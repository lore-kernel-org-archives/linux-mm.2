Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F06FC4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7292D6B00B7; Fri, 17 Jul 2026 13:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700CB6B00B9; Fri, 17 Jul 2026 13:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6185B6B00BE; Fri, 17 Jul 2026 13:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 337016B00B7
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:25:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9FF0E8013F
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:25:53 +0000 (UTC)
X-FDA: 84998946186.17.AC37E19
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id B2C8A14000F
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:25:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DCmxn4sD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of mclapinski@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784309151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vn+vPcBR7yKw800EHGrmkJfxwiILybxPqqHpaIR8qUU=;
	b=Wwms3fm4YR9HirnDPO7EJTJVdIBi1B8Y7odKhwRDGXgfjLbGzKfIDy/9gpw8nkNG+F9+Ju
	UeZFa+RdxtEqNs8Ax2X2RAD4ZKn+JYjWuYkiYsAlq2uHFzghojnjn2KeFFP8B5D7SboFP+
	+7bV2JP4mDOBogcB7aegNevvj/gTTy4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DCmxn4sD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of mclapinski@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784309151;
	b=Vp+wC6eCSwRPP2rWrfHQAj9pD3kP2PjPbhYBQMv7heb3PTo9osTwo0RhzeVjO8MYwSrgK3
	1V65KnbaAZzkvFEV1NGZ2Raz4pzpX2sWHESZos2viOWSe+RvpspxH0z5Pxsa/hcSN6oWU9
	9DPySjsrwOIppJ8nZ7nXshed51non3A=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-69a45011a92so17680a12.0
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 10:25:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784309150; cv=none;
        d=google.com; s=arc-20260327;
        b=l+8dwm/onZTBiIakItJq244oeOU6KttiLQzmicEyAFy4BLN/ZJxBNNoAUnyZM0z/Sb
         dOSTwOkmO+NK18pnkBOGuMCcFi52ohf6e14H5J0qxvplCVsvP6B98Sm8l1pv/iiFLAVn
         UAnsb6ymGdIJt3hQ12GboB07ox2mqS4600rCwFRaIxpeyUuZY39Cq/CIZTmwJnSNqcOi
         eE5LCLWmgR9/tO9zvSsxV7IMsg+mhUTvtDF7y8eIMndDSnAfj2lLJf6WiqIYNDaGIVG/
         ZKkBKEDXnCl4/bMEkIlhnOr5uQs5awqCh8IVznMaCdSxZEsslcRgQqiBZTirxZkN4ceT
         3MDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vn+vPcBR7yKw800EHGrmkJfxwiILybxPqqHpaIR8qUU=;
        fh=4lkUd/sErsB+IP+bg7aTGWPyQb34DbkbIN8dTDxijWg=;
        b=QBAGpw0IvAWgvehiIVDS7ePGmCYksMupsWz7Dbig2DYXOUKH5wDvTgX9yHUL90C6sm
         fgEKrfOQqNbPIxc1SjqQWfSf16q13A+URe5ej1oUlBDtIsHzdDyns52LZE135RiLT/mO
         dYco7QzCGVVN3+sCfeEUQ3utUJKw4EGwzK3bF1ek7c6w9nnGc9zqUPfL5gsQDdR56tXM
         7Bo+mulumMtIxi8JutWyGFhLahmfu+PuDOX+Djo/TEs5GfxJl+SNGV9TJfFuVw2Wwjp8
         lFCktIT82iFE2oKSkglUYzfrnsa0fsFI37Bu/3WSk1dlwGCrgIXEd9UsCLgKuNeocGPT
         DawA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784309150; x=1784913950; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vn+vPcBR7yKw800EHGrmkJfxwiILybxPqqHpaIR8qUU=;
        b=DCmxn4sDMQm9uU8YCdWL5py1CTE56Y1C00aR+h7LBAh0RE5+uZEfq0PfQcmva769mJ
         5VFj5QqUvf5MaMHhWle9MyVKgxI3OTTEXSVZbNX2Z07Wwg/uh3IWDJBlvHezifGQk6wT
         ldW4oPC4MtIkRtc9L1CHGv5C2drRz2r1+eyv6Ot+In+WofbDlUKhXAiXDohYKCC0ywZn
         SfgwJ7vZaYbFrF5NGXkJHz5FJQbtQ55FYFkbM4YRKs372NgMb/bZOf0K3TCL1/yidWwB
         VnZiApUGz8DtAHyDwlg2Hu5y3DcFG/FXOqtU3qg/iKIsEAuDUNz5geNWVa38VG9hTADd
         Q6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784309150; x=1784913950;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vn+vPcBR7yKw800EHGrmkJfxwiILybxPqqHpaIR8qUU=;
        b=IvgHaPY2S1Sf4Jl3LOga8x4EzPgZ6dVtbmiazT7R3GEM36H4L4tEPSmzrRwzIIP25g
         B9M5FCj5roslmqWNSIfOpCGf8S8UYiuhCrsWu8vLawXqWTmweImEzRWuH8EVrPG/YpQa
         knGE3CMtj3FMIkH5piDRVa7SK+YfypxMbyERhNVIow19dhrRTa706D9Whwy/4ZmaS8J7
         KfmJEzyE2i5O3NVujjGxrxghaWCTMOGNP83EJcu3hlofGpCThpkbGZ2wBLgpbrTahp4k
         /WfXGECmR1criO2FXj8WjgmXOLKoG5XBoQcKEgrYXsuizSaUpkOR9dyrLuCzcl6Sdmgd
         FR/A==
X-Forwarded-Encrypted: i=1; AHgh+RqEVOuADq1A4RLwwVTh4zIy4hZTJ/9WlUi3mDBNDGo4Jij//jQwdHRFc4fwVcalZm3rK1jRURD2QQ==@kvack.org
X-Gm-Message-State: AOJu0YxcFk9kXfkNLv/NT2uVgcZiRjnwK/ZSHUrgwGEJ4LffXF8gkhAm
	gZNiKG7ogCNZVGPsVWFTThVpB///RWExvsKjmBRYwYt7NTZpXdnXuuoJdqcbB8PMN0+24L3CIKz
	F7hvHnUAb/VoGD1wMmhe7GMpNb+wd4bBTpHwjhhuV
X-Gm-Gg: AfdE7cnVeWDMuKSeSj9r1UWpx2rO/X0axvlLJuJmLZtjMTPWCe0YD8zAoTThuHpTYtH
	UHcTgQFgfulKFvSDSNBG+Pookh/hhLKEft9T0ykAbru4HgShltQIqPdnNy7fDcK7TEgdwrgOCAk
	PQ//0dxmW4IU1xQDnbwMd3/WUkbF9tR8JHPfYN3GG5gcXQdK86Lqa5AbZPdlVudna7XxWHndDAA
	SPdYXGP9hULTXLTNSI9JzvyE8wiJ4NG7mApN8Cq5bHVPm6LgzwIb0ujre3Q
X-Received: by 2002:a05:6402:1244:b0:68a:e1ba:9cc0 with SMTP id
 4fb4d7f45d1cf-69e89ac9e37mr2887a12.8.1784309149795; Fri, 17 Jul 2026 10:25:49
 -0700 (PDT)
MIME-Version: 1.0
References: <20260717134028.2880508-1-mclapinski@google.com> <alpWWFo1gnxVnP7T@google.com>
In-Reply-To: <alpWWFo1gnxVnP7T@google.com>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Fri, 17 Jul 2026 19:25:38 +0200
X-Gm-Features: AUfX_mwtqaEj54b9UO72Tsip-eG3KMthhMEZ491YyqaB1ESSnxwLuQFSVqeb19A
Message-ID: <CAAi7L5f0huF0Gyo_uw-UM2zZdgeQtee1dNHW0pGMCW01HdsVZA@mail.gmail.com>
Subject: Re: [PATCH v2] kho: align kho_scratch to MAX_ORDER_NR_PAGES pages
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Evangelos Petrongonas <epetron@amazon.de>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: osqjtpgizrsx3sz4znbp6iyowtmyb7qy
X-Rspamd-Queue-Id: B2C8A14000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784309151-974982
X-HE-Meta: U2FsdGVkX190ACVCO/+jNxlvWpBJKMbsgw33csaIhWp/dwoGipV4xR4lvNjOYZ/9+Jm7DSIdiqo0Lh6Avu+ue/fEqjCqi8PerSTg14VnwSyjpqWiDNV2Rh1O9DR59YCmufKDEFNHZaTMJm3aTpRo3Pca70BsC/j/rVVvbjyV06P5QCatR5ATI9CRrqHVMped3ocuNJqL1lU6DLEYD8TDFjEEotKfH2U5+27vuPA/qqpZW0dwuwa60rRe9Sm/AhiF7aBK/m8y/35JK4AtxHziB7/Ya7PE5XJgy4a2GsWcmh9IXx0GfRCmKcC9oEtsDdoVn0FRpkNSpE3zGriKcw73zKDkScfhCrKB0/JweVlHJu9woavW/g7t7aJWuJHxJkL0PzA2jzxxDt0EZqV85JVe/npwdfrBy84nVcuBSxpjxE9YiB2oT8JNcPUIMd65rRjfViQIaEMUxgw7Jn0epwRgcf3A+BXQD9++tl2SnO1DzNXuHB3xA59DEM/O4D6gYkQMq7GWKmBND1b41npyFICf21Gpk5J/ukxh9vF/pn2RLSAheTXnKABV7SF0qPmd1Aq+SOenvnumVcB20t4PIvpeXKoCg6rD5P4Iy/3PsSuYsBwWHKt72bWDfzsBD6nMIe34Q89uBLknohPJ9kALtlWIpsvvST5QjZh8uXYzXiEGMDqDjPjcNLSQkQbENyY/5vZ9bhqJtmaghJ3Oj32qFQ6CL5gxHAw3H/Ajf6NceEDIFX7f5YK49zvpERgwl83KQTdlVT57VpN7CbbgvfoYCdkEmshuWGX3jVKII8jhzg4P5QmLGtGr9cSZkvU/amf7HTmeJLt6At4wo/Z5WGpfr0gNqyCL7NOnwODTGGVwoWXRG93sgl8taB9rrOwaqXxdLQcPxRs6XM7zovgPhfO5aL1BkMCaREinT0iVPgs0tJDgBsZIDthepZzbviA9VuzqkExOL/H6kkx9oxFlnY5jum3
 ymKBqpMr
 of9NP4IXn0DJgKaFc2buYPOt4OWI0SC5+KNeeet8oSVpGP1ZW2bkH/Ye+kPcgUoWY4v668+3Jr0YwoHUN6PgUN7h9DX6BI0D9ze9qrVzn+2M3a7PEqvN8fuvJO0dTqIvUpxdJhbgpSQ6eWqttM9kMjCWzyl5FJt/hW9he3i79UjzIb28bHiE3h5otpymxBjmEH9D8Hg8T+lJEY4oTK0JcPH5rPMilCfu3mzRTve/RWoo8vKFFfM32mYjC5r5yClVQvVxwBbqe+7pafjOL/AR47RPlTmkg5wGHxtbhgKJVeGKx0bQSMtsDK4MucLSlGb3r0T+qDxZISmbg1ZYalHr3WwLU8WnYPt8RBWCRfq31rYkZ8y1RvHyP86biYgKVT2IczQf5aMWYQNth8THnhJayx92egTJpwqW6Hd/P5WDgDH1CAwlEdjXyNxvn3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 6:21=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On 07-17 15:40, Michal Clapinski wrote:
> > While booting with KHO, the following crash was observed:
> >
> > BUG: unable to handle page fault for address: ff19164fffff8328
> > RIP: 0010:__free_one_page+0x1a1/0x6b0
> > Call Trace:
> >  <TASK>
> >  [<ffffffff913208bf>] free_one_page+0xaf/0x240
> >  [<ffffffff93973288>] deferred_free_pages+0xa8/0xd0
> >  [<ffffffff93971b4f>] deferred_init_memmap_chunk+0x10f/0x1b0
> >  [<ffffffff9396e265>] padata_mt_helper+0x65/0xa0
> >  [<ffffffff90fac402>] process_scheduled_works+0x202/0x410
> >  [<ffffffff90fae739>] worker_thread+0x1f9/0x2d0
> >  [<ffffffff90fb62fd>] kthread+0x27d/0x2f0
> >  [<ffffffff90fae540>] ? __pfx_worker_thread+0x10/0x10
> >  [<ffffffff90fb6080>] ? __pfx_kthread+0x10/0x10
> >  [<ffffffff90efdc55>] ret_from_fork+0x145/0x280
> >  [<ffffffff90fb6080>] ? __pfx_kthread+0x10/0x10
> >  [<ffffffff90e2e46a>] ret_from_fork_asm+0x1a/0x30
> >  </TASK>
> >
> > deferred_init_memmap_chunk() interleaves initialization of struct pages
> > with freeing them. This works fine without KHO because free regions
> > will never be neighbors. However, with KHO, free memory will be split
> > into (free && scratch) and (free && !scratch), which can be neighbors.
> >
> > KHO scratch is aligned to CMA_MIN_ALIGNMENT_PAGES pages but buddy looks
> > at the neighborhood of MAX_ORDER_NR_PAGES pages. These values are
> > configurable but CMA_MIN_ALIGNMENT_PAGES is always less or equal to
> > MAX_ORDER_NR_PAGES. In the crashing configuration they were set as
> > follows:
> > CMA_MIN_ALIGNMENT_PAGES =3D 1 << 9
> > MAX_ORDER_NR_PAGES =3D 1 << 10
> >
> > So while freeing one chunk, buddy accessed uninitialized struct pages
> > from another chunk, tried to merge the blocks and crashed.
> >
> > To fix this, let's just align KHO scratch to MAX_ORDER_NR_PAGES pages.
> >
> > Fixes: c6073743d0c7 ("kho: make preserved pages compatible with deferre=
d struct page init")
> > Signed-off-by: Michal Clapinski <mclapinski@google.com>
> > ---
> > Unfortunately, this is very hard to catch, so I don't have a good
> > reproducer. But I run the code with the fix through extensive testing
> > and it seems fine.
> > I think I've never caught it before because enabling HUGETLB is what
> > causes CMA_MIN_ALIGNMENT_PAGES to be 1 << 9, instead of 1 << 10.
> >
> > If this passes review, please cherry-pick it to 7.2 so we don't release
> > a broken kernel.
>
> A changelog would be super helful here.

Sorry, forgot.

Changelog:
- functionally it's exactly the same
- changed SCRATCH_ALIGNMENT_BYTES to be calculated using
multiplication instead of binary shift
- updated the commit msg as Mike asked
- rebased on top of liveupdate/next

> Pasha
>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 22 ++++++++++++++++------
> >  1 file changed, 16 insertions(+), 6 deletions(-)
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kex=
ec_handover.c
> > index 4834a809985a..175c08a6e41e 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -38,6 +38,16 @@
> >  #include "../kexec_internal.h"
> >  #include "kexec_handover_internal.h"
> >
> > +/*
> > + * This is the minimal alignment required by deferred struct page init=
.
> > + * deferred_init_memmap_chunk frees memory to the buddy allocator, whi=
ch looks
> > + * at the neighboring pages (up to MAX_PAGE_ORDER) to merge them.
> > + * If KHO scratch is not aligned to that value, buddy can access unini=
tialized
> > + * struct pages, which can cause a crash.
> > + */
> > +#define SCRATCH_ALIGNMENT_BYTES (PAGE_SIZE * MAX_ORDER_NR_PAGES)
> > +static_assert(SCRATCH_ALIGNMENT_BYTES >=3D CMA_MIN_ALIGNMENT_BYTES);
> > +
> >  /* The magic token for preserved pages */
> >  #define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
> >
> > @@ -640,8 +650,8 @@ static void __init scratch_size_update(void)
> >        * Scratch areas are released as MIGRATE_CMA. Round them up to th=
e right
> >        * size.
> >        */
> > -     scratch_size_lowmem =3D round_up(scratch_size_lowmem, CMA_MIN_ALI=
GNMENT_BYTES);
> > -     scratch_size_global =3D round_up(scratch_size_global, CMA_MIN_ALI=
GNMENT_BYTES);
> > +     scratch_size_lowmem =3D round_up(scratch_size_lowmem, SCRATCH_ALI=
GNMENT_BYTES);
> > +     scratch_size_global =3D round_up(scratch_size_global, SCRATCH_ALI=
GNMENT_BYTES);
> >  }
> >
> >  static phys_addr_t __init scratch_size_node(int nid)
> > @@ -656,7 +666,7 @@ static phys_addr_t __init scratch_size_node(int nid=
)
> >               size =3D scratch_size_pernode;
> >       }
> >
> > -     return round_up(size, CMA_MIN_ALIGNMENT_BYTES);
> > +     return round_up(size, SCRATCH_ALIGNMENT_BYTES);
> >  }
> >
> >  /**
> > @@ -692,7 +702,7 @@ static void __init kho_reserve_scratch(void)
> >        * next kernel
> >        */
> >       size =3D scratch_size_lowmem;
> > -     addr =3D memblock_phys_alloc_range(size, CMA_MIN_ALIGNMENT_BYTES,=
 0,
> > +     addr =3D memblock_phys_alloc_range(size, SCRATCH_ALIGNMENT_BYTES,=
 0,
> >                                        ARCH_LOW_ADDRESS_LIMIT);
> >       if (!addr) {
> >               pr_err("Failed to reserve lowmem scratch buffer\n");
> > @@ -705,7 +715,7 @@ static void __init kho_reserve_scratch(void)
> >
> >       /* reserve large contiguous area for allocations without nid */
> >       size =3D scratch_size_global;
> > -     addr =3D memblock_phys_alloc(size, CMA_MIN_ALIGNMENT_BYTES);
> > +     addr =3D memblock_phys_alloc(size, SCRATCH_ALIGNMENT_BYTES);
> >       if (!addr) {
> >               pr_err("Failed to reserve global scratch buffer\n");
> >               goto err_free_scratch_areas;
> > @@ -721,7 +731,7 @@ static void __init kho_reserve_scratch(void)
> >        */
> >       for_each_node_state(nid, N_MEMORY) {
> >               size =3D scratch_size_node(nid);
> > -             addr =3D memblock_alloc_range_nid(size, CMA_MIN_ALIGNMENT=
_BYTES,
> > +             addr =3D memblock_alloc_range_nid(size, SCRATCH_ALIGNMENT=
_BYTES,
> >                                               0, MEMBLOCK_ALLOC_ACCESSI=
BLE,
> >                                               nid, true);
> >               if (!addr) {
> > --
> > 2.55.0.229.g6434b31f56-goog
> >

