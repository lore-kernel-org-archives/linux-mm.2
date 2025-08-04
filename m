Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC4FC87FD1
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E571F6B00A6; Mon,  4 Aug 2025 08:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E076F6B00A7; Mon,  4 Aug 2025 08:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1E676B00A8; Mon,  4 Aug 2025 08:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF7E96B00A6
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:43:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9E128113A1F
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:43:37 +0000 (UTC)
X-FDA: 83739041274.25.45F35AD
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf12.hostedemail.com (Postfix) with ESMTP id 06D1C4000F
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:43:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WRgsvRlF;
	spf=pass (imf12.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311416; a=rsa-sha256;
	cv=none;
	b=a7U1Or8KsLNx1LrKR4PXfXgIC3uZXUd3bmjGgc0KT2N+eb5yhFm7jLiSVahV//QOjxQv5+
	ipvaEttFFYDV3dG+O5YgixpAaa1pgJYvxRQkjNjdMN6/81D3k8ROqZKBMVyMlS1fj20ZM6
	gJh3ddpHkEsrots99yrJaSeUGhmcE0o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WRgsvRlF;
	spf=pass (imf12.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLLzwi1yAXsHc08Aygf0gJ2rcKhVnpp9gk2ta6mt2yU=;
	b=5rFYIPksqu7tr6lK9j3lGuKDqj6d0D8UoWZsy1IglGVine9EmlW+fKiiZR/v4MOJUcoAYF
	Bg+aQmN2yHS1XdyVxKBsLERXD0ZLVb+npQJwApa92udQwFnA/IV0thw83fnVbHg1W6/n45
	0EqAdNObMA9sK1dgcgvqKGjfyf/B3hQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 46869A55826;
	Mon,  4 Aug 2025 12:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7673FC4CEE7;
	Mon,  4 Aug 2025 12:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754311414;
	bh=gXQfTddyrmH8Ixen8MMOQFcSDtf75ytBbFmEnbpkIK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRgsvRlFW0e77jc7NIsyBW2keN26coVZrkVCiSkqs4aw+XPWcg7vc+V1XlKoIcE88
	 IOIbPQelgEDLheM/qg7mVhJZzAqXm7CUjMAMKNzC+umg0g7DwYC9YBLyHXL0I66FCh
	 IFbMO71xVEUgxdJl2+IupUgaBpdkpCp+VfiDgWnzz0MMd73xSf4ctXSScspzbf7J4C
	 MQm70SnKxDBQEq6Qi5EQDhrkAfT+WwzTZQfsthVUSLn1pLEnK9pcRGmBAGcQOXI3DR
	 pSMdvMXvMDulNitg5dtAwYyxJ7hDxcGMKpGt6kEpCAlccx1SJGPya+SDEHg8s11i4i
	 u8QgrR2e/DTYQ==
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
Subject: [PATCH v1 04/16] dma-mapping: rename trace_dma_*map_page to trace_dma_*map_phys
Date: Mon,  4 Aug 2025 15:42:38 +0300
Message-ID: <7e10dcba2f3108efc6af13bfdbe8f09073835838.1754292567.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754292567.git.leon@kernel.org>
References: <cover.1754292567.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 06D1C4000F
X-Stat-Signature: pdok8swka5r93rsn7nmh4sbr3fbfqxtq
X-HE-Tag: 1754311415-947729
X-HE-Meta: U2FsdGVkX1+gm0BWlnKPV5rBNH8Bivh46KXn0X0m78dv3khJPZMrPgQ7yXfemWfW5gbkrzqGZQ/FtyfDHwQhZhzkiDQZmebQBxxGJJbFBGQ51FwzabT+zcef0u8ETuri6+v5HGxHf7AUamKYyDqilncriCXbcAmPmlN0/AakaNSzUE2ZU8AH7RK29XE/hrZaK8Ia65fLn+TshJKY8kMlkHP9qA/MbHwLR7PjTKtlyluV2VfRUImi7k8Pi+s5w/SKPrwL4huIxF0UUXc/YDdgRzSfq/Qd5GFebtt51dxTI41O71fvM8YGtuxy2qSrVmTkHLIDNxSPqDD7fseB4gBG8cQy6VWcstkFKPGeBa1zaTeX8/3JsWLIug9alKsJy3VwAKW/f+DGlzL7BSu26HPMQMvjUR/9SXIKPncowPoo2tL2thPThgDnFolDcYwzWdMxroi/gsFa1SAoy8heMmPuj/Nz8KCSITTRd0oW/aMKfZtrGpCHeUDz4ypda/XHuHl1cMrUFioMT//0OFhfgv1lIDLgZmF+38n7FwL7m0O0Va+zR3GYHcKxPDEbYjcGV40ML3gMLCd3E58115UulaNgfhat/DYr7aC43Z1onN5GrNu5hg6+6MvXtCKMJNqFde6H2Zjb1VxctNVbBOZkad+zCiW3xG2+327/mEAl1yTt8KxVxJcPsxhO6igmgPKjxQr5AbbVSYPUS70K8mhJpShNB+uJamnKxJ0lIR3DSP1WmoFjwQbVSy6aPbfAYV9FpahGM/2NM8wQG/1NBQw3dhHtqfAzizz45lD2YKzEcqKZ4d6V8sMd65ykP5jJYFdYXtrAMYBqft9/kcTTrDowN/ipJ7g1/PJtSCAuheUXw8fgJtqYNIuPw31pa4/hwQPI4+3lHQmHXl3q+NJdrbtUwRwYLijBP7RZRTqIIBLgAX+zHH/ySkPi4edo50dT8RDGU4NZJyfw9EHHWJilAOL4enw
 7wbTmAlI
 THewe+8ETRvCYjrBEgw9e8VbT20hhOw2oAXiw58zuRx0fqbn39dUaOlTs+JT+s2MXDd/l27NBsw+hstGDiXWcZGTqA7xlhMfIU9h7voSsWHo7Xz0WJPSj5e1cvE76xmxENNp3IwR1U1MFqPm1xG+2uEJFPWHCZzGQTaTJT8mr/5LdPSoc+OD3CrE6EukpmY4AJr4Vn3EGF+V4apCt6JoRILFsvDWdwDe63jWJIxb9fWId94TdaRj/tgchuRd019ikFmPZfPVdFYw2nPKn6ELrMWPqDqN6GiGW52GUs+a0gBULzZT4a6RRS+qM5A==
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
index 4c1dfbabb8ae5..fe1f0da6dc507 100644
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


