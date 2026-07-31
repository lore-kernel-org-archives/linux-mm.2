Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CEC0C55174
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 18:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F96B6B00A0; Fri, 31 Jul 2026 14:16:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D14D6B00A2; Fri, 31 Jul 2026 14:16:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A326B00A5; Fri, 31 Jul 2026 14:16:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C96626B00A0
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:16:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B2A8A1A5C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:16:06 +0000 (UTC)
X-FDA: 85049875932.06.01AC92F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B1E72A000E
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:16:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C8mqCAa3;
	spf=pass (imf15.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785521764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wUJP0XuZAHVCju2vCQtbQJIE3DcNFW1LWD6svK3iD8=;
	b=x/IkQS3jsXRc+rlSi4sbHTJB3X29tgfRcKDpc7WlnB9iPGTrQjj4botjfcXhlrJt2PKFYy
	ZNw4xNbCfzW3P5eoIOGyGxxURWJrviCtc4QK26mDV3t/zd9vQ+3C896IwXx0T1rEQghev1
	5BtAYBO6ShTm07C9ChoqK6fUOQq2PCs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785521764;
	b=MperCIREIWfWmVldS5zSwF2ovg4MzqT9euzxQwcXKx3D5kdIDNxpXvGJtc+PgqG8RU6kvB
	/j9923qy+RHvB8dCe/m3Wi17Ym7+BHRrocbfoyJzDhPiP6wliGSOErr6oasY3gwQAEbUJN
	9pdi/K39G5JQZtlIpLf/t92AMLXJY3Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C8mqCAa3;
	spf=pass (imf15.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22E32600C3;
	Fri, 31 Jul 2026 18:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6998C1F00AC4;
	Fri, 31 Jul 2026 18:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785521763;
	bh=9wUJP0XuZAHVCju2vCQtbQJIE3DcNFW1LWD6svK3iD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C8mqCAa3sOez8bYlcdk7Ex9hl1Zc3wGzNlS+gMfhYDFWo2GO6U1oOyWzlb2bPQY+x
	 hqp45+zj52D2OrfKyI0wE6OnSs4tXIB0pDV9h5BA+FBwqNLLssYqEG2iralfKBbWze
	 8TnH2nZgoDMCRUVPIIfWgQ5CX2TqVmWguLZl5ry0GMyg4/zCAi/p/yVuCqOjBPDh1S
	 3CfPkRN86lNOdPWBsocKmexkv/xlcBg6n1fCMbp7GWE8C9TU8+qYac8CviSfGdpNx7
	 2tBQ+HKflUJA/Bs03oR8x3vLAb4l3YfkvzAafZcN8aqTCzekcrr22Gj5IiA+WkyfGs
	 NrtPDLo03P3hg==
Date: Fri, 31 Jul 2026 11:14:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/swap: reject swapon() on filesystem-level encrypted
 files
Message-ID: <20260731181408.GA12803@sol>
References: <20260730184853.48347-1-ebiggers@kernel.org>
 <amy7Biucbf-et5O2@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amy7Biucbf-et5O2@MiWiFi-R3L-srv>
X-Stat-Signature: os7zyqyyog98pw59x1e76onqt64fwmf3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B1E72A000E
X-HE-Tag: 1785521764-562880
X-HE-Meta: U2FsdGVkX19ohUEX2NhKnHIdowRYiivwQvba2+a9AI9OXPr/E/JH9X0EEvCYFbF6Asbj6TivcX8mbV392XU/GTqVGiAXKcjfFGzRbmVuIJxMpi0OEVlSFXbJiqIdwjN1qnyPmMUwTygtenijVwrb6j8ynqUTRg7fduDrCRXSl/QQiHkGw6RmafmfKa0LC2aJddFkLupSB4X1QFBjEi/MTTwl6f0xJZjPAUkVOLOPlwrjEbwLxIGMclp8WxygQJchnxDJ79aTwP+HAIAFSf37maxmguRvsC9r7x8QIfYnZL/VpqMmbsezS1KJTGgCop1V/fV8DrhyDpaegNVmlr0uFudh/hkyeVNd66799cCmq4fpSLrJ5Ek7l6ZUwbZHt/pXYh3ydGOWLzsTUuqLmVxRc7q/l6ugeAPD6wU1031UsJm6SBnk3h8J8zGaw9OFwQJCQjlYAdxLYkN3ISuon7yc5GqPfrbPZR8V3Z1cCJhs5hY8oovVAebR2maRsz0/Gf0TruabsZqRNFHnHYnmTuAp07H9BhQfn9csLbzoJGICgBXhsQmiiTvhatbQ2utFRpfzKA3c6T17tEVd/7qlFXLfIUzgsNlehGt7L00TOVsKXNOLL23BikWN4IpaMXkkMRxCKZSBgnwbGaWy8pLCPnjKIcN3RCEUxJED2qbNXWuXtk4zsKNypiHwwJJcjkt96mXeAmPhhx44IO+1zhIvojl1L2P75P0Q6h3FlF2dsTkBr4UxbRlpOvSKWpz1j8LAiiOphz6YpguEn5HyDwwiRsE+7NlIMAcOR84AY4MOfFz+eMYRpHqjOgr7sirltQpnjuyeL6HEQBRIyTxTrbr1H3uDA5fYeHADSz3+gcbWOIild7fDXWK08b253vGZ6lreAj/h9Vb2GDBRJ3lAQ1EV3QOlUmI09T+1PUzo3LITLqm/fMvVX3kai/ZquwXmjOKhRziH07UsLw2cry6z0F8xsLr
 jqK2aPiT
 FVc6pBleZyr6BOXQkgYNOypGVdueRB27CKlL/50FasHHVd8Q1em0YgTwh8Lm4eNU7p8cShBCEVkvhuw5PTQNmeFQ4D6R8Lf2PSwQv2DZsZldMlyMhdjkN2mdtYsnOahBzQxFjE6EKqdlb3fokNLJGRjMW7+jMJDdQAIiMdClGG8RirBSevIU8N2gnyAgPn7uTdUGfF2Vy+JHAGmGD/RP6B3qZUw25FRIUym9QhQ1w9B3BDe9Mnwl1tz79YK+EgAMHKS+1n0uZ33KJDyk+8y9UR5SX7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 11:11:02PM +0800, Baoquan He wrote:
> On 07/30/26 at 11:48am, Eric Biggers wrote:
> > ext4 and f2fs don't prevent filesystem-level encrypted files from being
> > set up directly as swap files.  In this case, encryption is bypassed.
> > 
> > No one should be doing this, vs. the methods of encrypted swap that
> > actually do work (such as swapping to a dm-crypt device, or swapping to
> > a loopback device on top of a filesystem-level encrypted file).
> > 
> > Nevertheless, to prevent user error, make swapon() explicitly reject
> > this case.  Document this behavior in fscrypt.rst as well.
> > 
> > Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
> > Fixes: f424f664f0e8 ("f2fs crypto: add encryption policy and password salt support")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> >  Documentation/filesystems/fscrypt.rst | 4 ++++
> >  mm/swapfile.c                         | 4 ++++
> >  2 files changed, 8 insertions(+)
> > 
> > diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> > index c0dd35f1af12..cba1989777da 100644
> > --- a/Documentation/filesystems/fscrypt.rst
> > +++ b/Documentation/filesystems/fscrypt.rst
> > @@ -1238,6 +1238,10 @@ astute users may notice some differences in behavior:
> >  
> >  - DAX (Direct Access) is not supported on encrypted files.
> >  
> > +- Encrypted files cannot be used directly as swap files.  To swap to
> > +  an encrypted file, set up a loopback device on top of it.
> > +  Alternatively, encrypted swap can use a dm-crypt device instead.
> > +
> >  - The maximum length of an encrypted symlink is 2 bytes shorter than
> >    the maximum length of an unencrypted symlink.  For example, on an
> >    EXT4 filesystem with a 4K block size, unencrypted symlinks can be up
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 78b49b0658ad..e4991da81b5f 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -3650,6 +3650,10 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
> >  		error = -EBUSY;
> >  		goto bad_swap_unlock_inode;
> >  	}
> > +	if (IS_ENCRYPTED(inode)) {
> > +		error = -EINVAL;
> > +		goto bad_swap_unlock_inode;
> > +	}
> 
> Sounds reasonable to me.
> 
> One minor suggestion: it might be helpful to emit a pr_warn_once()
> explaining *why* the swapon was rejected and pointing users to the
> dm-crypt / loopback alternatives, so the -EINVAL isn't opaque.
> Optional though -- the check itself is what matters.

How's this?

    pr_warn_once("Filesystem-level encrypted swapfile '%s' is unsupported. Create a loop device over it, or use dm-crypt\n", name->name);

> And this patch updates fscrypt.rst. Would it be good to also
> update the swapon(8) man page to document the new -EINVAL
> condition?
> 
> Other than these,
> 
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>

swapon(8) is for the util-linux program, not the syscall, so it doesn't
document error codes specifically.  It does have a NOTES section that
incompletely documents filesystem-specific constraints on swap files.
It's missing most of the current constraints.  But sure, I'll send a
patch that adds a note to there about this one.  That will be a
util-linux patch.

- Eric

