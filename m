Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E76AEC982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 05:45:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64526B00DB; Mon, 21 Sep 2026 01:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3B476B00DD; Mon, 21 Sep 2026 01:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A78066B00DF; Mon, 21 Sep 2026 01:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 805ED6B00DB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 01:45:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0BFDDC0557
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:45:14 +0000 (UTC)
X-FDA: 85236681348.08.2E2546A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1246C1C0003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:45:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OFvC3n03;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OFvC3n03;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789969512;
	b=HKO4+gP6dMOJrPPbrB7X5Vx6NDCc+2HIuUUCZADS+giyCAhsx6r/MOCl8STsxlpB7RonqY
	lD7IOSYDyv9/m1+Yu46qqPXBMV+H7rowmHlyZaiTHas2ujnLi7aIdnbD62dqXSWm52QjxJ
	6cFnStpb6GMYAEfF/uVtB7RXauuribU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789969512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hk23fiq0KZ1f/Xix9GdF5C6Z3buHI5adbp760BxRcJM=;
	b=B54+u+mqkUbVGSZAOvOfG/3jx2YI/RVMRho/Mkjiyg1xNagRZ1D/GBLgyU45917UZo209E
	BJ+QfxFjyy7k4r0aKtgOaObz5u+IgEG1UaYrZqrGGqboJqySCPi8nYvE6ja3BMJi7XmLzW
	wDaIRUtbSNzWimpwbBSe9uCAjzZxoPI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D74D43F7F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4751F0089F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789969510;
	bh=hk23fiq0KZ1f/Xix9GdF5C6Z3buHI5adbp760BxRcJM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OFvC3n03q55ybfelNcS0Cg5OTbPNdnvaSEanmNE1DeZsP+jmrYTMKveGV/+5VC4Wq
	 3M8HIItE6MIibyPAbgljYIJAXQZ+WF/N8xBcsR3ZZoXUmuyHRKQBoDI1+iwxGhpsFz
	 QW6iF2uyg733ZgW9jR5a4z7N5T5Y2MrvrvSl+fqAgSlK9fucNvkOflCIhogk/YhGeZ
	 z/l2/1iZy2f//oz7ZHRHxaQ8FoAUUyMwImD/VSLIZyHZ62/iU942W8twP6GoFD2pNZ
	 1rSXORzJqqQ2FAlHdfyMWXkTYzr5hAum57/zWP5t/vch29IhF9ZswljJ+CAgzcTYvs
	 Z0GmfGTBaBTWQ==
Received: by mail-vs2-f42.google.com with SMTP id 71dfb90a1353d-5c7e8a17839so455252e0c.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:45:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx817H+lcYpC85/M3weSelRIB/rpF0Ky8rav2KMhHGa3/z7gKfDEmfh7q4xOa7pbVrbxXbttkoa3w==@kvack.org
X-Gm-Message-State: AFuF++k4IMV4IvuEyy3lGPBKT3rV0gpycq5BW3ZwMpgjNl8nQdRp4pwm
	R3s7QDhDGgHR8xPWjtx6f6MhCJGlwHaY/K1+Vtz9Id1/s7+R9vLd5A/Tg7l3OmQwnXrqd0hvpJV
	A1+6QugiPR9IciTJRfVfk8803Mj9SF/I=
X-Received: by 2002:a05:6102:424d:b0:798:24e8:23f4 with SMTP id
 ada2fe7eead31-7a55a328abcmr2528499137.7.1789969510003; Sun, 20 Sep 2026
 22:45:10 -0700 (PDT)
MIME-Version: 1.0
References: <6ab08265.71f81b7d.15fa6d.001d.GAE@google.com>
In-Reply-To: <6ab08265.71f81b7d.15fa6d.001d.GAE@google.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 21 Sep 2026 13:44:58 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xnM66UZ-n55AHW4UHn+PSCP7G-gGUHUfSt6MRZGeRnfw@mail.gmail.com>
X-Gm-Features: AcwNN1Vz2PUryz8nxvQr8pMX0aqG4s1oJiLjepSVJsplEgiB83boz4wgOvSfKMo
Message-ID: <CAGsJ_4xnM66UZ-n55AHW4UHn+PSCP7G-gGUHUfSt6MRZGeRnfw@mail.gmail.com>
Subject: Re: [syzbot] [mm?] KCSAN: data-race in copy_mm / lru_gen_del_mm (3)
To: syzbot <syzbot+c6e1b1b32ff2fc3b7d60@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, david@kernel.org, 
	hannes@cmpxchg.org, kasong@tencent.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com, weixugc@google.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 1246C1C0003
X-Stat-Signature: b54o14dkahopn6y7mujzhxspmqq1q73o
X-Rspamd-Server: rspam01
X-HE-Tag: 1789969511-5739
X-HE-Meta: U2FsdGVkX19tHeqEoco3nesbLldgRmHQ+ZK6rKOnjTBJbvz4W0WW2C+Z0o8C3HsfVSaP+TEmtB7GB4gcs72g7x1/xKl7NW25FNxAj2w5eLYIAsL09v8UAmBpl1xmTikbyr4AcJDl5gFwRKkvV6Ce3VJ3xo4Xcmfz3FAtSifHsv2t3T2lMkbIj9TiSLUGRtAgAfq3jjLQ8QmRLVrNyzD/NlBCgoUEHJTXaGs3jJqxy7gGCP2UFpfchPDG+R9lSLjeR0KOu2Ib7j65Ffe5XtNw9UMeYokC7bkTE2cLQ3PYWHy5Nt+UBYBNe76xBBkfTa6u7GJOJG/aAMVmeIdLbKy9ILYrNbena/hFbAHXq/jslsSnqoM8yQcMCWqW1X/hiclhKZlS71BtmWQEKF9VkODtyBvma+6ddpWWnJACzTzGv9YECMs0zlOpcX+wQRFtQToyNsAsKdYlWArPPze0cW6mw4X9BX3f2zDYlXqlCHbRV3+W9//zwiIiCqfd63AhDKxkmpryyKNWYNoRRy85V71PjuIl5GlJF6Op1dHKdg8Eal1ZFxG/SzMGUdUCbTcEBZwIsP+Jff9HPcouWQSjYl+Ikyf08gZ5+zYiSJtoRN1y+jY5t+5dBCKzU3o7SoR8O3h+n4BzQCic+fwIhML3N5j6Sac0Gp2j5cyuNgngqROMaiZgqjHo6eifQxcc7CGZ4hX/WMqjfvoOnkpQWql/QlzyafsVYLU/ov05hmCCif8FkbRY0vEylkR5FtIoQz1IscgxQ+Hg331oMhOh1dlAQNM81dww/zHPl7DUDuIQrFR+roguorzQ8hwJP9J/Nr6l9OcWsPed5E/yAFVwKwqwL24NKYQuGKkNTepvDoEaLraVGJ3pki5PIU5iFsBlbxin+dR23WxkDJOHLsE5P/OZM/85qbt55finOnhqyaGCr8fSJasXupOT5RRyCQRa8Yn4mucuEIDU8JlTdCLU+tcxQpg
 ZMbrpbpy
 Z5EngXGXsaQsCkR++syCvpYZ8QEjlWodNA2J0mkfXAiwknW/Mac3h4kqAfa2NNzyLlFeZQff3V3pfkTTSqv6vyzQ5TTMuoHspkWmzvUUPDzOs0Nwqm1IraLa6VaUWlwpvMBtNn8QEB4ReHTbSz0roLTD+4cA8PdrHrlSF0JUwCLNm5akynQqWJxulkE7cOWm/mb8xSqr0R5ypwcgWu+d0lv7QlSRUMG1hanHsWlhk+l5MVrntjYy3g1x9D/2JPXNs7A15QcQNMk46wFMYymUDNHVpaJ6A/q2D9RI5NbJ1wQTa6b8dz73OpDWEoCu6sOdw2e4uSsGOem/o/FQRU1LM39LPswP1YO9OS9q6tRCEcsHgGFT5hGrWfR6UEH5QvkrfbLwEyR7x+OjJAez1elQ5x75Wy7p0rZOhNAkBy9gnAkL/opvYZHYTXTYkA9IQQbBCx/hbtBCpYccbd7VDWs1/eH+FOg8wD1r30s7Q/aSAfHvugSLouOmA5JRNd0pJ/izt2gccrS//ySFWdKAODK7yQ/zYiekf20FJMAWU6Z13KGw5Dg/kC0yrzKgnsCYsQGG2rYkyRP2kucg2BB21BP5k3RrkaP7CnkJiEOQD8DHA9dEi7gv159ARKmvH2Hjc5x0wxtRkuMtY21iEhAONfxNHaf26ybRw42MPTb057tYhWcXkVI0Kfs+mP5PjOHz7xwap4DO5qRGkA0G2epkTsF7IckMjIdNtM1CsGKm53iiD1DcQtJ28MEd4jl50BFiLWDRiOl5iM6Aetap2fbg4f/LC9od0vapZTBJIzzR0Y3/K6WUxrHi1/75eBdR1k58KJqo6YGLH62JytDXLllF7tY6UgVZ3XYvtBtAVvXCjqx6kN+f9ctUeeSUuZiRS4RdmOaNfxeR0ag8dvmVAcFWIR6/pu5Bjp6z6jeOIHjZKxLVDoCFAk5twtVp715X7U2glOxgMoB5B8VzdlgoiSpuexsrkEms4bbQy
 +Spy075t
 IuA1xdauIw2BKCQMrl7zAJpmIcOTjUmx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 9:03=E2=80=AFAM syzbot
<syzbot+c6e1b1b32ff2fc3b7d60@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    17e7b8eacf4c Merge tag 'cifs-fixes-7.3-rc4' of https://gi=
t..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D11d6c52558000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D8372e2cd52628=
d4f
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dc6e1b1b32ff2fc3=
b7d60
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e25=
5-1~exp1~20260613092250.77), Debian LLD 22.1.8
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/60ea54622289/dis=
k-17e7b8ea.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/675e38c8bebf/vmlinu=
x-17e7b8ea.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/1006b8efd827/b=
zImage-17e7b8ea.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+c6e1b1b32ff2fc3b7d60@syzkaller.appspotmail.com
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KCSAN: data-race in copy_mm / lru_gen_del_mm
>
> write to 0xffff8881077eb088 of 8 bytes by task 7336 on cpu 0:
>  __list_del include/linux/list.h:241 [inline]
>  __list_del_entry include/linux/list.h:264 [inline]
>  list_del_init include/linux/list.h:333 [inline]
>  lru_gen_del_mm+0x299/0x3e0 mm/vmscan.c:2998
>  __mmput+0x17a/0x1c0 kernel/fork.c:1203
>  mmput+0x40/0x50 kernel/fork.c:1216
>  exit_mm+0x113/0x1a0 kernel/exit.c:617
>  do_exit+0x438/0x1510 kernel/exit.c:999
>  do_group_exit+0x138/0x140 kernel/exit.c:1154
>  __do_sys_exit_group kernel/exit.c:1165 [inline]
>  __se_sys_exit_group kernel/exit.c:1163 [inline]
>  __x64_sys_exit_group+0x1f/0x20 kernel/exit.c:1163
>  x64_sys_call+0x254f/0x2550 arch/x86/include/generated/asm/syscalls_64.h:=
232
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x112/0x360 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> read to 0xffff8881077eaa00 of 1728 bytes by task 7337 on cpu 1:
>  dup_mm kernel/fork.c:1537 [inline]
>  copy_mm+0xd6/0x340 kernel/fork.c:1595

I guess all we need is:

diff --git a/kernel/fork.c b/kernel/fork.c
index 22283bf849e1..696021c459d9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1532,7 +1532,7 @@ static struct mm_struct *dup_mm(struct task_struct *t=
sk,
        if (!mm)
                goto fail_nomem;

-       memcpy(mm, oldmm, sizeof(*mm));
+       data_race(memcpy(mm, oldmm, sizeof(*mm)));

        if (!mm_init(mm, tsk))
                goto fail_nomem;

As we don't really care about the data copied by `memcpy()`, since
`lru_gen_init_mm()` will reinitialize the lru_gen state in the new `mm`.

static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *=
p)
{
        ...
        lru_gen_init_mm(mm);
        return mm;
        ...
}

static inline void lru_gen_init_mm(struct mm_struct *mm)
{
        INIT_LIST_HEAD(&mm->lru_gen.list);
        mm->lru_gen.bitmap =3D 0;
#ifdef CONFIG_MEMCG
        mm->lru_gen.memcg =3D NULL;
#endif
}

>  copy_process+0x10ad/0x2340 kernel/fork.c:2310
>  kernel_clone+0x1c0/0x5f0 kernel/fork.c:2769
>  __do_sys_clone kernel/fork.c:2911 [inline]
>  __se_sys_clone kernel/fork.c:2895 [inline]
>  __x64_sys_clone+0x143/0x180 kernel/fork.c:2895
>  x64_sys_call+0x2479/0x2550 arch/x86/include/generated/asm/syscalls_64.h:=
57
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x112/0x360 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 1 UID: 0 PID: 7337 Comm: dhcpcd-run-hook Not tainted syzkaller #0 PR=
EEMPT(lazy)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 07/24/2026
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Best Regards
Barry

