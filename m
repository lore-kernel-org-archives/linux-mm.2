Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F2FDC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29B3C6B008A; Fri, 25 Jul 2025 12:40:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C2C6B0099; Fri, 25 Jul 2025 12:40:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B776B009B; Fri, 25 Jul 2025 12:40:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0346D6B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:40:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ACD28133FDB
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:40:53 +0000 (UTC)
X-FDA: 83703351186.05.D36331D
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf03.hostedemail.com (Postfix) with ESMTP id D84082000E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:40:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zeO2ahSD;
	spf=pass (imf03.hostedemail.com: domain of 3krODaAsKCFMvx5zC6zJE8119916z.x97638FI-775Gvx5.9C1@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3krODaAsKCFMvx5zC6zJE8119916z.x97638FI-775Gvx5.9C1@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753461651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h0vJgkAubMXXN6o65VTnm8PRheVkeM5gEkAdD1H4GYM=;
	b=kaVo+oDxS2142AcAtHpKcmiBKyVOGzAfhA4CPRgup5oquM8NHB8RcMbKna9kfrlDAEqOe6
	d03xYO43en8zArP4ajDiclT/3pN2d9NjG9Mq0V738J/vtE0y1mAty/+1yRuh933kfQtm3a
	iDDenmRN2f+U09/0pFIy4WOHXPyXHPI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753461651; a=rsa-sha256;
	cv=none;
	b=uYFleAiyKAs/cyr48OzphWUVbWKTiF4u35eZx90ohBxIFHsQqOiAahMIcQV4fTXZNDF6Pk
	AHXQp1/jpnMbFCNu42DZfdaVfYAXLBoQTwSYpDloH4V8p0jnmfNPMe/VyLtAARqNvULgCA
	ezHutMKEh7yhqrcifooMPSs45ZJrdbU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zeO2ahSD;
	spf=pass (imf03.hostedemail.com: domain of 3krODaAsKCFMvx5zC6zJE8119916z.x97638FI-775Gvx5.9C1@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3krODaAsKCFMvx5zC6zJE8119916z.x97638FI-775Gvx5.9C1@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b3510c0cfc7so1758659a12.2
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753461650; x=1754066450; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h0vJgkAubMXXN6o65VTnm8PRheVkeM5gEkAdD1H4GYM=;
        b=zeO2ahSDrPDz3WGxxX+088Rol69L6nz7knqHdWWEkxDJoZLjSUk8aZVXS0EKYZ4ehh
         krxTSMvMeVWfomyfE6Lg7DUPJzeM5avghyOwLPWewqUTf+9c/q5N6pYiaJL0Nco6mjpv
         aAKHH5GbGPHb07KL07hcBE3VDr9LKvdpY8mA3rJ7+5KsQAk/6kHEl6dZBkWmhj/fU/4J
         XZjQ6/OO61EjJH2fp/AcP2dngvg5oHXMaxcLO1Jr6uaeFHWOrn7tVQrg66WKvpF5b8M0
         VBnjr2BDti+dTall9ErdZ5InDIRUoUzCWORNFmzSyf/H653pVCtC8NmHvCPBW8VnrFTw
         DhPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753461651; x=1754066451;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h0vJgkAubMXXN6o65VTnm8PRheVkeM5gEkAdD1H4GYM=;
        b=S/sCpmGqwJIMRFQb3hXaI0hjwyadIZ++LNSUrQEc6nDaL1BAsRfmjweGlXkBHMV6Or
         5aE3in+G56D3RCvJOLJccOwy3ssmZbYOiza9Vm/SXm2t3vRIsVFvaD6Vd7fSmwiyTUks
         x86qM5dA8Ezbp3QqFP9aUHL2io5yomrnAIimSAI7726ehPZHAvrYxPS8N9BVP7KHJsd1
         zc6gMSl54hyTo6AHBzezPnrMKYSK1Peovn9pMajfjC9E8/4+ueqA5+QpgzuZcmHURCuE
         bN/9ib/7UHjVkiDo132fP1jxjQ/tcZ+wq8YUfPT+u1NgsyiibwOc4sAwutacR5freDyG
         xvgA==
X-Forwarded-Encrypted: i=1; AJvYcCWMpXzaXT1yPMmkPKotm3gy1nYeH0PEr+CczdqSbtE65ldUOTp47pgAsUzxZN3MjHHwUHgb2KYaNA==@kvack.org
X-Gm-Message-State: AOJu0Yy2JVx0SmzxNFV/UQYA5YoV0Sl8nuQlMUyz7stznXGqhsuxs7M3
	jPZAR5IsPEJlg1I1fsBnZu1f/ySbU1nVoQW1mUXLMejgkbdwUWIns4y95RUVOy1w8tUw85WWTkk
	TACnM8iyv8wAeWMOVWF7skzpDsw==
X-Google-Smtp-Source: AGHT+IESSUb5A7ox/0yy/1EortQTdLaTQG/uMcj33CzvrGYLDRDtIu6A1gNBwhWuX15U4LdcnVba587BKC1ItwdU2g==
X-Received: from pjbqc8.prod.google.com ([2002:a17:90b:2888:b0:312:26c4:236])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:e185:b0:31c:bfb9:fca0 with SMTP id 98e67ed59e1d1-31e77a18508mr3602768a91.4.1753461650340;
 Fri, 25 Jul 2025 09:40:50 -0700 (PDT)
Date: Fri, 25 Jul 2025 09:40:48 -0700
In-Reply-To: <aIOMPpTWKWoM_O5J@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
 <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com> <aIOMPpTWKWoM_O5J@google.com>
Message-ID: <diqzy0sccjfz.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v16 15/22] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D84082000E
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: e7zacyjh17nheyg7yj7rrdgn7tu9foeh
X-HE-Tag: 1753461651-393368
X-HE-Meta: U2FsdGVkX1/DRFL5MxH5vGY+7mCmzABnTvPw8hPElDIpjGNbd0GtbX9wVxYPoGAQmMwhaFAThATsQ9NkfoSyJA9oga2Yi3KsEeIZaDFYFO8ZaBXBooXXCnh0x6fWg4UztsgPrgD/EbgedaqjIBmsuiyDogsN1NykkOeirJiP4jybgy55LgivE7mmVF8GP6rTZFc8xYDxXHopO1YO+tidBO/liqrWM9oyk/dXDrphaIYgT63s/Fs+SEGvbP8Tgi773TIUJPoXyQBOLAsW5r0bIryUdSqqlFUozutCSJUwuR+Q/74EEOh2J8Vl8zV4tF2iuFaEE4naOJwMJYaXSccqL5MOb2emelpOgTQolEtDEbuWPFQ/2O/z2OKFisnR2CXPHyB0YcesrrO4QFrqhBRYG4QF4x7k9mGlP38BE4gTeWGESkf8AxT/FSyJC9AtfEkP3IoikA7P8EPN3PfxARvkvTc+q6VsBQPJiCL7w7OK4PuQcF0XJXgTr0XS4CKIZw0PSlcUflqycsN5RlONPAd+ZFIK8f5dXo8XVB1qQkIfxrRfe6DoftK0U7A9QC8q6GKf7dTwialeGEFJ6AWfFk9Wgn72WUxLchTQqT5LOyhlrV4WbUrg1XJgjdtHzeQakIJYDsTOoqq76w4K+eHiBxqbo5gr/NErDceg/96LmXP/oDyMIM1+qUuAutU9Ng4zB9ED93R7BiMNtgUk66XsEPaYaoN3XIUrKMHuxqM91pRxQhjUzeVQK8ioUlRCfLdCR4J76umZaBkFs0eVhSBetXhgSHvr9UsRq1Am0c+KNm4zyZ9z0tRjlpvSrEPf/5X8+O9zMayO91E1Aueoo9WtJfV9OtgGs/bgDf0RT+Qetxe2D9M+qjNKEjUYC2vAuHlcIF/N3SwmIX1LluMUMJQ7gm6muGaNX+GOUo/V6dsmjB9JnkCukiwYVh252+c3VaAFV7k9M72jyiysoQ6zmXOwJB1
 mMs6hAUG
 QFzrXsi267yuoJ34xsZc80dTDc69bykFGGYjsInCb5Z2fVV4Rl+eL5tn7OX+PGZMDWYjMSj/+EKsdEJC754RDwVQvPWpMmTuF+TITYNmWoqavwL1KyCcZbA6zj7ml1W2P2TkBGJcXJv+N7fHA06tUY8flr4/aZHZnWOuYF8+BH9HrhT9FFRJnLjUl/dvGPYfBWOyDlS0U4I3x/yFyQzFBzuZFK0zFJrp2/sTd0avXeb3wFxsnTqdI0q2kNgtQ5Zlh/5aKRHOfAoIubESUthw6qJs+Ie5fXDk2bOhA1z135RdtD9M5XwrL8kij3FvE5FcMTzqljSBq4T3lvNDYKHCzQmr6v9QyrT1JR4l0B+R6Xmadinr/1xvLSohqKeq0quO5Hn9kBr9aec4NcfBFTddMMC01kThmADaJpb+xTMrhnSG5X2sThT82itmi694SxN6hI46DD1mvmajfpdngyYscHF/YueB6sWOeQr7cNyTG9s7JJZ7RPopsxrKCrkhJRMaHmm2pB4NnRNL2FZD28VZ8UKjdMrvKNTaHDFkxKQd3/xS21VuuNTWhD8D1DQ01/pztego2rHwWx8BLcSIxnJSRNFxlxY3dMqb560lfloeMtSgUOESRzuzxelKR0NmsdpnObKJZ5ZZPc6KAqUs/jlLVjk8xit6TtVwR4cawjXmuXAnv71ICMGTEkTIyfMx4HPpZuvXEpT1Os1zujhZM+d2VZzfC0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Jul 24, 2025, Ackerley Tng wrote:
>> Fuad Tabba <tabba@google.com> writes:
>> >  int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault =
*fault,
>> > @@ -3362,8 +3371,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, s=
truct kvm_page_fault *fault,
>> >  	if (max_level =3D=3D PG_LEVEL_4K)
>> >  		return PG_LEVEL_4K;
>> > =20
>> > -	if (is_private)
>> > -		host_level =3D kvm_max_private_mapping_level(kvm, fault, slot, gfn)=
;
>> > +	if (is_private || kvm_memslot_is_gmem_only(slot))
>> > +		host_level =3D kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
>> > +							is_private);
>> >  	else
>> >  		host_level =3D host_pfn_mapping_level(kvm, gfn, slot);
>>=20
>> No change required now, would like to point out that in this change
>> there's a bit of an assumption if kvm_memslot_is_gmem_only(), even for
>> shared pages, guest_memfd will be the only source of truth.
>
> It's not an assumption, it's a hard requirement.
>
>> This holds now because shared pages are always split to 4K, but if
>> shared pages become larger, might mapping in the host actually turn out
>> to be smaller?
>
> Yes, the host userspace mappens could be smaller, and supporting that sce=
nario is
> very explicitly one of the design goals of guest_memfd.  From commit a780=
0aa80ea4
> ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memo=
ry"):
>
>  : A guest-first memory subsystem allows for optimizations and enhancemen=
ts
>  : that are kludgy or outright infeasible to implement/support in a gener=
ic
>  : memory subsystem.  With guest_memfd, guest protections and mapping siz=
es
>  : are fully decoupled from host userspace mappings.   E.g. KVM currently
>  : doesn't support mapping memory as writable in the guest without it als=
o
>  : being writable in host userspace, as KVM's ABI uses VMA protections to
>  : define the allow guest protection.  Userspace can fudge this by
>  : establishing two mappings, a writable mapping for the guest and readab=
le
>  : one for itself, but that=E2=80=99s suboptimal on multiple fronts.
>  :=20
>  : Similarly, KVM currently requires the guest mapping size to be a stric=
t
>  : subset of the host userspace mapping size, e.g. KVM doesn=E2=80=99t su=
pport
>  : creating a 1GiB guest mapping unless userspace also has a 1GiB guest
>  : mapping.  Decoupling the mappings sizes would allow userspace to preci=
sely
>  : map only what is needed without impacting guest performance, e.g. to
>  : harden against unintentional accesses to guest memory.

Let me try to understand this better. If/when guest_memfd supports
larger folios for shared pages, and guest_memfd returns a 2M folio from
kvm_gmem_fault_shared(), can the mapping in host userspace turn out
to be 4K?

If that happens, should kvm_gmem_max_mapping_level() return 4K for a
memslot with kvm_memslot_is_gmem_only() =3D=3D true?

The above code would skip host_pfn_mapping_level() and return just what
guest_memfd reports, which is 2M.

Or do you mean that guest_memfd will be the source of truth in that it
must also know/control, in the above scenario, that the host mapping is
also 2M?

