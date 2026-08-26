Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFD23C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA7016B00AE; Wed, 26 Aug 2026 05:18:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E57DF6B00AF; Wed, 26 Aug 2026 05:18:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9766B00B0; Wed, 26 Aug 2026 05:18:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACC2D6B00AE
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50F9F140138
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:42 +0000 (UTC)
X-FDA: 85142870484.16.F0A02C1
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5C39840003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AKSpQqaY;
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787735920;
	b=M9oU9wLToka7AuIYx6iXQW4aJdELPHrCG99OXNuWXK5GgP2BoafnDM5N3HuUmAHf/rjf+h
	0DWUzYPlun/pLO9oiqAU+TiDeom3nXJ0qlKOoyQQjssLs91PzCW4uhE2Hv2cZl4zGDkCrC
	z/cbFUmJtGCcFPgDmxq6CXr6Jx825mk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W29gLyGYJCPLMB1l2BXhwer1rQC/3q6nHb6nCzKL89k=;
	b=px6sMrr3AEewDyyUXphWK+uyZCKkAvBkKXlpH0QgkjtaJf2HgPO3bi0Q57mjEEt1eB60fe
	c88XZXPqYUT2UmgY+rwiif7ys5t1oG9i9ikZb5pS30OQuk2NgaEHtZ2y4Dd2dfachiBvrh
	gV1NZSL1q5lps1Rk09ZoWTEp1z8INTQ=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AKSpQqaY;
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-90c776f6c13so7598316d6.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787735919; cv=none;
        d=google.com; s=arc-20260327;
        b=F3qyUXR+Wgdb4yYrQj+8x7DJEpk0p5GQJxdtxT0FeivFe1toL3IRWAklUGNGjIzNaP
         +KYjJ5OuNUOyMGIIeV0+7wsChWaxoIiGaVaaJdInS6/FxrF2tGchsRM2vXiZoxhSNRIT
         YVWK7loIT4od2QwRRvzoDr3es8W28BbS449yx2CWZUdD1fv6mmAGYlEaEtbFlmmCVfJ5
         gYHoudbybhdpihNcFK1IJyXzWgb0ylLmEOVkcv6nx69+Z2t14lZAa2GBcd2zBNNSTu1r
         yJaJxX21awlRVWnooCUuotvQE3MPL3dZoyzcVP0trAO7aZkgV+i4RCW4NzXGB/AlfQ/m
         kl8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=W29gLyGYJCPLMB1l2BXhwer1rQC/3q6nHb6nCzKL89k=;
        fh=HYEP+wf7YHEFbpcI5IAPkvaYNiver386mnRVmEFMZI4=;
        b=r50xQ6S5gvymj73AYtEUBHVsbE/ZtQuFQayrDGUxARDIfywIF8CRZjZmyoMqZhKGIm
         9M0UMhz666BQpfOZ7Z0ppiSH8ShejTwfVqTuqACzg7ZNnnzsqxoO7JKmq91HImdjK7IW
         gKPoFxGi41VJVzQSHWXkA7BVfJTpyZNOnycHBEhmJpzma0Y8KEREaMATbmLD5nI7VaTl
         0RmIUdqNzka/I35WGhP1g0VbiBDM4J3G5V+JMe3jaSNDFJS2SjUm6g4u/Khub40nTyas
         0Zop9pcJ6XYgeb7bsc+dqBqX62o5ORDh52dOxpaeeyAK8Q5P9hMEvKtbztnnVJwi4jdX
         d2MQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735919; x=1788340719; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W29gLyGYJCPLMB1l2BXhwer1rQC/3q6nHb6nCzKL89k=;
        b=AKSpQqaY3xYeA7QW5H/X6ro+ci31/sTErYj2R1pMCg0OvpoiLjCio62LslOzR860UN
         EQXt674G34peDdP9OAJ3IcU18T3dhaTTVvvXjtZPyIjk273HkTYEBDQfzlhTupgmdvmz
         5RyfgYtS5Ym4dJGmRLWanqGVIbmjl1oSs+JoPkCRfmCmEkeixHOJ8ovEmj/CcXUaNvtB
         v5c1ODqNYm+ROaxg9nZSW95sIx1NECl0vMOpNlTI//moBgXjYUK0DP5jc9G++LWmQV76
         K2LbTMiucFBzc5pUA7EYrzxDR+q4PH9GCRBoFLDXwPuH6ndBUSrr5pocpp+MTLvYtQI9
         MySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735919; x=1788340719;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W29gLyGYJCPLMB1l2BXhwer1rQC/3q6nHb6nCzKL89k=;
        b=rq6j12lChEnG1vuYnFk/Nr7hNO35ecxtHBXSdPArq3/t9KzJ86rQSe0WDjE3wb56j6
         fsg8uWS4Da41jWwKhwLKAEFwZPFmp4BflPZ7Zh4F5OQRW4tVCgHOr0MRM/l0MViZb86u
         L+hFhc1oyjozjGW1v7n+h6jzekVJmt+gJlhvCr++0izGc2t2qUHNCvYfWbgY+dmFJ1YC
         EO6uwZuaJ/fyzCPJXcWX//6rHKWR3a92KD2EnLT5D9QJeFO530Au0I5xHoOmEG7u7b+q
         zN1QOWB1mg8srCATgNaq2Wr3bBnxZVVhmFBvehd4UDOGo2xesLMFgJcQtsUc9o4F68KI
         Hqng==
X-Forwarded-Encrypted: i=1; AHgh+RqMF6AnAwfRXOTsjjREDZedtJegIbYIrj34lV/BdWiECmFaDMRVixnbtt2eBGKFH87rVaVrWR5pfg==@kvack.org
X-Gm-Message-State: AFuF++nHJds8cBVlsC8qcJR9tW+dTnHTcjEbeHtmtkIeVYXU2+kyVYQ4
	N7E5CALe9lmkifaGXV8JiiWsH8PzCRId1vsjHT5yZc+l8pfteR7hP2YbQ9g1NsQkoWnxeTiE6MG
	sfOwQ5aUpmHuZNUMy4HgiVahENKxwuVAoHRSSlVIb
X-Gm-Gg: AR+sD13yOhhxW6IaywWyb8Mhz7K7i2ml+Q2pMXHVv7Z68IRCJ3VDi3dEazuaZJCn/1p
	yu5unPsv+2WjEhQC/sVsqdYBbDUCR4x6THMQm3aj/oWU/G6M7L7ErDoDE+E4+AS2IudgiO4WRzP
	SkrXWxc5mqY9p2LtwD7GwfH2Q47sXNB78qfPTjRsnq4bIHNRWmonxTVuSvwzp2nQ+ZvWP8WJLzS
	wNb9KG4/xKPQkMiBahjsROPXhBqt0RJGwJ5Fakpc4wCVRTwyKRjXLRba3NKbADctUDKglIB198k
	ohqJrQOXzBNhtIRpBAZHBwCjcavXg6CEulzhszDpQmeM0RyCcRPAplvsPNblqUrWkgm5dBP0xRb
	b+xsNVi0BsPck75G1lhMiyf36V/IOEA==
X-Received: by 2002:a05:6214:260d:b0:907:94e6:f8bc with SMTP id
 6a1803df08f44-90cc79998c3mr49415816d6.15.1787735918598; Wed, 26 Aug 2026
 02:18:38 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 26 Aug 2026 02:18:37 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 26 Aug 2026 02:18:37 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ba8d0441-b52f-4357-b2e7-1e352aa385a2@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-9-2fc18ee6d3ba@google.com>
 <13ca60c6-e154-4397-8092-09f861e90fe0@kernel.org> <cbf5f7ca-a960-4fb8-a760-2d2794eb6864@arm.com>
 <CAEvNRgGOyQHnF_b8dk8E0d7_=CcwXtYUdU3ko7Qbep+_O7UC0Q@mail.gmail.com>
 <aoZZMQ3Uc8yQWPNA@google.com> <7eba513d-cdae-4832-abac-038dcdd88517@intel.com>
 <meww2a2uf3yeevsfpicyrlg3hch2x4bsdqv2lsv3vfjxg4qzes@co5eogmhkxrk>
 <ao3lOu8-wpGTs2wd@google.com> <ba8d0441-b52f-4357-b2e7-1e352aa385a2@intel.com>
MIME-Version: 1.0
Date: Wed, 26 Aug 2026 02:18:37 -0700
X-Gm-Features: AcwNN1VwWEAXm7Hyp9OqQou024-MyvsmSKreeFDqqoFiEfe8rutDN4-Z7NuYwk0
Message-ID: <CAEvNRgFXJbV78ktsg=b4srFp1OFjtQWQGuNPjr_MmWD-wOvjgw@mail.gmail.com>
Subject: Re: [PATCH v10 09/41] KVM: guest_memfd: Filter both shared and
 private when invalidating
To: Xiaoyao Li <xiaoyao.li@intel.com>, Sean Christopherson <seanjc@google.com>, 
	Michael Roth <michael.roth@amd.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, jmattson@google.com, jthoughton@google.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5C39840003
X-Stat-Signature: jgz9mutgbss5dhb864nwu7xxabgkag47
X-HE-Tag: 1787735920-55641
X-HE-Meta: U2FsdGVkX1/QP5+eIxakHNB1T1PDtqjCS3/CtnKVidftCnfSLXU07vbRtcyBY3ZSEHn84nDSq18r3KDhYFo58AbEPC2PwofkMwGpBt1n6xHWVXZxeb2CSOG+JCTehcOs00goj80hKrqdRi647UfSWgtiHHxUAL9OHubEwlcMuyoyWZAHrT7FEWwq3PU+VQ4AeJzge+6Rz0H9hhiQ6Whm0SJ0t17c2x5SKlkDs/boIyLl+OI8CAVEPjYHKpXfxFqHyh3xjEZKgDeJkCcPhEA8lCk8PMa7WRFGKItb14Qyn2J+dfSFE9RQP/XMlezoAPe3+b/8u20nQYLiaeDHcs8yrPCZFHBD8QcMHuF4FWlIv3EsfXYKwVOW7jr/svNJKAsmBAXNNKXOVomG5J63nU05xk81+6hll7Zg/uERtcaTTHopAeqzV8teB68ZBvVbJ7lOy/CMD1NRiCwBZ8jqoEsW47ywEBpf9n7Bnib+c5zTNhXkqPCccteKnPK1Jsmni1sBXTGwsOvc5EFCiCLMSMJoCpgP2TFvJv5JtYnwr2Y7y6U5B5l4aAKaiQRPf6cBHwbNhMFs8NHbuJTA5TZfDoGxkWdnCf2KSA284vTBh2tg4EzEvfF7MN7xNKjBQJDtfxP9ZHbYRScmg4diaoNiddm3CmEcVz3eAfK2sSUd9Vxo9d587qQHl+VnHKW3k7xNURp38rbb/oCyh/lIhGvj4V5dVtXfeGzA6m9VNTNvA+do3TNuuRuB7ombBd8nHGpN3PmVmlMeXJDGS4sa7FfXdPrtmaEoKyQd/wdeQAu1zVS7tKc0wmXIbr+Y7whTl+zXoh4ckJ5dUY1DOFJLSh4RGs/uHWsbIIn3Cngh/rXcW4/z9xNvxEfscclksmE+YaJK4rSR9gmGsyA8ytUR4wUZITttISbVUhz8AUSKgrXLdjZMa4eBIp6oGpNt6m/lYftgA8buLrBZq6n+jqmbEJIRpNN
 H3Y3kzLM
 i9Sye5eSByhmOWpomJFa7cw+RFpWyMMlpyMpmX7b2+7ZfvPypFpUxsO5/+bHeWd4on5rzAx5mtbcIBa8o1EdI+/UTfUHcpPdHSW7KKQYzLf+h5vnfdtVRILxG7+7MWxMCmst41SHzZS4hADeSB4ff48nDoPTqD0aO+GwpZeeyyggwBkdQSZqUIn75JLReGBceQFCPxYWlTNIvsTX9pmACd+T66dRfdJBJXvYIfdHixEaK7tnx2VEQcMhVEdknhPSOZIgGloI3HgfDGdsov/Sf5GoPyDl15bPTLUQoC0HTQXIbnyJUxC/thoc51fdwrCHUXFsCM7/GgMamu8OTTElHqx3wAMFtH8qIiVT8LQGD+VD17ZcVT9sWdCorSl5HaSY2H95mlAWSip2lUu9NTbXl6qxGa/tvc0+LfS+2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 8/26/2026 2:55 AM, Sean Christopherson wrote:
>> On Tue, Aug 25, 2026, Michael Roth wrote:
>>> On Wed, Aug 26, 2026 at 12:13:47AM +0800, Xiaoyao Li wrote:
>>>> On 8/20/2026 9:32 AM, Sean Christopherson wrote:
>>>>> And vice versa, a PUNCH_HOLE on a SHARED gmem (if userspace is
>>>>> using an INIT_SHARED gmem for the shared branch of a memslot) could invalidate the
>>>>> PRIVATE mappings (of a different gmem instance).
>>>>
>>>> I'm wondering now how this could happen.
>>>>
>>>> the requirement for PUNCH_HOLE on gmem to trigger mapping invalidation is
>>>> the gmem is bound with the memslot. But how can a memslot bound with two
>>>> gmem instances?
>>>
>>> I think this is for when userspace uses an mmap'able guest_memfd instance
>>> to handle shared memory, and a 'normal' guest_memfd instance for private
>>> memory. Each instance is bound to the same memslot/GPA range, and
>>> KVM_SET_MEMORY_ATTRIBUTES handles switching between the 2.
>
> What I didn't figure out is exactly how the two gmem instances are bound
> to the same memslot.
>
> The case I can imagine is
>
> 1. create gmem1 with GUEST_MEMFD_FLAG_MMAP and
> GUEST_MEMFD_FLAG_INIT_SHARED, and get fd1. mmap the returned fd1 to get
> a hva.
>
> 2. create gmem2 to get a fd2.
>
> 3. call KVM_SET_USER_MEMORY_REGION2 with KVM_MEM_GUEST_MEMFD flag. Pass
> the @hva from 1) to 'userspace_addr' field and pass the gmem fd2 to
> 'guest_memfd' field.
>
> However, with this case, only gmem2 is bound to the memslot while gmem1
> is not. Following PUNCH_HOLE on gmem1 doesn't invalidate any mappings
> because the f->bindings of it is empty.
>
> Do I miss anything?

I think Xiaoyao is right about this, the "vice versa" part is wrong,
since gmem1 has no bindings. Even after kvm_gmem_invalidate_start(),
going via MMU notifiers, that invalidation invalidates only
KVM_FILTER_SHARED, so only gmem1's mappings will get invalidated.

The earlier sentence about PUNCH_HOLE on the PRIVATE guest_memfd (gmem2)
is still correct.

Here's a repeat of the above in pseudocode. (I wanted to make gmem2's
flags=0 more explicit.)

gmem1 = KVM_CREATE_GUEST_MEMFD(flags=MMAP | INIT_SHARED)
gmem2 = KVM_CREATE_GUEST_MEMFD(flags=0)
userspace_addr = mmap(gmem1)
KVM_SET_USER_MEMORY_REGION2(userspace_addr, gmem2)

gmem2 has no MMAP flag, so that KVM will actually fault from gmem1's
memory.


Walking through PUNCH_HOLE on gmem2 again:

gmem_in_place_conversion=n:
  * conversions go to the VM, shared/private tracked at VM level.
stage 2 page tables:
  * private mappings from gmem2
  * shared mappings from gmem1

If guest_memfd invalidates KVM_FILTER_PRIVATE | KVM_FILTER_SHARED, then
gmem1's mappings in the stage2 page tables (which are shared) will be
invalidated along with gmem2's private mappings. That's not great since
we only really wanted to invalidate gmem2's mappings.

If guest_memfd invalidates only KVM_FILTER_PRIVATE (since gmem2 was
created with flags=0), so we will always invalidate just the private
mappings, which is what we expect.


Now I think there's an issue here: with gmem_in_place_conversion=y,
everything is still the same as above, other than where shared/private
is tracked.

gmem_in_place_conversion=y:
  * conversions go to gmem, shared/private tracked in gmem2.
stage 2 page tables:
  * private mappings from gmem2
  * shared mappings from gmem1

This time, the filter lookup will return KVM_FILTER_PRIVATE |
KVM_FILTER_SHARED and we will still invalidate memory from gmem1.

In conversions, a to-private conversion on gmem2 will invalidate
KVM_FILTER_SHARED, which also invalidates gmem1's memory.


Is this just a case of user error? That with gmem_in_place_conversion,
userspace should not use userspace_addr from something other than the
gmem for the same memslot?

We previously discussed that validating userspace_addr belonging to the
gmem for the same memslot is pointless since userspace can later remap
userspace_addr to something else.

One option is to say if the gmem doesn't have MMAP set, always only
invalidate (filter &= KVM_FILTER_PRIVATE). That means a to-private
conversion on gmem2 will not invalidate the shared mappings from
gmem1. That would break implicit conversions to shared, since a
to-shared access sees the shared mappings and doesn't cause an exit.

Perhaps we can iterate the maple tree and present folios and invalidate
exactly the folios matching the shared/private status and gmem, but this
is quite complicated and I hope we can avoid this.

What if we say, for gmem_in_place_conversion=y, set
KVM_MEMSLOT_GMEM_ONLY for all guest_memfd memslots. This way, the host
can still use gmem1 for userspace_addr (user error).

KVM won't be using userspace_addr at all other than kvm_read_guest /
kvm_write_guest, and for those, we previously discussed that it is a
user error.


Xiaoyao, any suggestions to solve the problem?


Meanwhile, I'll still post v11 to resolve the other comments first.

