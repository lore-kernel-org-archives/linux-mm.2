Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE172C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B16756B00E2; Tue, 14 Jul 2026 10:38:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7446B00E5; Tue, 14 Jul 2026 10:38:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B6426B00E6; Tue, 14 Jul 2026 10:38:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 57F736B00E2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:38:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8560C03BE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:38:09 +0000 (UTC)
X-FDA: 84987637098.16.3D99DA8
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id D5F19120006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:38:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mMXX43WW;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784039887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=klabNcutZlGjGAyxaUYGBRc4Z56CA+f2nGt8Tj9nR2w=;
	b=WDhw15y6sCQvLxG/JOOI9sqzWBf8EtT2dg1qzzCr6gkflJLL0oamgY03K0JgFgZIBQwxim
	phdxPghcD5TYUluqdjWo1xXsLu82Oa54qZWwD341VzA23HX7x6wh0fMQtp2iCUkb1jvX1J
	liIbfRQNdmP7mO8x6ChWW4fD7a3TIHc=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mMXX43WW;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784039887;
	b=h0P3fZ16HKBbZyX5ZacvOiQ45Q2jSxlA8X7EcdbKwsoRj3h70Gz9WyeyBi+qP3Yo0Y1/gf
	WF2Owuc4+OWqB2uXbgz3sKSVk+pfug5Vz5c7t9KiCZM/RkSOMtnAz2ZhED7Qok5WiNBIey
	7Slsy3dmb6tqotWCs8ibSzhHWi7w9+Q=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c10e86e52so324381cf.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:38:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784039887; cv=none;
        d=google.com; s=arc-20260327;
        b=ONrJDzdkONWYE+ZcuUvtD4lrIi0Ui295DbL39Ix8hLu1CLWpalVqThiCLbhIQmQrIn
         YIwtSTAOqBoQHhl88q4TptX7fD6VpD0r3zC2qKHW0p1of0itrFidN9VG3HJul+mjBYLh
         TvniirUUEl9+xQYqKH7VaKJUH1LmKsQNXAnTesR+mR52GxPunsDsGLZm6x1q+DH4U+w2
         TlJ6uM5F1lUISrfPzMBQrgNX/Xyk14Ka0b+qV03ruYuA0xBxjEQkv6iwebq749ccT3QH
         QxyGhNo6Tc/JeIh8QonTtPRjDRq0zmC0+dzyBJKqbTdD0SgKEDrXnBn0Mhcx2b19A31Z
         cv/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=klabNcutZlGjGAyxaUYGBRc4Z56CA+f2nGt8Tj9nR2w=;
        fh=gYv1pkfwOepCpzkLaQJo5yTWd5sOweaiZXfpGrqFPOQ=;
        b=SpBNo+d/NX+mUL4MfZX9iuVJTdj7E780op5gRPZlqAxLMIEO+3DN1rcsKgxeCNAn1V
         1tn6Zl2BuGb/Bvkee+0YvXfmuM7ShvfiRI23GKVodIv5uSoqGnwqjgZ049x/3klAbhg5
         aN2iFM+jrDkv5xiqsoGL0HAlWMUwfK+pPUOLEkIQJ9FR+q2s6XmJqGk+SAypgH4r5MkC
         1tYxLTbWvU6VkVhsrP8BY06Igx7InOMyEY0xL19oqssEYMQmGNr5X3UZg2TqtC29Xxqs
         LCKcGtwoNYrjfal/zU14dqKsCBPmTV6rqbZszu0owutRYpieqdGNFWeWxJdUd6z4kkws
         M5yA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784039887; x=1784644687; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=klabNcutZlGjGAyxaUYGBRc4Z56CA+f2nGt8Tj9nR2w=;
        b=mMXX43WWm3la/todW18DxPTmbwxRr+Nz90odZBmJ8QE2rZmZFxOTWIfUxaqoJbBQ7N
         gZ2pBrFNta/lPeL3H1EKmNrRduPdXEvpQh6iHCfB3Zw4aI1JGKaqcR2q618hWL9Z+upd
         cQQuLhZCdj1J5uRNqqjRAZj6nVbn0pPIstFDytijweJa4ExoXF06R7s7/7X00L0jl0G3
         pHUpd+nbFUOBRQYROEIL9fuUMjZgYs3nXgtJjAUPS5J+d033mMqjetn/BSmcyrOm6GOQ
         Dka4KAc8I33C1MiPyIbH4eSE3z6z+o4eDt9QZ4J7vBzUtIi6M6wBK7tIRkYrqovD2TdT
         uNzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784039887; x=1784644687;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=klabNcutZlGjGAyxaUYGBRc4Z56CA+f2nGt8Tj9nR2w=;
        b=H6WlNIcoVWWninta1gIXNC5THThytqAZQqk9m0eODdnK4bjzs6nV27Mxx+gKX2/3rj
         VIiRkUsuQaOGCHJ3YwFX8FbYiF/kBPfDXCdKMIBAajBVcb7C7OyEO3Jw6otSI/1I2rO6
         yCiJjNuTVaAMFGE7Lk9U9AahLAc5V10nBOI1kAr7X2cXPwshNWQRmIVewiNQT5Jq5epe
         a/HTALH7X3HqdR8yPGXvv/fQvI3snEJgHthXgMuX5IRn/yuW0giZn3dLhH9ER2gN06p/
         l1BaxedqKCNjWA6MxH+blOTwTMr7b5WgUi3GmNdNQ+IWGHIJDu9cZGipWUX2t/kcmSr9
         lsWg==
X-Forwarded-Encrypted: i=1; AHgh+Rq/DCQT25ExriP6AZRN82hNC8KqzQQugmqPkL7VZUcGUWEcvg68EcwEkZpZmJlV8piojY/LJinmiA==@kvack.org
X-Gm-Message-State: AOJu0YzOdVZTvVHC8uwV0tOQPMW8txDCYaA1sl2VtJWOeASuAqbAyrdz
	fqhV/zXciCCjGgG4V/h5DtrW3HqMqapp+dK/zCVN5oh9n7SzhJoNTHPlpj6xrV5Nhz5kdwHlO/3
	3SXh9/p4dLhK+vHst1b6hiYowrX/I9lenpD1xOy8E
X-Gm-Gg: AfdE7ckpA2Ge38H1kn9b5HhxbiIzTuPBID5SWVMS3aFGScWaMejQKaa4ypgIVYZmbVt
	TdVlFO+FvJTl0mutLRv5Q9TSbeutA6ABsk2SABXHHWsQMR+E8tP3j5eG8+VCdq5NtvMEHirQgcP
	qWo/L8GUepZ5Q/9PKhUAE/mwmQrHfu+tX+fuH5JLZQz0HfwKVWSWY3ZRhe5/0ai+W4e8uH2tD7M
	7G4tYTGib6De8LpXHn7riZ3VbxPf5T22HKtpj8Y3qB0JQIypZvD1XGsRwjOFLd5MGJ1rVOWrGJt
	2Yl1oLXTGiS2lcUtLEXNyuiB6u8=
X-Received: by 2002:ac8:7fd1:0:b0:51c:9ad:d76 with SMTP id d75a77b69052e-51d7c6a8b03mr15483251cf.19.1784039886094;
 Tue, 14 Jul 2026 07:38:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <20260713-kmalloc-no-objext-v3-3-47c7bd138de7@kernel.org> <CAJuCfpG=Dk6PRWy-8wR4j0UreSsa=fdiFWvBYpOkSZE0zV2Z4A@mail.gmail.com>
 <fcee1dbe-1109-44c8-a3dc-8aebc5569c73@kernel.org> <34af7126-0a19-4da7-a3dc-4e6e0ae01ca7@kernel.org>
In-Reply-To: <34af7126-0a19-4da7-a3dc-4e6e0ae01ca7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 14 Jul 2026 07:37:53 -0700
X-Gm-Features: AUfX_mwYeQCfOUzC_nBCAycgCXI-QzCA2j7jZA37ZhkSyGe8sO_yDF7WPJ9DhZE
Message-ID: <CAJuCfpHYbTobe04+Mm_CRMv2SkUuT_9j8T7ByEyv=cJU+YZZCg@mail.gmail.com>
Subject: Re: [PATCH slab/for-next-fixes v3 3/4] lib/alloc_tag: introduce mem_alloc_profiling_permanently_disabled()
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, Hao Ge <hao.ge@linux.dev>, 
	Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D5F19120006
X-Stat-Signature: snr8ztrqmxjpwn9rkuyfmabtzc9cmejz
X-HE-Tag: 1784039887-713460
X-HE-Meta: U2FsdGVkX1/Zc/TOcptdy8RFBKKkzkaGXKFbnxvhJ6xSBzxfp4DiXlgpPPaaqwGS8WQW2G6F3YyrNtLP4CqUGQLz/gPGwde1S8vYT6XlwFdFZS8nf+ovZoMNjVp0oNGHdPDnzDbNvDy84icQOgdQbgNDaO0yzlV/Oh3OwSB/S/JySY5bPA9XhSVt9bzykvvMUYmuD36R8wbDbsxYpJVo4pDH+lwfiff84gr2hfgbFYkB3mZkPsyW5PZCRZTBsfSLT2rS5CJjCvyokHi7ZVOi9I2ThHn0+ltlcazD5cpcoM/6fPFyVKfZnI+v8f7kKRMFln+S4IB4p5KyXJA3oh7VmFXZX1HSx96X8ZrNMcp1cL05Osu8u5L+dB4U2JOlG+2dMmSsfK+cNLXjwY+9h+aWDa4ZbaXQ00yj4SiPSEY8VMRxlmGr6Ib8LabIpBJXnBeYDlQ+oP7VLc5TdcXmfhm02m8uUcoQ7ZBDYE2t/O+21k/a5YNfWScsbxUIFNRmSfqJqxg2OcHmlWeUogvffeO9HuzV3jqnNgMlEojg5OHg2/gGc+1xPYwQH6bCA/ue3oChDetvUFdVGfZFF1Qrl7JdrNnI1e7u6gAEm7aBSyiVE6RzVwuMTO+6K8SW7ZyqoAJJT9JILcBfcKB+asSOjgqWYIdASbcAwWwBSMiKvxyNVeMTZOlsT09YPk5kjv86xlXQkrdhlOoSadlnBZNVnlrtkkC27JiZj2MsWMP7GbJT2NGBWR1Xa7RV8DT1U7c7zhjDRhk8cAZZKsLHJ9FEFvJ32SaV1fQB4SbOBxMEMdWnCLdrW4aeMJ4l3Em4X7Kxux0UKfLed9XkgnH7gRIJKTxo4/J9namyCxMYhetU+z8L0RvwJ9EQE/0OY2Y0xz7vY6L9hVscsfDKZt5epkZkEil9Ql/f+FXjYSqCdq+YWkQZt31de7q98tdA71NELrBD0dP6/EDn6J/vghNKQZG6zO6
 t1gDRd1y
 JKJiHpfZETYCOfJAnFoYT5qCeW/XyUALEwJO5ooYWHN0+gfS19emA2ZNSoyy8LYdhBXe0OAXW/Wms9KKPxsxvhH5wo2Pzz9sCdwabojyu3hDNFaI4nOJdqrLq3hGcGWbVTJGbADC2TWgYAk+k8ZFjdWxCKg7WIu9V8soAKSNULWFtgL3XyXc2bpyncBQNGdAD7SdWUtnIcobxJi+0ZaADadRBgcN59uZtAVDtvwBwI0dK4js1+9m0zEAC+ihHcbZVWU00MUnyLZdIXm4JKyF/Jo0FYhxWX/8w8lxaec81RoiPQnawr+4KLdtDuFMvAxguyGd+bPFoVd4Bu+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 9:28=E2=80=AFAM Harry Yoo <harry@kernel.org> wrote:
>
>
>
> On 7/14/26 1:15 AM, Vlastimil Babka (SUSE) wrote:
> > On 7/13/26 17:43, Suren Baghdasaryan wrote:
> >> On Mon, Jul 13, 2026 at 7:29=E2=80=AFAM Harry Yoo (Oracle) <harry@kern=
el.org> wrote:
> >>>
> >>> mem_alloc_profiling_enabled() tells whether memalloc profiling is
> >>> currently enabled. However, even when this function returns false,
> >>> it can be enabled later.
> >>>
> >>> However, this is not enough. Some optimizations can be applied only w=
hen
> >>> memalloc profiling is permanently disabled. For example, to skip the
> >>> creation of KMALLOC_NO_OBJ_EXT caches at boot time, mem_profiling mus=
t
> >>> be set to "never", "0" w/ debugging on, or have been shutdown so that
> >>> it can no longer be enabled.
> >>>
> >>> Introduce mem_alloc_profiling_permanently_disabled() for this purpose=
.
> >>
> >> nit: I would call it mem_alloc_profiling_supported() but this name wou=
ld do.
> >
> > I wouldn't like that name, because _supported to me sounds like those
> > CONFIG_ARCH_SUPPORTS... things and not something that was just disabled=
.
>
> Agreed!
>
> Actually, last year I wasn't sure what "_support" in
> mem_profiling_support means and had to look at the code while fixing a
> bug [1].
>
> This year I forgot what it meant and had to look at the code again :)
>
> > I suggested mem_alloc_profiling_unavailable(), but it's not ideal eithe=
r,
>
> Hehe, in terms of 'the meaning is obvious without reading the code',
> it's not very straightforward...
>
> > naming is hard.
>
> Agreed!

I'll let you pick one :)

>
> [1]
> https://lore.kernel.org/linux-mm/20250624072513.84219-1-harry.yoo@oracle.=
com
>
> --
> Cheers,
> Harry / Hyeonggon
>

