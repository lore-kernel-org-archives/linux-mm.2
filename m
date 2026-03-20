Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23A081099B33
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 115CE6B00D8; Fri, 20 Mar 2026 14:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EF5E6B00D9; Fri, 20 Mar 2026 14:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0046A6B00DA; Fri, 20 Mar 2026 14:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D79AB6B00D8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:24:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A6DA13A78A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:04 +0000 (UTC)
X-FDA: 84567265608.15.E6AD14C
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id D769380010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xrr9caNL;
	spf=pass (imf02.hostedemail.com: domain of 3wZC9aQgKCC4TKMUWKXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3wZC9aQgKCC4TKMUWKXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wEQbyAdpH4wcaIvB7qivO6yBcfRik0FOdijG8dCPMoQ=;
	b=qxPurgAkCSGIs421DO7HJeIXOZqNZz91/6MXNS53biLgcaaBho97kNh3xHkBeQyAZug72F
	wQKRUuWFjYPAZtIuhTvVzJFzgHhYS34GwmpItvWhAtDER2NrTfdyl4YDMG+uei/8aMACFx
	LUUd+YDs6l0g9Ius9KJ3P5y0ODctkD8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031042; a=rsa-sha256;
	cv=none;
	b=Iz2T15zjJUXowVYDVfX9Ci++AJGwmiEyWTWkHBH3Y2IilwdHF4gqUMYi7eeejXzocMZHa1
	7LnadAL+dPmY84HRLuj2V7ZkIjGH1nw3eWJbYUra+XpIiCGbb5DMIjJVoltwEO/O7wEyNi
	QJT5znNUoFn51OBrT2wEo4rsDS8iF+8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xrr9caNL;
	spf=pass (imf02.hostedemail.com: domain of 3wZC9aQgKCC4TKMUWKXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3wZC9aQgKCC4TKMUWKXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4853b474594so24734995e9.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031041; x=1774635841; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wEQbyAdpH4wcaIvB7qivO6yBcfRik0FOdijG8dCPMoQ=;
        b=Xrr9caNLQSj/3FOFMp0hxgBAaJZTqQBLqGiGuNTbpffKV8cySa3xAG37bvT05bx9EF
         dl4185BFmhs1xkGnEi5BEo7zqQDHegoa7Mv2yeRGkQt/HP3rNGeGcdUnmKRtjq5SUZMf
         TB5IV4jZ497/S6CmcgroiLk9SCVXgoPY7UNZ15D4qbLWJAbRtR4alGCirDVrSvZvve3g
         iG2DR+Mnv83DXw675sjVNjORdZ5/4FJFsL1EmPScBvwd6spb4nvlUKuUP8cqVIZ9UG8v
         A9nzXsCo7BDIufrFJTUkN9ZIIvwLz8w1Z3ZkHyJIkPERwNLivZFwz0FbjtOKwhaaf2Z9
         Ayfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031041; x=1774635841;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wEQbyAdpH4wcaIvB7qivO6yBcfRik0FOdijG8dCPMoQ=;
        b=bypBZIn6yAa6Hs3afjLpIYqENU/coYRh0+RHBynwMjsgJ+XMv6QfoFYxAr9dqoYrPn
         qfUFY+VJScN4ewLPWd9oYtMAsyZ/nFysaXr0TxzJi14fBYtEeeSLlkOGYtjO3Lt3i14j
         4OqxI/2KovoiNLf3vLbyCszKSDKZ9w6Urg0eiQfeut2blFpOx/kssB2HiZLdSJsQ+Y41
         8BPOZDWjMidQTA9D4rP9iXWzssHayxJKo79XCQdWND0SEhclrW5sk3Ol9G1hcsNF+DYy
         oIAl81NP0JadnzAfHxRrnItEy/FINdrQfwcS/nWBj7fAoyLbDWx62Ey8RN0B6vN4d6gG
         ilmA==
X-Gm-Message-State: AOJu0YypHhWSojr29gGV3M7zVcEHHkCXKIRvbGMNLH47JULZs51rHNqt
	eErHB3WrA8hSjNv8aZWYAqI02c25WIyyGI1z1oAnfdI41BfdQ5z3daGfP+6AArOxsmM6Fhmt9at
	L2KqVB08s6idMfA==
X-Received: from wmlu26.prod.google.com ([2002:a05:600c:211a:b0:486:f89b:7f29])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3e10:b0:485:3428:774c with SMTP id 5b1f17b1804b1-486fe8b0073mr69538015e9.4.1774031041300;
 Fri, 20 Mar 2026 11:24:01 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:39 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-15-28bf1bd54f41@google.com>
Subject: [PATCH v2 15/22] mm/page_alloc: remove ifdefs from pindex helpers
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: riqhzeitqzfa1z7nf8h8p6i73ou7e1f7
X-Rspam-User: 
X-Rspamd-Queue-Id: D769380010
X-Rspamd-Server: rspam12
X-HE-Tag: 1774031042-951252
X-HE-Meta: U2FsdGVkX19jcl09jIpIN8hIUumZnFOjYfKwlFiBD58BPEnyzBHWhn/By8wzLOFVrRzuEIs/MfWxd3xJc+E68pj77quPGUkoxRoftfNbg5wjkUqPJOSg7JTwvVBSVqYAOQJyNfPRpEnbGmkOtldTj1IHLeFGx/tcXw3TikZ5swieKih7i/LLmA9nkLEjqAZmsDkvxFnU64y/9oCst9E6nG3gHjAj5Lmy6tLC2rtL5UNu6GHaJB+KTOsuyry58AM8JhdV2pU9S746pYXgOUg92C1uRb0eWnDe1WLj9S3bxQ7tXRJha2JIdqy88fd1pu/PUaUMqLOchCMBnQdX62KKr4dbPHuP7Lj6hJGWl3Simh+8yJjWg0xdfeKt5zCoyO5RR9UP6hMbYbgFspCaFJhag9b0lc95FE7tlknQuaU2qWF3QPGvmHzF0H0IxowXrz9LIZ9ANgPsFVd1Wq4SdWQnrIzN91CHxoF9eDE9adlEiyJK9s1fx4WRAQ2IeyipYNiCkFQ8Ep3dAkFrHwWbuGLDotDgPVrI3dujIHR6Bp7UGgIpBegnFvvDj+MLu64x7zVNSja2RtMWFpd8TQKMgGRxB7lcV/kvJgiMLLaKEhjAaYydc4m4yxfQRLBAZ3Z0B9wO+Wn4N8RJB1nqpKoZlO7punQBuK2BSV3UedN7IcOosLi3aXFSJaQrmAxYs+UtvVJVucCUL2eP/OGALr0FK4KMz8z5VmmxaLPnqkqvolKt3Pk9HyudwoVHoUepruZAgUTFxZva/21G0voLibROH6GiLg8ifE8EKjfJyzfiYFlGuXqP7kZ/ZN5ePWDQ5Vn4wblulo37I7sSkoUzQyEtjxCav75sZ/XtsnB9RzonWK74Dt/N7/nC+yc+eh6Y63OroKUWGp5fKmpTVZ5t93wIafu9TOJmxCfI9xjmxLqtLsp5ivtElk3WAIbZM4emyWJgldJlO9GsrXt4TZnkeZg8Bfm
 J8qd9208
 fF6eBKyx5S75ndPluVqDcT7E++bHPUfqQXC7E+U2pegOhrbn7C95Q7ox3jccQ6skQVOUhtb40jCvDdUXv0oR000+16eZAclswNXTavXMm8PaBWT1azmIZRaL9qiPt9ZRXstEJcQ2gjgvQyE893J6Zi1WWwIK2f49IXpK/4zOwNUL4GNmdop3tD7ud/Ab/AkCVPswD9vEl1m23F0lmhe3hZ2cezepX/JfKg/OmfcZ13p0ttwd974YIhrcJOBUWAFHN68KKhgB/Jxvi7NPFYJI3NX5ukPMC+qvg3QGMX5R/G4f7V9tyvkyHb04BVAWlp9hmNDeS8FQhI2e7h4PEJz8jVijj1SfHAARwNS5+UOH4iv0Bw6h3MdG29efbrszQuDc/juickNtyH73tSE2Yg+g/iDe6as8cFYr7jEsAHQBeMqcbDbbeS4stf+XrQiFQqVyBQsy3RHa2F1NUjczKT51pLqL+3vobO4+Cb+fpIaOeyRkRdO16qD5JZ7m+shhJk0wttXBBbjlQPj5Zz++SsJ8qZOsah/QIAcf9N0r8Zd4ANBmLqApcc08E6GIRJLhW3KEeYmO94riLHb6V8filMwh9t+qkSikAK2jXZb91JscZirrvgFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ifdefs are not technically needed here, everything used here is
always defined.

They aren't doing much harm right now but a following patch will
complicate these functions. Switching to IS_ENABLED() makes the code a
bit less tiresome to read.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 994ddcb132aed..f125eae790f73 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -696,19 +696,17 @@ static void bad_page(struct page *page, const char *reason)
 
 static inline unsigned int order_to_pindex(int migratetype, int order)
 {
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		bool movable = migratetype == MIGRATE_MOVABLE;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	bool movable;
-	if (order > PAGE_ALLOC_COSTLY_ORDER) {
-		VM_BUG_ON(!is_pmd_order(order));
+		if (order > PAGE_ALLOC_COSTLY_ORDER) {
+			VM_BUG_ON(!is_pmd_order(order));
 
-		movable = migratetype == MIGRATE_MOVABLE;
-
-		return NR_LOWORDER_PCP_LISTS + movable;
+			return NR_LOWORDER_PCP_LISTS + movable;
+		}
+	} else {
+		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
 	}
-#else
-	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
-#endif
 
 	return (MIGRATE_PCPTYPES * order) + migratetype;
 }
@@ -717,12 +715,12 @@ static inline int pindex_to_order(unsigned int pindex)
 {
 	int order = pindex / MIGRATE_PCPTYPES;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pindex >= NR_LOWORDER_PCP_LISTS)
-		order = HPAGE_PMD_ORDER;
-#else
-	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
-#endif
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		if (pindex >= NR_LOWORDER_PCP_LISTS)
+			order = HPAGE_PMD_ORDER;
+	} else {
+		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
+	}
 
 	return order;
 }

-- 
2.51.2


