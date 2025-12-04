Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C66DD20695
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 415F96B0005; Thu,  4 Dec 2025 09:04:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C6A66B0031; Thu,  4 Dec 2025 09:04:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5C26B007B; Thu,  4 Dec 2025 09:04:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 13ADD6B0005
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:04:49 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD2DC1DF330
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:04:48 +0000 (UTC)
X-FDA: 84181959456.25.3276CB2
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id BFA90180019
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:04:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eBwRJkoK;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764857086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m2OHzduwyMHzjPdCjOuqGZ7AEjHDktHniTIyQEKPg1I=;
	b=zp8hAnFAempz8Ci+tM2L/kSQ/OrUcwz7mwfhwPPeE3HZWpQ9lNQ/BqbSbQLIl2eMJNiwXl
	34WC6XCaIVuMFjI3aJMKr0hiYT5yQwxLs6jOd5trXbp/ZAzifzBnkS2+5oIh8fHw9YGGo1
	e3X7vNJrlvkHOc1XUTfcmNewvJe0oRs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eBwRJkoK;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764857086; a=rsa-sha256;
	cv=none;
	b=ES7m0ejV3fhkAfDLO0WhkNg0qUJGiz2MiWb7TsSW35hS/y3j5cP3bD2whU9gy8Xn3IgrUr
	dkAefgRCldDUEIa14D315TOdsRzNMXz+o0+IQqo/dCnytMmls4N2inR3c/XKAkXXKOgjA+
	HCbvaB8JwKo2IAmZaUEo0Eo0ZHVV9lY=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-640aa1445c3so1386798a12.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 06:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764857085; x=1765461885; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m2OHzduwyMHzjPdCjOuqGZ7AEjHDktHniTIyQEKPg1I=;
        b=eBwRJkoKU1LckGgayyz4HVHKasdZMr2dQuajPaJ8m76/+vD+Mtas6PWLaAh9VmA1ls
         hIVgG7BGvO9lkrBhROVXdiun5xtHNDjREPeKr8Eyvk9/0Ct/ftfb6fOun8DjD9CoOO1w
         +aLHwVWVpiklMuo5buzs+3zw3kSjoyn1Xy00YrfX0m3mbVq6yyrNK2AM+PzYDM0CLoE8
         F2l+PjXgW9TO5b4I5REEiUHu8hEGcPmK8AVsgquTuUpt3KMcKtZdeM96YdhV5YFdoMjR
         l8HwP05g0LQphp+7ybUg388dyBicPfCwk72lJP2R6fF8G/xhjBjYnPi3B5FD1YSs8Lru
         Bgmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857085; x=1765461885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m2OHzduwyMHzjPdCjOuqGZ7AEjHDktHniTIyQEKPg1I=;
        b=vYo2LgzPY9QJNFIWY2Ty57bx2AIK6434ppX5lBTw7mWjnzTQDExTAHOsb3SwxE8OO5
         6/iJNbFkndEjFnAf7Z7GWxKPxhGR3F2oWz8bP/5w8Uh4t8kkRZXDQ9PGptNb2H6IyHgo
         HGdyVNwKmE1A+aCLHW/g7vAI6vcVyQ6PCQribL4b7cwncpDU7SeRTsCYljMXv5ra8onP
         oqb5SToXr4GG7XMQF3TRNEExaS3lzTYCDOTJ55/CzcBaJeOWtT3yF7ianTvreczz0bDl
         kEP+AZs9lUe+YJXHMOvZQ/kcmDUPHSTjEl5ejyzIU8/AaT3CPKUP9A+BS8t/mb7+r/Wn
         4UqA==
X-Forwarded-Encrypted: i=1; AJvYcCXqmy956BoO+ydLx6Q0cJ8zoERC9MThp0PQAVSqjadRuv8t/YEzQkayB4hMCX2I+5Xo1tRLryGGfw==@kvack.org
X-Gm-Message-State: AOJu0Ywsiho9Ccejo9g5CNspU5oZ/CkNmRdjMr48mRE0MeT/nasDVAOM
	dvV3iuSr8GXZAhs2qlr8SlMIWB1j3gNuNkyZvTP91cq1vpvZpRdcQ179unmbGn2fixVcG2avUWL
	UJy1CpCfSkYZc0ryIL44KxGp5DR+nacAT+t1+C6xJWg==
X-Gm-Gg: ASbGncsvvf2tJrLCcX1XCGMKMTfeFONQa7qrizex6l/fNzqyxEXJrp4tbmCyWzDFdPq
	R1XbUACMd75Rbta03U3LUw/qUrrtV4i9IEaS00MrgIhlz3TsAb8kTuyMj7+2jxi67LdFuRV/b7+
	cCubqWj6g25ljdRJkREko0vY5oqtWO+tbpMCxxlghQTBPiOS2U71xd5WOAcpn5XQlgxeQMe8gUf
	Pm1I0Pn1vjDxjUxLULXqSRDYniqwj0FQ1aAD7jnVOIBdCkCVLQRHbSCJLHlF3oFveoaQk6KS9oo
	yLA=
X-Google-Smtp-Source: AGHT+IG94OdQHr54OMV2qpIIIK7h0Ej6bTJOSF1H34v/pHfaqEE+8uq2G/bzw3XIm8zT8Psu5fNEtKDd/Wpths6hKlI=
X-Received: by 2002:a05:6402:5211:b0:640:74f5:d9f6 with SMTP id
 4fb4d7f45d1cf-6479c49b846mr4833830a12.25.1764857084611; Thu, 04 Dec 2025
 06:04:44 -0800 (PST)
MIME-Version: 1.0
References: <20251128173257.969322-1-usamaarif642@gmail.com>
 <20251128173257.969322-3-usamaarif642@gmail.com> <aSwFwMVyFcPlOR10@kernel.org>
In-Reply-To: <aSwFwMVyFcPlOR10@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 4 Dec 2025 09:04:08 -0500
X-Gm-Features: AWmQ_blMRM_Y00X2CQLSsrRM9SSTBl5NL6F7ikVTlKBehL835QS_c4zect_25Ak
Message-ID: <CA+CK2bB+OQ-8CDdQfN3UFxUJR62ZjZkFB3dN43LYaXavewk_ng@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm/memblock: only mark/clear KHO scratch memory
 when needed
To: Mike Rapoport <rppt@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
	changyuanl@google.com, graf@amazon.com, leitao@debian.org, thevlad@meta.com, 
	pratyush@kernel.org, dave.hansen@linux.intel.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: BFA90180019
X-Rspamd-Server: rspam11
X-Stat-Signature: 6h3pp1ppas13unfgwbnx8s4npeeonymg
X-HE-Tag: 1764857086-661423
X-HE-Meta: U2FsdGVkX1/CZjQi81tzj0RY+1ON2m4FhMeAFSAPqp5sIuKxfuQ20Ttvs0LiRsTRD2uOaBWMh4a1oFiydLVqnSjTHEO4pU4V3wtYZu3i4OLYCaNVOAHdev1la0gUS3Ssi7CtUUVpRoRUDJ0YxJ8GZtLIN9jf4F+OC28R7hmWCeGvquZnN6v4JOY5e44nBI6G7eFuMFKkUkGlBzVYD7iD8SWgFodh27n4DAv0TCUhsgKTQh5XYQIATpYAxjFKbllRMRXzlhifehMuuCnX88AyLxTZSfgJNJ1fLiiX7MUh7cLlWKfLKPEflsULECeAlLIQ28oXxOOV0N/DR0JPqYwv8rfwFuegVcqraT7HuR55xINVQaIpIf2miz2fxCgVwdFrjYOX2zDxOKpZ760l7Oiw3MEADr1LVviMl2IzlmKhC4wazW358EPveeocrCYMEUZaNSpuS0mpYvi64c9EWE/r+XNzr4YPeT8YBBzTPIzWZI0oF0qYS83AFAkBATrkIAPh+bE51cDxJ2fBjM3H2uhBNbjsARnQbDxMrrbZ3WqYEyfYn9z0enh/GpGAaanlxzsC0kWih327u95IojdZ58SfxJJbRKB47qkyDBrvVvfGHB61mYwYdQW6S5qs94epX+teTCHAvSzBKKQYQxcCtDdHy9VZuN289siVQAN1Lh48UJpqRltJ3RZWrdYojqgVZKasd8+/PjvsUb7ev0wju3lVOi33hyzoF2QGb8KN0vlo5rJiWQDnsruCKTb85xGUTJpbHQ6zeXtP4MIhZ5qW5iLOPoUnaSsjM8vcTMBVUnzeIoZYy9hJZIJLIrWFptwCzGXBj65INQh3hh+PTF5D4Th03TsSM2OgSJVz2wRRguHoeK0o4DDVn5QUltpd9hZY/a/BCsakIfh35dCxLYe6dWKgv+xM96lU/s925BXsJ+sNR4ih6qd4CY0jc5/88PeWTdp+6BQfeoTqYrsyq5fGOaG
 V124O3vk
 8003WTL8RgxaYbL/JIGV9s6wIwssvFHg1ZXC92VC5/jMb7XrOc9eTPKzx3y2Ik4MyMHYsUf3Kc0/AgXanCeIKz+bdD35wvma6PJ5XdYzZqkOjyWF+OQNxt0cRoVXr38mR38s+67hisfS4ANlQRlvk7mjGEf+dfl0hkGu5LoVxICUcZgiE+3AC2K/a5nLniSX7jBHsz75YwaEVMqvXznINlsiQFSg+wPOt1NkLJIaB/ih2BjJTaA2o/FtHax1SkJNeb5ddmYFuqJP1wYpKeGU+W/qJw9K1r9hLfeK4ihjF/XsuVmc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 30, 2025 at 3:52=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Fri, Nov 28, 2025 at 05:29:34PM +0000, Usama Arif wrote:
> > The scratch memory for kexec handover is used to bootstrap the
> > kexec'ed kernel. Only the 1st 1MB is used as scratch, and its a
> > hack to get around limitations with KHO. It is only needed when
> > CONFIG_KEXEC_HANDOVER is enabled and only if it is a KHO boot
> > (both checked by is_kho_boot). Add check to prevent marking a KHO
> > scratch region unless needed.
>
> I'm going to rewrite the changelog and queue this for upstream:
>
> The scratch memory for kexec handover is used to bootstrap the kexec'ed
> kernel and it is only needed when it is a KHO boot, i.e. a kexec boot wit=
h
> handover data passed from the previous kernel.
>
> Currently x86 marks the first megabyte of memory as KHO scratch even for
> non-KHO boots if CONFIG_KEXEC_HANDOVER is enabled.
>
> Add check to prevent marking a KHO scratch regions unless they are actual=
ly
> needed.
>
> > Fixes: a2daf83e10378 ("x86/e820: temporarily enable KHO scratch for mem=
ory below 1M")
> > Reported-by: Vlad Poenaru <thevlad@meta.com>
> > Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> > Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

This patch causes panic with my tests in linux-next.

[    0.000000] Kernel panic - not syncing: Cannot allocate 17280 bytes
for node 0 data
[    0.000000] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted
6.18.0-next-20251203 #2 PREEMPT(undef)
[    0.000000] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS 0.1 11/11/2019
[    0.000000] Call Trace:
[    0.000000]  <TASK>
[    0.000000]  ? dump_stack_lvl+0x4e/0x70
[    0.000000]  ? vpanic+0xcf/0x2b0
[    0.000000]  ? panic+0x66/0x66
[    0.000000]  ? alloc_node_data+0x32/0x90
[    0.000000]  ? numa_register_nodes+0x82/0x100
[    0.000000]  ? numa_init+0x36/0x120
[    0.000000]  ? setup_arch+0x667/0x7f0
[    0.000000]  ? start_kernel+0x58/0x640
[    0.000000]  ? x86_64_start_reservations+0x24/0x30
[    0.000000]  ? x86_64_start_kernel+0xc5/0xd0
[    0.000000]  ? common_startup_64+0x13e/0x148
[    0.000000]  </TASK>
[    0.000000] ---[ end Kernel panic - not syncing: Cannot allocate
17280 bytes for node 0 data ]---
PANIC: early exception 0x0d IP 10:ffffffff89007a13 error 763 cr2
0xffff991090a01000


> > ---
> >  mm/memblock.c | 14 +++++++++-----
> >  1 file changed, 9 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index 8b13d5c28922a..913cf322eb89a 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -20,8 +20,8 @@
> >
> >  #ifdef CONFIG_KEXEC_HANDOVER
> >  #include <linux/libfdt.h>
> > -#include <linux/kexec_handover.h>
> >  #endif /* CONFIG_KEXEC_HANDOVER */
> > +#include <linux/kexec_handover.h>
> >
> >  #include <asm/sections.h>
> >  #include <linux/io.h>
> > @@ -1126,8 +1126,10 @@ int __init_memblock memblock_reserved_mark_noini=
t(phys_addr_t base, phys_addr_t
> >   */
> >  __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t siz=
e)
> >  {
> > -     return memblock_setclr_flag(&memblock.memory, base, size, 1,
> > -                                 MEMBLOCK_KHO_SCRATCH);
> > +     if (is_kho_boot())

Looks like memblock_mark_kho_scratch() is called before is_kho_boot()
is working:

[    0.000000] memblock_mark_kho_scratch: is_kho_boot: 0
[    0.000000] memblock_mark_kho_scratch: is_kho_boot: 0
[    0.000000] memblock_mark_kho_scratch: is_kho_boot: 0
[    0.000000] KHO: kho_populate: is_kho_boot: 1
[    0.000000] memblock_mark_kho_scratch: is_kho_boot: 1
[    0.000000] memblock_clear_kho_scratch: is_kho_boot: 1
...

--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1514,6 +1514,7 @@ void __init kho_populate(phys_addr_t fdt_phys,
u64 fdt_len,
        memblock_set_kho_scratch_only();

        kho_in.fdt_phys =3D fdt_phys;
+       pr_err("%s: is_kho_boot: %d\n", __func__, is_kho_boot());
        kho_in.scratch_phys =3D scratch_phys;
        kho_scratch_cnt =3D scratch_cnt;
        pr_info("found kexec handover data.\n");
diff --git a/mm/memblock.c b/mm/memblock.c
index 87e7495a68c1..f55b5cdba5dd 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1126,6 +1126,7 @@ int __init_memblock
memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t
  */
 __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
 {
+       pr_err("%s: is_kho_boot: %d\n", __func__, is_kho_boot());
        if (is_kho_boot())
                return memblock_setclr_flag(&memblock.memory, base, size, 1=
,
                                            MEMBLOCK_KHO_SCRATCH);
@@ -1142,6 +1143,7 @@ __init int memblock_mark_kho_scratch(phys_addr_t
base, phys_addr_t size)
  */
 __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
 {
+       pr_err("%s: is_kho_boot: %d\n", __func__, is_kho_boot());
        if (is_kho_boot())
                return memblock_setclr_flag(&memblock.memory, base, size, 0=
,
                                            MEMBLOCK_KHO_SCRATCH);

> > +             return memblock_setclr_flag(&memblock.memory, base, size,=
 1,
> > +                                         MEMBLOCK_KHO_SCRATCH);
> > +     return 0;
> >  }
> >
> >  /**
> > @@ -1140,8 +1142,10 @@ __init int memblock_mark_kho_scratch(phys_addr_t=
 base, phys_addr_t size)
> >   */
> >  __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t si=
ze)
> >  {
> > -     return memblock_setclr_flag(&memblock.memory, base, size, 0,
> > -                                 MEMBLOCK_KHO_SCRATCH);
> > +     if (is_kho_boot())
> > +             return memblock_setclr_flag(&memblock.memory, base, size,=
 0,
> > +                                         MEMBLOCK_KHO_SCRATCH);
> > +     return 0;
> >  }
> >
> >  static bool should_skip_region(struct memblock_type *type,
> > --
> > 2.47.3
> >
>
> --
> Sincerely yours,
> Mike.
>

