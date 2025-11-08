Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75A1ACCFA18
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 09:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1FCC8E0006; Sat,  8 Nov 2025 04:19:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD0468E0003; Sat,  8 Nov 2025 04:19:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 997DD8E0006; Sat,  8 Nov 2025 04:19:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 766FD8E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 04:19:40 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0897F895BD
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 09:19:40 +0000 (UTC)
X-FDA: 84086892120.02.C013ACE
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id 446F7A0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 09:19:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JSvMtvjf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762593578; a=rsa-sha256;
	cv=none;
	b=DRP1v0msD/SxVvPk9y5wPsJU/rENgkrXpdWCD2yjPTYQQbhaK5CnXT96M2VnbSHqQ8USdC
	nglcx5MjrmRq4kIL1H8j4fPc7J0FMtkUqk+7Ody95h4KhajGvFuzBkjyGla1rh4sZI9TX/
	043ebqTylzrYGv5Y8hp96Op+8iAOLT4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JSvMtvjf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762593578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xMJJSbsWQXZcDWYlPD+q/sMKmcoPg7XO2KNCJJBRcPk=;
	b=EaAEBsBsWC3x1BkTSlLXB1uF9SmJQzJgUm7vJ+JgI8+q7nTTEY/vRtYUFjg3RkZmSp5lnb
	6ZD7TKiVyq8KXtXZRClznA+2zXP7OVeXp9IBtPGsShN3MF3dH12yY0v3iHhO17I7u/Zb9s
	DRZTBytrIYVsCCF+VcHbXCv4EhdWcPI=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7aa9be9f03aso1351304b3a.2
        for <linux-mm@kvack.org>; Sat, 08 Nov 2025 01:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762593577; x=1763198377; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xMJJSbsWQXZcDWYlPD+q/sMKmcoPg7XO2KNCJJBRcPk=;
        b=JSvMtvjf1RYHo7Y+zqebHUY8a9UUS4kKucEwZlG1rP052dbPkyxJ2D3xlvs0pgqYbW
         q9dXkLKmUF3t/s+R6L0/E7YaIVgyw1Qe+zIYGIfbpfEadj4CvwtiRk7Vru/497QmviBB
         l8od3tR24kFuYk8TDsAw59bncKJUelD4iET3XGJ3fZ5nDUUBGmNcwABoRzcPg0L7AxZS
         ucTNj8wBUveijLC7CcrDsbq3+dvok6vxGkPPobLLuYmD3AtpDChftdRuckBIWESGu7Di
         cW1mI4ikf7fdEjM0gHGsDP7IYm+oGi88V6LxD9QITuuW/m5CfABpKWSuhU/4Vt2hc+IQ
         lATw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762593577; x=1763198377;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xMJJSbsWQXZcDWYlPD+q/sMKmcoPg7XO2KNCJJBRcPk=;
        b=bqK9SV2UuZVyBEMvmS4l8qdYduLUZZUQBl3R/t5UFnSFg8VQjNZIGAZZuI1dQgM3GO
         /qiYhQL0tWmAL9KeeCumtM9d2yZabJnhcj6sEu7oaYMa6MPwwJgjckEzlYYqdTQaq52f
         rUbvj/0BJWE9J/f6PH5DkIYuhJRWkLiQNIs+bFeILMn0D0T1cXxUHklNIy5pV+6p5yZ3
         O5JqIQhX2uMtXSwIxfapXyQ6BOuwNnddiXj0Xp9acDkrK08NX+sbAmg3muFKT20ZizZL
         ysYUeTNdU44RgLLEc6H2R7ulwD22M42XOOngCTh8KhSLYIAjkMEJQPqYmfjN4dQirbCb
         I7Ow==
X-Forwarded-Encrypted: i=1; AJvYcCXR9mIpSIxlXfid4JWfLjPEA/Z6UpyKN3DPVhROUOPZovPkC+7qskb6u+heeV6TErktpnaJ8PRbmA==@kvack.org
X-Gm-Message-State: AOJu0Ywaawke1JrUIX3zmKUMGmQGzpIepafw9IwL3UtNMEXILr+1XUkd
	QF9MbGMR9oG6sTN/kbntV1bWoFLX/iYN3fgA9pbUPtlPwl0zwOfhUEzw
X-Gm-Gg: ASbGncu6iODVAu6o8zYcFSQuTJxyNT1AlAwOFv/1FRSc09d8eXBe/VOATtss7L9g/Hu
	Fg9KhG196NpJ+OR34VLIh1joCq0CDjTDjCMUvwd1ikWF4IIwdjf7zFlVWm4F/a5/134vATPUAJw
	afx6nJBl+2fe16V0LAVWj4ufB5Z8MJPVPlchl/2/VEooX/rwl6J2HGKnJoefbFLxQ29WOgH3RpU
	eJEuGCDjrlDkhWPX3jE/h+rotNH/3ZwwfftDRl0poWrLe7qi4YYeNGmTk2yfkR4eMxkuyUr06KF
	BfcCLTMHBzkFHm5nNP8C2ywnBwk6ORlfji14ocmbmKQ13MMPfhjPwbY5ZaGsJheZdwtMuBk+Urw
	vlC+wPYi0fshUWBgtKG3JtpmCEo46ir+AGmPrUfuToiTTYnIO26dZCNsooPlSp6t/5P0UuRAtxQ
	V5
X-Google-Smtp-Source: AGHT+IF0YP4Otkbzly3RQbSixJdpmmdp1zu3glQ2poSUDNCvD7oGyUzRXByQOYxnN497yc+CfkoJmg==
X-Received: by 2002:a05:6a00:a8d:b0:7ac:69cd:ea0d with SMTP id d2e1a72fcca58-7b226f8dd18mr2391831b3a.19.1762593576763;
        Sat, 08 Nov 2025 01:19:36 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0c953cf79sm5483323b3a.3.2025.11.08.01.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 01:19:35 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 77412400200B; Sat, 08 Nov 2025 16:19:33 +0700 (WIB)
Date: Sat, 8 Nov 2025 16:19:33 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Dominique Martinet <asmadeus@codewreck.org>,
	Jeff Layton <jlayton@kernel.org>
Cc: Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	David Sterba <dsterba@suse.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	Chris Mason <clm@fb.com>, Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>, Jan Harkes <jaharkes@cs.cmu.edu>,
	coda@cs.cmu.edu, Tyler Hicks <code@tyhicks.com>,
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>, Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Dave Kleikamp <shaggy@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Bob Copeland <me@bobcopeland.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Hans de Goede <hansg@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	NeilBrown <neilb@ownmail.net>, linux-kernel@vger.kernel.org,
	v9fs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu,
	ecryptfs@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	gfs2@lists.linux.dev, linux-um@lists.infradead.org,
	linux-mm@kvack.org, linux-mtd@lists.infradead.org,
	jfs-discussion@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
	ocfs2-devel@lists.linux.dev,
	linux-karma-devel@lists.sourceforge.net, devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] vfs: remove the excl argument from the ->create()
 inode_operation
Message-ID: <aQ8LJfKC0R-4ehLU@archie.me>
References: <20251107-create-excl-v2-1-f678165d7f3f@kernel.org>
 <aQ7fOmknHIxcxuha@codewreck.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hTQgJTXrd9+JcPiP"
Content-Disposition: inline
In-Reply-To: <aQ7fOmknHIxcxuha@codewreck.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 446F7A0003
X-Stat-Signature: jxjex9qzi97jaco57hno3uacox8uxqnm
X-HE-Tag: 1762593578-154001
X-HE-Meta: U2FsdGVkX18nL5LAJoV0+0OSmfMuA9JKN5Q7+u+9rZ/Q7bJHYmGxEW9gLfzqLSCuKpxR526UyunL/gtw60wwAZnR0DSY6XNcZIZWy7FQofXdNsgKmDBur9u4oAUPZS3FsrCMl0cP15qwDa2+1syPayF4ILNPpf7rpAj/kR4GFDHZFnwRgK0ClYMh3UCiVx18rHf1te/pAFUx0dvIj1rfiEFFBXUU4WdERGMxlaRr/b4MEjA4B66gBmWiO+/X1DVdYkTmXm6XEDFz0z83ltcv9WEC0qTvvBed6nqOy1/78CY6kXi2T8WObO/3DrOcvoRe3mx5scT36StdslWaSFI7Spa7737EgpsrfiAypunKHin62bIz6rZn4sDte/x1tgSxeqRpifDyMqrbU2mEV4vaftU3Q8jLhvR7g02goVbVLOWciezMmb/b2mBUezCD1pAEhbKfwVDpK8e3hdJ9kHPJfaTK5Ag3grSOR8H0VMeYOYB4bLlFswQW13WoT/3vArdO+ljnndk/VpZ2EvVQHKv8pFEtzFWF3kEFUo1bLpoiq3x0WN3qSqhJbrHi95jSJOdiS1d+yA66DgWoxyM1wh6ChO3h2B2fgr2Ew33o4VhRT8nO25OAxLramxAxn9IZq38ud1ArPCTYdZclkavNh30AV8rSVwuoj/kHTtjjVBmlvCh6MuPI8OtmsF6oyoydrSJWCGfCIOt+l5M7BaTrSd+CxjkUYw06EifjeRxdI83Il+TmpWFDsMGtyLInANpWObDqztZ0uNpnc+aPQptmEGh0TOHDJ2ZeRMqnMeIJA1gclhDR4Dfjnf0rsu2r/CeYMjxEEedGxABItXLNqvHaCabW1KBYOWE1sCFCVvVhgIi+rDlWuonDtQnPHYQrIkk2cQ5PrPUCkvxwpl+VyT/ziLVSXQo6RubdjJCI79UbNuUPr0a2aibHu2wOvoQkOZzHD+F6szFOPVUZ0fd8VPQkgoe
 EleHsKxr
 VcOsbHzyVWKfp/zrRVEp+WlaHh1+efDIXO2XlZ4qeztku3zEa+p750O/T1cew3kTfKwXcB0N2LcTUQWH8mLumdGls+GwYDcq5KLwfOVByRNqhIeIkvH5oQDpPRBPOQBVBhgcdbroY67dgL1jUYKQyJePWJHWtA7LLM6HoIuBgcjHhdjJGR92V1EGnoVUADZQ1N6Oj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--hTQgJTXrd9+JcPiP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 08, 2025 at 03:12:10PM +0900, Dominique Martinet wrote:
> Jeff Layton wrote on Fri, Nov 07, 2025 at 10:05:03AM -0500:
> > diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesyst=
ems/vfs.rst
> > index 4f13b01e42eb5e2ad9d60cbbce7e47d09ad831e6..7a55e491e0c87a0d18909bd=
181754d6d68318059 100644
> > --- a/Documentation/filesystems/vfs.rst
> > +++ b/Documentation/filesystems/vfs.rst
> > @@ -505,7 +505,10 @@ otherwise noted.
> >  	if you want to support regular files.  The dentry you get should
> >  	not have an inode (i.e. it should be a negative dentry).  Here
> >  	you will probably call d_instantiate() with the dentry and the
> > -	newly created inode
> > +        newly created inode. This operation should always provide O_EX=
CL
>=20
> This and the block below change halfway from tab (old text) to spaces
> (your patch)
>=20
> Looks like the file has a few space-indented sections though so it won't
> be the first if that goes in as is, the html-rendering doesn't seem to
> care :)

FYI: I'm using Vim. My important settings (in ~/.vimrc) are:

```
set nojoinspaces
set textwidth=3D0
set backspace=3D2
```

However, ftplugin override these for each file type, so you have to essenti=
ally
"fork" the relevant ftplugin file for each type if you want for your settin=
gs
to take precedence. For example, in case of reST, copy
/usr/share/vim/vim91/ftplugin/rst.vim to ~/.vim/ftplugin/rst and override t=
he
already defined options there:

```
=2E..
" keep tabs as-is
setlocal comments=3Dfb:.. commentstring=3D..\ %s noexpandtab
=2E..
if exists("g:rst_style") && g:rst_style !=3D 0
    setlocal noexpandtab shiftwidth=3D8 softtabstop=3D0 tabstop=3D8
endif
=2E..
```

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--hTQgJTXrd9+JcPiP
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaQ8LHwAKCRD2uYlJVVFO
o2WVAPsFBRuUsYfWxAnWROgP/61sBqVYDc/UsPimcXm5dJJfgQD9ESTXpfxlpefS
VKeWBneX6svZYShHE5RzrbcYO+G5GA0=
=gW2v
-----END PGP SIGNATURE-----

--hTQgJTXrd9+JcPiP--

