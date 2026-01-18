Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E674C9830C
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 23:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73BD56B00DA; Sun, 18 Jan 2026 18:23:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713456B00DB; Sun, 18 Jan 2026 18:23:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 612926B00DC; Sun, 18 Jan 2026 18:23:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 504E56B00DA
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:23:40 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD1EFBA2E3
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 23:23:39 +0000 (UTC)
X-FDA: 84346663758.05.F190203
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	by imf17.hostedemail.com (Postfix) with ESMTP id B439B4000B
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 23:23:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b=Dmw+pxT+;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="I GTmerX";
	spf=pass (imf17.hostedemail.com: domain of neilb@ownmail.net designates 103.168.172.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768778617;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLWfoPH86LevLJ5dEarcfR/PsriG4IfSU/3wyLJz+qM=;
	b=FEVumVfo4oy+Pet0nACgIDd1csv6LnIOQh58QHxktF6lTnNGVGNbDcHaXH1l2MRBq7EoLy
	shpz+CqerEiDtnKBJVjXyolRxGBDK7iaHZYxMV5tofH3sM2iTiAGmb03AHv/u4/ab5+s9B
	hT+Z0+jxyOsJQuV5G62WXztws8mPyHU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768778617; a=rsa-sha256;
	cv=none;
	b=EvRz0ek+WsxtxhFgt0LBs3sPTB5uZdSX20BWVRuyPigO0WkU/ZxR0C/5dVaXmkdc8HzAwm
	AyUcn5YH+IsLyaAaFuiMIb2lD1F5e+aOopOY2vlBUVv+3nroZtluNonHGLYRb5zFUeg2j/
	kvooJqLbb532/ngMPKEVddj5dO369Wo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b=Dmw+pxT+;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="I GTmerX";
	spf=pass (imf17.hostedemail.com: domain of neilb@ownmail.net designates 103.168.172.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.phl.internal (Postfix) with ESMTP id 044C21380091;
	Sun, 18 Jan 2026 18:23:37 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Sun, 18 Jan 2026 18:23:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1768778616; x=1768785816; bh=cLWfoPH86LevLJ5dEarcfR/PsriG4IfSU/3
	wyLJz+qM=; b=Dmw+pxT+mC6s44HDc9ViDXhGQeEmMpmNYRhtbA86QNG09PG/Ljt
	hV85ad3/pbmWWoao3arxAaxDpjTC5inzso+nDbFp9L/ocC8FvAlBD0K6BSqaNtKf
	C3km6dpzlK9Qvfbi4RlAOZVQRcgXUx6BbC4NNZXExiSaEBKuKkrscbvke30TKEj0
	X3c26YUO2IvjIKJetsMrJSw+w98guonRsqk3c5wy7tRYCBiBKWCThYgKRu77I56g
	W/jQbAZlq9qtSmpdQFd+C0/rLGEaY2+/6NIHoLbGsxK4GkDCFlahWHWTEoSSJrS/
	k5ZW9JDwUgtzyYMplQwMaStWlBzRHOxECQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768778616; x=
	1768785816; bh=cLWfoPH86LevLJ5dEarcfR/PsriG4IfSU/3wyLJz+qM=; b=I
	GTmerXNj37QbHVnwq2oYiiWRj3dNMRiwAfGv/vxfYmuPEFFfJjUyW8ruiPn+ZUTw
	y96Ysjc5jkE+PfgCaUfHrNzF77vJ+CHZGj8ZZyFQniCqqNBHAWqccBt7S/bU1BV3
	Xnstc4VvhfH6RZxhRpoHiUxWSmJT21A47932/vgOnE5bxUOTfBJmpqxFnE86OITm
	uIg7MLSy3DGOcBFTzEd5fbzcCQYBFRkQDDO9qGFEXh5IfaJ//ctGtwtYx+/A3prw
	KJ8U8PGheh+G3smkjCFKvnDL2ddcVu2iicAyBab5Q6myVEkn0CxZuzyjCejBBwJF
	S/bm6s4tkRpP23BkNvcHg==
X-ME-Sender: <xms:dGttaT6YTMF6Fa6OlzcaAnM6fKqB4-4u0PRgZNSqPeyFmRns3uNnWw>
    <xme:dGttaZPm2B1Iaa5cFSjo7JQ9nDmVsbYtDSTRFdNHBicQ-lkECLbL66rkbZK2MZehf
    _rCs8HRq47ygqgxsOGTs2CMA0vWt7_AzG555MqfdnDHw6XZXQ>
X-ME-Received: <xmr:dGttaV5f0odFoTqo9Cm-3bXwUWdDQe8OS_nESoDmZC33EUUTmsf8jTlPE6SJiNhWOG4bTHrmA205RC8BAhr3cbUxrYEQhQL_108cgTPUPoLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddufeeitddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurheptgfgggfhvfevufgjfhffkfhrsehtqhertddttdejnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epvdeuteelkeejkeevteetvedtkeegleduieeftdeftefgtddtleejgfelgfevffeinecu
    ffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehnvghilhgssehofihnmhgrihhlrdhnvghtpdhnsggp
    rhgtphhtthhopeejfedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepvhhirhhose
    iivghnihhvrdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopehguhhotghhuhhnhhgr
    ihesvhhivhhordgtohhmpdhrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhunhhiohhnfhhssehvghgvrhdr
    khgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqnhhilhhfshesvhhgvghrrd
    hkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhnfhhssehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkh
    gvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghr
    rdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgvgihtgeesvhhgvghrrd
    hkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:dGttaek4FCMZRAxWF6ejfvNQASS42yuMJmNL6Qr_VSzT2alP2kiMEQ>
    <xmx:dGttacMnrF3MIVkqtagaBM_OFbr4viUT9Quj4YPA_rDrR6FZMQe15g>
    <xmx:dGttaRUgcJhZGcX_B2l09umj3yAF-qAbVHXccqpyubd6rn2m6D7nYA>
    <xmx:dGttaVutjkDk_cSqIw9p5HdrWWt8-J_WTU_-yJ8LgZsJLx3q9gD8ew>
    <xmx:eGttab3JlD-dDEAYvGFUDpoqKXPgn7EN1IPurNldS43-2K0UKJSizYjm>
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 18 Jan 2026 18:23:15 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Jeff Layton" <jlayton@kernel.org>
Cc: "Amir Goldstein" <amir73il@gmail.com>,
 "Christian Brauner" <brauner@kernel.org>,
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
 "Jaegeuk Kim" <jaegeuk@kernel.org>,
 "Christoph Hellwig" <hch@infradead.org>, linux-nfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-unionfs@vger.kernel.org, devel@lists.orangefs.org,
 ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev,
 linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-mtd@lists.infradead.org, gfs2@lists.linux.dev,
 linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
In-reply-to: <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>,
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>,
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>
Date: Mon, 19 Jan 2026 10:23:13 +1100
Message-id: <176877859306.16766.15009835437490907207@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B439B4000B
X-Rspam-User: 
X-Stat-Signature: 7skyojca4jeatksr9f35i7g56gyxtu8e
X-HE-Tag: 1768778617-769161
X-HE-Meta: U2FsdGVkX18fxRWA2k/yfK8DSnlIJ/1c6P7WPFBowSsHaDS8NqU3w9fuJOgjnh4RoWf5RHKKoFHwxaNHLc7ZHQncsdK9edDZKat/IysVZhQPftdJ4bNtujLCyCCvNmq3J/O+j2E6Svtd0Klyh4dOpvTFV81QlX+8ftjhzSCKs6X2FM6A+AW0pQna6USSbw6IMxki4nZGNuDf+2rfNTSFKY1vsitNcZWEdmvCI+zs9xeyOLFYBWnrU9VlJ63n67QqK+yXBOtfO6VUt5GbH1BpDlOoHyDf1x+U1f399ZKfN6uSdGWkaCqHnejJmK/jZV+tsEtZtKo6TvdA1uFZ3eUZBOGv6enFNBmWPPrUvuYt4H0a+V7BzVcdmzD7k7x8KUYBn+YrKoMaUpVjaSNEMFhj+34TaNNrjwupH0diLlZA/X73BJMcGJgvoHNRePc0Dt/esJpZ6tdZfCUvQ955F6Els6tIgzETz1HOKc4gdNOPq+sqYRMST8g7/Ik2ImJTEfhckP2BVFrEmcK/qYe14PQ1eGcIdA9yqZmmPuHpSMQx2xw8c7P8v5sikdzbRAFZplKo91kJbuloLuc3mE0oCSL3dJWEIC28dmBq0RmzlOMIVwOTAMyHg/btl+xeEy8jdUgbMEZA2Reklq/mijs4KoLkUoAsQgcRVTxG3E+9L1LcuR9/gWeXOn0zDISipHdJZIPc8VoclNkEis4iaUlKS0e8/B+l/StEF2TpjDAAOxvBoT6myT7RwJp03IyBfrOcwtqCUuCQNaiql2RYyLrlYWBYCHU6gdpTm9X4Ciz62Km2/LPX5Y26h8C0FhFnfgrZ8YGmjLZL0izn7NCRBHoBTgmr8cnIOLf3RcsEJyJVGacsB5kdOURta4JWNj9aP76ThSnP9fEJmUqeEEFDv8x3q4tWYzvTbLUqRaHdIHZqA6RkE66oBwXmovfF8TdatXhLPn47rxpInryA5n9yNEkz3GA
 Pkw2Stjq
 WzpS/agyM25XA9vGyycQsijjSdPtfrBIFkhj8ooilr2qjFx91f9vadFqEv6QZzQMLoLBYSt579ElNfm6WXyvZ8NCki/CpjW/Xzrvptm7di/J3aQss71pKo/wNTKaosg6ZtrFGxF80GMOqeRRGic5Zfn3G/rD7gXhZF8UbicK8umR3NNKXCHPivIqtPJEnwg0jmeYe1hSxMyNsP9DTzU/aMVSN1BgGudC8cz6Y4bVcBGXZUfcuMQ6zztwouXiriKaL6x65zsUQ0zpAe/1f3wpIu3zzfHUKLAImBsRVV1dI7PvBrXmBil5AuBYZw9FU6pV6vrd4ZihLG/e+K8vJaFQLZZ6dqQjzPzQMCjPXX+mnJ5UZ1OzZrvZaKfkx/5Pfizk7GiaCjrxfcBlf2Wuw/0g5j6CqsL10+aYUODEDYKO0R/adZgWd/K92Qr8yIuHianUMxsIoCe9rUmBtF14OKAbNBvNibvcmvJsWL08UDwgOVtrb56FQ45PICXNOFi46/ECRzk0Ugbs/ge1neSspEyHtOZH45h2+3Vx/yMw0/ICIV/+M9Tb90knt+352midjOpQlau806/hKsRXMLyLxpOmTpe+hBFIIClMiHWIT7QEjKZsY2C9vw97k01p069fWlf9F2kNEcfVAHnIlUC6gyeZBntGet/5Z+TnFQn5zI/VXs+O3FUjSy84cc6JUvdLtIYKIA8uPR5E3r+74Npl9LFbStGkvqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Jan 2026, Jeff Layton wrote:
> On Thu, 2026-01-15 at 19:17 +0100, Amir Goldstein wrote:
> > On Thu, Jan 15, 2026 at 6:48=E2=80=AFPM Jeff Layton <jlayton@kernel.org> =
wrote:
> > >=20
> > > In recent years, a number of filesystems that can't present stable
> > > filehandles have grown struct export_operations. They've mostly done
> > > this for local use-cases (enabling open_by_handle_at() and the like).
> > > Unfortunately, having export_operations is generally sufficient to make
> > > a filesystem be considered exportable via nfsd, but that requires that
> > > the server present stable filehandles.
> >=20
> > Where does the term "stable file handles" come from? and what does it mea=
n?
> > Why not "persistent handles", which is described in NFS and SMB specs?
> >=20
> > Not to mention that EXPORT_OP_PERSISTENT_HANDLES was Acked
> > by both Christoph and Christian:
> >=20
> > https://lore.kernel.org/linux-fsdevel/20260115-rundgang-leihgabe-12018e93=
c00c@brauner/
> >=20
> > Am I missing anything?
> >=20
>=20
> This was Chuck's suggested name. His point was that STABLE means that
> the FH's don't change during the lifetime of the file.
>=20
> I don't much care about the flag name, so if everyone likes PERSISTENT
> better I'll roll with that.

I don't like PERSISTENT.
I'd rather call a spade a spade.

  EXPORT_OP_SUPPORTS_NFS_EXPORT
or
  EXPORT_OP_NOT_NFS_COMPATIBLE

The issue here is NFS export and indirection doesn't bring any benefits.

NeilBrown


>=20
> Also, on the ovl patch: will fix...
>=20
> Thanks for the review!
> --=20
> Jeff Layton <jlayton@kernel.org>
>=20


