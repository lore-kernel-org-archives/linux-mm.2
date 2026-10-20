Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 966E760A2618
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 16:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=n+EZMxVN
Received: by kanga.kvack.org (Postfix)
	id BD7806B0173; Tue, 20 Oct 2026 12:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAE4F6B052B; Tue, 20 Oct 2026 12:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC3906B052D; Tue, 20 Oct 2026 12:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83C706B0173
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:58:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF53A1602B3
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:58:57 +0000 (UTC)
X-FDA: 85343614314.14.832587E
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id F1A76100007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:58:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n+EZMxVN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792515535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W3UZs72ItN8BjuPnBCdirt6JsCzxyYkOlT58mDePWJs=;
	b=DqOdR/me19SySwn7KmEWO41y/FMx+ryxYaCnBYoUYlkLX1TNKFSU4xUltz92Nh2UmW3ovm
	GEzvrKUQk1pW9GLThZq5NARoPhWdGHjJ+4m2Z5VJIFsApC3Rv6efOSKRQDy4gEN9N/CRyP
	MgFOn2DmFhcEDZ4cb6Fn1HhIpTEOcYw=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n+EZMxVN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792515535;
	b=qa24HhyiU+QSXh/d4mLz4f0bbToz473OO6Br8/lGv/YQEscoxhIfq9NxzOyQS1s2tNyZub
	b7n+rWHVilF/5M4jcR+ztiUcOk4U8i0IvR0+9kbnnb8hicVhcxUAJUFU8nX8Bh6/7ThZ7A
	a0qbRcnEIEeFyiy1YYHYASMnMkIr7+g=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-66c54dc3a91so461437d50.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:58:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792515535; cv=none;
        d=google.com; s=arc-20260327;
        b=lyhlrw0YYg9M6ziEpZucb1ga8RAsXN2RVpAl3G+J7BYmI2sCeHo6IsfVLYj2l7BYRE
         cEUwS6lFzAUXicxgCgkjQFJlAGxKuBQGhx3noY1CLAC2B75eh8ciSrlTKnJYLiYsuB1m
         g3+EaP/9gTYndGdYJlEyGRKcpRpwdOa1H/HW1g8dJCDD6qnUCjoi/oZXh3Q9jnImXBfD
         4IP8jto3/wqlLOnBX8mu5eNKMXaLZVKvNDIP0YRm/QqXa5T+OJ2LwLzKExr7yo3XiR01
         FtuRylsxSvP3ClZaK94wTYpHiE3kgrict0aENIZbZ8iQS0W82tuxGjKA3pODedBjnpxp
         iQ0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=W3UZs72ItN8BjuPnBCdirt6JsCzxyYkOlT58mDePWJs=;
        fh=FoBuObcpY46YjbApxNlQfdWCW7BkBNGmzr/5nMphsHQ=;
        b=r/H+OXbp/sTMAEDJCVvh3W2s7fB9qagPhCZUBTQq3DiJ9/V9AuBfP1PRr5jz79iSA5
         0t81/Spg1L+dmSEh+imEGYlHM8Uqpuuk4hnwM0eSW196zHqGYkWz8LcTlHrKzTStdzTf
         yzMlC1KMklP7ilD3SWFIzMNbzwB9S8SvdQKiS558L7cQCT/NRHsQoOxMfblreue6YeQu
         /bt+lpyhL+0S1Lludl6eM67JflvRJsOebajjr/HxfknGm8/e4LXm5i9jcZ8lJqnqL1PK
         cBHf+/YGiwCWh5WK3pTFVrB8iASiNI92+OPUp4G96Aofpq8mfCBRzVgM7mSF+AMPVSHQ
         l4BA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792515535; x=1793120335; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W3UZs72ItN8BjuPnBCdirt6JsCzxyYkOlT58mDePWJs=;
        b=n+EZMxVN2Voh2fPnS/RKHJuBgNddSniRT1C6W1KE7+68QoXdhwvmRNM77sXNGvdvWx
         27QwUF78VkeRoYClVRqviUSRNu+6olcGPaL7RqaKYfDeRflHxhOvXVNhGRBRDO0tF7wD
         rh5P5vFYHbzFD8nKufyHuA7qhjCpzkYHxtfBeS4D1jOIJ4Wk+ohRHiDuu991ZX7LiII3
         9lJG1YgV23TNUnQPxwwVfVNJriiJ8fF1WtEUr9e1uB0BFR3bF8I0kR7QzA2TY5upKOXV
         FGx37BZZVRJ2ieB0LRlDVChgo7y8rHQIjTbxrmeSX7YJNPaURvuDj/ArdQcNbJvntvjU
         NMsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792515535; x=1793120335;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W3UZs72ItN8BjuPnBCdirt6JsCzxyYkOlT58mDePWJs=;
        b=C3j2TAgNAor/1Dp5OxrY/1klQ+nEekP7dcjvCf98V6iEtOedyZ8Ly3Mcp55NO+XPRK
         2RAzmWTxpPycpEnb2fUWCSQ0r0B8tGOma+Eom24/ZShYW2aPd9lQw+jEBhaz7t4KeBU1
         LOCThCPdSwRTRA1Zdrjls4OvDqkKcesLDxPD7KdWLWczgKMdrkcrJ1u+t3xq+/P4Zikg
         6XqYtSKihgZjvSNg8Sv4oem1U6tXBic9mgy56u/CJrQCIDUSTWeIVOaWYdKAR3cqF7QU
         I3J+9i8GYQcMAqYjFMwQIyCKvNsN9MgH8KRvKZCs1HjS0tRN2Wfd99wGXiSI4oOrrK5g
         4iPQ==
X-Forwarded-Encrypted: i=1; AKwUvBxrZXyMTzX1UFETLNAFJONZ/u7H5V0T6v8YGOoOwxa9VDxgOF/Q8RCUBfsl04sDSr2IPO8cDNbMbg==@kvack.org
X-Gm-Message-State: AFq9FYKnxhlUU2JTT0DctZED+QC3mlGKg6jC6ZNSmVd8j4+FhZsiOmGS
	B3hCZ75KliL6WDVuK43ach6937NjsnWkTSrp2gHtgPGeL7alpqehuoaM/zX5mMKZOGm4Nl3fYP1
	rHsHmt5nKJSoRFTH++bwekx5Om+AA5mY=
X-Gm-Gg: AYBFou3a90yfZr5Gj9+HJRbbqxWOeb8QGl9hGgRagv7i63ukLQH2w+tHobJPpxWS9WH
	iv3SBU226xgt8DQwHHq1bh8ilvbF5YlFSB2vdZQ+lvLrHKsz2/71asA0gqoTdur0J4++3toC2Y+
	THG9bAxqrd9hLnLUrrQBRN4UaEy2WlagyIvQ+7YSJPlH9B72e2LicX1CAz/I+YP0JaWuqpL1f/i
	1Dn1cmKwbN8E7E8wb//OlRPdtUl94qtzDkvczroGx+klMBDaM2+1eQfc8tRwILMmlMyTI5e0O/M
	Dh+u9Du8IT/s4EaFzOtRr1KlSe6O9YXRv5v/tn13BkXRZjPhJ2g+uQ==
X-Received: by 2002:a05:690e:138a:b0:679:b8df:29c with SMTP id
 956f58d0204a3-679ca54432bmr6769731d50.2.1792515534972; Tue, 20 Oct 2026
 09:58:54 -0700 (PDT)
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 20 Oct 2026 12:58:54 -0400
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 20 Oct 2026 12:58:54 -0400
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20261019-bug-word-at-a-time-zeropad-kasan-v1-1-f21a3ed6a477@gmail.com>
References: <20261019-bug-word-at-a-time-zeropad-kasan-v1-0-f21a3ed6a477@gmail.com>
 <20261019-bug-word-at-a-time-zeropad-kasan-v1-1-f21a3ed6a477@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Tue, 20 Oct 2026 12:58:54 -0400
X-Gm-Features: AclHuK_J27k-o8Ui6g8e3q8L_DReW_3vhUszXOZ3Ua6MjDZ1MkwzX1wkuw839aA
Message-ID: <CAPAsAGyrH1quaLuyui6Qm5sokid8=yjNbAM3cOunynfPNQtfgg@mail.gmail.com>
Subject: Re: [PATCH 1/2] word-at-a-time: check the first byte in load_unaligned_zeropad()
To: Qiliang Yuan <odys.yuan@gmail.com>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, Marco Elver <elver@google.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, Kees Cook <kees@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Peter Collingbourne <peter@pcc.me.uk>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: F1A76100007
X-Stat-Signature: jeio73bxagtz3btbtk83n5tc6gjrbwqa
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792515535-295678
X-HE-Meta: U2FsdGVkX1+dvFDB96hd1qyXeDPaf+ZM+SCEoW01WmxqTHTuZPPlk8Jro+mS5gw/wxn+2vioedpTe7mpdv2YDZQKGC3WaBiS1/aF+F+HdvGnZ3IfRonaC64tMN+KCgWIh/5k7bnf42g+0mi/NbT4f2Rwzs0dqZ0GdqP3dSqPp3sJPhnbcO0k6INxC3cOu5/lJmJ05j8xgoii5cQW6ucWq/4bEE42+jn/ulHNVMgRH4nw7MvSuueKmOBE6AXF4K5tGn5KuXXaXlcFGGXmWeesLv2wBSWLV8cusu/jnY5wbrhbKL2AVs4lFstXsZIylTELBCbqS/wlseWUWWTQ7KvEdoQr1wG2jpTRlJc1gpF9dhw10NGdFeF2RxRgNnBHJE5lr5b3eROCtmguIQiZkuoYiUdAFVkuA4fK3suEXo7j8HQpv96GQ36Ll5JH1Br8bwgNVmeep70R2EAIA+0R27/vE125ygpuub6owHlQ80NcKqUKDmViOgkglDLHjyaR45pxFAP6ItUcJsi7riOnSGUCXwm3ln8yzgP9mrqR4cbn04tmLPKoDoa+rCY8wvJJwBB4mWGKOgxfMtnVCB00qw+C/GIskySPndjW6nU6HpFYUq0QsPgEZYzavd9IkBHzEs1+tSRiuA9BCiovhBgOB3mA84mWImY/cMvmgllzXzAIIS6V7EXoY61oS45WqvJxHdKe62Q3aQsqxAP9etDB2XOJfhnF8gV5ZGKfB3att3FAdGgOesM2f1QlJfyl5bVXps1QxzkEy39kp99PxJ7R385MojCefI2TEkwDxoTXKNOCwNmWFydo8TpvRibTawHrdlh6RRBjzgOT1g8cLDE97EDw0tkErXOaF2MXikpI5wNB3pREflJUZxqO4nZTmqlqEPAOGnfb7RBH6AtZ8L3sNcjRl2jHVHZGICU6LA0Xo24a7tqMTQA8/tiSKt+KcrtJNDJvX/x+QSeW5Ruas2+5VNX
 FtOLAByu
 +pjQi7N+aSQ+sSSMw8yiKztgru3tXGD577lKy6aXYmnbGqaQjuI3lDCTj9Gss2FNEZHeYqswFb8Zr10FBxYrxXvOAnbLbK4VkwVUulDwEe6T8Xa/Tta2xObzS/rt7XDdm8FahgDgh4j2qPKNFslrImWxanv6Jesnj79g8SGafx0dSjmxB1t5rllWWIGoBAc31bOGSwnCgvucWMdzNrS1MmBADk1YK8gc4qmkgpSEN9pKyDDNyMBR7AziLcxfwUrYFd1h87TmtIoeo18x3rbk/rywd4Y8dLT9mc4mbgbrYNJhef4y4z8aEKPgGzF+r+bI8t0gZqNOPRifm0HQx8p3fnSJdgwDiXkBWotnmyK+F/v0ApTh+N6Ze+/jTY/9gK5JpJEUDMYYLXxGmCI1rxSPwAP7oIWYU60WukYArVLVjWRggHBIbu+0y33zWf6i10Tu4GQnLt270uIs7nICx4hC9dbgtq3Bodp9tEsgn796ak1d9uQYYLqTBcSFdnVNV9Dh/7EA9lDCxaDr+KXCJEOmDXEf2X+H/2sVP59MZzVydNCBC1eyP8kYV+qLyDQC65oa2IPfjvP9WnF0JkjAOO5I9cX46jEOqHHK4W+hu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Qiliang Yuan <odys.yuan@gmail.com> writes:

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
>  	unsigned long ret, tmp;
>
> +	/* open-coded instrument_read(addr, 1), as in read_word_at_a_time() */

Why it's open-coded ?

> +	kasan_check_read(addr, 1);
> +	kcsan_check_read(addr, 1);
> +
>  	/* Load word from unaligned pointer addr */
>  	asm(
>  	"1:	ldr	%0, [%2]\n"

