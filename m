Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 117FFCED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8721E8E002E; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D3608E0030; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCBDB8E0030; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27E2E8E0002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D089C1A0379
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.18.CB6CA1A
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 269AD120007
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=iOMbmWEw;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8X770T8ZfjCDu3xB4E5AEqp0VoQs0dPMEWp6Hxra23A=;
	b=RCOeY4Zwka7UDUUGoxI76F5X30NB+wfFa/r8FqdFKJtLhGc4WRKE7X/nXaYppf5OVrozir
	DbUuqGxOQlHooWvV/t9OXl40KlysRxFqDsESKg1ekKg27TyielcODOTmPhkJdPQ1asZ2KM
	sDKTFf5t7ViuDyxCxVrskVCV3gVtg+I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=ztAarfINuAySL/h5Eb4FgtRlDngYnJPEDYbDCO2tckOaoxqUe1Q20vOIlkZLgxki66rnVN
	jzm11yIoEccUbkJTzrZOnMfriUspnJ+aAuKPKG+ut5GrMBuW3j5vwg19e705qChQESdMIp
	HwwvI7mxYFfTm0zw+7ShFmU7p7GkJUU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=iOMbmWEw;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8X770T8ZfjCDu3xB4E5AEqp0VoQs0dPMEWp6Hxra23A=; b=iOMbmWEw8MhF43OLV4OGzbGV4l
	2UzCrFrcBQreA9Boshu7TrRR2/OKw5XV+h4v12MQMfaLEHMkDdSeVQL5T2SrldYFpStxa7KU10n+o
	DoX/8FTfqXIHhwOF/aqO4ujkpGArqpcLLV+DoPw+x3bqIsAUWP0cjUrFoNd7/5yM5F9PFKL/1guqT
	pDBRRPt74aPobPXeVxgi8PlJoBfvINts6a2OEMmeklrW56loMVL2nZCfQT5LWL4h9wloH8FHtfQO4
	HhE6beCAYlEU2JiI4v5PtJ84dsHf/D50xDHHsXMDPzW4o18eWIU/UT00daQf4tthetYfpFuDaujxe
	nta2w1rA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4W-0000000GESv-2Wwd;
	Tue, 18 Nov 2025 05:16:08 +0000
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
Subject: [PATCH v4 33/54] selinuxfs: don't stash the dentry of /policy_capabilities
Date: Tue, 18 Nov 2025 05:15:42 +0000
Message-ID: <20251118051604.3868588-34-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bx9ffjhkuf8di5k5fpaok6atz7kwqe9k
X-Rspam-User: 
X-Rspamd-Queue-Id: 269AD120007
X-Rspamd-Server: rspam10
X-HE-Tag: 1763442973-772189
X-HE-Meta: U2FsdGVkX18WfjTxwsoXSsxAclkr5zRaQST6Z58nEoUc2VWADoHI1uYc0q4DZUsi75t3XFp3Mld8R0Zr5ooFhu2GEx82YmnbkCorJjsuNWutFKQlud3B0Iqqb+EFPDbF190peqix82+sMZJU/2wRwJUlLLoyPupJkquIsD+i7sCaaPRHJfPRIwp9aS41KWR7/whgQi8W0TNRS7AtdW2UzUrLU47XrFB/kXpY56OIYpGO0zuGn91xGANgc/we5AFHonGa3ERSXRpA2iz2c9w79raiD+/q23QvZJqfBjtu+tFoXJjUmA36Kc6sJ3RwALpD5rsNhIYA/p0XSm6dtaR7Cj85yja3NInERq/2XUMaYRqUbBEcAOst38eCTV1kgyVwrcLZ1un+Ta+1O8M4gGqsITUCqFU8Jbv+xmy/pX5srKhJhyuU9eS2cXlLCyO3RaSdxKwqF9V7nPnbEpDZA+Xawks5T2g/YDwEGg2tEaIRvpeQFCDo1yuNGtTlY2UeZgDej7XGKyBuFObDRmvcvpYWP9TKfacC0mqsKj5n+jgqhQCJ/Dup3JyPX+yj7/xbXzHXrAh2lgHYa/m4MrAl8Rc0EEEvOTBuj5t7XzVujir8fPCXzihCYqnu7f5YcxIBflGAw5Y2bzmZJApTH77107VrGIUTygQwDqeYS2azYMnldzB9Jmh/h/8UHGnjFr/Lioi266Lfgwi6KMbfyd76yAO+MzZWb77lLkBr5uRaVWP88C0OR+Zag2Sbgzj1yfsh33O89x5LxUlKgBi8KeNU+7KNVBXYDdZ3BMFi5Oqz3uLmdf1NpL+oMFYD/yDNSi53nrMezCylYHqd51YMIrbEYZi5nm1f44EFdtGOGUeutS/GSBq5UrOcEKkhiU8+JBuPvqccJQvkqPoB+O57229d/pzYsl/Ae5UXaFovtMrZ0SUw6fC2wr/Hmz6QQakOEOrROXfGSZCeeBvH2k8u3NfWoaC
 NG4kMsV+
 PzjekTix/Q4SxIBjdXM23ID9oZD+0QXBzYDIGV7Au/GhTw32CH18DD0pFrbQpyq5XAe/pXB+oXdgO6iSGN01746QchkOJBx5evJT+G2MaZi8uB3ytSR7dspk9HmcZimaeL5x+AhOoUfR69MSFcA00ehmYVsBtEu2KbfLB7jsdbIwfmUfCtpdJMjhlajNhtZrPwi+I/4yNBy2JR1801ckVA34VVPPP4EbxnYEtAkQOOKfbJbcQF/d5BFizv1yf1q8QmuH9lZawT7g6YH0LDBtlznDXW+ouHTUcGMARs4/3sx/evi+lLqXJymOwxXJDhCDwFYWHCR6t1q7Zj5FRWcQ1lC7rNsDVVEcW7PY6eLvmfcho89WJfbk5FB192bD6WUCneRasgC6i4L/qXrODCN6gWLcb4xRg3KakxKrIe/2VeduusUOrqi9sb34VUi68c5M+ZvB5J6VjDRyGLmvxXOKd7ScztRWH5f/8AGQu9NUQtDdJpyM6j90CVwZGph9k8a/CQ5PISsDnJTjy0Ri9B017ne9/ydZuQyhC802YCR9wLw8xzc0=
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

Acked-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
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


