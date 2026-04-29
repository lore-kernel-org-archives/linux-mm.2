Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E2BEFF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60CA76B008A; Wed, 29 Apr 2026 11:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BD7E6B008C; Wed, 29 Apr 2026 11:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AC9B6B0093; Wed, 29 Apr 2026 11:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36DB46B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:12:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8866C1584
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:12:10 +0000 (UTC)
X-FDA: 84711934020.29.C4F3750
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 77DF540014
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:12:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X77e7OZy;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777475528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIFsdpU37KWnRnOSzyREX6cnqaju9TfHn4yZ6utUnI4=;
	b=WLb3tUSmgFJ8y8nGvrJMK5McoZK7BHgtgb1VvOOCe7f4xQJBj905TUV4X2ooB2gXKgLz+C
	9xw3iXFxCqi/aAm/OcztonfF4temEK7SIcju0FKKuKmq01NST/AL9g1hL9CBj5C6OipHno
	nQePlbbuYyqfLYusckZktm2hQSdfwik=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X77e7OZy;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777475528; a=rsa-sha256;
	cv=none;
	b=6tUk5F/k80f5j40+i/0nhXEh7qCUu2+JszJqc5a0sInlqgew3qA8IghjtQLf/JUvDiVZcQ
	5dTofjsdoFYpfyPjwY2AjrD/Fe1Zn9hYuMJJv5lazFblHz1e/LSl1gkj5sa8/hwyxuzZlk
	I7vRCJLpPPTCWNRaHdgsBj+aOPHMmOo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777475527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MIFsdpU37KWnRnOSzyREX6cnqaju9TfHn4yZ6utUnI4=;
	b=X77e7OZy8hVYjmMbYBghxW4yk4PwDn385ZVXZKaZnAxa77/vGJY2jGQAZdS1eJ1T3gKYa9
	VgeljOQMzp9SJ5wsvcjjEI8Npq/97lIu70PxQ3+HFMhHfQz/ffnErL5fK8ojYZIVfqg3bR
	dgfgA8mFF1SrU4dw/hBNns8kqKaOrH4=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-bFHVGzj_OlK4ihVe929xEg-1; Wed, 29 Apr 2026 11:12:06 -0400
X-MC-Unique: bFHVGzj_OlK4ihVe929xEg-1
X-Mimecast-MFC-AGG-ID: bFHVGzj_OlK4ihVe929xEg_1777475525
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-389fef1b721so56191891fa.2
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:12:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777475525; x=1778080325;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MIFsdpU37KWnRnOSzyREX6cnqaju9TfHn4yZ6utUnI4=;
        b=crLiyh4zJWtpF6wEyeD6I5mwiFzr6vZ/ePVD4/HcnPoukF55ycEEbMyRsDs8laGRqv
         jHDqNbFh2m0ss51wyvlwwTkFtP1s1dbx8GmalnA1YToxJZFLlXR0mWpxISb9Fw4GaueK
         xswkIEbe0PRGAZr5cXuuwsTe2vJZ7eXhAaA8OH6PNbfXu6Bde6eLtaXtaQojdCRd2XyV
         3jy+wru2D9qoHZDYMkxdIhbC1nWNB7Q2mQs2NbJLtlos0VjRrJEIBpKBnekWxJ9njJlj
         Z94iuzf1a4R07ihy4VsrLXfcVEjj+cV8W4qfo7Sp3yo3jgtr25a0ebQUyxYXExprhSg5
         syLA==
X-Forwarded-Encrypted: i=1; AFNElJ90SLKX77Qp7PlylKFowIKIaGVlGWm62TbiQAIHKfEkgFg2VRsfv1ZBdeye+PY3+1AYpWgjHXn4Pw==@kvack.org
X-Gm-Message-State: AOJu0Yz3OvhMYepVxRh8R13wi79ZJ6h1GiCyLLo+a1On/iSvCMeZCFLb
	w8t6vKipznbsEP+h2PL/rctR6oSnKvb5WHSrHLnfhrBlK+bwS3q9GGoH8Lmdo/KKrqyIkm2SVLH
	VnFGweUcfuTRmg5VS0sZQcbNVktey8MIzeBzwawgy1UilacQRu3fT7m4YTamnyI0QatkbdgHK8Y
	rmHzGr9bubzT+o5aUi3gkIsh0Vl/4=
X-Gm-Gg: AeBDietYcCtNCcULVu5miWIOP1eL3XOVEhaCG/Q6iDXtV+nI0oFE98z4qn59TV8modd
	lUNC4Dn6uMi5hQHDW0RXjXjS4vvkFJBnnxg13JXn7ANte2cHz3LANsZnrouPdb0EFYeq4sAHeos
	CqlZyu2duQqN8y0QqbR5st3v/tv43b7yeWIAwpydTtnFrX1vUo5uYMTHU9gIK2d1M6LLnClY3jz
	dqQGvUJ88+87pFdbTOKtLZhEcQam+IehYdrfGhSWzPPPxYO2ng=
X-Received: by 2002:a05:651c:41d6:b0:38b:f0f0:e3f7 with SMTP id 38308e7fff4ca-39240cac934mr29426551fa.7.1777475524874;
        Wed, 29 Apr 2026 08:12:04 -0700 (PDT)
X-Received: by 2002:a05:651c:41d6:b0:38b:f0f0:e3f7 with SMTP id
 38308e7fff4ca-39240cac934mr29426101fa.7.1777475524415; Wed, 29 Apr 2026
 08:12:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260419185750.260784-1-npache@redhat.com> <20260419185750.260784-5-npache@redhat.com>
 <e9dbe863-d125-4fe5-8ecc-91ad7293e5cf@kernel.org>
In-Reply-To: <e9dbe863-d125-4fe5-8ecc-91ad7293e5cf@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Wed, 29 Apr 2026 09:12:08 -0600
X-Gm-Features: AVHnY4JWHIajx86OyyAW4xEABiDRXdIc8my5jlzqHRFOcHufFZGfWfjdV3YP0YY
Message-ID: <CAA1CXcBfFcaXRvx0UnutjDV_ozcRXUmVCXZ6E6HH0buX=BYntw@mail.gmail.com>
Subject: Re: [PATCH 7.2 v16 04/13] mm/khugepaged: generalize
 __collapse_huge_page_* for mTHP support
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, ljs@kernel.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CKkMWhY0N9vQCTdXGGmYVy0TWIbCbOEo6yBidBAbjc8_1777475525
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: u549x448f3acu4we7e5oe6gzaabk4xsu
X-Rspamd-Queue-Id: 77DF540014
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777475528-806846
X-HE-Meta: U2FsdGVkX19EP5sgkmXBnKRMJBfUnbW2Cy4/QfpHF0btrqIqORJoupecpS4z5yQ8hHmECPgJhnPxXwob0GPOQkJRRMAmcCkW2EagC0RPArlMjJ7nusXBzsRjkTZTBedgj5sM06myZUeN5oFZ28KiJ7qMwPSGegn+AM6NEQJGv3Fs/VgfMbfQH1vuWJc2HHTQZioSwO29AKywkTrkMUlfRHsPrCWKINfLF1xBH2mhk/uVPOK1CQh6LIXGpIVfaTsp2UPNY6RDOboVSoZqChCCeOEi/TA54bSWYg/5rxHUGKBV+f3A0Mk6gw09L+CKUS0tTSdSfs6GwmeY9q8jCFSwFEgxbpMAyIn1zetgxuDNjo45+l+m9mGA2dPrV8gxUeWNy129zCqpbmRoHk40z7B/tdfghsvFtAk+BqDOap0xmZQTuxIpuNYfwSLeXY39CUagIAx/csFDw9Ig1sUgOOX3vTcXfkMD261peNu8hm9nx26G88drLKiXLViFPDiUMp4lkq6oAAs0UxzeM6Y5GvJfZmtm8lZdX7AYjWMUzjPTqRdMe6jf8KOqGduhIi0ap3P7nnBrnJ63RTZKJHtIMuDGVdUjPVsQehMJWYBl0b3l/zroYCgwOk21OZwZw5eOAGftV+4H8Rohc7E6jFl20wnCFj9elgVfBDOcNtJjeQ3repFUKIWgVO88hLJWgFkuvkigI21qYhXN5WNr3Df7b2PjH4+p8+ClxYbA3kIjJBb+IfiiB5oce2mtHPR7lTwqHUR7JxlT8RlZD38tm3Mfmd+oyhAbp5j9NJ1uah89P9s7pzQ1IHA6bpBsqjicoge5udf8dGj9Iooi1j/TuS3k94orse1QqnUTAHqqEe/wZUGJp+KDiziWthayct9ixPE2u5MI+Z1XBXbc1K2tJnYTDx4/i0aerXfytjxPJY/eQaPcuLAX88aa5NnufcL5bwwbaQO0LllA1uThyOj6pXX8cA0
 HLLo4P4r
 zsJgs85gZVeBYuRIZJV7wDBeUPfLaL7a9qDTkrcSeXUgpZNvlUAqrIGXPxVEsnTTCm/qmCobgfrn2ekl8lSjMKvAjbqoeN2SLMHz5wscQ208iBMEClKZs3XPyCtUatTg26rg3Luz8IyQStiEVWI+g6MUgc3mX3MmAUgehBeQStD2LNBtqxXpEiL4cFSokJ6ujrfqr125CHflprodFw2/auaLVe2yECbJIQdHPDdclrLFdd0YFVCtpA0nEr9lyTZPh13iki/wRFYH1Msn18qgQB2GQggUrk2QQ4f7/qUIjB64/biqwYS7s/hEgjfxuiFGl4FleSFgmxCssn1NVkoTypHOPNoJCkkkMGs7iAR39j3nZ2+VPdXPJNKGeCwEA+rttNjygxHjI9hGQaxRCLR9KmjNeQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 2:07 PM, David Hildenbrand (Arm) wrote:
> On 4/19/26 20:57, Nico Pache wrote:
>> generalize the order of the __collapse_huge_page_* and collapse_max_*
>> functions to support future mTHP collapse.
>>
>> The current mechanism for determining collapse with the
>> khugepaged_max_ptes_none value is not designed with mTHP in mind. This
>> raises a key design issue: if we support user defined max_pte_none values
>> (even those scaled by order), a collapse of a lower order can introduces
>> an feedback loop, or "creep", when max_ptes_none is set to a value greater
>> than HPAGE_PMD_NR / 2.
>>
>> With this configuration, a successful collapse to order N will populate
>> enough pages to satisfy the collapse condition on order N+1 on the next
>> scan. This leads to unnecessary work and memory churn.
>
> You could add a link here to previous discussions.

Ack, not a bad idea for historical reasons.

>
>>
>> To fix this issue introduce a helper function that will limit mTHP
>> collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
>> This effectively supports two modes:
>>
>> - max_ptes_none=0: never introduce new none-pages for mTHP collapse.
>
> "introduce" reads wrong in this context. And I don't know what a "none-page" is :)

Thats a page that is none duh ;P Ill clean that up

>
> "never collapses if it encounters an empty PTE or a PTE that maps the shared
> zeropage. Consequently, no memory bloat."

Thanks that does read way better!

>
>> - max_ptes_none=511 (on 4k pagesz): Always collapse to the highest
>>    available mTHP order.
>>
>> This removes the possiblilty of "creep", while not modifying any uAPI
>> expectations. A warning will be emitted if any non-supported
>> max_ptes_none value is configured with mTHP enabled.
>>
>> mTHP collapse will not honor the khugepaged_max_ptes_shared or
>> khugepaged_max_ptes_swap parameters, and will fail if it encounters a
>> shared or swapped entry.
>>
>> No functional changes in this patch; however it defines future behavior
>> for mTHP collapse.
>>
>> Co-developed-by: Dev Jain <dev.jain@arm.com>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>> ---
>>   mm/khugepaged.c | 124 ++++++++++++++++++++++++++++++++++--------------
>>   1 file changed, 88 insertions(+), 36 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index f42b55421191..283bb63854a5 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -352,51 +352,86 @@ static bool pte_none_or_zero(pte_t pte)
>>    * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
>>    * @cc: The collapse control struct
>>    * @vma: The vma to check for userfaultfd
>> + * @order: The folio order being collapsed to
>>    *
>>    * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
>> - * empty page.
>> + * empty page. For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the
>> + * configured khugepaged_max_ptes_none value.
>> + *
>> + * For mTHP collapses, we currently only support khugepaged_max_pte_none values
>> + * of 0 or (KHUGEPAGED_MAX_PTES_LIMIT). Any other value will emit a warning and
>> + * no mTHP collapse will be attempted
>
> Not sure if we discussed it (and maybe I had a different opinion back then ...),
> but could we simply to fallback to max_ptes_none=0, so we can avoid returning
> errors here?>
> max_ptes_none=0 is ok, because we will not waste any memory. The warning clearly
> tells the user that this combination is not supported as is.
>
> ... and it would make this function a lot easier to handle. In the warning, we
> can just state that "falling back to ... "max_ptes_non = 0".

We'd then be "violating" the uAPI expetation and is the whole reason we
have this 0/511 behavior in the first place ;/

If it wasnt for that issue I would have a completely different design.

>
>
> [...]
>
>>
>>   /**
>>    * collapse_max_ptes_shared - Calculate maximum allowed shared PTEs for collapse
>>    * @cc: The collapse control struct
>> + * @order: The folio order being collapsed to
>>    *
>>    * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
>>    * shared page.
>>    *
>> + * For mTHP collapses, we currently dont support collapsing memory with
>> + * shared memory.
>
> "do not"
>
> "shared memory" is misleading, as we do support shmem. What you mean is maybe
> "collapsing with anonymous memory pages that are shared between processes
> through CoW" or soemthing like that?

Ok ill clear that up thank you!

>
>> + *
>>    * Return: Maximum number of shared PTEs allowed for the collapse operation
>>    */
>> -static unsigned int collapse_max_ptes_shared(struct collapse_control *cc)
>> +static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
>> +            unsigned int order)
>>   {
>>      if (!cc->is_khugepaged)
>>              return HPAGE_PMD_NR;
>> +    if (!is_pmd_order(order))
>> +            return 0;
>> +
>>      return khugepaged_max_ptes_shared;
>>   }
>>
>>   /**
>>    * collapse_max_ptes_swap - Calculate maximum allowed swap PTEs for collapse
>>    * @cc: The collapse control struct
>> + * @order: The folio order being collapsed to
>>    *
>>    * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
>>    * swap page.
>>    *
>> + * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
>> + * khugepaged_max_ptes_swap value.
>> + *
>> + * For mTHP collapses, we currently dont support collapsing memory with
>> + * swapped out memory.
>
> "do not". Given that this is also used for the pagecache, can we make this clearer?

Yeah! I originally didnt plan on using these helpers for the file
collapse operation but figured hell, why not clean them both up, might
end up helping (hopefully not hurting) when Baolin goes to add mTHP
shmem support.

Cheers,
-- Nico


>
>> + *
>>    * Return: Maximum number of swap PTEs allowed for the collapse operation
>>    */
>> -static unsigned int collapse_max_ptes_swap(struct collapse_control *cc)
>> +static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
>> +            unsigned int order)


