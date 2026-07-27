Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E73DFC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE5FF6B00CC; Mon, 27 Jul 2026 11:40:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70136B00D3; Mon, 27 Jul 2026 11:40:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A39D66B00D5; Mon, 27 Jul 2026 11:40:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7236B00CC
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:40:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0046E80550
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:40:37 +0000 (UTC)
X-FDA: 85034968914.11.E161B79
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2845A1C0012
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:40:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NwiR0vK7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of uqbarz@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=uqbarz@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785166836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZNNFqmiKhCxMpepdTGRnKCzuc4JoIea+/gUgOwbSgQ=;
	b=DO4Ms36XpI3kUyTw1mNAU5Na/OXZhnl8lMq47rZpcuGzw0/IrU36PxYDumPhbdDNVMWnLZ
	HJQNCBVjTKmPpxfFvUBqgz+TBWc04fMtb7DM0omG0xcGn3d8gxY4g0fJZUvUf56XG3vXEa
	tSc4lnPytDXZ8A0dufPYbQJ49mBIfkw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NwiR0vK7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of uqbarz@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=uqbarz@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785166836;
	b=m7igoeAHqH5mYHvjfT/+5YDx7sQ8gT1FAvje7Az8wIOB5whtyIYFSU169QgsCMQAohSREb
	aLUgnhNC0WrELYn/WXPRljW0fJ5FfWFvKOiIdYNTRwoLBmCw7yb6e2owZ6nC43QM8cK9MU
	cMILTX48JwFKEyD7427d7KB6/YcIpw0=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84e27035206so2830444b3a.3
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785166835; x=1785771635; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oZNNFqmiKhCxMpepdTGRnKCzuc4JoIea+/gUgOwbSgQ=;
        b=NwiR0vK7DT3ABqTnaP7SD1tOjaNYTQjM4Iwa8AcmD7IXEIJs3BHmBiKJhxrUJqlUSL
         SJ8JKu3Y+L0TvGFzG/GeheVC1vpDWGpU0AcdQ1q7TbFspk+MODDkqBtMZBEeVkXOIK06
         S3Lihd2h1KS2SJK5HTzYVw1wBPFc+SD97801qA6aumpfXFD5LjrP/jyOktczMAYCmDp3
         aaOgOphJHsodvvbfFRI7vwrn2Ar5if4GUt597ixMNph6vKIklhfAgB/3ZBokViYvGLrt
         vTeTOAUXo2dLqsE9Qk2TycMxSRsQIhcuyzCvJoqIPb+yBEFCpSEgVnoS/E136SM1FoRQ
         OIgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785166835; x=1785771635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oZNNFqmiKhCxMpepdTGRnKCzuc4JoIea+/gUgOwbSgQ=;
        b=fHlFarpciYTVEA5XNzJTuTgNk2LEc4xDXjuAy2reGfWtVY6jDHBiLN9mf8HLntY+Ws
         8nQu/R+vwlrGpuIasUcjqFIX1040wi8ctHhiCq9rBq87Gxl50ep2UCRq4YnhIYbaOVrf
         mvOBAnCE6Ff9xLz1fNg/+kl/8IhUMx2mGx05gH2B/lgSIt8ve0ssmLXJc/tZtlCvaxQZ
         2CpZchhGL7K9/UyVLNc/2Dvq3m+qlHsWf/koaP4AkYpTiaRmfGJGshYdYkDJcXFYE15U
         EaKLnqEniDwLElB1MPUqVh+cAIHht4FagSNZE/4QmgihQ/cobAiaHDNbU1pafvS6febG
         5jCA==
X-Gm-Message-State: AOJu0YxMTNSp8hCapdep0erLDh/gGHHLWwGYHPsMqNQ30CDZUVfXa60N
	H2VRyXdAq6ZiId2FakTWL7w9LWRpeA7LjpVDrvjBtBOUDj0zTaZ7E9Lq
X-Gm-Gg: AR+sD113AoOKZAY8H+4MhFIK81KglZH0LIEX1LzcXkArgZOgHqNQLsRnFSCIScbLO1i
	tVaEmqk28w0BlEd/eVTyAV4v6CaNLwrBq/U4dGCsnwwXT8BrfpW8g3L6j8fGbYiyXhrtxWvQG7v
	qdQTUSaN2rHgVdQ5ASEJtb8ZYZDR2QOWaMY8pvhvm3ResehW79y3iwk/+q/sIXYRwGFeUt6gqrc
	RFye25/2QWa/NMufWetc2CqvQwbvKvWyHBVyC743Yit7orWQkrYLVcWd3lfqYALfC24BsvGae5Q
	ePlYS0+CjYCZ7MM3duehwwwpOQjlgLVqDJ3/du38vMT8LThLERo2rMTNULZclU4XRqvsypSjcpa
	F2Obtv9Kz6jyTk07N4TD+Hev3pUSWHdbrbDJXiu95/JZ42QKqMM9jMKb5zit3HOEvxVe2PKWqJ7
	N7tNOFZSckE938bdXRlamF
X-Received: by 2002:a05:6a00:3393:b0:845:40d1:87fa with SMTP id d2e1a72fcca58-84e8cf89b3amr16485b3a.25.1785166834932;
        Mon, 27 Jul 2026 08:40:34 -0700 (PDT)
Received: from spr1.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e5327f3fbsm3332996b3a.19.2026.07.27.08.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 08:40:34 -0700 (PDT)
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
Subject: [RFC PATCH v3] mm/thp: serialize huge-zero folio state transitions
Date: Mon, 27 Jul 2026 15:40:01 +0000
Message-Id: <20260727154001.4102341-1-uqbarz@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <4146d4f5-c8fb-42cf-9dc8-a9d4c26055da@kernel.org>
References: <4146d4f5-c8fb-42cf-9dc8-a9d4c26055da@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2845A1C0012
X-Rspam-User: 
X-Stat-Signature: otxotrupg9jfni9ummym614q384ih9kr
X-HE-Tag: 1785166835-311050
X-HE-Meta: U2FsdGVkX18e+PYwy8fUj0jGbV+So4Nlgqc+wrxPdoBB3Ln3CKYV34IkRuXcMpRJRQJDrnd1DTbiKG6noNHUitv7uKHgrytY0iagwfbxb8UIv6m5qoS6+ukhRByY2L4+8X1UG4LYo9+8ufwG+lCgqnKSM65siyj8XWS6xKAhe6vKODvWQmg978mXbToXiutIa9pH1h+qSyCSGUX3XlFnmUiXockwWNozp1p9Qqu5ln6Ra5AtgU+9jip28ssSronAUxkpLRuesha4giM2I3g/yDWBcZaXWbt/l/uNZ+is0DQE5rJU7/0JYVoG0KqD+/Wy+scOXzY+hhSNpdJ8PQSkvKnPAWaF+U13XX7i108tEv9dTEakuxrQ7q+6fVlYMH7ESLRzHujUz+sdh8+hZsLEQrf/VRkfmg0/kp6jMC5hTa7Yqw6Tvdup3CX6wx/QNZm9R7HDDRrBtDSAYfjSAOzLnHx0mSPrwBp1jZ0HdBXCgXRcfAlHukRDY5/DKtHM+4WAIUz9LnFn6eABLazNQkWkmZop1Mq3ya+2tCGiIQfy9dD6GZVR0ntO9S+bOakDk84NomwfelXIWo2alpevxN0TCv6wB0kGJJ501bA8J6W8iUeIOvUp9qeLt5tv9lqxFudbmhNSIMAZWfhS/LC1r1QN2Vu/mccWK6T4hX11xsy9YoudMNi7QLiSH/AxLhoRBnb80XRNC9+zZY6weMtqLOh9yqgxMF+UoMV8WGZzRWLQCW9ltqhSIoEU0Kxs4OzzAwJJVql/TD+cF+/glsBBo6Y2HP1mOhWgdodCOy/t9F/agC16gREsDJ7PhfflFpvAZHUYTswNtzacZKxAPY514UAoODyNEfDVfInOOeeDSq24V8zZq1Ga+rDSffYDYjIf1uoT+asbwLoqIJQpt83OPTLGwa8R+x75D4UrPihWAuBFASy59yAUk9m0FXFQbdOieD5UJlCcYaXhJqaF+s8NdaQ
 YX6Qm8oI
 vOn2oYBRXVOHm/Rafbf4HHlwboyf8UOZHVeQEPgk7aQIVXm3tXyl1gtDodaVEyNyeyQnYP6HA0C2THaQ+QJpYRp3kPVt1Dile7PdTc1mY5u1+CtxXOtHu+u4Syw57JUD6e6/JvIOZ44IkMSVpjWguAS9b+ibVIFCTU8jyYWmyPsHXVApZw+YlS/SY1zfROAJMInCjcFrnxrn5BJyra13keVn4Lsm2659mkmSNStx2YYj9CSCsqXNHI141gDtkoLpiRsFQXA6tSRGHTjaHpnAaKQEIalbui51yvQA0/3pQIXFwUwt8r4pgCt21CqgZNRU7lM+KsGFpLIfXGHkSjb8xGlr5FpM5FuXKPTfBLVxUG/j+LBMvTsEhIurycmW3AcQgTu+9pRbxhpTl6+HC6buNSl6Cgq3SUxH+q5iApL8WR2avWph1obR9FqIasQ==
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

Suggested-by: David Hildenbrand <david@kernel.org>
Link: https://lore.kernel.org/r/20260724100509.2300200-1-uqbarz@gmail.com
Signed-off-by: Hengbin Zhang <uqbarz@gmail.com>
---
 mm/huge_memory.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b5d1e9d4463d..79bec4495540 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -78,6 +78,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 static bool split_underused_thp = true;
 
 static atomic_t huge_zero_refcount;
+static DEFINE_SPINLOCK(huge_zero_lock);
 struct folio *huge_zero_folio __read_mostly;
 unsigned long huge_zero_pfn __read_mostly = ~0UL;
 unsigned long huge_anon_orders_always __read_mostly;
@@ -237,17 +238,18 @@ static bool get_huge_zero_folio(void)
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
+	spin_unlock(&huge_zero_lock);
 
-	/* We take additional reference here. It will be put back by shrinker */
-	atomic_set(&huge_zero_refcount, 2);
-	preempt_enable();
+	/* Publish the identity before admitting lockless getters. */
+	atomic_set_release(&huge_zero_refcount, 2);
 	count_vm_event(THP_ZERO_PAGE_ALLOC);
 	return true;
 }
@@ -298,9 +300,15 @@ static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
 						 struct shrink_control *sc)
 {
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
-		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
+		struct folio *zero_folio;
+
+		spin_lock(&huge_zero_lock);
+		zero_folio = READ_ONCE(huge_zero_folio);
 		BUG_ON(zero_folio == NULL);
 		WRITE_ONCE(huge_zero_pfn, ~0UL);
+		WRITE_ONCE(huge_zero_folio, NULL);
+		spin_unlock(&huge_zero_lock);
+
 		folio_put(zero_folio);
 		return HPAGE_PMD_NR;
 	}
-- 
2.34.1


