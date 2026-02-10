Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0670EA3F09
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 06:17:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C69826B0005; Tue, 10 Feb 2026 01:17:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C17286B0088; Tue, 10 Feb 2026 01:17:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15F46B0089; Tue, 10 Feb 2026 01:17:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0FE6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 01:17:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2AA9D58A19
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 06:17:22 +0000 (UTC)
X-FDA: 84427539924.28.A0EFE1E
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6AC50120009
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 06:17:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770704240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BPL24Vy+0EKks1jEf/6W3kTGZzkJXnFKRHmoabbB3SI=;
	b=k7ejBYc81aVZQDf5lJ6M+rqn7/qOgmmr9A9h5enlPZ2pMzeGsC1Y+rAcp2OtjquRnNKZLb
	zeHTxF/mmg5IbfiDIbN8ZqRnNThrJTmmeiFgER3M7wdhpId3pwLEGOajPT4g4oIPMSQz88
	DGZvjc4Ss/tITCyAYSPUUDI29xPvmFA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770704240; a=rsa-sha256;
	cv=none;
	b=Rd/P2mzAS1ynM57CtX4Wpm1SE1eO7fthe1gYwFgKFWUBFxV38Jvng0toQMg6nlIaTuEKjD
	uXbl6nY0y88bIyszEvnplHV3Jjwiwg0qzUN1BtQYLANz88vrf78rHgFogweUfsmqI2gf+D
	NZ5t6NdzBWj5Keqh0Y9zPqd/gZR/9vk=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61A6H80H4129767;
	Tue, 10 Feb 2026 00:17:09 -0600
Message-ID: <5a44609fe992624573a3ca0a293888bd623e2a06.camel@kernel.crashing.org>
Subject: Re: [PATCH] mm: Fix memblock_free_late() when using deferred struct
 page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Alexander Potapenko <glider@google.com>,
        Marco Elver
	 <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 10 Feb 2026 17:17:08 +1100
In-Reply-To: <e5d5a1105d90ee1e7fe7eafaed2ed03bbad0c46b.camel@kernel.crashing.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <aYJBBs17B-SQXFqq@kernel.org>
	 <279931074239b7f3812c4cb3969f887303c8cc26.camel@kernel.crashing.org>
	 <aYL3zxuTLT8N7C8-@kernel.org>
	 <c3769af482913dd7ee9d5302c8afa990255691a5.camel@kernel.crashing.org>
	 <aYXDeN0WGQG8-cxe@kernel.org>
	 <bf0231accb89709968efb4d8e1be9970aeb716f8.camel@kernel.crashing.org>
	 <e5d5a1105d90ee1e7fe7eafaed2ed03bbad0c46b.camel@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6AC50120009
X-Stat-Signature: a3afnpwme57bni3y4kynukn5j7puypn8
X-Rspam-User: 
X-HE-Tag: 1770704238-114865
X-HE-Meta: U2FsdGVkX18E4yX4MjO1RfSsLcpDjeP5yyaUsXqXvxfWjXRl0bIKYoMqR/u6nCyGWJQsnBOli/6VkhOvCIZma0qvPkQzyFJQQZKv1aJLl7/JWnq9Dp7IglXgEwy7FyR4YBajenFmak+M7yCjDc2BNcke12yWdfwvV88rxnXMS/TXKlQxZwfMsq3H9kl5eTLTPv2eAxqGLTMU+RtuIPVBZKuqm59IW5x07RG8MVRO0l7wwR1woDpttuVWDfZLnyL7812yQeaEubeI9GsfVIe2XMD6A7yFhhNOujUzN7rHafituqLML/9cBbIf7HglEIfKWcV3bevk9eDZlPdp3U5uMj/NVdBCmUfCt1Q6i3fXpRKhAaJ+t9jdc+/ODoaCn7TM03Ru3zPKlv76yik33ffpJWVV0sKeZXvVuWqIkk8qUw6xwn+5i/FW6s5llepNmC4l4ExJS2eqlelQxrewGCLSLm3c6h4L2ucb0juZF+sK6mJWradTF77yCJows9H6+vfd68oy5hDbTo6dIA4Uar+cS5jKo//VDfthZLiYmZ7S3/kRRFoK1sWoBDWGDst7DVgNZefBR1geOhn68kc+YB+sWG9xOhbpA1JX9Ky9SWL7NN5O5JDpEktPWvhTzDsdoVcaT7wVNALUj0FimGFnM9XlKjmLqr19lQpwswxwz6ZXONpdvLNT38VJT4D7TUsdvPYY7MQEhC1T29A9OoQMfQScH2G7sGBoQlMy0p7gbFkZWwnNGZ6LGVe/HLMFqh/kdRlIFc2B6U0iRdPpcqhZzFGMkknrh8vA0xb/B9+I13bgiQLcYnA66+3ivBaB9fFEkptcUccciQ1DJmfnRdXcPRqk27kAJKhP73Gq4t0T+rzXgyLTaxaw20+0IvONlZ0eiaycQKEGUc9/uFu5O+s59zujd0Sk8aVL0ewJu7cop5le7098VA2M9q2u7cj/ZIy7lXQlMUeKh+s411Z+HOkP1nW
 ZQOByvdp
 dSD4evQbG54jtqdfiK/j99o5AhSVz2f1Owsw+kfr2Cp6ws9Mcn/OEH9mtSLpASZ3m5GxTwURl6OWCaLJHVisSw37LOugTKAkPFWS3KBeDjLNxuxUCf52XVP5RVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


So ... that was a backport to 6.12.68 and my original patch is crashing
the same way ! (it was working last week interestingly enough,
something else got backported that gets in the way maybe ?).

I'm going to have to go back to digging :-(

I suspect the pages aren't reserved. I swear this was working :-)

Cheers,
Ben.

[    0.033998] RETBleed: WARNING: Spectre v2 mitigation leaves CPU vulnerab=
le to RETBleed attacks, data leaks possible!
[    0.043386] BUG: unable to handle page fault for address: ffffe49c803073=
88
[    0.043386] #PF: supervisor read access in kernel mode
[    0.043386] #PF: error_code(0x0000) - not-present page
[    0.043386] PGD 1024067 P4D 1024067 PUD 0=20
[    0.043386] Oops: Oops: 0000 [#1] PREEMPT SMP PTI
[    0.043386] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.12.68-92.=
123.amzn2023.x86_64 #1
[    0.043386] Hardware name: Amazon EC2 t3.nano/, BIOS 1.0 10/16/2017
[    0.043386] RIP: 0010:__list_del_entry_valid_or_report+0x32/0xb0
[    0.043386] Code: 89 fe 48 85 d2 74 3e 48 85 c9 74 47 48 b8 00 01 00 00 =
00 00 ad de 48 39 c2 74 46 48 b8 22 01 00 00 00 00 ad de 48 39 c1 74 45 <4c=
> 8b 01 49 39 f8 75 4e 4c 8b 4a 08 4d 39 c1 75 56 b8 01 00 00 00
[    0.043386] RSP: 0000:ffffffffb3c03da0 EFLAGS: 00010006
[    0.043386] RAX: dead000000000122 RBX: fffff44480600300 RCX: ffffe49c803=
07388
[    0.043386] RDX: ffffe49c804e5288 RSI: fffff44480600308 RDI: fffff444806=
00308
[    0.043386] RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 00000000000=
00002
[    0.043386] R10: 0000000000000000 R11: 0000000000000200 R12: ffff8cf21b8=
cbc80
[    0.043386] R13: 0000000000000000 R14: 000000000001800d R15: fffff444806=
00340
[    0.043386] FS:  0000000000000000(0000) GS:ffff8cf21aa00000(0000) knlGS:=
0000000000000000
[    0.043386] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.043386] CR2: ffffe49c80307388 CR3: 0000000006c34001 CR4: 00000000007=
706f0
[    0.043386] PKRU: 55555554
[    0.043386] Call Trace:
[    0.043386]  <TASK>
[    0.043386]  __free_one_page+0x170/0x520
[    0.043386]  free_one_page+0x4c/0x80
[    0.043386]  memblock_free_late+0x72/0xd0
[    0.043386]  efi_free_boot_services+0x11f/0x2e0
[    0.043386]  __efi_enter_virtual_mode+0x181/0x210
[    0.043386]  efi_enter_virtual_mode+0xcd/0x110
[    0.043386]  start_kernel+0x393/0x500
[    0.043386]  x86_64_start_reservations+0x14/0x30
[    0.043386]  x86_64_start_kernel+0x77/0x80
[    0.043386]  common_startup_64+0x13e/0x141
[    0.043386]  </TASK>
[    0.043386] Modules linked in:
[    0.043386] CR2: ffffe49c80307388
[    0.043386] ---[ end trace 0000000000000000 ]---
[    0.043386] RIP: 0010:__list_del_entry_valid_or_report+0x32/0xb0
[    0.043386] Code: 89 fe 48 85 d2 74 3e 48 85 c9 74 47 48 b8 00 01 00 00 =
00 00 ad de 48 39 c2 74 46 48 b8 22 01 00 00 00 00 ad de 48 39 c1 74 45 <4c=
> 8b 01 49 39 f8 75 4e 4c 8b 4a 08 4d 39 c1 75 56 b8 01 00 00 00
[    0.043386] RSP: 0000:ffffffffb3c03da0 EFLAGS: 00010006
[    0.043386] RAX: dead000000000122 RBX: fffff44480600300 RCX: ffffe49c803=
07388
[    0.043386] RDX: ffffe49c804e5288 RSI: fffff44480600308 RDI: fffff444806=
00308
[    0.043386] RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 00000000000=
00002
[    0.043386] R10: 0000000000000000 R11: 0000000000000200 R12: ffff8cf21b8=
cbc80
[    0.043386] R13: 0000000000000000 R14: 000000000001800d R15: fffff444806=
00340
[    0.043386] FS:  0000000000000000(0000) GS:ffff8cf21aa00000(0000) knlGS:=
0000000000000000
[    0.043386] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.043386] CR2: ffffe49c80307388 CR3: 0000000006c34001 CR4: 00000000007=
706f0
[    0.043386] PKRU: 55555554
[    0.043386] Kernel panic - not syncing: Fatal exception
[    0.043386] ---[ end Kernel panic - not syncing: Fatal exception ]---
[    0.033998] RETBleed: WARNING: Spectre v2 mitigation leaves CPU vulnerab=
le to RETBleed attacks, data leaks possible!
[    0.043386] BUG: unable to handle page fault for address: ffffe49c803073=
88
[    0.043386] #PF: supervisor read access in kernel mode
[    0.043386] #PF: error_code(0x0000) - not-present page
[    0.043386] PGD 1024067 P4D 1024067 PUD 0=20
[    0.043386] Oops: Oops: 0000 [#1] PREEMPT SMP PTI
[    0.043386] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.12.68-92.=
123.amzn2023.x86_64 #1
[    0.043386] Hardware name: Amazon EC2 t3.nano/, BIOS 1.0 10/16/2017
[    0.043386] RIP: 0010:__list_del_entry_valid_or_report+0x32/0xb0
[    0.043386] Code: 89 fe 48 85 d2 74 3e 48 85 c9 74 47 48 b8 00 01 00 00 =
00 00 ad de 48 39 c2 74 46 48 b8 22 01 00 00 00 00 ad de 48 39 c1 74 45 <4c=
> 8b 01 49 39 f8 75 4e 4c 8b 4a 08 4d 39 c1 75 56 b8 01 00 00 00
[    0.043386] RSP: 0000:ffffffffb3c03da0 EFLAGS: 00010006
[    0.043386] RAX: dead000000000122 RBX: fffff44480600300 RCX: ffffe49c803=
07388
[    0.043386] RDX: ffffe49c804e5288 RSI: fffff44480600308 RDI: fffff444806=
00308
[    0.043386] RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 00000000000=
00002
[    0.043386] R10: 0000000000000000 R11: 0000000000000200 R12: ffff8cf21b8=
cbc80
[    0.043386] R13: 0000000000000000 R14: 000000000001800d R15: fffff444806=
00340
[    0.043386] FS:  0000000000000000(0000) GS:ffff8cf21aa00000(0000) knlGS:=
0000000000000000
[    0.043386] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.043386] CR2: ffffe49c80307388 CR3: 0000000006c34001 CR4: 00000000007=
706f0
[    0.043386] PKRU: 55555554
[    0.043386] Call Trace:
[    0.043386]  <TASK>
[    0.043386]  __free_one_page+0x170/0x520
[    0.043386]  free_one_page+0x4c/0x80
[    0.043386]  memblock_free_late+0x72/0xd0
[    0.043386]  efi_free_boot_services+0x11f/0x2e0
[    0.043386]  __efi_enter_virtual_mode+0x181/0x210
[    0.043386]  efi_enter_virtual_mode+0xcd/0x110
[    0.043386]  start_kernel+0x393/0x500
[    0.043386]  x86_64_start_reservations+0x14/0x30
[    0.043386]  x86_64_start_kernel+0x77/0x80
[    0.043386]  common_startup_64+0x13e/0x141
[    0.043386]  </TASK>
[    0.043386] Modules linked in:
[    0.043386] CR2: ffffe49c80307388
[    0.043386] ---[ end trace 0000000000000000 ]---
[    0.043386] RIP: 0010:__list_del_entry_valid_or_report+0x32/0xb0
[    0.043386] Code: 89 fe 48 85 d2 74 3e 48 85 c9 74 47 48 b8 00 01 00 00 =
00 00 ad de 48 39 c2 74 46 48 b8 22 01 00 00 00 00 ad de 48 39 c1 74 45 <4c=
> 8b 01 49 39 f8 75 4e 4c 8b 4a 08 4d 39 c1 75 56 b8 01 00 00 00
[    0.043386] RSP: 0000:ffffffffb3c03da0 EFLAGS: 00010006
[    0.043386] RAX: dead000000000122 RBX: fffff44480600300 RCX: ffffe49c803=
07388
[    0.043386] RDX: ffffe49c804e5288 RSI: fffff44480600308 RDI: fffff444806=
00308
[    0.043386] RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 00000000000=
00002
[    0.043386] R10: 0000000000000000 R11: 0000000000000200 R12: ffff8cf21b8=
cbc80
[    0.043386] R13: 0000000000000000 R14: 000000000001800d R15: fffff444806=
00340
[    0.043386] FS:  0000000000000000(0000) GS:ffff8cf21aa00000(0000) knlGS:=
0000000000000000
[    0.043386] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.043386] CR2: ffffe49c80307388 CR3: 0000000006c34001 CR4: 00000000007=
706f0
[    0.043386] PKRU: 55555554
[    0.043386] Kernel panic - not syncing: Fatal exception
[    0.043386] ---[ end Kernel panic - not syncing: Fatal exception ]---


On Tue, 2026-02-10 at 13:10 +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2026-02-10 at 12:04 +1100, Benjamin Herrenschmidt wrote:
> > On Fri, 2026-02-06 at 12:33 +0200, Mike Rapoport wrote:
> > >=20
> > > So it essentially becomes "oneliner" :)
> > >=20
> > > diff --git a/mm/memblock.c b/mm/memblock.c
> > > index e76255e4ff36..6e984bcdf6cd 100644
> > > --- a/mm/memblock.c
> > > +++ b/mm/memblock.c
> > > @@ -1770,10 +1770,8 @@ void __init memblock_free_late(phys_addr_t
> > > base, phys_addr_t size)
> > > =C2=A0	cursor =3D PFN_UP(base);
> > > =C2=A0	end =3D PFN_DOWN(base + size);
> > > =C2=A0
> > > -	for (; cursor < end; cursor++) {
> > > -		memblock_free_pages(pfn_to_page(cursor), cursor,
> > > 0);
> > > -		totalram_pages_inc();
> > > -	}
> > > +	for (; cursor < end; cursor++)
> > > +		free_reserved_page(pfn_to_page(cursor));
> > > =C2=A0}
> >=20
> > Nice and sweet :-)
> >=20
> > I'll spin that & test it and send a v2. Thanks !
>=20
> Tadaaa ! Looks like I'll need to dig deeper... Busy with something
> else
> today but I'll get back to this asap.
>=20
> [=C2=A0=C2=A0=C2=A0 0.076840] BUG: unable to handle page fault for addres=
s:
> ffffce1a005a0788
> [=C2=A0=C2=A0=C2=A0 0.078226] #PF: supervisor read access in kernel mode
> [=C2=A0=C2=A0=C2=A0 0.078226] #PF: error_code(0x0000) - not-present page
> [=C2=A0=C2=A0=C2=A0 0.078226] PGD 0 P4D 0=20
> [=C2=A0=C2=A0=C2=A0 0.078226] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
> [=C2=A0=C2=A0=C2=A0 0.078226] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not ta=
inted
> 6.12.68-92.123.amzn2023.x86_64 #1
> [=C2=A0=C2=A0=C2=A0 0.078226] Hardware name: Amazon EC2 t3a.nano/, BIOS 1=
.0
> 10/16/2017
> [=C2=A0=C2=A0=C2=A0 0.078226] RIP: 0010:__list_del_entry_valid_or_report+=
0x32/0xb0
> [=C2=A0=C2=A0=C2=A0 0.078226] Code: 89 fe 48 85 d2 74 3e 48 85 c9 74 47 4=
8 b8 00 01
> 00 00 00 00 ad de 48 39 c2 74 46 48 b8 22 01 00 00 00 00 ad de 48 39
> c1 74 45 <4c> 8b 01 49 39 f8 75 4e 4c 8b 4a 08 4d 39 c1 75 56 b8 01
> 00 00 00
> [=C2=A0=C2=A0=C2=A0 0.078226] RSP: 0000:ffffffff9ac03cc0 EFLAGS: 00010006
> [=C2=A0=C2=A0=C2=A0 0.078226] RAX: dead000000000122 RBX: fffff56600459c80=
 RCX:
> ffffce1a005a0788
> [=C2=A0=C2=A0=C2=A0 0.078226] RDX: ffffce1a005e3e08 RSI: fffff56600459c88=
 RDI:
> fffff56600459c88
> [=C2=A0=C2=A0=C2=A0 0.078226] RBP: 0000000000000000 R08: ffffffffffffffc0=
 R09:
> 0000000000000000
> [=C2=A0=C2=A0=C2=A0 0.078226] R10: 000000000000001c R11: 0000000000000200=
 R12:
> ffff8ca75bacbc80
> [=C2=A0=C2=A0=C2=A0 0.078226] R13: 0000000000000000 R14: 0000000000011673=
 R15:
> fffff56600459cc0
> [=C2=A0=C2=A0=C2=A0 0.078226] FS:=C2=A0 0000000000000000(0000) GS:ffff8ca=
752c00000(0000)
> knlGS:0000000000000000
> [=C2=A0=C2=A0=C2=A0 0.078226] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000=
00080050033
> [=C2=A0=C2=A0=C2=A0 0.078226] CR2: ffffce1a005a0788 CR3: 0000000006c34000=
 CR4:
> 00000000003506f0
> [=C2=A0=C2=A0=C2=A0 0.078226] Call Trace:
> [=C2=A0=C2=A0=C2=A0 0.078226]=C2=A0 <TASK>
> [=C2=A0=C2=A0=C2=A0 0.078226]=C2=A0 __free_one_page+0x170/0x520
> [=C2=A0=C2=A0=C2=A0 0.078226]=C2=A0 free_pcppages_bulk+0x151/0x1e0
> [=C2=A0=C2=A0=C2=A0 0.078226]=C2=A0 free_unref_page_commit+0x263/0x320
> [=C2=A0=C2=A0=C2=A0 0.078226]=C2=A0 free_unref_page+0x2c8/0x5b0
> [=C2=A0=C2=A0=C2=A0 0.078226]=C2=A0 ? srso_return_thunk+0x5/0x5f
> [=C2=A0=C2=A0=C2=A0 0.078226]=C2=A0 free_reserved_page+0x1c/0x30
> [=C2=A0=C2=A0=C2=A0 0.078226]=C2=A0 memblock_free_late+0x6c/0xc0
> [=C2=A0=C2=A0=C2=A0 0.078226]=C2=A0 efi_free_boot_services+0x11f/0x2e0
> [=C2=A0=C2=A0=C2=A0 0.078226]=C2=A0 __efi_enter_virtual_mode+0x181/0x210
> [=C2=A0=C2=A0=C2=A0 0.078226]=C2=A0 efi_enter_virtual_mode+0xcd/0x110
> [=C2=A0=C2=A0=C2=A0 0.078226]=C2=A0 start_kernel+0x393/0x500
> [=C2=A0=C2=A0=C2=A0 0.078226]=C2=A0 x86_64_start_reservations+0x14/0x30
> [=C2=A0=C2=A0=C2=A0 0.078226]=C2=A0 x86_64_start_kernel+0x77/0x80
> [=C2=A0=C2=A0=C2=A0 0.078226]=C2=A0 common_startup_64+0x13e/0x141
> [=C2=A0=C2=A0=C2=A0 0.078226]=C2=A0 </TASK>
> [=C2=A0=C2=A0=C2=A0 0.078226] Modules linked in:
> [=C2=A0=C2=A0=C2=A0 0.078226] CR2: ffffce1a005a0788
> [=C2=A0=C2=A0=C2=A0 0.078226] ---[ end trace 0000000000000000 ]---
> [=C2=A0=C2=A0=C2=A0 0.078226] RIP: 0010:__list_del_entry_valid_or_report+=
0x32/0xb0
> [=C2=A0=C2=A0=C2=A0 0.078226] Code: 89 fe 48 85 d2 74 3e 48 85 c9 74 47 4=
8 b8 00 01
> 00 00 00 00 ad de 48 39 c2 74 46 48 b8 22 01 00 00 00 00 ad de 48 39
> c1 74 45 <4c> 8b 01 49 39 f8 75 4e 4c 8b 4a 08 4d 39 c1 75 56 b8 01
> 00 00 00
> [=C2=A0=C2=A0=C2=A0 0.078226] RSP: 0000:ffffffff9ac03cc0 EFLAGS: 00010006
> [=C2=A0=C2=A0=C2=A0 0.078226] RAX: dead000000000122 RBX: fffff56600459c80=
 RCX:
> ffffce1a005a0788
> [=C2=A0=C2=A0=C2=A0 0.078226] RDX: ffffce1a005e3e08 RSI: fffff56600459c88=
 RDI:
> fffff56600459c88
> [=C2=A0=C2=A0=C2=A0 0.078226] RBP: 0000000000000000 R08: ffffffffffffffc0=
 R09:
> 0000000000000000
> [=C2=A0=C2=A0=C2=A0 0.078226] R10: 000000000000001c R11: 0000000000000200=
 R12:
> ffff8ca75bacbc80
> [=C2=A0=C2=A0=C2=A0 0.078226] R13: 0000000000000000 R14: 0000000000011673=
 R15:
> fffff56600459cc0
> [=C2=A0=C2=A0=C2=A0 0.078226] FS:=C2=A0 0000000000000000(0000) GS:ffff8ca=
752c00000(0000)
> knlGS:0000000000000000
> [=C2=A0=C2=A0=C2=A0 0.078226] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000=
00080050033
> [=C2=A0=C2=A0=C2=A0 0.078226] CR2: ffffce1a005a0788 CR3: 0000000006c34000=
 CR4:
> 00000000003506f0
> [=C2=A0=C2=A0=C2=A0 0.078226] Kernel panic - not syncing: Fatal exception
> [=C2=A0=C2=A0=C2=A0 0.078226] ---[ end Kernel panic - not syncing: Fatal =
exception
> ]---
>=20


