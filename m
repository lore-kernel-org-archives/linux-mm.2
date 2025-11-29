Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69A2ECFD2F6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 18:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 507AD6B0008; Sat, 29 Nov 2025 13:07:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4927C6B000A; Sat, 29 Nov 2025 13:07:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3595B6B000C; Sat, 29 Nov 2025 13:07:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1DAFE6B0008
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 13:07:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7E9512EC70
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 18:07:01 +0000 (UTC)
X-FDA: 84164425842.07.E89C763
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 12FEE40011
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 18:06:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=imequqQ+;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764439620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EIt6lFRNy0y5ogK7k6YPxw5lcXWuqpwlSXjb5ATV7rU=;
	b=bI0EXhQ+9Z1gSfBJv6f75GBdGyr28dEYsPyNlScDq+xIyb/ngaFLvDJbRREcrTG52Cx4WQ
	Z+v04Wme1aY4+yeoNSeJGNx1orGko/MuC8BzQIQtsGpKGGhtG8QnCprQmfhpbqa2U1PPIF
	dmDAXKs27r/fjQr491dL1w39uTISpXU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=imequqQ+;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764439620; a=rsa-sha256;
	cv=none;
	b=1lhPpK4AY4CPWbpuIjHJ3zh2jOYyUzLpCnN53ZcpOZ1iykxIx6rURoK5rw879pl3tsStFX
	GDyZS1q5whilaxkpRGb0d2TyQi6hkvlBIc+DYFNsFDyCHggSQ6lMtHXYqQbWFc7BAHIO8L
	ZZTgNXOwOayP48B0NFDfv3x3PAahivQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6731D60051;
	Sat, 29 Nov 2025 18:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952E3C4CEF7;
	Sat, 29 Nov 2025 18:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764439619;
	bh=nHDT+vnVr9ZxoQNQJxT+ttjh4quzdU+UxPDtwJWJq9Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=imequqQ+pT6INKeFynsxEJTEi5ZQUOItUSepXeIIj0XlNMIRMi2GdRFp1LsQlnirL
	 Ibr6hf35eNoBXFqol2lu4UpPb4GkIS3TOn2Y5YI+pLWuYA6hDM5l36aflaAbALkxVc
	 FLdxZYEfksXfgRkwCy+oGFJKtKjO/B2SCEXq39VA=
Date: Sat, 29 Nov 2025 10:06:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: catalin.marinas@arm.com, kevin.brodsky@arm.com, ryabinin.a.a@gmail.com,
 glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
 vincenzo.frascino@arm.com, urezki@gmail.com, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
 stable@vger.kernel.org, Jiayuan Chen <jiayuan.chen@linux.dev>
Subject: Re: [PATCH] kasan: hw_tags: fix a false positive case of vrealloc
 in alloced size
Message-Id: <20251129100658.6b25799da5ace00c3a6d0f42@linux-foundation.org>
In-Reply-To: <20251129123648.1785982-1-yeoreum.yun@arm.com>
References: <20251129123648.1785982-1-yeoreum.yun@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 12FEE40011
X-Rspamd-Server: rspam02
X-Stat-Signature: febexsp69nu5xjf9ys6uceckj3apegz8
X-Rspam-User: 
X-HE-Tag: 1764439619-192504
X-HE-Meta: U2FsdGVkX1/ptIKCx6bBCSXp+Bscq17MW6sVPY/x3D3aI8TBLz5tffL3bkjxrGWW9RXukUx2gthEctTYj6Lk4mFb4HRFWV1SqjDOHE5ZpdZxdiMcvuCssMwn1xrt1AlFKDxDpIjoHhJjT9JijIrY11PJN4t8hl7ippNwr7WkldwlvtOn5Z0HkE+96Q9x6oz1kCuEbNZZxvggrnyXrLdq2PYBMfirYDot7ZV/53CjHQR6qHkJp5PE7KoGnad+GyLvuzea4xVU+95xA001rYWBpu9WT9ACvohvk17VFLEl7M9QG15CNn9+TEMDOVJ+zKlZImq7NQMVeVYNlYmcJVS6qlb9/7vUtmCqCbVV4jO0E5AnN05F6kXD+rPnVbPPIY9SLfo6JH6knkQGZuN80SHhr3cuCg7eN6C/4UEt9e4qs/Jo/8vCR2wBDGv1xnVsBnxo2HfVm9F6AI4Bh8mMk59XojzRK0KXwZtkcNSblRm4XW9OADFWuHKZXkWNfb2Fw4xYrQEYKURVQGtcWrRz9PwYTq0VPvjkaZPsySTs54JQrxTwFhJURCRkjjXuQJX88pCysq5ptvbijUKK5RUO0+HpByLY+1L12A6wz5XSHUUU+VgCn++VauRf9QjydvTwmXwhY1RKjHbH/eSSFbX95tTZzpdtIYtABdbJpKcpWB+iHNxnvOS3CIg6kpGwHgX2mPtkidYxnK0TWCE1DsgAq225zlEXaR51tqIMaSlhLnGBOyZEoEYR1r+fUfsqSwFPn5YlR8DwW5cKGcDXSkVf/C+n0RUAtKsgOKqhqXWc3nOZ/KUlknrFFDHtNtSMm0hOeSn5FCYRLfKJ0QP3eUv+8P/4LIqdFlmGX7uzDd2tANdZPZnSNQ42EsGW+5Nfik5/RKoERlqYhHEej0LW/0YYkEMwqfAfcaRtZJFbqW3q0SZq9OJ+V/zz+xN9XMl0XegGzUOobjnXlRS/wLNlsqPfamr
 IPfr9vuW
 CTdTjUPtaRk2QlW0Ns9l+Hq/owFmso6Moj1pod4FMn+ViKgHiheNQOSyjfUcr8yJ1IcmWw7G/PWuHKQ7+/LvMQd+vlYTR/k8mWycbCVt+hUiSN89Ao2AIIhAp0Ar4wiknsD82LfGTKc2TgTFDHVAMSavy5+VJ2rToP6MM9C8mv3fAzDJtHMzCFJSDa/jz+EIWHUhRk1foRnMksW82rxEqPhrTXwemqD+FknxEe16UBu0Xqg2JaP7jwo3u2FhFqLhn0+Ljsi/X0A+eYXIaJoQGWmJNh7VjJEJfV+6NtMbwO5cDonIUpx1h1GN7AMqDjJSaRtIymZ3fFZoIqzAMOuOdB2zK8tJf/EdVKupNRUDIzO/MnkDhqFxCS8Xe7ePnZT+XcAMo7HuiPC7E0aa/x9fjsV1uZP1KQpJJiP2JiIAl+iwJJLz/5HDvc+QGoDEQjPhTo8dJKVdL15dSjxUM/QSKV7tx+0elz29dPf7v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 29 Nov 2025 12:36:47 +0000 Yeoreum Yun <yeoreum.yun@arm.com> wrote:

> When a memory region is allocated with vmalloc() and later expanded with
> vrealloc() — while still within the originally allocated size —
> KASAN may report a false positive because
> it does not update the tags for the newly expanded portion of the memory.
> 
> A typical example of this pattern occurs in the BPF verifier,
> and the following is a related false positive report:
> 
> [ 2206.486476] ==================================================================
> [ 2206.486509] BUG: KASAN: invalid-access in __memcpy+0xc/0x30
> [ 2206.486607] Write at addr f5ff800083765270 by task test_progs/205
> [ 2206.486664] Pointer tag: [f5], memory tag: [fe]
> [ 2206.486703]
> [ 2206.486745] CPU: 4 UID: 0 PID: 205 Comm: test_progs Tainted: G           OE       6.18.0-rc7+ #145 PREEMPT(full)
> [ 2206.486861] Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
> [ 2206.486897] Hardware name:  , BIOS
> [ 2206.486932] Call trace:
> [ 2206.486961]  show_stack+0x24/0x40 (C)
> [ 2206.487071]  __dump_stack+0x28/0x48
> [ 2206.487182]  dump_stack_lvl+0x7c/0xb0
> [ 2206.487293]  print_address_description+0x80/0x270
> [ 2206.487403]  print_report+0x94/0x100
> [ 2206.487505]  kasan_report+0xd8/0x150
> [ 2206.487606]  __do_kernel_fault+0x64/0x268
> [ 2206.487717]  do_bad_area+0x38/0x110
> [ 2206.487820]  do_tag_check_fault+0x38/0x60
> [ 2206.487936]  do_mem_abort+0x48/0xc8
> [ 2206.488042]  el1_abort+0x40/0x70
> [ 2206.488127]  el1h_64_sync_handler+0x50/0x118
> [ 2206.488217]  el1h_64_sync+0xa4/0xa8
> [ 2206.488303]  __memcpy+0xc/0x30 (P)
> [ 2206.488412]  do_misc_fixups+0x4f8/0x1950
> [ 2206.488528]  bpf_check+0x31c/0x840
> [ 2206.488638]  bpf_prog_load+0x58c/0x658
> [ 2206.488737]  __sys_bpf+0x364/0x488
> [ 2206.488833]  __arm64_sys_bpf+0x30/0x58
> [ 2206.488920]  invoke_syscall+0x68/0xe8
> [ 2206.489033]  el0_svc_common+0xb0/0xf8
> [ 2206.489143]  do_el0_svc+0x28/0x48
> [ 2206.489249]  el0_svc+0x40/0xe8
> [ 2206.489337]  el0t_64_sync_handler+0x84/0x140
> [ 2206.489427]  el0t_64_sync+0x1bc/0x1c0
> 
> Here, 0xf5ff800083765000 is vmalloc()ed address for
> env->insn_aux_data with the size of 0x268.
> While this region is expanded size by 0x478 and initialise
> increased region to apply patched instructions,
> a false positive is triggered at the address 0xf5ff800083765270
> because __kasan_unpoison_vmalloc() with KASAN_VMALLOC_PROT_NORMAL flag only
> doesn't update the tag on increaed region.
> 
> To address this, introduces KASAN_VMALLOC_EXPAND flag which
> is used to expand vmalloc()ed memory in range of real allocated size
> to update tag for increased region.

Thanks.

> Fixes: 23689e91fb22 ("kasan, vmalloc: add vmalloc tagging for HW_TAGS”)
> Cc: <stable@vger.kernel.org>

Unfortunately this is changing the same code as "mm/kasan: fix
incorrect unpoisoning in vrealloc for KASAN",
(https://lkml.kernel.org/r/20251128111516.244497-1-jiayuan.chen@linux.dev)
which is also cc:stable.

So could you please take a look at the code in mm.git's
mm-hotfixes-unstable branch
(git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm) and base the
fix upon that?  This way everything should merge and backport nicely.



