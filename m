Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18452CFD355
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 20:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BEE96B0011; Mon, 24 Nov 2025 15:44:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6967E6B0024; Mon, 24 Nov 2025 15:44:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D3006B0095; Mon, 24 Nov 2025 15:44:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4CCEA6B0011
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:44:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82F291605A5
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:44:15 +0000 (UTC)
X-FDA: 84146678070.12.3E602C6
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9DDC61C0012
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:44:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=c1PbeZxY;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764017053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBE6LeQp/9dxs9+8oqbQWSo19CZnncAHHP/erXGXDYE=;
	b=7Cbd1b7du/2N48Xap6GNd4MM6PVdseypyc7eoZ7z+KaJnfdyALhOhS2qYeIGWmnJUiOElU
	cNHzFZGcunp0zpVoql3U/cjkwGvQLIwcgW7Y7YyU5Q3Ynm3bRURpvhnjcKtUn6G89oSbfo
	w0EaBfMq0VdKwArZ2+i0VbmJwTRRvdA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764017053; a=rsa-sha256;
	cv=none;
	b=rG+jjHgnse2xKGXHpOk57TCTKpWk30y/bf61v41XrC2w6YtoJb2k5rN3LBL1t4zVLXUiMA
	ITCcbwYL7Hg2JMyWS4VWzQJWOBLCWUCyZJ/O+ME2OUL/31vIE/P9Emm3GpCL24PcxULn6L
	rfsKtGUyBYPpHMYJEbBYRaMeBpRogFM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=c1PbeZxY;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-641677916b5so7083510a12.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764017052; x=1764621852; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BBE6LeQp/9dxs9+8oqbQWSo19CZnncAHHP/erXGXDYE=;
        b=c1PbeZxYCbcXcTHxTERWNbYN29Kwxva6xoHjRQpMXbbWx4HpuMi90n83Fu3u3mvO/1
         DJRi+39bWzptsgJL5SYfUFie9+Z10x/PllMJulb2WRbgpx/jMp2yXQI7YRJnudsXsf7B
         NKJxB/Qu3dgiXe6Jra09+ouGR2uT19d0BviBrH1xih8U4myAot8peyEagHMPxMvEhNfK
         JaontJ35lkmz4rRptTnHSQqPmuyPTyz4wWPOQCxiEzqkUmFW4QEsqRUknPjizY6OCaPE
         UTn/35NCsBRQPPXLRrCnS8c/HrJ7EWkAXc6GsWM4yHN9okbUeD5wLEejLCY4gEhns+Wm
         Fl9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764017052; x=1764621852;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BBE6LeQp/9dxs9+8oqbQWSo19CZnncAHHP/erXGXDYE=;
        b=KafkQn7RYMgXevfAXtGz9i6UBrQdMUMwsc1MznQ1gIYfxSsZs43FB7q2ok1BYRWkLp
         z2qe/KIiu8A6/wUhnNwzYuwXiYtVceTHQEi5HRDxWLvpSkV+xxRWKevp+CdBv0/KCT3O
         lLM3cSHRMIhjYCbHX/mvNfOF9uwtJAHeKM2x1DMtGJxxzsqHZpJQtJWxdtSG4appJiH1
         XnkAfBSub0WquSVHRlaQSeFzkv3brus2dUNJuDf1wxX6Muq2d+bmLesofFeTGER7SiOY
         dAOXayWOsIdpXID9KQmvNH0wZY71vHywtNN39K9tJEUjrt0BtKKgMYTGQzKFlJk0CDO/
         kb4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVMnAsDCfNt9M2Ctao0N0za6FghQOp/5mFjz8fPdg/hXxPbGjc/Y0dQiTk3sxraAt/IHcPVSLcYZg==@kvack.org
X-Gm-Message-State: AOJu0YwIV6sF/ZDPgtB5Yr65X+d3EERW1B1tC9aN6t0Ay2JkhEYBJLHB
	Bu2mN8GQf3lbxp3Kl1MnYT+TIq+nnxQLUki82XZP3pG5QUAQ/oEl+xEmtEmX1VKNJsi/lCCN/cp
	zj7zoJiZGB/9MMAwqyAn6rkExG84fVYvt8l7RPtr0Ug==
X-Gm-Gg: ASbGncsH3zUyHC+j46BhXVwtJma+c7LioClO4PL0Z0KhXQLCaquktlpXyju1+kkKa7M
	RyWKLy82uxHXUkRKu5zVxvSdWen6zZNFJGEr/bnW4xjzZaW8HL9wPKUQuEmthO+TijZx938aO0W
	+W/p7Hke24UlXFzFdgacZ7wHigELUPKbezAgRYRuSPspTJMT3jk+Ey0HGCMZLCQPt4QU42IRgHY
	DnfhfQW3F2u3Aup7IdFtZ//q7QFXWNkOnVdBFsFFzRqjDWuOq+ci5RVUPyguY4V0Nih6nlBLUr/
	hpk=
X-Google-Smtp-Source: AGHT+IGhvW1zbxphQtXzCMtZtUK6gJJpF4SpaRUxkwNlXNg4phdSf38kNJPBHFGIc5NhOi7Yie2O+dbmmBf+QzpJ1eA=
X-Received: by 2002:a05:6402:35d0:b0:640:6653:65c1 with SMTP id
 4fb4d7f45d1cf-64554322775mr12262864a12.5.1764017051792; Mon, 24 Nov 2025
 12:44:11 -0800 (PST)
MIME-Version: 1.0
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-2-pasha.tatashin@soleen.com> <aSLsCxLhrnyUlcy4@kernel.org>
 <CA+CK2bCN7x=eMwfTXF-2+vR=Gn3=41z6Xxx6wM1m7i-rxzug9w@mail.gmail.com> <aSPoIw2keoueM2q8@kernel.org>
In-Reply-To: <aSPoIw2keoueM2q8@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 24 Nov 2025 15:43:34 -0500
X-Gm-Features: AWmQ_bl-mLHs5xZHjLqaNQo3tDZr-xY0sDzlZu79iSrnbtwX9ynUfgq6sBNqNvg
Message-ID: <CA+CK2bDqaVV9=gQUQr81euOJCN2d2vJGH+9fZw-Vcymuff3KdA@mail.gmail.com>
Subject: Re: [PATCH v7 01/22] liveupdate: luo_core: Live Update Orchestrator
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9DDC61C0012
X-Stat-Signature: iaxhfg75cnsgkihwjrkksk5zhsimsfum
X-Rspam-User: 
X-HE-Tag: 1764017053-757232
X-HE-Meta: U2FsdGVkX19JD/FAZLntvvNhO2wifqwshKSRKFcgeIPdH40/IbcKav/LZa93ajWFqZTVyC2Qmmaj7x06IAZrQC/8nRwDaC1Sym4+Xc1i72s6yPkL4prtGXuuTgbAIcMLjnldXiNIiylgT7m2raA0QwRhYpR8huOUEC8r0xKiBSimvRA1bFideiVOnggQ1vAmfClHmoYbJcemni60xeKVcEfOjfMB6ORQ9/cBibh5cJyjhN+tyg8ThUEYzFSesNw4ZVmYn2KsCymcgpwmhgdt20FS2Q0/2FA8Z6y8ZqZ7rj9i17RcK8wU8BIg3CTIxI7qwAqlVteyxSetufvRyJhYy+hzKORGRhb66Qvvp8JCqByffHxvxSYLoE3lskvX4v8w//ljcIu4c8jGZiyRjlwjgASLpDovU4o6UIcfxSdhvujjcXI5LGXmkEAsLvjUUHvpPY48/7MsH+7LMEOIg/nU7Caf3g3Rlp6txg4LBRWfiew/wwcnZ05KIWVuB+ZW3vWLZW7AJ+AI3gZ6h3FeNYlbhtZXd2RVYuSW9PUopxPw7rMYEi7pUBxGS1ANWIt2LTxF+2fOVzK75Z26v6MX8QngFoe0UF/zdl2Qe+j7xNb9IFVLsFR6nqeWzylJXn9F+03C88Mb7j+HwYtfSyqknT2Pp3D/dXPTNhNtf3A7Z90L68y0l8aPQsxr0P9AS43z+z+awVJPrqRrikARc6AT3w5JJxu2eqNwIQvQWRy/w6T8mFVXq8UoppL4ej5zfm8Lw+PB8LrnQS+0duOy1tbDuArOAJRb+G/EL9Mh8ngdhQSG04PD/LX2CJLyFQpRjhNVm/qVYInQTsIXUovwXu5JKQjELrhhyojta/KXFYiQD4iQbpBnjSURL+tpO0p4feO3Z2aMhg71DIGBBxIofW1mhGQO3ymyYH+tK0IBh+IxBGPUmYoXsiibJ8R1WIjlZgmJrF4oo4/+3ohRcnWwnqu8/Kq
 +uitglke
 mURSITsspC7aNPT9Hn0jj8e7CDMqDQnPC5SrbLJNuDcWelB5Zo/xTA/rN/RWGoNBDWnTBmXz/6JzDFq/WgWaexbdbKF5VT+Yqktawpykfo1TGsO85jrzZ9gUd5QDhnMyBSFaNAOyit4h8vj9d1qtAlEwXgwUfhYN4/w046OJCaUk679JvBb4Zwr8rcDl/D/aCq3xObBMfnnFBeFjkb91S4vnjU/ejWOfJWkZgBgrNG1PWQX9sw+qGlOHCqLyMhCJGhPny37UNZM+Q1yMlhyXHPud3xrLtSupB7/QWfnHUYQsH4n36fV2UxdQCsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Sure, or I can remove all of them from Kconfig, whatever you prefer :-)
>
> Quick grepping shows that the vast majority of Kconfigs does not have
> copyright, let's just drop it.

Done

