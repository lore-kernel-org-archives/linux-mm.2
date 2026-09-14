Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DB54C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 11:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A2D86B00A5; Mon, 14 Sep 2026 07:44:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27B6D6B00A6; Mon, 14 Sep 2026 07:44:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11C7D6B00A7; Mon, 14 Sep 2026 07:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D72D66B00A5
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:44:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 374918033F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:44:12 +0000 (UTC)
X-FDA: 85212184344.09.A36F5A3
Received: from mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4485840006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:44:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T4RsrHfP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T4RsrHfP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789386250;
	b=cKng2bo6howlt9GwEhPCMSNGma6JlLBjPQ+9AQZZR9U+zV+++goPKLVFuGH//+NAK5oGr8
	NJSLgafuiCdnLytGl6RFnDdgQEIkoRNyaVbP25XhOCuYUOqLlPujqTfs3uXoqGkY4p63rZ
	cY43S8bCA98HNlYaq409v0ATiW2YbWw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789386250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQ9afrGeblbRrHz7qzJG86JE5X9fHIQg3/CX2+ca3RQ=;
	b=Kk27ZS7wP8yNffSK+I1ew0FyGxUJwV9p5AA1MvaI+iy9LHUljV2o1PGYffNEOadYJ/1XVU
	gSLTsy3WAE3Jo0YMh/Nmht/CBt6ywq/2NamObXVJjx9LsUHHKVvAMjm0zw/AyKQkuEWKSa
	pB8+Phkkiv24kOoD9H7tGnaPqt+RBhw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9WXF5SfkPGIzLBw1Y4CC+Epd6KLA6VeaEGUz3MVaYfc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789386249; v=1; x=1789991049;
 b=T4RsrHfPwQm3nDnqLql4CnNsjaqThVqN7r+hUxX45SvwIW3P8fqFwATLiLw31leggPxTxC8v
 YeVSx6cVLiihALmxALKEz+VrfXjcXn6s7lXcnqJtmHG4YtlEakshX+RbCofoqIedgSMsYJXCRPl
 mTvMV+3Gx6cyzfbmZly9HYfk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id a2dd83d028e1d9e3;
	Mon, 14 Sep 2026 11:44:08 +0000
X-Mizu-Trace-ID: a2dd83d028e1d9e3
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v7 09/29] mm/debug_vm_pgtable: test PMD swap-exclusive helpers
Date: Mon, 14 Sep 2026 04:42:01 -0700
Message-ID: <20260914114320.12988-10-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914114320.12988-1-usama.arif@linux.dev>
References: <20260914114320.12988-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4485840006
X-Stat-Signature: wk799dxkaaots3hfz39ad5k18rxsjcrc
X-Rspamd-Server: rspam01
X-HE-Tag: 1789386250-378068
X-HE-Meta: U2FsdGVkX18gB0oQF1a2xxceuvQukNijrY3eL+nJbvM7T76uxKPIsAvdlKweyw+hTSgsrViuv4AApeXeSGLjPoiZaawpNkrxzX+zYrnksmZd+VocjvyEnihq7hswkQTfGHSXPPyoGtUzgEpytSYBUKHX9QnUlH+1stDuEelmcwP5VHN4zcZB0wPSeKCHl6SBCVrB4YtWJte49Yw6Klurgi3LbjwS/ylDymLu7TTVnYFzSUVu3SRwUrYFSVzklLWCH39bUgk9GrHnfXrVmhN2kHeVgvFBbuEpVyaYUcPSdWXInwpSSQBKf346eJGc0ZmWG9R2hkTvqp5TZYQpqlpQyKms1VkuTo/IoKrEFgM+B2NN6dPHZIF9QXM8yBzoZDR6zumoycRnBM0hPDN+O5aN5bJH2RbTa8HJGH9FiT4RM4TRmSYrGDQpUG17S7rYaIWQ7h4e34IOucfP6PbylSzYuZTxCp9D2S/BimGs7VhjiJ7P6e5RtrDs/xCh/W/Lrn1bN7w20Yd+CD+y1N0MIXX/wuirscaVPeWUnmj3QrIls1tYMat5y6NmuCvdHkhc6ToUrLwkusZSonKNr1ui1EsJAJ34yvit4M0LbvP0iA2BhdkBSCpvo07gLxNev/sfTlHLFbGh+AbWNljiKX9M0D/zAuFaPJ//LE6WLD7MwRavL0o1GM5Xh4m8rlmtmEsLi4w3px6B9VAzrO0jSf0qyHnD7rAVtjhlExJq0Qt79T+I1uTchxmSt7m1q3KUxl/++rHO7BYpEE5OLr3gPPYQ7BpAdFVy5pImc1DcJzkaLv1vo5n1dQjuKiTGv0Sr2bmOW6d4avwaNeS6HVlqL2dbjvMBO6mHL1LqvL5Y+yzJ0hvTwmJf+ErUqavkwVSTVicLpMnWJVZW6mR4LdosjTN1Z34SsdZH/3wk+l5SmjqPwwSOo2UZ9TAAZKnPIuK1ttblzywadYCtEaLyg+G+sjatxNz
 wvGy/AaR
 htJrHb76pab2JBmWSBNyg9ka0KUOHccUA1bhLzmcKpqNIKqnahtLMGe4PJ24J4syD8Z4VucHfr4PLCUON0rvVXFUSmv1r45xFP0eHD0UbPSbyeBCHEUOnG9++OIHlRZKtat1NhJ6VNrKCHb3Y2BBOCdQ1GOehsXSFN8zr5UUCViJpuNn+sjouKm19T6imWIQgU4Rgtcb5yrEnCG1LU/jYghWVYE3Plgq4Tlmjmuy76EnRYo+qxU7HDhOv3sv/m0G/ZzTAR70zB+y0jDyUPtIb5I7Mnm5CJpovrdVPZYs1VoSzK4c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An architecture that picked a PMD exclusive bit overlapping the swap type
or offset field would otherwise only be caught by data corruption at
runtime. Mirror pte_swap_exclusive_tests() at PMD level.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/debug_vm_pgtable.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 2875fd22d7bb0..863111c6d4eb3 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -802,6 +802,45 @@ static void __init pte_swap_exclusive_tests(struct pgtable_debug_args *args)
 	WARN_ON(memcmp(&entry, &softleaf, sizeof(entry)));
 }
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static void __init pmd_swap_exclusive_tests(struct pgtable_debug_args *args)
+{
+	swp_entry_t entry;
+	softleaf_t softleaf;
+	pmd_t pmd;
+
+	if (!has_transparent_hugepage())
+		return;
+
+	pr_debug("Validating PMD swap exclusive\n");
+	entry = args->swp_entry;
+
+	pmd = softleaf_to_pmd(entry);
+	softleaf = softleaf_from_pmd(pmd);
+
+	WARN_ON(pmd_swp_exclusive(pmd));
+	WARN_ON(!softleaf_is_swap(softleaf));
+	WARN_ON(memcmp(&entry, &softleaf, sizeof(entry)));
+
+	pmd = pmd_swp_mkexclusive(pmd);
+	softleaf = softleaf_from_pmd(pmd);
+
+	WARN_ON(!pmd_swp_exclusive(pmd));
+	WARN_ON(!softleaf_is_swap(softleaf));
+	WARN_ON(pmd_swp_soft_dirty(pmd));
+	WARN_ON(memcmp(&entry, &softleaf, sizeof(entry)));
+
+	pmd = pmd_swp_clear_exclusive(pmd);
+	softleaf = softleaf_from_pmd(pmd);
+
+	WARN_ON(pmd_swp_exclusive(pmd));
+	WARN_ON(!softleaf_is_swap(softleaf));
+	WARN_ON(memcmp(&entry, &softleaf, sizeof(entry)));
+}
+#else  /* !CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
+static void __init pmd_swap_exclusive_tests(struct pgtable_debug_args *args) { }
+#endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
+
 static void __init pte_swap_tests(struct pgtable_debug_args *args)
 {
 	swp_entry_t arch_entry;
@@ -1322,6 +1361,7 @@ static int __init debug_vm_pgtable(void)
 	pmd_leaf_soft_dirty_tests(&args);
 
 	pte_swap_exclusive_tests(&args);
+	pmd_swap_exclusive_tests(&args);
 
 	pte_swap_tests(&args);
 	pmd_softleaf_tests(&args);
-- 
2.53.0-Meta


