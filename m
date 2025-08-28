Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBA55CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 23:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15B1F6B0024; Thu, 28 Aug 2025 19:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10BA66B0025; Thu, 28 Aug 2025 19:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3C976B0026; Thu, 28 Aug 2025 19:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D96356B0024
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:00:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A6899140436
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:00:34 +0000 (UTC)
X-FDA: 83827687188.28.CAA959F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 742C3100014
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:00:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U3ssYPyI;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756422032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30fk9NHjTb+YHallX3yV7R6e7ygOcFwvrpZnNLQLRbU=;
	b=CWt8Xe0mpK0luGXRj1ToL0o6IEtYyIbO5KqfhpJ6l3u/kIx5S4EkHZEpd1NZV1ugolAVSA
	eYH085RAEJ5YxCFRKslSVSAadv77UBgt3oHIGe9z2NkZxUNgva7EGFKfK7KopYPQDp1GEy
	idBNIi4XNxQxZJ35/FBJ+ARbD1ww7uQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U3ssYPyI;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756422032; a=rsa-sha256;
	cv=none;
	b=to07/QxYUbDHNIL8Uh4+atwKHfuZoloXS/zdDl5PMf0WZeWXyk9w3aVcnipTzD0GwFoHuK
	TXA5jalJ7JcRLWuP++8Uy6B1QHV8dgCk7xoGnDw8HzHitPGUQWlqn+F5+PBRHQwmVKcc/P
	QNNsQWWXx52RRD+ZK1/CMWJZuGxW33Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BAA9452AC
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D0DC4CEF8
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756422031;
	bh=30fk9NHjTb+YHallX3yV7R6e7ygOcFwvrpZnNLQLRbU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=U3ssYPyIZf4bYjFozVRTageNbBGWYnc0BLQHgtQCltO6D/wkhm6Ma8Pow5iTRUxn1
	 Ooi3zc5WYwmOGr5knJMQgsVpkf9TqEm8MilGpoORDWF1EDpalWL/2t3chxjK+JGmx0
	 Hwt9jdTB75A2Kxcc2WQ3H6YwutEKx6pEhLq4iU/tHRD3XzlAfIjPcbCMy3TSCFzFaK
	 9uu/dluZEdUB27iqtAyb+n6OwAocbz1SbqbQiLL1TRxyTDXUGW+JyWaK5+4ooS5oCp
	 NN2KfHo55A/69tSBlFlcka6JRfMKJI46BYY6ILyQ3eMXfisYnEkNEggK2P4onyoLtR
	 d/B7R6bcnFhhw==
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45b7cadd676so25755e9.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUoyaxXUEfUA9KcAf2GV4brSPITPQPBw2Rks0D/8bjMZf+HdFHtrgRoLA5weQZjxQyMeywxizOjiQ==@kvack.org
X-Gm-Message-State: AOJu0YwyCd7G7loxfcQJDYDNbUQy2fT2U2tUA/KASkIaj8HMkOsMrbUc
	KvNPhS7cu1FEg72HLKB+CqZrzUc4BhP1eGHBxARvK8B9lAkBNtmd7lVFNCeMXqlvVeWGvPI1jut
	OiA+EsXWSA5+uGe60KaYEqpdFVs8KjpgBCzlP6wyu
X-Google-Smtp-Source: AGHT+IF37cR06H6qWz1gtR2Q33GyRHew0V5B6RhMXUxYEwLPyE0Qes9gQWNNur2aLf3Td0YQjtjqefGyXYAmbB98VJw=
X-Received: by 2002:a05:600c:a408:b0:453:672b:5b64 with SMTP id
 5b1f17b1804b1-45b66a2b6b4mr5476195e9.2.1756422029193; Thu, 28 Aug 2025
 16:00:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com> <20250826162019.GD2130239@nvidia.com>
 <mafs0bjo0yffo.fsf@kernel.org> <20250828124320.GB7333@nvidia.com>
In-Reply-To: <20250828124320.GB7333@nvidia.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 28 Aug 2025 16:00:18 -0700
X-Gmail-Original-Message-ID: <CAF8kJuMcD4HA_CjK7iZ_47jgnu63pF-0WRrhdREvUmMVOgWBEg@mail.gmail.com>
X-Gm-Features: Ac12FXwgAj48kKV8-NSqN51LxVJutv6tGbA-WA_eygERRbP7T7KY6y3bnmWLRPM
Message-ID: <CAF8kJuMcD4HA_CjK7iZ_47jgnu63pF-0WRrhdREvUmMVOgWBEg@mail.gmail.com>
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, jasonmiu@google.com, 
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: utuhesxgcck6z89e6bsyx1rner4zmoct
X-Rspam-User: 
X-Rspamd-Queue-Id: 742C3100014
X-Rspamd-Server: rspam05
X-HE-Tag: 1756422032-298322
X-HE-Meta: U2FsdGVkX19OUaljw+Y3U4Ec9SXUYxMsPlOLlDmbRiTo81Zbwn33hena/kM2t2/fB0ZqilEbDnJs9+QXKsKbP/P4AxM5YTFrOwaKkHdkqfgawcm53lR5TF43SqHqBCFf3byNBk/g47uvDGd6tR+lDvHY2jOX/BtwV6nbr8gWCs7GM3rXr3jalPcbbo04L+mSAXEirybsnR82jDqsvO01Z3H9geqlMfVc6EA7V2cd16qoMbxxL713NmSAzHQ0M3+KkTB0V4sgMYNaOlA/yu7rIuTCT4ku2jSWdq3cJ1xEORbZC70elscr2K4Iifx0g1PDCkzyix27Sy+fsE7l81uyeE/KxW7PEQM7byij0IkUw3nr8x92qWeq0a2Q456tlNUabmUdlY/0KOUkzCarPsat0C9JQWwxkmm14mJ4yP1h6yT2IDsXu9HxJudMWmHgEhpwFTOq/NWg+dmUvVdeaTIgOpkqoeEcZ73B5vTQSuhRarVJNEKujQ/l8vltvWhsRlVb31poAIjYc99oMfiPx52Ap+gpHCkN7/RzN+IC1kkDBT538hFcbMehqHEiQgGM7Rgix54+T/5L5k2rKy0VaRV1kM473seopr2Kk65JpJJ/9LtzPC/EKjVFF8VX7BHhNl40OqN9lP6JWqm/JLG99f9lgf1tMtDs1wR6ta9kiLD8FbARfHdV4PheWQgKgi+HpkGljS5HUxzGkIt7fSY9SmB7LFTnf8qY31mAajRpCA0TgTojEkTOgj2c00VO4boAmxvzB8I7zfT6TDI7lTV8ccFSvCpcxGTSobWCuwJw7ngzG6Q8NX6gUH0Kl8N+TMdxPwGBox6P3NiQs40YhuS041xalkF9Vg6qPohpSKB5EHzcPNAS7mvazgqh1Mti5RyQLcSRL7kEzSUe9kyZm6Ib0ISG7ReLpAYl1D9/WDhGfAXfBDwI7dKyVKTS8/X1u1kZfAN1cbv/eGfEiy3pgROpgbl
 UyinCX1I
 mjB/HlaMbnl1pzQlMufgl1hYfXJRhsze9BYp76gydiXzmdmzR1M+8RfTtR1YIs6dOP5RT/j7oM1Me+R208JFN0K1ITCCdYrGtJHOEq9FtDQmoHXvbWx7/LR0b5/340sZ2uAjjPuKcIYAtvnHZAKEjdekGETFCaQ0f4u5k2nDL6KjRWkZxP5E2HMNByyxmWe668qrB2fhPUg4iXsNDI6+FSZFwBALYD258ylJ9/oPfPtEWaeGA54B0xTBR2+cgE6wVNt7NvIHNI0/m0F1+E5RX6MCu8LBfQONLRulwah76wA34za3RV0CECPvcIHmLJ6EFSofMCyWB4RkGxvJxlcTGTRdHrS9N61llwuCwPelUmNMBlMFJSsGNfNJ4Hg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 5:43=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Wed, Aug 27, 2025 at 05:03:55PM +0200, Pratyush Yadav wrote:
>
> > I think we need something a luo_xarray data structure that users like
> > memfd (and later hugetlb and guest_memfd and maybe others) can build to
> > make serialization easier. It will cover both contiguous arrays and
> > arrays with some holes in them.
>
> I'm not sure xarray is the right way to go, it is very complex data
> structure and building a kho variation of it seems like it is a huge
> amount of work.
>
> I'd stick with simple kvalloc type approaches until we really run into
> trouble.
>
> You can always map a sparse xarray into a kvalloc linear list by
> including the xarray index in each entry.

Each entry will be 16 byte, 8 for index and 8 for XAvalue, right?

> Especially for memfd where we don't actually expect any sparsity in
> real uses cases there is no reason to invest a huge effort to optimize
> for it..

Ack.

>
> > As I explained above, the versioning is already there. Beyond that, why
> > do you think a raw C struct is better than FDT? It is just another way
> > of expressing the same information. FDT is a bit more cumbersome to
> > write and read, but comes at the benefit of more introspect-ability.
>
> Doesn't have the size limitations, is easier to work list, runs
> faster.

Yes, especially when you have a large array.

Chris

