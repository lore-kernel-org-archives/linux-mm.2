Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73F8AF47CB6
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 19:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1B2D6B0005; Thu,  5 Mar 2026 14:05:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C90E6B0089; Thu,  5 Mar 2026 14:05:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89DA46B008A; Thu,  5 Mar 2026 14:05:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A06B6B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:05:52 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 28FFA1A027E
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 19:05:52 +0000 (UTC)
X-FDA: 84512938944.17.63498A5
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 115C740005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 19:05:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Fuic1s1y;
	spf=pass (imf12.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772737550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DUfdbW7OxfhKiR73pKbZr0uWEl4+qEzhZGOpiUb5qj8=;
	b=450GYkHiHfMtrY9Wg9xy2YOE6Ze16T0JopiVwMUsiv6mVhjg9sag4gjR0ES4wKrbwyvcfs
	Bg3oF0a2g7l9vxbMICutKuJz+YM7DC5igC5FyDijs3CsnVbeS3W6fUb1lnWCF0ZKGN2eUY
	KEJgCzwRjuMQO8D0Wa4e68do4m8rSFQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Fuic1s1y;
	spf=pass (imf12.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772737550; a=rsa-sha256;
	cv=pass;
	b=Io6JY0KNs+h0M3ahtx1j64xYtftqwC0PJdrCo8KNBPr6q8Bh4tGoAUNtKDdYpGc9aMqLBJ
	CnCG2uXDyd6Jf/ZKRtf1EGk7bxCrdDUdjqdHKL3LIEyZY2dTjlh30q/bpC+N8WehPisWRb
	TmE+SJmMug9U8gNTz5GubGG3LmzISeQ=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-797d6bde07fso5082107b3.2
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 11:05:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772737549; cv=none;
        d=google.com; s=arc-20240605;
        b=Ne/xLpGV1huKmwN2j6fc9cCSN/Ix0hLphuIM4eS8VaS7uCtZZHxCMtXmtQFTCwOQii
         inf+ORJDlJS2RiJiZTjtgTp9aEAPLdmLbbroB6CV1lH80m15YkHId+uWP2BaxHN7q8L7
         X4zmiYxY4zjlBw2D52pn7jQBbQj9MqezCkciwctg2vRnYazktdvqX49cuzCXeuTnc1TQ
         53Um1+UA9/P4FmXu7mXcQHS1/2Q06gvv/NqfAur2kfKfXPcNSi7uepCJppza2ct0YvEO
         rQeX4sOXkDyJRk73fmNK8FASz5EhV4WaZ2nFFmtUOtMUsR1Ifk319D+ZAoI9PCVUul0D
         NOfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=DUfdbW7OxfhKiR73pKbZr0uWEl4+qEzhZGOpiUb5qj8=;
        fh=kSLuP4BoKkwoQtAPzxZPFQV5CGO1uAgWswVKCCI4Ln0=;
        b=kWtE7mfMKhknITyaioJ8B7pByq6EoASiQZOX4GPf4BGi9EiY57DDh6k1Z9/V7F0mKR
         lrOa8yMeV67o6X7mcs0gtER++bLg5kCHVHSmdmpEA/qSvH5hHbV7qUVPKOoLkivCEH+p
         vULKGN3J7wfImzQTEREvHDqU+dS2L2PV2MEUYLDwLW01MMXgPpFoaoMTObeTUgnwWWot
         Xzg6Y6q4I5Ega6c/iYxHGpIOAxNkP8SGSUmbgaK/cLkLqUHJ6FwV9UaJnHFq4MUTB1a4
         4oHD+mE1LXrLV+yVUOJTMYEicsJYFtijzaCSkz+zY110xdltNzoGaW0XIbTKyp05HRPz
         3McA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772737549; x=1773342349; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=DUfdbW7OxfhKiR73pKbZr0uWEl4+qEzhZGOpiUb5qj8=;
        b=Fuic1s1yyfKtnajSky6761nIzxxVeCZjqvVZApcbDSSi5BugzVmISLdzhkUpkq+q7+
         4NukEOhiWQQdHxiKZq2Oa+hdWrlC1C07sYH01ZWTRdLfPmRlk2GPoJgygPgmo+3BpmI4
         bZDMF49LzQGR3xBEms1s1v1mY7qgaXJaMz7GIUOxnsiMrM4fVd2vc+qw1cz79Lh3/X27
         jpgDkBzIFkQJAg9AbwVpAek3W9VC+PuRqFySbllseo+2j6Csj9tiP4MHUWTbCunZWmPN
         Ii2XD5zyjre7tARudIAKfJpJ7YzbqN+BtdbKiFxfRMqUbSgDlW8HyMomQUYEQedU2L8M
         5r5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772737549; x=1773342349;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DUfdbW7OxfhKiR73pKbZr0uWEl4+qEzhZGOpiUb5qj8=;
        b=dLTkoMOriEUw015YiJ2iY97rnSIDifH6gB9C8jtRUjAVIvbNIFqlcPruqnbJq0Xqkv
         WP/qoh/sjm8Lt4A8AvJsEmb1FOPeQbRszmrFKMgN6ujS6xhizHWKo1hte9p//y6vwFUY
         LQ8JsXYB56zdYB8mEFe0hd+Mv0Fi4f2pyjnkOqGxGK2iafaCsYxTY7PJUHDbTZu3jqMx
         piVvkS5tdaYk7rfOJN5XvGi+6rypftOC0eNEtq1pHro+b5R4KEdszkzvWfhbRjBAaSRB
         tY5UaODNY6xtk42ksElIjIXRLxiqdASh6gqRlmHbfJExszkdKD6iSDBIXxd0DY8oK27J
         4q8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUn+k2rai7TPcQQSk+wpQTS0gpYpiyx2bJQvuPuGsC3Qt3naB1YPuK7khSizWrd8dW0H1K0YR6yTA==@kvack.org
X-Gm-Message-State: AOJu0YxlqwCrR4+fLnqTEJbD2NNlczii1aHFAHr2Bpk06Aj9RpmDi5kg
	0jIfH0vQhe93GbVLeBqPUpbkLKZbe5qd9U8T7JuekRQ1L4BkJ0H+hCzGRBttebizDiiq+DyWHbG
	lumIzDmI1FCQhX76Jq8AXEuYhvmWsngU=
X-Gm-Gg: ATEYQzxH+h1n4jT4IRrbTl/jx+P9EpDfKy8+jJ3sqHsxkZTnemBvEImMQUcUnp3/lPM
	reOkZPqMYcOP869vb7SJLMgOnktxpxdyceIFdi7RIOoD568gCYojlVtJQZ+GqDumOQA84FFJr8o
	JU5D9Voj4EE9JgDcHjVm0KXvh2Qwh28z/2XI7Iqs/gaNd3py+ZZhv2iuwHEo8KZZdYmjK1t83rD
	mtVTvhP9eI4pl8fZ8KxSsmp6qGbGeITkEGFSCfaf+J3JM99qXQ8qYsUlEk1wXxcU7SDA3ehWQUj
	tgForA==
X-Received: by 2002:a05:690c:e3ca:b0:798:1de:f894 with SMTP id
 00721157ae682-798c6c843e6mr49794737b3.4.1772737548885; Thu, 05 Mar 2026
 11:05:48 -0800 (PST)
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 5 Mar 2026 13:05:48 -0600
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 5 Mar 2026 13:05:48 -0600
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <bd935d83b2fe3ddfedff052323a2b84e85061042.1770232424.git.m.wieczorretman@pm.me>
References: <cover.1770232424.git.m.wieczorretman@pm.me> <bd935d83b2fe3ddfedff052323a2b84e85061042.1770232424.git.m.wieczorretman@pm.me>
MIME-Version: 1.0
Date: Thu, 5 Mar 2026 13:05:48 -0600
X-Gm-Features: AaiRm51wLGHSZ9SaMaT4E-JYzg2vW23YHvcBblsyf-Lc9uQK9qhJFdTRUjtyx2g
Message-ID: <CAPAsAGxpHBqzppoKCrqvH0mfhEn6p0aEHR30ZifB3uv81v68EA@mail.gmail.com>
Subject: Re: [PATCH v10 01/13] kasan: sw_tags: Use arithmetic shift for shadow computation
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jan Kiszka <jan.kiszka@siemens.com>, 
	Kieran Bingham <kbingham@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>
Cc: Samuel Holland <samuel.holland@sifive.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, workflows@vger.kernel.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 115C740005
X-Stat-Signature: myyh6tq3ro4dq6drzgt4689qu4n7qhts
X-Rspam-User: 
X-HE-Tag: 1772737549-794964
X-HE-Meta: U2FsdGVkX1/gLOzQ/oeG1C11YYybBQqXwqlVJl+8AIhded+KluzWV2j7YiDjUCf5osifLnHweFYWng+QIs1z8wnYEXg2ZvqqKbZLl5sEyWJ7NdXW/1QGQ959KZoEQZUpq8fiVTaiphYiXctSHavHJ8kqcgI+wdTvskzuyj7XmSNMd7aqUc0LESZVtCe1N1bMEVSjqKndgMtX7+QVH8I1dORLv1vzbAXAuLK8q/HzNa5d1b+BDt2AZ/brZif2xrqsREVRDPbMRzHsAlYecMT0LVjwoNPvRJG50geGwBoqdM9Gd9GjsNzX2wJPdK6MiyMTMmTefpCeBHPYo9u3jroajcnbj89rjX+sUjAD30lQs3IUkYDqxCHw0ZDe364WmrTQXKaFD54SZWTXlLwMkEVWUSQXOR+dUn8jT7yYEQBYTufjjbb2lXyDSS+avuFjz0b9aNAsXKOk3aWnYApF5IFX5PRmRTn4bNeYl4Knw+WCM6LT93BJ3Pp54yHmgJI92eNZObcdrhO7Yzbxc0ynUJ4vNX76WkUcgJPYvSTbVaVVVBjdFKRXVzQ4XkkuRX9tkntXazCXOUeoqK2R/gc5SWmNmeDZ2otQZPs5KnK+Of9pFy0mJ7el5+gLtY0Kbbpr0lcsuAvmeNB6PUgAl6ya89UFdB/8L5fFtCaEV3OkpuVJ0HHNoLk1W95S1l5EfYbgoqqR1yI4/+zurUG94iR9RDZhTxkHzZLmowQF30r7bsXy7VzshuAyk7XMp/VXR/NyKVsmxanE7goNkteGi/HXPSniarr/Twj9QIlXytqrh59mhyYXNt7E+7HbOKCKj2CdLDqKJ8kBwH/CaIdj565zf9lMqy89PWNGZgvOAWQsaylh33JagFQvUIqFlL/DTxqGtWWp0p79aXljeWXyMoNJvrDbYDiAJvEfgQCrVNZNof1EdtAYTuXvO5M6ubVVVpQgwnijhOgaXvuHK+sFAlD87C0
 nLH+vjMO
 STevFIvclAh29jM3HYtfxLialDzB+gZHF4mQDqzd9so/TuLnghwbHzhZzeglqH2BisAt48cWz7znb32CPdVxIqBk0cI30+kYZ9z/PGY7GVlyVxFqDYKspjlcNokgAYbC6Z3O5uvID7nqJQEtFj0FhnvRYqwN+LGvhr9t83kNo6pDKTnw28FKpZb4zpkTlW9mCVIk3lZ54QVaBz3wcCSa3I6xCnauqR0pBQAjsnolycYF9mvFNJP+xf22W4jLJWCwFB4UlP7ZP07Ho8ym50CWI1S7sdIg1qw8Sipw3E3R9tg+2JqUqP7gGlNwhgTnt2sf86IU4Z6DIz6ftupZjoZ2iIqOI3cpvlvkPyqkNx2KAdZgBWiuo7FadDeiArlv5g/kQ82yML3HT2LMBAW5+JNEpyB3ryznyDCuV8sPE8AkgpKFjaZA0Pi2hNRCITapLVzRPTpf4dgvzb3vWM8w/AUiuV74jwt1i6Fm4QLOGVKW7uiqmoMMhezb418B1EBklb4k7/GLwSkmP8hO8bLQZrB5iTq0pc6cKOy0xwEDe6GPxYR0vhzTlBOsKbViXigqQQ9rYtII0SkLitbP43fmS0YuBWoiLqDCu8uKqLMjC7P23uF6rp9zSrYLEGfSts6KDDgPI9yOP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Maciej Wieczor-Retman <m.wieczorretman@pm.me> writes:

> --- a/mm/kasan/kasan.h
> +++ b/mm/kasan/kasan.h
> @@ -558,6 +558,13 @@ static inline bool kasan_arch_is_ready(void)	{ return true; }
>  #error kasan_arch_is_ready only works in KASAN generic outline mode!
>  #endif
>
> +#ifndef arch_kasan_non_canonical_hook
> +static inline bool arch_kasan_non_canonical_hook(unsigned long addr)
> +{
> +	return false;
> +}
> +#endif
> +
>  #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
>
>  void kasan_kunit_test_suite_start(void);
> diff --git a/mm/kasan/report.c b/mm/kasan/report.c
> index 62c01b4527eb..53152d148deb 100644
> --- a/mm/kasan/report.c
> +++ b/mm/kasan/report.c
> @@ -642,10 +642,19 @@ void kasan_non_canonical_hook(unsigned long addr)
>  	const char *bug_type;
>
>  	/*
> -	 * All addresses that came as a result of the memory-to-shadow mapping
> -	 * (even for bogus pointers) must be >= KASAN_SHADOW_OFFSET.
> +	 * For Generic KASAN, kasan_mem_to_shadow() uses the logical right shift
> +	 * and never overflows with the chosen KASAN_SHADOW_OFFSET values. Thus,
> +	 * the possible shadow addresses (even for bogus pointers) belong to a
> +	 * single contiguous region that is the result of kasan_mem_to_shadow()
> +	 * applied to the whole address space.
>  	 */
> -	if (addr < KASAN_SHADOW_OFFSET)
> +	if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
> +		if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0ULL)) ||
> +		    addr > (unsigned long)kasan_mem_to_shadow((void *)(~0ULL)))
> +			return;
> +	}
> +
> +	if (arch_kasan_non_canonical_hook(addr))
>  		return;
>

I've noticed that we currently classify bugs incorrectly in SW_TAGS
mode. I've sent the fix for it [1] :
 [1] https://lkml.kernel.org/r/20260305185659.20807-1-ryabinin.a.a@gmail.com

While at it, I was thinking whether we can make the logic above more
arch/mode agnotstic and without per-arch hooks, so I've ended up with
the following patch (it is on top of [1] fix).
I think it should work with any arch or mode and both with signed or
unsigned shifting.

diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index e804b1e1f886..1e4521b5ef14 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -640,12 +640,20 @@ void kasan_non_canonical_hook(unsigned long addr)
 {
 	unsigned long orig_addr, user_orig_addr;
 	const char *bug_type;
+	void *tagged_null = set_tag(NULL, KASAN_TAG_KERNEL);
+	void *tagged_addr = set_tag((void *)addr, KASAN_TAG_KERNEL);

 	/*
-	 * All addresses that came as a result of the memory-to-shadow mapping
-	 * (even for bogus pointers) must be >= KASAN_SHADOW_OFFSET.
+	 * Filter out addresses that cannot be shadow memory accesses generated
+	 * by the compiler.
+	 *
+	 * In SW_TAGS mode, when computing a shadow address, the compiler always
+	 * sets the kernel tag (some top bits) on the pointer *before* computing
+	 * the memory-to-shadow mapping. As a result, valid shadow addresses
+	 * are derived from tagged kernel pointers.
 	 */
-	if (addr < KASAN_SHADOW_OFFSET)
+	if (tagged_addr < kasan_mem_to_shadow(tagged_null) ||
+	    tagged_addr > kasan_mem_to_shadow((void *)(~0ULL)))
 		return;

 	orig_addr = (unsigned long)kasan_shadow_to_mem((void *)addr);
@@ -670,7 +678,7 @@ void kasan_non_canonical_hook(unsigned long addr)
 	} else if (user_orig_addr < TASK_SIZE) {
 		bug_type = "probably user-memory-access";
 		orig_addr = user_orig_addr;
-	} else if (addr_in_shadow((void *)addr))
+	} else if (addr_in_shadow(tagged_addr))
 		bug_type = "probably wild-memory-access";
 	else
 		bug_type = "maybe wild-memory-access";
-- 
2.52.0

