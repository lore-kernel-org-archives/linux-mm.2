Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE306D43360
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 23:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 019936B0005; Thu, 11 Dec 2025 18:25:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09BC6B0006; Thu, 11 Dec 2025 18:25:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF8256B0007; Thu, 11 Dec 2025 18:25:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C8B5C6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 18:25:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 683DDB8920
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 23:25:35 +0000 (UTC)
X-FDA: 84208774230.27.8465860
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5163D2000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 23:25:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=toTxqqJ6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765495533; a=rsa-sha256;
	cv=pass;
	b=ds7SGP1WM/rrwoPLctyvxJiAYFeXQrhXDL9rplBCnhApSve+AEyhvxUymJUni5somngrIR
	mGC2SPZr3/B8HDYBQhBVwVIVEN0Crt5S80EL5pXMKufxvIoP05+trHihM288mmSMFCso9x
	z9R9GQhNdTZUv1E8K/QbTFUZdGr8g48=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=toTxqqJ6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765495533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NgAS2i+WuabPCqxlCGTGd0RyAlQOwBDUG294JndQ1+g=;
	b=jeprn9PF5mPwN0NpTevb+Rk4L16dkRihCZgwLlipGtEgdWDC7JbHlA/WTcC/vDHXxwOk3I
	bb74hPjGizmOhSx2p4vDnINzxbX+IBtkZAyc+723KZmmFZvhJb/kgQ1PidWCYYuyyqYOCq
	6gV7pIXlhuMY4BiwMzdiFfXEyGq5LtA=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4779e2ac121so113395e9.1
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:25:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765495532; cv=none;
        d=google.com; s=arc-20240605;
        b=MIHta4CPTp27iS4gpSbaQaZgJqix0xIQDVZzJfb1W4RN7JK7XL53R2SaydwlhTget5
         g7sYOfTg1v0ZYTzPwwqjAoTOH1jOLBdIdGxET6woj1sk2eqdKcoxh66+89gwrqo/QeqU
         Jurs8kpNOOzvedQNwni1PiQvMVWF0tGiN+okYzdcT2ZQe0dEn3DSeEIsIqgFhTraZQG3
         pHbmu4NTd/A52Z6PgvznWOEVATNwP3hukx/wO7SPXrIb28JzkpYd9JuHhCxSW9GO+sTM
         TAroOgn4FZ4uXjscQcdVL8igKernVhebhY+tWNuiD5jf+tpTMrT1JmWi58MBsu8KP9DO
         Acbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NgAS2i+WuabPCqxlCGTGd0RyAlQOwBDUG294JndQ1+g=;
        fh=X7f+eogFftrNBLAxb1tK8JEEM61p46I3QYouXJdoSJ8=;
        b=KKIxrW5jAm69ARNZ31R2WmQfN4m/kQiQGP4/k14HANRsTjSMGjXBo680P4D+UDDIWw
         jVux2WCVYQ4kD/mc0HFf0Kee0s7nvCFiXwvHjpuofuFAQHlTg16hfus1dwbSLWXE+3XP
         nAVzqNH2qR6WBqHKfjnAq6bT2g1kXuRa9C/PL02eK7FdxwDHinCVwb7S23vUWW0mYNKJ
         qezSn0bAEGLZqr8ZhPrGl8O01SFmn38xCzDtckTUiP6wEyC9MX4RThIxFClwksZsoBo2
         IE26+XPlp+AKPfkVcDEcp4gLkJGiFQaNoFi6ZCejLMiHK42g7yljRKAN51vRNUQ1OWCk
         FBLQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765495532; x=1766100332; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NgAS2i+WuabPCqxlCGTGd0RyAlQOwBDUG294JndQ1+g=;
        b=toTxqqJ6P47EGYc2bqW7bOizD/BJp+J85MWJ47p/7G+dazJ9TPBW10qlq6w/UJaenr
         aNcDB77ACW8wdfz2RugwB2MHQ3LAxVgtBc9mabXJMdqPVmBczFmdHVjfrWTBeN8SkZ08
         IUZ54x4MWNegP5OQDiz4uheW85zet7tdxlSkh/xCSju03Ke4BE7YZeixll9KYUIbPSke
         mHEKqsQvKPIKoJwgXiKLYsALdUogxzuMtj+kfdESh0YK94zuUBzmEsm0IWIpTSkv8yPV
         UVjEOhf7A/cErLqrzlFrCIBwE4nNW6B6awkAV3JvvKRFAl5iYMMTySK1V7KC3GN4TSP9
         2qNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765495532; x=1766100332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NgAS2i+WuabPCqxlCGTGd0RyAlQOwBDUG294JndQ1+g=;
        b=ceAqYL1+pMkQF7pcWHafrodbhhg1s4vUW53WzSHd9lOeGFI/bY91HBAatpqwX/iJ4K
         IjMdEtgZGxX2BrCKkzUC652vK0kdIVNwFiNB0MHTLGo9pKTTI2pTG//dv1+DHZEY6jzm
         QVl5dHPHZRHOEj89t8BWuKDJqUOOIPGtvAdgGSA4fAprWpwpMVrXR1YsD9J7YNEKmnrq
         NN7n7Th4NrTUWMK4OW1HlpW8N3tY9bWqLp4Hwvu/IFoix+oSxzztPt7A2AKkC/qNaF1R
         JhRif+ABMAaisNYLfjV5sMpgYQAZSJVXFfcKLjbFk58JPA+GKm7qZSzP6HHt3ZAls+dd
         Usww==
X-Forwarded-Encrypted: i=1; AJvYcCVBZAdnQxIM/dlvPuDinY1zTB/F7DG1D9d7DPJOKOUVo98m+gBU02LBvTokE2+GRIMF/YVsbl/4bQ==@kvack.org
X-Gm-Message-State: AOJu0YzBOk6p5+5sUVhbHxqGsmn88XFgqwAL8FntWIg58KLFokWtqyHv
	MONbbh7fZj46Lx7QYEXRgPZ7Z2L2olUAa9oZR2MGEbgBcAFJNHzSuEn0NyXiJeVatNwEoY1CE6W
	VuLvZ8EbOpXsC1jWWt3dQAPF6RrBhZLqRu3jwbdwP
X-Gm-Gg: AY/fxX4kUZiNpALpX1TuEWnKpnbTn9H8RpemEOsCczRxtpi9JSMr0H7xcatGn64oqZQ
	mRM3epw7hwLfkN3ILPp1UlCUfCHODFw6pY+B4JHfYIaZ86mO1TtQMzzKLls3MVzTxtPTQVFrR83
	Zm1SDTHDLxriPU59n0HLOyihIiNwUrPSfzX54LTXOxqoj0L396/fqZryL1CEv//bUKTxfrbn4CI
	irZ0RuDLYOtqKmlVl3LmhVyw6anvbj0cBKcX+53ER9U7wQDJx5yX9JXnOB54WIboHrOnVTGU0/7
	VA+vyww2tKvkgND+jdxxeQ8kIPhE
X-Google-Smtp-Source: AGHT+IELsxBEvLr9lhxQI6U6yiPfylzFjjXDhgwGFlEHLwYN/fZlRQWWLcQMcMN3K4irAeygHhzmk1gxOJpHCOinQXk=
X-Received: by 2002:a05:600c:4f0e:b0:477:772e:9b76 with SMTP id
 5b1f17b1804b1-47a8980f35amr1528645e9.7.1765495531556; Thu, 11 Dec 2025
 15:25:31 -0800 (PST)
MIME-Version: 1.0
References: <20251211193106.755485-2-echanude@redhat.com>
In-Reply-To: <20251211193106.755485-2-echanude@redhat.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Fri, 12 Dec 2025 08:25:19 +0900
X-Gm-Features: AQt7F2pSTNWKDsucwV-uysbrv-q3tz8hqRtbVQ0Nrt24_BZVepbEChaAJPcQzz0
Message-ID: <CABdmKX2MPhw121ZG8V+f-XoOReUsCdmcug-cWDg=3WZcJ=NHHA@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: system_heap: account for system heap allocation
 in memcg
To: Eric Chanudet <echanude@redhat.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, Christian Koenig <christian.koenig@amd.com>, 
	Maxime Ripard <mripard@redhat.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-kernel@vger.kernel.org, 
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5163D2000A
X-Stat-Signature: ewb1hq7rpxdatckh4bs76iupecx4uwed
X-Rspam-User: 
X-HE-Tag: 1765495533-166641
X-HE-Meta: U2FsdGVkX19WAowluSU8K++Otg3s83rFlLvVvLHAJVx80CwH6wcUBoSHt4M44b5Ph3W8YcFVmIgtKzT0wpC/ZQtXje3Qtn67NnQAhcMDR4bWKPjiv9e6sOMvYQdjKo9dNJrRyFlJi45bHxCIMeqerGIEjC+vIizUmLTqhBNy9UCWWdKo39rpwDjlcDTtzLq+HhSvokNL0sRRb0soNh/gKrzNimoeLqM1+0C0aPPZ8KAlGSgwl/B+FXaDv2hlovdWMWBKlIOOmj582cLkbHhC26F+13bki+I6cChASkUX+NdlxskhjQ5d4tGmwmyEavRyG2+HlBbepmMfKrwGKKXYlI04U6szpLsJQE5HUYlUaJhVCe0XqP5HwuWigCIS49hvb63KrSmymqgs8x+R8hIjjAxkFOLzcoPTNsx37ygpKWYK4FT7XdrmONiqKlkIA86xFSCfBh/kvBEUvijuneMPe499dtgyiOJi5P8qR/VQXh5SH7xW3iCvjlWEvlOk+xk+7P3W+sAX3BOx4L7IKI1MW8gBDe/xzRF5ckA+tOsMzH+GCeaxeVz0ht4sHofspAF/h0sgoYYdcCr0yEbx+dG+MCaE5LsiYOdaZh7V4NI2hon9v61uzviyTWixKhg1MVkCrGXrXnis01TznM7Os5eHvXMhkiMbIt3QN9Tu4M93k77f0an5j0EyJNrx1a7sSJC/ze1cfxRHj+dGxk5JqB3Fh5Gf3tJY/Y0g5aCKpkLAyjBAKeCxbgbb8TmTVpVSF4bpZ3Jn5rfTMp0zlKuus7THPxVtgTr9/kd0Gu0qGOHCdbhaH58rXsdpfr+lJmncTmGO7NYnu1HMFItelug4MeeV0ZkHl4PlE52zN3xCuHFhfolQf/rpEaRLqq16eornmLhaKX8zJ4N+FQX8Uv2RZO07jeWWVEj88cs6SMtdySh+j0u65JSN9yRdzdpVvY+95JHuwTWxEIR8ftJnQHamV4Z
 DjC7LMH7
 CoCD8gy84HP7+3eX5vJ5fGRv/ne+NX64Dsum2I3Cz5j3Imr9JW6cn5plOJt/K13rnB4dPFDyEFrVlmQSY30UhUKBUIBhucDkxRv89f/L+G7nthMNE/IDQKuv7ZsDn7ZzfVKgfISbL1xwT8KaYlQLdj5OmOWfwI4/VgOO0uYIpzh4pHFzaSxX2QDmyyE0SVJdflr3B7nwM/tE/MiJsUnSpGJunFt9Z00sJ92xi+HkC1u6Bv6rLkcQoSxCDJQyD6Zkucj01Fe/xfqq36ocSF7SLiuz9z6ieoRRFQtTKesEuymLVxY5VHkkQCA7zV3Tm+S+sgjAeXmeWWwf1j5o2Xk7sUZ9tDF5JJJDyIDNJOfWuuaA1zvoE144WHeVQb4aS+V0m1zuJ2p8/ENLtOXU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 4:31=E2=80=AFAM Eric Chanudet <echanude@redhat.com>=
 wrote:
>
> The system dma-buf heap lets userspace allocate buffers from the page
> allocator. However, these allocations are not accounted for in memcg,
> allowing processes to escape limits that may be configured.
>
> Pass the __GFP_ACCOUNT for our allocations to account them into memcg.

We had a discussion just last night in the MM track at LPC about how
shared memory accounted in memcg is pretty broken. Without a way to
identify (and possibly transfer) ownership of a shared buffer, this
makes the accounting of shared memory, and zombie memcg problems
worse. :\

>
> Userspace components using the system heap can be constrained with, e.g:
>   systemd-run --user --scope -p MemoryMax=3D10M ...
>
> Signed-off-by: Eric Chanudet <echanude@redhat.com>
> ---
>  drivers/dma-buf/heaps/system_heap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/=
system_heap.c
> index 4c782fe33fd4..c91fcdff4b77 100644
> --- a/drivers/dma-buf/heaps/system_heap.c
> +++ b/drivers/dma-buf/heaps/system_heap.c
> @@ -38,10 +38,10 @@ struct dma_heap_attachment {
>         bool mapped;
>  };
>
> -#define LOW_ORDER_GFP (GFP_HIGHUSER | __GFP_ZERO)
> +#define LOW_ORDER_GFP (GFP_HIGHUSER | __GFP_ZERO | __GFP_ACCOUNT)
>  #define HIGH_ORDER_GFP  (((GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN \
>                                 | __GFP_NORETRY) & ~__GFP_RECLAIM) \
> -                               | __GFP_COMP)
> +                               | __GFP_COMP | __GFP_ACCOUNT)
>  static gfp_t order_flags[] =3D {HIGH_ORDER_GFP, HIGH_ORDER_GFP, LOW_ORDE=
R_GFP};
>  /*
>   * The selection of the orders used for allocation (1MB, 64K, 4K) is des=
igned
> --
> 2.52.0
>

