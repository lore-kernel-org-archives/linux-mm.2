Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF3D9CA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 23:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89D376B0096; Thu,  1 Oct 2026 19:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84D876B0098; Thu,  1 Oct 2026 19:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73C776B0099; Thu,  1 Oct 2026 19:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 493466B0096
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 19:02:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BFDA71205BB
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:02:33 +0000 (UTC)
X-FDA: 85275583386.25.7F78753
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1BD3214000D
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:02:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cUOYibZi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3hua-agUKCKsacLLYRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--praan.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3hua-agUKCKsacLLYRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--praan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790895752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H9Nsbq9QtXqLgLY/VgsHpejd7/8LcoyLy2HQz4L3CBk=;
	b=Lw4PvWHR0j7vKEKPL/YeALcHYiHrtilFGf1hftz7f4NyNb+PsX7hnp4ozT8h2Z3fP87xuh
	+E1rB2s9I7i4tDEG9A7nBttBV9MslqnLrmHN28ZJsPF7pGYF4xFC+ui1MUL76ocUifbpQP
	WpjUKr3S6hswzug6/UFbkpGdUmVLoN4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cUOYibZi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3hua-agUKCKsacLLYRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--praan.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3hua-agUKCKsacLLYRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--praan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790895752;
	b=Q5fR0lsB7vgGn0ukr8tOmy1mgQ/tfLcTLDWnQwnXyb0je40j/jHPvIhvc14nDtTkUGuUgG
	5jnmTVDWrNvjoauOqIUyf+w7VhGZh3hc6PUcUIOgdS6uAFt93TFdH+kUTAlrfP0eFfPsST
	R8/1GQwLSK6os8UVdY0Ww9WG3Zhju0Q=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc4ac5feaa4so4369284a12.1
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 16:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790895751; x=1791500551; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H9Nsbq9QtXqLgLY/VgsHpejd7/8LcoyLy2HQz4L3CBk=;
        b=cUOYibZinZePjbwi7QizZmrTWU0oq+Iu5RBLujXz3GshY7WyO9aCtTTEz9lyo8E2oL
         4s2iKPbFsx2nv3yHHnWxd34R9W61bmmr0vRjgsjk1uOiiEVZc1RP/HpOScm5ED1kaKF6
         r+Hid2pSMCkbvDdd9zA1pd58v6PgfmaU7RrkFYjla6hMFJqdit5KThAQrOT7CbtY7k+o
         dSbZZeG26uv7HkeRXIRIKjBXj1KyjNuzr/tK81V9DuKF03scI2x0AzV6u6dP6QRE2Ipb
         8i7ZKSvLS0dZ2NFv2PlYVTAXHJlCew+vObJcKHg/P3Ct6ez2mei7/MbfwTiiTbj+ocaA
         68kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790895751; x=1791500551;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H9Nsbq9QtXqLgLY/VgsHpejd7/8LcoyLy2HQz4L3CBk=;
        b=ESneN+plfVdT22bK0Hco3bF6bAcOuYT3oEJ5eSUaqaimOwkMwHpsjDdIIp7Y969gT3
         jTzchfJSqqvXFMYtPxR8oDMfg/WEXvjLSaR7G66re9f/iXWZ8e5kt9UVwelK8/GH9vtL
         y3By4yDEop4Wo7v4NAEfxQq551pwzDU7/BKMRT7cIjVQtjlu45cCVTKkxjfo6SRdDJKM
         wsfVtJPPrSkWqZ40dAeWPvY2cOfdhkpnQ30cnUeWbhl7VPGNdC/DOM9E8HhaLceKnzO6
         Y4NZBSMi/oAG4HqchXmUhDQqRQFSYrHTsH8L5MqPvVtETHGBrvX7nlY1uQs2pyu1/4Kz
         qAUg==
X-Forwarded-Encrypted: i=1; AKwUvByliDzY0ShwEeSPTut1V5UunQ9nultgBy/phceckcja6tTSPcfL0j49/bvcZwEZvtpoRZdGJcn6hQ==@kvack.org
X-Gm-Message-State: AFuF++mitsSQNVtdODKxA9nk25CaExr1kq1hW4Q13rZIOzJqtFdwE456
	aPdB7uT7fxUvA6+FIFcdveNtiPf+wSuaVngEZDy6YxEyBz4crFN1nAnb8Hkfslk04Jd+JLmTJrI
	r6Q==
X-Received: from pgbbo24.prod.google.com ([2002:a05:6a02:398:b0:cc9:f793:b98a])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a1f:b0:3e0:af38:a4ce
 with SMTP id adf61e73a8af0-3e0bd199495mr735761637.14.1790895750642; Thu, 01
 Oct 2026 16:02:30 -0700 (PDT)
Date: Thu,  1 Oct 2026 23:02:17 +0000
In-Reply-To: <20261001230219.818128-1-praan@google.com>
Mime-Version: 1.0
References: <20261001230219.818128-1-praan@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001230219.818128-4-praan@google.com>
Subject: [RFC PATCH 3/5] iommupt: Add lockless sever_branch helper
From: Pranjal Shrivastava <praan@google.com>
To: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>
Cc: Mostafa Saleh <smostafa@google.com>, Daniel Mentz <danielmentz@google.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Logan Odell <loganodell@google.com>, iommu@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 1zhpc3mc7rmu3beyuawu3wzwb34j9zmb
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1BD3214000D
X-HE-Tag: 1790895751-459199
X-HE-Meta: U2FsdGVkX1+nO7Y55onT5XdWmwc+Ws3c85foCXRVtrbAUvJI8uQU73nljxvidGmc1v7obANgsrv8rFZ3v2DZvR/OlUe2Nfji/CbBBK8s9d//VjHopJexBIZr0yz2PpjdmFgRRE2nxiZqvfU9HrSxdvmGWpALcGGiahlL6ypatLYOu6XSaIhl1lwUj5N6Qoc8X4FjfGM9xzs5JItlnfo4qTgyl3+X+h79VdUYetX0Gorj0MQw7anSrKs8xZu5AUbHWwcsNT9MMchqw3Pm1Jh1zdYwp+xrWSXGp120MgwhqL4kI1iaLoapeWwsCeK6EidF9w7Qq8+jfwuygJyTlu0eInKDVCA16Lua8NdyKJ5ynG2Bo+B4LAMmrd4iTvdWwQiKP4A2VeH1clhSrECaozQ6rv7rOMB6+cKnQO5EWY6qThyGK3RYe4uxPEU12GyeTGo3exqpeFiTabgT7vr/ci2xISqNq91SMysSY8rZ/eq/7/JFdw4oxnyXELiUNjMoaNA+BNwugV9h5bTqF3bsFl9bUDQf2swUZ/qf5vCWhRW1dKq7A4lWpdvR73RsMJzd7Sxnw9XuPJ1PL2vkuoaRSCNhSXgTae2rhvdvh7GrmDFbpRCOVxpRguIbuNem+mbMkRXpIFs9vqtWrWlaCSqUhLPqa+UyOZrXZwCrpNwLbhIZ4KAkcfkXG6QW9mLWKnpuoygtxenJBRv2/N0Hr3w8GBZGgpk9C18JEjFbuEA655EFJw9ho4C+K51+lL5rjkbzx58U7mvSTeNYBZhi+NTKldJbxEiSk0oZayotSvMth6XkYiWeoTAvu3FB/R+Mx1Adr4JtJl6k10i6pE7a+JvWcdw7lPpbK/SzxyVaRL/JqPr+qOfyGbLI8jvZYOCW1PXqthWWZW7B3HkKcNkP8bjU08289crzbjYPAgw9jkrclvVX7geuA7KZnVCay+Z8Y9FlWORuYFaxe4wZ8Mt4V7t6G7v
 Dbm1wiXW
 mJNyrxsEC1FjAvdgnBfMGT2w2DVSr2otCiawPuaGeHi1q/yQWVXeUZPKpZmp5AXuWcxLPWvkyXp84vRG5ggMBqpsRNLhnvXM4FnIJZ7D9LZA2QPoP+rT9d9VL1+K1yj1JCtXaMvbiIjcJxKwFu7eJUtKBDqqLAQh3bq63nBnB9dUxEAVmbWWiVFqaUmO0G+aCD77pUkCb0CCIf7hKQIZYXgQONGhgAP8muRScbQldMKkaP30wx+PFSXwTx0bPtZQP2cm/HrIGj+c2P14/VjEF4EiuWAe1QMVYC25RlyRCl2OcAguw0ovXiy2VEGJ07TwP9Mk4qZejjm/FtItWbTae3ehZ1e3ADagrG1i8pxs4WdNYmW2/9+xYkosNxzFSQ9BdYtiUMPCxxAFbvQruQDIR2ynle+KR6asqpPVYBgevv2lUzyqKMKWKqoNYdQZ0WwMcWbk/H2t4Vd/HYX5P2t5ERIVtokjfyAx5VVviML88jRUt1jCO/kp05KhlV13wpTRhMPp0N+aN1AG+3vRl2f5xcFcm1M91kg2KflG+OF/opvkSVtUjcwe+Rv05eqIAt5d8mTVf5MAWBllYpqOEBvIOzjFVfWSyoiiCsdFrFKmVImCzJtaeOrdFS092/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new sever_branch pt_iommu_op. This helper performs a
top-down walk to locate the target parent slot and safely executes a
lockless cmpxchg to 0x0. Because generic_pt abstracts all hardware PTEs
as u64, this safely utilizes the existing pt_table_install64 to cleanly
sever the branch regardless of the underlying IOMMU format.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 40 +++++++++++++++++++++++++++++
 include/linux/generic_pt/iommu.h    | 14 ++++++++++
 2 files changed, 54 insertions(+)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index c3d09b746eec..868242eb2d55 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -1155,6 +1155,45 @@ static size_t NS(unmap_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
 	return unmap.unmapped;
 }
 
+struct pt_sever_args {
+	phys_addr_t expected_phys;
+	bool success;
+};
+
+static int __sever_branch(struct pt_range *range, void *arg,
+			  unsigned int level, struct pt_table_p *table)
+{
+	struct pt_state pts = pt_init(range, level, table);
+	struct pt_sever_args *sever = arg;
+
+	switch (pt_load_single_entry(&pts)) {
+	case PT_ENTRY_TABLE:
+		if (virt_to_phys(pt_table_ptr(&pts)) == sever->expected_phys) {
+			sever->success = pt_table_install64(&pts, 0x0);
+			return 1; /* Stop walking */
+		}
+		return pt_descend(&pts, arg, __sever_branch);
+	default:
+		break;
+	}
+	return 0;
+}
+
+static bool NS(sever_branch)(struct pt_iommu *iommu_table, dma_addr_t iova,
+			     phys_addr_t expected_phys)
+{
+	struct pt_range range;
+	struct pt_sever_args sever = { .expected_phys = expected_phys, .success = false };
+	int ret;
+
+	ret = make_range(common_from_iommu(iommu_table), &range, iova, 1);
+	if (ret)
+		return false;
+
+	pt_walk_range(&range, __sever_branch, &sever);
+	return sever.success;
+}
+
 static void NS(get_info)(struct pt_iommu *iommu_table,
 			 struct pt_iommu_info *info)
 {
@@ -1208,6 +1247,7 @@ static void NS(deinit)(struct pt_iommu *iommu_table)
 static const struct pt_iommu_ops NS(ops) = {
 	.map_range = NS(map_range),
 	.unmap_range = NS(unmap_range),
+	.sever_branch = NS(sever_branch),
 #if IS_ENABLED(CONFIG_IOMMUFD_DRIVER) && defined(pt_entry_is_write_dirty) && \
 	IS_ENABLED(CONFIG_IOMMUFD_TEST) && defined(pt_entry_make_write_dirty)
 	.set_dirty = NS(set_dirty),
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index dd0edd02a48a..d1ade1767a9a 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -137,6 +137,20 @@ struct pt_iommu_ops {
 			      dma_addr_t len,
 			      struct iommu_iotlb_gather *iotlb_gather);
 
+	/**
+	 * @sever_branch: Locklessly sever an empty page table branch
+	 * @iommu_table: Table to manipulate
+	 * @iova: IO virtual address associated with the branch
+	 * @expected_phys: Expected physical address of the child directory
+	 *
+	 * Context: Executed locklessly by a background Shrinker.
+	 * Uses cmpxchg to write 0x0 to the parent slot.
+	 *
+	 * Returns: true if successfully severed, false if aborted.
+	 */
+	bool (*sever_branch)(struct pt_iommu *iommu_table, dma_addr_t iova,
+			     phys_addr_t expected_phys);
+
 	/**
 	 * @set_dirty: Make the iova write dirty
 	 * @iommu_table: Table to manipulate
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


