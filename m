Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79B0DD2ECE9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14FD6B03EF; Tue, 20 Jan 2026 08:20:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2736B03F0; Tue, 20 Jan 2026 08:20:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99A126B03F1; Tue, 20 Jan 2026 08:20:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8625B6B03EF
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:20:17 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3551A1AF3FD
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:20:17 +0000 (UTC)
X-FDA: 84352400874.02.FC7EFDC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6AF2E14000E
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:20:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BtzWd0dX;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768915215; a=rsa-sha256;
	cv=none;
	b=C2Vl9ainJgN6NP5RI/8CyvkhGMfK4EV5qOeK+2Ab6mAEN7CIYRRVa+G0TnOF5/BU4rVZkx
	XPPd2tMkxZVFKHmyaJal7oQrWHCFzEeftECGe//9YhTJV4J4k5kYxhtSo6QKXftypU+I+7
	ATB7qE92LeR+j1nOzRZEEOAQEBdoDPo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BtzWd0dX;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768915215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8M3unCvvvCXXWqYVTWs6YOmSdeAHHZ28NvKcawP/Mc=;
	b=2hMN2SS/41QKYPniRE5vZFC9C7YswK5QJE72E4nT4o9XX05vsGTE/GmKFHctQfxLopBrqQ
	vRzkjz9hfKRwYRqSmoiFI4WIFOW4FuirfZQTcbDylVdnc7bd6QDzro+29hTtI1biy4uQ7C
	5rUB4JIJo0S+VajZryW9Rjf7pVAX+UQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 962E660153;
	Tue, 20 Jan 2026 13:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672F2C16AAE;
	Tue, 20 Jan 2026 13:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768915214;
	bh=2q4hi60bazvcilbJNiRaJ1JXOg/rrf7FitaJTcVDTb8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=BtzWd0dX8xBjfl+Rd+agDtCA43l7AAkFA/UsKIDl9a7o4TBkTAytTBAuUr0Qyuh75
	 2N7fm3ZAHeK0SWNrzZRWqfSRMDMMqT3mpkwnv7lmITCL2CwjeO/xepTD7gyE7YHLl2
	 gM+m3vW5GHY1o82g5ze5dgIN3bLPNkibscKkg0isZRuq/GGlvGiuzt3eWvg3a5Pl2D
	 7Xay7ZOUmajqckfhjbuheztwcouRty0bEYtF4WcXwaAwtOWOwNnr8WWChOTQqMKgHX
	 B428QQ2/IOEF+hZbWNjI/5dC68aGe6BBGOTCHedvnLkRZD6kmneMW0MiewKug88TR0
	 XdKyqpB0lgjYQ==
Message-ID: <9b64bed72e43d0bf24e9b1e3bc770c4a87082762.camel@kernel.org>
Subject: Re: [PATCH v2 01/31] Documentation: document EXPORT_OP_NOLOCKS
From: Jeff Layton <jlayton@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro	
 <viro@zeniv.linux.org.uk>, Chuck Lever <chuck.lever@oracle.com>, NeilBrown	
 <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo	
 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Amir Goldstein	
 <amir73il@gmail.com>, Hugh Dickins <hughd@google.com>, Baolin Wang	
 <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
  Theodore Ts'o	 <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Jan Kara	 <jack@suse.com>, Gao Xiang <xiang@kernel.org>, Chao Yu
 <chao@kernel.org>, Yue Hu	 <zbestahu@gmail.com>, Jeffle Xu
 <jefflexu@linux.alibaba.com>, Sandeep Dhavale	 <dhavale@google.com>, Hongbo
 Li <lihongbo22@huawei.com>, Chunhai Guo	 <guochunhai@vivo.com>, Carlos
 Maiolino <cem@kernel.org>, Ilya Dryomov	 <idryomov@gmail.com>, Alex Markuze
 <amarkuze@redhat.com>, Viacheslav Dubeyko	 <slava@dubeyko.com>, Chris Mason
 <clm@fb.com>, David Sterba <dsterba@suse.com>,  Luis de Bethencourt	
 <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, Phillip Lougher	
 <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, Paulo
 Alcantara	 <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N	 <sprasad@microsoft.com>, Bharath SM
 <bharathsm@microsoft.com>, Miklos Szeredi	 <miklos@szeredi.hu>, Mike
 Marshall <hubcap@omnibond.com>, Martin Brandenburg	 <martin@omnibond.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker	 <jlbec@evilplan.org>, Joseph Qi
 <joseph.qi@linux.alibaba.com>, Konstantin Komarov
 <almaz.alexandrovich@paragon-software.com>, Ryusuke Konishi
 <konishi.ryusuke@gmail.com>,  Trond Myklebust <trondmy@kernel.org>, Anna
 Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, David
 Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan
 Kara <jack@suse.cz>,  Andreas Gruenbacher	 <agruenba@redhat.com>, OGAWA
 Hirofumi <hirofumi@mail.parknet.co.jp>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, David Laight	
 <david.laight.linux@gmail.com>, Dave Chinner <david@fromorbit.com>, 
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org, 	linux-erofs@lists.ozlabs.org,
 linux-xfs@vger.kernel.org, 	ceph-devel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, 	linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, 	linux-unionfs@vger.kernel.org,
 devel@lists.orangefs.org, 	ocfs2-devel@lists.linux.dev,
 ntfs3@lists.linux.dev, linux-nilfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-mtd@lists.infradead.org, 
	gfs2@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net, 
	linux-doc@vger.kernel.org
Date: Tue, 20 Jan 2026 08:20:06 -0500
In-Reply-To: <aW8yV6v8ZDiynOUm@infradead.org>
References: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org>
	 <20260119-exportfs-nfsd-v2-1-d93368f903bd@kernel.org>
	 <aW8yV6v8ZDiynOUm@infradead.org>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
MIME-Version: 1.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6AF2E14000E
X-Stat-Signature: ex1k91sn5ca9gct7pxx35oqkadoctzh6
X-Rspam-User: 
X-HE-Tag: 1768915215-427193
X-HE-Meta: U2FsdGVkX19MR/faMP+kE7xoJ4MVHPWlHbOa06qtTEKJrbSdxW3CTt59gAKTS1+JBrP1/Xg70Azi5lkldPIgoic4W1hQMlUyERlfMs+PjYql+RYv6YMvmfG1w+MrXpujsBEMKX9QVDmLiAVp085VpAtlmCfgD0V7JJLqjxwFSJm4gkKau/6m35LAT2aCVb2/ZcfInMBdnmO6pV4V5gYZ4GmzXKuIUckX7MeiOtIX8mYKVOtP4nAx9Ql00OHmBV31mdLzcQhqW231c1KnvNwKWGAtZXRLe1YWSBp2PopcjNRG27GWKxAhMchgzhSpZxKcZTI1TyZerH8cuyayR/mIQS1RJVOADFBM8jGKtOCGKb0mKsjfXwdsuZ937acQAaCJZS796QN3Qulz9cvCwlBmoc66GBhs0W4EGnp8/RGgbaqxtxwbOOU9Atmp5mdH1+vsKDmI4kKALymtEcUReTj0pBFsfiNJEeDvuRF0VQ7yu3dGpD1ZfG0u+cRhmyiaNJ499jut4bwdBteS0zpJ7oDbhsPpncnm0i0UCSinh6Y02rHJoWWHqDm5zJh2817NKZK8gHpyU+Qmhqh2jQUy860qyIKmRGnPFc/g887SmwbpojrM1/P+uzJueYweG+IbSXJiQpG2jQpow8AgMMTFcF1iCduJJUQp7nmCD3igYgFn/y+1yhShHsLbbbeL+m7YQ+B0STaO4Y7XtBVNePHzpzBF1/VHVtHfa0kg3z8gNoJTRiJVdtGU9A3dwHJRPn21ZJtb1Lh1FIfQpnEl7Te6HeGsz+jgzSu6V4SUha4z8epedkU1lrfd+uyTVnFekhrOQanDfQEuX9ccNQ9t3P0t83jku88bmBmUkG8iFumznOt5hbXUA9o/8zBMnBNcnDq/vnHMd6W/gmOjh3U/VvAdzAa9n/wpFEeIbGb5/VbP6yfQNHhaqg0mN0LOzlrq294altOfmd2Og5H2lWVeu9vyt8b
 5NS06y0Z
 5bYTVI2pvEPhT/A6hCBsBB8X82N90JftW5bFQjNtLSaF5GU54KMazKcfjk5o7m3vY52qp4IM8hicNQIEN6rcuGj45qBqey2D5x1yMvzoXZ9jzx54pxnBDzgmn9x/fkcT5A8YBj1/VdtPmYcRW6QARlHe/70Nm3Ii2OeS/G5BdooEtjYZEkXPkDvUo8rVBAmtxqBo9VIUCpy69aiGEPTPJAN/Wutnyb7wYEF32Lr/2/YU5uK4A02G4PwcOI2csrOCQxFpyHARjheJ20Dx1chPKUKtXfxUZ3PN+f/H2QZk/ZFVS6hMSLXmNoimvy1rhCrjHLMY9QGlV/FLOSqdtv5Y2jHxTWEWxrEyLYfp7d5uPnFYqrYQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-01-19 at 23:44 -0800, Christoph Hellwig wrote:
> On Mon, Jan 19, 2026 at 11:26:18AM -0500, Jeff Layton wrote:
> > +  EXPORT_OP_NOLOCKS - Disable file locking on this filesystem. Some
> > +    filesystems cannot properly support file locking as implemented by
> > +    nfsd. A case in point is reexport of NFS itself, which can't be do=
ne
> > +    safely without coordinating the grace period handling. Other clust=
ered
> > +    and networked filesystems can be problematic here as well.
>=20
> I'm not sure this is very useful.  It really needs to document what
> locking semantics nfs expects, because otherwise no reader will know
> if they set this or not.

Fair point. I'll see if I can draft something better. Suggestions
welcome.
--=20
Jeff Layton <jlayton@kernel.org>

