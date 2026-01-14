Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 387D5D38FEA
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9497E6B0093; Wed, 14 Jan 2026 11:43:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B2E86B0095; Wed, 14 Jan 2026 11:43:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78A586B0096; Wed, 14 Jan 2026 11:43:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6A0346B0093
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:43:37 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3E967BA242
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:43:37 +0000 (UTC)
X-FDA: 84331140474.27.08FA942
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id A9B304000D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:43:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Uzoy4pIb;
	spf=pass (imf27.hostedemail.com: domain of 3tsdnaQgKCDclfhlmTYTZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--smostafa.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3tsdnaQgKCDclfhlmTYTZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768409015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tdaemC/8rVdnYF36w5DJ/vmlH80Wji91vs6XJXHQNS8=;
	b=a035XnJnI/SI1F35c6J0U4OQlnpSQ13PH6P4DpPfggT27TEPipxUrEIkxkbxbxo/fwOGFD
	u9qjCYVaChGaq8pHcC6T18584u6Ojom6FhmmAX+BNkzpcwOX5mYK7/djH6eZSMOuGa+CZ2
	oFk/bS3NTGOLTBQKV66EKxpKGtQrV9U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Uzoy4pIb;
	spf=pass (imf27.hostedemail.com: domain of 3tsdnaQgKCDclfhlmTYTZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--smostafa.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3tsdnaQgKCDclfhlmTYTZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768409015; a=rsa-sha256;
	cv=none;
	b=q2SA60gvVOutEZhDjwJfHJXUv6AcKb6TWCI8ZOG6Te6PglgOOogKGcUsoXBI0nVRC/+oAf
	ok4jgjMyQQby2Rr3SbOwvSbJHA1r/xGKwO/mRCHfqW5UgpY4HZZ81B44Gt/hYp6xw4jPC7
	fPAA8kQ5Fg+yB0n98oFffY86gF1bCBc=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-430fd96b2f5so29745f8f.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768409014; x=1769013814; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tdaemC/8rVdnYF36w5DJ/vmlH80Wji91vs6XJXHQNS8=;
        b=Uzoy4pIbhs78iA2i8IlZy7jYe5bk6q04vPD7VrB0hzt5RpLibVNvxaA08RssEQsA5l
         YhyFYc9EDE6iPRD+Yo6NEtHPiaBDPxd0/FI9HZI4PqxzGRuiJaJSEBKGeG/0jB7QfZ5e
         JNDGjoloE3tCPOA/paBrVttPBkChE4U95m8eMIdAGYW1nLm/EuTk0iyr+YG0OwsQQp5F
         f1zwIAfV6bjGr+gidyx2oDNIyxputU3t8m5VeIo6C7jpFz2ro1ohgmUTxPbBxMGTLV/L
         0RkAsUxt5uMrrCnoUGVM+ElXtvRXzU92W8fDbgptPFv97fXifVcqpbS4a0x4/I4nc3jB
         eIwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768409014; x=1769013814;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tdaemC/8rVdnYF36w5DJ/vmlH80Wji91vs6XJXHQNS8=;
        b=oQGSLiyQX6G30FbpyZaCgdWFOOE8j44yzJAx+mnCmgEojYGj+p2eLke5Zo0IPh0ZtE
         K6fdQzCexJVsSIkRgx/+3vw4X2uap1L/1mHtrcptX3h/oFuoL60aWwpRCRri+VQbeX+e
         GVc4pyZQFE6wbutohViizHB+igwfA2g+G7d2T7BJOnei1f1l49J9ZVf+mBXeVbu+4vxo
         MLdXKKIST6cWPOO1j55VDh1JrN1H4GSYvd1dgUzlpL7Qj3TfP593dJ8XP/cg/3Ru6y92
         0igcMUiByMXhmUqxDkwJSZs30gCRXQsV/8wIKQRtmfwSxA8Xpw9qpurBzhxfCgcjH3VY
         OYRA==
X-Gm-Message-State: AOJu0YydWWlAeF5yOSEOExWHEYnCh3Ch9b8ADasLHjDGx6RH3Qu7AGJT
	GDRC1HgjkxxwFJFypkm5EAtL8Zvx3uvR2qoqdnepJ+zjwtpSXb5m0sywccWbhBPX0jD++txKVdd
	87FNmjXqBkkV1/8CDx8TDgehV+6Y0AEwAqmbfGIC+yidv6kQVxSurdSrRUzap6kmFwlO4pChqcK
	eTXHO2YFBw43kldfb1cL8dQnKwPILqwv3vMKCxYKRxJQ==
X-Received: from wrwe15.prod.google.com ([2002:a5d:65cf:0:b0:430:f6cb:a9d2])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4304:b0:430:fdfc:7dd3 with SMTP id ffacd0b85a97d-4342c5537ffmr3522133f8f.50.1768409014021;
 Wed, 14 Jan 2026 08:43:34 -0800 (PST)
Date: Wed, 14 Jan 2026 16:43:21 +0000
In-Reply-To: <20260114164322.787125-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260114164322.787125-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260114164322.787125-5-smostafa@google.com>
Subject: [PATCH v7 4/5] iommu: debug-pagealloc: Track IOMMU pages
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A9B304000D
X-Stat-Signature: p8ogxcq7paug5us7ci3bnixxtog691se
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768409015-800237
X-HE-Meta: U2FsdGVkX1+PutW1LoB8+/bJJKCcIJDh/n2X/CQ/rMbaJJasFR4uHF/9cXbOSCugyb7qRlERlYYO3pW2Anp8IjmnKEJEV/Qru/K2ZflsvYrcYlTwW7XAor9r9tx3A3HZeurYRswb4SsCE3kqfY7jmU0kOU0z5XKU3XOH3LkT9+kZ/Cnbt44Jd1As25hrzstUBa0LSMqAqQW7I9x6bM7Rl1VbIaxrH850SvDP25U4faB67t8l3XBmUVWY64VghHBSGgVD5Dv5uVr1Exps9qCoq1F87HMjYMz4f6h1xaHKaJot+CVcQ97ALFPLel5XtrS19jE3eaR+M3D6cRl1AMtfFUQjZtupU+NqmLCwAc/RxqP5SBZUJlnPjfNLdObU3rF9UuLjMNNAJAKnoyVDCaB4Tc4jGg8EWOX4ZKPuCtxyn32bmAX9XGO421XshgizG1dKQV8PGUrklg0eyxYumTevkzKVBIZd3Nog18iubXNaTXSE5WClgwxesVJ6tmQSjB635QUsAxoYnJ/ucEb3Oh1JhuMmpLQwN64uKLiJRcXAV6sJZ7Zi8y+oQEQWnZKUYnYRm68aIqCErKyrxbxj+is6EnFAOhPUZB9qGN++ES3uZEC764pP3GsH5twOuqQ5CjQWk7tLeO7tWYH4N4TTSjHw0IAB/qTa633OvkDSLqbYUJFzquf5Yy5CSY3rWm1gB5S/OJmUhE153L/tfy47ZKpJE6HoHF6RnPa2useMzXSiFEX79FC6AnAV0lv6vhPvNMomgRQU+8qGgKXKlfUiNIvaIvzuq/Xsc9M8j6+dNA5laODt6KKjG5rfxDfIhLmiwAdf3b/CxhB79YDCoCOPrWaciyYiz7b2bXiOagk9fPSVjZX26b0QmMlBtJRcCkCLddVwqa3miMTb7RbljH93OypQJFQVvH8rpc3cJLTmR4fy30bGLr88Wtpxu/LfQSvg57FIETVA73YcdZEOrYfVlE1
 eJzZiOQy
 q/kjFFFzwvn0n8KJhI2rstIitymEGUPmJRyVvmNYpx0lKwQyJCGHz0d+x1SMQQC0vNaCpRcvUm0U0MhrW4qUPGgcxDPJwRVZV5R1VpSBKTbJxT9nAhNMwuR/axY6oXObUMNtZy131JB/C13AsJN1cKIpzlFk0/ZgCgZXyahcVprK6gcEwsqauUCAyOQEtfai6o8kjnqFEYH8Vgf6T0QMCD0fHmi2dONeA/eXzM/w1gng4IO5Ms8nPDyUiEE0DZOlMhS55oTvbCuAc62wHm19HqPbxbA==
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
 drivers/iommu/iommu-debug-pagealloc.c | 86 +++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
index 1d343421da98..3ce3385588b2 100644
--- a/drivers/iommu/iommu-debug-pagealloc.c
+++ b/drivers/iommu/iommu-debug-pagealloc.c
@@ -29,19 +29,105 @@ struct page_ext_operations page_iommu_debug_ops = {
 	.need = need_iommu_debug,
 };
 
+static struct iommu_debug_metadata *get_iommu_data(struct page_ext *page_ext)
+{
+	return page_ext_data(page_ext, &page_iommu_debug_ops);
+}
+
+static void iommu_debug_inc_page(phys_addr_t phys)
+{
+	struct page_ext *page_ext = page_ext_get_phys(phys);
+	struct iommu_debug_metadata *d;
+
+	if (!page_ext)
+		return;
+
+	d = get_iommu_data(page_ext);
+
+	WARN_ON(atomic_inc_return_relaxed(&d->ref) <= 0);
+	page_ext_put(page_ext);
+}
+
+static void iommu_debug_dec_page(phys_addr_t phys)
+{
+	struct page_ext *page_ext = page_ext_get_phys(phys);
+	struct iommu_debug_metadata *d;
+
+	if (!page_ext)
+		return;
+
+	d = get_iommu_data(page_ext);
+
+	WARN_ON(atomic_dec_return_relaxed(&d->ref) < 0);
+	page_ext_put(page_ext);
+}
+
+/*
+ * IOMMU page size doesn't have to match the CPU page size. So, we use
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
+	if ((unmapped == size) || WARN_ON_ONCE(unmapped > size))
+		return;
+
+	/* If unmap failed, re-increment the refcount. */
+	__iommu_debug_update_iova(domain, iova + unmapped,
+				  size - unmapped, true);
 }
 
 void iommu_debug_init(void)
-- 
2.52.0.457.g6b5491de43-goog


