Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34606CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 908578E0087; Wed, 29 Oct 2025 11:22:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DF2E8E0045; Wed, 29 Oct 2025 11:22:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F52C8E0087; Wed, 29 Oct 2025 11:22:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5598E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:22:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C14CEBAF71
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:22:32 +0000 (UTC)
X-FDA: 84051518544.28.2C85BAE
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id C9719C000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:22:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IMiOJ2KR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761751350; a=rsa-sha256;
	cv=none;
	b=XL2gcTHXgih7KCkebPjf68GOOx1Ce0zDfndHygKcjpyKXDi53R4OJekzwuvz515bmMwEc+
	2jp0zJva9RnDWLmS2KNuj+ZQEJrD3KJcd60BsME4ovwrkwYeD0EQe/kPuckoQy2on0bYcL
	GMI2Iiwx2SHBIxdfhWRr8Un+i7D7yTc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IMiOJ2KR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761751350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5uEf7AWHW2EFfq5FisNeu+6YzxFXhNgGD2IsXcF2IXA=;
	b=n0yTVk1vo+irMi6oBhn0MjmJAf/lSnUiidUpBwxP3xglMJ80YFWRbnEJABHwf36lGJs3g6
	PVFxvTBAr/hvBdNw/tAMwlxwtb+NFkfCJ5jR5pV2MGyfCMb+XlcA+zNq3H8gw3CfF4cKSg
	WY3iD+3EWL3vy4tO7MxqnVRgIDQtacw=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3304dd2f119so23519a91.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761751350; x=1762356150; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5uEf7AWHW2EFfq5FisNeu+6YzxFXhNgGD2IsXcF2IXA=;
        b=IMiOJ2KRUbJi0nqkSI6hq5UAamrbAMJdT+2KBUGi544Atv6z0/vnGPR1JiumXtVsOF
         E0BaO0GG0aTpnT1xRSxk1SFu4Qghi7lbkBen7F1PL+uSrhoHVdomEg+3LwULnhzCZplC
         o8Ch2ntSC9EBRkQUGQO+/nS/lwKnUoYbZjgtm3763NXiqT7BkPH+Yk/bKsra4NUz8eiV
         Gsp39Ed7TRTNpGSMRbt+8SfT/p2O58n3nfara8RpnaJkxbGPfZFYY6Yl61LFpZGZ4iK7
         T/W8kLzc+Dg2qEdqQv9lBb0+IpGAGq3Nekg8wB7PLLo443p+BoWI24a+DBtWRfCwFE6l
         Ou0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761751350; x=1762356150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5uEf7AWHW2EFfq5FisNeu+6YzxFXhNgGD2IsXcF2IXA=;
        b=qwpGWnk7u/58in1dS1VJJDJq2YmdcifsBXi/87ApQUW+gZNFE0mRD9lpVBQzq3Gf82
         uRm5+aqfPzCnZkb6lt0yoOzEooZKNlwUSqyybAmeIzFWuatj/qMQdKJlb4iC00bVyoNY
         JY6CTMoVSnV3ma8XHZ7To13JgOvnztjV8dENuYSqlwOZptMitGNlKGAKYdBlVG7nru0N
         MO8vE8ah9d9KpagsKBA+tTIwXHtGXxsNUOhpv+Yt70ltsMjr4oH65o9CzO3G/ri/hQbp
         MArD6Imne4+tG++APXPlEQasNy0o16xq+vUtbVkDchtjF/JYTsNKBrUEksT39HKtbWdd
         Do9g==
X-Forwarded-Encrypted: i=1; AJvYcCVt3bvL50QEp0sshkgeUX0CzndP3D4vz+ze3vbVhcG+Rx8IFpRqZJznJJeWXsvLgUPDudHGxpIr+Q==@kvack.org
X-Gm-Message-State: AOJu0YxxMDI30uRAroml9OQ/yPlofH/dvHaKEJWuiN0EJ/cGglHzwoly
	BPjfH11w0623ISeZvnQn+DCOhf/jmF1Gltz9k52N47zaS2VL0bV8pQqvHka2NxXXdarRzPyJW3D
	uO1lrZL4VHLAEaQ3TNJgg/1eLu9qWAYE=
X-Gm-Gg: ASbGncveiOOgWikP0+qck5Pmlzi8HBdmmqy7t++Ej267LJcMtmsSNJ0TmvFV68UTXO5
	PkiYH4PArzg/HfL9IZAMoV2cmOoKXNIk97WVTNRotQu7oJGpgQizr4aW3tqjab/kodRgxnpXygT
	x5KrNZIeMXN9fRy8VljlYQV+Cede4IaNS3jU6QAwbFhL4m03pDp6ebwnpvYRNLKuFYrLAtIRYm9
	8hlXsE+skgs7QoR2pOSK6sN5m7LMCo/NUWctG1HWHdN1R9VYNfAFlhEwyXKMkQ61iVhKZI=
X-Google-Smtp-Source: AGHT+IHauJsAd7JkZgiXBb1QwsQmdX1F9k4bjlfRe5Ruq2nxIy/MOGpvFoFrg1ywX5/XWt4Wu3tgzcE+Da4joovTwjA=
X-Received: by 2002:a17:90b:3ec4:b0:33b:b020:5968 with SMTP id
 98e67ed59e1d1-3403a2a2304mr4383659a91.21.1761751349618; Wed, 29 Oct 2025
 08:22:29 -0700 (PDT)
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk> <20251028004614.393374-35-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-35-viro@zeniv.linux.org.uk>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Wed, 29 Oct 2025 11:22:18 -0400
X-Gm-Features: AWmQ_bmyeQMYjDS06AWxBfYb9-0R5GZ19KU4TCXUFH7N6Zg4orJWZ7Jju9hX1JU
Message-ID: <CAEjxPJ6nF1fooxn4XaW1_OcAT46Uh+p4dD5-+uKjWv3EbfvoOg@mail.gmail.com>
Subject: Re: [PATCH v2 34/50] selinuxfs: new helper for attaching files to tree
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, 
	neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C9719C000C
X-Stat-Signature: n3xtbug34mdenj3dzsxyospsudsxjrud
X-HE-Tag: 1761751350-703383
X-HE-Meta: U2FsdGVkX18IGNgvXc0rdVRubK63MQHUPX6JCJhk4rNjgCFFrc9eZXt5NQkRXIF5K8SL65VPU+1mw8pnH0zDTwxpsox9CpVa/hd8BqkpfqJ1O7oXu+IXiuWonXijc7PJgx/9iA4LCRwdPNk/1TNE53OAIhF8NTGZMx3OwM5efIXFIYmQOmtHToWArZKxZ+jcDLSsfmldw6xmLhGE72ndQCazV0JJX2WhIimVTFXRPLISLKWEJBo80Cnv8QmDhi+uizrM38VwSLeKrmI8I/ZALrKvgpN/3myYLbC4UIsZaImgtOrDSSjQkoSBag7Bfp4GcjhzrUqCYpxMGtnoLClBnTFa2Z63yzSIPR/sc1W5f5wU0c6woUjILAnhBDdCdLftLqyalQIno2nYkDNxw/uUAo+7ezMGYh4UKUAVaJmIjwkhBoV6XGHkcOklfIHY09cnQdarMBnhBYpAhHS97XupDVuC69BnZ066t93h+CtVt1f+11/Xue4zUu0/UtrEGkFxoKOdhD+lYBFiTAksBATMqBt6GihWvFn5PEbDIvwCAbr83KKA75AB1chx71ztqZEmJCPxs5LDeTQyzWQRuAz7gi04U2lRsfqMbCn51cGyG7fhgcC7f02boq5zEXv9Z49yERZXRXtlxg5P4lSN/9b52sqM3MS9mW/4JCBF8fP0WGs9xZyctorI3UdTLvjOplXLV6rqi/DvWNRgftnImvb+JCwIXHCJ7q0miNcC+R41F00utAj05nyaiEUqGYn4SB4d8xoSYUZ6DwE2GiDnTZXp/YrW6JsHPfYOUWHrHavLktm6Hv8K2TJERNo0MpJ0PFhbHDJG+Yq/UPZdGmH9CtvAcIufb7P9mWbGyXKgFro5rBbuWuCrwgEZKZfEUC8QLXDWmptQ9UFxPQDLaUhcmnAPW17Vr9B39sgKwWevo5rkfc0eNeS9CzgVNJCGVBxWFOoip8U2CAFjuHCEWYndDF4
 Cpas29jp
 Q7iP8qKwawC2RBa23ORKrc4SloKeq9+oj63Wy3tCFbiGcAyfmmNcBqVgHvBo0/J6WIjVkpRrWzdHhRQD+uGnchDAh95cTRG2FoS/Q6cRUGiZ0WeWQZG7PQ7N0KmvZtSbptphbLSgYxPQvMm/488u2DFlsNHAob2Y5HuJetYQRvU1GtZwNtpJx8tdt3tLoFhQAzvzWk42J3hrLkhYQNwh1CmlgHDS5AuFjcDNgeIHMK4NNnREpLd5ENzWEkKhYDzYeoyVVfeJ0Oa8PEI4vc14JS+AocWyMAX7CFrwmQEjLSoHrureJjsNyOC0lVOc3NedIZ/UwuCsgtZDv8CanOYfIgKL/VWFieoKzJWCY4+TIlvk94iG3LxO/kQ5PfvPF24lWMGWKkCR16CvLw7OJ6xk+ism52mNKmyvncaAbixFujpUBrEgpyK9DIY+9JWIj+YbhAB5GIKJM6sRwpGMSln8CGGSwBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 3:56=E2=80=AFAM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> allocating dentry after the inode has been set up reduces the amount
> of boilerplate - "attach this inode under that name and this parent
> or drop inode in case of failure" simplifies quite a few places.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>

> ---
>  security/selinux/selinuxfs.c | 160 +++++++++++++++--------------------
>  1 file changed, 66 insertions(+), 94 deletions(-)
>
> diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> index b39e919c27b1..f088776dbbd3 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -1197,6 +1197,25 @@ static struct inode *sel_make_inode(struct super_b=
lock *sb, umode_t mode)
>         return ret;
>  }
>
> +static struct dentry *sel_attach(struct dentry *parent, const char *name=
,
> +                                struct inode *inode)
> +{
> +       struct dentry *dentry =3D d_alloc_name(parent, name);
> +       if (unlikely(!dentry)) {
> +               iput(inode);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +       d_add(dentry, inode);
> +       return dentry;
> +}
> +
> +static int sel_attach_file(struct dentry *parent, const char *name,
> +                          struct inode *inode)
> +{
> +       struct dentry *dentry =3D sel_attach(parent, name, inode);
> +       return PTR_ERR_OR_ZERO(dentry);
> +}
> +
>  static ssize_t sel_read_bool(struct file *filep, char __user *buf,
>                              size_t count, loff_t *ppos)
>  {
> @@ -1356,8 +1375,7 @@ static int sel_make_bools(struct selinux_policy *ne=
wpolicy, struct dentry *bool_
>         *bool_num =3D num;
>         *bool_pending_names =3D names;
>
> -       for (i =3D 0; i < num; i++) {
> -               struct dentry *dentry;
> +       for (i =3D 0; !ret && i < num; i++) {
>                 struct inode *inode;
>                 struct inode_security_struct *isec;
>                 ssize_t len;
> @@ -1368,15 +1386,9 @@ static int sel_make_bools(struct selinux_policy *n=
ewpolicy, struct dentry *bool_
>                         ret =3D -ENAMETOOLONG;
>                         break;
>                 }
> -               dentry =3D d_alloc_name(bool_dir, names[i]);
> -               if (!dentry) {
> -                       ret =3D -ENOMEM;
> -                       break;
> -               }
>
>                 inode =3D sel_make_inode(bool_dir->d_sb, S_IFREG | S_IRUG=
O | S_IWUSR);
>                 if (!inode) {
> -                       dput(dentry);
>                         ret =3D -ENOMEM;
>                         break;
>                 }
> @@ -1394,7 +1406,8 @@ static int sel_make_bools(struct selinux_policy *ne=
wpolicy, struct dentry *bool_
>                 isec->initialized =3D LABEL_INITIALIZED;
>                 inode->i_fop =3D &sel_bool_ops;
>                 inode->i_ino =3D i|SEL_BOOL_INO_OFFSET;
> -               d_add(dentry, inode);
> +
> +               ret =3D sel_attach_file(bool_dir, names[i], inode);
>         }
>  out:
>         free_page((unsigned long)page);
> @@ -1579,6 +1592,7 @@ static int sel_make_avc_files(struct dentry *dir)
>         struct super_block *sb =3D dir->d_sb;
>         struct selinux_fs_info *fsi =3D sb->s_fs_info;
>         unsigned int i;
> +       int err =3D 0;
>         static const struct tree_descr files[] =3D {
>                 { "cache_threshold",
>                   &sel_avc_cache_threshold_ops, S_IRUGO|S_IWUSR },
> @@ -1588,26 +1602,20 @@ static int sel_make_avc_files(struct dentry *dir)
>  #endif
>         };
>
> -       for (i =3D 0; i < ARRAY_SIZE(files); i++) {
> +       for (i =3D 0; !err && i < ARRAY_SIZE(files); i++) {
>                 struct inode *inode;
> -               struct dentry *dentry;
> -
> -               dentry =3D d_alloc_name(dir, files[i].name);
> -               if (!dentry)
> -                       return -ENOMEM;
>
>                 inode =3D sel_make_inode(dir->d_sb, S_IFREG|files[i].mode=
);
> -               if (!inode) {
> -                       dput(dentry);
> +               if (!inode)
>                         return -ENOMEM;
> -               }
>
>                 inode->i_fop =3D files[i].ops;
>                 inode->i_ino =3D ++fsi->last_ino;
> -               d_add(dentry, inode);
> +
> +               err =3D sel_attach_file(dir, files[i].name, inode);
>         }
>
> -       return 0;
> +       return err;
>  }
>
>  static int sel_make_ss_files(struct dentry *dir)
> @@ -1615,30 +1623,25 @@ static int sel_make_ss_files(struct dentry *dir)
>         struct super_block *sb =3D dir->d_sb;
>         struct selinux_fs_info *fsi =3D sb->s_fs_info;
>         unsigned int i;
> +       int err =3D 0;
>         static const struct tree_descr files[] =3D {
>                 { "sidtab_hash_stats", &sel_sidtab_hash_stats_ops, S_IRUG=
O },
>         };
>
> -       for (i =3D 0; i < ARRAY_SIZE(files); i++) {
> +       for (i =3D 0; !err && i < ARRAY_SIZE(files); i++) {
>                 struct inode *inode;
> -               struct dentry *dentry;
> -
> -               dentry =3D d_alloc_name(dir, files[i].name);
> -               if (!dentry)
> -                       return -ENOMEM;
>
>                 inode =3D sel_make_inode(dir->d_sb, S_IFREG|files[i].mode=
);
> -               if (!inode) {
> -                       dput(dentry);
> +               if (!inode)
>                         return -ENOMEM;
> -               }
>
>                 inode->i_fop =3D files[i].ops;
>                 inode->i_ino =3D ++fsi->last_ino;
> -               d_add(dentry, inode);
> +
> +               err =3D sel_attach_file(dir, files[i].name, inode);
>         }
>
> -       return 0;
> +       return err;
>  }
>
>  static ssize_t sel_read_initcon(struct file *file, char __user *buf,
> @@ -1666,30 +1669,25 @@ static const struct file_operations sel_initcon_o=
ps =3D {
>  static int sel_make_initcon_files(struct dentry *dir)
>  {
>         unsigned int i;
> +       int err =3D 0;
>
> -       for (i =3D 1; i <=3D SECINITSID_NUM; i++) {
> -               struct inode *inode;
> -               struct dentry *dentry;
> +       for (i =3D 1; !err && i <=3D SECINITSID_NUM; i++) {
>                 const char *s =3D security_get_initial_sid_context(i);
> +               struct inode *inode;
>
>                 if (!s)
>                         continue;
> -               dentry =3D d_alloc_name(dir, s);
> -               if (!dentry)
> -                       return -ENOMEM;
>
>                 inode =3D sel_make_inode(dir->d_sb, S_IFREG|S_IRUGO);
> -               if (!inode) {
> -                       dput(dentry);
> +               if (!inode)
>                         return -ENOMEM;
> -               }
>
>                 inode->i_fop =3D &sel_initcon_ops;
>                 inode->i_ino =3D i|SEL_INITCON_INO_OFFSET;
> -               d_add(dentry, inode);
> +               err =3D sel_attach_file(dir, s, inode);
>         }
>
> -       return 0;
> +       return err;
>  }
>
>  static inline unsigned long sel_class_to_ino(u16 class)
> @@ -1771,29 +1769,21 @@ static int sel_make_perm_files(struct selinux_pol=
icy *newpolicy,
>         if (rc)
>                 return rc;
>
> -       for (i =3D 0; i < nperms; i++) {
> +       for (i =3D 0; !rc && i < nperms; i++) {
>                 struct inode *inode;
> -               struct dentry *dentry;
>
> -               rc =3D -ENOMEM;
> -               dentry =3D d_alloc_name(dir, perms[i]);
> -               if (!dentry)
> -                       goto out;
> -
> -               rc =3D -ENOMEM;
>                 inode =3D sel_make_inode(dir->d_sb, S_IFREG|S_IRUGO);
>                 if (!inode) {
> -                       dput(dentry);
> -                       goto out;
> +                       rc =3D -ENOMEM;
> +                       break;
>                 }
>
>                 inode->i_fop =3D &sel_perm_ops;
>                 /* i+1 since perm values are 1-indexed */
>                 inode->i_ino =3D sel_perm_to_ino(classvalue, i + 1);
> -               d_add(dentry, inode);
> +
> +               rc =3D sel_attach_file(dir, perms[i], inode);
>         }
> -       rc =3D 0;
> -out:
>         for (i =3D 0; i < nperms; i++)
>                 kfree(perms[i]);
>         kfree(perms);
> @@ -1808,20 +1798,18 @@ static int sel_make_class_dir_entries(struct seli=
nux_policy *newpolicy,
>         struct selinux_fs_info *fsi =3D sb->s_fs_info;
>         struct dentry *dentry =3D NULL;
>         struct inode *inode =3D NULL;
> -
> -       dentry =3D d_alloc_name(dir, "index");
> -       if (!dentry)
> -               return -ENOMEM;
> +       int err;
>
>         inode =3D sel_make_inode(dir->d_sb, S_IFREG|S_IRUGO);
> -       if (!inode) {
> -               dput(dentry);
> +       if (!inode)
>                 return -ENOMEM;
> -       }
>
>         inode->i_fop =3D &sel_class_ops;
>         inode->i_ino =3D sel_class_to_ino(index);
> -       d_add(dentry, inode);
> +
> +       err =3D sel_attach_file(dir, "index", inode);
> +       if (err)
> +               return err;
>
>         dentry =3D sel_make_dir(dir, "perms", &fsi->last_class_ino);
>         if (IS_ERR(dentry))
> @@ -1873,58 +1861,47 @@ static int sel_make_policycap(struct dentry *dir)
>  {
>         struct super_block *sb =3D dir->d_sb;
>         unsigned int iter;
> -       struct dentry *dentry =3D NULL;
>         struct inode *inode =3D NULL;
> +       int err =3D 0;
> +
> +       for (iter =3D 0; !err && iter <=3D POLICYDB_CAP_MAX; iter++) {
> +               const char *name;
>
> -       for (iter =3D 0; iter <=3D POLICYDB_CAP_MAX; iter++) {
>                 if (iter < ARRAY_SIZE(selinux_policycap_names))
> -                       dentry =3D d_alloc_name(dir,
> -                                             selinux_policycap_names[ite=
r]);
> +                       name =3D selinux_policycap_names[iter];
>                 else
> -                       dentry =3D d_alloc_name(dir, "unknown");
> -
> -               if (dentry =3D=3D NULL)
> -                       return -ENOMEM;
> +                       name =3D "unknown";
>
>                 inode =3D sel_make_inode(sb, S_IFREG | 0444);
> -               if (inode =3D=3D NULL) {
> -                       dput(dentry);
> +               if (!inode)
>                         return -ENOMEM;
> -               }
>
>                 inode->i_fop =3D &sel_policycap_ops;
>                 inode->i_ino =3D iter | SEL_POLICYCAP_INO_OFFSET;
> -               d_add(dentry, inode);
> +               err =3D sel_attach_file(dir, name, inode);
>         }
>
> -       return 0;
> +       return err;
>  }
>
>  static struct dentry *sel_make_dir(struct dentry *dir, const char *name,
>                         unsigned long *ino)
>  {
> -       struct dentry *dentry =3D d_alloc_name(dir, name);
>         struct inode *inode;
>
> -       if (!dentry)
> -               return ERR_PTR(-ENOMEM);
> -
>         inode =3D sel_make_inode(dir->d_sb, S_IFDIR | S_IRUGO | S_IXUGO);
> -       if (!inode) {
> -               dput(dentry);
> +       if (!inode)
>                 return ERR_PTR(-ENOMEM);
> -       }
>
>         inode->i_op =3D &simple_dir_inode_operations;
>         inode->i_fop =3D &simple_dir_operations;
>         inode->i_ino =3D ++(*ino);
>         /* directory inodes start off with i_nlink =3D=3D 2 (for "." entr=
y) */
>         inc_nlink(inode);
> -       d_add(dentry, inode);
>         /* bump link count on parent directory, too */
>         inc_nlink(d_inode(dir));
>
> -       return dentry;
> +       return sel_attach(dir, name, inode);
>  }
>
>  static int reject_all(struct mnt_idmap *idmap, struct inode *inode, int =
mask)
> @@ -2012,17 +1989,10 @@ static int sel_fill_super(struct super_block *sb,=
 struct fs_context *fc)
>                 goto err;
>         }
>
> -       ret =3D -ENOMEM;
> -       dentry =3D d_alloc_name(sb->s_root, NULL_FILE_NAME);
> -       if (!dentry)
> -               goto err;
> -
>         ret =3D -ENOMEM;
>         inode =3D sel_make_inode(sb, S_IFCHR | S_IRUGO | S_IWUGO);
> -       if (!inode) {
> -               dput(dentry);
> +       if (!inode)
>                 goto err;
> -       }
>
>         inode->i_ino =3D ++fsi->last_ino;
>         isec =3D selinux_inode(inode);
> @@ -2031,7 +2001,9 @@ static int sel_fill_super(struct super_block *sb, s=
truct fs_context *fc)
>         isec->initialized =3D LABEL_INITIALIZED;
>
>         init_special_inode(inode, S_IFCHR | S_IRUGO | S_IWUGO, MKDEV(MEM_=
MAJOR, 3));
> -       d_add(dentry, inode);
> +       ret =3D sel_attach_file(sb->s_root, NULL_FILE_NAME, inode);
> +       if (ret)
> +               goto err;
>
>         dentry =3D sel_make_dir(sb->s_root, "avc", &fsi->last_ino);
>         if (IS_ERR(dentry)) {
> --
> 2.47.3
>
>

