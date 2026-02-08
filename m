Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C58ECEF06F7
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 21:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F43C6B0096; Sun,  8 Feb 2026 16:58:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A7B76B0098; Sun,  8 Feb 2026 16:58:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 600A16B0099; Sun,  8 Feb 2026 16:58:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C13C6B0096
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 16:58:54 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D93C4140681
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:58:53 +0000 (UTC)
X-FDA: 84422654946.08.C52B4F1
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 15732A0008
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:58:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IzQbvprw;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770587932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HpwswEDlCandEKSEcjjhsX6vu11jfmhgbFRVqdS0y6A=;
	b=enQkue87Ne1X3ybeKKwpLSS00vBFCouj/QSKiUfaGsPIl7TZMeReHJX7IdDVhr8vYcBKl/
	Z4J/STPcwpzIyWMPRLpWu8cBCSt/4RCZgf+uZgDyQ6vu4jJS6VJCVmgNeofWHYcmAjfwHn
	5Hecj+iPw4V/CQejsqNreRi4N9le9Ps=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IzQbvprw;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770587932; a=rsa-sha256;
	cv=none;
	b=VsUcD5L0owUJO4Con8t847EKWEVCDUJYRf1SxOND34hStSQ8XWVJfDMmP9OqGkslP0PKcL
	ua1im9qO64RL128yyjbHOTeb/BU58Y1DMd864ly7eTAU57f/Ip18zSbKbVlXMX02ivSkd5
	onDOA6psJo76vLW2aZyIgqUu33W8/Mc=
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7cfd53a8c31so2707780a34.1
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 13:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770587931; x=1771192731; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HpwswEDlCandEKSEcjjhsX6vu11jfmhgbFRVqdS0y6A=;
        b=IzQbvprwZ3u0yL1xjkJ7Sp9+i1mW2pNaTDGQ8ubjNuZpU5bxHdGb//VV9I22fpR6wX
         CEWnxSnweXenj8ur2ihJ4S395CwcPy06FY3iExX8VadtibIHcHSVACLA/Djb2lnZfP1A
         dUtheVVPulz9PE4SpP9VTTpebgiLtrzvNNnJMe+Bafpgy2U53DwRJigYCaJm7p0fV7+p
         YiazwOKofsOgjsTp80RpauWr9xmzRzm9KLRUpdPd6xIiW42LN1+rD8D71jX540/nbfWZ
         iXFsU1BacMFmYJj9JZ3FK4k9d9uNVLQ1ak3sxosYsmUWcwXXSCM8KMWZPyDFyNKN5WSc
         XG9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770587931; x=1771192731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HpwswEDlCandEKSEcjjhsX6vu11jfmhgbFRVqdS0y6A=;
        b=PT5/YIwARLt+atAYLzyoVxhcfjgXwyjHcetU4IgvicMCw1eQh4zqNEP+2rRK/gEHIl
         ZfjS1J9oxKanoaH0Wn2CL0Xq8QL15eAFIM93DE8ufvZ/QNi8GI6Mi/0hzOAAO4AQdJXx
         50IssunAN1ZDJFogb6EVeXPnKWHFBal+3BgQe4xGw8mW/YpwGezhvKvA4xBSJps/OvqT
         JKAV9Zq7cAORhvFitl+maj5iRn+f92c3WTQ4NXJMMvG9DtMtOVFz131WYqz2mhXAOj58
         4zxc4aVksY/U6oWfp3MgFvTNF84fbOBbB6qFJYdB6nnvqkyB3yL5p/eeEr5wwQDsnZAf
         7Wkw==
X-Gm-Message-State: AOJu0YymrpeJ8Qwks6Rf41Y0yqNCAjC9D/CN9FWtzq9ToVHZUqMIIbPe
	TfnH+gvkMbpXHLrfFgK1sawvhpzAzlf1UyGuOLJr6IjmROlzxSmNst2zL2QNv5dEPbRWlQ==
X-Gm-Gg: AZuq6aI8Xylf9P7WAHNJxPWPEkeFXVKbcHIG2OgyMu0GWcZBF0UZKpSgTMhaVshuUmT
	YrI5t9B2C/+zdakMD7qqa6e6JZBJ8/uRNtX+lDmbh6lhlQM9rjw7YX9U+QzRlSBduoMI0xOM/Dm
	X2RpBI6yvpptGUbaHPVZY5jn8rocegzdx44U9tF9bBCWZ/PIBgjtwom2THwgmkNDTEMui6CsIrx
	JVfPCEFa7xPBbhCRXVyPFMRPz9X1E1FZb+24hf1fMfG+Rb+9xY+uN5aacxl/OIh7O1ElSnYgx1l
	qQ1VkEHoRhFa64EWyrIe2NcsIl1N3O/KkW5efHF11uUHUAa8xgJpfuRWr/UW2kLuxAPT6NEElp7
	9fJudkUI7gQkYpcWYY8C9ap/FLBvQsAsGs73Cd8sKS9pbpvCv6r6ADlvQC17lRnYaF/3lSVzeEF
	m1YDMdUrPGSPwnHjf98whnF/rMcpaU27x9FA==
X-Received: by 2002:a05:6830:828c:b0:7d1:93ea:5bc0 with SMTP id 46e09a7af769-7d4633df66dmr5296308a34.9.1770587931097;
        Sun, 08 Feb 2026 13:58:51 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:70::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4646fb89fsm6346653a34.1.2026.02.08.13.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 13:58:50 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	yosry.ahmed@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	len.brown@intel.com,
	chengming.zhou@linux.dev,
	kasong@tencent.com,
	chrisl@kernel.org,
	huang.ying.caritas@gmail.com,
	ryan.roberts@arm.com,
	shikemeng@huaweicloud.com,
	viro@zeniv.linux.org.uk,
	baohua@kernel.org,
	bhe@redhat.com,
	osalvador@suse.de,
	lorenzo.stoakes@oracle.com,
	christophe.leroy@csgroup.eu,
	pavel@kernel.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org,
	peterx@redhat.com,
	riel@surriel.com,
	joshua.hahnjy@gmail.com,
	npache@redhat.com,
	gourry@gourry.net,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rafael@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	zhengqi.arch@bytedance.com
Subject: [PATCH v3 04/20] zswap: add new helpers for zswap entry operations
Date: Sun,  8 Feb 2026 13:58:17 -0800
Message-ID: <20260208215839.87595-5-nphamcs@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260208215839.87595-1-nphamcs@gmail.com>
References: <20260208215839.87595-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 6noonr64ndk1oty5j3r9r58ys6ncorg6
X-Rspamd-Queue-Id: 15732A0008
X-Rspam-User: 
X-HE-Tag: 1770587931-248637
X-HE-Meta: U2FsdGVkX18WtvqJrx8wvl8XOSssK9x4zCDBSBxgj0UDHigD1StnKphYKwFr8W4ae6PGyuammd7zBNb1WTaNkDEGH+GtqXa5BOFVVfVSczlekii/Y0JwHDx+k9TVAqHHt5GrOjQQ/qSX60w8tb5afvPcyevXa1bqxlLhj0vJIJstx9UYXdBpfawo/z+Z/uh24Ajltih2MGPE/i2f6e6l4Vm3PNHvii4n7AzfAc5fcbfOv8JKbl7TkyLX8bFOd+5rA5OhiTCabx9PU/oaRPDqL8gAqj3w2cQ7NJhOQ8Y+uTuyouWm3Fks3Fi4llGgocuVyZkSD2k+oodY59H/wcLBWKAEmwfrN5QYGo1P0BYjvRE5zQCPqVzUE+ulyG2mWSahZXtsY3GyYU1UzHowStfcLsfljGo5APVBqF+iwDeqRYTWPpJQNqiQac8iNKKpjJFhHT+Ejlj0tQTRijXtsGkqkJ0d+W1rc+I2rfbKt5ignJFiCoHjvuJAD9FNfYAZR4xxjP/olkDElhmlaJncOg8vo/Z/YMPEwCRnf10GQV0PgOE8jc6lwe7b6FeEC070cULB1f35Od2tbeT3xjX1dJw/oA+prBjH0q9V0BaXKrG5Y8ra/eLu8rxB4vOWivP5h32z4pYLqxyGL0JpVs7VypyjBwTuZyIexfrrQ+6b648OjdzSNoIvVgNMR59/axVn7R5kzW3qC9zX+AOUF1zXhXc5OMew1zaAA+xKUgszvYvGpr8SqlqYGZwNeUWFUjVpOHOzgqEB03qNSotfFKrWCdVKAr4Zg7arJcLdm4+Qz1VvgDAHuBT65/4yk5uNb2i8n2rt0qwuk5HK3QaaUdl5ud9pgFBYv5KAR4Ioj19ap+TE7sksn4MQhrx5mf1H9AvDK/8EmbXlRPNvUKL31gC8bE6GdT+ZvttmDDlpgELreokLAdi8VD9VReHbrzEMV/t3Zx2GoQCBDh5NGrGYP2qnqOR
 HpLWbLtv
 JCLPn+i71yLsApEcgyek66uKN/VMILwkV9oB+Rt5VbwNeDjoraTaOCVqv4v7PPwZRvme2/xMyXfcbpp1mprSAin1u94Lg5PC2mZ8YdGZre5QDfbc76+gdpVwFZOjM5cjb7gRjCt49W/SIh9pR6PTfB1zfrK8sgH7+LiI6BpLXYY+ZlwV/4Rm+Oai5pzQ49fCqRx1pK64l76ydE2oYmL8zqUPqNUOheIHggNdZLtbAU8ktEXm6lr8EG/e0vlLDxLNkZIzpgfBZJDJqKU0Ae/Tj5QfbtGNKsV6mc5yb1jYvdbX13h3dOusWavn+YFfyxM7Y41QC0pufJUR+3MSBuOEt4BcKWYfG7D2HMdrHzLJPwD8A2rtAvYbGUYFfy53xeldQk7G2ZWAq+ahizPJNO3a/GqdNlW0agxm/NMrNj0tFmAyv0JoKeN1OC/7MV8kkN4JMmXMC4kTpDupjzgPNQRoYST0gT4bIKqOVz7h4xJJb8dENK63UyBCjO3wPCtWZmtDSMEWKM1jxAnMwE6F3OGkRXI1XleuBzCfOPzYTA+kWuoutRwiXej1zuClotBL/W5CWeSnkVZK6vJSg2No=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
2.47.3


