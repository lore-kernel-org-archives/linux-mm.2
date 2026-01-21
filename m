Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E929CC44502
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 09:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F5056B0005; Wed, 21 Jan 2026 04:58:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A30B6B0088; Wed, 21 Jan 2026 04:58:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184476B0089; Wed, 21 Jan 2026 04:58:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 083FD6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:58:38 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0AF11AFBCC
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:58:37 +0000 (UTC)
X-FDA: 84355521474.25.FD45EC5
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7CACA1C0007
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:58:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b="u/+XlkNJ";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="K sgHoYF";
	spf=pass (imf20.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768989515;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SJFJMNOM7awUTkwMl4hIh6WDIUWbLKvHg9WhRsfaf2c=;
	b=P49orB5+//fxDZ/sO35nVYQdml19OVtHws6WJbvjGRyCyxRSHBNkXg3B/vQGLrjmhffNrV
	HuJyP9uT+baw+ljoImiDeihlyKTWO6lF4mYE0f7o9gz131pWEMQmLklJChtMCz+t9/mtyN
	idYjBs1XAfsbTaRH6cxPhviKoW5lIy0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b="u/+XlkNJ";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="K sgHoYF";
	spf=pass (imf20.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768989515; a=rsa-sha256;
	cv=none;
	b=Ll4nxzd00BxdvsM461p1ck3WZkYrzwJBmzG4/rk4yDgdlbGfUcano3uN7YXL0pnP0pXkXW
	L0VENPo0Vl9kzbvp5jQJqMBx4Fw8a2f8kCgKSRZf1p4TVtnbKdyMNFpdB0lRT+9a3Btd+6
	o7c9hHL98DBgrIRK7YrUV3VQeF4yYdY=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailflow.stl.internal (Postfix) with ESMTP id 451251300E5F;
	Wed, 21 Jan 2026 04:58:32 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Wed, 21 Jan 2026 04:58:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1768989512; x=1768996712; bh=SJFJMNOM7awUTkwMl4hIh6WDIUWbLKvHg9W
	hRsfaf2c=; b=u/+XlkNJ5V8C5rphAsXf4CRGr0/yY85HzlfIyvdWMIOWXjkQsZL
	hepFVBVO1TGy2MoYqvQ7u24GdOhaMOyN4g29b2duuwJtKYPuWULecyd+MTKRrnGd
	bn7kIcDBwiSCpdoLSUnyYvsgKKeCh1a1dboVMEHTkywI3/WnmYN3GCNjLf2VRDaS
	mz10UPqJbOR5v9xAcZGKcH9zcUO4BUeKjYMDUBeMoVj1ZC1ebbxPD9BY7qRT3PmC
	Gwn3pbkB6fVbCnilSsQt/utzs+2skAgouKRc4vJtaZN+evNBodtN4J3cJ2k+j3M7
	oBRpH6fOpkxc7s+UTVvfrzOozmRmPn80CPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768989512; x=
	1768996712; bh=SJFJMNOM7awUTkwMl4hIh6WDIUWbLKvHg9WhRsfaf2c=; b=K
	sgHoYFPnq/EWy/oXN2LK4RtBbAtHJ8+lCm2EZp7IwyvLgqOVBaJq5V/djUpulah9
	UZ0lnTRqDqpfgEWG2bwPTyIhf+OkxtllFSCCXe8SSJx40Mx4bOPORKRjQmxip1hr
	Hb36gWUn1deRpKO7vBAa/3uHu4mrPFLZ6AyHhEPvNlMxLsivck+jYIJfvJxUK3BQ
	GCt+NV5AdMTQ9cbmkjq9uYNtDwzHhARKjkpF8i9scEBGI7u7PYYWuik1qWV+s+zq
	gG23IiKM5UnKmkw6iHYCl3/e/WqQdwf43M3cAuoYqYAcuk/YbwF3Gb61tiHUVMiD
	2n2dL6Sl4cIXHxXek/iYQ==
X-ME-Sender: <xms:Q6NwadpokZr4zUG9s3yceH_yGV-75ZmEqaCw1iMpcdO-7P_bqHmGqA>
    <xme:Q6NwaYq2ihpc8yBbDG1PVuLPaKeWe_7VoQt8GacEUU17dyYTuVoNw4BKpnWFQRT-4
    Xg1led3wwge8NMYQ6_6srDDet02RciO8TD0ld2euMF5b0iDjA>
X-ME-Received: <xmr:Q6NwaW9rCqB8cw6Q2kJ-ijrsI9kO3BQ343rhJ_gbt5YTx-pU0BQLrEVYYLR7F-XOpzmXxNsMMi5DLL_oShZmUtCCtUc08foOiDNqnALDYUDz>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugedvleekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurheptgfgggfhvfevufgjfhffkfhrsehtqhertddttdejnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epleejtdefgeeukeeiteduveehudevfeffvedutefgteduhfegvdfgtdeigeeuudejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
    esohifnhhmrghilhdrnhgvthdpnhgspghrtghpthhtohepjeejpdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpd
    hrtghpthhtohepghhuohgthhhunhhhrghisehvihhvohdrtghomhdprhgtphhtthhopehl
    ihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinh
    hugidquhhnihhonhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehl
    ihhnuhigqdhnihhlfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplh
    hinhhugidqnhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhn
    uhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlih
    hnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqvgigthegsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:Q6NwaXP_r1AtxnebpNkWh0ccYaXxkWUlkdex3I21_ko1xomksZ4zhQ>
    <xmx:Q6Nwadv_3MuYvlxZn64JB2BnqApISdsMFoP98SEqbGk-2TZ7AkLEZw>
    <xmx:Q6NwaZ3nfLV93Vtn6SIHnsAzPzQFUB9XxFmo0He_Kd-2FrGyOzYc5Q>
    <xmx:Q6NwaXZBKV6NDhrR9j2xzoxiBc-32Bgplw5GGYFI5LL9zipce5X4Yg>
    <xmx:SKNwaTXSyiSStct1wtcBjcLkfs8d66i92fMj1g3ySdmDH9qv7jDxxYWO>
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jan 2026 04:58:08 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Jeff Layton" <jlayton@kernel.org>
Cc: "Christoph Hellwig" <hch@infradead.org>,
 "Christian Brauner" <brauner@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Chuck Lever" <chuck.lever@oracle.com>,
 "Olga Kornievskaia" <okorniev@redhat.com>,
 "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>,
 "Amir Goldstein" <amir73il@gmail.com>, "Hugh Dickins" <hughd@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Theodore Ts'o" <tytso@mit.edu>,
 "Andreas Dilger" <adilger.kernel@dilger.ca>, "Jan Kara" <jack@suse.com>,
 "Gao Xiang" <xiang@kernel.org>, "Chao Yu" <chao@kernel.org>,
 "Yue Hu" <zbestahu@gmail.com>, "Jeffle Xu" <jefflexu@linux.alibaba.com>,
 "Sandeep Dhavale" <dhavale@google.com>,
 "Hongbo Li" <lihongbo22@huawei.com>, "Chunhai Guo" <guochunhai@vivo.com>,
 "Carlos Maiolino" <cem@kernel.org>, "Ilya Dryomov" <idryomov@gmail.com>,
 "Alex Markuze" <amarkuze@redhat.com>,
 "Viacheslav Dubeyko" <slava@dubeyko.com>, "Chris Mason" <clm@fb.com>,
 "David Sterba" <dsterba@suse.com>,
 "Luis de Bethencourt" <luisbg@kernel.org>,
 "Salah Triki" <salah.triki@gmail.com>,
 "Phillip Lougher" <phillip@squashfs.org.uk>,
 "Steve French" <sfrench@samba.org>, "Paulo Alcantara" <pc@manguebit.org>,
 "Ronnie Sahlberg" <ronniesahlberg@gmail.com>,
 "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>,
 "Miklos Szeredi" <miklos@szeredi.hu>,
 "Mike Marshall" <hubcap@omnibond.com>,
 "Martin Brandenburg" <martin@omnibond.com>,
 "Mark Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>,
 "Joseph Qi" <joseph.qi@linux.alibaba.com>,
 "Konstantin Komarov" <almaz.alexandrovich@paragon-software.com>,
 "Ryusuke Konishi" <konishi.ryusuke@gmail.com>,
 "Trond Myklebust" <trondmy@kernel.org>,
 "Anna Schumaker" <anna@kernel.org>, "Dave Kleikamp" <shaggy@kernel.org>,
 "David Woodhouse" <dwmw2@infradead.org>,
 "Richard Weinberger" <richard@nod.at>, "Jan Kara" <jack@suse.cz>,
 "Andreas Gruenbacher" <agruenba@redhat.com>,
 "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
 "Jaegeuk Kim" <jaegeuk@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>,
 "David Laight" <david.laight.linux@gmail.com>,
 "Dave Chinner" <david@fromorbit.com>, linux-nfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-unionfs@vger.kernel.org, devel@lists.orangefs.org,
 ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev,
 linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-mtd@lists.infradead.org, gfs2@lists.linux.dev,
 linux-f2fs-devel@lists.sourceforge.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 01/31] Documentation: document EXPORT_OP_NOLOCKS
In-reply-to: <2ed97731c54ef130ea58861a91c80dacd785de9a.camel@kernel.org>
References: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org>,
 <20260119-exportfs-nfsd-v2-1-d93368f903bd@kernel.org>,
 <aW8yV6v8ZDiynOUm@infradead.org>,
 <9b64bed72e43d0bf24e9b1e3bc770c4a87082762.camel@kernel.org>,
 <707f08e114bf603caf7de020bb630d5477e86bca.camel@kernel.org>,
 <2ed97731c54ef130ea58861a91c80dacd785de9a.camel@kernel.org>
Date: Wed, 21 Jan 2026 20:58:06 +1100
Message-id: <176898948697.16766.1729756714812778707@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7CACA1C0007
X-Stat-Signature: pnd3s6gmad53om4spex67w6e1i4gyd4s
X-Rspam-User: 
X-HE-Tag: 1768989515-407174
X-HE-Meta: U2FsdGVkX188MgmX+h0/GZT4rNbSCrkKHfRd5a2iWc+0CKcOLWvJQ6naV21tdd9VII+VQKH+JXs0mM5gf8dRxKXoKPqwrcjdLUdaACIgvv/tsgafcP1SRMEAUngPQb6a10zuoEYHOSmHh1G7juMvHEysDZMSv6a5G8YzjgNYnJCYng/klYTtzlLS4Y+d4HtDWb1dxn27BPLVIeGUGcqE+2P+TKjGj/hXWcXkxrib34CsuWWw+TYlDrCAmoOqptRH4R6AvpYdxDLYOTTrQj7dK0MnGvImX2b/3yArWT08Wa2sJP6zIqvKilywH/4uSNFlTRBa779inrgXkFjrwS2FJ3aewZm+wYExop31hNuuwa2TeHFay45u6O/Kv5tS6HWbl9ujVP18DADlXgDUyvkcyMNDEzLe0zEaS767EMyOBzzFm1TL+DMMkDu+cxE/lRj171AMcHSxzNxn679qtxhO6EAsmsqJmyGSldtiEukBJJu4kkC9ecVBAyqofDY/0V2xS+oULNg8pZGFptEPyRNxympbvPGeTawC5hHAW/Mvu8LkJWxkFdu/+sRIY15dOxDpUoeM3Hgnlx8N4T1uIxx0PCHxR709lRyt9/bJtslq63fNfxXg52+35dU2yx+AIVos1sSgVpwMwZHOciU1T//s2A8SOxvdgzYQbcZsVU/a6EnT9/GS7p8H++mfPJsFMhaGIUoaHE47ZpITkg4Mkxm+cKqxOLphwVJZgtZrDdhVyeArjCdvjZ1Omiuy/5HayBTHxd3B3bz7dOeLtwmF31/JAB3VoEnTE8HLg2PU8xL/5MpaZh8E6KBm7AM2c75DKMnBJntZBT1up4QKmM6zds11oUixHBErc7yBCpPCrt2frkVAbPf8b5/po1I0JrEwvIWt1HBkjB1cxu2n96PCnpOTfRF5OFg4rwwubsP5dV93pQrsPpAgqjipb49kgIq6BhPjAyx+a0ycNbeWr3S2Xbr
 AWhTvVqI
 9ItKKHKwgUiqLnW90wPurwzhsH7UNw53hxgGsaPrwowxNhC8EoaEb0g+8UtVlwEoOO+vGqJ3cOv/stkvvVmM3kVi3OmEUocyeNWvLd9pb8iZB78WcbIkvZDwO2EbXm1z5LukNCRxpaNtSPt6TZ0YyZaxZslOLJ6+hjBzSw3yBNucjNmf9tXDezFefniTjy1rkDlzBnm89CialN5y6pw2gTMeJvR4i9OFNwW5EEqvZ6QvW4ARowtY+gnL5VwK7vLWXzy1A5T+2BwQKtX/ONdUETle3Ftez6Exy0msq6ONRMmJtmbVMTCic+aPMFtnPMV/KsfCmXQKv6TC4jjSV2sqsD7A2rD3XG20rcqUZJC9THmqLr/sbhDcnHBvW2C0jRqbRAejz+VzfU3y9ijadZCNu1xBWmI8JSvJsEdLtCIBAGq7oedO1AzgNReQZwoOWduWcj0/2+t5pKrR1LHtwzAnbNkc0jwrY/eP+IO9HMjkjZ57OIMr5SYSinK6c24TmHcU5RL5ygzDY7/FZblEpjCKBVqcuq9sEoxpR+KQNQ4uDRd2KsHsVDbsnANopCP90K7k0YOUKMLDzELwhiApQTeJBLGif4ci5iEHCMDy1qCcMAFkVJUF56/dCzELcE0vJKDJbZyYzeIqEFqgLyCpgWqV1ZBIcY1U4cj1fV5z/tLEotZt+Al72Hd9wRPz6gEQQTOvLRx90w9wOePTpTHSczDh018XWEU4WnP+gEck3JdEd2hn8PGM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 21 Jan 2026, Jeff Layton wrote:
> On Tue, 2026-01-20 at 09:12 -0500, Jeff Layton wrote:
> > On Tue, 2026-01-20 at 08:20 -0500, Jeff Layton wrote:
> > > On Mon, 2026-01-19 at 23:44 -0800, Christoph Hellwig wrote:
> > > > On Mon, Jan 19, 2026 at 11:26:18AM -0500, Jeff Layton wrote:
> > > > > +  EXPORT_OP_NOLOCKS - Disable file locking on this filesystem. Some
> > > > > +    filesystems cannot properly support file locking as implemente=
d by
> > > > > +    nfsd. A case in point is reexport of NFS itself, which can't b=
e done
> > > > > +    safely without coordinating the grace period handling. Other c=
lustered
> > > > > +    and networked filesystems can be problematic here as well.
> > > >=20
> > > > I'm not sure this is very useful.  It really needs to document what
> > > > locking semantics nfs expects, because otherwise no reader will know
> > > > if they set this or not.
> > >=20
> > > Fair point. I'll see if I can draft something better. Suggestions
> > > welcome.
> >=20
> > How about this?
> >=20
> > +  EXPORT_OP_NOLOCKS - Disable file locking on this filesystem. Filesyste=
ms
> > +    that want to support locking over NFS must support POSIX file locking
> > +    semantics and must handle lock recovery requests from clients after a
> > +    reboot. Most local disk, RAM, or pseudo-filesystems use the generic =
POSIX
> > +    locking support in the kernel and naturally provide this capability.=
 Network
> > +    or clustered filesystems usually need special handling to do this pr=
operly.
>=20
> Even better, I think?
>=20
> +
> +  EXPORT_OP_NOLOCKS - Disable file locking on this filesystem. Filesystems
> +    that want to support locking over NFS must support POSIX file locking
> +    semantics. When the server reboots, the clients will issue requests to
> +    recover their locks, which nfsd will issue to the filesystem as new lo=
ck
> +    requests. Those must succeed in order for lock recovery to work. Most
> +    local disk, RAM, or pseudo-filesystems use the generic POSIX locking
> +    support in the kernel and naturally provide this capability. Network or
> +    clustered filesystems usually need special handling to do this properl=
y.
> +    Set this flag on filesystems that can't guarantee the proper semantics
> +    (e.g. reexported NFS).

I think this is quite thorough, which it good ...  maybe too good :-) It
reminds me that for true NFS compatibility the fs shouldn't allow local
locks (or file opens!) until the grace period has passed.  I don't think
any local filesystems enforce that - it would have to be locks.c that
does I expect.  I doubt there would be much appetite for doing that
though.

Reviewed-by: NeilBrown <neil@brown.name>

Thanks,
NeilBrown

