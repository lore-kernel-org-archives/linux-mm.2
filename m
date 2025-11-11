Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25081CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611FE8E0027; Tue, 11 Nov 2025 01:55:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7FA88E0029; Tue, 11 Nov 2025 01:55:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A22408E0021; Tue, 11 Nov 2025 01:55:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81F278E001F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48A53B9730
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:35 +0000 (UTC)
X-FDA: 84097415430.30.3C9FD70
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id B682B40007
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=wtKH4oxQ;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844133;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxXF+ZX7o2qevQIhaj7GgHO9nhvHZfJFLXJ69dxgaxo=;
	b=Dwusu9NDVjevKxIn0f1rmSBbGlPUVOvEOAx0MW+pGIFVWXIFrl4nqu7EXveqg/kt4z9Qet
	uxyRVxkTTzSNTPFOe5umQwpQHQx/sAOfaE2mZYsoMazxYFVrfSAIeM4qF8PYeyPvxulaH/
	ehfO2sVtNOd5fOTZXJRC9wkEN5tu6gQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844133; a=rsa-sha256;
	cv=none;
	b=cfXourc+oOmh7jnsHlcowfVVe73xhUxA01pl0IFX4/wgiBRNlGKWC2qoiuAVLPCdeSOJPb
	vbdjCCDhFle/cI/YV2ESDs7UVffyIK7XMm/vkjyphJr5c1avfsiBGkbE3w4hbdCEoo6lOc
	w4VWUwVzf2MsIaDqzObQCzCnIfafvlM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=wtKH4oxQ;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AxXF+ZX7o2qevQIhaj7GgHO9nhvHZfJFLXJ69dxgaxo=; b=wtKH4oxQY/2cA79HkCgcoKJBMF
	YOrX8xLQGNijM4ZeIrn5wgh8EBLeXIRaCgznbJWJLF4sMCXG88No2yz/1N4QDf4Ybv2gyxTP0MuEY
	HkPV42ETmPsvVN2SBm+bxIDlulzSLOfEmEy6wdi0zvIgWAJwDEbSoixVhKxYYLF4BnOcAsljsLcW7
	3Bt6WXPUByXgorENsvHsomVIe3iq9nlXOBMLEUsu5/duQEnIXHaL+5Itk/JH6XH6Q/JfUB6ZlnzVj
	7OaCgWawr8yfCA28JGyWJ2pL3w9/EGC2wTPtLqttDRbvBiPwZB5KGEGoXvL1Z/3IFEh1JEsOTDgsR
	JeBZReMA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHo-0000000Bx8x-3l9j;
	Tue, 11 Nov 2025 06:55:29 +0000
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
Subject: [PATCH v3 40/50] hypfs: don't pin dentries twice
Date: Tue, 11 Nov 2025 06:55:09 +0000
Message-ID: <20251111065520.2847791-41-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ys8wd9zrb69idhoogmunn1gzoidqkc1z
X-Rspam-User: 
X-Rspamd-Queue-Id: B682B40007
X-Rspamd-Server: rspam10
X-HE-Tag: 1762844133-332959
X-HE-Meta: U2FsdGVkX1+RrI0uDnXh+CJFT4f9FCfRsynH3BeIqIVp+AUSEEc7O/sJ346BAfKD5AAey/PdKVQHRAxpuVoHn4GXdyoQfNjlmBSkTCoTKVAwb9nciM65RoZewn26/mE0ktR0WynAni+x2QnG9n7U6u3dXUg9BklYIrkANQvBllTzQ6bOD24+iCKalAXTLNabomK9ot+j0hQ5T7HvoIeBKb3tse3wYNfjs/uikiQLTzIWrZIaHGIjhaFv624XTDPHSBjd4Nh9Rr4hWmcWAVYKuu68JI/uJsl7TlVZanbb790C4PIRimk69KZayJ/606RvcjZEJyFPYC1OoJrf6cHbSkk6JDTNe0LMAAYCLuVtGvV3wQwRLDBQFMxWD7iYqDBUaxEwnnLTxX+iMnOJFvFtxgAgwjaGv7NR7nSDRhT+lUtgSyr7M1ml/prBU/X8Hm7rKBqcRI6HsyVOyKkUkTV5ULemns2O8XNkGB5zZ04VRKJ3Eo0Uv3cTCnFeYFM7OoHEJwqjcXeaT23e7uhHbT0Q8ULXzyU0WSQiMK/5VoBtwQFRUURtkJOGlGhUOeyyN+1QLHEoSpc5QFsSMrifZudQYzRnfBk/3jtM+PmraLqCwYoM9QP1YuVxiubFEwbkKCahBXUdyMeVJozPs545e0g3+BHzmyUf0wn5r5WNUJjNtuCcbrGFq5IvS21FZ5jBtnmusBKxa22QeoOUfzXoO8248c6PYqzV7M4gzawG+Hw3yZwsmc8hyN4F8t05m70iSZP5RkNqSi34IuiSuI65dOgAyBHqp/J47WW0lZDLKIQczMzrN/TA8pJGOM9biKftf2xKDwZg8/w6i/cyyi1SFXSktiabL0CXCfcPlFBTDjDCAiKEa/RrPKg2KMie3SVr95RSm4z1YW57M7kZ0x1ppen1DB42cyoze+qFazUV6piB7fqwEZAU7vdH4yQVIKOww+wWqRhz+6HPS8ahwZzBfwo
 tzLqL0SO
 xfcV1X9lQN/QI6Q8tPintv3zAaCo/aNgFs+Y9UkvzLBD2Mtp4bBrOgRMviaMUfdZ9AGe6z9tHBoX4giEB+PlsQIQh4dzmf9/ACS0UGjWdYRiygCIemKY4Pz67oF8uyQ/mwQbtWrejkLWaJTcR4d8K4p8ZrFHAlTea4vbbZApgbvGgjbMJrlE4ZqReBcdQUrGGzOOThqdBzTx2CfraSnNAZd6ubh9y2XAOLAJqWCFTRO6gMi2X4X59y8w+bUm2VO2wxaZhSHjNmIYrEoFrHUTqISfd9l3YBOYw3E/OfRApQPzMzBISUhq5yc6tPXAbCwbQvoZ0dyi9PTloWr+b39oEXsaQFMSQCsSdvRMYRSeY4ZKRdBa211Y/diGqtzUk0d2onv4hmP3fwtq+U5drLaKIsVzZCZDJMYtf3oe7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hypfs dentries end up with refcount 2 when they are not busy.
Refcount 1 is enough to keep them pinned, and going that way
allows to simplify things nicely:
	* don't need to drop an extra reference before the
call of kill_litter_super() in ->kill_sb(); all we need
there is to reset the cleanup list - everything on it will
be taken out automatically.
	* we can make use of simple_recursive_removal() on
tree rebuilds; just make sure that only children of root
end up in the cleanup list and hypfs_delete_tree() becomes
much simpler

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/s390/hypfs/inode.c | 41 ++++++++++-------------------------------
 1 file changed, 10 insertions(+), 31 deletions(-)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 96409573c75d..a4dc8e13d999 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -61,33 +61,17 @@ static void hypfs_update_update(struct super_block *sb)
 
 static void hypfs_add_dentry(struct dentry *dentry)
 {
-	dentry->d_fsdata = hypfs_last_dentry;
-	hypfs_last_dentry = dentry;
-}
-
-static void hypfs_remove(struct dentry *dentry)
-{
-	struct dentry *parent;
-
-	parent = dentry->d_parent;
-	inode_lock(d_inode(parent));
-	if (simple_positive(dentry)) {
-		if (d_is_dir(dentry))
-			simple_rmdir(d_inode(parent), dentry);
-		else
-			simple_unlink(d_inode(parent), dentry);
+	if (IS_ROOT(dentry->d_parent)) {
+		dentry->d_fsdata = hypfs_last_dentry;
+		hypfs_last_dentry = dentry;
 	}
-	d_drop(dentry);
-	dput(dentry);
-	inode_unlock(d_inode(parent));
 }
 
-static void hypfs_delete_tree(struct dentry *root)
+static void hypfs_delete_tree(void)
 {
 	while (hypfs_last_dentry) {
-		struct dentry *next_dentry;
-		next_dentry = hypfs_last_dentry->d_fsdata;
-		hypfs_remove(hypfs_last_dentry);
+		struct dentry *next_dentry = hypfs_last_dentry->d_fsdata;
+		simple_recursive_removal(hypfs_last_dentry, NULL);
 		hypfs_last_dentry = next_dentry;
 	}
 }
@@ -184,14 +168,14 @@ static ssize_t hypfs_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		rc = -EBUSY;
 		goto out;
 	}
-	hypfs_delete_tree(sb->s_root);
+	hypfs_delete_tree();
 	if (machine_is_vm())
 		rc = hypfs_vm_create_files(sb->s_root);
 	else
 		rc = hypfs_diag_create_files(sb->s_root);
 	if (rc) {
 		pr_err("Updating the hypfs tree failed\n");
-		hypfs_delete_tree(sb->s_root);
+		hypfs_delete_tree();
 		goto out;
 	}
 	hypfs_update_update(sb);
@@ -326,13 +310,9 @@ static void hypfs_kill_super(struct super_block *sb)
 {
 	struct hypfs_sb_info *sb_info = sb->s_fs_info;
 
-	if (sb->s_root)
-		hypfs_delete_tree(sb->s_root);
-	if (sb_info && sb_info->update_file)
-		hypfs_remove(sb_info->update_file);
-	kfree(sb->s_fs_info);
-	sb->s_fs_info = NULL;
+	hypfs_last_dentry = NULL;
 	kill_litter_super(sb);
+	kfree(sb_info);
 }
 
 static struct dentry *hypfs_create_file(struct dentry *parent, const char *name,
@@ -367,7 +347,6 @@ static struct dentry *hypfs_create_file(struct dentry *parent, const char *name,
 		BUG();
 	inode->i_private = data;
 	d_instantiate(dentry, inode);
-	dget(dentry);
 fail:
 	inode_unlock(d_inode(parent));
 	return dentry;
-- 
2.47.3


