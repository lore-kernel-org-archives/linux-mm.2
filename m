Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03A0CA0ED1
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37720900135; Thu, 14 Aug 2025 06:14:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 301D7900121; Thu, 14 Aug 2025 06:14:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CECE900135; Thu, 14 Aug 2025 06:14:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE381900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:14:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C809D160575
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:38 +0000 (UTC)
X-FDA: 83774953836.29.DDC5B70
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf03.hostedemail.com (Postfix) with ESMTP id 326CC2000A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aVubZT2u;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755166477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1NCjZhyl27tEG0V7+Bnhq6xk8+QM26SXgxxy0a0etE=;
	b=2/R8zfL0+aIOtJ8nU7JENFHVxMonRkj+gQdOQXN5I8CRjc+nVSrzSvRSPwHw5E8Oqc8yAl
	5F+yNcsIypV7iPzkwg15JWWMGX3HssEkojokL/64R716+OvVDQMWxw6N13JVr8UNZmsF9R
	Yznacv4Hf3+3Bdc248Lzk2H/nkup0lU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aVubZT2u;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755166477; a=rsa-sha256;
	cv=none;
	b=y9SKA2arN6ZQQCzEnPDe4P4Xs1Omw/1N7Ei+EaIytgWugwgJDb5IvfpWXucD9Dyl5u5ciO
	FS3V2c8M05sqyWPM6ghkRsk7Ywf8cy9eP36a/JC7twqUitS09PJtKvVduPEre8uQKTEep4
	cPG86Ixf+3pFwNWgjU3h2EJsl5oi/HQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 41027A56685;
	Thu, 14 Aug 2025 10:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20789C4CEF7;
	Thu, 14 Aug 2025 10:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755166475;
	bh=7++3kMKsheKzaFgoeiPBTnsBsSQVYkGRdnBVDIHyyh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVubZT2uurKSIzdFlKMGSZ1aqzlf9Ub/xIp2zaQnuXDP7uFHmD0g6x9HB1uxIbB0P
	 nWxheGYh2MRaN1gMU2QAK/0rl/Dr8ialqj2VtB+1w9oedE/RjBGJE0shoNE3rkmvxi
	 SE0O5JUHOYgmGlvPfnq8qqHP+mdNxrgmaDdpXs1A9F9fOQttcfYzQFYFvq9H+9WXJn
	 XqfZ0o4MbUpEXIHTlaMguQKJuMjZxTdfahLTpiQjUXbTdgeKfNXELNUHttJxi1TQZA
	 NGD7eKEHxcw4D2FX5yFQBcXOjXso3VuTXfbxwDExP+HuCa8mn2uWLaVIDW96krcaiP
	 qRpcmbdDbhxpQ==
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
Subject: [PATCH v2 09/16] dma-mapping: handle MMIO flow in dma_map|unmap_page
Date: Thu, 14 Aug 2025 13:13:27 +0300
Message-ID: <7b8c8f88f61c85d60e24f04e88d42357b898ccbc.1755153054.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755153054.git.leon@kernel.org>
References: <cover.1755153054.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 326CC2000A
X-Stat-Signature: ndu7znwqcc5ezt7okxjy718u7uhak4ac
X-Rspam-User: 
X-HE-Tag: 1755166477-84522
X-HE-Meta: U2FsdGVkX194Q+0/Ci2VyMIg/ahzDMQEZuTXTVRiHu0u37L95n1BP2YF+TJ5nm5LfSiyWkdweqiq/su09z/78FkyJTrxnXZt5SmdnXatMmH44JGC3PGkXfSkb5l5MNSB5dv3SQk1FDNyyiXDlg5sNaKs5ya8O30M0y1yLtXtuKliC0psHFSBzsEcXYfMhxQB0vWdWtmpM/qiYHphFKqccm+xy+GsgWkPuxMZHB3JFEgy1PXcMWAoDYaxmcJitH5qOj0OjrrkN/rls+p8uwmgeMpFkOBQRtGBuTKTH5f/6ORHNsw8r9soRMONZuKtPvjFdu0O4boc05WdWOK6JW4006xvRqa5MZnUTbgftqc2Do9OksK9pnF/QXuQRTa4KcRAXUfXrVuqfcI3zyvDhW8/HlsZ/blymp6aK8/kGq7K4QuF0TmwkYCDzhKnAbapVTZ0jtgmNJYTgVRvn0RsnKlUWxdqv0xxuv97LW+heSV/DlhEmjAL1AOzFCEfGQlueEiP44JVpScQSnYrNGrcSt5/WHF/Vapj/AUojT97ql0jLpLiZ/PGz6g1d1md7vAKThutISStLfzBNwkemPahcfR+1dNQ+itImiGyH8LiateeoBroLg6bl8f+eftghJkkgJaLJWhVYHlNSMX1ss0WuAOTvOF0ktnT5A6q+an+KvSojTmjlUkvjDVbAlwAXJFFdO9wPka+XwNKTq1HdVpRTU9sFipcaOlG6n+GO3J2K1Sg3o/V+4QGuHmUej7g0/kpndLED4WP2nuNb10DjNnO5mMmyuwR1bGyw2KhEn3arMaXo6fJhpMi/pDvRlx9n3SiKuks1mTybMJIEZzVIO3beoI/fdP0keW613vUfxFQjptHjfq8pWMnZ/V60nYVCpXmovXzn9gN7snGvKe8KXRqiCjsU6QsMovPm7pogVdi8zdbsGA36rKFFwZ4vOCt0RW2TbYGe7jRnkmhUgAfacKARry
 rd94tDHX
 NHlVxrQ+klBhx75tMqLqFwvtnK9NwRLg/WkerTn7iDdvzYXIa8By4TN6h4t1iQxVvqru3HvaY2PSKH78IKL6c350eht9QDlplS5WOdV0mDyWsiURcQWIRwM4NNPWdUb0PU5C6B0G3RbWRi22g7WJk/TN+3HrUob+/15xfxKgBCKgGEPSPhHbgeWTYgy7gOIZIvUE7+Dvzu041qJg/5sSwAhg4znZvzgoY2JukM3n2P36mGLVQIvbVzYS+mxkAbl2mMfsMyqRBsQrDvq0Pr9EOJQjx37saN4XCEZs7jO3WwPAp6NNV5jn/ybSIfKY/v7/6mW4rSNl+nAPrMVS7knKdbIjiL0oTuEPs+Da0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Extend base DMA page API to handle MMIO flow and follow
existing dma_map_resource() implementation to rely on dma_map_direct()
only to take DMA direct path.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 kernel/dma/mapping.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 709405d46b2b..8725508a6c57 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -158,6 +158,7 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 	phys_addr_t phys = page_to_phys(page) + offset;
+	bool is_mmio = attrs & DMA_ATTR_MMIO;
 	dma_addr_t addr;
 
 	BUG_ON(!valid_dma_direction(dir));
@@ -166,12 +167,23 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 		return DMA_MAPPING_ERROR;
 
 	if (dma_map_direct(dev, ops) ||
-	    arch_dma_map_phys_direct(dev, phys + size))
+	    (!is_mmio && arch_dma_map_phys_direct(dev, phys + size)))
 		addr = dma_direct_map_phys(dev, phys, size, dir, attrs);
 	else if (use_dma_iommu(dev))
 		addr = iommu_dma_map_phys(dev, phys, size, dir, attrs);
-	else
+	else if (is_mmio) {
+		if (!ops->map_resource)
+			return DMA_MAPPING_ERROR;
+
+		addr = ops->map_resource(dev, phys, size, dir, attrs);
+	} else {
+		/*
+		 * The dma_ops API contract for ops->map_page() requires
+		 * kmappable memory, while ops->map_resource() does not.
+		 */
 		addr = ops->map_page(dev, page, offset, size, dir, attrs);
+	}
+
 	kmsan_handle_dma(phys, size, dir);
 	trace_dma_map_phys(dev, phys, addr, size, dir, attrs);
 	debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
@@ -184,14 +196,18 @@ void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
 		enum dma_data_direction dir, unsigned long attrs)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
+	bool is_mmio = attrs & DMA_ATTR_MMIO;
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (dma_map_direct(dev, ops) ||
-	    arch_dma_unmap_phys_direct(dev, addr + size))
+	    (!is_mmio && arch_dma_unmap_phys_direct(dev, addr + size)))
 		dma_direct_unmap_phys(dev, addr, size, dir, attrs);
 	else if (use_dma_iommu(dev))
 		iommu_dma_unmap_phys(dev, addr, size, dir, attrs);
-	else
+	else if (is_mmio) {
+		if (ops->unmap_resource)
+			ops->unmap_resource(dev, addr, size, dir, attrs);
+	} else
 		ops->unmap_page(dev, addr, size, dir, attrs);
 	trace_dma_unmap_phys(dev, addr, size, dir, attrs);
 	debug_dma_unmap_phys(dev, addr, size, dir);
-- 
2.50.1


