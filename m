Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5177FCA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 08:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B2C8E0011; Sat, 16 Aug 2025 04:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72838E000F; Sat, 16 Aug 2025 04:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF848E0011; Sat, 16 Aug 2025 04:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 887F28E000F
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:47:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0937D1A0390
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 08:47:43 +0000 (UTC)
X-FDA: 83781992406.07.25C8E44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 023C780009
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 08:47:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bm13s9ge;
	spf=pass (imf02.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755334061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0wlj7grRPx+XgV6lGNuTJmzwNSt1vWGaVjkz3M/E6o=;
	b=Qzfka9qixlacqLgj3qrTucfAsQVa440D7NK/J8fvgN5ZOH98QwBDZxMv5Qo9dQgqldnMZB
	7hlt3AXTY2LfgrJ3GprCWxT+Faqp0owBzOH1rUnJC3s2Bv174Ou78/rRSa9UmFteqsuncN
	6sGdwG+DS88vBr5E/WbV1lWxH9ZCl1s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bm13s9ge;
	spf=pass (imf02.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755334061; a=rsa-sha256;
	cv=none;
	b=GA5be2bxtWZLxaoVQJQhO9gUxd8ejH2DYqGZFY/7fRSP7VVtlCaSue9fqasr98jB2b9S9r
	xqAhV6irWCKLR25e7qXEGJ5PJwmnPq/r4+7RT0/7fVutnBHcE3TiaS1OTgRW9p9yKqplSh
	dNV0379ALuazPbEkwinw4fnSLkEyChw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9403844E78
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 08:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74178C4CEEF
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 08:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755334059;
	bh=HkZlzOA9ZrYvvcD0PeswYGZw66p+bwhTbRZ8Q8hstkU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Bm13s9geUm2bfzSIYEjfG9gtzpkynoYlOiCgHRpkWKhP1Ty+6/P+euavvugmHQJMa
	 ou54bABqCUUEGBdtfzMmoh2Vn1uI3s9GnsViLYUfeSkPB9kUgxHxFP7fZKgIh7lDM3
	 9IdNId715qPg3EoCVnDiT185nNI8acM1lP+4tykUFChZa2FR1px8n3d9yj+VE/T/9y
	 d1yJCozG9kAVHdjmeiCZtYAGIjrhOJkxO6DhjVuilWeEX3OcH5zKuvNxlqeE4utaCp
	 N8iOxgd3NQHcDWJCdoxTk21gCF6dGCHxyU93D/zEj4Ul6XdfbIUFlQnzUwMutqZztv
	 44aWx4ZvhL7xw==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-afcb78c77ebso423627166b.1
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 01:47:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVSMOWI+0GcykbSr+Ygv3m1V1TkWkXKrw78x295SdrXczL7Hd9BbaNlrrH9EjTnUnbhl+yEzH08Ow==@kvack.org
X-Gm-Message-State: AOJu0YxaYWn0eIImGw8t90WWyw9aRWeC7qxpRpbXWNlRlvG7fU+Ks+NO
	lf3eLHGOZ9hLSbLBJ0bOR85FI0OpZLDIGBk7KUPiOBR/Vzzco5AqS4agMn3jy7Pj8C/RWsBLhA9
	FuU64A4AcDMQGpU3UOsatQ6A0oOAjPeo=
X-Google-Smtp-Source: AGHT+IG2/ge+J54lL98agjdmhjJpHeai2wzug4zI7jxa0J4QZRgmZytm10MNWrq4ZzgJrJXkyOPbDR++P4wZcWmTFeY=
X-Received: by 2002:a17:907:1c0d:b0:af2:bb2d:9b1e with SMTP id
 a640c23a62f3a-afcdc1c1295mr429526466b.5.1755334057980; Sat, 16 Aug 2025
 01:47:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250816072149.1952348-1-chenhuacai@loongson.cn> <c324c1fe-7a64-4da1-9641-fb1b9756ba2f@redhat.com>
In-Reply-To: <c324c1fe-7a64-4da1-9641-fb1b9756ba2f@redhat.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 16 Aug 2025 16:47:26 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6Q=6vgWnC1wNHKR11H6ziRagAktXm0Rth2rcwmeTtHDw@mail.gmail.com>
X-Gm-Features: Ac12FXx3M7wFfM1KCeH9c04Ro5iit2qB-qKmwhBwhUsutOoU3OZqPoaF1OAXn0I
Message-ID: <CAAhV-H6Q=6vgWnC1wNHKR11H6ziRagAktXm0Rth2rcwmeTtHDw@mail.gmail.com>
Subject: Re: [PATCH V2] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
To: David Hildenbrand <david@redhat.com>
Cc: Huacai Chen <chenhuacai@loongson.cn>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 023C780009
X-Stat-Signature: oz6a8udc3oy5ssxaae5zbxsxmwcxrr7w
X-Rspam-User: 
X-HE-Tag: 1755334060-617714
X-HE-Meta: U2FsdGVkX1+HSe4Z0afSdBcVyso6vJziXURj3eM/AiiWuhz7zKgTuEEIvvl6sRh+1uObsUzpXzWS4716EPda+J4OoUDvdHpCzv1c8KGrjwhwrJYvErqKEc193mAApoiYnHDqj/0yK6ymooC/cxHvSxwSlq0oM4kHSUW7k55q48oVfKOUVfvzdZyctDdE/5Um+SygstRri1ehqT10mi9arhZBGPedI+Yi7OlVZEiZlCeD3OFjTPOO5L/2ZLYjjdQx8+4qktfet5fHVVwse0qPOYz+PM9AzB9G80iMROvY3WHLXVYCXI41zBXj+B1m+ylYGz+ZA6CqUcEUMxXSpWEYPce5NrEm7OW4LdL4p8fNmvw634dHttSKPpQeCz82cKEZivS/gADWXNHrRnU7vavzW+ZBJ3MPvu5Y1iFP3/k3d5WqniajTL28yvx3E6QQkO3WVL+41l6PZBWby+dowutjGXlsBr9OLeMne2GANlr7b5nRcHOGezbAEBf/QMLQeViTaJ+hyQCoxIEtzakK10w6Jr6QKtBpkh5PL0J4mkGQ+++85cqBwvD/+rzL8McS9wMUqFSG45eZZw+lRS1921F+piYKWWAPbzAJMcLzxagFPTea84RgFKcrYbVGJy5kFNEDQZp6k3zTqbDAm++4QNMoRxojJ3O3YiZQvp4fkaJFmCdRKmmSDQUOOBHcKtGlQMaYTTsBtr0JGOGWcI/VBSXCqKku+cq2rETEsSmKy6lYUXynDvsYg0hfjnMMZ9edE6yU8zE4Bxz2NrJ9wbPI0p5rmo03sJ+NgtSzfe4B20pTiiugMeGicfaSRerDbjtT+hhmFO78yNqekqQWKfs+MXvC8T7bT//5vTssOR2Rj9es5MnT9BHjphe14/5ud2oKOvHANUo1SKcM2QOTkBrnuj19LYqpvxNx9cLjg9Rng2QFZ33lC43kKvOGtN5B5R+uLeiEBbOuU4g5roHcJQiAkMz
 Py0tMwik
 g3Fa9kDVGfubG5g5IUn2IhaYKyuIoVTL9GjcvkD7X4cl+ei5Tquk/o361mqeMZtHQ4bFDBx2WBZJwxR0SYuU5NwsBTOf1fcN80+Dh92gEXo3gtZvi3cYmVshT6tKH1LbLNsTplk2epwgaf4Qx2niGkyJmr/qCDymW15PgBQAkoH/1mYplX+CtgAMl+TSQCzkfojXYYqwd1B0GHXxL8FEpMUYpJGwK4gBKL0+CuSui6z27D1Ls0xr4BfMj5ZCrpi+cG7Do7pMqYlPIqusAg7AC+x1Pr6ABqgxZd22w6MHcFQAxvyy83N8FFSdhnQ3f7Tj9dD7DYprFZHMOs30c6xFnoHNKxmFWNPEHXtTa9UpulKkVApmVJce8+vXieg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, David,

On Sat, Aug 16, 2025 at 3:28=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 16.08.25 09:21, Huacai Chen wrote:
> > After commit 84caf98838a3e5f4bdb34 ("mm: stop storing migration_ops in
> > page->mapping") we get such an error message if CONFIG_ZSMALLOC=3Dm:
> >
> >   WARNING: CPU: 3 PID: 42 at mm/migrate.c:142 isolate_movable_ops_page+=
0xa8/0x1c0
> >   CPU: 3 UID: 0 PID: 42 Comm: kcompactd0 Not tainted 6.16.0-rc5+ #2133 =
PREEMPT
> >   pc 9000000000540bd8 ra 9000000000540b84 tp 9000000100420000 sp 900000=
0100423a60
> >   a0 9000000100193a80 a1 000000000000000c a2 000000000000001b a3 ffffff=
ffffffffff
> >   a4 ffffffffffffffff a5 0000000000000267 a6 0000000000000000 a7 900000=
0100423ae0
> >   t0 00000000000000f1 t1 00000000000000f6 t2 0000000000000000 t3 000000=
0000000001
> >   t4 ffffff00010eb834 t5 0000000000000040 t6 900000010c89d380 t7 900000=
00023fcc70
> >   t8 0000000000000018 u0 0000000000000000 s9 ffffff00010eb800 s0 ffffff=
00010eb800
> >   s1 000000000000000c s2 0000000000043ae0 s3 0000800000000000 s4 900000=
000219cc40
> >   s5 0000000000000000 s6 ffffff00010eb800 s7 0000000000000001 s8 900000=
00025b4000
> >      ra: 9000000000540b84 isolate_movable_ops_page+0x54/0x1c0
> >     ERA: 9000000000540bd8 isolate_movable_ops_page+0xa8/0x1c0
> >    CRMD: 000000b0 (PLV0 -IE -DA +PG DACF=3DCC DACM=3DCC -WE)
> >    PRMD: 00000004 (PPLV0 +PIE -PWE)
> >    EUEN: 00000000 (-FPE -SXE -ASXE -BTE)
> >    ECFG: 00071c1d (LIE=3D0,2-4,10-12 VS=3D7)
> >   ESTAT: 000c0000 [BRK] (IS=3D ECode=3D12 EsubCode=3D0)
> >    PRID: 0014c010 (Loongson-64bit, Loongson-3A5000)
> >   CPU: 3 UID: 0 PID: 42 Comm: kcompactd0 Not tainted 6.16.0-rc5+ #2133 =
PREEMPT
> >   Stack : 90000000021fd000 0000000000000000 9000000000247720 9000000100=
420000
> >           90000001004236a0 90000001004236a8 0000000000000000 9000000100=
4237e8
> >           90000001004237e0 90000001004237e0 9000000100423550 0000000000=
000001
> >           0000000000000001 90000001004236a8 725a84864a19e2d9 9000000002=
3fcc58
> >           9000000100420000 90000000024c6848 9000000002416848 0000000000=
000001
> >           0000000000000000 000000000000000a 0000000007fe0000 ffffff0001=
0eb800
> >           0000000000000000 90000000021fd000 0000000000000000 9000000002=
05cf30
> >           000000000000008e 0000000000000009 ffffff00010eb800 0000000000=
000001
> >           90000000025b4000 0000000000000000 900000000024773c 00007ffff1=
03d748
> >           00000000000000b0 0000000000000004 0000000000000000 0000000000=
071c1d
> >           ...
> >   Call Trace:
> >   [<900000000024773c>] show_stack+0x5c/0x190
> >   [<90000000002415e0>] dump_stack_lvl+0x70/0x9c
> >   [<90000000004abe6c>] isolate_migratepages_block+0x3bc/0x16e0
> >   [<90000000004af408>] compact_zone+0x558/0x1000
> >   [<90000000004b0068>] compact_node+0xa8/0x1e0
> >   [<90000000004b0aa4>] kcompactd+0x394/0x410
> >   [<90000000002b3c98>] kthread+0x128/0x140
> >   [<9000000001779148>] ret_from_kernel_thread+0x28/0xc0
> >   [<9000000000245528>] ret_from_kernel_thread_asm+0x10/0x88
> >
> > The reason is that defined(CONFIG_ZSMALLOC) evaluates to 1 only when
> > CONFIG_ZSMALLOC=3Dy, we should use IS_ENABLED(CONFIG_ZSMALLOC) instead.
> > But when I use IS_ENABLED(CONFIG_ZSMALLOC), page_movable_ops() cannot
> > access zsmalloc_mops because zsmalloc_mops is in a module.
> >
> > To solve this problem, we define a movable_ops[] array in mm/migrate.c,
> > initialise its elements at mm/balloon_compaction.c & mm/zsmalloc.c, and
> > let the page_movable_ops() function return elements from movable_ops[].
> >
> > Fixes: 84caf98838a3e5f ("mm: stop storing migration_ops in page->mappin=
g")
> > Acked-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > ---
> > V2: Use EXPORT_SYMBOL_GPL_FOR_MODULES instead of EXPORT_SYMBOL and fix =
build.
>
> See my review.
>
> Please wait longer for a resend, so we don't have to do this weird
> review dance.
I'm sorry, when I receive Zi Yan's Ack I think there is no big
problems, so I sent V2.

Huacai

>
> --
> Cheers
>
> David / dhildenb
>

