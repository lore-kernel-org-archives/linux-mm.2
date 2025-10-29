Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A03F7CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECE358E0086; Wed, 29 Oct 2025 11:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7E6A8E0045; Wed, 29 Oct 2025 11:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6D0E8E0086; Wed, 29 Oct 2025 11:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C29F48E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:19:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C0EE160865
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:19:54 +0000 (UTC)
X-FDA: 84051511908.01.79EBF94
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2A2222000F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:19:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P2rpjQ0O;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761751192; a=rsa-sha256;
	cv=none;
	b=StZwrg3/h3k52c3r4wUGOKRfmPqMgT6FjRM76Iy6704QKHe0rPWWlhsoFPNBu6foUQAYi9
	1TIm8KEhmvZKzbPzfBFE6aHYuqhF6ErnZK62zcDfU0j4J4qw3uR80M+9pO9r8fJZ4524nW
	JpzFiuyBSl13qVRmxSQxx7c/sx6vVpA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P2rpjQ0O;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761751192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1CdmUiAXh1HKc3m/r9pA/phMrmd+nlM0IzGmsHncGb4=;
	b=EXoXySsRP+17ONSMkW0MOkIPgxZ8RFv/aQ2wPTpROax1ahFX/zrRA1YH9obkSSHWggohFm
	aXem2fTg9QaOXNbkg9+0mLkTT+ze9iz71Lt4RhqpL+buO0tYpZM9MdWuj7Zje49oHgFzS9
	bfItzsOK+rIf47hu3shYf3Cwh13ALLE=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-32ec291a325so27240a91.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761751191; x=1762355991; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1CdmUiAXh1HKc3m/r9pA/phMrmd+nlM0IzGmsHncGb4=;
        b=P2rpjQ0O7+Q3mbA8BwzCHQ1Uanfrx44wLOhgDM+SYRwgAVIuPuCyDCeQNTvJhyswIV
         f8YFuO0FjBgCaMxZBA+5JJ3u7OumBaRCCRaxR/No+F9U+7NE90qC50ABKijvdtUOjn/s
         ceKpNk8U+bUco93/olCwtXCRq0K8OthcEhY6siUi7rlL3XtTKEJSa4PLasrhp5bHF9l8
         J4mI806A5NpRMKYv0Ipz6wSDIEjcsgvygqsCyGRSTAjVVbE1kmdjKDQf801T0olRjHa6
         EK5M/+etEqHYITk+YwTABr6sow3p9njA5c1dsbHCvN7SRPQ+9LKQxYQLnXhcHyQSNIEa
         rM9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761751191; x=1762355991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1CdmUiAXh1HKc3m/r9pA/phMrmd+nlM0IzGmsHncGb4=;
        b=uej6YYdtSChiOAcpZg98QiKHh2VH2i1aCS87OU9yWg1jfLkpzuB6z2RePHmTVtYng+
         cf9uiS4mDDr4gw8q+TGji/rz4xBgIylpEE3yo7y9xiL5xf/DevreT+bEAnUf3nhbSMd9
         R6ssfaU9bd/cuq+2yiNAGannX7YhgmS8Lj8g8wlJUOrQ7SgB0zYM1/06TpQ1HdQa+gFm
         Aep098TZwQD6GBjhpdnzQP0iMXcbY3a/U0HU9wTNmJ8b8DH/xDQOpxxfzPm8HzGUm7Dz
         MGqFtH6/kT+sqMhpFkTOoXc2JCDKDfkMew46XNKxSEcdZS+UDaGD2lJSCTiPMQ9fwmFq
         kejQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYcx0eZvZ4rDy22da0RCR7SCd3QTwPyZ2Fpm4Nz0rvtwf3xmpU7xZn70oWpIOcKBeczfxT/rC3hQ==@kvack.org
X-Gm-Message-State: AOJu0YwHUoVBBdxLWc4JJ1OkGSuiEhQn3IrB9RXHdcaaz/ne498bEHtr
	wLo98xPIKxvThbFALff/aeR/hFtyoWP7gJHUaojLAT8YkH6E6gz01HAXBojFwWBgY5EN1E7+DLL
	bOrGgbtVJqIHRIoVCumA/cqndtCCAS5E=
X-Gm-Gg: ASbGncufJr9FrqvTCTDkhiN8rN8F0JnvqlOQtDrijX2zrGHaK4EsaV/GaNn/tWjYBrs
	J7VYcJpfXywmxjy9+IogVe6Wdnq+TQdQQYkNgGidZfGypt98L1cOnYKkqQ/gDaA4bS2L8MVKC1o
	olH0MqzFuX1jnRWH804UEiE47SuFdRlvnEMg0ZSwopluY60Bp1zJzA9U3O4+Cn7455EwBLTOZKy
	eVW5F+YB1MqBxN6fC3e35x/lZMnLdFwu60M10TDR6xQwehOekVQ+t/2x5xybEOLCdxx1o8=
X-Google-Smtp-Source: AGHT+IFbcnsAk75YEZiUX3rsU0b/ZmVe83k3NaOxPSYI+q4vlPOeZ92ke++maKcHRCEWJ6+8d/ixoTttE36+ff9pbFg=
X-Received: by 2002:a17:90b:1f8a:b0:33f:eca0:47c6 with SMTP id
 98e67ed59e1d1-3403a2f179cmr3475777a91.30.1761751190939; Wed, 29 Oct 2025
 08:19:50 -0700 (PDT)
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk> <20251028004614.393374-34-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-34-viro@zeniv.linux.org.uk>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Wed, 29 Oct 2025 11:19:39 -0400
X-Gm-Features: AWmQ_bk3QGrfeacG4nKn1A56jExYpoFICsJu3Aq8X6pMLjFJYWj1N_7Lqh37COA
Message-ID: <CAEjxPJ60geP6mJsKW41Pj12tPCf-dGk=ys8vr5fEiO2tVj1Rdg@mail.gmail.com>
Subject: Re: [PATCH v2 33/50] selinuxfs: don't stash the dentry of /policy_capabilities
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
X-Stat-Signature: jm8zyqgs5cnx375ipi7bjrex7qey1qp6
X-Rspamd-Queue-Id: 2A2222000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761751191-77302
X-HE-Meta: U2FsdGVkX19v+tY0gtbrbd2LCmiqRpR/czXyVYbn7RSg5G3s1zvEmDb/lW+0jZ0gSyYChIB+38HirOANBnNsGWkmHtS0zvxkFOHOWI6EjCZZJLrdk7Mh5BuGE9McxAXsPv5D80suC7tyR7LgYPTWG1UdZ+13QXKxAR+LArDyJxlODIO7G148Ha5cruttJvK3Ymh4hP5U3cfNmbYRcPUvDwCf4qFalN1r/jj/zThnJPiN0K44U6oCfOvNyGP9SfbArlwyjrJgsktP8SIdt1dM4eKmdvBJ24zcSEiUsHwYNH0ooTjMPlkmxXdQJfGYNoJZoQPpn1cuDY8zK1JIhbYex1fZuCNNCUJ5mkHrNjKjRD/Xii0xQ7h4ptoqB+UfNnGrAUgXK/BGi78Vm3ZBraJCPmhYcABI+3LEtmceIp71pOSpAz/st48Jrjy+N/KiDcQY/2RXJ1EQznw32mHcK4874+cZVkg5kHGZZxtuCj96JqiT8w2T5xPcQwdox3thS1R9EcWzZd3NmtWMoxYkf0UyX9IBfnWG2Nx43dwEtuIAQxh6MumQgL+wzNoDTiJKqsJFAT9UB72vLnejuOj0rFUFa1Q1G1A3KHGi9OJgcCmUl/3omJey7SbK8n1wVBUdm/yr20fVyZ6pUft3nnzAWp8FtJp2UhAUNwp2gxsd0/rTxubFxcNfVQirECkjfjoMmJpasO1ONSLut+1Fun784TXKpSPl4wsxT4IuXa0G0aSRYKfPSUWvcfvwZyB79xkY5MBPtgOb4LyC9AgtejOFjpBlDw5cwkTho9hiO6VtQ7n7uAHknwVn0Ze27tnxFATX3eAU4exd5vVW1AbEOGTPY1Pn/NPEuTdR2RyKBhWf4b9ByGyN0P4sDfpFBFBLevRaTdNHZcH6iBIycL1GSf6xIRK3NHjCx/cRu2tbLrCbPXvqpXUOBdbpdo1FsTeS2mnsIp5E/bZ1X14tIneWJOg4CXE
 8ZW7esPL
 U6TbMqAjA90BEjV4ls0ZPEf53g2O9U/svgIDIt2kYXBYZ6vxJsfJ1nIwoF3PdHA6QxCGUIXKs//KeemGG8zWowwxQZbiWRmVaTAPwF9nJ1Hl9de+Q869cIIsc5QOVIAJRiCZC/yDItSiZwucsbMfkgg4KnCc3L3Lob+VBK+9z4+qRWdhCQ2Otn4Ft1GrlocBfSJP6uuCLvAKTuA/vKjfbPbsplR+T+FrI15oUxzrcJUfVpHouQbWmLuLkbhA6CfdxBbY/ykEhi4vXenQWGCU54TCnQa2O+e0ILAfdDdNeO/HcnvkdLw/4n0ezsVHaMXepkqGXD82DsfrquuZY7/PcthVdGqvAwTGHInjzuNQMMHKBuLb9T4sCZE3ONWZZ38fXC3eUE11pRxWIjLevoC2v/VtshCZofN94dlhQRXx3V5ssE1uvxfpp+xQiO7iapduqkEdnOwkPqy1RP+L6r0NT6nhJUFrt3Z+Z82O8cod2voaNsbKCOn8XiWGbkoY4THYBUlJS5gmWHCDXk+Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 8:48=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> Don't bother to store the dentry of /policy_capabilities - it belongs
> to invariant part of tree and we only use it to populate that directory,
> so there's no reason to keep it around afterwards.
>
> Same situation as with /avc, /ss, etc.  There are two directories that
> get replaced on policy load - /class and /booleans.  These we need to
> stash (and update the pointers on policy reload); /policy_capabilities
> is not in the same boat.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>

> ---
>  security/selinux/selinuxfs.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
>
> diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> index 232e087bce3e..b39e919c27b1 100644
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
> @@ -1871,23 +1869,24 @@ static int sel_make_classes(struct selinux_policy=
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
> @@ -2071,15 +2070,13 @@ static int sel_fill_super(struct super_block *sb,=
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
> --
> 2.47.3
>
>

