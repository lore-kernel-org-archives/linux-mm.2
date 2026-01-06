Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47453CE9D79
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 16:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C23F96B0096; Tue,  6 Jan 2026 11:22:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE42D6B0098; Tue,  6 Jan 2026 11:22:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AECE76B0099; Tue,  6 Jan 2026 11:22:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 994D76B0096
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:22:15 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 47A1C1A041A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:22:15 +0000 (UTC)
X-FDA: 84302056230.03.2F1246F
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id 48CEA160008
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:22:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RAjGRM17;
	spf=pass (imf08.hostedemail.com: domain of 3szZdaQgKCOYaUWabINIOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--smostafa.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3szZdaQgKCOYaUWabINIOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767716533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pkB0OPkib0nA6oaGKP1dgUq2paM+wkefemX2KuvLm1c=;
	b=S1EufQ0ngrutywCw1IkB7qfXHbnmuLwveJBLzrL7AxQ0ijRS/u6LzVtpVUuMjG16rHjk+9
	FFCpvG7oL6qENUI/tON+vnoVWuvhfCxv8ZbBznYySVKtCKlC/7Aba6Ib5YjeNolzIBHHpZ
	ak5DsC6LApGtkBzPPzM1WVNX8nfTUoQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RAjGRM17;
	spf=pass (imf08.hostedemail.com: domain of 3szZdaQgKCOYaUWabINIOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--smostafa.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3szZdaQgKCOYaUWabINIOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767716533; a=rsa-sha256;
	cv=none;
	b=rZi0f6FiuMZ560mtMaGq7CfP04QnCmm1tBvehZz3lRgzBZ0WCWfIs/n00F2kBASugNzkBF
	VFkcEy8Uk74iMKOhifI9GI0djn6TBSJjfGMhBGPF+2MqIKlpGGluoG6RZWtw7MuzVQFcQH
	XyC/OoPhB1c4Y7hGsBvFNXWuNYJF9Jo=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4325b182e3cso566778f8f.2
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 08:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767716532; x=1768321332; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pkB0OPkib0nA6oaGKP1dgUq2paM+wkefemX2KuvLm1c=;
        b=RAjGRM17tIZP2u1quseLLxTUG/JClO0/HZOEM53b5ANt5SHx6gf7y2uX4agiUizVMq
         NENfLsPlBKjAcxS21Jfh+dfSzuLQeE2TbWSQUhhdZ9apPayzlgzZEdHuQMpaMyi61KKr
         15SgSaJHCN89LsgsKcCVDjAHtxBlsm/sWX5qUbk9v6ylUmNWI0e2oFcr9aAnijK7Um/R
         E2XMnb7td/TbsCMB/EsmqtISxt4uvO+nZ5w4npxNVv4kEFZQgTQIq2q2yZ7Jpmmh+gjw
         ZVlk1Qbb4YEaFtGnr21Z7L75UKQk+0NLOmSqQhUbfj3TFOt8o7dakit9BMmmf1tLSPHN
         P81g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767716532; x=1768321332;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pkB0OPkib0nA6oaGKP1dgUq2paM+wkefemX2KuvLm1c=;
        b=p3zRFN+5e3VLhoiHCpSFs7ICen3eT2soBuo3LVcvZpGKmuZoJzPriS/zSUv3Y+KlOl
         AbmIq0kmpwJ5KUSMx1m0wkrbAkwSPRtxqS6nc4B3tvAPk517iNug2MiLTgramunTQWIT
         /hVv0IcdtyPwMBNAjV5sgy9+cH+gE6ej7X/BWiGY0Yc3ygTSrZSDL42VdWUhUAXWwxBP
         rMn4KSTd5XoueQ96L9489IemRg6e+6CzQ77WECWpWAi51XtoT+cAQcARpiICGuUihUQR
         GSRb/uamEwOGLlO30e78YqUm0x60Y7VxhLZjuF7q6Y1a9O4k3R/9XJdlfAmzFb8Viuyu
         kyGQ==
X-Gm-Message-State: AOJu0YxjwEGsgO0O/HuCiN+AUC94e1IDouFJTi8aJl1ngdmBxWJo9dMf
	mpk6rYkBnNCujGIxt+TXioMg0Q6v5dK2LO7Dd05RdooYaavVhUtrRrUlHVxOGgkfy89Qzs5pPmN
	CH45QzdpUYPe4vwzfhaFGSbtURPCkD/3DSz/mBFfYfxppR82jIvq9m6sTOeb2QTpANPiPLd7SAm
	Cu75sECePPaOuGvWx17XZI211MM+/rmIAJHnbHbkt+BA==
X-Google-Smtp-Source: AGHT+IFQc8/Ih6tMLdszCIxSM7So3dMycZRLhJrz2no7PbcgYmWCWwIwp4Op4ZOQgvLHVVNUlH9GZoqjW7mvIg==
X-Received: from wrbgv17.prod.google.com ([2002:a05:6000:4611:b0:430:f5d7:f015])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:26c3:b0:42f:b707:56e6 with SMTP id ffacd0b85a97d-432bca45aabmr3978012f8f.34.1767716531688;
 Tue, 06 Jan 2026 08:22:11 -0800 (PST)
Date: Tue,  6 Jan 2026 16:21:59 +0000
In-Reply-To: <20260106162200.2223655-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260106162200.2223655-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106162200.2223655-4-smostafa@google.com>
Subject: [PATCH v5 3/4] iommu: debug-pagealloc: Track IOMMU pages
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
X-Stat-Signature: 9tarb5mwyd8rorru89eo7s4rico7cfi8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 48CEA160008
X-HE-Tag: 1767716533-218970
X-HE-Meta: U2FsdGVkX1+rMdC15fkbC+2YRmLvqa2vuZPLIgHa6NKbRnKEJVBwGewvQ70ZIzTvx1zDSUGkBkTSyWVrIM5QfSZ9HMF06E3F0F08nwaDM++p1GvE8aep/Hgp1OYHgsb7K7ICBcRiz5Yi1/iTZWVMy2lW37I99RQBHnzB6VkfkaDnfPKPBt0sZBTERPwSbOF0RssQQTOj7Ii1NDgXUx/TXNkY1LBMKV7u3OloRyVbQj2WrFeNsWdyQqesJ3sobBPbJz7w2z9irCY91aw6T5DYPwT9J9omIr9TW6x9G5m0161SsYgGfaWqI1deFmsOtIzGcxXJmW0ziM2IB2S614cqpGSkknLOEXABlwfD3G8eY4b3+SRhCOC+53IzEYz3nAyBMWi7zkSTdl6PbqJB7Fsr9S1qDdb5SYy8McMkxVaQZcoWVxGd+mnHOuu1LxpnqZ2ldqGCY/3me96JH6A9TB28ehkPARSfsv0zTkv3QUqa/YcyzkzE1TXoDtpsR+Xq69HvncoqX+m8VT+u8YB2/Rat8i01IIZ2WFIntTgQ9xoGMXZ2tgzI3Ybdgyxf/Yao4J5LnkVu/tp8+kXS8ETktSFlfTplpqFUlUqxgO870VzALpO5OYbQP0iKGQohQoFZwuD/yAfCEW/2HefQLvCTofHgcudOOU0gRmDKzhaGfquAHTxriSm+dw3LMy8Jm0oXSfnPDl1aAFp2P6LS6qI+FEZGARXaNTNMvvcbjMGOsjCTWW23xIRziGg1senoPDcgCcxHX3Y5bBt39B2S4hZikFqosP+r5Dl6uqJDPG7E/0nd/KgjYAcpmk93/JJVUzUutUz7DEiEREJDBTuxM8u5cA/sQz3AeJCvJwFkKPJNkNL+Abp4acZjcmUNTN3imqRox1/B639aqa8kCRQqjPbleWQor7o26aVRQSVrqLYtTWfYPlgnHvNvlyIz/hJhoHYPOgXouBtlEgT1V5swANUdrFR
 7fsdUnQd
 B3J6ZlHCQTaG17714VMVMJSbVQnG/sZQIesgjLrIMxt6k2EYZJJc8zw5bWjA/f5EGZ1XaSt2iK0L8w/AQTCp3Wyi04ITMnE4e0XHLKgCdRWlHF4doI52SgqLjsq5vmLVaDQ90FCkotp4N3UQRkkYx/YxF5B8Dn83Hlx3xhrj4zg1CJPA/KrDTQRjds/2h+DxLVTT2T9WG3Pni9ZkNyjSPwA2vXxhEmCsdH9fH39B20l8cW4VJxwlfPeWSjZXP+dSNel0A5pUcOzp0fLMZo9wkNXAfcAMIFFj79/iqWC49Nq21J2/UB8qjIzKkRwEr7M4XlyU0Gf4D5Vv32gmXEIIxrBpyWBP5yWbQxlzpSABdMGTmokhkDMjhqJlQ9Ery16/QSxthJHmo7RlN4n4RfYrTlp1MtYakgVJpSXWErzufe8askqukn/+S4eLtHWwpx1DoHswOms9ZfsKVW1XftcP92YzoTuunyErERjpz1IRwmMhPmngkqSucNwmPJZqXf3Vkqnxhw03/ZC3kiP4ZLf73fFby3PG2TfJ6R9s+YBivTEwhPqEJTU5n8zyPJ7y7CljoizX4fYEuKEeoK8E=
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

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/iommu-debug-pagealloc.c | 91 +++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
index 1d343421da98..86ccb310a4a8 100644
--- a/drivers/iommu/iommu-debug-pagealloc.c
+++ b/drivers/iommu/iommu-debug-pagealloc.c
@@ -29,19 +29,110 @@ struct page_ext_operations page_iommu_debug_ops = {
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
2.52.0.351.gbe84eed79e-goog


