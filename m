Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75B46606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 04:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wzldufxr
Received: by kanga.kvack.org (Postfix)
	id 6F9286B05B8; Thu, 29 Oct 2026 00:53:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CF916B05B9; Thu, 29 Oct 2026 00:53:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BFCC6B05BA; Thu, 29 Oct 2026 00:53:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3AA916B05B8
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:53:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E4A9F1C1B2C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:53:49 +0000 (UTC)
X-FDA: 85374446178.13.20D4DAC
Received: from mta0.migadu.com (out-85.mta0.migadu.com [91.218.175.85])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3FFD11A0002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:53:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wzldufxr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.85 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793249628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSvRu+DrKpZk9fhC33/WfqayjP5HLD0PEYNxYg/H2d4=;
	b=lYI7PN6Y4cQklmzFmyLB6BSP1YG4IdN+B9gX3DENjEuEL21+lQghTjZBr1+MOPqk6q1Y5x
	y2umR0KjkNADxmJptdIKKjC9E19grvpGB2MZhcKkFZFeFz6J9V5841rLoH48GNC5h8nWzZ
	R/Ki9blobTTZ7H8ieTO04sqPo2hgf6M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wzldufxr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.85 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793249628;
	b=Qm+Hq6Lzdks/x/VYhQ5s+jZXNbRA0cdn0kBr7BjfwDw8IvF2B3sgBXwN8IFnCMhyOAmRXI
	4KmO8DTgWc6FfgWIqDg2S/ABZiDErY8rk4LfjpFMEO0/7bAWqrvsIhdPEYXNedigfNcsYg
	+OMjAtcJKKWNLYfXuWzs8FqZ8glV5zo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=i7u+rlmCh6Mr8ur+/yCWDheirhBIEcgUXzKbr5iYaLI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793249625; v=1; x=1793854425;
 b=wzldufxrq7LeGF/UT1w/d7qBoo4cSoxFnLCvJgGiKddxIK6nGj3eWwtYfsSoRfGtBw1RSw+o
 l2EEGi9jB7oYX3VF+s085Fb8klvLZm/TtHLejbv1l7E/dPxEI1csGXXbkf56r/0e2nXCXfg2S7r
 8BiHJX3hY4QzJUxF7RNT23/I=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 06f3ecca37f8f8d0;
	Thu, 29 Oct 2026 04:53:44 +0000
X-Mizu-Trace-ID: 06f3ecca37f8f8d0
X-Migadu-Flow: FLOW_OUT
From: xu.xin@linux.dev
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	aneesh.kumar@kernel.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	harry@kernel.org,
	hughd@google.com,
	jack@suse.cz,
	jannh@google.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	josef@toxicpanda.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	kasong@tencent.com,
	kees@kernel.org,
	kexec@lists.infradead.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	minchan@kernel.org,
	muchun.song@linux.dev,
	nico.pache@linux.dev,
	nphamcs@gmail.com,
	npiggin@gmail.com,
	osalvador@suse.de,
	pasha.tatashin@soleen.com,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	pratyush@kernel.org,
	qi.zheng@linux.dev,
	rakie.kim@sk.com,
	riel@surriel.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	stable@vger.kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	weixugc@google.com,
	will@kernel.org,
	willy@infradead.org,
	xu.xin@linux.dev,
	ying.huang@linux.alibaba.com,
	youngjun.park@lge.com,
	yuanchu@google.com,
	ziy@nvidia.com
Subject: Re: [PATCH 33/46] mm/madvise: fix data loss from MADV_FREE on a KSM page
Date: Thu, 29 Oct 2026 12:53:07 +0800
Message-Id: <20261029045307.131675-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261027-fixes_core-v1-33-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-33-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3FFD11A0002
X-Stat-Signature: ym4z6oyep6mn7obbe9arh9btx3gz4fwc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793249626-136955
X-HE-Meta: U2FsdGVkX18YvmDFx3L4YsLyKPW46orTG6UdbRslNRMtfBVCFtZNDkane7vJMgA5bN2DTUV4h/PMdzaWW1SkKzXFfd0L86NEKcN8UQhgU0TS0LNrZtI0IkY2BIM/jxYbwuwUy90sUMDmaQCmmEIMNAIqRU399F1SmwPFHBL+M/dl5vUi1IRelJf3l6afy8rJSpgPViZyVaDp5IycrlvQg1RZas6MxlViK9Xosl3YMo6oIb9ldEJBTRGoy3ko+ywTt/rOEmM9aBrd5muA0+qxoROWXYwetRAx1k4oeKdflnOZHK8Tg/yMKPc1EcVnqT0unXr3YcQRX2+odIsBYBXxa+ld2mMLJMn4PGrtS/6EO59Dyr0lCfJhRkp39S3VqdsmKHEVfZ2ByUkX4LWXiYV9Aa5H7g2ONkDffFVUGfqh7o2x/lLKOVJCVF2jF3DltA36+Vg6TdARkCUjeKlZx+9fzg2kDuyWLpDnuSpvMr39uagLX+jf6oYG5IiOCFHBPG2AT0Y6UV4i3r3Fc6m3TdzXxThsW5BU4Bv1/XzI0Zckuq0348taTkRE0yRRVuma5kch37Xx4DCcvp5zt6j0J3h1V4Z4VZtzzARlu/HVlR3NNxW7eIWKCJU+7EabuQxd80OYe8fOTI2QiHhY0jzqCwYpgFfZbWdsmko3m/dO0uamn/bODUV3ZKGrvPu/91dsJZSncmP6JQdqI7cYkZKgj0IT/KWUSa7oSot2r2UZLe2GdKTd2exat7+hEsDHLkhBLy3WS3D8JbjlyIN5lOJGurPwp0mCQthu1gG0CFV9BtWfBduFrPezSzwrPOAfOH89+Hzj85EC2vuBZxjPUcUuhkbZNG4GlrVaLN7OG7TCSNlIIMa5UryKVbx+ihkEUYhl2+HW19BQBhVq4P/b5uVMMJR23OQWD+QRyWx/wea0L+w7N52Z14fHPkNPVk1odlsqRa2ATXxnXz4GZenwn/Bz8Hq
 TdvY21gr
 P3oSd1JWlVpNB7bLIlpadCnJ8gb33Lj0JKveMfQb+t9ne1sWi06KmpPPXecKOmhHF821wgDrw1j1+zkf5SCSBt/HnSgvLM5T8xbu5Vm4HPkfT6uv5v0CiuO4FMmlE8xrIJcn4jbWR9zVh+zyPVWDp16u2sPagvOqHWJQyrdiK9amWOARzvo6w38UMnYmZRRZZl1AhuU3KvqGgczrMJn9JJ6dw4kjHNlkMuWdU5loa6troYymev+27TjOIegsXlAzAd298YzXk3tXtkcw1OfjQ1PzoAbdnuFYhDojW9LFNL8vO4l23eCLONDSkZA5A4V8NiSUKbXEgGpJOZl0Q8GJElj5P0Bcbif50QnroiYJXIwZxngbu5YORq85hsO13g69DNmqPRwS20IAPSQ4tcFSNo75RJLwWG6Gyt1UmhjFeMbM7ljjpoGP0SPfqjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> MADV_FREE can clear the dirty flag of a singly mapped KSM folio. The
> folio remains in the stable tree and can gain new mappings without being
> dirtied again. Once marked lazyfree, reclaim can discard data that those
> mappings still need.
> 
> KSM always marks a folio dirty when converting it to a KSM folio in
> try_to_merge_one_page(). Marking a folio lazyfree clears PG_swapbacked
> but leaves PG_dirty unchanged. Preserving PG_dirty makes reclaim restore
> PG_swapbacked instead of discarding the folio. This also protects folios
> that were already lazyfree when KSM converted them.
> 
> Skip KSM folios before clearing their dirty flag, checking under the
> folio lock to serialize with KSM conversion.
> 
> Fixes: 854e9ed09ded ("mm: support madvise(MADV_FREE)")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/madvise.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 75b409e97dbf2..a16e3cb256b7b 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -756,6 +756,15 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
>  		if (folio_test_swapcache(folio) || folio_test_dirty(folio)) {
>  			if (!folio_trylock(folio))
>  				continue;
> +			/*
> +			 * KSM folios can gain new mappings at any time, so we must
> +			 * not clear their dirty flag.
> +			 */
> +			if (folio_test_ksm(folio)) {
> +				folio_unlock(folio);
> +				continue;
> +			}
> +
>  			/*
>  			 * If we have a large folio at this point, we know it is
>  			 * fully mapped so if its mapcount is the same as its
> 
> -- 
> 2.43.0

The fix looks correct to me: checking folio_test_ksm() under the
folio lock properly serializes with KSM conversion, and skipping
the folio avoids clearing PG_dirty on a KSM folio.

Reviewed-by: Xu Xin <xu.xin@linux.dev> 

