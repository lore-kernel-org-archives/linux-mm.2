Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FCB0EDF148
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 10:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EA496B0005; Fri, 13 Feb 2026 05:51:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 797F96B0089; Fri, 13 Feb 2026 05:51:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679946B008A; Fri, 13 Feb 2026 05:51:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5574E6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 05:51:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7E56C1C9A
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:51:09 +0000 (UTC)
X-FDA: 84439116258.15.4EB771A
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0D6AF40002
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:51:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Q4mghQap;
	spf=pass (imf01.hostedemail.com: domain of elver@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770979867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H2yjc4HwnZnDfH81aOY9V+Nb7nZlWZ+t7zlqHmmWMvI=;
	b=0Y6XN3H5m5AKtqJEIhYUHRRYX9hHhJ4KtVuo22vU7a1KXVCnQkmLNPsD9Jt3v2xUK2qTi6
	IJtsvM4d/Aygp/gYHQ430GP5JdPJkUDGivbP1mvncI6DZjt4UZ6+MuN2UVaWcsyatJhJMC
	G3fN2xvaXzSVcnr8qOzuh1wSdE5k0DI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Q4mghQap;
	spf=pass (imf01.hostedemail.com: domain of elver@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770979867; a=rsa-sha256;
	cv=pass;
	b=laEcCEJXqmKMhkBqQHQP7IhLXbBPTc6YGaG1HU8hZwnS0EOz5e1CkTwYbmDGKcqfNm1tcR
	WrcI9g2GCqMJPQBIHZ4dwQm+N1pUqaZeqr6sbTGk8S1yx1Bhlif2MRREBvICaaM8ztWhTh
	U99nc+mQCtKt5DiatxRKo5zFuAhCWlM=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-124a95e592fso538076c88.0
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:51:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770979866; cv=none;
        d=google.com; s=arc-20240605;
        b=Lwy3HkWY7acZiaTgZ0aXZNnbmqN7thJIhyi5MRES1pfjht/g9wE0lHOivioovvX/00
         5lCEjlpxdSEfmLp6BxLnafmLndQRpznsenO6b3ZLoqQju0OlRjBXUBJEj9p8lJL6Ac4k
         NspBlSMc93ypLjd3rDE9M8DCniCWXGrOSOlWe5LuAjjM3qlc6yWRMXwwHflTSj5y/X+l
         5bL/iqE/eQcCIKAYkJ8BRTkBNSfJvQtoC/HmeSg2jzA3bONxcpMG7CG4QabxLBF1BZ86
         JXQ7xEwh9HMM0GirQ3kbQkdvPq7ku4dp12XYSpamoqFcn6xZi7y7yb2VnColmbHmjyoI
         8zMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=H2yjc4HwnZnDfH81aOY9V+Nb7nZlWZ+t7zlqHmmWMvI=;
        fh=dYzE6PV/VQiZGzTGlQWIEhzBdT7NSyO0LEQomuk6kao=;
        b=c3MR5THwmj65gL9pgkOPzpBuZNh3RC3+Xw5lo6k/35hNXH+6u24hR0SRwXR3KOG8S1
         qpqlMZ9qkytkG59/OuwYig+XCCrWKAUSANTfj5BGR6GSiJrtrJmLFPPjJpOH1zrwuQKb
         hIfYcnHKdbGcfCQ3WzBbgHYaC5jspKyO8DycCnS3Xd65E5Xw1PTalOxmMdqWpAPNvCVt
         6xRUHkQ8yVHtKWLMED2tovm+Z+tKTHh/L+8F8GQlmBJduRtb39FzCGjvFFBP1UhxcZJu
         omNVJxB+g8ace75StNMH3H+nRpttOzrH3mnuel2+u/DhGfcOX9N+bzSwFuFlpgw08l3K
         5keQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770979866; x=1771584666; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H2yjc4HwnZnDfH81aOY9V+Nb7nZlWZ+t7zlqHmmWMvI=;
        b=Q4mghQap4SY05stJKmP80qTgg3PVGbRSfTx0ZR291DYTKPtYN4cvptaSkbx+UIjUaY
         G7BiWCowe7mB1mh5gtJJZE2Co7ymFxTOpUZ1EEzeHbYPdZsD+DuuGqLb8et9bfUcsGim
         9ODKkLOvwXWwJHOfJTI42Ea8cA2BOx/sb9WizbyK/5oJbpjUhM/ayQGxJ+QaMNQqgbsl
         ya2MFrsQrqH6iAwn3JREy+qDDgZjAoDsSfUSBKF9tFno9fzB5CC3kljcEfN6KglQ0DCN
         c2Rloyg/U1zPhLV2cV5j1dMfP1G2+kSmquEljttwi5lx63YVZeBzBI3zG9wQQarfxkyR
         TB8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770979866; x=1771584666;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H2yjc4HwnZnDfH81aOY9V+Nb7nZlWZ+t7zlqHmmWMvI=;
        b=fyPscHOoW3PYOucgZv3b2rXZ2w7OwN3+zk1RrI8Wcmc06H4qaZOLZs2g7zSI55MDQx
         0mdeM5mjY0v7mUKd2zZktLc4m4kTR8JX7l1C1UPWlhERhOHORfuF6i3F+jC/fakfVSCf
         z6D2VDfaoHrQ8ID1tucb471YvxFfSxeQWc8igBYzUMx9MiK5iv3I6dmQoRujzPbLzGHo
         0xoEFfq3LjLNTXsbZ4/fHkEqhoZvGRrEleLOXH6irqUj8/hLtgOS1EarO3vrHlsyRhoY
         ouz8V/duYI90Zr+tNcOivPCZB9DhgnN837Ud2HCP7dAYNsXw65AIhnlZd5ngCJUKvIWv
         tzLw==
X-Forwarded-Encrypted: i=1; AJvYcCXCXe7WNl1/oNzOTugR4zBy167lEafiZFYKCBqSIFJfvtlRqqPn1J4PUISyxsk3K40dBljhyDlyMA==@kvack.org
X-Gm-Message-State: AOJu0YyEkhT4rZavhKMeA1/e61b40SZ2Vj3N1ZCsLuFJ18sbo0hXhpba
	90UM+qHGmJ0A2Hc8aYHhs2NDTUwSRUztvdkl/gWte/fgASHyWGKa9mza22y1pUkpeTOg4efyPEk
	3e/AXHe32dhV9EZu50Zd12EZIAECgkE1S+8Gw6Sgf
X-Gm-Gg: AZuq6aJDGGR5TNiiBORqv3FjRQEcSxHgTLwsP0HCeGvpQCFDNJf2E8HHeMDbHfeGij1
	kI6SfAdqsw3YtCERFpY1U6MWsao4ugRpSCxIsBlan82UPpKNN99RqZeGH+NBirEDupjJMOp+rsO
	iyqNUky02Cv4/YGMghbayHt5uWjKu8f2wJcHIXjMa9HZz3dHbSfrsX3k9R9SUiVFB7jZtfN8n88
	Bt5hkVBQ/O0kFYj4czOaXiwuXfWq660KNpEobiMYkhPd2YB+wXqbDfUjL84IyvD5PHCoCA6QJNr
	yJ3k/EP3BLacrDxxlOtNKc93H/iyEdnTmj1efYCG3dlRJ6OvUg==
X-Received: by 2002:a05:7022:403:b0:119:e569:fbb2 with SMTP id
 a92af1059eb24-1273ae47f17mr592920c88.33.1770979865034; Fri, 13 Feb 2026
 02:51:05 -0800 (PST)
MIME-Version: 1.0
References: <20260213095410.1862978-1-glider@google.com>
In-Reply-To: <20260213095410.1862978-1-glider@google.com>
From: Marco Elver <elver@google.com>
Date: Fri, 13 Feb 2026 11:50:28 +0100
X-Gm-Features: AZwV_Qj3kSyotLTHtMF94eaTev9fGUyX13rb1GtRDWyCVZcl4zIsPhmkTtg7Z6o
Message-ID: <CANpmjNPJV-aQKnQ7Mtr6e8_12UR3C2S3abJx_ePFWmS1WV_UVg@mail.gmail.com>
Subject: Re: [PATCH v1] mm/kfence: disable KFENCE upon KASAN HW tags enablement
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, mark.rutland@arm.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, pimyn@google.com, 
	Andrey Konovalov <andreyknvl@gmail.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, 
	Ernesto Martinez Garcia <ernesto.martinezgarcia@tugraz.at>, Greg KH <gregkh@linuxfoundation.org>, 
	Kees Cook <kees@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: c6bypdrua9fsh9gdekd7b8x1phpexmu5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0D6AF40002
X-HE-Tag: 1770979866-883176
X-HE-Meta: U2FsdGVkX1+uzjjsVTE0Fgqt/N9/cjzyphLM+H2jZubDaYGi5ypoMs4coxq9lgCWn2aJGl26Jz/VCDxH6wz1r32vnt2waiY6WPeMmnoEX/7zzkyc7BNPem26Efkd/Rheb6ROhe/s9smSsqRNJjwpuFRd4n3rDHgV4vk+1Bdq+y6Ll44CGSXKzFg7qAo0FfY48UQnxgQsKKtrNnqZejDuxSnki03BIVVLWOG3EAm8fPKr4yBcIFIJuemD5GkCVHOm9fBBaxJU9tlYE92HWc/KcPgZZGJ4MrhUzvfRTv2yEoVpI1eCIcvhhc48KeE1Oq3UTIAqQgh9Hmvw4BlZf0FGR/8QML9gsch3EyD39Ot3J8ppPgoSBSghY3IXzk1KuHkzikWJyUla9t7yi/g3wFzVsNB4plRdCeIKFo666MBCpZZnKq3w9aFG4d/Lkn12jpe47d558y3yI5bIogeyIr7xC65iuYpExCV5AlvbS+DZfopsQ91t1vkvJ4hW/P2zdFN/mf3BmFxL+BrQGp3gZA+J9v+F8aj3f5u32vn/w9ZQ1hnWOeIAIOFuLk5Sewl31CF5I0vqIVktZ4LvTdw3WisRS3DGJIooXRWj/jOGQJ6MQajHdVfgusrQ3XzUZHEkcpQcjt2K4AB7XcXWRqVlQKXdbT8xaV77/TFAtkhp7EqlQYGPXLvHWQhPy7OMRqT813AXkLCucZ6l9NJc3tgq9iVOhhrVW/u27ImUeVNkfQb3fdAg+gCFSYa2LHKGO214hP4VMyGIsT31c1SeXOyeHUBu5mZP8SBfXsrMXrnrOkHvz6l7fY9Q5uk/iM7WounDZp5q4uPfFq4tIjKF5VlpdRbxZjmJVGNaLaXZWWoVb4fKCXUTsalDV2UHs/N+dw2gsKqjpMemlmDqJbLb13KVRbE/jXyY87OLkBIwDknjD0GviJZu+HOyR+cXYQBDNV5eSASmq4IRsT17LVSs/HgBp68
 QqroQ6GB
 czBYnzQq0OHLbpN2B8ANLjvhVPsNJFXRgviN5BX+F0R6a78tKdR6iT5S9lA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Feb 2026 at 10:54, Alexander Potapenko <glider@google.com> wrote:
>
> KFENCE does not currently support KASAN hardware tags. As a result, the
> two features are incompatible when enabled simultaneously.
>
> Given that MTE provides deterministic protection and KFENCE is a
> sampling-based debugging tool, prioritize the stronger hardware
> protections. Disable KFENCE initialization and free the pre-allocated
> pool if KASAN hardware tags are detected to ensure the system maintains
> the security guarantees provided by MTE.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Ernesto Martinez Garcia <ernesto.martinezgarcia@tugraz.at>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: <stable@vger.kernel.org>
> Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
> Suggested-by: Marco Elver <elver@google.com>
> Signed-off-by: Alexander Potapenko <glider@google.com>

Reviewed-by: Marco Elver <elver@google.com>

Just double-checking this is explicitly ok: If this is being skipped
enablement at boot, a user is still free to do 'echo 123 >
/sys/module/kfence/parameters/sample_interval' to re-enable KFENCE? In
my opinion, this should be allowed.

Thanks!

> ---
>  mm/kfence/core.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 4f79ec7207525..71f87072baf9b 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -13,6 +13,7 @@
>  #include <linux/hash.h>
>  #include <linux/irq_work.h>
>  #include <linux/jhash.h>
> +#include <linux/kasan-enabled.h>
>  #include <linux/kcsan-checks.h>
>  #include <linux/kfence.h>
>  #include <linux/kmemleak.h>
> @@ -911,6 +912,20 @@ void __init kfence_alloc_pool_and_metadata(void)
>         if (!kfence_sample_interval)
>                 return;
>
> +       /*
> +        * If KASAN hardware tags are enabled, disable KFENCE, because it
> +        * does not support MTE yet.
> +        */
> +       if (kasan_hw_tags_enabled()) {
> +               pr_info("disabled as KASAN HW tags are enabled\n");
> +               if (__kfence_pool) {
> +                       memblock_free(__kfence_pool, KFENCE_POOL_SIZE);
> +                       __kfence_pool = NULL;
> +               }
> +               kfence_sample_interval = 0;
> +               return;
> +       }
> +
>         /*
>          * If the pool has already been initialized by arch, there is no need to
>          * re-allocate the memory pool.
> --
> 2.53.0.273.g2a3d683680-goog
>

