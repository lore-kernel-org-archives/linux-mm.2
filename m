Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FEB3606A330
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 19:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GjEL9/j9
Received: by kanga.kvack.org (Postfix)
	id 0D34D6B06DF; Thu, 19 Nov 2026 14:37:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ACFA6B06E0; Thu, 19 Nov 2026 14:37:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2D026B06E2; Thu, 19 Nov 2026 14:37:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADB3E6B06DF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:37:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2FBAC1A0C34
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:37:04 +0000 (UTC)
X-FDA: 85452876768.05.7C2A00A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9F382160005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:37:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GjEL9/j9";
	spf=pass (imf08.hostedemail.com: domain of mason@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mason@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795117021;
	b=MvVbUAdeeO1ySKSXGWzH+C9dXANKB06RiXVIHkXq//gNItSTWJ+BlhBoNgxY6nnw7KHQ2g
	3vGSb5k4JpU6g1Kza8AHHBPZxqKwACTOhMryaNB8hBPvt6QcHpN3+JXAraLzoq5IQb59tR
	HP1yQw6phAzP1BW+hAf9B/x8U124YHs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GjEL9/j9";
	spf=pass (imf08.hostedemail.com: domain of mason@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mason@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795117021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nbSaTv00XrnS3z4ynTuPVvGI4QPJtySnEbRJHnCVwLg=;
	b=c30UM9CnaxTxVWoXecAHIAGNxghYdlKQVh7ASFCqOdJdO9GdqqHU6kXdo1uB6Ch05z1/zv
	Fyncxm/8SnfBcxAThh7iB19Vh2T5pqdkBnLl9ENWyX4zd5uMFpE0Oc/xtiDKkx3uWsDvOe
	wirkSPCN8rEc0qz3TgZylNCrtPY9A1c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C0086224D;
	Thu, 19 Nov 2026 19:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7701F000C5;
	Thu, 19 Nov 2026 19:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795117020;
	bh=nbSaTv00XrnS3z4ynTuPVvGI4QPJtySnEbRJHnCVwLg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=GjEL9/j9g/k9ifKAZo2phRjhiZdSeIum7AHbliPM4QvstJODJ614SblVkVz1CDAQQ
	 mC60F3WehuYdg9PEm4VBCOns83QhMyw+5s1EO68ffsj9JwjknZ8kNxp7LiNm3Qeq0U
	 ryCMByRFIolAID10nuVBJJyVUkv+nMW/F1TpQVpsTQuQ2DVrKn3A6s5/me+lTXmJ05
	 LB2jQsm9epFt3tXqUZRxOeZeDz6bxJbCU3jIixUiujHf9KL9akYsvRLE+5Bgch4wx1
	 3HrW6+tcJxGKYOjTpf+sWgNLsoELEN7ILuwjmXzfcjF3DeeraQ3haE2tEFZpO+0ZjZ
	 ccmSiT/beQvww==
From: Chris Mason <mason@kernel.org>
To: hughd@google.com,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	qi.zheng@linux.dev,
	qinyuntan@linux.alibaba.com,
	shakeel.butt@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] mm/shmem: don't use the memcg of an uncharged folio
Date: Thu, 19 Nov 2026 14:36:57 -0500
Message-ID: <20261119193656.88678-2-mason@kernel.org>
In-Reply-To: <20261119193656.88678-1-mason@kernel.org>
References: <20261119193656.88678-1-mason@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9F382160005
X-Stat-Signature: poxrzi1ar8wqzpfcewo89ebf9bsu8e1n
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795117021-313767
X-HE-Meta: U2FsdGVkX1+E8r5XT0/2sFT4uPtqdVTF22vmdfcViNcMD34ycyweBuzYbiEncvIvah26QcN4Yjk93DT7f0f4qtZ3R5lYrAPGD5GlokiY5apsJrT2aZJnpI/hDCAachjtJlaiAvpemL1b0FbXfAJKsERUvWV5LDOWPH9NkG4Km1l2mn18PJy79Cs6a5rHQMUqgyLtM+Psh/4QLcdPrmkqiIg8L7x+q/ZJd7PEf3yuY3LuKEMKioe98XXP3xpHapp/BoLs7RR3h29ms+2KC2wSA2In4IJoNi9N5tMflIlIVaugWWmjjMUXoP1Ln5nushqXb/mljHjfCi/XlVnLLHkf5LiyBSoZ6am7fvjs2koG8dRxHTjsB+e/eErPRZH2nLuNhJeo8e/sGU9Ul1xzOsi5EoC7FF9hAeZFcPmK1ugiWiAOMET07dlhm8jUFvOzLfBH+T7A0Zax02aF0B+XtpG5Vd56K3hii7538mOvmOSQQ2oJRfGphWV0G68tCsyS9mKVV/hd4qMJfhVF/qA1bAOrhrXguhbQ6o0AwMFopgQt3PUGU2TIo6EVjsGXb4mL+Be/PjESwHh9rzVNErE1pa2eHKHeF0HbzQZoSZjBQeRPiBpGNuZ0egEHdgWZXYV0D30EJxrf8l5sDV0nThJNw7+d36FpmGSWirA2CfXVFexqIgcRAJezHpnd9unhnIzxxDqHCsiUpqO9prVZJnYUzuMl8JgUKKShX4uIad8q1Ihadc+Z8bDGpZDLMI3hA2DaFmor/TDhbXza4GWn0DXZ1RdZmhu9bejuyu3o+Dz2/y5NckY9CgfO3K27xEq5yx7OeCItuvv7fRIK7H6god0Sh2bXCesBA1EdohEUH6lIojWKvIgugBbOM4M6rIViiRT4ZjJaW8QLH3fhXtwx8XZHiYjzqzJiyCR4r7kt7Lvy3TheqriT54HH4Gruy2AtbkQ73bsSDUvLud7q/xaxx/MTASd
 bFtVQRZD
 /IOmahxY83rMtvnhUad65pndLkdcq+xYeqG5nz2MmEQ4rVEDmAIN07EdCQ5JR1P+ycRl0v7n9qxDfQdK1M3sDE5WOF5ciq/M14MlzmYe+aGBgtryxvKOGB+sRgxtzpdhYymgkNrPaG11o9lyDaRL8EHKNMoycb1vpAXFjDI3wCV2YhJY8cx50+FLptG+Ty4SUzUzi4iUGuCntyycmKNHBh61TLFXIZkSzvvyPRAQDbHVuFlaW2qXY7eOCs3zK//J50jHi4sXXqwB6I5t0EISVGMlzqg==
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
Signed-off-by: Chris Mason <mason@kernel.org>
---
 mm/shmem.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 10cef89b00b0..4465a43d6f74 100644
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
@@ -928,32 +934,41 @@ static bool is_shmem_unused_huge_match(struct folio *folio,
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
 }
 
 static void shmem_unused_huge_requeue(struct inode *inode, struct folio *folio)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
-	struct obj_cgroup *objcg;
+	struct obj_cgroup *objcg, *old_objcg;
 	int nid = folio_nid(folio);
 
 	objcg = shmem_unused_huge_alloc_lru(sbinfo, folio, GFP_NOWAIT);
-	if (IS_ERR(objcg)) {
-		shmem_unused_huge_drop(inode);
-		return;
-	}
 
 	spin_lock(&info->lock);
+	old_objcg = shmem_get_and_clear_objcg(info);
+	/* The lists for old_objcg exist, the inode was queued under it */
+	if (IS_ERR(objcg)) {
+		objcg = old_objcg;
+		old_objcg = NULL;
+	}
+
 	/* Requeue the inode to shrinklist */
 	list_del_init(&info->shrinklist);
 	shmem_unused_huge_lru_add(sbinfo, &info->shrinklist, nid, objcg);
 	info->shrinklist_objcg = objcg;
 	info->shrinklist_nid = nid;
 	spin_unlock(&info->lock);
+
+	obj_cgroup_put(old_objcg);
 }
 
 static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
-- 
2.55.0


