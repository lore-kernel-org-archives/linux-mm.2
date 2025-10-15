Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9951FCCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:51:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF7BF8E0003; Wed, 15 Oct 2025 02:51:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8198E0002; Wed, 15 Oct 2025 02:51:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96C68E0003; Wed, 15 Oct 2025 02:51:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B55BE8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:51:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5330488A24
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:51:46 +0000 (UTC)
X-FDA: 83999428212.18.E079C0D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf06.hostedemail.com (Postfix) with ESMTP id BF557180006
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:51:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YqlSEe5B;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760511104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVrjXdHEWBWhTPbFS4in917B+EHMF3wKT79bdUZbygc=;
	b=LbSMOnyNv72s0kZ/8/F4dSUBt0xvD7Rn4TC/uLn0SnmWtbgMdoIsYxLqeroaDO/lCjePIG
	yN8phJlkBlfEa8iaGk5mLo7S3mxhsORr2U+PBJ43lyCkWpKStsv8VVXyhFHlFwAGLHti46
	soWXPoOjSk3/Cvjm/E2cr337pw1TsJ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760511104; a=rsa-sha256;
	cv=none;
	b=vYOX6Xw5bJLDdWe7xMSm7ZMt8qjCVIf9tJ8wMuqUL2Wlh4RpCBD5rso7DK5XefaKk+e8v9
	vgUSt6aB1Fh1hL2FkyWr/C/sbSt+uvzHg1mrEp/N6tYkQkMKD95wy13Uq0Ert7z6e1ns0x
	U0OXiVY7z6NHazS6m5+JqE6StR1IIHs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YqlSEe5B;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760511104; x=1792047104;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=azz8Uf5bZisqVcWDk3j8GghBZWS+eaQ6DBO/BiA7Ncc=;
  b=YqlSEe5B/jdIm2BXZ9/RQL/9E/nVGfoFZd54ZXiKTVHgS5jlpgh3PyFX
   48tMPcwdBZ9ogPJfUhEQ+rOr1KnTcp3Gwk9PEngtZ5iWzGCLCc+xj7Ikt
   87pjBHI/JUa2xsivpuXsA+wyMyGUkXMZ1llOY8/MOWFbi3ZOIK/G9zpiT
   VOd5zyob8Lfu0c2LSU+xEx+viiKGZ/00pSDuiQu5wYJGezrIwVSkBsLzs
   NxH8ytTB3XiGPtPrtml1tB8ZZOm9Ax3EUVMCTVehDJvBE0n/9iQ9/67kc
   22tgkuguclRTXI+ETMRdIPd9dlWiFxOHze3CBPqLEYkwMR+3ft4cJCcbo
   A==;
X-CSE-ConnectionGUID: rZytO5sFRKiCuU7gbGDRcg==
X-CSE-MsgGUID: OLQG8l+UQi2tIndplLQt4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="61710906"
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="61710906"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 23:51:42 -0700
X-CSE-ConnectionGUID: /VzDypJFRz+fSDcq4FxHQw==
X-CSE-MsgGUID: 8u3VvAzWSKm07V1V4g4KSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="186097740"
Received: from qiuxu-clx.sh.intel.com ([10.239.53.109])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 23:51:38 -0700
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
Subject: [PATCH v4 1/1] mm: prevent poison consumption when splitting THP
Date: Wed, 15 Oct 2025 14:49:26 +0800
Message-ID: <20251015064926.1887643-1-qiuxu.zhuo@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BF557180006
X-Rspamd-Server: rspam02
X-Stat-Signature: rwqfnr7w4bbnpm7eyiqe6hwozrgaqn78
X-HE-Tag: 1760511103-176994
X-HE-Meta: U2FsdGVkX19i8DCMgTLJmIeMLAH5keJT4Oic/2I1W2l7YRpJphTARjAOF/F6i3a0IcrPHu4+aeFlNV9bgCYVJ0+Z+0BwRId/n1+aT6LzbnODOyPJH+gANRYHKcAv2ZxWg2niC8GhMmS1JLw7JHCh10ZN2T/jH/miIqWvFp8hV8W1eMRGc1eGZlwz8uD7LBj9gdrL5WEVEeYug+cc10NBU0S4hkeXNu8jKDlCSamA4OOUAL69E4tTzx8V13Ktsgmrd+lnPX0clPZhW2lfTYfhUmHxRC801F3fjyU37N6ILia4Ehyv/SY24UQGiqRwSD33+0rNpapBh5tSEZLfeeDjITGge21W1lRF7PcWh/h82FmkpEZOMy1T8Dx9i0oNjqQL6N2LVvnAW0R+CMzIDQw1LOTO93yThaN23UoG5sp9/wvOY2H1ZDnYz3Okjzpys6I9MpMqWn3lePcsq6birTiEqb3XnKCFEPkRpUFL6WOQ6LaEK7WHQ4ZiIt8e62NEuzOVVQaIU2XWLRY/4ne9vX4jth6Xq/bI30Q7/EKUgYM+XXVUycod3do+z92vtBM/uMYrLrwKj1bXtojRPHZs9QT/6jHrWbPco+NEp1bAi0LozhWLuw8DFTGPrro3BCq5r2qipVJOvgInkSy1Ojh4Ws0dkkTa+6smpF5pENbA60T3kp/usBRTsTs4SzCCbdj0zfo/b93fM9W9Eb9WOgPrKlNMaaLCvUpaoI6y33DZUslEWY92Zk5nG9ZelYGN5K3KKzlpL9fcu147+waf4+5tdQAmyiFAVhvHhlJRmQ4ZpJL1XjQGLiWOxn/MFwe8cAFXhuCCtp/wfWKGkOH7cct7uEbW/9ufv7MUgnWI2+sLf4/VOHYZrvLDfnwbiIkRG/NgaJTToNBBPaLf9mphqvF4Ga1dU22Jx4tKsClTHcEvQuZRK5iIiB2awWddTw43/oLbiF9vIdWXWoVB19Ttub34NP8
 us5+OMvQ
 kpHaLOW39KavDmvSbqWCRcR3hCf0OfYpdXkW4wt805iaSTJmFpeD4YC9tZtQMT7FnU70bigCEUu+O0YZC9OnhZy+prtv08bjFDC4mByIX7HcGYVgEGnRJGT5Um20CayEMHfzfxtV8S9uWVCHe2aeDioHtjTQpvPQLQpea8+8Ib+QFtQucRB8QKFEtAMMQLentl1CidmCraU9HRUdmGTUIK7I1rUWpQJdwx2m/1SfPi9f9EOLrrC51rwdN8mEvFNnHJFtrkNPzFkYyawb7aT93we0ey6SjWPRItkz731/0AbD7uX7/8RS4C4/P7aB8s0B+B5z8g541tXeRpIKrMQCSoucoEQ==
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
reads the pages in the THP to identify zero-filled pages. However, reading
the pages in the THP results in a second in-kernel #MC, occurring before
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

[5] Re-access pages in the hw-poisoned THP in the kernel.

[6] Triggered in-kernel, leading to a panic kernel.

In Step[2], memory_failure() sets the poisoned flag on the page in the
THP by TestSetPageHWPoison() before calling try_to_split_thp_page().

As suggested by David Hildenbrand, fix this panic by not accessing to the
poisoned page in the THP during zeropage identification, while continuing
to scan unaffected pages in the THP for possible zeropage mapping. This
prevents a second in-kernel #MC that would cause kernel panic in Step[4].

Thanks to Andrew Zaborowski for his initial work on fixing this issue.

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
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
---
v3 -> v4:
  - No code changes.

  - s/sub-page of the THP/page in the THP/ in the commit message.

  - s/sub-pages of the THP/pages in the THP/ in the commit message.

  - Simplify the credits in the commit message.

  - Collect David Hildenbrand's "Acked-by:" tag.

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


