Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45424CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A25CC8E0123; Tue, 14 Oct 2025 10:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD758E010A; Tue, 14 Oct 2025 10:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 913528E0123; Tue, 14 Oct 2025 10:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D67F8E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:21:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3242A47781
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:21:47 +0000 (UTC)
X-FDA: 83996933454.08.C46CA76
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6DABD1A0007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:21:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bG4c7lG+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760451705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bc/kk9aGg+NAA0PnxquTmsluNh6C3YJCHG16E4V/i88=;
	b=JrPpXO6NsLDPibqyF6wbVQfZZn8fL2bMF0mgnQRCuaOu3JbuMzLy/B+BRpwxzBtoF2Oj5n
	3sY2iG22Z1YyMXRyers7lg/XEfmiMg1JYjQ3azKXPfHgjDo0B9jiuqXIK2FoeLLJ8EzJmT
	G+TM5pA45k3vmFoUgyqhZ4PaksW04sU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760451705; a=rsa-sha256;
	cv=none;
	b=aL6tRNTeliCZNYe+FR/p2VpTTTMU/NLifEmpoz1GAQu7MndIxH9uxHba1b2/qlixTJUGC3
	aqlMXCW8UZdFNe64qcy+Wfmq3gzjBjU0+2ddltS5uzqV5i1figPJpkvY8IyEEr4lk4nD+p
	0R7Hxd+rEGo05l3OWFKVpFbUB+n93RQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bG4c7lG+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760451704; x=1791987704;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1Hf1GQnfilFRE9nB1w0R6O4CsxGa+shCweum3ftHKYs=;
  b=bG4c7lG++NTYSlAHAk0uknmneaqmn2kOPCHvz13vGuaqsnAkFfLD4pYa
   BywLRrBTifLZB7gkgt5buxRo6oZdd2zopmJgfjRbHbOV8rkg46GZR3Z1c
   gpPW2gTshWehh/NRQzN/3KOqsRUlr6Q1XRrq3xEI5wcaqaGFNSS2IFY2P
   I20hUozJ6f2+SxPM1e9hUgaNJzmp+I+EHYb7YukNrB+ISjdXYmwgOX8Sv
   V3e//UiRjU0aMdvdEhSjZQrI4xssxCIzgF8+fy8tgP1gowI+0S2oVYyEX
   hpAgT+kIEfZje22f0mc5aZwgZZ+EQDQ1tQSAN9sJYePoFBBsKRYqeIj+5
   A==;
X-CSE-ConnectionGUID: YkdguFqUQ0i4srWOf1KUCw==
X-CSE-MsgGUID: 0HABOIysTAi4MbeXKm6BOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="62653254"
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="62653254"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 07:21:43 -0700
X-CSE-ConnectionGUID: fjCBQiILTRa4fpom3HZ2vQ==
X-CSE-MsgGUID: xqmpdOA3RDOarD3OZxal3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="181449086"
Received: from qiuxu-clx.sh.intel.com ([10.239.53.109])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 07:21:38 -0700
From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	linmiaohe@huawei.com,
	tony.luck@intel.com
Cc: qiuxu.zhuo@intel.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	nao.horiguchi@gmail.com,
	farrah.chen@intel.com,
	jiaqiyan@google.com,
	lance.yang@linux.dev,
	richard.weiyang@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/1] mm: prevent poison consumption when splitting THP
Date: Tue, 14 Oct 2025 22:19:35 +0800
Message-ID: <20251014141935.1878315-1-qiuxu.zhuo@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DABD1A0007
X-Rspamd-Server: rspam02
X-Stat-Signature: f6tmuubn9jwd9ozfas9zg9gxtz8mtust
X-HE-Tag: 1760451704-698837
X-HE-Meta: U2FsdGVkX188nhMIMtuhRGc46WjrjT9mIdVv3WRZ4M2vxwKTHLq7Uyc8KV4MCwHmQR0QDhiYDYxGh/PR4TOVGw3oDf9abCqKMPWI59f4PhwGIBVqDvdpWBOkejDuyn74iia6+6gkks1G49bZI66cO0HSAuE+DWYz2JJDhjOrYvo8nDe9SkNdVfZoW1t9ayA3S6HXsB647Xr6WRmdU54R8zb3sFGURyNFB5mOaEhKuv9Q2vSHvUKrRm8/xhNrHCQ/c0/mwChbutPyveOHwElWhBWNVDfBQtKCNaVSgGjEJ96wPE4VOwxBsiF1+0oPzZH+3GBZKFG+ifvUkSXjJoxXU0m70/MgRqKHWLJhakbPwtNoZeyMTsHVukJKPhzNsyLwcqwsNCpwPf+3z4IUdbsCjRdo9nHEUsjZ463+JWvt5CG8mrIYYtRYpcbOgbxJN9AnXj8jjQr3dous6Z4MSGttQvBKHRmDAc6TkngdG2f+sWczrJqacbcMma2zPRD1Gr+s6urg1Xn7JOa6diQLXR0qy+tU6yK3J7WzHrNTxXW/Qg1Rr3gxvQzIr6oK70UDEXV1L9ZMypIsDxMTvoIizTIVY4hAa4GTcxx0/9dRONCofc4BDCtcT4bTlFdQEloX8exun34gl/I+Tew9fg8DPcsUpwrJR5rLwgdPlOIXZFRILTz6pO9EoEPJasCoZEwDgrToS0uwNgquZp91xLImZYtxI6sZCZeDuiy5avbpmY8eT5BMQtnqFQcf3ffa4nLnQdKRE7pzY7hdavGz5DrSjbIs03L6cOCzSW7S9DR10sZWi9NwS2/w4Cw7nN+DHvY2epIuCwgyoasjlM/XjpXsUDvfFiGxkulayLqCNhsvKm2eyFHjyvMVgbQPUaJ8hZqzjE6T3iMcAaEW8MC6BiBa3tT9qQ1AgLxPIoZYK+NRkBQeQXhYq3kykugRUQaLkYLAGixPYQGPeLxsX/PQMBRa3qI
 GSAUiR74
 6PnU23MW0siDaTV+YRzDPzSCIxpthI021yspHqPcrR2eS1jN8rl9+U9021tOLVA4K3NcpQ4Z669ooUjw0FfGKM6da9RTycSTiWKy+fnujKDEPlXUpwCSWFoNefrVD/gVcPxbK4NR98ED/l4uh355j1emoUV0WD2oegVklHfAIXa463O/KU+hZRLpXws0S/1DaBGLwIKDATm7HYQ5wJxQ00h5mP5t4LoXKb05+ZVaB/zan1lvHE4iLqrb+Kv7Afpl/U33MV/NaftSLLbsHTlWVnRtQhTbSItRjVpnGnXIbOxKzal/k/Z69KHTUmYZnasgYwSE7NK58O+Id6IQ7G+h1gVsojQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When performing memory error injection on a THP (Transparent Huge Page)
mapped to userspace on an x86 server, the kernel panics with the following
trace. The expected behavior is to terminate the affected process instead
of panicking the kernel, as the x86 Machine Check code can recover from an
in-userspace #MC.

  mce: [Hardware Error]: CPU 0: Machine Check Exception: f Bank 3: bd80000000070134
  mce: [Hardware Error]: RIP 10:<ffffffff8372f8bc> {memchr_inv+0x4c/0xf0}
  mce: [Hardware Error]: TSC afff7bbff88a ADDR 1d301b000 MISC 80 PPIN 1e741e77539027db
  mce: [Hardware Error]: PROCESSOR 0:d06d0 TIME 1758093249 SOCKET 0 APIC 0 microcode 80000320
  mce: [Hardware Error]: Run the above through 'mcelog --ascii'
  mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
  Kernel panic - not syncing: Fatal local machine check

The root cause of this panic is that handling a memory failure triggered by
an in-userspace #MC necessitates splitting the THP. The splitting process
employs a mechanism, implemented in try_to_map_unused_to_zeropage(), which
reads the sub-pages of the THP to identify zero-filled pages. However,
reading the sub-pages results in a second in-kernel #MC, occurring before
the initial memory_failure() completes, ultimately leading to a kernel
panic. See the kernel panic call trace on the two #MCs.

  First Machine Check occurs // [1]
    memory_failure()         // [2]
      try_to_split_thp_page()
        split_huge_page()
          split_huge_page_to_list_to_order()
            __folio_split()  // [3]
              remap_page()
                remove_migration_ptes()
                  remove_migration_pte()
                    try_to_map_unused_to_zeropage()  // [4]
                      memchr_inv()                   // [5]
                        Second Machine Check occurs  // [6]
                          Kernel panic

[1] Triggered by accessing a hardware-poisoned THP in userspace, which is
    typically recoverable by terminating the affected process.

[2] Call folio_set_has_hwpoisoned() before try_to_split_thp_page().

[3] Pass the RMP_USE_SHARED_ZEROPAGE remap flag to remap_page().

[4] Try to map the unused THP to zeropage.

[5] Re-access sub-pages of the hw-poisoned THP in the kernel.

[6] Triggered in-kernel, leading to a panic kernel.

In Step[2], memory_failure() sets the poisoned flag on the sub-page of the
THP by TestSetPageHWPoison() before calling try_to_split_thp_page().

As suggested by David Hildenbrand, fix this panic by not accessing to the
poisoned sub-page of the THP during zeropage identification, while
continuing to scan unaffected sub-pages of the THP for possible zeropage
mapping. This prevents a second in-kernel #MC that would cause kernel
panic in Step[4].

[ Credits to Andrew Zaborowski <andrew.zaborowski@intel.com> for his
  original fix that prevents passing the RMP_USE_SHARED_ZEROPAGE flag
  to remap_page() in Step[3] if the THP has the has_hwpoisoned flag set,
  avoiding access to the entire THP for zero-page identification. ]

Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Fixes: dafff3f4c850 ("mm: split underused THPs")
Reported-by: Farrah Chen <farrah.chen@intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Tested-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
---
v2 -> v3:
  - No code changes.

  - Rebased on top of v6.18-rc1 and retested.

  - Add two "Fixes:" tags.

  - Collect Lance Yang's "Acked-by:" tag.

  - Collect Wei Yang's "Reviewed-by:" tag.

  - Collect Zi Yan's "Acked-by:" tag.

  - Collect Miaohe's "Reviewed-by:" tag.

v1 -> v2:
  - Apply David Hildenbrand's fix suggestion.

  - Update the commit message to reflect the new fix.

  - Add David Hildenbrand's "Suggested-by:" tag.

  - Remove Andrew Zaborowski's SoB but add credits to him in the commit message.
    [ I cannot reach him to get his SoB for the completely rewritten commit
      message and new fix approach. ]

 mm/huge_memory.c | 3 +++
 mm/migrate.c     | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1b81680b4225..1d1b74950332 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4109,6 +4109,9 @@ static bool thp_underused(struct folio *folio)
 	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
 		return false;
 
+	if (folio_contain_hwpoisoned_page(folio))
+		return false;
+
 	for (i = 0; i < folio_nr_pages(folio); i++) {
 		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
 			if (++num_zero_pages > khugepaged_max_ptes_none)
diff --git a/mm/migrate.c b/mm/migrate.c
index e3065c9edb55..c0e9f15be2a2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -301,8 +301,9 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 	struct page *page = folio_page(folio, idx);
 	pte_t newpte;
 
-	if (PageCompound(page))
+	if (PageCompound(page) || PageHWPoison(page))
 		return false;
+
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(pte_present(old_pte), page);

base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
-- 
2.43.0


