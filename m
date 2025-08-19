Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D776CCA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:37:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 751048E002E; Tue, 19 Aug 2025 13:37:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DA6F8E0005; Tue, 19 Aug 2025 13:37:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B8C8E002E; Tue, 19 Aug 2025 13:37:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 415C18E0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:37:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA26A16018E
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:37:49 +0000 (UTC)
X-FDA: 83794214658.03.2BAC939
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 34928C0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:37:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OoY3cFH2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755625068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxToNPSfI6WM9a997+Z4VoIL+Khe9+Ojk4pU73w2JVQ=;
	b=7uXG+NOYoJuWRGFeQOEZPDh5QL6O/H+s6UOlLTzdNe1i5038WC8tBSIAok60MaXlG97s7B
	9T5JQmi5GeK5YOnlNMezPj75F4Ei7pScN3waBCGe8Z5s5zLM6Uq3d2xOeQsMQQ3TsM+xKo
	pBIbud9FFU5atzM+lGMMkjaqhsfBcIc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OoY3cFH2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755625068; a=rsa-sha256;
	cv=none;
	b=RhrdAIjZQ6920lyNn4I1tkh00WuUg+YFpDaIa9noswCLo5Pi2NN4WzWPPkeVmb/H4R/4wa
	lXybwSRLGUFd+tPhZ8cfq5bhw7+glttG8jAKXB2sTX8sB0xwadnewMWtwnx5l5dAJOYH8h
	F0r1QrvV9nIJbpwgwanqkvN1v0UWaJg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 68ED361428;
	Tue, 19 Aug 2025 17:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E31C4CEF4;
	Tue, 19 Aug 2025 17:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755625067;
	bh=/KA5/iirzA+7NBo2WhreWFarQonN7Bxg4iw8kozROnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OoY3cFH2dl227qnLV9qdRahXTo4iRGaE1ejAUo1nffsJP0oy41x+3H7L4v7i2x+3n
	 xubqfjQVTIQTYC5r+ENf4+KGcCnAUVsLcgjhKtSG7OSOwipn6OBplJzxmTdzuG0M9E
	 nOqACnOTvFp/m3vySJgCvla7yn84iC8kCcZYBJMh4R+MZ/b74GrWwrWb+iQMHKPL+t
	 NgcwvdawK6zK2SX4ql7GcDqU9F51bDD3j3M2HcQm4mmg1VmtQYwjFoitOFxvUHKbl3
	 rqW/Lkb1w2tnkNmZBZDtXk0WCZ8okhRrV49XpXjkU1fgNjQ27YX9a0l0afVRahDzUy
	 VvDsrkwd9UrzA==
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
Subject: [PATCH v4 04/16] dma-mapping: rename trace_dma_*map_page to trace_dma_*map_phys
Date: Tue, 19 Aug 2025 20:36:48 +0300
Message-ID: <d7c9b5bedd4bacd78490799917948192dd537ca7.1755624249.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755624249.git.leon@kernel.org>
References: <cover.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 34928C0002
X-Stat-Signature: fq57uk5qp3iccw4yfj3h3ysa5erbwhjh
X-Rspam-User: 
X-HE-Tag: 1755625068-493711
X-HE-Meta: U2FsdGVkX1/g0vF1M9B3z9irtpOp8UYvew2yCtx+h0yq8oxMSbvsUiU/1wvaxreZVwSX76xzosuQ/9Kv8Bz9p2NpfuNOWxIklW6Ptp/nB+PsDjs68y+CrumaGGCU0dX+8v/llFVQvCpd5MVCDyTuiQ2ZJ+3qf8Ed8fjHknVHW2vl+XdYaGEhMlYwilamvbcGhaADEeLVj/gDmDunirZjaLqelam83MSu5ohy4V0ckyWP3AyfWYzK9SmtOqhwZnjdTuSGXSzNR+gIqnCRVT07LUcws+U3HjY5txlZUJ5WMeCCEHVNQeIJLkbCAMsB1+8WbThxt0G0J2OzE576wvFQ0dyDjqjGPfcbxtNHQRxbfWpLXXPNsJ4sxpgCchS2BCm7I+rVb+/TGa0+YLVwF/p9p7zTaCfmmTEee8vSrbK/QkNwlrGuNy1KUeXuOb2bDGfgPahucAUuwYcUzSvhmMFQY434SV/NXFuVGNNDmkqWoWCMTZGt7aAEC7LKyRqH/ea05szZHjQxLZBcKkiF9wvDLVIdkE1d0CK5U9hF9Qwg8eEuIQyFmBAZnoSFuRkMxBtyHAa70izxRSof7eR70ULW0iVe7AOadyY3jageFYrqhfT69vHwD9BXp7KCg/qz77In4FjxGuA7uaw2P3AsxFTZo/qwYsMBun6bCcXytd+RHC8oQB1c2HexMghQ/Azii/hpu8j+KFW82CLQE8dAUF62pnfEdUy+xkRHnnD8HH6dbS3LHE/5q23vv1bkn6FEnW5pi6e62I20rahWNASu+bGJ3efb+N7wpFCLE271EbLG0ykZzoPdgYAOfMaVj6TEPNrcjqFHCm/7nEL6xnz7desUfioWioHhnHYu+dy5iaDgpRM+IsaOTxwojHLSoboozfpaiGDlT6774nwIIoZ5TjQHag5pwFuk0yUnR4D1FfGS0az6VddbqfOTFL4qIL1/PVm8sVMSbM6ryY88e5FL/Ty
 sAXaQf2A
 KdVCsitQx8rShN8SQdff06ov+vu6m6PTgwaA7/2io90wy31KUQbaOIXNopU47QAql/BBLF1IrcEPwIrd9nUX4GYy4vzRlvvEM1uu/LuTvt2zFHUSxxgoxChyeOI1DJl+BpfjdTWzqVY5yJyF5nFwOUVphZBTSIgoTfS1JFSQ20+uy+ugnGU6kHCplm+t9dkbj544E+cYUbM+QDZKpCDhWTz7QcAc6fXBpIB1LKYINgwj1p6z2bzpGSdAIu0We80LfJ2RmTHLAFw4u3KkM4Bvx893OzKoTklWhKKO+tODujPg8WuaKpLnrmX6FOf41uGhHEMdOy5FnXqMIjkcHWP++j1B8HWFfTnomxqjr
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


