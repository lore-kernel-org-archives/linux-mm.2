Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9ED1C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1D436B00BC; Mon,  6 Jul 2026 10:13:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5596B00C9; Mon,  6 Jul 2026 10:13:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B4F6B00CB; Mon,  6 Jul 2026 10:13:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6072F6B00BC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:13:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C9009120424
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:13:52 +0000 (UTC)
X-FDA: 84958545504.04.13FC332
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id DCE3D4000D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:13:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GPjSKqy9;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783347230;
	b=pv1JFGpRFIIDcetPy1wfZtHttfz/3vZQzoXKr8E+fsNVDcH2riWfJ+a7aBolG6REyHG3uy
	xq+0WPW4i51kGF5UwKSDhH1y5KJMFjH+qEuLZIt987qP+O4A1qNulCDwHlrxSdm4ETiTas
	BQoGc/uQQPJFARhTbCVDMfq1FAK7qxU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GPjSKqy9;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=at7S7Pwoka+yGRXapoJaa9NfEpHgPY63ySUQLEPjbUw=;
	b=LGzkVXQ0NGnu1x97OUtvRPO3+LS+6XtZdYz737Vave7AJsHZNLHt5+4viTUVy1bj6sVW6o
	ZwXNxEF/3lg11PwsgxHk/HFS/sMZup9C+xGZyrVJeUTsr4Bws+ICySd6tuStSoD5DlvMpA
	y+UkerZKG35wfJ1O/fN3stEFcWMQ5ok=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493b1710405so18990785e9.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 07:13:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783347229; cv=none;
        d=google.com; s=arc-20260327;
        b=s8wwbFHCMr2pIkxkMIbSqmZ7a8vO6KhaT3ZcBmyjSvXtxuCWjSIBdQp3j9gwww75yr
         k3I068OgSC/Os0YGAnZH0mzwwWSV1LhUD79x2xSWt1aBOsdc3wdJJ7wUhtIMuCkMvZ3S
         RxaIjv7l79Q719FhpL0XvlgI9s2UftRPCJ2P84Wh2TznyxgsYqagdpQ/6u+w1ueB+uYG
         MVkncaUN8Ubzg+g2N5M+5qdgCbklw2dp0Yu/Xjzau9TG3IldNeEfsq2SOIDR4oqVx/Ix
         T1B4+82oWXDuaBMdgnvsnt0XSBJ4jsxqcadaOL1lt3Sfse9Bngs++8TCfZv9yLE5aoEw
         MjUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=at7S7Pwoka+yGRXapoJaa9NfEpHgPY63ySUQLEPjbUw=;
        fh=aG5ni1doLAnXHYqsPbXyhQcmBYGd5kua4CACGaFFn2M=;
        b=rojhpZIOGMJIgKmnOvnsZ/C05HC6kh3tvQ5E+x2uwekQAbMePqrcFeT84r6AzWrf2S
         AKGbvE1vMu832Ykn7GWYDDUAQTUDFAiuWEnxVjhxb1+9I6pXGY+ygAhlpHbSYbG7UGKu
         O6VQ58P00C5ST/SDKV4Te3BG7YZ1aoxY7pdePkwn75oBOYsB61rRCfZLpDAOHH3xbsv1
         Iy9cOu9aGaPsv8TYGBWluanaCRW3OdH7T9Q0Ff1pawldW8Br4MK5h6KrtsexZWFguM3n
         BwL5Uw3RE9WlnW0OXx1/T+K3BXcn4iIN8L5CpsGy8SzYgoWrZ16eOmToaNOnBwbsIMyU
         9nmA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783347229; x=1783952029; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=at7S7Pwoka+yGRXapoJaa9NfEpHgPY63ySUQLEPjbUw=;
        b=GPjSKqy9hnsQrR8yI143NRPi88FjmUTvtpdJGDvazpOlz4BNAktm+HmbX++Qzwyfkx
         z8cw7lYIaJ3OwT3sP4xwiTuoi5hP3gIEdsd1tP25l21YQYHUcivUQIZvrLnkkNVmjeH5
         MgBjlSuq10EpaAI1eAD4Fzkthw3OjKfa7vWAknxtVsky8sDd6986pA9sOpLjbwRaBVa3
         Bl8XS4Cxyw6KO+rnEa/jPafOQI6zHB+VtNrnwTXDCYTyNjqj0x4lfPhN7avozCnHCKJQ
         1V5t6MP6O3VWVJfIe9/370UvAp9z9G+bUwLn7q9ttGyHQd6PlWhUSeaZFhqGDex9ZqBs
         9ZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783347229; x=1783952029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=at7S7Pwoka+yGRXapoJaa9NfEpHgPY63ySUQLEPjbUw=;
        b=P3qhAdAMChiVTAQ5QHtC1zbmCArS824/0u0qnvbvIqJPYbtjHQX4zlEaklk7Rg9Trg
         RbjH2MENtm8VrLtI2WxthojY73SAZ8rpMZzLrJfNsG5er3Gctfi8u0g4EyC7Kkp37fVg
         +FOfl9p4cDx2azl/fuRy0DWLClmD+C6Krm/8Y6s4CSG3MQe0dl6sg22DM6K04596HnUb
         6O+jMB2umHlPUjAJxYazdBRAgVkoIl296hlQ2eFz2/f96GUJHlEDhwTaFeqwmQOXKlAh
         b/t5l4pxp6582PEXOsCAE7Pr18bQ1zkZsiBk6/lA8Z/WedMfWkjNzSbM6Og4nuMzo1Rj
         sO7g==
X-Forwarded-Encrypted: i=1; AHgh+RrCrOpnewIgTBGRLD/wgzRVgIaY8KR7lIwUB2mA5mqFJflq4zq+EKZwXskMrSFapbrU05dZ9fMbyA==@kvack.org
X-Gm-Message-State: AOJu0YzzCKJ7J82nPwB5T7rKNAQTvtPr8Z8JGFEAquaMD1PFo8B/nRCt
	DxoUKCPDyU3fMWysCP4cXR7tIN2YcsqDHr/Zd7AlG3Em7zKhOluT7TV8quL9egkbFI72xBAVi0K
	Oo4tr/plLPo1iL35+QjirZ+StaVakgmk=
X-Gm-Gg: AfdE7clo8ls40DDBlRdjp6mZ15lOhMVLOaYBwHQzrxRf0EqESKtHWcYyXNCALMNkH81
	xDMDV5bqhib9vtS/2vX0stIcOH10xXBU8vBO2UB/cCNsKJcqWP47MityEl96UCFQxvPOmkiYuHw
	Br0jMmsw8eSyaiGSvuPnlfpINOnLlb/rgjwW/hp1mLuYvEMvh7c6CGyuQBLWrMVOlWaERP+5t0B
	ibdNaVeT6fe1iMs3na3RxMdFGSC9r/SOCB0fitL2GEdlMvCgT7qmO0DrfAJEZ8RCeRsXrSIqUvl
	cLhjY2bD0RXz/hyIT4QlwSxsZipprVQ=
X-Received: by 2002:a05:600c:548d:b0:493:c76a:2363 with SMTP id
 5b1f17b1804b1-493df062bbfmr8660625e9.6.1783347229058; Mon, 06 Jul 2026
 07:13:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260704092007.3483-1-igorpetindev@gmail.com> <20260704092007.3483-2-igorpetindev@gmail.com>
In-Reply-To: <20260704092007.3483-2-igorpetindev@gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Mon, 6 Jul 2026 16:13:38 +0200
X-Gm-Features: AVVi8CfVPHeDFcwZFaPlAKFlXuuJ5cR9nM_7uUktMLaNJeE2nAjSdPSiyUYgWXg
Message-ID: <CA+fCnZfx7dpwP453aCFHNmDQ87B4EnZYGfZVbwVV8fVvfxuKZw@mail.gmail.com>
Subject: Re: [PATCH 1/3] kasan: deduplicate quarantine reduction logic
To: Igor Putko <igorpetindev@gmail.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com, 
	vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DCE3D4000D
X-Rspam-User: 
X-Stat-Signature: 5i5pnyo6ycd8u1qsuqxgeisqrerhrj83
X-Rspamd-Server: rspam03
X-HE-Tag: 1783347230-658901
X-HE-Meta: U2FsdGVkX19TCP1csFc1Mb3qj9BrVlxyK0tspsoqS7AdMvUYYLjCs3pSzpSIVj1bX0/DoV7cETP7Ek7Q59Xhv4ojjLi+QJ9Fx96fFT6PtJuEvi0Rfr1duFn10Fagd4u5V9YNLFUGBYdOFZZDtLXtzN2ICA3C2xDWwy8nBwzSQXdG6CcXaWo3yOrvSM3AwMUymfIqnYOC1/YMhVQUbMjJBB3SdfEyvgL79aQAXK++3IGpc3vOIG54T8yfZkOe82KKneJaJeVaqfZBMon1Q1DGBE1aj2o750ZFLI+vaWu/VZbAlJbKb/cynq2nCklXmx56+VCQEMTLoxFsKS8ugR1Dz1ZbOSParLueYmnDeS4KrGPhFUAqrEt9ws7ca6n5jQ5RaYfpu4evlwFzpEORCPbWWsuQ2WPxl7ALlapuzSwImTfpO8ZnPw/QpGGwjKWr3szy+vA9zwW091mbwkllxtMzLZaCNeoSc2RMJ+KSFYJ5c0HnciFk2+s+y7VU52e4wHZKuA7MavZGBqaQBoRH43YPH1vwErz7tEhjO+ILh5Xxp3/lEU4w+cVCXHa96awBMP8NuFuTxsb1DmUKEk0QZ4MrXZpF1jJh3Oq4IQTcgHFwkZNXQ08cGi4pDR12Ak8z+p+4x2+Io0nTskZ480qfZuOJ1SibR6iXH0n2I0P9l5NZZIFRxdHTPVAV4JO+7K3mMQInwlC1799kGevqhlncRpDXEm2PquE/6cVffVQ/uPrUJk8vKEr9EMwltCSQxDE96zwmnskpnnEf2hZaH+0zTBuXyHqy6G4KHRTmFv8TbNpsrt07vXHjaNHi7umuaDs53sejZUweXDKnyqjgN0NT886IB2a1MAqqKkklSy7a1F/f2CMDOlzPqLiEqW7jG0ZF8XpxGO9w5bGCjKXapHQhjek6zVxLjW3HoIKb7YzqKWDc3EX35tE3+msfL4/PeXdzOWM4++cj1KUoxnuddeSWVmU
 W6ZHeEHV
 P5skiYOIMZjMzujqvB8zp+M5w8aqYAkfdZKbF2E7cjlK/YUgaCXuFqpBBgg6SJrIG50KesEkUvT9fV0cRelafWNQY5nB3iBp4kNELdTm+BoxF9nywwNFJ1Ivt7ujYl6hHsiZLADCZU9PvqSBBACBzr639SRDEWLMdUtrn9ZTqx4hEl/H5kcUJMgg+kAHTe1volWvz6QNIqukSV20RbznJbuaixdR2j5vhney2oKNX7fA5l6/cS4WrRjdRXIq98BpCTEIVIIYPnDvFqFDYESSjpHhB35pwSNw4ozdyNxykXNYrFKP35Yph8CA+ojjLytjOd14hYdBDhW3Ct3+RYT3LyLlTEevCxWPL8Xccx8m+gBEYJ71EbkZeBSeV1OtdqDO3G61vjcxUd9VSuVYn3w2vX7BwUXBwD2eZWB/XQRSr4GZu5ZRiYKLnHMnpLEHx0dHeVsjQKzilaO11vuxE1GqnlqYgv9qFUzw9JWS4JbjIzbhObZwcyRyJ+EKHKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 4, 2026 at 11:20=E2=80=AFAM Igor Putko <igorpetindev@gmail.com>=
 wrote:
>
> Multiple allocation functions share the exact same conditional logic for
> reducing the KASAN quarantine size based on gfp flags.
> Introduce the kasan_quarantine_reduce_cond() helper to eliminate this
> boilerplate from the slab, kmalloc, kmalloc_large, and krealloc paths.
>
> Signed-off-by: Igor Putko <igorpetindev@gmail.com>
> ---
>  mm/kasan/common.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index b7d05c2a6..34aa0fdce 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -340,14 +340,19 @@ static inline void unpoison_slab_object(struct kmem=
_cache *cache, void *object,
>                 kasan_save_alloc_info(cache, object, flags);
>  }
>
> +static inline void kasan_quarantine_reduce_cond(gfp_t flags)
> +{
> +       if (gfpflags_allow_blocking(flags))
> +               kasan_quarantine_reduce();
> +}

Not sure about this change: it's hiding the condition for when
kasan_quarantine_reduce() gets to execute and does not really improve
the code readability otherwise.






> +
>  void * __must_check __kasan_slab_alloc(struct kmem_cache *cache,
>                                         void *object, gfp_t flags, bool i=
nit)
>  {
>         u8 tag;
>         void *tagged_object;
>
> -       if (gfpflags_allow_blocking(flags))
> -               kasan_quarantine_reduce();
> +       kasan_quarantine_reduce_cond(flags);
>
>         if (unlikely(object =3D=3D NULL))
>                 return NULL;
> @@ -402,8 +407,7 @@ static inline void poison_kmalloc_redzone(struct kmem=
_cache *cache,
>  void * __must_check __kasan_kmalloc(struct kmem_cache *cache, const void=
 *object,
>                                         size_t size, gfp_t flags)
>  {
> -       if (gfpflags_allow_blocking(flags))
> -               kasan_quarantine_reduce();
> +       kasan_quarantine_reduce_cond(flags);
>
>         if (unlikely(object =3D=3D NULL))
>                 return NULL;
> @@ -443,8 +447,7 @@ static inline void poison_kmalloc_large_redzone(const=
 void *ptr, size_t size,
>  void * __must_check __kasan_kmalloc_large(const void *ptr, size_t size,
>                                                 gfp_t flags)
>  {
> -       if (gfpflags_allow_blocking(flags))
> -               kasan_quarantine_reduce();
> +       kasan_quarantine_reduce_cond(flags);
>
>         if (unlikely(ptr =3D=3D NULL))
>                 return NULL;
> @@ -460,8 +463,7 @@ void * __must_check __kasan_krealloc(const void *obje=
ct, size_t size, gfp_t flag
>  {
>         struct slab *slab;
>
> -       if (gfpflags_allow_blocking(flags))
> -               kasan_quarantine_reduce();
> +       kasan_quarantine_reduce_cond(flags);
>
>         if (unlikely(object =3D=3D ZERO_SIZE_PTR))
>                 return (void *)object;
> --
> 2.47.3
>

