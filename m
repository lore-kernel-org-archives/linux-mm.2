Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C3DBCAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 13:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97A8A8E000E; Tue,  9 Sep 2025 09:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92B948E0001; Tue,  9 Sep 2025 09:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840BB8E000E; Tue,  9 Sep 2025 09:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74E608E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:28:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4352F11A423
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:28:30 +0000 (UTC)
X-FDA: 83869791180.23.990E9D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7E9C940006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:28:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J1woyVLh;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757424508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vayxyhaMF3JHU73oK2kjzQVv9MzTvy3OtGJfg2sjWUw=;
	b=v+9W1nijADoJvsmFyBjvN4ncIcCn6zR6d7oipFanfkq3hKf6VUeNpxrhFE5+kmh/D8j6DM
	zbECFfdb6Y7KldqZhy7GNFZfY2Tpt5P41g381bNe33CvTbGEp2Q+fAyjkjGRz6+Iyqr78M
	hKdeGdiSIU8K+RgdaMt0LgjK4DLB5ks=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J1woyVLh;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757424508; a=rsa-sha256;
	cv=none;
	b=2AYMIjlqtUD1tWtzgaZyizHHSeH5S7ht8m2oK8Qn0ZX/UXzl3mNLTx5GkyhBVs1FqzK+ZB
	IE49Ra6peDeOMBh9ESQyThWAhrGs2T4+Ey5wUcIRV5x9Otna+Uvl7W5Bol951eqjkYMtDl
	nV7BoSdWV5PJlISYEc4DdOtYfBR1KKU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FBE744D02;
	Tue,  9 Sep 2025 13:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E1DC4CEF5;
	Tue,  9 Sep 2025 13:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757424507;
	bh=m/3FWvMEP+/8V652buMynLIdEwgRPi43wgZz18MTj3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1woyVLhqM3siMNPivivEJv4VNv9s6uNc0piiXttUtdg0DDgKmV0YSZ8iAFwn4Alr
	 i3+qMLsfuJ9iNwKrXrEh3Gws4/K2iEAToxhQNQRXHpqnn6JdhSO4dpZT934lxzQik/
	 O7NdvZ5UQ9AQqZA3NGDNaMt/iPOjxHoruIxaXyeL+Muz472ygrFNWUvBi2XbazYeKs
	 f6ctLEh0WQXu5o3Q7G7BI3TeRYALJWhN1JAzf58uBQBm+HT/TLHbHonKigOdYlr4LE
	 wORVtoiGviO3dG7x+I9o7DQ7kX+JtTcYcgSvq5O39pFQ72XF5HX25y58wNQqXX7NAx
	 AVQmxHiCRj5Sw==
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
Subject: [PATCH v6 04/16] dma-mapping: rename trace_dma_*map_page to trace_dma_*map_phys
Date: Tue,  9 Sep 2025 16:27:32 +0300
Message-ID: <c0c02d7d8bd4a148072d283353ba227516a76682.1757423202.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757423202.git.leonro@nvidia.com>
References: <cover.1757423202.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7E9C940006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 5rbwqmhgyxdcafw6qfgu17a6niu45toi
X-HE-Tag: 1757424508-615358
X-HE-Meta: U2FsdGVkX1+DdcQ6+3COULK9EtPCFiYSmLSf0vaiFrpzsYoJMfAjMqx7jGbUJgmuFR/bwlIs2y+1MZ0zVZYnAMbMYVD4oxwFZhV3r5yCID/5ar3UpZpCuA5kNJtjVNredAjQbyWwb4BpOlUpQWG/IrtjJ+Arl/uQVQt+WVr1SEJclTTlqsZL1LU4tvbkEXToGM+Q7zZ8RAl6niRxPH3YbO2OU7wjUyj/JbdTz3aERiOM/AooRGxPxsTjWOiIspr1noTK3nMHm0q042m1YweEqqpv5JIEP+/auUF5YTbjBCz3h75uVWa00LbWGg+JGHMd8PFsobOZE02wxXiWt5x6O6eCQKj5ABR66TkJjDLAUFildz1hYYI8MJjA6aiBWbn6laAqqZBvsfVe3BW9rMQDihQ4Vs5nMdl1ne2AIXdoXB452wBfXpX0J9nAUjS6+QBifWtoFHyt7lr/dq1gqVwl2uyetCHpEpVpjb2DLr9MnavqXGgAbUsEpTk8I/Y8ooGZKb2574Hp097mYOaRo09mnkj8lXpylpyFh2vGxFrfuyOvb3QA8ec77JE/GFuIfPHjbUh2bWP0zdwqoqHverZv7VS5Euoti7NNd880ci1mp9lJlDj+tt42ZKC+9LyXb5hVvBmV9/ZEBoPlQvle5OhNNCpggM8Po5IQ79z9U873SVSEN96ezhawVP3LHIPJYstz6/5UYgajdiJWByvFlwkkfH7Uf6P2vbTfe/Jh69LiFuVEXloaJ6k/dF0n6firhuqgnjWzolxtFRJiZ+enKPht5xnIDzD4nahFZ/j63JkHEPQzGjFEd+jE44tKvDsoiVECgdTEamGeYIb2buUYpXuWntSwaegv7v7RSRQ9VgESG5dI/qafn4JienT4UmOUtcJzpXDfSVnGLJbwu6IcULVRaap0LUgTgsenSZOZD1Q40PmlvpRYRZhqpfqYWDpO1K+GrhBl1gAxdEfqnX6E7F9
 qn31p+AI
 UrEFUnVt8bDhQiCEwkL1ydV41HayvL7K/rpgq6FKXaU2udwloE8RPgCpEtICBafUg8sHwbyoUx8FCTFrr2LCYW0/0T1sfjR+u3gg3GYETWWMLsZ+Vs54X87i7d3KlwcaErgdKQVbjXR0ZijLUqd91CuPPieL1E7Gb/I1IwujLpsitLQWjbLYeo1Awyy69Fhm0e6NV6m7AVRkoJbRmeugbYFZjI1V2ZAffqrSHn24zry+pa5k//oAgn/Tym/mB6c4dc2aY3btfsdZG068ug1971YxKXRl667RsBEO4y47bJBqka05cax1TJ/WROA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

As a preparation for following map_page -> map_phys API conversion,
let's rename trace_dma_*map_page() to be trace_dma_*map_phys().

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/trace/events/dma.h | 4 ++--
 kernel/dma/mapping.c       | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/dma.h b/include/trace/events/dma.h
index ee90d6f1dcf35..84416c7d6bfaa 100644
--- a/include/trace/events/dma.h
+++ b/include/trace/events/dma.h
@@ -72,7 +72,7 @@ DEFINE_EVENT(dma_map, name, \
 		 size_t size, enum dma_data_direction dir, unsigned long attrs), \
 	TP_ARGS(dev, phys_addr, dma_addr, size, dir, attrs))
 
-DEFINE_MAP_EVENT(dma_map_page);
+DEFINE_MAP_EVENT(dma_map_phys);
 DEFINE_MAP_EVENT(dma_map_resource);
 
 DECLARE_EVENT_CLASS(dma_unmap,
@@ -110,7 +110,7 @@ DEFINE_EVENT(dma_unmap, name, \
 		 enum dma_data_direction dir, unsigned long attrs), \
 	TP_ARGS(dev, addr, size, dir, attrs))
 
-DEFINE_UNMAP_EVENT(dma_unmap_page);
+DEFINE_UNMAP_EVENT(dma_unmap_phys);
 DEFINE_UNMAP_EVENT(dma_unmap_resource);
 
 DECLARE_EVENT_CLASS(dma_alloc_class,
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 0b7e16c69bf18..bd3bb6d59d722 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -173,7 +173,7 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 	else
 		addr = ops->map_page(dev, page, offset, size, dir, attrs);
 	kmsan_handle_dma(page, offset, size, dir);
-	trace_dma_map_page(dev, phys, addr, size, dir, attrs);
+	trace_dma_map_phys(dev, phys, addr, size, dir, attrs);
 	debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
 
 	return addr;
@@ -193,7 +193,7 @@ void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
 		iommu_dma_unmap_page(dev, addr, size, dir, attrs);
 	else
 		ops->unmap_page(dev, addr, size, dir, attrs);
-	trace_dma_unmap_page(dev, addr, size, dir, attrs);
+	trace_dma_unmap_phys(dev, addr, size, dir, attrs);
 	debug_dma_unmap_phys(dev, addr, size, dir);
 }
 EXPORT_SYMBOL(dma_unmap_page_attrs);
-- 
2.51.0


