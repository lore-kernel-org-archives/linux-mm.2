Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79B35C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 10:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7459D6B0093; Thu, 30 Jul 2026 06:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71D296B0095; Thu, 30 Jul 2026 06:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632F66B0096; Thu, 30 Jul 2026 06:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33D7A6B0093
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:56:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C6F4B1C1266
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:56:19 +0000 (UTC)
X-FDA: 85045138878.20.62B2550
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id EF6F11C000C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:56:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OtLn6gsx;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785408978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9Xu4NzS9+9i6cOnOquw83IQLYolWiz6Ch/ixPkboEw=;
	b=ioLDNVwZHzPVRXXEwU3S/FvkIR+vwEn/mPwG4cKaAFyzHXAT96Nqkyohvps8iTb40SCVdz
	ackgmzNAOwI0JlG86kPvuCdg9VT03G57QoHLsdNgNklF1JjktmoBijVrpbNK4IHEw4jxbf
	QegXnRkF7V6o9dULQAJ1KqryG2Cm+s0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OtLn6gsx;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785408978;
	b=wzrdkO9zlE3FIT+paW6wUoUcvUM3vxtiDOATD/m1g35IavuGnBT9ejba226YkqB+2I631U
	1trzU1Hj1Bk4GHJ+Yf+f+b4HI7vAabM59rcudJSCo+NmesV6tD1rdzrTav7gYOChw9KywG
	P5ARycDwolH+tPOO/XgD7QjDmufR94w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6848D600B1;
	Thu, 30 Jul 2026 10:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91001F000E9;
	Thu, 30 Jul 2026 10:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785408977;
	bh=e9Xu4NzS9+9i6cOnOquw83IQLYolWiz6Ch/ixPkboEw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OtLn6gsx+Ixlq8bL/+lhu9UmxDYQA4TlXUIHW/LOkcWBYcNIgmYtoD32dB5SQ1vLk
	 eu5q1YpYggWlu12BXlPOZvIgmX8pGkvqYBEkxZGNj9uFyjR/UDbpbKf13ViUHE5GzN
	 /sllPPXoRMGaahC78COX3PpLet+vx5LWCVFrbFTnYApMSliAWeEEcN5KcwxUFzYz5i
	 KKyRaf2yM9Mgeflf+/XE8TE02O8zC7Gud/8XQSEIfOuqL5r2XwkAGIJ/ta3jmgZijK
	 5fJjn1u6Ti7pnS3+4ugN0Y60/jz6cmvAVdi7OBAkb7SynurmBkUGGNdKo0mRadOknK
	 UIVNaCKIqQc5g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 30 Jul 2026 11:55:47 +0100
Subject: [PATCH mm-hotfixes v2 1/2] mm/huge_memory: fix huge_zero_pfn race
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-fix-refcounted-huge-zero-v2-1-c5d8a41b317f@kernel.org>
References: <20260730-fix-refcounted-huge-zero-v2-0-c5d8a41b317f@kernel.org>
In-Reply-To: <20260730-fix-refcounted-huge-zero-v2-0-c5d8a41b317f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>, 
 Hannes Reinecke <hare@suse.de>, Hugh Dickins <hughd@google.com>, 
 Yang Shi <shy828301@gmail.com>, Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Hengbin Zhang <uqbarz@gmail.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=7999; i=ljs@kernel.org;
 h=from:subject:message-id; bh=IRgSi/0LFnuUZJKJpz25rLsHbrN3WwCytgcKhXlMJd0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKydXetn9m84jd/QjhvdcOloFX6Mw8I1K0+9alFbF9Cx
 O9LG+wndpSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAij7YzMjwQPrx8em5uxtRe
 7sy6AmszhTC3qmVXXy1x3rHr1tF8rv2MDEfuBZ/+y6SkwrL8lzdjda0B95kJxgulm5TUo+rzf32
 czQUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EF6F11C000C
X-Stat-Signature: bc411pfxprirrb4fab6i6iuzout7e93x
X-HE-Tag: 1785408977-558526
X-HE-Meta: U2FsdGVkX1/T3cAwWIk+2mSpEmsaivG7uU8FcfGaI37mfulpw0y03sKNFJXqVIzVnvQHL65NBBszvju8Ai20i4Bme9uSBsjR3CTPWx3wE04ja05R99guh1yEWtdfW4ADMSagxYH9pSGLkiRS9MBxpKjayacexJrYFkHhYTMFVDngohEKrX3D8IXs+Unm6B9IOAS8Fz2UHUG2bwyTJHfC9Xukbuk/qSkMOOZ8Hj+UV7XptpsfHJR0ffcuwxT8n6RjTFub4b8mrffU6ghtb1+o2qyvB4HpEu5FndzirmTFwld1N9f7Ju6ZGMc25RPZqRJSzzXHxleqQw4qpK7yx1jiw/ErZ6tGCnppydp0TUvcTDHcOUFO0APFOQtmm3WdUJI3n5t1uoH6Gcj9aX+97FO9b4oOLRp//5eOs6focnjjo7eysA+MtLsmfZc46dzlxvHi90MXcQH8lyqsRivMRp1t5L8typtjgkkagz2kVMyM9aRdXJGqk3X52jipSKKCJl3uEExbhNd9O1DnibW2Qg13DyWT0QyNX0oG4209bdnwACS9v6rX68/FBA8nvzFeMueI91oFLNqrakdXa4wz7r2fqG1pXL7MJdPMir3ohWdiu3uujtHUfNpPx9s78bOyl1+QNH/goggvXUBxaijprJjT5eHvcai43yRyFhVbibyphn5Se/5hQQy19G/dn3mA36z2/3sbG50SxqXcHUAeVJrxze7bz+hU3YjQ6Ipm6x4aNjwB+PjCC76NGSLkiNDZYUow/BPPdIXYe4W7TjZuBDF9RxFUf/SR5zJzrt0uisQ8+/HRWP/WGHLICZegX6FKilAu23oquLKdU9qE73tMseoXGooQZvpV6JxC+1zG9+QmNCLs9atKMr7UJcMgaDvhQFsGX1NukRFyFVaVUtY4+IJEkJpo/9mxNyO8WPteacuedLBOC+RVjLLAtor0UmuyuslmQgNJQ4GzsefZtSHsjKP
 dYiIxc6q
 5ZfQio+aKjuWA6+5wlTWMDaXuko+175xLAAWow30/34BxZKPyzOmCm3Q7ydDyX14RS9sGu3c+o2XoMu8TayDxfXlkFz5PQVbCpy66G6DWOv3J6u4b8QFNiDflSqBW2cZ3MclH6KmntVamK7T/v2O4cQ3W3nBwoQLsBkbMA1Mpm1N1NAfzogv4XdKkAUSBpCqwQVBHLcjdINO+CevEp/75Es2cPDz9+ZsSKYFOBT/9IH2VcpqGsBb06EiAEIejQwqcQN6RSCcaJdjWQPwp9LhByaSFs1C9ClqreB2ISRQmIuMv4bk9q+/v3tkDW96L9rjYqs7K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If !CONFIG_PERSISTENT_HUGE_ZERO_FOLIO, the huge_zero_folio is refcounted by
huge_zero_refcount and returned by mm_get_huge_zero_folio().

When the caller is done with the huge zero page, its reference count is
decremented. Only a shrinker can set the reference count to zero.

A race can unfortunately occur between a shrinker decrementing the
reference count to zero and a concurrent page fault.

This is because shrink_huge_zero_folio_scan() might, if very
unlucky, be preempted between setting huge_zero_refcount to zero
and writing an invalid value.

During this time get_huge_zero_folio() could write to huge_zero_pfn
before shrink_huge_zero_folio_scan() resumes.

In this event the huge zero folio will be persistently
misidentified causing the THP code path to be entered
inappropriately for the huge zero folio:

                CPU 0                                   CPU 1
=======================================|=================================
shrink_huge_zero_folio_scan()          |
   atomic_cmpxchg() sets refcount to 0 |
   xchg() sets huge_zero_folio to NULL | get_huge_zero_folio()
                 |                     |    atomic_inc_not_zero() -> zero
      preempted for a long time        |    Allocate new huge zero folio
                 |                     |    Write valid huge_zero_folio
                 v                     |    Write valid huge_zero_pfn
  Overwrite huge_zero_pfn with ~0UL   <--- Invalid overwrite!

This results in is_huge_zero_pfn() and is_huge_zero_pmd() incorrectly
returning false for a huge zero page which could result in issues like the
huge zero folio being incorrectly split.

Note that the issue is with huge_zero_pfn not huge_zero_folio, as
get_huge_zero_folio() uses cmpxchg() gated on huge_zero_folio being NULL
with a retry loop and shrink_huge_zero_folio_scan() uses xchg() to set
huge_zero_folio.

Fix the issue by introducing a spinlock, huge_zero_lock, to prevent
concurrent write of huge_zero_folio, huge_zero_pfn and huge_zero_refcount.

There needs to be significant care taken here to ensure correctness:

The fast path in get_huge_zero_folio() uses atomic_inc_not_zero(), which is
outside of the critical section, and means huge zero allocation is gated on
zero huge_zero_refcount.

The fast path doesn't use huge_zero_lock, so the critical section is
irrelevant to it.

So invariants are required - huge_zero_refcount MUST:

* Only be set in the huge_zero_lock critical section to ensure
  serialisation of huge_zero_pfn, huge_zero_folio and huge_zero_refcount
  writes.

* Be set non-zero only AFTER huge_zero_[pfn, folio] are set to valid values
  so installation of the huge zero folio on read page fault ensures
  concurrent is_huge_zero_*() calls correctly identify the huge zero folio.

* Be set zero only BEFORE huge_zero_[pfn, folio] are set to NULL and ~0UL
  respectively, and atomically.

Establish these by:

* Only setting huge_zero_refcount to zero or an absolute value in the
  huge_zero_lock critical section in get_huge_zero_folio() and
  shrink_huge_zero_folio_scan(), and always updating atomically there
  and elsewhere.

* Using atomic_set_release(&huge_zero_refcount) in get_huge_zero_folio()
  after huge_zero_[pfn, folio] are set. This is paired with
  atomic_inc_not_zero() to ensure atomic_inc_not_zero() only observes a
  non-zero value if huge_zero_[pfn, folio] are set.

* Using atomic_cmpxchg() in shrink_huge_zero_folio_scan() (as before) to
  ensure that it is set zero only when equal to 1 and set atomically.

* atomic_cmpxchg() being fully ordered ensures this is done prior to
  huge_zero_[folio, pfn] being set to NULL and ~0UL respectively.

Eliminate the retry loop in get_huge_zero_folio() as the atomic_cmpxchg()
in shrink_huge_zero_folio_scan() is now performed under the lock, and
replace with an equally locked atomic_inc() to set the reference count
should the caller be raced on huge zero folio installation.

folio_put() naturally implies a full memory barrier so its ordering is
maintained correctly.

The huge zero folio also cannot be released except when the shrinker does
so as it is non-LRU and non-rmappable.

Note that only the huge zero shrinker (via shrink_huge_zero_folio_scan())
can actually set huge_zero_refcount to zero, which is the count of mm's
which have at least one huge zero folio installed plus one shrinker pin.

Additionally convert a BUG_ON() to a VM_WARN_ON_ONCE().

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reported-by: Hengbin Zhang <uqbarz@gmail.com>
Closes: https://lore.kernel.org/linux-mm/20260727154001.4102341-1-uqbarz@gmail.com/
Fixes: 3b77e8c8cde5 ("mm/thp: make is_huge_zero_pmd() safe and quicker")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 032702a4637b..1f0535721652 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -41,6 +41,7 @@
 #include <linux/pgalloc.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
+#include <linux/cleanup.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -78,6 +79,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 static bool split_underused_thp = true;
 
 static atomic_t huge_zero_refcount;
+static DEFINE_SPINLOCK(huge_zero_lock);
 struct folio *huge_zero_folio __read_mostly;
 unsigned long huge_zero_pfn __read_mostly = ~0UL;
 unsigned long huge_anon_orders_always __read_mostly;
@@ -224,7 +226,8 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 static bool get_huge_zero_folio(void)
 {
 	struct folio *zero_folio;
-retry:
+
+	/* Paired with atomic_set_release(). */
 	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
 		return true;
 
@@ -237,17 +240,22 @@ static bool get_huge_zero_folio(void)
 	}
 	/* Ensure zero folio won't have large_rmappable flag set. */
 	folio_clear_large_rmappable(zero_folio);
-	preempt_disable();
-	if (cmpxchg(&huge_zero_folio, NULL, zero_folio)) {
-		preempt_enable();
+
+	/* Paired with critical section in shrink_huge_zero_folio_scan(). */
+	spin_lock(&huge_zero_lock);
+	if (huge_zero_folio) {
+		/* Somebody else already installed it. */
+		atomic_inc(&huge_zero_refcount);
+		spin_unlock(&huge_zero_lock);
 		folio_put(zero_folio);
-		goto retry;
+		return true;
 	}
+	WRITE_ONCE(huge_zero_folio, zero_folio);
 	WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
+	/* Paired with atomic_inc_not_zero(). +1 for shrinker pin. */
+	atomic_set_release(&huge_zero_refcount, 2);
+	spin_unlock(&huge_zero_lock);
 
-	/* We take additional reference here. It will be put back by shrinker */
-	atomic_set(&huge_zero_refcount, 2);
-	preempt_enable();
 	count_vm_event(THP_ZERO_PAGE_ALLOC);
 	return true;
 }
@@ -297,15 +305,22 @@ static unsigned long shrink_huge_zero_folio_count(struct shrinker *shrink,
 static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
 						 struct shrink_control *sc)
 {
-	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
-		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
-		BUG_ON(zero_folio == NULL);
+	struct folio *zero_folio;
+
+	/* Paired with critical section in get_huge_zero_folio(). */
+	scoped_guard(spinlock, &huge_zero_lock) {
+		/* Paired with atomic_inc_not_zero() in get_huge_zero_folio(). */
+		if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) != 1)
+			return 0;
+
+		zero_folio = huge_zero_folio;
+		VM_WARN_ON_ONCE(!zero_folio);
+		WRITE_ONCE(huge_zero_folio, NULL);
 		WRITE_ONCE(huge_zero_pfn, ~0UL);
-		folio_put(zero_folio);
-		return HPAGE_PMD_NR;
 	}
 
-	return 0;
+	folio_put(zero_folio);
+	return HPAGE_PMD_NR;
 }
 
 static struct shrinker *huge_zero_folio_shrinker;

-- 
2.55.0


