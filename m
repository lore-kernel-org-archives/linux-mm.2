Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0A09CD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 07:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDFBD6B02FA; Sat,  9 May 2026 03:04:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D918F6B02FB; Sat,  9 May 2026 03:04:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7FD56B02FC; Sat,  9 May 2026 03:04:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B716B6B02FA
	for <linux-mm@kvack.org>; Sat,  9 May 2026 03:04:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3057C40556
	for <linux-mm@kvack.org>; Sat,  9 May 2026 07:04:40 +0000 (UTC)
X-FDA: 84746993520.12.9419741
Received: from mail-pj1-f68.google.com (mail-pj1-f68.google.com [209.85.216.68])
	by imf06.hostedemail.com (Postfix) with ESMTP id 38A43180011
	for <linux-mm@kvack.org>; Sat,  9 May 2026 07:04:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MWQNSlbD;
	spf=pass (imf06.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.68 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778310278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QVO03yvgR7MFJkwnTb5HkHDLGj6R827bwPS9kDzxY8o=;
	b=nPSIFHnKIH6+jjpmsiUuLzfkA/kRdFR29WLlAmYSf2huChmUbrIFfgTgDVMYqMuo+BmwBk
	OXCkte5ZXjh+6xO02RenEnrmTWQqFAp3NkIJcbv4bm1xRWBSa3q+39K/mtLOeVjaJdo8o2
	5GNj8prR3Cuq11xvq1sKnzBccWgRB+E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778310278; a=rsa-sha256;
	cv=none;
	b=2p9AgAa+gvwmJ8CYbXn1ULIpF4d+6wDJhXgcqfSbEHbnl0fOCEXjZgSR5wUgbOwSPBlutH
	bE9IBDTywJZzpPDAZwPHDxr68DjhOQyoFehJPUIf2rsK+BicU5mWuqBtz11uTZy+81jkGw
	3Y6gpIwO9Fs6+KHuxjqEkoxL67JyXLQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MWQNSlbD;
	spf=pass (imf06.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.68 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f68.google.com with SMTP id 98e67ed59e1d1-36523acb0c1so1918637a91.0
        for <linux-mm@kvack.org>; Sat, 09 May 2026 00:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778310277; x=1778915077; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QVO03yvgR7MFJkwnTb5HkHDLGj6R827bwPS9kDzxY8o=;
        b=MWQNSlbDuCetTYUCXC/vt+EjWJ1V5p5iDszpqnc3dheWo0r9XbHNBIIwiqesj22Kgt
         R9n4dzVlMHR6VbVzuxOxXvXVPRO2IlExdJcC3c/lgOmicax/OoebCZJ/Yg9ImLcUw9nZ
         5dlsFTYdJ+VYMMazcHXwwI3cHLzXXE3F0Mo/qFAo6uFety3d6OiJMfM8X+wihWmQaHWC
         F3yJe73h0rHl8sbHlp62pOpNB1HJ9cAHabbMI0iesuyAQfGzk6E67NRvUhooo7uP6wcv
         Drq8WcaPq4oTxA/qsrjmnGUWXJe+Rze+b4wyJkp3MpgSf3QvdfUgXxlzhM/CYpUZgDZK
         uB1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778310277; x=1778915077;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QVO03yvgR7MFJkwnTb5HkHDLGj6R827bwPS9kDzxY8o=;
        b=J9YbDZQ76NQlTlnO06SWVaQN9i7McVUCArflumDuEah2ujv0JIODKkGo3MWYf5yuo6
         ws8uJ5rAzEPD3ti4pGFCdrhCXKWSCYexUYMpDawB02OvIccx1C0XJzA56JOgAIeDrip6
         5vfIMqbmoTy3Y+cGK3YRcTaidNijEncXo8wPlUOc+tszvEIXWwvN82RX8lPSth+hhOJi
         teP/KuOr6FGeVgWw1O/ZY8OBmmQg1Tsm2F1IqztbfPIAShbSL/eXYGco4yZpN05I3phl
         LLKu/24ELXep4SH8w8stZO69HmvbBrPQLZ1HAiDsvOstLEUvSwwDE2DfErIYeZO/VHc5
         8loQ==
X-Forwarded-Encrypted: i=1; AFNElJ8p8s+rBu5FDuoXjM7FtBLI1cidHrO0fngk8iEzMNLDcJA/zLorqz+BPYpB+Us8g5QmKLDN0//zcw==@kvack.org
X-Gm-Message-State: AOJu0YykwMmVG480M+x/fsGJMfUJlrb5xyZLECA0IeueZJevSCekxqP3
	y6jXRKebxZbKRf+QU06jYpRv5YLgrEoENXCKVKYKzlHvJall2UAwjWKL
X-Gm-Gg: Acq92OHZdznxwIwf6Om67YRwx4VK76mTNpVl1X92Ik/qiy5QN+Y6IDZmT55FUuFgoYH
	C1h1X9bm7nz1VzSONf2MwFBpT8cHKV5S+52ZcbJxUvFGJKdTCnEAhVB3eiY2gHg47xie8cbitNO
	1QIQb7pO1loTDNecmxwvl7/TEbP7l+wk845Zo46BPhHs5Swz3bxiLMt5ZevhIpnITPYgiSAb2DB
	0fKBAiUC5unZot9ErHaOFboVc/96XhlI1HiyYRgaR4bOhX+Hq6cr12lza3xKugHA+pNkzNAfuam
	pt4NsNE/tZnBcnTOtGm42ATfcg8I6jVCM6JIzNIOnnz4h9dE4crmVMfvDdeUwWtXee58DkLFb0D
	VBjr7UDuaV4iyX6xWNdAYVtVc93JMHwd99XPKKAp7SYOU/mMI2Fof5WMy6l1+BeQ5zvwcfG/JLk
	HkccbtDCwZ1ss/8WhD7z+ivtTiz4ANozi2bQ5HRUhQNg==
X-Received: by 2002:a17:90b:2882:b0:364:a497:dc45 with SMTP id 98e67ed59e1d1-365aa83f807mr17884589a91.0.1778310276863;
        Sat, 09 May 2026 00:04:36 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367d628474dsm1156505a91.8.2026.05.09.00.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2026 00:04:36 -0700 (PDT)
Message-ID: <42f6064b-ea32-4b9c-b6b5-f1dd47a89ac3@gmail.com>
Date: Sat, 9 May 2026 15:04:29 +0800
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
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <af30otSSGbPxHbxM@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 38A43180011
X-Rspam-User: 
X-Stat-Signature: s1xy5n6sgn87j4urg5he9c8fjz3k5phi
X-HE-Tag: 1778310278-118530
X-HE-Meta: U2FsdGVkX18Ew8ZHmM3Eqt4jC5u/1ooNQBbpsXQjB8WvioTYtHMhbP6bN1eqZd/Zgn/s/zbrXbvCv2mBPfeNwMCF4ZWjUHKYIoiHzl7TKOLNh+/WCLR48j46x1y2DWlbVcdfvYu7/VvkeXVvSXK+uUnRclYqHHckqLzGuA/jMiOY/bBOBkgUwdb8vHGlRF+8oR3W0QxrN3kKqTnA0sTq1cxuh0thQOZJnuMqwhM4yLv3mz/+symI01GSxTwh7ghOWM5NWUpXtqbz2g3Q5j+0n5vho9kzm0pZUlEU0+3kBe79SnuaKJKd8wqjCi+7otdNI69tk3edR/zItO3Cz8W7574rQe2kxJ3rGz7KB3mbxtYG8u9kWMjcCQkow6kukceDtgHM8eQXWa6MFNu7QZymgO4VT3m9wWsh0Ie69UwVcE3s+agt5+Yq2bTQaIdNQn/blVTGdoLi2gfxYELNdx4pQbIw2211xItNcpEI9+3DXXLa3ulmUbBvNdcTiCiTKUE430dcSc3GhPjtoeCAvvCCJlbhO5kVEDFigFmuR5p2YydNoLTbOLGBBKDF4VEtT7bv/rIILm5eG7QWvCdDH31ADiQrbNyD3kyU465q/uZW3llI1wqjis1D0/RVvTXkn2YbZTp0hl/u8fDPgxNDgESjYzziqm6Wj/ekI9r/xBgo3XpSRjTysauVtE5YAS90CpkNJzCDuX2PSJFdSo8uQdfYMzXZRhnam6wOQ9ad3I1zO+2T6iv4tWRU802GvfNmAUe3SqS9QAoYDdaSYPHQMpWHpS+yKdSRnDuw1m43sGQ2Drkb83KDUOosG6VGKR7HPFn6RS4D2OAaoy7J0AaSv7bZBob4zz+wit4ZbU6hZ04lx8YAf/wN7RtML5MHaZfe8WKMyONfz03GPDpENwmqCsPdTOl1iWctVjjwt/b6BlI/ZNoTxni+i2B5kcJswZ0k3Ox9aUAsl9qABTLMDAUAcB1
 uLRp4Xhu
 MecdeNjJXB23XgFAe7Pcl4bSSL71gB1qV1ZTvm6kUd/N/Hn5/+PnmgSsqGIyf0eb/BZSkEq+J32tKMxOZeAAn2LRuanvgfLP14r9fMrm4SFanwNBHp/WdKh746nJRMpDNt1xMTgzkbXX8yeLDTKKdUCYv9RG7jYaB/pjG6KLcQJ/UlEJHl2kN8NlWbg8KChb8X106PG5qLW7ujSvUdi3IjNxasV7JK94gzoTcDKLUNjQzM5IoM0xx9/KIRUApdYRd7rhlrRcLjXdtX/LdDhW9guxFY3kdbHb8pVzJUwScd/VwafR7++Q32etKK1tACg0tNNuy3pfIyB2omFLu2NGGzzMpLD/06fRoGvp0RqjJ2PcP4nUekYCkQIDpIo0QUskkh1Tv+TNkuz9b5U6EX1r8MdXoILTIj6RfLDHIXbj/Mze6Iyfy+wvS/dQiPBbuo8VkurQSYheyYT0UdKgsLZwEoB5aCEZj4tpAHjGUuQXmmnKXIH3n3JQiFaXza6NQGGwPmvRR3J0nhG1wahZnAibCkCqkQWY6ORZFbEMoU9E9ieev+XGyC0CH5fRE/CYlHAmNmROqQlXYwzYx3HEKTFOFYa/dC07oPMcKwMVKCW6qwAxCHFW5xgdDVg4Fl6b+WN3vVZl8/6Y4AyMBLY2CKmUUxHUNiVYIBH4/9t44VtCqces9Zuk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/8/26 23:02, Lorenzo Stoakes wrote:
> On Fri, May 08, 2026 at 02:27:37PM +0200, David Hildenbrand (Arm) wrote:
>> On 5/7/26 09:05, Chen Wandun wrote:
>>> madvise_collapse() computes the THP-aligned window:
>>>
>>>    hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK  /* round up  */
>>>    hend   =  end   &  HPAGE_PMD_MASK                    /* round down */
>>>
>>> Previously this was done after kmalloc_obj(), so problem arose when
>>> the range contained no complete PMD-aligned window (hstart >= hend).
>>>
>>> When hstart > hend, (hend - hstart) wraps unsigned to a huge value, the
>>> final comparison fails and -EINVAL is returned instead of 0.  Consider
> I think both should return -EINVAL.
>
>>> two single-page calls on a 2 MiB-aligned address:
>>>
>>>      /* hstart == hend == aligned  ->  0 == 0  ->  returns 0 */
>>>      madvise(aligned, PAGE_SIZE, MADV_COLLAPSE);
> What's aligned? You're putting a random variable name in there? Presumably a PMD-aligned address?
Yes, PMD-aligned address.
>
>>>      /* hstart = aligned + 2MiB, hend = aligned
>>>       * (hend - hstart) wraps unsigned  ->  returns -EINVAL */
>>>      madvise(aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE);
>>>
>>> Both calls cover less than one THP and collapse nothing; both should
>>> return 0.
> Disagree.
>
>> Okay, so we talk about a "userspace is being stupid" scenario.
> Yes!
>
> I feel that -EINVAL is correct for hend > hstart, and I think it might even be a
> userland A[BP]I break to change it (maybe somebody, somewhere is being foolish
> enough to use this to also validate input ranges).
>
> The weirdness is when hstart == hend being 0 but that's sort of established
> behaviour I guess.
>
>>> In addition, kmalloc_obj(), mmgrab() and lru_add_drain_all() were all
>>> called before discovering there was nothing to do, only for the code
>>> to kfree() and return immediately after.
>> Just a comment as you motivate here why this is suboptimal: we do not care about
>> a "userspace is being stupid" scenario being fast.
> Yes, in general - so what? The user is doing stupid things, so the user wins
> stupid prizes?
>
>>> Fix both by computing hstart/hend after thp_vma_allowable_order() but
>>> before kmalloc_obj(), and returning 0 early when hstart >= hend.
>>>
>>> Fixes: 7d8faaf15545 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
>> Fixes: is likely ok, but I don't think we want to treat this as a hotfix or CC
>> stable.
> I'm not sure I want a fixes here, this isn't really fixing anything. This isn't
> a bug afaik, it's just us not handling this brilliantly, but (possibly by
> mistake) getting the right output.
Yes, I also thinks this patch only fixes minor issue or cosidered a 
clean-up.
I would drop this Fixes tag in v2 to avoid any confusion.
>
>>> Signed-off-by: Chen Wandun <chenwandun@lixiang.com>
> I put this patch through AI detection and it's telling me there's an 80% chance
> this whole thing is LLM-generated, which is making me grumpy.
>
> Can you confirm that this is, in fact, your own work? Plagiarism is not a nice
> thing to do, and THP doesn't need more traffic, we're overloaded as it is.
I can confirm this patch is my own work，I found the issue and wrote this 
patch myself.

The issue was found when I noticed THP pages were still being generated 
even after
adding "transparent_hugepage=never" to the cmdline, after debugging, and 
finally found
this was due to madvise + collapse path, while reviewing code I found 
this minor
issue and wrote this patch.

I did use an LLM, but only to check the commit message to find 
spelling/grammar
errors and improve readability.

I fully understand your concern about the traffic, I will be more 
careful about
what I send to the list.
>
>>> ---
>>>   mm/khugepaged.c | 9 ++++++---
>>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index b8452dbdb043..92473d93e837 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -2836,6 +2836,12 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>   	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
>>>   		return -EINVAL;
>>>
>>> +	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
>>> +	hend = end & HPAGE_PMD_MASK;
> See below re: conflict.
>
>>> +
>>> +	if (hstart >= hend)
>>> +		return 0;
> 	if (hstart > hend)
> 		return -EINVAL;
> 	/* For compatibility, users may rely on this. */
> 	if (hstart == hend)
> 		return 0;
>
> Is probably better.
>
> But I'm not sure what the point is if we're already doing this behaviour?
>
>>> +
>>>   	cc = kmalloc_obj(*cc);
>>>   	if (!cc)
>>>   		return -ENOMEM;
>>> @@ -2845,9 +2851,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>   	mmgrab(mm);
>>>   	lru_add_drain_all();
>>>
>>> -	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
>>> -	hend = end & HPAGE_PMD_MASK;
>>> -
>>>   	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>>>   		enum scan_result result = SCAN_FAIL;
>>>
>> In general, LGTM, but see for conflict:
>> https://lore.kernel.org/all/20260409014323.2385982-1-ye.liu@linux.dev/
> Please use mm-unstable as a basis for your mm work Chen, this is something you
> need to fix, the patch above has been around for a while and is in
> mm-unstable.
>
> You have patches in mm already so you should know better by now.
Apologies for not basing this on mm-unstable, I'll fix in v2.

Thanks for your review.

Best regards,
Wandun
>
> But I'm really not sure I'm in favour of this anyway. I'll defer to David but
> this feels useless to me.
>
>>
>> --
>> Cheers,
>>
>> David
> Thanks, Lorenzo


