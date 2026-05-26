Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 986C2CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 16:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BB676B00BB; Tue, 26 May 2026 12:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96C656B00BD; Tue, 26 May 2026 12:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882C26B00BE; Tue, 26 May 2026 12:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 778E56B00BB
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:09:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1520640303
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:09:34 +0000 (UTC)
X-FDA: 84810056268.19.5889AFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 65593C0010
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:09:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lW/i5z2H";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779811772; a=rsa-sha256;
	cv=none;
	b=mMMPQsBtcG6HGZAaCFXyKJ7qPYpSW7G+ahv2zEfiqrPh94nngs9f3KN5QbI8y/r3bD4suD
	bPuF8BJb7cUQgN+AMV2mhlXHa+EtzE1pzTpn1OJtKefIL327ZoqF12i/LqBn0bE5l4dXya
	spZLRyyHlYqbOi51EnEdbFMnfaNGdWM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lW/i5z2H";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779811772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9tLNwN05C3W3+dgxps7Px2L2gRcE4w7+jlrCyVSDhYc=;
	b=NOxClmNroU/ncvTOSEo4ybCMqFou+t5ZNOZd0utDe/gMr+Xr91CD9j1QVyKQIFJSyEqpYU
	Qp5jkxL3zRZVxIwCz+3EszqHr+pAbml68Aj6+50hGIWWgaYQIxW74tHgQ9bhcRBefYZ2z2
	U53xZtgHNdYycssmTV5dtrZL+S/xmcU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB44F600B0;
	Tue, 26 May 2026 16:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24461F000E9;
	Tue, 26 May 2026 16:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779811771;
	bh=9tLNwN05C3W3+dgxps7Px2L2gRcE4w7+jlrCyVSDhYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lW/i5z2HCdEXtBE9qJbS2TOhbeRh7JUY7fXC9oetAc5iN6FPf4UQ5LnKUlHUm5kkE
	 +xBxRozS2FF7py+EDKvvbfkYx2S2slj83/tCJpwj6LxGGT9AcNdBvdCS9QpGYY263a
	 F13sjUcrRGv2+nkKlgEEDszwO1gzSUQ2/b1MSCdR644Nh0B3f/cxrOvyXLbiRZyuHV
	 ZEYAXu4HmkQ5yj+64AJc6b13u2vhH1da0rGewGeOok5lN0F9wJOk8tCuOgvzDUhtb3
	 9178yaFNOLQkLjiYEEy+c0kp+iAX/i/Ajx+f7YV+5w6YJZoQYRXmtM2ccc0oEkMnUE
	 cpMCVj08TNvFw==
Date: Tue, 26 May 2026 17:09:28 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, nao.horiguchi@gmail.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, boudewijn@delta-utec.com, 
	ziy@nvidia.com, harry.yoo@oracle.com, willy@infradead.org, linmiaohe@huawei.com, 
	hannes@cmpxchg.org, jackmanb@google.com
Subject: Re: [PATCH v4 0/3] Only free healthy pages in high-order
 has_hwpoisoned folio
Message-ID: <ahXFPh-a_Zt1Q_r_@lucifer>
References: <20260202194125.2191216-1-jiaqiyan@google.com>
 <CACw3F53U8xNTHJkdJMo-74_t0a2dX2cJtQOjpjizU8=UNLQRqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACw3F53U8xNTHJkdJMo-74_t0a2dX2cJtQOjpjizU8=UNLQRqg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 65593C0010
X-Rspamd-Server: rspam03
X-Stat-Signature: oarf4ezw3bri18tknq6z8zkwkduruci6
X-HE-Tag: 1779811772-953926
X-HE-Meta: U2FsdGVkX1+IWEratTHZS+vhb6+rPpMoDzoiK1UlZ6MLqCFHiqHJY58WdfvnqPjEqRs9QgyYrFCDhdO9GFI3P8DhG8wiMLF6l+dXWAXN72GgE7bYZ8s8AGLo3r8vZJ04ALnFvC6IoS/lEEMtINZpMbG603bVxfWr7r5+zeDWmWggpMVbLK5kTmu2/8jgiBdbThcYCykxruwgRLDA5cHgPFLRMBVBXQ44Vb139l5I8MhB6lz9mjCY6Q2OFwwLPnL0lEPotnMy92ROds7DM62yAyQXcCsjjCSlPnGM9+VrqmyocgavzT3+RUgph5NGDRZMevaQ0lhIaGqBmwH1rlQluWOJVQgfXE6XrwVa5VqVZyldKS1PI07JRqN8xMIG4V4YfGchV6ubYXBocAnVXfFeO+Ke9sFtYZqouxQAKXai+Vgx05G3uPqMge48JyZEsvvWs/bk3PCog4e0TSpO3tEhlcg0iljzmYEYyw8QapB8CBzB+RfyYyxYhK81q8wN1X3y98rSdFlb06TfXf+oUsWwTpfzeYRiVeqCEA5EFDeQKu7j9d+5BITrXpzdxgdLHoTk1P5MWfT578JXsOrMq+TgIUPCK/BSdWrUH03+9o+hCuyfEYej9O5ZK0cZD7Wz3HYa4ePe0CzvGSSW8HQ4TCjrBT47D6pkiPu5IeCM6eWFRKvFK6Ct1DbiidMypZ9nyKbXz7AnlnR1Fy2nPXl/oFADe439k8yJCihz+me7OiAMJbTLHNzmkLTvmIXYU5AmirkdpKNkUlJVkU80wyhSx8n7H3sUMdLauI566iehxPWPOWnlEmxHbGZTO9ZfFGEVoW6jKnS9aMI1FmmFBtVd48uob7lckKGeobRLxgFawgOvpQ/SAfldx+02Mtl8IXpGvtkIvL0U2FX/OJORqZYfPmPRpX/u2uvX26OlEQrtq6XP36tSLC/JHEqQAykIh33oD5sREgBAxQculOWDYiMdTTI
 5dEsCQ3d
 vP6XTNJj4mInh/QP0PmLBTnAqZ6fJ8DT1Qd73hWXpzhrAa8aVD/W3QFQYqsIcWCI0F4Wv85vMfh8h9L9ASWAKmg+0UFhcYEKW9MOBsbQ1dGSnMQI2lpH/k9JMNlfUeyVvv4efdQfzHcq8t9hiOkWfiJfh1ejgQ5jG+fD/I8zn47ERjvP+1Dl7lD/s8JO1GTq0uRQCLm0TA6S69jfpN4mE3GU2XdAAl57FW7CUwH39fX94T7BRbEwDoNkjrZt/aDu2+IxzxcAyEEyuzRd8ZNbOoh+ml2qM1xc3qAUJBE3/JTqw4zFnS65b+GhhAYSyuCrNvq7kllooRLBr8fA0pnOKOqXwtvokpYAJeOXCA7ZTn5mfgLFfBOBcXZ6WFdslFxq83MxGkp+DOcR1FG29D5fZiONra8edOqnrvQsJdotvzxZqH1JUKY3qBov6f8TkXyrffEPo9DeDXWAqEfvfrRwy4/6WkhpBT0S7O+ZrxMjl5xPigRX45l6U/UUWW5y8dGOvy7owBaNFeGbTwTwA3E2jNl6buMxG73S1VAvq0cw11Y14Ih6EN1AcwzkICFfDPQV6nqGYrflkBgtfGlE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 03:17:57PM -0800, Jiaqi Yan wrote:
> Hi Vlastimil,
>
> Could you and other page_alloc.c reviewers share your thoughts on this
> patchset? Thanks!

Hi Jiaqi,

I guess you are blocked on review here, did you intend to return to this?

I'd suggest attempted a respin to get some movement here as clearly this slipped
through the gaps last cycle.

Cheers, Lorenzo

>
> On Mon, Feb 2, 2026 at 11:41 AM Jiaqi Yan <jiaqiyan@google.com> wrote:
> >
> > At the end of dissolve_free_hugetlb_folio() that a free HugeTLB
> > folio becomes non-HugeTLB, it is released to buddy allocator
> > as a high-order folio, e.g. a folio that contains 262144 pages
> > if the folio was a 1G HugeTLB hugepage.
> >
> > This is problematic if the HugeTLB hugepage contained HWPoison
> > subpages. In that case, since buddy allocator does not check
> > HWPoison for non-zero-order folio, the raw HWPoison page can
> > be given out with its buddy page and be re-used by either
> > kernel or userspace.
> >
> > Memory failure recovery (MFR) in kernel does attempt to take
> > raw HWPoison page off buddy allocator after
> > dissolve_free_hugetlb_folio(). However, there is always a time
> > window between dissolve_free_hugetlb_folio() frees a HWPoison
> > high-order folio to buddy allocator and MFR takes HWPoison
> > raw page off buddy allocator.
> >
> > Another similar situation is when a transparent huge page (THP)
> > is handled by MFR but splitting failed. Such THP will eventually
> > be released to buddy allocator when owning userspace processes
> > are gone, but with certain subpages having HWPoison [9].
> >
> > One obvious way to avoid both problems is to add page sanity
> > checks in page allocate or free path. However, it is against
> > the past efforts to reduce sanity check overhead [1,2,3].
> >
> > Introduce free_has_hwpoisoned() to only free the healthy pages
> > and excludes the HWPoison ones in the high-order folio.
> > free_has_hwpoisoned() happens at the end of free_pages_prepare(),
> > which already deals with both decomposing the original compound
> > page, updating page metadata like alloc tag and page owner.
> > It is also only applied when PG_has_hwpoisoned indicates folio
> > contains certain HWPoison page(s) for performance reason.
> > Its idea is to iterate through the sub-pages of the folio to
> > identify contiguous ranges of healthy pages. Instead of freeing
> > pages one by one, decompose healthy ranges into the largest
> > possible blocks. Each block is freed via free_one_page() directly.
> >
> > free_has_hwpoisoned() has linear time complexity wrt the number
> > of pages in the folio. While the power-of-two decomposition
> > ensures that the number of calls to the buddy allocator is
> > logarithmic for each contiguous healthy range, the mandatory
> > linear scan of pages to identify PageHWPoison defines the
> > overall time complexity.
> >
> > I tested with some test-only code [4] and hugetlb-mfr [5], by
> > checking the status of pcplist and freelist immediately after
> > dissolve_free_hugetlb_folio() a free 2M or 1G hugetlb page that
> > contains 1~8 HWPoison raw pages:
> >
> > - HWPoison pages are excluded by free_has_hwpoisoned().
> >
> > - Some healthy pages can be in zone->per_cpu_pageset (pcplist)
> >   because pcp_count is not high enough. Many healthy pages are
> >   in some order's zone->free_area[order].free_list (freelist).
> >
> > - In rare cases, some healthy pages are in neither pcplist
> >   nor freelist. My best guest is they are allocated before
> >   the test checks.
> >
> > To illustrate the latency free_has_hwpoisoned() added to the
> > memory freeing path, I tested its time cost with 8 HWPoison
> > pages with instrument code in [4] for 20 sample runs:
> >
> > - Has HWPoison path: mean=1448us, stdev=174ms
> >
> > - No HWPoison path: mean=66us, stdev=6us
> >
> > free_has_hwpoisoned() is around 22x the baseline. It is far from
> > triggering soft lockup, and the cost is fair for handling
> > exceptional hardware memory errors.
> >
> > With free_has_hwpoisoned() ensuring HWPoison pages never made into
> > buddy allocator, MFR don't need to take_page_off_buddy() anymore
> > after disovling HWPoison hugepages. So replace __page_handle_poison()
> > with new __hugepage_handle_poison() for HugeTLB specific call sites.
> >
> > Based on commit 8dfce8991b95d ("Merge tag 'pinctrl-v6.19-3' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl")
> >
> > Changelog
> >
> > v3 [8] -> v4
> >
> > - Address comments from Zi Yan, Miaohe Lin, Harry Yoo.
> >
> > - Set has_hwpoisoned flag after introducing free_has_hwpoisoned().
> >
> > - Unwrap free_pages_prepare_has_hwpoisoned() into free_pages_prepare().
> >
> > - If folio has HWPoison, its healthy pages will be freed with FPI_NONE
> >   right in free_pages_prepare(), who returns false to indicate caller
> >   should not proceeding its own freeing action.
> >
> > - Rework the commit on __page_handle_poison(). Only change the handling
> >   for HWPoison HugeTLB page, leaving free buddy page and soft offline
> >   handling alone.
> >
> > v2 [7] -> v3:
> >
> > - Address comments from Mathew Wilcox, Harry Hoo, Miaohe Lin.
> >
> > - Let free_has_hwpoisoned() happen after free_pages_prepare(),
> >   which help to deal with decomposing the original compound page,
> >   and with page metadata like alloc tag and page owner.
> >
> > - Tested with "page_owner=on" and CONFIG_MEM_ALLOC_PROFILING*=y.
> >
> > - Wrap checking PG_has_hwpoisoned and free_has_hwpoisoned() into
> >   free_pages_prepare_has_hwpoisoned(), which replaces
> >   free_pages_prepare() calls in free_frozen_pages().
> >
> > - Rename free_has_hwpoison_page() to free_has_hwpoisoned().
> >
> > - Measure latency added by free_has_hwpoisoned().
> >
> > - Ensure struct page *end is only used for pointer arithmetic,
> >   instead of accessed as page.
> >
> > - Refactor page_handl_poison instead of just __page_handle_poison().
> >
> > v1 [6] -> v2:
> >
> > - Total reimplementation based on discussions with Mathew Wilcox,
> >   Harry Hoo, Zi Yan etc
> >
> > - hugetlb_free_hwpoison_folio() => free_has_hwpoison_pages().
> >
> > - Utilize has_hwpoisoned flag to tell buddy allocator a high-order
> >   folio contains HWPoison.
> >
> > - Simplify __page_handle_poison() given that the HWPoison page(s)
> >   won't be freed within high-order folio.
> >
> > [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net
> > [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net
> > [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> > [4] https://drive.google.com/file/d/1CzJn1Cc4wCCm183Y77h244fyZIkTLzCt/view?usp=sharing
> > [5] https://lore.kernel.org/linux-mm/20251116013223.1557158-3-jiaqiyan@google.com
> > [6] https://lore.kernel.org/linux-mm/20251116014721.1561456-1-jiaqiyan@google.com
> > [7] https://lore.kernel.org/linux-mm/20251219183346.3627510-1-jiaqiyan@google.com
> > [8] https://lore.kernel.org/linux-mm/20260112004923.888429-1-jiaqiyan@google.com
> > [9] https://lore.kernel.org/linux-mm/20260113205441.506897-1-boudewijn@delta-utec.com
> >
> > Jiaqi Yan (3):
> >   mm/page_alloc: only free healthy pages in high-order has_hwpoisoned
> >     folio
> >   mm/memory-failure: set has_hwpoisoned flags on dissolved HugeTLB folio
> >   mm/memory-failure: skip take_page_off_buddy after dissolving HWPoison
> >     HugeTLB page
> >
> >  include/linux/page-flags.h |   2 +-
> >  mm/memory-failure.c        |  37 +++++++++--
> >  mm/page_alloc.c            | 133 ++++++++++++++++++++++++++++++++++++-
> >  3 files changed, 163 insertions(+), 9 deletions(-)
> >
> > --
> > 2.53.0.rc2.204.g2597b5adb4-goog
> >
>
>

