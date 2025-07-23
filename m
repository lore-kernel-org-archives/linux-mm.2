Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F03C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A648E0028; Wed, 23 Jul 2025 10:08:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1025D8E0002; Wed, 23 Jul 2025 10:08:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 018038E0028; Wed, 23 Jul 2025 10:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7B798E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:08:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9CFF51A0728
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:08:46 +0000 (UTC)
X-FDA: 83695710252.22.81384CE
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id B5296C0006
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:08:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oG2suvRE;
	spf=pass (imf10.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vannapurve@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753279724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5zg3UsrTJynkIKxZEHYyGJJ/fZYYjq5XL6YoBVRz4+s=;
	b=TFaMMVu60lj3gx1RvW9yGlCqLBJs+YEBuWJGK3mIiie1ezvy7NDtkZaG565SQD/5lPjZoz
	CHOnS5IPiQTSmy3gZFNU+8di7iR9l1wJzI0Aicm5Sk5u2lYrBes8sP74c/zgesra9YiRxp
	l9r3/mDbIKLMOzORsxds6npkTm3SGHo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753279724; a=rsa-sha256;
	cv=none;
	b=13CpwwNoW+MVOsuca1nnva0otgwHLCkFC8hj8nKQOMo2ZN1djLXoApIntxMHjp9SFOEQNp
	jQNZe4IRGJJlq/2q85r/W96rjDDCAfFM5FH0PINANSmtNILQwl4Uc+MwWwWUFbMBjlKwNg
	oQsO703ytRnp2ukOXIj+4vbZuKaP1rM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oG2suvRE;
	spf=pass (imf10.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vannapurve@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-235e389599fso219895ad.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753279723; x=1753884523; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5zg3UsrTJynkIKxZEHYyGJJ/fZYYjq5XL6YoBVRz4+s=;
        b=oG2suvREE9L++1gaSs4VjJUYKWqS8BzaF1EsiOdcDsV2ECqTS8GVbov/Q0rfEfXrkH
         wGSlsmmtvvltSFoik9O6/OAXw/TkuIwgl2lfWj5VoOG4XQFcLHyouIL65P1i5P5ZPIig
         qumSTeohrGvfzG06N+tqcDCFoUontLSbhmNBAe5XWzGN/9+B+6feboyIWmMxdnUjBBiB
         MzRVX5B6Sbb+7MWtqmYDPUn0v5LVOno7W/kJScX39rbiTp4GE6zQBdV+FONnx2Xmz1AC
         CUUEEEfqGNHO9bm8TY+8O6PwjHmh2W0452CGvn5ouaTaa0Fxn3pCh5xQnG7S8GeyZQgH
         V/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753279723; x=1753884523;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5zg3UsrTJynkIKxZEHYyGJJ/fZYYjq5XL6YoBVRz4+s=;
        b=uPc2k2t8OPGq/Yl4aUhd34eqCPdfZVAMpT6iURNZhNltUoAVeXJYAg/cdgDr8d46SX
         NuEER+l04jN4BwS5guZbIoOuWP0oASjpGz9ckPAcNodLNKyJK3CyxSwcjGYk/YQxaAxh
         Dk+04QxGnZDEgq9pJjHF1Sqge3pBbeBJeP71vUZBt0wAclkQtlk1ZeDZQNYaJk+JW1hJ
         ho6jjyNJ3P5g4GyIrqzT3XtaYYhE7hMrSCosiSzXNB8uqUyzWDlYuZs959sE/dxyV9xv
         cYV3LpgAzev9kvww53edqgZVaUGA10pKA38r9B40fDL7kdaNrCw9E+IOSImE5Obw5wYh
         JzAw==
X-Forwarded-Encrypted: i=1; AJvYcCVM5stxRkIvkZ3/jyLfpt6H8c5f6mWJez8Osj3h6szNHVfThf1Vf5c7Tp3EwInxJTmx6nMntf+4BQ==@kvack.org
X-Gm-Message-State: AOJu0Yx5lhdJm+cB/5D34QR/DOZq9zw/dCDvbEHBbe9ZvcS4g3IH+50x
	0ZFqu8FZ8EcC2EgHGwcOrwkp8hVJopZZ9kqYX8sliXH4JbDIsCiFhfdC3U2hh9XiFUvz7o13Uzc
	86qmzdlv/wCdoV9JhI+jUBFM/3c+iTqrSd0i1W4qa
X-Gm-Gg: ASbGnctVVi3V6EAWgGERTOqs+G+oRTArEyVrmIFU1WKbd8NIXdthiFGy30HsiUG2wXk
	yQXVZZOoOj3tThOU4TIG5cPe4lo830y6gmKVSl/Soxf+JTSP3+rxgTGCic45x5R5MZPwV3QXdP6
	hKHLZAo6jcPGyergYzxK75eNZoIb2qYwmhUpi0FS5ZLf0xK6C7NhplwJCm8qOZKMHGEuo7vWxz9
	6cIz1QhxCqj2TrA3DL4zTOAEeGipxvnGT/YGojO
X-Google-Smtp-Source: AGHT+IGTqBd89Hz2FU5+XDL1Pa3oPTMlfNKSx7fc+kyEKrz2+R2DB3L/Vg2Q/bKXh/ftc4wQ1ninLLDh9ZPqaALt4Zs=
X-Received: by 2002:a17:903:1a2e:b0:235:e8da:8e1 with SMTP id
 d9443c01a7336-23f978e11f0mr3711085ad.18.1753279722891; Wed, 23 Jul 2025
 07:08:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com> <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
 <aH5RxqcTXRnQbP5R@google.com> <1fe0f46a-152a-4b5b-99e2-2a74873dafdc@intel.com>
 <aH55BLkx7UkdeBfT@google.com> <CAGtprH8H2c=bK-7rA1wC1-9f=g8mK3PNXja54bucZ8DnWF7z3g@mail.gmail.com>
 <aH69a_CVJU0-P9wY@google.com> <CAGtprH_r+eQjdi8q5LABz7LHEhK-xAMi4ciz83j3GnMm5EZRqQ@mail.gmail.com>
 <aH-hxiD2DwovFpqg@google.com>
In-Reply-To: <aH-hxiD2DwovFpqg@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 23 Jul 2025 07:08:30 -0700
X-Gm-Features: Ac12FXwpJ1aG0BseZ1JbWyOGHq9d8eSgResVmgCZ2LYsmpKUxZNm4vyPGOyUMSQ
Message-ID: <CAGtprH8QfPU8tByPLHL69MOhG5hNspS6zCjxzB8xM_Tbjgcs1w@mail.gmail.com>
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B5296C0006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 4zassemj561fq8qgw454191r84f47jhm
X-HE-Tag: 1753279724-435453
X-HE-Meta: U2FsdGVkX1/KucAKPGo5j/uVuU50oErB7o0CJdGXU2kfaEPFwV/4zKjAtWHr1vVCPE1fR09xuNryo3RaT/N+nplkcMZhNte5EEIOszqzSdCyhF9oDr+CB4S8kDBMN7LetOMA+pzUtwIXRXs59mog4HFHgpo5hMaUHStWO38i3lWoyN1m6Kob5M69PH5K9hxjLDq701hsromSqx3JUtL0u7jAz0lNpEGvcW4/SQ2Gu9GGX+IjwzvIwhu9tXZA4CfXpwz0KHN8nEjK4cr14d61SljCBvCSQ/rmy5BbnGKyO9BUpNwvYjjlBdjFY4LHnNz4M5mCTcLvcRhH4iBQ6NF+QA+X8TeVZHzoZnoHxyua1oMMuQdrR9Ek4HrqIpQx7f6oBQUxKrlcmth61+MtiGxByDFSU/E5IdM1iLWvyDYl7nFCrfN8Li7021J6hbI+lsh/Kih+xeunzgaloaHoGLTvnXC7xIrGfesUHerRMLJxDtbkkhKIySEK6fVeOBmhpbodjY6txP0w+MrQeQKoltJueDZ0o/0oucDM96gcEYqTJ0wR+J+jRmUUp0VA4f/i5l45eKve6Z3+HaedBQ0rKrwd3O/DxhH/cbdM9AaEbNymwV6Ugq12/gcJ5GET3J8Jcia9hDzvFkAmepwz7uYhJ+2X61VGR5H53t1BTr1IjVQK80Bu/FrylFHLRgBThqBm2x2q0lmVevkYP3QzS4l5dYcvhSuQoKHl5Ny0V71Ql0Ym7MGgvfoiXAut+YW3Qk7hL//TWL5aUNLwo9uUYiphZL2bv4BFh6+azp5TLjTG0+F3raSArEteMLjFqT1Ofg+eJhsfeoNhM0vE2nyVqj/UOkpj5A73ZI6E0A1R4Ail4EJ5X8Hr3/kWD7VKzLZSl0tpup7hZQv4fpj4mBJMgDxwlESgVcqIfPv+Rredb3QEOoIafZ+EEgV9Ar+ayFy6OaWsKRiDi5FyD2YG7TLar0ytL/v
 u7nhdBHy
 YnneZ3g46p0NbmOrLCj06CQaSAj2sA6TR02mVeTrzKI0StEBrv4c0pBzO6/dvdl3LpkqwHOfRSiWsaDUaPW9Un+KGkkCm/aJ/8doz3rYUQrawmZLR+cgENk5Rqk5V5lCzMFC4WrkTrKblgwVXABTdQP3r7tVQVGbC71GsVD/FDXi+AvMej/roLrMplyJ8ftrr8I5bi2sx86Cdjqzft4sS0gV3aFFT/nC27Uo1y5j4jdlEZ/qxerGQRLNRJ859craenoPDR62oVGk7aZvSSBFNek31ai8pOEX9MeF4Nx0uSr8Y0pGUQAPRnnHt1ueIECtCks3ds6oY6NqkjGUXDPz6lhFDFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 7:35=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Jul 21, 2025, Vishal Annapurve wrote:
> > On Mon, Jul 21, 2025 at 3:21=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Mon, Jul 21, 2025, Vishal Annapurve wrote:
> > > > On Mon, Jul 21, 2025 at 10:29=E2=80=AFAM Sean Christopherson <seanj=
c@google.com> wrote:
> > > > >
> > > > > >
> > > > > > > > 2) KVM fetches shared faults through userspace page tables =
and not
> > > > > > > > guest_memfd directly.
> > > > > > >
> > > > > > > This is also irrelevant.  KVM _already_ supports resolving sh=
ared faults through
> > > > > > > userspace page tables.  That support won't go away as KVM wil=
l always need/want
> > > > > > > to support mapping VM_IO and/or VM_PFNMAP memory into the gue=
st (even for TDX).
> > > >
> > > > As a combination of [1] and [2], I believe we are saying that for
> > > > memslots backed by mappable guest_memfd files, KVM will always serv=
e
> > > > both shared/private faults using kvm_gmem_get_pfn().
> > >
> > > No, KVM can't guarantee that with taking and holding mmap_lock across=
 hva_to_pfn(),
> > > and as I mentioned earlier in the thread, that's a non-starter for me=
.
> >
> > I think what you mean is that if KVM wants to enforce the behavior
> > that VMAs passed by the userspace are backed by the same guest_memfd
> > file as passed in the memslot then KVM will need to hold mmap_lock
> > across hva_to_pfn() to verify that.
>
> No, I'm talking about the case where userspace creates a memslot *without=
*
> KVM_MEM_GUEST_MEMFD, but with userspace_addr pointing at a mmap()'d guest=
_memfd
> instance.  That is the scenario Xiaoyao brought up:
>
>  : Actually, QEMU can use gmem with mmap support as the normal memory eve=
n
>  : without passing the gmem fd to kvm_userspace_memory_region2.guest_memf=
d
>  : on KVM_SET_USER_MEMORY_REGION2.
>  :
>  : ...
>  :
>  : However, it fails actually, because the kvm_arch_suports_gmem_mmap()
>  : returns false for TDX VMs, which means userspace cannot allocate gmem
>  : with mmap just for shared memory for TDX.

Ok, yeah. I completely misjudged the usecase that Xiaoyao brought up.
You are right.

These are two different scenarios that I mixed up:
1) Userspace brings a non-mappable guest_memfd to back guest private
memory (passed as guest_memfd field in the
KVM_USERSPACE_MEMORY_REGION2) : This is the legacy case that needs
separate memory to back userspace_addr. As Sean mentioned, userspace
should be able to bring VMAs backed by any mappable files including
guest_memfd except mappable guest_memfd is not supported for SNP/TDX
VMs today, that support will come in stage2. KVM doesn't need to
enforce anything here as we can be sure that VMAs and unmappable
guest_memfd are pointing to different physical ranges.

2) Userspace brings a mappable guest_memfd to back guest private
memory (passed as guest_memfd field in the
KVM_USERSPACE_MEMORY_REGION2): KVM will always fault in all guest
faults via guest_memfd so if userspace brings in VMAs that point to
different physical memory then there would be a discrepancy between
what guest and userspace/KVM (going through HVAs) sees for shared
memory ranges. I am not sure if KVM needs to enforce anything here,
IMO it's the problem between userspace and guest to resolve. One thing
we may need to resolve is that invalidations of KVM EPT/NPT tables for
shared ranges should be triggered only by guest_memfd invalidations
(This is something we need to resolve when conversions will be
supported on guest_memfd i.e. not for this series, but the next
stage).

