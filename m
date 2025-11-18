Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B342CCF2561
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 22:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121D76B0026; Tue, 18 Nov 2025 17:07:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D2346B00A0; Tue, 18 Nov 2025 17:07:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDCF76B00A1; Tue, 18 Nov 2025 17:07:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D98396B0026
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:07:56 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D874140246
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 22:07:56 +0000 (UTC)
X-FDA: 84125116152.01.393F823
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6D3562000C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 22:07:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IOjLpQnU;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763503674; a=rsa-sha256;
	cv=none;
	b=r5nr0CqefZ0OUauJWa9ARZF39PYAsFUhF9WFhGFmG42CmXYENiT4NPHwfu7b8fLpUSIGnX
	L8tc52fF+VGWaPIL4j39r/8iZuTjlJuTJEpGRVkuPKrGajM9v/S5rTNmYT4CVf4Zlc0Y71
	TXzZcDKLyHNSq3uSS+qshAMCtRRv30U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IOjLpQnU;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763503674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AgyH+nOFFLOOLPQj19SMqqrRCiMHwP0eevW9Zl1x2hs=;
	b=za1KBuPLDk9BDTkWvBYoe/1ROkmR18RCHxXhI/eqsrSSDc+MQSDcbVAvVLy21hI4Mraw8b
	nPK1aZgY88KrEq39YEBFQaRvqMhnxTOgwbJyrJU37AVmPbfSFbEDHN8y5rgjgljl1II4g8
	Xe1wG0iFPmyvTqzJpnrnTwKyemfVFbw=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-640d0ec9651so776689a12.3
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763503673; x=1764108473; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AgyH+nOFFLOOLPQj19SMqqrRCiMHwP0eevW9Zl1x2hs=;
        b=IOjLpQnUXS+aIWwyqqaXO7tkVm2EehfYv29fZ1Ib4Jq9/BSAYGb/i8ILhOivbzEYjB
         aH5FMRrP456jNwYtYW79CEYLV0AydzSIRdUkKmFYva0k8RoU8Vb0A4kB3jNLmZ5Hsig3
         S39c92Xfok4VQ5yVtP1Q7fv+ktpJc3ErKMRw91Erfq9rWWsSWoY2hO1O+xrVYS+udmtp
         Yb4bzfPSxELf2/tmCU71yGq4pCAWAK0hligtiM+9DKiMbyHSqV+quYSD9UDm3EG7KYI5
         CtbA9P5ntIfsDkS303Ndkk6uQwd+eHVngafgB0yzHx2ZB1twBDMrHq+DoIbf8VWpzTT5
         yJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763503673; x=1764108473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AgyH+nOFFLOOLPQj19SMqqrRCiMHwP0eevW9Zl1x2hs=;
        b=b+qVKGR4LABWqewR4OPI5LJpq1mSzZi3IVn879j/RAI7zvXGmfJeL5IvDmVk7TsmsM
         dBs/fBnQgBbzyxAfPweMkwLXFxpBqjCui9U0hLM5NEDGbemwCp8dgGmnGNUo8rkA2t8L
         J/LGP17tbMoEkVgGaSLX1ndd4UIa/30PbpXwEjUp8b/Yz7KT0mD69jCoFax8BaIgnMLp
         sA5pJauEAckt8bppOgV6EVD+9zFtAp7yMlwRD4w9mBf2DGwCTyAJnpx7yiffP1fl9vuP
         wvlD3yLOMibY7BwVpQGIuFv6tHtU8d1cV+Jo8xrrcjbsQ6bXebbodNAwt1Zif05paS22
         fLvw==
X-Forwarded-Encrypted: i=1; AJvYcCWHHkc7CeTcF0MGIm+0kgqhpoyCRunig82AvpvibrN5IC42Z7BrG35D3PO3QPdCO390LjUmPL8xgw==@kvack.org
X-Gm-Message-State: AOJu0YypPg5iDLnjyPu6NAzlahdiHxynlXpBB+N2MG7GxWArAbDlquH1
	8DehAIJP5s3xbKVr6rMqTgtcnBoMJ5aTEuUhQnNcRL+2bVkckob+U5/TfGVhi1RZO2olmyBjLAL
	yRWViLPv0zxNl9T95QGuxMLp7a3t6ikluFZGFGCqTUg==
X-Gm-Gg: ASbGnctTyWhMN3ermkAti2wdT2OXHKfIb9+0EQiajpeMHu5xarWDtB8pO+kOcHj4lVo
	jTsgF4JkCjQoi28eNoobl80mFS52sLdGVHYenfCzkX9LfNs657e6SgKKy6fFpnYmahA7z9ZPRsr
	oEF+0i0gLkr1W2Hr0RrHEXJV1cQth19/lvzaW3wz96yT0EnFym0rMAsohIGDa/w0eJEybatN5+c
	bMQMGjSa9UaWu8WBYU3w0Hignu8HKv06k3fOYK+7phuJwdrMQ0GI4ASO69rNnrmqsfyIZod34R5
	rsY=
X-Google-Smtp-Source: AGHT+IHtDqrk0qniYZc5AFwR5DqbAOIqGAY4cBt02gO8xxQprKgTQdf+fJMHgzuhx8eUZMd/TIJzeZERktIMHFkuZIY=
X-Received: by 2002:a05:6402:13cb:b0:640:ca0a:dc1c with SMTP id
 4fb4d7f45d1cf-64350e04b49mr16432565a12.7.1763503672627; Tue, 18 Nov 2025
 14:07:52 -0800 (PST)
MIME-Version: 1.0
References: <aRoi-Pb8jnjaZp0X@kernel.org> <CA+CK2bBEs2nr0TmsaV18S-xJTULkobYgv0sU9=RCdReiS0CbPQ@mail.gmail.com>
 <aRuODFfqP-qsxa-j@kernel.org> <CA+CK2bAEdNE0Rs1i7GdHz8Q3DK9Npozm8sRL8Epa+o50NOMY7A@mail.gmail.com>
 <aRxWvsdv1dQz8oZ4@kernel.org> <20251118140300.GK10864@nvidia.com>
 <aRyLbB8yoQwUJ3dh@kernel.org> <CA+CK2bBFtG3LWmCtLs-5vfS8FYm_r24v=jJra9gOGPKKcs=55g@mail.gmail.com>
 <20251118153631.GB90703@nvidia.com> <CA+CK2bC6sZe1qYd4=KjqDY-eUb95RBPK-Us+-PZbvkrVsvS5Cw@mail.gmail.com>
 <20251118161526.GD90703@nvidia.com>
In-Reply-To: <20251118161526.GD90703@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 18 Nov 2025 17:07:15 -0500
X-Gm-Features: AWmQ_blpcRzsFKrW-N42BrQ1n1NLtjzkNBwejiuKy6hBEe6k9J5ADY-OfS4GodI
Message-ID: <CA+CK2bCguutAdsXETdDSEPCPT_=OQupgyTfGKQuxi924mOfhTQ@mail.gmail.com>
Subject: Re: [PATCH v6 02/20] liveupdate: luo_core: integrate with KHO
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>, pratyush@kernel.org, jasonmiu@google.com, 
	graf@amazon.com, dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6D3562000C
X-Stat-Signature: mqbopqkx5ajsbrztqm35gf3z6poprd8y
X-HE-Tag: 1763503674-795112
X-HE-Meta: U2FsdGVkX18KO+X+3qG25nu5gyNpFQqouVkALLxYhAUw/ZKivItlh1U7rjl82d7fhmX2WXPmDSOYHqO+J4bhTpamPqNYeYe4rCZOQk82mnW5bLhUrLfG22JeSpP034WafeNcKb6u4M1mbuBwf7cf2UdoiWHcxPR/GLZbI6z4ROMdCmMuZp8Y+6oNTiZh4oUVTurQ7Jk1GgheYFHVX6DrvQEHSQ1vFEcsQKPRj31kZBMZ49sRVUkViLujL3fl+e2z7lsSqxGmOPccJ1hxE8OUMHRwb7CtH1jJMprk77JIgLje8PWNBBOy12YVX4Gk7MRn3xDdEFIH75QLWnc5P+EjKElEKjZQwczgLVS82ll/I4h6V5TL8LfLoyH7kZwOd93fUZwePs+VEgs2FNkUR+LR4OJyUCE5T6BO7gQqrgvOheGlE3PVDP43cZ19QZ7Zfqt/fE/w47dwuItbjHDpcyowhl841tbJ1ZS00ZKnyvLpeSZ4L45bBi6AvkZ6CRHJGWzNQnIp1dVdNf6r97w1wv0O9CXiZZUmpmQj3+isSjIny/9Fmtlm7J6OEq+elnRv89gxYbyWUgQsCH+K3QyRUzFZt94gkabvLaiS+c6ldWKZDjnGP50SMnw8RQCfcW61N348TPzcxYEqocZFWjPIFJJKmfne9BMIVc2OQ3YXPjC9WOdbecLzNiennD4BAVhkFVPeyFFmx9efNNLzytiRQp+CblI4PtkcEveyhOHw9T1SHNRZ9pMpjUxirJ09Hf3s3FLylA99qqeAGLmpZXj0X4ZYE6j8V8NI2otcgXqYOo2hBvinjgj/FhYt4/dyFWi2xxr6sCXGf6pwnd/HyZ0Ztxr8OTC8yA0DCbOn+5Nfyo65v2IwYMAlwTeIFn69fRgbjFPGa7tG5NP6pi+qY4DW/7/uBWmwPIWwcvAj8rzgGg3uQLZhCphIT9csbNTsuBtn58nvC09R6F7HtjpmSQq4s1D
 n9itAILc
 IybZXoksoPPJH3VgtW07OPDMuDWA0NQA2VsdXNnb8zF/sBH+hnYoNGVzutVDtZ8Zd7xVqrslRGITJagEd67bjGZVAD0Yl3UhXvCkpLnvT7C0Sncy7t46jWgsumJ+QaYFPhl7v8ohem73QsBgifh/NovJqIq/dREC81SYCVoraNYZVajvkU1sY9Lk09X4fXBheBLHzxDGg8pegDfCB9i/31PDpbrYETtEe43vRiuUp1GKouZn1Gfhf6B+U5D8qJmK4hKMi0vxYx7RfHkiOnrYhMrgVX8p/zkysyJyaUnyzrtj5HqWJwReM/f6dMZ/39qlrwar+JSNJvveVCNk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 11:15=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> w=
rote:
>
> On Tue, Nov 18, 2025 at 10:46:35AM -0500, Pasha Tatashin wrote:
> > > > This won't leak data, as /dev/liveupdate is completely disabled, so
> > > > nothing preserved in memory will be recoverable.
> > >
> > > This seems reasonable, but it is still dangerous.
> > >
> > > At the minimum the KHO startup either needs to succeed, panic, or fai=
l
> > > to online most of the memory (ie run from the safe region only)
> >
> > Allowing degrade booting using only scratch memory sounds like a very
> > good compromise. This allows the live-update boot to stay alive as a
> > sort of "crash kernel," particularly since kdump functionality is not
> > available here. However, it would require some work in KHO to enable
> > such a feature.
> >
> > > The above approach works better for things like VFIO or memfd where
> > > you can boot significantly safely. Not sure about iommu though, if
> > > iommu doesn't deserialize properly then it probably corrupts all
> > > memory too.
> >
> > Yes, DMA may corrupt memory if KHO is broken, *but* we are discussing
> > broken LUO recovering, the KHO preserved memory should still stay as
> > preserved but unretriable, so DMA activity should only happen to those
> > regions...
>
> If the iommu is not preserved then normal iommu boot will possibly set
> the translation the identiy and it will scribble over random memory.
>
> You can't rely on the translation being present and only reaching kho
> preserved memroy if the iommu can't restore itself.

In this case, we cannot even rely on having "safe" memory, i.e. this
scratch only boot to preserve dmesg/core etc, this is unfortunate. Is
there a way to avoid defaulting to identify mode when we are booting
into the "maintenance" mode?

Thanks,
Pasha

>
> Jason

