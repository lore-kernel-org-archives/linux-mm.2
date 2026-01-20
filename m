Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB0A9D2ED0F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 09:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 014216B039F; Tue, 20 Jan 2026 04:42:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2D8A6B03A0; Tue, 20 Jan 2026 04:42:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E056E6B03A1; Tue, 20 Jan 2026 04:42:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE0126B039F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 04:42:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5439E8B924
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:42:18 +0000 (UTC)
X-FDA: 84351851556.09.A4D12E9
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3B337140002
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:42:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b=QBLgYxDP;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="I lJarEx";
	spf=pass (imf26.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768902136;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LV/m+2BySRP4UTa8KO6B5ANmTiLCS01qCPx3K33a4E=;
	b=ltiu7r9wuZSOIVnD38bBDXx28+PyRoYqbPwQi4h0J4T1P/Dxs3YrLrJNWzOcFKWP5ueS31
	EsTBNr4FvlVTzGN1VfxAQ7EA2lfzKsgJdh2cWraB850aLHGUGZCDuIfwXJHwkknR9G7lec
	HBMzQEgdJdEVB4u2bMdPbfb9dh47bzI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b=QBLgYxDP;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="I lJarEx";
	spf=pass (imf26.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768902136; a=rsa-sha256;
	cv=none;
	b=CPdp1UHM9rYBgssqEX7RcUeFxA7DGFYC/9TqZi3qzkhkRHpRoT26/D+0tQ1Ks0glRY6nyf
	KHoJTwkKjk+/8u1P2iRRd+LCya3Cuhxz2c0wvn6yGnHtFjPAZn0tbyEzegWKBiBepuMr0P
	6UlWebEJIp2ihmkafh2A0vK+jgTriVo=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id 69A65130083C;
	Tue, 20 Jan 2026 04:42:13 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 20 Jan 2026 04:42:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1768902133; x=1768909333; bh=8LV/m+2BySRP4UTa8KO6B5ANmTiLCS01qCP
	x3K33a4E=; b=QBLgYxDPwqb8F/HKOO4s4mzyuJJ5MMUd1laQIcZ9FLfjSQIHZc+
	1PekC9F5KiYouciRAURW5scRiZfUfVf+lHhWler9vaCX34KwsDgrcH+K5GMcSPhm
	01zfr2TzcAnR+XzN7ZoF4Ce1ogYn2127mD1CbQtGo5JcXSrLM5DudreAqJPMM+d1
	pEZdVLpH1i/ogNehoKQHjAQzn/eGcaPjc942Em7vOAIEwadjFSKz28MGc0I4d8PJ
	d+9coMB/qwxJWZ/EAe0Ypz4WGmhqrnEngeKyp+9XDQoyLvIZ2mymsJ4bkGZ81TV2
	9WZ0ZuIw8lEEQvuro+dbp9T/f1kCrvifu9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768902133; x=
	1768909333; bh=8LV/m+2BySRP4UTa8KO6B5ANmTiLCS01qCPx3K33a4E=; b=I
	lJarExedh8uzTTah/bHx79/YyztFkui/cYw/IFWC48OO9ny2YOytT0/PMAHPrEDb
	AyA1750snwOOTIfNl1On1EDKsnlM6Q77auuvSlGsq3AxJq08dwSFRCRJ1TyTja2v
	+tCSqzwbvZw7q2vVw6dZHjcUAN1pOOX3Zdb9iGaOEaZKjE7VYix7rALrimtuXK4G
	S1EmLbVnF9+emGzsZoKwIU1ZYEvNciORd/LEYYeVM2jaUNvrhdFzl3xvTnxrXXO8
	gSL7ILssNaIMxQAvCboeFOkje0ZJkqebBwPR89zdsWbkDmGoBagFfPVqH96/r7xd
	UUf6p6EbYyj35tCGpABfw==
X-ME-Sender: <xms:801vaS1HQqJTkLN0qOfNxDYR4QEeodh9pOzlm5q1a7-te1bwVk57KQ>
    <xme:801vaY92pFHUjDCZ7ioN3ccEM76jeUEkRPxfdpf9xsPE7OOAmasiRMHpY3FbvAzGy
    Ib4JB5h0uHGt7LJIgiS1xo9p7Tuy3xjN92zLOGtkOHkCRc-bw>
X-ME-Received: <xmr:801vaYkPNCbWybQZ_Z8VogKxTEtLNy5ht-LA6lJgxbV_7j9EyJUyIE6sAp6pW0R92ATQU3P6FFEfKSEQt9nWaYMYiqesHSX-YaV04pjX969V>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugedttdejucetufdoteggodetrf
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
X-ME-Proxy: <xmx:801vac0dgfcvMTCBXINaH24yiyKEFUIE1Ls5XDW5vogt4-eXS0CHcA>
    <xmx:801vaegrkt6HTpXA0iTS6Ch9yRl9FxpkN1c8EoOi51B2W-NRG0Cc9w>
    <xmx:801vaSZ2kk4EgEdqpha3AierzEi87LlnWdGD9QbopkHA9JEx5vqJWw>
    <xmx:801vaRWFkRpjMuQy6ymBG7IFYgOaPEcaBxpo8w9DagSZ9_XbM_Rmug>
    <xmx:9U1vaQUrUz_-VltF1IDMQy_Zdp8PR5Bulioc2EaRPWdDYTmHji8Q8eiD>
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Jan 2026 04:41:53 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Christoph Hellwig" <hch@infradead.org>,
 "Jeff Layton" <jlayton@kernel.org>,
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
In-reply-to: <20260120-entmilitarisieren-wanken-afd04b910897@brauner>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>,
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>,
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>,
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>,
 <aW3SAKIr_QsnEE5Q@infradead.org>,
 <176880736225.16766.4203157325432990313@noble.neil.brown.name>,
 <20260119-kanufahren-meerjungfrau-775048806544@brauner>,
 <176885553525.16766.291581709413217562@noble.neil.brown.name>,
 <20260120-entmilitarisieren-wanken-afd04b910897@brauner>
Date: Tue, 20 Jan 2026 20:41:50 +1100
Message-id: <176890211061.16766.16354247063052030403@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>
X-Rspam-User: 
X-Stat-Signature: giuag5ms5texn3ynion7szfxa9w7fwss
X-Rspamd-Queue-Id: 3B337140002
X-Rspamd-Server: rspam04
X-HE-Tag: 1768902136-393747
X-HE-Meta: U2FsdGVkX198e8aIzstyCk9ISh6/bT9Ba6eJKHFDuY4icgZxgkPRDBeeo6Z6stWd9TRocGIkF+zh7IeGkLspqypaDGIY+OY5xmO8y+fNUMC9nfPOR4ofDI0rHAoTvRiFzuu3SbPvE9IHSCh+RRNcKFjDS8fTvZDmyIwW9S6f+NsMWkiOZC7KvnH7H0VPzSrVVjA5Ggy1VWeeY+PqjNeWsd8f95Tf+2GDBX3je1NHq77cvbzjNIVNUT6VF2N52zZJjrqJb1RRab6VMcJl9hyfUxj1mmfUmLzqby/6lSexx2v/CvrlZqBXxqLV/I7xMPcRjfNiYwGzedRuKAArEg2SOiOIf3IcqeBqSRirTDQsEvEz5QF4xDL2cOqgLG8K1d/bYvInDX87EhCdMgA/ovji82IVXOVHXo+9TapiP4/bB2wWaPdbv9xSPr5x7ZzrTxNcymPIMlUPaZ7VU337JoaQ5SBkegO4auxBLPKEiyOmYvhfMoeSZBwGZRw6HJFZvCTB3V4zQU7oLYNh6jFax2t8l9O/rpDr4zlG8sgnGS0R183WlDKmGsoYJx1laEFQ7jUF6bvpLErbOLWyD92EQ5ur7NToGw6zQhR9oa9GGah3NaF1AT9XdvifdO5la9Z+d7+F87NWD+MPk4WRNfsDO8vw7HNhg3YyQyW1MN0j7C6OT17hIINx31LvqCZbNwXOohZ5i8n8Q55o8Wu7w0ExFmEU9fV691XDNzYuKRxeLiZ+MaRAJkiDbD7hZv8wFzdPucVDPxRvJJV19MMG3Crm6dbXo/LwB0RGcNhWeQQ5YXutqyOVlx3dfdNDPA1l4rhjS7qbGO5asHpuSUsZRMMCip+YHC/MIenSkTS7n9rD2sYWlMV3lSDlwvwc85+m9LzPhYZXX+9OEzT2kc5V/As1FIlBvKCizIpvIJKVaTizaTQhuXK5NAezodE6i6yFm9uMTPcrBUYpTmyA5b+b4oEwWhv
 /W7GAIpS
 Hof3MuEzJAs/NOp8NRbyX815rA2SlxcYFH1qNhP4FVldqplu1lxk0Wm4DHLLEQkVrG1qbs3KkF/mHM7TNk9E8QPMhyinKelJ/klh1DlyivLGcCzIlBnPKfHKn1ET/5YU4Vkz1v/WNvXUM74zgaQ2PqvYDTymk1C13VgpPxqnoTse/PgOItaDMw3lxQn7ibW2rYeYTmY7oLUFcSglfD25r3wgBk2Ffwav83tHrV+IDBPNJu9Q3+vFUHI8ZkNDGUudd0IbAVslSKz5uBmQHYFQHE92oYGEWt+r6FS3aMYbNtRDXuwaME21lvOEjaL1CcvFGy6QXNc4lQsPFgqANVDrow+GwbRklFm5/ehw7gB/4AHqTFBSlZP3Ft1O07uXfv2gNrtz8wY28hgk/vZD5vX4Ki732sWOqc8anGw357BBByJoRhubI68OMT22KNEL3Dwf/qPMjWghxC9xG10XNbXruvRs3SHAjBy5DCnWkAZxUDseKP5E8QEnn9qlgFIt5oKAYa++GtF5FVZOGC1Z7scyHo6mBU0cVCgXYuwMJDj45TqBvoUuG1dZ034LUj0ittQWGOUvskUEQFqCx5yjEyiw/5d4J1uh5trMFMqqnmO8crODDV5UzckNxXAp7LhVw8tIZMAo4FQ8FtizyYn1BwxcLfhQarg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 20 Jan 2026, Christian Brauner wrote:
> On Tue, Jan 20, 2026 at 07:45:35AM +1100, NeilBrown wrote:
> > On Mon, 19 Jan 2026, Christian Brauner wrote:
> > > On Mon, Jan 19, 2026 at 06:22:42PM +1100, NeilBrown wrote:
> > > > On Mon, 19 Jan 2026, Christoph Hellwig wrote:
> > > > > On Mon, Jan 19, 2026 at 10:23:13AM +1100, NeilBrown wrote:
> > > > > > > This was Chuck's suggested name. His point was that STABLE mean=
s that
> > > > > > > the FH's don't change during the lifetime of the file.
> > > > > > >=20
> > > > > > > I don't much care about the flag name, so if everyone likes PER=
SISTENT
> > > > > > > better I'll roll with that.
> > > > > >=20
> > > > > > I don't like PERSISTENT.
> > > > > > I'd rather call a spade a spade.
> > > > > >=20
> > > > > >   EXPORT_OP_SUPPORTS_NFS_EXPORT
> > > > > > or
> > > > > >   EXPORT_OP_NOT_NFS_COMPATIBLE
> > > > > >=20
> > > > > > The issue here is NFS export and indirection doesn't bring any be=
nefits.
> > > > >=20
> > > > > No, it absolutely is not.  And the whole concept of calling somethi=
ng
> > > > > after the initial or main use is a recipe for a mess.
> > > >=20
> > > > We are calling it for it's only use.  If there was ever another use, =
we
> > > > could change the name if that made sense.  It is not a public name, it
> > > > is easy to change.
> > > >=20
> > > > >=20
> > > > > Pick a name that conveys what the flag is about, and document those
> > > > > semantics well.  This flag is about the fact that for a given file,
> > > > > as long as that file exists in the file system the handle is stable.
> > > > > Both stable and persistent are suitable for that, nfs is everything
> > > > > but.
> > > >=20
> > > > My understanding is that kernfs would not get the flag.
> > > > kernfs filehandles do not change as long as the file exist.
> > > > But this is not sufficient for the files to be usefully exported.
> > > >=20
> > > > I suspect kernfs does re-use filehandles relatively soon after the
> > > > file/object has been destroyed.  Maybe that is the real problem here:
> > > > filehandle reuse, not filehandle stability.
> > > >=20
> > > > Jeff: could you please give details (and preserve them in future cover
> > > > letters) of which filesystems are known to have problems and what
> > > > exactly those problems are?
> > > >=20
> > > > >=20
> > > > > Remember nfs also support volatile file handles, and other applicat=
ions
> > > > > might rely on this (I know of quite a few user space applications t=
hat
> > > > > do, but they are kinda hardwired to xfs anyway).
> > > >=20
> > > > The NFS protocol supports volatile file handles.  knfsd does not.
> > > > So maybe
> > > >   EXPORT_OP_NOT_NFSD_COMPATIBLE
> > > > might be better.  or EXPORT_OP_NOT_LINUX_NFSD_COMPATIBLE.
> > > > (I prefer opt-out rather than opt-in because nfsd export was the
> > > > original purpose of export_operations, but it isn't something
> > > > I would fight for)
> > >=20
> > > I prefer one of the variants you proposed here but I don't particularly
> > > care. It's not a hill worth dying on. So if Christoph insists on the
> > > other name then I say let's just go with it.
> > >=20
> >=20
> > This sounds like you are recommending that we give in to bullying.
> > I would rather the decision be made based on the facts of the case, not
> > the opinions that are stated most bluntly.
> >=20
> > I actually think that what Christoph wants is actually quite different
> > from what Jeff wants, and maybe two flags are needed.  But I don't yet
> > have a clear understanding of what Christoph wants, so I cannot be sure.
>=20
> I've tried to indirectly ask whether you would be willing to compromise
> here or whether you want to insist on your alternative name. Apparently
> that didn't come through.

This would be the "not a hill worthy dying on" part of your statement.
I think I see that implication now.
But no, I don't think compromise is relevant.  I think the problem
statement as originally given by Jeff is misleading, and people have
been misled to an incorrect name.

>=20
> I'm unclear what your goal is in suggesting that I recommend "we" give
> into bullying. All it achieved was to further derail this thread.
>=20

The "We" is the same as the "us" in "let's just go with it".


> I also think it's not very helpful at v6 of the discussion to start
> figuring out what the actual key rift between Jeff's and Christoph's
> position is. If you've figured it out and gotten an agreement and this
> is already in, send a follow-up series.

v6?  v2 was posted today.  But maybe you are referring the some other
precursors.

The introductory statement in v2 is

   This patchset adds a flag that indicates whether the filesystem supports
   stable filehandles (i.e. that they don't change over the life of the
   file). It then makes any filesystem that doesn't set that flag
   ineligible for nfsd export.

Nobody else questioned the validity of that.  I do.
No evidence was given that there are *any* filesystems that don't
support stable filehandles.  The only filesystem mentioned is cgroups
and it DOES provide stable filehandles.

NeilBrown

