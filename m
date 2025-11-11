Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED05ACCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:55:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414E08E0011; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36E9E8E0025; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 194EF8E0010; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A42A98E0010
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72EB113AE32
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.13.72F5115
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9767C14000B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=TqkcMEiv;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf09.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=xjvnPm5tdZTgZvGxXMCbo3F2iIbx8wYl1KZFrG3D2p2/b6X7T8yqzTjlfVpcu1d7XR4JmU
	Iz3x3931J0V2H0qGJnNCgLiJfOgVlbnVH1ulJ+n5rPnAtSlDeaDSf8FCsWux73kTNSn3M3
	lrHCEHmfz2++nhaqP23+DuDIcgKjfjY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=TqkcMEiv;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf09.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NeGicC5Z67ZOycdylyHVP58sPv/wzz9kpKbtM8vrBao=;
	b=WJ4iKiIbtzs4DuiQ4S81TM9OyWDdI5ANA5hZApGEbKtup/fy0mqNvrOmbfUmsojI51ghUV
	Gi+OPMpdmMGLuH6LNFeBw5/y4o/huL80R2Xe3e+wrvnBk0uHyFAzcKVJW3u2NXL8Ar6kJJ
	xmhLk3I+09T4PH4wdBJojPdbTRVU5M8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NeGicC5Z67ZOycdylyHVP58sPv/wzz9kpKbtM8vrBao=; b=TqkcMEivZIXJYaF6ZOIHxmt9Vk
	ohKhWrAsLkuIVUzpRtv9GAOLw4PKTjGu0cDrLfq1aZdI1jpzLIeVbQJUtimjnqiyE4l28biMeXbU0
	SIQ9Rb3j150+dScnH4j4C3q+qtBcOCjEBfpcd3R4Jx8kW1fQP3eCjEpoPGCq/C7xzApDvTnyKJR98
	PXZAThOhk5zfcqKAsI5C3RZlC5f1Axfu8UDfOLsCHtAoj7mqx27DDYDiOSKPtcPe+a8s9ij06CBms
	M0WHQ4bUWJL0ApP+7L+eWUGoTAFk9bqmcTwUs5BYke3+24aoCR67UP1bIbQcrW5ESQ9Z9sGcWideo
	fsqkHMSQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHj-0000000BwyO-2vqR;
	Tue, 11 Nov 2025 06:55:23 +0000
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
	bpf@vger.kernel.org
Subject: [PATCH v3 15/50] convert bpf
Date: Tue, 11 Nov 2025 06:54:44 +0000
Message-ID: <20251111065520.2847791-16-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9767C14000B
X-Stat-Signature: sf4wors85cz5fmg8tkdrafw6mfhmnyte
X-HE-Tag: 1762844130-834388
X-HE-Meta: U2FsdGVkX199jR8MclyhrJDCu+yXIEdNDtHIv8IHepeiKwmYI1PQbN98oQJUtoB8Xtv82PGrh9IUbKdqW4yPIrG9LGK9LtJC+P2BYalkjO+PbCMBBMsqlQra3F+5SZJ3ExMTdS/M5LBzp/mIKQoR64+9CwdrPEUYpHs6WEyIjnD/kPHZ+xtvaGtyDdWH62iikqTuh5s6i5qOEdhZ1qIaITOM1alzMD87cPXZo8S3+AZ17TGJAwu+/CImI2gDaIrJy1ndRzjFNbEwUsqkLNGEkMWIsonPkxJQaVeKc+M37CIGb5gnb4FlcOLlsLu7V11/FoXFq+NI0h5ZT2r7wWfhowafvqQI9Kd5p0LyUg6XbyZRqejBVWosuhTC5ixK7cRZY7zVbDs0TJun1YuMGNEBeffq+SLJH+16HN4Em7QlnOC/bHel9yxijNH0KNRWgrZAIHd9w9da+N3eBOSBHZLiVoO60xX5WMfwQPUIbq5ZPy4LziK0wM2lqSmuoYu/CIgaLnM82DlqLBE7VX4XBc5hyQ7pSblXh8iHn0H6J1Rc+JuwTJpWSZ9b7kDiM0ohxcdLMBc4GOCseOS1nc6/Vt8JXsobRsXl7J98/D6USrJVlIZOkqBbVfuPschYNzIp57n7PLT9Bq48NHSx2YpUr3SSxzbQ5rqw+qVOVVXn80DIpJ3wghsEGWsNrgmWBUSylP9fB97N1raDzPnz/ZASYPps2PveglCPIXr/0NN0OHz7Hm5gKORBor138vvY2inagN9npX7YWrg52+zK169MbCY/5FDIwhWvBLcGRz/Z2QwQZxuQa0rAVGW9DWKeREmj21ax5uvv5H+e42ZM1RMlVEmh6Grb1JO+i4Xm5uYzBspWlQdgj+gKTRZ3AfZlxw3kbPf3avq1bDyMvFRFV4ngFVRwkkkRiG6sjsdxAew8TMYjehfthg1KcNHrt1JD1H2rDlanXn5FIaBhMtRYtU9+hQW
 PlkBU9Tx
 ulyKMdffi5hXq2rfMq17fwmq749mzpvt0FrM1iW9dTp2E027OvdWINQDLYBtSoQRrXfzjRBWGIZ9R/RztKmoqTkrad2a1nOFPwQoVdgLiRK0IXO3JHtaQtMeZQ+b9A4GAdGLM5DhnMKuFplGHwr/WHVlCly83+0dcRKuguSN+z8ORwcLxxCPpa8eJ/Y6zEMF4mYtnF0JPccNQVfS14vQ0VqCoZaKU/yWmYgsfq068E2E0eizZ/3lIkMN/xdQX99nN4VPCzsUY1VVwqU8V2W1JaQAgvqm7t1QBtf9x8moMTzy+knyTsfHVlIo9JrDZSamNrhGlRFU4PiuDuEoBCxRj83ZJZOUzf2u8G3eEU1NQ2U0voFc4Q/IQRaecpf2lY680U9GLZkyZ4avyUvWW9wBxeWgw6J1MfLynjJAJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

object creation goes through the normal VFS paths or approximation
thereof (user_path_create()/done_path_create() in case of bpf_obj_do_pin(),
open-coded simple_{start,done}_creating() in bpf_iter_link_pin_kernel()
at mount time), removals go entirely through the normal VFS paths (and
->unlink() is simple_unlink() there).

Enough to have bpf_dentry_finalize() use d_make_persistent() instead
of dget() and we are done.

Convert bpf_iter_link_pin_kernel() to simple_{start,done}_creating(),
while we are at it.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/bpf/inode.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 81780bcf8d25..9f866a010dad 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -144,8 +144,7 @@ static int bpf_inode_type(const struct inode *inode, enum bpf_type *type)
 static void bpf_dentry_finalize(struct dentry *dentry, struct inode *inode,
 				struct inode *dir)
 {
-	d_instantiate(dentry, inode);
-	dget(dentry);
+	d_make_persistent(dentry, inode);
 
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 }
@@ -420,16 +419,12 @@ static int bpf_iter_link_pin_kernel(struct dentry *parent,
 	struct dentry *dentry;
 	int ret;
 
-	inode_lock(parent->d_inode);
-	dentry = lookup_noperm(&QSTR(name), parent);
-	if (IS_ERR(dentry)) {
-		inode_unlock(parent->d_inode);
+	dentry = simple_start_creating(parent, name);
+	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
-	}
 	ret = bpf_mkobj_ops(dentry, mode, link, &bpf_link_iops,
 			    &bpf_iter_fops);
-	dput(dentry);
-	inode_unlock(parent->d_inode);
+	simple_done_creating(dentry);
 	return ret;
 }
 
@@ -1080,7 +1075,7 @@ static void bpf_kill_super(struct super_block *sb)
 {
 	struct bpf_mount_opts *opts = sb->s_fs_info;
 
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	kfree(opts);
 }
 
-- 
2.47.3


