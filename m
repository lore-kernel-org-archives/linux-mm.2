Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB171CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 12:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 252318004E; Mon, 27 Oct 2025 08:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229B68000A; Mon, 27 Oct 2025 08:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13F7D8004E; Mon, 27 Oct 2025 08:49:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 00D6F8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:49:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 99256B9FE7
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:49:01 +0000 (UTC)
X-FDA: 84043874082.27.CCD25DA
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf28.hostedemail.com (Postfix) with ESMTP id D2245C0003
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:48:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=N4t0OS5M;
	spf=pass (imf28.hostedemail.com: domain of 3Omr_aAsKCFs35D7KE7RMG99HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Omr_aAsKCFs35D7KE7RMG99HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761569339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TpsH9gx/luUFZveFm6voMll1yjdVEPjIbyyyxybZ4HQ=;
	b=apbQAHqQUxspbdYKQ/YEuI2gslry6Yjsb8ZtWIHv90vbOdFIgXuvKfae0oFfjf8cTABGp6
	Rq8IujmI3d8YMbRl6f1/TdpM9nR7IU9rj0rlBBPY+9SlQtgElxVj+BzoO3XGcj4uziKEI4
	JLJGOpsXS2NjW00N57KXftWQE5qKz9E=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=N4t0OS5M;
	spf=pass (imf28.hostedemail.com: domain of 3Omr_aAsKCFs35D7KE7RMG99HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Omr_aAsKCFs35D7KE7RMG99HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761569339; a=rsa-sha256;
	cv=none;
	b=gyZGijXFX9YghUzTXeDSEO+QQfsAFk/mpLJpHpCvmIBy4JIznBmvLSKeDm9SbnkTYiXBbE
	ETOABdNMRGpInPUFbb3RnBQsoeTevzXkM9UgyZGiz4Vt4tEUK7CwQIaSVQUYH/e+SPYxtV
	UGDKfGx1yZA9VF468GVq3V03ZPR0hxs=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b6cf1b799dcso3278727a12.2
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 05:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761569338; x=1762174138; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TpsH9gx/luUFZveFm6voMll1yjdVEPjIbyyyxybZ4HQ=;
        b=N4t0OS5McZM7QWcK/z+0c/H/pJLvJmnBGAdDp9l7i8/pSy4IL4lB2+e3kHzG0w54Ei
         2txBPTy0clivsOyZsKLoCUauj6q8ciJf1ib9uSvGcc9yMs+EuotOhHgId0Eq0Bp29tDS
         9RW/ghkelCq7J5hx/ASpaIgRqVBEo67Lj38vAX5VdCPFqZBGR/Bah9fk0GWPHh1AoYuT
         xYsIW3AqaX2Xe3645hTHeqko8e94JrE3Zh7N8UHhONtuvp5mbtBJwksVmAsbGpj3MozY
         NNSllvpzWIr8REJGXkH2CM1IMenK7PrTbiNoWdQgddmrswal5bjqMakytZtIlVjafJpP
         OAzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761569338; x=1762174138;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TpsH9gx/luUFZveFm6voMll1yjdVEPjIbyyyxybZ4HQ=;
        b=tkumvs7BJGqjr7hSGucKZdq3uQznMJacVSGf351ULXpPYIHMGxiEtO6FAQqfnYP5Sk
         QJvnhMToGcpgraGmU5n/Mz17gjPkmkRAttnrwr2biVqlfWE2dzkFfqWUf7dAOIsWoQqR
         KsQY69QBxus9a8yVpM8OgMPRGke9ajLXBiB2ImbM/nv3wIDljrXqpS8V4EQ/W5ta6A48
         kHCUYWaR7bD2igxa52sSdiHI7kQEcqWZDCghcUjLQjQQIQKIY2+nsjMyek9ylT7lFbx4
         UMziwux9zrizcjbILip8TjdyvY4aOoTP+aUC5mW0KbCT9d3E9aSkWO+Wzr/01NUUTNjt
         ISAw==
X-Forwarded-Encrypted: i=1; AJvYcCX76gbIIEo2lAYWNE9n26pdE4AVXDO9QxWBzMA6+WHdfS9VDsumjMvUB5f/rWE2MvaGXbBJuGauyA==@kvack.org
X-Gm-Message-State: AOJu0YzBGdy3KQihVjSJcDb/G9CqL2p4TrT+ffpj3i8SO5NxEyWfquh4
	5qMHzwGv8uZXV6RQtQEcCk8pRldwDuK/5ljd5mLTXF4Qql8L2555j8HYVbovGQAhrpuKhubzQGH
	Thn6yau6xA9Zv8FLBVQleNzy8/Q==
X-Google-Smtp-Source: AGHT+IE8aJKICvS5xOA+BTAY6bjRh41q0VtmGZijtJh7qHPsEmdIFH7jOAvP+FEHmW/GVGRbcG4XOU1+vDg6R+rrXQ==
X-Received: from plbmg14.prod.google.com ([2002:a17:903:348e:b0:268:e12a:2266])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d60d:b0:270:e595:a440 with SMTP id d9443c01a7336-290c9cd4b48mr418021645ad.25.1761569338212;
 Mon, 27 Oct 2025 05:48:58 -0700 (PDT)
Date: Mon, 27 Oct 2025 05:48:56 -0700
In-Reply-To: <aPu7IosMI61NjZY5@google.com>
Mime-Version: 1.0
References: <8ee16fbf254115b0fd72cc2b5c06d2ccef66eca9.1760731772.git.ackerleytng@google.com>
 <2457cb3b-5dde-4ca1-b75d-174b5daee28a@arm.com> <diqz4irqg9qy.fsf@google.com>
 <diqzy0p2eet3.fsf@google.com> <aPlpKbHGea90IebS@google.com>
 <diqzv7k5emza.fsf@google.com> <aPpEPZ4YfrRHIkal@google.com>
 <diqzqzuse58c.fsf@google.com> <aPuXCV0Aof0zihW9@google.com>
 <diqzo6pwdzfy.fsf@google.com> <aPu7IosMI61NjZY5@google.com>
Message-ID: <diqzecqojyrr.fsf@google.com>
Subject: Re: [RFC PATCH v1 07/37] KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Steven Price <steven.price@arm.com>, cgroups@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, x86@kernel.org, 
	akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jthoughton@google.com, jun.miao@intel.com, kai.huang@intel.com, 
	keirf@google.com, kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, 
	shakeel.butt@linux.dev, shuah@kernel.org, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@linutronix.de, thomas.lendacky@amd.com, 
	vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	vkuznets@redhat.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: fk99xg5emwe5g3xhk545zyirddd7kbgz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D2245C0003
X-HE-Tag: 1761569339-336666
X-HE-Meta: U2FsdGVkX1/YewYHfJlnwu+Np90Y6eN0C+1uK2ZPGLQSzIiti8W6HVvGpaFHW38X5qUxFgDolvXP0CuglrWB87GlSZANeILNP2T+coCGoJWtIMsL+42gMMG1/Qt+yxMM91XZsXKPpdM6G/tBwOcgdDqA98bPmnQJMSpTIT0JuFNkGUpij8mPtFr6cmY99NOQ8OzC2MrwqPtmDjIMKSNtVa4xQK5aCbo1m3CwxBETxTGz65oGu4bbAh/p/jwmR1R5yu5yWWQ/5R9pVhUQDBAtcs5sbwp1+Y9CA3TBJJGnPJXZLiTKazOWgPSVsnXcqKtmUxdYocLvz4HjfX8lOSufKRsW6aVkysswtbx5elNW6CFAiGHyinDkKNQQ5FjKLg74daiTj/yAbWdijwRSw7fpzR3vmoUpzFAzwJcl53gY+D+dIXJs1oI4FM/R6ZWuqVyY7VCSHMRKyTXivQT+d0pnKMMTtHc4MVz0qgtW8+Wqf3t4lEtnY6yT1oVHt5bat0jO33tBGnYw/v096GRptUs0XmZeJTilWwJbVr6wVpjnqKDrCf+JbO0mlBytxQB7iVIvAMbE0B1BY9NrRFI7wPxAyUIkemj8UaCwvNnIID8LuW+rnsX4NisAJyQVgY/7tGdEN0VjiqAXiG9d1D3u15PXBdIL8yvGk/+3zWl62KsSRpJ8DVZIktHGsE3KqwbRzZL89bMgSm6wmqocy2jOBiYODEWDrUkcSM/r9LDHB/Jb9drI3oFXtFURuNki26jeShS61AGagud3XCoVm9I78qn8Wo3TLFcl/w9X0aC0KlPCoE/UQUHA//pCwaDesDGa1VLZJdPwm3MFH7c//gqZwaZdhB6omSRDGDP/rG4FmHzFvlJPcheSFZSTGNy9tqWUEOOgTGYxUlRqRKEsK80IN9+gDh26njdORdnvIH1djDShiPMu/SogqImMb1qUSVKQ7RKc+WMXBG4OpNs6PwDCtgW
 BwQD+AQH
 k+NDcFOAZl7S0pVV/rZaQsUrwMncBAZoeVZzzhj1qlNeiBDW6nUqMexK5SxU+BvNNmJpB010jqz6ZpZPLQyOgxbzc+zAnXSsY9Eb4qn/szg003aIzjNBs82bZpx1kaCU5aJDW7G+IQ7tA+OOQyKBy12VLK9DA4GSPyiV7zFRMDVeYgbwAlu0lIWEUVbO3PPzD1VnrpCtdS86z5ie5u/H39+0FV4zFji+j/qn5Rpg2XJ2NFHPWnLXu4JKsC1u7txYtqvLfquZVEpddWWOAecV7F2lnp1bY9/ktC/NXIrwJUk7UuTK/UB0Moa9nxuHy0H3DeR0CnVcOz1+4AQoPOO1Pv/QcKPeEloBbjS0GG+1C+Y4u6kxCPOAWzcXsXUukB/f1rQFjrVghGpJfT3LwHE1063DHviZfp9bL0oyg/mZlyXKulYQVVmC9sPiSp96ug2mfy858iQ06YZNJZNGjSYCj/ijQE8RLnyIQiqOR32tLNjkwJVNYyRmmie7eYFxCx/BIJqPExb6OgRCEYGd5oI5J5nrTosqqGSaA4S+hG4Gmneo3FaPiompwJ8jaOyfeZrW2DBIgzcieWg1a3hCd4BwjpNFHc0vyHbLICREM9u1Pk56HQj3VVMX5WsQoYufeR8ZSZUIW01+HJD4QjS+MsKLZt8+6U/+4QPwOFjOlYVtra7Nqy7BXEff16T7LaqWdPJzticf/Flp7ZY/7zIOqazaW/puPvnnVvw90L7VEF3pk6AWnbhVzCvQkuViNAAWsjb1lB2m8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Oct 24, 2025, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> > @@ -486,6 +488,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
>> >         }
>> >         guest_rng = new_guest_random_state(guest_random_seed);
>> >         sync_global_to_guest(vm, guest_rng);
>> > +       sync_global_to_guest(vm, kvm_has_gmem_attributes);
>> 
>> I ported this [1] except for syncing this value to the guest, because I
>> think the guest shouldn't need to know this information,
>
> KVM selftests are about practically and testing, what information should or
> shouldn't be available to a test from e.g. a safety perspective is completely
> irrelevant.  In fact, one of the biggest advantages of selftests over KUT is
> that the guest side can know _exactly_ what's going on in the host.
>
> See the usage in 1850e3da4b03 ("KVM: selftests: Update private_mem_conversions_test
> to mmap() guest_memfd") from:
>
>   https://github.com/sean-jc/linux.git x86/gmem_inplace
>
>> the host should decide what to do. I think, if the guests really need to know
>> this, the test itself can do the syncing.
>
> Why force tests to do extra work, and potentially introduce subtle bugs due to
> state being stale?

Adding it back. Thanks!

This variable should be sync-able for TDX selftests as well since the
value should be synced before the TD image is loaded.

