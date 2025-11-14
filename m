Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFEE0CE7B15
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 14:49:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16DFA8E0013; Fri, 14 Nov 2025 09:49:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E8F8E0002; Fri, 14 Nov 2025 09:49:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28BA8E0013; Fri, 14 Nov 2025 09:49:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB6E08E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:49:13 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE2CA12DFF9
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:49:13 +0000 (UTC)
X-FDA: 84109495386.13.3133677
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id A6CF91C0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:49:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cN+xrgnm;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763131751; a=rsa-sha256;
	cv=none;
	b=s+haoW5vjqqWD0pYmRueuNh2sEnFo/miz/BQJtmgkA8VTpXc8o5Udv4roq7c6Dh/V4tgxf
	KV/MamukTZECHHDdx2AxsbhkyiTPBueOVuxHvEO1qJ33wLEITTqpMPHM+Rz5Xoe1SNEh4h
	LtxBCj0Gb7ntH9fypf670Er45rA/010=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cN+xrgnm;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763131751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYEAXpQ4a552Nj/Tapn49whjWroq5jBGQBSgz6ETKNI=;
	b=pMwXJI7ckfkT4Jnf16CXQOHZ62QRsIz21BDi9HN0Jda4jX4ZAv3jucRp6pk+NBKTMztGOK
	yq8+ugImT0qqtVF8BtSphMS07EI1lDbf+OTXkDa5fFwE+tJnnPqKkxJDPjRssABvTHxgKI
	B6FOsRt9m8sci/t1vG6fHZKJ9Nrj2S4=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-640c6577120so3661574a12.1
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763131750; x=1763736550; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QYEAXpQ4a552Nj/Tapn49whjWroq5jBGQBSgz6ETKNI=;
        b=cN+xrgnmgBDQm1kVLKQTe2sFTn3CDnuyfMslH4F3Dqj+4Mufx2l8pGDkopgXnAq8IF
         il7Ryd+idVyOc6aPKUvXWegtQLqg3VUfa+7uq6bbd6mjC+XC/YzlUZqmRJwSkxmBwuok
         qEKCuqA8P+cJY4k0RwemZeRoq++Zs2lx/kCglDYoR89r+5AYs+vtt/1EbaYex2HqgvAv
         kOUJz6EggQwD5bDTIlDkwNrlZs8KZPokgcxwx2LTb6qwdg/0Y8kgCT36rRvjMSgwM2mm
         BnRMmtFv13dDgI3Q4vG6YzsaTx1H6ErQLBfiDF9/FQIbqkGgUpk/MNkZtXTtZhWLGu0F
         J+kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763131750; x=1763736550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QYEAXpQ4a552Nj/Tapn49whjWroq5jBGQBSgz6ETKNI=;
        b=sgD0AoCMKPiQzAKF9A8wtOYY5cQtTSIVFWWhRi9pefnGC32P2PTW1lkVFhocWLDmLF
         qf7XlKhhvFpMO1fQH09yX7HF6rAguI48b9fhZ2UYj8UfS6ZPl9PZ3b7UQWDbSuoXSLuK
         7a4tbB8/OvBMd7WCPm57Lb7CNTG3rfgoccnpYpOCW3VvnYOSV/8aPjmvqJ/Do0UJGoB6
         63SSShJ1YoVgApgjKCVGnLGUaZnoJcQJFc8g09CDZFO/kYLxxfft4qkCP/cXAA4ksnbz
         SZv1f1/RIcZcM/NrpKpuNr/1/ANDBSpLMdkWqDK87HAjD8TNEg92gjaVnD97LlMkxV9m
         7LcQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6IvJTKbuxf/MFl0QR5ysvV94p/SaHprd6epX2mDe86YA3CaJtUCyscu34oQNFzwq0aSD0glVJ1w==@kvack.org
X-Gm-Message-State: AOJu0YxhHE/iokN5iqEUkJeCGyXLp0idvZf+uVp9mgIV+jfKG0oixzRs
	x+FG7/w8F/t5OwVPbT8274yBn7hIxfrpF6ewL8SwW1hDyYJuGdxQDInQdSQ2HQyAAtySZ01lI9M
	ciW0n3v25lREcJzQ/t3fIvNzkrWad/diT2zzgnf3gug==
X-Gm-Gg: ASbGncvfvYO6wafippsLr3D3cfyPKiPFj6eQ7XjzyToz5Yws28EJ4v99F//TyFRJkrv
	TT39VZiicZGBn0mL2ArucGeNpxc3RdWtJ3FczYSmBLfCpRg9EpG1dRm1rJkYDQ16BDvpKJylynh
	n5HNYBSiFQzeQOknQ4gkozgljRwKdxmJOVEwJEvXc3I0xFklm7nEtOrVHM5dGfUhbLs45cNmE+4
	Rkr6o+valKZa5pgl+HB3ef+utgbE5oM/NC6fwu/gKzj8mvcqWR6BdRS0pGhjglB3oB7
X-Google-Smtp-Source: AGHT+IHF8MqvIeu6twye/eYx/FuUCbRP62c2HbXTtkjoVGfiBHyEq0ZpwisfIJrVT6Hu103fGvqOuZ0WbhmUHmm+4tw=
X-Received: by 2002:a05:6402:5341:20b0:640:ccb0:f4da with SMTP id
 4fb4d7f45d1cf-64350e9ff6dmr2279684a12.29.1763131749850; Fri, 14 Nov 2025
 06:49:09 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-3-pasha.tatashin@soleen.com> <aRcSpbwBabFjeYe3@kernel.org>
In-Reply-To: <aRcSpbwBabFjeYe3@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 09:48:33 -0500
X-Gm-Features: AWmQ_bm03KKG3xgTX39tlkUT5awfMY0ljNHpMhWuof0QVJ12PZgKUmkaxYYGwgY
Message-ID: <CA+CK2bDzExcm-1LMFFQ4FgyfX5yuaPBd2fXdbNsd2yTbrSNKog@mail.gmail.com>
Subject: Re: [PATCH v5 02/22] liveupdate: luo_core: integrate with KHO
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A6CF91C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: 6q493iqa5wt75pqiboiruhqf4ser5yq4
X-Rspam-User: 
X-HE-Tag: 1763131751-291366
X-HE-Meta: U2FsdGVkX1/SzKxa1kRJ0zMbQezcRtshKcSNhlOoe7h+8QDvSYu0zTvdF919S5vphM8fnM/1g6Z/PNHdPCb9fNeGrgLEbR0FagWIvCXcCxGi9fpmnOPaZfmgysPpmDDEDgRLHzEXc1XEG32CaYNQbfxaTPnJLimAtqen7lDgaQVect0ZhPRhvT25z29Prp7LMJ898GCoRis0aOwNT5GaRQR3rKyl239ny1etpqNXmsC/uzHZ5lMtij8Xvui/OJzkQveGA6bwNhpSuQy3sxEckeqzNK5OYpvZfeV5urDyl1HWdBOWrCYyhltE2mcb6JCLR+2hmH4ZBIz1sYX/a60Lhva6NHimDZRiBoOsoIuGtyxpj7cznbyJZGJMzza3e/08tN06hntWOo1TeD7mz6V0ccl+uDn8KhGyJYYv4rAbNdOkgxTme3ss+3leOmcE082vE0sHYIpUwvOKaKjp11ocsXlAIC4uqUsNHUX3wcZhUa6ZYHjIFUjXbQGZoA18fZbztBG4BT6D0zI50+Ho0kE+iMyrHRQeResKplJ3R2FjELvrNI/SIZlTVO71cM9BegPUSEaTNnrZ5mKwgMlf5bKMnabrMWOHc1ju5mW9TpftlkVP4zvcTYZlXmwOna+1I4y9vMPRWIf35zrjgW/X+lnMEtm/HuVpwRBZsjpDv21Ei0w9l9140uudEr4qfiowdOblLKaBYtN/uI+LkOSf5vvSSNHGR0VBsJIa8BT0Ick6kVdsxWrXuBZE74L3g+sqc2r2ECf97wXJIq4bhp4IKID/jDZaCRsoa3k1eOvfk4LmncHXAJwMJ6jsVzJ7OmoaGHDQZVLDDznQVav0B5hTp7VowdCOzVs/jAdHgiaMRkQbkOL8DNR7bUTho+WL0T2j69oLrysz72zt8OLqAMd5S0U+S8IKzmKB+uRksyxV+yJxJDI7pcgxiEdmVXLFvR4aiuPPp3pTxOo6aESNHCaq3d8
 B4FdM1bl
 dUbRg3VhDbwzB75h5wO/DJFN6h7pg555IDHzonSSd6So9iZ8HF71o2uTfWcx64g0lGbxVE+Nm4BbeRn98Lmly1w942kLF85NVHo6N0PEl8DavCxaIg0btJEdpeNJvdYhCvBN1xVlA3va2h1c/Pf+esTsjVf6f2OWL75a5kW2oz4GL5gHvd1EFc4PsstOcU6tgcZRyiIGJroA7Gth/V31ytNdTJR2Z7sTjAQNPVyir28jvolpqMgeb8dg+k1YrgLMGs8/9KT9RPwE56YxJ3SuDjO+LJOrjv0ibKFUWphgdszSLeIVybqCSvJkVhnJVCdwKhUmuBfD/N1wu4oZKI1S3ij+TJjXQUgMFJ5lCKoE8nXt8AebJ23K28T54cSRm1I8uMPYcIvz+TJiolro=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 6:30=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Fri, Nov 07, 2025 at 04:03:00PM -0500, Pasha Tatashin wrote:
> > Integrate the LUO with the KHO framework to enable passing LUO state
> > across a kexec reboot.
> >
> > When LUO is transitioned to a "prepared" state, it tells KHO to
> > finalize, so all memory segments that were added to KHO preservation
> > list are getting preserved. After "Prepared" state no new segments
> > can be preserved. If LUO is canceled, it also tells KHO to cancel the
> > serialization, and therefore, later LUO can go back into the prepared
> > state.
> >
> > This patch introduces the following changes:
> > - During the KHO finalization phase allocate FDT blob.
> > - Populate this FDT with a LUO compatibility string ("luo-v1").
> >
> > LUO now depends on `CONFIG_KEXEC_HANDOVER`. The core state transition
> > logic (`luo_do_*_calls`) remains unimplemented in this patch.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/linux/liveupdate.h         |   6 +
> >  include/linux/liveupdate/abi/luo.h |  54 +++++++
> >  kernel/liveupdate/luo_core.c       | 243 ++++++++++++++++++++++++++++-
> >  kernel/liveupdate/luo_internal.h   |  17 ++
> >  mm/mm_init.c                       |   4 +
> >  5 files changed, 323 insertions(+), 1 deletion(-)
> >  create mode 100644 include/linux/liveupdate/abi/luo.h
> >  create mode 100644 kernel/liveupdate/luo_internal.h
> >
> > diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> > index 730b76625fec..0be8804fc42a 100644
> > --- a/include/linux/liveupdate.h
> > +++ b/include/linux/liveupdate.h
> > @@ -13,6 +13,8 @@
> >
> >  #ifdef CONFIG_LIVEUPDATE
> >
> > +void __init liveupdate_init(void);
> > +
> >  /* Return true if live update orchestrator is enabled */
> >  bool liveupdate_enabled(void);
> >
> > @@ -21,6 +23,10 @@ int liveupdate_reboot(void);
> >
> >  #else /* CONFIG_LIVEUPDATE */
> >
> > +static inline void liveupdate_init(void)
> > +{
> > +}
>
> The common practice is to place brackets at the same line with function
> declaration.

Sure.

>
> ...
>
> > +static int __init luo_early_startup(void)
> > +{
> > +     phys_addr_t fdt_phys;
> > +     int err, ln_size;
> > +     const void *ptr;
> > +
> > +     if (!kho_is_enabled()) {
> > +             if (liveupdate_enabled())
> > +                     pr_warn("Disabling liveupdate because KHO is disa=
bled\n");
> > +             luo_global.enabled =3D false;
> > +             return 0;
> > +     }
> > +
> > +     /* Retrieve LUO subtree, and verify its format. */
> > +     err =3D kho_retrieve_subtree(LUO_FDT_KHO_ENTRY_NAME, &fdt_phys);
> > +     if (err) {
> > +             if (err !=3D -ENOENT) {
> > +                     pr_err("failed to retrieve FDT '%s' from KHO: %pe=
\n",
> > +                            LUO_FDT_KHO_ENTRY_NAME, ERR_PTR(err));
> > +                     return err;
> > +             }
> > +
> > +             return 0;
> > +     }
> > +
> > +     luo_global.fdt_in =3D __va(fdt_phys);
>
> phys_to_virt is clearer, isn't it?

Sure

>
> > +     err =3D fdt_node_check_compatible(luo_global.fdt_in, 0,
> > +                                     LUO_FDT_COMPATIBLE);
>
> ...
>
> > +void __init liveupdate_init(void)
> > +{
> > +     int err;
> > +
> > +     err =3D luo_early_startup();
> > +     if (err) {
> > +             pr_err("The incoming tree failed to initialize properly [=
%pe], disabling live update\n",
> > +                    ERR_PTR(err));
> > +             luo_global.enabled =3D false;
> > +     }
> > +}
> > +
> > +/* Called during boot to create LUO fdt tree */
>
>                          ^ create outgoing

OK

>
> > +static int __init luo_late_startup(void)
> > +{
> > +     int err;
> > +
> > +     if (!liveupdate_enabled())
> > +             return 0;
> > +
> > +     err =3D luo_fdt_setup();
> > +     if (err)
> > +             luo_global.enabled =3D false;
> > +
> > +     return err;
> > +}
> > +late_initcall(luo_late_startup);
>
> It would be nice to have a comment explaining why late_initcall() is fine
> and why there's no need to initialize the outgoing fdt earlier.

I will add a comment; basically it is fine because the outgoing data
structures are only used after we enter userspace.

>
> > +/**
> > + * luo_alloc_preserve - Allocate, zero, and preserve memory.
>
> I think this and the "free" counterparts would be useful for any KHO user=
s,
> even those that don't need LUO.

I will move them to KHO.

>
> > + * @size: The number of bytes to allocate.
> > + *
> > + * Allocates a physically contiguous block of zeroed pages that is lar=
ge
> > + * enough to hold @size bytes. The allocated memory is then registered=
 with
> > + * KHO for preservation across a kexec.
> > + *
> > + * Note: The actual allocated size will be rounded up to the nearest
> > + * power-of-two page boundary.
> > + *
> > + * @return A virtual pointer to the allocated and preserved memory on =
success,
> > + * or an ERR_PTR() encoded error on failure.
> > + */
> > +void *luo_alloc_preserve(size_t size)
> > +{
> > +     struct folio *folio;
> > +     int order, ret;
> > +
> > +     if (!size)
> > +             return ERR_PTR(-EINVAL);
> > +
> > +     order =3D get_order(size);
> > +     if (order > MAX_PAGE_ORDER)
> > +             return ERR_PTR(-E2BIG);
>
> High order allocations would likely fail or at least cause a heavy reclai=
m.
> For now it seems that we won't be needing really large contiguous chunks =
so
> maybe limiting this to PAGE_ALLOC_COSTLY_ORDER?

Let's use MAX_PAGE_ORDER for now, my concern is that
PAGE_ALLOC_COSTLY_ORDER too fragile to make it part of ABI. If
allocation fails, the user will have to deal with it, as we return a
proper error code.

> Later if we'd need higher order allocations we can try to allocate with
> __GFP_NORETRY or __GFP_RETRY_MAYFAIL with a fallback to vmalloc.
>
> > +
> > +     folio =3D folio_alloc(GFP_KERNEL | __GFP_ZERO, order);
> > +     if (!folio)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     ret =3D kho_preserve_folio(folio);
> > +     if (ret) {
> > +             folio_put(folio);
> > +             return ERR_PTR(ret);
> > +     }
> > +
> > +     return folio_address(folio);
> > +}
> > +
>
> --
> Sincerely yours,
> Mike.

