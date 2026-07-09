Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0024C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91DF76B0088; Thu,  9 Jul 2026 13:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE786B008A; Thu,  9 Jul 2026 13:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E7176B008C; Thu,  9 Jul 2026 13:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 423716B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:33:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2689168DC8
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:33:53 +0000 (UTC)
X-FDA: 84969935946.26.77CEF64
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id CD95CC0012
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:33:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Z/GvK7QY";
	spf=pass (imf10.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HdtO2LUS3BfbYCc5UouYbQ9tOWtdjh92xlNm6EsNhlI=;
	b=aNiJUs7hgBJ6EpdPBmLpcZQfMSXLs62rx23A6nkzoWBFkbTNhk8Iju4IoG6lWrERTyrEjH
	m0tgVArbEURgClQaRc8SeWpK/6aK7xgmKBxEiqtyLYtHh//Y8HvdlROUAi0+lCeH9mxbAk
	0sG/hZElMmHPRMIlLF6xOTdyDEmpLOk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Z/GvK7QY";
	spf=pass (imf10.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618432;
	b=7bnbiuv4/D5/tE92F/ooC3DF/MA/OhqgiHVdOLox6NeSbfmuTXdTCSInTBq6tuwXwsN0qL
	Nyqu1rMlTpFkUII/N0UbNGgM/Ypo+cBYxz/a6BwYPUwpeWXwVbHssEvq/8xBy8R3XchKBm
	Jfp9vPm3mW13auuYj0Dl+3b2iHoGw0g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5028D1477;
	Thu,  9 Jul 2026 10:33:46 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD1893FD88;
	Thu,  9 Jul 2026 10:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783618430; bh=zIT/xLbbs8vi+r7fH9gOio4S5P+iCKE4zCWJYcJdnzo=;
	h=From:To:Cc:Subject:Date:From;
	b=Z/GvK7QYaxBo+o+yhClPhpwCdGfatuoBnPNjS6Ec9n1wBszvkQbNTSmqZG0iVqJsX
	 VinI/I2wIeUIgAp2gbqxjgDHCq1QxmAlxW60U9iiPiafZGHsRnvdmDkWbTMCL035HQ
	 NHIeroHdQBTZrVoR99j+zEF9rq8vxgZi3YT2Y+F0=
From: Catalin Marinas <catalin.marinas@arm.com>
To: leitao@debian.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: kmemleak: confirm suspected leaks with a second scan
Date: Thu,  9 Jul 2026 18:24:47 +0100
Message-ID: <20260709173347.689607-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CD95CC0012
X-Stat-Signature: rwt3n4sfdeerk9y7a4ut4xhk3ck86zu9
X-HE-Tag: 1783618431-904257
X-HE-Meta: U2FsdGVkX1+yoQ/xNfMfwslYzX3cBxDATFLVrLRk1R0sz7qRKhPQ3o0G4catB0zkObSC6zxWEOhRCVSSQBl6K8V8w7/oMcqY6wl7o2Q2ZSyUNpSpJmv7pbwatlNH3oCVDeI8eeeOLke2SdOYxIGJYgY3bgN1gwc/fchZBGkkrxv0yy1ilPSdC1KL3udXmj5sDYwjOaWbSis1DtbGur5dPa0EVUU5ZCGhp9mv9gI74RDlW+I0wVrUC/769ENnJgqkjGt6ezmYcSrHqPQCi6pTInuFzwoww/9dEI7xCDd0zg1oWyAq0K6YSnWq3GeMxf1InbX2bkERgutOFQEJ7yGOEMFPrdMdJ0RabsfCaD6YaOLYh56ro3MRWTssnPPdoD6C6fpqllPV4NDwbLHxiHei00O/FjHh/W30HWkv2pDCo4rhYISDG1FTeK4OfqjdjkB43teNN3w1ddMC7tOMUMDSV6mbRdkhtemvAlgC0sDzY/V+NVBPQGrD7oDuK7muVDd1XrwZY8oKIyQt4SN159DQh7U/VdPGmtnVRo0DtRm2/udv7f2qpemU6SIf7xcRnOPE/fJHeZQ07NP+tkTcezzh5izh/fwFCFhDytuHJBeOeC6bgtx9KvypJyvXJyl0iFQNihBCpKSxvKNa0SrgJ/zV4wfeIIyMCP/T02RRp1g/2bBb0psre8NBo4wOA3Q22dOqYuAAkEx3+cAu5ur3w+Ij/Y3fY77+VXtH8SKHEf2+wY7oGi+aHL0/P9ttPDwgOQySxTZI7TXrGn3L2q0Du7OQStlPGemPhWTJOtdThKYB2R5/Ny5ikPgiPb6GVh+qQrYxtMIxCyU25qz4ioJmu2jLgn6P2Wiq4X2Ju0BduE+wb3tKADdp5vO1Jv/ea0/3/DJ5Mh5XkwTRCmVw8cQxuHl2Y6Ix7+NfewZadAXf8S8jBi1u9UmT3UEuX+9fQU5e+lawj81sbA9UeBog42awCjb
 z7418t85
 3O3YTw6frVUrQVdRJqJ62+JoemPDF0rhP7GZV1rpql+bLTpfDFqe0hwD5Fh5gnbN4wvfOuOIQKDVHeVoGSoH2Zj/ijM/1cnN/Jka7LWNGnK+4YgQKh/o+5634//aaoPapBDMQrhUWR9eTmNsCvMXy0/xbs4zSA/ktoW7JOLQrfYdNCzDmf0fQLJSjpnx+fjVs8oYj+QhzD/W0VjBHSyBJQ8spnQUbPrupBFx8aEnIWb1wamDHS5SYQLpuagq7d2QAGR/kJCyNuSlW+Hr1SzKK66UaB9NOddgT73Si/VSgNsj4qxWWdXUZnk8ty7CIJ1KBEr8WmIGaI/qsU238iM6GVurlnDVoU5Z2P/cczCgC+i0ZkbFaai61mt9DgW8+liEhyloZL3JGlwuCN0KKdLbzrMmywpfAVaqKbVfw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kmemleak marking phase is not atomic. While the object graph is
traversed, the kernel can modify pointers, free objects or allocate new
ones. If a reference to an object is moved from one location to another,
kmemleak scanning may miss it. We have explicit annotations like
kmemleak_transient_leak() but identifying and maintaining them is not
trivial.

Given that such transient leaks are short-lived, rather than just
reporting such objects as leaks, do another scan to confirm the
suspected objects. If no new leaks are found during the first scan, skip
the confirmation one.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Assisted-by: Claude:claude-opus-4-8
Cc: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---

As discussed here:

https://lore.kernel.org/r/ako1sMPVu4dfQR4K@casper.infradead.org/

attempting some more heuristics to reduce the transient leaks. It
overlaps a bit with Breno's minimum scans patchset but this one limits
it to two scans only back to back and only if new leaks are found. I
would say it is complementary.

The difference from the link above is that we now use the same scan loop
to mark the suspected leaks instead of a separate, heavier one.

I told claude to refactor kmemleak_scan(), hence the assisted-by above.
Ideas mine ;).

BTW, I'll be away from Saturday for three weeks. I may reply
occasionally but won't be able to test anything.

Thanks.

 mm/kmemleak.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 3 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 7c7ba17ce7af..505b5c3a423b 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -175,6 +175,8 @@ struct kmemleak_object {
 #define OBJECT_PHYS		(1 << 4)
 /* flag set for per-CPU pointers */
 #define OBJECT_PERCPU		(1 << 5)
+/* flag set on an object left unreferenced by the full scan, pending confirmation */
+#define OBJECT_SUSPECT		(1 << 6)
 
 /* set when __remove_object() called */
 #define DELSTATE_REMOVED	(1 << 0)
@@ -235,6 +237,8 @@ static unsigned long jiffies_min_age;
 static unsigned long jiffies_last_scan;
 /* delay between automatic memory scannings */
 static unsigned long jiffies_scan_wait;
+/* number of objects flagged OBJECT_SUSPECT during the current scan */
+static int nr_suspects;
 /* enables or disables the task stacks scanning */
 static int kmemleak_stack_scan = 1;
 /* protects the memory scanning, parameters and debug/kmemleak file access */
@@ -1439,6 +1443,11 @@ static void update_refs(struct kmemleak_object *object)
 	 */
 	object->count++;
 	if (color_gray(object)) {
+		/* referenced after all, no longer a suspect */
+		if (object->flags & OBJECT_SUSPECT) {
+			object->flags &= ~OBJECT_SUSPECT;
+			nr_suspects--;
+		}
 		/* put_object() called when removing from gray_list */
 		WARN_ON(!get_object(object));
 		list_add_tail(&object->gray_list, &gray_list);
@@ -1797,15 +1806,15 @@ static void dedup_flush(struct xarray *dedup)
  * kernel's standard allocators. This function must be called with the
  * scan_mutex held.
  */
-static void kmemleak_scan(void)
+static int __kmemleak_scan(bool full)
 {
 	struct kmemleak_object *object;
 	struct zone *zone;
 	int __maybe_unused i;
-	struct xarray dedup;
-	int new_leaks = 0;
 
 	jiffies_last_scan = jiffies;
+	if (full)
+		nr_suspects = 0;
 
 	/* prepare the kmemleak_object's */
 	rcu_read_lock();
@@ -1835,6 +1844,8 @@ static void kmemleak_scan(void)
 
 		/* reset the reference count (whiten the object) */
 		object->count = 0;
+		if (full)
+			object->flags &= ~OBJECT_SUSPECT;
 		if (color_gray(object) && get_object(object))
 			list_add_tail(&object->gray_list, &gray_list);
 
@@ -1904,6 +1915,10 @@ static void kmemleak_scan(void)
 	 */
 	scan_gray_list();
 
+	/* a confirmation scan does not look for modified objects */
+	if (!full)
+		return nr_suspects;
+
 	/*
 	 * Check for new or unreferenced objects modified since the previous
 	 * scan and color them gray until the next scan.
@@ -1926,6 +1941,11 @@ static void kmemleak_scan(void)
 			/* color it gray temporarily */
 			object->count = object->min_count;
 			list_add_tail(&object->gray_list, &gray_list);
+		} else if (unreferenced_object(object) &&
+			   !(object->flags & OBJECT_REPORTED)) {
+			/* flag the objects left unreferenced by this scan */
+			object->flags |= OBJECT_SUSPECT;
+			nr_suspects++;
 		}
 		raw_spin_unlock_irq(&object->lock);
 	}
@@ -1936,12 +1956,42 @@ static void kmemleak_scan(void)
 	 */
 	scan_gray_list();
 
+	return nr_suspects;
+}
+
+/*
+ * Scan the memory and report the unreferenced objects as leaks. Must be
+ * called with the scan_mutex held.
+ */
+static void kmemleak_scan(void)
+{
+	struct kmemleak_object *object;
+	struct xarray dedup;
+	int new_leaks = 0;
+
+	/*
+	 * Full scan. Objects left unreferenced are flagged OBJECT_SUSPECT and
+	 * counted in the return value; nothing to confirm or report otherwise.
+	 */
+	if (!__kmemleak_scan(true))
+		return;
+
 	/*
 	 * If scanning was stopped do not report any new unreferenced objects.
 	 */
 	if (scan_should_stop())
 		return;
 
+	/*
+	 * A live object whose only reference is moved by, for example, a
+	 * concurrent RCU update can be missed for one scan and reported as a
+	 * transient false positive. Scan again and only report the objects
+	 * left unreferenced (still flagged OBJECT_SUSPECT) by both scans.
+	 */
+	__kmemleak_scan(false);
+	if (scan_should_stop())
+		return;
+
 	/*
 	 * Scanning result reporting. When verbose printing is enabled, dedupe
 	 * by stackdepot trace_handle so each unique backtrace is logged once
@@ -1969,6 +2019,7 @@ static void kmemleak_scan(void)
 		trace_handle = 0;
 		dedup_print = false;
 		if (unreferenced_object(object) &&
+		    (object->flags & OBJECT_SUSPECT) &&
 		    !(object->flags & OBJECT_REPORTED)) {
 			object->flags |= OBJECT_REPORTED;
 			if (kmemleak_verbose) {

