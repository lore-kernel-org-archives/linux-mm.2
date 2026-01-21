Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6374C44503
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 10:34:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D478C6B0005; Wed, 21 Jan 2026 05:34:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF4D86B0088; Wed, 21 Jan 2026 05:34:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B956C6B0089; Wed, 21 Jan 2026 05:34:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A6FBF6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:34:35 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 06A238CB03
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 10:34:35 +0000 (UTC)
X-FDA: 84355612110.06.E8B3AE5
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf14.hostedemail.com (Postfix) with ESMTP id DE4B5100004
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 10:34:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b=kv5lmdgw;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="o 4LwLi0";
	spf=pass (imf14.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768991673;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K9j3jhKpFIpiUQJzHWR2x3eEHOIQSB6ye1vrprKdmzg=;
	b=zEOXLij2VimdrvRsKNintO0emwGc8+/TUozJUHIHMtM+YB8U5W2jeMvvZOHgydNnBpkhnb
	DLcx3mwVrdVVoCyXFOckBv9o5lG+rXQRwWE1GieM1/b1JCEUSDABP/Uq32cRFsAvw7b5jx
	sGpHIpxPo4qJbCGmbXL1U/D1JylEzKc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b=kv5lmdgw;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="o 4LwLi0";
	spf=pass (imf14.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768991673; a=rsa-sha256;
	cv=none;
	b=lDHq+NDCsRC5FTw6m0//0YImRE755RJ+ocdKu+PpiSptAaxjgxHFl+vH+O2nD9VD3mx3wx
	Vfsvn5OX0IY4gyvPxe9vOzDAlYp19IrEZhX8b8VXDhcrV49OHowQL0bALd0az3NUv0Vpmo
	yCRuelPSTP0z8djWTgg72cZKDqs8oS8=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailflow.stl.internal (Postfix) with ESMTP id 14B671300419;
	Wed, 21 Jan 2026 05:34:30 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Wed, 21 Jan 2026 05:34:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1768991669; x=1768998869; bh=K9j3jhKpFIpiUQJzHWR2x3eEHOIQSB6ye1v
	rprKdmzg=; b=kv5lmdgwptpNtolMex40wHyYDtu1zR3kROgUgHa9dV4DF424TII
	xz8dxcyqZv5vn+C5E7je63p/kUX6FA6DJv49ZG4TEvmE9CmQROcNdltD80UCq70F
	67OKAnNM8oyAk8/zKVARKWIUXc/0rwj0A3HsU66MhxNwBVK6BifqALpBS3KNgyjp
	P0XbAYs6phH+mnFqRoXC1mh9pnuNQ+fFEwhXXc1sSnndee26t3rwwjTbJtTESJ9H
	fxgBNTVTQMWx/Tnp/sidQDM5zxfwLw4V6i5O5idHrafun9SF76YRjqhEkQ+5kNcK
	HcmbYYUHLFntzBcrv0lywLVtTimlIcl+nQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768991669; x=
	1768998869; bh=K9j3jhKpFIpiUQJzHWR2x3eEHOIQSB6ye1vrprKdmzg=; b=o
	4LwLi0FQ1jEf8fskqm7+L10I5i+E4UcJvDl06S22E2N6MVzowyCMRqm/bH1M2J1a
	JDwioi/R98Kd4aywyn9uZLSOM7z8MArbO4E7czObG95qdFlOtvQuQeCk3G1ZaKic
	Tehtuqj1UGP3Eb7Ucl15f9362hASG+CEClGzitcQtKQLQ9R6sDLQi76cFZsvhiXR
	ga+keMqdKP1sZXq4AW8N7RVWcf1Wq1jiHpO0YXPueFkCr92lRvi0sx0LsAgnwX8p
	AKZCnY9vD6dcgSVBcblBk6RRY3JRRT1CNgtvJrCkNeFsfbLaIXO8m2mpKZ7xfZXV
	VHjPUcyIoRUMrrAPKWG+w==
X-ME-Sender: <xms:sqtwaejzMMYRFV89Y0xjhbUY2Ux7NPR7lm9XvAv8w1i7kASo3nK0Zw>
    <xme:sqtwacbJbsKb0ZWVMi2Ld61rpE_gwOTUmZUOuIFkObP6qtSchisKdfJNZxw0XqFd2
    dpJMMfqKKl9ncf8qF50uKZThAPLp5_pMzEv9z25paWGdt3g-rQ>
X-ME-Received: <xmr:sqtwabSH-RRobwNx5gak-6jfqjdFsk_YBqmqf4AohoRb2sCX2uoyp4QOYu7NMlajZX_Q1etTmNQaSqmVM8w660ms4W7YiwL8iGuB03vkYszh>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeeftdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurheptgfgggfhvfevufgjfhffkfhrsehtjeertddttdejnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epudetfefhudevhedvfeeufedvffekveekgfdtfefggfekheejgefhteeihffggfelnecu
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
X-ME-Proxy: <xmx:sqtwaUqa76K57jmkll9tnYEPNFtkwAFRAIOxkmOCTcJg3wPstOKebw>
    <xmx:sqtwafqX8Nkd7EHiHXFk0lbznDX828ETkTyNFowHaBS8I4Kgjb_iRQ>
    <xmx:sqtwaRGfSRcbTn7ju_6NXus6mwh9CX54E07yQqtkZf6nvJqjRrtQ3A>
    <xmx:sqtwaZtU8f1xqg3JxB6L05BW89l7H_7-dfzynjFDw6dcCKuLsBgwHQ>
    <xmx:tatwaYpYIXr04Y4VvYfBrbHTBHEkDGuPdYscX8VKwQ1WEKpEcFWHhm0u>
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jan 2026 05:34:08 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Christoph Hellwig" <hch@infradead.org>
Cc: "Christoph Hellwig" <hch@infradead.org>,
 "Christian Brauner" <brauner@kernel.org>,
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
In-reply-to: <aXCg-MqXH0E6IuwS@infradead.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>,
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>,
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>,
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>,
 <aW3SAKIr_QsnEE5Q@infradead.org>,
 <176880736225.16766.4203157325432990313@noble.neil.brown.name>,
 <20260119-kanufahren-meerjungfrau-775048806544@brauner>,
 <176885553525.16766.291581709413217562@noble.neil.brown.name>,
 <aW8w2SRyFnmA2uqk@infradead.org>,
 <176890126683.16766.5241619788613840985@noble.neil.brown.name>,
 <aXCg-MqXH0E6IuwS@infradead.org>
Date: Wed, 21 Jan 2026 21:34:04 +1100
Message-id: <176899164457.16766.16099772451425825775@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>
X-Rspam-User: 
X-Stat-Signature: 36tdjnhxhutd8xk7sz37qshyzpxye7aq
X-Rspamd-Queue-Id: DE4B5100004
X-Rspamd-Server: rspam05
X-HE-Tag: 1768991672-411163
X-HE-Meta: U2FsdGVkX1/dYwapJTg+MDfaITwpIoA/RynA+KvFYmLY+XMnqD8aZ6hZ2Waz4h67bvZ3guQckUBrDG3bJLTy/wRjBanQeAl0u/1d9a6PKB9YELr6Cw184qbafbztaa+4gz63AZ6hQMRmPjuHUYylpLheKbuG5FCcxPFolV/I2TjOHGM8WutLnUZ2YdxbdsawbEl4q8h09GUSZJNdcYviB+I5hq+ZneX+23trlw5kwkJnvrZSxRwBEyhVg7rDSeERLiMDD0MLyMk6VSgX4OTu0Bkh6SRErR0wrThsz6dMy3hHkFo2Ypf5gdDMznNzkbqsOI865jhDoqUif//qUI7DKS0REVarB+jMXWF1VhSD8LHADCtWVMepPHGuubz7JeGw4t8pxShHg/vQaU3j2HdMTAL+6LdGqyT0rXN73uIt5OEJJ6fsGtWzrzWNTT22OhuttjgkkdTRbgvuHnLnHkHzeZ+cNMPebPD3fFvxPgIEsFsgRhq2LDdVbt7FYGKCUq4sHeMN8V+LC2p3MSVnQsXcP0YNK7PvJrXiyBHGdOK20Ua+AfXwkSzJ9tuPghbKgFG7KDpw4aBtI+OrvFRV2r9meWDkps7iuR3rsPZBPCPyQxlzPfwuDMvoj1oQRtlssbOdzAXLlvPYLBwLsmWaf+k4JEeZ4p3v5ScrGR0L/isJHHsKNfd44LVfJprxipnQ1Cy3TrFvZ3n9I6H4mY3NeaSR7dr5CMMW8hCiMLmcBCgj0E1Akm3dorHW3t1DCjvm76fRaNRKaL8fSRYVFu3rOJsOYxw9ZPlzHPveH06X/J0bzFJTfaZlBvegqc3xqZtaZMnx0yCQvWOQvU0vXZW7doid7GTxMRdF3Ft0gY7X95wqDByT6YtOBgLizAAVg64iNLTx5mSo86pLSvZ8hbXF10l6pBpHy/EgGK6UpxvvyZHkt0PyXT1vqlJoZj1K6XRk6m3c60+XMYTGn8eO5j7nVSi
 nmEb1MQQ
 jE6Gy23y+myKPWJ5PjhQtOyf+TXpDV3fFdqDymGS1SMiZ1whtCTaEgB/V9M96SZ+WbBBo4qdJkBJkvTxAWFGVgF7QYU801rtM6UsOTNFGBRKQf1OthDJCHC5Ez+/qSb7WXevdLKlnE9cybfiEGlnu1KcolRkGmbBJDzUUmce6Z8bfYW9yVvWV+lxnEl35HYFp1OGOLFN8E+oZAwwd0N9mH7JqkcIszaa8Y86JediVzzutoh8HzrTthpuVGZ2ard1i20seMcnUn7zxr5Is0qK3GX/o7WmMwPxy/plKDqQUVKfVIvOy9apFu0pZd51iZiHMIp5ugIZWUhM6VoyAJcZQmNfHH3nFQYWgzJopNKstBPvzZrGpA77sT1jR0Q6cYi3IasVkoJWTSJJjBSKBCIYuZ3TlLuZ5S9od/4Eh2W5Mc0k78x39RGBDJw8ws3tUH7rlY526LignyO6cdbb/LnCQburiPNlFQ4pK4wrBmBk/4ivQLyfbLL+r/2yt63p7GKDvAfnjUVOuSRHaZG1pethtv8JPO4Fz5nfaKNguLGpIxuQ3rycCZOC2drTjfwBx4w17IzCnDazdoBFR2C7T6AKY5fxai8WJLBe/tRp0ZyNaDCloPXUcfKOdCzjIXnymrcYABhLEV8c9xKaR1N9TgpyVKJ8AIOjvFeLu2bhCfVBVX5ukIc5K4/Fv87D2Dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 21 Jan 2026, Christoph Hellwig wrote:
> On Tue, Jan 20, 2026 at 08:27:46PM +1100, NeilBrown wrote:
> > > If you think NFS actually explains the semantics pretty well, please
> > > explain that too, especially in forms that can be put into
> > > documentation, including for the user ABI.
> > 
> > There are multiple issues here:
> > 
> >  - filehandle stability.  As far as I know all filesystems provide
> >    stable filehandles when the "subtree_check" export option is not used.
> 
> That is news to me, but certainly interesting.  Does this include not
> reusing the file handle for a new incarnation of the same thing?

"stable" and "reuse" are quite distinct concepts in my mind.
"a new incarnation of the same thing" is in my experience a new thing.
  rmdir foo: mkdir foo
on an empty directory will create a new incarnation of the same thing.
But it will appear to be different in various ways.

Names, not file handles, are generally used for new incarnations of the
same thing (again - in my experience).

I cannot 100% guarantee that all fs's provide filehandle stability, but
I am not aware of any, and none have been presented in this discussion.

It is true that the NFSv4 spec claims to allow them but I find the
details provided insufficient.
They might be able to work reliably if the server provided a delegation, but
without it I don't think they can be used reliably.  I'm certainly not
aware of any attempt to support them in Linux client or server.
(I know Trond doesn't like "connectable" file handles).

> 
> >    Certainly cgroupfs does.  So having an EXPORT_OP_STABLE_HANDLES
> >    flag would mean it was set for every filesystem - unless there is
> >    something else I'm not aware of.  That is certainly possible and I
> >    hope someone will let me know if I'm missing something.
> 
> Well, if does not provide stable file handles with the subtree_check
> export option, or more importantly with the CONNECTABLE flag passed
> to encode_fh, which is the level we're operating on, it can't set the
> flag.
> 

Hmmm...  I didn't know that open_by_handle_at() supported CONNECTABLE
requests. That seems relatively recent.

If CONNECTABLE is requested, then only directories get stable
filehandles.
If CONNECTABLE is not requested, then all filehandles should be stable.



> >  - filehandle uniqueness.  This is somewhat important and if a
> >    filesystem doesn't provide it, that should be considered a bug.  In a
> >    different thread Christian has observed that there would be benefit
> >    if pidfs and nsfs provided uniqueness across reboots.  It is quite
> >    easy for a virtual filesystem to generate a 64 bit random number when
> >    the fs is initialised, and include that in file handles.  Having a
> >    EXPORT_OP_REUSES_HANDLES flag could mark filesystems that are still
> >    buggy if that is thought to be useful.
> 
> Yes.
> 
> >  - GETATTR always reporting file size of 0.  This is the only concrete
> >    symptom that Jeff has reported (that I have seen).  This  makes it
> >    impossible to read files over NFS even if they have content.
> >    Would EXPORT_OP_INACCURATE_SIZE be useful?
> 
> i_size = 0 for a regular file sounds like a genuine bug to me.  I'm
> actually surprised anything works with that.

Files in /proc are all size zero.
Files in /sys seem to be all 4096 (or maybe PAGE_SIZE).
Files in /sys/kernel/security are all size zero
Files in /sys/fs/cgroup are all zero

I agree it is weird, but it seems to work ...  though I do have a vague
memory of something not working because it used a library function to
read a file, and it needed to be fixed.  No details come to mind except
that it was probably md related.

As some of these virtual files can be different every time they are
read, there is TOCTOU issue with trying to make the i_size accurately
reflect the result of a subsequent read.  I think the cost of setting an
accurate i_size even when it is possible is not seen as worth while.

> 
> >  - maintainer feature choice.  A maintainer may choose not to support
> >    export over NFS because they feel that there is no value and the
> >    possible support burden would not be worth it.
> 
> The maintainer has no way to disallow exporting through nfs.  They can
> at best disallow exporting using the kernel nfs daemon if we provide
> that facility.  But as I've argued multiple times, making arbitrary,
> selective and very narrow choices about use cases without technical
> backing for them (which then would be expressable as a flag like those
> listed by you above) is really bad software development practice, and
> not something that we usually do in the Linux kernel.

True: once you make files available to people you cannot control what
people will do with them.
So maybe you are saying "what is so special about knfsd that it gets
information that no-one else can get".  I cannot argue against that.

> 
> >    There may be locking
> >    / lease / etc issues that further complicate things.  So it might be
> >    reasonable for a maintainer to choose to forbid NFS export while
> >    allowing local fhandle access. EXPORT_OP_NO_NFS_EXPORT.
> 
> We already have a EXPORT_OP_NOLOCKS flag to deal with this.
> 
> > 
> > It took me a while to sift through the code/patches/comments and come to
> > this understanding and I apologise if I wasn't as clear earlier.  But
> > my intuition was always that file handle stability was never the real
> > issue, and maintainer choice was.  Hence my rejection of the
> > "STABLE_HANDLES" name.
> 
> Why do you keep ignoring the fat that the stable handles are really
> important for anyone wanting to actually use them for their original
> storage purpose, be that for knfsd, a userland nfs damon, or other
> storage applications in userspace despite explaining this countless
> times?
> 

It isn't that I don't think they are important.  It is that I think they
are universally provided (when not connectable).
If we add an EXPORT_OP_STABLE_FILEHANDLES flag, I believe we would need to
set it on every export_operations structure.  So what would be the
point?

Thanks,
NeilBrown

