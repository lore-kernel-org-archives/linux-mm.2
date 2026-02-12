Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4040EB4908
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 11:30:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B08B6B0005; Thu, 12 Feb 2026 06:30:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 371AF6B0089; Thu, 12 Feb 2026 06:30:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2744A6B008A; Thu, 12 Feb 2026 06:30:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19C5A6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:30:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE9081C167
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:30:57 +0000 (UTC)
X-FDA: 84435587754.27.6D47C37
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id F3E018000E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:30:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf02.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770895854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eaGbk+egOFBXU+UzOtKAyyywgDKNNkNlq2LxYsvzcA8=;
	b=Rl9wZaz7K9UjTntfv4UpEe8v0feFlQHp5bV3KbPLXU0y7KesA51nMzw7QJdfUaybBetd9o
	6K0N7yYwIUvRhuhKDISlDIm+zzvq0dFPrj1dqGSlpaoOm7vdNFLxarDxHqeVfZmeNrBONR
	no0yLj/oHLDjCGHYRxvMK4iEJKENO2k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf02.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770895854; a=rsa-sha256;
	cv=none;
	b=kZ9O3v7UCLjfK+YOaUY2T1SWJDe2Zq6ksthAJPda3GRpKLYNFYGO0WLdyE6Urbc3rv1a7R
	zI/p8heUIxyBZ5hQwzq1rg8mBo5S0HaOflUMPtPWijWOH8S2pPTHSsJyi4IjWKy7pxC9pF
	DbCPzY8nlNmt4L+63ecuCLlkL13mFtk=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fBY5R098mz5B12g;
	Thu, 12 Feb 2026 19:30:51 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 61CBUgRV087278;
	Thu, 12 Feb 2026 19:30:42 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 12 Feb 2026 19:30:45 +0800 (CST)
X-Zmail-TransId: 2af9698db9e5ab7-3e9e3
X-Mailer: Zmail v1.0
Message-ID: <20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn>
In-Reply-To: <20260212192820223O_r2NQzSEPG_C56cs-z4l@zte.com.cn>
References: 20260212192820223O_r2NQzSEPG_C56cs-z4l@zte.com.cn
Date: Thu, 12 Feb 2026 19:30:45 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <xu.xin16@zte.com.cn>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <yang.yang29@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHYzIDIvMl0ga3NtOiBPcHRpbWl6ZSBybWFwX3dhbGtfa3NtIGJ5IHBhc3NpbmcgYSBzdWl0YWJsZSBhZGRyZXNzIHJhbmdl?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 61CBUgRV087278
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Thu, 12 Feb 2026 19:30:51 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 698DB9EB.000/4fBY5R098mz5B12g
X-Stat-Signature: etrhn913dfge3r6zk4g3szsa1go9g96m
X-Rspamd-Queue-Id: F3E018000E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770895853-305731
X-HE-Meta: U2FsdGVkX19oeQpTp5EeWGpputq5lpQU7oTKQX+CDN3L7SpJsq/vKIjUI/8DW1D0lP/+q77PWvksxD6BMrEiDb1GQBCMNcllD5dVmNdKq/MydGcaSRYGNAFH6UJYikuAUJGt53tJQ/V0eEvDx3XiWfUbccWF9/Iw19zwjV45DRtzhjw32iTYTaau7Aa2zDE3oxRqGu/WbmDeQCFDz1/VXmSv4HWbMbeat+XKWR4reMuVOXvo6eFcawTeMPJRYCMa9dLvjdp6OfrAH5T9fe9yMN/terTZsHbxSpTRr834Fd6pcdgHsvwiVCT3X8gWpjLCLmpvE7kZ/sRyUoD5tTDR8hepq8jJ8cuJAzh9HAfabDCOF35w6uu9DIu0O+wuXyqz3du/DvVxbcd5Cv5WE2M3BmYHKKC5SmLX1tlpIIjBfGwiwohSe3tef/EBZjrWDf63iDLzyLMoN5gByOwVOTFLwVLqB/8aB0oWgGtdD4Jfeew8yGgUGc8aXYDF9MRmAhs+lU+i6fNq/ZmFSRCeBGJcmVPv39kfBJHgtpVcdmZaQlutuKZpf23bnWJunRIbtf9BCrjICZWamM5aAJh78TgGn9HzjZOLQSTxqRONSD/8fUBv3TJ0LNwHz5mPsl7hYv7iljeukfm1t+djCdy+zVry1jO45+djddxk5YHIhLSVOFuwYRdrkWwUBzmajIvQNzgbgIgzFEsgG3izppneGJXzQIszXq85JctwirXulrOz3bnkGYy39Hh+uiu+JPIJI0D0kF343KI6+FTbm8Q9zn0u4MZErJOxdMrf6T9XYSMC05RQwLqDX2tM1DFJIwhSLDQLmvCNaHcsQ+00FRsXKY74Wk9PW1SYu76J+Rayh4rugtYglJa6GKOE25eIvM/QqcWPnu6D3lMZgrNhTk9QJ+6TYrbCVtsmM5mJW9zYdhasIthkKS5G2qMNLHAry7/yjzX9ctn9axHHZHUVYXImthB
 JKWFG9X+
 AsnPY1elhmxcAIXKG80i0mZ+AH1Vl70gyHSvS7m3MaRuSGUaTiEJ39aHz2xphInvSDI1yumnKLi1mjPECycDvUybxqSg2NyivPCwYPRSj7UQuKgDnjOhzeGjszftgJF/GZHPTvsd8/BCz0MQDsNWGUa8Gu5g/ocKQhZ6MF3zOMjC4cZsoKa1S4KEB8bcTCEgfdHrbVWqTk2dW1SQB52kpotsT4rk3G+2qStUf+r98TJHBQiPG8w6hjbqWrBGnsAQJMXzRSEP+K2Sl7KDGndt9MJeFSrD5MZrheOgq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Problem
=======
When available memory is extremely tight, causing KSM pages to be swapped
out, or when there is significant memory fragmentation and THP triggers
memory compaction, the system will invoke the rmap_walk_ksm function to
perform reverse mapping. However, we observed that this function becomes
particularly time-consuming when a large number of VMAs (e.g., 20,000)
share the same anon_vma. Through debug trace analysis, we found that most
of the latency occurs within anon_vma_interval_tree_foreach, leading to an
excessively long hold time on the anon_vma lock (even reaching 500ms or
more), which in turn causes upper-layer applications (waiting for the
anon_vma lock) to be blocked for extended periods.

Root Cause
==========
Further investigation revealed that 99.9% of iterations inside the
anon_vma_interval_tree_foreach loop are skipped due to the first check
"if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a large
number of loop iterations are ineffective. This inefficiency arises because
the pgoff_start and pgoff_end parameters passed to
anon_vma_interval_tree_foreach span the entire address space from 0 to
ULONG_MAX, resulting in very poor loop efficiency.

Solution
========
In fact, we can significantly improve performance by passing a more precise
range based on the given addr. Since the original pages merged by KSM
correspond to anonymous VMAs, the page offset can be calculated as
pgoff = address >> PAGE_SHIFT. Therefore, we can optimize the call by
defining:

	pgoff = rmap_item->address >> PAGE_SHIFT;

Performance
===========
In our real embedded Linux environment, the measured metrcis were as
follows:

1) Time_ms: Max time for holding anon_vma lock in a single rmap_walk_ksm.
2) Nr_iteration_total: The max times of iterations in a loop of anon_vma_interval_tree_foreach
3) Skip_addr_out_of_range: The max times of skipping due to the first check (vma->vm_start
            and vma->vm_end) in a loop of anon_vma_interval_tree_foreach.
4) Skip_mm_mismatch: The max times of skipping due to the second check (rmap_item->mm == vma->vm_mm)
            in a loop of anon_vma_interval_tree_foreach.

The result is as follows:

         Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
Before:  228.65       22169                 22168                    0
After :   0.396        3                     0                       2

The referenced reproducer of rmap_walk_ksm can be found at:
https://lore.kernel.org/all/20260206151424734QIyWL_pA-1QeJPbJlUxsO@zte.com.cn/

Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 950e122bcbf4..7b974f333391 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3170,6 +3170,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
 		/* Ignore the stable/unstable/sqnr flags */
 		const unsigned long addr = rmap_item->address & PAGE_MASK;
+		const pgoff_t pgoff = rmap_item->address >> PAGE_SHIFT;
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
@@ -3183,8 +3184,12 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 			anon_vma_lock_read(anon_vma);
 		}

+		/*
+		 * Currently KSM folios are order-0 normal pages, so pgoff_end
+		 * should be the same as pgoff_start.
+		 */
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
-					       0, ULONG_MAX) {
+					       pgoff, pgoff) {

 			cond_resched();
 			vma = vmac->vma;
-- 
2.25.1

