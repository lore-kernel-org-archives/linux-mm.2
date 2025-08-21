Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B98CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 08:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38868E0027; Thu, 21 Aug 2025 04:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9A78E0002; Thu, 21 Aug 2025 04:01:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D8D48E0027; Thu, 21 Aug 2025 04:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B2078E0002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 04:01:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 374271174DF
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:01:26 +0000 (UTC)
X-FDA: 83800019772.12.719780C
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0A11040019
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:01:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LtjFSqyv;
	spf=pass (imf27.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755763284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0l+hqGahEDr13/VVOMr1/ba48aJ1pl6KG+1VNry8aA=;
	b=1t2ZOFSBBzA9uZs8qHsdDpX2Jt7xeAgfCXX3GLYS8A+GI9zmB9ZNv2EU7QL2dCqVqsZsVU
	AlAb/EY7TzbS7WvGpaB6AuOFmZ81fY4tm9KjrwtvEdNfWAypA3CgFRpOonMkZSiRxK1pae
	OksDid5q07X6c9tU5ImTF2FO4lwBQ1s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LtjFSqyv;
	spf=pass (imf27.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755763284; a=rsa-sha256;
	cv=none;
	b=Nl57FUDqX2RAT6o0ZzLMoB5ZNUdi6jFBeXLT4xK1u2JI/m4jFz4J9/XtGHt4Kp1vq16kq6
	1UF3knlCGQzk3PsbQomQwLEkjRaRYEgkGGoNBTp/4LKQUJSQJK2j+Mb+ud6U9TQTBDY/1I
	t1T8PveL9kBlHemkobMaTCNHaiARNAQ=
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-30cce58bb89so1023603fac.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755763283; x=1756368083; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X0l+hqGahEDr13/VVOMr1/ba48aJ1pl6KG+1VNry8aA=;
        b=LtjFSqyvI9tWZMD5D7OeD/L9MM4Qgu7/xY15ySNfmiPqHXDgOaLZpKtECBL8MZ4J+x
         hpRwjbMzq/Gak0hAuZyh5Jri1qaUr0uItb1Q8kEaU8JjxWuZDzeip3y61okgnFHKBgUQ
         zN8Kmj26Hop5ekYWVjGwmKvyfkbaI1ZKBHo2UXyyWU5030En9+4aKODZgmgw/59rMWvV
         ASO7s5Uc/j9sHB/7FQMppzhIzyX7r1kNu0M39D2fLMNKLtCz4QNeUXu8Yv7URUvHOG5p
         tEHk5uMEHAKzHAme3ybPrAn4aS7Hu4Fja3WUhFHXtZwTmomBlYMEOECo7nUP9VdG4Jg3
         33ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755763283; x=1756368083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X0l+hqGahEDr13/VVOMr1/ba48aJ1pl6KG+1VNry8aA=;
        b=McJpysbpDbz0aVXpJY4Y0yMa3BOBPGE0LGOo7MOYlPihO9WKQ3a+PXL7Jx1Pn+uGYE
         LpIuKyseiMLDeehyZA9T21Vzfxj0q0DPF5YnrAs/cDHmLTQrBK6DU5xzWSmCypUYwlkB
         Q+lgjfMLChpsKss9amVvZxnvtdpb322Nc9NJMgvrQnty49JLv3fcDGN5prUQEN0vCpKe
         xTgo9ESlrGYD6OFio3NWaxIcHBYYBhstEm9GC3fB6w4NhIyM6yjNfKlg8ChjFRNsI159
         Xjc6UP3bgIHX+XWS7Rd43wbtWrhh3LqKop81CrrdmFHt/oqJ5Hdnk/9nzqhk6fuX6Hul
         VQfA==
X-Forwarded-Encrypted: i=1; AJvYcCUwb1ivtm55Ity3clp33r9nVDhUOPp/HUKlgVno6APBxCnN5XycpRgDvA/8CLwIojC3c6rcuvao2w==@kvack.org
X-Gm-Message-State: AOJu0YxaJ09Ik3CjSrECt9wJXSOb5uZxLpfzCZ25P06AD6aWR61F/0pJ
	50EbKq+waEsMdXXIpLjuVp3yIKJBSXrx37F/mxEeHcdfuRoQiDcY+pBGRIuEtYy8A0r7iu2kPWu
	PuGHcxgw/LeaddVxBTDW7dDc/FBXZUZBBx8HiHiZfJg==
X-Gm-Gg: ASbGncsc32QSv6SWJ4odk9E2ZlJrZoIinzGGqciAt0X7XEX3v4rNhiCKYjQa8hiSSpk
	+Y5qb5hphPr5Bp0GXVt1P7S0hLLHwKg2UYwKfd5hEuFIdICEEjs0tTSQy5b46pFz30kWIyAktfq
	KNc3Fv9j8ghVCZ+rG+/8FyXcWeUXuaTMvOL9snznOnSUao0OZoGD4JiC5VIbqz/37vgLTg5HI1G
	GiSC1AAM6q8vl29h2JKIqtm
X-Google-Smtp-Source: AGHT+IE1OeafrLylfvLmrdDojnOroAp8hDYwluDFKL9kS6j+UuoaPTREpF8UcR7eJdteZMLpeZ1xWt+LGXG2u0Pv6TQ=
X-Received: by 2002:a05:6808:50a5:b0:435:27b4:3fcb with SMTP id
 5614622812f47-4377d6b1ed9mr504349b6e.3.1755763282540; Thu, 21 Aug 2025
 01:01:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250819135007.85646-1-cuiyunhui@bytedance.com>
 <20250819135007.85646-3-cuiyunhui@bytedance.com> <e7653089-5c57-ee61-ed01-0b3245e10d82@gentwo.org>
In-Reply-To: <e7653089-5c57-ee61-ed01-0b3245e10d82@gentwo.org>
From: yunhui cui <cuiyunhui@bytedance.com>
Date: Thu, 21 Aug 2025 16:01:11 +0800
X-Gm-Features: Ac12FXwUWi_BUfDOcCWj-9DhtNJYZaytAFdS1lP3UQLaq51ftYyrJTGQtLfjgb4
Message-ID: <CAEEQ3w=KrysBJrkYA6mUKCjC=fz23R7u81a2p8EipaN9oVHs_Q@mail.gmail.com>
Subject: Re: [External] Re: [PATCH 2/2] riscv: introduce percpu.h into include/asm
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: yury.norov@gmail.com, linux@rasmusvillemoes.dk, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	dennis@kernel.org, tj@kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0A11040019
X-Stat-Signature: czdmfr6rgwzntu4kdnkqhk669cksga8o
X-Rspam-User: 
X-HE-Tag: 1755763283-275055
X-HE-Meta: U2FsdGVkX1/NUrY4/aklvdQZVqyw5xqRXBIRNbViY0PbHGeEj20YHExvKA2EhE9KNstVGuFOuQyucZ/pgaKj9G4uiRbfm1gVK4bsXpFPka/mc0da2sK7NTOxrY5vdaNhFfLoJjilxZE5tC+A1ZmrAIifNwGGzsEoyV1MkFwFjKKvAi7/MyVoptPNVUeOxVvv+fCRmCLynYT07Rbz6F47P7etUdN8gl12hXYUHAV/VrnuHpwyXn2vxNSjt0Zztby/c33DexBb8UpW8eXYZH6ZBdQDakSpy+KawKmvybjnIE7yD+V9vPqm+NMCOWiPFRVuhLbEjOzfJWMfRHhDT/snCZO6GJZ9YwW+Kjg5h1GuoLxuOFzBaihKZ+QA82qosUJFcHYB2QQZtmDsY2tttUjOSNP7jSYGPcsCNoG37rR++171oIrG9u2RJtHnOzRcS/TxL166DmYX3Ud8R+mK/Srlv4rUpEKpJSCEBHxGZw1oLQ7BDIj6L+oxguur+VNSu+MBs9DTmV//R6pe3Tgg8igupA4PRQUU6kr5qU1Ts/Zobwm0/ysBKN9PmsoEGuOWlKv6B49ktXFwZKCHmVqjbwzb0uO91mJdtotf1plVZhZ5W5QdnbgjPQuYQL3JWdBjrs6lPgMfkASk9+x01T2yjNWKIbvMEbH7/hAbl59NLOF7+523riRo7JaqR2WgERXCYYLKEcOfeM/OCqMgmmrnVDRWxbC0phHfV0iGnIGuKBOPiPpI7vhWQPXQBSu3/P79nijHTm2aZO+F2+6eZcGZ5lJL1c+AA9SczKKh/XLHHf8WsjKDZNOIKgsq6Sym2TmJqonl0MmbyeJW41gV2evfdXm73aYqqHf006yuA3NqXDSPTKUOnwbp7mMVmPfjkBMZ1oQQq/yCPjsIGOnNBNjwQJ62Tib6vHwIQA8sFqEScwMK0S46xt7b4ziG6o4pHnySZ3OGLICoqp9WKwJcDH5wOWM
 2153C+X5
 mqOB+HPD4hxWtoyO0Lut7sulZNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Christoph,

On Thu, Aug 21, 2025 at 7:39=E2=80=AFAM Christoph Lameter (Ampere)
<cl@gentwo.org> wrote:
>
> On Tue, 19 Aug 2025, Yunhui Cui wrote:
>
> > +#define __PERCPU_AMO_OP_CASE(sfx, name, sz, amo_insn)                 =
       \
> > +static inline void                                                   \
> > +__percpu_##name##_amo_case_##sz(void *ptr, unsigned long val)         =
       \
> > +{                                                                    \
> > +     asm volatile (                                                  \
> > +             "amo" #amo_insn #sfx " zero, %[val], %[ptr]"            \
> > +             : [ptr] "+A" (*(u##sz *)ptr)                            \
> > +             : [val] "r" ((u##sz)(val))                              \
> > +             : "memory");                                            \
> > +}
>
> AMO creates a single instruction that performs the operation?
>
> > +#define _pcp_protect(op, pcp, ...)                                   \
> > +({                                                                   \
> > +     preempt_disable_notrace();                                      \
> > +     op(raw_cpu_ptr(&(pcp)), __VA_ARGS__);                           \
> > +     preempt_enable_notrace();                                       \
> > +})
>
> Is "op" a single instruction? If so then preempt disable / endable would
> not be needed if there is no other instruction created.
>
> But raw_cpu_ptr performs a SHIFT_PERCPU_PTR which performs an addition.
> So you need the disabling of preemption to protect the add.
>
> Is there a way on RISC V to embedd the pointer arithmetic in the "AMO"
> instruction? Or can you use relative addressing to a register that
> contains the cpu offset. I believe RISC V has a thread pointer?
>
> If you can do this then a lot of preempt_enable/disable points can be
> removed from the core kernel and the instruction may be as scalable as x8=
6
> which can do the per cpu operations with a single instruction.

Yes, thank you. While it=E2=80=99s certainly good to remove preemption
disabling, currently RISC-V=E2=80=99s amoadd.w/d instructions can take the
address of a variable rather than a register.

I previously submitted an attempt to use gp to store the percpu
offset, and we are also trying to push for an extension that uses a
register to store the percpu offset.
https://lore.kernel.org/all/CAEEQ3w=3DPsM5T+yMrEGdWZ2nm7m7SX3vzscLtWpOPVu1z=
pfm3YQ@mail.gmail.com/
https://lists.riscv.org/g/tech-privileged/topic/risc_v_tech_arch_review/113=
437553?page=3D2

>
> > +
> > +#define _pcp_protect_return(op, pcp, args...)                         =
       \
> > +({                                                                   \
> > +     typeof(pcp) __retval;                                           \
> > +     preempt_disable_notrace();                                      \
> > +     __retval =3D (typeof(pcp))op(raw_cpu_ptr(&(pcp)), ##args);       =
 \
> > +     preempt_enable_notrace();                                       \
> > +     __retval;                                                       \
> > +})
>
> Same here.
>
>

Thanks,
Yunhui

