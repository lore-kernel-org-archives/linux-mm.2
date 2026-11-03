Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19D8A606BA3E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ts5HB9y2
Received: by kanga.kvack.org (Postfix)
	id 2DF386B05BD; Tue,  3 Nov 2026 10:14:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6DD6B05BE; Tue,  3 Nov 2026 10:14:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CE976B05BF; Tue,  3 Nov 2026 10:14:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF0F46B05BD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:14:27 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 80C081C3C50
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:14:27 +0000 (UTC)
X-FDA: 85394154174.08.9D100C9
Received: from mta1.migadu.com (out-84.mta1.migadu.com [95.215.58.84])
	by imf21.hostedemail.com (Postfix) with ESMTP id EB1EE1C0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:14:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ts5HB9y2;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.84 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793718865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=14hcT6F4fj8zJj0gPfB9WiAi+uaybopFKajULVBMQnI=;
	b=Tkep01HayLcWTdqt/ECTaxTGJXJUszaCrM68ZHbxoGncDbD8+ZQdbW+L3C9ovFf87cYTjQ
	1C/Wgomn9e0RVv7x0misjwefA9AhL6ioxn6RDg17Y1xw3ErC4sNisWvBMORuqjM7VW5Bc/
	NRanIcWdEqZ08GStvWm1bE/iB9pIN+0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793718865;
	b=f5DPxVp6XYSoHnlbbh3/oYDWk5UBtCs3XVC3B91UlZLri7lrFu0PNknfz7/IJIhqhXivKO
	zTMgdiukpqgsUOB7aSJCAT8b/ZxSUTKzTdI0nAVfWyYv5GTvVcTaJ9f4kaeXK12XaQHFM2
	uTpJZv7JGFwxot0X9G4I3nUDQAGgPJU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ts5HB9y2;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.84 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/n6q6+lIX9B5ZuliSLqd+JJa2B0QDGQRcHf36WsHI7Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793718861; v=1; x=1794323661;
 b=ts5HB9y28ZzWXoUo+d+m68JgTc6d40SOeizyYnSAdoBpXnsyKf1HioVJw2sd1J/ysygB1Kx/
 e64gLcGfgRbQFzbr3FKFgzMKXjBuYVURrWLNzVd6xMUrDy71PsneXa7FBxNvenPg4GGPhTAsRVD
 8G1VawouDX2sNWIeVN26sFcM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 198054973b778b6a;
	Tue, 03 Nov 2026 15:14:20 +0000
X-Mizu-Trace-ID: 198054973b778b6a
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	ying.huang@linux.alibaba.com,
	baoquan.he@linux.dev,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	liam@infradead.org,
	ryan.roberts@arm.com,
	vbabka@kernel.org,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com
Subject: Re: [PATCH v8 00/30] mm: PMD-level swap entries for anonymous THPs
Date: Tue,  3 Nov 2026 07:14:15 -0800
Message-ID: <20261103151416.1720617-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261004030844.90483-1-lance.yang@linux.dev>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ymrqauhtug87utn5q7xif8crcyjjp698
X-Rspamd-Queue-Id: EB1EE1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793718863-902039
X-HE-Meta: U2FsdGVkX1/yau0CEhE1hBYV7hs5hdQejj1bUF98YPyEPERi6Gg+Dr/n7mSPtqPccTXK45FXA6Oi/0gb+YALmai5MnD12NLsV+RUsdZAOtMw3aJg5LRhR3A8fBmzj9BEKSlwXRsmlawTSJRXSmVfqGInUDH1CnizYH2/ZSOul0RrprmTOWAzDANaTa5xV+Itr7P9ezVlEPuBpnx1H/BWWTgu4v1hQMCH53a/Pay0z+VJOIeK2ciOaLoCVRHzvonqVwXjoOKbZG91xdvarthWv67PIky4FbkdeggkhScp81AEoQZb8fn2eRiREZ3/YYCzhUPIdDKgZs8ljl9uOBBzCGgvhRsfs1icpcOfH59UIJvgoGLtAqQ/FxhGq0sTGuRIZCbJuUj5nb8RiuNk0Hp3KjwyHnReKsXYo244aDH0Pmw8hQaVGhJmPJAxvnaQ/tBEuxe2sxY1XD+PF2khjzsyPhC6C99tFrsF/vBnMFD0S25WKnBEnzj+8RBH81L5yHjIyUamG4M8HdyZsWoLnNiSDV1/LvqcNITO+VB5wq9tX8ZI9FlfUZzrbobqQe7GkGLJ6tqdo5MgRrnc2sJMfq0ckHo5JxjAJK9uAax4HgRBvFuzriOQXCaeiVPvPBtCOSQpsl8xQ3xIKghjG18lsta76tiec5GgrhLhq5lkG+Ptd8YsOW/Qk4sPA7kbqpsvrh6PY/mVYRM+Jpyj23r/gW5C+xVFa5jYJu3KhWdHJ67kmuqBjG0LYMdWK5fncKTfWxvh9IXIeY3Yzf/OsJUapRurz2xcSIL4nnPDZlZEvRqip/b3Pol7sXVfwqc8N9HjOlT5O0QCKa5dzgjBPrSB7NAKyqPOmoFTskkE781200pKKlrZIpFjupkZ7OZd4dfuwanO1vHk4BisX8kr3I/MLU4zpRlHpxLtPj7fKOf/en2swwBRMGHbgpgFWqy5nH7JYB6ouQeGFGDCPOpziLX5JRF
 tX1KZOGD
 L6q3PehTNW66CNAntZ+MOcLd2okU1CNPHuIMQCXRwMh4e71FPZtl0vXw/oa9Zr/kzxKXIhFbI6BVUOPnCRcCzpgG+gb2FbrFi+GMfkVnjSf8ICi5uJRDrlDU5xp82QiwX+0PD3iQzL+QkSmQb6GHoFSWsERgJEcOUhUMisiYWCI0IyYWHtyAZxRuxpqCy7ez91Jbu9ghv9xXZuw8GYzUrwvb3wM4m/WcWQOyJbi4tyIETkQbuwcF3ggY8Qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun,  4 Oct 2026 11:08:44 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> Hey Usama,
> 
> Staring at the swap-entry bits across architectures, and RISC-V looks a
> bit off in that regard ...
> 
> With Svrsw60t59b and CONFIG_MEM_SOFT_DIRTY=y, setting swap soft-dirty also
> sets _PAGE_EXEC. A migration PMD then looks present ... so the fault
> handler skips the migration wait :(
> 
> And yeah, this is a pre-existing bug. I've sent a separate fix for it.
> 

Thanks for the fix! PMD swap entries also preserve soft-dirty, so the
same encoding issue affects this series. The dependency note lists
your separate fix for RISC-V with Svrsw60t59b and soft-dirty enabled.
It applies cleanly and preserves the exclusive marker at bit 6.


> https://lore.kernel.org/linux-mm/20261004030312.90163-1-lance.yang@linux.dev/
> 
> BTW, could we also add more checks to pmd_leaf_soft_dirty_tests() so we
> catch this kind of issue early? Setting a swap flag shouldn't make a
> non-present PMD present, IIUC.

Done. The pgtable test now sets swap soft-dirty, checks that the flag
is set, and checks that the PMD remains non-present.

> 
> ---8<---
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index 863111c6d4eb..80686e2baaa1 100644
> --- a/mm/debug_vm_pgtable.c
> +++ b/mm/debug_vm_pgtable.c
> @@ -762,7 +762,9 @@ static void __init pmd_leaf_soft_dirty_tests(struct pgtable_debug_args *args)
>  	WARN_ON(!pmd_is_huge(pmd));
>  	WARN_ON(!pmd_is_valid_softleaf(pmd));
> 
> -	WARN_ON(!pmd_swp_soft_dirty(pmd_swp_mksoft_dirty(pmd)));
> +	pmd = pmd_swp_mksoft_dirty(pmd);
> +	WARN_ON(!pmd_swp_soft_dirty(pmd));
> +	WARN_ON(pmd_present(pmd));
>  	WARN_ON(pmd_swp_soft_dirty(pmd_swp_clear_soft_dirty(pmd)));
>  }
>  #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
> --
> 
> [...]
> 
> Cheers, Lance
> 

