Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 966EB606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 11:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=TE41Bqzg
Received: by kanga.kvack.org (Postfix)
	id 0FCC36B067B; Tue, 24 Nov 2026 06:06:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 085CC6B067D; Tue, 24 Nov 2026 06:06:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8FEF6B067E; Tue, 24 Nov 2026 06:06:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3C576B067B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:06:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8234E120AE8
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:06:46 +0000 (UTC)
X-FDA: 85469734812.07.C1DD263
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id A4C69100005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:06:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TE41Bqzg;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795518404;
	b=je2ofHsfrusoUkUrTEFM6l8cIw+9DkdwSlveaIDwz8KsPaRQBII5DX6ABLyKvq5apIcP/Y
	1Zj5Hh3SGZf6pLICu5QT9ljpH8uH1tLg98ORJD9aOp5Z8v+70HYQb2k2H9GV3ztk1F9Htl
	m1IPiYSDToSQS3vpqYoIhEDj9xudSdA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795518404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CER9M0zRJu1ua41msi7LSMzJUbxgL6WMglqzL5PYieM=;
	b=q+JY3NL0XQiGtq3ESxHEswzct3NAqHsFKVlMARm769gRMVJfNh0cTloajVVoxQQrya/D6z
	hCFWo7fq8kmmzoHVJV2LYFIgluQ2zweiCxsRggT4zPivtYbzTU2sZKS4GEcM97lK+DWZ1c
	WeIq13sBHEiiNrZmRI7ndYwgYmI5DUc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TE41Bqzg;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cdab938dc83so1744374a12.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795518401; x=1796123201; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CER9M0zRJu1ua41msi7LSMzJUbxgL6WMglqzL5PYieM=;
        b=TE41Bqzg8W8GmhcWK+KgUc7jvtJdPFyGs11b2dd0gVPHyAYod2OvgFkbjNO4gsjeMc
         VbKH/YZQ28vNazTebufttpVhnk9Cri3gbDa7svXfsvMIue9n13QvAiXCegEFngmNmB/A
         kOuvmd2ADdP59pEnSs/gNoeNvFTXeNFhW2VzU8d+/LUJJQtX5BeGQYrOYMXZK9VGM3uY
         IN2o7qkPZ1J/ltSOms8B6m+Dl9KRMy4eWM3eKYtP0IULcFVsNMvGcDizICXhIzkV0DaE
         sG4vaSEG8d45eDBbu10ZO4IA6JaOCuQO3+prTfJbwoYXBcWxSMphsIED8AL6n+JDr5JU
         2i1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795518401; x=1796123201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CER9M0zRJu1ua41msi7LSMzJUbxgL6WMglqzL5PYieM=;
        b=SIPL9hi1tGeGh2RhlNU015HCkSCnmcBZvd59r0pm0TUORu/Ub6gKBiYkvYPlRfy0WP
         kxw8rKvDkkmkWfYPBoQj8htE+mg+WS7yFwPwN7ENxH10U1RUmC/NUzNKee4+5953kmRl
         dBhMj+ZWgcP8iDOuJdG+sXMtPGiK9c9iB09DhPcrleLPpNBrYaahjc9VvAFn+NY/XV4w
         9WVFinyl2Ea3oBsuJnrk6/pqRLDWi2wQwGSjsyLdOBHXnoCEYokd1qxajwzmnE/ixnK7
         dGjnP6DTolpEXCZTTk14jXd/5I4j6V12lVAdIZb9ZvKmsWbEquF2PWh2SmGu2n9Af4Wa
         iPBA==
X-Forwarded-Encrypted: i=1; AL+hErF9HjBCt/VSeNgxwmAUVHnXorEwEpLjN4uefYcHnK3MK83pq4YFQz0cgiA7pQbU/HqH2fdfytH5dQ==@kvack.org
X-Gm-Message-State: APuU4Z9SRnNDxOABbhaPx0/qIuIqintpwviIZBukKTkf72AlR4JMcH7i
	awJ+j+X1KcJ/lpWj5ZV1/OjWIJ5Fv8Gg6JJ5mTcWoY6cEXMa9mCN4zQgb8ZYsJV+iH4=
X-Gm-Gg: AZFdTZdz89Ms/AKkViNm9such0fv+uFYf6ERRDeScjKNUbuetocJo10thiQywNnZuk2
	pwNdFR2CRHjHsjaEiSnlQL9BSXhXUE8L8+NeOY09PHeVISIIkVDkYSzq2HoVZnToSCbEHcOUMY8
	kmCJIIQ/XlhI3A5BiuBY7Nro/KhtVIfOUNwAMOeNter+qyS6C7KxxfC/+gyaGckfC+b0oKxjimh
	qS09CXaMTNzswm02KcStYmgmye8EUFnsQhojVYGVxMaEr2XhF4Ldd9iLjGDrlntEOuz79LGuHOR
	UeUcKc+Gbi7pIlcjIRZwqfHDJnp0btP9z8d8pLBcrfSn5sHSBiYXpwlQrCCmpSSXn/ORwBng7kb
	2D/uMLecxpedqlL6KDiAhJPwncSIWznP4scTT2EI3bVjIA4ww8mCLmoEYcGtZtiCGXRxfjTIg4h
	lmNSNPvNnfR67FsAd4RNUIEVF11x5fCElQ1V3jSuFBiASp4vQKsp9zjKd9LRt9u4tXLuBDJ7xQH
	YeOd3pRKxxkvPpTS4Rku8wYQ46MJdYdni/nkOHNdKeY331DftzNpb/pvaQQvkmlv/ja5UV5zvnb
	vquVM7Kn+j9qNMH6uC5ytcAqmRr2YJPQRrrHo/424faBwfbPeAP2EQbzUi79VszBhzRlz0g=
X-Received: by 2002:a17:90b:5350:b0:3b0:a3eb:75a0 with SMTP id 98e67ed59e1d1-3b41c8fe153mr12047381a91.23.1795518401247;
        Tue, 24 Nov 2026 03:06:41 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0a33fsm22909735a91.6.2026.11.24.03.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 03:06:40 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 3/6] mm/hugetlb_vmemmap: drop the redundant hstate argument
Date: Tue, 24 Nov 2026 19:05:27 +0800
Message-ID: <20261124110530.3004071-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261124110530.3004071-1-songmuchun@bytedance.com>
References: <20261124110530.3004071-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A4C69100005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6jpae9ycny9ybhz7ghtwwwpnc9jhks3e
X-HE-Tag: 1795518402-370268
X-HE-Meta: U2FsdGVkX18bZ2gDTIKqqiKLhzUP2U+5orzTn6Mh/p8ueTXJum8fgZ8F80yDY0tDAo0KpAZ1KW3EBjcdXtTWlVD3YXRMu7ceaCWUIR4T9WZ8IYBcfG+cjWiFT2THpcHzF/DyYojlCR4CfVECRuoZYcqQ88wNw5frFBlPeeTjUP7VVEDSsOjT4XO34XOmubwwH+Pb/MEm5HmM9HNfAq8r7GG8V0kjRbniS0tQSGijkTBctMMqgCuN0lzYrc3LF+fxpK1jnruXzwwbceZ3QKyL2gbDo2osBOEf+VBoMDqIWBwnQGl3v3IKRM/htVdcD8peXt6naU4iUYWXYsOA3aHdPecTCSaKcPHjyyVjQOQBoWOMRMtPX/MpCBlUqR6p/AuJjqPvI+sy6BXCJijj61/zcq+NakHBnwMbPz53A5fQExAG2BbMnxJw0abEcMT1ob86jKJfDgl8TMf9ik7hjgmipHhQ/QG06kcJ8dYXouYmmJJAO9RewgfUoz0gx24eeP+MYk/svLLDAPlHpYQFDyfg426xsaS/yIk9w5A/IcKQ47AhcSOBV7DGGQxt9S9lfgaULqrdcl7oMHPDBbJHgOC3xv4HxLy9+jw25KqgACkuVj2slbsTJC2m9QLfvAn15/zzeLt/Sp/13wtHwfldimR6gi6YvwGXFxtXB0p6DiV511N6FZq/e4qaNWrzg0Z921E/098EmDC45qtsk2NON3BKyRqbQzecbxr8o9ZFTky+v7qHyJHs7LwW00ojq8JRENWBJ4H/YvMc5WS9vRPTfiDZDbGH+e44uei4QRJGn5LWMW3LVep+ID57bxM+qjPlI8dqou1JA/1Ly1fQr3z/+R2lfFXatXPs4cK2e8EtmJCNmhJERH1+vpdGtN55mKQWnFGv5N27Ky67NqfjRetobdH2l6v5uj0eObghcokSrVGyKUaFoxRZseOxvoKDriW+N33qYCV9wgeXs5NnTKjQO88
 y7sQz/+c
 hBm5e3lFWkiOjY6v01VKftqvfps9xNOgkaufGYGFGAO7nkR1lltnKPQbP9z2nAI91j+Jwyf4nBHjh0irENOXlFcn+V2as5/k2AVF7wvhiuuFTP6XqTF+4sa9gFYEOPtGwJuHVVabJws0FlQ9myGIUZ0aGZ2lf08jP4Jk8Xp2Ecrcyd28jFxUb7TJZhznoxtmBF7AnUdbuO8NCYI0kjqk1HiLnZZKfENeLCp8QH/THDJg8AYZibKrio3ZUgU6PDMk82P13Keo+EUShwR1qAzDTfAxXxxFuJsc1vkqmVUqwrYaNDyUVoHm9qxVX9M87+Ua7favaoyHqs8muu2zsvAo1bwT7FhIOZE2zJpF6AdsgTvteDZXNn4XP8QxNNKyXYzjrpnRPa33u4hZUROQdeELqSoWT2mbctPntK141rULdGHgTKP+CmeEPc6YIgsfSdsQvkN4NZ7SqMb1z6am2lg9Us45ecrccKXzi/xpc90Gt418mnOF2gUkg+WfDQoR+LSoCpWn/iYcm01AW0dz8hdz4NlFcclKc9G8JvuxCHN43EdPOtuQKXqBKVPJ+xfNI+iiZfmfFw2OYw/ySD6Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The single-folio optimize path and the single- and multi-folio restore
paths derive the vmemmap range, order, and NUMA node directly from each
folio. Their hstate argument is therefore no longer used.

Remove it from those paths and their internal helpers. Update the
callers accordingly.

Keep the hstate argument in the bulk optimize path so an ineligible
hstate can be rejected before iterating and pteifying the folio list.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c         | 12 ++++++------
 mm/hugetlb_vmemmap.c | 28 +++++++++++-----------------
 mm/hugetlb_vmemmap.h | 18 ++++++++----------
 3 files changed, 25 insertions(+), 33 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0eddb8cee1eb..0475ee595406 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1519,7 +1519,7 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
 	 * is no longer identified as a hugetlb page.  hugetlb_vmemmap_restore_folio
 	 * can only be passed hugetlb pages and will BUG otherwise.
 	 */
-	if (clear_flag && hugetlb_vmemmap_restore_folio(h, folio)) {
+	if (clear_flag && hugetlb_vmemmap_restore_folio(folio)) {
 		spin_lock_irq(&hugetlb_lock);
 		/*
 		 * If we cannot allocate vmemmap pages, just refuse to free the
@@ -1671,7 +1671,7 @@ static void bulk_vmemmap_restore_error(struct hstate *h,
 			 * be freed without restoring vmemmap.
 			 */
 			if (folio_test_hugetlb(folio)) {
-				if (hugetlb_vmemmap_restore_folio(h, folio)) {
+				if (hugetlb_vmemmap_restore_folio(folio)) {
 					spin_lock_irq(&hugetlb_lock);
 					add_hugetlb_folio(h, folio, true);
 					spin_unlock_irq(&hugetlb_lock);
@@ -1701,7 +1701,7 @@ static void update_and_free_pages_bulk(struct hstate *h,
 	 * in an effort to make forward progress.
 	 */
 retry:
-	ret = hugetlb_vmemmap_restore_folios(h, folio_list, &non_hvo_folios);
+	ret = hugetlb_vmemmap_restore_folios(folio_list, &non_hvo_folios);
 	if (ret < 0) {
 		bulk_vmemmap_restore_error(h, folio_list, &non_hvo_folios);
 		goto retry;
@@ -1948,7 +1948,7 @@ static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
 
 	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
 	if (folio)
-		hugetlb_vmemmap_optimize_folio(h, folio);
+		hugetlb_vmemmap_optimize_folio(folio);
 	return folio;
 }
 
@@ -2117,7 +2117,7 @@ int dissolve_free_hugetlb_folio(struct folio *folio)
 		 * non-vmemmap optimized hugetlb folios.
 		 */
 		if (folio_test_hugetlb(folio)) {
-			rc = hugetlb_vmemmap_restore_folio(h, folio);
+			rc = hugetlb_vmemmap_restore_folio(folio);
 			if (rc) {
 				spin_lock_irq(&hugetlb_lock);
 				add_hugetlb_folio(h, folio, adjust_surplus);
@@ -3981,7 +3981,7 @@ static long demote_free_hugetlb_folios(struct hstate *src, struct hstate *dst,
 	LIST_HEAD(dst_list);
 	LIST_HEAD(ret_list);
 
-	rc = hugetlb_vmemmap_restore_folios(src, src_list, &ret_list);
+	rc = hugetlb_vmemmap_restore_folios(src_list, &ret_list);
 	list_splice_init(&ret_list, src_list);
 
 	/*
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 71aa340cce55..4ed2db189f59 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -414,8 +414,7 @@ static int __init hugetlb_vmemmap_optimize_param(char *buf)
 }
 early_param("hugetlb_free_vmemmap", hugetlb_vmemmap_optimize_param);
 
-static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
-					   struct folio *folio, unsigned long flags)
+static int __hugetlb_vmemmap_restore_folio(struct folio *folio, unsigned long flags)
 {
 	int ret;
 
@@ -436,20 +435,18 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
  * hugetlb_vmemmap_restore_folio - restore previously optimized (by
  *				hugetlb_vmemmap_optimize_folio()) vmemmap pages which
  *				will be reallocated and remapped.
- * @h:		struct hstate.
  * @folio:     the folio whose vmemmap pages will be restored.
  *
  * Return: %0 if @folio's vmemmap pages have been reallocated and remapped,
  * negative error code otherwise.
  */
-int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio)
+int hugetlb_vmemmap_restore_folio(struct folio *folio)
 {
-	return __hugetlb_vmemmap_restore_folio(h, folio, 0);
+	return __hugetlb_vmemmap_restore_folio(folio, 0);
 }
 
 /**
  * hugetlb_vmemmap_restore_folios - restore vmemmap for every folio on the list.
- * @h:			hstate.
  * @folio_list:		list of folios.
  * @non_hvo_folios:	Output list of folios for which vmemmap exists.
  *
@@ -460,9 +457,8 @@ int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio)
  *		encountered. The folio that experienced the error and all
  *		non-processed folios will remain on folio_list.
  */
-long hugetlb_vmemmap_restore_folios(const struct hstate *h,
-					struct list_head *folio_list,
-					struct list_head *non_hvo_folios)
+long hugetlb_vmemmap_restore_folios(struct list_head *folio_list,
+				    struct list_head *non_hvo_folios)
 {
 	struct folio *folio, *t_folio;
 	long restored = 0;
@@ -471,7 +467,7 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 
 	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
 		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
-			ret = __hugetlb_vmemmap_restore_folio(h, folio, flags);
+			ret = __hugetlb_vmemmap_restore_folio(folio, flags);
 			if (ret)
 				break;
 			restored++;
@@ -488,8 +484,7 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 	return ret;
 }
 
-static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
-					    struct folio *folio,
+static int __hugetlb_vmemmap_optimize_folio(struct folio *folio,
 					    struct list_head *vmemmap_pages,
 					    unsigned long flags)
 {
@@ -518,7 +513,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 
 /**
  * hugetlb_vmemmap_optimize_folio - optimize @folio's vmemmap pages.
- * @h:		struct hstate.
  * @folio:     the folio whose vmemmap pages will be optimized.
  *
  * This function only tries to optimize @folio's vmemmap pages and does not
@@ -526,7 +520,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
  * can use folio_test_hugetlb_vmemmap_optimized(@folio) to detect if @folio's
  * vmemmap pages have been optimized.
  */
-void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
+void hugetlb_vmemmap_optimize_folio(struct folio *folio)
 {
 	LIST_HEAD(vmemmap_pages);
 
@@ -534,7 +528,7 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 		return;
 
 	guard(rwsem_read)(&vmemmap_remap_rwsem);
-	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, 0);
+	__hugetlb_vmemmap_optimize_folio(folio, &vmemmap_pages, 0);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
@@ -573,7 +567,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
 
-		ret = __hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, flags);
+		ret = __hugetlb_vmemmap_optimize_folio(folio, &vmemmap_pages, flags);
 
 		/*
 		 * Pages to be freed may have been accumulated.  If we
@@ -587,7 +581,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 			flush_tlb_all();
 			free_vmemmap_page_list(&vmemmap_pages);
 			INIT_LIST_HEAD(&vmemmap_pages);
-			__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, flags);
+			__hugetlb_vmemmap_optimize_folio(folio, &vmemmap_pages, flags);
 		}
 	}
 
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index b7781baa2ce0..c75faf3e5510 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -15,11 +15,10 @@
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 extern struct rw_semaphore vmemmap_remap_rwsem;
 
-int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
-long hugetlb_vmemmap_restore_folios(const struct hstate *h,
-					struct list_head *folio_list,
-					struct list_head *non_hvo_folios);
-void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
+int hugetlb_vmemmap_restore_folio(struct folio *folio);
+long hugetlb_vmemmap_restore_folios(struct list_head *folio_list,
+				    struct list_head *non_hvo_folios);
+void hugetlb_vmemmap_optimize_folio(struct folio *folio);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order);
 
@@ -34,20 +33,19 @@ static inline void hugetlb_vmemmap_write_unlock(void)
 }
 
 #else
-static inline int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio)
+static inline int hugetlb_vmemmap_restore_folio(struct folio *folio)
 {
 	return 0;
 }
 
-static inline long hugetlb_vmemmap_restore_folios(const struct hstate *h,
-					struct list_head *folio_list,
-					struct list_head *non_hvo_folios)
+static inline long hugetlb_vmemmap_restore_folios(struct list_head *folio_list,
+						  struct list_head *non_hvo_folios)
 {
 	list_splice_init(folio_list, non_hvo_folios);
 	return 0;
 }
 
-static inline void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
+static inline void hugetlb_vmemmap_optimize_folio(struct folio *folio)
 {
 }
 
-- 
2.54.0


