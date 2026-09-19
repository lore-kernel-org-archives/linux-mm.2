Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 751D8C982DA
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 10:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63F8F6B0088; Sat, 19 Sep 2026 06:41:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0F96B008A; Sat, 19 Sep 2026 06:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 444786B008C; Sat, 19 Sep 2026 06:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 150086B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:41:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED32C16024F
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:41:06 +0000 (UTC)
X-FDA: 85230169332.15.966791D
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0C8BE180003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:41:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j0yuEmrn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789814465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x47tJsyRRuS9WWsrQkleNMY57Cc3HHS/YjAw1Ng37/U=;
	b=RDhn8b9drlYcWWWkUDKR87zDEImWMVp8wPWbNOYLg1+uKPbSG+aEUXnlcvTlkYysgMCVtt
	JzyJKWAqIJ6OSox6yLUAYcbsNKHtpIHaCO3FXE6Wa1vQgDIM+AOtdFbQmyDzM3zEFnMoCE
	mUiGsiy1izgrLCefL+/nUj1nXPgSPHI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789814465;
	b=BFOMJzk8iAp20FXUK4Kl82rEA580E/Rm6DVg2mwMnjbwgcFKdcXvTq4E7rWBNd9aUePJE/
	iSk36rOfxM2dhP3SmJtDPrTH6FM9Yax2TdJHT4EJAr8JqIUZQzCaA9JitAykw5Xb+rVP9S
	Px/CPFl033TEmre0H/2lILDZshMPjoU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j0yuEmrn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e721b5503so15163495e9.0
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789814463; x=1790419263; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x47tJsyRRuS9WWsrQkleNMY57Cc3HHS/YjAw1Ng37/U=;
        b=j0yuEmrnDXKdesblvdkOSZc8yKf3xvulUxKIahyL8bWyfQl2HD+e5M5cLdcEOjQ9qQ
         Ft1r/pzAaMIWLm9ZLvYO8rSg5uGtrCt1/QplrTQUXS8EJx+wUdVptzV1uaWH/3nzgJg9
         5V4k9n558U7D2uKSxvTEB6QmSdgFtGyIcP9+Smwg0iRdfuHFrb86Uz9p8ihhpRb23758
         r2h35yUCFwzacrRoORgZHVPEEcc2jGliZHOL4ZaqfL++sEaSboARJvafTixr/TOYZ0XW
         /cN4lPHQO1g57kAafGAH27SqwW/zOVqPp2avWtfGuJNfbByB4NTXq/SEnukG+pfFb4sY
         gXzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789814463; x=1790419263;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x47tJsyRRuS9WWsrQkleNMY57Cc3HHS/YjAw1Ng37/U=;
        b=HH4yVDcRy4s8O3aVzrUrhhpjSR46X5PvwDnlEF0SSujbn+IzcClEJ2poWfsywoakv2
         PWINBhEXfOEApJbmfRagmt/c3tZyWzwOJPTl5tEg2qNYtY4yECOG+kCwgtEav2uftRMi
         V6l4B0XcyOGLLjOS8kIM51JZlcyg93mkEdb8iIugOt1kTpBOtNErezqe8v/UQZMx4OgN
         AqRISsjFoRB4s/fYP6kYiW5YKOtE/5H5lIlDVK+28QbgHu/CVUnjGKzDUIXkTW7hCQeH
         U7dICcpwogF9xGWutezczfuWy2W8kthVsTk2AMHbmyf5XTsd4y+vwKdE5AF6QUFHyRSg
         zHiA==
X-Forwarded-Encrypted: i=1; AKwUvBw9rJ5+cbbRwG0H/iYuXIubPelroWl4AcOS3a3QMIDM8ypIH0KPlZcqbX58dEEwebTl0lapIoJv9Q==@kvack.org
X-Gm-Message-State: AFuF++l8QD/MG8TaOGDfKQshKESQy7LCfnzd6adyjik32610affbBPBD
	Cm8lg2E7GeBc5ZUoxysxpMm9Jb3QI2BORXzauRa0W5kYe4+rpZAppQBy
X-Gm-Gg: AYBFou21R0ElRMmTcKUrDAHDKdR8GZStNxrD9+3s/Wz0NqwDNre1kzzh3rSl7VXHN2c
	d/TfP3AU5bJRHQdmxfiY85TLJ+qXsaTuGaQ//LNgubGxUqmjl95A3XMSRbEtGhJo5VY7rrHtsf9
	xtJzaTK2TMj3O32Ndxuvs76cHMqEGzZJ2Vp7iyLIoe3dey2Y8YliKx97/cwbR/RfwtyUWNJdFnA
	cMiVYsV7dhzBijjldOE8qcsk5pBBomXmYJET7BcHC/SymDtBka5PbTQNbkP9FMEOygZhfnJzlV3
	oVhmy03g0NkHa9NKGC7X8qJ8gD8fkP4nIC757RBlfV2wDXORWoT9Ozki159GlKuPi8GsgJsfClG
	BN8XTNLKQTijgqdUfG7BJb7XPr+mxSvx1hg++99Y8SQg4XhOv8NAsDBPsXbvYRZ3lC8GZhyIOpo
	JXZCZxZu9c+FEmpGhRlc1rjvy2+q+rQBr+AwNKaOrZj+NWqB22KrbNU3yioVz43NlnL7gGQd44i
	f/eGOOxTPGsK9mZV2sUi7X+LOZz4VeFOsk=
X-Received: by 2002:a05:600c:8518:b0:49d:28c4:b304 with SMTP id 5b1f17b1804b1-49fc5741563mr73992215e9.29.1789814463336;
        Sat, 19 Sep 2026 03:41:03 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc521f5d9sm32797955e9.2.2026.09.19.03.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 03:41:03 -0700 (PDT)
Date: Sat, 19 Sep 2026 11:41:01 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes
 <linux@rasmusvillemoes.dk>, Hao Li <hao.li@linux.dev>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, Kees
 Cook <kees@kernel.org>, "Gustavo A . R . Silva" <gustavoars@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, Nathan
 Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 linux-hardening@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev
Subject: Re: [PATCH v3 1/5] slab: align ZERO_SIZE_PTR to
 ARCH_KMALLOC_MINALIGN
Message-ID: <20260919114101.34423251@pumpkin>
In-Reply-To: <20260903203720.63689-2-kmehltretter@gmail.com>
References: <20260903203720.63689-1-kmehltretter@gmail.com>
	<20260903203720.63689-2-kmehltretter@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0C8BE180003
X-Stat-Signature: 8mpi6midjbmkbokce61k8k348dhuhsrz
X-HE-Tag: 1789814464-874490
X-HE-Meta: U2FsdGVkX18w4zht7Tx6kF+WF1A7xdEa9EbEdq1u0yMe681sXfXT3NE+9I3/nTZnpBOUkpU2W6pOUhmUToSnsOxxAfPNBuiyDmd2p/cdDTJqvL/o16tWCWMRvTUcvPhFE0PRlYuMjaAFiwKgM5DHg4GLC4RRTowf+I9cnzae24yt9C8Tpnvkc81Y56biZJn8fzKrxFzAj+1GQMNPMjjKLbvQhDFBygTzIUbo3/Zlv0slblug2QqmfZUNV/MjlGdk1hSuUiAsH3UrzIPJsDWCdg0NIXEM36vD9wa+3mtfQyjsu8S2Weefg5g+LUc8qZm5mIMaKfRCs7bV9MFqsvULWYEG+eHmBZ8K9MGRueGxdN8/5XCH5vQMRMqzgNQiui6GMybHQ+xvTv4mbYa87TzSqYQB3WcRyECVue3pkTjttVl3n4wWRULTS4LsMyfJYRPM4NIRJbEFUrxhp37bnj5wLllIsTrD8/A+fhfLxXB0cF92ABo3eY1Aezdh7OJoL0mQRrJxc3WSyRTdbOZMPH1Iqxgzk4jfiS1EWmhT3x7enTQRrg0jlGLRJ/N4CuC5cnAgRAhmBfclemCbuIP3kSvXkrXHGRwFO8EGcIbkg9G5V3P3SSoEYEFlSvXwSTaqVgxC9eGtOSqYHfMMuQwTViCYzhIZPd16QMZ3jYVzpz0zc8fxcN9Qx2W1WS121L/pkEeHS9S9jnsBI6g4lHcbU7eJibi0qXgkzcE+BA4aChghLa0ionaVv3f9lDP7j7ZjYBbN5aOp/b29s3L1X7Z5+M098x8EdjA7PKCmvaR1GoJZikuWd98CO2bNCBZRs/sS2ZRn1Gdujw5XWP5SgFaNLLJ2oz9ZF6LnZNeQ+PofTJHWBmG+4eS5N7Jn+CTBYCexpsYut9NHLZ8JWIfUKkq5jlo8QMs+5iNDy+g0X6FgnI25+0FJJRtRs0YiTfyRW/4TYJE802OtemsBHSR35gOTfSD
 Hg+BdczJ
 b/7E9Only8DETyGA2xRDlxP0Bp928LsaHX8O0dlLY1AD8dIxbrnned0mnJYr/REzGH1q4f/3Tv7fo8P8SJU5FFhlLWRYkar3qAVOzMuSbuP7NZGARW1kD+PneUG5BxP0i4VYlGvMZOyQoonwDCdrPLZ6fku5XAVzDHSSiuex8vmsS7pccbpfESs8Ez8LxUX1wpfyUGXi0sCF6IR6VAXkMwrmM/jPxxN5f5GfTUsyHnSqHlPdi55XtEB3uQYYS/5XZdly35eJAUEjNARh87C2iwUccAXZWrkXfd6keh0WB+4ZE4r+QzctKpb7OhKV1KnCpPfuSpdBMXZ0do+p/jwynsS5w9p17+K3nDPePE90kTF6hOFIHCJ/igo01HjXmu3+SiZMf80c2b9gO1ssvsHkoz6rs6WzV3D0X89kIbGQlU9xMVAn61/bxKk7blNLoeH55HjdBZDnYw8WCDW9+h+D+BOHO4UszzYP4BE44073Wrf9nwHdhb4mstPR2wXPRqO6IQjdK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  3 Sep 2026 22:37:16 +0200
Karl Mehltretter <kmehltretter@gmail.com> wrote:

> The kmalloc entry points are annotated with __assume_kmalloc_alignment
> but return ZERO_SIZE_PTR, currently (void *)16, for zero-size requests.
> This violates the annotation when ARCH_KMALLOC_MINALIGN exceeds 16.
> 
> This can mislead compiler optimizations. Clang's UBSAN_ALIGNMENT detects
> the violation on armv5. GCC and Clang retain the ZERO_OR_NULL_PTR() range
> check but eliminate an exact ZERO_SIZE_PTR comparison after an annotated
> allocation.
> 
> Define ZERO_SIZE_PTR as the greater of 16 and ARCH_KMALLOC_MINALIGN,
> retaining the existing value where it is already aligned. Assert that
> ARCH_KMALLOC_MINALIGN remains below 0x100, the value of LIST_POISON1
> when POISON_POINTER_DELTA is zero, so the sentinel remains distinct
> from that poison pointer.
> 
> Fixes: 94a58c360a45 ("slab.h: sprinkle __assume_aligned attributes")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  include/linux/slab.h | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index cda126def67a..563dadc16d82 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -262,13 +262,16 @@ enum _slab_flag_bits {
>  
>  /*
>   * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
> + * It satisfies the alignment promised by __assume_kmalloc_alignment
> + * and keeps the historic value 16 where that is already aligned.
>   *
>   * Dereferencing ZERO_SIZE_PTR will lead to a distinct access fault.
>   *
>   * ZERO_SIZE_PTR can be passed to kfree though in the same way that NULL can.
>   * Both make kfree a no-op.
>   */
> -#define ZERO_SIZE_PTR ((void *)16)
> +#define ZERO_SIZE_PTR ((void *)(ARCH_KMALLOC_MINALIGN > 16 ? \
> +				ARCH_KMALLOC_MINALIGN : 16))

If ARCH_KMALLOC_MINALIGN is just a constant (I suspect it has to be)
this would be better as:
#if ARCH_KMALLOC_MINALIGN > 16
#define ZERO_SIZE_PTR ((void *)ARCH_KMALLOC_MINALIGN)
#else
#define ARCH_KMALLOC_MINALIGN ((void *)16)
#endif
to avoid bloat at all the expansions.

David

>  
>  #define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
>  				(unsigned long)ZERO_SIZE_PTR)
> @@ -625,6 +628,13 @@ static inline bool kmem_dump_obj(void *object) { return false; }
>  #define KMALLOC_SHIFT_LOW ilog2(KMALLOC_MIN_SIZE)
>  #endif
>  
> +/*
> + * Keep ZERO_SIZE_PTR at most 128, i.e. below 0x100: LIST_POISON1 is
> + * 0x100 when POISON_POINTER_DELTA is 0, and no architecture currently
> + * has an ARCH_KMALLOC_MINALIGN above 128.
> + */
> +static_assert(ARCH_KMALLOC_MINALIGN < 0x100);
> +
>  /*
>   * Setting ARCH_SLAB_MINALIGN in arch headers allows a different alignment.
>   * Intended for arches that get misalignment faults even for 64 bit integer


