Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CB6FCA0FED
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 18:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 784586B02CF; Tue, 26 Aug 2025 14:58:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70E476B02D0; Tue, 26 Aug 2025 14:58:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D5E76B02D1; Tue, 26 Aug 2025 14:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 482486B02CF
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:58:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C79B81402A5
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 18:58:46 +0000 (UTC)
X-FDA: 83819820252.18.1E35418
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id E371740019
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 18:58:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PV4zNNTv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756234725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pJME+1KmU2SzOA/lb1+BnOW4h/J3iSbhKPhNpdWiID4=;
	b=ycqEw/PxX8FsQ30Z7NNJq+QprTaxPD34XxUjDDghnJNPGmJu8Zq+NgNbIMHuAwCDpXnbaN
	fzIJ5KvDB0G2q53RlL1B4jKEP2+6+QNlsnDuMgyQlUt+m/RCv6DrlH2qDRGuCVCwRzEYCy
	nIQfxGONYHjUzeENVILjFGNfGE0MgsE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PV4zNNTv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756234725; a=rsa-sha256;
	cv=none;
	b=YrX9mYuJDRwf0dH+WpGwnSYDXc/E7CA2dctF/NFsT1a3z4zqzqtiqd5E6Cw2MSDdV0yIpc
	i9EnDPSTnY/lOMNL+2eRWjKUH+fAqEhxJdMfZvJ95QTYUpD/BuyM36389JvFGSWKj/TmS0
	J3SNtciqREWb4sG2liTI775mSHzumV8=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b109c4af9eso49037551cf.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1756234724; x=1756839524; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pJME+1KmU2SzOA/lb1+BnOW4h/J3iSbhKPhNpdWiID4=;
        b=PV4zNNTv249ze6+EtXYDo+sbVpZZ4UqL3WHykPyyq2TfzziZ3LWxrudrETOh2AAtga
         k0ISRG4/gmwBysoz6WVTf+TvpDgwJxkcn7lDnepGc/gjc2BXN9q2o2z0uCoiKs4Oa0Av
         +hVIFTXebW2568jQIn4RbINRQcpLRPZlVErST4YRRh0SoKcoVSND3oDNAlqXQdhVIg4W
         fxU7lhO4NiLp+7wSZ7ov7Ez2dx7hb4bUBhC1mWJq4X2/wILUbKKmZgfTPNVIiICeTbeD
         SaYGSu01WvpUM3tVANet98G3TIfRh/GJVBcAxmjhRu0naT+vTLDUOnRwpYBw97KNbtJ/
         2SCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756234724; x=1756839524;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pJME+1KmU2SzOA/lb1+BnOW4h/J3iSbhKPhNpdWiID4=;
        b=XuyLJVOntFBkcAVPKmnzctNsyf06dYrpsY1PXg7/zumvMv1vvkvqY7rPu0Gejx7AXc
         Qb+MbbVrpJ3YPvPIlPIHLS7USlVAxdMgDsOaHsDcD6NGhUha661guYrB9PUUI7eEvFt4
         mIz+o2Tvuavy9vRganoso/Jb2X4xrLrUE9Bibjvire+BaKmJIN41N9+02boDXGeBx9O7
         ij79vgDiS5RBbNR3UXm/oE8iuQNYA5tl4vYWPyAzmKEhqGt1Hd6az2JDduel3E9o6t5q
         TP8FeKFh0n23tlZ9/4f2dn673ryqmroOfI1azwgwMag/K1ERn5SLDtUBvcMQ8MaSzbot
         4V5g==
X-Forwarded-Encrypted: i=1; AJvYcCW3CvcCG1Wu8wVK8jPFs1Dj9RzCQO5WQyaxB7pPYeNzKtKM2wiKM+0yjHeCSLTpMXAxX+/9drXysQ==@kvack.org
X-Gm-Message-State: AOJu0YyHKt/BgEdwg+bb/pwbESW9Ii1MXMHFddYmGfulOkFFsURbfkj/
	ZA/5IExTBs6NHoFQZWN3b7HDVC6nan5CD//5399Yt/FlZ2r3JZtH2NpJ1C0YU8A9ArBdpMEySk/
	UzrW684isa/YiFFALUuA2FlCtpa2/rbQgUFYOjV/aeQ==
X-Gm-Gg: ASbGncu5mqwY0u4Zpa3WiCmDQW0F1ghbLKswyj9mJqjqDAqK1ybJLr9uToRzruYuq3W
	1qb9b5dH71qMTmHqLVUu4xBEOzxgGrznq6n5akmnVrKVjOTvwEBvv7G2pQ4qRXpzaVq6NrN14Oc
	m4IIZhnCkVWgQ5g9lFE/WGlS1EBviqJjtpYL1B9PHS0ZXAh+/Sjp3Y24eK7NotwB01RJamCcd8B
	D7Q
X-Google-Smtp-Source: AGHT+IH7x6PzB/jpkOPVprK93HcHA2jlE9LSPDmfVuRTuFZ8graOQso5EGuliHqnNQqcqLY5o7Pky9G7peBJC7yYL1M=
X-Received: by 2002:a05:622a:286:b0:4b2:d5bf:20a1 with SMTP id
 d75a77b69052e-4b2d5bf2602mr93874511cf.23.1756234723572; Tue, 26 Aug 2025
 11:58:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-20-pasha.tatashin@soleen.com> <20250826160307.GC2130239@nvidia.com>
In-Reply-To: <20250826160307.GC2130239@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 26 Aug 2025 18:58:05 +0000
X-Gm-Features: Ac12FXzbC4_094zxu3z9fUDRO3yQVd4QdY6g8DyMrUl3RDt_kmv57pEA7HFGGV8
Message-ID: <CA+CK2bCR84H90dZP40yFw086JP+YwH4=V0ncFfNoR8Mo5+azkA@mail.gmail.com>
Subject: Re: [PATCH v3 19/30] liveupdate: luo_sysfs: add sysfs state monitoring
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E371740019
X-Stat-Signature: y7i9izoubofe4oekjcred3uxafmbc5z7
X-Rspam-User: 
X-HE-Tag: 1756234724-395687
X-HE-Meta: U2FsdGVkX1+Ox+xzhRMt40ECHUf2Ko4rxNqLMfEzGGJXjatPnMhq9uh0Aa99xdBIlM37KAamnRGxPKtpbXVDjy5VpHvoCTbXnzUDlcflBNer+fYTNU6KaEM52Tv/8ByNBqJHwl/KiewXzoXNYM7nEmon3mxmo23DBZxsDEmLzHtknUdpXObq++uA6tL+WK27F7CPJXkqU7UdTDlB++ThGn2/xZt9yHULDfORZPmmKlARNpZZMI1guo7yumZpjc5+sL9kV2qsOnd+CNtVekvgkgVPiBSuoy0sT6/15arU/u4S3z2CH8DV59gxFbwWhkutbU8T5h4wPh9RFhjXo9DQvfSoA4LHDzKI/XThI79XS9hQEHF3sLT5mvmYrtvnsODP6nv+OCVt34BuUQivADCc4P9SunCL+n4ppvjsFpOpvCnpSaWtqLFdPIxcDNzncRLrCcUe1PH0JEqnIAN3rkhgbGbvWyMYt8+7KS/K4dIXGy1p6NvEbiSn8Z4i+i+HVIj8iBm5iBIr3OJK0NlPB7Dq5IQ/smoj9MX0fMc9cCQeiOT3ymng92HMIUuywCAFkUM0CcfYzkLHHcs6PLR9DzAGv4gsJN/EFH2AofLGkmWufvJ8Osylt2N4coS/ERz/z0WwX8xhq1rHaaAeq5rc80lFDfgiDN9hOLoaR6PFqn0nmRZmyYHYN0rtunpQoy4Kp0biF2NpipOxqDTbU+FDSzRjVgC2yL8hsl+SYSPsBOWIdTTcX0qpBJ/b+iVTla1FeVb3EWSdU0oxqJKLFLIatXXlBuJKTsy6eWOqj+RRPWC6Z/Qdih8B6GiegRZW5jjgzly29YHnXzB31g0ZgjleF61gMERjKe/vd6JKtouDEexBaYxDEoS0hIFB6mAaUdfw4KZNcI2QPSwiFNQY5ee0DAiaHsP8twGLyfzEsmZVgAieSrk+t21QC6oJJOaKka6M0q9NKjFpvVcc65vihbbelYh
 yOLmSYTe
 pAAmamsRn2c6QmNybfxiPzzCbMRVCwEcoeaC3RxCoGIMSxoaLvKfP9qFI+rso2GnG21vHCLD8W/FLA9ICmTZl9DnP1lEPERmKOla3EtHmQ8fDdBU06tLpwT0eUoH1xTVHkS62W82/NOh/Hg+5AZhF5yL9+r/V6neP7HehPpj6tsHiwfkeCXFDcBRfItsK6NkS1xaDtCIG25/Wc8wZjaL8JQj70MXxTEmU4WsQqIQ5E451iyB+xjCxLh/5FqG96DF2kNnnxc3onAKrvbbv98ZOyi06lL4T5kFKoI1d5dDxK6vgldaVJAAUyKNgAfsGHrPiM68voi4nIDLol01ghH/bSUlvPptkjd2mNV8d7ABvxDVH0LXvpV8uavH7z+4PXQJNTxTCG9aFJ7d/kEPTcVdjGoIV+7H72nvX1xBEYo3P/6ZYZUoW3v2tHuwCgxFJqC1buC7S7W+obRnEu0o/dczF57BMGhZyW0DFAR4xte4TnYYpPIYobEtNtkOfgL0CiNcY5MVS2X36RRp43G976zmy+mjMH1F1oxfhxJGFr6HI0uaE81X5NPtbeJ8UX0mVQImj6rHG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 4:03=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Thu, Aug 07, 2025 at 01:44:25AM +0000, Pasha Tatashin wrote:
> > Introduce a sysfs interface for the Live Update Orchestrator
> > under /sys/kernel/liveupdate/. This interface provides a way for
> > userspace tools and scripts to monitor the current state of the LUO
> > state machine.
>
> Now that you have a cdev these files may be more logically placed
> under the cdev's sysfs and not under kernel? This can be done easially
> using the attribute mechanisms in the struct device.
>
> Again sort of back to my earlier point that everything should be
> logically linked to the cdev as though there could be many cdevs, even
> though there are not. It just keeps the code design more properly
> layered and understanble rather than doing something unique..

I am going to drop this patch entirely, and only rely on "luoctl
state" (see https://tinyurl.com/luoddesign) to query the state from
"/dev/liveupdate"

Pasha

