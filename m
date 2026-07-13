Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB961C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D335D6B0005; Mon, 13 Jul 2026 07:48:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE19B6B008C; Mon, 13 Jul 2026 07:48:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3CE6B0092; Mon, 13 Jul 2026 07:48:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 919B86B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:48:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 313BA1C68E5
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:48:40 +0000 (UTC)
X-FDA: 84983581200.15.5E9872C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf08.hostedemail.com (Postfix) with ESMTP id 44C7C160003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:48:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ZoSryOM6;
	spf=pass (imf08.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783943318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LzjJcbcBOXrfLADuXXmAbo73ajPyy8OrPW+mEAjdK4=;
	b=ltJGVEaxU2AVz1obRICtq80eQeX3EK87VcpbqyzimraR9joa+wwnZzaGlcp2E98foW8IkO
	F/I2xAtCwr5KNF2QYYyEI/pfmdLm/TSeklKvN7/nRtJfry0FCCrFydBzqhW7dqDZw7MR4Q
	zeLt5pd6LP99gTdVDVfM5v5rZ2M8fJg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783943318;
	b=QA4Jzq9d/3D6oGfpka2SVs3i3d1HwKKt+mdEfFU1K3IXWKKokbeSwEAII+kycDk2ARxtX/
	LMMlnShPXNn9tQ1aTf+EJczTq7k8pFNi7qF6y0/6Yp1bcedZVmAP5ueY+zarsZKLTaDOsd
	62JB2w/Z+RK0aZSxf66tzR+7scirlDQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ZoSryOM6;
	spf=pass (imf08.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=8LzjJcbcBOXrfLADuXXmAbo73ajPyy8OrPW+mEAjdK4=; b=ZoSryOM6Ov3DSqe5rhcu0hpRgy
	9nPDwffqAXSVVcZLie7XqTNa6I08xHjd8ztoSRCJrb5XVCa6NSJD3l0inU9tx5r+TF9ZIC/2d+flT
	tDUgXuwb2hOGsN81/uUdThVyxEa9RQhCGFcCWrrPrw0iXdj9zM377Yp9t2RR+NYdV5IhGo2GYqgh6
	h0bKjCg4FPrhCZ8ps92Yi8JLzIqg/l/v1ww1bKLaf7eETNsYxPVWzFJ+v8DU/XE3ponBxbujUfvgJ
	0jzNJp7sIPRbkvnwvcBUQEpoQ9QN6mdcRqAaVm+wBc9eTS2KtkC5w9c0Qi1yG255Z3FS/KG+g5QJI
	o2qPzl+A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wjF9C-001Tie-0A;
	Mon, 13 Jul 2026 11:48:30 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 13 Jul 2026 04:48:04 -0700
Subject: [PATCH 1/4] mm: kmemleak: confirm suspected leaks with a second
 scan
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-catalin_pto-v1-1-5b93b1131089@debian.org>
References: <20260713-catalin_pto-v1-0-5b93b1131089@debian.org>
In-Reply-To: <20260713-catalin_pto-v1-0-5b93b1131089@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=5439; i=leitao@debian.org;
 h=from:subject:message-id; bh=2Ik36nD5Ymen0igsLFiFN5pbHvbZF0V0k4IOFO34tCM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqVNCDe9n1M9YNOiQ/yUFY2MBL+A8LR6gq6LZuK
 UWDOMGVhmmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCalTQgwAKCRA1o5Of/Hh3
 bRU8EAChIkFYicCYva6mq7aO2tlOJyY4KTdiQFZL5K3tXxDOFUh9nxGrlQOzkVvtyYfOsPiIrsD
 nfWCwHcQVbyWANPt4qyA0G3rTI+M9f7pfk4Q6PPmgM+gVKTFUNfVyma47kdgItlSycJNfqZLYiI
 Ex5W/qBFwdefN8ey2pxvRc02VreAv4XpDv9T77OqaCC75SzG81fI/qrpMRUcjoAZLZCJZdRb/O1
 vmWed4KgnZMcVKFOkQg8HYCAwxiwB59b110PPiZUFV6V0XIJYrWMeg6aKxm2BHUou7y/fP1E+3j
 L8Q2WPjllunX66rVivlHMCS7gdBlZnpj5JEcUAUN9aNSj8McwdI5cI5vsung2EUM4PomAb2wDnB
 GED78mm8KOr+I6iPAbMA2bXSaEXjjZL2QIDx98zbc2tNOMuKHmv4BmQ3+vJG46dWGhYApAgr/OQ
 ickcPUwvRdGBOMwrvPXi3M/35QeHkVaOl3RzJr0nvda9v9Q7JDiUqLI2gPfiKrawcSIfJi5/fps
 DKia5+UqAAQue+DIcHdFHmFAGlYzvRtXPfdRwc+CI0zG2llHgKUyvyDO4Ew9r2dHVv9Hx5xEuVm
 8bC8c2HmbD1CGMnNV5yOdPwqmtCrTn12E8WG73WdrcnPEObU7xEPknF5YNfviaV2DyvmEtR+YJP
 9XJsusLKdLazP+Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 44C7C160003
X-Stat-Signature: aff4qtg6g66igaa1rp464ju3s1p87nji
X-HE-Tag: 1783943318-252362
X-HE-Meta: U2FsdGVkX1/55cjdVLTmE66wuWgP8v99SFH3Hvcu1eevRfEBhsB/aoKZ/dMrkftOREdqO5OwijKWztpuN2kIWynYl6TVfrWHlSYGFUH6LXWBeLjnUZ1XQ2qmxEULbiRMIT5iVJhXQLz8jn+G7LhuufSGXwIgpFvdOjxS5IT4tJ2GLzC55Q6Z7oLrN+tAFwNIdyqYmYEMjZDrdmaiF3UYwKo/5Ovgbmwk4XYeGJ1UQZ5qFBh6eOGNRhlOQBfzpswgyRhnHtsu1jWhouqhgv1QWmJL4eGbQW4RFojxo1rb9XMvkX7v+HlDiuCtmO+TU1OX8e3UOqRKTiVj/qIids/ILZ6Fh7osezUD9N1btpH+hxMlXKGNHNLQZIlbuKdTYy7iOAOQjk+/XrVtTcuC0s1PnubIOqn77vsaU3cW9SWOJr+l895kFOfq8tfp/0jN6LIJZLpM/086p+/bRpGM6gkfn+Coo32Tp4u5wg65FPmHPx7m74zMp35TWWK/9wWCbzfK+WN7ns0x+076xlMCfelNd+ZnX0P7kDit/iQyPEtBxL0zY3ZWnqFhDVBqv1llaL8ALNULm9S6MRL0rP4PddRsB+SHUQXXSwLHkIbKBta0fEZ1M5lgJDeKW5ew7dsHR6304WtT8c/k7FqsOuEouhAH2flSUR9mCoBOx2IoK0nVZC9X89Wu/RIK1Y2hvbxmcczeOD8lIgzU1h6drLuKCc2XEXyfr5s/VdmvL1HhYIP/9qm7gggwApxolLrRlE5PPZ5hFfC5dqJmmKmDLmFlmKwqc5K9HaTLZ/SNzAioaby85S6sI7xoaoiFIywJQ3MgZuY2FPDPCTWF8khAJQYTHlL9axiLspqqO3xSvFbWKYpAWK08mJdNzljWO4mthgfqg0qseT02o/Btrb6rADvjAcExn+6chquRhzDiWOM+y1AwqJjbwEezrhyH+M6GGDSmqa2M0bDB048+fkvHj2zUFcR
 rdc0FTYb
 AI2gGD0Ajxgb0a54TlQpEJluYxvxce9F1IWcIka8nnR0kNqm3uGGHN59FWBeucCyYtCPNzngF01uX8g7hREsw4CdxMl3FcLQXuRLbr8+RweHEJjzUwH4mDJhKepp9oKrSiaRKaoaW56viIhOh8MWTJI1G9NGlUOFaNWSarapqHsXe3eJCWr36Aos3eHgs/RD4etZcJ+qxZYaXVFF+e6AsDiWKHPEAb8qcizRmZ3NphpHTFYUEgMH4yjRDcFQrk1oVI/nMLyEjAvupLl4hCXYgLnUble0AoDQEE++AsUF2GL4eI76mosWCxnbiiLnN6O5mWxIJ1KjQ4/JkvKbUK/UnkQw99xcL2Wpzbe1R3DrFYeLoC4EQ6mpqt/vnmSeyXoUWKjb26IIqwEEH19KLoQMP2dynKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Catalin Marinas <catalin.marinas@arm.com>

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
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/kmemleak.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 3 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index e96e9efd19b0d..ac77bab580688 100644
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
@@ -1440,6 +1444,11 @@ static void update_refs(struct kmemleak_object *object)
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
@@ -1844,16 +1853,16 @@ static void dedup_flush(struct xarray *dedup)
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
 	int stop = 0;
 
 	jiffies_last_scan = jiffies;
+	if (full)
+		nr_suspects = 0;
 
 	/* prepare the kmemleak_object's */
 	rcu_read_lock();
@@ -1883,6 +1892,8 @@ static void kmemleak_scan(void)
 
 		/* reset the reference count (whiten the object) */
 		object->count = 0;
+		if (full)
+			object->flags &= ~OBJECT_SUSPECT;
 		if (color_gray(object) && get_object(object))
 			list_add_tail(&object->gray_list, &gray_list);
 
@@ -1950,6 +1961,10 @@ static void kmemleak_scan(void)
 scan_gray:
 	scan_gray_list();
 
+	/* a confirmation scan does not look for modified objects */
+	if (!full)
+		return nr_suspects;
+
 	/*
 	 * Check for new or unreferenced objects modified since the previous
 	 * scan and color them gray until the next scan.
@@ -1972,6 +1987,11 @@ static void kmemleak_scan(void)
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
@@ -1982,12 +2002,42 @@ static void kmemleak_scan(void)
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
@@ -2015,6 +2065,7 @@ static void kmemleak_scan(void)
 		trace_handle = 0;
 		dedup_print = false;
 		if (unreferenced_object(object) &&
+		    (object->flags & OBJECT_SUSPECT) &&
 		    !(object->flags & OBJECT_REPORTED)) {
 			object->flags |= OBJECT_REPORTED;
 			if (kmemleak_verbose) {

-- 
2.53.0-Meta


