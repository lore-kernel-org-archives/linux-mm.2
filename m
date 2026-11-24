Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54B0B606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 07:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EtRK0xDX
Received: by kanga.kvack.org (Postfix)
	id 715376B0610; Tue, 24 Nov 2026 02:21:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EC5C6B0611; Tue, 24 Nov 2026 02:21:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 628F96B0612; Tue, 24 Nov 2026 02:21:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40CF66B0610
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:21:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3AE340944
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:21:27 +0000 (UTC)
X-FDA: 85469167014.19.78B1868
Received: from mta0.migadu.com (out-125.mta0.migadu.com [91.218.175.125])
	by imf25.hostedemail.com (Postfix) with ESMTP id 99F47A000C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:21:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EtRK0xDX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.125 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795504886;
	b=kJvpYzTbaij8gCxGuxPmFRm0YQuzc7d7dTsWoV6ee/f3PCHUIozkusJoKe7NhKBmzcZ/yx
	+NibJWoiUt9F3QT1zrDFItJLo/aq322SIaZNXN7TG7SQuMF8RPEyz5VEQRY/50RgU1wRt7
	WRIG+EFDwCftRpVECpXSPty7tl6C7H4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795504886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fuY33GUF0eUP0SwseynPFkH435CSn9417a8iUr7BK7k=;
	b=KxRkEslkdzHhOC37SmDYuUd87sJngMwgCMTWnvxUXoQE5GZVt7esl+hXn2vNRFPf1NxwRC
	h76KBMiczRTqY7mzF4dx7goKgwJg/CvLV//ihPopvfMGPU77rg/7MOQ5pk4C4DJMYns13c
	TFeWHlBj2p/vw/3L399PIUTSU5Ww6kU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EtRK0xDX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.125 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dsrRPagJG7IpTBUtHaN37ZSV+UIhydva5xu3fPf5Il8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795504878; v=1; x=1796109678;
 b=EtRK0xDX48aYVGns5qZl8sf1U4gRqygL/LQNdOk6NK/48fwI9CtxppbezuodiaNUOk9Jdh2o
 1+9FffH7K8rFvsxYYcCiY5q5PDTn/a/vV7ThX65V3Ye76zWWzqH4EPEcKxGw1vxQav1W7ak4O4H
 6QiNWSga/nNj4sHyQ/epgPcU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id bb0ec5bee1dfc514;
	Tue, 24 Nov 2026 07:21:18 +0000
X-Mizu-Trace-ID: bb0ec5bee1dfc514
X-Migadu-Flow: FLOW_OUT
Date: Tue, 24 Nov 2026 15:21:08 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: sashiko-reviews@lists.linux.dev
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org,
	kasong@tencent.com, baohua@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com,
	baolin.wang@linux.alibaba.com, Baoquan He <hebaoquan@kylinos.cn>
Subject: Re: [PATCH 1/4] mm/mglru: add MM_WALK_EMPTY stats and tracepoint
Message-ID: <awU65FQ4XGGdwMpG@bogon>
References: <20261120085806.781225-1-baoquan.he@linux.dev>
 <20261120085806.781225-2-baoquan.he@linux.dev>
 <sashiko-outbox-226848@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-226848@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 99F47A000C
X-Stat-Signature: isw861bs1od7gtkcpkmgggmq8uouh91e
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795504882-708717
X-HE-Meta: U2FsdGVkX18Rsuy9sJZJYidsJdVeWF18jZ6yP0J9TXPaphaVQPXpdf96ddfDoYp/p1aiuTk6VhiUcNGZJnCFIOhN7o43Tps/bYCxb4gpfFsRAjtEkMgR7s3W7JKT6vdaH1aRqCw3iohDFfdvs4x/7mJXy13vp04esXdfMxaHTuT7PjNJhlczWW4iexzj89OTxYxpDXoAl5E4w38uEjb9kTdJFUPy/h3ZrDQt6KQ6zJstK9giv7hfUE2lSDOtOZn0LPfY8/SpGqTQxLOPY9csPhdmA8pxIdLSe5vFOWStur4t29DN/Zq7rnMoDsz6osRhitWR9kRKEv6kAIB01F5+CuF5Pzg/8n/+VQWmsGMtC+lREwMlsDlN9kigmqA4e50WV68ty+bVPuEol4kkSjdkq5aAga9lsOYrIk4L4t9XEumjMAren9FNFmla7NY821ZF+Nmf2VcWhIMjTm9Y9WFg6ww7A0cWip9n897pGWowrnXURCybkH0MEineKpSGcgrmx7xeq2qm/XaeMdIVCiTAgRLzVisD6qUBmJ7nbnSdckODqc+pa27UdgkZMvj+DacYJ3VWBIBtfhTTbIQQRHuLuEPN1sxAs0MGiHZCviJgf9dAJC9nHVHOpjApWjEAim4MXE2GNqV4WTzfLdje0AgUXlCTdg/SAv61ytZvgxLI5yNyPn1kUcOWRC1eno8NXRoMnQ+fAz/2EIC6BjrGNQDf+14OurUfctE5Mcj1/Mk0tW6DbQHoqiOjGymoPmCxqc0Nr3LnDxIVN1iVzzfdUAv37g9EBNMZ5mXDrZVz974EVMYRCM4r81xTC2N8QF/tNxgq2o4+6qHGLdMnCQ8Lihc2SOdO9ZPhpY3Rpso4VQoa05LeoJiAvYvF4PDUXSV3qjht3qT+sl1exR7hqbd4hxTIee0RpwhGsqh7AHy4tg8UDNhffVyBzwP6kiff1HBhfs3ytMR1iq4FAV99Ulk0jWp
 Aj9ZHYTR
 q8gJf+yg1AzdoPfAGUKwcFMRpWJAyJ2cl2ZEvh/U4iWgXKEi195JbT+jxGJI7oFhaJQ686YWkS3gPPYam7pNcPHkbR8ji3hQ5SHLYB07DcosDX+MvPYlasa+WJ1nnQiWbfdDc880uUgt13r48fXJl4Q+kdYhgfRhmwclFmFdRWbBBduGqwJJQCr1I96B+dT2MPXEMkOv/NJPnSpEwtel2kr17oTIVOG8Gbk7cocESaL5FH20u3NsWdZ7NNSCz2YblhWgyoPW3PmIvP71Q5nl3fmebqTdhcwXX1s7EWhNRrKmk4h8eUZinGfbmJ995tp5w4aH64I5kdU2RGHQUmNkjXBXbIk3Px6UFsvlOgMXUfb/ISNx83QC6oFIgBk88iiAKynrYUDF4JuLA9bNN7RkhpInYrj+l8XqUXAEEyrKx8DN9sGFj+BlocBhr5yMoBE4cz8+INChyloADY+EKpuS0SUGBJJ42NYJUXcbIO01VrhfDgpP14X1edbdtpRyvc771G1SgA/tzYf0PchDrUsUqsgtNszWo6Z/vzPzlNKS/p8bx1gYvQsiOc5kKMjZ257zIwxY1E0DcJ77z1BtJfkO8DGBcgmS9M3NB2CiR4IkT0IvpSQawFxumTjPLyX5PUaDfdm0g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/21/26 at 08:59am, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/mglru: inconsistent MM_LEAF_ASSOCIATED accounting across
>   mm_has_notifiers()
> --
> 
...snip...
> > @@ -3682,6 +3685,8 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
> >  		if (!folio)
> >  			goto next;
> >  
> > +		walk->mm_stats[MM_LEAF_ASSOCIATED]++;
> > +
> >  		if (!pmdp_test_and_clear_young_notify(vma, addr, pmd + i))
> >  			goto next;
> >  
> 
> [Severity: Medium]
> Does MM_LEAF_ASSOCIATED count all leaf entries belonging to the target
> lruvec (as described in the commit message), or only young leaf entries
> in the target lruvec (as described in the header comments)?

Agreed, and the counter is not worth keeping. MM_LEAF_YOUNG already
counts the leaves we care about: it is incremented after get_pfn_folio()
confirms the folio belongs to this lruvec. So v5 drops MM_LEAF_ASSOCIATED.

> 
> In walk_pte_range() and walk_pmd_range_locked(), get_pte_pfn() and
> get_pmd_pfn() filter out non-young entries before get_pfn_folio() is
> reached whenever !mm_has_notifiers(vma->vm_mm):
> 
> mm/vmscan.c:get_pte_pfn() {
> 	...
> 	if (!pte_young(pte) && !mm_has_notifiers(vma->vm_mm))
> 		return -1;
> 	...
> }
> 
> When !mm_has_notifiers(vma->vm_mm), every entry that reaches
> get_pfn_folio(pfn, memcg, pgdat) is already young, so MM_LEAF_ASSOCIATED
> is identical to MM_LEAF_YOUNG (which also only counts young entries after
> get_pfn_folio() verifies the folio belongs to this lruvec), and an mm
> with old folios in the lruvec is still counted as MM_WALK_EMPTY.
> 
> Conversely, when mm_has_notifiers(vma->vm_mm) is true (such as KVM
> guests), get_pte_pfn() and get_pmd_pfn() let non-young entries through so
> secondary MMU notifiers can be checked by
> test_and_clear_young_ptes_notify() and pmdp_test_and_clear_young_notify().
> Because MM_LEAF_ASSOCIATED is incremented before those notify calls, it
> counts both old and young entries when mm_has_notifiers(vma->vm_mm) is
> true, giving MM_LEAF_ASSOCIATED and MM_WALK_EMPTY different meanings
> depending on whether the mm has MMU notifiers registered.
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261120085806.781225-1-baoquan.he@linux.dev?part=1

