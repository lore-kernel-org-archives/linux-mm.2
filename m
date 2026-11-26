Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EAFE606A33E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 14:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XM/v0L+X
Received: by kanga.kvack.org (Postfix)
	id 34BA86B05B3; Thu, 26 Nov 2026 09:12:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 323246B05B4; Thu, 26 Nov 2026 09:12:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23B9A6B05B5; Thu, 26 Nov 2026 09:12:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4AA6B05B3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:12:49 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9519A40487
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:12:48 +0000 (UTC)
X-FDA: 85477461216.08.6ECD601
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1D9DF20026
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:12:30 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795702351;
	b=FhTCeHjOJSjVykW/a+cZPFqyqb0SdxYEoRteFbeQd+lvuewbK9XyF3GZ2Gc4KWFTkFoYQb
	B2jadLenvhH6wcD09BNeGy95gvZyJ5l6EQX0hJ/SrCZMT94EpsIt9mB4Ky4eARyeMTL5G/
	vk44Lsv8qFQwmZQZTeXavOiDqmJiuag=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795702351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i2cNc8HSARC2wOejD22JDbD0mwhfJQiUlrWNB6pO/o4=;
	b=7fgj4IvPMZlLGkMMBK9aZAL8IyDOogxu3M59mk91v2Fjs3Kxx2nofBDpWJqBCDlPK01l//
	8r3Z4t7NUQ/IEKVqUS6gtG8/ZUdm30FQ6LvH9vJmc7SX8Cq6WuQ9LfH2E3mKLUpHAozVA5
	r6Q2pjg8diCMlt2wV3ieklYRNlnR0F8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XM/v0L+X";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9311D62DC7;
	Thu, 26 Nov 2026 14:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F20F1F000C4;
	Thu, 26 Nov 2026 14:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795702350;
	bh=i2cNc8HSARC2wOejD22JDbD0mwhfJQiUlrWNB6pO/o4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XM/v0L+X45woIBgANOwNtHPPIUmqXvHJxQ6mG9ukfV9OpVWj+xy+U5/lLU6twpiv8
	 I9moaYBWThXPieB8iVDdrgZRck2TaptOWDWaINkRf87Eq23OBBP4BTZHZiTLQF+6Dl
	 3VoSl6+svsMEeJ2t/4eq+g6pv6fIyAc88iW1KHSuMke+N+vXD7PgYDbZOpIKcCeCBD
	 LeBKC5ixNrN57C6ukG4KDBtar3YC/74xgGg7ZUoS6201lCrDlW5P4oZaRkM5OvGFkt
	 8tKz+wqmdZnUid+GmJ08v/IpaXMQLzrmptGj3dz97OX8yyKN8C9vQpgSwH1Cha7eo+
	 bzApLFZU5wIZA==
Message-ID: <4b60cf7b-bf8f-42dc-979e-71fe6d00c5d1@kernel.org>
Date: Thu, 26 Nov 2026 15:12:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/9] mm/mprotect: add MM_CP_PERM_UPGRADE
To: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>, kvm@vger.kernel.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-riscv@lists.infradead.org, seanjc@google.com, pbonzini@redhat.com,
 akpm@linux-foundation.org, peterx@redhat.com, ljs@kernel.org,
 imbrenda@linux.ibm.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <20261112142039.907090-2-clopez@suse.de>
 <20261112142039.907090-7-clopez@suse.de>
 <3314e44d-dbfe-45da-a1b0-8337784a5e86@kernel.org>
 <5412ba3a-ff32-48e8-b5a1-d46b97cf5f8f@suse.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <5412ba3a-ff32-48e8-b5a1-d46b97cf5f8f@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HE-Tag: 1795702350-459522
X-HE-Meta: U2FsdGVkX194cBDbVmV3JmKW4vGr42C/Ue+qog8eij9m71e/lvvc07YTBgjLZE+hJp+z/SAzyLxpBd6JOtu1dXBVLPb+fEI1wetpxgA8R6mSNz21oqzEETlfnotjudrbF8ub256DRtEBhbzdU7jF7y1fiOEIyx9ZFLaw0/bg1e8bei8r//vrfu7OrqZw+VQ1gFMOaCOTKzOAmgVtJwUQBYzmsOo4miNIRoES1po/FSX76KemDpdzFF7QS85332x5WwRWzF7hG/Cc0zJl7tA3TnNQcKSGMWipwb1nsSmqKIRPtN8lkm8pJIQ7LVJGY+qq8HCvw/KlibX7sBRIxls8wvikHgxNeoYmSbFzbE8dt+c5fHQoD7FCjb+VEzo6kTnd3Tq5+vbrbP4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/15/26 23:03, Carlos López wrote:
> On 11/13/26 7:51 PM, David Hildenbrand (Arm) wrote:
>>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>>> index 84bcfe0281d3..8c0fcd10f5a3 100644
>>> --- a/mm/mprotect.c
>>> +++ b/mm/mprotect.c
>>> @@ -767,6 +767,17 @@ static const struct mm_walk_ops prot_none_walk_ops = {
>>>  	.walk_lock		= PGWALK_WRLOCK,
>>>  };
>>>  
>>> +static bool vma_flags_is_perm_upgrade(vma_flags_t old_vma_flags,
>>> +				      vma_flags_t new_vma_flags)
>>
>> Two tab indent.
> 
> Will fix
> 
>>> +{
>>> +	vm_flags_t old = vma_flags_to_legacy(old_vma_flags);
>>> +	vm_flags_t new = vma_flags_to_legacy(new_vma_flags);
>>> +	/* VM_ACCOUNT does not affect page tables */
>>> +	vm_flags_t mask = VM_READ | VM_WRITE | VM_EXEC | VM_ACCOUNT;
>>
>> Why is VM_ACCOUNT a permission upgrade? At best it's "no change".
>>
>> What am I missing?
> 
> It isn't, this just means to cover the case where mprotect(PROT_READ |
> PROT_WRITE) on a private read-only VMA sets VM_ACCOUNT as well. Without
> this, the change is not detected as an upgrade.

Why is setting VM_ACCOUNT and upgrade for permissions?!

I'm sorry but this is all way to shaky and confusing.

Take a step back and think how to do all of this cleanly without making this
code here unmaintainable :)

-- 
Cheers,

David

