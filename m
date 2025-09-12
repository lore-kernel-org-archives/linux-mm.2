Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 359BFCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 21:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398868E0008; Fri, 12 Sep 2025 17:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3701B8E0002; Fri, 12 Sep 2025 17:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 285D98E0008; Fri, 12 Sep 2025 17:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1472F8E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:05:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AA88411B08B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:05:32 +0000 (UTC)
X-FDA: 83881829304.02.723F129
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id D05E7140002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:05:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CrsoauYF;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757711130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LS6N8Phvjq9J+fDOffQfqEhS8X+tEPx7m7a32OEvstM=;
	b=wMdUIM9n4ik5gH8t/3Pi506QItMSL4+pC5npkrBF6fq29NPi8ls7vOcrG6Q9aEso1DjSLt
	uW8zGeFb1apGMBXJz8ccTWyFpt6HDQZroxqH7gEYfoOdrgijg7QrgNFAa9HrAOW8vdPUcg
	ScLvdTA3X7H7EPA+dlEsHz0AUQumoOE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CrsoauYF;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757711130; a=rsa-sha256;
	cv=none;
	b=Dksg4mW0QI023xwTT8uUniV+APadTCaKWDp331sY1J91Te7eXVe90CkoBnry34XzX1XPAb
	lnMJAICDNes5CjQGVk9IM+ZTGQazgqKeYKQM3bWERKu+iAHl8e72wwu/9SoObTKUv2NWv/
	udtbU2whWLdkRIV4IOwPs7I3EdhzURc=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b4bcb9638aso45561cf.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757711130; x=1758315930; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LS6N8Phvjq9J+fDOffQfqEhS8X+tEPx7m7a32OEvstM=;
        b=CrsoauYFp4i/ozPAWR1na9YpFEglxxC+8vww4ckBXD1f279kVl4YGgLFj+4gW5fCnI
         XHq98zvkkclQY/sZWpU2VNm0nes69QFh1AZSJdB5hVrTs/qhclbHTMb5BF8GW8Bjh5DT
         X7UONcJml64jCN3TWJVmluw3TAieAdXV1nleFCZ2oJGmTGKJrSjHqwIJtgJ0rLRT+hHR
         VeUGNT6y3k1ygxwDEvubcIKXNWLGRMpjdm23dotqen/Xdiw2NV+UszFaxji31HDurZI7
         6N5rLGSBPFXaQ21o+pqgy6LW4bdgaKE1tEt9oPtIJoaU50xThdep8AQofwNeGwFZskRF
         Vg5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757711130; x=1758315930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LS6N8Phvjq9J+fDOffQfqEhS8X+tEPx7m7a32OEvstM=;
        b=aYgGY0YWDP2m5Danp92+S45SJoCpN9KFR8MuZuQEIl0aYhf25z9Op1qQnO2BlcGhrJ
         4uMVGIkNIxg8YY4jqNeENUS1XLiRAbL7325V0n0I/VPPg5UDXAMXdeC/BRw94dzrYt2x
         rGhwBswxQAhfxdvXS9iCyJ98NNasARnhaAlO06CntEx8cGS0JZC3K/kiYl4LMaEs+XEt
         e9hsV+czbd8jQt5CY9RKe2h2c6FvA5mYudVYbcJp9rrvu4FW5VCtwAuZmrfSA6L1X8xq
         unjSBQaw+ek5KREUUp7Cd3XoB2luabLfyq/vLyFBlmQXLDHGcbNyJ/x4UU2RmL1IN9AT
         /Law==
X-Forwarded-Encrypted: i=1; AJvYcCUdmSTINmyO5hy8pxv1cnq8d+RlPBH6YTJlqRMx2UOU1SYNFw+0Jm21IXTC6gJp29wb+9+of/oCqQ==@kvack.org
X-Gm-Message-State: AOJu0YzBxcT/IB8jGXyAWOYnJ81ePPRuMpFw9sVRxq99x0witKER7M7d
	Bca/h2Y6nOdbYkFu1JhpjId9kM5+iUHZmAO9G55/UXDfAcNSqJCThNCAOx49Y5Niwi9wEespxIZ
	or3raXlsk06FZzabiw7wokSlxDTB/e1W40zQt44xE
X-Gm-Gg: ASbGncuV2pAd2OMGUBbmlTdqrIxf8G4B3cRUrUwrXjxorqX+DGI3O/o7CAj+O2ehzjf
	1rXSXeeafDo1v1fB4ufyr/FmniDhhCckLsJ8cPH34JaSPF0hNlKrDEBJWEEPMd52grMZoIYlrfT
	U4BG4qkAqiStPMfr7PP7zvPNiGAgZXvsqdMBlVap9tWnV7LhKFmW4UJIG3AivKKqdDKg7TpKfV1
	oytAuMTY3+PHf6JMPPeQaE=
X-Google-Smtp-Source: AGHT+IHb2K2xXlIpqcAzf1xMj6i87zxQ9C/c1C073ZrqSL1hu65ba+HrjVU/5m45uOUXUsbx8ELp9JxVxwF+qaMRAJs=
X-Received: by 2002:ac8:5910:0:b0:4b3:487e:741b with SMTP id
 d75a77b69052e-4b78c6df940mr338881cf.4.1757711129577; Fri, 12 Sep 2025
 14:05:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250909233409.1013367-1-surenb@google.com> <20250909233409.1013367-2-surenb@google.com>
 <c2efc885-8b23-4ef9-8eca-05f17e158fb3@gmail.com>
In-Reply-To: <c2efc885-8b23-4ef9-8eca-05f17e158fb3@gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 12 Sep 2025 14:05:18 -0700
X-Gm-Features: AS18NWCOujUdYpmOTJkjMpH1lwHsOYcF8mubnSwHOTjZmB4XICE1Z6kVVsS-ZQ4
Message-ID: <CAJuCfpHf6shxs0A1dmRuYjjU-wU8p=tFD3BO43DTYbZ0U=rFMQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] alloc_tag: use release_pages() in the cleanup path
To: Usama Arif <usamaarif642@gmail.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	shakeel.butt@linux.dev, 00107082@163.com, pasha.tatashin@soleen.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D05E7140002
X-Stat-Signature: kwqor6i5s7rzcwnm34dcnkasa4ao1c7h
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757711130-88962
X-HE-Meta: U2FsdGVkX1/iUbOLbTf6SczMP4eMkLCXokZdHSzfphEH4DlW9Gn+dxKLSLV5DBr2OGelO00CwbHSH67WiHhVt/NXqhxfxUGsJJTigBaHe8FVPah61ZpL/6NfmuD8GZaNx6Jr5CGq3EXmwdYUEDkPwkQQ4SsMS+gygyRF85BHiZPvCAXkTy7H+nPUsj4DDYaJnNhRnaKrrxKpjxTh8Qnzqq9g0Jb5XFq59NtTYn9GGhvu3hEQ0RGyaeKsmK6FiYIMxseBa4XaaebBQgyB1O7F85uzsQTruNzsd1GVk9DKU72g9RookBWXGzTu2axzE/Wb9Hui2f4txeE8QxoeafTAyU28IpMcqRtdDytZwj4XjlZ/dBOUvzQfplkrUnoxMpUkVDqqQFNfAgU7x/7sfrKkGDdFUnu6mbG6SKzSTt7GEcViXa9PlOrD8Vm4QT5nbB029sH0dwhw/86oT/W0AcLhZ37Rf7Mnl5k/ujMStmkfC2FJNvmiO7c8RdZpRxFFsumVfA9qeqfkmCH75tQwz3o//wJVtBZ2DZloUnrqPaxL0AM7ep487SWtiZrxLQ/Lfp2N7yB1P+RaJz33iHNcooJx1K1TpSgkwKd87Bcb1Dg+1PZbCfeASB4qHWl3pIaFLYSyDzrgbsh4YTPQ3SMX2pf+F4DbFlOin9LewaAZZvAeJzlsu+NmL1mX6TaVeg83DDBX1NTWRwTDMXzPqMSUqipbnBSWXwroMsrMUlB2JFeTp79iUog4Ny3MRS2RekAklzt1Vl8t/D6RxCuFyPTc9C0/KMFX9wmRe9GZ4q1LtT1P2YXm0bWSn6NyC8T96M4n1a6qwxkjZ91Gso+Zc4O4RI6viZnnfgnm7iSk4ZZ5vN5H5VCuRojwN4HyelXjMqMGSS8QQi3A6Qz2C+IbXTwhm6345tNyRZ0AygQPp3hrHev7UEjoBKc/QOzRTVM0gJOOZL0FwtzuzAUddGUejkn4y65
 /PS2HDBO
 MjGGi+S5t9OKXVcR7ijnY+BdFRmXgx6SoYwvhdTyeYVm0SWmOxl7XteoAWOsudoMFI4upSmOOFrR4UQI25haZQE7eLDGCefsoOg9NazgBNYXHwxQmIPg1dD4jOewCs4HxCWN+BQAVcbV1CwhEmYM+p6yfoWCjLF89nx1im0uj2LEe+tNBcANN4nON3Z6qffuBoX4ae+0nF9aD7nusD+xNDiA0dYaUpmV3OhLikuxwTiOP/Dk5k0Fx8BUw3b3vmBsGzJZeYLp3vCJyD7ZV+xe0kOGXrpzCBiJgeFMBHp549I7V4+Eomk/f5x6x9JSaHbRS/EJvjiarRzZOVydcfRhZVSTUAOsfoYboNDwEW4mDDMk31SCB0fX6DffWkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 1:49=E2=80=AFPM Usama Arif <usamaarif642@gmail.com>=
 wrote:
>
>
>
> On 10/09/2025 00:34, Suren Baghdasaryan wrote:
> > When bulk-freeing an array of pages use release_pages() instead of free=
ing
> > them page-by-page:
> >
> > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  lib/alloc_tag.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
>
> Acked-by: Usama Arif <usamaarif642@gmail.com>
>
> > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > index e9b33848700a..95688c4cba7a 100644
> > --- a/lib/alloc_tag.c
> > +++ b/lib/alloc_tag.c
> > @@ -438,9 +438,10 @@ static int vm_module_tags_populate(void)
> >               if (nr < more_pages ||
> >                   vmap_pages_range(phys_end, phys_end + (nr << PAGE_SHI=
FT), PAGE_KERNEL,
> >                                    next_page, PAGE_SHIFT) < 0) {
> > +                     release_pages_arg arg =3D { .pages =3D next_page =
};
> > +
> >                       /* Clean up and error out */
> > -                     for (int i =3D 0; i < nr; i++)
> > -                             __free_page(next_page[i]);
> > +                     release_pages(arg, nr);
> >                       return -ENOMEM;
> >               }
> >
>
> Maybe this can be done in free_mod_tags_mem as well?

Good point. I think I will respin this patchset with your suggestions
and will include one more fix for an issue that Shakeel just reported
(see https://lore.kernel.org/all/CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE=
8pG0K1uXA@mail.gmail.com/).
Thanks!
Suren.

