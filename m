Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F856D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 09:28:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82C576B0397; Tue, 20 Jan 2026 04:28:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D9A76B0398; Tue, 20 Jan 2026 04:28:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BBA66B0399; Tue, 20 Jan 2026 04:28:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 575A26B0397
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 04:28:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6BB78ACE2
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:28:17 +0000 (UTC)
X-FDA: 84351816234.16.237F89B
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf17.hostedemail.com (Postfix) with ESMTP id CD4E94000C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:28:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b=j33OTuP0;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="v RfEPB9";
	spf=pass (imf17.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768901296;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7QgCrbLkIptlQB8MVpfuQ5CmfZ1YH3bd02HxJZ3+58E=;
	b=nwQNcBSw/tA8QTQhCq/W57gGEWXYG7wYl95Sj+/lz2CV2QJGYFUzqWYKAV0CheBSPCJAd4
	nkaVjZvHzTdtJZM89em17CDNkXV4vUj/Hf9UZhKX2CuFxaxEI8iXFT3b9sm05xGgNDBz53
	4NkHG9gZqKpgGOooipD6dla3vFrASFM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b=j33OTuP0;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="v RfEPB9";
	spf=pass (imf17.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768901296; a=rsa-sha256;
	cv=none;
	b=LRtIsdQgyYi3A0en4Z0xwSSSA83BlTV7qxGFEBiTM0FjfTUj0jKXPtUiTA2MTw+YAM6bzv
	cSElLb7uVJBDq25z2/sKEkUYbux8HTWdn8t1wq7kCX5HKWbzJBkRmbVfCtE/k1ilSw9pAZ
	kU5f4wCxEQLqMrOylRQmUh+FIwurGdw=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id CE9921300F39;
	Tue, 20 Jan 2026 04:28:12 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 20 Jan 2026 04:28:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1768901292; x=1768908492; bh=7QgCrbLkIptlQB8MVpfuQ5CmfZ1YH3bd02H
	xJZ3+58E=; b=j33OTuP0cjno3z5TCSPfTCf69nIJq4J2TB5KtE0o/LhmJQgOMMH
	kw9U4yfo+H4rbb4XXms15vEyKh5x5b9B49ixFXgMxO4Fm/hlFNGiQ+bGN45gDtRw
	OmBoeYoqajuPHnyR9SoIEo6hAUWx0AGYwxm0DKRLHzi1XCnz83A+Hu2GZPA6aOKy
	RYLYKmY0UNhDwR1vtSOzYxhEesYwmuTg/Wi6L8FGSkj9+ZIBdbcCFjmPCZksIcHe
	kKd1xQhaGqcg0mozQ4CX54TPCVBCAS2wCwpvglGH91fDXLL6Bvjn2GFbB+NC5Mzg
	8aJ9uAz6SFiYHNlOnXGI9e3y5wQd6hGFAJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768901292; x=
	1768908492; bh=7QgCrbLkIptlQB8MVpfuQ5CmfZ1YH3bd02HxJZ3+58E=; b=v
	RfEPB9lwITUP46pQlb43ZbdMvxQAVBGMGvib8VTBG9JSo9K4qJAJLjbu5y7j73ym
	Qq3Bc0GK6JEw8nge/9U3NMkxvbjnEI/Ql3zoReMMAU2ycFjN5VLIXyTGDlZ9tldG
	YgURkKvG64q2sB1nBTb/8GE6Lw99gQK+2TICCynSDho7Mvxl3hSSag9eGoZb+MaV
	oo8v63rBhvVlkO8Ct3o6GUqwRPu+Ijq5yt0cKqsqAdpEZGpx+AkEVlFEQ3yPkt8x
	uJ/IqXAfO3Pl34Ql8sGavblmOZ2r9+wh8PIDOYvjhIPgR5sCl1S563/bzjtKHtCZ
	P4olLR+6UbfSBxEoSdPgg==
X-ME-Sender: <xms:qEpvaZRu_TffLaKZaE2CMY56BJZs69KBOLtnttktrwuGzZ9ody-WNQ>
    <xme:qEpvaQKNRSt0Wi7GeDYGOldsinZiQ_yhrx7t0k8T2G3tKf8FjH9OLeJ94c9A7G_ww
    X6RDyQAeSOcxaWQTYme-4_uSzp1k5iDvZmDz68VmQKXregkq1o>
X-ME-Received: <xmr:qEpvaUCQIq-1KHB6_RIe1LGDrNvPT7-Pf2pS69NApMKw_XyWcd3Xjgm1K74OT05ZV5sAHW67jfmb2iTtKkO835nraIAcdJpfENZOC6QYa41Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugedttdehucetufdoteggodetrf
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
X-ME-Proxy: <xmx:qEpvaeYFJm2gr5_L8NWl6mKqz3iuWcYL5GhOz7qN1Jbytm-BYS6-XA>
    <xmx:qEpvaWaRmlMl_FAkLOWmvpEFBndgYt5ijvyvEjxWGEaN27mPHvAi-g>
    <xmx:qEpvaQ3aTzLxTMX0gQJAiP7LkrKQZuiwBkg6xW_bdcSF80TWtR8qMw>
    <xmx:qEpvaefZ5gApKS4TFvhYKouLIp05WV67rLedqicozK4OIkyQ2Rx9Zg>
    <xmx:rEpvaZbrohR6KsMgi07NQMg42JbqLkXHlbfm5plWcXavjDNCqQ_UV7PJ>
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Jan 2026 04:27:50 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Christoph Hellwig" <hch@infradead.org>
Cc: "Christian Brauner" <brauner@kernel.org>,
 "Christoph Hellwig" <hch@infradead.org>,
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
In-reply-to: <aW8w2SRyFnmA2uqk@infradead.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>,
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>,
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>,
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>,
 <aW3SAKIr_QsnEE5Q@infradead.org>,
 <176880736225.16766.4203157325432990313@noble.neil.brown.name>,
 <20260119-kanufahren-meerjungfrau-775048806544@brauner>,
 <176885553525.16766.291581709413217562@noble.neil.brown.name>,
 <aW8w2SRyFnmA2uqk@infradead.org>
Date: Tue, 20 Jan 2026 20:27:46 +1100
Message-id: <176890126683.16766.5241619788613840985@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CD4E94000C
X-Stat-Signature: ib6dw7x6s7btq7ib4kix67qkzk96ge1n
X-HE-Tag: 1768901295-446323
X-HE-Meta: U2FsdGVkX1/WtzhmNiKs3u87KJ7UqVcgRBoUqwfgbi0vJ1Wp9rJNN9qV5FFA/6kTDI758F4RdElhvnYhwzsr1WHXVlFhgY9YvoAE5NH3Tly7Cy5JnCiB5VT/SGQH9gTq5qnekavUTyV7Cne3LYYbHaJVFrhLPbYMeDlwdrbKEZ6U7/N33L9IE21R11afxw3vH7nwpYW7n6ClGZ5f6TB7VTj0+LRZcAp1twS0ywKLIEGiWGrt6CJcpuqOY9z5KsLe6iFh4pkOqDjpsNVMe46mpCj/hI560Si4wG1dTSRAQBNy/N3GzN0BIGztF5IzxbGfekwhJr35RbznRas+tiA8d6kkuMMHdHHlfSEvJn5HQJGPZqkCJkX4fp2CbbL41juXRxos+IbRETGJth6ptre3q+EHs8A+C5KBZdoC1mKx5SPmN841R1orVRYQck+CRDHcRsqskbkEwNSslobExspwJJJFlv34SYRHPPM8t9TXixgXV5AU0W2u5kPNjCEJ/WkoZafDaaqZcAxoq1xRiBB/pFWBcYmDcmNut+kKvEANromfbsDNoW28OpSIfwdIA1T0I9+F4APrll0i8LCPFL7SIFptu7twWTKehdgazaa9+KmxRHyxsFZVwGm3ObovDZAxYCWFsOFixONJlWboLifwfYnpNWiUC/2md0/f2v+0rIw3NEM/Kr/tKEqJbBJF/oRrofzDjtUb+IUNgYb1CIMS7TBanaIrnY2Ht9VHw8wk4YRZW3Q8He2j6+O0i4IGJaWbwr1ZxKeAhlAHny72Iq8mem8dj2Nmhm7LTmWS3gq+orwI6uvehNHjuR5GbEEsc4U3Z4hUeE/l4JKDGJLv6bFFmpDG/iAdIX/THSwwG/7HO4NBJdKXudMBe65b9tKhI/KpmMEu6abABcd6TbFN+jXi3ZItCAJZgW6bREGj9HsschG/wHMOSB5YY7YEpO5gtxekg5F+BblmMVqJJ9nx2Gu
 v0gjX0X9
 DDVUJVfUSP156EZiW6AOldy6HKRk0FiBjN5ROUv+4HWKKPxic73v6gPl1QSc9meCnQem1z/xX1CH7aJ75BI5uFlK+9anURn87MOlxs9ft6EL07mh1L0SX4lHMDgpBqv7a0okFCDATzeyRB6tZ7t0a8a2Pky5dcaDZYvwJi/tZ3H5oeDrtR60JraK6ti7e8hMZjATwJRdMOmJ3fNZTlA3P3O1a4FqthO2hfPriGTZJwvaEmUlxZDPxqXfvTF6OI9XmWPVAbSo65MsFamhl9ljysKqjVj6bp84D1rm7He4rLaqKrpFdNme7D5x2qXNBcxXHk5xvPWnsrQnIGiu/EsW1lbPmhMwiE9270OK6TPrYSX5yOqDIc1IzVya+OCcA+HnQaDRbJwU381PodVsM8WhaN8mnwU2OL6U5bB1mHrPSqNugPsNA8bQHjiBLbvB/IrMjYUec+9Pv5tVBW6Pn0reXs51AtVKSWlQNIPfEGcV13fCHyhDMYfiHgQOx1ouy9u0afLhRv1hMhkWEzkKDOCFvkIFM6HG+wBpKJU1Z+6sMxL4qN91l6PSgjeLJZzzQvutlBpQ7BC7P6yWZIMY6nsedWssj3AeGaDZrMNxftFjco8a476LCrqfaz4N8U69gnuSSjTcZuqiFS+6X08YPYXqD0/SJ4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 20 Jan 2026, Christoph Hellwig wrote:
> On Tue, Jan 20, 2026 at 07:45:35AM +1100, NeilBrown wrote:
> > This sounds like you are recommending that we give in to bullying.
> 
> I find your suggestion that anything you disagree with is bullying
> extremely offensive.  If you have valid reasons for naming something
> after the user instead of explaining the semantics, please explain that.

I was referring not to your behaviour but to this statement by Christian:

  So if Christoph insists on the other name then I say let's just go with it.

I think that someone "insisting" on something rather than "arguing
rationally" for something "sounds like" bullying.  Had Christian said
something like "Christoph has convinced me of the wisdom of his choice"
that would have been very different.

I am quite happy to have reasoned discussions with people who disagree
with me.  I hope to always provide new relevant information, and hope
they will too.

> 
> If you think NFS actually explains the semantics pretty well, please
> explain that too, especially in forms that can be put into
> documentation, including for the user ABI.

There are multiple issues here:

 - filehandle stability.  As far as I know all filesystems provide
   stable filehandles when the "subtree_check" export option is not used.
   Certainly cgroupfs does.  So having an EXPORT_OP_STABLE_HANDLES
   flag would mean it was set for every filesystem - unless there is
   something else I'm not aware of.  That is certainly possible and I
   hope someone will let me know if I'm missing something.

 - filehandle uniqueness.  This is somewhat important and if a
   filesystem doesn't provide it, that should be considered a bug.  In a
   different thread Christian has observed that there would be benefit
   if pidfs and nsfs provided uniqueness across reboots.  It is quite
   easy for a virtual filesystem to generate a 64 bit random number when
   the fs is initialised, and include that in file handles.  Having a
   EXPORT_OP_REUSES_HANDLES flag could mark filesystems that are still
   buggy if that is thought to be useful.

 - GETATTR always reporting file size of 0.  This is the only concrete
   symptom that Jeff has reported (that I have seen).  This  makes it
   impossible to read files over NFS even if they have content.
   Would EXPORT_OP_INACCURATE_SIZE be useful?

 - maintainer feature choice.  A maintainer may choose not to support
   export over NFS because they feel that there is no value and the
   possible support burden would not be worth it.  There may be locking
   / lease / etc issues that further complicate things.  So it might be
   reasonable for a maintainer to choose to forbid NFS export while
   allowing local fhandle access. EXPORT_OP_NO_NFS_EXPORT.

It took me a while to sift through the code/patches/comments and come to
this understanding and I apologise if I wasn't as clear earlier.  But
my intuition was always that file handle stability was never the real
issue, and maintainer choice was.  Hence my rejection of the
"STABLE_HANDLES" name.

Thanks,
NeilBrown

