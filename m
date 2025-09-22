Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07574CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 02:50:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4677A8E0007; Sun, 21 Sep 2025 22:50:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 418438E0001; Sun, 21 Sep 2025 22:50:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306998E0007; Sun, 21 Sep 2025 22:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 188D68E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 22:50:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 999E114048E
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:50:17 +0000 (UTC)
X-FDA: 83915357274.19.38AA55E
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4A7A2C0004
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:50:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=c6u4s3no;
	spf=pass (imf10.hostedemail.com: domain of paul@paul-moore.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758509415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7XFLhLN2bC131m5hKpTDzRYLjnq0kauHpj5EizfADo=;
	b=Ku5F65psTjR1H+XiRucvwOo1BS758o4w1iiJrVxFoL9IC3XEJeSTGz1DanNpWOVozRzEMd
	LtjDM/DnhRbX1be+gJ7SlQ9r1Ic1kZNJ7VYaVmxxrWUwxur9ZY/Q/3jKYZFJaa5PcCX0cI
	MeJ4N0s5g3Kl6kGFSuW+RZAaCk2qrWw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=c6u4s3no;
	spf=pass (imf10.hostedemail.com: domain of paul@paul-moore.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758509415; a=rsa-sha256;
	cv=none;
	b=7qnZOjLjIw4q4hmf+rJ3nE1+LFQHQEmZgKDrKhPyagP6vse21je3O/KNSLA+KP0reSx7PV
	U3FfRVGwD/mM1YXZm003LOJy18ttlw82KgajXdqm0w2Jyd53OXumiakU2LjITQVZFsLUMF
	dlMlQD7ifa85T12NUqJhpDnGBK/f/Yw=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b4fb8d3a2dbso2710906a12.3
        for <linux-mm@kvack.org>; Sun, 21 Sep 2025 19:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1758509414; x=1759114214; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p7XFLhLN2bC131m5hKpTDzRYLjnq0kauHpj5EizfADo=;
        b=c6u4s3nom5qyTwaBg2SMji3YGjUFqWzkhAICtQBDeG3rpSOJ1xxj9ZFOoI+vTeqpdo
         JiAtOQSm7iYag7jS86Q/6ypckSIwXL+hLgsDTx8OEYzq7bPltRLuVJPFd0XQ7UpojowB
         inryZ1Sg8YlpGZ/qX7kzp1ColZeLk/SMRi8nEUUYID6iwmj/X5062qt18jfSauQWYNLc
         qTxJspgChgB7CHvFQidgi5RN+zM4Z+rI2A+BVPD19OaAzKPLw3eJEehXrESXIQ8eB2Ow
         8E6QmuYYrR+k9RnTcvDTEB1MJPAYgvSo69MZRDKbui0vo8U0oZvZfYqY+VktpLflZo94
         HmAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758509414; x=1759114214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p7XFLhLN2bC131m5hKpTDzRYLjnq0kauHpj5EizfADo=;
        b=J8aud8ixItzKgwjlUmEKvHM3hgxGRtnrSSGLvIVUmNdAxzP8lfA0URtjPWZZtRwxWI
         2taGzxfyOfcipFwzTMKooXGvGYpn8hUbnCDyBfwOvD5U2pyAJxD5JUSXqT2y7+UcHviA
         B3f/V1n0hLojXCsR33OyxVngQJfkzGurH9CV3ighwTXbGlvtWmxGJRZ5l88w3+iMbu07
         4a5OXuoi9koR1nDyl1or5AmXyzoVxjpQKGDpjMC0mljQPb95XSuo/7XZRd/zP9QYSl+Z
         P8wWJi8S7ZuSbXBBxmjU7+wfWDdhmxFKAakEYzsShnMe12t+E6qF5+sliFxy0OVG3wVg
         Lesg==
X-Forwarded-Encrypted: i=1; AJvYcCUbkU8xiemOIYAKkcvvBQRK1Q9dWI+j/uYlyL2bgp9JS3+kcSwNEzDAaTD3vLnHqqpovSAB+YL93A==@kvack.org
X-Gm-Message-State: AOJu0YzFxo3tz3RZU8kXmeR8dCBlqsrVeoPPGPC1VNqqZBWAhoO8Hv5U
	EsDsS9385ApUAGPiP9BaIbh1ZTeZ8/nnwCkeuYrTicvEFKdUK7qbAGr+Lxx9lRx5BtYLVJYby1F
	yiU7SBhqZox+1cUah6rZ1vSs8OeRbBgL2F9VJyRUb
X-Gm-Gg: ASbGncvNdEnsm3h7vI8/dyPAFn49xXve8BXxCHsUx3VR85y0vcaRN52yqtDGpnPMvSX
	R99mZi9RlYKlsTOqEeezMWfNXrwX0ctKkzBBKSIp1x5KqZ5k6tKuKlUvmiT1sqTTzZDtez4ZKnl
	SnE2LfHS0hd0bpkU5yH96wkhv5yD2qUb7Q61E/wC2ztF7YNNSOK91cdagMVpbZHDV00/LemsSTi
	WN2QJ0=
X-Google-Smtp-Source: AGHT+IGe+15w8xvp7a+Fw0oSWAsBTAKPDi7raUHSz68Xr1TN17drDWabkB3/4zSQVbDi/BgDo5ph0IOND5WuUlo/leI=
X-Received: by 2002:a17:90b:5109:b0:327:7c8e:8725 with SMTP id
 98e67ed59e1d1-33097fee350mr12554584a91.10.1758509413659; Sun, 21 Sep 2025
 19:50:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250920074156.GK39973@ZenIV> <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
 <20250920074759.3564072-31-viro@zeniv.linux.org.uk> <CAHC9VhTRsQtncKx4bkbkSqVXpZyQLHbvKkcaVO-ss21Fq36r+Q@mail.gmail.com>
 <20250921222619.GO39973@ZenIV>
In-Reply-To: <20250921222619.GO39973@ZenIV>
From: Paul Moore <paul@paul-moore.com>
Date: Sun, 21 Sep 2025 22:50:02 -0400
X-Gm-Features: AS18NWA59TWujxe3lwJRQwcdud2e03V7ijpvYuacj-73O3HLhpPDNRlQbZP5_x0
Message-ID: <CAHC9VhTy2j+hkT24hM1J2GH+12wp63DArRo6BGTvTwGX2k4CnA@mail.gmail.com>
Subject: Re: [PATCH 31/39] convert selinuxfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, 
	a.hindborg@kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org, 
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, casey@schaufler-ca.com, 
	linuxppc-dev@lists.ozlabs.org, borntraeger@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4A7A2C0004
X-Rspamd-Server: rspam05
X-Stat-Signature: c85hss9sab99cpqnzkh4btzbwc1kbng5
X-Rspam-User: 
X-HE-Tag: 1758509415-451250
X-HE-Meta: U2FsdGVkX19VRg21VF4NT9qAdNAAIy+mgbMRPQClFzreJfde7RyIwaRYF9V9nHCfZ2lTJ2W5y3bvR2IU8FRJUJp4z6cJKEey4IqjkxX0V9XB8OFdSFvfp6zBspiAklHNLK8GlIaT5DATmdUZs8rM5J/dBgy+2E3WnoVa7bDUrDuvrflbxqLfhgDMiM3MjenKatwu8S9Q2yIeV9uPkXLUG1pWzLJU4Sm/qAFD75wUgDizxkw6+Dt01q0bwihWTJt2tnSyiiwEwuKrvUddng3tF9r/oNMksyab5crkdDNBt4Nhkilw4NECSk82dZZ1LaOSjzSeTDmTSmKVeCJDHep3ho/5sHC2L4qCOos6k7nSOz7LVp/9k9b16rzFbZULSW+PARrdKkUODO+d/KfsBl3t3ekP9eRFAUCWdvpB35nfyxd6smjlJk0mZDyEdmRlpP0bcsVLD7wNPqrv87qJQsd1/UVUUNlhdgDfWRHhdCH0yrPCiLIcwiUccU4s0bzyd38KZ6Z+WC2HzMvuTdliTSxct4xjcTyzUAtETwEX8Yg9aV9i+mfxpa7vdgEl3o3x5VDI6U8lakhO80szFIOiUjyQe7kvSMdznJF0/t4cfxjsNBmx1dyHOn9N9IFZs8axVq3dKscHb+pCUK3NOXKIMFKMubgg/ntWRbQquFbw1ytdw8u9CqCveHHOskBAJVQg+XWI5GV1opNP6O36zV482MdEX7tHytM5o2z5A33dgglYPSoekB3DcboaVs7HAWKFCXntB2R2bPZV9+R2+M6+SvBp8xrTJyd+8JgDj45psbmz0A8ZXCP22XlK8wCoT8Vaah8+AzthEL5O+U92PdM6YK38dAs7uy43wcAa2LZQv2v/LX5pJ7D1JV2RweKhcaS1B5XLFYPhcC5E9GeC23jp6L8IdeQIGQbSRgKsyW2guKhi0/AOgjnp8ZejVq7N9kO4y6eIdrWWkCKKVudIMIph+OT
 Uhvr+N5J
 h8k0Rx4Oe8MzUMM1YV4zxNqs5pLjfFO5Kl6pq1McyZPTBwiZgv4YY6pKJBs31Ir9r4AWo8NREoLFZhBhKI6ezNQB0J5xEieTGoYKHu/C9OL6QVi0//kyW70Ucf2b3zU3E9IEo0kHD4tOaM15PcSaG0hFSdLW8ci+kDDK1L5WKI+dHLCBqlin9P9fWnjSgJthzFJMCkf3caplE/us+RkwLGm7+A/QZkvejZUFFk4bkb1dLOx00q8HKVhYemBVY9VnvaLzDE3/N6EehmxubO9MMjf7FFDbB1QUMg3pAfpyJqdjmTDFIWCIwZJ6ArpXAIvf0MNEgTLSqt/IUGTg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 21, 2025 at 6:26=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
> On Sun, Sep 21, 2025 at 04:44:28PM -0400, Paul Moore wrote:
> > On Sat, Sep 20, 2025 at 3:48=E2=80=AFAM Al Viro <viro@zeniv.linux.org.u=
k> wrote:
> > >
> > > Tree has invariant part + two subtrees that get replaced upon each
> > > policy load.  Invariant parts stay for the lifetime of filesystem,
> > > these two subdirs - from policy load to policy load (serialized
> > > on lock_rename(root, ...)).
> > >
> > > All object creations are via d_alloc_name()+d_add() inside selinuxfs,
> > > all removals are via simple_recursive_removal().
> > >
> > > Turn those d_add() into d_make_persistent()+dput() and that's mostly =
it.
> > > Don't bother to store the dentry of /policy_capabilities - it belongs
> > > to invariant part of tree and we only use it to populate that directo=
ry,
> > > so there's no reason to keep it around afterwards.
> >
> > Minor comment on that below, as well as a comment style nitpick, but
> > overall no major concerns from me.
>
> FWIW, how's this for the preparatory part?
>
> commit 17f3b70a28233078dd3dae3cf773b68fcd899950
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Sun Sep 21 18:09:48 2025 -0400
>
>     selinuxfs: don't stash the dentry of /policy_capabilities
>
>     Don't bother to store the dentry of /policy_capabilities - it belongs
>     to invariant part of tree and we only use it to populate that directo=
ry,
>     so there's no reason to keep it around afterwards.
>
>     Same situation as with /avc, /ss, etc.  There are two directories tha=
t
>     get replaced on policy load - /class and /booleans.  These we need to
>     stash (and update the pointers on policy reload); /policy_capabilitie=
s
>     is not in the same boat.
>
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Looks good to me, ACK below.  For me personally, it's a bit late to
take non-bugfix stuff for the upcoming merge window so I would defer
this for a few weeks, but if you want to take it now that's your call.
Also your call if you would prefer this to go in with the rest of the
patchset you've working on, or if you want me to take it via the
SELinux tree.  Let me know.

Acked-by: Paul Moore <paul@paul-moore.com>

> diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> index 9aa1d03ab612..482a2cac9640 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -75,7 +75,6 @@ struct selinux_fs_info {
>         struct dentry *class_dir;
>         unsigned long last_class_ino;
>         bool policy_opened;
> -       struct dentry *policycap_dir;
>         unsigned long last_ino;
>         struct super_block *sb;
>  };
> @@ -117,7 +116,6 @@ static void selinux_fs_info_free(struct super_block *=
sb)
>
>  #define BOOL_DIR_NAME "booleans"
>  #define CLASS_DIR_NAME "class"
> -#define POLICYCAP_DIR_NAME "policy_capabilities"
>
>  #define TMPBUFLEN      12
>  static ssize_t sel_read_enforce(struct file *filp, char __user *buf,
> @@ -1879,23 +1877,24 @@ static int sel_make_classes(struct selinux_policy=
 *newpolicy,
>         return rc;
>  }
>
> -static int sel_make_policycap(struct selinux_fs_info *fsi)
> +static int sel_make_policycap(struct dentry *dir)
>  {
> +       struct super_block *sb =3D dir->d_sb;
>         unsigned int iter;
>         struct dentry *dentry =3D NULL;
>         struct inode *inode =3D NULL;
>
>         for (iter =3D 0; iter <=3D POLICYDB_CAP_MAX; iter++) {
>                 if (iter < ARRAY_SIZE(selinux_policycap_names))
> -                       dentry =3D d_alloc_name(fsi->policycap_dir,
> +                       dentry =3D d_alloc_name(dir,
>                                               selinux_policycap_names[ite=
r]);
>                 else
> -                       dentry =3D d_alloc_name(fsi->policycap_dir, "unkn=
own");
> +                       dentry =3D d_alloc_name(dir, "unknown");
>
>                 if (dentry =3D=3D NULL)
>                         return -ENOMEM;
>
> -               inode =3D sel_make_inode(fsi->sb, S_IFREG | 0444);
> +               inode =3D sel_make_inode(sb, S_IFREG | 0444);
>                 if (inode =3D=3D NULL) {
>                         dput(dentry);
>                         return -ENOMEM;
> @@ -2079,15 +2078,13 @@ static int sel_fill_super(struct super_block *sb,=
 struct fs_context *fc)
>                 goto err;
>         }
>
> -       fsi->policycap_dir =3D sel_make_dir(sb->s_root, POLICYCAP_DIR_NAM=
E,
> -                                         &fsi->last_ino);
> -       if (IS_ERR(fsi->policycap_dir)) {
> -               ret =3D PTR_ERR(fsi->policycap_dir);
> -               fsi->policycap_dir =3D NULL;
> +       dentry =3D sel_make_dir(sb->s_root, "policy_capabilities", &fsi->=
last_ino);
> +       if (IS_ERR(dentry)) {
> +               ret =3D PTR_ERR(dentry);
>                 goto err;
>         }
>
> -       ret =3D sel_make_policycap(fsi);
> +       ret =3D sel_make_policycap(dentry);
>         if (ret) {
>                 pr_err("SELinux: failed to load policy capabilities\n");
>                 goto err;

--=20
paul-moore.com

