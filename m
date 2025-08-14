Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1C6CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0E9190012D; Thu, 14 Aug 2025 06:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBFD4900121; Thu, 14 Aug 2025 06:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D867390012D; Thu, 14 Aug 2025 06:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C035D900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:14:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74CBE117A7C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:05 +0000 (UTC)
X-FDA: 83774952450.03.ADC6B21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id E8DCC18000A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BGe4vleQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755166443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxToNPSfI6WM9a997+Z4VoIL+Khe9+Ojk4pU73w2JVQ=;
	b=RBqnsuvu4J6/5Ylp8yRBOrWtQmd/tbz+2ohTelJNtgftY3hBlrWj6qWUZJmiASn7zJRiYo
	ydwMWk1jtW3Gfyb8DqYaZvlAGAItc0B4flmLapb5HpwXBImhRZDYfjB6Uf1b1mmU1bjIc6
	5don70AjlQAJxjyeUdftZEMi+e8Ft7U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BGe4vleQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755166443; a=rsa-sha256;
	cv=none;
	b=I8rCvk4kzIqVGfgWxdxv/64Mf4oRYkN86XW2nJar/ZNSdJdhlrDOVtDGuDQr2SPTOhEp61
	kggSYTEK+ca7CA81AXQ3PXZDEpnwN3M+BTf8lb3hhUpBZMhQnejrZyNWsHLcfSYwMBiLp0
	2wAIdx07BkIhcPL1Tuepj6Wnr06ZdIY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E0926020E;
	Thu, 14 Aug 2025 10:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F402C4CEEF;
	Thu, 14 Aug 2025 10:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755166443;
	bh=/KA5/iirzA+7NBo2WhreWFarQonN7Bxg4iw8kozROnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGe4vleQatc6QvuAH2fy4B75TxBgzBxEACBQ36+ORLvUhpw3mDjyp8mcCmmP6BkHf
	 fR+i/ZitYuPWRhYU9ApTdUDtdXSAmprzH0LDmBzzJeqaI3CnO4dgdJGtp+ykzqyrq1
	 HrbrxFJd1kqtKJ3lHKYDz8V3nqnBxtrrAHClqUIPGudaRZg5RJzucTOQagHfnrrG36
	 /paFtR8N4oabJii/YhJMofjfC4t8xx4hzWTz0ZBc9wzITfbft5gm35VZKBAWhiEdXW
	 2B8XpBZQp2uA6OV3Nx3+yghJgiUfs984NGzIEhTePN6wNHKnVhCiPrE8oeYg4Qsptu
	 jONoXg/efXbaA==
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
Subject: [PATCH v2 04/16] dma-mapping: rename trace_dma_*map_page to trace_dma_*map_phys
Date: Thu, 14 Aug 2025 13:13:22 +0300
Message-ID: <18459094e29f22a137a9a77c614bcef07963f769.1755153054.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755153054.git.leon@kernel.org>
References: <cover.1755153054.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E8DCC18000A
X-Stat-Signature: rhr8tgunwbu7b6szq6sww16rtu8na3sf
X-Rspam-User: 
X-HE-Tag: 1755166443-93770
X-HE-Meta: U2FsdGVkX19INSdJk4mJfTXnl/Q40VsI3QzDS/TYMPrDeDhiCvUC08oIZXm6aojdICkHmW7yosXGdPW+z9uqhTyUcKV3lgRilxsZ70+c2iczOMld+TBprGyh6+jvS/8UlZmyl1VBi+mXJkgGqM7x98576UkDiQAyJVkEHusXQfpfhJ1VbJEvd+A4CnROUQypQi2M5WWc/EfjJw1Mq4FTAojsrO36b10lSTt5bLugozzzjKA7Jivt90GnBDSaubOT3rJwXf5w83d+yxsViw4rnHg/3OW9qw/Gu5LlZeLjcW60Sy4duqFlo5xrkKyv7UUe9lK3FwTci3pyNL52z7oVw2+v/YlbwRLsRXC8q2ViuaYbPWlvVRgSyH5K9KpK4yfsL7U2J87i0DpNHzcArMFqYbL5oyP2BdrqtnU49GziLXe5NOkPTCkaVwePZcyWtXi5vBrSCD/Ijdb40B8j7q+EL0H8KAal4Tk5uLqf9eWjWEf+5m5gBa8fR/cQiWNJJDKduKqdgin35ga5OJvb7j0Ml5m6phYXZ+AQVX6IyRwb1JXlOQonXlJb9FKieIhBHnAuvO+O2/czIdaaK0LcJmJeWnqIAj2ANFdjyI/HbinPptpokqkOuKW1IFY22qzhkh6NCTR9/Bnw/z2+LTZ1RNCcm0robVrGXn0bqJ9nWmJ3r4Pdr/6xucmQCUeAJn8WCSRBnrKEZX/X6sFGPKTJVu8CM7xgYMkkcgydvFW2rCmUaqq9ymuEdBHSADC2/QTwtHl8fwZMVf3XqP1heJUGPrqfJyQtiJL4skfBVwqd5UE4LjsYLdUtovFtsqvxJyccnxXglFWBSq+iZhGzOeCSDXAYe9iDO8OGyV23V3TC4Rjm6wpvbJHGZPIg9ojiHwCa1e2Sg+w4MfVQxXx5F3UofjegXIGaE1WLC6+BwcJdXIr6Y8LN7B34bEWRn4r3RNtQfzlPZWdUGTcvUZgVrPLkXI9
 avFA2TwX
 O/tRkaSFHwVbPdXe9KzBhqfOK+iEV7iR3ZWBf21Xvv8s0C7f09ViGEUAgGW291Zzv3RJtkOTM/H/hn9Gxox+nLmrXsW1z6gfjFcJl/HmIaQUHelnG5ra3OlKe3pxlXW3LzXh2IHGV0FV/hddqE02bOBIyttOTAUGXA3lqxnf2OtOm9MovIQ4jgKhLLUGqo83AyE/xIdH74Ykq1zjfkiZb7gXSdgqH/htbDBQcZM0mqX2FyfuMbuAFvaSZKoXoieQgd+EI+Q9koisTVxBxLZgVn4Tq0YeRi4g2bskJdWrLNknKl/6e9FC/oRN/JqeMZTCH6aqe
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


