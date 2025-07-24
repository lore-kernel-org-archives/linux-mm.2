Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3EF7C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 22:41:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 429966B0350; Thu, 24 Jul 2025 18:41:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4015D6B0351; Thu, 24 Jul 2025 18:41:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 317166B0352; Thu, 24 Jul 2025 18:41:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 216436B0350
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:41:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9934597F1
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:41:47 +0000 (UTC)
X-FDA: 83700631854.12.5F7C1D6
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 09C91100002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:41:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=i8A5GQpd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3qLaCaAYKCGsbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3qLaCaAYKCGsbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753396906; a=rsa-sha256;
	cv=none;
	b=754ZNFyPEgvccU49aMaoRC6HPh4Tc5NlhW38xcLk9OvoowSwJ2V9h+xDiipw772Uvwhrqu
	irqprha5A+RmA9EwggbGfhKN8AovIerWcdU4hlBmcdBY89kSSMQiAJ/lpJs9Ir8pA4zYhA
	fjwIpHxlV0YZ9Ab6iIF9D7+Sa6ZEWUk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=i8A5GQpd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3qLaCaAYKCGsbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3qLaCaAYKCGsbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753396906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I++IEkZ6cfA0pom6sVbuAxnUAMPLwsrLQQjRsHcyFdk=;
	b=2T6kdpyCri8u5B9gPcnKyqWIozbile+VgUwzR9/Hwz+fF2DB2StSPfa53O1Km4oWeBS3fK
	vFZySABtsWxFuSqIIAi5WYGU4FyDv88bVTGuXqedRLPuQCeMZVahAhWTgoaeTi3UeJCxFG
	zNKI7p4SLZIW2bQJFQEbhQrRmPNYuzI=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3141a9a6888so1206706a91.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 15:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753396905; x=1754001705; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I++IEkZ6cfA0pom6sVbuAxnUAMPLwsrLQQjRsHcyFdk=;
        b=i8A5GQpdRAtXsoCEpZ05A9gFSlSl/nVHQ+2bLVtEnjIV+MfC1MHeYCo9SoP02/PTny
         AKaEw2ivGt9V6jyTOU01kL3g0UcjFR/KosEI3kdr7nIqECXPs7al2YyXhBKnZXccHMy3
         XSvfLvQ4CxD5Wr3p4YNVwbuFrPxLdUSBYoi2qCO+b5rjg40EP7l5KaEgAkvw+lFwWc23
         l62ae4vwAPr2xoxhCVGysqZStGeNFaO2qKtTK8EyrxjHkEiAnV9ZLwIRYtyZceIFhn53
         vur4nJs4EgYdAP1266Qe+dJ79iNFWy60KZEVvuE9/8BglSCBl+JOP+1jn9y/hVtrD61g
         tAgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753396905; x=1754001705;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I++IEkZ6cfA0pom6sVbuAxnUAMPLwsrLQQjRsHcyFdk=;
        b=qt7YJQ4Lpn1B/QP8inOrCFDLPggp3Glr/7GsdKF3KCxeoJeQaIfHgIcPywKdfX0r/E
         t50pGhPP6oUk7VvSC5PpS/BUS+c140JJYP2XzhArF5MzhjRCJTGti2f+EAlc3iaFV4UM
         mATSxJlzUupbyToCvYL+ysgrL0g35ERAYfXJrjZVgnfH1OJRhkXkl568MVghz0meRqhS
         CQ3KNpOEtQxyee6fG7G5EboHIE1kJ3nGe5MHXQ4kEYOKormEnzxY8dj043efC7DmNu1F
         8yZSESF8hVVYIFpoE8Rd14YWsRzhWOUhx7uR/E93bNdowDwBoZGnAKM2HQzYqf07lDW2
         mmbQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7lsrtDSIrJPdsSFrsHpnUN8XUOfaiRpWMntYQpIWHzQ9dRTKafiDDn2X3H4ubySUN/9Fw+v2W3Q==@kvack.org
X-Gm-Message-State: AOJu0YzFoRdtafRx+B6qJ6AUodRQHWkx4ZOgZ189ZqzIDNxUJVVI4Fa2
	QEdT0sEjTebNrn0f57Q5YXepkkC1eqUa4IfdY9dc5sVuWVTpJimjJS9ghdEDgiNyCy3ZFO8aMPX
	cobwYYw==
X-Google-Smtp-Source: AGHT+IGEPOlZq7owpGUQ0/mQoz/iYL0juCcDdQmikLBP7yLM7Njsl8AJeWnJbZK3d5L+Zszkhv9RTa/c8fM=
X-Received: from pjbee6.prod.google.com ([2002:a17:90a:fc46:b0:312:14e5:174b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4985:b0:315:af43:12ee
 with SMTP id 98e67ed59e1d1-31e507e27a7mr12941229a91.16.1753396904788; Thu, 24
 Jul 2025 15:41:44 -0700 (PDT)
Date: Thu, 24 Jul 2025 15:41:43 -0700
In-Reply-To: <a438c189-4152-4ad4-977e-6a5291a7dd40@intel.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-6-tabba@google.com>
 <a438c189-4152-4ad4-977e-6a5291a7dd40@intel.com>
Message-ID: <aIK2p9TgiNeQOI4s@google.com>
Subject: Re: [PATCH v16 05/22] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
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
X-Stat-Signature: b61kmkehs8cnix6dz186e1xbjb8xiqua
X-Rspam-User: 
X-Rspamd-Queue-Id: 09C91100002
X-Rspamd-Server: rspam02
X-HE-Tag: 1753396905-161922
X-HE-Meta: U2FsdGVkX1+NcZsqcps+qc/yZz9xx3Au61S+2Vj4+IKEWQfSs7rWEkeNarl5J6r+0MUJ4DwNXhHIgd74+VRbIz4FtJqoEQMr3T8g3uyiBXtujfGzMP97JXbLcRhP35+Fr4E1aThrCehagPP6dL2wLPKA6eXnIKht5XkqPNxCRqshO/ck/zh6oZRjvVytSl0cxnxYJHRwYof/SiqnA9cYdvcaX0Murv/oHx5mfB3IiyWk1jtFEGrLvX0nv1ZLkCflt2NDV38+E5a1ZrY7Sm23/JKc9ykPinZS41Td5IbTH8qHuDz35jFsmw02bYefoCJQ2mVAzw6kNrP3COAVZEr9yhQy7LrHjbivagSauX/i8wTsco9JaLzcsyez9n6AcIXS7rqgi5muqYaegFTY7PdSA+wXEcmM5gug5Q4w72s0M8Iv+TGGRO8gYJnYwWS8jDrSOdUgsHHoY9rXkW76A9S+JbQGRnIfSDtXVqu8aHdGdt39GJnCV9XzN3Njiv0GNCFFB5O0QYmRBKlepiRtE2d7IGABi9qn5LsylXOqSoKzDOG6VfSaoJjVpmCLZodVENeb3jjNxnVCrRNjXTC8NsAgqnui0MqFgVQif+Rbwd1NW+WTt0nXMIyXgx7Qiap9vUMalnv+jyeavoic321clf9tB3oLHi21QMaos1/d3cgqnZS5uZeH13P/yp/GZhQMltJ8T3P13/ZLnFT6fGAOA7niLevUZdE1HTVdahbtDceu8+SEuCg9Wkh+EBUBi5lKLg6/uMDJbXuPfnQeuK82Bb6cWZsb8YzwOky0Ec5qIBn35ZfA0xiJrlizaP6DeRBgIp1TIy6/U/wqhihs8WtWkUufsFN39H5IZdb23Dha6onu0EWmpoCKFdQA4z8+lu1oz/zWxot+it9ZbgG2t3VRScWboAZSTQ7J3PGn3GiQYg8hQtqTQj6kivT2WDN6dhqNW862Q/BRoMDJaVehqYtAmVz
 Q5ImCdLR
 jkE2/yJkEIth6ZFEfIisPoseltbDNU1l3JfaBzZDWCP8FpDWOVIxyVkcv6SnHaJ2Jirs4vqOQfeDo8SFMTR0zcELSWqcg747N6Vv3XtXWw/+27/A6JC5+93PqjuGhq5IN9Gtim6Fih47K2pfkCVsGgwlYj+6aZqcqSH5ujcE0hGmRTqQHxFpOi99u0R74YkMmbGyeiYkzXvwsB1b3W2VZ5cSsBjczgxr2oVzUAw6FFjMwJHN2zrec0Hq+NEMxz0ZIi/Io6zm310PyENQDcJFqzV5TN8SSX1U8UsJ7fJ4ipu/aKOoPl+6TdL30ZxQZs3tMwWJvRe0wHT71hqrkC8SxYKXhqQJJt5LsCnoSUM0VYqKEgFbsy9HHxVKeZlTBBEJ+rwBmtHR1tNx+7vLLhrDJxCq0sQo1vXHl/I5x9DiUks4Un41CcvC3kTxAo1tfDkiR6SKVXDmeSXRFLfDbfIuVeUbP6urKDxq8Dg5y7qceqGNNisGxwEwXPlL3RNtK79LQSKnOabDSG9gWbtPiAvwNp8p95KX72F/0DNYSCOix6FYYn4mJ+aNSDZWps5hEgHj0Wy7srbTcQ6e84ReFX3Dl6YEBoGKKLOXmXhGFxA8bOFHFILmzDrDvQyDsFtCLZE6vP2nRGLbYLf7+jatKsDdPVKUpMFeUtEhVtMUBE0D9Cv15gcFnHgpmy2t2NppU9r8MK3qFFxjEKm3jJbk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025, Xiaoyao Li wrote:
> On 7/23/2025 6:46 PM, Fuad Tabba wrote:
> > The original name was vague regarding its functionality. This Kconfig
> > option specifically enables and gates the kvm_gmem_populate() function,
> > which is responsible for populating a GPA range with guest data.
> > 
> > The new name, HAVE_KVM_ARCH_GMEM_POPULATE, describes the purpose of the
> > option: to enable arch-specific guest_memfd population mechanisms. It
> > also follows the same pattern as the other HAVE_KVM_ARCH_* configuration
> > options.
> > 
> > This improves clarity for developers and ensures the name accurately
> > reflects the functionality it controls, especially as guest_memfd
> > support expands beyond purely "private" memory scenarios.
> > 
> > Note that the vm type KVM_X86_SW_PROTECTED_VM does not need the populate
> > function. Therefore, ensure that the correct configuration is selected
> > when KVM_SW_PROTECTED_VM is enabled.
> 
> the changelog needs to be enhanced. At least it doesn't talk about
> KVM_X86_PRIVATE_MEM at all.
> 
> If Sean is going to queue this version, I think he can help refine it when
> queuing.

My bad, I simply forgot.  How's this?

--

The original name was vague regarding its functionality. This Kconfig
option specifically enables and gates the kvm_gmem_populate() function,
which is responsible for populating a GPA range with guest data.

The new name, HAVE_KVM_ARCH_GMEM_POPULATE, describes the purpose of the
option: to enable arch-specific guest_memfd population mechanisms. It
also follows the same pattern as the other HAVE_KVM_ARCH_* configuration
options.

This improves clarity for developers and ensures the name accurately
reflects the functionality it controls, especially as guest_memfd
support expands beyond purely "private" memory scenarios.

Temporarily keep KVM_GENERIC_PRIVATE_MEM as an x86-only config so as to
minimize the churn, and to hopefully make it easier to see what features
require HAVE_KVM_ARCH_GMEM_POPULATE.  On that note, omit GMEM_POPULATE
for KVM_X86_SW_PROTECTED_VM, as regular ol' memset() suffices for
software-protected VMs.

As for KVM_GENERIC_PRIVATE_MEM, a future change will select KVM_GUEST_MEMFD
for all 64-bit KVM builds, at which point the intermedidate config will
become obsolete and can/will be dropped.

