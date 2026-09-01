Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BFBEC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 23:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8C436B009E; Tue,  1 Sep 2026 19:24:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63F86B009F; Tue,  1 Sep 2026 19:24:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97A6E6B00A0; Tue,  1 Sep 2026 19:24:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 65F4A6B009E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:24:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E2773C0562
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:24:55 +0000 (UTC)
X-FDA: 85166775750.26.A38B4A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4621A160006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:24:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VvGWg+Kr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788305094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFw5zgkGnAPMxb67e0R/o6CVVTXZaTWLLe5xe6qm9Ko=;
	b=YtvC+cKLvQoVlOkcicLLWpf/e5RXMwYT9+43enK4nPdIOmwnEge/H2dYW0a0YjZsDoJh1j
	zrMYIjl3nOJqgTA9ssSDNz5sN7VCeGtCCnQlFVGiN6Uj0TgPUbfrT7c/36uuC4RvBaPcTy
	HDpfuTyF+G+Twju6wYy2z9iVrHLdKJE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VvGWg+Kr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788305094;
	b=rBrlGCFxLKwbBLkwsapAWZo+jVRKGBZSVbXz34Mgm6j4MDBodtL4BQ5J8gZR99nq5Fjl5y
	QLjM2rSEEoDlyUTH2As+6s3bjRc2cNA72zznvQ2lkm43pzOM+8hrj4QtVmi8J8dQyhQQAC
	ur7r384r0LvFZ3A973+w6oZSds6NMGM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D0700600D9;
	Tue,  1 Sep 2026 23:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF101F00A3A;
	Tue,  1 Sep 2026 23:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788305093;
	bh=rFw5zgkGnAPMxb67e0R/o6CVVTXZaTWLLe5xe6qm9Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VvGWg+Kr1z5qUex3V5KxKtgW0/4PU1vYOVO5+DIRjj24ddVqGhl+RYfdUxxHg+cqG
	 EApYK3aeTVVouHEmKSMSC0eWou5bakMYTzeWh+g0ef6Z8ugDcA0mjzvy1iYtQ3T+Pl
	 uot1sQMFB01SqK3M5lURJJ/hRhJdKGvsFhcc7rsRDeACQMgz2mCwOwbEFX1L7C7zv0
	 zBSICyyYlu9rcCLwYr40KPXuKB7YNW34TqGG1XPVqOWav2lIe6vNck5ZEEorrTrAYr
	 XPFnyvdwp/cXodcjxVG4G1pZFIkkLOEBICc+UaRVEAopyOZFFm7LbyLjAqGhGa929s
	 11w/MTT2VlsZA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v3 6/7] mm/mglru: move folios from oldest gen to second-oldest gen from head to tail
Date: Wed,  2 Sep 2026 07:24:20 +0800
Message-Id: <20260901232421.40157-7-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260901232421.40157-1-baohua@kernel.org>
References: <20260901232421.40157-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5twn1qwyb8iascr4o14jc5ntuayjhh5b
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4621A160006
X-Rspam-User: 
X-HE-Tag: 1788305094-294368
X-HE-Meta: U2FsdGVkX1/3MlT42oFGIQ8Ln0F6R7UOb5f8m4AKiEw+qBXNz5WgmFPat77kiuRKj35fv6fhEuxnZYRrEQYjiKRW18qSE8I0mdIa8gNDTiXaN7p6Z2YF20uUBxmM3tjl1ggJzeVBsdLt/1vjOJEM4Na/IbA6aNUu0K3BIjkRTXoiPsPN9DwQyhY3T+LnEb0s1/JzYXDb8SEjrP+fOJXGLSAZLINRFUAbtfmtoHU61eDMpYlgTebddKgZ5u3TumIQq9YjQzXZQui0eHMJajEUq3bU26MYe4Oy5PU0NdV339aJ1suXC2+uqFi+BiP8xZmyy9O0A9mx1mTFwCJAoZu7/hLB03pTgwes+z9h3LbDCKfXCcHw/xulbdL5gcb1S3YEz1UukzSWB4N6HubtQmiK9U3YP+ooE9kN9B5+v6q9ohI+csR8QTvPAxE9FcT3a7mImxOSLyvfm0JF7Jp8MHume0o6YiHM49csTbmFklgls0jc1txaz5VeL6LS2ht5PjKtI1Yjp4h28AxLEHprA9Sfhvx7jIuprSAIAB5tljBzYebC/RPmBvU7xvs3zU6sfqY98vMkG7Sy/p2Tyei9jF6mRBiQTVeUZQpE859+d6k3BmW/ovSAD1haviQUpzf+Vf5pj2FuPXsrIJ29TEPnCAQvZ5FUQYqV9Xqwaj1cbWmnK2QkLeX9aviQVBOxyT1ukeUf4RvijeN0VkdTW3BvOHzrWXxKByTd4yk4aRfyn1YwRC+4aWpwM4+wQQ+90SOQnIMrKpuy2A9CF1ipeWrarvIE+fJe99GrLS7JhZhsy5wQD8mKYWI2u/dMpBzqKinUBauEvR31gMk2IzmE8R0jNHlvwgW/GNn/r+dyUQxNu8XmCNnM2I8NWAJqpWaaASwSGASlHAwLzfBhxJ8m6lEQmtK5NjUASAVPsFmouZLtUb2KLWq/5zAREfUfXtLnVp0+b1I+bwVxStuMYh1Gf3Xayle
 hbxTr10V
 XIhIeH7z08rrT13eTwfE46ttDs+ptqgar7FhtMjv4nlRIzWZsXK7xLvYsYcMhjQ9PPEKhYRHfAyml/ZFi3QeF0NmM4jOwb/Jni+1f8pLecwzyGrkL454PwLYN5PRiR5JJxn9CC2z1sC4JR8fYWLaNc0aqN1KYZeC0yz4NqFdIcNOSAsMmvWbQ1QZQMgNiAFaf5zeYdSsWfUzTBfOcICuTDMLDrFlUxlfT8DlOeJgJGT/v3tvEP1iSs+Oy2Q4Pxcbfaw6MkWvmCaofBAXIZlesss6KsKeT/Y1l/arRUDzR7Ww6YhqozFigGNXTUqv2GkIjCVqG+WFqWHgaU6s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For reclamation, it makes sense to reclaim folios from tail to
head, as folios near the head are relatively hot. However, when
moving folios from the oldest generation to the second-oldest
generation, using the tail-to-head order would effectively cause
a cold/hot inversion.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/vmscan.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1907a946840d..76dfa9575852 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -192,11 +192,27 @@ static inline void prefetchw_prev_lru_folio(struct folio *folio,
 		prefetchw(&prev->flags);
 	}
 }
+
+static inline void prefetchw_next_lru_folio(struct folio *folio,
+		struct list_head *base)
+{
+	if (folio->lru.next != base) {
+		struct folio *next;
+
+		next = list_entry(folio->lru.next, struct folio, lru);
+		prefetchw(&next->flags);
+	}
+}
 #else
 static inline void prefetchw_prev_lru_folio(struct folio *folio,
 		struct list_head *base)
 {
 }
+
+static inline void prefetchw_next_lru_folio(struct folio *folio,
+		struct list_head *base)
+{
+}
 #endif
 
 /*
@@ -3938,10 +3954,11 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 	/* prevent cold/hot inversion if the type is evictable */
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
+		struct list_head *pos = head->next;
 		long delta = 0;
 
-		while (!list_empty(head)) {
-			struct folio *folio = lru_to_folio(head);
+		while (pos != head) {
+			struct folio *folio = list_entry(pos, struct folio, lru);
 			long nr_pages = folio_nr_pages(folio);
 			int refs = folio_lru_refs(folio);
 			bool workingset = folio_test_workingset(folio);
@@ -3952,6 +3969,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
+			prefetchw_next_lru_folio(folio, head);
+			pos = pos->next;
 			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
 			/*
 			 * If gen_increased is false, this is a promotion. Put folios
-- 
2.34.1


