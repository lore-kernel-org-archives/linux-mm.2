Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C7BEFED3D9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 442226B00A0; Fri, 24 Apr 2026 11:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F3776B00A8; Fri, 24 Apr 2026 11:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B8326B00A0; Fri, 24 Apr 2026 11:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F40C46B00A0
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:06:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B72F2C0632
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:06:17 +0000 (UTC)
X-FDA: 84693775194.15.0F24752
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf02.hostedemail.com (Postfix) with ESMTP id B937B80009
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:06:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="lRXYF/m0";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=none (imf02.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777043176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZGEE99cwULXbVYrMEkHn/4LIcan0Fk2kMQBVTvLPAo=;
	b=Wy7NvCnQEowwdXOwjsSROgEzvVldM5Giufh8loXmflRvEYwtMsWx0AHpSQprpG1VsoxwMz
	N4ESitYUvPUdWXdk/EFAsvt5vK0VSf4lfw7aJbKD8Qe/6veWDpq+5aCe33fcZzNjFwWaU4
	WbfFJ6dbEAdM/tv8XTKpPsDhv0y8xOk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="lRXYF/m0";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=none (imf02.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777043176; a=rsa-sha256;
	cv=none;
	b=4sQFAYJUncAfUDXEBTdena3tc5+BvKNbIGUHfvn4oPzyD+rbnAl/ahy3gkCWa70+pk8UAV
	CA05ezhyfaL997hxmaZsLosBmx4fwPWcPIJW1w/kPocxtVDTxUYeVin5KOedvX0n4SUfuV
	yvo2IKK5CHjnWEXHBo/8buMrdq2643o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=mZGEE99cwULXbVYrMEkHn/4LIcan0Fk2kMQBVTvLPAo=; b=lRXYF/m0o9eqzuHhMqAFj1LMrp
	3DiuZJvJCZkPCdeNMZi3pIJ3mK6xtu2lOHuzK4MpHxv9dY2ukVO2yP1FLKfEGD8Lj40xPsbPf8qeF
	II5Q7HkiHkS679xCR22gjjWiSRS0MDAPpP6PIm/u9yt7n6osHjLI65PeOhvfXEGh/a1c6LNehWrte
	zD1fsInUn8d1GEZlGpgS1v+FLdGe0XCP3o8eY6A1CEfsp+ChrEvNwYaJ+t/GrFbxTblyBz/F7nFT4
	5ZDFpk86/GknlXTwUPjS3OmUa/0tvLU5rsMgQuYfiOxQuOWVYtUF6k32EGjEG5zIPiykR34dD1/Na
	9XJrreGg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wGI6a-003FtH-0t;
	Fri, 24 Apr 2026 15:06:08 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 24 Apr 2026 08:03:36 -0700
Subject: [PATCH v2 1/2] mm/kmemleak: dedupe verbose scan output by
 allocation backtrace
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-kmemleak_dedup-v2-1-8bea649b2a92@debian.org>
References: <20260424-kmemleak_dedup-v2-0-8bea649b2a92@debian.org>
In-Reply-To: <20260424-kmemleak_dedup-v2-0-8bea649b2a92@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=10687; i=leitao@debian.org;
 h=from:subject:message-id; bh=akHXePfPebMzUdTcryE7KkaXUo55nftRQsGBt9wfwYI=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp64bVTXI0Q51jMB/WSB+QfdXgIS0mvpZ+YHPR9
 qN39q/RI3qJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaeuG1QAKCRA1o5Of/Hh3
 bTZcD/9+/8vy5o/zhC1gZzQCAsM7zewGRNcYIKl8JeyMhvi8uaBDVMWqypEct4wENsm+L4WIunS
 iFAYz7+NaFrNIc9JLzQm6vA2EK0rfxybKqHh7hQ3V/h5B22vOSa92DKf+LuoGmrT8KFyDXk10lP
 w0nvzBzJlZECrbn7p8Hq46gh/779WYf0qgRh0GgG5eVb4Ql62+Tp5EQYgFa9TffAlx4FWXMqAf+
 vB31D+bL9zkiKp3w9GahKngBGbPRJ110w31stSeHDtUzzmnuXfsMTuL51DwqDI6xK3N/lzD5DA3
 ok8Bv/nvviHtlq/YhRL3ba+PBDqea1u95BFeHt0QZoPk/SrFsCtnJf8qStAzx4i7+X/+4rAph4B
 KZ+G47hB9ulMd02yX7Gk+Ac7taPWWJV4dw6r9KTHOk5XP+ai/KSWPcULl/9sVs7ZN2j1cL/OgOZ
 at/6YQ2V0rNpO9CCc9nAzON0J38psfhhRZUTvXlPYVr+CObmAUYJdKlmkONMbTkzhdOxtWS//W2
 cfYLmvGuiJbUcXpOq9643YRxu95qe33N77xt9Nsqke8wlTQf6LuK8Dxt7/6quob2Mxhq6F1AsFl
 qIQLi1j3FAb4JH4LBlYYZqTab3yT0lhXlu9miwE2w/HLbdwCG4xHwAY3n2UW+ipYoRBZJLit8kw
 UXAbb89jr4CHtAg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B937B80009
X-Stat-Signature: secdbgwiedj681yf7hmbat5y7me5crfr
X-HE-Tag: 1777043175-931637
X-HE-Meta: U2FsdGVkX1/w6n8pr8EH6iujU/ZGJKQUjuATFDzHOZY0otykbAXgzMJ5rENrmTru02tooJUa1HtUC8pPiASzWbFEaXN5C6jBzqor6IwmE+uFwi6yXHjhkPBoo1R+jESYHnpjrezMjsjdDy0A7oOV5U7JR/Kpl0k/hUzbr4wdqJyC7CNaBphe6G1j2Ve2xoQ2EKxHb0kAMqyE2rMeIiaPrjp/HpUyuX7sTw/R44wPwbUS26O2vpJEsCb/v2r8PWF4uumWOHGpCVBNcqeAOzDkRgkLC9gdN6eq2CXTEX5SgJFwekKC487Wuwf0LgifbmgOMJ+QZAPdPgBvGcFt8c6tsTjLpIF3M9/E0LmBjQcf/1wRhFV3MLXPeIHQ7zSfKfPtNHDfEK8Ri65U+PCCYIGKv3l0cBaWd68DGWJ8qpdJygaNWP3a2tUhxaNQBvzz/fcxMKTobyMOjUi5zZu5zrRPTSpM7EHiFK6KnsIJyEEadhYHKbyTzcQrmgQgfjQDl/TF8NdVA24CkAkXFoZqx8sk/8mnXVyLnUpyAvWaQuS/xcKaYBMI7xWYmmB6Mcn5UqEkS/U4IZODF0rZZ4/9xZfRobZWbpkGqx6Ch+yZRYLuAnPqHRW3VncRAbugkyLTE/+rj7XShmw/EDTahyF5AIrUASZsUXbf8/ZdxSZ2k5AsB9WzDi2yOVcxT/sGCWLVE3uDe4qSZbPqmkEcgJ7f0VLBQWcHCr+bo13nQ5qMZ3PdYT/SuOrLQXlN2BxYPerBYbOcuHR7IoXVsNMS6p6YjHubzp4YuTTbm9vY2OwhwZYPGypYXSambjWo58lnGe6p4VT3ywlraKaJhy1qVS44EEJnlu5nxnjdOmPYLmI1MHO7+tuGkSs148411W+u2a8bUagmEuwqtS3n5M+DPn3XTLMI9AE6Tdq50WDPnVD1PZ1LgbIKMnDknWwzQAnIC3R/fe/29cSrW5Jlja85iD4cFGK
 LV2ST06V
 5vb5iet9FTnXEWhSnDcwfPtCACyBdloTwECnMIlMWSfrtj8kw4vxKF1K9pUC5eDlua6KJ6xu0AVgzqooslyHOIlwjU8N1HxJ/bC/hu9WdNe1JQmua7hZxQr/wZzxZUcxuYJky/utVCQo52l3+cgUpMXP93TEChANYLpL1yepsrv4xmSy2Ch9X05hCyhABqHGt5/0+Zy6JFmYclzSbHIhSb2HZI4Bby2kNHX6w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In kmemleak's verbose mode, every unreferenced object found during a
scan is logged with its full header, hex dump and 16-frame backtrace.
Workloads that leak many objects from a single allocation site flood
dmesg with byte-for-byte identical backtraces, drowning out distinct
leaks and other kernel messages.

Dedupe within each scan using stackdepot's trace_handle as the key: for
every leaked object with a recorded stack trace, look up the
representative kmemleak_object in a per-scan xarray keyed by
trace_handle. The first sighting stores the object pointer (with a
get_object() reference) and sets object->dup_count to 1; later
sightings just bump dup_count on the representative. After the scan,
walk the xarray once and emit each unique backtrace, followed by a
single summary line when more than one object shares it.

Leaks whose trace_handle is 0 (early-boot allocations tracked before
kmemleak_init() set up object_cache, or stack_depot_save() failures
under memory pressure) cannot be deduped, so they are still printed
inline via the same locked OBJECT_ALLOCATED-checked helper. The
contents of /sys/kernel/debug/kmemleak are unchanged - only the
verbose console output is collapsed.

Safety notes:

 - The xarray store happens outside object->lock: object->lock is a
   raw spinlock, while xa_store() may grab xa_node slab locks at a
   higher wait-context level which lockdep flags as invalid.
   trace_handle is captured under object->lock (which serialises with
   kmemleak_update_trace()'s writer), so it is safe to use after
   dropping the lock.

 - get_object() pins the kmemleak_object metadata across
   rcu_read_unlock(), but the underlying tracked allocation can still
   be freed concurrently. The deferred print path therefore re-acquires
   object->lock and re-checks OBJECT_ALLOCATED via print_leak_locked()
   before touching object->pointer; __delete_object() clears that flag
   under the same lock before the user memory goes away. The same
   helper is used by the trace_handle == 0 and xa_store() failure
   fallbacks, so every printer in the new path has identical safety
   guarantees.

 - If get_object() fails after we set OBJECT_REPORTED, the object is
   already being torn down (use_count hit zero); the leak count is
   still accurate but the verbose line is dropped, which is correct
   - the memory was freed concurrently and is no longer a leak.

 - If xa_store() fails to allocate an xa_node under memory pressure,
   we fall back to printing inline via print_leak_locked() instead of
   silently dropping the leak.

 - The hex dump is skipped for coalesced entries (dup_count > 1):
   bytes would differ across objects sharing a backtrace anyway, and
   skipping it removes the only remaining read of object->pointer's
   contents in the deferred path. The representative's reported size
   may also differ from the coalesced objects' sizes; the printed
   trace_handle reflects the representative's current value rather
   than the value used as the dedup key, which is normally - but not
   strictly - identical.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/kmemleak.c | 148 ++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 140 insertions(+), 8 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 2eff0d6b622b6..7c7ba17ce7af0 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -92,6 +92,7 @@
 #include <linux/nodemask.h>
 #include <linux/mm.h>
 #include <linux/workqueue.h>
+#include <linux/xarray.h>
 #include <linux/crc32.h>
 
 #include <asm/sections.h>
@@ -157,6 +158,8 @@ struct kmemleak_object {
 	struct hlist_head area_list;
 	unsigned long jiffies;		/* creation timestamp */
 	pid_t pid;			/* pid of the current task */
+	/* per-scan dedup count, valid only while in scan-local dedup xarray */
+	unsigned int dup_count;
 	char comm[TASK_COMM_LEN];	/* executable name */
 };
 
@@ -360,8 +363,9 @@ static const char *__object_type_str(struct kmemleak_object *object)
  * Printing of the unreferenced objects information to the seq file. The
  * print_unreferenced function must be called with the object->lock held.
  */
-static void print_unreferenced(struct seq_file *seq,
-			       struct kmemleak_object *object)
+static void __print_unreferenced(struct seq_file *seq,
+				 struct kmemleak_object *object,
+				 bool hex_dump)
 {
 	int i;
 	unsigned long *entries;
@@ -373,7 +377,8 @@ static void print_unreferenced(struct seq_file *seq,
 			   object->pointer, object->size);
 	warn_or_seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu\n",
 			   object->comm, object->pid, object->jiffies);
-	hex_dump_object(seq, object);
+	if (hex_dump)
+		hex_dump_object(seq, object);
 	warn_or_seq_printf(seq, "  backtrace (crc %x):\n", object->checksum);
 
 	for (i = 0; i < nr_entries; i++) {
@@ -382,6 +387,12 @@ static void print_unreferenced(struct seq_file *seq,
 	}
 }
 
+static void print_unreferenced(struct seq_file *seq,
+			       struct kmemleak_object *object)
+{
+	__print_unreferenced(seq, object, true);
+}
+
 /*
  * Print the kmemleak_object information. This function is used mainly for
  * debugging special cases when kmemleak operations. It must be called with
@@ -1684,6 +1695,103 @@ static void kmemleak_cond_resched(struct kmemleak_object *object)
 	put_object(object);
 }
 
+/*
+ * Print one leak inline. The hex dump is gated on OBJECT_ALLOCATED so it
+ * does not touch user memory that was freed concurrently; the rest of the
+ * report (backtrace, comm, pid) is always emitted since the kmemleak_object
+ * metadata is pinned by the caller.
+ */
+static void print_leak_locked(struct kmemleak_object *object, bool hex_dump)
+{
+	raw_spin_lock_irq(&object->lock);
+	__print_unreferenced(NULL, object,
+			     hex_dump && (object->flags & OBJECT_ALLOCATED));
+	raw_spin_unlock_irq(&object->lock);
+}
+
+/*
+ * Per-scan dedup table for verbose leak printing. The xarray is keyed by
+ * stackdepot trace_handle and stores a pointer to the representative
+ * kmemleak_object. The per-scan repeat count lives in object->dup_count.
+ *
+ * dedup_record() must run outside object->lock: xa_store() may take
+ * mutexes (xa_node slab allocation) which lockdep would flag against the
+ * raw spinlock object->lock.
+ */
+static void dedup_record(struct xarray *dedup, struct kmemleak_object *object,
+			 depot_stack_handle_t trace_handle)
+{
+	struct kmemleak_object *rep;
+	void *old;
+
+	/*
+	 * No stack trace to dedup against: early-boot allocation tracked
+	 * before kmemleak_init() set up object_cache, or stack_depot_save()
+	 * failure under memory pressure.
+	 */
+	if (!trace_handle) {
+		print_leak_locked(object, true);
+		return;
+	}
+
+	/* stack is available, now we can de-dup */
+	rep = xa_load(dedup, trace_handle);
+	if (rep) {
+		rep->dup_count++;
+		return;
+	}
+
+	/*
+	 * Object is being torn down (use_count already hit zero); the
+	 * tracked memory at object->pointer is unsafe to read, so skip.
+	 */
+	if (!get_object(object))
+		return;
+
+	object->dup_count = 1;
+	old = xa_store(dedup, trace_handle, object, GFP_ATOMIC);
+	if (xa_is_err(old)) {
+		/* xa_node allocation failed; fall back to inline print. */
+		print_leak_locked(object, true);
+		put_object(object);
+		return;
+	}
+	/*
+	 * scan_mutex serialises all writers to the dedup xarray, so xa_store()
+	 * after a NULL xa_load() must always overwrite an empty slot.
+	 */
+	WARN_ON_ONCE(old);
+}
+
+/*
+ * Drain the dedup table. Re-acquires object->lock and re-checks
+ * OBJECT_ALLOCATED before printing: while get_object() pins the
+ * kmemleak_object metadata, the underlying tracked allocation may have
+ * been freed since the scan walked it (kmemleak_free clears
+ * OBJECT_ALLOCATED under object->lock before the user memory goes away).
+ * The hex dump is skipped for coalesced entries since the bytes would
+ * differ across objects anyway.
+ */
+static void dedup_flush(struct xarray *dedup)
+{
+	struct kmemleak_object *object;
+	unsigned long idx;
+	unsigned int dup;
+	bool coalesced;
+
+	xa_for_each(dedup, idx, object) {
+		dup = object->dup_count;
+		coalesced = dup > 1;
+
+		print_leak_locked(object, !coalesced);
+		if (coalesced)
+			pr_warn("  ... and %u more object(s) with the same backtrace\n",
+				dup - 1);
+		put_object(object);
+		xa_erase(dedup, idx);
+	}
+}
+
 /*
  * Scan data sections and all the referenced memory blocks allocated via the
  * kernel's standard allocators. This function must be called with the
@@ -1694,6 +1802,7 @@ static void kmemleak_scan(void)
 	struct kmemleak_object *object;
 	struct zone *zone;
 	int __maybe_unused i;
+	struct xarray dedup;
 	int new_leaks = 0;
 
 	jiffies_last_scan = jiffies;
@@ -1834,10 +1943,18 @@ static void kmemleak_scan(void)
 		return;
 
 	/*
-	 * Scanning result reporting.
+	 * Scanning result reporting. When verbose printing is enabled, dedupe
+	 * by stackdepot trace_handle so each unique backtrace is logged once
+	 * per scan, annotated with the number of objects that share it. The
+	 * per-leak count below still reflects every object, and
+	 * /sys/kernel/debug/kmemleak still lists them individually.
 	 */
+	xa_init(&dedup);
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {
+		depot_stack_handle_t trace_handle;
+		bool dedup_print;
+
 		if (need_resched())
 			kmemleak_cond_resched(object);
 
@@ -1849,18 +1966,33 @@ static void kmemleak_scan(void)
 		if (!color_white(object))
 			continue;
 		raw_spin_lock_irq(&object->lock);
+		trace_handle = 0;
+		dedup_print = false;
 		if (unreferenced_object(object) &&
 		    !(object->flags & OBJECT_REPORTED)) {
 			object->flags |= OBJECT_REPORTED;
-
-			if (kmemleak_verbose)
-				print_unreferenced(NULL, object);
-
+			if (kmemleak_verbose) {
+				trace_handle = object->trace_handle;
+				dedup_print = true;
+			}
 			new_leaks++;
 		}
 		raw_spin_unlock_irq(&object->lock);
+
+		/*
+		 * Defer the verbose print outside object->lock: xa_store()
+		 * may take xa_node slab locks at a higher wait-context level
+		 * which lockdep would flag against the raw_spinlock_t
+		 * object->lock. rcu_read_lock() keeps the kmemleak_object
+		 * alive across the call.
+		 */
+		if (dedup_print)
+			dedup_record(&dedup, object, trace_handle);
 	}
 	rcu_read_unlock();
+	/* Flush'em all */
+	dedup_flush(&dedup);
+	xa_destroy(&dedup);
 
 	if (new_leaks) {
 		kmemleak_found_leaks = true;

-- 
2.52.0


