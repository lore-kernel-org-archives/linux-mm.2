Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE5CA606A337
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 02:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b9ngfcOS
Received: by kanga.kvack.org (Postfix)
	id 15B0F6B031E; Thu, 22 Oct 2026 22:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BCE26B0321; Thu, 22 Oct 2026 22:45:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEEB06B0323; Thu, 22 Oct 2026 22:45:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF0056B031E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:45:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3DDE3120154
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:45:54 +0000 (UTC)
X-FDA: 85352351028.16.68090C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9F66CA0009
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:45:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9ngfcOS;
	spf=pass (imf15.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792723552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EChwTQ/BOLQr1g03ftMuDlTlHMg8QkSEgwBc0qrp/YE=;
	b=4n6PAdcf3DqNg90nEiTfIOBajAprUXiM0YTKBQdhS88ldp3H1sfjQRYZfdlSO3rGKJFzZ7
	Vo7mELTVa/mOw3sENh+UC6Pp9y26oeguNMNeA/vKc4RqErJlYwbz01J7dt7l5UzRHCgta6
	4wTBEwuI6MnTInAe8gfiOHeq3xcfyVI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9ngfcOS;
	spf=pass (imf15.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792723552;
	b=N6zgXZvWHxairPgLP4un3/piKpTCRhwcUcg9Gb5JBVYaV99qZCJzmL8EYsUK5YPtpbH1/F
	KYux20+1a3hApmM6bSfCITWAq318DZWQusAmw7s0iUVwEo2P5Iaie5C7rEFw477SrxrIan
	cPVYBkRzsaRhhjzA2Fi+u6bNuF2veXM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F0B843F8B;
	Fri, 23 Oct 2026 02:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5151F01825;
	Fri, 23 Oct 2026 02:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792723551;
	bh=EChwTQ/BOLQr1g03ftMuDlTlHMg8QkSEgwBc0qrp/YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b9ngfcOSCrXa0gUiYxpzl/xSX0WV3YUeZYQTe4WoAdp1pmTRv5o9Zh5nso7HOmKrh
	 xs8zLoDIvejBesgyW14q/YXCuZ2c7It95Hp0AZwuMZWz97QLg7HStud1leTLXsrT9F
	 J5jIAMrzF3MTcCQFsaq0QP+ccFWQe7U+P3q6hBodL4VCXLzjb9lVERmiaRpdX5nk1u
	 vXFwQcQb6Ga2mzOSw+XiIg4nZTw0dCmgZH2Ff9TZ3mGaGb4Ibdy8zVM5q6So1/0Mi4
	 0DiRCfEPdADoa3pQN9P1oLHC8yz7TqKiWsRcdTf6ggb8gRPiuAMZIfj6+jjASsvYn6
	 nwkdjpK+deB/w==
From: Mike Snitzer <snitzer@kernel.org>
To: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>
Cc: linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v8 1/7] NFSD: cut a misaligned direct-mode WRITE at the mapping's smallest folio
Date: Thu, 22 Oct 2026 22:45:42 -0400
Message-ID: <20261023024548.71123-2-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261023024548.71123-1-snitzer@kernel.org>
References: <20261023024548.71123-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9F66CA0009
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zf5h55boq7shf47e6si5fp5wpan6zr1g
X-HE-Tag: 1792723552-475913
X-HE-Meta: U2FsdGVkX1/egp0HE/JpC9o8D7Rv/5ebhgbbXsZy+BB7lkmJ9z5sVuIACUiedoy38h80J+XXRIOmb0HreaP47KNjKxuDMKrxhs9I316aA+t5q0SAGQXPnXI5Tu7XPTtXqdI/rmZ27wHxI1f3r1HAY3RCdtJiBf0cxFOI1S0yG1pHoRpzW1WixaUHCho+3qTfY62JcVvzyFqmafgb5GloFTMX13h2ynMAqd4l4sPMcpy2UoFQl6BkjzaMUEc0kjPL6Gn27/Jzxojxzd2FLrORdK4aXFn80dEpaUh5aQCjvvIh+x2KhfHRwp/TYpbmUEZbsOr/Y4IgmOLkncd+OlglQxUIE2TNdsTJPf5kDRPY3u7WDXSvnB6caRKK56K/Uz4Rv1cOCa8WYBbPPLNdGm4lHg8epJChLw3JYE/2poR7TCC0Gf8rKjkA+xo3j5PU4S5SkTxaJnFPRscsSWxALL5XhBSw1esdmQZ8DhQiu2bC9nG7dcSV9/1NetZsHU+Xw9FtcTG4yObTPojFwp/xFgq5v4SlZZXir6AksI29oTXG3fAVaAERCuEL8OkzATocie38gU2+bTZnzqcFnH2oHzDAmywP0UMoCkrNCB1HKxjmjDKd8WHTcAcQRGWuuNCjA3ETr3ked9mwNThj9hlMKqTY+v8n5JsB2cZRO/ZZRXg23zytVea3n4bodW4O+XiOj3n44otlPvvF7eG/NSIL67cBPC+9vAyoIHTP/Btifz0L1mh9vBsQdcO3WvFyP5hjwh8th1X5MD8QNLNgHstZTPckSuLgIvBMUp3UjCwWQLEtonqO4txMGy4Ask9rBRoKX+8hr1rPVtPysX1ASaDJgHKuA53wiXNgSnJMpimh1okbOFxj2xHIiXOTGrm1QFYuJVwRtQhrROMa5rlT+kyjCUgV6wx5pGmc7obAuQqwysYaa3nM3Kr83Ey5IumChLd+RdekYMz4pmFsG/0DZIWObXn
 GmcuW2/w
 d3ACeNYP2XyYq5io9uuD1NC4KUXxOwDATPc6F2sR2eGTdeMwpgCshaemmG5C+nkOZtZkr1efFWeRA5apncsvNVGpmPf28xiSQsbxGGMGU7Y0r9PIWHVT3CGtZ2v3Y+d8RVC6sBD0Xe1NkRGMnj/tussBDuh6tkvti4S5x6+q2OhCJE8XtRaSluOwTk2F7afcrqvg5PKXm1l52ff4OrGHqt2VyLV8oUyjtFCu8Kq2by0R90KoLl9CNVQYmueje8wGNWIRzV885HYmrYu0rallBpsz1t+Am8wwaV/JfLl/Ky5Yv0UInLhkRuRKLig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

nfsd_write_dio_iters_init() cuts a misaligned end of a direct-mode
WRITE at a multiple of the larger of offset_align and PAGE_SIZE, so
that the direct middle, which invalidates the page cache over its
range, never shares a page with a buffered end.  But where the
mapping's minimum folio order makes the smallest folio a block larger
than a page, the page cache holds that block as one folio: an end cut
on a page boundary inside a block leaves the middle and the buffered
end in the same folio.  The middle's invalidation then drops the folio
the end wrote, and whichever of the two neighbouring WRITEs comes second
reads the block back.

Cut a misaligned end at a multiple of the smallest folio the mapping
allows as well.  Where that is a page, nothing changes.

Fixes: 80728157d1bd ("NFSD: cut a misaligned direct-mode WRITE at page boundaries")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 fs/nfsd/vfs.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 9219f8eb386d..ade00dabef18 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1452,13 +1452,15 @@ nfsd_write_dio_iters_init(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	/*
 	 * The direct middle invalidates the page cache over its range, so it
-	 * must not share a page with a buffered end.  An aligned end needs no
-	 * buffered segment; a misaligned one is cut on a page boundary even
-	 * where the offset alignment is finer than a page.  A WRITE may end
-	 * at OFFSET_MAX, so the prefix is sized as a distance rather than
-	 * by rounding @offset up, which could wrap.
+	 * must not share a folio with a buffered end.  An aligned end needs no
+	 * buffered segment; a misaligned one is cut on a boundary of the
+	 * smallest folio the mapping allows, a page or, where the block is
+	 * larger, a block, even where the offset alignment is finer.  A WRITE
+	 * may end at OFFSET_MAX, so the prefix is sized as a distance rather
+	 * than by rounding @offset up, which could wrap.
 	 */
-	cut = max_t(u32, offset_align, PAGE_SIZE);
+	cut = max3(offset_align, PAGE_SIZE,
+		   mapping_min_folio_nrbytes(nf->nf_file->f_mapping));
 	prefix_end = offset;
 	if (!IS_ALIGNED(offset, offset_align))
 		prefix_end += min_t(loff_t, cut - (offset & (cut - 1)), total);
-- 
2.52.0


