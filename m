Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBDBFCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 15:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29D7280002; Tue, 14 Oct 2025 11:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDA7A8E010A; Tue, 14 Oct 2025 11:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC908280002; Tue, 14 Oct 2025 11:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CC5568E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:11:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A353160994
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:11:22 +0000 (UTC)
X-FDA: 83997058404.16.436FBE3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3D9E3C001A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:11:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Aa9Z/qKB";
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760454680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CFM7dXtICj/fa8yA6o+n0YfJf/ny9ONIQh0B3zZDb+k=;
	b=CEzN5+xdwRPxlUtJXn0B5RA6EkxItS7+Yv9WmQsVawIpG2XQZafvaQIEMASp1jYlJWZ+CF
	nEPfS+RfesD9FYzv2M1msk1nRqw0OSrTgmIOCHyIeEA5Cgv0ccpxDllQ2W5VBC4lzM+Jyr
	XbYuLoc3hD54Vz+SyBgiAU/aewk6OVE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Aa9Z/qKB";
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760454680; a=rsa-sha256;
	cv=none;
	b=bPXpJA/thkrxBgUg9posIdFzSu00oN/UVawHJc/QJbVUVoKYqjy6DHWrTmModUb8/Z+ZMb
	Qtvxexzt47IU+5mk/r2e/sJTaejMVhvYl7hlVRwU0uczGIkDhHMcxiPrsjtaWg4xZNF974
	uEDVz6ue25ljsboRYHvT7os+PvgNEFg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760454679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CFM7dXtICj/fa8yA6o+n0YfJf/ny9ONIQh0B3zZDb+k=;
	b=Aa9Z/qKBxtR8TxZR7Zky1ZVt8xpwMHBk3Ay22WgMydKT8P2WZwBjw2A7Osynko1YRPBzBI
	jFuMv0ZjZvpwLzhHlbSBAzC9GzROQcKGbaUvH4xjv4DeUo2qam3fvZCGvjZuH9FYQHNLC1
	Dju8JbiFeX8g/qpupdNQ8XObwVPyCEg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-H1mLTMqeOA6sZOl0Pc-Ntg-1; Tue, 14 Oct 2025 11:11:16 -0400
X-MC-Unique: H1mLTMqeOA6sZOl0Pc-Ntg-1
X-Mimecast-MFC-AGG-ID: H1mLTMqeOA6sZOl0Pc-Ntg_1760454675
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e3d9bf9e1so36854055e9.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:11:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760454675; x=1761059475;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CFM7dXtICj/fa8yA6o+n0YfJf/ny9ONIQh0B3zZDb+k=;
        b=tYxULlmv2H+zpwnu40PzaN5IsO0rbiI7IVgw2hYpMb2zoANR3WOHqa5JAvogmR7NyG
         GkPM6OEnQyOhEuobapHBbHUHmFbluaBAIkRJ26ayiI2hqK65O+ZHiQmEcnojVbcZuQPQ
         koCWyocp5z5Cd9yRMk+vxlilfdcsPBmzEwcC41MGE34C6tsZtL9QXc2DlnijMPpR9VG1
         CZvv+3tH3M3uLg8Yto6Jokual2FtQEbwoJb+MQ2JIOm7k1GhPyAeFlFU3uYmpYaNzL1M
         jYKEWfAbArqsOa+Xrla/OtAKXYD83tZt/ZmwBjtKYtpbyV98jtkw2qDEvXkgp3Aw0+hs
         4NMA==
X-Forwarded-Encrypted: i=1; AJvYcCUKSqJoMwPAVK7IAin67XzbMCEdiXasC8YDZnJEp7ZEHNoJAG4v3aqK6W88bHlD8e+HqspA28XPJg==@kvack.org
X-Gm-Message-State: AOJu0YxbGeWPktb7W76r99hfHzFSI6XO+liSXQNMnLasuT7TusYKAgLe
	ZRCHStlDyhoc/80kWz/grL4U3s8fQoFYPcGFgamIiX8sTk5XBXoHCTyCCIHZhz8ghuk0ayby6ck
	ReqFTY9OKQlPmalVtY0GnG56g3xnJ2qrpZuaoxkT3VwWLgbYK2jkSHFvy3ryM
X-Gm-Gg: ASbGncs6RAYuk143sgG2w095huwDmnCitihco0KyeST1Wd4mRJBUlfUg+HJLW62Lj2r
	wT11eXzcs7QJ3Lx3zjyH1c0pogKHeC8lmAOTEHIjdcQ1raqqYgWHiqgYyA66LhFDt94TeHqzJSx
	SG7NCaMhl4/2yoIYCOKnHDb7BhFcT9lTjHa1B7sUUnN/6mQOnt7G9CkNdXpNTpdZVo7KR164YNc
	hMKlPqw0DY6JR1Ahr4M01gu52UthnhtfcIwlA6Yvt84iFU9UNN8ICFQOs51p+ESqLVqVZP70chO
	tv87zParuYtC0T6ghCUHLpvkyP68mArcyYDasVgyAw/pYQx7fTZAjHf0KpODsyHz6kc4gC82Ig=
	=
X-Received: by 2002:a05:600c:608d:b0:46e:6d5f:f59 with SMTP id 5b1f17b1804b1-46fa9a8b2aemr174419295e9.4.1760454674824;
        Tue, 14 Oct 2025 08:11:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGAGYdJNsQt56FoIi3mVgcJVNPd2gqaodPPXK/4B0rTbZ0qKVvefWZK8UoRY5YIzCmIEwIKPw==
X-Received: by 2002:a05:600c:608d:b0:46e:6d5f:f59 with SMTP id 5b1f17b1804b1-46fa9a8b2aemr174418995e9.4.1760454674352;
        Tue, 14 Oct 2025 08:11:14 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb49d03e2sm246982765e9.19.2025.10.14.08.11.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 08:11:13 -0700 (PDT)
Message-ID: <95a223b1-8d57-40c3-8226-678b1db233aa@redhat.com>
Date: Tue, 14 Oct 2025 17:11:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
 ioworker0@gmail.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mpenttil@redhat.com, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, richard.weiyang@gmail.com
References: <20251008032657.72406-1-lance.yang@linux.dev>
 <f33735d3-b38d-4b6a-aeba-b415e6b24ea2@lucifer.local>
 <0bfdbccd-9d4a-409f-ae43-b44bb7347d70@linux.dev>
 <f7392f43-b8f1-4e6a-b9c8-25ad8a47f82c@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <f7392f43-b8f1-4e6a-b9c8-25ad8a47f82c@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pOrrtaSZTDGnNp0PKi1Q8HPfrgnXLBZBWzuT_Qy80ns_1760454675
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3D9E3C001A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: qpi4zy48yhmqppi6444qdqcd91usp1bs
X-HE-Tag: 1760454680-348763
X-HE-Meta: U2FsdGVkX1+aukOryV80r89FgBZPfAHysgzC581ogNs+HTiY5jFmd5q2WOEjOQzHzFqXN4F4kaihlhUSt+f5UdLRI7+SAHo15mJmzsmS9y7/Qv2T1PZ/uKQSUF5/hl6MTm3JJZkDQyLua0OAwEQ4LgQ6qwoJ7h5LTM0rrOJ2SXHkXUtwRdou+RwHXddCCSKjtPV7VVJXHScuov74+J1/mrOEVHdMpWSB60ORLzRkEcgYD9qdPYzrxiYCRDrUXYkwRXIdOf9J6Z/Gvb8sQJ8zP9UqfXjt3o8BmX5L4WrnK2yQJSAdME02kdRo2HZOHsNE51mHaZwxNGy4gezXOf/n3V/acPa7Eqoud87zd1dwa5HlmeMmuPnTvduiN8pGulbGiDBFz2cr8YXofemQCLqOILpJYNzSPPhz5eFu+mSo+ofixpQgb9GUMYyq69MlO5SZm6QxxH1M1QrsFiBGk+8sM4rcb6SQfudjdLLbxwpO2pO2QUgwFHpxY1oPaDaMX2BurbOFxxicJfR9EaFksaJL3RKwFDaKMZZUZB3QxrbIuK/iW5BXOGzTy8rqOwprLgQ4ejZMQLZK+MUsxBCbyUHdH7cJtPdZZy7uLqJ98b/jT8Da6aEAbjmgfa/DH4do8ItFLFY+nHephV8DnQSue+xTRhRlZMZHxwlM8YvwVndLDnViaOyeBfPq5dwlnhvNPawultvvSKytbImjU9hTfc9oo5TcVB3sEtt6+VzLkUbArwd86B7meVU5A1S/NoM3t1nF3HtPgfTUQMhYDQBoW9SxO8APvOhz3pstF9SiX3qTMMc2UR42uwf4TM+gL95jroyvYzKI7lAx04T7lpyiUtc5uYWlZ5LiwctIkOrTQY2SYMmpDTpPxjPwcKNNXdHsw04dfHtngrlC9pY8rRi9Ik2Sf5kkZJ630J8X7N/o4EKbU3WRBubbZLbWoWI069I+CX1gI9UOtjV5vERCgjo26Pe
 Tbawr6I4
 axvBX4wngKb9O3D+jDDSDue75nDtBjCzwQiNvp1xZfvuUPaH7nep29fJqbCV8+VOheCoJbOGRCET/BfoecCyHJTEWquP2oSs8zt+6IgtogwBgpJFDK8YKZlyBodKiqPSyqcXQS2AFM1YpjYXUfFdzLt/bvxBBeMkywUrheFAKwgiL9KcAIZ4eKKIF6LgnzYrTk5o5rpADwrIlbCd8PlJXWgv6bwciXqJOpyLdTk8PZi1WrPubomrjvMPCmAHSvuqLbEFL+NInWoQ083aa4/Rne8kIG2kCo3FKCJbkf368c8+6GFKvYs57kr9KZhkFCUmofdkUaio+fEMOa+4X/KVnH61Z5nLBxGgsoggiJ7faFRDUJOHnIi79tVMsI+w393Fb66ASADF4/oPFT4qQBObfeykxoTwMkcHe2Fxj/fte2cSRrmcUPxm5Ehyzez0v9FNpEEmLC0lActV3RwtOUdw1yVmkeL2vKgMbTU0ROdh+m4VfmYoV3xZoojiZBNiGCyFSKCgf1YmaLMsdQ6+DJ8TAwTR3vAxtRiNYn1qtVe9jHpP8FQa4FMToIMwkp0PjWGljUYl2lsRcI5KRr4h9F2Mqu4/GOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 16:39, Lorenzo Stoakes wrote:
> On Tue, Oct 14, 2025 at 10:26:20PM +0800, Lance Yang wrote:
>>
>>
>> On 2025/10/14 19:08, Lorenzo Stoakes wrote:
>>> On Wed, Oct 08, 2025 at 11:26:57AM +0800, Lance Yang wrote:
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index abe54f0043c7..bec3e268dc76 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -1020,6 +1020,11 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
>>>>    		if (!is_swap_pte(vmf.orig_pte))
>>>>    			continue;
>>>>
>>>> +		if (non_swap_entry(pte_to_swp_entry(vmf.orig_pte))) {
>>>> +			result = SCAN_PTE_NON_PRESENT;
>>>> +			goto out;
>>>> +		}
>>>
>>> OK seems in line with what we were discussing before...
>>
>> Yep. That's the idea :)
>>
>>>
>>>> +
>>>>    		vmf.pte = pte;
>>>>    		vmf.ptl = ptl;
>>>>    		ret = do_swap_page(&vmf);
>>>> @@ -1281,7 +1286,23 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>    	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>>>    	     _pte++, addr += PAGE_SIZE) {
>>>>    		pte_t pteval = ptep_get(_pte);
>>>> -		if (is_swap_pte(pteval)) {
>>>> +		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>>> +			++none_or_zero;
>>>> +			if (!userfaultfd_armed(vma) &&
>>>> +			    (!cc->is_khugepaged ||
>>>> +			     none_or_zero <= khugepaged_max_ptes_none)) {
>>>> +				continue;
>>>> +			} else {
>>>> +				result = SCAN_EXCEED_NONE_PTE;
>>>> +				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>>>> +				goto out_unmap;
>>>> +			}
>>>> +		} else if (!pte_present(pteval)) {
>>>> +			if (non_swap_entry(pte_to_swp_entry(pteval))) {
>>>
>>
>> Thanks for pointing that out!
> 
> You've deleted what I've said here and also not indicated whether you'll do what
> I asked :)
> 
> Please be clearer...
> 
>>
>>> Hm but can't this be pte_protnone() at this stage (or something else)? And then
>>
>> Yeah. The funny thing is, a protnone pte cannot actually get here, IIUC.
>>
>> ```
>> static inline int pte_protnone(pte_t pte)
>> {
>> 	return (pte_flags(pte) & (_PAGE_PROTNONE | _PAGE_PRESENT))
>> 		== _PAGE_PROTNONE;
>> }
>>
>> static inline int pte_present(pte_t a)
>> {
>> 	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
>> }
>> ```
>>
>> On x86, pte_present() returns true for a protnone pte. And I'd assume
>> other archs behave similarly ...
> 
> This was one example, we may make changes in the future that result in entries
> that are non-present but also non-swap.
> 
> I don't see the point in eliminating this check based on an implicit, open-coded
> assumption that this can never be the case, this is just asking for trouble.
> 
>>
>>> we're just assuming pte_to_swp_entry() is operating on a swap entry when it in
>>> fact might not be?
>>>
>>> Couldn't we end up with false positives here?
>>
>> Emm, I think we're good here and the code is doing the right thing.
> 
> I mean sorry but just - NO - to doing swap operations based on open-coded checks
> that you implicitly feel must imply a swap entry.
> 
> This makes the code a lot more confusing, it opens us up to accidentally
> breaking things in future and has little to no benefit, I don't see why we're
> doing it.
> 
> I don't think every little 'aha X must imply Y so just eliminate Z' idea need be
> implemented, this feels like a sort of 'mathematical reduction of code ignoring
> all other factors'.

Not sure I follow. If something is !none && !present it's what we call a 
swap PTE (that includes actual swap and non-swap PTEs).

We have the exact same code flow for example in 
copy_pte_range()->copy_nonpresent_pte() and I don't see a problem with it.

If we were to ever change what we call a "swap PTE" (I don't think so?) 
we'd have to fix stuff all over the place.

Maybe I get the concern here wrong?

-- 
Cheers

David / dhildenb


