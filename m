Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 485B3CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 13:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835A66B0005; Wed, 27 Aug 2025 09:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5438E0005; Wed, 27 Aug 2025 09:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722338E0001; Wed, 27 Aug 2025 09:24:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F36A6B0005
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:24:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C942A11920A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:24:02 +0000 (UTC)
X-FDA: 83822605524.09.F8E2F27
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id DF055180010
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:24:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hdtrNRtc;
	spf=pass (imf24.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756301041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0+Z6EZIQR0o/UT5Ew23/Zd4wA8+f+oOfKWhDtiUSUCA=;
	b=p8GfzU3IaUuQ5I9Vu3YvFF9otX8pkXknZ9K1CJgYSUHTcP7Y4kgupZitXiw1f4tEhHVJwP
	mg0WddShm5gat4nRuGOuvTGxZg69qSMGRdaUJkdDwHmKSu2X0TG+VpBCc/rTtgENGmdc3j
	/Z7PDvkn1oHjzAwDswhyE57YnEyzWII=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hdtrNRtc;
	spf=pass (imf24.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756301041; a=rsa-sha256;
	cv=none;
	b=3ljyn45KETgR/zUJErBW0ZbIvG/MY14+AN7PQ8QOouHWvdTr4femg4zl6V55S0876nkPzB
	p3Z5d8jNTJQyXtxTPnLtKBeDaJq3Zd1vBXpPqB6ichcEXu1OdXkyb5GlHOWMgBOGLa9WfW
	3/beYB05p7DwKpEfEE2ivzmkx6JhS6Y=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b47475cf8ecso4788169a12.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756301040; x=1756905840; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+Z6EZIQR0o/UT5Ew23/Zd4wA8+f+oOfKWhDtiUSUCA=;
        b=hdtrNRtc9SoCywY86/lM63VIbTe2cWf6EGt1UU71r3FRh24VCZYh4rMpmoZvIsy63o
         00NT+2AJ8oSYdQuNNsj16jKQ8dsaGZowIMpCBQx3ZZdRuvdPglxg+INd90+ydGkjYCp+
         wlc3U45BmpwTy91cFVfy+Wy3GVioO3h14ns0ZV70CwSBtqlfxxszkO1aYr0wIzQUCTYV
         wBt0KfK9zBUihDJOiYBwcpBl05G7mXM9vArIs3NeOA8FJDPk26Dzav72TIDf4RQoU2wE
         sD3NVaEzmQSwIa4bbVUxhVEuRwux3vzkNtKqDRKQZjhWvsiI8xl/OioAY278I8HBoJ2c
         +cYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756301040; x=1756905840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0+Z6EZIQR0o/UT5Ew23/Zd4wA8+f+oOfKWhDtiUSUCA=;
        b=u+4ahoR5OUytlY14dC6deWWY4q+le8qHrk8BBIN8K0RbAFjGIaR3UcG0X9EhwPx/W9
         OexOWxl2TQwlkVXB6gNQixfCVf+UOs7HaDVtGandvZlI+LIaU2yYQnLzkkqxkeGbO+DI
         t6Kw6WvTRwadmbOrxAYmV2+zPLozC1Qpnh+S58czseOF44y9dsnBO8E0MwsLGPpkycU1
         IeGn8bq1FrBCqfMJidtMWj0ebJr1jQXc7YusFaqTS2qMWy5MHQuWij80WLT3OvOSH0xT
         VitF22FhsrhFhbxHP/0DvpVkFwKXgE3ch0MknAZgTqOtU6kjgUuVRBc496/WF/syyj1Z
         zPdw==
X-Forwarded-Encrypted: i=1; AJvYcCXInxIyyneMDvW9usrKegvqKUd4iRLiDowz6v4eu0AgKxt70/i3v1tLY0R2e33a8dCeLrg896cp1Q==@kvack.org
X-Gm-Message-State: AOJu0Yx/2KzY6EaixAsNGLWXVUYsL8Lg1cg36VCX9I9a2gQKDkyrvyz0
	6E5BzLoy44nBaLeoEpL1GhisRruSGKb1Ucmn5ouUnBm8cwQk6C4v9uvTXbv68QkrLQgii1noMFY
	YVrjtP+TcPVVOkTSlY5le0tGkvgrVvEo=
X-Gm-Gg: ASbGncsdcalo2oRE96GtBC8NbXEzJAnz9bUsgZ1mmFVHkNf3WOvz4BnFBgeC54xQFvm
	Lb5w9xcFfbSj0RQzqCaVlGmypkwxfD3k4ejEtxYgfbkYJQP8gXqVZh2BRUVlyLTg0KgmpEFAkIv
	76HlYecNF+Z0sp/OGkGD8lSerPJG3/SNYW3pnm6qN9VTycHW1h5vCXS9fBfYi45bWrWyVBOkFw8
	+PN1UI=
X-Google-Smtp-Source: AGHT+IFqToF9gBp+UyFTqKlU5wNf+zGDiS/bnFnnJhMueM+agaECoZFQMDP9MtD0GJBSwP2SR02RjH7cGdZdRQCzIbI=
X-Received: by 2002:a17:90b:17c4:b0:31e:6f0a:6a1a with SMTP id
 98e67ed59e1d1-32515e12e55mr24232684a91.3.1756301039423; Wed, 27 Aug 2025
 06:23:59 -0700 (PDT)
MIME-Version: 1.0
References: <20250826031824.1227551-1-tweek@google.com>
In-Reply-To: <20250826031824.1227551-1-tweek@google.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Wed, 27 Aug 2025 09:23:47 -0400
X-Gm-Features: Ac12FXwwVCVh8Q4CW3b7vD2Y1uA9d0c9oJmdXy-DlkO1Tt715Tn3W-AtphEbLg8
Message-ID: <CAEjxPJ6G2iK9Yp8eCwbwHQfF1J3WBEVU42kAMQHNuuC_H5QHNw@mail.gmail.com>
Subject: Re: [PATCH] memfd,selinux: call security_inode_init_security_anon
To: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	Hugh Dickins <hughd@google.com>, Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, 
	Jeff Xu <jeffxu@google.com>, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jfmfcgz9ae18j96xp7i1qr6soj3mftye
X-Rspam-User: 
X-Rspamd-Queue-Id: DF055180010
X-Rspamd-Server: rspam01
X-HE-Tag: 1756301040-375351
X-HE-Meta: U2FsdGVkX1/4mV53X3JO6KrfDUNfdWz4r0BQgI6KrSmDOtVuRxjcYoIx/+Tb702eeDhlIN7kli4zomxoxBVJ3jd9T73btXHAsKh+w/O1N3NVFgmjvjyh6/sjEU47q7m4qe2lwqYErUq8jJhW0QH/7NvdH1ClSDiS8EiXVX2pamxpyg/mSt6UkkKBr9/+VzO8CZbofZfBjLC8uuAYIS1k8mXMN/+s/VK2RLEb7EXanzmxe6s/nTG94U+HDUWvuED456Hf3s/M9dxe2Eh7Y3n5yMYGNsUDGmUkY8yzTO1QVLj5zoyLussCT/iEUoKEW+PxWANjwhsztu63OsV0aWK7QYR/q+1GOwYGlU45vQVZ/WOhBqhcQHjuGQUzUDLa0iyMsNprVvlVXjMfMPQLbDhlg0U8pLeZ7wompDObS2dh29YIfkbZYyxJz9cy900FGGJn/v0He1spoN5F33N+bzdGoPfHBbuvDvF8Y8rKP2Q9QkCeDxmis1wGl1yC62/YpjRmSlmpl1KuLIo2mVQjIiYJBsEvvndMnz7KW3nmSe0v/4A82YKyJ3NbT+fEimuv6raOV7MdqstEk+tyWKJSc1NaA08dYvFe5TsnKlJf7ifgvuiwHc24gAghShIHrzk2ycKYCkco6CcbHpdsknRAdYgAICM4hSzd38A5eO0bU7V+p8oXS6xaBCd3gDNwB51usWooVko4mmjsclgPem16HhI/x2OeXqYhb2vCDOB7Fxq/1p2Ay9eFtErOdsGeEWusxc4JCdIXaI5TqfR4q0oNiryH5qLnKoNMEkLRrezuhYnVUBL8z+mqt1eXjPdj2rNn3k6pvbg7nRqbW85I3owwfcmVmuGcbRxGqMB4qWeT0k+C16yH7jrLxD4cTMLOxiMrJPUJkjOFXA3cxQcHgrNzgpqWH5sw1rl9qNvCpXj4IkBbxUtmbjw79Yq2NYDF6W3hpVs586hTFbYzIbaGd0I6XQ2
 AzD8Lc4Y
 p+qJ0Jhdb/6cRLR2QXM1XDMVXC1pQQiIecBUvgYy1aVbv4n05FcGTdb+Gza/tr9PPGm8i8KNQpyNW6qqvz3+Cu2y5UfaaI3VLsCvcYFYpOikkT8ANwjvFT+MVM3qSdtXzcHatw6YNlbxb6KDXMdY+n5Q8E1bL9Ow30U9sslpPnEx0RMoLZG4Is7tpmS9eEftgoKURFVIPk8iRDtP0iV8frYaMWZz+uzqC054ShgpfW54feBr64juUfbeoh3VwS7+kVIaPxv/Xgabn+ISWb2yr7mf7vjMsEC8j5KvQZfjRksEalVvGHEhZGBoKbfRgVs/tiViyNI3TzaWGtenFsQTLlSwRUYiTxtYYELxXVcKejPAuGD1jEiChy6YiPa3Jat+wNMNMYButdolEgPrfb/Aga14HR54/UG/ZGAlHT6HmoylftyZS1K5zxnd1I40eO0jPSIUxO1uRBHrmXA3u1fwI7N9Qm5XuY/664OVEZv7Bael50j3edOmPiv27IrtZfBSTRcGwR5n6okeeKZ+Oh6WM3FGP4XNr3xv7rdjzuSNw9RbyN26B/eXC9h39E6mIXkmv9IiqDnwISEsy/lzU6BvXM2/48WXvRaQ/EqAC3qUaHsafxm3pbMbCglDNDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 11:18=E2=80=AFPM Thi=C3=A9baud Weksteen <tweek@goog=
le.com> wrote:
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

This looks good to me, but do you have a test for it, preferably via
patch for the selinux-testsuite?
See https://github.com/SELinuxProject/selinux-testsuite/commit/023b79b8319e=
5fe222fb5af892c579593e1cbc50
for an example.

Otherwise, you can add my:
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>

> ---
> Changes since RFC:
> - Remove enum argument, simply compare the anon inode name
> - Introduce a policy capability for compatility
> - Add validation of class in selinux_bprm_creds_for_exec
>
>  include/linux/memfd.h                      |  2 ++
>  mm/memfd.c                                 | 14 +++++++++--
>  security/selinux/hooks.c                   | 27 ++++++++++++++++++----
>  security/selinux/include/classmap.h        |  2 ++
>  security/selinux/include/policycap.h       |  1 +
>  security/selinux/include/policycap_names.h |  1 +
>  security/selinux/include/security.h        |  5 ++++
>  7 files changed, 46 insertions(+), 6 deletions(-)
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
> index c95a5874bf7d..429b2269b35a 100644
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
> @@ -2366,9 +2367,12 @@ static int selinux_bprm_creds_for_exec(struct linu=
x_binprm *bprm)
>         ad.type =3D LSM_AUDIT_DATA_FILE;
>         ad.u.file =3D bprm->file;
>
> +       if (isec->sclass !=3D SECCLASS_FILE && isec->sclass !=3D SECCLASS=
_MEMFD_FILE)
> +               return -EPERM;
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
> @@ -2378,8 +2382,8 @@ static int selinux_bprm_creds_for_exec(struct linux=
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
> @@ -2974,10 +2978,18 @@ static int selinux_inode_init_security_anon(struc=
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
> @@ -2996,6 +3008,13 @@ static int selinux_inode_init_security_anon(struct=
 inode *inode,
>
>                 isec->sclass =3D context_isec->sclass;
>                 isec->sid =3D context_isec->sid;
> +       } else if (is_memfd) {
> +               isec->sclass =3D SECCLASS_MEMFD_FILE;
> +               rc =3D security_transition_sid(
> +                       sid, sid,
> +                       isec->sclass, name, &isec->sid);
> +               if (rc)
> +                       return rc;
>         } else {
>                 isec->sclass =3D SECCLASS_ANON_INODE;
>                 rc =3D security_transition_sid(
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
> 2.51.0.261.g7ce5a0a67e-goog
>

