Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FE35606A338
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O/Zi2n8T
Received: by kanga.kvack.org (Postfix)
	id C4D976B061C; Fri, 13 Nov 2026 05:29:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C25086B06A8; Fri, 13 Nov 2026 05:29:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14CC6B06A9; Fri, 13 Nov 2026 05:29:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A63C6B061C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:29:19 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F2AD11C3EF9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:29:18 +0000 (UTC)
X-FDA: 85429723596.25.BCC8E47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 37C4DA0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:29:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O/Zi2n8T";
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794565757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CT8U4Q29aGYjqSS4zWx9hqDxh+kziiY7Qkd0eclbYtA=;
	b=nVJUA3KF94N9G3MDDmlfqLRg9KbHj7/d1hJEa30lUI/X0//04rUjl/WcaAFnDAPuzlm9Sw
	WnLr124HUxCCAjnXQYqSNaTaQoprf+OV70IcIIA7NQilf6octyCogwvW/qbQ9IQyBeacD2
	FkrluuEAhW9G5pIaOJzwZPqizhZhbVc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794565757;
	b=v0Yv2IoNiBv/AIgLk1+VqC2RZ4lIR6+Uh0vujH8bNeApThrb8d3Ak05DcJJdQ3FPkQZZ2v
	sxPP6VSe6GF5EFyzV6CXo6XATibby8WY1jL0myaQd8TRA7mm9Ccpxo+XtzE56SWN6tWQqu
	66J7Gqm/dkvvRzJ+gTz+IkTVSg9/3u8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O/Zi2n8T";
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C5008625E7;
	Fri, 13 Nov 2026 10:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFF61F000C4;
	Fri, 13 Nov 2026 10:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794565756;
	bh=CT8U4Q29aGYjqSS4zWx9hqDxh+kziiY7Qkd0eclbYtA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O/Zi2n8TiGSKIRFWSXPmcu/nA+o63e1Qu3TtCwOU9Hz8fjczRGYx1alC76NyYox7x
	 OVrl3HxSMMSd4MlljdO2FBF4ZQnXp7ZYOUWk8ZO6iK5QfYjJDalbgdqWBpZqkvhprq
	 PI6mL/0kx/vd/G2CcTuhEdaUSsOR2myaZ3owYYvUcR3pBXDPERmQOQjSCyqKK1HXHa
	 HoHC7ndTnpDmoklThcEqYst8UJIHZqtm1hQyPD/RD/Apig/WZU61RmkEitksiogh3p
	 INLk2L6nz/b1elPkB8apW5Y3scOQIuR6Q8Su4KQOSPNLM9LS1/KIWCkPugzqDIXNay
	 GWYr20JEFHWBA==
Message-ID: <011cd94f-1789-4909-83f9-4007776f1b05@kernel.org>
Date: Fri, 13 Nov 2026 11:29:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/migrate: don't batch the TLB flush when there is
 nothing to batch
To: Zhiteng Qiu <qiuzhiteng@hygon.cn>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Alistair Popple <apopple@nvidia.com>,
 Xin Hao <xhao@linux.alibaba.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Yuan Zhong <zhongyuan@hygon.cn>, Shifei Ge <geshifei@hygon.cn>,
 Jianyong Wu <wujianyong@hygon.cn>, Shijie Huang <huangsj@hygon.cn>,
 Yibin Liu <liuyibin@hygon.cn>, Fengyu Wang <wangfengyu@hygon.cn>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261112010357.2739389-1-qiuzhiteng@hygon.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261112010357.2739389-1-qiuzhiteng@hygon.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 37C4DA0003
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: zrt3wq6wfyao8hgmemeg9ueoqezixhuz
X-Rspam-User: 
X-HE-Tag: 1794565757-246216
X-HE-Meta: U2FsdGVkX1/rV2Xi3Jzxmrj6Z4gqiSmBV8N7QbKUZ5xaNZkZmelQnQigFKebAmIkwU4p4ycleQ/V5goQsNT3Iv5LWDoSL02SmnY2L9Z16gYo5NUV9mKwunMaq/VuU+S2SYntHSzE4eKL9RYJTdflGYsUHUfFHZmJVYWpa0raBWx0xEB+pR59MZJTQ4WrQNZxH9Fp5eTCcxNMbUsr0B6JWwgfoHrBLObOpp4qM1Fh65i+vITQ27/7bmLr86Lvya46rEpF/BRVyNz1XKo7D0jxRShoDx39GnqcqUs6HyoRU4i2C2ZyMymIDLTXrwzdojXY5uEtuaXgIthEaoCI8JjPWq1h7kOL5IoGO8mhPLmVlfsHaMfDINN8V1hlIWKNULdZY8Y1BbCP3AjqlR4L6ZxU8HOPcs9WROjGxxNXoUxv7izbv0FHMfjSz5GbcIZBWfwdP+EHdusDCQmfGClndYXF56lHvOq4Cp8GxKEFH41y241ZnhSnGFnYxhnUuuOixVWGp/BaRe3SYS6HRd2qOLuFnrwvOkZCFUvn6kRnxWpz4LkOEfbc3UuoMcGA7v/8/9ZmroPTeWaqms6ALz+p6Xw6Xx5/Qeiv/29j6/0BCkJp6dS/KnRZWBr1S4u32FUi721tyU20Nz3en45+TSLelxDd7ewvI3H2dQoodZJ6oqr2lKHPJoIv/7pWavfu67K3KxmICRPBQWbCW6iefjZDSSrefA9oXeyKZR2/t4j0e33Yk6y5J56it8skvWaq2mPq1uZfKfEnq16v5vyoiKJpipLBZqaOau5zykUiU3Z+mU9kpCWRJldC0MEuqZuapdiyXWLcLHeU9Glb1MKoNC97Yl43oB5ch3NNl3BtpaCSZTbTJsY9KQ7o+LoH3+o8Fjx+MFndhxnXviFTTOw7TOhmnQqJ/O25wwdSkBe8KXN5Sm/roZbA9QBq+Z74RfoPYH0nUa/uYuJdKyxAlGQMwEy+CsC
 kN94jGkZ
 uj6twdQL/SRxWppFR+uS6vsjyDyuMwpnbEyH0z9Iu9u8ZlvzA4i6AZP6TnyxYIY3OjK5AbzCnw0VlXeM+tQpg8wF0C4CxYYggC3LMp9t1K3Zz0B/w7oiGVCq3ASlSmIRrAHY79GeEt7dXzKjmUq4DI0eeXBkV0SpJpgphCTFyZxUxXiVxqDjMUd7oudHOMsjvvueg9OVoMlqBzu2715hnRRl6cmlXD+yNP9dvmtULecLEMwgHKXyeMp3OKg6vSmENz26KiBJY4s8d6n5tqcQZRY+WbpYhPphtCsM6mtpPXNM4J5W45OF8OtFsyyQGX2v0NsBV8rAeea8RFsuCHPCKDIiMNBelpCgnqg7ck31rjMc64jU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 02:03, Zhiteng Qiu wrote:
> NUMA balancing migrates one folio at a time, but since commit
> 7e12beb8ca2a ("migrate_pages: batch flushing TLB") it still unmaps
> with TTU_BATCH_FLUSH like any other MIGRATE_ASYNC migration.  When the
> batch contains one small folio mapped only once, there is nothing to
> batch, and the batched unmap can leave mm->tlb_flush_batched pending,
> so the NUMA scanner's next change_pte_range() can call flush_tlb_mm()
> before changing the PTE table.  With migrations running concurrently,
> that state keeps being refilled, and on this workload the scanner
> often flushes the whole mm as it walks the PTE tables.
> 
> This slows scanning and keeps mm->tlb_flush_pending raised longer.  On
> x86, a migration that unmaps a PROT_NONE PTE while
> mm->tlb_flush_pending is set gets true from pte_accessible() and needs
> a flush too; with batching, the resulting arch_tlbbatch_flush() is a
> full flush.  The two feed each other.  In one run, 33% of the
> migrations overlapped a scan pass, although passes covered only 9% of
> the time.
> 
> On a 2-socket, 384-CPU x86 machine without INVLPGB, with v7.3, a
> 120 GiB anonymous working set on 4 KiB pages and 384 threads (three
> balancing on/off pairs per kernel):
> 
>                                      v7.3          patched
>   throughput loss from balancing     13.0-16.5%    0.5-6.3%
>   TLB interrupts per migrated page   202-210       12.7-13.6
>   average scanner mmu_gather time    ~90 ms        ~6.7 ms
> 
> The mmu_gather times were measured in separate instrumented runs.
> 
> So don't ask for a batched flush when the batch holds a single small
> folio that is not mapped shared; try_to_migrate_one() then uses
> ptep_clear_flush() for each PTE it encounters.  Large folios retain
> their existing flush behavior.  migrate_pages_batch() computes the
> flags, since it knows how many folios it is migrating.  PMD-mapped
> THPs are not affected, since set_pmd_migration_entry() flushes them
> regardless of TTU_BATCH_FLUSH.
> 
> Signed-off-by: Zhiteng Qiu <qiuzhiteng@hygon.cn>
> ---
> Changes in v4:
>  - Compute the try_to_migrate() flags in migrate_pages_batch() with a
>    helper and pass them to migrate_folio_unmap() instead of a bool, as
>    suggested by David.
>  - Go back to v2's check, limited to small folios, using
>    folio_maybe_mapped_shared() as Zi suggested.  folio_mapcount() would
>    stop being a good hint for large folios once try_to_unmap() batches
>    them better (David).
>  - Shorter comment (Zi).
> 
> Changes in v3:
>  - Use folio_mapcount() for the check, as Ying suggested.
>  - Cut the changelog down.
> 
> Changes in v2:
>  - Pass the try_to_migrate() flags directly and use single_folio in
>    the VM_WARN_ON_ONCE(), as suggested by Ying.
>  - Rewrote the changelog after looking into why b99a342d4f11 does not
>    avoid the flush here.
> 
> v3: https://lore.kernel.org/r/20261109122915.2150586-1-qiuzhiteng@hygon.cn
> v2: https://lore.kernel.org/r/20261107143456.1590658-1-qiuzhiteng@hygon.cn
> v1: https://lore.kernel.org/r/20261106041628.1177963-1-qiuzhiteng@hygon.cn
> 
> The table was measured on v7.3 with the same check as v4.  On mm-new
> with v4, three balancing on/off pairs gave a 1.9-2.9% loss and
> 13.2-14.6 TLB interrupts per migrated page.
> 
> I re-ran the tests on v4: mm/migration selftests 6/6, LTP move_pages
> and migrate_pages 14/14, 30 minutes with compaction forced every 30 s,
> and 4.5 hours of NUMA balancing racing with fork(), MADV_DONTNEED and
> move_pages(), 4 of them on a CONFIG_DEBUG_VM kernel, all without
> warnings.  Splitting partially mapped 2 MiB THPs during NUMA migration
> still gets the batched flush (0.115-0.120 TLB interrupts per migrated
> page), and 64 KiB mTHP and a MAP_SHARED mapping shared by two processes
> behave like base.
> 
> No Fixes: tag, as this is a performance trade-off that has been there
> since v6.3 and nobody has reported it as a regression.  Happy to add
> one if you think it should have one.
> 
>  mm/migrate.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index cb699ea59d33..8eb14b0a5d73 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1218,11 +1218,28 @@ static void migrate_folio_done(struct folio *src,
>  		folio_put(src);
>  }
>  
> +/*
> + * Batching the TLB flush only helps when the rmap walk can clear more than
> + * one PTE.  A single small folio mapped once has nothing to batch, and the
> + * batched unmap would leave mm->tlb_flush_batched pending.
> + */

These comments belongs split up into the function above the relevant checks.

> +static enum ttu_flags migrate_ttu_flags(struct folio *folio,
> +					enum migrate_mode mode,
> +					bool single_folio)

Just pass the from list, please and check for ; internally.

Also, use two-tab indent here.

Further, i would suggest calling this

	folio_migrate_ttu_flags


> +{
> +	if (mode != MIGRATE_ASYNC)
> +		return 0;
> +	if (single_folio && !folio_test_large(folio) &&
> +	    !folio_maybe_mapped_shared(folio))
> +		return 0;

/* Helpful comment. */
if (!list_is_singular(from))
	return TTU_BATCH_FLUSH;
/* Helpful comment. */
if (folio_test_large(folio))
	return TTU_BATCH_FLUSH;
/* Helpful comment. */
if (folio_maybe_mapped_shared(folio))
	return TTU_BATCH_FLUSH;
return 0;

> +	return TTU_BATCH_FLUSH;
> +}
> +
>  /* Obtain the lock on page, remove all ptes. */
>  static int migrate_folio_unmap(new_folio_t get_new_folio,
>  		free_folio_t put_new_folio, unsigned long private,
>  		struct folio *src, struct folio **dstp, enum migrate_mode mode,
> -		struct list_head *ret)
> +		enum ttu_flags ttu, struct list_head *ret)
>  {
>  	struct folio *dst;
>  	int rc = -EAGAIN;
> @@ -1344,7 +1361,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>  		/* Establish migration ptes */
>  		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
>  			       !folio_test_ksm(src) && !anon_vma, src);
> -		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
> +		try_to_migrate(src, ttu);
>  		old_folio_state |= FOLIO_WAS_MAPPED;
>  	}
>  
> @@ -1835,9 +1852,11 @@ static int migrate_pages_batch(struct list_head *from,
>  	LIST_HEAD(unmap_folios);
>  	LIST_HEAD(dst_folios);
>  	bool nosplit = (reason == MR_NUMA_MISPLACED);
> +	bool single_folio = list_is_singular(from);
> +	enum ttu_flags ttu;
>  
>  	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
> -			!list_empty(from) && !list_is_singular(from));
> +			!list_empty(from) && !single_folio);
>  
>  	for (pass = 0; pass < nr_pass && retry; pass++) {
>  		retry = 0;
> @@ -1924,8 +1943,10 @@ static int migrate_pages_batch(struct list_head *from,
>  				continue;
>  			}
>  
> +			ttu = migrate_ttu_flags(folio, mode, single_folio);
>  			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
> -					private, folio, &dst, mode, ret_folios);
> +					private, folio, &dst, mode, ttu,
> +					ret_folios);

While at it, might as well fixup the indentation.



-- 
Cheers,

David

