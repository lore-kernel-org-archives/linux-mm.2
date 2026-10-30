Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D08F0606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 03:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JZqpmtFQ
Received: by kanga.kvack.org (Postfix)
	id F1AB06B05B3; Thu, 29 Oct 2026 23:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7CFD6B05B4; Thu, 29 Oct 2026 23:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6B406B05B5; Thu, 29 Oct 2026 23:55:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA2AA6B05B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:55:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34921A8201
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:55:50 +0000 (UTC)
X-FDA: 85377928860.11.A6AD575
Received: from mta1.migadu.com (out-212.mta1.migadu.com [95.215.58.212])
	by imf04.hostedemail.com (Postfix) with ESMTP id EA7BB40003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:55:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JZqpmtFQ;
	spf=pass (imf04.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.212 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793332548;
	b=sK/ZklVgvS+egbMuA6oCZRLbjXvPMNbfpm1RYxsGZLbAnsg8m07f2w6HNUPRSYcVo9lD9P
	CNGkNCX5oc1dYOIVwQA31bTU7HVlRcrhCLZfQblEMYky9rum9GrDGKqzrxYBFSb5hbGbZO
	vUAJyLVLxv3pJzQoNw3JQzfvHSwLXjA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JZqpmtFQ;
	spf=pass (imf04.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.212 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793332548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ey3vPsJ2dQFhz2BxI4N3mBDHBT7ectNl9BIu9ANR89g=;
	b=Y8YnXmIUQnEbW/ZopQZvDxTTda9N46Uf6AoWEGKGzb1HltmsL4tKGZ4OvnTP+QHHn9PQ6k
	iQC9oDC2p4/Y0HYRXvaFcvVmNXPBtuX4uhZZa7Q9G7fQV+Hm090cFNa8KuY8P1KMbpxQZU
	5KGo/gZj2sy78OoKi/A/UpxhN8GcGYs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=U6aEVcyx4cbsQT0ReFIAsX7642J2D1rQ7p5hav7hVYg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793332545; v=1; x=1793937345;
 b=JZqpmtFQ7Ohd/1LNlZcCz7DJxGmfw1W0QBIwKd81WGlQ+GCSScpslPKi5z61+nW3yuNQ2DfG
 qYpgDNHPL3GYEromeJ9ePTKmdga4oQNe9eAq94ZKZxJjP2u8k8hH0quzBvtjDNrpC+rFPoXIxuw
 UlDm22KbKQ+To97lJYUZVLqY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 29251291072b5e95;
	Fri, 30 Oct 2026 03:55:20 +0000
X-Mizu-Trace-ID: 29251291072b5e95
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
	mason@kernel.org,
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
Subject: Re: [PATCH 39/46] mm/ksm: fix use of a freed anon_vma at swap-in
Date: Fri, 30 Oct 2026 11:54:47 +0800
Message-Id: <20261030035447.140856-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261027-fixes_core-v1-39-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-39-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EA7BB40003
X-Stat-Signature: 5qc4dqowoaqhfcx3dqwdhjwc4icu839x
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793332547-839863
X-HE-Meta: U2FsdGVkX195Rr6bXMOBg07mSComOxbVm3SJk3JA9/JY4IE7I62M0dDw+s3BpWUyCi2A0WxlurB8RoGveZA/HxXV2UFkVIaY4IXIfL/VWYbRITnpbrknxw/gG5ELUsnkMOjeg5Hayr+con4CvSjL56nx6ZgLVzhs5x5uANjdum5c6OvKE1vWV2gge0VE2zGhHg+8t+7xeMkt9TTMvn1pDeV/qqkNbM1h3wzL1vgWNANkD4jrLBA13mxJrBEHkuuHUMCM+9HthfDuM8ybrgVJGcTVO64ji2lSuMq6O/Sj0/JqCb0fo4iFexPxmiT91w3he8xJKUXH+pnpvjvhos6na6VpFlICK8fXZBn/u6J4vOYRfxhWLfQvYneAV1HLT9eWasEhNV7/rFH/iUPyVLNR0O0JLtaKXOti6w77+f2hVsg9P+o2yspslOlZy0Lly8hzw+XtGl3lEDAWhThF/hupCbPedXMuLQ8kZMF2elNtU0/YQyNjD/Z7S5cjQw3GxFLjMdZ1F4vjLAFEBzMwh6aQZ7oVoD2oe4SG0P85djQQkO8USZpRqlgAA/B98+yLk269KCqW2DDk1wraYZ6EvbG4mL/4y2nK5s9ktJ0rx7aXE4bBkMDAKqzDAx9u57hfr6yvlujatME+UiJBk1wIoDyQ46JSHolNnhwNxwEqipy9+w4LHviEvUsOw5qUQHFJBDhB7rKdxlll1TZgoB3adrYqfmSQ2pg6iv8w4yuA0MmV/iaTVbXcPCMYEetamJZtnjq2InhtS1t+RT2pzZw0xGnaYnBhyCSbRR1/hCIQ19xmeaRCsz2a9N2f8+JQ0aXwm3+N8HM8nz8tVyKnychfo1J42UqfrgkEbkTYzKQp8CUsjMtTALTifzYtOoIw5rroInPpuBX9JuiZ+eyOQvZSndlLOT9/ejBR3Cgmftmaqhdzd4bjSnCmHApv1KaHHnxgM8/eQBMbmss9idLrOTrZqw+
 ZNWjRCe7
 vRfdKRB08sLqqtOT741+pdue6vx8FcJXrR+5oDHNwdnD4/Z0EzTQS38hIdMvJppcoCmO4h4T34ubLkOzhjdLvovaMcfrgCksoRLm6dkXzyyMWMMkwtuhPAkmUJzAMN10DvNqhqu9VquexevXbMOBYtVzXCf4PoYpD3I3BYx5F/4V8kNrw5Y0gVtqyLVTIQSLqTdqO6p42aGlDJvHPxhbsxoY6mEbzQC2fxJRMXFkUP+DwgoZlJjeaybLHJA09jDOzOhMAVSp3qvgt2M9TeMETNFALp9dr0IXpr+M6p/NhJqVmLVXFBpNubGReOTDFzJbkYPRKMb4wlAixWXT2DRDPG72raGpcR/0gV9XmaY4sA7J8GAWLIFWvZUl2oKWUVUju1b3+4gQjRqOSmL/a9J8hfgDlJQ59K/DBGvsLQ7wbEB0wAn1Ggq69Yx0a/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> A folio read from a swap slot previously shared by KSM can remain in the
> swap cache after the process that first mapped it exits. Its anon_vma
> can then be freed, so ksm_might_need_to_copy() must not dereference it
> to compare roots.
> 
> Doing so can result in some false-positives, resulting in the reverse
> mapping missing the new folio mapping, preventing migration and reclaim.
> 
> SLAB_TYPESAFE_BY_RCU allows individual anon_vma objects to be reused
> immediately after freeing. A stale pointer can then refer to another
> anon_vma whose root matches, even though the target VMA is not linked
> to that anon_vma.
> 
> Move the anonymous rmap compatibility checks into
> folio_anon_rmap_compatible(). Keep the page-index check and compare the
> folio's anon_vma pointer against the VMA's own anon_vma and root first.
> 
> If neither matches, bite the bullet and walk the VMA's anon_vma_chain.
> The VMA keeps these anon_vmas alive, and finding a match guarantees that
> reverse mapping can find the new mapping.
> 
> Lorenzo Stoakes says in a private discussion:
> 
>   "This isn't quite equivalent to the existing check.
> 
>   Every anon_vma in an anon_vma_chain shares the same root, but if you
>   split a VMA then fork both of them like this:
> 
>                   VMA A
>                /        \         <split>
>             VMA B      VMA C
>                \        /
>         root <- anon_vma 1
>                ----^ ^----        <fork>
>               /   parent  \
>         anon_vma 2   anon_vma 3
>              |            |
>            VMA D        VMA E
> 
>   VMA's D and E both get their own new
>   anon_vma's such that:
> 
>   VMA D: anon_vma 2 -> anon_vma 1 -> root
>   VMA E: anon_vma 3 -> anon_vma 1 -> root
> 
>   And if you found a folio referencing anon_vma 2, the existing check:
> 
> 	anon_vma->root == vma->anon-vma->root
> 
>   Would be true for VMA's B, C, D & E.
> 
>   However after your change it'd be true for VMA D only, as it's the only
>   one with anon_vma 2 in its anon_vma_chain.
> 
>   Whether or not that could actually happen in practice... 🙂 I don't
>   know.
> 
>   [...] after your change it'd be true for VMA D only, as it's the only
>   one with anon_vma 2 in its anon_vma_chain. [...] I would [...] say that
>   you are making the test stricter but more correct.
> "
> 
> If this affects performance when KSM was never even involved, we could
> just track whether KSM ever merged anything and just skip these checks.
> 
> There isn't really a lot we can do otherwise: for mapped folios we might
> be able to use folio_get_anon_vma(), but for unmapped folios there really
> is no easy way to see if the anon_vma is still valid.
> 
> Document the (confusing) lifetime requirements of folio_anon_vma().
> 
> Fixes: ba6f0ff3981e ("ksm: fix ksm swapin time optimization")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/ksm.c  | 36 +++++++++++++++++++++++++++++++-----
>  mm/util.c | 13 +++++++++++++
>  2 files changed, 44 insertions(+), 5 deletions(-)

Acked-by: Xu Xin <xu.xin@linux.dev>

