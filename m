Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D5DFE94625
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 02:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EED56B0089; Mon,  9 Feb 2026 21:10:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6666B008A; Mon,  9 Feb 2026 21:10:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FCE86B008C; Mon,  9 Feb 2026 21:10:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6C6C46B0089
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 21:10:37 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E0258B503
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:10:37 +0000 (UTC)
X-FDA: 84426918114.09.C5FFBA3
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf02.hostedemail.com (Postfix) with ESMTP id 711068000B
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:10:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770689434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/SPIcfU/sQ3sh7t2gzEK0q/BvQ8Xm47/yeK7lBU7OAI=;
	b=XOeSXQL34+YY0pgTP67oX6V75kjtURoP1a1E3TeXUEAO92ZomqZ5N8m+QS6rbqvDiot/JE
	lvRz+bVqt/xXGpB8Ybz7Mw70ESQdTMn2A4i/ptIw6wvoq8BZV1AG0UleCWSpFdGHKHvWxR
	AhMtTzhR6mtF8k7MYE00PzbzhodQ3uc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770689434; a=rsa-sha256;
	cv=none;
	b=2Q8t9s9LHSM5A+O0A3Rn0SDXGUO7Crzb+yRQFkX7zgVNxkveUqAsQn0j6hK4+eRwMFPer9
	2UnbVuyNoFQQ59JNY40qk7nIKE4lCBkpOXvX5H5fg8bG22cVibtHAfa+xnJyLLAsdWhhdg
	VJ2cO7rvyASwF4K9erXEOuMv1DY622o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61A2APF34121295;
	Mon, 9 Feb 2026 20:10:26 -0600
Message-ID: <e5d5a1105d90ee1e7fe7eafaed2ed03bbad0c46b.camel@kernel.crashing.org>
Subject: Re: [PATCH] mm: Fix memblock_free_late() when using deferred struct
 page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Alexander Potapenko <glider@google.com>,
        Marco Elver
	 <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 10 Feb 2026 13:10:25 +1100
In-Reply-To: <bf0231accb89709968efb4d8e1be9970aeb716f8.camel@kernel.crashing.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <aYJBBs17B-SQXFqq@kernel.org>
	 <279931074239b7f3812c4cb3969f887303c8cc26.camel@kernel.crashing.org>
	 <aYL3zxuTLT8N7C8-@kernel.org>
	 <c3769af482913dd7ee9d5302c8afa990255691a5.camel@kernel.crashing.org>
	 <aYXDeN0WGQG8-cxe@kernel.org>
	 <bf0231accb89709968efb4d8e1be9970aeb716f8.camel@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 711068000B
X-Stat-Signature: ohabg6om8dd5gnncatge4he97uj18ije
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770689434-958542
X-HE-Meta: U2FsdGVkX1/hNLh2qJnU1ro6y046IvQcWWoEaQKgzIcA+qCd6PZB4F8TfQWzxq7+1WHpd+/szd/+y9Z0zYO9lC8Umd3xN+s5hX/0wyBXZfT0lepkzMJE+00cEJkaZhxCNLA+7EveK7puCBrdVlmgnV1aYtsMieX2Kag39rj9I47HtL0Ipesz1HtScTEv+I4NAwEUlkY4aAE2qXQCFWyUcrAZ3XPgYEKF1Ab88GKXjX/QYc0DqiwS75xtsYYaMBE3Z8O7+6fMQxfY7AVrWc4qVRrl4LFMWc4DZzPMGQ6pd4Ld2xDQfRplpf5EulrkPkpvSF2pNyiYQJmuQcrzt3c/MdFu+p171/jVWQjhJW+i6QNEBIP+RnswqRN0IWrIcmDfS1c0cp3bbT5IBA6N5Em9/NL5J9rFbdPk+jrsUvuKyLVqqkvzFGxZ+LQMSeKqjYlG43HMIIKZZUZHWEB8k4tkQrdsypMjI/HJ8zx5LLO5dwZjveIZrACKEgDDWk3A26ne70xpj65NXKztKXJMzZ+9BReJWYgbyFnz1P7eQ1VoVa96j3MtZX8x+Kdz0WfnZ4o0CiLFwQhSrErMUkJOsCCcGv+l1QNc/naz2n/0amVX+/WxOuXY/Ryggksn99wLTk6ag2iooCCuwtXmwERbBR1Ix4R1js2149iNGsnwoUUruMxWSGQvgdyqwrIAi6GEyRqfDHXWzjTvs/hxWfQ/rJwBE6KTW1/ahbvivwhY8LkRerXeu+hLtjDBeLJEN8a78ajSkGgEUt05bxfYu1SQ3+a4MjqMUe5BRQ9mZAAOZro5tdjt9XM7bQYVyITpVElhXsDjyG0hR57YfTIkJmGs4b+djez0UnbK2pJnlQQ+P7oVAz8HRODC7ZwjeLDKQIYlPdRA617GUqwjkYr8WbJdN91KhCiUkDHlJNYSUgm0DN2A/OKp1rfaFM759seT7lIun7aNqoC7mJ2Ma7Fez/CAz+H
 M0kHdSgh
 QUTfOxAmLdIiZfU1nc5vJeTelP7a7+Yg5WnwoI3UpUwwUVzFQV80qQjr6WNSs85rRFI/I8IrU+LunsgP3Ka36GB/XWAzZQ+JB2npBtaTJORIZO0E1sQaHY6eZQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-02-10 at 12:04 +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2026-02-06 at 12:33 +0200, Mike Rapoport wrote:
> >=20
> > So it essentially becomes "oneliner" :)
> >=20
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index e76255e4ff36..6e984bcdf6cd 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -1770,10 +1770,8 @@ void __init memblock_free_late(phys_addr_t
> > base, phys_addr_t size)
> > =C2=A0	cursor =3D PFN_UP(base);
> > =C2=A0	end =3D PFN_DOWN(base + size);
> > =C2=A0
> > -	for (; cursor < end; cursor++) {
> > -		memblock_free_pages(pfn_to_page(cursor), cursor,
> > 0);
> > -		totalram_pages_inc();
> > -	}
> > +	for (; cursor < end; cursor++)
> > +		free_reserved_page(pfn_to_page(cursor));
> > =C2=A0}
>=20
> Nice and sweet :-)
>=20
> I'll spin that & test it and send a v2. Thanks !

Tadaaa ! Looks like I'll need to dig deeper... Busy with something else
today but I'll get back to this asap.

[    0.076840] BUG: unable to handle page fault for address: ffffce1a005a07=
88
[    0.078226] #PF: supervisor read access in kernel mode
[    0.078226] #PF: error_code(0x0000) - not-present page
[    0.078226] PGD 0 P4D 0=20
[    0.078226] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
[    0.078226] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.12.68-92.=
123.amzn2023.x86_64 #1
[    0.078226] Hardware name: Amazon EC2 t3a.nano/, BIOS 1.0 10/16/2017
[    0.078226] RIP: 0010:__list_del_entry_valid_or_report+0x32/0xb0
[    0.078226] Code: 89 fe 48 85 d2 74 3e 48 85 c9 74 47 48 b8 00 01 00 00 =
00 00 ad de 48 39 c2 74 46 48 b8 22 01 00 00 00 00 ad de 48 39 c1 74 45 <4c=
> 8b 01 49 39 f8 75 4e 4c 8b 4a 08 4d 39 c1 75 56 b8 01 00 00 00
[    0.078226] RSP: 0000:ffffffff9ac03cc0 EFLAGS: 00010006
[    0.078226] RAX: dead000000000122 RBX: fffff56600459c80 RCX: ffffce1a005=
a0788
[    0.078226] RDX: ffffce1a005e3e08 RSI: fffff56600459c88 RDI: fffff566004=
59c88
[    0.078226] RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 00000000000=
00000
[    0.078226] R10: 000000000000001c R11: 0000000000000200 R12: ffff8ca75ba=
cbc80
[    0.078226] R13: 0000000000000000 R14: 0000000000011673 R15: fffff566004=
59cc0
[    0.078226] FS:  0000000000000000(0000) GS:ffff8ca752c00000(0000) knlGS:=
0000000000000000
[    0.078226] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.078226] CR2: ffffce1a005a0788 CR3: 0000000006c34000 CR4: 00000000003=
506f0
[    0.078226] Call Trace:
[    0.078226]  <TASK>
[    0.078226]  __free_one_page+0x170/0x520
[    0.078226]  free_pcppages_bulk+0x151/0x1e0
[    0.078226]  free_unref_page_commit+0x263/0x320
[    0.078226]  free_unref_page+0x2c8/0x5b0
[    0.078226]  ? srso_return_thunk+0x5/0x5f
[    0.078226]  free_reserved_page+0x1c/0x30
[    0.078226]  memblock_free_late+0x6c/0xc0
[    0.078226]  efi_free_boot_services+0x11f/0x2e0
[    0.078226]  __efi_enter_virtual_mode+0x181/0x210
[    0.078226]  efi_enter_virtual_mode+0xcd/0x110
[    0.078226]  start_kernel+0x393/0x500
[    0.078226]  x86_64_start_reservations+0x14/0x30
[    0.078226]  x86_64_start_kernel+0x77/0x80
[    0.078226]  common_startup_64+0x13e/0x141
[    0.078226]  </TASK>
[    0.078226] Modules linked in:
[    0.078226] CR2: ffffce1a005a0788
[    0.078226] ---[ end trace 0000000000000000 ]---
[    0.078226] RIP: 0010:__list_del_entry_valid_or_report+0x32/0xb0
[    0.078226] Code: 89 fe 48 85 d2 74 3e 48 85 c9 74 47 48 b8 00 01 00 00 =
00 00 ad de 48 39 c2 74 46 48 b8 22 01 00 00 00 00 ad de 48 39 c1 74 45 <4c=
> 8b 01 49 39 f8 75 4e 4c 8b 4a 08 4d 39 c1 75 56 b8 01 00 00 00
[    0.078226] RSP: 0000:ffffffff9ac03cc0 EFLAGS: 00010006
[    0.078226] RAX: dead000000000122 RBX: fffff56600459c80 RCX: ffffce1a005=
a0788
[    0.078226] RDX: ffffce1a005e3e08 RSI: fffff56600459c88 RDI: fffff566004=
59c88
[    0.078226] RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 00000000000=
00000
[    0.078226] R10: 000000000000001c R11: 0000000000000200 R12: ffff8ca75ba=
cbc80
[    0.078226] R13: 0000000000000000 R14: 0000000000011673 R15: fffff566004=
59cc0
[    0.078226] FS:  0000000000000000(0000) GS:ffff8ca752c00000(0000) knlGS:=
0000000000000000
[    0.078226] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.078226] CR2: ffffce1a005a0788 CR3: 0000000006c34000 CR4: 00000000003=
506f0
[    0.078226] Kernel panic - not syncing: Fatal exception
[    0.078226] ---[ end Kernel panic - not syncing: Fatal exception ]---


