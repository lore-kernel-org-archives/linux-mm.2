Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5DA6D232C1
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 22:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D73126B0089; Thu,  8 Jan 2026 17:47:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6766B008A; Thu,  8 Jan 2026 17:47:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCEB56B0092; Thu,  8 Jan 2026 17:47:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A907F6B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:47:27 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1EEA81A02E0
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 22:47:27 +0000 (UTC)
X-FDA: 84310284534.27.D8D6CCF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 373D6180009
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 22:47:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kNZ/y6ld";
	spf=pass (imf06.hostedemail.com: domain of linkinjeon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linkinjeon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767912445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o8ABr/DNoRVjWLpEG3gYzt78FrDlsrlJ7hUxCqSBKIw=;
	b=MNE9NB+FxItVa1j5j9/C2vzlGE7U1e5L7x0oP6gXF3nsjf6Zm+jWZpaa68RGadCqQXAHeA
	iGMMVMJOl4rvST34wCqlZZzvQ7y3XTNcPxvog8z5jixfTI6FeaGJrtIBicQGx/LMUSgZkI
	oYXY0Q0TzIWgubM0fVoZ+BDYZPsEPio=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kNZ/y6ld";
	spf=pass (imf06.hostedemail.com: domain of linkinjeon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linkinjeon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767912445; a=rsa-sha256;
	cv=none;
	b=v8KZre/ZMYy5MFxW94c3deuuE70CnrS2oU6IET126wpJaUc5STWNP1EYpp8DlwsafxKBck
	xi2zOqLBHYGJdCMLIhQjvthE5HAR+BYHK3WNfcorhvh7tMIHCTpLlKumvQHIDln+VCv2AG
	9SFlHOGKOuMPDLYEOxiIKSPdEqV/0Kc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 81E0360161
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 22:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C4EC2BC86
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 22:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767912444;
	bh=bpLucB2OVlqnpdSgR5fVsT/9lEifzVxq4+Kg3z371KE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kNZ/y6ld9T/Ac6XqHUpuWQ8PCKoHqDZK4KRIN0fR0qhZUAZgmdbhls/DOYhiAGX7z
	 lKJXMbj5kAIa3yPHcJzWdDqHLZWZUws36K4s8WUtTHBy0kZ1G+0Jbjoh7BgoGMTVB0
	 EHN+7t2qxXK5Wg9JwteHTuHVEx86cGwPSYmACkxAaR6cPMp9ZisNCP6MINj41SffBs
	 rGpQYrIDRH61Pi646aQVZ+ZmxyNbNF5rChS8TKq0svn+ns7GoUEV1FIGJpWNhiL7jz
	 wNVHZ83G97Pf5PZFUJN8TAkCmyWsi/CmvHe4Mf70Y4ziokGk5SSSZrPhqGGZMeQCS4
	 YWE8KQUzoe6Nw==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b8018eba13cso609730066b.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 14:47:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVAcQ+lFhuvQPY2TN0BSBwx5FQ4iysdk3r2FVtD5SM3ViUAYx7Qb8dvpus4ZAxkPffgVGzeTpQm9w==@kvack.org
X-Gm-Message-State: AOJu0YwmmdYF+YEq77fg+t0sfXCUce4WW04ruAQ45a5Yg2f+W1rpA4Pu
	OfIjpQnXMCPFdzaByajBp7+QP9sCottMJAOEW2HS0GOXVIin377Hgd+TFjjBZnzbjTZM5UN30zb
	XpwAGHkNwhoB5BvPCVZjWA83gxBUVayw=
X-Google-Smtp-Source: AGHT+IHRRvrZk+LJHsAd5/mP4TyTtkU5XrZgqXx3MfUuP0vWFtvlehE6tE5BFAh0/XFz8o1ILqvfmo203M6g5zkxlKk=
X-Received: by 2002:a17:907:c1e:b0:b72:c261:3ad2 with SMTP id
 a640c23a62f3a-b84451dab67mr854015966b.50.1767912442100; Thu, 08 Jan 2026
 14:47:22 -0800 (PST)
MIME-Version: 1.0
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org> <20260108-setlease-6-20-v1-7-ea4dec9b67fa@kernel.org>
In-Reply-To: <20260108-setlease-6-20-v1-7-ea4dec9b67fa@kernel.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 9 Jan 2026 07:47:09 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-JTE+233AwpvrXTsbfrbY+U_pvyUTQQSwz0mXh43jt=A@mail.gmail.com>
X-Gm-Features: AQt7F2q41Fu16p_9dWtEjvrFao8uwKCSAe9mKCbLxMeS3Ih2bsPKkzatUTosKic
Message-ID: <CAKYAXd-JTE+233AwpvrXTsbfrbY+U_pvyUTQQSwz0mXh43jt=A@mail.gmail.com>
Subject: Re: [PATCH 07/24] exfat: add setlease file operation
To: Jeff Layton <jlayton@kernel.org>
Cc: Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Nicolas Pitre <nico@fluxnic.net>, Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, 
	Anders Larsen <al@alarsen.net>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Carlos Maiolino <cem@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <chuck.lever@oracle.com>, 
	Alexander Aring <alex.aring@gmail.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, Hans de Goede <hansg@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, 
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, 
	linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	gfs2@lists.linux.dev, linux-doc@vger.kernel.org, v9fs@lists.linux.dev, 
	ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: zd1x5a3gp5gox66gyqen6qosn9qo4eek
X-Rspamd-Queue-Id: 373D6180009
X-Rspamd-Server: rspam04
X-HE-Tag: 1767912445-687919
X-HE-Meta: U2FsdGVkX1+l13hD58DN2AjLSIWy+vAmDsWFLj734NwmvU/yakEio+AWDYn7yzlInV7plux2ceqD+eG2H4yh3o81zHoamT+PhD646zDsPri9t1pG1kYuKviB6beusLSsZ1eVY2Awj8d5agiE4bH6coC/OLBoKFueLbM/Qozb43uNAwXKTwzfAtqqUZHbXGbFM2o25MhbJXa4Lg2Qctr/mwTBeS1kfeTYnWjwmieUkRUIzRVlirIyakqA14YN/DTSdqm3S5DOLtHp5wzQuXms6uv5fonvbvv0P/Q0u69jezYIlLiLctQSMPOQ2C8+zv52w1kZlgrOwpPCfDYjCVEeiYJ5qaATm836XWhGO+HvwF/tWBlEbQ3LPj01UBKF82ljBUmC2L+E7HMeWmZ0Z5muKl/zK/zdC0P9yKmzNWV1GD4IEilVBixGRnktOu8ysMWTOky417Kb1MGTwYpcU6qufl0hxVpPQHsv78Pfyie3Vv9uKCIzioSktA8tGFODZIB04Xs7szWnfbG3lqZnb9LXblxkkmwvueYrp6gAMEblG5QN9tZCH2Y34NC2Il6TEBtWY7XJLgFU3f/7oILS7RnQYrtKROvSt6osuqiVzSE8vjt4t/7D7bjk/OPX8o0z0p3p99tPNaTq+UR2DPuo0uYBolXb7en0RfsE6HdCKskfz4GWLuT343UgVBBC/7I7JKp0CWA7R1v94bbRjJI0e8XeVfdhOA5apNJ6sg61JpiD0gou3UENEqg5MyIt3FmuhQ7Uo0zFmkvXIk+w3KOrqZRPyYs62LIpKWRFxGCHRHN69RiGhGdB9cmPudp0fQIPa+SY++z9suTjt4/eIjhf9N2IJ9pROigdEhrXZcc7yXpW4V56N9+0351waEF69SdGITNHDEMg7cZQjjNlIk9FxfHCp9Dh2+hgRqVhhorA8yDNKevhnEZAGmlvnBgat+pDnyXJcWaOgp4o6OPS9s2OuA9
 SjX9UYOs
 Cv1KSQ9ONVgP9lhlOekwbPLNMiEg4okmAevMvdLVnzb+65weEFnpxUwDg3Mr3vZqmSUmkVW+X1TyH8dU+43uKaqxf51UA2UwqfS2tytpPC+ysIHC0g7Sx+IzPld62F4mFT6Ga8ZVzTAJxuW5iygcR/qQpfX+/Nx3R6A27abiaKitwOl3X1T7rfqbrJal1ujc1/NcztUNGSc8HaftAvENABF32T8wQETWSj0gmv5n+K1qcXd0x1I4Kg0Z52zeWhvuTB2tC3Ch7fpHNrkqubNx3p/1Bt41AipXo5qnPPuzQiqpA8V0g2Is5xh6mWXzCKztJMMAIobsETQnFusBWewaWq94W0wiCRKU5CigLaV3KxKtSRGakamHy/bzwUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 9, 2026 at 2:14=E2=80=AFAM Jeff Layton <jlayton@kernel.org> wro=
te:
>
> Add the setlease file_operation to exfat_file_operations and
> exfat_dir_operations, pointing to generic_setlease.  A future patch
> will change the default behavior to reject lease attempts with -EINVAL
> when there is no setlease file operation defined. Add generic_setlease
> to retain the ability to set leases on this filesystem.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!

