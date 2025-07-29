Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B22C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 08:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1E4B6B0089; Tue, 29 Jul 2025 04:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCF546B008A; Tue, 29 Jul 2025 04:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE51D6B0093; Tue, 29 Jul 2025 04:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9C5F6B0089
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 04:08:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 546A859476
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:08:16 +0000 (UTC)
X-FDA: 83716574592.23.D02403D
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5E50120002
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:08:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vA3sKpPX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753776494; a=rsa-sha256;
	cv=none;
	b=yNY/N0qM3auHVhC8Zs0kYRSAQL4dq5dDp6gBTg/8wlJ4sKNGx1s2dOqIVRcyNtsenVg7da
	lsMvqVbmAfJ80FmCIIRIjOwdvE+tvXRfrVYI9dBg/28lj0RlPwS65H92aHS2rY/G5RJ8py
	oElow9bOkdA+Svci3pLNWVX+zi+/5Vo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vA3sKpPX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753776494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4D+GIvBwkRTfSk18WRWL6ADC9Bi5jFYdl5q9R36jCus=;
	b=E7yp8ipP8zhX4FI91+NtwhNMiFSqJB5cMe5cW9TNlGNw+kRWGJw14pjto9TX/mcO86Hu1v
	LWaiZD0vFEZ4a6oN6pjaPpezj2ay019sGXNj3HKg1Qo156YIQYxCq9rGPyAoNOGNJfYWzM
	kf7NzPFjz79fK4R5o82yYabwKooqlR4=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6156c3301ccso4653a12.1
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 01:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753776493; x=1754381293; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4D+GIvBwkRTfSk18WRWL6ADC9Bi5jFYdl5q9R36jCus=;
        b=vA3sKpPXzTMmvg51Ron+KMhjIjf4klu01vf2VpWNthNrCy7eCt8krA1FrRcLj96UrA
         5ywQA/5/jJ0WUWYaObGMpeMF5jTfvfulbPAvwaPnuxBBKqI6p6ZEJSoGyZIdEG09+aX2
         mLcfkESFZQbA29UG9Ttjd+jLRp2GmCy9Cot+S4o0uemoCOpMe/6It66Orc2NMfy0JdM0
         Z+DjFUXM2JuxebwWj+TGRlVcfvztd/LBPFY30ymsaSnD5NcS598Wasvk2Tzk32FfcWqP
         Pos+AfUdEZoBxehcUvTN40WiOASbohnwTS/LZ0zPRlmu/drdhRZj0G5zCbM1EU7CsAF8
         d2Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753776493; x=1754381293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4D+GIvBwkRTfSk18WRWL6ADC9Bi5jFYdl5q9R36jCus=;
        b=C480LQsDDeT0DgNu3CQaMF36+V0FtoWFG3ygLsHRExYol0qN+kqvlj3GPYX4TEhc2J
         AbKlDQrIzeSOkm7dBnLT05Munv0zTYv4AgqhYTz+uDn/PXniRtxB27yhSuz25jpqqnSG
         lw+94v02CFW0TcmyVlJItT6uwNFFuksgXw59ZeJrgzBNiBU6XAosS2trQ1zBUTMHYwBa
         +fxFwZ6rcSkq9MPNeRiHsnMC1roE/guJHRzbH2aX68Bc3g9GNeUX90YUZMT/r8ajkth1
         3WNzpifNpGpN2DcSM0TihPdZN0ye/Qw+V6IkFuhVFH1NjQ4341965Pu9oHuc627oiXYy
         KN/w==
X-Forwarded-Encrypted: i=1; AJvYcCVaBczzXZos4Db8xUdB3ngF1kBeVo5CLEJ9vxkA8KQm/F3JDz3p0nS6sRB4JwPM7rtLRGdQsOWx/w==@kvack.org
X-Gm-Message-State: AOJu0YyUzjADNuHQrdp/5/JYEKt0Svqf5Pdde1YELvY1Ks92mmRcZoXG
	+O8ri2pXO2wzk+AjNa6ol0kAe418ROqI6lPxcW5hRodZy0m8sUAfC4qQ9lnG355VaZIZO2sxRLD
	imiTi5XApONs4T1bvxTEv4P+2S8s0C/y23FhPmV15
X-Gm-Gg: ASbGncvxcQRT3MGmxB7BPjCpVXe8uEm5XUN5cIG1NUipQxVvBFh9uLjdnbp2iYUAPll
	pJ4uCTmuy0WgZk1dMwANhCB8PYZe6WrX8JmSCLw7Gq0dR3RCQFVzsfwOGI2R9fsZ+ftI6Atgx4l
	eSJtqiqr2eZ+OY7+KDE9vXm1NeDKzZch3Ejx/zGA8j9fHUO/wezU8ldaLhFbsEfBJIkDpFDNlj2
	Xp+Jn+IIfBU5M9PwIHIn+IcvpVmreoVYm1cQrUT
X-Google-Smtp-Source: AGHT+IGcXvGdAr6TvJhNCZ95eVsXRkJ3K3zE7LGz4EXE22eFx4/bx/BVWxGUSrbt/vmRmWcZ+uRVkIWt7pYofe7iL3s=
X-Received: by 2002:a50:ccdc:0:b0:615:5ae7:a3ae with SMTP id
 4fb4d7f45d1cf-6156a4ce799mr41920a12.1.1753776492388; Tue, 29 Jul 2025
 01:08:12 -0700 (PDT)
MIME-Version: 1.0
References: <68794b5c.a70a0220.693ce.0050.GAE@google.com> <aIfmv-qSxKxWgzur@x1.local>
 <CAJuCfpFjvSQs2SomPpafw=H-z3fOBy_+K3qkdPa8wz_pH_C1pQ@mail.gmail.com>
In-Reply-To: <CAJuCfpFjvSQs2SomPpafw=H-z3fOBy_+K3qkdPa8wz_pH_C1pQ@mail.gmail.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Tue, 29 Jul 2025 01:08:00 -0700
X-Gm-Features: Ac12FXwTYz44HDx6ZFsvx6WVYP8tmyPvMZumxmqvdy7Xwd974aHyc3U4TnXF0DU
Message-ID: <CA+EESO7goQHuAdobDvWMaYGiVw30g1=o_f5UzBceeSbS2n5MtA@mail.gmail.com>
Subject: Re: [syzbot] [mm?] BUG: unable to handle kernel paging request in move_pages
To: Suren Baghdasaryan <surenb@google.com>
Cc: Peter Xu <peterx@redhat.com>, 
	syzbot <syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5E50120002
X-Stat-Signature: xkaqms9b1awbfiz8oxm6xxcgogcwob3h
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753776494-598535
X-HE-Meta: U2FsdGVkX1/lLoZGor5li9KIdaOE+sO1kyJl+T0+RHy4TcUB4aJUTOdBXIE6UCHXBIhoAgAc0mUqAjGCoftx3GKtwVjx6D7/qpCmvsgXx446XQ0d9A0HwdOWe9q7K0U/9fw7di61EUS5CMTY+AiTyvjw/jQnw2DA+6+3jIcMmYkVOkhCMlXOJHRWBhF8Kpx1i9pjwX0pLRYTJe6+ROsY3PubcGKFR4VYw51Lvs58yOA6+oqbfxSvlvG9fFvFPn+y4cW7pyRF8QnkCKFr8xP3FvcGANH/eI433CFL8rILKfZ4EwAdo7xuewppfdbgN17vlXZlNuVbuZs7MHG2rxKvAwQgwJUpzuf0Qc41aYiZc6CyFnZecvgWNcecpjj5s/CQ/aSiIjCe/Z/LTtiFRI9kS4/wVFEhb6NtGlDfoOKoM/6yXWCSy9vdVF3CFlUGMwK+yunMit4ptvbUq9izoPfsR6K4H6AXVbLrd2glXVDGFrBiMTfL5h6w99s/sOJ3+OYLBP5hlk6ggBP3Heb+8sb0ZR3ZlTy9hdvVdf+J0MkYzC5sXBnzkpP86OMB/Z3NOiWcGeU459b8kO/x85YrJJWRfo8E3Y43Rn1PYMZ49ZMkgbwBOMvjttxWWcQU0CJfDBlr6h/3MLvX5DIW1S5dWrBTTcaMGqzF7wNiS5lLD5+e+m28TUAYUlfUfH8GLGrnQptz6sqRuRszm+8uPNQJROCdBaWPcP09k8xyErhwQErT4kk6zjGHq6Y4/0JB7H1PhLIzQBEUXaFhyefUAczvU2wexpA/wXObV350OX3T9ExXC5WEp25tED0GN0sg1y/XpUsHb6Wk8QN+/rM8PMfo2mR9WCpLqgbvpYDXTmeslqIWxofrV57NIu0krzov9eP6wePCOPp3eSJzfeiL6cMVoziF+32QgArO/rsCuEHS/I2SNOocbsp0kBQGFk3QmK1h8UBgdZeyWo0p/5VfCnwyT9T
 27SGDEhF
 J64naWDgypJpnKfo6IgxL++FN3QNVpoUYLWXHR5vWU9hAulXCENAE5Ghz1M6M2QA7Q0FJB6X3ogyXvYr5/pVFb/P1BNvbfRBltvTV5aSNWYqhnmgNFayubbCkssw58jwV3+22wdW9FHJ29iOysarJogctJ/X5XYXpSmmyItb9cN+HV3JTLqMY1oPqRHActfsu7WHJx2d8JTiws5oeBhLkvv8mo25WzE9ju/RhGtq+rSNFlIofXLZ77aDih6SZtJmbNqtfgWXY6/HIwpGtprgR06Nj5s/OW5VB4F22u4/zSNGfD6GgUu7Rc3Kky31QYO40RAjmFv4ylYr5tWaChPdBcycJEA46tSp44Kbiez3DOmQCaBBJXPLt4V8+cuX3hyiyJ1ZjWnFhj1VKrlopBbs1jV1fOE0Z/wGDD46xOn8jNzjvzX1WxMx6DWLQHwk5P/g/Phw5hKKVEDKpAHr1v58EYtcQp+yhrC/FMXjXdjI8Uy7dNzuuO4aoOOU06dE9W0OThgTDlq3AUL8cU4ZO3hDOfZnWryON+MowcASk5DFvAwa1q8AyjtoZ+XwWOP40D0Em17hF6kk25lUVo0SBvLAZJTt2pKRuKFPgRQG4lAcnjFBD3p6BN6KtqimZAfL0GAvWGVqQ/OFtFhe+SWN4rMR+L7s/hG/v1cn2tMV9u1pP1YX1BUVYmmuWILzkBfhFadr0PMzQJ3hV8GuKRKDuzyzFoYZj5tnsaZoBZA/C6S1Jzb32T4n7VbED+a1HX/vwleSJgKdSELPByMiZJERJxe/Sjji4jhlr9ynltq+UKLIHn8Db7Nz4qHuclaM73BUrOU2AYKyoKF3cmUoUAfyyYbx6h5j/EO6T8wBZyBDZzo2UvnwAEP4bb+S2OI6V2E6IuUY1AVrTdKrrUsD3DbnJAT9Ao6TG5yN3nRJnNZMjhd1fn6D3pp9K1VDvuOttxAB0RIANLiFSmWq/u1MstGfzga/ia80BqGkk
 gKficLwX
 EI6x8ePnDGU/UgXe0R3Ront9KRWch/5RUlhYy0p4T/jxmT9o/RF6LgED+Hg1a/1/YFXGkkCoKjyzk1fth1NofCK12vItEpRcyzkrCRunFLLLvQqevUvA3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 7:51=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Mon, Jul 28, 2025 at 9:08=E2=80=AFPM Peter Xu <peterx@redhat.com> wrot=
e:
> >
> > Copy Lokesh and Suren.

Thanks Peter!
>
> Thanks! I'll take a closer look tomorrow morning.
>
I think the issue is that we are incorrectly handling src holes in the
THP case. The reproducer is setting 'mode' to
UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it seems like the src address is
indeed untouched at the time MOVE ioctl is invoked and hence likely
has a hole.

When this mode is set, we (correctly) don't fail with -ENOENT, but
then instead of skipping the page, we keep going with THP move, which
involves fetching the folio unconditionally from the src_pmd, which is
expected to have no page mapped there.

Suren, can you please double check if my hypothesis is correct?
> >
> > On Thu, Jul 17, 2025 at 12:13:32PM -0700, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    e8352908bdcd Add linux-next specific files for 202507=
16
> > > git tree:       linux-next
> > > console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D17f813825=
80000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Db7b0e60e1=
7dc5717
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=3Db446dbe2703=
5ef6bd6c2
> > > compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88=
f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1004138=
2580000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D10eb158c5=
80000
> > >
> > > Downloadable assets:
> > > disk image: https://storage.googleapis.com/syzbot-assets/ae8cc81c1781=
/disk-e8352908.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/57aaea991896/vm=
linux-e8352908.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/feb871619b=
d4/bzImage-e8352908.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> > > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> > >
> > > BUG: unable to handle page fault for address: ffffea6000391008
> > > #PF: supervisor read access in kernel mode
> > > #PF: error_code(0x0000) - not-present page
> > > PGD 13fff8067 P4D 13fff8067 PUD 0
> > > Oops: Oops: 0000 [#1] SMP KASAN PTI
> > > CPU: 1 UID: 0 PID: 5860 Comm: syz-executor832 Not tainted 6.16.0-rc6-=
next-20250716-syzkaller #0 PREEMPT(full)
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BI=
OS Google 05/07/2025
> > > RIP: 0010:_compound_head include/linux/page-flags.h:284 [inline]
> > > RIP: 0010:move_pages+0xbe6/0x1430 mm/userfaultfd.c:1824
> > > Code: c1 ec 06 4b 8d 1c 2c 48 83 c3 08 48 89 d8 48 c1 e8 03 48 b9 00 =
00 00 00 00 fc ff df 80 3c 08 00 74 08 48 89 df e8 9a 30 f4 ff <48> 8b 1b 4=
8 89 de 48 83 e6 01 31 ff e8 59 70 8f ff 48 89 d8 48 83
> > > RSP: 0018:ffffc90003f778a8 EFLAGS: 00010246
> > > RAX: 1ffffd4c00072201 RBX: ffffea6000391008 RCX: dffffc0000000000
> > > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > > RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
> > > R10: dffffc0000000000 R11: fffff520007eef00 R12: 0000006000391000
> > > R13: ffffea0000000000 R14: 200018000e4401fd R15: 00002000003ab000
> > > FS:  00007ff35708f6c0(0000) GS:ffff8881258aa000(0000) knlGS:000000000=
0000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: ffffea6000391008 CR3: 0000000074390000 CR4: 00000000003526f0
> > > Call Trace:
> > >  <TASK>
> > >  userfaultfd_move fs/userfaultfd.c:1923 [inline]
> > >  userfaultfd_ioctl+0x2e8b/0x4c80 fs/userfaultfd.c:2046
> > >  vfs_ioctl fs/ioctl.c:51 [inline]
> > >  __do_sys_ioctl fs/ioctl.c:598 [inline]
> > >  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:584
> > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > >  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > RIP: 0033:0x7ff3570d6519
> > > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 51 18 00 00 90 48 89 f8 48 =
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> > > RSP: 002b:00007ff35708f218 EFLAGS: 00000246 ORIG_RAX: 000000000000001=
0
> > > RAX: ffffffffffffffda RBX: 00007ff357160308 RCX: 00007ff3570d6519
> > > RDX: 0000200000000180 RSI: 00000000c028aa05 RDI: 0000000000000003
> > > RBP: 00007ff357160300 R08: 0000000000000000 R09: 0000000000000000
> > > R10: 0000000000000000 R11: 0000000000000246 R12: 00007ff35712d074
> > > R13: 0000200000000180 R14: 0000200000000188 R15: 00002000002b9000
> > >  </TASK>
> > > Modules linked in:
> > > CR2: ffffea6000391008
> > > ---[ end trace 0000000000000000 ]---
> > > RIP: 0010:_compound_head include/linux/page-flags.h:284 [inline]
> > > RIP: 0010:move_pages+0xbe6/0x1430 mm/userfaultfd.c:1824
> > > Code: c1 ec 06 4b 8d 1c 2c 48 83 c3 08 48 89 d8 48 c1 e8 03 48 b9 00 =
00 00 00 00 fc ff df 80 3c 08 00 74 08 48 89 df e8 9a 30 f4 ff <48> 8b 1b 4=
8 89 de 48 83 e6 01 31 ff e8 59 70 8f ff 48 89 d8 48 83
> > > RSP: 0018:ffffc90003f778a8 EFLAGS: 00010246
> > > RAX: 1ffffd4c00072201 RBX: ffffea6000391008 RCX: dffffc0000000000
> > > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > > RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
> > > R10: dffffc0000000000 R11: fffff520007eef00 R12: 0000006000391000
> > > R13: ffffea0000000000 R14: 200018000e4401fd R15: 00002000003ab000
> > > FS:  00007ff35708f6c0(0000) GS:ffff8881258aa000(0000) knlGS:000000000=
0000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: ffffea6000391008 CR3: 0000000074390000 CR4: 00000000003526f0
> > > ----------------
> > > Code disassembly (best guess):
> > >    0: c1 ec 06                shr    $0x6,%esp
> > >    3: 4b 8d 1c 2c             lea    (%r12,%r13,1),%rbx
> > >    7: 48 83 c3 08             add    $0x8,%rbx
> > >    b: 48 89 d8                mov    %rbx,%rax
> > >    e: 48 c1 e8 03             shr    $0x3,%rax
> > >   12: 48 b9 00 00 00 00 00    movabs $0xdffffc0000000000,%rcx
> > >   19: fc ff df
> > >   1c: 80 3c 08 00             cmpb   $0x0,(%rax,%rcx,1)
> > >   20: 74 08                   je     0x2a
> > >   22: 48 89 df                mov    %rbx,%rdi
> > >   25: e8 9a 30 f4 ff          call   0xfff430c4
> > > * 2a: 48 8b 1b                mov    (%rbx),%rbx <-- trapping instruc=
tion
> > >   2d: 48 89 de                mov    %rbx,%rsi
> > >   30: 48 83 e6 01             and    $0x1,%rsi
> > >   34: 31 ff                   xor    %edi,%edi
> > >   36: e8 59 70 8f ff          call   0xff8f7094
> > >   3b: 48 89 d8                mov    %rbx,%rax
> > >   3e: 48                      rex.W
> > >   3f: 83                      .byte 0x83
> > >
> > >
> > > ---
> > > This report is generated by a bot. It may contain errors.
> > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > >
> > > syzbot will keep track of this issue. See:
> > > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > >
> > > If the report is already addressed, let syzbot know by replying with:
> > > #syz fix: exact-commit-title
> > >
> > > If you want syzbot to run the reproducer, reply with:
> > > #syz test: git://repo/address.git branch-or-commit-hash
> > > If you attach or paste a git patch, syzbot will apply it before testi=
ng.
> > >
> > > If you want to overwrite report's subsystems, reply with:
> > > #syz set subsystems: new-subsystem
> > > (See the list of subsystem names on the web dashboard)
> > >
> > > If the report is a duplicate of another one, reply with:
> > > #syz dup: exact-subject-of-another-report
> > >
> > > If you want to undo deduplication, reply with:
> > > #syz undup
> > >
> >
> > --
> > Peter Xu
> >

