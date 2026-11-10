Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CD07606A7F7
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZkruCbZ7
Received: by kanga.kvack.org (Postfix)
	id 5C21C6B05B3; Tue, 10 Nov 2026 08:23:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5995B6B05B4; Tue, 10 Nov 2026 08:23:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7306B05B5; Tue, 10 Nov 2026 08:23:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 32F506B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:23:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2782BC06B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:23:47 +0000 (UTC)
X-FDA: 85419276894.03.8A1BF55
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8ABEAC0003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:23:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZkruCbZ7;
	spf=pass (imf28.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794317025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wnCPVGnFkCMfnhztBqzYv3ZWVtZicPARnus4J5UF5Bc=;
	b=EY1rk5ce664lnrSF5IHy1bCNRF8f6JP9BOJEHw3HlxfEvOGZCfkLXS4tNuFyIPOm4lBm3l
	WkvbqDtAQeOsPEYg1geocNyr9cNQT6AbFQvRRsIL78GAOUpy4ifFfp1i+csy71zjdyQ8Zv
	iYD6eXsCQSmhlqDb0CyQXTVsMuIDCS4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794317025;
	b=JueNXMwxG5vSeVAEWxITc8w5/zf15Vh5I5pPU9vuKXXE1siN74DGX8n5Us12kruJWgxf/R
	K8jA3nPddZFJ0fh0eK06s7p27bhFhZEM4Ew3FkI54r6J2oX1IhsKs9Y2GRL9DELg7WwKHh
	1RlpjtZDWlOHmsm+0pWcxj3X86yIROw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZkruCbZ7;
	spf=pass (imf28.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BCB0D63917;
	Tue, 10 Nov 2026 13:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6991F0089F;
	Tue, 10 Nov 2026 13:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794317024;
	bh=wnCPVGnFkCMfnhztBqzYv3ZWVtZicPARnus4J5UF5Bc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZkruCbZ71BbG9JOnDTQW+HinEcm0lMCTvvCCvkt04ltCSD7uOQfxPBzYAexdZ4uSA
	 3t3MQ3XPiTjY8gcS+4EzbWh+4gOYlJimWi3Kit1D1fiOixEP9rirz5THqnbKrZ8VdF
	 jSm8toZ2W/1Knn3vWCHY4ctcG0xhgr9bOkaEIJiKjQE8Vm/ACgwK99Jn2SUePCb4Is
	 8HfUnZkw8778f9z6yIbAcsbwI5yIBLLWX6tRYUhSU23U0hwFuKRyrLJIoZyJveFuLr
	 DgjvfV+E9nXln97l53kgQvXYSJCwgoddmL+1BHEYd4hPjROhAHxnSnj57fsutGCBPM
	 TXL5DwKmFPB3w==
Date: Tue, 10 Nov 2026 21:03:31 +0800
From: Jisheng Zhang <jszhang@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 2/6] arm64: entry: Always inline helpers used by
 non-instrumentable paths
Message-ID: <avMWI5makxfDNJXD@xhacker>
References: <20261109114500.20298-1-jszhang@kernel.org>
 <20261109114500.20298-3-jszhang@kernel.org>
 <sashiko-outbox-206977@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-206977@kernel.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: i33hsyau3qd6uw49rp1cus5xpgizsbag
X-Rspamd-Queue-Id: 8ABEAC0003
X-Rspam-User: 
X-HE-Tag: 1794317025-335305
X-HE-Meta: U2FsdGVkX1/c5ZiXbVbwiiYwCNqrqPJzADfxb4MenIUgIK2ltBVzeRtvoYcrOV/a9YRsKn+Qc5/91snuK6icgqPczlYH7OgTAfCLPM0aCxEmCLnOZRPQkQ/OuIri5AXLyog8jTVheMT2VDMI111CcRq1m+m0R0J4BtCBn7aWkqrTcsXNr9ArqscmiyBO2QDoipv1LVThDSeactczmTxKdznQJ+u+KtutGpTOvfknjB//R9WHVQQWZdCWDV9lLifDu1ktxK2TuAA/biR3AJK6511a9uk07Aou55gRDsjzlU7cfov+dD+0d6/346eiBS5mpwaKoa9SmEV3kHcQ/IyZLlK2NQHb0YunQgKETJSie3e0iFvHiJudkg29QyxbI/UUngxOgZSmz6efztgYa+he48CrgaqNe0djrioG2Pi11YUNzM69vaYtWs/JHZoLSwph7ph7VT2oJBFJd0HJZy4P+lq0ARSSKcehEHPj+yw1GOfkEC1uRGn2cdYqXuNNe77ZXIN+AuLbrokhg3xAcvheF7q71aYpUji6DPEE52teA543AV688IRKZ+9abFX7yaM9NFTD4/CB8uL7VXXuMRVGVeJ5siCMvrjhvqwUBp4n/D0UNyciPTDJw7w+foRcvlYjiAqyFlJuXclumX0HqoH9Lc6hKCZSJXahe8m+1zyRiv0c/zTwqMXZiS4p7bxubCyNXP1LZh8i+0Y7BdJsX4ZtTAdS5fsjVnB3X3tyYgmjcI9J5ulsENuptc4f/1ggT37OooSGdFnXtFNwFUiZt2d3YhbLhca2tR8YItS3PiAORV+OX6b4WDCz6v8YTzYn5muFVSlfOA1iDcqBUtBABz1LzFQf3vlRccUXI74dvMupWUxQPE9CVplxpBXFj1lPAFkTfS4zMNCq1VaFYUTvzqh6O7NmnA8/1KcTR70hGwAd7/1trzlhMqiZm6JrXCK8XdAsyTQDeG8oxoaljV2m5F3
 DFlgCWwF
 opQI3EgQTdvaITb2t54+mbtgEAMR4jgq2nE4aGVB0WYKn2ib3Tl34OCYSAWoojliy6TivZ6O2J1DORMK7kN2mJ3olX1xRdXsAEWHXIQ1RS5n6srwfonlJzzLIAEGLff6b1oK/5MvCSunTgroUEu68V1nDYSBeGZXD5DnSaGeuRNL3vDffVtJOZN+ReER2ZG3L9xoEIh72Tas/TGN9ft5w56w0E8zNooUojk9m1NfaxNAwx9nZUurTYcyhYGzE/p438zah4YZP2IgcTmwj6oaS8A+PgA68NentoEx5lnPV+EMT5x0uqMVrPgm64FQXXTea51+ifFMvv44wpl+ADSGzA7Zr2K8/6CcT9KZK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 12:05:42PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] arm64: entry: missing __always_inline on !CONFIG_ARM64_SME stubs
>   in fpsimd.h
> --
> 
> commit ed5f3b4320afc347aa0402f3b75096047a676bff
> Author: Jisheng Zhang <jszhang@kernel.org>
> 
> arm64: entry: Always inline helpers used by non-instrumentable paths
> 
> This commit marks MTE, SME, CPU feature, and rescheduling helpers called
> from noinstr entry and exit paths as __always_inline, and updates the SME
> entry and exit helpers to use tif_test_bit(TIF_SME).
> 
> > diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> > index a67d5774e6728..e7c881c1c1f79 100644
> > --- a/arch/arm64/include/asm/fpsimd.h
> > +++ b/arch/arm64/include/asm/fpsimd.h
> > @@ -749,17 +749,17 @@ void sme_enable_dvmsync(void);
> >  void sme_set_active(void);
> >  void sme_clear_active(void);
> >  
> > -static inline void sme_enter_from_user_mode(void)
> > +static __always_inline void sme_enter_from_user_mode(void)
> >  {
> >  	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714) &&
> > -	    test_thread_flag(TIF_SME))
> > +	    tif_test_bit(TIF_SME))
> >  		sme_clear_active();
> >  }
> >  
> > -static inline void sme_exit_to_user_mode(void)
> > +static __always_inline void sme_exit_to_user_mode(void)
> >  {
> >  	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714) &&
> > -	    test_thread_flag(TIF_SME))
> > +	    tif_test_bit(TIF_SME))
> >  		sme_set_active();
> >  }
> 
> [Severity: Low]
> Should the !CONFIG_ARM64_SME stubs for sme_enter_from_user_mode() and
> sme_exit_to_user_mode() in the #else branch below also use
> __always_inline, matching the !CONFIG_KASAN_HW_TAGS stubs updated in
> mte.h and mte-kasan.h?

I think this is false alarm because the #else branch is null function,
any compiler will inline them even when -Os, but if maintainers wants
__always_inline as well for #else branch, kindly comment I will update
them.

