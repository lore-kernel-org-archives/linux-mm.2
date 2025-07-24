Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 201ADC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 22:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4BB96B01F9; Thu, 24 Jul 2025 18:33:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF56A6B01FA; Thu, 24 Jul 2025 18:33:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E4676B01FB; Thu, 24 Jul 2025 18:33:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8BB1C6B01F9
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:33:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41F4BC055E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:33:41 +0000 (UTC)
X-FDA: 83700611442.04.1F95C71
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf12.hostedemail.com (Postfix) with ESMTP id 83C8C40003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:33:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sj9VJX3q;
	spf=pass (imf12.hostedemail.com: domain of 3wrSCaAYKCIExjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3wrSCaAYKCIExjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753396419; a=rsa-sha256;
	cv=none;
	b=RXawqt+V+EYPdF7ocX3boTkChZZd2DH0nhjBa5fFrpfsYJAXzYPrNEZNdhJQhQ/cRmyCJ6
	MYTagzjiWCVdUWH873E1xxkiuqG1BYOpEbKWXDO7D8a1jnvUzpRmm8tBLWf+6oUVnfBuAm
	u2XvcAefJ6NZmYMTlxvEsfRXg369u/0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sj9VJX3q;
	spf=pass (imf12.hostedemail.com: domain of 3wrSCaAYKCIExjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3wrSCaAYKCIExjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753396419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=inLy5vcBNILr3/MOBz76JuwhCqWg6KJsocdJKuHsHow=;
	b=4PixnbiLXZoWNdHYKApPMAgDCVZkBeQpMJiXYXzS72XNUcY6c8nMarC/TB7kv0MH64RlXb
	40kWwlKjdXmEd0z42yxL0PvUc1ZI2S3TmM+zsJZUfMZ3dPsrsDcutXQqfG2NI1jvrz4i5P
	j5BDXgIDH9pB6QVcrcV43HCIXmkFSyo=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311e98ee3fcso2931070a91.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 15:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753396418; x=1754001218; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=inLy5vcBNILr3/MOBz76JuwhCqWg6KJsocdJKuHsHow=;
        b=sj9VJX3ql2CsZp660i0LybkUSChvs5EZCQTttwT2UbSU88GL1zJV0WJWG4GKWZY10P
         0dmcGbi+gf2s9ucXrlftavC7dwXCfJmwdBM0MWKHQ7pRsjiT70l+1bKgS29ejyZu1O9r
         Tdmzg1lPXPQ5DISPysdbMhDtNOA0CMDIHdcqXDeYBU0osoelFYf5+NzgTDnt05L3R73y
         BiYAADSfpoEt3w0/Q0QwPPIm6WuhzQJC7xQr458HSedOdStz15B8QVym26Z3WqeK/bus
         6DPByf7fgxoTuFBBdZxkmRcdP/cyC/y/n4+LrUaPn8uw3i6dk39Ue+4cB/biOsdmNp3c
         gCQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753396418; x=1754001218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=inLy5vcBNILr3/MOBz76JuwhCqWg6KJsocdJKuHsHow=;
        b=DHtk+i4Psj70YO/AdWldGR/vnDpwvit4x6iVk4pddpWXvpg7pRn2o4rSuz5WaOVXWG
         ggecuRNUobZAZojuRsyBk5T+YUxjP9Vw+dRLJFaAUBAVenFjfDvWqIjWRcLSNmc/+NeX
         sIcIne/yYrGBhzDgS61ovysg1+xTNykdVUaWIyQy6DTdbM80ALTzO3qx1HCzdGFTb0cm
         QLngsxpbSof0X9C4/VGp32AV+aGpQTMd6B6Zt4QEFizp4ETtTn3/GqO8SydeFkMePJ43
         /MJag1xEYLnwjBGaOeYDeEHD0RqsTI0i6T3z7WrjBcQJeWtGrYIDssIUkm7lgI+JYBj5
         MZOg==
X-Forwarded-Encrypted: i=1; AJvYcCXQALdN7ZojlhlLWbT4tzGGQP70qVJ9kGiYSM88Z8mLCPqJsz6d3DQRzWRmhZnJpUBRETLfBRzMAQ==@kvack.org
X-Gm-Message-State: AOJu0Yy7CS57wGmK7wn//BhD7aEngdKEUBgWaYVfxqLoyBPAbgxL0BEu
	zUruufh8aqOioBLl0cibb/Drrt/r+6mR0hMuxYUzNbna7vXDmepedvsqN8r+n0WwsOGkGkQKIMF
	rukjvnA==
X-Google-Smtp-Source: AGHT+IE9v+AMqISEN6fUyAdtK8mFeHQvOl0cmpRw928j7ZGnBCeUKwILml7veHgu+g+g3U0uNgaRQdu3bsM=
X-Received: from pjbsy11.prod.google.com ([2002:a17:90b:2d0b:b0:31a:aa02:8c50])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e0b:b0:30a:3e8e:ea30
 with SMTP id 98e67ed59e1d1-31e662e841emr4851203a91.11.1753396418146; Thu, 24
 Jul 2025 15:33:38 -0700 (PDT)
Date: Thu, 24 Jul 2025 15:33:36 -0700
In-Reply-To: <c301ec11-9d24-4cc6-9dc7-46800df4d5a8@intel.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-11-tabba@google.com>
 <c301ec11-9d24-4cc6-9dc7-46800df4d5a8@intel.com>
Message-ID: <aIK0wHgP91XhNEMC@google.com>
Subject: Re: [PATCH v16 10/22] KVM: guest_memfd: Add plumbing to host to map
 guest_memfd pages
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83C8C40003
X-Stat-Signature: ocw8q8tidbb967gt6w6nb14mmr3ea8fd
X-HE-Tag: 1753396419-580405
X-HE-Meta: U2FsdGVkX1/WB735qRdEOYfViMR1KDOIjmJ4yLR3jWHlUhbMFfwfA0ruHNrFb2JvCROXIlzIUgtpGfsJ0N5I6wN7jt8yRHIZUUpBH0WU0qlLE+cHpT8Qrr/Kt6iif+1e8scOdyJyVQqq1Wm+7VvvY/MjBepTwx8b4RIp7UZJj0AO5YPho1LdoBPqwwzySljDtnE1ObLI3XkQ/Cc1RAq+Vhp0a5fxnlF0KWYH8vL7mL/RhY3bEXfBL0NxT+x2VzfaCHO2A9a7yYvlGazmm5RkjGs89U389oHlnWodvN1PKEfYYdGXLj4vWKP7ltkF/ugJHW1xwRic9pAMa8LFiDW5gcstX6HAbpVNUD2w2ry8B96pkEbDMmKv7Ee/TJhJd2Ib6Hl/AGh8L2p8cOMT/uS9E0PlguHkloZsqYfQC0ec2tWsGMICVxmUKXsVsc/RgYsUQwPZsNeIAD0zxGKC1q2pE+HCQjt1NE2iJmiwskgj+ykr1UdYfDQX0kPoGQS5NJJ9831uHZ4tv5C7nLhSjh1Pbp4xcR/hLHmen7p5HrdDafFnd+uI7nvULLVbLec7KSCVAjHBB8nJWQrN2OofvvgghvNa/slmtstRBjuZervcDc2T608SLvlrCGv57Y6vgnavme12hfoWOHD4xmKs9pQr59nKXBeFy2JaNUMitGSZmS0sX+thMdsffkbOCAaw7qVCSrr2oprmJP5jxhL2vHzwF73rGJXN0Ri9xeJsXj6tseVpsKZvow41/nsxkGI7FGkCXhWjbef3sfBet8t8dxBu86t77Shghu6ju4xdjpWCn743p0eEbNFYnPMMkVuhvBNuVwrqjg+IIdNjvolHXGNiUE/RtNdzyD4RQ8rERcBUtCJQBC0bDhHNKPB8NhINz0f86IDyPlvyT1LWjm2mDL4OkwqYqOvT51xBCrb2+1TtqLe7tbWisfSlpqlekzR1SWawMpMnRfQNJTHHJu2bEc0
 tbl8tBAV
 X3xmEaU8c3uk/0VuyVBdcie0cOObYV4BtumxLuE0wfLvBjBkD5keN1uLxnUBZyfnj85O5q5+ae8qkeKECS1Ha5b0YdzjToX0WybbVXN3eOJU67h401QasdXiO4BXdzLW6zOgVO74EWUXBqFXvKvlQZ0HpoVPBjrg/3PLbxWEJURLjRjOKkXDChbTiXfs6zF0h5yiIYamrqdlodMJJYmu19yksya16ij8Sd7j+f3EP7q5fbqK5exFUWMDS1Art7tBPJDuvSHtSuYiiLk21YTWKR3Ug7tDj5NXN1bUSnNtyyIrWZyPRT5N/Se1ZKbz9xEINd0QuBoomDSE+Rq/HiqhrIg5i2yrjU6g5P3sYrXsyFEbkz3BCqI1rUGyxgqKUmUyg1CQczmA7DWZkU0JBGcQrty0IzEiIRfO15SCyCFi7V0kaJjjnhbnX49iZ2211Trl9qOtHy5cQhKUx2RlUQBLee3z4TAwv1MdHR+/bGqJ+aeF3EiG+/IpVPCfwaby8Oo6Ap8G632IybvipvgeAePt8/1nWWG8eppJGWRfkpxQFuDpLo8k+UjHgzhV9TMCXDyjcYwI3gVRfQKe29A1vTTyaoDyv48YC8myhWyHmv6glsubF8eayN51Y2omrAw1+oxr/hHFULoaUbtUJkjV1s1qDq06j/SvcXR+yqmGap9NMgc0YSaMsd95bnBayZC4L+mbgh2rWGda9XUxTuvQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025, Xiaoyao Li wrote:
> On 7/23/2025 6:47 PM, Fuad Tabba wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index a1c49bc681c4..e5cd54ba1eaa 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -13518,6 +13518,16 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
> >   }
> >   EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
> > +#ifdef CONFIG_KVM_GUEST_MEMFD
> > +/*
> > + * KVM doesn't yet support mmap() on guest_memfd for VMs with private memory
> > + * (the private vs. shared tracking needs to be moved into guest_memfd).
> > + */
> > +bool kvm_arch_supports_gmem_mmap(struct kvm *kvm)
> > +{
> > +	return !kvm_arch_has_private_mem(kvm);
> > +}
> > +
> 
> I think it's better to move the kvm_arch_supports_gmem_mmap() stuff to patch
> 20. Because we don't know how kvm_arch_supports_gmem_mmap() is going to be
> used unitll that patch.

No strong preference on my end.

