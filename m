Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EBB0D46626
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 21:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78A9B6B00E2; Thu, 15 Jan 2026 16:07:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741876B00E3; Thu, 15 Jan 2026 16:07:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661FA6B00E5; Thu, 15 Jan 2026 16:07:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 54C9D6B00E2
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:07:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF9D38BBCD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:07:52 +0000 (UTC)
X-FDA: 84335435184.17.D101669
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id 43A09A0012
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:07:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sfiK0CIJ;
	spf=pass (imf25.hostedemail.com: domain of 3JVdpaQYKCMo8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3JVdpaQYKCMo8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768511271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+q0zy3rt0+W46s/KLmj4uNeydBrbpj2ej0hXrXM1xwo=;
	b=3+VPY2BUV4EL9msMjNqCfmeVD3HQH2apRu6WfPmPJljRZam0fyoxA1pPQeuOz0uCHP8x9h
	hh+rb9jRL+bRI41oO3hsDkMnLza61e6YMW0yBpTam5t6tFQXA0OirJSdK3anr1yzzl6wCO
	feR3yTknCbKxgNCMl4ru2uEEyASbZVA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sfiK0CIJ;
	spf=pass (imf25.hostedemail.com: domain of 3JVdpaQYKCMo8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3JVdpaQYKCMo8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768511271; a=rsa-sha256;
	cv=none;
	b=t0v+88NugcbHXY0fAKUgyuk39/eI6J2Ah1o7BhQ95BTSZIe2Zs3O98K0F95HlgHvvqNr+a
	PDJQ3PB1fZYsaeQaGkRxsOnITiNQu2KRw2ajNMq0yhEI6HnhJOujrIrXheOTRizrKGltls
	LNSvmi71ge55sX4KYs9Ikya8HZoXuOw=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29f25e494c2so14048615ad.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768511270; x=1769116070; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+q0zy3rt0+W46s/KLmj4uNeydBrbpj2ej0hXrXM1xwo=;
        b=sfiK0CIJThbKBTMBsJNPRlVzhgM0YkUKnE6Hm+N65LpvwpmQCaaGA0o3EYpDJNNDdA
         +7DS6LTHj3s2KH5Tdn8LnS0471nm2PB3rUYts0xg4e8RhBA7ekK1t2yLAz85e6pXL0Yr
         etByeh+PY1AU/1EkwUY45Z4LsVGqlMatUJxkskukgrf8iiy4eO+yW/Emry97JWpMpd/P
         w4rsPtDkwfmSzS81GDNVPzingvrd811riUATLPoiM3NNgIb32m4RnGjljpkue053r7nW
         0PezzCrB0nbQaCIAYIPRwV/+0PasHDj24Vm1C387P2fHDvuvS5c4shix5VwKztinfupO
         hOLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768511270; x=1769116070;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+q0zy3rt0+W46s/KLmj4uNeydBrbpj2ej0hXrXM1xwo=;
        b=Guf9NJaRxMOkL7upj2HdtbEog0t08g/4CwptJOy/tZfC0Ls7IsAVAE8DywKKpbzl9a
         sJcQky87XZwhmpxSBr2X7Jnasmd5a3Y65FQ11Ubkb8KTQ5YXdozNXWyVsTaNwxNgoZ7N
         3qG8ap1YLhs4OFglJDjGrM2jrQj371kmKSeZXpERn7hu2A0A78RGoVLXrVk4AdBb40sR
         wkHMbM52TNBX628Et+ZnIajIxpGTS7MdSzS9SWgCcANgloXifbOTjiWcx/038A8RwfLz
         zRREJn6Xmmm7idZDet+/hZyJn7rOCVwB5Q0Z3EKEdDYtGzLD01+J8hLumzh8zJnUBOrQ
         bPtQ==
X-Forwarded-Encrypted: i=1; AJvYcCX21qDfToKh8BY5Pzc03B02ruIee1flH3YRQfqKL71YzCdmEykoBq/3PT74q8T+vAHrROlr/lLxdQ==@kvack.org
X-Gm-Message-State: AOJu0YxzPKOI3TACXNR7aWKl2m7PlGIAnv0E60mhw/02EItq/vE71069
	3QTxTiH1LyCPjeB0hfa9tLPeHH8WpCebAQsvFcFyFwC69igVQPKNxDNgxWPXCJH/kx6YDtobN7+
	kMDHajg==
X-Received: from plch3.prod.google.com ([2002:a17:902:f2c3:b0:2a3:e3b:89b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2c08:b0:2a0:c92e:a378
 with SMTP id d9443c01a7336-2a71756b899mr7431015ad.7.1768511269740; Thu, 15
 Jan 2026 13:07:49 -0800 (PST)
Date: Thu, 15 Jan 2026 13:07:47 -0800
In-Reply-To: <176849903000.720660.2401438098975748028.b4-ty@google.com>
Mime-Version: 1.0
References: <20260108214622.1084057-1-michael.roth@amd.com> <176849903000.720660.2401438098975748028.b4-ty@google.com>
Message-ID: <aWlXI3F6AyokM23l@google.com>
Subject: Re: [PATCH v3 0/6] KVM: guest_memfd: Rework preparation/population
 flows in prep for in-place conversion
From: Sean Christopherson <seanjc@google.com>
To: kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	vbabka@suse.cz, ashish.kalra@amd.com, liam.merwick@oracle.com, 
	vannapurve@google.com, ackerleytng@google.com, aik@amd.com, 
	ira.weiny@intel.com, yan.y.zhao@intel.com, pankaj.gupta@amd.com, 
	David Hildenbrand <david@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 43A09A0012
X-Stat-Signature: uacpufrog34uozssatm8gso1tg9o9ao8
X-HE-Tag: 1768511271-277474
X-HE-Meta: U2FsdGVkX1/xw6U42PXVll5rEuB1aHOHs/jB4JjAbHyNlRwk1xOeMiR2Mrk4S6HU5CefPtRiwURWKA81aKwH2LqJJvAhbEj+YM88DfvwdRwW4otB0qoazpb3WP27LV64lWA9D94iP4F985QQPy0F6EXu+RLUCvQlvWfkRjJGi77Q8hjCMURsBuaddncmbyafnPCUy8kxef+xNzEn4URAMif3Jq1pwAtqmClpTlsXC8l+nv1nmeEz8R8RGOh2swiY2bk5tn3WYpRKYM7SYOAO/Jmfh8RFEdS7uaydJCgADVAk+ZcWqiG2FCztyYaESMnTsxTwXmZKMfzL1DUjqj1HMz1CZrpG783aHBYy6qyeikWF0CofXKGEIj/H4xyTGbYC9sEQDjRqWtN43WZetMEbdVUiPfLuCvOg5u2WjLaN1YGuNSkBF9Tkz/43Y23+Jz+wnYbEDou/UHr3KTTnIlAwqXJxdiIi7xnPWbf8WosTNUT5CXtBmqdy11j0TD3h3uD4fM0GaIycsk+rFNdM1Ybk5KomU6ZuNQFRyY/g5GRV4UWH4wcjDWN2dxG7UYkKSj9tnff/ApwEaJkG7Zna/SaZMYrEcsCf/Z/sacX3Ar9CU1bbsVYSXq5ixLzadGYhhammqIi2eAIC2iOdc6pzvCRv+AKnULsrzYjkicM0pj/B1PJPXAmbt4rniUr5zy0+7J4vVV+H5MTxStUlLkln12FIJH05SMSunuZp1KoG/G720jPE2jfdWYYMEUbHpLUXyh28W9PGkxjV1BoOlYXP4OZZ5/xZHuPcRewXny7tvlbdp9ZON3UBVnNeRAvV8WJE5AjmJzoiXS2NaA29k7yDUGKxXTdeKWs3VtSoPySOqMJNHxnS+L8q5ePo+NEe+N79sZpBSuhxno25x+1Bbdq9WC4PcM1k4CwLXcpcfyUSggqOicIz7zjLIIVb+DNu0H+/ICqK7ePD6z0HZaQJvVRHuDp
 iJqVC+28
 EvT/85sH7Jql8bjmkE7HB0JdlNlht128n3RWlIo6FhnGUfiv7uOXZVPjyIX55X5eoo8Wp9zNNFsdyiCLOafrwEZOCHKK9ZPWVJN7rTbi/IxrsdUcph+mwBkGjeFNRdI/pnpNVGE6IBnvrQrNFeSu2Aio1reNcOcG4b19927dlFFk5hNqHnXeA/priULxuF3eh6EOkCfB/PjG8lQxi0aTIy/+7D40sjenLLk+MxtldWzqR9sZ8wRYGvN+AfifYi//Qy5EkIRY8CxJ8NKwb1zIQU8RS2RvUEBwV38ngEI0ejk2w1Ik+fJ/VMylA9JFbV2ZOptAn+s+A1u8HdnxnSVdz4d/ujyrbicbZVD4HLbSbSbYSxsJCGrZNY94FIfnzope3YFZ4D8Rjcq5jPYB9bEDFP9tyUUWKlUAeJ+Bv0o2Coyj7SC3rzRA50YiCwRJA01GPqYY8dweL260/J1FG6QdT3I3e0s6YwrTLVBzsOhSUAnfE0CJB8pOA2rJQ6EIwOr+eK2LeB9RpmLO+JlSAEaITuoMjSija2zlYP248+a+iwsbYgr0KO3W/hgGNksV3rOM+hTujC5VA37uChu/LI8RfqlTl7bPm12xEU466gLR66GszADmbe797LWyIIcu1H7kx32DxHU8onQhP5/dZgKirftyQchSlpINi0QVN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026, Sean Christopherson wrote:
> On Thu, 08 Jan 2026 15:46:16 -0600, Michael Roth wrote:
> > This patchset is also available at:
> > 
> >   https://github.com/AMDESE/linux/tree/gmem-populate-rework-v3
> > 
> > and is based on top of kvm/next (0499add8efd7)
> > 
> > 
> > [...]
> 
> Applied to kvm-x86 gmem, with the tweaked logic I suggested.  Thanks!
> 
> [1/6] KVM: SVM: Fix a missing kunmap_local() in sev_gmem_post_populate()
>       https://github.com/kvm-x86/linux/commit/60b590de8b30
> [2/6] KVM: guest_memfd: Remove partial hugepage handling from kvm_gmem_populate()
>       https://github.com/kvm-x86/linux/commit/0726d3e164f1
> [3/6] KVM: guest_memfd: Remove preparation tracking
>       https://github.com/kvm-x86/linux/commit/188349ceb0f0
> [4/6] KVM: SEV: Document/enforce page-alignment for KVM_SEV_SNP_LAUNCH_UPDATE
>       https://github.com/kvm-x86/linux/commit/b2e648758038
> [5/6] KVM: TDX: Document alignment requirements for KVM_TDX_INIT_MEM_REGION
>       https://github.com/kvm-x86/linux/commit/894c3cc35b89
> [6/6] KVM: guest_memfd: GUP source pages prior to populating guest memory
>       https://github.com/kvm-x86/linux/commit/ba375af3d04d

New hashes after fixing the IS_ERR() goof:

[1/6] KVM: SVM: Fix a missing kunmap_local() in sev_gmem_post_populate()
      https://github.com/kvm-x86/linux/commit/60b590de8b30
[2/6] KVM: guest_memfd: Remove partial hugepage handling from kvm_gmem_populate()
      https://github.com/kvm-x86/linux/commit/6538b6221cc2
[3/6] KVM: guest_memfd: Remove preparation tracking
      https://github.com/kvm-x86/linux/commit/8622ef05709f
[4/6] KVM: SEV: Document/enforce page-alignment for KVM_SEV_SNP_LAUNCH_UPDATE
      https://github.com/kvm-x86/linux/commit/dcbcc2323c80
[5/6] KVM: TDX: Document alignment requirements for KVM_TDX_INIT_MEM_REGION
      https://github.com/kvm-x86/linux/commit/189fd1b059a9
[6/6] KVM: guest_memfd: GUP source pages prior to populating guest memory
      https://github.com/kvm-x86/linux/commit/2a62345b3052

