Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A35AECCF9E3
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 01:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 073378E0002; Sun,  2 Nov 2025 20:49:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023778E0015; Sun,  2 Nov 2025 20:49:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E04828E0002; Sun,  2 Nov 2025 20:49:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C38878E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 20:49:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 750D04A3A0
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 01:49:07 +0000 (UTC)
X-FDA: 84067612734.06.3F90FD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id D4E6340005
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 01:49:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=by+vf6nh;
	spf=pass (imf27.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762134546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=kKAQ55ZC7CWCOj9QlnZCvTgQQ9XfGsQN//rFpJEjYqI=;
	b=4C9Ol30X6KgkbhFgLuSBYBWMFtFuu1Bd03wIMvbaoTABfhXk9c9/tE0o7WDeyOXag0Jx6L
	DQcdDu32ef4naIS+bwdE3qWVw/MwbrDYjOpVudLD8iBx36NpdyH6mgtPfyplla0ZbchRSE
	nFBWgnIdqgVcnS0jF2+ETkONnH2OgVI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=by+vf6nh;
	spf=pass (imf27.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762134546; a=rsa-sha256;
	cv=none;
	b=tPUYO9+fOUiaSE73ovdYskmOPhORAZ15acoRncTRpHrMGKXVhDCEuzb7KljjDm5FMigq+3
	psaeynTfy3q7JtMfBTZBtmZdgE/HvcGApyQcoJ/j+XKNAYITeWGqhL0RBahsgaE+wylWDy
	6aRYxarb1H7BRpir5UxoUsBPcv1Tvm4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F1A88445EB;
	Mon,  3 Nov 2025 01:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F9EC116B1;
	Mon,  3 Nov 2025 01:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762134544;
	bh=arAtIsI9jWOkj6ySIvHWCR08cokcinzzktaRQv6IHN4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=by+vf6nh/IxLNCKqVoTx0uY91rCPHfNp0SKR0gkxqPBwDPjvazd9muJvUpQ4MX6+h
	 OVH0VZosqAwP6uQtGyF5Yr6H6NS13L3oTDqvQJ73JXuYLmDzIMf41Hyl9nZRCM3MCR
	 X4lZ3wrziffBnDCz8ofoefifnznpH+LbyqLDfRNw=
Subject: Patch "nilfs2: fix deadlock warnings caused by lock dependency in init_nilfs()" has been added to the 6.1-stable tree
To: adilger.kernel@dilger.ca,akpm@linux-foundation.org,anna@kernel.org,axboe@kernel.dk,chao@kernel.org,djwong@kernel.org,dlemoal@kernel.org,gregkh@linuxfoundation.org,hare@suse.de,hch@infradead.org,idryomov@gmail.com,jaegeuk@kernel.org,jlayton@kernel.org,konishi.ryusuke@gmail.com,linux-f2fs-devel@lists.sourceforge.net,linux-mm@kvack.org,mcgrof@kernel.org,mngyadam@amazon.de,nagy@khwaternagy.com,syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com,syzbot+f30591e72bfc24d4715b@syzkaller.appspotmail.com,trond.myklebust@hammerspace.com,tytso@mit.edu,viro@zeniv.linux.org.uk,willy@infradead.org,xiubli@redhat.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 03 Nov 2025 10:46:57 +0900
In-Reply-To: <20251021070353.96705-10-mngyadam@amazon.de>
Message-ID: <2025110357-fossil-reclusive-c3df@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Stat-Signature: gziwueo45gcmztmtggamb51gqqsk4y6x
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D4E6340005
X-HE-Tag: 1762134545-181990
X-HE-Meta: U2FsdGVkX18WSG1Lj631k+w3/xm4thb7UIQkf2wpiw8LvA1nCD4kiWfT/8cbJ2VpOxJwEtKbVZ9ENH79PGLwYa7yBzGbMkhDfmwhR+cmJfcbTNgVibqV9HSTXFW2x6v0/gLU2kmmxCqgoFsFGXDxvkIFR4/S+F0CtEgsrAj6OdGy+nMqSIeg1fT7L9ZlDrfa8Sid/OxQAJ/UOAuQr4MkJG8ALVcXOia58UvAp4aMcu9ygGnOUJL/PakbLgMfIVxYxEHmn4MEI85T89TP3PibNFJKonc8BDrlMI8/mIKok6lZ6a4xDF5iznWfZQwOa/jqBaH+IVWsALURZVnvVC4wA1v3a4p+yC5F+LhwCkCpq733uF1ydki4HF1rCKPr5R0jr7emqLu8Ch/e4OcG3LwmGCURVj+iJzoD2sZPOvobR4VMo9z0jnjsvmvfxiR2Lbkht8IdnvHLXdAoBK0/HrC9nkbAP03Cw4v5yHAYZ5C9NGIs/2K4DUEmM46WIb+u+lF+E3H5RgYf4lylGhkjxZ0qsF/0/bIbIW60iy+kpsj/T0Pvj4r3cfGhyKgIXmUwNi2oODMdKI861dd5WW+3i1nfvg5l+dfZn4q4p1enF3/tc1HzbDA2VCKcd2qKNdjUEJRDfaxcqumsiNCSOEpEFZ6i84iukdq5M4mVwoOWeYW7H0XR0iKmC8NQDZwjwQhp4vx2QDbaJz7aTyC882pE4naGIfaE0wnmqACitx18KHoNl6tC7CQP8tzS7BvcvxST9bLdKRLqgTTRpL71eONYfRDUKiOsG51d6UdkY5/VaNJUGrWND6JJr9qtx50VysQV4rIZ5CTxZfxT+ThIiqLTZe2qJEGQYaR5DdTikBolTKgO5sLf13zqH+xafGZS22ia0ABhTEXCXAET+IxDDzTnlrsHSE69xec4OVJpnxKKkvXCuP2jLp22iVtv08cEnBGVNygFulrSbRVY8R47icp/+Di
 Ear5aIJ8
 jE/ManWaEB8/d4VAc8VmaY3l2dbtUujtQXWDu4r3q6A8BnA6UeHuOxewGcvYAFjx53vl0bBaePZ1OrPVlEXxZmJIL+5jBRIgm3L06S0PT1NbtUW3MItA4+MZSSpGwnOA6itmzpaoJOWSeML4RBihY3B42U6Pnea0Cj6EP6Y0OAdZafxkIQLPfaRpSgo6D4hy2/JbuqgnTU6gQnpEHY1Co7yU53w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    nilfs2: fix deadlock warnings caused by lock dependency in init_nilfs()

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     nilfs2-fix-deadlock-warnings-caused-by-lock-dependency-in-init_nilfs.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-188303-greg=kroah.com@vger.kernel.org Tue Oct 21 16:19:13 2025
From: Mahmoud Adam <mngyadam@amazon.de>
Date: Tue, 21 Oct 2025 09:03:43 +0200
Subject: nilfs2: fix deadlock warnings caused by lock dependency in init_nilfs()
To: <stable@vger.kernel.org>
Cc: <gregkh@linuxfoundation.org>, <nagy@khwaternagy.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, <syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com>, <syzbot+f30591e72bfc24d4715b@syzkaller.appspotmail.com>, Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <djwong@kernel.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Hannes Reinecke <hare@suse.de>, Damien Le Moal <dlemoal@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <ceph-devel@vger.kernel.org>, <linux-fsdev
 el@vger.
 kernel.org>, <linux-ext4@vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>, <linux-xfs@vger.kernel.org>, <linux-nfs@vger.kernel.org>, <linux-nilfs@vger.kernel.org>, <linux-mm@kvack.org>
Message-ID: <20251021070353.96705-10-mngyadam@amazon.de>

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit fb881cd7604536b17a1927fb0533f9a6982ffcc5 upstream.

After commit c0e473a0d226 ("block: fix race between set_blocksize and read
paths") was merged, set_blocksize() called by sb_set_blocksize() now locks
the inode of the backing device file.  As a result of this change, syzbot
started reporting deadlock warnings due to a circular dependency involving
the semaphore "ns_sem" of the nilfs object, the inode lock of the backing
device file, and the locks that this inode lock is transitively dependent
on.

This is caused by a new lock dependency added by the above change, since
init_nilfs() calls sb_set_blocksize() in the lock section of "ns_sem".
However, these warnings are false positives because init_nilfs() is called
in the early stage of the mount operation and the filesystem has not yet
started.

The reason why "ns_sem" is locked in init_nilfs() was to avoid a race
condition in nilfs_fill_super() caused by sharing a nilfs object among
multiple filesystem instances (super block structures) in the early
implementation.  However, nilfs objects and super block structures have
long ago become one-to-one, and there is no longer any need to use the
semaphore there.

So, fix this issue by removing the use of the semaphore "ns_sem" in
init_nilfs().

Link: https://lkml.kernel.org/r/20250503053327.12294-1-konishi.ryusuke@gmail.com
Fixes: c0e473a0d226 ("block: fix race between set_blocksize and read paths")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=00f7f5b884b117ee6773
Tested-by: syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com
Reported-by: syzbot+f30591e72bfc24d4715b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f30591e72bfc24d4715b
Tested-by: syzbot+f30591e72bfc24d4715b@syzkaller.appspotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/the_nilfs.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -680,8 +680,6 @@ int init_nilfs(struct the_nilfs *nilfs,
 	int blocksize;
 	int err;
 
-	down_write(&nilfs->ns_sem);
-
 	blocksize = sb_min_blocksize(sb, NILFS_MIN_BLOCK_SIZE);
 	if (!blocksize) {
 		nilfs_err(sb, "unable to set blocksize");
@@ -757,7 +755,6 @@ int init_nilfs(struct the_nilfs *nilfs,
 	set_nilfs_init(nilfs);
 	err = 0;
  out:
-	up_write(&nilfs->ns_sem);
 	return err;
 
  failed_sbh:


Patches currently in stable-queue which might be from mngyadam@amazon.de are

queue-6.1/block-fix-race-between-set_blocksize-and-read-paths.patch
queue-6.1/filemap-add-a-kiocb_invalidate_pages-helper.patch
queue-6.1/fs-factor-out-a-direct_write_fallback-helper.patch
queue-6.1/direct_write_fallback-on-error-revert-the-ki_pos-update-from-buffered-write.patch
queue-6.1/filemap-update-ki_pos-in-generic_perform_write.patch
queue-6.1/filemap-add-a-kiocb_invalidate_post_direct_write-helper.patch
queue-6.1/nilfs2-fix-deadlock-warnings-caused-by-lock-dependency-in-init_nilfs.patch
queue-6.1/block-open-code-__generic_file_write_iter-for-blkdev-writes.patch

