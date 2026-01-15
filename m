Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8C8FD46606
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDD6D6B00D3; Thu, 15 Jan 2026 13:32:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF066B00D6; Thu, 15 Jan 2026 13:32:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBF716B00D8; Thu, 15 Jan 2026 13:32:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B89EE6B00D3
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:32:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90D3E13AC21
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:32:31 +0000 (UTC)
X-FDA: 84335043702.26.459E8C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 82DF24000A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:32:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JNemC1yy;
	spf=pass (imf04.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768501949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mu/jwyuzs1woV3EsPbDGdDC5dwANFYIHrH4NaGlTLGQ=;
	b=5MWzLg0bukeuM22SRiT2ns1dA8bCeSXOCjMN0zYPLKW8NymhCVrd/RE40yYB6sCeZj64ZT
	aSVqy8iADFNiiq6qUSkaejIzWZegmEO4y3wmIj5xNv5LTWvW7bi2SLfOchnD9YKYy+5R4l
	/azPOPmm0JlajsSU3xVAv8lZBCzNdzE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768501949; a=rsa-sha256;
	cv=none;
	b=gTKlAIX4psbHSmI0RoNsdOKB/X+RncBW2t5qbdqZ/2VUtfC/gQ2O12pWWkoWI4yOy/oxXY
	mY/DAvJ4b4ycH4GxxELzUJRwTgFVESoajL5TW5P8VV3C+sRSMYfekPkD0f1xiyzPhz4BDn
	FKjSvlS+lOWoWAx0VETJHL3V/0wuv7g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JNemC1yy;
	spf=pass (imf04.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 454DC4451E;
	Thu, 15 Jan 2026 18:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A66C2BC87;
	Thu, 15 Jan 2026 18:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768501948;
	bh=mu/jwyuzs1woV3EsPbDGdDC5dwANFYIHrH4NaGlTLGQ=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=JNemC1yyTQKx5E4pIkzvytUyGES2tmVjzNLWcONSrxdEfLh3HlZ+29IPzV++/rV8O
	 /HufzuRETrrLBI4IgK1mEivYdYvao6frYVSEUn2AXXy3guy4u8MrpbYCuAu8C1ruaK
	 BwomDAPfPK9evxM9sjnY973CQhs3rFOvwwrsPWD1GN0t9LaV4/M6zqIS22ZYwvDiXt
	 7eIxB9z5Cz2MzTOm3tABDloqGJc8wnEFa7XSr1cniiaRjwx+2QKA2jRZ2Mj8DV7eWp
	 x1iKOENqOdKyNjx+zUz63w8fofWQL/VEVXD5wSR9ScT7i3QHOaACZWezQRR4LuAx+z
	 TU3CqTeesgqIQ==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4BF17F40069;
	Thu, 15 Jan 2026 13:32:25 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Thu, 15 Jan 2026 13:32:25 -0500
X-ME-Sender: <xms:uTJpaST2S_BQmvIoVXUTG3Uv00CIkT_f-EbDQ1KH8vIlVQcwDXypQQ>
    <xme:uTJpaSn5OoyclbrYS_ARTUh6TEP2VOjUGj53_LG2lxkjeVICq65KK1J-vKaQ4Q1LV
    V04RbrQdCpqL5Mvp67L_2A99E7e0MjEKZHGQg6du4B2aAO0ZSdxuww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeijeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedfvehhuhgt
    khcunfgvvhgvrhdfuceotggvlheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeegheduieeiveevheelheelueeghffhtddtheelhfdutddtheeileetkeelvedtjeen
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomheptghhuhgtkhhlvghvvghrodhmvghsmhhtphgruhht
    hhhpvghrshhonhgrlhhithihqdduieefgeelleelheelqdefvdelkeeggedvfedqtggvlh
    eppehkvghrnhgvlhdrohhrghesfhgrshhtmhgrihhlrdgtohhmpdhnsggprhgtphhtthho
    peehtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepnhgvihhlsegsrhhofihnrd
    hnrghmvgdprhgtphhtthhopegrughilhhgvghrrdhkvghrnhgvlhesughilhhgvghrrdgt
    rgdprhgtphhtthhopehslhgrvhgrseguuhgsvgihkhhordgtohhmpdhrtghpthhtohepjh
    hlsggvtgesvghvihhlphhlrghnrdhorhhgpdhrtghpthhtohepmhgrrhhksehfrghshhgv
    hhdrtghomhdprhgtphhtthhopegtlhhmsehfsgdrtghomhdprhgtphhtthhopegrmhhirh
    ejfehilhesghhmrghilhdrtghomhdprhgtphhtthhopehiughrhihomhhovhesghhmrghi
    lhdrtghomhdprhgtphhtthhopehkohhnihhshhhirdhrhihushhukhgvsehgmhgrihhlrd
    gtohhm
X-ME-Proxy: <xmx:uTJpaX8XlASeI3-hQVJmMxlK8TxdmBSwTtFsbhSoxL3UV4Wvip7VrA>
    <xmx:uTJpaZqkkN3176e2LvdCG3veTiN-GTqcScuGt9t_e1DrtMHWJT3eyA>
    <xmx:uTJpaet8tZs4QdmQ9KbY-CWNsY3QfKFOvT9QPuO68BSRBM5oq_7Zeg>
    <xmx:uTJpaUR2QUA-L1hS5UnoJ8HhY1Uu2p18HC8n7POL1S450zS9m_Kiew>
    <xmx:uTJpaYWzGNFQ6fy0VRVsd1um1FRTenoVzHGzsRuwWHvuFBVbXXDnMbke>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 155C8780070; Thu, 15 Jan 2026 13:32:25 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A7-j_yKLHrMN
Date: Thu, 15 Jan 2026 13:31:54 -0500
From: "Chuck Lever" <cel@kernel.org>
To: "Amir Goldstein" <amir73il@gmail.com>, "Jeff Layton" <jlayton@kernel.org>
Cc: "Christian Brauner" <brauner@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Chuck Lever" <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
 "Olga Kornievskaia" <okorniev@redhat.com>,
 "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>,
 "Hugh Dickins" <hughd@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Theodore Tso" <tytso@mit.edu>,
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
Message-Id: <d486fdb8-686c-4426-9fac-49b7dbc28765@app.fastmail.com>
In-Reply-To: 
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to nfsd export
 support
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 82DF24000A
X-Rspam-User: 
X-Stat-Signature: haw43qk7css7fkqg9pzt9gsk13wmi3jw
X-HE-Tag: 1768501949-485330
X-HE-Meta: U2FsdGVkX1+e6iC4ZXCEWyG1ip4WW292f6k62DZr9x6XvCLjqzdK6A0aa9TNJsWjWPjzi3KuCr9N8i+GyXelemBhbPe9XJEqKjl61DzVoF1AexY4h4J/AYjo/8unY8Yrr1uMOOxHOnc5iIA/Wgfvvw2rn1O/pyXwOhGbdVtm9AOr0aGiYD3l9EWCqC5g7TBSD1Q8tmJP+m3K2PuBxONgkKi+GzrR9OtiBb7SsWcBpsnRJUcSuJZm2w1j65Q14wYuQbvW/AJuzzwxz8N1b4Ur8tkqRgU1UQ2bNgNKb5i3PhN1KD0h3xyf0ncVj9f0yclwZmr7uIU9AkOZPKCHEmfYRTm9kVk+NDvu/3xQWNW/yEPL3yQnfgxIr5j0ngECErFdvTUBOQoqwCyuRtl485Rqp90BORz7LgwmckLy4VEBX/m1gm8DiRZ5Sz9pYZMURkpe/ksPPrA5GZU4PMa7k1aGWXllVaym8qNyi/lAJt27o5NxKD0OIYgi3N5/Pz6J2hxpXx/2nN2yk/djiXBN4MDDHhgqZhDpfZdUsIyOxRNin8QVF7MIsIwx3y+R81kN4jrXrO40LA4v+dw4wPxgdzZqScQ54HyyGg8puO8lRKK4+j9XuYQfBp2asX1Sl1M6OzKzNCwviZvas5Ld2VNI6x8b8tmWkg/rOYwr1ugKGXd6p57jkQsLHx6CSdrWKJ1YolksGT2H4Cd6GbKFLN+DLAi5yT8SSVVFzfs1quGvdIyTwoibllhKEsRwKkiIpLstn+fYAb5oRarivN1mEW04iUDmXV2gAbevFlDh82m12VHbe3PMV6HXO5gPIpK7jgyoFnpF6Jhx6H4Xri32t/j4V2Veb0EeFg2gXg1/Mi1+7Z5lO2DJSmOMMX0zQ0ZunEdnrfYDR/ipW3/V1CFHbC7zFQSmfDb2mfLk4l3I1c6xZwVI161y+u23DQpZ9QgGx7uNE0Pg8ecrqbwrbgduxE5KTxT
 rz7/BH5n
 CkU+atOpvmT51XhNA8Z3WKFHTXAMINQ76VnWTnMc7VF/IFYDB2HDAqGQIM66dBFjpHOHWgVDDarlJbHX6VNQc6H++ENHqV2MLzzOVM0ZM31sJ3bt/DMAFy1i0bN/sk18IEsyfiZlhxSAQs+vDmuz0ulhyWwxGXIHIF+EZA781csryPQ4s23jB+zHS9H3jfs7G5Y3rKUapdZsFWqJwTDv5f8jUo0YTFFjtK4mzHuMxwG9kyEM+5FxCTG5XOxCK6lgc+UYMgujRJezz5t3N7DogABb57IL8PU8AYiQEVNUlBka4L556b62ljBSgrJ14EGVqqKL748xKfhy6n1/hvOwX3rE14g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Thu, Jan 15, 2026, at 1:17 PM, Amir Goldstein wrote:
> On Thu, Jan 15, 2026 at 6:48=E2=80=AFPM Jeff Layton <jlayton@kernel.or=
g> wrote:
>>
>> In recent years, a number of filesystems that can't present stable
>> filehandles have grown struct export_operations. They've mostly done
>> this for local use-cases (enabling open_by_handle_at() and the like).
>> Unfortunately, having export_operations is generally sufficient to ma=
ke
>> a filesystem be considered exportable via nfsd, but that requires that
>> the server present stable filehandles.
>
> Where does the term "stable file handles" come from? and what does it =
mean?
> Why not "persistent handles", which is described in NFS and SMB specs?
>
> Not to mention that EXPORT_OP_PERSISTENT_HANDLES was Acked
> by both Christoph and Christian:
>
> https://lore.kernel.org/linux-fsdevel/20260115-rundgang-leihgabe-12018=
e93c00c@brauner/
>
> Am I missing anything?

PERSISTENT generally implies that the file handle is saved on
persistent storage. This is not true of tmpfs.

The use of "stable" means that the file handle is stable for
the life of the file. This /is/ true of tmpfs.

--=20
Chuck Lever

