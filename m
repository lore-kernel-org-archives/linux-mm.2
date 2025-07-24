Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD149C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 22:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B40F6B034E; Thu, 24 Jul 2025 18:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 664B76B034F; Thu, 24 Jul 2025 18:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5537A6B0350; Thu, 24 Jul 2025 18:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7396B034E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:35:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05C74BA237
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:35:15 +0000 (UTC)
X-FDA: 83700615390.09.B0596A3
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 471871C0003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:35:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xhuBBtkF;
	spf=pass (imf21.hostedemail.com: domain of 3H7WCaAYKCN4SEANJCGOOGLE.COMLINUX-MMKVACK.ORG@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3H7WCaAYKCN4SEANJCGOOGLE.COMLINUX-MMKVACK.ORG@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753396513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PFqcIXETNfo8GzEn6hB6Ya7g4JGq3t1ggKMLi3jyaSw=;
	b=6dA4MqWL13JkaMQcSCf7+hD0MrVSlRuBZaCTiUmuApXsZeDC4HpPF25wgyRNMKxL+XVy7J
	ULuv2DQxaXUJsqSUwV23ai4n8X5Zb6vhntw9dTmk4iYWHXzpp99XcGLKZlwA0olQR+Jp2B
	BNXdQg0BzrBNmH+jVS7EMgO2J7+q62A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xhuBBtkF;
	spf=pass (imf21.hostedemail.com: domain of 3H7WCaAYKCN4SEANJCGOOGLE.COMLINUX-MMKVACK.ORG@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3H7WCaAYKCN4SEANJCGOOGLE.COMLINUX-MMKVACK.ORG@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753396513; a=rsa-sha256;
	cv=none;
	b=IPhl+X/9epcYwH875LNfG3GCXH6FtGrGhqPA9Qb+Lt7+tuqgclVfCFlMaA+vFrjLpy7CBh
	dj0eEQJY+cL+tX8lyoX3BBcTJCSb/0zEYb8kT9G2Oxmz25m8Onke+osN0ofnX3B58aUiq6
	xOBArAmzisNUzz/V0C6xESt8pRYOXUE=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313fab41f4bso2244980a91.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 15:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753396512; x=1754001312; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PFqcIXETNfo8GzEn6hB6Ya7g4JGq3t1ggKMLi3jyaSw=;
        b=xhuBBtkFlbE9zbMT/Vy7St8c/y7IsZyU9bIaWFf8JhMwZXxaao0lYiZjX6Kptx4tOC
         5KgTpsu/K821ccZw3zpMZU1QlTirSxf+G/fA4iRZutac7TVb5w/KI/w/FMTyO4SYXytU
         rYT1muq560uRBm1LdlQ3KirHmR2fXIXHnXALX4oAofgkf8mUJ9iuRV+dxhM0D8I9ZPGv
         LGbWWN2hUdQZ83kFG5MVw+QTAVUbprKysS8AK3QcOxiBd0saGVPJ/7DZTVPLTGGkW/kx
         YX+URTsI1Mf8cH/31evQ+cG6izpWyIlwQ9akKcE50AMb9KY1HUvhu/cUoENM/vrzzWZm
         7amA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753396512; x=1754001312;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PFqcIXETNfo8GzEn6hB6Ya7g4JGq3t1ggKMLi3jyaSw=;
        b=Ik3nYGiBYHdrDh4Jbs53ikZQ3e4QoowPbOncgJnQvM0rx+Ts2lJ76ojutuMw2eRfas
         4Qh9H5r8UQAGL6sxx3tkudL/qB/es6VyJ6NzwwuLjkqnFAWBI0vNlGKvsssKtDGgvpyU
         4s/926HyhN3ESnwh7MEt/opYckl6KrO2ILLgXW4I8IA9oHJpPmJBEpLAQ6hU8g0Zzu37
         yxY0uxQCvxkFXqXJeqm/du+XKoxnG1sW9RhbIImsa7Kz1Ecy4KJw/z19hrRqnNaHib+L
         z7GCsnmzhLFUdypQYO64nmE7kfCbmChzc4ltzzt0KjEUEJA1Y3tMBb90LWHgVl2D9QbY
         PIQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpKSho7V30n+cwbgzs6Fc375hbXXuSdP7gPDWKOt7+rCD6SVDm58DTEUBsslqwMsnYsutvmh5UQg==@kvack.org
X-Gm-Message-State: AOJu0Yzia1fqtvuXXLd8h1b3wYxHubbA5adpqDqhv27gvlXPeUGewxXC
	wGxsyMtva1drB60FsfyFL7weYZ0SvLe1FSBtiq4zitjRQM2kGQljoitX447wIFFis6s7pdQR0hD
	06GdFzw==
X-Google-Smtp-Source: AGHT+IHuVeukYr6lWMjvsRkjvN6oFU8CQPzldpvdB/N9yisxOdKopu5kObxNBBArWTOrC8zyhULTFJAICEM=
X-Received: from pjbsu16.prod.google.com ([2002:a17:90b:5350:b0:301:1bf5:2f07])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3809:b0:308:7270:d6ea
 with SMTP id 98e67ed59e1d1-31e50855de1mr10081085a91.30.1753396511877; Thu, 24
 Jul 2025 15:35:11 -0700 (PDT)
Date: Thu, 24 Jul 2025 15:35:10 -0700
In-Reply-To: <3f337306-e79f-4ac7-bb86-60b88b262e88@intel.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-5-tabba@google.com>
 <3f337306-e79f-4ac7-bb86-60b88b262e88@intel.com>
Message-ID: <aIK1Hp4jZRY4zVTW@google.com>
Subject: Re: [PATCH v16 04/22] KVM: x86: Select TDX's KVM_GENERIC_xxx
 dependencies iff CONFIG_KVM_INTEL_TDX=y
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Queue-Id: 471871C0003
X-Rspamd-Server: rspam06
X-Stat-Signature: 1d4ebzsmnoiqsri5mfozoox37eiunru7
X-HE-Tag: 1753396513-993588
X-HE-Meta: U2FsdGVkX185BJ8O+OcGaUCbIi9yqnxVjKkPhk1u/qF9m/uVxTNtZT6+GCHjMxtHrZ7rUI8CTb0VeTnpuVBDMMWn4VAVD9GHdk8M2lmBKPAwK0zqKp9I4rQUoIiJ8EoBQD1o3mxxRGFR18Nh0y5XfLvbVTygLy/nPM4dpevQabjRYAuOOZh8Dxn7iAr2K5EQ4Rff1WLjRvZ12/Qs1vdjnce6YkL9T+QfKL0GvALbwKPed9U/x3iuYhHvW+/pWyqtTFCHPFsjG13BZok6+19lTEmkp7icDkH/B4g4rZL9xZOpm1ExAwQV0TM0QdjAtugQ+I6dmA7baXnx3C8AQ1qHORhW9b4zpzdUOnr7qp1gUGagTpkRhhYbCoaH7pEi4xEvDxUyLq9UOXI4dCzPSdXjOAm2rCDXP4r84GDZmT2cTdA/TrWRrDZpQENO7mOxYJeO2IkY5MkwNb4G92B4nmssjYM+N4ychkTwPP5fzoOPRatp8FlI8IA4QEpXJPtN7DizZT2W+1uXnJYlE0CupNyXHdV8K/dKASDveHmRos4umPfLuY1vrjJBKNDKbGI297VMfNmouiI18ag4h3LwxefXseiQFrcCVW9Au4e6A/826Ch9Z8ZY/8l0bJQTs+5KJ3roVF23pXpZEd/fO3JOe4/TRIBao6rS3BSG9+4q4m9bAVQglAtOj0RTYSuErSWmjwKSh2OYtLDZR106FBT5taFlnzy/9n4PRWsioTAd9idXwd/L+WV5hQW2n7y5OUPS+6cGmZ+W7eqRTn3TGdQh13c3+pzYPoSokUoLME2HyPnR5tfTSGh1CFw+0dBORm9dafz6xqhVkGJoGSsWKLdeNoIlgJHOKvmrQJZh8LgAMLx8qK4IroLk0vOY2U+HCCsKX2vlGK0MGWT49BPcKo0NO857RwFJbOMFdzWa4+qSJIvY7Mo66WGEW6RiLO3BnaWgymq+lfA+/wRlt1zIPmO2Cgt
 j37DJDGd
 0CN3aa9OOeLNWY/hkibcnDMBnhRlzb4VyNh5+4Vrxk5RBzKYjdaxxq7nit5hjSabhnVyDfdln1YHUWXV9yeqjBLvraiY4WlsMqouzTkIQvCfZyVcrf4S1EugvGkimjOB65eq2G10rW9vJZ7j9eC7Iq2OVWbBU7LnlK+4reNQCXAJN8vw33TtWkH9ky7ua6tcBmjn43wYbofmwZD+C4pz3uUwsnwj4AwFiyCbz+Yz8vNpq9Siz+JRDUH1HwqF+qINEsgefnIFyLDWEImia5ppss99rgLYjuZy9M9XIXE29mfzHP2GfRxx+6MiMJ/TmdfUuVTaehDVbhLLGcfZ4PSq/L+rxZ95y7X1avHgrnaLbIj2TTeHCMTFpqpSG7rGAVF9bMWnZY57TVajGEELYBE8Os9w0Qi9/kIuxpUlc6NKprBE+WPkBnziGwWEMFQaHUg1kujpj+2HsMT3q7DID0HyTzZE/GcwdJ8JkehZSe3WzGo7TDUbb+tj2HjhxGRMEByX6KZm7IDLVGK8d+42M3vpnTYsToQNVBgCm44GT8dUwTYtb5ujOaODqRtkR7rqoja4zTWRNpFVtq53xx4iujp2NmzcOhZ4jI5Ymy5nI8YAIKZ+Mn6u8mQn4SGtp2xNN2B0RHU+sNqZCAVAzWp9TQ65gEuJypjIt2mEx3jr1TXW0ViYRVtbFJDbRna246Nh6x3UO1q9hu9RswU4bc4scYgj9rKKQ6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025, Xiaoyao Li wrote:
> On 7/23/2025 6:46 PM, Fuad Tabba wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > 
> > Select KVM_GENERIC_PRIVATE_MEM and KVM_GENERIC_MEMORY_ATTRIBUTES directly
> > from KVM_INTEL_TDX, i.e. if and only if TDX support is fully enabled in
> > KVM.  There is no need to enable KVM's private memory support just because
> > the core kernel's INTEL_TDX_HOST is enabled.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> 
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> > ---
> >   arch/x86/kvm/Kconfig | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index 402ba00fdf45..13ab7265b505 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -95,8 +95,6 @@ config KVM_SW_PROTECTED_VM
> >   config KVM_INTEL
> >   	tristate "KVM for Intel (and compatible) processors support"
> >   	depends on KVM && IA32_FEAT_CTL
> > -	select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
> > -	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
> >   	help
> >   	  Provides support for KVM on processors equipped with Intel's VT
> >   	  extensions, a.k.a. Virtual Machine Extensions (VMX).
> > @@ -135,6 +133,8 @@ config KVM_INTEL_TDX
> >   	bool "Intel Trust Domain Extensions (TDX) support"
> >   	default y
> >   	depends on INTEL_TDX_HOST
> > +	select KVM_GENERIC_PRIVATE_MEM
> > +	select KVM_GENERIC_MEMORY_ATTRIBUTES
> 
> I had a similar patch internally, while my version doesn't select
> KVM_GENERIC_MEMORY_ATTRIBUTES here since it's selected by
> KVM_GENERIC_PRIVATE_MEM.
> 
> Anyway, next patch clean it up as well.

Yeah, I saw this oddity when writing this patch, and decided it'd be easier to
just deal with it in the next patch.

