Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FBEE606CEFE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cCgQyS4g
Received: by kanga.kvack.org (Postfix)
	id 3E5006B05DC; Mon,  2 Nov 2026 10:08:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36F9D6B05DD; Mon,  2 Nov 2026 10:08:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ABEA6B05DF; Mon,  2 Nov 2026 10:08:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECD4C6B05DD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:08:09 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BF80140165
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:09 +0000 (UTC)
X-FDA: 85390509498.23.52B91AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id DD11C16000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cCgQyS4g;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+IKR9RbbuGuGx/yVom6rw6BPG5GNPAbNpjwaKg4rCb0=;
	b=6wjAaXqGRPD2ySbYTuXTjKQpoYfYc/vOWJ5JTMQvPeOHEK/LjkPsRsh30W2QeZXRXRc9BB
	vqvbQqGoghI1BUOFv0fyZu3OfGDKoEib7QSWJPVP4D4XoPml0vTY150n++EZy6lvDCOhGX
	B+NLw88UleknP2/ydh5tEbzzFGh7/h8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cCgQyS4g;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632087;
	b=fj9refR6QS/eDMwZU3+wQLoXIkFLS84s9uOGaKsOZLM2p0jd8Yg1AdUTu4hswih+JSFyAu
	UyJUdPvpsCySLKlLiu6m9nm6ZeDtpGdDg0UiSbhDJOb5OrLL4/wG6oisZePXyYJu0Iifnh
	0Jffeo8hVkjvdDQWPzd6h4IPEgMPo20=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B6CD605D0;
	Mon,  2 Nov 2026 15:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5A01F00A26;
	Mon,  2 Nov 2026 15:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632087;
	bh=+IKR9RbbuGuGx/yVom6rw6BPG5GNPAbNpjwaKg4rCb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCgQyS4gxgKrL6ivpISet83poV/dEhRXOe58Rztq6mhqbAx0PILnDAQbC2eGQZoxz
	 P5GXEwFJJa5546UnO1Szdjt0UbXAwPhU6BI4rbfKV/ZT6A2ODGnTfq2pa1ZSPjMh+O
	 QsSdlLfZKb4tHBcBLnViwunT9CLdEgNQyAi3ZqKFIlK/pyhQVZG3g1qFoswzDAHcXQ
	 bKPLwqxyv7LcL/fttn+G4UzuWC49D85BiOkz6T8McRV06dm5tfNOT6LfwRV1+lQcVm
	 LWC5uFbIqdpyeg4YzcU2Sup7ATcad4o/WCt/llXv7TDQhx746G4pFg1OkzPRe2ZE6M
	 IkbLx7R2KynxQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	Bijan Tabatabai <bijan311@gmail.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/9] mm/damon/{p,v}addr: skip folios already on the migration target node
Date: Mon,  2 Nov 2026 07:07:52 -0800
Message-ID: <20261102150757.93058-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102150757.93058-1-sj@kernel.org>
References: <20261102150757.93058-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD11C16000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ikis8mogmy9znh3hoa9jpkt5ba8n6pbw
X-HE-Tag: 1793632087-782276
X-HE-Meta: U2FsdGVkX18/OqX32dvd6nmI+kYJ9gtwLZsaaK9DFhIRIC7bPG1zTA5FZ62Q1NFCZkd2cicvCw4W2VD7kikRSgIjjt0yf6aCoRPUNCVFjCLXmRcLTOM8Eq6YwG4SfMizKjj2PKwpAPCspqTAFYbjLHMWErW+L2yIMs4563N1DB0KVjFtMdUrvW350Uxev77Gz2E8S/03JPZYPOicLlLRhPhmgDCTZmUkRKePYjE8TvXcLd3ajC48MS56ohcF2lWl9RN/a0O3jPNlar/hEjmJ85G6+VtSkGoax4xAUfrZftRlbd/aa5MsL58BvEgCM/Kd0RuXTEj6gv8tjO0wVtyk2LqfqbpHSRZqz+ib0qB7fLLPOni6XHcaCBhfwVjk2j4CayJV8tZLzstr05hyUOq6zW8wT1AZmic7DWgegPLot/fex+fEw3FUg1zDgXlP4APQH2xC7KwH/iSGutdrgpn23ADlA5EOsEuojQAsDD4Lgg8QA24g6y+zSwMTY0DA3zQ7Zx1y77lyXpG+Wm8SMv8iA6pkCY3jxkOAr8r1SFHvZROUM830/vqUvhxDVFxxW+CY6HVB9WVY/LUGvOkIyr65R0Hl5lrSC7qfh/ti5d+K1cD6tmk0lCm6+puoTcDc6wFN9D5JeT7bWGdGr+P5AikSDRiYGM1sgzJ3ETYPYAGrYIpouI4BlBABlmymR3qg4WKa1OgnjMWWiB+oFUt9bTyX4gMWUQyWZ+4zVsM8thnRugTZ6fH4stzuK24WS9dzVcmQGxqdyf+j6YKlIDPmxp7Wp7YZXtMsX0CWpMFPlQA8Fch8yLY20WIq4BRmWjyATJpDRQKeCq8W9vy2R251cDwKLHu7q4T/+2Ne2dV4XHhyO/hxQ2HtuG146ThuJ4oVh6OHI66PnhaOmJLR1MSUmg/MupkwRmVieTPY0/tEAItWdmCpf425wB/eiLex1yZ+CXNpvPJF+RZ1SiRZbEbmsbH
 HxubOkBn
 KoyVf6M4mySkYwfuS98Aan9aqt4oZtzp4xASdRRBCjkxM/fgkHpzlHjHqr9KuVj2BX8sb9KT1lTUiX4T7IqaV0/ygkBZTaO6Rfn+4D1tyvJNV2cEZmEoM5+hah0zTJW+KnETr/CvCsXMd2IzP+spPNc9Xm96FvjHdUxCyJgGgx2O0NHenCEov+38200HzmkFYJxn3O62ZrBoAxsge7DLn7MbzPmw82+1+S19cRFmCHN0X6tfTiDURYh07/6GMZyq23VU6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Aveline Noir <jm5905938@gmail.com>

While measuring DAMOS migration overhead, I found that the target_nid
path isolates folios already on the target node, then puts them back on
the LRU without migrating them.

Skip them before isolation in vaddr and paddr, as the vaddr explicit
destinations path already does.

In a synthetic same-node fvaddr test on a two-node x86-64 KVM guest (8
interleaved runs per kernel), guest-kernel cycles fell by about 29% with
4 KiB regions and 90% with 16 MiB regions. Median kdamond CPU time fell
by about 76% with 16 MiB regions, with no clear change with 4 KiB
regions.

Cc: Bijan Tabatabai <bijan311@gmail.com>
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/179320218513.2.7432933245840036676.damon-same-node-skip@gmail.com
- Put performance results in commit message.
- Use two tabs indentation for second parameter lines.
- Collect R-b: from SJ.
- Rebase to latest mm-new.

 mm/damon/paddr.c |  2 ++
 mm/damon/vaddr.c | 18 ++++++++++--------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 2cfdc356b4157..5b773012a8764 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -368,6 +368,8 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 		else
 			*sz_filter_passed += folio_size(folio) / addr_unit;
 
+		if (folio_nid(folio) == s->target_nid)
+			goto put_folio;
 		if (!folio_isolate_lru(folio))
 			goto put_folio;
 		node_stat_add_folio(folio, NR_ISOLATED_ANON +
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index b549496ea8e2c..1e65e7651cd98 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -786,14 +786,15 @@ struct damos_va_migrate_private {
  */
 static void damos_va_migrate_dests_add(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr,
-		struct damos_migrate_dests *dests,
+		struct damos *s,
 		struct list_head *migration_lists)
 {
+	struct damos_migrate_dests *dests = &s->migrate_dests;
 	pgoff_t ilx;
 	int order;
 	unsigned int target;
 	unsigned int weight_total = 0;
-	int i;
+	int i, nid;
 
 	/*
 	 * If dests is empty, there is only one migration list corresponding
@@ -801,7 +802,8 @@ static void damos_va_migrate_dests_add(struct folio *folio,
 	 */
 	if (!dests->nr_dests) {
 		i = 0;
-		goto isolate;
+		nid = s->target_nid;
+		goto check_nid;
 	}
 
 	order = folio_order(folio);
@@ -821,12 +823,13 @@ static void damos_va_migrate_dests_add(struct folio *folio,
 			break;
 		target -= dests->weight_arr[i];
 	}
+	nid = dests->node_id_arr[i];
 
+check_nid:
 	/* If the folio is already in the right node, don't do anything */
-	if (folio_nid(folio) == dests->node_id_arr[i])
+	if (folio_nid(folio) == nid)
 		return;
 
-isolate:
 	if (!folio_isolate_lru(folio))
 		return;
 	node_stat_add_folio(folio, NR_ISOLATED_ANON +
@@ -840,7 +843,6 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct damos_va_migrate_private *priv = walk->private;
 	struct list_head *migration_lists = priv->migration_lists;
 	struct damos *s = priv->scheme;
-	struct damos_migrate_dests *dests = &s->migrate_dests;
 	struct folio *folio;
 	spinlock_t *ptl;
 	pte_t *start_pte, *pte, ptent;
@@ -858,7 +860,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 			goto huge_out;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
 			goto huge_out;
-		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
+		damos_va_migrate_dests_add(folio, walk->vma, addr, s,
 				migration_lists);
 huge_out:
 		spin_unlock(ptl);
@@ -883,7 +885,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 			continue;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
 			continue;
-		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
+		damos_va_migrate_dests_add(folio, walk->vma, addr, s,
 				migration_lists);
 		page_idx = folio_page_idx(folio, pte_page(ptent));
 		nr = folio_nr_pages(folio) - page_idx;
-- 
2.47.3

