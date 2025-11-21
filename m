Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DF4ECFC28C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 15:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AEF16B0030; Fri, 21 Nov 2025 10:22:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 660FC6B008A; Fri, 21 Nov 2025 10:22:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54D796B008C; Fri, 21 Nov 2025 10:22:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 366D56B0030
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:22:57 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8FACB7284
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:22:56 +0000 (UTC)
X-FDA: 84134981952.16.C50246A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0C3F6180007
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:22:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fVo6nX9r;
	spf=pass (imf24.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763738575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rrqwUAdiTjVeigWf+Lqd94aLGIPRhy6PTfNHBFTOQK4=;
	b=Hm6KNpC33TywgNfkBttBkgXTNBKS15JrnFc+fEMBsMFbfCqXz+KAQsX7CRL409IWqbEXyx
	JOYaIl9TKh1NLmNzk5qQ+him6oUOpLHl6EaT5BNrkWwh2wsas3U6fgxXaCM3Cc2b4QK+S9
	rYurY6jkapQs4PWfqLyGME6UabgLQks=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fVo6nX9r;
	spf=pass (imf24.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763738575; a=rsa-sha256;
	cv=none;
	b=MmH8eM2H0Xrrr+3RarJMt8yLDAg817JcIHTSTaBgrKb4s5zVhZW64NWKGoBAXNjkuijEA8
	2r3TVa+7GJzf2YhxSJkcVZ/CEgJ0NWr7VMtAEruKgi1QAy7e8VKfp2rab96pYsaSWRzHSQ
	sHNE2MZbLCXlXKRX343L5isv12mZnME=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763738574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rrqwUAdiTjVeigWf+Lqd94aLGIPRhy6PTfNHBFTOQK4=;
	b=fVo6nX9rNyV31J61JU+stBOz/XGbFNfx7TF15zbGNOyN0UoeWJTkSL0xEAFedhRiil3rws
	nJSte0LjTwacF/UDdbZLMDQomzTtMd69dOs3niCEOppQatmehw1f2MSiInPMrlB9dj6UPY
	wExWiKp1Ne+jFIoFdkoVAisM38NZUfE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-538-a6X_AiQEM9KS3BN3lClAGA-1; Fri,
 21 Nov 2025 10:22:51 -0500
X-MC-Unique: a6X_AiQEM9KS3BN3lClAGA-1
X-Mimecast-MFC-AGG-ID: a6X_AiQEM9KS3BN3lClAGA_1763738570
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 516751954B11;
	Fri, 21 Nov 2025 15:22:50 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A8D2C180049F;
	Fri, 21 Nov 2025 15:22:49 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH v3 3/3] tmpfs: zero post-eof ranges on file extension
Date: Fri, 21 Nov 2025 10:22:46 -0500
Message-ID: <20251121152246.1023918-4-bfoster@redhat.com>
In-Reply-To: <20251121152246.1023918-1-bfoster@redhat.com>
References: <20251121152246.1023918-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dQbcpQYEvbhIGgP81cdPGR5EJ6kY5niUPGJ3y8yIw1c_1763738570
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0C3F6180007
X-Stat-Signature: dpw9hjaqwk53uwo87bffoazrsp1e8huw
X-Rspam-User: 
X-HE-Tag: 1763738574-777137
X-HE-Meta: U2FsdGVkX18Hn3mSUpmNvQOozqCCABcdnb6EAbz5LjBchxQvl9xo9yKY7VBM3h4O7voWbzuGA0q4IXzAyPK1kvBfo4RKAH/xi5DKo6s/Kd1FzxSQl02OwHo+6ibR9PkuqKpQoLFt7oImBwWOkgn7uiJl5GjF5/cDuRwSrOGNCuJztJFO26/LUp0pn21mG0qssaIIHW9GJSDBAEVtmGrBFe0oEbZYyAlAjb6ybvO5ctVPzIpHPM4YCnXMbuwqikQ5rAkO0t4uv4GR9L1+89wHiU7BvdM417vinh0bR+fBGa1Hkv8WHxRWocj9xs/fhxQpKtZXBlcB1B0zCgKa439/zWYj0N56iALUj7dy5OXbTH82jhrEuEZ/rQRJjo9dQq96SVbNAPsRx5SaGtXZBE7cqF79CDqR2oFKbu5IITV6R2emQha+kXCfWJUkcnKp7PesZY1RWDDi9dVGNhlkuZ7vBIokViKXnEBIjPinTYdLnQaTs0vczKVOstOXTkHgIAcrRfe2g26OrRgGaUGaplSSbj6jEi3nMQi0OLva7/znfEKcFiR/fQxzTkQjj553ktseIVU2eb/8u1dbvNl7kOYi8zcevr55X0WRHKcjnG+dK69vEshHUS9GMh9OZ+B630OQCAuZRtuQWYz48tBB1IpCd9B2V7Y/YvY/ECJ0LisDZ/Qww+shFDIYuGEfSKzr2h2QssnoQeBUDUEs2CIsl4Sh2RPTUg3qee9bmSfNy5lCOFoMCVqmPOlSb4tVWluH4iOOXU4USv7Z37OTkckRj2Hw1fVFS1douqT7fiUvSIJFSY6r+H6Ci3vVBwF2A//zCqn9YjwZxUO3IskMgpj0UepRHho4ziMyqTmLW0eYGvOQbJKmoLBkI3w7247384CKbf4ckM9xWiIMlLJgKFSJMTY+jgpMkOh/mttAwrvX96RzDXMSvoQNQbxr08t/CvSGsazm2WBz6lAQYP00jWy4fRR
 Iria05Rp
 dj+t+bCpk7md292BcJg2opXUN5VXy4YUR4rOGatxfxmL+LbRowuI5XyqICvRJOMT/Hhy1mCviiO5Pgj7AyrFL3+xMfDNVMqCDR4XGwQj4bAe8o6IqJCzC3v4J9Olm6uVTWXsGgJeZQRffKOMkPlzqNJQdD18IHLEz1UGHV4KAo4HnBkYpFSK140A7TgLtpd0pRN6fmzV9qGrvJ+5Y3/lZ0nFIDL/HhLfYv3GvUE32+mu4BVVum+7ygXpmcx0p3cOVD47K4Re2W8/9hpzCm6/tM1IaH37V645Qye3xAUMUCQZsh+tKlKveIhVV8QCyKTNj2gF2mzIB+wpTXJcqHcq97g64eQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

POSIX requires that "If the file size is increased, the extended
area shall appear as if it were zero-filled". It is possible to use
mmap to write past EOF and that data will become visible instead of
zeroes. This behavior is reproduced by fstests test generic/363.

Most traditional filesystems zero any post-eof portion of a folio at
writeback time or when the file size is extended by truncate or
extending writes. This ensures that the previously post-eof range of
the folio is zeroed before it is exposed to the file.

The tmpfs writeout path has been updated to zero post-eof folio
ranges similar to traditional writeback. This ensures post-eof
ranges are zeroed "on disk" and allows size extension zeroing to
skip over swap entries as they are already appropriately zeroed.

To that end, introduce a new zeroing helper for proper zeroing on
file extending operations. This looks up resident folios between the
original and new eof and for those that are uptodate, zeroes them
before the associated ranges are exposed to the file. This preserves
POSIX semantics and allows generic/363 to pass on tmpfs.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 mm/shmem.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 97ca2b3dd1b9..81dd2bfb0444 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1101,6 +1101,78 @@ static struct folio *shmem_get_partial_folio(struct inode *inode, pgoff_t index)
 	return folio;
 }
 
+/*
+ * Zero a post-EOF range about to be exposed by size extension. Zero from the
+ * current i_size through lend, the latter of which typically refers to the
+ * start offset of an extending operation. Skip swap entries because associated
+ * folios were zeroed at swapout time.
+ */
+static void shmem_zero_eof(struct inode *inode, loff_t lend)
+{
+	struct address_space *mapping = inode->i_mapping;
+	loff_t lstart = i_size_read(inode);
+	pgoff_t index = (lstart + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	pgoff_t end = lend >> PAGE_SHIFT;
+	struct folio_batch fbatch;
+	struct folio *folio;
+	int i;
+	bool same_folio = (lstart >> PAGE_SHIFT) == (lend >> PAGE_SHIFT);
+
+	folio = filemap_lock_folio(mapping, lstart >> PAGE_SHIFT);
+	if (!IS_ERR(folio)) {
+		same_folio = lend < folio_next_pos(folio);
+		index = folio_next_index(folio);
+
+		if (folio_test_uptodate(folio)) {
+			size_t from = offset_in_folio(folio, lstart);
+			size_t len = min_t(loff_t, folio_size(folio) - from,
+					   lend - lstart);
+
+			folio_zero_range(folio, from, len);
+		}
+
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+	if (!same_folio) {
+		folio = filemap_lock_folio(mapping, lend >> PAGE_SHIFT);
+		if (!IS_ERR(folio)) {
+			end = folio->index;
+
+			if (folio_test_uptodate(folio)) {
+				size_t len = lend - folio_pos(folio);
+				folio_zero_range(folio, 0, len);
+			}
+
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+	}
+
+	/*
+	 * Zero uptodate folios fully within the target range. Uptodate folios
+	 * beyond EOF are generally unexpected, but can exist if a larger
+	 * falloc'd and uptodate EOF folio is split.
+	 */
+	folio_batch_init(&fbatch);
+	while (index < end) {
+		if (!filemap_get_folios(mapping, &index, end - 1, &fbatch))
+			break;
+		for (i = 0; i < folio_batch_count(&fbatch); i++) {
+			folio = fbatch.folios[i];
+
+			folio_lock(folio);
+			if (folio_test_uptodate(folio) &&
+			    folio->mapping == mapping) {
+				folio_zero_segment(folio, 0, folio_size(folio));
+			}
+			folio_unlock(folio);
+		}
+		folio_batch_release(&fbatch);
+	}
+}
+
 /*
  * Remove range of pages and swap entries from page cache, and free them.
  * If !unfalloc, truncate or punch hole; if unfalloc, undo failed fallocate.
@@ -1331,6 +1403,8 @@ static int shmem_setattr(struct mnt_idmap *idmap,
 					oldsize, newsize);
 			if (error)
 				return error;
+			if (newsize > oldsize)
+				shmem_zero_eof(inode, newsize);
 			i_size_write(inode, newsize);
 			update_mtime = true;
 		} else {
@@ -3514,6 +3588,8 @@ static ssize_t shmem_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ret = file_update_time(file);
 	if (ret)
 		goto unlock;
+	if (iocb->ki_pos > i_size_read(inode))
+		shmem_zero_eof(inode, iocb->ki_pos);
 	ret = generic_perform_write(iocb, from);
 unlock:
 	inode_unlock(inode);
@@ -3846,8 +3922,10 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		cond_resched();
 	}
 
-	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size)
+	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size) {
+		shmem_zero_eof(inode, offset + len);
 		i_size_write(inode, offset + len);
+	}
 undone:
 	spin_lock(&inode->i_lock);
 	inode->i_private = NULL;
-- 
2.51.1


