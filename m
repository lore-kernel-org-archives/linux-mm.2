Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2545D6E2BD
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 311426B0088; Thu, 18 Dec 2025 12:37:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C8326B0089; Thu, 18 Dec 2025 12:37:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE026B008A; Thu, 18 Dec 2025 12:37:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0AF066B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:37:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C44DEC01A6
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:37:46 +0000 (UTC)
X-FDA: 84233299332.17.D343595
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id C51F140005
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:37:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ayVlna7g;
	spf=pass (imf12.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766079464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5QdlsjnvqcZtuvASOH3lpLVJ9DAQKa6CAUEA2Iqcz8=;
	b=uUAfgXHHskifSJn9Dv0iWKcmmQGmE+o7ayUG6Vn6MUlyLEhbTLACIbJHm2M8zBe1dxeljX
	JQpqLfAZ+y6vIf2vNz4V9vaUrk0yJRWdXqkkBb7KOnC+PpbePB1daUQijap571rgRpeeXM
	APa2JkDGqarGo9nSH00Vsk3eWksuW5c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ayVlna7g;
	spf=pass (imf12.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766079464; a=rsa-sha256;
	cv=none;
	b=fUkV3OzZd0LUQc/iEqX6yVWHUQJYMLxyQEQcbvKWII7YPdOREazaZ4nxBKCGjeV/222+mN
	bJmak0Ih9mkjhAsU8MDU0nrY/bR6e1Y4MZ58v1ots4Tc03omQb4/QzsAnTiWtCBZo6dS8Q
	xQRTpNTO4XRUZLiKEdP/s4cq6+Eyan8=
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-37a2dcc52aeso8571341fa.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766079463; x=1766684263; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t5QdlsjnvqcZtuvASOH3lpLVJ9DAQKa6CAUEA2Iqcz8=;
        b=ayVlna7gOyBg1geHWSwa5Inuhu4avU5Ox86IRPkEpGNoavYXi1aFOsFlgUBfUzzUun
         5qQPs3F/Fm/SUceeTGxhVJch53M/P9SbfbHwSgHsbB7b5SmJY718Hme0UbZFYW8PNjoK
         5Mj+nkQeVO7aOvXo7/m/CDxSWi+C8nI/TkKD0zgeRxH4FOaH1pLs3YbAw295QBGN0dwl
         vHx3X9d9yNG4dewwsWeJNYDUcqaHgYON+s2qv7oOc0Qq5/XDK7Eb3iUKrwytdwExmITZ
         qYOY5uP6AHutqoPHBfodK7u7P1DrSdnVaVO9C8KsdZ39EgWMQBNSOXgC1gGoSlAHpUWu
         dntA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766079463; x=1766684263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t5QdlsjnvqcZtuvASOH3lpLVJ9DAQKa6CAUEA2Iqcz8=;
        b=Sf13AlC8vqudcJwNAooldTttGktlELn+iqpKPiA1VYibyyw9Y/xv9Goo6buN+baKz4
         16QmJsjZvcCgSg5fhuH18PIJw6DolZMuT0BG+8WLHlUebf+omhSr/My0QC77oklzJFgk
         g+FR7u/J3QujWhsCNRo3f+ApghNCffush9DFSncS2zSL9258fXDWw9h41MQ4Pfbgf5CL
         bNl5jYc1GaKyMrCQhBfRw507MYqvuNNx2vQ29YaL7x32+hf9cydcRk8nSR/JuSkvRyEp
         975tjtnsLmXKYZnaJabRpsAK0g6lLJalWtpZpQOIZDNp7GbfdJmO6n6L3+o3Nw5oeBfk
         Je2w==
X-Forwarded-Encrypted: i=1; AJvYcCVsVjfGLrvtADxDJwIBCEVgE2SGk0atOV5XJZh37z2pLc4XHhXuge/JrxbVk3K2LNxH3A9iYwwhUA==@kvack.org
X-Gm-Message-State: AOJu0YzZNvaJOLL4GUMsWJI11Ugt/vCB8lG9Ep+mfebDPfgm43D2vT2q
	z5gyMJxj4+K6BxscnZVG9xj+0YbnXispMeAdCcIX9NYnfoRN86CL4s9+gmsrFzI9vhjAjdT3wwc
	LNYI7H5feYuYsx/kBG9G0JHnIXXpgBfc=
X-Gm-Gg: AY/fxX7H9N0GeJyHY8GG+rLRC38RuxOLuesM0b6xctJq/xlFqAWOWXnXBDR0VuvSTmz
	/GQlpIPbh2isuGBpaHxdC4G8fqiC8e85AbJHvbBs+KsCFOyAYWg6q5N4g3n4+Plk8PMMQ28e2kR
	lfMp53+V4XaAOL1MN9UP+7DIzonYyFIVhwQ++s1K+qiC4zD9KptLLrz0nvZr4ITaA7i8HHjm8w8
	1ieSz+Z1bAA5ISxeYDJE7abV8Y7XnFm/XSVbZGcEUxJURa/JDwb8bd2PQJOUn2PD+sktq9vPBZd
	ht0=
X-Google-Smtp-Source: AGHT+IEpztJ8/Oc+Es3sQgy2cxIcccuVwHnjY+irVmpUhBY6FE1JhNS+XHvQhg0+lSlGd1EkNb1fvtRSAvrglkfaPnQ=
X-Received: by 2002:a2e:bea2:0:b0:37f:c5ca:ac02 with SMTP id
 38308e7fff4ca-381216351fcmr293951fa.20.1766079462542; Thu, 18 Dec 2025
 09:37:42 -0800 (PST)
MIME-Version: 1.0
References: <202512121138.986f6a6b-lkp@intel.com> <aT_8woTbtklin3Bh@milan>
 <aUI/MZ8sGDt8toOC@xsang-OptiPlex-9020> <aUKONAP3CZn1kZw6@milan> <aUOFGneXSVE+DItX@xsang-OptiPlex-9020>
In-Reply-To: <aUOFGneXSVE+DItX@xsang-OptiPlex-9020>
From: Uladzislau Rezki <urezki@gmail.com>
Date: Thu, 18 Dec 2025 18:37:30 +0100
X-Gm-Features: AQt7F2qrnk7u0JIBsBRE6RAjnmRa-PLVv94DblNCWhOYRGSZu08KzeG00DwOzEI
Message-ID: <CA+KHdyUgK6hSbrKMpH1YqtadzBDFR=SnBUY-hCHnzkLqmcPf6A@mail.gmail.com>
Subject: Re: [linus:master] [mm/vmalloc] 9c47753167: stress-ng.bigheap.realloc_calls_per_sec
 21.3% regression
To: Oliver Sang <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C51F140005
X-Stat-Signature: o9xkwoqhcfa64cizf4bmw3thf7tg5dmc
X-HE-Tag: 1766079464-888122
X-HE-Meta: U2FsdGVkX19Tum7SI9r+D2bafOP7dbE+qtWzSbwv7AHAqXNzwhfPNSIpfDb/6GZ0Bm5Z54UH/Gn9jZEyCjRJmJkEkhCzCuxG+At+5QNAzTyf2MxD63zTOgEtNVHnurp6rPXaaxpImTbxC61cH1DYHsYFtOi8CubiMzg4dyXkI5PaLlDsREbZRXuJ6qaiE55wKCbIFV4sqUQ+scr3XiFNowPahDA614CDI3Q+5ZBSKwVavnOZR8XjDNwtv2ZP4dYArb4DQpIB0MmFLECGUCnAZCatQpoUY3CBAQu0FoNRXqqBHxiIvBwx52AURWTRG3vPajWvsOsG2mD07s0mYVkx5TyVRnG5vhmeGm/QFVlbDqYENb9z9gWkXkdeeYKMp1cISch2RLaV4E7t8+XCRi1IcYuSuaANuhyVJyOMnT2VgC/M0m8eicOslvOb/4zG7/q83gEvKC2avxbEaW128HzIasUwcGhC47Kk2M3ZD2ELqDd4JZWzU2e5OONfq3XeYMFPc4kTEuu9ikidozxPwf2/1T2UrPRE9/r+cL9CQ9iLw6S13skZhk5PzmuBLsWlNbiXs6r7hlbKZQeXrC1NUtarMQMA0SUvitMLrbqtmfPKk95iEUi8pAKzyj6I2XjmLY+WZkQ9Uxn42T4dBVinz0U0MquDKZxRvKJVzDGsmr6PQNuC6Cc/TygH63MU0ypE/tqd0D/kUU+FVLQa+fMDiE2o/9mGhYoPyNDJ35y9H2+fyzX6ZATL6FM12oUaOIUlF9oOzjoFZcw9pwszDNG1CRQ9KdQqUOG+b2uz6DnYB/fqKeVQuuITX6M6qQoG8f4BaVh90pyFm5mQqK2n9mWhXdUg85/C2M6SfGkcQj+0Iisf+auBPVGUQQOBLskRuElTUYq1VXxsJ8jIjNe9Gi6VLkEI/c4zceP9W6L9K5vhKUop1GzO6dpJdDQqStHDDxNhNQ6/lJ4+tpy9T6yGlqNR4fo
 76aZo4b6
 h1QohrN5L3nVlDIjNljfD1jYOzCoLhuJ/PztFcrSFa8lSXsh83B2fkqhZzoXHVmATV6gS7y1Xf7MB7KrPtK+9vBPjBZjcjnBCvKqG/rzDg1+bAFlurY5EuvnN9uKtTOHcH5xdz2wJ4reTmSDivKpRwhg3taxjpKInKis2MBDMQDVh3YSqUJ6qrnIfe5MGfTDL8DOGZGJE4Sun6CCrNBX+MecOGblXnGEK7peWeKXdAkz7at8qnnnwNl5tEvFwUrF7g5roITTVB8v+rc4ZJLzm7YvOK2c0JvMKQzzMSFaZQvf67E/dnchLo24oCWG/xDrzHttPQTijCISpE5BG5hqvaQXHhx7fy6ubPfXg42a/0AHQQcPNb9VaKc93N8D/EKfZ7lGeFYXkEQFHbz6BKSy1D2zYqiJiUtuiuQHBcGVm108l2rKGFPhZTPo375CJvCe0/v2cxtuPSHw/af+YUhS4vDrK8cfmGRsAPrXxiIO9eQkDrHg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Oliver.

No, thank you!

As i mentioned i do not see how pointed patches can affect performance.

--
Uladzislsua Rezki

On Thu, Dec 18, 2025 at 5:38=E2=80=AFAM Oliver Sang <oliver.sang@intel.com>=
 wrote:
>
> hi, Uladzislau Rezki,
>
> On Wed, Dec 17, 2025 at 12:04:20PM +0100, Uladzislau Rezki wrote:
> > Hello, Oliver.
> >
> > > > >
> > > > > Hello,
> > > > >
> > > > > kernel test robot noticed a 21.3% regression of stress-ng.bigheap=
.realloc_calls_per_sec on:
> > > > >
> > > > >
> > > > > commit: 9c47753167a6a585d0305663c6912f042e131c2d ("mm/vmalloc: de=
fer freeing partly initialized vm_struct")
> > > > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git m=
aster
> > > > >
> > > > > [still regression on linus/master      c9b47175e9131118e6f221cc8f=
b81397d62e7c91]
> > > > > [still regression on linux-next/master 008d3547aae5bc86fac3eda317=
489169c3fda112]
> > > > >
> > > > > testcase: stress-ng
> > > > > config: x86_64-rhel-9.4
> > > > > compiler: gcc-14
> > > > > test machine: 256 threads 2 sockets Intel(R) Xeon(R) 6767P  CPU @=
 2.4GHz (Granite Rapids) with 256G memory
> > > > > parameters:
> > > > >
> > > > >         nr_threads: 100%
> > > > >         testtime: 60s
> > > > >         test: bigheap
> > > > >         cpufreq_governor: performance
> > > > >
> > > > >
> > > > >
> > > > > If you fix the issue in a separate patch/commit (i.e. not just a =
new version of
> > > > > the same patch/commit), kindly add following tags
> > > > > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > > > > | Closes: https://lore.kernel.org/oe-lkp/202512121138.986f6a6b-lk=
p@intel.com
> > > > >
> > > > >
> > >
> > > [...]
> > >
> > > > >
> > > > Could you please test below patch and confirm if it solves regressi=
on:
> > >
> > > we directly apply the patch upon 9c47753167, so our test branch looks=
 like below
> > >
> > > * f7991e8a0136cb <---- below patch from you
> > > * 9c47753167a6a5 mm/vmalloc: defer freeing partly initialized vm_stru=
ct
> > > * 86e968d8ca6dc8 mm/vmalloc: support non-blocking GFP flags in alloc_=
vmap_area()
> > >
> > > but found it has little performance impacts
> > >
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/t=
estcase/testtime:
> > >   gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.c=
gz/lkp-gnr-2sp3/bigheap/stress-ng/60s
> > >
> > > 86e968d8ca6dc823 9c47753167a6a585d0305663c69 f7991e8a0136cb0fdf35f11e=
28a
> > > ---------------- --------------------------- ------------------------=
---
> > >          %stddev     %change         %stddev     %change         %std=
dev
> > >              \          |                \          |                =
\
> > >   48320196           -10.9%   43072080           -10.8%   43116499   =
     stress-ng.bigheap.ops
> > >     785159            -9.8%     708390            -9.7%     708644   =
     stress-ng.bigheap.ops_per_sec
> > >     879805           -21.3%     692805           -20.7%     697312   =
     stress-ng.bigheap.realloc_calls_per_sec
> > >
> > Thank you for testing. I had same expectations. No difference.
> > Honestly i can not figure out how:
> >
> > * 9c47753167a6a5 mm/vmalloc: defer freeing partly initialized vm_struct
> > * 86e968d8ca6dc8 mm/vmalloc: support non-blocking GFP flags in alloc_vm=
ap_area()
> >
> > can effect performance. I am not doing anything related to performance.
> > I would like to ask you if you could test one more thing. I see that
> >
> > [still regression on linus/master      c9b47175e9131118e6f221cc8fb81397=
d62e7c91]
> >
> > contains also below patch:
> >
> > <snip>
> > commit a0615780439938e8e61343f1f92a4c54a71dc6a5
> >     mm/vmalloc: request large order pages from buddy allocator
> > <snip>
> >
> > where we try to use larger order for vmalloc. Could you please revert
> > it and rerun same tests?
> >
> > Thank you in advance!
>
> we've seen comments from Mateusz Guzik in
> https://lore.kernel.org/all/e4b6sjeh22uqhxhxudsbanlnyo2potwowuy7mkrp6tvxn=
ftjn4@mcjyes2s3eu6/
> that this could be related with cacheline bouncing.
>
> not sure if you still want us to do the test you mentioned?
>
> if so, sorry that I cannot make a clean covert of a061578043993 on
> c9b47175e9131. could you prepare a patch for us? thanks
>
>
>
> >
> > --
> > Uladzislau Rezki



--=20
Uladzislau Rezki

