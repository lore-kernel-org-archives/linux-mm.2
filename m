Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72E8CCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 22:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B85C78E0015; Mon, 17 Nov 2025 17:06:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5D3A8E0002; Mon, 17 Nov 2025 17:06:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9ABD8E0015; Mon, 17 Nov 2025 17:06:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 994048E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:06:42 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4CB0A1A02B4
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:06:42 +0000 (UTC)
X-FDA: 84121484244.03.23BEC0E
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9D5338000D
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:06:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=LGGTxIiN;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763417200; a=rsa-sha256;
	cv=none;
	b=u3PI11DoCLCatEyjnDVO9IIEP7rTXbHSGX6NRn58a4Zu0bbHX+IIb1Zw6wLpEVzQmQ7gTB
	79bYvTVCYZJuztGIFf7vh9zeFsunadU8XwTs4z+CD0FOlKt2XP8GwqC/JWZSF4NO3bZPQo
	p3S3arGG7Tj/jqyF4ZYuGdzbXweq8+I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=LGGTxIiN;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763417200;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pa8Bj6Fizee8bOJm05tNzfmFor9U/R6BxTW6KbLJQb8=;
	b=zKb/8zfkP3t2B0Sr3HcyjRfrDWL/bp+CubX0hd5YtvS5nyC7EmeJDC4NAjVLl1CfA2qgjj
	cr66TwlhAtxTgGA+30DGGx8h+OaG2YEWyXI5B2ShYEOX+GPidQmHHUbT0NImrNx2EOCmgC
	/N3FFCnEOOkbDcyQXwHF+IFxI4tpdL8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Pa8Bj6Fizee8bOJm05tNzfmFor9U/R6BxTW6KbLJQb8=; b=LGGTxIiNBdrbm5G2I+cWguzNzA
	zWVvjmo7bkADIlhFP685l1lN8nMOPePMcXYA8HPiQkfsCX2eaHsBhgEmqSlkey+XkLqDp4jvYvvYP
	bjcDbMo44o50n24abxn38PZ0pyf+c868M7DhFitlxq19WV5vC1nlrn867TlFaLsqi96LU2NDUpWkc
	phrUaYp+rXDBb16CZ1LpweTW6OlKcN47whnhIVrsAbduMu+37YeWV/ant1bEjxIR2f4ZgJYP/VAPL
	XTMw5jekKcQsFuy69b1FFiXLw2cnuLnT1rHFocNvmgCtp4kCKDeEKPFGnl6w8KeV7mLyTvQTa8nKd
	NA3ikdXQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vL7Mp-00000007N36-2ZO2;
	Mon, 17 Nov 2025 22:06:35 +0000
Date: Mon, 17 Nov 2025 22:06:35 +0000
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
Subject: [PATCH 4/4] functionfs: fix the open/removal races
Message-ID: <20251117220635.GD1745314@ZenIV>
References: <20251111065520.2847791-37-viro@zeniv.linux.org.uk>
 <20754dba9be498daeda5fe856e7276c9c91c271999320ae32331adb25a47cd4f@mail.kernel.org>
 <20251111092244.GS2441659@ZenIV>
 <e6b90909-fdd7-4c4d-b96e-df27ea9f39c4@meta.com>
 <20251113092636.GX2441659@ZenIV>
 <2025111316-cornfield-sphinx-ba89@gregkh>
 <20251114074614.GY2441659@ZenIV>
 <2025111555-spoon-backslid-8d1f@gregkh>
 <20251117220415.GB2441659@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117220415.GB2441659@ZenIV>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9D5338000D
X-Stat-Signature: nsnn8jcqesyn8bts74oz4oqs5rfcpn7u
X-HE-Tag: 1763417200-106320
X-HE-Meta: U2FsdGVkX1+mvdbY3ECZjBWmOjam0rMPoAzIcnaGdYNGkVKe1/eker/Yieyg8KK3lRwusLvYA2sDftR+C1dWvj5Yn/hbgVd+xnMYdaBejN3UA70JzKdvtHdcWRsFIF61S0qrd/ioXxFrB+enNGJPHEnhd8WR7IYOGxiieZpTeQzPW4T0bSs6N9JoTVNVIOOTJ7jRMyAejyOvD2U8m+giakXYLftwE6cshS1j6baMY5j49W/D5t5Etzha8JtRUoDkss+pyRf2P8Um6idOWtB7XMuj5oz3eTpRwHWSeT1sH9vg2RoQjnFj3UhgISdUsYOJdZVoD7DKvzDzKbtZCyJ1Mte6eBmRgIE4R4/7JEPODnvlM6uJvaPgN8GBKK9Lt+BmsAMD6DMiJnfrHy0/3gSWemy0OSJ3n4Yy93iMXA3H2T/olVRq4zI8xd6d1ReVLZJ3fnHz0DFa9eO5s805TF1ko3Rw5CfboxhnHL01LzZG+PlnyRdUqXPbe53cG3zeIm5QKEvlyErP2R1mV8IZLo6vtzoBMliYSp9YXB4kRMFeMexhq8oZb6PHa5e860Yti4WEMO4T+3uoO1UBR9CRzZnT+5WD+rp127r/Oc8zJaB9rL6keOSDWoVvvdfS67mLal7mL6TZnqvXWkKQu7v+vpTKci5mkL9dy3vS4YYQve144JyvEw6569T4/X2bHfOEGBquan+iPqLEOfK/rPJnIAEteCCx+czRcSb0Htbrz8cTdubP/BdwSs3fMf/BIyqxLqBtObZhkQ18E2x9hQV7evBX6V1hIzqNQEkV/VL7TiGsfbit2EhaYX3Zrv7JOMZh/WqcCs6SPb1LRZruxGNKmCXNd0PYtDzAQXBID/JXTDgzo/KJkz9GJna4m4Ui4xhjhPY/xsIhIRzrgpXg02n+nvmq/5nnr441L8Riy1LX+RGXmu/Ag3myU4jWUppQ6iN6S1JQZVwyeds3cNToiSMCC8A
 hW3/VP9S
 ut8pJj8TzHdcGkQlCIHaHS7YJecUS1xTEQJmprjWTnm8gukj1E8N/4s2ZnwhXEJuKnHSo2ecwSpD23CwmLXunCScdmoHt2M4F3rtBivtj7dnnPF2mtO80TrQOL+9fhJtR68ie55RhpEqUqlGEsLcgdOnEwXZhHmKrsIEFQiwPxdWkuohxu01Lkbee6qBk2dAHKIcOb5OXUUQqFM/sjVjUTha/Gj6B7THrXlHH5ifOfXdX4+HZyK/y8CJv9xDiOYyandEFmeN5J6vCbujeZ9H/kFMDsTH7faKf+w1PLuKwGUBDLYUw7t3E6omieYjC67XIG2cyKatAuXSLIcpfP9wLfapCYx3EezXPrJoxe7ajgfm6iV1Ao8j36AljU/rZfjRVivqKqJkPVoIA/M330lnABb0MvDV91KXn03U/4HUFyA0P5dOmcQilvlMUEDS8IrR/hIJMBqqC1vuMdbhgHAiI2XDN7sF/9WV11U1K0dXgdnpvvyTgDW3Tqy60TO29WEc0m7oClH1G4crFNhfxxMOTEgyaGs2yY5O/xl5u/z8NRvtL/s8w6ERR58Ge+Ei5iACk+6yt6jh2OWoKacW43AEpbn2DQz9s5NgqW+23YbYK4Kmmkbw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/gadget/function/f_fs.c | 53 ++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 27860fc0fd7d..c7cb23a15fd0 100644
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
+		return -ENODEV;
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
 		return -ENODEV;
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
 
@@ -2353,6 +2381,11 @@ static int ffs_epfiles_create(struct ffs_data *ffs)
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
@@ -2360,7 +2393,7 @@ static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 	for (; count; --count, ++epfile) {
 		BUG_ON(mutex_is_locked(&epfile->mutex));
 		if (epfile->dentry) {
-			simple_recursive_removal(epfile->dentry, NULL);
+			simple_recursive_removal(epfile->dentry, clear_one);
 			epfile->dentry = NULL;
 		}
 	}
-- 
2.47.3


