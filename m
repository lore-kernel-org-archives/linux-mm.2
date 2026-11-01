Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75168606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 18:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KZyqzvaD
Received: by kanga.kvack.org (Postfix)
	id 5503A6B05B4; Sun,  1 Nov 2026 13:37:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 526AB6B05B5; Sun,  1 Nov 2026 13:37:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43CF66B05B6; Sun,  1 Nov 2026 13:37:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 147AB6B05B4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:37:06 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 82B8F1A0A03
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:37:05 +0000 (UTC)
X-FDA: 85387407210.19.3DCA5D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 60E0180006
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:37:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KZyqzvaD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793558223;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Jxx/xd6pCWHtMs9q1hQKO+mSAAQUnWlajC1KDUBk9TQ=;
	b=FWWewL9USVIRoz07AxcLx5xwKJYimoqLaM5UQUmsP5fKwkeQuPEGT3UJeiSffVCTbEwlIQ
	PF3chgLokJhKyq6rVZaYBhj1wI30g/sU58wutjWHQj9OUDGHK4jcm7iTxZt94x9ydMbkaA
	ADD8frCBfaN1THyAqHzO5+ZLLLWUvOQ=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KZyqzvaD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793558223;
	b=FnyWLEPEcaG6h1MnDuWJ1Kgwko83mQl6b/vgL5Bv5FRGBs3kb5p+3i0rawgjmHODTDjOGO
	4HwoRCTEzuqQvwRjsglS/iYjZApYempjRC/4R++vx1tDqCYVsb6VfNDmA+4VwvGDr/BANv
	Iq/9na5awagqIMz784ZFWkoKcaoQYqY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FDE7434F8;
	Sun,  1 Nov 2026 18:37:02 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793558222;
	b=AyekSGmPeS7CbstnkeXvV1MJw21JXjji/Q+QY+YnePFBRJfm4q2o6ZZnCa1Z7KDHa/5c
	 KAvTe30gbwvGr6p4auD5ymCDoKiwUvxddFRr4DteNl+PzhToqaS1NVx57ApTe5zWDTefy
	 CgtP16hjL2mgloKhBGHdtsKLc2vkhBbZrQYqhXYLHphvQB+n84L6aHmAskVyMzZZ0DR3p
	 CyU//TTzxBhAg//X9rbvgwhRMrg6/GnR+b2pIPvsOpUbdB4mmUXz3NiLFHhrBblSdkTX4
	 3a6Bh2BJ/W6oyTVtS/vusv/ttaXhKm81cqCilIvQjd2qfpCRBz7+zIAhCW26WwnQQpw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793558222;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Jxx/xd6pCWHtMs9q1hQKO+mSAAQUnWlajC1KDUBk9TQ=;
	b=emMHHqmdfWVzkvhURwhBkHbTra3iOSPELpY62SBKlYsMh31MFrlJQz1s4Vit++TVfggd
	 pETwk7/hXd0TEGOunD/y2T0qvKb5HKfjhiMCQYq/o1qsFEiYS1U8rgHc9DdPmIFDCXv+l
	 1f5YbEbeAGIyUW6swJu4V5S71ReIWI17ISduWMyh81oCzIkFdQdPW6NKjqwdIHoAgOoyB
	 QFUZE0tmjK8twki4oYrYSGjCIc35qv/RXwN8LC8nL7P4P+1t1frRu6cTzfC5IIbKC5CyX
	 upzWRQbD/tuPs3GzkVW0ecZoTp7mFzirGeJ98aho2fwAKCxBkpEQS+UArxHJO8kMCtA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7D98D1F000C1;
	Sun,  1 Nov 2026 18:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793558222;
	bh=Jxx/xd6pCWHtMs9q1hQKO+mSAAQUnWlajC1KDUBk9TQ=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=KZyqzvaDuNOPUw1sylWUyDAZpFRFw+p0beV0ZZbziqGxvwbJKOXGH4iZQTxUVRVki
	 rYH2nDZazPLGdAVU2ruwWjayn45jiL40aJR6j/rR05IMlC19ql9Q5pB0olwVNXenlY
	 jdx2GCEgbCfgUwXk7/LkMZolg5hy1UZrCT5p07zs7TMH90G5MpWDoj0mvfVx+9uJGi
	 E6hgUIV5dHhYhJj6g5S33gxmxeciah/oFSDw0ANuzoRmDOlFkQxUU9PnjdgnOq9E3G
	 z5pfeYeMPq2qQ8CSYJiFAWxkDKDnKILW5+OlMkv/KE0Ly2mK/JGm2XTMxoNyAuu6Ua
	 1Vw0SRAlHuFPg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CA2A24622F;
	Sun,  1 Nov 2026 18:37:00 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Sun, 01 Nov 2026 13:37:00 -0500
Subject: [PATCH] mm/memory-failure: set PG_hwpoison of a non-hugetlb page
 under hugetlb_lock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261101-hwpoison-hugetlb-ro-v1-1-a42d6411cb65@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDMBBA0avIrDuQWJTUq0gXUSdmpCSSUVsQ7
 96oy7f4fwehxCTQFDsk2lg4hgz9KKD3NoyEPGRDqcpaq6dC/50jSwzo15GWT4cpYuWMMdrWyro
 X5HJO5Ph3Xdv3bVm7ifrlXMFx/AH/N+LpdwAAAA==
X-Change-ID: 20261030-hwpoison-hugetlb-ro-5f8881a60af9
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793558220; l=6529;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=vY4HPfMnuH6pA4pu5hK+iTt0s/Q+jMXoy6cASM5sNGg=;
 b=BJZtadvt5YuVcWGhuFJ00T8dPa/oJPXlWu1Wz1QVyyt6FBAJ+lLQ/sG8Utr4BPh/1ygdTKDfM
 fVpY5oVI+boAN4a2XqYq7k1+iYM8E6KiGtqYDNzR+LG2E2/GDm+slCG
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 60E0180006
X-Stat-Signature: m4wngq9ycsmjdch63k3r81b8re6d98cn
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793558223-980820
X-HE-Meta: U2FsdGVkX1/HUYyHM6ulLJaLBsvvEwPl9MSv+WjKmHpwBMvmoIut4TfCNOErc7A2+9SERgD6bu94Q9IhtScFC3vx4mLq92UIA6JDVTTeHCXygU1yVVYqLflzNwi9YksW0Xo3tPKAQnaHWcv+0A338W9pqSwU9/jkGq29zkuJj92PoAgR0fnfwJ2M/PFc14LQ8JJgjX46WM7JvNwg8xtZREc/uyLNehS/HWAcgeykzUJoptclfHrRr7jjO6anb3S0MqO1SICpSh3/74xD/z1oFY3vBLMo2G1mjNQfLM+OKJvtdGH2/gXzw+Jxb8QOIChN5XrCU6HUIptne+YhAjiJ3/Zbp7rPxX3AwSIbMcU6frz+E9u6il66WGFPj9qoX9ALI6gNLx54t29hgGb8LBhsf7DBbQ+8HBNxH42tTMVPlNCze6rHnP0udL5JsT2bJlai+QZSVe5fvvwKeddyhPhQNtxV9RjwYag2d340ACCtMr0CkxhnhoUXxlakNvR+x4l/vnqUySf6Pdv9NIDA0oYdncn3ZjJd05bl1+4ufrmNfa+T6BSCQaQGpwdwGxjwAPfBDprmP6RWGMXy9hprxgeIDJWlXU6ti7fAm6nI/mpMTJTzdb/IpNktipgmf7zK+s2Acetrz+YA1iRD5aqu1XmnZI+aEFyNuEkI9WAAaf1pa6I9Q2H2hopBeHA5HCYJ9ojoBtAd+0NHyCB802Q/lE5DbYO5Jhz3Xxkr5kjXEC7NGIw6ofGO5TsG1ZCsUSHdb9CiRdVP0qTbajjGr4phG3spEBkXQ5lepfCAhjyEVdET4dhdO/IXIK8GkC3tDDtHjC+NpHijG2fKZpiu/u2OvHH6+USug/saRkyaN6+lUq8fuY+JERcrrmsoRR7+79VM5FJ44rMPAgVpQyqe3AIE5mq9fPSi1qaC5fWGqd7esSKb6SvpUD513FkXhIkg3dNIuN0gb5TqsxmQGpc01cvHgER
 M93owvTi
 HTFrIlMA96Ozh/Z9t+JOgU3cUfW7foCucmRKWzHby368IQqFVhXp/S5unvpX9nTsxZFVICJrmG8l+0rkaoVCb3hbXmZ10sr1dQ/xkg+I41iZDae62CDWAKl/f26TBmEgkTtLqN3HpAYwXn4rxDDTgx99C1bB52fBwuzc5RhVrbu0yo/BpnGc/G7H+qS6vxA0alVbKzve6L7Ox2/s/MmTg7I51vV4ASjOnqJQbrbO+ELn+RAqPa2EQj1KCQ+JERcW5k6w9tEWSqlIMtRKlcwtEgTkuRWcfhGDEA9HHP+q7HTFMrclPqyz3tOjXKMSptAMrF2CtnR39VK3Her6cERxon+9lXKTFX3UkSHQHBHq5C2V9X9O125WIFa23RcGdULTMvRdZ4QkbuCin/7dw+ajH99p+Z8towFS8n/1BertjV6Hx9LPm/YoV869L5vKMSWGHPlhiRi29ew/tnzBj69bmKUqzqrICGBM7SVidI0xm0eoARn5+5waV8LtQAq3A62xEUyX2HsP6MRcZDt/tA4lVCla2JtELfyy+t/Jxc8zMhYw06IXc4B6lvFgvwad3Aqtlj6XgjePtdweEvK1JV3PFHXMngLtL2AW2eqsyrKMuPkmEJQwV8Ap+dM/cHJUNO17DG8U1efZyKYFQVz0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mani Tofigh <mt4022@columbia.edu>

memory_failure() checks under hugetlb_lock that the page isn't part of
a hugetlb folio and sets PG_hwpoison only after dropping the lock.  The
page can become a tail page of a new hugetlb folio in the meantime.
With hugetlb_free_vmemmap=on its struct page then lives in the tail
page that all such folios in the zone share, so the flag lands on tail
pages of every one of them:

  Task A (memory_failure)              Task B (nr_hugepages write)
  get_huge_page_for_hwpoison()
    /* P not hugetlb */
                                       alloc_fresh_hugetlb_folio()
                                         /* P becomes a tail page */
                                         hugetlb_vmemmap_optimize_folio()
                                           /* P's struct page now in
                                              the shared tail page */
  TestSetPageHWPoison(P)

The error on P itself is ignored, while healthy pages of other folios
stay marked and are never reused once their folio is freed.  After
freeing the pool, /proc/kpageflags shows them as hwpoisoned.

This is the allocation side of the race that commit 32c877191e02
("hugetlb: do not clear hugetlb dtor until allocating vmemmap") fixed
for freeing.

Set the hugetlb flag of a new folio under hugetlb_lock and set
PG_hwpoison of a non-hugetlb page inside the locked check, so that the
vmemmap can't be optimized in between.  The retry path clears it under
the same lock.  With the fix, no healthy page gets marked anymore.

This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development.  The C reproducer below however
hits it within about 35s.

Fixes: f41f2ed43ca5 ("mm: hugetlb: free the vmemmap pages associated with each HugeTLB page")
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/hugetlbro.c
---
 mm/hugetlb.c        |  3 +++
 mm/memory-failure.c | 37 ++++++++++++++++++++++++++++++-------
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ff9dbfbc7a96..eab0d9c5758b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1770,7 +1770,10 @@ static void account_new_hugetlb_folio(struct hstate *h, struct folio *folio)
 
 void init_new_hugetlb_folio(struct folio *folio)
 {
+	/* Pairs with get_huge_page_for_hwpoison(), see there. */
+	spin_lock_irq(&hugetlb_lock);
 	__folio_set_hugetlb(folio);
+	spin_unlock_irq(&hugetlb_lock);
 	INIT_LIST_HEAD(&folio->lru);
 	hugetlb_set_folio_subpool(folio, NULL);
 	set_hugetlb_cgroup(folio, NULL);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index b705f9f97f42..087b385aa060 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1976,6 +1976,7 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 #define	MF_HUGETLB_FOLIO_PRE_POISONED	3	/* folio already poisoned */
 #define	MF_HUGETLB_PAGE_PRE_POISONED	4	/* exact page already poisoned */
 #define	MF_HUGETLB_RETRY		5	/* hugepage is busy, retry */
+#define	MF_HUGETLB_NON_HUGEPAGE_POISONED	6	/* not a hugepage, already poisoned */
 /*
  * Set hugetlb folio as hwpoisoned, update folio private raw hwpoison list
  * to keep track of the poisoned pages.
@@ -2060,7 +2061,11 @@ static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 	spin_lock_irq(&hugetlb_lock);
 	folio = page_folio(page);
 	if (!folio_test_hugetlb(folio)) {
-		ret = MF_HUGETLB_NON_HUGEPAGE;
+		/* Mark it before it can become part of a new hugetlb folio. */
+		if (TestSetPageHWPoison(page))
+			ret = MF_HUGETLB_NON_HUGEPAGE_POISONED;
+		else
+			ret = MF_HUGETLB_NON_HUGEPAGE;
 		goto out_unlock;
 	} else if (flags & MF_COUNT_INCREASED) {
 		ret = MF_HUGETLB_IN_USED;
@@ -2111,7 +2116,8 @@ static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
  * PageHWPoison) should be done in single hugetlb_lock range.
  * Returns:
  *	0		- recovered
- *	-ENOENT		- no hugetlb page
+ *	-ENOENT		- no hugetlb page, now marked hwpoison
+ *	-EEXIST		- no hugetlb page, already marked hwpoison
  *	-EBUSY		- not recovered
  *	-EOPNOTSUPP	- hwpoison_filter'ed
  *	-EHWPOISON	- folio or exact page already poisoned
@@ -2130,6 +2136,8 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
 	switch (res) {
 	case MF_HUGETLB_NON_HUGEPAGE:	/* fallback to normal page handling */
 		return -ENOENT;
+	case MF_HUGETLB_NON_HUGEPAGE_POISONED:
+		return -EEXIST;
 	case MF_HUGETLB_RETRY:
 		if (!(flags & MF_NO_RETRY)) {
 			flags |= MF_NO_RETRY;
@@ -2189,10 +2197,24 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
 	return identify_page_state(pfn, p, page_flags);
 }
 
+/* Keep the flag if the page has become hugetlb in the meantime. */
+static void clear_non_hugetlb_hwpoison(struct page *page)
+{
+	spin_lock_irq(&hugetlb_lock);
+	if (!folio_test_hugetlb(page_folio(page)))
+		ClearPageHWPoison(page);
+	spin_unlock_irq(&hugetlb_lock);
+}
+
 #else
 static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags)
 {
-	return -ENOENT;
+	return TestSetPageHWPoison(pfn_to_page(pfn)) ? -EEXIST : -ENOENT;
+}
+
+static inline void clear_non_hugetlb_hwpoison(struct page *page)
+{
+	ClearPageHWPoison(page);
 }
 
 static inline unsigned long folio_free_raw_hwp(struct folio *folio, bool flag)
@@ -2470,12 +2492,13 @@ int memory_failure(unsigned long pfn, int flags)
 try_again:
 	res = try_memory_failure_hugetlb(pfn, flags);
 	/*
-	 * -ENOENT means the page we found is not hugetlb, so proceed with normal page handling
+	 * -ENOENT and -EEXIST mean the page is not hugetlb and is now marked
+	 * hwpoison, so proceed with normal page handling.
 	 */
-	if (res != -ENOENT)
+	if (res != -ENOENT && res != -EEXIST)
 		goto unlock_mutex;
 
-	if (TestSetPageHWPoison(p)) {
+	if (res == -EEXIST) {
 		res = -EHWPOISON;
 		if (flags & MF_ACTION_REQUIRED)
 			res = kill_accessing_process(current, pfn, flags);
@@ -2506,7 +2529,7 @@ int memory_failure(unsigned long pfn, int flags)
 			} else {
 				/* We lost the race, try again */
 				if (retry) {
-					ClearPageHWPoison(p);
+					clear_non_hugetlb_hwpoison(p);
 					retry = false;
 					goto try_again;
 				}

---
base-commit: 5e6c45aaaf93343c7f8a1cde9797080238af5c1b
change-id: 20261030-hwpoison-hugetlb-ro-5f8881a60af9

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>



