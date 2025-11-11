Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2DAECCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 16:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150468E0007; Tue, 11 Nov 2025 11:18:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1286A8E0002; Tue, 11 Nov 2025 11:18:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03DF98E0007; Tue, 11 Nov 2025 11:18:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E37EF8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:18:33 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA83859F09
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:18:33 +0000 (UTC)
X-FDA: 84098834106.20.8B0B97C
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id BE8DF2001C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:18:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Aa5TljGi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762877911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZa3zooHjmwGdeVp4+48ce5dKd796p2blxghBtAzxUM=;
	b=XzAs6dBtwb+Kc4B0yS/fySbchiHpr9YICFD6cH3AM2EjnujRwLTza8aQCmKQoS+0dkqSm/
	eqITf5Dxa0KTeV2torjjG8ro2fgYCh1x2YRXu6XURZAwpHFLGw3b+r8oxjkQlzbAr8ynEU
	jukqiyNL2z03jKb82z4/9h2jlMadOyc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762877911; a=rsa-sha256;
	cv=none;
	b=M+z6r3AXAtkYqY9l7+qyc69kYoujMtwRzyqv9ofFpv7kaZgfYAIWZLtke3+WmWlRFs1ZxV
	mSPubYJZUsd6eXYZCnmttPb+DfrcqkC92K55UhALp7HmIzL1qAbDv/Kn8QHmbq28u/V2V4
	LlcKhzI1IB6gK2uNa021OhKwSnAK37I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Aa5TljGi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-64162c04f90so5910433a12.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762877910; x=1763482710; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uZa3zooHjmwGdeVp4+48ce5dKd796p2blxghBtAzxUM=;
        b=Aa5TljGi4ZMXI9n/FTDYp9DK6dUm7jHY/3Qw6aJhdfF+BcJqcJaeu+F5qbDsD6X0tN
         gOghC61bx+cBuZlIIzPB3gX8mPh0/3X/kb9HkMlnBPLR2p0oAXJHblX79XbisCqnDRVF
         d2+vdUOxS/0LW2Lk0TrKO5KXjw3b2iq0LCjiPRU8+TLloORUikoA693lrSBrdWLxvdr5
         ph1T4ZnY6XBk6hHB2uvPdt3FgrX5XC82kpxAuONUbS6Id1vYuCa9uPXJayNbzQMcLN9N
         v0XX6oWrexxNV86emuBVxihqBPVBDiaPeF8wm9ZQLxM+uaboHi1S/ZF0pV4CnvnxyWgs
         DHqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762877910; x=1763482710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uZa3zooHjmwGdeVp4+48ce5dKd796p2blxghBtAzxUM=;
        b=LtQhXPmfPY9fgNVUyfsTFqzfwQyZq2oQFd9vxxBt98lArvlOVBGUw8flIxSzjUvjK7
         LKPwFiPPPhHAnV4QiTBA6jmVgFMX7kvAS1I5P2jkNDMeUz4iMhReYGs3bBgXbx5YcSsD
         1sVq7I6M+zR0RsTWZU9DZe0RdR/W9/94Q2uue5y/43902/IIS5NqPbAVZBnCvG+Y2EG8
         tsAdERJBlG0Ghst6BrV9sKB8icIPZlTyCr8qVn7FcW5FlSrzRiKUvOB47EtFh/kv+YDU
         yio3FWoXeOc1miAhnRzORDfJzOhnjqQ/Er9c0GBZk+YZP6lwTnu/T5YXtXy73dSuFMjA
         eDgw==
X-Forwarded-Encrypted: i=1; AJvYcCVk1Rv3Iw/ILP8GXJ7sZVIjEC4paO49wmO57HjQCrKZriCgXNZ20epK8u7nkIYtJP1NB8Pk3ioydQ==@kvack.org
X-Gm-Message-State: AOJu0YyIcDiyvFKblF8O5eb/xN8xihSgWA4IdGMw6nU+YnmZtwp3B1Co
	7FuVvdEcQrrvtlQXVxBIF7Lh6Nd8HiOX1eD9mcd47IWc/PydyEGtSSZIYRkL8FloBgrAvk7HluW
	LOZ/Rs2OLdYIbsnyWj6N+tynvuONr10U=
X-Gm-Gg: ASbGnctNM3WJ+irl4ED1J0gquNDFKo/qwBInLBuhy/7rMVobi4bAW3GEZQ/InI05Cgu
	Ont00H1xJqXx++p6Sw/Mgl+yn54/ag5aoGyBOlJi5/6VAyJHUmnsUDX4NEfZhsy5SKMFdSE8jdS
	4K349raB2pZJXSSZ/E6OVOp+6k4kw7IzlEqQTfgbxIqHEhU68wIizwGsJLbkFZLaxXZrY91W5iX
	dVTcWZnZ9SFqpR+nJm7YK4I2DYjElhgguNGPDMah0a9qwJxlEjOsD1Ir/COTx4isAkmYl5wNXbQ
	BAwzsSrpPnb4nulePbQl
X-Google-Smtp-Source: AGHT+IGUflb/HrIfwX7os9w4FgoupDHRvKJcM+K+pNSt5ec2cnSHAhxgNhDKHl4asKuAFkHXaTqgfMClUL0oUEmi1ew=
X-Received: by 2002:a05:6402:34d6:b0:62f:8274:d6bd with SMTP id
 4fb4d7f45d1cf-6415dc2bac8mr10438493a12.8.1762877909944; Tue, 11 Nov 2025
 08:18:29 -0800 (PST)
MIME-Version: 1.0
References: <69135040.a70a0220.22f260.013d.GAE@google.com>
In-Reply-To: <69135040.a70a0220.22f260.013d.GAE@google.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 12 Nov 2025 00:17:52 +0800
X-Gm-Features: AWmQ_bl2TBASxhQf6QXwjigZuQ20ctH9V5NouRRx_4-83l4I6XBy-Wo0B5E1vfU
Message-ID: <CAMgjq7B=OizLoqKca3RjeV0h3p0GQ4uen+gDo3=WdAxQ1gfxnw@mail.gmail.com>
Subject: Re: [syzbot] [mm?] WARNING in swap_cache_get_folio
To: syzbot <syzbot+d7bc9ec4a100437aa7a2@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, baohua@kernel.org, 
	bhe@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3us3jit786xg133ausoiupybze8ssf38
X-Rspam-User: 
X-Rspamd-Queue-Id: BE8DF2001C
X-Rspamd-Server: rspam10
X-HE-Tag: 1762877911-969084
X-HE-Meta: U2FsdGVkX1/YmoPNEmLazvUoONCaFqEZ4TlWqgGBHrZmv2X682TAWnSFTXroXnpaYf7Yg1A5BFFwpMXiKrE6JBHp5MYRX0eFJBuCTeG0he2r6ch67mYDAC0f5ektUWiKrIEm8yMN5SPYMoBtdDWWHuKc61Vld5vdc+xq1tmwIqFW44SRgajcNg1XPfxS6RzBdpS+IWALmzkDusVfUDjBug6A3S7PIJ3DB3kXP3BjBLJjbV5SDpu3Q1k6UXlZ6qFKRxEykX96K+lyvQNnxOhpw56tL09jKri4ky8bs1pR2+P9LwhJr/dV48vGPSJnKWKbykd09ClMkwpZwIozLr6WU61ZEvPfdB3bkTAgJyjGcQ5FIdURbFZQSLT9i+Udxa9j0j+gdBOpM+Yx6zYKWQujlOyCziLjvupbMEGpnJoJ8creYUScTWzM04kgp14r7AwRDCz6tVEU8VhqtBHqJNO/w2blKyVjBCBUR8sDovtKs2fPbkhJYBfzT2XRlCW85ugsP6I94JRxppW01oDHGUjVfrfzfBBaV4XPYrigUjAZelxKkv5/HNq9deQCfFZZnphdsWg6Cl5GsZfk4Ehv5vE7L0Bi8dPSNBWtbESkyV102mL8OoIabPBrwWwDFUpZHUZcoMD1fy0kqn83eFJDnHNRNbpq6j6smC3cODFjnKfmkgIYN57sxAdhXSfHi4rw5+ZNM1bZRyqus6zf7xUydPqAwSvMFEMgfp+wZ9FJOq2FzP9YRVMXl0x8INn6H6Tcc3k5DdVhBwPNso9oaG8LlkPJx3F4kR3qh7dNKsj9ztlsNjZYwp9Tv9kTpBM22GjjBrYlQ/Cp7m5sS0uXzuTst7bmFAny3No9KpaJ0sc6bpnrInkmpVo2A/6E3qlTYnVdhLjnbvnZ/F39JdFwURETMlsyeM8uRVLCYEloubKkftq8Voo6upzyINoe65NuSNTxxPfJbNCyryY+G1bfH7sADM3
 VbbtDIcm
 gmxFqcHhhBiMJrOdWy4SC20AQacY2dqn4Nofc20kTojkRjIklDtFgxyaNTgzEtbMBfBvJK8BiiuFqc7wsvM1PrE0fJlpaef5ntRqiOkA7D2wyGxVp33OpIloXhYpd5CC+qREu3VF9I1VM4eDiGDm35fOP89XNRGb0xv7rRduxqN6BrA2GXgT/2aHeMt3fypLK5ORbPoN/dxYiLvmWYEbwFFLNw4cCxOv6OQnyC5lGbtx2cRwAJ2uWF6BlxHKn3jN79ZEmyiI+wu5wlpFbm7x8IoSTyEu6nDrH5ZkBQ4XTFeX5Zip/flMtJXl6Ba7HeLX36cmYVkMbYHZZ+S9/NGEKywjdRnGmDHg/vTKDeWOWwtMw8pRdwbLlLRYMJKQo4IPLwuRapo7IMUNWVss5HxcqZlz1aI34vMtu2NqFn7RHRilu5lJR+TloU3oz/MAc/Hwb19wpjGTsGc3oYQu0uu3uV3w+XcpRZy7vAl+p0EnrXbj/m/WlzoiB71RI573ZyD3+hkHl50vSkec2MsYaCC9rX8snsjpn8ieLqu4EixYgRcoll5z1rGXWHz367N4YtiGH0fm18Ab43W7jIpAGINRTmcGPLFn+Y098sFM//zhVUdy47JgNzEbSQGIo/315cJuVv69beN0LoFLNGHGRuC3dW8ZL9BNKWHY8i0npJK3apj214WbWEWrxvQyC2xXV9YQ+revzJZglrkYc1i2BxdahIpjje34kuZHh8d9KENacnn+l5Dj5VztApJLBvhYzDH/JZ+dZNAJxYEY6FL5uiORD3aIx/4fCyDWYV6ayiXfKbflV05nNqsaXVT6NfwarSu0KR6V7S+FrOuSK0hcu5j4MoxUVYhyrhbqkQ1+iI/H59MIm3TOjQSg2MHI6BF7EagOxq7xeciuRG1PFSwU4NkqSZoIEUFD9VfOKCpRly85iXdl+Un7mSWHoTSdUaKq8+IlqzhEg3Rmv/iA1empWQsr+c6lMtflR
 paNKtXxp
 iO7mo4T+jzXxqBL5FdLLFV2VUOBMdTN7MHG6aBfnGRtnFTm60T3YzXue0zifauR/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 11:33=E2=80=AFPM syzbot
<syzbot+d7bc9ec4a100437aa7a2@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    ab40c92c74c6 Add linux-next specific files for 20251110
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D17f69a5858000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D84a798f69f994=
783
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dd7bc9ec4a100437=
aa7a2
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b797=
6-1~exp1~20250708183702.136), Debian LLD 20.1.8
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/34ed0f0c2fd0/dis=
k-ab40c92c.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/a781fa106d0c/vmlinu=
x-ab40c92c.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/367c75242dc9/b=
zImage-ab40c92c.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+d7bc9ec4a100437aa7a2@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> WARNING: mm/swap.h:87 at __swap_offset_to_cluster mm/swap.h:87 [inline], =
CPU#0: swapoff/15184
> WARNING: mm/swap.h:87 at __swap_entry_to_cluster mm/swap.h:93 [inline], C=
PU#0: swapoff/15184
> WARNING: mm/swap.h:87 at swap_cache_get_folio+0x365/0x530 mm/swap_state.c=
:94, CPU#0: swapoff/15184
> Modules linked in:
> CPU: 0 UID: 0 PID: 15184 Comm: swapoff Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 10/02/2025
> RIP: 0010:__swap_offset_to_cluster mm/swap.h:87 [inline]
> RIP: 0010:__swap_entry_to_cluster mm/swap.h:93 [inline]
> RIP: 0010:swap_cache_get_folio+0x365/0x530 mm/swap_state.c:94
> Code: ff 31 ed e9 2a ff ff ff e8 a8 d5 a2 ff 90 0f 0b 90 e9 3d fd ff ff e=
8 9a d5 a2 ff 90 0f 0b 90 e9 44 fd ff ff e8 8c d5 a2 ff 90 <0f> 0b 90 e9 6b=
 fd ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 3e
> RSP: 0018:ffffc90003237a40 EFLAGS: 00010293
> RAX: ffffffff821e8784 RBX: 00000000000001ff RCX: ffff88802e633d00
> RDX: 0000000000000000 RSI: 0000000000007a12 RDI: 0003ffffffffffff
> RBP: ffffffff99cad4e0 R08: 0000000000000000 R09: ffffffff82139c79
> R10: dffffc0000000000 R11: fffff9400022a327 R12: ffff8880317bf000
> R13: dffffc0000000000 R14: 0000000000007a12 R15: 0003ffffffffffff
> FS:  00007f3bed90fc80(0000) GS:ffff888125a83000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005640123d7005 CR3: 0000000034d9a000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  unuse_pte_range mm/swapfile.c:2282 [inline]

Hmm, I think this might be also related to the soft leaf entry changes
recently, unuse_pte_range calls leafent_from_pte and passes the entry
from it to swap_cache_get_folio. In V2/V1 of softleaf (which is being
tested here) leafent_from_pte returns an invalid entry if the process
exit / unmap raced with swapoff.

The recent swap table series added some sanity checks and triggers a
WARN if the entry is invalid so we are seeing this. Softleaf v3 might
have fixed it.

Just guessing now. I'll also try review the code again in case I
missed anything...

