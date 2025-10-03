Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 031E4CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 16:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53F918E000B; Fri,  3 Oct 2025 12:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517AD8E0005; Fri,  3 Oct 2025 12:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D298E000B; Fri,  3 Oct 2025 12:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6FA8E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:06:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C55FAC083F
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:06:01 +0000 (UTC)
X-FDA: 83957279322.15.FF69DB6
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id E6D1BA0015
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:05:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AftsyuHq;
	spf=pass (imf25.hostedemail.com: domain of 3ZvTfaAYKCB0L73GC59HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3ZvTfaAYKCB0L73GC59HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759507560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rr9Zgpsr/95Zre8MDjbJaLg4HUOz/eRCvS4su6KFtWM=;
	b=05suw/dhmmC5PJ9OsWsCbrdv9kf4NKty8JNdiv5fpVpz4maQhYvrMPJQkhvrCzwiSpRHe5
	LgwmBLeRsnyRGZl9LljEMDozajuDgzH62eVoqytWXje4Zf0zyjDIEJ9mvOKeZQv2MwjnqW
	aMlUnjlvTO0U849LDzaQb+xdCNj9520=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759507560; a=rsa-sha256;
	cv=none;
	b=d0MKsrKLnWXKm6siZZQ+26r55sUq75YYrQm+FMHAUj3PHA2x+9czlnto+sxblo7fJnI44o
	HZD3chTiB7qBd4TEzQYDd7jHBT1NSD4n2zIsFrd+k6cIBWEvpYri6cR3V2/NtkkIC+PLEv
	YWqtiW4Di2IAWMoWCyg/M/ByORBLq+M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AftsyuHq;
	spf=pass (imf25.hostedemail.com: domain of 3ZvTfaAYKCB0L73GC59HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3ZvTfaAYKCB0L73GC59HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77f5e6a324fso3921430b3a.0
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 09:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759507559; x=1760112359; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rr9Zgpsr/95Zre8MDjbJaLg4HUOz/eRCvS4su6KFtWM=;
        b=AftsyuHqQ80/ogX9r1BGZe6cbNodWPEV4Px/O8XkxIyikCpEjjJC6wQyMolXUL880f
         fu/aA2/SUbjv6T4LKKVQUWx9CkgxSbAwYlbZA1QxaDGrw0IqSkbA7kKhUQaUakS0jWYQ
         QfitnLaULEZS3PYyQT1rD1bslqTfXrZNn5y9kUc5irKxs7uKVPEC4FUAHKTE8cbF6q8X
         4x+GFIPboq08G2D49qS6+t/5E736MQkhzPIldEYbXf/zB+BZoDu7viuElAqFfQp83rr7
         6hLoVV2BtMUg98/YwGvM66EMHJjNL73c3giqyzjQuxzwMg9WZnMxULX9DaJ/Nbyh/DjN
         nZqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759507559; x=1760112359;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rr9Zgpsr/95Zre8MDjbJaLg4HUOz/eRCvS4su6KFtWM=;
        b=r7yhpTTKXSNWk1U7Cu/WU6lSKdaY+KDr+vclcs66Oo6qK8WE8g6BE7VtBzbCP8fOtm
         7O0ISnhdodgY9DUzprZTLuB9H29t8Nw0xUqktrLxDpFZ+tC5/wHhCxus4dwpBiNG8U5n
         /gfwNxj8VvQ8KunibdZuDn3dpt9n6uWeWjLC3uWzLT5vVzF7k+C6B4AJUcwTQXocaxYz
         iQRQ0ae12MeR3PbMT1LvHBpSXpij0Ar/3qhpAsEsiOOtJ15rwoMd5b/0GXVWVolUfufj
         eMnZ7q/XHiz1xSNN8fH/VDmRWCyPOATLxO4n3k6E4YdBBiGTkgDjwvDHwcPPz1Y31alr
         1p3A==
X-Forwarded-Encrypted: i=1; AJvYcCW0LymINoyGTji/HJC4KTIl1Q0+0dXSb65SNsnvJlGIKx/sP4noTrRr5o+aKuNycil47R24Wb2Lcg==@kvack.org
X-Gm-Message-State: AOJu0YxQ5r2PmSTY4LUYWeBlsy4fJE1nzeTT/VLVVfam03L+5UCyAKjT
	ngokscijxKFHIvQ6syEUuLOHk6qAWVjm7HTGmtaK/H9M9eWPdGCDNpJXBcpwOviIPDYG5wNsvgd
	5r2mPnw==
X-Google-Smtp-Source: AGHT+IGkAn/LwerysZuGwJxYNVKUT2Gz4Ib8pIhMx4SKsJOPx+xTCSenhBS2G7GLP8kza9/oaz73nVHnf4c=
X-Received: from pgct2.prod.google.com ([2002:a05:6a02:5282:b0:b55:135:7cb9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3ca8:b0:245:fb85:ef69
 with SMTP id adf61e73a8af0-32b620cbda2mr5197670637.40.1759507558303; Fri, 03
 Oct 2025 09:05:58 -0700 (PDT)
Date: Fri, 3 Oct 2025 09:05:56 -0700
In-Reply-To: <aN_fJEZXo6wkcHOh@google.com>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <b3c2da681c5bf139e2eaf0ea82c7422f972f6288.1747264138.git.ackerleytng@google.com>
 <aN_fJEZXo6wkcHOh@google.com>
Message-ID: <aN_0ZMduyGlX0QwU@google.com>
Subject: Re: [RFC PATCH v2 29/51] mm: guestmem_hugetlb: Wrap HugeTLB as an
 allocator for guest_memfd
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org, aik@amd.com, 
	ajones@ventanamicro.com, akpm@linux-foundation.org, amoorthy@google.com, 
	anthony.yznaga@oracle.com, anup@brainfault.org, aou@eecs.berkeley.edu, 
	bfoster@redhat.com, binbin.wu@linux.intel.com, brauner@kernel.org, 
	catalin.marinas@arm.com, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	dave.hansen@intel.com, david@redhat.com, dmatlack@google.com, 
	dwmw@amazon.co.uk, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	graf@amazon.com, haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E6D1BA0015
X-Stat-Signature: s9x7b5wmrsk747ighmxgxozfteyq5efa
X-Rspam-User: 
X-HE-Tag: 1759507559-254399
X-HE-Meta: U2FsdGVkX1/2QgBCWtrruHUp8lQfNt/RbFa75D23SJmegWQVo0Xaay/5UVvKQOM6ygzUpUDh3Rs+kCa3A8xXQpaNsgRfGxVchrABzBDtuzrqAJd0bBlFZG4WEOT7kta/strCNn2wFFeP1LpJNlWvaA59QLqCK5+w9tJSNv1R6Qz0azlrVVz8SMVkBI1NErIwl35A8C/bxSkxek3RiII4yFKr8Eesl3IlaWMhjmjffVjamF0kvrgGcZdW5N33hEm9Bj8BC59tg2bVrb0eyh+/CnPBaY4Uv/q/kiwO5B+ricAFI/4nFSQN9BnKxvc6AbiIYK2It8ko1fu20riR5svmT9g/G8jAQL/gZwL4eEYJ9j9RaGWpQTMbM1Ucx6OAy8lsdpdtxb6kmErxVPuS6DcBI89iJN+jkhSs+doTAD0FGgLZKoALAeFob26eMT4oWYugPFbc2TmK9QWqxAX48WP+K7yH/vuJgM+JRyGE7wQnWjfWJBC+ZD9kbd02mZYYaaK7717MMYzC9ncDfhiq6ISHbK3Sr4ETzpqBiTnfn8bvG2dLJznNM3bu6llaTJyuzNRJeNs8vIDBM+1NNPvGIG4pzJA5h/BVatJ0h9Njg5dNn0Mxeg+hbV/IOsu7oVf6nX7ZLAlI0vzIwUemAJRAIGiCY/1ee8GN3SaRdAzHOG/Rc8YXX1NvjHiQdiCuTZDseZUmEbWSf2ngbs5XjiKw4yIRVz1deov7sjitkWgMydSpX6qCbnQdVhvrVcOTolgzXQIoJdBSO2z5W5vG2q6rzGO6SfFnxSBVDNgZ1far5J8peds7rFKmlLAgThxI4/aAbOtYutxC5bLy0gIaTJ4wZ6IUjFUwNpEqtIo2Bx0faeD+kdrSqWwSGPNAZRTHsEqEeR+ppPZJ0vVRvx26X+yEG56Sm90QTIkzitKO9zd++i+EDcrTBzHpiMRASHkGTg+kQQLTlJ37wnKS+KPL4er2DN+
 DhGxhh2v
 2op2YOtby1ZZUsRF8Aw+VECrTUcVIL4zQaTMUSpDTCQUp9zRyCxcNhcgfSokU8HDRcEfHgrlP7DIi1c9qm10ES1DqAgqdB8yCtlgi6IdR+vh/IHQHBVoHKTf/ojZfJb/2ORNKYJYHoDqwIO9HRxcCbQWOFAEh/h3dEeGok4SJ5eoXkkvzE2vVqhomtS/rwl/GEbbMNBduTDnLQcDSzpNk3QSIdAahK49+t/s/w+pSPWfuskEIMvveliTBl5IPau/IWeYNmhDCyjlxllvYp7dh1VAFWkOpXhY1hrRq+ZkP9Cr1GEaBzi618SnTA03kSU44MkjbJFEiIH734AfS0ddGJuwJT+/Xr1+/zyDQrrZ6NrKT4XrU+5R9Zf9/aJnfveErkZhuaosTJuec2MV+pUeqOpmt8BCx9cB2TuK3tiiqhFjKzJcsLlcc/tB287r+o0ySisrmi1FrGwb3Egv2UsJqTSMJpGpOvsyVici9w5JxUXR3pwTC3D0ljqti6mXJV1zjAK/loo7ojDDa6o5pYih0vEqwLFlWPv/9xGrt1M8LICZywgYa5dty3y1MKzcFSICyzDUXj0KmPevtZ2FMI2CpX/NxWJgdm8jUfLB5+w/V+tmT3JBHw694jjzpYgB8FIeLbhIrnJf0Y3kts0C8oGnHSPf1aQhUlty+O0HKPbwkuiOA1N1Y9NTTdbiJefsvOLdVwcQbuWjb4mak+N8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025, Sean Christopherson wrote:
> On Wed, May 14, 2025, Ackerley Tng wrote:
> > guestmem_hugetlb is an allocator for guest_memfd. It wraps HugeTLB to
> > provide huge folios for guest_memfd.
> > 
> > This patch also introduces guestmem_allocator_operations as a set of
> > operations that allocators for guest_memfd can provide. In a later
> > patch, guest_memfd will use these operations to manage pages from an
> > allocator.
> > 
> > The allocator operations are memory-management specific and are placed
> > in mm/ so key mm-specific functions do not have to be exposed
> > unnecessarily.
> 
> This code doesn't have to be put in mm/, all of the #includes are to <linux/xxx.h>.
> Unless I'm missing something, what you actually want to avoid is _exporting_ mm/
> APIs, and for that all that is needed is ensure the code is built-in to the kernel
> binary, not to kvm.ko.
> 
> diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
> index d047d4cf58c9..c18c77e8a638 100644
> --- a/virt/kvm/Makefile.kvm
> +++ b/virt/kvm/Makefile.kvm
> @@ -13,3 +13,5 @@ kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
>  kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
>  kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
>  kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd.o
> +
> +obj-$(subst m,y,$(CONFIG_KVM_GUEST_MEMFD)) += $(KVM)/guest_memfd_hugepages.o
> \ No newline at end of file
> 
> People may want the code to live in mm/ for maintenance and ownership reasons
> (or not, I haven't followed the discussions on hugepage support), but that's a
> very different justification than what's described in the changelog.
> 
> And if the _only_ user is guest_memfd, putting this in mm/ feels quite weird.
> And if we anticipate other users, the name guestmem_hugetlb is weird, because
> AFAICT there's nothing in here that is in any way guest specific, it's just a
> few APIs for allocating and accounting hugepages.
> 
> Personally, I don't see much point in trying to make this a "generic" library,
> in quotes because the whole guestmem_xxx namespace makes it anything but generic.
> I don't see anything in mm/guestmem_hugetlb.c that makes me go "ooh, that's nasty,
> I'm glad this is handled by a library".  But if we want to go straight to a
> library, it should be something that is really truly generic, i.e. not "guest"
> specific in any way.

Ah, the complexity and the mm-internal dependencies come along in the splitting
and merging patch.  Putting that code in mm/ makes perfect sense, but I'm still
not convinced that putting _all_ of this code in mm/ is the correct split.

As proposed, this is a weird combination of being an extension of guest_memfd, a
somewhat generic library, _and_ a subsystem (e.g. the global workqueue and stash).

_If_ we need a library, then IMO it should be a truly generic library.  Any pieces
that are guest_memfd specific belong in KVM.  And any subsystem-like things should
should probably be implemented as an extension to HugeTLB itself, which is already
it's own subsytem.  Emphasis on "if", because it's not clear to me that that a
library is warranted.

AFAICT, the novelty here is the splitting and re-merging of hugetlb folios, and
that seems like it should be explicitly an extension of the hugetlb subsystem.
E.g. that behavior needs to take hugetlb_lock, interact with global vmemmap state
like hugetlb_optimize_vmemmap_key, etc.  If that's implemented as something like
hugetlb_splittable.c or whatever, and wired up to be explicitly configured via
hugetlb_init(), then there may not be much left for a library.

