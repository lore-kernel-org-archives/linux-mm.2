Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96762CA0EE6
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 15:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8BD900188; Thu, 14 Aug 2025 11:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A96D900172; Thu, 14 Aug 2025 11:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19881900188; Thu, 14 Aug 2025 11:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 04DCB900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:05:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 697631A0709
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:05:46 +0000 (UTC)
X-FDA: 83775687492.11.6B2E2AB
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id 75779140016
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:05:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=e+8NSf7b;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755183944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4zaTlP5pzo/qg9qINxtiKx2DfK943m3JT2OR6iyYMuY=;
	b=nJlnPIa6exIF3wVdbip3C/EeP6BiXv+0o+LBjPZGRuEMAELbpAMriHDEO7XDLPKVOb/POU
	domLOIM7Dram7sjsIqkG+dzt1q0I9n4KmCqVA9yx2kB2tpCVLPCsUu+Hp0F+wQXlhzqt4r
	shMWVRDoWHeW+3ATNblwQL5bWkaU92M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=e+8NSf7b;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755183944; a=rsa-sha256;
	cv=none;
	b=HlSPWPge6Wj7y7dlof+CSWmfwQXCuhCLFTzNpXsqyAuFz4Rd3dj+FkQA3PlWTK37YasFyD
	HznxJFjjjCTQUAmEt12MHIdgWVJvzPtqZXegCz7L457qedL7pghrKu9g+/G5QuEkh3rI/F
	kXNkNhii/TyUFO8LLOpqR002Q+A+WEI=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b0faa6601cso21451281cf.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1755183943; x=1755788743; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4zaTlP5pzo/qg9qINxtiKx2DfK943m3JT2OR6iyYMuY=;
        b=e+8NSf7b8tynSmf6FIX8VAgRmstVoOngoF4WHHR6n4FOrLjMei9L8IhsqFLOm7L2kq
         ctt7MW4/uXAsWcAdaElwXrVc3mesrAN5zdBluirXRG/PTEMKmh0Y3QmsWY3MFOsO1lCU
         xf5iDa+t5dNMprwh4TTWzDn2KL6R6e1iZnjNmdHSv1klA+2VSmtN1UvQyt6zL0fYosT3
         w59/xWDP9DgkNoOynWBVzZnOnUU6b51n0An9xvcfNA8VyXkfRiw2PXa0Ubf5KjJ/gnww
         7vAUZQnCAhEy6OfCr8sItJC25Bh9rx+MvqLyhSsMVklWyE48bKGYvtpZqvR/IsvGTsum
         wckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755183943; x=1755788743;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4zaTlP5pzo/qg9qINxtiKx2DfK943m3JT2OR6iyYMuY=;
        b=weObdjLa+kYPoZ6cnjbpMMb7IKC1nGNIYIlx9HaUSMpgdahy+EEtm5J2e2Tzv0wsvJ
         ZudfzNawYf5e+sEHqsdZWVhj6TuSVtxyw4lZtKh2Duuz1FtWvmpWz66uylLpw3wgrFW4
         DTq5AUpJe9DOqUECgGKMvxVY74oTYZRbZug2J/Ch3rmwWxkAptP4j4pnm8Z61DfS7utU
         7SfMTJUEQJo/Ill4gSzco0G4voPYhenFwvvmxHn3t2cShEtJ3isrM1JzSkc0xYFqfyko
         BtD1z+aHvczSyOp8jD4l7Beohzt7/2JiVO0xsvydX/7VT8fqFVz46JDeG8mWGBlnZF/B
         UjMw==
X-Forwarded-Encrypted: i=1; AJvYcCWGa94sSsg3Ocyn5VENg5wCwDKAnqh3rZzUz2YmkzOh3Zq0rMMo/Rj9kou6TMv39UtU9xzAj7V1XQ==@kvack.org
X-Gm-Message-State: AOJu0YwE8AAUXPH5D9RzzsOt/e2ZIDRsBFN99iLdVNHR787piXwN0ly2
	bQiSz96ucYEdxF7+dvJ1nSJ7q4+GcELuCkfpC3qbb/emdJEo0Yf8LSIsMxo3bqkg2zz3qOvPa9a
	ZJFrKS5CfMl+5ouMGW+oCmoPdw7L4RVaan/9/CfWYHQ==
X-Gm-Gg: ASbGnctN8kQziMHUMLn3Zs/QzPphIZRzZz7qeywI1I4L19c77wg/+rwYKo0HfMqmfYz
	X8vysxxXOZbzUG8BxYaW/qgZlinDRINRsXlXOB+zpyDbmQDuX5UVDGMq6ZjYaibuhmNYWSvUywj
	AorQC0MIHo5XiZ9hW/XqXt8hBCX9VHVFoyRCwpsWcHcQeIvCZgDwpNyKhH9jaz1sVgZrqKplne/
	W0xdt6LiCELHlc=
X-Google-Smtp-Source: AGHT+IGd/DJ84Imu5KYRHkgnpNm4NZ636lX1WUQFrgSI87aMZKq+0zSxGBg+110FdN/squBIYOywjRpAp8ettpbigko=
X-Received: by 2002:a05:622a:5e09:b0:4b1:1109:6090 with SMTP id
 d75a77b69052e-4b1110964camr21827551cf.4.1755183943358; Thu, 14 Aug 2025
 08:05:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-8-pasha.tatashin@soleen.com> <20250814132233.GB802098@nvidia.com>
In-Reply-To: <20250814132233.GB802098@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 14 Aug 2025 15:05:04 +0000
X-Gm-Features: Ac12FXy7hDZjxYMY4c9rpouOJZeOk5g8OwQ5wREtab5YlBDjZqQf27ADm8vAB8Y
Message-ID: <CA+CK2bCbjmRKtVVAok7GH8xvh8JWrga5Oj-iK-p=1M79AqvhRA@mail.gmail.com>
Subject: Re: [PATCH v3 07/30] kho: add interfaces to unpreserve folios and
 physical memory ranges
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
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
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 75779140016
X-Stat-Signature: mhu4a73up1r6zcijidpwybbbu4z41fu1
X-Rspam-User: 
X-HE-Tag: 1755183944-316061
X-HE-Meta: U2FsdGVkX1/YOsXdafArqCyFY8r2MuHovgAvHZMoc/q4czYtiaTaF/lNZzXP8xNkJfIyKSypoVS/mCWbOb8PKeIUydpKy2v2GoWE8HW2pin1J4x6HZ+kHS+N5r43eWra/a1Xm5fhM0vl9ZpS6X0JRdZLeJloUrkcxnBi9PE8jh9ag+gsRtnWyWoBy9nqpTfJZbG42bzWlr2C8+F1ZO5xA0MMCGVaUO7dkHVLuQ6FreBslMxPMsEns4gK7nfAzq/aO0YS/9whQEq2f7zlNxbsg17nezSv0IdbaUgz57S4XL92TiO9EuSYttrbCN5EvqEWFGTOBT/EuzPp4d4FKgnrSp3sEL8U8z945OlF6JRqNMaLZGfMaRgNBrrlUjGmFJ3FG6cKnYFXjkgRsyifQntLysWO1YZdXcDHUvoTG7wuCWKwP3UzYjZSNPt38G23lRy0irV9PMAwL9gM1zPdWS02g/N6ZV1YaEeop+hrwEN1It4NSIcqYq/UtlskVQph8qrTyfoFkeuYWFqDjoxqjvw8yYFcOj7hTUAQCxl2Sbn1KxD27tjHYrSR3iEgzsoYIICm6wlkl+mSsx4SGlpvqvYGOwNrmNks9F+DMI/g3Zb/9PrFVLePH6kUPoIvCYXuP5rT/I5yJCTbkSgpI3fm/8+1zWeafHBG1tfTXsfwFSnA1hoUB7L3r/8WqIkEHPLQlYtGP7q+YtA3EJmDdJb8o5OTFbrL9ass8h+V5GwfLWGiAAswS6rUaypr06Dt1AW69B1GI/WMXgaicU6ZrG2tkLLP2CaH0ywwWHd8fahyaB7DMwm67OVTrOIZEH8DR5OtJqLQxTaPazrj1Qfn8VDZfcJA6ovebt80CGo3PoVzejMXqAURk4SIJciAPIOZJuedHzHqupdD6qzZWfGFRl2MuAHx4lvMtxxcqYUGO4oxhVZn99uqBxGVKfFZnu8JvBQNQaOEXz0cMM1MsuGNFc0Mhgr
 djbx3T6M
 gwbaAKfEpRwrOFesmLpZMySGemlVi02FFFqitpjOkKWyQFL0npicUGbgVOLQLF2+gQRkR8ip76qNJDr72/Jq1tQesBNIYpo4PWAI216a3XPgyuh56CnbcxekvD1Liuq+amtj8QX9ajuDKjzMNPyOrw1pCPOnUEGorHmrKMf4uKVwLyc6dMnU5p9RTwPbo7/ap5MjFMzPDkN3Q7H1AbBRAu6fdccVmWibtUSvqNYhSZ4LhtiSchXIFb9Vk/q/cXy18Nwhd9vro6IEhIa//Yiotqmwp1MVNqDM0V2FT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 1:22=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Thu, Aug 07, 2025 at 01:44:13AM +0000, Pasha Tatashin wrote:
> > +int kho_unpreserve_phys(phys_addr_t phys, size_t size)
> > +{
>
> Why are we adding phys apis? Didn't we talk about this before and
> agree not to expose these?

It is already there, this patch simply completes a lacking unpreserve part.

We can talk about removing it in the future, but the phys interface
provides a benefit of not having to preserve  power of two in length
objects.

>
> The places using it are goofy:
>
> +static int luo_fdt_setup(void)
> +{
> +       fdt_out =3D (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
> +                                          get_order(LUO_FDT_SIZE));
>
> +       ret =3D kho_preserve_phys(__pa(fdt_out), LUO_FDT_SIZE);
>
> +       WARN_ON_ONCE(kho_unpreserve_phys(__pa(fdt_out), LUO_FDT_SIZE));
>
> It literally allocated a page and then for some reason switches to
> phys with an open coded __pa??
>
> This is ugly, if you want a helper to match __get_free_pages() then
> make one that works on void * directly. You can get the order of the
> void * directly from the struct page IIRC when using GFP_COMP.

I will make this changes.

>
> Which is perhaps another comment, if this __get_free_pages() is going
> to be a common pattern (and I guess it will be) then the API should be
> streamlined alot more:
>
>  void *kho_alloc_preserved_memory(gfp, size);
>  void kho_free_preserved_memory(void *);

Hm, not all GFP flags are compatible with KHO preserve, but we could
add this or similar API, but first let's make KHO completely
stateless: remove, finalize and abort parts from it.

>
> Which can wrapper the get_free_pages and the preserve logic and gives
> a nice path to possibly someday supporting non-PAGE_SIZE allocations.
>
> Jason

