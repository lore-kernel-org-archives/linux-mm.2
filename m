Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C2DCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E833F9001BC; Thu, 14 Aug 2025 13:54:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C2A900172; Thu, 14 Aug 2025 13:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5E7C9001BC; Thu, 14 Aug 2025 13:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B2017900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:54:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 89FDA1A076C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:30 +0000 (UTC)
X-FDA: 83776112700.20.4633AFC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id ED7081C000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EOeexjxP;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755194068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxToNPSfI6WM9a997+Z4VoIL+Khe9+Ojk4pU73w2JVQ=;
	b=Y4iPf6PXBk7YC3RyLxiIa34GH5n5oBtilf2JYfDQqgmoH7Iy7WYBCF94ZU05RqZ1nc1B2k
	LxMYsREnzS/y7QDssE/xLHIqan8/3gz6MAdaprNpwnDOkhcCGWHdcktigFYBqDBJCsZy3r
	yYEvPVmVE4PpuAshK00dZiFAUyIoM94=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EOeexjxP;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755194068; a=rsa-sha256;
	cv=none;
	b=6cR9Rpnm3H3c3SI163VIsDty7Fhgyz5n+h1p6vyo8TYMFRaP3GUV6HjpNh9nWsEX25sNLq
	k2Qd2VBC2srEMjRdeUd5dtq2F6wICmDG5OgQZ67M0AcKSrF/XiycpsfJ+ERxIRwPtBQGlp
	aW7nPxekNfG5wQZL8Z/sArWoO7RFDcg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 75DE8601E0;
	Thu, 14 Aug 2025 17:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8C1C4CEED;
	Thu, 14 Aug 2025 17:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755194068;
	bh=/KA5/iirzA+7NBo2WhreWFarQonN7Bxg4iw8kozROnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOeexjxPS/6ckwAPFRbfEI6in/li8Umj4rsGNm9PozGB9vSpZDA0l2HVvxKXWJY0H
	 c9kRUP//VlmtqQDo7vP2pT9qUIq35CfPoyCVtFUgYbGTuqU/IrXxy5Zis4lOPAfKpv
	 Qn42KxzqThq/CBCoqG+x30f0YbctMymqllyLmd8r41SkZLk0a4Vld+fYgdMxy/D7oK
	 KkD8kBg+gl3/b6HrQsdWNvwrzee1F50J0L4mqfd/q98lj6BCMP40rfPDepY0NoMJLi
	 /vr2KcIfm8mHX5eJ4IXShqV3DtPJ2Y2dAIyk9uE1jeVq3oTEm0AUda85Mgz4J38cN8
	 S/2gU/vm5nOng==
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
Subject: [PATCH v3 04/16] dma-mapping: rename trace_dma_*map_page to trace_dma_*map_phys
Date: Thu, 14 Aug 2025 20:53:55 +0300
Message-ID: <d7c9b5bedd4bacd78490799917948192dd537ca7.1755193625.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755193625.git.leon@kernel.org>
References: <cover.1755193625.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ED7081C000D
X-Stat-Signature: aj54hcyrqqnkkdjtxx6yzm5jn9jzzybn
X-Rspam-User: 
X-HE-Tag: 1755194068-933151
X-HE-Meta: U2FsdGVkX1+7ITLJ9ehkdUDRaa7aaclVQYFHgTvFFsMy6fIO4X8YFczGEdvkUYbQexqxZyUJkRqTZ0pNYcIF0Njlsaly8b64o22J8oxKQ2u4yzaOwjlMhRClY74oZeBhSEEn/AJ0j21aqBJIdRE7dPjbjMT/qRGHtAQP6/4UuEwP+ZUTjmgywA71GJc9IbqXYSpHDEBeYQj38BCHH6eelhtehRTFJt8ZX+4fYtwyYGENtUSt8aymBg93u4C41xORpc6MnZc4Z+IX5aSymWV/0pSgSVttOZC4zELmtPrt4Q5uPQCq6iZ/Nzu1jW8N1+5PBoZNsGJw6KRGWcUTCbcB7gDuxA0qp2qry6nchvz6xY4y8Z1baRfusClsZfJUqO0yGrRfF38YSE4Y+ccX3PZzRTodlUVzQ2jVSa9TLXBW0gePXN3p5NN+p9B5aLeYBEM11B6ggTYvF67+TwD75hmWNQMhWM6KIjb4SuYO8svDOpttW6wiRWSc3mN/0zaQrUB+T3KBpvHMG2VPSEJXvAEiE4auT486GBIXSNN2iRjgrE3CAo0dBHK2WOe/bnQEQ9MfSrdg7mgD7br5RBWsDoahF4leMx7vUM9hfHR5b5Tbg/EgJdVl/9WC8Pt31zZDCdJM7Lxj2xHM7oM8qt05MfDUv5rdhhCcLVSVT8QYtbAKkbXmn1IZY2/k6My+9K0h2qmXBDd/gGawMy0I9jF/gqNHHBjyX2jPtMFkXnkavJofqhYr31XKS4Q8GvblRPeWZs+TQL4tJ19mvNsnkIdiVOvb94C2J8ytB0JzZ4r2UOwb1Yb7VXmrfslnKXAdmIwcEiCW4PxIflX+LbwfH+8lj0CPLufad3bBDmbyxawh/FXYbaL9bFZFjcVzm+f2JOtCi0w4aTgDlR8nKDCB2ttXk9cw/e9wqYC81UDYMlnprs+7iPImBsq//jx5Bt87fBtU2ZeCicFGCIVXM+HBVrE03eZ
 5KUMAWQ9
 bhonPIJ7iG3yGglYg8w0e4ffukE7f8muKk1bs55N7qSWlO4JqMayUFP6v58K2xpWvxuY1xprEvMauW3renNSwtB+cSUhIaFABSpey0uei99nQmJkCTGSxDXGC1fpCdRFdrr2o0LbLBv3PronbLWpbGOU5mvox2I2+z0gsJ5u2UE+wdk7Tcinm7ls18TTfEKLl3yXEwMd+NA/u2mdHbfHmwmbrZEmMnInF7+kXpgZ1d9/71zbkFiY/D1ZXZr+zRo3d4QDSCyEpV4DHZRXXVyPdSdnw2kmiPBWIPQrf2Gc0Yi52jIK2h2t+se7KaQ==
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

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/trace/events/dma.h | 4 ++--
 kernel/dma/mapping.c       | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/dma.h b/include/trace/events/dma.h
index ee90d6f1dcf3..84416c7d6bfa 100644
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
index 4c1dfbabb8ae..fe1f0da6dc50 100644
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
2.50.1


