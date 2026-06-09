Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 986DCCD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 178A16B0099; Tue,  9 Jun 2026 09:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 150086B009B; Tue,  9 Jun 2026 09:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 065E76B009D; Tue,  9 Jun 2026 09:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7D9D6B0099
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:20:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5A0A164B2D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:20:11 +0000 (UTC)
X-FDA: 84860432622.08.60E7FB4
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id C5263100016
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:20:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q5ewh0cA;
	spf=pass (imf14.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781011209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzZH85xAJ3bnOHXxZ2IlyON4zc70knGPmBexsKaQByk=;
	b=G1/LSKOcL66WBpwmjZt9hT0ryRKwAqjy+3rp+rLQKIJ/vmz4u2mLoAnaWqxNRNrTzAPspO
	hPdZp7xpB0LjjWCPP0aRI47eij01H7IgdNl43uC10U3FUurSWghoZAcM1V2mMaRt5EXilI
	k6uffMAFMPmjpFg1crVsvbtE5sqmCQ0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q5ewh0cA;
	spf=pass (imf14.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781011209;
	b=o3z6DobUWlMuYuQoqJoLyctO3cpOM/bYibc41o9ehch1QxnOkj4UKNKl7M3peCkcnCJTPB
	jR+eAa5wHUIsAkpKJ0uYZ7Ho5/tw30pvQRMYaKB+/3492Zs6AQPey3y6I2kII+4QtAAO+b
	n928XAtYkrQOS5SHj8uabwX9ek/gfYg=
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-13721dfd471so7199698c88.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 06:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781011208; x=1781616008; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rzZH85xAJ3bnOHXxZ2IlyON4zc70knGPmBexsKaQByk=;
        b=q5ewh0cAcfV0KqeMTQdoMmzrB/z5GFMdRzGDzyFkspjKK3Ba/38e6nuLB60SXnlhzP
         HL2onxOOSzDcfV0c4RxqxoquqGGU73+0r0xKWl6L4F4r+tWOfW4wRY5dheIxE5z/hiVe
         SAkISO91rNrgHHWyHtr0mHq0ZBMn7qkh9tsEsqsGNtI9J0+T0W7gcLCC8m+pNRJOfAqR
         8srRpbxxQEjcqlSQQ/pux6Un/8muTQl1BkTt1YDFsPTfDehncV68CXgOsFR3NPZNgRXW
         4sIkFOrR+88Mr73leSfJln7jIpUCXVfHEX8hIw1i4EDx7oDDlMbvhtYM0RSWQdHpUe9w
         mKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781011208; x=1781616008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rzZH85xAJ3bnOHXxZ2IlyON4zc70knGPmBexsKaQByk=;
        b=Gy7v81EzUsc53Tv3eq9ekL57ORwonwAkkPvNAGbIfrfp/24Xt2pYQyfSAAockcYJo5
         Il0/TOmcKAaEA1Axlya6pVkbYNnBFMxuQzBB66UNfm+nfUGVdnqwoPnH8hfLIj+N6lhU
         C0LSHnLQQdkX5WjEAevuGFC69I0dWdzHl1s1iY2pmxLdIlPw766VJLfyjZ+XwXU6VaTS
         P4R9SuyeQO7ku5a6/h5C8yU45j59QEmMKk/cnSFidYut3QQQYM6D30XaPUTr55eGNY7P
         ileDi0edfdoNBEJFaqkd6aNEbwtSXuumqy/XGX99tXcAzBD8c17BFxGAS4LjsCH3fvWP
         TGyw==
X-Gm-Message-State: AOJu0Yzub5ojjIZAc+8P9fodo4wEEW70OV/92XvvA8RDCTLyieMmznM9
	r4eGeKiQ17YQFQpdjb3jQHxcE/HorUYKQC+8KkNuirRsWx7UtNrdjaq+aSH5Nw==
X-Gm-Gg: Acq92OG54AUaTOeHKeF5p23zX53+AOFVJBCT914u7Y2TnohGYHJuYcElEss/uOXfycu
	5dQZBUaShQMyGfHrssw2NRb0cp8ihAGWxJ/UHENS+WjonZs2UvFHJGaAtqlfiozJewi+bTFEYpP
	5H35gy9DdNFnzPpYE25fQgX6ni+6BhRNWOvrsnrs0xPwUaN1Od5wMH7qbLl/gjVFsrJrxG070ZY
	NEIlBssUoGBlaMjXKsGDaDMj8fKFvwrUj++Nl5n3jCKOGNDjSDmVe39Mu478dWbaNfSCD8IcG6v
	NuiREHdN3986omluMJ70powBT2HsA51xWW6cq/CIThzrRKp8M7PRCuE1xj3yEIW946oIDrRfSi2
	WiA3/0ueYVDSoo/vYvHg9TxLppcp4nZXjhXa+iKU7iLwWkRibm+ataSB/61oxMCN5xV+WoF6T/t
	ofav/ay8Qg3UI6BKUrawV0fH1vBt3z7ZGD8VrFd8XaiGGqpSch/DfmUwiIOJwk
X-Received: by 2002:a05:693c:3945:b0:2ea:c085:44b1 with SMTP id 5a478bee46e88-3077b22a000mr11912732eec.19.1781011208262;
        Tue, 09 Jun 2026 06:20:08 -0700 (PDT)
Received: from localhost.localdomain ([129.41.58.2])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074db55f60sm27162467eec.6.2026.06.09.06.20.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 09 Jun 2026 06:20:07 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-mm@kvack.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Sayali Patil <sayalip@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC 2/4] mm, swap: make SWAPFILE_CLUSTER runtime
Date: Tue,  9 Jun 2026 18:49:32 +0530
Message-ID: <eda5b7a6c82abbebf590ef788b4ab6810c73675b.1781000840.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1781000840.git.ritesh.list@gmail.com>
References: <cover.1781000840.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C5263100016
X-Stat-Signature: 1naidy8c6rrd7wtjts1dqx6pf99bssae
X-Rspam-User: 
X-HE-Tag: 1781011209-844106
X-HE-Meta: U2FsdGVkX19HYAWkXjk0kmGnC6rY9OMyOrnaS6nsCNj7E6T7oqhPy+tvuDhkdwn4huca2KSUA4LS/9tRYIZUbIC37UuXeYXThziEWHWPDo3Cr41ngl+OuDRt7xhkW6trdshhcUOPpGwm1nPwiwVrG+QgerShMBdGyQZuCVkHw2MZXugD3AWszPzZRQa7JEzwxdNvnWtLpmnzbkGUmM5d8wobAGSg4OjlW5NM/aKtNmEVhD4bzDn6GkYFvDyzeYVqtbgC4yAyY5iMgpk7wjgnwmLG8+yTIMSCSKLa69dfrzu43swau6U/fHkzGftB8wCzjY1yDY78fbJ27oFM6YpT8DKD21fSGwAqfbIFll0HL+VOaIcaaZ70BdDYUSdtZXf9Z1E2z/jlYkoN478cZ5xGSpCXZ9bUoOG0+dLpbSgN3xUNswUvDy9+SWgUEbt3A73AMDmVyV9nUaeWH4t7yLrobXNsUkuYYB76juqB1E3dVBUAhv3n/8JHcnmQZ2FYU4luSXKuOjLXhRSzMlvQBcFbFCJwBjjIEvX0WBszBrsQB4bY18UkvxN8O94iPuV4y3tnxFWN/liRieFfTGVPBogf2CArn9j54sssmIYwYDR5noJPALQCnmszOhe419e7gdx5gQWbGAJBWmjsiWfOFbR7F2zOrvfWKetUpYD3BtxvkVpPBXE+8XCR0L4/JGXbnwDIYZByt/H8JgUng9gXsZwExhmhhmnTaF6cdm0s+kshVRYbVBmCnCR+eI/fM1bRniDVzdsHpZXxlOMRvfcduJCltsODU5TmhZxDoN25SEB7pPyOEElcRP1JIIe+PIPgUcO2cdpHjJ95eoA5xnKXn1hCWDDOIyoAuBLFfcINBxFJZRmB4jHD+UPgosdi2bwA3I58ECOID47QWV+GsBo3ug+lCCwOalcC68UvTGjCe+wrUVb6yA1yuraQSPUYK/G8phsG7cQXSH2tTRCrTkXbNed
 Hvoin3D+
 Of754xBMX5Ibehy4zO4SA08/e5yRTsM68O8KCy4vFyt7gMRqgR85sJbC9nqGH0P9L4R9fVgYOBWPR1RBS9WBFeE053u16OTHTxZ3kiGtofTw2e1kqeGUlPkLq2zLkjzSWSR6GodSkffW2Wygu1qCaHCBq+7S7pKmg7R2rwvv+2cUaoOdi+dVUBGgp2u59E+0MHOgy4D5UGLZ3UgEDkeAp050RsxQukYQ1cOmnS+MkZs9sOPOG9phTN5DjoJpM7kpG5whdJPDBcNEcqJlEG2w23QXkJHT49jyrLej79iABJJRUxuPGCtfp1rmGfvdm1gepu98EQ7oXUaGCfORHNuuMT9jyyphZTidjfR88TDWxWDjQp0ArJlXb7H++6mcU2i1ehs5f5gIqDxWZizlbwTmBfPCP12fmb5N0I4wbf8SUghTmXLNTsMBU5Eh77cBk+dty9dQK2qltYZQ+c7obpP1sVJHunFGm16H3Nirbun4FV1fsxG3LuFaPTTPCinIwAiTwlPp5r2aFa6Wmh9TwVz/ZW5r7ceaC5q0fgEpkcdJkjxJ22epO7NBOxuEsKj864QSfMx3/X64GRRS+D8B0nQiz+d/tlsxi0kJQwywP6B2RRfBr5uQRidB/Zf1wjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This makes SWAPFILE_CLUSTER as a runtime value. Architectures like powerpc
book3s64 has HPAGE_PMD_NR, which is derived at runtime depending upon which
chosen mmu.
Hence this patch initializes SWAPFILE_CLUSTER at runtime and also
modifies swap_table and swap_memcg_table which were earlier using this
macro for defining the number of table entries.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 mm/swap.h       |  5 +++--
 mm/swap_table.h |  6 ++----
 mm/swapfile.c   | 27 ++++++++++++++++++++++-----
 3 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 77d2d14eda42..956879a69ddd 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -26,11 +26,12 @@ extern int page_cluster;
 #define SWAP_TABLE_HAS_ZEROFLAG		((BITS_PER_LONG - SWAP_CACHE_PFN_MARK_BITS - \
 					  SWAP_CACHE_PFN_BITS) > SWAP_COUNT_MIN_BITS)

+extern unsigned int swap_slots_in_cluster __read_mostly;
+#define SWAPFILE_CLUSTER	swap_slots_in_cluster
+
 #ifdef CONFIG_THP_SWAP
-#define SWAPFILE_CLUSTER	HPAGE_PMD_NR
 #define swap_entry_order(order)	(order)
 #else
-#define SWAPFILE_CLUSTER	256
 #define swap_entry_order(order)	0
 #endif

diff --git a/mm/swap_table.h b/mm/swap_table.h
index e6613e62f8d0..90e2a7852300 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -8,16 +8,14 @@

 /* A typical flat array in each cluster as swap table */
 struct swap_table {
-	atomic_long_t entries[SWAPFILE_CLUSTER];
+	DECLARE_FLEX_ARRAY(atomic_long_t, entries);
 };

 /* For storing memcg private id */
 struct swap_memcg_table {
-	unsigned short id[SWAPFILE_CLUSTER];
+	DECLARE_FLEX_ARRAY(unsigned short, id);
 };

-#define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) == PAGE_SIZE)
-
 /*
  * A swap table entry represents the status of a swap slot on a swap
  * (physical or virtual) device. The swap table in each cluster is a
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 78b49b0658ad..016a5aa0cb93 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -129,6 +129,17 @@ static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };

+unsigned int swap_slots_in_cluster __read_mostly;
+bool swap_table_use_page __read_mostly;
+
+static unsigned int generic_swap_slots_in_clusters(void)
+{
+	if (IS_ENABLED(CONFIG_THP_SWAP))
+		return HPAGE_PMD_NR;
+	else
+		return 256;
+}
+
 /* May return NULL on invalid type, caller must check for NULL return */
 static struct swap_info_struct *swap_type_to_info(int type)
 {
@@ -437,7 +448,7 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 		return;

 	rcu_assign_pointer(ci->table, NULL);
-	if (!SWP_TABLE_USE_PAGE) {
+	if (!swap_table_use_page) {
 		kmem_cache_free(swap_table_cachep, table);
 		return;
 	}
@@ -456,7 +467,7 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 	if (rcu_access_pointer(ci->table))
 		return 0;

-	if (SWP_TABLE_USE_PAGE) {
+	if (swap_table_use_page) {
 		folio = folio_alloc(gfp | __GFP_ZERO, 0);
 		if (folio)
 			table = folio_address(folio);
@@ -471,7 +482,8 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 #ifdef CONFIG_MEMCG
 	if (!mem_cgroup_disabled()) {
 		VM_WARN_ON_ONCE(ci->memcg_table);
-		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
+		ci->memcg_table = kzalloc_flex(*ci->memcg_table, id,
+					       SWAPFILE_CLUSTER, gfp);
 		if (!ci->memcg_table) {
 			swap_cluster_free_table(ci);
 			return -ENOMEM;
@@ -3912,14 +3924,19 @@ static int __init swapfile_init(void)
 {
 	swapfile_maximum_size = arch_max_swapfile_size();

+	swap_slots_in_cluster = generic_swap_slots_in_clusters();
+	swap_table_use_page =
+		(swap_slots_in_cluster * sizeof(atomic_long_t) == PAGE_SIZE);
+
 	/*
 	 * Once a cluster is freed, it's swap table content is read
 	 * only, and all swap cache readers (swap_cache_*) verifies
 	 * the content before use. So it's safe to use RCU slab here.
 	 */
-	if (!SWP_TABLE_USE_PAGE)
+	if (!swap_table_use_page)
 		swap_table_cachep = kmem_cache_create("swap_table",
-				    sizeof(struct swap_table),
+				    struct_size_t(struct swap_table, entries,
+					    SWAPFILE_CLUSTER),
 				    0, SLAB_PANIC | SLAB_TYPESAFE_BY_RCU, NULL);

 #ifdef CONFIG_MIGRATION
--
2.39.5


