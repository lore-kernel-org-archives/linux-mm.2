Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EA63CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 09:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 990226B0092; Tue, 13 Oct 2026 05:18:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 966BC6B0095; Tue, 13 Oct 2026 05:18:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E15A6B0096; Tue, 13 Oct 2026 05:18:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9226B0092
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:18:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C82D780AFE
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:18:29 +0000 (UTC)
X-FDA: 85317052338.16.433CB90
Received: from mailrelay-egress5.pub.mailoutpod3-cph3.one.com (mailrelay-egress5.pub.mailoutpod3-cph3.one.com [46.30.211.244])
	by imf26.hostedemail.com (Postfix) with ESMTP id 848A2140009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:18:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b="tSH/Wi9q";
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=0gcI8aCZ
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791883108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QvNh11oJXl4baoOT3DDsfp6RFRaR2ZJoWtlgXXO75tI=;
	b=UGP21zxHE5Pit/K+MHNXCHZy6ou564gIbMj/m4wZSPM+428Nr+eAIo4BUKTKQyP8UEsZ1Q
	+UQbBJB7RPMnp6ufOSDGtySg+lTncB4Oqlau6bvLysrkfT1xWxAYWXbqQ7EDxNtky4CFy3
	oEzJi3Yj6i+E99zY6MYbIeGYPo1Eb+s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791883108;
	b=Ek+3DJfX7EWLnngqH3g78z3FtNxW0oimUV9K7u+KXK1bQvl1QyfRB811kTCbFAW5+BQiSW
	LlLlr9sFB0Hp1M6aRoTMAM4PN/P5tQHgMxovrvyyN6vmY1wEqVToIdVOA4qXgnDfLWNPFJ
	t1x5+C6ImTBC94E+rg2dMi4EVwKoCX8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b="tSH/Wi9q";
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=0gcI8aCZ;
	spf=none (imf26.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.211.244) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1791883104; x=1792487904;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=QvNh11oJXl4baoOT3DDsfp6RFRaR2ZJoWtlgXXO75tI=;
	b=tSH/Wi9qixI4r+KP6FzS9zXUGshyfkpCGVGoLSlmZ+i8KrjEzp9ry4AR/gIyVCXj+lSpJRTU1I/8E
	 JK85Xqj/aHTQ7eq63qsYNxhakfGwUUZ7i/wwl9MlGwglPzKzglhA3kJyd5tZjx73jYgUffayQ6XW2E
	 VAE6D3oS74Qq4GKJb7sygrNyXw+fwEM+mhvOe9hVVmJZbn+CFl8rbJSlskMTNBtkKK928jhNkqczBH
	 PGX8f9oH+TsXvc/i8tv/EP26fGoTcVnT7kZOejqjXClOhmHBMjtZttczNeyJS73qqt1zurrF4ct0sS
	 LXfN9rK1JyK6UJER6WUOZAzcaE1mFMw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1791883104; x=1792487904;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=QvNh11oJXl4baoOT3DDsfp6RFRaR2ZJoWtlgXXO75tI=;
	b=0gcI8aCZpvuOyPEeMuf/5JJupCYCw4UOfVru3UBNBjuLktxnMxpF1HNrTVzUT318RcHLmVFyjPEUp
	 PqppCM1Dg==
X-HalOne-ID: 09f3f4df-c6e7-11f1-b88b-7d3e33f7de26
Received: from localhost.localdomain (c213-102-77-204.bredband.tele2.se [213.102.77.204])
	by mailrelay1.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 09f3f4df-c6e7-11f1-b88b-7d3e33f7de26;
	Tue, 13 Oct 2026 09:18:24 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Harry Yoo <harry@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Vitaly Wool <vitaly.wool@konsulko.se>,
	Vitaly Vul <vitaly.vul@partner.samsung.com>
Subject: [PATCH v2] mempool: optimize mempool resizing
Date: Tue, 13 Oct 2026 11:14:08 +0200
Message-Id: <20261013091408.1231786-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 848A2140009
X-Stat-Signature: jbfurq9w6bdxrgagrifadz8mbkftbwqi
X-HE-Tag: 1791883107-339319
X-HE-Meta: U2FsdGVkX1+i2M1yV5rtJaSSGfuZ3behF3nFhdd9QuyYOF+TLdFdQ0uEzRsY29lNG3P8NRCAkK8kKJ1GFmQZh9jJ3hLcN5GQ5kGf/d7v30x36hOgGH37oF9IkSRx09PZ1MJM0GdUWHvYfCrkKGNbg9K/MvFfLTvPK/3wtUPU193MyK5Oy55/jYGQeXh08L6w2egvsZsb2skhEMcCjbuErPjp9jiRt0oJFbXbyGWf7z+M3XSlKFusnn2ezqRb4ZYJgRZyqhCWqU5Q1l31bfy2FTZguKEIacvu2HTlJ/BCli0waSFXzGa3/5ZySRQyvNxm+6l2KMfxoFNYIdlu7zuMISTEsP1cmTMukk++VwyrplWVFI5xNs7GJjY1ngUYz0UOx6V7dk7O8aapPkedYRI4dTN63ZScQDDI89wTr5Wj7Ql2nOUnfPOZ1ffs5lbcjXC0j863Jf8h5r0ebQ4l6bu9F8TjvFKVKm93xwzlkY8zc2pfMyb3TundzOUs2l6LzSfevluY08vUzQd4J+9ayy0IkCzspRl4QTIoAcGfVp14bqJkd7YlqbAqOayH0EkU2OFRat7KFXMLCqNrTWZH7JtPndZ5U6nIpNLv9ecbX+6OaC4M11/YavphqqGU1kf0JbD1oqKEaQpTNSgZJ6msy6Z5GmY3nt0unwoCMlMRPIoskGQJ46TrbtPBEoJcKmEk8oGTefvmvhf+y14Bv7MBMWXrmRrAV0HrHIMB6DEX2XqEzQJhPcdz6FrBfZLNPUdzvhA02Qgm9MQr8EqNsqeurMymlq6PmhAli4UGnaMiKrR+T0HWXQCIwYmPkBsbnUtgNFzyoOwaIYsuox+lFjB4u5f3/bTeyfRXLd7THtbUyBEMIdx7lGNehJucReuV6HiAh30k9usor9LYJlFXsLj4s8v6SyGYkl7Yvr2zUYrYNwnus2Du7Hn4Xs3Bko1YUpBPRTeKzc/ZQS31oGSOX5DTW84
 nR9RFfpA
 qE4V1rQbNKBzdj3BNQZ37fQ8mgmFn+Hktn+IIvOdw0bOJlpg5syO77n6EcpSl85yH/wOLUPT7ZjfJDT8aaRexNRsuu1VVf8fazod9COsPP0gImfC48aSvbWQ6jkhW4HplnzHYDh0+s9Ot/TIOXgqv7k1edCvhsevaOGAh5ziw+TSytftNQqrDXCUADbQ/Z93g9JdO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Resizing mempool to a bigger size currently requires a new allocation and
a data copy to a new larger elements array which doesn't go well with the
idea of having a fast and deadlock free memory allocations during exreme
load.

This situation can't be completely avoided but its occurrence can be
vastly minimized if we track the actual number of slots in the elements
array. This patch introduces a new member of struct mempool which is set
when the array is allocated in mempool_init_node() and only changes when
mempool_resize() replaces the array with a bigger one.  Growing a pool to a
size that still fits the existing array now just raises min_nr and refills
the pool.

A racing resize may enlarge the array while the lock is dropped for the
allocation, so __elements_size is checked again once the lock is
retaken, and the unneeded array is freed.  The array being replaced is
now freed after dropping the lock.

Signed-off-by: Vitaly Vul <vitaly.vul@partner.samsung.com>
---
 include/linux/mempool.h |  1 +
 mm/mempool.c            | 43 ++++++++++++++++++++++++++---------------
 2 files changed, 28 insertions(+), 16 deletions(-)

Changelog:
* v2: all the API / behavioral changes are dropped, only the
  optimization remains

diff --git a/include/linux/mempool.h b/include/linux/mempool.h
index 6da502aef2f7..a8a411290bf0 100644
--- a/include/linux/mempool.h
+++ b/include/linux/mempool.h
@@ -20,6 +20,7 @@ typedef struct mempool {
 	int min_nr;		/* nr of elements at *elements */
 	int curr_nr;		/* Current nr of elements at *elements */
 	void **elements;
+	int __elements_size;	/* nr of slots in *elements, never shrinks */
 
 	void *pool_data;
 	mempool_alloc_t *alloc;
diff --git a/mm/mempool.c b/mm/mempool.c
index cb74e718b2c6..1911a696737b 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -261,6 +261,7 @@ int mempool_init_node(struct mempool *pool, int min_nr,
 					    gfp_mask, node_id);
 	if (!pool->elements)
 		return -ENOMEM;
+	pool->__elements_size = max(1, min_nr);
 
 	/*
 	 * First pre-allocate the guaranteed number of buffers,
@@ -353,6 +354,8 @@ EXPORT_SYMBOL(mempool_create_node_noprof);
  * This function shrinks/grows the pool. In the case of growing,
  * it cannot be guaranteed that the pool will be grown to the new
  * size immediately, but new mempool_free() calls will refill it.
+ * Shrinking keeps the elements array, so growing the pool again up to
+ * the largest size it ever had does not reallocate it.
  * This function may sleep.
  *
  * Note, the caller must guarantee that no mempool_destroy is called
@@ -364,7 +367,7 @@ EXPORT_SYMBOL(mempool_create_node_noprof);
 int mempool_resize(struct mempool *pool, int new_min_nr)
 {
 	void *element;
-	void **new_elements;
+	void **new_elements = NULL;
 	unsigned long flags;
 
 	BUG_ON(new_min_nr <= 0);
@@ -381,24 +384,31 @@ int mempool_resize(struct mempool *pool, int new_min_nr)
 		pool->min_nr = new_min_nr;
 		goto out_unlock;
 	}
-	spin_unlock_irqrestore(&pool->lock, flags);
-
-	/* Grow the pool */
-	new_elements = kmalloc_objs(*new_elements, new_min_nr);
-	if (!new_elements)
-		return -ENOMEM;
 
-	spin_lock_irqsave(&pool->lock, flags);
-	if (unlikely(new_min_nr <= pool->min_nr)) {
-		/* Raced, other resize will do our work */
+	/*
+	 * Grow the pool.  The elements array is only reallocated if it is too
+	 * small, it may still be large from before an earlier shrink.
+	 */
+	if (new_min_nr > pool->__elements_size) {
 		spin_unlock_irqrestore(&pool->lock, flags);
-		kfree(new_elements);
-		goto out;
+		new_elements = kmalloc_objs(*new_elements, new_min_nr);
+		if (!new_elements)
+			return -ENOMEM;
+
+		spin_lock_irqsave(&pool->lock, flags);
+		if (unlikely(new_min_nr <= pool->min_nr)) {
+			/* Raced, other resize will do our work */
+			goto out_unlock;
+		}
+		/* A racing resize may have enlarged the array meanwhile */
+		if (new_min_nr > pool->__elements_size) {
+			memcpy(new_elements, pool->elements,
+			       pool->curr_nr * sizeof(*new_elements));
+			/* The old array is freed below, outside the lock */
+			swap(pool->elements, new_elements);
+			pool->__elements_size = new_min_nr;
+		}
 	}
-	memcpy(new_elements, pool->elements,
-			pool->curr_nr * sizeof(*new_elements));
-	kfree(pool->elements);
-	pool->elements = new_elements;
 	pool->min_nr = new_min_nr;
 
 	while (pool->curr_nr < pool->min_nr) {
@@ -418,6 +428,7 @@ int mempool_resize(struct mempool *pool, int new_min_nr)
 out_unlock:
 	spin_unlock_irqrestore(&pool->lock, flags);
 out:
+	kfree(new_elements);
 	return 0;
 }
 EXPORT_SYMBOL(mempool_resize);
-- 
2.39.5


