Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94741FC72C5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC9DC6B008C; Mon, 23 Mar 2026 19:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7AB66B0095; Mon, 23 Mar 2026 19:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90426B0096; Mon, 23 Mar 2026 19:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 973CB6B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:43:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BDA6160DB9
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:43:58 +0000 (UTC)
X-FDA: 84578958156.13.F2D7F41
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 56CCB140006
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:43:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lmIZMrLr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of naup96721@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=naup96721@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774309436; a=rsa-sha256;
	cv=none;
	b=0pTH9FccCX4VR/dNF3Bvw7wIK0LVrULX1wBFMHm32Y/W4UfRo+nw+CULsy4Nsp3QKQPdj0
	D2HldVkzcbgeQ1LAVx7IMIqTLZkSlEjB4TqGDbzejhaWqstmGfVBAsSr/XRgWSfHLRTYxP
	PMx0TPGKfOMTTjKcm/S+XqNByT5GLKk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lmIZMrLr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of naup96721@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=naup96721@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774309436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nk23nS4uNqRq9buSJNAiJ+S2Nw+SaX69zi7y546U44E=;
	b=bFruXAP7nFbWt8ac2mtYZj6yygMOhZi2COMJ8lZJXTNsD3nQ6U4unwpHtGoka0YI5PGJvV
	Yqe21NyyT9sZYOn4+7KH80SJxDNsPKJB2EhdiwoUv6cBcRDZu+Qn2y9BX2DywEE4Tu7pRv
	gmWw5jTjzDVu/KAI7A52d2UKQoFtci8=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82a7539851fso1873296b3a.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774309435; x=1774914235; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nk23nS4uNqRq9buSJNAiJ+S2Nw+SaX69zi7y546U44E=;
        b=lmIZMrLrrrRN+U2IJGilIy384XcSY6n0QtsaqVt2i4aRPIZiGKAdgnZwPWJ5qgyzCS
         ytCXsMB3omvsW/UhJkJHBTDtcdXS4hyfY19T1CO0sliRj3I3ePot/VMK1lXoibQWUHCE
         FIHNeXOiVU4QQNA5yOclhLTz2U25TL9/NhfyElzSsp/SFqIGECPw/wsLDQoUiRo/xHcI
         jFOvX33MAdi1mX9sfmmsX2+pyk9SdjbT/zsJzftHH8Pl2KMkCCk3S7OX23wejDt2+/yG
         Zy7qwvRPMaHTuhbY6a1ID+EOora9KB8rwNVbuLAkaX9mSo9dByWQbP2QLfxBDAYIXkcx
         DkYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774309435; x=1774914235;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nk23nS4uNqRq9buSJNAiJ+S2Nw+SaX69zi7y546U44E=;
        b=QfByZG+KtQvcHEfEJWGht6KFXD6AhXYCbMHQ96LdcQtsWxNg1LDQpSMYbdjJ15hqS4
         Ro1J3HtNVkqMoeWAojmgT0nxAUR7yM/fNecyPv8hKVE5EL5mjaM+Ib22wYupXdJyaeOZ
         euuPm8y/4p6y315HhyCKsz0pVQtGMYeYrzI2RMi+TY5FTd44ZGIaN62ZtsI2gHpdGPT4
         MSyPd5Facoejs42Yq29DTfUk4MJZrtXYoUczicx155OG5rgiKAWnuAwGOBlG/KzMBmBz
         SBpppjMKj6X6M3V6bVXrgHhPulM89od9vrCb7QAZNrRSg+xAv2mQhKUUQapmfYqlT77B
         CPlA==
X-Forwarded-Encrypted: i=1; AJvYcCUpePbuMjZJdCK/2ZWgZA3f0fl0UJOjteFCTteEqgw1y5Y1WQT3PYQJSzC9XasBXmP3f2Cte7To8Q==@kvack.org
X-Gm-Message-State: AOJu0Yzz2rEgKI6/ine10mQHM+5A4sa3aaEKa+N1n5DgCp2+WEzLa5Q+
	HSquI3tuQuJHPbEiiJ5MGxLliSFwXKXtOm9M3D10DpMPyyK3id6mzTIt
X-Gm-Gg: ATEYQzwA9f+/s1onECP2hrYmHENjtnaObQbQcvaXhJsjjEx/at+7H7rTAOzy2GwEPEE
	dqFFtBcR4yOlwOxrkBZatVDZGcVsG+gEFRxrE9RwcAT5xZ7BSQwGVaHFPRq0h+GWjjM0UwShGi2
	aiPJWimyQHWFdG1bP0lD+gcp53sfleGU4mUsWXjuLbSMv3uB4cIHYeMNdSao9a3CuAkMiWTH3Lt
	C7BeT3PUAI0Xw4ynx0E6Ty7d6+wD+QEW657IrL/81AATiHEkDKFtzWrtNRa+uZC1q0KgJF7QNBy
	pqns3oKXZqpCGQoBdcPlnrLqtRKPq5N1YpEfNWFFlR9ouNWeZ+Tf8xHQbYldmgCdt3YpRj/kvx5
	Ep5XAmZ8HdSgxRnuOQLk9P1Q+KbNOyAeTagW/vTB4CkSFgUZq78/5CGxKcWNBNuI6LY4yHhXgi1
	P4zjND1yDD4kAIrOyG5TowIN/VUIrYegCrtnCaNN05I4r/sOM4
X-Received: by 2002:a05:6a00:9507:b0:82a:6d7b:cd3e with SMTP id d2e1a72fcca58-82a8c233005mr13119826b3a.19.1774309434923;
        Mon, 23 Mar 2026 16:43:54 -0700 (PDT)
Received: from naup-virtual-machine ([140.113.92.221])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03be2589sm10084120b3a.24.2026.03.23.16.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 16:43:54 -0700 (PDT)
Date: Tue, 24 Mar 2026 07:43:50 +0800
From: Hao-Yu Yang <naup96721@gmail.com>
To: Thomas Gleixner <tglx@kernel.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hillenbrand <david@kernel.org>,
	Eric Dumazet <edumazet@google.com>, linux-mm@kvack.org,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] futex: Use-after-free between futex_key_to_node_opt
 and vma_replace_policy
Message-ID: <acHQNms30SOapIx+@naup-virtual-machine>
References: <20260313124756.52461-1-naup96721@gmail.com>
 <87a4vyihlx.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a4vyihlx.ffs@tglx>
X-Stat-Signature: 76tn78z3wfze549ff3mu5kkemnkxsgsk
X-Rspamd-Queue-Id: 56CCB140006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774309436-701995
X-HE-Meta: U2FsdGVkX1+H6O8vkZJgKzw8cGXIAKjqDphlTDRLPB/IXexZUtau5tN1ZYrCR2TaYKA6q83ovJrs4RJd6NgXJaVvByUKK77Tq6SOOZZ4KDFh2JiJpAMsdJ6c4xfXHecQcao5GR8/MDsbIWhxQJQ74+Uvpy6cg1pYaz+Gfew1ibCeKGhga0xAJjaX3SxekDNqCltPDgJjzwsiE9ZjrsSZV+N1zdSUF0WkKTDuvqJpyeFiUAFTCMym5X90nJdTRwzy32O4vhgjijytd8QxfWuejVSLFOsy2Z3wgO2NvbftmrGEjOYJtg239CfQKFuhBUidv82H1xJNa2msYtTfIhAosVYNByrJPHoi9x/8NQaDw58dSKSSvitvVb6X7CbKe+6VmP5/pq+7ejW7PH/Qs6lK5nGbh4n1z+xbYx0yPnPqYbGSfLBJwRqWAILuPHP+WlkgF6g4a5ax+MaJkXfpIt6MKtyo679WnnbV5Th3ysRxseqiBWe7kZVhc5Po99se+d9Ghrmh1GQgKtLLowwl6rsAVqtjpKlFLKM5mhwYHsRDtuvRpQSVXhddneOLqmRNOiiaHt1d9A08BASINQ1WpldR9k+q9hIXdGxd7nn+W+ueQAL7BVk9xzr/u0lR3qDnTdOlR1Vc4WPCzCO2X7aU1GSR7qq/p/4560soh18TBEUocjz1mVqWgI8gH28N+8n3tY3rgn4J0g0W6W3wB9U7ECWH7DIqVEeps2PIBQSj8Qs25K2v6boTEAnLcHblYHrxPbFYW2Ni5CcPdaODjxmTPhMwJJqWanUvouVXtulrbrUclmIMM2bpG+++U0Lr3XC+SE+bVGKdMqLQOk/FqIK3qSv9e4P3GuA2VNqXyi00rNXYRqnkObSuaR7JHCzsh79c1XwN/+PD5xnVO4b4pLN8UVD+NTgDVnjRVzOBa3cN5YlzCyBszc472459TOKlHsfyLPH4WbU4sTB1eZDITSSd6Vq
 oGbDu9W8
 W4eyiWeau34rvApKyKlqghFnr5OH/fUc1S6/CVvWRtqVPxKlXOSmT7ShSS9bcMXa9PmoHioGu+UO4MRBN+P2TmDFY5RZqrVBGRQqhbG2f57DobjdqXhJYUvpIw17qrssEhhZva4THOZ6Mb/ETmBFQyQfQMP5mxd7jutGYR7DzU4w+z6dRX9VEj4YFKKB5dDlWmjB5PV24BiW8YZlXqF5i4LL3rlUrEUQXKo7Hk1Um2CpijlNa5NljSnU9fkqhNGHHIpVmZCaBqkKgU8QV1gy8mG2QPfEUqXnH83JxH56Gd1QiEeOL3PwQXvUQvtoXv4svc0HREjYGSwGJeM4dBTG/8sYPiWoWjAAJ89mgqdc9gbKUPfFdnoJJ8DfDpkprhWvD4lJWYYx8qN0hO0LjKlvGCxpupB6Dh6QGgPyeciKe1rPnBR+W85enONY4iFWCXge1Icb4QclIN3q2jmkafWC8ZhHASY4ttUU/3Oa4huKyFqkzvacL1Zp/UB+7u0p6dE/X2S2QTKiGspruwPrnciP5/is6TSRgocF2GnJPGSTIg7sOzNLMFTAw+YjwY7J1tnAZ1psJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OK, so now i need to submit v3 patch?

On Mon, Mar 23, 2026 at 06:24:42PM +0100, Thomas Gleixner wrote:
> Hao-Yu!
> 
> On Fri, Mar 13 2026 at 20:47, Hao-Yu Yang wrote:
> 
> I've removed the security list as this is public already.
> Also added the mm list and the maintainers. While it fixes the futex
> problem it is a change to the MM subsystem, so those people need to be
> involved.
> 
> > During futex_key_to_node_opt() execution, vma->vm_policy is read under
> > speculative mmap lock and RCU. Concurrently, mbind() may call
> > vma_replace_policy() which frees the old mempolicy immediately via
> > kmem_cache_free().
> >
> > This creates a race where __futex_key_to_node() dereferences a freed
> > mempolicy pointer, causing a use-after-free read of mpol->mode.
> 
> > [  151.412631] BUG: KASAN: slab-use-after-free in __futex_key_to_node (kernel/futex/core.c:349)
> > [  151.414046] Read of size 2 at addr ffff888001c49634 by task e/87
> > [  151.414476]
> > [  151.415431] CPU: 1 UID: 1000 PID: 87 Comm: e Not tainted 7.0.0-rc3-g0257f64bdac7 #1 PREEMPT(lazy)
> > [  151.415758] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> > [  151.415969] Call Trace:
> > [  151.416059]  <TASK>
> > [  151.416161]  dump_stack_lvl (lib/dump_stack.c:123)
> > [  151.416299]  print_report (mm/kasan/report.c:379 mm/kasan/report.c:482)
> > [  151.416359]  ? __virt_addr_valid (./include/linux/mmzone.h:2046 ./include/linux/mmzone.h:2198 arch/x86/mm/physaddr.c:54)
> > [  151.416412]  ? __futex_key_to_node (kernel/futex/core.c:349)
> > [  151.416517]  ? kasan_complete_mode_report_info (mm/kasan/report_generic.c:182)
> > [  151.416583]  ? __futex_key_to_node (kernel/futex/core.c:349)
> > [  151.416631]  kasan_report (mm/kasan/report.c:597)
> > [  151.416677]  ? __futex_key_to_node (kernel/futex/core.c:349)
> > [  151.416732]  __asan_load2 (mm/kasan/generic.c:271)
> > [  151.416777]  __futex_key_to_node (kernel/futex/core.c:349)
> > [  151.416822]  get_futex_key (kernel/futex/core.c:374 kernel/futex/core.c:386 kernel/futex/core.c:593)
> > [  151.416871]  ? __pfx_get_futex_key (kernel/futex/core.c:550)
> > [  151.416927]  futex_wake (kernel/futex/waitwake.c:165)
> > [  151.416976]  ? __pfx_futex_wake (kernel/futex/waitwake.c:156)
> > [  151.417022]  ? __pfx___x64_sys_futex_wait (kernel/futex/syscalls.c:398)
> > [  151.417081]  __x64_sys_futex_wake (kernel/futex/syscalls.c:382 kernel/futex/syscalls.c:366 kernel/futex/syscalls.c:366)
> > [  151.417129]  x64_sys_call (arch/x86/entry/syscall_64.c:41)
> > [  151.417236]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
> > [  151.417342]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
> > [  151.418312]  </TASK>
> 
> Please trim the backtrace so it only contains the real important
> information.
> 
>   https://docs.kernel.org/process/submitting-patches.html#backtraces-in-commit-messages
> 
> > Fix by adding rcu to __mpol_put().
> >
> > change-log:
> >  v2-v1: add rcu to __mpol_put
> 
> The change history is not part of the change log, it want's to be placed
> after the --- separator.
> 
> > Fixes: c042c505210d ("futex: Implement FUTEX2_MPOL")
> > Reported-by: Hao-Yu Yang <naup96721@gmail.com>
> > Signed-off-by: Hao-Yu Yang <naup96721@gmail.com>
> 
> This should have a
> 
>      Suggested-by: Eric Dumazet <edumazet@google.com>
> 
> tag.
> 
> > ---
> >  include/linux/mempolicy.h | 1 +
> >  mm/mempolicy.c            | 2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
> > index 0fe96f3ab3ef..65c732d440d2 100644
> > --- a/include/linux/mempolicy.h
> > +++ b/include/linux/mempolicy.h
> > @@ -55,6 +55,7 @@ struct mempolicy {
> >  		nodemask_t cpuset_mems_allowed;	/* relative to these nodes */
> >  		nodemask_t user_nodemask;	/* nodemask passed by user */
> >  	} w;
> > +	struct rcu_head rcu;
> >  };
> >  
> >  /*
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 0e5175f1c767..6dc61a3d4a32 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -487,7 +487,7 @@ void __mpol_put(struct mempolicy *pol)
> >  {
> >  	if (!atomic_dec_and_test(&pol->refcnt))
> >  		return;
> > -	kmem_cache_free(policy_cache, pol);
> > +	kfree_rcu(pol, rcu);
> >  }
> >  EXPORT_SYMBOL_FOR_MODULES(__mpol_put, "kvm");
> 
> While this looks functionally correct it is incomplete in terms of RCU.
> 
> The vma->vm_policy pointer needs to be marked __rcu. That then requires
> to use rcu_dereference_check() at the reader side and
> rcu_assign_pointer() and rcu_replace_pointer() on the writer side.
> 
> Especially the writer side is required so that the proper memory
> barriers are inserted for architectures with a weakly ordered memory
> model.
> 
> Thanks,
> 
>         tglx

