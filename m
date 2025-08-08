Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E88CA0EC0
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 06:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D224F8E0002; Fri,  8 Aug 2025 02:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD30F8E0001; Fri,  8 Aug 2025 02:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC1A08E0002; Fri,  8 Aug 2025 02:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABB838E0001
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 02:44:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 278AD5F79C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 06:44:52 +0000 (UTC)
X-FDA: 83752652424.09.E45F641
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3403CC0008
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 06:44:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DvpceEla;
	spf=pass (imf22.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754635490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/bygktD0fqAfBcULD1cv//efBpJOrdPBFdY6zXSYR1E=;
	b=iTSA45lZm7y0rytJyxIKfk8DPjjsvQVisHRlolhZEHDCpQ4uVbKuM5kzElERQH5yVfrPWw
	x9pUMnSsHXsjKZk66UN6Ss1y1qx8iDI3Rr0bRdYAN34oK5Umf0XMzJIstAtnkA/zHl4iwy
	x+ymKyb1Tushzm5YC2pstPX8rmjls+o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DvpceEla;
	spf=pass (imf22.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754635490; a=rsa-sha256;
	cv=none;
	b=Og7elKWS0hcJkFn+/pgHrO/iDiOQEnR6J9n/FxYuuZMf+grKqwTyloHB+NwavpKkydiRxb
	7WW1by1kbivgKYfBxDiwVXERmSFlC5NRZBDR6Eo/EMoDZULP72E+MiAzK0TanJHAnNTXOo
	nGesCoHRSIAhzpvCvE2GlG4OFT7tvGQ=
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-32f1df5b089so16471541fa.3
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 23:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754635488; x=1755240288; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/bygktD0fqAfBcULD1cv//efBpJOrdPBFdY6zXSYR1E=;
        b=DvpceElap/82Ovj7bgoOOaP5E0i0kqrGvzBt6XGZ2sa7BvCYOvy5uPemmr/06+2NJh
         ph3TUkPk9uU4GWIOH7ZyT1Fj6U/3vsBal0bPu0aMwQ3GgFBltdNKrqL7C7tKFsDANkSE
         jjct8lyT2096cXzDhE0QIV/zQLEgMtU/gJwqVw4VfpDnd9EmzmtoQ4eOwX7mEvBkTL2M
         mYCNlZht55Pd5QOIpwNeGAqUlnZbBcsK6N7hFG1MvjmcOKXGirHgWhDZHyp8KNN48oef
         3QiYu7A5ksBtmXKQjaeW/Mqk/FqPy+O+yWCtsBwh7SXr5r2gcKFC2PzZVMZW8hQ2z3ID
         FfNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754635488; x=1755240288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/bygktD0fqAfBcULD1cv//efBpJOrdPBFdY6zXSYR1E=;
        b=SjqWcLK7fnP5SMqgWn4k76SxBSd6nedAl1DllY8jSPrMEKM5Rj8Ci0H60VaMT9CxFv
         3s2UjsSmlR2zNrUhQv9vRv17mftvkUo2oFpoXbCN9XbLhDWdFKTsdQUMwNIRA+3d2ZHK
         FfAPnd0G20cm6Sze+D/D/hxA0Qtf0yU7CZXPhVSwlcqNccAlOy1Eu0nnOJRvHgx5C5lm
         p0XB3WespmwXTDu6NBUjfw6Lzh0hXyVf83/5aik8bxfr+F0p2n2wmp1uBdlVMZfZXc30
         x0PNZ0aJ7XbNG3ax1qRLpx85gG5nkfrbqwFYOeDCNqL/1bv3IgryYZyfiSF0A51vQJIM
         xuLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkj4O+ep6O/8SdDdU4GY6QutpZU4/Il9a53XEmnpdoGR0Yoiumip7sGD+Sli2USwrNKNG8E6OTTw==@kvack.org
X-Gm-Message-State: AOJu0YxDyM0EyqWQwG1NpiHok//bFc7GslQo4tlmCgL3pxgVqYOpVZr0
	eA5PbG5sLAp2v7cUZhPgOx3erwsamQ1l+IOPIToCtwCQsnsI8Gw1nGIk5qITqYTIuzcUyLWPFSH
	XIPvNqoUSostOCV0wYe6UD3C7mCRQdD8=
X-Gm-Gg: ASbGncuudR0UjTKhF19mOVOqe7IXuuPiPZor+s3HykputFClw35u6rwvO0jXSTLpiZK
	7FoPGB4wV3+pRMp2W9ASdlYV0o9mOJnNTP2KvRwlfv/EXzGuagDAHMNt+Kj8u0tLcp0x4CCpy+A
	rEGp9ifm65zpduN0CYjUsNmusf4v0Y0itmdEgKwUbhuuavN4Cco7XxHDmzYZQQ1m18F9JxXKfFD
	sUZ1YA3ZWEUCQ==
X-Google-Smtp-Source: AGHT+IFs71M36/AELdEQHAnmGYL1flS4Z16XX46ZSXB/yJtln5z+7ajdXBk68gahFV3tPaDyZV4i3858ZjCNgBJDsz4=
X-Received: by 2002:a05:651c:4010:b0:332:2df3:f8ac with SMTP id
 38308e7fff4ca-333a222c31amr3330341fa.32.1754635487960; Thu, 07 Aug 2025
 23:44:47 -0700 (PDT)
MIME-Version: 1.0
References: <20250807194012.631367-1-snovitoll@gmail.com> <20250807194012.631367-3-snovitoll@gmail.com>
 <07ffb27c-3416-43c9-a50a-164a76e5ab60@csgroup.eu>
In-Reply-To: <07ffb27c-3416-43c9-a50a-164a76e5ab60@csgroup.eu>
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Date: Fri, 8 Aug 2025 11:44:30 +0500
X-Gm-Features: Ac12FXy3j3jcHWv5quQse7L5XRgGZZuU0Dnwj-G3jWlUZ0ijDblLaDUsIz_V-Q8
Message-ID: <CACzwLxhahYWfRc5xKshayniV6SuFFnMT0NfHttippcASzZgtRw@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] kasan: call kasan_init_generic in kasan_init
To: Christophe Leroy <christophe.leroy@csgroup.eu>, alex@ghiti.fr
Cc: ryabinin.a.a@gmail.com, bhe@redhat.com, hca@linux.ibm.com, 
	andreyknvl@gmail.com, akpm@linux-foundation.org, zhangqing@loongson.cn, 
	chenhuacai@loongson.cn, davidgow@google.co, glider@google.com, 
	dvyukov@google.com, agordeev@linux.ibm.com, vincenzo.frascino@arm.com, 
	elver@google.com, kasan-dev@googlegroups.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-mm@kvack.org, 
	Alexandre Ghiti <alexghiti@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: b9cqp5sfthx68pb78bpwtskue61gtsg5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3403CC0008
X-Rspam-User: 
X-HE-Tag: 1754635489-85879
X-HE-Meta: U2FsdGVkX1+KoqYeRMsBf9q7fpM0Z1ofDLFdGRSgvIWCabBKHLpI0CLONOtaAkvBP3Sw60spCadKa12c1Bf006rk81qaIJ4FeWhUbOpxNFjz50gVf1yE019qC/oAw58N2Tr+vDWg/ihNLI+swFPKmkpWH8DyddHqnS42SIBaTffzyAyxVsDLMMWHjAtBKfOLZRARgPqZ9QJz/qOp2QjqNwOj0aff2wEloRjhy0hYkfwwVQS4j9FwT1avPkoWLjzu+uDB9ohPdLH6NxQG8xsdvJlJL0WhBlS5q+wFFgotm1AsxfRtsKuH3jU6VZToq8N5at4xozn69n/caqjp4Qhj7ZlJO+wcN1VsIn7S9BtRfBGVzKxVeSYMtpdNPiXa9g88NVEZYH0XXrgd7PvB4SrNhKDKQxJ5JI4WJ8utJxTnaxadqTt2yNOzhXkZZFcGdeAhSPK8lJtb6ndjvSEyZPuLK2j+TRR7opgyrCqo2KefFF61TeymMNvU1roNc3JGL9VwcSo1atZl5Su0Cg7w2AmvNICiuKqn2Ag0ysjnIWyPmc1p25WVoBzidIxn173jUUE76HAt4TfRJOhk393L0p2yBGQH46D724K/Nj/F4pckyl4FWKC/bAKv66xp5CkbhLbJmvBWk4Q9lZziR+sCJXqXzpvw7dfmulIwTjJqX2b0eNqsGDsVt57N96MSV/XPd3IzU18anW3AzD9ppHfzVIC00nbIlu8T6YWzN0dVt6VSw903dA9ecHO/AHTNmA/Y3Bpx/dKILLiuwxXeNR9VR1c5Ezr7lIAYHHZoWH/jKf2uHA7PzAvR6dFzaT3JsNbZ3MvzgGZ3HZ+bAj/FZOp9DsoXG7WNPyR4f9xj41wrcZfWwiL4iY/0ap64rgLOiKQabPpDFG1SR26fNqA1jeCWh+HcpzGkdHBZ2G+5ddRjA8NhM5jdrAbzTTIvIqFeQSRlAV7Jh91Jtbwhgc+0QRuqsvR
 8fjlWrmr
 BQZ8DmdgsDNTr/S5eWNo3lq5yVRiVK/H6qbF6g8uv/irqzLRm+PsELZqBe8j86gO0sXOTfNcHjtb4JuuTqhB6eJE2Xsy/0qiYUkz190AVXI51Im1YapevNXZpMSgitrYA7qmoyKLFiXmioUqxA0sAtUDOrUeEeqhsg2Errpl2oJoah1HKd4mhKiD3PRGXb2gor31Lq6XYouP86BLdFfNAGzeL4ncsA1zT+1N6CLBS5uSfpnHG7KjOQeB/0BjST5V8saPtRWqk///8tODjfdovqYPy04XUwKF0+nIlWJG6fBU5Nk+OY4mNFNb5cbl1mD0pA13sMjykIfaeblktEOuzlqDfjgR4C6Vi3Vt14w3CiW+ED1N7AqjIaqinKvjZBEMzwoO091c7TGHB2X0lB/2JGlsV8YW/0ap77uKi1Aw4T16NL39NUyXKt54e+cKCcb7CJwbqKZbLi9KZfI5qSBgik7GfiRVGlstnk2xqGl42ABaSaofABM8Wx4jWZ6hnIfdByBjg8+4tVYBqBPB3KpZijFFW+sCcR7mq9WUu6GJccSQ1GKanihxzV8s7ys5oJU+Y+Gb13WD6b4vhCZM4JefhLftIsf7VCDJdEQZR9/7rv/T9T/l5oXHubR0V7fa5MaGtAI2IW5s+ty7zdLUKjmiCuSrkt+yk4RUsKP5V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 8, 2025 at 10:07=E2=80=AFAM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
>
>
>
> Le 07/08/2025 =C3=A0 21:40, Sabyrzhan Tasbolatov a =C3=A9crit :
> > Call kasan_init_generic() which handles Generic KASAN initialization.
> > For architectures that do not select ARCH_DEFER_KASAN,
> > this will be a no-op for the runtime flag but will
> > print the initialization banner.
> >
> > For SW_TAGS and HW_TAGS modes, their respective init functions will
> > handle the flag enabling, if they are enabled/implemented.
> >
> > Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D217049
> > Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> > Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv
> > Acked-by: Alexander Gordeev <agordeev@linux.ibm.com> # s390
> > ---
> > Changes in v5:
> > - Unified arch patches into a single one, where we just call
> >       kasan_init_generic()
> > - Added Tested-by tag for riscv (tested the same change in v4)
> > - Added Acked-by tag for s390 (tested the same change in v4)
> > ---
> >   arch/arm/mm/kasan_init.c    | 2 +-
> >   arch/arm64/mm/kasan_init.c  | 4 +---
> >   arch/riscv/mm/kasan_init.c  | 1 +
> >   arch/s390/kernel/early.c    | 3 ++-
> >   arch/x86/mm/kasan_init_64.c | 2 +-
> >   arch/xtensa/mm/kasan_init.c | 2 +-
> >   6 files changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm/mm/kasan_init.c b/arch/arm/mm/kasan_init.c
> > index 111d4f70313..c6625e808bf 100644
> > --- a/arch/arm/mm/kasan_init.c
> > +++ b/arch/arm/mm/kasan_init.c
> > @@ -300,6 +300,6 @@ void __init kasan_init(void)
> >       local_flush_tlb_all();
> >
> >       memset(kasan_early_shadow_page, 0, PAGE_SIZE);
> > -     pr_info("Kernel address sanitizer initialized\n");
> >       init_task.kasan_depth =3D 0;
> > +     kasan_init_generic();
> >   }
> > diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
> > index d541ce45dae..abeb81bf6eb 100644
> > --- a/arch/arm64/mm/kasan_init.c
> > +++ b/arch/arm64/mm/kasan_init.c
> > @@ -399,14 +399,12 @@ void __init kasan_init(void)
> >   {
> >       kasan_init_shadow();
> >       kasan_init_depth();
> > -#if defined(CONFIG_KASAN_GENERIC)
> > +     kasan_init_generic();
> >       /*
> >        * Generic KASAN is now fully initialized.
> >        * Software and Hardware Tag-Based modes still require
> >        * kasan_init_sw_tags() and kasan_init_hw_tags() correspondingly.
> >        */
> > -     pr_info("KernelAddressSanitizer initialized (generic)\n");
> > -#endif
> >   }
> >
> >   #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
> > diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
> > index 41c635d6aca..ba2709b1eec 100644
> > --- a/arch/riscv/mm/kasan_init.c
> > +++ b/arch/riscv/mm/kasan_init.c
> > @@ -530,6 +530,7 @@ void __init kasan_init(void)
> >
> >       memset(kasan_early_shadow_page, KASAN_SHADOW_INIT, PAGE_SIZE);
> >       init_task.kasan_depth =3D 0;
> > +     kasan_init_generic();
>
> I understood KASAN is really ready to function only once the csr_write()
> and local_flush_tlb_all() below are done. Shouldn't kasan_init_generic()
> be called after it ?

I will try to test this in v6:

        csr_write(CSR_SATP, PFN_DOWN(__pa(swapper_pg_dir)) | satp_mode);
        local_flush_tlb_all();
        kasan_init_generic();

Alexandre Ghiti said [1] it was not a problem, but I will check.

[1] https://lore.kernel.org/all/20c1e656-512e-4424-9d4e-176af18bb7d6@ghiti.=
fr/

>
> >
> >       csr_write(CSR_SATP, PFN_DOWN(__pa(swapper_pg_dir)) | satp_mode);
> >       local_flush_tlb_all();
> > diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
> > index 9adfbdd377d..544e5403dd9 100644
> > --- a/arch/s390/kernel/early.c
> > +++ b/arch/s390/kernel/early.c
> > @@ -21,6 +21,7 @@
> >   #include <linux/kernel.h>
> >   #include <asm/asm-extable.h>
> >   #include <linux/memblock.h>
> > +#include <linux/kasan.h>
> >   #include <asm/access-regs.h>
> >   #include <asm/asm-offsets.h>
> >   #include <asm/machine.h>
> > @@ -65,7 +66,7 @@ static void __init kasan_early_init(void)
> >   {
> >   #ifdef CONFIG_KASAN
> >       init_task.kasan_depth =3D 0;
> > -     pr_info("KernelAddressSanitizer initialized\n");
> > +     kasan_init_generic();
> >   #endif
> >   }
> >
> > diff --git a/arch/x86/mm/kasan_init_64.c b/arch/x86/mm/kasan_init_64.c
> > index 0539efd0d21..998b6010d6d 100644
> > --- a/arch/x86/mm/kasan_init_64.c
> > +++ b/arch/x86/mm/kasan_init_64.c
> > @@ -451,5 +451,5 @@ void __init kasan_init(void)
> >       __flush_tlb_all();
> >
> >       init_task.kasan_depth =3D 0;
> > -     pr_info("KernelAddressSanitizer initialized\n");
> > +     kasan_init_generic();
> >   }
> > diff --git a/arch/xtensa/mm/kasan_init.c b/arch/xtensa/mm/kasan_init.c
> > index f39c4d83173..0524b9ed5e6 100644
> > --- a/arch/xtensa/mm/kasan_init.c
> > +++ b/arch/xtensa/mm/kasan_init.c
> > @@ -94,5 +94,5 @@ void __init kasan_init(void)
> >
> >       /* At this point kasan is fully initialized. Enable error message=
s. */
> >       current->kasan_depth =3D 0;
> > -     pr_info("KernelAddressSanitizer initialized\n");
> > +     kasan_init_generic();
> >   }
>

