Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9D0C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 17:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99BEC6B0089; Wed, 30 Jul 2025 13:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972006B008A; Wed, 30 Jul 2025 13:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887D26B0092; Wed, 30 Jul 2025 13:09:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7987C6B0089
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:09:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36169B9E04
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 17:09:44 +0000 (UTC)
X-FDA: 83721567888.01.79CA5DA
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5464616000F
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 17:09:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=18iq3Gpb;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753895382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ornz5fkkifiDR+ny9GBtOpxaRpztQtp4fA2guzhOWYY=;
	b=OkgQ0m6gpQzw7smBEWHdtoGerICiyBm8LHY3hUcDnMiL7hqz4VSp5o/TYFFcW3z84UxDpC
	kD3LBo8EjltDAb7OZPqdMz+3oKABAmiApt6EDXhztxBXvmZLttRy7YkqZhmLN/tN7PhNHT
	D2Ybx0NAnhe2ikM9shadhYgD+HBQkwY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753895382; a=rsa-sha256;
	cv=none;
	b=McjKmBV+6A77ul0R7tR0POZBhqss8tOeAs7G9wx8SK71zuLF/cz4DGKTm1uFbY7cWc9J7h
	Gfo1bn3uItMC7SGoq51IkADJ6PLFp0FVkOEa0tWAqqSE+xWk+nMnm0Y2GbcvfrjOMH5iUn
	Iym3XCBS/obdqHHeatQx8bnbv+U5Qto=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=18iq3Gpb;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ab3855fca3so11961cf.1
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 10:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753895381; x=1754500181; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ornz5fkkifiDR+ny9GBtOpxaRpztQtp4fA2guzhOWYY=;
        b=18iq3GpbVFBqJFbzWP/hbiN0xtjgVxBk9sdEG6vC7BKugFs2e42vXj5pxbN6x16/+K
         j2TGVOjRtDntJHj8hzApWD2lA2KxiuLkYGLgEG0N75OLow65ZYITxQZ3DPpCkDXlIGUf
         kxQqDd+wNBa3om7bjsYFeX1szXA4d6nBUxrBpTpB7UVWM7dtpEmbNAH+/IRgohcTYBRX
         EOLb3gXISYtdKO/BNrq+hyFRhtwy3PeZYftiWlausCUOhdn6eT9F2kphSi/be57HX4b9
         gPPeN52rhB7Hr5c0EEDA9zAOYL/s0GKkRlvEcBIm3CvIgmn4gPNbbXGmItHDNSyddoms
         3Vxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753895381; x=1754500181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ornz5fkkifiDR+ny9GBtOpxaRpztQtp4fA2guzhOWYY=;
        b=iCsdNUwVCz60fLe1fO30jyZqyDpDMhoHvdIFo5n2Iaq5goQIbop0ikYvMGyNTN10A7
         aBLEtnTGmP9fRRm3DsXDQvb3qv66tA1lyMu7b2S92+xGNTZYR0H6XiAl724xYCA2PeRT
         s23z1lw7vO96ZIpHYKkA775m8ApHnc6r8kLlpsfGX5OIdHWQVVI++GXEWT1XvG3e4cQF
         aFvoJc42oXsfvI+Z6XLJY8LZEDUYi0Th8UfRxmk0miYHrMjGPQs/KK8AC0P19xFCxcwt
         O9BP4UiRF0H0gHHVrncU1Ff9VRF3p4ywjKm4I0Q+zyexaPJFuhwsiQ491jrVPfrQIXfQ
         0DZg==
X-Forwarded-Encrypted: i=1; AJvYcCUEapHBgKIw6SxMwFvC7Q3DTO6ZJ1uJsojt8LA/z3Be11F7AywhtJFXjU9Scj8BWFkCJrObLi4emQ==@kvack.org
X-Gm-Message-State: AOJu0YztC6DdwIAGj2gGdP6OLyCwMVNy+ur6QuwQrWyFcJNMXbUQxaIi
	58RkjCDs1avOv/Jg7AijQS17KZnRq+3aZqAMXov8MZQwj2JOB7byf9vPlviWn3FnLZypoSLO3mt
	ixD3lfwSWLMBsjPB+XDWffgqE+fD8zSWG+tFqmj2i
X-Gm-Gg: ASbGncuBDcnAPIX4aSahPbSWLaBLdvMl762fP9OfJBliZ4Bw4Kgwoh6RpqsmKG1mLpE
	Ycxsh3ya+VvCQa1Uud847EIqcwztAhVrpRYQzh7OacVIRNIwA38jWtS38qs7YcxzYskJuT6ELnh
	hWyS8k4w/F+P6hUq2bhTTLUuVI2SkxGwhCD70RMtrIa+wr4auIiIy/MrAj3HYyPNrt3cvywGZ0N
	p7t/4/+ddWztdPC3y0WJchl+QxWUfbLPcSb/A==
X-Google-Smtp-Source: AGHT+IHJSGoncxy6snA63ICBiOwoo+mkeZNRxbOighGafxurDE8wizkpCLimPwYtssEQItZCmnQsCPsYpjGYx5A8nV4=
X-Received: by 2002:a05:622a:281:b0:4aa:cba2:2e67 with SMTP id
 d75a77b69052e-4aedf66ab3dmr4744811cf.21.1753895380766; Wed, 30 Jul 2025
 10:09:40 -0700 (PDT)
MIME-Version: 1.0
References: <68794b5c.a70a0220.693ce.0050.GAE@google.com> <aIfmv-qSxKxWgzur@x1.local>
 <CAJuCfpFjvSQs2SomPpafw=H-z3fOBy_+K3qkdPa8wz_pH_C1pQ@mail.gmail.com>
 <CA+EESO7goQHuAdobDvWMaYGiVw30g1=o_f5UzBceeSbS2n5MtA@mail.gmail.com> <CAJuCfpGGpQ4s+z2AAs3YwgHASVUqx4tEi=1BMeqW8_wL_acq_w@mail.gmail.com>
In-Reply-To: <CAJuCfpGGpQ4s+z2AAs3YwgHASVUqx4tEi=1BMeqW8_wL_acq_w@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 30 Jul 2025 10:09:29 -0700
X-Gm-Features: Ac12FXy9U8CDMEZDRh4a79HB_hxWTB9tzdWfnoQgViYYKcrZcwYxF8AOn0Jg8Dk
Message-ID: <CAJuCfpEirT6MS2kGnp0q0Ykke+_0tWu-zrrJmhsOraPqdH0zwA@mail.gmail.com>
Subject: Re: [syzbot] [mm?] BUG: unable to handle kernel paging request in move_pages
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: Peter Xu <peterx@redhat.com>, 
	syzbot <syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5464616000F
X-Stat-Signature: jj9bsf4dxqiojo6ciphqjg46cnpx9da8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753895382-466488
X-HE-Meta: U2FsdGVkX19EsvycstUdgvAZ5vNo9JE4c6EpCikik/4oBF5H1MOJHcBS+mZNSuk5ETUj3PlKRpUsk5DTzv1OlP3hYR1Jo/5H1x3YCEL5WYT//83MozB92TTgzLco9eaWD/MadF5dYbkQbd4IT/U0qxNiFv7h6uanMIOaHvGarXez0BeQG2evU2TZBZUo3gikABgNgWJiHI5Mji35hkuvh8voFKt41SBhdx/DbIYYzy+UtPsdpFfjYfc12BsHuCjzYbqZvyxB2nG/AtSyk4dKDmEoRPDF/kXRKp/NOX09wYxWuxmemwz2eYcKeSD8DvwqgGuP/xDa9t2TR2db28rsxfwyOCGdnh56JhwG2abbw+XGkXHd5asniDIDi+qUenRpQjnBODHT3PzQL49TgzHEO89X6SjtL6FtKbkYkuCu4qI+/LvleJlUPwLIfiKi5XZeuTb0TyqEnWZlsppAI64MLcIe4p1jprsItwePxNWuim8r+EhHK9A3ezeKX/fZ3ivPhMybT3c9PCrw00sCFD7WvF0duXqslhVjdov2ncYTz0EbcgddQUp88AXjEqwr6cu1VsaLyfdwN0YBgIUGQG8S204yRPESaxRnB/CY1qg1oSe9wks03Vz96G+wjSO8/vG7mPARcyW5L5t/GmDPsaI7/aid+329ldEpoaz0Ob3b3OQ1f+h3K2yNyIUo+ozt7Mk13Q+bnHi+APppMvkuAfTpbmj8/NzVnZZbfoJttDbJFlhh6hMgutAJfpWVObWVdl+DFEwsHnXatTK/FSSX49RkqP0Y/bZtTfbS4IXRM7LDcwG3uy3uDW1wA2bxP3r4JqLtliHpaNNABJCHL6771gxOpdxaNOFSvQ4whuafyemH6sjN8Xr+QWnbfgTA6lg/ww2YAf25n4O0rTulPQGSwjNR895ND7blkdkTurW7PbVzBa5RGRvdh7s0YRGvQJqX92huv/abWuu+Ms2IUbr6/dv
 75G8MxiC
 1iwmcL+rBqd5+JiIdrKDBYk804jj2ryMstGnjlcx1ALqlrPFfrCYDHk2j6si9WG2tKUZp/8QTfdtJjVBEdbfpkgj7KDJx49QHfjljPvjdISZeWcckWF/vXWm46LlAIbv+9qk12GvqsY6Zozv41wW1Q9nZUTS3osC6mR+MI3ONdn1kT7C+QX+abcts0b0m0ZMCjvf84OpM6MTjmqO0q0CmZbhE2aR8o9QiGCY708C2ctDME97vez/eVoAJ0dMOC7lrNDdBMXX1/2EfW8N/wIvb3FkiKLl9tPRO2xV3Z+WIixdxiacyGh+Gvywrjg2WnxD0IHP6Z5BCKpxfK/+yCTEb9qna4EpgkBMfJfX50wU8AgRLkkcast2+8BQO7deFcpryXoPxASo2A6ih2H3Mauae5jd2sdt7z1CBCrZr4WhFeVRff5i51XT7FwtWt/RmAXVWMvrMN1e87EGkZICoJMddsaOqQemjyT/SkEyh+Yh7Ub2HA6V6zV6yma38fSCfa7/in39w7sevikzJEHb7LO0oRLjfpmiU0fFn4XKLlJOZu98MhcGW0gdGxUyM3/zlFAScK8GfLBj6BRvgXr+w81zqv8D4AxPDU+6pws+aOMEiymfRi5htCekIfWDMcMgnpkPedI5jImfcAn1Q6qFUMC6rj95PAHm3IlKcvAeqhqiAhKK/WbahuDtJvUgE8Rcz9VczPLL99+YWv2X9nbawAcf8qSkVG/7cBBxaY5Uj1EF2svLNToEHnTQxXZr2LbwbYjiQ2QjKw5mweY9i5wze0vYMT3JE9G6s5bwUlACcQGjM+LETvC84BVvUu3I7+q52hYH6rmWvlrEPz23ZJrPMZ1K2kxgtQZe2WvKMwMtEszqfjnZqQNSd3EaxBNpVL6lEVTtI8Z1rs6y4twBlwGxZRijWhICEoBx8n9W1K369+oJ8UEPEBn5+WSQFEf+yuYkcOQF2doH+f2UJfPQPNPrWEtvjUEpYvvGE
 JPtRlOgc
 toEdKTjOqZvhlAA7LB9VSx1koH22gEees96ENOUZoPgbGVglLfQUBOmzE8Kcys392QSk9X6D4V+Xt/Z7CnvVKN26M2hjO07cWyfbhLCoZh9K/u+OgWKUQIX3DFpIVXLS+v7nni1kFe4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 10:51=E2=80=AFAM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Tue, Jul 29, 2025 at 1:08=E2=80=AFAM Lokesh Gidra <lokeshgidra@google.=
com> wrote:
> >
> > On Mon, Jul 28, 2025 at 7:51=E2=80=AFPM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> > >
> > > On Mon, Jul 28, 2025 at 9:08=E2=80=AFPM Peter Xu <peterx@redhat.com> =
wrote:
> > > >
> > > > Copy Lokesh and Suren.
> >
> > Thanks Peter!
> > >
> > > Thanks! I'll take a closer look tomorrow morning.
> > >
> > I think the issue is that we are incorrectly handling src holes in the
> > THP case. The reproducer is setting 'mode' to
> > UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it seems like the src address is
> > indeed untouched at the time MOVE ioctl is invoked and hence likely
> > has a hole.
> >
> > When this mode is set, we (correctly) don't fail with -ENOENT, but
> > then instead of skipping the page, we keep going with THP move, which
> > involves fetching the folio unconditionally from the src_pmd, which is
> > expected to have no page mapped there.
> >
> > Suren, can you please double check if my hypothesis is correct?
>
> I think in the case of a hole the prior call to pmd_trans_huge_lock()
> would return NULL and we would not handle it as THP move.
> I was able to reproduce the crash, though the call stack is a bit
> different. Will try to figure it out.

Ok, pmd_trans_huge_lock() actually confused non-present PMD with a
swap/migration entry and does not return NULL in such cases. I posted
a fix here: https://lore.kernel.org/all/20250730170733.3829267-1-surenb@goo=
gle.com/

>
> > > >
> > > > On Thu, Jul 17, 2025 at 12:13:32PM -0700, syzbot wrote:
> > > > > Hello,
> > > > >
> > > > > syzbot found the following issue on:
> > > > >
> > > > > HEAD commit:    e8352908bdcd Add linux-next specific files for 20=
250716
> > > > > git tree:       linux-next
> > > > > console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D17f81=
382580000
> > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Db7b0e=
60e17dc5717
> > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=3Db446dbe=
27035ef6bd6c2
> > > > > compiler:       Debian clang version 20.1.7 (++20250616065708+614=
6a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D100=
41382580000
> > > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D10eb1=
58c580000
> > > > >
> > > > > Downloadable assets:
> > > > > disk image: https://storage.googleapis.com/syzbot-assets/ae8cc81c=
1781/disk-e8352908.raw.xz
> > > > > vmlinux: https://storage.googleapis.com/syzbot-assets/57aaea99189=
6/vmlinux-e8352908.xz
> > > > > kernel image: https://storage.googleapis.com/syzbot-assets/feb871=
619bd4/bzImage-e8352908.xz
> > > > >
> > > > > IMPORTANT: if you fix the issue, please add the following tag to =
the commit:
> > > > > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.co=
m
> > > > >
> > > > > BUG: unable to handle page fault for address: ffffea6000391008
> > > > > #PF: supervisor read access in kernel mode
> > > > > #PF: error_code(0x0000) - not-present page
> > > > > PGD 13fff8067 P4D 13fff8067 PUD 0
> > > > > Oops: Oops: 0000 [#1] SMP KASAN PTI
> > > > > CPU: 1 UID: 0 PID: 5860 Comm: syz-executor832 Not tainted 6.16.0-=
rc6-next-20250716-syzkaller #0 PREEMPT(full)
> > > > > Hardware name: Google Google Compute Engine/Google Compute Engine=
, BIOS Google 05/07/2025
> > > > > RIP: 0010:_compound_head include/linux/page-flags.h:284 [inline]
> > > > > RIP: 0010:move_pages+0xbe6/0x1430 mm/userfaultfd.c:1824
> > > > > Code: c1 ec 06 4b 8d 1c 2c 48 83 c3 08 48 89 d8 48 c1 e8 03 48 b9=
 00 00 00 00 00 fc ff df 80 3c 08 00 74 08 48 89 df e8 9a 30 f4 ff <48> 8b =
1b 48 89 de 48 83 e6 01 31 ff e8 59 70 8f ff 48 89 d8 48 83
> > > > > RSP: 0018:ffffc90003f778a8 EFLAGS: 00010246
> > > > > RAX: 1ffffd4c00072201 RBX: ffffea6000391008 RCX: dffffc0000000000
> > > > > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > > > > RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
> > > > > R10: dffffc0000000000 R11: fffff520007eef00 R12: 0000006000391000
> > > > > R13: ffffea0000000000 R14: 200018000e4401fd R15: 00002000003ab000
> > > > > FS:  00007ff35708f6c0(0000) GS:ffff8881258aa000(0000) knlGS:00000=
00000000000
> > > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > CR2: ffffea6000391008 CR3: 0000000074390000 CR4: 00000000003526f0
> > > > > Call Trace:
> > > > >  <TASK>
> > > > >  userfaultfd_move fs/userfaultfd.c:1923 [inline]
> > > > >  userfaultfd_ioctl+0x2e8b/0x4c80 fs/userfaultfd.c:2046
> > > > >  vfs_ioctl fs/ioctl.c:51 [inline]
> > > > >  __do_sys_ioctl fs/ioctl.c:598 [inline]
> > > > >  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:584
> > > > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > > > >  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
> > > > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > > > RIP: 0033:0x7ff3570d6519
> > > > > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 51 18 00 00 90 48 89 f8=
 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> > > > > RSP: 002b:00007ff35708f218 EFLAGS: 00000246 ORIG_RAX: 00000000000=
00010
> > > > > RAX: ffffffffffffffda RBX: 00007ff357160308 RCX: 00007ff3570d6519
> > > > > RDX: 0000200000000180 RSI: 00000000c028aa05 RDI: 0000000000000003
> > > > > RBP: 00007ff357160300 R08: 0000000000000000 R09: 0000000000000000
> > > > > R10: 0000000000000000 R11: 0000000000000246 R12: 00007ff35712d074
> > > > > R13: 0000200000000180 R14: 0000200000000188 R15: 00002000002b9000
> > > > >  </TASK>
> > > > > Modules linked in:
> > > > > CR2: ffffea6000391008
> > > > > ---[ end trace 0000000000000000 ]---
> > > > > RIP: 0010:_compound_head include/linux/page-flags.h:284 [inline]
> > > > > RIP: 0010:move_pages+0xbe6/0x1430 mm/userfaultfd.c:1824
> > > > > Code: c1 ec 06 4b 8d 1c 2c 48 83 c3 08 48 89 d8 48 c1 e8 03 48 b9=
 00 00 00 00 00 fc ff df 80 3c 08 00 74 08 48 89 df e8 9a 30 f4 ff <48> 8b =
1b 48 89 de 48 83 e6 01 31 ff e8 59 70 8f ff 48 89 d8 48 83
> > > > > RSP: 0018:ffffc90003f778a8 EFLAGS: 00010246
> > > > > RAX: 1ffffd4c00072201 RBX: ffffea6000391008 RCX: dffffc0000000000
> > > > > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > > > > RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
> > > > > R10: dffffc0000000000 R11: fffff520007eef00 R12: 0000006000391000
> > > > > R13: ffffea0000000000 R14: 200018000e4401fd R15: 00002000003ab000
> > > > > FS:  00007ff35708f6c0(0000) GS:ffff8881258aa000(0000) knlGS:00000=
00000000000
> > > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > CR2: ffffea6000391008 CR3: 0000000074390000 CR4: 00000000003526f0
> > > > > ----------------
> > > > > Code disassembly (best guess):
> > > > >    0: c1 ec 06                shr    $0x6,%esp
> > > > >    3: 4b 8d 1c 2c             lea    (%r12,%r13,1),%rbx
> > > > >    7: 48 83 c3 08             add    $0x8,%rbx
> > > > >    b: 48 89 d8                mov    %rbx,%rax
> > > > >    e: 48 c1 e8 03             shr    $0x3,%rax
> > > > >   12: 48 b9 00 00 00 00 00    movabs $0xdffffc0000000000,%rcx
> > > > >   19: fc ff df
> > > > >   1c: 80 3c 08 00             cmpb   $0x0,(%rax,%rcx,1)
> > > > >   20: 74 08                   je     0x2a
> > > > >   22: 48 89 df                mov    %rbx,%rdi
> > > > >   25: e8 9a 30 f4 ff          call   0xfff430c4
> > > > > * 2a: 48 8b 1b                mov    (%rbx),%rbx <-- trapping ins=
truction
> > > > >   2d: 48 89 de                mov    %rbx,%rsi
> > > > >   30: 48 83 e6 01             and    $0x1,%rsi
> > > > >   34: 31 ff                   xor    %edi,%edi
> > > > >   36: e8 59 70 8f ff          call   0xff8f7094
> > > > >   3b: 48 89 d8                mov    %rbx,%rax
> > > > >   3e: 48                      rex.W
> > > > >   3f: 83                      .byte 0x83
> > > > >
> > > > >
> > > > > ---
> > > > > This report is generated by a bot. It may contain errors.
> > > > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > > > >
> > > > > syzbot will keep track of this issue. See:
> > > > > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > > > >
> > > > > If the report is already addressed, let syzbot know by replying w=
ith:
> > > > > #syz fix: exact-commit-title
> > > > >
> > > > > If you want syzbot to run the reproducer, reply with:
> > > > > #syz test: git://repo/address.git branch-or-commit-hash
> > > > > If you attach or paste a git patch, syzbot will apply it before t=
esting.
> > > > >
> > > > > If you want to overwrite report's subsystems, reply with:
> > > > > #syz set subsystems: new-subsystem
> > > > > (See the list of subsystem names on the web dashboard)
> > > > >
> > > > > If the report is a duplicate of another one, reply with:
> > > > > #syz dup: exact-subject-of-another-report
> > > > >
> > > > > If you want to undo deduplication, reply with:
> > > > > #syz undup
> > > > >
> > > >
> > > > --
> > > > Peter Xu
> > > >

