Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 980CDE7317E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 19:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C7276B0005; Mon,  2 Feb 2026 14:41:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94A746B0088; Mon,  2 Feb 2026 14:41:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856296B0089; Mon,  2 Feb 2026 14:41:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 737266B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:41:33 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DFD3FB698E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 19:41:32 +0000 (UTC)
X-FDA: 84400536024.09.D10388F
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id 34B6CA000A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 19:41:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OAsTjMh1;
	spf=pass (imf15.hostedemail.com: domain of 36f2AaQgKCDwhgYogwYlemmejc.amkjglsv-kkitYai.mpe@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=36f2AaQgKCDwhgYogwYlemmejc.amkjglsv-kkitYai.mpe@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770061291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=R651U2F7F++1pgrvVY/Dtwm4BL52ZLzQ9GK04apqwc0=;
	b=HF4iq0fiiUU8j+PcVoGuNV+SZBpLJX2aVnyn2wx27u1iZRPZU418cZR9nXKlM4WXRNydUc
	A1sp3RRQvyDgxpIp3YORjhBKrO9LyDl30etJjAM0s0eAKTFr+rozzdKa6nWjNNKum2KQYb
	bBElPDxl1BKvnpPRh72GgPh6rU3Mbug=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OAsTjMh1;
	spf=pass (imf15.hostedemail.com: domain of 36f2AaQgKCDwhgYogwYlemmejc.amkjglsv-kkitYai.mpe@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=36f2AaQgKCDwhgYogwYlemmejc.amkjglsv-kkitYai.mpe@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770061291; a=rsa-sha256;
	cv=none;
	b=MWJ7KM+zExAOPZEi+RhWn8rEEOKjTzZfHOv8j/1co6o8ioBWQxWvSQsOZsnwjuLJHi/xYi
	ymCKfGl7nkfMuoK5nR0uEPsBkjOOzHZqg1oRsRQ33zAYb77cthLfqgFl3H0lB84oTfsbhk
	2Kl7Dm72UFcohEnsWLDFyQE+zgTHgWQ=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a7701b6353so49060815ad.3
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 11:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770061290; x=1770666090; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=R651U2F7F++1pgrvVY/Dtwm4BL52ZLzQ9GK04apqwc0=;
        b=OAsTjMh1Bcu9uRYzYFWy1FTyHH5fMnK3MoioXl/dFYSTzv5LuGWTJCbe19MjRvonn/
         hrxUsM11G8Hk/3wg8LstoH180Xt9FzAF+INqCR61+XGRXGDJ7eNg6y1TClq+RDJPbyMO
         IhNeHVPSVmoDltYXzUwfCKdPX9NmzoqqoOUB4aAhDIfTvhE+1ahMf8NVd6IGDRMSP1gx
         1DR6KAZR/krGzm8PuY7b+sG90fZOoKnGDaE4PjYbHRpq18O0+h/DHT64nmW4oup9atv+
         CV0ELLzStYFlkD+u0PFPS+nRmW40MUineZxZtFwzjPFSLyAKmMcPWh/LWWmUTExWLUIV
         UeZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770061290; x=1770666090;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R651U2F7F++1pgrvVY/Dtwm4BL52ZLzQ9GK04apqwc0=;
        b=BCPRTuq+XeHFrto0Yi7F3hd3UJUFtROeBumSD09WlhLUGOeaNwnKX+a7/xlcgB+gS2
         y7x+/TQHkglRzQvXzcVX8AFU00HO+DVBIDKsCCTpXpBJTJ0wPr5LLqIb+v2S3gvOe/o5
         8wtxDaFrJKKWVeT8dMVlcXbAWxdv75jh5nIEwgLXXxpzE58e0MEX2t1N0IdJFLqqcpmw
         hgt4vccqQWi8afUBfcQcL4M5vI8IFt04T/a8/lKCLGokIIjCs/TgJtVrru0mX6eZ8Hnt
         vh1PZEQNbT8IsNEAFoLrSh+n1mei30paY+q/ElsSZr/4azr624Mhs1qWSrHPXL7LvYxw
         NXqg==
X-Forwarded-Encrypted: i=1; AJvYcCVpU5N41SZBP0bISZ3i+NMkzI+jFKGO7F9IgT+jefVMVOi8+DsCcs0spdq7Te/4kmvbvJOpa2+vvA==@kvack.org
X-Gm-Message-State: AOJu0YwPImpyxnRjZd4eOvpYUv0B2FGsxc3qu2ai86JN0w4CuNBfLWWY
	Qv3RTw//Bxc1Cndgp/OpQ8qs6K9HLj6Lp4/3vhSTLEvTKTFTaoSrvi0OnBfUZ5/NXoDIbGXBdB3
	lIkgOjgkjzNrHAQ==
X-Received: from plqt11.prod.google.com ([2002:a17:902:a5cb:b0:2a7:80f3:ce5a])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1590:b0:2a8:fc56:a3e6 with SMTP id d9443c01a7336-2a8fc56aa0fmr66145035ad.24.1770061289697;
 Mon, 02 Feb 2026 11:41:29 -0800 (PST)
Date: Mon,  2 Feb 2026 19:41:22 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202194125.2191216-1-jiaqiyan@google.com>
Subject: [PATCH v4 0/3] Only free healthy pages in high-order has_hwpoisoned folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, harry.yoo@oracle.com, willy@infradead.org
Cc: nao.horiguchi@gmail.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: g5uboyfp9d9hudjq1e113k68dpnuopjz
X-Rspamd-Queue-Id: 34B6CA000A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770061291-980348
X-HE-Meta: U2FsdGVkX1+A66rruZQfxD09kux6UCgTo3VZTiOQ98gQG/icOiVcmSLsvA9sjnEwL8qT5vDcbjoKLJFdBg5JWdgi/eaPPlgvFGjZwMl2+Hw9Km0CMXgTU3VRh8w9ajKnOaaUZp0RukrTMvnAz7DLl514k47Q3taIGtC6BGjZO81mLUW78oO8R0xhcm5eEV0fp2bvVVL8ZAN530R4A2f+7KkWJGdR0JdF+BtsoKmc7EfRB9s3wuPrTrEiijx0/9BnjP7dbCaMMjIHypcQGqu8Ey+iT34fLGlYsUpD75h1Zs5rvWBnhcnc/XLobTU7d1XPtOpGU1DR3x2JPJ5qQRQGT9oBSmd3QffEpSrjaKFAb+8Piff39kcCcMVYpPs3pzVa03C3YVerEQzsR//u2AKMaLchf1w0nRmuHZYAZUTlRG8mZSkNz4vzl5m1OdTuQn8T7us87KTzCvM2mblLmEA/mPGsYScpuq3/fWNO+zbELVdLF+NhaJMq2nLb/MHYXIwtqLXABbTVh3uAuZkQ9bfILhnJPEybiAwMBpiDVjgbgEMtNTy1wV5NwWDNLzvyW9szfQQEE5DCSy7dFXMc6hTiOq7pQrQN4sF9J60hwUnIH2vL1X58KZsI4xOWa/D0ByN/7ySq7L3S5gD4tYIpaJg6+KYDv8Kl9swcAs/ZFdPUidl5eEm1JpRnKK1cOxkRZ9KjbaFR1ZyLmUEcEcWcKBsdMSDd+0QBm8f531MRUXZnXq72t1OxqfgXo+yXhoHykZlaOS/3jQm3hQdJj5W6CLbl/761LNqedF6FmUGVC/y2NOOflnphK+8lRO2rhedGwufev4qwCHHw9vf7mY75EIv+h3qJsOLAG2rkz4IqgquelCpZ9or6FmfUy1Y2Z2XZWca5JYehBWQUxUpEkhdH5KC459hfvsj3g+Jxfkg/oTWXYHPonuCDrK2b0pSeAUJ2CDDumz5IGCcAu30nCBWKG/s
 IzwqyMzy
 zovrOhZ2uo1pZX9qD8ayFzEiO0pyx+yyB5oST0eQn/Xp/8XgdHzPaTHopiJCtNU1s4lffIQpNMEwjIwDHU5uWY7KQ/8aM4Evn+x/IXeJRBIphWrBhBmIG1lnQ/aET+eSdiEjCK3lxHB1vY1yOm07VWoRUdDExQnUaWfhL42zW/vx0Hdy+cvKvzgudxnuEt+QXMh/tLkJicjR+VE2vrykQ8UgvJVgYpyCw0FYy8/I6AFxwXuwHines0zNilpAjfr62HAd6P7znnZHjFMMJnZlgGoDWKOTtGG6A6708/0Em7DxC/qhC8MB8TTDbAigWOiGo5Y3XIIVktN98wJcK0AlglG3XyFxc7NP5G8yf0aDXTAWqZ0ZoR2FXGKscsMPfGQ71kvgbx6TvbyaQbYwG9WDq8ay/XDuGDLxq4xzndqufEBXtMaHlz+Ow5jb/nDTk4gIhf634amgJCvn7gmESsCfJffOOY7IYH+L2IkvnbCgqbwJe0A4J7KfARxs+lJmPuhQrSnIMEf8+Y+dFT4nBndaIamjvhvIwe44owmdwG6KrKy3HhHplom0VDUBuurZT/ENOcjnWsGwuy91d93ThfxsTkB1FpXlOf+Ic2wEMmZSmUxCEjDaon/6QDXKvPvW7pO5xR0Q3eklJoN3Tdzl+w9cn6TiLLZ3okiXsmlFmyA95vNs/KTxbFm6ij7LiYQ8TBHLf1BtVtLXeJmF9LglLOq+TeFRz3X/sneB8wm3jlS6QFNO8GT9UKlXZljZHLvgDozSD0dLsqx80PDuZ70hL61uOdcyMnVqvj20WYiqSJRFUUlbOZuWBY+zufaZdhUw8HZHumVab0RBRv8h30DhNUadVyrntFQ==
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
pages one by one, decompose healthy ranges into the largest
possible blocks. Each block is freed via free_one_page() directly.

free_has_hwpoisoned() has linear time complexity wrt the number
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
memory freeing path, I tested its time cost with 8 HWPoison
pages with instrument code in [4] for 20 sample runs:

- Has HWPoison path: mean=1448us, stdev=174ms

- No HWPoison path: mean=66us, stdev=6us

free_has_hwpoisoned() is around 22x the baseline. It is far from
triggering soft lockup, and the cost is fair for handling
exceptional hardware memory errors.

With free_has_hwpoisoned() ensuring HWPoison pages never made into
buddy allocator, MFR don't need to take_page_off_buddy() anymore
after disovling HWPoison hugepages. So replace __page_handle_poison()
with new __hugepage_handle_poison() for HugeTLB specific call sites.

Based on commit 8dfce8991b95d ("Merge tag 'pinctrl-v6.19-3' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl")

Changelog

v3 [8] -> v4

- Address comments from Zi Yan, Miaohe Lin, Harry Yoo.

- Set has_hwpoisoned flag after introducing free_has_hwpoisoned().

- Unwrap free_pages_prepare_has_hwpoisoned() into free_pages_prepare().

- If folio has HWPoison, its healthy pages will be freed with FPI_NONE
  right in free_pages_prepare(), who returns false to indicate caller
  should not proceeding its own freeing action.

- Rework the commit on __page_handle_poison(). Only change the handling
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

Jiaqi Yan (3):
  mm/page_alloc: only free healthy pages in high-order has_hwpoisoned
    folio
  mm/memory-failure: set has_hwpoisoned flags on dissolved HugeTLB folio
  mm/memory-failure: skip take_page_off_buddy after dissolving HWPoison
    HugeTLB page

 include/linux/page-flags.h |   2 +-
 mm/memory-failure.c        |  37 +++++++++--
 mm/page_alloc.c            | 133 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 163 insertions(+), 9 deletions(-)

-- 
2.53.0.rc2.204.g2597b5adb4-goog


