Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE998F44869
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 13:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 399286B00AE; Fri, 10 Apr 2026 09:40:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3704A6B00B2; Fri, 10 Apr 2026 09:40:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 287526B00B4; Fri, 10 Apr 2026 09:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 178BE6B00AE
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:40:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9768C1C88
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:40:10 +0000 (UTC)
X-FDA: 84642754980.10.3A648F1
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9DD2B40008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:40:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pPplItK+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of elver@google.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775828408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iCXB7w7ko4o+lkpt1Tfr/OwLPxl1m2l/vGRhYm7vF9w=;
	b=nDmCQa4GeaVtyaAFHE4wf9bRhEZKXlzydyxtS70KVOUiiSfzyrxp2TQdn5rCXVRUfxBZqW
	1x//CFtZyDVBrHhv01lUDvFeMA6MVDGV38mWKTvqviWoIU7ji0tsp2NWHr/Zi1ywW3a7+B
	6ebgKkjv3Un0cJCgbEcCRMqYHUUQOCE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775828408; a=rsa-sha256;
	cv=pass;
	b=77zIviyxXle8fVI+ShxjZfcOjtS4tavOdzT406V+bBCEKE0brAh6fp3mI6WvPSE1WyPQ8W
	VqWmumSInl4HqCfSRHqKdg1C0aRxVm55mR9m/uIqPqzratDUlQ+6WSkWvspG0nNBirgYTW
	dFeg1XALuNglgmKWpmvGRaVYrwvVv1I=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pPplItK+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of elver@google.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-128e4d0cc48so9423206c88.1
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:40:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775828407; cv=none;
        d=google.com; s=arc-20240605;
        b=RJYwgImXE4RaX4b/hc3Dyp7+dCNLKDIxgAXF7MJ3RmDXADBL1zA5RfXZW+mY0oVedD
         IzfPlKaSAm6xfgI645DrDJ5MAo7JZc91EUDwpXNZ8SbWNs1E+GUoJKbeVXSB8UKQTgDh
         IDk7u3q1L/iBoA1LrLMIXibnM8T5i9HVWrqrt2WGiyevfUWE3GN67Rhl9cDVyOipOed2
         rVlux3oIiP/niyOdpU9O5fGW8wfWN0xO+U1NMl04SLVd6FAALOwC4AE8bW7bUziAcF+W
         bHEI/YBHg5MWjn0Bpas4KXctVf9BmbNREPWCCUankkacWDbgHXaQytR/TLOXWBP30t/q
         WkeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=iCXB7w7ko4o+lkpt1Tfr/OwLPxl1m2l/vGRhYm7vF9w=;
        fh=Ag11ca5DmBV/yq4YDs0MB2uby60NigON9mnYFOx84FU=;
        b=M8XjyVuU6D6vuGG0RNXFgql0Fw3Ihm9k6TTuNSxPLHnMnTLeJmZnleaepr7RHmEVay
         hckAyUXBSyR/VJ7t78NpIMGGis9K20PTzJCzM2knRjTYOVmdHI8a1gr4bBHB26AH7DA6
         EzTNE3JuXpec14pGm0w3NcYz4vZPSIARkFiDPpVsGpMSBzkGH3ksdYR9cmqE0S9za/PD
         A8UIlx4b1jauMDdEzS/OGXAxOoesRyb7QIe9Y2s7TAgR4gc0ZbmAtqb27hKwP5who34G
         Rv0dSVVfyf/nhPPm4QdK2CKXl4nQGfNqFY58SnpLbxixJv2AWJCDaN01Y7ib0D9LaXJT
         eSmA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775828407; x=1776433207; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iCXB7w7ko4o+lkpt1Tfr/OwLPxl1m2l/vGRhYm7vF9w=;
        b=pPplItK+qeaOXsv2w4PypBPYmvd1hv8wr2ddp5eITpt1vB0726DiST61MUSvHFsblS
         tu15fbXzTMDzFUfuy0yxwy8A+ydKQtkdZ0dhhEgJyMWP3lbgo3g01WJkZCz1b6Mw+yQd
         /XKEq+GFbsqb5erOELf3qgdAargCBpwMMj477kiGb8MhUFIn8+34acewn8ziHiWUhY9y
         Ne59TAj1mei3ViKr0zKGX99n80/+EFxFyI0o3iNYl6InkVagBF/V/a7ZtNyDpEkzevEK
         GmaV/Vd5pc1nairCOTtoZRh+S5jmRygwN7/9zf+F8BSa0+s0N6/ybzBhn5BVAlYnPEsp
         dhAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775828407; x=1776433207;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iCXB7w7ko4o+lkpt1Tfr/OwLPxl1m2l/vGRhYm7vF9w=;
        b=Jklg9mTSnv4ZtlXbaBJJg4vRn1j3L/AkfWVwDEX9SvAzI8kq1LHql8gSHki9RFeuHf
         J+ZMX2EIK47UB1EHbwBNKne8Sqbr+a+AkiPoTWaJDRbenxkkLvA2QaTcU7QE05yLef9k
         wha/Bzy7I6xQ5NZuL2j/968sGPYdTs82c0uCC4CYnVJ2fPi6ZfpoqKghpT1EXUWpaxD2
         Y/DmyHnapcpwdZxSsUFweG7o9lKza8dOUtuWoUMrB7wFJAip+kZ+OPDJfMnPQMzQlKaL
         IkO0zxaD5NsIZIh1ZkPXze9jF+1weiZDQfRP8LwrGkVJrWnOpqyauhlFRDTutFDwNK+8
         3vGA==
X-Forwarded-Encrypted: i=1; AJvYcCVeKIZvxh4gbV2bhFQqiTr9/sbOcAiUns8wRWhw81bBpr5kf0AA2htAyo88b5FLcELBsWQdhWi01w==@kvack.org
X-Gm-Message-State: AOJu0Yzb3QLlcjotlo5eaDK7mYlSenDDT7UnkJbROiMAoh33oRQjgeFD
	eez5PP8emgV/kJq5gwxlNtSUE36/TxRTznCYhPTOmKXvGVzXNWPzd9pefiNPO84J2+DyhR9wkTE
	1lAqnH8c9bJPnbMxo2RnYRJ5OTDJ+9/x9FCRrZC9N
X-Gm-Gg: AeBDietNxGsG9vHTAUiMezlHWPT02TAEpqIWDl5mbYfcL63ytRA4/GW4VhRqdOS/m1p
	tO1plDrTH2TrIvtK3fmnXiA0vkk2b+to0HJsHkBoiDtI737WzySCEuDZOr2n2zrnMLxMGIHUSoT
	fq/mZNdNW3drfxzFvJpszHb3w4G9BAjuLz9Suff0jXcbZHvPrxeWKuNeyAIKeBpShpN1qHWxnzr
	3DV5w9vPyQh8E3RF5ivnKlR+mlrwt28PinrHP5t1bi2Rr9/0WGj5eE46SbHwOOpkse66YE1vNqp
	rrntEoLFv8DwqeputRi9tiDTWbLBmhN0z05ITIi8RsStiiLL
X-Received: by 2002:a05:7022:fa04:b0:12c:2ed4:62fa with SMTP id
 a92af1059eb24-12c34ef907emr1882312c88.32.1775828406651; Fri, 10 Apr 2026
 06:40:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120318.862164111@kernel.org>
In-Reply-To: <20260410120318.862164111@kernel.org>
From: Marco Elver <elver@google.com>
Date: Fri, 10 Apr 2026 15:39:30 +0200
X-Gm-Features: AQROBzBE-9UxDQG5mMJLgipEeL_Y5pwE-Y_PUrJGxDBLilqBu51b8lLzxdip708
Message-ID: <CANpmjNO1vsO1LT6xijhz3nsjQa+_A=9omfgOSz=aGn293-LqTg@mail.gmail.com>
Subject: Re: [patch 19/38] kcsan: Replace get_cycles() usage
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, 
	Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, 
	Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	David Woodhouse <dwmw2@infradead.org>, Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Thomas Sailer <t.sailer@alumni.ethz.ch>, 
	linux-hams@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Richard Henderson <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	loongarch@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-m68k@lists.linux-m68k.org, Dinh Nguyen <dinguyen@kernel.org>, 
	Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org, 
	Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9DD2B40008
X-Stat-Signature: 31g9h6qi3jho3hhka6neb1h4xf3uewrg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775828408-206714
X-HE-Meta: U2FsdGVkX19UQ6Asl4DG3iFTk2EOzXdwVWkUytONL2EvCrl6MPnJcdyOfeo8a4Ax6qu8/WxpKaa2R5nQivHSVksZMNmFy/NEvFeG6Tqi7ALJLJBgYo519leBvD1IHKbxljJrg9PmuloaknG+nOQrhc+vwA1HBfQ9qJ+24t0PIdQk4MrO1zMadGTEEYykUY5Q6Z+Mxqs62H/Ij4WnsphNiGfWi0VDnMImQOKSjIuXKQIYWSy3LXNvtdXKZME8ym4w4IHnuDaUEL95d+ZPHxwQ34TUyEFilPuxRUMkfd+Liy9f7oRSmyvuYdS+OzSPxyocHEWMY9oJ71QjM8qApRu1f7bMr6pIMo7aQKcnkuZTWGE3q1BjJHDPLDzr4ycYD2Py3CNJDnXI6qAdUBKQNgTjRvzzW9u1OuCIyOQFtroEn/W/383F62jYElhmjXPPON2nF17LMIGdS8cosrRp5QKKc9nYQBpJhvMiC962EVabjt5eLBeF7PdprLBnI0Qyr10v0m5A23u+Pd6FBpyHwzEPe5JQyndnNqkD2cCR0aqaFObndaUhl2G1HS8bYVaBffLVmhJtWMexku2JKEczdPR9izX1iQVTUAKWvMfQKS1KWWS9gu02TgDUMR7KV3o7UyhwMG7LCOg++sVplMXX4t7FhKu2xKk/tSd1J+FY43ZXK55D6uXB/ub8J7RODzEed0iH/x4Xxflcmxl4MTeRF8VO9Q1Pq+AJLmvflAUioM7sj9ZNJg6P0HIsyMo/xL383gUCmk+ghLd6gbyTdVc6H5AIiaB72nR172CBPXYIkSNZPkyJzXYCL2GpEjtyOv+8M8Tzo2wNR+M1yxYqv8dUt2fkISokUHII+etijSO31VVwx7USJm1N1PqydijMztHplpK1/jmkw9g93ve2H8YEBkevh2/pF+WUMWx6mUsMVHUncnLJ0u94hHmw4UwgBCvokf4KLgylvkhsMbARDDBKllw
 bmAOb8ME
 yynvfjuHqwFMkECOPfshPIpDkyKYzKuzc7uYiieuc2RtswOYB2SxAFpjvarAmD3W7mqlagK9Al+GwJ/KzegVpfTZZCBOFpFgRm5n4dWJ22KMdZlp7lTw1bFtvwM4zaK756dbwQuFvAT7NACyMhUJUO4WPjzpFWJVqQKZzdkcE1Hv0JDd436RnzGDT50JsojCsW1JZeaEmJanNxsudqgVpGcTBBCtJdZJmfuNEqc0JD+aNR6nEsp+/Eh181AREPYmnGyCUmkdSv2QWJl+N22fKeFVC5EQpZHFCsJf+ZGIJ0HvqICuTMSZvLr+tZ3joej3gMSSI8KeS7BG1446IdhnElw0FTEkxL+qp57MVxRGho12kX3lOqfP6fU4aTU/crY7TArJV72+lOtEW12ijXAJcSmShvkmjGKkVg5f7luoe4e55ovy2aepAA7P7+n+kp4PGR9t+IOmiDKK/wgw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026 at 14:20, Thomas Gleixner <tglx@kernel.org> wrote:
>
> KCSAN uses get_cycles() for two purposes:
>
>   1) Seeding the random state with get_cycles() is a historical leftover.
>
>   2) The microbenchmark uses get_cycles(), which provides an unit less
>      counter value and is not guaranteed to be functional on all
>      systems/platforms.
>
> Use random_get_entropy() for seeding the random state and ktime_get() which
> is universaly functional and provides at least a comprehensible unit.
>
> This is part of a larger effort to remove get_cycles() usage from
> non-architecture code.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Marco Elver <elver@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: kasan-dev@googlegroups.com

Reviewed-by: Marco Elver <elver@google.com>

> ---
>  kernel/kcsan/core.c    |    2 +-
>  kernel/kcsan/debugfs.c |    8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> --- a/kernel/kcsan/core.c
> +++ b/kernel/kcsan/core.c
> @@ -798,7 +798,7 @@ void __init kcsan_init(void)
>         BUG_ON(!in_task());
>
>         for_each_possible_cpu(cpu)
> -               per_cpu(kcsan_rand_state, cpu) = (u32)get_cycles();
> +               per_cpu(kcsan_rand_state, cpu) = (u32)random_get_entropy();
>
>         /*
>          * We are in the init task, and no other tasks should be running;
> --- a/kernel/kcsan/debugfs.c
> +++ b/kernel/kcsan/debugfs.c
> @@ -58,7 +58,7 @@ static noinline void microbenchmark(unsi
>  {
>         const struct kcsan_ctx ctx_save = current->kcsan_ctx;
>         const bool was_enabled = READ_ONCE(kcsan_enabled);
> -       u64 cycles;
> +       ktime_t nsecs;
>
>         /* We may have been called from an atomic region; reset context. */
>         memset(&current->kcsan_ctx, 0, sizeof(current->kcsan_ctx));
> @@ -70,16 +70,16 @@ static noinline void microbenchmark(unsi
>
>         pr_info("%s begin | iters: %lu\n", __func__, iters);
>
> -       cycles = get_cycles();
> +       nsecs = ktime_get();
>         while (iters--) {
>                 unsigned long addr = iters & ((PAGE_SIZE << 8) - 1);
>                 int type = !(iters & 0x7f) ? KCSAN_ACCESS_ATOMIC :
>                                 (!(iters & 0xf) ? KCSAN_ACCESS_WRITE : 0);
>                 __kcsan_check_access((void *)addr, sizeof(long), type);
>         }
> -       cycles = get_cycles() - cycles;
> +       nsecs = ktime_get() - nsecs;
>
> -       pr_info("%s end   | cycles: %llu\n", __func__, cycles);
> +       pr_info("%s end   | nsecs: %llu\n", __func__, nsecs);
>
>         WRITE_ONCE(kcsan_enabled, was_enabled);
>         /* restore context */
>

