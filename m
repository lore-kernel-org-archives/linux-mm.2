Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE58CCA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 12:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46FD96B00BF; Tue, 19 Aug 2025 08:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0FE6B00C1; Tue, 19 Aug 2025 08:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E72C6B00C0; Tue, 19 Aug 2025 08:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18B7F6B00A1
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:45:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C96B4160622
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:45:24 +0000 (UTC)
X-FDA: 83793477768.19.234F3F6
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7071F18000E
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:45:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=b54MkgSH;
	spf=pass (imf16.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.167.175 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755607522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FUojvKeMBqfwF4oHIlHpGQRStzsw4ZB/bPNyhGSltUU=;
	b=X5eA6sRoSLbWTA3RRX/cLWO3NIH8o4DqYB75vBu7swZY7aZvfKHpsScp2nMjDTz2bRiGec
	9yV32J9I8McwrAp0LKbwyxOMVg9hC1nTbArvm/srWmUi9gJpq+5haEt3bOg/+NafompLWf
	S9LAf3gbjuuqBzGyU+g8O4wwbWF1ctQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755607522; a=rsa-sha256;
	cv=none;
	b=ljorU/7pE1adYUpJo8b2iftrjmpBqqN870DDoOwKRhEkXI+LOiRxFWWLoBUtkqPqiozxa3
	/bMc/9WYByue7e35HqnZwKNWcFjLr1sx8MP4OUzcSzPMmavFVaBZPTWdb64fRzp5lj8ha4
	WBqlBXG1hTHnbpYYtlvzZiZxbCSgwrw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=b54MkgSH;
	spf=pass (imf16.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.167.175 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-435de7ab175so371561b6e.2
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 05:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755607520; x=1756212320; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FUojvKeMBqfwF4oHIlHpGQRStzsw4ZB/bPNyhGSltUU=;
        b=b54MkgSHtFlBfly9rfru6ZPvOv7wpqPAgP5m5FHW/wMHxN6zYAjCcoyh+1mhkByB7v
         pnJFMmaDxNAUc5mYUSGJk6z9Xz6eXEx7vOR14MNqg5RYS088p2LpQlyT5r7flNQGd7q5
         doiybT+34/UY1GfyZTsmfig4U7xDZFQcmTUUHUOhmNzWyJkUYWEtsnC5AZpdrKO6IEav
         S/fZ0sB6K/xgIpm6u+ijhYHvMlhYWOjK4n3IxEQXN368CFKab1siZSnFlwFlP3QlWS9N
         46GjEeLMC96PAHo8WrVTInrl1HqFFUUuFxUFixiD/+XwumY9Y/S+FUrEqiPs2RHqiJkG
         wYPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755607520; x=1756212320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FUojvKeMBqfwF4oHIlHpGQRStzsw4ZB/bPNyhGSltUU=;
        b=S3sySQkUHxRgRzcdpKNK2c3V6a6JtJ+X8kDd52t3gyld9dGukS4A1U0ZMDoRA+84YI
         0mixKMvDbiIdJYoSekT+IBItI7suJl4+gPThRdak5uJaILNBco7pG9t8GGsIXTxP91aG
         Szn+SvQWoz+W6n8UeD6TEFj0I9B0qNAvIQ5iLehT4Yd5IKtYUvzELbJPodU/jH2w87na
         ODHjDCEO3unMxPEL0jT0a6JDfpjyDE8QpkT03vco2tZzcmvgDa2KiDhfB+Uo7JVuyt32
         0zjX8yhirOoSDmWL8RXDJoVUVOBeKSsnH+RYqYV63up3yGdVuQCDbR+ORd+lRH4ePkIc
         Mr+g==
X-Forwarded-Encrypted: i=1; AJvYcCUOfQG5OJ4q5gpnBmeGs0bzXSNAwV/nSZAR/D+ozcjEtP3GDBMgvab8c7xgtb77ECBWwVYiEL5f1g==@kvack.org
X-Gm-Message-State: AOJu0YwNoKIc6IfSjukV95iTk2l3LcJmSofAPLE1+ySTCRUsyPDYZNsR
	BJ17Yu7d/Tk2Dx7i9t/fvzvo3D0bz1WNgck24lZHVoZr1Gf4DXNqigNeoDRSy5+9q7fKIqn+XmW
	g2YkDsjEmoDg7apPTikq6x1piZkcnKUCgGf/HpbZijA==
X-Gm-Gg: ASbGncsNUUAslu4PoTwAi8tYw6ZcpwUfS6xWpn4lQEWJ/3WeP75sqn4zvyu1ZlrmRpZ
	ts6lBooZMvCGpUgdISIRtiAfbUC1PhjMnPpZUcCoFTYZrhByubSqNrtulUkBEE1P5MZQ5/lKnCT
	5VlMpNQO/BS5/KKT89lQYcVXapvr/NVbiGGB3WBndVquPXic/nxp0aDbeYhecQMhVbpMlhhcSzQ
	vFfieFXbOAdOL7buWWdWyrB0Tc+
X-Google-Smtp-Source: AGHT+IG1P73YNABywoBqFugfnLVsaKoash1sBuVSd1ClslQnR6v+KIcsSELoKISWQ8BcxeVjtLvfgi6rGdRvY1EJbps=
X-Received: by 2002:a05:6808:4497:b0:435:8506:1b40 with SMTP id
 5614622812f47-436c12bdc8emr1500322b6e.0.1755607520124; Tue, 19 Aug 2025
 05:45:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250618034328.21904-1-cuiyunhui@bytedance.com>
 <20250618034328.21904-2-cuiyunhui@bytedance.com> <c9ba6163-6703-441b-915c-d784044f862f@ghiti.fr>
 <b0583098-204a-4ad1-b173-4bd00a358d61@ghiti.fr> <CAEEQ3w=uz-kTe05-fnPa_BfkZ6ZocQHg-G001yBtLqRM2zEr+g@mail.gmail.com>
 <404d38d7-f21b-4c97-b851-8b331deb3f8a@ghiti.fr> <CAEEQ3wknpn0Y6H8A-MEk-9hkvUwv0VapbtBR97Qhz9ipCk2Jew@mail.gmail.com>
 <416b8286-7c78-4c56-8328-5e1b99bf15d4@ghiti.fr>
In-Reply-To: <416b8286-7c78-4c56-8328-5e1b99bf15d4@ghiti.fr>
From: yunhui cui <cuiyunhui@bytedance.com>
Date: Tue, 19 Aug 2025 20:45:08 +0800
X-Gm-Features: Ac12FXzdvyJ1fET3KfuvaYRhHbOu4YJdVzd-_7iXNtQL0eIHLkP87MM3NeJ87Bk
Message-ID: <CAEEQ3wkoNFmL1h2CXu9jfmVZfBmAC9ZiTo1vLQ8Xcohc9g9J2A@mail.gmail.com>
Subject: Re: [External] Re: [PATCH RFC 2/2] riscv: introduce percpu.h into include/asm
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: yury.norov@gmail.com, linux@rasmusvillemoes.dk, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, dennis@kernel.org, tj@kernel.org, cl@gentwo.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7071F18000E
X-Stat-Signature: aruxu4fy7ceitzkze1hrb5odtnk8gon9
X-HE-Tag: 1755607521-98073
X-HE-Meta: U2FsdGVkX1+RUhRDJ5QFDVr7ssA4qBaZggjaqxMkQp8gF2UkllNz42zTIV+fj2Lps117LL8Kz/GUSCv8WxfYTmt9HktvfY5RKoPezhul3RfaZLRITUkZ1yL0vgTHADIxsLI9/BhOR5ji/E6OzZmhhYFUsZ1t9vlZBSj6zLEyeNGZPABf0Y359Pa/3mM+D2wrFpm6FjsFN159hbwU8Id+uFhPNgI2BXs+pJKXr9zoPyiag7n3NY2HIkQZFWHUEFaDVBA1ZVzT74TDrEHRsef9kxdZlm2IStQ8sJsnCx4BRiw0T7NGvIru/ZcNACDdz3X1t79zZs6YRfoje137H8bFwrTepE7FtDZhrRlImUUR95Qyztee1b7gQHEOPxQ11a+ohBWIPqG9D0DVWZF45ZFjHmOffMxK8dDF2Xhqn8mk2iSQe4SmIArT419EzgcYJj5kZNjuUlpibbYefCBwx80QWY9ykw6I3keBdJ6BXnZAvPn7KPcwmFsIanpLUr+w5Oo1eOf3DY2Tkug6ByNYih3pypvufhnqZM1ibLzK7rVuNLM/vo478o9mct14RBmCIqRFSIzDl7neMMQKiHhosfazthidKvEiODxJ+lGTB8NJ3MFsV9dtENkzuJ1WYUOlsT9vYtR81uWkx4R4OfkA18iYoepEP9Va2Uu1DTzJNG8hvMs8Yw+khJEfGSphS/Iyle/aOZE247mPYto6h52aU2ny0cbXib1XDz3CKSvkh/SYAnOd2+So6gg3gpudAP6CeR2t3RGNhG22vSB7TKlRAxjYIEi+WWrTgmPu9Bonki6GXerZfMBbQ4LmrjxpjFDJFvCxBAaOgk2dzrh0vpLq7efkFkp4ummjNXjBjGczg5st6PBIVf7VaTFXkbCtn+kzfuxYeJwe+n5YalW8uJAp4/XRwM+pVjaDlsLteZJTRN/tK7iaxKGWLJyEZS3Fc9U7HyiRdB63HgAr8y2GmqeBS1w
 LpTIQ01n
 jXj1G/AegVfzHdVMt/74VEe6DJkEsGKPXjHH1/+DjW7tLeTRqSmxu8bMWidgyCYDYPuD+iDc85p6VBHKXZJcl1omQdbfmPE8MbsJ+CnCwBQUo5p+zbCsdBA22wyAXSD+3+ntvbOfu/E7uvYRQBJKQr5+3E7Qu9t8UiRKIDFyJovmy70FpkHe4isFst0yH0+jUEEcfLcteCHHDd31QdgUcDcS7+TXUWpuY8jgz+aFzqO3s2MIOsXisw6mL8iosrT4jt7bKwhW5f08kPm+IxpT/LJ8DjD1Ks/NuKAPI3ToElDvCH6eN/OrdruVjYKzTLQAw/Fc0pKtWoh9K6rqQdxBqy6aa/N+xkiwAxVYvZKLi2EXy8Ii27lcFYbdrrQugm0bnjcq+jkundM6zI6zR0m4HPOyOWMWzG0mgTnE+/BzQp5mn91U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alex,

On Thu, Aug 7, 2025 at 10:55=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> Hi Yunhui,
>
> On 7/18/25 16:33, yunhui cui wrote:
> > Hi Alex=EF=BC=8C
> >
> > On Fri, Jul 18, 2025 at 10:23=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr=
> wrote:
> >> Hi Yunhui,
> >>
> >> On 7/18/25 08:40, yunhui cui wrote:
> >>> Hi Alex,
> >>>
> >>> On Thu, Jul 17, 2025 at 9:06=E2=80=AFPM Alexandre Ghiti <alex@ghiti.f=
r> wrote:
> >>>> On 7/17/25 15:04, Alexandre Ghiti wrote:
> >>>>> Hi Yunhui,
> >>>>>
> >>>>> On 6/18/25 05:43, Yunhui Cui wrote:
> >>>>>> Current percpu operations rely on generic implementations, where
> >>>>>> raw_local_irq_save() introduces substantial overhead. Optimization
> >>>>>> is achieved through atomic operations and preemption disabling.
> >>>>>>
> >>>>>> Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
> >>>>>> ---
> >>>>>>     arch/riscv/include/asm/percpu.h | 138 ++++++++++++++++++++++++=
++++++++
> >>>>>>     1 file changed, 138 insertions(+)
> >>>>>>     create mode 100644 arch/riscv/include/asm/percpu.h
> >>>>>>
> >>>>>> diff --git a/arch/riscv/include/asm/percpu.h
> >>>>>> b/arch/riscv/include/asm/percpu.h
> >>>>>> new file mode 100644
> >>>>>> index 0000000000000..423c0d01f874c
> >>>>>> --- /dev/null
> >>>>>> +++ b/arch/riscv/include/asm/percpu.h
> >>>>>> @@ -0,0 +1,138 @@
> >>>>>> +/* SPDX-License-Identifier: GPL-2.0-only */
> >>>>>> +
> >>>>>> +#ifndef __ASM_PERCPU_H
> >>>>>> +#define __ASM_PERCPU_H
> >>>>>> +
> >>>>>> +#include <linux/preempt.h>
> >>>>>> +
> >>>>>> +#define PERCPU_RW_OPS(sz)                        \
> >>>>>> +static inline unsigned long __percpu_read_##sz(void *ptr)        =
\
> >>>>>> +{                                    \
> >>>>>> +    return READ_ONCE(*(u##sz *)ptr);                \
> >>>>>> +}                                    \
> >>>>>> +                                    \
> >>>>>> +static inline void __percpu_write_##sz(void *ptr, unsigned long
> >>>>>> val)    \
> >>>>>> +{                                    \
> >>>>>> +    WRITE_ONCE(*(u##sz *)ptr, (u##sz)val);                \
> >>>>>> +}
> >>>>>> +
> >>>>>> +#define __PERCPU_AMO_OP_CASE(sfx, name, sz, amo_insn)            =
\
> >>>>>> +static inline void                            \
> >>>>>> +__percpu_##name##_amo_case_##sz(void *ptr, unsigned long val)    =
    \
> >>>>>> +{                                    \
> >>>>>> +    asm volatile (                            \
> >>>>>> +    "amo" #amo_insn #sfx " zero, %[val], %[ptr]"            \
> >>>>>> +    : [ptr] "+A" (*(u##sz *)ptr)                    \
> >>>>>> +    : [val] "r" ((u##sz)(val))                    \
> >>>>>> +    : "memory");                            \
> >>>>>> +}
> >>>>>> +
> >>>>>> +#define __PERCPU_AMO_RET_OP_CASE(sfx, name, sz, amo_insn)        =
\
> >>>>>> +static inline u##sz                            \
> >>>>>> +__percpu_##name##_return_amo_case_##sz(void *ptr, unsigned long
> >>>>>> val)    \
> >>>>>> +{                                    \
> >>>>>> +    register u##sz ret;                        \
> >>>>>> +                                    \
> >>>>>> +    asm volatile (                            \
> >>>>>> +    "amo" #amo_insn #sfx " %[ret], %[val], %[ptr]"            \
> >>>>>> +    : [ptr] "+A" (*(u##sz *)ptr), [ret] "=3Dr" (ret)            \
> >>>>>> +    : [val] "r" ((u##sz)(val))                    \
> >>>>>> +    : "memory");                            \
> >>>>>> +                                    \
> >>>>>> +    return ret + val;                        \
> >>>>>> +}
> >>>>>> +
> >>>>>> +#define PERCPU_OP(name, amo_insn)                    \
> >>>>>> +    __PERCPU_AMO_OP_CASE(.b, name, 8, amo_insn)            \
> >>>>>> +    __PERCPU_AMO_OP_CASE(.h, name, 16, amo_insn)            \
> >>>>>> +    __PERCPU_AMO_OP_CASE(.w, name, 32, amo_insn)            \
> >>>>>> +    __PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)            \
> >>>>>> +
> >>>>>> +#define PERCPU_RET_OP(name, amo_insn)                    \
> >>>>>> +    __PERCPU_AMO_RET_OP_CASE(.b, name, 8, amo_insn) \
> >>>>>> +    __PERCPU_AMO_RET_OP_CASE(.h, name, 16, amo_insn)        \
> >>>>>> +    __PERCPU_AMO_RET_OP_CASE(.w, name, 32, amo_insn)        \
> >>>>>> +    __PERCPU_AMO_RET_OP_CASE(.d, name, 64, amo_insn)
> >>>>>> +
> >>>>>> +PERCPU_RW_OPS(8)
> >>>>>> +PERCPU_RW_OPS(16)
> >>>>>> +PERCPU_RW_OPS(32)
> >>>>>> +PERCPU_RW_OPS(64)
> >>>>>> +
> >>>>>> +PERCPU_OP(add, add)
> >>>>>> +PERCPU_OP(andnot, and)
> >>>>>> +PERCPU_OP(or, or)
> >>>>>> +PERCPU_RET_OP(add, add)
> >>>>>> +
> >>>>>> +#undef PERCPU_RW_OPS
> >>>>>> +#undef __PERCPU_AMO_OP_CASE
> >>>>>> +#undef __PERCPU_AMO_RET_OP_CASE
> >>>>>> +#undef PERCPU_OP
> >>>>>> +#undef PERCPU_RET_OP
> >>>>>> +
> >>>>>> +#define _pcp_protect(op, pcp, ...)                    \
> >>>>>> +({                                    \
> >>>>>> +    preempt_disable_notrace();                    \
> >>>>>> +    op(raw_cpu_ptr(&(pcp)), __VA_ARGS__);                \
> >>>>>> +    preempt_enable_notrace();                    \
> >>>>>> +})
> >>>>>> +
> >>>>>> +#define _pcp_protect_return(op, pcp, args...)                \
> >>>>>> +({                                    \
> >>>>>> +    typeof(pcp) __retval;                        \
> >>>>>> +    preempt_disable_notrace();                    \
> >>>>>> +    __retval =3D (typeof(pcp))op(raw_cpu_ptr(&(pcp)), ##args);   =
 \
> >>>>>> +    preempt_enable_notrace();                    \
> >>>>>> +    __retval;                            \
> >>>>>> +})
> >>>>>> +
> >>>>>> +#define this_cpu_read_1(pcp) _pcp_protect_return(__percpu_read_8,=
 pcp)
> >>>>>> +#define this_cpu_read_2(pcp) _pcp_protect_return(__percpu_read_16=
, pcp)
> >>>>>> +#define this_cpu_read_4(pcp) _pcp_protect_return(__percpu_read_32=
, pcp)
> >>>>>> +#define this_cpu_read_8(pcp) _pcp_protect_return(__percpu_read_64=
, pcp)
> >>>>>> +
> >>>>>> +#define this_cpu_write_1(pcp, val) _pcp_protect(__percpu_write_8,
> >>>>>> pcp, (unsigned long)val)
> >>>>>> +#define this_cpu_write_2(pcp, val) _pcp_protect(__percpu_write_16=
,
> >>>>>> pcp, (unsigned long)val)
> >>>>>> +#define this_cpu_write_4(pcp, val) _pcp_protect(__percpu_write_32=
,
> >>>>>> pcp, (unsigned long)val)
> >>>>>> +#define this_cpu_write_8(pcp, val) _pcp_protect(__percpu_write_64=
,
> >>>>>> pcp, (unsigned long)val)
> >>>>>> +
> >>>>>> +#define this_cpu_add_1(pcp, val)
> >>>>>> _pcp_protect(__percpu_add_amo_case_8, pcp, val)
> >>>>>> +#define this_cpu_add_2(pcp, val)
> >>>>>> _pcp_protect(__percpu_add_amo_case_16, pcp, val)
> >>>>>> +#define this_cpu_add_4(pcp, val)
> >>>>>> _pcp_protect(__percpu_add_amo_case_32, pcp, val)
> >>>>>> +#define this_cpu_add_8(pcp, val)
> >>>>>> _pcp_protect(__percpu_add_amo_case_64, pcp, val)
> >>>>>> +
> >>>>>> +#define this_cpu_add_return_1(pcp, val)        \
> >>>>>> +_pcp_protect_return(__percpu_add_return_amo_case_8, pcp, val)
> >>>>>> +
> >>>>>> +#define this_cpu_add_return_2(pcp, val)        \
> >>>>>> +_pcp_protect_return(__percpu_add_return_amo_case_16, pcp, val)
> >>>>>> +
> >>>>>> +#define this_cpu_add_return_4(pcp, val)        \
> >>>>>> +_pcp_protect_return(__percpu_add_return_amo_case_32, pcp, val)
> >>>>>> +
> >>>>>> +#define this_cpu_add_return_8(pcp, val)        \
> >>>>>> +_pcp_protect_return(__percpu_add_return_amo_case_64, pcp, val)
> >>>>>> +
> >>>>>> +#define this_cpu_and_1(pcp, val)
> >>>>>> _pcp_protect(__percpu_andnot_amo_case_8, pcp, ~val)
> >>>>>> +#define this_cpu_and_2(pcp, val)
> >>>>>> _pcp_protect(__percpu_andnot_amo_case_16, pcp, ~val)
> >>>>>> +#define this_cpu_and_4(pcp, val)
> >>>>>> _pcp_protect(__percpu_andnot_amo_case_32, pcp, ~val)
> >>>>>> +#define this_cpu_and_8(pcp, val)
> >>>>>> _pcp_protect(__percpu_andnot_amo_case_64, pcp, ~val)
> >>>>> Why do we define __percpu_andnot based on amoand, and use
> >>>>> __percpu_andnot with ~val here? Can't we just define __percpu_and?
> >>
> >> What about that ^?
> >>
> >>
> >>>>>> +
> >>>>>> +#define this_cpu_or_1(pcp, val) _pcp_protect(__percpu_or_amo_case=
_8,
> >>>>>> pcp, val)
> >>>>>> +#define this_cpu_or_2(pcp, val)
> >>>>>> _pcp_protect(__percpu_or_amo_case_16, pcp, val)
> >>>>>> +#define this_cpu_or_4(pcp, val)
> >>>>>> _pcp_protect(__percpu_or_amo_case_32, pcp, val)
> >>>>>> +#define this_cpu_or_8(pcp, val)
> >>>>>> _pcp_protect(__percpu_or_amo_case_64, pcp, val)
> >>>>>> +
> >>>>>> +#define this_cpu_xchg_1(pcp, val) _pcp_protect_return(xchg_relaxe=
d,
> >>>>>> pcp, val)
> >>>>>> +#define this_cpu_xchg_2(pcp, val) _pcp_protect_return(xchg_relaxe=
d,
> >>>>>> pcp, val)
> >>>>>> +#define this_cpu_xchg_4(pcp, val) _pcp_protect_return(xchg_relaxe=
d,
> >>>>>> pcp, val)
> >>>>>> +#define this_cpu_xchg_8(pcp, val) _pcp_protect_return(xchg_relaxe=
d,
> >>>>>> pcp, val)
> >>>>>> +
> >>>>>> +#define this_cpu_cmpxchg_1(pcp, o, n)
> >>>>>> _pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
> >>>>>> +#define this_cpu_cmpxchg_2(pcp, o, n)
> >>>>>> _pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
> >>>>>> +#define this_cpu_cmpxchg_4(pcp, o, n)
> >>>>>> _pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
> >>>>>> +#define this_cpu_cmpxchg_8(pcp, o, n)
> >>>>>> _pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
> >>>>>> +
> >>>>>> +#include <asm-generic/percpu.h>
> >>>>>> +
> >>>>>> +#endif /* __ASM_PERCPU_H */
> >>>>> It all looks good to me, just one thing, can you also implement
> >>>>> this_cpu_cmpxchg64/128()?
> >>>>>
> >>>> One last thing sorry, can you add a cover letter too?
> >>> Okay.
> >>>
> >>>> Thanks!
> >>>>
> >>>> Alex
> >>>>
> >>>>
> >>>>> And since this is almost a copy/paste from arm64, either mention it=
 at
> >>>>> the top of the file or (better) merge both implementations somewher=
e
> >>>>> to avoid redefining existing code :) But up to you.
> >>> Actually, there's a concern here. We should account for scenarios
> >>> where ZABHA isn't supported. Given that xxx_8() and xxx_16() are
> >>> rarely used in practice, could we initially support only xxx_32() and
> >>> xxx_64()? For xxx_8() and xxx_16(), we could default to the generic
> >>> implementation.
> >>
> >> Why isn't lr/sc enough?
> > If I'm not mistaken, the current RISC-V does not support lr.bh/sc.bh,
> > is that right?
>
>
> Yes, that's right, but we have an implementation of cmpxchg[8|16]() that
> uses lr.w/sc.w which works (unless I missed something, I have just
> checked again), so I think that's alright no?

Since RISC-V does not support lr/sc.b/h, when ZABHA is not supported,
we need to use lr/sc.w instead, which requires some additional mask
operations. In fact, 8/16-bit percpu operations are very few. The
number of system startup operations is as follows:

8-bit Adds: 3, 16-bit Adds: 3, 32-bit Adds: 31858, 64-bit Adds: 7656
8-bit Add-Returns: 0, 16-bit Add-Returns: 0, 32-bit Add-Returns: 0,
64-bit Add-Returns: 2
8-bit ANDs: 0, 16-bit ANDs: 0, 32-bit ANDs: 0, 64-bit ANDs: 0
8-bit ANDNOTs: 0, 16-bit ANDNOTs: 0, 32-bit ANDNOTs: 0, 64-bit ANDNOTs: 0
8-bit ORs: 0, 16-bit ORs: 0, 32-bit ORs: 70, 64-bit ORs: 0

So, when ZABHA is not supported, can 8bit/16bit operations directly
fall back to the generic implementation?


>
> Thanks,
>
> Alex
>
>
> >
> >>
> >>>
> >>>>> Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> >>>>>
> >>>>> Thanks,
> >>>>>
> >>>>> Alex
> >>>>>
> >>>>>
> >>>>>
> >>> Thanks,
> >>> Yunhui
> >>>
> >>> _______________________________________________
> >>> linux-riscv mailing list
> >>> linux-riscv@lists.infradead.org
> >>> http://lists.infradead.org/mailman/listinfo/linux-riscv
> > Thanks,
> > Yunhui
> >
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv

Thanks,
Yunhui

