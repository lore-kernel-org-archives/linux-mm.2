Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0B51CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 11:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFED56B0005; Thu, 28 May 2026 07:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0336B0088; Thu, 28 May 2026 07:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC5C36B008A; Thu, 28 May 2026 07:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C8676B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:54:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 457AF1A080C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:54:43 +0000 (UTC)
X-FDA: 84816671646.03.E10F695
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id AFC1314000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:54:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TqPvOn1B;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779969281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWDXgypc/7XooyW97XM8K/TWQykaNtrC+ELRkmzs9jk=;
	b=OiOVDANOUvDpzItusWVgXI1Nx50tEFnBVO0x1EwsP6bq+e/51aAEIVJdEEJsrycQzEthQA
	KlGaZrF00mdRNNz6j3Hvfy+YnIaqYSu/gjJWtA2Zew+iH702G9eoy7cqXgSrLcqOVCOxYg
	Su7eKGtsDArx8BseGfXbUWCqTc0JlJ8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TqPvOn1B;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779969281; a=rsa-sha256;
	cv=none;
	b=C/QS3dT2oimtqma1wdYTpEeLOsuxLCVRQkMLqL7bvxX5UT7/Flz0bs/HnNFKLRz3rZM6Ay
	BServZuHGcTDqhcSHeQH5DNtnL0vYd2FnpnNU+MjNuAjXeBU4mjAwU17eInGF4lmjxvBla
	BvlFx1Oq4xKYJC5kmxRT/jjLAZymbZs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F5F2601DD;
	Thu, 28 May 2026 11:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9981F000E9;
	Thu, 28 May 2026 11:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779969280;
	bh=EWDXgypc/7XooyW97XM8K/TWQykaNtrC+ELRkmzs9jk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TqPvOn1BLY5HNy2XQTNp3rfgM5ZSnWb9w1Q0sDdSCzMEBGniOisYaEaj4aSaabiQr
	 3fGzjMMyHa5yCJBM2853gj6h8T0N96bHhz1EAA5vdbQxyl843T6c6tpX7fHy7kHkE4
	 TSGhcKc+p44nhjR7V9dL4x0b7fHT2H5KhF/avwXCxwdOORgdrNGwavUotFkbxmk4f9
	 q6Cq6bhzJ/4ALknDd8Dun5mIJgnpR4EpsPrG2WLPRRosJ42w6jhR4cn4b5HSdGWmGo
	 +/575jOvQ5LEQneF/1h+zG077ZMa+AARJQc1HyC3YekgpottsIWdsviDnSgeaVEiiJ
	 3tjInNdJYnPQA==
Date: Thu, 28 May 2026 13:54:30 +0200
From: Christian Brauner <brauner@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
	Miklos Szeredi <miklos@szeredi.hu>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 14/17] fs/namespace: use __getname() to allocate mntpath
 buffer
Message-ID: <20260528-geregelt-unsozial-apathisch-c8b484e0932e@brauner>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-14-275e36a83f0e@kernel.org>
 <lwnrjpmzbv6swapmnmb5jki3xxxzqsxuks5vykniwhakvhqh7i@rhff3qrwfnoj>
 <ahVisehwQGXEoM0g@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ahVisehwQGXEoM0g@kernel.org>
X-Stat-Signature: sor7qoqspn7eo98ib615u1ozoj5oucj1
X-Rspamd-Queue-Id: AFC1314000A
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779969281-708098
X-HE-Meta: U2FsdGVkX18+4CttkU5/0DFCJ2ILUlp9qzbbNXxgCFfDeZqlqHgPpIor0HmmmgxJ6tM1hmNX/bmSTcdVXvLD8q6z59IfuHY3JmAVSeKn3R42BsI7M8vKAdfnM3kon8QwfIlmRts77uaKcBB8yOWNTZss7jz/AksjlcwuTnaES6CHEHyrfkTNuIos/EfwaTXUsoWPvqDNtqwH7PNqoMgVO7yBMWrBeufnMZ/HJSoBR9i2P20Zid+gSDnQUanc9daWXLMJXK0eOl++b00SX3QdDbjjHewXvRsP++jtpFsdezcmq01osZBcPxL6w3dQoE8qAQPHDP7Au1MThtai3BGGOPkAQPb2FbYTBXeXvZ7DBzK+UCaf6QSICcajNzktGh8YBINjlBc5a1GzyWvJLfQrecAXqFartB/HydBu/UEGEYjgf7lMzGheBGTPzmgrSpGdsi0HPjlBoKSok8uP462zV9mWDDmEZy20dvGZ0hdfikX/CwnMc2Cg7e5IVSO1xNqosYIYZITM9k1BS3NOEdUuK7f8QGUWEJNiT4ASuOUEOuyk5y1yzufgB7WNOOPnRIrTwME/XbEeFSPWdDc/WvUEayhhL+PJ2qlFV811G+aqcBfXdBZSYbGJLKZ+Ypx97AldTA1rWNyt2DwgeUvfgZoIzcN4zziZoBgqCvY2RIRZ54hLxEhwnDOa0jpwMJCOpna4mCdYNkkfb9fBUQpI+8tjhGzxa3b0SKrHUtTxTeJ0y56VSLnhx9RWP4C6zmfhNO2WybPRqT3d6ePjPYVka52tiCvGSb3I1usA3fn5ZYYi1QZd+Td08Vtj2Eh21PfjzuQ/GxGvUxzg3hWSY4r3erxD5x8/Gio5lykwj2k4AbwiQlyxkHLs/r/IqIzmEHbLFcp6ZQUyqgZ1T/V4GyyQHCJzDQxXMpFlu9CzC2r0Tn41xgYFcl+Rgm5Y2HGYd4zQW2aRLl5CSf65SJEJUn4E33x
 qixCKdsr
 9Yb5B2ifSLy8HHSLAu1KpXt/Wo7Nug3ovBrbimPTMU6hok2ZgJFttRHGvm8fwDyfkqmXajFfOw5MfFUibUe7B09yDK4anmt01sqEsdaRZCKqiQJl1IGQuN+im/y6qr/w1z7jRI+gzl9dYdNKqvOdtzuviJ50URabDIg1SMwrBaBxPCN0jZqf71mVIPc5sp2CHAX0r9xoRjht73vcTPUTb0+XSZJEHbQfAhhDvStWG2Hl9BPKS8ijNb8vOv13bBqgebCLHY2rTR374trqAqK3skfpT8l1hjtzT5SZ/+InRYdUsomVtG93zABU/8I9Qj2gY+5pDNuo4lP4Ey6hEeVIY67vnCo5EjyJx5QZarut7ZeJY1dhrExHQx8A+UxtGmRVy112Wloh24buYO/eb58KSuW6SxLonRvIGzn2fKSErR5x0qXQkzehXyQq886XQxtBg6MYe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 12:06:57PM +0300, Mike Rapoport wrote:
> On Mon, May 25, 2026 at 06:22:13PM +0200, Jan Kara wrote:
> > On Sat 23-05-26 20:54:26, Mike Rapoport (Microsoft) wrote:
> > > mnt_warn_timestamp_expiry() allocates memory for a path with
> > > __get_free_page() although there is a dedicated helper for allocation of
> > > file paths: __getname().
> > > 
> > > Replace __get_free_page() for allocation of a path buffer with __getname().
> > > 
> > > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > ---
> > >  fs/namespace.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/namespace.c b/fs/namespace.c
> > > index fe919abd2f01..2ed9cd846a81 100644
> > > --- a/fs/namespace.c
> > > +++ b/fs/namespace.c
> > > @@ -3303,7 +3303,7 @@ static void mnt_warn_timestamp_expiry(const struct path *mountpoint,
> > >  	   (ktime_get_real_seconds() + TIME_UPTIME_SEC_MAX > sb->s_time_max)) {
> > >  		char *buf, *mntpath;
> > >  
> > > -		buf = (char *)__get_free_page(GFP_KERNEL);
> > > +		buf = __getname();
> > 
> > Fair but d_path() below should then get PATH_MAX and not PAGE_SIZE.
> 
> Ack.
>  
> > >  		if (buf)
> > >  			mntpath = d_path(mountpoint, buf, PAGE_SIZE);
> > >  		else
> > > @@ -3319,7 +3319,7 @@ static void mnt_warn_timestamp_expiry(const struct path *mountpoint,
> > >  
> > >  		sb->s_iflags |= SB_I_TS_EXPIRY_WARNED;
> > >  		if (buf)
> > > -			free_page((unsigned long)buf);
> > > +			__putname(buf);
> > 
> > And __putname() is fine with NULL so no need for the if (buf) check here.
> 
> Will fix.

I've folded this myself.

