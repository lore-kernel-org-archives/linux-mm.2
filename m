Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F6E8CA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64E56B000D; Fri,  5 Sep 2025 15:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEE1C940007; Fri,  5 Sep 2025 15:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98F56900002; Fri,  5 Sep 2025 15:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 819C06B000D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:15:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 47CB513A264
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:15:25 +0000 (UTC)
X-FDA: 83856150210.19.67519B2
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 515C84000D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:15:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mFUeTq94;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099723; a=rsa-sha256;
	cv=none;
	b=tGlBRhwXD/apeMacg3INMA6yOSPyXDomCxSzu69V18qk2SoGc15R3rcPhCAwhjMn2Wccq6
	HMxWmlMUZnTF6UNbhgbvLIRV7i7iZIzOjP2TtrshZMDXrV6u2uiMZ3/JwCyl3hp+N/udVw
	qLJOH6h9n7xSqT6Y5NfV9MUdpB/qzLc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mFUeTq94;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099723;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTNtn8bp73dj8smpZWVlmgVZUs77+apTLTbhCM2474w=;
	b=VpjmsZf88dFG3hJmp0zH5MHA4ZfPsC2OPFfDiD/0tVyhRLF7U701vzV6EGlcd+d6MBny5B
	zCcYDmCddxV4WWahtfJIQQosPKDJxDzKEH7euJ154StdsYZLBF7+gzMgWQ3genpiZfrrhE
	nU5b3jZO1CcQdAFfXG2lxVuFs1O77yM=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7724cacc32bso2025729b3a.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757099722; x=1757704522; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NTNtn8bp73dj8smpZWVlmgVZUs77+apTLTbhCM2474w=;
        b=mFUeTq94y78RGR9IjjM6GEl8d0vnGxxP75r2QC+PkUt5UNnaOaBliFP3d8fRgi44Xu
         0O0YHvC9zt6sptKYvcP80EMiqRgB+qZFz7oi5Lb8eMvoiQFtrwZPEnqGz0zgKC1oUMzG
         mR+XZvPT3NZHi4FkwesXzi73Nc08jUL/p0ydm5NCXOlKxCzKjJiaviAgVwG3kz9j6JPh
         iPSaPwzk1+SILebUp2uyGnUdCqgevghbjQPYNqGFgyhMcY7GwsCeEu370AHjzJcFWdF6
         UXKA3t40tFTOTgpaUXlSBG0UWy+mf5k+oXdB9qruhxs/OYzgkdR2pBRsjxLPjn3g85y3
         iing==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099722; x=1757704522;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NTNtn8bp73dj8smpZWVlmgVZUs77+apTLTbhCM2474w=;
        b=I6YsdzRSntcSdXMEMJc2TqX5+MPJey1EcRFXMqvMrzeEU8dSVxSbXOOUy4wdXRUpj8
         EO2jIge/m3DRtS4lR7XbFWeFhcVnEVb+90OfsgvJwRQE/gYobWRhXlnRuSE0fpDglAwf
         cv9iexepMHRUDIKFZqZ+lYxo5ZqSvQ6vrSeGR5q+kjVO9NLVLW3xa2GjXf7l7eAaZEiN
         wC89+cl3cGXPjnl/ATDWG5ObraA/695mGZzVb458ET23YBgRlxYkD5GWv89/C+lMl76U
         AEtZS5xljLgIGcSZEGssNpryTyT6sBZUw+Xl9C/U4Jt6nPwFZFLlmlRCDQ736CtY6bcY
         9lZg==
X-Gm-Message-State: AOJu0YxSMVPiJAJzLWqf8JJ8c5qI/5XlBfLvNtZwiDQXqFf8sNA0CV7V
	0FlSMSJxkdlgiYEdvF4ZCZglksZ3kfEyOP3I1R4aVNbHQ6+SHTLrHDg4coJAe3xdiBk=
X-Gm-Gg: ASbGncth9sV+BwFcSyXcaQRN0ivYpiX5VgeSVty62vxPzyH8YUZSEpSmtqnxwm05Kxq
	cQeRpCcScIEZy9xm/brTGYpGa60sNXMeEi2Zs617kcMgJlZZG0v5UGb80zfMxKcJlvd1co7DePS
	LddDDCYYsBWtQ9Q6GhGdi9zwZhjNw/pIyVtypNRzrJTdSZKimnXswausyacgnnY7Qp8FZEPZFAC
	AYtFMgvUatPx6WcRrPBAl3qubCjC7easZ6WUCMxmaaPHV4BjsJqewzemc1Ytj8A7cd6ztn4MgOA
	x6Z4OYWJw2o/mVU5KLVsTf/aALvuziJelaeXNw1OiBAjAg09bpEFKG40O8GwhvXRpYJ+9o/jKcm
	RvLEUcxSrvPnCwKdlf/9ldHDR0Ow3jzlVxh6T01ORUP07efOjqo/t/hhnnNTrPd9cWMwo
X-Google-Smtp-Source: AGHT+IH96qTgWSibnaaMdWjrVapYmHypSxAQB9nXdv+S9Q7X6ROZXhBXtRtbecK0Xwab4dhhHrwjCg==
X-Received: by 2002:a05:6300:218a:b0:243:9587:a743 with SMTP id adf61e73a8af0-243d6e06239mr30146256637.23.1757099721686;
        Fri, 05 Sep 2025 12:15:21 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77256a0f916sm15871442b3a.63.2025.09.05.12.15.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 05 Sep 2025 12:15:21 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v2 13/15] mm, swap: remove contention workaround for swap cache
Date: Sat,  6 Sep 2025 03:13:55 +0800
Message-ID: <20250905191357.78298-14-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905191357.78298-1-ryncsn@gmail.com>
References: <20250905191357.78298-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 515C84000D
X-Stat-Signature: xbiof5j551b18nhboctjhsmwfi8a9y4o
X-Rspam-User: 
X-HE-Tag: 1757099723-226515
X-HE-Meta: U2FsdGVkX19PeLD0uTWTi5wUmuOO+j1sgakeXyGaQY34JMN4Vz3J35n3lPhh6RSgUFVkT71P+iYxLwioC/Xn0JwVYe1T5t4m4zjzPI/csEcMVXUkiR9Mqijc/nzHtsNEa88N8aSAtl0mla9hTyuzFXUZXXVYa+aV4Qhydzv8ZgmcjQ7UbYs4nivbOX6NSaiasZHUCd9wRjOHfHpZBV4FauJQsWgFeYnSVFengDIdliBnGvWhvZ0azmyEBjuYUdK5ikrCLKw1wCgTjEAj1rJ40Tz5bre1H7h1Bic2spzFcnsHZDUkxGkRQL50+KN0I1Ym1yju7msa/pxtlaW0srGwAdxuXF/T9EyCcreAkKNsKmCb7DFd0KU/6/YVOzUIxkQ75KcVOUZ41VU7I4cQl31ENquCoV5MsR29i2bYXZvuxXUxn37vBTBhF9c4u0zrJLlaDFoWcjeX/1cwG6gGf2IRlyoOpMAVphqwD8Nm+dCXTuD5QPqVSuzI5XoCBzVw6CDNb3MtPt1R6wEc+50g9w6KWCu1QVLNlwDj7QmY+6g6+yiw81M5fGTeiRdzVP5caZFTp8788ORi4cBhOqjiQhwfgMy1wubfRUHtkd0PJorkiGmTXG9sHSW04arPYv5KiNNIr85NSrlzzWzuJmBNlo7CMMulOrqck6uxa8mFThjp71mKvsQqmJPgGcT19xTtpAoPq9ODpao2OhT0on0YmZWGkkNo5oPo6NLH2QtSXAO3Wp5aES+cZXJxxT1Z4DBFrY810a9ozCl+7/0vhCc2dbzD1i8/ZEfhT/nqok34VzdLslCwhlM8zSjite2tae4QravyWKdP9jO+2F2MVDqMeCXcEBPMmuxDrA25LKuNUIDHlgtPPzT4eOosu8kiT//RF7L+6KV+ZDTd+XaHC9xfIdrdqyPbuGCQdpaYvGxZuKhXPVtSpr2HwOftnS8NajqJrwwV+yAI6Qcy889uAE8Uoa4
 RKdIGeIo
 jncQZdzd3RZGxS98F4mI3vvDfyNjOavyptPDO3r5INTjF+3bjQYJkD+8H5ww/BNLAn0ScUOXnpPT5nCmS316rI8z1DOdy/PmT7864g60qJIGEOjzkWwEVzfFwvW+4llw4kPbI0f1kc9FZymsHBr0Es2Ha7/bqG89De7oiq9KGGgIBpnbkhcL22vmtLNgHy89UXeM/DLCZvEmDSndcsLHOxBGuLXPZjJVDsmwzRGxpAO2AkqIuFiLIFgGCSw6HThyaMI5C/QjDfyTeflecGw2g87iOVShvD7+NYoWkCYDaOxOpLMjluYAzUvcf7eECxfTjx0KvycgWvN8Ht6r2BE7/cpcvWkdTwjoY40VBuxE6nUPukGG4UzTSZtGnp66+NHUix+3c+zuOedFMVqQ4Py1N+YWdyV/RtU9Z9RgfHSAIQhKtDp7HN4zYuGwaplcfNZQRPNqIUouD/mtwknW3D/j98CXvoMovwmKqZhNGYEZ/IZP7RhzyL29WuurA3Hg3dOjY5fk9umSu388ToadtxejUMQF2UFZKbcmOkUODwyB9upoQowyvvuQrCGCH4xzWwR4lbrv6tq5NYuY/sve+FPNcYOjOEmarTsU9b2jtzm7dCW4usWCLUjcmP4tXdQ+9KfjKnE5WplKIxJHjDAz2j/UG/DHvO0GkkR9gLCN5e9bhD0l/CIBVSV3oTKPMbqQ9evKpoT/aUmUXdlP/oo4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Swap cluster setup will try to shuffle the clusters on initialization.
It was helpful to avoid contention for the swap cache space. The cluster
size (2M) was much smaller than each swap cache space (64M), so
shuffling the cluster means the allocator will try to allocate swap
slots that are in different swap cache spaces for each CPU, reducing the
chance of two CPUs using the same swap cache space, and hence reducing
the contention.

Now, swap cache is managed by swap clusters, this shuffle is pointless.
Just remove it, and clean up related macros.

This also improves the HDD swap performance as shuffling IO is a bad
idea for HDD, and now the shuffling is gone. Test have shown a ~40%
performance gain for HDD [1]:

Doing sequential swap in of 8G data using 8 processes with usemem,
average of 3 test runs:

Before: 1270.91 KB/s per process
After:  1849.54 KB/s per process

Link: https://lore.kernel.org/linux-mm/CAMgjq7AdauQ8=X0zeih2r21QoV=-WWj1hyBxLWRzq74n-C=-Ng@mail.gmail.com/ [1]
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202504241621.f27743ec-lkp@intel.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/swap.h     |  4 ----
 mm/swapfile.c | 32 ++++++++------------------------
 mm/zswap.c    |  7 +++++--
 3 files changed, 13 insertions(+), 30 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index e48431a26f89..c4fb28845d77 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -197,10 +197,6 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
 void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
-/* One swap address space for each 64M swap space */
-#define SWAP_ADDRESS_SPACE_SHIFT	14
-#define SWAP_ADDRESS_SPACE_PAGES	(1 << SWAP_ADDRESS_SPACE_SHIFT)
-#define SWAP_ADDRESS_SPACE_MASK		(SWAP_ADDRESS_SPACE_PAGES - 1)
 extern struct address_space swap_space __ro_after_init;
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
diff --git a/mm/swapfile.c b/mm/swapfile.c
index cbb7d4c0773d..6b3b35a7ddd9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3202,21 +3202,14 @@ static int setup_swap_map(struct swap_info_struct *si,
 	return 0;
 }
 
-#define SWAP_CLUSTER_INFO_COLS						\
-	DIV_ROUND_UP(L1_CACHE_BYTES, sizeof(struct swap_cluster_info))
-#define SWAP_CLUSTER_SPACE_COLS						\
-	DIV_ROUND_UP(SWAP_ADDRESS_SPACE_PAGES, SWAPFILE_CLUSTER)
-#define SWAP_CLUSTER_COLS						\
-	max_t(unsigned int, SWAP_CLUSTER_INFO_COLS, SWAP_CLUSTER_SPACE_COLS)
-
 static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 						union swap_header *swap_header,
 						unsigned long maxpages)
 {
 	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	struct swap_cluster_info *cluster_info;
-	unsigned long i, j, idx;
 	int err = -ENOMEM;
+	unsigned long i;
 
 	cluster_info = kvcalloc(nr_clusters, sizeof(*cluster_info), GFP_KERNEL);
 	if (!cluster_info)
@@ -3265,22 +3258,13 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 		INIT_LIST_HEAD(&si->frag_clusters[i]);
 	}
 
-	/*
-	 * Reduce false cache line sharing between cluster_info and
-	 * sharing same address space.
-	 */
-	for (j = 0; j < SWAP_CLUSTER_COLS; j++) {
-		for (i = 0; i < DIV_ROUND_UP(nr_clusters, SWAP_CLUSTER_COLS); i++) {
-			struct swap_cluster_info *ci;
-			idx = i * SWAP_CLUSTER_COLS + j;
-			ci = cluster_info + idx;
-			if (idx >= nr_clusters)
-				continue;
-			if (ci->count) {
-				ci->flags = CLUSTER_FLAG_NONFULL;
-				list_add_tail(&ci->list, &si->nonfull_clusters[0]);
-				continue;
-			}
+	for (i = 0; i < nr_clusters; i++) {
+		struct swap_cluster_info *ci = &cluster_info[i];
+
+		if (ci->count) {
+			ci->flags = CLUSTER_FLAG_NONFULL;
+			list_add_tail(&ci->list, &si->nonfull_clusters[0]);
+		} else {
 			ci->flags = CLUSTER_FLAG_FREE;
 			list_add_tail(&ci->list, &si->free_clusters);
 		}
diff --git a/mm/zswap.c b/mm/zswap.c
index 3dda4310099e..cba7077fda40 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -225,10 +225,13 @@ static bool zswap_has_pool;
 * helpers and fwd declarations
 **********************************/
 
+/* One swap address space for each 64M swap space */
+#define ZSWAP_ADDRESS_SPACE_SHIFT 14
+#define ZSWAP_ADDRESS_SPACE_PAGES (1 << ZSWAP_ADDRESS_SPACE_SHIFT)
 static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 {
 	return &zswap_trees[swp_type(swp)][swp_offset(swp)
-		>> SWAP_ADDRESS_SPACE_SHIFT];
+		>> ZSWAP_ADDRESS_SPACE_SHIFT];
 }
 
 #define zswap_pool_debug(msg, p)			\
@@ -1674,7 +1677,7 @@ int zswap_swapon(int type, unsigned long nr_pages)
 	struct xarray *trees, *tree;
 	unsigned int nr, i;
 
-	nr = DIV_ROUND_UP(nr_pages, SWAP_ADDRESS_SPACE_PAGES);
+	nr = DIV_ROUND_UP(nr_pages, ZSWAP_ADDRESS_SPACE_PAGES);
 	trees = kvcalloc(nr, sizeof(*tree), GFP_KERNEL);
 	if (!trees) {
 		pr_err("alloc failed, zswap disabled for swap type %d\n", type);
-- 
2.51.0


