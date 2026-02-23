Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9325EC110E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 17:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 237796B0005; Mon, 23 Feb 2026 12:18:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218D56B0096; Mon, 23 Feb 2026 12:18:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 145A76B0099; Mon, 23 Feb 2026 12:18:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F01896B0096
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:18:41 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6799C1338
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:18:36 +0000 (UTC)
X-FDA: 84476380632.14.BB9E28E
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id A9F9D1A001E
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:18:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Ia2NZLvQ;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771867114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qXwm4BvBP2UBJv0zqzFl0pkFiiw+bxAXt6eY/QjyFkU=;
	b=4x/iajY6Ni5EYbgNWLoam0w+MbkvOU65OpjeXy4ovRbpsNbztQBBd/lG3rCODH5U0WOOzj
	OV6jld8jBAtbeGIAQVX2SPcFuLOOiP7hgF+N0Rp2hRhPyNUQZBZjEEyED01wNARZV7s3dU
	2Gtj8o9fToa5QKf7IfX1h/85gimp+WM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Ia2NZLvQ;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771867114; a=rsa-sha256;
	cv=none;
	b=4uNa07F43j/ZTUvWMqVH1Vo80u7/8HsMw8MD7+l7J/f9PuPbhOAS3tI2Kzfk/YDJI43t31
	ajmblxxMXR7F0QclNFuSiVVb2sqTGV4+PHcTEXIKMI3fvod0Z53jOus6jlGaYjrdXVnrBc
	W13bLEWLYiVdGG54neSTEO05NWk0jHI=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4806fd9033bso6223155e9.3
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771867113; x=1772471913; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qXwm4BvBP2UBJv0zqzFl0pkFiiw+bxAXt6eY/QjyFkU=;
        b=Ia2NZLvQMMlaxKw2c4q96MyEBWkouYgXV1FuiD25wBZSXSHqqA3HkRjKW67QT3kia2
         lFvHE14rLFkOvt7RWwzAe8a8BpgQLyX6/6nKzzA6tPHbaYvfKjLto/IQXeRwMZaS5YAf
         LHdV9SVpHtDcG3VvhnyVDjIHGWseqI3TojFl4bhDuGRZz9PXZxdv09rXUndjHe9v3Si2
         UZHTbnaXYPhyfJBFAuowUyHVhipV3ejvqRc+PsmSJfpoL4dDEZz9WFIV8vPgKxGPQ67F
         Kp/y534hDNgJH5IeoTlN2C1zDir0MYg/+xsSbbAbVmUVlF4nWnVMxmxanH97ZbNZFJOO
         Zi7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771867113; x=1772471913;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qXwm4BvBP2UBJv0zqzFl0pkFiiw+bxAXt6eY/QjyFkU=;
        b=VmsricxZ2xImGg8uIcN6ZXz6+H92RJTyPrQzi5M3o6I0ZxGcLWMLdzj8LBiCJ2NLQo
         LJT6IJ82KnkjbwGwDC63OjUrRa8SE8wJugFyQCZWkaiIbAI9jK7Nq+7QRmLugJOWkDDU
         ub+nEg/Mz7RJ/j90YzoqYU5n5PEkrS6L51gvevh7E6CCfuHI7nP6VZU7pKmc+a/ZecR9
         JLutgnXoTNSWWGCjFyfM4yVgPM1vY2tKZqYgOx8uSXdPBcYESNOCJEhsrDv92ycgGFuu
         1gW1RL+69vDUJ1Rue39OYwdsVNAVqai6VCbNKh/NgwIl46FfuDvltavHr549v3xeNdE3
         VPrw==
X-Gm-Message-State: AOJu0YyADOZKGLyyw+pTODX10UdBbxPSQnuGQ2lGceIhRI0EsQT0VO8G
	sQYGWdLI/Vvbvd0OUc9MCmf8maH0b2ONeaxOUQKLQmdefnrKUn9z7i5kBscgPQ1EiUQ=
X-Gm-Gg: AZuq6aJDCbk7UInN0orkaoGeYZw52ryUhzSic/cUSutvOfMUJfAab8GLg+JaY0P8LgO
	B3DtRnrJ2rECdbaKDMzdpX9zDVyLqpvoBrHf9AU9UtaydrKG+9vm0i+osj/odVHyf27MwIcO2Vd
	Bqazf0R+BIXFzpbn15YN4XIwCSBLSlzr3f7ryU/brjrVI0sS6wTT2bjfpGiHRryPw5aI+nleI8Z
	jrC6HW4QkApt27tJdaf07e6EGuYH/O7cWJ58uLa5iAUNuV8l9vCnsz7K7Dj/mRM371koJ1Uoeo6
	iv1Q0HFj6qrL0J1BIOPykwvR1+aNCJz0XW+R1qek6wOhZG1bswDtKEhW+6MaoIZe5/jdWu3bF+F
	uGNlMJp8Lg9G70CRILniod5kkjNXlBrz4Ytn/JVrlpc3k9Gm7insXVuyYzFIgq8W5EeypREA0FX
	bncGVuBnsvSkSNTqcfpQ==
X-Received: by 2002:a05:600c:154c:b0:483:7631:befd with SMTP id 5b1f17b1804b1-483a95fc285mr92715365e9.7.1771867112959;
        Mon, 23 Feb 2026 09:18:32 -0800 (PST)
Received: from ?IPV6:2001:1a48:8:903::e14? ([2001:1a48:8:903::e14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a9cb3de5sm222425635e9.12.2026.02.23.09.18.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Feb 2026 09:18:32 -0800 (PST)
Message-ID: <6ca5f70c-43c5-4ba3-bdc4-8c48607dbe7c@suse.com>
Date: Mon, 23 Feb 2026 18:18:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [7.0-rc1] codetag: kernel warning "alloc_tag was not set" during
 boot
Content-Language: en-US
To: David Wang <00107082@163.com>, surenb@google.com, vbabka@suse.cz
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Harry Yoo <harry.yoo@oracle.com>
References: <20260223155128.3849-1-00107082@163.com>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <20260223155128.3849-1-00107082@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: A9F9D1A001E
X-Stat-Signature: ti67h6xezoiaqbx9sdzahmk1jnoisayk
X-HE-Tag: 1771867114-384115
X-HE-Meta: U2FsdGVkX1/XB2//3Rwti4XvuUyB+4tWhWghBeBAzhk9VbVHGv/RL7vhDBQmwWbMlyvZisQIEpWBx9alN+wbiwnt0Qe+rlVoliave4fAYzZXji9yoFOAR6Hsh2avGC7DaqI8pDT9zJAvHzfLzkiTdd1msC0pnl23DVZ7yCp6qChbTml1ALAv8zUYEtliW2HrBS8QxRrmmpIVyRM5qil6H50uyuEgLxtOZyhIdLjsi1RMmJDYE2IPif7sg5s+f+IrVuhjp1/uL5/sqvUqgGaQO+5wZUE8J9U4U7KOwGP2NCeXO24Jax1aNG6amndOMNYb/KamqeYUmuSKx+dd16ckS5SsOC0N2Gu3rrBqxMU+e9xbDcyf3ReVJMyIw+E6zjEYOS6ApFIPtm9Rlbo+VtsETVbJsdi8/sfq/pG7d75ejdZM26GcHAQshI1SvZe5xuamUb+BNLt0jczFBO45RoNet5poVL/CyIdim2JUa42oDAsHj1mSn16LFnNJfsSqGp8dfvZKO5CDnN421mGtUmZhEFyuqOiS1wMKOAvDjcb1r7GZ1nJAf2WpOElEMoOfuY9uHv9RLJU3glG+7Fmb4dKfdBl7tvRQVTeWytPL64fAaebd12IKj17+aMfjg98ZKAMgcklXZpJBhzRzFrIBbgsnBIuQkZasN1WQnQnUDBCemzx3xWuo1XTJv5N8DqgOsV/PgdAGWY4W/6vSgWLVcScWmOE7x9EIGkMGHzueonT+sJtKNzhC6rxFU4bUpiiZHIybanJoIi7XkMFe3L+Qbgbs57BIlM8H7GQKfOlQOENH5FWbC5v9LBScB1BqxtkT5WkplLJw1ZYm0cMNMnON/ccel0SUNbkOV9OLmJNK59OfhuvviN2lRLJkvu7HctE86jaXQgMthElc1hjRLgMWSz7b/ZV6trpsvCRpU0XSYXjPXH+i8YZ9sEaX9OpeEp/v9xqk4SyfMPalucWR9JZ0Fd0
 /Db9L+BN
 10Yl7GvN3W5Oy39k6ZLxCijTu4sa4MnMEsg2fP6c+5q0oCFA6d7ordOepwmT7qvXwrAk2Lg593arzz/vgdc6mCKgyT9hLUBq59yIEmhpfVBhaso9BW9Wxpm0WUpTkP6leE2/38rdft0rzPmF04cvpZwpfdYlaVgJCVQ0+CIDLxYdrGqodjboIBx6iX+cV8UObbhXQM3ibKoMz2LIIethboKzoakczgZ6bU0gfY5Ml3iM3jNxpMgO1OMNQMSwbIHTdFiWZUQJ1lYlH9+15oIEQPMTD7NBXNF6u8K15Lq5cyJgihXAy1VQ02ZBQWauV0SqA+eI5el6mQl/CNztalwjRE/wSX0OYymhpSQXOAggUbKxsOtrMW7zGCrMCV5YjnjOi0Wf08hPa5BkTZPUlY2duezHLddLyKs287UiABd2EcL6uQw5rI6/MEClsGo5VpC/RP9QLGU7KqPnQ/T8qb16a0r52Xjwpk0W0c+kmMnOaKIujdLOirFeep68oYf1ws0l9DNZj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 16:51, David Wang wrote:
> Hi,
> 
> When upgrade to 7.0.0-rc1, caught a kernel WARN during boot:

Would this possibly help? (it probably shouldn't but let's see)
https://lore.kernel.org/all/20260223075809.19265-1-harry.yoo@oracle.com/

> 	 ------------[ cut here ]------------
> 	 alloc_tag was not set
> 	 WARNING: ./include/linux/alloc_tag.h:166 at __alloc_tagging_slab_free_hook+0xe6/0x120, CPU#4: (udev-worker)/145
> 	 Modules linked in: xhci_pci(E+) ahci(E) libahci(E) xhci_hcd(E) nvme(E) sp5100_tco(E) libata(E) r8169(E) realtek(E) usbcore(E) nvme_core(E) scsi_mod(E) scsi_common(E) usb_common(E) i2c_piix4(E) i2c_smbus(E) wmi(E) fjes(E-) gpio_amdpt(E) gpio_generic(E) button(E) efivarfs(E)
> 	 CPU: 4 UID: 0 PID: 145 Comm: (udev-worker) Tainted: G            E       7.0.0-rc1-linan-0 #802 PREEMPT(full) 
> 	 Tainted: [E]=UNSIGNED_MODULE
> 	 Hardware name: Micro-Star International Co., Ltd. MS-7B89/B450M MORTAR MAX (MS-7B89), BIOS 2.L0 07/18/2024
> 	 RIP: 0010:__alloc_tagging_slab_free_hook+0xe6/0x120
> 	 Code: 2c d3 e8 0f af c2 4c 01 f0 48 89 c3 74 9e 48 8b 00 41 8b 54 24 18 48 85 c0 0f 85 6c ff ff ff 89 54 24 04 48 8d 3d da 4e 44 01 <67> 48 0f b9 3a 48 8b 03 8b 54 24 04 48 85 c0 0f 85 4c ff ff ff 48
> 	 RSP: 0018:ffffd28e40278e80 EFLAGS: 00010246
> 	 RAX: 0000000000000000 RBX: ffff8c36422d82c0 RCX: 0000000000000008
> 	 RDX: 0000000000000200 RSI: fffff352840bb800 RDI: ffffffffadc4aee0
> 	 RBP: ffffd28e40278ec8 R08: 0000000000000014 R09: ffffffffac80e09c
> 	 R10: ffff8c3640042200 R11: ffff8c364dca2480 R12: ffff8c3640042a00
> 	 R13: fffff352840bb800 R14: ffff8c36422d8200 R15: ffffd28e40278ed0
> 	 FS:  00007fa2ca8be980(0000) GS:ffff8c39c0c1a000(0000) knlGS:0000000000000000
> 	 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 	 CR2: 00007fa2c9b727a5 CR3: 00000001158cc000 CR4: 0000000000350ef0
> 	 Call Trace:
> 	  <IRQ>
> 	  ? rcu_core+0x451/0x750
> 	  kfree+0xab/0x370
> 	  rcu_core+0x451/0x750
> 	  ? rcu_core+0x3eb/0x750
> 	  ? srso_return_thunk+0x5/0x5f
> 	  handle_softirqs+0x100/0x2e0
> 	  __irq_exit_rcu+0xb1/0x100
> 	  sysvec_apic_timer_interrupt+0x9d/0xc0
> 	  </IRQ>
> 	  <TASK>
> 	  asm_sysvec_apic_timer_interrupt+0x16/0x20
> 	 RIP: 0010:xhci_handshake+0x56/0xc0 [xhci_hcd]
> 	 Code: fa 8b 07 89 f1 49 89 fe 41 89 f5 21 c1 41 39 cc 75 22 eb 3c f3 90 48 81 eb e9 03 00 00 48 89 da 48 c1 ea 3f 44 21 fa 41 8b 06 <44> 89 e9 21 c1 44 39 e1 74 1c 83 f8 ff 74 2d 84 d2 75 3d bf c7 10
> 	 RSP: 0018:ffffd28e4045f9d0 EFLAGS: 00000246
> 	 RAX: 0000000000000002 RBX: 000000025354e082 RCX: 0000000000000004
> 	 RDX: 0000000000000000 RSI: 0000000000000df4 RDI: 00000014243ef470
> 	 RBP: 0000000000989680 R08: ffffffffc0741fbe R09: 00000000ffffffff
> 	 R10: 0000000000000004 R11: 0000000000000001 R12: 0000000000000000
> 	 R13: 0000000000000002 R14: ffffd28e40cc8020 R15: ffff8c3655ac1801
> 	  ? __pfx_xhci_pci_quirks+0x10/0x10 [xhci_pci]
> 	  xhci_reset+0x6a/0x110 [xhci_hcd]
> 	  xhci_gen_setup+0x201/0x450 [xhci_hcd]
> 	  xhci_pci_setup+0x50/0x1c0 [xhci_pci]
> 	  usb_add_hcd.cold+0x265/0x5d5 [usbcore]
> 	  usb_hcd_pci_probe+0x16f/0x420 [usbcore]
> 	  xhci_pci_common_probe+0x39/0x2c0 [xhci_pci]
> 	  ? srso_return_thunk+0x5/0x5f
> 	  local_pci_probe+0x41/0x90
> 	  pci_device_probe+0xd0/0x250
> 	  ? srso_return_thunk+0x5/0x5f
> 	  ? sysfs_do_create_link_sd+0x6e/0xe0
> 	  really_probe+0xde/0x380
> 	  ? pm_runtime_barrier+0x56/0x90
> 	  __driver_probe_device+0x78/0x120
> 	  driver_probe_device+0x1f/0xa0
> 	  __driver_attach+0xf6/0x230
> 	  ? __pfx___driver_attach+0x10/0x10
> 	  bus_for_each_dev+0x79/0xd0
> 	  bus_add_driver+0xeb/0x270
> 	  driver_register+0x6e/0xc0
> 	  ? __pfx_xhci_pci_init+0x10/0x10 [xhci_pci]
> 	  do_one_initcall+0x43/0x310
> 	  ? srso_return_thunk+0x5/0x5f
> 	  ? __kmalloc_cache_noprof+0x143/0x3f0
> 	  ? do_init_module+0x3f/0x280
> 	  do_init_module+0x91/0x280
> 	  init_module_from_file+0xc8/0xe0
> 	  idempotent_init_module+0xfe/0x2f0
> 	  __x64_sys_finit_module+0x6d/0xe0
> 	  do_syscall_64+0xf4/0xf20
> 	  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 	 RIP: 0033:0x7fa2cb41a779
> 	 Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 4f 86 0d 00 f7 d8 64 89 01 48
> 	 RSP: 002b:00007ffe556d6b18 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> 	 RAX: ffffffffffffffda RBX: 000055b03b330950 RCX: 00007fa2cb41a779
> 	 RDX: 0000000000000000 RSI: 00007fa2c9b9e44d RDI: 000000000000001f
> 	 RBP: 0000000000000000 R08: 0000000000000000 R09: 000055b03b2fed30
> 	 R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa2c9b9e44d
> 	 R13: 0000000000020000 R14: 000055b03b3242e0 R15: 0000000000000000
> 	  </TASK>
> 	 ---[ end trace 0000000000000000 ]---
> 
> The second time I boot my system, I got the same warning but different call stacks:	
> 	 ------------[ cut here ]------------
> 	 alloc_tag was not set
> 	 WARNING: ./include/linux/alloc_tag.h:166 at __alloc_tagging_slab_free_hook+0xe6/0x120, CPU#0: ksoftirqd/0/14
> 	 Modules linked in: xhci_pci(E+) ahci(E+) r8169(E+) nvme(E) libahci(E) xhci_hcd(E) realtek(E) libata(E) i2c_piix4(E) nvme_core(E) i2c_smbus(E) usbcore(E) scsi_mod(E) usb_common(E) scsi_common(E) wmi(E) fjes(E-) gpio_amdpt(E) gpio_generic(E) button(E) efivarfs(E)
> 	 CPU: 0 UID: 0 PID: 14 Comm: ksoftirqd/0 Tainted: G            E       7.0.0-rc1-linan-0 #802 PREEMPT(full) 
> 	 Tainted: [E]=UNSIGNED_MODULE
> 	 Hardware name: Micro-Star International Co., Ltd. MS-7B89/B450M MORTAR MAX (MS-7B89), BIOS 2.L0 07/18/2024
> 	 RIP: 0010:__alloc_tagging_slab_free_hook+0xe6/0x120
> 	 Code: 2c d3 e8 0f af c2 4c 01 f0 48 89 c3 74 9e 48 8b 00 41 8b 54 24 18 48 85 c0 0f 85 6c ff ff ff 89 54 24 04 48 8d 3d da 4e 44 01 <67> 48 0f b9 3a 48 8b 03 8b 54 24 04 48 85 c0 0f 85 4c ff ff ff 48
> 	 RSP: 0018:ffffd362c0137d48 EFLAGS: 00010246
> 	 RAX: 0000000000000000 RBX: ffff8b718006c610 RCX: 0000000000000008
> 	 RDX: 0000000000000200 RSI: fffffa5884001900 RDI: ffffffffa184aee0
> 	 RBP: ffffd362c0137d90 R08: 0000000000000001 R09: ffffffffa040e09c
> 	 R10: ffff8b7180042700 R11: ffff8b7183b47440 R12: ffff8b7180042a00
> 	 R13: fffffa5884001900 R14: ffff8b718006c600 R15: ffffd362c0137d98
> 	 FS:  0000000000000000(0000) GS:ffff8b750ce1a000(0000) knlGS:0000000000000000
> 	 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 	 CR2: 0000560882dbc058 CR3: 0000000107e6f000 CR4: 0000000000350ef0
> 	 Call Trace:
> 	  <TASK>
> 	  ? rcu_core+0x451/0x750
> 	  kfree+0xab/0x370
> 	  rcu_core+0x451/0x750
> 	  ? rcu_core+0x3eb/0x750
> 	  ? srso_return_thunk+0x5/0x5f
> 	  ? try_to_wake_up+0xaf/0x740
> 	  handle_softirqs+0x100/0x2e0
> 	  run_ksoftirqd+0x37/0x50
> 	  smpboot_thread_fn+0x114/0x2a0
> 	  ? __pfx_smpboot_thread_fn+0x10/0x10
> 	  kthread+0x114/0x150
> 	  ? __pfx_kthread+0x10/0x10
> 	  ret_from_fork+0x238/0x330
> 	  ? __pfx_kthread+0x10/0x10
> 	  ret_from_fork_asm+0x1a/0x30
> 	  </TASK>
> 	 ---[ end trace 0000000000000000 ]---
> 
> Bisect narrows it down to 913ffd3a1b(slab: handle kmalloc sheaves bootstrap)
> 
> 	$ git bisect log
> 	git bisect start
> 	# status: waiting for both good and bad commits
> 	# good: [05f7e89ab9731565d8a62e3b5d1ec206485eeb0b] Linux 6.19
> 	git bisect good 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
> 	# status: waiting for bad commit, 1 good commit known
> 	# bad: [6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f] Linux 7.0-rc1
> 	git bisect bad 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
> 	# bad: [6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f] Linux 7.0-rc1
> 	git bisect bad 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
> 	# good: [939faf71cf7ca9ab3d1bd2912ac0e203d4d7156a] Merge tag 'drm-next-2026-02-11' of https://gitlab.freedesktop.org/drm/kernel
> 	git bisect good 939faf71cf7ca9ab3d1bd2912ac0e203d4d7156a
> 	# bad: [c87c79345ea8ff917354e9223d44034e4aef2690] Merge tag 'uml-for-7.0-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/uml/linux
> 	git bisect bad c87c79345ea8ff917354e9223d44034e4aef2690
> 	# good: [83310d613382f74070fc8b402f3f6c2af8439ead] Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
> 	git bisect good 83310d613382f74070fc8b402f3f6c2af8439ead
> 	# bad: [541c43310e85dbf35368b43b720c6724bc8ad8ec] Merge tag 'fs_for_v6.20-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
> 	git bisect bad 541c43310e85dbf35368b43b720c6724bc8ad8ec
> 	# bad: [1c2b4a4c2bcb950f182eeeb33d94b565607608cf] Merge tag 'pci-v7.0-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci
> 	git bisect bad 1c2b4a4c2bcb950f182eeeb33d94b565607608cf
> 	# bad: [61e629596fabd7f60cc3748a603703c5d9b58428] Merge tag 'for-7.0/dm-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm
> 	git bisect bad 61e629596fabd7f60cc3748a603703c5d9b58428
> 	# bad: [148f95f75c513936d466bcc7e6bf73298da2212b] Merge tag 'slab-for-7.0' of git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab
> 	git bisect bad 148f95f75c513936d466bcc7e6bf73298da2212b
> 	# good: [41f1a08645abb5ef7d2a3ed8835c747334878774] Merge tag 'kbuild-7.0-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kbuild/linux
> 	git bisect good 41f1a08645abb5ef7d2a3ed8835c747334878774
> 	# bad: [6c2f307f30edbe2b18a35584f01854a27e375927] slab: remove unused PREEMPT_RT specific macros
> 	git bisect bad 6c2f307f30edbe2b18a35584f01854a27e375927
> 	# good: [f3421f8d154cc0906da145299c72f4a7f046ffde] slab: introduce percpu sheaves bootstrap
> 	git bisect good f3421f8d154cc0906da145299c72f4a7f046ffde
> 	# bad: [e323b52cf00ffc3f5ac79420af7ab340b4576a5c] slab: remove SLUB_CPU_PARTIAL
> 	git bisect bad e323b52cf00ffc3f5ac79420af7ab340b4576a5c
> 	# bad: [913ffd3a1bf5d154995c6cfab44994b07b3c103f] slab: handle kmalloc sheaves bootstrap
> 	git bisect bad 913ffd3a1bf5d154995c6cfab44994b07b3c103f
> 	# good: [f1427a1d64156bb88d84f364855c364af6f67a3b] slab: make percpu sheaves compatible with kmalloc_nolock()/kfree_nolock()
> 	git bisect good f1427a1d64156bb88d84f364855c364af6f67a3b
> 	# first bad commit: [913ffd3a1bf5d154995c6cfab44994b07b3c103f] slab: handle kmalloc sheaves bootstrap
> 
> 
> 
> FYI
> David
> 


