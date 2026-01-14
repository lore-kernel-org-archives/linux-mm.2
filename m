Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F6B8D37E3D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 14:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDE726B0089; Wed, 14 Jan 2026 09:53:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84CB6B008C; Wed, 14 Jan 2026 09:53:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6AA96B0092; Wed, 14 Jan 2026 09:53:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A438E6B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:53:08 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 384291A053C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:53:08 +0000 (UTC)
X-FDA: 84330862056.01.5092ACE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 15D744000A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:53:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DZ4y7792;
	spf=pass (imf07.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768402386; a=rsa-sha256;
	cv=none;
	b=0E3ROoN7n0P28JD2mvOOkU2l1fIOtkLOItFZ8RpAMt6iNrxesxFqBDf0ANCcMDGJ/VuaY4
	f7NuALE/AWUMpAyWdCDBiFMWMSSRt9XiXhRuP7DPRuhHCQ1XBq5eBppMFoui/kPTWjrfqT
	j7CAlJE8xLFQCj3Yn4w0hwUjEd/rkss=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DZ4y7792;
	spf=pass (imf07.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768402386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xKp2mRX639Xrl1hAH25cMUgzI8E+8kaOkrWTmDZ9gJI=;
	b=0uUoa9s1Wk2iTuad4ovnP66fCs+43qC4XXs0LYaWB+P4eKAblL1OY+bvDXfvlsVS+pbTvk
	oBW4TevWpBVMyBOKsreFGmYvAmAKxhNO9OQ+irHmZoK9+t6qZ9QoDYQaGIicQN+4KnwQ5s
	teDXp6YIapt7mm4ssfIbhXHeo+cSLxQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BBFEC44110;
	Wed, 14 Jan 2026 14:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C50AC19423;
	Wed, 14 Jan 2026 14:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768402384;
	bh=xKp2mRX639Xrl1hAH25cMUgzI8E+8kaOkrWTmDZ9gJI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=DZ4y7792kI2/4eE5VVTlEy1lwDXzIzeNr2iEGyaqqLMYTsvcSbwt8Bo54fNz4FJrn
	 0CjwDI0jj4BZuie48fZ7X8+pogo2m9xuuz5ZkTKqUIWIWMb2aIahe3YDQ1OihTAsyY
	 /kSWP/W66gnEfc8gA/3bKKHjBBbzoJWIQmXxEVECLl86oIEVeZwN3rPLewdZXpBLNQ
	 4fSATB6J5Q9DEK8WPOow5IHJKdW2q5kckZv1zfwvc/Rackn2AgyYEGYSEHyTHq4m0k
	 xzDo6EcWHnQhpPR7xCjV8fvC1tdohxaCsjAOcYPGoYZ1/+HzD4MzDToJBxFdCh/tru
	 OSjQsEWq0CzTg==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 336F2F4006C;
	Wed, 14 Jan 2026 09:53:02 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Wed, 14 Jan 2026 09:53:02 -0500
X-ME-Sender: <xms:zq1naTL1verRbjv_OWxa5Qc-mm-FLSmJA57qMcDcmimTH1ZvOzAH8Q>
    <xme:zq1naR8m09634GxEfslbvAHAt_pWKVnj5KMHoclqQy7tbEop4pkDoeOLzOlsxhgNB
    mfBJSAWYD5Pvqo039VVHWSbWWy3lMiNKfBSo92wfzMrsG2olMOvAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdefgeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedfvehhuhgt
    khcunfgvvhgvrhdfuceotggvlheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefghfeguedtieeiveeugfevtdejfedukeevgfeggfeugfetgfeltdetueelleelteen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegthhhutg
    hklhgvvhgvrhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeifeegleel
    leehledqfedvleekgeegvdefqdgtvghlpeepkhgvrhhnvghlrdhorhhgsehfrghsthhmrg
    hilhdrtghomhdpnhgspghrtghpthhtohephedtpdhmohguvgepshhmthhpohhuthdprhgt
    phhtthhopegrlhesrghlrghrshgvnhdrnhgvthdprhgtphhtthhopegrshhmrgguvghush
    estghouggvfihrvggtkhdrohhrghdprhgtphhtthhopehlihhnuhigpghoshhssegtrhhu
    uggvsgihthgvrdgtohhmpdhrtghpthhtoheprgguihhlghgvrhdrkhgvrhhnvghlseguih
    hlghgvrhdrtggrpdhrtghpthhtohepshhlrghvrgesughusggvhihkohdrtghomhdprhgt
    phhtthhopehjlhgsvggtsegvvhhilhhplhgrnhdrohhrghdprhgtphhtthhopehmrghrkh
    esfhgrshhhvghhrdgtohhmpdhrtghpthhtoheptghlmhesfhgsrdgtohhmpdhrtghpthht
    ohepnhhitghosehflhhugihnihgtrdhnvght
X-ME-Proxy: <xmx:zq1naR4y4iRWBYp2xNnePgUOv-GP1DKdFBDtDf2IC92YRobPvv4XvQ>
    <xmx:zq1nabUvbFcuW5qmkDCHdiOne_rDLza_EAZnBtIjXTs4zRVj0oLKWg>
    <xmx:zq1naXWzKUDfqjQXjvlbqUXobr95Hj_DLjvdFTe0pPxUPWiy4igVFQ>
    <xmx:zq1naQSTIJTSkNqnVd_7fRCRq8sinXvVVU9WAT0_5jXT_tt716hBhQ>
    <xmx:zq1naeeXm4Q-EAh1xMCT3MnzrdKd7lPZzpjsKoHgYV0ycvEqIoQrdgKM>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id F2C75780070; Wed, 14 Jan 2026 09:53:01 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: ArEQL-Tet5yZ
Date: Wed, 14 Jan 2026 09:52:34 -0500
From: "Chuck Lever" <cel@kernel.org>
To: "Amir Goldstein" <amir73il@gmail.com>, "Jeff Layton" <jlayton@kernel.org>
Cc: "Christoph Hellwig" <hch@infradead.org>,
 "Christian Brauner" <brauner@kernel.org>,
 "Chuck Lever" <chuck.lever@oracle.com>, "Jan Kara" <jack@suse.cz>,
 "Luis de Bethencourt" <luisbg@kernel.org>,
 "Salah Triki" <salah.triki@gmail.com>,
 "Nicolas Pitre" <nico@fluxnic.net>, "Anders Larsen" <al@alarsen.net>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "David Sterba" <dsterba@suse.com>, "Chris Mason" <clm@fb.com>,
 "Gao Xiang" <xiang@kernel.org>, "Chao Yu" <chao@kernel.org>,
 "Yue Hu" <zbestahu@gmail.com>, "Jeffle Xu" <jefflexu@linux.alibaba.com>,
 "Sandeep Dhavale" <dhavale@google.com>,
 "Hongbo Li" <lihongbo22@huawei.com>, "Chunhai Guo" <guochunhai@vivo.com>,
 "Jan Kara" <jack@suse.com>, "Theodore Tso" <tytso@mit.edu>,
 "Andreas Dilger" <adilger.kernel@dilger.ca>,
 "Jaegeuk Kim" <jaegeuk@kernel.org>,
 "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
 "David Woodhouse" <dwmw2@infradead.org>,
 "Richard Weinberger" <richard@nod.at>,
 "Dave Kleikamp" <shaggy@kernel.org>,
 "Ryusuke Konishi" <konishi.ryusuke@gmail.com>,
 "Viacheslav Dubeyko" <slava@dubeyko.com>,
 "Konstantin Komarov" <almaz.alexandrovich@paragon-software.com>,
 "Mark Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>,
 "Joseph Qi" <joseph.qi@linux.alibaba.com>,
 "Mike Marshall" <hubcap@omnibond.com>,
 "Martin Brandenburg" <martin@omnibond.com>,
 "Miklos Szeredi" <miklos@szeredi.hu>,
 "Phillip Lougher" <phillip@squashfs.org.uk>,
 "Carlos Maiolino" <cem@kernel.org>, "Hugh Dickins" <hughd@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Namjae Jeon" <linkinjeon@kernel.org>,
 "Sungjong Seo" <sj1557.seo@samsung.com>,
 "Yuezhang Mo" <yuezhang.mo@sony.com>,
 "Alexander Aring" <alex.aring@gmail.com>,
 "Andreas Gruenbacher" <agruenba@redhat.com>,
 "Jonathan Corbet" <corbet@lwn.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Eric Van Hensbergen" <ericvh@kernel.org>,
 "Latchesar Ionkov" <lucho@ionkov.net>,
 "Dominique Martinet" <asmadeus@codewreck.org>,
 "Christian Schoenebeck" <linux_oss@crudebyte.com>,
 "Xiubo Li" <xiubli@redhat.com>, "Ilya Dryomov" <idryomov@gmail.com>,
 "Trond Myklebust" <trondmy@kernel.org>,
 "Anna Schumaker" <anna@kernel.org>, "Steve French" <sfrench@samba.org>,
 "Paulo Alcantara" <pc@manguebit.org>,
 "Ronnie Sahlberg" <ronniesahlberg@gmail.com>,
 "Shyam Prasad N" <sprasad@microsoft.com>, "Tom Talpey" <tom@talpey.com>,
 "Bharath SM" <bharathsm@microsoft.com>,
 "Hans de Goede" <hansg@kernel.org>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org,
 jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
 ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, gfs2@lists.linux.dev,
 linux-doc@vger.kernel.org, v9fs@lists.linux.dev,
 ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Message-Id: <5a1730f3-30ff-403c-a460-09a81f9616c5@app.fastmail.com>
In-Reply-To: 
 <CAOQ4uxhDwR7dteLaqURX+9CooGM1hA7PL6KnVmSwX11ZdKxZTA@mail.gmail.com>
References: <8af369636c32b868f83669c49aea708ca3b894ac.camel@kernel.org>
 <CAOQ4uxgD+Sgbbg9K2U0SF9TyUOBb==Z6auShUWc4FfPaDCQ=rg@mail.gmail.com>
 <ec78bf021fa1f6243798945943541ba171e337e7.camel@kernel.org>
 <cb5d2da6-2090-4639-ad96-138342bba56d@oracle.com>
 <ce700ee20834631eceededc8cd15fc5d00fee28e.camel@kernel.org>
 <20260113-mondlicht-raven-82fc4eb70e9d@brauner>
 <aWZcoyQLvbJKUxDU@infradead.org>
 <ce418800f06aa61a7f47f0d19394988f87a3da07.camel@kernel.org>
 <aWc3mwBNs8LNFN4W@infradead.org>
 <CAOQ4uxhMjitW_DC9WK9eku51gE1Ft+ENhD=qq3uehwrHO=RByA@mail.gmail.com>
 <aWeUv2UUJ_NdgozS@infradead.org>
 <c40862cd65a059ad45fa88f5473722ea5c5f70a5.camel@kernel.org>
 <CAOQ4uxhDwR7dteLaqURX+9CooGM1hA7PL6KnVmSwX11ZdKxZTA@mail.gmail.com>
Subject: Re: [PATCH 00/24] vfs: require filesystems to explicitly opt-in to lease
 support
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 15D744000A
X-Stat-Signature: kd9u5byx1rfczopw93t3wg4zkig3iy1n
X-Rspam-User: 
X-HE-Tag: 1768402385-733322
X-HE-Meta: U2FsdGVkX18wrDqGrv1g2T8KOknSITyW2g26aXeYp8xBcPdwLHH0RTemWUAFxVm105AxnHCKRIvc/zYETZRPyKkHTbFH+EKELYlAvCKrQ+4X6V00LLLfk5DvB7dCuIgK/OIJ93GJDiOKTSUi6B/VtzTYgL5dndBUjd4VQZC4HiJ1kFQwoYGuBWMVT6TQubb0aiTnY4gGJKknNyBivDW/iokkdSrCzukmgM+Dur4D+t/dwgMQEGmrm+xfPS+I/HGn0C5C8Kp5nG0b/NaRLR3NZKXePPDWc/dfsFUo0VRRNWDxWptVkhnVPMXq4NhhwJ+7ntgDQ5w/7E7rfAl4k0SMjY0pFsCE23YE92dW0GoqznnCizuo9Tg7H3Yr7vhHlyPGdGPADnP8BRkiO7TmY9jVFcG62eHysHlxIL/1z7WzujDnOt5S6ca9SG/u88jxM1YiUOCW+JtbPH8g0nN19bvBZkhtlvcX+pdAz1ly6SlnMt4Im0VuEVxbyE3pNr/whv7lhiikfFm9PO5CGbd9Czbd019CuUYnMTUyiD/MI8qI9ju8TpIP8yo9W+RHyK1O907UOP9LpWnFLpAIKpf6ywDW19bzuctgrdg9EklRpzOooExfdaRhePsiMfpNgnT0iHfhpRyHBSzkK4aJfp70wUZFHO6O1s6DFUIt2lEktnUnHZWhURFArSYQT1Pm4exLe6pOBm4hjN+odsUjOfqKbRtlhMVe/7vU1eI4PiDLNPRYdNH14RTWahLauwO0jQNAsLQ/Lnaqyqhl98h1bzxXiu84UNDxEjB2kENY+A6OcOhwqaM7oLmXs7gPG5sX665QYfvdG6lh9i8n1ajcO4XjgdYYWCBSc3p16OhZsERYja+5IVZVX+Ytpsq4DfLiEHrUXiUKEcn67cflEXI9yqmg6siYyO0iplucIx6AajRh0cMC/BZfK5Q9U6Ng6dC/fZzrBs1bWbtBwxYyc+fzjp8s61t
 VCwWKaUv
 w9UavDG3w/BAaz15UVbhrpBdul9ziD3TVtKVhcXsvy7gNNFCDfeW29Sr1jWXIugJmno62QRKQsrTVltaZvo5vn5Tjp9QwluFupbPDnqCa18Vd3kZqR3YIY1ScJZ3frF0kUca0rrLROtD+VVJ+59V9b3kBM2h9Si8dC0Xp9cWlz6sG9dSoCgJNGvlVsGhr3APKNCkWfqnItrCegpmya34yoNY8p4XDOGPQCnmBpHmfVsc/xAM835ndstNeQV1cwEVb6LfOazWGsoZRxdhC+5IZaIqewKYKcM4CqzqDj9mJNnAvN0gFbfjDdU3IGDUIxniu//BK0Lx0UwD+k/B0SzXL5nYluw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Wed, Jan 14, 2026, at 9:14 AM, Amir Goldstein wrote:
> On Wed, Jan 14, 2026 at 2:41=E2=80=AFPM Jeff Layton <jlayton@kernel.or=
g> wrote:

> Very well then.
> How about EXPORT_OP_PERSISTENT_HANDLES?
>
> This terminology is from the NFS protocol spec and it is also used
> to describe the same trait in SMB protocol.
>
>> The problem there is that we very much do want to keep tmpfs
>> exportable, but it doesn't have stable handles (per-se).
>
> Thinking out loud -
> It would be misguided to declare tmpfs as
> EXPORT_OP_PERSISTENT_HANDLES
> and regressing exports of tmpfs will surely not go unnoticed.
>
> How about adding an exportfs option "persistent_handles",
> use it as default IFF neither options fsid=3D, uuid=3D are used,
> so that at least when exporting tmpfs, exportfs -v will show
> "no_persistent_handles" explicitly?

I think we need to be careful. tmpfs filehandles align quite
well with the traditional definition of persistent filehandles.
tmpfs filehandles live as long as tmpfs files do, and that is
all that is required to be considered "persistent".


--=20
Chuck Lever

