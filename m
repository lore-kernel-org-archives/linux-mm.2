Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5D08606A327
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=otzl4zhc
Received: by kanga.kvack.org (Postfix)
	id CCA3D6B061F; Tue, 27 Oct 2026 04:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA1AA6B0621; Tue, 27 Oct 2026 04:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B695C6B0622; Tue, 27 Oct 2026 04:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B2576B061F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:32:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D134808FA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:32:04 +0000 (UTC)
X-FDA: 85367738568.21.D3D6A38
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id 375D9140005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:32:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=otzl4zhc;
	spf=pass (imf23.hostedemail.com: domain of elver@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793089922;
	b=IHk7Wmz0OmjN14ispnzE8eNX53Gqmqh1hB1VX5AXmbdcfRW1mbjivGMN5wpSMM29IL8Nrf
	FliPJjZJ7/eWLPOt7XXJTLZZa7Z5/oL92v3xVvESUYkXDLNb16PjsLyj3idoLrhi4a+g3f
	9rPPjIdFbLFN0Z/LtzLIIx2r2MwQm7Y=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=otzl4zhc;
	spf=pass (imf23.hostedemail.com: domain of elver@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793089922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UynfW7iNvibXVGme9+4+y50qRrX7DGhKBqz5uurKF50=;
	b=55vzmKnuaL+czUqkPr2tJLybZKA2NvZVs1Q+1k9mSPE3hbm60/jPg5axVsxfdVrfDLTmGl
	pDxZkkK1EgfD1A3jvHWzj4F1npqtKTDH7SzdnQ1niHiJBE0ISBoFtmlcbmaaQf5AwMZi+C
	60QRYQ50pyWOkoTX6FoQGZimIqFHt1k=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1846bc43c28so4397052c88.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:32:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793089921; cv=none;
        d=google.com; s=arc-20260327;
        b=VQEkLs9rpfVeQzr6BUqWPKDktr+rjoab81MODx5uvk/9FGo8a2ZOltmaOaMaxyH8uO
         NKDt8S6s6h+YEt5vRj/xTHVdRKIsb/VpHZ5NCNlwhl42mdnvMWfnXN6PhF8JxkxJPpSb
         XZDaNVlAKzeNc3tjSBIxMoeybUpA3dybQmVQ3goXGXK3RO+8ruPzplgjFy3dqqmoq1Bp
         gE8nAKx/HROfUn/z5AckktrIo32KBOdrpgaxOxZR14ep4MIhm8f0i+hNfW0NCyu3u3pq
         DE7sZdrkjN6kKj5wXaNCG82oulkklkr2hsyRJVdI/Zr0MEq6CWmIzC12ZjIQ82RnXfaD
         ISNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UynfW7iNvibXVGme9+4+y50qRrX7DGhKBqz5uurKF50=;
        fh=cmAP4m/sNEx9lzPC/GkXTQK11HjM3PJe7t0Qhq2Gt2s=;
        b=p5oRsSn+Xt7POMKlHOzMU1EgGAe7r6Z4T2dF8QUqb4lUfY0dcIueC/klJqn8668O+f
         bWX5d5UPHwLGYFfOB3ugMfU5uG96A/o15WgkmjMzVLKFT02b5NG25WKDF7YgKvFg5JJr
         PJB7FbyF9hZLBucL8uilhmxnMpUBPuJcB3aQcxI/XvN/ZkSdNtkNmuley7S0aDhr6Eps
         zqblUauLmkh5kezdk/jpvB+Z1STRKVTtn23Kb0N6/RDRHoxmv6zzJ7D8DhDEB1WA1KIE
         R/yMi3/a/1s2vCIPJ8T4n0uqgPGD9Q0HXrzvPidCd+Kv0t7CbJsM2CA51EK8Ij/yuN8l
         ht7g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793089921; x=1793694721; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UynfW7iNvibXVGme9+4+y50qRrX7DGhKBqz5uurKF50=;
        b=otzl4zhcVZGLlF6D5gENIxz28X8xEPS3ZvXKmJ2Mr762WqhGmj2PQ3zkKxsLqcDux9
         COFtXbWO8rHW53c61+4ZgOiK/Ggpl8Dv7mqA/5wOgBcSZWyj7jiVVikmnj5+rFX1d21q
         LXq5m5gsMkvo3LIC12oIm35x8zFEed/5915IFtdFoJwHWyQMp6dX8tbuFtkU6F0v8X9n
         C/XXGfCNSmD8wg5oilJG4FVxKb5mdUYheMpGp1lcfO4Ow6ZCV2GUEPtAGz5eS+Go0UV0
         Ph0uE/feSS6pD/XImR4gr+d2TnxpgnhJafeQBojkvqFRnZyFFRN6KyAM3Mk8+bfsisgU
         GkPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793089921; x=1793694721;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UynfW7iNvibXVGme9+4+y50qRrX7DGhKBqz5uurKF50=;
        b=u1Gj68/WwFZXdrMVdFVlU4n/j9pNYIBy7fQlhiGrDTyOXFVlcFJI/0NCpVb8WD1LWg
         uX77r8yTrfwBZEGVY9VAkCcYo+dKEK1uQFybveFnHzDLh3shGEJifEEA894a9XQ+WQ0k
         qwdgVXmNMrkuPS9NKAbV3ADv/lq2RWo3LogT9af6Nr8a6hzhU0JjJexAM1xWVyL5RFAs
         U8MttMC5XeeDTe+2DUp4inkPi5v3xeD8GZUaAiNFDONmBt2UDtAFrkxTgedDWHx73VqW
         V80yOKZ8hHRHRf9zZcZm+ns9fsxfRAtykBiF+ryQcYvDUqUvtcUnUlBaFSkGoECUXnbJ
         EY/w==
X-Forwarded-Encrypted: i=1; AKwUvBza0DvDcAfhg1dugc5aG3npQi34QCjEJXynpNPtqo4bLPzFBhEDKk9d4V6E/go8Z3tMoThOP4IRNw==@kvack.org
X-Gm-Message-State: AFq9FYIbp0zsfqfGnR+nL40V//P632id11J0Dx47Yu+k5MZ21hy68qnc
	8JT0AGoYtZAwIAQsqpvmZXWNswuapPJEdhJWAdmGe6VJu3mkc7+W3bLsGRRsH+X2hA941tO9VGi
	U0BKN0TaO2knru5kl1M3m5EBBoE1oKvbqt8sZCJaU
X-Gm-Gg: AYBFou1n2zFFGKizHdLrRG8T8wm5i4eIOQkke15PF057MPiaFVHKVjEf0fBDpMIY7h7
	2Oa9ZtVxIENucWsDmavhIvU0UK8+W3k1tGgpM6TWwlqLoq0dsppXs4Dmd2Q4Juqz6t1pYMxyeoC
	vdATy/8K3xMwEtTgCpJGk5ApSv7CeBauvQ5x1hg4RNoe5fz4s+KzfmMNOu+Qn4zXD82fkdDU1eX
	XSRWLzS7SS5mSbdtr642N45ShQzFyYxYA/qsYYiIC/KChwiPyjckpzs8a+6aa/U4/TnY3jEDsjW
	EFPuA4FQKIRBTwEJ0pL4Qzv4CVXM2jowcn6eNXYvBzjerLcpvwpPLj6Ltel7saQsT60TSigp07Q
	m5u6A5dnuSakQuw5aBnuO6BVne6x99BLHcXUXLbT9WvxXKolXtmcxmBJKraVQ45MmMMBc
X-Received: by 2002:a05:701b:2719:b0:14c:c947:6afb with SMTP id
 a92af1059eb24-1993505eb6fmr12920689c88.15.1793089920040; Tue, 27 Oct 2026
 01:32:00 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <auA7FdubFEDVPB7v@chrisdown.name>
In-Reply-To: <auA7FdubFEDVPB7v@chrisdown.name>
From: Marco Elver <elver@google.com>
Date: Tue, 27 Oct 2026 09:31:23 +0100
X-Gm-Features: AclHuK9Z31j2srRPq0cvI1MA14RltVYpiKhG7tlR1MRKpnbY3pyvJ0pGLxERO2E
Message-ID: <CANpmjNMunLgXHRqXgW3LnniCX50CLbLYsE3DpY7h=cuvu2vSkA@mail.gmail.com>
Subject: Re: [PATCH] kfence: Allow selecting static keys mode at boot
To: Chris Down <chris@chrisdown.name>
Cc: Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 375D9140005
X-Stat-Signature: gzga1ya8ikxutff5i47oiqkwrpg4ojef
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793089922-275624
X-HE-Meta: U2FsdGVkX1/4v0dOpGih7/dCpwCuWQt4gBWojMTBQ6bNdtXB+tR6hSU2nwo/3INs8vPkqsKJYZq855J0kNsCp9v7ZDfG1BMb4+MMtcZZzfj/jFta6Jd2HeOHRz+hnyKqaHgN+ypAsXd1YaFUvNBUsSTBYaIb38xC62vAL0wj22vHtG63lThmd1TlDCpY+bK+nqHd+SWvT8XsrBqwUI+5sIPgGUNUuYMB0C6LeRb463IlWeCNV5HpCPrwb+YtVfTagfV+OW35ny1VZvpxctvIM56Ydi6IH8G9341/ANVTIsRarZVmo57eNuPUfBMV1FuBatpEFCNq/HNRoPF8AmlTTcEXSAOhIFiLIl4op/A/EvK55UFkk79LMTQvvh4tPhaxQTfnSdkUPGXFAtKKr/VfQ0DcT0PzyfM3nrzG/JMsUPozHCisT23Vub8ya2Lukv2mYWYvA5tkks6D+go8appyoFYQc/8NZItrF1d7V54z9MthNH84pDFF1PubWKamVjl6Ax8YlOwCOVT1QEZg9bGy5p7MeTpa9O7XGpRbBODgFwOXWomXa4dy/itj9dzYk9ScBtUG6G1mSNbhLGlzNqjekXQehsKJkeZqylFPdQdhZCCUXbkn0okirumXPu0mur4NjneA/plt0LjJe52u9UykCoJSATPBDLViuNrktvs+Rsb8N/nPEBDyy58o/cQrJ6yMz4U7FAMEE295z90ijs4SMq9vsW5aZVZatGAGE7iGQvw16q3NY3j2b/nPANTlF7BkEk4lOdlCOUpnutLnTy+KeyrRLX8UnI9LkPXZBBymPNPKFCQKKDUHy+D8RDz61uq1YO8tgK9YkSqLHPZ0U/EUSUSY3DiBqzUXpo8L0OeRizAKwfLuJhsNjy4HJgItEVGfcrXT06F40P2rGQVsyi1CrhNtALRHtE/JMbdP6oguPWMpiMCIPHzmn5v7QoV2KyeLkEe1xQJfLLrcS2xuufJ
 NwRcrStO
 aVNpB4B57u4lT4bTIdTreui+s/Yxmr3EhK59aEs6yE57WgWZMk6Mf8hbEMTin48sEx7tFgBDL6+vkX4tCr4rqFfVXJ89bt28ruQh5tweXFK1Cqha7xqbvkOAEug5l66mvANzQy165wVpOTqMRJs3zk2FTwMLHoFdebAhV5Q3wphACma8XNdDzCeU2hIGeSl7UCbPPvb+dhyeAoH0NqAysRjsRwEtd7/45geHCA7LIQ+Fdkgw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 27 Oct 2026 at 06:48, Chris Down <chris@chrisdown.name> wrote:
>
> KFENCE can gate allocations by toggling a static key for each sample, or
> by leaving the key enabled and checking an allocation gate. Static keys
> mode saves a load and compare per allocation, but sends IPIs to all CPUs
> twice per sample interval.
>
> Which tradeoff makes sense depends on the host. For example, on machines
> with many CPUs or latency-sensitive workloads, the IPI cost can outweigh
> the saving in the allocation path.
>
> For this reason on some machines we prefer to have static keys, and some
> we don't. However, today this is configurable only by
> CONFIG_KFENCE_STATIC_KEYS, so this means building and shipping separate
> kernels. It also for that reason makes comparing the modes on a
> particular workload more cumbersome.

On which systems have you found static keys to provide a significant
improvement? Can you share benchmarks?

IMHO, I was thinking of deleting the CONFIG_KFENCE_STATIC_KEYS mode,
because on most systems, it's not worth the complexity for the small
(if any) performance improvement anymore.

> Let's add kfence.static_keys= as a boot parameter so that the mode can
> be selected per host. The default still comes from
> CONFIG_KFENCE_STATIC_KEYS.
>
> Testing with the unoptimised branch layout showed no obvious changes in
> performance across allocation sizes.
>
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
>  .../admin-guide/kernel-parameters.txt         |  6 +++
>  Documentation/dev-tools/kfence.rst            |  9 ++--
>  lib/Kconfig.kfence                            |  4 ++
>  mm/kfence/core.c                              | 47 +++++++++++--------
>  4 files changed, 42 insertions(+), 24 deletions(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index e75344f4e0cd..cda98e1b0b68 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2989,6 +2989,12 @@ Kernel parameters
>                         Format: <unsigned integer>
>                         Default: 75
>
> +       kfence.static_keys=
> +                       [MM,KFENCE] Whether to use static keys to set up
> +                       KFENCE allocations. Ignored without CONFIG_JUMP_LABEL.
> +                       Format: <bool>
> +                       Default: CONFIG_KFENCE_STATIC_KEYS
> +
>         kgdbdbgp=       [KGDB,HW,EARLY] kgdb over EHCI usb debug port.
>                         Format: <Controller#>[,poll interval]
>                         The controller # is the number of the ehci usb debug
> diff --git a/Documentation/dev-tools/kfence.rst b/Documentation/dev-tools/kfence.rst
> index b03d1201ddae..15212ea1047d 100644
> --- a/Documentation/dev-tools/kfence.rst
> +++ b/Documentation/dev-tools/kfence.rst
> @@ -259,10 +259,11 @@ SLUB) returns a guarded allocation from the KFENCE object pool (allocation
>  sizes up to PAGE_SIZE are supported). At this point, the timer is reset, and
>  the next allocation is set up after the expiration of the interval.
>
> -When using ``CONFIG_KFENCE_STATIC_KEYS=y``, KFENCE allocations are "gated"
> -through the main allocator's fast-path by relying on static branches via the
> -static keys infrastructure. The static branch is toggled to redirect the
> -allocation to KFENCE. Depending on sample interval, target workloads, and
> +When using static keys mode (boot parameter ``kfence.static_keys=1``, which is
> +the default with ``CONFIG_KFENCE_STATIC_KEYS=y``), KFENCE allocations are
> +"gated" through the main allocator's fast-path by relying on static branches
> +via the static keys infrastructure. The static branch is toggled to redirect
> +the allocation to KFENCE. Depending on sample interval, target workloads, and
>  system architecture, this may perform better than the simple dynamic branch.
>  Careful benchmarking is recommended.
>
> diff --git a/lib/Kconfig.kfence b/lib/Kconfig.kfence
> index 6fbbebec683a..2b2ad21aa36c 100644
> --- a/lib/Kconfig.kfence
> +++ b/lib/Kconfig.kfence
> @@ -70,6 +70,10 @@ config KFENCE_STATIC_KEYS
>           enabling and disabling static keys invoke IPI broadcasts, the latency
>           and impact of which is much harder to predict than a dynamic branch.
>
> +         Sets the default for the "kfence.static_keys" boot parameter.
> +         Selecting the other mode at boot adds one extra jump to each
> +         slab allocation's KFENCE check.
> +
>           Say N if you are unsure.
>
>  config KFENCE_STRESS_TEST_FAULTS
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 55d5c114eadf..cfbefca5b78b 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -119,6 +119,9 @@ module_param_named(deferrable, kfence_deferrable, bool, 0444);
>  static bool kfence_check_on_panic __read_mostly;
>  module_param_named(check_on_panic, kfence_check_on_panic, bool, 0444);
>
> +static bool kfence_static_keys __ro_after_init = IS_ENABLED(CONFIG_KFENCE_STATIC_KEYS);
> +module_param_named(static_keys, kfence_static_keys, bool, 0444);
> +
>  /* The pool of pages used for guard pages and objects. */
>  char *__kfence_pool __read_mostly;
>  EXPORT_SYMBOL(__kfence_pool); /* Export for test modules. */
> @@ -845,7 +848,6 @@ static struct notifier_block kfence_check_canary_notifier = {
>
>  static struct delayed_work kfence_timer;
>
> -#ifdef CONFIG_KFENCE_STATIC_KEYS
>  /* Wait queue to wake up allocation-gate timer task. */
>  static DECLARE_WAIT_QUEUE_HEAD(allocation_wait);
>
> @@ -878,7 +880,6 @@ static void wake_up_kfence_timer(struct irq_work *work)
>         wake_up(&allocation_wait);
>  }
>  static DEFINE_IRQ_WORK(wake_up_kfence_timer_work, wake_up_kfence_timer);
> -#endif
>
>  /*
>   * Set up delayed work, which will enable and disable the static key. We need to
> @@ -897,17 +898,17 @@ static void toggle_allocation_gate(struct work_struct *work)
>                 return;
>
>         atomic_set(&kfence_allocation_gate, -kfence_burst);
> -#ifdef CONFIG_KFENCE_STATIC_KEYS
> -       /* Enable static key, and await allocation to happen. */
> -       static_branch_enable(&kfence_allocation_key);
> +       if (kfence_static_keys) {
> +               /* Enable static key, and await allocation to happen. */
> +               static_branch_enable(&kfence_allocation_key);
>
> -       wait_event_idle(allocation_wait,
> -                       atomic_read(&kfence_allocation_gate) > 0 ||
> -                       !READ_ONCE(kfence_enabled));
> +               wait_event_idle(allocation_wait,
> +                               atomic_read(&kfence_allocation_gate) > 0 ||
> +                               !READ_ONCE(kfence_enabled));
>
> -       /* Disable static key and reset timer. */
> -       static_branch_disable(&kfence_allocation_key);
> -#endif
> +               /* Disable static key and reset timer. */
> +               static_branch_disable(&kfence_allocation_key);
> +       }
>         queue_delayed_work(system_dfl_wq, &kfence_timer,
>                            msecs_to_jiffies(kfence_sample_interval));
>  }
> @@ -956,7 +957,7 @@ void __init kfence_alloc_pool_and_metadata(void)
>
>  static void kfence_init_enable(void)
>  {
> -       if (!IS_ENABLED(CONFIG_KFENCE_STATIC_KEYS))
> +       if (!kfence_static_keys)
>                 static_branch_enable(&kfence_allocation_key);
>
>         if (kfence_deferrable)
> @@ -967,22 +968,29 @@ static void kfence_init_enable(void)
>         if (kfence_check_on_panic)
>                 atomic_notifier_chain_register(&panic_notifier_list, &kfence_check_canary_notifier);
>
> -#ifdef CONFIG_KFENCE_STATIC_KEYS
> -       register_reboot_notifier(&kfence_reboot_notifier);
> -#endif
> +       if (kfence_static_keys)
> +               register_reboot_notifier(&kfence_reboot_notifier);
>
>         WRITE_ONCE(kfence_enabled, true);
>         queue_delayed_work(system_dfl_wq, &kfence_timer, 0);
>
> -       pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p\n", KFENCE_POOL_SIZE,
> +       pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p%s\n", KFENCE_POOL_SIZE,
>                 CONFIG_KFENCE_NUM_OBJECTS, (void *)__kfence_pool,
> -               (void *)(__kfence_pool + KFENCE_POOL_SIZE));
> +               (void *)(__kfence_pool + KFENCE_POOL_SIZE),
> +               kfence_static_keys ? ", static keys mode" : "");
>  }
>
>  void __init kfence_init(void)
>  {
>         stack_hash_seed = get_random_u32();
>
> +       /*
> +        * Without jump labels a static key is just another dynamic branch, so
> +        * static keys mode would only add the cost of toggling it.
> +        */
> +       if (!IS_ENABLED(CONFIG_JUMP_LABEL))
> +               kfence_static_keys = false;
> +
>         /* Setting kfence_sample_interval to 0 on boot disables KFENCE. */
>         if (!kfence_sample_interval)
>                 return;
> @@ -1175,10 +1183,10 @@ void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
>         allocation_gate = atomic_inc_return(&kfence_allocation_gate);
>         if (allocation_gate > 1)
>                 return NULL;
> -#ifdef CONFIG_KFENCE_STATIC_KEYS
>         /*
>          * waitqueue_active() is fully ordered after the update of
> -        * kfence_allocation_gate per atomic_inc_return().
> +        * kfence_allocation_gate per atomic_inc_return(). There are only ever
> +        * waiters in static keys mode.
>          */
>         if (allocation_gate == 1 && waitqueue_active(&allocation_wait)) {
>                 /*
> @@ -1187,7 +1195,6 @@ void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
>                  */
>                 irq_work_queue(&wake_up_kfence_timer_work);
>         }
> -#endif
>
>         if (!READ_ONCE(kfence_enabled))
>                 return NULL;
>
> base-commit: bae9a042b03b27924c6fd5bdc00a20d6a44d6041
> --
> 2.54.0
>

