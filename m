Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 788F8E6BF08
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 12:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51A366B0005; Fri, 30 Jan 2026 07:19:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C79B6B0089; Fri, 30 Jan 2026 07:19:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D39D6B008A; Fri, 30 Jan 2026 07:19:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 28B5D6B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 07:19:15 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B8F488C192
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 12:19:14 +0000 (UTC)
X-FDA: 84388535028.12.3BFDBA3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id A08E71A0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 12:19:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769775553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3rSTfLHmcNS8nvtITUG8uvjalVmbtgqljIhY6rTy/a4=;
	b=maGBTQv44HLBfgT0r1gsRT5ev9DpmBqbdiuz5jfJDRRVs2CFUgQnBO8gmpM0Mqqkwnw2ku
	kPW/IEfuR/+Bx54IhNks4dk0MEDNTfl1UvlEWf0JNhs/ImDO5A/RSH73qDMYdSO0q6lB60
	iRz6G1bMFX9amAxCfLcRcyRnge9r7Oc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769775553; a=rsa-sha256;
	cv=none;
	b=Sz/jPRtRIuhGLwwSUiiaoLseZu4lXpQF223leHgLeTfdPWUi/dKOTZ2qJ6ErkSyfypLo8U
	IwHHkznIvKSt6l8OPPIW8Zh33X42N7+dTQqDJW4hsuiS4s+o1WVk64qO5bqYuGdhBS/tOR
	t3QB9RvOABfXO373k2Ytl9cnIFPYC94=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED916153B;
	Fri, 30 Jan 2026 04:19:04 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8FD6E3F632;
	Fri, 30 Jan 2026 04:19:09 -0800 (PST)
Date: Fri, 30 Jan 2026 12:19:06 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, will@kernel.org,
	zengheng4@huawei.com, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, wangkefeng.wang@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] arm64: mm: fix pass user prot to ioremap_prot in
 generic_access_phys
Message-ID: <aXyhuq_DOd2pC_Fo@arm.com>
References: <20260130073807.99474-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130073807.99474-1-tujinjiang@huawei.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: A08E71A0005
X-Rspamd-Server: rspam07
X-Stat-Signature: w4m74r697kxox7yx6ax3sfxogxwoutbt
X-HE-Tag: 1769775552-7068
X-HE-Meta: U2FsdGVkX19SBv3vJ7x0r1Mtmw7gaU2+IFnm3cRD+pIWpj/iC82sD8likY8knJoXOJnajfDWjow5IYG9vHX7N+X6FHuwZg7wD99TsMESMMx3c9A/te5Xl8J2nxZbRRSiK5ixnLKgAuuaw8ngrzQe12WQOtDIMBCxGhifNKtFvC/L4Cr60BCZMP972j9h9QOH8Is/dGC9bNDbAvnVQEsPTUbkK2UfeUjH3rQu8S0agVtePHkv4JasR0Zw7ACEXAyhMSQGelei6gBf4QYaq5cgFyYeq3qaQhCCdNUlXssUnCEhxMID4/4h9hkUevH3LtPJx0zP5x9QNxZ7I2l1S7sd5MEFjqd8gLKbyQSEZ0i8jAhVHZm5eYHXAVzJv77VPWFRtxK2zN0DDtj2FN67PNqVQSBsev3JVz5CkotUC29YfYUgBCU+IruCEUH6EoePGw22+Wnrfxj/in4nIyZ7kxRPk3e3toXLXyvxv5ndSaIYNLdv8lLqrmqGmDw0eb0CIS5nJnDtkxjqNY23hyfSp+U9zUXp+LI/KUpD2YXbR3N2tkbRb+drbReqqHYjrGHxd1Zi5J7Mic19TWZJW69TYHWrjvSxDcafaHJXAHytjQL248ZIecf0kT1oh5DC4ecbltrw+afRGSHtd+lul/uKKa+63JRhNgBPIkpfs/CuyHusD2MGVRFzLRx0CV68uX8t8OKwoLz6aX7REeiKl9KrieGXybAlnWyvAbK7PRwV8XZgOk8DshMgJR3aZq+zxldjWfFOtZVpQX1smbHc2kGIBdIz6lhJZDWg4EdmlPhcxRoWVUfvcVyaC3+HUjhRg6QEULU7xv1pNm803tIzP3+J9yFXAXvM60u72a8b0EBFyHEbFlb6Vgp7IZvVZEbhACiRUWZQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 03:38:07PM +0800, Jinjiang Tu wrote:
> Here is a syzkaller error log:
>   [0000000020ffc000] pgd=080000010598d403, p4d=080000010598d403, pud=0800000125ddb403,
>                      pmd=080000007833c403, pte=01608000007fcfcf
>   Unable to handle kernel read from unreadable memory at virtual address ffff80008ea89000
>   KASAN: probably user-memory-access in range [0x0000000475448000-0x0000000475448007]
>   Mem abort info:
>     ESR = 0x000000009600000f
>     EC = 0x25: DABT (current EL), IL = 32 bits
>     SET = 0, FnV = 0
>     EA = 0, S1PTW = 0
>     FSC = 0x0f: level 3 permission fault
>   Data abort info:
>     ISV = 0, ISS = 0x0000000f, ISS2 = 0x00000000
>     CM = 0, WnR = 0, TnD = 0, TagAccess = 0
>     GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
>   swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000001244aa000
>   [ffff80008ea89000] pgd=100000013ffff403, p4d=100000013ffff403, pud=100000013fffe403,
> 		     pmd=100000010a453403, pte=01608000007fcfcf
>   Internal error: Oops: 000000009600000f [#1] SMP
>   Modules linked in: team
>   CPU: 1 PID: 10840 Comm: syz.9.83 Kdump: loaded Tainted: G
>   Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
>   pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>   pc : __memcpy_fromio+0x80/0xf8
>   lr : generic_access_phys+0x20c/0x2b8
>   sp : ffff8000a0507960
>   x29: ffff8000a0507960 x28: 1ffff000140a0f44 x27: ffff00003833cfe0
>   x26: 0000000000000000 x25: 0000000000001000 x24: 0010000000000001
>   x23: ffff80008ea89000 x22: ffff00004ea63000 x21: 0000000000001000
>   x20: ffff80008ea89000 x19: ffff00004ea62000 x18: 0000000000000000
>   x17: 0000000000000000 x16: 0000000000000000 x15: ffff8000806f1e3c
>   x14: ffff8000806f1d44 x13: 0000000041b58ab3 x12: ffff7000140a0f23
>   x11: 1ffff000140a0f22 x10: ffff7000140a0f22 x9 : ffff800080579d24
>   x8 : 0000000000000004 x7 : 0000000000000003 x6 : 0000000000000001
>   x5 : ffff8000a0507910 x4 : ffff7000140a0f22 x3 : dfff800000000000
>   x2 : 0000000000001000 x1 : ffff80008ea89000 x0 : ffff00004ea62000
>   Call trace:
>     __memcpy_fromio+0x80/0xf8
>     generic_access_phys+0x20c/0x2b8
>     __access_remote_vm+0x46c/0x5b8
>     access_remote_vm+0x18/0x30
>     environ_read+0x238/0x3e8
>     vfs_read+0xe4/0x2b0
>     ksys_read+0xcc/0x178
>     __arm64_sys_read+0x4c/0x68
>     invoke_syscall+0x68/0x1a0
>     el0_svc_common.constprop.0+0x11c/0x150
>     do_el0_svc+0x38/0x50
>     el0_svc+0x50/0x258
>     el0t_64_sync_handler+0xc0/0xc8
>     el0t_64_sync+0x1a4/0x1a8
>   Code: 91002339 aa1403f7 8b190276 d503201f (f94002f8)
> 
> The local syzkaller first maps I/O address from /dev/mem to userspace,
> overiding the stack vma with MAP_FIXED flag. As a result, when reading
> /proc/$pid/environ, generic_access_phys() is called to access the region,
> which triggers a PAN permission-check fault and causes a kernel access
> fault.
> 
> The root cause is that generic_access_phys() passes a user pte to
> ioremap_prot(), the user pte sets PTE_USER and PTE_NG bits.  Consequently,
> any subsequent kernel-mode access to the remapped address raises a fault.
> 
> To fix it, define arch_mk_kernel_prot() to convert user prot to kernel
> prot for arm64, and call arch_mk_kernel_prot() in generic_access_phys(),
> so that a user prot is passed to ioremap_prot().
> 
> Fixes: 893dea9ccd08 ("arm64: Add HAVE_IOREMAP_PROT support")
> Signed-off-by: Zeng Heng <zengheng4@huawei.com>
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

That's not urgent for 6.19, it's just misuse of /dev/mem (aren't they
all) but it's worth fixing.

Thanks.

-- 
Catalin

