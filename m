Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3710B606A32C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZO+bMQM2
Received: by kanga.kvack.org (Postfix)
	id 45B4A6B05B4; Wed,  4 Nov 2026 12:09:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40AA56B05B5; Wed,  4 Nov 2026 12:09:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3A46B05B7; Wed,  4 Nov 2026 12:09:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ECF996B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:09:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 712C7A0258
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:09:27 +0000 (UTC)
X-FDA: 85398072774.15.E3FC7AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id DBFAC2000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:09:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZO+bMQM2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793812165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rKSitA4GhO3iXo6/sM1DqbwM0oZP8831TgqTTx7U8Yw=;
	b=fMvz13KbxFA6YMl6W3ReEzpTZy7G2WYJuANct0w/yrWEJ3yveAPbYWKb77jMCppKDs/ZJv
	L5KXfN2ubHcQ94w5qDVqyK0Rk/iR7uhHu5HbuEGMweKKiL0UgAdDp4lo3tCR1EPqc614Sl
	dBb3vO46W8JAOz3GabC+SJ+ZY9pcis8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793812165;
	b=JUTSPKd6LimqdNfsQHlga6FQQp72S/MEl/VVDVb1mMcVjIfag1EnZ178Ae3rvhb1fOxPJV
	0aCQmNA8hNCyOvqCpFjLKKTfyF3+GqQTIc0advNxCSIAG/q5hJtN/mowNFeTtrdIdW5/8w
	33YJbYMZlXO7pVkczFj6iSfRApvy94I=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZO+bMQM2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D785441452;
	Wed,  4 Nov 2026 17:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9DF1F000C1;
	Wed,  4 Nov 2026 17:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793812164;
	bh=rKSitA4GhO3iXo6/sM1DqbwM0oZP8831TgqTTx7U8Yw=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=ZO+bMQM2HPlq92f7QNDpBuxeZ+BfI0Cg9C4IcKYdsvwAtqDeicKjU0j+Ex7z2Ug2h
	 iAcK43Oug7C/9Yhilc8KJ6DqyN0QyOdXsYtzGLcUyj4e9vkx2b/rsY1gr6+ksOMcx7
	 R2ije2b9dYDCOqNznuUrfA0mjC5b0j5tjyS2Gg3D+DFZKV3ToMsR9Jo36cIJ/j3Vn0
	 y3OAx6kwWKkr3as4pmXDWQTz+E6TfSb3Zu7/Um8YRfxPPXR0sQgQgnZDBiqzZwlSVX
	 AIbFqs9vx5gIwa2J4XAesfziIs2wiZPh6lNYEmv2NcW20tLhNcdqYtNcp0BLbyJELh
	 zBZ8xrMULVd8Q==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] mm/memfd_luo: don't use memfd_pin_folios()
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261103172251.2348370-1-pratyush@kernel.org>
References: <20261103172251.2348370-1-pratyush@kernel.org>
Date: Wed, 04 Nov 2026 19:09:19 +0200
Message-Id: <179381215936.28814.9050829645096838793.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: swkgqnooedy8fg5wp1i61ufwoqw9ckbe
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DBFAC2000A
X-HE-Tag: 1793812166-851977
X-HE-Meta: U2FsdGVkX194+PDotC2SdoeJHgVnh9kiLm67ypxhtVN8fKEnIW9Ptha1O3IcqFQ9R9nl8WSmfPqdv1Y8Oz+todAUbNtphviEEaTg+/OQt5dV77hZg/2nWeAl8jrCszYHpHGBgofWI1V15qLgoBWx0pESN3sz3BKu8Rj3vHaDqjjQ+jA5vPVJU2vJK7AbUWWXctVd6UnSg8FF4WYElTI0fJeMBcAHZMtD0yeYS//ctIDv5AYhjptWW5WVQA2DrOFFzIgEz2+ZssxUb4vUpu3VrxyUIPSSZ79l3K8q3V7drzOG8c6lPmOLlEyuBSOMtB+E0zPqM+HQ6K6v5DBkKA7AA4OMobDmGiTG4MnauAC8bvO8UIHXVdGzyDaEy1H9td4XYjnEfoxoLm9HOg8nnt27BiYmVehHFGt898B4kF+aGOPQfPCJ4GxojcXUSyCANvf1qlBMNSqePwaCT4jscH6rPKvi6gth7F8HjijJzQpBzWcNMKLElXkg3fPsMZVWqEEsBCcwcPAtMMELufbCJ6pWFe7oNwiQjRldl57kOWAQ0bYBqfVgBPwyVn3Vs29Ua/p7W9xYk3kglBvZ25NU4MlIE0gen68RRyrf0AY0THKLoHbf+newuUa4UDJRNwPfoAscX6gsmsT1L+QsasYOOPVvySiiTaFFvhPS+HzlVRQ09c9KzDnJ5xnxIDsiVfnOsJ3qforoQSN0KYR4JhSTCArKjhrNHBm7iZpYvyJhZWs01313ztgmS2UGunAP3VmXQn4lMAsvmhw31XvLyh084HBxQ8N7DswCxo0mflH39S5FYRj5Vl+ysnoLZmM/90Gc16HjjEQDSI+TfBsZXOYXZ8JuUdM0xZb5V8s3zSg4aBm6v2AwTZ8+NTvm5lxcvjG/hBMSzJvgwLWxzyFPh969BYXM2dsL0nzur9kVtCjLrnmD4+fP8xY8mVcUNjfg8udXO6NI88ZbKnzWUxy1/rzNL/n
 bSReLznn
 /1s/5W1FNkRV70mU/xvXKCw8UJwcqhebsvJdejaEZ1lzJCFSMs9V8nVVgICNPV5Ea2f+aDk1L7+i9WFVH547jhQVrjJsEQv82mgl0zwiC7CGAY1JZOtObluTJcNounspL1NsXbwMOxDd1IhQvC9ohcMTv0JV39PvD2MZwDE5bMf9LjirzjHiKe19cOqbpr0YMEwK50AZCVibkgcRMkGUob+OTtKFCHRFp1TE7Z0Ngpoow3JgXDJxnp4wK6OGBVAxsMt3oDyoit3B6BGp9ruPBAmLfUkW+P0tZNNQWmaRvcu8ixb67fHb8dnWzRLsVRHJMDvlsmVWCl7IQ9OHHAhanYB8qwWQU0g8MSWB/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

With a few nits below

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> +/*
> + * Move a folio out of ZONE_MOVABLE or CMA, so it can be held until the next

"held until next kernel" - here and below - I feel that something is off
here, but can't pinpoint what exactly.

> + * kernel. Called with a reference on the unlocked folio, which is always
> + * dropped. The caller must look up the folio again afterwards.

I'm having hard time parsing "called with a reference" sentence :)

> +/*
> + * Look up the folio at @index, allocating it if needed, and make sure it can be
> + * held until the next kernel. Folios that are not longterm pinnable are migrated
> + * out first, retrying a few times if someone else has them isolated.
> + *
> + * On success, returns 0 with *@foliop locked and holding a reference.
> + */
> +static int memfd_luo_get_folio(struct inode *inode, pgoff_t index,
> +			       struct folio **foliop)
> +{
> +	int err, busy_retries = 0;
> +	struct folio *folio;
> +
> +	for (;;) {

Won't
	for (retry = 0; retry < MEMFD_LUO_MIGRATE_RETRIES; retry++) {

look better and the body simpler?

> +		err = shmem_get_folio(inode, index, 0, &folio, SGP_CACHE);
> +		if (err)
> +			return err;
> +
> +		if (likely(folio_is_longterm_pinnable(folio)))
> +			break;
> +
> +		folio_unlock(folio);
> +		err = memfd_luo_migrate_folio(folio);
> +		/* Someone else might have it isolated, retry a bit. */
> +		if (err == -EBUSY && ++busy_retries < MEMFD_LUO_MIGRATE_RETRIES)
> +			continue;
> +		if (err)
> +			return err;
> +	}
> +
> +	*foliop = folio;
> +	return 0;
> +}

.

-- 
Sincerely yours,
Mike.


