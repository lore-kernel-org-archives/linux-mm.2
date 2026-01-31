Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A58B5D46C1D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 02:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC4246B0005; Fri, 30 Jan 2026 21:41:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A718E6B0088; Fri, 30 Jan 2026 21:41:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96FF76B008A; Fri, 30 Jan 2026 21:41:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 856A16B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:41:41 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1BA75C235C
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 02:41:41 +0000 (UTC)
X-FDA: 84390708402.19.504A47C
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 243A5180007
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 02:41:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=qWC3w5CK;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769827299;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3+SZjilbeej82D6cZd1fnlpNeQE0EQG9Sk/0nsOkcI=;
	b=xKIY5Y7/iWGR4i10QGeZzUxV4lsgHERq3POM0sXViFkXvfU8I4FlcJVwmr7FetYuktTAeb
	AwxXxaypFO+bgWuHXKDuRDQ/sHblyVzVc7QdDUScTX1m5dc7W2l1xiv0IoEdSOf4C44op7
	Bmz290ZaRoVnYfaczyl5qYjX80a6u3o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=qWC3w5CK;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769827299; a=rsa-sha256;
	cv=none;
	b=vKLp4VVOkxHjELaxB6Xjm78jfCznumkZxR6gt95ke5WstQYCffUoiNz0n3W3R13kHrQQhm
	bOaXLYwXtmxppd/dIccRsiH7ApJxbCvPrKpNjJR5DYAx5Fml5lIWZJTkbL0WjvL+M3i/lC
	JPsEaYhB3c8rZhNUV8GDvyRIPBMY3XU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=D3+SZjilbeej82D6cZd1fnlpNeQE0EQG9Sk/0nsOkcI=; b=qWC3w5CKXv3HugEtDLi+gWk6Te
	Hc8cao6e2I9WgDwxI4vEw6/OOMZ0qMbMvoRPxa0zfL889Znbb9v+o6mkUi4R9tqX1mLpzhvD0xoHu
	A1FS75JfMHJT8e1fluxMg79bZ5p2V1SLvWIdPEt+DUYwGQhnCTlCyw5eUykIzMp/SyA3Dg82fzRkd
	W4aq3clE4iJumyrtoBDrf1fy8Q10XImeg/Di9PUsmvPZitiMMiGJVNI5QSEEiTAlGnVVLtoyz8fzu
	SNrXZtDVIbbwXXxKzFeQigWkSVz6jmd8pu1W41IeFVPnRHqFHxaQZ5Lb0Bhj4mQ7n5mCHIm+p4gtY
	REVLuqEw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1vm0xI-0000000E6WY-2rbV;
	Sat, 31 Jan 2026 02:43:24 +0000
Date: Sat, 31 Jan 2026 02:43:24 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Samuel Wu <wusamuel@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel@vger.kernel.org,
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, clm@meta.com,
	android-kernel-team <android-kernel-team@google.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
Message-ID: <20260131024324.GA3183987@ZenIV>
References: <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV>
 <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
 <20260130070424.GV3183987@ZenIV>
 <CAG2Kctoqja9R1bBzdEAV15_yt=sBGkcub6C2nGE6VHMJh13=FQ@mail.gmail.com>
 <20260130235743.GW3183987@ZenIV>
 <CAG2KctotL+tpHQMWWAFOQEy=3NX-7fa9YroqsjnxKmTuunJ2AQ@mail.gmail.com>
 <20260131011831.GZ3183987@ZenIV>
 <CAG2KctoKDsfbyopQYq3-nJBg3fG+7Nrer17S6HqQ+nCWEcHeWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG2KctoKDsfbyopQYq3-nJBg3fG+7Nrer17S6HqQ+nCWEcHeWQ@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: jd3knkmjhktjxsn64hc4pouuj61374jy
X-Rspamd-Queue-Id: 243A5180007
X-Rspam-User: 
X-HE-Tag: 1769827298-255137
X-HE-Meta: U2FsdGVkX19sOCZuuhbKro78YomPNNr15+Im0SPnnKNFQxgYClQ4HL4Fa0cinLYMhkCSYC5cUQ/MfY7q2fH+gDZv9vwNXd5vg/aCZPe/EnkGmEx3YOEe6AzbMCrAmq8TYE5co0agsud6pXhmvos7AOhpQxEIoiDTCKip5XFNqpnMaeDuqCR3W5d7QTLdf+Ry2FOLVjysymjlai+miINPHeeoD7CGKSLuUWnv7HcYHBSLpWhO4XQJNLv+sb4ytdWGXCKu+y1+NsWpbvLxSwGh2Xx32eb6/o769VSKmD3W1L1ekQtgIC0oinlMikegvoi2Y5hVWCoXUMIC3kstLnlXf4SjTfARhoEbHw4cvEvQF2Dl/aMie9zhscchPA4eniaN/5MSplyNUZRjf/Mr8LAfamJr/0SLMtDlzYVDXfKxob7w0E+qNn63dRyK0oqyRIRjX8/sHJ+U0Pdu625RxfYxCkXyemke2GslLofvI6tHz7VdQ1hEu1Kf5f9Bk9ABX0vWAkNaK1WXcXFHXItwvQpvHCvFvPUeBw+Bf0Gm4ps7YEFE58LNwsims2rBxf4tWwXiXKaXnfufkekwZ5hrFSpKi8YiaKAuIi48qdruIfdD4dXPjHiaUmtUj6qK4gKvYZ7VjxOCXYoyn2cVaacn+gUvtAD/GHt4CaNmtifoEWIZPuxLGy/HAO2XuD9KRi62K+tRyu08yRWazOWgPVUwdvaDrmNxmb+Goiggpjtd2GGv0B8gvgFmirKfRcIdxPfodshUV0jf/HTwBeZX08D7FpY/jZVSy+sdBC/8tYbsRYLkQ3J2Fglss3oLjcm7Vu/jy6Mb9qOPLant8KumJ4JZS0IblhguI/ibbFD3E6BTsGC0QM7k6/iGQBmBSDOI5rZM564jlL7g2A2R7pFtmiYcRAVPTCB64elXi1Jwo2l9b09IcRVDmehSN8WLjLiKsgDDpJyxFd7yQjZdvmm8rvgg5za
 ePQu3BS4
 MyXeZPB3BvkRm3WCrPZ+N29jmQe6tSkJGptmlyg+W+OAG9HOSTDDHMOsA6wKu36cOzaYrZpQIKsZx8/81gEXiVOMIl65/fjW58MFzHSt6LteCqhavZbCXe7SlV8VE4E/xCzrkpT58oxu4TLOLO0vAA3JnP0jWwdTlb/EZEHo7+MImy80FuuQPe4uU/Avt7aguPXzIWqUKHNI7X6w9a9clefjxu536oMeJt2c8uOg3/h4Qda+Nj0Pc5yHb+Tov1KSaDurd8HVto7tJFSX+/qaGMz8HbhvXpAwJIh3l9CApx5JTHTguAJZeLG0sqvk8YWRv8GLk4p9MuB2DY35x+J1nkr6YorxH49nUlSnOWP7zHHN/PnXzhrREzQmufwENDFhLL/MqAucTHEKa6A1KZ5i9pX1+7LeOrd1K3umpOIUMPTewxiGN7IuYiIZBklUjcLlfy7jPx4FLKIzAjbJolTBLSxHotptcN54k8jDG7L3oTMGflHFrYA+Qy7815K1VwhXrRYqOoytNmucdY0uhYTqIMz4vbzRx83vIvpl3RkGlXsNsllM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 06:09:00PM -0800, Samuel Wu wrote:
> On Fri, Jan 30, 2026 at 5:16 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > On Fri, Jan 30, 2026 at 05:05:34PM -0800, Samuel Wu wrote:
> >
> > > > How lovely...  Could you slap
> > > >         WARN_ON(ret == -EAGAIN);
> > > > right before that
> > > >         if (ret < 0)
> > > >                 return ret;
> > >
> > > Surprisingly ret == 0 every time, so no difference in dmesg logs with
> > > this addition.
> >
> > What the hell?  Other than that mutex_lock(), the only change in there
> > is the order of store to file->private_data and call of ffs_data_opened();
> > that struct file pointer is not visible to anyone at that point...
> 
> Agree, 09e88dc22ea2 (serialize ffs_ep0_open() on ffs->mutex) in itself
> is quite straightforward. Not familiar with this code path so just
> speculating, but is there any interaction with previous patches (e.g.
> refcounting)?
> 
> > Wait, it also brings ffs_data_reset() on that transition under ffs->mutex...
> > For a quick check: does
> > git fetch git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-wsamuel2
> > git switch --detach FETCH_HEAD
> > demonstrate the same breakage?
> 
> Had to adjust forward declaration of ffs_data_reset() to build, but
> unfortunately same breakage.

That really looks like a badly racy userland on top of everything else...
I mean, it smells like userland open() from one process while another
is in the middle of configuring that stuff getting delayed too much
for the entire thing to work.  Bloody wonderful...

OK, let's see if a variant with serialization on spinlock works - how does
the following do on top of mainline?

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 05c6750702b6..fa467a40949d 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -59,7 +59,6 @@ static struct ffs_data *__must_check ffs_data_new(const char *dev_name)
 	__attribute__((malloc));
 
 /* Opened counter handling. */
-static void ffs_data_opened(struct ffs_data *ffs);
 static void ffs_data_closed(struct ffs_data *ffs);
 
 /* Called with ffs->mutex held; take over ownership of data. */
@@ -636,23 +635,25 @@ static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
 	return ret;
 }
 
+
+static void ffs_data_reset(struct ffs_data *ffs);
+
 static int ffs_ep0_open(struct inode *inode, struct file *file)
 {
 	struct ffs_data *ffs = inode->i_sb->s_fs_info;
-	int ret;
 
-	/* Acquire mutex */
-	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
-	if (ret < 0)
-		return ret;
-
-	ffs_data_opened(ffs);
+	spin_lock_irq(&ffs->eps_lock);
 	if (ffs->state == FFS_CLOSING) {
-		ffs_data_closed(ffs);
-		mutex_unlock(&ffs->mutex);
+		spin_unlock_irq(&ffs->eps_lock);
 		return -EBUSY;
 	}
-	mutex_unlock(&ffs->mutex);
+	if (!ffs->opened++ && ffs->state == FFS_DEACTIVATED) {
+		ffs->state = FFS_CLOSING;
+		spin_unlock_irq(&ffs->eps_lock);
+		ffs_data_reset(ffs);
+	} else {
+		spin_unlock_irq(&ffs->eps_lock);
+	}
 	file->private_data = ffs;
 
 	return stream_open(inode, file);
@@ -1202,15 +1203,10 @@ ffs_epfile_open(struct inode *inode, struct file *file)
 {
 	struct ffs_data *ffs = inode->i_sb->s_fs_info;
 	struct ffs_epfile *epfile;
-	int ret;
-
-	/* Acquire mutex */
-	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
-	if (ret < 0)
-		return ret;
 
-	if (!atomic_inc_not_zero(&ffs->opened)) {
-		mutex_unlock(&ffs->mutex);
+	spin_lock_irq(&ffs->eps_lock);
+	if (!ffs->opened) {
+		spin_unlock_irq(&ffs->eps_lock);
 		return -ENODEV;
 	}
 	/*
@@ -1220,11 +1216,11 @@ ffs_epfile_open(struct inode *inode, struct file *file)
 	 */
 	epfile = smp_load_acquire(&inode->i_private);
 	if (unlikely(ffs->state != FFS_ACTIVE || !epfile)) {
-		mutex_unlock(&ffs->mutex);
-		ffs_data_closed(ffs);
+		spin_unlock_irq(&ffs->eps_lock);
 		return -ENODEV;
 	}
-	mutex_unlock(&ffs->mutex);
+	ffs->opened++;
+	spin_unlock_irq(&ffs->eps_lock);
 
 	file->private_data = epfile;
 	return stream_open(inode, file);
@@ -2092,8 +2088,6 @@ static int ffs_fs_init_fs_context(struct fs_context *fc)
 	return 0;
 }
 
-static void ffs_data_reset(struct ffs_data *ffs);
-
 static void
 ffs_fs_kill_sb(struct super_block *sb)
 {
@@ -2150,15 +2144,6 @@ static void ffs_data_get(struct ffs_data *ffs)
 	refcount_inc(&ffs->ref);
 }
 
-static void ffs_data_opened(struct ffs_data *ffs)
-{
-	if (atomic_add_return(1, &ffs->opened) == 1 &&
-			ffs->state == FFS_DEACTIVATED) {
-		ffs->state = FFS_CLOSING;
-		ffs_data_reset(ffs);
-	}
-}
-
 static void ffs_data_put(struct ffs_data *ffs)
 {
 	if (refcount_dec_and_test(&ffs->ref)) {
@@ -2176,28 +2161,29 @@ static void ffs_data_put(struct ffs_data *ffs)
 
 static void ffs_data_closed(struct ffs_data *ffs)
 {
-	if (atomic_dec_and_test(&ffs->opened)) {
-		if (ffs->no_disconnect) {
-			struct ffs_epfile *epfiles;
-			unsigned long flags;
-
-			ffs->state = FFS_DEACTIVATED;
-			spin_lock_irqsave(&ffs->eps_lock, flags);
-			epfiles = ffs->epfiles;
-			ffs->epfiles = NULL;
-			spin_unlock_irqrestore(&ffs->eps_lock,
-							flags);
-
-			if (epfiles)
-				ffs_epfiles_destroy(ffs->sb, epfiles,
-						 ffs->eps_count);
-
-			if (ffs->setup_state == FFS_SETUP_PENDING)
-				__ffs_ep0_stall(ffs);
-		} else {
-			ffs->state = FFS_CLOSING;
-			ffs_data_reset(ffs);
-		}
+	spin_lock_irq(&ffs->eps_lock);
+	if (--ffs->opened) {	// not the last opener?
+		spin_unlock_irq(&ffs->eps_lock);
+		return;
+	}
+	if (ffs->no_disconnect) {
+		struct ffs_epfile *epfiles;
+
+		ffs->state = FFS_DEACTIVATED;
+		epfiles = ffs->epfiles;
+		ffs->epfiles = NULL;
+		spin_unlock_irq(&ffs->eps_lock);
+
+		if (epfiles)
+			ffs_epfiles_destroy(ffs->sb, epfiles,
+					 ffs->eps_count);
+
+		if (ffs->setup_state == FFS_SETUP_PENDING)
+			__ffs_ep0_stall(ffs);
+	} else {
+		ffs->state = FFS_CLOSING;
+		spin_unlock_irq(&ffs->eps_lock);
+		ffs_data_reset(ffs);
 	}
 }
 
@@ -2214,7 +2200,7 @@ static struct ffs_data *ffs_data_new(const char *dev_name)
 	}
 
 	refcount_set(&ffs->ref, 1);
-	atomic_set(&ffs->opened, 0);
+	ffs->opened = 0;
 	ffs->state = FFS_READ_DESCRIPTORS;
 	mutex_init(&ffs->mutex);
 	spin_lock_init(&ffs->eps_lock);
@@ -2266,6 +2252,7 @@ static void ffs_data_reset(struct ffs_data *ffs)
 {
 	ffs_data_clear(ffs);
 
+	spin_lock_irq(&ffs->eps_lock);
 	ffs->raw_descs_data = NULL;
 	ffs->raw_descs = NULL;
 	ffs->raw_strings = NULL;
@@ -2289,6 +2276,7 @@ static void ffs_data_reset(struct ffs_data *ffs)
 	ffs->ms_os_descs_ext_prop_count = 0;
 	ffs->ms_os_descs_ext_prop_name_len = 0;
 	ffs->ms_os_descs_ext_prop_data_len = 0;
+	spin_unlock_irq(&ffs->eps_lock);
 }
 
 
@@ -3756,6 +3744,7 @@ static int ffs_func_set_alt(struct usb_function *f,
 {
 	struct ffs_function *func = ffs_func_from_usb(f);
 	struct ffs_data *ffs = func->ffs;
+	unsigned long flags;
 	int ret = 0, intf;
 
 	if (alt > MAX_ALT_SETTINGS)
@@ -3768,12 +3757,15 @@ static int ffs_func_set_alt(struct usb_function *f,
 	if (ffs->func)
 		ffs_func_eps_disable(ffs->func);
 
+	spin_lock_irqsave(&ffs->eps_lock, flags);
 	if (ffs->state == FFS_DEACTIVATED) {
 		ffs->state = FFS_CLOSING;
+		spin_unlock_irqrestore(&ffs->eps_lock, flags);
 		INIT_WORK(&ffs->reset_work, ffs_reset_work);
 		schedule_work(&ffs->reset_work);
 		return -ENODEV;
 	}
+	spin_unlock_irqrestore(&ffs->eps_lock, flags);
 
 	if (ffs->state != FFS_ACTIVE)
 		return -ENODEV;
@@ -3791,16 +3783,20 @@ static void ffs_func_disable(struct usb_function *f)
 {
 	struct ffs_function *func = ffs_func_from_usb(f);
 	struct ffs_data *ffs = func->ffs;
+	unsigned long flags;
 
 	if (ffs->func)
 		ffs_func_eps_disable(ffs->func);
 
+	spin_lock_irqsave(&ffs->eps_lock, flags);
 	if (ffs->state == FFS_DEACTIVATED) {
 		ffs->state = FFS_CLOSING;
+		spin_unlock_irqrestore(&ffs->eps_lock, flags);
 		INIT_WORK(&ffs->reset_work, ffs_reset_work);
 		schedule_work(&ffs->reset_work);
 		return;
 	}
+	spin_unlock_irqrestore(&ffs->eps_lock, flags);
 
 	if (ffs->state == FFS_ACTIVE) {
 		ffs->func = NULL;
diff --git a/drivers/usb/gadget/function/u_fs.h b/drivers/usb/gadget/function/u_fs.h
index 4b3365f23fd7..6a80182aadd7 100644
--- a/drivers/usb/gadget/function/u_fs.h
+++ b/drivers/usb/gadget/function/u_fs.h
@@ -176,7 +176,7 @@ struct ffs_data {
 	/* reference counter */
 	refcount_t			ref;
 	/* how many files are opened (EP0 and others) */
-	atomic_t			opened;
+	int				opened;
 
 	/* EP0 state */
 	enum ffs_state			state;

