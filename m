Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6C9C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 20:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4E6D6B0096; Wed,  6 Aug 2025 16:14:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C26636B0098; Wed,  6 Aug 2025 16:14:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16056B0099; Wed,  6 Aug 2025 16:14:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A01826B0096
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:14:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F9D481BFA
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:14:58 +0000 (UTC)
X-FDA: 83747436276.03.EA2BF60
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7DF378000F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:14:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YNZoFbmU;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754511296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZDHpr0+0p20pkDv2mu3Q9yjs57G8bc2Ou1cKrq4mu+Q=;
	b=25uv5G/mdxB6gHzEBem26X0doZPFgf5HkQ3YM74TFBFElM+QuZdDq01f2zh/h0o0k0j0XP
	w11Jb2Qaikb0GMSNrZZpESE0C4d0ib5+U+FuW3AUxorg11MN498ifXSks563Gr+85UeWhu
	739A5AuBvcS72PG05NTKd9Qwk1ly9T4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YNZoFbmU;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754511296; a=rsa-sha256;
	cv=none;
	b=ei4TMhKYsAhZq6eYCUK5L1yOm7HNW3+EgqwJyWt8PBuQsv64Q0vrLv8zehNNuS43+/Uvdz
	gC7bVXrf7WpKsl+cP1NbeUkLnNyaPhj+jIN4VepS0tyVu0a4wFDDiopqAtk5VdPRQHRoLQ
	6UhzRFCEl6TKURhq1NlEHfVadFtitB0=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4af12ba9800so4189121cf.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 13:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754511295; x=1755116095; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDHpr0+0p20pkDv2mu3Q9yjs57G8bc2Ou1cKrq4mu+Q=;
        b=YNZoFbmUHB+U0OHsmN57asqlVdHOhelk7bEISEzvZEFLB4axeCeivP4JE0gI0ndg29
         CrlVAVF06zj2Xy9+NkfUMUxtQgU0qoXSN001Rkp+lu3wHgHtZsh/qHftPpzSDuQhsYBV
         kEnvYVafYdAqeTGhYr1FeROKD3pt2JRZUJxkpwjxFdO+bxtJb3x7ZoY5NykXFku3Bagb
         /qtuhedjExyWv6lNjgSk8o3Y/3BQzIGUsy17Py2qi8mJKyJi35vDfX3jRvciKZ1B8fb3
         J/+N9n1MijOFs4nNh1pTTjKzkU5fTfVl1CVaQEcRvRmRrnwsvhtePRu8HERoFvpldPCQ
         cfaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754511295; x=1755116095;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZDHpr0+0p20pkDv2mu3Q9yjs57G8bc2Ou1cKrq4mu+Q=;
        b=ncmwfRs6giXXUPehJaBabn5Gf2watzWp9kcMI2upR0RzXkw2HPNICoy29v+BTzgw03
         qON5vaqnuBDXMIsvq2KhNhcDkApabMYqtwHFS81nSICWCLIDnO9sgFGjfkSHBZFTsThw
         xVPYF8jHhk0UBxJToRhEntcryVFxbCLua8S3AV8+jas7tjN0bIbkbE/Wd84Xb71HKTwv
         NL1N0LtG4J//dxDdqZtl60l8iuDgN4bCLlzBwlNfqw1fbFDEcYK15gY48aayBU4yBayH
         O5ta0EAfZ4JaumzFnZ1OS9EWnaatZQ46/OKEWK8EqaTjA0eux2YzyG2UsyjNCg3iToHU
         m3Tg==
X-Forwarded-Encrypted: i=1; AJvYcCULlhbXq05dvgv262dtRiHv6QJn2SbGKr2JehD6xvUmaaJeDowL63t7cjgWrskebPw8M8fk4muc9Q==@kvack.org
X-Gm-Message-State: AOJu0YyJthgMAjO6KGWCbYfRp0/Wv6b2taScuVhKe4xnHbh4C3b9xemZ
	jpyHPKrr07MEK0Y9vwJtpWd5PHs10hOvCt/cswYDmblcXFcf4ufCCsFzLiSVtXZlubpE48DF8OM
	7Wy8cxLmQihXRmv6LZWJFZ7fLe+oibGrtj+0wr1uuqg==
X-Gm-Gg: ASbGnctsPe8bPamsbQBgk8EQvpLcrprZI7CKAzFXpYndcIbZxODTByFzjfda44NszPB
	vhW9GKcQNMY6swaKxwXTmKMBjqpXkgzDBwOLpBepNliR/HCU5QyZIO+U40woMBmGGiorzjXTfCj
	HvujurRHgSlmLk/qGncpskDMXMBUXogyXNVq3usqRFz+JECCSljESFfd7+RfTaGT/jWVCTud95r
	9FB
X-Google-Smtp-Source: AGHT+IG1pTZIp3NhezI/eRT45NKH+mtzWFGAo+1iZoAphp7Sfj8eCIzIiMWt+Cx51Yqtbvyg1UAKQ14ylzy/wQGMu4A=
X-Received: by 2002:a05:622a:3cb:b0:4b0:7950:8cdb with SMTP id
 d75a77b69052e-4b09267f8cdmr58173331cf.31.1754511295380; Wed, 06 Aug 2025
 13:14:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
 <20250723144649.1696299-32-pasha.tatashin@soleen.com> <20250729161450.GM36037@nvidia.com>
 <877bzqkc38.ffs@tglx> <20250729222157.GT36037@nvidia.com> <20250729183548.49d6c2dc@gandalf.local.home>
 <mafs07bzqeg3x.fsf@kernel.org> <CA+CK2bA=pmEtNWc5nN2hWcepq_+8HtbH2mTP2UUgabZ8ERaROw@mail.gmail.com>
 <mafs0ectod5eb.fsf@kernel.org>
In-Reply-To: <mafs0ectod5eb.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 6 Aug 2025 20:14:18 +0000
X-Gm-Features: Ac12FXzhqMjLum8cECX_x2Yzk_OzuXfSOe_mHCnoev6H-Zqbf5NvubJCxtWA6gg
Message-ID: <CA+CK2bCwe-9QzEbG60csWAWwKC+XMrv5=3DHOJFkBVLgkzTsEg@mail.gmail.com>
Subject: Re: [PATCH v2 31/32] libluo: introduce luoctl
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Thomas Gleixner <tglx@linutronix.de>, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, anna.schumaker@oracle.com, song@kernel.org, 
	zhangguopeng@kylinos.cn, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DF378000F
X-Rspamd-Server: rspam06
X-Stat-Signature: qz7te4zhp9tru96kzttbuxeydxt8a8dm
X-HE-Tag: 1754511296-968384
X-HE-Meta: U2FsdGVkX18f9Ij5/AeqJO91FR9rNLSx27uLGxgOinT89yDvAEYBx7F6JscoF6dYASaawJ/MJXMphYYiFqXhAQdBFqGVwO2wrVFdbASiKGCdxVX0ko3Bz78MHQwigj3U260btuJc8p0GaIiGbbk2OIO5vRkjeT0cNcW2sAf1Xp64kdT1Yrb0v0I9cPNh3HDrw5DwSxDcNYFgl72Ou5RbloNYxrSD8K1M7cSqOlNxbbIQlx/kYg9lvvuyoEfAyiUMHafc/DCZKjk67PmFOcHe0ib1+ASw3RYqEgyAgBtYBgkB5C+8bTWLJXqolnqFrCXD90P+GLI8xP7YsWVcXVpsyp65Yhru2VlyDgdBxkSiEDRthr7Dzew/fFDS+YRtakP3uOay5gLQbON6X9JWdqHDyZHGOh8TAes8wd46y2kjfOMLPrxAC02qaTzf9s9cXxZoQxyETgxa9MvjR+LlvcQM2k1WT6AEGZ/nnz1XAbmj2s0vo7xDUOICB10pGIHOS0ID+UERyeqD2aEYeiPwLieN6H1I0dIbmi1dLvaFpKdhTosvATpZXVCWokFQknIfLEXPlAjccn99dq+Jr7MU35NhrR7zYIMb7zBOdX3X3z3/ZyT5zIXauJZv8WvCPCSoK2KtQxCwOvs2Pu51dDIipeojElPg1SEQGGgk/GMNwnTpu+QkrSJqJZcUsGmTP+36vMux8MxPFIzuzgyKNhlBqz0k7bYeHT5ObwhlHyjkje2dBUjJlzk/GvRr3NAkX+ZsBt7biXze5tyyETgTdAzurYYmduN2F3mYb3i33wFH9RFE2PlPOtCaOACrd1K+UBO3BjpajK1rgoDBDi5nXemAeaSDwM2FEaGvV+uUlR5YeLQixlawRSmXCYKad9DtCkGrITr+cDMEh7zmrDY3Sal/QGbtyr3w0n6f2eoqW2CRDOfmI2dskmDr+nwFQ9zKs2U20pZW2YKk6qpF+u/VvX37Jhi
 eXSzflBA
 gPaX6nAthDIfDIA9R4SUUWPF4Gx0o4bGMJJXSO3KiZ6oxzjo5ayGieeMU7yAQyYBEW45ye5F9cKN906H3jFOSQuNoqjTRlOloL/FB/qQiHCWjKmie/S/7SHGfdV2YSvfLFk7zK5R9bJQ65nc9XxtOWqv1eKTBGUyVc4vG6U06OQ2qviZrTnRaj6D4PfV61gP/ttKzPlRFn1QceGA5Af3j8me2xMpaaBqHZLyXurYaimxBpB/TmpCkDrBynw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> I didn't mean this for the memfd patches, only for libluo.

Makes, sense, memfd patches are going to be submitted together with
the rest of the series as PATCH, sorry for confusion.

Pasha

