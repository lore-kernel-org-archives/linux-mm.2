Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 262F1FD8FF4
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 18:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C04BD6B0168; Thu, 26 Feb 2026 13:26:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAFBA6B016C; Thu, 26 Feb 2026 13:26:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6F4A6B0172; Thu, 26 Feb 2026 13:26:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 861D36B0168
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:26:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3AE8216032B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:26:59 +0000 (UTC)
X-FDA: 84487439358.19.328E4BF
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf15.hostedemail.com (Postfix) with ESMTP id 42010A0019
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:26:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=ROUBdTKd;
	spf=pass (imf15.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772130417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXRtBBG/qhw0slRma85SDcDIachKM+DkOh/vjMaFIu0=;
	b=73BSBMEkAl/co73vKyxRIv2krhdNGd7nf19a2csCS5LYROL9v2XhQx6XqCZYLztD85gEag
	YPGD2dgJjTRs5mLXiUHk8lZpOn5MoCRaGokfnnMhdb4WZoHDKD3ndRknzqiW/ad2XebPvW
	rIWItcn9u8LNHI1lHC6Gk0Q2NlAHuhw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=ROUBdTKd;
	spf=pass (imf15.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772130417; a=rsa-sha256;
	cv=none;
	b=uKh4d8V+014RQXZiieBLWdxLKgXWJ7FwZhsVyyzyBtyq0A4Z0sfevaB1Sw4X9HO7yuVfm8
	pZuE/SMdAxDYtRnFcfTkW7bu5mJqauWh+PH81xRVeWIeLWJYnA4NvDPsrtzkXqxMwfXkam
	VXRpzMP8Zq4vLFB0StAxt+vB92LQ6vE=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 5976EB2CE3;
	Thu, 26 Feb 2026 18:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772130415;
	bh=HXRtBBG/qhw0slRma85SDcDIachKM+DkOh/vjMaFIu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ROUBdTKdAI2asAnZVnKs+ciEM4SjsPZwqQLfD3v+GHvBhTDiiyYhMHaeCQQlPHtGm
	 r0tsUeUHrtF5h6G3bZpEsfJzcCPyjb6Kg4sfxcrRsh3ZZEaWw/uzEW6WdzhQ+QChFR
	 LthCPlRh1pASvysPqMKh34FyuhkEaC+fnjdWT5c8=
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
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v3 3/5] mm: convert compaction to zone lock wrappers
Date: Thu, 26 Feb 2026 18:26:20 +0000
Message-ID: <01729baf359e4c6612aead53f1fcb644f782d1de.1772129168.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772129168.git.d@ilvokhin.com>
References: <cover.1772129168.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 42010A0019
X-Stat-Signature: ntboofwzqcuo7itsjthdyggfpkdrhi84
X-Rspam-User: 
X-HE-Tag: 1772130417-955849
X-HE-Meta: U2FsdGVkX18y8mruzIcTlwSNzuHgn3pXbB80eJ2FgBEBqgSuMeznggxNF7gffdgI66fxmOJO2fA43YC/Q5n88fYDplG3UqVAF8HHF7MqZyzKpte9g83YRHA8oBf0V1ZoQuP70LFi6O9wjbcvILuLL1qJj4s0dT4Li1TcrHtUPHmL+og/MtxF1c+iGpDqSbkNxRbIl66vjh3orHadAitKhGOj/BJrgHCRqG921pPFXGtzvnElbILsvMi2JoH5eCpFCiVHpgKSYn2UWXaxcwzFc3MzJPCZGwZHwQgpUMWClYFqRZ4xXvVAhQCyYs8EGrXNIWIOmB2lTuPlmqX3dJ7EYN4TYdOZ8o99x1Q3EaRuulprLfelWClPleRHaIw98NFA6CYrywaP1fb0NArSIDs2OKOvVAAp/+ASkj/eTy3UVEPusw9Tl7n6/hBc+whV9vj45vcJrjsdeHKYX1YbPZU/8dLNgWHsajp6sTPhLQd/4/+yN2COIMsIY5PcyKxSmthVeEQ+RAodwnpom/Cv7qLWw+p6w1F7MHUqBsQR17iQD+/HcAbc7MBNpImRbaCKitl+I4QEAt2yueVs8ZFU1hzvcIZAJ5rrMMCkJicBJd1dIrf6nBa3TQLZZ6BsEpoHD3xPXDXrHloUTx9GyXGvUuM1HUxk/IHTkGjsMWsxPlOMCSjjSxjUGZm+Tfj7Ew9GtvvXOw9I0h+crPwuZmFVaMDSXetdYPuEWVI4geLuoZ2saoiY8Yk4hvhy2T4RkIHrc1L5x0R8og/FYQ5/4UHUvf0nehziviB6BrMq7w0IzzuMD1+BgE28e2HVkOiIrgasI50V0rQIEhpzS5oJzatonaZsIvDKfrNh/WyOC8r9vCiOPoE2wgkjSA/hNWPMS4JnoS62o715ZBz9b7ylef1Zz6CDlAKos8ZYfHWy8UAkY8lNdbwHUhqoPlcY029hCr6xSJ4k2EiPHYglWfuIjmDrI/C
 kECjmWv/
 DiGwDQuUb/znUCwFEZRDFwqEVZuE0kH600XmNzt/edjdiAMtxBXqpivuSDmiNfmVEARXii5dIjNM00r/haJeh2R+OtI9a3UTn6lS0FiuSvqnKPZc2GXlvszCAWRjTvVuqtVlgxFjNnlac5B23OWQ3Bg9d7Y5M82u/dnzMl1rpjurpI744Lt0rg5d+hK8sOq12blgFNXLABN6Mp6eMCnCtK3oL/WaoWHKSXDdrln+ORUg8XsNIMgM+EYL/pQ==
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
---
 mm/compaction.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 47b26187a5df..9f7997e827bd 100644
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
+__acquires(&zone->lock)
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
+__acquires(&lruvec->lru_lock)
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


