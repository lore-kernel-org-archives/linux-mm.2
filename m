Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9025ECEBF88
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 01:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6FF8E002E; Sat, 15 Nov 2025 20:47:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C879F8E0005; Sat, 15 Nov 2025 20:47:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9D738E002E; Sat, 15 Nov 2025 20:47:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A634E8E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 20:47:27 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 544ECBBD25
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 01:47:27 +0000 (UTC)
X-FDA: 84114782934.18.C1481F4
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9A5F31A0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 01:47:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jh+9D02P;
	spf=pass (imf19.hostedemail.com: domain of 3LC0ZaQgKCDsgfXnfvXkdlldib.Zljifkru-jjhsXZh.lod@flex--jiaqiyan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3LC0ZaQgKCDsgfXnfvXkdlldib.Zljifkru-jjhsXZh.lod@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763257645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+XqlIsMDWzYqc7JguFqNqhha1T5Qhe5Y6rEy+19C3o0=;
	b=qjFH6Eaz5pdLZrNSxslr8Dl8j+FJvF2RDLOk0/JM9ggtSWfTDsUr0DbrSsrfUNg7OCDjae
	mclwFayAdL861SfuUvOU3LcPZLF4L6bfC0z6Q76PCBefwA8uwcHo4N9sXUKKxWnBYijf+w
	ypSmoYz9Kl0APYzIF8HPzWNcQuxNru4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763257645; a=rsa-sha256;
	cv=none;
	b=csf9n+1drRlGgCFk2XqF72cPuwCnzqBLVM45kBOkRddwG0HTx33ApdTOe0p8niInoVcioK
	5pfyPZ7hcRl2y+SrLwOcUr1jN8xb4Rns0xn+lyNn51fAbRyL9ig5B1TgnlepY6DMCSrJOL
	ym5jO2A/m8QOOI11dhJo29+tyU7/quY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jh+9D02P;
	spf=pass (imf19.hostedemail.com: domain of 3LC0ZaQgKCDsgfXnfvXkdlldib.Zljifkru-jjhsXZh.lod@flex--jiaqiyan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3LC0ZaQgKCDsgfXnfvXkdlldib.Zljifkru-jjhsXZh.lod@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-343823be748so4017554a91.0
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 17:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763257644; x=1763862444; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+XqlIsMDWzYqc7JguFqNqhha1T5Qhe5Y6rEy+19C3o0=;
        b=jh+9D02PLPbsvFJi0y2NbaF51faw88akU7iZR1ocFVnuQ13HUbu84BijlCByuVjjyb
         imvqwSAMOyr5I8SbAbkZV/Bxpkn2zyx0hqbNN4t7dw3Tpqb+SX03ONktmzuOtbnDmQ9l
         C1xwaNPu8iRIJtFy22fu+0R/csJHFLM5a8VDYLGF+B2NusLlRMIXvJj+XfvZcTQQ1BdI
         FjVplZPfwrBpanBxotTmrcXOHR4JCeEKq7KjHdq2XLKGLXAT+/GQQiVELyZe1gOkqTm1
         D/T8/cjIFD+S6Mvgaw211x/WJ2gWna0pAjFBhaZgtA4AdbQppjQkrSfh/iVNPKi4LoJ7
         txPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763257644; x=1763862444;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+XqlIsMDWzYqc7JguFqNqhha1T5Qhe5Y6rEy+19C3o0=;
        b=hQt3OJ330OK2HYrVYFkouK+S95x0kHIhj7BefLb0gONKd/rAzcaqq2lJlrfJu3jgRG
         K7YrqriJBs6NjOIjO6xvw9O4deeFkeWjdtQcMkjvwnsA3fTL/FLhNBcX5+3BRKeJwiVf
         vFnavF0/aanQaRA6H5rxRyY9fdwi9inVCwg9Uh+jIvg9HhTp7t3QVHc0lgyueqVcVLDH
         0xct7PG7pUYIj6wfYJ5TnBfKH+DM5PAmP+GEtJlT1dWrZD4x8AmvyuMJicl8JoI2e/lh
         I1I5b8Ll05KoXZZKejBtqGNqZmgGXwdB9F4qeuanokl/aoCIdol27zVZ1l8i1bxV2QTb
         wIVA==
X-Forwarded-Encrypted: i=1; AJvYcCUGNBz/aneT696GGpJRdiIqEDW0v8fwvYFa//LKg51NSs902EYSw7/TBBoSZNgj6KVI0osd+5pHvA==@kvack.org
X-Gm-Message-State: AOJu0Yx6Eo/hqdkJs8B4+GrBKNfg0E2uwicfI7bNK43/XpUGHPa3snCU
	n2d4FlmNan5rYBTwGIRuRBRxeTzwRLCGI4BkoXxgorXoaqplvTZFizxfk6tdiLaU9bl3aL9/zAm
	SAzE6b1cCarEe5Q==
X-Google-Smtp-Source: AGHT+IEsv7NHXWIs6Yu2rkIffMNoH1XQYTEANQjz5QTzo7SXbZIR8OEsdNaEZH+xmUiMVSFZfyDJEvVIa8rVaA==
X-Received: from pjub12.prod.google.com ([2002:a17:90a:cc0c:b0:340:d03e:4ed9])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3bcd:b0:341:3ea2:b625 with SMTP id 98e67ed59e1d1-343f9eb4416mr10268299a91.12.1763257644392;
 Sat, 15 Nov 2025 17:47:24 -0800 (PST)
Date: Sun, 16 Nov 2025 01:47:19 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251116014721.1561456-1-jiaqiyan@google.com>
Subject: [PATCH v1 0/2] Only free healthy pages in high-order HWPoison folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: nao.horiguchi@gmail.com, linmiaohe@huawei.com, ziy@nvidia.com
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, william.roche@oracle.com, 
	harry.yoo@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, jane.chu@oracle.com, akpm@linux-foundation.org, 
	osalvador@suse.de, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9A5F31A0005
X-Stat-Signature: fz43zc4zj98js9aip1iekd1z1ybbe7yc
X-Rspam-User: 
X-HE-Tag: 1763257645-450723
X-HE-Meta: U2FsdGVkX18h+gy68JmXAS7bmUoAnLG9r0uJnJAiXJKC/qHbKHub2ed+H8TIq8MYL97o9oOx3dXuYaT4j9RlVpXmjhbgoQ4pbuAPyfDBb2rocKCwrz1QrdcrUjx0D9fehNlviCwK59X8u8Sy7pt6Y+8gC9SIB7RYCOeJKJIuTFUsJbZmen063TVM+1CGrmxt4XBh3JP485uCe3pLqkd3Kv6JhOTETqzBCCxus101hl+32brl/Efa8HLdMVYEuWAj/dfcpTfdPxses95f6L2vAhMdR79Vw9E+f/Yfq5BGTY7bGVlfhe4FB51N9GTWs3ijQf1hxTYtKvzGeak4dQqJOkje4b0bvDeG0a5frPQAfdNIPDv1pEPqpvR+4LqCg4A4qhzXmW367La7mb7DUzOiRAZ9FG6A1M5UeFJfROqFfUYDiatyd//u4rRMzjQzl5jOCUdpuyaDmD7GH/S4wRTQzNXHl2tT6Ea8YMI+23WUFwjJ56vKeb0L2qzQLfyPbXL2xldHthM68D8XGGxjVoJkshOVLrgTHz9e1JuSPHmDSWX9K98SEKuzpQ0gIwXMQaEUaHlAT5tdMPTVutUk+vkG7GkB+FmQHifEvCmZIiw+kZbuahezxYZ1P5iDuwA3y3gxQ5vF/2KPMaO4oKuirdEXkIN9PdKTit9e0KojSoXRpgo481jT6HS3YJVYcKjnqdvbbLH7sO9SFsrJjh1Qu0EYE5REo5Z5ElOT6tcBOgMDmtq6h0CsxwqxGXN3jSHlv4wLDP5cXXbAhHSBCvDO0baHcFaV534MfXDiFyzrhT2IycMHwfNqJZbGsQNvTzXhm3Z6ayF38UsPaPUf3HlXhHHoZCRnTuIZrWyhHm+cRWhI2pyXlmWRoJHBqwwnNR2BFksZierqB1WrSD+UHEuvpk3OkFCevDwSIl2ySjUqazTuwQNyrcr3/m59SPGnQyQ4CoHNsIK29vxzL7xmZUbjcNJ
 GspeI6uq
 UeMnPCGqGo2Q8oNy/vxMy5PQ2l2hNwi4ljDUSETzusv+xyit1IxC053HqKzKetbICUwE1HJuN3ugAK+qxhBY++/0WVX0A2GuRi20U/sd1MIuqhAuTRggTHCK6tAg7S7N+T2So2QuipkxKPdgm2P1L2dvrbBd54dY4dvNLFoW7bQhqm3Oq/phOFwJaJXqTMoYV81koK+/To0OYmeaO0/vkJF54ECFdJIXU+n2eX7pEpuYNhtcU1b5z5houDyzDMmK3nW7KoKw3MBl8EOFsmceX/yT+r1QhDeiYyaTij/mO71EGchly5XPpq3wwjb053ZGj2br0Xg5WureR/hN2ySPHv4gXF+YJK5l3l9Wr9FBNDkt3EJEB8RC24x227MzROd9VOtgocEk/Q771jwyIWMDmzn57I/HnoCoEs6/sZTziDLwuAx8gy36ydJXyv+nlBYy/JUSTBRWy1Wgmxu94xK2uZY2h9g4I5vkKhVgp7iouRdqUvUrWLdsKKQ5KnGt1ohW4Zq265gZt/TSrEgBjMHM+rJjHpEPkKmLQt3bUqiCfBhvw187Gpv4Ym2x0p342t2E5nRP5PHv7UcfdVD8lsRutzYkFFbRp9wgkB0zOj5K4QbC9oPdXPbvSlue4m0le1cVDYrwDNLc/xOtVMafm3Pty4HvDIga4y6/CQZpYgIh2PNH67qGWPKjhruel6XLBFKyemIzENuNi9M7tDIIIIHAq+7tqYRWU7t2fwZx3kC/S5Kue2+M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At the end of dissolve_free_hugetlb_folio that a free HugeTLB
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
dissolve_free_hugetlb_folio. However, there is always a time
window between dissolve_free_hugetlb_folio frees a HWPoison
high-order folio to buddy allocator and MFR takes HWPoison
raw page off buddy allocator.

One obvious way to avoid this problem is to add page sanity
checks in page allocate or free path. However, it is against
the past efforts to reduce sanity check overhead [1,2,3].

Introduce hugetlb_free_hwpoison_folio to solve this problem.
The idea is, in case a HugeTLB folio for sure contains HWPoison
page, first split the non-HugeTLB high-order folio uniformly
into 0-order folios, then let healthy pages join the buddy
allocator while reject the HWPoison ones.

I tested with some test-only code [4] and hugetlb-mfr [5], by
checking the stats of pcplist and freelist immediately after
hugetlb_free_hwpoison_folio. After dealing with HugeTLB folio
that contains 3 HWPoison raw pages, the pages used to be in
folio becomes one of the four states:

* Some pages can still be in zone->per_cpu_pageset (pcplist)
  because pcp-count is not high enough.

* Many others are, after merging, in some order's
  zone->free_area[order].free_list (freelist).

* There may be some pages in neither pcplist nor freelist.
  My best guest is they are allocated already.

* 3 HWPoison pages are checked in neither pcplist nor freelist.

For example:

* When hugepagesize=2M, 509 0-order pages are all placed in
pcplist, and no page from the hugepage is in freelist.

* When hugepagesize=1G, in one of the tests, I observed that
  262069 pages are merged to buddy blocks of order 0 to 10,
  72 are in pcplist, and 3 HWPoison ones are isolated.

[1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net/
[2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net/
[3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
[4] https://drive.google.com/file/d/1CzJn1Cc4wCCm183Y77h244fyZIkTLzCt/view?usp=sharing
[5] https://lore.kernel.org/linux-mm/20251116013223.1557158-3-jiaqiyan@google.com

Jiaqi Yan (2):
  mm/huge_memory: introduce uniform_split_unmapped_folio_to_zero_order
  mm/memory-failure: avoid free HWPoison high-order folio

 include/linux/huge_mm.h |  6 ++++++
 include/linux/hugetlb.h |  4 ++++
 mm/huge_memory.c        |  8 ++++++++
 mm/hugetlb.c            |  8 ++++++--
 mm/memory-failure.c     | 43 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 67 insertions(+), 2 deletions(-)

-- 
2.52.0.rc1.455.g30608eb744-goog


