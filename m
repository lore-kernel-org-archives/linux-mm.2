Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17109C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 18:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5EF56B00A1; Sun,  5 Jul 2026 14:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0FA66B00A2; Sun,  5 Jul 2026 14:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFFF06B00A3; Sun,  5 Jul 2026 14:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 952C26B00A1
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 14:07:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 073F91A017E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:07:20 +0000 (UTC)
X-FDA: 84955505040.16.02269EB
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4C4C0180003
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:07:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vpPVb3qW;
	spf=pass (imf16.hostedemail.com: domain of 3VJ1KaggKCBM21t91Ht6z77z4x.v75416DG-553Etv3.7Az@flex--jiaqiyan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3VJ1KaggKCBM21t91Ht6z77z4x.v75416DG-553Etv3.7Az@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783274838;
	b=jPykoFMNuQll/qRf19gmRNFm+3K9jjBHN58Ajzk1Tc2AFdNuOzP1Hpy5Yjo1opY86uPG3t
	aNzsapnQDRNBh1HtjvtwuQPP7m4rtiEJrzzgmBleqh5ZuE7QdpF3g44dQXh0K+vQebBnqr
	137HMEUy7+EytY70ZCkbc/f02a0grV0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vpPVb3qW;
	spf=pass (imf16.hostedemail.com: domain of 3VJ1KaggKCBM21t91Ht6z77z4x.v75416DG-553Etv3.7Az@flex--jiaqiyan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3VJ1KaggKCBM21t91Ht6z77z4x.v75416DG-553Etv3.7Az@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783274838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=W0l/T3c1tBTPd59g2vWHPm6URn5LD4/gNmBayGnnWek=;
	b=wuaGtVWK5WJYrzH13Syqo8Slp3IprjiK/9gWS4R+RSlrT+AVaKUN6nwnnyAIZr4yWVsN2E
	S1/IeWbEh5sSE/j7dB9nIaR4jDJpFT/anOobicHGsykwXiQqmDiYtEF+Gv51egixYZrWp7
	ctF2OclVf1ZLWXuFyjr6xdUecYCKdfo=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-380b630c505so2735946a91.1
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 11:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783274837; x=1783879637; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W0l/T3c1tBTPd59g2vWHPm6URn5LD4/gNmBayGnnWek=;
        b=vpPVb3qWFvABZ2QMrngb7NdQNCgpRIb7pwgCFmvetIKhVCCVCT+njEDFpEjZ0JJZvC
         yi7V5gdJSHGBItoo5v48QYqQQMoom52q2n9Qo7SrNr8r8+lLp+XazsH+wURFB6yMOzAG
         T8Gyf8PzcyeXrKi/NhUcxtA1xo1rRRJ/7XciClwhvrJjEluCDgqd1E8uJDt3Mu+Uu+/+
         bhuaaj+o7JAuxDYH1zwqtHT0JK1AjcXpTF8urZ7XHdiHdJtbGEzf4PVEs50fq/6NVOo5
         p4IEgEVF648VcmrjhTOHvzrkCrpBiiQG8DCYVQnjOy+lSTCOH0rKNq/9NoZzX2wUludm
         lHqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783274837; x=1783879637;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W0l/T3c1tBTPd59g2vWHPm6URn5LD4/gNmBayGnnWek=;
        b=Usa/sJVF8n0nSGbgbqLUN7aIMj4Yo/lRuCYbbQSMO5W2YhhMvxlrnB9laiR7QRZ41D
         e8x+fDuPttcgOpdhfwIVvJcl9PDh3BbQVqtV1BcqC+yReCb+IznMzieh/JiUysbgA8Pi
         347oGjQetVhVWpA7nTPjbthrEMUeSyX19wZNH+3c3W2g+CyLKUy8kcHRh5RB5mJwtw9u
         8OUUqZotlXVLNAY9wZhYF32o4fk+HKSo9AolP0hNfx+X5Wdn0MGosSsq/4/INRNPmEqX
         AKe3GxIG71mpuLXC9HBulfcUf5VBmv4yC7QGaKlcb+IeyjBj6khoe3kfz9ahb6l076ZH
         9WGg==
X-Forwarded-Encrypted: i=1; AHgh+RozAzkExWV9y702Kz3mOTTkw0RebDslzUAqmJ+pT30YdMt56nhB44LyLUtvJlQPGe1tWDQoOtaLkA==@kvack.org
X-Gm-Message-State: AOJu0Yxj2QrUXv/FgiHlSaRExcKg342K4ZE/OV8ovTuL5VIRnMIFC8ja
	8OpOr87PZ4vL3mdqTdxByZ/oaWilbvrgGDHzsBr5uPWTvwWNuuFIyFHU1q/aKNdrZzM2SFKwgwE
	S+tCBgD9oawpSDw==
X-Received: from pjoz16.prod.google.com ([2002:a17:90a:9810:b0:384:f6e1:ff81])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:48d1:b0:37f:e326:6557 with SMTP id 98e67ed59e1d1-382803b8446mr7223203a91.4.1783274836929;
 Sun, 05 Jul 2026 11:07:16 -0700 (PDT)
Date: Sun,  5 Jul 2026 18:07:09 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260705180714.3708947-1-jiaqiyan@google.com>
Subject: [PATCH v6 0/5] Only free healthy pages in high-order has_hwpoisoned folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com, vbabka@kernel.org
Cc: osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org, 
	osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	nao.horiguchi@gmail.com, david@kernel.org, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, muchun.song@linux.dev, liam@infradead.org, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@suse.cz, 
	rppt@kernel.org, shuah@kernel.org, surenb@google.com, mhocko@suse.com, 
	boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4C4C0180003
X-Stat-Signature: u9uuhq7yc6anhts7sd9irqunrwz5ogfq
X-HE-Tag: 1783274838-260198
X-HE-Meta: U2FsdGVkX1/2hjsjaZoD8aDMFidmT1MF0VGd/wNhoUR9bhBlhlguG3bPrtDbzosG91OzsnwX6MGZr6NxP7Pa2k6nWJ2b/IYLypevuzJ2jiseHcEV70ttTPP7uKnMb8HBxO+WK/QvFmORqECfDmhI1QXpiGaZI53mJVeMxpVLYBNM+nu4QGiAEoWGE4BXjSVWnerYm3m16SsmweI9bn/JEZJ1Zv0tXGLdAdHYmrzeN8YvdKTa8+XkAQCE+WSj6n73+NBkz1JZfPifAT2fNg7IroEkgf8YT4H0LcT2nucepO6omUCoDdCrWoM+G5uVnswjR0/fSA9PcHjOWwDPk5HLeS844YZWtWbMuXUiVCL4obXAkzX86YdnNDojVJpprZa9LemGJeUJzz9T9AiO6iSWRyWT/VW8n+mKuDZ0Odm3zzel8tgp5ADycTPOuXE0bBq1o0dLxIceF35LAR3Upf4BoJmcyN2CXntoQqaH64b6iK7xHheHeF2F2Yr8vI1lkmHUc4tzqt5APvknVHqRoDeu5y9AqiAIjJI8om60oofEKwcdEJpAZlCYzgOpD71EcVpgV56Bu9u0b+7BqjrnOvZ4pcEahSXp4qL4jlelip7yeS9JJElRqoSimARtxMxD3+ZWMfmD71eZM/2cUnL+ZWLRtYwt9QyyLICPatwU7e563DjnsW2vNZFp5HKvL0x2TLM9P71GlV5aCpjO1EoJAsBSp6lD6gM6mxLF+gTrebES/es34BSLNwLk734VXca/Y2SfyRQ0GDSZTOLZyQQhi6Bg22vGdiYEjeP1pOUQyYCgnPxKt5/+NEN5c2c8FEzhclit5iXF462msv3zo3AReIAhUUZSYB44pgj1oskqR0QrA3WsqGo3f9DDfgmbg204kDqdGZ5iPu1PRw6fB/tpmkNl/NXyKwJtaXrqXDpZVL6FQIpEfBoTg1BUvqQvyRW4i8n0Zkr5lbWwqQnhElC3Rnl
 fU9e1CLm
 CaEluvk734q4a6Apd+qVdrHw7HffR8hpG5dAqdLpGwDAoXFnt1OZe7JymtA3r0uE3MjLXmz8GiQSi/Uvf2U1341sFwJXDWlX8ObwisWavAoqrYMWP3HVinGz2e2gB8Y6q3JmpgIPsRMcWEtb4RNYA0CmfXMKvpW2QgDjhdQj+e1ADnFV6fqb2K7G+MRPk9jP7TSI9tOkwfHH9hCjNdPq1odEn/+4bMT8+MMKYx1uobFnc1KLbSWokUDdj05vEenNrDmLDxHogcRMSMATjPBI4/BBfpTeWD11vx5aeIqaBlFzm3Nm/2WRmunHBq0Qe+aLU5Ee9eQVz2vPlhKpV/qr4PQNZ6tAzvTEAtdDKT+/VBLTezdYC7HLfGWs+iianMXRyEPG6nhwU1WLpraaeTly3iQeFDM4v4kP7kVEEsQIP3MYoBykAQCs543bWTWlQGwMYRNGu5vkxR0w66NskJMD5zXs7fAJ6OHXoxLlSY1LsZ+EB2hJRTi46yMsqOD+/FbcEGcFGlionv5REwEPKQPY6oVC/M6cQ+CfUQPhR43VUAGLkuXNFCGYZYMzRaJJKem0YmZvxd1aFN5uDDzqX73dpzqsDRl1VDc0WONpRJ7ibm+654WhrvZCWSZP2xAR1PY/1SDyOdbWnFEC9ovfBL7mJzod7Jk8fDTWpMcZN1gjSSQCwWwweMBcURFMvJJ9Q5ANMcN8LLjyDiij62fREJjCOoz2vAiPH41/L7nlJalwbb3keTYXFzlWrfi+qVJeeWVw888/slkVyHSFmhdzGH5XWMiuZDV3w8bgTQ6MSbzMhE2Rn9mwZsjUIc3pJlmenF0rgIHptoXaBgeDP6V2c0vkwyBkidDKheIE/wJpjc9Bp6M/9MN7cQV2nD3h3WzxMYcVKa/3W7bSGPBEwtk8JFvGS57yTow==
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
and exclude the HWPoison ones in the high-order folio.
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
freed via __free_frozen_pages().

free_has_hwpoisoned() has linear time complexity wrt the number
of pages in the folio. While the power-of-two decomposition
ensures that the number of calls to the buddy allocator is
logarithmic for each contiguous healthy range, the mandatory
linear scan of pages to identify PageHWPoison() defines the
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
for anonymous HugeTLB pages. It also cover the code path that
frees a HugeTLB page that contains 1 raw HWPoison page.

Based on commit cfb8731f5396 ("mm: fix CONFIG_STACK_GROWSUP typo in tools/testing/vma/include/dup.h")

Changelog

v5 [11] -> v6

- Rebase to recent akpm/mm-unstable and address comments from Zi Yan,
  Miaohe Lin, Vlastimil Babka.

- Extract free_pages_sanitize() to avoid touching HWPoison page(s)
  at the end of __free_pages_prepare().

- Introduce FPI_SANITIZE and add a fpi_t argument to the freeing path
  free_has_hwpoisoned() -> __free_prepared_contig_range(), so that
  healthy page blocks are sanitized before __free_frozen_pages().

- Make free_has_hwpoisoned() be compatible with order==0.

- Repeat the previous test done on both X86 and ARM64 machines.
  CONFIG_KASAN + CONFIG_KASAN_SW_TAGS + kasan.fault=report are
  enabled on the ARM64 machine.

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
[12] https://lore.kernel.org/linux-mm/20260531055829.3636554-1-jiaqiyan@google.com

Jiaqi Yan (5):
  mm/page_alloc: introduce __free_prepared_contig_range() with fpi_t
  mm/page_alloc: only free healthy pages in high-order has_hwpoisoned
    folio
  mm/memory-failure: set has_hwpoisoned flags on dissolved HugeTLB folio
  mm/memory-failure: skip take_page_off_buddy after dissolving HWPoison
    HugeTLB page
  selftests/mm: add hard memory failure anonymous HugeTLB test

 include/linux/page-flags.h                  |   2 +-
 mm/memory-failure.c                         |  37 +++-
 mm/page_alloc.c                             | 176 ++++++++++++++++----
 tools/testing/selftests/mm/memory-failure.c |  70 +++++++-
 4 files changed, 247 insertions(+), 38 deletions(-)

-- 
2.55.0.rc0.799.gd6f94ed593-goog


