Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD1A4CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 01:20:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F36B18E00B8; Thu,  9 Oct 2025 21:20:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE6E68E0002; Thu,  9 Oct 2025 21:20:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5918E00B8; Thu,  9 Oct 2025 21:20:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA1738E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72B90B6058
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:20:03 +0000 (UTC)
X-FDA: 83980448286.16.E344E7D
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id AE40880014
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:20:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="EcwO/xUr";
	spf=pass (imf30.hostedemail.com: domain of 3QF_oaAYKCO0hjgTcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--surenb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3QF_oaAYKCO0hjgTcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760059201; a=rsa-sha256;
	cv=none;
	b=QgAeEmscGn1nQ+0LEvlm91/L/S74U6ZfIbNo/i9xd5I+OfXK5qC3399+p1PhqKZx7v7fMm
	uxHLz177Ow3XoDMxvdlEsuzsUcJ23Cakujr3qMnLQc+itr/nuLx3L2F+rTXJ0yckT+Dx6/
	359TIGGBDpJLMcTN4IKCwKdtw8uwW7s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="EcwO/xUr";
	spf=pass (imf30.hostedemail.com: domain of 3QF_oaAYKCO0hjgTcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--surenb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3QF_oaAYKCO0hjgTcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760059201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q5NnfUqcWLVy127Caashokc+Ty+gAwqDLPiFwXfeq7Q=;
	b=dTUPV23P/0kMCi6umHMVO4Ax2noH/5e1ecvCzBdC7Ass4N0zrX/IiT5jzkcIChfxMhAP9q
	JiCcL2hRoq856dKvWbAwEPti+ZiAtvNanQBLNCx/Cm3qmq62g2e+LQZiu0kNmbCVVLV5UK
	8hNI8uGOAWb7M12uEoYcy1KsdZXOXwM=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-339b704e2e3so3823569a91.2
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 18:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760059200; x=1760664000; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q5NnfUqcWLVy127Caashokc+Ty+gAwqDLPiFwXfeq7Q=;
        b=EcwO/xUrft8piSpnaLxj1eQCZZrISZYHfb1xen7oRUPnCXvjsf9RzdUYr7ekNETsP3
         uMGgw/mlbEekOD28syTbKfZd11Sk8ozQQL/pUvQ77131m5kVktnQz8EcvyUbu7UCEkGi
         SFr86Gr8j2tPtR5qGDwzPbhFAN+sL5KUdqJvhwFHJGeAmcTEvn4JHgUHahvHpmbsN2m8
         4thn+Ba0tKOBZl8z8p0VUVqbcpX5yjfEMwnnZ+M1t33ASZ/4S4hwLQ74FSbXhBlFFWW0
         ye3bLijsMQlElC0Lh1yi2x0ivAia6huBKOKs1vnPWj8oYHf4qjjzFea8JlIEPax+Uf1O
         VUQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760059200; x=1760664000;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q5NnfUqcWLVy127Caashokc+Ty+gAwqDLPiFwXfeq7Q=;
        b=MQmmoFFixccSoNoQkCPdJD2SNA5WYbMLlZY4pkP2ZktS9E7PMVkrbJAhfq951pO+zB
         cS1MxvCltjZsPQmkBVfiFsHjpcThjzih2TP62SRSO6zdIl0A1KLQj0l+nSE1zBD9mkT0
         5/tBNnja0TxZqQRSqhRYlZjFaNtB1SnBulaH203hcbfPdZTfcG+AOZSIn8PexUFbhqt+
         Vaf2XjYtQhmAFNzIEIMN5ibEJODeMr+tWZg3gdCGee5/dyq4KvCGT9uF7Io3XHUlUmor
         ztyxDrF+veUiDxDmu2lLyTjFN4UZKP28GZpPE+9I9X2d8idHPJeObG959iCN2+nwx+1n
         O0vw==
X-Forwarded-Encrypted: i=1; AJvYcCWvXvD/BAV4hVXtWfG7s0q+/IzMts/n17RfJEI1Gtu0fPOCDUvWuOGdAG11mjPvhRju4CLitps9rA==@kvack.org
X-Gm-Message-State: AOJu0Yxf+1dgT+gNK8I1x+KyFvmXPe7Tz6oUi7jAcbG1oiREH8YDSf0i
	frQsiwGiSFIGCiFecTmkno2trZcW9lQpMBIIp3vhR3QSOfmfUqe4t08GUXpZler3piCfudZOcwA
	4742faA==
X-Google-Smtp-Source: AGHT+IGUtqiuXgYovxJ9pqzet+oIg30O6HUu5Ov7PiPDZ2bQlxmJF3pLfeJkqhVr7qj3OayvX9LqFKSZH5I=
X-Received: from pjbpb8.prod.google.com ([2002:a17:90b:3c08:b0:33b:51fe:1a95])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3908:b0:335:21bf:3b99
 with SMTP id 98e67ed59e1d1-33b5139a3c6mr12252369a91.32.1760059200475; Thu, 09
 Oct 2025 18:20:00 -0700 (PDT)
Date: Thu,  9 Oct 2025 18:19:45 -0700
In-Reply-To: <20251010011951.2136980-1-surenb@google.com>
Mime-Version: 1.0
References: <20251010011951.2136980-1-surenb@google.com>
X-Mailer: git-send-email 2.51.0.740.g6adb054d12-goog
Message-ID: <20251010011951.2136980-3-surenb@google.com>
Subject: [PATCH 2/8] mm/cleancache: add cleancache LRU for folio aging
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
X-Rspam-User: 
X-Stat-Signature: expea9xczjwjfg4nddmnmrudoj5udui8
X-Rspamd-Queue-Id: AE40880014
X-Rspamd-Server: rspam09
X-HE-Tag: 1760059201-412179
X-HE-Meta: U2FsdGVkX1+yl5kUuDa4BFRzMksFyzV+hJpG2TjZQ/0cBsGIDKY4AiVqUV2uQ+jeKPaSQjhewAAb0QtG2W1KatbqKBPwloZhR07jZEDTJNWo/kUMgx55YxW9l/IvkX/zjKRsu+TiFBCcAi+RMwVmIe/LeCCj0p17PnmCqHIa4/X0waEnDIHGLRTy2mjjOCkubJHMRbinvJkANKtFahOChSKBtsoNHjwyPuVDT+6CdgieugPBZzC7GhqyWVgdHfwbMtYk864ADQ/qa5hsiXg3XjokNRzcNe2LvAqz4kXsBzDmXYIS+zr0+HsvH6+suZu9Jdc2wYKmnRK2j4AnFiaD0bFotCI7BNyi1iNJe4FORUNO67otYrorZ5+Q2IBlVDKwarP9qFRtqS9FWsENqPGCyUjkLKPH1XxvkBX2LsxRBHSJh8SmPLGn0Ygm2RdlXxuuACXznkv9d1rswl2pum17/Uc1wePqLg7X6QZkaVmcmvfbOKVrCQu/mVEMh/EdpvunnX6PCZ6sSOg3OwfhM0mc1z0xmmoZFQnF5lAse/9A5kcOx88m6FOKOEGC3/rXMM/8woUmk/ZwHOlmtSTBEpfWstZqdoHyVpWq9fmVq8HNhNX4DMb9mKfOFic5XvyVlVIYdWSYhvXdM+dG5rCHGdMypkr3gBl4bwIZlSjko/k5Dtp4CTZJ6Iw6NsEUnLX6Sq6VlRqmez7ELaR2/ZPWsBjcDk0ORdSyKYHyvxFL+sKOLRPwQhRMel5Z8t6cHqxg7yYttDZ2cX+8Dk+pT6ZH65RQByew6VyR6E0PdJsoVQuVTDzC9kTok/Cg7s8jEhpvlUbAQavW8eO+G3ePESEdBqTn/uE2cJNbfp0YCglx0nyh9wyDDq6iWeci9TnFNG0EtWcGKd967fKKU6VFNxrk2MzDdNzBHVshgLSIqkpA676GGg9QcaAddaUXo69P/oAOVUbwMcggbpeh9+hJQ5ykZrD
 LVP2Ax4F
 Bn+blrmDQ6vJN79so1Z0C/k3dlo+25ByVyq38/DslmZjphwCr9I77dDw/flkQkfJqWgvDAF4YX8EIUhf2TER8nH/YiHBrYx/CaSZX2qYaUJ4wv7upFkyb8V0P260K2b8aPHWxkF7muD20uVC0MCnpQXcAxRpC3TTc6dCbE4Fcm4oiAxQk6hgV24+7rkrfdnrYr/BG/pZK93lYsQF1UxdbIIGSdK7wePOaV7j/SB9ZXvIU7kTfWPuPy0Nkz6KqwBZ6GZYmydvPHQZ+tHCyN08L+CU/IRMsrOoyuSw3NB1/jzC/Az6le/fRb3uxqxSAndgHNJYKf1kd6atKMEhGWWQ89p2rlDL6P2cQ2liNbtymXfQmMFJtxyS6+2SubrAW5KBbsKvDyMJqbR1LttjBldjFicC+pSPSUV9CtrohFaP7ZEgM2UTlDYtyhzdweugRrExSnRbD2tG3o2l6/Eseodn9H/9zQ862fpJ+savzYxeBzkWutdBeDsZAI8qqvyRcY8b4TuEdY683SIlQ3TavuZcVaXJO14khJO5cgxUO
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
 mm/cleancache.c | 90 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 88 insertions(+), 2 deletions(-)

diff --git a/mm/cleancache.c b/mm/cleancache.c
index 0023962de024..73a8b2655def 100644
--- a/mm/cleancache.c
+++ b/mm/cleancache.c
@@ -19,6 +19,13 @@
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
@@ -60,6 +67,8 @@ static struct kmem_cache *slab_inode; /* cleancache_inode slab */
 static struct cleancache_pool pools[CLEANCACHE_MAX_POOLS];
 static atomic_t nr_pools = ATOMIC_INIT(0);
 static DEFINE_SPINLOCK(pools_lock); /* protects pools */
+static LIST_HEAD(cleancache_lru);
+static DEFINE_SPINLOCK(lru_lock); /* protects cleancache_lru */
 
 /*
  * Folio attributes:
@@ -130,6 +139,7 @@ static inline bool is_folio_attached(struct folio *folio)
 /*
  * Folio pool helpers.
  *	Only detached folios are stored in the pool->folio_list.
+ *	Once a folio gets attached, it's placed on the cleancache LRU list.
  *
  * Locking:
  *	pool->folio_list is accessed under pool->lock.
@@ -181,6 +191,32 @@ static struct folio *pick_folio_from_any_pool(void)
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
@@ -316,6 +352,7 @@ static void erase_folio_from_inode(struct cleancache_inode *ccinode,
 
 	removed = __xa_erase(&ccinode->folios, offset);
 	VM_BUG_ON(!removed);
+	delete_folio_from_lru(folio);
 	remove_inode_if_empty(ccinode);
 }
 
@@ -413,6 +450,48 @@ static struct cleancache_inode *add_and_get_inode(struct cleancache_fs *fs,
 	return ccinode;
 }
 
+static struct folio *reclaim_folio_from_lru(void)
+{
+	struct cleancache_inode *ccinode;
+	unsigned long offset;
+	struct folio *folio;
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
@@ -468,14 +547,19 @@ static bool store_into_inode(struct cleancache_fs *fs,
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
@@ -487,6 +571,7 @@ static bool store_into_inode(struct cleancache_fs *fs,
 			spin_unlock(&pool->lock);
 			goto out_unlock;
 		}
+		add_folio_to_lru(stored_folio);
 	}
 	copy_folio_content(folio, stored_folio);
 
@@ -516,6 +601,7 @@ static bool load_from_inode(struct cleancache_fs *fs,
 	xa_lock(&ccinode->folios);
 	stored_folio = xa_load(&ccinode->folios, offset);
 	if (stored_folio) {
+		rotate_lru_folio(stored_folio);
 		copy_folio_content(stored_folio, folio);
 		ret = true;
 	}
-- 
2.51.0.740.g6adb054d12-goog


