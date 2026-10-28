Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47849606A742
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LPDWlhG6
Received: by kanga.kvack.org (Postfix)
	id 4E7F76B05C4; Wed, 28 Oct 2026 11:47:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 499456B05C5; Wed, 28 Oct 2026 11:47:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 387DF6B05C6; Wed, 28 Oct 2026 11:47:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07BE66B05C4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:47:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F7421C1D73
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:47:12 +0000 (UTC)
X-FDA: 85372463904.15.B91419F
Received: from mail-pz2-f5.google.com (mail-pz2-f5.google.com [74.125.228.5])
	by imf30.hostedemail.com (Postfix) with ESMTP id 86E1180016
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:47:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LPDWlhG6;
	spf=pass (imf30.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.228.5 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793202430;
	b=4KN/TWfaqJACnWW1U/COSZCeBWvT3oyk8S2CClvKiuM8FendKZdiMLtEPOQGor2BglSmOr
	ImnlRNwhDMbn2evVp8lfyqL1/ojuAPiaWw7UKLB0rJYRdvpEKpUXXqC/Z2tcwCnJRA5R0A
	yUGh0QeLczEQnme69UL+DFfanusnH68=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LPDWlhG6;
	spf=pass (imf30.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.228.5 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793202430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kDf0N2qKy2D5WoUW21DkgIjyXDWbzLDsDhnlR4wrAP4=;
	b=68kEMuTO2or4/DKpXhxadCHfQ7fxbt3VgtAm/kHjcGIiXjQgSI/D/XQswsLpddo9NQD9UJ
	hv5niIVaANzERLrc6GJxrfUt/AjB9aiF5t7hJ3lkfuMMcN5kU7iuaQi8du+bHANpCFDt2f
	5Sy3CUFMbn0Wyx/TEt5YUcWl6XIqy88=
Received: by mail-pz2-f5.google.com with SMTP id 41be03b00d2f7-cdae9336a3eso187839a12.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793202429; x=1793807229; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:cc
         :to:subject:date:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kDf0N2qKy2D5WoUW21DkgIjyXDWbzLDsDhnlR4wrAP4=;
        b=LPDWlhG6GhMHj3TWMNgzLU07XN2FUz5L+1luk7tNmPhCr4QmsnH4HA8PbExtu0bkNr
         4x37OY3DtPrkcEqiEzdr2byKOm6oIxvY75ouBzW29rYHPuinhqOJQLWxqDe8q/adHvln
         7k5uLSsEM/cmXE7X2vIPwFkW6kx7w/wMaadnVShdnVwH4OUz/yjf0D/Ql1sauF3iNg61
         zTamnX0EQITMhOkSiOQqHtGWH70XnfDUBW1lkJ4ClJeUmMXMgSL4CsyfkhhsdvmwHTc+
         odIp2MMRjga+YXIYEDjiZW88pckiIGR3jllnVrIOKjFgrXZbHXoRiqYe4+WURs6oKkCp
         NFXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793202429; x=1793807229;
        h=content-transfer-encoding:content-type:mime-version:message-id:cc
         :to:subject:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kDf0N2qKy2D5WoUW21DkgIjyXDWbzLDsDhnlR4wrAP4=;
        b=UViYnSa1Atk0iDwVK/Pgcjx1ZuWbgbrc9B7hUtIxQWAZgzG8bpXiOIWflzqBfjckCz
         aAFSb4Nk2nSngIsg+F0J57/bPGW7bEh+Ao9t47vdM4IfViCHYatU0o9nZKTXDmpfAnLd
         EPe4jlR2OpZ/flq1kGUvVHVRu63gBtAMNldm5BGK3e6jT8SmRDjtFpCmYjYMKePRiS61
         UeaWKgdLCmlw57tzAv1oYZnNCHMf7jueZ277eYOjh66pjzJyhucZlquK/ttfEJdUgX+Z
         7Kdz/RRFC5zrlipmSXDFXETOtoQTkSnvMYlJlBpTNpMfbpIZQ/OIJeik9zy5vNO0G83F
         Cg0A==
X-Forwarded-Encrypted: i=1; AKwUvByiLQ/PzR1sXV5EGbbXUJtfCBCG14EMEgdG7BhrI/oLp9AqFfLN1ZdAbHRAVysXVzktB60G8d8qqA==@kvack.org
X-Gm-Message-State: AFq9FYI0LEejBzUp9o1GwXKS4/VF65d2VbvsFweme9LpYmcWo3piVA5n
	Xp8oAjf3UeAMTpyTznpjocWgaCl73uNoVVTyNz5vZ066Bz/vQK1VJ64Y
X-Gm-Gg: AYBFou2whhQo8iGW1eXIWRhtzj1ktrKiiYsONs22UkhjRknYPIw0qphexhUYzE9CV8N
	TGKKK0UQGm+N7b3OVKF/fHLEXKrOyhGZdUIe0Y0lTafjienFU2GCU/B2EF50yh4dfem9qnp1qGw
	NsNelZzx14TXg7VekWyAXVNz2fO1CwaafXQXIMD2yA5kqzxk28bIHfjRKzBk9iuNsLYLpqB8uRN
	x0UWKN7SwfhF4a46SuhYM/bBmG392CEvJbVMR/m4V/CuUWBk2UcfHT1kown22VBKUI0gSrnwOfB
	CEsNgWNP/K1uzkZcfVdCW7rY6g+E1Y+sfxi5GKynyNB8l9yisXBdnYbi1kt4pDJy4W/fCDqmw9J
	hSXUku9MBykXLAOVl542raKo7jPK04prVPNy0GW41NEFr+ReFtz4xBgiFgEUBZiS/AhgtlNkTHu
	CUoOWgk+CJRhxpRuFalzeMrRc7PZEaz9U5AjdR1occeTZMV47ob/RQx+lh94y7JNB+QrrySCkKt
	ZFYKZP2TLBeU1gGfTHnFxOR714UfyvtoNMz3XGLRn5C0WBD2r74Jb2BN9di9TlnugdFUcy4VJI+
	xmJMti0QxFfxaWRKd/wt3cJQ2wAQ/uBR5m8b3OG6lsHGg7uts2rFY07YoZaRTOQ8vUpISVRbOya
	lSOy79dGeJlMFg9QYZPqSqpdK/w==
X-Received: by 2002:a05:6a00:3493:b0:8a0:2344:c44b with SMTP id d2e1a72fcca58-8a6e8b8347fmr2113647b3a.40.1793202428981;
        Wed, 28 Oct 2026 08:47:08 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a5f66bcesm1375802b3a.15.2026.10.28.08.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 08:47:08 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
Date: Thu, 29 Oct 2026 00:05:46 +1100
Subject: [PATCH] mm/damon: skip folios already on the migration target node
To: SJ Park <sj@kernel.org>,
    Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
    linux-mm@kvack.org,
    linux-kernel@vger.kernel.org,
    Bijan Tabatabai <bijan311@gmail.com>,
    Bijan Tabatabai <bijantabatab@micron.com>
Message-ID: <179320218513.2.7432933245840036676.damon-same-node-skip@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 86E1180016
X-Stat-Signature: poy5rz4zk4aecd4gbhukk8ayyy3czk6o
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793202430-141448
X-HE-Meta: U2FsdGVkX1/sbBJtOOuukO4QHFYjRRM9vSzA1VeJ+pBkF6GWyIO+XEf3Xst2m9TKh3yXwjiMDfzerfXE8MqpF4EXpOhREQ1N20HFjcPeeOKGxixdcofvxZ+j5jagsoJmOHHUjJcK4op8YpU1pSYP8T4MYpR2tV4Q7RDdOoGiglFG/N5c44xEbM/dIKOwOfQyiwjR0LjU6rM3Yypo/qSLOI6HxLZW60SqiPye3aOgJYklvJ6m3j03fMgjV9FVqlUU5M+OZ5RLlRB0RUKiWlrCUdJX69zwZWiVLt94+aICLoNtCdoIbo5Jueith0Sg2yDEMhJpeKE/gq4FYHZc7cN4xCUnqaIyw1hBqpr764ig7K9JgnyFF8Mfv8uyKsSVh/swcaWoNKyxriQedmJl3JsRX4IFEloYNO+Y/ARwL665GUKtE26c1IakGC4mqsnJ9btQJ2bBcPrCaAHP30OnPSjRyvXDypnibiESTvG2Kel3jAPcdMueGe178/9bHq4mJToNG+iPDV7Dqa8Jo8p38yY7T5B0nJ4aC9s5MI1TM4CF/hubCG3mtp+JaiVCEgKP8GNNDgqAQe5sZRpmdZKOuHpVYpJSDUCWt1W23GH48egqMGLhJ27etfKC+2sKbzFRzm80gp8YV/qUGhq+pWi4w1x4HOuaw+8tVlolVPICu94UtUz1YKbqrxKr6T15hObbfoaKSbIHu4CIo119ahsMZbcC+7ye3LwfhW4TDR3/l/DeFmYxuRhn9aD+zne8ZuW50ILjYWu3wd7Nt1Cm3SDlgpgupgmU4/3/XqMwUSlnJL3JdulKL3wccVYvYKd67dvGGovi/Y6TZP8vBpnqLP/hAAJHmCba+iVnv8KJXC1ZpGPgwJ4bufZVpODjvHAo6ZPnxAWk7wTDl1Sag+adk9lVP4m/DThb5V+HD4+nwWw8jReyQctt4WzPlxvrNQNg8cUT4vZcl1si+QiqyVPaPnfUGmv
 YWj34rZW
 Rj5I2b7Wz3rI7JCl0p+WNDnGEk4zASWtoySWQdqw6b+2CEjm9fKGEODl3MGrSOOqVPcdcii9AD4ngcVXTEmAj7XTpnmakXJ0HlZSS3ww6Sq2LN+MwRXK87eL3+8+GxWYcMxhPqGZN8neb73wgTFrrVEjv/5pCXnZZGqVQFBwA8NsClvHKI4VHzDUmP9QhlDgF0K3uOfDqkeu1tadLBHqs7HHweBDzCyfggCNSRgb/WKwSUYwv7DUc/tpxkvDUkQB/xAsyvoSAYylr/sPvltOBjV6XH+Ekr0YKfyse+1tNEBq1oN7iejTwoi0vHzLA99OAjdCJ+TsC0zgxOEb4dd8IYWL2QkhhEgRFJzs0eCYVip/VKRe540T/wavRcugJG5BrSu/4PoEyNeHMq+kL+0i51DpfrDlQmL+2cgtDB7ux4m/KhlY2HJrfuEliPLKKNHYOxxsTMSE3AUumbaUUr3EtyYfT0ag0kiuajKpdUFtUbHEzT3h8bpNqkUTOYWQorsKw3Kpv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

While measuring DAMOS migration overhead, I found that the target_nid
path isolates folios already on the target node, then puts them back on
the LRU without migrating them.

Skip them before isolation in vaddr and paddr, as the vaddr explicit
destinations path already does.

Signed-off-by: Aveline Noir <jm5905938@gmail.com>

---
DAMON KUnit and selftests all passed. In a synthetic same-node fvaddr
test on a two-node x86-64 KVM guest (8 interleaved runs per kernel),
guest-kernel cycles fell by about 29%
with 4 KiB regions and 90% with 16 MiB regions. Median kdamond CPU
time fell by about 76% with 16 MiB regions, with no clear change
with 4 KiB regions.
---
 mm/damon/paddr.c |  2 ++
 mm/damon/vaddr.c | 22 ++++++++++++----------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 2cfdc356b415..5b773012a876 100644
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
index b549496ea8e2..cd71fb1ac209 100644
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
@@ -858,8 +860,8 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 			goto huge_out;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
 			goto huge_out;
-		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
-				migration_lists);
+		damos_va_migrate_dests_add(folio, walk->vma, addr, s,
+					   migration_lists);
 huge_out:
 		spin_unlock(ptl);
 		return 0;
@@ -883,8 +885,8 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 			continue;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
 			continue;
-		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
-				migration_lists);
+		damos_va_migrate_dests_add(folio, walk->vma, addr, s,
+					   migration_lists);
 		page_idx = folio_page_idx(folio, pte_page(ptent));
 		nr = folio_nr_pages(folio) - page_idx;
 	}

base-commit: d865f2677c44cb2171b833d6775cf692756fa8be
-- 
2.56.0


