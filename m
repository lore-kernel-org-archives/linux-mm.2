Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00AC2C83F25
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 19:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6363D6B007B; Mon, 21 Jul 2025 15:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60EA26B0089; Mon, 21 Jul 2025 15:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B266B008A; Mon, 21 Jul 2025 15:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4611A6B007B
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 15:09:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC04980190
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:09:24 +0000 (UTC)
X-FDA: 83689210248.27.C47EF61
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3AFC11C0005
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:09:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dTC2L2wP;
	spf=pass (imf20.hostedemail.com: domain of 3YZB-aAYKCMY4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3YZB-aAYKCMY4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753124963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Si1iE2iNBG/ks3WLyUfkQmiowbypc4vWR85emDi8O7c=;
	b=syeXrQtGZ8f8TJcZrnfrk7b89h1zFd2XJ9iICJwSkV1FITC28teqK5tJcW+awawNjdOMlH
	XTLa+rDRO0hy02vqKwThlB2otAi72Ka1S1BiINuuslRY274BFVuZpqdO0VkgQKe9uPSDs4
	SY9y6NqD9PfFxzoYXyFEZljP5QK8N20=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dTC2L2wP;
	spf=pass (imf20.hostedemail.com: domain of 3YZB-aAYKCMY4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3YZB-aAYKCMY4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753124963; a=rsa-sha256;
	cv=none;
	b=SFWYwrFDnSAgL+uIhXaWyc8Z/DKl12HJFPF0ZjKLNs6ctWCtoJZw2PXgxweoRFAwioGQVE
	2G3fUdMVNlJpn4Hc5/kvIbs7hd9ADjr/MotmBNBEAQlxtuxa7fi+Of2EMitDSbyK+2uoq+
	Jwe+YX4DYqAcrPgec725TT/aaJIcC9I=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31327b2f8e4so4155681a91.1
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 12:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753124962; x=1753729762; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Si1iE2iNBG/ks3WLyUfkQmiowbypc4vWR85emDi8O7c=;
        b=dTC2L2wPKhvxOUXTL9hSTBNv+CoXhd4/+ulbImYWVBJOddRZjL8LHXUAxVZ3Qs2EIq
         LseVKzdQA/nLXzB8AszcGTAh+ucjZjIW9u/h1Zmrq9s2t0NWAgPeo41QJ68xULhqxNcE
         ps0xZ7K6WK8jvGj+K0REqzfIcrAX1S8zQw2Hr2Dqdxl58wziGqbh0i/Q/Z4DkwsLpqri
         p/WE21e09PCmKLHUfU03bVYdHx9DzG1trc0DEFVUChgfY4bygbmzxIpNRZOprtideUxi
         N9w4g8aOXLBvlWj8T1M+WxBRatxqarvrPjLJpjmcULSla8cju7Bp2Z8LotTdOl7AmDFG
         2BMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753124962; x=1753729762;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Si1iE2iNBG/ks3WLyUfkQmiowbypc4vWR85emDi8O7c=;
        b=niFGTTEKwbYQfcupWRujmVlBmyF0m1aJcvCns0JW+W/fmltyd7q6Nh2ZE9wzEGw5Ze
         hNy+TZJPBZ1uZWHN6V1vDeSDm9/ctjNflOy3JDLbY55lrck/pAN2DSVpuXinjHvtYn71
         LI5Cm7BdqB75Epo6hyxdukcuWo6Etyi8fsgaC+cXd0JM1y+4c99NUwwyJCxVOD0Y1Qzd
         nF23GHCpXKjJZsvyMHmEZXiExOrvh2YJU22Fqo999IM7/rqSg6LDYWCEcxGHMdlCM/Sx
         fCXIaWF3/ka1MvmIaXlApduFg6Qq8pCZUEWI0gYlxbYQpDYpP5pMSuwVDQTalgJjpJPx
         Co+g==
X-Forwarded-Encrypted: i=1; AJvYcCVELOJ+ShlwrqZUIMe3dRjuQr/MV23oDXe+c6UJNkIxYXcHZ0dpfjyQgysP2VMti1nVXmYeStwgUQ==@kvack.org
X-Gm-Message-State: AOJu0YzzKWB2KyFJdFtWZ01BmWq9axyNsLHhgU6r1N5QZ2eZ+VnjOXCa
	e0yfAn5+iWX5h8ntkQEyB7SqVF2+3sw4vMbAGvoINdO878tPlBNt9Nbip42GxL5C2YPu7WmuiyA
	lYDiwfA==
X-Google-Smtp-Source: AGHT+IGbFJhpUQREKI8MWV2U6QwjTBevOOYx6cNDrdGaRxBnZH6BAHAIN1v9eC/o9N2pBUnhgExVswlyNEw=
X-Received: from pjbqo12.prod.google.com ([2002:a17:90b:3dcc:b0:31c:2fe4:33ba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c4b:b0:311:fde5:c4be
 with SMTP id 98e67ed59e1d1-31c9f45c8e9mr24240317a91.35.1753124961668; Mon, 21
 Jul 2025 12:09:21 -0700 (PDT)
Date: Mon, 21 Jul 2025 12:09:20 -0700
In-Reply-To: <CA+EHjTw766UKoLVoxGWDS2adq4m0TWsxwTWMGsjMK=qkSx4iCQ@mail.gmail.com>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-5-tabba@google.com>
 <aH5uqeQqvzgJOCN0@google.com> <CA+EHjTw766UKoLVoxGWDS2adq4m0TWsxwTWMGsjMK=qkSx4iCQ@mail.gmail.com>
Message-ID: <aH6QYFTKoDqnxrW8@google.com>
Subject: Re: [PATCH v15 04/21] KVM: x86: Introduce kvm->arch.supports_gmem
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
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
X-Rspamd-Queue-Id: 3AFC11C0005
X-Rspamd-Server: rspam06
X-Stat-Signature: eghh5oc4ndzikiudffrfdd3b98m9jr8t
X-HE-Tag: 1753124963-104721
X-HE-Meta: U2FsdGVkX18B3HzCglnJqRUAH+HOk7+zM53Ku1yX3a+P4KrTH4iGg6tBtab2yAXQEBrhorCcE2waYjA8Wy+IVNBueCQze4kQiJBOkIwSiu0l0JJ+Dhi6XFwUOvZ6CVCVJGyIg3FIjrHI1HWuaeeZtje068sHeikDddzTqEgZvUTywl9qc+JhSW58KzNW5Os960hmdW2uwp0K4wgNVCp/+EHVeOovzHKyLMjnaMQEI5MKpqg4t9Mk7BfgfEQyTfIFmw+48vsczuUj/i7GWoGFHmHKTIm/Z0bfOUTpYGdrEx+SfcONiFOebu6+mHFWzfXwg44kuewpgDMYJfkmMpDTQmqlITCLglgSxQRBT7lRM0A+wGG3aLrqRna6UbASWHGM7OzX1xm4VSe30AwoRWZ1PAqMgIzFu1YKHnoFBcI+gwZahK8UIKkIb+3qyqN7/M2Prgt/NvZk1c4NRQYVKfertBMiwbFjJgDl3lpZAjvSaH4TGgXP1tjnniwHGqbNIZimEVOsrGlneeuN5mKldML+dC7XEoQDu6CuUvVIA2W6FLtjZGsvzFFXUPKUziu/RiUZNkMB0Ukhz97lvRomPva+B1ogOHz4WVGRayyBOajLLizff6Y4F57kk43ypK3Z7iwWoMPkWP+uVj11p8svBGCsrIWo3YMu0+bEL+edhcQUcNhBN9hoejjVVRAOz0186Iw2HO6OSSAA7NGJCD6uEv18P2Zw/dnbuz6T+qx/2RdNW1V0m8weoKZIxWZLGkHu0AhIDQQvVFUJUUW5urwq59HFfVZtrW9grysO1Ey8JnPTIPjufJ2hk4xCt8PhJJj49NdPMoO135DuItuYrpNu1cyq0hBNl31Lelta+BnPrPX86kA4/PQDYZ1St52+W/2gtAftDEfnQZvCr+ojTHVJ4lMOjB5cjT6kckWhRxCo5zsDYqOJgnE58NStQcqPXlYdO8Ux5TOC8sL4DpgJsYpltVG
 kInYFWDT
 ElzGKzsGegXzo7ypq/lhabA9NGdpiqyGCBgkf7FVPgAEA/MUgaeM64lU5VaB2dXddUIUrB9ej0qS9KbJTAEf6N1nxMgvc+PVyaY+t0CZL/+vyf2jUsxm72/WEa7ng1IgIMSEb5+jcIRZM94xGkTF7eIePxAUY4ZJwELAppDObv4LtUrtgPtzHofE8Fr5geK8NN/HUqT+1wd4GALO1PZXtVpkf5pBGt1JvX6DoZ/z9wMSHaohg6w0E9JsUopy0wUXlpdisY5ELjsnqVpIw0HBuXn2zBZk4UE+aOGndUyXfJEH5Cm3bDw7JSSMatkc9Z+1VlVgGuWlXWvVkccIRrnewIZJmgFYLfsFeNJ/d1rHk0MepDWGRDZTVOsRrk7R0D9X/rAOdvOFshRHtPkQ9/dFwk1L8CClKkCH36Qe4mPtFTdqFXb6zJ4G29Vv3o4bcIp1my2dH5zrwjJREjjhUkaGtexGiQiGZ0JLA1Za5yi92OcEN8Aa3dOz3BIeOFwkTvIgNp9JvrfuOWR4N9ped9lNX7eCltVR1E7orzS2kIeXl9wB0REoBt3xGqRld8bobLXh4yy19Bu+mofgn7a1q5DpERPnJAkngjLN6biaMZzQRNSwoB2HmjfxlJzRb4UxCSlZUGP7+7fIgFohJWhzFavtH/n+Vfhnh6RuC5iIbS25H9hZRpZIon0dUT1nKJuLh1z5s4lgoYdvDiduBn7O7APrK/BxbMpyo9xKBcsnilCayrAGX3uU/19gyM0+/FYIwQeeh23SMjvjTquse6qwvrHc5tHdGFVOIicTa33D3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025, Fuad Tabba wrote:
> Hi Sean,
> 
> On Mon, 21 Jul 2025 at 17:45, Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Jul 17, 2025, Fuad Tabba wrote:
> > > Introduce a new boolean member, supports_gmem, to kvm->arch.
> > >
> > > Previously, the has_private_mem boolean within kvm->arch was implicitly
> > > used to indicate whether guest_memfd was supported for a KVM instance.
> > > However, with the broader support for guest_memfd, it's not exclusively
> > > for private or confidential memory. Therefore, it's necessary to
> > > distinguish between a VM's general guest_memfd capabilities and its
> > > support for private memory.
> > >
> > > This new supports_gmem member will now explicitly indicate guest_memfd
> > > support for a given VM, allowing has_private_mem to represent only
> > > support for private memory.
> > >
> > > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> > > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > > Reviewed-by: Shivank Garg <shivankg@amd.com>
> > > Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> > > Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > Co-developed-by: David Hildenbrand <david@redhat.com>
> > > Signed-off-by: David Hildenbrand <david@redhat.com>
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> >
> > NAK, this introduces unnecessary potential for bugs, e.g. KVM will get a false
> > negative if kvm_arch_supports_gmem() is invoked before kvm_x86_ops.vm_init().
> >
> > Patch 2 makes this a moot point because kvm_arch_supports_gmem() can simply go away.
> 
> Just to reiterate, this is a NAK to the whole patch

Ya, in effect.  Well, more specifically to adding arch.supports_gmem, not to the
idea of support guest_memfd broadly.

> (which if I recall correctly, you had suggested),

Sort of[*].  In that thread, I was reacting to the (ab)use of has_private_mem.
And FWIW, I was envisioning supports_gmem being set in common x86.c super early
on, though what pushed me into NAK territory was seeing the final usage, where
"optimizing" kvm_arch_supports_gmem() isn't worth any amount of complexity.

 : And then rather than rename has_private_mem, either add supports_gmem or do what
 : you did for kvm_arch_supports_gmem_shared_mem() and explicitly check the VM type.

[*] https://lore.kernel.org/all/aEyLlbyMmNEBCAVj@google.com

> since the newer patch that you propose makes this patch, and the function
> kvm_arch_supports_gmem() unnecessary.

