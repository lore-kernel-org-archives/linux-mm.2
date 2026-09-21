Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B4EDC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:55:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22F4E6B00DB; Mon, 21 Sep 2026 08:55:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B9C36B00DD; Mon, 21 Sep 2026 08:55:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0136B00DF; Mon, 21 Sep 2026 08:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF7E66B00DB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:55:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 352401A0165
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:55:14 +0000 (UTC)
X-FDA: 85237764948.04.94AA72D
Received: from mta1.migadu.com (out-190.mta1.migadu.com [95.215.58.190])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3783D180005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:55:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ypq628FR;
	spf=pass (imf24.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.190 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789995312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gctxgDY+X3px/vL6qisaP2MEyrIZsb3j26W4aNz8iwg=;
	b=3SW5cawSqn3F2iimgIR58WCsAcRZ+/xbDGs4iyaapDDdWmr3Rd0ZxMFiDGCH1YBqr/fE3C
	+uexgBthbG8J2hwJSu87wufJivJyjRgn/hEzU0N1j4BjDe7u+RanxUNkZ7HdTrWpCwR1MT
	zLk2JeaxVbV1c/HlnEjBAG+zBJWAEMk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ypq628FR;
	spf=pass (imf24.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.190 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789995312;
	b=R+8d0ZKkwSJtx9e0gKwSd3XDx6gGV4vO4zsyWL5yAcrbA7T7QGbbowcxTgrZoZOBTbj6eu
	6hJjwAm4pnIHQZqE4Tv3g3XHNXalzHrCYl5g5QC8pYgUyvlt80Dyn6GjgYP6wGtomj/yGG
	tsQMj1a03bWiTzZ6Tpm5WnlO6BDuGRk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rgUPJLDIrF/y+IKscmXbwuCMcRf8kaxaT8pd8fmezLw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789995310; v=1; x=1790600110;
 b=Ypq628FR/xaaDBp1Xc+I0WGx8inWuXa83HghVIVnhj3N7rHD4XQdoVJ/Sb0MfZ6rUmWPJ4Zi
 ZYSauhMu+EPAWct6WPLhOb6yAYU/zOTsqPhvD2zZjVxvzwd5/u0Kp1SbUPV5ckrvXZxNcf1Uz9d
 TF11mr9/7L2/D/3kv2dOtZRo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b9b60e85b785a8f7;
	Mon, 21 Sep 2026 12:55:06 +0000
X-Mizu-Trace-ID: b9b60e85b785a8f7
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
Subject: [PATCH v2] mm/slub: make the case handling in __slab_free() easier to follow
Date: Mon, 21 Sep 2026 20:43:22 +0800
Message-ID: <20260921125421.142452-1-hao.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jti9n9abpsgt9psccuhijodzjewiaure
X-Rspamd-Queue-Id: 3783D180005
X-Rspamd-Server: rspam07
X-HE-Tag: 1789995312-692058
X-HE-Meta: U2FsdGVkX18yBj4byWvOrUbDiDXQ1ghWL/WlTZ9jxrEcmKyuqgnRAVqH6U18V/cvJzUFgU4CVcDhX+lOFshWT3vDFvImAeh8LCcWNfn4qOlI1fnDut2in89Y7DMeZWge6nj1S5M10IWh7PDaMDZBtFT+7vxRlF5AmlgALF+9yoiIMu224CQZWDeanW2rp4uFeeIiWxs9HN7SI0Ar7OEuQIWE66Iv2K4YrAZnG3sRLGqMQKKkzEtStMnwPWhIcbT2QXF43SVyW82zQH6+vxpyd8dMuG3V3B223qEwIi9U0puZJfDrXgrenhs8vwj2Z5kN/CkkNpCrvXUpQodXwx89PDAQvFYcB4V08Y7kwB+v3hVqR6xIyGsNp7K39PweQxYqRFxJL6fXD5ezxlBC0RJksKplKqeUBsXnqyaMTgacGGjwM+LbMAN5g/ZW3Cz5KpYdVmRFelzWGuxH78IzSCfP5ruGwmEWqu0jNwfUFVElM0RL9Kl0nVyD727Uf+GoNLFJDUN+5HqWkTEUuC0ZDgS8lZgLJhyoN3kWDf/PCiptlqIFH5vpGkFhzpuQV4i1nTneX3ZEBSE+fiaxKB/ln+Jsfnhd3R+UaGhbGkKAr4OBRU4p/AETQp/QlV19MDykhdJL9N1ZeR5+n2LG8I1qQAiLFS3JQWS9e0E/IgVIrUi1lCcOhQhjXWVEDTC+C5pdrBR+2xDihjpt+4QavDwjm/zuEN1qieFhBZYDLPPZQkGqBizpZgqZT2p6F5MYeutknOuWdEq1SlVoE0YCUrptKCB93WrBaXsDW7x5cIryZaAtSt3lFwJNb/fcFpDoD4ZbSN8f3DDU4nS7OpfEECDzu6lly2hPXNobfq7p/9idm49i1VO7fqNK7SnSEWymEuCy4HvHx1F0PECCKzXxB1r12504u/Oei8033+I8CvGV28wWE1JwC8L2EJoaDp4BSKPDSp8zCG9RPz/uTJF0UzYeBUm
 jgeeMjJ4
 La1+i6qFLPPQ/KR3uOkAbuUy/ElMYHHOW27vK0/H7SWg61DIWpx/MOR2PLuqm2P3aSXqbx00/bxq6AhBM/RN7BvlpiQ7eFabxZWq9/oYcOgaRsAK7Uuh89Fo0t4uyfYDm1sy0CUT8KLGL6EzzrMsP+T9N0Jeha/sDvL2152Cq3uvv1eOC7LMFqZ99ZEu2gzk690NCA26/+Q8q6yIM9vSJLBvZLgcEZyfOaM7V5MAeSGjN3LFVPXqRTPNluPdNYeECqNn44uM0wQv2yRIRkduegll8ZbRrPmq5h+tFpz9tAZg0iQ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are 8 possible transitions in __slab_free():

  a. partial->partial, offlist
  b. partial->partial, onlist
  c. partial->empty, offlist
  d. partial->empty, onlist, exceeding min_partial
  e. partial->empty, onlist, not exceeding min_partial
  f. full->empty, exceeding min_partial
  g. full->empty, not exceeding min_partial
  h. full->partial

(The onlist/offlist distinction does not apply to f, g and h, as a full
slab is on no list.)

Clarify which case each branch handles, and replace the goto with a
return at the end of the skipped block so that every branch explicitly
states its coverage.

Cases 'a' and 'b' are the only paths that need neither list_lock nor
list handling. Give them an early continue: handling them upfront is
much clearer than forcing every other case into a nested block.

Also, read SL_partial once after the loop right where it is used, rather
than re-reading it on every iteration.

No functional change.

Signed-off-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
---
v2:
- Split case-a into its offlist and onlist subcases in the changelog
  and reword the partial->partial comment accordingly (Thanks Vlastimil).
- Drop the shrinker as the example in the list_lock comment (Thanks Harry).
- Polish the wording of the some comments.
- Collect the Reviewed-by tags.
- Use git --patience to generate more readable patch.

RFC:
https://lore.kernel.org/linux-mm/20260824122513.3829-1-hao.li@linux.dev/
---
 mm/slub.c | 98 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 51 insertions(+), 47 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 54ec12503357..9c13d6887092 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5751,76 +5751,80 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 		new.inuse -= cnt;
 
 		/*
-		 * Might need to be taken off (due to becoming empty) or added
-		 * to (due to not being full anymore) the partial list.
-		 * Unless it's frozen.
+		 * partial->partial: if the slab was on the node partial list,
+		 * it stays there, and if it was off, it stays off, so we need
+		 * no list handling and no list_lock.
+		 *
+		 * Note that "continue;" in a do-while goes on to evaluate the
+		 * condition below, so we do perform the freelist update.
 		 */
-		if (!new.inuse || was_full) {
+		if (!was_full && new.inuse)
+			continue;
 
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
-
-			on_node_partial = slab_test_node_partial(slab);
-		}
+		/*
+		 * The slab might need to be taken off (due to becoming empty)
+		 * or added to (due to not being full anymore) the partial
+		 * list.
+		 *
+		 * Speculatively acquire list_lock prior to cmpxchg(), as
+		 * performing cmpxchg() before lock acquisition races with
+		 * concurrent partial list operations.
+		 *
+		 * If the cmpxchg does not succeed then we will retry.
+		 */
+		n = get_node(s, slab_nid(slab));
+		spin_lock_irqsave(&n->list_lock, flags);
 
 	} while (!slab_update_freelist(s, slab, &old, &new, "__slab_free"));
 
-	if (likely(!n)) {
-		/*
-		 * We didn't take the list_lock because the slab was already on
-		 * the partial list and will remain there.
-		 */
+	/* partial->partial: we didn't take the list_lock. */
+	if (likely(!n))
 		return;
-	}
 
-	/*
-	 * This slab was partially empty but not on the per-node partial list,
-	 * in which case we shouldn't manipulate its list, just return.
-	 */
+	on_node_partial = slab_test_node_partial(slab);
+
 	if (!was_full && !on_node_partial) {
+		/*
+		 * partial->empty, offlist: a bulk refill has taken the slab
+		 * off the partial list and will put it back, so its list
+		 * handling is not ours to do.
+		 */
 		spin_unlock_irqrestore(&n->list_lock, flags);
 		return;
 	}
 
 	/*
-	 * If slab became empty, should we add/keep it on the partial list or we
-	 * have enough?
+	 * full/partial->empty, exceed: we have enough partial slabs already.
 	 */
-	if (unlikely(!new.inuse && n->nr_partial >= s->min_partial))
-		goto slab_empty;
+	if (unlikely(!new.inuse && n->nr_partial >= s->min_partial)) {
+		/* partial->empty, onlist, exceed */
+		if (likely(!was_full)) {
+			remove_partial(n, slab);
+			stat(s, FREE_REMOVE_PARTIAL);
+		}
+		/* else, full->empty, exceed: it is on no list to remove from */
+
+		spin_unlock_irqrestore(&n->list_lock, flags);
+		stat(s, FREE_SLAB);
+		discard_slab(s, slab);
+		return;
+	}
 
 	/*
-	 * Objects left in the slab. If it was not on the partial list before
-	 * then add it.
+	 * At this point, only three cases remain:
+	 *   full->partial
+	 *   full->empty, not exceed
+	 *   partial->empty, onlist, not exceed
 	 */
+
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
+	/* else, partial->empty, onlist, not exceed: it stays on partial list */
 
 	spin_unlock_irqrestore(&n->list_lock, flags);
-	stat(s, FREE_SLAB);
-	discard_slab(s, slab);
 }
 
 /*
-- 
2.55.0


