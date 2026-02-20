Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C46CC53215
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 05:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A413C6B0088; Fri, 20 Feb 2026 00:12:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EF5A6B0089; Fri, 20 Feb 2026 00:12:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FB346B008A; Fri, 20 Feb 2026 00:12:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7956A6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 00:12:46 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39F2C1A0AAD
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:12:46 +0000 (UTC)
X-FDA: 84463665132.06.CA4204D
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7B1C7C0006
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:12:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771564364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2IjES6tDriSJL5JKekSnrDSjo356W2vs/CEnhWZ8sCo=;
	b=C7gp/QxAAzSx08R0LAH/CcpfLn2x7dRh0GO3reKkPo8TeNvVpT+7KKR34U3u5WIRGgUtKj
	KtiCKU7JvVi8OU3w5h5GI3EaP29z4mAJNHWePtsk3eunIsgYIlUVOHaBnyb1NLNpF+/PPT
	vnj7zMDE4yHFNU8zXuam7B3ngjb8zJE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771564364; a=rsa-sha256;
	cv=none;
	b=rSjJznwcaEK/vDh8VxHZOFtyHlQejRY6fivVUd5VYm/kWD3y22kyhoUbTs5jw3kz/NA2C3
	OKoO0dA/KC9kkgw1HxWgVMGHNUIf8Vota9eR3177VIJ3eyhCjGTtpTNWgkiQQvY2jPy6TZ
	CGqD82df1AwSqMeRcLDExpX1c0vzLRE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org;
	dmarc=none
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61K5CZow646695;
	Thu, 19 Feb 2026 23:12:40 -0600
Message-ID: <e6bee1f5a32b8164b66381d353d8182078619dbf.camel@kernel.crashing.org>
Subject: Re: [PATCH v2] mm: Fix memblock_free_late() when using deferred
 struct page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Date: Fri, 20 Feb 2026 16:12:35 +1100
In-Reply-To: <aZbjCFqlqdFwKSHR@kernel.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
	 <14295eba34f10f5896e6cb7d3e1abd36199cd918.camel@kernel.crashing.org>
	 <4d93284349178a783725539b66dca25725fa779d.camel@kernel.crashing.org>
	 <aZVyxKVS8y-rqwrK@kernel.org>
	 <6453da0558ba20d5c87e730bdfedd47966977931.camel@kernel.crashing.org>
	 <aZbjCFqlqdFwKSHR@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 7B1C7C0006
X-Stat-Signature: 66yxm5cgwgrj69ehuesitigj9i9m8to8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771564364-49148
X-HE-Meta: U2FsdGVkX19hYH13yaLlKm7TSx9PRHRST3M7v/aGslQwpYXulYBk8Rxy17sWmrG51z85Eyfh55iHt2OudPR0CAtUSKm6QiSEhHvDMCrybQCsQNK13jlHPAsymYpJ7TfXnDYNJtOcQybH8KjCSIMBrAY7Y++Uhn4+qQQDKVRpodgZfb43XN7SbypJ/Og48ApDNyZjsf2xLae576avaKtgR4dqYFThWlWuq1E5/Y1VaFKN/cgNYZu19DZ4cyQfvahGDAnC3OMyLv+XvTUlBBBDMuXFbkDtU8t5G1x1m1QKM1GHC+GjmOsRNqhjWPrVn0lcSg/xfJt0MDTsSiZTF+oh6R39smLc0kLh2/QMX6ymT8NhtKl0xv+Bchmrsyp1v+vd6upvuANEW6gYd6q/xBbeD28O3mRe6cfCOEuoTrNWjaRhOw74I8YwufPLLr/sywbShKp4xZUeWDMuOn/KkVcQbdN3N3tfTn9rSjt7HwC9XEJpM2rjwvE80TAIwUVVx/uFOyw8JCXsDcXeyiGwUFokRe4nUaosiQjlZzDKJpe2/Tinyods5AExR8hjcwEkxGnpneRi30Oa/L8rhz4VkGg1l46BRIe5tHT4Sqa78PAzKhb98RslCWfpJRsGjO8HvGruIPxBY4CW1cbGnFW/QwhOA/eZRtAgHVhHZv0Dh554XB6nJd4GQOEug9/yMF5hSa/5DbOA0h2b3++tRqXJDCDNggo+TYFZlr8EJFVBX0zq+SRTQtd2hqryyinfQt3caejg8XSEfCMsrzcsnd4gxcLJsxvAAr4chwZtbMa1Yc6uaLx+NMf+9UzHoAc1yF/u6q6EjRbjkYBX5v9WSOAq7bylcmFJuEXwCmYEWFVaHr1TnI47sNPH6+bBaxIV8yM80PX7NQ66PzLncBLNGoSGwBSbvriwxSxz9rhnjYf1z5I9+QLotIM1QIA42oWqCDE/KLwRj7zgKcWCNSKrKEEJgLk
 n10RH8jc
 Rpigg3jgod8/blILy5XtxITMs9eBQ+m0xJcggPkBo5TLtBlV6ObnIrzzjOE+AfSfmrVYh//caXi0p47yfXe0Cl7mNGGj6bOTIX7g5W7t5sR0eo+88ZIv1AHKoIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ugh ... backport to 6.12.68:

(sorry, no more logs, it's from the large scale testsuite, a couple of
hits out of 1450 tests but all run with "quiet" on the command line).

260	[    0.014444] ACPI: SPCR: [Firmware Bug]: Unexpected SPCR Access Width=
. Defaulting to byte size
261	[    1.015737] BUG: kernel NULL pointer dereference, address: 000000000=
0000000
262	[    1.016238] #PF: supervisor read access in kernel mode
263	[    1.016651] #PF: error_code(0x0000) - not-present page
264	[    1.017070] PGD 0 P4D 0=20
265	[    1.017274] Oops: Oops: 0000 [#1] PREEMPT SMP PTI
266	[    1.017664] CPU: 23 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.12.6=
8-94.123.amzn2023.x86_64 #1
267	[    1.018384] Hardware name: Amazon EC2 c5n.metal/Not Specified, BIOS =
1.0 10/16/2017
268	[    1.019011] RIP: 0010:efi_free_boot_services_memory+0xd/0x60
269	[    1.019472] Code: 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90=
 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 55 48 8b 2d 2b a2 39 00=
 <48> 8b 45 00 48 85 c0 74 31 48 8b 75 08 31 c9 ba ff ff ff ff 48 83
270	[    1.021033] RSP: 0000:ffffcfcd40037e00 EFLAGS: 00010246
271	[    1.021461] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000=
000000000
272	[    1.022059] RDX: 0000000000000000 RSI: 0000000000000202 RDI: fffffff=
fafa663d0
273	[    1.022637] RBP: 0000000000000000 R08: 000001158a8b1d80 R09: 0000011=
58a8b1d80
274	[    1.023222] R10: 0000000000000012 R11: fefefefefefefeff R12: ffff8a8=
a5f142a00
275	[    1.023813] R13: 0000000000000139 R14: 0000000000000000 R15: 0000000=
000000000
276	[    1.024399] FS:  0000000000000000(0000) GS:ffff8a8a5ee80000(0000) kn=
lGS:0000000000000000
277	[    1.025064] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
278	[    1.025513] CR2: 0000000000000000 CR3: 0000000683c34001 CR4: 0000000=
0007706f0
279	[    1.025513] PKRU: 55555554
280	[    1.025513] Call Trace:
281	[    1.025513]  <TASK>
282	[    1.025513]  ? __pfx_efi_free_boot_services_memory+0x10/0x10
283	[    1.025513]  do_one_initcall+0x41/0x300
284	[    1.025513]  do_initcalls+0xac/0x130
285	[    1.025513]  kernel_init_freeable+0x256/0x310
286	[    1.025513]  ? __pfx_kernel_init+0x10/0x10
287	[    1.025513]  kernel_init+0x16/0x1c0
288	[    1.025513]  ret_from_fork+0x2d/0x50
289	[    1.025513]  ? __pfx_kernel_init+0x10/0x10
290	[    1.025513]  ret_from_fork_asm+0x1a/0x30
291	[    1.025513]  </TASK>
292	[    1.025513] Modules linked in:
293	[    1.025513] CR2: 0000000000000000
294	[    1.025513] ---[ end trace 0000000000000000 ]---
295	[    1.025513] RIP: 0010:efi_free_boot_services_memory+0xd/0x60
296	[    1.025513] Code: 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90=
 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 55 48 8b 2d 2b a2 39 00=
 <48> 8b 45 00 48 85 c0 74 31 48 8b 75 08 31 c9 ba ff ff ff ff 48 83
297	[    1.025513] RSP: 0000:ffffcfcd40037e00 EFLAGS: 00010246
298	[    1.025513] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000=
000000000
299	[    1.025513] RDX: 0000000000000000 RSI: 0000000000000202 RDI: fffffff=
fafa663d0
300	[    1.025513] RBP: 0000000000000000 R08: 000001158a8b1d80 R09: 0000011=
58a8b1d80
301	[    1.025513] R10: 0000000000000012 R11: fefefefefefefeff R12: ffff8a8=
a5f142a00
302	[    1.025513] R13: 0000000000000139 R14: 0000000000000000 R15: 0000000=
000000000
303	[    1.025513] FS:  0000000000000000(0000) GS:ffff8a8a5ee80000(0000) kn=
lGS:0000000000000000
304	[    1.025513] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
305	[    1.025513] CR2: 0000000000000000 CR3: 0000000683c34001 CR4: 0000000=
0007706f0
306	[    1.025513] PKRU: 55555554
307	[    1.025513] Kernel panic - not syncing: Fatal exception
308	[    1.025513] Kernel Offset: 0x2c000000 from 0xffffffff81000000 (reloc=
ation range: 0xffffffff80000000-0xffffffffbfffffff)
309	[    1.025513] ---[ end Kernel panic - not syncing: Fatal exception ]--=
-

