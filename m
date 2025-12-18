Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD05FD6ACDA
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05CA26B0088; Thu, 18 Dec 2025 04:49:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22006B0089; Thu, 18 Dec 2025 04:49:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E1D6B008A; Thu, 18 Dec 2025 04:49:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB3C06B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:49:35 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61065C1109
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:49:35 +0000 (UTC)
X-FDA: 84232119510.10.7D016F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id D32F8A000C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:49:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i+zreEJo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766051373; a=rsa-sha256;
	cv=none;
	b=QQPI+kOiB3ps7GSrCSqcmHdldf+TuaS85FPazEJhGZj9Sf+WUJJUBSS/amQI8bEXgeyP0a
	Z9XhtMMYRNzXNoO1y/juP7zeb5K35QT6mVKNnYDRL0Dsfsj5dWeglYXZTXP9w7MSt8Dr09
	TIfAucS/DRCPqqgzyHtsJNUiEyslseo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i+zreEJo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766051373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4f/3AsagFg63ign6qhHYvC5NMnw53xH4g6gUbREbfI=;
	b=jK01BWWKsA6qipdgZ6zHBhNJgxjmdDiLhr2vb2dVxDK0R9uFk7ENP+rWkiAX5IpRwU9qPf
	0Mql1BI+3m5YikWHo/5Rxk3Y2DD+zCmhFQ9h73ozXgEqToPdYRaXv3xZ8p29bTLkvOPoCc
	864OAIn7BOiJd1r8gVV94bfbhPcop2s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A675600AC;
	Thu, 18 Dec 2025 09:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F25C4CEFB;
	Thu, 18 Dec 2025 09:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766051372;
	bh=jpct4wgiQvvz63Cwe2t0WKmpu8qE8JWTj+D4fEqN3KU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=i+zreEJolTQBByW8JlPjfJ3Z1VMPes2Pd7PeJAb/lYS9S+kjePXS6fxK/1oiCfHLA
	 SApDHO3FssA1sTS4F0w9Fy38cvl6WxkWVC0byQPuPQVMzC/aSU38p7T3YrTzKe/lEq
	 +t3yiGig3MducPpc0NbGREP5v9YB9iZndsqe1W4uJCR6ayBC+wFjG6VFCOs/Ruqnwr
	 /aqNqVbKxX2atQFftfDEC4z1dyMeo2hNdSyY1J2kx4C/dxYP0m2u9xYNOYoJOhOi8v
	 V67YJYBgk8qBspVZuXfk+ga0SVCqlyGMbpJhXfGQGXvZ8Lw12uC/zGimGfkUK+YzIy
	 Z5I+jzlJ5xCgg==
Message-ID: <cbea0364-b8e3-4e3b-852f-b16436b60de1@kernel.org>
Date: Thu, 18 Dec 2025 10:49:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/22] mm: Allow page table accessors to be
 non-idempotent
To: Ryan Roberts <ryan.roberts@arm.com>,
 Samuel Holland <samuel.holland@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org
Cc: devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
 Emil Renner Berthing <kernel@esmil.dk>, Rob Herring <robh+dt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-9-samuel.holland@sifive.com>
 <fbfef7fc-4030-462b-b514-498eea6620aa@arm.com>
 <c2597d43-d909-4259-bb5b-9294e4069385@kernel.org>
 <af8fd275-a34d-4b2f-8834-9c85dab2bbae@sifive.com>
 <a063f6c5-2785-4a9f-8079-25edb3e54cef@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <a063f6c5-2785-4a9f-8079-25edb3e54cef@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D32F8A000C
X-Stat-Signature: hg5miwaeqjkyysftxz7zscgwas4xtqcm
X-Rspam-User: 
X-HE-Tag: 1766051373-110573
X-HE-Meta: U2FsdGVkX1+DtjUExRI/K34vuApDL8GnmjfXCUzeXzvyeYtJkabsEVy6hzEUF4MCI2/qvu6T5TOluAm7Jwwgc2i7o1L+DWdhkYOrsUvg23FSdu1C8rm07cSHGWk+OqPLvI01pHD3jl1yJ7K+0Tgt5cICIy7O36H2vDzLvRmoyiBZbuhQs9i2qdJ/7jLnp20si3qS612hFLffdAihxa5o4Ke8KqlHDjBwIlIpBQRmnQn7Yq7cSlY2QRq1Uj28kCIv4FiLaHedgMMw0I5jklHbCNFsG1D0CsqDz7QBAIgRi+ULyGxPFssUiHQCIAyt14mffb/G9WOrNFkYe9FcXwBt2QK6++D8p1UEFsTSFOuZcLvWdDJYj7KDXUkZc1X7DUSMTdAYahgLN3SvhnLv3S142Duys3ufOKJuc0QaWga4W6FXUDN4ueMHyW9oAIeT+doZWU20Xf1agqWvFz0/EIq1PskROCZniUzaeHttn11BuWfvQCmh6OcLIZyl5Mjcu76ESVSuUZ4H/6rU5Ku2zI1MiwldZi7pPmBx43+uksnnlPBmaa7OnCA9oKmlqyUxa6j6YvFdlcPpAVD9sIbBm1L8OIozozDrMkm9aQKRK8whghyN1up2PpvJDe3Qli3OEKUcZiosm2J0tNXbGg0fzk+89CVaMOihSZD+p8bUWI51/9zwW4uWSKIy3nccdoR3HiByJBD2xAsFsNdYvbkfLyBVRHS5S2+5m/TCoX8WkP6u7vXuv0YnbFfBY/c+d5LQpuDDkTi0X6PyWTDEHg8yxAP4Vc7kIbc41js4BHt+EYCpbOoJPvm/0GcxP5k9EfYZNSRSjtIDSgh7j0Al83N6VDfMZRpjLJaGaEm2Du1QJ2P8e8nXJOOmWiHBL5ey66YnFnlHwhE09Lf9uHjyqmVB94VfhKOpyveEX5XiWlabnGt+OMLNN7X7pJLGzXgfnQneJ4JkIB2Ee1JeUeqVsfq4DLG
 L75qGDls
 1pVstgDwNPujSCvIZcwFYhxLoH8zYYknJqqD6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/11/25 14:59, Ryan Roberts wrote:
> On 11/12/2025 00:33, Samuel Holland wrote:
>> On 2025-11-28 2:47 AM, David Hildenbrand (Red Hat) wrote:
>>> On 11/27/25 17:57, Ryan Roberts wrote:
>>>> On 13/11/2025 01:45, Samuel Holland wrote:
>>>>> Currently, some functions such as pte_offset_map() are passed both
>>>>> pointers to hardware page tables, and pointers to previously-read PMD
>>>>> entries on the stack. To ensure correctness in the first case, these
>>>>> functions must use the page table accessor function (pmdp_get()) to
>>>>> dereference the supplied pointer. However, this means pmdp_get() is
>>>>> called twice in the second case. This double call must be avoided if
>>>>> pmdp_get() applies some non-idempotent transformation to the value.
>>>>>
>>>>> Avoid the double transformation by calling set_pmd() on the stack
>>>>> variables where necessary to keep set_pmd()/pmdp_get() calls balanced.
>>>>
>>>> I don't think this is a good solution.
>>>
>>> Agreed,
>>>
>>>      set_pmd(&pmd, pmd);
>>>
>>> is rather horrible.
>> I agree that this patch is ugly. The only way I see to avoid code like this is
>> to refactor (or duplicate) the functions so no function takes pointers to both
>> hardware page tables and on-stack page table entries. Is that sort of
>> refactoring the right direction to go for v4?
> 
>  From a quick look at the code, I think that some cases are solvable by
> refactoring to pass the value instead of the pointer, and leave it to the higher
> level decide how to read the value from the pointer - it knows if it is pointing
> to HW pgtable or if it's a (e.g) stack value.
> 
> But the more I look at the code, the more instances I find where pointers to
> stack variables are being passed to arch pgtable helpers as if they are HW
> pgtable entry pointers. (Mainly pmd level).
> 
> I wonder if we need to bite the bullet and explicitly separate the types? At
> each level, we have:
> 
>   1. page table entry value
>   2. pointer to page table entry _value_ (e.g. pointer to pXX_t on stack)
>   3. pointer to page table entry in HW pgtable
> 
> Today, 1 is represented by pte_t, pmd_t, etc. 2 and 3 are represented by the
> same type; pte_t*, pmd_t*, etc.
> 
> If we create a new type for 3, it will both document and enforce when type 2 or
> type 3 is required.
> 
> e.g:
> 
> // pte_t: defined by arch.
> typedef unsigned long pte_t;
> 
> // ptep_t: new opaque type that can't be dereferenced.
> struct __ptep_t;
> typedef struct __ptep_t *ptep_t;

This is what I had in mind when we last discussed this topic and I 
suggested a way forward to not play whack-a-mole with new users that do 
*ptep showing up.

Agreed that we ideally indicate that this is a HW PTE pointer that must 
be de-referenced through ptep_get() or similar. (maybe we'd find a new 
name for this set of functions).

I talked to Samuel at LPC, pointing him at the way XEN-pv implemented 
support for changing PFNs in ptes. We might not need all of that rework 
to move forward with the risc-v change.

Having that said, I also agree that this would be a cleanup worth having 
(which will result in quite a bit of churn :) ).

So if someone wants to bump up the patch count, speak now.

-- 
Cheers

David

