Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E928C83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 22:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4216B009A; Mon, 21 Jul 2025 18:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B954F6B009B; Mon, 21 Jul 2025 18:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83D66B009C; Mon, 21 Jul 2025 18:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98B2D6B009A
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 18:21:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F79FB3798
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 22:21:36 +0000 (UTC)
X-FDA: 83689694592.16.91A2D78
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3066A1A000E
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 22:21:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pi9XVoeZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3bL1-aAYKCC0bNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3bL1-aAYKCC0bNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753136494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5n3DfUq9+hEwNPgG2lSxnRPPih9D3owzTYtcCu6Ji3E=;
	b=0r4V7LHzsPbmf1QQgQ4DhykH2J/msWPOhZ6iUvOOEo3xaFitzkwJgg4GrTnDt8Z+XyJnxq
	AxI6w4IFPd8/3IqyjJ/VqKJ+ILcnIIhXzyjilWsKO943RvRQJ4gJh6v7Q7Ia66ur6LAD5S
	tm22OSi32U2xK17nGAn/VmDV47GnexI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753136494; a=rsa-sha256;
	cv=none;
	b=23Io6vXczYRBVl/5fILbs9o0c8/BlRmVFV23lBnlRiDbnN3IAlvOOMW/wx06VUzn9673IW
	LEwd/5ysVMmjGwtqFaKF+LgmCfYSqnE9usOmhyRmaMb18M0bG52ftL/pZ9rnSu6Srrfy86
	TM4VPeC1OislBjAO+HVQQUn378Pd8G4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pi9XVoeZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3bL1-aAYKCC0bNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3bL1-aAYKCC0bNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3121cffd7e8so3148297a91.0
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 15:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753136493; x=1753741293; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5n3DfUq9+hEwNPgG2lSxnRPPih9D3owzTYtcCu6Ji3E=;
        b=pi9XVoeZhlOgX0FvosEztZdacIvZjZ7B1SzDtvCvfwMCTQl/TwvwDJoSbCQL+/oB53
         nwiHcsF+UC3yssSlEcKtF+/zW3JyDrZxzMSdaWJTFW3aTecadqnGDQqcwn+tGDPzYMr6
         SjALQthYCVzaY3ck+SS2NL9b1iP9PcEZOUOCe920W3l2ltK6lpA/lA5FlwAmaqqPfD6m
         F2lRe2hFdN33u/+myzIbVeG1OoYaAb2+c2la18z0mKtr/K1x+u1V3p3KjpAsggQzq/VW
         NsBkwRyEB9iTIZhJvEduswVa2N6uECSR5g6FYqS/c44UeoXq7Aj0eTP9PGhoRb8KhySz
         WTag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753136493; x=1753741293;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5n3DfUq9+hEwNPgG2lSxnRPPih9D3owzTYtcCu6Ji3E=;
        b=Olyi5vLx8hsLY3w1kZYhiBSafYX4mrdCiBCY2in6+Hqldfxoy/VUYEBRRvQ5/cN/w8
         67cX13vI+/z4wJsBR7yD9ox8S1Wpgr4ySr/90BRe/A89nqLalZGMody3cQvlFDw+N+7a
         U7sd66v/sKTbbiP41wIrrJWV4JZz/ms8puNmRhCSsf1FxVifIvj8JKP9Ns0OC3lHFQ0j
         zbUu6eyntGgHojQvHQkbvZhf829cDhC/bGlxrnX/vyJ2BQe7vTZ/8BZguEWxTIX5QbU8
         lTVWejN8TJoWlA+NhjMD7I1nKjzRBCAiFGXdFhbYqVyKyrHT8+5Bp3lW0dG86BnTztBE
         GhHg==
X-Forwarded-Encrypted: i=1; AJvYcCXs+DNYUGUT0i6gsFmJyf9je8xq1Zr0RDnwNSNVlpxwAUR1i42+0AtSbcqO8SDVbbcQdbK7bykftg==@kvack.org
X-Gm-Message-State: AOJu0Yx6+NS9BFokxDwcFrPc/PtqS1ghUfuc2DYJGMJ/CLB6pOEEwGAr
	1SZ5v6eZ/tWXOMX2PvSiN/cUgkFEiv2tHnsiuTqvyrJOklipaNYWh7+JgNKov9+/g5zOAxwGB3p
	p60ff0w==
X-Google-Smtp-Source: AGHT+IGVYoYyFSUy6kkP0xnDMkijp28Tq63+5NFoZx5vd/eebqwBJh/r6JAT/xPGMl6C6FANHbZf61n9I0k=
X-Received: from pjk13.prod.google.com ([2002:a17:90b:558d:b0:312:ea08:fa64])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a4a:b0:312:f650:c795
 with SMTP id 98e67ed59e1d1-31c9f4a80b1mr26427314a91.21.1753136492866; Mon, 21
 Jul 2025 15:21:32 -0700 (PDT)
Date: Mon, 21 Jul 2025 15:21:31 -0700
In-Reply-To: <CAGtprH8H2c=bK-7rA1wC1-9f=g8mK3PNXja54bucZ8DnWF7z3g@mail.gmail.com>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com> <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
 <aH5RxqcTXRnQbP5R@google.com> <1fe0f46a-152a-4b5b-99e2-2a74873dafdc@intel.com>
 <aH55BLkx7UkdeBfT@google.com> <CAGtprH8H2c=bK-7rA1wC1-9f=g8mK3PNXja54bucZ8DnWF7z3g@mail.gmail.com>
Message-ID: <aH69a_CVJU0-P9wY@google.com>
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name, 
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
X-Rspamd-Queue-Id: 3066A1A000E
X-Stat-Signature: uwrjhsgapai14qnx9zc5s3ibw7xu9h8i
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753136494-637932
X-HE-Meta: U2FsdGVkX18bG3WUWB04eZeGDkUvOr9oCKmOvvkLMXHKIeG2oEDjSueW5rEbLXrZcWRsnqI3FejLlDcAsoKwSWy5JaXT+m2xh4TpNIvKLxQX5GMPBftF/eoooeU47+1ws8s2caOK6g7kt21DIiDjoJoQSuEuuhcJeh0Nsdtu2zM4mY6mWMrkZYGYcALCyaUaqtX+ArN6JLey+a1VMDuH9r34TZLZl0tl1RHlpFJQeuoMNW4eanXXdQAk5zBBsFWJmukOZ1BjOA+szqH2+bWtEMBtF6b+88wkItU13IMKlvNF687qmJVEoyzhy4Webhk8jOGs4A2/cVIeqFkeryhSbIbGqIEHnsVobcel7pvDXhMsIhK1yZSkoSVmbpLALYe9bqTeYlcLoH8eEtOEiApEnfr6CAd7GsNZEEUqT7l7IpiXYutGDdxgTRKniDaKBiYMbHJlaoMkAE/LfQKLB8Lz0Qup/WS3ZO6yh8gGZ7iCtWciPkWyoabvUJQWZeUbIq1zG7NartUIuq3I9AnFW/FvPHNTVDFJU04ZZs76QpeSnRF61w7Vxfr6ECWolLnY3kaiAv9rsuxUbE/fIRPPCQGSBsWpLQ3107yBr3F1QGKpnNlE4Pwgd+dPaIdvXUEM1qXAR3xuYOrPwWsgJWwvSUoRZ+Je0/UUKeCV3XgRASUwCcbqZGgFsMCuyZ0DwPSEa/ns4ETiHnjpAjLqIP05Hop8+I4EPiq+4onPPlytGbbdnPmDmlr5kSJ3AxgtDgVKArHwUIFrmoKyFICrg38LIL1qiEQHBjXpIVc2w0PFqpGjxXGZbMweSlxJWbp2buY9Day1CJt0fA8B2QoQD6LBQ8xbvBnb0KN8Wy8SJfR1XpWhUYfcShA/Ul3mZ5WxzKcwxPV0AQdTMnsU8R8mr67ylNXixg/t3OPiG01ep66zPqJjaRiMY9aTbavdIRukLHJPlxBCbC+MPtbIYEX0BMrH0Lq
 1Yk4V+WI
 TlB5MPy/lq9Qqoh3Kv0TFDxigrYUaAVhXNdV/R7LEIrKqWDfR2ZHQ3Lf3NDS9jwPnzPDooefxZC4Jd1VDz5zggyEbYbZG7qG2yGfptZUv6dev07eeG9SpSdkJVAcbKLok6WAID0KxatKigTc7h8/38bSHcmf4ArUj5HTFZWcOnaqE7CDYcZRRSM6j/ND2/VLFygeGa7Xp1fFsmYAYGK3/6vYbPROvf7dy1hVf+gn2lo2MGj9mKMNaUrr9FwYm+Uw30VNNzAWLZTHrHLCpOPgH45U4R2zP1Ei/NkC9e9OQpfrZCLy28H08u6pN8d+ks5AmBj9y6RGvIYHVkdHocEizODV9P+nOETmJzHUBe0mwxCjkeWp2r7urEMJO1wIHVYPyLdIo/SdUH9lBSXH5UczjBjR2H6UvFvO0RPOZrykA5yBtEDoiYRpw5QFluCcd51kkKF+ldsG7jKX0qqQJ6PAgPU4suyHqiAXE8zDfG/itTfOZKHtXEAnDOrDi4XCUptnaTCRoDf+zPzLpIq5ot7APL2MdpbrXR4gz5US8iCeu48fC8/wqd3Sb0YhXs/M6UPxfkyivzsvOFtLxJM8rl0Q7EKZwQSg882gg0x2U3rAPCYK9aM/4uUmKbUpU+b99aUM1sbQXEGCGC+E4OXxwChd37TfeCp6LAn6I8S7VOGHAa4mTFg4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025, Vishal Annapurve wrote:
> On Mon, Jul 21, 2025 at 10:29=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > >
> > > > > 2) KVM fetches shared faults through userspace page tables and no=
t
> > > > > guest_memfd directly.
> > > >
> > > > This is also irrelevant.  KVM _already_ supports resolving shared f=
aults through
> > > > userspace page tables.  That support won't go away as KVM will alwa=
ys need/want
> > > > to support mapping VM_IO and/or VM_PFNMAP memory into the guest (ev=
en for TDX).
>=20
> As a combination of [1] and [2], I believe we are saying that for
> memslots backed by mappable guest_memfd files, KVM will always serve
> both shared/private faults using kvm_gmem_get_pfn().=20

No, KVM can't guarantee that with taking and holding mmap_lock across hva_t=
o_pfn(),
and as I mentioned earlier in the thread, that's a non-starter for me.

For a memslot without a valid slot->gmem.file, slot->userspace_addr will be=
 used
to resolve faults and access guest memory.  By design, KVM has no knowledge=
 of
what lies behind userspace_addr (arm64 and other architectures peek at the =
VMA,
but x86 does not).  So we can't say that mmap()'d guest_memfd instance will=
 *only*
go through kvm_gmem_get_pfn().


> And I think the same story will be carried over when we get the stage2 i.=
e.
> mmap+conversion support.
>=20
> [1] https://lore.kernel.org/kvm/20250717162731.446579-10-tabba@google.com=
/
> [2] https://lore.kernel.org/kvm/20250717162731.446579-14-tabba@google.com=
/
>=20
> > > >
> > > > > I don't see value in trying to go out of way to support such a us=
ecase.
> > > >
> > > > But if/when KVM gains support for tracking shared vs. private in gu=
est_memfd
> > > > itself, i.e. when TDX _does_ support mmap() on guest_memfd, KVM won=
't have to go
> > > > out of its to support using guest_memfd for the @userspace_addr bac=
king store.
> > > > Unless I'm missing something, the only thing needed to "support" th=
is scenario is:
> > >
> > > As above, we need 1) mentioned by Vishal as well, to prevent userspac=
e from
> > > passing mmapable guest_memfd to serve as private memory.
> >
> > Ya, I'm talking specifically about what the world will look like once K=
VM tracks
> > private vs. shared in guest_memfd.  I'm not in any way advocating we do=
 this
> > right now.
>=20
> I think we should generally strive to go towards single memory backing
> for all the scenarios, unless there is a real world usecase that can't
> do without dual memory backing (We should think hard before committing
> to supporting it).
>=20
> Dual memory backing was just a stopgap we needed until the *right*
> solution came along.

I don't think anyone is suggesting otherwise.  I'm just pointing out that w=
hat
Xiaoyao is trying to do should Just Work once KVM allows creating mmap()-fr=
iendly
guest_memfd instances for TDX.

