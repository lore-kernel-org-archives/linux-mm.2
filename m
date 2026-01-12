Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98915C9EC90
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 14:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05F4F6B0088; Mon, 12 Jan 2026 09:01:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037006B0089; Mon, 12 Jan 2026 09:01:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA6676B008A; Mon, 12 Jan 2026 09:01:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DBC046B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:01:55 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7840216029E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:01:55 +0000 (UTC)
X-FDA: 84323475390.19.453B73D
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9E82540024
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:01:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768226512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4SN3qenemYADI/7eWK+39sOxBnkZ4F2cbQuk21h5vYo=;
	b=wXoiKykikdWxVWB6smCa101RZZMfHSg9R5c2k8UctkEumZKWF6fPGPR2FVaeG/PyvWpF6Q
	IYKl+6mvKrVZvfeh7IC27ez+e6TWR5Rue8CsgpcqL6UGUOLfixPAxnSVQhPWQUnVa7ZrYv
	QcWtMFh0ujN6PFJgm2OoL4MVQ73HbaY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768226512; a=rsa-sha256;
	cv=none;
	b=oTc8Y7OUCGgn+mNVQwOx4Cnq5xx3Bhzb4rzXwIGsjFvX8h7ZYRqCUwTgxYOgm7O+T6Uspd
	lTb7MQIl6HyNKOWthHm8MgPV/eu55wcyWxUH93ne631Xb2vRxsg3WkajBNgmevgTSJYqQs
	WDPhyo56L88b3naHZO0FlXYS6/P6reY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4dqYvv40y9z8Xs7C;
	Mon, 12 Jan 2026 22:01:47 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 60CE1ehK014327;
	Mon, 12 Jan 2026 22:01:40 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 12 Jan 2026 22:01:43 +0800 (CST)
X-Zmail-TransId: 2af96964fec7049-3551e
X-Mailer: Zmail v1.0
Message-ID: <20260112220143497dgs9w3S7sfdTUNRbflDtb@zte.com.cn>
In-Reply-To: <20260112215315996jocrkFSqeYfhABkZxqs4T@zte.com.cn>
References: 20260112215315996jocrkFSqeYfhABkZxqs4T@zte.com.cn
Date: Mon, 12 Jan 2026 22:01:43 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
        <chengming.zhou@linux.dev>, <hughd@google.com>
Cc: <david@kernel.org>, <wang.yaxin@zte.com.cn>, <yang.yang29@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIDIvMl0ga3NtOiBPcHRpbWl6ZSBybWFwX3dhbGtfa3NtIGJ5IHBhc3NpbmcgYSBzdWl0YWJsZSBhZGRyZXNzwqDCoHJhbmdl?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 60CE1ehK014327
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Mon, 12 Jan 2026 22:01:48 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6964FECA.002/4dqYvv40y9z8Xs7C
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9E82540024
X-Rspam-User: 
X-Stat-Signature: puajfeudzdp91kmi1fyrnzmjig6761wx
X-HE-Tag: 1768226511-451327
X-HE-Meta: U2FsdGVkX18lO1A2bYxrAcJPHG9X5ZJZyeiHW9fXMkwi5bvmWMXFFAo5kVRpq2RRrXPOLfEX3r7HwdGulkUz8cLr08brQOSan5cvIoY9vIvsQj9b5Ac1q4FS5auao8urLvI/zFp7nayDJ98WzUzNxUImGhgvMTI0fRHGf5LDghhtXlzqb5abjLAPZJBkHCkAG4uoofSfOjvg6/uJ7BnVnnRQDgPNAuifG/iQ8+jMZUJhCAQKLgfVcLSuItIcABAXAUnDp6y+LqyRo/x8lpStGkj1a8jUI7b84XDXmfk8awXh5p9qY4pqNpQ5ljHodkTeeKtEbz5Hh6lryN8O37Y9NtA54+2P/OL5cGwDu9J24k7CFRs8jPBQWhAz/Dz+irVqgdMJZ9ZIGM2rPKovlMhvblI4XRPCFtAbdxmXbWkzxne4AzD/tA5klOjhJUvl1jogg5BmpHrWFszlDoTqQMXQIzprkseON5n65vykFmMm3R1hmN/xcO9LFMmM8OX/gf8nMmiSxC1xEKOCwhL3hBbH7pk3f32CeG1PQKxU4MLB/zFv/I49CdjNKCux8rUksRmlweENDQvSPL2QK1NVPJLf4XyJESPSA35x64hq7DljwsAA+cnM426/ff4N6PXwi0aw1uDMqnt7O1H1U8K+uvvzpJbL6eWvM8ShQKBJDDlIwT9Jq4T4Q/qPagfIAPNosSNbh+QsbHCKKSBzJfvoBKfwKApjKEVrtcMhHxnoq9BH6o3kXUfQLKh1HDTJ7C1PO9E1FgqrBXKv+zKBoY1KL1Ha9O1yNfOSKRq/3c6iM7QZeObkrKFgi34hDn0EQX1oLFzvHhwB0qKI3+dwDfG5ilF6Cs4IcnysmYDbIWZVQrKB/SWp4itj8ZnTBm4ewAU85t/S9cNyn5JYehrth+y8Mo7xY6i0hUJwXS8bsGZO9lHManQWITv4ap5zcAvFhYa04YCkqRbHkb8f248hEJR+971
 ASEWJiNQ
 ntV42DbMk8yx8GYpRTkj+45LOE9+DCbKSlbWxmxKI293iLcp1U0yoKjYM0IAUHHmA+WaNTVowjF48hRkpm+bsP85Y3KVw4ilRRteC9EYMRMApl2NBrjDS8oHyYaNzTPUlJtuprWJHP4bWxOeqOzhoRxiFM0O1O4yN1S+8JfqYmtIpiU5Cpt3c7intHldNRv0R1Ik0u5zAjm3q92yFBByKP4/66v0IQqypZIGO
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

Root Reaon
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

	pgoff_start = rmap_item->address >> PAGE_SHIFT;
	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;

Performance
===========
In our real embedded Linux environment, the measured metrcis were as follows:

1) Time_ms: Max time for holding anon_vma lock in a single rmap_walk_ksm.
2) Nr_iteration_total: The max times of iterations in a loop of anon_vma_interval_tree_foreach
3) Skip_addr_out_of_range: The max times of skipping due to the first check (vma->vm_start
            and vma->vm_end) in a loop of anon_vma_interval_tree_foreach.
4) Skip_mm_mismatch: The max times of skipping due to the second check (rmap_item->mm == vma->vm_mm)
            in a loop of anon_vma_interval_tree_foreach.

The result is as follows:

                 Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
Before patched:  228.65       22169                 22168                    0
After pacthed:   0.396        3                     0                        2

Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 335e7151e4a1..0a074ad8e867 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3172,6 +3172,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 		unsigned long addr;
+		pgoff_t pgoff_start, pgoff_end;

 		cond_resched();
 		if (!anon_vma_trylock_read(anon_vma)) {
@@ -3185,8 +3186,11 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 		/* Ignore the stable/unstable/sqnr flags */
 		addr = rmap_item->address & PAGE_MASK;

+		pgoff_start = rmap_item->address >> PAGE_SHIFT;
+		pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
+
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
-					       0, ULONG_MAX) {
+					       pgoff_start, pgoff_end) {

 			cond_resched();
 			vma = vmac->vma;
-- 
2.25.

