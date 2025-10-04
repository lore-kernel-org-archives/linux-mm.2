Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 265C0CCA471
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 02:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CC7E8E0007; Fri,  3 Oct 2025 22:08:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77C238E0002; Fri,  3 Oct 2025 22:08:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66AC28E0007; Fri,  3 Oct 2025 22:08:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51AE58E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 22:08:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E8EA711B121
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 02:08:47 +0000 (UTC)
X-FDA: 83958798294.19.021EF4B
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 244801C000C
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 02:08:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WaIqR4C5;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759543726; a=rsa-sha256;
	cv=none;
	b=E+JSbv9QT8IngwM76o1TZ2IYvNIhqiTHoQnsDbzRYHPTPj8jp1gc6Yfwf1pKBvvhRYpIQl
	0UmQHd9Y+jhXgPAyepQfO5V1ubSzqY0BuOMAGUGlxYiiwUv+0VzQZuZzE8y5UCguOFfqG9
	xob1vG6Zl94X7SaP5yBVDEOfQDFTx3U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WaIqR4C5;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759543726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nob5kKRkv8Qml7C9lk2znkph3asIUJ+dkyoMrrTUiew=;
	b=XdJjV/cvQbjjVusfYhft4RbeZQAWzxqVmNj/C52jWmMqxksh32rLSGpV4zat507oFMqHnv
	skTLO4lzvDjjPUCa3UY1NPrXXTg+pdNAhEwlcQds/GufOLPXTc3OAFl8qWpt5D7zr/Gm7T
	TDzLUqwnRSw6kUCSqA53J3nUH36Ryrs=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4de659d5a06so16837161cf.3
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 19:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759543725; x=1760148525; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nob5kKRkv8Qml7C9lk2znkph3asIUJ+dkyoMrrTUiew=;
        b=WaIqR4C5WXACQO2mdh2Z9W1XTRfRb9uFCvmbyWIOyIoOMrPtX+xVHHPq6R3ZLulp+i
         DaLBVA/teB3HdJhdEfobAWbsRJt1k1hwC4jxaCSpRv7beRPJOOj4B/vaV/LhK97fX9N5
         WUUkrIjLHuwgN7loG1IyoIqreraZVwOFydQ/xXLHv7FYvW7LWin0F4KG2qwjm5oBpaw0
         0gcjRSlvJtojuGp+d/zvFMrNIe8fFM3etBsC/P9h5CWC5VC9GNMQRMy9BUlcMs6tljrs
         7ROSzc3lw1O4jveLmjxQ5NaHCmGM0d7G6hW/DuMmDMjVeJ47Lk3GHxB3C7oegecrRyYx
         wZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759543725; x=1760148525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nob5kKRkv8Qml7C9lk2znkph3asIUJ+dkyoMrrTUiew=;
        b=VucwQ/qsTueP6hx6/40IrwsKWBnjqxU+vrbV3X2sKq/aTWSNHm/1n9m59Ke6dHy2Lb
         Dy8bcM3n6j6MjdNnLAlHTGkFyjLvUfQYJoa7PxHqBDJ4xd/F2dVwZFwpNNXODNHnYCNJ
         LPLp2tgi8Pl+Q7GBoHOZb1MYkDVsmfRVM8qJFpK41ioRwCoACPMrtb4Y2hoElqX4mqiM
         lEylpFJZ0Pl+0lTvenoebF2ZwjOeMbqX5pW72MzaUNV89Ty8A9TnI8l3bWKm8ENU7PJR
         Drqvbg5SDEaUyrkVHLvMdq9rgZPc7Vug1T+FLyk7jNlj+x+Sr7DL6LdXn2EaRm+Y5ORQ
         2V8A==
X-Forwarded-Encrypted: i=1; AJvYcCXtuzKM1ZSz5iuHN0dtbjhuBeVkvj+NiIK42BqpWqy73kbRgUVLaOv9loDqI32MPj3YsH5bweQ6UA==@kvack.org
X-Gm-Message-State: AOJu0YzzurcDgxk4FT807hy2NhHLsgtPM023K/ZHsz0FPGJxJp2POeZF
	R/RQw+2aqi5NgDhjyrPfRNi+hatxd9jUZBaOIZOLrnhHAZU2jBJ1n/cLkC/T+NgyhJprinHdO+j
	p4tGYcppGR30Om14pKIX3RVq+G9edF8aMTsHHJLSiyw==
X-Gm-Gg: ASbGncuSxm31W+NxSk882eEMNarbaamG9cRFwE7w7HRyvAktt1ld9SMAmWjW5Zlm530
	SZ3m4EaRO7nteFSI5K7t1EYasGE4yIGc5A6BSshtfHYKxW7zu6fSGlzDnal2VHwDkEPgh+n6M5W
	fjcX2ywOnp/r4WKutbGn/be3MARj27sgpAbM9EEvYGyKQluHH5kNck+HD0uGSlkUoGC7EJJBMJv
	5GIfbolKDqk4ia394YZ9uh9qeTu
X-Google-Smtp-Source: AGHT+IHbUzSApGmCRxnFWZElbyxsoU4/P0TZBLF0BzTvLsCV+miCnogbHJNniWq337bBkZeh/jjC8xT2gDd4cs+U3JI=
X-Received: by 2002:a05:622a:5c98:b0:4d6:173a:8729 with SMTP id
 d75a77b69052e-4e576a44213mr72478001cf.10.1759543725080; Fri, 03 Oct 2025
 19:08:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-19-pasha.tatashin@soleen.com> <20251003231712.GA2144931.vipinsh@google.com>
In-Reply-To: <20251003231712.GA2144931.vipinsh@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 3 Oct 2025 22:08:08 -0400
X-Gm-Features: AS18NWCqgXSjTPwyDSbb0KSJXp4c4gz9L9NTQCHF71G2zcSqEq0ghlLm9Q7hBiI
Message-ID: <CA+CK2bD+gG41LA5=kfuWh=zsYm5L9Dq+M8Bhg9-2sn05YvNfaw@mail.gmail.com>
Subject: Re: [PATCH v4 18/30] selftests/liveupdate: add subsystem/state tests
To: Vipin Sharma <vipinsh@google.com>
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
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org, steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 244801C000C
X-Stat-Signature: nbbpsope4t6di33n5p6xgupu8oxsfndo
X-Rspam-User: 
X-HE-Tag: 1759543725-187351
X-HE-Meta: U2FsdGVkX19Zh57n5W2D9LEwYUpTQnlztN4ACq3ydaQURn2Gap1ODJz1PPx89+FzVJO7BmWWv08lslG77eSY15lJxY0V+USy74wMWhzLbDEANvqNCGwnZwgVI3ZQ6+pqeGSw3iT9VKEmBOafvHGk3w9OWEQ1hWj/Qk/YvRxLI0cXERV3mH8Siz7R9LPss+1DCMMNOyGmHvdd+XXH8OxAY4QI0Y5PTjoO3ewd/DzMaB64W6F/l66Yvz9GE/Tx56PHD8jlVZsZXoSG8X/YMVN/z6eh3d1OwZb6my2qnyZ96AViguiTiSQqqYY/ocRzHkt2+pgqzX8ekhCgMGvLL5bHrMVYi6npiJFDwu2XjyHdSW/O56sh2nYypc30KMDN1hic1+ZsC8FjYXPxSsg/GrgbI6H0BnF/YuQfb6VOI8iQ04axvk3i2Shf7HbzHUPoaGBa64HhWomax/kM+BHEyrIOGdq3WxV7FLe4vBJ+Jy8aI9Ytf3M1KeQU9R4qppNs+GKAazxydsfr5apNyL7fdtjv5bQ9YpLj8uTo3ntU5jCjNth7ZoTwje3FEcElGftCFn8TW+Y20M7c63P9rwnkpnyWbNdnpSzk4KGpURxFx+VYIbWZF/xNF0KXcc4B3ZZ1VOSQtIo4bvIzRlRZvEBq+HTvfBrCGDASZVtqNVDJF3ZnZTZ7ZtzaCgJXk0YA6TUS2Xpqu1k7MZfa35lzx2sYG0dyjDvzk0sMuTYbAAT+Qdx9H86TuzwXFYf8OfNdjfCyB9awgXJFDHWaGD37lpUE+XythQtUIOT43y7L0iNxpR8LDYchVTlDrdrTydKQetlAbj5fJkNVFKaX/nsNLwgM+YwXDuHi2V7GBHlcwwuwkN7m29yhQn8X4Uf/J7l6EZVLAFORXVFUAcYad3lqs5nPMNuywstFBZDlsRMqutZ2WIsxynPAGe++H+cdAJDROX8/bzh3eiT0yg8VBMR3Mr/Xow9
 Q6Q4Tay+
 37owIEXUGqHTQAki0bFEjXqv7i6+IY0YW8xpBOnt4B/u6x1wRMzcGFxz6l17CxE35F+9OIRN58kBDhk4ZiQix676jfjub76HTS17kVi6wpzQHBxK4nFLU2elwgJHefXdfQdVkcTjttSQRPHHyUID2w4Tic/1nj1ZH7MgvWSbCwvbn0HRMeCcN+rPKe7Ugpa2P2dB9wJIpNPxcELvOIBaRLti424Ipn8eEKCq1cHvuJ01PWN38UPpkiU4rP3xRK52DsVIpp+d/gFHcZCX9yK8PfyA6PDgyyU4ttoYY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 3, 2025 at 7:17=E2=80=AFPM Vipin Sharma <vipinsh@google.com> wr=
ote:
>
> On 2025-09-29 01:03:09, Pasha Tatashin wrote:
> > diff --git a/tools/testing/selftests/liveupdate/config b/tools/testing/=
selftests/liveupdate/config
> > new file mode 100644
> > index 000000000000..382c85b89570
> > --- /dev/null
> > +++ b/tools/testing/selftests/liveupdate/config
> > @@ -0,0 +1,6 @@
> > +CONFIG_KEXEC_FILE=3Dy
> > +CONFIG_KEXEC_HANDOVER=3Dy
> > +CONFIG_KEXEC_HANDOVER_DEBUG=3Dy
> > +CONFIG_LIVEUPDATE=3Dy
> > +CONFIG_LIVEUPDATE_SYSFS_API=3Dy
>
> Where is this one?

I removed the v4 SYSFS interface, and this line is a leftover, I will fix i=
t.

Thanks,
Pasha

>

