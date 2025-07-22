Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA34EC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136C16B00AF; Tue, 22 Jul 2025 10:37:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10EE66B00B0; Tue, 22 Jul 2025 10:37:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04BF06B00B1; Tue, 22 Jul 2025 10:37:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E94326B00AF
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:37:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BAB26160412
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:37:17 +0000 (UTC)
X-FDA: 83692153314.08.8B2B446
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id E61A714000C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:37:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MJyiooWD;
	spf=pass (imf26.hostedemail.com: domain of 3GqJ_aAYKCKcZLHUQJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3GqJ_aAYKCKcZLHUQJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753195036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dUACzvPgQEm4XYWd11I1pPmyiARplQU6zhTfmXThj6g=;
	b=nHUfuSnBUMeJRj8M2NEGhTUyqLk3HZJyNzTYrCVGSMSIrrmU1tL75RIti+Y+MqJwq0ULrv
	LpFejsjGPuzvHPkJ/zPH0Bevau1PoqNcn35nq6RKPPa3dF+P+scz+F6EF2tHL3BuKNWyxL
	r+tVMJxc8JVtJdgYtvy9Cwb1e0UX/K0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MJyiooWD;
	spf=pass (imf26.hostedemail.com: domain of 3GqJ_aAYKCKcZLHUQJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3GqJ_aAYKCKcZLHUQJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753195036; a=rsa-sha256;
	cv=none;
	b=wccse+3uDxs0Oh8zBBQWFtxftoU9xolrvbzNFMK7Fl8t4o1LnCzQM1B5rQ5kh/i5TyFLF5
	fR8ci+hgqKF5n/6kuBwDTShy9iS+4Gp/aAruHVZJt4+q0b7hpwMbpEhGA48kzkq76b45I/
	vg2bgWf8oWoL/68bYBsVgI6RM/D8BZA=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-312df02acf5so6400121a91.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753195035; x=1753799835; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dUACzvPgQEm4XYWd11I1pPmyiARplQU6zhTfmXThj6g=;
        b=MJyiooWD4Br8ou7WwYS7xJd++EY2PizF3O3YVQEKTCThcEXSrAJB5aC0IdHUpL7abb
         3LHN0FjkE7OjfQhCHuoHvtCV3kBha0/peauPqFQa3rJfuY6Rpxcjr/z9dJUn92QOTgtC
         Yq9UXnAloSBclOYhh6/nFQW8jnyzEiNrDbvA6k94Ci9h/Pj6NOX+uhcPnETtbDFe+5Xu
         5uCZ8L4qDKUScIm2vRFZ+DTCQV9WCFXwGZK2aU+9c66hANxSY6YG0famaIHirxqJadi3
         if0Ckc8KcS+57vqh82sBIN4fGWUu9zjbAUs0hgQ6rLgh8jfqtxG5uKxhRY23DWShgiXU
         r7Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753195035; x=1753799835;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dUACzvPgQEm4XYWd11I1pPmyiARplQU6zhTfmXThj6g=;
        b=FDAOEHgyxh2eD5DFkCFOS3ZEtY0dXtiYGpM/1HMTtb0S6nTWKvj6XjFOtk0nlHVCL1
         jSe67iaK7HjLBNiiY0j/C+b4zF35OoSMBsKGoYry6zGwZANfsfnuA2qgMi9hmKbtMgLn
         Neml3tv0h1/qu9z7+Ihq0WKsA2UKwVFgHgBDTegLGHQHybz6k9hU6oY+tnsBb2Uva2T+
         YPtzbslgreU28hJQ/Ln1c72yK1Qk8q7iDpPPheg9D7AjK6tPgIrX8wwLTG0YZ0yKD6WA
         KaHv2pQx/Melq92G4GqDRLDydwxEwuO9aqRtMRoIxlIuxkdzBgCAofrckZ3Mmiv1kH06
         IYMw==
X-Forwarded-Encrypted: i=1; AJvYcCX6n3yqJhtMb/KRnyNg+POMfLYGbbp+PX0XxUyg61LmQebWCH7yVMzWdODbe1THBc2dLyeMjbr/xA==@kvack.org
X-Gm-Message-State: AOJu0YzbO71FIz7vBMpB1X5kTpUrUnNF2/yMH4R+0ji1CngVV1TLu/iP
	8aY45dL+aPnXByO6XjluCXpZdhWyEQu1sJgDXb/0FBz2DYsPPEX+wqGPh/SSpUIiknPMXosfiLm
	rEXnkVw==
X-Google-Smtp-Source: AGHT+IE8C9J3LvK/phm20LbST6qjzlg3ADXumanwajQGLHBmnJo5nov+CCWKM1So3cCPJD4+nPzceM8mbdg=
X-Received: from pjbqo11.prod.google.com ([2002:a17:90b:3dcb:b0:311:7d77:229f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38d1:b0:30a:9feb:1e15
 with SMTP id 98e67ed59e1d1-31e3e153417mr4923710a91.8.1753195034488; Tue, 22
 Jul 2025 07:37:14 -0700 (PDT)
Date: Tue, 22 Jul 2025 07:37:12 -0700
In-Reply-To: <608cc9a5-cf25-47fe-b4eb-bdaff7406c2e@intel.com>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com> <608cc9a5-cf25-47fe-b4eb-bdaff7406c2e@intel.com>
Message-ID: <aH-iGMkP3Ad5yncW@google.com>
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: m5gpdqhwmuma3h45ynfrdxt39su1nt56
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E61A714000C
X-Rspam-User: 
X-HE-Tag: 1753195035-75927
X-HE-Meta: U2FsdGVkX1+r9NyLH9ihW/DOCH+3vBNWpCpVnQwrd/FQfYM8VHHaQuTa6YS/2DlB5Sq2hVGyM1d6sAFPr1YzVSqlzeBDpV+E+hmPAQ5dipsac5zHar53rTmUh58fA3FfAaPwXZiqoL7204Xpbq+ylBm8A1/u4EjFDlFWWDvdqyLBlLoU8ealjwXP4I8OQ7eFMBFQJSv+s+YLobplVbABCdDD0yVeRy0x8xKuGMLe+u9guqNpsA5pfWMHl+zbDa+viQYUOzdbcf/xICZYa/bE0ozz+5it9UuiY8MyXXQKJv4Y8dCYFhkG7SvBeMa+oWFl2zJqBQHPUdyWXKJgeXoazz2WwM4ne7621S15chd9wQNMVy4M3vm20mqBFjqD6rB8SjF3oQhN54cFgfZk4sBDvfIHjPAyKfm+Ezscc3xQMW9RyWn+2ZNbwFUolNQ1wjq+ZvurH35xwvLlt0iTPrQKJw4UJL+5b71IuecVWCoONJIy2EyRwxxKQELC/etD5F/OEVrRQNRBttxN2aAZTPxg/Gy7WNZmmkS7QSZKPO1DznpLpechb3Xz8wKdGaeNYoGlu7aERKgSC1S5uzts1oPek+W4TPURQ8rcZbPG6R9JHXkCap1PbjjjEhYBGWeo9a2tT6aY0Bi0iAdZ5yVOzAvFhxO88L5hKzHhO7uZdgSUa4Lm+cN6pT/LwtBGT7IVVZS3pyFDgEP9NsdaiszmnSayoYESYFdruQlVS6QbheQhCaRyMcpl8RrRG79BdaoVUBC5BNtuFVq94Q+lH8GdCxVhCbhLLxPL6co0+4Q+AazTIqqw+gLE01UYqIxyrU3DxvOEs86OmtB14jwXH4vpel5UFNphWX34OaUYwm/8jZ9hnrn9XtkfDp1/PohNV25iGl5AmJhYrwIkZ4qwWlk2abeH+EmAgl855eIeLELH52Y5xApY38HE5KQOoLqZTgQA8bK2NBaHkP0NEa1bUTjuUaB
 KEmhhChG
 oVb/oo76fMKhd+ewruE6CCjDCA87TMB/wMUIbDWAFkBhlh/FN2HdmQcprkDqdhhk//eoL1tQp+nE4EVsrTthVU6/2Khty+StG1QENfdIbcj9PGdy9K+E4glExhfoRKtYq0v6sWVLDNJDfy+GCytHSEDEC6cxPGO2q6k+aQxqZ+m9H3NbXhkETJHctHHNq8vRlnhggusxJfgyvxQU+WoRUaS1mns9xAlYKnnu8QY/JzKNGABBLZjwxh5zaEUphXAfLJtGB+54pMpIpycO4pjEKEnOfDrnRf8vwPAhDqoo4rXVZB7f6ue8tMHOlSgMSv8wMY91WD4z1OBrqJJcyz101xIlp5ZX/SzHpw38j1BkpPtl33JxLW6/pQuGhgiKPCR46N3Fqf2Kww3FMJuPq7DbCUHfqX86DXxtnSlW2ji8oSyQqbLEqilPcCiyR5nA5/VCNVrnIrBu3sgIr7jJHKfKBBrSlxWVOmuuBjfd3hsUgw7KcEYJFwBFFoyVAxFfTHBVxlFzZgDWYtfMm38S7V1Pjx6IB2jjW9PuvV9ZbAxrOjemxMtx1yY6O8yIKm2Qx2zSG+89lLaRDL6Yxwnhl1TJc0dfOt+kz98xpa2nRGUHCOG4v44pSIBn3Wt8sgknVxkD4i3rm7hbhwb1DL0HM655XkrMrtdoTJV4BmPbt68VRHPnoF9skog6ESC6E0GEpWJPnHfoFL7QgQCcecEs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025, Xiaoyao Li wrote:
> On 7/21/2025 8:22 PM, Xiaoyao Li wrote:
> > On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> > > +/*
> > > + * CoCo VMs with hardware support that use guest_memfd only for
> > > backing private
> > > + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping
> > > enabled.
> > > + */
> > > +#define kvm_arch_supports_gmem_mmap(kvm)=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 \
> > > +=C2=A0=C2=A0=C2=A0 (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&=C2=
=A0=C2=A0=C2=A0 \
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 (kvm)->arch.vm_type =3D=3D KVM_X86_DEFAULT_=
VM)
> >=20
> > I want to share the findings when I do the POC to enable gmem mmap in Q=
EMU.
> >=20
> > Actually, QEMU can use gmem with mmap support as the normal memory even
> > without passing the gmem fd to kvm_userspace_memory_region2.guest_memfd
> > on KVM_SET_USER_MEMORY_REGION2.
> >=20
> > Since the gmem is mmapable, QEMU can pass the userspace addr got from
> > mmap() on gmem fd to kvm_userspace_memory_region(2).userspace_addr. It
> > works well for non-coco VMs on x86.
>=20
> one more findings.
>=20
> I tested with QEMU by creating normal (non-private) memory with mmapable
> guest memfd, and enforcily passing the fd of the gmem to struct
> kvm_userspace_memory_region2 when QEMU sets up memory region.
>=20
> It hits the kvm_gmem_bind() error since QEMU tries to back different GPA
> region with the same gmem.
>=20
> So, the question is do we want to allow the multi-binding for shared-only
> gmem?

Can you elaborate, maybe with code?  I don't think I fully understand the s=
etup.

