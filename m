Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83CF7CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 16:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35B58E0010; Tue,  9 Sep 2025 12:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5E68E0001; Tue,  9 Sep 2025 12:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAE4A8E0010; Tue,  9 Sep 2025 12:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B62178E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:31:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64CCEC05FF
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:31:16 +0000 (UTC)
X-FDA: 83870251752.03.2ECAD25
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7CD32C0004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:31:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CUvE10EC;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757435474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mefygqhgG/25eVyDa/qEx6O2io7m5fyI2dwOWnP2+28=;
	b=Cm0Xmp6V4YkS0VKmZmxK9udTB+aMwhJG9TMu0NO88yc9q6oGk70cZxKVwY0ccXeaT4PY9Q
	i/1FdYDLxd7F7e/TZJ/9UdfytxIP14HQyvzAR0fPSQLIzfVjTDw+WZZPKeL6jFt9RrQdIn
	lI5UZKkLU3AGstlNG7lytcviW0eQjQs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757435474; a=rsa-sha256;
	cv=none;
	b=2aYO7/4JdzO5RA13VCHf3PV5CavmwyF4xlc0BeMxtRIh7Qv2Hs15TpMVPidsX3magAr1J1
	F5IXgksxiJQND1hDPrukKfijm8gey7efYrUNZ6fB3x8a8tjAM1+N4NwvmxVnzTrFNBGe6t
	KNe6sq7QjhsC5dx865sgKSl1fTkx908=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CUvE10EC;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4b5fb2f7295so30057101cf.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 09:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1757435473; x=1758040273; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mefygqhgG/25eVyDa/qEx6O2io7m5fyI2dwOWnP2+28=;
        b=CUvE10ECvNrTmXNKyaY6YCaEjRULRGX7VhBvXIsQVnTB/TE4ToQG3JiRzh18E/ZrPL
         uhfseSnlpMY957XrEs6SHqM9ty3UH3JRzhCy5rf8HcfUH/RbvG/Z6xhFiB4rhl5pEkdR
         fOZ0rx/xqjadPYQDIOCRYsXwNdsfWJS6wWrqPWaK8jLqRsgTdraPZ7xtJe2CcHdkf2hN
         JbBvIrbenWODEzKgV/jT/mJXlromntQ9S1ZrB6b7NZOmFIhh19bfMzoFLwF6a1ALTI/i
         lzScu203VAVSBesE6TmRiMjauV5X8PYQSi7KPfe1ysmoxVnVm5QFL/v4otL6gLGi1tSS
         eMqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757435473; x=1758040273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mefygqhgG/25eVyDa/qEx6O2io7m5fyI2dwOWnP2+28=;
        b=ReMDPsHQPyBbB8byq4P9MCxbdaYOb+Nrt9LieC7nWFDxlEkWn/PLLVoZheMZ4VSxzv
         I33wcyeIZSf7b0nillMFrXuzMKwbuENBJ7NSIHpeKlfzYWUeE41YYyqyjlVQcDTvZGPf
         eOPlyxV7a4HmXqGOEb1uP8n5gGnIkGlu2p6dGqYrcDN5nXPlvr1jsdj7Q0Mle6AUdLFG
         8cCpP4+K1Vnz4fEzhKuuEAc/WXEU/kuJz9bOz0Y/G7ueq0i+4SPS1lxqgXWc8MssgYs4
         f+wUu0Jt8Q0qpKtiik8OducYrADrlo2IrByiz5KfHvEkJGGXK92dralDlw9JKfYmzvuS
         JQQw==
X-Forwarded-Encrypted: i=1; AJvYcCXsfMAK8eFiv8zso+QrL0StY2gqSNxGkpxlMazn0lkeeskIQYX5bJoRJeERaKwSEj1b9HykXEfMbA==@kvack.org
X-Gm-Message-State: AOJu0YwP+JEbC+NEjZP/p19iZzh7ZxpeGhZ4vAK+ydwOhKLomMPApzag
	prnDx5bK03EnEq0GpbuTf3CRPozdOD4mraBBTVK3F/ksI6TKcPBGajY+00XEQXg2X2KF9wX2r8i
	bFUKL325jfTV6oY64GIWYEggsSN9zJtLpL1x9cS7OAg==
X-Gm-Gg: ASbGncvpWjE8EA8T5+JuNDn4iBiuw+8+NinahBoIB1qQykjQH7Q40xNfTJEQP9cTVUU
	vqw3AfGBqb3BkqwYTUOhdPA6BrBG8KtofaIOwDfXWbFeD9m+iPl5CGXwSf16zqfdXrUrzv5gu46
	u6WXWWRh8+7fNfRxrd8s8yZbGpGxXtiSYerQZLAHqgdd8azwj/BE83sOqtP/6eccS0gNwLFEndU
	gql
X-Google-Smtp-Source: AGHT+IG7jq+sgIVXGN3h/LueN2WhEhyxg+lgF8zD8d4TVGlNbmugwYuofv2hu7ci7G9Y0iK0GJJdSRb+1h+3q0EXcwA=
X-Received: by 2002:ac8:5acc:0:b0:4b4:94e7:7307 with SMTP id
 d75a77b69052e-4b5f85898f4mr141860471cf.66.1757435473222; Tue, 09 Sep 2025
 09:31:13 -0700 (PDT)
MIME-Version: 1.0
References: <mafs0bjo0yffo.fsf@kernel.org> <20250828124320.GB7333@nvidia.com>
 <mafs0h5xmw12a.fsf@kernel.org> <20250902134846.GN186519@nvidia.com>
 <mafs0v7lzvd7m.fsf@kernel.org> <20250903150157.GH470103@nvidia.com>
 <mafs0a53av0hs.fsf@kernel.org> <20250904144240.GO470103@nvidia.com>
 <mafs0cy7zllsn.fsf@yadavpratyush.com> <CA+CK2bAKL-gyER2abOV-f4M6HOx9=xDE+=jtcDL6YFbQf1-6og@mail.gmail.com>
 <20250909155407.GO789684@nvidia.com>
In-Reply-To: <20250909155407.GO789684@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 9 Sep 2025 12:30:35 -0400
X-Gm-Features: Ac12FXyuJ9OO-2DZjI3E0TxJNzWUwRCJ02D-wXqnWeEvra68NFxAUUaITiNW7fc
Message-ID: <CA+CK2bAvxvXKKanKzMZYrknBnVBUGBwYmgXppdiPbotbXRkGeQ@mail.gmail.com>
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pratyush Yadav <me@yadavpratyush.com>, Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com, 
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
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
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7CD32C0004
X-Stat-Signature: mdhksgae4o4uc95ffxgss1zbgt7tjdeu
X-Rspam-User: 
X-HE-Tag: 1757435474-308898
X-HE-Meta: U2FsdGVkX19P4Y1JJ1I2ZK+kniob1cKVa7f7D+6xniYShrxZtbLHW4PKJZClKU6JnZYEQaIw5q8Hp+CPTQyddFcmAekZ3FGBIrnn7HPFgux+t6njleKlGQcfbX2rmRITpiMn6Qv4scIeCLDMNjtBc3/6Ew31ar3AyMj0QfXpneA2emED4hQAvX8p5SdQWPPKYdhPfYuZXKK1ZjsVKNhplUatha9gLtr+bjeeVKNBDkD3eWG7wtHFVC/XSYZUL8S0Fwa7wL/MHhdCLUv9XZylUDRIkbczUmrZeEgKxbX/KXdfFmveSSXLjc4ayr5662I0DMWwLkEicWwEFDqA3Tpx4MwPwEz4xJfW35mayhJD6ipjUlALVQqkvnmwdqzLp+bPchjP80c42ITZVnYD425wqY+05e3APZtfO3Sp+FrhPF1bEDrXAweMig1EPtx1xA7pI5DFLhdveGl7GireWO19sZkRtLxzOewQ6o1KIO+NJnHY3txD5Rp2xJysUb8wr0FscuUdq+out+WFIMlilKw4Sl7UJVjzwUMk9Qhy0puNjUJP/6bHDiTrsNSZAPWi52NUIv5nMtRG08Hs+PERJA0+p/IXCJg07LRXfUEXNkINEeEBT49JIXCTgB7Ipuj819UkHW5eyv+ZQzH5Dw162Uyt/dijBk4dywtexzcf91A/6oNN2Uvn0+471iYeKxJjIm6ehkmQ42I8hwHeamFS8xQ9O6fFYKh5BRh9LmPtvzOFUo8hbpGuLg1T3fvlAS+EMi7wK24ffG/Z7BLpwjXFuxAfhCZfGyVCVE0JKD+vBWG9gRy542wsdR9QEf74ESbEgycZjtE7JyuBhWsJnylUsQcrft3CEA2k5urSaifDFcaTqk+9YIzVIu9j0PxBSJ3dKHxo8ez8HNzjsSuACXQWf64e/ytw5cB8GhQGBFPUDvcgcmKQqcMSu7i8uppuG7Ume0IiuBogGq0T5+tFkyXjQW4
 jlFgtbXU
 GMfZIJGCF585iQCFq8bGdz1T+J8h16Yd1kAbGBRCvKM2mj0bxDJcZmgT187usM5qQGvQAAEFpB7Mf57i7+xdDS6PC/juFNDJyL71irCIEtr0tCtE0lcWhSPxjijvyrzO0zFFywZZV/uQcFy9q7G3L0LCaMd96OQhDWhwnevmLqCi/uXNj9GwT/YXWc7oahO565LUdIIVnrMOnCPjFZaBEFGgdAZfP6A55QUEsg0CUxbmsFpH3Jtn7q2q789+ZvObCf5t5UqftzKH5lIrFxkz2IqOrl9/wjJJ4oMH3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 11:54=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Tue, Sep 09, 2025 at 11:40:18AM -0400, Pasha Tatashin wrote:
> > In reality, this is not something that is high priority for cloud
> > providers, because these kinds of incompatibilities would be found
> > during qualification; the kernel will fail to update by detecting a
> > version mismatch during boot instead of during shutdown.
>
> Given I expect CSPs will have to add-in specific version support for
> their own special version-pair needs, I think it would be helpful in
> the long run to have a tool that reported what versions a kernel build
> wrote and parsed. Test-to-learn the same information sounds a bit too
> difficult.

Yes, I agree. My point was only about the near term: it's just not a
priority at the moment. This won't block us in the future, as we can
always add a tooling later to inject the required ELF segments for
pre-live update checks.

Pasha

