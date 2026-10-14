Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9550CC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 21:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E191F6B008C; Wed, 14 Oct 2026 17:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0EA6B0092; Wed, 14 Oct 2026 17:47:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07A26B0095; Wed, 14 Oct 2026 17:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC9836B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:47:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A557A07F0
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 21:47:11 +0000 (UTC)
X-FDA: 85322567862.11.16D19F7
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 304F940003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 21:47:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qInC77LZ;
	spf=pass (imf12.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792014429;
	b=Cba7UP294UvPfMHCMvmF1+gL2aon8MIk6hgNqNGpN3sZnJdpVez9fl9rS39KEjyfk4+PQw
	fKpLfUyqHKJcUnoOdRXi95hj89941vcFA2uRp9oWqEsL/TbokyO9VxiVmKRjm25dzTR0YL
	NSSQtpaFlPbrZ1/89008Egr8IKIborA=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qInC77LZ;
	spf=pass (imf12.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792014429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OmdjCtO0BT/G+HosYDOiIQ+MFbY+P6PHIY8xmD++EWw=;
	b=LCYsXsHQ+fWEOvaW8Q1aGy/3dkhMlhZdMNM+4dzQgf6hqpViHZtloJwTh9zwnucleBOl5h
	IBoS5mNJm359n3v7Ma7VQqLjG2Bo4/sx36Mt7MF1iO8GAa543xM6mtH7rcbmfj2yAADYH8
	mou88jRj/eq6ZW/0LZm3S6vHoOOtowM=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-9196d8543cbso7321336d6.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:47:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792014428; cv=none;
        d=google.com; s=arc-20260327;
        b=eQ5ACEql5lMTn1z1outl4yS03/BVTlxupH+rDHPoUoWFBM4qzG1HabIG2QjbQ84e6N
         r6UX8+WLCeewM0fpSCC4qrkQcDTUX1Vwh8rqdlLg2o4U57nTgZmFO92aTSVlERPJyhQz
         rH+0gbvKBfPruzqmZIHOIwMCRwErkPHKeQa096uLMf9Ka8B67y9MguIlytW8xeJXjCpA
         p6Wg5fRe99u6zQv2WLVLXDkRg0xa+C1vWtNWWAnhy+ztraf/QWivG02txpDKr0Q++pSD
         rt3cH0PQpl/eg24nUgootmnVU33IuVhWbXo81i1WiGNNUHES7ezYAWuuTVQv83rcApmT
         KIdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=OmdjCtO0BT/G+HosYDOiIQ+MFbY+P6PHIY8xmD++EWw=;
        fh=nBAIqdOfN3dcghKALikyBnKUBygcqqtSlCTrIVlj5yU=;
        b=WwmCkytrFsR3O15bZJo2aryr6/BaEtTud76jSBBdDePr/nXCN6ZT5CHABnVsbD+FXr
         +dYXZ246C9XSvqd8s5b1okUYmhrN2cZhKAijzNnjTyQKkMgeK0WZrwbtXfjSJ7EndIzA
         hvcb3PRLUBIo6khJv9+Xy76o1v9lT3EKBe/X3YAEqyviaiaPMRIp1Od8TUWiDoDoy7nE
         WB3sNqzUGIoUAjB5amceEri4PnZc86NN9BAVDAFOebITq40vRA6DTMpRrwFAVFPX3zKq
         +f1NJq1piUY4PulO2j70rx7ooU8VB7fFaG8q9Bj9PCk7iOGNznFrRGk4m9WPLUMbb+4E
         Qykg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792014428; x=1792619228; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OmdjCtO0BT/G+HosYDOiIQ+MFbY+P6PHIY8xmD++EWw=;
        b=qInC77LZD0u5Gk4oTjUHg5o0ec8BnLke3nhPVYbNkJ0n+JVPzt0ilay9fhTttVXLAM
         qJjNSlTWWPF6XOEkOvoODW2JVKDQqd3zyaLVwQZwQjnecomqk7HlIuKMTFphwS7xLFw/
         oX2hutcCRVSfob2IKGqaCuquAoZeMbsihsVreraM4tbfLLuIF8Uoxc2KKsxJF4OKJbAK
         qNj4VregEd8qiv1v0jqEqK8NjIhs/UjLXDeX4QLRne9BHq6eqnCpMiZmXH13RCAiyOtL
         +0vKWROhNkZtFumhoFsDftiN50LFzxqs5Gt70LSjyjsknsNacp1FidKp3KKIcRfpLIZ2
         ah1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792014428; x=1792619228;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OmdjCtO0BT/G+HosYDOiIQ+MFbY+P6PHIY8xmD++EWw=;
        b=HNLKsSswqGm4skAFxH04WoEFyPKqBT2OWZtW93BYWNixC8saPf2iVCT8p6xFxKdr8i
         msio7m3NVAaP9XqlAGizWL/4bYC15s987T0tOM9mYZK3AmiJkrfHJ624wrybOAQqLDeB
         ZUhCzSzHRLupjvkUiuqRTSLFFHlBe5e6wFg+iVQWgHsOvXiVJSIJXKn4Qlyv9DxKHJV6
         qN4GbvK4YJtLhfqfDHzhlsyVJxarEY18Lgfml3AtyjAJdAjvDpSzjzACjyX9gC3FHt4x
         Bde6VRMwIWFPzB7SoshKqp7LAwubgGjBS0AXftNxOjbPTLKLJOR3BPQYlm3JhlptcUtb
         7IuQ==
X-Forwarded-Encrypted: i=1; AKwUvBxaQj0h5kuO9YiKGtX6cAzg9ZA2hQ9XWz7Xaqnuyv5wtShkWXTjeakVJy4aYoAVOzSPnmtYuAIQyQ==@kvack.org
X-Gm-Message-State: AFq9FYJp3feydVE8CCIBhcKGPv+N+Fnu0VdA57N0Vi8HJkkaRiHyp6nR
	kqbyFdj4oCKJM4i8zx+lo5dXunZp9TbC9G+l2G+bylwe4oW98jdu5jv3dEUhSsjS1j1I96/DYJp
	+Z0QWOYCS3caUrOs5CRffl3MrKo5kzJQon9dbtyzE
X-Gm-Gg: AYBFou2NTdeQ/g6WnrMQsaRAOdghxsG9xQgRXFgxWqJBhBmQNFTPM80GuIVCqsuvnM2
	OPdLuoToXuAxX28fil24Kq1Zfgw/jspF6koMf69MpyB+WxoJ+xU7aKpjOuawFNssrh6BFlqqUo3
	sPkl+5g+SWI6ib43Zn31lDZGhU8krKfGayID6QZWHQd3K6AZOCqgyBFnMPhh11V7WEHPOd2FyVc
	fbs/+5zWwIeE5lveqzXGD7LeMT3zFrp3s75oxDvsVbc9JViSe8a4dtvf/81AFFv4IP9XazpqQuw
	y83m4yVCAKr/qw9bQ+ohabfSoWlmkOXBvKodBtxNCwJuyGlKKeo93XLoJq7X6IlvsLgoGnZjqCr
	usxnZQc50itUSatzNdVsfRgu9Oy1cVHl7OCE5nQ0ba9dElscsz1Lm
X-Received: by 2002:a05:6214:43c1:b0:91b:8e06:73f5 with SMTP id
 6a1803df08f44-91b8e0680ffmr139578016d6.15.1792014427625; Wed, 14 Oct 2026
 14:47:07 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 14 Oct 2026 14:47:06 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 14 Oct 2026 14:47:06 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20261014095702.39676-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org> <20261006183235.16576-1-griffoul@gmail.com>
 <CAEvNRgEseLO+LbkwXrEit0H2LH5Wx-srSvHEMpt0=upPL3tF=g@mail.gmail.com> <20261014095702.39676-1-griffoul@gmail.com>
MIME-Version: 1.0
Date: Wed, 14 Oct 2026 14:47:06 -0700
X-Gm-Features: AclHuK_bDoENPFsEJnePb9piUrHFuROo5b9vCnTZ7F3PMjuUH-N1Jl6pvQGbDQg
Message-ID: <CAEvNRgHtB8j6=9r=txjsKvQM0F85nRN4KW5sdnuv_-Og=cWEfg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/9] mm: Memory providers for guest_memfd and iommufd
To: Fred Griffoul <griffoul@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
	Shuah Khan <skhan@linuxfoundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 304F940003
X-Rspam-User: 
X-Stat-Signature: 7ea9y49fuwk9akd9ss35qkn3o49fhh5m
X-HE-Tag: 1792014429-520653
X-HE-Meta: U2FsdGVkX1+OpWq4njkdiliUG08WNPvjOl77UGTdFLLlYflnvqVz5KWdkRDVyM2Cv3MR0guAc42UbQck3ZyJ+Nk3Pn8ZREbbDu/dU6zuprFwsMOztO8QgTiiDgr4Sh7YNlyTmb84VT8wYQJN8QzEmMA30ddlbTs4KhGaZHFtl5+8rk4OrgCznCQzeYe20q6fEWww97VeDP949IN9vMg3d/z5qT0CYIXx4H5q0dqGiR+5ObrV2l7zHcEqLTI/Q0zXQIOiho8v8Iu0M6dtC5t4rIIKWVpP6x4N7+lLExX/AtumZgLWFh1J8ZyVmqLJbQ+LJJvMSfIdSMH8KGxvnT/JZq7PtDbatti/gEypUb5uPt/0dL7+h4nb0pwsUWRsmpM3XWt5EAl0rC0v6GGpQb9Zq4JnmJwLFcDeS6sqsrq3BYFujIJrnXmrBSUb/RpFg1iR7FVW61tr0CNkEmP4vF2Ch7XpT7xDbhUBzbrifWm/GIBVC4KpytFs441pARjnCv17N7SCeYU/iPFfMtbr+uvdT5jHPTgM/ez8MefaP/N2eklZcIV8oUoW6VQTPiSzvf8vIjkKeqvmUfNSdKwwuwkr/XZwkfI4bzUwCzJnIgd+ibavqSQmPwGwL92VjxGh4/ycft8Cn8EJogqILYxriwvXX7FhBn5KWpeMIEHgWD5NPafrSHtnXdVhabc2ZqGzzLduzsZxwERzjSU/z4A4t0Lu733No85qGigMHqeHSR/+qvoAE5hVXQD70QWz1q2yCO6Jwl5w0GlF7mqmSaB4Cu/f2Eh6C5bzKJ2wjc/kYMQUye4+EA50vGDpnLgqFi62EX8hFqmXCr0Vm/xJPbx7yMhTER76FwGgB9zUJiv1ReEL0nFBDDMN4Pmzd1MoMyc8FwGhUC5gWVDI6LFycvjnl1dA3zQ3GllZw1TEK2J9enqI8OPo/DEFOyWvyu+IJGhis1ULmu9n8+T9PSr7PVsoDxw
 RzVCFWCF
 Zk5RSFFgUUB2jhoeSHPp/X63s7O04memKNAHpWmO6gsviF+/Jly8dVsZop2uEqGSbUTOF/fU0vSdRFA2UgbfKOE+jo/kV91uP0y2VFEh0NzOBhvINvL++AUF9ikmNqOtfn4jcZZo8Pq4yIxPDl66NN2h3XiiXrx9dzINwu4nQf8S+qIUO0p0OAhO4ENuHt7Lk2p59OT7KLFft8tmU5pe3N3AVC96eviFbedo8GlP9YNiz82leDcEW4R7bU30PynKFeFuBZ5PC36mo4TNokWicqvv2hEPMd2AYXtgpl2vVjSHWlOJLfa2SW0ShlPLX5FXxklz8qRv4eCyWuZO3BJp2gA3b94MVJoyQBvRQzq4iB/FMUZkHKgISKyFd6rCwqH/axMdg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fred Griffoul <griffoul@gmail.com> writes:

> Ackerley Tng <ackerleytng@google.com> writes:
>
>> When the provider wants to revoke the page, the notifications/function
>> calls flow this way, the last [ENTITY] in the chain actually does the
>> zapping.
>>
>> + [PROVIDER] -> [KVM]
>> + [PROVIDER] -> [DMABUF] -> [IOMMU]
>> + [PROVIDER] -> [GUEST_MEMFD] -> [USERSPACE] (AFAICT this was not
>>   implemented in the RFC.)
>
> Thanks for going through it. I have just posted v2:
>
>   https://lore.kernel.org/all/20261014093733.90312-1-griffoul@gmail.com/
>
> It changes two of these chains. dma-buf is gone: iommufd attaches to
> the provider file itself, through a small interface in mm. And
> guest_memfd now maps the file into userspace from the provider's
> frames, so a revoke also zaps the VMM's mapping:
>
>   [PROVIDER] -> [GUEST_MEMFD] -> [KVM], [USERSPACE]
>   [PROVIDER] -> [IOMMU]
>

Thanks :)

>> IIUC guest_memfd conversions was not illustrated in the RFC: what
>> happens on a shared -> private conversion?
>
> There are none yet. Only VMs of type KVM_X86_DEFAULT_VM can use a
> provider, so all their memory is shared.
>

To borrow David's words, the part about this that makes me itch is
conversion. We have to support conversions. Even if it doesn't merge in
the first patch series, we have to have line of sight to how conversions
would work.

Conversion requests originate from the guest and then the host handles
the guest request by making calling an ioctl on guest_memfd. Hopefully
this part doesn't change with alternative provider support.

Suppose guest_memfd still gets the conversion request first, in RFCv2,
to reach all the mappings in various page tables, it would have to be

+ [GUEST_MEMFD] -> [KVM], [USERSPACE]
+ [GUEST_MEMFD] -> [PROVIDER] -> [IOMMU]

since guest_memfd must ensure no IOMMU mappings to guest private pages?
There's that extra step through the [PROVIDER]...

>> Does your provider need to know if some memory was transitioned between
>> shared/private states? The provider can be notified too, if
>> necessary. If not, then isn't guest_memfd doing all the coordination
>> better than going via the provider?
>
> Our provider does not need to know, and I agree: once there is private
> memory, guest_memfd converts the pages, so it should tell the others
> what to zap.
>
> I think the two models meet there, and the v2 cover letter now says so.
> The iommufd side of v2 does not pin and keeps no references: it asks for
> the frame behind each page, treats a page with no frame as a hole, and
> maps again on a revoke. guest_memfd can offer that for its own file:
> shared pages return their frames, private pages are holes, and
> guest_memfd revokes a range whenever it converts it, in either
> direction. That is your [GUEST_MEMFD] -> [IOMMU], and it should work for
> folio-backed guest_memfd without memfd_pin_folios() or refcounts, as
> long as guest_memfd also revokes a range before it frees its folios.
>

This part makes sense, if I'm understanding you correctly.

> The one difference is that v2 also lets iommufd map a provider file
> directly. Going through guest_memfd would add nothing without private
> memory: it would only pass each revoke on. And memory that only devices
> use, such as MMIO, does not go through guest_memfd at all. Both paths
> would use the same iommufd code.
>
>> Does the revocation model work for you? If it helps, I can rebuild the
>> sample provider to illustrate how the revocation can be done.
>
> Yes, the revocation model works for us. v2 replaces David's sample
> with one that moves, donates and makes pages read-only, and a selftest
> that checks the guest, the device and the VMM's mapping after each
> change. It may be a good base if you want to try guest_memfd as the
> provider for iommufd on top of it.
>

Thanks, I will prototype what I have in mind too to make sure things
work as I think they will :)

>> 4. [DIRECTMAP] Kernel direct map.
>
> Agreed, that is separate. The memory we have in mind is a range hidden
> from the host with memmap=, so it is not in the direct map.
>
> Thanks,
> Fred

