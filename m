Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55446C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 06:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FA056B0005; Mon, 29 Jun 2026 02:27:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D1346B0088; Mon, 29 Jun 2026 02:27:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E76E6B008A; Mon, 29 Jun 2026 02:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E45BE6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:27:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B3638F255
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:27:56 +0000 (UTC)
X-FDA: 84931969752.21.C2DBF46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9DB211C0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:27:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XUoHVk1I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782714474;
	b=hY4bM0RRkR979USvUcLh4itGOzGpIZpBEqFUfmlSI2vqNX+hJ+pRkrcw0HBdkvZzlX7uMw
	WzJ22ngjNxBXo00JFvMGA5LclO8d8LrK5OqS83KuyT2W440cvFTZXOt9woQt3iKi0P2mtI
	eO6aBYDkqN53Q+YG6xqHhJkFtpst7lk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782714474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8diiuVvstmh7e4zfvwC2TUp3d+EiAMlelXELW0j1hjI=;
	b=iBjh1xTeAEaoXNKShCYYGg/jHSAH9LsxEjMRJdg3f0H8PTyChXFjwH2MjY3RUFY3dJt1P4
	i3VkJzrlk+M3mRRPAxq/jLPHeq/nAH0B0VpyI4OLLfeG1RnTKCN9qgoE9fBtJCzHmzRFH+
	dktdXLMPAP5xXiepUD8/9JbLRKAHKs0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XUoHVk1I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 35DB96001D;
	Mon, 29 Jun 2026 06:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E361F000E9;
	Mon, 29 Jun 2026 06:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782714473;
	bh=8diiuVvstmh7e4zfvwC2TUp3d+EiAMlelXELW0j1hjI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XUoHVk1IkDHpBf/rl1gBmvmCwGQXinaUwLcSEq8EvP3XGURvE/T00WCGDMaDt9/Ha
	 ClQlj6YrvXnwFi6pa2mQYOM69K0jgcIK24NBAjAk1+JOm9DWkAutR2dsUeNNtxdbOS
	 gq6WMK/Zz9vb8+mVM4lzCx0LF/BC84Lgwd/AsqDWo8s/l9nG/cgz1D+Fus+SQXB8qq
	 dQ3FWrXaWWDEyfbHi5nHuqSMBPSjfaebnbmkQU+g27mXs33Jn4cPRbf/4AiRWt25Ro
	 LeieO9Rj3+pCr4LnifXrjcDB2MgHMmur19W0Ki1FDuerhlZKi1gNC92u45zL7+GBLo
	 4azJoKnYhHOwQ==
Message-ID: <85cf5045-b52b-4aaa-a038-ca1b856b55f9@kernel.org>
Date: Mon, 29 Jun 2026 08:27:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING in usb_free_urb
To: sanan.hasanou@gmail.com, vbabka@suse.cz, akpm@linux-foundation.org,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 harry.yoo@oracle.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: syzkaller@googlegroups.com, contact@pgazz.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org
References: <6a3eeead.7fb353d3.354599.b0b0@mx.google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <6a3eeead.7fb353d3.354599.b0b0@mx.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9DB211C0005
X-Rspam-User: 
X-Stat-Signature: gt6mqm3uw9xwb7peiq7h1idaxkxwg6s6
X-HE-Tag: 1782714474-735047
X-HE-Meta: U2FsdGVkX18wW2TWQJMpSdgzinFY3PzUFin9EKsVkF553yD0uQbCdMFforlNCw7UESBDlAIOWESU3tECZjAfKMfQsyUDNio6HNoRwXFMAl3M7SxGvbixsHZSdR5HsPukcmWX/LOG+CTZzTmkqAtxwEhs2f4aabXtiXopolVoQ0Y8biOXfc1cxGN05GHZ5buC6MZPPjevBAnj+ycvtg8VVx7hhA+Dd4W1QXJTEN90CPmRAgjp623CtolCm7GTb7p6hxHX1af5UIPaoek5M+IBRZpU06MZEaj6oQN9ktKUwU2j4YUXHta8Ij9AbSlRO9wjQo7TVY3Cqf1p7G92FhfCIjm16fEr0RU3qtHOk3pSnSb/njnj+L5xAumrKYtO2EhMfRxb6NZxmka03lIF7eoPN0//cGNUAok4T0XyIsfuZ1nc2r2gNBz8twkzW6UJGZ4ibXhtsKLh4cOagTwodVuzV1guZyZrpBFk9I6AnPy85wRvtWwp3Pdtpn/4CHYIj8ChRDcIbg7g2ydhC6mZhMJr7Qd44hJT+JFnH5jUBa2usFUPMJ8xFbFQjgCZXomJer7zgrRH9aEEEoExmv5tLMz0wrj3Sn1/By0RXRPIKHThqvMmBUW0BxvJxuVYa2+az1l1jYS8CqXiaYjbfdVJEQ5xdqI32Vk7XXPnj9/y2xiqRVHXinp2vTbfB0IiwsgTAXGmlVIaiSrSTKF6rOGpuCVE5MMkUbRQi6TS7Qlmwcv2DICix8ZZIljudc3MpAI3vnvvL5BoehfD3zwXDE3e+b9C3bKy9myG3KenguFDG3azs9Q6Hp70Bekg4c0YYBbImPWpLTBNP/VRN6HagX0qUo1Ina/nfeF1o+/NoJtHK0tWN1V/XVSJyg88nowTLBQNMwR7fSYkVt7bXxV79N5aLiG7W0TawdOyS5guEb+tQ7AXPLy5F+L5PSysY7S1OnVsu4jfI+tn1x2WEZHQlyTuw5Z
 VsJgu2hx
 SCicKe7+78VadxP4NRa9Rc7uIsUdGV+ik44Hd9k6aCYO9bHN5Mw9XQy51G4Bn+iu0dsj8gocwkp20x67jp8LgbhBcNBOZg8epUReHoJQG3RVKu+Zb1TDZkLAwJusB2Sfjee1HD2Cb4ZmDXR5eLdiXb6Yp8zwZDEwoco/RF4mc55J2hllKeWvwImej8wDhR0hB3g409FwXq9tGkLSQIaBee9vCBRNWCBQDbtaalV8NlC3dasPmI/uo5YSZztzbLH2/dnQMNDl9bFaq3oGf1CSnPToUJv7J/z3QMgmQUNb9oPHi5l5Yz0wMVjI11ZV8wNrWXVpCiiWlHW/eZ+jK6VGwsfJkHWNKydzaCp2LgZlF4uplToa1d+HHjNjZnf0GX7xN2nCkO8Hx+ksajMNkxITAj0Vy4cxuEC98gOviJSOmdJuSxZ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 23:27, sanan.hasanou@gmail.com wrote:
> Good day, dear maintainers,
> 
> We found a bug using a modified version of syzkaller.

Subject says "usb_free_urb" but you only CC'd slab maintainers, where slab
slab is most likely a victim here of e.g. double kfree() or a kfree() of
otherwise broken pointer.

Ccing USB and EM28XX maintainers. But they can feel free to ignore this per
the next point.

> Kernel Branch: 7.0-rc1

Why use such a version for fuzzing? rc1 will have many bugs that are already
fixed in 7.0 final. And it's not even latest, 7.1 was released 2 weeks ago too.

> Kernel Config: <https://drive.google.com/open?id=1zJHAs5GUroGFBkxAlzfDaWAd_NVPZTfJ>
> Unfortunately, we don't have any reproducer for this bug yet.
> Thank you!
> 
> Best regards,
> Sanan Hasanov
> 
> 179683 pages reserved
> 0 pages cma reserved
> Memory cgroup min protection 0kB -- low protection 0kB
> ------------[ cut here ]------------
> !PageLargeKmalloc(page)
> WARNING: mm/slub.c:6352 at free_large_kmalloc+0xb3/0x160 mm/slub.c:6352, CPU#1: kworker/1:4/12317

A kfree() was attempted on a pointer that's neither from a slab page nor a
large kmalloc page. Might be double free or corrupted.

> Modules linked in:
> CPU: 1 UID: 0 PID: 12317 Comm: kworker/1:4 Tainted: G             L      7.0.0-rc1 #1 PREEMPT(full) 
> Tainted: [L]=SOFTLOCKUP
> Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> Workqueue: events request_module_async
> RIP: 0010:free_large_kmalloc+0xb3/0x160 mm/slub.c:6352
> Code: 25 00 00 00 ff 3d 00 00 00 f8 0f 85 a6 00 00 00 c7 43 30 ff ff ff ff 48 89 df 44 89 f6 e8 45 d9 fc ff 5b 41 5e 41 5f 5d c3 90 <0f> 0b 90 48 89 df 48 c7 c6 b7 4c 72 8d e8 cb e8 08 ff eb e4 90 0f
> RSP: 0018:ffffc900028e76f8 EFLAGS: 00010287
> RAX: 00000000f0000000 RBX: ffffea00019a5c00 RCX: ffff888067550001
> RDX: 0000000000000000 RSI: ffff888066970000 RDI: ffffea00019a5c00
> RBP: ffffc900028e7710 R08: ffff888049c40603 R09: 1ffff110093880c0
> R10: dffffc0000000000 R11: ffffed10093880c1 R12: ffff888066970000
> R13: ffffffff870bc0f1 R14: 0000000000000000 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff8880ef136000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fba7e4bf008 CR3: 000000005776b000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  kfree+0xae/0x630 mm/slub.c:6437
>  urb_destroy drivers/usb/core/urb.c:25 [inline]

static void urb_destroy(struct kref *kref)
{
        struct urb *urb = to_urb(kref);

        if (urb->transfer_flags & URB_FREE_BUFFER)
                kfree(urb->transfer_buffer);  <--- this one

        kfree(urb);
}

>  kref_put include/linux/kref.h:65 [inline]
>  usb_free_urb+0xd1/0x120 drivers/usb/core/urb.c:96

USB layer itself is likely also not the root cause.

>  em28xx_uninit_usb_xfer+0x165/0x310 drivers/media/usb/em28xx/em28xx-core.c:833
>  em28xx_alloc_urbs+0xf2a/0x1130 drivers/media/usb/em28xx/em28xx-core.c:-1
>  em28xx_dvb_init+0x2b0/0x4a20 drivers/media/usb/em28xx/em28xx-dvb.c:-1
>  em28xx_init_extension+0x121/0x1d0 drivers/media/usb/em28xx/em28xx-core.c:1117

So it might be this driver doing something wrong?

>  request_module_async+0x5e/0x80 drivers/media/usb/em28xx/em28xx-cards.c:3457
>  process_one_work kernel/workqueue.c:3275 [inline]
>  process_scheduled_works+0xae1/0x1800 kernel/workqueue.c:3358
>  worker_thread+0xa0f/0xf70 kernel/workqueue.c:3439
>  kthread+0x37d/0x470 kernel/kthread.c:467
>  ret_from_fork+0x507/0xb90 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:245
>  </TASK>
> 
> <<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>
> 
> Modules linked in:
> CPU: 1 UID: 0 PID: 12317 Comm: kworker/1:4 Tainted: G             L      7.0.0-rc1 #1 PREEMPT(full) 
> Tainted: [L]=SOFTLOCKUP
> Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> Workqueue: events request_module_async
> RIP: 0010:free_large_kmalloc+0xb3/0x160
> Code: 25 00 00 00 ff 3d 00 00 00 f8 0f 85 a6 00 00 00 c7 43 30 ff ff ff ff 48 89 df 44 89 f6 e8 45 d9 fc ff 5b 41 5e 41 5f 5d c3 90 <0f> 0b 90 48 89 df 48 c7 c6 b7 4c 72 8d e8 cb e8 08 ff eb e4 90 0f
> RSP: 0018:ffffc900028e76f8 EFLAGS: 00010287
> RAX: 00000000f0000000 RBX: ffffea00019a5c00 RCX: ffff888067550001
> RDX: 0000000000000000 RSI: ffff888066970000 RDI: ffffea00019a5c00
> RBP: ffffc900028e7710 R08: ffff888049c40603 R09: 1ffff110093880c0
> R10: dffffc0000000000 R11: ffffed10093880c1 R12: ffff888066970000
> R13: ffffffff870bc0f1 R14: 0000000000000000 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff8880ef136000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fba7e4bf008 CR3: 000000005776b000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  kfree+0xae/0x630
>  usb_free_urb+0xd1/0x120
>  em28xx_uninit_usb_xfer+0x165/0x310
>  em28xx_alloc_urbs+0xf2a/0x1130
>  em28xx_dvb_init+0x2b0/0x4a20
>  em28xx_init_extension+0x121/0x1d0
>  request_module_async+0x5e/0x80
>  process_scheduled_works+0xae1/0x1800
>  worker_thread+0xa0f/0xf70
>  kthread+0x37d/0x470
>  ret_from_fork+0x507/0xb90
>  ret_from_fork_asm+0x11/0x20
>  </TASK>
> Kernel panic - not syncing: kernel: panic_on_warn set ...
> CPU: 1 UID: 0 PID: 12317 Comm: kworker/1:4 Tainted: G             L      7.0.0-rc1 #1 PREEMPT(full) 
> Tainted: [L]=SOFTLOCKUP
> Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> Workqueue: events request_module_async
> Call Trace:
>  <TASK>
>  __dump_stack+0x21/0x30
>  dump_stack_lvl+0x2b/0x150
>  dump_stack+0x19/0x20
>  vpanic+0x53e/0xa20
>  panic+0xb9/0xc0
>  __warn+0x320/0x500
>  __report_bug+0x28d/0x500
>  report_bug+0x175/0x220
>  handle_bug+0x9c/0x200
>  exc_invalid_op+0x1f/0x50
>  asm_exc_invalid_op+0x1f/0x30
> RIP: 0010:free_large_kmalloc+0xb3/0x160
> Code: 25 00 00 00 ff 3d 00 00 00 f8 0f 85 a6 00 00 00 c7 43 30 ff ff ff ff 48 89 df 44 89 f6 e8 45 d9 fc ff 5b 41 5e 41 5f 5d c3 90 <0f> 0b 90 48 89 df 48 c7 c6 b7 4c 72 8d e8 cb e8 08 ff eb e4 90 0f
> RSP: 0018:ffffc900028e76f8 EFLAGS: 00010287
> RAX: 00000000f0000000 RBX: ffffea00019a5c00 RCX: ffff888067550001
> RDX: 0000000000000000 RSI: ffff888066970000 RDI: ffffea00019a5c00
> RBP: ffffc900028e7710 R08: ffff888049c40603 R09: 1ffff110093880c0
> R10: dffffc0000000000 R11: ffffed10093880c1 R12: ffff888066970000
> R13: ffffffff870bc0f1 R14: 0000000000000000 R15: dffffc0000000000
>  kfree+0xae/0x630
>  usb_free_urb+0xd1/0x120
>  em28xx_uninit_usb_xfer+0x165/0x310
>  em28xx_alloc_urbs+0xf2a/0x1130
>  em28xx_dvb_init+0x2b0/0x4a20
>  em28xx_init_extension+0x121/0x1d0
>  request_module_async+0x5e/0x80
>  process_scheduled_works+0xae1/0x1800
>  worker_thread+0xa0f/0xf70
>  kthread+0x37d/0x470
>  ret_from_fork+0x507/0xb90
>  ret_from_fork_asm+0x11/0x20
>  </TASK>
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
> 
> <<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>


