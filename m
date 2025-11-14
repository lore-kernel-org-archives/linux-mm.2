Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92FFACE8D62
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F26278E0042; Fri, 14 Nov 2025 12:22:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED61D8E0010; Fri, 14 Nov 2025 12:22:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC5568E0042; Fri, 14 Nov 2025 12:22:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C64DE8E0010
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:22:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7486F88C2C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:22:02 +0000 (UTC)
X-FDA: 84109880484.21.BDA2808
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7469D140007
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:22:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=R8sWqb8F;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763140920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0TVgXqLqg97YQ/m1CXUTN7T2KTMv0q/tzdoKWytqb20=;
	b=0GA1LTewSWGQHX8pSz/anrofLOSqDSlB9IfxY7+HUjNqreMMqg+AM9MOp6kaFP6d3UOQfx
	OzcW2Xa+tdU7cU/n5ud1SVruqMgHelr8LbRpkl/Y3fIl7SHj94TdjmnD2WIVrv+Pox9JxG
	AKPBSStBlA+iviyiWxkEGzzZdMC5VbY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=R8sWqb8F;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763140920; a=rsa-sha256;
	cv=none;
	b=tStkhjigxQXoLZDTIBblH67m+h8DXqI8Vd4ylFNvXSPn48gDTvLRd87C0HtstSjGGP199r
	zgBROQ2+8Hegsc2HYFp2UNf8qw2BXX/ghppPNH5GcOjzIoceCAcnrSuMslqvMedsePJw8A
	0MPORQ+jnIrZlLztqS34CgiQobzdW6c=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-640b06fa959so4025128a12.3
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763140919; x=1763745719; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0TVgXqLqg97YQ/m1CXUTN7T2KTMv0q/tzdoKWytqb20=;
        b=R8sWqb8Fq0Kbq12s37j/U0esggFRttiThvXJHhRzbsjopIto6ec6eebuo2OD60NEfd
         tCUYEjNL3CridcP0O/WkCmH9mTHGVXKlO9JQO1EEFt3VwrSqw+yStphSxZ6l8c3gqn4E
         7fFaI5EDzd7XNF2VXZNNy13ixPhjWEQ1MTJ9AquP7L4FMAZ41bVckMfVBisoxFRnGmrP
         dfFfvypEyDpt+hyQsalheiqtSu0diUyY8A3krlqt3q0AhKKJwGhA0Iuo8Mlv5+l6tj/C
         GwFlqMX5cUzHtISNj6D7SfgKYEd5IA/r6CCbrorTdqiJH1xpgPSEEWgzM+X+c9OBhdXp
         OGnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763140919; x=1763745719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0TVgXqLqg97YQ/m1CXUTN7T2KTMv0q/tzdoKWytqb20=;
        b=HX9xA/kLJ45krnXE0tdzHrB8sO4LHwBKyJSWXPB2N2f8+Eosmk+g+rYWBaqVfJ9lZl
         vpnKznAEtbDrFyvBcWa3rtZM6uED0Yb5ymwolcTzE1Aig5e+c8lOwmukLBBxEdolTEou
         MA2I+3C7n0dYmotiEewKIPWzFMPrCklABX0oULaz/v6JU9bbVeoubDqH2YA5ltk/FM9E
         33IiDFLHuCpSvVhlWz+34t8gEYLG8+icfudfMrDXG0UrqXTNJ2o6nzEekiU8DYFuoXcD
         0uTyYcYQqQTs/IO6wMnGXfQvGOY1VGT3Gt0BJbDsrwq5QtEyJ8eGMfW4V2ggd1aJG5lF
         kdCg==
X-Forwarded-Encrypted: i=1; AJvYcCXWIyrjPa9ge1nX2aVPUuSm2wqj6pBXlcjmIETawSj0Z8qsnDjS0zlQRvWR9kzV/pr3BELen3XqJg==@kvack.org
X-Gm-Message-State: AOJu0YwGMpYPfTvV2Vk50rEvh+nJCbAxgUJ+33gnau4cAd8Nn6WY546v
	KwZEvQ41GDgYgCk+FVr0nXg8AjT8B0/xjBH1clCPZUdRAq+dLDY3Cp1RUbDJvw/ANBy7jpI3/gp
	jY3/Z/1fgzHbAGE8XONXdmkcEaAkRCipLxKg+eG64VQ==
X-Gm-Gg: ASbGncs8MJf8uyON1a/MjZtOh1Mj9FdkdPV8wArIMlULYMfqcu4exQLc9SH0PFLr2Kw
	ht4oXuJHGXaMc6Tjw5qhvL2trKoVdDhi4fVarKTBlK3s6mX9fkOS/zehjEVlxLbhsDVEVemB/mI
	oGT07nJ+KTjlBNhJPY3I+K86oQJ0AamHBkjQSi7MCgQdU8xfHpeQgkSEKM/J6w8CD5DNe4IkS89
	92KQV4qQz+rZS0hd98/E5JlVI0lNS387baTQTtoTElT/+k4peLlYihWnbNnmkge3or67vRuT02m
	HU0=
X-Google-Smtp-Source: AGHT+IHYCGe5EZttu74Kr7Wh87nzjge4/R6w5u4bJFNP5Xp7DoWHA3m+n/3j2Vr/nlr7+Zv6hOy2EF3HxmxGzlfQyHg=
X-Received: by 2002:a05:6402:42c8:b0:640:abd5:863d with SMTP id
 4fb4d7f45d1cf-64350e869b2mr3251200a12.20.1763140918227; Fri, 14 Nov 2025
 09:21:58 -0800 (PST)
MIME-Version: 1.0
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
 <20251114155358.2884014-5-pasha.tatashin@soleen.com> <mafs0tsyw7e0a.fsf@kernel.org>
In-Reply-To: <mafs0tsyw7e0a.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 12:21:22 -0500
X-Gm-Features: AWmQ_bkwQNcWIMU2RTcQ4saxk90WtRQeCs4SP12Mj6QMS9uqJrYZtq9AM6guyhU
Message-ID: <CA+CK2bALea-5wDyaU2gMYo==yOvrdj=V6FKc4g7G8KV_vgV6Mw@mail.gmail.com>
Subject: Re: [PATCH v1 04/13] kho: Verify deserialization status and fix FDT
 alignment access
To: Pratyush Yadav <pratyush@kernel.org>
Cc: akpm@linux-foundation.org, bhe@redhat.com, rppt@kernel.org, 
	jasonmiu@google.com, arnd@arndb.de, coxu@redhat.com, dave@vasilevsky.ca, 
	ebiggers@google.com, graf@amazon.com, kees@kernel.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7469D140007
X-Stat-Signature: wx77hu5gnd6acaw9abanwxnx584cor98
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763140920-521134
X-HE-Meta: U2FsdGVkX1/9/HyxTrsMwqf3nLXma0/xKK7UTozbggcNxHZGiYPcdd1Kw/r3gc9tpqXX9qNzf08smvO386GHLHjQB6wp503a8M1R4GBPel8L/bKkeNzxrRmluZJv/Q6zTDm49RNIgRhEoCAAvOH4EY+om0ppp4cPgVtxMiqfH6qcP+iDKpfvSliPE64XzMWmtFCujzZKCKOkNzQY+pAVSzbHxQYChRbReost8i1TvqPWKTlHaTF5/BTN5wl+lrteknIL2Lg0rRO0T5z8BCM74bXuA+UXh4UrftXLMLcv2LieXpcqWaPkk2ZPnDOl8KeaIMxfAGh61mOi6oZJzBwmQ3/T+RJ1y/NgQC97jJDaWAKct/B3+7kd3TGOuxrz7RYQMPqR3cU0H/VYZAjZ7tttIricCMjyoYl8nIDhxp3PdOagN7/2VUs1eMZvUL9AD7TECemPzYtasUPeYi9tke9O9BboNLGUEAABnePU9xqwAfdKOZHG+/QB6VcGqa1tFrZDvmZfjSgVKv3c7FUZirFLIAMPKVqsM2LFxN/OJKYG7MkR+BUgPS13uKpK3SgiAW7mUXzsrsuGwdifbb6Re8qZuaYG2TRazSTpUUn86tTn40O8jyrsAAFjhLMmHDsui1aGTy4DTou2NgDWgzWZP3rtUegi/ouGzpNFcJG1NeYGNixNseAfuWwBK6+IxpGcvqsdNMD5jgKHVzRWO/nTDMdOkWtEwT/cNStcqdYp6vUtBqrLSSAZRCYWWrFckPI5DUcGKeVO8EshPlDhKiEkEayKH9+tr0IFzM+2jNrlWfZQwsZgByZPOY/dJER3ZZf/Xad/Rm8JA7skj16G9JJW1YnVpNkmhG+m8GBxp26uXh5Kv77IBFdRTW5SuVdtiFHfTMxlI67CysO8bpkZKbVW6/mkf7ViJHu6D5dbgUiUuTBKXO5XDqu7jKcO5uJv79F47UZbyp3OMyQuKebA+5dK/vb
 ExZG7kIc
 0SoSH7emBksMbmTslPMsHiaJ2HFbQstavfsPfY0y2Tff1lBic8AuUWED6btsgbnayQhsR3eI6ITO6c/35nc8xdglo9kCP79WkKqSMpM2nmLcYHwoGXmqO8X+4sQPTEgiCxuw7ThKf0xsgmt9TwyALz/o01L/ehDdzTe5NytNq9xRCBzmHozJmJ+ZS4TQEesw39I0TowYSNzeBz2fV/LnN4H2t924lhT6ZyBmkXzYKv4cSBh0ItExf9KS0s+sL05DzUpFZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 11:52=E2=80=AFAM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> On Fri, Nov 14 2025, Pasha Tatashin wrote:
>
> > During boot, kho_restore_folio() relies on the memory map having been
> > successfully deserialized. If deserialization fails or no map is presen=
t,
> > attempting to restore the FDT folio is unsafe.
> >
> > Update kho_mem_deserialize() to return a boolean indicating success. Us=
e
> > this return value in kho_memory_init() to disable KHO if deserializatio=
n
> > fails. Also, the incoming FDT folio is never used, there is no reason t=
o
> > restore it.
> >
> > Additionally, use memcpy() to retrieve the memory map pointer from the =
FDT.
> > FDT properties are not guaranteed to be naturally aligned, and accessin=
g
> > a 64-bit value via a pointer that is only 32-bit aligned can cause faul=
ts.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 32 ++++++++++++++++++------------
> >  1 file changed, 19 insertions(+), 13 deletions(-)
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kex=
ec_handover.c
> > index a4b33ca79246..83aca3b4af15 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -450,20 +450,28 @@ static void __init deserialize_bitmap(unsigned in=
t order,
> >       }
> >  }
> >
> > -static void __init kho_mem_deserialize(const void *fdt)
> > +/* Return true if memory was deserizlied */
> > +static bool __init kho_mem_deserialize(const void *fdt)
> >  {
> >       struct khoser_mem_chunk *chunk;
> > -     const phys_addr_t *mem;
> > +     const void *mem_ptr;
> > +     u64 mem;
> >       int len;
> >
> > -     mem =3D fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
> > -
> > -     if (!mem || len !=3D sizeof(*mem)) {
> > +     mem_ptr =3D fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
> > +     if (!mem_ptr || len !=3D sizeof(u64)) {
> >               pr_err("failed to get preserved memory bitmaps\n");
> > -             return;
> > +             return false;
> >       }
> > +     /* FDT guarantees 32-bit alignment, have to use memcpy */
> > +     memcpy(&mem, mem_ptr, len);
>
> Perhaps get_unaligned(mem) would have been simpler?

Hm, it certainly more descriptive. I will see if I can use it.

>
> > +
> > +     chunk =3D mem ? phys_to_virt(mem) : NULL;
> > +
> > +     /* No preserved physical pages were passed, no deserialization */
> > +     if (!chunk)
> > +             return false;
>
> Should we disallow all kho_restore_{folio,pages}() calls too if this
> fails? Ideally those should never happen since kho_retrieve_subtree()
> will fail, so maybe as a debug aid?

Right, my thinking was that they should never happen, as they do not
have a way to know the location of folios to be restored. So,
preventing FDT access that we do does that.


>
> >
> > -     chunk =3D *mem ? phys_to_virt(*mem) : NULL;
> >       while (chunk) {
> >               unsigned int i;
> >
> > @@ -472,6 +480,8 @@ static void __init kho_mem_deserialize(const void *=
fdt)
> >                                          &chunk->bitmaps[i]);
> >               chunk =3D KHOSER_LOAD_PTR(chunk->hdr.next);
> >       }
> > +
> > +     return true;
> >  }
> >
> >  /*
> > @@ -1377,16 +1387,12 @@ static void __init kho_release_scratch(void)
> >
> >  void __init kho_memory_init(void)
> >  {
> > -     struct folio *folio;
> > -
> >       if (kho_in.scratch_phys) {
> >               kho_scratch =3D phys_to_virt(kho_in.scratch_phys);
> >               kho_release_scratch();
> >
> > -             kho_mem_deserialize(kho_get_fdt());
> > -             folio =3D kho_restore_folio(kho_in.fdt_phys);
> > -             if (!folio)
> > -                     pr_warn("failed to restore folio for KHO fdt\n");
> > +             if (!kho_mem_deserialize(kho_get_fdt()))
> > +                     kho_in.fdt_phys =3D 0;
>
> The folio restore does serve a purpose: it accounts for that folio in
> the system's total memory. See the call to adjust_managed_page_count()
> in kho_restore_page(). In practice, I don't think it makes much of a
> difference, but I don't see why not.
>
> >       } else {
> >               kho_reserve_scratch();
> >       }
>
> --
> Regards,
> Pratyush Yadav

