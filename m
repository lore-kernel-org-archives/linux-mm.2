Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C8EBC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AEA26B00AC; Tue, 22 Jul 2025 11:54:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286936B00AE; Tue, 22 Jul 2025 11:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19CE66B00AF; Tue, 22 Jul 2025 11:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8C86B00AC
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:54:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95BAC16042A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:54:29 +0000 (UTC)
X-FDA: 83692347858.15.044B6B5
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id C8E2BC0007
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:54:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kzYMqTCW;
	spf=pass (imf28.hostedemail.com: domain of 3MrR_aAYKCOMXJFSOHLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3MrR_aAYKCOMXJFSOHLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753199667; a=rsa-sha256;
	cv=none;
	b=QVOeBj6l18pHrrQpdneOJRA/29NevPWYtNaAjC9Hs4cl7QDuKb1X1FHOHbb6cZuaUiveNE
	znA2jdMK5afctSFq6NHUE8n3kWp1zcOideKGk7DpYOhgY1F8AOV5sDFBzOpuujpejoDWVW
	MMHqpoI970tyXWPeusSRvviywjUbEHM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kzYMqTCW;
	spf=pass (imf28.hostedemail.com: domain of 3MrR_aAYKCOMXJFSOHLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3MrR_aAYKCOMXJFSOHLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753199667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2EB07ZZ1nZF+2zxBd27QnHrigr6tNVGhECi/rfOelmg=;
	b=jww5nLJE4d/F2HzCubewHhc+uvIqNLkFX2LJwjcr0HwaPL5zOI3/AhSAi8SHoWzVroRHdP
	1XhCXpNaSj+p8B5Hrqt/6XNHqnvfqmP8rC2qPzaFglgcTNG8+MyZl1REPAPCmDIXqcgd0L
	5r49vt7anFzuoaTAUcljhD8mITKxiY4=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-315af08594fso5420157a91.2
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753199667; x=1753804467; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2EB07ZZ1nZF+2zxBd27QnHrigr6tNVGhECi/rfOelmg=;
        b=kzYMqTCWWRWaZ97grmfwcB/Xb1k/bOqen8y9hs3kiw9hW+oGlQuKioPtGVWQ4/6v9S
         ICnKM901ifPSF1xe/hG1Z69KadfPHPeL5rRzZX0ZBLSRriyKr4t6eufxMSgci1NLsObn
         2jTV4Mf0ZKUbCzAtb1OO3xenhRg+NOO7sdDEXqKLWZyFTs/4FCS+Ntky/UZ3lpRljLHt
         NJhOVMosbcroX998GzoRDOWoL84yPN37FUF3V4hQToND2yqe5qbvZujkMMoSshzvKafV
         Lmp7VJraJPTGc7GXy2OY9z5e95RPFZy5ipP0Rqk/yu6gY8UmbfDZoRTjWw09Z/hQ8BKC
         f15Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753199667; x=1753804467;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2EB07ZZ1nZF+2zxBd27QnHrigr6tNVGhECi/rfOelmg=;
        b=glDOUFL7mfn86Ej6TtmVkYiDmvcBJMxw1qwO37YptAJ0cCq3KVtwqi/E7j1mmxoO5O
         zKeXE3nn/5rRAaVwFhdNLIVpoMyyndmV90CZ1+yD0ScF0hIBPgh9IbGUJjvyg17la5/6
         DrIOc8Ckvk84Xkxwscjd015n/9D+jenlGJ6alnjqjyBnLlnPwIHFzkEpAbWqzkQJFz8f
         ifwSWuX739dRL2Zzs5TI2uk/79k48REUaJIHclBDC82I0dOm4YHiWm/PRq2r5PRMJ1cy
         1j1rt1xULBkz6+ihDTXATDas01X+g/qVuKJ21AiJ7jxTiq9ohAMHee0R7ZR9RMU0GV7K
         XbwA==
X-Forwarded-Encrypted: i=1; AJvYcCUOv2yyo+5067n4xh59YwhgiwpWFpkbNt4mrZrP+jiiQUI3Wo1AQ99gq/kQLlhlq2Btw1dwQp6IXA==@kvack.org
X-Gm-Message-State: AOJu0Yx8GDOXM39gy3jN3sxpbdUR8l+2BiPGktcucZwlceZKHBOqmLWt
	QKZZriRQWm0mk4E7NX/LmPlCDfzsQJQRGsoMhDqw3dRjnp0X9GCphDKKbE0AeCxELdnE9u9rN5j
	MU8A6Eg==
X-Google-Smtp-Source: AGHT+IGD9GjUmk2mTKpI5WThiVPOreH1K6U86raMu0YkKxP22VhfLnDZ4ZgBcgSwwkWvRKO4X9OvNPQVInU=
X-Received: from pjbqo11.prod.google.com ([2002:a17:90b:3dcb:b0:311:7d77:229f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:5d12:b0:31c:39c5:ffbd
 with SMTP id 98e67ed59e1d1-31c9f4b4177mr29758044a91.24.1753199666565; Tue, 22
 Jul 2025 08:54:26 -0700 (PDT)
Date: Tue, 22 Jul 2025 08:54:25 -0700
In-Reply-To: <13654746-3edc-4e4a-ac4f-fa281b83b2ae@intel.com>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com> <608cc9a5-cf25-47fe-b4eb-bdaff7406c2e@intel.com>
 <aH-iGMkP3Ad5yncW@google.com> <13654746-3edc-4e4a-ac4f-fa281b83b2ae@intel.com>
Message-ID: <aH-0MdNJbH19Mhm3@google.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C8E2BC0007
X-Stat-Signature: du81b5ar6bj1ieb9habuagg1cnra6wre
X-HE-Tag: 1753199667-916566
X-HE-Meta: U2FsdGVkX1/LsJca+LRFgxg5bMJEEpeeuo+WF51HAPjxXbRHLnQK72rGyfmHzU5ftUdmla6CPBsqkWbtFO/A/vaTDEmX+6PmdHVQ4+b1iVpccgRca/HygeqcjkcQmpyQxisTUjeL79MtDpFcJ/Yt73slYdoeGLro/LJ8uYihfsNLxwSyHaovhG/X+8uwSQViIBgIthlAOKTy+9Np270TuzpryWhpSXaK3k2/ZnExftJvFuVLLXJQc4O8zZBB92Hdp9wQVqD/R2DQAgdJooptBuDpWwI1uZpI6z3fa2zQAt7A9oHRqB4kCN4uHzcS5NVKLmYFJ+TaU/QJduLv50MkFtGAc7uiz5Pc6q8DTJl6w1TjpLN+uQ4KFZfUmJX5WDOArpXb48Fe6atbIrrGK4d3zAe6X5+H5FuwJuNVDMMnlwJigv/pLCS0PCHHloLhjuJ8SLu6SIAz6RSoMQ8wWUfBPa/8InWeKLLAChHLnZuGFNWaBvGfo/GD4j2UeZlk2mAxp97n661+4e5kdd5p7VkqYukwMTvgL2un+lm7A0v4sB9WFugXYT0+k22Imf0IJbEyytMEpNWcX4yIKU36cwCQQPMqNR8AMrU3qWsA/UNNcb/8G2lChxTUkAsNPCRD1ab2W440xjyoMLe/j8qupv5UIrIN9UWgV904Wx1nxPA2Tovr0LvWZD+fHzmmTdIX33FG/X6KKUl58IGNudjRfU5y7tNRViDySumRDDANfzv1KPFsYpY1y14T4hAGqIpBZMhMMf5F5tnw+WBaPBEiRuUOYNAyziPivh2Acg7ezk8po7lMGaLyetIE+qcBhUPD56on8N8rvptl28PJhTHMGOQcXX0lPMZPB2+qez1OSjE2RFyNfBfymoGrRCLvJB/cqYAMyQqM1kuEdVxaf3q4ErPFCYymxhvfU0g1MriWS0Zh0Mo1TXFa+0U/whAUrjLuPq0c7Uj6moB+rcwHMGpbAQm
 is46QTfP
 4KGhm5EYz+TLR+fnYJbGovPY1LxcTAJKrTe8YrwXkQfhuLfEC5mwYjbhI5npH350KDW8hLTpQ7LQWJr9Ny1GgiO0JE9Gn7t9YNq54M2yyCv3lqdy3L56yJMb4Py9ybyvQxB1OT9Ckddo+7nPpgTJ3sxPaeiEXzQU3cUlq5Kh+kiZ2b2h4ZNDd5Oo8N8HfRAd4Xm20ksX93Mi9KsejsJm/iXoRx5kwc7RyHTxVXeRM1AH1V5nqa4J/Ty7DNDA7sc2HB/TksJItO7QANS5mvg0TiMW9QnxeqwzLZY3zcL4Vlct2n4c0N/29fr/4+OdtXPSMxi7EhpXFRfPw9+Dd58Lu02LDTpUkOkUxac3sRmotqkK52ByN1fRaQJYQl8zZztx7Xg7DEkXxXHTZRs2KtkJPkGKYXc8XGwZ04aX7c4852L56zTekqc0hCG1dt20CGxazUGZl07ZAOteQxT77y/sI7yql3uvDxPWV64/EHMqbA9p/ybqRskzFHMqDrIbB8j8QzFavBYhgkf5CCUVHIWjXckR7b7n4owqEK6YKvKvYmdrayb7TJ+0AVMMHRXUA1wPX4fAHtUedI4DIAUXY/o7+adHCTIwWxwZQIGq7KoDpsh1Vnzbj5k3ht2DSczsFxG3ugcs1hEVXx3jB04yUvSI1QFkMBH3VzTTSDU+fhxrQKQ2bY4bBql+yYG9z3SHIXRYJ+bJKzV8jlEKcFtjb3Fja5xwzaUrVVUO8gjZOZ4M/1dRPw0XFQMmg8x9OFRFp9Xucblf0GGad1vYv0RdDsz8ttthJjmvCFI/s9Ljl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025, Xiaoyao Li wrote:
> On 7/22/2025 10:37 PM, Sean Christopherson wrote:
> > On Tue, Jul 22, 2025, Xiaoyao Li wrote:
> > > On 7/21/2025 8:22 PM, Xiaoyao Li wrote:
> > > > On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> > > > > +/*
> > > > > + * CoCo VMs with hardware support that use guest_memfd only for
> > > > > backing private
> > > > > + * memory, e.g., TDX, cannot use guest_memfd with userspace mapp=
ing
> > > > > enabled.
> > > > > + */
> > > > > +#define kvm_arch_supports_gmem_mmap(kvm)=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 \
> > > > > +=C2=A0=C2=A0=C2=A0 (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&=
=C2=A0=C2=A0=C2=A0 \
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0 (kvm)->arch.vm_type =3D=3D KVM_X86_DEFA=
ULT_VM)
> > > >=20
> > > > I want to share the findings when I do the POC to enable gmem mmap =
in QEMU.
> > > >=20
> > > > Actually, QEMU can use gmem with mmap support as the normal memory =
even
> > > > without passing the gmem fd to kvm_userspace_memory_region2.guest_m=
emfd
> > > > on KVM_SET_USER_MEMORY_REGION2.
> > > >=20
> > > > Since the gmem is mmapable, QEMU can pass the userspace addr got fr=
om
> > > > mmap() on gmem fd to kvm_userspace_memory_region(2).userspace_addr.=
 It
> > > > works well for non-coco VMs on x86.
> > >=20
> > > one more findings.
> > >=20
> > > I tested with QEMU by creating normal (non-private) memory with mmapa=
ble
> > > guest memfd, and enforcily passing the fd of the gmem to struct
> > > kvm_userspace_memory_region2 when QEMU sets up memory region.
> > >=20
> > > It hits the kvm_gmem_bind() error since QEMU tries to back different =
GPA
> > > region with the same gmem.
> > >=20
> > > So, the question is do we want to allow the multi-binding for shared-=
only
> > > gmem?
> >=20
> > Can you elaborate, maybe with code?  I don't think I fully understand t=
he setup.
>=20
> well, I haven't fully sorted it out. Just share what I get so far.
>=20
> the problem hit when SMM is enabled (which is enabled by default).
>=20
> - The trace of "-machine q35,smm=3Doff":
>=20
> kvm_set_user_memory AddrSpace#0 Slot#0 flags=3D0x4 gpa=3D0x0 size=3D0x800=
00000
> ua=3D0x7f5733fff000 guest_memfd=3D15 guest_memfd_offset=3D0x0 ret=3D0
> kvm_set_user_memory AddrSpace#0 Slot#1 flags=3D0x4 gpa=3D0x100000000
> size=3D0x80000000 ua=3D0x7f57b3fff000 guest_memfd=3D15
> guest_memfd_offset=3D0x80000000 ret=3D0
> kvm_set_user_memory AddrSpace#0 Slot#2 flags=3D0x2 gpa=3D0xffc00000
> size=3D0x400000 ua=3D0x7f5840a00000 guest_memfd=3D-1 guest_memfd_offset=
=3D0x0 ret=3D0
> kvm_set_user_memory AddrSpace#0 Slot#0 flags=3D0x0 gpa=3D0x0 size=3D0x0
> ua=3D0x7f5733fff000 guest_memfd=3D15 guest_memfd_offset=3D0x0 ret=3D0
> kvm_set_user_memory AddrSpace#0 Slot#0 flags=3D0x4 gpa=3D0x0 size=3D0xc00=
00
> ua=3D0x7f5733fff000 guest_memfd=3D15 guest_memfd_offset=3D0x0 ret=3D0
> kvm_set_user_memory AddrSpace#0 Slot#3 flags=3D0x2 gpa=3D0xc0000 size=3D0=
x20000
> ua=3D0x7f5841000000 guest_memfd=3D-1 guest_memfd_offset=3D0x0 ret=3D0
> kvm_set_user_memory AddrSpace#0 Slot#4 flags=3D0x2 gpa=3D0xe0000 size=3D0=
x20000
> ua=3D0x7f5840de0000 guest_memfd=3D-1 guest_memfd_offset=3D0x3e0000 ret=3D=
0
> kvm_set_user_memory AddrSpace#0 Slot#5 flags=3D0x4 gpa=3D0x100000
> size=3D0x7ff00000 ua=3D0x7f57340ff000 guest_memfd=3D15 guest_memfd_offset=
=3D0x100000
> ret=3D0
>=20
> - The trace of "-machine q35"
>=20
> kvm_set_user_memory AddrSpace#0 Slot#0 flags=3D0x4 gpa=3D0x0 size=3D0x800=
00000
> ua=3D0x7f8faffff000 guest_memfd=3D15 guest_memfd_offset=3D0x0 ret=3D0
> kvm_set_user_memory AddrSpace#0 Slot#1 flags=3D0x4 gpa=3D0x100000000
> size=3D0x80000000 ua=3D0x7f902ffff000 guest_memfd=3D15
> guest_memfd_offset=3D0x80000000 ret=3D0
> kvm_set_user_memory AddrSpace#0 Slot#2 flags=3D0x2 gpa=3D0xffc00000
> size=3D0x400000 ua=3D0x7f90bd000000 guest_memfd=3D-1 guest_memfd_offset=
=3D0x0 ret=3D0
> kvm_set_user_memory AddrSpace#0 Slot#3 flags=3D0x4 gpa=3D0xfeda0000 size=
=3D0x20000
> ua=3D0x7f8fb009f000 guest_memfd=3D15 guest_memfd_offset=3D0xa0000 ret=3D-=
22
> qemu-system-x86_64: kvm_set_user_memory_region: KVM_SET_USER_MEMORY_REGIO=
N2
> failed, slot=3D3, start=3D0xfeda0000, size=3D0x20000, flags=3D0x4, guest_=
memfd=3D15,
> guest_memfd_offset=3D0xa0000: Invalid argument
> kvm_set_phys_mem: error registering slot: Invalid argument
>=20
>=20
> where QEMU tries to setup the memory region for [0xfeda0000, +0x20000],
> which is back'ed by gmem (fd is 15) allocated for normal RAM, from offset
> 0xa0000.
>=20
> What I have tracked down in QEMU is mch_realize(), where it sets up some
> memory region starting from 0xfeda0000.

Oh yay, SMM.  The problem lies in memory regions that are aliased into low =
memory
(IIRC, there's at least one other such scenario, but don't quote me on that=
).
For SMRAM, when the "high" SMRAM location (0xfeda0000) is enabled, the "leg=
acy"
SMRAM location (0xa0000) gets remapped (aliased in QEMU's vernacular) to th=
e
high location, resulting in two CPU physical addresses pointing at the same
underyling memory[*].  From KVM's perspective, that means two GPA ranges po=
inting
at the same HVA.

As for whether or not we want to support such madness...  I'd definitely sa=
y "not
now", and probably not ever.  Emulating SMM puts the VMM *firmly* in the TC=
B of
the guest, and so guest_memfd benefits like not having to map guest memory =
into
userspace pretty much go out the window.  For such a use case, I don't thin=
k it's
unreasonable to require QEMU (or any other VMM) to map the aliases via HVA =
only,
i.e. to not take full advantage of guest_memfd.

[*] https://opensecuritytraining.info/IntroBIOS_files/Day1_08_Advanced%20x8=
6%20-%20BIOS%20and%20SMM%20Internals%20-%20SMRAM.pdf

