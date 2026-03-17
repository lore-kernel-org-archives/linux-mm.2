Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7B52FF6E85
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 21:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D78EA6B008C; Tue, 17 Mar 2026 17:26:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50ED6B0092; Tue, 17 Mar 2026 17:26:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3EEB6B0093; Tue, 17 Mar 2026 17:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B1B7A6B008C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:26:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 626E2C1967
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:26:36 +0000 (UTC)
X-FDA: 84556839192.09.28178E2
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id 66D0540006
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:26:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eue4lrWB;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773782794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O9MljJMIpne7nbSW7i1x1Or1SMzjT+hBLrQOgGeQvrk=;
	b=MJQbBZ116CrzHtyITAQrwA++gjFkkUwLMzTLGkOVVDWs5mbiudl8f6ChLrOmsXsMH4/QYi
	vIzECwIPyYAjnslGOgevkfKldQhXHl4sHshKqVxz2pfCe/w/c6dZ3KJtDbz4QKjAj2lqow
	W+mybd7I9ZRpIVQGVHcMLrhYxx6Qg4w=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eue4lrWB;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773782794; a=rsa-sha256;
	cv=pass;
	b=6paEVKe96D+WsKzLza2A3//hrBLZNoRtJcu3nYfjhWs62dzX0xOgbasLQRYVHuZ81PnZ64
	+qUV4mTSNmRk1SuPzqsbnBgK+kOeG8bqf+jHQO31gpsHTWq+mnOHNCNL4OaPs0Fbf9D2i8
	rD8bLbfwqdOGl7cor4+1jRp+s479bs4=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50906a98ffeso171311cf.0
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:26:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773782793; cv=none;
        d=google.com; s=arc-20240605;
        b=R3Ar1Ca1E6Usj140z2QtmzSb/zWs4xFjpuYhLtofhNxvD9idOAX4un5s+6nJPYzFYA
         WzTpJvfWYpURFEFBoTh+0GTvPIElawrVm0e3T6kkw3qFSiOu2RV5fLs6q3WplXqG9WI0
         UnSvf3GyselaM0W66Q2o1ovxmO3LxFZ86YgFix4elWfZhO7FZRKSCxuxyUbnHVmIEVO4
         kWqT2bD67JMYfoN0hqq1OPcRzy9hQ4U/9ssQb/7977zx4gYzyZMCPbtRn9E/EMhmYQ3O
         WHGtl+rFZYRhXvLDh6lfLIcqu+kEcKxIaanybb2YoiWifnoofmK7c/ZYZbElnff3J7bh
         7HUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O9MljJMIpne7nbSW7i1x1Or1SMzjT+hBLrQOgGeQvrk=;
        fh=5NYeeMIC+YTSwhzS2aG+O3eNFMMv3fjT3xqssq7HfQM=;
        b=gXA7aPVZ1Kt+bzNMfOgmPwnH5p4C4ribMMPNebBhdBYxZiT3RzR4P55qMv92eRmVaw
         jnfepDWLO+TYPDrRamGHPCSiiGcwj5OWoBN/omFekOBLh9ht0jDs+EQZ8EdOP3Sx+oE4
         kGy92U4sMDSaF87YtvHWlZv9X353BO4uuIf2Zx/g2HAP0VuRkNmkNPyi8T5m46+2e+wc
         XR1l69M80+8i4HzpcpnX4xpEFCOrRiWBEEoZsDHGsUaNw3SXt7Eg7JzNCYHN27qe0IvI
         L33auYuGteydYVsB2HRxWlThs6qOD2Ebqpk2Yc3EcuJ0AZwvaIm6aWBLXf1gbsNNyFQa
         yPhQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773782793; x=1774387593; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O9MljJMIpne7nbSW7i1x1Or1SMzjT+hBLrQOgGeQvrk=;
        b=eue4lrWBcouSynIsnq0Nx9pDCMCcdNRKQq5Co73RpngTO6N8/Ca6BrTlopfPGO7aFo
         hJvluUi3Y/Kh7YlkVVUImTImVHHt7o4PWzZYpoAciG591wrpDmmsiVHnTED32nJpAo4o
         tCsbQGfdzPyJkSyPkvG0rcO5LiNjq8U5DU/TT5xnobmOSpoZrZfc0uDzqHduLLZsbrLC
         81paSp4G9lP6Ve8TbT6vgw4z0sW3MmFr6f52T5wPiN65rA3tCzmlGyfP6+NQ4Ms9GKtm
         RyDuWNsDlq2z/LznejsG0wMfN7XtQA/8RG3aA//jkXnFa5t1XGS4mV/jE1QRgoB4QCcX
         wOoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773782793; x=1774387593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O9MljJMIpne7nbSW7i1x1Or1SMzjT+hBLrQOgGeQvrk=;
        b=H5mbPzdUzZKxBVC8vWKCYc+ndbHLUiN7jM3HOr54Rl/MOlPB3wtC/kvqqM/iybX9Av
         s4QSYRK3UlH1lYmDDbIfQSaAsU/DQiBsoHATxErYS384DXNQyiIfvjm73kmuki7At+lk
         9vOm+vjVetpbE3vmn8I4U0UO16coATKhqshJHseeNqDGK68Bg1lKL4DK8cPEDoabBRsp
         Xvd5BxYHL18bFoi1GDx1K8FU2FmHwKy2dhjVgklBhVs07auNHIQkU7fhvPb6ALCHB0VA
         dQ3bWcsh/N4Wnvp3OJM0ioYEvzmLYr3pXkur7fds1sCqXb2TlzvGx/CtRnlLqhvLeRjE
         MI7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUIC7bmU01D1UMVP52rDhY10+qtCh+O6cuURcoUIbPGtTiFK0LGi2IeXUxqsvQQ9yRGQk5YIiASRw==@kvack.org
X-Gm-Message-State: AOJu0YyLLRPtvY8PlfIy6gHCm+URTLiXaXmra9cbQvNyrXCWChx505Rf
	ZZqik0nxE1QCOPNN6jk1BMVIRNLIGHKs8jDrEv/TXL12fNh1OTtqWfFCixBz+/cQTZzirnVwXBc
	XxdBKDPfbLxQRgsmLYpRuFFQGzO2Rggbe9vBOQLrH
X-Gm-Gg: ATEYQzxs5O4WsNrnXBkULzyP1AMZApVnwvu2ly4mkHYAs69emv4VGyrtKER2I5hWY0b
	8bzFdzm63VbJCoQO9FowHOXKhqF6/EQZt8WnMjiveZz/la2l4xA8p4iFx1JwA7+N9/FIR0+GG1y
	3LFfZpADZ7BCz2a7+XSGqxoHLgPBCzOQA2VeixGqk/eFM/yOmiAgiiVxRU8ikj1eRgbOEDOIn/h
	3Ka9P9Y400J5pIY6JO/AzwyIsNwy2UqKg4xWD8J7xxMU5XSDDVQ+Hso94Zh7HbZtOwwIkFC7JSp
	89CYgqKCaXqg5qjWG1jNGuf46MWJKOTiIycxww==
X-Received: by 2002:a05:622a:614:b0:509:1eca:6d24 with SMTP id
 d75a77b69052e-50b1470ee58mr4568251cf.2.1773782792685; Tue, 17 Mar 2026
 14:26:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <48c6d25e374b57dba6df4fdddd4830d3fc1105be.1773695307.git.ljs@kernel.org>
In-Reply-To: <48c6d25e374b57dba6df4fdddd4830d3fc1105be.1773695307.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 17 Mar 2026 14:26:21 -0700
X-Gm-Features: AaiRm51SJauRxJyG8YD3YuiOnfN0s_6akSz6AhkIFbo6vEz-Gt-mAXyXfHq04tA
Message-ID: <CAJuCfpFXuHg4KPY27pqMC-xV5y9ZY2W72_R8_rxO0DvrJ=_yvw@mail.gmail.com>
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
X-Rspamd-Queue-Id: 66D0540006
X-Stat-Signature: xb41es6neath7afirb6use1anq8ot4nc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773782794-857613
X-HE-Meta: U2FsdGVkX18R7wazG20jJ0lP9fPmHBEJHrL1sLR78hmWEGQboh2mNIIHiG30sl2wtX7X9as1tcwmzNAQD5yYhVugqyM6u5rDqlXsxJtq2JHyKO8wHFCH8KnL8gyMaEepDeLSmhqm7daMPa6uiJJ0k5ZqpsIbIPnoDkGmfCppRuJ0rXGH8zZNAmfa6cWtdwzpJ3ADMWgBxGvnhbMb1923SQQ6DSCJ+H0Xfgm7NCgwyQxXba6XwHOynOCDt7PEpt6XlWuFq8fFnrDLi+PYBeCf/TKfH1GzKmmqC8Agj3KsNBWhRDVTbOF9aNF63TTNVCUBzyOpgh25sKfiMjfOdG8+2foIlqmpeMkhso8AZgBWJaW3geAo4aIdx6KyfEHlsF3bnDXK5VXoCKOkIemGaX0vfuC6jQnAbSHuWSNzpHH1EG4V7yPVky8tOlKTyrGtVgvPs8trsq/SqOz+ouLwDs64Xte84FENBu77M0WIJ6Oy3T8pJ0EwIwGyDJfDh+pBoVswtXhELLnbiBMT66ePVj0A+AsbjwjfmMPK9RXQFwygEwDABgUkPpjp1PoSVx3ddh+M1TcuqFyUwcLuGUBiZrrfl8alBmkVlYxm1IFaOlireeoMmJCb0tfoH/J3DQ1OJ3/PZ95uX4zQnFVUQoidal3oRcwGThgrPdI/DIWn2uNWk9D/YuEmUXhubhaJkgLSZv+90dsXKsYaoSVO9dbtwtposYZLFg6tLBRYmKKAY4ggQt3FlhSJ+lIELTEcVW0QcSxPTUWUDzSWLsmIszkSUzFjrLVxHl9w58NuvRw5WVc+pPsjAp6KGyf+qUzpYA/4WDGsJRZhx4D911L0bQE5kzDYiExtW6Jq7kU6j495PwuWFlpNovCkr6pa8rBr9Dj0hROwh7/AyACxFPWWV/7O8xUGqRFancwyqg/jRrvok7YJDq3UxGWnBj6jpPeK7oAgV/ZuZqPXBpp60P2G56S8qZJ
 inKLesCf
 9sukxAHhHlD5TrzHWLwlglmy+Q5AGrv12MUy0ZyLJ7XWS/3OruGU09rB4pkhbVbk5YrN04DoxfqyIBZbDA26VAMvz+Dvex/UHjRJF/1l+sAYI04e3fa0mtHyiYPYBWsOE27a2+btIfdtv752IGICzntlm64cdV2DcDkarKrSafCCAv6zjCUx9uMi+5NqVJ47+Qh1lVfCDzKd+08fVmlR3PrsCtFwN9nPwuE4RQMDtZf3jRX6MTNK9rkvFY8SDLXTYkETkdeE4UV7+wMKw+dqgQ+l1TyYfeksTi49gD+yWjMnDJf9N7CnXJMpatGecXhEkRdcWfLr9DqlQdqs1LLXRE9CgQwfTuKRfAzoQ+o16SrvFUf4d+BVb3PLm5m6YMmuY4AWH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 2:14=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> The f_op->mmap interface is deprecated, so update driver to use its
> successor, mmap_prepare.
>
> The driver previously used vm_iomap_memory(), so this change replaces it
> with its mmap_prepare equivalent, mmap_action_simple_ioremap().
>
> Functions that wrap mmap() are also converted to wrap mmap_prepare()
> instead.
>
> Also update the documentation accordingly.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  Documentation/driver-api/vme.rst    |  2 +-
>  drivers/staging/vme_user/vme.c      | 20 +++++------
>  drivers/staging/vme_user/vme.h      |  2 +-
>  drivers/staging/vme_user/vme_user.c | 51 +++++++++++++++++------------
>  4 files changed, 42 insertions(+), 33 deletions(-)
>
> diff --git a/Documentation/driver-api/vme.rst b/Documentation/driver-api/=
vme.rst
> index c0b475369de0..7111999abc14 100644
> --- a/Documentation/driver-api/vme.rst
> +++ b/Documentation/driver-api/vme.rst
> @@ -107,7 +107,7 @@ The function :c:func:`vme_master_read` can be used to=
 read from and
>
>  In addition to simple reads and writes, :c:func:`vme_master_rmw` is prov=
ided to
>  do a read-modify-write transaction. Parts of a VME window can also be ma=
pped
> -into user space memory using :c:func:`vme_master_mmap`.
> +into user space memory using :c:func:`vme_master_mmap_prepare`.
>
>
>  Slave windows
> diff --git a/drivers/staging/vme_user/vme.c b/drivers/staging/vme_user/vm=
e.c
> index f10a00c05f12..7220aba7b919 100644
> --- a/drivers/staging/vme_user/vme.c
> +++ b/drivers/staging/vme_user/vme.c
> @@ -735,9 +735,9 @@ unsigned int vme_master_rmw(struct vme_resource *reso=
urce, unsigned int mask,
>  EXPORT_SYMBOL(vme_master_rmw);
>
>  /**
> - * vme_master_mmap - Mmap region of VME master window.
> + * vme_master_mmap_prepare - Mmap region of VME master window.
>   * @resource: Pointer to VME master resource.
> - * @vma: Pointer to definition of user mapping.
> + * @desc: Pointer to descriptor of user mapping.
>   *
>   * Memory map a region of the VME master window into user space.
>   *
> @@ -745,12 +745,13 @@ EXPORT_SYMBOL(vme_master_rmw);
>   *         resource or -EFAULT if map exceeds window size. Other generic=
 mmap
>   *         errors may also be returned.
>   */
> -int vme_master_mmap(struct vme_resource *resource, struct vm_area_struct=
 *vma)
> +int vme_master_mmap_prepare(struct vme_resource *resource,
> +                           struct vm_area_desc *desc)
>  {
> +       const unsigned long vma_size =3D vma_desc_size(desc);
>         struct vme_bridge *bridge =3D find_bridge(resource);
>         struct vme_master_resource *image;
>         phys_addr_t phys_addr;
> -       unsigned long vma_size;
>
>         if (resource->type !=3D VME_MASTER) {
>                 dev_err(bridge->parent, "Not a master resource\n");
> @@ -758,19 +759,18 @@ int vme_master_mmap(struct vme_resource *resource, =
struct vm_area_struct *vma)
>         }
>
>         image =3D list_entry(resource->entry, struct vme_master_resource,=
 list);
> -       phys_addr =3D image->bus_resource.start + (vma->vm_pgoff << PAGE_=
SHIFT);
> -       vma_size =3D vma->vm_end - vma->vm_start;
> +       phys_addr =3D image->bus_resource.start + (desc->pgoff << PAGE_SH=
IFT);
>
>         if (phys_addr + vma_size > image->bus_resource.end + 1) {
>                 dev_err(bridge->parent, "Map size cannot exceed the windo=
w size\n");
>                 return -EFAULT;
>         }
>
> -       vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);
> -
> -       return vm_iomap_memory(vma, phys_addr, vma->vm_end - vma->vm_star=
t);
> +       desc->page_prot =3D pgprot_noncached(desc->page_prot);
> +       mmap_action_simple_ioremap(desc, phys_addr, vma_size);
> +       return 0;
>  }
> -EXPORT_SYMBOL(vme_master_mmap);
> +EXPORT_SYMBOL(vme_master_mmap_prepare);
>
>  /**
>   * vme_master_free - Free VME master window
> diff --git a/drivers/staging/vme_user/vme.h b/drivers/staging/vme_user/vm=
e.h
> index 797e9940fdd1..b6413605ea49 100644
> --- a/drivers/staging/vme_user/vme.h
> +++ b/drivers/staging/vme_user/vme.h
> @@ -151,7 +151,7 @@ ssize_t vme_master_read(struct vme_resource *resource=
, void *buf, size_t count,
>  ssize_t vme_master_write(struct vme_resource *resource, void *buf, size_=
t count, loff_t offset);
>  unsigned int vme_master_rmw(struct vme_resource *resource, unsigned int =
mask, unsigned int compare,
>                             unsigned int swap, loff_t offset);
> -int vme_master_mmap(struct vme_resource *resource, struct vm_area_struct=
 *vma);
> +int vme_master_mmap_prepare(struct vme_resource *resource, struct vm_are=
a_desc *desc);
>  void vme_master_free(struct vme_resource *resource);
>
>  struct vme_resource *vme_dma_request(struct vme_dev *vdev, u32 route);
> diff --git a/drivers/staging/vme_user/vme_user.c b/drivers/staging/vme_us=
er/vme_user.c
> index d95dd7d9190a..11e25c2f6b0a 100644
> --- a/drivers/staging/vme_user/vme_user.c
> +++ b/drivers/staging/vme_user/vme_user.c
> @@ -446,24 +446,14 @@ static void vme_user_vm_close(struct vm_area_struct=
 *vma)
>         kfree(vma_priv);
>  }
>
> -static const struct vm_operations_struct vme_user_vm_ops =3D {
> -       .open =3D vme_user_vm_open,
> -       .close =3D vme_user_vm_close,
> -};
> -
> -static int vme_user_master_mmap(unsigned int minor, struct vm_area_struc=
t *vma)
> +static int vme_user_vm_mapped(unsigned long start, unsigned long end, pg=
off_t pgoff,
> +                             const struct file *file, void **vm_private_=
data)
>  {
> -       int err;
> +       const unsigned int minor =3D iminor(file_inode(file));
>         struct vme_user_vma_priv *vma_priv;
>
>         mutex_lock(&image[minor].mutex);
>
> -       err =3D vme_master_mmap(image[minor].resource, vma);
> -       if (err) {
> -               mutex_unlock(&image[minor].mutex);
> -               return err;
> -       }
> -

Ok, this changes the set of the operations performed under image[minor].mut=
ex.
Before we had:

mutex_lock(&image[minor].mutex);
vme_master_mmap();
<some final adjustments>
mutex_unlock(&image[minor].mutex);

Now we have:

mutex_lock(&image[minor].mutex);
vme_master_mmap_prepare()
mutex_unlock(&image[minor].mutex);
vm_iomap_memory();
mutex_lock(&image[minor].mutex);
vme_user_vm_mapped(); // <some final adjustments>
mutex_unlock(&image[minor].mutex);

I think as long as image[minor] does not change while we are not
holding the mutex we should be safe, and looking at the code it seems
to be the case. But I'm not familiar with this driver and might be
wrong. Worth double-checking.

>         vma_priv =3D kmalloc_obj(*vma_priv);
>         if (!vma_priv) {
>                 mutex_unlock(&image[minor].mutex);
> @@ -472,22 +462,41 @@ static int vme_user_master_mmap(unsigned int minor,=
 struct vm_area_struct *vma)
>
>         vma_priv->minor =3D minor;
>         refcount_set(&vma_priv->refcnt, 1);
> -       vma->vm_ops =3D &vme_user_vm_ops;
> -       vma->vm_private_data =3D vma_priv;
> -
> +       *vm_private_data =3D vma_priv;
>         image[minor].mmap_count++;
>
>         mutex_unlock(&image[minor].mutex);
> -
>         return 0;
>  }
>
> -static int vme_user_mmap(struct file *file, struct vm_area_struct *vma)
> +static const struct vm_operations_struct vme_user_vm_ops =3D {
> +       .mapped =3D vme_user_vm_mapped,
> +       .open =3D vme_user_vm_open,
> +       .close =3D vme_user_vm_close,
> +};
> +
> +static int vme_user_master_mmap_prepare(unsigned int minor,
> +                                       struct vm_area_desc *desc)
> +{
> +       int err;
> +
> +       mutex_lock(&image[minor].mutex);
> +
> +       err =3D vme_master_mmap_prepare(image[minor].resource, desc);
> +       if (!err)
> +               desc->vm_ops =3D &vme_user_vm_ops;
> +
> +       mutex_unlock(&image[minor].mutex);
> +       return err;
> +}
> +
> +static int vme_user_mmap_prepare(struct vm_area_desc *desc)
>  {
> -       unsigned int minor =3D iminor(file_inode(file));
> +       const struct file *file =3D desc->file;
> +       const unsigned int minor =3D iminor(file_inode(file));
>
>         if (type[minor] =3D=3D MASTER_MINOR)
> -               return vme_user_master_mmap(minor, vma);
> +               return vme_user_master_mmap_prepare(minor, desc);
>
>         return -ENODEV;
>  }
> @@ -498,7 +507,7 @@ static const struct file_operations vme_user_fops =3D=
 {
>         .llseek =3D vme_user_llseek,
>         .unlocked_ioctl =3D vme_user_unlocked_ioctl,
>         .compat_ioctl =3D compat_ptr_ioctl,
> -       .mmap =3D vme_user_mmap,
> +       .mmap_prepare =3D vme_user_mmap_prepare,
>  };
>
>  static int vme_user_match(struct vme_dev *vdev)
> --
> 2.53.0
>

