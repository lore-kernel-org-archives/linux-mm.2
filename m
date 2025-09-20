Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DC1CCAC5A8
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBE7E8E0006; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA18F8E0007; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E27C8E0001; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 188F28E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C583814094F
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:07 +0000 (UTC)
X-FDA: 83908850214.19.4DAE134
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 51AB440006
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=qmfxZkHa;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1X8MC3Kv2szH/aZW8Vz8ecvuKZEkFejBxtbewl37q7g=;
	b=CA2S0zU4IUSduVRDeyfHEgY0olzgLfmnTA3Wp7Fu1HkXQ6oY1/KGJ72popRIK3/maioegM
	Loxtxh9udvTfsWND4sy5rqJUcAbpqKtL2fF4CRSSyo9AL7v3fpKtJ8UpJl84tAqChsZSjv
	UHHqOEmXBdhXJzLLzhK/Ht3GA/44XFw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354486; a=rsa-sha256;
	cv=none;
	b=E6MQ/LQky1N5dd8AYQMRYMqGDQXjerGPhCUzff4vELtn1EEMRbepxpsjkSJQ7amGiS7kkJ
	ziaC2MprrylFUOZV/VY0uI6NwhSTIJDB7fe/suRu3CJO9z0l2R+QTLdoxqMedF/hxFWH35
	zNOsMVeLK63BmwYht826Ipt222bvMow=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=qmfxZkHa;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1X8MC3Kv2szH/aZW8Vz8ecvuKZEkFejBxtbewl37q7g=; b=qmfxZkHaOy6z213r3hoOLfPjJq
	z5H9zRL8cOu1GzvBs73WpMj+FIYrP7dwqTnnSJ2WNyzAxDOvrv1MaXglsNWmTRhLlFWNTwVj5/o9y
	XjOBTMfpWSYL6tEl+iH5wSQWOC0S4dYhFKVdGR50n09pqsxGd9zpEmzyqWeIowslcjIeyBVJ/zW9P
	Kl/dzZ9WwwYl4BLeUVzB4SjeCf71sDkKYgQca2Hh2mQaJaIoAzJdanSBuHL6fKJCte90eiSRb+56n
	0G3WLx25Foc2DorqmP2+Hpw3LetMjXLyjC7IUR/7nrNv3vsSS0SGTzDYfl5P5mZ2TgLpWKrpE3shU
	2Ti5jkBw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsK8-0000000ExBm-0p68;
	Sat, 20 Sep 2025 07:48:00 +0000
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
Subject: [PATCH 02/39] new helper: simple_done_creating()
Date: Sat, 20 Sep 2025 08:47:21 +0100
Message-ID: <20250920074759.3564072-2-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wp5wwbhusojk4wherox67br1nffdomtk
X-Rspam-User: 
X-Rspamd-Queue-Id: 51AB440006
X-Rspamd-Server: rspam10
X-HE-Tag: 1758354486-964893
X-HE-Meta: U2FsdGVkX1+T1D/oSast7EbHXA3dCNDsYpuZ7dTZ9IvcGGPyrnVBhdQEdpjLMnvl0X5dN72fEeahLenpx9EgKYXAfzyw66c3geYYrGnZRAYtn8cxezlcYVMTz7Ag6mQXtHexpfIc7G7/V7RfckNSMB7at1YELXuP+1QVfBYxw/AtlnVOFLJGiqlfXY/lJKjddCJwSYQUZwswZcYtkM76nk1uxJ8vviRJoMuUwk5iYvhiaxk5dMKt1fyok09M8CZ0Wzu39N0+4vubHYyUySsnH9ONveJeopsBrswF9RBEyC/AgopPVCUVJRf1wybAaWYwVVRegLuwHgOEB/wmj8Z2tjSJMIySvB3cSD6zsapR1xXjOuaxHWrSqfhRv7z7fFpfqsmuzTz5gRjRBAnXXsow3rA5zJMVZlrkWXJZF45KFXPtJpoSYPHUOmsNEiPoQi0/9aLfqjPdCkwq6BqlWr3RSWPNfFC/PE4R/QOToTgXdGv1qIASkPYxwD1d4SH9PREFucU7fGQLl1AHu9nzeqT8MVgS6aXBBcfAdw6oVLJw/i4HMTBrUcAWTsr/s290G8KLbECQWIxvLTwwoN+9Hry0Qw22oJJLyJGNNFmqVV1jBlpQG44w86HrbKtk3hK3SQwDB/NA10KEW/E+IyGnjUFDMYffLs5HbIAjBTpVnMb9YyLyOcg2vs8dXeWIlXMMCnjaSwa2CFm6fs4tEUmf1/NErNudVJsHZ9XjqhasCTUjINvmyI2XDX+1jVpDc60a7wg7O/fE61u4CR48jyf24BIAuH9A55eQE8BYSXIkksbRW7NQqCvGe+waAQKijIMruirSWLPw2j9ShPHHGJNQE3UAMeKjOr0CVYZxlyC9DS5+47Om0StHN9AzWPsQpYHqKzCg9clXJBxhkbfsCIkBw8KAmbq3sbhMkaKy94dSdXFMtLPD8Nz1CwdniAYjsM+BVFKDxO28/cHH1zXGliXSjCv
 1pVm1/7O
 ypC4V3H/KbX9jtn89j4TMzmCeME7OaCdY+68eeLf6LdWciZenv/A1YCKU/siy2yez6Eh1svD/fiDD7kudKFgS7dwCT8c4XdiMg8PfByfcJe+7ytjnqy1rAbqa5sZeOhN94lwHjfCAwgR/8mO1shwzGI2LJ7GBYyWDri41o5gWHV1C8MVyEhGG8A37DsxrnMYc0lQO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

should be paired with simple_start_creating() - unlocks parent and
drops dentry reference.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/libfs.c         | 8 ++++++++
 include/linux/fs.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/fs/libfs.c b/fs/libfs.c
index d029aff41f66..a033f35493d0 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -2326,3 +2326,11 @@ struct dentry *simple_start_creating(struct dentry *parent, const char *name)
 	return dentry;
 }
 EXPORT_SYMBOL(simple_start_creating);
+
+/* parent must have been held exclusive since simple_start_creating() */
+void simple_done_creating(struct dentry *child)
+{
+	inode_unlock(child->d_parent->d_inode);
+	dput(child);
+}
+EXPORT_SYMBOL(simple_done_creating);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3a33c68249e2..e3000302c3b9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3659,6 +3659,7 @@ extern int simple_fill_super(struct super_block *, unsigned long,
 extern int simple_pin_fs(struct file_system_type *, struct vfsmount **mount, int *count);
 extern void simple_release_fs(struct vfsmount **mount, int *count);
 struct dentry *simple_start_creating(struct dentry *, const char *);
+void simple_done_creating(struct dentry *);
 
 extern ssize_t simple_read_from_buffer(void __user *to, size_t count,
 			loff_t *ppos, const void *from, size_t available);
-- 
2.47.3


