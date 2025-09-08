Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A60FECAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 16:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7AE06B0012; Mon,  8 Sep 2025 12:27:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E52026B0024; Mon,  8 Sep 2025 12:27:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8EE56B0026; Mon,  8 Sep 2025 12:27:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C79626B0012
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:27:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 58259118A82
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:27:46 +0000 (UTC)
X-FDA: 83866614132.16.2CC3EBF
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id 62CF5A0008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:27:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DyJd15yO;
	spf=pass (imf25.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757348864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eqksz8Elm+j9d5P5oS54jOmzSpQqif5zj7qYCyq5Noc=;
	b=yyeih8YdU/Q2EA2tqnxQ5tUW8RnXHXciDYWO4HGgqjxLCYe06IhYCMv/46YnilbSTcXsgE
	g8OFf7LGEok2P2r3zC3aHy5UxG27e9geJAwizpifajYYmJPYzTD5lNtFlCSpr0SF1rJM4n
	fpSA/wHzjyVqvbLZQ+glAdeDVKVn6J4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DyJd15yO;
	spf=pass (imf25.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757348864; a=rsa-sha256;
	cv=none;
	b=CgJ6gTJ+Bm/D6kS/5liI41edv4S7fNlwPfoFMUojVATrSOGigqpR65T8ACqH69YXxKF+FZ
	7OU05Gs/d/QUC/GbHO/qVnpmXp5wa+0XDbgUNhQk2b9r8B0zS0kU3zCvHqCooEgxZGjtm9
	5ZgbLbYvBJzDtBkRqHleL+rGNLd3gXg=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b4c6fee41c9so3604659a12.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 09:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757348863; x=1757953663; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eqksz8Elm+j9d5P5oS54jOmzSpQqif5zj7qYCyq5Noc=;
        b=DyJd15yOdoNrtuGIbOO8kI0NCXBoKgfPwnj4JtMTAakT3dmn2UTFjBKZ5FXz2pAAe6
         PkNmwPuzCcoIJiy/6GaVIGzi3uiY7GBUCPATzzoMezk9FxGJtytGSRnz0Kg4/KRbzost
         uc1BCf3Smte9s9EgQtxWh4nQgkEyqN9VuTlYWn1AfOXoN4/XupBCZ4MxMpDRgQJA0A94
         fq4U9a/FzSl2sd/tmDv59D8cJ7cmDJVKK+461UF9o+dz5d6HgNV0RNs7N0u0Ymf8F5Ql
         bcLAnSXJOZ4OdzRtrJORjgl/fstP1VxcfLMYMTDUZrOn9JjAvsufQzORCyoRzfLItasm
         +RxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757348863; x=1757953663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eqksz8Elm+j9d5P5oS54jOmzSpQqif5zj7qYCyq5Noc=;
        b=eAI4NtBr27Nt/Q+gM8XoiCTNxwJjuJ3cjEEHaMub727ZO+dtJ0F6L8G31NotT4rpi9
         zWFHH+kIg04ZpD9MlgRCVNcclfqNfe2pXC0wddcPjN79vL/81s1Bkyq2vzZIqKZjNqTe
         z3JhKlpuQ9QED48/jgCvwuit+QHaTcO6lB1eSEwoDCB1dUrLSmxHjP1/wYQHCG3hTsC2
         1U6TRHTNViWktfqMZrMSM0LtLoEw+EB8Qx7c4FgArsdy0kYxMv45UQxa8+1Ta8BZ90hc
         QXj++BpPcdPuU/Ls157EygmwOQoiNRwIpNV/U90UlSkbiXQkIdBo4SL5yQH1shdZIcyY
         wpxQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5NG9PWuuoQnA8c9l/5nD+CDRTFNdJmlxOGuYsouPRl0d17zyc9emh0oCAgsr+sY/aASu6r+PzIg==@kvack.org
X-Gm-Message-State: AOJu0YxKrjlQ5s3T19vu6e1lkRQFGVwJ+507TnmUY8elWXr0ckNEoQ1N
	ZlEZ6FLkc+Rcu5rHXyPT+9Fe6/u/02u1PunJkC+NJspv+SRWXlQ7cPYqpH/IAXUnwetiKrZnF19
	Up5/7OLUXidGflMYCn3Ixwavf3T+lbZA=
X-Gm-Gg: ASbGnctx6p85tBV1woyk0MqU+3IcZxbkX9PmnMcJRzGAGXh/XT2z1ztS8DQdp2mPLmB
	UhIO/FtujXsTq1YX4mbjHtsKsA5UUd7BsOL9g7cwEYL7CTEHgNF6IcZErBLxIdNsDljfDLjbRxF
	vkESWIAefUJHhdgvSArbNQG7YZkHdeIXnquYiY7PT9vjS33JdgWopw8/sNP0QpapxygE2uBTBMC
	CNfGBw5nSND9idwZg==
X-Google-Smtp-Source: AGHT+IEDHB8CQ3IuTWj7RQjTDdTxecjnrrL3Sce+3gGLzG/rmTLFq4zmdmZQREIb8tm2hwLEHCSVH3EIkU0L2w92lBA=
X-Received: by 2002:a17:90b:3d04:b0:32b:623d:ee9e with SMTP id
 98e67ed59e1d1-32d43eff92bmr11113951a91.14.1757348862937; Mon, 08 Sep 2025
 09:27:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250908013419.4186627-1-tweek@google.com>
In-Reply-To: <20250908013419.4186627-1-tweek@google.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Mon, 8 Sep 2025 12:27:30 -0400
X-Gm-Features: Ac12FXzOq5uQaG3MIFlG7lf0qwtknS8Lq4am64oYOyVC_0QFQ4mNZM_xLLwrHZk
Message-ID: <CAEjxPJ6QfUZijh3PEpHs_Yw6Hmte92-rg8gkvMw9cD=JxA+CMA@mail.gmail.com>
Subject: Re: [PATCH v2] memfd,selinux: call security_inode_init_security_anon
To: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	Hugh Dickins <hughd@google.com>, Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, 
	Jeff Xu <jeffxu@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Isaac Manjarres <isaacmanjarres@google.com>, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 62CF5A0008
X-Stat-Signature: ai46kz8q5nsaecszacu8a3f9bt9ohiyg
X-HE-Tag: 1757348864-865077
X-HE-Meta: U2FsdGVkX1/Wa1vrS4KDaAGw/2sak1G7JZDCctTifGLkD9uZwCHTsMxzrhONaLjn9ol6VAOnx7L7rEqaKT4L4ySIYYu1ryROaj2pNL9YSVxn9UOB65uYZfqL401l3ahrN1lY+C5KLSnjSMyZfbbcdy/6FwgfmIPiTayYIr+RCTYEQj7tX0wWEJSLpXCpwOz8K335dD9fFpCZepzFCEhixIa2S5U8mkMeefxn7so4dsbnH4tbt0ZyZFbsaG4gXjNyuZa7MLLFUTMpmSZltPWEeGIpEOUVPEDQPwEqwtX/3E/VR3lC7oxUb17NVcV/2CeTJ1d7wSHN9njMVPxrpgBBzBbqUZjBsMg9HcgcRr051b0rsAY3m2WaaYn/COYBzzv+gShZ75vMfyafUBB3KMioT61kgLhsF+pW84/C9Zgp3FcwNFjww7J4LYH0I6sgF6yJKZ/2Voe1eVQtjgyA9/8qHD+n4aHAvRLbFSrG79y1+cVO1bXdhPyK8Ax7QErMj14xdPUlwYQ4JvLk2MofpFcCPHCqifqSVy3V9Yie+IRv0E4n7Ng7kiKbEaPHjNmcCsLKTAw8NbDH9/dQEEf0gi74otbyOdvFFWzQFBM6yXA0rpcuuQEKpwdaW7RvP6yWcqeU8TSxItbN3NiyTcgyxb1mDnZgKnRm/a4NUdoNk25E3xJFZFLKWDYVws3LjkT4Loj+76bp8LYvgpiNMrmeXgtgoQ4xsBXhxwyiV2YfbFyINrbmzmO4hOS3gVSxiUXmIiMs7/8mddr2gV7YqhfAwPz1ky5PFJStrqwB+4DM1vIh48L1ajOxdAbJdEaB3kIbUL/sy8sWrFrgdH+kGRxndWfMVy98SEOJT5ZhGsSDcOtDw7ZBNVXXexndxfQwPvszAR8GpdjQj3E2TxCmB+tFVh2IxSwW+ywKFA/n9RPKfSLed/vNDt33EHzahzTHQ7eJWFJx92v7I2gmR6JCkVodVzT
 N8FWhKgK
 cVVmTjWDBy5zmUut1RFGmedh/ITVuUyV6rfUv9aleqPGQk3uWsSAp1nhi4EnLk1Kou5BEqLHhG4/nZh+VYdv1082KaU8nquERuM/ZIJ+keODfZuEGanQvcfBQmBdtkxjghm9jPIv3jFLCSSoooeiKeOD2fawDcp5SxXRXxG1iCMyoJMBnMSS6V/nzAwI03Se/4kXS7ypuEyqd0eomh3TWnc8xqMyW2XTQoAk8iuk5BBrCLGwGpcjCs5kPF98wcGOJQkLzAAfLtWdYuOfx4X1b+grt/MUiPBkF3zcOvm7cN7EvtoYn3vKJ5s+KGQrA1Y23CkQxOWs1XKIcwN3DjdChsUdSOJ+BrDpxYC8xEgKWQd8vorbaaXFIf9RpDdoz2CuD+viIrmxgI3AQ7j70iFcx3t/zgb6Wwu/jt7nS49d3e7xf7ej2gOidTdyjc5E1qHIjeX2ThLoQzwGc+esGewI4C48m+R419AYWqRscxBVoSZItit+HwVpqKTGXyzZ6XaFyFeJ85jw+/o61Jo6m9EbTC+pajzoLAikgqBtX1ugQEBqq8ZjAMmqG1cQkUbOKLDwmx5W+pN1zkKI/fjlP/NdmRBOAeQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 7, 2025 at 9:34=E2=80=AFPM Thi=C3=A9baud Weksteen <tweek@google=
.com> wrote:
>
> Prior to this change, no security hooks were called at the creation of a
> memfd file. It means that, for SELinux as an example, it will receive
> the default type of the filesystem that backs the in-memory inode. In
> most cases, that would be tmpfs, but if MFD_HUGETLB is passed, it will
> be hugetlbfs. Both can be considered implementation details of memfd.
>
> It also means that it is not possible to differentiate between a file
> coming from memfd_create and a file coming from a standard tmpfs mount
> point.
>
> Additionally, no permission is validated at creation, which differs from
> the similar memfd_secret syscall.
>
> Call security_inode_init_security_anon during creation. This ensures
> that the file is setup similarly to other anonymous inodes. On SELinux,
> it means that the file will receive the security context of its task.
>
> The ability to limit fexecve on memfd has been of interest to avoid
> potential pitfalls where /proc/self/exe or similar would be executed
> [1][2]. Reuse the "execute_no_trans" and "entrypoint" access vectors,
> similarly to the file class. These access vectors may not make sense for
> the existing "anon_inode" class. Therefore, define and assign a new
> class "memfd_file" to support such access vectors.
>
> Guard these changes behind a new policy capability named "memfd_class".
>
> [1] https://crbug.com/1305267
> [2] https://lore.kernel.org/lkml/20221215001205.51969-1-jeffxu@google.com=
/
>
> Signed-off-by: Thi=C3=A9baud Weksteen <tweek@google.com>
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>

When you revise a patch, you aren't supposed to retain other's tags
since they haven't technically reviewed, agreed to, or tested the
revised change.
That said, I have now done so and thus these tags can remain!

> ---
> Changes since v1:
> - Move test of class earlier in selinux_bprm_creds_for_exec
> - Remove duplicate call to security_transition_sid
>
> Changes since RFC:
> - Remove enum argument, simply compare the anon inode name
> - Introduce a policy capability for compatility
> - Add validation of class in selinux_bprm_creds_for_exec
>
>  include/linux/memfd.h                      |  2 ++
>  mm/memfd.c                                 | 14 ++++++++++--
>  security/selinux/hooks.c                   | 26 +++++++++++++++++-----
>  security/selinux/include/classmap.h        |  2 ++
>  security/selinux/include/policycap.h       |  1 +
>  security/selinux/include/policycap_names.h |  1 +
>  security/selinux/include/security.h        |  5 +++++
>  7 files changed, 44 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/memfd.h b/include/linux/memfd.h
> index 6f606d9573c3..cc74de3dbcfe 100644
> --- a/include/linux/memfd.h
> +++ b/include/linux/memfd.h
> @@ -4,6 +4,8 @@
>
>  #include <linux/file.h>
>
> +#define MEMFD_ANON_NAME "[memfd]"
> +
>  #ifdef CONFIG_MEMFD_CREATE
>  extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned in=
t arg);
>  struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx);
> diff --git a/mm/memfd.c b/mm/memfd.c
> index bbe679895ef6..63b439eb402a 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -433,6 +433,8 @@ static struct file *alloc_file(const char *name, unsi=
gned int flags)
>  {
>         unsigned int *file_seals;
>         struct file *file;
> +       struct inode *inode;
> +       int err =3D 0;
>
>         if (flags & MFD_HUGETLB) {
>                 file =3D hugetlb_file_setup(name, 0, VM_NORESERVE,
> @@ -444,12 +446,20 @@ static struct file *alloc_file(const char *name, un=
signed int flags)
>         }
>         if (IS_ERR(file))
>                 return file;
> +
> +       inode =3D file_inode(file);
> +       err =3D security_inode_init_security_anon(inode,
> +                       &QSTR(MEMFD_ANON_NAME), NULL);
> +       if (err) {
> +               fput(file);
> +               file =3D ERR_PTR(err);
> +               return file;
> +       }
> +
>         file->f_mode |=3D FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
>         file->f_flags |=3D O_LARGEFILE;
>
>         if (flags & MFD_NOEXEC_SEAL) {
> -               struct inode *inode =3D file_inode(file);
> -
>                 inode->i_mode &=3D ~0111;
>                 file_seals =3D memfd_file_seals_ptr(file);
>                 if (file_seals) {
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index c95a5874bf7d..6adf2f393ed9 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -93,6 +93,7 @@
>  #include <linux/fanotify.h>
>  #include <linux/io_uring/cmd.h>
>  #include <uapi/linux/lsm.h>
> +#include <linux/memfd.h>
>
>  #include "avc.h"
>  #include "objsec.h"
> @@ -2315,6 +2316,9 @@ static int selinux_bprm_creds_for_exec(struct linux=
_binprm *bprm)
>         new_tsec =3D selinux_cred(bprm->cred);
>         isec =3D inode_security(inode);
>
> +       if (isec->sclass !=3D SECCLASS_FILE && isec->sclass !=3D SECCLASS=
_MEMFD_FILE)
> +               return -EPERM;
> +
>         /* Default to the current task SID. */
>         new_tsec->sid =3D old_tsec->sid;
>         new_tsec->osid =3D old_tsec->sid;
> @@ -2366,9 +2370,10 @@ static int selinux_bprm_creds_for_exec(struct linu=
x_binprm *bprm)
>         ad.type =3D LSM_AUDIT_DATA_FILE;
>         ad.u.file =3D bprm->file;
>
> +
>         if (new_tsec->sid =3D=3D old_tsec->sid) {
> -               rc =3D avc_has_perm(old_tsec->sid, isec->sid,
> -                                 SECCLASS_FILE, FILE__EXECUTE_NO_TRANS, =
&ad);
> +               rc =3D avc_has_perm(old_tsec->sid, isec->sid, isec->sclas=
s,
> +                                 FILE__EXECUTE_NO_TRANS, &ad);
>                 if (rc)
>                         return rc;
>         } else {
> @@ -2378,8 +2383,8 @@ static int selinux_bprm_creds_for_exec(struct linux=
_binprm *bprm)
>                 if (rc)
>                         return rc;
>
> -               rc =3D avc_has_perm(new_tsec->sid, isec->sid,
> -                                 SECCLASS_FILE, FILE__ENTRYPOINT, &ad);
> +               rc =3D avc_has_perm(new_tsec->sid, isec->sid, isec->sclas=
s,
> +                                 FILE__ENTRYPOINT, &ad);
>                 if (rc)
>                         return rc;
>
> @@ -2974,10 +2979,18 @@ static int selinux_inode_init_security_anon(struc=
t inode *inode,
>         struct common_audit_data ad;
>         struct inode_security_struct *isec;
>         int rc;
> +       bool is_memfd =3D false;
>
>         if (unlikely(!selinux_initialized()))
>                 return 0;
>
> +       if (name !=3D NULL && name->name !=3D NULL &&
> +           !strcmp(name->name, MEMFD_ANON_NAME)) {
> +               if (!selinux_policycap_memfd_class())
> +                       return 0;
> +               is_memfd =3D true;
> +       }
> +
>         isec =3D selinux_inode(inode);
>
>         /*
> @@ -2997,7 +3010,10 @@ static int selinux_inode_init_security_anon(struct=
 inode *inode,
>                 isec->sclass =3D context_isec->sclass;
>                 isec->sid =3D context_isec->sid;
>         } else {
> -               isec->sclass =3D SECCLASS_ANON_INODE;
> +               if (is_memfd)
> +                       isec->sclass =3D SECCLASS_MEMFD_FILE;
> +               else
> +                       isec->sclass =3D SECCLASS_ANON_INODE;
>                 rc =3D security_transition_sid(
>                         sid, sid,
>                         isec->sclass, name, &isec->sid);
> diff --git a/security/selinux/include/classmap.h b/security/selinux/inclu=
de/classmap.h
> index 5665aa5e7853..3ec85142771f 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -179,6 +179,8 @@ const struct security_class_mapping secclass_map[] =
=3D {
>         { "anon_inode", { COMMON_FILE_PERMS, NULL } },
>         { "io_uring", { "override_creds", "sqpoll", "cmd", "allowed", NUL=
L } },
>         { "user_namespace", { "create", NULL } },
> +       { "memfd_file",
> +         { COMMON_FILE_PERMS, "execute_no_trans", "entrypoint", NULL } }=
,
>         /* last one */ { NULL, {} }
>  };
>
> diff --git a/security/selinux/include/policycap.h b/security/selinux/incl=
ude/policycap.h
> index 7405154e6c42..dabcc9f14dde 100644
> --- a/security/selinux/include/policycap.h
> +++ b/security/selinux/include/policycap.h
> @@ -17,6 +17,7 @@ enum {
>         POLICYDB_CAP_NETLINK_XPERM,
>         POLICYDB_CAP_NETIF_WILDCARD,
>         POLICYDB_CAP_GENFS_SECLABEL_WILDCARD,
> +       POLICYDB_CAP_MEMFD_CLASS,
>         __POLICYDB_CAP_MAX
>  };
>  #define POLICYDB_CAP_MAX (__POLICYDB_CAP_MAX - 1)
> diff --git a/security/selinux/include/policycap_names.h b/security/selinu=
x/include/policycap_names.h
> index d8962fcf2ff9..8e96f2a816b6 100644
> --- a/security/selinux/include/policycap_names.h
> +++ b/security/selinux/include/policycap_names.h
> @@ -20,6 +20,7 @@ const char *const selinux_policycap_names[__POLICYDB_CA=
P_MAX] =3D {
>         "netlink_xperm",
>         "netif_wildcard",
>         "genfs_seclabel_wildcard",
> +       "memfd_class",
>  };
>  /* clang-format on */
>
> diff --git a/security/selinux/include/security.h b/security/selinux/inclu=
de/security.h
> index 8201e6a3ac0f..72c963f54148 100644
> --- a/security/selinux/include/security.h
> +++ b/security/selinux/include/security.h
> @@ -209,6 +209,11 @@ static inline bool selinux_policycap_netif_wildcard(=
void)
>                 selinux_state.policycap[POLICYDB_CAP_NETIF_WILDCARD]);
>  }
>
> +static inline bool selinux_policycap_memfd_class(void)
> +{
> +       return READ_ONCE(selinux_state.policycap[POLICYDB_CAP_MEMFD_CLASS=
]);
> +}
> +
>  struct selinux_policy_convert_data;
>
>  struct selinux_load_state {
> --
> 2.51.0.384.g4c02a37b29-goog
>

