Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDE5DCAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A3038E0020; Sat, 20 Sep 2025 03:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6450F8E001E; Sat, 20 Sep 2025 03:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50D9C8E0020; Sat, 20 Sep 2025 03:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 387178E001E
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F3D671609B3
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:13 +0000 (UTC)
X-FDA: 83908850466.26.AD3447A
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 57A01C0004
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="nu2DxVc/";
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354492;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rRHh5JUIce5mWQsV9mVTqyiiQAMXVbnbpesnzOQCmz0=;
	b=R5oxD9TGcvO2RxhEQ+0VKTYsrYIw9OcF1S1AOUeAVHULhyG01mSZGsnk8Nylbq877N0aRP
	6/AzsprB7KocRh5uiU+AcL8dtfChzFU8+yaxaqbqWiFv2H3TXsAFRiTSJce4QLl/XKQ/t4
	G8XBP8qgB2nfw9KdixZVJwmPHqxMHh0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354492; a=rsa-sha256;
	cv=none;
	b=uudyst8qcYYX7livQYfD2txjmBuEk22SKLtCLKlr0j+PgzcA38pySKOulz2Oa3qDfwxkuj
	zp0pXn9xGUx4UogwbVKLFD7oejK3D3G1irtbzLnErvcPLRxHHpAScWYBjIx7nxlBuk/09v
	UGbBeOFd17zcOWGssZ+q+s9qjMKNTpQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="nu2DxVc/";
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rRHh5JUIce5mWQsV9mVTqyiiQAMXVbnbpesnzOQCmz0=; b=nu2DxVc/ftXlRw40lhs+lwWyMV
	n0jjnB8yes/L2hwipkC4qMgI2CxPE+uBARDpfFkpfh5X4qIBhHQW+BQm7JMsJyNO3eul6XsHlEh3E
	ST4hGZiCYQ5EQXCxieh9tNzAHEZpOcansaUeouUm7Rd09xGVuWRAKkmGVrs0MSSxeAevKdIkAfNSJ
	otjfzXdV+bL6aQM5I+xqOYDLp2W9Wa78rvxJqs8zvqFNk6A9zePHXRvDPrx8/8aHLEt5/0EN4cXMv
	xPKulAIcIS6MyL2f8jyGywXV1eLDYLdhMp/fXsKuHGOpGoh+0b93X7bYEz4WOv5eESzdk4X0wrdSc
	KNss0+iA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKH-0000000ExMd-05vS;
	Sat, 20 Sep 2025 07:48:09 +0000
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
Subject: [PATCH 34/39] gadgetfs: switch to simple_remove_by_name()
Date: Sat, 20 Sep 2025 08:47:53 +0100
Message-ID: <20250920074759.3564072-34-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 57A01C0004
X-Stat-Signature: pmrfr6tzpfkc918jox17zbn18mdukhif
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758354492-971671
X-HE-Meta: U2FsdGVkX18D2MKxtNNbMqfs+M0Ofao63CPSZPArScpskj3Q+vmai9eQBpuG61y/D+WRVKSXM9R97c8mQ79c5ZQetmezwJ0LCr65GCMyws3xWsuEx2RG2g7mMIPH8PuUeJ+iNFAG+WouKdmSnPXXHUui2703vqUa0tNLca3++EZqGXsYcyDoyEMRUPxYEUYfSeUrCHAPyRoZm7cZDwaZRyrs0VYkjNB1um7OSr6hH0HYZCPx2dH0NZcSosq+zC6BC6mMMAYZ94YPwGOIzjOP69t8I9XFX1UvcAdVi41MRDGI+1JjGkLeALmYcPyBFk3UM5dgCVTKAx9TMnpwHqox6vZGvcSJD8xbjjmbfvC8VPuQrYR3Xwi4WJrGccv911cvnhNYNQoJCQy/ac+NNKBFGwxgCnVlb2jw0Bsp8w2PMe9d+/Qh9ykqXMi2uXKCnR3wVAotledN/aOxDJehBbCV4RXp4tTn2HQXxvVeqJj3zIqlHaRA6st7yv8ggVCMEMfok8JBoa5QKl560NOj0lmCJdCdC4hkawCJdZNG2YEg9i5I8aVAGWoXV8h988G5zZaWMPs3EBhECr4Y7Ju/++vqUfkZ0O5g+2UEmisxpq239Fboww5Y/qX9UlTmfESEN4FLttkDuo+cA+oeu46iPOlayPTybqFpsf1YUiIH1+HbRfksuzCyDLqXgGWQDBHW7XD2Opoh+XHj+sYdQaz8cwGB+K8/bZOv69UslAltbnl5eKEZ61DdnbNbPKWeWWeUOg2EUdHtdxd3NjphPoZQ9WG+DN6lWaXzwo1mF6xIebUhxloDSASRXz/CXfe5KTmSGuPHAuWJzu2KXbqJ51oCZJs2rH+8YxQNHsaqOme2PvWZYbr0uulO1gPimNTZhLMaafZKzXfBTDD12vI7hy12YpwXwcVyq3xiqGfXD00aEgr0JL5CObZi80DlUY+1AEb2QWUjDRdUNXPglsJ9RS4u682
 OA6W4PN4
 Y0NuTbAaCYeFiWiipBzWd8lAKzeCENpZ7mVRhJPbv5oO9OMxVNFMiUFcRJnl8AC+HoENVpruqsihAyTbNtmy3GANYfb0fJOi+wgJ1v8gWbk+s8ALaW6X3T4Mg33h1+K3bdyAAZQpLlJJy1c+bwkLwXoSXpi9C5yJDrE0vfGrtYG9pK4/ZySK2rhUnsHTOduzlBn+cqD6nZ5VzZZCvBs/gK9fZmOs2u3J+KnZu1Qla6nJ3fVq0LSPoX1M94HdfflEGRzjuwsKF+Qqp+qcBBu3iVD7FEBr3YG9kTD3itSjsJZKpM6MkpVuNcZPe32apA4LX54upOvxbLLVTGycHWRg+539577KTT1ZjjS++EpTWmluzMe59zY9eh+yfUkddnIOxeO5e/W0jNFnyeSx6v/qDqXWLkqTwevOLYC9WW5qmiNNECEHnQf5HtB3NmxSY3QQdNwnpeFoyYVDTcCUmkAxlZNhuUA==
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
index b51e132b0cd2..fcc5f5455625 100644
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


