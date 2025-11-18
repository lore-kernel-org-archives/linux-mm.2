Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5E07CEE328
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 15:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23E646B0007; Tue, 18 Nov 2025 10:38:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216566B000D; Tue, 18 Nov 2025 10:38:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12BD16B0011; Tue, 18 Nov 2025 10:38:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 02C306B0007
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:38:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C732B1405DD
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:38:11 +0000 (UTC)
X-FDA: 84124133982.04.2BB1F44
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id C44D514000F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:38:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Vw8ZZuzd;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763480289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6uekXVR+jn/Plqa3NW/kjSUDt55yanBt9ufFPxdFs0=;
	b=A35km+iq+I5Q09QVUKYIGCVFxqjmM0Dfpv9oacwzGAPmaHnbf/E+VmwrLdh6xkH+rUQ09x
	Zny4c3JfRXXS7uIkn8eDakKnCgFceIBoP3nSniNfzzWHHepkEzZzEiyNz30M8d8SeoG+0n
	gtjSKLShf67zCt+W3nPZiMyRNJ4Q04s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Vw8ZZuzd;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763480289; a=rsa-sha256;
	cv=none;
	b=PFtMJAc/1O96GY/BxZysLXqYYmStt9O5KqUl6IN/6SUOzzjR8UZjdTZJGYu9X5FkMmZBC1
	bDu6Iz1IIG58XJrtB5hxEItLPnliV7pdX+L0/h0kaK0sDixwPvKg2gsN9HSC/xxJNeRDZD
	va+kKlkSB4TcL4e5hIUzw2TUVTmxQq0=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-644f90587e5so2207045a12.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763480288; x=1764085088; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B6uekXVR+jn/Plqa3NW/kjSUDt55yanBt9ufFPxdFs0=;
        b=Vw8ZZuzdYH67dP7PLEg8KIeZBidInL5KGqy/DswtL+GyPT3wbPnmTaGQHA4MAhcRPJ
         etgh2t8x2WTzaXpeuOtGnYdGmVqnLnc48G2hfhwJGV8+dEgSt6Xhjb779d4l4mBTtALO
         IwZkUDI618D4Dnt9bFSGcrkS1V8A/N5aIHb9h64O9q0mrFipRgtYHAUmhd3VflHcgj+1
         HLr4IPlcXPpUSTZO2JAxY0UqYaEhoF+CGBXmSkRWzQXMTxcMesbEXcdwsz6NbVTNVA8y
         Ug2dc/gf+vw76hF3wYQGlu+SSfGmjlyHdIFegaVsVeSdDR5WJbrCk4WelySrAZPGTlsi
         cVsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763480288; x=1764085088;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B6uekXVR+jn/Plqa3NW/kjSUDt55yanBt9ufFPxdFs0=;
        b=osqAIOBXLBQbXJAH/hWGFdVUNaKphc76LG1zlCK+wrlNj4bvG1PXKP00PN7GHsYT7m
         Qb5ZTVBIp3QxCrq3unt5odEN8V2fL0K+3Nx10gRqM2RdhzXAoM+TzepKaGSgWwdr+etu
         9JeLopMbnF2/zswiaI/Jhn+PQHasVFSQpCnNIRW0ggMIWdEneSJND7aG142SYVpuxwHs
         j3ANNb2amHDw98npiTFiYs3KcJZmk7eqbjpx/GO2mXeXz228MYCzSWlNnRG8PliZUVSu
         4ez2UmuAaLdV4yeAuq15JPXxoe/bNbk6xyRAyffu5TQ/RAQcigzqRj6dFhXSJiFOojYh
         WZJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZ8tE+02aB/XVaJPeeoJ0mXPrZeHz1u9ObZtH6xfyw502NyadrtadJxXsjXOzkhSQae1eAbhyygg==@kvack.org
X-Gm-Message-State: AOJu0Yw+D5F0/RoAZ/JmkoTYb3f5RxbFG3qBddmQY+UtzsdtgF0dVNEy
	g3C7Ke0TnLaVgTC7ypg2IVNIvdTdq4ikGsFLUQgG/cupZnpK1ZsFPgHYWjqf8CtZZgHxmajrz2/
	pNbpoy3g0+ovZSMPGIAoy9BSyy8vZJot90vWzbCtoDQ==
X-Gm-Gg: ASbGncvXDNqinwgazTdt3/fBPKn94aNYGOB9oFkkK6Mn+T9d9/JgIRX0DWnKYmN/wWM
	dgdyDUcaCITZKFlybDlqYhsL5CIrGxbwDBW08W0JLaYmmZv3w6On0HdI9SqwFe77ULHe96aKmh0
	EO04FVsX3dv9oMaCV3nSoJIzW8muSFnGJuDC1FCUfAwbTBRXbG6sP2IZ620m/n7zJzF9aMFHDmM
	bvgkWckCIEgts5tTq2Euiq+TEzF7PTCR+rdNzmTJgSpKrsIByVz+kjcHZ7Cyoa2xGeJ8unNwJkj
	AtA=
X-Google-Smtp-Source: AGHT+IGrjPyW93BjIwBqBDRqzXa58mN2pSY6sOqPun6CMHKlu12QPm0Wx9wn3sNAxL6K2ljWwKgu92DgB9iBQq14qms=
X-Received: by 2002:a05:6402:2112:b0:641:1d64:8dce with SMTP id
 4fb4d7f45d1cf-64350e8e0fdmr16538410a12.17.1763480287895; Tue, 18 Nov 2025
 07:38:07 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-9-pasha.tatashin@soleen.com> <aRrtRfJaaIHw5DZN@kernel.org>
 <CA+CK2bBxVNRkJ-8Qv1AzfHEwpxnc4fSxdzKCL_7ku0TMd6Rjow@mail.gmail.com> <aRxYQKrQeP8BzR_2@kernel.org>
In-Reply-To: <aRxYQKrQeP8BzR_2@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 18 Nov 2025 10:37:30 -0500
X-Gm-Features: AWmQ_bmD9p5Nn1RKDLqeZ98HzkdyZzvLR0FYSVXPyrJripjLvaLejIY3K1PEUqg
Message-ID: <CA+CK2bASYtBndN24HZhkndDpsrU1rwjCokE=9eLZUq2Jhj6bag@mail.gmail.com>
Subject: Re: [PATCH v6 08/20] liveupdate: luo_flb: Introduce
 File-Lifecycle-Bound global state
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C44D514000F
X-Stat-Signature: dcy4e8gwsbf1ga3o4enc53ekd1ztz7e4
X-Rspam-User: 
X-HE-Tag: 1763480289-308193
X-HE-Meta: U2FsdGVkX19Q3UDnRZP2QQSPt1dyiuYrT1YuEn7y2wIgMp/gX0E3pXzNLiA2mV95oIoE6k/FSRcM0E0l4dQfXO8xpebk9c51swypoJASoNpIyB+SMa82LfHbVSPsUoksrlRgDiIIO2eAowFT7jK9494ILCXwa6C3kDU0hQ6xbra/rzQtFdqZi15UC2rD4Dw2JrE9Zr97WtVgKL4prK10DzyLc0XvU9bM4ThA65ADlpL+7zb/lHB2x2TXrCJkpNtb646CzrhHkl3IVNoqc83ONQgbTPEvUGssR/0V8aBnFSJ2ncLHH4pYbIu0KaBhuEosEn0UbdgCn3Nv1jlj9UWBgHRCgotpLLokU1W90p2UhuFtz4F1xVG6DNed7KrV1zH0+U5Iemzk5TDgjtIpuBtx3m94C1RVv0adj9M7BIe5TeQsdXVm0zryRzoCV1M5Xs/xpnW825vlQ6yCby6V/2ULPXQBCh8IaJMEJ7eGN0zh45/08kXyK0fWFV6Yw0dEbNhOsftoD7iYD5UI4nd41Ba4zzeSXPZ6KlBsLefn20Zi8M/w//1aYsTU5aWHkj9qObX5Uz+7SCBzupmEPX8G+MemxtN22IR873yBd/AZz7m4RWa3jq80RhTLGFk8rIGs8TUfVSqceLv/0hq17vx1ZIG8iCjoDtKg5tYTlHAE3UproOatwNlmcqBZyjNiFYSwnsUmEhpHMSSFxBfhzjExW/xZ/dnnQF0nKwUuhb4eZgZxs4uXXqvkSRPnc7LXj8arTHssKiIVHQmhe9IATikm3V1VJ65FSChPIeWiWdiq0UGK04vvwOtvb64cxrNfE71vU68hfoDcQOs9+BexUxypKDdD1L/mv/tgiQmVDh5qJ/RndvjNq55Hpdrk11TSLCyRybqX9bCuazByvLt5zPyYdCulWJ2LZG+M3vmPSy2NcyN/SkaFB+AhzrG00i4wIMxqDF5HYzRuRvcPRIODc6MG/pH
 OYq3NVMJ
 tnKkVK8/0LuoaxwgR6XFm0ggp23v9ZNTtKs5S5SRMlQbbjtyef9vwX9VWfBKurLY0iEUh7qNklh99Ojckm6Qoav5OBEPfk/WFVlgOtdYaK0XCklvKjkfFU7b3/clVmXJoInoLEx1OuLFuSzuIF9XIUb2OiMsTIu9/ZHJsmB6H256k4pQokGFVDkmho0VF6myWiXuiNTEjIxoycOKY5L2dbUmNGchmtwyBu1sIDhBNW+5VLSvKUMoZ1dp+POy1qgUMIX/Yn5CMVhOEXZNKWn08AgdQ7oh6bl1frd8ius9acxfTQlwE0kPncQio5cNZqpTs5c57rp8yaUloj9c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 6:28=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Mon, Nov 17, 2025 at 10:54:29PM -0500, Pasha Tatashin wrote:
> > >
> > > The concept makes sense to me, but it's hard to review the implementa=
tion
> > > without an actual user.
> >
> > There are three users: we will have HugeTLB support that is going to
> > be posted as RFC in a few weeks. Also, in two weeks we are going to
> > have an updated VFIO and IOMMU series posted both using FLBs. In the
> > mean time, this series provides an FLB in-kernel test that verifies
> > that multiple FLBs can be attached to File-Handlers, and the basic
> > interfaces are working.
>
> Which means that essentially there won't be a real kernel user for FLB fo=
r
> a while.
> We usually don't merge dead code because some future patchset depends on
> it.

I understand the concern. I would prefer to merge FLB with the rest of
the LUO series; I don't view it as completely dead code since I have
added the in-kernel test that specifically exercises and validates
this API.

> I think it should stay in mm-nonmm-unstable if Andrew does not mind keepi=
ng
> it there until the first user is going to land and then FLB will move
> upstream along with that user.

My reasoning for pushing for inclusion now is that there are many
developers who currently depend on the FLB functionality. Having it in
a public tree, preferably upstream, or at least linux-next, would be
highly beneficial for their development and testing.

However, to avoid blocking the entire series, I am going to move the
FLB patch and the in-kernel test patch to be the last two patches in
LUOv7.

This way, the rest of the LUO series can be merged without them if
they are blocked, however, in this case it would be best if the two
FLB patches stayed in mm tree to allow VFIO/IOMMU/PCI/HugeTLB
preservation developers to use them, as they all depend on functional
FLB.

Pasha

