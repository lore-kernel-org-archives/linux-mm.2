Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE0F0CD6E51
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 07:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51AC6B010D; Sun, 31 May 2026 03:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03096B010E; Sun, 31 May 2026 03:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF0FC6B010F; Sun, 31 May 2026 03:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B19316B010D
	for <linux-mm@kvack.org>; Sun, 31 May 2026 03:31:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6205B1C0628
	for <linux-mm@kvack.org>; Sun, 31 May 2026 07:31:23 +0000 (UTC)
X-FDA: 84826894446.04.2DE6E3D
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 98C4710000A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 07:31:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GLxC/+IQ";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780212681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ygMusJ4OhxFWYgfdJFdjk6JjCc/P5Yv4lLsq+6asc2I=;
	b=O6TVcYH2Gb8s7CmkZXQ4BNVCGt/DNm87XhQJsiXtkhi7Wl6SCQ6H42VlfJWlBkdHgLYpR9
	76NYdZePY1mzICNa0t/94rCwCKnLQckmdUJp9S5PYBybHnoNlmprzigHEvor2ZPJ60Fg2S
	tXRs5Fwydzanq789pixjkUqVqPmCtH4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GLxC/+IQ";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780212681; a=rsa-sha256;
	cv=none;
	b=HlfulDEmNaiN2AWHHawK0cMFWK1EoECaE0i+gTp72MN/HhFu8/3+AAkJKXuI4eGhZXZJcF
	cdl0jV2uxEiH6EPmWebR4L6vcV7H15c0nfgFuNi8F2ZSsk0MnQfra4T0JgH1yXI2MGd38t
	3WXSXg1kIoY4PNJQDA0kFbPJXsd33K0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780212678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ygMusJ4OhxFWYgfdJFdjk6JjCc/P5Yv4lLsq+6asc2I=;
	b=GLxC/+IQoaYnWqMbHdZqSraF09cYIqx1TkB97Iseulqg7tgBNUbFR46llX5lxy/ymBtQqv
	ta1xf7DjhgeW2OqmHLXsTMw/0Ulf6309h0NH56ha+aGc/AaAGZdFlMvFzL8F4qoKgQF23n
	J+dGGm1xnDWnqudtQmP4PWNJD6sQVHo=
From: Lance Yang <lance.yang@linux.dev>
To: npache@redhat.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com,
	usama.arif@linux.dev
Subject: Re: [PATCH mm-unstable v18 12/14] mm/khugepaged: avoid unnecessary mTHP collapse attempts
Date: Sun, 31 May 2026 15:31:02 +0800
Message-Id: <20260531073102.20318-1-lance.yang@linux.dev>
In-Reply-To: <20260522150009.121603-13-npache@redhat.com>
References: <20260522150009.121603-13-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 98C4710000A
X-Stat-Signature: 8ymiqdxu1bhtparj1zo8rqgz8kz4xg3j
X-Rspam-User: 
X-HE-Tag: 1780212681-535980
X-HE-Meta: U2FsdGVkX1+15pe3rl6bmBqZf/zpyZzmrf7+yXc1cLTDwsIn9K7FVgjqGZ9BTd9yxbp1kHLwc2QktCqC3J6EZR6GCc+UWEjvT+ay+qh5KY0HGt7DWUl9+KxPFpi/0ytgXn5mx0KpB2Uzt5bMZorI+rTJwd/NPs7rqy+kGuj3bGESKcYky/A6u/xz7ePe2u3LdesAZdlCZCzXixCfKG+EGWHFAgMsgMcS1hAeYQwIT/0zHSIwG5kCVjWGCTPX/2oFyGyydcmUkNeVBXF8sdZJNTKBkRip3+b7MMOcLYEWZBa8M6XcXNBXCncAAJbEqg1jXxGcM6BK0+5fZ14mAbTaCDvYO6tmP+TOiQ5FIpEposId0WFFO7TrKsqd6afUViQNQ+zXXqnBF3bFMz8+lkIxeL4xKVMLsOuVxrt4HrUmV35+3sLZ6KC2BQa5F0PJJ9+e3tGP1VTDQ4/8SiaCAi/jwnO3pGs2nENf8xTV0OTcacQNExim4J0pb76YZg2FslcoxHvLMJiv5s07cT9a6GIF2cjQFBYpwf/drDLFL+A9JOSNEVQFrBTsgjUeYevydZ/uTULQuK4ErV9m9rmPRaiwi/34bry3HRTSio93IQ2NfMf0cBbFxRLWeDZOnqesdHBdlSJqZR9NmbLiaZx5wCMpa+02LjzX/EntOFDaoZkSlZluZ9b6sc5X6CZrmUJA76Mx2Z36Ka6E+vFkyuxlGj7UqQC85az458eHkn6k2v3dg5y6SDnCqmJy+fDg/5KHzfvFoDxumL30Vrf5TX6YCfpaEAhsDK8OwlWwpodWW+aeKHxOrb0BDKNa2rLWglipub6R0A1MDu+qegiszREmgxWb6klpETsuvwBCaLdl0Cg8oZu2PKCvsYJ6RQESQVvBDkx/h2xTuf6WfsPAVO0fVr6aieiFw2FtJCwoILlQVDtLnpq83npdj/n2p/bMXNPnQGl6eITKWNrVqe+SmxEGOsE
 cbXwv8tO
 C121RuKaUJByZ5pCaHwo6KYm8rRBdDihoxd6ICZZJHBa0gu1I+EXZLZxEGPslgpy+dfvSsjbVGqJB+LhDsdQikAt1GqxahbEh5A587UdH4ZJ93XEOpEah4griSxNxNROVs5mYngMjMl+s6tPr+uoOsHZnDGJdDIYwfTKt+ZG4CKoU8XESB7DV0UZrtjyk0e9TF7yADOi8eVSghN6JrDD+jLO8NYFfwZR6Ii3kxPdSlU2yWZWhNEDCicootd2ElIsfZabbLGNYsPe46bJ4M4G555UbwaAs6CymOBpOlK42ZjfJ3J3OaQUbHZ9t49F7hzoPqUmGaPYatTCUec33sp/B/0hPuddk8+5ItuAaGiH6zIVgFCk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, May 22, 2026 at 09:00:07AM -0600, Nico Pache wrote:
>There are cases where, if an attempted collapse fails, all subsequent
>orders are guaranteed to also fail. Avoid these collapse attempts by
>bailing out early.
>
>Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
>Acked-by: Usama Arif <usama.arif@linux.dev>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Signed-off-by: Nico Pache <npache@redhat.com>
>---
> mm/khugepaged.c | 24 +++++++++++++++++++++++-
> 1 file changed, 23 insertions(+), 1 deletion(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index d3d7db8be26c..15b7298bc225 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -1535,9 +1535,31 @@ static int mthp_collapse(struct mm_struct *mm, struct vm_area_struct *vma,
> 			collapse_address = address + offset * PAGE_SIZE;
> 			ret = collapse_huge_page(mm, collapse_address, referenced,
> 						 unmapped, cc, order);
>-			if (ret == SCAN_SUCCEED) {
>+
>+			switch (ret) {
>+			/* Cases where we continue to next collapse candidate */
>+			case SCAN_SUCCEED:
> 				collapsed += nr_ptes;
>+				fallthrough;
>+			case SCAN_PTE_MAPPED_HUGEPAGE:
> 				continue;
>+			/* Cases where lower orders might still succeed */
>+			case SCAN_LACK_REFERENCED_PAGE:
>+			case SCAN_EXCEED_NONE_PTE:
>+			case SCAN_EXCEED_SWAP_PTE:
>+			case SCAN_EXCEED_SHARED_PTE:
>+			case SCAN_PAGE_LOCK:
>+			case SCAN_PAGE_COUNT:
>+			case SCAN_PAGE_NULL:
>+			case SCAN_DEL_PAGE_LRU:
>+			case SCAN_PTE_NON_PRESENT:
>+			case SCAN_PTE_UFFD_WP:
>+			case SCAN_ALLOC_HUGE_PAGE_FAIL:

Nit: shouldn't SCAN_CGROUP_CHARGE_FAIL go with SCAN_ALLOC_HUGE_PAGE_FAIL
here?

If charging the current order fails, a smaller order might still fit :)

Cheers, Lance

>+			case SCAN_PAGE_LAZYFREE:
>+				goto next_order;
>+			/* Cases where no further collapse is possible */
>+			default:
>+				return collapsed;
> 			}
> 		}
> 
>-- 
>2.54.0
>
>

