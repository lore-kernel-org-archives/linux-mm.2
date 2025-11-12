Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13CA2CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 12:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11F8F8E0005; Wed, 12 Nov 2025 07:47:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7508E0003; Wed, 12 Nov 2025 07:47:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00CE68E0005; Wed, 12 Nov 2025 07:47:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E16708E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:47:04 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 975D3B9662
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 12:47:04 +0000 (UTC)
X-FDA: 84101929968.26.F2C3FEF
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id 96FC2140007
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 12:47:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LO4NBWFL;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762951622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NlYd6Xq+AnhKekfFM+8+8cT83BwyMkqy6p8G3DXg5+E=;
	b=PPcmR+mABerC66adZZgXe2najoMocK75uTBf4OF42VIc206isCvbrtCtCjhEV0BDOUV8LO
	ztOWOZoXXG5hm9v+bj3e0YU+arKUoEY7paGEdPca4x1V0xmZoPiLiNsJ9l9v5uPmGKYAC7
	OxOUc0V5HWG3o80HdcF5duaMXsUMyKo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LO4NBWFL;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762951622; a=rsa-sha256;
	cv=none;
	b=iRqyOeAQZErhd6g/ql70TYV6x/UCk93CkgYhlRW9v8iXuAVRw1JkdNfP+xZdGvWh/wsx8r
	KroXLabEKaybTZzWTykgI7YjSLMOQqm9vI+tlPvz7OqpSQFf17djdajjekKEBJJ/RXPrj1
	6WaMo2mWIf12Bxju6LZxU1zghwltpqo=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64088c6b309so1235684a12.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762951621; x=1763556421; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NlYd6Xq+AnhKekfFM+8+8cT83BwyMkqy6p8G3DXg5+E=;
        b=LO4NBWFLEta76oq9Z57MxTdUT6Y32vFq4G97K6d/SDcawl2Su+RvO3SOj6PmP5Yv37
         HwmE3Mmqrmyp0zDaawSehJsLlDp71+6K31805nPmzhqF9Svns8JCQFx0jQ696y+5sJ7w
         oAmIUZXsgI9r98c4lt9J9Tuwjah5Ri00W9uuoQjDQN6qC0gthCSNNHI8YBJqsP7b9fro
         u3RyiD8lyjPM13PQWNzl9mV3+DkKDuSVp2/dLcws0u7b6QXbs9kA10OgF9Fl7w+72HFp
         7n8T4GIdi6x7qum6MljmpQmhQdLlWsS9E+52op3vQRrtLoiZ6151EaYkUfY0ORPeq/WP
         kWiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762951621; x=1763556421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NlYd6Xq+AnhKekfFM+8+8cT83BwyMkqy6p8G3DXg5+E=;
        b=MGmfNG3OVRVGNicO3UN0r0fmFeorVr0IaHKV9xHaviKEmRTdqXUtUBceukvEnV0Zq1
         5e1pvvfPxmb3k209RpwlytO88Ez58Cj4YbdI0jdETltS5SOjJ7jMSdAMeftpYtKBen/a
         Yf7W9b7a0Li9BZwoY3Zv4eI6q6eWKKQdH24heYC6UxfEhOnvqA1qDqztb5A2/CUidu1I
         NyO47/trvh6Jx7s2XZEF9PoIRh5vdzEB5L2gCdlRKUHtujWpGs/Kij8MC2a0nuOMFAHZ
         /3WyyJE8Yygl4DPQEKEtrbgbRdfe9htO3Qj30PgsoucJ1MfKoPHRsbMrUo7f9OIZMk3G
         36pQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5d806v4I1MZ5AlBSFqEvq5Q7H2VrmFtcPqYWom9v8P3N8i0Q2DPPvcwB3DAuYVYmjZ+5t9hV8tA==@kvack.org
X-Gm-Message-State: AOJu0YxotidUOnGulK6PurTHUJGvtUt2sn4Q0mGBJ6vf4eVjPsdW1wzl
	5tx5Mv5nK6mDrS2HkEPhalj8ZBLpmRA07M6ZWYbLG348TU3MKPh6eXiwFlMplusXcZ43AhUSGuZ
	7z0UqQXWc46IJLuvbVk9BNDuneyVJ81X8+NZ8cqdFiA==
X-Gm-Gg: ASbGncsSMGMJasugJfRTq+Bhm2RuUatKFxoDrWWiExocOB76+BurVvy/06FHH4zs60/
	OS5cJ6JVXZdkp6jVazphyn6leeXHEiy3OwCdeeCW5fK/EH1Yluj6y19wpxpQ/2yr/6Zn3zgk+iY
	5nz9K4jVyjXbG6zsWUY1DgTq3HDuDBnLb+3W29H263Nfl109VgpWLFA1pcNYupnOir95cWb+fWt
	pW2OCV1o54y93+GQ2dNa6CBZAILJPpwvo5Sd79N5828VG+e5pEjjTzt3A==
X-Google-Smtp-Source: AGHT+IHPQjz/pJ437pH7YFtSiDGAQ3VcFvPXvPvzuQHBM0+kWPerbB0r4L6RkLw74giNqTUgcHTcvt5mHbrdxH4Haek=
X-Received: by 2002:a05:6402:5186:b0:640:9c99:bfac with SMTP id
 4fb4d7f45d1cf-6431a4d609bmr2586786a12.13.1762951620623; Wed, 12 Nov 2025
 04:47:00 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-3-pasha.tatashin@soleen.com> <aRObz4bQzRHH5hJb@kernel.org>
 <CA+CK2bDnaLJS9GdO_7Anhwah2uQrYYk_RhQMSiRL-YB=8ZZZWQ@mail.gmail.com>
 <CA+CK2bD3hps+atqUZ2LKyuoOSRRUWpTPE+frd5g13js4EAFK8g@mail.gmail.com> <aRRflLTejNQXWa1Z@kernel.org>
In-Reply-To: <aRRflLTejNQXWa1Z@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 12 Nov 2025 07:46:23 -0500
X-Gm-Features: AWmQ_bl87XR7836bCxIna383p3224VYBM84reJOLcIDxOxFdtSf2hXG1yTbnSeY
Message-ID: <CA+CK2bB8731z-EKv2K8-x5SH8rjOTTuWkfkrc4Qj6skW+Kr7-g@mail.gmail.com>
Subject: Re: [PATCH v5 02/22] liveupdate: luo_core: integrate with KHO
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
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 96FC2140007
X-Stat-Signature: kc8j4eydnfwby3hg79aqfai9f1ohmbpp
X-Rspam-User: 
X-HE-Tag: 1762951622-576205
X-HE-Meta: U2FsdGVkX1/Mt9bwt5vo17rBsB6TQpvKD6579jr/admnfMDV6+z9IM9j4HzAtBrufEZMM4ACR+NhOpBKEzOdd6aIZHHYJ7BWkYTvXsXPaZEIGJnNjEHTuUfcibd7CrWObKTCqFFAGtvYpamRefzlwaSbouUmK8x/BMFUPuoPsBvZMEfoX+kCULDE63gAYC2YAR/1RaGEqRyVSI6AQQ19y46HLln7F7lxnbZHABxwt0RvRL25aS1x9HM0O9h4kYssiFndqW4C7QE3v5DZDhUfbejpXbZXUj9MaCsHqzB0Nf5+SrKwzohojm99oK+tcTflovmi5BOkfHeJIounmC+QjZ4Jw6KvF/62wKlee30uZ4dc9P/L19XuVvowfG9jXRprtPVBe85ljta/ili+p5NVTkPmbIyyrerllubLitGF+Y4tgx36jv+zYkeLm/COlBHT7HZPFEt5PQ9p5qlsGj7/cFJubp8GMCddPrFbYzBp4kL9nLpIH9z39by9ZgcQ7KUNmVgdO4Fr50VOi3URwY1pzsOyZOUVEC1I8ZoTe6hy4qAyr/CmK9k6aRiiCj4ERW7yJjTfP5ehVm8a+dPgOKOOerK/X8qnfAPo5XIGyu1hKVwiLO/zX3b0Y9M3VBbxlDqir9JCWNX9Bd06SAtysZXPkgSJ6G4alS+ONVCv0FC4aH7Q+ps9kVoLMRUvM9C7+r3tHuye0WfbIWVgMIeNBLWo09X8aDaP87hu0Fc2JbkTxwrqFTvE+1eKv4L8kK51vErSjYuSGXXO0KMBXiOagsY9e3vAjCDJIYy5pTLSY78mH6NrUblNAfxi7UM6Hhfr6uvR2wNSMWmaxPEiIe/xhq992DCjXnKzLXj+olvGJkftRNy6vAgmzEIC1wf20rqV48qp0dyhB17Wumvw0DF9QRh6XkAU/6xmReex6ixXViOzGnVclJh62nlbj6vbuSuSvEu28RvDLN1BghivJF3vIRi
 tbfIT6DB
 xyxEzmCUN8BtHIS2FbTfJkvIkqNQ9MJyHB/3kZi6B+gxdO3Xu/w/pXKAVlmkLEq+N3Jtw8999Bjo8MYl5KQwk7aeBxhPf0aZwIeI4yKn7pHwuGNQtqulPAa/UVOCGi9fdTvTZ/dqsUwScEoz1NTuutq+mt/PQvkVCyOYExYDgaiGadFfFvhpsu19x6OSSqxwnbwAjRxfXld/kGz8efWD1fB8KWrGdzmQzmJMbZwBc90Rx+MiZj5y5aWEfDhw9jX6GmLXq1TFSgNa6clDXUqbTn62y8v8T4ybMHhpNsApSchZHjNNSjeOZpZtd+KTO4SsfwurXrgS49Tx9TaSAdUTZPt1YQKKQQU1nbjnM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 5:21=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Tue, Nov 11, 2025 at 03:42:24PM -0500, Pasha Tatashin wrote:
> > On Tue, Nov 11, 2025 at 3:39=E2=80=AFPM Pasha Tatashin
> > <pasha.tatashin@soleen.com> wrote:
> > >
> > > > >       kho_memory_init();
> > > > >
> > > > > +     /* Live Update should follow right after KHO is initialized=
 */
> > > > > +     liveupdate_init();
> > > > > +
> > > >
> > > > Why do you think it should be immediately after kho_memory_init()?
> > > > Any reason this can't be called from start_kernel() or even later a=
s an
> > > > early_initcall() or core_initall()?
> > >
> > > Unfortunately, no, even here it is too late, and we might need to fin=
d
> > > a way to move the kho_init/liveupdate_init earlier. We must be able t=
o
> > > preserve HugeTLB pages, and those are reserved earlier in boot.
> >
> > Just to clarify: liveupdate_init() is needed to start using:
> > liveupdate_flb_incoming_* API, and FLB data is needed during HugeTLB
> > reservation.
>
> Since flb is "file-lifecycle-bound", it implies *file*. Early memory
> reservations in hugetlb are not bound to files, they end up in file objec=
ts
> way later.

FLB global objects act similarly to subsystem-wide data, except their
data has a clear creation and destruction time tied to preserved
files. When the first file of a particular type is added to LUO, this
global data is created; when the last file of that type is removed
(unpreserved or finished), this global data is destroyed, this is why
its life is bound to file lifecycle. Crucially, this global data is
accessible at any time while LUO owns the associated files spanning
the early boot update boundary.

> So I think for now we can move liveupdate_init() later in boot and we wil=
l
> solve the problem of hugetlb reservations when we add support for hugetlb=
.

HugeTLB reserves memory early in boot. If we already have preserved
HugeTLB pages via LUO/KHO, we must ensure they are counted against the
boot-time reservation. For example, if hugetlb_cma_reserve() needs to
reserve ten 1G pages, but LUO has already preserved seven, we only
need to reserve three new pages and the rest are going to be restored
with the files.

Since this count is contained in the FLB global object, that data
needs to be available during the early reservation phase. (Pratyush is
working on HugeTLB preservation and can explain further).

Pasha

