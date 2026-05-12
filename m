Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F146CD484E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9A836B0092; Tue, 12 May 2026 01:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71A56B00A2; Tue, 12 May 2026 01:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AE186B00A3; Tue, 12 May 2026 01:37:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A56A6B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:37:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39014120398
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:37:36 +0000 (UTC)
X-FDA: 84757660512.09.08F75CD
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id 966F220011
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:37:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=T+9tuwEe;
	spf=none (imf03.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778564254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNG6f/qsobCnQrMhBOENN8KDFhS7LUQniOJgelpzd6g=;
	b=gjaHY6zHufX67SYPOICOysd4ef1aXJFXW07Q7Ijp38L3aj1/HDbjGMXKyYd+w5tT1iWtYC
	bkTL53HevaEQX5Bf9HH5GyiBNaqfkx6vD/NfUqv+KrNMZqkL1RYdhwuhsFo22iGDsjfCVa
	tcbAyM3yU5HLkleXhHeiT/ctSzPH/kc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778564254; a=rsa-sha256;
	cv=none;
	b=dMf5uwLWmfRjpFnR5p+UGvSN+AlBRU1z+8gkHlDlPpThhfNXPsdA9ZXJOLbbs9OXghH/MR
	pwzOF2psv9VcbpXntUPyuaVGdwgrXDhDbugA5MGflJvzvJYr1q0ZKb0SYv1kKGA9BZTvjE
	X6xCj3D1DM12dIOpzAPCDFOm85dGkBM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=T+9tuwEe;
	spf=none (imf03.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GNG6f/qsobCnQrMhBOENN8KDFhS7LUQniOJgelpzd6g=; b=T+9tuwEeXC5tQgcpvWKYfuq6Ar
	uKkEDYS0He1n12AYyubbJb1pKFwP0d0egx+o3zSlEHg33Z+uNrYMplMAd1fCjYcVjBidd1n34L8DK
	yofO+zJRzWIbLRHqeLst7TRdnMK1aRDpYTT0iIQ6IIOy6TBzDn6JFvcDscaBZdLTC1OsW2eOjm3YW
	EFb1C3k0vinDbZ33FIm1eb3PLLRF4xxvmFXprvKiBggk5QgqvmIOvXvpsL8EgCQV8IL6Xkdfigr9F
	zwHZAG0Q/JdYvWqG+ejmLyrFHsg1w1ZB6VSHKa4nxK61Ndh02jSbtEK//PKZzbVyiFuzG30kwk7vc
	Bah3mVQg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfo6-0000000FfOs-3Cda;
	Tue, 12 May 2026 05:37:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong " <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH 07/12] swap,block: limit swap file size to device size
Date: Tue, 12 May 2026 07:35:23 +0200
Message-ID: <20260512053625.2950900-8-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512053625.2950900-1-hch@lst.de>
References: <20260512053625.2950900-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 966F220011
X-Rspam-User: 
X-Stat-Signature: bk6mwkkpepaukjn1ceyfp1by8ndbsrc5
X-HE-Tag: 1778564254-889279
X-HE-Meta: U2FsdGVkX1/hS/0vruKxQlgs7GoQtIax2yd+MPXqkziTctLhBPIvZZ8Qokkks1dBZCQKJeEwbWqW3tl29iTxKbax4pdna3fBe9AkAxRQOv/XB4ro1Q5y98MU92DlvwNPPBLKe3zx0xTl8ryFo/lXBPHHt4lpmFDTPnpiDifbCF8zue/fL6G+YgAjpgOlJQhUcCJyX9rw1F0hoQFEojFk048m1AZi/IhOcUMLe1hwwAc8QvFluj7nCAQXKAIb32F8bqCF/fwbcBDWrIZIyDEjmzk1gVwoqL73YzcbNZq62ZDMs57WLQRUkFjiBlKfLU/BrMqvcgw2yVT/mSJKf1ZkqiFsoZwRVzrHjF23HXPpszh9EZrAQh0b0FMY2m8QSJnGDCk+iDcey/OKtRdR4S3S76J/nQ3aG5HUdHe1BVIb3jr5zJzAkmS7pMR/YfmZBOUFHmCA3Hg4xIYq/oTbZh1pboB1YCESHP9pxvRm0oCalMW0VVrNnxfoWYpZlI/J/EZeAT19ueXHxbwgiHG7UizoLaOVh7hRjVjbYfHildrihmoKhUJF+52Nt12Uf/EpL0wtCs5zKIE0rZpp36eeEOivmI/rKf0B7yWkPi1q8ut/gS7N5xeD7RLtsMDRFlhtFuJsI3VB92iv2Fccfs1WROsfbiMI95C+d6gY+gLtoyJU5GqlhuInc1mO9Gyhjsrtwa3Hba+yfMS0n7JW24z9BXXZMoIR43tWdIKq/NthntI1y2Ip0C7kCUSq3SDY5pgd9u4SvhiATYWI8NZL95oIskLyS7Fa5V/NKKJg9UuxhkLtbK4WzOaO2OBBlLKQPG75VeNleWwMsWeiqvpcn8d1Zymsqqxqfr1N9LeKBKztIrkui4jZvBFdPf+BaUknUvD9NpomjaFJdcJO9YbDqLZSwDvhOikYphIBhbXGCmNJO6bo+MANZzUC0J5oUpwuxty8G/w4dHdstX629RQr5sniFxU
 +Kakj9FF
 2U8zlttIYX3LQiSWdmKi/kMkPp6R0WoLMLtSd3vb0k2wsM89vPnAC7qUet+ZUCkZPdeO29p+2LrWcoblituejM3JGhnFDenYNftCjFzd1rwpQDOqMSwZVIX0OhtZ84UFXKbS1hmpeP/0mHvisTk1qyB32jygmioEm5BcFAuyeK8fwNm4ykJrAKBWQSeTTqDxwPysu7zroNaXv3SEUqKJI59FYrmLYaUEqd5RFy5u7XmYRN8W0FG5I0lxZ1HR64rs5U1P50ZO876TLIkjIlRKNPcDN3Ypbn36ldY+0lwVFEw4XqMmIUuIQ4+qatEd4dUeudShq+vhuuLwYmu1/l3k3NnK3xgNU1re0jFT1oBSzKAsn+JpDAkj1DiPaS8lI/K1HICojr3Ca9EqRpQOrreehvZ07Ouk2sl7j+pS73lgzsqnhowdV7omvfAhQ1DVaZbwolOcuwbZY9jiin2MShzNyGzl1+jv2zt9dC0wkdxCRZtrarabfR5BmkyNc4OPhwOzlro+99mDuRiP7hREGuVrPFNAY3s89ZcFIBq621cO+aR5WrF1C/VlZANTmQKYH7xSaNqXsvUfuFA1F6udGu9E4o9FzMUWz6ZUVH0Fia2EKXA8Hyyu/fSkBcaAW/zGlPxC6rZfe+WHAB7VUYppPuMl0dBbTvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Don't blindly pass the value from the swap header to swap_add_extent,
but instead the device size rounded down to page granularity.  This
activated the sanity checking in the core code that catches a too large
value in the swap header.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/fops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 453141801684..067e46299666 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -951,7 +951,9 @@ static int blkdev_mmap_prepare(struct vm_area_desc *desc)
 
 static int blkdev_swap_activate(struct file *file, struct swap_info_struct *sis)
 {
-	return add_swap_extent(sis, sis->max, 0);
+	loff_t isize = i_size_read(bdev_file_inode(file));
+
+	return add_swap_extent(sis, div_u64(isize, PAGE_SIZE), 0);
 }
 
 const struct file_operations def_blk_fops = {
-- 
2.53.0


