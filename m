Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 697CDCCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 02:31:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDE1F80101; Mon, 27 Oct 2025 22:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3E9D800E4; Mon, 27 Oct 2025 22:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2ECE80101; Mon, 27 Oct 2025 22:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 91AC0800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:31:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 458FCB7FF9
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:31:38 +0000 (UTC)
X-FDA: 84045947076.10.098CCAE
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id A61D78000E
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:31:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=TfdF7U5F;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761618696;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0Qrr7Pik3tDoVKCVmiI21jyafwT3CSaV2KUBw4Cb78=;
	b=kvY2O4eXAETSkD379ftuYLhsAGVCc92HUsilKccpnnHBXFHYsyd4RBLWL8nkde3GnbPl7T
	0b+Vwkiw/u3sqH3G6qYvgEcBC1VkS3DoTCoGf3Q3T3BEHnO5kUbQTgZ3JSnzuFEJOlEnRl
	GX9ppj3A33ecz0+eEV+2pNvsSxXO940=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761618696; a=rsa-sha256;
	cv=none;
	b=bkBh37g5Kkm5OZ7roHm8ij6KuBVlsfKI1twjUe6keuVk2cQ44Qb+HDsVFvj0x1KXqQ4dbw
	hYGnYLUKIWqusF4yLZCaHHawbvDX0JyCfWwDuUKcffqZ+NS9aNMW6Y/jFcLt4m6RkOcXWl
	FcKjFHfmZdCM/rYpPovoHacGd6t8dik=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=TfdF7U5F;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=X0Qrr7Pik3tDoVKCVmiI21jyafwT3CSaV2KUBw4Cb78=; b=TfdF7U5FZWDvRf8GETUZzVqWWu
	wA194I96ofrhzs3/DXQNgszGrSIWpNBJmOFPnDq63XnTCdNJPlCWF83PhIn9G/VBfkftY6vAxNo2w
	HHk2fUI58Sze6ljbIxIJizvPCVFYoBsKdbvnYFFOywc/5sjV9EnF+//kMe37DzwRse8nYx/aKmE06
	wu+frj4dpmNZ1+zeRtANettaZeP2ym04EphAQIEozI9YGi/JlwxU2fUxXCqwhxaw61n54T8WuZrZc
	/q+nmqdF0mDkzCTsfBjf37HdN/ilOzb6oFMCwn0v8v8pjDvHPHZO2hF6ffl4j1a/6vfeVr4RDnIH1
	9D32fM2g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqs-00000001eZl-001h;
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
Subject: [PATCH v2 33/50] selinuxfs: don't stash the dentry of /policy_capabilities
Date: Tue, 28 Oct 2025 00:45:52 +0000
Message-ID: <20251028004614.393374-34-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A61D78000E
X-Rspamd-Server: rspam02
X-Stat-Signature: fooc9kwdwi3583dw6ehmkeh9ziob9e17
X-HE-Tag: 1761618696-559922
X-HE-Meta: U2FsdGVkX19TJNDY/5d2s7qZ1c4Q+ORDCXqglz4KXOmt4rQHg637fuJJA15wlbpFAgeIqfAIsQTAVJ6dz5Rcww9l6oqgF+kJNr4xb23VM/7U28fbTnau6sM5xdubWODTnWA8chI1CGq6xoJIcJ84RLOr/53687yOthuLWMTyJRG+6ZFzKE3jbcxO3KaanOFJbnqScNWOAjmAiKxEN4z2hIHzo+tETJejl8IjWl41XmECvNlNxoYI1m+m+38h3Tggk3IZLokgUDPF0/Xopl6lzAKyfWl4wLxE4tBEA3l7lAzKNY3Y1RPbYzYvfD7HYFCN0uwT1TN4VjFsMlR1a6ZqOT+Xz5cl7AXUrIn1j8/TNRLP5szc/GVjXD0Wa45ilSHwY5gQDbNfybtdf8bZsFJyhgooDMoNasYBZ3OfWph6rvUM2TgzVPeZxUaJKfhamAePFXhzw99W0DZWGs7DYo/P6zbigUgKaRoo5Ijmj1V2d7zhiq9XAIzYOV+KwOgPeTkLmCuehypzntDs6KsGenwpMsD3RG6gs21OvGcpmdT1wbZALKo/w/ELRUeSituZjBJs7YFFVT1sgOXaFg3yl7iBu7jm2TDYEGgVfq3J0Rhf3da/13dN/k9R9mKL/nM4oiSblR6lrMcKc6nRLC0apBmDDJK/InWzyBybGsCIZST86ODHc8rw/J5TcFZhMdP0TW7fu8krmNjvm+cU+3q5diLMoxzMJIgHyH3noshSAb91mmaaiOvB33LwUcYqSC4VVaCRE5lYDfXzzcv9dMoT23VJORtAsAMxsd5DQ+PAu+ZoBvEro5ogHaxpqUAQtuwCl4gJimF6+1l+3NE5hewWF0lISHOsYxpK7dXJuHtcqiccfOYJ27TM5z2gs06mEdvEHQkpKAvMHM92yfACdFVj3xOxOqzsKbNBbZLD1y/Dz7SQPja1Zhn+FQL9n4sduLCz0i0a69JS/vuLikf9tSOXJPG
 V56/gyzs
 O83C/wzU0cW6ECJ44hkAinkaTYSe0tgpCI9IC0C1S8bVE5FlCpZunejUSiEtbGum1j3/7ngvzO8UVtxei5FXNpy1Ow+s66vQyyKp8RKjOa0nPl/YSoe/vPU8u3saPl+jDWSWQC3mQdGsgim1ePZQg9QJX/FBKg0ZXuX11+EDp2YBUg6Vxa02faHyyLLl5CbQuXWI0hQCtPdNSHBWpVot/Q8Zo4AdHcH5Ly37/OJBTzWB+I5uHV4K9y7CU0ZJ/Q1lky6Sh1yH50fjv6fYzf7vJqDmYW/Lk4XooYgW1ACZbkne1pK1JhVw3vMFYM9q8lwKOeXJ5Xr+Mql25qhOnQvicSY3e97Jyt3h206r+QbIKMEL/3kyAc/1X24FvacaLQJb8Cof5XTm9+HrZUmcF5hIT2W2id3d8aNhjOTDCH5WF8fcygOONshE3Dc5EBgHBBJsfqZ80n1atRIvyd5BmCG4A0EfN+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Don't bother to store the dentry of /policy_capabilities - it belongs
to invariant part of tree and we only use it to populate that directory,
so there's no reason to keep it around afterwards.

Same situation as with /avc, /ss, etc.  There are two directories that
get replaced on policy load - /class and /booleans.  These we need to
stash (and update the pointers on policy reload); /policy_capabilities
is not in the same boat.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 security/selinux/selinuxfs.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 232e087bce3e..b39e919c27b1 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -75,7 +75,6 @@ struct selinux_fs_info {
 	struct dentry *class_dir;
 	unsigned long last_class_ino;
 	bool policy_opened;
-	struct dentry *policycap_dir;
 	unsigned long last_ino;
 	struct super_block *sb;
 };
@@ -117,7 +116,6 @@ static void selinux_fs_info_free(struct super_block *sb)
 
 #define BOOL_DIR_NAME "booleans"
 #define CLASS_DIR_NAME "class"
-#define POLICYCAP_DIR_NAME "policy_capabilities"
 
 #define TMPBUFLEN	12
 static ssize_t sel_read_enforce(struct file *filp, char __user *buf,
@@ -1871,23 +1869,24 @@ static int sel_make_classes(struct selinux_policy *newpolicy,
 	return rc;
 }
 
-static int sel_make_policycap(struct selinux_fs_info *fsi)
+static int sel_make_policycap(struct dentry *dir)
 {
+	struct super_block *sb = dir->d_sb;
 	unsigned int iter;
 	struct dentry *dentry = NULL;
 	struct inode *inode = NULL;
 
 	for (iter = 0; iter <= POLICYDB_CAP_MAX; iter++) {
 		if (iter < ARRAY_SIZE(selinux_policycap_names))
-			dentry = d_alloc_name(fsi->policycap_dir,
+			dentry = d_alloc_name(dir,
 					      selinux_policycap_names[iter]);
 		else
-			dentry = d_alloc_name(fsi->policycap_dir, "unknown");
+			dentry = d_alloc_name(dir, "unknown");
 
 		if (dentry == NULL)
 			return -ENOMEM;
 
-		inode = sel_make_inode(fsi->sb, S_IFREG | 0444);
+		inode = sel_make_inode(sb, S_IFREG | 0444);
 		if (inode == NULL) {
 			dput(dentry);
 			return -ENOMEM;
@@ -2071,15 +2070,13 @@ static int sel_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto err;
 	}
 
-	fsi->policycap_dir = sel_make_dir(sb->s_root, POLICYCAP_DIR_NAME,
-					  &fsi->last_ino);
-	if (IS_ERR(fsi->policycap_dir)) {
-		ret = PTR_ERR(fsi->policycap_dir);
-		fsi->policycap_dir = NULL;
+	dentry = sel_make_dir(sb->s_root, "policy_capabilities", &fsi->last_ino);
+	if (IS_ERR(dentry)) {
+		ret = PTR_ERR(dentry);
 		goto err;
 	}
 
-	ret = sel_make_policycap(fsi);
+	ret = sel_make_policycap(dentry);
 	if (ret) {
 		pr_err("SELinux: failed to load policy capabilities\n");
 		goto err;
-- 
2.47.3


