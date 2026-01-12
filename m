Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB33CD25031
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 00:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 113396B0088; Sun, 11 Jan 2026 19:49:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B3DE6B0089; Sun, 11 Jan 2026 19:49:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF55D6B008A; Sun, 11 Jan 2026 19:49:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DEFF26B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:49:30 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62CDC1413B1
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 00:49:30 +0000 (UTC)
X-FDA: 84321478500.05.4FA6BBD
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id AA63180007
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 00:49:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Xtp7Hq60;
	spf=pass (imf02.hostedemail.com: domain of 3F0VkaQgKCIQrqiyq6ivowwotm.kwutqv25-uus3iks.wzo@flex--jiaqiyan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3F0VkaQgKCIQrqiyq6ivowwotm.kwutqv25-uus3iks.wzo@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768178968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EqrYwOA/SKK2L1uqGSnc6LgyrcML9QFnO9Y/0CjSe2k=;
	b=3/B1cUX+f32D/9uevkMoSj8npsh5eDltrH2DwZ2+LjZE07rQRlZavSiGDrqE1Cb8mwDD2n
	DG7NeeaqivmHXF8DpYHLgn7v+qWAKGI/CZ4E0+9qTnRE0WzAYMHgfcd6dYilYS+7wiP3Lh
	vkGahxz4G1a/LFUrkw6VNATTehdWcNc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Xtp7Hq60;
	spf=pass (imf02.hostedemail.com: domain of 3F0VkaQgKCIQrqiyq6ivowwotm.kwutqv25-uus3iks.wzo@flex--jiaqiyan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3F0VkaQgKCIQrqiyq6ivowwotm.kwutqv25-uus3iks.wzo@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768178968; a=rsa-sha256;
	cv=none;
	b=LisRq8vWoZ70QlUwgXS28R7m1WKywVsLkIb1n3Gt7U6KjkIRNMiitmBW+UwHjyaKvCxiTh
	b0XSGZO4n9pgbWcy9hVJdMzQ3DKubQJuZPSjz+GfTAVBP4sZRgfacFw08bMwKg+l/dhfUs
	ndNZvgdne9T/ba+VB7ZZyXtRGczqD48=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34eb6589ed2so6178669a91.2
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 16:49:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768178967; x=1768783767; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EqrYwOA/SKK2L1uqGSnc6LgyrcML9QFnO9Y/0CjSe2k=;
        b=Xtp7Hq60RSlg6nVtwoBJqpzOhmAuyUAADaeTQnS4IuognQDPyw6sr4CVWnIUYMsQAt
         ngzrk0mQu/+Ne9oYWaGmlUWwKXjoMBm5NgxrLcR9L8Cgksm4mN5q+3FE1CwB1Vv37+j9
         7idPBhmVK81UocgxSvdx8Snc9+M26P9FIg+euuI99IcoYjvm/EuaG/yAKNF7/PQ5Ujac
         6GEpsksbAsD3u0uvGsuU5hh/fWOaVpoFLddW9CTIPqNyeLW/dpBjFVIddBdyzuYExIA0
         C4GeDBaLs+xfgHdGEocaJlAHRWdzlIw4a+eHnGCMbDwJ1pMRANTWAXOkrjj9Fe2b+QU4
         AzVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768178967; x=1768783767;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EqrYwOA/SKK2L1uqGSnc6LgyrcML9QFnO9Y/0CjSe2k=;
        b=CkiUQkxljgCWnCTRpOpXaGoIxh1dKfZvNO8j1Xftgs1C1yhmwwTlzyAeDTSGJz5jig
         YzfgHUvCZDK4lQYCQr9JD3XJFt31/Hr4FfC2eB2R/eatKH4XdGnJyah7Uk/LQiCbq0Wj
         mlFTsbqusOvYMYGEzA2oaY6YaSSrGjv/xzCt1IbBX5xY4wyxpClSDx7mbI95zdEU2tVJ
         Ih7itGhEDXa6oodybFeYKwhUN6ig6T06JnBC2YD92Rs/GAiIccLRCz0m/1YJX2sDTwlV
         VMmpVOYblSHIo+Haf3gzlk/e1Rs1Bp3TJNx3B9u32OaUhsGmaW/VjdnC0+C9/gnpe91/
         w7/g==
X-Forwarded-Encrypted: i=1; AJvYcCXW+de5+RCLtyNsvjubj7TJlcTgAn6qp43sFZMHkX2yWOsNe+nbnEPEqnJgNZCsgaanhXotEycBGw==@kvack.org
X-Gm-Message-State: AOJu0YwkRM6ygn1kOCfYhidYA3eDaU29m7+yQAp3bZZPmcxg6fT2b37a
	wuyqKlaktaLZEMV7mJuzVzbRUjQ9FS3MMg6mH4ygckmZ1MZ+NAceUukDD9L+HaOgSD6kbSagaTM
	Ig9th5jwqtYYf9A==
X-Google-Smtp-Source: AGHT+IGAM5qyyxs1jxTgJvo0rmapMT3NR06icHbsNvYUhtDHrVEA7OLP9hcDkSNhOPUiw2WN2JX91JXWLGdtsQ==
X-Received: from pjxx14.prod.google.com ([2002:a17:90b:58ce:b0:340:6b70:821e])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1e0a:b0:34c:e5fc:faec with SMTP id 98e67ed59e1d1-34f68c3367fmr14390811a91.2.1768178967400;
 Sun, 11 Jan 2026 16:49:27 -0800 (PST)
Date: Mon, 12 Jan 2026 00:49:20 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260112004923.888429-1-jiaqiyan@google.com>
Subject: [PATCH v3 0/3] Only free healthy pages in high-order has_hwpoisoned folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, harry.yoo@oracle.com, willy@infradead.org
Cc: nao.horiguchi@gmail.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AA63180007
X-Stat-Signature: oqda55mdf5ncguagurfqx31i3ejxe34j
X-HE-Tag: 1768178968-63119
X-HE-Meta: U2FsdGVkX19YSdB6UuMNRDjXkeaMjPJIfPHfGljXHh8zu44IMCoAvyru4JsgaWhZj5WS1kmIrk9uoeZRjKudj+lXtRqsuACViR8eK3QIgSpHaU7u6b1DnAT86rpTHJWFGg7OYIsxYQIegcgZxr4KhdFt9K+/2NHZpQgnQhxYcs3GWTWeRzcepOO9lrhHC48itOnf2lIldoysvZ/qDlZhm5XeTG/KuMuBYxOkW1TWdAIZI4Ix09V+kysgVWZebSDKBIwefVQ6Hg0XQNoTyhPKRFcb3I/XRphF8W39fzjbxxMDf6WrJ8Cd9anqYQEBJczEFZ1Ml6ALyPnTambHabapMdB7vJzvHoqeM6SDFsSEr4i0jVfl+a6WRUfii/YPVcukuOAs6iCQs7VsxV/RBbqzqm8NvVDzkGw1cyKjzI5WAr/vAGddbtqIaFWVeqwb5TdKzaxfRZ4MOGUfyrMWqUkw6khJQ7DXm3T4EgZaC6jClByzRwUKCNpsSg2z2ZGYPVeL9out3N+0VyXQjwOVn5dDPb2p6xVh+sqqXlasFe5WfC7WJWcP7N/OjuqX0YnFz6sSPDDq4CbM+vWh+scahYTpytrEJX1xcYEPIc3V/zdpuuFZG1hZcDwQoKsx5BFzNJZQdzeUmmDlWl5V05tcVnl5n7Tfixj6XE/3kzX4cL2mA/KkKprZRhKBFogm2CYJl8lzZurKZaqjRIqQcQ1g95JAc5up4ROXpblrRpJ2ewL7+4ugSx3cwQpq2IQSlUC6DW3cbqXVREteWOLRNy2SeZA1PUd9Vr+H34GsDSf1qBFzx3qso5CZ4ongqqFvp2S0XvLR/TEYQtrVB/fbTWFs5/yLuaQ77oPc9inoPv/lYsEUXafX8zNpsSw9ZqIpCk31ETLHgCkpYVjytk9VuImNGKs1YY7CZl3ro5XsVYHx79CScBieuwrFzODR2+vbt6GufyCm10vxzhaoRqIpSXsLK4O
 bWB+XCqr
 DrYU01m16j78l7kxVpJAkA7km0CHqrAygNbR00ZRxSBkRavG081HM3go9O6Y2sGDrnMKhpvtAygOc4m5s7nXMKwUpq+huIAMtCwA/cC9SUHmSGxA9kVIHEe5oHyyTK3lgHzl9Cf0HWevXbR1mWolOluBcvEzS6LRamqc+ZqJMET+Yn/hTB3YeJ1Rj/Vegq9VXlDKIQQ+hUo4ZETMiaiafjaiCz1NVQiwwXDTnzis/VU4acSCzMVgxeBSFk3TV4ob04rXzU2uUynBlZSkp3VMfEYG8ifnqJ89xqtmbqG3KBEoMCTDE2+WnfwMbbai1epnEG2Xa9R1tKCXvimYxs5ZUp/cdWRjaXq/eDwA3tyqGaZoD+iiOx3Z8Vt++5NJJ3nyd1w9QHki+Hu/lhtQiGUAYwnBFUEEh8mRaxcLQg5IO0ZAoS11fblR97GqC2xKl/vOKOoJaTMWY7qw/73BCH9DGNxVJO6CZIDYFihgIVzh4dP6TvnK62tkjOgW8qWPbv5Qy0NaIAUmy+CiqRLGoYvMgDGJ0YAu+EEXNndQ6SFdCnpxYon39JpmNjYMmh26//xc+Kt/j7tCroVFn6jimZw/RdmAJ0TlK6F4D7fLVAoBfEItnFolSNsgShI87dsW+ZgFWkMnCa4Hxhbe8l4WJicSW3I0b5cCPxsigi7/LXZUvQDXsmbhbS6yppz3aw8DUe0uzRNKc6DZsjIK926g3R6SJ7CobEPRC22Y+g3BgX8vTnk6im26+e4khdFgpTDc/Y7vMeSOHK1/B17sE9/Cbv0aYXEddAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At the end of dissolve_free_hugetlb_folio() that a free HugeTLB
folio becomes non-HugeTLB, it is released to buddy allocator
as a high-order folio, e.g. a folio that contains 262144 pages
if the folio was a 1G HugeTLB hugepage.

This is problematic if the HugeTLB hugepage contained HWPoison
subpages. In that case, since buddy allocator does not check
HWPoison for non-zero-order folio, the raw HWPoison page can
be given out with its buddy page and be re-used by either
kernel or userspace.

Memory failure recovery (MFR) in kernel does attempt to take
raw HWPoison page off buddy allocator after
dissolve_free_hugetlb_folio(). However, there is always a time
window between dissolve_free_hugetlb_folio() frees a HWPoison
high-order folio to buddy allocator and MFR takes HWPoison
raw page off buddy allocator.

One obvious way to avoid this problem is to add page sanity
checks in page allocate or free path. However, it is against
the past efforts to reduce sanity check overhead [1,2,3].

Introduce free_has_hwpoisoned() to "salvage" the healthy pages
and excludes the HWPoison ones in the high-order folio.
free_has_hwpoisoned() happens after free_pages_prepare(),
which already deals with both decomposing the original compound
page, updating page metadata like alloc tag and page owner.
Its idea is to iterate through the sub-pages of the folio to
identify contiguous ranges of healthy pages. Instead of freeing
pages one by one, decompose healthy ranges into the largest
possible blocks. Each block is freed via free_one_page() directly.

free_has_hwpoisoned has linear time complexity wrt the number
of pages in the folio. While the power-of-two decomposition
ensures that the number of calls to the buddy allocator is
logarithmic for each contiguous healthy range, the mandatory
linear scan of pages to identify PageHWPoison defines the
overall time complexity.

I tested with some test-only code [4] and hugetlb-mfr [5], by
checking the status of pcplist and freelist immediately after
dissolve_free_hugetlb_folio() a free 2M or 1G hugetlb page that
contains 1~8 HWPoison raw pages:

- HWPoison pages are excluded by free_has_hwpoisoned().

- Some healthy pages can be in zone->per_cpu_pageset (pcplist)
  because pcp_count is not high enough. Many healthy pages are
  in some order's zone->free_area[order].free_list (freelist).

- In rare cases, some healthy pages are in neither pcplist
  nor freelist. My best guest is they are allocated before
  the test checks.

To illustrate the latency free_has_hwpoisoned() added to the
freeing memory path, I tested its time cost with 8 HWPoison
pages with instrument code in [4] for 20 sample runs:

- Has HWPoison path: mean=2.02ms, stdev=0.14ms

- No HWPoison path: mean=66us, stdev=6us

free_has_hwpoisoned() is around 30x the baseline. It is far from
triggering soft lockup, and the cost is fair for handling
exceptional hardware memory errors.

Given this nontrivial overhead, checking PG_has_hwpoisoned, doing
normal free_pages_prepare(), and doing free_has_hwpoisoned() when
necessary are wrapped in free_pages_prepare_has_hwpoisoned(), which
replaces free_pages_prepare() calls in free_frozen_pages().

With free_has_hwpoisoned() ensuring HWPoison pages never made into
buddy allocator, MFR don't need to take_page_off_buddy() anymore
after disovling HWPoison hugepages. So refactor page_handle_poison
to remove take_page_off_buddy() in case of hugepage, but still
take_page_off_buddy() in case of free buddy page.

Based on commit ccd1cdca5cd4 ("Merge tag 'nfsd-6.19-1' of git://git.kernel.org/pub/scm/linux/kernel/git/cel/linux")

Changelog

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

- Refactor page_handl_poison instead of just __page_handle_poison.

v1 [6] -> v2:

- Total reimplementation based on discussions with Mathew Wilcox,
  Harry Hoo, Zi Yan etc

- hugetlb_free_hwpoison_folio => free_has_hwpoison_pages.

- Utilize has_hwpoisoned flag to tell buddy allocator a high-order
  folio contains HWPoison.

- Simplify __page_handle_poison given that the HWPoison page(s)
  won't be freed within high-order folio.

[1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net
[2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net
[3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
[4] https://drive.google.com/file/d/1CzJn1Cc4wCCm183Y77h244fyZIkTLzCt/view?usp=sharing
[5] https://lore.kernel.org/linux-mm/20251116013223.1557158-3-jiaqiyan@google.com
[6] https://lore.kernel.org/linux-mm/20251116014721.1561456-1-jiaqiyan@google.com
[7] https://lore.kernel.org/linux-mm/20251219183346.3627510-1-jiaqiyan@google.com

Jiaqi Yan (3):
  mm/memory-failure: set has_hwpoisoned flags on HugeTLB folio
  mm/page_alloc: only free healthy pages in high-order has_hwpoisoned
    folio
  mm/memory-failure: refactor page_handle_poison()

 include/linux/page-flags.h |   2 +-
 mm/memory-failure.c        |  85 ++++++++++----------
 mm/page_alloc.c            | 157 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 197 insertions(+), 47 deletions(-)

-- 
2.52.0.457.g6b5491de43-goog


