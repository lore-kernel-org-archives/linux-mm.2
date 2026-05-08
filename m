Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 106DFCD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 22:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FBF76B02A8; Fri,  8 May 2026 18:17:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AC826B02A9; Fri,  8 May 2026 18:17:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19B2C6B02AA; Fri,  8 May 2026 18:17:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 071B86B02A8
	for <linux-mm@kvack.org>; Fri,  8 May 2026 18:17:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 96EA31C0DE9
	for <linux-mm@kvack.org>; Fri,  8 May 2026 22:17:33 +0000 (UTC)
X-FDA: 84745665186.24.51D7B60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E259280008
	for <linux-mm@kvack.org>; Fri,  8 May 2026 22:17:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C69JblI1;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778278652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZ4W3eHSYcI+ZzcnA+02bpKxHcw1Gxpw1c+C2nU3nS4=;
	b=YPyRnlZoP4Jutb4E8NbJo4N7B6q/Eywn79K+9EwMkBKAJRXq6Wbl1kvOOwcG7iJNYcm8kj
	g2J23EtZ99eWaV80/t17qMhNAw7oEuMXIlMMtREpmmYtItcMDir/BLISuJnoLl1C3zPTKR
	2aT8lLk06zhjW9ttThB+VvVvmLBHzaQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C69JblI1;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778278652; a=rsa-sha256;
	cv=none;
	b=sKoVRBmFTDQ3d2gr2BrsF6XvajFBwh04BBOa1iXUMX2W2tGIied733ur6GfCz3okhcrXI/
	DY3Qev5HUeXjOz6uDvd/4QYeODEGu8Q1BWUrgKqMxVagKlLEut029OQEJw7DIFl8z2N7jj
	vsbpcxsyMJ7O3ZukJ68j4OdwgadFFJs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 295B360181;
	Fri,  8 May 2026 22:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3ACC2BCB0;
	Fri,  8 May 2026 22:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778278650;
	bh=ogzMc2HnWA6Fl9VQJKS6hplq8PjQCqBpKSJZksIJBvY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=C69JblI1AIi/KI8VBmMJ963aaFKRyR5DT/nyFs+XsLBwqtIeTo/OgBq4s89mkptk8
	 MzGaMhnvnBhKwu6DAznvLBUhVmVtgrU9vCzQgfa3zSsbo0+BEiow1wayyxVWrKGfwe
	 rb/zKQpQO6EVl6hn9Z6da0fJHOv4xdoVzOVf25AY=
Date: Fri, 8 May 2026 15:17:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah
 Khan <shuah@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 0/2] mm/kmemleak: dedupe verbose scan output
Message-Id: <20260508151729.682551a2b2739e8b5d15ade2@linux-foundation.org>
In-Reply-To: <20260506-kmemleak_dedup-v3-0-2d36aafc34da@debian.org>
References: <20260506-kmemleak_dedup-v3-0-2d36aafc34da@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E259280008
X-Rspamd-Server: rspam06
X-Stat-Signature: ua84yqj5767xuxmiyqqxcousizyicahz
X-HE-Tag: 1778278651-786936
X-HE-Meta: U2FsdGVkX1+VXYV/mbN/W1ULqf5S/h8qFKWFdsvEZ9e8oHJ8NlhiTYkK/fjVhNNBaUnQlPjEqKtjyqukwwblkC79wXfYoDHvlqoCJj8CuOi9bbi5RMhWS5F4k4+Fud7yJUkP/+GuK/6vjOToLMhS7flZXxgg0x+pZltY6FUtPyEFT393urVjhEe4jprv/A4m8qPQvCWSSAnRiMkuseIKMSTd4KFV/ZUEYHR0ZYHOLBDe6JqVXVZDpPNESUBlLQhNYQmUGR6HM+qp+dvsDLktmkBbCZUQU8eV5FnfmeFoE0iUlp8Tyz1Xytxqo5FCELFgXOSceqrKgMWl6A4Xrvz7T/C4T4CfXiArtYztV2tL4N0se+AvochHeYHMnNsCYiRV2VqypRO9CIjZhG2JpFjcV1ydx/whZpSI7Tc9Xt9Q1rsJ7pCPhdTO4NFbcgVLAmSHAPoqfmuUouiQk1kFXJI7NV7+3zZ5Uxl+bXBxwVMAFe2F23HXYY0q11yNrhi6ZbO6igD+NvTrG0mhwwUcDsfnfy0wZ+pkgoaffYFalGtwytV35Mo1dx0YP0N+Qyj33fvxuxsoL9E6PsRcDgmD1Sp6ghlIMg8SY9HwARzbjhHYG7X7nxtJUFbFsMNVqiMsio92ZnDNPJK8BZMx2dzPbwwDzIFeCSqw6AxoKTESKuTSzBU8cY87i43g+QgdP5MP86iEyzz0xI6ieeiqGLXW/BK4PgjYMhgRAXK2E2hkidAZnZMshF0QRo3ppWhYrfcAS2/cGa+Qm2sm5sAjRHk7RzP66/KxfX/aL8JhLSggb7/7f7ccOrLjOYEE7n6JKCfUx8/MHe5eO6gAPYupJosfidqMrCoaGgvrtNYdyFhwg0RF5TvIqH1Ko31n0hbIV12hOL5TiL1QkBJBgQZhUayVL4m+wikWQGEi6JycCiYv2GA+nyd559Kcj9z7CwtIZBZDPjx3Wpnz7MdnpKc9smonTLb
 I15KgEiz
 FKIHF9g1+2VLCdi/Tq2B2ne0sWxEP7kH5Et+xlgaiZNPlElzaM6C0NAS0fwPta8sRrBi614IChcz4Yd+u3l8vVyw7kYeofNmvO8nB5VRyEho62auAa4CcjKACEBgzRmChLUPilMQ7OSSi1m0IU0bPeR/09qtYwgJFXDKcy561AlP8BlgMZmMYmx1TmVFC2n9dhxqi1FaF0kyPy4qSdvvzgi8RNf/YwemygGTLTL4eyuMjJ2g/V0uR7in7xLp4cqvhy1zCPWPuw37PHXsddMAwXqA1MY3XV9qjkABD0m8rSo3GM5gNZoQ2ZGBxU21T/SQso8r4bxyuzsP1gU24CodurQ4W1cSG8A2fE6ONGVAEPIMYXL+0wmCHs6X/KCFp6MGEXfxKXYWfkcxHaWuAYSwuiOcICCT3t+qyrusOBGN5pm1MteWeKlwdHGEqAtIepU7b+eDrzFbe65FkZfQonlcjw3dWJkdR8DBiq/sL/yvq5X4REJPOs/sZ0KNgWiE/QY4vRfGJLB1MfvEDPArtDLbYcIo+/X2ZzeaLHXKGAR6zkW/WLq3rnAHAxTwZwdXFsAa1Q6IK//sHyMsqmEdxNc0jYp0U2UgXcetQCAhkVSErKO5/4RU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 06 May 2026 05:58:23 -0700 Breno Leitao <leitao@debian.org> wrote:

> In this version, I am not touching the kernel code, but, just fixing
> the selftest, as sashiko reported some issues, and I am addressing them
> in here.
> 
> https://sashiko.dev/#/patchset/20260424-kmemleak_dedup-v2-0-8bea649b2a92%40debian.org
> 
> NOTE: Additional testing has revealed that lockdep detects a potential lock
> inversion issue on kmemleak and legacy console.
> 
> The problem occurs because the function holds &object->lock (a raw spinlock)
> while invoking printk to report the leak. This printk requires the legacy
> console_owner lock, which remains in active use despite the ongoing transition
> to the nbcon framework.
> 
> Concurrently, console drivers such as hvc (hypervisor virtual console) acquire
> the console_owner lock and may subsequently free memory. This kfree() operation
> calls into kmemleak's __delete_object(), which in turn acquires object->lock.
> 
> Although these code paths hold locks from different object instances, lockdep
> operates on lock classes rather than individual instances. Since all
> kmemleak_object->lock instances belong to the same lock class, lockdep
> identifies this as a circular dependency, even though the actual deadlock
> scenario cannot occur in practice (?!).
> 
> This problem was not introduced by this patchset/selftest, but, it is exposing
> it. I plan to solve it once this patchset is done.

None of the above is usable for a [0/N] - it all pertains to the
ongoing development process and should formally be below the ^---$
separator.  Because it isn't relevant to the permanent kernel record.

The v2 series had a nice cover letter, so I stole that.  Please check
that the below remains the truth, the whole truth, etc.




From: Breno Leitao <leitao@debian.org>
Subject: mm/kmemleak: dedupe verbose scan output by allocation backtrace
Date: Wed, 06 May 2026 05:58:24 -0700

Patch series "mm/kmemleak: dedupe verbose scan output", v3.

I am starting to run with kmemleak in verbose enabled in some "probe
points" across the my employers fleet so that suspected leaks land in
dmesg without needing a separate read of /sys/kernel/debug/kmemleak.

The downside is that workloads which leak many objects from a single
allocation site flood the console with byte-for-byte identical backtraces.
Hundreds of duplicates per scan are common, drowning out distinct leaks
and unrelated kernel messages, while adding no signal beyond the first
occurrence.

This series collapses those duplicates inside kmemleak itself.  Each
unique stackdepot trace_handle prints once per scan, followed by a short
summary line when more than one object shares it:

  kmemleak: unreferenced object 0xff110001083beb00 (size 192):
  kmemleak:   comm "modprobe", pid 974, jiffies 4294754196
  kmemleak:   ...
  kmemleak:   backtrace (crc 6f361828):
  kmemleak:     __kmalloc_cache_noprof+0x1af/0x650
  kmemleak:     ...
  kmemleak:   ... and 71 more object(s) with the same backtrace

The "N new suspected memory leaks" tally and the contents of
/sys/kernel/debug/kmemleak are unchanged - the per-object detail is still
available on demand, only the verbose (dmesg) output is collapsed.

Patch 1 is the kmemleak change.

Patch 2 adds a selftest that loads samples/kmemleak's CONFIG_SAMPLE
kmemleak-test module to generate ten leaks sharing one call site and
checks that the printed count is strictly less than the reported leak
total.  Not sure if Patch 2 is useful or not, if not, it is easier to
discard.


This patch (of 2):

In kmemleak's verbose mode, every unreferenced object found during a scan
is logged with its full header, hex dump and 16-frame backtrace. 
Workloads that leak many objects from a single allocation site flood dmesg
with byte-for-byte identical backtraces, drowning out distinct leaks and
other kernel messages.

Dedupe within each scan using stackdepot's trace_handle as the key: for
every leaked object with a recorded stack trace, look up the
representative kmemleak_object in a per-scan xarray keyed by trace_handle.
The first sighting stores the object pointer (with a get_object()
reference) and sets object->dup_count to 1; later sightings just bump
dup_count on the representative.  After the scan, walk the xarray once and
emit each unique backtrace, followed by a single summary line when more
than one object shares it.

Leaks whose trace_handle is 0 (early-boot allocations tracked before
kmemleak_init() set up object_cache, or stack_depot_save() failures under
memory pressure) cannot be deduped, so they are still printed inline via
the same locked OBJECT_ALLOCATED-checked helper.  The contents of
/sys/kernel/debug/kmemleak are unchanged - only the verbose console output
is collapsed.

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

Link: https://lore.kernel.org/20260506-kmemleak_dedup-v3-0-2d36aafc34da@debian.org
Link: https://lore.kernel.org/20260506-kmemleak_dedup-v3-1-2d36aafc34da@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |  148 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 140 insertions(+), 8 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-dedupe-verbose-scan-output-by-allocation-backtrace
+++ a/mm/kmemleak.c
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
 
@@ -360,8 +363,9 @@ static const char *__object_type_str(str
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
@@ -373,7 +377,8 @@ static void print_unreferenced(struct se
 			   object->pointer, object->size);
 	warn_or_seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu\n",
 			   object->comm, object->pid, object->jiffies);
-	hex_dump_object(seq, object);
+	if (hex_dump)
+		hex_dump_object(seq, object);
 	warn_or_seq_printf(seq, "  backtrace (crc %x):\n", object->checksum);
 
 	for (i = 0; i < nr_entries; i++) {
@@ -382,6 +387,12 @@ static void print_unreferenced(struct se
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
@@ -1685,6 +1696,103 @@ unlock_put:
 }
 
 /*
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
+/*
  * Scan data sections and all the referenced memory blocks allocated via the
  * kernel's standard allocators. This function must be called with the
  * scan_mutex held.
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
_


