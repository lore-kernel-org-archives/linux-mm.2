Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAD98CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 13:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 075686B0092; Wed, 27 Aug 2025 09:45:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 025FA6B0093; Wed, 27 Aug 2025 09:45:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA55F6B0095; Wed, 27 Aug 2025 09:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4F256B0092
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:45:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A2FCB160209
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:45:30 +0000 (UTC)
X-FDA: 83822659620.24.9933E7F
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id B4E3BC001A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:45:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IskmDrM2;
	spf=pass (imf22.hostedemail.com: domain of nogikh@google.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=nogikh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756302328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cpeAyXHMygB6Vp8avv/l/2pS0bBbs9F68uJjKNzJkaA=;
	b=voKhIZQMMPWEPa67v6NoC09WaC4KgkFQinhUgMMr/5taYn4FhCoyVOmjUNxpmv2dPBbumP
	RUCUxXG0eINavv9xYiK/7WUs4SZR5lMnLbr3Lf5dopCQAVMQ3gJPagkr91vkuGNrAAXUKp
	jUi2VhxY+RddYIi15eezKg7m4byOV7k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IskmDrM2;
	spf=pass (imf22.hostedemail.com: domain of nogikh@google.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=nogikh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756302328; a=rsa-sha256;
	cv=none;
	b=C1RI9BbODvgU2mSFhP5AnHucV9fsnIMC1jA0j8lb49YyvR4bvbRQ4C5DKKBX6dKCVQhvvz
	H/tOYY08Z1EiTOFftDyGMXYgv7AUk6gmJpNxJu0Ae0psv4zrFCvTJA9jWScMrg81HaAwDH
	4TosJgNKldRN857bbm9//cdC0bx1INc=
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-74542b1b2f7so325009a34.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756302328; x=1756907128; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cpeAyXHMygB6Vp8avv/l/2pS0bBbs9F68uJjKNzJkaA=;
        b=IskmDrM2n7MkZgGDi0t278AtRJj+XcDaaVUSPWXuw/TJfYX1FUDxBqZH9P0xaw/8yo
         7WBczchCN9DJelnhCYGIsukQMsVjHNBtdIqEi+UGXe9E75oAoYi97qZWM8d+13BYynD8
         wnmLH4aONlFXjPrSUky/+JcymIuIpcxY3pz8UvKb8NVNawhGGGMEyjeUSWU/7NhnwYgD
         /R+e8vzzgDXlHIXqDcHG599AyFirtHmN4krOjES7qmIaiPNL0ixffLq5dTppM4RV8dpR
         vfy0oUxjMtSQEraI75c6gHQCSb5RCP1h0IRoNABgfXFm/apaKiJv5uJTrzyWl5Z2z68B
         CFdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756302328; x=1756907128;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cpeAyXHMygB6Vp8avv/l/2pS0bBbs9F68uJjKNzJkaA=;
        b=qgDu5VqATgmqhgDSX+dwxDGuoN5GCVb3GUJNZPh7tS+icLtCVq75srCdA+KwFlR9qb
         pFegnaIXFLEdrLxY4BogRbd2K2703DFCbCmfcTsoOvc8Qmt5c7lsGZ/tC2r78aJ6hOGM
         2aj4n75amJ31SRpj+NWNKWfUi9sMBV88h8511uOD3eVWmNqdSH1GbhUtMm5uENyuBnky
         azwouuGvL/4yGx52lFITmdGr/qaFsyymjEbSbGQYh+gc77cIty6zPCvMPgdqli3ab090
         Z61uAkDs3LoDhBzB1xdsblzjju1O105PqsazQi8pQejIwbERW1X2OuC8MLXGG3aodxQm
         WWjw==
X-Forwarded-Encrypted: i=1; AJvYcCXk45yTmeY6fE0O5GrEYwaINAsXAtxVQMJMDe90eyK/+OnLF/jTgQC1C6eUNBBDQmfxUw5e+8Bg1Q==@kvack.org
X-Gm-Message-State: AOJu0Yxp9xoy4weVcnnT2jC9FbgkaFg9bKNw0PVJhkOknP9W/01wZUW6
	EW6GIT4gJwG49yw2bFANBQdTDXg1BiJUiupAGg/Q9fMin5H9A8e+61vsgJvdSQCBRR6JDQHAObf
	jmUF4+MrWcM6/aZeFAtDGRUeOKnbRW3BiOtTzpzmV
X-Gm-Gg: ASbGncvvOI2XM69FEBN/4Ow+a+JKZSklQf3/Kb5aXSe21lCJ+71iBzNeV/2+0vU1haV
	CAKEazth+XAzXTJr+SIP0ZGrrlKGYJMiFxfNNDjw6YbKJlsa7oJe3hXYKSh9ehM9zYlPkoRRp5N
	usElSFeTvcfkbsSj3e/kmoZc3VRV/7v7PoXraToAiP9ERs5D+7BXTFeKO2KGd3lFzBOLffM2h4R
	Zsg2Ju320fMOFGu9qnGUbUC/zH53ABzLg5MieI8vUMCHX7HHEMSN/c=
X-Google-Smtp-Source: AGHT+IGK7wifIZTut20YoDMzlxEGyZdNXsXaZZswhXERO89C+jJhJO5osaSyoHUdvFiNWYFFLseH95HRoPKQiuu2iAE=
X-Received: by 2002:a05:6830:60cf:10b0:745:1905:af2d with SMTP id
 46e09a7af769-7451905afa6mr4676726a34.10.1756302327478; Wed, 27 Aug 2025
 06:45:27 -0700 (PDT)
MIME-Version: 1.0
References: <68a841d7.050a0220.37038e.0051.GAE@google.com>
In-Reply-To: <68a841d7.050a0220.37038e.0051.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 27 Aug 2025 15:45:16 +0200
X-Gm-Features: Ac12FXy3XsS3r_1Xsoljd22xWwY_l_Rgh701RqGb2u2OIv6ofdVJaEbx_TPotDk
Message-ID: <CANp29Y5zWmwXDq1uuzxi43_VXieykD2OOLF12YvBELCUS_Hibg@mail.gmail.com>
Subject: Re: [syzbot] [fs?] [mm?] linux-next test error: WARNING in __folio_start_writeback
To: syzbot <syzbot+0630e71306742d4b2aea@syzkaller.appspotmail.com>, 
	joannelkoong@gmail.com, David Hildenbrand <david@redhat.com>, mszeredi@redhat.com
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-next@vger.kernel.org, 
	sfr@canb.auug.org.au, syzkaller-bugs@googlegroups.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ua5dp1k97fdmoypb66w3d6sq6w4qdn4b
X-Rspam-User: 
X-Rspamd-Queue-Id: B4E3BC001A
X-Rspamd-Server: rspam01
X-HE-Tag: 1756302328-319166
X-HE-Meta: U2FsdGVkX18fLGgybsmIuwk/ACm5DE2Jv3JJsevAHbZawJFLKM8zTolaGMRmh8JT2Y/lh/7AEanE9t3wOnA1osl04KUzUgQtA4hORNpOgDLZspiYUd3hvaxxXmJ09LwAyZ/rnUW9cg5+h3Ej402mT8dIaQkn2k5Vd1JybBvFkHnq/+SX10eS6qAWnPVCrh005U3SD2PG6m4DEeC1O2VzBh2YYezm5vfM9vngvN0DD/luJbrVVhf57VG+THYosQdondlUkGkjl/PCRCXqodKjc4QWvAdahTvGN42ck1y9RTczKq+BHn8Kz4AzcDJ0kNM9pfHMo1djx7lYzZuXgOi2mvrYdBUWUU9hpcPlZwF6UtKmQT85oV9nTruH0cLXu0Gj1wPFdNa85DeVc8A/YaJDe6hFdtx3udLlmfj/pQ1OBMUl4yVUdAEutAvDsIqoR8nrdXxe2sjq19y4q8dokgHlGQHhX1f6LsAO6fYsgrCmPUrhmpCbktV5PWxqsptUnC0heLKv+N75kB0U4Qls4NW5HjPP4cffBtJQ8TpEmbuUj2an7uLCvBs1SgD6jTLoEo+hGzKCSqpkc6+tujjew0IgM9nS1qrWAZslL9dh9fAQPirrGAErHV3S3Mreq3eOkcRtD6KCOFaZqnDW/xJyK7Uht+kgXMJXUqTfKP9B2uttg+xQen2urMNuHmAUi/jkmm+2SOWW49w0JdMZkPlxzogPLtLHcZ5xcDJyWkiOb/CJm+cD8hvbUj8v8uA3rQ5ovsW63Q6TZy9j7mI769pmFGwIoU9eeu44rG6II4xhM9GNDJUyAEM0ttiosj3qdzMNjoqR5gFwyPe6/+DF5imOJozj6eAcQ6SHhsoXwb8v0rY2FaMgKCG5TJQkAQirbNgqw2d1h0kHcozAvcbph8unPgD1Q5rhwaxaTRbBZQqsm8hzBftV/GQvRC13kZ0n/YbzPhzXpwJykX+5zb72+AgUdHE
 ybw6+Tj3
 CDzQsHvC2Ie7O9lG0tsZrVVlQNJNQNvcVncU5n6Ge9klruMFGYZmpjkCdpLFnq7x/AIDdp3Kt7OGr0cw4Bi8V41RluKB6ehKS6KgS2d7sjvOSFRDzWqBeFqGRbi55h8wAGwzbvMAl11r0d9DQm1WGz2BA522OtBoEuuy5TdvYteM7GPmxC5BphPBWUzcXc7Z5nb4e/0EVEkyiItVPqwfbvEa/lfF4PoWragMMai2QZhRRY9qhi6twE3nqoUjTJcyh9P5YhDhcJ7+aWc97XvRfVpfjslXxfe4A264lquxY7q+AM+i6+j2JyX+9FhgESx2ja/QBdvdTx3IBDFrKk3xMgxZKgv2ujSYPFVUa8+9k+JZj/WU6p/dAAZxGLQ+vwZSUUlVlfPIzKcNRs/fc3f+54QLkViAaSqMGFsuP1gbC41Y9OQylnVuASf1QKUyz96bnm6KrOp2BmyLm/7vjsmomeo83w5tlM8Nf70rvJs3mCxz9IQFTLY2htFpSB9BpEYiNEuTpnfRhpSgcfK7YKlSU0HqkVgrkJZTU2PVw02VbWu466AdXQJa/BjZPojEGkLISYpLkPKOzjjKyptogMrVHzndCaojVURNSqFOTCKVFHyV2Sf1jRddKE9Tl7ApiPjk64X6ws5BlYpcJros4U2J2byPqpKodyd11JXJE1ML87/k6BaQVBCFyVwdUijzoP7qiGLdJwD4pigWvv/tOjJaWoZiM+aUazPNRhGZXLLsFSvU3zW87TbLLq9QSwyMOMVn9y0JAYXbpdjt9VA/xYmqdZRwzT1k1DDjSTY/5obonsL5Mhzt0oQqKFh8tE51OK62+hbPxR0B9R4AeuUXJppve6yWimp/FTzsMTTBTDBXfK10co9LFInPTolFsKBZKpwLNvcI2upSZowV4EnY6VaNiZyNdg+A8YmD7GsoBnBYUH/96JkHwVh7WTp9mohQrxTKgq/nzMTREuLwMa0qQ07iLmEkMq26u
 Ue4ZYNIa
 Ph9A0DKJyDl73PHNBxQKA2cHM/Bz8Hrnwgu1aqXd3MWCvjnXQJ9RRsJdv1WXzZfe7eBxwtglw2MnHkLSFMSgVMUjF0S1Lgag
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I've bisected the problem to the following commit:

commit 167f21a81a9c4dbd6970a4ee3853aecad405fa7f (HEAD)
Author: Joanne Koong <joannelkoong@gmail.com>
Date:   Mon Jul 7 16:46:06 2025 -0700

    mm: remove BDI_CAP_WRITEBACK_ACCT

    There are no users of BDI_CAP_WRITEBACK_ACCT now that fuse doesn't do
    its own writeback accounting. This commit removes
    BDI_CAP_WRITEBACK_ACCT.

Joanne Koong, could you please take a look at the syzbot report below?

On Fri, Aug 22, 2025 at 12:09=E2=80=AFPM syzbot
<syzbot+0630e71306742d4b2aea@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    0f4c93f7eb86 Add linux-next specific files for 20250822
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D172c07bc58000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D21eed27c0dead=
b92
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D0630e71306742d4=
b2aea
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f604=
9-1~exp1~20250616065826.132), Debian LLD 20.1.7
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/669ede8f5d66/dis=
k-0f4c93f7.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/50feda89fe89/vmlinu=
x-0f4c93f7.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/317a0d3516fb/b=
zImage-0f4c93f7.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+0630e71306742d4b2aea@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> WARNING: ./include/linux/backing-dev.h:243 at inode_to_wb include/linux/b=
acking-dev.h:239 [inline], CPU#1: kworker/u8:6/2949
> WARNING: ./include/linux/backing-dev.h:243 at __folio_start_writeback+0x9=
d5/0xb70 mm/page-writeback.c:3027, CPU#1: kworker/u8:6/2949
> Modules linked in:
> CPU: 1 UID: 0 PID: 2949 Comm: kworker/u8:6 Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 07/12/2025
> Workqueue: writeback wb_workfn (flush-8:0)
> RIP: 0010:inode_to_wb include/linux/backing-dev.h:239 [inline]
> RIP: 0010:__folio_start_writeback+0x9d5/0xb70 mm/page-writeback.c:3027
> Code: 28 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 ff e8 ce a2 29 0=
0 49 8b 07 25 ff 3f 00 00 e9 1b fa ff ff e8 7c 04 c6 ff 90 <0f> 0b 90 e9 d6=
 fb ff ff e8 6e 04 c6 ff 48 c7 c7 a0 f8 5f 8e 4c 89
> RSP: 0018:ffffc9000bb06ea0 EFLAGS: 00010293
> RAX: ffffffff81fad344 RBX: ffffea00050de8c0 RCX: ffff88802ee29e00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc9000bb07010 R08: ffffc9000bb06f97 R09: 0000000000000000
> R10: ffffc9000bb06f80 R11: fffff52001760df3 R12: ffffea00050de8c8
> R13: 0000000000000000 R14: ffff888023060880 R15: ffff888023060660
> FS:  0000000000000000(0000) GS:ffff8881258c3000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f7354907000 CR3: 000000000e338000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  __block_write_full_folio+0x75f/0xe10 fs/buffer.c:1928
>  blkdev_writepages+0xd1/0x170 block/fops.c:484
>  do_writepages+0x32e/0x550 mm/page-writeback.c:2604
>  __writeback_single_inode+0x145/0xff0 fs/fs-writeback.c:1680
>  writeback_sb_inodes+0x6c7/0x1010 fs/fs-writeback.c:1976
>  __writeback_inodes_wb+0x111/0x240 fs/fs-writeback.c:2047
>  wb_writeback+0x44f/0xaf0 fs/fs-writeback.c:2158
>  wb_check_old_data_flush fs/fs-writeback.c:2262 [inline]
>  wb_do_writeback fs/fs-writeback.c:2315 [inline]
>  wb_workfn+0xaef/0xef0 fs/fs-writeback.c:2343
>  process_one_work kernel/workqueue.c:3236 [inline]
>  process_scheduled_works+0xade/0x17b0 kernel/workqueue.c:3319
>  worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x47c/0x820 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup
>

