Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9101BCDE01B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 07:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFA818E0005; Fri, 14 Nov 2025 02:46:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAB858E0002; Fri, 14 Nov 2025 02:46:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999F68E0005; Fri, 14 Nov 2025 02:46:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 89DDF8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 02:46:26 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C44513A736
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:46:26 +0000 (UTC)
X-FDA: 84108429972.23.36A1CBB
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 28A2B140004
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:46:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=RmwmpcQV;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763106384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h+GY3DA2a89Ro6bK+Ny9JBXd1oGc4240hj01Ocp0k3I=;
	b=EKrQm7TmBqLODOmRe3pejLxe28TxkwXvA0bl2V5BzqS1Gr9II/bAR+3C1/ErRpIvZh5zGK
	Ukc8fWvuH/XRYV7wScBKMU4pN3ZqkWX84LUHw7Ps7pfAopH8yExLhyk5wTECGoq2kW1IvK
	l0GQktGNlbw/ZvzaMtyT3u4GzEElWco=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763106384; a=rsa-sha256;
	cv=none;
	b=Wo9womeCxIBEsS7XQbKkJcqqe5Cs1A6X+WpIDxJc521fmKZmUV4myPNmdmJq5kWnhfa8Kx
	bJDKpTz7ubsmR4wexXmese5BVRIRw17TNysLdKgEF0xktz8gcawHiEC4802b8T8422dpYa
	WyK30srbLopF1uoLa3utgPoTXZb4XHI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=RmwmpcQV;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=h+GY3DA2a89Ro6bK+Ny9JBXd1oGc4240hj01Ocp0k3I=; b=RmwmpcQVdyxseRwak/qof99plg
	19GIkQZH7ChhzOiG3uz8dg2HkAA5N+5/V1UIxXkDLDUEZCoKXkHmJU2jU1s+Q0xxu/tK+e7sPtX1g
	p9WnhHDcBBVa4n8KLpZIKcLWl1vD6DcEr3NuPGBC/3lFrFbZqBzzS93Vmonf4mXY1YBnwXFMeqSOq
	0VjFZh3Nht/9wWMlfASZ7/M0BXd2QaeBC84W+1f0gTGtGlmpUd/NgvFb/SFB2rT88CqI0WGcOH1cX
	adF7Nl5bHG2kHMKYO15y03X/mRHcKujBsb/+YppfEkDblFYHA+Zfb/PsC9CidjgprrT4VBcTnotMR
	Z1lBwfCw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJoVa-00000009Pew-1WxF;
	Fri, 14 Nov 2025 07:46:14 +0000
Date: Fri, 14 Nov 2025 07:46:14 +0000
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
Message-ID: <20251114074614.GY2441659@ZenIV>
References: <20251111065520.2847791-37-viro@zeniv.linux.org.uk>
 <20754dba9be498daeda5fe856e7276c9c91c271999320ae32331adb25a47cd4f@mail.kernel.org>
 <20251111092244.GS2441659@ZenIV>
 <e6b90909-fdd7-4c4d-b96e-df27ea9f39c4@meta.com>
 <20251113092636.GX2441659@ZenIV>
 <2025111316-cornfield-sphinx-ba89@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025111316-cornfield-sphinx-ba89@gregkh>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 28A2B140004
X-Stat-Signature: ag4bxhtgw41pq88a78r4b5s7y1ngtf7i
X-HE-Tag: 1763106383-115436
X-HE-Meta: U2FsdGVkX1/ECe9BohAIUbXgMCbVhZua3ADw4L9Dz/h93rev80I3frogCurAya655mGQC3iVGQv4gk4KvwztJAmn9iy4oln+2y1SrpHDzrUEKDCyXE6e6fTUxblWE+jUUSfXko0U0FSvF2rUOPqDwnqn47F43qco58c9FO9NkRXTPB56bxmtXX5iSK+U+l/sLtKfSGkvjYZTQ60ygacIbpkmUbBAwWv84Mscn/gx+hUjY9iPcYqXrMoNYMT2oWDm1Q03hCU5nVBdA3qifWX68so32N+5C2ehGB8W3AYckIDcdIeyf+B3sv4UCH0j4yhRWhWTn0efkAxye6qVeT3XUTYDt+xCvUhR9TkAAL/tOkrwt5TncdvB6opQxBG6Y5W5OJbALAKjRh/SOsowkedNUtwX8pvcPEr0nYBCqqvrCL0TINSmhTIi9XLvX/uFWaPZW2uAhnpbiEKqhiliw+kq6Vc6riBsj3QgSFaO78/TZsSuNRy5dKJ0KjjsrlnwcuRzjyMiHMYuXx2jwJCw3bCu/g+/CCk0wm2DZylohvkp2M+9U0YxGoE6Ye4O2V/+xtDhHBAWorPknpDyziWmzeVmWrwIMOjSzhY9U1ydCo8qj4CvCTfvgyv7f4JEFeHDnalY6HNe897UPM/ytDKXOv5pLWx6hKDBVraUXpUZuLGkrIX26WZiVKFwp5Rs6sguyN7WVs/OkMePVyN8Pfea92vmO0EgDdGwXtBZko2xkIqYL15XMhniS1qH1PmQ7tVOgKmuzaArWRtla2DjRo3TflihwhYJY/OD68h/QJ+CZZR+sIlBEogDIe7CtamGair9OQk4Y+mEVRacn+7V7hrRszAX3WoSHnfgzX1PwcTZSFO2ym8utmdM8Yp39gsHhvkVzP6XN78XmFTezqhvBZ9UclS77UG4LSBPAcZR4zqHirqY0ykjx3ZIFDQp3plsgyYLdNHFe/KcWLhnoMTvzgwgdaZ
 89HIeVaJ
 RhoZyMPtWwANfidoCQ6rCvyeQcooDztP1cLpZW9m1bCXsNBuKtbZukj+gXq3fFiIJ8dsmSRMkAhBH27y6kJVtV810J4HzynyaahzhDZqo3KQ+MSK9WOdydRP3BstXk77/me/206o97aVeJYHOd34CBLxlOcQcOVd26Ux5oU/o3eu5Da6RPlTzhhnbsYpXnyp9WH+i51YBzERRrNtF8vK7OHnlfnzyWdVRhCbHN7YRNYEp5lEwo05vjNB5+9mKpbwscRuQySnqrixblIfjsahxc+NofLQu732LGj19wZNyr789zja+aTYkYqgslg8Jyv8lztuNIzXhKQlaI2XKnNf8WCdMLFu4GL1y34Fgn3/qoEIrx7GpPe1muOiyECtrMExCuHddnBnIjS74VT/YgzzlwIbDPjaNa2wisD/CEkey/qirhdAymjz8xfnUZegLahRmPI5sW2sK7c9G1buTdB+HRQppZI5aKzgvQRwwX/OS9sq6/Bz162a3IMFpzzpn5Ck8IignI4vLjKNrRvJjreAlovh4X/nvw4QbdjlVIWeVrk2aoI6zm8bjDQwVNYx+S0k+rQM3vzZJqnZMARMI3tQy1RwnUAwynr+2YhXv58JSAnVoC1Rh49K2jPX3+pgapAGEgR3dwkZHs/vRPBg1L+15tpGjSlh5hsghL8tc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 04:20:08PM -0500, Greg Kroah-Hartman wrote:

> Sorry for the delay.  Yes, we should be grabing the mutex in there, good
> catch.  There's been more issues pointed out with the gadget code in the
> past year or so as more people are starting to actually use it and
> stress it more.  So if you have a patch for this, I'll gladly take it :)

How about the following?

commit 330837c8101578438f64cfaec3fb85521d668e56
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Fri Nov 14 02:18:22 2025 -0500

    functionfs: fix the open/removal races
    
    ffs_epfile_open() can race with removal, ending up with file->private_data
    pointing to freed object.
    
    There is a total count of opened files on functionfs (both ep0 and
    dynamic ones) and when it hits zero, dynamic files get removed.
    Unfortunately, that removal can happen while another thread is
    in ffs_epfile_open(), but has not incremented the count yet.
    In that case open will succeed, leaving us with UAF on any subsequent
    read() or write().
    
    The root cause is that ffs->opened is misused; atomic_dec_and_test() vs.
    atomic_add_return() is not a good idea, when object remains visible all
    along.
    
    To untangle that
            * serialize openers on ffs->mutex (both for ep0 and for dynamic files)
            * have dynamic ones use atomic_inc_not_zero() and fail if we had
    zero ->opened; in that case the file we are opening is doomed.
            * have the inodes of dynamic files marked on removal (from the
    callback of simple_recursive_removal()) - clear ->i_private there.
            * have open of dynamic ones verify they hadn't been already removed,
    along with checking that state is FFS_ACTIVE.
    
    Fix another abuse of ->opened, while we are at it - it starts equal to 0,
    is incremented on opens and decremented on ->release()... *and* decremented
    (always from 0 to -1) in ->kill_sb().  Handling that case has no business
    in ffs_data_closed() (or to ->opened); just have ffs_kill_sb() do what
    ffs_data_closed() would in case of decrement to negative rather than
    calling ffs_data_closed() there.
    
    And don't bother with bumping ffs->ref when opening a file - superblock
    already holds the reference and it won't go away while there are any opened
    files on the filesystem.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 47cfbe41fdff..ed7fa869ea77 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -640,13 +640,22 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 
 static int ffs_ep0_open(struct inode *inode, struct file *file)
 {
-	struct ffs_data *ffs = inode->i_private;
+	struct ffs_data *ffs = inode->i_sb->s_fs_info;
+	int ret;
 
-	if (ffs->state == FFS_CLOSING)
-		return -EBUSY;
+	/* Acquire mutex */
+	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
+	if (ret < 0)
+		return ret;
 
-	file->private_data = ffs;
 	ffs_data_opened(ffs);
+	if (ffs->state == FFS_CLOSING) {
+		ffs_data_closed(ffs);
+		mutex_unlock(&ffs->mutex);
+		return -EBUSY;
+	}
+	mutex_unlock(&ffs->mutex);
+	file->private_data = ffs;
 
 	return stream_open(inode, file);
 }
@@ -1193,14 +1202,33 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 static int
 ffs_epfile_open(struct inode *inode, struct file *file)
 {
-	struct ffs_epfile *epfile = inode->i_private;
+	struct ffs_data *ffs = inode->i_sb->s_fs_info;
+	struct ffs_epfile *epfile;
+	int ret;
 
-	if (WARN_ON(epfile->ffs->state != FFS_ACTIVE))
+	/* Acquire mutex */
+	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
+	if (ret < 0)
+		return ret;
+
+	if (!atomic_inc_not_zero(&ffs->opened)) {
+		mutex_unlock(&ffs->mutex);
 		return -ENODEV;
+	}
+	/*
+	 * we want the state to be FFS_ACTIVE; FFS_ACTIVE alone is
+	 * not enough, though - we might have been through FFS_CLOSING
+	 * and back to FFS_ACTIVE, with our file already removed.
+	 */
+	epfile = smp_load_acquire(&inode->i_private);
+	if (unlikely(ffs->state != FFS_ACTIVE || !epfile)) {
+		mutex_unlock(&ffs->mutex);
+		ffs_data_closed(ffs);
+		return -ENODEV;
+	}
+	mutex_unlock(&ffs->mutex);
 
 	file->private_data = epfile;
-	ffs_data_opened(epfile->ffs);
-
 	return stream_open(inode, file);
 }
 
@@ -1332,7 +1360,7 @@ static void ffs_dmabuf_put(struct dma_buf_attachment *attach)
 static int
 ffs_epfile_release(struct inode *inode, struct file *file)
 {
-	struct ffs_epfile *epfile = inode->i_private;
+	struct ffs_epfile *epfile = file->private_data;
 	struct ffs_dmabuf_priv *priv, *tmp;
 	struct ffs_data *ffs = epfile->ffs;
 
@@ -2071,12 +2099,18 @@ static int ffs_fs_init_fs_context(struct fs_context *fc)
 	return 0;
 }
 
+static void ffs_data_reset(struct ffs_data *ffs);
+
 static void
 ffs_fs_kill_sb(struct super_block *sb)
 {
 	kill_litter_super(sb);
-	if (sb->s_fs_info)
-		ffs_data_closed(sb->s_fs_info);
+	if (sb->s_fs_info) {
+		struct ffs_data *ffs = sb->s_fs_info;
+		ffs->state = FFS_CLOSING;
+		ffs_data_reset(ffs);
+		ffs_data_put(ffs);
+	}
 }
 
 static struct file_system_type ffs_fs_type = {
@@ -2114,7 +2148,6 @@ static void functionfs_cleanup(void)
 /* ffs_data and ffs_function construction and destruction code **************/
 
 static void ffs_data_clear(struct ffs_data *ffs);
-static void ffs_data_reset(struct ffs_data *ffs);
 
 static void ffs_data_get(struct ffs_data *ffs)
 {
@@ -2123,7 +2156,6 @@ static void ffs_data_get(struct ffs_data *ffs)
 
 static void ffs_data_opened(struct ffs_data *ffs)
 {
-	refcount_inc(&ffs->ref);
 	if (atomic_add_return(1, &ffs->opened) == 1 &&
 			ffs->state == FFS_DEACTIVATED) {
 		ffs->state = FFS_CLOSING;
@@ -2148,11 +2180,11 @@ static void ffs_data_put(struct ffs_data *ffs)
 
 static void ffs_data_closed(struct ffs_data *ffs)
 {
-	struct ffs_epfile *epfiles;
-	unsigned long flags;
-
 	if (atomic_dec_and_test(&ffs->opened)) {
 		if (ffs->no_disconnect) {
+			struct ffs_epfile *epfiles;
+			unsigned long flags;
+
 			ffs->state = FFS_DEACTIVATED;
 			spin_lock_irqsave(&ffs->eps_lock, flags);
 			epfiles = ffs->epfiles;
@@ -2171,12 +2203,6 @@ static void ffs_data_closed(struct ffs_data *ffs)
 			ffs_data_reset(ffs);
 		}
 	}
-	if (atomic_read(&ffs->opened) < 0) {
-		ffs->state = FFS_CLOSING;
-		ffs_data_reset(ffs);
-	}
-
-	ffs_data_put(ffs);
 }
 
 static struct ffs_data *ffs_data_new(const char *dev_name)
@@ -2352,6 +2378,11 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
 	return 0;
 }
 
+static void clear_one(struct dentry *dentry)
+{
+	smp_store_release(&dentry->d_inode->i_private, NULL);
+}
+
 static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 {
 	struct ffs_epfile *epfile = epfiles;
@@ -2359,7 +2390,7 @@ static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 	for (; count; --count, ++epfile) {
 		BUG_ON(mutex_is_locked(&epfile->mutex));
 		if (epfile->dentry) {
-			simple_recursive_removal(epfile->dentry, NULL);
+			simple_recursive_removal(epfile->dentry, clear_one);
 			epfile->dentry = NULL;
 		}
 	}

