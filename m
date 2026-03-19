Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0469D1090240
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D9F16B0502; Thu, 19 Mar 2026 11:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1976B0504; Thu, 19 Mar 2026 11:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8666B0505; Thu, 19 Mar 2026 11:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2906B6B0502
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:19:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED8F759AAD
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:19:17 +0000 (UTC)
X-FDA: 84563171154.13.6F47D2D
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id CBDC71A0014
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:19:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jgBrSwW6;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773933556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+SkkA6JHNTO5608C+WgUR0GK5zpsD2f8nbksELlrew=;
	b=hvA4ff+jwTr5kPeoHU/r2qn+NpY+oqwRMq8HZGjKwzltgO2ot/IwvI54/TNTJHnnp8Romg
	qBnrWr1dUG1ZTQxqlO6782OJQE3s6SfVCQydEL669soWAfQ79fHwJfHRQ7R9gKY8bCwvSC
	UyAnxm/4rgwKYOghhg9lHIuZIqbzTZ0=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jgBrSwW6;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773933556; a=rsa-sha256;
	cv=pass;
	b=nsDmYsrQ17KWuHx8qaBvUU0AW3U80tuyslvB4H1WGb1b8nSJkohfiEvVhgvq+I6+W2DL1B
	EqNbg0sJo8f/BWqk1KhOKbHWk48afxMddsxucnhmdDE14JCV1msDf7/ylNyi8gt7wfNUrp
	ZzD/N+36btUyyXsL2BEbvfB+BhjCEks=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-661ce258878so12083a12.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:19:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773933554; cv=none;
        d=google.com; s=arc-20240605;
        b=bj5vC2Iz/h1mb5hgW3oxyqmkKgc8aNqhXhNqUqnftp5rYGuBSHjr2Q/xULahsZh2bi
         VFtDANlfOIXu73wqQVFXQtiOVYpss/zdxmbwIG7tz81C4Oj/LRlpjZ42gvQy7WcnFHG6
         BvBMD+yBHsCq1K6FXzmTn86/1Vk4TOS/FExSESBCx15jTVGATHd41d35FUWNfslQBTgf
         r+0mLM6Sp/aWPiO4C8zVso+5suFKEejTUIaAdyOFa0MuIn1JToluw/5ullljf+4dxCq2
         yvJZ4CV2Mvo4/q0k0iT/wfufSmvcqfb8KpSdpUSZiM3DknXQS53XPb+yvQ3fXFyyv1+S
         rOTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l+SkkA6JHNTO5608C+WgUR0GK5zpsD2f8nbksELlrew=;
        fh=clh7ZHaOVFrnhRU8+hmsI5yqxdU60o8W41UX1lH7bpw=;
        b=TbR05nn7o34ilmeaq8IcKx4nca3sJAr3zjZ/WJejbGHhp9bEBDncnvRV/ERZpbAdYd
         1cQ+Ow3+xYHSNGV4sqJN34LPB9Kf3POVRFg1WDfNoO0MNOOjy6x9H4wYSrl0r/j+5q7y
         ciZgQEu7nZDcIwTKrJl9e7GKjMFcC8TYa8Mmp+CoLSua4A9uG8GeiNz3OX2ClGFGoLWB
         2XvboSj4QhquRUHcH8uNje3BPIiHUEq8s3SClid0R72MIImvhXzMLlybAoEE/s8V9HEt
         Q82RuwR1pnOTSkYXbtNKZ4OacgU0/41VZr6wo8i5ZK572lZXbsoGPfxokMpBjgvJY+f6
         pHVw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773933554; x=1774538354; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l+SkkA6JHNTO5608C+WgUR0GK5zpsD2f8nbksELlrew=;
        b=jgBrSwW6vFBHDH7nmkBr4bK7prZ/1BfDOqcaqqVrPCwTW4KZ40lyRsf1qQ+nncn3vD
         OnQnwPOAIb5BY0Xe34LJTsZE0qK/0gIr7VjgTso+1UH/yME+0mrHETK/XgfdtWB4Yz5P
         N4DiTRINB1zTUnZy8nvKmYywWOXTea6buZ4FUDrWOPY96Hac9uecy+KWENsmGTCt9HOG
         GTLlS54DAZT2T2EYoeyqwb5rF2mWTjuFlAMPV69rHBTnoSjVr9WHaqdWtZaG2icYV4sl
         2K7pgTO8Mns6QP5zl2C0J/fWp/e3KBAP6gj0PXaHnd035/pGDNIo/ycsTUjDMjP+wlTq
         /NZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773933554; x=1774538354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l+SkkA6JHNTO5608C+WgUR0GK5zpsD2f8nbksELlrew=;
        b=D2fPbTIwJ66Jkhhi5P+Mv2nDTZk7tk4HRRXx5axAArXwwEH8VmKTnY+lXuaEtFAUd/
         BKBXPC6I198ErMttpIe4vsD5lufyWvs3BTYO1uRHdBoOxPNtgXrnQaWiTs+7vfxCB+1B
         GYAAlptwsmT52+r2cX85DRDeUYQ5jJZcIW/0WCpQe4oTvheyqaR1Arg/QgoBh1WvDGew
         gS0xr69R4Ck9+PVdCUMwLq0kTJZRg0zUnHy/0DO14GB2t1e8MobFHXk94vrx35PqZ3qN
         +FciHU3K6w0rppsWoASdsIXx1U38g59E75PJvvHOSfrVYGbFO1T5DyjYVst5+NhYAiq3
         5jIA==
X-Forwarded-Encrypted: i=1; AJvYcCUzOn3HhS6AlbnbrqHeSQvHs1L7ecNR1/knjGfYCnLzlrmTilQKkL9C8Vcrfr1U6mLQobyxkqeEYA==@kvack.org
X-Gm-Message-State: AOJu0YyGYn80xtiVBkBz/A5EGEPmYJjYHFYImzgltpik4hY9ng4Zoe7M
	qtplJJ15MbI1X6VFWqo2qPMUWvt+k5CYYF0GAlGQgJinQJEq5uvdISrdav/n1VLJacyhF7QU/8/
	GQBSv2pksKYE4K1IIcV2Ly8MX9LQOjlID80oFq+J4
X-Gm-Gg: ATEYQzxacibvjmXL80ALKx0/VgIdhxMKenu9iclwHF07ul0nHdkegb2ov1LX7mLqJtL
	GLtIbMIB9UKZPbc0O05HqwOblqopx5drNJUrfHqv36WuJ5qBFEmUe2vEFIJ1dtTt1AeeXKRS0NJ
	P15ofNbc1wVwvNxmzchWYINc8btzTUDoOoJDIxMdVM1NrmMtCdItCmbjMN+iY1WRztqaTi8ksau
	0TmtS2jRKr2j6f7lnBzyvJrk9pVsk5A8uxmjxTHuA5oD/S36v25U4wQY5BZIbb2gMyqwHz1u6FB
	iX83YJNgzz6w/v/g72gHQdZVgSevbJ/OayOT
X-Received: by 2002:aa7:c305:0:b0:665:4aee:2091 with SMTP id
 4fb4d7f45d1cf-668597c91b5mr35260a12.1.1773933553516; Thu, 19 Mar 2026
 08:19:13 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <48c6d25e374b57dba6df4fdddd4830d3fc1105be.1773695307.git.ljs@kernel.org>
 <CAJuCfpFXuHg4KPY27pqMC-xV5y9ZY2W72_R8_rxO0DvrJ=_yvw@mail.gmail.com>
 <CAJuCfpE5qZmi43EeZiRcy78pD6YvJb5n_xnoUJfwEjomowu0=A@mail.gmail.com> <8cdad898-b306-40fe-a367-efe7147f83b9@lucifer.local>
In-Reply-To: <8cdad898-b306-40fe-a367-efe7147f83b9@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 19 Mar 2026 08:19:00 -0700
X-Gm-Features: AaiRm538m687pN9OvrM8BA6vooI_JX1puVDbGEAq4CrmCygBr1Sq-70iE-ogZ1c
Message-ID: <CAJuCfpHXqtxZr5s84jCcz513a2pgMeDoobsLBJH9pSON49cM+w@mail.gmail.com>
Subject: Re: [PATCH v2 11/16] staging: vme_user: replace deprecated mmap hook
 with mmap_prepare
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, 
	linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Ryan Roberts <ryan.roberts@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CBDC71A0014
X-Rspamd-Server: rspam07
X-Stat-Signature: 9q4mi596hox6w16dkfinx8h71quhu5ci
X-Rspam-User: 
X-HE-Tag: 1773933555-416526
X-HE-Meta: U2FsdGVkX1+pAN5rOskmm9kiO6PfgCGGHJ2sdgV/7Qv6QeC8E2UVEbOSA+sO76d4vGefEdtqaSSgwvW5sruxQuqgAlHulAR4El0tB3gwsHomrIIono3rni9E+m6utMar+Qq2KB2I0a/8MsptDze9EEnK+KwW87n5sdVSPg3LmfJEEe430QsR5tC9iTT3Rwe2qA0WcyZ8c6jnJ8woXIHFriAA5q1KYlHVa6/1qRqGEhuFOrzItOKgSkwPmnIi3j4E/4A1ore+q2e8lWVy+HimAkwNA4r6YOH2OPDDdbIv/Y7WM5D4p2uBnq/9+yxxZ/wC0PPBWOHJzaHwT3nz88udzBiTDhHpmxQHnj2AW9Um4zZnD8f3D/Bax8leHqRR2HM3Z16kjD/zC4fqULMzlUXmHkh+klUBN/MMSr4Uc4uCuiJUGklpLWneH+c4ZFoVg3xWnX9qrn5RbxBC2uK/QQ8Cg4dxZc8Y7rd4lhWD+iMYpYZ7XTzgXJXlIqkJzKT3MvEc9bhxX+9QwckzBQHrKj7eTpzYVsAhl6V0ujXZCvLeHk6CUy9l9BP8V+7533JTxuck5oA/j1hiv0NNTJIU07sG7bEFJ9O+gKbbE5RJrScjInlcePy1a7L2wigJeN8O2D6O7soXIRdSXsZrbhMlu22LDh6t/ZH+JQbTL9Yn+RjgxmDvyZOTsyIODxgwOeaPriyjlcnJWhAJS7pYrUoTdbKhbiML4afsm7ijm4JmOLTYOP9g1w66L4llNZ4K5OYzuJkoUG6BmRKUI/esQ9oUTIJUySLulubrN9ciJlLFRBZrEC8dMq6GN9eaQ8eqVbUwpLdrbPzWN1GwrpLpWoZmM+FR9eMn4rP8/jGJ6DeC30xeavr65MeNVE7DfP6SFCCvMIaAj2lejWlT/pSkzyebFnTHiJDGIzHOGEZqlwSqVYm8jM+CHJI04Lvi0KZICVPZhEbcW53X4EX7GqNvWL2w/dP
 Nhm0W8i9
 /BsAzrfC03Bm/mpjrkexpXFmpsFTj4wL3V2Fw868neqAuUgNUrQ/x97InJHy0Y0MBnPxwc0TCYPl3IJ327Xm6y88uF2C52BtP1Ivq16fT/hMZcxxN2eCNtod3zGlFmc2peAVS3nhMEXsdsr3zErD6gge0SKWP0uHzjcY9s0Tk9FOAFIW4eecQE+miOp402XS0lB+ZbDH4aPht/bZY9hmpchCr/P9pjJEQYIDLH3iBaVC/XmcKOpPNWZwmMXAlTtUbVEzRc7+utlADdagtyLo3VMIQS2C+kvBjtuBJTLIqXhEJ6o9JzHYuMsOw/sEXmcuxRAqA1Lq9wgzHoFm/LJuEbYhYaWZCCXebS0xIi/S0ZpOziU/fO+5hlSVpN72bcm4L6KrQncE11PJWUBfPdnzmQ4VQ1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 7:55=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Tue, Mar 17, 2026 at 02:32:16PM -0700, Suren Baghdasaryan wrote:
> > On Tue, Mar 17, 2026 at 2:26=E2=80=AFPM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> > >
> > > On Mon, Mar 16, 2026 at 2:14=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs=
@kernel.org> wrote:
> > > >
> > > > The f_op->mmap interface is deprecated, so update driver to use its
> > > > successor, mmap_prepare.
> > > >
> > > > The driver previously used vm_iomap_memory(), so this change replac=
es it
> > > > with its mmap_prepare equivalent, mmap_action_simple_ioremap().
> > > >
> > > > Functions that wrap mmap() are also converted to wrap mmap_prepare(=
)
> > > > instead.
> > > >
> > > > Also update the documentation accordingly.
> > > >
> > > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > > > ---
> > > >  Documentation/driver-api/vme.rst    |  2 +-
> > > >  drivers/staging/vme_user/vme.c      | 20 +++++------
> > > >  drivers/staging/vme_user/vme.h      |  2 +-
> > > >  drivers/staging/vme_user/vme_user.c | 51 +++++++++++++++++--------=
----
> > > >  4 files changed, 42 insertions(+), 33 deletions(-)
> > > >
> > > > diff --git a/Documentation/driver-api/vme.rst b/Documentation/drive=
r-api/vme.rst
> > > > index c0b475369de0..7111999abc14 100644
> > > > --- a/Documentation/driver-api/vme.rst
> > > > +++ b/Documentation/driver-api/vme.rst
> > > > @@ -107,7 +107,7 @@ The function :c:func:`vme_master_read` can be u=
sed to read from and
> > > >
> > > >  In addition to simple reads and writes, :c:func:`vme_master_rmw` i=
s provided to
> > > >  do a read-modify-write transaction. Parts of a VME window can also=
 be mapped
> > > > -into user space memory using :c:func:`vme_master_mmap`.
> > > > +into user space memory using :c:func:`vme_master_mmap_prepare`.
> > > >
> > > >
> > > >  Slave windows
> > > > diff --git a/drivers/staging/vme_user/vme.c b/drivers/staging/vme_u=
ser/vme.c
> > > > index f10a00c05f12..7220aba7b919 100644
> > > > --- a/drivers/staging/vme_user/vme.c
> > > > +++ b/drivers/staging/vme_user/vme.c
> > > > @@ -735,9 +735,9 @@ unsigned int vme_master_rmw(struct vme_resource=
 *resource, unsigned int mask,
> > > >  EXPORT_SYMBOL(vme_master_rmw);
> > > >
> > > >  /**
> > > > - * vme_master_mmap - Mmap region of VME master window.
> > > > + * vme_master_mmap_prepare - Mmap region of VME master window.
> > > >   * @resource: Pointer to VME master resource.
> > > > - * @vma: Pointer to definition of user mapping.
> > > > + * @desc: Pointer to descriptor of user mapping.
> > > >   *
> > > >   * Memory map a region of the VME master window into user space.
> > > >   *
> > > > @@ -745,12 +745,13 @@ EXPORT_SYMBOL(vme_master_rmw);
> > > >   *         resource or -EFAULT if map exceeds window size. Other g=
eneric mmap
> > > >   *         errors may also be returned.
> > > >   */
> > > > -int vme_master_mmap(struct vme_resource *resource, struct vm_area_=
struct *vma)
> > > > +int vme_master_mmap_prepare(struct vme_resource *resource,
> > > > +                           struct vm_area_desc *desc)
> > > >  {
> > > > +       const unsigned long vma_size =3D vma_desc_size(desc);
> > > >         struct vme_bridge *bridge =3D find_bridge(resource);
> > > >         struct vme_master_resource *image;
> > > >         phys_addr_t phys_addr;
> > > > -       unsigned long vma_size;
> > > >
> > > >         if (resource->type !=3D VME_MASTER) {
> > > >                 dev_err(bridge->parent, "Not a master resource\n");
> > > > @@ -758,19 +759,18 @@ int vme_master_mmap(struct vme_resource *reso=
urce, struct vm_area_struct *vma)
> > > >         }
> > > >
> > > >         image =3D list_entry(resource->entry, struct vme_master_res=
ource, list);
> > > > -       phys_addr =3D image->bus_resource.start + (vma->vm_pgoff <<=
 PAGE_SHIFT);
> > > > -       vma_size =3D vma->vm_end - vma->vm_start;
> > > > +       phys_addr =3D image->bus_resource.start + (desc->pgoff << P=
AGE_SHIFT);
> > > >
> > > >         if (phys_addr + vma_size > image->bus_resource.end + 1) {
> > > >                 dev_err(bridge->parent, "Map size cannot exceed the=
 window size\n");
> > > >                 return -EFAULT;
> > > >         }
> > > >
> > > > -       vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);
> > > > -
> > > > -       return vm_iomap_memory(vma, phys_addr, vma->vm_end - vma->v=
m_start);
> > > > +       desc->page_prot =3D pgprot_noncached(desc->page_prot);
> > > > +       mmap_action_simple_ioremap(desc, phys_addr, vma_size);
> > > > +       return 0;
> > > >  }
> > > > -EXPORT_SYMBOL(vme_master_mmap);
> > > > +EXPORT_SYMBOL(vme_master_mmap_prepare);
> > > >
> > > >  /**
> > > >   * vme_master_free - Free VME master window
> > > > diff --git a/drivers/staging/vme_user/vme.h b/drivers/staging/vme_u=
ser/vme.h
> > > > index 797e9940fdd1..b6413605ea49 100644
> > > > --- a/drivers/staging/vme_user/vme.h
> > > > +++ b/drivers/staging/vme_user/vme.h
> > > > @@ -151,7 +151,7 @@ ssize_t vme_master_read(struct vme_resource *re=
source, void *buf, size_t count,
> > > >  ssize_t vme_master_write(struct vme_resource *resource, void *buf,=
 size_t count, loff_t offset);
> > > >  unsigned int vme_master_rmw(struct vme_resource *resource, unsigne=
d int mask, unsigned int compare,
> > > >                             unsigned int swap, loff_t offset);
> > > > -int vme_master_mmap(struct vme_resource *resource, struct vm_area_=
struct *vma);
> > > > +int vme_master_mmap_prepare(struct vme_resource *resource, struct =
vm_area_desc *desc);
> > > >  void vme_master_free(struct vme_resource *resource);
> > > >
> > > >  struct vme_resource *vme_dma_request(struct vme_dev *vdev, u32 rou=
te);
> > > > diff --git a/drivers/staging/vme_user/vme_user.c b/drivers/staging/=
vme_user/vme_user.c
> > > > index d95dd7d9190a..11e25c2f6b0a 100644
> > > > --- a/drivers/staging/vme_user/vme_user.c
> > > > +++ b/drivers/staging/vme_user/vme_user.c
> > > > @@ -446,24 +446,14 @@ static void vme_user_vm_close(struct vm_area_=
struct *vma)
> > > >         kfree(vma_priv);
> > > >  }
> > > >
> > > > -static const struct vm_operations_struct vme_user_vm_ops =3D {
> > > > -       .open =3D vme_user_vm_open,
> > > > -       .close =3D vme_user_vm_close,
> > > > -};
> > > > -
> > > > -static int vme_user_master_mmap(unsigned int minor, struct vm_area=
_struct *vma)
> > > > +static int vme_user_vm_mapped(unsigned long start, unsigned long e=
nd, pgoff_t pgoff,
> > > > +                             const struct file *file, void **vm_pr=
ivate_data)
> > > >  {
> > > > -       int err;
> > > > +       const unsigned int minor =3D iminor(file_inode(file));
> > > >         struct vme_user_vma_priv *vma_priv;
> > > >
> > > >         mutex_lock(&image[minor].mutex);
> > > >
> > > > -       err =3D vme_master_mmap(image[minor].resource, vma);
> > > > -       if (err) {
> > > > -               mutex_unlock(&image[minor].mutex);
> > > > -               return err;
> > > > -       }
> > > > -
> > >
> > > Ok, this changes the set of the operations performed under image[mino=
r].mutex.
> > > Before we had:
> > >
> > > mutex_lock(&image[minor].mutex);
> > > vme_master_mmap();
> > > <some final adjustments>
> > > mutex_unlock(&image[minor].mutex);
> > >
> > > Now we have:
> > >
> > > mutex_lock(&image[minor].mutex);
> > > vme_master_mmap_prepare()
> > > mutex_unlock(&image[minor].mutex);
> > > vm_iomap_memory();
> > > mutex_lock(&image[minor].mutex);
> > > vme_user_vm_mapped(); // <some final adjustments>
> > > mutex_unlock(&image[minor].mutex);
> > >
> > > I think as long as image[minor] does not change while we are not
> > > holding the mutex we should be safe, and looking at the code it seems
> > > to be the case. But I'm not familiar with this driver and might be
> > > wrong. Worth double-checking.
>
> The file is pinned for the duration, the mutex is associated with the fil=
e,
> so there's no sane world in which that could be problematic.
>
> Keeping in mind that we manipulate stuff on vme_user_vm_close() that
> directly acceses image[minor] at an arbitary time.

That was my understanding as well. Thanks for confirming.

>
> >
> > A side note: if we had to hold the mutex across all those operations I
> > think we would need to take the mutex in the vm_ops->mmap_prepare and
> > add a vm_ops->map_failed hook or something along that line to drop the
> > mutex in case mmap_action_complete() fails. Not sure if we will have
> > such cases though...
>
> No, I don't want to do this if it can be at all avoided. You should in
> nearly any sane circumstance be able to defer things until the mapped hoo=
k
> anyway.
>
> Also a merge can happen too after an .mmap_prepare, so we'd have to have
> some 'success' hook and I'm just not going there it'll end up open to abu=
se
> again.
>
> (We do have success and error filtering hooks right now, sadly, but they'=
re
> really for hugetlb and I plan to find a way to get rid of them).
>
> The mmap_prepare is meant to essentially be as stateless as possible.

Yes, I also hope we won't encounter cases requiring us to keep any
state information between the mmap_prepare and mapped stages.

>
> Anyway I don't think it's relevant here.
>
> >
> > >
> > > >         vma_priv =3D kmalloc_obj(*vma_priv);
> > > >         if (!vma_priv) {
> > > >                 mutex_unlock(&image[minor].mutex);
> > > > @@ -472,22 +462,41 @@ static int vme_user_master_mmap(unsigned int =
minor, struct vm_area_struct *vma)
> > > >
> > > >         vma_priv->minor =3D minor;
> > > >         refcount_set(&vma_priv->refcnt, 1);
> > > > -       vma->vm_ops =3D &vme_user_vm_ops;
> > > > -       vma->vm_private_data =3D vma_priv;
> > > > -
> > > > +       *vm_private_data =3D vma_priv;
> > > >         image[minor].mmap_count++;
> > > >
> > > >         mutex_unlock(&image[minor].mutex);
> > > > -
> > > >         return 0;
> > > >  }
> > > >
> > > > -static int vme_user_mmap(struct file *file, struct vm_area_struct =
*vma)
> > > > +static const struct vm_operations_struct vme_user_vm_ops =3D {
> > > > +       .mapped =3D vme_user_vm_mapped,
> > > > +       .open =3D vme_user_vm_open,
> > > > +       .close =3D vme_user_vm_close,
> > > > +};
> > > > +
> > > > +static int vme_user_master_mmap_prepare(unsigned int minor,
> > > > +                                       struct vm_area_desc *desc)
> > > > +{
> > > > +       int err;
> > > > +
> > > > +       mutex_lock(&image[minor].mutex);
> > > > +
> > > > +       err =3D vme_master_mmap_prepare(image[minor].resource, desc=
);
> > > > +       if (!err)
> > > > +               desc->vm_ops =3D &vme_user_vm_ops;
> > > > +
> > > > +       mutex_unlock(&image[minor].mutex);
> > > > +       return err;
> > > > +}
> > > > +
> > > > +static int vme_user_mmap_prepare(struct vm_area_desc *desc)
> > > >  {
> > > > -       unsigned int minor =3D iminor(file_inode(file));
> > > > +       const struct file *file =3D desc->file;
> > > > +       const unsigned int minor =3D iminor(file_inode(file));
> > > >
> > > >         if (type[minor] =3D=3D MASTER_MINOR)
> > > > -               return vme_user_master_mmap(minor, vma);
> > > > +               return vme_user_master_mmap_prepare(minor, desc);
> > > >
> > > >         return -ENODEV;
> > > >  }
> > > > @@ -498,7 +507,7 @@ static const struct file_operations vme_user_fo=
ps =3D {
> > > >         .llseek =3D vme_user_llseek,
> > > >         .unlocked_ioctl =3D vme_user_unlocked_ioctl,
> > > >         .compat_ioctl =3D compat_ptr_ioctl,
> > > > -       .mmap =3D vme_user_mmap,
> > > > +       .mmap_prepare =3D vme_user_mmap_prepare,
> > > >  };
> > > >
> > > >  static int vme_user_match(struct vme_dev *vdev)
> > > > --
> > > > 2.53.0
> > > >
>
> Cheers, Lorenzo

