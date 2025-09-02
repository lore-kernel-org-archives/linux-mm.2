Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C2ABCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:50:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9C38E001D; Tue,  2 Sep 2025 10:50:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1458E0016; Tue,  2 Sep 2025 10:50:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D10298E001D; Tue,  2 Sep 2025 10:50:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD37F8E0016
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:50:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 87543139C81
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:50:17 +0000 (UTC)
X-FDA: 83844595674.28.0525F48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8402D160016
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:50:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rJeu6B43;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756824615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4SM6zHJ9Q6ObBfi9kz8op3wvjKvHEZA6J8C6N7vBkM=;
	b=ov8vxJsjhgOwJWg5gAYERsT+3CiSnjAwyyeCOLSaKnqKHmx3B/DO+L4FPwJnMYOfZLZGzc
	BNe2VFnCEnDQqeCqhjKVETNw8QLVEBVHcf8xVI/qjlZ2/UG24AwP25Cy1KzVdD0v6y8HwH
	CSXZlEuFC5Pgcyld6Dntnm1cukyFOmI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rJeu6B43;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756824615; a=rsa-sha256;
	cv=none;
	b=xRI7XzwBMfPWtyCnZ66tJw/ZzTZrAl4JD2BUmNgednG9iCPRflEwJytSrXYAT4DTYI2qwO
	oNEI7vVwlTr9kO/Y8XStQRMFWr3ODU/gx1PajJSZvbK7UqCdYSf4njVDY7JHqoiGcPiGyL
	yXLrJ+jaui5NfdwsXtgxcHNiniOekbk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A15CE43588;
	Tue,  2 Sep 2025 14:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3108C4CEED;
	Tue,  2 Sep 2025 14:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756824614;
	bh=5GnXky7X8jRP4E4M761xyU7kxSqR5w3y9HvcAnisW/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJeu6B43+1PA3hIr12hg0lnVgq8hEaO1Lw0dSu66C4Hxh6OtUnH4qrmq2UzSSZ1N4
	 l2ZMHW11no8o4RgcofoNHTdHE1yoSWlx22rWWSHOD8+Ogvu4ojzleuOhx12qfasdh8
	 1xBycpNin9JG/1JisPEuSXMSjGw3Xeby21NvKY8cKczB0oynk2yRys0EmsHljVnB3u
	 KBLTyBq9WFsVfFALrQa4WJtvJqzt56sC8sAjNNKhzQLMvhf/aVz1+461ufH6pc4SF9
	 +Mv7reAnOosbLyMyMqxFSSvL8KoRwphakYFROv2rFhXteTJEarDn/NkqrxQfsDao9k
	 qBoW5Cs7du2bQ==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com,
	Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v5 13/16] mm/hmm: properly take MMIO path
Date: Tue,  2 Sep 2025 17:48:50 +0300
Message-ID: <4aac9ae9c0fe39a2e47139fae6d602f71d90bd09.1756822782.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756822782.git.leon@kernel.org>
References: <cover.1756822782.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8402D160016
X-Stat-Signature: arhn69pqc5qdsxb3rm78km6mdd6hnuka
X-Rspam-User: 
X-HE-Tag: 1756824615-966671
X-HE-Meta: U2FsdGVkX1+zAaDbby9Oz/+W/+VKhdjD0iYe20cI1H6Ac3l1C7wfSkWzU2Xb3wMqdfb4IhIdXdGSrhluBuYcSr/xn7BofLYKPpXj7xELLm+PA8FqAGWuQrqQosb0/O6bHPtGROmlSEws2agb7EeoljiEOvV/6yK6aT1jC2IJEuhiuirKY6kr4fTM27ElXDN8hEAuEwBcWoTO+tk8B1n/DAlng8K8bz0xQHo3NOjHA1rah8Ozm5elzMqY7YIKiBVfwj9dNncrCCnGRqFtyoJUAOuaqsf2AeKq8UTvwS1FLSltQO09LQDCirfckPLFfAQ7TZEcdOUX5+f1QRKnYOD9p3Isem4du1bHSqpnd6Qeh7hZrHkgxRxqX5VrjSsrKutkrZpApJGOeeQtfQQ1PSsYF2EKPuuYsXG8ZGkgQfzplgJCJwkx38wb8qrRc8ZiPEXJHcsbzqhTNz0Zyq6tUzj4zf5t/ClGUdbPCNy3uvVo9hnn82DdLDuXapbhICVBl1pjNdhqUR1BjakMY+IE6hhWYLbSYBdafSqb5IueFcULT5xNW297NMJyqcIh3CsEHeU5rZ/7Upc2UNu1MwAV9BKLDU2FFCAsfBznzsTlr4MsnxiFimVmZkqVxtov1ZEdq7SLdopdZ0JQ4YQGOVClYUE4Kjpls8ofbyWdcOqubVelzFqL0PWFAW5U+YY2EO2ZJ4BDUcAOSQiNixw3MkJGyjQT7wDN2NGa8QKOwqXwqPtv8cbNLZUqiSb+WAUjzoheII+JeTI8IhKs+NNWxEPfpR2sCWjqJbkqPK30P9ffvg2eFGqRwrk/3Jti+Ir1pz4o5EuChdVKZao2d9aMoOLvpGNDsfGKPTM+BAOBRaFVuZQRYEbd5CRNMeLZYex1/vRa4ZPJtRCl/TJDd88GgDsE9sC+AcSgR7ZskIy6EEW70xaaAZJoQIqgyI6wu1qwo+UK7uDj6fCd5/hAVwttNCbM4Z4
 /zrCjUcw
 AS6d9AqMJNo4qDtX0LNrN/QqGo78AWZpRs+9o+fMHeTFFSiEIoGaTWBjoh/9ecjxNFljxelviQFlB3ZD+mH6JuDuVUtHZoyHohU9fwVZ0CQy66Rbd6ckhP55LIMbjtgze0aCxoxyaK4ApOzZhfhJs25ClfmUEjUe1zdjmqyP54p39MYAyAXndRS2SbPlO7IXZWoVV8dS9fSmQjdViGiJvYXeH6oxQNj2HavK2JOUE62Vwg/6iiEn1iW74Z+FHq+9u1RFOs2dXZ9RpuKSuw4lvspgH3Bc2miXk0P5lxL3qrobub2OIFZl7VSSmfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

In case peer-to-peer transaction traverses through host bridge,
the IOMMU needs to have IOMMU_MMIO flag, together with skip of
CPU sync.

The latter was handled by provided DMA_ATTR_SKIP_CPU_SYNC flag,
but IOMMU flag was missed, due to assumption that such memory
can be treated as regular one.

Reuse newly introduced DMA attribute to properly take MMIO path.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 mm/hmm.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 015ab243f081..6556c0e074ba 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -746,7 +746,7 @@ dma_addr_t hmm_dma_map_pfn(struct device *dev, struct hmm_dma_map *map,
 	case PCI_P2PDMA_MAP_NONE:
 		break;
 	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
-		attrs |= DMA_ATTR_SKIP_CPU_SYNC;
+		attrs |= DMA_ATTR_MMIO;
 		pfns[idx] |= HMM_PFN_P2PDMA;
 		break;
 	case PCI_P2PDMA_MAP_BUS_ADDR:
@@ -776,7 +776,7 @@ dma_addr_t hmm_dma_map_pfn(struct device *dev, struct hmm_dma_map *map,
 			goto error;
 
 		dma_addr = dma_map_phys(dev, paddr, map->dma_entry_size,
-					DMA_BIDIRECTIONAL, 0);
+					DMA_BIDIRECTIONAL, attrs);
 		if (dma_mapping_error(dev, dma_addr))
 			goto error;
 
@@ -811,16 +811,17 @@ bool hmm_dma_unmap_pfn(struct device *dev, struct hmm_dma_map *map, size_t idx)
 	if ((pfns[idx] & valid_dma) != valid_dma)
 		return false;
 
+	if (pfns[idx] & HMM_PFN_P2PDMA)
+		attrs |= DMA_ATTR_MMIO;
+
 	if (pfns[idx] & HMM_PFN_P2PDMA_BUS)
 		; /* no need to unmap bus address P2P mappings */
-	else if (dma_use_iova(state)) {
-		if (pfns[idx] & HMM_PFN_P2PDMA)
-			attrs |= DMA_ATTR_SKIP_CPU_SYNC;
+	else if (dma_use_iova(state))
 		dma_iova_unlink(dev, state, idx * map->dma_entry_size,
 				map->dma_entry_size, DMA_BIDIRECTIONAL, attrs);
-	} else if (dma_need_unmap(dev))
+	else if (dma_need_unmap(dev))
 		dma_unmap_phys(dev, dma_addrs[idx], map->dma_entry_size,
-			       DMA_BIDIRECTIONAL, 0);
+			       DMA_BIDIRECTIONAL, attrs);
 
 	pfns[idx] &=
 		~(HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA | HMM_PFN_P2PDMA_BUS);
-- 
2.50.1


