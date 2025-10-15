Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1AAFCCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 14:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E34EA8E000A; Wed, 15 Oct 2025 10:36:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C4F8E0005; Wed, 15 Oct 2025 10:36:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D48EA8E000A; Wed, 15 Oct 2025 10:36:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3E0C8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:36:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72D391601CB
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:36:50 +0000 (UTC)
X-FDA: 84000600180.01.7FB610C
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8E66410001C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:36:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1IuFxIda;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of glider@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760539008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ifYwjtgGq5keUbDlKteK0EeKaKXUIahDxueNXQTSmx0=;
	b=8DAUma+V1Pxa5/jEofq2SzQmpSY45Ck5Pyulz42ZOYFt5sl1XrEzdnPiQAvgnoGlXxij01
	SnVajcOuDrNvIew2tb2V6b0iinE3/nsw0pZG19q9crrR2cSGtUSumGrX1/AKst8NKNbgfu
	A2rI9udbeF7wcEty95QD0DL77Cx5Qrw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760539008; a=rsa-sha256;
	cv=none;
	b=QR3e/MVH9VSqrkvz8J488eEdIsAbiMJ702BoH6YNPrC1J7D8mR0H8dwYaswaTfZUJBbq32
	k0yWxIp3SHWED6kW+xAFIqks3vghCN6BjbXboKD1mBBQwepKgD7iaJzrjOXMP9qnenBXQY
	Ykp0WiXPo/eWX9wb9VzwynOq5nS0SHE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1IuFxIda;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of glider@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=glider@google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2909448641eso290335ad.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760539007; x=1761143807; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ifYwjtgGq5keUbDlKteK0EeKaKXUIahDxueNXQTSmx0=;
        b=1IuFxIda2X+nse3VJ+DKWTl2LlFnUZCUkzVNSJ6KpghBX0Rs1xKJhsF+hUu+BIbx6A
         w7zTPMkJbMBEtCkg52aAEjVEaytXTf3pgHt1Du8dv/aacqIHHhHpvTK8YbaR/OpwVMwm
         GDjy4X6rxIx1GYz221Tn8OTmDK1bqgSK9q7r2bkCOmaExJb2tZycTIMCkb3iiBBwgBtv
         irYam6ban103WzgIgUwsSSp4hg3Jl8yAUnx42gUAZSy1VFfdPutX3jEu1WHdPod+CKB3
         D1vaG5YjI2qTGCMRWtYcQLAlK6vRt0QdEhXoMcahZZBXtxMq2rQVOuDzoMqug/3jHsa5
         GJLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760539007; x=1761143807;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ifYwjtgGq5keUbDlKteK0EeKaKXUIahDxueNXQTSmx0=;
        b=l65e3H5pEY2ilElKGZiLb2r+CXwu1sQFDv520WDXdOE3Bo0l4bHgG4Wzes+DbUp4Dn
         8LP/feyXeKvM4WIqJsP9dHDFffaKpWwkLgOIxcVM7ygjesyTCFb+4EQQKxgVkggEHXHn
         4hH86lonw8Czc+MBwraqZyq0uiwNLqUOH6/9Ao846r+azdeAN+q3wBqX60IWGJpFKuyR
         arnWyJkjXLmYja73I81//vGNH7XeGMl2sN2M0C1LVWPnblC/pVbEdhFNdZhOpcSx2pe4
         5K14G3k/TlLRskoydDynUx59L4rotW3hv8dk8Ou/XMyaPUa3lgoP2izfjCdl0FyGxRok
         GFpA==
X-Forwarded-Encrypted: i=1; AJvYcCUiw+Q8HMrXLTiv289opncaIN4VFl42Cv0vgJVwzcywroGYiPzCRKSwXUsXAPPxgEoc7yA6LdUkIA==@kvack.org
X-Gm-Message-State: AOJu0Yw6i6mm9q/wI6rsverbDejT7pbdZHiRpM46wOVXiRenHfkctDUu
	dc8fWgNH1mPX05Ca3CrIq9JaO7ZIZZHFoLEMKp64Wfl/SJv0j73M3dHcPeK8CyNjWkwcIKUZgRx
	rQODRVO8D97pg/9JPZqAxQKZWm0lHCnOz+gAiwFkp
X-Gm-Gg: ASbGncv4sz/4KkJAPU5Two0Iha9vP2DW5iqnpVaf2MMZojYnl8jHkqa0QzgQ+hJoFJQ
	JROJF8SiUKJ9BJw1Sfu6Y9QceuCo5mIr4ew8KprVso87LKWelE0TosC/lF9wLd+Z6vP382K40cy
	cKoy8DAEvzden+nUwdy5Im6zOJ9DzjD2dE45xj0hhtuYMIEAI7qLQX2QDIqkbP13bd71XaGNEAj
	YVtLWqquIfevpCWzxuaRtHJuleJFkyxuSHvYwmmN80KKAcbsfBc3lDlW4gt9QpfUtUeWlfvCg==
X-Google-Smtp-Source: AGHT+IEgJ4Xh7QA5HE+tPAkou2gC/3g0NAsVR8ZhLLf0dUw631bkhU9G1C2LnuWl+YoLKezB9R+Fgv0xDlsaqCPV16w=
X-Received: by 2002:a17:902:ce92:b0:26b:3cb5:a906 with SMTP id
 d9443c01a7336-29091b58552mr3833485ad.16.1760539006951; Wed, 15 Oct 2025
 07:36:46 -0700 (PDT)
MIME-Version: 1.0
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
 <20251015053121.3978358-3-pasha.tatashin@soleen.com> <mafs0v7kgjoxq.fsf@kernel.org>
 <CA+CK2bCG011xf7v9nGMq4WQAUta9wDt05+W8KmRuc-JE7ZTwqg@mail.gmail.com>
In-Reply-To: <CA+CK2bCG011xf7v9nGMq4WQAUta9wDt05+W8KmRuc-JE7ZTwqg@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 15 Oct 2025 16:36:08 +0200
X-Gm-Features: AS18NWAisQiMzt2QRK50IWgyiwg1QpdPMU2VVQzYd71ezZ8bUqs0a3UMQudZMqg
Message-ID: <CAG_fn=UNOLezyetfBYd3ztWDHmGwht-01yf1_p+O-JXcPu57TA@mail.gmail.com>
Subject: Re: [PATCH 2/2] liveupdate: kho: allocate metadata directly from the
 buddy allocator
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, akpm@linux-foundation.org, brauner@kernel.org, 
	corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com, 
	elver@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E66410001C
X-Rspamd-Server: rspam02
X-Stat-Signature: o49qy558cq1aroadttoqerpq3r3i8s6b
X-HE-Tag: 1760539008-969618
X-HE-Meta: U2FsdGVkX19xlNJVAIhzxKl8qTX/YuFoksSSwuAyR2EuHPWaid21/cYrZTesg1uwxnx3DerBno7tBy1tk2Ea0DpHlLclC0egN1tSpRTdyjuVZKrH7IKC839VnKkUPqBp7GcAAhaSebpWjPv+xWu2+NP9p7Ss1MJLLu1GH0tUgZlu87sl1lq5WQNUXcZfY3q1aSBo5GiS13R2B81pk1oMaJOA7QZ6TCFATJ+Y9uYUoNn5r482gXLK1iYtJyFW8Fy0eIiOOlXU1qBpbNEJWPTTlyI6y/dyLRxQDcgxusIxbf3wpmh1VwB8xhdW8zBD+vfW5lytWY4QRn+mlz8LpkDRzbmztxJJ63UuD3ih5g3pvkLBZdI7IAvHe8kZJBE3tVLn7zVSdlsoLWjfhf+W9oTKKtGlZf95xwdxPqYuiwZfiTmKBt1faTL7jUcVbadd4UsIMo4Svuk/jo0H/NkVYOuI1cdcS7xMytkh/wh+rdcgnwpe10/Yv75x9BQZSZV5l4EvGQLf6vFbwZhMNvbqZ6tynAHEUTAegu+rSor4o2F3boaFrHNk2FpG2xIzvHtG2dpYj2GrRq0JhB7sbYhnqB2cZpYuvzkFPyY9Jt6EAQC7gIlAjDMo9HewQF2lSoDtiakua7yHomtXRfVQw7kCzcH73jSEityBW8bD5hT/cuSAXAZPLJ22bhH8ga4METYcq2adWk5zqVndLL9yOMNKHVx5hGu7SSX7gTAU784dCqXqa3HnQuaK7n4d8vDobA/+rGtgm+wwUJxPRGwmDO/iGr/XCbS61R+BGhQ1lfrwHIBs0FlyDXoM9x+r/p80vzTz3Uu8gZoxT45EtGPr0j41L04nHHKZjAecOEYhN4YmAPejI2r5/U0jBys/9wNjo6O7ebh2+LXtOvSrmmYo7GUXqfHq6d4aK5JeUNA1yoEupK+v6ORQ4SEN4MVk+MZea5FO5B5RX/gjhHsfun4YbC1pIIs
 VXMPYxjo
 GRKJEIkxGoTp8sIKRUxAqB+K/HUe9ULb1/ARCSBhzL6nhJh+VkfVPjgtjkYf+nN8BS0ipAq2siUuereV1Vzmu+7RmGW7Fu8uvo44HptKyAtiiL5CzK76xInZnNDTHP17Vr+tnvzLyDArFXIHw/0dgF0AawrbZwagRqaTbsX8HMrqwOsnilHjMEYOTPtgblgmcXYMELBTYtmqi7CBZUedAMBsxBar/lRqcV9izAyu1Tz4HIyLMPBMX+7YO9gDN2i+tWgtPzE4FnsB0HXll42FqvJeEsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 4:19=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Wed, Oct 15, 2025 at 9:05=E2=80=AFAM Pratyush Yadav <pratyush@kernel.o=
rg> wrote:
> >
> > +Cc Marco, Alexander
> >
> > On Wed, Oct 15 2025, Pasha Tatashin wrote:
> >
> > > KHO allocates metadata for its preserved memory map using the SLUB
> > > allocator via kzalloc(). This metadata is temporary and is used by th=
e
> > > next kernel during early boot to find preserved memory.
> > >
> > > A problem arises when KFENCE is enabled. kzalloc() calls can be
> > > randomly intercepted by kfence_alloc(), which services the allocation
> > > from a dedicated KFENCE memory pool. This pool is allocated early in
> > > boot via memblock.
> >
> > At some point, we'd probably want to add support for preserving slab
> > objects using KHO. That wouldn't work if the objects can land in scratc=
h
> > memory. Right now, the kfence pools are allocated right before KHO goes
> > out of scratch-only and memblock frees pages to buddy.
>
> If we do that, most likely we will add a GFP flag that goes with it,
> so the slab can use a special pool of pages that are preservable.
> Otherwise, we are going to be leaking memory from the old kernel in
> the unpreserved parts of the pages. If we do that, kfence can ignore
> allocations with that new preservable GFP flag.

I think this is the best way forward.
Changing KFENCE to allocate the pool from buddy will make the
allocation size less flexible (goodbye, CONFIG_KFENCE_NUM_OBJECTS)

