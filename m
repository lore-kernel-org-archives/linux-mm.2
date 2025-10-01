Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0180ECCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 16:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606118E0012; Wed,  1 Oct 2025 12:43:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD678E0002; Wed,  1 Oct 2025 12:43:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A7C8E0012; Wed,  1 Oct 2025 12:43:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3FD048E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 12:43:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF3C4140196
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 16:43:27 +0000 (UTC)
X-FDA: 83950116054.15.BBA38D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 105E11A0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 16:43:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=et4f6tyq;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759337006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RNy7oxf6drqmm6IYcV3OWSCXa64vRp5VD07stDp2h3M=;
	b=fnn9XOodHHVYMgM9L1XEdjMojy8IQB+LFb/rlRtoY/bcbLfxEPb/fZe27gvAMcyL8icoOW
	48AzO+bsqX8KthWKTAysj1TOXuH+xqbKZU9KQz4gRFqYwqWRRCLRHqo/JCWVwXMuxJbCsH
	SNeDlk95j1Im8aA52JTLKroqPIN1w20=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759337006; a=rsa-sha256;
	cv=none;
	b=MNQgiVUVJRPFDekBe4gIVQJWykCzXd+7akUQxftc6se7LWrfJZU+frvFuYCRfmE8w0ldVA
	6t6q39hoxLb/47FY7+D1MpSpcKDulK2ixQcAoWAZXyDVzDyH62fSWpUdrwgm3kE25Q3+Rf
	0oWnYhzA9B4dHnWWZB4bm1GdN0k6xQQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=et4f6tyq;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B36CB444B2;
	Wed,  1 Oct 2025 16:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B905C4CEF1;
	Wed,  1 Oct 2025 16:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759337004;
	bh=QNWLZ4djmIVjwAAxkUZ+XJhGSD3E4wAU7zU18m3QAOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=et4f6tyqrgBs7WZdlRex+OjwqnGS/x5v8MW5qcn+FID5dPPlJ6MdrhJ69h5DiRGOU
	 JMdkEsTcrsZICAHv2OlH3sRAZBik9sU0UHIc7UUI0CCMSawT2yT8B82DtPj+LhGlTt
	 yUBy3bUol0m3/CncqRBf25h3T+RjMO/mqJvolAZ/43Ei8ths7hTOrn1i0qlaS980vB
	 kI17kNzpPN97y09flJ7eGoKXitPjRvc2brrw14m4Lv4hDWOpkQC953BAQykS23lhMp
	 73lmIDC0Nn0bZp4CpXnwKzHJmlAvUB6yXZ0M2bDTY//9tiAGJP3K/J5VM8LDPCs5qY
	 HbIogzzOYCGTg==
From: SeongJae Park <sj@kernel.org>
To: Jakub Acs <acsjakub@amazon.de>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@redhat.com,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	peterx@redhat.com,
	axelrasmussen@google.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/ksm: fix flag-dropping behavior in ksm_madvise
Date: Wed,  1 Oct 2025 09:43:22 -0700
Message-Id: <20251001164322.54119-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251001090353.57523-2-acsjakub@amazon.de>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ydp681ia4mhk6wkxxpexdhhasxdx8y7j
X-Rspam-User: 
X-Rspamd-Queue-Id: 105E11A0002
X-Rspamd-Server: rspam10
X-HE-Tag: 1759337005-499101
X-HE-Meta: U2FsdGVkX1+40GI2+oks34MZPrHqEHSA4DIT1qV7W9jYJO8wEyJ003CmwKKr7EfIipxPRlgxySsKyeHFCLFWgSguwCFCqXqYnGkPaEDNQ4dv/SoUMZZQG0y/7N21RUUazA93VdrFrv32MJCbo0w+K40CwmQaNZr4YVZZGioTgd9aGSHoO1ziClRLdJV1VR6ywWkpNHj9mgY9IoIZzUd5fFZ0K1bgwZ/CYqi47HhEMgrQpi4WfuCHkh7zB2qKLy1ek1YC/UXKjO5HjfeTu5ga2xeKeGkN6NHeNep7x27zJEEfkYrF/IT1Xta32HHJuLLbnq+bIEuqcdObby0zxiWBTVUThyy3vaAOrB4CJm3zbNvfb3TInkI1Gj53XkWrxgl/tkzRuUBxSRyW6SOw+hZjfO4OSnlm23l/uNywdoQkzAq2MvHZMxYN40ysS0eArmsAkqqBDzsN+Qu8CWBrVbD70fCfGt5823O+MzODbKmIc0vt+iutnhhUfirg1LyZwVSSnbPt5vUF8+J/skExRmkHQCUqETvugGJ9iGZzB7CDxqc2qidugAX3biDJg/nOO5D7XNAF51svNQnvwWj+wcQ9x5GbGFkkm/FWe37lKBIGkaqJlX1T2ys5DBjdZUcT4ReOxflzvPshxncBnvO57mW33ruxVsGGrQX6tm58kSM4nb1uG0dZuuUpRpRKd2RQIRKvQzjbGtKtl91eOsO4OUFIEK3j1bL6ldlcbTxYe2wMxzzLE2JLPLU66qwHWm6LDGikuydL/n/4jDEEI9nFYYoN88syZGcEJn2erwEYsOw28AzxSxXopzJhsGqBE6TFd+moUckbHDIIZC4xEPlnN5ylIAYQ096hg+991nTDNIqtbFVpNoggs907VAFbX7ho/FBCn3OmyCnccFJi7LYC9GYm9ccW8yaZOQge8M3Wm65kDsUD6XuEhF1L9Mzevof9LJuY9ilM52lOVG/+wKZjWND
 QNdshsdh
 ni5py6bDZy/CbOXsHqrd5ZXERQ5Q6ZJ13ZQchErjIF4a1UkP3yDNclD4ChoqLOHw4FFJuf0GmrHqf68bfmepg71TNMBVkSOHgQW9HZhEMtHK7WYNgnlzX9Dv2P+FlaIM3ct56uZaH2FyoKaE1qDOoUHExkN7Pe8ytsRi1vMrxMZxO4wIE8IGslaOI0j+t4FK8g/NRPh2Kt2J2DTO9SB48FUxw8eLxHFRjjLIzHec351mSNSDku8punytH0YF3vmWpT2GEYduLHU937FfkA2b0ZS3p7KKzvTopNZ7COIyKbbc1YRPgUNj8U2QlnEvyinD0fUMMpUYj4ceKt7lY+r8LuCnUywrD6NH4qzoAOyBB36QT+vKLexMRmVnHQ82Rzct5wytU6XRh2qfOO6HJV6NzVK1DNpf8U5FulWDwL4+jnQior6eO1hgM+cvAdPlGUSDvJ54vOiX1CmYk6nL2r9rsbg9UU2i9sHH2q5PZt1BsbXla83l/ZnKoy+JX+7rHZQNR5EG7j7BEeMP7chy8MBftpuj+Y5Cy4g0hJP5taiEBkrSah1ZPxw540i5VanAeqssZbQHsnHq3/Y37Oz0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 1 Oct 2025 09:03:52 +0000 Jakub Acs <acsjakub@amazon.de> wrote:

> syzkaller discovered the following crash: (kernel BUG)
> 
> [   44.607039] ------------[ cut here ]------------
> [   44.607422] kernel BUG at mm/userfaultfd.c:2067!
> [   44.608148] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
> [   44.608814] CPU: 1 UID: 0 PID: 2475 Comm: reproducer Not tainted 6.16.0-rc6 #1 PREEMPT(none)
> [   44.609635] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> [   44.610695] RIP: 0010:userfaultfd_release_all+0x3a8/0x460
> 
> <snip other registers, drop unreliable trace>
> 
> [   44.617726] Call Trace:
> [   44.617926]  <TASK>
> [   44.619284]  userfaultfd_release+0xef/0x1b0
> [   44.620976]  __fput+0x3f9/0xb60
> [   44.621240]  fput_close_sync+0x110/0x210
> [   44.622222]  __x64_sys_close+0x8f/0x120
> [   44.622530]  do_syscall_64+0x5b/0x2f0
> [   44.622840]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   44.623244] RIP: 0033:0x7f365bb3f227
> 
> Kernel panics because it detects UFFD inconsistency during
> userfaultfd_release_all(). Specifically, a VMA which has a valid pointer
> to vma->vm_userfaultfd_ctx, but no UFFD flags in vma->vm_flags.
> 
> The inconsistency is caused in ksm_madvise(): when user calls madvise()
> with MADV_UNMEARGEABLE on a VMA that is registered for UFFD in MINOR
> mode, it accidentally clears all flags stored in the upper 32 bits of
> vma->vm_flags.
> 
> Assuming x86_64 kernel build, unsigned long is 64-bit and unsigned int
> and int are 32-bit wide. This setup causes the following mishap during
> the &= ~VM_MERGEABLE assignment.
> 
> VM_MERGEABLE is a 32-bit constant of type unsigned int, 0x8000'0000.
> After ~ is applied, it becomes 0x7fff'ffff unsigned int, which is then
> promoted to unsigned long before the & operation. This promotion fills
> upper 32 bits with leading 0s, as we're doing unsigned conversion (and
> even for a signed conversion, this wouldn't help as the leading bit is
> 0). & operation thus ends up AND-ing vm_flags with 0x0000'0000'7fff'ffff
> instead of intended 0xffff'ffff'7fff'ffff and hence accidentally clears
> the upper 32-bits of its value.
> 
> Fix it by changing `VM_MERGEABLE` constant to unsigned long, using the
> BIT() macro.

Nice!

> 
> Note: other VM_* flags are not affected:
> This only happens to the VM_MERGEABLE flag, as the other VM_* flags are
> all constants of type int and after ~ operation, they end up with
> leading 1 and are thus converted to unsigned long with leading 1s.
> 
> Note 2:
> After commit 31defc3b01d9 ("userfaultfd: remove (VM_)BUG_ON()s"), this is
> no longer a kernel BUG, but a WARNING at the same place:
> 
> [   45.595973] WARNING: CPU: 1 PID: 2474 at mm/userfaultfd.c:2067
> 
> but the root-cause (flag-drop) remains the same.
> 
> Fixes: 7677f7fd8be76 ("userfaultfd: add minor fault registration mode")

Nit.  It is recommended [1] to use 12 characters of the SHA-1 ID, but you are
using 13 characters.

> Signed-off-by: Jakub Acs <acsjakub@amazon.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Xu Xin <xu.xin16@zte.com.cn>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org

Nit.  This would be nice to be placed just after the 'Fixes:' tag.

Acked-by: SeongJae Park <sj@kernel.org>

[1] https://docs.kernel.org/process/submitting-patches.html#describe-your-changes


Thanks,
SJ

[...]

