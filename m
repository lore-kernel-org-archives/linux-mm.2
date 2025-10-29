Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01E6BCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 21:13:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36BAD8E0101; Wed, 29 Oct 2025 17:13:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31C708E00B2; Wed, 29 Oct 2025 17:13:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20C178E0101; Wed, 29 Oct 2025 17:13:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0EA608E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:13:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A894E8915A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:13:52 +0000 (UTC)
X-FDA: 84052403904.09.DC976D6
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id B38EF2000F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:13:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KNOjtVry;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761772430; a=rsa-sha256;
	cv=none;
	b=mmggmSbOt43EwgY1QhYHd1kMKA0RGFaMTG7/qqLjbwcSwm/Fmm6Fssdc25NQw3/s5Z/Lpg
	cybEc6MDduSvV0JB1wivNAeyHzwOJcYfqBFgiWIWY8uV75N2JTPKIrAY62g9r8KRo7T7pn
	8p+dFlUAdWcMc1lnCiJ983fVxMBn4IY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KNOjtVry;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761772430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JEkVL2yw/xHlwVM5DiMfV/wkuCa8mgAwcpgYx81B7GM=;
	b=eKtWDWxmF1w+jPpJdoHxvYzLFKk/c57QpZSH+WWQZhIzJxMYchoCApb4NUWou+i6lHtwRy
	L51/7wHxp2lJ6BqUaL8WCCegpO/pmLHSSm8g0j6jeYphCZOiVwxh0ptTlFXuwOaCWw4Gyx
	XEM1C9PvapNxk+1OjB16PyS49vL1Soo=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-57e8e67aa3eso2201430e87.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761772429; x=1762377229; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JEkVL2yw/xHlwVM5DiMfV/wkuCa8mgAwcpgYx81B7GM=;
        b=KNOjtVryU65DJ8BQFn25HOp2gPweq3OOyTrK25NUGkMn+wQ1r6jP2n69KKSgliLXMu
         ZTLbkvV0BPofiQFgSSnNvAbT+njEvKurf78I4BhmxYNJBhMxC0yQxOVGaSzMyNttCyPg
         hpgc1K23eB+pGFfbfjutSUNg6unfO2gNxuurSA1cNvNtEbHe839z3rFWH4dqezFVdGhU
         ExnKP42J6kKYTP/Xel2gRNvv7jelVFIxMrrMujX/b/ncnR0Aafli9cSkAnsKvGcSWiwh
         WuR+scu3IvU3q3zftwiZTwU5gX9hw5/Beb5XyJ11SEFskkifddqatgtbFnGYAJ8CkLAf
         wwJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761772429; x=1762377229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JEkVL2yw/xHlwVM5DiMfV/wkuCa8mgAwcpgYx81B7GM=;
        b=sPHoeHXmkGJHASWPgr6vlGgniBGtpxXVvfiTVVu9vO8CTr/b+HM8sBkKFdAqSZ1dMD
         pOWldYOWzh9wXomblOaasRocJYqTFJvmxpVjoXlnu9D9i26Z/LoRRBqGSx1T6HrT645F
         qNHZOn0fw3SlCl0pSqrMc0csGt0HAkBkFWs+j1jXvqqKAN+oetkeNvvIhMpWxpsjG3pb
         PyK0I4jwcko/fu/M0357QJlk1dtJqTWeY4lwI0+JMWX4taW4i/OZJM054vawUQpnJl8X
         yD2+o5ABp4R2g/drjJETcGUUQ1UGYBe5/n5YQqLM9yE4P3IfjqmFqqmadI/4GJsv2b1U
         XWDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOUbS0jkBgcO6T9I42MoO6cW0Z4stzTHvpk8VwbYDhjJEji2rIF8QPFJTxJjwYyjg1dYK0402GCw==@kvack.org
X-Gm-Message-State: AOJu0YyWnE0PshqBAdawEt5RCaBrLN+xjnXX8vmSixWmwcL4Gb69Nyvr
	1oGEvj44l3mx90Ac/G31o3PzfsGBS9DljbxhbWjIaRrNnrylKMeihwfI/vJdbx1a4vnX11fWuDK
	CoHA55w92NJQ9CZCEqEx50d1Pga34ckSij25RHoN7
X-Gm-Gg: ASbGncvYpWa4ag/TMeIp3uhyhCXttK5cvpaD9bhyxfPySjr4Ke1AeACxGRznkFTftsD
	eXb3TlBSn87pEPhIycbgg5YTIPpBRHDKPv7O7NTM3K64qkypPHRkeM/0K8n1nUCvU8I044Fuvmy
	ngjzPoaBNjkiuMr+zs5VePYyIk6QLQuOYP+IPXPOUHl/FPleZliSaGfCYbYWKU7DrRI/vUo0m42
	HmXdmo90ty9RsIWQErCkpclklMLPHi9k3nW/Jl6hFhtPt1eD7HmIc4h69HO0KecLnxSRcjLXhsC
	7EeaRA==
X-Google-Smtp-Source: AGHT+IHZQoB9yL+ldFaXMM1bMXJiwccZfdn7OWdIICrdEFPtCJ4NB2qUJ+qk4p2BEZhWEpH+XIXLyp9M3uzoemzEy4A=
X-Received: by 2002:a05:6512:3ca2:b0:58b:75:8fc6 with SMTP id
 2adb3069b0e04-59416d8ce02mr294670e87.19.1761772428439; Wed, 29 Oct 2025
 14:13:48 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-15-pasha.tatashin@soleen.com> <mafs0tszhcyrw.fsf@kernel.org>
 <CA+CK2bBVSX26TKwgLkXCDop5u3e9McH3sQMascT47ZwwrwraOw@mail.gmail.com>
In-Reply-To: <CA+CK2bBVSX26TKwgLkXCDop5u3e9McH3sQMascT47ZwwrwraOw@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 29 Oct 2025 14:13:20 -0700
X-Gm-Features: AWmQ_bnOObc6BWBaYvrzlZGN0Gzs0AQqmxe0DWfFCoP14pNjDRBJcsWZpskW2fo
Message-ID: <CALzav=frK48c1=nsbVJ4EvqqOqr33pUArP4G17su0hxOYveALw@mail.gmail.com>
Subject: Re: [PATCH v4 14/30] liveupdate: luo_session: Add ioctls for file
 preservation and state management
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com, hughd@google.com, skhawaja@google.com, chrisl@kernel.org, 
	steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: b9cifgejxau831ty7e8akk7zmta3ftu1
X-Rspamd-Queue-Id: B38EF2000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761772430-657775
X-HE-Meta: U2FsdGVkX19NOGyWQEiHNKKr85B3osL9uGy/UNmjBeJc6e7/JtpPHC8rCRsvHELqIDAwcjP109d3e4xIFmpeAXSx2oBouLm6oDIiGv/kkiQZc09ZUisfVCSxdqmWLEHRheR4jCvT/4XaahUo1hGW7j5rHJMDtlmLjWCT2F0jOVvPutcTHIIt/ggwSp10vNEOo1WGMAdx0tIShLIFzwnRBvlDD///W+RKXqT2x91ro8LIHujywnPlEiz51mq5eXHarMelzpVRYq/irqypweA27LuwSUjSWm2cDvaU9ud4rD+9sWTkFMgWP4E/+O4uh9GMZziXMqaDiDek9ZeoihWQv/KJK/jXqQhC9UnqqHLHlnORNTQ5yBHmPj9ktRG75NlMsSuYI4HzBGm4QV1mjmCsH/LkqxUd8fyZzOu0QjmOslK2g/4N0IUFpc4k7OksR4icZD3dvsS0KBXWlMqmAWdyNl+IxxnrfaXiaZfi1I3UZtpN1fImUJAdGok8+WCGQYaI/jpIhAac8T2gacMguVWYQRiq1D2aGZ+7IVr2COuskIFEqJGlvOz5kHnysufwakuu/MTGjEqaNomdQ40W1rEsnUXfy2ClFw930ZGAS7uX03DuHr6K++vMaDq20hFL5nuswzmDYGAT3k6/azXbN++WLUGRPKIPl/hd2IMj+e57CrBarm6Y/0iAaECVz8EQWIDdfKdYs4475WjxAMKQP/caNVeWK3KuIJkBq+5IjP0vQgZfDpMCv+swrZRq9hq3y1f65fL4+T2dvepeV7dv3Cm1PCvUfWW5MHDyEe5OrzwugfoCaVcv299XZAyjt1kE8pyPW7bkRex7LmG/hUZOcq9a8hyFVm9DcJ9OIgVNoDhe7gRusuDH2/OjgpENVoE0J4bDoevTfpBEWrfb5/VejGFasC3bPrD6x2XEMLx4IP0D5hjbW/bgfrKDMJurnW+XzgwyzQ75sZFLwVEUGYSdXoL
 0SQZc3bX
 EryItJvYwQ/50qRD5eD4eDKS5/ZfGOi1h+cH6HXdcEvX7KxvApDJm9FrpnIF3jevCXgIuuaSFy9LiXgdOdHIVpNChY7tnMXcOCQrNedsQtp0xzPTQz5CyMqBUJC3kX/1BAiW54jZLt+ApGRHgEhXGsHMZRgBr+mgIAND7uH3fLZyUEA430f3rSPVtVDjYnwzX8N48QnjSXxvKlG5yg1lg1J1NjAuE0ZLyo66KVDV/YA1vVYajmYaMpyWaqo1o5dNRtTd4sw8niu35zgNCiXPjr5geC5XOfuD5sdwDMu15iD2bMIJMeaKmX4Qzxd7kCI53TFzScUDEljYd9K4Eh4ATSuPTZwDM98y98rlRwDght2Tsj7gFciBi5bJ0jw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 1:13=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:

> Simplified uAPI Proposal
> The simplest uAPI would look like this:
> IOCTLs on /dev/liveupdate (to create and retrieve session FDs):
> LIVEUPDATE_IOCTL_CREATE_SESSION
> LIVEUPDATE_IOCTL_RETRIEVE_SESSION

> - If everything succeeds, the session becomes an empty "outgoing"
> session. It can then be closed and discarded or reused for the next
> live update by preserving new FDs into it.

I think it would be useful to cleanly separate incoming and outgoing
sessions. The only way to get an outgoing session is with
LIVEUPDATE_IOCTL_CREATE_SESSION. Incoming sessions can be retrieved
with LIVEUPDATE_IOCTL_RETRIEVE_SESSION.

It is fine and expected for incoming and outgoing sessions to have the
same name. But they are different sessions. This way, the kernel can
easily keep track of incoming and outgoing sessions separately, and
there is not need to "transition" and session from incoming to
outgoing.

