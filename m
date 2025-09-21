Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D09A3CAC59A
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 22:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC74E8E0003; Sun, 21 Sep 2025 18:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D77268E0001; Sun, 21 Sep 2025 18:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8CB68E0003; Sun, 21 Sep 2025 18:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5EEB8E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 18:21:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA7881A03CF
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 22:21:29 +0000 (UTC)
X-FDA: 83914679898.09.C6CE4A5
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1EFB140005
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 22:21:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ehq2jUEG;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758493288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHLyAWNRRvZ698aiszn9fxUOIJUP3t6BL2WpPwYPRag=;
	b=zXtFWpUcQh5yv1VhOqBo2+ZeBH1EKGVQBEXmYlesL/YE25ZzUg47rf2FZYvMyQI37U54/Y
	teahNJMlSjbaZRBhYogUTjGmvgAo0J6s/dEmMp4v4c/DLaJPdSh0h0vRwN6xQ94z2elq0i
	Lg5rwRFLYJ5YJgEDBHUwJsYcNhKhVDI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758493288; a=rsa-sha256;
	cv=none;
	b=wa7smZ5UXIHunMXZ47Y/x5hw8Y1R4c31Hc6H1QDix3o1tkvco/vKsYJFK17RkLQbvtBcFm
	eplTetWeICvfoT6Ve66AjBxcDBRhUubij6aLe/GjE93A9R4NS5e+emiZKO3oRPe9q3ZC85
	Sgq0b60T3oTmQnceYqy7pvGoN1k18OI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ehq2jUEG;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b3d3f6360cso37567871cf.0
        for <linux-mm@kvack.org>; Sun, 21 Sep 2025 15:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1758493287; x=1759098087; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PHLyAWNRRvZ698aiszn9fxUOIJUP3t6BL2WpPwYPRag=;
        b=ehq2jUEGhhM9TuLQW3mXS12xk3PoQ2P6u5rwIizN14okF+ja1aEbXMfy7yfmmnRi9L
         URmekmGwx3v7p7aJmWm/uvBTtyQw5xwL3P5uacx8S3ty/V4iR5y8D1rEmSZui1ivBMUz
         BBqeBqjmiFbQdmwrcotsYl139rbG2dz98hcGfl7/KAapc15+VgbRiyV2iHudVezxkeSX
         jvzJ/mADx93SuJyAD9OzFZ9dTyk/JS0Gykjs9q793by+waZlFhtynhD+r0VsjsMNpsKp
         rZ7pnpJuUiT0DzQDF2h21ZzBSX7PG7TGG2MPj2L/KaE9+QEMdsPzqRpYKfnBfo390AU4
         wHLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758493287; x=1759098087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PHLyAWNRRvZ698aiszn9fxUOIJUP3t6BL2WpPwYPRag=;
        b=HCdlQdzrQbLJsPjTul6PWfTk+fbunOaiQZleWRNmAYteM8VUfXVlo2NtbSaXNMK8iB
         HLUKAsRZRjmGVFqBpjFOdTzynH32rzqdtAqpFdNYoUFrwk3WlxFY07eJ3GIvKnWsHruO
         u6coHnVchh5JQsv/6miRKSy7f8ScsQBciFKo09lR4H58DRkU0FMSD/EtPCzdoBXuXB1G
         5dvLfw2a1D7RTb4jxezwwd4Znj9ncegu5+g07460OE4zwaFrVeG7EEd2JcL8iPo/5P8e
         IwwaiXhK8FC6kY08bRgk/bB/IzKvS5yts0iT0CEWyS7KPQGick/hZ6embaE+dowDo1Lz
         /uGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHJqb+hlI+T7t/3UFDiW90osDnzUlD8ipobIkzsSqvShAdHAjFDeLFiit5B4nKqjIo5rcr7TwGcA==@kvack.org
X-Gm-Message-State: AOJu0YxV+kS8Iubm7Rr2OHlwJXhcd4cysaqaPoa0cb/3Mck8sgqaT7hz
	hvurp4/b/rdoNnxQKT9DF/kEDOyrdbOgfm9KIhAhwb+Xe7FHWHmrM04Rg0O5VvEpuEO5jLwZt4D
	952qQbu0tDTKM9FqDX4LQPFy9hdXfTSjRTAP5QGbdgw==
X-Gm-Gg: ASbGncuqPm+LxFUhsfwFB8Qgi5iB4tGu9yK619vo86QMUok7pkfCVZFZMUVFU4xMzIO
	zwZGveuzke+jnnLekoEG6QvzBi3j0hhFD3vDl+LcR+uNepkknHc/WKTCpdnli7ZeGt9buftHj1J
	OwDjUTN07BnpsQYUiFMsbw4Lji+eWakcHgNOylBuvfYWQpiVarsrBv/opoLDikxgF9iPbiKph+t
	8yvEYg=
X-Google-Smtp-Source: AGHT+IF9Bd/LCK7h6/iC83qqAy9wLiFHaZDvz7ruwA4mtaZ7EwXHPx8srwbwmVkArl3yVoSLBLTkv5dGYhCDZ5ZrJps=
X-Received: by 2002:a05:622a:4c06:b0:4ca:10bd:bae5 with SMTP id
 d75a77b69052e-4ca10bdc5dfmr21648151cf.81.1758493287147; Sun, 21 Sep 2025
 15:21:27 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-8-pasha.tatashin@soleen.com> <20250814132233.GB802098@nvidia.com>
 <aJ756q-wWJV37fMm@kernel.org> <20250818135509.GK802098@nvidia.com>
In-Reply-To: <20250818135509.GK802098@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 21 Sep 2025 18:20:50 -0400
X-Gm-Features: AS18NWCcd-5oq0uHFf03h4LWbprCKHRBHh45SwiCRQil-ZYQKwKcHW5Zv6e3HKA
Message-ID: <CA+CK2bDc+-R=EuGM2pU=Phq8Ui-8xsDm0ppH6yjNR0U_o4TMHg@mail.gmail.com>
Subject: Re: [PATCH v3 07/30] kho: add interfaces to unpreserve folios and
 physical memory ranges
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>, pratyush@kernel.org, jasonmiu@google.com, 
	graf@amazon.com, changyuanl@google.com, dmatlack@google.com, 
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
X-Rspamd-Queue-Id: 1EFB140005
X-Stat-Signature: mqp64zb4wnpmj7rxtscfp3r1aa4m3m91
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758493287-767429
X-HE-Meta: U2FsdGVkX19CJQOxi+yKhntuMXViQfIvMJ+n14bwetY0Z7B2I3Qt12byFTgrm/Azk8dqMBpkfcFFK7z61l+jE7pIQgC06yFoDKs2wLKGUQD5Vhv2X20z7SSy6NaoKX9cXU1dmGDlferulf8oQ/ILeHkVh9T13nin8qU/pH0E90f15RvzSthohxk+Mp4ZmISV27MeQO9dtYcixZangu3XciOHnNYmaVXTdm/V1J6BXoH5KTbuS/KthcJ32lBR4lfA+qCD+sN2KrgpaVb1M6L/cLMPd9VXjJ++BTh6Os0IuEQM7dQrjkp9TvzhzJ5ZUQ6D+PcEas/mJNw+NtBgqu8alj2ygg6VziDgngRZM7YC89zAhpQvPBo95aBzVfEUnbkE/dWvTGrodcWVszwBZpCkaR7NyaNwFxd1jaxIaOMijVR8deF9CNQz8yvz+AKDNU/zr/gvgzpJzN5bc6O/lQ1176d3s9PIhTTfqSyJ9WcAK2pkxsOiy7QPY1EOPMgvfB28jvYKCf+iGz4BZgsNfXMs9EeDjlxWDC80Bo+wp7nPQMj2JeIdTrQ5qId/BFn3pQ2kDQk1aFYfbiI8QenkqaMZO2eOJp8pGUkWzx6qS64uGLpV2QlyPkh/YZrKpAesh3x9Ul5sVLOSwpBYGYrUP3jzz8CgTN0k0gPeMyyjuC6+jjO/vvNpjIxj1TOETG1SZXsSene+eqX2fy7xdW0OAs5NjY2aKnqbP+LkFn2np5wKaUZgmV0rccb+SrJkiA0lRzvLQ7RtoCaiinpGRSVpLl1vGBxa9kmt1cRFwjrp1hA8V8clXZu3qe/GU09ibXK+09vx2jLScWbf4RZcCwzDf6GJXJqpFlwbwc4LLrLQYlpqb1qIspmAFIkKxwDLXU/YdUi1ifLdfD/+2p83nx6jR0n3/+tNeFHr8Bznua1bQgBhtf7+WiTGJhl3CYuVZ1ojh5MOpVqD7mdr9TBI8r/W9mV
 Quh7B1+g
 VuiVJIrfGxjBw1MFKi7BchJkLTfXpEVASXlh89LcVo5NzzKj2+jABy6HaXwCmSFT6v7tWaL2y6VBxoSgcGkbKlU2IYZgYEMUUPgP+D3K0ytTZwuOsFWzAoRFpSNmPhixzIDQVg9PYFsHlPNLsdTZTY01yZp7fkZVt7ZSuPH5MAzHz+Gn62rdW5suq/6NIa09q5eQw/4elwZxAdqkKx+DwEBS7t70JkP0WxqVX9B/Lya2pt6vZM/iC6TCfVPqdxPwwAGbjLeti9sXsStKhnp1Q+9W8CxbU8ZamJliA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 9:55=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Fri, Aug 15, 2025 at 12:12:10PM +0300, Mike Rapoport wrote:
> > > Which is perhaps another comment, if this __get_free_pages() is going
> > > to be a common pattern (and I guess it will be) then the API should b=
e
> > > streamlined alot more:
> > >
> > >  void *kho_alloc_preserved_memory(gfp, size);
> > >  void kho_free_preserved_memory(void *);
> >
> > This looks backwards to me. KHO should not deal with memory allocation,
> > it's responsibility to preserve/restore memory objects it supports.
>
> Then maybe those are luo_ helpers
>
> But having users open code __get_free_pages() and convert to/from
> struct page, phys, etc is not a great idea.

I added:

void *luo_contig_alloc_preserve(size_t size);
void luo_contig_free_unpreserve(void *mem, size_t size);

Allocate contiguous, zeroed, and preserved memory.

Pasha

