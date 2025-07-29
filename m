Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E07C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 13:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5E706B009F; Tue, 29 Jul 2025 09:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D361D6B00A0; Tue, 29 Jul 2025 09:53:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C24846B00A1; Tue, 29 Jul 2025 09:53:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B3CA76B009F
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:53:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62B6ABA5AB
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:53:39 +0000 (UTC)
X-FDA: 83717444958.30.0832CCC
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 77356C000C
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:53:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LD87H3qg;
	spf=pass (imf28.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753797217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7iBOO3HPD83Wia82eo/Lz71fr158dDJN9X6lTtZnvkw=;
	b=w7J9ydsfvhTs0q7pD4qYfjVWiYE3tQ5kX5cTOXPU98++mfylQvb63rUdKZG6GTCoJLt56Q
	dRmelAMJW24mbDOaVof006BT2d5bglrKol4OeqfCMskjFjKmvls4Gte5dgHmVxlZCSq1yd
	ljj3A77Iawvc3Glp+M081QWEf8v7Kt0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LD87H3qg;
	spf=pass (imf28.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753797217; a=rsa-sha256;
	cv=none;
	b=NYyxfvEYZJlP1Lj69atIuaPWQ8Fj/bLYZ0sc7wjrcjyDMYFIBLesUPyGU+7PHlnfZL2+yN
	xEddaEbULmh5dk6sPx70FcByCQbAHwhPWbNzrAnCN0h1fNJ6bEpGAZfgNbK0XpN49TIPdm
	C9n+CKbfPqAoJ3HP/VNSdwa2LVcwXmU=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4563cfac2d2so58092025e9.3
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 06:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753797216; x=1754402016; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7iBOO3HPD83Wia82eo/Lz71fr158dDJN9X6lTtZnvkw=;
        b=LD87H3qg3V7OgkVoUl7H/ZWgHrn6Z/qSZbgtyWHR5R2ZSK7nXiW4S5oZQVjAS7XRIg
         TOH+NnZ2kKt5gyOG9OnwONbrG4VM9Trtvw2m4iV16JFovNSoMMh0C501SC6zcgyjTNIF
         GRnDg9tOpO4kA/mHDZaFg1JF7hblL+Jjcuh6nuQUHeE54oLekP5iQFzP2dp1tzsyv7nV
         A1U7kwjasYZNOTtib2uYOLpxX0feSAISHqD3pbZ41jbaZvSi2hjXqyopjwSmfacJ0xjY
         URO0c/aunFsWHpKlY2MMpusx9nQ4rRq2o+Q89wTfEZOZP31qpnbJSUNK8pl8OnJ59ZDA
         72og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753797216; x=1754402016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7iBOO3HPD83Wia82eo/Lz71fr158dDJN9X6lTtZnvkw=;
        b=uWCoiBWWIVv4NuhvRSsS1jnBmxhnF0XXY6E3fODwhTiSJlgMtI/Ff1/CBLPYJNTgO9
         k/Qr3q/AKdzYePacTwYjgaCzWLSqoVk/p6/RmMaZSSAdVLCo5Qo8dNzFhAfdHVLsvbdj
         NJY77lZFBfJt/k6+f2a4Qs7gz992nyUuX7R+zLQ6DtqSBy2RRvAri1vepeW36Kwaityp
         WUDkxHIeUriD293Fkf0k/XdibGiYwLsx/mss+M7MD2jsGJRYgqIDAOhorj9UQcsVzqbP
         /TkLLv1WviwhRLw4laH0MuyVcNWYsY/ygXD9fC9pZn5Qm4J2I7zcg5Ys/erI61Q8lYz/
         cCxg==
X-Forwarded-Encrypted: i=1; AJvYcCX9jdUIramyBVPzwvjEhbxtBPRXzxIBTNx+KP7GUmhsBQ0Xv+ir1kq3YMbuzRBr8EFG/wXCfiCwnw==@kvack.org
X-Gm-Message-State: AOJu0Yy8DNKVYQo5pO+QsWY9MUKYDeVC/WyppNxGi6ggPZTt9zf6yRYS
	7nZlRmcSS9p81p4j6QKPa/4q8jvUF18JHln2XTjpCRV7qwclHJAxp4NU
X-Gm-Gg: ASbGncup92c1GeFEQ08p3ZgShyoB/FoLSG3dp/Tre5xFyLA1mUeaDfY1seyavF1oQq8
	j28jKFM/XX6ymqoEnQ8hVyv0avyMvGNE+4PnDTC1v2rpu84McFNb6lAE55F40VpsL0QUaUKkKhh
	ktx8+WRkpaTIlAEUQRSGDqopmA6ISj1Cq1yb5iMobizgdLIqY0Ja3IuPxeEte2PjdWA+MU9PnUu
	XUPGG/6C1Yfk3UJnBjzqQKt/gd4UvdUOBx4ays4vxIHZSZom8IDFyfET4AwLAgya8WG8Z6pr3Q+
	aBfJY+3bCmmVRwYw1sL/5it11fZFKTm/A/witJl+mEiRNjpuHfOTblXDsZwEx9YBCLn0p6rS51M
	u2xfAQtoVPCQRChM=
X-Google-Smtp-Source: AGHT+IEIprs1zggr9FmpwKbpcHvwinjoIgq8TSbS938lrRqegcHD6kkTnyQRwqNGGJHiAYpAFwrfXA==
X-Received: by 2002:a5d:5f93:0:b0:3b5:f0aa:b1e5 with SMTP id ffacd0b85a97d-3b77672df06mr9719092f8f.19.1753797215638;
        Tue, 29 Jul 2025 06:53:35 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff:4c::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b778ebaca7sm12658402f8f.30.2025.07.29.06.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 06:53:35 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	PanJason <pyyjason@gmail.com>
Subject: [PATCH v1 2/2] mm/damon: Add damos_stat support for vaddr
Date: Tue, 29 Jul 2025 06:53:30 -0700
Message-ID: <44a30f700fdcf4470318ef5cd248ba98c59b77a2.1753794408.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1753794408.git.pyyjason@gmail.com>
References: <cover.1753794408.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 77356C000C
X-Rspamd-Server: rspam06
X-Stat-Signature: zo55m95thewqzto51rnni11hcckaxt1p
X-HE-Tag: 1753797217-603310
X-HE-Meta: U2FsdGVkX195z0PEL3IiyMkxQdh9HR6TefiPRdmjlGPInzXbHArfjdWAhXkwrScCEUW5Iy+m6PbBvD6UtUvomFW9ESc3rX+8qxaC8gNNffnFjIeMwlAORniKVUBhYeZaLzF/9YovJO16991V4WKYgnJpFt+LhpompcS1crWkcTmx1LPBn+WlZaViWU964tqqpT6bVuybY+7yz3PZAk4YBWI6D6bhxvVLerOrp9qKXuOI88Z3AIC5Koth/Y26kTRLehYi961IngaqGcJOZDMXwHj1btdu5sLcIgTuudUnSBBvpG2p2IXMRE6nt1IAxpmrBBffpYkJ8GZQc3lu8i5TPS0EUwHu/aJ3VPD56SLZUg0MLGVrQex6S89/EgHQWX7220OD/ez0BhRDPiYvOzmwDGKd0ds0ApVGTmYdA6Sl6PjoMO+M/iktVoA+9b+BcwDd6tzHKMuqNOLj43Cyrqj2ETtzrhmmFavXmZxzbdXnXAsyW7KMXG8KsEPOMEs/ooHdYLbs+/aLflTwhOL3MQhQa6VfBK7Fb0rAE7r78jnaZ5juP6fs8TuK171dAqJ+L8hehGaJI+UHFV90KZQbQ6UMVYAkoWPjBLcfNnD2TxzAFbzWSpk2ZfdbYLE/bNTofn2TDVFTR5YaltWfMe20aQN8RyhiLxfaiAHj6JYA0n8vdA3f3XEVNiMlYiH4ZsdIwC2hTIteddBXzkrlHVYth/iHx8ES+c08uk0VNNd4VXxABqM9dP/Uwd1WOKdCL/C6yaKli3DXU+rYdnbu2xKv8HogHX1LKzV4UkquWJCHoVCzbxMh/JKYODYjAPOX7FLyosv9S59qOnpUn/W+nncDulyDD/jzcl9YvInODEjkUq6cQePGhL0Isz27ueVWYzThiav6RFMR1+6gs9TPqcDohdTHEm6Rg3cXuJFgKa39fSjvc3mPVudszJI1AEuI09+/OkpyGCZKYhFqE0IN+Gol9/D
 1kQtXjW0
 HQMuo/R3oIAraiY7h1exNvpE9rSctGPdWTUWcVHsl0YPcZNGQPxzI7f7eHCJmePBmK3k++xwL+9JdugS/PQVpR/rilc/rw/18jR37RuVOk76M9TfmBdLIB/MAM4QliJZSLkhuYbABdUiDYX+5iKHecMdAauVEI3LKytKoI9qnBYs6rkmwq55PF762krCXpK0ObUtWapmlBWNH844UYpwfVZzCrIUjG8mXyfKXsnhKOj8x5tFbPg2x3zz1Vat7hWdEbs8aIUifFGhQCLfxTn7f9tg0+PwjNMPdns3+8GiK5rJPbabAhNt7AK+zv3hueUtptRcU3i92Sgp5HgVYOXyXD2jfgZ1KVaYn+/69gc5WCH1wXFBO+vuKq8TNwdEdI+4exzKYSjn/FJyVSjsH1Vqebma4tGqMids4Owy9PRPCPe65GXUTQW1/nQ0vrCcejMOPHflm5hOzxtTU8wvUfVnOGcd9hB1IJMvUhrEETXu0WOJ+yeCgkyNQevdikW992wkz9fd434TKT5g5HEcxIak4xMrlCGmf/bHSO2zzG/Xu9BmSsAE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: PanJason <pyyjason@gmail.com>

This patch adds support for damos_stat in virtual address space.
It leverages the walk_page_range to walk the page table and gets
the folio from page table. The last folio scanned is stored in
damos->last_applied to prevent double counting.
---
 mm/damon/vaddr.c | 113 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 112 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 87e825349bdf..3e319b51cfd4 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -890,6 +890,117 @@ static unsigned long damos_va_migrate(struct damon_target *target,
 	return applied * PAGE_SIZE;
 }
 
+struct damos_va_stat_private {
+	struct damos *scheme;
+	unsigned long *sz_filter_passed;
+};
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
+		unsigned long next, struct mm_walk *walk)
+{
+	struct damos_va_stat_private *priv = walk->private;
+	struct damos *s = priv->scheme;
+	unsigned long *sz_filter_passed = priv->sz_filter_passed;
+	struct folio *folio;
+	spinlock_t *ptl;
+	pmd_t pmde;
+
+	ptl = pmd_lock(walk->mm, pmd);
+	pmde = pmdp_get(pmd);
+
+	if (!pmd_present(pmde) || !pmd_trans_huge(pmde))
+		goto unlock;
+
+	/* Tell page walk code to not split the PMD */
+	walk->action = ACTION_CONTINUE;
+
+	folio = damon_get_folio(pmd_pfn(pmde));
+	if (!folio)
+		goto unlock;
+
+	if (damon_invalid_damos_folio(folio, s))
+		goto update_last_applied;
+
+	if (!damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd)){
+		*sz_filter_passed += folio_size(folio);
+	}
+
+	folio_put(folio);
+update_last_applied:
+	s->last_applied = folio;
+unlock:
+	spin_unlock(ptl);
+	return 0;
+}
+#else
+#define damon_va_stat_pmd_entry NULL
+#endif
+
+static int damos_va_stat_pte_entry(pte_t *pte, unsigned long addr,
+		unsigned long next, struct mm_walk *walk)
+{
+	struct damos_va_stat_private *priv = walk->private;
+	struct damos *s = priv->scheme;
+	unsigned long *sz_filter_passed = priv->sz_filter_passed;
+	struct folio *folio;
+	pte_t ptent;
+
+	ptent = ptep_get(pte);
+	if (pte_none(ptent) || !pte_present(ptent))
+		return 0;
+
+	folio = damon_get_folio(pte_pfn(ptent));
+	if (!folio)
+		return 0;
+
+	if (damon_invalid_damos_folio(folio, s))
+		goto update_last_applied;
+
+	if (!damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL)){
+		*sz_filter_passed += folio_size(folio);
+	}
+
+	folio_put(folio);
+
+update_last_applied:
+	s->last_applied = folio;
+	return 0;
+}
+
+static unsigned long damos_va_stat(struct damon_target *target,
+		struct damon_region *r, struct damos *s,
+		unsigned long *sz_filter_passed)
+{
+
+	struct damos_va_stat_private priv;
+	struct mm_struct *mm;
+	struct mm_walk_ops walk_ops = {
+		.pmd_entry = damos_va_stat_pmd_entry,
+		.pte_entry = damos_va_stat_pte_entry,
+		.walk_lock = PGWALK_RDLOCK,
+	};
+
+	priv.scheme = s;
+	priv.sz_filter_passed = sz_filter_passed;
+
+	if (!damon_scheme_has_filter(s)){
+		return 0;
+	}
+
+	mm = damon_get_mm(target);
+	if (!mm)
+		return 0;
+
+	mmap_read_lock(mm);
+	walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
+	mmap_read_unlock(mm);
+	mmput(mm);
+	pr_debug("Call va_stat: %lu\n", *sz_filter_passed);
+	return 0;
+
+}
+
 static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme, unsigned long *sz_filter_passed)
@@ -916,7 +1027,7 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 	case DAMOS_MIGRATE_COLD:
 		return damos_va_migrate(t, r, scheme, sz_filter_passed);
 	case DAMOS_STAT:
-		return 0;
+		return damos_va_stat(t, r, scheme, sz_filter_passed);
 	default:
 		/*
 		 * DAMOS actions that are not yet supported by 'vaddr'.
-- 
2.47.3


