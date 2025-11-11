Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 526C7CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 21:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AADA78E0008; Tue, 11 Nov 2025 16:00:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5D7A8E0002; Tue, 11 Nov 2025 16:00:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94CA28E0008; Tue, 11 Nov 2025 16:00:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6E18E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:00:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25EB21A01F2
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:00:28 +0000 (UTC)
X-FDA: 84099544536.17.B7031C0
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id 416B5160016
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:00:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="YnPd/X4z";
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762894826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fp+8AG6pBI0jJ/x1v+sgWdRn9Lp3GBtp4uOEuA09BJA=;
	b=D0gnMW4ptHGUYASXdUYAcFkY9pISaOsP1SQagD/hqCMN00UojASE8O/nicxg4YefYA7bQ5
	bghift81X1ipPE8r428gcUub2x5nmbHFzzpxVyzR/yBTJDcSWKvSWaGg8MPsyTdF9MaHG8
	6BwDTiVVEluPzbsFA/rbtbKVW0UpdlI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="YnPd/X4z";
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762894826; a=rsa-sha256;
	cv=none;
	b=i0z9fCkaBnu2/5ph3wb5+TxQ6Xa/qBbWxSa8g4m8Y2HU9KAhokCHqCE5cUABZm074qGKLP
	QrWmVT8+tk3MfQDRePwTSSL/afN8gRHRV26N+Puv4D3FAiViJ1dVIpnsMfydk+FULAW3wZ
	HoQbRvYBsW87yz9wXYVKsP+q0S+7U2c=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-641977dc00fso152237a12.1
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762894825; x=1763499625; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Fp+8AG6pBI0jJ/x1v+sgWdRn9Lp3GBtp4uOEuA09BJA=;
        b=YnPd/X4zFKzE1A+7xoxCltQod6PYUftjPQ0A/IEgc6NlXxZrP/Y4huOLaKz07eczXm
         bgxDINh4GPdiEi7XqbteL1tzmGk1+DE4XhBBBEAac4tVx9X10xR8NdoW3DZ8KUBmnxWO
         Fer57MYsU9cHGsnU3e7kvUZhWmZJDTSgqK+l4CnDZOrF1K8QeybucTmByt1wcxjH4RDg
         3Fcvzb898VyL0mptKiOfLWkUu+TTcqTtxO8HyqIerOBARztqFdnTiN20vVsKYJJfXvbZ
         RZxDYElJ2uwgjEJz+4zKprRSxAuNTa1lEynV8hnldECeoY0k0O622D6Le3PvKeQl1j1r
         +8TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762894825; x=1763499625;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fp+8AG6pBI0jJ/x1v+sgWdRn9Lp3GBtp4uOEuA09BJA=;
        b=AooEiw4dU2cmOle8G8aCyQGSJDQMiKuLoSORsglwcdCb8rs0hY7YcRFyZzLizj8aT5
         eFyxD0TX+CZJNcdL137k0ypQHpf0afOqzhrX5n5U9If37kXsSVcrGaswetuP2n3MEG2A
         kplqdoX4YHOoSgvsPJZvM//3q4URgeUixHBWptL8iwx1jAf5BiOOLWKiFmvfb+dxmdFY
         in6/fv+XBgykM6l98xPD6u4LI7CPGmYMzgbeZH2dvaw+cn66bS7doKv4GD3oLsBAJRmc
         slNeKE+GQ7lMOVNUJrEJzOmgvPY6tx9ZRrWB5yXyB3Mg00oWcu0kxIjwZfZjHIrfiGY8
         iSvA==
X-Forwarded-Encrypted: i=1; AJvYcCUyc1kPVbinRQIJAOTAsliVV4sqiAk2izWNpFDIxKmBZriJr21QRAXB2xBiPFShNaSy8XCEJZX4pA==@kvack.org
X-Gm-Message-State: AOJu0YwmStE320sq4jK0/DjzfT74gIKBVtsyX/Qkb+5TF0Fi3mSMZdtS
	YDg46y/6FdJrzLP6LLEywIPOehdK5UdguxzZLCjwoXrhuBLP20GAUnZsOVcKyc76U58X/7ikfby
	wRcjnIQ64P7krK92hxrWof+bPLwhc/c020RCSLUc/DQ==
X-Gm-Gg: ASbGnctgSMp1/nYhwdhHRM7FhaTPcgEr9IokdKQasTxvUYqq0ZvkhS/TuJFa7vape7q
	Ob5qdnq26lDOSoUNsXXdVN7vMJs5KGtxJfXaQQqpTsC5GEok/SCsLRzCA+EiCy3jKal+SYkRuMg
	2QwtoA2SVl4CFJGEico5lX/r82DIYYEJfq7A40vwmphmacqKGAXqFeEnXLZogSfnu0edrSXCdut
	4m/whNBTYB+S//LPn1wo4AbLGja2pJBaG+kwgAkD+tZDCEYP7m4S/2snGbR3ELXoLa8
X-Google-Smtp-Source: AGHT+IH+e0YsGvHk4dFv4/hkj2NgB2ttZSxI+gZm+9yj2ImFkWPrLek2DaIdjfDu/vAiHUMqP9wuFNVI+e9wnD3MABk=
X-Received: by 2002:a05:6402:51c7:b0:640:ceef:7e4d with SMTP id
 4fb4d7f45d1cf-6431a55d74emr573319a12.32.1762894824747; Tue, 11 Nov 2025
 13:00:24 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-6-pasha.tatashin@soleen.com> <aRHe3syRvOrCYC9u@kernel.org>
 <CA+CK2bA=cQkibx4dSxJQTVxVxqkAsZPfFoPJip6rx8DqX62aEA@mail.gmail.com> <aROaJUjyyZqJ19Wo@kernel.org>
In-Reply-To: <aROaJUjyyZqJ19Wo@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 11 Nov 2025 15:59:47 -0500
X-Gm-Features: AWmQ_bnYdSMroRMjjVnLSAE6-uLxVnY6rxuibiqAyIlNle_pZdH3zG6_TS_O-10
Message-ID: <CA+CK2bAwfChKVNtHxVi3NWbE=LCLFacB_tD=ZamM-2UTNHOnzg@mail.gmail.com>
Subject: Re: [PATCH v5 05/22] liveupdate: kho: when live update add KHO image
 during kexec load
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
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 416B5160016
X-Stat-Signature: maj8jynamysd66xddfgo8umjnd1iuo5c
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762894826-607149
X-HE-Meta: U2FsdGVkX1+NsxB7tW3CnfWcBSPD5yhW0suYfqSa5/GsXBngLyj9g23pAz/Qt8k5L/ci1qq4vcfpjXm6TGEUdKG2tLhH5IfC6mDvkO17tgCLfNnarYa4XNz47n1hfGikH/aZ0dP1+tuGYfgauDa3Avh1aW6OdX/DhZ205s3JeCRLNkn7459KMw85D4k68pYWusfpuOUxCVnGx0tRZyDaEAnn9wiHnc2Xu0NACQFCSDaT+Sn8XUTf0GIzSvbImv7oEBHGZBBld9GPROt/3HFAeeAOQFTnaVOQbYNnkTqAkS0q6xiHxLILMgNp3GofbSazJdiBf7kSgDHGu+tf4m235ph0QL1eqcZe4YMeR8Ofo8nhAlkxUR8loVn+KxBMoGH/+I50UYNYmGPRvwlm0P5W4oF8Kr2ZYOx7iqBkV3bdie6dWP947Vmhrv56NwxZvv9xr8IJSXiG9rE/ZrHIPWGHdtOSUBw53Q0ffmqjMamnnlcCMYVPVwmd9F9nogMnFWluMt9/X/ip0ZoQHkPU2GacbgZPkplIrB5FdacV3NHUfSnkIIZl5g/tWgam8ORXxhDocVhfldz39sxd+fPajwilDySvNZNhrIx/Lc9aDhayFsalZzohKRePE0HWmIZX4+PLxcNTBwpQC1CrQAUmB4H2+vR5YD7ILQ4wpvqLNF0eyVnjT7Eis4qNdJlM2Th5FFpSsBfiX0RVEWGEo4GHbEjDFfpiHIUqc5S5R6sLHkA7KkcFf3E1XSVUNiiQaNotto8ALOb7cG+vjql5R8aLP/5VoqH7lqCofGFH5ut5fQa/lpfO8VS///dwA6uMyRdXoCRg3FxYKSnSgMspEChMWOQ1aUDL8toJaCXCyy91osdJU+ebewbqy/X+vcw4V9ohWmi3GSQIDbOSI7C2snSINTtWVHG0Nrz9T8ZREKQ6Wy1BYXcFOeSPpu7j4tyDTOI+dpTVVmAGQSzmHIsIl9vAA1Y
 ZaDMePaM
 jK6VDPphJ/oZJB21DkvmLAU3QIWp2HM5TQnacDEeVpGeFFcKZxgarU/kmZiF/Ek3bIpmzBTA2aTsAfdFOdVjoPppOgTTD3hVxdtS9R0j2FeWEkIMdFgSg98hHuFw/34Mo92UrJn/gSZDEbCwTE/4yREiV6SKhvrT+I5aj89nK0YU4fhnOA6n7xfmgZV33lrmCMxxRxQuKaU1P0UfprmHtAVZD7kxOAZCkaDrpRZjpmzc5q8mEqN8h07YbBE8JBpYwwABPiYVN1Vg2c5FBSNLz1ogAD0djFLX2w1HI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> I believe that when my concerns about "[PATCH v5 02/22] liveupdate:
> luo_core: integrate with KHO" [1] are resolved this patch won't be needed.
>
> [1] https://lore.kernel.org/all/aROZi043lxtegqWE@kernel.org/

Thank you, I replied to your comments in that patch. However, until
KHO becomes statless this change is needed. We *must* have KHO image
as part of kexec load if liveupdate=1.

>
> > Pasha
>
> --
> Sincerely yours,
> Mike.

