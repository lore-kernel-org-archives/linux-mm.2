Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56BB0C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 03:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C491F6B00A6; Tue, 30 Jun 2026 23:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFA0F6B00A8; Tue, 30 Jun 2026 23:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC45F6B00A9; Tue, 30 Jun 2026 23:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CBD86B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:11:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE2688C398
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:11:17 +0000 (UTC)
X-FDA: 84938731794.19.C920173
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id C94CDA0008
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:11:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Nx4nvyyC;
	spf=pass (imf15.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782875475;
	b=J1XHFH1UQD6YbYKzhD2sHrH0z89HnL65mKOCB+jtk0fY5p6RX81BdylY4xZSTQosKFivy5
	3xgVbivSn90WX0fJ6FOoAMfHopLcR1vDyqKTyAfKmIZtw+RC7T8Yf5AKfy8iK6nA20xiLW
	nudCW7PEf1BFXXFiYM/IFZezep171cE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782875475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AW+XVWe2JL0df9uuAdxaZgi837urm1REze6zO62j7wg=;
	b=A6puQ0NuOG0x54O5q3GAFiPxmmlcPTzZJqU6AjQlkqjWiEBDwJqYIq57Tw941dF/lfDoIs
	ZljNGPasVVswngUgIEQDLDYv25I/VNP88tRSCgfQgD1mSSLYidbCTdsZVjPZn4g53+YuyB
	c+iQZezyOIRrAzTbNxci01vlCZTTYXI=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Nx4nvyyC;
	spf=pass (imf15.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7eb29ed2bbdso28429a34.2
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 20:11:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782875473; cv=none;
        d=google.com; s=arc-20260327;
        b=FKDans2nj0SP+eV25fLD8NJoIwh9j9pXQ1FPPGsr57+vMPq4cZjNXqkkDx2To+nGeE
         o85dE0B37BvOxvAbKabxDuMWbf+wL6O2Ylv45bB4WNEABoqT/TSV2hnZh/qo+Qbf0U7r
         Zyk0eC9tMTAU121rvKVS6BXONf2nFx7Zsr055LeFWjGqi2pm/75zTTfPAw7wxzkvb2Yr
         4dv9mJQ0/m2SeVVc1Y0u+v6VHzdmYHSZe2z7P1dQyjQKT/wCmcPnC0UTQeCC2sg2NiSn
         llIIrTiKYvWtTrG25Vw7iy5ON5EReIYyM0l4fhWwM5kWbM+W2TMzCdllJrvtftzMmR+A
         iOBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AW+XVWe2JL0df9uuAdxaZgi837urm1REze6zO62j7wg=;
        fh=gFHE4S10I/QRJ0BUvPtN+9xkrMcdOhjPhw9KZu7fZ4w=;
        b=TMFdORXWo4NsVdT5lLJ5+wPTB7iro10rLdZONfdsEkSCT8V/rfBJ4p/TBjye73EuBX
         ivS+/wkFZJ8+ZD7CMIikIDHk9FQ1s0q6/Xn0YoVry5YEXJVZ0jmyjaEFEWha2H/xJMrf
         vwZJ4RtF5/XBEEFa8SaB0/GateVLxA4nu8FQLBYJUJgdcLY0etPCJ1BTLKoH/mGyZhFn
         BPd2zshD5pnrszj6Tgt19VoN2hw2ZvEta07+W8ryVRV71uYwelN1Ina6CWJtv1NwMyzr
         z1oxJIsgrgptvyqlxOlFE/i7BvWiA5YZLJUvnZ8IQPlxmp2aAgTuOcLrTuYDzGqk6LVN
         j0gQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1782875473; x=1783480273; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AW+XVWe2JL0df9uuAdxaZgi837urm1REze6zO62j7wg=;
        b=Nx4nvyyCOT9cfGDhbJfsBsoRJPu7Gvns3Az1hWuCekqgFiCPr+JKOlrlyg3U0ksymK
         E8PfDh6nwKCaJK2bSu8f3UaIByG1aYSO7VqvUUY/GNL6BUxjjcRkxRDWyV0u1qlCGA+F
         ZJuET6iw1o7m6ZoCjsVpjCC5+3cl/oBCoP2N9XrdSnB4DGOJw9LF9cwm5gpxBXxm8cQQ
         ZhMcDtFRrImeP1D4bVjtO6+VWZLuD/v+4AU+cdASNi338ZbiGUmpPbDvU5zucJBLsaZq
         dEUqL7tV1Hv3DgW+7dPlhbws1JEskDKpqrkrmpifaqo+VQvp+Wah2zEhJG1K+4j6+CsT
         NtmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782875473; x=1783480273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AW+XVWe2JL0df9uuAdxaZgi837urm1REze6zO62j7wg=;
        b=lxGbpih5N1C9vhZiWwcLoTR5eSTXqkW0pNuLrKBVkfS+Ub1dOrEBlp9XtRt1xwa2+R
         aSV/R81A9Ac8NMGF4mVDAtdHknNtJXxsAZyTzdNd1iSlqoJjfDwkU7cks1bVW657cO8k
         EeEdf47IINlk2ycE7CxqKdswE+T8ry5fDA8TTuCYb3YldjMrcR8pvD89MXc3bvrQsPY/
         i8MZFOUEw5s3U4qI0TDtYwMe52qO8BsaZ4y5s6p8PmLBRYo0LQBy08OtFUrlJouu7t0R
         71gDfSGcJEnyuXmRpsMX5AXy5mPepGNZgrU+sx1xINIZjzaW5ka6YMbVtsgEGVQ+fPxJ
         iPWA==
X-Forwarded-Encrypted: i=1; AFNElJ/9+FDkdYfI0ATgU6ZwVP80V4yc92VIWWHEPrdt2PbLaVTQwyseymWM2al6C4ftosr3c7KYf+2lCg==@kvack.org
X-Gm-Message-State: AOJu0Yy/k1QVqEcMhsd6cSUBNLwF5QnWeHS+GROCcouFxnmUPLFPlrFD
	HgUUZhJz53iBU14O32cR/+WjeRBV/WCoE4x9UYb8rlhBAZd8lfe0Oj+LnVFIr0uMej7edqjr/4P
	J5k3FwMONNlGLQOxgVp2WDs/yhHAgG0Fze4ZTFkx0Jw==
X-Gm-Gg: AfdE7ckhopXUF0HIA8F5y3qEyvFx2i9am40DvVe81l0w6nCqah+UBa0aJqpzLwdJ8Gk
	XOvyFQhPdbKqRGCrI+MFnQFTvpwht3Om+koH28dZZn//dHLQ/A/v/hohlPrNqUTZUKTK2gupqUb
	Oxf4naDdRzyKSfIlov5scF/NpdB7TdB28Dstm0mB03J8HVIdnELVP7zkoC6Co4NolSGkNiTgl2p
	Cm5LsmjM2JwpRIwewmuB1Uj0Ec0wHLuO5HNJNoNFdMLE/VfytUwP0igbjCHvFCYHWVlkR1WW7o=
X-Received: by 2002:a05:6830:4901:b0:7dc:c4ae:a689 with SMTP id
 46e09a7af769-7e9ec586d01mr4829708a34.2.1782875473497; Tue, 30 Jun 2026
 20:11:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260505062026.91724-1-cuiyunhui@bytedance.com>
 <20260505062026.91724-2-cuiyunhui@bytedance.com> <3720c3a4-cc0d-4ba8-97ae-35def0189e2e@app.fastmail.com>
In-Reply-To: <3720c3a4-cc0d-4ba8-97ae-35def0189e2e@app.fastmail.com>
From: yunhui cui <cuiyunhui@bytedance.com>
Date: Wed, 1 Jul 2026 11:11:02 +0800
X-Gm-Features: AVVi8CfCZ39PlUVHuhvVesQ30Ayu5byi3NLY-dGR5ZLniizemgTSehNq4vDg6QE
Message-ID: <CAEEQ3wn8AFVqWZAiXfQd4a1ZzH=2L8qRX4W3S=KcmQ5FORjn+Q@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v4 1/3] riscv: io: avoid null-pointer
 arithmetic in PIO helpers
To: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, "Christoph Lameter (Ampere)" <cl@gentwo.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	=?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, pulehui@huawei.com, 
	puranjay@kernel.org, Thomas Huth <thuth@redhat.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Ben Dooks <ben.dooks@codethink.co.uk>, 
	=?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>, 
	Samuel Holland <samuel.holland@sifive.com>, Zong Li <zong.li@sifive.com>, 
	"Conor.Dooley" <conor.dooley@microchip.com>, Thomas Gleixner <tglx@kernel.org>, 
	Deepak Gupta <debug@rivosinc.com>, seanwascoding@gmail.com, 
	Andy Chiu <andybnac@gmail.com>, menglong8.dong@gmail.com, cyrilbur@tenstorrent.com, 
	wangruikang@iscas.ac.cn, Atish Patra <atishp@rivosinc.com>, 
	Anup Patel <apatel@ventanamicro.com>, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, qingfang.deng@siflower.com.cn, 
	Linux-Arch <linux-arch@vger.kernel.org>, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8h5deuky8rj5t5e9n5qs1s5omskodpjj
X-Rspam-User: 
X-Rspamd-Queue-Id: C94CDA0008
X-Rspamd-Server: rspam02
X-HE-Tag: 1782875474-652819
X-HE-Meta: U2FsdGVkX1846x7SZWbMEcXuSpPUCi4bZfM7dDyD8S6eANQytWd+yqxTZ3meYlfngV5tRc0qG9GKLyhDo4EfFCuhFLttff+EQNYLSdu5LSTplkLVZltqPljaqb5k/SfIv/vC8ZS8DQSl7iCnt/ENuM3CQXtAlzVCyH6rH9CyC+5th+N2NqkI6rbpPNErBLgnA4Sik/VPZWPaJRXWLxpKkamu735b6a2JEdMl4QVZVbtezxsPaJe4fuNOyUEvz5tqs/sFOzEjA426Sr6TzOq4QSBqoVCzxOktuuYr43h9Jg7fHkb/n4xquNzHVY4frrO7uWEvaFDLFF8Y0NTrw5CmHvBXQ4Vy4bSmuApLgUEo6wobCfFKOfv6A+9deV3D0fE3TDWzvud4/00tBXQcNse5OzidOHKD4+AURAHT3pAknOV5G6j6rxSJW6L8j1aUw1nK0S4SKDDcL36/6TnJ+UEzG3ZUK1UDGSsiJJ+1F7EUMPRcsCKeGq3nLYkVAbMzgGySat6P+Q3NqgpbfLKdS9gBPPiI/zvqgl4JO/yFnvO2lNqVwK8SOC8Ii/kZU89NzIa+sjvwmWsYiIZUbWjj2nsVTgl4MDQmWrWLTGS0Exu3xalXYQOqY5cCoyR2yUdHGxuBf++wBVcOcU/JgNOEaubG4Hp1cxggkaEr5uiDELjol3R4MkuAL1nxHafeuy/WSy84RA+gY71LVcMEeZUCe+qQKECfobe7nKvbrTriqmKWG3NtsQ8H3Mte5nGy4isEFyaHytDL5ikib802MrRZqYMwC5i+ygCf9LnXmDNJkr7BkOO9OAj/lYEATNaOyY7M8Fy9CBtMJMVI738tyy1CFQZM0id2IhfasDWHHuBiMlXgGoOU97YM9WxeGXYSg696AJ4HnmEwAc9Hf0jmhreFnqGczTZGrQqXymV3Gqwl3/7pdz4ZDZz7ePtWkdl1rhL6fMKHj6SX+YujrDoY4nzoSm7
 nassPSby
 hbPeGogZ/uhn8Z9YfT39fYDnWVDQNmWAxJ25WK5lozyEh+66eKMim//P6FvLkCQTqy4yHyKWh6N5qTt6vH4TTzmpSSHU4tHJh7hiEYcgQKzOrTdCtrT5GwUI8rUmOskq9z7klcMdmYKhKs9Qnaz1nCWvIxNYXxjAnVMPXv/oGCRNRJ4bqpgS7YrTqClc6aoH/Cx25Tc8ra6o0KnEty6Kzs/yCRuSEigX/oC5WZFqfZalbdAwHzsornY1jc7JbpsNpV46xtiozc3JpbXV0gzNDVsDHcc8B17KEd6OfH9U5yHYqqeUGNkDwMZpuU3p8yUEWKhd8g7L3cQvW7eLdeG6Bv98nZfmEE3pp4L9zLbZgxkVBxF4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Arnd,

On Tue, May 5, 2026 at 2:34=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Tue, May 5, 2026, at 08:20, Yunhui Cui wrote:
> > The RISC-V PIO helpers derive I/O addresses from PCI_IOBASE in ins*(),
> > outs*(), and ioport_map().
> >
> > Under configurations where I/O port support is not available, these
> > expressions can still be formed during compilation and trigger
> > -Wnull-pointer-arithmetic warnings from clang.
>
> If a driver attempts to use ISA port operations in a configuration
> without CONFIG_HAS_IOPORT, there is a NULL pointer warning because
> this is actually a NULL pointer access that will crash the
> kernel if the driver is ever loaded. You should not attempt
> to shut up the useful warning here but instead make sure every
> such code has a proper 'depends on HAS_IOPORT' dependency.

Thanks for the review.

I agree that NULL-pointer arithmetic warnings can point to real missing
HAS_IOPORT dependencies in drivers, and we should not hide those globally.

You are right about the generic ioport_map() change: the helper is already
guarded by CONFIG_HAS_IOPORT_MAP, so the extra CONFIG_HAS_IOPORT check is
redundant. I will drop that change.

For the RISC-V ins*/outs* helpers, they use PIO-specific fences
(__io_pbr()/__io_par() and __io_pbw()/__io_paw()), while the asm-generic
helpers would go through readsb()/writesb() and use normal MMIO string
ordering. So removing them would change ordering semantics.

I will keep the RISC-V helpers for now and only guard the port-I/O
variants with CONFIG_HAS_IOPORT.

>
> >
> > +#ifdef CONFIG_HAS_IOPORT
> >  __io_reads_ins(ins,  u8, b, __io_pbr(), __io_par(addr))
> >  __io_reads_ins(ins, u16, w, __io_pbr(), __io_par(addr))
> >  __io_reads_ins(ins, u32, l, __io_pbr(), __io_par(addr))
> > -#define insb(addr, buffer, count) __insb(PCI_IOBASE + (addr), buffer, =
count)
> > -#define insw(addr, buffer, count) __insw(PCI_IOBASE + (addr), buffer, =
count)
> > -#define insl(addr, buffer, count) __insl(PCI_IOBASE + (addr), buffer, =
count)
> > +#define insb(addr, buffer, count) __insb(PCI_IO_ADDR(addr), buffer, co=
unt)
> > +#define insw(addr, buffer, count) __insw(PCI_IO_ADDR(addr), buffer, co=
unt)
> > +#define insl(addr, buffer, count) __insl(PCI_IO_ADDR(addr), buffer, co=
unt)
> > +#endif
>
> Can you try to remove the custom accessors altogether and
> use the ones from asm-generic instead? These should already
> have the correct behavior all the time, in particular they
> already come with the correct #ifdef check that is apparently
> missing in the riscv version.
>
> > diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
> > index ca5a1ce6f0f89..d799e5ccc9437 100644
> > --- a/include/asm-generic/io.h
> > +++ b/include/asm-generic/io.h
> > @@ -1205,8 +1205,12 @@ static inline void __iomem
> > *ioremap_np(phys_addr_t offset, size_t size)
> >  #define ioport_map ioport_map
> >  static inline void __iomem *ioport_map(unsigned long port, unsigned
> > int nr)
> >  {
> > +#ifdef CONFIG_HAS_IOPORT
> >       port &=3D IO_SPACE_LIMIT;
> >       return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
> > +#else
> > +     return NULL;
> > +#endif
> >  }
>
> The function definition here is guarded by the #ifdef CONFIG_HAS_IOPORT_M=
AP
> check, which should already prevent it from being visible when
> CONFIG_HAS_IOPORT is disabled.
>
>      Arnd

Thanks,
Yunhui

