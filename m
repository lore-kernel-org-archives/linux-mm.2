Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 451FDCED606
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 11:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57C966B0022; Tue, 18 Nov 2025 06:22:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 554926B00AF; Tue, 18 Nov 2025 06:22:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46A3E6B00B0; Tue, 18 Nov 2025 06:22:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30CAC6B0022
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:22:04 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF991592C2
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:22:03 +0000 (UTC)
X-FDA: 84123488526.28.1348775
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0E93280009
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:22:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PiVE8uzM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763464922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DxOYts0Fmp5FDQWz0e0QXGnzOFM/fR7pmTcekd0dh2Y=;
	b=kJnhqhSCIBLlyrPwK18TqjaeWKoK0KXxdI78NOi1Nqy5g2O2dLTWhRXB6TMCxhMMN9sLU8
	TvB3nLivlKiWafSbunQCmvyOuahqcLKaNNW/GUj404LSXpAF/a1zfs5pyI1/skTagELXDJ
	uRUZFy0eKalu4PaU589jB4sqmZmXtcY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763464922; a=rsa-sha256;
	cv=none;
	b=6D9ZxmkXsb44Fm2h/+OalrVr9grTHB2bYJiIta+x9G9Z6vssCDtrwShqt0Vy2JcyGifyai
	Kw05ejSQqdIvzzDwxYuUjbJNe3DiUPWakmnSzjvbr2O3JmyhILSIgLJ5aoe7YGLNRFEOH3
	15fxf2gDFL0RB6Tnpq88xNUZwM8jW30=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PiVE8uzM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DE4F60192;
	Tue, 18 Nov 2025 11:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7B3C19423;
	Tue, 18 Nov 2025 11:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763464920;
	bh=OSqrTzVKPfEphWSOWozqjN2DP6jQ1KyGCt3LKIzrAwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PiVE8uzMlUpbGMOt63k6vT8hw2abfpbdQAia0dP8s95gP0HGX5fqQBVw6T71VApzj
	 KxmYgAGG71dqGOdUg4HjnG6IuQfg5PpRaH9zD70xx5QpJ7SyM66AJNLOx41zAmQA76
	 Se7qyl+Bj42AlkZ9gFU1Kz+G0qbs1PPVvgf6TZpliCSjdo57yFzup0baGiLn44pKgD
	 ovt78WFggNj7PnxWuPJy7GVjcsYBZ9hWBPefxqqiLlACZYHUOKyU51ZYZ1hV8/c5am
	 LqW7CgaFMV4iZ3wVEipl+0eGPKrwlgcDDl07AGZJpMGkGhJL2ogQFrtaNtLOsITVkS
	 VYdo9nZgRP7GA==
Date: Tue, 18 Nov 2025 13:21:34 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v6 02/20] liveupdate: luo_core: integrate with KHO
Message-ID: <aRxWvsdv1dQz8oZ4@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-3-pasha.tatashin@soleen.com>
 <aRnG8wDSSAtkEI_z@kernel.org>
 <CA+CK2bDu2FdzyotSwBpGwQtiisv=3f6gC7DzOpebPCxmmpwMYw@mail.gmail.com>
 <aRoi-Pb8jnjaZp0X@kernel.org>
 <CA+CK2bBEs2nr0TmsaV18S-xJTULkobYgv0sU9=RCdReiS0CbPQ@mail.gmail.com>
 <aRuODFfqP-qsxa-j@kernel.org>
 <CA+CK2bAEdNE0Rs1i7GdHz8Q3DK9Npozm8sRL8Epa+o50NOMY7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bAEdNE0Rs1i7GdHz8Q3DK9Npozm8sRL8Epa+o50NOMY7A@mail.gmail.com>
X-Stat-Signature: jou86b3o417zqxrc5qqzubd6dtgbzcw4
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E93280009
X-Rspamd-Server: rspam10
X-HE-Tag: 1763464921-747556
X-HE-Meta: U2FsdGVkX18eC3kPyY8uCcUdtIKHuVe+ppT30PHmRasQutXVuAiwOgdLBhrBT7/O416++Ml0F31JU3VoDkgmrpF+eXoodHGt6lER7Y42H2E+8ioyI8CTzrgZOBkaass4K1kyFWUc9GoOfPiAfZMpcxq2K1q5D3HDYo6MP32PdKHEZbTE46zUqTLk5svtXLrSCNaA539h7AIDjvJh2iaJCU8HU0t371xIqB/3TKXsCDI5GQ7gi33iYZirPXZ7P3fn6TTUrhiN4FtBJb4iRw19Q7RLyMopai3Qzjl/OSoKHAB8biZg3u9yPZb3dxc3+DncckxhB8NZEVmUSF/UZQUb8+gcTdDcakLtZ1Xuxl8yuB+sGOSwgmDKunroAYRyoIqi5Ob1WmCQdtsUuJrwOiO3pQyOvGH82wDsE9PqwFDTOGHhf8RgJWjYT83qzM5brcsnU957XmlVY8tg3aoh889Gvti+J93z6EQTalgaaovZYBZsay5Ck+2xSbC/LTf9+zNqfwAIEU7M4Nt+OAqUy9g0pPyK+tJX4xF/SCJMjwo2Zp/K37gD3/IhLmFu4P2Ctp+TFGgdYUKP9Mto2A7vSIUVPUcLA+twR41FWchgdjMSHg+Gm7OAbCGDwFRA0n4GSmXMEkhElSIhAvGuokr7RSHz7ZISpIZd/dvU1gEuo7QPISrGdFnFGKB1YUoD/HdUPe4ep+pu+AmbEzLN1Va/n3fOB+tU3iO3stTbFYeyOf5NK0ZKIp7m7bM8D4XjsLp78kp19Cl74+IDsJ6KFFoKXJ7zrbuX8vyI1le0WGoYqkaGVXKCbiXmBUAhOkE65YOeESqfxI/pU0FVC+kdnFAlXtd5Av+4MpOfGSRv06U0o8tSfmpVb68bQunLSvWVXacJrUtYYOZOHY5KFTARx35ZWavDGYcX4by9tysVibdOfi1BFaRfRPyYNN1gzXw3Mg5/Jy42OCMxBO8b6qUMHvFym/j
 xwVKZmbL
 OGV5s+nyuxnEHKZWEDNnIq+YVjSePyYNfDITb17CV5ocnsyuOOke4yK7rsUc7le2MRMIhe9XftMShu2q39qN1qY13be2Msu+8Ul99LKKJUm3BmgC1KQgqF4gG/k9ZPDkSRF6sJDIBvgtQUMHgQYLpu8GA8oB8AdrmLVwUJsJ7cDSNIyObcl/KrzsUjU1NogMERmQYW2RudCf8mfMMU3jvUEYJI/v15DUBbvTTLnQqebw7bBy9fz3wXvj1FkjGFx55ST69LJXBP+ZCbvD7B+Xd+HWrpKeCgVM1+CmSA80wdu3wNMEq+M4SFIvq6udbKuIET8IdjwFIhBixXGLjNtjDixhC6SF2v1D2SUJnM6tz8acPrAQ6AYbOwhDXfo/Zcq4jhN7Ak9ZQ5nYxrC8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 11:22:54PM -0500, Pasha Tatashin wrote:
> > You can avoid that complexity if you register the device with a different
> > fops, but that's technicality.
> >
> > Your point about treating the incoming FDT as an underlying resource that
> > failed to initialize makes sense, but nevertheless userspace needs a
> > reliable way to detect it and parsing dmesg is not something we should rely
> > on.
> 
> I see two solutions:
> 
> 1. LUO fails to retrieve the preserved data, the user gets informed by
> not finding /dev/liveupdate, and studying the dmesg for what has
> happened (in reality in fleets version mismatches should not be
> happening, those should be detected in quals).
> 2. Create a zombie device to return some errno on open, and still
> study dmesg to understand what really happened.

User should not study dmesg. We need another solution.
What's wrong with e.g. ioctl()?
 
> I think that 1 is better
> 
> Pasha

-- 
Sincerely yours,
Mike.

