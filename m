Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DDF3E64013
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 04:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965296B008A; Sun,  5 Apr 2026 00:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 915DB6B008C; Sun,  5 Apr 2026 00:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 805016B0092; Sun,  5 Apr 2026 00:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 700506B008A
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 00:48:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 349331B8E14
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 04:48:03 +0000 (UTC)
X-FDA: 84623270046.18.22C78B5
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 659AA100009
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 04:48:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MoGCs1TA;
	spf=pass (imf14.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MoGCs1TA;
	spf=pass (imf14.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775364481; a=rsa-sha256;
	cv=none;
	b=mT5LLMA9wWSdud+3H7+BTDUUwRruQRer59kw75uN7t+VccNDHoDu+KiVl1X/6Rxpu1PjEV
	6rLHRFcJHuEDuMjP5Ax8kH/rNy2UQQYBEd67dbNEcev5rhxAJY9pON+mJEttm1nEn42o0K
	rqVRmEhj2TR7NJdKFXg07oz/cFFGCbc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775364481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bf/9MBFSOja6BUaWbfBKRjL1h5PXO9yGtHvj7Ksf3NQ=;
	b=Z9xDJxDjSkyTPB8WDGo7hp1H496wo5+lIy1tAGUsQjJugIgL3MNzx2L9/GXcUucBdCdQSc
	MgSGtbFuS+IRw3ytrZ1mNVpJN0T43AXBt4S9M7EOQSxfLULuMp8CCMjlWuS19fB1YX9xpO
	8fNNMQzQSi5nXIh+24XycIcYTQroetY=
Message-ID: <559ef477-1d93-4c52-b90e-4a790758d598@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775364479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bf/9MBFSOja6BUaWbfBKRjL1h5PXO9yGtHvj7Ksf3NQ=;
	b=MoGCs1TAPgggMYBSB6mILFsHFKCC8yILxZUyPExWIAr2TcPm0WfgraVsmrl5VVCrsnlzX5
	+V8eGuBi6whJanO4bv/45U73/mA8QFTGG6U/9yHQQIcOxInosslhqS1jXVMRLZEoJKAZ3V
	/nfrSqXB24H5ccy+zAzW4caLuTRri2g=
Date: Sun, 5 Apr 2026 12:47:52 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] lib: test_hmm: Implement a device release method
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 david@kernel.org, jgg@ziepe.ca, leon@kernel.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
 dri-devel@lists.freedesktop.org, balbirs@nvidia.com
References: <20260331063445.3551404-1-apopple@nvidia.com>
 <20260331063445.3551404-4-apopple@nvidia.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260331063445.3551404-4-apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 659AA100009
X-Stat-Signature: hiohnhpupb4eu8ubd5jffjej8t4wks4e
X-Rspam-User: 
X-HE-Tag: 1775364481-305035
X-HE-Meta: U2FsdGVkX1/pijBTUMFkTaC/ORhzQGpQeMaynF0m92Wt6FOO8l6IlTZH26a/smfq023QutLcoL5tkcB4tJBilexzBNqtxLUXr0ajhKdXxL9/jN5bbMMPRi3L8ikapbJgshXrK3IDg555fQjlBm6fsMafuc1URzWsOqIDoHG5huat4vil4xlSskykyPQkNndsg8yRkc5VmwM2GOjuHVG1X527uxyRl/tRAE0XocWt13r7fwtAgQs0Stx4qVRHYDX4GYdmfBh05BhO+ky2soD2A/zOgCfxhdVsSQEwa1bGUXm9SeUVa/WR8U1Gad8bmi2WiD+NVj7oqNmyPRLLm4M/3oV30rY9Vouk2tgHZTnBAVKc1xoJoW/c5lIE5Y8XDIYNmOony3vhpXuO34cyksYOopa6H1iapV9K4QSL8uN4r8sBLW6p4a7DcGspInKyvLxwhGnbetZdFd0CPUkNu4XoEDug4Tp9TqteYogZ/rIixlhGkSBRexKlKCXW21SirVj6hqtzxCsV8b/wQ4caIDccugc25HtLG2ymi/TICsMSGC7n4wnd80jaJnIqpUqyeJ4jECkDVdSu/sd8O9RjfYrVaGyGd1ThR2QOjDXZMsMSCRjYd2UzJqfKiTrllVUGZjRWCNwpa9dV3yUcYUZ4HuEAt+z7ReCJw5g+dRZSQ7zH2969rd9poeGuZOhxOUj83YWj3V84e4A7k/6Gaxq/9RAgcpHDSvMD0LOJkzIR3gzaTOwso/3v9aapctK4Dggm3dOcCRGw7zI8bWlEv8vpXiOK9OXU3wFrdHs5C/uUv5sjMi/61S4CT4wgI6yG/UoduiT/4K0SPxWwpZzuRQGpWcUo2lB/5ReQj/peLtc5ujPPVox5WzpBWsPq4FM5o8L6GEP3aefXJFL50Tyo1/c45JThImuPGVEXuHAzUy+W4nhlNoMb1CAXJE8tIV3iV5I+L4AtZojwIQ48OvOGvvkPJz3
 vGVbm+rq
 8Q0i7JRe4+0Tc5vsTfd8yJrlsvqSuezyLF1v7m8/XaXl4hVra+aIbkcocWa4bAgRRRWgHyHUTug54dFB93G2C0FC5KAWhtIgcu36b8lYZ5xIq9tvSQJSKNgenNYwu6QdZtVZ8tv8Ph05t3KQjwzhZ7qcmNZeG6xVmKM4nGEkWCeX55wqpNc89f6TsSctVSSBTG1h+N3NkhuAgt2CkMPXUwXXIHQy2vxs7P6eB81psTK2YnPOXg9VFch7OARsnJ1s1BbBjlyKm4kZ3OTk8jbLmKODTKtEfKUa4K3Y7LDGvsyMOs38Ve0FBoZTrnqgKFtIvOp/KmoUB94Y4Jfx5/rFMqSdpDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 2:34 PM, Alistair Popple wrote:
> Unloading the HMM test module produces the following warning:
> 
> [ 3782.224783] ------------[ cut here ]------------
> [ 3782.226323] Device 'hmm_dmirror0' does not have a release() function, it is broken and must be fixed. See Documentation/core-api/kobject.rst.
> [ 3782.230570] WARNING: drivers/base/core.c:2567 at device_release+0x185/0x210, CPU#20: rmmod/1924
> [ 3782.233949] Modules linked in: test_hmm(-) nvidia_uvm(O) nvidia(O)
> [ 3782.236321] CPU: 20 UID: 0 PID: 1924 Comm: rmmod Tainted: G           O        7.0.0-rc1+ #374 PREEMPT(full)
> [ 3782.240226] Tainted: [O]=OOT_MODULE
> [ 3782.241639] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> [ 3782.246193] RIP: 0010:device_release+0x185/0x210
> [ 3782.247860] Code: 00 00 fc ff df 48 8d 7b 50 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 86 00 00 00 48 8b 73 50 48 85 f6 74 11 48 8d 3d db 25 29 03 <67> 48 0f b9 3a e9 0d ff ff ff 48 b8 00 00 00 00 00 fc ff df 48 89
> [ 3782.254211] RSP: 0018:ffff888126577d98 EFLAGS: 00010246
> [ 3782.256054] RAX: dffffc0000000000 RBX: ffffffffc2b70310 RCX: ffffffff8fe61ba1
> [ 3782.258512] RDX: 1ffffffff856e062 RSI: ffff88811341eea0 RDI: ffffffff91bbacb0
> [ 3782.261041] RBP: ffff888111475000 R08: 0000000000000001 R09: fffffbfff856e069
> [ 3782.263471] R10: ffffffffc2b7034b R11: 00000000ffffffff R12: 0000000000000000
> [ 3782.265983] R13: dffffc0000000000 R14: ffff88811341eea0 R15: 0000000000000000
> [ 3782.268443] FS:  00007fd5a3689040(0000) GS:ffff88842c8d0000(0000) knlGS:0000000000000000
> [ 3782.271236] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3782.273251] CR2: 00007fd5a36d2c10 CR3: 00000001242b8000 CR4: 00000000000006f0
> [ 3782.275362] Call Trace:
> [ 3782.276071]  <TASK>
> [ 3782.276678]  kobject_put+0x146/0x270
> [ 3782.277731]  hmm_dmirror_exit+0x7a/0x130 [test_hmm]
> [ 3782.279135]  __do_sys_delete_module+0x341/0x510
> [ 3782.280438]  ? module_flags+0x300/0x300
> [ 3782.281547]  do_syscall_64+0x111/0x670
> [ 3782.282620]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
> [ 3782.284091] RIP: 0033:0x7fd5a3793b37
> [ 3782.285303] Code: 73 01 c3 48 8b 0d c9 82 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 99 82 0c 00 f7 d8 64 89 01 48
> [ 3782.290708] RSP: 002b:00007ffd68b7dc68 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
> [ 3782.292817] RAX: ffffffffffffffda RBX: 000055e3c0d1c770 RCX: 00007fd5a3793b37
> [ 3782.294735] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 000055e3c0d1c7d8
> [ 3782.296661] RBP: 0000000000000000 R08: 1999999999999999 R09: 0000000000000000
> [ 3782.298622] R10: 00007fd5a3806ac0 R11: 0000000000000206 R12: 00007ffd68b7deb0
> [ 3782.300576] R13: 00007ffd68b7e781 R14: 000055e3c0d1b2a0 R15: 00007ffd68b7deb8
> [ 3782.301963]  </TASK>
> [ 3782.302371] irq event stamp: 5019
> [ 3782.302987] hardirqs last  enabled at (5027): [<ffffffff8cf1f062>] __up_console_sem+0x52/0x60
> [ 3782.304507] hardirqs last disabled at (5036): [<ffffffff8cf1f047>] __up_console_sem+0x37/0x60
> [ 3782.306086] softirqs last  enabled at (4940): [<ffffffff8cd9a4b0>] __irq_exit_rcu+0xc0/0xf0
> [ 3782.307567] softirqs last disabled at (4929): [<ffffffff8cd9a4b0>] __irq_exit_rcu+0xc0/0xf0
> [ 3782.309105] ---[ end trace 0000000000000000 ]---
> 
> This is because the test module doesn't have a device.release method. In
> this case one probably isn't needed for correctness - the device structs
> are in a static array so don't need freeing when the final reference
> goes away.
> 
> However some device state is freed on exit, so to ensure this happens at
> the right time and to silence the warning move the deinitialisation to
> a release method and assign that as the device release callback. Whilst
> here also fix a minor error handling bug where cdev_device_del() wasn't
> being called if allocation failed.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Tested-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Thanks,
Zenghui

