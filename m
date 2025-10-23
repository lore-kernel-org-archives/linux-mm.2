Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31560CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 18:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91C038E0018; Thu, 23 Oct 2025 14:02:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CCA98E0007; Thu, 23 Oct 2025 14:02:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 809618E0018; Thu, 23 Oct 2025 14:02:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7373A8E0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 14:02:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38D4912988E
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:02:07 +0000 (UTC)
X-FDA: 84030147894.08.F2FA27A
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2C73EC0021
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:02:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F706njO3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761242525; a=rsa-sha256;
	cv=none;
	b=yDDs8AruEFpMLGpbNwek9dLz2MpKUHgv89QK0bzmsqT4rKdSMOxm9mdhj1nAN+elyZULAQ
	0cGpJT19DyuKg4kkqSQB9pFAdyrQDuw9W0B2V1rGLtflAhVX5AFpl1fxvlFedLvi9F53X5
	79fgvsraXelvqlP6/0v7ESr7lahXdD0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F706njO3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761242525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lk62vnASvkBxJgkC6Qb/LY2NePGcYntSkBsPsS8b6vw=;
	b=4Bl10KI09GRsmE/w5oHb9sFUzpsjY431SjokE6piIRcGRaTpygtLPLYrxdAeafudRF0Jrk
	xm9XVcX0Vfmwri5MisN5p8zCcC+E+crL13oHqSciQW4K+g4jvmM9CkDa9x4bD3bhL3Makw
	bsFk0mrbOJNKuWo4MxayVWDsU4SiaGI=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7a26b9a936aso741870b3a.0
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761242524; x=1761847324; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lk62vnASvkBxJgkC6Qb/LY2NePGcYntSkBsPsS8b6vw=;
        b=F706njO3CTj+EgwTJOvNmmEP/KekqJOa+w3g5bepZxo8LMlsjP7k1W4oW5lubeWQ77
         j4aldEbl/76B4e3j/yw9ZyGqT5GNWLIqF357p2lHv40DuUJLypaQXXJ6ErByC8fiMaFc
         ksoeCAUwvVk6hoQvYChr2ioBxtzblNxTafmcS2coonyz7FfnoUOCq0YyoDBzz66HIDgD
         WCGwkFArTP4aUY7BWdSGIZSXvjUQxcoWqqIN2PU7BeX9TgIo+tls4Q1XNL9IPGq4fNhR
         KrFje6/75NEsOE0dRDVMbHjbBs59FkFQI/C+N4cgfxg4/O0D06cvYpbMMCwMnsQabMGD
         rCCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761242524; x=1761847324;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lk62vnASvkBxJgkC6Qb/LY2NePGcYntSkBsPsS8b6vw=;
        b=g9cy8wNf8uGr6beuJz7vHDRxb5DUYczKxfLBaR/IMdW5MgcsRtR03sv0z45E+BNwpX
         sClwSnVrVLCSbKuTgYO7s0O/qaGRXHcpeV0SPPABLQ+pnLCa1F7Q2+ZTh5iEUv1EGQcw
         rfFHDMntQ7VvoG9UDhCyp9COy14wI7AoXTKF0p9qOSEv5kehJ4nDKojqHSi+huClAOtr
         DvwuptVRUm5zPokBJ8sQAZZk8mbGLOKNFCgZwz1+ztW7HVmZKKobS3ZO7bQxOsT5e4JZ
         G+Gt+FBgtg94yz6C3AFPPY7ihfo16oCfnoDQHMl3knd5wyYVZ4pKDxujtQ4r2Gz+99rD
         gwzg==
X-Gm-Message-State: AOJu0YwQNWKCwDLLTV9Iywb73qSYvDlC7qR9uL38Z1aJqCn9VY/RHRI5
	UGe4uL/+DxiTTZdrNXecdE6nuRBcNqueNATpadH8G2XDN5i83+O+yJq8
X-Gm-Gg: ASbGncuVtNuvuLfXxs6Or2zLTDGZOtHpkFsTllbXgvoNQUxGgt3IuEZ1bxjrdbXu3S7
	VlQy2QRoFRHf2Z64upcWGTfqI9RuuDRVM1sZM6Vg/GERn7t/06j30OAcbIE+144LKfHQzPkg8NV
	/fvAATP9Rf+UmfFHUlVfzwSycS90oImErvmXGHxXXcfPNgAdyD4ZmxruM9IKI7KNv75eD8earB4
	gc5K4YW2u7LfX4enKdEkTJX7jryxENPYDXzce8xx9MROeVhTfBFNvVS3daswveKPsq6shjLrhqE
	Xsp3wJEilXPCjYbVec9Hn8QIqw9KvU7Frf9fT3CAcb1rOTJXaf3/wepHYmVtoQ7orzzWIRJlwQh
	ooycBDu2MahZO5uLe/pN8ovdbnIStt4XdpdxdDjYushn5d4wuYpoibWnLHOywBKXSRUgUa/28SI
	7TgRx8Cw==
X-Google-Smtp-Source: AGHT+IFPUrlbvn8DuW25skZvpIHzGvxrGeq0n5tQxV88E3xMkZ9FaMz7plJmoiS9eWwPcZAFgSQvBw==
X-Received: by 2002:a05:6a21:4613:b0:334:adbe:752a with SMTP id adf61e73a8af0-334adbe757emr30117578637.31.1761242523824;
        Thu, 23 Oct 2025 11:02:03 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6cf4c4d83dsm2734532a12.18.2025.10.23.11.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 11:02:02 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 24 Oct 2025 02:00:43 +0800
Subject: [PATCH v2 5/5] mm, swap: remove redundant argument for isolating a
 cluster
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251024-swap-clean-after-swap-table-p1-v2-5-a709469052e7@tencent.com>
References: <20251024-swap-clean-after-swap-table-p1-v2-0-a709469052e7@tencent.com>
In-Reply-To: <20251024-swap-clean-after-swap-table-p1-v2-0-a709469052e7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 YoungJun Park <youngjun.park@lge.com>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2C73EC0021
X-Stat-Signature: 5jkp4x8ezao7g96zaj5k7tye9biozwoi
X-HE-Tag: 1761242524-383220
X-HE-Meta: U2FsdGVkX19aciVbIaYIeGryjktuhX8QAW3zPy5TDpK8sXR4xbL16QqF1UtjjDvZ7pfaZhcVyVRhW9049LRrS7FeFr7lp/uye+n6wZ5TUyJtyni5wLaU6en3YUTUDpyfHJvQt1oIYGiyC0GDuBxrRz5gF8pgf8/BRsj9NCkAqd+SHk3H6+Igqy4vguPqRWCS1Zq224JGswSC5zzgysD1S/5tZOMs2sSpi4fdckMeHYRcbmrFI2VwxuxwMZBndQCopViBij4WFOyHPj6AF899pktOUxO59riyk9CO+tIsBtCuO91WDUkgjfiSgUDWfRpZPrVaSgg6iZpFwMM0kW+YHqUJB8FT8oTPKCULOsuZA9UKt+/RZjxtHPJP9oeejLILNvxxburn9DNST3HBC5t6d7Uq7a2f6heMPELEnFy/48eE5H7dCLwd6dyZnMiFTWFBD0+bt75Z8uX7oVqjp7US6elsUy8iX5UHtZsLVDiJljaK2rjYQjek2DXGATTxDJhA/WDZ8lMM0nEgxCXilSJAFq+ogV7WMWNT7USBeK60mikoycegYbkG6H1gWwkt7EXIxG+rM9Qc0TPStwMTDS380ELmBD5S5G5H/pVOOqKfdR51638sXv8DGT52UAIt2GLQMsFJt3WxGIOd+BrwoUBuKv2TCCERBK6+cH312yphc8CaziwEa8xmHldRIuEV520/0N4YIPkDWWQIzPKyZGbbm7S97YbkVPRZ2NemZLvRMuWTqFLL1aH4sfKKatk2IOwsbkKzbCVKQYXj5nXWT02DP1n0cdzfnIoVWoHAB/TL83baML1EQJWdc44t31ZPm/xqeEfkKlRUKSRcC1nyKniUNa2p3B9mrC3WYz6T/640efqCUDH5jzIOOTHS3ziY0Ns1WFwLlhf+Dpy/ZpzrnX5QrTMWPhHTdSW0exBgAtglmlzQbqrLq9dNd8Ki3Zq0JcrZFhJFQxkefx3MiiS2UHn
 9djP8DI3
 GbQwpWWPPIND02TvRYg9/d/FEmsqxpxVMWGakkrduHnUX60BrZC/Zs2KKAjdNE4FUkmId/QBs36OnidJH+RpJlWkPkh+aPkrAlhzyF8tN9IbCpCE8rV1be2pOUTZvlTsOElwySSl+ggZdPT4JI8D6Wrl35oOXG28lNssvb0RvY45cQYEsoSuMKhE5nMH+qRhJ70M2wI5f+0XrXLOCUwD8myfzHB35orI5oDDrJFyPmY5j/YaOl+m4x9YoeyTF7ts55D85NMQo+0jFQvzUDZJxCFkszWl6ComvIK+8t9Bi/SMrMfzW5oYX8IwjvbJEEgpsXU1tn/HSZf3LZ+W0JeNuKtkjUJJL410tb6bBDa8cBy6EQgtyJgjzhtx13vGkRisuC9vz74qgX13xjoHlD8Qn2EaIYvr31grYrn011xzX4qbXdBY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The order argument was introduced by an intermediate commit and was then
never used, just remove it.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 42e2b2759240..214ccd1f69cd 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -594,7 +594,7 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
  * this returns NULL for an non-empty list.
  */
 static struct swap_cluster_info *isolate_lock_cluster(
-		struct swap_info_struct *si, struct list_head *list, int order)
+		struct swap_info_struct *si, struct list_head *list)
 {
 	struct swap_cluster_info *ci, *found = NULL;
 
@@ -957,7 +957,7 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 	unsigned int found = SWAP_ENTRY_INVALID;
 
 	do {
-		struct swap_cluster_info *ci = isolate_lock_cluster(si, list, order);
+		struct swap_cluster_info *ci = isolate_lock_cluster(si, list);
 		unsigned long offset;
 
 		if (!ci)
@@ -982,7 +982,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 	if (force)
 		to_scan = swap_usage_in_pages(si) / SWAPFILE_CLUSTER;
 
-	while ((ci = isolate_lock_cluster(si, &si->full_clusters, 0))) {
+	while ((ci = isolate_lock_cluster(si, &si->full_clusters))) {
 		offset = cluster_offset(si, ci);
 		end = min(si->max, offset + SWAPFILE_CLUSTER);
 		to_scan--;

-- 
2.51.0


