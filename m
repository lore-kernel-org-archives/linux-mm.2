Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B712C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 21:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 966AC6B0005; Sun, 12 Jul 2026 17:17:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F0B46B0088; Sun, 12 Jul 2026 17:17:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A6D6B008A; Sun, 12 Jul 2026 17:17:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2E16B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:17:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F99C4095F
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 21:17:11 +0000 (UTC)
X-FDA: 84981385062.14.59A4B5A
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id B684A120006
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 21:17:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rjDkhy2H;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783891029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7MxMLcMIAxJrPGTQgHrDnIbgvC0waKObkfC1RnG/zSo=;
	b=0H5GxZw3Izdae1CTx5jl+VTu9BzJjl00JvuKLGct1O4p02AH/aNQqCVac3KMizm2vrYuVi
	jVI4C0rMDI0Y+8InMCYoDMlDFFmtBiXB87hEW28lcgSDVRP87xKtYnHNPOZzxZZfABbr+7
	I+L/xiH/PWMRzSngrJsviGPKlMfYbfY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rjDkhy2H;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783891029;
	b=dz0SnfumvwxyCKDK/c1yMHxN6rCL2kziyj95VCRa2u5WZ8lagdWr41dekgekjX9vFNACtx
	H4rcnqNfDVgk/yiPQ4dDWAMlmhKa7BaFtk1aZjeOHQbK55fd+FJWZsr4iLlLlt1PrjkJNk
	23p1hmrvZVnclRKLrHKpKFBySfHZFy0=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493bf73ec2aso17439175e9.2
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 14:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783891028; x=1784495828; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7MxMLcMIAxJrPGTQgHrDnIbgvC0waKObkfC1RnG/zSo=;
        b=rjDkhy2HXDEFzY2fMwnFrqs5aqW9gks1W2LRcbmU4SMxb1bKc3oswg2OgXaE9BcYHq
         zBRyO2BvwUkJksro3o15bXjoo+Jkel76rVR74TACPDQYdaVVhzGaz93YUmFJp0/fik43
         BIqYI5tfN2+HNJk24SW5pQBy9O+ezwzn/FhEKCojgAxPAxNd4PnZYU1zzR2NoEU3suqG
         WVVy1r7zulJBBQ+PbneJQHA1YZ6mNOe7qutZ6a2buArjXN8GUAXXTRgZUWv9gb75SvGH
         Kyh1GZTiE3ZsG9V0xCsvqigKBvilTsvQ2Q7mhNs+a5stz8qxT03BgAPvnwdamsX1f+1b
         0gmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783891028; x=1784495828;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7MxMLcMIAxJrPGTQgHrDnIbgvC0waKObkfC1RnG/zSo=;
        b=L60iwTeQCNbtQcqaTi5h4CPghwMJ+Y+6xkfSrr64wT3rfAJLvRE3NUIITnkOpZjUfi
         UYMjtQjfSCnOt194+pHbEtiY9Bzberu5UUzOi7aiNEYuTEPr1D6RRwcZ12wCrEv5yLzO
         dgpffu0dWkUW+8EmQoo62VRtQ8R359Iu0N8otzKYU8ZH6lC0Vt/vvWgsniwX2gDRM2g4
         eqRa5ey4gTBtHwSO55MImDcOQ4AxGUBssVzQw/W3sV9xR7pPPEvuTX20OgGp2qaxlX+u
         x7I9u7LzJZXyASxFMaym6SyeqopfnMHXY/eKZRYmZ31El54qzEfDMvDzijQvMSu1aaLw
         FNsQ==
X-Forwarded-Encrypted: i=1; AHgh+Rre0aJbWyEScS7zkiXsOzk16Qxjn/iYcHW0SoyLEcmGCxmmPGyXn723AKvDTmDh2qvc/rn+/Lmiow==@kvack.org
X-Gm-Message-State: AOJu0Yx0LcO5kD4a3wS/UQaBCBga+dqYSQ5m/vcLVvpBwM4xVocehXyZ
	R/g8Ek4qLJj9wEj3+ksP2dYNHQCZOZAvsgU1DbJ6Fp8yuDY+/8Xf+hbz
X-Gm-Gg: AfdE7clVIvSPnQT8KUS7xhWEUzAPZo9FOznw1zI1NZ3hmFluD9DR6heTPnqiG0NvC/c
	3AXJaqRP6rZAnArhb3tkqCFJZ8amL/eatpFmV1bRyF4MkB521xRdB3NGHvOjftDP3Nso3TSEJFm
	IUIEwZ+n3Tw0LOm6I5zrKJ4+hcCslGdKS63VugTGh5lV1Ge183LIel3PL3LMupFuk20dxY32ol6
	B2YOPZX1W3PUK8w7cHmHYwEQIKkh3t9g6qKW/9GJa2lWZV0a+qdjf3UKBY//0D+VkNwA1e7wfJJ
	NUXxXSZoce0Szv/Fx7m7lIdoAg5ndWthc3HEOLOQ9BxUixokAhYswFvEfOP5ozDzyG6ThMaudwh
	cAAHxpIfIoP+13hjzyWRnIS6fdIkUxzTAIfvM87xavcF070uxTC//Ynu3IHVq7md1h1V3V2N1xo
	Hr7DFdofAbwpBkpaSqhAu9giMn27oSo7A7
X-Received: by 2002:a05:600c:1f91:b0:493:e79e:daa6 with SMTP id 5b1f17b1804b1-493f8826e69mr64082685e9.33.1783891028042;
        Sun, 12 Jul 2026 14:17:08 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:f61:3b01:d08a:833b:756:8fce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa039b0cesm81772275f8f.22.2026.07.12.14.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 14:17:07 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>,
	Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Coiby Xu <coxu@redhat.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4 1/4] Introducing pw_lock() and per-cpu queue & flush work
Date: Sun, 12 Jul 2026 18:17:00 -0300
Message-ID: <alQETF2_78k5cvq4@WindFlash>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260520134832.WS7TrMnu@linutronix.de>
References: <20260519012754.240804-1-leobras.c@gmail.com> <20260519012754.240804-2-leobras.c@gmail.com> <20260520134832.WS7TrMnu@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B684A120006
X-Stat-Signature: bieaop741c6oynq9njbparwudm3z34wo
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783891029-305486
X-HE-Meta: U2FsdGVkX193cd4P3n4zq/U94sGE8iXTuNcQfdHqGN7Qj8iW9kRf3pTvvOhlHW11UMtJNPHTN2SjRs+92HWINam9N1oAR0xVNQNRysUVRgI5mg/KtO1Wsj8f6edRWQHlswgSibIJDNbPHRfx2roWrOhXBWNBOytCFujiJHvcf/3rnjsXOmBt8ihPDLXetIPvseFmD0wDPb356srmodtTvmmP0jqtArt3+4UvQrEQhFFZQgebynNVcwKVFE+8MPFZcc5wnYMLYYZpD0fr++tE5kDUDhJ5XFSUZh7RiAwujEMGVJBbe4aI0wmZ2xGO/HClwNga4xqMgpUBxF71hivSRJMMG0I79GC1WfcMPNqeltLfSWhUHRuysJhEzx51B1ZtQvaeFTVSVUDWbJYc4fTfe2mY2SyLo8fdAvhgoZhV6XmY83ORF47d2X8mZh+zAUvZHaJMry/RIutl4d1nmXAM55oJGcYp4Pzn7kAFck3fBKZ1hLOdolWDPvBGUiYieCGij/PPY/iYxYGcVJtdgEHA4yLd0tGwKM30viy9AFeF8Srj1FlSrM2JU5IVTDmKo98Lf6837+PkRpZ5yu9ypllJPrmU4YZW2hE4vDpyNnkFrd0o4BrFXPeeIkKfehPKZAhm6GbajxlbNLwPZX3kW8WIU+iI2lpjx5O+64rxr4ouGSDJa+T6ijNV2luRAeDkqbjGT++Mo/y8QzLQ9gVESTZiSK/6oMVscNzOlmhjMItg8lPHHZxbD+L9WsRQOQfKYxoQlIHIZMaXJ0HDy9RjjDAqCABNqlEjjTHYVh1YYlm/vvRdbjibEOZ1Z3VItQmIHz2jc1R/uUp55b2tnJtsRKpuVCCdaClbhEVaf0S/W/QQiRPRpwjnfX1u0a7CPFKh2uh2ZUAEdOFdNLzM5xWJmSqhmLbHCJg9eFFzIyijyAvJzJbuKX4834t3CAudv4ybviCvN6U2oWjMA+0+UGBUs3O
 oAdO9aAC
 kXXxwNTwGNqc0RsxL8dZmkQLQ1Pwo5T7YXaXrzXNCwC0J9YPf9/wKIB0JqEbxwtnwhnT+erkKZtJPvhNl8FxnRJ14plELfFce2unMAYalwoFTWM8+LZx8K6QeSWyDIUUvzH4Ms4udG0HX8h+4IPwZGycnpvkEp9JWqekdTv49JIGbFUprkpM7iPX3DlOcPhO9WlJhNYbZSzFhEmyxI2dUoTLu/tQVHGwp0ZOfqiQDeNblY8W6GkQ2bcLhU/F9qJDShSZinBmoUD463aRgfGSVL0nYgmEAKbJjYw2sFEbXU81AWeWrME9IDu1xCJGeGEpfcdI43xlv/XhjZcM/7jXM50fO4w6I1ffGCKeLt14HCVJkn6HVyZOOx0/aXEM0rV7FBtGDzW7xVsfTXFWCi+m7A6h8NX2xbQV16YcIQN9FWFFWmOQSNd2fxdFVGL4UVaOoYVHkQYB/Ay6Sry8URxz2I1si99/7tmCWSlnQJ1TGUL+x7RaAFVz89YUkPM2jhi6tBkXu0OBe0dJf+6f/IPcaULJyrF6Tcb2UgC7kau5zVdkI+scE9rnYH/XUlgQMymMu2O9NJrjXJ9JtqVhiwH52eA9VJpKQiclhJwav
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 03:48:32PM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-05-18 22:27:47 [-0300], Leonardo Bras wrote:
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index 4d0f545fb3ec..68c8a6f9d227 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -2810,20 +2810,30 @@ Kernel parameters
> >  			  If a queue's affinity mask contains only isolated
> >  			  CPUs then this parameter has no effect on the
> >  			  interrupt routing decision, though interrupts are
> >  			  only delivered when tasks running on those
> >  			  isolated CPUs submit IO. IO submitted on
> >  			  housekeeping CPUs has no influence on those
> >  			  queues.
> >  
> >  			The format of <cpu-list> is described above.
> >  
> > +	pwlocks=	[KNL,SMP] Select a behavior on per-CPU resource sharing
> > +			and remote interference mechanism on a kernel built with
> > +			CONFIG_PWLOCKS.
> > +			Format: { "0" | "1" }
> > +			0 - local_lock() + queue_work_on(remote_cpu)
> > +			1 - spin_lock() for both local and remote operations
> > +
> > +			Selecting 1 may be interesting for systems that want
> > +			to avoid interruption & context switches from IPIs.
> > +
> 
> This documentation is supposed to be for an administrator/ user of the
> system. Exposing him to underlying kernel technique shouldn't happen.
> It does not explain the users/ outcome so it sounds like best hope.

Noted, will try to improve the explanation to target a user/sysadmin 
public.


> 
> >  	iucv=		[HW,NET]
> >  
> >  	ivrs_ioapic	[HW,X86-64]
> >  			Provide an override to the IOAPIC-ID<->DEVICE-ID
> >  			mapping provided in the IVRS ACPI table.
> >  			By default, PCI segment is 0, and can be omitted.
> >  
> >  			For example, to map IOAPIC-ID decimal 10 to
> >  			PCI segment 0x1 and PCI device 00:14.0,
> >  			write the parameter as:
> > diff --git a/Documentation/locking/pwlocks.rst b/Documentation/locking/pwlocks.rst
> > new file mode 100644
> > index 000000000000..09f4a5417bc1
> > --- /dev/null
> > +++ b/Documentation/locking/pwlocks.rst
> > @@ -0,0 +1,76 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +=========
> > +PW (Per-CPU Work) locks
> > +=========
> > +
> > +Some places in the kernel implement a parallel programming strategy
> > +consisting on local_locks() for most of the work, and some rare remote
> > +operations are scheduled on target cpu. This keeps cache bouncing low since
> > +cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> 
> PREEMPT_RT can be spelled out if you mean it so it is not confused with
> other meanings of the two letters.
> 

Will do!


> > +kernels, even though the very few remote operations will be expensive due
> > +to scheduling overhead.
> > +
> > +On the other hand, for RT workloads this can represent a problem:
> > +scheduling work on remote cpu that are executing low latency tasks
> > +is undesired and can introduce unexpected deadline misses.
> > +
> > +PW locks help to convert sites that use local_locks (for cpu local operations)
> > +and queue_work_on (for queueing work remotely, to be executed
> > +locally on the owner cpu of the lock) to a spinlocks.
> 
> not spinlocks.
> 

If CONFIG_RT=n, and PWLOCKS=1, it becomes a spinlock.

IIUC in PREEMPT_RT=1 spinlocks become mutexes. I get that it does not 
actually spins, but it should behave as much as a spinlock could in 
PREEMPT_RT systems, right?

> > +
> > +The lock is declared pw_lock_t type.
> > +The lock is initialized with pw_lock_init.
> > +The lock is locked with pw_lock (takes a lock and cpu as a parameter).
> > +The lock is unlocked with pw_unlock (takes a lock and cpu as a parameter).
> 
> If it is a function, it should end with ()
> 

Right, will correct those.

> > +The pw_lock_irqsave function disables interrupts and saves current interrupt state,
> > +cpu as a parameter.
> 
> CPU.

right

> 
> > +For trylock variant, there is the pw_trylock_t type, initialized with
> > +pw_trylock_init. Then the corresponding pw_trylock and pw_trylock_irqsave.
> > +
> > +work_struct should be replaced by pw_struct, which contains a cpu parameter
> > +(owner cpu of the lock), initialized by INIT_PW.
> > +
> > +The queue work related functions (analogous to queue_work_on and flush_work) are:
> > +pw_queue_on and pw_flush.
> > +
> > +The behaviour of the PW lock functions is as follows:
> > +
> > +* !CONFIG_PWLOCKS (or CONFIG_PWLOCKS and pwlocks=off kernel boot parameter):
> > +        - pw_lock:			local_lock
> > +        - pw_lock_irqsave:		local_lock_irqsave
> > +        - pw_trylock:			local_trylock
> > +        - pw_trylock_irqsave:		local_trylock_irqsave
> > +        - pw_unlock:			local_unlock
> > +        - pw_lock_local:		local_lock
> > +        - pw_trylock_local:		local_trylock
> > +        - pw_unlock_local:		local_unlock
> > +        - pw_queue_on:         		queue_work_on
> > +        - pw_flush:	            	flush_work
> > +
> > +* CONFIG_PWLOCKS (and CONFIG_PWLOCKS_DEFAULT=y or pwlocks=on kernel boot parameter),
> > +        - pw_lock:			spin_lock
> > +        - pw_lock_irqsave:		spin_lock_irqsave
> > +        - pw_trylock:			spin_trylock
> > +        - pw_trylock_irqsave:		spin_trylock_irqsave
> > +        - pw_unlock:			spin_unlock
> > +        - pw_lock_local:		preempt_disable OR migrate_disable + spin_lock
> > +        - pw_trylock_local:		preempt_disable OR migrate_disable + spin_trylock
> > +        - pw_unlock_local:		preempt_enable OR migrate_enable + spin_unlock
> > +        - pw_queue_on:         		executes work function on caller cpu
> > +        - pw_flush:            		empty
> > +
> > +pw_get_cpu(work_struct), to be called from within per-cpu work function,
> > +returns the target cpu.
> > +
> > +On the locking functions above, there are the local locking functions
> > +(pw_lock_local, pw_trylock_local and pw_unlock_local) that must only
> > +be used to access per-CPU data from the CPU that owns that data,
> > +and never remotely. They disable preemption/migration and don't require
> > +a cpu parameter, making them a replacement for local_lock functions that
> > +does not introduce overhead.
> 
> Why do you need to either the one or the other? My only guess is that
> migrate_disable() is sufficient but you prefer preempt_disable() on
> !PREEMPT_RT because it is cheaper.

Correct.
One goal of this change is not introduce overheads in the user code, in 
special on hotpath code. Using preempt_disable in !PREEMPT_RT just nests 
with the one in the lock, and it becomes almost free

> 
> > +These should only be used when accessing per-CPU data of the local CPU.
> > +
> > diff --git a/init/Kconfig b/init/Kconfig
> > index 2937c4d308ae..3fb751dc4530 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -764,20 +764,55 @@ config CPU_ISOLATION
> >  	depends on SMP
> >  	default y
> >  	help
> >  	  Make sure that CPUs running critical tasks are not disturbed by
> >  	  any source of "noise" such as unbound workqueues, timers, kthreads...
> >  	  Unbound jobs get offloaded to housekeeping CPUs. This is driven by
> >  	  the "isolcpus=" boot parameter.
> >  
> >  	  Say Y if unsure.
> >  
> > +config PWLOCKS
> > +	bool "Per-CPU Work locks"
> > +	depends on SMP || COMPILE_TEST
> > +	default n
> > +	help
> > +	  Allow changing the behavior on per-CPU resource sharing with cache,
> > +	  from the regular local_locks() + queue_work_on(remote_cpu) to using
> > +	  per-CPU spinlocks on both local and remote operations.
> > +
> > +	  This is useful to give user the option on reducing IPIs to CPUs, and
> > +	  thus reduce interruptions and context switches. On the other hand, it
> > +	  increases generated code and will use atomic operations if spinlocks
> > +	  are selected.
> 
> I think the goal is to avoid scheduling a task on a remote CPU to get
> something done. 

Correct, it makes an isolated CPU less noisy.

> 
> > +
> > +	  If set, will use the default behavior set in PWLOCKS_DEFAULT unless boot
> > +	  parameter pwlocks is passed with a different behavior.
> > +
> > +	  If unset, will use the local_lock() + queue_work_on() strategy,
> > +	  regardless of the boot parameter or PWLOCKS_DEFAULT.
> 
> This sounds like it affects the greater kernel.
> 

It should affect only code converted to use pwlocks.

> > +	  Say N if unsure.
> > +
> > +config PWLOCKS_DEFAULT
> > +	bool "Use per-CPU spinlocks by default on PWLOCKS"
> > +	depends on PWLOCKS
> > +	default n
> 
> n is default.

You can set PWLOCKS=n, then it compiles out the mechanism.
You can set PWLOCKS=y, and then it will use PWLOCKS_DEFAULT + pwlocks 
command-line argument to decide on using either local_lock+IPI or 
spinlocks (that become mutexes in PREEMPT_RT=y).

PWLOCKS_DEFAULT is just a way of letting whoever builds the kernel to 
decide the default mode, while letting the user decide to disable/enable 
the mechanism on cmdline as desired.

> 
> > +	help
> > +	  If set, will use per-CPU spinlocks as default behavior for per-CPU
> > +	  remote operations.
> > +
> > +	  If unset, will use local_lock() + queue_work_on(cpu) as default
> > +	  behavior for remote operations.
> > +
> > +	  Say N if unsure
> > +
> >  source "kernel/rcu/Kconfig"
> >  
> >  config IKCONFIG
> >  	tristate "Kernel .config support"
> >  	help
> >  	  This option enables the complete Linux kernel ".config" file
> >  	  contents to be saved in the kernel. It provides documentation
> >  	  of which kernel options are used in a running kernel or in an
> >  	  on-disk kernel.  This information can be extracted from the kernel
> >  	  image file with the script scripts/extract-ikconfig and used as
> > diff --git a/include/linux/pwlocks.h b/include/linux/pwlocks.h
> > new file mode 100644
> > index 000000000000..3d79621655f9
> > --- /dev/null
> > +++ b/include/linux/pwlocks.h
> > @@ -0,0 +1,265 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _LINUX_PWLOCKS_H
> > +#define _LINUX_PWLOCKS_H
> > +
> > +#include "linux/spinlock.h"
> > +#include "linux/local_lock.h"
> > +#include "linux/workqueue.h"
> > +
> > +#ifndef CONFIG_PWLOCKS
> > +
> > +typedef local_lock_t pw_lock_t;
> > +typedef local_trylock_t pw_trylock_t;
> > +
> > +struct pw_struct {
> > +	struct work_struct work;
> > +};
> > +
> > +#define pw_lock_init(lock)				\
> > +	local_lock_init(lock)
> > +
> > +#define pw_trylock_init(lock)				\
> > +	local_trylock_init(lock)
> > +
> > +#define pw_lock(lock, cpu)				\
> > +	local_lock(lock)
> > +
> > +#define pw_lock_local(lock)				\
> > +	local_lock(lock)
> > +
> > +#define pw_lock_irqsave(lock, flags, cpu)		\
> > +	local_lock_irqsave(lock, flags)
> 
> The part where you have a `cpu' argument which is not used is entirely
> confusing.
> 

That is how we compile-out when CONFIG_PWLOCKS=n, it has to receive the cpu 
parameter as the version with CONFIG_PWLOCKS=y below use the cpu parameter 
to decide where to find the per-cpu data.

> > +
> > +#define pw_lock_local_irqsave(lock, flags)		\
> > +	local_lock_irqsave(lock, flags)
> > +
> > +#define pw_trylock(lock, cpu)				\
> > +	local_trylock(lock)
> > +
> > +#define pw_trylock_local(lock)				\
> > +	local_trylock(lock)
> > +
> > +#define pw_trylock_irqsave(lock, flags, cpu)		\
> > +	local_trylock_irqsave(lock, flags)
> > +
> > +#define pw_unlock(lock, cpu)				\
> > +	local_unlock(lock)
> > +
> > +#define pw_unlock_local(lock)				\
> > +	local_unlock(lock)
> > +
> > +#define pw_unlock_irqrestore(lock, flags, cpu)		\
> > +	local_unlock_irqrestore(lock, flags)
> > +
> > +#define pw_unlock_local_irqrestore(lock, flags)		\
> > +	local_unlock_irqrestore(lock, flags)
> > +
> > +#define pw_lockdep_assert_held(lock)			\
> > +	lockdep_assert_held(lock)
> > +
> > +#define pw_queue_on(c, wq, pw)				\
> > +	queue_work_on(c, wq, &(pw)->work)
> > +
> > +#define pw_flush(pw)					\
> > +	flush_work(&(pw)->work)
> > +
> > +#define pw_get_cpu(pw)	smp_processor_id()
> > +
> > +#define pw_is_cpu_remote(cpu)		(false)
> > +
> > +#define INIT_PW(pw, func, c)				\
> > +	INIT_WORK(&(pw)->work, (func))
> > +
> > +#else /* CONFIG_PWLOCKS */
> > +
> > +DECLARE_STATIC_KEY_MAYBE(CONFIG_PWLOCKS_DEFAULT, pw_sl);
> > +
> > +typedef union {
> > +	spinlock_t sl;
> > +	local_lock_t ll;
> > +} pw_lock_t;
> > +
> > +typedef union {
> > +	spinlock_t sl;
> > +	local_trylock_t ll;
> > +} pw_trylock_t;
> 
> Why do you use local_trylock_t ? Its use case is different compared to
> local_lock_t. _IF_ you are fine with local_trylock_t then you should be
> able to deal with a per-CPU spinlock_t and none of this should be
> needed.

IIRC there is code that use both local_trylock and and local_lock, so we 
needed this to be able to convert the user completely.

> 
> > +struct pw_struct {
> > +	struct work_struct work;
> > +	int cpu;
> > +};
> > +
> > +#ifdef CONFIG_PREEMPT_RT
> > +#define preempt_or_migrate_disable migrate_disable
> > +#define preempt_or_migrate_enable migrate_enable
> > +#else
> > +#define preempt_or_migrate_disable preempt_disable
> > +#define preempt_or_migrate_enable preempt_enable
> > +#endif
> 
> if then () but this looks terrible.

Agree, have to figure a better naming.

> 
> > +
> > +#define pw_lock_init(lock)							\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		spin_lock_init(lock.sl);					\
> > +	else									\
> > +		local_lock_init(lock.ll);					\
> > +} while (0)
> > +
> > +#define pw_trylock_init(lock)							\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		spin_lock_init(lock.sl);					\
> > +	else									\
> > +		local_trylock_init(lock.ll);					\
> > +} while (0)
> > +
> > +#define pw_lock(lock, cpu)							\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		spin_lock(per_cpu_ptr(lock.sl, cpu));				\
> > +	else									\
> > +		local_lock(lock.ll);						\
> > +} while (0)
> > +
> > +#define pw_lock_local(lock)							\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl)) {		\
> > +		preempt_or_migrate_disable();					\
> > +		spin_lock(this_cpu_ptr(lock.sl));				\
> > +	} else {								\
> > +		local_lock(lock.ll);						\
> > +	}									\
> > +} while (0)
> > +
> > +#define pw_lock_irqsave(lock, flags, cpu)					\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		spin_lock_irqsave(per_cpu_ptr(lock.sl, cpu), flags);	\
> > +	else									\
> > +		local_lock_irqsave(lock.ll, flags);				\
> > +} while (0)
> > +
> > +#define pw_lock_local_irqsave(lock, flags)					\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl)) {		\
> > +		preempt_or_migrate_disable();					\
> > +		spin_lock_irqsave(this_cpu_ptr(lock.sl), flags);		\
> > +	} else {								\
> > +		local_lock_irqsave(lock.ll, flags);				\
> > +	}									\
> > +} while (0)
> > +
> > +#define pw_trylock(lock, cpu)							\
> > +({										\
> > +	int t;									\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		t = spin_trylock(per_cpu_ptr(lock.sl, cpu));			\
> > +	else									\
> > +		t = local_trylock(lock.ll);					\
> > +	t;									\
> > +})
> > +
> > +#define pw_trylock_local(lock)							\
> > +({										\
> > +	int t;									\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl)) {		\
> > +		preempt_or_migrate_disable();					\
> > +		t = spin_trylock(this_cpu_ptr(lock.sl));			\
> > +		if (!t)								\
> > +			preempt_or_migrate_enable();				\
> > +	} else {								\
> > +		t = local_trylock(lock.ll);					\
> > +	}									\
> > +	t;									\
> > +})
> > +
> > +#define pw_trylock_irqsave(lock, flags, cpu)					\
> > +({										\
> > +	int t;									\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		t = spin_trylock_irqsave(per_cpu_ptr(lock.sl, cpu), flags);	\
> > +	else									\
> > +		t = local_trylock_irqsave(lock.ll, flags);			\
> > +	t;									\
> > +})
> > +
> > +#define pw_unlock(lock, cpu)							\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		spin_unlock(per_cpu_ptr(lock.sl, cpu));			\
> > +	else									\
> > +		local_unlock(lock.ll);					\
> > +} while (0)
> > +
> > +#define pw_unlock_local(lock)							\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl)) {		\
> > +		spin_unlock(this_cpu_ptr(lock.sl));				\
> > +		preempt_or_migrate_enable();					\
> > +	} else {								\
> > +		local_unlock(lock.ll);						\
> > +	}									\
> > +} while (0)
> > +
> > +#define pw_unlock_irqrestore(lock, flags, cpu)					\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		spin_unlock_irqrestore(per_cpu_ptr(lock.sl, cpu), flags);	\
> > +	else									\
> > +		local_unlock_irqrestore(lock.ll, flags);			\
> > +} while (0)
> > +
> > +#define pw_unlock_local_irqrestore(lock, flags)					\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl)) {		\
> > +		spin_unlock_irqrestore(this_cpu_ptr(lock.sl), flags);	\
> > +		preempt_or_migrate_enable();					\
> > +	} else {								\
> > +		local_unlock_irqrestore(lock.ll, flags);			\
> > +	}									\
> > +} while (0)
> > +
> > +#define pw_lockdep_assert_held(lock)						\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		lockdep_assert_held(this_cpu_ptr(lock.sl));			\
> > +	else									\
> > +		lockdep_assert_held(this_cpu_ptr(lock.ll));			\
> > +} while (0)
> > +
> > +#define pw_queue_on(c, wq, pw)							\
> > +do {										\
> > +	int __c = c;								\
> > +	struct pw_struct *__pw = (pw);						\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl)) {		\
> > +		WARN_ON((__c) != __pw->cpu);					\
> > +		__pw->work.func(&__pw->work);					\
> > +	} else {								\
> > +		queue_work_on(__c, wq, &(__pw)->work);				\
> > +	}									\
> > +} while (0)
> > +
> > +/*
> > + * Does nothing if PWLOCKS is set to use spinlock, as the task is already done at the
> > + * time pw_queue_on() returns.
> > + */
> > +#define pw_flush(pw)								\
> > +do {										\
> > +	struct pw_struct *__pw = (pw);						\
> > +	if (!static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		flush_work(&__pw->work);					\
> > +} while (0)
> 
> I don't think this should be a collection of macros. Either proper
> functions or static inline _if_ this is performance critical for some
> reason.
> 

Agree, I remember the only macro that was hard to do so was _irqsave() 
versions, as it uses an output as a parameter, and I ended up letting all 
of them being macro due to them looking similar.

Will convert on next version.

(Only the _local*() funcs are performance-critial IIRC.

> > +
> > +#define pw_get_cpu(w)			container_of((w), struct pw_struct, work)->cpu
> > +
> > +#define pw_is_cpu_remote(cpu)		((cpu) != smp_processor_id())
> > +
> > +#define INIT_PW(pw, func, c)							\
> > +do {										\
> > +	struct pw_struct *__pw = (pw);						\
> > +	INIT_WORK(&__pw->work, (func));						\
> > +	__pw->cpu = (c);							\
> > +} while (0)
> > +
> > +#endif /* CONFIG_PWLOCKS */
> > +#endif /* LINUX_PWLOCKS_H */
> > diff --git a/kernel/pwlocks.c b/kernel/pwlocks.c
> > new file mode 100644
> > index 000000000000..1ebf5cb979b9
> > --- /dev/null
> > +++ b/kernel/pwlocks.c
> > @@ -0,0 +1,47 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include "linux/export.h"
> > +#include <linux/sched.h>
> > +#include <linux/pwlocks.h>
> > +#include <linux/string.h>
> > +#include <linux/sched/isolation.h>
> > +
> > +DEFINE_STATIC_KEY_MAYBE(CONFIG_PWLOCKS_DEFAULT, pw_sl);
> > +EXPORT_SYMBOL(pw_sl);
> > +
> > +static bool pwlocks_param_specified;
> > +
> > +static int __init pwlocks_setup(char *str)
> > +{
> > +	int opt;
> > +
> > +	if (!get_option(&str, &opt)) {
> > +		pr_warn("PWLOCKS: invalid pwlocks parameter: %s, ignoring.\n", str);
> > +		return 0;
> > +	}
> > +
> > +	if (opt)
> > +		static_branch_enable(&pw_sl);
> > +	else
> > +		static_branch_disable(&pw_sl);
> > +
> > +	pwlocks_param_specified = true;
> > +
> > +	return 1;
> > +}
> > +__setup("pwlocks=", pwlocks_setup);
> > +
> > +/*
> > + * Enable PWLOCKS if CPUs want to avoid kernel noise.
> > + */
> > +static int __init pwlocks_init(void)
> > +{
> > +	if (pwlocks_param_specified)
> > +		return 0;
> > +
> > +	if (housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
> > +		static_branch_enable(&pw_sl);
> 
> How likely is it, that you you had users before late_initcall()? Also
> can it happen that one of them uses one function to lock and the other
> unlock in this brief window? There is no check if this was used before
> static_branch usage.
> 

I don't really understand that much of initcall :(
That part was done by Marcelo, I have to reach out for him for more 
understanding of his decision here.

I have to take a better look here :)

Thanks!
Leo

