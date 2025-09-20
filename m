Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D518CAC5AA
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 291918E0016; Sat, 20 Sep 2025 03:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD2AB8E0015; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451728E0017; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B41D8E0010
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0BF2DC08D0
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:08 +0000 (UTC)
X-FDA: 83908850256.27.89311BB
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6D8871C0005
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Xd+fhdH+;
	spf=none (imf21.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHIurh1L4ZAnx8Qlum7bXJSPzKE6mjESH5b9zbhJwo0=;
	b=QjSEIuPnxZnmIAf/wnalkHKZkm16W4Op8SrKrvjjMEPIPpAJ+8jhBQQlfmAiJmhEH9ksgR
	mhMbtAJ1KmQ3HDqKfUixxGcrFXtEnMrVwji1EyBKn1WZXdAFv3iK36AA4Qqpe2i/hc5KNu
	zpLQ5XHHDufNb0qnjKE1WABLIaxPQT0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354486; a=rsa-sha256;
	cv=none;
	b=kHyNmOWsahajX12307Md2wV6Llt4elnTZDxFVhaVeAHd5VF8WQnp7JwZiWXVJk0paKI/BF
	n+gl8gv5TosqpeC31/8/LgO6xTTBJiQOnw6Im/Tl9i7jjOEwg3m6oWaSaZQulH7O4OXgQV
	a3l0icXoVo6pYgii6VC6HqIW+1iM2N8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Xd+fhdH+;
	spf=none (imf21.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SHIurh1L4ZAnx8Qlum7bXJSPzKE6mjESH5b9zbhJwo0=; b=Xd+fhdH+XROIHkZFDeHvNlvGi9
	2XDjMdW0HBBVLKWurJFnhokxryB8V7D0GP7K9K48Gtb4JvIpea72Lqt8zNNKOf1gP5ZbalRwMA/Xa
	yenZDqNr5o036U952M8Q9k5Bu6ohbdqU0HFDCyc6fPRdm2ziCCaevvpNIj7uKyx3g9vd4hAlQDwt6
	c8ELFtaoSFtPE5hO03NWrFizgx12s47mZFKBGy+doHIlOiXqU3YuIlOy0VtCexqTUQuHeQJTezd2p
	jSOqkfX7/7qhwr/ni2e5+G3Ar9WkN1ld9PMG0uKudvozKird2FxqtQkzzEQcZ1pcbRkVKTC1IJWsa
	ezXbChyQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsK9-0000000ExDc-3YnV;
	Sat, 20 Sep 2025 07:48:01 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
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
	borntraeger@linux.ibm.com
Subject: [PATCH 14/39] convert dlmfs
Date: Sat, 20 Sep 2025 08:47:33 +0100
Message-ID: <20250920074759.3564072-14-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6D8871C0005
X-Stat-Signature: etanf9eqrsf8mq8q8pgdssk4xt1ycy1g
X-Rspam-User: 
X-HE-Tag: 1758354486-825243
X-HE-Meta: U2FsdGVkX19C/OPXou3G6yT0AEEdZLg4i6GU7ZpkQ8MqQGMFYVUzGOPZDfOyvDRsDDo43j5v3lF9EyoG0fQOH/5I2dLTSOi4EJAvABLAiGl+IJXIAmuxJL8URkJHp/XUg1vLyS1w6eY0dm59uP368jQTPU358pceNPkvNpDSUd63tLfNd3CvkwvtLFB3n6ugSPyKrb8KF3tefdTb4VC84urmwxdJ70ynpQUwQ5JKJpB/T0y3YLiuXB1xtUK4B2n3K7GMSZKCXruCT6mFHBeLzKSHisank81oKFSa+pd73sCb59x3ztziHJtY0G6WRZPj3ItMYA0oeum+A7dhMiGXL1ykqvEpuhmxNzs6lj2qg17trdVb3qnELggfwTxn+74dVid7tybyYdC8nkbFNosLW1zSgdiVuIh+8mSMLUqH8B2gzarstXqJgKkFcnDBnXKkg7QLmhQtvK+TFVnyYQLyKKy9brkOri5q6ik2Caa3FbJ+UhaB18/4tXXwre534Oji3LNMQLy0lKXzB/Q1hfbWMl0uy+v2yhCPmNmFp5J4Hkx38WfHfsEOgZHhgetc0aQPgJJmWWVlqDL+NrOD2CRfXduXb2E7t6qpVA7MjHAEOW+qK3dfh6ljXjHW/VNfrZp13YE663GKyDIVxFugttDTiChA6jUB1nmutg62BiFwtEEeQnBAXiKzWFHUI3NyU16W4meAEjBnZCQ1VXO4sqsxunRjUk2F6wkdCmKiRpHyQW1yQmYd/NCYCt81zPpSAEIwFrFkd40HOdNmDadvzrqZwYFWKRGODaA7zdOSVToVQfcpkCgKKsPm0O598dnaDjOxwakuyLPTKefCgj1z6JtWeOnyim1ZQp8b8xus6RhKl3TMEqkawgIqBu4/ebp5IM+HdpnYk3Xe3v2vlif9FyqPVxgdKc6r2W14LaKzG+rJJjQlt63hPwYF+8YoIHuRE5jM48rkEuh+Owys4vOsuN/
 x7n6J+SH
 0tagnYgYb6rVzhKOjL1e4E1w5Ni8O6lvoJGb/f4e0d4LDZF63J4UFQKso8mf0EOrzcn7dn19J21xdWuwSj9FvW5nkpW4T1GsomU5OP3Zci4Z9K1cBsYMuzUwGlRyiHGlGAYVxU4oNgpvh3y/ChDnqBbbkPGF+vgWtEnWun+/KIEPZBRFAMdgTo6gCP0A9sJH9gFBgFI7aE7epHqYuWCkDyx8UiT1N8Id+1qYqJuhadjz+lgKdjPjmNc3kgZlNTnmjKOBYKa3v/KrLSHx4HxHh+T0/fFj+ab+BSkNdTzKRjdVsTKQ0UgSd6UENR8FazShqf0t3LOwvLzqsqI5533Z0q3POhzrTI5NE0livLfkj8G2n4PKTvx7xGRuPNu/v2zazL+K+wZrMpWRebHRs0pZCnt6Cj7ctBMJnJ3LsIhRxOi0yqhv4Eqo0E64YzTD8hLeV1L7fgkE4ZZyN9As=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All modifications via normal VFS codepaths; just take care of making
persistent in ->create() and ->mkdir() and that's it (removal side
doesn't need any changes, since it uses simple_rmdir() for ->rmdir()
and calls simple_unlink() from ->unlink()).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/ocfs2/dlmfs/dlmfs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 5130ec44e5e1..c1419765a8fb 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -441,8 +441,7 @@ static struct dentry *dlmfs_mkdir(struct mnt_idmap * idmap,
 	ip->ip_conn = conn;
 
 	inc_nlink(dir);
-	d_instantiate(dentry, inode);
-	dget(dentry);	/* Extra count - pin the dentry in core */
+	d_make_persistent(dentry, inode);
 
 	status = 0;
 bail:
@@ -480,8 +479,7 @@ static int dlmfs_create(struct mnt_idmap *idmap,
 		goto bail;
 	}
 
-	d_instantiate(dentry, inode);
-	dget(dentry);	/* Extra count - pin the dentry in core */
+	d_make_persistent(dentry, inode);
 bail:
 	return status;
 }
@@ -574,7 +572,7 @@ static int dlmfs_init_fs_context(struct fs_context *fc)
 static struct file_system_type dlmfs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "ocfs2_dlmfs",
-	.kill_sb	= kill_litter_super,
+	.kill_sb	= kill_anon_super,
 	.init_fs_context = dlmfs_init_fs_context,
 };
 MODULE_ALIAS_FS("ocfs2_dlmfs");
-- 
2.47.3


