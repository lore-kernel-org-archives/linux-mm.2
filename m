Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F073CCD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 18:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 652DC6B0092; Fri, 12 Jun 2026 14:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603B36B0093; Fri, 12 Jun 2026 14:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CBCD6B0095; Fri, 12 Jun 2026 14:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3DBE76B0092
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:09:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 07F99A01DC
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:09:45 +0000 (UTC)
X-FDA: 84872048730.25.BF83A54
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1173A180007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:09:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jg6nmnMd;
	spf=pass (imf24.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781287783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sy5B4Hkkhz7VX1oSnZgSOogbp7pZpM+mVFfKtzTdJuA=;
	b=HIbdaRxgS8FKaVqV63Z8z5t5/r3sGVgjtixlMWQhLxTf3QE1iF3XeLNP5Jz8lGuCxBU0SJ
	C5q6+bg9eZTI0sqh0iBfzG/by8bYnc8WGoIe4A0hX4jYQV7+ZXznYZCiLvf2Eb1VIgeanU
	mqrkdz8DOC70b5yFCajhnqabzwctlEM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781287783;
	b=4wNzeXU+lf0eewZm5MIyjyQNYeXttqrp8oWsHbCeXjddiPoJzbPwJ6JmSUvXwwgXHjdbop
	nbwHXsQYYhF6KmV9MtX8Y3bwTuvtnO+G73z0OjXgVrwSO96m4njeTxA4LnlRE79vMUa9d/
	aDxpsOsDQFBZ0HHj8cDq2gvFNMkcx4g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jg6nmnMd;
	spf=pass (imf24.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2bf1f074a12so13550935ad.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781287782; x=1781892582; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sy5B4Hkkhz7VX1oSnZgSOogbp7pZpM+mVFfKtzTdJuA=;
        b=Jg6nmnMd4EDKgesjPl1Hj5zP4v7tW4cwHKpdNkmXikRnKLVTPLcEZ2tEJGDJ4OO6jL
         07uptxYdPlIuil0V+zZ3+yEu08CxKdnevAKBwhVgR6d0APAb0neECheJ/xZqaHBoZtLp
         lHRVB00uZW0RcmG028whAZISmXbsvu/cMzTKXn2tTNfqg/wbMWHf3Nel6AWD4voOZpzL
         CtK0DSOja8YtXF09XCQsiiOoSeNAXTvdUnLQvzfQ1YbmZYk12P7UdG/YQ+w2dMymsI7N
         uxtQ4SbUjCd561c/A097Y0JJBUMapxmUTmk2jERpmX24sYuGr7z6T7F/yASQtySvjri+
         7PGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781287782; x=1781892582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sy5B4Hkkhz7VX1oSnZgSOogbp7pZpM+mVFfKtzTdJuA=;
        b=B7Woo/9MCA7deQGyn4YTynTXr5sKouiIknzzkzMG9f7eOGPCPRF6rTEIAt7q/Wt+/k
         TMzS7Z9QJ0PGOtRlKd8rPoHFwWIdc0zQwGXu5hP+nCgtrREdQpWdgepG5bakq/CPRGuc
         2oYvoXtWUaRj0Olr0ALZVoiybUH/sCs624qZ+vyIuqOwRaOvChVndE5uD8cGDO5LzgKp
         NcSARKF5tmI8qRLV13b/GDrgzZJQSSy92Yb8g/rB5v7OSQ2X55zm+kbJ7dC1cZiDmTYc
         F8hCq7adxZxJKOpDPFvQtCgGtqO3iMMEcoVO1khmOjl+WWAbySrcIrRvOMLwYBj08p3l
         rWcQ==
X-Gm-Message-State: AOJu0YyzcryuDrbCaLjK9XVNAGHK0MYIUBImZ7czZQmuLZ4PbI11BGaN
	pXrWd9q1Mbp7NGZWjPY45S04rFILx1FuDN4KWVDF/CS1YGbwviLWisFNnjBYmmJ5
X-Gm-Gg: Acq92OENsaaUH2rQSzuj5QXTVviPHQYhIlvfaC88z86Va6zRx2xZqymSPfS8Sa58YWb
	+N+Z6U0MMxHk+OKr0r5r2we2PziwasKNKotQ44o+VGh/P0gxbIp/uovntfLd5n5zHAD33Ix3VeZ
	bHVhFzPGqlfV5uwo9VEgB1QcH9WZUTEZmg6pGTAfe/mDL8E8i1TlXu/4fSRAYXZyrNMsPBKVR3a
	6oCNc8NAilZ2TcQRhDZcUQXeMIYo/ADuAU97cDP13ORkzlgO3AZiJjmZt6E7fP/Kj1kFGkv3dbg
	CrXFoMVmdrKx22+d+DJQc8Cd0Zb+dNX6xICcDWALpWIoB/XYNkWpI8jqxvJkZUzowG5gbV25Zxu
	5x1PBRpEjVxY2bO9WjUqRKTOuy2aHWHlCHkw53yai3gxcM1/Y0S1ARmNjX8VHc9GjUzb0Ur/bb9
	arHqbBSiWqbrL9BYdO2SMJO5jQb6M8rHcCCXmdpSXCVfA=
X-Received: by 2002:a17:903:32c4:b0:2c0:b6c7:2271 with SMTP id d9443c01a7336-2c4109ed38amr47426415ad.4.1781287781888;
        Fri, 12 Jun 2026 11:09:41 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f7c70easm38956975ad.25.2026.06.12.11.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 11:09:41 -0700 (PDT)
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
Subject: [PATCH v3 1/3] mm, swap: make SWAPFILE_CLUSTER runtime
Date: Fri, 12 Jun 2026 23:39:15 +0530
Message-Id: <1e8d7e4d0bb1377277ae8b6561d89fa0e048e7de.1781287297.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1781287297.git.ritesh.list@gmail.com>
References: <cover.1781287297.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1173A180007
X-Stat-Signature: fhpzdh18p4we18ippfunzzsteqwfimg6
X-HE-Tag: 1781287782-714564
X-HE-Meta: U2FsdGVkX19kLV0oIjcv5zCXVhcf+26O8PCLe3nwE0GHjAcmhVdlEaPG0ytylhrdmwPCMCMVCWzswecLliQwn4OkbMeZ/98nq+VHelay5Wt/4vI0NJLk3HSS9rQXTblyiHwdYIbMTME5eNsCs7vflORHzF94F/Z06vLsp7bU/XIYQ9o7tHbMHYKdHtAfhECaUFB2OMjaBy+l+0uKO3bDh8G6nzaU1ZtbIwL18pA8pMGBebdX3cKvuCSvIDdr9FHoCmajIJf+GoHoAlIa21XDenlfHCyLS94MZB2oIi4p9z8OojsoYmzHxU5zRJTcYNtK+T/4FtGQpZsLkzc8/UX63NrmqdbD4L8qujEBLRcUNkasR1HFKYKqjrXdsG+KTqPPJC7eeUGIoNx/mI/FA7r8Ti74gnz303XEsELOiaGrU3PrPy93ekchWdGPsrpTZtgk2qKOu+4eJUn4m9DkdZQnja8LA9UDD/5RAQx0wk4AZyRtTQKoVok8P7LGzrUSv8uaAOeKvzY/UJyZ/mVtu8eAjSPGcWHsMC64oQd0BfqckJJD3/UDaTQyXocD0PkxSiUwER8b3PrSzU9wsQrfnU9YLVclsVN59ndFoJA/gmXM810YMe4h2xVki5d6krPYHqATP5yv02pHtQaFbXLLUBGCb+8etSCnNx7gIeXOYjWHT3b09nf6j5cXLUljKhdPmg78QShGoHtpJlpyy3aGSwdmiMfbnjaNqqkYblJxCQWqTSadqMi3lteQnVQdI6LIayqSsS20L6VgypTsFvCb7d2LEmwpjpNImlGBX7urq1wQPrQm+7wOkJFh2JzUw7nQT5yQgmqQStoRlmFbIJHzuAkdW0VnA2+dgdUb796bpNFwthVTPLhKZ8wI7I63f4DbPikqYQl1boYBXrvn4ETeYr2gHnLzzxA7KuH6RPAugT2Sw9IPUuF1ONWR7NW0M7e+zTFJq1UKV1mahjkilZ0Bi9i
 7NDVIakv
 o+rnvaIMa0C4ZA8mSESTspRE+XVteQJJV1ADEASYy5oXjH+eucTzyvoh2gjmdPOR1kz+8dXX06xmai76pCFUsILIsephpT3g8vRGrbsKRH0Exc/F4KleYuNoZwvZ6YmcDE7ARVw62Vy35yP4Dwan0WYg17zRyI25kxVCBYIdhRoS7IY4R7RdDJULmR2fVGRC6LckSgBpuwM1EGmcKARmRk1wN2qAIO38K8x/sAAsdDDl4oyEefvk1B8SW/kA1yfhZ63Yc8YUT1YAsTI1ji8F5K6of9NUnKuW6E4EZX0gbO7sADSg0gcLXTRaaoNIXdHZLOdYl/oSdColNQ2NetElud8zDpU7aY+6paa8WIObilzJIyU7FrvJxXWAfVqC8BoVQR1xzefspaUX4ACAsrl8L/jx734V8DZsQ/YwbikeFS+liOwg69ieJk6NHzJdyA8Rl/UxNeL955OuM92z+/d8dYVjcw0ICD4FFBg3zxL0YKzDhWaKc9YNkxEm7eGTHVN3qf5unnTCiaq7BOi6esXbuJusLKjXV/PvMpcST
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
index 78b49b0658ad..80846bfb5f76 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -129,6 +129,17 @@ static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };

+unsigned int swap_slots_in_cluster __read_mostly;
+static bool swap_table_use_page __read_mostly;
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


