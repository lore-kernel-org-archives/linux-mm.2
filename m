Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BFC4CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 07:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACDC26B0093; Mon, 18 May 2026 03:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA57E6B0092; Mon, 18 May 2026 03:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 993CA6B0093; Mon, 18 May 2026 03:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 858646B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 03:35:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3EA7214082E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:35:05 +0000 (UTC)
X-FDA: 84779729370.27.BD5D83A
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf21.hostedemail.com (Postfix) with ESMTP id F200E1C0004
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:35:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779089703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5V4WZ4zsBoGinUkFvoNAlBX1QL+qh/6OzpGceUET/X4=;
	b=NoYZHUsUEZsSuvbaOQI1RLVnLshWck7DSXA7Tp5Uckg0H7KQwbDV5S6jDnSjOjUxE4nlP+
	QCnSfKdO1lKhIWOvWStQ2UhEhGt7G5of9K/qM+auE/4Xrv4VIg5Z/NdpI6FNhj8cmXBYD9
	mAonzwd/UUsNYgMtOksDRB9UXA2F150=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779089703; a=rsa-sha256;
	cv=none;
	b=YCIWReA7AuNPeVfhFjBYwYOZ+0e3hLmRDQFVOMorJWjcVf6HzaPBNSmKrPPwPJjlOrWTg1
	9MosVf4RKyFMjyrutRwnLazVsSYuswQHKjrFBYLQXX5KMb5mm9WWIvsgTgdZuK2jrabZuc
	+u67F36bEPUbL40MauwfTxbNBryXsdU=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 18 May 2026 16:34:59 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com
Subject: [RFC PATCH 2/2] mm: swap: do not allocate zero_bitmap if zero check is skipped
Date: Mon, 18 May 2026 16:34:55 +0900
Message-Id: <20260518073455.2495934-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260518073455.2495934-1-youngjun.park@lge.com>
References: <20260518073455.2495934-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F200E1C0004
X-Rspamd-Server: rspam06
X-Stat-Signature: ky66ypdnhp1ejs5kyi5muo197fuorrcb
X-HE-Tag: 1779089702-392239
X-HE-Meta: U2FsdGVkX1+zOQXxf8goB3pFPXgfKYEd+zoM68TEcli12LQJCene/hWYdn8hUe/bl/lYmjUyrn71kQZveUgW/N497Un2XNEv5+ONIefqivx7+VvZq/19KqyjV15B2gaC+3SMzFkktORDAboFcztGN+YhguoWtgp8IJNxkidNuU5Iw7HyeoSbhXGFiPwu2kYB0wkclNuf8i+6k6n3IQI8jA9dUDY98iU+trX0foWSNcm/ODSyHwxsxrGu4rVqifn15XywCHP21Bpkp4bGkP8/Oe76UJ6OUJVr0Zd81fKFDSiH0z96UNcibGx2R3iimlXiCpstaD5QVJFqUMgennk9bFOd0+lvup6amA6Tl8htYnNQrhikJjxZJw0QpNbVu+4OMl3j/F8urbV58YE3Oq9aHfmQqZyglcgLNyVLniPZw9Cf4UJ3kMVWfMryVCaZPAJLzi/UoohA+b+eGSV5My7ABarjF96BSjrxpeYcmK9fjVn2S2VWJ+Y3elebvYcagtNFDqqM3oQ3Rmii+k9w4616ocVulPIfwRPj/DW6/TSw51yN7VWMcybf1wUEAKMVOge0TqD2I9q1FqtBf+EqaX7YjsX8F6gGH5mKDTvF7M17kx5y22yPzpIkV/TeVVj8eS1AGKWqBPAlouehszYh5WPWBnOiOBpOwYxMp9up/TIwqMfUviq+l7uLXbV+hiIip/rAVnIiaHiWV1k9+Ex420CWZ8Zpy/8LcCkvMtm9OeQk3z54my1brzcjLtXbW5LrpQDjOrWm26enq4bQWo6ntQbaM0CAmHzi6wfZveQZFIT0UXM4YB8huy7MFv/LQruwB5ZcI7CJ2sJd0nsM4ZpQIwXeTNafLV5F//xFx4QsoryZ4bgat+CTaabmCzk9Hg6JaZ4Y1pbp5JyAqQybhNqgfQTaA4xM0/duo2mqICpykJRl6zp2z43ljiLi9LA82SyrhJGwpX5nB6IFEQoFWrFtfPv
 CWFWr4pX
 4Zaalo9vGyzLDR4C27TOZ4E2CFKy/vNRJWd22en7fD4PVCfPv929hml5d/Rvg2lU7h1QmM0b2NpZ2YB9OvsM0wJRLiwHzrvf9IeSG2YSePV5y/zDaiQTdhMFa+YTeiq2VC3VryduuyCWhWHW5wdg+nv9j2K04zEVL0g+Rr+iu2oqpKy72CB6/9f4eFSECWS1IAbZhvONaBd8Lqcg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On architectures where !SWAP_TABLE_HAS_ZEROFLAG is true, the swap layer
allocates a separate bitmap to track zero-filled pages within a swap cluster.

If a swap device is activated with the SWAP_FLAG_SKIP_ZERO_CHECK flag,
the swap layer no longer checks or tracks zero-filled pages for that
specific device. Therefore, allocating the zero_bitmap is unnecessary.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 35cc33698b78..232cc5f9e06e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -446,7 +446,8 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 		 swap_cluster_free_table_folio_rcu_cb);
 }
 
-static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
+static int swap_cluster_alloc_table(struct swap_info_struct *si,
+	struct swap_cluster_info *ci, gfp_t gfp)
 {
 	struct swap_table *table = NULL;
 	struct folio *folio;
@@ -479,6 +480,8 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 #endif
 
 #if !SWAP_TABLE_HAS_ZEROFLAG
+	if (si->flags & SWP_SKIP_ZERO_CHECK)
+		return 0;
 	VM_WARN_ON_ONCE(ci->zero_bitmap);
 	ci->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
 	if (!ci->zero_bitmap)
@@ -539,7 +542,7 @@ swap_cluster_populate(struct swap_info_struct *si,
 		lockdep_assert_held(&si->global_cluster_lock);
 	lockdep_assert_held(&ci->lock);
 
-	if (!swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+	if (!swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
 					  __GFP_NOWARN))
 		return ci;
 
@@ -553,7 +556,7 @@ swap_cluster_populate(struct swap_info_struct *si,
 		spin_unlock(&si->global_cluster_lock);
 	local_unlock(&percpu_swap_cluster.lock);
 
-	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+	ret = swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
 					   GFP_KERNEL);
 
 	/*
@@ -813,7 +816,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 
 	ci = cluster_info + idx;
 	/* Need to allocate swap table first for initial bad slot marking. */
-	if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL))
+	if (!ci->count && swap_cluster_alloc_table(si, ci, GFP_KERNEL))
 		return -ENOMEM;
 	spin_lock(&ci->lock);
 	/* Check for duplicated bad swap slots. */
-- 
2.34.1


