Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76179F532CC
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 04:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5CB36B0096; Fri, 27 Mar 2026 00:40:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0E176B0099; Fri, 27 Mar 2026 00:40:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FC6C6B009B; Fri, 27 Mar 2026 00:40:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8DEFF6B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:40:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 312B18D701
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:40:02 +0000 (UTC)
X-FDA: 84590590644.23.B7BEB46
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 35E711C0003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:40:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PFHIqCMx;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774586400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ghwAyUKvjCU6TkeN5oOYg5xDcI5aUkLixuks7jzEEo=;
	b=VrBKNzvH6VDypjFdYkA2pFvaKBZ6ZuLZuzuLiuuYQ2J0b1KoV4/nurV1mh1nh4+cNoV0IC
	s2cuucm/l06yUDiSQabRLv3o9VUHEzLmM0jcagFsO8URbs1SMQbfbbooThmWdywlsIuenG
	2jQUCfehBEq0CpBqV6KG7dPyYqRUI1M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774586400; a=rsa-sha256;
	cv=pass;
	b=ubC1Mr/R7KjoK2v2RNM6a0xXqDl2UpdWg7Ipb65YPJC8qY+lPRjiZF6sxXFHkoXnxVO0GJ
	hrWIRvQsKYI2M5AOQHfiKl9jN8EC6D+BXWPeujt0Cw274NJLkBhDqTQtngg1z+aSmLw/vS
	YbdevfNL1/tjLapeLotQp6NbiX+olQY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PFHIqCMx;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-509062d829dso256121cf.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:40:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774586399; cv=none;
        d=google.com; s=arc-20240605;
        b=Ref5TePdwQMvmbs6e+EsRR3eu8QtE6GclzDAjQ7SfQ1NTBJJ12gOEdUnhJAR9XBi5R
         dcQe2SX9PKgHwcE43ywTxKCXBWOBTkLE15ybtLlnXj6Vs9LJZbk82Cq4eZdIHuZrDz4W
         iaWMFyxoEKcDsalIyqE82S4jk+lt6SsWZxkTR+dUqHjDosI1p5P1A+LuJJFjuMy6tTRG
         JlWSiYvfyWGLqRaRlJ3LTRTbWvIaJ9Iy38dseF5jfm6O1Ehgd40QqwMzP4JnnoyGSuHA
         6ze9uFK608gpfGtbK/6o85LH+jRmwOuePHx4JImRQeJXAxb8VYZPF2Y4wfgW+mxp7Ulc
         tf9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8ghwAyUKvjCU6TkeN5oOYg5xDcI5aUkLixuks7jzEEo=;
        fh=b5y1psk2fHRp7scLGWSRrvG3VnwIw9GnPTB8/zdwhN0=;
        b=GLefpWDyo/3Z4nrBARP77UbQaDlgYvjhoyCQlCn1CO6mkaV7Qw1xgULPURrTtuYSXr
         TA1yR+kwnza9L/X+Nn8umtft8O2V/Ii2slKX5sDHiRsEX6zOG8U1vlgO1UbClH3LG97I
         oZjd6dCxluNazJ133bmBOqg/ymZdBtmsfQdWITUsU/5p+m9dJQLLMdpvC++jUXMWkXwI
         nGI4uETrpFx5D3DQWY8d6+nXlla+WZ67IRC5S05BCeF3yQlYKVycTXlOIxfwbT9MLl8c
         cbuWBUzVncE/8k2IPdn3yoYRSZ5W/jn4FaoJbsbSZm1lh/hySjiebuLpicE1VfzFhnyI
         QoGA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774586399; x=1775191199; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ghwAyUKvjCU6TkeN5oOYg5xDcI5aUkLixuks7jzEEo=;
        b=PFHIqCMxOVGea6yvI5o1vaeQgvRyT8sDgvdZMr9MJe+5y/KlqSJREdhUaLJiK3FNlj
         XcUL6GBDUKw1FqFwB7wZrAIag19zQbEllrOuStRYChA6rqBe6RK7YW4VQcxmOrjVjifd
         XwyhIOKMcR9Y/q7GOzQYDnvAR4daCHigVAwnf9UjmxDJ+fFj12mybu3DAwsDVCrkHNHF
         aYClZc6BGJyjHUDzjUVciFnR75LQhqfdGF+Kf+fpB1ZpOiX0Gj1POrOjMZd2rv7SSRXp
         nh0K9Hs8qSs86oUtRvJ6AcC6/WjZOHjqgBx+2cxEJ70cQdSbT/o50cZOhymHN6ZWUY7w
         pqbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774586399; x=1775191199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8ghwAyUKvjCU6TkeN5oOYg5xDcI5aUkLixuks7jzEEo=;
        b=qsZGJDATia/EaudRM+4IhBMpbD01BnDfBYWa+Y5K0btJWgFofcupFPZ5nhhgUPsGUp
         lfax2ddKh5gy5jHKdwrZqQj4WFOmmRhznygFIKr/NcT6yKQqik7VCLjNpmolubxloFNL
         PSjIU8CFQxPiYh/b+gEPNAkZQrjub6H/UnUafD8VYcNSFLFXT9mtuBiD9robmQosZk2I
         mdFTwkh9aavMqNyvi77J9HhBLZ1D7BaWVy+GpuM6ormlQ/jT8vLpgdXZ8YAkQQ6m+G3S
         RN50MIIuasxK/iOV6zmC0nAE1PDrSsXfMH3CdKyGT391iyj/Myt+jRAsg7t6ZnMuukF6
         D18A==
X-Forwarded-Encrypted: i=1; AJvYcCVHdbWKilQUYa6i0U2Ueqxnm/K+aF7aNqzQnsAnriDst9a4OcOEIc36YLtAZ5kwtTBWPbR3yTfV5Q==@kvack.org
X-Gm-Message-State: AOJu0YzF5bmr9cYa4CV//EwpbmlPvlggixhNkVaCAtZXN+OlwOtMlbWr
	do3SOyQqflu7Ss9HH4SwSGR/iSpnVWbzcQQ6PdGGjuALZkNlEsoXcsnzL8kPVVKWrrjRNIiazEb
	5Xs3m90xOgWVpvrR6EFY4LYY8ACTjmx3CjwTNaDsE
X-Gm-Gg: ATEYQzxLmOCJOGH8KN9MYJ0V2cOxB9f8pC660yhMvCicsQrX/qx3b0sBPd3/H9ir4dM
	oKaP1cOM678Y9JaxDJbITG/5DVDhRp9KmEVZhoyCJJf+n7TUYpMLs+3+vAu+wiBsYubTbE95m2k
	Ws+DjaGDBXy87pacPi1sf5Wmr5OKIrUeOyvfQ5fBpLs2yVETf9ZH2CqHReXPgBzL6RiAGwb8p9X
	EY+IAhM8WH7ERS+sktE5xJUhHh19cLyMqzUzOJs7n7gKv7SkMGAtSvG27MvlyJLQPM1CyKdhqjH
	HZazcA==
X-Received: by 2002:a05:622a:2449:b0:50b:8d3c:5bd7 with SMTP id
 d75a77b69052e-50ba3262ademr6392921cf.9.1774586398666; Thu, 26 Mar 2026
 21:39:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260326140554.191996-1-hao.ge@linux.dev> <CAJuCfpG3w0-m_BAhvRj0Mo2cCeWmD3UaEMa=gd=tvT7hrL=mqA@mail.gmail.com>
In-Reply-To: <CAJuCfpG3w0-m_BAhvRj0Mo2cCeWmD3UaEMa=gd=tvT7hrL=mqA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 26 Mar 2026 21:39:47 -0700
X-Gm-Features: AQROBzCDWTwLtDrssNqFECp0kzirhNT08t8WfqZAn6fGEv15nemLRJ5y2AWFEw4
Message-ID: <CAJuCfpF+6zKxWdKxd3jFYPzYmVWh54gCibLy9hBX0YyLYeSRaA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/alloc_tag: clear codetag for pages allocated before
 page_ext initialization
To: Hao Ge <hao.ge@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 35E711C0003
X-Stat-Signature: cfggaxyeus4hob7ufznhdmu479eereqt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774586400-383303
X-HE-Meta: U2FsdGVkX18YgER+ogw8LDn5QcdDJjMWcdI6igzuf6cxSuzeG2430R+v1BoI2kro5WNASdgTVOOkTK1zMebrQ/RRshpScxRWoM/Wh2ZAsDY3S21bQ2/5NOxj/DCZ/knKssdTkw4uaNkN/ExZDq6Q0C5gorKxVDyYkFKXT3GUTDWNdc1P8bk9jZPPn+jQkiqOArxV7fO2q8XH0hc8JC5jIVkzT61+DyB5Ea/Qo0a9epZE6pvymxEVlH/+FPbA/D0haY2bFdy/ebwzV8EWsOO3H7SOG3yu2abO8xaLiEFMfNC0x3ET5S5o2p0zFoUrp/35OlF0q/+s898UqeMFZswAfuXZVLmX0ugGPqVeAhi7MiAXkEdxQm/NYtHc23js/PI4fb8UaBWyXYYEcyuG3w7TU/ucH/B3lBjl/4olrIpKDWAzyg2WKh2V+t/lSHoD6LWV2Ls9Z/HndxDbQKPQXUNv2R+pS7NWWgRHEPBuMp2bCgDWB6nAVhnLRNOa8Ywk51bJZih4A0DBk4jEV8LAIE49Dx19teZTrqBhFhgvDArG9ajsOqGgmsPT5lc2MIFjXLIWafxW/hzdUsLt+10Lm4bfZLUq0XkmCnKdCyAY8B564qdN1RGc14vQ+BWX7+zKT4K0cbCTnu+pwbrOcNze/gm+7JO9QBc/YdYUrSl+d3tgVskbGCouuB9IZ2DsZWYbIBQpo8dfYBQiTPtAuL9X+Ly4EPkGTz5/jzXYKxlfMxA3OJg5Nu3JEsE7xPXT5K2+0dFsR96vC8tusrn+7TUrVbfeSL3bbwTAANGl56sc/XGTgW0HdmXWtuC6isgJ9zHUV8ASUgSSxIaohaeSVNXbLh2kQT5pXufoVb1Q9sFyrgqdGe9CmQvQLcD7yw8WYGOLTiFSMyLY9jtJ2E3EWt/H6TCiW+7DGY01XYylhSAV8vAwtjn6QASzSb1z6eVVCKKMuK3M5rNvnXDJid15eXWEd5d
 I6EIMpGP
 lnfHvTh6/6z+goIfwko+b1Cz4Z6vCRTi4hw0AslkhWusyTC7VSdYROW8wGsSbbHIfqj0J35+GcmV8Q1SqL7llfLLmDZJsUDP6++7Qctiny5ivcliIO7qvTQ7MYU5b70A0FPyF3Z2FApvxjr8gI2Mhvk2Lw8tA7LvjQLMGj7pLw+H3MbEggQGeCi+p/wkeDsuBGT91pgegk8815T/N2UPjLH9JCQpglYPhAXs/KWZlaa0QhOYQBLtZWId1aLRp3CBuB9VeJTBJuYf40iyT/9BD6ISFprKacFKver8uFZn2ZIqql+XpP2U39Dcb2ITdAzDcI8KB/g0/yyi21KOaV06tuw4e3nrdFdD85WiTb8xPiJ5L0qEv8m1cgtk9OTRvnFeVi41Bs2WxZ7prtKK0yL0te0bDHKYtRuf9jgd2/1y3EvCExnbF2exIxL5K1rRQMTNG4a0j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 9:32=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Mar 26, 2026 at 7:07=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
> >
> > Due to initialization ordering, page_ext is allocated and initialized
> > relatively late during boot. Some pages have already been allocated
> > and freed before page_ext becomes available, leaving their codetag
> > uninitialized.
> >
> > A clear example is in init_section_page_ext(): alloc_page_ext() calls
> > kmemleak_alloc(). If the slab cache has no free objects, it falls back
> > to the buddy allocator to allocate memory. However, at this point page_=
ext
> > is not yet fully initialized, so these newly allocated pages have no
> > codetag set. These pages may later be reclaimed by KASAN, which causes
> > the warning to trigger when they are freed because their codetag ref is
> > still empty.
> >
> > Use a global array to track pages allocated before page_ext is fully
> > initialized. The array size is fixed at 8192 entries, and will emit
> > a warning if this limit is exceeded. When page_ext initialization
> > completes, set their codetag to empty to avoid warnings when they
> > are freed later.
> >
> > The following warning is observed when this issue occurs:
> > [    9.582133] ------------[ cut here ]------------
> > [    9.582137] alloc_tag was not set
> > [    9.582139] WARNING: ./include/linux/alloc_tag.h:164 at __pgalloc_ta=
g_sub+0x40f/0x550, CPU#5: systemd/1
> > [    9.582190] CPU: 5 UID: 0 PID: 1 Comm: systemd Not tainted 7.0.0-rc4=
 #1 PREEMPT(lazy)
> > [    9.582192] Hardware name: Red Hat KVM, BIOS rel-1.16.3-0-ga6ed6b701=
f0a-prebuilt.qemu.org 04/01/2014
> > [    9.582194] RIP: 0010:__pgalloc_tag_sub+0x40f/0x550
> > [    9.582196] Code: 00 00 4c 29 e5 48 8b 05 1f 88 56 05 48 8d 4c ad 00=
 48 8d 2c c8 e9 87 fd ff ff 0f 0b 0f 0b e9 f3 fe ff ff 48 8d 3d 61 2f ed 03=
 <67> 48 0f b9 3a e9 b3 fd ff ff 0f 0b eb e4 e8 5e cd 14 02 4c 89 c7
> > [    9.582197] RSP: 0018:ffffc9000001f940 EFLAGS: 00010246
> > [    9.582200] RAX: dffffc0000000000 RBX: 1ffff92000003f2b RCX: 1ffff11=
0200d806c
> > [    9.582201] RDX: ffff8881006c0360 RSI: 0000000000000004 RDI: fffffff=
f9bc7b460
> > [    9.582202] RBP: 0000000000000000 R08: 0000000000000000 R09: fffffbf=
ff3a62324
> > [    9.582203] R10: ffffffff9d311923 R11: 0000000000000000 R12: ffffea0=
004001b00
> > [    9.582204] R13: 0000000000002000 R14: ffffea0000000000 R15: ffff888=
1006c0360
> > [    9.582206] FS:  00007ffbbcf2d940(0000) GS:ffff888450479000(0000) kn=
lGS:0000000000000000
> > [    9.582208] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [    9.582210] CR2: 000055ee3aa260d0 CR3: 0000000148b67005 CR4: 0000000=
000770ef0
> > [    9.582211] PKRU: 55555554
> > [    9.582212] Call Trace:
> > [    9.582213]  <TASK>
> > [    9.582214]  ? __pfx___pgalloc_tag_sub+0x10/0x10
> > [    9.582216]  ? check_bytes_and_report+0x68/0x140
> > [    9.582219]  __free_frozen_pages+0x2e4/0x1150
> > [    9.582221]  ? __free_slab+0xc2/0x2b0
> > [    9.582224]  qlist_free_all+0x4c/0xf0
> > [    9.582227]  kasan_quarantine_reduce+0x15d/0x180
> > [    9.582229]  __kasan_slab_alloc+0x69/0x90
> > [    9.582232]  kmem_cache_alloc_noprof+0x14a/0x500
> > [    9.582234]  do_getname+0x96/0x310
> > [    9.582237]  do_readlinkat+0x91/0x2f0
> > [    9.582239]  ? __pfx_do_readlinkat+0x10/0x10
> > [    9.582240]  ? get_random_bytes_user+0x1df/0x2c0
> > [    9.582244]  __x64_sys_readlinkat+0x96/0x100
> > [    9.582246]  do_syscall_64+0xce/0x650
> > [    9.582250]  ? __x64_sys_getrandom+0x13a/0x1e0
> > [    9.582252]  ? __pfx___x64_sys_getrandom+0x10/0x10
> > [    9.582254]  ? do_syscall_64+0x114/0x650
> > [    9.582255]  ? ksys_read+0xfc/0x1d0
> > [    9.582258]  ? __pfx_ksys_read+0x10/0x10
> > [    9.582260]  ? do_syscall_64+0x114/0x650
> > [    9.582262]  ? do_syscall_64+0x114/0x650
> > [    9.582264]  ? __pfx_fput_close_sync+0x10/0x10
> > [    9.582266]  ? file_close_fd_locked+0x178/0x2a0
> > [    9.582268]  ? __x64_sys_faccessat2+0x96/0x100
> > [    9.582269]  ? __x64_sys_close+0x7d/0xd0
> > [    9.582271]  ? do_syscall_64+0x114/0x650
> > [    9.582273]  ? do_syscall_64+0x114/0x650
> > [    9.582275]  ? clear_bhb_loop+0x50/0xa0
> > [    9.582277]  ? clear_bhb_loop+0x50/0xa0
> > [    9.582279]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > [    9.582280] RIP: 0033:0x7ffbbda345ee
> > [    9.582282] Code: 0f 1f 40 00 48 8b 15 29 38 0d 00 f7 d8 64 89 02 48=
 c7 c0 ff ff ff ff c3 0f 1f 40 00 f3 0f 1e fa 49 89 ca b8 0b 01 00 00 0f 05=
 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d fa 37 0d 00 f7 d8 64 89 01 48
> > [    9.582284] RSP: 002b:00007ffe2ad8de58 EFLAGS: 00000202 ORIG_RAX: 00=
0000000000010b
> > [    9.582286] RAX: ffffffffffffffda RBX: 000055ee3aa25570 RCX: 00007ff=
bbda345ee
> > [    9.582287] RDX: 000055ee3aa25570 RSI: 00007ffe2ad8dee0 RDI: 0000000=
0ffffff9c
> > [    9.582288] RBP: 0000000000001000 R08: 0000000000000003 R09: 0000000=
000001001
> > [    9.582289] R10: 0000000000001000 R11: 0000000000000202 R12: 0000000=
000000033
> > [    9.582290] R13: 00007ffe2ad8dee0 R14: 00000000ffffff9c R15: 00007ff=
e2ad8deb0
> > [    9.582292]  </TASK>
> > [    9.582293] ---[ end trace 0000000000000000 ]---
> >
> > Fixes: 93d5440ece3c ("alloc_tag: uninline code gated by mem_alloc_profi=
ling_key in page allocator")
> > Suggested-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > ---
> > v2:
> >   - Replace spin_lock_irqsave() with atomic_try_cmpxchg() to avoid pote=
ntial
> >      deadlock in NMI context
> >   - Change EARLY_ALLOC_PFN_MAX from 256 to 8192
> >   - Add pr_warn_once() when the limit is exceeded
> >   - Check ref.ct before clearing to avoid overwriting valid tags
> >   - Use function pointer (alloc_tag_add_early_pfn_ptr) instead of state
> > ---
> >  include/linux/alloc_tag.h   |  2 +
> >  include/linux/pgalloc_tag.h |  2 +-
> >  lib/alloc_tag.c             | 92 +++++++++++++++++++++++++++++++++++++
> >  mm/page_alloc.c             |  7 +++
> >  4 files changed, 102 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> > index d40ac39bfbe8..bf226c2be2ad 100644
> > --- a/include/linux/alloc_tag.h
> > +++ b/include/linux/alloc_tag.h
> > @@ -74,6 +74,8 @@ static inline void set_codetag_empty(union codetag_re=
f *ref)
> >
> >  #ifdef CONFIG_MEM_ALLOC_PROFILING
> >
> > +void alloc_tag_add_early_pfn(unsigned long pfn);
>
> Although this works, the usual approach is have it defined this way in
> the header file:
>
> #if CONFIG_MEM_ALLOC_PROFILING_DEBUG
> void alloc_tag_add_early_pfn(unsigned long pfn);
> #else
> static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
> #endif
>
> > +
> >  #define ALLOC_TAG_SECTION_NAME "alloc_tags"
> >
> >  struct codetag_bytes {
> > diff --git a/include/linux/pgalloc_tag.h b/include/linux/pgalloc_tag.h
> > index 38a82d65e58e..951d33362268 100644
> > --- a/include/linux/pgalloc_tag.h
> > +++ b/include/linux/pgalloc_tag.h
> > @@ -181,7 +181,7 @@ static inline struct alloc_tag *__pgalloc_tag_get(s=
truct page *page)
> >
> >         if (get_page_tag_ref(page, &ref, &handle)) {
> >                 alloc_tag_sub_check(&ref);
> > -               if (ref.ct)
> > +               if (ref.ct && !is_codetag_empty(&ref))
> >                         tag =3D ct_to_alloc_tag(ref.ct);
> >                 put_page_tag_ref(handle);
> >         }
> > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > index 58991ab09d84..7b1812768af9 100644
> > --- a/lib/alloc_tag.c
> > +++ b/lib/alloc_tag.c
> > @@ -6,6 +6,7 @@
> >  #include <linux/kallsyms.h>
> >  #include <linux/module.h>
> >  #include <linux/page_ext.h>
> > +#include <linux/pgalloc_tag.h>
> >  #include <linux/proc_fs.h>
> >  #include <linux/seq_buf.h>
> >  #include <linux/seq_file.h>
> > @@ -26,6 +27,96 @@ static bool mem_profiling_support;
> >
> >  static struct codetag_type *alloc_tag_cttype;
> >
> > +#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> > +
> > +/*
> > + * Track page allocations before page_ext is initialized.
> > + * Some pages are allocated before page_ext becomes available, leaving
> > + * their codetag uninitialized. Track these early PFNs so we can clear
> > + * their codetag refs later to avoid warnings when they are freed.
> > + *
> > + * Early allocations include:
> > + *   - Base allocations independent of CPU count
> > + *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_ini=
t,
> > + *     such as trace ring buffers, scheduler per-cpu data)
> > + *
> > + * For simplicity, we fix the size to 8192.
> > + * If insufficient, a warning will be triggered to alert the user.
> > + */
> > +#define EARLY_ALLOC_PFN_MAX            8192

Forgot to mention that we will need to do something about this limit
using dynamic allocation. I was thinking we could allocate pages
dynamically (with a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid
recursion), linking them via page->lru and then freeing them at the
end of clear_early_alloc_pfn_tag_refs(). That adds more complexity but
solves this limit problem. However all this can be done as a followup
patch.

> > +
> > +static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
> > +static atomic_t early_pfn_count __initdata =3D ATOMIC_INIT(0);
> > +
> > +static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
> > +{
> > +       int old_idx, new_idx;
> > +
> > +       do {
> > +               old_idx =3D atomic_read(&early_pfn_count);
> > +               if (old_idx >=3D EARLY_ALLOC_PFN_MAX) {
> > +                       pr_warn_once("Early page allocations before pag=
e_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
> > +                                     EARLY_ALLOC_PFN_MAX);
> > +                       return;
> > +               }
> > +               new_idx =3D old_idx + 1;
> > +       } while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_id=
x));
> > +
> > +       early_pfns[old_idx] =3D pfn;
> > +}
> > +
> > +static void (*alloc_tag_add_early_pfn_ptr)(unsigned long pfn) __refdat=
a =3D
> > +               __alloc_tag_add_early_pfn;
>
> So, there is a possible race between clear_early_alloc_pfn_tag_refs()
> and __alloc_tag_add_early_pfn(). I think the easiest way to resolve
> this is using RCU. It's easier to show that with the code:
>
> typedef void (*alloc_tag_add_func)(unsigned long pfn);
>
> static alloc_tag_add_func __rcu alloc_tag_add_early_pfn_ptr __refdata =3D
>                 __alloc_tag_add_early_pfn;
>
> void alloc_tag_add_early_pfn(unsigned long pfn)
> {
>         alloc_tag_add_func alloc_tag_add;
>
>         if (static_key_enabled(&mem_profiling_compressed))
>                 return;
>
>         rcu_read_lock();
>         alloc_tag_add =3D rcu_dereference(alloc_tag_add_early_pfn_ptr);
>         if (alloc_tag_add)
>                 alloc_tag_add(pfn);
>         rcu_read_unlock();
> }
>
> static void __init clear_early_alloc_pfn_tag_refs(void)
> {
>         unsigned int i;
>
>         if (static_key_enabled(&mem_profiling_compressed))
>                 return;
>
>        rcu_assign_pointer(alloc_tag_add_early_pfn_ptr, NULL);
>         /* Make sure we are not racing with __alloc_tag_add_early_pfn() *=
/
>         synchronize_rcu();
>         ...
> }
>
> So, clear_early_alloc_pfn_tag_refs() resets
> alloc_tag_add_early_pfn_ptr to NULL before starting its loop and
> alloc_tag_add_early_pfn() calls __alloc_tag_add_early_pfn() in RCU
> read section. This way you know that after synchronize_rcu() nobody is
> or will be executing __alloc_tag_add_early_pfn() anymore.
> synchronize_rcu() can increase boot time but this happens only with
> CONFIG_MEM_ALLOC_PROFILING_DEBUG, so should be acceptable.
>
> > +
> > +void alloc_tag_add_early_pfn(unsigned long pfn)
> > +{
> > +       if (static_key_enabled(&mem_profiling_compressed))
> > +               return;
> > +
> > +       if (alloc_tag_add_early_pfn_ptr)
> > +               alloc_tag_add_early_pfn_ptr(pfn);
> > +}
> > +
> > +static void __init clear_early_alloc_pfn_tag_refs(void)
> > +{
> > +       unsigned int i;
> > +
>
> I included this in the code I suggested above but just as a reminder,
> here we also need:
>
>       if (static_key_enabled(&mem_profiling_compressed))
>                return;
>
> > +       for (i =3D 0; i < atomic_read(&early_pfn_count); i++) {
> > +               unsigned long pfn =3D early_pfns[i];
> > +
> > +               if (pfn_valid(pfn)) {
> > +                       struct page *page =3D pfn_to_page(pfn);
> > +                       union pgtag_ref_handle handle;
> > +                       union codetag_ref ref;
> > +
> > +                       if (get_page_tag_ref(page, &ref, &handle)) {
> > +                               /*
> > +                                * An early-allocated page could be fre=
ed and reallocated
> > +                                * after its page_ext is initialized bu=
t before we clear it.
> > +                                * In that case, it already has a valid=
 tag set.
> > +                                * We should not overwrite that valid t=
ag with CODETAG_EMPTY.
> > +                                */
>
> You don't really solve this race here. See explanation below.
>
> > +                               if (ref.ct) {
> > +                                       put_page_tag_ref(handle);
> > +                                       continue;
> > +                               }
> > +
>
> Between the above "if (ref.ct)" check and below set_codetag_empty() an
> allocation can change the ref.ct value to a valid reference (because
> page_ext already exists) and you will override it with CODETAG_EMPTY.
> I think we have two options:
> 1. Just let that override happen and lose accounting for that racing
> allocation. I think that's preferred option since the race is not
> likely and extra complexity is not worth it IMO.
> 2.  Do clear_page_tag_ref() here but atomically. Something like
> clear_page_tag_ref_if_null() calling update_page_tag_ref_if_null()
> which calls cmpxchg(&ref->ct, NULL, CODETAG_EMPTY).
>
> If you agree with option #1 then please update the comment above
> highlighting this smaller race and that we are ok with it.
>
> > +                               set_codetag_empty(&ref);
> > +                               update_page_tag_ref(handle, &ref);
> > +                               put_page_tag_ref(handle);
> > +                       }
> > +               }
> > +
> > +       }
> > +
> > +       atomic_set(&early_pfn_count, 0);
> > +       alloc_tag_add_early_pfn_ptr =3D NULL;
>
> Once we did that RCU synchronization we don't need the above resets.
> early_pfn_count won't be used anymore and alloc_tag_add_early_pfn_ptr
> is already NULL.
>
> > +}
> > +#else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
> > +inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
> > +static inline void __init clear_early_alloc_pfn_tag_refs(void) {}
> > +#endif
> > +
> >  #ifdef CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU
> >  DEFINE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
> >  EXPORT_SYMBOL(_shared_alloc_tag);
> > @@ -760,6 +851,7 @@ static __init bool need_page_alloc_tagging(void)
> >
> >  static __init void init_page_alloc_tagging(void)
> >  {
> > +       clear_early_alloc_pfn_tag_refs();
> >  }
> >
> >  struct page_ext_operations page_alloc_tagging_ops =3D {
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 2d4b6f1a554e..8f9bda04403b 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1293,6 +1293,13 @@ void __pgalloc_tag_add(struct page *page, struct=
 task_struct *task,
>
> In here let's mark the normal branch as "likely":
> -        if (get_page_tag_ref(page, &ref, &handle)) {
> +        if (likely(get_page_tag_ref(page, &ref, &handle))) {
>
> >                 alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
> >                 update_page_tag_ref(handle, &ref);
> >                 put_page_tag_ref(handle);
> > +       } else {
> > +               /*
> > +                * page_ext is not available yet, record the pfn so we =
can
> > +                * clear the tag ref later when page_ext is initialized=
.
> > +                */
> > +               alloc_tag_add_early_pfn(page_to_pfn(page));
> > +               alloc_tag_set_inaccurate(current->alloc_tag);
>
> Here we should be using task->alloc_tag instead of current->alloc_tag
> but we also need to check that task->alloc_tag !=3D NULL.
>
> >         }
> >  }
> >
> > --
> > 2.25.1
> >

