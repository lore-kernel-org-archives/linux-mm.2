Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03FA4C44500
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 22:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED80D6B0005; Wed, 21 Jan 2026 17:48:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86F76B0089; Wed, 21 Jan 2026 17:48:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5DFE6B008A; Wed, 21 Jan 2026 17:48:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C77BF6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:48:14 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F1E313C6D0
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 22:48:14 +0000 (UTC)
X-FDA: 84357460908.29.D434760
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf10.hostedemail.com (Postfix) with ESMTP id CCD60C0006
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 22:48:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b=GuovOWXR;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="G Qln8ft";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf10.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769035692; a=rsa-sha256;
	cv=none;
	b=CGk+lcI6FwQxVpkruSMqhWWKqOrtDaifVzHdaiqKzspP2VNWFU21MtLmjyrMOYHgeD+Vod
	+ATLmMG73i8Rv8+Hp607EpS5QMAFx+tZTVi9QoVpzRDmy6aSEsubDOm9xQZFiu3j5Xtw1C
	dsLIb2YTylS4iRiy3Xj2lj1JyRg+byc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b=GuovOWXR;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="G Qln8ft";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf10.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769035692;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5coOyJl4iosEMxvKLf9pz/D+NbUu48dkiDD9Y2kxJME=;
	b=sjbjBRpqTLEVMEI9I2pj5BDAU8he6Pzv0xrZepDJ3BpiUoowDBc3DOfGLiBmfslV4m9OWu
	evbziGxhn2pBxs3U/gQUZa0w0KuyN7A5omX93ppzx4ySaxo10RUVgKJet4H10GUAU2TH1v
	XaQdFf7KfR2p3sr2150aFPvq840cHEc=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 8D6A31300F24;
	Wed, 21 Jan 2026 17:48:08 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 21 Jan 2026 17:48:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1769035688; x=1769042888; bh=5coOyJl4iosEMxvKLf9pz/D+NbUu48dkiDD
	9Y2kxJME=; b=GuovOWXRBLUE5OJcSyLnE/2eveX/36uTx36j9P93zjQcQRBZQL2
	hrnzBjQOgzs/f0q+zVSV1tWHCGJeldpGO5tNxzbNYGAmGERTI/74rC4AhDEcwnbN
	3EK+IxK9Da7qBxTZ0cL7/5RdElCmK5xx1WEmeVCQTAdbEDCJzhvLIyYH/VUBXRn2
	h49SQEqoXX9n4peKNOiWNTGeGPiK9qsGhIMzVRsfQ8nV0r0CSHnLs3nYhgIfpNL3
	aRQdXpKb6VS0ww0j3QddijYoBo1Kwrkcj+Ox1b+DG22Mrte7SY069e+GdbfIhnlj
	3VqqpOkLrd4aGQop2LrD926E4486pl+anPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1769035688; x=
	1769042888; bh=5coOyJl4iosEMxvKLf9pz/D+NbUu48dkiDD9Y2kxJME=; b=G
	Qln8ftBpavKFAA+sJNEPaaNr8oKurXmo3q4BaVp9GwaWB1fm8C563yxGcgYW93DS
	2xtNzCjbtolaXD67qz6Qutqe5geB5bsD8Ugeg6j/LWjxuo9XwZj1mmfo4drLgUP2
	yKqhpGLcalZ4u5NUgfoc97greSYLp54DwzSB4S6wHw4u2msQsbGk5ZA8IJMGNIbQ
	ngZ+8m6ZYaIowc/dHLMNgP5a1uqvjsJX/qkbUxNoCKOD6a2oW1oaQNc62xAi1nw9
	1ilzAzJcDO41rfb5T7w8GgYR5Vyc6IoiPl6WjnE4pmvyLFxhbYKi59Pm07XkqffD
	MH3MYMODbYPIXIIlLoSWg==
X-ME-Sender: <xms:o1dxaZ-cMFc_o0d43ug7z0kzLEBmcLr7-qnETyPvdBZuqqtXE2bH3w>
    <xme:o1dxaWu_cgJpAPDvXRifHWGeBvpSKMc12f7rFBgOoG_tMemlpn3xQTXYgCwgfa7tz
    OXDCzuK93xla979oqbjqOFhStCl3Vabm505SJATmkmL4XzdyA>
X-ME-Received: <xmr:o1dxaTxZPCOrm1mlblqPiWzOX285XPSCGpXm-fKvOvS9y7eJCkfR7O9aWP_lCWxHfYgXgfjqf3Vws4y9gRuwORW00qGz0381O1TtjVlRJXe1>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeeghedvucetufdoteggodetrf
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
X-ME-Proxy: <xmx:o1dxabxtlAdkhpwCkINTEBpxmOYNyzwJPUiM41SluU32_hzzNA9XZQ>
    <xmx:o1dxafCKgd9STI3lGSZvVjQToHTy1h7liCKSrmU9waffzwMuC1NFUA>
    <xmx:o1dxaY793FR_a6LdPfr_ZHshxnAh_1jwBDA6jddarcyZMxIXycacjw>
    <xmx:o1dxaRMf9cXehnUejISjAclfFWLd7Zsy6-U0xLPbufXx8cPynQ1yZw>
    <xmx:qFdxaSd_vulaCSCn1gwPqzAJtzBUIYK-Pjhk-xVuA_6gzPYpL8lA2saQ>
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jan 2026 17:47:43 -0500 (EST)
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
In-reply-to: <d8d68d1df6838c382799ce58345cfb5366585a8f.camel@kernel.org>
References: <>, <d8d68d1df6838c382799ce58345cfb5366585a8f.camel@kernel.org>
Date: Thu, 22 Jan 2026 09:47:41 +1100
Message-id: <176903566115.16766.12892778448343562390@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CCD60C0006
X-Stat-Signature: ecjy8kkhccd31qtbwtkcm1qwzu7i58o3
X-HE-Tag: 1769035691-67061
X-HE-Meta: U2FsdGVkX1++SmhZaq9OjxXTC7+RIwyj5S3eBlbL7/Xzc/bEwCNdci7M2tKTSYjZdyC30BqAp3lZgZsri77njoNiiVZsee8RVGgGz6re1h8U8AxWjMhZqr+mtcrUwQf6ZaphyIhhL++ZgrcnbSgPVzf6TlF83ZwreCKLNhF+jPtMjvNYROh7xodaw+9VGUGEUJix7goF6oA849fcSClIWa0wfVWcY5J9PRpkmp4hauX3wEhE1PZWMwI7rgGyIBdddS1hLh2UAvXrgrndLmfmnJsDDgWsm/2laX90phFZd6LObniofH+qpjjFh4ir4OVDj8Rw57+W17Q38LgiSyXac/H4pfdQWOZTFIXd95KdIfRC6LUD7SwoUAdWkvyA+x3+xxpf0IzlV9BAb/ZmFEZoXeIAW5Qf41iU+UiCUoK3zVYpUFMPgN7Nqc1sl8Czi6QYwdxErQyFt9RBIxaB7L4UTRybQ51xCxT3NpMQN51jHATTXNYHimRvGnt6WMU3TbBZTFuCHCoGWV/IYZPBQcf2TjgOGiIO5pB+kI6XCNB+RwDWW0Hn8WG+tMy0I4qAVw3YHP49/Sv0tQhsIYiNekYfqaCpfb44AO/fidqXV2G6F4zQRdaULf94kk36yow4PADz0/eomtLulfuuzJjE267jVAqKk9+57giCGFCmetEYLHTwlQxsoN9JqKI9Vm1NcDnBDJDP2fCwFyPp75HYdA3Nhr5G6FzSmisiGS+/cU9aJ07fHITRJDtlyZzi1UmurGbvfYNQQ1o6KTi3ottu98g77CaS0PsSdtBU7HEYHOp/Da5Fc4RUMHbHQWPF0mf+AkrGGxgOzG7iPPfUfQRA3G9rdh0UB7X6WlQg1nXg0P4k0N0ziafsSMaPi/Em+639IJxYZWC59pd3kPZczBJEvknBu9PWe1wo/+nOCGqy9ffJ6QuKA67wWjUwp87PTNQCQVTvtsqebAH2nZUdt6FC1CX
 29pmjCLc
 jf/nMivzAhxywlJykj/xMNLQmXqeZECcaKKLYPSZMGWXUw7u0fq33AaWbQVmK++fBWqC+261TiFXkF2TYGQUiRPrXpaHHgQ5I3ZSDUJpgQQoVm5l9d+J8wgwq4b4NhigVqlm/EuObJv4kZK1S1YtjglpRWXCgwo0RbJRWnxUpj3IEQR5S7VfJHSXgVTrlgf5rIcwAX3mMgbZ/2CEJxgbRy1nyfYBSdr0Rg+Tjy17+WMEEMPpUspJJL4sG7qxVPokdUWBciXQ2RoZXIZKpohFFqDqODMHl1EpQx6yoqZzTciphs7I69y6cuHIL12K5BYFai7GLn4aA+FDH+4JaszS5wPbQ827sC2D9FKiB480DQnOtvyJR+V52GgFeahPErE7LzIAZHgppJ+F267Ly++6Ea5a2dJlGR3iAaWnLCqwouSEUQtiaS+KwcztL0T09HoTH5vTaaHw2ELv8Ki2E8vrx77GvLwBE8u1qxG5cTZIWDI4MEQnjf+ZhiwJLJ4hFaUyNsk2aHT+cCxK5F21P9a7CLsTw2KLCA6MUxqRL56IS8lcrMqrYo8vbWd19C0wKz9c/brSJm0h4mDmkqzQ3XKhQxv70MwOMor0VmDMVc7JWGa+flvnmAlBRQqhCKbs8Q59YhIwm37Iq4Ds1A8z5Vn3dz/BiB0j29gBqMGc/mKMA8htozNQ7ku1IgbQBW1/WhZ5NVmhnfd9KxWIQCwR3ZxVDZ5/YfKkOOlD4a39Ztcn2IH5m4K8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 21 Jan 2026, Jeff Layton wrote:
> On Wed, 2026-01-21 at 20:58 +1100, NeilBrown wrote:
> > On Wed, 21 Jan 2026, Jeff Layton wrote:
> > > On Tue, 2026-01-20 at 09:12 -0500, Jeff Layton wrote:
> > > > On Tue, 2026-01-20 at 08:20 -0500, Jeff Layton wrote:
> > > > > On Mon, 2026-01-19 at 23:44 -0800, Christoph Hellwig wrote:
> > > > > > On Mon, Jan 19, 2026 at 11:26:18AM -0500, Jeff Layton wrote:
> > > > > > > +  EXPORT_OP_NOLOCKS - Disable file locking on this filesystem.=
 Some
> > > > > > > +    filesystems cannot properly support file locking as implem=
ented by
> > > > > > > +    nfsd. A case in point is reexport of NFS itself, which can=
't be done
> > > > > > > +    safely without coordinating the grace period handling. Oth=
er clustered
> > > > > > > +    and networked filesystems can be problematic here as well.
> > > > > >=20
> > > > > > I'm not sure this is very useful.  It really needs to document wh=
at
> > > > > > locking semantics nfs expects, because otherwise no reader will k=
now
> > > > > > if they set this or not.
> > > > >=20
> > > > > Fair point. I'll see if I can draft something better. Suggestions
> > > > > welcome.
> > > >=20
> > > > How about this?
> > > >=20
> > > > +  EXPORT_OP_NOLOCKS - Disable file locking on this filesystem. Files=
ystems
> > > > +    that want to support locking over NFS must support POSIX file lo=
cking
> > > > +    semantics and must handle lock recovery requests from clients af=
ter a
> > > > +    reboot. Most local disk, RAM, or pseudo-filesystems use the gene=
ric POSIX
> > > > +    locking support in the kernel and naturally provide this capabil=
ity. Network
> > > > +    or clustered filesystems usually need special handling to do thi=
s properly.
> > >=20
> > > Even better, I think?
> > >=20
> > > +
> > > +  EXPORT_OP_NOLOCKS - Disable file locking on this filesystem. Filesys=
tems
> > > +    that want to support locking over NFS must support POSIX file lock=
ing
> > > +    semantics. When the server reboots, the clients will issue request=
s to
> > > +    recover their locks, which nfsd will issue to the filesystem as ne=
w lock
> > > +    requests. Those must succeed in order for lock recovery to work. M=
ost
> > > +    local disk, RAM, or pseudo-filesystems use the generic POSIX locki=
ng
> > > +    support in the kernel and naturally provide this capability. Netwo=
rk or
> > > +    clustered filesystems usually need special handling to do this pro=
perly.
> > > +    Set this flag on filesystems that can't guarantee the proper seman=
tics
> > > +    (e.g. reexported NFS).
> >=20
> > I think this is quite thorough, which it good ...  maybe too good :-) It
> > reminds me that for true NFS compatibility the fs shouldn't allow local
> > locks (or file opens!) until the grace period has passed.  I don't think
> > any local filesystems enforce that - it would have to be locks.c that
> > does I expect.  I doubt there would be much appetite for doing that
> > though.
> >=20
>=20
> Yeah, I don't see us ever doing that. It'd be a tricky chicken-and-egg
> problem, given the demand-driven way that the mountd upcalls work
> today. We don't even know that anything is exported until something
> asks for it.

statd keeps state in /var/lib/nfs/sm, and nfsd keeps v4 state elsewhere
in /var/lib/nfs.  This state effectively records if any NFS client might
try to recover a lock.
I think the v4 state is granular enough to identify the filesystem.
lockd could be enhanced to use the same state I suspect.

We would need to generalise that state and load it at mount time and
block new state creation accordingly.

i.e. this would have to be a vfs-level thing which nfsd makes use of.

Possibly, but there are other things better worth our time.

NeilBrown


