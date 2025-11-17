Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09239CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 18:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66E706B0011; Mon, 17 Nov 2025 13:20:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 645C38E0002; Mon, 17 Nov 2025 13:20:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 535476B0022; Mon, 17 Nov 2025 13:20:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 429106B0011
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:20:49 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A19E3B76CF
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:20:48 +0000 (UTC)
X-FDA: 84120914976.18.4FBD39C
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id A5AA8100019
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:20:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="fIK/i39s";
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763403646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8uyJ9UgvBm8P+z5AaxjU/5GgC74k2Y8kBRaWb+wv/8=;
	b=J7ZVSIpeWCm1cSfp+qGtnf/IaPwxjq68FTmt6/K5Fyzt8zVlyaHuPQb21Mvie4IZ7FD8Mo
	dkILv/IeifQ0mS05v9xECVmFtvjZ1EkiTsRSt35xdJwdd2+2kg4cHuno5xVePpqxukCk0v
	X/z/HjrBHUWvZHDJxDgb8s/JAB4tzYE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763403646; a=rsa-sha256;
	cv=none;
	b=bRwxFf4Xr2Nli4brb73ndgYwDdv9nmyS/hOKnLFYWCXVMP+fg0ohqLAchRclPJEdV5nax/
	HVbT5anmNqjc7+Oo4LJDcfNfrN6muMO+cKMJ+NZXxzaZZnm0T4srZcMxNmFArZbZKnC+fP
	2CnDZF8dD3BzHyv2jdSL5K2nnVmEnRI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="fIK/i39s";
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-640bd9039fbso7887376a12.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763403645; x=1764008445; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j8uyJ9UgvBm8P+z5AaxjU/5GgC74k2Y8kBRaWb+wv/8=;
        b=fIK/i39sFR9J5dJE6KO9uAeiKxnMM/fMRk8A1LZVGxwvtJbXKJEfHtD4UmXu1ybbwy
         245UMmRXvXUVPv5bg437rkntRom0ca0Oq/drkN1Qh1mdJkgctDaa21+XhG9la0JyC2YS
         GBvv1If1iUVJipCiHYdldCORAsl1nJITcdTUNzoIM3Suv/JUNbEcqGqBcCJwCyP2CDqL
         2Rqp+uvb3AthARvIE5LMBq5WQABWNtp9lwJV4sTWmvmkANa21xG3HVZx6sE+N/XK/8PH
         cnV86h67EMt4wi1Kq2gN2/kIcBESXuJok9MPtATmSGZ1IwPCt4xSnhYUWJVt6VVdq+07
         s42g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763403645; x=1764008445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j8uyJ9UgvBm8P+z5AaxjU/5GgC74k2Y8kBRaWb+wv/8=;
        b=PLVVOydZTXuzdb/JjvI2ofreafDilX2h8O0SQLVNfDJhuGLCXzTmXoY7U9ZF7Z+DNJ
         FdR9mlVK3CGY59NXyjX182GfOQKqz9MtcBqEWc6DJ1uggP6ia91MPp66Y0Cfp+GOywQE
         OZhGays5l/Zf/c14SWXJNmB/P7j+v1993GkNrf4m4i1KXTJ67X6GuuJLZTB3w48LroYi
         xGK2vvuo5EadaSyE252vS4JCjR8xZR/JMU/aIoyhteUXjx2XtKxk7qtO0msEzys5jvSC
         93AfMTkU/YAHqkLGw98apU7PKNUxyrjw2Aa6mtIvtBhFArCGnvGEH0o3L6w0DxrYHoYY
         E9qw==
X-Forwarded-Encrypted: i=1; AJvYcCWP78lHbS859Fk7v0vhr40VJEtEhLDrgkAYrfyQfv8CbOtdd2ZdS1OfYUkSwxna81kOMsw1KEZ7zQ==@kvack.org
X-Gm-Message-State: AOJu0YyQjea1QuFEbWvpUhEhverefRPw58pklomLnU6L6NLoaLXyxtvY
	bUVHPuw7PhuW7uGmu4A8gyhNDBBLkQN4CC9eLQtxC+nQubJawVExYpH/Vhhr8kQkCBMe4+7zEO3
	9wSnUb8QQd9gg/Pwz96yLi6x88m8woRzHAtrsxI2wJw==
X-Gm-Gg: ASbGncvXG/YTDEew35VPfuFuAuTLJhFMJqU7FYwwQH/JEb3HnYLxVQGDOIODktunwE2
	Y2476oD4IAZUdsazhwCE5Ys5AnOCT5M1RtvbvOniDI8Ygt6jLuOuczP7dAIiEroJShS6HOD4uUg
	PWOLMbBHJJKQFjhrV4ls1XsvsvEZCtQy1I3u1TRWKvE3bOONMz+95GoI/QIQ3n6ZHFFozh7kQlo
	LcTjJgRjlzZKXuCOSCP5Vu5YGgx2SW2ZaFRSdk0p8NhgnktUj2vWZ1hBqHWVES5jNHF
X-Google-Smtp-Source: AGHT+IGM1Tr15Cbgk4QQHnvYqnvMCGG164LW1Q1ssAN2iVzR9VtHS4h71YwFJlzXxkn+A9bvWz6u1Z5jGfTyNzSIJ9I=
X-Received: by 2002:a05:6402:50d1:b0:640:c807:6af8 with SMTP id
 4fb4d7f45d1cf-64350e9c5c3mr10832591a12.30.1763403644857; Mon, 17 Nov 2025
 10:20:44 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-11-pasha.tatashin@soleen.com> <aRrtmy--AWCEEbtg@kernel.org>
In-Reply-To: <aRrtmy--AWCEEbtg@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 13:20:07 -0500
X-Gm-Features: AWmQ_bngMkZtOLXtzvbIhDYg36rxAp3uf7c25ogdWq8dWGd7IJgw-yYh-gP9XSc
Message-ID: <CA+CK2bCVf2RppZbALAuFZyZarWukzhwkmOgtG2PcKqUQuao6uw@mail.gmail.com>
Subject: Re: [PATCH v6 10/20] MAINTAINERS: add liveupdate entry
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
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
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qhge7prfb5jdi7ah8fb9sr18fj6mhutm
X-Rspam-User: 
X-Rspamd-Queue-Id: A5AA8100019
X-Rspamd-Server: rspam01
X-HE-Tag: 1763403646-597868
X-HE-Meta: U2FsdGVkX1/u76bWbwf8j4zVVQQipR9AglGj17fEmQ3LB1dBYNuhoCVC8gJ1D5JXXv11LxBlF2HdG8xWEZMc0f35hkiCuWgXY2bBs4mxZ4q1Gcbc52YP516DJiDfNaERKEzEYDUYiL/eUXt3gC9XC6aUUW7iXSghx1hAJPbmz3YxQJlIxaGyM7oBw3SBlraTAZ8CjT8Py1PE/dskEYil7CxLzoVlY8YR1/d/eJtHtVW9P28oZNwxB6xj0yOJ5bW9Twcr451TpefYwlFiTr3bCm1ul823c+FXq2ul/rkF3n9ngbVBO3Alin5JlakOdGposu9wQAr2UKhE8vMsAJJQ3NcqHhkkxVD7EuuYu6Sjoym3nMPHcZXQBzrTkLIbl+qypcbDntV/d0xHlJhkO/+Ox6C0pvh0+ZhQ4TCrSQ0BAs0SSVbtTRt66bs7+DHpuTpNkl8CSE1krgbCEOn2DS6tRug4sTniSlaBOxvMydMEZynxiqcmL5U29pkyltdCPs9WpzE9lGEaG5ACLE7LV2B1aAyuEVYWATfZEtblSEQ+Z5Z2fOiLZFFVqYsPd8+AC/T4ffbJRvPxbYVPH3iovIfPni2DlfEl4FVOuUnv66wPU4eNNm3O4K4j2BuCP2hno3FnekkEIgxqQPa8r2dQbRj2hV7kTj/0CPAbC1h/9lUYMTOGxShwf5N1+1DdrZVkAQsEwfstg/mZ/9rr1Y4ZnrJN8XN7lNXzIam+KxxvUQp+eTZDzkJkRIuWV6c2PNqBVJF+aolZNVN/DX8dFXShfwdXANgqkzogxSUn6H6NR4dK7jNKizFzggvbnNSQWgGLvwthFaxdWzeFf+BbQ4q2XmeCv7XXk6Yqpmu09W7T+EFJ52L7IvdlE4u+IwvU0MR0JA9HLA8dxfHTPPp1Go27TmFkUMbrlWSaWDR3OCDpbq0VkRlihcjAVoirxYONFWdRMFziH7dtdKzx8/fZiq18rEt
 FUcqjUHL
 OyCvvqJD3FxJ4M1n4Lz4F30UMS9x4kptkxRfqdY1Y9N/sE8LS42rD6/B/xwUXBaW8pN6SfA1GeKWFq6dbpSz9hzwbQfuBynu4q0kl8TIc9h+o2YliDYr9gTC1+ORvPklw3mqX60cRcXObLGrjYhVS1pw2P5eh4oLXBfED8yhwx9q4XEngsSgc4frsnwQjNne4fh6yhweeTdskEwgv2fqCGN63YJfaWdpRnMWQtABYclcEVrrhVb4Q8cPE3VFaR/vo6H+4wtnhqlECMfdsPG8KaHAexxjoR+sGricrsRqlZRkz8xn7gXzTkdv8HEpF8TkFhk5CSf/b6+t5PRr9nqEheR7wDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 4:41=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sat, Nov 15, 2025 at 06:33:56PM -0500, Pasha Tatashin wrote:
> > Add a MAINTAINERS file entry for the new Live Update Orchestrator
> > introduced in previous patches.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  MAINTAINERS | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 500789529359..bc9f5c6f0e80 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -14464,6 +14464,17 @@ F:   kernel/module/livepatch.c
> >  F:   samples/livepatch/
> >  F:   tools/testing/selftests/livepatch/
> >
> > +LIVE UPDATE
> > +M:   Pasha Tatashin <pasha.tatashin@soleen.com>
>
> Please count me in :)
>

Sure, added.

> > +L:   linux-kernel@vger.kernel.org
> > +S:   Maintained
> > +F:   Documentation/core-api/liveupdate.rst
> > +F:   Documentation/userspace-api/liveupdate.rst
> > +F:   include/linux/liveupdate.h
> > +F:   include/linux/liveupdate/
> > +F:   include/uapi/linux/liveupdate.h
> > +F:   kernel/liveupdate/
> > +
> >  LLC (802.2)
> >  L:   netdev@vger.kernel.org
> >  S:   Odd fixes
> > --
> > 2.52.0.rc1.455.g30608eb744-goog
> >
>
> --
> Sincerely yours,
> Mike.

