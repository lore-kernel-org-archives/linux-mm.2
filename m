Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28BB3CD1297
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B028E001F; Tue, 11 Nov 2025 01:55:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58CC28E0020; Tue, 11 Nov 2025 01:55:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8768E0023; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B40F8E000F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B7D3F13AE4F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.25.EF60C59
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 224F21C000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=YCDudwCD;
	spf=none (imf21.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844131;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8X770T8ZfjCDu3xB4E5AEqp0VoQs0dPMEWp6Hxra23A=;
	b=QF6y1uaQIQ9ww/vR/I+kZ1ZamtV89iJXjdaTYV3/8YO1cqdU0GGjppCJWrIOIrqq6i+p0/
	YaigGu6Ojb5BgLkoiI2ANQQX+4lXkRj3Ywsg3/tFU5HCFayswMGmMvGQ8S3vD6B1bnKUMI
	Cpstu8OGv+W522cVjIrOPaLUsUCVJl4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=YCDudwCD;
	spf=none (imf21.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844131; a=rsa-sha256;
	cv=none;
	b=vQ8MBBJ8GOg4+CMJ5Z2eVNVUMtqeSHurqu0RyUWJKzh/nPf9Zor8RY6fo+3U959HLV4Sez
	Ka7J23Mn75FOFcNOJvD5Ub2bRrlsTk7KABw/pb49Ef4JDJUo3vgOTw+1VVr4k+Nbu8Frzd
	SzSkeyEUAkLKj123f2453oaP8zv+mjA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8X770T8ZfjCDu3xB4E5AEqp0VoQs0dPMEWp6Hxra23A=; b=YCDudwCDT/n4mN+8CVGG/MVpKv
	HXMKHDYa0eAoCZBp7rPVUFHDcK55zwx1kWLUNU/sTXQtPOfR3YBdohIuk01gmUmOXc/gGOIW4MLHN
	q6hwsoi7Q0hkY8ti3IDavzsEsJjvTcWMl/b5dG/LunvamKdSimus6KhyaPw/wM3O9nXkobmOoIbcy
	JhlSaMb2V2j7YUnd3PIhI1A58jHvLBk/2CPMyNlE6TqswKB/6vHKcHwuv0QG3ZP8RVWL+7zcPvn3r
	6ydR3Iwc37imHuIzYZPdqsSdfuzz3FZg2HijNLeMjmh1ddGfHdq/TvOa1SEfgR6yONrujxgrznqfg
	/X3ZcTKg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHm-0000000Bx2N-3R3y;
	Tue, 11 Nov 2025 06:55:27 +0000
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
Subject: [PATCH v3 33/50] selinuxfs: don't stash the dentry of /policy_capabilities
Date: Tue, 11 Nov 2025 06:55:02 +0000
Message-ID: <20251111065520.2847791-34-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 224F21C000A
X-Stat-Signature: afhtj63h3t3fc5a5yymfggnjfoxtj9rk
X-Rspam-User: 
X-HE-Tag: 1762844130-91037
X-HE-Meta: U2FsdGVkX1/t525JbUgcoCrKltEl2u8BGsOtjFyqIC0It35nAscTY2+SO27nS4qtqFaqy+2xpyFAFG1IT/iAT3BwTSej8BgrP8QG9aPirV4W6TCikL8hL+379s3k7N++E79fxSl+EROxjYBz3RGXUsuUOBXrDg6RypO1KAqO/xkFEj8JKTFzQBhkU2FwqRERXaf6OfrhnKEfy/RDKICS2wH8BDzfr4zz9/+unV8eKDT3B2Im23lNYHxQ5c7Pej7lIDxZCtC6ij660d9SINPpxwVUiAZl7hXb4Sx8oaY+8lk5j3s0NWaYG+ZxikQplMVaEw75xvl1eOPGShkXQHF/ycB9+GP+0anwp0oCEEv5q0EC9a0r40G4x1wIuP9E8oIfUGHTiWD7ZSNwOk5R+TDgaXVhmq8s53YReZ/ZKb4dhW3xWuAmIhK4trpZq3oXO8YMFrHLaT/W8ZGd5YzNSSiuY7eEpLOMGlZcglfDhVs0JDrk3meYR8IkEpuYXgCz2fUlnID84GFlaAx2uiUvhDpzc5MWGoWbg6aNKgQjVrd7XnhkaWVRs2wOHH+bh6xXkUYBtU8zRDKNrm3QrJRetRwhxf9dOKufFjPMTneN88ztkpns2sam2uwx2IfLQISc2CDOpnROPI40pGgD8CAeGASbC3oD1CguIa/9lg/OfEFbJILMD7iwfLlRGOip/o+cEyEUUH2Sprgx9AZ+WMhXPwwqAuxb+WnyAL+rRcS2j1raNGrs+upgZK7GzY9R52CEGMRj4phWtlN7GJG2/dm7JO1IWJFLwKRMy6NMuDJPpMWn4+Wus/FG0K45Gl5qvxV2BfLR5uAXUqOD//q5hmF66X0ACZKk+D8jJLOebhJmbwq0RU6qK8dmTZjzozxJgYnGTbsX6/op4J1JEMTMyHzYCKlQvpc9swbZKh9jAkVO/YYq4kd3V8VuLkFUQdBzkSTvjvld9Y4SE5bp2mxCWk3/DBy
 R/VZVIAh
 Bn/D0YyMjJI7l3T9YDeoNrnnGbNSaiIeMxvrTZR48K9xcG7SjOBQ9iy25379umj8Z02w3CrPxqCExUHZgyTE6uC0fOO7SuOIBVC5B76g90kQuJyLXURkQOXuA51VDGW7bp9338c+5CgdSymA5MSWfTLFvDS/sJUM6136iY9K8q5TIQG7uGVDu+cGYoVjC3rrVKzI58R3MU7pBEwEVL8WsStiRSi/WGQQtTuYjLjcyZhnR5JiahJke+MkqPrMa6nfoqqdkbaVIAmYvFV2CGREutecXSwQtmvwb+nmisF2Db+1TZofTcKRZ9vDMnS6rVU9xZ+d6aMzPX7dMAi2eJVETKGjYrA5Oul3B5lbWEbNp0xtNXwEUJbrkQK68f5yyjy4K41Td7Lz3kaf2RTaQn9vj92o09KF8dynU/TA2LQ5NBB2BKeO/zCFbwCXITCBS23lLHQS7/w68HwfUkkq0uPIyaROI0BhLtNXJzgvuORxr7yyyznOYNTBkjiedNi6AmbunSAcUef5GhDd6PckiWEcEEy/GBrTYpCtulzCjv0kwBipxGSs=
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


