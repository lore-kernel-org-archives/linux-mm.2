Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE936D73E9E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 22:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2073D6B00A3; Thu, 29 Jan 2026 17:52:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19E396B00A8; Thu, 29 Jan 2026 17:52:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B4006B00A9; Thu, 29 Jan 2026 17:52:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC5746B00A3
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:52:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82904B8341
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:52:53 +0000 (UTC)
X-FDA: 84386503026.17.BC9E3F0
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id B0C66140003
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:52:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Xd3s3aE8;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769727172;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzC4ieMh6vmoXuGrRF8AJfVTPzFDIVwsq0W+97NeH6I=;
	b=WahUPHtehRoFr3PzE3HqOuUg+kxN94kEj20ge18MM4JOGfwhYRL1Fyc6Mru6fwEYX9qF2y
	M30XZ14ZP44oWqxPLrCOc+sCvn7mlUuX+JgKHo2RcSD6IXVLJPKiK83hEX1PMa99FM/etK
	0SxnUJ0g8pajPkdh/YOSoVs3FxiixRM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Xd3s3aE8;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769727172; a=rsa-sha256;
	cv=none;
	b=AeRBUT4P8YHiCnOP2onWQ+XPE5JmO+HXi4wjS3q3QxFbRdtiBpKfdCjJhAo5sovpPsBhgu
	Bsbl3pQzZe5VZ5Q8d3y+LW7O1p1pHWqfm/lC/7OWWG/AnZYd2t37/ORVKsCwIbm7REKrAs
	7zYuZKPLYgC6ktEqUyfggnrt8UZHfuc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=NzC4ieMh6vmoXuGrRF8AJfVTPzFDIVwsq0W+97NeH6I=; b=Xd3s3aE8lP0Iuf76XmQmTqyylY
	kyjYtmWz3WE5Wp7qeyPuSNsrn7VnrFKLBLvg1QeejST/l0HFm8A1qmVzFffJgrhLWXrFqbyf6a33e
	/22zqtNz8ozygjvj4by61/hPWVbdmEB1InvlYHMIf70seSv2TGIK6fBViv/wS7HAbDGRBmDvmj2ZB
	JntUzR5O2yOGBeO5kVkWDZ996QY77yEhYaT27vlMP0zpBJ3x2kyXvwFS0IvjUmVIU8AbZJaqR0rdb
	wrNWss8rPX4hfCo90x1Ou0DJDoWZBnnF+jopJxNrM5FqeIqToCi5KntAUvJccM6KN/Cc2/WSy2jpw
	jyJAcUeA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1vlauH-00000007wty-0EGP;
	Thu, 29 Jan 2026 22:54:33 +0000
Date: Thu, 29 Jan 2026 22:54:33 +0000
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
Message-ID: <20260129225433.GU3183987@ZenIV>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh>
 <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV>
 <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260129032335.GT3183987@ZenIV>
X-Rspamd-Server: rspam12
X-Stat-Signature: rxtyjgjqi6e5kh5ui8stf854xoyor943
X-Rspamd-Queue-Id: B0C66140003
X-Rspam-User: 
X-HE-Tag: 1769727171-389282
X-HE-Meta: U2FsdGVkX19zytgo4p2fKCEVWdTqzetg+Qqj/z4VXGHmnSv7JaXjhQZoUTuWIxeP5vgOvzbpIMl5h3WnXWIbweuXToCsqTRgj2VS4Z4uA/pPLElpcX2pMPv3LGCDqGJvkHnyRwQOK7fMBpIJZVSWcubf8DRmpcHo1k6Ph9BbsPytx7wVGqCD8WMsqp3Jio0oSz2+c2tSEgQR52f3xnBydPlW0lp0KltiNmcbKGdjfeMEcEj4rYgCB7EqV+BEmwW0l6Lasfa0UL+hqyHn0fd3+UYNettAu0cgXsK9JWAwe6R8iJv/7Hng2+tOF7wL9IrM3+IlGYo3swfR1V5ip2iNF9yvyNsWoMwyf/maZGr6oT1zn+YvVtP4K2lnAL8ScLwEwoVuFeGOpxYOEBga7a83OddzCN/+faNON9dto+wMakE/454ppy+huNUokkQ6MyecEXEe0vdrVYVcwMo3ZXSs3OKLdKiH0m4jgL5fZr88E0Leser/gA/4u74iz0Fwxh2VnNuE93YqL3cC7D52fyHBGksX7bczYHSKD1K6urhIWHgfb33k7mT1THKcIzWZITnod7uSt9cHbnrR2WM0qlxkHovVixV87DK58iquZUkBdAfzmPJP3Xgvm6vN1ro+FYeoy5BqEkkbICBQuml+w5/aUz8v20rv2Qw3VTM1LmGl3JpGqdWBCB66OF2PEr1lJEjiPcqIvb7BOaXtdUbrItUsJtmS6fi7RLvaD3ASP+IlQXZUpjb/42DLyAQlIPhEEN/ouvEDQxNRZx+AXmNA+yUgBzAGAKWt4fW9FcVDMugMh3uXjR0N8FepzGLz/QFuLZ59EQOHJP/8B7C+G7XuccK/norBUivEBordcDJwh/z8vOHYZytU8SZ7baKWizLmI3cqGrFAzr7Nx12IAFWWaonE5QAWM2CQ1FVk+pp2+PVRBFe6NVj4Kk48/xmLTzQv/JT/CjSD/rqw0ANWHkl6Fm6
 6w6AwaAv
 nvYKORyYAftSmq+xxf0go8QY14G63CbFH6nN864uBlOOrQRQ+evUMjjLqKD/Gvd/LIuvWj6PhiXlJ0vxLXrgJfwbQoFAwDC+kFEfzBWNP5QfRR2QE76uFaeWrcPhf5Toi2FXBTzbfAp8CGd0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 03:23:35AM +0000, Al Viro wrote:
> On Wed, Jan 28, 2026 at 04:58:57PM -0800, Samuel Wu wrote:
> > On Tue, Jan 27, 2026 at 8:58 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> > 
> > > Very interesting...  Does 1544775687f0 (parent of e5bf5ee26663)
> > > demonstrate that behaviour?
> > 
> > Reverting only 1544775687f0 (functionfs: need to cancel ->reset_work
> > in ->kill_sb()) does not fix the issue. With 6.19-rc7 as baseline, the
> > simplest working recipe at the moment is with 6ca67378d0e7,
> > c7747fafaba0, and e5bf5ee26663 reverted.
> 
> Sorry, I hadn't been clear enough: if you do
> git switch --detach 1544775687f0 
> and build the resulting tree, does the breakage reproduce?  What I want
> to do is to split e5bf5ee26663 into smaller steps and see which one
> introduces the breakage, but the starting point would be verify that
> there's no breakage prior to that.
> 
> 
> PS: v6.19-rc7 contains fc45aee66223 ("get rid of kill_litter_super()"),
> and reverting 6ca67378d0e7 ("convert functionfs") would reintroduce
> the call of that function in ffs_fs_kill_sb(), so the resulting tree
> won't even build on any configs with functionfs enabledd; are you sure
> that you'd been testing v6.19-rc7 + reverts of just these 3 commits?

Could you try your reproducer on mainline with the following delta applied?

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 05c6750702b6..6c6d55ba0749 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -646,12 +646,11 @@ static int ffs_ep0_open(struct inode *inode, struct file *file)
 	if (ret < 0)
 		return ret;
 
-	ffs_data_opened(ffs);
 	if (ffs->state == FFS_CLOSING) {
-		ffs_data_closed(ffs);
 		mutex_unlock(&ffs->mutex);
 		return -EBUSY;
 	}
+	ffs_data_opened(ffs);
 	mutex_unlock(&ffs->mutex);
 	file->private_data = ffs;
 

