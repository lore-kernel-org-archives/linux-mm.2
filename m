Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59BD6C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 21:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5A06B0088; Wed,  8 Jul 2026 17:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1764A6B008A; Wed,  8 Jul 2026 17:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064996B008C; Wed,  8 Jul 2026 17:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6DC76B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:18:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D0B81C143F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 21:18:26 +0000 (UTC)
X-FDA: 84966873012.17.44988BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4F305A0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 21:18:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ij1oKLvn;
	spf=pass (imf25.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783545504;
	b=BM0imR/uFEBhhj35q+UQOJ3tNu24NBQiVraFvWY/WM3PQlZ9H8www6WuDfQxK4Q0liObrQ
	HPq4/JbMUwxjRzjwfcnV2hFYkdfnWoch6nAGahg8Um4IWq0mGnB+xN2uVPejz5l9N1gMcq
	maGE1/VxxbcNifA82viBiyoj9OhG3/M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ij1oKLvn;
	spf=pass (imf25.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783545504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XHlK26iT5OTlGmvdsQr6aTlcJ71q9tfgFUQl/PoXZWA=;
	b=WIAw71P4EpEukb8CbMxeJKJ8lq4MkN8h4ERDjVZiXd1W7zDjuCCBoGDGfkoc3kRoiUNN0j
	tln1kDg2SZdaM/iW2SJKaw8neKxLD1HoiDb0rKxHXVpyhyaLLywbMSvD4hl8QlInGQ3rL1
	7fNO1wMfc/wdji6c0b2g8SKDmlGejZ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3018143BCF
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 21:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174B71F0155C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 21:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783545503;
	bh=XHlK26iT5OTlGmvdsQr6aTlcJ71q9tfgFUQl/PoXZWA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ij1oKLvneDuoMo7g4aa7tnzEGSduqP/POFTYHBdxBZ815qZpk9LFbDgsAo0yCt8IU
	 7IVs6w+zLmWUyetjrgBlg1w5iqaPlbRALMaZO8JW7hqU/1gvwTbxJwp4KOcWeGc63v
	 75V4WotUCt8Dobg79gGG87lQ7nK03BdYhKAKjhYHR6XGEIrP/JoGdtP22AbbDvdmY9
	 B/6r+YzOxZx43W7v+wiSMS40iikcKhYr6dIVP5FmzwUS2uq8+P91iQ4y6rs3YT1Lct
	 RdWSXHuhozPhfIOsKn2saEE2M5xJTpuQM3JnOsppmQRmSqllqe3+hlGwET7HA3MA1T
	 EVcF2gcOddPww==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-691c5776f35so1851632a12.3
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 14:18:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqCh5WoakfbBZ+CM/WBZGdbT6/nEwCH93awN3aIm8fvhzzAsaLnnC10igAiaGkYVND0TGsipMr6/w==@kvack.org
X-Gm-Message-State: AOJu0YyaNguuuQQvHg0iGaZI0pkzzF9k+yDnJYtnmFV0h1uzhNtzwIHC
	831VXD007Tc1PH6urb+S7sU9BMmxkWm31S38Wr0kEGDeQ0W2h/ty/PIQKU3CR6TDBXtnODtZ7EP
	3N7zQvwbNu8b1ECO1wQxjyV+fxFT71Q==
X-Received: by 2002:a17:907:a286:b0:c15:b6bd:cbb8 with SMTP id
 a640c23a62f3a-c15ce121a12mr190425566b.50.1783545501322; Wed, 08 Jul 2026
 14:18:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-1-d80f7b871bb4@nvidia.com> <178293558945.1610040.13281502080616690110.robh@kernel.org>
 <akZde-8lFvf8rPji@orome>
In-Reply-To: <akZde-8lFvf8rPji@orome>
From: Rob Herring <robh@kernel.org>
Date: Wed, 8 Jul 2026 16:18:10 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJCMm-oL35COx=agY+mwRUMMnRvbUgzPr5Hy9uvcPk0Dg@mail.gmail.com>
X-Gm-Features: AUfX_mz5rhGcrunDpACqiF1Zhx-HBPPyHD0sxMJJ0YCYlPmg5dj7i6HAGao9icM
Message-ID: <CAL_JsqJCMm-oL35COx=agY+mwRUMMnRvbUgzPr5Hy9uvcPk0Dg@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] dt-bindings: reserved-memory: Document Tegra VPR
To: Thierry Reding <thierry.reding@kernel.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	dri-devel@lists.freedesktop.org, David Hildenbrand <david@kernel.org>, 
	Yury Norov <yury.norov@gmail.com>, linux-media@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, 
	Simona Vetter <simona@ffwll.ch>, linux-trace-kernel@vger.kernel.org, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	linux-mm@kvack.org, Russell King <linux@armlinux.org.uk>, Will Deacon <will@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, David Airlie <airlied@gmail.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	linaro-mm-sig@lists.linaro.org, Heiko Carstens <hca@linux.ibm.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Thierry Reding <treding@nvidia.com>, 
	Maxime Ripard <mripard@kernel.org>, Thierry Reding <thierry.reding@gmail.com>, 
	John Stultz <jstultz@google.com>, Luca Ceresoli <luca.ceresoli@bootlin.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Brian Starkey <Brian.Starkey@arm.com>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Michal Hocko <mhocko@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Sowjanya Komatineni <skomatineni@nvidia.com>, Suren Baghdasaryan <surenb@google.com>, 
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
	devicetree@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>, 
	linux-tegra@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Conor Dooley <conor+dt@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "T.J. Mercier" <tjmercier@google.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, iommu@lists.linux.dev, 
	Mike Rapoport <rppt@kernel.org>, Sven Schnelle <svens@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F305A0005
X-Stat-Signature: hgpb8xwib359wbsx3kmqe1kncus1n38m
X-HE-Tag: 1783545504-243844
X-HE-Meta: U2FsdGVkX1+LVcSD2K0bGcMIIhngv8jOSbZ5q8wbEs+K8Oq0MENPQYsSA/jaZ9/mggT6h4+TTU9/HHieeaebk2QjfQHncLcZvRQIHsX7D2T6GHNjWhjFearexnkggNiXKYYPrn99nI8zDFf96yW6mYrY4mVOSUTrtbxv6ao9U47nhWhpT484wnbwzb9jLsG4H1Zm6cT5AvoBIZLKLE8e2Jy+EbyonQzmJLo3iU4nmbnIeXco6rhFGBbh7dub3wuew//TU+SyRJ+XASfdiAmEuashvvRK3cU9baoL1/gM6ZqXE1Gt/pFm5PqfuG7i1XY3cM1cig1z0FbgQtyBCA2qWa4sJni4a9jvC+jQsHYF8QPZkOC98AHMeNoTDMVQo7aQC1B6ePCGRfRyqg3Tu7R3C89Ok3bzzehQvZxq+B1zwYoV4W3rQwngxPpBm+FeSoM6qcHpCh152jttHjj8QfH9VoBAkRWi9dBvfjr/5MPm0YakWqRSc0UmQvsCXzaZuHaHHn8bYYlefq3EKrZZn5O00kdfgmy1lOqIhoCTRuFnYIEK87BYBaivFxv+AjCDGVxLCyNgG2tEjWjBkx9F2jEbkoq8eSd8Wm29T7qDxbRNUiYvubHY4IxM+BvEhgZNIMxGGDbYvv9YyZ3oF2w4VFKIqzv8/B6zEUHo+PBTBIqrU8w9vwGYoxN1ks0jH5YYJeXZ4oLmBx2PqmrIZJUfYkh+D6V+EVawrJlIShDlg83NNa7TVtkGHUkJ6dZSd+k7pCiktS20RfZpeqnmQSPJN5W1/0r5PTMM0sojlhJ4I22riWWJyj4a+wolCayawpFCPNHIkMvvzcS6ew5I+ZWeZjKDaTrHLgBs/Jx8DYfxCN4WO2y9LwlpUF47OIn91XCvKnRmJgNDq9YrPsY6wM5qvQMCrDZp9lkGz1YShVqE4K338C9cq3ms2ZngOepHMZ9dq3AUVx4mTOlW9bLRr7Vd3NC
 rKTj6RXn
 GoqxV6nvoeKmQ38WnNVf0VyxxU1jNhI2QUIP3o79O7ErTYRGgPrIkFjA020cfLmkdX9PETbrOzMgNCWD0RienMiTb3TICLr5LCrrEPHRAcl3jbFFwvNsj5fSgqVV+MhX1OT3nx1zgVqTnx4eAc7orwsD6B5XcFS59Vr/t3KxUHWKNgAhtCnENcre0unbYfR0qtdjwdogSUjrREaMTXI/1FOMM2LWuzK9n/qJIMTWSPJVsqck5bgV5khISTKTs/WQA9NJoj3N4D6shQF6bTiuuk7exmRxBN3C7LRM4ZT+H0E/uGY+zm+Pj5XDxau9oiNMqNRjU9ytkD9Dq37CFucWBJU1jp2yNpnNcIBWGiNIT8Eu8VivKrwfB47VRZG/7FB6/o5DyH8SvjwpBj5Rzoh3tM4PgOuoKQazdiH1KLZkLA8K/7dwoxTmymSAxQyd4Tt4o21x/dlDxPOxbKpFe7YXsVkAHvM/FeMwIsl1SShtxXTPXpFpZXiys6DAT6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 2, 2026 at 7:58=E2=80=AFAM Thierry Reding <thierry.reding@kerne=
l.org> wrote:
>
> On Wed, Jul 01, 2026 at 02:53:10PM -0500, Rob Herring (Arm) wrote:
> >
> > On Wed, 01 Jul 2026 18:08:12 +0200, Thierry Reding wrote:
> > > From: Thierry Reding <treding@nvidia.com>
> > >
> > > The Video Protection Region (VPR) found on NVIDIA Tegra chips is a
> > > region of memory that is protected from CPU accesses. It is used to
> > > decode and play back DRM protected content.
> > >
> > > It is a standard reserved memory region that can exist in two forms:
> > > static VPR where the base address and size are fixed (uses the "reg"
> > > property to describe the memory) and a resizable VPR where only the
> > > size is known upfront and the OS can allocate it wherever it can be
> > > accomodated.
> > >
> > > Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > ---
> > > Changes in v2:
> > > - add examples for fixed and resizable VPR
> > > ---
> > >  .../nvidia,tegra-video-protection-region.yaml      | 76 ++++++++++++=
++++++++++
> > >  1 file changed, 76 insertions(+)
> > >
> >
> > My bot found errors running 'make dt_binding_check' on your patch:
> >
> > yamllint warnings/errors:
> >
> > dtschema/dtc warnings/errors:
> > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings=
/reserved-memory/nvidia,tegra-video-protection-region.example.dtb: protecte=
d@2a8000000 (nvidia,tegra-video-protection-region): reg: [[2, 2818572288], =
[0, 1879048192]] is too long
> >       from schema $id: http://devicetree.org/schemas/reserved-memory/nv=
idia,tegra-video-protection-region.yaml
> > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings=
/reserved-memory/nvidia,tegra-video-protection-region.example.dtb: protecte=
d@2a8000000 (nvidia,tegra-video-protection-region): Unevaluated properties =
are not allowed ('no-map', 'reg' were unexpected)
> >       from schema $id: http://devicetree.org/schemas/reserved-memory/nv=
idia,tegra-video-protection-region.yaml
>
> Any ideas why that second error shows up? It turns out that it goes away
> when the first one is fixed (which admittedly is a stupid mistake), but
> I spent quite a bit of time looking for a fix before realizing that it's
> only a side-effect of the first.

If a property fails validation in a referenced schema, then everything
in that referenced schema is considered not evaluated. So then
unevaluatedProperties is applied to the properties only in the
referenced schema. That's why 'no-map' is also unevaluated. Just a
quirk of how json-schema works...

Rob

