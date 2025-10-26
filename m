Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E62ACCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 20:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D65E8E0180; Sun, 26 Oct 2025 16:36:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 284A78E0120; Sun, 26 Oct 2025 16:36:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1258E8E0180; Sun, 26 Oct 2025 16:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ED5798E0120
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 16:36:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B511B1A0418
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 20:36:22 +0000 (UTC)
X-FDA: 84041423004.04.8C1421D
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	by imf01.hostedemail.com (Postfix) with ESMTP id E4EE340005
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 20:36:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BErQwMQz;
	spf=pass (imf01.hostedemail.com: domain of 3Q4b-aAYKCJgKMJ6F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--surenb.bounces.google.com designates 209.85.128.201 as permitted sender) smtp.mailfrom=3Q4b-aAYKCJgKMJ6F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761510980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMCyHr31TLzATbQuHg3ruEQF/2874D74tyKjOOWzy0s=;
	b=gZNJ/yZjh1nF3E5p82efVrQjJZiyYOTbpNBtBr7VDsQS4jX2iCo25hYA8rEP0huOmEgeRW
	4+dzBKdRw2vJ14bInA+J7BufWiiI9sU9FFJK3XHfYmhEH/fSYMe8lJmguFlxa7aPYKqsBr
	Qs2XonbekKPdHPoGv8ffsK9oK7tBBf8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761510980; a=rsa-sha256;
	cv=none;
	b=p0HsentMBlnnqmDbhMQTYurC8ab2jMYKkWq3hWvsn4xh/TeBSHWXfjc20CvVbkKj89k3ZK
	SSbzUdrxnvSLZEbIBDJMhukJXZJzGl0a2rBkAHpI6mGsfrsAlnBx1mfzFNjWPZDcXDWzs3
	Q7xrFldpDVdNtGxPt1qYHdJroHwVp/o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BErQwMQz;
	spf=pass (imf01.hostedemail.com: domain of 3Q4b-aAYKCJgKMJ6F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--surenb.bounces.google.com designates 209.85.128.201 as permitted sender) smtp.mailfrom=3Q4b-aAYKCJgKMJ6F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-785d7ee74b7so44233437b3.3
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 13:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761510980; x=1762115780; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IMCyHr31TLzATbQuHg3ruEQF/2874D74tyKjOOWzy0s=;
        b=BErQwMQz0u+/xnYdTaYGjcxMeKpCfOhpnfAqlMRp4Dp8ohAwZ6JOpCM7+XjaqnSZTg
         7BxY6UjQAPKGyULgJmc8htcC8eDquS5k7HrO2jpnOQMDjzKqKP2lF/9RrRivUoAN5JyQ
         3L1QJw30P2o7cUnNELmXAYhJkJBUEgwva40HPn4gpg0pMe9yrFlET3e6iavE/qgL++vD
         aAHiY49LO2Ki/4HDW6OXv9km9Gt/rqpHNQKvooFCaXwFWp+qFLg96tkvFODdTaj87mOu
         Da0IsrvnKKBBJJjlfUqiv1U5P/niHS3KVz/HbvXXQHlf0QhRe8TJLi0eT1hNda4vrX82
         YAvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761510980; x=1762115780;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IMCyHr31TLzATbQuHg3ruEQF/2874D74tyKjOOWzy0s=;
        b=fDdhaAiQCnGQke6ZOk2faEs9jQ9RLga9DahSiFCeUyH0JF1TqQers3Sl7dAvk8zFpV
         vmHgvq4qJ6KAwZNt7gb0i+WxtpSOw0P1Y7tZi3surAScJH3VEJa/OAutJGfoHumLF3K7
         a0KUhJ/qiOIgiJOAL925Yjd2XPWfgiFFJvmLSe2AYp6gzHDsbCvAwMxIIpnqwwYxGtIV
         3mbQVhRLB87yidM1f70Yv6UJIDYxP6C8wQoPvjumLSFBwq1h/DrMsle8IXU41QV0wd4V
         s9mKNGiqAk97sO7BUjBHDD073+snZ83u4ZTZyCdvYWPvgM+ZZzybicjVX0EL7SkrLw9L
         1kIw==
X-Forwarded-Encrypted: i=1; AJvYcCU8wpXbdu3Y2Z8xOBXJ+1DmNDjRwg3+VJy28hPtCPhE11HabjDhjC2H4SVQ/oFmLSAcgsXZRoOXBg==@kvack.org
X-Gm-Message-State: AOJu0YxE40KWMGvxLvDNHkM22G54HxUjqkHVTdRJH+bs7XJTt3LKqtpV
	uSIA0QIaujhPZRo2ayxT6IRM4pdcMM2JaFCLRLLUknM5h/vA+VhIdGQSsUgqhcRLY7Wp7+MPUrL
	+Vv660A==
X-Google-Smtp-Source: AGHT+IHpMr9cFr0H62WPICb/ViZzGU3rsCsk6GeJaW1ZdGu5t8yZ0ftElBAnf4rqpT99zJhDJFFFka8CTI4=
X-Received: from ywa1.prod.google.com ([2002:a05:690c:9401:b0:785:bb80:f2f5])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:690c:f88:b0:784:9419:2787
 with SMTP id 00721157ae682-78494193880mr250052107b3.69.1761510979847; Sun, 26
 Oct 2025 13:36:19 -0700 (PDT)
Date: Sun, 26 Oct 2025 13:36:05 -0700
In-Reply-To: <20251026203611.1608903-1-surenb@google.com>
Mime-Version: 1.0
References: <20251026203611.1608903-1-surenb@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251026203611.1608903-3-surenb@google.com>
Subject: [PATCH v2 2/8] mm/cleancache: add cleancache LRU for folio aging
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, alexandru.elisei@arm.com, peterx@redhat.com, sj@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, axboe@kernel.dk, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, hch@infradead.org, jack@suse.cz, 
	willy@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com, 
	hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	minchan@kernel.org, surenb@google.com, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev, Minchan Kim <minchan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Stat-Signature: o1m1cnw6rgqnjeoqhu7g7fmjgd9df6e6
X-Rspam-User: 
X-Rspamd-Queue-Id: E4EE340005
X-HE-Tag: 1761510980-88842
X-HE-Meta: U2FsdGVkX1+D06X+P8EQyFWSEMX7nhJP75hklP+lQEXdvLO/J6pO960NRe7O1fKAT9PRkXYMjcKe5uhfTGDjkzbzo2w4sNZZ9ThXqoA6U6FXkz5qNnuqjOtbocXQCDrsuL+slk8pZdIJevHnR12005nIZyECiA7820xFwUQcxWRSW4n+sx5qQ/Oeya0tUEa4RdW6Og6plpa+jIeyAufOqXC7YrSA4mbhL7ETIKzTtV7LT/Z/XkmER/9uoiIYRNJQrBr++/7uA0TK5oDsaV0fz5HKJkGt1df3ucGkCml2LOyMLcGEkPxqsOWuTOyjNlq2zCzKCm898EUMEe38+7T0cDVZA+UCxyEGFd7y2YB6LLkGNzDyscZ779m0mnNPQ3ATlQSGEh5zzLzv9F79eiJoSUMF8wUk5f/TPp3yccLGYfiyM13X3EnfSDboJzpdBQmeGkpfKR2vLobiJbZyFBQatRxukC4R6qY1ALr9ng10PQlZPlHK7T375aXQD7X1yAjN7TfxBm+rqP9V0GMq9f6kqULeUv+BT4H4mFbBm9EGYEq/h/LtdeCh/itRaEABLgiomyliCnzCynNvPGqeqBJR7XUgNaKwQcPECkbTdeAoZqrgkMgzvS27JA/Niqh6Wv+6V2Gm94dW3qdlTAbOuAO6O6vlnmoIXG0+Ot2pYG8ILFyxLeNeKcu1DtzvmuRTqQNqcDZBRyxsSWHO2dfLa1E6Bn/KrOuPhHWDgDKKQSp/uC+wRMkFEhzUUspjT3gGgM1oRwZAB5wTuRSvZ+0cPyFhDWSEWwhvakZSwR1tRrN93BSnvgNQl9tXOPff4iouCASrpsyCHVkDHz2dmFsXuaDV+pd31PFUMpdgnLoGM5eqY5pcwru8ET9HhX5HPboyzlzTVM2M/4DmzJyPThiC3Wz2vAOSOGGD8UKtXYETTdXuRHrbaEymfe2FF1kMP5wl3EXgBBwNtYVx55vhTw+ZVd2
 qi2WcpKt
 Hz7CmZWAxWtwy+fmHG8axR3QOwFWIiemCAYtXA5fG4f7xWsSF4NmqKm8TqwG4punBXerVIOvYjY4qfT3sD8F2XgEdjkEz77wvQaSOvujCQjpHi9QdQiAkINhJDXQdT2guNN1v5MibiYvv3LfR+9AASJ2iuPbf3wsG0EDvmMMb+wkv281kv2g/jfRayAbX8kPpbCdYn2zLkeVwEXFDbN0/jr8vCOO5PGuqiTAVORUQmceOV1Ot0HJFPiwZxfJIP4FR4C2nVX6n33hbIikCQsIr5DTIr6UUNb7Mf5+aTpgrHUEQHBPyn93E6FWHb+/0EjxSFtlXEsHA9WJpxRnIIYhpFoKKiDAjcImUu2IcKT2BiErzVn0nGOo9HnP10LHiiaoWCV8U1UkisvmalXlCKfGckmDY1EuokQ9qH7zkXlpWAw8LbEdaRhl/bhWRxyC1HwolhGWRuvkJ0Iw3ocfM9/wr7FKy5g/W8u7JmmneoT63vsJDhyqua961012x2KglkXinokQ0KSNs0ncgkK9IFjNIUPxAO76Rl0PJ0Yg89XwhTBcvns40FJqLdG4/nMQ7srdaVwO0XsSfAYaQlmM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Once all folios in the cleancache are used to store data from previously
evicted folios, no more data can be stored there. To avoid that situation
we can drop older data and make space for new one.
Add an LRU for cleancache folios to reclaim the oldest folio when
cleancache is full and we need to store a new folio.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Minchan Kim <minchan@google.com>
---
 mm/cleancache.c | 91 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 89 insertions(+), 2 deletions(-)

diff --git a/mm/cleancache.c b/mm/cleancache.c
index 26fb91b987b7..3acf46c0cdd1 100644
--- a/mm/cleancache.c
+++ b/mm/cleancache.c
@@ -18,6 +18,13 @@
  *
  *	ccinode->folios.xa_lock
  *		pool->lock
+ *
+ *	ccinode->folios.xa_lock
+ *		lru_lock
+ *
+ *	ccinode->folios.xa_lock
+ *		lru_lock
+ *			pool->lock
  */
 
 #define INODE_HASH_BITS		6
@@ -58,6 +65,8 @@ static struct kmem_cache *slab_inode; /* cleancache_inode slab */
 static struct cleancache_pool pools[CLEANCACHE_MAX_POOLS];
 static atomic_t nr_pools = ATOMIC_INIT(0);
 static DEFINE_SPINLOCK(pools_lock); /* protects pools */
+static LIST_HEAD(cleancache_lru);
+static DEFINE_SPINLOCK(lru_lock); /* protects cleancache_lru */
 
 static inline void init_cleancache_folio(struct folio *folio, int pool_id)
 {
@@ -73,6 +82,7 @@ static inline void clear_cleancache_folio(struct folio *folio)
 {
 	/* Folio must be detached and not in the pool. No locking is needed. */
 	VM_BUG_ON(folio->cc_inode);
+	VM_BUG_ON(!list_empty(&folio->lru));
 
 	folio->cc_pool_id = -1;
 }
@@ -123,6 +133,7 @@ static inline bool is_folio_attached(struct folio *folio)
 /*
  * Folio pool helpers.
  *	Only detached folios are stored in the pool->folio_list.
+ *	Once a folio gets attached, it's placed on the cleancache LRU list.
  *
  * Locking:
  *	pool->folio_list is accessed under pool->lock.
@@ -174,6 +185,32 @@ static struct folio *pick_folio_from_any_pool(void)
 	return folio;
 }
 
+/* Folio LRU helpers. Only attached folios are stored in the cleancache_lru. */
+static void add_folio_to_lru(struct folio *folio)
+{
+	VM_BUG_ON(!list_empty(&folio->lru));
+
+	spin_lock(&lru_lock);
+	list_add(&folio->lru, &cleancache_lru);
+	spin_unlock(&lru_lock);
+}
+
+static void rotate_lru_folio(struct folio *folio)
+{
+	spin_lock(&lru_lock);
+	if (!list_empty(&folio->lru))
+		list_move(&folio->lru, &cleancache_lru);
+	spin_unlock(&lru_lock);
+}
+
+static void delete_folio_from_lru(struct folio *folio)
+{
+	spin_lock(&lru_lock);
+	if (!list_empty(&folio->lru))
+		list_del_init(&folio->lru);
+	spin_unlock(&lru_lock);
+}
+
 /* FS helpers */
 static struct cleancache_fs *get_fs(int fs_id)
 {
@@ -306,6 +343,7 @@ static void erase_folio_from_inode(struct cleancache_inode *ccinode,
 
 	removed = __xa_erase(&ccinode->folios, offset);
 	VM_BUG_ON(!removed);
+	delete_folio_from_lru(folio);
 	remove_inode_if_empty(ccinode);
 }
 
@@ -403,6 +441,48 @@ static struct cleancache_inode *add_and_get_inode(struct cleancache_fs *fs,
 	return ccinode;
 }
 
+static struct folio *reclaim_folio_from_lru(void)
+{
+	struct cleancache_inode *ccinode;
+	struct folio *folio;
+	pgoff_t offset;
+
+again:
+	spin_lock(&lru_lock);
+	if (list_empty(&cleancache_lru)) {
+		spin_unlock(&lru_lock);
+		return NULL;
+	}
+	ccinode = NULL;
+	/* Get the ccinode of the folio at the LRU tail */
+	list_for_each_entry_reverse(folio, &cleancache_lru, lru) {
+		struct cleancache_pool *pool = folio_pool(folio);
+
+		/* Find and get ccinode */
+		spin_lock(&pool->lock);
+		folio_attachment(folio, &ccinode, &offset);
+		if (ccinode && !get_inode(ccinode))
+			ccinode = NULL;
+		spin_unlock(&pool->lock);
+		if (ccinode)
+			break;
+	}
+	spin_unlock(&lru_lock);
+
+	if (!ccinode)
+		return NULL; /* No ccinode to reclaim */
+
+	if (!isolate_folio_from_inode(ccinode, offset, folio)) {
+		/* Retry if the folio got erased from the ccinode */
+		put_inode(ccinode);
+		goto again;
+	}
+
+	put_inode(ccinode);
+
+	return folio;
+}
+
 static void copy_folio_content(struct folio *from, struct folio *to)
 {
 	void *src = kmap_local_folio(from, 0);
@@ -458,14 +538,19 @@ static bool store_into_inode(struct cleancache_fs *fs,
 			move_folio_from_inode_to_pool(ccinode, offset, stored_folio);
 			goto out_unlock;
 		}
+		rotate_lru_folio(stored_folio);
 	} else {
 		if (!workingset)
 			goto out_unlock;
 
 		stored_folio = pick_folio_from_any_pool();
 		if (!stored_folio) {
-			/* No free folios, TODO: try reclaiming */
-			goto out_unlock;
+			/* No free folios, try reclaiming */
+			xa_unlock(&ccinode->folios);
+			stored_folio = reclaim_folio_from_lru();
+			xa_lock(&ccinode->folios);
+			if (!stored_folio)
+				goto out_unlock;
 		}
 
 		if (!store_folio_in_inode(ccinode, offset, stored_folio)) {
@@ -477,6 +562,7 @@ static bool store_into_inode(struct cleancache_fs *fs,
 			spin_unlock(&pool->lock);
 			goto out_unlock;
 		}
+		add_folio_to_lru(stored_folio);
 	}
 	copy_folio_content(folio, stored_folio);
 
@@ -506,6 +592,7 @@ static bool load_from_inode(struct cleancache_fs *fs,
 	xa_lock(&ccinode->folios);
 	stored_folio = xa_load(&ccinode->folios, offset);
 	if (stored_folio) {
+		rotate_lru_folio(stored_folio);
 		copy_folio_content(stored_folio, folio);
 		ret = true;
 	}
-- 
2.51.1.851.g4ebd6896fd-goog


