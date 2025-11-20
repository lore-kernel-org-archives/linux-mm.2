Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7FC0CF9C7A
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 18:38:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CDA76B0027; Thu, 20 Nov 2025 13:38:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07EAD6B0028; Thu, 20 Nov 2025 13:38:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89AF6B0029; Thu, 20 Nov 2025 13:38:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1D4C6B0027
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:38:17 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE15EC020C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:38:15 +0000 (UTC)
X-FDA: 84131845350.03.679A475
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id C70C7120006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:38:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QIXdh9sm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763663893; a=rsa-sha256;
	cv=none;
	b=WPmnci/glhVEFr8dkW1c964oU27L/et1Wru9/SKusp/RCTkSHCzUBDAjMoW8to2AaTtGji
	v35UyH1jZ+8oToVEY5hs83/kUdx3GxB1u+VgOU/4mrgpVFhybMk4QhkodtP2vV5HfyZcd4
	F8pzx2klUEfytfPcaucmjk8UmcJyeJ0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QIXdh9sm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763663893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XEixO8O0Sgt+Lt6PLSkUIcXQwGzn13P0qmJRoyPv45k=;
	b=qV/ZUvBvlcrebEwDWG+kV32J2NWI6j2SP9fPEsVdH/D/mxmNuo//PjWkrldvw6VkSuWMDJ
	2iT+Sv5Bs3BgLOOnn9+rgwIri578yYnBqSq8B6pFjGmYtw4hb+QHQZZLpBVvWoxHUQeoZ9
	UPffAP95MYOMRQrPB805sQZKP8h8Yc8=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5959105629bso1144675e87.2
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763663892; x=1764268692; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XEixO8O0Sgt+Lt6PLSkUIcXQwGzn13P0qmJRoyPv45k=;
        b=QIXdh9smxB+fXMcqLn68MnBXPsIHKUfo+Fo7+4Aab7KmggZYyFcUo6ojx7cCebWgXv
         KzJvrnXR8Xs4qsLVTwwALPiiyL2g5UxvYnF/R2MjKbnF0OnlHA26fwBWxmNdbp4rQrzI
         ElOGS0iukaOh7Nlw6DoR35gWMUl37gR0XmP1FnYkmmzXTzsMyjCTTbsJPYbuNBzqY8lA
         NSv67pC9HapWqmdjEQdL6ojKoOisAJUgayhYGAkuvDUB6/fU9iyEOmiR+2lO+TWj3aNb
         ZwWlK635qMhpZ+p4KZJadeUxuckiFy5+EgdyMq8kceVIl8P7yo26UkNtMjFoKkiUU5cb
         aCZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763663892; x=1764268692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XEixO8O0Sgt+Lt6PLSkUIcXQwGzn13P0qmJRoyPv45k=;
        b=prj101TjxkzO8IUG71wMZkyngyMjOg2++4WiyuUrlUa4UzP6khS81m/34bzUuy/XjB
         nu6ZEdcSSu1tG8gC/9xZTOQq8Vly5ynqFitZL73YqYlDS4+sUxk04pZGkcw8oNYafSH6
         77GG2+ZKuMYyQgBbmB2lu3gJLXw/+cabqoARUh/FDmcsX5i2ja4yGiWdvCiQjZrH7EEm
         HRI4ltpN5+rYEUEie9/KOPbKlpMKLDiEs49c+0zPTqr/uo1NqNvj1GfCiBBvFTEbLt82
         GhmxO6G++rSkeXl1wT1eKZ2eGXSkDwHKIwv72QhHlCjdy/tGZr/7w3OSW165RA0hhVNU
         nMPg==
X-Forwarded-Encrypted: i=1; AJvYcCXAPuBjK4E9kFy1Jnk1CUMwzV17dCQfr7rDDSCDD1y5+Rcb/4QEEWqwu+BCCTThxT6eaMuXzwHV1A==@kvack.org
X-Gm-Message-State: AOJu0YwnBN1OO+XSkPKrj1KdKu5KvWfDsEG1V6uLE7s2UULb4DP+YgNL
	WJ+U5f6lj7HHXrEa4gFXy/tmhxzK2QqdCgxKTU1Oh1xnqcsjAhczplA0cvbulOwJ5w6mgSK9lJr
	EumWc9c38dhZpalwsTQo967vFJe0BCCM5OcLZwHnD
X-Gm-Gg: ASbGncvb6Sl5XEBlQ88OvUEiHxkIAoc2mxk9l2hE1RZlk1u+A9ntUT/4zdgTDkntQqr
	avv5QdK0d7esoHYwHqxude3u53XN+wLFPXv+ttsbDNhWtgLjD2Qb0HFDrOxaOBT+EsonO9tS8mV
	eNB4SnFvLVflvxgevXxeY9S0ZVrRs8/ws9+MftVMArRCzrvxC3khootCTB9MWlHC9VsHzl8sROe
	WERYhQtMa5Cq5AhCQwXD0x5epH5BCU7Ma62QnrzHZ5PdBSlGldlVqIMaGQn5nUCiy7+mPM=
X-Google-Smtp-Source: AGHT+IFxGlfrzESORJlhJ+sQ1ptMndyIY9+wnuGK/JMRNqNcwAbgDqN1vNXo1wzn0/v3S95tUN0EH3tcgci+Oz3slSE=
X-Received: by 2002:a05:6512:2215:b0:595:7a6c:7dd3 with SMTP id
 2adb3069b0e04-5969e2b50d0mr1513169e87.5.1763663891285; Thu, 20 Nov 2025
 10:38:11 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com> <20251115233409.768044-6-pasha.tatashin@soleen.com>
In-Reply-To: <20251115233409.768044-6-pasha.tatashin@soleen.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 20 Nov 2025 10:37:39 -0800
X-Gm-Features: AWmQ_bm8564IWabRa9o-QUB5L75hdON9Crp276hpUHsnCI8idLYa3aONINMtLrk
Message-ID: <CALzav=c-KJg8q8-4EaDC1M+GErTCiRKtn5qRbh1wa08zJ0N4ng@mail.gmail.com>
Subject: Re: [PATCH v6 05/20] liveupdate: luo_ioctl: add user interface
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C70C7120006
X-Stat-Signature: cd88ib6kr6rshywdm3a5xp718spssiy3
X-Rspam-User: 
X-HE-Tag: 1763663893-838668
X-HE-Meta: U2FsdGVkX18jTRi2OxEw9hKtjVVmFydBonT2GsZCipHX64Nh28bUgRZS3WX8MHdmPs3mOB0NnsWIhhTqNBI0g0W9GjWD0KJt+qsoCGYW0CszA7nwgIzER6M15EQHHvu4fW5jZtw1OBvpYvIyxy4U0in1n7vVcMKumCQ2prCb80cPbJZCsFOxL21m5Lf4wCRVh0L8T/wYT0ixvBthiEcDJidAQqaUUlnkvZDIHbsub5kPuMpDaB7b85yEZ9oRfsP0Py+xbOYp+JmJH0DcsaZ7xv1JvnEgcA2d/ueQvs7DalwcWZMWfU9aulF+0yMhTtb4LJ0f8GlleTsZMFmneM93CZVgQpF6cH0/WF8In5Cq/lFHGHHrO3dHcV62u9yVBSVFCecam6PdXzFuOSCmMTfP8NjKJPZvfcm1qsS5zs599kh9wXna2MJQpqg4Vy5YbMCnktSCzoMt3/NT2FKEJcVBezuafy3sN7rrK2TGIuOFOZ81wMCSUcrtUuJzCbPUnHu24bem8tAHA8I8yzP3LoP9ulX+haauzjkAV1vUBJiv2sohJ9SAJmIw8lRNR5ZTuyY2mTr1GMAZpQbxFRf3B3ujRtz5uVOQEPVptzDTAAJiOCR0bXQWygaOLyyK/m1z++4gfCoqUtIZHyjKMqlU2nZleCKWdXxRuI3M3sghMzE2CaZbsAs7W4DSLFQaDjwujicWHwrzqb/5tT59dchLfV48NmApERSekCw3jI+n9mZoUGdrPPbSpGhXrtB49OlSrBWKwZLpRH5BOrMyUYaq6zfhKuAQCxuemHaGbHcz+CgScBw932fA2OGhZEJWPB9tT2ChZBPPvH32SEAQKv+DuM7FeAS/fLhXs6EKNJxmHhdi7rQ9rE0B2gRkbla6OAL/GEcY6l005bskgjCa/YP0hL0FDtumunvCltf9T0H4udzSD3wdwzIA9JWZ8zh6IOADNfx35hswPsNd2AqLTe+3eoc
 0IsL9nRW
 dp0HsIkQyr5pyPvcCdE6JJWk/3x9hGWEkwsDDjj3q1LkSGjTB6S/LAPnwQpF5c95Jz7GpPD43B8bUlB2jRlmlrk8MRtQ3hlRIFwUeaom/DuP2+KdChQTc04d8wztktUFM2JL4jROYPic6GHRBu1Qi0HvognC8p47SQZabTMpxjTLWi2PX2kn5ukpRtmjircPzLFqRZh9VCmmptRGeQkGD5Y6A7tvzC2SHCBCyFjIVq4aGKcR5Vy38Gcgp3XHbPRjOruFTrf7UFVpu2t6nS1AtEhfqcdTnFYTIp1smDQJtQKyOOlvHW2TBcCiiQ3yZPgUJGMUJedKJul2vYIUNivTDe1V97hT2bHdJElXVwu2cWDfraoOX5na62EFWlcsorIiVq+nHpjiqnCTYVkI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 3:34=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
> The idea is that there is going to be a single userspace agent driving
> the live update, therefore, only a single process can ever hold this
> device opened at a time.
...
> +static int luo_open(struct inode *inodep, struct file *filep)
> +{
> +       struct luo_device_state *ldev =3D container_of(filep->private_dat=
a,
> +                                                    struct luo_device_st=
ate,
> +                                                    miscdev);
> +
> +       if (atomic_cmpxchg(&ldev->in_use, 0, 1))
> +               return -EBUSY;

Can you remind me why the kernel needs to enforce this? What would be
wrong or unsafe from the kernel perspective if there were multiple
userspace agents holding open files for /dev/liveupdate, each with
their own sessions?

