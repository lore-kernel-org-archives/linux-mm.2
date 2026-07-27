Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3B26C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 13:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B064E6B00A7; Mon, 27 Jul 2026 09:19:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADDD56B00A9; Mon, 27 Jul 2026 09:19:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A69D6B00AA; Mon, 27 Jul 2026 09:19:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6932B6B00A7
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:19:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D9DE014070F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:19:39 +0000 (UTC)
X-FDA: 85034613678.02.57F9DE1
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id 29D991A0006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:19:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cx3OUODS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of uqbarz@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=uqbarz@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785158378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lEceZ6FrG9kgXwqbPymkbPYYUj1GiTAukTMmaD6Bev0=;
	b=wU8VXsqvm0Chuus08nh0CTCopT370YqKvx20dQV72wPHLf4HZXATryE6Kabzmz96D/c9Cg
	f3hALzciHBfW4Mfj65e5ioErACGgcFmppQtJ8qf9opnSrpqeai1mOMBfwzVSPXciOLpDo0
	0vC4GwUiEqnyCgTQqvHSQ57xjmYLb1w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cx3OUODS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of uqbarz@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=uqbarz@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785158378;
	b=x7QTdRdJ1GUqtVTpngfIgsvoheXP8vjIqypRy9E37nRnSMhJlKtUOFL9zyBtdtc1b1uMFk
	5OuNa3wTiFsitveIEyygHM3JjZArA69WiB0B+3znP7RiFR0gc8gIY7Hm3ezBme5ImY+bpI
	Tva5NxYC341jLue4sVVCijSLgK10sUM=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-ca12086c06eso2096064a12.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785158377; x=1785763177; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lEceZ6FrG9kgXwqbPymkbPYYUj1GiTAukTMmaD6Bev0=;
        b=Cx3OUODSPH1S+7mqzf2V+XI7JQGUnq6V50diobuML6a6yJx02YdDqEHM+m1yXcb2El
         CxgGagJXKJBvy8/9EwKmUZXzhuuFhRQBgSkVAsEH+j7SMSajS/nE1vO/TAF61CPQaZfJ
         tJ3IyjdeN62lN6fxNCRKVsyZBhanTg/TGAtcCucH+jW5OAL8gmXOGbbS/igIFstHgEWv
         2AEooge/YN6pHSzlVhg/Rv1rjDxllpaRbNPMn0Mafcx3I2ix9NfFzSbZoU5c0dyBnVo8
         Homnxx+K60n99bYbEiul7IQD1Vba94G5/mLTW2DivTl9LnCd4iVOId6yXV8SiX2M/8bH
         AGIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785158377; x=1785763177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lEceZ6FrG9kgXwqbPymkbPYYUj1GiTAukTMmaD6Bev0=;
        b=X2W2TpVI4slbim2WO6EGHn9rWJjCU2PvZZudcr4ayuhNDilOL+FckQMrXKmQ9dDhGf
         cfCEYQhdPT0liJI00G+V4O0Mns0QFAxmMFgJdKNoW4pooCRGAI2ZLIp6YJAn2SYeOn5w
         6sNoryImRQmc/W4Q++hY2tWBumtWNmYQBN2saQgmgWTTCmlFe8GFl3b0T13ALz/qwJy6
         b0P3U1KXb2//p8+ei/R60wnuC7JbH1kj9C9pqLB80J8ApOhe6bsRVLrPMZI2FeHFDT5E
         HtxHn7qerc6x/7WPrsW0kOZhuvmbB0roogY+E6rrzjbQpwMTazHaxfK5/NVXmzXQgN16
         uBbw==
X-Gm-Message-State: AOJu0YxutPBWtfCUQQuUgchVnnYdAO8i7JG+duYg9+tJS2+RnMg/Himu
	FadNMl0XRq4JXVAMHEAcsjE6vzw8pX6NwA3ONGc94+t5zFFBWruIlNXX
X-Gm-Gg: AR+sD1323dOwMxFxYQggCfFTEzegPCSItk611N+C4NXMNyACzEzEQD4w7MSXtSRoVli
	wBjRD0Dok+Y/E9/GbkPpqLKhhkUMUCf6se8J6KGM+k6LNAzSeCY6ebrNbcd/X/ot2Z9XiOLsoWq
	V4/lVS57oHWLY22LrZaz8dJn+rkN0GqWW1C1HKlSqD+OV1J70LWepXzk3IvZm4hecxR5GFqk4Hp
	4/9J6Gn1VI6/2ZRBttvq6z9oxEsKmXInRMKd6UCU4DOTY9Y84cMKQo+TenIz1jgN9oMvbQAJvef
	fedaUq3KiRO5nXmDqcxeihIsMew5zsbf9I+X3wsQ0A9mJ1PK2qQeazAfx4OkqweYvdiEBMeqlPJ
	Nrf16/nkhWXB7HyXdatc0n6nmwZz2QK0qJyqspQsTwRcsIPgYOT3Rmgq65b07gc0RXyhiHQNymA
	RIOx/ELQwi2efY7mQo8f7P
X-Received: by 2002:a05:6a20:1602:b0:3c3:a140:9380 with SMTP id adf61e73a8af0-3c67da110cbmr7404589637.16.1785158376963;
        Mon, 27 Jul 2026 06:19:36 -0700 (PDT)
Received: from spr1.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbbb662329fsm3185355a12.9.2026.07.27.06.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 06:19:36 -0700 (PDT)
From: Hengbin Zhang <uqbarz@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Hengbin Zhang <uqbarz@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>
Subject: [RFC PATCH v2] mm/thp: serialize huge-zero folio state transitions
Date: Mon, 27 Jul 2026 13:18:14 +0000
Message-Id: <20260727131814.3983064-1-uqbarz@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <177a1767-c782-4210-b377-44c520c74619@kernel.org>
References: <177a1767-c782-4210-b377-44c520c74619@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 29D991A0006
X-Rspam-User: 
X-Stat-Signature: bks1ts9azsk3foe5e6ud6e4ybry6mz6k
X-HE-Tag: 1785158378-123846
X-HE-Meta: U2FsdGVkX19ajzQ0s1ljp3LIxYPO8FlX7fPd5rzve4lLzWxkGkxBSZTvqPz9yNYgF05qDkQkLh3DT4a9C9t+Fk6DQ5hs4VwlaSfislA2QZSYpiFC+n0DQqCN2Ye2i1UMLif71iY6ISchDJqOIEEjj2+kI6SZSRWqVAH2KBKQuvDEy8831ZNoTxig2Y7dW+1U6jQrwNFvWyeDDM4/dtWZqZ2qmZCwkYeDG1hyC5XjcyHHBndpn3z3f4wS8m2WMLvSVAx35L9qQ8j0YqH6eDo2Ze7lyax8Cnmg+neN4RZ21d5UOC5d47Bnci1f2ePeq9c7Tz4uSBeaqElec7uoKv3up6l8E/VzVui90ID/NIeUZpzFpRgzIXK+HHBF73c4880ntxE4GXfXwdOw/lvwXxpBPAdj/HcmYAwW82WgdKFIkMwgzmuQ1FWcCPdXKdaj96r3LXTD0H5LWESGWT6oztexqox063jCcKcg/M/Ufd7s9tjxhLvkzCIysb7ka8uUi1iMyqLnkEphks6kU6u4FNNhFZ8yNGbYo308P0Ewx94nae8AoWNSvRp/SzQBdYaEOlQ5qNOO9qexYnD7em0Azum2qTWtpHhXiWmHAB73BFoJkw4LnrxPP5GOC4F1+j9SRGvnuPntGDdc1CNFtxz6gpyUSF2ITEanzLBUD4N036x9BSCirvbC1hLFIGCV6jLGo8DUK3+zbqwxXgi9KQZzKIZqJ1ftkh0TcrF87KixVGaHmCKV/8iIL0bqsmZUIfZjDGZgEP8DomBVrneXBuR7/TYhtr/FWNyy99RWuHIAyyyMraXzlBt77EqN430eHHwUhKKv8zrJCkQl29zmUT1sQxmi6WN/esmh0Ofk8DwOyJUNrcSWwyeOyFgxCg6GksU3sZKIt3LoKaYGtpyKsWA8w74Z1L0rZwFFJ0REyLPT3YB4QboI79dRQiDMwFdIboT7pu2neYe1kzAeNRRI6Qy2L7q
 OvbVzQvs
 /AeOpoE+71oKxG9xH5RhbkYlyKmm7jDCgiC+9n/0tZ3k+uyLc+L2xHamcrlGEJg1xM0PSJklEEI6SX63IUbezRgM4JohuNeVu2dApRSqstlt7PYBdIybf8Vte8yRpc8CaPDy06Io/J59C2t+bsm4ASXyWKwW3j7n/GKqDkOdrMrk9iXPvuTg1WWKrmtm4wQ4NxjyE3+G2aQMDBsGCTV1OaRSu4CuJ5gafD7IYm91D1EGbXZGfS2n7EQx7DimktJ/Oe7+yOvb5w29F5ICl7d3I5bD07FV2g/QCtSFUwL4LpsHZJb2yA7btTa0PyD9l5kbofHE+TjgYQ40KSqcvOwT5Lc9bfSyBQ7kc2PogGqsNTXHrJg32wGA0OS1ZhQWMCz/gDGH60mpVeS14W8ual9hgbOkuHgBNy6S/J5TXmlhkHNG8u2hiRDtRA1VEtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The nonpersistent huge-zero shrinker clears huge_zero_folio and then
invalidates huge_zero_pfn. A concurrent fault can publish a replacement
folio and PFN between those updates, after which the old shrinker
invalidates the replacement generation's PFN identity.

A later partial mprotect() can then misidentify the live special PMD and
enter the ordinary anonymous THP split path.

A writer-side spinlock keeps huge_zero_folio and huge_zero_pfn updates
from different generations together. Lockless getters still use the
refcount fast path. atomic_set_release() publishes an initialized new
generation before a successful atomic_inc_not_zero() can admit a getter
on weakly ordered architectures.

The race was reproduced using test-only instrumentation that widens the
shrinker/allocation window; that instrumentation is not included here.

Suggested-by: David Hildenbrand <david@kernel.org>
Link: https://lore.kernel.org/r/20260724100509.2300200-1-uqbarz@gmail.com
Signed-off-by: Hengbin Zhang <uqbarz@gmail.com>
---
 mm/huge_memory.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b5d1e9d4463d..89771a9b282d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -78,6 +78,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 static bool split_underused_thp = true;
 
 static atomic_t huge_zero_refcount;
+static DEFINE_SPINLOCK(huge_zero_lock);
 struct folio *huge_zero_folio __read_mostly;
 unsigned long huge_zero_pfn __read_mostly = ~0UL;
 unsigned long huge_anon_orders_always __read_mostly;
@@ -237,17 +238,19 @@ static bool get_huge_zero_folio(void)
 	}
 	/* Ensure zero folio won't have large_rmappable flag set. */
 	folio_clear_large_rmappable(zero_folio);
-	preempt_disable();
-	if (cmpxchg(&huge_zero_folio, NULL, zero_folio)) {
-		preempt_enable();
+	spin_lock(&huge_zero_lock);
+	if (READ_ONCE(huge_zero_folio)) {
+		spin_unlock(&huge_zero_lock);
 		folio_put(zero_folio);
 		goto retry;
 	}
 	WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
+	WRITE_ONCE(huge_zero_folio, zero_folio);
+
+	/* Publish the identity before admitting lockless getters. */
+	atomic_set_release(&huge_zero_refcount, 2);
+	spin_unlock(&huge_zero_lock);
 
-	/* We take additional reference here. It will be put back by shrinker */
-	atomic_set(&huge_zero_refcount, 2);
-	preempt_enable();
 	count_vm_event(THP_ZERO_PAGE_ALLOC);
 	return true;
 }
@@ -297,15 +300,22 @@ static unsigned long shrink_huge_zero_folio_count(struct shrinker *shrink,
 static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
 						 struct shrink_control *sc)
 {
-	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
-		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
-		BUG_ON(zero_folio == NULL);
-		WRITE_ONCE(huge_zero_pfn, ~0UL);
-		folio_put(zero_folio);
-		return HPAGE_PMD_NR;
+	struct folio *zero_folio;
+
+	spin_lock(&huge_zero_lock);
+	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) != 1) {
+		spin_unlock(&huge_zero_lock);
+		return 0;
 	}
 
-	return 0;
+	zero_folio = READ_ONCE(huge_zero_folio);
+	BUG_ON(zero_folio == NULL);
+	WRITE_ONCE(huge_zero_pfn, ~0UL);
+	WRITE_ONCE(huge_zero_folio, NULL);
+	spin_unlock(&huge_zero_lock);
+
+	folio_put(zero_folio);
+	return HPAGE_PMD_NR;
 }
 
 static struct shrinker *huge_zero_folio_shrinker;
-- 
2.34.1


