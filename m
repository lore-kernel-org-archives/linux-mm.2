Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9709CD98E6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 04:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB9806B008C; Fri, 19 Jun 2026 00:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B90BC6B0092; Fri, 19 Jun 2026 00:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA73A6B0093; Fri, 19 Jun 2026 00:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A8A66B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:41:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C53E4C17E2
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:41:28 +0000 (UTC)
X-FDA: 84895413456.01.45D2669
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 07BEC20006
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:41:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jd9ShQnK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781844087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nDwlvER6qvScgrv7Fk/iPlt0cLfE/eSLJgReW67yP/A=;
	b=z/E0KYKr7A/wj9K3eQtm6/6i+biYuizUw/Rg/B/Cyqq448hqALHtfGkxFfZRCk5Ne54mMs
	mFqAGE+hPdaALxzhDcphpaEL/oz/g7h1aVXeuWCJ/hN2BwCFla66W05RuJR3PZVFUcPJV4
	8pWvlZSTHkBj9/ZQYUP3KxrJ/b77ZY4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781844087;
	b=vWQS5SjJHVqoaeP1Yt5pmRndr+jdPKfch2UrPwQyL72RGyPpxpsfrO4UhN3ib5eaOJ4sbj
	jm7z1titBGp+vDTeY5OtAc55ZppxBn/lf9t+Wqh4rZoVhXC9/437JKSKIIlXppse3EENCH
	atQU1n0KzJLPAZOJXqL/XqCkt5c5Xz4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jd9ShQnK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2c6c57c5c07so12217825ad.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 21:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781844086; x=1782448886; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nDwlvER6qvScgrv7Fk/iPlt0cLfE/eSLJgReW67yP/A=;
        b=Jd9ShQnKgkKziAN6SFZNy7HPDHw5K1rB37N1XBKz50mVIIK65SaDzV1Y6oVWb31o9r
         3w3L67dZNhBP72/l/iJ63LxjDq5SqTGCDxyAT1BKzR1a0btWb6Ql4ttOCKWV/64yVSoy
         DwEjFNQpKkCXedxULZIvbPtahAX6YQhY7oy0nYlljzZQYM8Usl6imTvO/EIyCLr+5DCc
         JmiZTlbzYl2JfUUDhD/2PCqHZrAVHUCD0knCk3UXUtI+KvkUptcJ6yXNxB8a37FNl+zh
         m7m/vukiLjFPbeqXJXLAPutxF6WCMPnhqTFtD2ENAapx8pfpyV+DxLVHKBP7ytsx3C2B
         iyMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781844086; x=1782448886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nDwlvER6qvScgrv7Fk/iPlt0cLfE/eSLJgReW67yP/A=;
        b=SlubNfL+VVJL9MktEYTp+E6mpYaSn7IBkdeMi+mWH0Nr47K32+nboj23vku/pcjsV6
         PdjaaSGaQX+JX5gd9qUwoXQ7R752voURkJLS0/nsT7O3bSUguGxurpDx1UmMRXV4YPhm
         3RkW5zArk4zxuwxoKitQuJVn8vLEVug47HvmibroGQvwWXLzKLQiTTl7VgL9uHZQcr1Y
         UW1w3u/I7yyfOHubhQcdQw6gWhYKqMPxSuod6L8FKu0T7gB88LmUg9tfDGKvm44PNkaC
         rT7BTHupy4Jj2CF3BvLyaxWb8uuEEeznno6ATG/QjSnvstsic/w+Fac3MgV6XizM9Z5G
         MSaQ==
X-Gm-Message-State: AOJu0YyeJcgc+mA2qgwqUc7D3naXmQcSnHZqq+fE0QPIMfRKvLvRh2V+
	LnjApcIPFb3z8qPJUSv89ICudefNE9KhZhAhc0mHnlUIBibEfhJtXNwMQdlpVg==
X-Gm-Gg: AfdE7clpiJYzBbDmKXTbxI9j7Q+V4uY33YGrrxQIIT+6RTMefNbf2KhijJX/2zeiQF/
	UWyuwoNzN6W024aChq89ScPVyoPDNsogkZU5FLYX4cozYWGrI5s77pAQztFuYT3zHG//PqxNMLo
	UNHy95AYBG0BWzUgeEndIZJ4srvqmO5xWazGd2Jgr3GvH7+4+toUJsXsLgDJPFwcA9b/GzCvYj0
	qLKZzfOqFW+tcTeMGK+XHmYZpQURVc9uS70Y9O8WoRkXOwSw9nHGzbpRhIKbv1ubN4Rm/lbgm+C
	WZA5QZ9Czeqqwwszo2HeRALY/6fAGn9IVYlcogWoxsEhx0KSqGJXGaB3drsPMRGpRwnuxaVD5uS
	JKcA45Ym1K+YJSXuUlSqz9uwIsq4MA5jyyU8FFvbgEeQbBUY7xex2ycT5SIW5cAUG7b4yxG3vGm
	aszO2rkFGvIJxsrKPsHrBEpw==
X-Received: by 2002:a17:903:1c1:b0:2ba:4e84:966 with SMTP id d9443c01a7336-2c718fcc7a6mr23166285ad.36.1781844085879;
        Thu, 18 Jun 2026 21:41:25 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7208e5760sm8293735ad.36.2026.06.18.21.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 21:41:24 -0700 (PDT)
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
Subject: [PATCH v4 1/3] mm, swap: make SWAPFILE_CLUSTER runtime
Date: Fri, 19 Jun 2026 10:10:57 +0530
Message-Id: <e519e98f51be2d310367e39df0935da79001e535.1781843449.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1781843449.git.ritesh.list@gmail.com>
References: <cover.1781843449.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 07BEC20006
X-Stat-Signature: p1ub6xp4mimkyqioqnoigszf3owrt5nj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781844086-32155
X-HE-Meta: U2FsdGVkX18Z1n7v3TK8x2qbvSIgdomQX4Z2zVW0uKYB9dLliMlF53/1+gWxhySMJpRg1eF6R6JDBWDR9eUsJnu1vrM2FiFBd2Vkx858CdbBPI/F+lvs7TAZqP4hF23FzIUT6GO3VKY/UxWtjcp+bnTrRplKzJynT7CUdn3tJ6igBTijOumpUp2d+8ZbhuxCFse6GjPjAABuXaHC4QDub87TRe54WDz89h64OjQJ24IGRuDQ+6sqSXf2Cthwj2H6Vpx4HQrfj1JRbGBW9oOsPBOQ+1k31n4tYBlx+WxGe0Updw5AtLStWgcagaf1ti5kaL/eucZHTs72o9jRvF1afYTxLJAcIhscO+ZXBel7bEVWv8j8M8aZaNHVxetMQvTBDvbF4ufI5pCygoG9imcna8ax764dYhKVTJTwPsMTnbYXMW0uV9QAstSkxP4u/XumkmjWZbubDllfGMx91/qzU2vtVHZ+vcxlRO6LuBff2ocumy/7kkOc2v7CPxaUziAjEBgp60MKpP6OpvWJGFm6ZQ/VG9tYLveDFdlrRmZPpEDn7iGnQUKMAvb0Chp5kc07O+AWGSbPAmvKqbzf6y/KqDvSh4n6qA1AYSTohOqQ6SE/DeF4Z9wQ12fxlk4gyjPs8kiHLHFSNeikr4xbhmvYMX+NSfvmd5IcArZLsZv6uXEnEzw7+4I7VfVfilNLhJEywckfRMH0aj8i/0esEQUQnAP8CR8A0IN6/p/1Y6ifHNKHzux+I7nJhza/vzm76x90q1vv4vQzovgMLA24EoYG2wWRikRUnHPjcSf7VOF/fd+SgchIH7SjRspm0hmnkPxUaAvSpASPdwaImt07Ozv7ZsXD7IPW9Fz1xdRM04fpTl6GEGx4YBQKEigxGYifOd9oguJAcWz7xBp3jfbZTAUydO3PWnR68RBpLjLnYJHoflF7xb/YJCzjXhGfKtXQLNTeoHNtaOLoo5bVEdEeDug
 mlOchdtx
 ZYFoBgoGp0nVNiX0SKaSMAY0oXT6eux3UoeS5+75Yk0nTcYXoivA2YBfOhswedMf3ixprIt5uXM1VyMTAiN6MBzlSejVfSTbajAmpYHGMb/n1bZJ/rqlQqEJO/CGIMEl1Cbf1TiYqIm5+E2jx07aqLJrynVuEjvw+3V4YC+ChseeOZ8M+sgh++6Isb+D13SBCtHNrS13w7GIQqhgylZQ21odHXj/EYbumW/lICh7WIYt2jYWgwrp+a2JW54gE5JQfT9cvK9PSQ/CheMI9wPoTrYR8SP1EdieXLgONPrWqYqVqbCNKl2a84WK4KzfLgUKgynuwLLrWGKioW1vhbJFtjZ3Vst94taYljxMCCkvITGemA4UHxoefr7y3/1NKPUs7X+pt9hNzMbAJD0opb4F8h/V89ijKvgsuug1GbEO9CiEy5XYbfoqZqewrOOyLN+78Ew15Mk51++ST2N8XucYGJwcpxmIX+/dC+AvVaqCHK8xkevcwhgRRKxFGPF8wUDOh9ErTSaNxaHYshUeEFXw6KQR6Q8lE/k6l57Q6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On PowerPC Book3S64, MMU is selected at runtime, so macros like
PMD_SHIFT are effectively runtime variables in the Book3S64 code. THP
swap code uses these macros to size some of its array data structures
based on PMD_ORDER e.g. SWAPFILE_CLUSTER macro is used for this very
purpose.
Hence this patch makes the users of SWAPFILE_CLUSTER to use this macro value at
runtime and also modifies swap_table and swap_memcg_table which were earlier
using this macro for defining the number of table entries.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 mm/swap_table.h |  6 ++----
 mm/swapfile.c   | 17 ++++++++++++-----
 2 files changed, 14 insertions(+), 9 deletions(-)

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
index 78b49b0658ad..4bf11c5b87eb 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -129,6 +129,8 @@ static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };

+static bool swap_table_use_page __ro_after_init;
+
 /* May return NULL on invalid type, caller must check for NULL return */
 static struct swap_info_struct *swap_type_to_info(int type)
 {
@@ -437,7 +439,7 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 		return;

 	rcu_assign_pointer(ci->table, NULL);
-	if (!SWP_TABLE_USE_PAGE) {
+	if (!swap_table_use_page) {
 		kmem_cache_free(swap_table_cachep, table);
 		return;
 	}
@@ -456,7 +458,7 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 	if (rcu_access_pointer(ci->table))
 		return 0;

-	if (SWP_TABLE_USE_PAGE) {
+	if (swap_table_use_page) {
 		folio = folio_alloc(gfp | __GFP_ZERO, 0);
 		if (folio)
 			table = folio_address(folio);
@@ -471,7 +473,8 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 #ifdef CONFIG_MEMCG
 	if (!mem_cgroup_disabled()) {
 		VM_WARN_ON_ONCE(ci->memcg_table);
-		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
+		ci->memcg_table = kzalloc_flex(*ci->memcg_table, id,
+					       SWAPFILE_CLUSTER, gfp);
 		if (!ci->memcg_table) {
 			swap_cluster_free_table(ci);
 			return -ENOMEM;
@@ -3912,14 +3915,18 @@ static int __init swapfile_init(void)
 {
 	swapfile_maximum_size = arch_max_swapfile_size();

+	swap_table_use_page =
+		(SWAPFILE_CLUSTER * sizeof(atomic_long_t) == PAGE_SIZE);
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


