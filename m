Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2BFCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 14:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1433900184; Thu, 14 Aug 2025 10:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EBD6900172; Thu, 14 Aug 2025 10:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9288E900184; Thu, 14 Aug 2025 10:58:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83D9B900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:58:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DD0C160664
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:58:26 +0000 (UTC)
X-FDA: 83775669012.09.9005856
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id 22B631C0011
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:58:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GbiPNFQh;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755183504; a=rsa-sha256;
	cv=none;
	b=5EcZvvjOGkWrnMdFsYXpz9i4HSgkODc4rWSQNFpPb3b4GCBGmjcWC5KdlVLuLz7mLrvOh/
	EBCuDbl0DkboLOGt9TYneqj7/1kRA3xoBEvnWq/h4XTirGJp/zJPypW02Y6po07OpWkjSb
	cRpqzeZklozCWNSiWIqWQlxZsNDy5NA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GbiPNFQh;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755183504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0sgUd9YdBOZy0kVdBoXU78NUeqQMRVWLT5DC2WvX4NE=;
	b=Ho01x/SYrl3VN4FKptgdMopZhind2oEtHNQ1ULFM5xzeroSI43ARqGD61SO8fkH6VrJR9Y
	aBcvQIw52nu2aundUOB2/VfSSs/A4PqlQTeVsafXzBIntB5/JvW1tnIy5bbvQ5hraCufE9
	iFzCN4rktunGl1t+hNMUFTIONhGzzcs=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b1098f9ed9so7069981cf.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1755183503; x=1755788303; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0sgUd9YdBOZy0kVdBoXU78NUeqQMRVWLT5DC2WvX4NE=;
        b=GbiPNFQhzlDzSwEdRYFDKJpiGKitEkhcwA+BmK9d6NCiJdlYb/CcMnOP38eeDstb8A
         iIgZU0ZtiQH+dzuZmfYp/ZWjk2LEPk9ikfF4VqkeGLHPJz1WgmP8cCmIOQ68Cc3VBPbH
         zelesLIhn0WXdwHU/p6dsvdIwu3Uur3hiX7hg8ZndIn3kt95lCCd1jBIfVIx8XvhOsVR
         3go88tGmIxNofVRsK7xKpKDxkgiv1VxafjiKrzZaUgr6kU9wq6dGjcVxvmrpQzDmzreh
         IbxBezQC8h+ErjH7F7hD3bm4wFJ2oLTk8cCRLF/sUKoAWo6srKsiXo4jVzbqlR25QQGM
         7EuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755183503; x=1755788303;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0sgUd9YdBOZy0kVdBoXU78NUeqQMRVWLT5DC2WvX4NE=;
        b=gGMWJcuuuWh0JCCWq7bY/1H8r8aEuXnruVwTHz6UHlcGBnOp3RbXTvpVDlcAAqw8VM
         DmHbtHJVTsDyIgojQEZuXHRFxmvezYrZCRjExUgiN3QJmyYa7PRRRCJMeue+MQhXWUU4
         saVUctQEPhwcwUDlpTelk69RtPeI7UXBMksKZD9JXhlqu0RmbcpwUcsBvbYD0TBjEO18
         rH9RpFl1D+CYmozEW7bZvn+BjaDDFxjWVysdX7xY45j+CTAZfEib9qT8LIyF3sMyp8gl
         Vy5BDnksTI/2jb+Gswa33qS/1S2TCNaCZcgz400DkSloNZsBoNaaKs7N/BesCoELKcpE
         Fk+g==
X-Forwarded-Encrypted: i=1; AJvYcCVsKrhJlxjynkURBNMgtHlJjgS6A+3yMF6uoIrpaQTbRRRaxo0wLzFqNSa7bHh/zy+Q2P7OUX4heQ==@kvack.org
X-Gm-Message-State: AOJu0YyiAeNqB7f5i8LEAe+pKNFPNKInYLyTVShE+Rm6jEAkfA4+En9N
	tZCx5S/ecfnkVwfUd3m1x+KFOgIVx8OQXGlvAg4OYe3xToyRmIXlXGVPdmnjGvttiy5nVZgKOMb
	bpQ7X8qFaDiO5LU2NwPE+JAGuThUqmGrmFAJGg+S47w==
X-Gm-Gg: ASbGncvbWkN79/ahktB3MHwFWd/eH8DgmjLY+GK+VhjjwRrs961v5cicduSrP0E+ts3
	ccPb+kFQNwk5MzKE06pC7ugm7bppZmaTDLix1KC9GvEp5zlNLDLY1vUQ457mESo8u488wEBspLi
	5O4HMXfBo5RYwBOyT1HJwCOJnoFApnwDYyDmoE/cTrLNwYstwss0jEamvaUj976gdeav7Rhss7v
	NxD
X-Google-Smtp-Source: AGHT+IFHaAxoYBbg9LXBtGJVpwf11YGEdCLkE88L9yAIytLzKSm9bsg1ZUT6QEZSsty4xseoM6W0eewH0Y9mwveJD34=
X-Received: by 2002:ac8:7fd6:0:b0:4b0:695d:9ad0 with SMTP id
 d75a77b69052e-4b10a915ec4mr58260861cf.3.1755183502991; Thu, 14 Aug 2025
 07:58:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-2-pasha.tatashin@soleen.com> <20250814131153.GA802098@nvidia.com>
In-Reply-To: <20250814131153.GA802098@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 14 Aug 2025 14:57:45 +0000
X-Gm-Features: Ac12FXzhuAauSUYd9gdMUr4m-BLBsxxrJtaDxuhGuUwdJZFXccXBv2CW6TsGSmI
Message-ID: <CA+CK2bBWEFUU728aQ++7Yp5qXApsHzOTjy=nLMyd7WE27RfQbg@mail.gmail.com>
Subject: Re: [PATCH v3 01/30] kho: init new_physxa->phys_bits to fix lockdep
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
X-Rspamd-Queue-Id: 22B631C0011
X-Stat-Signature: 5444q6y1k913aatifcdas58nirjfocg3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755183503-522685
X-HE-Meta: U2FsdGVkX1+Br6Ykj8OElj2EYoEnGLBJmIqwk9PSItYa0F+/y6F8+jDlauRh0CKHSkYMlPoy4Boe9M12DSV5E6m6tYvpTDWGcMWdsXwRXAEt4kGuyqdiP/hRSIvXlnk7g2u0Gxh3b/naczIsYXh+UofFqeKJ/2gYdG3Ophf4OruN3/71r8BSpAOpGmiKdOhBldNPewYJ+kADQgQbnlSTfk8HwPXukXX1tq05mFnn4zkM4jBbq549Xx3DW7eKA5ObmewGPWooLEwjNfYhRVySv9yFai08H3gCihmO5PW0xbShhF/NLOQamQ0RYdehUZBH6eI0ibp91Ly27/BfuDYSqcJfVM+t21L6WYN/U8q1hV4XP3pZktBvxi116VSrPqsoLvUvqKp8ktdwuWEqX2j2u7mg5FneqlK6+CvB+ctK1GkCh+P6NSS7IyhFzVfbFXg+M9+hnwf0GnIFzREsJDJFd5I60fElf+Ayd7F902QqYCa04IgOlJL+cT4+OW5nxlJlLWq+lOJ7Z9bL9zT3gQJ4g9GUQOsd33ES69hIjMXg/WuCC6pujRQGxaStCL9Soi39h9M1Ce+RvO8G+N/+DGYyMgNDkMauDWeu2EkA+I42KyDGMQ/eDdRHDJF20aKHhMzs0a/ckhz3t3xaZ2jToUNvomTV1fdvKm7UsUyD+RcKU9aPD8sKhoq2orowPjqK0LnoeWzWyoIV/tOUheWoXIMu3AWlOUmoHL3ZlQiMTcHMc2YFZopDtbVYUjeie7Kcg4iBJIT556PEVtAUNWQqlIZ4/wnsbl+QvjalGdfXrTnMtzGoe1ZruUTjCZt2tanrnU97wGYOtzn5JBZEJjirplwjTtc1JVeTccGcjwhZW28m3TN6+XsC69loFDqdDo/qUpu39GuYuYbXsTCygzpg/fGfJI4fSBldQM3DE2Ml6cgE66vANDvC15KbazQhbcSn/Gvi/K5pB2gY8eNJQxIBT78
 1BRk9MiK
 KclyUflMDshR5Y8JEXldzfAjqutgM5PyJIiNh0wkS6ZAqd6Pc4gF3IsIKiKlHze+86mOY4ykBK+G9AyPBNVH6K9Z/9ss9/4k7hpFRSLY2PSBiCEXbUgq5+bMcy5uussiNCkkuzKCtaWsFvjcKiHD/e6bfT+DIlazGvCuyYm9BDn+ij6KT963+AkimYteIRal6DStJ6sDMDOUHOJm8znN6tzi6mbtERMKP4MzMlwtr6EDsBo2IfPrW5dVOHtl8IeHVWexXkdB7ZjhVHt3zyLtFA1OvIIuVDcguVwl9LINAmozhUtwj9xQK5LtlOvF37JtHnMcoVKSpjmy48sMMzSVtub+4EgLyvsHUa4cr6Helx8Gr9ETOLu3AK1OStg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 1:11=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Thu, Aug 07, 2025 at 01:44:07AM +0000, Pasha Tatashin wrote:
> > -     physxa =3D xa_load_or_alloc(&track->orders, order, sizeof(*physxa=
));
> > -     if (IS_ERR(physxa))
> > -             return PTR_ERR(physxa);
>
> It is probably better to introduce a function pointer argument to this
> xa_load_or_alloc() to do the alloc and init operation than to open
> code the thing.

Agreed, but this should be a separate clean-up, this particular patch
is a hotfix that should land soon (it was separated from this this
series). Once it lands, we are going to do this clean-up.

Pasha

