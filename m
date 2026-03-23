Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C971F483DC
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 17:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C76246B0088; Mon, 23 Mar 2026 13:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D0F6B008C; Mon, 23 Mar 2026 13:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B87646B0088; Mon, 23 Mar 2026 13:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A31646B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:24:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 479EAC0DFE
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:24:49 +0000 (UTC)
X-FDA: 84578002698.28.2C52B0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9133D80008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:24:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h6z1XBcx;
	spf=pass (imf02.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774286687; a=rsa-sha256;
	cv=none;
	b=FNv7cttNbmWcuj5bCTR1Eg4RWDe8DSk7tkhzNvFZYjjzthcDbQi4Duj3eD0yxdXEPCvV2o
	TiTzlBgL+45WzGDT/T+JBn9MPLx5eYuVhl1AFYgUdtzeDNHEIykRrBuBh/+l+LOwxdDRxm
	wsJDWMXsE2fAfo2K7YBrIe9WN9f/WwI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774286687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yBg2qMLJDqdx3AMYjnxthe7IrbvdpRd1x4RaEUILeJM=;
	b=R5GY1GGldjCAW0kXhft1YCO1BbkkvvK7Zh7WZWyHVRggDC5DsrQra2zvziBy6CHiUQmlsX
	JZAM1US6DcsoKkDQ/zKjzhl7iF1wHCLhol1VDkBusxddkZl5HzSde0c8ol1wMIWnKc6lM2
	9WVkmd1HTuRaHHpyUgvidOjYUYqRHec=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h6z1XBcx;
	spf=pass (imf02.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 892B94082B;
	Mon, 23 Mar 2026 17:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CD3C2BCB3;
	Mon, 23 Mar 2026 17:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774286686;
	bh=5rreWIFoBoqRLvvete3U9VClnhxT5TadVzK4NkDP+EU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=h6z1XBcxWz5pCI1SUvB5F7QjzqXt1wzbdHfwAi9WqwQ9jNLhm0RhQeXtYJtSYV5/5
	 zdsCQzwpXTE6sKPEXtsEdxGWpI9P02K3tuh+sXGI62N96fykAzXVHeEcEWwmuwjC88
	 pDP9ZMnP3tf51pQ5iVll69G4/NYkqGHk1/kLY8/5ft7PUJV5ERoFc9zDq7nt3qyxJY
	 Ti9lYdG9BAnuFADdOg7HDhz3vzxcemQ18Exg4G2ZRNsLiBkJL/gROSlfY3WEDW7P8E
	 H6Qt5rpQ6DVbzkZc3Z8QMa8FYS2/tvw8WX//0Xr9XSYOVagklAyGbNxAEp8da5EKsS
	 ZKxT3bDHn8eNQ==
From: Thomas Gleixner <tglx@kernel.org>
To: Hao-Yu Yang <naup96721@gmail.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, David Hillenbrand <david@kernel.org>, Eric
 Dumazet <edumazet@google.com>, linux-mm@kvack.org, Peter Zijlstra
 <peterz@infradead.org>
Subject: Re: [PATCH v2] futex: Use-after-free between futex_key_to_node_opt
 and vma_replace_policy
In-Reply-To: <20260313124756.52461-1-naup96721@gmail.com>
References: <20260313124756.52461-1-naup96721@gmail.com>
Date: Mon, 23 Mar 2026 18:24:42 +0100
Message-ID: <87a4vyihlx.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9133D80008
X-Stat-Signature: 3czfm97xx6bbjsjm4napppa3yias57qu
X-HE-Tag: 1774286687-998234
X-HE-Meta: U2FsdGVkX1+TC9LZfFIq3lZuKCJkmqJWvamT8Eq3a66tTf48voG7b+u095/taD4d63UZBnoqRHKHI5K7BabdXfFAy0dMb57zwm9z3SZVnkhiRzYyEZ5cCLD2UqIHE6pZ3mhMzzJn3KbObh8AsCV3CNPCJIQ/CB734ei2gmFAEclPYlRGKaNt3LEziB9qGaYNz0zy3Q5y+FmewItVnbFlHU5sr8WeYZgAnwdbKvpoaNVLFZMBiVonZaU03+d7MyhU/Nr98C3n2KRUakddjxy6PpMVtKdC55lD23FlUVtWEJdX81G2oJgn0hxF1DM7Okl3Hw9mLAPg80/QilYYSFqiUn+2/2oJ1nxQAB9+pZyFHYtLTexHomRWURFi9P5jcrjtYJk8i4jL+RdaaUJXFscRVld2gX511pWJEDWM6EJXBxqD3nkKKXkn/hL0OWDCXN38slE25qt0HSVCv2/Pltm1C73nE5IFVB+xuyOfWXoFa9bFu2GuC3rx63WYD4X+OK6OuKeMMEiZoKMw6kZKVF9n3Wd1tlTTFubqisaQwnXy/MxpJVUNf+aM2ZI5xGfWHjrjKNKKLg6CtSmYU47ZKmqe2Rok4l2n/VC/fKrZSLuk3BxmTmYKiSoP4fj12gTwc2wh9p/K3WRHMrLs/CPWR+biuPn27/HyOMO97D+bjY4QH16qjPwqcASMH3MwE8aYwmNdq9Duvt/sZwwzfaJdSW7RF7Cn1dxmCdTCFUUnlmmQA+T6P30libWuX9rl/e+Nr8f/myxM90J7sJNlmZj24cWRJa+g+4OQT8oCHYmvG4wlWYGmmNgIL7wdip1ALFGVecpXIJneOZDlJhRt3CQzcF+etSD+mtgbAzzjNyzCVf6+FRrkiaSvWZe3J5Jg/Hf/v1V/psqxMdndtiBD8P/x/LQGxL0SBI/BtL75AfLl1QJBRYON5PVeENAItBH+k17f7G0lYzoP/3lSZ+NSTV5LPu7
 k0rTfKj6
 FGwpiPQqMmFcummCQ0V2E9zyDCvxs10jKd/FHwV7UA/PPptjMxtbj6mCZuee7wsZ33+33ulLzN7KtCUjtUiPYV/X06TRbTzmh84xPwIhj0fWTEXP7Uw+RWfSZgoeUh0Qnh27onk6In4VP+dn/ftqfqksVaTuaGf/kkOdwAvt7lo8NrmoauKu/hznSmsoov7hL59CsrmIg0wwLDDhPMOzuqN3FxHjzfi/jOBVTTRgd7z8uBMpDQ/M0PWLj12D44G5edDcC1oRbHetTKysBzTRte8vdbu/M8/dbJaHbt2nF96HXymiuIOHPcO1k0KED71bCBpusgmxusatlPCH97KhDCrdwwzS73DmZFDlZBtnUgT/WA+CLXKVhE1lVq3FGPff0QRIlyWq68p46XzY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hao-Yu!

On Fri, Mar 13 2026 at 20:47, Hao-Yu Yang wrote:

I've removed the security list as this is public already.
Also added the mm list and the maintainers. While it fixes the futex
problem it is a change to the MM subsystem, so those people need to be
involved.

> During futex_key_to_node_opt() execution, vma->vm_policy is read under
> speculative mmap lock and RCU. Concurrently, mbind() may call
> vma_replace_policy() which frees the old mempolicy immediately via
> kmem_cache_free().
>
> This creates a race where __futex_key_to_node() dereferences a freed
> mempolicy pointer, causing a use-after-free read of mpol->mode.

> [  151.412631] BUG: KASAN: slab-use-after-free in __futex_key_to_node (kernel/futex/core.c:349)
> [  151.414046] Read of size 2 at addr ffff888001c49634 by task e/87
> [  151.414476]
> [  151.415431] CPU: 1 UID: 1000 PID: 87 Comm: e Not tainted 7.0.0-rc3-g0257f64bdac7 #1 PREEMPT(lazy)
> [  151.415758] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> [  151.415969] Call Trace:
> [  151.416059]  <TASK>
> [  151.416161]  dump_stack_lvl (lib/dump_stack.c:123)
> [  151.416299]  print_report (mm/kasan/report.c:379 mm/kasan/report.c:482)
> [  151.416359]  ? __virt_addr_valid (./include/linux/mmzone.h:2046 ./include/linux/mmzone.h:2198 arch/x86/mm/physaddr.c:54)
> [  151.416412]  ? __futex_key_to_node (kernel/futex/core.c:349)
> [  151.416517]  ? kasan_complete_mode_report_info (mm/kasan/report_generic.c:182)
> [  151.416583]  ? __futex_key_to_node (kernel/futex/core.c:349)
> [  151.416631]  kasan_report (mm/kasan/report.c:597)
> [  151.416677]  ? __futex_key_to_node (kernel/futex/core.c:349)
> [  151.416732]  __asan_load2 (mm/kasan/generic.c:271)
> [  151.416777]  __futex_key_to_node (kernel/futex/core.c:349)
> [  151.416822]  get_futex_key (kernel/futex/core.c:374 kernel/futex/core.c:386 kernel/futex/core.c:593)
> [  151.416871]  ? __pfx_get_futex_key (kernel/futex/core.c:550)
> [  151.416927]  futex_wake (kernel/futex/waitwake.c:165)
> [  151.416976]  ? __pfx_futex_wake (kernel/futex/waitwake.c:156)
> [  151.417022]  ? __pfx___x64_sys_futex_wait (kernel/futex/syscalls.c:398)
> [  151.417081]  __x64_sys_futex_wake (kernel/futex/syscalls.c:382 kernel/futex/syscalls.c:366 kernel/futex/syscalls.c:366)
> [  151.417129]  x64_sys_call (arch/x86/entry/syscall_64.c:41)
> [  151.417236]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
> [  151.417342]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
> [  151.418312]  </TASK>

Please trim the backtrace so it only contains the real important
information.

  https://docs.kernel.org/process/submitting-patches.html#backtraces-in-commit-messages

> Fix by adding rcu to __mpol_put().
>
> change-log:
>  v2-v1: add rcu to __mpol_put

The change history is not part of the change log, it want's to be placed
after the --- separator.

> Fixes: c042c505210d ("futex: Implement FUTEX2_MPOL")
> Reported-by: Hao-Yu Yang <naup96721@gmail.com>
> Signed-off-by: Hao-Yu Yang <naup96721@gmail.com>

This should have a

     Suggested-by: Eric Dumazet <edumazet@google.com>

tag.

> ---
>  include/linux/mempolicy.h | 1 +
>  mm/mempolicy.c            | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
> index 0fe96f3ab3ef..65c732d440d2 100644
> --- a/include/linux/mempolicy.h
> +++ b/include/linux/mempolicy.h
> @@ -55,6 +55,7 @@ struct mempolicy {
>  		nodemask_t cpuset_mems_allowed;	/* relative to these nodes */
>  		nodemask_t user_nodemask;	/* nodemask passed by user */
>  	} w;
> +	struct rcu_head rcu;
>  };
>  
>  /*
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 0e5175f1c767..6dc61a3d4a32 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -487,7 +487,7 @@ void __mpol_put(struct mempolicy *pol)
>  {
>  	if (!atomic_dec_and_test(&pol->refcnt))
>  		return;
> -	kmem_cache_free(policy_cache, pol);
> +	kfree_rcu(pol, rcu);
>  }
>  EXPORT_SYMBOL_FOR_MODULES(__mpol_put, "kvm");

While this looks functionally correct it is incomplete in terms of RCU.

The vma->vm_policy pointer needs to be marked __rcu. That then requires
to use rcu_dereference_check() at the reader side and
rcu_assign_pointer() and rcu_replace_pointer() on the writer side.

Especially the writer side is required so that the proper memory
barriers are inserted for architectures with a weakly ordered memory
model.

Thanks,

        tglx

