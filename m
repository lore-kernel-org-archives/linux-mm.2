Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC973CEACD2
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 22:00:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 314018E0015; Fri, 14 Nov 2025 17:00:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EB398E0005; Fri, 14 Nov 2025 17:00:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 228C78E0015; Fri, 14 Nov 2025 17:00:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0FAD38E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:00:56 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 971E61404AF
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 22:00:55 +0000 (UTC)
X-FDA: 84110583270.30.247BCA1
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id 893F318002E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 22:00:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dxMuhRY7;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763157653; a=rsa-sha256;
	cv=none;
	b=6WonwNA1Hah8vDEY6AAj6AOkz9ege1P1V2QHqlBRuseVGvIQnrK17UHx9s5kLic+Td1KEL
	g4yWl71PRJHNw7F3Nb7wlj3QuqwxgkiolTEmJ2bcswopEFLrejLNaSsbxzcwzVCT1vf4kq
	NQuTpzOQFONc1G1AM02XK03FkL6eRAM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dxMuhRY7;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763157653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RSAAbiorXY4ttM/eBzB2Fv1MKUrzCTOCI4JcJxN8/S4=;
	b=265yGOOA6OC70mqRsSuRUqX1RMbkv5dIPD6a8dveDUGWjlOZycHHwG80zjDXO9gOLzSgYN
	i4l1qCFAnGim0F3EkR3AmVidvKatPgxcPS2mfgmzB2Qxhif1yJ5lV3AWH3KW34csszKjM8
	gouBJVR+65fAPbgBYf6UxS+crdolsd8=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-641977dc00fso3644842a12.1
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763157652; x=1763762452; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RSAAbiorXY4ttM/eBzB2Fv1MKUrzCTOCI4JcJxN8/S4=;
        b=dxMuhRY7L7UBL4mWNxmpbS5cZR/B1MNwGUyOElXbXd6loyL3gnXCYcx4tnFKFwWevX
         RIpfusyKwWPunLHoZHcrScaI85hl8olISOlU5g3yEENFs/Qc4ar2KSLjt4JWUktIr3VF
         dcKTSxijPamFHcl396VTR1QkfEo+hkPOsH0RsFQVpuzb7abWii51Tr+1LmZGUvmqO1vb
         y/d1RnSdbyZKy60GaAt8EA+0gfTKEiIXDPjzESG6X/N0FUZOMZAWIa5UaRkxv7AuzQ4h
         U/4ZgIWsjQPAXbwRzmUU0SwR0etWL2+So5H2FpkWMIs4ZsF0Nu+eLzccNqp1L/iMQ5rw
         6oIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763157652; x=1763762452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RSAAbiorXY4ttM/eBzB2Fv1MKUrzCTOCI4JcJxN8/S4=;
        b=MCjyadh6B6Weowar+gIMOWYdEbrXXyWcrwuqK1vZGAxkzr4F7vukV8k+fPS1/nwXbL
         hhG6dZ12PhFORuCJJ3iNuGnIpyOiwMKnJUk/bwdE2ZiHLJq5Wp/1LzKntqyC1uJCwq0P
         6nxi6abLL9h1zXj1RVsB8JDhDbDJrshDtQ+xedebXQGkqFKjPUH4FsqYL1gLzQFqgEuU
         bBljALouZpZ+Kx3lHatTS/R6ktCHT9OSERd9xxQ6008SaX8eQM86diyaVCVyZP54r1C4
         pf1gPt6/JiUyTgHlvE+ekgyktY2vRzvb1eqvS21WpMkkLGO+B68C6qsT/KMV0qFDp5XY
         vc5g==
X-Forwarded-Encrypted: i=1; AJvYcCXvwPmNr2JCgFgI8ccZG7cYTkdCzGXJ6wTxIDAtEIhkUDt7sHQp9/ceyKNp6PFSaCh2LPRj1Ofg3w==@kvack.org
X-Gm-Message-State: AOJu0YxOxTc/NebsHrHifUKdrC8x6TgRrUg+xHRsYj3CERNNmDHtUkRA
	TbT/mQmthSN1g8CgEgWoPTowVGuXTbVfzEs+G0Fzw/9tLBpzmEFA0VLuoK57J/G/yy1irbnRtjJ
	zMtw+dE6WAUkDZ7XycxrxU6QI6kjrsBz0VCvzgyCwuw==
X-Gm-Gg: ASbGnctRAXMFRD5MD2qm5B70RuW15JkoqNf7caVPAa1jQpJwryTADGtBC98e5gqmExY
	/bEyEj/ZQq4gt+zoIXrOCSmKPWBIzB7b2c37swU4N2g6oKbXmWEhhJMuhIpRdWVbPhTbomJ5fOr
	n4oA1hnKR2Mvgd1EU922yDNgfD38TG2YKWrSSa3N6IwXGmJwVtNaEMYK/OMzABYmsczKaq3L5Wk
	d7Wqwbo+Jhmm7+PPqPsHiH0d+Ofve97khP+vYRO+yi2IL+54Nsif5TXJmVrE3Q0Htjk
X-Google-Smtp-Source: AGHT+IGJu3cLiD1bDul5opVrNT/vEEbVnNgcHNbr6iiJHiWwp5TRoCGLYvvSbOreoaljGuLLqZc3LldENbMUf+s76Tg=
X-Received: by 2002:a05:6402:42c8:b0:640:abd5:863d with SMTP id
 4fb4d7f45d1cf-64350e869b2mr3989773a12.20.1763157651638; Fri, 14 Nov 2025
 14:00:51 -0800 (PST)
MIME-Version: 1.0
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com> <20251114134434.5375d085a6bdc1671351f243@linux-foundation.org>
In-Reply-To: <20251114134434.5375d085a6bdc1671351f243@linux-foundation.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 17:00:14 -0500
X-Gm-Features: AWmQ_bm6TOtLq5TASBWVywq3CLLjZula_1Qj_NU6fmtM61AOSpKRjii0y7ulay4
Message-ID: <CA+CK2bB2O4Z6iaBMZ8G1paxdH4gywDvVsD6MtxHJW_mtS7hG7Q@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] kho: simplify state machine and enable dynamic updates
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bhe@redhat.com, rppt@kernel.org, jasonmiu@google.com, arnd@arndb.de, 
	coxu@redhat.com, dave@vasilevsky.ca, ebiggers@google.com, graf@amazon.com, 
	kees@kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 893F318002E
X-Stat-Signature: 6d68wfd3d8z8nnn1tt5ejmcd46iexe7a
X-Rspam-User: 
X-HE-Tag: 1763157653-809771
X-HE-Meta: U2FsdGVkX1/hveOM/0Kgul//jTaui3z9GGLFOS/h7xQ/Hd8ezrshCdMRgDvdU1ymf+us3NMnfJna+oFtHl1eRrFqZRN/hZeyp5VahPg6fXL8rf2+z62YxkxR0qDiiksBWbfd0bGokPMN9B4L2UTJ84+G7yWv+Fu5Cem14jdBHbxTIrRmg3tuNl9Nk3vMOU8w4m4sL1DKhg4PvpmsnZYm6caXdPg0pZWoFqOWDfZ7TPIuvsgxThI9Z9dUofDQCSd04T9SSye89lv8c/Usg8N1xEmFk20QFAvvJdzM3+fdzkuRa2hb+F9E6t9DuckhAsD2k3xI7fQI23SvsZR+HStoC8ga+LmoPym2M/487CubadlOYOQWRGuLeXjbFRJVgNP8F3tYx01Y/GWnvBbqhYhxIn2d9FdUxMDQ+ZajeuF/oxsxh1teKK3UQz/z0wCQ6xl2kzOooonT7WUG3EvnTXDmtwWsuj+KcDcABxfkKPbJufAQ3/3bvmYTvSdUOfWnNlV1OCMgwcmQ2wabqU96/7pgC1kNg8TJDf0Hn27A2vYMxzUL5lNjLD24adbp26EQXYK79OlooErDfH/LJHJu2f3wvXI2snYBVtJzcm+erXNuAvdZArf3H/sp1hXawGtg4h9GUvvRXjowAmvNIh1+vMdLIIqnvRO+Ft5oMgE4fZSzGjR1Aube8ZIQSKG4ziY5CFmSdDxTcY6Zfl5kpDUKelDAmT5Hw217ljyo30yDQprsjmhICfllFqRJp268lIxadDTdvIcbtITdHjO3pt0b7AbybpfD9Vfve+GpcoxfPQaQgtMWppP7i1cXOouwynUZj3lEuBigFfAnLwWaCH4WRVRZAAT35cHX0SfyU0DELxm0ZOGiV5uFl60iEDBSIakRFKm3WTAjRt7RqMcwIS3GJPYGtwyOiwwo5I95WvbVC9Lo2+yf7U3PxZ8Ejek5eIsfOx3TjRIiSIghh0ZkLqFPXQE
 H5+T2xqS
 ZoXDum2aC4/UdBuWlmu/e5O18vlydMfa+XvkH9k07ICiRnp1i6YTsIMSfXfiSE4/TuYz0ndAfataMcfV1bQBpkKIEXHKsLG8/OOCgKM8KHDCClqbQyb6Rf2ResEd0rBGhG9Ozf5hFrMe631nAIiZKb4U78QB0iUoqO0QvN8x7eN0arsq+Ml8ytFEc1ZhfUk75MQw5zwvWlhsqyZM0p26hdgpK3en1QV0qaAUK//BjVmeKAmS7lGVi8PCbv6mcSgCermpAO5VvYc1G4b1D32vq25xywOKQZbXF2TKvHkwmd5S2fvPjTF5BSLFBp2nWkHRAzRygyKyJwsGhEnc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 4:44=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 14 Nov 2025 13:59:49 -0500 Pasha Tatashin <pasha.tatashin@soleen.=
com> wrote:
>
> > Andrew: This series applies against mm-nonmm-unstable, but should
> > go right before LUOv5, i.e. on top of:
> > "liveupdate: kho: use %pe format specifier for error pointer printing"
> >
> > Changelog v2:
> > - Addressed comments from Mike and Pratyush
> > - Added Review-bys.
> >
> > It also replaces the following patches, that once applied should be
> > dropped from mm-nonmm-unstable:
> > "liveupdate: kho: when live update add KHO image during kexec load"
> > "liveupdate: Kconfig: make debugfs optional"
> > "kho: enable KHO by default"
> >
> > This patch series refactors the Kexec Handover subsystem to transition
> > from a rigid, state-locked model to a dynamic, re-entrant architecture.
> > It also introduces usability improvements.
>
> OK.
>
> Where are we with the series "Live Update Orchestrator, v5"?

I am working on LUOv6, it is going to be an incremental update with
much smaller delta compared to v4->v5, addressing all the comments
collected so far. I plan to send it out this weekend.

Thank you,
Pasha

> I'm seeing a couple of review comments which I plan to circle back on:
>
> https://lkml.kernel.org/r/aROZi043lxtegqWE@kernel.org
> https://lkml.kernel.org/r/mafs0ms4tajcs.fsf@kernel.org
> and a comment from yourself against
> liveupdate-luo_core-integrate-with-kho.patch which indicates that you
> plan to update that patch?

