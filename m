Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 748881099B39
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CBCC6B0151; Fri, 20 Mar 2026 15:27:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A3886B0150; Fri, 20 Mar 2026 15:27:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5929B6B0151; Fri, 20 Mar 2026 15:27:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4733C6B014E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:27:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6D45C1988
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:27:45 +0000 (UTC)
X-FDA: 84567426090.03.52F65F9
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 21F0918000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:27:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZsluQJEO;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774034864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHzOeFlaQp2gdFIuNzaMDht2eyy5SJ0a+c6tcwRztv0=;
	b=D3h9+NNcvmsbe/HYp11fC4zOtsIjqQVkNe9BKE22OPlDero2T4Y1Uv08Wj2VZuU2qwm15B
	YOiFGUpa7XlCLwyZZPUFDWI9mxLuUqY/aBplZx4x5CuBeXYajGRG9KxWCnN62ysuG1bqs8
	xu03++5ZWS6uoB5uvi5kxASJCna4JB8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774034864; a=rsa-sha256;
	cv=none;
	b=CiJd2XYiax8GKyYfdARTDH0wgxNScIRbEuX9neXQeC+eRj1fwkRvVysScuKMU+oSswowJd
	u1oxqb66gAPaES8C0FdNLTGTBEGA86WOkGQa/qr/RlCj76p840422BSew//I5C2JraJt6M
	5gwW6DoV+0B/5xPXYISgwb+K/USUGZ0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZsluQJEO;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-4670bcc40d7so781555b6e.2
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774034863; x=1774639663; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZHzOeFlaQp2gdFIuNzaMDht2eyy5SJ0a+c6tcwRztv0=;
        b=ZsluQJEOI0nZA0QQ3ix4rZX1xZVEZrHUXvxYJOpHlbsFSVISXFuwkEPZpvW8GHBXgW
         xbXEP3ApuEeXj++OGjRKtUoDmzEW7SSpXuqNttxqrojv8IeN2ZvPPZ4TV6r+MRvQG1kd
         q0kpIKxK8r2ucR9jbPldZiXbR2I2yRE9P0mSI3uDeOPsOwt6rrBB3B5VlkYyItsHyeJQ
         2PO38yp5tAtH9cbay5ZH16+A3B9O+6HOOmxABIyJKOGxXnBubJFtjnbXSqp2uEyAdbtT
         QtvR1wNXID2jiEye8FGgv2ROhtfJi8uZO9HipMxsDpJZL7caN83sioci6w4DiaU8UIi+
         5YuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774034863; x=1774639663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZHzOeFlaQp2gdFIuNzaMDht2eyy5SJ0a+c6tcwRztv0=;
        b=CWtULC6cgBFnWo38uayPlNogMszfwD7aQp43vHlWlkETnJTbNAQzTDaZBjHWpkcvJw
         ttSnSHMfWD2ZwvOp4U/gt5NnX7negRHjh7r+2fQ8fBuY5y9TWSqkkiLiOYLurnR/RWFv
         eVkFqUcVi6Da+WpUs2i7rH+EuxDuF8ceRyr1RlCnI/dEMpzH4s9LZtbUiaTqkLW9FBgG
         1gSd2n4yRF7mSB9QlOx9P6ImmTAY5zn6/Ks/0actatRdcPvW5mLULD6jvikHYz9toV96
         1jgS6uzP7U/4sOESsmfcRW+Zhd20Pa76FEvCYPQC+7FWbgrUUN2zIL0fN6HOkcVhAXV1
         b+LA==
X-Forwarded-Encrypted: i=1; AJvYcCUapONXvYJrMy1Cq4bksYdIjG6cw4LwB+Mpioq1/K1CISO1stkPN4nfCWG6AMn3x/ScR4fRxbHatg==@kvack.org
X-Gm-Message-State: AOJu0YxozH6iRtgsUIau66uJGIMUPBFo956dmmu5hqADjWC90PDjOwsx
	saoCTYKTUGeicuBTwVDVJMCigYvR8/8cRL2NEZaRSD4xXS2sbVJHZoME
X-Gm-Gg: ATEYQzxqpvL+Hjv6gTDtQsuyVVNyF287XApFyi1S6D+hiywt/emXkqFlXZcj87LZX+L
	C7wzzukG+gA9nTWy5BPLotxk4sGiyDKyWbSkHxlDB6qSy+Fy7seqbDkn/QMBFXIjQuBsCaPxAb6
	U0rBX9rcaHYR0/z8mad/wBPTflCfGHjRz3vdmdwURClao+e2lYXxBjK4bwyqj/+VAaQGsyzcMnO
	Yq4gml+7I3vV1U053E8fxO+pLmSTNQSIep3y5EMSDnU3waC4NG52vE4vUIIULq8aRWWMvFordSg
	jvVac2F5DUZrLWkoBOuAC/HFsydtwToYW0PQZXQVzqRe3raHMMjnUMltslorewDKsySGU/lFQTf
	i9DpaQq2qmO2KGyQ4oO+yT/68lo4xsySyNeeyJ9IXwNSGzkOIGhAI280b+pw4BzPN3rhkJ63S+J
	7oIbSilOBKadRA0+YctH1zXfDzGnqC0mj9eLINm7SBHf562pRxDLufELTu
X-Received: by 2002:a05:6808:228f:b0:467:2509:c207 with SMTP id 5614622812f47-467e5d9cf3emr2304552b6e.17.1774034862980;
        Fri, 20 Mar 2026 12:27:42 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5d::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-467e7ef9c05sm1872071b6e.13.2026.03.20.12.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:27:41 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com
Subject: [PATCH v5 04/21] zswap: add new helpers for zswap entry operations
Date: Fri, 20 Mar 2026 12:27:18 -0700
Message-ID: <20260320192735.748051-5-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 21F0918000D
X-Stat-Signature: gkb859eii4wfg1sa465mu3xi6ab6gt1o
X-HE-Tag: 1774034863-89929
X-HE-Meta: U2FsdGVkX18qS+jLpBDez0qPWn3sUHmWOAlabcpBNsVyH9R5wEFnF8+/x0PL32itDZc1n9mElvKxHTnN79PpGIYmiIoujvKUUPB2JtjtdH1Tp4JRUOHhMSGsC6OTPLiiYqLLpM8rok9D+juCvUJY8E5QVIEQYpkj0LdkP12P1cSP3cQBSpKqMhzPeE2g1ZIeoMT38kHzwnwURixabZtN1v3FxRWNfVmjXQ3jPdoR/YM7RFbFE6dLS7BR22/9QsqdaVS4a+Q9JXSrkZXYWzrf0EIWEEPJpmYbx9KYTz142Vr5G8Zda1z3KdzU2kx6O8+qiVr2aWbGt3afe1iL2DW4WE0B8KGXHPoCbPCMtFPDB6gsL7CIjvr6697TpY2xw+bmJLAPirkrSfEGbUZfwcJcYs6YxCumfELhfO826U8DA81XN/6z4nM7yoh/3rlYiMYjjE/JWlVnIEPa4bqBDIBToSKH/MK2vDv5Tf6l3Sd2/7DZfrpxGRGJPxqE6+0U9JwllZ5a6WEIYSc5ZryBfND1LnNzDLX96G1mlVGurgNoq5fHXmBiLwb+ViPe4RKi3nR1ChvNmAXF7Q/a4EyR57mTuXF7g49tOXpP8wSv2jX8PzsyVxWPfOcjoL4Xll8oefwdS0klTXC0PTt3Zo1ncoMswVzx8nbQb+3ix0wi/OymkRgmwrvdjrMELYPfow6gFxgD0cme3QQxDHfOMAxHc99v/ZDFj56sJ+kIqFu+cROkN8EGX/zXsZxM0sLAQZrNoc62KloJ+J5GCFxgegFBnnHeUwhVtoRSTx/i7RE10O9pMkkK2/0e0oVNM5pwQ2xw+zxRumYs3hAXJwZGgrgeqZWBLJLbTsoVaCr9WuJ5kH2eP/wGrm3JDE9Ynvs0niSufLHr0jSfBdoLbGX2vHYetO7bVvRUmR47iGRencRsboXf3eT1peU0Ba5W6qG4Y+RYIKZMTXcCdvNb3dkkBCaP6M0
 TBk2CkYA
 K4q8rf+xlLgbaeY42+OKIzX6mvTK6TMHC9tKowjAxpfioPUvBbGkTbj0FVymkFBDNSqQTTQR2OxuujvR5FRgGvdeuN0T3Vjl2U6sK+n/BwmFTvf5kuqoeBqVG6FBXDxs9biyfKJDV/bgXkftS4qYSyRPLxCHRfSxwF9+BnoJGRHPcilw7dEEu0p6QjJHXbZuqeUOC4EmIpFCwPZFa7r2PfzxeOiIjfaRD3J+59F0cYofGEfMVupKDldibe8wcx62ShM4bOlOgMLCuveB3OAWr2psMtQlGLU8hQuudJh8wnM8yi+E3bE6CVQgaLpSdO2z3AVXx6SGXq+J8xaPmHpUSYo27uwCLnGd3GBmCfGlvmmrurLe+UJsCGA5eXDBgmnRcTu+SxLbTTQF+n/jZyZCAhD5d20uf1iyyrJamFlWoHW1qRaQWWDdkUtXE3CfAedAQqj/mhDuqsrB7xPCQWzRcugOtaXhyUYpOYdi7R7Njs+sfG3JjYEHYCiobhjd6F0PUtUOiBjM2hIQZMvjoeLqBD8fpnGMmAWdYXbNVm3e39z8WhdEx3Xa0Z9muEnQZFqFOA2zExdMqJIgiPUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add new helper functions to abstract away zswap entry operations, in
order to facilitate re-implementing these functions when swap is
virtualized.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/zswap.c | 59 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 19 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 315e4d0d08311..a5a3f068bd1a6 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -234,6 +234,38 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 		>> ZSWAP_ADDRESS_SPACE_SHIFT];
 }
 
+static inline void *zswap_entry_store(swp_entry_t swpentry,
+		struct zswap_entry *entry)
+{
+	struct xarray *tree = swap_zswap_tree(swpentry);
+	pgoff_t offset = swp_offset(swpentry);
+
+	return xa_store(tree, offset, entry, GFP_KERNEL);
+}
+
+static inline void *zswap_entry_load(swp_entry_t swpentry)
+{
+	struct xarray *tree = swap_zswap_tree(swpentry);
+	pgoff_t offset = swp_offset(swpentry);
+
+	return xa_load(tree, offset);
+}
+
+static inline void *zswap_entry_erase(swp_entry_t swpentry)
+{
+	struct xarray *tree = swap_zswap_tree(swpentry);
+	pgoff_t offset = swp_offset(swpentry);
+
+	return xa_erase(tree, offset);
+}
+
+static inline bool zswap_empty(swp_entry_t swpentry)
+{
+	struct xarray *tree = swap_zswap_tree(swpentry);
+
+	return xa_empty(tree);
+}
+
 #define zswap_pool_debug(msg, p)			\
 	pr_debug("%s pool %s\n", msg, (p)->tfm_name)
 
@@ -1000,8 +1032,6 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 static int zswap_writeback_entry(struct zswap_entry *entry,
 				 swp_entry_t swpentry)
 {
-	struct xarray *tree;
-	pgoff_t offset = swp_offset(swpentry);
 	struct folio *folio;
 	struct mempolicy *mpol;
 	bool folio_was_allocated;
@@ -1040,8 +1070,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	 * old compressed data. Only when this is successful can the entry
 	 * be dereferenced.
 	 */
-	tree = swap_zswap_tree(swpentry);
-	if (entry != xa_load(tree, offset)) {
+	if (entry != zswap_entry_load(swpentry)) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -1051,7 +1080,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 		goto out;
 	}
 
-	xa_erase(tree, offset);
+	zswap_entry_erase(swpentry);
 
 	count_vm_event(ZSWPWB);
 	if (entry->objcg)
@@ -1427,9 +1456,7 @@ static bool zswap_store_page(struct page *page,
 	if (!zswap_compress(page, entry, pool))
 		goto compress_failed;
 
-	old = xa_store(swap_zswap_tree(page_swpentry),
-		       swp_offset(page_swpentry),
-		       entry, GFP_KERNEL);
+	old = zswap_entry_store(page_swpentry, entry);
 	if (xa_is_err(old)) {
 		int err = xa_err(old);
 
@@ -1563,11 +1590,9 @@ bool zswap_store(struct folio *folio)
 		unsigned type = swp_type(swp);
 		pgoff_t offset = swp_offset(swp);
 		struct zswap_entry *entry;
-		struct xarray *tree;
 
 		for (index = 0; index < nr_pages; ++index) {
-			tree = swap_zswap_tree(swp_entry(type, offset + index));
-			entry = xa_erase(tree, offset + index);
+			entry = zswap_entry_erase(swp_entry(type, offset + index));
 			if (entry)
 				zswap_entry_free(entry);
 		}
@@ -1599,9 +1624,7 @@ bool zswap_store(struct folio *folio)
 int zswap_load(struct folio *folio)
 {
 	swp_entry_t swp = folio->swap;
-	pgoff_t offset = swp_offset(swp);
 	bool swapcache = folio_test_swapcache(folio);
-	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
@@ -1619,7 +1642,7 @@ int zswap_load(struct folio *folio)
 		return -EINVAL;
 	}
 
-	entry = xa_load(tree, offset);
+	entry = zswap_entry_load(swp);
 	if (!entry)
 		return -ENOENT;
 
@@ -1648,7 +1671,7 @@ int zswap_load(struct folio *folio)
 	 */
 	if (swapcache) {
 		folio_mark_dirty(folio);
-		xa_erase(tree, offset);
+		zswap_entry_erase(swp);
 		zswap_entry_free(entry);
 	}
 
@@ -1658,14 +1681,12 @@ int zswap_load(struct folio *folio)
 
 void zswap_invalidate(swp_entry_t swp)
 {
-	pgoff_t offset = swp_offset(swp);
-	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
 
-	if (xa_empty(tree))
+	if (zswap_empty(swp))
 		return;
 
-	entry = xa_erase(tree, offset);
+	entry = zswap_entry_erase(swp);
 	if (entry)
 		zswap_entry_free(entry);
 }
-- 
2.52.0


