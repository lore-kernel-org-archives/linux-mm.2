Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD04C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 17:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30B886B007B; Tue, 29 Jul 2025 13:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BC7E6B0088; Tue, 29 Jul 2025 13:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D2226B0089; Tue, 29 Jul 2025 13:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 102F36B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:51:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA6F9B6E9F
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 17:51:40 +0000 (UTC)
X-FDA: 83718044760.08.58EA2A7
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id CFB512000C
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 17:51:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Cd/summE";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753811498; a=rsa-sha256;
	cv=none;
	b=NU4hCtimNhydsJvZ56UFw9LCVBJu5gL3nOLJ+BAjHbBKYyrvPt/slLEFJjCycl2di49LDs
	zm4acT/PqWzC8QkjS/wuvMT8QjJiwfivrXv8em/QjwwBdP7bxyr8JwvQyEjHgKLTJY48Ee
	NGkKaCbcY5Sr9PR136T9yBYUXR6IrCU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Cd/summE";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753811498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iUV4bd9jQv9HI6OBSP2N2WpkOCN1WYWoK2UgBJjsg9Y=;
	b=Z0gwn9qetkHAQ8YakWTNbzXZP+ixIk6TbXQj7g6EeTYDLkMGkTEg+QKvFtyzYW1acQM8mm
	18cdFhyy/9IXxepFhbaL3zw6WF2mZk2fBeO9aLjU/13NlYstj5Hzvh7YpG5tG0dmWQasXN
	gbxWAayu3COQf9jAocHRibE+Xh4l1Hs=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ab86a29c98so23061cf.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 10:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753811498; x=1754416298; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iUV4bd9jQv9HI6OBSP2N2WpkOCN1WYWoK2UgBJjsg9Y=;
        b=Cd/summEekSNmHB9Z7gFbeYFAcJ14RGOTduzh7EgmaeQbyx4YvLjrjYdbyBHvaGuu9
         lMflTLbu8YMuGiHcwon2zQj339aSp6DDRCgX80TVLm5eJ9KApPqY0+wtl3gFHOp5GL/i
         LUDyMhafnmqhvmloX4fNH6FBlAJJC3pS64AP1PoqedIKw+MOHqizSph9e7KJuERYxkp8
         kworWQMkr2uWZKGxmjMLriICK8Em1YqsHBu7VSCMuUiQkIjaTAoKov89E3879rolF55J
         icYzgnNQVmbMQIwNtiUAp59sg29UWMJZkUEn2hD0t+oCtUgiY6NgMDVp1wIBWOZdLrmv
         hwrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753811498; x=1754416298;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iUV4bd9jQv9HI6OBSP2N2WpkOCN1WYWoK2UgBJjsg9Y=;
        b=GyHp26TJGhavjzgGwC0cR3ChI7iPY7ejYeIpP6z6pOYeL5+QtIz76JcuVsdbUuM3bA
         s62EGmXggtv89Jlg4NgrK8niVTM2y+PA1QQbzGbCAUeakk3FYQbLQgU6sK/M7kkejJDv
         Aq8MkDqlG1+1IYHnvsm7Q9y7BW3YPLYmsZxtHQHGO/w7j41nhT7QDUq2O5nFn9VmNdNx
         i5+xpc4QtolgohT/iJqPS3dmOFRwAaZQMfy5LbPM0hA1LII79EZofH3hrjGDIpTso3/X
         9pQJIiXr2KcWSW1SkrEsloVoqwnXk86b1wjXPMVquaW/Ayy7uZcRkyXu8Ksgn8vO3Du+
         mk9g==
X-Forwarded-Encrypted: i=1; AJvYcCWXkU6unHvZDG21WqR6Ai8yIYhWCtfgIfODzYChb2anG5GKzZ3G4//jnsJsK/AdTCVS6kCUnYaf8A==@kvack.org
X-Gm-Message-State: AOJu0Yyx8VlT7tdCs3CH3XHer1lMMa95FL+PCvL8K5KgsbYYSnZJAyI/
	HyiOPveHKrMwqdUvj0YONehZpeGGVHFnuT/sTYGj4rLbmgu3y0usa/TCUN6ip3kOPsIR9k+wO6c
	5rGn/t8Frr3QUHcsk2KLgbJApS0z3VceqhNgwq0O9
X-Gm-Gg: ASbGncuJCS7vOHnstTis9grq/iDAoHpGaTuzVVlPwb8U9c4kxsIKo6wlKO16WdLiE79
	ZhYb6L6Azl7du4zRkJxAta+xUAPdScZv3I6lll70fZLdkKU/tlV/rASkGEHYR9qvalvUzVvl22y
	ENB8e1PPoz4dflEUycO3tqVcGePT0JcXYBWNhs6BjKkeHt0h7tVnZNDLq98plWHE1vs8V2wJlnA
	+JXrhwluccwbeJn2ZEI1DTS2GGYaipxPjXSsw==
X-Google-Smtp-Source: AGHT+IEKQ1ZSdA0dCGB/QidlUmKWUeKgpTvh58U9nFdnK2Ys0CFX4j/XIXq5wjXiXS9G9FXtIrhwbcQSHH40WD4PyYQ=
X-Received: by 2002:a05:622a:1916:b0:4a7:bed9:5251 with SMTP id
 d75a77b69052e-4aeddd1e930mr3161cf.9.1753811497192; Tue, 29 Jul 2025 10:51:37
 -0700 (PDT)
MIME-Version: 1.0
References: <68794b5c.a70a0220.693ce.0050.GAE@google.com> <aIfmv-qSxKxWgzur@x1.local>
 <CAJuCfpFjvSQs2SomPpafw=H-z3fOBy_+K3qkdPa8wz_pH_C1pQ@mail.gmail.com> <CA+EESO7goQHuAdobDvWMaYGiVw30g1=o_f5UzBceeSbS2n5MtA@mail.gmail.com>
In-Reply-To: <CA+EESO7goQHuAdobDvWMaYGiVw30g1=o_f5UzBceeSbS2n5MtA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 29 Jul 2025 10:51:26 -0700
X-Gm-Features: Ac12FXydOXggkkwOKVSAz6ykCOejwKRuh2-g1yX-kFBa882Gm_XdDezYtwexigs
Message-ID: <CAJuCfpGGpQ4s+z2AAs3YwgHASVUqx4tEi=1BMeqW8_wL_acq_w@mail.gmail.com>
Subject: Re: [syzbot] [mm?] BUG: unable to handle kernel paging request in move_pages
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: Peter Xu <peterx@redhat.com>, 
	syzbot <syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CFB512000C
X-Stat-Signature: jxyubq1k8gq5pqrsq65yb6erxbxbjd1s
X-HE-Tag: 1753811498-594572
X-HE-Meta: U2FsdGVkX1+9HlcTs7qRyRz6jWx+2Er85iHzSoz0Rg8u2MQH9p3MpLd+wQxj/7KYXATbkU3lTHxsmwGElDUwoZ7EF1HrCshlc9LOfbNMj1M5wWsQoHm1kPCxYSmaGU7LYZsnjWM3BYna0YCAZiFHp8kDDf/+1yDevWW/kyBQ4TnPRQpkv1T6YiY0NrxoQEKRZqZII6i9ShlmxMbiR9r0cz9tOOFtppkUb5J+kE/ulgUvfj71YRQHTACGUT96KqcVAoccE7piHo2UUtMHH9VJmcq0wf+UuUxIntOzHbzNwxL3Xk16kHIh1hdDn5BNQtz550kA969Ct+7OT8ftAy3l4S/uUF3zSQ+bszx8aVJQHlSRQtUO6P3FlspTM0OxUddAGOnnRXkZM/iZ9DnDdfppQUHHs7jmA87CU9lHlIwV3LRmSl8r+Bjgrp/I6ZOYtrSqw1gL9KuLfjPfFtGpzic7c20PHPqF/AhvVVKTcvp6f1kOA94op/zf63CTSBmpHKiNQksp9X8WsXmKWkUIWAG+XzrlcnjlUz5OmjL08QD3XJSNijTDSHArERMXm068aSOIs8Njgtdw1luKEsiswfelogfa4vIR4eK+QB9owFZdBwmizdK5MCFjcBThQcYeL4gpVzMjr7MCoxUbHYa4lMNHtw177VLLowPa9IKvzjd63FCccVxoAZQAdlaPwwWbzo5yWUcnTT75v63fM4fuxIbwKCpC2tBcLLt4o0PqORAsVWQOrwofRoUo31znNvdxTizxjXFoOSTj+MWvlPihG3oFni8BmgLLvkWFcjs6uGgcjQqxTgSdTgPwlDfms88CbwcvEPTegCli5LF2znZ5O4b9JqHDfXPRjAXq1l9VWKqiX8WXml8qbzP3OmUvH/KYyOMyzE15r3RjJ2tTMzqsm1MqWdTkZa0Ygxoih6SUhpmSIL/rxJDgT3iiOqn8M2orMl8JFQeNUqq15jybwn7V6mr
 2JY03uaR
 0VPnC90ti/WjizRSG5mdCWotWXWorUgJFBbSD1jc2JpZPkGuESZMF3dU2qbi/3FgIAGuS5MaQV+9n9JcvP/atZ6/S5OrfNLeNXrvR2KaRIIMZWGJYdRs8vIQ9oIdLEWH4hS8rJn8c/0BaxyB5iGBoMYUjcPVhpiRMTHeqXfUyCZAVaXu6QLD6mnSs6tqvaGzK9jDMugnUkQs17mddg9+cTCDlmhNUXZ5OyoT7Yt4lcnAQdXn/chzgY9c5BWIujH10ANhRe3lBk3GvIKEInfL/0egCSMF5yyLyBrkDVZJLHDvcIkwkND8ZiYrqfddRyxYE55Ira03pDuOkViIQZVkI3Wxif4HORL5i6eZN6kKIzDccGIxfUn2riFdTlVn3SztWLZhBwlyZ78YOElFfJsblTrhoQWQZ2oPDsOxg23twBBoBZjPKeLl8WAZzq/pjWdy2n6Dlvd8o1My82oKUT2dc75qMZIS5rfk49FhbJqtoV9PuzGang9FrN6bfCe5asW0xGuugf7C87pzIJwjPjH3aLSuqtpS80nrtaA2f7DzA62domlHkPRHJxLhO7paF041d3LTrXPLYB++WmMyFd2G1Q7WnzZDZYZx+agsjbcA96qQe1mYtp7VJic3YWnrQmNznglzlSTPPC2IGF4ZMXWl6XTJEytkjFsFyQ/iUEeKf+ypfEGPV8KOnzUR4lAo825Tj0BWGzpvhCiZisg4PNLPztQ77DrS4jjPyR1MHlhQ1Co5wJ/QUcXxF1qp/snYO4siuxHHNsgqDOWY0eg1Qr8gNlPgxO99XU/iurnVtdYDiD7NC5sZSVjAC2fC7spKHByCrJQ1wfIIydLBZRtE+L8jlluE+BiMcXDgOCn0BdSvXtO/QVCifvx4iaMQMptBTXKJZ7vCk5JOKpUn2wYn3mAPrNnH2EOuKbWM1WN1TnQERQW6GbDGvj9u5+Oz4oUwuqwixOO2RN0+K1xgXxU5cBCGWhSiOQpJO
 q902cifM
 J7YSolQE8TLozrg2qtQASo4lhXXYpnOgtFpNTAb7UNpimNMl/vJI1RNZgn5v9JQ02fo4o7LSMXrNGYx9bIWK7vGY7RbHSa5qGIg7ki0JD5pvhRy+YUX9UQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 1:08=E2=80=AFAM Lokesh Gidra <lokeshgidra@google.co=
m> wrote:
>
> On Mon, Jul 28, 2025 at 7:51=E2=80=AFPM Suren Baghdasaryan <surenb@google=
.com> wrote:
> >
> > On Mon, Jul 28, 2025 at 9:08=E2=80=AFPM Peter Xu <peterx@redhat.com> wr=
ote:
> > >
> > > Copy Lokesh and Suren.
>
> Thanks Peter!
> >
> > Thanks! I'll take a closer look tomorrow morning.
> >
> I think the issue is that we are incorrectly handling src holes in the
> THP case. The reproducer is setting 'mode' to
> UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it seems like the src address is
> indeed untouched at the time MOVE ioctl is invoked and hence likely
> has a hole.
>
> When this mode is set, we (correctly) don't fail with -ENOENT, but
> then instead of skipping the page, we keep going with THP move, which
> involves fetching the folio unconditionally from the src_pmd, which is
> expected to have no page mapped there.
>
> Suren, can you please double check if my hypothesis is correct?

I think in the case of a hole the prior call to pmd_trans_huge_lock()
would return NULL and we would not handle it as THP move.
I was able to reproduce the crash, though the call stack is a bit
different. Will try to figure it out.

> > >
> > > On Thu, Jul 17, 2025 at 12:13:32PM -0700, syzbot wrote:
> > > > Hello,
> > > >
> > > > syzbot found the following issue on:
> > > >
> > > > HEAD commit:    e8352908bdcd Add linux-next specific files for 2025=
0716
> > > > git tree:       linux-next
> > > > console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D17f8138=
2580000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Db7b0e60=
e17dc5717
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=3Db446dbe27=
035ef6bd6c2
> > > > compiler:       Debian clang version 20.1.7 (++20250616065708+6146a=
88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D10041=
382580000
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D10eb158=
c580000
> > > >
> > > > Downloadable assets:
> > > > disk image: https://storage.googleapis.com/syzbot-assets/ae8cc81c17=
81/disk-e8352908.raw.xz
> > > > vmlinux: https://storage.googleapis.com/syzbot-assets/57aaea991896/=
vmlinux-e8352908.xz
> > > > kernel image: https://storage.googleapis.com/syzbot-assets/feb87161=
9bd4/bzImage-e8352908.xz
> > > >
> > > > IMPORTANT: if you fix the issue, please add the following tag to th=
e commit:
> > > > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> > > >
> > > > BUG: unable to handle page fault for address: ffffea6000391008
> > > > #PF: supervisor read access in kernel mode
> > > > #PF: error_code(0x0000) - not-present page
> > > > PGD 13fff8067 P4D 13fff8067 PUD 0
> > > > Oops: Oops: 0000 [#1] SMP KASAN PTI
> > > > CPU: 1 UID: 0 PID: 5860 Comm: syz-executor832 Not tainted 6.16.0-rc=
6-next-20250716-syzkaller #0 PREEMPT(full)
> > > > Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 05/07/2025
> > > > RIP: 0010:_compound_head include/linux/page-flags.h:284 [inline]
> > > > RIP: 0010:move_pages+0xbe6/0x1430 mm/userfaultfd.c:1824
> > > > Code: c1 ec 06 4b 8d 1c 2c 48 83 c3 08 48 89 d8 48 c1 e8 03 48 b9 0=
0 00 00 00 00 fc ff df 80 3c 08 00 74 08 48 89 df e8 9a 30 f4 ff <48> 8b 1b=
 48 89 de 48 83 e6 01 31 ff e8 59 70 8f ff 48 89 d8 48 83
> > > > RSP: 0018:ffffc90003f778a8 EFLAGS: 00010246
> > > > RAX: 1ffffd4c00072201 RBX: ffffea6000391008 RCX: dffffc0000000000
> > > > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > > > RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
> > > > R10: dffffc0000000000 R11: fffff520007eef00 R12: 0000006000391000
> > > > R13: ffffea0000000000 R14: 200018000e4401fd R15: 00002000003ab000
> > > > FS:  00007ff35708f6c0(0000) GS:ffff8881258aa000(0000) knlGS:0000000=
000000000
> > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > CR2: ffffea6000391008 CR3: 0000000074390000 CR4: 00000000003526f0
> > > > Call Trace:
> > > >  <TASK>
> > > >  userfaultfd_move fs/userfaultfd.c:1923 [inline]
> > > >  userfaultfd_ioctl+0x2e8b/0x4c80 fs/userfaultfd.c:2046
> > > >  vfs_ioctl fs/ioctl.c:51 [inline]
> > > >  __do_sys_ioctl fs/ioctl.c:598 [inline]
> > > >  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:584
> > > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > > >  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
> > > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > > RIP: 0033:0x7ff3570d6519
> > > > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 51 18 00 00 90 48 89 f8 4=
8 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01=
 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> > > > RSP: 002b:00007ff35708f218 EFLAGS: 00000246 ORIG_RAX: 0000000000000=
010
> > > > RAX: ffffffffffffffda RBX: 00007ff357160308 RCX: 00007ff3570d6519
> > > > RDX: 0000200000000180 RSI: 00000000c028aa05 RDI: 0000000000000003
> > > > RBP: 00007ff357160300 R08: 0000000000000000 R09: 0000000000000000
> > > > R10: 0000000000000000 R11: 0000000000000246 R12: 00007ff35712d074
> > > > R13: 0000200000000180 R14: 0000200000000188 R15: 00002000002b9000
> > > >  </TASK>
> > > > Modules linked in:
> > > > CR2: ffffea6000391008
> > > > ---[ end trace 0000000000000000 ]---
> > > > RIP: 0010:_compound_head include/linux/page-flags.h:284 [inline]
> > > > RIP: 0010:move_pages+0xbe6/0x1430 mm/userfaultfd.c:1824
> > > > Code: c1 ec 06 4b 8d 1c 2c 48 83 c3 08 48 89 d8 48 c1 e8 03 48 b9 0=
0 00 00 00 00 fc ff df 80 3c 08 00 74 08 48 89 df e8 9a 30 f4 ff <48> 8b 1b=
 48 89 de 48 83 e6 01 31 ff e8 59 70 8f ff 48 89 d8 48 83
> > > > RSP: 0018:ffffc90003f778a8 EFLAGS: 00010246
> > > > RAX: 1ffffd4c00072201 RBX: ffffea6000391008 RCX: dffffc0000000000
> > > > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > > > RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
> > > > R10: dffffc0000000000 R11: fffff520007eef00 R12: 0000006000391000
> > > > R13: ffffea0000000000 R14: 200018000e4401fd R15: 00002000003ab000
> > > > FS:  00007ff35708f6c0(0000) GS:ffff8881258aa000(0000) knlGS:0000000=
000000000
> > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > CR2: ffffea6000391008 CR3: 0000000074390000 CR4: 00000000003526f0
> > > > ----------------
> > > > Code disassembly (best guess):
> > > >    0: c1 ec 06                shr    $0x6,%esp
> > > >    3: 4b 8d 1c 2c             lea    (%r12,%r13,1),%rbx
> > > >    7: 48 83 c3 08             add    $0x8,%rbx
> > > >    b: 48 89 d8                mov    %rbx,%rax
> > > >    e: 48 c1 e8 03             shr    $0x3,%rax
> > > >   12: 48 b9 00 00 00 00 00    movabs $0xdffffc0000000000,%rcx
> > > >   19: fc ff df
> > > >   1c: 80 3c 08 00             cmpb   $0x0,(%rax,%rcx,1)
> > > >   20: 74 08                   je     0x2a
> > > >   22: 48 89 df                mov    %rbx,%rdi
> > > >   25: e8 9a 30 f4 ff          call   0xfff430c4
> > > > * 2a: 48 8b 1b                mov    (%rbx),%rbx <-- trapping instr=
uction
> > > >   2d: 48 89 de                mov    %rbx,%rsi
> > > >   30: 48 83 e6 01             and    $0x1,%rsi
> > > >   34: 31 ff                   xor    %edi,%edi
> > > >   36: e8 59 70 8f ff          call   0xff8f7094
> > > >   3b: 48 89 d8                mov    %rbx,%rax
> > > >   3e: 48                      rex.W
> > > >   3f: 83                      .byte 0x83
> > > >
> > > >
> > > > ---
> > > > This report is generated by a bot. It may contain errors.
> > > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > > >
> > > > syzbot will keep track of this issue. See:
> > > > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > > >
> > > > If the report is already addressed, let syzbot know by replying wit=
h:
> > > > #syz fix: exact-commit-title
> > > >
> > > > If you want syzbot to run the reproducer, reply with:
> > > > #syz test: git://repo/address.git branch-or-commit-hash
> > > > If you attach or paste a git patch, syzbot will apply it before tes=
ting.
> > > >
> > > > If you want to overwrite report's subsystems, reply with:
> > > > #syz set subsystems: new-subsystem
> > > > (See the list of subsystem names on the web dashboard)
> > > >
> > > > If the report is a duplicate of another one, reply with:
> > > > #syz dup: exact-subject-of-another-report
> > > >
> > > > If you want to undo deduplication, reply with:
> > > > #syz undup
> > > >
> > >
> > > --
> > > Peter Xu
> > >

