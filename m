Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A768CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 17:32:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FB2C8E0017; Fri,  3 Oct 2025 13:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AAE48E0016; Fri,  3 Oct 2025 13:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69B488E0017; Fri,  3 Oct 2025 13:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 538F68E0016
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:32:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 013705B8CA
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:32:51 +0000 (UTC)
X-FDA: 83957498184.15.97F85A1
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0C7A110000C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:32:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IC8+QlgP;
	spf=pass (imf14.hostedemail.com: domain of 3wAjgaAgKCJ8RLNRS9E9FNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--smostafa.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3wAjgaAgKCJ8RLNRS9E9FNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759512770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AgDVF0Sn62dc4Fy33aQ885t/YxSjHp9XC3s20FTM60M=;
	b=KSBIRU2NnO+TxT9GsGMd1ovOePCdShmMDPTSGObh+AXOtMpq+Vvpnm4odudrPp8MIEeDOI
	0BjTQjLrGYVj0VLcVZAHDpeS0xbz4o3cTHTMDow2Gx+7qiQ/q+B1guKhlt+ICUcAzlbWOx
	+iNQTt01K4ZsQvn0b+VLkrRpe/D2q+I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759512770; a=rsa-sha256;
	cv=none;
	b=VEVqsUDqyKmuqxYlTNHiuiA49dOVcDEaewxwtu2q1bPAI6MFfr7sLQihclBabSAoHreEuY
	ewGAswXmDwO2+Qq2H9c8DWctZvs9aHsIKBreKfXgtH4iTuMSSN/TS8zO3TiqpzlEPTb2uc
	ZquTpbh7ff6GYpjl4EwPN0nYhtxt2Ww=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IC8+QlgP;
	spf=pass (imf14.hostedemail.com: domain of 3wAjgaAgKCJ8RLNRS9E9FNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--smostafa.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3wAjgaAgKCJ8RLNRS9E9FNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e3a049abaso15700225e9.0
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 10:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759512768; x=1760117568; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AgDVF0Sn62dc4Fy33aQ885t/YxSjHp9XC3s20FTM60M=;
        b=IC8+QlgPGuBzROukVn5C2tSsuRR83/RTqV097vKPxEcj1z9yMiBcB+goc083zNRyHe
         nRp6moClmltmpI/IF7hMLKm6jrQD8i1QUP1XkpEabqtswlsCh2i77SpclMSn/ajF6kwu
         1w/Ui9TFvpRCEinWdGxM9YyBa9jBVyyJRXvmwsilyOEHIGQot4yIJb36Ri0nVrDQPBVn
         co0GUu6vlP/gmzkS5MbsN1hwaLKzYQZKJhFaTFJkurZGOQOt/roojx4YDDIaweXFEATa
         K2U3yuxZ90n38akCpWp0RvP4vFEXebS0FQHmgUg2wUiP3AwDwGXZWCNgaj7ptR9zxYmq
         iCtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759512769; x=1760117569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AgDVF0Sn62dc4Fy33aQ885t/YxSjHp9XC3s20FTM60M=;
        b=PnEr2mvvQdZZgV5i2dFVGVJGLM3D3IYsLnBJKMn6bJukAECkubXMy2Z9cJJlIVOBI6
         87e0TzcnSf/IG0kkfRpJoZeyFsykC+5zV8yWNFplaioPMfU9oFSttoDEdnsfB91BVdgh
         8yh2VkbJCgkqKeSa4AzbWpGapus329dd5wVT1fzXZaNFxPHPW0gWZ25/Ql0p1JLGcP+Y
         ZGnStgkNOOvto3QTzkCe3nbmt1vg5iGT/WgUN1LiJlJgv0oPi7Rfd1JMGJAK5tLEi1JS
         D5nPiXRkW/39oxffFp5VBGI5cRsyOHdLvd/CHp4B5GiMkrMt/DjGAhXbuNG9RtuFGPb+
         k+LA==
X-Gm-Message-State: AOJu0YztQr/yUBTIf5XdB1PkNGbOhPa/JtBrQIraXmmUJiktkTitTV1h
	iZmvUTlhxBoSA3/yAfKQG2WCvJgFRpqaYdL+XgL0dkySFf+nbKOpipejyXnFijrZSlzKqPSl+C0
	9rnvzQdJCWcYutoLV1q1XFc808Oczt6Xb8/8OJbZoN0Dzur8QUNTeP4mmSxuAXthgrj+KMxTxOE
	chpQaCI/TKK5zR69jB4K1VQ3aebnlvJC2o2KVJ7ami3A==
X-Google-Smtp-Source: AGHT+IE28Cn+D6RTRtX91pYwDnd5zfpJjbOEGfORhMIoLTvvcoagejiT2Mcgwr5tybnnq3WA/m4ZzUqRkVc5Cw==
X-Received: from wmcn6.prod.google.com ([2002:a05:600c:c0c6:b0:45d:d522:48a9])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8115:b0:46e:3b81:c3f9 with SMTP id 5b1f17b1804b1-46e71143012mr33226465e9.17.1759512768358;
 Fri, 03 Oct 2025 10:32:48 -0700 (PDT)
Date: Fri,  3 Oct 2025 17:32:28 +0000
In-Reply-To: <20251003173229.1533640-1-smostafa@google.com>
Mime-Version: 1.0
References: <20251003173229.1533640-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003173229.1533640-4-smostafa@google.com>
Subject: [RFC PATCH 3/4] drivers/iommu-debug: Track IOMMU pages
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0C7A110000C
X-Stat-Signature: gx7cutysyh7j647ks1bjpp5yfrik89xz
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759512769-65309
X-HE-Meta: U2FsdGVkX1/bUyBdxcXt64geXt8Qx8ghIaV676zCpA4QeG0yRlfYHc53A1bgnd6qBr9ESRBIr298LepcNdoAGDy1dfEBAMwt+KVvnpuR+mV8U/1WGhRUxGrHeCVzJA6TEtfHlecbu1sGfeaHM5AS1Qo6BvQ7aVF6lk3hnlpoUzWfShNmjJ/1MTRGKaehG4bRVeyyRtlc07iANQCZfexBLlSg5VhY2eHPaFsRuwCeGgeo/qwvyW13hctN0PH0myAbQ9MgbY4/fmpjIOw3P1cVN3hBRPp1oN/p+diHpDHcGoCgMUrKanMjXkXK1YqYs4/H5BmhncBkumOKdLnRm5kCWYS+0j60KUyECfWJf0PzgfcBv5AEQTc5UBCIHcPCPFt2k4ksZY/YItw2RNZN9O9BNgpCv8+3VViyod7TzMoNnwyvsac3GjgCA1XLnG0aThjdrKd5U2Vum6DTNJKN0UpPalExs/3StBSB3w/WQZNA9S9oquzqNhwM7/28tTsAV7LcsA3nqa9RD/Kjtd07+9Flkh3VYUxDsrNP9qLL3p4eQ8wbCg7JedowL9g4tn9kW/nMEZvkErSr/IZAPMA7SJdtwilBW3UymlX3CCTbfN5fk42w095kLTD2WqIfQZyi57Kt6laMdNSFbL7CGDb9jItYdzKEZaLQGiMNEloK943vyXLyxPpX3Rfg76Sc9F63uG0M5pbR2n6c+CpQll08geEseMZi5nWzuBMgka++tY2gdVt0Fw2ejEUNw4Ty7Nx24xMsLRELfx9uY67tpxSS7T8SQITiQ7gMWBuEHNAO6JvpUOLs66RXVCgyNBAhy2e1zoVwvEfTnsE5ykPMRJra+1oq+YqvAtAHLOd4GLiGHU21R482ZW9PjfZtUs/HGjUA1S71AUzX+FjGcWDgBnBCxWvIzTn7E4XbfcMdLIho9pMdYpsU9CvOb5N+7ACP9w/5iNG6YiLis9SOcJTtVragWme
 0Qi/YPwR
 QlsjeZ/evEjQFd3HKBIU0kLCIc3xnyKXJx6L7GGgbsWNG9vv7P64Y81aeML5e8a8wgfcFZOkuVCUwF+SwCFg0j5EiPEKEL3/SdrhVM4Hz/EgO/N3E73lVYGDg5aSe266QRVvuKWqmm8vOA8NJQ8uu6QKTYiqlVRGG4rN4rWCPw5YP8rfkHiyaC6G1cKPDhKduTt+qsmPf6MZQ+QuivSA4rBm5nxRTduvQtcLSoMqfGwEVTXju7220J46t2RWxXiF8Cs69kX7AnVISFHiJNXY7HQftIoj5vwwtXqQzW0An/ML8HtwGNOF7iCH6Qe29Ce731cytfMBE5K0HMdJVHqOCjg9ZqhfGgHM9y3YAAMeNkmIyKTWL2SZ1NpLx2IOBF7mUeY2lQbXEesYzBq3k+cy/IgqM9CsEQ4jHNSTHOU0/Lf2bfd60TWFhgOu60dGiecipfA4uDjv23ApM+aNRKSg47f6t/lLZpp5FMg23Varkw2xrErtsP9vSE7ZnfeAMZiE+a0bCb56PTZpk+2AGsGI5RrxgNCgWplPhzkUKE0PKOi2o6KRfONgHf+iEzX0s9EEL3prHpSAgHaRyMCMcNIQghplxJrY4JDdbE8RkKYSKLVcZuNmAL4DJS01tXfn5XeRIa1BpzOG3nOlmP9k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Using the new calls use an atomic refcount to track how many times
a page is mapped in any of the IOMMUs.

For unmap we need to use iova_to_phys() to get the physical address
of the pages.

We use the smallest supported page size as the granularity of tracking
per domain.
This is important as it possible to map pages and unmap them with
larger sizes (as in map_sg()) cases.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/iommu-debug.c | 83 +++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/drivers/iommu/iommu-debug.c b/drivers/iommu/iommu-debug.c
index 607f1fcf2235..cec8f594c7fa 100644
--- a/drivers/iommu/iommu-debug.c
+++ b/drivers/iommu/iommu-debug.c
@@ -27,16 +27,99 @@ struct page_ext_operations page_iommu_debug_ops = {
 	.need = need_iommu_debug,
 };
 
+static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
+{
+	struct page *page = phys_to_page(phys);
+	struct page_ext *page_ext = page_ext_get(page);
+
+	return page_ext;
+}
+
+static struct iommu_debug_metadate *get_iommu_data(struct page_ext *page_ext)
+{
+	return page_ext_data(page_ext, &page_iommu_debug_ops);
+}
+
+static void iommu_debug_inc_page(phys_addr_t phys)
+{
+	struct page_ext *page_ext = get_iommu_page_ext(phys);
+	struct iommu_debug_metadate *d = get_iommu_data(page_ext);
+
+	WARN_ON(atomic_inc_return(&d->ref) <= 0);
+	page_ext_put(page_ext);
+}
+
+static void iommu_debug_dec_page(phys_addr_t phys)
+{
+	struct page_ext *page_ext = get_iommu_page_ext(phys);
+	struct iommu_debug_metadate *d = get_iommu_data(page_ext);
+
+	WARN_ON(atomic_dec_return(&d->ref) < 0);
+	page_ext_put(page_ext);
+}
+
+/*
+ * IOMMU pages size might not match the CPU page size, in that case, we use
+ * the smallest IOMMU page size to refcount the pages in the vmemap.
+ * That's is important as both map and unmap has to use the same page size
+ * to update the refcount to avoid double counting the same page.
+ * And as we can't know from iommu_unmap() what was the original page size
+ * used for map, we just use the minimum supported one for both.
+ */
+static size_t iommu_debug_page_size(struct iommu_domain *domain)
+{
+	return 1UL << __ffs(domain->pgsize_bitmap);
+}
+
 void iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
 {
+	size_t off;
+	size_t page_size = iommu_debug_page_size(domain);
+
+	if (!static_branch_likely(&iommu_debug_initialized))
+		return;
+
+	for (off = 0 ; off < size ; off += page_size) {
+		if (!pfn_valid(__phys_to_pfn(phys + off)))
+			continue;
+		iommu_debug_inc_page(phys + off);
+	}
 }
 
 void iommu_debug_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
 {
+	size_t off;
+	size_t page_size = iommu_debug_page_size(domain);
+
+	if (!static_branch_likely(&iommu_debug_initialized))
+		return;
+
+	for (off = 0 ; off < size ; off += page_size) {
+		phys_addr_t phys = iommu_iova_to_phys(domain, iova + off);
+
+		if (!phys || !pfn_valid(__phys_to_pfn(phys + off)))
+			continue;
+
+		iommu_debug_dec_page(phys);
+	}
 }
 
 void iommu_debug_remap(struct iommu_domain *domain, unsigned long iova, size_t size)
 {
+	size_t off;
+	size_t page_size = iommu_debug_page_size(domain);
+
+	if (!static_branch_likely(&iommu_debug_initialized))
+		return;
+
+	for (off = 0 ; off < size ; off += page_size) {
+		phys_addr_t phys = iommu_iova_to_phys(domain, iova + off);
+
+		if (!phys || !pfn_valid(__phys_to_pfn(phys + off)))
+			continue;
+
+		iommu_debug_inc_page(phys);
+	}
 }
 
 void iommu_debug_init(void)
-- 
2.51.0.618.g983fd99d29-goog


