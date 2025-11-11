Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23C40CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B7948E001C; Tue, 11 Nov 2025 04:21:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 767FB8E0002; Tue, 11 Nov 2025 04:21:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A5218E001C; Tue, 11 Nov 2025 04:21:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 595FB8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:21:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 05C6812D1DD
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:21:35 +0000 (UTC)
X-FDA: 84097783350.19.2396FE0
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 54BD120007
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:21:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=oQsjlNA0;
	spf=none (imf03.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762852893;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h9ER29fbTJgjBa1gGf0LtXabL8srR/KWhHIa5FKJzwk=;
	b=bef6seNZq2jEm2e4OGoaKBMbwPo8J9FnZ21QLEfEhLYl8zr6CtUX1KFWY6TFmEzP8ygfSg
	wfPb9rOQpEKgeY6HTtvAwmAKlqDip00Lllg3i/oZb4YFbKpM+jc1QMul56wNC5m+31SGHB
	mg810/KIrtX9vXMsNlNiGBx8/tJ0ml4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762852893; a=rsa-sha256;
	cv=none;
	b=R1m7fARFu0nOf1vfeXxwHhYXpCtsrOdHrUfkFqj4iF6JqMPiMIo52CY6qr7h22hWUvh6zl
	pyzPhrVKvo7+P9x9Zo61rAflu63S+bBJBBASkWZAf6Hm3uFDBkpFoDK79N1RpLvFx6XqcL
	bkamb58UQo0PFfY2W38+MDdJLotQDj4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=oQsjlNA0;
	spf=none (imf03.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=h9ER29fbTJgjBa1gGf0LtXabL8srR/KWhHIa5FKJzwk=; b=oQsjlNA09lydyaG8FeEwSV0XoJ
	PUWsxqhIyS8v4nFPrdoo96yfcVKpmdff1gejn53PbFOVMACcn6fe7mJoXdScunb2j9pVWcq9ijz79
	vvmfnDQnEQ7JKbik2NCvovbfTo69xQuIggh4zPsb1p/Upe/eH4hziX654BCvSmnlJ/k3FfMOIwbJF
	o8q0WnptvwFpYe5ZM/6npRERUN8GH0zJzilKT37w5RGhgnp5RPBoFufvwG8Sk8nQx5BbD+To6YWvp
	cDz9q86r/3rOH5cGFEWaBhEpqEMRUOkTxYFsXrqQIxijoK5+8o3fyMu4FW57NIVo0iyE3kHiX/kFO
	mTLjKEdQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHo-0000000Bx7I-1Uv3;
	Tue, 11 Nov 2025 06:55:28 +0000
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
Subject: [PATCH v3 38/50] gadgetfs: switch to simple_remove_by_name()
Date: Tue, 11 Nov 2025 06:55:07 +0000
Message-ID: <20251111065520.2847791-39-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h543gahk1p5arz7kddip8gwgwqqkdxwr
X-Rspam-User: 
X-Rspamd-Queue-Id: 54BD120007
X-Rspamd-Server: rspam01
X-HE-Tag: 1762852893-356299
X-HE-Meta: U2FsdGVkX1+AKwixzNhWiwB85ZB8RGRHzLRB/KNdJUEbHKxcRJ8BLiM1e7d2PY2NQlqydE2JcEYeGreS/eZ39ErnSPAkIH6TeRWCdV33s36CIf12ypRj0vrQQvA9AMvnaMAVuvWbk47i9k0NguBgH2HzYLo+Ne2NfITrlGWFbalh6iRsJg7Y+PV7BeT40vhpnLZcTUY3+msn0dhetBA2aCOGE7J86XIxlPgQAbbvK3hVSK1N+RJMpgB0NcYBHONla1jaeElvDfRBf6DA4jIj/1EU0CNVsBv9r0+tn81atLznG1C6vMW98+nkIEK6hwv59ffO1E4JYgV3VwK57f7Bs9vPoX5VasPld3J0eC/unFnRluXhsHdTN7LUr993HUd9Mm1pxL88kITlK1d4psMOA3d1d1oe1yLK+GkJMdA2+JBB8BzUcQVfnHzry73ISMfKF6TiDAZn3WymLUR9d4QRmhaFyVfyypVq5MeH9rBooSl3QsZFo+0oeQ2/CsPCZp8C6ZPTmHOd4Kyqi9K3Ww6TUmWyl/lLk/XnSS4sO1OhB4CbLZFv4uCfSJysu1//3yhkT3oktV6T38n5onGryG59s6yS4PIFWUqjvokEx6WApBXLjI8QrqZCr6UF/CUjTKlAx090L50Cw6oKCnZ52XxIHTZSMS8idjnweypJ8aCXkS+ggODyb/T3EeMciWGkx5CaTFeLOuq4KFtN+XfK7uGPdBrgnqAikYeAVCearZfutdjChRSQValmhwCy7V6n90p6jCKSxMa040tpagOoyklv7FwdFUjhkUu0LCILDlsfo4IQZ6EQaKpuVyZ4Ro6jRQTL2dmxqsMNdjuD4LmeghloTdPSxSA2ZHcU9H1ukt4WsXjbb7Jk2fOkN2uQW/qi9jweM3k4x/iPoh+1aAt5ujAb/M4Cx75D4wxz+1tYuUWJVjTrGMp0wCerMDT+TLwdgimdtHjXeNfmG/Gf2SXnup+
 N8EFlwDR
 Bxo+ST1JyyhBUuk3+kdHDudwdyewkV4stNSbJSxbLkuSg2E3X9VGCyc2WLFBTQ4fH3jABN7LDeYgbgPvpd7wB4RR36izuQe9EvgarQSeVy2PLlp8+RyhCGAc/eybtxkBhUXZJAxdJVg+p6XjfuSyZo72sSD7fUMhqqVUN2Ps8hfss0ZV+zxCWj793GVmWdOiJqKFPRPKSduYHiz49G4U7gC9PRaydsa3TCPGcmNb/tgpSoxhNGoR2fA1T/P3kJIOWTXSevKlcS3cpJEShvSJNSoqoPlT59i18gn1lHblYZXTKCIXhDnfRCYhUFvDtDkZ3tbRJdaFj/VD/z9dy/lb9oe1oGeOapMAgfiZzvH0w3DjwRsUNW2DozzB8o3NI6wCIv88veGCKnPEPOoz6pg/LxUPRdvnh4NHaRvlzmgbF7tq2f8FBm2ycNN+LSlPSAUK3Y0NuEoUP1j3pMu6C4a/o22ATMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No need to return dentry from gadgetfs_create_file() or keep it around
afterwards.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/gadget/legacy/inode.c | 32 +++++++++++++------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 13c3da49348c..bcc25f13483f 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -150,7 +150,6 @@ struct dev_data {
 	void				*buf;
 	wait_queue_head_t		wait;
 	struct super_block		*sb;
-	struct dentry			*dentry;
 
 	/* except this scratch i/o buffer for ep0 */
 	u8				rbuf[RBUF_SIZE];
@@ -208,7 +207,6 @@ struct ep_data {
 	struct usb_endpoint_descriptor	desc, hs_desc;
 	struct list_head		epfiles;
 	wait_queue_head_t		wait;
-	struct dentry			*dentry;
 };
 
 static inline void get_ep (struct ep_data *data)
@@ -1561,16 +1559,12 @@ static void destroy_ep_files (struct dev_data *dev)
 	spin_lock_irq (&dev->lock);
 	while (!list_empty(&dev->epfiles)) {
 		struct ep_data	*ep;
-		struct dentry	*dentry;
 
 		/* break link to FS */
 		ep = list_first_entry (&dev->epfiles, struct ep_data, epfiles);
 		list_del_init (&ep->epfiles);
 		spin_unlock_irq (&dev->lock);
 
-		dentry = ep->dentry;
-		ep->dentry = NULL;
-
 		/* break link to controller */
 		mutex_lock(&ep->lock);
 		if (ep->state == STATE_EP_ENABLED)
@@ -1581,10 +1575,11 @@ static void destroy_ep_files (struct dev_data *dev)
 		mutex_unlock(&ep->lock);
 
 		wake_up (&ep->wait);
-		put_ep (ep);
 
 		/* break link to dcache */
-		simple_recursive_removal(dentry, NULL);
+		simple_remove_by_name(dev->sb->s_root, ep->name, NULL);
+
+		put_ep (ep);
 
 		spin_lock_irq (&dev->lock);
 	}
@@ -1592,14 +1587,14 @@ static void destroy_ep_files (struct dev_data *dev)
 }
 
 
-static struct dentry *
-gadgetfs_create_file (struct super_block *sb, char const *name,
+static int gadgetfs_create_file (struct super_block *sb, char const *name,
 		void *data, const struct file_operations *fops);
 
 static int activate_ep_files (struct dev_data *dev)
 {
 	struct usb_ep	*ep;
 	struct ep_data	*data;
+	int err;
 
 	gadget_for_each_ep (ep, dev->gadget) {
 
@@ -1622,9 +1617,9 @@ static int activate_ep_files (struct dev_data *dev)
 		if (!data->req)
 			goto enomem1;
 
-		data->dentry = gadgetfs_create_file (dev->sb, data->name,
+		err = gadgetfs_create_file (dev->sb, data->name,
 				data, &ep_io_operations);
-		if (!data->dentry)
+		if (err)
 			goto enomem2;
 		list_add_tail (&data->epfiles, &dev->epfiles);
 	}
@@ -1988,8 +1983,7 @@ gadgetfs_make_inode (struct super_block *sb,
 /* creates in fs root directory, so non-renamable and non-linkable.
  * so inode and dentry are paired, until device reconfig.
  */
-static struct dentry *
-gadgetfs_create_file (struct super_block *sb, char const *name,
+static int gadgetfs_create_file (struct super_block *sb, char const *name,
 		void *data, const struct file_operations *fops)
 {
 	struct dentry	*dentry;
@@ -1997,16 +1991,16 @@ gadgetfs_create_file (struct super_block *sb, char const *name,
 
 	dentry = d_alloc_name(sb->s_root, name);
 	if (!dentry)
-		return NULL;
+		return -ENOMEM;
 
 	inode = gadgetfs_make_inode (sb, data, fops,
 			S_IFREG | (default_perm & S_IRWXUGO));
 	if (!inode) {
 		dput(dentry);
-		return NULL;
+		return -ENOMEM;
 	}
 	d_add (dentry, inode);
-	return dentry;
+	return 0;
 }
 
 static const struct super_operations gadget_fs_operations = {
@@ -2059,8 +2053,8 @@ gadgetfs_fill_super (struct super_block *sb, struct fs_context *fc)
 		goto Enomem;
 
 	dev->sb = sb;
-	dev->dentry = gadgetfs_create_file(sb, CHIP, dev, &ep0_operations);
-	if (!dev->dentry) {
+	rc = gadgetfs_create_file(sb, CHIP, dev, &ep0_operations);
+	if (rc) {
 		put_dev(dev);
 		goto Enomem;
 	}
-- 
2.47.3


