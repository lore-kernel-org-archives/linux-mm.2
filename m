Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65D0BCED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0AA38E0015; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A929F8E0021; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4588E0036; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4FF9F8E0036
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15496B8B70
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:16 +0000 (UTC)
X-FDA: 84122566752.17.025B303
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 650C0140007
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=rzQCg5lh;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=zmWn1AvLUusNhsu/0/DVtVYRZZl29bCPr20jaGU1OauCw5KwbTu/hlf0NQZMNwEoYtliMO
	C9qrr3A36955TYv308kqvQsKFenRhNz1qbMhQ+gd2u3Y5PMuHcd15F6IOe0+MllWKv4PQb
	PW7kW96JTfi98uSi2IgVlY7N7xxgUYU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=rzQCg5lh;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h9ER29fbTJgjBa1gGf0LtXabL8srR/KWhHIa5FKJzwk=;
	b=KQ5oiFsPlakv5GJDpC9wapETPxHfnEYel8YIt/WF9xfGDq47NseNBB+cO6R/Un3M6aCu8/
	o5QCD0BZKPtJXmT5eoHVsI3yDdH/Hcr0wn4lJRzrDSraPTl4giE0TPA2FaTSS0twuPVN5e
	CmlaQexz46hNgwDFyjO7aWypl8oQsWQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=h9ER29fbTJgjBa1gGf0LtXabL8srR/KWhHIa5FKJzwk=; b=rzQCg5lhFgfrMZlOVGl6dExZ/a
	d0AgChO0Od/vBClGgnOu5Fjd5tl4dza+2pw+6RbcoI/f4TzFLHPjRU5qnY9douyr6yZfFvzXeiNCc
	eOk1A/AfCZ2Fq9xW+wz6Iqe+G9K+8nuPPSVS6n3g9BfJxSh5M7HlQ7wGAr5JQXKfUHF8uLZ9hy5G+
	xDwykHVpmx3evybIAKrC1sf5vcsJi02w5hG99QhujDNzHfiDW0+GKIhRq2eSwYG8ZwA8dbSKiOQnk
	GnJYztrt9p6X2SHG0V2njXC+vTfxmOCaE3Nz/WzhcwmKIAz1BWSlmOecW8XBg5ia5hN5eImMb/kkB
	7GelKqYg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4X-0000000GETr-25uP;
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
Subject: [PATCH v4 42/54] gadgetfs: switch to simple_remove_by_name()
Date: Tue, 18 Nov 2025 05:15:51 +0000
Message-ID: <20251118051604.3868588-43-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 650C0140007
X-Stat-Signature: cetdi9q331ttjhfnhf5cecm78gsr4xes
X-Rspam-User: 
X-HE-Tag: 1763442974-70973
X-HE-Meta: U2FsdGVkX19IObSxUlpeaMGSuj8pulOJ5W1iwFlSaBUzndbXfh+S/IdUUBm2OWQ8r7rWmiWu9BZ9t+QxwfyZeB4/C2rloxfI+nJsVbwF/rbuBBb6HRG5Q3Wm4c0XzQ9f/wFooZoR9sgwpsou1FzEq55CDW3O4InsuG7pdVWAwFI+JCzlloj2FCVeyZm9YnqsD0VD2V6jFt+B/8akSSnjlRuA/406VNTS50RxeHqC7TCGM5av+bFVNyM7XHByHAXTlBNPy/4znaAJaplkPMMnTbRXI4LDoalTp1hR1vFlFXoJbWh2NhQGV7FKR3jnqkE590uD7MIq+Pn6SRbt/Be7Qt13gsKResRnBtWwMdprj7VwGQcVYDa/SGNn7pJRduGV82A8+A1gHq51uCGuw4Mx7bXX6iSiEjiy+0qAYOsDlyqsmtJn8Lige1yBXEGsadEtJVntbfdJq5IEtkFiJ3d39dFOFzgq1nXaFDohUmzGVz0p0q4XwlzIjXqR/1qrFf+Ke2o4xCJpmUmlqBvW3dIY+wYvFxf8k8bH6GJTZyf9UueGS9JkHcDWTZKx5oAkJFl3vZGi1QTAyt694gO8tUrJyUWHfnhtHTZEcA512gkGYkrKUxjNLBKJOeW5dGukBez6KFSa1/SoJibOcMMGvyNPTB5WDdFI1SWnGTBsJhV99vnJwMZtSK+l3mk0Ccz1MRWUnezDc6KZPe5IYcFaqtqmB5Mi4y91J7aXX4Zg4oNKpcmXNhTrbpXuPaccxlzvvZSoygFMclOlz0AGAX1W2cocubig7RJWiWBSGihLmlIi+DCZsJtjFChxx+C+zZYGG6SLlY3m4X6/Ek9QuCOlMwAdNdo0lYtBKJz80n/mpHIaPyxNFAhud5XTIOv+zBDKNEkUMC6FAqATx9e5SDmbXGvq+dlJiuSI5kz1xBDjqDOKAcLB/gdg2k2yqOu9bqmtCCCdx/TYZXrL4yoB6sQT02t
 dKmfWhwk
 0/0NT/xBibVwkgSKf9IMWkhTlt4JiteGcQtuh7LrkXBt6qZ/FNhbZuljjlDDlmiMr/u5R1IFGGehauYqL2RKCyD0Cfkk7iKWwHRvk75kjcrC1gjuu4zXTTTWoqpXIiHbuopNq/ZUWXV8eagP9uTpLVHK1mdTPdQfhysui/lLJdnynnFMbQgubBL4wxfhYOHPzv5i/A/WXVcmj5nym9d650h5Tep26XQJkwcAhXlXlR9yO3B3SoEyZINiZXtv/AX+lpgBXhDSW2+wIvB+H6YO5+muU/NZdtRCcUvCACyhWCSLnbLViePCccfe7FudjP4VmC/xzwFL9Rj8rWExK572AV8Tmhqy8NUK425VlJrsNCSsxFdENuBT4m1PFn9yswTsdqNu5x78myRCz7h80uPG5wYtgBG11veKbuW43ZOvN2prpPgG+cuarntp4NTr5nw/hvm68xkvoLmyyz4u3t4VwaGbaTw==
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


