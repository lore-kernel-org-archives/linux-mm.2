Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E435CCFA00
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 01:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C2568E0014; Sun,  2 Nov 2025 20:49:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924788E0002; Sun,  2 Nov 2025 20:49:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79E788E0014; Sun,  2 Nov 2025 20:49:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 51D438E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 20:49:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01BD9C09B2
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 01:49:04 +0000 (UTC)
X-FDA: 84067612650.20.1401291
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 671F51C0007
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 01:49:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=0jO2qfF1;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf21.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762134543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=PTZBR/+jGqho/1/sSKa8ur1ebiBadAeCs15kuUvuwgE=;
	b=F9bbjRbLmSgRhhmGOjYhmb0XRXDJtBPnJsqLlRqPmcfNNuqPtnXlJRZPycooj93pQD80BK
	EmgvXOM7EDcCZXhzGeT4j7+nNfAJF+l60zd5QSMKIsjLIrOE0WF9Om6K+Tnxbm6LGaBQgD
	BRqTBw9BpFVlCBaH3xt7D1JUOMMyAhI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762134543; a=rsa-sha256;
	cv=none;
	b=rdLfRySPNgrbIFQz9xwtYAuqLChp0Azybzq2DmUd4YiOfkN7YADJoQpyHsPWrqvyUFHLhA
	QbU1T0d7ScUAqKG6PnQA3Vp69GJqIuZ/n1xV9JIJyTJ9yXEqwprJDOZpNyKOrpbvaNXn0A
	6JPQiZAdc+mctZKmg09fYR3LLh0lztI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=0jO2qfF1;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf21.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E568660285;
	Mon,  3 Nov 2025 01:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA7AC4CEF7;
	Mon,  3 Nov 2025 01:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762134542;
	bh=x1IgnlFiUXcdST24tK9OU5r5GycL4oT2+MYVAJhQ4VM=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=0jO2qfF1seJHxkzTMbJwmBvhH3Ls+15J96j9CHQteL1mAetZLlJqjKUcdwxHE6YdL
	 QRjYTNVBq4jrm3J1jtiG7/sit9RUzxqphbB1fEGMlFC6+jwpgYB2HcQCA34xurEZSz
	 XnNdLPrNgSPaAACeSSVuEZpKsVAOtmOQ3FUCe9X4=
Subject: Patch "fs: factor out a direct_write_fallback helper" has been added to the 6.1-stable tree
To: adilger.kernel@dilger.ca,agruenba@redhat.com,akpm@linux-foundation.org,anna@kernel.org,axboe@kernel.dk,brauner@kernel.org,chao@kernel.org,djwong@kernel.org,dlemoal@kernel.org,gregkh@linuxfoundation.org,hare@suse.de,hch@infradead.org,hch@lst.de,idryomov@gmail.com,jaegeuk@kernel.org,jlayton@kernel.org,johannes.thumshirn@wdc.com,konishi.ryusuke@gmail.com,linux-f2fs-devel@lists.sourceforge.net,linux-mm@kvack.org,mcgrof@kernel.org,miklos@szeredi.hu,mngyadam@amazon.de,mszeredi@redhat.com,nagy@khwaternagy.com,trond.myklebust@hammerspace.com,tytso@mit.edu,viro@zeniv.linux.org.uk,willy@infradead.org,xiubli@redhat.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 03 Nov 2025 10:46:57 +0900
In-Reply-To: <20251021070353.96705-6-mngyadam@amazon.de>
Message-ID: <2025110357-margin-underhand-fea8@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspam-User: 
X-Rspamd-Queue-Id: 671F51C0007
X-Rspamd-Server: rspam02
X-Stat-Signature: ipmpnckww7a4ddw5topw5e6au1sy31he
X-HE-Tag: 1762134543-735785
X-HE-Meta: U2FsdGVkX185MPe2hnn2+Pxcol0g/tgvWeV+cfomgmiCzCnWXmciuxKDTHvtHcvoc4roDbIzppoq5gS+7qu59SrnzSKeW+nsooTzbLcEECtpNWa5wBwE/O07PXqasRUk7cNhrKgARG/DiwCjyy5GGPj2xfHC9FkRbYGMc0FT3foyYwS03bXQkPrSMkTRWPvKa6tNro2reEV/Hc/uNBeLcmBX02geKdSRn95xM+X2tgv5C+s4YR5Anbqv2e7FiP0IDC6Ygw1f6lQTVCSec3DweRS81yyZuYoQ+B5bKeMr1H0Hz+P7zlp9FRMnjm+F1m3B7K9trtXcnIkoT8n/rTXhCtZ6iV2TVL7U+vELJQR/Aapc4TUdG1V9kCLYBbw5RNHejUnepp8s1SWdcmNWXw/u8X8hWoRT1X8K9fmzOgrUyLdP4nJWIuxa8J5fzQbQIs4RX9nUbrEpV5nK4CRmZpvmumyUroWlT5gemom+sagSb5QIfA9FE9itWQQPZAcnv+TfikGR11VRTH1f6ymsTDt5Sv3XaQbPiCOJzT46TALnduodW8DoXXhKo5iKOlQiz00A+VwavIxcCvmHdcvkPThP++RfsB0/FiwaWjgdTH2A5eupSuoR+xaARfOdhoVZ6trmlbsuSoCaXJ7VOcTKCobXEAdOeLaaw02tZgZey2A5cFWMFYaTOkHKee5Naqg7rebWu+5iTcImUMfpd+5LgzXESkk3wRDjakWoy8tzsAuYuqDemOW+fdfA/2jjtH7SX4iT28KtoZRD+caegGamfrH21GhjYUy4HuRaac64BGFcLxzXG7g0DTdXrMwvpA1woU5ckXwqFWD2ai2x1CaGgL3YzrCM75HiGC4Hy3gytTRbd1qVFPhfaf/8ytlmbNVG4Fdfa+LHsRDv6XnCo4NAXXoBYX0cWoZg437oe9ic0cafsCVqqwzcIo9Nc0uuHhclqaFwXnwjrF+FFjc+60Yp8bR
 PtMOyQm3
 uiusVZB5fUAn6koG/Y4AzSB760T2txuSvTSH3YfBcR01sbKkss68MN210BL6Cb9ymMJDiKomO0UB9IiFzYow9R7xpRhy/BH2ktrmVJsxTZf/ZOxqOtp2OyBrC/uxXaf8eiC6fvpWsmySWh9//dKt+Nu70ptkwcZ1tYofYAY7YA36g64MzLJ+2Di5lwOWRRCvtNzSHPD04aSYoPR/uTM3quCOs2L4+TuOTLphj8tuC1O5KN7y7Y+2/hh+nLc5EoV060dQrKDKvsTB02Xv1xvgnrpnfwhmKfkci5qtC0n3WyKPMzKUtvnAGBqZo65qe0jzsF+GK0xrXtcSKxiYvIlKpdH7+3Dole+LoMm3QNhtMO/fnqjB4Y+Jz2NlkPs2zyV00BnLCcju281OWIBlOL98oS/qTuzE21ki3zFd5r4KzGPab/jomDMYJ2LZqHKr9rWvuGGyuCP1pixFg2kMQuDzz32ny60h8E7WeCXLwOo/1d+bUS6YIGh/nGmjCrVxMdCaYPwMdc0odSxYc4PfD6+F3NEtyjG49b0FxwrMJZODY5RpuUI2WPAyGA6ouBmWKKC96es3z0XSdFM0fho4XqUv59C9QS42IMLM5CIynrEZtXSBT2YZLHCDHyFO5khfva+hizeZ0wRo3l9VdA6Vng42rxFIEIltfhx/2DRcVILHGp36OYIBsEL40YlDypvkvG8N+xCMtExoBsbu8JNtk2MREayzQi9Sl61RK1O2dvtQ+YgA6g4vqiLHMSrJHywptvNuYgGgtJp6ycfd1nUNA5O5QhR+5mbYyWxH/jxokNK3Wz6OUXJRh+dHHXtYJBTNORdGagAlNsgdiOLfrg+auN+OxCgC5K6J/PCc3/ZBod8t/EqgncaUFJ2cXqBQMpwxzBMFVZXWOhBpkwBnVRLZ/AMn36Gwy1VBmUaCHd4WZoelyAzYJg1LseFJopDafklMDpi3bz5sBO8pCMnTnoIfq9zyeFD9G7l5N
 CQjYqLAH
 e3R5QWuIEusRdQnAGttFNzL6KOkq0ancPiDjV6ZAAb58dnNHk6tQL6bRJzL4yNoKsrp0OHrabsgmcTuv+xC9XM6VbM02gmnTeXM7NCxnYJATG5/5gkvvDpDmtxyJ2qhsfHCDQxD/R2LDbvy4aBBCXeCJvyGqZuSTLA7bVcdY68MIjBQ7W+22dQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    fs: factor out a direct_write_fallback helper

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     fs-factor-out-a-direct_write_fallback-helper.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-188299-greg=kroah.com@vger.kernel.org Tue Oct 21 16:17:20 2025
From: Mahmoud Adam <mngyadam@amazon.de>
Date: Tue, 21 Oct 2025 09:03:39 +0200
Subject: fs: factor out a direct_write_fallback helper
To: <stable@vger.kernel.org>
Cc: <gregkh@linuxfoundation.org>, <nagy@khwaternagy.com>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andreas Gruenbacher <agruenba@redhat.com>, "Anna Schumaker" <anna@kernel.org>, Chao Yu <chao@kernel.org>, Christian Brauner <brauner@kernel.org>, Hannes Reinecke <hare@suse.de>, Ilya Dryomov <idryomov@gmail.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, "Matthew Wilcox" <willy@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, "Theodore Ts'o" <tytso@mit.edu>, Trond Myklebust <trond.myklebust@hammerspace.com>, Xiubo Li <xiubli@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Jeff Layton" <jlayton@kernel.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@infradead.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Luis Chamberlain <mcgrof@kern
 el.org>,
  <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <ceph-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>, <linux-xfs@vger.kernel.org>, <linux-nfs@vger.kernel.org>, <linux-nilfs@vger.kernel.org>, <linux-mm@kvack.org>
Message-ID: <20251021070353.96705-6-mngyadam@amazon.de>

From: Christoph Hellwig <hch@lst.de>

commit 44fff0fa08ec5a6d9d5fb05443a36d854d0ece4d upstream.

Add a helper dealing with handling the syncing of a buffered write
fallback for direct I/O.

Link: https://lkml.kernel.org/r/20230601145904.1385409-10-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Miklos Szeredi <mszeredi@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[backing_dev_info still being used here. do small changes to the patch
to keep the out label. Which means replacing all returns to goto out.]
Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/libfs.c         |   41 +++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    2 +
 mm/filemap.c       |   61 ++++++++++++-----------------------------------------
 3 files changed, 57 insertions(+), 47 deletions(-)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1582,3 +1582,44 @@ bool inode_maybe_inc_iversion(struct ino
 	return true;
 }
 EXPORT_SYMBOL(inode_maybe_inc_iversion);
+
+ssize_t direct_write_fallback(struct kiocb *iocb, struct iov_iter *iter,
+		ssize_t direct_written, ssize_t buffered_written)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	loff_t pos = iocb->ki_pos - buffered_written;
+	loff_t end = iocb->ki_pos - 1;
+	int err;
+
+	/*
+	 * If the buffered write fallback returned an error, we want to return
+	 * the number of bytes which were written by direct I/O, or the error
+	 * code if that was zero.
+	 *
+	 * Note that this differs from normal direct-io semantics, which will
+	 * return -EFOO even if some bytes were written.
+	 */
+	if (unlikely(buffered_written < 0)) {
+		if (direct_written)
+			return direct_written;
+		return buffered_written;
+	}
+
+	/*
+	 * We need to ensure that the page cache pages are written to disk and
+	 * invalidated to preserve the expected O_DIRECT semantics.
+	 */
+	err = filemap_write_and_wait_range(mapping, pos, end);
+	if (err < 0) {
+		/*
+		 * We don't know how much we wrote, so just return the number of
+		 * bytes which were direct-written
+		 */
+		if (direct_written)
+			return direct_written;
+		return err;
+	}
+	invalidate_mapping_pages(mapping, pos >> PAGE_SHIFT, end >> PAGE_SHIFT);
+	return direct_written + buffered_written;
+}
+EXPORT_SYMBOL_GPL(direct_write_fallback);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3278,6 +3278,8 @@ extern ssize_t __generic_file_write_iter
 extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_direct_write(struct kiocb *, struct iov_iter *);
 ssize_t generic_perform_write(struct kiocb *, struct iov_iter *);
+ssize_t direct_write_fallback(struct kiocb *iocb, struct iov_iter *iter,
+		ssize_t direct_written, ssize_t buffered_written);
 
 ssize_t vfs_iter_read(struct file *file, struct iov_iter *iter, loff_t *ppos,
 		rwf_t flags);
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3923,25 +3923,21 @@ ssize_t __generic_file_write_iter(struct
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
-	struct inode 	*inode = mapping->host;
-	ssize_t		written = 0;
-	ssize_t		err;
-	ssize_t		status;
+	struct inode *inode = mapping->host;
+	ssize_t ret;
 
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = inode_to_bdi(inode);
-	err = file_remove_privs(file);
-	if (err)
+	ret = file_remove_privs(file);
+	if (ret)
 		goto out;
 
-	err = file_update_time(file);
-	if (err)
+	ret = file_update_time(file);
+	if (ret)
 		goto out;
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
-		loff_t pos, endbyte;
-
-		written = generic_file_direct_write(iocb, from);
+		ret = generic_file_direct_write(iocb, from);
 		/*
 		 * If the write stopped short of completing, fall back to
 		 * buffered writes.  Some filesystems do this for writes to
@@ -3949,46 +3945,17 @@ ssize_t __generic_file_write_iter(struct
 		 * not succeed (even if it did, DAX does not handle dirty
 		 * page-cache pages correctly).
 		 */
-		if (written < 0 || !iov_iter_count(from) || IS_DAX(inode))
-			goto out;
-
-		pos = iocb->ki_pos;
-		status = generic_perform_write(iocb, from);
-		/*
-		 * If generic_perform_write() returned a synchronous error
-		 * then we want to return the number of bytes which were
-		 * direct-written, or the error code if that was zero.  Note
-		 * that this differs from normal direct-io semantics, which
-		 * will return -EFOO even if some bytes were written.
-		 */
-		if (unlikely(status < 0)) {
-			err = status;
+		if (ret < 0 || !iov_iter_count(from) || IS_DAX(inode))
 			goto out;
-		}
-		/*
-		 * We need to ensure that the page cache pages are written to
-		 * disk and invalidated to preserve the expected O_DIRECT
-		 * semantics.
-		 */
-		endbyte = pos + status - 1;
-		err = filemap_write_and_wait_range(mapping, pos, endbyte);
-		if (err == 0) {
-			written += status;
-			invalidate_mapping_pages(mapping,
-						 pos >> PAGE_SHIFT,
-						 endbyte >> PAGE_SHIFT);
-		} else {
-			/*
-			 * We don't know how much we wrote, so just return
-			 * the number of bytes which were direct-written
-			 */
-		}
-	} else {
-		written = generic_perform_write(iocb, from);
+		ret = direct_write_fallback(iocb, from, ret,
+				generic_perform_write(iocb, from));
+		goto out;
 	}
+
+	ret = generic_perform_write(iocb, from);
 out:
 	current->backing_dev_info = NULL;
-	return written ? written : err;
+	return ret;
 }
 EXPORT_SYMBOL(__generic_file_write_iter);
 


Patches currently in stable-queue which might be from mngyadam@amazon.de are

queue-6.1/block-fix-race-between-set_blocksize-and-read-paths.patch
queue-6.1/filemap-add-a-kiocb_invalidate_pages-helper.patch
queue-6.1/fs-factor-out-a-direct_write_fallback-helper.patch
queue-6.1/direct_write_fallback-on-error-revert-the-ki_pos-update-from-buffered-write.patch
queue-6.1/filemap-update-ki_pos-in-generic_perform_write.patch
queue-6.1/filemap-add-a-kiocb_invalidate_post_direct_write-helper.patch
queue-6.1/nilfs2-fix-deadlock-warnings-caused-by-lock-dependency-in-init_nilfs.patch
queue-6.1/block-open-code-__generic_file_write_iter-for-blkdev-writes.patch

