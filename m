Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAFFC606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 06:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=URJ69ifo
Received: by kanga.kvack.org (Postfix)
	id E99836B05B2; Thu,  5 Nov 2026 01:59:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E71E36B05B3; Thu,  5 Nov 2026 01:59:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D88656B05B4; Thu,  5 Nov 2026 01:59:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB5F76B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:59:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C5BAA1C4304
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:59:28 +0000 (UTC)
X-FDA: 85400164416.19.EBE5006
Received: from mta1.migadu.com (out-206.mta1.migadu.com [95.215.58.206])
	by imf03.hostedemail.com (Postfix) with ESMTP id BF49620005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:59:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=URJ69ifo;
	spf=pass (imf03.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 95.215.58.206 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793861967;
	b=5GK21D4nIDOGW/uvvow1jWB/NEasZ6hgRypWXfwSSGv3KTFd1u9edKanUHncBOnMco4tej
	IhTF6pG3F+Khe7IByORZ4RXuYxv0m7CKefrJPc39YUJbqJLhx4rtnkhBOLWWdSnphhXeUq
	bNEjdqG+hsZE79Pq5M0GMwiTaAumylU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=URJ69ifo;
	spf=pass (imf03.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 95.215.58.206 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793861967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nIzPxp67nycIcgpn1aR+9cX2c2A9Fk/9SrE7eGQSDVI=;
	b=N6ECCXLZ3XOrnbAvPtLLnynsTTVfgzslG8mMELhxU+qvayzW16KBg1RMe0UTwi+Dl0Xjj8
	1DXCQ/SFupZj9Lm1PcqxHGlUCofxnJ5vL2nUVgnvT02l3eL4QNVuz5+1sQMJldfmrfJcCu
	BtofZqzGw5kjd+/phU1ZXJIexEt0w98=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xVc3emtqQK3gdjiaDH2/ozjRn5r+zA/0E88efrFuawg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793861965; v=1; x=1794466765;
 b=URJ69ifo97ROruZ6pmwjXf0aKmSur7mh2uvlDandRG7mz4fCmrISF3oG8QPrDgE6EtbpnoLX
 DDOkrLFAjlHrjyterio5ErE9cY4DTjD2rrmzaqCHaS/HCXbs+pcE5kLsyhLVR0lxf7DWy2zDiJH
 ybQo4+FLjg9nVwpWWXkCsyjQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7015cdc676c618de;
	Thu, 05 Nov 2026 06:59:25 +0000
X-Mizu-Trace-ID: 7015cdc676c618de
X-Migadu-Flow: FLOW_OUT
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
To: Jens Axboe <axboe@kernel.dk>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	asml.silence@gmail.com,
	hch@lst.de,
	Anuj Gupta <anuj1072538@gmail.com>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Li Wang <liwang@kylinos.cn>
Subject: [RFC 1/6] block: refuse a dma-buf bio that carries a crypto context
Date: Thu,  5 Nov 2026 14:58:42 +0800
Message-ID: <20261105065847.196540-2-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: grcyfyy5nbr3pwe4h9iyhiicpdpmn4oo
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BF49620005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793861966-617050
X-HE-Meta: U2FsdGVkX19CPubn+69FY2rfZQYW74cMaCOdFjQNo2eWM4Yf26onAns0BpUhQMy23rtksiTxyDJggiTQzlowKFERSel5PW+zUUHsQ42Gz2wA1FxCBpeYB1MFQGkYUUtfkClPT0Oe6Mz0kykuEY30c3Kdati/l0wRrQpSPqGTzpo+3TLi5y4F4DM82DUI35BdnEPIwy0A8v5EtxqSq1/Dgxcz/vtRxdi5PwfQLZkOBy2CWbBdJZU/gb1m9lsDbS+azBJve/t1GTHt+pUAWomlM+QQlgMHvOabmqkP+E07prL8u2pYELWjSH2fs18US+se191+s6QQSOZqvK3YetkiHc2202aE5zHjIRzNpGXXftdSWmqIpZGPD5xx8C7v89NVuqqjvFlVdhl+hBz34XXUuQp9xRMkLx1Rj6qU+5cLG5P1/DTOn26WP+IM1MoiMi8/57NcMqvjd0SdHHXszuLsx6hytdwiQe2oUzZLugrLg0NT8CkYetSrQQ7sc/lsAtUPpL38BwKKfK4uY1NO7VCZkwO0N+UguvNsJtHGyibU5/iu5bVBLII0go4rqcexu1sXlMD2UcaUVHHPxyvLn9F5FHS8ML7zDh/HEiXYKHDL6lCx+CK7SwBRTn1LxVPq9O6kIE5joUsw/bhuPPRtVUovb1hAdS0R6xp7Yq4hg4N5m8Z47HnB8yz+spg4ACEXRcbXSFYE/yjHRzRGNPtzBywtyRGMJ7lY55pFcNLqkiLYqVA8ozTZ4DYUTftFiiEnQ3U6m4u2RX2gOxRO2Fwpsfp49eLy8uVBk1CIGdp37SBvxlsjoZhDZ8tfnT8hBYYRqgTw6fcjCQvqg/4fVURfaSwRkebd64U5knECaqfMzvwysWe6KIt3ZBAV8UfMQ2P/YMxFhP3zrPvJ5vnDs1vUwR2Wd+DoghYJjSmn1RWtQid5i4KyEUwCXCXz8TSyeT4vgBwFEezB9whJyqLtB4IXYud
 RQ3MozpR
 mOC3N2sjtdTqnodo3WGLv/kyzKcD61XMnM2E1+cCxEfGX5LWW06vZS2ccuIaHLj1/35VRw9eBBcJOMugNZfenKCpOThdS58jxD8Am67jZ25lVswrj1i1isfdrUGjjgfe/fA8lezuYxsF+s9AxRPUpxILa2qwb8eSsAzfk7FJ63Z1kfTVmXJ9sppzGkKyOmoh8vZmKcLvIls3oRmspzdxdaxhHBpw27HJwgFH/WQozLlaFKuGeXOqWuYXh5z0fWDM+bdFAOIlknoVqif5Pyb3ukj6g5adkKKJ3m4AgWUaX7aqQaLY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>

A dma-buf bio has no pages for the crypto layer to walk: the
software fallback would read the map as bio_vecs.  Refuse it in
blk_mq_submit_bio() before it can reach that path.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 block/blk-mq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index be5671966787..f0d978b1724f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3138,8 +3138,10 @@ void blk_mq_submit_bio(struct bio *bio)
 		goto queue_exit;
 	}
 
+	/* a dma-buf bio has no pages for integrity work or contents crypto */
 	if (unlikely(op_is_dmabuf(bio->bi_opf) &&
-		bdev_has_integrity_csum(bio->bi_bdev))) {
+	    (bdev_has_integrity_csum(bio->bi_bdev) ||
+	     bio_has_crypt_ctx(bio)))) {
 		bio_endio_status(bio, BLK_STS_NOTSUPP);
 		goto queue_exit;
 	}
-- 
2.43.0


