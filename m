Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC410606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fme3Kdwb
Received: by kanga.kvack.org (Postfix)
	id C212D6B05B0; Mon, 23 Nov 2026 14:55:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD1846B05B1; Mon, 23 Nov 2026 14:55:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0F146B05B4; Mon, 23 Nov 2026 14:55:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 880F86B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:55:05 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A66D1A099B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:55:04 +0000 (UTC)
X-FDA: 85467437328.29.774CF62
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B646F180006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:55:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fme3Kdwb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795463702;
	b=OH0rdPFPGCHqU/DqearnZNdLWbD3xmZLohCjx3N/2Q1ILSF5lT7IF06J/UY262N9pdQZUo
	Rg6MAihNeXb5N+GoQXCegEsgTzweZcMOEAeBgAjHYfltNSQXXjI4Ty2ETSXh2mjtzL5Sx7
	4RaSD608IiLA3AdGJ1v9tMn+ZBBGBCE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795463702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5xkBqtOz/cxSYio3ZQFvWPZV907+8EypMB85HFz3iM=;
	b=hcqXdKzvzRpQ4SIXRukn8YCCVMgDmJmyP2F7rpDO4ALcC7/Mp6ZqGtei8GhFqbmNJKnhR7
	YxxMKyGyqjqYPRrCP8CcM7u1L03gV0LABj2MbkqDX4Ewiltt19J3CpnMe0pdpsYPKeppMj
	ewJuppG66hcwEGrc8vinFXo7ax1uevI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fme3Kdwb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB602406BA;
	Mon, 23 Nov 2026 19:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9681F000CF;
	Mon, 23 Nov 2026 19:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795463701;
	bh=b5xkBqtOz/cxSYio3ZQFvWPZV907+8EypMB85HFz3iM=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Fme3Kdwb7X9HKaSgS+tsMCzmvD6INAAinoHdB/9i0GwoDs+wAXAYOx4tdn8N9UumG
	 UbDEJGtnucVzivH4BB9Cf2sRXCnDcsIeEMSFiDWXqkv2Z9hu+mbZevKMOp8KC9k1fd
	 5p69kp3Xb9NzBE2f5lEI+OQn8Grh1ysEMoG9GljgeTUzKZkwoOOPTfrYCxrtwjsxHU
	 6f4IO7jhFHat9GvLp4EDpEp6ENj1GEN7bwctGQA4ZLrdfCD0eetKk7kCT4BEP4mpm3
	 FLCYSyf6wQMq6IgiAGTwkOUzXvDnHcAwkz5lZQzsn8N6hP92ldF/tXT7bgjOQ1chNj
	 TSIWaVj+tsQqg==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] mm/memfd_luo: don't use memfd_pin_folios()
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261123130115.4021199-1-pratyush@kernel.org>
References: <20261123130115.4021199-1-pratyush@kernel.org>
Date: Mon, 23 Nov 2026 21:54:56 +0200
Message-Id: <179546369651.425130.14155931836758567682.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 9fr9kex974imgr1tp915q6duu4opqxif
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B646F180006
X-Rspam-User:
X-HE-Tag: 1795463702-606304
X-HE-Meta: U2FsdGVkX18ftLwqeRRoyAU9Ai6n6WwEQZGTVOXUlDyleDhGQ6oOtv3nexMESkanz1uIE1pu/ADFBA7N/+OUm9GKkE9ruK4CrSJgRXduxoj/oUqZRv+cXck6Lg21nKNpWyNf0UqyTF3x67i25a2tRZV+dtZDaSholAHVhM5PaYN3bOfNmN3WDY9Hh+4BZlTfDfBYh03vzx+bI4kAKuJPBsz00b8gNzeJmOQOF6WDWzEzz/uM7JR8YiNCdMpdhm4rWQ681lL0iYB4W6ubusjd+HhxyuG+Sml3MzCLH+Cq8XROCHr9m0kZZGQ0qhg1EIjwt3PHs5hcy3X82dKyvN2yvFBDdX93zb2qyMv6talTN/vxFkfRAcK/Q7yIA7qa+vMtTgyRlCaixX2j3cRiuZTappZbQSkg0PKrMaKK8D2tHstQ2+debaEnTE/phNiuT3gbbjuArB7BkUG9aOBdOHYAqE8pcY+b8QOba2QacIND8Cr5xejVmd4neuTaBCjXKwWBdqkFR/xNGdZAY8CC7QMpw1cv3Qn5YiH7RpU2fVefJifMo/U67KbxBJhcx4YazTDvU1kHJ0YEar7JK2wVJdvAPWpHA4pV9Kg81Da4HwQVqLMmp59KhJyiYZWxlYc0odTs/YNXAQ4NNUPPe3Hnl6rrftYfL6OYlGPYf+tfyQGnHw7RhfG7RMQ8jkYI109qg8+xMnJFQXmblUCEd+7HxAMXG1Fk7DkBaXozUX9Z9nMOxVSGXEogMyMfuERLuFwh8Gi0OctdAFEPdWmTR/ZRC4b4ojR50WmyaVNMouPnV/zy38aZWVbzI/Z4yr6TqvVZ1HubDfqRBTVbY3IdEBDqyFMoqq5tzf8qTeXeJGpsqB2M0d/+QVHbZb5j9/prTypXc39sJk6NHIjGSU+dMrkWrsGvLugCRBWwc/JVFQipryr5i2UBcMwYPZBWSNoNuLhRkG8xGPXShSl8eCz2W5lY13J
 WOq2+84g
 3qEUFN8ughHgCvzez01U1Y6hZtmJLFP1og7CIo9YrV03OSa096yfjQGj7+PlsZfmRL2I71FAI7I8vw22OE4eVT5kXezR8R4gahHthCVqeVXC6OZGBxoWmGNCGZCGul89D7zvgAPwGSXj/m+psTIBpSkaNzoNSfRG+cQuFQ0s2NTtvaCVwXe+X8Ar6jL++gSuGQHDitchc/pQlFNC62ZJfS5tOglr7HVDxyGdKauHz/bd4l0Dqa9Rl6qvZe85vo2f5IwhNO0evEEZaUGdy6CDBNNhhtmOT3HfMTYvc1vZV0irGbTx60Ctx8Ue8yYYSWF1VSBoEY/nVvtzQR70Mlmg5GyHCGHDgFa+ppM8GUeA9cInYPBXKwsuB2cInvJA5XLj5bSJq8QeamZRRoGcezremy42TNvTwrNvMADfMcdS7/c7vT3Ls4U0LSWSeuVhOQ9Y6c8gNuAEKMBJRAwnUcDqb/+AOyIx5iUrjLzFIRW7tVGEdSSL/alfqNgmJm84F3UhyDKobn1eOMUi4Vqlcy0Oz4X1QN1+ft2SJ3rz0QeLVH7GUG25mHF7gsIc6LgS2d6T4nwEP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

> memfd_luo takes a snapshot of the folios in the file's mapping. To make
> sure the snapshot does not go out of sync, it pins the folios in the
> file via memfd_pin_folios(). The pinning also migrates the folios out of
> MIGRATE_MOVABLE to make sure doesn't land in KHO boot memory or in a CMA
> region.
> 
> memfd_pin_folios() does not lock the folios. So it can race with
> shmem_writeout(). A folio returned by memfd_pin_folios() might already
> be in swap cache. This happens to work but is fragile. memfd_luo looks
> at folio flags and index on a folio that isn't in the memfd's page
> cache.
> 
> In addition, memfd_pin_folios() needs the caller to allocate an array of
> folios. memfd_luo does not really need that since it will vmalloc
> folios_ser and store the information there anyway. The folios array is
> unnecessary overhead.
> 
> Finally, memfd_pin_folios() fills in holes in the memfd. This makes
> preserving sparse memfds very expensive in both compute and memory.
> While this patch doesn't yet stop filling in the holes, it sets up the
> infrastructure to make it simpler.
> 
> Fix all this by walking the page cache directly using shmem_get_folio()
> with SGP_CACHE. This returns a locked folio with an elevated refcount.
> memfd_luo holds that reference until the memfd is unpreserved. This
> blocks compaction, migration, etc.
> 
> There is still a need to migrate folios out of MIGRATE_MOVABLE page
> blocks. This is because those might be CMA or KHO scratch. memfd_luo
> will hold a longterm reference to the folios so it will block migration
> in that pageblock. Introduce memfd_luo_migrate_folio() to do this.
> 
> Also factor out folio unpreservation logic into memfd_luo_put_folios()
> and use it from memfd_luo_unpreserve_folios() and from error paths in
> memfd_luo_preserve_folios().
> 
> Since shmem_get_folio() always returns uptodate folios, drop the folio
> zeroing logic.
> 
> This change also improves preservation performance, shown in the table
> below.
> 
> |------------------+----------+------------+-------|
> | memfd            | baseline | this patch | delta |
> |------------------+----------+------------+-------|
> | 4K pages, 32 GiB | 748 ms   | 600 ms     |  -20% |
> | THP, 4 GiB       | 0.59 ms  | 0.59 ms    |    0% |
> | THP, 16 GiB      | 2.99 ms  | 2.61 ms    |  -13% |
> | THP, 32 GiB      | 4.83 ms  | 5.21 ms    |   +8% |
> | sparse, 32 GiB   | 8695 ms  | 7269 ms    |  -16% |
> |------------------+----------+------------+-------|
> 
> Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
> The diff is unfortunately hard to read. It would be easier to review the
> patch by applying it and looking at the final code.
> 
> This patch is picked from a separate series I sent [0]. It is more or
> less an independent change. It fixed a race for that series so I added
> it there, but since that series might take longer to go through, I think
> it is useful to take this patch separately.
> 
> [0] https://lore.kernel.org/all/20261027173031.763213-2-pratyush@kernel.org/
> 
> Changes since v2:
> 
> - Reword the comments on memfd_luo_migrate_folio(), memfd_luo_get_folio()
>   and the allocation comment in memfd_luo_preserve_folios() so they no
>   longer say folios are "held until the next kernel". Instead, say that
>   preservation holds a longterm reference on them.
> - Use a bounded for loop in memfd_luo_get_folio() instead of an open
>   ended one with a separate busy retry counter.
> - Collect tags.
> 
> Changes since v1:
> 
> - Add memfd_luo_get_folio() which combines shmem_get_folio() and the
>   migration logic.
> - Collect tags.
> - Rebase to v7.4-rc1.
> 
> ---
>  mm/memfd_luo.c | 306 ++++++++++++++++++++++++++++++-------------------
>  1 file changed, 190 insertions(+), 116 deletions(-)
>
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 6b68220275ebe..c963bc3522e61 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -77,26 +77,161 @@
>  #include <linux/kexec_handover.h>
>  #include <linux/kho/abi/memfd.h>
>  #include <linux/liveupdate.h>
> +#include <linux/migrate.h>
> +#include <linux/sched/mm.h>
> +#include <linux/sched/signal.h>
>  #include <linux/shmem_fs.h>
> +#include <linux/swap.h>
>  #include <linux/vmalloc.h>
>  #include <linux/memfd.h>
>  #include <uapi/linux/memfd.h>
>  
>  #include "internal.h"
>  
> +static void memfd_luo_put_folios(const struct memfd_luo_folio_ser *folios_ser,
> +				 u64 nr_folios)
> +{
> +	u64 i;
> +
> +	for (i = 0; i < nr_folios; i++) {
> +		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
> +		struct folio *folio;
> +
> +		if (!pfolio->pfn)
> +			continue;
> +
> +		folio = pfn_folio(pfolio->pfn);
> +
> +		kho_unpreserve_folio(folio);
> +		folio_put(folio);
> +	}
> +}
> +
> +/* How many times to try migrating a folio that is not longterm pinnable. */
> +#define MEMFD_LUO_MIGRATE_RETRIES	3
> +
> +/*
> + * Preservation holds a longterm reference on the folio. This would block
> + * migration in ZONE_MOVABLE or CMA. Move it out.
> + *
> + * Must be called with folio unlocked. Drops the reference to folio. The caller
> + * must look it up again.
> + *
> + * Returns 0 on success, -EBUSY if the folio could not be isolated (e.g.
> + * because someone else has it isolated right now), or -ENOMEM if migration
> + * failed.
> + */
> +static int memfd_luo_migrate_folio(struct folio *folio)
> +{
> +	struct migration_target_control mtc = {
> +		.nid = NUMA_NO_NODE,
> +		/* Not movable, so the target is neither in ZONE_MOVABLE nor CMA. */
> +		.gfp_mask = GFP_USER | __GFP_NOWARN,
> +		.reason = MR_LONGTERM_PIN,
> +	};
> +	LIST_HEAD(source);
> +	bool isolated;
> +
> +	/* Flush per-CPU LRU batches holding the folio so isolation works. */
> +	lru_cache_drain_for_folio(folio, 1, NULL);
> +	isolated = isolate_folio_to_list(folio, &source);
> +	/* Isolation holds its own reference. */
> +	folio_put(folio);
> +	if (!isolated)
> +		return -EBUSY;
> +
> +	if (migrate_pages(&source, alloc_migration_target, NULL,
> +			  (unsigned long)&mtc, MIGRATE_SYNC, MR_LONGTERM_PIN,
> +			  NULL)) {
> +		putback_movable_pages(&source);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Look up the folio at @index, allocating it if needed. Preservation holds a
> + * longterm reference on the folio, so folios that are not longterm pinnable are
> + * migrated out first, retrying a few times if someone else has them isolated.
> + *
> + * On success, returns 0 with *@foliop locked and holding a reference.
> + */
> +static int memfd_luo_get_folio(struct inode *inode, pgoff_t index,
> +			       struct folio **foliop)
> +{
> +	struct folio *folio;
> +	int err, retry;
> +
> +	for (retry = 0; retry < MEMFD_LUO_MIGRATE_RETRIES; retry++) {
> +		err = shmem_get_folio(inode, index, 0, &folio, SGP_CACHE);
> +		if (err)
> +			return err;
> +
> +		if (likely(folio_is_longterm_pinnable(folio))) {
> +			*foliop = folio;
> +			return 0;
> +		}
> +
> +		folio_unlock(folio);
> +		err = memfd_luo_migrate_folio(folio);
> +		/* Someone else might have it isolated, retry a bit. */
> +		if (err && err != -EBUSY)
> +			return err;
> +	}
> +
> +	return -EBUSY;

In v2 we did another shmem_get_folio() after a successfull migration,
now even if the last iteration migrates successfully we still return
-EBUSY and don't update *foloip.

-- 
Sincerely yours,
Mike.


