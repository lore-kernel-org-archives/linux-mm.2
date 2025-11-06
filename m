Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 889DCCCFA19
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 16:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3606D8E0015; Thu,  6 Nov 2025 11:40:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 311AB8E0002; Thu,  6 Nov 2025 11:40:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 201258E0015; Thu,  6 Nov 2025 11:40:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 078628E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:40:15 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA3F656A64
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:40:14 +0000 (UTC)
X-FDA: 84080744748.16.BB733C7
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 347B44000E
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:40:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4fx4aLBC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3a88MaQgKCIw82489qvqw44w1u.s421y3AD-220Bqs0.47w@flex--smostafa.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3a88MaQgKCIw82489qvqw44w1u.s421y3AD-220Bqs0.47w@flex--smostafa.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762447213; a=rsa-sha256;
	cv=none;
	b=0WXH/7ouvYUQJqTxNSbvAROG2HIvVDkuifbj5n+ZdRjNO3jmtkHecNfhiKpds3udbPqEf5
	xXvRITr9iu3fnW1ZUxxyH3TSaZViUxih0CBsf78GhhSdELaAmjyT3oi3TREWFqJJFoN2yP
	OwczaKbnQ55DSpLJA4hpW4GVHuxJwNo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4fx4aLBC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3a88MaQgKCIw82489qvqw44w1u.s421y3AD-220Bqs0.47w@flex--smostafa.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3a88MaQgKCIw82489qvqw44w1u.s421y3AD-220Bqs0.47w@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762447213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MuGWRmebEyeJKEBuBok+7/p5tCLW5lhor0NHCb2aik=;
	b=kyuN9k1SVa+j+K/GZHnU+fY99L38o93zHGRnY97DPBweYW6pK/tJfJdrYKduuTSVSBTmmg
	5qeXZ+wGjL3P+8+G1OTRbFOLUJ73zReR+Gnmay81qv8o2U91+1EX5dgKw5ElQ04PEHRg/Z
	0FnxvThL8DPJKdkMY3DcD67td578AnI=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-429c5f1e9faso934002f8f.3
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 08:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762447212; x=1763052012; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1MuGWRmebEyeJKEBuBok+7/p5tCLW5lhor0NHCb2aik=;
        b=4fx4aLBCPMOTGt/O741cUHXbBpSoGz0En8hWXIRc7EFGtvVd4UxLcHC/mO/XejZJtx
         tW+bFkJpCJu6wY1rnvXRKDI4C3N/Ifmrmg46GCVEEHYBSUn/Um+rUeAt+xCt8QsEhgHX
         qR/zv5ymEzWfNeYl8JpT/09lkDLSmHe3VTf/2sav/D3WUM3WWvwg3IDHHdm1zTzJmvaz
         6p5V4twonYF0aZpLIIEaNTmOz6K4RaW2dPCkfk3O9i8qZa4sxakuwoQYn7H1DTyaQIDE
         D5q3fbOrnGruix170Z6/phdNKcrwvIXd3T5IRlBgkvgmNvsp4Ao/xiVFnOG9UsoWB+o2
         3Ahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762447212; x=1763052012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1MuGWRmebEyeJKEBuBok+7/p5tCLW5lhor0NHCb2aik=;
        b=at47EG65M6ZV7QLVTKKzHdwZhf0EFDMyHt8TS+poNaR59hPIVOQJSClFthfKfV6eTw
         gqE3KUe6vFEByhm8o9ocvXyBPvQuMinkxW2vyxKqPAIuqujE3yPGczb1N9Kl3i12aDe+
         HqNdfNHO/26VTpGHy/GyfMSonavT/9zkGLRsZCVp+WVBIgEaCE9CXib9q6/1UDMQ9Qz8
         kYt9PB+BRN/ZLCKQFXVKHpKSZ/SIlPEl1JMlRw30F00rg4hWcmT5Rpjx0DOX3garoBIi
         l9ghXs5JDrFvZiIIj+zH7KOHVhd9gsYaJ1WaAbTmISOEm0ZhOoXa/yeGixAwxrAwjmBe
         1nnQ==
X-Gm-Message-State: AOJu0YxdBGp5zu2wuYFuiRspwM7UJLD6tkbk9DbspESYEVnznPQJALm9
	0eZJEeVcBE/uAZbuEUW8xtsnGET2Wlh8OKEyuUk1aB1xzHvB17FVmVOt87RoTraDzyC6Yoo2UEg
	4Ql9WfJdWyFdbFPXfYhlreTM8Wy7y7FKo55Ot7GbX+hU0/4aIpCEmRW4rYygcg1V6ECx5jYku+F
	Gq8fGeBWaji2iHypV+na9L/iYnZ5XxXU4IO+2pET/B1A==
X-Google-Smtp-Source: AGHT+IHysWr4kZOr+q4Pq/IsxPJWwhd0Upf8H/2toPB1V7pns+GJ5i8QYBGBp3tQwp2KTNC96A5o74tpeTcSWw==
X-Received: from wrf23.prod.google.com ([2002:a05:6000:43d7:b0:429:eeb3:9047])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:220c:b0:429:d4e1:cb9d with SMTP id ffacd0b85a97d-429e32c879dmr5734101f8f.8.1762447211597;
 Thu, 06 Nov 2025 08:40:11 -0800 (PST)
Date: Thu,  6 Nov 2025 16:39:52 +0000
In-Reply-To: <20251106163953.1971067-1-smostafa@google.com>
Mime-Version: 1.0
References: <20251106163953.1971067-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.2.1026.g39e6a42477-goog
Message-ID: <20251106163953.1971067-4-smostafa@google.com>
Subject: [PATCH v2 3/4] drivers/iommu-debug-pagealloc: Track IOMMU pages
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	Mostafa Saleh <smostafa@google.com>, Qinxin Xia <xiaqinxin@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 347B44000E
X-Stat-Signature: 38xrgjx8an78uddczj7t9kt8q7j8ahon
X-HE-Tag: 1762447212-213323
X-HE-Meta: U2FsdGVkX1/7C9TfYWU+r58INhYFZTWm8+5MmXkfw8/PahzU+64Iw+6flZo0wisa1Ixt+NbUBcRmj2j38SK34kl0ZaHQ7AYzdwxZORsHMdF8Ms0c2/llMNub6DmAbs6wLuwn+1xinIQ2hSfum76g/2sgT7lUsaa0JRYWJARUMrwni5J3YN5V+8CwqxdywoRSUw2EjaTlm1P4GtDqCd+FFXCJozwmLjQMS5H1W5DePPUyySoVnufAFZLLOnmrDo03aeuprfTRnMyzft7IPCwBJ/0ItEYQbDPcwIiqiVdsoGf/W37INao776jz+COxPpLLKgGwU7u1ZaVOnNslTjJm632qa3s5TIT08YuWuSgbjSKlz73NyrSDpwcYSndtutM8997VFZLp0uUQ2P0598gH3d7G+u8bx9UYFfwU3Pi0jhnLzK8Pi21zg3nFwHbmmkH4DnQHWUgkOXqoGhVMh+UJbuAtZeCJ1jVpuNrr+bCx8+hs/W2Fh4MPL4nAhNmqo5L934J6dnwtuqUFPbjfCSqY1TIITLkBroF8CmTo9r2v8ZFA443pqZhQMtpGiXagmZKERLVUKFwBa94+fGJaVMM/nqzgGi1lO29a7dMypHLALzT/nJzdlM54WhzTKZn7yVCHLOrHl6i/cWVmAUtPC5ji086WDO9L45W26dFN+S5zNUuFPabYWnPuAvV1/l7O+G0tvYEGI6Xt0Cuavs4+wOsLa92MqBCOVANf2QaWMIx1fjm+zhuv6R+fwJpj//RPVTEaNZA36LRilQ/cTtNv5y0DqbyOTJdfPiHDmR2b3VilXMqMj87ElvGbIlkCu0rvktyycOxR4u6h/jVpD0a1HKWukAD2RpH0KC+Y82mnVTbfnJZJea6s6Y0NIb9uu43WJ//FNAO4Ky8vZby5Y+38Pzdj1wm9Ia+HKdo/mY1gl7r5lMN5unhMjKrlTAHLJkRaZrnfPyV5MibRzRdwpeOrPfU
 cAXhg3km
 i356DTvT+9L7mwv7eMevMYvviKTNQvh3cqZhlr/2B4HnL5iep+GhzvyxFg8f5gW5cy/vmX2N0T1KFBbRte1Bayym5hJ+CYwHAu/wa5A3uQpSoV505UCex/H+kP4GmeczHUwKSxBmYbPNYQ+FT5wwJjowiQ8OU8zXbaNhoywcrFMYS8k9fyRAlXFki2XccsQb8WHDJr3SN+sgTtt9GLwfc7lZlwp5Vgj5uD1FezAhy5e/o+ifBeOC8Hj78MPg8sBcvZ4pHo1hTnozGBHVom+Ym31qxBnsqt7+92qeeYlyhla2PJ3DYsjGFqHJpDKhsMQmUx1cjr8IMMqQOHglro+yitdPU+BC/UEY0xTB7nFA3kT8D7jE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Using the new calls, use an atomic refcount to track how many times
a page is mapped in any of the IOMMUs.

For unmap we need to use iova_to_phys() to get the physical address
of the pages.

We use the smallest supported page size as the granularity of tracking
per domain.
This is important as it possible to map pages and unmap them with
larger sizes (as in map_sg()) cases.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Qinxin Xia <xiaqinxin@huawei.com>
---
 drivers/iommu/iommu-debug-pagealloc.c | 74 +++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
index a6a2f844b09d..0e14104b971c 100644
--- a/drivers/iommu/iommu-debug-pagealloc.c
+++ b/drivers/iommu/iommu-debug-pagealloc.c
@@ -27,16 +27,90 @@ struct page_ext_operations page_iommu_debug_ops = {
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
+ * IOMMU page size might not match the CPU page size, in that case, we use
+ * the smallest IOMMU page size to refcount the pages in the vmemmap.
+ * That is important as both map and unmap has to use the same page size
+ * to update the refcount to avoid double counting the same page.
+ * And as we can't know from iommu_unmap() what was the original page size
+ * used for map, we just use the minimum supported one for both.
+ */
+static size_t iommu_debug_page_size(struct iommu_domain *domain)
+{
+	return 1UL << __ffs(domain->pgsize_bitmap);
+}
+
 void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
 {
+	size_t off;
+	size_t page_size = iommu_debug_page_size(domain);
+
+	for (off = 0 ; off < size ; off += page_size) {
+		if (!pfn_valid(__phys_to_pfn(phys + off)))
+			continue;
+		iommu_debug_inc_page(phys + off);
+	}
 }
 
 void __iommu_debug_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
 {
+	size_t off;
+	size_t page_size = iommu_debug_page_size(domain);
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
 
 void __iommu_debug_remap(struct iommu_domain *domain, unsigned long iova, size_t size)
 {
+	size_t off;
+	size_t page_size = iommu_debug_page_size(domain);
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
2.51.2.1026.g39e6a42477-goog


