Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB437CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 324B78E001A; Tue,  2 Sep 2025 10:50:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D42D8E0016; Tue,  2 Sep 2025 10:50:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211468E001A; Tue,  2 Sep 2025 10:50:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 102808E0016
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:50:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D48591A020E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:50:04 +0000 (UTC)
X-FDA: 83844595128.07.B0446C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3DA8040014
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:50:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lkdauzdp;
	spf=pass (imf11.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756824603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBN6TymVGMKhXDzN9igdXoFGYHBR48aWHHpqoRKUgm4=;
	b=w9ok4cUwhLzb4IK/VMUXU+7L2iWQNZg53mLTYuGkwBzt+MxnjxbRyvm1tLlTX6LBujI5ry
	iqAcsW3zvZxtOao99PXw2GjD/70h/75l/lg4G0JD8MdHhIJGCKwja2SKelQT86TTNXgrCm
	dmYCChc5B/9sR/1QZWNLCRalfpUcmz4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lkdauzdp;
	spf=pass (imf11.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756824603; a=rsa-sha256;
	cv=none;
	b=qVWa7yBmhnzVbgd0nHAquVWS9QwqNOrmIR599L0TR8wAwWdKDWcQii3kORQ4Xa7XPjbAnx
	DiQpfs6yU2cN2mYrNFOhvB+PBxOkHkK9N/y8YMnLdKmeSpvEng77OdcrabLp/KJO5Fn6UU
	YSxSx4jwaOyRNJD/quPjaX6HjJDr14k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A6A641B36;
	Tue,  2 Sep 2025 14:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5010C4CEF5;
	Tue,  2 Sep 2025 14:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756824602;
	bh=ZBDCCXKOUbAW2GsG2jVC6suB2pwDgJLZN0OvrJL85zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkdauzdpN/SIpGSSfK8kLRUi86AA3+TOqmqD24ZnSor88UIrlGHjQsAmCWO6e2anl
	 K1lRyv4MmrXkJu2ofOy32MFwkshextQSVPwvtX4cA3dJRuVSZhM7Jx9KBi5eSNonrI
	 z4cGmqRTm+5StjFtRxvIwsoIxLa3y6W46EmimmukeeLvHkuxCFF2Vrt9w4OBWq+PE8
	 obKDUurvbMwMhMZ1bRG/wLIUXAqpLU+zCaTKDld6pT5B4hrYSp0DUwIX2ynJrtw+wC
	 fv6qY0+duowp3cuGhIqsRETMXtVLq780uF5XI7RuDfeie+OQAT9g3cPsIbtn3Lr6Ky
	 j7H6Q0F41/mKg==
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
Subject: [PATCH v5 14/16] block-dma: migrate to dma_map_phys instead of map_page
Date: Tue,  2 Sep 2025 17:48:51 +0300
Message-ID: <b6356fbc547963548f2d4f035fb2e85f9d83ff99.1756822782.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756822782.git.leon@kernel.org>
References: <cover.1756822782.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: udthxr3dozk8z18ug966c6c757axp9io
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DA8040014
X-Rspamd-Server: rspam01
X-HE-Tag: 1756824603-482196
X-HE-Meta: U2FsdGVkX18Ip5OZO256knKULv3KdBCtbFbSltSVmTJnzuGB4LUE4WTecUwm2s9txAmV8zExpWKNEYGsUToGCEqURuaYktH+s84Z5rzJAvPsKdde6PQPB8QmsDmHsb5fMB8RCXlg/L6WS8iVxPL+gM7Hr+uadM8JEa/4j5Cq3sRcnJkg4XNZQsl4y70vqc5fSCIdPpce4peScokDf7OSHWjbsEKZeVYeafWzQAxXjcbPksmPsZ4i/rwOLz6uN2dMDY8p8G62IZq+Noa1sB08jvd9W1Qk2/CnYxZR9OZswZ1A4I78IWaOEOnPwm7CqqpUXhPB9WZOgHqZSfwKAUzZpkwsylyWpVtbZHPh7xpN+XzttFGRhCv68MWyI/UWAUJVlewPPCmQlgxYHVPQmkL03vEpGp7XvHvdleRa1AdzQe/ocEaFUUkRrvd1VFPyEV2uTTQLnLgSz0mTzcA1SXQ50zeZ+DrD9OvXNSPkrvVPogMtbD9JBMjmtfvAr3rh88w+FtmWlrI9FsBlz6JKYSkiKSHVChZ13UQrryzQG2z3VMw5NDdVKnDcHnvFY99RWDnTMd3WPjXXoR3qAyVnB5vyoPDRhMKMyCGpNQ0CgHaPAU7u3LgMgWFqHpLHALmvm9zPYjrqpeuqW/03jD0CahuRPMeXCcQqAbNyK6cmHmYCCp/1DZys4Ou43DAzZdIBWgX54x3+O0kLHiYpvfFFOLkSJ0i1P+DQLRP3xNerrt1NKPLrOx5AInVM6WzxPi74IEfnc84xG0klaoDuAsjzXwlNcQ95YXSYPJ0a6CcygstCE9ulTiSj3KK/Pb954DS1DQlWjJOUkeWWrxf+E59q2nrTF6WZfU0XI459cLTaarQqcpYLtPQa3MMxRSrHke5cWVBsjyqavYrotiBvxY4qTATm6HnVRv4tlOIL//G8ysHAaaz+yXm5j1zo0ikHSxokSYhO5Vis83GBCDf3Wyz1Vh8
 u28kjgQo
 fTxSW702DOmNyxL4H3Zu7pPzPT5ZJ3K1ac37DOrpbgdc87Gjp/czkH1T94C/oY7lG2qJogvIsjQApz0fSd7Lel3nuubPUI3vSi+7Mv9OB7geSD5kRy8X1xDuNb5arVLvTmJfdT7mYtVqOhswf3tpP4oGrJauAAgOxYT4/04QsEVJ5M68nSSQovUU13lPNKvwS17j5EWNIAKvbIPx13Eeu60bSz0C7TVqMpagWpsmApmJnRciXy0A1ODrcBGi+xMiU5TiJ+4dqg7Ld/zmGQ6yDbwxYMgOR4DlbjYUCv118gL4kP5QQLJGxnLy8gTWU2cWdNROmq3iqM4vsBXUnDWZCxrv8VOhDGTwhZwhcOT3EOEJ4T3BgvBCsD+9ikg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

After introduction of dma_map_phys(), there is no need to convert
from physical address to struct page in order to map page. So let's
use it directly.

Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 block/blk-mq-dma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index ad283017caef..37e2142be4f7 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -87,8 +87,8 @@ static bool blk_dma_map_bus(struct blk_dma_iter *iter, struct phys_vec *vec)
 static bool blk_dma_map_direct(struct request *req, struct device *dma_dev,
 		struct blk_dma_iter *iter, struct phys_vec *vec)
 {
-	iter->addr = dma_map_page(dma_dev, phys_to_page(vec->paddr),
-			offset_in_page(vec->paddr), vec->len, rq_dma_dir(req));
+	iter->addr = dma_map_phys(dma_dev, vec->paddr, vec->len,
+			rq_dma_dir(req), 0);
 	if (dma_mapping_error(dma_dev, iter->addr)) {
 		iter->status = BLK_STS_RESOURCE;
 		return false;
-- 
2.50.1


