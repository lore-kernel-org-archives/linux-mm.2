Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 734B0FE51F3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 09:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D93C26B008A; Fri, 24 Apr 2026 05:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D448F6B008C; Fri, 24 Apr 2026 05:27:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32FA6B0092; Fri, 24 Apr 2026 05:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA5836B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:27:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B0F64072A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:27:13 +0000 (UTC)
X-FDA: 84692920746.29.1E12ECE
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id 670FA140012
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:27:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=YxwE6YlM;
	spf=none (imf23.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777022831; a=rsa-sha256;
	cv=none;
	b=Y4RHcx+H/Tz1XlXhTGZj9ehshpiaLDatcTjFBd6yDrCJmxNEWyASd/2gW1Tmhdnz/0mh80
	o7TdWNCfmr4YEePq7XqK+0kiOqk8gPFsFEdK6p+HneiIX/vKxN1Zq4zUZ+GDsdaFfwuEsO
	AqGlbWD6YCf96Mx2TkeEmGp1LuGT2o0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=YxwE6YlM;
	spf=none (imf23.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777022831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1JKHRu+5MuPmYUl/EfV4ZrR+5gJxryIP6aQ4C+kLlY=;
	b=1VJ8Nqd4CBaZV1mHcwuLO6/X6qnVljTl7laz4ASxB0ral1XRzBYp6wCG311NwQut5Vve74
	x7DTXgF3u/COW29ze7uqvlQ95HCEDZrjz2jpBqVFHXK9ddGyxJLD4/cxrPyoxBz3CaFjAk
	maKJUCWWBmVKljZ8EHJYl4QkHT18/v4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=u1JKHRu+5MuPmYUl/EfV4ZrR+5gJxryIP6aQ4C+kLlY=; b=YxwE6YlMfaSTq4plkRHmQ7Z2bm
	9uUAtnia4XkpA3KuvGK8/ZS/OEkcerl7nGzZpLobHmz4AsrlcbHYXrDCV8J5i2IFGdZxp9K2Tx+cI
	s+kS9hpGcK53+SAtS06eeuXZf5p60ZaC5YjtkI0Ov9VVHBZmS3gd84xYKw2Ijs8qno3F4/ktURkIy
	V0StVvrPDFZcjIrsDqnGce4vNzII8uAixdOTGlvE0Bnv3Gf5LV2h37+YJYZD9/cS4Bma2B1uYBQnU
	HLcE4lkn7oc2skUi8CjnmhxIIba/MfW7LHK37oLl3XAznPDDZl8GJv3i9uvw/I5NajzZNw7L67cqp
	MYPXzDEg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wGCoM-0034Qu-2t;
	Fri, 24 Apr 2026 09:26:59 +0000
Date: Fri, 24 Apr 2026 02:26:53 -0700
From: Breno Leitao <leitao@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm/kmemleak: dedupe verbose scan output by
 allocation backtrace
Message-ID: <aesymSWyh8NRIrDQ@gmail.com>
References: <20260421-kmemleak_dedup-v1-0-65e31c6cdf0c@debian.org>
 <20260421-kmemleak_dedup-v1-1-65e31c6cdf0c@debian.org>
 <aeostKcaHzmVBFjb@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aeostKcaHzmVBFjb@arm.com>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 670FA140012
X-Stat-Signature: 4xfetjtm1ft8m1ns9xxn7pqtqxu9ba1y
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1777022831-274494
X-HE-Meta: U2FsdGVkX1+5QajFm0jt/2+SrVHm2jlrsB4AVL5WrznxM0SU15vWqY7yHfbD0R37dR93Ht0itF0RR4GeQu6spzrn1OawzkUN5vZWpxOshpxQeB2b15xbCZ6kO8r8wPj6iwVjFyaZ3rctlxYnwy8QZ+Y965mECrIkbQ85jIcy11pyiMZL2tzP1F0Vi+UCFEPcUd9+gVFerB6q3s+7qTg9YqNEjoioW3a9AkdbGs2CSlCz7cD4AdouWdiqfgszzTccgsRw4Uaf+VYtGk/GsEZ8tFCh4o8ebl6RTnNew+GKyFQyzMGE98unuJuNMks1A/Z69VQouVvTv4PQ1WOMnYCeN9FKfvROnd7I+9UMDL+m+a8AnnUZKZJA8ZMb+1DAxW4yZe2hS3OPq01ewXgdhw29qFc2bi14svvGJKI7wVa/Bbc5E0CX4fjS2D3L7BpkG4KJm2KFgV1FKBbAjie0g45LrAAfDHHHXdvgvE20uKPTpDNRfJmGfsntsjWTcDadZwvv+l6hOzDPP7jmCwGFClBiQu19Xr8hdk7uhcghK7KcmVbHEAYsIdA6wbT2SuZwo4z7FmYBvrSj6utFwJHuxdzR8FjP8XVbXyAR/mLSJrtlb12yJAmNRRZpiKcEcu49RRRfGX5tSrp/8rd36o9b5kdaNWCsC1bL3rIfJw0XF/tv/I05WwBitaXDh2voA+4SqBylc2MV8M0wdPShD1HBhWt0AR58/1od/hsS8KQdHzbK6PQB1JBXp7Q/p+Tu3YL53tDELC1Hp7tqSIlgnJcTxSgTXomLhQMMXfasZIH3dm3Y1oIKXfGxA33b6+ts9Q5AmBzWziAbQhZFvFxEbmf/q3ehSD738zrfNOVJK6on2384rnggic0Aqb6FEVBDDUxThC2GD4kSNPVvGPjAWK6YfZjoxYiXyx+3/JhiCrfOqh39awhZzC3XTG/UDgi9HokNCml7kDRcmXy4bUK7WlwU86v
 ej7lqj+g
 tbotpirH+b+3MYw2SChXz4R7f3TMuHTjzp3WvlnJiLgDdWrY3R6ga1Tzx2i1bqc9rfIJgzbVULGc9xCvoh8z7tO+G1uehzCb+ATjk1TBPGMWWT5A/ga/JgKeT3JJZ5eH88jqB2I6NRAGM9FklDAAgQwgwL9RqAGQ7cXfv8hTjC6LzlzXuO0Isi3TbVTyoty2X6H+LUQAsDoO4q6esORSow6aSkY5E/pLhl2KeoKOn9cPSN/ux77898rjqkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 03:29:08PM +0100, Catalin Marinas wrote:
> On Tue, Apr 21, 2026 at 06:45:04AM -0700, Breno Leitao wrote:
> > +	/*
> > +	 * A brand new report. Object will have object->use_count increased
> > +	 * in here, and released put_object() at dedup_flush
> > +	 */
> > +	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
> 
> Do we need to allocate a structure here? We could instead add a
> dup_count member in the kmemleak_object and just link the object itself
> into the xarray. Well, maybe the leak being a rare event is not that
> bad.

Ack, that is a way better approach than this new struct and memory
allocation.

> 
> > +	if (entry && get_object(object)) {
> > +		if (xa_insert(dedup, trace_handle, entry, GFP_ATOMIC) == 0) {
> 
> I wonder if we need xa_insert() at all. Since it's indexed by
> trace_handle, we could follow similar mechanism like stack_depot with a
> large hash array, maybe gated by CONFIG_DEBUG_KMEMLEAK_VERBOSE.

This custom method would buy us a few things: no GFP_ATOMIC on the scan path,
no xa_node churn, no wait-context concern around object->lock, and the
xa_is_err fallback goes away. The cost is a static bucket array (a few tens of
KB) always reserved. Keep in mind that this code also change when uses set
`kmemleak_verbose`, so, we cannot gate it using CONFIG_DEBUG_KMEMLEAK_VERBOSE.

The xarray approach keeps the per-scan storage proportional to the number of
distinct backtraces actually seen, and scan_mutex already serialises
everything, so the GFP_ATOMIC/xa_node overhead only materialises when leaks are
being reported.

 Given how cold the scan path is, I'd lean toward keeping xarray unless you'd
prefer the static-table version for maintainability reasons — happy to respin
either way.

> > +			entry->object = object;
> > +			entry->count = 1;
> > +			return;
> > +		}
> > +		put_object(object);
> > +	}
> > +	kfree(entry);
> > +
> > +	/*
> > +	 * Fallback for kmalloc/get_object(): Just print it straight away
> > +	 */
> > +	raw_spin_lock_irq(&object->lock);
> > +	print_unreferenced(NULL, object);
> > +	raw_spin_unlock_irq(&object->lock);
> > +}
> > +
> > +/*
> > + * Drain the dedup table: print one full record per unique backtrace,
> > + * followed by a summary line whenever more than one object shared it.
> > + * Releases the reference dedup_record() took on each representative object.
> > + */
> > +static void dedup_flush(struct xarray *dedup)
> > +{
> > +	struct kmemleak_dedup_entry *entry;
> > +	unsigned long idx;
> > +
> > +	xa_for_each(dedup, idx, entry) {
> > +		raw_spin_lock_irq(&entry->object->lock);
> > +		print_unreferenced(NULL, entry->object);
> > +		raw_spin_unlock_irq(&entry->object->lock);
> 
> Sashiko has a good point here - while the kmemleak metadata is still
> around due to an earlier get_object(), the object itself may have been
> freed and the hex dump in print_unreferenced() could fault (e.g.
> vunmap'ed object). Same with the print_unreferenced() above. It's
> probably not worth printing the first bytes of the content anyway when
> we do coalescing, the content would differ anyway.

Agreed, this is a real race once the print is deferred. v2 addresses
it two ways:

1. dedup_flush() re-acquires object->lock and re-checks
OBJECT_ALLOCATED before printing. __delete_object() clears that
flag under the same lock before the user memory is released, so
the bytes are guaranteed live for the duration of the print.

2. The hex dump is skipped for coalesced entries (dup_count > 1),
as you suggested — the content would differ anyway, and skipping it removes the
only remaining read of object->pointer's contents in the deferred path.

> Also it's possible
> that the size differs even if the stack trace is the same but I guess we
> can ignore this.

Yes, ignoring — the representative's size is what gets printed and
the summary line just gives the count. Worth a sentence in the
commit message; I'll add one.

Thanks for the review and suggestion!

In casse you are curious, this is the new approach I am testing now:

commit fb356de0592c0de97d793207ef74b0f3f019379a
Author: Breno Leitao <leitao@debian.org>
Date:   Mon Apr 20 09:26:00 2026 -0700

    mm/kmemleak: dedupe verbose scan output by allocation backtrace
    
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

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 2eff0d6b622b6..d521cc71ec1ee 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -92,6 +92,7 @@
 #include <linux/nodemask.h>
 #include <linux/mm.h>
 #include <linux/workqueue.h>
+#include <linux/xarray.h>
 #include <linux/crc32.h>
 
 #include <asm/sections.h>
@@ -153,6 +154,8 @@ struct kmemleak_object {
 	/* checksum for detecting modified objects */
 	u32 checksum;
 	depot_stack_handle_t trace_handle;
+	/* per-scan dedup count, valid only while in scan-local dedup xarray */
+	unsigned int dup_count;
 	/* memory ranges to be scanned inside an object (empty for all) */
 	struct hlist_head area_list;
 	unsigned long jiffies;		/* creation timestamp */
@@ -360,8 +363,9 @@ static const char *__object_type_str(struct kmemleak_object *object)
  * Printing of the unreferenced objects information to the seq file. The
  * print_unreferenced function must be called with the object->lock held.
  */
-static void print_unreferenced(struct seq_file *seq,
-			       struct kmemleak_object *object)
+static void __print_unreferenced(struct seq_file *seq,
+				 struct kmemleak_object *object,
+				 bool no_hex_dump)
 {
 	int i;
 	unsigned long *entries;
@@ -373,7 +377,8 @@ static void print_unreferenced(struct seq_file *seq,
 			   object->pointer, object->size);
 	warn_or_seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu\n",
 			   object->comm, object->pid, object->jiffies);
-	hex_dump_object(seq, object);
+	if (!no_hex_dump)
+		hex_dump_object(seq, object);
 	warn_or_seq_printf(seq, "  backtrace (crc %x):\n", object->checksum);
 
 	for (i = 0; i < nr_entries; i++) {
@@ -382,6 +387,12 @@ static void print_unreferenced(struct seq_file *seq,
 	}
 }
 
+static void print_unreferenced(struct seq_file *seq,
+			       struct kmemleak_object *object)
+{
+	__print_unreferenced(seq, object, false);
+}
+
 /*
  * Print the kmemleak_object information. This function is used mainly for
  * debugging special cases when kmemleak operations. It must be called with
@@ -1684,6 +1695,103 @@ static void kmemleak_cond_resched(struct kmemleak_object *object)
 	put_object(object);
 }
 
+/*
+ * Print one leak inline, re-checking OBJECT_ALLOCATED under the lock so
+ * the hex dump does not touch user memory that was freed concurrently.
+ * Used by the dedup_record() fallback paths where we cannot dedup and defer
+ * printing through the xarray.
+ */
+static void print_leak_locked(struct kmemleak_object *object, bool no_hex_dump)
+{
+	raw_spin_lock_irq(&object->lock);
+	if (object->flags & OBJECT_ALLOCATED)
+		__print_unreferenced(NULL, object, no_hex_dump);
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
+		print_leak_locked(object, false);
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
+		print_leak_locked(object, false);
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
+		print_leak_locked(object, coalesced);
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


