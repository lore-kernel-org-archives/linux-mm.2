Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B96B7C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 14:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F6C66B008A; Fri, 25 Jul 2025 10:56:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CEA96B008C; Fri, 25 Jul 2025 10:56:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B716B0095; Fri, 25 Jul 2025 10:56:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 424E56B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:56:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C4A8C1DBA7B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:56:40 +0000 (UTC)
X-FDA: 83703088560.19.D52EE8B
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0A16440016
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:56:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1q7mxd1A;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3JZuDaAYKCLQmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3JZuDaAYKCLQmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753455399; a=rsa-sha256;
	cv=none;
	b=skTUYff+6l5PlnQZQrXCTDwUMTElW6s3epC+AzxTIMhYsoeDE0oL/JM08BDL/xgcF9R8jt
	Ckwq4L+eEIZLfZGcqG00JDBCbh6j43s6M71mkDnYAPwGzUOZFEV1YsP8QzK8LfAJdkYza3
	6S6hiYdNu85gJTjdcjJyQKjEYl8oRxg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1q7mxd1A;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3JZuDaAYKCLQmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3JZuDaAYKCLQmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753455399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M11ZItqJowsXWKLvHpygzI/Vvsnt9QVCd1UdBgcxgdM=;
	b=q/rQFInv3sfSTvs6H1YF+a76PSnbfLhG0lBfVto+tYZ7/wYixVm4bVsrVsUE9Ua/59OnGM
	2kNz2ZKrem/MwJERK/U/Ze7Vk2DfG/FaTo7N/urqgYDtKsHRQ6ZhsZwAR9GQ8whjADR6NM
	HkptVjPvLWQvIoSsI5OMQXx+7GIzctk=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23fba8fd56bso1661535ad.2
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753455398; x=1754060198; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M11ZItqJowsXWKLvHpygzI/Vvsnt9QVCd1UdBgcxgdM=;
        b=1q7mxd1Arjr5eibuNrp0yD7Z5JZ8aS2b5b02YghbpukRzk70jFNwX1gXk7b5qpAhxN
         2Sokplln49gGApnIP+JxomvcujiwYcYRRaANIWArLfUzHyirmCDwgGBCBE9gKOVw7MAD
         ZxoDsyuUbb2csL8c6L/MEJYUj4SCx60DMl/OypU0VCRRfTnsiUqsJXc1a2S6zZOcVSTZ
         HyRbOWzhqpwyAGHqTYWIb7YwqeNtcz0T72H4XvaPyGPPwDE5KB8VSZjP52nVEGHWdCpO
         WRKrnbVaYMtqD835CjUEAmc+oHTwvTj0C4NEMj+2WkKbmOSE0weg/zdWg/KWcuNSTf8t
         oIKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753455398; x=1754060198;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M11ZItqJowsXWKLvHpygzI/Vvsnt9QVCd1UdBgcxgdM=;
        b=vY0HFkw4zBixymdP4Xwga0oBVJtPG5vlOh8dd7Q3CVEue158y2Xo/elHecW0858ulB
         KfZWci4uKxHF5JmoiElcJoTJUrgZSFg2Rdi8v3UWgAhZkSF3Ze57wqHIykBCgx419Yo2
         xqTdtB2xXSbvLEsaNp7SVynOfxetWzYmAlWIO+7J9Pap25DJt7I/Zpk6MNooF7RV6yyJ
         0uMofbVOJ/oO4C0uX5/4amV0iUak8CXQAl8mXI8kzJgqKT5kkoiU3Vbij8MIydePGxEh
         NNysV8IokS7rXBBL84fMVYt03UGulskSj/r4W96TXYPLYXE9qh5JORytOsgB5Vycb2r7
         Dlcg==
X-Forwarded-Encrypted: i=1; AJvYcCV7/di7B2uex6495moHsdE54vdo/akJXp7yLENT6sBTuU+PrpxDoaNP2Q3oKnfIf7lIX5DPdh/b/w==@kvack.org
X-Gm-Message-State: AOJu0Yx85iMs7OSANseoaZFNWVkD5+Zt/cu98SwIuuBp+wI0iKUsWys8
	3BvtuG/knE+8l7gFUKzykq9R7lVoWAcMYZXeDwBUrAnvbJeRxLL7n/7TYUk1FPYK/XJjyzDO7by
	+6V4c8w==
X-Google-Smtp-Source: AGHT+IHSdqHbxeeeIonkSh5BY2m83Kk+wImCtE785oBEw0uVpGh4sf1S5Bqzy2yOyFZqFe/ReQAn+EAhx5g=
X-Received: from pjvf3.prod.google.com ([2002:a17:90a:da83:b0:312:ea08:fa64])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ca8d:b0:23f:b954:eee
 with SMTP id d9443c01a7336-23fb9541174mr15170785ad.35.1753455397682; Fri, 25
 Jul 2025 07:56:37 -0700 (PDT)
Date: Fri, 25 Jul 2025 07:56:36 -0700
In-Reply-To: <diqz4iv1dudx.fsf@ackerleytng-ctop.c.googlers.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <diqz4iv1dudx.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aIObJH439LQWjnqq@google.com>
Subject: Re: [PATCH v16 00/22] KVM: Enable host userspace mapping for
 guest_memfd-backed memory for non-CoCo VMs
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
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
X-Stat-Signature: yxwmdeyztdmy3hq6bmre9abgj8k6acfk
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A16440016
X-Rspamd-Server: rspam02
X-HE-Tag: 1753455398-694570
X-HE-Meta: U2FsdGVkX190LUBGhNh6R/RR8c7e/O6JMRtU1TplGH2fkNK9hhP24B4gpBRuoHIWWPNUIuZM9Rw0wXgD50QS3dwA0zKh7t4FX99injjPweBYWBnUVdEfCb9BmmUMHBUsXEeIwDap9khoR+nFUfXb1gAwVaSRTEKUesGF59sdGFIywEolV3J2G8Opjmdsxp6C6k+zHCpWJTNY9UUxO9IlLZDngwxo1FIxMcErTeTEPTi70XqzLCjTcVKzcLC9mtQAndorGastnJmdkeI7IsT2rB7arP5DJmAv88BEXzu8mUp2jCEX3O9sRIFnZUc/V9PNWFDEiJ0sEXeNIgxCF/OAWkuhKWj1i04/VNL3XQXte6MDIUYv5cvjQZOiiPGMkzTwFK+ObSqCHvHpoblRIK/KuGMHfaglZ4bOndEmbM6xfSr2QyFG7ARftYC95POa66j5yufMsMveYIuoy1LTSlNrnPB8fnqxTsdUJW0QWrG0/92WBnO8bCDKZxWAos9VbgzM7S8q/hmQ9Dm48aQShS47GfPMMWGy8ESNgIppOXSvdHnEDSQWYrS6y1aNYToqQIMZSkrrU1UARPJCb+oruZz3V+KSsn4257MVoxD53Vpzhryo3eVAb5Fd7yuv7t76tWOfRuev+6/1vfBHipLk6vZ8SYHEFR68QD7zbN/RqQFX8tS11KbSArcSAyZk4VjqDy1hzvDmi92njMqp9PCiRydXVOrGVI9E15gq/ApVax5dpXQvH0vd16DZ8px29q3lvko0vVCmMkUDjukkPDMiHN9iji+tZ8W/5Pptp5VIZlHYbdEkxTSLNg6pRxnXosSVYZIWQ0c60vxjaTfb4XsIhDMO8kKvQ7sdahlTS0zgMyBsJWVdvuRh5T5gNX9sUfXfLGSU7Ikt/HEJJYi1FX42s/CZ4mGtq2KDgm3alCsC7PfQDkkiOu1gUYO5jVl7GLeBkemBfTMauhY9HV8qEOrYQGI
 lQNWlioJ
 pPQPweenOMA2yQi4f9nKQQNhNq9EI+/7lhVuNU1JwMD2qci2xjOujNAttfa2lparu6gSzL2gfLQ7f7IpNH8/difpsC/2aH/b8QNH9IpU1FcBNkPNBWLLnQZRSi+gbs1rGe51kN4E3N3m2+vPPiLIFjq9JTpUWlPzsq3LdLSksEyrPBqP47QBQmgB8yVQVRQyAzA3p4r2C7ArwOs4i2STcNq81l78/t5W/d2zW5hn4PIOkmmGe11fnkdHll8VMd1ZnfPZsF87A2UkOBwPz7hil5orVtRfwxW2WnH7dAa2EvNIsrsuvtN6ty8NIIyN2opEwWxbgVQt/xIXJADSAlWs4euGpGEEWIPCgYzOr7eQj2VjiQEc2nSLMfiMrUgQ7gVfY/yEWxh/ilkKobEuBESh+CjCWyuVeo6hs4ZhzI6E6qrAzHphfTbxUYnbJsx4RjSPNr8sGuevebCKnv+9Sby0o96lLCnWiwwnLuR5U1P0lX3/kBkzYHRek3BtHcCoHyK1gtrNKDX2lXboGKyqmWX06HTEwM1fmVuqKy3PpeWDovlP8QQx+3ns52vV/8+cm3mcCf2IkujX+7HjF+s4+bBeeyFF6g8HCT/kspndmmOJbIupjTxTay/wr4lkLQbmMyabVA1k6milwBYs1RYw3lgT9+xNcFE4N07c2W/F9CdeaD1aPaYAcSTXvDyjhSNDS7f/3tytZHopHO/852XU3pJiwVlEtzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025, Ackerley Tng wrote:
> Fuad Tabba <tabba@google.com> writes:
> 
> [snip]
> 
> Did the patch [1] for x86/mmu that actually allows faulting when
> kvm_memslot_is_gmem_only() get dropped by accident?

Ah shoot, it did get dropped.  I have a feeling Fuad read "drop the helper" as
"drop the patch" :-)

Faud, given the growing list of x86-specific goofs, any objection to me sending
v17?  I'd also like to tack on a selftest patch to verify that KVM can actually
fault-in non-private memory via a guest_memfd fd.

