Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA170CD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 12:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F6236B008C; Sun,  3 May 2026 08:50:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A6AD6B0092; Sun,  3 May 2026 08:50:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BDA06B0093; Sun,  3 May 2026 08:50:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2856B008C
	for <linux-mm@kvack.org>; Sun,  3 May 2026 08:50:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7D674068A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:50:25 +0000 (UTC)
X-FDA: 84726092010.06.EBA631C
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf29.hostedemail.com (Postfix) with ESMTP id 34074120003
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:50:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777812623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0MWXkBKZqMd3Zs6KVqrr+JJi3EJ9eGiSwnwK8ksuMcQ=;
	b=hOwnH1GLVUbQtJvgvqnawIu6Y++xqWrKbWD5nIPRtvnxf0iTHoSroPHNSAkx/T2LtuQxqz
	PLVMZCdG5cROV8GuL4HGOBJehhCxHrneHKVR47mjDXQH75LLRNkAsgiMQvZFb/OSETFZRN
	luWPGCXZlfwbLa4mPreOGtxeNWs2xPg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777812623; a=rsa-sha256;
	cv=none;
	b=tioVwiQFZFfNClOKY/S0wqjz6Xpz740mw3Iph36w2AiRVb5Ah71WfbI34H3uP2f1LTOzvP
	3kkZ/vdJx3AYgVqNtZMH+pEPViM60vZSyyPEDn1x82SpMbzBq0TUrUnbOfgwk9UF0PvVAN
	VRSay8Gwr/UukfWoui0Ga5ccBxx36vw=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4g7l4D4qKhz8Xs6X;
	Sun, 03 May 2026 20:50:20 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 643CoCDh065255;
	Sun, 3 May 2026 20:50:12 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 3 May 2026 20:50:13 +0800 (CST)
X-Zmail-TransId: 2afb69f7448598e-4e661
X-Mailer: Zmail v1.0
Message-ID: <20260503205013850sym7UO0jvKJzyRiTYmO8V@zte.com.cn>
In-Reply-To: <20260503203538194jFwVGloy43M1F3sQGaFt7@zte.com.cn>
References: 20260503203538194jFwVGloy43M1F3sQGaFt7@zte.com.cn
Date: Sun, 3 May 2026 20:50:13 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
        <xu.xin16@zte.com.cn>
Cc: <hughd@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <michel@lespinasse.org>
Subject: =?UTF-8?B?W1BBVENIIHY0IDQvNV0ga3NtOiBPcHRpbWl6ZSBybWFwX3dhbGtfa3NtIGJ5IHBhc3NpbmcgYSBzdWl0YWJsZcKgYWRkcmVzcyByYW5nZQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 643CoCDh065255
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Sun, 03 May 2026 20:50:20 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69F7448C.000/4g7l4D4qKhz8Xs6X
X-Rspam-User: 
X-Rspamd-Queue-Id: 34074120003
X-Rspamd-Server: rspam06
X-Stat-Signature: stp6cbodctxp9iu69b1uu4xoiaq9iq7k
X-HE-Tag: 1777812622-278353
X-HE-Meta: U2FsdGVkX19ATwL45SqzSM4ae2vxXRcf+O+5SaXs7l5CsBJyFOkdjv0BFjsH++9WK6MIeb7FXOFp6kBn3ZNlYOmT2Ku7lyjkczjGToH89W5+QHVWvfCpePSlPbnwcCKBmUKm0UnW9BoU3anZTqHWZO/WA/EwbRCLuF9O/8rjVE2J8PI2inhWFuF8xqGGyQ+sdVboXvGqnCHNB3jZcdTVk/2epVXCH71tumngSALymm1KG0eSGtz1oTSzGqc11jZNt/rATVKyMme0TuEad6ob7IO6YmGY0HHjNuvyLA4bcyOkNXIfKwJs8QzG5VgCF2hojaa/MufLaKlGKj+8N8YMi25H6/cjYq2hhcwyXUsjKLLlZs0zQgen4EhOx5pzXp5UWSviVpRcVbPu2xLCisv46F60Q17K88nhA49jigLsQ38KH5DnjF3+TEMLcRdvdmr2kW4Q58hdIgNz/+onv/p2pwTNrT2LsdSgpa7H+cXWPylwOqtArLXZ7tTEH6hDhfdD6MbNz/6lT0QBR4b3Du28FG/uTjH607aexJp0ji2qY+WI0Si5IFjJ7JtWk8tGh80IsoLygUg+3xe6nxtHLGtR5QiflYcwunTZ0aYt08MZOhhjIcukA71SP7p0MNt29jUUiuI50kMX2TFx3ha7fnLvJHSaVXCh6Xt/pw67UUWleZZUg8z7HGh+RapnjsLr81/Ijx4lLYXOygDudAqgqolafv8UVkzxsXYuUPynsH8LNgqTmPY7QowT6S43xzBEmj7etnUVeQit5SbHYcCs0nmId8Ylst9iGqPJRqxZrgujqHzVF0zLg8DYjaZs8Jb8QfZG4A2DFEviQa+lH07XMXZzt2R8/dWrMIcJOxoq7ookUpUdFaZTUPrfvcycqfcSgWMry1H6oi/z6giiGaEjThn7KZ3+HkluelwgjdXPOTaRinHXDeGpR7zD7j+Zm/2rEk8JlSxBQ2HhKWZ12Rlyrvx
 K8KYdT+C
 Lq7VtEEpA4ITBIDKdDGXTjPo52oO6LBdQUv7QFIMRtrl2qxfEdx34qLEqxHQzESqtC7I6ZiHlnk5FgWMy2S4uzsrdo9EZdAX1szj630k0qAjep/EfTZPHTpXVy2ELPPEVeShff75KTwO7USmZzn33XTzItg7oGbDvwJW4KrhBAAhshs9XKK/gpye+eEuDf4cwG8Ijn1XY3xGfPKu38LAivmjneIj6m5gDVmJfPmaOPFWmwUjC4Zua7k5kzwCihS/fRRDDXhKzwI+d201rvohUd2EhahXlQou3soanfRs09bSgJF4=
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
We cannot rely solely on anon_vma to locate all PTEs mapping this page but
also need to have the original page's pgoff. In fact, I believe only the
original vma->vm_pgoff is just enough. The implementation of
anon_vma_interval_tree_foreach — it essentially iterates to find a suitable
VMA such that the provided pgoff falls within the candidate's vm_pgoff range.

	vm_pgoff <= pgoff_parameter <= (vm_pgoff + vma_pages(v) - 1)

Fortunately, we have already vm_pgoff in ksm_rmap_item in the previos patch
of series, so that we use it to get the pgoff to accelerate the searching.

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

The result is shown as follows:

         Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
Before:  228.65       22169                 22168                    0
After :   0.396        3                     0                       2

We also provide a rmap testbench: tools/testing/rmap/rmap_benchmark.c
The testing result in QEMU is shown as follows:

	Maximum duration		Average duration
Before:	705.12 ms (705119858 ns)	532.04 ms (532041586 ns)
After:	1.67 ms (1665917 ns)		1.44 ms (1443784 ns)

Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 0299a53ba7c9..a13184d00759 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3200,6 +3200,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
 		/* Ignore the stable/unstable/sqnr flags */
 		const unsigned long addr = rmap_item->address & PAGE_MASK;
+		const unsigned long vm_pgoff = rmap_item->vm_pgoff;
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
@@ -3213,8 +3214,12 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 			anon_vma_lock_read(anon_vma);
 		}

+		/*
+		 * Currently KSM folios are order-0 normal pages, so pgoff_end
+		 * should be the same as pgoff_start.
+		 */
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
-					       0, ULONG_MAX) {
+					       vm_pgoff, vm_pgoff) {

 			cond_resched();
 			vma = vmac->vma;
-- 
2.25.1

