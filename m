Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F309BCA5FD9
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 23:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 857016B0099; Thu,  1 Oct 2026 19:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FFAC6B009B; Thu,  1 Oct 2026 19:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B756B009D; Thu,  1 Oct 2026 19:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F1266B0099
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 19:02:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D992A7326
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:02:38 +0000 (UTC)
X-FDA: 85275583596.15.07D6470
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf03.hostedemail.com (Postfix) with ESMTP id BBA8E2000E
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:02:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dW904x+Y;
	spf=pass (imf03.hostedemail.com: domain of 3i-a-agUKCLAfhQQdWeeWbU.SecbYdkn-ccalQSa.ehW@flex--praan.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3i-a-agUKCLAfhQQdWeeWbU.SecbYdkn-ccalQSa.ehW@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790895756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a8Tzv848Pm5Gww4Q9gyMfGArUUtsY1KzJi65qPBcWZI=;
	b=VQ4B6CXAwGHMRIJ3FbfZK2XzzCR/ctG+iG7g/jmTIpkZWqxXEfI8iUFfetlrkK9+HBMErd
	eIN4yb4g/FPleuM1DOLgDSBQdGB2R8gsYL4kCI5oKE5qBoeKm0qKtGcyMdgI8W6CIKpnAl
	E2UUTfJUx7/Z9TaX9kfNLesiDDCdJOs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790895756;
	b=XtD/9a2bb9RRa7n5Uy5pfrUKd8CCkfSMClUFKcdt3k0/NuUx0HeHcY7wq3isdIA8I2t3WT
	hcFzYLyQ32HYUYPoWM0EYAQmb/geuCkknmSe+w64qEcSxaY41TMa4DiaAEdjAXlKNyKkpX
	nUPnMyqpi7/qiS4Fld5/wR/yyl21LmE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dW904x+Y;
	spf=pass (imf03.hostedemail.com: domain of 3i-a-agUKCLAfhQQdWeeWbU.SecbYdkn-ccalQSa.ehW@flex--praan.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3i-a-agUKCLAfhQQdWeeWbU.SecbYdkn-ccalQSa.ehW@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39aee9b4cf2so11333175a91.0
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 16:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790895755; x=1791500555; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a8Tzv848Pm5Gww4Q9gyMfGArUUtsY1KzJi65qPBcWZI=;
        b=dW904x+YCdkEnfMRNf0WcKe9CaKViCdrahg82Jp0j0EbazXzokPnNMVE7gsWAJnYGh
         dm+wQVkPrJmufZfBkedxCtkY3xc8pJeLZ8xXL4+EyCRkJsTjRTeavSpeqEcta/2CinV+
         Ov6H+z250gCqZUacZW09OT9hArh1+uF3l0ep4dL2rvKqpAiiQ6g6cBC9EO6bRlTVSEwK
         cEY/N/CNNGzpr4n3yN3ISYYB/TqxDmUiuvJMWOJJbjI5wZ9aZjSPf6qV0LIpIHLk7Pmy
         m53AmAtr9lyWcbeISDSCv395YoffOQTbf446RHUZXZXOMw+9ZyhpnNILP6HXGw5UQWz1
         ILLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790895755; x=1791500555;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a8Tzv848Pm5Gww4Q9gyMfGArUUtsY1KzJi65qPBcWZI=;
        b=LpuFPpAn5pnNSzfd0nlVIjmRvjRbiDmTod8K6/45TchwtCzImSgPnT9vxc3fem9GA7
         8QLW4OU1NhhYQUjnOCQIF6FJ/c3waPRPoRZsVkDAzNX2ewidOws0oElIGjBidLUGcvMz
         57W/ADQAc17z4eKo5WFOACG6Kv3sYb388nGS+bt1Av7vtIZTH+LR5U4TjyI3/voRXIKG
         smDODSv/GOjyGqidjjuS3WRcor1gzSKDwlFgyMPwHT8YjEgG29RePfNdDX5kLfZj2y1t
         pBaydaWwbBpwjioDne1ib43tbXC75RRKxopAM/1gDIFA5pNoXG/80CTHtbtOYCEekmo+
         jUNA==
X-Forwarded-Encrypted: i=1; AKwUvBxsTkCihmEYEMvrz5WHpsiH8JgeQoiVARp95ZSkVFT/gihsoVjjVsSJeQIjP9EQ82tZnaurGTsfpg==@kvack.org
X-Gm-Message-State: AFq9FYJHHrm5C2v6HnD9qFBEp647yOo56OyTWrOBrmyd/oR/yPqCgc1t
	k6cCNTUetq/dF3+o9CJ3R+05R1M0ivVhjHxUaqHI+5AxnMBg42mZ7f+lMz8HqGncLtLkNEboiKI
	NeA==
X-Received: from pgav22.prod.google.com ([2002:a05:6a02:2dd6:b0:cc9:f7f0:57ca])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:33cc:b0:3a0:f2c8:9ad6
 with SMTP id 98e67ed59e1d1-3a6ce9a677fmr808338a91.64.1790895755297; Thu, 01
 Oct 2026 16:02:35 -0700 (PDT)
Date: Thu,  1 Oct 2026 23:02:19 +0000
In-Reply-To: <20261001230219.818128-1-praan@google.com>
Mime-Version: 1.0
References: <20261001230219.818128-1-praan@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001230219.818128-6-praan@google.com>
Subject: [RFC PATCH 5/5] iommupt: Return real page count to the shrinker core
From: Pranjal Shrivastava <praan@google.com>
To: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>
Cc: Mostafa Saleh <smostafa@google.com>, Daniel Mentz <danielmentz@google.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Logan Odell <loganodell@google.com>, iommu@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: yi8o9qh3a7nhx16hywnhjxoys67psyie
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BBA8E2000E
X-HE-Tag: 1790895756-856713
X-HE-Meta: U2FsdGVkX1/wepD7K+hinjJpB+hLLKyzdH+gwHqiwV8rtSmBwlkSlhMVbGogROAxFId1mXsvxJL4qJ/7MQg1ROijznQ2671PVMW84UjFDC5ZQGZxnKRXWra3+K/v8PU3gj/DZygekBF+HY3QhHy50WtZv8rE40tPoQCv/Z6ABBmgZ54YY134En/bbk5GkUUxY3GAb9XwYEUoqJu0UFsYsus0P/0MMpgBDCDy2L4KeXV1ZITfb9u3hJ9l0/JVji/A4xr04B1IKpmeOlesXr0jwfyb3fSblHrpVV99TnpDhJdw9QQjU4KDJ9GX/RZepEouPNIRrT6MY0LJPy4dqI63//p1rOYi1oZmRpxT6oPDlSuKy6u2jy+HRkxpHpzAls/xh2IPGXy2IYdTTUJ2CW5z2swM4XaNStriOpQPCFNWC8n0V/VwW/AVSN5YcC1S/BFhXcdXqahgGPtG71zkhYRn1o9ZNXNnpQ/yt3nj8R72IgBbiozCsEGqAJssEZfrrt8yKz28kan1LbSqhXdIGq9vMKIUwG/hFZL4ulhfOiNV1rdmADY0GLl513xiyBqb+l8qkf3HFHi64+AVucWwarwUeBzIRz2LUhE2Vzkv54+LM1gQ6aXiBItFS77qJ/GtQsGNMyodEtY1NaBNTQ8qc4iqY6Y2jb5OYdw16/XsFCrg48U1+Nv+BQ5uynkBS+XEpIkCa1K4bv39Aw9aU3dlr7eXJNc5VhQJZ5rXjJ+RAror6p/87FIfwP6Z//4FSlqmxO1g6f31d9m6vFdoTfpaNqq+w6mfk72tljikcb3/gJRyKcWCjKX98YcsMaCv9pt1SKTZcTKP8EuFm1q83lLtxhkVT+8FLfdyfJEAddb6B7kFmqnQXA7vzekr2HG/Wsl4kPZXak+05RtnhTcnejjpedNTsQmu9eRInkWedBchzqk46MPw2FmcBBFBEiCJVN/Wl9CB+tbELyTbw+7WzDHhqEa
 PKWlkQQL
 aABjm2ywKIZpiAF3ITGBAmm5eUzw2uXOtFDhvlGuqiy4Xkh5a9p6/larVyX1Y79wpHGRUHN6GaR4WnizG3QNFm/y5Q/DyBGqVg6iqDrpcIu2FE3IN2kzrgezXBrEePenks9XpF4WvrPk4mh2Lo7rzNVtJrTPLYv7OUFk6pyREjIkhZlIRcnZWImcchBq+fsaypHxDU2OyF7fitxRXKGGrgoLdAMzSzuZWhzKs6tAPRLkQrJYQeAxsx4avMn29PJ9a9m9OqvgEZ4r74MzLepATjJ0+i2qUlANIhUNqdd4/lpUxM7vvTBuaVFpSIv/lgT28eOMAs5BpVcS4gfiKW8981EL9UgxyrXXDtINiFyVL6J+ZI/o0rFZRmcuw9V6VF/VkWRFkd7B8nvkk6Fm8a1lEyi6WXGcFJ3bTF5A9PJ6jheuvOhJ+YqdUPSkVkqwv4D/gJA+BofavNHR2hVS/jw/9YMYklew8BxfoYf8iisBpWRuXglUMHXechtITwHgLOows44TnM23gKVHedgSsC8vYbVu9leiNmhx0+7DevTOwBVvtX6eJ7bGlNfcqKEe2Cye+1GKB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the count op to return real nr_pages that can be reclaimed.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 1 +
 drivers/iommu/generic_pt/shrinker.c | 9 ++++-----
 include/linux/generic_pt/iommu.h    | 5 +++++
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index e5ee419f2f0b..4386caf3f713 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -1115,6 +1115,7 @@ static __maybe_unused int __unmap_range(struct pt_range *range, void *arg,
 
 				xa_store(&iommu->domain.reclaim_list, range->va,
 					 virt_to_ioptdesc(pts.table), GFP_ATOMIC);
+				atomic_long_inc(&iommu->nr_reclaimable);
 			}
 
 			gather_add_leaf(&unmap->pending, &pts);
diff --git a/drivers/iommu/generic_pt/shrinker.c b/drivers/iommu/generic_pt/shrinker.c
index 66169fb5db71..a27e171b5e80 100644
--- a/drivers/iommu/generic_pt/shrinker.c
+++ b/drivers/iommu/generic_pt/shrinker.c
@@ -43,11 +43,7 @@ static unsigned long generic_pt_shrinker_count(struct shrinker *shrink,
 
 	mutex_lock(&generic_pt_domains_list_lock);
 	list_for_each_entry(iommu, &generic_pt_domains_list, shrinker_list) {
-		struct iommu_domain *domain = &iommu->domain;
-
-		/* TODO: Return real nr_pages here! */
-		if (!xa_empty(&domain->reclaim_list))
-			count += 1;
+		count += atomic_long_read(&iommu->nr_reclaimable);
 	}
 	mutex_unlock(&generic_pt_domains_list_lock);
 
@@ -78,15 +74,18 @@ static unsigned long generic_pt_shrinker_scan(struct shrinker *shrink,
 				if (iommu->ops->sever_branch(iommu, iova, virt_to_phys(virt))) {
 					/* Successfully severed, queue for freeing */
 					xa_erase(&domain->reclaim_list, iova);
+					atomic_long_dec(&iommu->nr_reclaimable);
 					iommu_pages_list_add(&free_list, virt);
 					freed_count++;
 				} else {
 					/* We raced with map, abort pruning */
 					xa_erase(&domain->reclaim_list, iova);
+					atomic_long_dec(&iommu->nr_reclaimable);
 				}
 			} else {
 				/* Not empty anymore, remove from list */
 				xa_erase(&domain->reclaim_list, iova);
+				atomic_long_dec(&iommu->nr_reclaimable);
 			}
 		}
 
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index 95bf9d4f0b6e..3c94745bded0 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -69,6 +69,11 @@ struct pt_iommu {
 	 * @shrinker_list: Node for the generic_pt global shrinker list
 	 */
 	struct list_head shrinker_list;
+
+	/**
+	 * @nr_reclaimable: Count of empty directories waiting in reclaim_list
+	 */
+	atomic_long_t nr_reclaimable;
 };
 
 extern struct srcu_struct generic_pt_srcu;
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


