Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C459CFC6160
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 06:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49A46B0089; Sat,  3 Jan 2026 01:02:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF7D26B008C; Sat,  3 Jan 2026 01:02:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6236B0096; Sat,  3 Jan 2026 01:02:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7E86B0089
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 01:02:52 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 29D0587544
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 06:02:52 +0000 (UTC)
X-FDA: 84289608984.11.7900CB9
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by imf09.hostedemail.com (Postfix) with ESMTP id CFF68140007
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 06:02:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of pmenzel@molgen.mpg.de designates 141.14.17.11 as permitted sender) smtp.mailfrom=pmenzel@molgen.mpg.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767420170; a=rsa-sha256;
	cv=none;
	b=R1gGDiMZWSVb3bcjF6aivk7dogQ+/+h4r9owAdhLlD6KlonGiTR85Yfg3Rsbhz90tOiGY/
	6Co3s/vjrEeQZ16DGPBOGdKmCFw7Ui/YEuQDPXXt3Vh5uZVTqmoIH6bOU/+/aXgKJuVmew
	0m/Ly1SN1/rIxVPXLGP/hgKzw1Kl5lA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of pmenzel@molgen.mpg.de designates 141.14.17.11 as permitted sender) smtp.mailfrom=pmenzel@molgen.mpg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767420170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EzpnsZ95C+miupYdUSOBHKPY1HilM3Lk0m1rwZj1Hxo=;
	b=Nas+eYqrtQSr/H1ZVIdbA4jlR2CwM84sl4qg0NkGsJdR8ItjXDSnjnTxnnU36zQsfqyz77
	B7EUQE2aVO/RyL5o0vFd5E0m/ySjC8Fpv4OTJHiH1CD8kd1nqGUBiQq2NNGlom0zj4PZx3
	0RpzoaKKBvVu1kuLpUesSiVoH7tmkg8=
Received: from [10.11.202.139] (unknown [124.195.223.90])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 8E26161CC3FCD;
	Sat, 03 Jan 2026 07:01:52 +0100 (CET)
Message-ID: <49cdd663-bcbd-48b4-ac38-77ce94ef0c8d@molgen.mpg.de>
Date: Sat, 3 Jan 2026 12:01:19 +0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: BUG: kernel NULL pointer dereference, address: 0000000000000000
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
 Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, regressions@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Hans de Goede <hansg@kernel.org>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
References: <6ba903ad-9897-42bb-8c2d-337385cc3746@molgen.mpg.de>
 <db387081-345f-423a-a0ff-e13f3bec2d51@molgen.mpg.de>
 <CADVatmM_mRnkDX=hpUjbyKkZnGynxJfRSujGxm2LaWWMEL_2ew@mail.gmail.com>
 <ef9223ee-0a4e-468c-bfd0-0cf190d262f1@molgen.mpg.de>
 <aVgjpWaIRkerdgCa@eldamar.lan>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <aVgjpWaIRkerdgCa@eldamar.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CFF68140007
X-Stat-Signature: eb4crfwpppg9rfoe3g1ugxen1fp8q91c
X-Rspam-User: 
X-HE-Tag: 1767420169-822481
X-HE-Meta: U2FsdGVkX18qsK62U70cxIFz/p7arX0YpNcIKGFhDut6bLfBNLZUYPdrMsIRX/43jqx24LkPkxZPAQXQ2NFO/2zqBMFwTgam6ESVpA6l6zPPzkRz59UAQJ/jMxiYY1geRsJ3fLMs1colbyR/MDzD3kArgi5ewUnktt1gLSQaMq+xcUnDffchuN6Gg8SnCdZDa2AcmVaXiwkrPmgUDVtEGZ1Or0TcQwTo3ZI0Z4K72UZvFctcZ3U11w2ie7Ijj9NQGSBv5nZ3ayhxHpwh3iH/eMvwLacXbjGdZyZWyzwCB2pANTERzk99E74pFeY0vTJcWwPaFE3kQp51kpQzm6XizSbZqsMP4NNDKXa7TjZqkAPfCJQzNbpXxfSlS4pNhVOWp7sLkkvvdJNKEGmJdtwMjsPuGTecivae4S3+qC6V2Otk97q1wpNKQaTnCplONRoxWSAivZegSaaAw5wf0l4Z/C93ZiZDE3+GIMqOsWUCCSd1M29YtM9jtrw1BFP7YUcsLCaPfFHxo7WJOGVEWBqojgSJzl+mMWjyov/x38zooki+ZFm3+gp5KqLajK1ijPhr/PXhlKhPVyrSv3wMWu8cUtz0Vk5m9pC2YOk2RFBdUK4OYiyYmELRT7idjn0v6KnQByKvySjrf2TFlbLK2pbKYxGynH6WL/rL/P7HIxn8F7XXSt/3HzI10cO3AnU0fnombXrcRuJAarSyIKX/xrchQbXjwQ722s1pISp+QuhutASbwunM0u+LAxBQ72Z272KA0SIwuyiBHK8Yg/mR++PwfAgXTmU5jj2+OAK0TXdiJ8j7pI2HrhhWbzhQHn8vTJdhD0XjN2ix2gA68PkSdt/3tyhL3mEt6Ozg6EYnBQJyYnmP38BIaUDy6grhSvTNUuOiSV3CToQeQXBfpeT7OKTibdU0Fz9+/JM3v1DPBA2PK33ee/urXIs0Rp6L9/wlKFqG+vbHHo6CJLm7kr3mcod
 ko7mun5K
 b45lGc9jc7WXi6d0LHpabRrgVtR9A1nEPUkqBrBQTJ1kqzR8xkaayielFdJUiCa8U5Dc0STka/CDnyPvjTA+xOdj4Bz3AxNviRs9oP3H64d7lRdBQDeP3XtPNoAxATNrEqsVaBkh4lrXmILeFCt+Zn6RavdQbO1Adb37+pugi9JwO4jLMomOhyfNE00JjvIl9PUTDcuQERh+FHUyLQQC4nxzQTw5gB1nrCMtmFR9psubERw/mpRdxkTOC5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dear Salvatore,


Thank you for the follow-up.

Am 03.01.26 um 01:59 schrieb Salvatore Bonaccorso:

> On Mon, Dec 01, 2025 at 05:05:59PM +0100, Paul Menzel wrote:

>> Am 01.12.25 um 14:25 schrieb Sudip Mukherjee:
>>> On Thu, 27 Nov 2025 at 22:55, Paul Menzel wrote:
>>
>>>> Am 27.11.25 um 19:51 schrieb Paul Menzel:
>>>>
>>>>> Unfortunately, not reproducible, but starting with Linux 6.18-rc7, I got
>>>>> the oops below *once*:
>>>>>
>>>>> ```
>>>
>>> <snip>
>>>
>>>> Building and booting Linux 6.18.0-rc7-00041-g765e56e41a5a, I got another
>>>> oops.
>>>>
>>>>        [   15.234799] ppdev lp.0: really_probe: driver_sysfs_add failed
>>>>        [   15.234852] ------------[ cut here ]------------
>>>>        [   15.234854] refcount_t: addition on 0; use-after-free.
>>>>        [   15.234864] WARNING: CPU: 0 PID: 353 at lib/refcount.c:25 refcount_warn_saturate+0xcd/0xf0
>>>>
>>>> Please find the output of `dmesg` attached.
>>>>
>>>> (It might be related to booting with an USB-C mini-dock connected, but I
>>>> do not know yet.)
>>
>> At least today, I am also only able to reproduce this with *no* power cable
>> plugged in, and the USB-C mini-dock connected.
>>
>>> In both cases, it seems the underlying hardware was removed or the
>>> module was unloaded while it was still registering.
>>>
>>> In the first case, 'parport_default_proc_unregister' has been called
>>> while parport driver is still checking for all the connected devices
>>> and was executing 'lp_attach'.
>>> 'parport_default_proc_unregister' will only be called when the parport
>>> module is exiting.
>>>
>>> Same in the second case,  'lp_attach' was still executing and
>>> 'ppdev_cleanup' was called.
>>
>> Please find the output of `dmesg` attached with the Oops for Linux 6.18.
>>
>> ```
>> [   14.696290] ppdev: user-space parallel port driver
>> [   14.696974] lp lp.0: really_probe: driver_sysfs_add failed
>> [   14.697015] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
>> [   14.697189] BUG: unable to handle page fault for address: ffff991d07830708
>> [   14.697223] #PF: supervisor instruction fetch in kernel mode
>> [   14.697249] #PF: error_code(0x0011) - permissions violation
>> [   14.697277] PGD 388401067 P4D 388401067 PUD 101338063 PMD 10785c063 PTE 8000000107830163
>> [   14.697313] Oops: Oops: 0011 [#1] SMP
>> [   14.697334] CPU: 2 UID: 0 PID: 357 Comm: systemd-modules Not tainted 6.18.0 #165 PREEMPT(voluntary)
>> [   14.697386] Hardware name: Dell Inc. XPS 13 9360/0596KF, BIOS 2.21.0 06/02/2022
>> [   14.697423] RIP: 0010:0xffff991d07830708
>> [   14.697445] Code: ff ff 20 a1 10 01 1d 99 ff ff 80 3a 50 93 ff ff ff ff 40 54 3c 06 1d 99 ff ff 01 00 00 00 07 00 00 00 00 00 00 00 00 00 00 00 <08> 07 83 07 1d 99 ff ff 08 07 83 07 1d 99 ff ff 00 00 00 00 00 00
>> [   14.697530] RSP: 0000:ffffa8c040a27a30 EFLAGS: 00010286
>> [   14.697561] RAX: ffff991d078306c0 RBX: ffff991d0722a000 RCX: 0000000000000007
>> [   14.697593] RDX: ffffffffc078d5c0 RSI: ffff991d01fa7ce0 RDI: ffff991d03cc0000
>> [   14.697618] RBP: ffffa8c040a27a80 R08: 00000000fffffff3 R09: 00000000fff7ffff
>> [   14.697639] R10: ffffffff9482b180 R11: ffffa8c040a27620 R12: ffff991d0722a040
>> [   14.697659] R13: ffff991d03cc0050 R14: ffff991d03cc0000 R15: ffff991d00dfe8e8
>> [   14.697679] FS:  00007f09cb7fd6c0(0000) GS:ffff9920d8587000(0000) knlGS:0000000000000000
>> [   14.697711] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   14.697728] CR2: ffff991d07830708 CR3: 0000000102019003 CR4: 00000000003706f0
>> [   14.697749] Call Trace:
>> [   14.697759]  <TASK>
>> [   14.697768]  ? parport_register_dev_model+0x273/0x3c0 [parport]
>> [   14.697792]  ? lp_register+0x6f/0x100 [lp]
>> [   14.697806]  ? msr_init+0x1000/0x1000 [msr]
>> [   14.697822]  ? parport_irq_handler+0x50/0x50 [parport]
>> [   14.697841]  ? lp_attach+0x99/0xc0 [lp]
>> [   14.697854]  ? port_check+0x1d/0x20 [parport]
>> [   14.697879]  ? bus_for_each_dev+0x82/0xd0
>> [   14.697894]  ? ppdev_cleanup+0xb40/0xb40 [ppdev]
>> [   14.697910]  ? __parport_register_driver+0x7e/0xb0 [parport]
>> [   14.697930]  ? lp_init_module+0x1e2/0x1000 [lp]
>> [   14.697945]  ? do_one_initcall+0x58/0x2f0
>> [   14.697960]  ? do_init_module+0x67/0x2a0
>> [   14.697974]  ? init_module_from_file+0x85/0xc0
>> [   14.697989]  ? __x64_sys_finit_module+0x163/0x3d0
>> [   14.698005]  ? do_syscall_64+0x82/0x9b0
>> [   14.698020]  ? vfs_read+0x15e/0x380
>> [   14.698035]  ? vfs_read+0x15e/0x380
>> [   14.698056]  ? __rseq_handle_notify_resume+0xa6/0x480
>> [   14.698080]  ? restore_fpregs_from_fpstate+0x46/0xa0
>> [   14.698098]  ? switch_fpu_return+0x5b/0xd0
>> [   14.698113]  ? do_syscall_64+0x21d/0x9b0
>> [   14.698134]  ? restore_fpregs_from_fpstate+0x46/0xa0
>> [   14.698158]  ? switch_fpu_return+0x5b/0xd0
>> [   14.698179]  ? do_syscall_64+0x21d/0x9b0
>> [   14.698203]  ? do_user_addr_fault+0x216/0x690
>> [   14.698230]  ? exc_page_fault+0x7e/0x1a0
>> [   14.698254]  ? entry_SYSCALL_64_after_hwframe+0x4b/0x53
>> [   14.698286]  </TASK>
>> ```
>>
>>> Are you seeing the crash only from v6.18-rc7 onwards? Was v6.18-rc6 or
>>> v6.17 ok for you?
>> Going through some Linux kernels, I hit the same issue with
>> 6.18.0-rc3-00256-gba36dd5ee6fd, but with that the graphics environment did
>> not load, and I only have the journal entry.
>>
>> ```
>> Dez 01 14:33:41 abreu kernel: kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
>> Dez 01 14:33:41 abreu kernel: BUG: unable to handle page fault for address: ffff97fec6b9c588
>> Dez 01 14:33:41 abreu kernel: #PF: supervisor instruction fetch in kernel mode
>> Dez 01 14:33:41 abreu kernel: #PF: error_code(0x0011) - permissions violation
>> Dez 01 14:33:41 abreu kernel: PGD 3fda01067 P4D 3fda01067 PUD 101338063 PMD 106b74063 PTE 8000000106b9c163
>> Dez 01 14:33:41 abreu kernel: Oops: Oops: 0011 [#1] SMP
>> Dez 01 14:33:41 abreu kernel: CPU: 2 UID: 0 PID: 432 Comm: systemd-modules Not tainted 6.18.0-rc3-00256-gba36dd5ee6fd #154 PREEMPT(voluntary)
>> Dez 01 14:33:41 abreu kernel: Hardware name: Dell Inc. XPS 13 9360/0596KF, BIOS 2.21.0 06/02/2022
>> Dez 01 14:33:41 abreu kernel: RIP: 0010:0xffff97fec6b9c588
>> Dez 01 14:33:41 abreu kernel: Code: ff ff 20 ed 23 c7 fe 97 ff ff a0 3a f0 9a ff ff ff ff f8 37 58 c3 fe 97 ff ff 01 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 <88> c5 b9 c6 fe 97 ff ff 88 c5 b9 c6 fe 97 ff ff 00 00 00 00 00 00
>> Dez 01 14:33:41 abreu kernel: RSP: 0000:ffffaaba0095bb00 EFLAGS: 00010286
>> Dez 01 14:33:41 abreu kernel: RAX: ffff97fec6b9c540 RBX: ffff97fec48c7800 RCX: 0000000000000007
>> Dez 01 14:33:41 abreu kernel: RDX: ffffffffc077b5c0 RSI: ffff97fec71a58b0 RDI: ffff97fed8514800
>> Dez 01 14:33:41 abreu kernel: RBP: ffffaaba0095bb50 R08: ffff97fec77ec243 R09: ffff98022cd3f4c0
>> Dez 01 14:33:41 abreu kernel: R10: 0000000000000001 R11: 0000000006f6b9e9 R12: ffff97fec48c7840
>> Dez 01 14:33:41 abreu kernel: R13: ffff97fed8514850 R14: ffff97fed8514800 R15: ffff97fec7349b08
>> Dez 01 14:33:41 abreu kernel: FS:  00007f4b0c2fcc80(0000) GS:ffff980290b87000(0000) knlGS:0000000000000000
>> Dez 01 14:33:41 abreu kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> Dez 01 14:33:41 abreu kernel: CR2: ffff97fec6b9c588 CR3: 0000000106a5f004 CR4: 00000000003706f0
>> Dez 01 14:33:41 abreu kernel: Call Trace:
>> Dez 01 14:33:41 abreu kernel:  <TASK>
>> Dez 01 14:33:41 abreu kernel:  ? parport_register_dev_model+0x273/0x3c0 [parport]
>> Dez 01 14:33:41 abreu kernel:  ? lp_register+0x6f/0x100 [lp]
>> Dez 01 14:33:41 abreu kernel:  ? parport_pc_init+0xf20/0xf20 [parport_pc]
>> Dez 01 14:33:41 abreu kernel:  ? parport_irq_handler+0x50/0x50 [parport]
>> Dez 01 14:33:41 abreu kernel:  ? lp_attach+0x99/0xc0 [lp]
>> Dez 01 14:33:41 abreu kernel:  ? port_check+0x1d/0x20 [parport]
>> Dez 01 14:33:41 abreu kernel:  ? bus_for_each_dev+0x82/0xd0
>> Dez 01 14:33:41 abreu kernel:  ? lp_open.cold+0xaf5/0xaf5 [lp]
>> Dez 01 14:33:41 abreu kernel:  ? __parport_register_driver+0x7e/0xb0 [parport]
>> Dez 01 14:33:41 abreu kernel:  ? lp_init_module+0x1e2/0x1000 [lp]
>> Dez 01 14:33:41 abreu kernel:  ? do_one_initcall+0x58/0x2f0
>> Dez 01 14:33:41 abreu kernel:  ? do_init_module+0x67/0x2a0
>> Dez 01 14:33:41 abreu kernel:  ? init_module_from_file+0x85/0xc0
>> Dez 01 14:33:41 abreu kernel:  ? __x64_sys_finit_module+0x163/0x3d0
>> Dez 01 14:33:41 abreu kernel:  ? do_syscall_64+0x82/0x9b0
>> Dez 01 14:33:41 abreu kernel:  ? do_syscall_64+0xbb/0x9b0
>> Dez 01 14:33:41 abreu kernel:  ? do_sys_openat2+0xa2/0xe0
>> Dez 01 14:33:41 abreu kernel:  ? __x64_sys_openat+0x61/0xa0
>> Dez 01 14:33:41 abreu kernel:  ? do_syscall_64+0xbb/0x9b0
>> Dez 01 14:33:41 abreu kernel:  ? do_syscall_64+0xbb/0x9b0
>> Dez 01 14:33:41 abreu kernel:  ? exc_page_fault+0x7e/0x1a0
>> Dez 01 14:33:41 abreu kernel:  ? entry_SYSCALL_64_after_hwframe+0x4b/0x53
>> Dez 01 14:33:41 abreu kernel:  </TASK>
>> Dez 01 14:33:41 abreu kernel: Modules linked in: ppdev(+) lp(+) parport_pc msr(+) parport drm efi_pstore configfs nfnetlink efivarfs autofs4 ext4 crc16 mbcache jbd2 dm_crypt dm_mod dell_wmi dell_smbios dell_wmi_descriptor dcdbas evdev nvme serio_raw pcspkr nvme_core video intel_hid sparse_keymap wmi aesni_intel
>> Dez 01 14:33:41 abreu kernel: CR2: ffff97fec6b9c588
>> Dez 01 14:33:41 abreu kernel: ---[ end trace 0000000000000000 ]---
>> ```
>>
>> I was forced to hard reset the machine by pressing the power button for more
>> than ten seconds.
> 
> FWIW, we have two bugs in Debian as well reported, but they were once
> for 6.17.12 and 6.17.13 already. See:
> 
> https://bugs.debian.org/1124075

This is

AMD AM5 ASUS ROG STRIX B650-A GAMING WIFI, BIOS 3067 12/10/2024

> https://bugs.debian.org/1124463

This is

Dell Latitude E5470/0VHKV0, BIOS 1.34.3 11/20/2022

> Does it make a difference to cold-boot or reboot into the system?

I only did cold boots, and I am not able to reproduce it anymore, and 
wrote it off to some hardware issue – despite the system working fine 
otherwise.

I am adding the x86 folks, and regression lists.


Kind regards,

Paul

