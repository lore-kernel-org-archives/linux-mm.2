Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A286C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 19:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89C176B008A; Thu, 31 Jul 2025 15:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874006B008C; Thu, 31 Jul 2025 15:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 789C86B0092; Thu, 31 Jul 2025 15:20:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65F9A6B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:20:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E0694140AB6
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:20:23 +0000 (UTC)
X-FDA: 83725525926.02.8A43980
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id D5CCCC0017
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:20:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Xj6zeix9;
	spf=pass (imf10.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753989622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xRLUrxlBQp402/1+RqPQa0gOaP9InJ6DfzqqzSrs2is=;
	b=hVG/cSEUL2nZgHTcUOiBtzq4ItxezBXpf+QprQTh0Vdic8K1BLyU61+f4UgJldjvf3bUxc
	SXy1VIpF7uR9+CDm16/KD4o/34rxZYkPs4XorDUDN1DcKMsAxF1Pv+4GhOzTGisvjalSgG
	dp5+fC5IEeiKVhc2EI3piufXgZGo10Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753989622; a=rsa-sha256;
	cv=none;
	b=G/Vy2HuRH7kEzsyjhMqYIrYcph2MwreiivJJSwTktQH3oP0u0zZKaQlrDu70kxPfQfFG4K
	fvp2nAnzlLlDctwd7L3/PlkcpOE9WxknUZngpXZFNhuNxAz13G4poQoeRo1lnqrUup9NWc
	/pVY75CnAxepHrbhDoSLpc6/mVcj3ho=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Xj6zeix9;
	spf=pass (imf10.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b78a034f17so51235f8f.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753989620; x=1754594420; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xRLUrxlBQp402/1+RqPQa0gOaP9InJ6DfzqqzSrs2is=;
        b=Xj6zeix9XbzQp3KNJ2OGMeGcFPgmJqZyOQe3PHN8y/tTgER97oAHqCBB16bW6/Npr4
         20Q5h7iJXLTQRe+ILqYftJgWuH/pGcLiswjbesJouRM6yX+RAuswByUqJhkxUQZSC5+M
         tQi6Lj7iLLouQH/7rSrrPnt012W6Sr8nhuDpHXKTjswNIUeriGD09eqLY9hESL4EfC0T
         9Txi3BFF8UsAtaItBMr932GGkj7mSVNMiwGbs7blaQ3zhd4Phs6sxYwfyhgyv1KvR/Ij
         2+HkriXPGkq2+EAO9l9iEaVck3HX21AmiUQFNb/M+WMPICZcjCCHCapUUzV+C8qIzsd6
         9iYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753989620; x=1754594420;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xRLUrxlBQp402/1+RqPQa0gOaP9InJ6DfzqqzSrs2is=;
        b=PfyT3v1qGD33q/PObdRBgxLDkEOQfKcwQFHq6LmJc19a1dtSZtOZbjZLuok//FhRY6
         n1jlDrIpLOxiv1aeNZrBpcbOKx5hBXbkCkHkIqhJtJW7EoCWJGaRNqpU7D0/ZU6Wz+oE
         KowdfFH5J1C3EpLVyn49xqG1u7CDDPpBh7phtur0Dw3LOBWb+ocGvZG/UZjsgMO2XVH3
         qSAEY6kLzt5/zOD+bpqRkxCSAe3XapPWgY/5uoWBIabCKwmzjM/ZnIY8rcMIaTW+cnn2
         Skyg2UCVPy/3zsa2uniF4zDWz/hxM+sfiepGKJdFoLxPZYUxx8DNWU5VOh/DFU7fvu2v
         5Ymw==
X-Forwarded-Encrypted: i=1; AJvYcCXn0zn7LAfsgkUw1mckt+KfkBSeDMk0IUGgDLKmIIzjfx/8uy9lo+5U0KrYetL0v8Y4j+pPNqaaTg==@kvack.org
X-Gm-Message-State: AOJu0Yx3DaFC07mtuP4DL7yO1V0v8VHOGdLa3vvPPgaSv7ISfRx+zPia
	T/q3nrBqTF5gfBLIWyKa4q/fa7tBH/CRjgYtStQ4SSE/OUssgdAqc6tX
X-Gm-Gg: ASbGncsYHcbwVmd/fNyxBsbWuIhYbBH/5oms5KJau8JBflzhTxas3WDb8I+/zbmErWN
	CseAoLsA6WExzbkAaKEc7xPpMl/O7UeU35rbfdHaKAJx1lW/9rsgb/61Bg5tGnmLtcrAv4t93gU
	fAbt1wFD7lMMf3vj7ACx2WJIQCiYZonVzWk+8/lRAtHr8Tb5kZ/wz2cz0243nHWj7A8+ZSOprud
	e+7ri72NqnUEDrp/afFnX9FU5FnjF/kn4T5rIQMPWiBp2aMk3U9ajsvhpLUOGucOd5R8Jwk/VE6
	5Q/TZ4YoUHug5MIxBbmNZhJelrRnvXDVpq46Ufb2eEICp0vydpRZt/0Ag1chk+tikKCFBWHSKLn
	MyYUuaS/TXnkaKHRuG1f33xv4X/QlH9Hpf3W2iDUSdr/qq9CvECaU90mviTfa5DpxoeMxYM+aOg
	Kmo8dg6FM5AA==
X-Google-Smtp-Source: AGHT+IEx20gxDUvHP+1hO/8jGFnF9jdKE+U4NP7atpCHfRFhwcjxuJhbA9fC6HlRmlt/4jCJ9Rz40Q==
X-Received: by 2002:a05:6000:25c8:b0:3b7:9c35:bb7 with SMTP id ffacd0b85a97d-3b79c351143mr3125976f8f.46.1753989619761;
        Thu, 31 Jul 2025 12:20:19 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4? ([2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3bf956sm3394382f8f.24.2025.07.31.12.20.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 12:20:19 -0700 (PDT)
Message-ID: <6143b8ea-24c0-4446-a0cd-821837f6e74d@gmail.com>
Date: Thu, 31 Jul 2025 20:20:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] mm/huge_memory: convert "tva_flags" to "enum
 tva_type" for thp_vma_allowable_order*()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com
References: <20250731122825.2102184-1-usamaarif642@gmail.com>
 <20250731122825.2102184-3-usamaarif642@gmail.com>
 <c44cb864-3b36-4aa2-8040-60c97bfdc28e@lucifer.local>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <c44cb864-3b36-4aa2-8040-60c97bfdc28e@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D5CCCC0017
X-Stat-Signature: yxhj3zkpzqs5w747hs7izy3okruo9ddd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753989621-178914
X-HE-Meta: U2FsdGVkX18RxAyxzNvPmqnI49f2fj9+uTW1guO4JP75W4fyPdBWu2KNO2kvSNJHjh7ymcFnDBs9Dl7dX6LY+kovKygvTivrreU7TH7h1cySzAbzKvG915qHcfhjFvQq57ENJb/gMjWj7Qqn4l99Z8FJNM5CrtMzNjivJkwLOUdY5BBl9f3ZvReBg3hMU/HdG56RAiro1mQB4mIFzIZ57/VLz4IEs9nAzQf5QHWEYvUGjfuTkIgGvOA1Kpb0b30OnVP6RuLw4cyTE5wq7novO1/1LHnau7sz/dIILfZnHpBrpJ+cwLbIy5YEdlGZYD4lWy3adaQHLG+x+NCalWuKOBr7sUnzrpeSzulNfI+vNMi4TNKwQ/uunImzRWXykshV/PeNDZc9hPA/qGw9XB6n/kkpcz4C3p24iGqThhmC1l4RtVmDY37fTuy6j19UIVITt0gaelyJmgmyd6wzjc9uMwXL5kaFZ7xkBOqYXIa1BHJHFkH3v8FEqajJLgNqr++yKKVjnfOiHfLb4y4YUsWrSrzCEfF1TBtmahcpC/NMf33Er4TuzoJ6hdgbMo6Kf0Fg7pu0zsSLsjRbFlzeL1qKmvkvgvvJy0/b6R7OmPijdvSvLHR+FgOfaoWpTOWu/25ROofpDq6/7hW7CLQhA44RRkgGFblgoYYyqp8GLQlLtV9Od5IRZgrXdXAeGcGSh6STNTJugAi0TNca8QEIjm7zVOEjOrtW1oUV1qg7SvqGTL29zmyH/ypApuPS43tSWiQeAEesclqXXVuqlR9WfsL6BLseBhsFDtC1fRw/jfYae46VhwLoeQtYj094ahpIdmkwCHmtNamP0T3ASE55cH9O7O6L3luFJSnzJ4G3wXtkSmU+m+8fvS1uh221GuG45jXnxVoZNc7U9DMXffOLqoWrUzqFwXNEkHu/rEKFS+t9p0fTLWYnQMsOUVM6TI3xQO3YqTHsyq4tPyrVXd1k1aJ
 ejYf0VZ1
 3MrH7MmdQ9LSx6vwjMRQMkYZH4e1FaWU2Uknzzgy7jJOxkJFJxcUJuitHSA8u34QqXlLACJ1xTNGqJokAtkTIwuSFFjzCIJ4btSXtBoHASr2qXNEAHateurRBprLHSBYlbNsATRXvStVJRcCcOW+8WErlIOwFGZgbN/AJiLkslaBSBceQ7LHSS/A476St0myzQFC+Pf3h/am7/puzoGQTDCBHlOwhjZBJDbIBUItKoOW5JfR7cz738/OnX/1iQRgd0YpCJA4hT7zcJqi9sq6BDNdB1/se7mUpQI3LSqc9A23byfbIKN58E1Nlya9iiM8X9BNV2UjYxXjP2LO2dUES3MBr6Ng0GAg2ozWCJxUWp+AXXbyyj60mb0ArCLOvqB9jhyJK1Y3w+TxOfZwB+ZbDhtuMAQkqd+3/ac68+ED6sGardCD1G2QGFkkoXx+QqQ9dFhy2No2PDzMamVHAIbCN/Gf0HJVZdrZBAkUKeg7LGnwSQUTl99TT9eXd1S2d1q5pZBZP/ARTuIrHD6KZKPpwUAnc1PxXSXHICQvtumcQplXonqsP2Ec2lbXawsh445ieiMMaxnFlyJPR7a4ZrXc8kla4kA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 31/07/2025 15:00, Lorenzo Stoakes wrote:
> On Thu, Jul 31, 2025 at 01:27:19PM +0100, Usama Arif wrote:
>> From: David Hildenbrand <david@redhat.com>
>>
>> Describing the context through a type is much clearer, and good enough
>> for our case.
> 
> This is pretty bare bones. What context, what type? Under what
> circumstances?
> 
> This also is missing detail on the key difference here - that actually it
> turns out we _don't_ need these to be flags, rather we can have _distinct_
> modes which are clearer.
> 
> I'd say something like:
> 
> 	when determining which THP orders are eligiible for a VMA mapping,
> 	we have previously specified tva_flags, however it turns out it is
> 	really not necessary to treat these as flags.
> 
> 	Rather, we distinguish between distinct modes.
> 
> 	The only case where we previously combined flags was with
> 	TVA_ENFORCE_SYSFS, but we can avoid this by observing that this is
> 	the default, except for MADV_COLLAPSE or an edge cases in
> 	collapse_pte_mapped_thp() and hugepage_vma_revalidate(), and adding
> 	a mode specifically for this case - TVA_FORCED_COLLAPSE.
> 
> 	... stuff about the different modes...
> 
>>
>> We have:
>> * smaps handling for showing "THPeligible"
>> * Pagefault handling
>> * khugepaged handling
>> * Forced collapse handling: primarily MADV_COLLAPSE, but one other odd case
> 
> Can we actually state what this case is? I mean I guess a handwave in the
> form of 'an edge case in collapse_pte_mapped_thp()' will do also.
> 
> Hmm actually we do weird stuff with this so maybe just handwave.
> 
> Like uprobes calls collapse_pte_mapped_thp()... :/ I'm not sure this 'If we
> are here, we've succeeded in replacing all the native pages in the page
> cache with a single hugepage.' comment is even correct.
> 
> Anyway yeah, hand wave I guess...
> 
>>
>> Really, we want to ignore sysfs only when we are forcing a collapse
>> through MADV_COLLAPSE, otherwise we want to enforce.
> 
> I'd say 'ignoring this edge case, ...'
> 
> I think the clearest thing might be to literally list the before/after
> like:
> 
> * TVA_SMAPS | TVA_ENFORCE_SYSFS -> TVA_SMAPS
> * TVA_IN_PF | TVA_ENFORCE_SYSFS -> TVA_PAGEFAULT
> * TVA_ENFORCE_SYSFS             -> TVA_KHUGEPAGED
> * 0                             -> TVA_FORCED_COLLAPSE
> 
>>
>> With this change, we immediately know if we are in the forced collapse
>> case, which will be valuable next.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> Acked-by: Usama Arif <usamaarif642@gmail.com>
>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> 
> Overall this is a great cleanup, some various nits however.
> 

Thanks for the feedback Lorenzo!

I have modified the commit message to be:

    mm/huge_memory: convert "tva_flags" to "enum tva_type"
    
    When determining which THP orders are eligible for a VMA mapping,
    we have previously specified tva_flags, however it turns out it is
    really not necessary to treat these as flags.
    
    Rather, we distinguish between distinct modes.
    
    The only case where we previously combined flags was with
    TVA_ENFORCE_SYSFS, but we can avoid this by observing that this
    is the default, except for MADV_COLLAPSE or an edge cases in
    collapse_pte_mapped_thp() and hugepage_vma_revalidate(), and
    adding a mode specifically for this case - TVA_FORCED_COLLAPSE.
    
    We have:
    * smaps handling for showing "THPeligible"
    * Pagefault handling
    * khugepaged handling
    * Forced collapse handling: primarily MADV_COLLAPSE, but also for
      an edge case in collapse_pte_mapped_thp()
    
    Ignoring the collapse_pte_mapped_thp edgecase, we only want to
    ignore sysfs only when we are forcing a collapse through
    MADV_COLLAPSE, otherwise we want to enforce it, hence this patch
    does the following flag to enum conversions:
    
    * TVA_SMAPS | TVA_ENFORCE_SYSFS -> TVA_SMAPS
    * TVA_IN_PF | TVA_ENFORCE_SYSFS -> TVA_PAGEFAULT
    * TVA_ENFORCE_SYSFS             -> TVA_KHUGEPAGED
    * 0                             -> TVA_FORCED_COLLAPSE
    
    With this change, we immediately know if we are in the forced collapse
    case, which will be valuable next.

>> ---
>>  fs/proc/task_mmu.c      |  4 ++--
>>  include/linux/huge_mm.h | 30 ++++++++++++++++++------------
>>  mm/huge_memory.c        |  8 ++++----
>>  mm/khugepaged.c         | 18 +++++++++---------
>>  mm/memory.c             | 14 ++++++--------
>>  5 files changed, 39 insertions(+), 35 deletions(-)
>>
>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>> index 3d6d8a9f13fc..d440df7b3d59 100644
>> --- a/fs/proc/task_mmu.c
>> +++ b/fs/proc/task_mmu.c
>> @@ -1293,8 +1293,8 @@ static int show_smap(struct seq_file *m, void *v)
>>  	__show_smap(m, &mss, false);
>>
>>  	seq_printf(m, "THPeligible:    %8u\n",
>> -		   !!thp_vma_allowable_orders(vma, vma->vm_flags,
>> -			   TVA_SMAPS | TVA_ENFORCE_SYSFS, THP_ORDERS_ALL));
>> +		   !!thp_vma_allowable_orders(vma, vma->vm_flags, TVA_SMAPS,
>> +					      THP_ORDERS_ALL));
> 
> This !! is so gross, wonder if we could have a bool wrapper. But not a big
> deal.
> 
> I also sort of _hate_ the smaps flag anyway, invoking this 'allowable
> orders' thing just for smaps reporting with maybe some minor delta is just
> odd.
> 
> Something like `bool vma_has_thp_allowed_orders(struct vm_area_struct
> *vma);` would be nicer.
> 
> Anyway thoughts for another time... :)
> 
>>
>>  	if (arch_pkeys_enabled())
>>  		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 71db243a002e..b0ff54eee81c 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -94,12 +94,15 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
>>  #define THP_ORDERS_ALL	\
>>  	(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL | THP_ORDERS_ALL_FILE_DEFAULT)
>>
>> -#define TVA_SMAPS		(1 << 0)	/* Will be used for procfs */
> 
> Dumb question, but what does 'TVA' stand for? :P
> 
>> -#define TVA_IN_PF		(1 << 1)	/* Page fault handler */
>> -#define TVA_ENFORCE_SYSFS	(1 << 2)	/* Obey sysfs configuration */
>> +enum tva_type {
>> +	TVA_SMAPS,		/* Exposing "THPeligible:" in smaps. */
> 
> How I hate this flag (just an observation...)
> 
>> +	TVA_PAGEFAULT,		/* Serving a page fault. */
>> +	TVA_KHUGEPAGED,		/* Khugepaged collapse. */
> 
> This is equivalent to the TVA_ENFORCE_SYSFS case before, sort of a default
> I guess, but actually quite nice to add the context that it's sourced from
> khugepaged - I assume this will always be the case when specified?
> 
>> +	TVA_FORCED_COLLAPSE,	/* Forced collapse (i.e., MADV_COLLAPSE). */
> 
> Would put 'e.g.' here, then that allows 'space' for the edge case...
> 
>> +};
>>
>> -#define thp_vma_allowable_order(vma, vm_flags, tva_flags, order) \
>> -	(!!thp_vma_allowable_orders(vma, vm_flags, tva_flags, BIT(order)))
>> +#define thp_vma_allowable_order(vma, vm_flags, type, order) \
>> +	(!!thp_vma_allowable_orders(vma, vm_flags, type, BIT(order)))
> 
> Nit, but maybe worth keeping tva_ prefix - tva_type - here just so it's
> clear what type it refers to.
> 
> But not end of the world.
> 
> Same comment goes for param names below etc.
> 
>>
>>  #define split_folio(f) split_folio_to_list(f, NULL)
>>
>> @@ -264,14 +267,14 @@ static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
>>
>>  unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>  					 vm_flags_t vm_flags,
>> -					 unsigned long tva_flags,
>> +					 enum tva_type type,
>>  					 unsigned long orders);
>>
>>  /**
>>   * thp_vma_allowable_orders - determine hugepage orders that are allowed for vma
>>   * @vma:  the vm area to check
>>   * @vm_flags: use these vm_flags instead of vma->vm_flags
>> - * @tva_flags: Which TVA flags to honour
>> + * @type: TVA type
>>   * @orders: bitfield of all orders to consider
>>   *
>>   * Calculates the intersection of the requested hugepage orders and the allowed
>> @@ -285,11 +288,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>  static inline
>>  unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
>>  				       vm_flags_t vm_flags,
>> -				       unsigned long tva_flags,
>> +				       enum tva_type type,
>>  				       unsigned long orders)
>>  {
>> -	/* Optimization to check if required orders are enabled early. */
>> -	if ((tva_flags & TVA_ENFORCE_SYSFS) && vma_is_anonymous(vma)) {
>> +	/*
>> +	 * Optimization to check if required orders are enabled early. Only
>> +	 * forced collapse ignores sysfs configs.
>> +	 */
>> +	if (type != TVA_FORCED_COLLAPSE && vma_is_anonymous(vma)) {
>>  		unsigned long mask = READ_ONCE(huge_anon_orders_always);
>>
>>  		if (vm_flags & VM_HUGEPAGE)
>> @@ -303,7 +309,7 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
>>  			return 0;
>>  	}
>>
>> -	return __thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
>> +	return __thp_vma_allowable_orders(vma, vm_flags, type, orders);
>>  }
>>
>>  struct thpsize {
>> @@ -536,7 +542,7 @@ static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
>>
>>  static inline unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
>>  					vm_flags_t vm_flags,
>> -					unsigned long tva_flags,
>> +					enum tva_type type,
>>  					unsigned long orders)
>>  {
>>  	return 0;
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 2b4ea5a2ce7d..85252b468f80 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -99,12 +99,12 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>>
>>  unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>  					 vm_flags_t vm_flags,
>> -					 unsigned long tva_flags,
>> +					 enum tva_type type,
>>  					 unsigned long orders)
>>  {
>> -	bool smaps = tva_flags & TVA_SMAPS;
>> -	bool in_pf = tva_flags & TVA_IN_PF;
>> -	bool enforce_sysfs = tva_flags & TVA_ENFORCE_SYSFS;
>> +	const bool smaps = type == TVA_SMAPS;
>> +	const bool in_pf = type == TVA_PAGEFAULT;
>> +	const bool enforce_sysfs = type != TVA_FORCED_COLLAPSE;
> 
> Some cheeky const-ifying, I like it :)
> 
>>  	unsigned long supported_orders;
>>
>>  	/* Check the intersection of requested and supported orders. */
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 2c9008246785..7a54b6f2a346 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -474,8 +474,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
>>  {
>>  	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
>>  	    hugepage_pmd_enabled()) {
>> -		if (thp_vma_allowable_order(vma, vm_flags, TVA_ENFORCE_SYSFS,
>> -					    PMD_ORDER))
>> +		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
>>  			__khugepaged_enter(vma->vm_mm);
>>  	}
>>  }
>> @@ -921,7 +920,8 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
>>  				   struct collapse_control *cc)
>>  {
>>  	struct vm_area_struct *vma;
>> -	unsigned long tva_flags = cc->is_khugepaged ? TVA_ENFORCE_SYSFS : 0;
>> +	enum tva_type tva_type = cc->is_khugepaged ? TVA_KHUGEPAGED :
>> +				 TVA_FORCED_COLLAPSE;
> 
> This is great, this is so much clearer.
> 
> A nit though, I mean I come back to my 'type' vs 'tva_type' nit above, this
> is inconsistent, so we should choose one approach and stick with it.
> 

I dont exactly like the name "tva" (It has nothing to do with the fact it took
me more time than I would like to figure out that it meant THP VMA allowable :)),
so what I will do is use "type" everywhere if that is ok?
But no strong opinion and can change the variable/macro args to tva_type if that
is preferred.

The diff over v2 after taking the review comments into account looks quite trivial:

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index b0ff54eee81c..bd4f9e6327e0 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -98,7 +98,7 @@ enum tva_type {
        TVA_SMAPS,              /* Exposing "THPeligible:" in smaps. */
        TVA_PAGEFAULT,          /* Serving a page fault. */
        TVA_KHUGEPAGED,         /* Khugepaged collapse. */
-       TVA_FORCED_COLLAPSE,    /* Forced collapse (i.e., MADV_COLLAPSE). */
+       TVA_FORCED_COLLAPSE,    /* Forced collapse (e.g. MADV_COLLAPSE). */
 };
 
 #define thp_vma_allowable_order(vma, vm_flags, type, order) \
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7a54b6f2a346..88cb6339e910 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -920,7 +920,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
                                   struct collapse_control *cc)
 {
        struct vm_area_struct *vma;
-       enum tva_type tva_type = cc->is_khugepaged ? TVA_KHUGEPAGED :
+       enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
                                 TVA_FORCED_COLLAPSE;
 
        if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
@@ -932,7 +932,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 
        if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
                return SCAN_ADDRESS_RANGE;
-       if (!thp_vma_allowable_order(vma, vma->vm_flags, tva_type, PMD_ORDER))
+       if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
                return SCAN_VMA_CHECK;
        /*
         * Anon VMA expected, the address may be unmapped then
@@ -1532,8 +1532,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
         * in the page cache with a single hugepage. If a mm were to fault-in
         * this memory (mapped by a suitably aligned VMA), we'd get the hugepage
         * and map it by a PMD, regardless of sysfs THP settings. As such, let's
-        * analogously elide sysfs THP settings here and pretend we are
-        * collapsing.
+        * analogously elide sysfs THP settings here and force collapse.
         */
        if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
                return SCAN_VMA_CHECK;

