Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCAC3FED2F5
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:19:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4769B6B0005; Thu, 12 Mar 2026 20:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44E2E6B0089; Thu, 12 Mar 2026 20:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 350546B008A; Thu, 12 Mar 2026 20:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 225FA6B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:19:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ACB7F1C654
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:19:08 +0000 (UTC)
X-FDA: 84539129976.13.6660D4B
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf08.hostedemail.com (Postfix) with ESMTP id AF511160002
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:19:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=gHD+X8LZ;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="c CdkekO";
	spf=pass (imf08.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.138 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773361146;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mVG8eebTQIYrNSCfz5AoYNPWvAP9zOmA/oSXBEUNMDg=;
	b=auvt282y+CfaMIkog4w4yrb1sT/ZAemkkxeNKqmJslAAi+yjPiOXv0/KnT5QVrDFODf/AG
	Atcglg2URim+ccS551jE/KgBeKKw4FMz2F2ogMGCloqfCMqI9uW1YLBJVX7LvekKAZP+Ed
	pgi6a+RRsbLEDk4yjwwzc3KC9knRoB4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773361146; a=rsa-sha256;
	cv=none;
	b=mSGPK5lIzt2Oy/YBEmsdGsN5QNZSTsPts+ff1eSQk5MH7e6GBA/ivgIIff8KY4TqGT80GI
	N5judUSjxND/s+jABhrYXRJC761y0tSFpsIvSC+vTfAxMh/YpDXukOonvZigVsDV+34F67
	Zt/L7uCL0ZKei5RGSi1ENAryFxJyGZg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=gHD+X8LZ;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="c CdkekO";
	spf=pass (imf08.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.138 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id 8CEA61301B20;
	Thu, 12 Mar 2026 20:19:04 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 12 Mar 2026 20:19:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1773361144; x=1773368344; bh=mVG8eebTQIYrNSCfz5AoYNPWvAP9zOmA/oS
	XBEUNMDg=; b=gHD+X8LZJV5BmcTxyVzSi4eOH+f9NWdLk6voSZ3Dk2TmtFtrTPT
	n0z2oXB44COIaMxym9EotuPwl3zhBchA17LQD1aiXLP0HZVx+1sB2rDvs+59CClN
	HQKjtkq+MLlefiP50e3G0ZUzDRVImhJt8LXC5Gk+3LL4kz0dWCTiZEgkORI83H3g
	IYzMIhIFS+pW8u+iq3O1fDK+eB6xv0w3oEKr75CQKG3ENMDVGe/ATK98/l7Dvx/P
	8BZhP/BMTsa8A8nINOCn4yT0evPyJ+NeT9UVxbDjMi1RnmCTf2Vmbpsgbeb+2prd
	AnO6/VSTlvk8uuzd90K874TkKVJWxfC+iOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1773361144; x=
	1773368344; bh=mVG8eebTQIYrNSCfz5AoYNPWvAP9zOmA/oSXBEUNMDg=; b=c
	CdkekOPdZGeTHq9Q9fn6kwRHxICBqhAbEe7Mbn8RL0/ghUTZud8i2luiteEmp2Ir
	nIdMJTy2arC7PIdd3QUxuvFoTPxCOMLV9z6Gm7Dry2+55WAsz8/lpUpp6KLCvOb5
	vppTuCMIOaaruvILxo7wGqRgbVRfmvszAtPJWbhzUWIoBUdJz8+7BU3zgxJSlbc3
	fpGHsm7gMQ5BqZ2Qbs1zxa7FgNneoKrfT70cZbcDqlzmSr5Rt1Zdfq8ZqH/0hCpG
	u4ztiIjqn7BZ94m/pkzsJPqZlNum+Fn4NWKv3hqcNWG2BtBRflNBWi/TcF8QJ+Eo
	3H4DqYmdO0Ph/KIpM2FGA==
X-ME-Sender: <xms:9lezaf2biEH_YUoVtaJ788TBctRMYMGJjfZ2DGR5uanh1iY0Bnn1tg>
    <xme:9lezaRxzKm32RjDuV_b2LpuNVPPb6Y2SpMCDjskankSuVyTtPWjSsFcMWwjNHIFU7
    GLRMDp98i1zC2yMmBsdKulbM_AH2YMuIt5X8wc4fPQA-OpC2Q>
X-ME-Received: <xmr:9lezaa84oPqo9JeTHF-KiyHUZaJt4h0JSykKqUiirLVobFQ0qtPIFeYYpGFOGnN83U9sO87B36Hyg9vaeC9k5oIsMjNlS0OCsh5IMJauHcVf>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeekvddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurheptgfgggfhvfevufgjfhffkfhrsehtqhertddttdejnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epffevjeeljeehueejgeehleelueevudehjeekgeevueffteevhfefvedtueeugfejnecu
    ffhomhgrihhnpehgihhthhhusgdrtghomhdpkhgvrhhnvghlrdhorhhgnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsgesohifnhhm
    rghilhdrnhgvthdpnhgspghrtghpthhtohephedupdhmohguvgepshhmthhpohhuthdprh
    gtphhtthhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpdhrtghpthht
    oheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hlihhnuhigqdhunhhiohhnfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthht
    oheplhhinhhugidqthhrrggtvgdqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheplhhinhhugidqnhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
    dprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdho
    rhhgpdhrtghpthhtoheplhhinhhugidqvgigthegsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:9lezaSQ88me8CYxNCjygrSQBmtG4cdv1lL3aUTLRRuM52pJKUU1ccw>
    <xmx:9lezaXkQlDHP4UxMpnGEVP1brRONq1oRM3xyFBblzX9245pjYr4Vpw>
    <xmx:9lezaSZBls0VHhctSLEpvUTcq6jJd_Fbrs8I5U1SyxvxEE-JGS1Fuw>
    <xmx:9lezaak5kvHNn-TYlzGIxM5qxPwoE_QzIk7oFu49dZPa1Fp3mUUnVA>
    <xmx:-FezaRCDWnLXkmnc85hbOjTGKD_omhp2YPsIbC_7rVSfPvFCo06RTGxC>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:18:49 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>,
 "Jeff Layton" <jlayton@kernel.org>,
 "Trond Myklebust" <trondmy@kernel.org>,
 "Anna Schumaker" <anna@kernel.org>, "Carlos Maiolino" <cem@kernel.org>,
 "Miklos Szeredi" <miklos@szeredi.hu>,
 "Amir Goldstein" <amir73il@gmail.com>,
 "Jan Harkes" <jaharkes@cs.cmu.edu>, "Hugh Dickins" <hughd@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "David Howells" <dhowells@redhat.com>,
 "Marc Dionne" <marc.dionne@auristor.com>,
 "Steve French" <sfrench@samba.org>,
 "Namjae Jeon" <linkinjeon@kernel.org>,
 "Sungjong Seo" <sj1557.seo@samsung.com>,
 "Yuezhang Mo" <yuezhang.mo@sony.com>,
 "Andreas Hindborg" <a.hindborg@kernel.org>,
 "Breno Leitao" <leitao@debian.org>, "Theodore Ts'o" <tytso@mit.edu>,
 "Andreas Dilger" <adilger.kernel@dilger.ca>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Ilya Dryomov" <idryomov@gmail.com>,
 "Alex Markuze" <amarkuze@redhat.com>,
 "Viacheslav Dubeyko" <slava@dubeyko.com>,
 "Tyler Hicks" <code@tyhicks.com>,
 "Andreas Gruenbacher" <agruenba@redhat.com>,
 "Richard Weinberger" <richard@nod.at>,
 "Anton Ivanov" <anton.ivanov@cambridgegreys.com>,
 "Johannes Berg" <johannes@sipsolutions.net>,
 "Jeremy Kerr" <jk@ozlabs.org>, "Ard Biesheuvel" <ardb@kernel.org>,
 linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
 coda@cs.cmu.edu, linux-mm@kvack.org, linux-afs@lists.infradead.org,
 linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 ceph-devel@vger.kernel.org, ecryptfs@vger.kernel.org,
 gfs2@lists.linux.dev, linux-um@lists.infradead.org,
 linux-efi@vger.kernel.org
Subject: Re: [PATCH RFC 00/53] lift lookup out of exclive lock for dir ops
In-reply-to: <20260312193847.28c32a2c@gandalf.local.home>
References: <20260312214330.3885211-1-neilb@ownmail.net>,
 <20260312193847.28c32a2c@gandalf.local.home>
Date: Fri, 13 Mar 2026 11:18:47 +1100
Message-id: <177336112755.5556.2850267364383380917@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>
X-Stat-Signature: 3wx7hrrncx7caute5khpk78nt19gytkt
X-Rspam-User: 
X-Rspamd-Queue-Id: AF511160002
X-Rspamd-Server: rspam12
X-HE-Tag: 1773361146-589347
X-HE-Meta: U2FsdGVkX18VNB3LeqV/4nd0sBZ8AK6r5KOxxlN0Qalt6x6UvCyvI7gan3cAQATcNcAzZ7hgka4Jj3tWu8DbXTckP30Msj7OqvrAKV7mx9lomlnu5f9A+0s41yEhtMB+2bbeb2vlrtjs+BK+/L9TlhuKV4UdrXv01q+oSmuMcwIWhe0SMuRy0ZUZOoUI2S3QtU9D5LU8vtUQtk8c8wL3oI+uDRGo1wD7qcliXtJyCtGoX3196jcRtfz0dj5wxK2MWCHoleBC5714ynQvEookX7eWLdAEmTdEbkJgyZx570cbS8WpPA64nYHpWgmrDaglAMNWhONk30TP0tO8npEMetulq4/2KgqumN7j22m6+WoXnBam6/E1tfO0WtYSiWsenFpiSmEsEFJRGdAyaiQPZPn12m1oTmVE0oKUEFNHo95k//z8n/2+oeAoYgiN1pkcVSOBTLr1h7P48+hqZEmfkXkrlyPGpXM4IHVTO3XkW8dlRzJXli6FOHgXuK8OIhEDbxKKgPuhmVyvOKd0J/q8GFqnMBGErpGh4mIfEjKO/nIovOVaxRUc70xKXAHdJ3oDs1zRLkSK9BJ2Ihr1ybqkAR6qth+S54FntlZDoKPIBOxoqPW0qUel65YY1DaqWjswWbhf34SBY6vIvuMTouP3MshHReVEYy9LwY1T+bZe4ZScDzcCS8akIYfa3GGLJu6aTOsqsERvkPyd/E+BF53+cjW4zi3B0Xg+bfEQXwAHgEwScyOZJ7IzwkYMbRwn5bU5MwbTTmPXDq8U9aNH2TGBQIM5aqGWLyoyNNbPPS7Fo/mAqBpqNbwbXlvS+CBuf9mSbOMKt5ZPznnry3+fepLf1kBHUjOxJVDtxHDEuuUli0lmHAGoB3z/RUJ9/Wr9YcjFQx0lqMxDbOg9/GKfiq5+zHmcsHT+RkLFGxKwe1MPYT6qHSZ5ZD2ilNLZ1xWYiM0bXZFXJPPIgCmteD0fHXx
 QCukP9kp
 U2M3BnW+IOLF+n+2mp57pljxHTPdlyLnruU/LbD88XrtOVUNZzgsSSiZxFSeC0x2302oYwZh0QafmOd0a6nMtgT1pkDvXwJ/us4FszZfzzBdZbOCFFEMgD2yBSlf8o0nYhQUbJXq+L3078vMZhiklpgih5XG4R18i9DTHjUYycx4x4JkrjvcnTsDv0+62Ac75V9V2jzlp93MPlYlg8LC63MCF+ZHqz5aabeOA5U2N3w+v7qrHearEI+9tj6SmXDtQ8bQDwoHbH46Sxdwa6L0o2LvNUyfakUUg4jNJoBZQeg3u2a8IePJcPajPk0jYTqKNYq6grF0FErDzpF633O12vr+vFcL937D3u/lSCXCri3LLuMawNPTX3l+Wtctd/iZynU0Hduk8DLc0WLNHZ80zyZG+PqJvLgWkcQRC9yBAMZ8nkO25i7GIEtBQLbFo/0/fLFpVt9hMZIGbSkCjsMUDJ4MjQGwVoMq5z4F6PqyINBYzmm72QpdnFSkvSqUfCORPfTsZ1oPS/d7vGqMuXnvDGhwpySYaHGNvoY4bdw569P/BfaWfoOPjUpKhAv6qzNpj71e903hmJAKekejam3u6h8M8VccWHlZpo5ONVjTOu90j1PRpF5DQ0QzGJtx0Uw/RJAC+QH9ELh01k9Uxc58Foi2tdqLcPdS2HInEzwfBg4B+99f3sroikh5s2WQLH049gXWuUM6Nl+94xUcxk8MGY0Luzg8YYtuIdjF3mSIF3G83e1vmIiDty+sC1zTiv4ofFKpZuRb1ykH4MXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026, Steven Rostedt wrote:
> On Fri, 13 Mar 2026 08:11:47 +1100
> NeilBrown <neilb@ownmail.net> wrote:
>=20
> > *[PATCH 26/53] smb/client: don't unhashed and rehash to prevent new
> > *[PATCH 27/53] smb/client: use d_splice_alias() in atomic_open
> >  [PATCH 28/53] smb/client: Use d_alloc_noblock() in
> > *[PATCH 29/53] exfat: simplify exfat_lookup()
> > *[PATCH 30/53] configfs: remove d_add() calls before
> >  [PATCH 31/53] configfs: stop using d_add().
> > *[PATCH 32/53] ext4: move dcache modifying code out of __ext4_link()
> > *[PATCH 33/53] ext4: use on-stack dentries in
>=20
> >  [PATCH 34/53] tracefs: stop using d_add().
>=20
> Hmm, another reason I hate being Cc'd on every patch of a patch bomb where
> I only need to look at one (and maybe the first) patch.

I could try to refine my tooling, but you can't please all the people
all the time...  I wonder how many people would be bothered if only the
cover-letter was sent to everyone, and the patches only went to lkml -
to be fetched from lore if not subscribed.

You would probably need to look at 02/53

https://github.com/neilbrown/linux/commit/aebdc6545eb18e5b6a7d41320f30d752996=
b3c6c

to have the context to understand 34/53

>=20
> For some reason, I'm missing several patches, and this is one of them :-p

They don't seem to have made it to lore.kernel.org either.  Maybe I'm
being rate-limited somewhere.

https://github.com/neilbrown/linux/commit/77074c04a94176d6b2b2caf44dd84f0788a=
420c4

Thanks,
NeilBrown

>=20
> -- Steve
>=20
>=20
> >  [PATCH 35/53] cephfs: stop using d_add().
> > *[PATCH 36/53] cephfs: remove d_alloc from CEPH_MDS_OP_LOOKUPNAME
> >  [PATCH 37/53] cephfs: Use d_alloc_noblock() in
> >  [PATCH 38/53] cephfs: Don't d_drop() before d_splice_alias()
> >  [PATCH 39/53] ecryptfs: stop using d_add().
> >  [PATCH 40/53] gfs2: stop using d_add().
>=20


