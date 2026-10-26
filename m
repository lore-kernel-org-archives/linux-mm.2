Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8E5F606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=HpP/NKGz
Received: by kanga.kvack.org (Postfix)
	id E61186B05B5; Mon, 26 Oct 2026 09:09:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38156B05B6; Mon, 26 Oct 2026 09:09:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E306B05B7; Mon, 26 Oct 2026 09:09:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABCB66B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:09:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 40B1540740
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:09:36 +0000 (UTC)
X-FDA: 85364809152.27.DF13179
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4C31218000E
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:09:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="HpP/NKGz";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of elver@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793020174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LUx8uAJnT3d0+7yF1GQKbPBg3JzB/yB9ew9x+QwGKJI=;
	b=V7dHxdw8RVyrjhAtPOVoY4j2wfaexoqGhenwqwzD0r2IpJmF0na/9fzMPFXvK8sJmZkz7M
	0VUxj9gsERm6B0hTzAX0Qa5sjrJnU+l0o/MwhCVTwRXf81rH/qsLjKkfRB45fA38SMXfQJ
	+dAYUF3tb47EGJy3sLSEQSM7UJVc2YU=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="HpP/NKGz";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of elver@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793020174;
	b=xLdhlj0lyZBWbh4+gRyhsykXBTrC2iulBEC5ld1xt61EH2E+tnscO1t5c2b/pLhZR4yNEx
	4lwteXeTsLQWMLFYs6qc5KZNhTkj3eEGe6J1upYKC/NYsytGgwEDkrcEyLDEjNkIGsVWK5
	pl3HR2ZodIASo4Q9UDodsv9XSRl9sZU=
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-157fe9d771bso3517222c88.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:09:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793020173; cv=none;
        d=google.com; s=arc-20260327;
        b=ibP1taCmCHcj+EI5wOM9m4Mn3qUXY/8+s1Kh/4GZ5H98Lc6fZeJRfp34vjcDjbiGvn
         cD/jJ6yvFYF+Z7seiaolkZ4paQWUxk0Zej+qa9+00ynoiUXjcra+5yZX3ONJUQ1KGS5w
         fIi8/sXyc79LxDdV8TR5Ar1o4iocPyW2K4yASwq4oVHeYmjBLuFxzk3LAqDMewySMJKX
         mN5gHOv2HCC/5eDjfaGor1LfYhfGYTCru6JH8tvn1igJ2c6a3Lyxldh8nBPhO3aVCMzz
         zR8rNPRCmQL3ypyynnBTAXZtixxGGGJlXTiVb0298ZOyIdsaa749JAz0kQxUHOTWqZxM
         bFgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LUx8uAJnT3d0+7yF1GQKbPBg3JzB/yB9ew9x+QwGKJI=;
        fh=yOV/Ma2TIuzV6L9TdDW+JA1Yo3OEi4uayJgJZp0pKuw=;
        b=UYCUbqAmYcnkHKC4TnO9Z43bjQBqo6fQCFyuFCs3+NDCaL2c18HmZh4vIaNXaV7qYg
         qY3LFRSBsub8Gg7w/S7p29s6I8ASe4fwxDFY63otRQAzy7KDC98bPRqpK8EZO2ku1oZa
         KbfCZhMf6wYsUy/87a9KfyNO+Aijr6NaqZdbZFCng3ogByj606rcO9MEN08tzqHBABt2
         w0y86H/nkXi/je9gVJgok/4zn9jwid3BxLBvlocVnKsIewEQUenPBeuyrasSBmn25wpd
         B/d1xScHRVXuo1QhNMGYY1ompfVVK3SJiVYFZ+5aR0JulNEvHZxakHt5sSv3YAEUKKyh
         HK3w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793020173; x=1793624973; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LUx8uAJnT3d0+7yF1GQKbPBg3JzB/yB9ew9x+QwGKJI=;
        b=HpP/NKGztm+zK+tJoH7rhX7bEhGq3Q8JgiQSzM1mSLwjS+g952O0MqJ3t+A8Wx32YC
         1DjW5Rtet3vYUbC4Ij0SHP64/6/i3UWGKHbVeI8XnXRHJKhxj/26Yen/ssnSq43WBcBi
         RfA71hmN++KgQe1N8R16+prw3Qh//jlDl9nM6sZFHYUX0ywSDe3Lw/K/EFIUHH27BnMn
         Dcg8GNuWi+kCxi46RxEx4TM68lHIEC/8SfXQOT7eGJyt1nB6XUZTGWr/jEloRWSPtDUA
         xlLy4W/cDxcBnJBPuj8nmY+IyBZIz2z03RZiE/vj+qLIN2euXpRgTlpZy+H2PJWP47sF
         ppsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793020173; x=1793624973;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LUx8uAJnT3d0+7yF1GQKbPBg3JzB/yB9ew9x+QwGKJI=;
        b=WiQzLNjkDMeKitRsDZk9aw5i6Z3fE/SVT+YoWgBaTeD/7i3xeePSslQLkbtLGFRoGN
         Wyvu1fAdJ8GYBBQf66hLhxOf6eHxnC+kXrYT2A5jSjTOdJjhvt5gJ2lTJqaRW2CcB2fv
         +Rv2Uu4TARz9u4t012itglnlP8L1JrbBeMRk5E3m/NdieFIE13mXjv0OUhHU8/ZcM/eJ
         kjry1a6JRyyVRDIHvr+sZ2Bwg9+EJTWk1dkLc7b4yWKvmFdY3wH/+0v/32Tfl+tRtt0y
         iy2dCbnQkh07N0LtkfJtQhKWLj3XKBab7ix6QTiZIe8/5+B/76yxPPQLstziNf/4vPZJ
         uwNg==
X-Forwarded-Encrypted: i=1; AKwUvBy5eDeBfg3OD5AfvFkJ18aUOHhc/IqaC7ezN0KHKx3T1urZ2FxYgde56NVyMuDDPim06x4wgAZfOA==@kvack.org
X-Gm-Message-State: AFq9FYJii15VKKo09psRiQWWYSnUW/XbZLgMzwJwFOM0Ok1+mbITQIbT
	uUrZdvvyvgxndtw4MYIwz5ToGcIfZhmuaL8mYajlm2S6ChtuXRkinqGDmZf7IlhTjpxJz5/V0OC
	Ful7LO57J3cXIIB61eYoTRVvG+z30x+ozw5WEYrDI
X-Gm-Gg: AYBFou2SJE/i6LMqxqZcIPfhnyA94fGBhV/IRYY7DsuGmONxvO1pbBJQYMnW5irhgwX
	6xFoaDbp8L8Iyo9+fsVJkhkj27QfztU0MBPfbAzfjsjBChbJeEC3ptMSkB+/tTX7lvaIzwJF5z8
	xkGMnBnZsQCh95huQ+SjosehpVwEI5PH8qCIRnKGcp1Qa5jbhAvHkgC0Akyf9xX6TpIvzs+4+uQ
	Q+9KCz3WEh4K9MQbgxPAzclx4zH0TSN6IkOhFV/2XNfpfjDAPp+z+zYF5VhTMtEYJDnsE5IDRHL
	ri74ki3tNQckHPggwPdWpE/NiwzFTKr6R42eb54oKLD3gp9ccsWpdmwM80BBaOzI/XU6PFkizE8
	KjSv1T3lnsp3QtqdIFZrcMdmYbwzwY9lR0z7mlobRwVkjXOT4Z9Kh5lWw27hhxA0xXBw=
X-Received: by 2002:a05:7022:5f0c:b0:14d:c53a:f6a0 with SMTP id
 a92af1059eb24-1993580f7fcmr9793864c88.13.1793020172106; Mon, 26 Oct 2026
 06:09:32 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1793017073.git.liuyun01@kylinos.cn> <f6a6154134fd14c21070f280739acbeb5881df65.1793017074.git.liuyun01@kylinos.cn>
In-Reply-To: <f6a6154134fd14c21070f280739acbeb5881df65.1793017074.git.liuyun01@kylinos.cn>
From: Marco Elver <elver@google.com>
Date: Mon, 26 Oct 2026 14:08:54 +0100
X-Gm-Features: AclHuK9z186pdDjCz6AJnSToOjcvhVoN5e8gTK-5h4m3u7h5mXFXUG7CMtD-ppc
Message-ID: <CANpmjNMo6z0AtvxwpTCwgqvVdribB7L+WkOxQ++AH4sMegycMw@mail.gmail.com>
Subject: Re: [PATCH 1/3] kfence: fix pool cleanup on metadata allocation failure
To: Jackie Liu <liu.yun@linux.dev>
Cc: glider@google.com, dvyukov@google.com, pjw@kernel.org, alex@ghiti.fr, 
	aou@eecs.berkeley.edu, linux-riscv@lists.infradead.org, linux-mm@kvack.org, 
	kasan-dev@googlegroups.com, muchun.song@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4C31218000E
X-Stat-Signature: qr766j7w6gidzym77d81df8q6u19bb3d
X-Rspam-User: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793020174-487775
X-HE-Meta: U2FsdGVkX1/b7GVhfF9ZqsA9KJqiTFUIsF2cL+DBKCls+wENpNxzmJvmlTpVIrnwvXSQfQVTW9jLn5dq0UM4LizpJsUfpLBiFal0lkA3V7yWTpzjNZeezyEAbcikq4kBSs2u2jGFjzxdRSjX+deo8AQI+xjWFTspeAM/yo3tEIfkqMfaDdzQWB52s6ZGsUH2YyBwGieBnZA+81Kc7Tc4nqoamHHR9CmeI+HNtQ2C96rQxlOdkgjqqMAaHZMPaP5hM7VU/j5oBhNbOrItKtSmOZjI5DrmIwjemmm6GrhIq9ZigZsWNjOcRtilh0912t184hK90Jnzx7icHBBfjlu3vesWnP22AtGfmaAhz/7aWtdr1Z0pPJ8iPlpNetIIdHiJihuspvrUJFaQe2jtY+pWLnmzctBkrZ5ksRCuzkS1nHHm02TmO1njkvDr9CoHAu0Sy5Xzq3onz7COKIemKNFfRM6AfMyPiQQRDrBFKrVteiEyHagNRlvm+lDP50/AKINZMEROvMx9tVmFo99lsu9Ot7LTvUpRMEL6p+enRrgOtXsO4EsTPXLItdhOgyb5M0B1sa+s37+XkTfuIhrVJkvvNyWJEEXzEthPK96hwfjvPQnwr1iofBM5c4AlgKwq4CWm8Tpr7YSsPHLQOhnOnTNsjp9wBZyFcrBduOYVB6HxoSwl428bdh1HuW4rDDH/2OtM11X6ugKZVLgkAeNDwRs7nE88JUYzj4lHZrmCL7Lxczaa3c8+e5kdUNtJH3Bp3S6Q3jYDaVlMLP+KyLQJN/UDCykVuMVRI3P1z1ko4YByTPz8saa+V4eeMW5GsdPZfakUrNkKzHCcZbT8/RHzr/m7CuFyAOuJG5TmHt0kmyI0mrZXlnP41ea2Yp4yjFKxRmPfLvSJZTc2a+TfldBAYMHHDOEIHABY09FZcRMR93lzFTMI7lBQqzJ1NrEhcdqP1Mgz6mc8QFZ96PIH1Fjjo00
 JnF4h0fn
 qd1Ltk5YJw4kHIcKr/AT4hPEIYbRaWqju1299v5Tyd47HC7BkQa9vhrVij5y5azZXNctd9VLvU9kWU0QQWeftEgBUTHmhVsh9T8yw2zxpqSfPs7WhbfmBhpZ5lIxopy+/udwJXsFmohxzNgzjUrMDUkL9qnVco+u5L4TlvgB4gMUp7mzQ9LqovY/VzFs+twd0IYMvdTaHIHJ7oLJmPnb5lDXkW+IBs9r+LDUZ/gtwzAjGlMfxwfBQVq8udRBwQODeLjIndwlh/1Z9Pgb37gKUMvAT/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 at 13:23, Jackie Liu <liu.yun@linux.dev> wrote:
>
> From: Jackie Liu <liuyun01@kylinos.cn>
>
> kfence_init_late() saves __kfence_pool in addr before allocating the pool,
> so addr is still NULL if metadata allocation fails. The error path then
> tries to free pages using that address.
>
> Set addr after pool allocation so cleanup frees the allocated pool.
>
> Fixes: cabdf74e6b31 ("mm: kfence: allocate kfence_metadata at runtime")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>

Reviewed-by: Marco Elver <elver@google.com>

> ---
>  mm/kfence/core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 90925c646c4c..6e3d01bccdf1 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -999,7 +999,7 @@ static int kfence_init_late(void)
>  {
>         const unsigned long nr_pages_pool = KFENCE_POOL_SIZE / PAGE_SIZE;
>         const unsigned long nr_pages_meta = KFENCE_METADATA_SIZE / PAGE_SIZE;
> -       unsigned long addr = (unsigned long)__kfence_pool;
> +       unsigned long addr;
>         unsigned long free_size = KFENCE_POOL_SIZE;
>         int err = -ENOMEM;
>
> @@ -1032,6 +1032,7 @@ static int kfence_init_late(void)
>                                                  GFP_KERNEL | __GFP_SKIP_KASAN);
>  #endif
>
> +       addr = (unsigned long)__kfence_pool;
>         if (!kfence_metadata_init)
>                 goto free_pool;
>
> --
> 2.56.0
>

