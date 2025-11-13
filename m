Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB866CD98DC
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 21:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55B7C8E0003; Thu, 13 Nov 2025 16:20:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532F58E0002; Thu, 13 Nov 2025 16:20:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46F8D8E0003; Thu, 13 Nov 2025 16:20:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3337B8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:20:13 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E61ACC015D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 21:20:12 +0000 (UTC)
X-FDA: 84106851864.22.5E3064B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1951480010
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 21:20:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=S6rUH8FB;
	spf=pass (imf30.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763068811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3SMS7VBCa5HOAMawflIUN1T2WGvQjK05sPeyzxksjKk=;
	b=BZBeSpiSCIyw0/qukYOKuCH3DQRDeO5YyTlkrzTFzPHWj6RAYbzKhqViyBrd/NoSw8JdQF
	60/1LJBBS8+8zEROe8u/MDIXuVedcON7XEgx57RPCgx02QzYafr1rQmKvDRuPPyjgZxiCN
	KMpbdkUeULH7aofP0/+b+pD4E/7C0C8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763068811; a=rsa-sha256;
	cv=none;
	b=KoXcwkz5shXwf9a1Wy34H1b2TZpxHeK6gc2T0sXcWC67wbLWcFst/wEFNYu3GiFG0dO3wC
	lrzWa8AvLocrQWqwYkDZa8VFlOMPFBV9nXAAdkq05vcdX3bwuA/XmKiK1Lx/2yaSNxV4sy
	rcTcNBNcYM0gU1NNxlryp/P31jf3Mng=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=S6rUH8FB;
	spf=pass (imf30.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AF1D141A32;
	Thu, 13 Nov 2025 21:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C0AC4CEF5;
	Thu, 13 Nov 2025 21:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763068809;
	bh=9y9a2c/jVOu6lhfw2KQmK7c70gHOg4s3VbgeD47eFJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S6rUH8FB57R/UUe04bwBSoaGOYGmurKvFQGiKjaRp+69RaYMny8aJztzOQraBcrQq
	 2lwrKakpi4mw3npKSHEcLjHJYPumZM6bSLsdqs+5vrFZt/jlpgeaTIxOM5qITJXPz9
	 vcfnIkmnsJ7qWYDomwahLU7DQW/0LJ2QhI+mOxNo=
Date: Thu, 13 Nov 2025 16:20:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
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
Message-ID: <2025111316-cornfield-sphinx-ba89@gregkh>
References: <20251111065520.2847791-37-viro@zeniv.linux.org.uk>
 <20754dba9be498daeda5fe856e7276c9c91c271999320ae32331adb25a47cd4f@mail.kernel.org>
 <20251111092244.GS2441659@ZenIV>
 <e6b90909-fdd7-4c4d-b96e-df27ea9f39c4@meta.com>
 <20251113092636.GX2441659@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113092636.GX2441659@ZenIV>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1951480010
X-Stat-Signature: zpj4ctkucnj6idbhnpsw8qisk6fr7ocb
X-Rspam-User: 
X-HE-Tag: 1763068810-562272
X-HE-Meta: U2FsdGVkX18erGM1O/dC8fijbzyXaZVt/sq91mlwk/DKvjnAZmfcfzkjUCQzey9d7mm6L+a+1PIchwAjnYpUPqy2CpuomfmnoBgSHNmu9MYmSdgMQ0ru3Yyh7tRPiLKhR7Ykp0I1oioCtNp7qY4DRsgXy9VKpwGDjs5G6YTpNh1vusRkIgjFt7KPAx8QOk0SWKvG5UtvMQecsjj8XOhNeiJoDGjRPwBg/EzShmQRA7xAofUdsCCxi4VgBt6OpaboxCEa94exEO58CugGEb0rHn+BJRA9BIKlGpPcIxoEyFvZpVYFwvmgygkNm9RRlVBzabHWAFTyqRPet5CEPoHVUV0qv90202tonbkIQrBCRxR7esDAKtYpdqVbiiWsdwyg+AevB8+GF+C7wjCyox06FV5QNW9SHZNv43jF27HIb0fxP0qr7ezMPxtWzfD6bU7cySbyqWF8F/kYZTUuE/OgNYD6Rl0GX+NZToQmxlSs9QPGqspkU6SSa8RnQjF8eKvP/tB/+XW4r6JdAwByZ03mpma1bwp2Gcf7v/uyQFtdxvpMIcu6DfIHDTDYmoSbHGiN0J7r6UI13Y7AEq/Pv3f5N13uF3LXKcdypkB06meA+MHkGKZgEA2N56fHGXsrax9ftVIc7hotNWmriTRdKNIKrCYIsLh8usQfAL/DO9mrHqUcw6bGclAEMcQangxcurhBkvcgozuuYRGIi23wxEfYKIZDg3wuQuFFwxl/QNxL9G8ai23S5C+NSZNE05SQs6/KA1S4VIbhN/necZWRDBBs0W8ewEc03W+mQvY3DhJi3NE/vpHiDMedzav+9xpqf3jNunibc0YW+KJVgLLUcSc/3xT+TKoQjz/ddVEkGuqTkE1PsEOEYRRt9/58d+I2bmNss0/yEnPfbLBbUvi2nD/ZPyHyba8LeCaGbYrjAFB0rCliZ33FWjl0ywuiCXydmbomzQu1ZWfEE5SjmGyDDr/
 WY47JBEs
 g1EsqvVzEyyKwsVIe8qpArMqSqIyxA0k0cNST9y7Y554tuZBQcRZEmWTsXqfUPeTw5b/5oKtZ0JM1jVDg0vMNe1JR0QR8ou/nYbHDj9F443Jh7wqSeEbA9oz9IPPF6DXDHd8hlzyXHrvJBRnUxFFsaFZNAvS6/pwbong3TJHX8DCul/7RbASt76Redm8Z6DT4yCKDPAQ25Ft+2usaDd4f/2/cdS7FzkId6qQnJ252c9v/R2C+PD1IgwcuPfoEfYx+8ot0ldMsPeQKH/0Bgy0PU7xAsx50nzCFL9fJbZxgXwZ6K7qi1W+bHCeVd/RvkY7Gx/pM/ClJ6b55vZgKmg3mF57vKjY92PZrpch76+rVin9WqVVvxfxTF6/Dg2Tjl/sT1oGF2cly1T/Q3VJ75DIo+qGGnvyez0c4mrNe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 09:26:36AM +0000, Al Viro wrote:
> On Tue, Nov 11, 2025 at 10:44:26PM -0500, Chris Mason wrote:
> 
> > We're wandering into fuzzing territory here, and I honestly have no idea
> > if this is a valid use of any of this code, but AI managed to make a
> > repro that crashes only after your patch.  So, I'll let you decide.
> > 
> > The new review:
> > 
> > Can this dereference ZERO_SIZE_PTR when eps_count is 0?
> > 
> > When ffs->eps_count is 0, ffs_epfiles_create() calls kcalloc(0, ...) which
> > returns ZERO_SIZE_PTR (0x10). The loop never executes so epfiles[0].ffs is
> > never initialized. Later, cleanup paths (ffs_data_closed and ffs_data_clear)
> > check if (epfiles) which is true for ZERO_SIZE_PTR, and call
> > ffs_epfiles_destroy(epfiles, 0).
> > 
> > In the old code, the for loop condition prevented any dereferences when
> > count=0. In the new code, "root = epfile->ffs->sb->s_root" dereferences
> > epfile before checking count, which would fault on ZERO_SIZE_PTR.
> 
> Lovely.  OK, this is a bug.  It is trivial to work around (all callers
> have ffs avaible, so just passing it as an explicit argument solves
> the problem), but there is a real UAF in functionfs since all the way
> back to original merge.  Take a look at
> 
> static int
> ffs_epfile_open(struct inode *inode, struct file *file)
> {
> 	struct ffs_epfile *epfile = inode->i_private;
> 
> 	if (WARN_ON(epfile->ffs->state != FFS_ACTIVE))
> 		return -ENODEV;
> 
> 	file->private_data = epfile;
> 	ffs_data_opened(epfile->ffs);
> 
> 	return stream_open(inode, file);
> }
> 
> and think what happens if that (->open() of dynamic files in there)
> races with file removal.  Specifically, if we get called with ffs->opened
> equal to 1 due to opened ep0 and get preempted away just before the
> call ffs_data_opened().  Another thread closes ep0, hitting
> ffs_data_closed(), dropping ffs->opened to 0 and getting
> 			ffs->state = FFS_CLOSING;
> 			ffs_data_reset(ffs);
> which calls ffs_data_clear(), where we hit
> 		ffs_epfiles_destroy(epfiles, ffs->eps_count);
> All files except ep0 are removed and epfiles gets freed, leaving the
> first thread (in ffs_epfile_open()) with file->private_data pointing
> into a freed array.
> 
> open() succeeds, with any subsequent IO on the resulting file leading
> to calls of
> static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
> {
> 	struct ffs_epfile *epfile = file->private_data;
> 
> and a bunch of accesses to *epfile later in that function, all of them
> UAF.
> 
> As far as I can tell, the damn thing intends to prevent removals between
> ffs_data_opened() and ffs_data_closed(), so other methods would be safe
> if ->open() had been done right.  I'm not happy with the way that FSM
> is done (the real state is a mix of ffs->state, ffs->opened and ffs->mutex,
> and rules bloody awful; I'm still not entirely convinced that ffs itself
> can't be freed with ffs->reset_work scheduled for execution), but that's
> a separate story.  
> 
> Another variant of that scenario is with ffs->no_disconnect set;
> in a sense, it's even nastier.  In that case ffs_data_closed() won't
> remove anything - it will set ffs->state to FFS_DEACTIVATED, leaving
> the removals for ffs_data_open().  If we have *two* threads in open(),
> the first one to call ffs_data_open() will do removal; on another CPU
> the second will just get past its increment of ->opened (from 1 to 2)
> and move on, without waiting for anything.
> 
> IMO we should just take ffs->mutex in there, getting to ffs via
> inode->i_sb->s_fs_info.  And yes, compare ffs->state with FFS_ACTIVE -
> under ->mutex, without WARN_ON() and after having bumped ->opened
> so that racing ffs_data_closed() would do nothing.  Not FFS_ACTIVE -
> call ffs_data_closed() ourselves on failure exit.
> 
> As in
> 
> static int
> ffs_epfile_open(struct inode *inode, struct file *file)
> {
> 	strict ffs_data *ffs = inode->i_sb->s_fs_info;
> 	int ret;
> 
>         /* Acquire mutex */
> 	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
> 	if (ret < 0)
> 		return ret;
> 
> 	ffs_data_opened(ffs);
> 	/*
> 	 * not FFS_ACTIVE - there might be a pending removal;
> 	 * FFS_ACITVE alone is not enough, though - we might have
> 	 * been through FFS_CLOSING and back to FFS_ACTIVE,
> 	 * with our file already removed.
> 	 */
> 	if (unlikely(ffs->state != FFS_ACTIVE ||
> 		     !simple_positive(file->f_path.dentry))) {
> 		ffs_data_closed(ffs);
> 		mutex_unlock(&ffs->mutex);
> 		return -ENODEV;
> 	}
> 	mutex_unlock(&ffs->mutex);
> 
> 	file->private_data = inode->i_private;
> 	return stream_open(inode, file);
> }
> 
> and
> 
> static int ffs_ep0_open(struct inode *inode, struct file *file)
> {
>         struct ffs_data *ffs = inode->i_private;
> 	int ret;
> 
>         /* Acquire mutex */
> 	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
> 	if (ret < 0)
> 		return ret;
> 
> 	ffs_data_opened(ffs);
> 	if (ffs->state == FFS_CLOSING) {
> 		ffs_data_closed(ffs);
> 		mutex_unlock(&ffs->mutex);
> 		return -EBUSY;
> 	}
> 	mutex_unlock(&ffs->mutex);
> 
> 	file->private_data = ffs;
> 	return stream_open(inode, file);
> }
> 
> Said that, I'm _NOT_ familiar with that code; this is just from a couple
> of days digging through the driver, so I would like to hear comments from
> the maintainer...  Greg?
> 

Sorry for the delay.  Yes, we should be grabing the mutex in there, good
catch.  There's been more issues pointed out with the gadget code in the
past year or so as more people are starting to actually use it and
stress it more.  So if you have a patch for this, I'll gladly take it :)

thanks,

greg k-h

