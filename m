Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E33F5CFD352
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 20:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E0B26B00AC; Mon, 24 Nov 2025 15:08:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B346B00AD; Mon, 24 Nov 2025 15:08:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359556B00AE; Mon, 24 Nov 2025 15:08:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24BCA6B00AC
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:08:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D118DBA201
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:08:23 +0000 (UTC)
X-FDA: 84146587686.28.7AE6F06
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3D8CB4000C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:08:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZGZxQ7IG;
	spf=pass (imf12.hostedemail.com: domain of 3NLskaQgKCI09359Arwrx55x2v.t532z4BE-331Crt1.58x@flex--smostafa.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3NLskaQgKCI09359Arwrx55x2v.t532z4BE-331Crt1.58x@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764014902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KqKpIBZ5ph2RKHb1Juc+0e0et8fqgEk7XdVd6dRoI5w=;
	b=BOIv8b5WvGSm3Ti8av9rzpTWgAKkCRe+fK85WS1+0dARSDHu4S5XDjtC6F/mZ/YFa2fqdP
	C6z+h7/QQMcg5On3sO+UJc9OrCuGLiGb+ZK/xgeEs/cf0mkJFg+UskgWhNbRCKYqtlzCkp
	eQoDFevmq3yfImInRXRphztE59akCqA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZGZxQ7IG;
	spf=pass (imf12.hostedemail.com: domain of 3NLskaQgKCI09359Arwrx55x2v.t532z4BE-331Crt1.58x@flex--smostafa.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3NLskaQgKCI09359Arwrx55x2v.t532z4BE-331Crt1.58x@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764014902; a=rsa-sha256;
	cv=none;
	b=K76XtN9y78hAuKPV7c6va6hz+YNjl8e45VQPnFJLBZc+oXOPkSp8uyzN+6zi0piO7cnsRn
	ALmaG7CZcOqOhD1RUtyh0kevgT9wKR8uyd8O6/wRox8JnU6rvKIweaDsq2eHuYJBA5W3GM
	Du3KY4VIeNLthU63hw0qZi4r0HwTe3Q=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b56125e77so2236348f8f.3
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764014901; x=1764619701; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KqKpIBZ5ph2RKHb1Juc+0e0et8fqgEk7XdVd6dRoI5w=;
        b=ZGZxQ7IGF5qyCVpg9uFMV+hgCd1YbQmv6Y2UNJHCBCLNAqBvWFka3ra2/4rJRsLYid
         6VoFlLsWYkjOqj1DBQIqAfLRnpSnSpf7NlE8nJnF0jJg6gv0poph87LBvUUgb/H5aEHx
         X8/uEE1Blc0T221NY/0O1+pwwyV1bRcGXNp38j4+bnHxQuhswRRmu3bDrc1HiKZwqd/n
         9PLVty6EwZgPoUpeXYyxtKs7qfiqyOD2PasMC0YXRq9Q+5SmnMN6ngCgqYc+RXGdFizK
         5AbcF70z62YI4Q4BQlPum9YF+x6vVXrGObytOU67ulE7/g+ZtLeN6jqcnQulT1yLTdGO
         C3Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764014901; x=1764619701;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KqKpIBZ5ph2RKHb1Juc+0e0et8fqgEk7XdVd6dRoI5w=;
        b=nKFz1Umz0Spm4WQ0oSp7r9KirRHoU3H7cgEs/YTcpWyl29q/ynmyt4Ck0xEBAXBR1y
         UsQXryKg5RhwbAghN0+eP8WOB0b29+DpuwRI4F1O6ZziihsnXyYg1bNRRAmvFLYgLwIe
         031EW3xw57v9p+g0w3mFVDmtO4zJBByxwA78Slz593amzTYP4MARsc2VIBV4vIxQl9Cf
         m1UiWuOjREpxsZAlHgSoYT4gsdOi1uC6WBedoFaFkbj+hBysTBzKHFSAGsgkw/YPfsPX
         PN2qPtsgyn3JN1NvMKs3AkG+Dba0hJM8DnFCC1GChgijSh6me3i9VojhoY6YMfuVeW5i
         kojw==
X-Gm-Message-State: AOJu0YzQGet4H7gsgbXYfONw5hCOUz8NBm1GYvZcpDayLo8h7dcOAMyR
	9bcF0+D8hkmYedap97eA61teoPQ0t/sGGcu1hcW15Hs0EH1RWXjD31gADUuyKCPHldFWQ0rStDM
	fjyRjFJ3XKk+J3AqwzZZTNwJZKc3h0qv3vi9IlodVgTnqb+vohoZLujRDk0EE7AqDIHieJv0Z1/
	rr9Ab41982bcONh59Tnyy8krZZqZAmoRUZQrJ6Atu+Ow==
X-Google-Smtp-Source: AGHT+IE70jlTwwNL3KJSrpPin8RW4YVzvFsosBLdlm8Ql3ZPiG179UHj7pwJfuv7BMtTrtBrnOC1zPhnDThKiQ==
X-Received: from wrui7.prod.google.com ([2002:a5d:6307:0:b0:428:563f:ce93])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:40c9:b0:42b:3806:2bb7 with SMTP id ffacd0b85a97d-42e0f1e35c2mr143709f8f.6.1764014900720;
 Mon, 24 Nov 2025 12:08:20 -0800 (PST)
Date: Mon, 24 Nov 2025 20:08:10 +0000
In-Reply-To: <20251124200811.2942432-1-smostafa@google.com>
Mime-Version: 1.0
References: <20251124200811.2942432-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
Message-ID: <20251124200811.2942432-4-smostafa@google.com>
Subject: [PATCH v3 3/4] drivers/iommu-debug-pagealloc: Track IOMMU pages
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3D8CB4000C
X-Stat-Signature: wi7xzfbhgsdynw7ebug7oyj97jfjnb8d
X-Rspam-User: 
X-HE-Tag: 1764014902-297377
X-HE-Meta: U2FsdGVkX19O3XqL9XSQh+Xb7C/Xu9GVOVdeJKuOxLDV8HjJeML8LdLvv6cXZAa/FTV3oIKkvqR8LJF66syX995wJeZe5E8VbFoPpYGd+ewhY1h3NRaDni3AmRFJ0MWu10yK2ocGle3dovb2suK7QxJYmuJOGNXSFtxdCP51OSEAu2QdLynAALWwdcZFjPw6EGmCFEBh9J/J+a/BMayvZI1JBSfrjWcbdLYIR4QGJnJ297yGYqjw+looHlBzVIT+3/8WSvhUlSdJ4bs304hAXSBM8US++tT4V5HlVmJV22z7aJ59F/iaLIOxPIpQr1Cg06cSoy6oZvnfYwxRdIcxIBtPZOfh+RYMIw6dcvqzKiUp43GNLIp2/uTWCAhzymhYlupKQHiKBd8S2bBCRDrxoTSfX9gGkWK2PIL8OicJYVnvgt7/3M9NMx0D8QtLFtXRe1/vb/Fex0x7562Pb//1V2QjPoYhGCkmK2Ax/pzoWSs5ezx4/wIt8CxGXrwivy1Ar59ltWFCYCShtmHxVOk+YXSASiM1IVfb55CwoPYSZyNwHKdmvR29a+MhQvDnxho9i6IZ3zBmVoUDa0+7CZWC2vlmCYQeDSAPoM8SoUvqC86InBk+fJZgZVBhYbB5JvKVnxiXpAuOQWClw4CxeM/Tuv2RjWvpF18CUPjoCdfw0VDGYkAc1KeymvNleJfz/9bXzLzFKdPYpgB/5s7D6rbfCFARDcHj7jr4dUZJ/FuispqLGbecoyz98Vx7ID1xY1A5Pi7ELmb2Mn/kchdqY/V8hjJSc2XoCHBgoEpXXmbOVElD6owsswH248vpW9N1RWtEU32oREzIpvDVw/yLVf5CwrB2Oy+T/gQmfBlFtA2GeodzzqmVj8K5ICC8r/McK8z8Crz0EBtI6QgsqZrG59QEcyNB7yfb9ej8uWipE7Irbj+9pRjkVpWENFFhQAFkPsErzn0m+vDtYS/SkrUBBh8
 9TtlwD3l
 YXYpo6xXglrDRW5aVqrk5n9Y3XvrJqtUcChvBf5SmhQ2mExXCFddvsrL83KPzKCL48BlTRKMaiw49g9X9tOv6zin5arsxJ1dkhmJqgnDZniU45hNzY9h3siORItY5vyjbGC9O5QoVmMm7tp0BpUUrLYKyDlYnRjYuAG7MX9TJu32b4gJuWYRBcb8PMYTXhWOBxNEJgX//lbkKOv14kTjohBq0ka+y5aNzhcQBxNeSTmv7P1s3O12qIKqAL6yYjvY9rKwa3e/l8RNmYEs=
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
This is important as it is possible to map pages and unmap them with
larger sizes (as in map_sg()) cases.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/iommu-debug-pagealloc.c | 91 +++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
index 5665fd7360e0..c420b006ef08 100644
--- a/drivers/iommu/iommu-debug-pagealloc.c
+++ b/drivers/iommu/iommu-debug-pagealloc.c
@@ -27,19 +27,110 @@ struct page_ext_operations page_iommu_debug_ops = {
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
+static struct iommu_debug_metadata *get_iommu_data(struct page_ext *page_ext)
+{
+	return page_ext_data(page_ext, &page_iommu_debug_ops);
+}
+
+static void iommu_debug_inc_page(phys_addr_t phys)
+{
+	struct page_ext *page_ext = get_iommu_page_ext(phys);
+	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
+
+	WARN_ON(atomic_inc_return_relaxed(&d->ref) <= 0);
+	page_ext_put(page_ext);
+}
+
+static void iommu_debug_dec_page(phys_addr_t phys)
+{
+	struct page_ext *page_ext = get_iommu_page_ext(phys);
+	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
+
+	WARN_ON(atomic_dec_return_relaxed(&d->ref) < 0);
+	page_ext_put(page_ext);
+}
+
+/*
+ * IOMMU page size doesn't have tomatch the CPU page size. So, we use
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
+	size_t off, end;
+	size_t page_size = iommu_debug_page_size(domain);
+
+	if (WARN_ON(!phys || check_add_overflow(phys, size, &end)))
+		return;
+
+	for (off = 0 ; off < size ; off += page_size) {
+		if (!pfn_valid(__phys_to_pfn(phys + off)))
+			continue;
+		iommu_debug_inc_page(phys + off);
+	}
+}
+
+static void __iommu_debug_update_iova(struct iommu_domain *domain,
+				      unsigned long iova, size_t size, bool inc)
+{
+	size_t off, end;
+	size_t page_size = iommu_debug_page_size(domain);
+
+	if (WARN_ON(check_add_overflow(iova, size, &end)))
+		return;
+
+	for (off = 0 ; off < size ; off += page_size) {
+		phys_addr_t phys = iommu_iova_to_phys(domain, iova + off);
+
+		if (!phys || !pfn_valid(__phys_to_pfn(phys)))
+			continue;
+
+		if (inc)
+			iommu_debug_inc_page(phys);
+		else
+			iommu_debug_dec_page(phys);
+	}
 }
 
 void __iommu_debug_unmap_begin(struct iommu_domain *domain,
 			       unsigned long iova, size_t size)
 {
+	__iommu_debug_update_iova(domain, iova, size, false);
 }
 
 void __iommu_debug_unmap_end(struct iommu_domain *domain,
 			     unsigned long iova, size_t size,
 			     size_t unmapped)
 {
+	if (unmapped == size)
+		return;
+
+	/*
+	 * If unmap failed, re-increment the refcount, but if it unmapped
+	 * larger size, decrement the extra part.
+	 */
+	if (unmapped < size)
+		__iommu_debug_update_iova(domain, iova + unmapped,
+					  size - unmapped, true);
+	else
+		__iommu_debug_update_iova(domain, iova + size,
+					  unmapped - size, false);
 }
 
 void iommu_debug_init(void)
-- 
2.52.0.460.gd25c4c69ec-goog


