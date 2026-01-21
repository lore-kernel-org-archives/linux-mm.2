Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BF35CA5FBA
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 03:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91FF66B0005; Tue, 20 Jan 2026 22:58:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6E16B0088; Tue, 20 Jan 2026 22:58:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B85E6B0089; Tue, 20 Jan 2026 22:58:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 652E56B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 22:58:55 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E60685AC60
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:58:54 +0000 (UTC)
X-FDA: 84354614988.24.776017B
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8CA984000F
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:58:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b=YYEr2VjW;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Y 4kSyYf";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf27.hostedemail.com: domain of neilb@ownmail.net designates 103.168.172.138 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768967933; a=rsa-sha256;
	cv=none;
	b=kHyxHJJsQ0geTt5MNWFnDmzCja18Slv+WF/0juHBvCo8cGSwm0MQcdcn+V9fKuO1qgGb9S
	eRoYlOUX2grOLgljRgtlgoari/SWsxEeUcTnSuwAGEEPVboks+RlxWMVqPgsFdXfiPBTNC
	FmJaMRbuDITedUMXYmYAesciCKbUZag=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b=YYEr2VjW;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Y 4kSyYf";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf27.hostedemail.com: domain of neilb@ownmail.net designates 103.168.172.138 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768967933;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HPgiNusZcZTF/ZTl66piD/9BsmWo5Gc2+jAKaL+zbjo=;
	b=IQM7jgU7s49T3lkjyOXBYEyLcGsj2hZkIqaVExeRihs3tlIQBtyRp9Fmbap4sgmuaejEQf
	ePCPcgJ6L2ltR+6rI2vP+V+lzHqJTSk0uBmwvYmoG3pKE9Utx5rTaI13Bd3E8sRViOJ3Cz
	WknfujOEPWevz16vWe4cjpQmswYHF5k=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id 59F6C1380787;
	Tue, 20 Jan 2026 22:58:51 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 20 Jan 2026 22:58:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1768967931; x=1768975131; bh=HPgiNusZcZTF/ZTl66piD/9BsmWo5Gc2+jA
	KaL+zbjo=; b=YYEr2VjWIaKtDqIQ9vfEWExooQB7WdoWCHPbIyCUEJI6BAxeQcQ
	Lbk8vsbd4GXH0kYHJaGcChinGdfj9GfFjBP2dVOEb1g7c0vP40XWPDTq6qbmdX+f
	q8U4adtBeg5EFoL6E5HUF62j7hOUy4j8XFCT0i4fYg4se8kZH51qgrZqOSAUlTga
	rl7CFzO8J+PeDJ7M2JSUWHisN0sDH8S0NMXRz8qdtkwm9W98zD3C3gklDbkWIXrK
	vRegxtY4BxrRjprMIjBdoVNMCKrXQqfmvm/+rjsgzuPUZ23gzBTcc6UXYC33cLAY
	vFj8n0R7qJgD5zcyYlJT/0wZ8oNx4to8Sng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768967931; x=
	1768975131; bh=HPgiNusZcZTF/ZTl66piD/9BsmWo5Gc2+jAKaL+zbjo=; b=Y
	4kSyYfnUGNoNeVLU3ka40YnKW2sl+45SitUqyg7vTCZpQcxFqZev1sh8sHAo4DzB
	LJJuIPm7kr1a2T2O/jCPPqyfpx1RyAZnMeJxrzQuzh0MJ2v9HwC0x1U/ypjUALTY
	LkBS/sHDc8LkvX0vZjnTUcBNoleBEEaONsgjyNXSYbPCsyTNNhNqwnjeRYEYWhC0
	Keyf4hXJLJ2uIP8nM1JZTI64DK90fYZcMdZmLKhtCiDOLF6zK0pOuLIFL3efcAnh
	U7QNK8cCXtqL4iHqmwf38GI0o4feHmUs9gVmK1fgy3LCnOLy087fTAjf+2UjG0tL
	Zxk2nmIhddHGej/ASyZkw==
X-ME-Sender: <xms:9k5waa6xGMlhNWG7OiNFHfIpLvabWA1DAPtyEn94taKAb8B-mUoW7w>
    <xme:9k5waRR7ItrMgf6WBso9qWSvOzTjS1gqDa4US3nP2_YPOGpBhCwjdwQRddvH-EWFV
    V57p5_-4xzEl4CNusEssTAjoVs4ZFelbrYFxoXbJ50yHbQn>
X-ME-Received: <xmr:9k5waeoZsLXtAC9WGWMpKfuL6jcuFf0eBU9OKagBSlfpxrmBa-z1UpdKQRgAi22TvEjMRNRptGtFkHbPbhda8VF8Vv99_8wlEjUQv-qrj4y4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugedvvdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurheptgfgggfhvfevufgjfhffkfhrsehtqhertddttdejnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epleejtdefgeeukeeiteduveehudevfeffvedutefgteduhfegvdfgtdeigeeuudejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
    esohifnhhmrghilhdrnhgvthdpnhgspghrtghpthhtohepjedvpdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpd
    hrtghpthhtohepghhuohgthhhunhhhrghisehvihhvohdrtghomhdprhgtphhtthhopehl
    ihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinh
    hugidquhhnihhonhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehl
    ihhnuhigqdhnihhlfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplh
    hinhhugidqnhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhn
    uhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlih
    hnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqvgigthegsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:9k5waUhf0LUODlL_PQYsCPf5h1Hz9YtKoS8AL4OAL0YUoX9vGv32rg>
    <xmx:905waSCsyLL7f6fuPyvb6LM-a8AMULf8pIsT5TNPUcN888plxn2vJQ>
    <xmx:905waT9XbBSmLAgfzGT6kRdfvn_ApgSn62i1cNhe3-zAYtSYAOgBDQ>
    <xmx:905waTEUm6W92v2m08NAsDI3Dm--lHbflm-x_CKDQ7Y36cOw-DiEBA>
    <xmx:-05waa7eNM5AFWgAvsYRXTN-gn5rTHGxvGEPMtNHM76v4SM6_x2afNUS>
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Jan 2026 22:58:29 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Jeff Layton" <jlayton@kernel.org>
Cc: "Christian Brauner" <brauner@kernel.org>,
 "Christoph Hellwig" <hch@infradead.org>,
 "Amir Goldstein" <amir73il@gmail.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Chuck Lever" <chuck.lever@oracle.com>,
 "Olga Kornievskaia" <okorniev@redhat.com>,
 "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>,
 "Hugh Dickins" <hughd@google.com>,
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
 "Jaegeuk Kim" <jaegeuk@kernel.org>, linux-nfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
 devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev,
 ntfs3@lists.linux.dev, linux-nilfs@vger.kernel.org,
 jfs-discussion@lists.sourceforge.net, linux-mtd@lists.infradead.org,
 gfs2@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
In-reply-to: <a35ac736d9ebc6c92a6e7d61aeb5198234102442.camel@kernel.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>,
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>,
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>,
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>,
 <aW3SAKIr_QsnEE5Q@infradead.org>,
 <176880736225.16766.4203157325432990313@noble.neil.brown.name>,
 <20260119-kanufahren-meerjungfrau-775048806544@brauner>,
 <176885553525.16766.291581709413217562@noble.neil.brown.name>,
 <20260120-entmilitarisieren-wanken-afd04b910897@brauner>,
 <176890211061.16766.16354247063052030403@noble.neil.brown.name>,
 <20260120-hacken-revision-88209121ac2c@brauner>,
 <a35ac736d9ebc6c92a6e7d61aeb5198234102442.camel@kernel.org>
Date: Wed, 21 Jan 2026 14:58:25 +1100
Message-id: <176896790525.16766.11792073987699294594@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8CA984000F
X-Stat-Signature: nszwf46ccfd48hdm6c8kg4zhk61ftx17
X-HE-Tag: 1768967932-881650
X-HE-Meta: U2FsdGVkX1+Y5qZkmmpn6lewgbOFzqg3JdVTlZZFpZQJNDyGeEUwar3zBL9DNI39bIeD8ide3ZWjMy3x+1P5SedzBYva6s5NZ4VYd4i5n6ycEr0zohLx8pWvjcp6XXrYGj9KQUXXf5fzdjvD3943kjxTIIFcN3L9ebwY8OQ2s6xxepYXtWE/NDztOWtzjr3KucxdeCJXdFhB2VMWpv1S/h/2pzq9eMOOIeF5atcp/3lv/QowNmkhx/G3B20e0t25yJzx3w8guTjknUxukkhcp5jOCYglit6wzopmhgmxISLQ4E641jizOLbzpzVyF/ce9ShWkj48ylxgI2YIbIEV9AtqXI9ouxqmtDD10LaEID7y9Yyx2jDIJRyP8tfS8vhEVfZlRNUBAiIYdrzW4boD+xB5Y4X500u1aTSD4ug3ts4Lsp7XUiXPuz2VGtYKt2TOREHQZzaA90J9U7nFcTO4OU8epRTY5WyiOOFIJD4Xjfu8ZNuK0vrixg6G6IzIYOSEPP8EJqcKXxhGgCSR5Gn0OwQ/QFaQfexntvdAtkCRef4bH4PBEJnK/dz79Ppglh6fW79LA5T2ZqKQiXcAGWdi7hee39dI29X1RsThSKLZ4ug64LROnWE2Na4m/AbKkWdF7/6xXdhYzUuwxQFq1WQeJLfVOBsVmxkOxfHIbGs/jOhlqhSRce85VX9b35Q+IYif9/wOH5qvb9olZMMfTLgRR3BfcO9AlcLRuE5wY9/pg3a27YeXh+dAG+htcxBsJGkYoNgEER2GV/SSR6BDTBwY/k162Tr76DhGiO1dZgUn4DQND/95MBvQB5ekpm9t0LS0xnpKeZJE1+t18UiyIq2W4G4oJU3FMRrNnrLc5Gh/hhz9oVyF6jxR5dSL/61+59xiEvNpnuujobmQgiR07U+XZZtdGWDIpoVNTYPeldVrjYp2Icg5fnxhe8/XfvmifbBi2VVpTguMND1ddZwCBt1
 QWS0z6La
 g4z5wfu/lQLjS7+DRaNvbkhOmO5moEGJQwyd2VAQ02qsLmHyLYgr+SxyHS4TOc+e44BPjzS6ZOA7etnKFgIlvKHQ4OmHuips0Xy+HDoLR2bKoVp9wRxvZsljLHPUP5cQkIbFcps2NDfivB7d4CxbrdHQvEDNY+Ftkp0iriEvcGtk9SF0xPm2DI6wnFysHWNfZNBNrmAIPOs2h2UueB+fwlMF+xQUd+vC2FEpUN+kxBZiHQtWZVpoKJdlU29yw0JTM5wILm8yo0/8+IEYK8FX3VuDaSwfF0L2o/pongKT32VxTNaauoTsPKeA255wcwoRRjJVGqSzleScL5qOLoowmzUZBLaV2GoqNk+RVz34eYaXiePeMpgoUvlqIlXoD7PejwVisaFgVlErgSnaeMhjaL1QyVSYs/goNem5sx1xBLRaLWuE2mduMXS2M0GcPa0hxjcJ4r15Gu/dkOoPhuFgRParyoqZMAnSTSJ1G8OEtkjQP2nP/CrOYaGyuStxwz6mGZ2+LPa36RThvTPXrmOnar7DYWIvkqMJ63c+j48Lhe7j8ubN8mi8h4i8rg+oEuIwU4Jc2ebaCaaoIzaF4Dv5AhRGHOEwYXXrZwVOU1tV2D/pGLLi6Hnx51b+AhKo7n43CNP0vNCNmWsAyhe8LZRT1soryponixobtPUaaQpHBS6cclas=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 20 Jan 2026, Jeff Layton wrote:
> On Tue, 2026-01-20 at 11:31 +0100, Christian Brauner wrote:
> > On Tue, Jan 20, 2026 at 08:41:50PM +1100, NeilBrown wrote:
> > > On Tue, 20 Jan 2026, Christian Brauner wrote:
> > > > On Tue, Jan 20, 2026 at 07:45:35AM +1100, NeilBrown wrote:
> > > > > On Mon, 19 Jan 2026, Christian Brauner wrote:
> > > > > > On Mon, Jan 19, 2026 at 06:22:42PM +1100, NeilBrown wrote:
> > > > > > > On Mon, 19 Jan 2026, Christoph Hellwig wrote:
> > > > > > > > On Mon, Jan 19, 2026 at 10:23:13AM +1100, NeilBrown wrote:
> > > > > > > > > > This was Chuck's suggested name. His point was that STABL=
E means that
> > > > > > > > > > the FH's don't change during the lifetime of the file.
> > > > > > > > > >=20
> > > > > > > > > > I don't much care about the flag name, so if everyone lik=
es PERSISTENT
> > > > > > > > > > better I'll roll with that.
> > > > > > > > >=20
> > > > > > > > > I don't like PERSISTENT.
> > > > > > > > > I'd rather call a spade a spade.
> > > > > > > > >=20
> > > > > > > > >   EXPORT_OP_SUPPORTS_NFS_EXPORT
> > > > > > > > > or
> > > > > > > > >   EXPORT_OP_NOT_NFS_COMPATIBLE
> > > > > > > > >=20
> > > > > > > > > The issue here is NFS export and indirection doesn't bring =
any benefits.
> > > > > > > >=20
> > > > > > > > No, it absolutely is not.  And the whole concept of calling s=
omething
> > > > > > > > after the initial or main use is a recipe for a mess.
> > > > > > >=20
> > > > > > > We are calling it for it's only use.  If there was ever another=
 use, we
> > > > > > > could change the name if that made sense.  It is not a public n=
ame, it
> > > > > > > is easy to change.
> > > > > > >=20
> > > > > > > >=20
> > > > > > > > Pick a name that conveys what the flag is about, and document=
 those
> > > > > > > > semantics well.  This flag is about the fact that for a given=
 file,
> > > > > > > > as long as that file exists in the file system the handle is =
stable.
> > > > > > > > Both stable and persistent are suitable for that, nfs is ever=
ything
> > > > > > > > but.
> > > > > > >=20
> > > > > > > My understanding is that kernfs would not get the flag.
> > > > > > > kernfs filehandles do not change as long as the file exist.
> > > > > > > But this is not sufficient for the files to be usefully exporte=
d.
> > > > > > >=20
> > > > > > > I suspect kernfs does re-use filehandles relatively soon after =
the
> > > > > > > file/object has been destroyed.  Maybe that is the real problem=
 here:
> > > > > > > filehandle reuse, not filehandle stability.
> > > > > > >=20
> > > > > > > Jeff: could you please give details (and preserve them in futur=
e cover
> > > > > > > letters) of which filesystems are known to have problems and wh=
at
> > > > > > > exactly those problems are?
> > > > > > >=20
> > > > > > > >=20
> > > > > > > > Remember nfs also support volatile file handles, and other ap=
plications
> > > > > > > > might rely on this (I know of quite a few user space applicat=
ions that
> > > > > > > > do, but they are kinda hardwired to xfs anyway).
> > > > > > >=20
> > > > > > > The NFS protocol supports volatile file handles.  knfsd does no=
t.
> > > > > > > So maybe
> > > > > > >   EXPORT_OP_NOT_NFSD_COMPATIBLE
> > > > > > > might be better.  or EXPORT_OP_NOT_LINUX_NFSD_COMPATIBLE.
> > > > > > > (I prefer opt-out rather than opt-in because nfsd export was the
> > > > > > > original purpose of export_operations, but it isn't something
> > > > > > > I would fight for)
> > > > > >=20
> > > > > > I prefer one of the variants you proposed here but I don't partic=
ularly
> > > > > > care. It's not a hill worth dying on. So if Christoph insists on =
the
> > > > > > other name then I say let's just go with it.
> > > > > >=20
> > > > >=20
> > > > > This sounds like you are recommending that we give in to bullying.
> > > > > I would rather the decision be made based on the facts of the case,=
 not
> > > > > the opinions that are stated most bluntly.
> > > > >=20
> > > > > I actually think that what Christoph wants is actually quite differ=
ent
> > > > > from what Jeff wants, and maybe two flags are needed.  But I don't =
yet
> > > > > have a clear understanding of what Christoph wants, so I cannot be =
sure.
> > > >=20
> > > > I've tried to indirectly ask whether you would be willing to compromi=
se
> > > > here or whether you want to insist on your alternative name. Apparent=
ly
> > > > that didn't come through.
> > >=20
> > > This would be the "not a hill worthy dying on" part of your statement.
> > > I think I see that implication now.
> > > But no, I don't think compromise is relevant.  I think the problem
> > > statement as originally given by Jeff is misleading, and people have
> > > been misled to an incorrect name.
> > >=20
> > > >=20
> > > > I'm unclear what your goal is in suggesting that I recommend "we" give
> > > > into bullying. All it achieved was to further derail this thread.
> > > >=20
> > >=20
> > > The "We" is the same as the "us" in "let's just go with it".
> > >=20
> > >=20
> > > > I also think it's not very helpful at v6 of the discussion to start
> > > > figuring out what the actual key rift between Jeff's and Christoph's
> > > > position is. If you've figured it out and gotten an agreement and this
> > > > is already in, send a follow-up series.
> > >=20
> > > v6?  v2 was posted today.  But maybe you are referring the some other
> > > precursors.
> > >=20
> > > The introductory statement in v2 is
> > >=20
> > >    This patchset adds a flag that indicates whether the filesystem supp=
orts
> > >    stable filehandles (i.e. that they don't change over the life of the
> > >    file). It then makes any filesystem that doesn't set that flag
> > >    ineligible for nfsd export.
> > >=20
> > > Nobody else questioned the validity of that.  I do.
> > > No evidence was given that there are *any* filesystems that don't
> > > support stable filehandles.  The only filesystem mentioned is cgroups
> > > and it DOES provide stable filehandles.
> >=20
>=20
> Across reboot? Not really.

Across reboot all the files are deleted and then new ones are created.
So there is nothing that needs to be stable.

>=20
> It's quite possible that we may end up with the same "id" numbers in
> cgroupfs on a new incarnation of the filesystem after a reboot. The
> files in there are not the same ones as the ones before, but their
> filehandles may match because kernfs doesn't factor in an i_generation
> number.

That is is about filehandle re-use, not about filehandle stability.

>=20
> Could we fix it by adding a random i_generation value or something?
> Possibly, but there really isn't a good use-case that I can see for
> allowing cgroupfs to be exported via nfsd. Best to disallow it until
> someone comes up with one.

100% agree.

>=20
> > Oh yes we did. And this is a merry-go-round.
> >=20
> > It is very much fine for a filesystems to support file handles without
> > wanting to support exporting via NFS. That is especially true for
> > in-kernel pseudo filesystems.
> >=20
> > As I've said before multiple times I want a way to allow filesystems
> > such as pidfs and nsfs to use file handles without supporting export.
> > Whatever that fscking flag is called at this point I fundamentally don't
> > care. And we are reliving the same arguments over and over.
> >=20
> > I will _hard NAK_ anything that starts mandating that export of
> > filesystems must be allowed simply because their file handles fit export
> > criteria. I do not care whether pidfs or nsfs file handles fit the bill.
> > They will not be exported.
>=20
> I don't really care what we call the flag. I do care a little about
> what its semantics are, but the effect should be to ensure that fs
> maintainers make a conscious decision about whether nfsd export should
> be allowed on the filesystem.=C2=A0

Why do you need a conscious decision so much that you want to try to
force it.
Of course we want conscious decisions and hope they are always made, but
trying to manipulate people to doing things often fails.  How sure are
you that fs developers won't just copy-paste some other implementation
and not think about the implications of the flag?

What is the down side?  What is the harm from allowing export (should the
admin attempt it)?
If there were serious security concerns - then sure, make it harder to
do the dangerous thing.
But if it is just "it doesn't make sense", then there is no harm in
letting people get away with not reading the documentation, and fixing
things later as complaints arrive.  That is generally how the process
works.

But if you really really want to set this new flag on almost every
export_operations, can I ask that you please set it on EVERY export
operations, then allow maintainers to remove it as they see fit.
I think that approach would be much easier to review.

With your current series it is non-trivial to determine which
export_operations you have chosen not to set the flag on.  If you had
one patch that set it everywhere, then individual patches to remove it,
that would be a lot easier to review.

Thanks,
NeilBrown


>=20
> At this point, maybe we should just go with Neil's=20
> EXPORT_OP_SUPPORTS_NFS_EXPORT or something. It's much more arbitrary,
> than trying to base this on criteria about filehandle stability, but it
> would give us the effect we want.
>=20
> --=20
> Jeff Layton <jlayton@kernel.org>
>=20


