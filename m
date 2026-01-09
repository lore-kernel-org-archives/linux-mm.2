Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 438CED232EF
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 08:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1069E6B0088; Fri,  9 Jan 2026 03:48:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A516B0089; Fri,  9 Jan 2026 03:48:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE7D6B008A; Fri,  9 Jan 2026 03:48:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D57256B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 03:48:51 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73A0A13AD34
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:48:51 +0000 (UTC)
X-FDA: 84311800062.25.4CB503A
Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	by imf16.hostedemail.com (Postfix) with ESMTP id 39EAD180003
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:48:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767948529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hi6ZwA10nQeVVLVHSSKeYbeNuIjA/FZtJQ9gk2yneq8=;
	b=VrrfW8k4YsGjJvVY0IDoiqWXRB/eeqOnMHDQLdBa6ijy1j426nNPdWDLDiQOi9PprJAxXE
	Moj63R7lWO+gZUKu0eUW4t+NzcKIkLi7k9no0MUURV2brMUTD+UON8xtZJ+hV8Uc/aDGrC
	ENLCUkGWCRGD563wnRVSt9Io0FnELBI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767948529; a=rsa-sha256;
	cv=none;
	b=z/h98ceeZqWIdkdnCAlLqVmOb1cJOlp0NyJa+mJB8DlvhWgyRqhW15WDSE1sWxBkEhhm4S
	DNPJGUFxy+1SnRtAE/u+Nw0UcSACZGON4giZYRj6Qi4y+UNJsK+qwctzHxzFnzoebuNG4P
	WVp2OSdg43RnPkHFGU/fu12gTdzBSC8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at;
	dmarc=none
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id A047A29ABD6;
	Fri,  9 Jan 2026 09:48:46 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id PY1yWc1jnPcz; Fri,  9 Jan 2026 09:48:46 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id E0C0628F9E9;
	Fri,  9 Jan 2026 09:48:45 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id BZO6SamqYTTM; Fri,  9 Jan 2026 09:48:45 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id 30C7B29859D;
	Fri,  9 Jan 2026 09:48:45 +0100 (CET)
Date: Fri, 9 Jan 2026 09:48:45 +0100 (CET)
From: Richard Weinberger <richard@nod.at>
To: Jeff Layton <jlayton@kernel.org>
Cc: Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Nicolas Pitre <nico@fluxnic.net>, 
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, 
	Anders Larsen <al@alarsen.net>, Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, 
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Jan Kara <jack@suse.com>, tytso <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	David Woodhouse <dwmw2@infradead.org>, 
	Dave Kleikamp <shaggy@kernel.org>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, 
	Carlos Maiolino <cem@kernel.org>, hughd <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, 
	chuck lever <chuck.lever@oracle.com>, 
	Alexander Aring <alex.aring@gmail.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, 
	Matthew Wilcox <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Trond Myklebust <trondmy@kernel.org>, anna <anna@kernel.org>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, 
	Hans de Goede <hansg@kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-btrfs <linux-btrfs@vger.kernel.org>, 
	linux-erofs <linux-erofs@lists.ozlabs.org>, 
	linux-ext4 <linux-ext4@vger.kernel.org>, 
	linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>, 
	linux-mtd <linux-mtd@lists.infradead.org>, 
	jfs-discussion <jfs-discussion@lists.sourceforge.net>, 
	linux-nilfs <linux-nilfs@vger.kernel.org>, 
	ntfs3 <ntfs3@lists.linux.dev>, 
	ocfs2-devel <ocfs2-devel@lists.linux.dev>, 
	devel <devel@lists.orangefs.org>, 
	linux-unionfs <linux-unionfs@vger.kernel.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	gfs2 <gfs2@lists.linux.dev>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>, 
	v9fs <v9fs@lists.linux.dev>, ceph-devel <ceph-devel@vger.kernel.org>, 
	linux-nfs <linux-nfs@vger.kernel.org>, 
	linux-cifs <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Message-ID: <393733638.88534.1767948525135.JavaMail.zimbra@nod.at>
In-Reply-To: <218403128.88322.1767944438487.JavaMail.zimbra@nod.at>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org> <20260108-setlease-6-20-v1-12-ea4dec9b67fa@kernel.org> <218403128.88322.1767944438487.JavaMail.zimbra@nod.at>
Subject: Re: [PATCH 12/24] jfs: add setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF146 (Linux)/8.8.12_GA_3809)
Thread-Topic: add setlease file operation
Thread-Index: Ijb4veyM6wDb0tIeqxd8skdz5qkIYBNsmijj
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 39EAD180003
X-Rspam-User: 
X-Stat-Signature: mfham4rz7b6qssq58jo4qzugkixcfwgj
X-HE-Tag: 1767948529-899036
X-HE-Meta: U2FsdGVkX1/BtHSiAvDOHSxFQO95ePmp1tRJrBOAdqLhOh0iXJMXzZaupM6iyCmquxksJapJacTO7Puz/YeapOMu95oLPAnsbvFdUBR+mDTTuW9a03y5EIcjrn30tA431x9AWvnmPAreIZ7UQiazGqbdOJaaIYUSeDCcDXmSt3OEGdHcukQVEGwwxf8zwokxNW4YIvpz7A+QLBl4JUo02Pw0pTpESColWDMYRGDX3p35YDHWmglQL7n1x1L6+by17LAbQV1qh5ZjfSZt0xzobMpgMsCkl/+8sncgkcRFG8Jno0u6i2vOAkmXnwdlf7YIObPNBAHAoXHF5yFbr8fuMwV6VBX9Mt/a0KIek0utnNn0PEPb08Zyd4MXboahgPmA04ggoA7YpHy1vENmAq6H8560Vxpj5VBLlEYvyrI0QpYBJgJxbPQ6E+uLeMIf8stDz90zO8bYhNPbpA7C6EJ3JryEpE+1UPiwTzIqGvNhgUZDpUoQYwBiyw6rFuwH0fOm/QbUICol9/SflLU6/m1MnAJz15g0vLmt4JNgWI6p2iTuNWdgn9p6rfLCvO0dwXfUv/6j6qvJXr2BUqqELGXpbM3Rig//BvgGJ4C6TlmNm7cvzl+z7mAjgPkYwlC1hTLlzkGAh55bNoDw0AcE5rDFZmUkjALzUHHWY/Zdt5dvqqsS5UWsgRp+fMzT8Eg6XWoBLQHDVqF1VZ63ybyWncc0mpnH5M4OUXjkjttXatf4jkTraZO9Ubai6kjLNG/gy6K27K7T18MPKANdDx9NMBAJHzQfKWX+Fq8ccRJwPKaj6PdfFavicCdvPWdgHk7TX/nKhKJwQgVaO7cud4HjvO6cV+/Wf+Pc9Hz8mp7jkxqV1egRtMf0rpjH12G3816biLNWPrAeLwh0Cge9pLfpF//qZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

----- Urspr=C3=BCngliche Mail -----
> Von: "richard" <richard@nod.at>
>> ---
>> fs/jfs/file.c  | 2 ++
>> fs/jfs/namei.c | 2 ++
>> 2 files changed, 4 insertions(+)
>=20
> Acked-by: Richard Weinberger <richard@nod.at>

Whoops! I meant to reply to the jffs2 patch...

Thanks,
//richard

