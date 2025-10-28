Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E0F1CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 02:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4171A80102; Mon, 27 Oct 2025 22:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EE6E800E4; Mon, 27 Oct 2025 22:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32B5280102; Mon, 27 Oct 2025 22:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E616800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:51:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B0D261A031A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:51:32 +0000 (UTC)
X-FDA: 84045997224.15.59F71EA
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id DCC4F12000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:51:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="k3/3EO/q";
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761619891;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0EOMkT/UFsYLOkQCFILn7xjwHlMa0Zq2h7YoVPTnFkU=;
	b=WyFJ7fOgV2nD7ECF2fbeN/zilohe+8+3H7hmbRqimrYVi2CzD6AqoopD481j1pck6KLXWB
	Q4QtyeOAUUqJcdCJt55E/2NEznDohqp/GBVuJosD34MaF+YTkhDv6vyNQ455igVjz3okkw
	+soDl+TgPpV1FAGQyyXzeY3nwr8EXyw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761619891; a=rsa-sha256;
	cv=none;
	b=fDxwo0OI+Ah/qzGQIxQ6f9xGz8cnxYW1XsDXOn2Zv5l+JNEoL/LV6ME9PZQn8TU9aaMq+b
	DyQWx0Mw2Oz5/6Oh829fThpnA+VtwEMkFJnDhFgXz2slnYB/n4QKbKESJmw/5IwzzyerPy
	VbfGbH7namp4S23F3DAO0QNeGPevM9k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="k3/3EO/q";
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0EOMkT/UFsYLOkQCFILn7xjwHlMa0Zq2h7YoVPTnFkU=; b=k3/3EO/qtUoRTTjg9La+IgmqPA
	j3Fr77LMk7+8F1jeQrlZWYLdQyRNkCmkV8qxDp6YqqEYNtLKEPkW3TjMzd1xQKukE4QjVxpC09HmT
	N1IdVpWkZvIrMC8lkymsc1IrGbRhdDJuLx2/xFjuuihjMnfQGCXAWppU7M3TPJTGbfaZja5tN941G
	HhHiLUw+1zz5om0pDfrEBjE3v4cTBu9bYvXPPhZ+yYSfHYjsPtUe5pkpLDQzaIhYGzNctarrH196u
	U91d62uRws8Due5hStM4w+Qvubn61E3Ap+eNSwXSLDLUIwPoTV9IaaNf4NNScmIhj9YxNqjePMScg
	EJ37ogQQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqr-00000001eZJ-2zYl;
	Tue, 28 Oct 2025 00:46:17 +0000
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
Subject: [PATCH v2 30/50] autofs_{rmdir,unlink}: dentry->d_fsdata->dentry == dentry there
Date: Tue, 28 Oct 2025 00:45:49 +0000
Message-ID: <20251028004614.393374-31-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: mh9yz67okscwdyf84b9h4nz56q7e9da8
X-Rspam-User: 
X-Rspamd-Queue-Id: DCC4F12000A
X-HE-Tag: 1761619890-578949
X-HE-Meta: U2FsdGVkX1+AWDvadUGkOdijYx2hVyMNZNB6jNHzA95/TLwKfBwDgjyJNlz4jhz/UyTtsL2pqUsZtHN7Mrs5zf9lX3WE6ukI0zim45I9Zw1W19N/9volfTxLjqr4mRmTfYcro0BMtV++V3XhqSXTU+Eqyu25KZuGIwXtqPLPS4c1J72jsiOfc8QZ2Dn4dMGXn+dQrt4Da/1ML4wv7w8+KILt7wPzi3v8vE2J9EaN2arZGbfHk5CsRWps4iRJKxDszljkpxsvED9KKl44YryN9m4ArFa/3Xb0kSf07omg5z42+oUkFzICskzReWs7PnTdoB2ChYt9zGFlmdn54gCR/vG5YNrJFZFU6KMMfjNEUk/d9vap5xgc7kZRflciMzh6GYUAUy3M6Y3pRzsNxt9j1g2CfYd79TAPZjIU//ukGDKFosXriYCvJXgoGbYviMedtUdcnZpPMyBk7g9/O3r7sDkexeVTYFFWUtl2nCBSE5TqMB5JE6Gd/mkrafjM9sjtfbs7RmyOomSIAujTrN1/UEI1xmktFOo3EpNwAJ2iZURwO52IxC+ZwDizSRQMvTApAiYJ0Z8zV3JqvNW+z+PRPTDMh/8OvMZSacuWy5xrW6AR3WzhHQyHhBmnhApDBs/a4zV+40w9mcsGBTlxTVJ2PRt61Qgxmkn1Zt1c5NAVgaOuKQRlBtKM9BFPNF5c8ojdfbMR2BvOen4zhuMDrH0/vxh7iXoddAQqtxzpRpuPWkxXYQEgDYiRZ0dpkb+dQWhU1fionsueuaTcqZLHmqpeGz8XuQ2+u4c55QJwKfUXKNVoxf376b1F/jiNFcWrICnlE3RvWhgShqW6qEEe41uMuYMvubWW+I9Uqx9FEt5xzHzs2gjGg2ymVscfawSvOd/JDS7YmhtsLTv0Sd+P5tpL33ZlCaDNxV1KFwzvgkHwIEm3wQEyQfYtrYkem3q9GdsZ6Kbyv9TWlK86rKyB9FW
 mwVdL9MU
 2e/p/JGbBecH630Gao/fvtlKeim2nU4HpBkUM1m23ihRNLUABpTPDn96N/zNVnEcWNuntl4LlWQLmoGL5ytKjjzv8uaInTxAbhp77Fz+TXVyV8hrG4yAOnsvgaV2ybZ5Kl7/8Tq5Io/yrkqTxU6K4uZrDYAWJ6YI0yd848Cv4RHMHFxoEZw1RCLoUgFPIGdHDZDZGyIlsfova5iJS9wTsN6LcWQYKIbhfRw2gqiH9mOqdOlR2c7+xM1np7RiR1O+vDS/OaajnuaOqsGgonVGGM9JhJwjQL5RCrvBhxC1TWYYLO+0RMD5mIB1EKxFrw/0f3pgI5d2oJ2mvht3wiRc3GEGZs4BYWxrxawra0Vfb2NdD7ZlRORGxG45hY4OfTaxlMHuY8Jrhy7/8gUj/0vbDOv7ICJUSYUhqwivI6msLI6/jbbDKvn9fEOouxm5jcoOplq4I4MTTQCjOa5TjIG9MP6VTOvedUmSlM7L9rE317vcQ1b6No+upRotuMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/autofs/root.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 174c7205fee4..39794633d484 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -623,12 +623,11 @@ static int autofs_dir_symlink(struct mnt_idmap *idmap,
 static int autofs_dir_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count--;
-	dput(ino->dentry);
+	dput(dentry);
 
 	d_inode(dentry)->i_size = 0;
 	clear_nlink(d_inode(dentry));
@@ -710,7 +709,7 @@ static int autofs_dir_rmdir(struct inode *dir, struct dentry *dentry)
 
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count--;
-	dput(ino->dentry);
+	dput(dentry);
 	d_inode(dentry)->i_size = 0;
 	clear_nlink(d_inode(dentry));
 
-- 
2.47.3


