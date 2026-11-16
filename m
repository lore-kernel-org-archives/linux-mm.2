Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B01F7606A331
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=CvFaEcjP
Received: by kanga.kvack.org (Postfix)
	id D2E036B05B8; Mon, 16 Nov 2026 10:30:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDEFA6B05B9; Mon, 16 Nov 2026 10:30:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCE866B05BA; Mon, 16 Nov 2026 10:30:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97B4E6B05B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:30:50 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 346D640154
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:30:50 +0000 (UTC)
X-FDA: 85441369860.22.C21E034
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4F0BAC0010
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:30:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CvFaEcjP;
	spf=pass (imf28.hostedemail.com: domain of pmladek@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794843048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPr9IOYFjtJaYI4q2QerjW2bLfRzLv1kPuZUspzu/XY=;
	b=semay5MF5ha5vdRGrZf/qmd7rHBcM1HNDxtykw1YwJA3JwUQDNqUvWkXS8qV4H0gEps+Xc
	XVfYK8ypRvptW+Ske6pZpB+xkBgo5H2k+XMknbzlHXb+Drv2zGuBtt1Hh2tvSmOPzMzMGa
	GOJllLVAir5XehYLZdCqszYJlyaG2/k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794843048;
	b=O8FRbQxl3SXXDSwH3f7yiI4xf3/sS7789EHLRrtNE8tDqGU7UlOMWf+7ScQuWWLFkSLrqk
	q27REJPLKdDQTJdZnjY/5uIdaBMM74ZI2vIQHfDd7LvRU+j+5oeBaNKZeqMYSjpY1DpC0H
	xyHdzRmp+oQnc4IPSAX6y0RWmovcAtA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CvFaEcjP;
	spf=pass (imf28.hostedemail.com: domain of pmladek@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4bb702a7548so10988285e9.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794843047; x=1795447847; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hPr9IOYFjtJaYI4q2QerjW2bLfRzLv1kPuZUspzu/XY=;
        b=CvFaEcjPw9mN58nbazjLn2AEb60IZ7Yqd09FzwmV/Lq65iVKpNOagBk6veDvLKmfOA
         9jrxvqgw8OTCI8OZGa3iA7Zhbe6VgHjTVpkTRK1ZFwp6cplKaLe8OEbhgu+8UNrLlY8q
         VEfS9Ko4ezF9tTh5kYu2x8PGs2I6w9FMjKzwEdxuU3xiMX/m6kXM/zfJKwIxTuMnQKJd
         vxsGOr1dFuE5OcQMXdUln2lKKgbJ6HD6aTw6Apw82dRhSpULupQvcgNYzMSAq6gzsUr0
         3o5k7EhLwj1V0jr5fmIFil2vEby/6czhC7Git/rNWcUemgU1zbKoDCOEq18IrGPm+r8u
         SYMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794843047; x=1795447847;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hPr9IOYFjtJaYI4q2QerjW2bLfRzLv1kPuZUspzu/XY=;
        b=s0vcNdzErB+wcPXXBrklACOq7JxtYoLamV9fwRwp23FbH6bekuP9oPNX9Rogxpku4D
         SteCYXiRQtn1+LfX9EGxubI2liECd6hbVztxvSX2bdAtQm26zInTATD4wd9en4kLC7fF
         TEhInQ9ml+AtucwK5ZmaPEN0yfA3bqb/MFpwgEU80BPELk+iMij3cm575qFSobVugpsr
         Qs9JY/uoy0vIAjy/CLk6YNnKmn0V2FFR+52auENAxozZEaiPYASuiaN5WkC3+P39LGv4
         C3B94du8dp5MwDs/5gfsIYX0reGi+sgmlivEYbBAIlUejBJewcCX5AZktQcaUDosTPoc
         LtnA==
X-Forwarded-Encrypted: i=1; AL+hErG0m0ivN9fW9To/pkmu22ECvc9WPp5rgPdM4yrhYNVTpVf29Aj2dVWKm2cSovPWZhEEk4zaZLe/CQ==@kvack.org
X-Gm-Message-State: APuU4Z+sH18NCPUMVvFfa8KZO12g+PCvAr80uw4cj/vDTh8/uulTr4Jf
	HrlE1MRnGV/1VvkT3Heh5vAMtnSNBZxH4N7Md7Y6u+3DXTUr0Mko4WjJPlazKD3CyS8=
X-Gm-Gg: AYBFou3ocQ1s/FwxUtwX6AZqc80fL+fJ3kWB1df44rDYLNTHQ5xOPYQ6RNKN0kiwQh6
	PsFmqKwEZCU9QbeEZC/jaVsDRDJxCqf4I7ZMw/genY8uML6Dx5uTAzbIEL8Mo2E4j6wcpU5a6MT
	HWSGhcjSAwDMo+usTVKZ/NdlqK/vUGnGJDG06cYF85EwJ5ivegy0rMpikfNuOuX9Vib8sZ/hV+I
	lj4ORCo1WVXFY5qSVxF3ivXJnlurnfB7xdOx7GQttp/bMPt81yVYGDt+/xFJxWz78R+zypmnyzG
	FD4NqbGyPJawj+5IjnEHVGvxw8PlIovHSZs6N3KN2BiTeNAaIxwZL58URE15h8uf7IasTJfJ/3P
	WGyngciH8HoxoEXpWmJSaGBwMpDZXHExLVt/iqUCr8XVfdgD+XQJp6L5A1qWyXtRLjr6ko80SRU
	oibugKg749X/LC24pm7L8Vem7l9ItA0vo2XGIj0kQ4VUc+GYFSLafv4zSXFrDvXJ8GGB6y3dgXk
	e3Ve8s/7pd3ENr9iZDb6FpMH8l7KxvRofcVyphJhQCmQHO66pFEe2DR0THEskMuMjKEP18qiKcI
	nxO+WRbQqOclV8U0fBIUi2o4+cxLqEM=
X-Received: by 2002:a05:600d:8449:b0:4bb:5f07:10d7 with SMTP id 5b1f17b1804b1-4bb5f07134dmr146384475e9.26.1794843046610;
        Mon, 16 Nov 2026 07:30:46 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb55ae5299sm315252695e9.11.2026.11.16.07.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 07:30:45 -0800 (PST)
Date: Mon, 16 Nov 2026 16:30:42 +0100
From: Petr Mladek <pmladek@suse.com>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: john.ogness@linutronix.de, rostedt@goodmis.org,
	senozhatsky@chromium.org, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kprateek.nayak@amd.com,
	akpm@linux-foundation.org, baoquan.he@linux.dev, rppt@kernel.org,
	pasha.tatashin@soleen.com, pratyush@kernel.org,
	ruirui.yang@linux.dev, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, kees@kernel.org, anna-maria@linutronix.de,
	frederic@kernel.org, tglx@kernel.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, brendan.jackman@linux.dev,
	hannes@cmpxchg.org, ziy@nvidia.com, bigeasy@linutronix.de,
	clrkwllms@kernel.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC PATCH v2 1/5] panic, sys_info: Fix duplicate and dropped
 all-CPU backtraces in panic
Message-ID: <avshouTNBIeM5qtP@pathway.suse.cz>
References: <20261103024453.922373-1-atomlin@atomlin.com>
 <20261103024453.922373-2-atomlin@atomlin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103024453.922373-2-atomlin@atomlin.com>
X-Rspamd-Queue-Id: 4F0BAC0010
X-Stat-Signature: w8n3bfzrr79etioe31w74rcxw9bka8m8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794843048-637116
X-HE-Meta: U2FsdGVkX1/UD87VAunHqG+S7WHYshw94UY6XSfZO/SDJK3Vhh+R9XxMS6RYxVFhfN/NbCDeKZwjxhF9Uzz/LF4C+kSKKoU/oW/HfmslZiAKQDtYODv+xdvKuAuwXM9tMcfstuWIJ3f+KNadDqFXM8khQBhIJhqMJlud9bJSuBzlsVQypjJ3rqiT+U+Uw91hFOQwVrU2VrflT7+N1KJYFPoyQqOUOHxWzF9RDzvGN3OGWgTAIWn6qzsDm/0MkWGhMMLNFwSHLW59APX/wDfDDMJxJYwBgZPm1qFF83vBifusCgKHpaO9fIFQ3jkSPZGrIOJ4Rsll/+UhsFYue8gZxexZ12wmMU6u408k6JVG3EeO5J1VBv/tnzuE6HOte657CrGtZfHPaQmAep7Vfh40LvGaY1D8OalYRcw0eIVH20xYV9l0BpDd+8nIRdkZ8lLwf5xcFG7ckQCwO5IjOodOv8dqzC6zfOt4pQo5HVJ3SEJfsBEjCub/JB3LktCCid6WUimEFLBu/VxY4f/0BgevSb17coW/ABdjvb/SMbEYNB9jCmtLOYHycvFayRrn+VMlvf+BdP08HNte5EquZMnjZDsuEMfXcMPlLBtieMyu8EbOjzt4abQYpxxWFuc9f7mhJtpSvQgtwA0hJcBbVLltCLQUS61E8aag4rSI/2OomGNvh0nRqpxyBC4WqxbpwfSQL2RKWR34UibOn9qn6e4jyA+wrmc5oWUzlfJS+hcfCQi6F4VFIUE0f/XFVRuVIzP3WKkX6cypAhtnruEtcHKTSDBzaTu/2FS8KSV3ExiRAnlVWRWJK8/S1ygkkxm/BPqlxQKpz0KZqSnYcFn0iqJVwtSmPhj0ZojO+6WL/sYXebC4QfppKjVgY0pKF0SLeGNmBV8IVcVNDNZ8S6wkowJb+M92fiGmmSmzjuh8hkduYlWoP2liYXMpmuLrvUdq55MPI7XVCK2Ofv5CZoCXsd1
 4EFh5KOt
 YtO7qjNhHPIZRBCnX5VnyLFQQLT4Jze3C3MVBj6rszD2yMf+QZw0qWpd8T44MhCvqx7SDd9A5wARgahShqoPbX4w7z1t2xdEdmdIKjbSu/EmvFhu80glPlfHKAfyzoyMkckaPlcDsBUyzGy/8UCgxtj5Fr88iN1ap+rrfOpPX72KF+p7q7ZzcFxMODt9e31W4h72CVM7kGZUR0WUGFE2kMo9gEBGGy16ViUTI3X/xk22zSFZ1eM3b89CdHyUHfLB012sL43RSYRj5HkuzN1Gw4IleVjgTJyEAR2TilKEc8ACIhhw0IXYY6T8SQ5DgvBzCWLJsqd3RR3LB26skZTefqmtPBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 2026-11-02 21:44:49, Aaron Tomlin wrote:
> When sys_info() was factored out of kernel/panic.c by
> commit b76e89e50fc3 ("panic: generalize panic_print's function to show
> sys info"), __sys_info() gained an unconditional call to
> trigger_all_cpu_backtrace() when SYS_INFO_ALL_BT is set, while
> panic_other_cpus_shutdown() retained its own call to
> panic_trigger_all_cpu_backtrace().
> 
> This causes two problems during a kernel panic:
> 
>     1.  vpanic() invokes panic_trigger_all_cpu_backtrace() inside
>         panic_other_cpus_shutdown() before stopping secondary CPUs, and
>         then invokes trigger_all_cpu_backtrace() a second time inside
>         sys_info(panic_print) after secondary CPUs have already been
>         shut down, stalling for up to 10 seconds waiting for offline
>         CPUs to respond to NMIs. Furthermore, if SYS_INFO_ALL_BT is
>         configured via the kernel.kernel_sys_info sysctl rather than
>         panic_print, panic_other_cpus_shutdown() misses it prior to CPU
>         shutdown.
> 
>     2.  If sys_info(SYS_INFO_ALL_BT) is invoked on the panicking CPU
>         prior to panic_other_cpus_shutdown(), calling
>         trigger_all_cpu_backtrace() directly bypasses
>         panic_trigger_all_cpu_backtrace() and leaves
>         panic_triggering_all_cpu_backtrace unset. Because panic_cpu is
>         already active, vprintk_emit() silently drops all NMI backtrace
>         messages originating from non-panic CPUs.
> 
> Export panic_trigger_all_cpu_backtrace() with a panic_on_this_cpu() and
> one-shot guard so all-CPU backtraces are only emitted once before
> secondary CPUs are stopped, consult sys_info_get_mask(panic_print) in
> panic_other_cpus_shutdown(), record prior Oops stack dumps in
> panic_try_start(), and route SYS_INFO_ALL_BT in __sys_info()
> through panic_trigger_all_cpu_backtrace() on the panicking CPU.
> 
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -451,13 +452,21 @@ bool panic_try_start(void)
>  	old_cpu = PANIC_CPU_INVALID;
>  	this_cpu = raw_smp_processor_id();
>  
> -	return atomic_try_cmpxchg(&panic_cpu, &old_cpu, this_cpu);
> +	if (!atomic_try_cmpxchg(&panic_cpu, &old_cpu, this_cpu))
> +		return false;
> +
> +	if (atomic_read(&panic_redirect_cpu) == PANIC_CPU_INVALID &&
> +	    (test_taint(TAINT_DIE) || oops_in_progress))
> +		panic_this_cpu_backtrace_printed = true;

This would be pretty hard to maintain. The complexity of the check
shows how many code paths affect the decision. I can't imagine how
to synchonize all the pieces this way.

We need another approach. I remember that I have already proposed
something some time ago.

The idea was to enhance sys_info() API to remember what has already
been printed. trigger_all_cpu_backtrace() and frieds should
not longer be called directly. They should be called only via
sys_info() API.

See https://lore.kernel.org/all/aj5tFiwhRqPkAkqU@pathway.suse.cz/
for more details.

I think that this would be a better way to go.
What do you think, please?

Best Regards,
Petr

