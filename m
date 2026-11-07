Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F75E606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 12:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=hDsdHThG
Received: by kanga.kvack.org (Postfix)
	id A26F46B05B1; Sat,  7 Nov 2026 07:26:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DCC26B05B2; Sat,  7 Nov 2026 07:26:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EB1F6B05B3; Sat,  7 Nov 2026 07:26:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 650DC6B05B1
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:26:15 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0535F1C22C9
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 12:26:15 +0000 (UTC)
X-FDA: 85408245510.10.1E54D7E
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf30.hostedemail.com (Postfix) with ESMTP id 395DA80005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 12:26:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hDsdHThG;
	spf=pass (imf30.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794054373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u5ZJ/wlGvJUQePH7rwc/09MLnxEpQRsgWYMeOcnU8Wo=;
	b=ot9Hl5RWwh1UGhU4+tB/mAQMXVgr2FCpvTJP1HNvMhd3uXMaiXaKDT/eI1DVcVD1FNKdH8
	qIOdYZmECWKUjjhLXi9Qml+q7eQCNulhlKntSza9wrvakl//Q+z/79W/l1ZZpChjqKlfOl
	ernDZpWhrj2mauNrGxlYZr8bMT2gntA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794054373;
	b=MZ0TfHsQLCrhFN0f/EUoQmAWrOwx0qlS/PLTg9cLKx+KAPwiNZr4Nf191pzeHAEBw61V/k
	j/vr7ffrc3nntz17IE1mgvlsyAxDioLM/gnonR0Um0u4UyJmkgCEpQABEFL0qSVuu4VKQ4
	i6gQD+FCE9bOWhCASEIORC4aE+pObwQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hDsdHThG;
	spf=pass (imf30.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794054369; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=u5ZJ/wlGvJUQePH7rwc/09MLnxEpQRsgWYMeOcnU8Wo=;
	b=hDsdHThGYhpQUmDyysRKkvABoXo798iqubf/nJ15zBFktWcqhQqLFBBZHh4xA7GTa4Fg5WuFvyp0EBsU4rEcUMC7t8w6k1QiH7N6SK1gOK2Ni8FXs9hE0cKF7q0rvkzzTCHdTlYD2ufMdbPfuFcL9UKo6Nq6bbkdeWnBkuFfLGU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0XEESKRq_1794054367;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0XEESKRq_1794054367 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 07 Nov 2026 20:26:08 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Zhiteng Qiu <qiuzhiteng@hygon.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
 <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,
  Byungchul Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,
  Alistair Popple <apopple@nvidia.com>,  Xin Hao <xhao@linux.alibaba.com>,
  Dave Hansen <dave.hansen@linux.intel.com>,  <linux-mm@kvack.org>,
  <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/migrate: don't batch the TLB flush when there is
 nothing to batch
In-Reply-To: <20261106041628.1177963-1-qiuzhiteng@hygon.cn> (Zhiteng Qiu's
	message of "Fri, 6 Nov 2026 12:16:28 +0800")
References: <20261106041628.1177963-1-qiuzhiteng@hygon.cn>
Date: Sat, 07 Nov 2026 20:26:07 +0800
Message-ID: <87h5hsx1y8.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: piy68kwohp4p3hd7oianx4sdcfb9tdxo
X-Rspamd-Queue-Id: 395DA80005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794054371-852931
X-HE-Meta: U2FsdGVkX1+ueHPeQ2vht/i5PKq16FpHRU+ZqyeIMXQHlUAMg3A8nTHe9K0nVzQ98onkHQeq8VJLDn6HFDA//Q113VGbU6vmS9KznDZa2GLRwWbOhoTIx9ixLweMZ9iGINbd9Q/E2U5ITjqw1EGupYxOtG+A13wlgsFcRh3yc6pcJpaCPfv7nqNr7fbu4tvunS3PxqFi1vEk3fJJqVU0xKGpFycEe474LMhDTpVoXo+7r7Xc9gPFBIGlEec+Ivr0yt0HMQLTNLyPaY/2mABU9T6dpPS7VwYtkyR9MmbxKGWE+VIDBv+uiGdFjhLgBiyf61GzFMftyAkLri5NiyIUs+0vkxxlAZqVD/SXteGHCDYQ1MyRg01UQtUAfhDKty+A5b4dAICQ0mL3P2IukE41gqp7n6yrCzYfY7vAJ1y3KwdAjDeb+Ym+oqkc3h/N03J2Q3nKozJRQOXduZUAdCFVAN2Go2jiunlKM881wZRMyZyA8O5kdQdU0yJ5nekgZiogT7VYp/MoptVtSvyaeLKuJGGOb4XILd1gvXnBzZKyUHxaRlvYYdSoZx9O0cqkGe9ysR8WiEAFhzLZNuvuMyP0iFY3uOwLMqYN/4HQ5ZLJUgO3LzYk3uZHkk5sY+AI7JdA1Mysk7D+80kRTbLV+pWWL7j8hXJo/hhFQqi9IvuBYWHUkuVmJ/Hc+37/kMpxrGUvRQz4q4z60kMt5syWzaCp1DbQtv68Lp+r0P1k5vIJAsnjqNZ9KenxaawX02qERlR24QpRSRMTKJZMyPneDzml25H/kN+/xse3ExEAM0nVOtb39L5bKZq5wgaEZvEi+Em5m8Qimq1Mq9+TZbfwNj6Usf490knIZQ6Ew65VKz6djNHB+7vk0I8c2d+ICiHAN80fVABpECAzr4wyZClkN4F8NyhYSopHywRVA9MJMMyk0jii0WWzwFAP0xFNtasNwc4JeBzTfgLAINjzQBvh2gg
 l8/aHmAA
 3/cWvtmcojIgXZs0KAsdI/0r50fSeWkTKY7Y6k4urBrQZpOZfz5ys1Nkkeq1bk3WjUpU9uf89Yi/MkzU5QSmYZwg+aFSN1hhKJLgafvwQRoEAwhGvq+sJw4c/bvgJpsTnK7fcX+11IVLTDD43I8BvOhQqYatqvGSIEyLRCDkJ0prp9RaqionZRICGAH8yx0j1tegT2+8HukCNAv9jJSN9Xncu1WOLETdbIWyRnkml0ohiqVZhjy6bPrUUE1AUexPF+pooMjtx+igBhl7Bnl5IERoedjIDig4ecw93UJenxEHQhGZrXtuqfchk6nv/S0tRMICerRMGWni55BcIqThMvtQdvE0GuFL4xta3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Zhiteng Qiu <qiuzhiteng@hygon.cn> writes:

> Since commit 7e12beb8ca2a ("migrate_pages: batch flushing TLB"), every
> MIGRATE_ASYNC migration unmaps with TTU_BATCH_FLUSH.  That includes NUMA
> balancing and memory-tiering promotion, which migrate one folio per call
> through migrate_misplaced_folio().  For an order-0 folio with a single
> mapping the batch holds one PTE and there is nothing to merge, but the
> flush still changes: on x86, arch_tlbbatch_flush() sends a full TLB
> flush to every CPU in mm_cpumask() instead of invalidating that one page.
>
> On a 2-socket, 384-CPU x86 server without INVLPGB, a 4 KiB-page,
> memory-heavy multithreaded workload takes about 200 TLB shootdown
> interrupts per page migrated by NUMA balancing (v5.15 on the same machine
> takes about 11), and balancing costs it 13-16% of its throughput.
>
> Skip the batched flush only when the batch cannot merge anything: the
> folio is the only one in this migrate_pages_batch() call, it is not a
> large folio, and it is mapped only once.  The rmap walk then meets at
> most one PTE, and ptep_clear_flush() invalidates just that page.
> Everything else keeps the batched flush, including PTE-mapped large
> folios, folios mapped more than once, and the batch of sub-folios
> produced when a partially mapped large folio is split during migration.
>
> PMD-mapped THPs already invalidate their mappings through
> set_pmd_migration_entry(), independently of TTU_BATCH_FLUSH, so their
> flush behaviour is unchanged.  On arm64 the batched path only defers the
> final DSB, so a one-PTE batch should cost about the same either way.
>
> migrate_folio_unmap() cannot see how many folios its caller is
> migrating, so migrate_pages_batch() passes that down.
>
> Measured on v7.3: 120 GiB anonymous working set, 384 threads, 180 s per
> run, three A/B pairs (numa_balancing on vs. off, same boot) per kernel.
>
>                                     v7.3            patched
>   throughput loss from balancing   13.0-16.5%      0.5-6.3%
>   kernel cycles per hinting PTE    1.18-1.22M      0.28-0.31M
>   TLB interrupts / migrated page   202-210         12.7-13.6
>
> Signed-off-by: Zhiteng Qiu <qiuzhiteng@hygon.cn>
> ---
> Notes:
>
> An earlier version decided on reason == MR_NUMA_MISPLACED.  That also
> dropped batching for the split sub-folio batch mentioned above.  In a
> test that splits partially mapped 2 MiB THPs during NUMA migration, the
> earlier version raised TLB interrupts per migrated page from 0.13 to
> 16.1; this version keeps them at 0.11.  For 64 KiB mTHP and for a
> MAP_SHARED mapping used by two processes, this version behaves like the
> base kernel (TLB interrupts per migrated page: mTHP 2.2-2.7 patched vs.
> 2.6-3.3 base; shared 31.3-31.5 vs. 31.2-31.7).
>
> The earlier version behaves the same as this one for order-0, private,
> single-mapped memory.  These results were measured with it:
>  - 192 CPUs (SMT off, 192 threads, 4 pairs): balancing loss
>    3.1-14.7% patched vs. 7.4-54.3% base.
>  - Memory first-touched on the remote socket, threads on the local
>    socket (6 runs per kernel): no regression in time to convergence or
>    in throughput after convergence.
>  - 2 MiB THP (2 pairs): no difference, as expected for PMD-mapped
>    folios.
>  - A 30-minute run with compaction forced every 30 s: no warnings.
>
> With this version, tools/testing/selftests/mm/migration passes 6/6
> (including the THP and hugetlb cases), the LTP move_pages and
> migrate_pages cases pass 14/14, and the scenario tests above saw no data
> mismatches.
>
> There is no Fixes: tag.  This changes a performance trade-off in code
> that has been there since v6.4, and nobody has reported it as a
> regression.  Please add one if you see it that way.
> ---
>  mm/migrate.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 953af633ec..0f3404c3d7 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1222,7 +1222,7 @@ static void migrate_folio_done(struct folio *src,
>  static int migrate_folio_unmap(new_folio_t get_new_folio,
>  		free_folio_t put_new_folio, unsigned long private,
>  		struct folio *src, struct folio **dstp, enum migrate_mode mode,
> -		struct list_head *ret)
> +		bool single_folio, struct list_head *ret)
>  {
>  	struct folio *dst;
>  	int rc = -EAGAIN;
> @@ -1344,7 +1344,18 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>  		/* Establish migration ptes */
>  		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
>  			       !folio_test_ksm(src) && !anon_vma, src);
> -		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
> +		/*
> +		 * Batching only pays off when the rmap walk can meet more than
> +		 * one PTE.  A lone order-0 folio with a single mapping has
> +		 * exactly one, and on x86 the batched flush turns that one-page
> +		 * invalidation into a full flush of mm_cpumask().
> +		 */
> +		bool batch_flush = mode == MIGRATE_ASYNC;

Better to set try_to_migrate() flags directly?

> +
> +		if (single_folio && !folio_test_large(src) &&
> +		    !folio_maybe_mapped_shared(src))
> +			batch_flush = false;
> +		try_to_migrate(src, batch_flush ? TTU_BATCH_FLUSH : 0);
>  		old_folio_state |= FOLIO_WAS_MAPPED;
>  	}
>  
> @@ -1835,6 +1846,7 @@ static int migrate_pages_batch(struct list_head *from,
>  	LIST_HEAD(unmap_folios);
>  	LIST_HEAD(dst_folios);
>  	bool nosplit = (reason == MR_NUMA_MISPLACED);
> +	bool single_folio = list_is_singular(from);
>  
>  	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
>  			!list_empty(from) && !list_is_singular(from));

s/list_is_singular(from)/single_folio/

?

> @@ -1925,7 +1937,8 @@ static int migrate_pages_batch(struct list_head *from,
>  			}
>  
>  			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
> -					private, folio, &dst, mode, ret_folios);
> +					private, folio, &dst, mode, single_folio,
> +					ret_folios);
>  			/*
>  			 * The rules are:
>  			 *	0: folio will be put on unmap_folios list,
>
> base-commit: dba8aba0a9a00ff781c03d82ae534fc6f8c2e263

---
Best Regards,
Huang, Ying

