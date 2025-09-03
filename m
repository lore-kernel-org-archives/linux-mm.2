Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD1AACA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 18:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 448138E0009; Wed,  3 Sep 2025 14:48:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F8408E0001; Wed,  3 Sep 2025 14:48:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E7168E0009; Wed,  3 Sep 2025 14:48:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B3768E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:48:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D19E51A081F
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:48:54 +0000 (UTC)
X-FDA: 83848825788.04.7D75B62
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id DAD5CC0006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:48:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="O/00+cgu";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of jstultz@google.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=jstultz@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756925333; a=rsa-sha256;
	cv=none;
	b=8a7xxk09abi4h23RaC5GShpvF2+53K2mNlL5OwmKVqC3f/NbwCHahRmL5S5TJNPwZKBgMf
	ZPmvAD2QxCYcib1ZcaUeFYHj5iaO7XGZeOJDlkCTgBqolqwvRkbDA4aNq9K0LJ3onLmStI
	UsoSjmWwtDc98DqUvS3DH06hcomuR28=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="O/00+cgu";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of jstultz@google.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=jstultz@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756925333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SpKd2275sVbG0K2FZVdjWp6/Z18/FkDT3HL6WWRqaEg=;
	b=WnBVay/36tQGwk3hQQOY+xm5arFHnbE7aZHh0GMk2XvV9aaL3tTwQOcdMV4I5osh+MNHjM
	Nfvio/Drdpw5Q9il+el+vtW4R4qevJNAwMZp79NWfS6E5f1r71YV40lmJd+GOT6M1h5E0/
	3E8EdGRAh7wv6hd+iFDdJ/vOsTl9XDc=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-55f76277413so188810e87.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 11:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756925331; x=1757530131; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SpKd2275sVbG0K2FZVdjWp6/Z18/FkDT3HL6WWRqaEg=;
        b=O/00+cgum4YsBqLvPUdMMleMFi/oWwOFA0B75zSGkl23XkN3wCDIik6x3m5G2DC7ZJ
         uHpYdglguW+1LqXc4b5l8canZqQxRaagkv4qgyP1wagv0dzTXS4ZVKuTZqvp2hE6/qw8
         VZR+Q5iH8yGWr0hU5FMut0yV7T5jdWWA6T+uu2ii8nBpmiXwymjDlZfS+cjifGHp29BA
         0uV8mq+y8eOs5R5D6cdIcYgB0MF2MKyRDmx8T3x64fPkyg5SrH4z4lyZdQNfPwlyzuYv
         3c1ORXB+WcAi4IsWsJ5DtH1Rb69fEL5ora9XPX2wIpybUQnCF3Pzg9QoAQ2uQDqbX5V7
         6xzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756925331; x=1757530131;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SpKd2275sVbG0K2FZVdjWp6/Z18/FkDT3HL6WWRqaEg=;
        b=N1qSbpgOuFmt3CqajYQizePDeVCRKI1YruTouJ+/B0hgg9muX1sa3WEjzk6nYKNoV5
         qr0S4BwdbQT9mRyE+gRbLuoycsttTGXbC5gKh8ATldAvGEvfOhw6fXJPDWzNFNmYfhH8
         BrN6d3tPFjeqE3aY7JGnB6FTzEzLFSB83ujZCcwVPmt+yV/GgzT6mGuA5q9IdlpxRWZH
         E0YwmbFyPtvsGzmv2YjUU8/FNgVLtmHdvi1a5Q/aLwg9n2cc7f6giy1WHRFNub1BAvEz
         Nsf1Eei1B5Qxni7frMBExG6abTKHDEGO81bxrpO4vn/PyrkF1LZMd0vqk1XmfYI6aIN6
         JVaw==
X-Forwarded-Encrypted: i=1; AJvYcCXQgSha18kcRnuqL5UWo5AUr5oUAw3E3ZWN6czzeyheaR6rfKQbEIIwJoJQkZbrkr/9nx6NIph+qQ==@kvack.org
X-Gm-Message-State: AOJu0Yw8GH6iW584EvPwxvFqA4YgXAE6K87alpwcwkPQqwI0h2hUaRKU
	v1fv0NVgjuSDAARASbV0fQxNLCq2IE7wj9r520dbfH8UeMIqhgApGMOuAugMo5pSQFnZeoHIYnQ
	weMOvzYLvfY6FC1Me+Kut4/2JDyoCMK4o/EkSUnY=
X-Gm-Gg: ASbGncuGX2SeLUQnpvv+e+ezfrMOMrL3UV6ra13BpDk+Ze00/Kz3kBdKjcQI1paouLf
	T3tDhju4x9NO915PXDw+uGX2w3aVKOX+pNYny7s106EAf761U6cK3j+9D3XzGNFH7909SlugpGB
	VRt5lyntD2e/jTI0Wl+3QAkarj0Rk10ah3hGvXn/JvfzUF0pwtK7OP3cVSKkduYngycbDs5H2Ih
	CNeUqNpv2LLKqxIxZZa6ncXe/GUiHfAwRcnvFihNbE=
X-Google-Smtp-Source: AGHT+IF5G/J215zB6F+3YqHgBGUMzaMxIb8FdX2l9xOBS14z2EjkTnAnD4URRw2r/tfzfVxdowvkPYNpzRoqDhW7JLg=
X-Received: by 2002:a05:6512:660a:b0:55f:595f:9a31 with SMTP id
 2adb3069b0e04-55f709747b3mr4044420e87.51.1756925330683; Wed, 03 Sep 2025
 11:48:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
 <20250902154630.4032984-5-thierry.reding@gmail.com> <CANDhNCoM4RFX-QccF7xT=+-tduGj9OZ_8SgrTVyRucMwyVc73Q@mail.gmail.com>
 <e6twhwxi55eesb7xirei7wezzb77qjiji2mccgqlziisjzl3q5@3ny5e6lbgebz>
In-Reply-To: <e6twhwxi55eesb7xirei7wezzb77qjiji2mccgqlziisjzl3q5@3ny5e6lbgebz>
From: John Stultz <jstultz@google.com>
Date: Wed, 3 Sep 2025 11:48:38 -0700
X-Gm-Features: Ac12FXyfpojM7sYEH_SV5iPkXzxCBmlghsM38HwpGdBEBMQS7yemN51cEMcgCs0
Message-ID: <CANDhNCrO21O_URa1iHuroOoG-g61DL7uvECTwVxiuitCTi=i4g@mail.gmail.com>
Subject: Re: [PATCH 4/9] dma-buf: heaps: Add debugfs support
To: Thierry Reding <thierry.reding@gmail.com>
Cc: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>, dri-devel@lists.freedesktop.org, 
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DAD5CC0006
X-Stat-Signature: bgjte37p5x9yndgioz7rs8p33bria5wn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756925332-349290
X-HE-Meta: U2FsdGVkX19d0SG/y6Y/5oODIeRCDONaCKtvpuSRlznNq+pV4OtVRMBeuP6y08SntwSrbJbvkUJdkxh1bVfeuT7P72llP94wvWFWg/n0QfpXx9yfDH65UXZjsfz+oz7zuXiXrLItgLPP9NPHo39igWJogua4OpPAkTm57kbeNIVaevCpfprDBH8kmcg/iB9nmAiapuLUEBlSqlzWH95KRnLkjMlypBWus1Ky9EXUR6SdyIovdm9ekbqpaC4pcnZeT99O3GKYmyxGJ/i4neW8aKOa3ZOUlRwf9cMsXju4XJaACBILgdTuGKiA+2Bu1RtVDUMf+9zINjWZp+j9Y05LHoHVcK/a+cz0RHMFaHeTvNmXX+OWRZ7xcBHPANC/PUwpLsPuSzOHD4uRX8xeeuEhkgV7roOmdQB/s544bjoQe8LscyaNknKtapXp2hk+6rdgOL7H5W9YesMGiwa//E934Exg/zp6tZ4IirIX3zlqpRqEuKkwyU1H4sXsK69ChLF2ino4bIXgQlUJw0UDqSvPPTJWzZTZk/en92J1XeIbqPnZQ3lU21a9XYpwwz350JxfQPURaN/8vvJUA5DOua4JGdBh0oLqVm/525eGZNGK4S3pYk8MxCX1ygnnN+k1053P32sCOlmh19unzHBu2BGAJ02i3EpcZbKpjR38gf0DOWRdsmwdur32UnYWPFvMwo4lMkRr+HtW1sC7DBd/LuCmqQt8SXEZeWbeUFVsjbZ1vVjBlbGHUW/CVfYmPt7CohIoEs6U95MANtuu4yaXGVY2btWoetHf38GiXmWHgQNRVTE0qKvoKeVgplElxC+4pw+BLq4hnFgW4Q5pfb0ag9HWJKkS/UTdsdbdxMYXD3tde+Vj5WNAYnovGZjOCTCKH5LZXo2UqOfsk1qTbJJlL6CAtG3+VLlkzLTWQ5rVlMUT1nzNmI/7QAKQDpSMpmJq586injxBCj0WHRegAS32nvM
 AbCDFZLZ
 wdJRCRQN0SFd6CrSwfbVt9t2dqEZlzhGfWjGWVIgLzLxhihq9/GQaHvz8jcSGflYE3tbfRgreLKuadozaMGOBHph9a3molP0ty4vEizeMFZyS7YhzGRBwU7b5HjeegtHRIAHiT5XsyqsZjqCuzr0d+Zt+yph/Eex3KxbgbXElDuqqN2x1X4Ln/yNm8Se7ytExzX88cKo8LD7M2NcCD2tZZBaXdW+y9Dnf3n6LK5HxY+9DUu/YbEzLgu4BuJEOz+ikz00DSBebSppwxHxJMyLryjm0S70rtBmADZDvNDTOyhDe/5d5usAr7AeXAPLN/3qOrkzR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 8:38=E2=80=AFAM Thierry Reding <thierry.reding@gmail=
.com> wrote:
>
> On Tue, Sep 02, 2025 at 03:37:45PM -0700, John Stultz wrote:
> > On Tue, Sep 2, 2025 at 8:46=E2=80=AFAM Thierry Reding <thierry.reding@g=
mail.com> wrote:
> > >
> > > From: Thierry Reding <treding@nvidia.com>
> > >
> > > Add a callback to struct dma_heap_ops that heap providers can impleme=
nt
> > > to show information about the state of the heap in debugfs. A top-lev=
el
> > > directory named "dma_heap" is created in debugfs and individual files
> > > will be named after the heaps.
> > >
> >
> > I know its debugfs, but this feels a little loosey-goosey as an uAPI.
>
> Well, the whole point of debugfs is that it's not really an ABI. Nothing
> should ever rely on the presence of these files.
>
> > Is there any expected format for the show function?
> >
> > What would other dmabuf heaps ideally export via this interface?
>
> I've thought about this a bit and I'm not sure it makes sense to
> standardize on this. I think on one hand having a list of buffers
> exported by the dma-buf heap is probably the lowest common denominator,
> but then there might be a bunch of other things that are very heap-
> specific that some heap might want to export.
>
> > Is there some consistent dma_heap-ish concept for it to justify it
> > being under a dma_heap directory, and not just an independent debugfs
> > file for the driver implementing the dmabuf heap?
>
> Well, I think just the fact that it's a dma-heap would qualify its
> corresponding debugfs to be in a well-known location. We could of course
> pick some arbitrary location, but that's just a recipe for chaos because
> then everybody puts these whereever they want. There's really no
> standard place for driver-specific debugfs files to go, so putting it
> into some "subsystem"-specific directory seems like the better option.

Ok, I guess I was thinking if the files are organizationally cohesive
to be under the dma-heap directory, they ought to have some
consistency between them.

But I can see your perspective here that organizing the driver
specific debug files in a directory helps with folks finding and
identifying it.

Thanks for clarifying!
-john

