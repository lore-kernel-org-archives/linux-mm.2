Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B47BFCEBF8A
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 06:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDF1D8E002C; Sun, 16 Nov 2025 01:31:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8F838E0005; Sun, 16 Nov 2025 01:31:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2F528E002C; Sun, 16 Nov 2025 01:31:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 987CB8E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 01:31:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C6D2C08D5
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 06:31:04 +0000 (UTC)
X-FDA: 84115497648.27.467DD3C
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 27D4E140003
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 06:31:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=v87ep+8s;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763274662;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CSaTv+g6iTeyfNwAPb2UZSBv3rc0hQYoL1YvQs/TGcA=;
	b=a/XcUQtnqa98h6rm7GE4XiecORoRE7SOemKPgtHA0U4ZDrrpHcDs4Q2yi5CZXkvbhrsqd+
	z/t2mVkyNw+UdI6TP1siqt2NWQif4SYWBYbmvSLk6KeqyvtWVeo8v2bWnphzONhbhJVBBH
	MdO4I25Mp4j0+QNeXlKCweppu6On4eU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=v87ep+8s;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763274662; a=rsa-sha256;
	cv=none;
	b=ySWAwZdHwAofcMNHJ8ujcMEWg8EgO5eMrisHc3b8WABCPhkPCbdRFo4T8VTWEtiPo9CRm1
	paL4WjThkduo7YEVi5ogfykGTkT8uXd5t4MI0S01tMtIktbHFod4SBkl2Cw46TNIvXDfoE
	XtKKyhAIoarKD8W8gE7qwhEYQ0ztCas=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=CSaTv+g6iTeyfNwAPb2UZSBv3rc0hQYoL1YvQs/TGcA=; b=v87ep+8sGAj47MEf8Vt4uadQZk
	43mSG/U79MDARH/6bYNHWYEijJCkGJlTApHxDreiHLLZkq2qjparHOIa8lh4alzW34fB6LARDpvoq
	a0tzMldguNQi01Y3KE+ZamiC2CGY+r1XBlYwAhZvQT42pRdi83POrqpQ/KgmCrP2H9U6V/h9J+URe
	7TZKT/6AEJtzbW1csZg/Nf9SbWs9D/NPnstDd2Jkzk2xyIjQO+HzNXWvKJIhrZhTAqyNMImpj9WXS
	2UDAdfdak31c1xzZAJF2F3bpuo5eTczIsPAO7ceypi0uEUZb4ZieasuxVGFqwzwJDx4l0egDgHhP7
	bvKKdfyQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vKWHj-0000000Ccfr-1WoW;
	Sun, 16 Nov 2025 06:30:51 +0000
Date: Sun, 16 Nov 2025 06:30:51 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: bot+bpf-ci@kernel.org, linux-fsdevel@vger.kernel.org,
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
	daniel@iogearbox.net, martin.lau@kernel.org, eddyz87@gmail.com,
	yonghong.song@linux.dev, ihor.solodrai@linux.dev,
	Chris Mason <clm@meta.com>
Subject: Re: [functionfs] mainline UAF (was Re: [PATCH v3 36/50] functionfs:
 switch to simple_remove_by_name())
Message-ID: <20251116063051.GA2441659@ZenIV>
References: <20251111065520.2847791-37-viro@zeniv.linux.org.uk>
 <20754dba9be498daeda5fe856e7276c9c91c271999320ae32331adb25a47cd4f@mail.kernel.org>
 <20251111092244.GS2441659@ZenIV>
 <e6b90909-fdd7-4c4d-b96e-df27ea9f39c4@meta.com>
 <20251113092636.GX2441659@ZenIV>
 <2025111316-cornfield-sphinx-ba89@gregkh>
 <20251114074614.GY2441659@ZenIV>
 <2025111555-spoon-backslid-8d1f@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2025111555-spoon-backslid-8d1f@gregkh>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 27D4E140003
X-Stat-Signature: nasnn9a6yp9xg6q8rm9491x33ttq5nx6
X-Rspam-User: 
X-HE-Tag: 1763274661-456597
X-HE-Meta: U2FsdGVkX1+SiJO5Kg5Pj0H0olVykT3Pd8uWtllwk16FHYHXS2ZOk7E3ufTBlw8KJTCOhdqClHFHBaD8RkV+38I5tNuBUw/SqA/0ZSGXsXEw7P//cCtlXE4opQR3SRF3niWGutubAnw0hNEUdyKVOje4TJ19AOCOmfar36N6MIkeaRAwpgXE3a73ECOj8MsprELeto6JYhgxJYvBAcXGhLaqprtK2sbT2ca2PNAbqDko/88QXgkG5SmkeVwE/FjGrSQ9d6oEgtLhE6XdX73kTIwDhMfyw6uG7+PzSBSSkJcWjgsM1NaEV1hhCgDjK7qnMnsBSyZkP6zCxhciVg1vLbOo9OQ9AQN91ChNukh38emf/RLKLIn322NPgIzPFk1igEXEGJeqvfC0q4Be9n58c63it1RU4wZqZbjtRD6/NRE09N0bWgdAcb7ncFQhPSaDxd/alo2SGb4hoVkrL1U3yGQAwMsonFW/vhmnDDNE4OHhOdD09LlwDY9oLbgRrc/8b6zKRFri/xHn1CSbEyXMjozo0b7lRKZwGxXpZVSQqG6ir5nwX47tjBi2GQsHTItlQHfcZutGv+/Ge8fRBoyLE1N/wDK5KOfprkVjet+GCDK/licKQq1jDykYOOy72MUfzN4xHJ9ShX+bh45Kvx4m2ZxVuARvZg717gtSzIk7Bf7kP6/G8iQP1x5CK5I7VtSioDK7aN/c61hCRY6M4e27oO1GDMLemgxnP+M3V41rdLorsOVycaP3Je4Ec2sKFbcyAB4/2akIN45clUeOuzZfZDdrea3wS2vGtlKhtt8pd6Rdy3opAZ6c08T7/0+1CHHulHFWGry0aom82P+OCsURWehDp6anoH0+fnNKgnYDIEoUsP5K2LdVzUzIbq1ZldvKbqh0bT4KP/wOcOWLqyN7wwaED7Axe/ZFIW5zTFlj/fwx4JKDcy8vqPHYpZAJqgKjGlLjpZyDFJvMCf2WIJ0
 OyR9bauw
 vXHp9UXiNQWPtkaxr1mPTPucxhUGWdZ4HR4TSAeMxCg/A7XASWZ6tkl0pVZCSaapPfLE4tdRXWuJiACtEBuk7/6F6CCW6JHqWc3teTiTC3cRM4d0UJJEv7JX8vI2YrgQ0JtRz7rcSVDfxIEvXNCTjQXt+ZtiZxnva/OVb4VOnfXi37AyacmRtEmiBNCwicPo8+XTW/RdEumvifdE+3z7/HHfVWb2Mwm1kPAavLwi8k7EwAPiiYRRSIWaN8zamQ8RHMFWconIZZG72Q0wBoSx9mbTRrg+88g7w90mZiw6ikEQ8uW7hE70/gVLODnFOi4o6IDqQHbHqnQ3vfYH+VWdau6w1xpvZKDYgIt55MnG9GyCuuY3QSUfKbJBdZHBbDq8evkY49QMbIQjemDDigfPkgTcVVoeiqSW7dHDF0Hvo/9Wds/6RAJutLXHTZOQuHmfEUfNkYJEpHSPSOiqX43JdEQuUCbypovcXkt4hM8NAbRuJzFMfv2qvaaZ8ozfLHR+AAsKVsdAEixGPlpN/Cxw8fa91vhmx2S8Yov7CqELh5Lf19dySwA67qzTA37cGvTQLlDQTQxMVr/W7zl+fB1Rs+nenfFVdtMl86NN+HQug0AqQry8fY5NJrI60CoN5Yc6YtvE9eNR2SG+VpMr/M2Q94mG4ew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 08:21:34AM -0500, Greg Kroah-Hartman wrote:

> Ugh, messy.  But yes, this does look better, thanks for that.  Want me
> to take it through the USB tree, or will you take it through one of
> yours? (I don't remember what started this thread...)

I'll carve it up in several chunks and push to #work.functionfs; will post
tomorrow morning.  Minimal fix for ffs_epfiles_destroy() bug folded into #36
in #work.persistency - replacement for that commit below; are you OK with
that one?  It's orthogonal to the rest of the mess in there.

commit b9c24b7499916a1dbee50a4429fc04ebf7e21f03
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Sep 17 22:55:33 2025 -0400

    functionfs: switch to simple_remove_by_name()
    
    No need to return dentry from ffs_sb_create_file() or keep it around
    afterwards.
    
    To avoid subtle issues with getting to ffs from epfiles in
    ffs_epfiles_destroy(), pass the superblock as explicit argument.
    Callers have it anyway.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 47cfbe41fdff..6e6933a9fe45 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -160,8 +160,6 @@ struct ffs_epfile {
 	struct ffs_data			*ffs;
 	struct ffs_ep			*ep;	/* P: ffs->eps_lock */
 
-	struct dentry			*dentry;
-
 	/*
 	 * Buffer for holding data from partial reads which may happen since
 	 * we’re rounding user read requests to a multiple of a max packet size.
@@ -271,11 +269,11 @@ struct ffs_desc_helper {
 };
 
 static int  __must_check ffs_epfiles_create(struct ffs_data *ffs);
-static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count);
+static void ffs_epfiles_destroy(struct super_block *sb,
+				struct ffs_epfile *epfiles, unsigned count);
 
-static struct dentry *
-ffs_sb_create_file(struct super_block *sb, const char *name, void *data,
-		   const struct file_operations *fops);
+static int ffs_sb_create_file(struct super_block *sb, const char *name,
+			      void *data, const struct file_operations *fops);
 
 /* Devices management *******************************************************/
 
@@ -1866,9 +1864,8 @@ ffs_sb_make_inode(struct super_block *sb, void *data,
 }
 
 /* Create "regular" file */
-static struct dentry *ffs_sb_create_file(struct super_block *sb,
-					const char *name, void *data,
-					const struct file_operations *fops)
+static int ffs_sb_create_file(struct super_block *sb, const char *name,
+			      void *data, const struct file_operations *fops)
 {
 	struct ffs_data	*ffs = sb->s_fs_info;
 	struct dentry	*dentry;
@@ -1876,16 +1873,16 @@ static struct dentry *ffs_sb_create_file(struct super_block *sb,
 
 	dentry = d_alloc_name(sb->s_root, name);
 	if (!dentry)
-		return NULL;
+		return -ENOMEM;
 
 	inode = ffs_sb_make_inode(sb, data, fops, NULL, &ffs->file_perms);
 	if (!inode) {
 		dput(dentry);
-		return NULL;
+		return -ENOMEM;
 	}
 
 	d_add(dentry, inode);
-	return dentry;
+	return 0;
 }
 
 /* Super block */
@@ -1928,10 +1925,7 @@ static int ffs_sb_fill(struct super_block *sb, struct fs_context *fc)
 		return -ENOMEM;
 
 	/* EP0 file */
-	if (!ffs_sb_create_file(sb, "ep0", ffs, &ffs_ep0_operations))
-		return -ENOMEM;
-
-	return 0;
+	return ffs_sb_create_file(sb, "ep0", ffs, &ffs_ep0_operations);
 }
 
 enum {
@@ -2161,7 +2155,7 @@ static void ffs_data_closed(struct ffs_data *ffs)
 							flags);
 
 			if (epfiles)
-				ffs_epfiles_destroy(epfiles,
+				ffs_epfiles_destroy(ffs->sb, epfiles,
 						 ffs->eps_count);
 
 			if (ffs->setup_state == FFS_SETUP_PENDING)
@@ -2226,7 +2220,7 @@ static void ffs_data_clear(struct ffs_data *ffs)
 	 * copy of epfile will save us from use-after-free.
 	 */
 	if (epfiles) {
-		ffs_epfiles_destroy(epfiles, ffs->eps_count);
+		ffs_epfiles_destroy(ffs->sb, epfiles, ffs->eps_count);
 		ffs->epfiles = NULL;
 	}
 
@@ -2323,6 +2317,7 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
 {
 	struct ffs_epfile *epfile, *epfiles;
 	unsigned i, count;
+	int err;
 
 	count = ffs->eps_count;
 	epfiles = kcalloc(count, sizeof(*epfiles), GFP_KERNEL);
@@ -2339,12 +2334,11 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
 			sprintf(epfile->name, "ep%02x", ffs->eps_addrmap[i]);
 		else
 			sprintf(epfile->name, "ep%u", i);
-		epfile->dentry = ffs_sb_create_file(ffs->sb, epfile->name,
-						 epfile,
-						 &ffs_epfile_operations);
-		if (!epfile->dentry) {
-			ffs_epfiles_destroy(epfiles, i - 1);
-			return -ENOMEM;
+		err = ffs_sb_create_file(ffs->sb, epfile->name,
+					 epfile, &ffs_epfile_operations);
+		if (err) {
+			ffs_epfiles_destroy(ffs->sb, epfiles, i - 1);
+			return err;
 		}
 	}
 
@@ -2352,16 +2346,15 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
 	return 0;
 }
 
-static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
+static void ffs_epfiles_destroy(struct super_block *sb,
+				struct ffs_epfile *epfiles, unsigned count)
 {
 	struct ffs_epfile *epfile = epfiles;
+	struct dentry *root = sb->s_root;
 
 	for (; count; --count, ++epfile) {
 		BUG_ON(mutex_is_locked(&epfile->mutex));
-		if (epfile->dentry) {
-			simple_recursive_removal(epfile->dentry, NULL);
-			epfile->dentry = NULL;
-		}
+		simple_remove_by_name(root, epfile->name, NULL);
 	}
 
 	kfree(epfiles);

