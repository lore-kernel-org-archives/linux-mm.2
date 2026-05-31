Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E36ACD6E51
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 05:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28E546B00F7; Sun, 31 May 2026 01:58:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265F46B00F8; Sun, 31 May 2026 01:58:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154A76B00F9; Sun, 31 May 2026 01:58:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 047856B00F7
	for <linux-mm@kvack.org>; Sun, 31 May 2026 01:58:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88968A0386
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:58:35 +0000 (UTC)
X-FDA: 84826660590.08.019D0DE
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf08.hostedemail.com (Postfix) with ESMTP id C1B4E160005
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:58:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="BZ/OCkCy";
	spf=pass (imf08.hostedemail.com: domain of 3CM4baggKCGsSRJZRhJWPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jiaqiyan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3CM4baggKCGsSRJZRhJWPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780207113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dr+9qq/jAcebHDP2TjTQz0UYWksq816yOQ7d10bXinE=;
	b=s7kMHkw+frbCSC5/IXuN86h3HeLSZ+BwNU2Dy+ECsNQXz0ADiHAgY0Fr+tXDCAY/qJncIW
	rvtVJOx9YyZikWptSQ0obS3lspt9H1C7F/GkfN9tFlDgby1ZUh+RYtuSdmPoK1kGvB0CdE
	oiR/6otTdOfBfyMPMcwRvs67qCpydzg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="BZ/OCkCy";
	spf=pass (imf08.hostedemail.com: domain of 3CM4baggKCGsSRJZRhJWPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jiaqiyan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3CM4baggKCGsSRJZRhJWPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780207113; a=rsa-sha256;
	cv=none;
	b=tuNXdjbYDZVH/P3UMO+UMTwFAzM9gJPnMwE8NJseDy53zgdWCyk1xCUgy9agOXCRzqS0d3
	PMVTQGJLb8TrumtJ9JDHzquC2Yv6Y123gBEWLrO4RlrllXLzIH5NLpW1/35fuEUNqAFpO+
	k/J9bDSMcNEE0EKtHTHEW2/vaiJciTY=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2c0c272e532so3399275ad.1
        for <linux-mm@kvack.org>; Sat, 30 May 2026 22:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780207112; x=1780811912; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dr+9qq/jAcebHDP2TjTQz0UYWksq816yOQ7d10bXinE=;
        b=BZ/OCkCyyTReANcFQ6OWEcsnADp7zI/AetsKOzLuDrx3AcDrlE6zoLn/EX6998TWB/
         tFHb/foVRPG3BDhRaphnoHSt2TcdqHtbeYoVgM0wbtN8WH9cVEAqMTmcZdQT//BUEL+K
         66w9ejMiOE0+HgaW3DMMKciPhlgv7Z0j7yqzpkvJ6zTfm1eMGxPP3jhWfXZVbD8qz1/l
         hPfuDBeJo+olYe0FkpDDGnCs0vasMsvhcRIx0rEyTNyzYNDMyDkuKCIC1vwWF7x/44te
         Xsw6Mj2jjvFhSgC/zJNFB5aK863TMIl7MRjfdbkAqkcN61131sq+MIQVI2n+Rb528Udw
         8Hzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780207112; x=1780811912;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dr+9qq/jAcebHDP2TjTQz0UYWksq816yOQ7d10bXinE=;
        b=sbfFHTWy5Z105PnjYEmtUoQjK6lXbfW2kxj5wakMPKNiUwahc6SaK7u7p7VLDQ8cqt
         UPRCsppdxstchiIJy1n67qmZWwYEjgiqkdVFHokkHGJWwfnN6bsLsXO9y6/JnGW5UebU
         XvJT+l2/rRjj1HChBUOAl17O0T11jKpcOzmTsnrFHxQoroPTDleZrSr1sq3xKp7wLA15
         sxVzBBem1ul0Tzu4FXvjEfT+TgNSGijRAlm5kXW0+EE+nP6Q2gMTU29HAf/y5XhEJ9hY
         zWpyiiPoZduyfgQ1yll4vDPOEC4xMBZCKVoUVmCfamv9BaHa/OMlTQic0W0yXsegG0Rd
         U1Eg==
X-Forwarded-Encrypted: i=1; AFNElJ/VUpdsuzkBfAPlC6dV6FaehGenGRsN+lKgo4AHeoCMn2eOAUCHg99dgInmfXh3hHL8zDl0T32JJA==@kvack.org
X-Gm-Message-State: AOJu0Ywt0sJhNvJbHKsZVSYoClxoFXlutN0Hx4zv7ra8zQEmfneOhoBz
	gR+Rgyqtp7L8FXD4Uw3sywRL2rWmwGYAEotjwMBG1HzNWyQ8C+eJ/kuZAbs/wNN7ZHIzacx9XcH
	vYjCwgFF1+HwYcg==
X-Received: from plbkt11.prod.google.com ([2002:a17:903:88b:b0:2be:fd11:30f4])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ecc4:b0:2bd:2458:50d4 with SMTP id d9443c01a7336-2bf368cbb55mr67088825ad.41.1780207112324;
 Sat, 30 May 2026 22:58:32 -0700 (PDT)
Date: Sun, 31 May 2026 05:58:25 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260531055829.3636554-1-jiaqiyan@google.com>
Subject: [PATCH v5 0/4] Only free healthy pages in high-order has_hwpoisoned folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: ljs@kernel.org, linmiaohe@huawei.com, osalvador@kernel.org, ziy@nvidia.com, 
	harry.yoo@oracle.com, willy@infradead.org
Cc: osalvador@suse.de, lorenzo.stoakes@oracle.com, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	liam@infradead.org, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8jbi7i44y4666xy546ffz9exwwb4ejd5
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C1B4E160005
X-HE-Tag: 1780207113-504641
X-HE-Meta: U2FsdGVkX1/sY65hKXjqgOLclcM4WNlU/tB4wmposTogQIE4ZL+eDKloCg9+40CDp64ypdNhQTPFCdAluKwD6REdr/O+DnehaBzl8DH96kG5Sqw5tUwaakb++w/gfknyB7gLCqCbBYEI1aAWCLGRSQC7xXtOpnaXmErMy3+c1RCeeQXSBXmjz7mRdBrYxWd/T8Wk0nqbr9ZyX+JoQ2dmpSNtwIZWMI9Qa8RIBtSY7NwrHuyMC4TSuSAkC8qhnQucKqBz2k7UYqTtlkyL1gsBJ3+yzmPrBEyA5/Iox+PoKZQWQLXaALZ+yyKZZznjQDIWCPlU4tZwxama9v4XMs067+NoMpkiUwHjG3IzVbt8Q/WK/D/9cEgsxj8IG9dqoSqJfGING8aBi/ZO2XS+7pZBdYT3r0+9XExWSLxJCv/3vDu6m6tDqDxqIiSxMw13aM5hzn8FRwy/myorCD2ArzItkaVGdKEZjtzlbJTu4rEylsEUGF6xkaYhy+b0O+hdrc31aeY3fpJfDOqvW77G4wGZeb2/1RAdQ05dHmGToUSdXrJYbvLEFH7QuElWGXTIGePLL/haHgyEQpyBYiSDqr+lj3DSu8Ke81Sst28qHDpe3U+MmdiuRW7O2FHCug8oIROA4jOtukxCBLSDu1Jx2nyVOORF03jD+PZdLpcKbzypmwocZvr1SY/7HcMSSiUWss/C6iwVNizr7k0Z2sL3y7LsfExxGK1HXPjFM5LvfZSqBO36wdqg7e5Z5mzsSgS2BKxkIPzBibW9pE7ZYcbHZRfPm0RjjpTGQ+BBCd91vpFvXH19VrqNAsCBprKupIxskqIrBIOLFAUXsmLw5WzWqr1prmAjNO7oaKCjCw+zFVJyZEWAUWd1LLWcnuiVUnoQzuWKjddIcQx4vswoYMurSG7VvZf+M08ReUQiPcgyaVwFGipYx+6/kEfpg/tpQlKLESLZIyKY2jUO5WruLT62qMl
 uGdyfuOb
 lk8Q+54KEnaBkYH5dVlFiFAQFskA3D/A0yoZ7mW9HZDM+Yl41DyZJpwhvWA6SsaNv5ETXJPXttswXES3bfci/FK9kVKQJw4O8Ad/UPOsqx3recBl9eP1XMzp2vJxTg8g5SfsWTRQuu9qTnk35kp1jQijz4UDCLr8QTRFpZXBCpMJJgeIv/+Gdmb5UYHbYQkFWGLMoXj5yvqNmcO0bm5jwN2nxFHVTDJBih3hFE6VinO/+5o/02KfLeYrjIPXGdBL9Qf4HKG7DQL3u7UbZLAq1Sv2tJbXlURIcz8NYTFSCqgJfOeb9/3EMKxetMmC0haX56AqcYPWU6AanVU9fEHCG/MxblIS50b94ztv9M7ZURQfR306xKsz9Zk9ywrRN5j3PaM56H8PAPqgcYt4PSWvkCFdZhKMyZssn/7kTFqXYip2BIjf5BlktmLzdcmc4rymAo6zqJLA9ddNJEVR4kuQGXvTACSXB17o+72QBeFmSGTm+xQakO68Rr7SkeeHMXjP1+aaMf05/l35lODIlARQeeVOL5w7gjYcKZIjRhiwxT9iiGrxfqRtZfDWxrEKujwg1LAFGLR2w/078Wu4Fmd8kTnCU24vYo2+D9ca2i1ltU99dll3rSD6Jg1a0HkyE15AC7FoXQIJsOMLnRWoaMz/0HWhDQp6nVKfDbiTOfeQvnnmqXv3L6B0DAkY8IHR4yLigRCGQdmlsOC0Q6BSc5ogZUeVQGT8WIE1VRXKPNhFQWCMbx6HOsmo9gf0tsiyEMAvdO/lMxAEcrdyzTDka/7kI9+UB9qfpJcEnc+vDa0GqzqTjf/9Dk106Szpw/Qn6yGxkN9MYXxXvZW5sxT3Fo8SPEaflfb8s9qxg5CE8aibLEZsGtFcCcJ+14l0X0FLAGvm2blfvA0s44tBcmwo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At the end of dissolve_free_hugetlb_folio(), a free HugeTLB
folio becomes non-HugeTLB and is released to buddy allocator
as a high-order folio, e.g. a folio that contains 262144 pages
if the folio was a 1G HugeTLB hugepage.

This is problematic if the HugeTLB hugepage contained HWPoison
subpages. In that case, since buddy allocator does not check
HWPoison for non-zero-order folio, the raw HWPoison page can
be given out with its buddy page and be re-used by either
kernel or userspace.

Memory failure recovery (MFR) code (mm/memory-failure.c) does
attempt to take raw HWPoison page off buddy allocator after
dissolve_free_hugetlb_folio(). However, there is always a time
window between dissolve_free_hugetlb_folio() frees a HWPoison
high-order folio to buddy allocator and MFR takes HWPoison
raw page off buddy allocator.

Another similar situation is when a transparent huge page (THP)
is handled by MFR but splitting failed. Such THP will eventually
be released to buddy allocator when owning userspace processes
are gone, but with certain subpages having HWPoison [9].

One obvious way to avoid both problems is to add page sanity
checks in page allocate or free path. However, it is against
the past efforts to reduce sanity check overhead [1,2,3].

Introduce free_has_hwpoisoned() to only free the healthy pages
and excludes the HWPoison ones in the high-order folio.
free_has_hwpoisoned() happens at the end of free_pages_prepare(),
which already deals with both decomposing the original compound
page, updating page metadata like alloc tag and page owner.
It is also only applied when PG_has_hwpoisoned indicates folio
contains certain HWPoison page(s) for performance reason.
Its idea is to iterate through the sub-pages of the folio to
identify contiguous ranges of healthy pages. Instead of freeing
pages one by one, free_has_hwpoisoned() then re-use
free_prepared_contig_range() [11] to decompose healthy ranges into
the largest possible chunks of different orders. Every chunk is
freed via free_one_page().

free_has_hwpoisoned() has linear time complexity wrt the number
of pages in the folio. While the power-of-two decomposition
ensures that the number of calls to the buddy allocator is
logarithmic for each contiguous healthy range, the mandatory
linear scan of pages to identify PageHWPoison defines the
overall time complexity.

I tested with some test-only code [4] and hugetlb-mfr [5], by
checking the status of pcplist and freelist immediately after
dissolve_free_hugetlb_folio() a free 2M or 1G HugeTLB page that
contains 1~8 HWPoison raw pages:

- HWPoison pages are excluded by free_has_hwpoisoned().

- Some healthy pages can be in zone->per_cpu_pageset (pcplist)
  because pcp_count is not high enough. Many healthy pages are
  in some order's zone->free_area[order].free_list (freelist).

- In rare cases, some healthy pages are in neither pcplist
  nor freelist. My best guest is they are allocated before
  the test checks.

To illustrate the latency free_has_hwpoisoned() added to the
memory freeing path, I tested its time cost with 8 HWPoison
pages with instrument code in [4] for 20 sample runs on a machine
having 56 Intel Skylake physical cores and 768GB memory:

- Has HWPoison path: mean=1030us, stdev=21us

- No HWPoison path: mean=66us, stdev=6us

free_has_hwpoisoned() is around 15x the baseline. Its cost is
nontrivial, but still far from triggering soft lockup, and fair
for handling exceptional hardware memory errors.

Now that free_has_hwpoisoned() ensures HWPoison pages never made
into buddy allocator, MFR don't need to take_page_off_buddy() anymore
after disovling HWPoison hugepages. So replace __page_handle_poison()
with new __hugepage_handle_poison() for HugeTLB specific call sites.
It may worthy to note that this patchset doesn't affect the soft
offline behavior in MFR. This is because soft offline does not
folio_set_hwpoison() upfront, and for HugeTLB case, doesn't involve
get_huge_page_for_hwpoison().

To provide test coverage for the new __hugepage_handle_poison()
in me_huge_page(), the last commit adds a MADV_HARD test variant
for anonymous 1G HugeTLB pages. It also cover the code path that
frees a 1G HugeTLB page that contains 1 raw HWPoison page.

Based on commit 43eedcbb989c ("userfaultfd: make functions that are not used outside uffd static")

Changelog

v4 [10] -> v5

- Rebase to very recent akpm/mm-unstable.

- Re-use free_prepared_contig_range() introduced by [11], and remove
  free_contiguous_pages() in v4.

- Instead of using struct page pointer, iterate over pfn in
  free_has_hwpoison().

- Re-ested and re-evaluated free_has_hwpoison()'s time cost.

- Add memory failure recovery test for anonymous 1G HugeTLB page to
  gain test coverage for __hugepage_handle_poison() and for freeing
  1G HugeTLB page that has 1 HWPoison page.

v3 [8] -> v4

- Address comments from Zi Yan, Miaohe Lin, Harry Yoo.

- Set has_hwpoisoned flag after introducing free_has_hwpoisoned().

- Unwrap free_pages_prepare_has_hwpoisoned() into free_pages_prepare().

- If folio has HWPoison, its healthy pages will be freed with FPI_NONE
  right in free_pages_prepare(), who returns false to indicate caller
  should not proceeding its own freeing action.

- Rework the commit on __page_handle_poison. Only change the handling
  for HWPoison HugeTLB page, leaving free buddy page and soft offline
  handling alone.

v2 [7] -> v3:

- Address comments from Mathew Wilcox, Harry Hoo, Miaohe Lin.

- Let free_has_hwpoisoned() happen after free_pages_prepare(),
  which help to deal with decomposing the original compound page,
  and with page metadata like alloc tag and page owner.

- Tested with "page_owner=on" and CONFIG_MEM_ALLOC_PROFILING*=y.

- Wrap checking PG_has_hwpoisoned and free_has_hwpoisoned() into
  free_pages_prepare_has_hwpoisoned(), which replaces
  free_pages_prepare() calls in free_frozen_pages().

- Rename free_has_hwpoison_page() to free_has_hwpoisoned().

- Measure latency added by free_has_hwpoisoned().

- Ensure struct page *end is only used for pointer arithmetic,
  instead of accessed as page.

- Refactor page_handl_poison instead of just __page_handle_poison().

v1 [6] -> v2:

- Total reimplementation based on discussions with Mathew Wilcox,
  Harry Hoo, Zi Yan etc

- hugetlb_free_hwpoison_folio() => free_has_hwpoison_pages().

- Utilize has_hwpoisoned flag to tell buddy allocator a high-order
  folio contains HWPoison.

- Simplify __page_handle_poison() given that the HWPoison page(s)
  won't be freed within high-order folio.

[1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net
[2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net
[3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
[4] https://drive.google.com/file/d/1CzJn1Cc4wCCm183Y77h244fyZIkTLzCt/view?usp=sharing
[5] https://lore.kernel.org/linux-mm/20251116013223.1557158-3-jiaqiyan@google.com
[6] https://lore.kernel.org/linux-mm/20251116014721.1561456-1-jiaqiyan@google.com
[7] https://lore.kernel.org/linux-mm/20251219183346.3627510-1-jiaqiyan@google.com
[8] https://lore.kernel.org/linux-mm/20260112004923.888429-1-jiaqiyan@google.com
[9] https://lore.kernel.org/linux-mm/20260113205441.506897-1-boudewijn@delta-utec.com
[10] https://lore.kernel.org/linux-mm/20260202194125.2191216-1-jiaqiyan@google.com
[11] https://lore.kernel.org/all/20260401101634.2868165-2-usama.anjum@arm.com

Jiaqi Yan (4):
  mm/page_alloc: only free healthy pages in high-order has_hwpoisoned
    folio
  mm/memory-failure: set has_hwpoisoned flags on dissolved HugeTLB folio
  mm/memory-failure: skip take_page_off_buddy after dissolving HWPoison
    HugeTLB page
  selftests/mm: add hard memory failure anonymous 1G HugeTLB page test

 include/linux/page-flags.h                  |  2 +-
 mm/memory-failure.c                         | 37 +++++++--
 mm/page_alloc.c                             | 85 +++++++++++++++++++++
 tools/testing/selftests/mm/memory-failure.c | 73 ++++++++++++++++--
 4 files changed, 185 insertions(+), 12 deletions(-)

-- 
2.54.0.823.g6e5bcc1fc9-goog


