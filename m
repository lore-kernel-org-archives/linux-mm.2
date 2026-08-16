Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57387C5DF74
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B49E6B087D; Sun, 16 Aug 2026 18:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28D246B087F; Sun, 16 Aug 2026 18:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B75C6B0880; Sun, 16 Aug 2026 18:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DB51C6B087D
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D44F1A05F3
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:08 +0000 (UTC)
X-FDA: 85108619736.10.0E16E76
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9847E20007
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="e i6Waa0";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=KctISWAq;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/bEmHChGXXUr4LI/M464ypgkDiKtYjukQog+PJvxwc=;
	b=2yAMkACfv3SLTfN8ulh/oUM1vDL7zk+9vN+0AtkiRTKnB45QN0zesudI+5RiD8wTSatwTX
	XZ4dpmd6/Eva/Gw7x4S/cvGC0ckICCF6P/eeLBQozKorjNkOIwSHivgmupDOBqXp1z+jHo
	+NJe5QNYl8WNy0ekUDRxsQnJRA4L2uU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920426;
	b=sOree9okHsgG1ZePU2sT8PXY2k6YJMDe12IMLqtRLnekZ2tXCbmyEamuqUOKAX5uKF4lb6
	/+nMMpa5VgPDT1iTXzcl2NqeiLGDK+yE/u03B6lJigEYbTjnw9ZkqhdVmsAds7Kugm1B4Z
	aCLjj4a9nonbeXg6z+sfnqGpeb9Dwvk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="e i6Waa0";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=KctISWAq;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 33F2514000F8;
	Sun, 16 Aug 2026 18:47:06 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:47:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920426; x=
	1787006826; bh=g/bEmHChGXXUr4LI/M464ypgkDiKtYjukQog+PJvxwc=; b=e
	i6Waa0kx1JeztwEvkH7Ff200lYEintKhm9n8taz6+bc7eEjLWupgfwUZ7CWItYkM
	2Rn43iFJOvlPRnH51Hgg2xJ7+H7866S3YBV7YbWu1LzMtr1v8tS0Ozue/Tf1ZSYQ
	Fr9Kh7fq0yU1zBXvlJzbNWo6FVL0RQ/i6dy1wYd6jN6FAvBpvDOv19Zp7Ae4VNdK
	hqIdJA5GeQO18Qm4hGbkOS32fUXEqf512NYKfKFchNpjNRXFGPuuWYL9cK7GUupI
	E5iOXDGzSn3jQAxqA1rGfPfXYsbPcP5mf8Uu3VdY7Ng2qrsnUURbYEpMw1rXOrH+
	AhXf+0FPEOh2Y0pdB3Rqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920426; x=1787006826; bh=g
	/bEmHChGXXUr4LI/M464ypgkDiKtYjukQog+PJvxwc=; b=KctISWAqOVGNzO3uI
	qUUJkvTYfOuq8nQ9ZBuU3O7uZQDSx6Y23srlgaQ2pPIN98XBQHk0crb7X2+82lI9
	47S3CEe/ZbBo1+Yd+Q3SszJ5WYGeCCw0Pb+jekaXRk505lB06Ol0XHi2ePnP3p8p
	JCZSQT2Ct7CIBoci6RVWvambGzUrqgr70a8Nu842IaglBiwaZvCCu2oE2Wb7FteH
	44Wb4fDGgn4XCO0TNpb8iMuGW1f7r4/EMOuau7bZqwcquYtnctmwb03QbgRAzCKg
	tCxf7D/xKNQoW09nKQLobQf+vzzbuWcSTndkfMPifmJnoNcq5rFaii3A7e0mf5dJ
	jz3Yg==
X-ME-Sender: <xms:6j2Cah_2sr1iVSXmYImE-dJCURkscxE_V7MGFYQgcd-596KcxwOSIw>
    <xme:6j2CarDaWR8aP6VuAvuATaLhOOuh2tbrxoMJHVIHcj5yTmPrjr1NjChf1f6TzkSxr
    9ycyM0x21ffu0xrbnQMKXRY_7kqSnPrj1VzUvlaRv2iN2q-KzHM5NVj>
X-ME-Received: <xmr:6j2CarE0yqrEd0f2GsEVz6n-PruGtAMFlYO-E4_t0GmMcXD26B2y-r5_ghg>
X-ME-Proxy-Cause: dmFkZTGlsoL4dlGZVhjNGnyng7DWLkzd23+vL0S14uJaq1tszuZ6c/qXpcKjIN3SVavrqW
    anksLy7isjEKJzVCE9/It/QcezLPAumFeVWWYf/196d5DKxXijJBwwHlwdbhLN8+Q20ZSw
    VAcGFAGUZDfCfgJltT5NnBIG4Gh7JxdfG7re68r55pgQSoCRLBnoP1i35vKgO+O/kd9+lz
    qLG43ny3AnvUx0aE1SnxP3FJCiuv2lDE4FRTwfST8/uDABclrMy6sZKUEjfd1WPzb5NlOP
    S5qghqIOcnVKJHuC+GM/K5ckB8SXpR6Ag+KqE5QSQT/v+DpSzaOOJbUo2XdsQxu9tqIPpv
    n09TP7n+3O6PIcr4WyyYUg9u90X9r/cVsCqHguDiVmkz5B1ez36ZmXEudDYtVH55+e6bCK
    KD2uHs8jsljSrOCCQPiL6eMr8S6teHqR+yZdv5bSo99ujysnSUwODNY3DMq2uOuYhc/B1K
    zQd8gpF7lAHXJCYb5Gf3L/8gFrxBSdbUcXNXwSJdHiMT6VIr0Hbyj5mC/SwERAeAvPFx50
    mW3688759fv6PqAubbjBheKUmrOIHeCnR7QwRCZHDUwZPqhY9eJVsFYJ4M8BVHsY7amxmx
    /+VZW7YyA4oFHyCdj4h7m+U9nJCAvQgbWOMZ55UwAOCzJinUKyhZTVU0sDzA
X-ME-Proxy: <xmx:6j2CaiBYKFJ9JEQPyD4Ht4sRDGqQejtQ8K3vEEF_M-w69Czph1Kuyw>
    <xmx:6j2CaseGOzdZVy9VVB0tVx2JaQZaQc5t3rj7yw0BL5oDUxgtSBxOyg>
    <xmx:6j2CahJL5OBptOY68ktfWz7AoPlzlXqQZJcJmDxqPCZlKPu6bQXBvw>
    <xmx:6j2Calt3BgrxVe-AL65jGOfKxgsTkK47V59fEBP8Dz4GqSqA_KOIrw>
    <xmx:6j2CagwMipzX3UJtB1-Vp8W4qatAWCj_UL27CW_krc7w3RNgwzJuhCct>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:05 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 25/57] mm/collapse: collapse anonymous memory with the new engine
Date: Sun, 16 Aug 2026 23:45:37 +0100
Message-ID: <20260816224609.308019-26-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8bf88knfhcmik9mkii6uxqof1rtcezwc
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9847E20007
X-HE-Tag: 1786920426-700098
X-HE-Meta: U2FsdGVkX18unY82CXQ3xReW3fH1udMocA80k2mp54vNzcrIzH1N5cnvSOxByxFj8B47pr8HuKmO/6Tz0+LI0jXbXTKo7X1FcyTH6ihlC4CNWKlHQOTC+EKT8Qon+2moWi0r8A+NUgIol+Pf8Ps22d3o1/DoBe8/fEiFhXSwfch1w4Mbt4fwQyh02c2wDFMjU8J0h4zFUomZGh3jfDyuygKNOyg3D+DpV9UJnzP8wGENdk2DVA4vbD9uMwTQgO4VxPech5314oUN8+5JlXmUPMybIjqQ10u03nUmKTHFIrXZn9SkaznIys9AnzXvgg4wcNw8PVwpXFCbuC8Xsu8EC7acKefHC2xFg/LrEfmIkWxWeI76x1WwqB5lRy7cU9Oc0sFozykr0gl3RSl7CDRzlEAgvoMtyeS3Qctg0dOL6Qe5MN77y3zAq8uJsv3hyjEGSQVRa7vZb3+XWc/+lWY3rVbjs7Bg4prqTVr33Ef9he4cgkIYt7M+uaxeqV3MfPftDhvNVcm3RpcUHEbhGRHZDBRch5Gys+eoaLTC9a4mO3fIyQQF+JW43szbMnJ4lPVrb/nucnR8636t4jODRY0CZFLgtlkwxJa1ix9NYL9HSnbFf7f5/KAaIgB91FIbdCjfT8Se4xXL3/J1dBoKC6WZSpVnVS5Ik9cwuEvjRQalD4zyqgdMYrwU5/Zx6NiqKPTEmFruxBNun74NnfXWB156I4uk62g8EFX22GzmZQdeH6uaTdoz+Xr0KxMZkyaoz32agswr6/BbS/GN0LdMOgNhv57U307IVqFis/WGyT0H2ldlMnedfyxIQLZ+8HTnfql48yKBpuQiDlOvAmNZQXinPvJ5FzhjQmK/blrZMmx6a/hMG4Xc85KNin0Yrb5+d/Fsa1eEfo2FLNRrE7IZipJrAcgQAazK8UibxoW5WM6xC9EwdhSEBddesCJC8XOGw9Xv5zu+hDX5sIEYHjgSK/X
 fK8SwUN0
 uHhRczU/634a/SLy1Rhn5CHsIvtwjXTaRtpuu6WWqiroyxfWDfHCnFM+IeP5c0Gh3awHlJ1diH0LtevWsWjVn2XMwRJYqprxHUs5JI2Os/maIq2VBmZvYbYIGiCyvmLziM7Fx+WsUekXWuhbagcvlwcmQEhNZsUnhlEZBTCpkOzcoor4GZkRubNKMkYIXwngf1qUUL9EnXd5aLWB18/g7oXsKF9WU0oYiA26AuplhT9EY48sK1oGSFb1dC1760x8X/XGHNQ9ULtRbwd6hPslat722mmLd03yv/1oEpS17Fw96Gycn/fznIXi1HaltQv/ZwX3J4/pR3cjvOBq3EfYiFeRsSOzWoNL+fKxVENn+vwz1lFv3ip//is2J3mIWfecft//RCDFmR+bVtvHR1x1kcIo90zpCSDsYQajD95QAuO5c38eUAQCActeiXldgh2rwKock3wor4DNrSP4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Point the anonymous path at the engine.  Everything it needs is in place,
so this is the whole switch: collapse_single_pmd() calls
collapse_scan_anon_pmd() and then collapse_anon_pmd(), where it used to
call collapse_scan_pmd().  The scan runs under the mmap_read the caller
already holds; the collapse is called after dropping it, and takes the
lock itself for each round.

Both callers hand the engine a PMD-aligned address with the whole table
inside the VMA: khugepaged walks [ALIGN(vm_start), ALIGN_DOWN(vm_end)) a
table at a time, and MADV_COLLAPSE aligns its range inwards the same way.
So the range passed is always the table.  The engine accepts a narrower
one, which nothing asks for yet.

Two things userspace sees change:

 - A collapse runs under mmap_read rather than holding mmap_write for its
   duration, so faults elsewhere in the address space are no longer
   stopped while it works.
 - A table that cannot become one huge page still yields the largest
   windows inside it, where before a single disqualified PTE gave up the
   whole table.

The result the caller gets is the engine's, and it still acts on an
allocation failure by backing off.

The mechanism this replaces is left in place, now unreferenced.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c   | 15 ++++++---------
 mm/collapse.h   |  5 +++++
 mm/khugepaged.c | 14 ++++++++++++--
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/mm/collapse.c b/mm/collapse.c
index 91ff20138a8e..df3760e3918b 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -83,9 +83,6 @@
  * consecutive pages of one folio -- so partially mapped and compound sources
  * collapse too: any order below the window's is a source, and a PMD candidate
  * takes even a PTE-mapped THP of its own order.
- *
- * Nothing calls any of this yet: the anon path still uses the mechanism it
- * replaces, and is switched over once both halves are complete.
  */
 
 /*
@@ -1926,9 +1923,9 @@ static void collapse_anon_scan_init(struct collapse_control *cc)
  * that acts on what it found hands the range to collapse_anon_pmd() afterwards,
  * without the lock.
  */
-static enum scan_result __maybe_unused
-collapse_scan_anon_pmd(struct vm_area_struct *vma, unsigned long start,
-		       unsigned long end, struct collapse_control *cc)
+enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
+					unsigned long start, unsigned long end,
+					struct collapse_control *cc)
 {
 	const unsigned long pmd_addr = start & HPAGE_PMD_MASK;
 	struct mm_struct *mm = vma->vm_mm;
@@ -2337,9 +2334,9 @@ static void collapse_add_candidate(struct collapse_control *cc,
  * largest order downwards.  Returns what the table yielded: a collapse, or
  * the reason it did not.
  */
-static enum scan_result __maybe_unused
-collapse_anon_pmd(struct mm_struct *mm, unsigned long start, unsigned long end,
-		  struct collapse_control *cc)
+enum scan_result collapse_anon_pmd(struct mm_struct *mm, unsigned long start,
+				   unsigned long end,
+				   struct collapse_control *cc)
 {
 	const unsigned long pmd_addr = start & HPAGE_PMD_MASK;
 	unsigned int offset, order;
diff --git a/mm/collapse.h b/mm/collapse.h
index 34de3ebb05e3..50a9d59bbf03 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -186,6 +186,11 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }
 
+enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end,
+		struct collapse_control *cc);
+enum scan_result collapse_anon_pmd(struct mm_struct *mm, unsigned long start,
+		unsigned long end, struct collapse_control *cc);
 int collapse_control_init(struct collapse_control *cc);
 void collapse_control_release(struct collapse_control *cc);
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index c7c933e819e2..0662d08f7c60 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1553,7 +1553,8 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 	return last_result;
 }
 
-static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
+static enum scan_result __maybe_unused
+collapse_scan_pmd(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long start_addr,
 		bool *lock_dropped, struct collapse_control *cc)
 {
@@ -2749,7 +2750,16 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 	mmap_assert_locked(mm);
 
 	if (vma_is_anonymous(vma)) {
-		result = collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
+		result = collapse_scan_anon_pmd(vma, addr, addr + HPAGE_PMD_SIZE,
+						cc);
+		if (!cc->select_orders)
+			goto end;
+
+		/* collapse_anon_pmd() takes mmap_lock itself, where it needs it */
+		mmap_read_unlock(mm);
+		*lock_dropped = true;
+
+		result = collapse_anon_pmd(mm, addr, addr + HPAGE_PMD_SIZE, cc);
 		goto end;
 	}
 
-- 
2.54.0


