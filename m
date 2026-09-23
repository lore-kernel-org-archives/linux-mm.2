Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F679C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC7256B008C; Wed, 23 Sep 2026 11:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F876B0092; Wed, 23 Sep 2026 11:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4746B0093; Wed, 23 Sep 2026 11:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 770EA6B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:21:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B621A031B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:21:20 +0000 (UTC)
X-FDA: 85245390720.02.B5EE951
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3E34C140007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:21:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pp+iDLvj;
	spf=pass (imf23.hostedemail.com: domain of smostafa@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790176878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EE5PAnd1Wf6p3SmBC2optXiNbJWsLePJtC5K69fq2H0=;
	b=v+jrvLrUayzldC4sdNt4m0M+SLg3b0BcFe6VeXCLtIM/RgItojfbjCQKKsj5/05NR4+tOE
	kszEYBCODQQ36SoOGw2yUv2WlPIoEcehdAkXkLhmhGkw/4Q1b63XR5afTLA0L+LKmSvesG
	8LEhYmXlIpM7YC7iNqjx2i5s1CBB4qc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pp+iDLvj;
	spf=pass (imf23.hostedemail.com: domain of smostafa@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790176878;
	b=G8vqMJRTulP+RF02jw51SWukSbLvXAR9v1VDdG/AR0L6jKAsiG+KJCh+ImCOi4YCUfF/LS
	1FyqHOcF8bDOEnwOY158hGlKaT/XI7Leq3Kn9TgX13FMHXaC1NI9/TgQgPbgdzcMG/nMOX
	CTiaNNwagPHOa11ERsuJxd76llTy+as=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-498012a61f6so45705e9.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790176877; x=1790781677; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EE5PAnd1Wf6p3SmBC2optXiNbJWsLePJtC5K69fq2H0=;
        b=pp+iDLvjk6nL/UnFskU1waOuPTMesbPS2naFAuIB+c44o04UjpF/LVO0hDr30bJoNm
         oxPk6tVMbLqmhPZ+UsN5Q9sh/4KLy0laa7cuPha144qsssHfbVILb15o+qc+/VZ1DY2l
         9ItnPg80MrGbSQ0hbULKdMqy1PWTIC8POAxEuiPiuyQY3z6l/+YUuDpN72IB65jt8Df0
         HFgb5fiVHMj7eDMXV5SH+05yJmrwWFJ5aKWy5f3mTvjluQBCSJqcUmfthZOHkj6jZjAW
         RjElj9ztz2zck+0COn/I5OJkidEaXY6+e0cUG52J3rNEqWaLWtnhk7drjQmXNDIVUYbe
         2RnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790176877; x=1790781677;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EE5PAnd1Wf6p3SmBC2optXiNbJWsLePJtC5K69fq2H0=;
        b=G5j8ezuJ7S/F6hh8FKbSPz7lh9PlPL+kQL7j/BkQHkP+J4QSkDjUHvt5S4XVWzWaR6
         9K7T8thJ2vIjGyrP7+rCWdmMvWNrkYqzNjYWE/tr0KzvZoVfK7/E/XLuvr6U3XPsNJkf
         tQOiBohfibx5ome8HM+sAFEcVGnYPDJOQdLDr/Yj5NsnxCvZoNazWb7wX/msdZXuH0Ne
         zsLnUCLTMA4IZSa25dbfWOLbliEgzXXopCzodzjQjreL5fo/xjNUFabzwUcP+vXd1XNE
         Q2XPqgR6C/tNqguWdkvo/kqgxeKhYgny2WH3pZcel+VhKjaDVkhojbEwrrvlhCtgEMSs
         4VNQ==
X-Forwarded-Encrypted: i=1; AKwUvBxj5EH2Rc1R2Y8iEmGORx4s7RAT12UK9vMHY3LDV65IcipPCRemVLaB9j4ORO4ijmtai+5cNI5w0g==@kvack.org
X-Gm-Message-State: AFuF++mHPbMFRkEzYRxWAiRhWzksabKNdA9FCEToHyi3k46uDlu8Ggxp
	2ugvQfb48RHJMc39yh0rUYg5zPT+roJ6zepw+rNxUHzjU8W/KGbSUN5PbUYany8ZoQ==
X-Gm-Gg: AYBFou3tqUsSf4zNBfI9k+kTXwquUXuiwIQahFcFg+iZYlvshiqWuw39a06ijF2hffb
	+gn+/slrdA5HCJBcJI7GjdZcXCTlFVhuQGCT99YGTiJyCAB1hjHdP67yM0UijXaor+v25jpKJHo
	GMIb4vEiYq3BVJPUZV9Wk6kVgOzEGH7HWdhfSZKRREK8PMV6byAQFhwhGwKzOStYNB58KzWRqfT
	ArDQdqEXKSTNmD1k0IAPASBbGZ+2Y5HF34bHD4rCkqVetPVtHiDy3PD08e43PA1/Z5rAk4Y6yDZ
	0e14yec7tWRCBWPY+wmjAV15fSAHgxoNEO+Mp+WVCZ/bampzY7X8kOak8mO7QUY11kIQA0QeuwR
	d2sZXL13ZtFGidOqyjIGb0aJfSJ84wyRhP4dvDaG1iOp5IubRBHsGy03zZAET5lz5apSPSFLRE3
	xDUneZCpnEOgOFHuTX+tts/6Pi6LKL+JEiPWNriJf3ayP9tNLYXAA2fNHk103VArkDHPIKSnVFX
	BowVKjZJEcj+Fa9ZqEUAFbFKhFteTVnKYTqRASk
X-Received: by 2002:a05:600c:4e8f:b0:49f:e1d3:fe03 with SMTP id 5b1f17b1804b1-49fe586ff32mr27765e9.3.1790176875531;
        Wed, 23 Sep 2026 08:21:15 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe0c3ed96sm1697075e9.2.2026.09.23.08.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 08:21:13 -0700 (PDT)
Date: Wed, 23 Sep 2026 15:20:43 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Message-ID: <arPuS9FXrkYJhbiA@google.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com>
 <yq5aik3w344o.fsf@kernel.org>
 <arOfD6syXOgQhZYA@arm.com>
 <20260923130031.GE1540250@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923130031.GE1540250@ziepe.ca>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3E34C140007
X-Stat-Signature: mt4sct9bkhgs3ijm6ib11qp7rkykigrn
X-HE-Tag: 1790176878-231919
X-HE-Meta: U2FsdGVkX1/ou61HwB0+/vCPCi69NUaFC2bC40rKyeDAvEU8/29Ej7yWwhnDot7QfAuzWx97/yzujJ65b5QwsFSH+56MpirHD34+hccfRzjzKXMT5Fb/e8JV63m7jGcPPR9450/ZJJi4BVzsHVBRrbK19rSu23sjsFfDAU92Cck29fdwppWxoGQCi7SdfuiAhh1ccOA4YXi6O8OF4hvuyHRr4m0xbR7jaYnZSivldUN9isVu7Y70LutSfXnFrfuK63s6qyNz6Y1QDwSdzgNYevFVHuKR/XGwr4yEW0x1P7pgixYkJb0PLckE17CAqBIhXHYvDOO5kvx8fGZNhEkmGYYZuGXniG84FCqdpl1bXL+kzDKomlvv1MGKPc6Gu91wYqBcYQTDNvuYUWM5ZxeoiOAjjOrY3hlGpALAC7kaccJnFZaP3wX/x+7UTxBmDrRSR8qBQ8U8yTdzwoQOU2EeiHlOKSeKokktkZ3PkMCXDR33HrigBTXBZBSF/p+SXWQqa2LF1vQ+QM2ACa5OguvSf5FfQI5VrDACAuhNmqQc+wRBWgNoEbrHjjdm/pgIBfUO2unrpph9/Gnnth3d647Ftl+doYFg5K9BuXRWUUOJhpNLq8KRcFMTNXfeqj21Cz8lKwRl4IcHo9OvPQCq8hW7x33ww+GV4QtNaQ3IMG0mmn7WTsFp++DTXiKbVFRyBsyxhNsvg0+J6WueRjZ71whxgpu/ooLD5mdG3oLEyZ+r1k6B0eF553egWK8QJf2KfklJvFM/tdIqGWC/QU8u3yz+WCyvqrY+zhhfHJjTRtZb4VQhAN2PZ3iydeRSaQRw/tMljOhot0vg8ev2ntLAJEKCmrYxPdWKkkl+LTgJ4SDSluSgjbYJYMesDAnA4xaniamq1X3r9ZmCyte4auHug4KKaXGHS+DHw8qyCoNsTISdM6vrR0DgG+e4nanbmkaR4UT0EYbf7Em67oCh29ZHX+w
 NGus9EqP
 fC2W4O9WVZjqTcSl+1bt719bKGuZWvQkwPXo0GlSCY7sxuyyda0z3fHqn9jlmCCrpp2c+D5zbxQJhpNpC6x8nsRkujt/501SEGOzS87srjGJqcWbDFL1yE7uoMpWUsA38LYWpDu6rjZMfeTGgmvpNx2OSesAHzks6mrQyjJY0P4zPSmQWf6kbTqGt7N9hnag6JyHDw/w27Ynh+NLV3zufVu2GXjY35DZWY+oLkecaQaUSL3Bql+T6rugM4keMJKncJaEaOGmfoskAErY3YaaxbZ3AFVMTC71+lqESmUkTg36MlZ1CGhhaWwGAtaYbI1M+vlGYSM/aUXaCglLRM1n40Lle9B3ZB8MuaNiv89YzMWOAKhI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 10:00:31AM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 23, 2026 at 10:42:39AM +0100, Catalin Marinas wrote:
> 
> > On pKVM, we want set_memory_decrypted() to zero the buffer
> > before the host can access it (I guess currently relying on __GFP_ZERO
> > allocations). Since no cryptographic encryption takes place, there's not
> > much point in memset'ing again after the operation as the content was
> > already zeroed.
> 
> It sounds like this a pkvm unique thing, since RMM always makes the
> memory hidden, pkvm flow should do it too. Either inside its guest
> set_memory_decrypted() or inside the hypervisor like RMM.
> 

pKVM doesn't clear memory on sharing (see __pkvm_guest_share_host()),
and that is not a documented behaviour for ARM_SMCCC_KVM_FUNC_MEM_SHARE
(see Documentation/virt/kvm/arm/hypercalls.rst) which implements
set_memory_decrypted().

The guest is definitely the one knowing what is inside the pages and
whether it can be shared or not.
For example, a while ago I was experimenting with inline decryption
to avoid bouncing, and I imagine it might be used to build on in the
future.
Also as these hypercalls are ABI, I'd argue we shouldn't change their
semantics.


> Hypervisor doing it is the right place, hypervisor always needs to
> ensure guest memory is cleansed whenever the guest gives it up. Either
> via a private to shared, unmap or just exiting.
> 

"gives it up" is different than sharing, for example:
- When the guest dies pKVM will zero the memory before returning it
  back to the host.
- At the moment the guest can not relinquish memory (ballooning) but
  that is supported in Android which can zero the page.

Thanks,
Mostafa

> > I don't think cc_make_shared() has the right information on how to
> > safely and efficiently do the zeroing. That's only known to the
> > set_memory_* backend. So you'd have to propagate the flag down.
> 
> +1
> 
> Jason
> 

