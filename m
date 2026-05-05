Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E260FFF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFA5F6B009B; Tue,  5 May 2026 11:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37926B009D; Tue,  5 May 2026 11:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A003F6B009E; Tue,  5 May 2026 11:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 882926B009B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:39:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 31B8B8B9D6
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:09 +0000 (UTC)
X-FDA: 84733774818.03.80757A4
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5830518000B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GttvoQGo;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.169 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KREMUBUXFd40dOrxzMFx0/PDjOEkv9ZqqqX11trPF+8=;
	b=xDLHPyS9KhB+IkVpYGWdN2txmWhXO+2udwbRA7TjUlxCNWihyGdnzNQ+Bt+GgkKbpJJhNG
	1M+gLnWNFCKz2BGWc2SYCzN639HPLzDsosmnb/zzItxyCY/S02dTEazaHRmGXWDM79WCB/
	bKKgitP13VECve4guaHrUYhJCl1pIvI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GttvoQGo;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.169 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995547; a=rsa-sha256;
	cv=none;
	b=Q/es4qZDHdY8BfT2fiBCqts2ZnRkHazroA84cZVmteSzaJsWUvOwWu5G0wDCpyDnLV2DGd
	veYsOtoRkHlNudu1yLq2Geb0l0FxnRxOP0TuglB9j7jZ1tsHEZ5JWT0MtYVqzmM9qKe2Ky
	MHdnwFU43HxaoFaDp/1yJN8Vv56hsIw=
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-479dc6d26e3so3030720b6e.0
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777995546; x=1778600346; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KREMUBUXFd40dOrxzMFx0/PDjOEkv9ZqqqX11trPF+8=;
        b=GttvoQGoZwCUVyrSeQaJ0Uf6Qm6UzGhJAr0F/Y5bSC+LlaDyuZ1HraRcm1M4CfZjsk
         WHo94ELv+vjTZ2dChfFjyxImmQw0pfXSBPPZ/B+fT7+EgwJZDyF5xgtGk8uYqBmoKtU3
         oNJ18BQyRQfG9Hxh4r54mQ5sXTQtQIV8pW4c/o3xpjSKCrICZZJk3uYHrYppwwpUFbAv
         cQo7Luu3q8RTYcJxaB9kktpO6DO9+5bQt7jo70CTLlODhzC+IbJOWSKNJShisdaOEPeq
         Zkp/0zeT81Ww6gGVV9Oazm3ifmFvZtkKX3fI/osR7XhRC9D6b7tO20ZHSBzlhvVLjVTf
         5ogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995546; x=1778600346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KREMUBUXFd40dOrxzMFx0/PDjOEkv9ZqqqX11trPF+8=;
        b=pTuNqqrQOO6ELt+OGkDmr8EbDYn8rlGKCbCqjg07+Yeol0NUPnTPaJs906OKFrnxdS
         MGLSjxMG95PyxCmQG6SP5ah4l9jp1IoHdIVeEvPpW9sdLMiE8hQAVq8EpHTZ6yaeUaEN
         Ljf6QH/mE/M19obw4CVYPBxkftM7emDXOROv3/9UG5t4/zsxFipRGRAEAVMgoz4oil5D
         miUjCd1OgAT4URdwotspK7752UCx/6TfreZVzVKJEe5Jn8iqCACql2Q9btPN2jRcILCT
         ZV5jhquxe3n6Wf91OAZjtewuLuFs2I0guebHaDCNHzwaUkSa4ABvXIBY7+Gum81muLU6
         aV7w==
X-Forwarded-Encrypted: i=1; AFNElJ9xkz1KvhSbOQiG1S1yZVsN3oidnhZWCorR7/oLlMS6YeU28ncm/QNQj3eQLt7iVyPbqD2+6owAug==@kvack.org
X-Gm-Message-State: AOJu0Yx+t+Wx2+2B4CmPPn4o4nRVs91etPkGo4iIMhH+OYMCkOdw5LPD
	wF7ro06jHitpO5lzKWTgThqfBmGnioMga7IiV/jIennWOYlHUG2zEg/C
X-Gm-Gg: AeBDieswOj95Z5rmErtxzm4QFfP55jDzFBJ5bHs8Kx1WraTUtfHWB+qph+FA2/zXIWf
	Frz7A0omnbTX8VR7ZF/oVCHcxdo+xRPvn8T59g0rdDO66e2oIMCUTxY0qR4HjmbUv2M3OWP2s/R
	Zt2BKLyN2zybOjiBalcGMWD8MYFFC3njIs+hIdYzO8H5TQ+slsZlr/GjjrU0BjzzHAXxxr7arP3
	wfhk2BjeNH7pb5oEJpFnX3dZ5RNHxO+UTFjzMf3vbDcORKXLC4AHr7L6/1tvu31fnWr2JTdIy3f
	4BSu1AbjIr/cIM0v8oSzGACaJ1NzpmE2WC54swC1Ak8iC6utgtxzi3Bfa28/C/WWMKB7SR0s+wR
	JtFMF+gd8qv5T4II8zoRyySq016bESipT00enjJ/TPzLAcMGH1yGiGdcflXN6uONzC/fBYkv4dK
	GHej8FtEEK/VsowSCP0zCNqLofMY9aMVGg8IYQmm47jTKn/PmY4AHYxZlPnyT9w3AfyVg=
X-Received: by 2002:a05:6808:1787:b0:467:2a6e:adb3 with SMTP id 5614622812f47-47c892314ddmr6943387b6e.23.1777995546294;
        Tue, 05 May 2026 08:39:06 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:71::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c7640069csm8753456b6e.8.2026.05.05.08.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:39:05 -0700 (PDT)
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
	riel@surriel.com,
	haowenchao22@gmail.com
Subject: [PATCH v6 04/22] zswap: add new helpers for zswap entry operations
Date: Tue,  5 May 2026 08:38:33 -0700
Message-ID: <20260505153854.1612033-5-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260505153854.1612033-1-nphamcs@gmail.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5830518000B
X-Stat-Signature: 5norym5531o9w1tyneh4gfx4fnquqmz1
X-HE-Tag: 1777995547-636031
X-HE-Meta: U2FsdGVkX194wdEXhD1eIPCH2xfQjFKhEYXgcDQ83DZvWi34ZBj/X2BXLm3FAd2Bu/TruFX+nqKOE/ZxkIJVbK6X93YlDXzqdMKUTwBk6biK+XIp3/cws4HP+mPicJ410Pml+MQUkYoRDpLyewCK/9UNRFXrhlegHpB6V47afP1rAn7SNePljVrukFuo1RBXkGjg4Sw6ubk9KJGXlcg1X5HTsWBRIWyEwrfcsqspwdP3SdAkbstthAoMDooQXoIa6UvzuXiG+JdqUWTdxx7iSwGA4WQDV+4m3ZvMR+oIgnxTv8ntLqpOpieYYco3C4L3eZATTYX18rtBFCgtaCIRlv4rvxuHUAVS0fp4GxjHE6Ou7gES0mCQ4ZFKjE7V+OC0yPz1RmYXFUFxyq4HY4LIf/QJZotkd5l0bmYrZtU7ZfBfXTXtaIwV1htNeNUv+lhlypc40iOJDGWVm2wOP3wPnBDJVqGK25Itgjps5NGw7aU/p7Nc9rEpTCSQz4TsR6WS75aEc5CyQIlEJat9THevsEfn4XFYo9xoZPH1z+5GBwnbBjP+4z0HTXw3tHgAsJtOm8j+c/G6XfE+5irNoV9NmX/3b+UH4V/fxizWMZVpwn6ZQipqGXq4pVULq69fB2wVQML7wkyqppV3AzLDrETBW+F8IMssch82XglrcC1cTeyzjCnHwDvDrJkmbAwz/9vB2R1DQTlb2eZEvYQP76QFDvKtE7mkjZsfQ/bka+iFxNLwpRQ6eQzYn7EyFbG5KhW2ZPHLVE57423u6h8zvrA0P87X+wd82pS7LS0ishDHrJyim+c2r0YBuYzdX5Ob5CifyrGSqK7D30Hf/oMDULdeRWj2UxLQiBegnJ5/zlDZH/LGDEEt2svVipLqPPG1jr7lHp77yH0posrMuW8jJqblhCcEmYYQHR9TT0ya13S6d620WfwFKvoIymzy7m1ncQ30lrntoiKNaJC8C+b1uVI
 jYBH1E8w
 LF1uJ1YhaiZLhfMg82r6/tXe/pxtohuPcDIV/I+dXJEcwBaHEI0+RtEpD3YNoEqe9+u0FkH5KTOVpjWr6Voee5J7jDVnzalwBnBjya5BA1A+cBBp4A4hLcDLgSSzZjBFpmg4HnbA2fjUeqrPtX8bLBI8jDcpiNoFSwiHD/3o8uCmE7Bdbh6RtrM73PCFMbKrVQQSceEUvt4E2cb+dGcSLlzxkNq4jmuci54RDBpJY82z9vNvaPv9wyfLFWuYYGM0cdB4hQyWOL7/5q1VJ5FYeVElZX6lCB/hxTRFiN+MWwK+pZ65Wp0TRH/xNze6e53qwhwuTNSRZ0ilZqle4gS5xHLTgeqDc3Pf/FXbggGAqhipU3/5a6AN2XHZMRaDuT8JfAjT9AVH/9mRafnBtB0HHwC2NwNygf5BNpT+MDKlggWJeppM+5o3zjPfGJKCCwCp3QpWT09EehU18Uq802n1jqD2wmRLVhdPfm7tOFmeHTY1hbsEEtAZQdmLDsT2cKKr93ZRIx3ZCWzUOslOU2UCELue2mkA6uVjL+kyAGRvc2S8Lnki3fm1euIHE0zxaPq/jM7KdQwLkRiDlyo4yDiIU0eKH164Xa+5tFW1py4Nw5P2g+KBiyDgPKZ7EvqWiPRsjc+Qr4tMIznO+Lf+qCVAk906e8Y+ELWR2nV1hGa5Rx+dHEZ8=
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
index 315e4d0d0831..a5a3f068bd1a 100644
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


