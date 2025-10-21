Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FD39CCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:11:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 711E88E000C; Tue, 21 Oct 2025 03:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C2A88E0002; Tue, 21 Oct 2025 03:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B2058E000C; Tue, 21 Oct 2025 03:11:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5E68E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:11:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E112816039C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:11:13 +0000 (UTC)
X-FDA: 84021250026.12.E3A86A6
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8A92E10000F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:11:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=i+HZWgR9;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf14.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761030671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWT2gm3mr1yTWppm7hvARyuErTtEe+bWsoFO42B5tnI=;
	b=dZeis8WMZBHBiX4KBXXk4MdxnxHzSajJAjRqA/XqhHPngdyltAJ4V0tbhSmN2v6jRNeyBY
	sIc9zeHV2HEJ+0uofc2XTkH/wyzQo1B4KJj5RafeCUmopNF3SCPCJFe/Ug0CaRk/JfdBN9
	8eoG9OQJUdUAx6/z7G1D16tugzlxeRM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=i+HZWgR9;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf14.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761030671; a=rsa-sha256;
	cv=none;
	b=uNhxuRjX+W0jTsHeRDti2G/KzG+dmH0NfPuycvHOu65hLiJhglJ2a6A9sZcklknpk4qfjK
	VRFq9RzHJpg35GSIRcWqr+BX62HbK/HxZlDQuUYfxrADFsHsJeA3dWep6k0P8P1wsDhp4H
	HD3wV49oc7RJ/+URzK0EULdwuLmWLjw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1761030671; x=1792566671;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EWT2gm3mr1yTWppm7hvARyuErTtEe+bWsoFO42B5tnI=;
  b=i+HZWgR9Fy/ceK1rCjmrbVyyF2m7NZZMJOHI8N2U0KublxihHLEGfPLk
   nTiFq8UkzoAQ/eblVh37M6JkXxWHqPf+Wb7WxR5fQNPoC7RznCemV/ZN/
   qZFFVF0VgS17HNP5LGyJIdG9mjXBmL7SFxnEQGfYCo+tRS51gXYsa8T1X
   zfmfb13zNW0apqveKMGKoniXsdbRKWz/d/8TxMj0j9kLm5PeK1aMp7lgl
   MgWwmkOabI3Sf3G/YF/Op4y8z/ElFWtuJUixMw63WqrMiPLxyZw64GH6k
   tFZ+gqRiUsLZrDSV5WBmacjvPkepvgM5eDcxfmbU3iJi4lXWMBcKtTcu8
   A==;
X-CSE-ConnectionGUID: DKfSEOkqQQKB8ERoq7WY2A==
X-CSE-MsgGUID: DEt+B/AnQgG5Vzyn9KIMpA==
X-IronPort-AV: E=Sophos;i="6.19,244,1754956800"; 
   d="scan'208";a="3933276"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 07:10:59 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:11521]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.29.7:2525] with esmtp (Farcaster)
 id 72943488-d8d8-46a1-a014-aaf1f5c61ddd; Tue, 21 Oct 2025 07:10:59 +0000 (UTC)
X-Farcaster-Flow-ID: 72943488-d8d8-46a1-a014-aaf1f5c61ddd
Received: from EX19D013EUB004.ant.amazon.com (10.252.51.92) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 21 Oct 2025 07:10:59 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D013EUB004.ant.amazon.com (10.252.51.92) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Tue, 21 Oct 2025
 07:10:48 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <nagy@khwaternagy.com>, Christoph Hellwig
	<hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>, Miklos Szeredi
	<mszeredi@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>, Al Viro
	<viro@zeniv.linux.org.uk>, Andreas Gruenbacher <agruenba@redhat.com>, "Anna
 Schumaker" <anna@kernel.org>, Chao Yu <chao@kernel.org>, Christian Brauner
	<brauner@kernel.org>, Hannes Reinecke <hare@suse.de>, Ilya Dryomov
	<idryomov@gmail.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe
	<axboe@kernel.dk>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, "Matthew
 Wilcox" <willy@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, "Theodore
 Ts'o" <tytso@mit.edu>, Trond Myklebust <trond.myklebust@hammerspace.com>,
	Xiubo Li <xiubli@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
	"Jeff Layton" <jlayton@kernel.org>, Andreas Dilger
	<adilger.kernel@dilger.ca>, Christoph Hellwig <hch@infradead.org>, Ryusuke
 Konishi <konishi.ryusuke@gmail.com>, Luis Chamberlain <mcgrof@kernel.org>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ceph-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>,
	<linux-xfs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
	<linux-nilfs@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.1 4/8] fs: factor out a direct_write_fallback helper
Date: Tue, 21 Oct 2025 09:03:39 +0200
Message-ID: <20251021070353.96705-6-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021070353.96705-2-mngyadam@amazon.de>
References: <20251021070353.96705-2-mngyadam@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [10.253.107.175]
X-ClientProxiedBy: EX19D038UWB002.ant.amazon.com (10.13.139.185) To
 EX19D013EUB004.ant.amazon.com (10.252.51.92)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A92E10000F
X-Rspamd-Server: rspam03
X-Stat-Signature: cc9tzku5ey1d39wf43uuqdnwqrbsxqud
X-HE-Tag: 1761030671-690509
X-HE-Meta: U2FsdGVkX1+SGShk3MnxnvxSG+IwDnwRNKQMIHUF40EmD02NSZ8eAMsDENMjXPIOdQXguHzFx4fVPVYGxFrNG/SjPnTwVaqlUNrK9Ts5Cc12T1VzLrZNXG5Hz+I74LKy7Q8pyIy5yaNMTy1A3oi/WL3+veh/P3RTtBR+TRwmFDWQiQDX1l+x9LTrAdDhCCLL/k5DCkgKlMgz8F9zQKwTTbiCyTSkWLIMw5+rqjWi3PzN/zmDgF/bn2EqGJWKrkUi3ZxodlTPR1Q1usFgrPvrpkbq2hdAXjpt9wyEJzpQ3Rh3Et1TQCevJkzWR0zbM5MDPUtRDQ5eQ78ezlXb+cpte2rBgan4/icJctBO4UiG/IQMxU6vhvCG7wuaMgq7aM939OtU2iAcrLUf4t9+jl3OcvXIf7AsKKE3kR/PtiDCvAem0rl4zDD0hRm+a+K4H5a2KziZUvFx87hUUa9qp7AGsXNQPAJ6ABJMe3hVG3Oui0eYlP2wtoIANSjzbFX46akHExu23ZbyJnpb72DEoIR/FgJpmSYEMi5erGxYuEuFNmK5g8eh2aJ8c9sKoNgcnjDm81q1Gti26x30x9iFOAeosKTg1wjJ1AzTmRZ2iEpamX2yx1tntbROojwSw7zINpboq0832qcGuaXEDWzLVMYfPat3a1CA/r150N63V8RhPM8cl1KO271u/rtblCDmErksEECOSgwMTbPUuxGTrpL4cfwfvBN+qnRYXX3SakP1F1gA/Ur+2h4KZg4D5/m207bSSY9DeRxJDtJgFhkjvos8nMpLsckc2gFvcPGnc3cFf0ynaTpvvpGCoV76iD1Og9hWXRzaLYheFY6jcRK+TWVJZxaFlq71zyKulIJQDp2M7oMz8leYzi5SZpdSegxY8GdgrhAXK2nbwV+e9F39DAhgGK+ps/2I9jVdlYMXwM+Ue/3AQKMi4lV3TdxGsw+JoqGHM82qmxr8czC9u4gfYxE
 KJXc81Lf
 zjB9hO2GMxUD+Yhiav5FpXeBlN0o96TnHV2yjJbvo66YjEM9OOoucXle7/4iph4SsA2a1+zEd7kKQi51PUDri6sEBSTeAO/23VMJ7TSlX/cU1fHEnYDZ5yI/3iXUjgiPS/s47Uq6JLFqGqGr5bBLOUKAN30pnppxS6Qa7qUnfGP9AUgwhM+V+nzyWsD9L09vpu0oZwNjAizGCsTic3DhrjZGrmSpK7HXvcMJfK6y8s8rIQm5Ws4VSzCzWPhiqrnFRtWa6ejO/jPV917A2ELMKiRyi2iezboBVDjsKCBjJTkhsxutbqlZjmLLtdxnDsHNl5ZGZXOT1I6cbXsOKrZMaBqHPAKc8G0/S73xKXblaHlGf4SF9zLV/nhOAMDdxfaNS9jcP4Oy4NFc2PyZa63MHrKke4Zb8pJv/+/zdG5iHTreGL0ZZwcYYWbA/UWU7YehQ3Ur33tDFvHi4oi7fThspSOY3Y8r8bfMahgK1MquLPG5F+vNJhw30Gkq3oK6vBtNoTkSR9BCUbp98YGWgamH6lH+ClAIgHJSy7P7eEWpIovIRq/1V40VvjqmAQGTew54vHy6MW2Qw2rPeCf9mtgiCE4xTZK8BBX3uzBTPb0gfgfDRhUgd7j5CfCBSbbndkmRty1b9J1Dso9UZkEYj+5H/db+oYHR2giBRQebRk9J8QwhNteMFHnSoGJkGGC8AK3KN98ziAdqhs+AuO6+jWV0fF3qItqt1GQ+Ti9QGg0RVW7fO7dF+jE/ihi+RiZPXx43exjcd3cD0FerCZtfJKb2O44T4a3J+sQ4G/SvR/tcBAvMh2OpgvoOcljNBQlfRDie6fmEUMdya6QAGtYsk4Ao+EX7/Uo2igrH7D9DcFoVH0KNHJJk5IV5TzAeRZ8W4I8ZdxjE/T+DdlBbgG7Dt5ll4bTw/drjFxAgwEKECfIxHyyriOXMRWeDqJNkeL4PyjvZcHhKRi029qyNe0QwuoVss3lzO53Hg
 BfnAjnS5
 DBNBJqeLSyrpg51vU8yBrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 fs/libfs.c         | 41 +++++++++++++++++++++++++++++++
 include/linux/fs.h |  2 ++
 mm/filemap.c       | 61 +++++++++++-----------------------------------
 3 files changed, 57 insertions(+), 47 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index cbd42d76fbd018..a5bbe8e31d6616 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1582,3 +1582,44 @@ bool inode_maybe_inc_iversion(struct inode *inode, bool force)
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
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4e8a3e4f894c0f..02c83cd07d4f20 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3278,6 +3278,8 @@ extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_direct_write(struct kiocb *, struct iov_iter *);
 ssize_t generic_perform_write(struct kiocb *, struct iov_iter *);
+ssize_t direct_write_fallback(struct kiocb *iocb, struct iov_iter *iter,
+		ssize_t direct_written, ssize_t buffered_written);
 
 ssize_t vfs_iter_read(struct file *file, struct iov_iter *iter, loff_t *ppos,
 		rwf_t flags);
diff --git a/mm/filemap.c b/mm/filemap.c
index e2045266d2f2c9..b77f534dfad35a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3923,25 +3923,21 @@ ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
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
@@ -3949,46 +3945,17 @@ ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		 * not succeed (even if it did, DAX does not handle dirty
 		 * page-cache pages correctly).
 		 */
-		if (written < 0 || !iov_iter_count(from) || IS_DAX(inode))
+		if (ret < 0 || !iov_iter_count(from) || IS_DAX(inode))
 			goto out;
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
-			goto out;
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
 
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


