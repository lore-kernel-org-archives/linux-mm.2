Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1757CD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 07:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26CD16B0302; Sat,  9 May 2026 03:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243E96B0303; Sat,  9 May 2026 03:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15A796B0304; Sat,  9 May 2026 03:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 014006B0302
	for <linux-mm@kvack.org>; Sat,  9 May 2026 03:54:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A7A31C0468
	for <linux-mm@kvack.org>; Sat,  9 May 2026 07:54:08 +0000 (UTC)
X-FDA: 84747118176.27.E8BB5CA
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com [209.85.215.195])
	by imf11.hostedemail.com (Postfix) with ESMTP id 942E240003
	for <linux-mm@kvack.org>; Sat,  9 May 2026 07:54:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WJOxiyPu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.215.195 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778313246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FI8KA4+9qmXkVJzkHEuRpOiJGy/NTHRYsaW2TKVpccs=;
	b=FVoY2oD4VaWPKj+7Y95twi9uFVCbvkdOphpmUp681n/yrKCGngtUlaSl1kSWT8RMi4cpcS
	pGmZrH9yWLkINYD/Mx8WeANXoGdRzdHoan656NF2fOLTNbizcNCCvUPhlf1IksWjOD2RUq
	/YNQgxtLttqxFT/qer1GvUZRg6db4TY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778313246; a=rsa-sha256;
	cv=none;
	b=xyqALQe/jAXNtIAhDckIcDtFXxQWK12bC/F7C/iMOOWR0GzqldQnn5+yflpnoznsYX4CHN
	h3P0d0/ZG0/4k07iAC4+ZLYtorOYUajytOHen3PL3uh0Htk/D5RKNYeqjUgz60aBn8JLth
	p61BfUlP1SMDIwl7cvMVt/x39ruFZzQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WJOxiyPu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.215.195 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pg1-f195.google.com with SMTP id 41be03b00d2f7-c70ea5e9e9dso1173224a12.1
        for <linux-mm@kvack.org>; Sat, 09 May 2026 00:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778313245; x=1778918045; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FI8KA4+9qmXkVJzkHEuRpOiJGy/NTHRYsaW2TKVpccs=;
        b=WJOxiyPuxXjr6zhncbAGu44fWYDfbOytvdPpjf9FpkIKb06hPl9YPnkMu7KjoaAQyB
         d/APL8g8hO/2/laa9wr9UKmQadnej6vrniJ6WwrjXFGWAYkrD7QCuFhP2B37EJYRmA7U
         U0VFQssbL5OVKgJpympJFhuiS3a7YuSLh4YDv9rs1Cgo3wYYcJCtMtgaBRBC3V3A9MdZ
         +zqvoBCTQPeVf4Ozimj5K6Y4/IpdKipD6qr6IWtyZ66//mYRnPkR1T7R3L1JfGCvWvb4
         c+mJigKAJrd6QWg+B1jS7lZCw5iZaOG6sw1SE9MilYkOAGpUNGbVfQ8R1cqtkAru0Uk5
         pXvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778313245; x=1778918045;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FI8KA4+9qmXkVJzkHEuRpOiJGy/NTHRYsaW2TKVpccs=;
        b=b0eGRSRzZAYE7CMeWDWz4Ewg3Alsv+4i0C4T1PI0GxoZa+HDoU+SufIii6FKpU3Wwk
         sdPik5AH73zrv0vJpVfC+9YZVGaDTj+YpRIvtTRud88hL5nyj2Boe7UpZQzcipoQMm9Y
         n6DENZWW3pQr9/1EQlfdPn0nkMeYPJAfy4swgY7G6WK4i9cE3sCmMK0ShUcsBk/VERz2
         Z73+CkwpdtnSFNWjoTw9xKGG8F7mh0PgJxZnzOGh6/hexN51n1Os8r+rtra1UyHWPa8j
         IYkxEai8CzKE4WMe/pb1X8+iS9IULeTcxVA73L1AkUNI7135N0ceUMehoUwlrZbCXjX/
         r/SQ==
X-Forwarded-Encrypted: i=1; AFNElJ+7kjfr773YBDHHjp7s/FIGofHTxbOLLve8ED2SDscNnCp4vMwagS209uh/6aFYjLyGE2LGUQ/tHA==@kvack.org
X-Gm-Message-State: AOJu0YwptPn3KDDwov6t7GeBOx0FeNWHl2tZyK6KT/UlFbmllXDzFiys
	2AfvNAx//VK7LdBXrfCgoQkPS5Spdef73BI1pjN+3U3I48csWn6CE1fl
X-Gm-Gg: Acq92OF/5Di5AT5XGKKm8E98ETfE5UtGB38oQql/jFQkKuNUFAYw6IncVuJGzOZh6Lc
	4azLR0n/Wxt4u6s6dM+pbBCwKvxqQRoSR1eLfvA4kRh2M3ZisDoVeZnzmYj5q3dbduZhrmNdhmZ
	zzYwsuF1TOfOd2QMkQyiwkbSRngKTS83uBZeDtyQaiGyOpTgmgAkefnm6gN00SiTCVxUuVUTmVP
	8L9nD4+OPiSKEQW/EEiZAeWwwQzuTYiQ91LtsdyXLrBKuD3+LYAspndczN+D87Shfih3qA++xDs
	WjWjN58bz4GEWNgNq0CdjGk75js52uyZ66gJK0gK1Xoutn7NnGhG4PqujjznczGXVaRcGA02GbB
	5T/YHT4VlHicfKvOOUmjN4fDrji0scsstaxhFxUWJxItnI0LdU6ZzgW1HFLmM9tdPUeKg0ThRIz
	7pKIxiu2wCK7+hiau1nQ4jmn1S89yXevk=
X-Received: by 2002:a05:6a20:a114:b0:398:71f2:59b7 with SMTP id adf61e73a8af0-3aa5aab2973mr17549441637.33.1778313245307;
        Sat, 09 May 2026 00:54:05 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d409eesm42643005ad.32.2026.05.09.00.54.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2026 00:54:04 -0700 (PDT)
Message-ID: <81cc8e5d-0351-48a9-9814-aeb6a8c2d32d@gmail.com>
Date: Sat, 9 May 2026 15:53:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/khugepaged: fix spurious -EINVAL from sub-PMD
 MADV_COLLAPSE range
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 shuah@kernel.org, zokeefe@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260507070558.3064142-1-chenwandun@lixiang.com>
 <20260507070558.3064142-2-chenwandun@lixiang.com>
 <9eea2afb-8c35-47eb-b1de-6a08503c9679@kernel.org> <af30otSSGbPxHbxM@lucifer>
 <af37aPMyMV8JSIPH@lucifer>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <af37aPMyMV8JSIPH@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 942E240003
X-Stat-Signature: 6uhhhgocgf3ncbcg8iygyq5yce6335zq
X-Rspam-User: 
X-HE-Tag: 1778313246-307783
X-HE-Meta: U2FsdGVkX1/RySowv2wHRLPRC1ar/a1llyR4vP/Nt8LFFQDQHnCShSI2k/r60YhRvwBDYBRni8I/XuID6Q3SAewumeDDO5N5IhRHF86SeUDIDp+RfumRGvowScEw5e1W8cdHfWYVuPR8qXDMRdgTZ121vb3cqw6p4/+vwVof2ltZynQsj4VJ8XpMYuYa/7E/Td9mEcMz/ri+Oq72LN98Ei2h95p0aTT9tZqwqZMPyTF0/wRamJeMMFJlaQPMcHgiw1n47uc262aZdzrb2lI4wiFkW7MbU2sHUDAsvTVTVtSBYtrbgawMuc31uMhlYx5i1CXLAQ0oB+wsBqlIMCZd3o0qk7CjuM6ZPi6DfRqc36ssSmtkyw6FPPLUTmB33f48azQdonT9KgD+UDmKglzqrbXh/dteLH/7rBHMpaMGirvP0jlPQjcXZGkrgoWd1jYRCV0ORyxozFua4ipLSu7tM7KFhJKxFs4iK4px8XuT/EOrbLFEDfdw+R3EvKWIzPxSuvxsU63R+awyH5+9394uk5a4FXHT/Vy1XEc7Vi6qxxlGOvKHm7dnzuimdrPHj1w9rVrP1Ry/a0MqkFT+pTIm0gCNH/A5PdgdfCAsSXRyBmqkMMyZabfHCbAlM2vIJy0avh3l5XsA3S3oF5VsmHFpNc6lTQK2ETGnM3TP+XP6LaW96OZyAdl+A6JtI2rrWWhA/gWzLw70kJe2SwvCp+7X7lE8by8gryE/CO24IqU9+V03lVSBuw5Vo/lLVEaZMFJVo+i5QzC9P2pLPRsFuKhJi+wgOGB8GNcIqEYMyQzsKAhZYAENAEF066MC5iYIdh1v8iug0TZ1q2wm77OJ4DSQ7Ke9dvsF/+ZgqncC4EyP4FvPWaKcIb9HpRIgqBCaoD5/qq1PdYcE82SPK/Kz8g3jgM382BPCuu5c15MNd8mkN4gyi82sxknzR+6qfOq05WV84BR/jip/0gPZ4NpVkqC
 2+vNiAXR
 NXBAgOme5DLY7bRZoEXvpQhgZWJFHiTpFxaOVuVPPbFfAUs7oY8IYrJjNWYcQzaClNwqJ6gVsLWIUsgk01ntXd7vF9UbX3RG0xSIkZ0NPoluTiB91Ha/QRHvgxpM2fSHmy+i65Rn9dbuX8Mhgvs2mY0JpkONjCTd8MHg9Jy27Go7/8YJ6Z44Tx9P/TbdXpxflB2K+tOusTWz1FjTPNhfJPZdPcClfDCAev8AX7Vv6AazDxW+RMVGD2dLl5AsQrxBP01vJvUGmhgtJBzL3R7yAS3SLSplGqpDLXTsRECZ3Tev7YQBVJoDj1gTo7oFMnqfamg1BAltpxgDe+I5AaQZyJMJPHoHNf6gSd9XZEktWTyxbDI6naZhTMN+yRz9UspjgyIPgbSn/PPBd258/QX0j9If4aD7cfaKua/qclnWYHLR0jZUSPEU4qJEwsXLW59Fb3YtuE1ebZLugJFMHz/cfkMBjKBipT7pumE56YygCkb9OVlwKduOPjLK8iFzGvscacJxhhVoqo9BKOpbTyD23BMeOzwVSmhUqwR5zy6L1l/JpANBopFpgY20QWGSEN5dc4OyVxgR33jY4Qxe9LQnxaQZPeRt0t5u/7NcImBTAPN16RMyPH7kBV4qHtsF9QZGpB6vLTOQB7XY+mpjawKc/oNclsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/8/26 23:04, Lorenzo Stoakes wrote:
> On Fri, May 08, 2026 at 04:02:37PM +0100, Lorenzo Stoakes wrote:
>> On Fri, May 08, 2026 at 02:27:37PM +0200, David Hildenbrand (Arm) wrote:
>>> On 5/7/26 09:05, Chen Wandun wrote:
>>>> madvise_collapse() computes the THP-aligned window:
>>>>
>>>>    hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK  /* round up  */
>>>>    hend   =  end   &  HPAGE_PMD_MASK                    /* round down */
>>>>
>>>> Previously this was done after kmalloc_obj(), so problem arose when
>>>> the range contained no complete PMD-aligned window (hstart >= hend).
>>>>
>>>> When hstart > hend, (hend - hstart) wraps unsigned to a huge value, the
>>>> final comparison fails and -EINVAL is returned instead of 0.  Consider
>> I think both should return -EINVAL.
> Correction: I changed my mind (see below), and think == should return 0 simply
> for compatibility reasons. Though honestly both really should have been -EINVAL
> from the start...
I also hesitated before return -EINVAL or 0, for the two cases mentioned 
above, it
didn't collapse into any THP, so I wanted to return -EINVAL.

Later, I saw the function comment for do_madvise and madvise manual, so 
I thought
the cases mentioned above didn't meet the conditions for returning 
-EINVAL, so
I followed madvise manual and do_madvise comment.

Best regards,
Wandun

>
>>>> two single-page calls on a 2 MiB-aligned address:
>>>>
>>>>      /* hstart == hend == aligned  ->  0 == 0  ->  returns 0 */
>>>>      madvise(aligned, PAGE_SIZE, MADV_COLLAPSE);
>> What's aligned? You're putting a random variable name in there? Presumably a PMD-aligned address?
>>
>>>>      /* hstart = aligned + 2MiB, hend = aligned
>>>>       * (hend - hstart) wraps unsigned  ->  returns -EINVAL */
>>>>      madvise(aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE);
>>>>
>>>> Both calls cover less than one THP and collapse nothing; both should
>>>> return 0.
>> Disagree.
>>
>>> Okay, so we talk about a "userspace is being stupid" scenario.
>> Yes!
>>
>> I feel that -EINVAL is correct for hend > hstart, and I think it might even be a
>> userland A[BP]I break to change it (maybe somebody, somewhere is being foolish
>> enough to use this to also validate input ranges).
>>
>> The weirdness is when hstart == hend being 0 but that's sort of established
>> behaviour I guess.
>>
>>>> In addition, kmalloc_obj(), mmgrab() and lru_add_drain_all() were all
>>>> called before discovering there was nothing to do, only for the code
>>>> to kfree() and return immediately after.
>>> Just a comment as you motivate here why this is suboptimal: we do not care about
>>> a "userspace is being stupid" scenario being fast.
>> Yes, in general - so what? The user is doing stupid things, so the user wins
>> stupid prizes?
>>
>>>> Fix both by computing hstart/hend after thp_vma_allowable_order() but
>>>> before kmalloc_obj(), and returning 0 early when hstart >= hend.
>>>>
>>>> Fixes: 7d8faaf15545 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
>>> Fixes: is likely ok, but I don't think we want to treat this as a hotfix or CC
>>> stable.
>> I'm not sure I want a fixes here, this isn't really fixing anything. This isn't
>> a bug afaik, it's just us not handling this brilliantly, but (possibly by
>> mistake) getting the right output.
>>
>>>> Signed-off-by: Chen Wandun <chenwandun@lixiang.com>
>> I put this patch through AI detection and it's telling me there's an 80% chance
>> this whole thing is LLM-generated, which is making me grumpy.
>>
>> Can you confirm that this is, in fact, your own work? Plagiarism is not a nice
>> thing to do, and THP doesn't need more traffic, we're overloaded as it is.
>>
>>>> ---
>>>>   mm/khugepaged.c | 9 ++++++---
>>>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index b8452dbdb043..92473d93e837 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -2836,6 +2836,12 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>>   	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
>>>>   		return -EINVAL;
>>>>
>>>> +	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
>>>> +	hend = end & HPAGE_PMD_MASK;
>> See below re: conflict.
>>
>>>> +
>>>> +	if (hstart >= hend)
>>>> +		return 0;
>> 	if (hstart > hend)
>> 		return -EINVAL;
>> 	/* For compatibility, users may rely on this. */
>> 	if (hstart == hend)
>> 		return 0;
>>
>> Is probably better.
>>
>> But I'm not sure what the point is if we're already doing this behaviour?
>>
>>>> +
>>>>   	cc = kmalloc_obj(*cc);
>>>>   	if (!cc)
>>>>   		return -ENOMEM;
>>>> @@ -2845,9 +2851,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>>   	mmgrab(mm);
>>>>   	lru_add_drain_all();
>>>>
>>>> -	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
>>>> -	hend = end & HPAGE_PMD_MASK;
>>>> -
>>>>   	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>>>>   		enum scan_result result = SCAN_FAIL;
>>>>
>>> In general, LGTM, but see for conflict:
>>> https://lore.kernel.org/all/20260409014323.2385982-1-ye.liu@linux.dev/
>> Please use mm-unstable as a basis for your mm work Chen, this is something you
>> need to fix, the patch above has been around for a while and is in
>> mm-unstable.
>>
>> You have patches in mm already so you should know better by now.
>>
>> But I'm really not sure I'm in favour of this anyway. I'll defer to David but
>> this feels useless to me.
>>
>>>
>>> --
>>> Cheers,
>>>
>>> David
>> Thanks, Lorenzo


