Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21920CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 05:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E2D08E0002; Tue, 16 Sep 2025 01:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 493218E0001; Tue, 16 Sep 2025 01:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A8A28E0002; Tue, 16 Sep 2025 01:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2725D8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:07:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0C81C084C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:07:52 +0000 (UTC)
X-FDA: 83893931184.29.4E2EF7A
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id E120F1C0010
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:07:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lCjOFxuZ;
	spf=pass (imf18.hostedemail.com: domain of hughd@google.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757999271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1+qmsLaQYfIFnfOnViE0APxpYe9wnZszmNaZLIS/hLg=;
	b=5WKyg/bXmB0XDxr0OgujsNr5gyOuCfjns8c+Ky75yWHNV3PB8ROKfcKUMFb4xJdZdh1MbE
	d3VBmIGYI6gNpQojdCnkCB+BI0Gm5tm30lq3yl6gSzll+kEFPZtEIKeO5Fjj2kSj0c9zJ1
	L39ESbGrnBjPJkNrJfyzYkRwZ142+t0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lCjOFxuZ;
	spf=pass (imf18.hostedemail.com: domain of hughd@google.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757999271; a=rsa-sha256;
	cv=none;
	b=MxzkxdxqU2U9ybNmU8bYBAGg0Gud37EWPJJhHpp5f55PZoTJm7kFNkwnk6r6UY+go4DXa5
	qxQemqrgiFnFbXUwUQDM82muGxkyAH8WrSbOqtmJngiMXHnsIRSIyRU31uUYQrglVJnOuI
	Z9ts/ty1Tb9gCAIDra+Oq5wmT55s5yM=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-77251d7cca6so4777932b3a.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757999270; x=1758604070; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1+qmsLaQYfIFnfOnViE0APxpYe9wnZszmNaZLIS/hLg=;
        b=lCjOFxuZVu87uQIs8VYl7c7C11/MRUJ3F8GVVM/XypDHojbSctfBtV5cTlAlqeoOwl
         i58vCj8Tb28QuM5eBhj+g9x3m6CDYBB8P70dR0CmAsaILACPgU9ce4DoS+4E9c+NQAkM
         ResjUb2GBtZJrEqKPDGh9XCtwnTzqDiRM1yKmQDnkyH2ScvPBMiQOHZj0tAif5QDJjcx
         Pco35Bv1gUGNlKyBCBujHmQu1bSc7Jg8wP9Hbcnox509d+XOujxwlqlndpLOhzTpG9XU
         g5iX7ZqEcWJBzaDtNJttjnIQTP9C4d8riKqEewg3Z1s39lQbn5ysc1zjRdmpVcSZEIrY
         E77g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757999270; x=1758604070;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1+qmsLaQYfIFnfOnViE0APxpYe9wnZszmNaZLIS/hLg=;
        b=gThEs9FIjGX64Vrbez4PSIY/HtYs9cbQqLz9qEqT5AnP+BcMjq15aZm4tkne8UdK7C
         jraOD5SP9jX/dMGAaqzg6qtIUBumMAfazucdnX0jiNqwuStwMEaDVdOpah3g0jAjgjkt
         DfTx3v6hapEU0WvSQ9aAz5Xr6fCP2onjx5wGVYZ3FYHPXy8IyZuMoRTk4X6Oz2Nbmep0
         y5rOwZsQM2C++OVUtQTe0Re4ed1WZqIEQJl1TZ9aWP6Ce0zwjy8U5G0xQGyvxszHWBVx
         1cU7onqKAtVfqwO2tYvHkQiOpMdLKAZjdcg2X2bqp4fGGTAuxEOwzrYJ8n5CSOIdnjhQ
         HgMg==
X-Forwarded-Encrypted: i=1; AJvYcCVatAq3q0fUV0iP4pqKM3upLLBl/m8jrsabOtqMZ47AxJ/a8k8RLgk86vRN1LsRIACsGWECTV1DgQ==@kvack.org
X-Gm-Message-State: AOJu0YzWaA+em5wsJvqr6J2YmUZT3/VvktcIgq6ZUGH+i9bSHgJZOsYX
	N7U7kq3mkN0vj8Oo00TfEbqFBing7wSlz10UPPXTWywBgK7N6Qq6tpbQVJccgtWQTQ==
X-Gm-Gg: ASbGnctpCderRxs02LOfUoS8BpO2BnxrxFk8Nep9VHHvUFZbUCD/utYc7iw4wD4oZSa
	sXQsmwhzk7ZwI8q0siDa1YOKIadthNG9P5+UU5eigCEgDrnBUp0/8dFyE2TF5LfDBgDj0vQQRco
	Q1DHoAcVFLEW3rlc+lfAMYF/OrPh/l75dsbi9fnWmAuFL/rV4aoyY/pObPIwmWV2k+0rr/UEIBG
	ASVvTBx4do+yls3AX2k//hjDkwSdSYKb6FIDkDoAW0kXRoOKJCfIZ6+9DEAZuJb6ihCkhvb2bFD
	6Me9+nDAVMWVrxs02QEqy23FA8VddmBtiqGE2lX53drtpzz6jK+Xb/P2ozVOuEd3ZRvTHnUbjcX
	CpXta8coXq1AQtzK1aHVfJu1F9vV7DCp5qMBQoAPH9Mr0Y15mvJNvMDqAg5Z/w7PFXvfHYwlv41
	tgvPT+n4zKJAytvty9+xs0CIgI
X-Google-Smtp-Source: AGHT+IE67V0/Q7PMyxtMDe4Dx+1Y/Qbj1MBm0zEQYVlSQIpIVrmBipbiYSmuQN2+gYdoKBRHHyil8Q==
X-Received: by 2002:a05:6a00:a88f:b0:776:139d:cccb with SMTP id d2e1a72fcca58-776139dcdf7mr17285388b3a.28.1757999269172;
        Mon, 15 Sep 2025 22:07:49 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607a47310sm14496490b3a.27.2025.09.15.22.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 22:07:48 -0700 (PDT)
Date: Mon, 15 Sep 2025 22:06:52 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Paul Moore <paul@paul-moore.com>
cc: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
    James Morris <jmorris@namei.org>, 
    Stephen Smalley <stephen.smalley.work@gmail.com>, 
    Hugh Dickins <hughd@google.com>, Jeff Vander Stoep <jeffv@google.com>, 
    Nick Kralevich <nnk@google.com>, Jeff Xu <jeffxu@google.com>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org, 
    linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
    linux-mm@kvack.org
Subject: Re: [PATCH] memfd,selinux: call security_inode_init_security_anon
In-Reply-To: <6afc91a9f5caef96b2ca335b6d143670@paul-moore.com>
Message-ID: <92255d5e-7e0a-6ca3-3169-114ae7f6247f@google.com>
References: <20250826031824.1227551-1-tweek@google.com> <6afc91a9f5caef96b2ca335b6d143670@paul-moore.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463770367-1767593222-1757999268=:21221"
X-Stat-Signature: 6dgycf7dwuxe6gxqf85eqqf9jirc6cbo
X-Rspam-User: 
X-Rspamd-Queue-Id: E120F1C0010
X-Rspamd-Server: rspam04
X-HE-Tag: 1757999270-679887
X-HE-Meta: U2FsdGVkX1+w32VuF2EkFsAmJ5+cE0WqkgjkJ5KJ6/DnS4UI204u2DGAtB7P3+I+RXIj0gclVcKGhwCHu4wjCeDnV9gugmq81zoZkEHT0aAkbDeKoiSyFH5DHCWZ95oYBaXfMgNIXobEuGoh+da/DD6Oyp4kwlsL6GHS3fBMZVYolGY9iqm5UM4Z+/FHOFcBpGIGk2zkpv5Ux49JxDrzZ0oC8730VqliNUht1/QZ8K6l2PR5RUd5KSaPu3TbQl0fE/2oBmu/JKWIffxsHEtHAcfM6ueRM/dcXRpHD0SujRrV6EaA79JQQVVk6eBnq5k7Y+vx0imm1/URIiEKAKEgkyCy35jopaaiBnwX5RGcMyn40HLqyk14gtDXyr5fk/Gc1h2ikdt75OUgefqokcy8AoSVU7g7vCoD0TIQ8WWDLK6tOR81ZgMBFjGuFTbB4eodQcVQcGM5p2+FknslMzYDIgg4LTrEhQaIWVkvxJmcNXnno9+IVQ4iOcnMMAGQc7QmPER3wZyufYmkAHghJsDL7d1XPZO/uBarlMNFm+fuP+Pr+Q1kcDibCJkrgjGft4IcIv9HMzllw98Sx2NEPYRVSq8PVbe9hFv0xnvbv5/yqKp8xxTB0FI+efBwDABBXLAO6EsiIwVoZLsqUW89yAHwF8IhpjhdIWBSsQZUwbNhvnxG39QWFXM16VZZRs04gXdHR5L7LnF8aliJBaS30u61ElCB9cXuE3zrTxwKXcoByH0Bir3ThP7kNl5cJS1TqYUcd+Q6OtfBZOf7MSFSVAdu5j3+VUsLprG1SnRTg6EnZ1fhpz6roqbbsfEslB1y/cx9aa4/li6hysulBqhi/i3+QvT7wXbkCxB0HxZZ9zHYykpI8hNkY3m29uSDWYPkrxdgifaCgOY7Ko/xkYa0XGl08rFgT5sibWMiVGVXuFKxg/UwhFGW8G2Lpegu05B8FOYkXKOOBCz0k9htnSsGvib
 mZFuvzdh
 b1THi/Onkfl2Xk4p/zTPtT9901Qb3jVtdvSlxQU+FVIOKvWHYA1X2k+bURqQHvReuVpddDvXpZKuMobrzxLFn9TZOlmlFzRqSmeVnMwGrKJSSQW949fxgJK8XG4LeCbTCVlX65op2O6GL1afUazsZy+gmYEmdIrELZOdSjDlfvRQXCQ7jdFIl9zanGdbkgkmF8HglXrjo08T24mp6na8Uv/fNGEqmeSxf9aCX9d/Mz8gfyZ9j8ic/aIaJQeU3f3ajO4B+F/cT+FLYKgd/9VlVS01XwCwjY/q0WVgsS2jptbeR0w9g72sAFHM/SYR55jHwd+uWUTCMUevcCquzEIpiM3sqHsdkfYNJsLjzaG+TNtgN2zUNbnbpjUvSWI3VrN4ZzMAk0w+JTzVkfaSxK52qtTQ71BvbqdmwNrmitM3DyyG+ijYxSM4Wxo5SAC+Tr9UgxxZ3PbWucg42irWzSoYr927iNSwjf1o4c7XKJX7CoWXFNXJyvSZc9hH0YlnCRaA7+BOhl9gP34eF7n1duXmKOPaeP0Q5VUK+b/2lP/kUzNkhZA/nLwVEBsWybVd8ggVOO/DqCRDopn9nqFlgWEUXtPTqdIxh+j34F8oIj/sQS6fna8mndMaDUD3JrgKe+WtY4Nio1KVSBFos/WaYsTxrlfPcibzJKEenAwvtA/4Wrk/Fhe3LtH18fCt6dm0nz8/42wqqzkyN2k/MVhY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463770367-1767593222-1757999268=:21221
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 3 Sep 2025, Paul Moore wrote:
> On Aug 25, 2025 "=3D?UTF-8?q?Thi=3DC3=3DA9baud=3D20Weksteen?=3D" <tweek@g=
oogle.com> wrote:
> >=20
> > Prior to this change, no security hooks were called at the creation of =
a
> > memfd file. It means that, for SELinux as an example, it will receive
> > the default type of the filesystem that backs the in-memory inode. In
> > most cases, that would be tmpfs, but if MFD_HUGETLB is passed, it will
> > be hugetlbfs. Both can be considered implementation details of memfd.
> >=20
> > It also means that it is not possible to differentiate between a file
> > coming from memfd_create and a file coming from a standard tmpfs mount
> > point.
> >=20
> > Additionally, no permission is validated at creation, which differs fro=
m
> > the similar memfd_secret syscall.
> >=20
> > Call security_inode_init_security_anon during creation. This ensures
> > that the file is setup similarly to other anonymous inodes. On SELinux,
> > it means that the file will receive the security context of its task.
> >=20
> > The ability to limit fexecve on memfd has been of interest to avoid
> > potential pitfalls where /proc/self/exe or similar would be executed
> > [1][2]. Reuse the "execute_no_trans" and "entrypoint" access vectors,
> > similarly to the file class. These access vectors may not make sense fo=
r
> > the existing "anon_inode" class. Therefore, define and assign a new
> > class "memfd_file" to support such access vectors.
> >=20
> > Guard these changes behind a new policy capability named "memfd_class".
> >=20
> > [1] https://crbug.com/1305267
> > [2] https://lore.kernel.org/lkml/20221215001205.51969-1-jeffxu@google.c=
om/
> >=20
> > Signed-off-by: Thi=C3=A9baud Weksteen <tweek@google.com>
> > Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> > Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> > ---
> > Changes since RFC:
> > - Remove enum argument, simply compare the anon inode name
> > - Introduce a policy capability for compatility
> > - Add validation of class in selinux_bprm_creds_for_exec
> >=20
> >  include/linux/memfd.h                      |  2 ++
> >  mm/memfd.c                                 | 14 +++++++++--
> >  security/selinux/hooks.c                   | 27 ++++++++++++++++++----
> >  security/selinux/include/classmap.h        |  2 ++
> >  security/selinux/include/policycap.h       |  1 +
> >  security/selinux/include/policycap_names.h |  1 +
> >  security/selinux/include/security.h        |  5 ++++
> >  7 files changed, 46 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/include/linux/memfd.h b/include/linux/memfd.h
> > index 6f606d9573c3..cc74de3dbcfe 100644
> > --- a/include/linux/memfd.h
> > +++ b/include/linux/memfd.h
> > @@ -4,6 +4,8 @@
> > =20
> >  #include <linux/file.h>
> > =20
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
> >  =09unsigned int *file_seals;
> >  =09struct file *file;
> > +=09struct inode *inode;
> > +=09int err =3D 0;
> > =20
> >  =09if (flags & MFD_HUGETLB) {
> >  =09=09file =3D hugetlb_file_setup(name, 0, VM_NORESERVE,
> > @@ -444,12 +446,20 @@ static struct file *alloc_file(const char *name, =
unsigned int flags)
> >  =09}
> >  =09if (IS_ERR(file))
> >  =09=09return file;
> > +
> > +=09inode =3D file_inode(file);
> > +=09err =3D security_inode_init_security_anon(inode,
> > +=09=09=09&QSTR(MEMFD_ANON_NAME), NULL);
> > +=09if (err) {
> > +=09=09fput(file);
> > +=09=09file =3D ERR_PTR(err);
> > +=09=09return file;
> > +=09}
> > +
> >  =09file->f_mode |=3D FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
> >  =09file->f_flags |=3D O_LARGEFILE;
> > =20
> >  =09if (flags & MFD_NOEXEC_SEAL) {
> > -=09=09struct inode *inode =3D file_inode(file);
> > -
> >  =09=09inode->i_mode &=3D ~0111;
> >  =09=09file_seals =3D memfd_file_seals_ptr(file);
> >  =09=09if (file_seals) {
>=20
> Hugh, Baolin, and shmem/mm folks, are you okay with the changes above? If
> so it would be nice to get an ACK from one of you.

So far as I can tell, seems okay to me:
Acked-by: Hugh Dickins <hughd@google.com>

If I'd responded earlier (sorry), I would have asked for it just to use
&QSTR("[memfd]") directly in the call, rather than indirecting through
unnecessary #define MEMFD_ANON_NAME "[memfd]"; never mind, that's all.

Please do take this, along with the rest, through your security tree:
mm.git contains no conflicting change to mm/memfd.c at present.

Thanks,
Hugh

>=20
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index c95a5874bf7d..429b2269b35a 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -93,6 +93,7 @@
> >  #include <linux/fanotify.h>
> >  #include <linux/io_uring/cmd.h>
> >  #include <uapi/linux/lsm.h>
> > +#include <linux/memfd.h>
> > =20
> >  #include "avc.h"
> >  #include "objsec.h"
> > @@ -2366,9 +2367,12 @@ static int selinux_bprm_creds_for_exec(struct li=
nux_binprm *bprm)
> >  =09ad.type =3D LSM_AUDIT_DATA_FILE;
> >  =09ad.u.file =3D bprm->file;
> > =20
> > +=09if (isec->sclass !=3D SECCLASS_FILE && isec->sclass !=3D SECCLASS_M=
EMFD_FILE)
> > +=09=09return -EPERM;
>=20
> In the interest of failing fast, this should probably be moved up in the
> function to just after where @isec is set.  There are also a number of
> checks that happen prior to this placement, but after the isec assignment=
=2E
> While I don't think any of those checks should be an issue, I'd rather
> not to have to worry about those and just fail the non-FILE/MEMFD_FILE
> case as soon as we can in selinux_bprm_creds_for_exec().
>=20
> >  =09if (new_tsec->sid =3D=3D old_tsec->sid) {
> > -=09=09rc =3D avc_has_perm(old_tsec->sid, isec->sid,
> > -=09=09=09=09  SECCLASS_FILE, FILE__EXECUTE_NO_TRANS, &ad);
> > +=09=09rc =3D avc_has_perm(old_tsec->sid, isec->sid, isec->sclass,
> > +=09=09=09=09  FILE__EXECUTE_NO_TRANS, &ad);
> >  =09=09if (rc)
> >  =09=09=09return rc;
> >  =09} else {
> > @@ -2378,8 +2382,8 @@ static int selinux_bprm_creds_for_exec(struct lin=
ux_binprm *bprm)
> >  =09=09if (rc)
> >  =09=09=09return rc;
> > =20
> > -=09=09rc =3D avc_has_perm(new_tsec->sid, isec->sid,
> > -=09=09=09=09  SECCLASS_FILE, FILE__ENTRYPOINT, &ad);
> > +=09=09rc =3D avc_has_perm(new_tsec->sid, isec->sid, isec->sclass,
> > +=09=09=09=09  FILE__ENTRYPOINT, &ad);
> >  =09=09if (rc)
> >  =09=09=09return rc;
> > =20
> > @@ -2974,10 +2978,18 @@ static int selinux_inode_init_security_anon(str=
uct inode *inode,
> >  =09struct common_audit_data ad;
> >  =09struct inode_security_struct *isec;
> >  =09int rc;
> > +=09bool is_memfd =3D false;
> > =20
> >  =09if (unlikely(!selinux_initialized()))
> >  =09=09return 0;
> > =20
> > +=09if (name !=3D NULL && name->name !=3D NULL &&
> > +=09    !strcmp(name->name, MEMFD_ANON_NAME)) {
> > +=09=09if (!selinux_policycap_memfd_class())
> > +=09=09=09return 0;
> > +=09=09is_memfd =3D true;
> > +=09}
> > +
> >  =09isec =3D selinux_inode(inode);
> > =20
> >  =09/*
> > @@ -2996,6 +3008,13 @@ static int selinux_inode_init_security_anon(stru=
ct inode *inode,
> > =20
> >  =09=09isec->sclass =3D context_isec->sclass;
> >  =09=09isec->sid =3D context_isec->sid;
> > +=09} else if (is_memfd) {
> > +=09=09isec->sclass =3D SECCLASS_MEMFD_FILE;
> > +=09=09rc =3D security_transition_sid(
> > +=09=09=09sid, sid,
> > +=09=09=09isec->sclass, name, &isec->sid);
> > +=09=09if (rc)
> > +=09=09=09return rc;
> >  =09} else {
> >  =09=09isec->sclass =3D SECCLASS_ANON_INODE;
> >  =09=09rc =3D security_transition_sid(
>=20
> We're duplicating the security_transition_sid() call which seems less
> than ideal, how about something like this?
>=20
>   if (context_inode) {
>     /* ... existing stuff ... */
>   } else {
>     if (is_memfd)
>       isec->sclass =3D SECCLASS_MEMFD_FILE;
>     else
>       isec->sclass =3D SECCLASS_ANON_INODE;
>     rc =3D security_transition_sid(...);
>     if (rc)
>       return rc;
>   }
>=20
> --
> paul-moore.com
---1463770367-1767593222-1757999268=:21221--

