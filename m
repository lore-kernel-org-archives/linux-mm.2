Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C734CAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:21:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A451F8E0116; Thu, 18 Sep 2025 09:21:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D4D8E0112; Thu, 18 Sep 2025 09:21:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 933308E0116; Thu, 18 Sep 2025 09:21:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 819F68E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:21:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A4271A01BA
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:21:40 +0000 (UTC)
X-FDA: 83902433160.04.0860FBE
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0500B80009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:21:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KYKlNCDr;
	spf=pass (imf02.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758201698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXxuG0XXZ2CUEkR517o9YLIawLxCf0z3nLMq0JlK2WM=;
	b=6gBpg5V0WNGaisiNnc9RpIGAJ5uBa0ea5LV+18L0WemZKXRc/Xvd1ufeyD2u054fKUU4vg
	doSTJAALA9BPkAeB8pOpHHieJ9ZAE6zZR3BQXN0cQf5ssE2b14LNvmj22eG6fLonKyyb9D
	wgOaPiaJWqPNLgYW7k0fWaWEFTAvpiE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758201698; a=rsa-sha256;
	cv=none;
	b=blGc8lbmqXgv8uGG/BJQEC70DJO5wIR970nEhyM5jhkhkPKwfpBRN3vp9KeFHBajxV74uY
	iEky/x6wD9yr1yipwkaIwIczRflKdJnM/F4gU0yMMeGmO1660Q7LunCmgsBCzEkBwnSv5B
	x3jMPcig8n3thvUD+krNBYW16nWEm7k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KYKlNCDr;
	spf=pass (imf02.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3304dd2f119so655205a91.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758201697; x=1758806497; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uXxuG0XXZ2CUEkR517o9YLIawLxCf0z3nLMq0JlK2WM=;
        b=KYKlNCDrSkoVa5gRyLpVEsPrUQ4HRew+Oi5PiqDYBW6nrdkjheDy4v+NhxQjKeNLkm
         aF4AhTJidumY/XP2Up6UWb6LFFXEjvTijpWZLzt0X07SmMV7Es4TM/+7WihB8MTqSEuo
         StfQ/E1GMk4jVuXCV7205XV/SLU1AJc6U4NBJCaTUK7Kb2PO6W0P18Dso9I/4KRm4fK5
         aRzVcj0TErdeLybtawc152hCK0BPuVcgVcBRybN8dvIy85lyfO2yuBu9jVCv0dq9egn3
         D36kTAqtckNQvEk4uWUR7xlzjp02pWmzThnLtnwZtQQcp92L5HY88QMzqlgz06QEIMcY
         zd/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758201697; x=1758806497;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uXxuG0XXZ2CUEkR517o9YLIawLxCf0z3nLMq0JlK2WM=;
        b=bjV9sob0MxpChe3BGTf4MOKKEZyEWHww/ApCTgyzFEI8Omhe/MPSjqkuyIOjJH+yVD
         yZBNgpKNROtb5rpKF/+BkjuRAYUdPSKpjab4O0tQlOcU2IS2vIVaOYE6UBgKNIWqOnGt
         H4sadFKWiBu/o8FsJ1zy/J10JaCiy9/bTOXUlw8GjImjAc1x76jAW+DKMKTkwO3qJiIn
         HnQKeGPM5mBEqisWrvDQ/Ay+0biE2FGaQFUQW1cMYQglTzXOq0GptUwxN9LiJV73piiJ
         LuODwwMCRjl+Vypn4Zf4KElcTWdxvFFqfOpOJicVRSWuS4PXhxHXTBlgEpzR+u/iWKoR
         h0Rg==
X-Forwarded-Encrypted: i=1; AJvYcCWDRton6LTD+GsXMr/oMUPYBoxPJeGVLmJcqx1/cuOam/2hFz6ccMMDZZlEmul7JQWfSH1/djGBsw==@kvack.org
X-Gm-Message-State: AOJu0Yw62ildq/4DUJ0a7NS2O69elIhst9fB2y6wv0DggPJpXL+7MAqE
	2sRyjFOnE2yC6SoCpY++qRjX+NVrb1KRn+Y/cn63Whgebrp/TnigLKQVbupm1ToNJuYQCtPG+oz
	btT0MbF6tm9x85S8IrJF2Jg6MNEjpstk=
X-Gm-Gg: ASbGncszUHkB8UqrIUi8qvuqm4p2HPRPDgEGoRjqmPTfBNSff8rVNCbAF7GN+GkWGms
	++HZNG2HohevpbijH+ojvcEwICtNWiGiQtqbmSq+6XsRRw1GNR1fkdecrNmdAHvFnfQapyV/aN/
	Vzy6qLfOyifVfZ3dqeDqlNPMf3Ixw/lyJAH7lt5aMUi40bBUZDyNTGNEKUf1XKbTcF6sjwEeG4d
	Nvjk63aZWPgfOEsL5vS+rP0RA==
X-Google-Smtp-Source: AGHT+IEnjpkTWLCQa+CWj7BavA5ALvKGzVwQe85nvKFpYbfFsEBJjiEExOrH1PCFbaVN1zCXE1Rm7mKuObPQUoR+2TE=
X-Received: by 2002:a17:90b:384f:b0:32e:59e7:c37f with SMTP id
 98e67ed59e1d1-32ee3ef0cd6mr8705000a91.12.1758201696382; Thu, 18 Sep 2025
 06:21:36 -0700 (PDT)
MIME-Version: 1.0
References: <20250918020434.1612137-1-tweek@google.com>
In-Reply-To: <20250918020434.1612137-1-tweek@google.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Thu, 18 Sep 2025 09:21:25 -0400
X-Gm-Features: AS18NWC6hAaYPr9mZDSCAKWisfn4LDvK8z5iTIGk5nKtO93zNOxjlf-1udEy7BM
Message-ID: <CAEjxPJ6qe2WzikK64qH+iqeWd2BkTk+tgq1tMUf1u6H7UYrH1Q@mail.gmail.com>
Subject: Re: [PATCH v3] memfd,selinux: call security_inode_init_security_anon
To: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	Hugh Dickins <hughd@google.com>, Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, 
	Jeff Xu <jeffxu@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Isaac Manjarres <isaacmanjarres@google.com>, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0500B80009
X-Stat-Signature: qaaeg1fujdxsbhpz8yz71a9c6nd6sw9u
X-Rspam-User: 
X-HE-Tag: 1758201697-56869
X-HE-Meta: U2FsdGVkX18V0DzapDP1QvckvaKxWkq/AQtglaaVSa/Bt3Eq2tx0jva6rRb3vL922kZ68oF4DiC8x9XH38oL5ZKpYbUWdoyb03/JU+mjwkllSeCENXHqhIkPI/7O4vR2JPx6dKbUY/hRC/TuOUFLnMmZ8XI6xG3SV0M3AaOcUXAOZgiCQ2DF0QGVDZbutVZCPVro9iZKu5okncTHK8n6CLsjA2GAWbTxoBuTgU5ZYfDNPwrwsQPtIkCGQ9ltvZphbVWU2ILe8Dg6eehOKnin9jEwqRv5nBkqy7UcB+tDkFLZek3M/ARmDR5do9+lQWBku2dMboiS3iMaY0QFxgmeCX+zatSoBWdmFqlPA7lrCC+kOU++0/OP/kZxYwOBTC2ESaiI+Yq4lIVj96F1gK9ZIC2DvQPR3nq6uoeuC2D94EO95dNs+kl9ps4Z8MAlGd+FEnCM1VyXYsl0fO1Ztr9BsOaDGrscESyHqBb0zejggJxfWZbdOYDcvxDoZ6dv6TaB4Zt9lyRKYBqxm5d7f8PmcfZ0haOQFtlKF8+xDz88eP4B/gYc2yie+yhbImz2lLshMX4RXDWnyrWWcpSD3G20nZb+sBtDcjfqWl5/qRf33vaRptwqDl9bmql784S1xMW+ZYpBGlhx2koZwVRdSGYpwR0ExbI3SJeRaoTepP2cnqdbbX4sBooNBWqROLSIF987bw8jsTmMnPmAsje1IXwaEE1egr04fKLRHxazNNDjwPzMCt1IPihhpwYrcQWe3OV0SRqRlbw5SRdFd5xYMy/BqWVs+aF911hU6dhq/oxlvaBB6b6nRA9sr+QmZf0WqhtaQ0HvxmCwZDm/suXdY5Orc8YalISehzE61JNqAxdMeaK9luT2WDgaWWGZyuXIzzNtYIgwonXM6PVndOpW28FyeEf4qYCldFZ5J/lvtc5tiWSqqU0867ZUJoR6f67YoW2tLCA8eQRbYpMIPA0vfzi
 Qn74RCGR
 nZ4RMeOGe3lGMh8Om3Y00OStINoxvPES68xz6IOTo+Wq+1F2DZ3RiDtRnpWsLTFqr56psADuV3+/0aLXQRUxBWqqbBtduK1LPJpcmuxQJAfy/UZlHzUyUsBwAZyUQnDsHdpyGmeW22Gupj0Udutmt+iVwMjUwUkjCLsC15V8jJFDhkvmKgFcycBaswleLM7NWZG1Hrd4PNHA95n5UfO04/UcDdl10IrKz6sTEKwE0AiupIqYag84Gcvw8oEXBNVBuaYROMhVLO8yoDqoxu3jBqJgmgqmXToljqYwKKwYStoxhoTcrSKSLvwvifA+cKbY4QgNH6Vv7BK1nbLWnkUVrSij9aM5CwrcM61x8fIwXRt73dEAdhlZe1rQeploGQZuyYLtXZGeH0IazNglDLsCj3WrRdoZsnsYIXWF35+zoZ7pm1orgUar2rJjN5K8hRLN7MSuwRtARHRu3NFjY1tCrrV625Cu74jRULmJoGQQ6SA2/0OwEmx7xXepWV6nrRjNIDVVYCZEtw/Faw6WuvQC6JVrokPrESntuwO3TB/ANN4a8jFEXVZpUffxjbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:04=E2=80=AFPM Thi=C3=A9baud Weksteen <tweek@goog=
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

Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>

For testing, I reverted the previous revert of the memfd_class policy
capability on selinux userspace, built and installed the modified
libsepol, and then followed the instructions in the testsuite commit
description.
Also confirmed manual execution of the tests in both enforcing and
permissive mode yields the expected behavior, and the WARN_ON() was
not triggered.

> ---
> Changes since v2:
> - Add WARN_ON when using unexpected class. Return -EACCES instead
>   of -EPERM
> - Remove extra new line
> - Rebase on selinux/dev
>
> Changes since v1:
> - Move test of class earlier in selinux_bprm_creds_for_exec
> - Remove duplicate call to security_transition_sid
>
> Changes since RFC:
> - Remove enum argument, simply compare the anon inode name
> - Introduce a policy capability for compatility
> - Add validation of class in selinux_bprm_creds_for_exec
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
> index 0e47b4bb8d40..2b685f9dd61d 100644
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
> @@ -2319,6 +2320,10 @@ static int selinux_bprm_creds_for_exec(struct linu=
x_binprm *bprm)
>         new_tsec =3D selinux_cred(bprm->cred);
>         isec =3D inode_security(inode);
>
> +       if (WARN_ON(isec->sclass !=3D SECCLASS_FILE &&
> +                   isec->sclass !=3D SECCLASS_MEMFD_FILE))
> +               return -EACCES;
> +
>         /* Default to the current task SID. */
>         new_tsec->sid =3D old_tsec->sid;
>         new_tsec->osid =3D old_tsec->sid;
> @@ -2371,8 +2376,8 @@ static int selinux_bprm_creds_for_exec(struct linux=
_binprm *bprm)
>         ad.u.file =3D bprm->file;
>
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
> @@ -2382,8 +2387,8 @@ static int selinux_bprm_creds_for_exec(struct linux=
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
> @@ -2978,10 +2983,18 @@ static int selinux_inode_init_security_anon(struc=
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
> @@ -3001,7 +3014,10 @@ static int selinux_inode_init_security_anon(struct=
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
> index 135a969f873c..231d02227e59 100644
> --- a/security/selinux/include/policycap.h
> +++ b/security/selinux/include/policycap.h
> @@ -18,6 +18,7 @@ enum {
>         POLICYDB_CAP_NETIF_WILDCARD,
>         POLICYDB_CAP_GENFS_SECLABEL_WILDCARD,
>         POLICYDB_CAP_FUNCTIONFS_SECLABEL,
> +       POLICYDB_CAP_MEMFD_CLASS,
>         __POLICYDB_CAP_MAX
>  };
>  #define POLICYDB_CAP_MAX (__POLICYDB_CAP_MAX - 1)
> diff --git a/security/selinux/include/policycap_names.h b/security/selinu=
x/include/policycap_names.h
> index ff8882887651..454dab37bda3 100644
> --- a/security/selinux/include/policycap_names.h
> +++ b/security/selinux/include/policycap_names.h
> @@ -21,6 +21,7 @@ const char *const selinux_policycap_names[__POLICYDB_CA=
P_MAX] =3D {
>         "netif_wildcard",
>         "genfs_seclabel_wildcard",
>         "functionfs_seclabel",
> +       "memfd_class",
>  };
>  /* clang-format on */
>
> diff --git a/security/selinux/include/security.h b/security/selinux/inclu=
de/security.h
> index 0f954a40d3fc..5d1dad8058b1 100644
> --- a/security/selinux/include/security.h
> +++ b/security/selinux/include/security.h
> @@ -209,6 +209,11 @@ static inline bool selinux_policycap_functionfs_secl=
abel(void)
>                 selinux_state.policycap[POLICYDB_CAP_FUNCTIONFS_SECLABEL]=
);
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

