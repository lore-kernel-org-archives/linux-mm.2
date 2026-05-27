Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 276B5CD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 06:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71C166B009B; Wed, 27 May 2026 02:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5426B009D; Wed, 27 May 2026 02:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E2E06B009E; Wed, 27 May 2026 02:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1E26B009B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:23:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 197961C1B0D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:23:55 +0000 (UTC)
X-FDA: 84812209230.19.F1D76DF
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf17.hostedemail.com (Postfix) with ESMTP id F1B7B40008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:23:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf17.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779863033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IQsztf9EO5lY0TjW7OlYgsqttRK7GNlW6/CFjNmoK6Y=;
	b=Z2D2NMpfvyq+4LR2qbIVEAkNgQ9HTcjcXkrX9lfR9fth0xGM9jKVQu30wJXiMi/QE7DP3U
	Y6YolhYh+B3naf4iPJ35/TOrST3RtyuQoe79tbmm2HyEArlSV9v+saWuNJTKSqgjYHMrSv
	26wcd+BjB/wtAEWbw2rcU2Yv2iipvBY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779863033; a=rsa-sha256;
	cv=none;
	b=mlOZQLZvRXPfY19EdzBgvZwA/iYv+1FlPyiIEhjNQQS2MXsWzVreZ9gkYVH/CMULL2Wvpn
	yalQfY+1+B5vhYWyOLUmWD3F8z1uXgebRMLuaz1cjNv+FZrd0rhK4b/bzqF0AwS7ZWw4wv
	KTHFTotmB2CSf2jnXogBR0NpbSqaJCU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf17.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 27 May 2026 15:23:50 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com,
	baver.bae@lge.com,
	matia.kim@lge.com
Subject: [PATCH v7 4/4] mm: swap: filter swap allocation by memcg tier mask
Date: Wed, 27 May 2026 15:22:47 +0900
Message-Id: <20260527062247.3440692-5-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260527062247.3440692-1-youngjun.park@lge.com>
References: <20260527062247.3440692-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F1B7B40008
X-Stat-Signature: 1z1xdtzbabuoster5x9nhb8whty831ue
X-Rspamd-Server: rspam06
X-HE-Tag: 1779863032-230321
X-HE-Meta: U2FsdGVkX1+GOLrgsE5HQWv1FAXofeh7ivQWuXPy115GkzHyHVt0MarbhB707haoqCJQWJX20/nKQgzDZJL7T8WSfLzxnHlcp1/Q5lJIUmtjU3IDoFrzFWCP8luLgXzwaLPuP3WiaM9occbjLVvD9aQhjasMVvuRUTqMq3AkDuegTLRxgy8rhT7FWDVTFVSI0H2HxD15LBCM50Yt1jYbnF+LYFYh7dOMSzKS5iYx9GlInGIN2LwrpcCXMHICHhblX2Up9d9g+RbMBofOL5dgcLu5KegV8uR4oiIfTVSi4jaNC1U8XtgVtVEIyPS04KW4KxCtKuHDlGlOpZer4xhjrPb12xeIWuoo4mMB0JcOLTbSM9Eugo3vn3gukvvqcg8tOe4YuqATbyrscUCzOrGxm+cR7sCPcSs9z+s4EX8L32D6iyiTTGJ0F/GjCabnY7EFYuLajZQhrwUkBjkMsmnamdCF/5tkB5/s3tahoPaCpy/A2U/YNhmw9YTyi0LglxSvOSTzLtCSEw9BN2VHVYxVnSwod1mMQ8aqOpGVH2G76flb7B+jxETZIUkqmkO+TB+7hbJdayCXButvKJ2tj+HQiYEe9KXa6H7L8qo9+9yJpsuG3Fv+So8bkBsy/HEZWiPmJOXcG4cj/Pg+FFlu/cXYOdqj5FeeBhbcekOUpMdqzwygdLlGm2PDKVyEhMWBHge1Z/sqtkSxM0NTlVXI9MEP/zs3+cFis3cb3sSq0ZeKu3iH9Xa6u1ythd/sSV0OR23Xzc9wKXXul7gcProuJCFyAw/JZtv8C30OcZ6MKnLcAbyTSL/xOa2kvrB+6NrLPqtNLCQeNBbgBJpexwQBeBOdxi1oowoQ/T0OS8qpQQ5c1I1Ow3xBV60h5di7KamEs56VwQ3H1nIUlVr5PdqAvogYbh+C8k8bmm1kYyebNfEh0NtXj/XLbFWR4oZrqyxfL/qu0+KBde5bz23j9xNuguV
 GVpVRuF4
 R3IHF11mQ88DwhkyB/o1cDtgCXnFECHzf8cortGGT0xPeV4W+PmZp/sQXImVebwlmxPv1GJ1d0LLAo0rc9P1MXb0yHCroXVArl8LikObxZOhG+SJuG70/P7nCnfByy8DEBNxkZhz127nyged2S3dUEegJg/te8G0f6DfO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apply memcg tier effective mask during swap slot allocation to
enforce per-cgroup swap tier restrictions.

In the fast path, check the percpu cached swap_info's tier_mask
against the folio's effective mask. If it does not match, fall
through to the slow path. In the slow path, skip swap devices
whose tier_mask is not covered by the folio's effective mask.

This works correctly when there is only one non-rotational
device in the system and no devices share the same priority.
However, there are known limitations:

 - When non-rotational devices are distributed across multiple
   tiers, and different memcgs are configured to use those
   distinct tiers, they may constantly overwrite the shared
   percpu swap cache. This cache thrashing leads to frequent
   fast path misses.

 - Combined with the above issue, if same-priority devices exist
   among them, a percpu cache miss (overwritten by another memcg)
   forces the allocator to round-robin to the next device
   prematurely, even if the current cluster is not fully
   exhausted.

These edge cases do not affect the primary use case of
directing swap traffic per cgroup. Further optimization is
planned for future work.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9a86ebe992f4..1a2d29735b71 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1365,14 +1365,18 @@ static bool swap_alloc_fast(struct folio *folio)
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
 	unsigned int offset;
+	int mask = folio_tier_effective_mask(folio);
 
 	/*
 	 * Once allocated, swap_info_struct will never be completely freed,
 	 * so checking it's liveness by get_swap_device_info is enough.
 	 */
 	si = this_cpu_read(percpu_swap_cluster.si[order]);
+	if (!si || !swap_tiers_mask_test(si->tier_mask, mask))
+		return false;
+
 	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
-	if (!si || !offset || !get_swap_device_info(si))
+	if (!offset || !get_swap_device_info(si))
 		return false;
 
 	ci = swap_cluster_lock(si, offset);
@@ -1392,10 +1396,14 @@ static bool swap_alloc_fast(struct folio *folio)
 static void swap_alloc_slow(struct folio *folio)
 {
 	struct swap_info_struct *si, *next;
+	int mask = folio_tier_effective_mask(folio);
 
 	spin_lock(&swap_avail_lock);
 start_over:
 	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
+		if (!swap_tiers_mask_test(si->tier_mask, mask))
+			continue;
+
 		/* Rotate the device and switch to a new cluster */
 		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
-- 
2.34.1


