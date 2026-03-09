Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFD18EF36FB
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 08:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66226B0092; Mon,  9 Mar 2026 04:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFD066B0095; Mon,  9 Mar 2026 04:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFD556B0092; Mon,  9 Mar 2026 04:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 99B226B0092
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 04:06:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 469CDC40F5
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:06:32 +0000 (UTC)
X-FDA: 84525792624.11.5876490
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8573D140010
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:06:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j6SXWado;
	spf=pass (imf23.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773043590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9qkGX4IQsoz4+saQxr+Ks9qPbIOEkiQZre8PPkbRL0=;
	b=wGYmJc8KtLgrWvuDPj9BwMQkKkSiZ6Eu77Rl6IWMoZvU8ECyQ6eDQ9g2l+kXv/b+yTbycv
	E/UPO17z5QsEH6i7Q/7YlyIWofWCzksPdbB4T4xrMo+qDIE0DU0NOYDqjCz3/ThajesQyK
	awvxR8/P4CKQnkYtTRJ2lmKNpZzaV/E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j6SXWado;
	spf=pass (imf23.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773043590; a=rsa-sha256;
	cv=none;
	b=Eep9yE3UIukV20GcvldK2d+zQ2dMuw01ro8u2YUHtZZhfVRd2sVH1Zq+1Uu5g9Om2ynwxW
	KBQIzXBo03bQP7fX1JCTNwh0Bq6PhT9QR+9WqrYRzniQOeckA4s5AwLvf+QqCNJFFCbVwP
	xK6dYAiYcz3/UmMTLA7eR6i2YysRD+E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773043587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/9qkGX4IQsoz4+saQxr+Ks9qPbIOEkiQZre8PPkbRL0=;
	b=j6SXWado97/8h7663KF4D0acF7r5B6e90za3CBZQyfPGwi6sOZtNxEb3ZgDIQ1T7sdDyHf
	3Ps1c345JS1zAKGSuW0pOBd6Wik1EjnvFi4mN427itu/V7iCnRQfbHwAZW1nunTB+/P5Fz
	vvZbOXTVY1MSXuu33AH+4VX+gtj7zLo=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v2 1/2] mm/swap: Add VM_WARN_ON to isolate_lock_cluster()
Date: Mon,  9 Mar 2026 16:05:41 +0800
Message-ID: <25c1be6b4a54a69d4b57189fd84c7502c4412d7a.1773040982.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1773040982.git.zhuhui@kylinos.cn>
References: <cover.1773040982.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 8573D140010
X-Rspamd-Server: rspam08
X-Stat-Signature: jr93qw8ej9cme7khtcodrjxbjzhfy9dw
X-HE-Tag: 1773043589-701011
X-HE-Meta: U2FsdGVkX19llecC1TEoO/nRoLWbFqFJHj1NOehs0VYCaAGTqYMlqgDJIdSEK+jxbvgiQNVtGAgLLy3QZ+8ywqdGzU7Z2+yzBbwXk7SvSdZlHiTKs9meytvtCxgRY89QBl9gn6JSsRAVFRpRAmfK6NrW+d0kIP5JP0wymqiEKD3XxHbuS//pGYs58EH4RAmQsoQIrw8YBWvg9VR5Iszt9gT/djioB8fL2bDv1n2D5RWSvm9ZkXv0JtQVTVODSIWvSLDbGa98899Fd7Tg1wpYuyICAr+fSAZwr578hcKC+TL9ow2oTswVlL3w27EQnH4GXn/hKMjawGCx98yKKVDcsrPk0WE5o2/tdT0FSY98lRjmt40mnmKG7SD0+whrOHTHTVoupJsBAenRG2uIcnjKm6zAlDEMRWYZfvpZilTqFawx17b3O0VrKqvC50+MVjiY6yQEkcgNps/p8YcPHvEfrH4VccnYlM4g8EDd/N5kMqCWI9sPsJ4uHmhjrm7UI8SOjystCvAhVjHXMbtW27Qd+ZShYXIST/jB1XGP/U/XB962UV1jVsDUqrcPOEjgQZkFPMK41IMmVwhAU71dKSMBLwGmuYjdI0WNvbv/82Jqbi1wnV0UNKM80TJ6erRZqNVN7ZsePx9OkL8yrpSeYj33jcM3AfheJ8DDNotjfkL6T91AP3IlGSLi7pG7LvN09GUK6mqBVzeY/jKKPh/rkKIkJhgRhoWAoWbfHhXkSNsG91u20TrEBbiGoZ/PdxAun6pW+GHqBMiXv9UFZsA5yfsnljwCOsdnr78Oi9OBkodNGc1JBWbYUupbML+3sWXHezHvgr+HpYKpSt2xXRGucopGkS+WS1r9ZZEuHyQGio/baNMSobnh6uKdfpB5Tv2LC9SlXvHHIArYT9BnzkDb9lT07juEjLzpkyBA6J7o+5vM7/jWRCLwMOVvAnzpXL0bqV+JYHkXkQZC0a49XOPILQg
 uuGvE4fk
 m64Pjwmkq+c4IQiC/pNgWtelJnRj/eIj5nF2E7952u3y8RZf/C0fOm1z0d6IK0UlwGBdGFfFYLEOa0fytkmEEPxuZqz6YDUKUrBuShZAjy6eMkcle4hsfrsZY+vb9S15WLuHc4rXEN/XidA9uB+6ObxyB+slDK4Ts+Ze7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

swap_cluster_alloc_table() assumes that the caller holds the following
locks:
ci->lock
percpu_swap_cluster.lock
si->global_cluster_lock (required for non-SWP_SOLIDSTATE devices)

There are five call paths leading to swap_cluster_alloc_table():
swap_alloc_hibernation_slot->cluster_alloc_swap_entry
->alloc_swap_scan_list->isolate_lock_cluster->swap_cluster_alloc_table

swap_alloc_slow->cluster_alloc_swap_entry->alloc_swap_scan_list
->isolate_lock_cluster->swap_cluster_alloc_table

swap_alloc_hibernation_slot->cluster_alloc_swap_entry
->swap_reclaim_full_clusters->isolate_lock_cluster
->swap_cluster_alloc_table

swap_alloc_slow->cluster_alloc_swap_entry->swap_reclaim_full_clusters
->isolate_lock_cluster->swap_cluster_alloc_table

swap_reclaim_work->swap_reclaim_full_clusters->isolate_lock_cluster
->swap_cluster_alloc_table

Other paths correctly acquire the necessary locks before calling
swap_cluster_alloc_table().
But swap_reclaim_work() doesn't need do that because
swap_reclaim_full_clusters() just isolate si->full_clusters that
the tables of it must be allocated.
Then isolate_lock_cluster() that is called by
swap_reclaim_full_clusters() will never call swap_cluster_alloc_table().

This patch add a VM_WARN_ON to warning if a fill cluster will be handle
by swap_cluster_alloc_table()

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/swapfile.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 94af29d1de88..3fc2eb30c187 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -596,6 +596,9 @@ static struct swap_cluster_info *isolate_lock_cluster(
 	spin_unlock(&si->lock);
 
 	if (found && !cluster_table_is_alloced(found)) {
+		/* Table of full cluster must be allocated. */
+		VM_WARN_ON(ci->flags == CLUSTER_FLAG_FULL);
+
 		/* Only an empty free cluster's swap table can be freed. */
 		VM_WARN_ON_ONCE(list != &si->free_clusters);
 		VM_WARN_ON_ONCE(!cluster_is_empty(found));
-- 
2.43.0


