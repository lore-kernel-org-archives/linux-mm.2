Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B947E606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=qAHYOZj7
Received: by kanga.kvack.org (Postfix)
	id D8E696B05B0; Mon, 16 Nov 2026 02:00:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D662E6B05B1; Mon, 16 Nov 2026 02:00:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7BFD6B05B3; Mon, 16 Nov 2026 02:00:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DFF46B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:00:31 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38C481608A5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:00:31 +0000 (UTC)
X-FDA: 85440083862.09.A8877CE
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2EFC680009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:00:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=qAHYOZj7;
	spf=pass (imf30.hostedemail.com: domain of elver@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794812429;
	b=q9S/kfltqO6joACWkIrpV+RQISBF+RD+9/h0WaDnUjFSz00iGaJ4CdUxMpqYFOV+8FAzh9
	IzJKpbJwljI1gN9aNizEtMoAqsteFc1FrWfp6hvRQ+zc6NfNmn0AxLSRLRmXVEcujZPi73
	CknqspJAO5GtU2E9fcH1apP2ZZdWyUw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=qAHYOZj7;
	spf=pass (imf30.hostedemail.com: domain of elver@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794812429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5s1cMjlhSVoN+8pwAodz8Vnb1Cd7Y7PNKE3ORLQFJUQ=;
	b=UWsthrJdrETp11iJ+UirtSsU2ZQ3j/7PMHgZ2sOcuHY1J/3jl+2/AqajqvJpAjHQbCk2pW
	OLJseOopjf+v5TumPfV2CE42rsxTZ7+gDH6vYLzqL0S77msY1rKjvvlpqyoH2yrkB33Nmf
	HyJmNQ4ldYC107ePvSO7aepmbtrzCQo=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1b3beeaf6f9so3457342c88.0
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:00:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794812428; cv=none;
        d=google.com; s=arc-20260327;
        b=JgrpEh5weHsfhndeGc3RgXe1HWg7YtUqQ2cqTqs8dfvRoa6/TTCnRk91hB6jWVah1u
         cScPUs22vSLTQGN8GfOQzketNAgPrGBs2DtU1aSC7Qan/We4cLX/3P7TK+XsmgxG0wu7
         rmh0EwzuBOlIIrg/FoNmKxcdC5+Shvi7qH3q6AiN4lWSm2CzyQcK878KREsd2pTIgJ9N
         Ir/2UjTEJoS2jZZbX53yMlHR3SO/vffB9PxOYAXgEVsAAFifHbdgUaB4vmBENh2IAtSm
         L58zrwoPQtJRWcFwou/gpelA7gxN7P/W+G3Dy/tbHfweaCfUGI7m9qzMcuQSFeXfYNtL
         WNZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5s1cMjlhSVoN+8pwAodz8Vnb1Cd7Y7PNKE3ORLQFJUQ=;
        fh=+WS2Mc4lAT998JDgaV2evoHvEGngHyaE27cjFIiZY9E=;
        b=MWZewkHy3mWOuHKksF91qG3DpvdcfmnRnZ6Jf3f2Qn729SqS1xidHoJl2CYr2pmYvd
         prbl8IPfMdjxkFMdRk+NxlHAA3jvMFXnd6zuuKruwdnFNMCkJclLeZE9s4H4qQrGMDzB
         rWOGtTHYsBZ59NppZld79Y3mGQulQsz1g+/dPshwSyhyD38vNiaSMNbeJ+g2wHBcVMw6
         m3TdvvJFmJfGeyA/QukImmqu3TktD9t4aZarbiuJix7SC9m0y3kPA6YhgP2wWaFOpsYw
         IJDdN4fLCVpTpnX5pjbkC58j4pFb/QTpYA3TU4wFbFY5NjPl145714uowzFZpV02b+yy
         aEfg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794812428; x=1795417228; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5s1cMjlhSVoN+8pwAodz8Vnb1Cd7Y7PNKE3ORLQFJUQ=;
        b=qAHYOZj7xTwIoJcF0fPKp8sNvv3TbRmemVar2CCGVuR+DHbyYthu79iTqPZYsTkZ+h
         C7HnKVCmiM1AhzmU0DcEYQcjuG+cZjEPgpLJmt7agmj5Iii4D2Z9vWUeSmTihDceQYU2
         n5Syk7hD4svy/OiSqkATATXwx/SXffa958TJ3fHkgyM4A10WnVGUvPCMMfMyhMAUVHnU
         Aa/8oPS1xL8p9nLwjN9eejOsNSa8dw/8QnT0HLlnxUZD75QUs4xVm8+oxEWQu6LA4Xvb
         tsefHjGDyG/UO/4Ur1E6RFHgzi0fE6GOrcVcYvHqOQWAUyO5EtKmws1KC7IHwwEqswzc
         WWPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794812428; x=1795417228;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5s1cMjlhSVoN+8pwAodz8Vnb1Cd7Y7PNKE3ORLQFJUQ=;
        b=KiDPBbAHaD/PK//zsKpkT0xSTyW52NH8JvMEw1mL1sNfMb72e3z3iVRSRcZAx50pK8
         z3TCPnzLjThSQnbdpyPQzyup1qhkTJWZCRAjhY/CpzcGRpRvJwlgyPReJ1aWmSiDCPRp
         tRi96M9t17dm59XXF0zuiqGIGCh7wj1IM8Y10uwm3N2BQmW61XlC5tsf4HlGgCFIxWTy
         h10q98cmEjSRV8wMiJRT74yUOREJ1dijL5SFmdFlyzbwuzlp4jNomz4AF66B5V6FPcMv
         7LxaURU4UqTXwysjCAeirh2MpDIeT3C8HjLr+i/9kHW+h4QK+0vElHttG9G4BSWhKK2K
         yiOQ==
X-Forwarded-Encrypted: i=1; AL+hErGcdRiHmGJVbKoJ0XQkg+TJrD9GH9WYRnxEDqbno5r2tU4j3+g2J8D9sJatIQ4tyxbnMt5QHxJJ/Q==@kvack.org
X-Gm-Message-State: APuU4Z+i3NMRosUETZ5ovfjzA10adeek5VVlPRJhtZgh5FrLYxX9JFHO
	J/TFHfIB4ZLuEZtBQkYrQYWwTtKtecPz2xj2RwAU9Fp1bo6tEo0/V/hfvnKglYB7f5dGLzaf7/q
	bnmAhn03HD4fXGgI7aMBkV9BxZpyO+T8Jor8BtwuQ
X-Gm-Gg: AYBFou0xoef99f/eTB0T0lT+a2Ox3V1E0WQGyzlm56vXL80Lw7xyB3VY2F/wifIK7Ad
	y2aOHm8f9bJkM+VzdQgV+k72ZltbNwqMWUfgjnUTG3AE7EjURw8+5dQr0BN5Zy0aSTYcgH+6KTZ
	3dycdhB0HLNXHmEeZdRbW4lDzRU6ecGUiJcUVZhYH3i2VgTIQGqF0ygDjK57mnGbL5iAKGb/QG/
	GzUwbtBIKK6GXfNKVoTmPjvPIOIfGqx9gASYMQEFIX+TKHiCF073HHwVsBbXYxiRH5vlXoG5L+u
	eW2yVV8umCcWu+2NBH25laKC4yK4gERv3+dwjT9A/aoPqRl1r5f93/RBYNlthqP14zMm4tYOaFA
	/aBQPwvkDszNaqQz59gBdMv9hrpB/06ZuvqR2kvLvVFRomQkFe7/0wwgeRRggu8x14wFb
X-Received: by 2002:a05:7022:3a03:b0:1b3:755a:ec49 with SMTP id
 a92af1059eb24-1b503157e74mr10651080c88.40.1794812426897; Sun, 15 Nov 2026
 23:00:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <auA7FdubFEDVPB7v@chrisdown.name> <CANpmjNMunLgXHRqXgW3LnniCX50CLbLYsE3DpY7h=cuvu2vSkA@mail.gmail.com>
 <20261114150201.d428c3847d573be1@chrisdown.name>
In-Reply-To: <20261114150201.d428c3847d573be1@chrisdown.name>
From: Marco Elver <elver@google.com>
Date: Mon, 16 Nov 2026 08:00:00 +0100
X-Gm-Features: AclHuK-F0k1P_2O2E2wygaMki6BhhjUtxnekVFOvFTlkQiN3eI7cLbmv5yhD7oA
Message-ID: <CANpmjNNwaeFmVxfPsvdVSc33_DoF_Gcz9DpjGWf6PLD_GZwAyw@mail.gmail.com>
Subject: Re: [PATCH] kfence: Allow selecting static keys mode at boot
To: Chris Down <chris@chrisdown.name>
Cc: Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2EFC680009
X-Stat-Signature: uthbj9oo3b547rkm1wsgagkyf6e6h9ss
X-Rspam-User: 
X-HE-Tag: 1794812429-196005
X-HE-Meta: U2FsdGVkX18b+6RyAwWmnyzvCluB8bE91iZ8JhjARNq2ewFt+lyBc+zA2f+Pdl88W4b85SknRVir3Yn5WBHoFG0VmtSEeHJE549rdBRu5jKI3G90PY4/FKgbp+7IhL+rL0VIzRzI8DDtU+dflcxPIMu1XGmq/FCiPStcbvhzMzXXwaK/FvVlhYhwbU7zA2+5uvSUwarl+5qFM3FYzwrLuzHTVYc8Pli5CBEhWKfxhAJp1OLo3rvVgIShuorHNH6MZrGb7ofMuRp2BMD8hmBC9UDH9asvBxD/ZZ2Bd4cxEc1rf3KjWHd+AdNxSiIsfQs0QQczesLl7MKzlPlvpVN/hV355tPutJNjycz82x4Hd1sGANya0FOJSC6XlAZtMkcmiqdDCAioyWTlzxlotCGCcFPQRUXB85vPzN2a0y1BiXTkkf01nv8gaqIxXOllH0EtGPVLiepxan9ooCvClirKA0ZyUyRHJSPxvGPO1el+ffOPFlVE62sYlzDBytQb7N/jncIirvkbJqi7R9Prry7rYIEuxAheBShhhGMM0GIFJUziw7Az23Z0xAI6d3W6RW8A88rM5kbEixwygDVI6+Bh+/s8XO0tDxLBj56kZz3FZ0ceik5z0hN/Xa1O0tWxk+pSmj5WKJY7TKmkHXpuE35LkzQZPIbQrcnzoZCI4SnCF/Cr8vXFEzd15zzvvBjRiu87r6TTwIIzIuisZT4sIIw8ypLZN5GaikN9OA1/p0PSVDXL2Ta94SVq4u2uewM+jHwDbOyMQUyFEFS9PMW3MBugjr6DAE/7pAv5NydQ3VlkSkjzY3wfh/BNKk2vqbQg6bMU0HLj2Aa1Fx8r35Ah53V6Un0prgjdyGfkzI/X4/GfA8NUsuROIAK/rWJY/e9dcSmYmNVCBf5TR8TzK5GzKUypn04vriXvTYmA+g4Sv06Sb71vMmEe2WkbixTAvFsLzrNCrrwf4cZ4f1M1+3x7cmT
 88viYLXp
 SPYg4k5Eip2BUzipN7kMiPXOiQx03zbzfpVxVUOi4KB/ycUkYDt/4/tuXWuknJPy7DQhz9XQoZkAYTT79hjNsPDocCBOimSGs6Uk67Nk1dfO9mKEBjGwbz+LfF8zCos8Sj7hoZXkcroWaQYIGlnBDFPNJsUPjdsydxs7FwnwrC7k2rWPeksz7WNd5+j0rncfHtmFkoRt8xpF2VqJRmTXLec6crbFtmS+T43Vj2RZ8izcKgxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 15 Nov 2026 at 00:02, Chris Down <chris@chrisdown.name> wrote:
>
> Hi Marco,
>
> Marco Elver writes:
> >On which systems have you found static keys to provide a significant
> >improvement? Can you share benchmarks?
>
> I don't have numbers that show a significant improvement. To be clear,
> the hosts that use static keys have had it set that way since long
> before I started looking at this, so it may well just be cargo culted
> by now :-) Given that, I had a go at measuring the saving on its own.
> It's there, but it's small.
>
>  From a quick check I did in an 8 CPU x86 VM, a
> kmem_cache_alloc()/kmem_cache_free() pair takes 8.0ns in static keys
> mode, which is the same as with KFENCE off. With the dynamic branch it
> takes 8.4ns. A kmalloc()/kfree() pair takes 13.3ns in all three. Both
> are the same with either branch layout.
>
> So static keys saves about half a nanosecond per allocation at best, in
> a loop that does nothing else. At a million allocations a second on a
> CPU, that accounts for 0.05% of it.

Thanks for the investigation. On x86 I thought as much; I'm just not
entirely sure about other architectures, and before deletion, that
might need some investigation.

> >IMHO, I was thinking of deleting the CONFIG_KFENCE_STATIC_KEYS mode,
> >because on most systems, it's not worth the complexity for the small
> >(if any) performance improvement anymore.
>
> I agree, and I think the numbers above are enough evidence for that.
> Deleting it is better than this patch, because all we want is one kernel
> across the fleet, and that gets us there with less code. I'm happy to
> send the removal, if you'd like.

While eventual deletion would be my preference, what you say here
doesn't make sense. "One kernel across the fleet" does not necessitate
deleting this Kconfig option from the upstream kernel. You control
your .config, and the Kconfig option is default-off nor is anyone
forced to enable it.

An intermediate step would be to e.g. not make
CONFIG_KFENCE_STATIC_KEYS selectable on certain architectures where we
are sure it causes more problems (global IPIs on systems with 100s of
CPUs) than performance improvements. We could do that for x86, and I'd
Ack that right away.

