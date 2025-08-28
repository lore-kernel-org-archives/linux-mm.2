Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E32BCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 13:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C1C68E0009; Thu, 28 Aug 2025 09:30:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 699E18E0006; Thu, 28 Aug 2025 09:30:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AF758E0009; Thu, 28 Aug 2025 09:30:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4583C8E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:30:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E3F921DA6FB
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:30:02 +0000 (UTC)
X-FDA: 83826249444.25.1F92E25
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id E4B11120006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:30:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C2VBSKDV;
	spf=pass (imf29.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756387801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4n0tum4VDah4U2bv7Oe7CW2rYIFPwcyA0fu9h3EYKtA=;
	b=Wf8pidBsdhdQNDn/y1iMxY9Mj16SuNy58ehDKBFcWLM5NVFbIuxsQx6LO4fvK+GZIhr5Bn
	C+GzeAuprgiFN5xbfTCbq/HBHHZWXuwKyZk53tVT92WmFNhNrFL6a14yMvz2IU/pKlrqO+
	/yD8meBIWcXvzsutOvOHztYVMD92a+g=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C2VBSKDV;
	spf=pass (imf29.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756387801; a=rsa-sha256;
	cv=none;
	b=28L6ZO6Qr5z0ggfyJAZMzuLADjG/5MjLQIxJOfrqHyixyqrdvhbTXxtrryqJYQRJeZK3oj
	BWb7WbLCtyXEf5MTlaUhTTDAvguCH5tm9eqDBxxmHLxCuK+LkVKOp026CHJQ5/DNPAGtNa
	qdy7SbmtTeKqtzwvlb5G3h8EtQQDHAA=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3277c603b83so572722a91.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756387800; x=1756992600; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4n0tum4VDah4U2bv7Oe7CW2rYIFPwcyA0fu9h3EYKtA=;
        b=C2VBSKDVDgrfAiew4AoZLjtGKDpxWdILtvel3d32+L+kYNFeyCMM1Fe6dNK9sdkJ9W
         KBBWLt0iJF2dYbcF2VrKhr8duwNbIb7FU05DxtirG+XODmgTA4UhSS5tpgAagK22RzAI
         rJngnprbq5C4ZbsCub9w+Hnlo5eIPbaDuN3cL8lgEbeNiVwQvP8n47E7CRPsPSbDAK5e
         cxek4maX5AKoax+CZl4wt/hIxU9RCfGGL0g2nOSj06ibhivGRI6UUP/uVCQKIl7vWCWl
         DdhNYbXDe3pE/ts09fc9uTQEdD1ID55hAYM8LLLdaiViQdhsdyd3e1DbT9l4mGXFnpxa
         xsfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756387800; x=1756992600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4n0tum4VDah4U2bv7Oe7CW2rYIFPwcyA0fu9h3EYKtA=;
        b=QNFRw1/s0s9MPpKfiD3Z3yAvriH3M/6rmEUomPYrCH18VxZtcMfOGVh6ebbV3U43j6
         IUbAlYX0YW73tE6wztHhn4ooOx7syjN805SpM54BN/7UPKObu+YPiYYIaj5tWGWVJCo8
         rcESGQmVHRBNqUsEC0U17Gs2yMYuPGXooPkH37qdPlCK3f46YIy0iKU9R9P/hp94OVic
         8T7Nk1Y5aQ6EWhmaUoVLwFECGVXy0dNVuEFjDvVnTJwAHJQgd1EHEQMH/1swiTHB7vwl
         EgCcmuVDsPjpL259oRdrvZ0GijLMK3To7Mk7VeFXZdGajyI9zHN2UOYdOCcVLEMrXFzx
         TSVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYgIAlftzCGRjFoCoZxbsd0LflVWBF+tknFrDPm09gx+OJ5ocUr2Ia24x2BsMbAlI/+0s96NxlfA==@kvack.org
X-Gm-Message-State: AOJu0YyLFgle42bBZYUe+ElWxZZ9Om+Srpa9BwbTkxDTqVevtOdEOTGd
	rn8Q5fYNGql7wcbvjCZx/v74VQjhwRYcgAIcDo8rqzgDWPN22QjbqRy6hHLYKCrG+gV7iGZfiM9
	ZBQas6iIOZGdHOZtZWLMlULkUOrAA53o2lg==
X-Gm-Gg: ASbGncvh9Go9frbwNmmjO5PIDEhr+qd/jVyF63rXQYkn1Jq/eaelbtX9tjTWsuwQ7g3
	/sR+UVzFgQhz5XVnBAYW7MpsiY7H6sthbppOoriNfxTbXaVnOUlIBo+I+4WT6mOCH8fGdrFbKpF
	URZ9sHXGAvhDPmCyH2IKt0rrd24M4WZ9YIrS3SOUAt2g2MNnfoSiGsYW42lcLLNzLPrhCHnjTei
	NInhHc=
X-Google-Smtp-Source: AGHT+IF9fxo38tdSY1lXKPcvTKCu7yLbvImIstAsgUDP9cqGG5UHtxAtT+n8efcbSbsUybFZ0Kmprvh8bhLl5dF+eSA=
X-Received: by 2002:a17:90b:1fce:b0:327:ceb0:6f6a with SMTP id
 98e67ed59e1d1-327ceb07148mr783409a91.4.1756387799474; Thu, 28 Aug 2025
 06:29:59 -0700 (PDT)
MIME-Version: 1.0
References: <20250826031824.1227551-1-tweek@google.com> <CAEjxPJ6G2iK9Yp8eCwbwHQfF1J3WBEVU42kAMQHNuuC_H5QHNw@mail.gmail.com>
In-Reply-To: <CAEjxPJ6G2iK9Yp8eCwbwHQfF1J3WBEVU42kAMQHNuuC_H5QHNw@mail.gmail.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Thu, 28 Aug 2025 09:29:48 -0400
X-Gm-Features: Ac12FXwihC1jaP0Hmcu35QtchrNt5_UC4cuegSSxvaLhssrES19Bc258iqePTuk
Message-ID: <CAEjxPJ70O5SY=XYJKrQDLkHOO3spD4VSjYCv0LkhYKCvK=GP7Q@mail.gmail.com>
Subject: Re: [PATCH] memfd,selinux: call security_inode_init_security_anon
To: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	Hugh Dickins <hughd@google.com>, Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, 
	Jeff Xu <jeffxu@google.com>, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xtm66m6i97sbzw7oxx3ei7cozx1ohd8o
X-Rspam-User: 
X-Rspamd-Queue-Id: E4B11120006
X-Rspamd-Server: rspam01
X-HE-Tag: 1756387800-340306
X-HE-Meta: U2FsdGVkX18zdNHSZSO60+AZFLZxOHocj+nSCgsB9k46R6Pq0u6gNkux0OPT/uNbc/YO7fLAaHwxTV1RuOl3ImO/zJuLxZ/PKVDDRMP/dv2f1AFGNxSb0PCfUwAO3euJSGaPYeDNCSedtEPW66OJmB/jDKgpN0yUJX3gcsPGvgRPR0vYmmJ8pqZ70zvmtxD3cuar3X5kITlmKddjK8pl3Ak1lG5u0VTapfIrrmgENQ32nvRbX08vczC9GRaFVu1a9apLnyHOIsq5ut4znOt25iIAEor8ljDFXfQt76TJyMG0FkTK6z2VquauLn7u3xXS9e4UYeEkv+buHYOcCHzmiSAAuWV3p6Nm4hOXt7CYE4jDvw/e6uX6CAoAmeJS67JcNE3GpZGX6oIUYuR/EObi59FdF3awVygWXMtHAjOeta+j9nAdXrmM583pi2NYlH6zOrtfq9oAEeuGri/Kyv1Jtg/q9IpoSuxbQpBvtNo5MxEf2i2ib2ujaSSlrzHKhOLxtxdq7yd+NrekoX7HgQrEUIXk4a3AM44dzobH3iypH+v912ldm3tbp7Lwf65FI1+4MKNfG/TzUTYkfpLAj0IOQzxdN/LmTT+9ZawiSbycXLaFhu9txXen4jLBChIk5z/53O2bOxdt8ZI1foFRjxyouXXob8zkXu3fCs1+J9mPjUOm/t0HTg7dcBV8GgreRwnYVG58WJwVo0lk8neCiSsLeNGOWaQQtmIEq1/PBsNNdEeikPj7vq/WaGNw0dTB57RRQVEk/leJl1zyHiRJaj0ceqiVSXC4MGtAdg1vDYax2X7+FXDYEDo/26bzc5PuEYOsYV0KxdT7dFlqhr0Ys5dq/xHDYSoRFv3OQlw8B68WZrQeSWLRB9n1Ii51ft7mahWSDj3SW/YgEIqe6j2hcT9WXSWhAzWctHMQgmAvlkCaNcLyUfs6bQody02J1FfusP8LMO6fC3hsm2MVNo/1dpz
 EQJXxOrM
 fgI7dVrvXwkdHtkJqIqKIjc1rIvtC9twCqossoisRRPQJxLCzJ58P5HTH4/+ysFam/RpQyGUPNVvPB+xLCZPoYDTOh5MW1PemE8lw/ExStjGsuSHZWHI/I8brchZz3alM0Cs/zkKqCZ/GHGGJGZWt6bZrC+JIXu//VFBEAF3qCXRGaZfARc7k/j9RjHNW7bC+IR9f0VTxd2stoh8u1rJrN5nVpfqjEQmkZC3f8GKU5shWIg+QzAtWFanx07l690c8QTf8zt3Me/gzneVqkg6Iya0+hxdWsIw1R6Q1cJp4uhbv3Q4yj7Tr89K0OyWGJusx7GBVhUyMI+iluau7g8PhGOd6mMcm2pZx23SkRU+6PYJN33hxw4bIvoXVT5gSRg86/MFMThBoA1yQIT4fs2nx4/WvEqwAR0+PjxuHqO+QJlLK2ybElZVU7+aroVzr2S0MXHYdy9Hd2keI1AyfQlwtCsGI1WVkHKfmHPQsn9XWtoXTlerT7FWJuvhqTD8RNQJoWI+Jkpu9gB8he9a+AJHQ4Oj90zPp6//KVHrJzkfXCIFsZ0KbyI1aCoPcDr3TOBVRd6MDQjQ7PsIKh4KMLgkOpd36EfCIOzN19l5NtkF8BWFPYfaEzr6wkl1EWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 9:23=E2=80=AFAM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
>
> On Mon, Aug 25, 2025 at 11:18=E2=80=AFPM Thi=C3=A9baud Weksteen <tweek@go=
ogle.com> wrote:
> >
> > Prior to this change, no security hooks were called at the creation of =
a
> > memfd file. It means that, for SELinux as an example, it will receive
> > the default type of the filesystem that backs the in-memory inode. In
> > most cases, that would be tmpfs, but if MFD_HUGETLB is passed, it will
> > be hugetlbfs. Both can be considered implementation details of memfd.
> >
> > It also means that it is not possible to differentiate between a file
> > coming from memfd_create and a file coming from a standard tmpfs mount
> > point.
> >
> > Additionally, no permission is validated at creation, which differs fro=
m
> > the similar memfd_secret syscall.
> >
> > Call security_inode_init_security_anon during creation. This ensures
> > that the file is setup similarly to other anonymous inodes. On SELinux,
> > it means that the file will receive the security context of its task.
> >
> > The ability to limit fexecve on memfd has been of interest to avoid
> > potential pitfalls where /proc/self/exe or similar would be executed
> > [1][2]. Reuse the "execute_no_trans" and "entrypoint" access vectors,
> > similarly to the file class. These access vectors may not make sense fo=
r
> > the existing "anon_inode" class. Therefore, define and assign a new
> > class "memfd_file" to support such access vectors.
> >
> > Guard these changes behind a new policy capability named "memfd_class".
> >
> > [1] https://crbug.com/1305267
> > [2] https://lore.kernel.org/lkml/20221215001205.51969-1-jeffxu@google.c=
om/
> >
> > Signed-off-by: Thi=C3=A9baud Weksteen <tweek@google.com>
>
> This looks good to me, but do you have a test for it, preferably via
> patch for the selinux-testsuite?
> See https://github.com/SELinuxProject/selinux-testsuite/commit/023b79b831=
9e5fe222fb5af892c579593e1cbc50
> for an example.
>
> Otherwise, you can add my:
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>

Also, we'll need a corresponding patch to define the new policy
capability in libsepol, and will need to de-conflict with the other
pending patches that are also trying to claim the next available
policy capability bit (so you may end up with a different one
upstream).

>
> > ---
> > Changes since RFC:
> > - Remove enum argument, simply compare the anon inode name
> > - Introduce a policy capability for compatility
> > - Add validation of class in selinux_bprm_creds_for_exec
> >
> >  include/linux/memfd.h                      |  2 ++
> >  mm/memfd.c                                 | 14 +++++++++--
> >  security/selinux/hooks.c                   | 27 ++++++++++++++++++----
> >  security/selinux/include/classmap.h        |  2 ++
> >  security/selinux/include/policycap.h       |  1 +
> >  security/selinux/include/policycap_names.h |  1 +
> >  security/selinux/include/security.h        |  5 ++++
> >  7 files changed, 46 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/memfd.h b/include/linux/memfd.h
> > index 6f606d9573c3..cc74de3dbcfe 100644
> > --- a/include/linux/memfd.h
> > +++ b/include/linux/memfd.h
> > @@ -4,6 +4,8 @@
> >
> >  #include <linux/file.h>
> >
> > +#define MEMFD_ANON_NAME "[memfd]"
> > +
> >  #ifdef CONFIG_MEMFD_CREATE
> >  extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned =
int arg);
> >  struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx);
> > diff --git a/mm/memfd.c b/mm/memfd.c
> > index bbe679895ef6..63b439eb402a 100644
> > --- a/mm/memfd.c
> > +++ b/mm/memfd.c
> > @@ -433,6 +433,8 @@ static struct file *alloc_file(const char *name, un=
signed int flags)
> >  {
> >         unsigned int *file_seals;
> >         struct file *file;
> > +       struct inode *inode;
> > +       int err =3D 0;
> >
> >         if (flags & MFD_HUGETLB) {
> >                 file =3D hugetlb_file_setup(name, 0, VM_NORESERVE,
> > @@ -444,12 +446,20 @@ static struct file *alloc_file(const char *name, =
unsigned int flags)
> >         }
> >         if (IS_ERR(file))
> >                 return file;
> > +
> > +       inode =3D file_inode(file);
> > +       err =3D security_inode_init_security_anon(inode,
> > +                       &QSTR(MEMFD_ANON_NAME), NULL);
> > +       if (err) {
> > +               fput(file);
> > +               file =3D ERR_PTR(err);
> > +               return file;
> > +       }
> > +
> >         file->f_mode |=3D FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
> >         file->f_flags |=3D O_LARGEFILE;
> >
> >         if (flags & MFD_NOEXEC_SEAL) {
> > -               struct inode *inode =3D file_inode(file);
> > -
> >                 inode->i_mode &=3D ~0111;
> >                 file_seals =3D memfd_file_seals_ptr(file);
> >                 if (file_seals) {
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index c95a5874bf7d..429b2269b35a 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -93,6 +93,7 @@
> >  #include <linux/fanotify.h>
> >  #include <linux/io_uring/cmd.h>
> >  #include <uapi/linux/lsm.h>
> > +#include <linux/memfd.h>
> >
> >  #include "avc.h"
> >  #include "objsec.h"
> > @@ -2366,9 +2367,12 @@ static int selinux_bprm_creds_for_exec(struct li=
nux_binprm *bprm)
> >         ad.type =3D LSM_AUDIT_DATA_FILE;
> >         ad.u.file =3D bprm->file;
> >
> > +       if (isec->sclass !=3D SECCLASS_FILE && isec->sclass !=3D SECCLA=
SS_MEMFD_FILE)
> > +               return -EPERM;
> > +
> >         if (new_tsec->sid =3D=3D old_tsec->sid) {
> > -               rc =3D avc_has_perm(old_tsec->sid, isec->sid,
> > -                                 SECCLASS_FILE, FILE__EXECUTE_NO_TRANS=
, &ad);
> > +               rc =3D avc_has_perm(old_tsec->sid, isec->sid, isec->scl=
ass,
> > +                                 FILE__EXECUTE_NO_TRANS, &ad);
> >                 if (rc)
> >                         return rc;
> >         } else {
> > @@ -2378,8 +2382,8 @@ static int selinux_bprm_creds_for_exec(struct lin=
ux_binprm *bprm)
> >                 if (rc)
> >                         return rc;
> >
> > -               rc =3D avc_has_perm(new_tsec->sid, isec->sid,
> > -                                 SECCLASS_FILE, FILE__ENTRYPOINT, &ad)=
;
> > +               rc =3D avc_has_perm(new_tsec->sid, isec->sid, isec->scl=
ass,
> > +                                 FILE__ENTRYPOINT, &ad);
> >                 if (rc)
> >                         return rc;
> >
> > @@ -2974,10 +2978,18 @@ static int selinux_inode_init_security_anon(str=
uct inode *inode,
> >         struct common_audit_data ad;
> >         struct inode_security_struct *isec;
> >         int rc;
> > +       bool is_memfd =3D false;
> >
> >         if (unlikely(!selinux_initialized()))
> >                 return 0;
> >
> > +       if (name !=3D NULL && name->name !=3D NULL &&
> > +           !strcmp(name->name, MEMFD_ANON_NAME)) {
> > +               if (!selinux_policycap_memfd_class())
> > +                       return 0;
> > +               is_memfd =3D true;
> > +       }
> > +
> >         isec =3D selinux_inode(inode);
> >
> >         /*
> > @@ -2996,6 +3008,13 @@ static int selinux_inode_init_security_anon(stru=
ct inode *inode,
> >
> >                 isec->sclass =3D context_isec->sclass;
> >                 isec->sid =3D context_isec->sid;
> > +       } else if (is_memfd) {
> > +               isec->sclass =3D SECCLASS_MEMFD_FILE;
> > +               rc =3D security_transition_sid(
> > +                       sid, sid,
> > +                       isec->sclass, name, &isec->sid);
> > +               if (rc)
> > +                       return rc;
> >         } else {
> >                 isec->sclass =3D SECCLASS_ANON_INODE;
> >                 rc =3D security_transition_sid(
> > diff --git a/security/selinux/include/classmap.h b/security/selinux/inc=
lude/classmap.h
> > index 5665aa5e7853..3ec85142771f 100644
> > --- a/security/selinux/include/classmap.h
> > +++ b/security/selinux/include/classmap.h
> > @@ -179,6 +179,8 @@ const struct security_class_mapping secclass_map[] =
=3D {
> >         { "anon_inode", { COMMON_FILE_PERMS, NULL } },
> >         { "io_uring", { "override_creds", "sqpoll", "cmd", "allowed", N=
ULL } },
> >         { "user_namespace", { "create", NULL } },
> > +       { "memfd_file",
> > +         { COMMON_FILE_PERMS, "execute_no_trans", "entrypoint", NULL }=
 },
> >         /* last one */ { NULL, {} }
> >  };
> >
> > diff --git a/security/selinux/include/policycap.h b/security/selinux/in=
clude/policycap.h
> > index 7405154e6c42..dabcc9f14dde 100644
> > --- a/security/selinux/include/policycap.h
> > +++ b/security/selinux/include/policycap.h
> > @@ -17,6 +17,7 @@ enum {
> >         POLICYDB_CAP_NETLINK_XPERM,
> >         POLICYDB_CAP_NETIF_WILDCARD,
> >         POLICYDB_CAP_GENFS_SECLABEL_WILDCARD,
> > +       POLICYDB_CAP_MEMFD_CLASS,
> >         __POLICYDB_CAP_MAX
> >  };
> >  #define POLICYDB_CAP_MAX (__POLICYDB_CAP_MAX - 1)
> > diff --git a/security/selinux/include/policycap_names.h b/security/seli=
nux/include/policycap_names.h
> > index d8962fcf2ff9..8e96f2a816b6 100644
> > --- a/security/selinux/include/policycap_names.h
> > +++ b/security/selinux/include/policycap_names.h
> > @@ -20,6 +20,7 @@ const char *const selinux_policycap_names[__POLICYDB_=
CAP_MAX] =3D {
> >         "netlink_xperm",
> >         "netif_wildcard",
> >         "genfs_seclabel_wildcard",
> > +       "memfd_class",
> >  };
> >  /* clang-format on */
> >
> > diff --git a/security/selinux/include/security.h b/security/selinux/inc=
lude/security.h
> > index 8201e6a3ac0f..72c963f54148 100644
> > --- a/security/selinux/include/security.h
> > +++ b/security/selinux/include/security.h
> > @@ -209,6 +209,11 @@ static inline bool selinux_policycap_netif_wildcar=
d(void)
> >                 selinux_state.policycap[POLICYDB_CAP_NETIF_WILDCARD]);
> >  }
> >
> > +static inline bool selinux_policycap_memfd_class(void)
> > +{
> > +       return READ_ONCE(selinux_state.policycap[POLICYDB_CAP_MEMFD_CLA=
SS]);
> > +}
> > +
> >  struct selinux_policy_convert_data;
> >
> >  struct selinux_load_state {
> > --
> > 2.51.0.261.g7ce5a0a67e-goog
> >

