Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BCBFCAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 20:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4C0A8E00B7; Thu, 18 Sep 2025 16:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FCAF8E0068; Thu, 18 Sep 2025 16:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C4408E00B7; Thu, 18 Sep 2025 16:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7596A8E0068
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 16:21:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 305F9592DC
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 20:21:37 +0000 (UTC)
X-FDA: 83903491434.29.6E0D539
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 576BC18000A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 20:21:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HieRAthe;
	spf=pass (imf16.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758226895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvjczul9VVE3sbRWmkp0E1TQIs9R9iXx0UHgTzolVVg=;
	b=kl+5JVThmuDF/TIgGqfMGJh5qij4UjOkzCZecCAAl9VJ9G/Ew1umb9ntPgzTG3PdXgJTwF
	f0Fvr2XdRuYT12l9FVsVMb8/OJuF3cWOXNschVXFqeNtj0Z0Uqy8Gl3raqXwbjwdDyg/Dt
	xqEpmAbZjJceYH3LS5m/rWhrqExRq9s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HieRAthe;
	spf=pass (imf16.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758226895; a=rsa-sha256;
	cv=none;
	b=5xrQnJTR6Gt3dZT7bASI8CY87BQsbuI3doNgNnMYhwUpqHTHQuOP3djo4721javP8zvAHk
	WxsSnpq8ZvZN8thPHnd4flp5kk7Z0VnuHTd3Bmx5RbTyCH1+Zc0c77ZmXVchoXenW/LMpk
	P3XGy/eLq0tqkxh3Mh/bkipjNgrd1vo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E57C044BD4;
	Thu, 18 Sep 2025 20:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F889C4CEFA;
	Thu, 18 Sep 2025 20:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758226893;
	bh=qP3MQwM1EJ5Gl9Y7CUEowkPmBRxV9f3jSqmnplG0VdM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HieRAtheU5vVyO0d5vlDxkmm48RkpTsr//AeI0V2zteg8QCexEI2Jtz0O8TSNFUE9
	 kUquWWzeDw7+4JIu6biklnBx4qNpB7U9ffrqjdd0TP4OdcxbkyOb4Dqmt6Y/91NB9C
	 A+ux3oIEFvGRN9Vp5TWR//wTmLWE0W0w4A8QFbk1dEWHrrmQOn4joi/a4SlFm2120m
	 PuW6/Y44NqxWjR7/4eDN/f0TVQ1Vqfw3FIF5333VpqgxYlPumDb18T2C+EvlJ3fAr6
	 f1oroXfTYkRKJMzwPsh34GBorkUDauXKVjBQoKTeoNiY5+6DuSY6yM4r3t+km9GrJK
	 UJar4yMGrmVJA==
Date: Thu, 18 Sep 2025 21:21:16 +0100
From: Will Deacon <will@kernel.org>
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "Thomson, Jack" <jackabt@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>,
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>,
	"willy@infradead.org" <willy@infradead.org>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"kernel@xen0n.name" <kernel@xen0n.name>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"alex@ghiti.fr" <alex@ghiti.fr>,
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>,
	"gor@linux.ibm.com" <gor@linux.ibm.com>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"trondmy@kernel.org" <trondmy@kernel.org>,
	"anna@kernel.org" <anna@kernel.org>,
	"hubcap@omnibond.com" <hubcap@omnibond.com>,
	"martin@omnibond.com" <martin@omnibond.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"brauner@kernel.org" <brauner@kernel.org>,
	"jack@suse.cz" <jack@suse.cz>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>,
	"ast@kernel.org" <ast@kernel.org>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	"andrii@kernel.org" <andrii@kernel.org>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>,
	"song@kernel.org" <song@kernel.org>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>,
	"kpsingh@kernel.org" <kpsingh@kernel.org>,
	"sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>,
	"jolsa@kernel.org" <jolsa@kernel.org>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>,
	"jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>,
	"axelrasmussen@google.com" <axelrasmussen@google.com>,
	"yuanchu@google.com" <yuanchu@google.com>,
	"weixugc@google.com" <weixugc@google.com>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"devel@lists.orangefs.org" <devel@lists.orangefs.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v6 05/11] KVM: guest_memfd: Add flag to remove from
 direct map
Message-ID: <aMxpvI6Aj8mDsRNm@willie-the-truck>
References: <20250912091708.17502-1-roypat@amazon.co.uk>
 <20250912091708.17502-6-roypat@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250912091708.17502-6-roypat@amazon.co.uk>
X-Rspamd-Queue-Id: 576BC18000A
X-Stat-Signature: kzkfu4oz7bcuhnsgzyjtoras5f39ui6p
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758226895-842269
X-HE-Meta: U2FsdGVkX1+gQ59p90Qm+0kJ2UCv1/HbeWnVTy/s+VXt4R6sqgSNWtljhonU69HwT2pYx26G0BD4YckWB805e6yr4Hcxz6UpInxBnhC5x7W+4JcMkiNVMTJXj+iXFac1lCFx0+JR8mltZoUrNE1JsRnta6kbbv9E+7GYwZXGQlIGdAf9O94Gxx0ZoLz/fNOF7mWKIslR4QtFFlR5AzHhND52Ee1K8M2foWdlbqtvhopP8l7duQssukbJXp97cUajI2B0kUXr5+xx6vt1x5KmSGKnwS/1X0d53gjlBc644nngtSWLhFU3J0oTmQDIhzM2iQoONruyDNrmVbOjxS2cVyOZd0GCAPUCiYTy4OAda/wfZ8ICULHNpFu/6YU0xE/UiZZChYmasITdD8BkETgjpbuP0Vfus1+ZkWX/8D9/+57Xumxf5dETuqUfAwDZxtI5DJTirDAwjLi3pk2y/89RUL5cbO9NLNtCaI6dCrPUZgQRGxNJVb6zrxhVwIcPvcqTeXITRNEOMgr509m/op67WUeqSSfc0V/J9fn4J/YdhONZTo+LWSj82k/SAKQISgZUpLTPu3HYFFxcuuG7dNUW0gG7AvPvPx/3nTYOuvgk0aUuIzUVtJX2XK/Fp5cHX2gKJ/KIpy/noVXaLCEPD5FaPkNwGkbB0pxGkIotRTAiLnRDGvJcR9T74cxw7rNAKQk14fGrO4KJWctfBN0XZQ8VZg/6zN0m/uo5DWbq5Rz1RzJd7hVo80B4Ol/4elv4FfdiUdLdSx/B1BXdmpjGAxPtBHoHT3b3HJ6njkR8BFtYHMQj9NztXiwXZdcjXbQy9hvz6bjZHWTSR129OQpcyyAbX8bQEMUbBkHolnkVYLsGvbIIGahxu8CmsQb+vXjG5xFwRmM0/4iuAdViqNdtzerCfN8VJBP4jsjHWrH3D+ejK13vc3FxYf4rzsy4aSHzFEBPIP3zZqx72MRSROqsa3m
 pBLx5CLY
 lWYBPE7GBhrc11HSsaQJ/FwwQqUIKeaO5gecTTEf9sSEkEP37MT3tULU1WrdAb+hpB7SKO4KsZk7KEDm4rGAx4b9XKs5GYI5fpmOX0CeGGsu2PJkbViWI0PrkZ8wgG/0bSQO4cXpuBoNRaaAgEvtQAMTvkEBsBkTEtOsUue4nLfLqglqmpjYbXr1PmVI1K1GyeDBt79Z6xh4Gnp254bZUgAL7HjNNjl/Aky8KhNPi9ix80RT0dKVxqdntsNVYHx4qmbZbYrpO8GMNf/TW9VpOVK3UWY8vmVxg3upMLI0j+c6X7oqXKQjB6bSuiH3Z4vwLEZxcDrUJ5bsmMCI6BmZCJQLbzJryDq8u3pHbIMXRWpZtU28plSM0FTdTEnyRFy+c/RwcNZMrXlyRGT4VkSG4C7FMnY/39LDKSF4l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Patrick,

We chatted briefly at KVM Forum, so I wanted to chime in here too from
the arm64 side.

On Fri, Sep 12, 2025 at 09:17:37AM +0000, Roy, Patrick wrote:
> Add GUEST_MEMFD_FLAG_NO_DIRECT_MAP flag for KVM_CREATE_GUEST_MEMFD()
> ioctl. When set, guest_memfd folios will be removed from the direct map
> after preparation, with direct map entries only restored when the folios
> are freed.
> 
> To ensure these folios do not end up in places where the kernel cannot
> deal with them, set AS_NO_DIRECT_MAP on the guest_memfd's struct
> address_space if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is requested.
> 
> Add KVM_CAP_GUEST_MEMFD_NO_DIRECT_MAP to let userspace discover whether
> guest_memfd supports GUEST_MEMFD_FLAG_NO_DIRECT_MAP. Support depends on
> guest_memfd itself being supported, but also on whether linux supports
> manipulatomg the direct map at page granularity at all (possible most of
> the time, outliers being arm64 where its impossible if the direct map
> has been setup using hugepages, as arm64 cannot break these apart due to
> break-before-make semantics, and powerpc, which does not select
> ARCH_HAS_SET_DIRECT_MAP, which also doesn't support guest_memfd anyway
> though).
> 
> Note that this flag causes removal of direct map entries for all
> guest_memfd folios independent of whether they are "shared" or "private"
> (although current guest_memfd only supports either all folios in the
> "shared" state, or all folios in the "private" state if
> GUEST_MEMFD_FLAG_MMAP is not set). The usecase for removing direct map
> entries of also the shared parts of guest_memfd are a special type of
> non-CoCo VM where, host userspace is trusted to have access to all of
> guest memory, but where Spectre-style transient execution attacks
> through the host kernel's direct map should still be mitigated.  In this
> setup, KVM retains access to guest memory via userspace mappings of
> guest_memfd, which are reflected back into KVM's memslots via
> userspace_addr. This is needed for things like MMIO emulation on x86_64
> to work.
> 
> Do not perform TLB flushes after direct map manipulations. This is
> because TLB flushes resulted in a up to 40x elongation of page faults in
> guest_memfd (scaling with the number of CPU cores), or a 5x elongation
> of memory population. TLB flushes are not needed for functional
> correctness (the virt->phys mapping technically stays "correct",  the
> kernel should simply not use it for a while). On the other hand, it means
> that the desired protection from Spectre-style attacks is not perfect,
> as an attacker could try to prevent a stale TLB entry from getting
> evicted, keeping it alive until the page it refers to is used by the
> guest for some sensitive data, and then targeting it using a
> spectre-gadget.

I'm really not keen on this last part (at least, for arm64).

If you're not going to bother invalidating the TLB after unmapping from
the direct map because of performance reasons, you're better off just
leaving the direct map intact and getting even better performance. On
arm64, that would mean you could use block mappings too.

On the other hand, if you actually care about the security properties
from the unmap then you need the invalidation so that the mapping
doesn't linger around. With "modern" CPU features such as pte
aggregation and shared TLB walk caches it's not unlikely that these
entries will persist a lot longer than you think and it makes the
security benefits of this series impossible to reason about.

As a compromise, could we make the TLB invalidation an architecture
opt-in so that we can have it enabled on arm64, please?

Will

