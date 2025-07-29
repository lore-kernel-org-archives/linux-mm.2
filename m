Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB8DC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 02:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC05E6B007B; Mon, 28 Jul 2025 22:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E71A96B0089; Mon, 28 Jul 2025 22:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D602B6B008A; Mon, 28 Jul 2025 22:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C4C616B007B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 22:51:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 49D86113716
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:51:14 +0000 (UTC)
X-FDA: 83715775668.23.76C70DD
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 674E9120004
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:51:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rnmknaMK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753757472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rP4nJ7QVKuQ6dIL817mkYQc9jCgroNaq8Iqx4W9HDXs=;
	b=1v6/yFJyqhyeFwCwcyLffaUdA4UTAAcW5eFa20hQVmbTKXHtqn8/RJ0PUoi6EwxsXYnU1f
	L44F8AXMloxqnWntOHdXLsUg5/WDQAlWfTDK7p4RvD6uGHHoQRJfDwEmffcl/r9HP8/OBT
	9AnVBRxYq7NsgsLp1La2l2SHuJkWIA8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753757472; a=rsa-sha256;
	cv=none;
	b=U0cQ6G4tMB4l5tcUO03nIib5BXIASwlBN9VfGRVM0FX1fCoRmM3hNmT0oSoynG7cF+y6mV
	WItfzioSk1k60U9yswwyD8J+AHJq6dhGjqqfkcEnZa69kMghoOP9gxg1Tvpn0t+PCqYBVJ
	yVMXC4KfBJPXIFGTTGXPuf3o1IsCVnE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rnmknaMK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso240981cf.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 19:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753757471; x=1754362271; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rP4nJ7QVKuQ6dIL817mkYQc9jCgroNaq8Iqx4W9HDXs=;
        b=rnmknaMKDp4W+NdSLcR/P84Z7glkWlrxylrXmD8fDTZr2XV88i4BKsfCPYeWzCa+fM
         Mzck7oyuyU141FuQDoztR8fOuSFUwHc1NvbU42ox/yRUy5+9mR0z7hQN37oh6MJoX2UP
         dhXWv31yhPWofaiPIhdxFomUNgFFnewDPbV5DcjYFFl9GTgpmbY2M7VvmY5i9k3j9CO4
         K9V/kfN4bzLwnh6DKMkpgwalnQxSBf4aA1I6nkPkAf29tnunrmtLwoaD7iEtvbSEStHp
         IyVkf7G5dKPhTHCQvjNU4sm2vKkH4MSHksFVwNk4I0SPu3qBDAkws0nuOqBInztNs5Ub
         bxVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753757471; x=1754362271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rP4nJ7QVKuQ6dIL817mkYQc9jCgroNaq8Iqx4W9HDXs=;
        b=YuEud0dK2FqTFAOhpbnoyu6Y64u2LcpABe3+q07PaOJtRJfSyywhc09YSPyz4UewRL
         Qua0drqdLswDpPiF1cn29iucDE31Ou/zhoGAn+RbdqnUaQMfuJv97NK9VPUv/01wBekO
         etIgev390P2mNsLvYVGYzdo64g42Zq2GOel0pc7087Ww8aTaQw3uyBM4rX7h7zUB287E
         6Jg04dZXMjcCggfcU3tN1aFhwKkgzq2y89ThhFq3WSpLzEikRBTXtecU5Sx4nq4mYgZt
         ZhNbjoiovDg0HtPvRifC3gKZNeBlUsfaSyhgSR83uFBS4ElHScKuJke8+oZTGZ/jav7i
         jYlQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8Ge5spfYzdoCYl+vS3EpAdgY5B+hk6i5QEKHZzc2WOIw68sJyQOsKrv2ViYqFqqpnNEs5iyr/qg==@kvack.org
X-Gm-Message-State: AOJu0YyMqn2QgXHbd/g3QkVlFEHvqr8Rg7XRxl2FcBXdrtAbHSDQ2fqz
	dabG7ygu0gj/v2YXvzdNMj6fWCVOK/4dYFq12SqDGQHd7vWGHbY/eVNiNlvMR389JWrYT/mhzGx
	nx52qEAQrcatvD3trYMeKc8PwwRvxWrXbY1FOX2pq
X-Gm-Gg: ASbGncts5ohAcqrgkcfzuMPxnVobWFMKUU+UB4FBjF9wt8o+87pGjIWptoaEAHMX7l7
	DKVLGkI5ZQA5216jIS3bMXK7ADC5aU73SYg/ElAOeVpcwrgRHmCZ0yDFvv7qdvriHAb2orMEU+I
	QSHRx1OOvKjr7WqhbOPL4RTuSXxYwwLhdb8FEbhumikW6VojvuJOd2GjtNrcMmLH562Nr28j5HT
	O2a45Pjsy/0Fwo4lsxEMjUId1O5p8UDALQ=
X-Google-Smtp-Source: AGHT+IGyI4KuVMOu/ABy9Gmqs9xFZsf4rHRJ3lGsTjRW6FqT11tApijS68uAhbGR/B5/E2Yy8R0tlPFH4KUT9S2LiBc=
X-Received: by 2002:a05:622a:215:b0:4a9:a4ef:35c2 with SMTP id
 d75a77b69052e-4aecf9d2793mr1190081cf.23.1753757471101; Mon, 28 Jul 2025
 19:51:11 -0700 (PDT)
MIME-Version: 1.0
References: <68794b5c.a70a0220.693ce.0050.GAE@google.com> <aIfmv-qSxKxWgzur@x1.local>
In-Reply-To: <aIfmv-qSxKxWgzur@x1.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 29 Jul 2025 02:51:00 +0000
X-Gm-Features: Ac12FXxkdhvQM-2FTNyBaLgIo3h_qmvhR-ZEgqZTcFlI_763WaZT8GyJ4e8N0TM
Message-ID: <CAJuCfpFjvSQs2SomPpafw=H-z3fOBy_+K3qkdPa8wz_pH_C1pQ@mail.gmail.com>
Subject: Re: [syzbot] [mm?] BUG: unable to handle kernel paging request in move_pages
To: Peter Xu <peterx@redhat.com>
Cc: syzbot <syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com, Lokesh Gidra <lokeshgidra@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 674E9120004
X-Stat-Signature: wqxr58o6ctktakxu6r6ojqj5kfpfyi9s
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753757472-286028
X-HE-Meta: U2FsdGVkX1/Bj+z1R26N+XPoOcM//HIjEk34FGNeGAkne3NzsFS90xSfK+hlDf7VwpIcvuuJXlcV9ZI7GUMAHlQu0Pc9+B3vEdB7TEKxEDARF0w68pwAnLtF06NDyytM5jqtkjPOoo3fgXBZzV2VN1BBT4FkZCXb3uPqzlM9P60/sx0LbPaf88rEz6I7QYsf+k0zBISgndPG3AYLvz/ua2UqfD0TYZyN3JVCQQpEoNS3JozKLGc8C4jagAUN0ecXcCQr3yoFPCin1oPeMQTEji5tt8fD4L8bj4hI22H80AtYEC5mVSk2F2Hi6YeXXeC0H6wI5uF7CoMHpth5SoLWXIg6NbxGeOnjJFJ6Ywx0/6wTnPA0xrCQ+kD1+wmQHngLh497Ur1SxHJVDSfkVjghO58fK/9KP5QcJhtR6vYUc5F7HAO+25ksJBjny8M4v69Sr7w/GVKr9+jQp8m/yEtYgSZ+R2p8ESLGjO5/stkIP1Ft79GG7m3rnQCmGerfxgAI3Pc1pYuiNwO/fETzth14ym5qvaxz2wjtqdTU8h7NCa9Bvc7Fmsw6XyHpfN1G1XkMLvYQ6KFhnGQeoF9hnqaqUTHNOu4pZjU8gPa3cI6xuu2BOMPe1JopET5tEX7ho52WRZpjtYYMhjvr12J9GABt7hjPwWytsFi8giex/6WYuirFvTB0yNXsCAbAnoOZMvgMOGD4z26TEhjKPpDEqOGJX7UW+6bW3/AdVtfTZODfeNIavZIL0btk2V1IjINunMk22viOxjtbpZCay+bnZ7IK6vfiJnYfN/fcbW9mJ/sLYrX7fzccKFLes9f4icEUfZKi0cupvsML2Ity/eVwBTFdHUqg/e8oKGZKycFEPUosSOYYEYz0r5SvturEC2kuijoluvrXlWXxlpPCAp8juVZAVRuQLqKuqSCc8iav+tOkDRuNSht5xmPMCwKWQ1uq9Xk9og+G4sueqhZVylRJPoN
 6KljSBOO
 ZBzmcJsLGmrAuBYcV9lsDHmixhZaj6ZjkjNhNg8V9IGSUpAqD8CJSCBVHXkcQBanlPm+26gWPmuyS50HLhOi47+X8ZAsFBlsS71jowfd1mIN3sKwRgRe4F7p2YX39EBF8rM5v1SkB3elrLj8ZTeDcoAtXCAc3tRrmd9QyFx0vqz8UoByE+wtIPjMTMqH75miJNn+KoCYpuK2NhDeR22ySPgpQlfeeiXsf555uCZMmK0ZQSBgbkd9QghVITNXfW1XE5zNxIOUnugsvmkYmg0aF7501DWjpqTbRJJZPuJLZnh+Zy538BKXcpsYp0wtrfLhRGPQ3vHu8Eb9mx8nFARTLYBoCGXp1Di+66ENyGCByTxJ0rINzneSTAYjH12L6+sUI/bRw98uzo/1nyhn6ApcV6Ht7Y8SqWxvQiz4IE0tEBatpcxMc5jJdxpJAR/vc0aeza334mvfDInj6ldfbBud2GHjUPrIUgDYMRdAOUsP2oMcoVI2XVtDlCnN2b3CcBb/blk/uWiE1QQUHW/BeGEzxc5gHP+y0VHO3VluYihAdip5cZOKA76PhBL2OuSQJVvowDoEQVE+2nIKsTOtnZ5z0YZuddMsN6BFLRqy2wHDKF79pJRn3SO3Nn6L/qVHx/JJDjFaUPM1v6K/kZbkNZxlKgHKRpjndkVfsWN446pcWH+10X95iNBSlpJ+IDtWL4/OS+gpBSexybuNlGKtTAqXet832In68SUcHE1DvFnswPwDJkJ7AJSelJlHly09vlPoQWshj9crTwyXjeNn/9bGu3LghNQn5xSyMmfYZRxCHF6/J8EkgmLDZ8OP+NNIdzn0Ind4nhvnz/kaczkv2bOn7DUZPySlZ8shmSrQinkPOiLeEPeV1XbnK/6mJC6S0MuLWrf1r2qmwvfYfPR3urQKbSy1MNqrURvdnPSMPEyciCZALSR3g+TGv0Q22A7AU09KKzzRz1TVhF6UQugMuOHCrm8Kbo7sG
 3Wf7crzt
 +A0RADn8QDp2sjByKmOwb3NjOwdTC5fZdTprPAu1w4aXzCMCFA0TWKvZ1ZmWl7qvBMBl4/2FWe3W37GFNEh3oQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 9:08=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> Copy Lokesh and Suren.

Thanks! I'll take a closer look tomorrow morning.

>
> On Thu, Jul 17, 2025 at 12:13:32PM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    e8352908bdcd Add linux-next specific files for 20250716
> > git tree:       linux-next
> > console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D17f81382580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Db7b0e60e17d=
c5717
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3Db446dbe27035e=
f6bd6c2
> > compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6=
049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D100413825=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D10eb158c580=
000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/ae8cc81c1781/d=
isk-e8352908.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/57aaea991896/vmli=
nux-e8352908.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/feb871619bd4=
/bzImage-e8352908.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> >
> > BUG: unable to handle page fault for address: ffffea6000391008
> > #PF: supervisor read access in kernel mode
> > #PF: error_code(0x0000) - not-present page
> > PGD 13fff8067 P4D 13fff8067 PUD 0
> > Oops: Oops: 0000 [#1] SMP KASAN PTI
> > CPU: 1 UID: 0 PID: 5860 Comm: syz-executor832 Not tainted 6.16.0-rc6-ne=
xt-20250716-syzkaller #0 PREEMPT(full)
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 05/07/2025
> > RIP: 0010:_compound_head include/linux/page-flags.h:284 [inline]
> > RIP: 0010:move_pages+0xbe6/0x1430 mm/userfaultfd.c:1824
> > Code: c1 ec 06 4b 8d 1c 2c 48 83 c3 08 48 89 d8 48 c1 e8 03 48 b9 00 00=
 00 00 00 fc ff df 80 3c 08 00 74 08 48 89 df e8 9a 30 f4 ff <48> 8b 1b 48 =
89 de 48 83 e6 01 31 ff e8 59 70 8f ff 48 89 d8 48 83
> > RSP: 0018:ffffc90003f778a8 EFLAGS: 00010246
> > RAX: 1ffffd4c00072201 RBX: ffffea6000391008 RCX: dffffc0000000000
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
> > R10: dffffc0000000000 R11: fffff520007eef00 R12: 0000006000391000
> > R13: ffffea0000000000 R14: 200018000e4401fd R15: 00002000003ab000
> > FS:  00007ff35708f6c0(0000) GS:ffff8881258aa000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: ffffea6000391008 CR3: 0000000074390000 CR4: 00000000003526f0
> > Call Trace:
> >  <TASK>
> >  userfaultfd_move fs/userfaultfd.c:1923 [inline]
> >  userfaultfd_ioctl+0x2e8b/0x4c80 fs/userfaultfd.c:2046
> >  vfs_ioctl fs/ioctl.c:51 [inline]
> >  __do_sys_ioctl fs/ioctl.c:598 [inline]
> >  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:584
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7ff3570d6519
> > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 51 18 00 00 90 48 89 f8 48 89=
 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 =
ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007ff35708f218 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > RAX: ffffffffffffffda RBX: 00007ff357160308 RCX: 00007ff3570d6519
> > RDX: 0000200000000180 RSI: 00000000c028aa05 RDI: 0000000000000003
> > RBP: 00007ff357160300 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 00007ff35712d074
> > R13: 0000200000000180 R14: 0000200000000188 R15: 00002000002b9000
> >  </TASK>
> > Modules linked in:
> > CR2: ffffea6000391008
> > ---[ end trace 0000000000000000 ]---
> > RIP: 0010:_compound_head include/linux/page-flags.h:284 [inline]
> > RIP: 0010:move_pages+0xbe6/0x1430 mm/userfaultfd.c:1824
> > Code: c1 ec 06 4b 8d 1c 2c 48 83 c3 08 48 89 d8 48 c1 e8 03 48 b9 00 00=
 00 00 00 fc ff df 80 3c 08 00 74 08 48 89 df e8 9a 30 f4 ff <48> 8b 1b 48 =
89 de 48 83 e6 01 31 ff e8 59 70 8f ff 48 89 d8 48 83
> > RSP: 0018:ffffc90003f778a8 EFLAGS: 00010246
> > RAX: 1ffffd4c00072201 RBX: ffffea6000391008 RCX: dffffc0000000000
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
> > R10: dffffc0000000000 R11: fffff520007eef00 R12: 0000006000391000
> > R13: ffffea0000000000 R14: 200018000e4401fd R15: 00002000003ab000
> > FS:  00007ff35708f6c0(0000) GS:ffff8881258aa000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: ffffea6000391008 CR3: 0000000074390000 CR4: 00000000003526f0
> > ----------------
> > Code disassembly (best guess):
> >    0: c1 ec 06                shr    $0x6,%esp
> >    3: 4b 8d 1c 2c             lea    (%r12,%r13,1),%rbx
> >    7: 48 83 c3 08             add    $0x8,%rbx
> >    b: 48 89 d8                mov    %rbx,%rax
> >    e: 48 c1 e8 03             shr    $0x3,%rax
> >   12: 48 b9 00 00 00 00 00    movabs $0xdffffc0000000000,%rcx
> >   19: fc ff df
> >   1c: 80 3c 08 00             cmpb   $0x0,(%rax,%rcx,1)
> >   20: 74 08                   je     0x2a
> >   22: 48 89 df                mov    %rbx,%rdi
> >   25: e8 9a 30 f4 ff          call   0xfff430c4
> > * 2a: 48 8b 1b                mov    (%rbx),%rbx <-- trapping instructi=
on
> >   2d: 48 89 de                mov    %rbx,%rsi
> >   30: 48 83 e6 01             and    $0x1,%rsi
> >   34: 31 ff                   xor    %edi,%edi
> >   36: e8 59 70 8f ff          call   0xff8f7094
> >   3b: 48 89 d8                mov    %rbx,%rax
> >   3e: 48                      rex.W
> >   3f: 83                      .byte 0x83
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> >
> > If you want syzbot to run the reproducer, reply with:
> > #syz test: git://repo/address.git branch-or-commit-hash
> > If you attach or paste a git patch, syzbot will apply it before testing=
.
> >
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> >
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> >
> > If you want to undo deduplication, reply with:
> > #syz undup
> >
>
> --
> Peter Xu
>

