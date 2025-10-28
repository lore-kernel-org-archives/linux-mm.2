Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72CD1CCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3321800E6; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32646800DC; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06830800E1; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E898800E2
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE66313A7F0
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.06.0E1BDD1
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id EF0441C000C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=svrtyr64;
	spf=none (imf21.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h9ER29fbTJgjBa1gGf0LtXabL8srR/KWhHIa5FKJzwk=;
	b=i4YsydaohyURxsvIWohnsL8Zaxg6dO8xgKAdQ/naCnBc2aCbaRBmfEJ3dHNZBJ4g0U81V6
	tJ9jvvaLMGI0YxPARd5//QDXhkXEDQAJEuISEZGRLcXl9LFM1eVaINSJKHSpOT4kQjaHzk
	2j9JjYJMfF769Cvj3LlyBdcUkHLq0to=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=svrtyr64;
	spf=none (imf21.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=0T9eIqf+BOoNAFmBg6Cy+82+PIPcZDrGwzBjdko2xHhyIn6DcBP/tYeVnLFKNxcWJihDob
	+JG36Juj27SwshlRnSGyME9TO5bhi6/sHMTyJCBjBYy6VqEk0JPMUvWqzGTDEiJbIJB7HE
	eYOikUXJp6e+1Om7B4MDOZJRE4eAszo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=h9ER29fbTJgjBa1gGf0LtXabL8srR/KWhHIa5FKJzwk=; b=svrtyr64P+f8y4UQ14XiZrnvbY
	U8nvU2HTGKPb2Dixbm/HgRUzlcWeYZmNOij59DJ1Esrn16p4qSYwKE6eO0+HLdEUvBruEBJZhuwhK
	1TIqKSv1xn9YNNm8f4D+3eDUZ7bPgaLzSBFiWT6bOlAIvV6LU3nsWVKXNs7wQiZ0rOLJxMJBbprrP
	cJ7p9byjj3ZLd3MRD4H005lq+VvCyGwuPvM/h7aLREFWM/pyW9435dmXk+DccFTP//zJmbB2j4z/4
	FGbAwpIV1ETEwk+wvvTiW83+PBcyFf4aFPVTlclNeJyd4WjNSCKRDaFG66uZDOlfu735e4oGnE0ry
	NGI0ieaQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqs-00000001eb7-2n9C;
	Tue, 28 Oct 2025 00:46:18 +0000
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
Subject: [PATCH v2 38/50] gadgetfs: switch to simple_remove_by_name()
Date: Tue, 28 Oct 2025 00:45:57 +0000
Message-ID: <20251028004614.393374-39-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EF0441C000C
X-Stat-Signature: 1jr6gyywrqjqkez7aoztwwrsfxeruxzm
X-Rspam-User: 
X-HE-Tag: 1761612383-680581
X-HE-Meta: U2FsdGVkX1/NJa4ZrLTrKKbtoNYe1tznoFWwp6X20QW81gSkJHLpkmf9PsjN6TVY+MzERTEr3oZX8W2tG2sjOhf5ddH7gzTrPr+wslXVlYZj+toBRzXDVjE6HiENP2T1OO5gp6Mb4u2PLlCcgyo4Bl9IawH5zq6dOFHChWM/g18Q8mg2pKMnH+jsaRQWDkZtOkR0s856usxq6xM6zUOTLC6FVAT9YTN75YYYnPimeGnr9Ge7xdzvvUl/FQkIBg0EKPyCmoDwCu3aB9LGiFA9jwjH4A/N0vsyxaTj+hGxPI3ZJOQrFFhZaTLS9ZSjGTBcnIl3hmivyo2rNevWT+5R+7KIDNBdIzD2TFDNvNRW6ArETPRf9EGhqyXEv2YKtCRRCTKkM6cQo576hZFcHhGqpolRcDjlF3wWg7xwbEOJcdT+P18DTrsiZ9p2p4ByZm6Q4+svY0vbSMK6tWZz+TDRlH2Cxxmom7E8lAEZVG7hGdRpAi1aPknPuJM6IuGcJsF8W7kd0ocM/MnoJsz+hUTaUFQO9MWXbDbhEM/2qDu9TkUHceCZuIc4Hq5mGRC+S/aikl02GSA7fYtX0/bJ8js0Bm1Ikb/XKQHDgn6VUXN9cPSjmiCtvPuWFFIPiHiWEbEgcHd4pUqT62OrEOQuJxnttfqMi9NnaDG/eG8oFZwS/yhVnpCh96guCIhAsqb2Z/BIYtSSxq5jexJRPpoZha9DYUictvUOiTBvSd9pdN6GgV0p6Zqd6br+Xk/OIV8NvYI9Yal8GaK8cU1yyRb15cD5z2DdNmGty2vdXNheFhnVeG/qXc+wJecIeMTKF+FoBeMjHq+VenStViS4XjPQ/MBnJSbFT76/nWge/vde4DDPTH4oZNkvEavAf75k/kMiBL1KhHQaAedQf6upyi/7+F8DmIgKlRh91B3eQHPUEhHMjGxV91XnyFC/aYwizYfL526dne6AKGlPr9Fqwb4MLHd
 mkCxb+gS
 wPFK18JSav3+dyV8wHsKLSQSEHXSuGa472P4bUBOAUkAQreHbKrRwrThXAlPodXDI5ffLqc4JBIKYUen9ETWaPryI6H1vuKvULLczv/lhV4VT2fYhYBZBbljCVBnTb6LmjxT8yOZSYAMz1eLM+Wv1kTUTHJllUnNQuPRtGMVr2ZWMMgLalMFQ1PzvQHWSFbn4WHzRVIGTAId5Oq+jV9qBLllXIVmPEl0YETcdTxsT8FAuwJ2spPsOGPVolIGJig16my8rw3IhjM2ftcivbuoYgAxIG0sNRFLJSjP1UxkCCE2eV1bvVsQtp/bxpu1R4/xPxFONe+CuVicutZVHF1z5RBq/T3IpFZ0tW6YKE0kTBUr5AaV6YnOosB7BZGIl7wLUukmxnGvjncb1+m4Mb1LG0p0lrSs7FR28t7+nySCR8gXLNw0nfDnf23v6giCFyugKGkLrXBxD4isufw0wcturKGB1Jw==
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


