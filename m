Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F3C1CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 13:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BC948E001D; Tue,  9 Sep 2025 09:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66D6E8E000F; Tue,  9 Sep 2025 09:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55CF58E001D; Tue,  9 Sep 2025 09:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 40C878E000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:29:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CFE87C052C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:29:15 +0000 (UTC)
X-FDA: 83869793070.24.8A79BA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4F4FD40019
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:29:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tD4Bnfmg;
	spf=pass (imf01.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757424554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B7WZHRIYheRJ7INKDjrUdN/sfxXGu5MOL2kGZxwrFh0=;
	b=mcO616ym6cNwMc8z22ianwnM1VGPRI57cBd9fTM/n1bBjJg+d/UrNAKyJbp74MDu47G2U1
	x5QvMwo+fNcx8bL+aCArI6yYbQM5rMoB/55Ti3l3arVQLPcNq+G/49SfdzUh2fKHuV47d6
	Wk/CXssuXVG6l3c0oBLDK+Dialvt2uU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tD4Bnfmg;
	spf=pass (imf01.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757424554; a=rsa-sha256;
	cv=none;
	b=r9bhrBYc0Mi4988K3NqdawLWszuBaAZxGVVQrjkiJ9Ob2WhvTQYdqVbtMKRfjXYgbECLNM
	lgRiTfBkNdNDtmO3Zxpn99Qm2075s3CYFW7FNie2l1z2n9cEm+a+DrDopZyzonQWYH77LQ
	YcSVMC3NhAgdhIoLlYBYc3AE9xMlAl8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C541260226;
	Tue,  9 Sep 2025 13:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946BBC4CEF7;
	Tue,  9 Sep 2025 13:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757424553;
	bh=XSpIlPt4jLS+CRWTwe4PmKBEGcwSmMFNT5/+aafmf9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tD4BnfmgL7nSjP8jarOPnF1Kn1BC45TmtpUEyk4UgzRF9j3xxWUtgCJasGtD1cEYW
	 wsKbMmoN0mLlTVmqVsUCjuHU9MFeENKol/15l9I7px1JVOo67vHUW2X/x6NNJaO3go
	 B89Nkj4jb11BZXb69fWJg+iH7a9i4JMVdRx6HuizamFiINp/Xht6wzw2NrsRjzGEFg
	 uU2y5hSynA8hokL2y95P+N9k99ZCfT1r+u27f/8u3ug+IG812ekDMVu/nbK3l8aJ7T
	 OFODjRzmkmI1kisdeS4BJ0OXrhmGCoh7t8HbiKHptbJxGSed9WkruGW5w4iBDhJELY
	 ntNW51a5dmJaQ==
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
Subject: [PATCH v6 15/16] block-dma: properly take MMIO path
Date: Tue,  9 Sep 2025 16:27:43 +0300
Message-ID: <1d0b07d0f1a5ce7f2b80e3c0aa06c7df56680ed8.1757423202.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757423202.git.leonro@nvidia.com>
References: <cover.1757423202.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4F4FD40019
X-Rspamd-Server: rspam05
X-Stat-Signature: tq6y8mq36uc5egezshan3djd8cnqp3fy
X-Rspam-User: 
X-HE-Tag: 1757424554-70329
X-HE-Meta: U2FsdGVkX1/EozPR9O/Ahb6wzHjW7OtAjEMa/ltTPgUNTiz2cyUyJ2HOLBk/lPglqza6LQlVXrSeZ0uKYvini6unX45g/7AH5CEuFX7JriKMfaSdPnHDAdcc15rYL+CFWMaTEm4qJnDcwf4Lw2nEfv8+psKrmn69iM4rbW6ucA/f2OXBhzX7ZqxhwFJ7H0RZRLgtF+7J8Xdrmw+B4C4/6Im5YGQW6WPaQdytfVnMPW+zHgnKQoUp9uWB+rSgIUFsS/RKl+uLs032dfxwOIDaMAg1El17bbjkSF0GRM5lpm6bensJkPZW2QKtXk+OLk91LXoyIDYHVJeZijL/MH7fA3YHNZuaRJ+xZVW8qd2wzjeE3q+tQUoy9PNGYcIHp4ToShy3+DV/GQ7Vsy6lcQEwSxQwBv9mJSAkyARmOqljBDN9HFi3qbZT6D2hfLhtsu3JeA975uulmODt2EoJTOFiVJhAAErntqArjqhv1z5VjTopB8qYOr+nyVxjY5pCjcPiGY5fPxR83QwauiW9S3uM5O6VIeNqOvDV8pfm+QCgJ3B9c8DhFhyQk2Q304jfwROSvEtFptsF3HCHww45IwO6G1HWnkARIgfAUwBq3GJKOn6llntz0eBLF0BnyLi/w5eVrW6DEL7BOoBVAmO/Z8XubZgyokK0tAXZ9oEQreOxV94y7+oxjYqyqagH7ZiuYZcTikWpyaPfrkJpB6+gN18GQCM0IpIEtVmkuEoLUWd2pfStNXpzSylZIVwt7qZIrEjdyQg1wT7hk9CletUz6eM0kDb08uQSGn9fPpTNmmauK75/G2QI7wN0VFMVFIfKymSuO7Er4f2tseePiY03T8LNxARHfqlObsfbkPB2jELyW8UH9a+tB1uONajrltyinAqnnN2gUJL5PnIftueJZjbFZTM/hCTtEZwiRfyTlrubG7bjxRRBbCSl38TP69OJYxWoQVnG+8a+8bNQTeq068M
 TefhDrGX
 loLc2o4WQ0C/46yvImha2jaAuw7z8XX7uz1OoMDW5xEojnKCqnbHkr4EX9uvMHGzZwR60WxaDBGveI1kDbWwIEHJu8ajxXX+M3CZppfKxz3KmFcYrXh5gM+TAVlQMpwzroY73Wk479nvIAfxwP9BWhFMjbEVai7GP0pOlYSOnGbsB/A/f042LaZUg2bpL3aOuZMNeyGuxfop6GsjRqaMzWL51CjmXGgx/bA/LeiM9YfZqczgsSaGK99ahOWON7M/1+ncnbn7ZIIbQMeHx8g915FKORZX7nJDkAOvcE7/gojsXMxx7OCiDYpOGpv3ueXQladtu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Make sure that CPU is not synced and IOMMU is configured to take
MMIO path by providing newly introduced DMA_ATTR_MMIO attribute.

Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 block/blk-mq-dma.c         | 13 +++++++++++--
 include/linux/blk-mq-dma.h |  6 +++++-
 include/linux/blk_types.h  |  2 ++
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index 37e2142be4f7d..d415088ed9fd2 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -87,8 +87,13 @@ static bool blk_dma_map_bus(struct blk_dma_iter *iter, struct phys_vec *vec)
 static bool blk_dma_map_direct(struct request *req, struct device *dma_dev,
 		struct blk_dma_iter *iter, struct phys_vec *vec)
 {
+	unsigned int attrs = 0;
+
+	if (req->cmd_flags & REQ_MMIO)
+		attrs = DMA_ATTR_MMIO;
+
 	iter->addr = dma_map_phys(dma_dev, vec->paddr, vec->len,
-			rq_dma_dir(req), 0);
+			rq_dma_dir(req), attrs);
 	if (dma_mapping_error(dma_dev, iter->addr)) {
 		iter->status = BLK_STS_RESOURCE;
 		return false;
@@ -103,14 +108,17 @@ static bool blk_rq_dma_map_iova(struct request *req, struct device *dma_dev,
 {
 	enum dma_data_direction dir = rq_dma_dir(req);
 	unsigned int mapped = 0;
+	unsigned int attrs = 0;
 	int error;
 
 	iter->addr = state->addr;
 	iter->len = dma_iova_size(state);
+	if (req->cmd_flags & REQ_MMIO)
+		attrs = DMA_ATTR_MMIO;
 
 	do {
 		error = dma_iova_link(dma_dev, state, vec->paddr, mapped,
-				vec->len, dir, 0);
+				vec->len, dir, attrs);
 		if (error)
 			break;
 		mapped += vec->len;
@@ -176,6 +184,7 @@ bool blk_rq_dma_map_iter_start(struct request *req, struct device *dma_dev,
 			 * same as non-P2P transfers below and during unmap.
 			 */
 			req->cmd_flags &= ~REQ_P2PDMA;
+			req->cmd_flags |= REQ_MMIO;
 			break;
 		default:
 			iter->status = BLK_STS_INVAL;
diff --git a/include/linux/blk-mq-dma.h b/include/linux/blk-mq-dma.h
index c26a01aeae006..6c55f5e585116 100644
--- a/include/linux/blk-mq-dma.h
+++ b/include/linux/blk-mq-dma.h
@@ -48,12 +48,16 @@ static inline bool blk_rq_dma_map_coalesce(struct dma_iova_state *state)
 static inline bool blk_rq_dma_unmap(struct request *req, struct device *dma_dev,
 		struct dma_iova_state *state, size_t mapped_len)
 {
+	unsigned int attrs = 0;
+
 	if (req->cmd_flags & REQ_P2PDMA)
 		return true;
 
 	if (dma_use_iova(state)) {
+		if (req->cmd_flags & REQ_MMIO)
+			attrs = DMA_ATTR_MMIO;
 		dma_iova_destroy(dma_dev, state, mapped_len, rq_dma_dir(req),
-				 0);
+				 attrs);
 		return true;
 	}
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 09b99d52fd365..283058bcb5b14 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -387,6 +387,7 @@ enum req_flag_bits {
 	__REQ_FS_PRIVATE,	/* for file system (submitter) use */
 	__REQ_ATOMIC,		/* for atomic write operations */
 	__REQ_P2PDMA,		/* contains P2P DMA pages */
+	__REQ_MMIO,		/* contains MMIO memory */
 	/*
 	 * Command specific flags, keep last:
 	 */
@@ -420,6 +421,7 @@ enum req_flag_bits {
 #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
 #define REQ_ATOMIC	(__force blk_opf_t)(1ULL << __REQ_ATOMIC)
 #define REQ_P2PDMA	(__force blk_opf_t)(1ULL << __REQ_P2PDMA)
+#define REQ_MMIO	(__force blk_opf_t)(1ULL << __REQ_MMIO)
 
 #define REQ_NOUNMAP	(__force blk_opf_t)(1ULL << __REQ_NOUNMAP)
 
-- 
2.51.0


