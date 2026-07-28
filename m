Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACE2DC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82EE16B0095; Tue, 28 Jul 2026 08:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E22A6B0096; Tue, 28 Jul 2026 08:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F85B6B0098; Tue, 28 Jul 2026 08:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 340D06B0095
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:06:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A68BDA0349
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:06:23 +0000 (UTC)
X-FDA: 85038057846.20.F0C4CAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E40B110000B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:06:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZqSKJNkA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785240381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjKJkRa62Aqd+bRag3pI+uHr2P4wVFC3OXxyekYF02Y=;
	b=TQBg2DrtYc6NTjD62HJZ8qHqxvXBNL93CWoNsonUe4aIFAP6Y4aUl+GF7c9uoZyEmmBFZ5
	v9ZQoyCT4fAnfY7l7Vq/nBlqE9jcDF/fQ9HUkFIYjpYHIsw0gFSnKdwVXHb8REnUSTcURY
	DpeU9BvaDjmc5lFGBDXFJ3kp6JF0OM4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZqSKJNkA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785240381;
	b=039TckUkWbosYWByH4Go1/Ya3e8/35UTVUjzDnbADIH+2FXL1hAlLks5Rifw/AlPEO9A8b
	+52hH0/M40qx2defsjpsu9uIzSSflNAl0SC79nW83faUeUD9srfYRtd63wmZG9PHmt/qUt
	U3fmb++UZXpPArPlm1SN+pn/FRN9bSU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 80BE060AB1;
	Tue, 28 Jul 2026 12:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68571F000E9;
	Tue, 28 Jul 2026 12:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785240381;
	bh=mjKJkRa62Aqd+bRag3pI+uHr2P4wVFC3OXxyekYF02Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZqSKJNkAF/KlE3tup6g34OnBj0G+C23d3mRL8v1BQTh5fLKVxJRin1b4vsO4WDzAC
	 jeHL9nHBkp8TJ1lMzZmwSUII9IC+xE2ai/QRjduaPfzoi9xjHpXr6A/PD3yFwYj9Hn
	 Mx+4qdSvW8IjxkW0Gm6vDebs5GXnTBGSQRjmsS4TpSDoK9/+Iu3Tm6yFDZ9NJyXeHd
	 RuiEOpQdH0O/6srOMhVsfYgHj8Q8ewpXThszUmnAhLFaGTTzXxB9Ctb7FADihuCYp7
	 N9nZGFo76pKTMWHS6wVRGJCvamsbCKltfuv+ADwbT2Obszh0BpwMaULe6RUmGtv+iP
	 Xw1yzEbOnkT0A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 28 Jul 2026 13:05:45 +0100
Subject: [PATCH mm-hotfixes 2/2] mm/huge_memory: fix huge_zero_pfn race
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-fix-refcounted-huge-zero-v1-2-3f261f5447b4@kernel.org>
References: <20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org>
In-Reply-To: <20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7361; i=ljs@kernel.org;
 h=from:subject:message-id; bh=SFsjnbS3bJ4c9YZbrBfrJ8CJOq95OQeiVYiHgM8GtWU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIyZivJJb7nrmHbskx1Qt6a7x+kD25K5Ur9PTO73/zCJ
 F/L9ktrOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARbRaG/wUzi9Lf8z158GPb
 uhJOiUN+Ljd8o++q+bOJ79mTE/BAzZLhN8s5nsCGi0rnytVmhUdkrXHsW2NWs+B3KMvb+VIJdzf
 bsgAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E40B110000B
X-Rspam-User: 
X-Stat-Signature: 6rx4wma89ops1qrbpgp5cep6zfodzh9u
X-HE-Tag: 1785240381-803320
X-HE-Meta: U2FsdGVkX19AwiUfqx9dju0248jg38tXoh2upvn1DC32sx0mnGfC0L1+IUwe4nKjSwyz3nDNcys5XGr2hQ8KKLwfuHZkzujaY43sZx6DLFZTgYJ9B5lPakY5dF1EyB6uh7oaVqk7Q0YeISjsIl1+mCiAN1gh9DbdTabY4RQfThoD1Gjb36LGU+G2kaKFTiT6mgSpZedzo8BJki0fLmTuEuHNmZ4rxz4PIWPHkH3fODTlkoy5lx9rrUDtzJ5uEyh+CWeCG7h6a/6KXP0KNWgPo0hB2oneQGZYq2bDhc5KWInsRepmH3IQGfwpzXWhyanbaJzujylrvqWgixgx1YUl1Nf14DfVDLN7w+Zx9MWKe1XJEUv72NxAywbGDCrnMtj4BKRWsK7sc3JniYdF02CLnGYDgGQ4JTbyp8nl0/uBqRs1epW/yr4VWP3k32JFhcOoEkcAJDt/w8wymf7+/xQTDBmx0sbb5nxjshETrTVoKQkobCZIDsccfPlhFc9ZSvav4KU2qb9nj9SSmeC5//55c2v352FYQooBQNg+TXceN6BCf6q1Evtg8yrdqLsM3mqzwd89L3I3BxqlZjX1P3bfIosiwv6ANjhbAz4HsQVl94AzY1gzq/1V3LBxfEE3TpqLWu9zIpL+0L6PUVRSk26OG63Ik3xaKHZfa9fuDlE2J+fSXayxKG8CwyWSfVpRLriHQ2O5NKFytrbcIp9zfjWSvLs9KGM9pkdREdVr8PkA/PU/9vySF6NeR+P3KP9hkYPHYQahLNvwQijBvhbv3gdoCBj6tktEiQ3vRpePKDiNJ7lryNejjkzUxMLup1jNfzd1rCkkZ046TkyBaL/K+BmNbKSvALHWuC1myYrD1q3jfogIGMhRpcmzTtAm+f1O+2N7ikFv89m/EOjuNgBC67SylKaWFgPB/NQBR/vycseH38jyH/cAZJqXHTiIg7PfCl4l9IHLM05fgktpI/m4i/e
 /UorICCw
 gB8lkrSqGXgyqmA9est+JffhJHVeDbz0o++AlycxRx2rps+onOoCZQDClnoxepboJRuKOy7Wh7i6NIHhiyMHwY601fMwsiqZYd19E1QzunoAuewp4Wc1dqyAphnRtAUN2l2BYQuEKkIPXt7Dulyb1HtwkAksRQcmqcKyq03NzvKXkMMc9hDkkjtT+E7SCFzCs2XiRES9KZKjtHbQrcKt+sKGOvEOad2daFcghIGp1H4b58/wq/msGm4eFxIO/qv10N5dBQ56KYTZU9i/42ZBJqeMp6OnliurNWodG1+IlMq3Sft9+UAkhaADAjPuph8XDHv4I
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
outside of the critical section when !CONFIG_PERSISTENT_HUGE_ZERO_FOLIO,
and means huge zero allocation is gated on zero huge_zero_refcount.

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

* Only updating huge_zero_refcount in the huge_zero_lock critical section
  in get_huge_zero_folio() and shrink_huge_zero_folio_scan().

* Using atomic_set_release(&huge_zero_refcount) in get_huge_zero_folio()
  after huge_zero_[pfn, folio] are set. This is paired with
  atomic_inc_not_zero() to ensure atomic_inc_not_zero() only observes a
  non-zero value if huge_zero_[pfn, folio] are set.

* Using atomic_cmpxchg() in shrink_huge_zero_folio_scan() to ensure that it
  is set zero only when equal to 1 and set atomically.

* atomic_cmpxchg() being fully ordered ensures this is done prior to
  huge_zero_[folio, pfn] being set to NULL and ~0UL respectively.

Note that only the huge zero shrinker (via shrink_huge_zero_folio_scan())
can actually set huge_zero_refcount to zero, which is the count of mm's
which have at least one huge zero folio installed plus one shrinker pin.

Additionally convert a BUG_ON() to a VM_WARN_ON_ONCE().

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reported-by: Hengbin Zhang <uqbarz@gmail.com>
Closes: https://lore.kernel.org/linux-mm/20260727154001.4102341-1-uqbarz@gmail.com/
Fixes: 3b77e8c8cde5 ("mm/thp: make is_huge_zero_pmd() safe and quicker")
Cc: stable@vger.kernel.org # 6.18.x: dependent on prior commit
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0f60bc82e87a..acee2d28b9bb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -41,6 +41,7 @@
 #include <linux/pgalloc.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
+#include <linux/cleanup.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -82,6 +83,7 @@ struct folio *huge_zero_folio __read_mostly;
 unsigned long huge_zero_pfn __read_mostly = HUGE_ZERO_UNSET_PFN;
 #ifndef CONFIG_PERSISTENT_HUGE_ZERO_FOLIO
 static atomic_t huge_zero_refcount;
+static DEFINE_SPINLOCK(huge_zero_lock);
 static struct shrinker *huge_zero_folio_shrinker;
 #endif
 
@@ -270,7 +272,8 @@ void mm_put_huge_zero_folio(struct mm_struct *mm)
 static bool get_huge_zero_folio(void)
 {
 	struct folio *zero_folio;
-retry:
+
+	/* Paired with atomic_set_release(). */
 	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
 		return true;
 
@@ -278,17 +281,21 @@ static bool get_huge_zero_folio(void)
 	if (unlikely(!zero_folio))
 		return false;
 
-	preempt_disable();
-	if (cmpxchg(&huge_zero_folio, NULL, zero_folio)) {
-		preempt_enable();
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
@@ -312,15 +319,22 @@ static unsigned long shrink_huge_zero_folio_count(struct shrinker *shrink,
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
+		VM_WARN_ON_ONCE(!huge_zero_folio);
+		WRITE_ONCE(huge_zero_folio, NULL);
 		WRITE_ONCE(huge_zero_pfn, HUGE_ZERO_UNSET_PFN);
-		folio_put(zero_folio);
-		return HPAGE_PMD_NR;
 	}
 
-	return 0;
+	folio_put(zero_folio);
+	return HPAGE_PMD_NR;
 }
 
 static int __init huge_zero_init(void)

-- 
2.55.0


