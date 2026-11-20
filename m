Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0132C606A6E2
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 19:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A/LHCGfe
Received: by kanga.kvack.org (Postfix)
	id 873076B05B0; Fri, 20 Nov 2026 14:51:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FCCC6B05B1; Fri, 20 Nov 2026 14:51:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64FA06B05B2; Fri, 20 Nov 2026 14:51:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6826B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:51:05 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B14D61C22CD
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:51:04 +0000 (UTC)
X-FDA: 85456540848.10.F8EC507
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0136440006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:51:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/LHCGfe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of mason@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mason@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795204263;
	b=wn7aLrPjm+GDQPPmK0Y++4q94hqCBAUWQwe8JtFkqC32CN76fkgN476fB1T6zhDheyBqSG
	0jYNflufarOOKenpPb7pQw4+KAH0lpNcsNIsXewINXZ2Yvikw3W4DilegQFx8JTf3R4avT
	3nqrUDbkBduGUhYlIDc0yiN159vatEk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795204263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MTAY5ibAV1uBF9jduuJT+bDCTIoeL+5xkNZ5oxnneLw=;
	b=Z7Ei/Dr705Xww41tion/LlTjNa4tmcPf6QMyNlNYRCgv291tcnHYxUYDCUMKDMLu2lt/pe
	rtM+Jk35CxnqLDVaTvli9sHkv8PEha/mvWAbAS9Y5rZ2/dRh56pIjn4+RVas/mQvHHyTTo
	eHvZY21AYFaK4PnaCo+HiNWn5eHeW4g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/LHCGfe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of mason@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mason@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F1C6465BB;
	Fri, 20 Nov 2026 19:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041FF1F000C6;
	Fri, 20 Nov 2026 19:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795204262;
	bh=MTAY5ibAV1uBF9jduuJT+bDCTIoeL+5xkNZ5oxnneLw=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=A/LHCGfe7mu4454iMs5fhNiINy54iJwrmXZT5ZmbHZaxSE3qSYofocnuDwsb3nVZP
	 rkrTqjJ/FmgPJB0r+5bSjYluJfO0FJiZYA7LMmg+d6Oap+l/40yOLjj2b4MUmDjrTB
	 NtG/8sIT0VGNBPFd5qtgmzVlnwHDbEMK8LZZEnMH+C+nsXmDc+cHhAGw5K6W4M5XMc
	 F53IjUa+fdgCez2RmrnoqkxwoZd2umDt/RrZyV+2MyPkrOxEed8lbHVET2wgZZ9jrB
	 tlN/4sFAlc7HO7IU/5nIVvTazall6xcsZQD0yQfgKWrsRU4Ujknp1yN9VynbdIW0hS
	 Ni9ATcTdbhHVw==
From: Chris Mason <mason@kernel.org>
To: hughd@google.com,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	qi.zheng@linux.dev,
	qinyuntan@linux.alibaba.com,
	shakeel.butt@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	mason@kernel.org
Subject: [PATCH v2 1/1] mm/shmem: don't use the memcg of an uncharged folio
Date: Fri, 20 Nov 2026 14:50:58 -0500
Message-ID: <20261120195057.50031-2-mason@kernel.org>
In-Reply-To: <20261120195057.50031-1-mason@kernel.org>
References: <20261120195057.50031-1-mason@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xfqz9bwuhr9cirspjr5hin1cjg3i3y4m
X-Rspam-User:
X-Rspamd-Queue-Id: 0136440006
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795204262-999671
X-HE-Meta: U2FsdGVkX1/IOEsaewDxZxkTWBQvFInfFH9Bcg/0KVro0WgkC5zbMVP+IxZejoamVEtSN/QyaBB6f9ECoOFvnRPrHEnl83ZmU2gKbEa4RsV8ASyPbmpO7aHmLGUrVxSaa1eLnwDYxYxQPaKEZoAYkm+vAJMON12eN+O9NafU/kCE7ck3/rNrW0Nt/J26E1uNuO9zTHT5d7QnmEOjGvtgPq6fZNBeClCMZLZJgmtbQ4f4IAdMPaTDCx4OIrvXVKWFYGXZ5NASmbpUHoH6MwXvV/gVfd9FVnLFBfuIiXY78q4EjR0wo/Wsbelqfbsba/4G8/8TSuqZvGJ8lSFGeBvTDR+21x0LJCjK7tU594zj7EaEWcf6l2hY/maPpGGrtsOrg9DOC5HKVU54y8fK/9pRruvFNs3xzUig8orEOHEP2ZCdjSq+ZiC0pj9IT+VQy8b4EYZxWeXCbb+JXReNu2BRZcvb0Hh/KSq3LgC3S1AhUVwM5Nx5J4EWPabmmfm7Y6KB6VszE+nhXCTLUqC0ogDvQ13I2OMsf8B2aO3E+3L82hwNCP1Ds219piLCZZZEM2Fxb+a1B8FFGL6qVmEKfc2x8BXb3m3NAwpHdZhhiJMqmjbtoda9nwz79yxRilwLlIr5qu9cSpmCIGtyigK1yoCv5PyiA0lOXfwNRZHsUOJK1VLWcW4iZX4JxHIbQmEXFdgl7FyY20TVvf7eEPU586EBZkIiT2NC01kIjyU822NQ279SjcwUg7ScB210osbgOX5ebzzvoEt45mZ1OMhT9Iuzy7fk7LoxNaB+xoiQFfIXPjMPGqCrhkXiMAv6UJLZxifYFJad6ARJrtusmhRnlwYCYoAvcG/xIiKGYVsvqRia+RkxwirkmlQzhKglfUqa484wGBb6xWuafzSn1tglEs/fiyKiSU3BruwEvHGF50Tk8EdjApOxT+RvZZ9mmASDavux/ozVJc546bsoZDZVZLJ
 SqhiiQYX
 GQb8NkZK7v/OlnoVbYE/TZYFJoEnMajW7onD3h5yZSf4V3qQy+w6iixutRG3v4A4fGQBZFeyyH6E8UapHbo5QY8oPdKbXYASRMuHfizuOcuoS+HJvM+6Z+WBRXmwVo7btFYLcIPm5qEOsphVMssoIz/2qg3RxiQzfOGZOYFktiiBoWKG/6cIDpXMt0o1mKQtKNChqSPw4zE/Knn8jbHsEz/KuS8MYM0LSeOtLVIfMHZ7y0UcHSFIJQFP5EvFfBeFLDdIC1BZfcM+o3AOFYiVExZO3bNiCmjubgXisC4oEy4akFwnr2GXkaR5T9dK0yQiYECwZD+XmFi/0R2gEXVgrlQ02GkDodnUzPJuM+lgUSTP1Y01UiFCGDl9JfVrFQgTknpEpKOkf+0HiqKMrUuQKKQpW9x71ViJwuDz2qpqoO9zSNENz3yFQhRRElitypc0fEAOaO3YI7JC1sEl+gVCSBkQh/A9hnIna/LN2dDc9RoPxFcvhPuYOg7+YajxUlzelbGz3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The shrinker for unused huge tmpfs folios can dereference a NULL memcg
if it races with the migration of the folio at the end of a file.

folio_memcg_list_lru_alloc() assumes that folio_memcg() is never NULL.
But it is NULL until the folio is charged, and a migration target can be
in the page cache before charging.

shmem_unused_huge_shrink() looks the folio up without the folio lock,
so we can race with migration:

    __migrate_folio()               shmem_unused_huge_shrink()
    =================               ==========================
    __folio_migrate_mapping()
      xas_store(newfolio)
                                    filemap_get_entry()
                                      returns newfolio
                                    folio_trylock() fails
                                    shmem_unused_huge_requeue()
                                      folio_memcg_list_lru_alloc()
                                        folio_memcg() is NULL
                                        memcg->kmemcg_id
    folio_migrate_flags()
      mem_cgroup_migrate()
        commit_charge(newfolio)

Fix it by keeping the original objcg around while the inode is isolated.

Fixes: 743e7d025d2f ("mm: shmem: make unused huge shrinker memcg aware")
Suggested-by: Qi Zheng <qi.zheng@linux.dev>
Signed-off-by: Chris Mason <mason@kernel.org>
---

Notes:
    v1->v2: adopt Qi Zheng's suggestion to return early in the
    failure path

 mm/shmem.c | 39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 10cef89b00b08..901cfd15bdbd0 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -758,6 +758,13 @@ shmem_unused_huge_alloc_lru(struct shmem_sb_info *sbinfo, struct folio *folio,
 {
 	int ret;
 
+	/*
+	 * A migration target is in the page cache before it is charged. Once
+	 * charged, its objcg can't change while we hold a folio reference.
+	 */
+	if (!mem_cgroup_disabled() && !folio_memcg_charged(folio))
+		return ERR_PTR(-EAGAIN);
+
 	ret = folio_memcg_list_lru_alloc(folio, &sbinfo->shrinklist, gfp);
 	if (ret)
 		return ERR_PTR(ret);
@@ -887,12 +894,11 @@ static enum lru_status shmem_unused_huge_isolate(struct list_head *item,
 		return LRU_REMOVED;
 	}
 
+	/* keep shrinklist_objcg, requeue may need it */
 	list_lru_isolate(lru, item);
-	objcg = shmem_get_and_clear_objcg(info);
 	set_shmem_unused_huge_isolated(info);
 	list_add_tail(&info->shrinklist, &scan->list);
 	spin_unlock(&info->lock);
-	obj_cgroup_put(objcg);
 
 	return LRU_REMOVED;
 }
@@ -928,10 +934,26 @@ static bool is_shmem_unused_huge_match(struct folio *folio,
 static void shmem_unused_huge_drop(struct inode *inode)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct obj_cgroup *objcg;
 
 	spin_lock(&info->lock);
 	list_del_init(&info->shrinklist);
+	objcg = shmem_get_and_clear_objcg(info);
 	spin_unlock(&info->lock);
+
+	obj_cgroup_put(objcg);
+}
+
+static void shmem_unused_huge_requeue_locked(struct shmem_inode_info *info,
+					     struct shmem_sb_info *sbinfo,
+					     int nid)
+{
+	lockdep_assert_held(&info->lock);
+
+	list_del_init(&info->shrinklist);
+	shmem_unused_huge_lru_add(sbinfo, &info->shrinklist, nid,
+				  info->shrinklist_objcg);
+	info->shrinklist_nid = nid;
 }
 
 static void shmem_unused_huge_requeue(struct inode *inode, struct folio *folio)
@@ -943,17 +965,18 @@ static void shmem_unused_huge_requeue(struct inode *inode, struct folio *folio)
 
 	objcg = shmem_unused_huge_alloc_lru(sbinfo, folio, GFP_NOWAIT);
 	if (IS_ERR(objcg)) {
-		shmem_unused_huge_drop(inode);
+		spin_lock(&info->lock);
+		shmem_unused_huge_requeue_locked(info, sbinfo, nid);
+		spin_unlock(&info->lock);
 		return;
 	}
 
 	spin_lock(&info->lock);
-	/* Requeue the inode to shrinklist */
-	list_del_init(&info->shrinklist);
-	shmem_unused_huge_lru_add(sbinfo, &info->shrinklist, nid, objcg);
-	info->shrinklist_objcg = objcg;
-	info->shrinklist_nid = nid;
+	swap(info->shrinklist_objcg, objcg);
+	shmem_unused_huge_requeue_locked(info, sbinfo, nid);
 	spin_unlock(&info->lock);
+
+	obj_cgroup_put(objcg);
 }
 
 static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
-- 
2.55.0


