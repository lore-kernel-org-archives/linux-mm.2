Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C16C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 13:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C2E36B007B; Thu,  6 Aug 2026 09:20:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 373B66B0088; Thu,  6 Aug 2026 09:20:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23EFC6B008A; Thu,  6 Aug 2026 09:20:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E63A76B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:20:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 668C1140671
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:20:20 +0000 (UTC)
X-FDA: 85070903400.07.8D2A441
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf26.hostedemail.com (Postfix) with ESMTP id A1A2714000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:20:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Rvte7yVo;
	spf=pass (imf26.hostedemail.com: domain of 3EIp0agYKCFEBxt62vz77z4x.v75416DG-553Etv3.7Az@flex--seanjc.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3EIp0agYKCFEBxt62vz77z4x.v75416DG-553Etv3.7Az@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786022418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=quMxwgvzS8F8CxQzPIpHc+hBSqfVyEO+f6ARjKTQRm8=;
	b=6AnOk1Bny3rDR/IYteLlJo2b9HxYKIQm838wnrc8mFGv8HqiOyKdvf9X1jER8kolCLBD3Y
	yavSfRxh3Nio1WJazukglekkbHBhG5OrafPN+fvJxvuP6kPyAxTTBFleOQhE5be/mnC2I4
	x9hrdawUIvb7f7JovoQdJiI+ZMC+++A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Rvte7yVo;
	spf=pass (imf26.hostedemail.com: domain of 3EIp0agYKCFEBxt62vz77z4x.v75416DG-553Etv3.7Az@flex--seanjc.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3EIp0agYKCFEBxt62vz77z4x.v75416DG-553Etv3.7Az@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786022418;
	b=ytlLumqspVlPxPW4sREjvzfI4MUmQxkDAPTFiQz/pwzyaf5fURX80LGZqkfzitE2bxuGdN
	FVxRu0wIqS9AMLE1DdIP1uRg2sdEEV98TOl6woZkDreP1LD5BgOyHunI4U1uHwSzeNiibk
	KsIcpx4VnGj84rpjdNeVcd6lrMCCB88=
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8487eb67173so3592568b3a.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 06:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786022417; x=1786627217; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=quMxwgvzS8F8CxQzPIpHc+hBSqfVyEO+f6ARjKTQRm8=;
        b=Rvte7yVo99QmzB4OXvXXlyrm+sowoudcRoihDkQS2EYqwnB47Zf91Xe9KyeUQJ0DJu
         9z7Lmo+HYcYXm4DRNZdZAJyWS9frr/sFct9kbM2KLG9MAHn7fVhlqbbAeKcsVabUGkgb
         /1UszdGNYgAiUEHycaBzXXOkF7747H1OF2w8QBK6T/vunNU1aHPc3cgNtEp/Ze9L7GAq
         JcIAHXwnSvzJ/wCY7V23t7+a5lpt103HZ8tv0+ZUJx+Dkutf1XieOpXzgN7P9tOrgwcv
         UtgzQ+SY+c/VgGNW2ojN3gPeKjCuCT0sKSeR3QgkqfERSnckoiptShhj4heiS4V9e2nC
         RfJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786022417; x=1786627217;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=quMxwgvzS8F8CxQzPIpHc+hBSqfVyEO+f6ARjKTQRm8=;
        b=lo6v0qOuN+hxueDV24gvFpxYA67aigcC29b0rfaBvUqymV2pdqadmQ6brAjFAwmDGa
         vWa3aJqkx3lqrNxCDzkaIRV6VwcXuuvGE1PzHHZT7NMtwS6zG76dCgNXPlpU8LHp2Cf4
         ecvfcSIt8CcC+OgO2q/i7UFhv4ASb+uUy7Wd6zemzsmE50ek+XnZAQGP/ryrWraSw2GZ
         4fSCE5XXBOKS9t0X+Gkf9XgAG9wKI715nRTR6yTXkG7me3K5cKpCyL29DyBOdLad6v7g
         te84sQ62P2Bu7E/KaNEnw3PzlfeC6ZdRAniA4CcBHrYtwvdBNsY4HiM1XKotIG11W7Xr
         KuMg==
X-Forwarded-Encrypted: i=1; AHgh+Rpu7go9lUhOgREe3dlmFN38PzEUxXSlx23cGJNRpsKh/Ja5gX/94IXTNCVb3YNBSNM3ZNX8OPnfsA==@kvack.org
X-Gm-Message-State: AOJu0Yw/3eHFT8CIKTP87ACDWd1CYHenrH9MHoNWGvkPieH4/g/ie5Ih
	op93jMBNRT+waXo2Mt9tVj/MUXgcvI0gi4WkEVyGhUWU/9q/V+T6QAgLqf6J9i6Ly9FHWJrlia2
	E2C35uw==
X-Received: from pfbcj19.prod.google.com ([2002:a05:6a00:2993:b0:84c:3651:a4b1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3ccd:b0:845:c7f1:29fa
 with SMTP id d2e1a72fcca58-84f2e04a63bmr16001363b3a.30.1786022416699; Thu, 06
 Aug 2026 06:20:16 -0700 (PDT)
Date: Thu, 6 Aug 2026 06:19:45 -0700
In-Reply-To: <fda26964-721d-4a8c-9225-46ca3a5b2785@intel.com>
Mime-Version: 1.0
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-3-35f9aec2aed2@google.com>
 <7dafaa90-f3d4-4be4-a5cc-472163f18040@intel.com> <CAEvNRgG3qXrG2ix2MEcyVo0GXaen-Pte4gFAwEN+9AY=VtGU5w@mail.gmail.com>
 <b9ad1a1d-c167-4adb-980b-90096515a363@intel.com> <anPYxp-LMWaLDbMk@google.com>
 <fda26964-721d-4a8c-9225-46ca3a5b2785@intel.com>
Message-ID: <anSJ1lLS0HZnfjCt@google.com>
Subject: Re: [PATCH v9 03/41] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: kw7c3364nwefn5ms416aguxnsqryjys5
X-Rspamd-Queue-Id: A1A2714000C
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786022418-219406
X-HE-Meta: U2FsdGVkX1+X4W7E4biSLKNi3FkWZ08/UMjfk5Yd4hQbPEOJne+aKIC3GQVQLxzrO3E2y4LhoNRB4a2NwJj22c9NrpwlwaX46zKt7P6o07wYqzkadH5k/O7sb4H+J3cXy41rm/fYV4QyqXYmTY/4EqznWfeE5XdCb1YvbNZezpLab1VCIpggUcsvVjkMHGTmZ2/V/hHTXUzUSQsq2tkXETTZ3IlQlr9A8e8Li79ldZr/g9G7EbfgOdfUWrem6LzSCD6el31CPtiqa86fZ9JdAlIqNkMbpMDuLbqgeDiFhTLwlpPlAUJZtyhD7a2+MnzCZMlvVIuFWOM74znS1FzeSYJ8TcGKRiUKm7roZ5A3kpJ6CBKMc0ooOiR///KUl13gOtY5kq12mTYgFQG4xMRc9HsxuTYJry/0JBWGHXPJmi6FmGewErIm5sL9gH5s50UmOTdqPmfa3grdQUq6VxaTUmrjxSWWeYPcahlAZN0laz4PWegkq6K7PzdP6gynaAfhJ16Zubui323ij4wtOHCFPp4zR8i6+6wVmj7sWhob5b9SYmpWingJaMRJAfeNceFy6HBxQz/pys/MdURGPuGZoMQQ8cS2996843tYQ4hlC6JuSrLdMWGFrLOhp7G8aENepVAcAj8bctEiSP/t7OPvbRpo+VolNnVYzgKcO0vbrk/A6QuFHPJRMm7qXTpnaV9uw9ibOFi1iSghCoIO7tqgJuv+z2v5crMoBIIysRDoSRh8XGZB8gYoVx7Dhoe2jSbu5AB+G2FEUkve6oDe1IsyYnG1BNXnqGn5wUP3w+REV3nVejw/EDp5CAFpJgU9du3elitKmOpZIVkgvaqaDPOhRgTO4nYJZK+2xzfb7Hz0xHkfR4fQPABYB3kXykqnvUmJ6HHW363lymPUr96ayF0Ace/fJcJwiBhPzoLGtwjDXs08621jA+e7ziCDPRJwi8nZfvr3EtMvZOkKBM+sY7+
 OFU/9hjN
 fYXBwfRWBjb4o4aQqHWcD3VDi3xEkfPA6kVhGoiQdW0U5hWb1zTYfZ8tWNRzaAmfXciG7p3q5UBFt6WnM/3hwi20RCbV5ZWaxnB6EviyI98D0ASMRr8cjhQFwFaMf4+JII3US1O4N/c4xNuxs/KJ6/3ZerO2K9oepFyPVTiwQghdhX+PiPT3iFxdgPSdW9Qyb+mEul80Ka91o8Tv7ZimIYBvqSehNdySFQ62IUViQjZYuyaBvdM+2c0ETCH5yHMcsLv+LiIzceDQkqURNKpn/7tiNF5KoChJWdrSPjfh0JdW6+B//tJMtGhI0jBd/FRKNbA3b6V/AvZR/sV857iD5R3b/2j/il7Q/iykKm6VX3tKREdoWct4i3GIbRBQOnw1FHBM6kXTaSCQnw6vacaIhef8xPLM9cehy9io9lGyCbJnfw1bHSTqot5/CXSsIjUM5oR+mCH6Qy4hHfbl02KSomeqrDkhnxt43mdR9zXy0xLgjzuD5Rn2EtTZrjfU4+AdiVPpo9GKgNw5G0ONVFf4e1ToFTCZZJL9ols+jHvpj30mAqDPtX1omFJyd16ktiCPUTDpdE5y7yNoP9/uV/Gdj6mNftv8n/97ds/ESXBwdQts2/iVuKOLLX81ay6sY+/ahBwPLG3wzd0IxBeTU48UedgFugGgVHPp7WcZc0DadmFtp5Vw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026, Xiaoyao Li wrote:
> On 8/6/2026 8:43 AM, Sean Christopherson wrote:
> > On Wed, Aug 05, 2026, Xiaoyao Li wrote:
> > > On 7/31/2026 4:34 AM, Ackerley Tng wrote:
> > > > I think another way to phrase this is that if we don't make this change,
> > > > say, on the foo architecture where there's no CoCo and no private mem
> > > > support, kvm_supported_mem_attributes() would return true for the !kvm
> > > > case, which is over-reporting.
> > > 
> > > Under the condition that the foo architecture enables
> > > CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
> > > 
> > > > How about this, replacing the entire changelog paragraph above:
> > > > 
> > > >     Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE
> > > >     based on kvm_arch_has_private_mem being #defined. This improves
> > > >     reporting accuracy by not reporting support for
> > > >     KVM_MEMORY_ATTRIBUTE_PRIVATE when kvm_supported_mem_attributes() is
> > > >     called with kvm == NULL.
> > > 
> > > It doesn't help for the case where kvm == NULL, but help for the case where
> > > CONFIG_KVM_VM_MEMORY_ATTRIBUTES is defined but kvm_arch_has_private_mem not.
> > > 
> > > sorry for being picky. I think we can say
> > > 
> > > This improves the reporting accuracy by avoiding the case where
> > > KVM_MEMORY_ATTRIBUTE_PRIVATE is reported when kvm == null even without
> > > kvm_arch_has_private_mem being #defined.
> > 
> > How about this?
> > 
> > Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
> > on kvm_arch_has_private_mem being #defined in anticipation of tracking
> > PRIVATE vs. SHARED state per-guest_memfd, not per-VM (to allow in-place
> > conversion).
> 
> Sorry, maybe I'm stupid. I still don't understand how to connect it to
> tracking PRIVATE vs. SHARED state per-guest_memfd.
> 
> There are two diffs in this patch, and we are talking about the second diff,
> right?

Yes, the second diff is what provides the desired change in behavior.

> If the kvm_supported_mem_attributes() will be used by gmem, I can buy the
> justification. But it won't. At least, it won't after this series.

It's not about gmem using that API, it's about non-gmem using the API when
reporting KVM_CAP_MEMORY_ATTRIBUTES.  Without the change, if KVM supports any
memory attributes, i.e. if KVM_GENERIC_MEMORY_ATTRIBUTES=y, then the below will
*incorrctly* include PRIVATE in the set of memory attributes, because
KVM_CAP_MEMORY_ATTRIBUTES reports what memory attributes are supported via the
VM-scoped KVM_SET_MEMORY_ATTRIBUTES.

#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
	case KVM_CAP_MEMORY_ATTRIBUTES:
		return kvm_supported_mem_attributes(kvm);
#endif


> 
> > guest_memfd support for memory attributes is expected to be unconditional
> > to avoid yet more macros (all architectures that support guest_memfd are
> > expected to use per-gmem attributes at some point), at which point
> > enumerating support KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory
> > attributes being supported by KVM at-large would result in a system-scope
> 
> s/memory attributes/CONFIG_KVM_VM_MEMORY_ATTRIBUTES/ ?

No.  I mean "memory attributes" as in KVM as a whole entity, i.e. everything
linked into kvm.ko (and kvm-{amd,intel}.ko, supports memory attributes.

> > check (NULL @kvm) over-reporting support on arm64.
> 
> I think arm64 won't define CONFIG_KVM_VM_MEMORY_ATTRIBUTES?

Precisely *because* of this patch.  More at the bottom.

> So it seems to have nothing to do with arm64.
> 
> It matters for x86. After patch 20, CONFIG_KVM_VM_MEMORY_ATTRIBUTES is
> user-configurable. At that time, people can disable
> CONFIG_KVM_SW_PROTECTED_VM, CONFIG_KVM_INTEL_TDX and CONFIG_KVM_AMD_SEV, but
> enable CONFIG_KVM_VM_MEMORY_ATTRIBUTES on x86. 

No, they can't.  KVM_VM_MEMORY_ATTRIBUTES depends on one of those three being
enabled.  What am I missing?

config KVM_VM_MEMORY_ATTRIBUTES
	bool "Enable per-VM PRIVATE vs. SHARED attributes (for CoCo VMs)"
	depends on KVM_SW_PROTECTED_VM || KVM_INTEL_TDX || KVM_AMD_SEV  <======

> In this case, kvm_supported_mem_attributes() reports
> KVM_MEMORY_ATTRIBUTE_PRIVATE for system-scope query which is totally wrong. I
> think this is the case we want to prevent not something won't happen for
> arm64?

Well, yeah, because of patches like this one.  That's the whole point.  Without
this change, kvm_supports_private_mem() would be reachable if and only if
KVM_VM_MEMORY_ATTRIBUTES=y, which would prevent burying that Kconfig in x86 and
would prevent arm64 from enabling the PRIVATE memory attribute in guest_memfd.

