Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FDF4C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 00:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74C226B007B; Fri, 31 Jul 2026 20:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5AC6B0088; Fri, 31 Jul 2026 20:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A0B16B008A; Fri, 31 Jul 2026 20:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3076F6B007B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:47:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B50F3A1009
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:47:03 +0000 (UTC)
X-FDA: 85050861126.15.750FEB6
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf11.hostedemail.com (Postfix) with ESMTP id E658140004
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:47:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Lp/5WC0u";
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785545222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMek1aawQ8IyooAOw8hjJzP++g15hi+kUNuEx4O2XuA=;
	b=Wp0RS5fbxvkDuzuotv/jIFpvowWhl+pd5rkCHyqfLHn3e8IrTaB/IWb/9VggpMyHo+XXvL
	o5XWzVEr6MzLcHD7Wo2K/AAB9Kyc6wzPKydXN4vMMlMA3+sQtVR0mQQydFtlSai3Vz7GDa
	k3fvUsuoO85DL/qj6du5Yusy5hL0vpc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785545222;
	b=R3/AXV+aqdprDUfuK4c9dGDKLbtF4EO6ThUBsQTVRii/Ron8enL4IZ+bHRtHw6LOtlnEBl
	6nrNJoDm5Wktg4vEDmtXayVgaAOA4n509DkmIYT8/ZejplBKvk0TJS0x1hDi+lgGzET/HZ
	sW8d0PSo1tcfRtlWCjuxvZOfsnxQCk8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Lp/5WC0u";
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Sat, 1 Aug 2026 08:46:52 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785545219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gMek1aawQ8IyooAOw8hjJzP++g15hi+kUNuEx4O2XuA=;
	b=Lp/5WC0ukjnAn5o7N1qqH1jN1lRSaj6RecCQ9ONDeU+uZ3dm1b6L3FalP3D7qZ6EHAhVdC
	VlIh6gP28hAflRVDqF1Bq042TiBVII/vlLXde6jAxOk4MqdsHPCkYT7WPSTm3YwOPD+5px
	ZYNtt22HoOYMfrGxy6XWPDx99Au6IY4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/swap: reject swapon() on filesystem-level encrypted
 files
Message-ID: <am1B_Mz21L54mrDS@MiWiFi-R3L-srv>
References: <20260730184853.48347-1-ebiggers@kernel.org>
 <amy7Biucbf-et5O2@MiWiFi-R3L-srv>
 <20260731181408.GA12803@sol>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731181408.GA12803@sol>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E658140004
X-Stat-Signature: b3ju5sbknjb8tj94j9zcpim63up8a83f
X-HE-Tag: 1785545221-113822
X-HE-Meta: U2FsdGVkX1+RCXU3sxquuXERDRI9iL0/84Xg8F7pWwRHzdmbxljg3rCpLi2ysu0Jz8anbWRw4ad9A/O+Czv80wFMvYidlDmWCjzFMopo6wXtbsEwWciaDF7SffTSTaEVuAde3qKHMyYy1KV3VqNaaAIBBf1E643TLGX94dXMSc8NRkot5Hcfd/HvMb+mRW8AHBcbrSlVckwCamc0S0GXbFrc3Vgeuwrc6IHQbMZWs6dycS16VOQt+BN/qQD2gIiMIbgFtV4r2dosNSRJFK5YMDwgq5RQQ9NMvvny9yAddiZD0G7N+H3+uRNnnLCxpP+jXnVphxiEhnbe/n03Oij8tR1C/vWQsZ1CJQiIzdXkn8e2SXr4qpKSZH/vET43YlLKYjf3AQWrZhpumCyFLawuMATiahiW3/h4yjl6vV5asUf7rqWZhQp6x0zc2PYRUxWX1P2zrZfdKjUGSUYBkwodxeoLj8wS6+3JjeMsNAGZe3w94LdXSXZIzbU8/Rk2nLBVWJ1igDCbUGVp7WJ8pBovKauycDi5Ay7fVeb9n61uUlJYNiEFyAjrqvAEOfPSCxpVAUNdal2ye4vYBwAlFq30xTY+kAPTLHe8KelaIFgjj9qaSmt/YSXcwkCEg+Mt+1kN6Pn3qLeDd6+HhiTQICVVQR1tfz+wJO0jhXy+jlTSkpgEDi0tPjxU9yR6XOgG9vXyjPrUQ9sW4D1Gar4E9hsoB18LAaE6mLmxYZeBevNUWRGmIG9oZVkahbjazpk3CkCddgalcRZyYMVnffDUcPXceQ9sSLfkht2Xq/AYA8wCP8hqLPI5SrqhrN//9h4BpSa+5jleigk//ZA2KA6oBXtEszkuo9bTcO+m8Esr7AWbin20rHMxtvLWdmITMj2TxaNZpx7DR9xo0tMMdY1cRelDSa+aocrzCf767QWN0aKt7TQNSxIAmm29/egla3DhFosmnlax9bQxRLJGc7yeFRT
 kVvzpJtC
 WXiUTUUvhaX5mR33WoXH7LdWop3ZhlNh/W21KInhDXTELf16BbABMf4Y92LBC4PEJa2QMPt3GZH+OjVg8hKXidiPC8AfHNRi+54e0d3qPhZj3uMMyPqQtyNham/Wah3E+yqug83U6vA6GNyeiCWx7pG9kJKYYNXHs6l8sohLi5V9RB2CwyBeJ1cxqxzFThXi27UjZ9FI6xT1Rlgp0BKXynNADByRNcjuRUYL+42NPDj5loxKtekPAVoyNiEvmrnPBBKpB/5gsO+cWfGF3dQ9MzTAPSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/31/26 at 11:14am, Eric Biggers wrote:
> On Fri, Jul 31, 2026 at 11:11:02PM +0800, Baoquan He wrote:
> > On 07/30/26 at 11:48am, Eric Biggers wrote:
> > > ext4 and f2fs don't prevent filesystem-level encrypted files from being
> > > set up directly as swap files.  In this case, encryption is bypassed.
> > > 
> > > No one should be doing this, vs. the methods of encrypted swap that
> > > actually do work (such as swapping to a dm-crypt device, or swapping to
> > > a loopback device on top of a filesystem-level encrypted file).
> > > 
> > > Nevertheless, to prevent user error, make swapon() explicitly reject
> > > this case.  Document this behavior in fscrypt.rst as well.
> > > 
> > > Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
> > > Fixes: f424f664f0e8 ("f2fs crypto: add encryption policy and password salt support")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > > ---
> > >  Documentation/filesystems/fscrypt.rst | 4 ++++
> > >  mm/swapfile.c                         | 4 ++++
> > >  2 files changed, 8 insertions(+)
> > > 
> > > diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> > > index c0dd35f1af12..cba1989777da 100644
> > > --- a/Documentation/filesystems/fscrypt.rst
> > > +++ b/Documentation/filesystems/fscrypt.rst
> > > @@ -1238,6 +1238,10 @@ astute users may notice some differences in behavior:
> > >  
> > >  - DAX (Direct Access) is not supported on encrypted files.
> > >  
> > > +- Encrypted files cannot be used directly as swap files.  To swap to
> > > +  an encrypted file, set up a loopback device on top of it.
> > > +  Alternatively, encrypted swap can use a dm-crypt device instead.
> > > +
> > >  - The maximum length of an encrypted symlink is 2 bytes shorter than
> > >    the maximum length of an unencrypted symlink.  For example, on an
> > >    EXT4 filesystem with a 4K block size, unencrypted symlinks can be up
> > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > index 78b49b0658ad..e4991da81b5f 100644
> > > --- a/mm/swapfile.c
> > > +++ b/mm/swapfile.c
> > > @@ -3650,6 +3650,10 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
> > >  		error = -EBUSY;
> > >  		goto bad_swap_unlock_inode;
> > >  	}
> > > +	if (IS_ENCRYPTED(inode)) {
> > > +		error = -EINVAL;
> > > +		goto bad_swap_unlock_inode;
> > > +	}
> > 
> > Sounds reasonable to me.
> > 
> > One minor suggestion: it might be helpful to emit a pr_warn_once()
> > explaining *why* the swapon was rejected and pointing users to the
> > dm-crypt / loopback alternatives, so the -EINVAL isn't opaque.
> > Optional though -- the check itself is what matters.
> 
> How's this?
> 
>     pr_warn_once("Filesystem-level encrypted swapfile '%s' is unsupported. Create a loop device over it, or use dm-crypt\n", name->name);

Looks good to me, thx.

> 
> > And this patch updates fscrypt.rst. Would it be good to also
> > update the swapon(8) man page to document the new -EINVAL
> > condition?
> > 
> > Other than these,
> > 
> > Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> 
> swapon(8) is for the util-linux program, not the syscall, so it doesn't
> document error codes specifically.  It does have a NOTES section that
> incompletely documents filesystem-specific constraints on swap files.
> It's missing most of the current constraints.  But sure, I'll send a
> patch that adds a note to there about this one.  That will be a
> util-linux patch.

Sounds great, thanks.


