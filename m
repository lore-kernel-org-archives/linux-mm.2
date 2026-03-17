Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFAF6FB5EAF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 04:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C3F6B0005; Tue, 17 Mar 2026 00:14:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4D896B0088; Tue, 17 Mar 2026 00:14:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B636B0089; Tue, 17 Mar 2026 00:14:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC2286B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 00:14:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6185658C4C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:14:48 +0000 (UTC)
X-FDA: 84554239056.20.7A8E396
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 46C0A1C000F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:14:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VPJQ2HNG;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773720886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YcyQ10La7z7dBA+gaHeygI/JcZo0DlNoTa72Nf5x2Ho=;
	b=woCNuz0NiC/HT7KdBJ0eQnVC/mE031LOp1SX2WU/8DcdAvl+nQW6tgKva46iOyhnJ5IaDb
	Hv9BNQ8Cr0ZxJ9yf8D/ugIKyA1jQxW0ibCKqaJooaA1D9nhUNJTezueUAtWTta4b3B2ouH
	oFj6HCnnO13rFAEY4lzBANAxO53KljM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VPJQ2HNG;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773720886; a=rsa-sha256;
	cv=pass;
	b=8YC721Ah/r1Tto9FgQchw3J94yFjQuzEV8shUxs7E6V2q2u8w07zqJPFCOzQGMHL3UlZEB
	+cNpuB9W65E09pN0FuOOif5kt550QuMuNlhNkJXVrtrOozAQjF5rl/wJE7EszPkKujDQcv
	IkHtfwbwjAw3+q34jFRvcqNM+CC2E0M=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-661169cd6d8so3938a12.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:14:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773720885; cv=none;
        d=google.com; s=arc-20240605;
        b=JImGXci93YnJiSWNEEhT7s+HZN5coekemUGl6U2kAuJ44JeR6MiNvx8dK9bVZO8S82
         cJWMXZuRtcOSv7ixMG8tT6FxE04yl/XclUroKHmwIecfLg7eNw9Fg5rrSMtq2Ai8ondr
         FeAM+npvizkvXQpRDxmDuQCWGwiBmjEg9PvfSYcG21Bg5Q+xJQ8XFnmdxP6Fka18L5oz
         Y5z3ajC3MyW+T1rUnzxyrOGQ0PlnirOINYdGxm7Z9SQLuhczH5/AiVR1HSTRyyn4v/B1
         FTJOH0jWym2bjX8CCx9bjAPKR3QtO7cZe2Am9uVRolRo8h4F+OHnsxP+IuBcWlo9By9E
         XyBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YcyQ10La7z7dBA+gaHeygI/JcZo0DlNoTa72Nf5x2Ho=;
        fh=qMWcUfeZ6srpf0IQKCHNRXFB2m3XMPcU9eEsFiNTeP0=;
        b=WNaNtZEgut+WMlcbbchxfpBta95ZHIgCaqVrNP0WrlN0n2SxI7dR7z1iKR1hjMlJI7
         6MNZ2t5nmEYNYM5HOV96BfwlKzrKJKBckJCjlmzxpIggFDpxrvNXK6nkmSY0ECHhgwno
         YIItNqdValJvQb4Ej0Fc/M4bLyQQPDjcDy41YPeLTP7q/Oqpx5olY67xHpEdp3CtUixB
         gkJpY3c7uYAkVwvCF4akHe8v09HG2WI7GpWJcQqr8Gln8x1FZlQoOufYwafE8nzdkzNd
         NEK7KXqaC2QuezEuGYRgqy2v2QI61un5dFn759T+ZTweWZ2s/erU6M3W+rz8rSj2HwTl
         2ibQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773720885; x=1774325685; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YcyQ10La7z7dBA+gaHeygI/JcZo0DlNoTa72Nf5x2Ho=;
        b=VPJQ2HNGw7N0vqZmMomVTzFWJ1lA8TJgE78iJaNEDbB9ZAnaIPMhnYRmovxXPE+xBr
         DjK0pThCjgpAQwdPDQjasBWUVs8dM4XIcfsiskSpGq8PJaplQmwc9GEGFxNK8q7aZ+z9
         M0cqSzv0bBcRofEWTZleYB90mtPjsJN3vlz6pF4QRezUZJNPu9WBVg6zhypdYaKBEwDa
         sxZDVLyfxApQlzFt5ZSXdaK3A0YHk1rEl5216f4MZ+iLfLelDzkZpSt0uFj9FYCclR6c
         ZFmXICK475nyiU+Pw/bSurwKI4p1E1xTlGAPQbOCBO2fogIXgj7tbvY5lempTMA/Ouxp
         Gr2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773720885; x=1774325685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YcyQ10La7z7dBA+gaHeygI/JcZo0DlNoTa72Nf5x2Ho=;
        b=RvvOFPEznWExmaA+CeqfV3/A/7j8p5r2DBemjkfUcE0dMDA6phbXy4UXEJY/fUOOeS
         Gqjrlhtv0iqaI26ujV04S85ueuAB2PbETgrZ/PEd3zm9X9+SF4cKRdIsWHFunuGPaXyF
         p5AL9duK+l27b5Js2H/3M3ZP3YQYBjAE//FettQdHU+KUpNUlwW68hn1fq3SvJmSMvAU
         ipfyg0TNOdLQCUHUhL8re811iSBUtmTfOUfyEyavyBzVCxhy+KVTAI68mHLAtLjDTUCd
         eb0JvrqppSG4pWSzW8iww1zhqpfZbhwSETjlz7BC3rbbFypAvvK8UFeE7qDhlnNt1TtN
         868A==
X-Forwarded-Encrypted: i=1; AJvYcCU9vsS4VMRNFMLjiFUf1YVhWKmJNhqsAFL4Zf93fXeaTxTuBSnqgv+fHFLpZaYcqFrnuxdnA68oiw==@kvack.org
X-Gm-Message-State: AOJu0YzYr8nXsOqtEuEIebsDzhJdppl6YmLWNnsh0ER6v5wCGM6GDChm
	tD7RQ4HpFlCZPJrKRuWNa/HKuXm3MZgZ0lvxn4vSPR9c8cOIJnEiggUg2NmZpmINZmJXq1pM8AD
	bGvKWsXdIMVIneSH5l0Iaf2006uPFuBGqSK+Fwu9e
X-Gm-Gg: ATEYQzw0ZJ6/fb9kO0ncbyZlfO4gyzCx8m5CVQyaiKG/Rz6aNdeRTJ+JD+OHBzOYEcY
	QJ1wHr3+d29wdF+56G9tYwh1LQO1/ZJmoOecnB3KSztn/v+fqTfG8Yl7tZDcOVx5zIAhdK2sDRc
	BKWc1gCHRGHzyseVKhOcyylJV49rQgl7vYkusnT5gDhI6LO3yDG2/M3RzNXg7xfNyki/qzvueBH
	1wO9AUB2ikpjnT/Jjz9GSX9PRyZ/nQDuKbSJdVMxG11ci1d60H/P3dHUqnUdnsqWH4mtUQa5dbg
	9oH95g==
X-Received: by 2002:aa7:db43:0:b0:662:fa40:a4ab with SMTP id
 4fb4d7f45d1cf-6672c04079dmr12810a12.5.1773720884078; Mon, 16 Mar 2026
 21:14:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <1e58aaf3cdb61cc317d890c12c9a558dfc206913.1773695307.git.ljs@kernel.org>
In-Reply-To: <1e58aaf3cdb61cc317d890c12c9a558dfc206913.1773695307.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 16 Mar 2026 21:14:28 -0700
X-Gm-Features: AaiRm51gRTcyoMqq_XPyOc66DyE9InTC_Zt20apDrYUnF7DiAEmv2zggrx-iJUg
Message-ID: <CAJuCfpGocCSRT0yDxPOLg2NZ+W_ZSTjHGPZRKBd3U90=sQtHCw@mail.gmail.com>
Subject: Re: [PATCH v2 06/16] mm: add mmap_action_simple_ioremap()
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
X-Rspamd-Queue-Id: 46C0A1C000F
X-Stat-Signature: scgjpnqk8jimophtd4qu1icp4n6gp7ix
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773720886-805917
X-HE-Meta: U2FsdGVkX1/NOdPLIqJBuCIGgDQANyngjkmADKNotqn7jcKIpRdUMHsWMi5/vDEnLsWTzLmq7Po9I8NFg1akjOuiKEng7nh4R1N8/fgan8VuOkYexNwJdR246qjf6dAo5cgZSmIGwDAe+3whbb1pHx/i4xyH6gtaSIPAv+HO9sbRRYpi/6AstE29gkfPIJO3jMixMK/aPbeFmevlp9tWVT63XTYV9Hx3CbT0/toAr8KAAXTfhl7x6go9Ydf7TblC8+Sy8cjAx6EiJ4G0+/J0Nwp5XWpn7hEG567Qu137q/Y2F8B6gv06rWH2gpQ7I0LWIX0DyJIk1Aa2xsI8cAfYllX/S4o+YRQoFJ0Zzgi2bdQeLy2RZ+AZdgRy1BP1gGeJNh4zJYtAXbegqKIpyiyzq0X2abOJIiKW6PTjA6IfMYX4xPhiPu7AconuRZqnKBDZSpjHytCFBs6UKNlvkSqJI8CZ3LTEQUquYf+CdhVETDa4bROnm1y2VbRg+XTJlqsUABZhUEa0XUUcuHVBuLJGTKfBW0imlDxlcrjsJESWrhaGnBkBaTYOx0V6pOHJt99rV9S3ofOXuc0yIEWM0VZ4Tk+fNM/cbG32yWO8Lbq5dE8kFlxZRK+sNiTNRuRb76rJEQ0VGJ996hPz1AiFsazU0uTOrCRS6Fw5NPxV2sxCh5epBWoLChhEjE5TSOMI3zGgAgym62ETM0nEiuWuVyRvPDZOZ8azNti6+ASFPcF3VKY3/z8XknKIAaiDVzazfQmmijD/h1MmFZ0E0YfV9xyWIMDvVTq+xpeGsALjzyut7brXBFbFYBbJSz8jTOSRxQg5wK9BNDrBkYFmaKaaaXgzKco35FEbRcMkd3jjqyqLA+Ccp1rSoBJl0crQQdZ/7m5TDlzT8PcMndUHc5CyVOkDlgGTPpYG0ZM76aarTp8ICcuRyApKP6KWsTqKW0g2UN74z7H64J8H/xQBjw3Vs01
 knL01KE5
 tXCi9gF7TsTXCQKJ99PplMUDeRhcZ4bPdnAjuvxTgOaesnsOUdTMsMwQOYpe/dIdkHOLgaYQpEb883/DZnHux7fic4JvkHbMh3vSHbi2Axv0wo79eowz7JT8IDEQGxI8xPP8XI2QxHvZo3fRhRMNz9HwXbqZvglzoxgEPgBcHaBOwqxFFMIBYNdQIr2vXTi80o9vTGJlRkm21kL76VCbPT5QoVDALFV9TeCZOmKhVdcm5/wEegli3aOJS5M++V5XyHkJg1dmC9tuvhJus37Wa9+zSW9TDYZSYGoNaNfl0I4GBJQINSV/VcS3Q6ihOaNLEBJmbxU1pL4+gSsKp00LGU9hOugS9Yfru7Ba81R1GbL7c6seXwaqOWiz+ME66p4cXGoP8v2hM0vM6WB0dq3bdCt9ngsuHBCdM9JiDlyIP/v6A1e+cwOuqPp8mSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 2:13=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> Currently drivers use vm_iomap_memory() as a simple helper function for
> I/O remapping memory over a range starting at a specified physical addres=
s
> over a specified length.
>
> In order to utilise this from mmap_prepare, separate out the core logic
> into __simple_ioremap_prep(), update vm_iomap_memory() to use it, and add
> simple_ioremap_prepare() to do the same with a VMA descriptor object.
>
> We also add MMAP_SIMPLE_IO_REMAP and relevant fields to the struct
> mmap_action type to permit this operation also.
>
> We use mmap_action_ioremap() to set up the actual I/O remap operation onc=
e
> we have checked and figured out the parameters, which makes
> simple_ioremap_prepare() easy to implement.
>
> We then add mmap_action_simple_ioremap() to allow drivers to make use of
> this mode.
>
> We update the mmap_prepare documentation to describe this mode.
>
> Finally, we update the VMA tests to reflect this change.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

A couple of nits, but otherwise LGTM.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  Documentation/filesystems/mmap_prepare.rst |  3 +
>  include/linux/mm.h                         | 24 +++++-
>  include/linux/mm_types.h                   |  6 +-
>  mm/internal.h                              |  2 +
>  mm/memory.c                                | 87 +++++++++++++++-------
>  mm/util.c                                  | 12 +++
>  tools/testing/vma/include/dup.h            |  6 +-
>  7 files changed, 112 insertions(+), 28 deletions(-)
>
> diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/f=
ilesystems/mmap_prepare.rst
> index 20db474915da..be76ae475b9c 100644
> --- a/Documentation/filesystems/mmap_prepare.rst
> +++ b/Documentation/filesystems/mmap_prepare.rst
> @@ -153,5 +153,8 @@ pointer. These are:
>  * mmap_action_ioremap_full() - Same as mmap_action_ioremap(), only remap=
s
>    the entire mapping from ``start_pfn`` onward.
>
> +* mmap_action_simple_ioremap() - Sets up an I/O remap from a specified
> +  physical address and over a specified length.
> +
>  **NOTE:** The ``action`` field should never normally be manipulated dire=
ctly,
>  rather you ought to use one of these helpers.
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ad1b8c3c0cfd..df8fa6e6402b 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4337,11 +4337,33 @@ static inline void mmap_action_ioremap(struct vm_=
area_desc *desc,
>   * @start_pfn: The first PFN in the range to remap.
>   */
>  static inline void mmap_action_ioremap_full(struct vm_area_desc *desc,
> -                                         unsigned long start_pfn)
> +                                           unsigned long start_pfn)
>  {
>         mmap_action_ioremap(desc, desc->start, start_pfn, vma_desc_size(d=
esc));
>  }
>
> +/**
> + * mmap_action_simple_ioremap - helper for mmap_prepare hook to specify =
that the
> + * physical range in [start_phys_addr, start_phys_addr + size) should be=
 I/O
> + * remapped.
> + * @desc: The VMA descriptor for the VMA requiring remap.
> + * @start_phys_addr: Start of the physical memory to be mapped.
> + * @size: Size of the area to map.
> + *
> + * NOTE: Some drivers might want to tweak desc->page_prot for purposes o=
f
> + * write-combine or similar.
> + */
> +static inline void mmap_action_simple_ioremap(struct vm_area_desc *desc,
> +                                             phys_addr_t start_phys_addr=
,
> +                                             unsigned long size)
> +{
> +       struct mmap_action *action =3D &desc->action;
> +
> +       action->simple_ioremap.start_phys_addr =3D start_phys_addr;
> +       action->simple_ioremap.size =3D size;
> +       action->type =3D MMAP_SIMPLE_IO_REMAP;
> +}
> +
>  int mmap_action_prepare(struct vm_area_desc *desc);
>  int mmap_action_complete(struct vm_area_struct *vma,
>                          struct mmap_action *action);
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 4a229cc0a06b..50685cf29792 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -814,6 +814,7 @@ enum mmap_action_type {
>         MMAP_NOTHING,           /* Mapping is complete, no further action=
. */
>         MMAP_REMAP_PFN,         /* Remap PFN range. */
>         MMAP_IO_REMAP_PFN,      /* I/O remap PFN range. */
> +       MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
>  };
>
>  /*
> @@ -822,13 +823,16 @@ enum mmap_action_type {
>   */
>  struct mmap_action {
>         union {
> -               /* Remap range. */
>                 struct {
>                         unsigned long start;
>                         unsigned long start_pfn;
>                         unsigned long size;
>                         pgprot_t pgprot;
>                 } remap;
> +               struct {
> +                       phys_addr_t start_phys_addr;
> +                       unsigned long size;
> +               } simple_ioremap;
>         };
>         enum mmap_action_type type;
>
> diff --git a/mm/internal.h b/mm/internal.h
> index f5774892071e..0eaca2f0eb6a 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1804,6 +1804,8 @@ int dup_mmap(struct mm_struct *mm, struct mm_struct=
 *oldmm);
>  int remap_pfn_range_prepare(struct vm_area_desc *desc);
>  int remap_pfn_range_complete(struct vm_area_struct *vma,
>                              struct mmap_action *action);
> +int simple_ioremap_prepare(struct vm_area_desc *desc);
> +/* No simple_ioremap_complete, is ultimately handled by remap complete. =
*/
>
>  static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
>  {
> diff --git a/mm/memory.c b/mm/memory.c
> index 9dec67a18116..f3f4046aee97 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3170,6 +3170,59 @@ int remap_pfn_range_complete(struct vm_area_struct=
 *vma,
>         return do_remap_pfn_range(vma, start, pfn, size, prot);
>  }
>
> +static int __simple_ioremap_prep(unsigned long vm_start, unsigned long v=
m_end,

nit: vm_start and vm_end are used only to calculate vm_len. You could
reduce the number of arguments by just passing vm_len.

> +                                pgoff_t vm_pgoff, phys_addr_t start_phys=
,
> +                                unsigned long size, unsigned long *pfnp)
> +{
> +       const unsigned long vm_len =3D vm_end - vm_start;
> +       unsigned long pfn, pages;
> +
> +       /* Check that the physical memory area passed in looks valid */
> +       if (start_phys + size < start_phys)
> +               return -EINVAL;
> +       /*
> +        * You *really* shouldn't map things that aren't page-aligned,
> +        * but we've historically allowed it because IO memory might
> +        * just have smaller alignment.
> +        */
> +       size +=3D start_phys & ~PAGE_MASK;
> +       pfn =3D start_phys >> PAGE_SHIFT;
> +       pages =3D (size + ~PAGE_MASK) >> PAGE_SHIFT;
> +       if (pfn + pages < pfn)
> +               return -EINVAL;
> +
> +       /* We start the mapping 'vm_pgoff' pages into the area */
> +       if (vm_pgoff > pages)
> +               return -EINVAL;
> +       pfn +=3D vm_pgoff;
> +       pages -=3D vm_pgoff;
> +
> +       /* Can we fit all of the mapping? */
> +       if ((vm_len >> PAGE_SHIFT) > pages)
> +               return -EINVAL;
> +
> +       *pfnp =3D pfn;
> +       return 0;
> +}
> +
> +int simple_ioremap_prepare(struct vm_area_desc *desc)
> +{
> +       struct mmap_action *action =3D &desc->action;
> +       const phys_addr_t start =3D action->simple_ioremap.start_phys_add=
r;
> +       const unsigned long size =3D action->simple_ioremap.size;
> +       unsigned long pfn;
> +       int err;
> +
> +       err =3D __simple_ioremap_prep(desc->start, desc->end, desc->pgoff=
,
> +                                   start, size, &pfn);
> +       if (err)
> +               return err;
> +
> +       /* The I/O remap logic does the heavy lifting. */
> +       mmap_action_ioremap(desc, desc->start, pfn, vma_desc_size(desc));

nit: Looks like a perfect opportunity to use mmap_action_ioremap_full() her=
e.

> +       return mmap_action_prepare(desc);

Ok, so IIUC this uses recursion:
mmap_action_prepare(MMAP_SIMPLE_IO_REMAP) -> simple_ioremap_prepare()
-> mmap_action_prepare(MMAP_IO_REMAP_PFN).

> +}
> +
>  /**
>   * vm_iomap_memory - remap memory to userspace
>   * @vma: user vma to map to
> @@ -3187,32 +3240,16 @@ int remap_pfn_range_complete(struct vm_area_struc=
t *vma,
>   */
>  int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsig=
ned long len)
>  {
> -       unsigned long vm_len, pfn, pages;
> -
> -       /* Check that the physical memory area passed in looks valid */
> -       if (start + len < start)
> -               return -EINVAL;
> -       /*
> -        * You *really* shouldn't map things that aren't page-aligned,
> -        * but we've historically allowed it because IO memory might
> -        * just have smaller alignment.
> -        */
> -       len +=3D start & ~PAGE_MASK;
> -       pfn =3D start >> PAGE_SHIFT;
> -       pages =3D (len + ~PAGE_MASK) >> PAGE_SHIFT;
> -       if (pfn + pages < pfn)
> -               return -EINVAL;
> -
> -       /* We start the mapping 'vm_pgoff' pages into the area */
> -       if (vma->vm_pgoff > pages)
> -               return -EINVAL;
> -       pfn +=3D vma->vm_pgoff;
> -       pages -=3D vma->vm_pgoff;
> +       const unsigned long vm_start =3D vma->vm_start;
> +       const unsigned long vm_end =3D vma->vm_end;
> +       const unsigned long vm_len =3D vm_end - vm_start;
> +       unsigned long pfn;
> +       int err;
>
> -       /* Can we fit all of the mapping? */
> -       vm_len =3D vma->vm_end - vma->vm_start;
> -       if (vm_len >> PAGE_SHIFT > pages)
> -               return -EINVAL;
> +       err =3D __simple_ioremap_prep(vm_start, vm_end, vma->vm_pgoff, st=
art,
> +                                   len, &pfn);
> +       if (err)
> +               return err;
>
>         /* Ok, let it rip */
>         return io_remap_pfn_range(vma, vma->vm_start, pfn, vm_len, vma->v=
m_page_prot);
> diff --git a/mm/util.c b/mm/util.c
> index cdfba09e50d7..aa92e471afe1 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1390,6 +1390,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
>                 return remap_pfn_range_prepare(desc);
>         case MMAP_IO_REMAP_PFN:
>                 return io_remap_pfn_range_prepare(desc);
> +       case MMAP_SIMPLE_IO_REMAP:
> +               return simple_ioremap_prepare(desc);
>         }
>
>         WARN_ON_ONCE(1);
> @@ -1421,6 +1423,14 @@ int mmap_action_complete(struct vm_area_struct *vm=
a,
>         case MMAP_IO_REMAP_PFN:
>                 err =3D io_remap_pfn_range_complete(vma, action);
>                 break;
> +       case MMAP_SIMPLE_IO_REMAP:
> +               /*
> +                * The simple I/O remap should have been delegated to an =
I/O
> +                * remap.
> +                */
> +               WARN_ON_ONCE(1);
> +               err =3D -EINVAL;
> +               break;
>         }
>
>         return mmap_action_finish(vma, action, err);
> @@ -1434,6 +1444,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
>                 break;
>         case MMAP_REMAP_PFN:
>         case MMAP_IO_REMAP_PFN:
> +       case MMAP_SIMPLE_IO_REMAP:
>                 WARN_ON_ONCE(1); /* nommu cannot handle these. */
>                 break;
>         }
> @@ -1452,6 +1463,7 @@ int mmap_action_complete(struct vm_area_struct *vma=
,
>                 break;
>         case MMAP_REMAP_PFN:
>         case MMAP_IO_REMAP_PFN:
> +       case MMAP_SIMPLE_IO_REMAP:
>                 WARN_ON_ONCE(1); /* nommu cannot handle this. */
>
>                 err =3D -EINVAL;
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index 4570ec77f153..114daaef4f73 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -453,6 +453,7 @@ enum mmap_action_type {
>         MMAP_NOTHING,           /* Mapping is complete, no further action=
. */
>         MMAP_REMAP_PFN,         /* Remap PFN range. */
>         MMAP_IO_REMAP_PFN,      /* I/O remap PFN range. */
> +       MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
>  };
>
>  /*
> @@ -461,13 +462,16 @@ enum mmap_action_type {
>   */
>  struct mmap_action {
>         union {
> -               /* Remap range. */
>                 struct {
>                         unsigned long start;
>                         unsigned long start_pfn;
>                         unsigned long size;
>                         pgprot_t pgprot;
>                 } remap;
> +               struct {
> +                       phys_addr_t start;
> +                       unsigned long len;
> +               } simple_ioremap;
>         };
>         enum mmap_action_type type;
>
> --
> 2.53.0
>

