Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27542FA3751
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 21:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F7396B0089; Fri,  2 Jan 2026 16:57:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A1786B008A; Fri,  2 Jan 2026 16:57:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A5366B008C; Fri,  2 Jan 2026 16:57:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 466336B0089
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 16:57:15 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FA7D140D82
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 21:57:15 +0000 (UTC)
X-FDA: 84288385230.09.E63B95E
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0250A160006
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 21:57:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W+6S+6gB;
	spf=pass (imf08.hostedemail.com: domain of salvatore.bonaccorso@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=salvatore.bonaccorso@gmail.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767391033;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ixPej4sAy5a/rs1F6wmPPPDs+sy/vDVBIuic0yKAeBk=;
	b=yv6RjI1AQLTGhBH9ZCzcmo/f0W9deqXmaXMXpjeDk4LfE3CiDp8h26kyf4n+0jBOmd3x2E
	vUCJLKatu0WJrNPQls/Gv+prpEe8IeoVzSOOHHWAj8rKiuJE0RsgXQ/CaQ9190+mSDgvw3
	P3WCUoaGF0E1WQQXX2da3Z1fPOU49P0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W+6S+6gB;
	spf=pass (imf08.hostedemail.com: domain of salvatore.bonaccorso@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=salvatore.bonaccorso@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767391033; a=rsa-sha256;
	cv=none;
	b=Hi0/R0BGn1/2TA3WEnaEovxfayJGBjndBa2RZqabLORFVMpciRQTQxZzi18owPujICRN4E
	FQKUuMJEOYUFpRiwbvZb+xCKHskE5Q/XlGclY1tJzj8YoUQPoruzVbXfkYOoVUQ5RUexVn
	4KU9OfgrzY0u7VNNMylOO5ofpxps5uQ=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64b791b5584so17924225a12.0
        for <linux-mm@kvack.org>; Fri, 02 Jan 2026 13:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767391031; x=1767995831; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ixPej4sAy5a/rs1F6wmPPPDs+sy/vDVBIuic0yKAeBk=;
        b=W+6S+6gB2JaoPwE8gNSoTea1gqkAHbLK4axL8n8/HqHyUq9ih+A5fpxlOfJEAa06lh
         nSoayl2VWNttKjwXE70AEFSaeFRdfY1M4kzvnU9GBUTXMbILKWc5Df7QOzKoRF/13CrS
         i7VQbTBAYM+mOr/jcpcVEtHL0RH8+yOQM5wSo6g93vIypdMqaqNuu7l2KVIffDyRwI/i
         s8JMjT+11fsUOCe+z9BzR+S82GeHUz8sji7MJvEBr7wQXvH3yOnUFS49H6ePw564m1Wb
         xzR3yylK9NthR5amJ85rOP9ysHsUU3nn9M3LiQR9I9tmmqg5C9+m42A6jukCykU6M+8r
         4iZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767391031; x=1767995831;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ixPej4sAy5a/rs1F6wmPPPDs+sy/vDVBIuic0yKAeBk=;
        b=sO0vH2BY9nhTtZDj0N6+LW0dILBgSEkkpGC2XkCH2VA3rK6UC3y/DLKLE0gJkz6pPt
         CR/5EV4081/z++QBEArl2b4umQHcczvd5pvZh45W3uKeV9PnQS08EYF593jBTC9wSlxj
         Bu5lFDXbtPaL3c5i+NolaBC5qQhLiSVpmo2k7oLX/MzHE/WdP0HQ0VxvTo0fwS9xfpL3
         nPHj4h72qN19y1vxbEVmYmetFzteGQ+/L5OB8C70kikrd7XN0qyDxoJ8XNjLDh9MMuMU
         p01qmaw7ZgYQS54EOwH1lNJMJqMKmsbTQbLFkc88w/fxwYb2YihaxEvILC9RMWyP2Lk8
         glTQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+jOOxG1d7/VdBCA/YtvA2GpoJONAGy2AjYaRYBP3u6ufij64WSirn13SU9tCUIYPNDkagmf4X5w==@kvack.org
X-Gm-Message-State: AOJu0YwMaHofUgQ7zIcuQOc1FHrBecHrv41cI0I5YtE7BUKFs3XfJRsa
	a3xLcEDhssfybYzdDtY1j2qAyMnCTHM9Je6vtJakwrz348fQSlEOrROAm2/Wvauz
X-Gm-Gg: AY/fxX6m26bA5pJBX1DUYAJpdB8dY9d/wxq1om+2MdtqNKSuH1bu/hZRlsT52LZJnw0
	AJvmsPjTnJ+enThxLtrBvx2dGv036qgk2Q+nGlQvzRa4j+ifkmsr83RNeIqGb63OHdkP8pbRvaC
	LIAQXGc/+bukD04Kohr665JdNtpONbfIXgBqf+JgAhdCyK8ZgnvQCoDkJ4qr0W+NjUNpn7GEidh
	Kvk+l5pJSCz3bH75qdhNaBb2tZLDK/EGQb0PQyRl928Sv2Yypq+1O/GqPTf5bhilDvajH7q2yyM
	yh64XeRqrZnWleRZ7AAXkF9nYH2Uwg4Tpyyu4sLVAJW0hHMmz3jIaauQo9kJbN1zAzwkOk+Y8WN
	U3PBdT9KVw3ERFPVEHD/h3ZVV8x2TnPI5vxbPhu03cfgglCAYcW6umZ9eZO1NLose/+1Fov3625
	WLRDQJkJwCYJauzsZOvYlQqDRcMT0a/ZtmT8IJZJQ1s7R9Z/lhnBgCyok=
X-Google-Smtp-Source: AGHT+IFsZER8SIv/i5hzj9D7egZU9V3f26RNmw7cZoMkr0y/OfsSEPpH1BGTZ/+Oym2YtT3Lej2X5Q==
X-Received: by 2002:a05:6000:40ce:b0:430:f2ee:b220 with SMTP id ffacd0b85a97d-4324e4cb94dmr55491373f8f.19.1767383976331;
        Fri, 02 Jan 2026 11:59:36 -0800 (PST)
Received: from eldamar.lan (c-82-192-244-13.customer.ggaweb.ch. [82.192.244.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa08d9sm86241782f8f.30.2026.01.02.11.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 11:59:34 -0800 (PST)
Received: by eldamar.lan (Postfix, from userid 1000)
	id E0E39BE2EE7; Fri, 02 Jan 2026 20:59:33 +0100 (CET)
Date: Fri, 2 Jan 2026 20:59:33 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: BUG: kernel NULL pointer dereference, address: 0000000000000000
Message-ID: <aVgjpWaIRkerdgCa@eldamar.lan>
References: <6ba903ad-9897-42bb-8c2d-337385cc3746@molgen.mpg.de>
 <db387081-345f-423a-a0ff-e13f3bec2d51@molgen.mpg.de>
 <CADVatmM_mRnkDX=hpUjbyKkZnGynxJfRSujGxm2LaWWMEL_2ew@mail.gmail.com>
 <ef9223ee-0a4e-468c-bfd0-0cf190d262f1@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef9223ee-0a4e-468c-bfd0-0cf190d262f1@molgen.mpg.de>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0250A160006
X-Stat-Signature: ajtkmbkih74fnewdef3nrhroo6gfbybd
X-HE-Tag: 1767391032-991701
X-HE-Meta: U2FsdGVkX180mErjFoAJjXFEJofkZGKa/mf7LAB7I8waqdAzgLATGJ/06t697M6AHZjzeUEDXobT8SJeLI2i2uPcHsjgPh2fKFs2OpJ9FxgTk6HXV+vBM2e9MhbqzRxQvkJe4cGEiSMDar6DrHtA/teXjG0vBebRhTfyADzhb8Z1FHffBstcFIAVkPXSBKS+YZub5R5/etufP6owCUi3UWYcJ9yK/efVQAdTJqSYQD5AF0upVAPwsbOrqc+49iTKxM2lBVdwilLupZkTNZzicjNljAk3ahVdZNuyydm0Fzo0M8W7NPKwxeacbsQc238qFZyRb0emlUoumlCjJXGcrI1sCYjIAYdaTxj9ssbAxrL7J5pZ8IjEA6sYVdNw+z4AKcTi7KiU/jwmFyS8J3DNN9PadJ2yXkMNnYMe38N/FUWlCOuRPCYKRLAtpGwCP51LDK051hVIjqWanM7CU8/XJGlRcQIoHzDJiCgjlaQI73K7eFCfmzJHcnoQM5/eX/dCKvmnkzQ+qKVaw9Av5JtkGXhxfdQqYnDsebqa3sD7AwKUPuP5NLDqmvKscgGpxMG1qQ6pKSs2kjmTvX8kKqkm6ktKt5C6pgeQwLDz3/l308qbsNLv4jXN7qjvcw7ux1xA6uTt5faL/LecdQH9GIEFpRxA3AryMYe2ksJMVr3mtuM7S36A1xKVaHGQ3l4HIR60VGj3W7+o4WdX329YIasT1RSOBy3HT1FWB2gexpfdHbzX7UZQFb1nJZQEXSEgeWmnhOH43e7vb9yo0fyy9Xa6S8ecT89PFTcyBk9FtkT1QBwOKHPL5C2GmSVIvF+Eamzdwr76QaqXomgaMXv9EigHIRBLBgWHNGqspAWLbrVf9q+DcLZZJsoqpXcICfQnFA36r0y1hKUixxXLXOkwHDTepudPAjVjpLdS+E54UrIvMmDizrZZfqZTzcRreP6uxCv9zk7GYwWygbU8FvsYSb8
 reppEAIr
 6cv7G3+wW5U09beCM+sHrxKHQLFCLPoi30g0DTbAHnmIE0N5atC7+Ya+kp1G141Fz/4Ylpa1dv9sjaie1sEWFCRleVTZR8LarEqWgbBVnl/UTkbmfABTis9hM0yJXYfjIQjeKcSBJTUh3UMGwVcLt16AsBSp7ke7p6t9A856BgWXIwtHwCEcjC+CAhIA6euGY+AvU4XJTYgUmtTHeil/YfhDhI9/3UibUcWRrV7IqnNqj1IYda0XkgCMQpEt+zcH6FlIvxhJnnQe1cBl25Eccq38qS1pqsduI4Yx58WnI1sefk5XLc366CJ4dhZaELp4QymQc69EC+kRjZOVLGiNc5wij6vyeeG2l5h3jZ59ffsFCQzh6Wn5LFdOAJ7JJkIpW2PfSNXHsHk4ieP3IijzBHZWjWH3ivH4Nl54EHXGqPoNOtkU2VeRnB4X42SkkNqSIHmJXUo8IdxwRwoXMjmEo9/kLt11B2Z8f/k5NpXpQgipuKoPKcwSS8b1ZOBXtNXQR1qqwYSP953Ve7pX4vPb0M0yE6SgRLmvWW85Fuor5eOTGZBvJiicG3b8X3mBFDtjBtglm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Paul, hi Sudip,

On Mon, Dec 01, 2025 at 05:05:59PM +0100, Paul Menzel wrote:
> Dear Sudip,
> 
> 
> Thank you very much for looking into this.
> 
> 
> Am 01.12.25 um 14:25 schrieb Sudip Mukherjee:
> > On Thu, 27 Nov 2025 at 22:55, Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> 
> > > Am 27.11.25 um 19:51 schrieb Paul Menzel:
> > > 
> > > > Unfortunately, not reproducible, but starting with Linux 6.18-rc7, I got
> > > > the oops below *once*:
> > > > 
> > > > ```
> > 
> > <snip>
> > 
> > > Building and booting Linux 6.18.0-rc7-00041-g765e56e41a5a, I got another
> > > oops.
> > > 
> > >       [   15.234799] ppdev lp.0: really_probe: driver_sysfs_add failed
> > >       [   15.234852] ------------[ cut here ]------------
> > >       [   15.234854] refcount_t: addition on 0; use-after-free.
> > >       [   15.234864] WARNING: CPU: 0 PID: 353 at lib/refcount.c:25 refcount_warn_saturate+0xcd/0xf0
> > > 
> > > Please find the output of `dmesg` attached.
> > > 
> > > (It might be related to booting with an USB-C mini-dock connected, but I
> > > do not know yet.)
> 
> At least today, I am also only able to reproduce this with *no* power cable
> plugged in, and the USB-C mini-dock connected.
> 
> > In both cases, it seems the underlying hardware was removed or the
> > module was unloaded while it was still registering.
> > 
> > In the first case, 'parport_default_proc_unregister' has been called
> > while parport driver is still checking for all the connected devices
> > and was executing 'lp_attach'.
> > 'parport_default_proc_unregister' will only be called when the parport
> > module is exiting.
> > 
> > Same in the second case,  'lp_attach' was still executing and
> > 'ppdev_cleanup' was called.
> 
> Please find the output of `dmesg` attached with the Oops for Linux 6.18.
> 
> ```
> [   14.696290] ppdev: user-space parallel port driver
> [   14.696974] lp lp.0: really_probe: driver_sysfs_add failed
> [   14.697015] kernel tried to execute NX-protected page - exploit attempt?
> (uid: 0)
> [   14.697189] BUG: unable to handle page fault for address:
> ffff991d07830708
> [   14.697223] #PF: supervisor instruction fetch in kernel mode
> [   14.697249] #PF: error_code(0x0011) - permissions violation
> [   14.697277] PGD 388401067 P4D 388401067 PUD 101338063 PMD 10785c063 PTE
> 8000000107830163
> [   14.697313] Oops: Oops: 0011 [#1] SMP
> [   14.697334] CPU: 2 UID: 0 PID: 357 Comm: systemd-modules Not tainted
> 6.18.0 #165 PREEMPT(voluntary)
> [   14.697386] Hardware name: Dell Inc. XPS 13 9360/0596KF, BIOS 2.21.0
> 06/02/2022
> [   14.697423] RIP: 0010:0xffff991d07830708
> [   14.697445] Code: ff ff 20 a1 10 01 1d 99 ff ff 80 3a 50 93 ff ff ff ff
> 40 54 3c 06 1d 99 ff ff 01 00 00 00 07 00 00 00 00 00 00 00 00 00 00 00 <08>
> 07 83 07 1d 99 ff ff 08 07 83 07 1d 99 ff ff 00 00 00 00 00 00
> [   14.697530] RSP: 0000:ffffa8c040a27a30 EFLAGS: 00010286
> [   14.697561] RAX: ffff991d078306c0 RBX: ffff991d0722a000 RCX:
> 0000000000000007
> [   14.697593] RDX: ffffffffc078d5c0 RSI: ffff991d01fa7ce0 RDI:
> ffff991d03cc0000
> [   14.697618] RBP: ffffa8c040a27a80 R08: 00000000fffffff3 R09:
> 00000000fff7ffff
> [   14.697639] R10: ffffffff9482b180 R11: ffffa8c040a27620 R12:
> ffff991d0722a040
> [   14.697659] R13: ffff991d03cc0050 R14: ffff991d03cc0000 R15:
> ffff991d00dfe8e8
> [   14.697679] FS:  00007f09cb7fd6c0(0000) GS:ffff9920d8587000(0000)
> knlGS:0000000000000000
> [   14.697711] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   14.697728] CR2: ffff991d07830708 CR3: 0000000102019003 CR4:
> 00000000003706f0
> [   14.697749] Call Trace:
> [   14.697759]  <TASK>
> [   14.697768]  ? parport_register_dev_model+0x273/0x3c0 [parport]
> [   14.697792]  ? lp_register+0x6f/0x100 [lp]
> [   14.697806]  ? msr_init+0x1000/0x1000 [msr]
> [   14.697822]  ? parport_irq_handler+0x50/0x50 [parport]
> [   14.697841]  ? lp_attach+0x99/0xc0 [lp]
> [   14.697854]  ? port_check+0x1d/0x20 [parport]
> [   14.697879]  ? bus_for_each_dev+0x82/0xd0
> [   14.697894]  ? ppdev_cleanup+0xb40/0xb40 [ppdev]
> [   14.697910]  ? __parport_register_driver+0x7e/0xb0 [parport]
> [   14.697930]  ? lp_init_module+0x1e2/0x1000 [lp]
> [   14.697945]  ? do_one_initcall+0x58/0x2f0
> [   14.697960]  ? do_init_module+0x67/0x2a0
> [   14.697974]  ? init_module_from_file+0x85/0xc0
> [   14.697989]  ? __x64_sys_finit_module+0x163/0x3d0
> [   14.698005]  ? do_syscall_64+0x82/0x9b0
> [   14.698020]  ? vfs_read+0x15e/0x380
> [   14.698035]  ? vfs_read+0x15e/0x380
> [   14.698056]  ? __rseq_handle_notify_resume+0xa6/0x480
> [   14.698080]  ? restore_fpregs_from_fpstate+0x46/0xa0
> [   14.698098]  ? switch_fpu_return+0x5b/0xd0
> [   14.698113]  ? do_syscall_64+0x21d/0x9b0
> [   14.698134]  ? restore_fpregs_from_fpstate+0x46/0xa0
> [   14.698158]  ? switch_fpu_return+0x5b/0xd0
> [   14.698179]  ? do_syscall_64+0x21d/0x9b0
> [   14.698203]  ? do_user_addr_fault+0x216/0x690
> [   14.698230]  ? exc_page_fault+0x7e/0x1a0
> [   14.698254]  ? entry_SYSCALL_64_after_hwframe+0x4b/0x53
> [   14.698286]  </TASK>
> ```
> 
> > Are you seeing the crash only from v6.18-rc7 onwards? Was v6.18-rc6 or
> > v6.17 ok for you?
> Going through some Linux kernels, I hit the same issue with
> 6.18.0-rc3-00256-gba36dd5ee6fd, but with that the graphics environment did
> not load, and I only have the journal entry.
> 
> ```
> Dez 01 14:33:41 abreu kernel: kernel tried to execute NX-protected page -
> exploit attempt? (uid: 0)
> Dez 01 14:33:41 abreu kernel: BUG: unable to handle page fault for address:
> ffff97fec6b9c588
> Dez 01 14:33:41 abreu kernel: #PF: supervisor instruction fetch in kernel
> mode
> Dez 01 14:33:41 abreu kernel: #PF: error_code(0x0011) - permissions
> violation
> Dez 01 14:33:41 abreu kernel: PGD 3fda01067 P4D 3fda01067 PUD 101338063 PMD
> 106b74063 PTE 8000000106b9c163
> Dez 01 14:33:41 abreu kernel: Oops: Oops: 0011 [#1] SMP
> Dez 01 14:33:41 abreu kernel: CPU: 2 UID: 0 PID: 432 Comm: systemd-modules
> Not tainted 6.18.0-rc3-00256-gba36dd5ee6fd #154 PREEMPT(voluntary)
> Dez 01 14:33:41 abreu kernel: Hardware name: Dell Inc. XPS 13 9360/0596KF,
> BIOS 2.21.0 06/02/2022
> Dez 01 14:33:41 abreu kernel: RIP: 0010:0xffff97fec6b9c588
> Dez 01 14:33:41 abreu kernel: Code: ff ff 20 ed 23 c7 fe 97 ff ff a0 3a f0
> 9a ff ff ff ff f8 37 58 c3 fe 97 ff ff 01 00 00 00 03 00 00 00 00 00 00 00
> 00 00 00 00 <88> c5 b9 c6 fe 97 ff ff 88 c5 b9 c6 fe 97 ff ff 00 00 00 00 00
> 00
> Dez 01 14:33:41 abreu kernel: RSP: 0000:ffffaaba0095bb00 EFLAGS: 00010286
> Dez 01 14:33:41 abreu kernel: RAX: ffff97fec6b9c540 RBX: ffff97fec48c7800
> RCX: 0000000000000007
> Dez 01 14:33:41 abreu kernel: RDX: ffffffffc077b5c0 RSI: ffff97fec71a58b0
> RDI: ffff97fed8514800
> Dez 01 14:33:41 abreu kernel: RBP: ffffaaba0095bb50 R08: ffff97fec77ec243
> R09: ffff98022cd3f4c0
> Dez 01 14:33:41 abreu kernel: R10: 0000000000000001 R11: 0000000006f6b9e9
> R12: ffff97fec48c7840
> Dez 01 14:33:41 abreu kernel: R13: ffff97fed8514850 R14: ffff97fed8514800
> R15: ffff97fec7349b08
> Dez 01 14:33:41 abreu kernel: FS:  00007f4b0c2fcc80(0000)
> GS:ffff980290b87000(0000) knlGS:0000000000000000
> Dez 01 14:33:41 abreu kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> Dez 01 14:33:41 abreu kernel: CR2: ffff97fec6b9c588 CR3: 0000000106a5f004
> CR4: 00000000003706f0
> Dez 01 14:33:41 abreu kernel: Call Trace:
> Dez 01 14:33:41 abreu kernel:  <TASK>
> Dez 01 14:33:41 abreu kernel:  ? parport_register_dev_model+0x273/0x3c0
> [parport]
> Dez 01 14:33:41 abreu kernel:  ? lp_register+0x6f/0x100 [lp]
> Dez 01 14:33:41 abreu kernel:  ? parport_pc_init+0xf20/0xf20 [parport_pc]
> Dez 01 14:33:41 abreu kernel:  ? parport_irq_handler+0x50/0x50 [parport]
> Dez 01 14:33:41 abreu kernel:  ? lp_attach+0x99/0xc0 [lp]
> Dez 01 14:33:41 abreu kernel:  ? port_check+0x1d/0x20 [parport]
> Dez 01 14:33:41 abreu kernel:  ? bus_for_each_dev+0x82/0xd0
> Dez 01 14:33:41 abreu kernel:  ? lp_open.cold+0xaf5/0xaf5 [lp]
> Dez 01 14:33:41 abreu kernel:  ? __parport_register_driver+0x7e/0xb0
> [parport]
> Dez 01 14:33:41 abreu kernel:  ? lp_init_module+0x1e2/0x1000 [lp]
> Dez 01 14:33:41 abreu kernel:  ? do_one_initcall+0x58/0x2f0
> Dez 01 14:33:41 abreu kernel:  ? do_init_module+0x67/0x2a0
> Dez 01 14:33:41 abreu kernel:  ? init_module_from_file+0x85/0xc0
> Dez 01 14:33:41 abreu kernel:  ? __x64_sys_finit_module+0x163/0x3d0
> Dez 01 14:33:41 abreu kernel:  ? do_syscall_64+0x82/0x9b0
> Dez 01 14:33:41 abreu kernel:  ? do_syscall_64+0xbb/0x9b0
> Dez 01 14:33:41 abreu kernel:  ? do_sys_openat2+0xa2/0xe0
> Dez 01 14:33:41 abreu kernel:  ? __x64_sys_openat+0x61/0xa0
> Dez 01 14:33:41 abreu kernel:  ? do_syscall_64+0xbb/0x9b0
> Dez 01 14:33:41 abreu kernel:  ? do_syscall_64+0xbb/0x9b0
> Dez 01 14:33:41 abreu kernel:  ? exc_page_fault+0x7e/0x1a0
> Dez 01 14:33:41 abreu kernel:  ? entry_SYSCALL_64_after_hwframe+0x4b/0x53
> Dez 01 14:33:41 abreu kernel:  </TASK>
> Dez 01 14:33:41 abreu kernel: Modules linked in: ppdev(+) lp(+) parport_pc
> msr(+) parport drm efi_pstore configfs nfnetlink efivarfs autofs4 ext4 crc16
> mbcache jbd2 dm_crypt dm_mod dell_wmi dell_smbios dell_wmi_descriptor dcdbas
> evdev nvme serio_raw pcspkr nvme_core video intel_hid sparse_keymap wmi
> aesni_intel
> Dez 01 14:33:41 abreu kernel: CR2: ffff97fec6b9c588
> Dez 01 14:33:41 abreu kernel: ---[ end trace 0000000000000000 ]---
> ```
> 
> I was forced to hard reset the machine by pressing the power button for more
> than ten seconds.

FWIW, we have two bugs in Debian as well reported, but they were once
for 6.17.12 and 6.17.13 already. See:

https://bugs.debian.org/1124075
https://bugs.debian.org/1124463

Does it make a difference to cold-boot or reboot into the system?

Regards,
Salvatore

