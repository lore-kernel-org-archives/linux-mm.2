Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEF17CD3421
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 16:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DBFF8E0017; Wed, 12 Nov 2025 11:21:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B4398E0002; Wed, 12 Nov 2025 11:21:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0C888E0017; Wed, 12 Nov 2025 11:21:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA5E88E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:21:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 841CDBA1FB
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 16:21:00 +0000 (UTC)
X-FDA: 84102469080.24.B25DB7C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 874CB180014
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 16:20:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="DL1I9bO/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762964458; a=rsa-sha256;
	cv=none;
	b=qVhz+vp2bdJJefhW6rtNe7GUn9XOwCx3orEMkYMESyE9Dtvn2iy12vmTL4CY7czZXjEtvr
	jpw552QwXymJP3JKDHG1HvekrpCcqwN3VMaa4wDTm3arc9zxnUBltwSWFyl0oTeRWd4QXs
	2huWrwd4sulDqFP0Z4YtXDabZYtq7HM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="DL1I9bO/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762964458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pPwwIGYHC4Dhy1iXifP/JCcRpWQFWOK53tLj1FF2Wv8=;
	b=kM5Y7UQMGFTpczlNXT25zWF5yUBQS8BKslZ6F+qjhuzFiegGR9mdjFARhSzdUqQKvem54V
	j0+2OTr0Xp6SdbQvZ1ZrGHIdbXq1/lU4U2+MUS+WCyjJzUDqZr4qcGNgm5Zd46CADE32LK
	5bs81z9DuN60iqMX4F2z7dbL9F9BOt4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762964457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pPwwIGYHC4Dhy1iXifP/JCcRpWQFWOK53tLj1FF2Wv8=;
	b=DL1I9bO//Q5ycwdvYvWwzAKgkJq8mc4NruE7PR/2NMwp8hBvOVAUTHf5efxrEYEennBgB9
	btdJxd1pyzvlgl7if9PR0dLa7j0Gv1D/PU8PRKy//cJPIBrCooEhuoJw2QldzGiRI3W1GI
	T8D7SGrUdPVDVPTPDgqUPB0hbu/3vW8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-2DhznRZVOAiyc_tl3KBIwg-1; Wed,
 12 Nov 2025 11:20:54 -0500
X-MC-Unique: 2DhznRZVOAiyc_tl3KBIwg-1
X-Mimecast-MFC-AGG-ID: 2DhznRZVOAiyc_tl3KBIwg_1762964453
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B6C62180122B;
	Wed, 12 Nov 2025 16:20:53 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.29])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EE68A1955F1A;
	Wed, 12 Nov 2025 16:20:52 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH v2 3/3] tmpfs: zero post-eof ranges on file extension
Date: Wed, 12 Nov 2025 11:25:22 -0500
Message-ID: <20251112162522.412295-4-bfoster@redhat.com>
In-Reply-To: <20251112162522.412295-1-bfoster@redhat.com>
References: <20251112162522.412295-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kr0jwzD_8DuqwWhPNLM1oucIMvMOkyeOnA-qM78oksk_1762964453
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 874CB180014
X-Rspamd-Server: rspam07
X-Stat-Signature: d5ccre87n3ae8hibhuqtkxwkrdnuowdg
X-Rspam-User: 
X-HE-Tag: 1762964458-331865
X-HE-Meta: U2FsdGVkX18cfsGh30C0YA4BrvVxokz3wLXuzaLIAlQ+zMIYLmzLffsn25ZHABldpdPfwTA+BNAjidOOYxClvSvP3vEfgBQJe1XIh/EetLRSkbXmbsNRltP0TrrGPjc3lGHrpO7rJcSaIoRLtFRjXz6kPr1l0yAIhp9bVY9s2kqnWDFcsvWmlca24bMcS+0f4mPC7/JSFyDwF87LwuwvXVr/prxcnSbwCj2WMr/PosVBZ/JmMWREoEJuNiJF7eW/gA4nPRVc59dStBLfJeTSJUoRXzS6bdgWPqTpkHmIZsxPBJxNJsApbIA8XRi/CHsdE3vKU2mqbD1BPBOCX9MzfwAmxIKUHYHp2WsbwjL+z8rBJknLvoqekxiG9LERsN+iOBnuakPI8XvpXdRCPskovFgwrcEoMx0S0+yL90TqNeKVuhHUL0v63KP4BaxubZe9nfnTUUM0Uh4xrPR/JyD6ctqUt5Rx7riFmiw+DZ27GhAjG4x6HFnXclA4VcJzji9UCTe3DL0HN+uso7hFveY21dxTsr30nYrvjRJqxPIHVY6C2121MjhXAHRGEBJay9U84KY/gTZsAZc7u1SpwfajJ0/1F8qCzJiExtTnwQqYnjnmSOfieoX+4bwa73sxmObq8OO1PP4Imkb5OxWhyj5pmlAFxAK9Pv1ff33CUFxjCjMZE8uP7gSEFGgbA8/zPXdndF4NT1NRS0iU1EMRP80tx0tYzSP1XQQifhCY5tfBi52AFbArGrxUkffWAkojxP4vubNNjPG1mjFZk8i2xCKsx+fEJEPscJWqizuhBRCoaapJR/5Jl+mQrVtQbYqzG51E0uRCQKJ5e/FyL0GCeBxs4feGkLgbjY7ZFcZg3ZcGJIBzK6cd1fVnuzV6Wnv8dpnnZoEn8lwc+OFNJUuPUlMOsNu0fWjFSS9AeygbHIR8XmKkiij6Nn7ZuPsV33ZZOeOo5kL/W0keUw7Wz1pQoWF
 1D9tV5U2
 HR9bV5d5LllRTtEdIAvDVdRwLT/7vKtBqJ9mtmEupB+Qw9joZIeDTyKMhr9LIrHnBWxfmqfs6ussjs9FaCg5HXTWqt5AAPtDp3CiuOokNiBLD2tlcHeAycc7zShzs/o4AD+mrD7ZkAbAc/On1pueoNSYFY3L1aA0jnCovlV5tc9K1l2fX/to2/qvGh9UoK1rwYJeI6LRM1wLvnNBGRTr0v5KFFktfY2T2GAL2eukshsd47kW2PLcxoqRuZPB+tC8yHGs/d5YL/T6NZK9PZLH8hDidsYLdoRcJ1R4E9RWddUx0/T0gCMcY52AjxEvvnirbaviTvzqg9IlgHIYXUDl3w28gGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

POSIX requires that "If the file size is increased, the extended area
shall appear as if it were zero-filled". It is possible to use mmap to
write past EOF and that data will become visible instead of zeroes. This
behavior is reproduced by fstests test generic/363.

Most traditional filesystems zero any post-eof portion of a folio at
writeback time or when the file size is extended by truncate or
extending writes. This ensures that the previously post-eof range of the
folio is zeroed before it is exposed to the file.

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
index 7925ced8a05d..a4aceb474377 100644
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
@@ -3512,6 +3586,8 @@ static ssize_t shmem_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ret = file_update_time(file);
 	if (ret)
 		goto unlock;
+	if (iocb->ki_pos > i_size_read(inode))
+		shmem_zero_eof(inode, iocb->ki_pos);
 	ret = generic_perform_write(iocb, from);
 unlock:
 	inode_unlock(inode);
@@ -3844,8 +3920,10 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
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


