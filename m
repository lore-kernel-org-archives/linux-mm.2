Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0571FC5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 22:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46C056B007B; Mon, 10 Aug 2026 18:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C8A6B008A; Mon, 10 Aug 2026 18:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B8E6B008C; Mon, 10 Aug 2026 18:58:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0BF246B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:58:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08D53A02BF
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:58:24 +0000 (UTC)
X-FDA: 85086875328.26.FD1F017
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf10.hostedemail.com (Postfix) with ESMTP id 51297C0003
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:58:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LMIreBZw;
	spf=pass (imf10.hostedemail.com: domain of 3jFd6agYKCH8vhdqmfjrrjoh.frpolqx0-ppnydfn.ruj@flex--seanjc.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3jFd6agYKCH8vhdqmfjrrjoh.frpolqx0-ppnydfn.ruj@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786402702;
	b=m8fVfh4BNI2qSxJz4oSXyZtSwozCVJUSP3rdkUPNij7VV0cYLXn0SVw9Insog7GWlHEFOq
	V/ocCp7KR14q4GBB7tJ6e52TAg18NnIV9VyoMc8IACE4SnEayJcDyRyf4U3+HUCXajBHAG
	9JlqOBCoqmnp2fLv9u9Fuh6e0xQjZPw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LMIreBZw;
	spf=pass (imf10.hostedemail.com: domain of 3jFd6agYKCH8vhdqmfjrrjoh.frpolqx0-ppnydfn.ruj@flex--seanjc.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3jFd6agYKCH8vhdqmfjrrjoh.frpolqx0-ppnydfn.ruj@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786402702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Mn9WKaRVsVTpGaOSKTBrlWB9M3O9fuL04U/nAsMmiI=;
	b=4XlpjNrGTpivP6/ss8orZCz2waYooP/LrPFyogGgT8bbrYv/5/sqcW9TsGlRlXsKZ8TEmV
	zakGpdgUeFPUIumXliLJm64Nxc4VUEN653SgznIVEjg7hTr5OXy7ki0b5tFtbx7ucJlqYp
	T7IYfjrpOGBA6TiNavCJSIQWprAyBGM=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38f283baf1fso2439096a91.3
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786402701; x=1787007501; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2Mn9WKaRVsVTpGaOSKTBrlWB9M3O9fuL04U/nAsMmiI=;
        b=LMIreBZwOWB6/JVUpK4FsCWeyXSYcWbYptN8M6+zb/9tlraHFLugmysUnlRWix59bw
         DhsOmL+XJiGeR/qEZaMNOn+OaiwllPD0izlIvwURka5H1Nl4JVdO1xyfXsHINLW6a9PC
         ko/mYPI1+eA3mfIdIT6i5bwwYH1oRtQbGuzB6ttMRymupyQVR1x3ZcRy2VNDfeE/g2Kk
         bHsI2fe4wBRKCwUFErhT2ULFS6owK8xsKXtOFyRBDY8RXuugXFS7speWozV1Q53gB1vV
         stBbFlTK9xbkVFFulrw+3PbHO0KG0CbyLFWzMCMQzrELWVdtJzzHTob96q5Wd1m2huxc
         V+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786402701; x=1787007501;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2Mn9WKaRVsVTpGaOSKTBrlWB9M3O9fuL04U/nAsMmiI=;
        b=WbhfHb3xZ7+UcQYqwQtX3vWtPh8Vs0F4fxN5MhE5MXkB2i0RF6JuqVW4aE6QNu/6mB
         YcxS5mGbDz1y0LVMLGxb+L2ptqEft7gDwu67rEcoOXylgsHhiuJLXTBH/juHhcWAfw5Z
         J6IpHXcP8EoqLG9M4P1An1RpyCMjtAKVpUBAb6EIQxQ+TbvXVkr0j1639ML49si7MtUx
         OCVL0zo3KwVO8KizP7FMIgdmnSBOmpBNW8uCThNYUphQ6FMUz9n7MefQM4QdDm4E482G
         W4u701nTrocr7KIS1dMHjfaBHLddx2rapQfmUyY5CjHFqDwybQTw+Gfez4xumm974Ok2
         iq2Q==
X-Forwarded-Encrypted: i=1; AHgh+RqUs/EmPI0iNe9tXcMpflo7P1ia6R64qezuJ8gphlAbf7FmWoXaUJjIlg70k1iDZ6/0nT0mLcJ7hA==@kvack.org
X-Gm-Message-State: AOJu0YyFUBl9rPqIMq8ZMTTvuPQ95wdMWwQn5Tt8CvUi6ILu5Y65USrK
	o0yKdevcLlzgnbr3l5JydHnF3ekHbhNNLNjBKLnYLrqM/+0vHuqDJol5Ksbifl9kZY8+V3ECZGm
	WqzGJpQ==
X-Received: from pjse9.prod.google.com ([2002:a17:90a:77c9:b0:384:934b:9128])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:590e:b0:38e:6a44:671b
 with SMTP id 98e67ed59e1d1-3909d301d9cmr33802476a91.0.1786402700758; Mon, 10
 Aug 2026 15:58:20 -0700 (PDT)
Date: Mon, 10 Aug 2026 15:58:20 -0700
In-Reply-To: <20260728121138.1103610-2-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-2-tarunsahu@google.com>
Message-ID: <anpXjM_lg_UTpl0q@google.com>
Subject: Re: [PATCH v4 01/11] liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
From: Sean Christopherson <seanjc@google.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 51297C0003
X-Stat-Signature: 7ttm43ppmcufdofdgpq879gd4mamces7
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786402702-174676
X-HE-Meta: U2FsdGVkX19GOzq0oUR7/mwcENDw7QqdilMcAjIqG9xg2WsGvGgqxuQ+RVFu45vQX1+rUcXj5wjpIGR4aKqa1z1a5f+vPAIprXduVbB/XEf7BOlFPyx/PYVBvAacLHoDuxFB8wfOcWnPMBNUq79RVj7y2vTB4BvWFkBcmSsg173oQAQcog0UqA3/5vBv3gzTgo49dqdyEsGlYKrInH/H6EShfGGRJe9IE7R66ztfKXbKAWVffaErtLRFydD+lJValR26eJhBVVrrI2JB5uAV4vyHkRHeCGf1UR+2ai8oQSWfRNnYXb/r/EQM5pSiyu+6u4Cl2NTJ7IHl1bRh/7to/3w9jewbCv/5Qb8Az0GUZFZUL4T2XVrDMvRxCsLirVlVLOjhquXfuUNwcjrkMGIQBFkAjdrYJI+8lQy97PqMQCcnz13EZLmWKgl4O4HwEChyJIWxntNWAaTzNVWtQ6zaJV1+rN0dbBEV8fmYFwzY19qHkY2YEt8UFYnCqmELhGeNl2oT0lH8hmfHfKbxN6PNoXVa/xYRDSnHfLYwpdqCXNmaTBLpPHpz37HMCzoxj9LTNHoVbYacwqsbZPUoWIVNAczlT3ISyLieDBi969mdeTyR/SkYeSYlZgbfT1Z9vL1vtDiDj+d0x9ooHPUj9KLgHVoFW81PXRakbuPbKPd5URxVYxZX41FiGnYn03uflAfFD6ZLZPZp7NgGF7lMUo8x6Cd0jfiUJ940+ufQ0YnIfOVy32WuWJcLZe7gI/Ef8ou8RdSl/gYIGfRpo/K6aVivpfQgvEmazrVMYrGIn3MNJ0o88W3AsgFEMUC1BJxDPhRLjsU0kl2YEh0XXb/bZLh1RhTljAkbgxljcPf6ekvYMot7BCZ4eTGv6h3olSkgg/PvGJP44e149rJ2/OGMTsl4nNr/yrjs6XF+4yPFsxgUDjPyFRlzY7gDBD/DJ4L6EQbRjB0mt/j8jANH+LsKK2l
 +kA0RLZQ
 USlK9GBF9mtOPccb/t2cgMd3gHSMeKVfAoGHQr5dtBVpVMz/oxJMKMRKqX57di/7zzZUbMqEcoM3pwQYfOlr0cg3naj1Ss0NzsZuXvly2aucRAFXTviNE2AxXNVxuYJfaNHgKbSIllfxRUDijHdC/S6OFDIq/7ZSJaUuu9mFOVm7go0aHK35yW/91ZsoBRUkf5s5zBvBZ5wBwPcTC6s+Mw7/Sn4Le8JF2ZezoxDhUm0ypyxUvINKaVQNw14rGF42mp1O17NGmaz66/dlSFtNk4/PFhoiNIu/1WjDuJclhZdlFv8h71UvUAzl3gIxqnh4/dfcEBmKPWLO6IZpNBwiNWfbox4ltFQPDDYGxswh/enDQTRh2/V5tAscR61Jq1WQUQFziTJy0x2okNykwQK6L0oVTCuWUZ9MVS9P+J3gea7f58ir6y4D2uB78PaxDSAwHZr2bJ5HBcnPoa1UwBJzqBBOXNBqqBlvQXLsngbn0Iqo7V12yE9n1eA0XmtElLKnCncmq/XMDr1F0fyUdxf+0DdsAlJm9e5alg/6BWp3u4GZBNJ6ofOzhAOg7Qn+4obRpY8cpSHw6O0/RLe6V8FreC3iFABWo/iZhvIOZvnsxTr7LgHUk021z4QCwGNNplL7JkoH83RLS/7R4nP11n9MC8Q2xbBaO1kfiOUPvjulG0q/hFWc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026, Tarun Sahu wrote:
> Introduce the LIVEUPDATE_GUEST_MEMFD Kconfig option. This option
> enables live update support for KVM guest_memfd files, enabling
> guest_memfd-backed memory preservation across kernel upgrades.
> 
> Currently this support only guest_memfd files that are full-shared
> (INIT_SHARED and no support for private_mem).

Why?  Specifically, why do we need/want a separate Kconfig for guest_memfd
liveupdate versus KVM liveupdate?  I can _maybe_ see a KVM-wide Kconfig, but
even that seems like a stretch given that (AFAIK) hypervisors are the one and
only use-case for liveupdate.

