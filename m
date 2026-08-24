Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4202C5DF9B
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:25:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD3906B0092; Mon, 24 Aug 2026 08:25:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89156B0095; Mon, 24 Aug 2026 08:25:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9A0F6B0096; Mon, 24 Aug 2026 08:25:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1F36B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:25:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22F58160113
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:25:47 +0000 (UTC)
X-FDA: 85136084334.20.8D0EE5F
Received: from mta0.migadu.com (out-231.mta0.migadu.com [91.218.175.231])
	by imf09.hostedemail.com (Postfix) with ESMTP id 154AA140008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:25:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bz1CRkA1;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787574345;
	b=c0HWw1bPw9joj/nV6cCiR1e33AtN9DAFxyQm7ekFaCU4RAfSKpLIGGvL4J+rKUahlIxyTW
	ymb+hhjHoOBYDe7hMYZVcOg8t/0XVehxYTBGuQFCc34pXRr8bnmKPzmChY/SSvQB0kfzCH
	HCqpmoeschb/SOAbTjOGJ2Yc0scXZZI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bz1CRkA1;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787574345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Gw6+9UdxcoruomJS85a5WnpLvAzerW8BkZsIl1jeUA=;
	b=uEnESu8u98VDBy49EbV2LOmirXmoDFhcX6i0Iyex4r0J8E5fGdluNgfz4cLf2NAyZoL5YL
	mTo4bTf8rLd5Mh5802D9WGklAq39Kr3CD9XZ/EYrHNxcn5A4+oXENPDWDrgVlPKU/m9Zgv
	bhbLl5PJ06xbP3+oji8SOzv5DbMSmwU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bByriFdYljnZ/ThpugvNwdIhIddEfJ2Jmu46aFYPFbo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787574342; v=1; x=1788179142;
 b=Bz1CRkA1jDNaiXfnDlocv3luqDArdg2Si3EgjfUTlLxUeaw7maAmFXS2Lk1UUtX7XjuJfWWW
 GSH1PD+A5LithIRLBwMyUxMV1U60QSsWBjSZRRbcQqmFdlZQkEBPV+0/72xKLOC0dIjCFwQGbKR
 v2qXeUWvVcOWG12hRSUcvHR4=
X-Envelope-To: linux-mm@kvack.org
Received: from fedora (117.129.78.49)
	by smtp.migadu.com with ESMTPS id 47db1fdcc048b7db;
	Mon, 24 Aug 2026 12:25:42 +0000
X-Mizu-Trace-ID: 47db1fdcc048b7db
X-Migadu-Flow: FLOW_OUT
From: Hao Li <hao.li@linux.dev>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [RFC PATCH 1/2] mm/slub: make the case handling in __slab_free() easier to follow
Date: Mon, 24 Aug 2026 20:25:09 +0800
Message-ID: <20260824122513.3829-1-hao.li@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824122004.3652-1-hao.li@linux.dev>
References: <20260824122004.3652-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 154AA140008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 3qi99wtqk9km5gakmpdrhepfsrck58gr
X-HE-Tag: 1787574344-632491
X-HE-Meta: U2FsdGVkX1/72f8r83PokqgtS13CBXHwPVpVJ/+gr0irR67xe+XHtgai66a1BbE+cpqkfxc1eMQPmpoaysND4PAMy2wNg3s6OxpD6/szcgHAv1b60HfKTHQ/AkO1XhcJNE+wD70kGvsPf2XZljs3Q2MmVN6NblDuTjTFkA09aJV6xGl1pG26Oqcnbto0SSoIYosKaXcUu/OqliVJDSAkqmjg9sD8dWDQzxhyIhNxaEtzHagnkX4L6fDhI7MkCkdcQMYLBQnUU1wU6PKoWiu8lmcWNHqWcod0Ia9eCzWevTCVgOGKXxisTVo/iwwKW9j7mP+COB3ML24qCdm88RuftskUgZFtffrXxPjPRj7q97xyudHimhJgzAX7OliCrtsCQsPoS5KV6N4etLV/ZzSYQdfDbIUsDtlsXazbV9bSi0bdBEZrY9wkMTCmcyZamiWT+t8soSZj5rYz8aK9wjfB4h0FoLMNryOS8l8CZiEx0Vku2B7vmoeXv4aDDAX9FGgCzsdR5NfucSz5rAy22SAKbB9MWRUC8re9j4Bp9/RHlfa0WsV4ZRq+7LHypMXe734V36ZYfMkLHDt10y9V/SBheACm+nc5z9KRceIc5XwqPSGxDr8oj0HF8ggIKTrBByaX9KhtSFldsLhCKo//q+Gg5iqheMacGxZRpld9nL2sY+aI1j/fp2nW+6c9roMWEJqmtox2+8Gijz4Ll2LKgZi5mzAI47lRfAUJDkPaa6OqEnf/8X0k4eVzEeKegRljbvS3ValJZepSmLqb3Dhco0RLXtgIAf/xH4SsI5O9Ld5i6e5u+iv2fg2TiazR62u+03D1EC8FjjedAV1O/cAqU0pfwt2VRxS1S8kM42q/qyOTfqFzTaW/LbL0AHoyAbzdXtULdRLKmqozsZJ0gRTsPG9b1S5anA57S0kQMQCcd/ctSxt/YcFoz3wJC+LwZ6999BAXTDMBpNYjIrOBzz3v48Y
 tHJBfNUB
 +x3t7iKOVD2RRs56SmrzeQx3NnB9ABnXaTPWb65pGteADPcljqE3Rhi4sZYWbU3qzC6D+OyxhjllcQ5GnHbGJmsE8cSnyE6rsvuN9Dy83vPneR6CmWSiLeMNvh4A0/YVzr604mfeQnlP1m2qlca2w8v9P1dUtPuGAFQCzYp0v7vF0p549DnnoLNHJI2ip7ZOsqGbEHH4Pu7JahRFmx9RjBDyADsKtpSTfkUhsSe88CW2JpCXF84fALFlxgXodntNI8KnYLjpltJ+nEsl5JTQlxya4wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are 7 possible transitions in __slab_free():

  a. partial->partial
  b. partial->empty, offlist
  c. partial->empty, onlist, exceeding min_partial
  d. partial->empty, onlist, not exceeding min_partial
  e. full->empty, exceeding min_partial
  f. full->empty, not exceeding min_partial
  g. full->partial

(There is no offlist variant of e, f and g as a full slab is on no
list.)

Clarify which case each branch handles, and replace the goto with a
return at the end of the skipped block so that every branch explicitly
states its coverage.

Case 'a' is the only path that needs neither list_lock nor list
handling. Give it an early continue: handling it upfront is much clearer
than forcing every other case into a nested block.

Also, read SL_partial once after the loop right where it is used, rather
than re-reading it on every iteration.

No functional change.

Signed-off-by: Hao Li <hao.li@linux.dev>
---
 mm/slub.c | 95 ++++++++++++++++++++++++++++---------------------------
 1 file changed, 49 insertions(+), 46 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b0cd0572e2f2..e20375307770 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5748,76 +5748,79 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 		new.inuse -= cnt;
 
 		/*
-		 * Might need to be taken off (due to becoming empty) or added
-		 * to (due to not being full anymore) the partial list.
-		 * Unless it's frozen.
+		 * partial->partial: the slab was on the node partial list and
+		 * stays there, so we need no list handling and no list_lock.
+		 *
+		 * Note that continue in a do-while goes on to evaluate the
+		 * condition below, so we do perform the freelist update.
 		 */
-		if (!new.inuse || was_full) {
-
-			n = get_node(s, slab_nid(slab));
-			/*
-			 * Speculatively acquire the list_lock.
-			 * If the cmpxchg does not succeed then we may
-			 * drop the list_lock without any processing.
-			 *
-			 * Otherwise the list_lock will synchronize with
-			 * other processors updating the list of slabs.
-			 */
-			spin_lock_irqsave(&n->list_lock, flags);
+		if (!was_full && new.inuse)
+			continue;
 
-			on_node_partial = slab_test_node_partial(slab);
-		}
+		/*
+		 * The slab might need to be taken off (due to becoming empty)
+		 * or added to (due to not being full anymore) the partial
+		 * list.
+		 *
+		 * Speculatively acquire list_lock before calling cmpxchg(), as
+		 * performing cmpxchg() prior to lock acquisition races with
+		 * concurrent paths, such as the shrinker.
+		 *
+		 * If the cmpxchg does not succeed then we will drop the
+		 * list_lock and retry.
+		 */
+		n = get_node(s, slab_nid(slab));
+		spin_lock_irqsave(&n->list_lock, flags);
 
 	} while (!slab_update_freelist(s, slab, &old, &new, "__slab_free"));
 
 	if (likely(!n)) {
+		/* partial->partial: we didn't take the list_lock */
+		return;
+	}
+
+	on_node_partial = slab_test_node_partial(slab);
+
+	if (!was_full && !on_node_partial) {
 		/*
-		 * We didn't take the list_lock because the slab was already on
-		 * the partial list and will remain there.
+		 * partial->empty, offlist: a bulk refill has taken the slab
+		 * off the partial list and will put it back, so its list
+		 * handling is not ours to do.
 		 */
+		spin_unlock_irqrestore(&n->list_lock, flags);
 		return;
 	}
 
-	/*
-	 * This slab was partially empty but not on the per-node partial list,
-	 * in which case we shouldn't manipulate its list, just return.
-	 */
-	if (!was_full && !on_node_partial) {
+	/* full/partial->empty, exceed: we have enough partial slabs already */
+	if (unlikely(!new.inuse && n->nr_partial >= s->min_partial)) {
+		/* partial->empty, onlist, exceed */
+		if (likely(!was_full)) {
+			remove_partial(n, slab);
+			stat(s, FREE_REMOVE_PARTIAL);
+		}
+		/* full->empty, exceed: it is on no list to remove from */
+
 		spin_unlock_irqrestore(&n->list_lock, flags);
+		stat(s, FREE_SLAB);
+		discard_slab(s, slab);
 		return;
 	}
 
 	/*
-	 * If slab became empty, should we add/keep it on the partial list or we
-	 * have enough?
+	 * At this point, only three cases remain:
+	 *   full->partial
+	 *   full->empty, not exceed
+	 *   partial->empty, onlist, not exceed
 	 */
-	if (unlikely(!new.inuse && n->nr_partial >= s->min_partial))
-		goto slab_empty;
 
-	/*
-	 * Objects left in the slab. If it was not on the partial list before
-	 * then add it.
-	 */
+	/* full->partial; full->empty, not exceed */
 	if (unlikely(was_full)) {
 		add_partial(n, slab, ADD_TO_TAIL);
 		stat(s, FREE_ADD_PARTIAL);
 	}
-	spin_unlock_irqrestore(&n->list_lock, flags);
-	return;
-
-slab_empty:
-	/*
-	 * The slab could have a single object and thus go from full to empty in
-	 * a single free, but more likely it was on the partial list. Remove it.
-	 */
-	if (likely(!was_full)) {
-		remove_partial(n, slab);
-		stat(s, FREE_REMOVE_PARTIAL);
-	}
+	/* partial->empty, onlist, not exceed: it stays where it is */
 
 	spin_unlock_irqrestore(&n->list_lock, flags);
-	stat(s, FREE_SLAB);
-	discard_slab(s, slab);
 }
 
 /*
-- 
2.55.0


