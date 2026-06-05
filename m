Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98A20CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 19:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F126B6B00A3; Fri,  5 Jun 2026 15:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9C906B00A5; Fri,  5 Jun 2026 15:12:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D650B6B00A6; Fri,  5 Jun 2026 15:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2BCB6B00A3
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:12:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E247C1584
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 19:12:27 +0000 (UTC)
X-FDA: 84846805134.30.9B82118
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9EE18120005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 19:12:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q+IVvmTy;
	spf=pass (imf29.hostedemail.com: domain of 3lx8jagkKCLoyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3lx8jagkKCLoyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780686745;
	b=faIe47SgZei0f22FZCnLcmV0novaqWUQQFOw/8gEKVG41huN6+ObiNmFQdrEPzI6psGILG
	Ap7fXSyJ8218rejJmSbb6X8hDkEXlDN6s4Tnp6Jyz1bRYRVzxoikyseOipJTZKLSkCmV4a
	2d7hKMPQ2bYd5zEgl0y8Ui+3JcdyvPw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q+IVvmTy;
	spf=pass (imf29.hostedemail.com: domain of 3lx8jagkKCLoyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3lx8jagkKCLoyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780686745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJLAr1VP/c4bf762M8SOjS2IK8uV+iAanaOJxy7ql2U=;
	b=jWQy8FagNkdpc7i2eVcjgB2mHcg5/KzZdWpb2FFVs2j5qfaNGTPP8w5YxN0qyrQV2F5wzk
	et1Hppb4hlNHE4cA5XtqGc43B5Arz5s2rFX4rBLGg73NJrDgBhENm8Z60juzqtf5tzNzvu
	dH7CT37Scj07PP75KZZRS3YejrCmiv8=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-68c6649a135so393272a12.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 12:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780686744; x=1781291544; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DJLAr1VP/c4bf762M8SOjS2IK8uV+iAanaOJxy7ql2U=;
        b=q+IVvmTy+TfQRIi07to+/3L2zrkrKrEwcsdI8mrLRSRNwSVcAC4LfwZXCJg2kvypDN
         8f/7OEoru1J2/3S1pM7/Yn0nagb/aMTNFXzvXeS/auc48d+C5/vF9ENXUMh29E09zl/q
         cPjXCuMCVbRR/WPDZ4Qchlhn7vmeZXL6LNKj84LYWKxgr7Z05Zwco/AGpw/5Tgf+c/Oo
         KPtRZ2Wut2iEvJXacN76zK0VUEWpsqoYG6Bxc34SuufbLgV4OT1DgWkz3jOIay63YyJT
         UBFyqafRqrdzehHRmDzGFGOM90iYTaU4z8oYrnZqOCqkzyX4GbKXLgJr7ebT7iiYX7Co
         W1NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780686744; x=1781291544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DJLAr1VP/c4bf762M8SOjS2IK8uV+iAanaOJxy7ql2U=;
        b=SHpzuf1202hQceeROvnM5vE6ASMuS6tc0WFfR+86HfrJMcPvGMm0pXdKThXFd2RI3o
         o5LcGQfLaS2VHxDgVHSaaOLS1L+hJ6FHub4xvD5SMiWPKv1IQM9m/yDsIgD7kHjv98nZ
         nSPtbDqW8iFdrEkOJwjHxh96eyuutNCw1NeI5LEFH04ZktFjHMajKXkiA2CY31E8SqNS
         gjDemlHk7OBTI9TS9pCoTCWeoWvGIa4SeOxr3puVzJrwKoCsRgomMOEthZo1neJFf/WI
         p4cuHn86Vx7uhgFmNntspofU9WLEp96b34UqeRJmsdGpeS7aN+ta3SyXROiolJgH+Lhz
         xdHg==
X-Forwarded-Encrypted: i=1; AFNElJ97dV/g4BEz3XojGlqwCnnnhe9fAGATNGOmgDKT5zWiQ3wKM2PVT3r+R6A4MV0SmFCyi+kGvwVmkg==@kvack.org
X-Gm-Message-State: AOJu0YwJ7NUTJAA7ndLMYuMh8Cl7Dsaq6+NdC4o96AxQ8VupDItpqmUj
	mR0uuLvxV6JGJXtH0ibIRqItgshP+zU7Gmw7tw8ayqeU8VmKR7zhx1esYl5vVLHTMO5XArS5Pm8
	+YzHgmnfepvebxh765g==
X-Received: from edbbe11.prod.google.com ([2002:a05:6402:1a2b:b0:682:c35f:2ec0])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:1eca:b0:670:9ca8:1eb4 with SMTP id 4fb4d7f45d1cf-68fa503ad3amr2448684a12.12.1780686743590;
 Fri, 05 Jun 2026 12:12:23 -0700 (PDT)
Date: Fri, 05 Jun 2026 19:12:22 +0000
In-Reply-To: <CAEvNRgHsJbGz8k8vgCn_HSxeeQ8agEm4oBYQQ0+b3gFb-aVokg@mail.gmail.com>
Mime-Version: 1.0
References: <cover.1779080766.git.tarunsahu@google.com> <9huzwlwnbgdd.fsf@tarunix.c.googlers.com>
 <ahmbVaCUcBrYK8qO@google.com> <CAEvNRgHsJbGz8k8vgCn_HSxeeQ8agEm4oBYQQ0+b3gFb-aVokg@mail.gmail.com>
Message-ID: <9huz33z06bu1.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v1 0/8] liveupdate: kvm: Guest_memfd preservation
From: tarunsahu@google.com
To: Ackerley Tng <ackerleytng@google.com>, Sean Christopherson <seanjc@google.com>
Cc: axelrasmussen@google.com, mark.rutland@arm.com, skhawaja@google.com, 
	Mike Rapoport <rppt@kernel.org>, sagis@google.com, Jason Gunthorpe <jgg@ziepe.ca>, 
	Shuah Khan <shuah@kernel.org>, corbet@lwn.net, dmatlack@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, vannapurve@google.com, 
	Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, aneesh.kumar@kernel.org, 
	vipinsh@google.com, Alexander Graf <graf@amazon.com>, David Hildenbrand <david@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9EE18120005
X-Stat-Signature: r9jn4s9qxasbd9i1cz46qu3nr91amt7y
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780686745-623584
X-HE-Meta: U2FsdGVkX1+o58C0j9AP+/JhQC6exXief37Nzk2JuXbBdR0o3L6hyj9ATj0niTS/2ONCfDjKn9Ll77E4GaFphGe/a0xDr4GkKMFkhEQaC2lgCrvz4fwlUE/S3zs36DGq9DlCW2l68UMbUNKAW9GL9SZZn9U4s7erCvdjn65mSftSUifRaoU6EoaL6SuKbcqoekgj+/g3zCwn1F3SosoREP8Q4cbd4/dH3pCi29bFrtlp3qD1PFQdi7Rcnrd3RP3ShggQAFuNnA623gQzx84EtISTNMjhEqpvVXmadLEzZIwU+DFO1yGTM/SdnPkwYg0pzU0Y7Xwq84EoCKxPTkBwef1rtVs+w2sbCVeifP0XpZnIANqk05DK7WzNEyj1J3IbslSiN7giUPZecSRL6IjIdaoBLh1HhhDmvJ6u1x/4V2VPMadAwc3OgnuyvuZ/VI36AUrQ+BQAOP86O28Z326h2z+WrAJbMNP8u3zMcz4x83kFOCMnlaXRsaFz2F8Zx2YJsZ488LZxRrdcUhl/7hcC1rSvjb1Pd2qx35BN66NpuD+iO/DLeuywpA8foExQUO2ymERxJpxRAynEIwxc436yImP1XBO4ldMlLEmsX9mXBiwq3NAKFomUs4vCgmfOiyyxD/fNbgkfIfn3BZfeBd2tsN7YtxijZ3b/bGXJMI4m4VVoTIzC4VQltElJIkoAWfihcNssimeJYRPVDd37Cm8Onx4M+O8BiTLCEXPDqvhGIefypfDvxykvM0QYIw9Gh2ibRyamW5DExuwssFkoggBJince8wU/e5mSw4Kuz7i29Ej61gRwpZSJa1jdrIu+YA3yIZJEc4Mnj05fdy0khZcMyb0C67movulLbN6akhqOo11W/VnSm+lQwNmYpOMwuZKTajzn8INUS+Z4vN0qXFNeWa/NvMu+UbKgHpvZ97WgN9FjMXbMhogR2mJvOED4rZk6MKkPdggYnYQ14k7zn36
 iiKvnUyz
 r1lJhEf3HI7u2qbdjfhbm1R0xjwvQO6QSfsMbWsziq5O6PhIYxJShErHxFXPjg6WUw5scJzP8rtwMZexeqzSK/dIPX7A2PuCLTCSYNdUHvrTy04HuTpvHAGkouM2RHZXEgc6S+kdjXJyuxAQ4ZAOsNfwHeyrMefv/XFTOHG4IyiJlT6WLGa43tILQ30phgjQp1ztJ0KUazsxdKAQ1T6Z8gBdHDJv1U5/duSCDZmlk/UngcvW4NOZA7/BaVEpjTdQ21WXmih++PPuG6MT58GHREbnfK0XP200yrOA6ZB2iZVxfXLYeKJ2XvY583TWrsV4q1Mzv6SZ3jDBy7FHR2VRGYehPf//odDfdc9rAFMGLmBIu9fXY42BtYfAydsTPxpRXnzpCtqlAQXHat24imsZwoxZkZNnRuetX+Y3pcneRjEQZobm6H6Z7fBUrBaEWLBNTnsApz1ZHN0TTbhYzgOMcOqy1+dpHGaHb4KvrvKlRyA+jrucg0OQapByjT+qrhK0E4G/WPkAsipcQ8O1Xgl4HKBaRnkWImpYjP6YD2pzgDMRbLafwzOR8eFTedGwmzZtCSXxSucXQU736q+ZVdHvdjC4+gvCwYdnoKaO6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi,

Ackerley Tng <ackerleytng@google.com> writes:

> Sean Christopherson <seanjc@google.com> writes:
>
>>>
>>> [...snip...]
>>>
>>> we have one open Question left:
>>> 1. How to check guest_memfd is fully shared.
>>>
>>> [...snip...]
>>>
>>
>> Given that lack of support isn't going to be limited to _just_ guest_memfd,
>> simply disallow preservation if the VM supports private memory:
>>
>> 	if (kvm_arch_has_private_mem(kvm))
>> 		return -EOPNOTSUPP;
>
This is a good idea, I have implemented it in V2 (sent it recently).

Below, I have mentioned a detailed analysis. Please let me know your thoughts.

> Makes sense. Tarun this was the other option that I was suggesting when
> we discussed offline.
>
> I think (?) it is possible to create a fully-private guest_memfd for a
> non-Confidential VM, and even after conversion lands, for both
> vm_memory_attributes=true and vm_memory_attributes=false.
>
> In that case, your preservation series can still preserve memory tracked
> as private by guest_memfd but not used as private, right?
>
> I don't think anyone will use this combination before guest_memfd
> write() support lands, we just need to make sure there's no kernel crash
> or corruption in this case.

IIUC, currently, private memory definition is where cocovm with HW based
private memory is supported. Which is directly checked by
kvm_arch_has_private_mem and this return false incase ARCH does not
support it in HW (SEV/SNP, TDX).

So about the combination where a guest_memfd is tracked as private but
not actually private. (Created without the INIT_SHARED flags). Even
though kvm_arch_has_private_mem is false.

In this case the luo will preserve the guest_memfd. But it will not
preserve any attributes, because
1. during creation, we dont populate any attributes, so by default
guest_memfd memory always considered to be shared. (Even though no
INIT_SHARED is passed). Conversion to private IOCTL will fail as
kvm_arch_has_private_mem check will fail for non-COCOVM. for COCOVM,
presevation will not be supported and conversion to private memory will
be succeded. (No corruption and kernel crash in this case)


==== WHAT IF CONVERSION SERIES LANDS =========

In this case, we have two scenerio
1. kvm->attributes
   In this case, Every logic remains same as above.
2. gmem->attributes
   if INIT_SHARED: memory is initially shared and no entry in maple tree, and if
   kvm_arch_has_private_mem returns false (non-COCOVM), this will just
   fails any conversion request. hence preserving the guest_memfd wont
   have any problem (fully shared case).

   if INIT_SHARED not set: memory is initially private, and there is an
   entry in maple tree, marked the memory as private. During conversion:
   A. To private: it fails as kvm_arch_has_private_mem return false.
                  Preservation is safe and there will be no problem. as in preservation
                  we dont preserve any attributes, but on retrieval, when a new gmem
                  file is created, identical entry to attributes will also be assigned
                  as INIT_SHARED flag is not set. So we wont have any issues in this case.
   B. TO shared: it passes, and update the maple tree. preservation will
   not be preserving the attributes with current patches, and it will
   also allow the preservation as kvm_arch_has_private_mem is false. So
   in this case, on retrieval, we will lose the data regarding the
   private vs shared (non-cocovm). So if host want to access the shared
   memory, it will try MMAP and which will fail in new kernel (which was
   successful in old kernel as conversion happened). But I dont see any
   kernel crash or corruption.
   This is an issue with only non-cocoVM support with conversion series
   having the gmem attribute enabled without INIT_SHARED flag. I am not
   sure, if there will be any user for this very soon (is it SW_PROTECTED_VM ?? ).

Let me know, If my understanding is correct. Should we add INIT_SHARED
along with kvm_arch_has_private_mem check to make Above case 2.B.
impossible in future for the current support of guest_memfd.


