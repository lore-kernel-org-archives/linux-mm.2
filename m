Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87035FD45EB
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 20:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE3C6B0088; Wed, 25 Feb 2026 15:11:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B950E6B0089; Wed, 25 Feb 2026 15:11:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76FF6B008A; Wed, 25 Feb 2026 15:11:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 953A86B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:11:36 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF513C2710
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:11:35 +0000 (UTC)
X-FDA: 84484074150.10.25B0FB9
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf08.hostedemail.com (Postfix) with ESMTP id 30140160009
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:11:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RiKqQ1Vc;
	spf=pass (imf08.hostedemail.com: domain of 3dFefaQYKCPMnZVieXbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3dFefaQYKCPMnZVieXbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772050294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l12W4BbMOvS46dH8NvG0bfSFtU9wMtIxMN8ZzhevNqI=;
	b=s+qKLafAZX/koa5tGZ9RWHVs+YIKnYpkoAabkbRDVjnyU3inopdtzyt0Jtm1f48fyoRKv6
	JfGFSxWMoC+QUDabWSioQ4Mnqf9AxLsnMIOxeBEpX/+paoq2VSz5rx2TSOx9xPnELIqlDv
	V1Rw2eL64QXvm3euioNtBXHaoKLlyRs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772050294; a=rsa-sha256;
	cv=none;
	b=p6Qv7whyhXTbMD7DvowgrykE2SKh1l5oVdsFbZDov/8cqKR0BFd3nBOm/TmFTeK4iq30WV
	BRCZFvQebx1N6obGQF4meialv+mShFReiyn38DpsHOE7wgzEqNyNmtEc+rTwvF5q0fslBd
	WAwgTpUGKPOo+yEAIU1x8IZe7DK0y0E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RiKqQ1Vc;
	spf=pass (imf08.hostedemail.com: domain of 3dFefaQYKCPMnZVieXbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3dFefaQYKCPMnZVieXbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2adb085735bso324715ad.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772050293; x=1772655093; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l12W4BbMOvS46dH8NvG0bfSFtU9wMtIxMN8ZzhevNqI=;
        b=RiKqQ1VcJ2s7L9adW41pr+Jj8v/rPthTf2fR+0okgwNc8YcHLMAFoUcddzMZjM/Vqw
         s+5A/hPCBEvdR8AAp7OhV6VFnmr/h8NeD8mL+5zyLsF7gZvbz0DlAaxmzonuPFfICfqR
         L8L+BVnC/HlQy3k5M8DBrmQuxLNU4WrPkMEUH5gYUgifz41JI7rUv/VhjYOhf0poTH2Y
         yFBX95V9uvwRI1pcmg8Hmg2VEQgBvbsgoTfW9JOfq00Ah5NeWShZsM9wth3jQ0uP++W1
         bBEAFXjJN+QUPAnVy3a8EUjNxaMMJBXSfYukURldkkuMBC62P16iVH6+VU/Llc06CvpH
         6DlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772050293; x=1772655093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l12W4BbMOvS46dH8NvG0bfSFtU9wMtIxMN8ZzhevNqI=;
        b=GYo6FcVnRroy1fC6ofqrwjCecfRNvnb8ykuQPlkvwN/Xk+t+4zA5LSrj3I4OVMnREv
         RjBL6LXkkRAAcjhFTtEs08/jCaUeAGgoHAl7gfK25KGTRrftuF59RjoaMBeP9Isc7G1S
         WAgPy9QBskvM3gPPMp90nvmIQ+WBkKqcbP939kpNzHjCfCQfje5PCsblJtCNDVO9qf/r
         avFJ2Y6AFCTLm8e+v+MyGa1vjw++876l+246RzMJX7Z/K+mk5jk0p3N/qP8BplMZq8nc
         0uGAYAOhbx0jNLxYGDUiXUxwsMtzP+frVlDmY+3JmVeL7zOPzQ0+O/VX3yCv+EiBLjwz
         sLNA==
X-Forwarded-Encrypted: i=1; AJvYcCW2eApUM8oOAz7UUF6A4Ba7DKMuetq6499wAWjOixF2P//v22u1MlSTqhtiL/2iXgUYWhd9vtwNGQ==@kvack.org
X-Gm-Message-State: AOJu0Yz/hZb/DXL/CIf8co2ZC7+Giz/U4GE+TN2cDsuwJyyHODDuogH3
	t2dOcX8MAhjBXx7VYc7m0JscZW78T3RsyYP4tLXnfW2MYq8oDzQBJbGqxyjYrXuNZdzdQyKladU
	buIyY2g==
X-Received: from pghq22.prod.google.com ([2002:a63:e216:0:b0:c6e:700a:2902])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:72a3:b0:371:53a7:a4aa
 with SMTP id adf61e73a8af0-39545ebb5a6mr14949603637.29.1772050292456; Wed, 25
 Feb 2026 12:11:32 -0800 (PST)
Date: Wed, 25 Feb 2026 12:11:30 -0800
In-Reply-To: <20260202074557.16544-4-lance.yang@linux.dev>
Mime-Version: 1.0
References: <20260202074557.16544-1-lance.yang@linux.dev> <20260202074557.16544-4-lance.yang@linux.dev>
Message-ID: <aZ9Xcgxa0_ouGr31@google.com>
Subject: Re: [PATCH v4 3/3] x86/tlb: add architecture-specific TLB IPI
 optimization support
From: Sean Christopherson <seanjc@google.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com, 
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com, 
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com, 
	peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	x86@kernel.org, hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com, 
	pbonzini@redhat.com, boris.ostrovsky@oracle.com, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ioworker0@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam09
X-Stat-Signature: 1omfcujwsskoh1pdmjfinzypn4ggh3j3
X-Rspamd-Queue-Id: 30140160009
X-Rspam-User: 
X-HE-Tag: 1772050293-569502
X-HE-Meta: U2FsdGVkX18Gxs1zZ438Sal1XKeyv7Ivuz79iCK94NEw2Y6w5AmhkEvIN5UBrq78bWHieKS1ALotM9M3W336DYm/udFmiggPQhpga+YWgPhmTOa/SnfxclTQukNo/4cVj9WjFJwPWUDhD4qtnbr092OKTY2YOMcTaFMmptwfKAvAb7pLqWXMhqTz3gCtaYn60OtidmQJJOCFyoU4Bi7DtHDV+BX6a079tT/KEHHlmwDCVbGZTHIi9KpiPi14k13sQXb8Dz65Q21e9KzChqX3KXLeMwg8zJETn5WTiE7oC0M4KCm7wp6OxEgKBDhWKKjU/imk4T0Iwzyo484ajO5CjacyZigSC2zd717TGAoNkxln946eGesmbCbQ6fTnBYyckpLyueQ0tTjKLA4UbaTVt4pe48OulSxMBadTBaprzP5C4ezWtyuiJ6QnrPXH7jAqr+INpocJnJPyTegralX01FXFnyq04Kj29QbN0fecDFTDvmWiDsvthMfJVHKNkmCw8JUvEhvwMVly40jUcWf+MMbCVbD4vOfJop7BWu6I6c0wdUW7OgzfSvbOZ4tSETn+hYFMULf2qSEEBIkm9bLgqGUO1YcFdSwMtNa/GOCCtzs35Ui3VVvXrSUTZNGpB0NIsHBW0XeSrCkodn2tD6B3Puz0IVlB0VixfbiwH+Av4s/F/EAFpudpo04T4aRCfPTZncvjHKujmmgzXnNimGDDmotpjdo9t1LxxS5BzTUb02RKg+1AST9Z6gvorID+3zgGlhAfB7U/bdRwxtBYTIpY/tYD03MkZkIHIGS4eOwxyRSePKjL/IGKKwxdTk4uFwJULHKEvOd00YMIhHuO88thPQnE7b9E2D83p+H/qpIO5Qh8hE8Ceb5unJRfQEDZ4HRaS7FrDdag/yeLpFDcWHt7fK6A+SoLcQSqLLq3Q+k36b/J2U17AFNdgemZHAb9H5HnTtAjaJ51XFwqH+vtEcy
 XE6vLqaP
 D8X4gTQnKPHP1tXFxdjgJWNCy5NBmyEotE3xAdxQuA3CAgolhqKX67bb4oOpPinbF5I8WY2Kn/HGR3oUZcSL/FHcFG79gF+b/grs+zX828CXz/LFVbjBhTOtEtqaM1JJgaPrcGLH5eepzMV5InZ16v8zcwq3YBDx9yEvpUaW+Wp5u4Grp9kHZAPN2+nqh5WVV00GOnqJrlJMnB7qpw0RI34JIxSyPqikOwG7o6k9/nOmMy1OqpYss3U490IA2hBUZ99qz1m3N2AJ+bamkWkZ0JPpc/DQkj2JO9zjrD4pwB+kZYJQdrUtb+6YiiMeB6No6aqzNnH05OxY6rRtq+/wNhdAEVyLjYD5X3Z8RUYCxqcXAzrjzXfibmQDLp5EktrfZFjfRV5byQpl/YCD871ePDYAArraEPX8ZhnSBQz7G/q2ExZ8q8gqm9U6hiKvparxlVUFjOtqOhO9n7DESiAArf56dKjCrhPqiA5WOE56Mxe3mFfHcdRg0NQlBeZi7hZAVECACbvUQyR3dOCr0JPwMNjVtkvcRaXk+v3Il76q7qRw8LUYaNRyjBYSq7RiExXfKpFzxaw8KAabGvBzEpwGu5aDqecsEUL5Ej47a1Xs52/bgLUXvm+Eg9eKuz1pFEpVZKi8yaUswgTw2u/LYK2yaSVqLlMW3Ep5wvLxkt+4pSM7RcSo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026, Lance Yang wrote:
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 37dc8465e0f5..6a5e47ee4eb6 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -856,6 +856,12 @@ static void __init kvm_guest_init(void)
>  #ifdef CONFIG_SMP
>  	if (pv_tlb_flush_supported()) {
>  		pv_ops.mmu.flush_tlb_multi = kvm_flush_tlb_multi;
> +		/*
> +		 * KVM's flush implementation calls native_flush_tlb_multi(),
> +		 * which sends real IPIs when INVLPGB is not available.

Not on all (virtual) CPUs.  The entire point of KVM's PV TLB flush is to elide
the IPIs.  If a vCPU was scheduled out by the host, the guest sets a flag and
relies on the host to flush the TLB on behalf of the guest prior to the next
VM-Enter.

	for_each_cpu(cpu, flushmask) {
		/*
		 * The local vCPU is never preempted, so we do not explicitly
		 * skip check for local vCPU - it will never be cleared from
		 * flushmask.
		 */
		src = &per_cpu(steal_time, cpu);
		state = READ_ONCE(src->preempted);
		if ((state & KVM_VCPU_PREEMPTED)) {
			if (try_cmpxchg(&src->preempted, &state,
					state | KVM_VCPU_FLUSH_TLB))
				__cpumask_clear_cpu(cpu, flushmask);  <=== removes CPU from the IPI set
		}
	}

	native_flush_tlb_multi(flushmask, info);

> +		if (!cpu_feature_enabled(X86_FEATURE_INVLPGB))
> +			pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
>  		pr_info("KVM setup pv remote TLB flush\n");
>  	}

