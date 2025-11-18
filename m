Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A299CCCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D59558E0009; Tue, 18 Nov 2025 00:41:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D09C18E0005; Tue, 18 Nov 2025 00:41:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8418E0009; Tue, 18 Nov 2025 00:41:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9AAF8E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:41:32 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 631C5B8B46
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:41:32 +0000 (UTC)
X-FDA: 84122630424.07.FA4DC83
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id E90B280004
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:41:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=jVHHtkle;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763444491;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vEaGjhrzoRqqbrs71dNJ6HrGl1f3Qp25lPEbTwESe/A=;
	b=L/rqiexROjTz/cWCagaTh8uorgXdKjtcjB3Cn5asfVzWIU3wDSTyjwBlLzgIgSOmrCcsNF
	J+in3opqldQ4plQ6D2YiM/tlfuEavjmUY9xm7H5GdCkHLgZIjCXhj5qL4GyOT7kLM3IDl7
	htOBok4ivlmkEqKmjHEGMFw3HL/vHHw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=jVHHtkle;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763444491; a=rsa-sha256;
	cv=none;
	b=AVkpS8DiuO6wIvx2uaAPQu9im/xGOfNrdlxa1ikqLTORSTv4cqByDbn+wtalZlvgO6vrMe
	w3VdWLMXu/OTnBR4Ztk0KBh+cUafCs82LjvmFgATUSoPRGodtwskyEJ6uOezWTWdJ4o50O
	/YTTzVfC5iZ7L4hmQvD8W7IpJzyZsM4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vEaGjhrzoRqqbrs71dNJ6HrGl1f3Qp25lPEbTwESe/A=; b=jVHHtklen2k+/O6FtBxrGXYHsu
	B+ny9v20XP6xtEfoYk0NPqCupcKyoARuorYPrezPT4o+4zEzbFkfpT4nuTWhhWAxVHnG9QAuo55kF
	FGvWizwnkqSk1YOyW03kY0taLGCy8rxi9f5/y7JT7RaSZy8Vd/fqVMhJzcMVWCJC8wMIwYSipy3uE
	+KH5tzbWzTOiC7VspSMCoCeIhxPO5ZOT6LeNmNP6hB2MI2Nxv0BmgZJOP16bOkgp0KmUbdnw2EmvE
	tYUmLb5X3k+3lhxcYmGgfmfVbjSjjNjko/4uQfQK5hHmFbbVYMYBe1U+xQuGcB/ZBnJe8m0F/pPFP
	uTRaK5Jg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4W-0000000GETE-464y;
	Tue, 18 Nov 2025 05:16:09 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
	neil@brown.name,
	a.hindborg@kernel.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	kees@kernel.org,
	rostedt@goodmis.org,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	paul@paul-moore.com,
	casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com,
	selinux@vger.kernel.org,
	borntraeger@linux.ibm.com,
	bpf@vger.kernel.org,
	clm@meta.com
Subject: [PATCH v4 36/54] functionfs: don't abuse ffs_data_closed() on fs shutdown
Date: Tue, 18 Nov 2025 05:15:45 +0000
Message-ID: <20251118051604.3868588-37-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E90B280004
X-Stat-Signature: cny8x8d5uah57t975bkj4xkzmptztidd
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763444490-951474
X-HE-Meta: U2FsdGVkX1//gptGfoUE+NcJmUTF/7kon9ips1PEuhcufdqfZHV5ixZh+LkfS9d98ZMDgMrWPU0celZluhzkn5iThsa1Xt0FvU05tsHHNugXIRdcO8wdlWquweKJcIbwKjlAUym1o0pq6lQXlyOa/9QWToi0MRfucm+Bvvcgdc20vwoorsyf8BNjSSFUrtDDFNw+2BAU5DeF10tAMHcEYh4GcM6IGULJpKs9XvQyuoAyYYzm3YR4Nzc8iOWKkf47elEBCQ9d4Gln/lrw6ro5XZjPl0i5uh+3fSLdN60KTDkjqYqW9hoPnWUZF+sjEN3gxaRZ9pxN9XPgAGoSK5On61J+xlS8lMMg9hJMo5WzxoQtw4VMBSgPfPmfi683zpuOFuTyHH8MP/O1MgYx+IddkHZkYyvfb+DDB6Sz32MFo7T/SUUFRdlDkQHurXcFnRGNQSo2CuCiiWaqXHri6asbQn/2JYCu9DcEJC6MNdRlzRYa2qj/uxXHiBbCi2kMmQsgAawgc2otnU5Rc71tqpOwkLGS9cfI0tcee0Qtj5frevMUXmdEMLOZOAmP2og8ze0FVoM4r1KJBsvxnJCmo1TRrrjzz61yhGc+hqejEjaIOZa9KNilEzbrDSPPybAbebiUVeBOO7LPzE+Kr+bNQ6KIS7Kl4Jztwvh2PVTdUEoS1SadFJEdEAZLlHUP1st0dMqxmtJk2BhPeRhupUiULiev+dwMRbesLfgSQtriSnXXcsezu5u87DbtBxK+bT/T9vfWUv2WpSWnQkEuq3l8oBeO5yVN5XDz6VFSSK/6P2hwpTJ4r0SLmg3cJ0BVPGb7I2b7t1F5h2KSn16+qtE96lPdIuyusrvaGZIyM5x/CLTXi+ZSt3duIeJNF0vHzE75cmUiFun/gIunH2dUv9C134WLDJ14KYD0L/dnwMWn8zvmnQsVXJIQwvnMq530hLNgDK+7wndX4nD24EwXOPdbjTE
 Ghmt0/bb
 kUNIWVDGcqICAwpfevMI/s5Tp7U6yw0JBqaQo2hpKjxoIPS5CA+K21EMmUDaBCKDpbDI4HTJDZAgkTeFghewitJSQiXzAU/25EIZMorpf+vuew+fja1gIWBLFadQUeDnUXq7M6JfleMlqOqw2U/ldTsUBLVZzPfxFRzmT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ffs_data_closed() has a seriously confusing logics in it: in addition
to the normal "decrement a counter and do some work if it hits zero"
there's "... and if it has somehow become negative, do that" bit.

It's not a race, despite smelling rather fishy.  What really happens
is that in addition to "call that on close of files there, to match
the increments of counter on opens" there's one call in ->kill_sb().
Counter starts at 0 and never goes negative over the lifetime of
filesystem (or we have much worse problems everywhere - ->release()
call of some file somehow unpaired with successful ->open() of the
same).  At the filesystem shutdown it will be 0 or, again, we have
much worse problems - filesystem instance destroyed with files on it
still open.  In other words, at that call and at that call alone
the decrement would go from 0 to -1, hitting that chunk (and not
hitting the "if it hits 0" part).

So that check is a weirdly spelled "called from ffs_kill_sb()".
Just expand the call in the latter and kill the misplaced chunk
in ffs_data_closed().

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/gadget/function/f_fs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 47cfbe41fdff..43926aca8a40 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2071,12 +2071,18 @@ static int ffs_fs_init_fs_context(struct fs_context *fc)
 	return 0;
 }
 
+static void ffs_data_reset(struct ffs_data *ffs);
+
 static void
 ffs_fs_kill_sb(struct super_block *sb)
 {
 	kill_litter_super(sb);
-	if (sb->s_fs_info)
-		ffs_data_closed(sb->s_fs_info);
+	if (sb->s_fs_info) {
+		struct ffs_data *ffs = sb->s_fs_info;
+		ffs->state = FFS_CLOSING;
+		ffs_data_reset(ffs);
+		ffs_data_put(ffs);
+	}
 }
 
 static struct file_system_type ffs_fs_type = {
@@ -2114,7 +2120,6 @@ static void functionfs_cleanup(void)
 /* ffs_data and ffs_function construction and destruction code **************/
 
 static void ffs_data_clear(struct ffs_data *ffs);
-static void ffs_data_reset(struct ffs_data *ffs);
 
 static void ffs_data_get(struct ffs_data *ffs)
 {
@@ -2171,11 +2176,6 @@ static void ffs_data_closed(struct ffs_data *ffs)
 			ffs_data_reset(ffs);
 		}
 	}
-	if (atomic_read(&ffs->opened) < 0) {
-		ffs->state = FFS_CLOSING;
-		ffs_data_reset(ffs);
-	}
-
 	ffs_data_put(ffs);
 }
 
-- 
2.47.3


