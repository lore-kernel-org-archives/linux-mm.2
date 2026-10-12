Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08947CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 14:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A97E6B0092; Mon, 12 Oct 2026 10:41:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B006B0095; Mon, 12 Oct 2026 10:41:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023686B0096; Mon, 12 Oct 2026 10:41:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD32A6B0092
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:41:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 633F4A8FC0
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:41:15 +0000 (UTC)
X-FDA: 85314236910.24.5A17B92
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 50E7840010
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:41:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ebltQoEu;
	spf=pass (imf17.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791816073;
	b=gYkfVkNifv/nN29mYzDtSow00AVFe8k6Y4ICMQ5P6MbJxKyrPqww7G+xIhEJ9L8eAMKzLk
	xidDEM0M16i25arXwVeTEVEnblA4IHpFbKyS19eGq/MDb4IM4yUrr2UFd/TBrtXasEU6pm
	NpilTvEenmex1A8+J0uxNjzsWwZRBP0=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ebltQoEu;
	spf=pass (imf17.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791816073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EYFNAc3NwLAUZ6w5n0VWHZN4pBcB2B8Fyu8v+g7OFJM=;
	b=Ydx3l6gBnlzxOR5+aNTOE9m+O68DpppQRXwBKnGcGjthcxs6IeCIaG9QtBp1dVcysiCLqW
	zc+vOzyHYyIpVO55BoxQ8aa2d39EV2YVYKx2fJjFkSXiOXTEZESYvNTUMWFAlIgaYizywy
	1VaAnpLdLLcrjXEToMYoewFMTVCVFEU=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93cc31c18ebso134633885a.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:41:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791816072; cv=none;
        d=google.com; s=arc-20260327;
        b=d1rEl4X1sdmBSg2ofIAcHtAhcg+8JQdhUYE6vpU0aT/wlJOepXb/h5UnKbW55zvyQz
         vuYYk2zqId7PKqoscvKTCShEq5RDBJo+WeOvx0jK920oTglPbfcbeoqTqsKux+5Me00u
         0EqYDcSCWaBkDX4RDXKs0JVZjc9SM4cZgKLQsk49pbsOJ8dJo/D+MViamL982djutHrL
         i3Ws/t0lyO4xABK0f+77+lsDv0NllAF0UlDI778bzYTNlOPOnL/Fk0Gu3gWGwQUtMDvV
         pAe0p3WuWhjPLm7lr2ytuuERZmUKGENwGgQzU0BW4uaeyeocY1VRYImP7U7IQ76VwRZq
         King==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=EYFNAc3NwLAUZ6w5n0VWHZN4pBcB2B8Fyu8v+g7OFJM=;
        fh=kTFELDz7FB+JWssaXaxdmWYibeqWGw5/xd0u0GV3sWk=;
        b=b4+hhS9gFKfY9y5kKvV0MfgZxAq6XFmkkl/tkO1WXy9isxOJBrbjWkrrc9XIcDvtci
         rka4Uq19yLtAOcikeeDhi5yiWYEdytKlxm9MGgK3svwmnQ0QOTPntNiM8t15cJyUdv0z
         TpUREmQXPf+pba4lOuOJ7dJnMIym25V+MCTb6e6YfVygGQJuc7Yo+QAzU+beusXIxzNx
         3UCtQy06x/veuY0mXUoxPLUQAvWfVB3nF/ngFSiwGedd0knAFzI6SDx+lNQZpeDS5O6g
         ZzAjELzA36JY1OCRe+wabx6V5BlIECo5rrR+NMCoV3sae8Hi/t+os8a6SoKlEDtat0yp
         bk8A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791816072; x=1792420872; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EYFNAc3NwLAUZ6w5n0VWHZN4pBcB2B8Fyu8v+g7OFJM=;
        b=ebltQoEuhMlyik1DlXn3yKngsv6KD+pWUVvGhwA/D8lO8zgtFJaX55XNjt3qpGEeek
         dobzYTHOfkAoH29e/AiZJ+JQG8rf3nvwTYM0xjr15Fx8mf08XS1D8G+/3sy3dhJH8Avk
         SEdMsayj11PTSvO0J4/tI/tFjc/swAtjXlbLbq59gZf6RwUfHSOjKrHIKTM0KxBDpwXy
         wyUg7SaGPxpEWJrYGpt7d8KcNgKzgfXznrD4QDQokHDNYr4F4QDmoFZVmsq99GRzrmQQ
         r4sC867tF6DbnBJ8i7wg3uQXZKIdxLPRrUyEA6VQv7v2qts+CYN9xbuZKH3zkuFl65u/
         85iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791816072; x=1792420872;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EYFNAc3NwLAUZ6w5n0VWHZN4pBcB2B8Fyu8v+g7OFJM=;
        b=me5M/39PlzmaoyiJ7//Je/ScE9gRc+hMORMVnTQjPhdGsqqXuwd4qmhk8e6rBjq9cq
         X2ccaRB6tx0awWYk0oxz8TMvmP9vwa6q5bzXRxSc3cUUG+MuM0SmkoSaeQLOhuj+CtIh
         I0ltigOTNzpZLFPOFf/kQRin4xpUsTtkVrBbv+hIJXoymaJAWgJoClToY9QrM9Nwk6xf
         g0FyMifAGnIKBctGNAM5i90xuZ/M+5WPgVtnkjcLqWk9AufQuB5y3NQwU87hxmL5sZsF
         YmBvJaLb0NDBFerBraLrwC7CDtpyXmMTfP1hU5q2HLytZGSk1Yald3ix02FmOuIIH4h6
         /2Qw==
X-Forwarded-Encrypted: i=1; AKwUvBz1Q0Wbii+QORVQ0UI+lHg+3Q+6muRL1XefEulOiETxwQtGwwAdCT4LQONlnWZWcwzxmXN2Lybc/w==@kvack.org
X-Gm-Message-State: AFq9FYLM/dusFRcE5fZ3s9pirjrSKcxbhadhUT/0xR2E7q9F9+oqHqv7
	4wtdsI8uL7OF/XBGoPXkVmfoBhGoTZB29dkOaMXYtZruSNv0/tQ9Ho9Q0wb3Yro0rKUUa1pNRFZ
	o2fKPOpiuoKYs0n4fjXiHAI89tCPOC7lq0TdixF5B
X-Gm-Gg: AYBFou1ye8Jp+MofjkgKXNY0ZeyE5D9/TBwsJP2ITqZVk3lSa2K9DQoUEWuRTdmsG1S
	QLf4HI0ifdROAu1op9iBnIuFx386JNsjvD1ASS3dlU2kt/nQQI8nmibc8Iz2BGcSYbjD/nOC/4p
	cSzaRUOHW/vR9Mtfhr1fMhTM/Zo0Y/eYtesQ07UYbV2V2zV5NZeokIEmWdUR5xhtJ7d6T1MeCar
	kMxqRbyu29S6nHDo0qyaNvchMmTnspq6lclh6+ic/4yDhIiYtiw51kgNskuydWMusj8jRnxOVkT
	SiJ9FWMnlz0eLt/vYH9LtlJ0mrcwguP/1lEmInJIAMwn1IngyJakpUqiKO0L/LdwY48XlJ58GAI
	RP7koUGJmFnpB9MEMFlmr
X-Received: by 2002:a05:620a:2993:b0:93e:9508:8360 with SMTP id
 af79cd13be357-93ebd1dd868mr1604359685a.27.1791816071132; Mon, 12 Oct 2026
 07:41:11 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 12 Oct 2026 07:41:10 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 12 Oct 2026 07:41:10 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20261012095800.50250-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org> <20261006183235.16576-1-griffoul@gmail.com>
 <yq5ald8680t2.fsf@kernel.org> <20261012095800.50250-1-griffoul@gmail.com>
MIME-Version: 1.0
Date: Mon, 12 Oct 2026 07:41:10 -0700
X-Gm-Features: AclHuK-nc_uqkVW8eVTYkrPq_RPqOo6SBs5ABhlJBuD_rVj9OrJECoL16jCBpAc
Message-ID: <CAEvNRgF1hMz+4ivH6WhsEOLTJGOegYO9AYK6OByYysPp_nVJ=g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/9] mm: Memory providers for guest_memfd and iommufd
To: Fred Griffoul <griffoul@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, tarunsahu@google.com
Cc: David Woodhouse <dwmw2@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: tbxgd7fkfaddzbt6g1jrrfysfq8fuaoy
X-Rspamd-Queue-Id: 50E7840010
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791816073-654595
X-HE-Meta: U2FsdGVkX192rgt2fVQcuSz/K3IiSqVUX3hvL4PcycTHr7eyHd6p7ZLI3zkhxs7C5SsU21z+nRoiHy4M3xMiM3bV3MFmpBvFKs+yJE+mOpbzsNl2spkOBNWqjHJCP3ECo+30CiMjozVnoB+51pqKsk/rEvWRzaLuTyiy/CPJmK6ThGXz5/YeSDOaz7asj/J7FU/gd/4WfbIvOXjO9+GDpegB+XEHieKdUPT+m8GYIioSWIgxVy0Z3mjG0UVGT9h3NQUugRjrqOV/KfYhAWdxHTyPJ7M8bGc3VfHS6Gswd4edMvkD4Qxx+wo2gydkVckdrRkQgkD9oa8gt4FnibkE3aTb8VyF0Dby+mC8fqlUi8MIGbtQxwrVY8L8siUqFZnJJFPWzQmHHgwVTSyxUeTwhnY6XfJ4wU5Px5cdMucfZa1m11/cpYzOAmjKISDFtPHiqgRRzO5dYqdya3al55qFZr62ALVycgj4rv2KLl4r9UgTjcyV4dS3K5FjoTno0oaaRwVujRSQX/kjfd11mIZ00YQxXKYy/O+81HRag7r8PLa3tPiFJCErdmdCMUILQQa/Gn5mv4qpGZaH+aYL2uhg/5RtlflSBrKfrG8nj5kolVuBqYsOnJ5fqtd+C+QmZ9UoFq3SEvl/lxws9EXQG/aYk/ktoETXcM7Qxi7Z5vFK1gDVmVkD9DOdZMs83yLrKOtvqLArfM3QTKOSzBawzzDtjI4B7B6FGLxwYCfDVOE83o8n3WSSAlORbx5u7x0YsrA1traxAhPFezoga1RrzneUCcgXAIKHQeiUUXZVm4KSJDQL4a54Kba7HPBWzbTn5fHt16RdmeTe/gPr6LyoXh+jOC6GOVv+1xfQjl2Pxg+dSLPqtX+jSETSPgPHFTDsDxwAUcSOI/0SlNNpXTQKJlF+drrgRM62zOhvYi0+noW7Xfu7GV6iDz9Jad8rZswfreHuuXuY5i0PwqCuEwuEvqg
 GzKQcsbm
 J+R8By5fRPlnOK8y1dNzQ3SC5SxY4UlSepQ9jHhrI07XhjSuosBmVqJJ1xCF3uy2WuLuHGyaIoCjvs4KuAEC10d2/Vo/lvU575zNHaT2H0Y0wU4RdytrTUMs6mJRHSwzimYxDv2gujbr4XzniNeR2250IZg/3FijLXc871JG4z1hc//5Th6FDq15oRxA8JKNiiotfp8WtQdS7B2BkU8Rf8GnuN3H2BxBjpVa9Yh+f07N9760J4iOWdoZWZ2P31iqp9NFF6pAyq2A0qCBcKLPU6gYsMsK56x2V9vO7YT/kHKSa/SCt0HPL2BOC19LnYq0tQ89CdJRTKi8/jPewNhCpS+yS2+Kd1mzclDURG/c086qVrPth01daNcktoNtcj45kTs0uCaLldBO7R1tlDFScUk0Lh6qA1M4h1cladHkgixf7fzcnBo+joWKRs0RSwfLV1SGzgYI8sV8xQ4ukgg2q2grOQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fred Griffoul <griffoul@gmail.com> writes:

> On Sat, Oct 10, 2026, Aneesh Kumar K.V wrote:
>> I have been working on something similar for confidential computing use
>> cases. There is likely some overlap between this series and what I posted
>> at [1].
>>
>> I have not reviewed this series in detail yet, but I will compare the two
>> approaches and identify what can be shared between the use cases. Please
>> let me know how you would like to proceed.
>>
>> [1] https://lore.kernel.org/all/20261010072504.536230-1-aneesh.kumar@kernel.org/
>
> Thanks for the pointer. I read your series, and Ackerley's resource fd
> RFC that it builds on. The use cases differ, but the interfaces overlap,
> and it would be good to agree on the common parts.
>
> All three series add a flag and an fd to KVM_CREATE_GUEST_MEMFD. I
> think one resource_fd is enough, with guest_memfd picking the backend
> from the kind of file it gets. I am happy to drop provider_fd for
> Ackerley's flag and field. We also find the provider from the file in
> three different ways; I would like us to pick one, preferably without
> a registry.
>

David brought up many good points at the LPC discussion, I need to wrap
my head around your model. I'll look closely at Fred and David's
versions this week.

These thoughts are just from reading this email, hope to get more
clarification :)

> The main constraint on our side is that the provider stays the authority
> on which frame backs which page:

Wait, is there some magic done to make struct pages represent different
frames, as in PFNs? In your model, the struct page <=> PFN mapping
doesn't stay constant?

> it moves pages between VMs

Do multiple VMs map the same physical memory at the same time, or is it
a move like below?

I'm thinking that if guest_memfd wraps your provider, then your provider
can issue a revocation to guest_memfd (ctrl-f for
kvm_gmem_provider_revoke in [1]) on the move source guest_memfd inode,
then wait for an allocation request from the move target guest_memfd
inode.

[1] https://lpc.events/event/20/contributions/2551/attachments/2047/4693/lpc-2026-gmem-other-backends.pdf

> and has to
> survive a live update.

guest_memfd is going to support preservation [2]. Tarun's series just
preserves memory from guest_memfd's default provider (buddy allocator)
now. For your provider, I imagine the preservation flow would preserve
whatever metadata in guest_memfd (like the attributes in the maple tree)
and then go on to notify the provider to preserve some range of PFNs (or
folios). Your provider would then basically do nothing, since those PFNs
already survive a live update.

[2] https://lore.kernel.org/all/20260728121138.1103610-1-tarunsahu@google.com/

> What would not work for us is guest_memfd
> becoming the primary manager of PFN memory, as Ackerley suggests. Your
> get_pfn() leaves VFIO as the authority for the BAR, so I think we agree
> there.
>
> You refuse dma-buf exports while guest_memfd is attached. That is
> roughly what the memory provider interface is for: one owner, several
> users, and one revoke that reaches all of them. A BAR exposed as a
> provider file could be mapped by both guest_memfd and iommufd.
>

Will read the rest of this series and reply again :)

> I plan to change the revoke anyway, because iommufd must not leave the
> device with a hole: it should replace mappings in place instead of
> unmapping and remapping. Would that fit your case? I suspect it depends
> on locking, for example whether you have to revoke while holding
> memory_lock.
>
> Shared/private state and the conversion hooks would stay in
> guest_memfd and the arch code, as in your series.
>
> Does that sound reasonable? Ackerley, David, any thoughts?
>
> Thanks,
> Fred

