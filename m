Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67982CA5FFA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 07:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B08CE6B0125; Mon, 19 Jan 2026 02:23:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0466B0127; Mon, 19 Jan 2026 02:23:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998F76B0128; Mon, 19 Jan 2026 02:23:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 893276B0125
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 02:23:13 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A02613B7B5
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 07:23:11 +0000 (UTC)
X-FDA: 84347872182.02.E78BA0F
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2A76A40003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 07:23:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b=irDVjFha;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="K 8ltski";
	spf=pass (imf11.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.143 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768807389; a=rsa-sha256;
	cv=none;
	b=cdQ2PF8ByXLt/JJNwpY3RUnsLeaYsViUpvFK+Pf2i0hNO4DruSl4SvUl8i3VWr70bCR9wQ
	4xzsQzu55q4DogQy8a+hm+EqUFDi4MxMCtmHCDWtgVdh/EA+l+6JxuYyKtErc1Jhy9SLi3
	KUvpMZyiPYA4KeBkW5WkzZoaeOIYYQI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b=irDVjFha;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="K 8ltski";
	spf=pass (imf11.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.143 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768807389;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0q9OiSiL57A1oXpVwou+Qazcwu9lF8/fKQyDTZuHuY=;
	b=8ClZpBtg8S21rs/iH1uC+EJMlmzjKxzOmDyqYxfc/jti8ZBvd3P95pUEbmMzEULN/qOKIT
	mdUPb3RMt80ebdmvVScEo9Y/2Igb//Gjm6ECGK9cW0fDLPU49oQQArSftL2DjLGI8E/Zhj
	tB6Nz7NeZC08syVPr1GrlPTL5wMxFfs=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id 3219E130103E;
	Mon, 19 Jan 2026 02:23:06 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 19 Jan 2026 02:23:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1768807386; x=1768814586; bh=l0q9OiSiL57A1oXpVwou+Qazcwu9lF8/fKQ
	yDTZuHuY=; b=irDVjFhaz/K8YtiXzQ31MDOgMGCo+Gz//EwM4OijAM0vOKynyB6
	BpwYFZYCEe3o7Gx5L4V6M4FhbipwQNJV0ujCSLBSc5IHezW/FyB/LWZraYVlaMJu
	YnnpUl4JgVLbrNIec+WcKPTR09keVUJuKuo5IR+gQesu/p0p7PhQm/pf+9OgvKR5
	WdaCaILT5Zm8fqMcKW/PAdv1HxPiIM+Z3QX4jypg1fiENCArP/M8KaRMfJ7uYtgT
	cBjjHOj9Mr9wPQirkQS2BYF8pjwZRelVojFvJtbhrJ5l9QZPmQNMkhdcWIaHKOt+
	ltoa8OTg2UGC53H+WAMXgf82R3jVtEKBVww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768807386; x=
	1768814586; bh=l0q9OiSiL57A1oXpVwou+Qazcwu9lF8/fKQyDTZuHuY=; b=K
	8ltski0YBtBzy6uowaabbff8s5zuRDbtUFWXcDtg931MBwRc16+CKDMRYekaXZHk
	LOnd7mQjODx3F7HVmyPZWvLOv8yjti4w+MIAbxpLRgNDP65uPFl9Gfl058RUJHH+
	Fk6+cJVTq4wuDdMq1Z5W9k1ZuC7iRuYcXx1GwUdvxisFOcHq/jX6VpQCI2oyR0CU
	ZM3JKGGiUVRS4Nbh4KzQMT/wi9djnt+fqIQkRVTwyAKauSyNTqZZcQHWI735MH16
	4XBGsVULicKWqCSMDT9bs+x+/xy/Gu1Q6khze7NDCvAP+QvrXTWLwqj3Y9LKIzDB
	XZKhCr7irnaORckcnoZBQ==
X-ME-Sender: <xms:1tttaQEL1zY-cqjAi3LwisLLYig4vGmVFZGnEWqvFdfPu_1cBx4ryQ>
    <xme:1tttadNPXJyKg4i6N7NiajEYCS_ixBqVWnODY0xDbeIYm-0ddIGPmXX4nPobqTrUH
    FdEox9n77yL1V53kkmfQXZnVrRbAt8y41xmdzHA26xbb4UiNw>
X-ME-Received: <xmr:1tttaX2pXmbQvkTPzq0NQg4Hf4lyVdk2Kt7K2P2YoY0rgkMkSP0qEY7AWJnIFHDorFcLBSqfoL6DkzzzXRH8ujZGIJqMnM5xQhHy1RkjUWf6>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddufeeileeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:1tttabHi5RQs76Xz74nOwWrYIZ47zQ7Zj71gIm-NgtkzokJPtBcMHA>
    <xmx:1tttafzYjiWXRjDGlVz6_k-3h2GeOsbL3CzwIMyCt37eR3PuktBG4w>
    <xmx:1tttaaofGHLgl2z91oIIPm_yXGWHUeCGCqWi64kkrnWVR5nBeLXySA>
    <xmx:1tttaUlKdw4URdR2-6lB_1IM56jb7LL9_P5nu35Q0sPULNdt9mAF_A>
    <xmx:2tttacnPYyzS2rQik0c4UgQtzVVe9-q502rX9-wmNn1taRjPmfmDMIhi>
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Jan 2026 02:22:45 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Christoph Hellwig" <hch@infradead.org>
Cc: "Jeff Layton" <jlayton@kernel.org>,
 "Amir Goldstein" <amir73il@gmail.com>,
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
 linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
 devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev,
 ntfs3@lists.linux.dev, linux-nilfs@vger.kernel.org,
 jfs-discussion@lists.sourceforge.net, linux-mtd@lists.infradead.org,
 gfs2@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
In-reply-to: <aW3SAKIr_QsnEE5Q@infradead.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>,
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>,
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>,
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>,
 <aW3SAKIr_QsnEE5Q@infradead.org>
Date: Mon, 19 Jan 2026 18:22:42 +1100
Message-id: <176880736225.16766.4203157325432990313@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>
X-Stat-Signature: f66ixhwxhz1da5b4sio7oq85sb8stqtc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2A76A40003
X-Rspam-User: 
X-HE-Tag: 1768807388-233154
X-HE-Meta: U2FsdGVkX19MihlgT4m1+0CcRaLY4pV1RGeMg/c/yyoPThc7parneAFaE0tLc3bsMJ2uOACXJXoIESHJkh0H81zarmBLS3O4jMgVDv2vRO9K8yBHkTA2rkgpHBUIX9NrSwODF4fKEIQLvlg/k6QFe0APqeMntZYE1/0Ij4/qD0LRv6T7dQu7SUfhJNcHBEjQ/Y5P7JmtCRg8ub+ts+Ms4f2lSFBa4KsCuFjWQUOvlzvdI+8h9O7nIq4vxdjJjJfd+C8oROted3MFkcZ+aQ8GhVFYW9IamRKAy20ExH4wEeFX/t5rX/vJGvD0KJ4qQb/x4fuuylYWVk0vl4PDfLZpvh2T/NzYWMvWTVaVIwsmCUWt6H/lwwqYNVO62qvUYfpmwjBFBy5mfRdiQsmdmx0h9XLMGPDXTRlEto0ADym7hfcgAyMPFebL58BT7PB3tsoraEOYZs4jDMtOHtoow+jDXHugxxdxNLO5ocQWAgTMp2A2WPA9BdkKQJ4K62tqRSkGqr/6NUvvnsfXxCuSh6ze8Dt5ZhB2xwxiKqhnS/XuIhfuAZGDOtcskuCJU0627xiwfGWOt7p2v3c8Ka5SnDP+KtJtUXio07MtRnQ5L/5sDEBYqOJKJRRsRmVAiSPMbp+CTwGYlI91wNCqobEHJf7DLGVc6M+s9UuICzHx5O2R0CLb00rke5hap20Kc1B7IplIQ+NxtL/XBYX7pLI3f4XWUzz+GhLlD6C+9Clk2MBU3JlWfXckj0ZZASdCUDH9mwV351Gxf8qtC/yGMJI6u8mtXvR+SyizOKlUb588hcu0s8aT2gv9F82wlU3i3T8LEZvV7BRljn3OHkM9NH7skGtCzdfpvshSgi0HsTFe0Q5ig5sFN4bYyiM3fF5ym0rURWxUjZXDD+EJ6s3n6XwFdeT5rTDVI/D0Qr4WHYRHkLYS9V/V7WwNGAMeqtkXzMRzkjkEiliBI+wjaVuBJIx0Bt7
 cyO4+qSe
 S7FY3Ag04vGMJdt4ypuBoD7zegmwXZanALIlUjsxixc4Y8sHFbI7v8Mt9ZmOY06zX2CjB2nzPa4A6DKo/KNthuK2IKH6FUL2F8U6CHCIYm3e3Oo4CcCSCN9fmv+EE8EndGnv2oXGpeSSWrxk5ug6AuGW3iEqCX8BOqrMJ/9oumK//XLkkjJoFEggeQUVJ8MiP9Hhaf0f4SbAAbIlnvkPFCQE8ppGC+boQ+VOzAbg8Z7fZYsDrik/kTbYxGecAUo5EhdlKHyWxS3NgtHSfIondsb4rK4ojrnT26WZEt7vAyy01Dsypl3O5ywi/BCN/CJYEPf4+tbY36MjIpMW5y/uxu5dRoickJ1wSiAL4uoLjNwcrYdYhIsH5TO6WVXlYZ3g5leWrLXuC4L+rou8GBZneF31FxG6CrB6ToRDtOkaLGfmK5/MI226SD36G6S6OicNZ9qM1/eYaWDP8/XGxCW+6nHpbYSds38w/gpd2qiPmJ9CKbacl+ej+n9GWMUew94/Y1xPx7p5khjinuuBCheOA+EnnZXGjgiHqonHUmiMYbCXNeARyFsrot0MThcqiBVGtO7MBsEerkJk+A4wrerHt98rcOGiuhQkR8im0ga913jZPrrHeVBSwYHofNk8SzC+VvtFBE9g12W4YSUtzEdJunFfjkbpDy+NsZEAOs2tQpcKb3WmLhne5c4ukEpCnydQ4TXtM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 19 Jan 2026, Christoph Hellwig wrote:
> On Mon, Jan 19, 2026 at 10:23:13AM +1100, NeilBrown wrote:
> > > This was Chuck's suggested name. His point was that STABLE means that
> > > the FH's don't change during the lifetime of the file.
> > > 
> > > I don't much care about the flag name, so if everyone likes PERSISTENT
> > > better I'll roll with that.
> > 
> > I don't like PERSISTENT.
> > I'd rather call a spade a spade.
> > 
> >   EXPORT_OP_SUPPORTS_NFS_EXPORT
> > or
> >   EXPORT_OP_NOT_NFS_COMPATIBLE
> > 
> > The issue here is NFS export and indirection doesn't bring any benefits.
> 
> No, it absolutely is not.  And the whole concept of calling something
> after the initial or main use is a recipe for a mess.

We are calling it for it's only use.  If there was ever another use, we
could change the name if that made sense.  It is not a public name, it
is easy to change.

> 
> Pick a name that conveys what the flag is about, and document those
> semantics well.  This flag is about the fact that for a given file,
> as long as that file exists in the file system the handle is stable.
> Both stable and persistent are suitable for that, nfs is everything
> but.

My understanding is that kernfs would not get the flag.
kernfs filehandles do not change as long as the file exist.
But this is not sufficient for the files to be usefully exported.

I suspect kernfs does re-use filehandles relatively soon after the
file/object has been destroyed.  Maybe that is the real problem here:
filehandle reuse, not filehandle stability.

Jeff: could you please give details (and preserve them in future cover
letters) of which filesystems are known to have problems and what
exactly those problems are?

> 
> Remember nfs also support volatile file handles, and other applications
> might rely on this (I know of quite a few user space applications that
> do, but they are kinda hardwired to xfs anyway).

The NFS protocol supports volatile file handles.  knfsd does not.
So maybe
  EXPORT_OP_NOT_NFSD_COMPATIBLE
might be better.  or EXPORT_OP_NOT_LINUX_NFSD_COMPATIBLE.
(I prefer opt-out rather than opt-in because nfsd export was the
original purpose of export_operations, but it isn't something
I would fight for)

NeilBrown

