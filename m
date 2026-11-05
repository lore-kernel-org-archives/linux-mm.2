Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97DFC606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 07:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bqq0QLYN
Received: by kanga.kvack.org (Postfix)
	id B173F6B05B9; Thu,  5 Nov 2026 02:00:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEEDA6B05BA; Thu,  5 Nov 2026 02:00:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2C4A6B05BC; Thu,  5 Nov 2026 02:00:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F85A6B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:00:25 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 157C080947
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:00:25 +0000 (UTC)
X-FDA: 85400166810.13.F769700
Received: from mta1.migadu.com (out-45.mta1.migadu.com [95.215.58.45])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3B48D1A0002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:00:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bqq0QLYN;
	spf=pass (imf19.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 95.215.58.45 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793862023;
	b=SCW1Ram9TU262reZI2R72r78QPuisC6aegF56D2en/ccdesdDP9a3jMw8MU/wOm2yR7jDS
	W3tAIhKGZObZxzaYhgWHMn53mTcUrvkfZAiUpKVIeRZDMq1ZJ1Z7K17OqgazkslMaoCnDK
	mktCHnoVXTWeJ2TayFLi1RdPwg3X6qM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bqq0QLYN;
	spf=pass (imf19.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 95.215.58.45 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793862023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kx5WUkjnErrix8wXibd1Wzcuh2GC05qD7z4XDKSCne4=;
	b=fUfYsSZg2PAAGxQcQYDQl7mzLvJg9XHbcuvBjFe7wiiPJzogbu+JwjCwUqlHDKu+QxXEnq
	ad8Yas40bPh3JNk1tdxQBywln1i933iUqgtInN7Y2l//Dtnna/IsBmkQK6SYRUM2kHwKVO
	NfYewPCBan5RNXx1h/Tv4/jt+vVUJpo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=J78YU5ZFO0YkJHWe7jsk/frJ8JTGoObKjxZIdpWIbcM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793862022; v=1; x=1794466822;
 b=bqq0QLYNJgSrNg4Mtl4lIyx+/e9AOQOf9rrOdXfVedOC8kgVg+KBBI7UvZUR+t0h+HgG3Xn2
 Bp5kuOr6YC3Uya9F5fKHFtfITpNqMgDY+F0trZKzK205rWe4dC3/S8f5NsPFCKGjHrBBjDeK64g
 5ckthAxzxy7QRIaCfwkifE3w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 56e7aac47ff0582e;
	Thu, 05 Nov 2026 07:00:19 +0000
X-Mizu-Trace-ID: 56e7aac47ff0582e
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
Subject: [RFC 5/6] iomap: refuse dmabuf iterators on contents-encrypted inodes
Date: Thu,  5 Nov 2026 14:58:46 +0800
Message-ID: <20261105065847.196540-6-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3B48D1A0002
X-Stat-Signature: cu5gj7bz6aimb635pjbum3o43cx8hnbf
X-Rspam-User: 
X-HE-Tag: 1793862022-772628
X-HE-Meta: U2FsdGVkX1/3HAw0JygmiEFnP7gZiKs8QszVhAqFVz5yFFO2Tmny0KwczZcV1ivZEM1V3AjqWcrxLatukZHIv0n0k8/XOKc0w0t7dk6kBP5IhIRTkSnuOfGCFnoB0X8ChHyrXgIRsQiDT2fAbKU9ZJeq31ybFbLIs0Y9Wny+X+V4OR75gM2cT8/wzS5W+MqBuwh0z4gmTrrS1uhntF4wAGtphZ5pIAqn0Z6k47KrBUnTnSBszPRv2xBANdKfyGuzCWmlx38950ie7MssuA4enTVhZF04AdDlRU6hXlJgtFZ02rasrk+gqAJ25oOyjkuYo5+P/PLHGZhelhcTdHn/Hl25Y43NorBgScvHU46eYWlBV1/6dwAIt6KVxvw9hpjjSl9X83X4hl4Xu7UIJv8PY4HpTNNgbqH2+VyA/OHv7mDWZoTVBGvbEpJZ/Av60ykW7EP1641wQzuHelmy7goYxBybmyrOM4RFLBIezIg+kglYRSfI9Iy+FH8YRt0gepkKS/yFVqr5nrYEIaZkMY3+Xpmi0S3TvGzpdiJORtszK8a3FnfOYWpAiKUhws8nM8KmeAOvK5wyqgxWPd/67DFK7kJKSRfNHRKGpuUT5+Zj9xpqhVyfmrDFnZPA/l9M46MQpBdMynmaACPxpHrcUKltcOEMLOfuswX6elVGXhoIZUP3lU+WV5KT3Uctyy1TPBJAR6VsJLIfIE/Y+S4/5mDqoIHsF2CamJQOLMSEvbEognv/GI3ZfLwOAeHW+dALxmBEf/dhvg7FrwcXOOJybDFVxwt199j88dKQY3NghNr27NLLEI35XBC6yVoPdz6IOB4t/UBJq0grDNpGsK31EFUr94TOFrTpLAjsY/fTx8KSl70JnpG6Q7ajwP4E17jmh18+VAhkCiKLmmQFeBeC7SUIMjOC7x7qfqrOU6WYpOw1V0lWSVq5d8jdITZZKiX9VK9IDCwfMj9glTlQjVWGvDj
 X+TS3CvK
 uC24hCzccKOmAB+RslAUKwN3mnC/9jsiujRTH8y/r8/LiYoqgOF74KXrGSAU1w283O8OBkEWB6K4vPGIwlIn+dWdQYbAOLxfAQvma4tkFRJCJbtJcyh2EumNWqgL1WN6tsCeR0ljH2vZ4agagvnHPj7Hge3R/Mwx/ZAJQSmhNElCjZaECT++uwhE9NgDwiGDNp6npdKSlC5W6FmW4xy55pj8zQvUoqvXF/JYioT3jcxoelwbC3ir23j5wmzw6HV4rhaHsVjRXu1DlwOgNDvlVE5KC64/Ntr+ilZegwFvr53Ymp7M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>

Contents encryption needs the crypto layer to reach the data pages of
the bio: blk-crypto_fallback kmaps and memcpys them, which a device
mapping does not allow.  Refuse the iterator in __iomap_dio_rw()
before any bio is submitted instead of depending on each filesystem
to keep dmabuf away from encrypted inodes, and in
iomap_file_init_dma_buf_io_ctx() so that registration on an encrypted
file fails up front.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 fs/iomap/direct-io.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index fc40f4367ee7..aec47b70b084 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -728,6 +728,14 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (iov_iter_is_dmabuf_map(iter) && (dio_flags & IOMAP_DIO_BOUNCE))
 		return ERR_PTR(-EOPNOTSUPP);
 
+	/*
+	 * Contents encryption walks the bio pages in the crypto layer, which
+	 * a dmabuf bio has none of.  Reject before any bio is submitted.
+	 */
+	if (iov_iter_is_dmabuf_map(iter) &&
+	    fscrypt_needs_contents_encryption(inode))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	dio = kmalloc_obj(*dio);
 	if (!dio)
 		return ERR_PTR(-ENOMEM);
@@ -940,6 +948,8 @@ int iomap_file_init_dma_buf_io_ctx(struct file *file, struct block_device *bdev,
 
 	if (IS_DAX(inode))
 		return -EOPNOTSUPP;
+	if (fscrypt_needs_contents_encryption(inode))
+		return -EOPNOTSUPP;
 	return bdev_init_dma_buf_io_ctx(file, bdev, ctx);
 }
 EXPORT_SYMBOL_GPL(iomap_file_init_dma_buf_io_ctx);
-- 
2.43.0


