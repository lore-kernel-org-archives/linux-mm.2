Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0EF7606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 22:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=dugFetql
Received: by kanga.kvack.org (Postfix)
	id D26446B03A7; Mon, 19 Oct 2026 18:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7246B03A8; Mon, 19 Oct 2026 18:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B788D6B03A9; Mon, 19 Oct 2026 18:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EB4F6B03A7
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:31:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB0C8A8448
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:31:20 +0000 (UTC)
X-FDA: 85340823120.17.81B402C
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id 05F0B1C0003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:31:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dugFetql;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of elver@google.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792449079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Y7YiwpHnHRTlx4OY6pg4GKzGSuy4/quEwIOKfF9VTA=;
	b=v3UjmDyBllW4Pru2HjqefgY/nc2rJ8QVHuCAcCjuv21I4lulq9OPalqkngYIm9ABGswDr8
	klatDZi5A6dQv/ZILf/s2myvnoxMWSLnwCEEMPCMS4xUScbnH8LonXMMGlL//as8l8eaJB
	iQvaRptUDurnJfHmsxntULfGjKKY6n0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dugFetql;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of elver@google.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792449079;
	b=EU65LQfrrwGhH9gwvEhjYMaJ9i122mWrbH4fnM1Ca1rDoU5GZnl7UoAHiEZi+zJcgsTG2/
	bn3+WRbX5P3W0gb3gEeRX5M4Ev07T9WOJj8xk2ZQuHpTIYqCQC2JN4IxdLWH+QjRO9znXY
	27Dz7ga35IK7Qq0qG+oJB+3rf5BSh1Y=
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-353804b591eso4986783eec.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:31:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792449078; cv=none;
        d=google.com; s=arc-20260327;
        b=KB9xAykCFp3caY0zkZxOyC+hDSTMQmwqBHDN3HaEoKPPG3lQfvo4bUXy1Fw+I/VQpN
         8ZzMHmLr7OeRGRer1K4DsmrBTdJXJvYLnyl9dVHh7WSqvniH98Zc0ykgx5/5+MGPfvQS
         /8Mww11KGMSHiOYVhbyTmuSotfvoUAfu/A27SSyWCmqKylYYyZsiVss2cqd12LUEqy2p
         WdtAuICUVcJUgM2ZDmgsNVI3ubszuuS/9itsjuYr5D9qygThtuaKK8+/oCnXEszOzaGI
         XT+0+4mUs7yZj+N29+mLD/BZfVSiNJ/01MQ1mFP8l7vQ/ugHMxiKcDV/OfV3drMqPeii
         luAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7Y7YiwpHnHRTlx4OY6pg4GKzGSuy4/quEwIOKfF9VTA=;
        fh=8G3DEmqEw67Y/f2CiKvF0DTV9mHIH8BILSofZgVr1QY=;
        b=IDUQVx+5rhZ4qhnTfwhG2Qn/Fn9YnK92l/qDWSVW5qZSKUGaGH2bjX62TJQ8S38baP
         dcbHRvAWAEwfQ+DTJ4KLvIbkTu/h0yOUgZ/jWoC0v2SBY84W9Dta/iRU/qu2H+1N+Wde
         BqlTxe58gMBp/4bKre+mwSng+r73Pt9hTzMwufxX59H3nVn+oewq25dad00sypttUgbY
         1M9c0C6aH78HvJF+J/VW8LiE8UbGF1mH24cELUV31ndEloQXmjT246Y/ciOxAUi197pa
         dAVGNX7WOIdNfbXZ86whuMOV11HnLQiicvJFotjc+2RdA5lTBoX5xdFTg6BKYt26Fxwn
         ltEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792449078; x=1793053878; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7Y7YiwpHnHRTlx4OY6pg4GKzGSuy4/quEwIOKfF9VTA=;
        b=dugFetqlms4ECY3fCsKo1gD2gqWayBVKNYUi7I6s2Nu6fZeWynBfy9fOwaoBjIWkm1
         tLFtXsH4r1NrErTm1T2BdaLso+dyU1vutaTKX/QCw1reuOVfDBc4b3FUT5TTIUEdatza
         R50e8oGcB25+r9rKdU1baGNXDbUaP0/72067QqE6ap1fR9dsQRM2nPokIxsc0kkrsP4D
         S1/dceBKgf9YsboRKMXgkAF2O64EGo1WzRykEAGPDKDZF3Zu2ToZCu0KXkWW59bDvVqx
         KKTVVyArdRKLj4xoFSobwJ1o9rIAQL9NDx/s48PRFvP8lJDSGMJkXY+nKKiK9k8fO3w4
         VLAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792449078; x=1793053878;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7Y7YiwpHnHRTlx4OY6pg4GKzGSuy4/quEwIOKfF9VTA=;
        b=bydubo51fbliBYMVdlZD+a8T74FXbSePI3cChGsPPg22By9YYjKSfO4XwK0/9t0b4+
         53+eeblJuKEsWNE99jJOrvfBORsGTyeMXbODJ/SU+7bSEINNg/B606TT23oocbD0a2I5
         nDaidSlorc4/ls53Tceh2z8b+YVOYqa4/RwDd+vg7SdBLB4FhxwkHR4qHyNt4wTYsBbn
         6ZL1xpajFm4nPVqnx5SQCiX8fb4jI6ApjWJzlM9lAVUtRbr3QLakNokbVAaiLaKE9O4+
         couG+POWjUq3Pnydk8v5LYBQ38GdKIKuB1i20JqjKQSlY8TUNPIcpDP2K13SajyQKQ4r
         cS6w==
X-Forwarded-Encrypted: i=1; AKwUvByUqyproA+MPi/SlrvTA4cC73APMxxWVxYuakJvDh977yal6rJpL+JUWa055MrCxLT+0KP3UYQzGg==@kvack.org
X-Gm-Message-State: AFq9FYKa8Xc1yqi++Ymmo86IfcUwtNofCwChZf7pzC3hYP+RoweEuumj
	N8h7ggKMe1HI4201B+Cg7WIGjem0RLsXIEvDpnfTyk1xRed5d8JJ/OqOkITpqOp9jiW+0mbpIXG
	nDTQAHB5ArR7BvdcCKqkKncAH15nQw0eDqvak92i1
X-Gm-Gg: AYBFou2iibmJxtSGx4bfjtd/t0B4crukCWO9fQYr3yXnO79zp3UZj1Wa3NR0gy6Hu7D
	jjtRY1gEac4wdxUlKmR7QkG8WE+BR5qPyoHjC4VfJPmCYiPMT2IUiW9jphZwt5PKsKDF/xkql+a
	dKxKMgdDS6rRN2t/9nqYb3kdRiu0RkYDBdBH3LEowvABrUwiUnaYJWkBezGpEhVaYo1Up3C5HE2
	r6EUHmkw/tNEwSEziUvaHL79AQNllNXbUSN0kMFOkQf+hU3/keSglw4T7Ph0O647jj8E2IynY8y
	DlBc12RnrHpwbe9Wk4DbBwUcRSMeAY62yUQVr1iFttLHgMd7A0Tp1wTnm5/TTSJ+/vTOPo2+78/
	d0rido1Dsq//Nf4lJTYQMSInyue9YXPu5hrEzelwOMb2oaGdUImr/1H04j2dVbutuzAkr
X-Received: by 2002:a05:701b:42cb:10b0:169:b1b1:1445 with SMTP id
 a92af1059eb24-18512e2515fmr12984330c88.31.1792449074316; Mon, 19 Oct 2026
 15:31:14 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019-bug-word-at-a-time-zeropad-kasan-v1-0-f21a3ed6a477@gmail.com>
 <20261019-bug-word-at-a-time-zeropad-kasan-v1-1-f21a3ed6a477@gmail.com>
In-Reply-To: <20261019-bug-word-at-a-time-zeropad-kasan-v1-1-f21a3ed6a477@gmail.com>
From: Marco Elver <elver@google.com>
Date: Tue, 20 Oct 2026 00:30:37 +0200
X-Gm-Features: AclHuK-9KfyXQ0m8f9CHsU2jTa1lgiXB2sNpwhyCmDMarQWZL2s0qBm4al6Ih6c
Message-ID: <CANpmjNPPncfo41Hu=TKB8cd1aFm0Lm-9+AT6pXVsYyUgFVx8TQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] word-at-a-time: check the first byte in load_unaligned_zeropad()
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-arm-kernel@lists.infradead.org, Kees Cook <kees@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Peter Collingbourne <peter@pcc.me.uk>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 05F0B1C0003
X-Stat-Signature: 4s61x5s6h5xm1iyj4bou9u14n7ryg4cp
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792449078-78557
X-HE-Meta: U2FsdGVkX19AHTuq95I4C5T1afuqJ80qW8vr7Ecb0UxooKrfiH6D13kb4p8Z4w7SEeyh7CFMhjU6ouyrEFMAD6NfKSCEoWu6j5PtyhF69FUkA/42TbdfWlrJUn7vY+kKFXedwzJ6EXCMJM7dIsaiD6yvRKnb4dtMSQgyTdHz5wl9JzDCPc6mYsGdQB+kFfhyuBkkEjcF5yfN4vO8Tg6EM40dlhAfZlNvGRdWqSugRV07XWnSq6f9PcWz8w2nr2qiaKxzpnGGvn7J7aanVSiVLAfh8fI5d46lC3dNqNw0aN23T6IBB2BNwfzTky9W3utR/f0lhUfhAIfe/cJkst3OektjL4OuoyVkI++FpW7DS8VpOtp0Rg1X/Q7B+JjHvS1eM13b1mOLegE4xCBB0MuCdx/MTovQJjWMGaheeTsKIB737wySMcDuAMtNxMHTQVwRaRJmSHrPFgP1xaUedDsRWy9JOc72Go7u6PHwQ2nStJP/VSgcAymzdDvlW6EoT2f99ZLCk79M6vJmrQ1WdvZhV//W0mWrWa7U/RV4UHGNsZtXLSt2yGsVDNyFeFfQff9LDPpjjDtCREPgpsEIgRC8KEUt20pjNLIxapSwzooxLYflYI5h5fUoSQFiG6jm6sZRI99dzuD0hUq0tBj6827pE/pP88Slae2z8fjoSXo9zWAjSVUUS4OZwrLi/ScVozcXBx5xzKrPv4A0RlfotMukvQMPo5U48T2WOTQuSLscVt8sEnZG6Qum0/vRPJEB44ZkjkYEuah0V93fuu5t/2srXUDbTnjpFoNYI5DbQKxV+8iqKJzQaEdXyXo5z/+hdzzbPcEuXqqyKydN99t0USY3ZOepu4oZkXJJO8ourEhWsaenkfCYPv/UmqLimZcVpGClIeCi4osA1THCPOtqxWIkpxSf9OM3UPN/PYIm4GTjX7moiIccFQSoahfl9E8uFmqcIu6ScO1mV0meXU/zcAk
 wOuTOGmH
 MO/zM0u8/KgIpdWCVkSC7CD3sPLi/Fx9Ie+TiDPk3LAPNyzFq57yBFRiJsAfTb9uvfjviZoa4qsEOoqsKlmlZw6bQOL/+x8h0KdMsPp7BS/d1Ei69Q7llzuSoigraozTzlY2PHN42tyS+1hBh+dxxnfNZ8+iUl/T07CgwVT8PBH7b7nQk1CpsL6vfX79QQt4dyUixhSbTvPNG+1ffmUcL2WJNF+nURsvhKUV0s2OxIrHp6/vwlHotzC2AL9+YKhUaNhPCJo2i7dxYQLDTqJDa0msypK5nLkkad0c8CC/GpK5pl4ChtSluqKghQbCRk/3//P5Q3WLUoWAR2Kz/Gh/NVddDVngij+lF6SQtzysjHCuUv1d1JGGdad43Jy1fh8fhO5NuFFvUqxmQu9z9mabF7sQqL9zSf/oVk0/Vx7g3jDU1ObgQMpY98KGqMmCANl7lOgB7FhsyZPMgT/Xz9AMs88OJM4BUX5wVkYFBCVoUlswcsoOHCckzKh5jBsy+qPG+FwxwOalm7784lxMeU48mWRxMblnio2jKh63ZnTyeY5rFmQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 at 03:58, Qiliang Yuan <odys.yuan@gmail.com> wrote:
>
> load_unaligned_zeropad() reads a word that may run into an unmapped
> page and recovers through an exception fixup. It does the word loads of
> sized_strscpy() and of the name compare in dentry_string_cmp(), path
> components in hash_name() and hashlen_string(), and the trailing bytes
> in x86's csum_partial().
>
> It is inline assembly on every architecture that implements it, so
> KASAN and KCSAN never see these loads, while read_word_at_a_time() at
> least checks the first byte of each word. A use-after-free or
> out-of-bounds read of a name handed to path lookup goes unreported, and
> so does strscpy() reading from a bad source, which the kasan_strings
> KUnit case expects to be reported. On x86_64 with generic KASAN:
>
>   KASAN and string KUnit suites      failures
>                                   before    after
>   CONFIG_FORTIFY_SOURCE=n              1        0
>   CONFIG_FORTIFY_SOURCE=y              1        0
>
> Check the first byte at the start of load_unaligned_zeropad() on every
> architecture, as read_word_at_a_time() does. All callers only load a
> word whose first byte belongs to the string or buffer they read, so
> the check does not flag their intended reads past the end. Add no-op
> stubs for the powerpc selftest that builds the header in user space.
>
> Suggested-by: Peter Collingbourne <peter@pcc.me.uk>
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>

Reviewed-by: Marco Elver <elver@google.com>

Thanks!

> ---
>  arch/arm/include/asm/word-at-a-time.h                           | 7 +++++++
>  arch/arm64/include/asm/word-at-a-time.h                         | 7 +++++++
>  arch/powerpc/include/asm/word-at-a-time.h                       | 6 ++++++
>  arch/riscv/include/asm/word-at-a-time.h                         | 6 ++++++
>  arch/s390/include/asm/word-at-a-time.h                          | 6 ++++++
>  arch/x86/include/asm/word-at-a-time.h                           | 6 ++++++
>  tools/testing/selftests/powerpc/primitives/linux/kasan-checks.h | 3 +++
>  tools/testing/selftests/powerpc/primitives/linux/kcsan-checks.h | 3 +++
>  8 files changed, 44 insertions(+)
>
> diff --git a/arch/arm/include/asm/word-at-a-time.h b/arch/arm/include/asm/word-at-a-time.h
> index 5023f98d8293d..f672aad2e30e6 100644
> --- a/arch/arm/include/asm/word-at-a-time.h
> +++ b/arch/arm/include/asm/word-at-a-time.h
> @@ -56,6 +56,9 @@ static inline unsigned long find_zero(unsigned long mask)
>  #include <asm-generic/word-at-a-time.h>
>  #endif
>
> +#include <linux/kasan-checks.h>
> +#include <linux/kcsan-checks.h>
> +
>  #ifdef CONFIG_DCACHE_WORD_ACCESS
>
>  /*
> @@ -69,6 +72,10 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
>  {
>         unsigned long ret, tmp;
>
> +       /* open-coded instrument_read(addr, 1), as in read_word_at_a_time() */
> +       kasan_check_read(addr, 1);
> +       kcsan_check_read(addr, 1);
> +
>         /* Load word from unaligned pointer addr */
>         asm(
>         "1:     ldr     %0, [%2]\n"
> diff --git a/arch/arm64/include/asm/word-at-a-time.h b/arch/arm64/include/asm/word-at-a-time.h
> index 824ca6987a516..11ecca99057aa 100644
> --- a/arch/arm64/include/asm/word-at-a-time.h
> +++ b/arch/arm64/include/asm/word-at-a-time.h
> @@ -40,6 +40,9 @@ static inline unsigned long zero_bytemask(unsigned long bits)
>  #include <asm-generic/word-at-a-time.h>
>  #endif
>
> +#include <linux/kasan-checks.h>
> +#include <linux/kcsan-checks.h>
> +
>  /*
>   * Load an unaligned word from kernel space.
>   *
> @@ -51,6 +54,10 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
>  {
>         unsigned long ret;
>
> +       /* open-coded instrument_read(addr, 1), as in read_word_at_a_time() */
> +       kasan_check_read(addr, 1);
> +       kcsan_check_read(addr, 1);
> +
>         __mte_enable_tco_async();
>
>         /* Load word from unaligned pointer addr */
> diff --git a/arch/powerpc/include/asm/word-at-a-time.h b/arch/powerpc/include/asm/word-at-a-time.h
> index 54653a8634149..49c6a1f65c493 100644
> --- a/arch/powerpc/include/asm/word-at-a-time.h
> +++ b/arch/powerpc/include/asm/word-at-a-time.h
> @@ -5,6 +5,8 @@
>   * Word-at-a-time interfaces for PowerPC.
>   */
>  #include <linux/bitops.h>
> +#include <linux/kasan-checks.h>
> +#include <linux/kcsan-checks.h>
>  #include <linux/wordpart.h>
>  #include <asm/asm-compat.h>
>  #include <asm/extable.h>
> @@ -168,6 +170,10 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
>  {
>         unsigned long ret, offset, tmp;
>
> +       /* open-coded instrument_read(addr, 1), as in read_word_at_a_time() */
> +       kasan_check_read(addr, 1);
> +       kcsan_check_read(addr, 1);
> +
>         asm(
>         "1:     " PPC_LL "%[ret], 0(%[addr])\n"
>         "2:\n"
> diff --git a/arch/riscv/include/asm/word-at-a-time.h b/arch/riscv/include/asm/word-at-a-time.h
> index 3802cda71ab7e..fb7e2904dd7fd 100644
> --- a/arch/riscv/include/asm/word-at-a-time.h
> +++ b/arch/riscv/include/asm/word-at-a-time.h
> @@ -11,6 +11,8 @@
>
>  #include <asm/asm-extable.h>
>  #include <linux/bitops.h>
> +#include <linux/kasan-checks.h>
> +#include <linux/kcsan-checks.h>
>  #include <linux/wordpart.h>
>
>  struct word_at_a_time {
> @@ -60,6 +62,10 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
>  {
>         unsigned long ret;
>
> +       /* open-coded instrument_read(addr, 1), as in read_word_at_a_time() */
> +       kasan_check_read(addr, 1);
> +       kcsan_check_read(addr, 1);
> +
>         /* Load word from unaligned pointer addr */
>         asm(
>         "1:     " REG_L " %0, %2\n"
> diff --git a/arch/s390/include/asm/word-at-a-time.h b/arch/s390/include/asm/word-at-a-time.h
> index eaa19dee76994..59393cf065964 100644
> --- a/arch/s390/include/asm/word-at-a-time.h
> +++ b/arch/s390/include/asm/word-at-a-time.h
> @@ -3,6 +3,8 @@
>  #define _ASM_WORD_AT_A_TIME_H
>
>  #include <linux/bitops.h>
> +#include <linux/kasan-checks.h>
> +#include <linux/kcsan-checks.h>
>  #include <linux/wordpart.h>
>  #include <asm/asm-extable.h>
>  #include <asm/bitsperlong.h>
> @@ -52,6 +54,10 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
>  {
>         unsigned long data;
>
> +       /* open-coded instrument_read(addr, 1), as in read_word_at_a_time() */
> +       kasan_check_read(addr, 1);
> +       kcsan_check_read(addr, 1);
> +
>         asm_inline volatile(
>                 "0:     lg      %[data],0(%[addr])\n"
>                 "1:     nopr    %%r7\n"
> diff --git a/arch/x86/include/asm/word-at-a-time.h b/arch/x86/include/asm/word-at-a-time.h
> index 422a47746657a..1319e1d87a9c4 100644
> --- a/arch/x86/include/asm/word-at-a-time.h
> +++ b/arch/x86/include/asm/word-at-a-time.h
> @@ -3,6 +3,8 @@
>  #define _ASM_WORD_AT_A_TIME_H
>
>  #include <linux/bitops.h>
> +#include <linux/kasan-checks.h>
> +#include <linux/kcsan-checks.h>
>  #include <linux/wordpart.h>
>
>  struct word_at_a_time {
> @@ -71,6 +73,10 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
>  {
>         unsigned long ret;
>
> +       /* open-coded instrument_read(addr, 1), as in read_word_at_a_time() */
> +       kasan_check_read(addr, 1);
> +       kcsan_check_read(addr, 1);
> +
>         asm volatile(
>                 "1:     mov %[mem], %[ret]\n"
>                 "2:\n"
> diff --git a/tools/testing/selftests/powerpc/primitives/linux/kasan-checks.h b/tools/testing/selftests/powerpc/primitives/linux/kasan-checks.h
> new file mode 100644
> index 0000000000000..000c92de6baf2
> --- /dev/null
> +++ b/tools/testing/selftests/powerpc/primitives/linux/kasan-checks.h
> @@ -0,0 +1,3 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* There is nothing for KASAN to check in user space. */
> +#define kasan_check_read(p, size)      ((void)(p), (void)(size))
> diff --git a/tools/testing/selftests/powerpc/primitives/linux/kcsan-checks.h b/tools/testing/selftests/powerpc/primitives/linux/kcsan-checks.h
> new file mode 100644
> index 0000000000000..39c97bc15531e
> --- /dev/null
> +++ b/tools/testing/selftests/powerpc/primitives/linux/kcsan-checks.h
> @@ -0,0 +1,3 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* There is nothing for KCSAN to check in user space. */
> +#define kcsan_check_read(p, size)      ((void)(p), (void)(size))
>
> --
> 2.43.0
>
> --
> You received this message because you are subscribed to the Google Groups "kasan-dev" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to kasan-dev+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/kasan-dev/20261019-bug-word-at-a-time-zeropad-kasan-v1-1-f21a3ed6a477%40gmail.com.

