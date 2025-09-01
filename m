Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60A63CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21DF8E008C; Mon,  1 Sep 2025 11:12:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAB378E0084; Mon,  1 Sep 2025 11:12:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973B48E008C; Mon,  1 Sep 2025 11:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8046C8E0084
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:12:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C2CDC08D5
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:12:15 +0000 (UTC)
X-FDA: 83841022230.26.003E408
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7E503A0012
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:12:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PtS2sCfF;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RkXi9jb8SbuESKxwWn0khRdBbK2P/CuDfx1yGIyBM6s=;
	b=MjaSNJNAmIxvCGSvs6pGl7X1fvtyzRtrxQUJx733SdhG1uoLbdSRq75lk3oVwIxAkrMSgV
	D648rOnbOnNahWXXGHyS8mmSk/py5nhpLi2Ac3+f3n8iSxPRfXCDLfX3s27NS6dieLEBtl
	6u+Di9vAzBIepePtlmF3xxpjFNb1HTg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PtS2sCfF;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739533; a=rsa-sha256;
	cv=none;
	b=ZXdcGOHd6E635YJFnyQPGY6cxbz9HNPap/chvSSk0uwl6qAHETPWEOXEPjZzDkAOAPgmqb
	fCosS3QRX4Lh3wDNM/ofLk8Pyf0+TbB4OQMrTkUGg9JdSj2OIWfc7LtuOBRjDNrPQBdkBE
	bJmvXscU7TCGVYXVEt1k4akaeQPvNew=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RkXi9jb8SbuESKxwWn0khRdBbK2P/CuDfx1yGIyBM6s=;
	b=PtS2sCfFexexcHWJKB+DYkzBbxvH3L098UesiW7fI26fCPrv34fvzvfnoSg/MzXopVqgD0
	emA+nDP5Oh8qHD1fItno7ay7dRuv3C2OpCTb+BFSI4GQPEo7JrOCFDfglwEacuyun7Mr2G
	PpPTDQsMgeNdy8eKg1RWRpzrIy6bqOI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-83-3PVjTBDCNyiukKZGpg4ObQ-1; Mon,
 01 Sep 2025 11:12:10 -0400
X-MC-Unique: 3PVjTBDCNyiukKZGpg4ObQ-1
X-Mimecast-MFC-AGG-ID: 3PVjTBDCNyiukKZGpg4ObQ_1756739525
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B577E1956089;
	Mon,  1 Sep 2025 15:12:04 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0AC2B18003FC;
	Mon,  1 Sep 2025 15:11:48 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Alex Dubov <oakad@yahoo.com>,
	Jesper Nilsson <jesper.nilsson@axis.com>,
	Lars Persson <lars.persson@axis.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 29/37] mmc: drop nth_page() usage within SG entry
Date: Mon,  1 Sep 2025 17:03:50 +0200
Message-ID: <20250901150359.867252-30-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7E503A0012
X-Stat-Signature: 3ujbkeoni3i1t9j3g5gx8tgf3yegjg4p
X-Rspam-User: 
X-HE-Tag: 1756739533-766727
X-HE-Meta: U2FsdGVkX1/AHfhEVj9E2hhunXrs8WAJNvQvRb0Aky4J72I+rRa7XFj15neGCAWFAB5gaH7zi06a0cnZUBv/KRiq9j1KNYMf7PvhFg1bdHVx4PSCEFIBCYUsT+RCorjkZZbAaSd/RrPJmXNprmaVJrjXB2VwQECuR46mId3l19Vbc0whkwEK1yTNUZXi8TEn4DLp1Q9mWc9yBqI1KKJzk2Nrve5+/oop84xyNc60lYOpCcvXj7rryF2jbZr7WPltxFf5GrJFd2AgZPPcPv4ChJDa84xvYJEsV2/h1Amc97Z9U+AIVGI73BwXstVOiYicSxZQ13C1oHs4xmgGouC4JB91AYpP1c4gLPJA97cYFTehvGCA3HfCZYmWuF6TVG0TCkg4IjfS1XshTlu1mNScDP5KtEFYetrmfMhU3F2fAX1NFTOYSA12NE2Y8vlOpIai0mJSLqZmNLKfkfFaTXk7juNmSkmNox1y3/W9dW+/q7g9zngYqGPZWJZnmShNjKEvmNHtxlQCQOpobXLLNVU8H+Rrx5vd+ub2HQ/V2/QKod65oMQJGqrgmzJMQMTJrsp0g5jjwCDm4eUpCBna2eEfCar/Fj9DxjRWguVNfFIlGaaJL4ev1HqhrIqRaTCacICJojbKun68qVVPFxX6pBppRQi/75YUZj4Eq70EoLxhSn8+RIz9tdvCuwweK6bBUjzIIpuiLE5nB0NHp8F20fpwSmkNSSLmm/E5BWP52xRAjlBa2IWyi0MjBCXE6QJT8lSq+H2D3bjlVwwkHI728nAzwdRoHdIzxRO7t0oTANQgnq8Xu7Ow+GP/z4I0uHqkSFpeJCjXkRJ3E0MQwtqw0mTt1tta/uPDuH+NJvNvH1IvWs/qYa0ubRxE6MHJgB/Q8x86PBnmQQRPi+gvbiqNquZPNosZKwL7JlXkbVIpLIGp7aL6NJfnhX93nG4dlOrwY9AXNlk3u7qa3HUctG6nplf
 3MKdpy4r
 8rnI3DwCd+EGJHxlg9k2wcDg1tyFMuv8kdKOGu+rpkFPYjn1xBNNZbNYUUjl5ZMS5fzvxUsQ8TghGRjsDei39c8yaFCMiRBZM86L7Pf8qdO9VGLaoc50siXqB88Mgmpfe4sznXwOfMc90PrjsmGWW2hfHdEleGi3R1yW/jNNpsMDH/ciEjYZoTJhazcqudhle+JrquIFonMDsYHc4M08pjzJ+noIIaZ9iiJrrl7Luy7wRF2nGmysM4LvroW9zS/zdLO/2MbmZto52lH9BxQPKUL5/Y+dbsD+OeRU6p2KgaaiqFF79Ws2QMc2gQRZUD/+zfl0qy4n+NTxahNfNaUGrnpCqNSgXqLEn4gxi2X5DZfYxSSvIufsMsGLEWM1RZ1RGtvvV9QB7GZlgm+1iBTxboAg31/7MdVjMsTsDirZSZfembBprXFZNoiflsh7xG4MLjFVXWfxGe/3yF3B9ia3KKl2pVRwAebxQ1sh9N7RT3w1AHwdoJA2b3J4lmvGz8egv+HYviaTf7fZD5O3eTWiBOrw66kHj8Dvp+sXJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Lars Persson <lars.persson@axis.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/mmc/host/tifm_sd.c    | 4 ++--
 drivers/mmc/host/usdhi6rol0.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index ac636efd911d3..2cd69c9e9571b 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -191,7 +191,7 @@ static void tifm_sd_transfer_data(struct tifm_sd *host)
 		}
 		off = sg[host->sg_pos].offset + host->block_pos;
 
-		pg = nth_page(sg_page(&sg[host->sg_pos]), off >> PAGE_SHIFT);
+		pg = sg_page(&sg[host->sg_pos]) + (off >> PAGE_SHIFT);
 		p_off = offset_in_page(off);
 		p_cnt = PAGE_SIZE - p_off;
 		p_cnt = min(p_cnt, cnt);
@@ -240,7 +240,7 @@ static void tifm_sd_bounce_block(struct tifm_sd *host, struct mmc_data *r_data)
 		}
 		off = sg[host->sg_pos].offset + host->block_pos;
 
-		pg = nth_page(sg_page(&sg[host->sg_pos]), off >> PAGE_SHIFT);
+		pg = sg_page(&sg[host->sg_pos]) + (off >> PAGE_SHIFT);
 		p_off = offset_in_page(off);
 		p_cnt = PAGE_SIZE - p_off;
 		p_cnt = min(p_cnt, cnt);
diff --git a/drivers/mmc/host/usdhi6rol0.c b/drivers/mmc/host/usdhi6rol0.c
index 85b49c07918b3..3bccf800339ba 100644
--- a/drivers/mmc/host/usdhi6rol0.c
+++ b/drivers/mmc/host/usdhi6rol0.c
@@ -323,7 +323,7 @@ static void usdhi6_blk_bounce(struct usdhi6_host *host,
 
 	host->head_pg.page	= host->pg.page;
 	host->head_pg.mapped	= host->pg.mapped;
-	host->pg.page		= nth_page(host->pg.page, 1);
+	host->pg.page		= host->pg.page + 1;
 	host->pg.mapped		= kmap(host->pg.page);
 
 	host->blk_page = host->bounce_buf;
@@ -503,7 +503,7 @@ static void usdhi6_sg_advance(struct usdhi6_host *host)
 	/* We cannot get here after crossing a page border */
 
 	/* Next page in the same SG */
-	host->pg.page = nth_page(sg_page(host->sg), host->page_idx);
+	host->pg.page = sg_page(host->sg) + host->page_idx;
 	host->pg.mapped = kmap(host->pg.page);
 	host->blk_page = host->pg.mapped;
 
-- 
2.50.1


