Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDFF8FEFB6A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 16:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1B966B0089; Fri, 27 Feb 2026 11:01:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFD466B008A; Fri, 27 Feb 2026 11:01:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FC8E6B008C; Fri, 27 Feb 2026 11:01:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 895466B0089
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:01:17 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA616140761
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:01:16 +0000 (UTC)
X-FDA: 84490700952.17.C9CF77D
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf06.hostedemail.com (Postfix) with ESMTP id 23A10180012
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:01:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Ads08GM4;
	spf=pass (imf06.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772208075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=724OnEo1UU3p7rmjBisDMAoZBikcU2JAJeLCaC7K+74=;
	b=1cfqvzBd4WJYZAlen/KM+BhN2OMUCEMpv0E7u2OIAfY+t9jtdbFitd0+Fz5V1xCfAZ+lWm
	3mh+hXeAM6FFDLXyqVOT5cDs3vN6MKXcVe+9pNiZ1yidH9SENoWBGjVHECu9DVMPs8XrX8
	3ktT2g+0H70s22GAIOf435oPNEEqCzU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Ads08GM4;
	spf=pass (imf06.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772208075; a=rsa-sha256;
	cv=none;
	b=h6FQbMNy8FpunfimX75QxH0F9kQQ9bfZkd81ESbS1vDr8guiipJeoc62FwN08fOQxlrtr5
	ubhNnpBrzHcUrT2+gBxUbFno6REdQrzTy7UUbDQm+7csPw97DaQxHsDZIEa8Ni9BTqKPHQ
	EtVbdaflPrDfCopSzudy/lHRWbtjZZw=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 0585FB2E3D;
	Fri, 27 Feb 2026 16:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772208073;
	bh=724OnEo1UU3p7rmjBisDMAoZBikcU2JAJeLCaC7K+74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ads08GM4QklHSYJg9JjAkfvClZh1PdL7s1Zom5IVbi5MR2IUz7x39vX+WPonpa2do
	 XymKHWAACKH16MY+O509a/c3myOo4i3GuMdw9XDKAiX5qogH4UEqNnyozv41v0vvnE
	 zeRCXUuEUfFmCsPcLUnZPIpqjCuzwWNEy/rtSlrE=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	"linux-cxl@vger.kernel.orgkernel-team"@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v4 3/5] mm: convert compaction to zone lock wrappers
Date: Fri, 27 Feb 2026 16:00:25 +0000
Message-ID: <3a09e46f52cf9f709b0725bc2b648cc5212843b2.1772206930.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772206930.git.d@ilvokhin.com>
References: <cover.1772206930.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 23A10180012
X-Rspamd-Server: rspam08
X-Stat-Signature: seiw41wn3cy4t6gd775gtw3wj6i4xt8w
X-HE-Tag: 1772208074-241092
X-HE-Meta: U2FsdGVkX1/8yRGxP3DdLvFk1Lg2Ui7X32pNqU0b6LaGkr8oxH8MOtCHjZZV4w9B3rI3OYDSdlZEqM/3xQflB1E37fPqyLcrORLy5+H/C1kU8YlxSXkebyJ2Ba7fa8oohP9l8sEv5ud3NDJZvpRTk3bUPludDex3cMZ/6MrhwaeT/qruXHtU3ykTh9oodipWWwatOrBbox0cZyVCNW5VlAn3pSe/hA6rlMsZRHx/o6HTnq8NM3J7q1wpceFZuoQIP8CQ83iPJAArlVRcKfSxk43ADAyVQ6gqPyiI9wap0cAHYZcSw5P0wzRQHfVZSR5StVfkoJIc/BD8/luSmQiocEBIfAiYzpQpd8pAJKdiqcAhYLNnW2dl4G46Fbpk+DeVMAyfIdwuVVlmltGCwfICbb7tElMHmBjbaLNh08isSfYcbGsahlyAo44kerv8m8MUQ4rQ4uF5ZZx38LbHxt7aA9WeTL0D0flckDShW36zc5iAPSqk1lDyYBIQq17kn/U8LOXCqW7PMMaNia1gfZAMd7GjSaUtRQQH9WynPscHBQlOLD8Tsi2NHIdHyF0q2Dtlc1QaW8DdhqyEUSqrYVvwx8CyhkmxinD6Ndr2504OaBXJSAveXsq1xa7QYEWgd92EUCMzvzZHaw26k2pI1MiWae7D+AK1nVvJmBcEAk5ww9vuQ/Tkj2GiEhpCZFYs7FT33fCrbvvLlxTdGr4KCaMTKSU4N4hpP2WPwp5GvXRUg9TnRUkssKS2boceBKr+sPPDw3i47vStrZx7jJADeMFAA90Iha4lifqI/Zaxq+FEbID0jnQ+UUaVnh1hCmKwuidkVT+xip5lHSo4XJHA6WPIpxMaoKHMq5vRuYflGJTud3/DUQtew7uh/ZltCCZTR4ScHyT8v8Nk71KclS7F/q+MEVHP9TyRCtx51ETIrRBLE/MY7u4FNUIB9XHqlQ3taeNytjMmQtBbGLBFTh7XpGo
 uySLvzrn
 YpH78UUbikpJG/TMh+WEjk76FNtTFPRbpLaxFrKbf7gIg3ZdbxlJZEJ60VTHgKo9l9MEJ2ESJuwqih+c/YoZ1JXbcoSEIgEkiegFvgi9zth/VA+KohfKvf+UtZwMDGtyBMuvyT6us0HFbUDE4bXBQ5+vXA6ywwSo5Dl1ySSEGWYk8BsDgIDRq+4LIsVJQ7cJOjUkrAEvaLAXPBborw4guHSiwnwnCF0R8Qha53wcpzxPyJSkd1/aysc73SQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Compaction uses compact_lock_irqsave(), which currently operates
on a raw spinlock_t pointer so it can be used for both zone->lock
and lruvec->lru_lock. Since zone lock operations are now wrapped,
compact_lock_irqsave() can no longer directly operate on a
spinlock_t when the lock belongs to a zone.

Split the helper into compact_zone_lock_irqsave() and
compact_lruvec_lock_irqsave(), duplicating the small amount of
shared logic. As there are only two call sites and both statically
know the lock type, this avoids introducing additional abstraction
or runtime dispatch in the compaction path.

No functional change intended.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/compaction.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index fa0e332a8a92..c68fcc416fc7 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -503,19 +503,36 @@ static bool test_and_set_skip(struct compact_control *cc, struct page *page)
  *
  * Always returns true which makes it easier to track lock state in callers.
  */
-static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
-						struct compact_control *cc)
-	__acquires(lock)
+static bool compact_zone_lock_irqsave(struct zone *zone,
+				      unsigned long *flags,
+				      struct compact_control *cc)
+	__acquires(&zone->lock)
 {
 	/* Track if the lock is contended in async mode */
 	if (cc->mode == MIGRATE_ASYNC && !cc->contended) {
-		if (spin_trylock_irqsave(lock, *flags))
+		if (zone_trylock_irqsave(zone, *flags))
 			return true;
 
 		cc->contended = true;
 	}
 
-	spin_lock_irqsave(lock, *flags);
+	zone_lock_irqsave(zone, *flags);
+	return true;
+}
+
+static bool compact_lruvec_lock_irqsave(struct lruvec *lruvec,
+					unsigned long *flags,
+					struct compact_control *cc)
+	__acquires(&lruvec->lru_lock)
+{
+	if (cc->mode == MIGRATE_ASYNC && !cc->contended) {
+		if (spin_trylock_irqsave(&lruvec->lru_lock, *flags))
+			return true;
+
+		cc->contended = true;
+	}
+
+	spin_lock_irqsave(&lruvec->lru_lock, *flags);
 	return true;
 }
 
@@ -531,7 +548,6 @@ static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
  * Returns true if compaction should abort due to fatal signal pending.
  * Returns false when compaction can continue.
  */
-
 static bool compact_unlock_should_abort(struct zone *zone,
 					unsigned long flags,
 					bool *locked,
@@ -616,8 +632,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 
 		/* If we already hold the lock, we can skip some rechecking. */
 		if (!locked) {
-			locked = compact_lock_irqsave(&cc->zone->lock,
-								&flags, cc);
+			locked = compact_zone_lock_irqsave(cc->zone, &flags, cc);
 
 			/* Recheck this is a buddy page under lock */
 			if (!PageBuddy(page))
@@ -1163,7 +1178,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 			if (locked)
 				unlock_page_lruvec_irqrestore(locked, flags);
 
-			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
+			compact_lruvec_lock_irqsave(lruvec, &flags, cc);
 			locked = lruvec;
 
 			lruvec_memcg_debug(lruvec, folio);
-- 
2.47.3


