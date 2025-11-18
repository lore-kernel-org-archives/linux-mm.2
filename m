Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6212CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 08:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9E928E0006; Tue, 18 Nov 2025 03:41:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4F4A8E0002; Tue, 18 Nov 2025 03:41:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3E348E0006; Tue, 18 Nov 2025 03:41:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C275A8E0002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:41:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D8F0140434
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:41:34 +0000 (UTC)
X-FDA: 84123084108.11.9E8A1BC
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 888118001B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:41:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="qOQ7/DBF";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763455292; a=rsa-sha256;
	cv=none;
	b=piTRhWKV05VW9E9CgE8foxMLWO6WpInyxOeJ6sDxNyZJjKoVwfRtT9R/ofP1oSiY8VK+g9
	xP1sB0NzHU/J7QkevqtplsAeVpku2FIpcJfOuWt6LYSTmejPF7ihJRXJJ2lY7dxA6rzChS
	oSxHqXP0epCgxsuHMaO8jb/ZwQ6A8m8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="qOQ7/DBF";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763455292;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AovK4oTG8i9mD8KDrbZrZDCi+2Kh5o4vX35c5oMMEjA=;
	b=TFlrulijRfvX1Waby1Ty5CUztgCUxYbHqzS3SesP62yvgmSg1rjEWX19Cwkbl+Z8PHPsDL
	hI6vYe8kjiNciRQMHAD+riMvdcoFEc8FCpMQdswM1yyFhusv9NEl0+LvRl8DZJWCW6BfDg
	NmZM18QNY7jB2tDkAZwpHzJgp7FuH90=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AovK4oTG8i9mD8KDrbZrZDCi+2Kh5o4vX35c5oMMEjA=; b=qOQ7/DBFaqgk44J/G3Cq0lvalL
	mE6TeOcAIblEo2GWsJogLXskYnARt9irhLbNTO1yvrE8mNMIID5DaCngGHuFaudutnqy5vTr77+RE
	Ua2TTxe8h4d2jRuSeexhJgmxuEUOqLFe0vEkpT0ze5X8iIfV52TbzrZou9Tiw6YTrEgyp7vDf4JTa
	wB9fRM21E/zDAEwz7W3Ys0kvRmypLaGnvEliBh5dI8XNeBMp8pBNrxrYcXDO4zcyxJiSGlQudDnjd
	pBAgnifT2txEI21XJ62edGdZIhNdGkJkYqNDmWESJgKxxVpIjZE2Zc0BzPdwn0Vm2KfuET3ZSLjcj
	/zGGGKyQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4V-0000000GES5-37IK;
	Tue, 18 Nov 2025 05:16:07 +0000
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
Subject: [PATCH v4 25/54] ibmasmfs: get rid of ibmasmfs_dir_ops
Date: Tue, 18 Nov 2025 05:15:34 +0000
Message-ID: <20251118051604.3868588-26-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 888118001B
X-Stat-Signature: tnpt6zhtma3fgc48ez8j6w81kjidp1eu
X-HE-Tag: 1763455292-886285
X-HE-Meta: U2FsdGVkX1+pWqx9RoDtKk7uck4Is3WLCp4ZF1GZFr+ZH6TjzzU9I1+ih68YGxh086KU+Ia3MHrafIYU9nbAvxaJS8XKClb/ODTQOL7S1PQ26Plua2VtRnchltoJSlUF2tNUU0LfgBvUF9J0VGMY7s8J1D8y6vtZzvpSC7ywwQi+eVxBprE9AgnN4KvVAQ0kOGZbj/e6OssULF71N9nfr9iEnIQ0hEEiWpl3tkYa8g9nMXD3JRGUwnvSO61+IR4OhgfOjVv0QJ/+z41ZSJyapTQKMwp0ijCg933Jz6lHBHx8FM9BcXt7R7kN4G7p2D8WvXZrV0j0Ebd1HPJe1GhA+MUH9obm04BQNCHSBoKuqc5ARdCfxwYUKDUnlX8Rnn6VtjV3mjfcuwwD4nTP+9y8c1zOtpiVrDXQgw6wtnIyrxxiqdGOgG9RAJxInkHT48me7LsBMp8LIIKu6OZ4ln0cBKqdNCARhdTJt/BaTZrfpDIbsY9h7rShSQWTuC4/SlwxALf/3/loB3gAFokene/kNkck8zZkwSNpSeFoAJm6wqy7xPb+5A+CVTBgHSt0tUMKljz+1FxEq/Py1n+vVDXihVvWlW0n5xJZ/JFEKvmIkHHhsk8vnvWLNcOwOPs6gm1cW5oJIvAbFYMWm8zYA2ataOJMyCM0A3B8m1KgnqBYabtthBDO6lenw/vYVU/1wtBBPfLlpXneG3W776cmoPaRplealWR9mXLQDq95SZspA4essrvRZWHIh4vDYS5yPyii1pgiPztUKXesQQcsSc7PDDz/BR0EYU9ozmziRwBmRoIeYOM9mjkY9nx1K9AafWZqnbYa6bnOi/c0YAsYOJX1/Q88wGfcfaTUV2utJI3KKuuw52yKDZQE347zOTuADP0IUPBD3lDWuzuXHzg87+x/VzUTXjYyxa7/bN5vW2vuI7spsMFu27fi5WRbTAAtnlqtEEB+3NZT+Ru2Dq8AX7i
 GAk+3EaU
 0kZUzjKc4H5r1nZocvKs4UNo8foDS85z/9bNRa/u5QjfMzZJOk45GsfxvC017URDQGU/1NPKFLK9gH2VwejG6jJ1+T3nTlCLN+W1xhJC0fTzCwsM+nV8JipnHslDQW+sYL5CkxjQPMokEwEeXrIIRLNOKiddIxGyQYDStXVg3mIBaGWUlBy6KDax3Jdltdb1stEAzvnzHq2pQZjA+hh+Mbu0bHFu9CblvNRkuV46VbVpM2I+loZaAEEpjhm8GRp8Dw044kuZQd97mB5VOI4WAupPJlES+EjFmBvzvjsylbaGuVmYcRJsrHI4lp8tgDxFnHgsKXYRD7M72Ly8Klj0VdNdBJMaTLYTKPnMMWZKoCT+PVLcE/PnXO4dvpp7sC3G3NUGtpgFA8DVWhGgQodhdfiwQOQJddlLMQ+zMWbNAyyPL6dsm3pFE1SjfeXI/ig/U/yvNKMy90vvexsB+2gIqOe+4eQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

it is always equal (and always had been equal) to &simple_dir_operations

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/misc/ibmasm/ibmasmfs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/ibmasm/ibmasmfs.c b/drivers/misc/ibmasm/ibmasmfs.c
index a6cde74efb68..824c5b664985 100644
--- a/drivers/misc/ibmasm/ibmasmfs.c
+++ b/drivers/misc/ibmasm/ibmasmfs.c
@@ -97,8 +97,6 @@ static const struct super_operations ibmasmfs_s_ops = {
 	.drop_inode	= inode_just_drop,
 };
 
-static const struct file_operations *ibmasmfs_dir_ops = &simple_dir_operations;
-
 static struct file_system_type ibmasmfs_type = {
 	.owner          = THIS_MODULE,
 	.name           = "ibmasmfs",
@@ -122,7 +120,7 @@ static int ibmasmfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		return -ENOMEM;
 
 	root->i_op = &simple_dir_inode_operations;
-	root->i_fop = ibmasmfs_dir_ops;
+	root->i_fop = &simple_dir_operations;
 
 	sb->s_root = d_make_root(root);
 	if (!sb->s_root)
@@ -188,7 +186,7 @@ static struct dentry *ibmasmfs_create_dir(struct dentry *parent,
 	}
 
 	inode->i_op = &simple_dir_inode_operations;
-	inode->i_fop = ibmasmfs_dir_ops;
+	inode->i_fop = &simple_dir_operations;
 
 	d_make_persistent(dentry, inode);
 	dput(dentry);
-- 
2.47.3


