Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4F84CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BF438E0092; Mon,  3 Nov 2025 11:05:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395478E0057; Mon,  3 Nov 2025 11:05:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283DD8E0092; Mon,  3 Nov 2025 11:05:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 14DB08E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:05:55 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B4BEF577E1
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:05:54 +0000 (UTC)
X-FDA: 84069771828.25.60CD695
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 11E16C0004
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:05:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GZ1YhI+0;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762185952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7zqPFP4se4OIaFzLrGpOU2VTLQJoOSY+ZZS4O5etWY=;
	b=S23X+3bx4yTzNeOFXz/5g4q1wM6yJeP9XhgT0R2I+spLaQ4ZmuFdoRjROvwwCdbJ8mLP4C
	7MjIkEeMdV7NJRDNQawAXa/PTP/ZDUbcOFwp9k+2bcNjrcGrzLkNZWazqv+7N3Dk8QTeqw
	Ey36TkKsQ8VGTQc+S17RbTn4Jh8zBmU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GZ1YhI+0;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762185952; a=rsa-sha256;
	cv=none;
	b=w+Th5mHLrm91Fa7Cbuz68LzKdoRhKN/dLV86Aghh8MtlYrMk0qX7crmMkp3JrU8q+N/O2j
	CujgmLuuLUJwL4taWBJBXTSHLtvoQs0Ax6Q3ApLNspPGxWve7RfLlZ8wCA/knmijpogM3O
	I+Ny67f/0tnyVJRWAuYv0JeNnIVfRxA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762185951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h7zqPFP4se4OIaFzLrGpOU2VTLQJoOSY+ZZS4O5etWY=;
	b=GZ1YhI+0vheznP97r8VVrzWD/XaZaaakFGBt+o2PsIecgnOrNwAWioddfNdA/VcQQ8L1vl
	Qk0mjyCAcgL4RiMUmDWieVRmz4gjDwX0ULMnpw+TLXRMIZxIZALdFNZ8ba2RLjl5y3hnmD
	W1MxUGl5yoLtd5VwKSjJGZW9puOKBAo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-208-OTJEm-IRPq6sGApnvYvkJg-1; Mon, 03 Nov 2025 11:05:50 -0500
X-MC-Unique: OTJEm-IRPq6sGApnvYvkJg-1
X-Mimecast-MFC-AGG-ID: OTJEm-IRPq6sGApnvYvkJg_1762185949
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-429ca3e7245so1246308f8f.3
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 08:05:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762185949; x=1762790749;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h7zqPFP4se4OIaFzLrGpOU2VTLQJoOSY+ZZS4O5etWY=;
        b=WeF06bgkw8ieVVMv2G7ds3jxb2O2H8JBak96clp5Ybm48xSlSFtx5KH1p5lh+X7Upg
         9GfAQ9OV5SBptDW0vgnvvX0ZPR1YUok9pKgLoT8TNnKw29GGv2OXqouMgTLCMz0hK9zJ
         AgzbJJe5Cm8a8qIowSpGYDNoYK48kuixUO+HL4WrqruJrL4Wfb8IbImnVm6ZUhMs3f0I
         RQl+qH1/UmkSeaeeVxKxDqJSK9tZbRK154EATA2jqqkzp337iCpfUTet0usQNQ/13E0K
         iHRfMyCA2qkuJRRNxwtynrsmMyP8nkgfczPFSMFy9p+9IY8W0q9Vre0S8/ErgyyaHIqf
         Y5qg==
X-Forwarded-Encrypted: i=1; AJvYcCX8iMHYf0yClTcHX/gA761G7CVyogHwXWPDBuFyAnJ8MMFhK5nIU1b3XtTYH8OCV4+5FbkPTTb1OA==@kvack.org
X-Gm-Message-State: AOJu0YxGPyILt/K1lo2NT/aYqOux4nhNuQCSi8SepPv55v8J3e855iHR
	vXKKck4tdVOoOE/1L3GWTIKcuaJUSovhGXiyl27wLLbVQ6cav2wKqjMQaSo5L9NtronMYu8ar+Z
	KNEu8Rj9QtNPPmDhZqkEcRZ2jSb+glGalrTYSABZOT6CsgS0oXPAz
X-Gm-Gg: ASbGncuVkOath8K2a5aEMkBivOhOjPTKXv63BoN16J9llws77NP2BcTrPdo/qQ9vamj
	Wv6hfoKbX1s7XF44lBSRip+aBkQ4a9pFg1GlCbzjJ1bjOT+DsjKCMej3HOhK93q++gPBg/IrZ2L
	HLoywZXK/iZFoI073B6JvI/TvcdQGknnYZnm6VmWZa0ZgB+ZgJxLViFqOWg3xlkU31etVOGRrn7
	cD+ak1cfs/Iz6Rz+nLV4nz5sJfxNsWdNyR2dHMjw15G/J11M74gKRLW8lP2bFVYnCT8OKCTZAQ9
	tfOELIfNXatbxSTL6eP70b2+ZVj1rMnHJyJ5AadGs/XAMuB2yiaiEC4uOlquTywQeMdnJOCa1C3
	Jq5kYv1X95bXdzCkeEMjkhUxpQ3DAOrZtXjT/yiGZi6SdzaQNxzr+j+MrDBNYsYKxKpW6mfz2hL
	eX8qvLmzpDDpHz2kDwsH2oBvCAh/0=
X-Received: by 2002:a05:6000:2411:b0:427:928:789e with SMTP id ffacd0b85a97d-429bd6d583dmr11477153f8f.61.1762185948292;
        Mon, 03 Nov 2025 08:05:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFc7QNXPV2goDccZBoudQ7Gvk8PWg7e8ZaWNXwQcsQ4X2jdmxCnoJTtoWX7k3mSPaCwOvUqEA==
X-Received: by 2002:a05:6000:2411:b0:427:928:789e with SMTP id ffacd0b85a97d-429bd6d583dmr11477100f8f.61.1762185947708;
        Mon, 03 Nov 2025 08:05:47 -0800 (PST)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c102dfd2sm21748638f8f.0.2025.11.03.08.05.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 08:05:46 -0800 (PST)
Message-ID: <05e2062c-1689-44e7-9cc6-697646ca075d@redhat.com>
Date: Mon, 3 Nov 2025 17:05:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/12] powerpc/mm: replace batch->active with
 in_lazy_mmu_mode()
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-10-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251029100909.3381140-10-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dKFjsl8kKnYCGsODoL10KYVBG6IJlOMATJjMizJvD18_1762185949
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 11E16C0004
X-Stat-Signature: f9juzahgrtonsuqg86iz6y43s917keoh
X-Rspam-User: 
X-HE-Tag: 1762185951-256495
X-HE-Meta: U2FsdGVkX18k4ay3mQLk7RFvnEvPkOJBpr+BwPRmjlizHuRiszK5Hk2cJ6gTghXE62f+zzFi/gY07lf1lb1CzoeB6BWwmR8rNFaMXSf5SmQctAGcBVCMWWSlxhV8Q0NH1vmIwuDSaMnWRh05RMq0z3ThfpokvWlIq6mMGWy47UxQ9tgtkcM6aoSrX+F+D6CIkvCKHRjhodwQ8oE31WV4XFhsO0vRsTWJHCunjlL8dRC5vK/RAuBNd/UZ4nAaLNdXKVPQ7qpNYrVca/u9zYy1gMgdp2hGhkSKeKa2MWdAx+t+FsTzagt0OV4iFoc2kaAw1V6Ek9sceibzNLcZTswm9UQwELDxhAsO/9uhW/3bsA8c4RXHZRbeJIeV2hsjJr7tZADqcphA371Rg2veFT1DK8z7WlkNS28QOHpgNyL65xqETLTnFHKeq4YgZFvcfKzCZNGW3o9uAsfes4jUoodSWZvNOigH/nqXa4hYsK6aGL/DIkHD6+qONccROA0hLb9YCy9f9RPDr4MmOlYt5hA1mnYXvYCUCrbUsGva1lGjYzSI2T8X/PpXZEaSEF+xFddRGfsDFiplFdLfJCAoLxNXuU/ONW8g5zr2zC6HdR1ERQhExecpZPS2nNawWqd6sblVenBuepHFciLaIBO1taZirjUoKP4L4VjHMRL1mkOG6dS3oiwpq9Ni9KUN8U/ZdQx5IUbtbYPo4R11gHGX0tJoRH/LZePd9W25A8Mc1qKcXdq5X0QOvwW0R7JF9e2uyqKFn2gDWYFJSQ4EEBDUgOlhnFXRRIg4F7IGk/y27FtZ8KQskmGH1gWd0JDmh60N24zWWfw5c5bpTnmIC9INo/BqcSf98rAtasE2CduWpydyypkHFFiiUSrQIk5UxOZi0itJMtM1j0VdTjEXYO0aUm6s5iJwQgIJ/YZjRkMuXKfDvbT9y2gk6Bpex+bVTif7QvMdSuJdmlEOfDTbysxoEky
 UvEUOnCs
 PrRyGFPr5Elt7yT/sHB9O9OmaeuF6LcFv9cQeETOlOSAP3HsjPxLS9DkEiRQkmwlcb2amwjEDZucxjCccXDxLc0EwSRgjceELy3vMeMgIu7CWyy2IhMx5iOx5QCAIQLQmIyozefjWZZw0EpWCxD2NKK3jtmJkYpI6EzzJoj5Uu7vzTOFOPblk1a706Cw51Gpu40ynyc8Y0bcCdbL5SjLpbDcQjL6n/jdIrHd4q0eIJgOpX9qOBL0z1FhHuglSQUkTdVf4ywYXR4X1U7d2WuxfgkglA4wHwI1BQ05ekWzcljSimtOQ+cWsuhU15Lby1+2nBgwfrZ+d2hqBDGVvoiyVsFPMlrzNniJ79PsA4t/n+DTHoWTub/aU3HdPabXrsL9lEidGgQCGP1fsLLKvGzhHaRdnrKvO8QBB4N6gJC1VCsXqwlXvQbr93vbiG4NjtAreaMUngnGnPKdcxdnpetHvse2kzW8QRIVFUajZQ7c5+VWqVZbcyMfzqq3TEkekdebQVi3Vzw9NXDiKYjE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.10.25 11:09, Kevin Brodsky wrote:
> A per-CPU batch struct is activated when entering lazy MMU mode; its
> lifetime is the same as the lazy MMU section (it is deactivated when
> leaving the mode). Preemption is disabled in that interval to ensure
> that the per-CPU reference remains valid.
> 
> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
> mode. We can therefore use the generic helper in_lazy_mmu_mode()
> to tell whether a batch struct is active instead of tracking it
> explicitly.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---

I suspect you were not able to test this on real HW. Some help from the 
ppc folks would be appreciated.

LGTM, but the interaction with pause/resume adds a bit of complication 
on top.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David


