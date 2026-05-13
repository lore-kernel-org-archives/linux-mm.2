Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47250CD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 03:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 853A76B008A; Tue, 12 May 2026 23:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 804696B008C; Tue, 12 May 2026 23:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F3C76B0092; Tue, 12 May 2026 23:24:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BA086B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:24:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E46E68DEA3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:24:26 +0000 (UTC)
X-FDA: 84760953732.23.E21EED3
Received: from mail-pj1-f68.google.com (mail-pj1-f68.google.com [209.85.216.68])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0045EC0002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:24:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eB8MqKMG;
	spf=pass (imf10.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.68 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778642665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=shxQwZMWxb7nA4OQov3Bopteic25gB7G6Th6kE4YmRc=;
	b=4Df7gHIsjjcnrMgZxilc1nNNLcuULrSEstL8zTSBSq9MD261KwyWXNijH+11vtwr46kDFv
	LA0KFpT9lTYZJK8gV0IyrQRpNK2tnIdcOVEyzT4oKBy5DLTfNXGVc6efI+kAHnm7j8hjM2
	v8jwIgwavi3qbh4ziJR3rb4QFSZWwws=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778642665; a=rsa-sha256;
	cv=none;
	b=Ykv3bxKaKZCm32J80ENSTKKusztv/TD/urIBr5q5xyn+SZcuRcwAUeoQkjpH8iJxwtZY3B
	LVM7JwtYdsacWCwU4WpWmG950L4FP0lEJXa9qWowV+fjdF/mdzxdx2zRZOudEJNWILFRRh
	OoLKQMG1iKjMc3bWN+aMeck0/WLgNQI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eB8MqKMG;
	spf=pass (imf10.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.68 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f68.google.com with SMTP id 98e67ed59e1d1-366070f71adso5626915a91.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 20:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778642664; x=1779247464; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=shxQwZMWxb7nA4OQov3Bopteic25gB7G6Th6kE4YmRc=;
        b=eB8MqKMGc7em12pq76HS2QkiTHB37ut1UfydmDSnhIL9l+VEGc/Xu8Z6K9l/yYwZIG
         38cixlOWbn4cp+AGu1eqUK7ZzxPFztKIxkiQAVwtN7U7Yps+8CGcXfMkqhbq95T71SI0
         VULmpO3u0EJ/gPdNnXeH5Dpr6Y7h2JGQbvQt2evS6RrbGEdhOXDn1RA9GZ7RXIJ02kBR
         ENck1yQ9QYGNp9ULxpc89qtCvCyJVkn6Gq1eDZbwyNyHn6oGQ4LFHruZza2CJdEndydf
         5NlLhZvQ5b2F70Xet9Z24q93oQeaacISpDonW2Hyl2jYA9DtZeEUSscA9TbmR5Bpy4FE
         kupw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778642664; x=1779247464;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=shxQwZMWxb7nA4OQov3Bopteic25gB7G6Th6kE4YmRc=;
        b=rSug6e9bBBp+GY7bKO5jRmFHxvOrCKPvCUFRyNsgkQVHNXvU0qVM+ulOAolrnFwuqm
         Nlpu6q26RqbPkTpz+Vxg65zpDJ3sg+KoKgoSr8rSLT7aCdhKDJNjyRAv52zGWAGMHbGK
         hkLV7/ogNz6ANk8VoGkPIjKkzP1sQCsk4N0ozz1OqAwRd31+SCJsKflmRmJerHJ9waMi
         mCzuEpekh778OyrRntF0q5XO1NXqCqn4Fnae5+0wBVDQNAHjJl2NxFdXLE8SZBupm5oT
         ONeAo3NUZrEAVCd870zXTKHtECEKEuTCrkb2zeSQ/7jPUiH8tEOqxxU/4qBJn5brU+3v
         XBdw==
X-Gm-Message-State: AOJu0YwiQOgG02dxZyUQVlfKS8jYbbmr7KIhidpZSYDvZX0hEJWoITNd
	eLBTu74hHWWZB5lE6FfNaWrOWiAF79yGE2FMELoWLpDDpLn35KgiS6Pg
X-Gm-Gg: Acq92OG44RMCk6g+PIW3EKQ8YwLSUGIuYQUVNXxFDz47iJbMFrHQMdkVsGLV4qQwAuf
	YoUsyb74DofvGDrVh9j3Fc87VS7FKrTaQblXluOY+iCNRC6pypxcUetHJD1EJCLugo3XOk18qDc
	Vg//hbZC3HoOzBQBG+bT0wLvXgZd0kdqC46GrXKpjG1PsFN0LjhUZFLhIH+4XmVySwIX918/i7U
	Mk2QJn58TFTNSw91iKR1WFMGkMorYF69nJ4mmql4hU3XeOREhCZflEWywVEB0+NEBlFHvtFG4cT
	0Goz8eCsW348ZFRZpIopVzz7sb04WHNrlYws/nCtk34HW32Wd/HrmmSzQDUoQ3jzKICjEGIBZgt
	MDRObN+c4Idx8n7k8FVq9ON9EpWFYIEIN5JP2Vqb3x0oyydeOJC96U8vKUTTP3WyXcL3mg1f2pW
	EMfA7PNbo8f2uHhn3gkoVzGvkuwgmPO62nA8pESHm0Uw==
X-Received: by 2002:a17:90b:3907:b0:368:1088:bb1d with SMTP id 98e67ed59e1d1-368f79946bemr1059205a91.15.1778642663670;
        Tue, 12 May 2026 20:24:23 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8267735eccsm13751689a12.32.2026.05.12.20.24.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 20:24:23 -0700 (PDT)
Message-ID: <93275e30-ef8b-4ca0-9854-206b4232d90c@gmail.com>
Date: Wed, 13 May 2026 11:24:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/khugepaged: avoid underflow in madvise_collapse for
 sub-PMD MADV_COLLAPSE
To: Lorenzo Stoakes <ljs@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
References: <20260511065701.799006-1-chenwandun@lixiang.com>
 <cff99673-ba36-41d0-add1-e2738f95bc4a@kernel.org>
 <4e3d0c1b-af33-470d-acb0-1e6540ba312a@gmail.com>
 <0a860f74-b2fc-4ea7-9f13-1879c2c8c168@kernel.org> <agHxP3iZd8RdHqSw@lucifer>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <agHxP3iZd8RdHqSw@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0045EC0002
X-Stat-Signature: wsgtyask7xb5robypq8thkwf3qj18z5z
X-Rspam-User: 
X-HE-Tag: 1778642664-427633
X-HE-Meta: U2FsdGVkX18cJx1RsgJ3T5aHQNKTeYdedJ6ZQlftyn4hZg1Pp0M7+UXOXZ3MccOtsFS8G/r2ZLIDjL/hsMleg4Tl+8ch+ntuJUlMHfEn11g+E9Kg7GFdnF4uplcoTm1YwFiP+1b/tpF4Yq27VTtlPwNj65rZJ24sm+6U6lj3mcI0RHqVz5vEaP1946RWPDilMOxH/rGtaH82YgqM+yZvMIGfRMmOFTL6jOtIZJV9zrNc0wJQMFlRWbTwgzPqLt5jXOUhrHI4yuhNKiweCipOD1i6KQQk247hdBuQzcY5hXb9Dh2wymRrqmp10u7PotYlbN+dAUgPt1qoIxEHf42bedhNgCCddXbtWd93roST2SgZoH+DTYLLiB8ukQGqYVPcqejOlpFj+BZzK3THc0CIZrD5vaPR46TIMgWMyoBNdwfc+uZpOgPGdHoOYXNoSul5I8yNHujZ3pF6ygOonX6pIOw1oDTpl/d+UIZng4QIJB8KQTNVkxCyQJbei1cq9ZPQmOzqzbCOxHtGGdGUf8y0r1gDIB+JyBC4Nq1yzxb+lT53S8sWsWh6OnpJnbcDDt5wJ8amkmge3YGiljkFrSRCKw0Whzj87qyxP1KsLiczrghTvewn94OaCCer7rHW1PIFIftje3GAprBaz+yqhszBXls6GsWyaKmewt8izfNpm44RWRhGMQF5/295SDTCQ3SsnQgvCYXb2Ve6c0oy9PR4rx0J74Puaaw+x3PW7f2sFGX6fSa275jLjpO7hSf/Ub1NaRIjxnn2BpPgLzp38jiS/A6/pUSa0QdIZnpGW/x6c5K5uFSn49V/elVucXODr6XrBhlnHau5SIRyL/Wp8RgGPRW7o/+eUKwwfxWeQmXkQbZfvkNAEGK+p+ISPZ7gPXfgdpMEB0wazjWOIYEC/pplwKjmz5IUfRNb5NcqJ0HmO78kIyRufxwAJ2m4cbts7w6k0LJ/Bok8lTdIGWehxZx
 j3Qcm8Bg
 8WznMYJWe8g+CIXLg7HacWxWU0ZF8xBbXf4tEAMM6AFVMuTH3GWGFnaM9ujJUjgru0K+SiRNFGhg77yU8duJcxxsbzbl56RP+G61rLScmnQ1M93DKM/WHVd5+P1Qd4h7sxMwWrJ0FEiFGODLefKpvcfzgwF7HPrrIKopPf1hEgrK30mJGS/xwon4/AS5DpVBpRMmsIqm7aQ1OwlmOvGTxbnBGzgwVm+yJGi+jaqoyEJXG8kbDfFz+Zj15PbE8q40mzQrpsQ1wKhamnEdjMyf4dkYQeEBfH8Oiw+TfyNYAhHCNTLuBtPYWX9g8oxpOX2B+SPA2wHEyuzSA00yeN08nY2Ud/DQzHlJjtATjMeB0y8jLFzfHXcWostFW7Z4dz9xwM4PTFtbkAD/E/rk46UyTI6rOjJ82EZ3qYVu4eNIjvQb0b0qYUr0aH42Jlcqktfr/iumiwIPAYnMJ5LhEy28cXQ6y2NxAUkpOua5oWTFAnxU2k03CcOIFRnm4CYm9Clt/4Xfd1sMoMDyMdeSlq8DDLgfQWQhJPp+U6q4MH2AbDHtmp5eYgCVdFEHdFw6zJVeZNRbsbkIT8/5DRQlcIady9rOnNoaufK/Sk60drz0n6cLSETsFTN/ROazQVlkwDTkFwatWOGBpVF6BVW2Gyr5FK1t83w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/12/26 00:21, Lorenzo Stoakes wrote:
> On Mon, May 11, 2026 at 10:01:39AM +0200, David Hildenbrand (Arm) wrote:
>> On 5/11/26 09:35, Wandun wrote:
>>>
>>> On 5/11/26 15:17, David Hildenbrand (Arm) wrote:
>>>> On 5/11/26 08:57, Wandun Chen wrote:
>>>>> From: Chen Wandun <chenwandun@lixiang.com>
>>>>>
>>>>> madvise_collapse() computes the THP-aligned window:
>>>>>
>>>>>       hstart = ALIGN(start, HPAGE_PMD_SIZE);     /* round up */
>>>>>       hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);    /* round down */
>>>>>
>>>>> The following case will cause hstart > hend, and result in underflow
>>>>> in the return statement, avoid it by returning -EINVAL early when
>>>>> hstart > hend.
>>>>>
>>>>>       madvise(PMD-aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE);
>>>> Ok, so providing a PMD-aligned address as start will result in 0 and a
>>>> non-aligned address will result in -EINVAL.
>>>>
>>>> Didn't Lorenzo agree that just returning 0 in both cases would be clearer? But I
>>>> might have misunderstood it.
>>> Lorenzo suggested retuern -EINVAL for both case at the beginning,
>>> Later, Lorenzo add an correction, suggested should return 0 for
>>> compatibilty reasons for hstart == hend case.
>>> (If I haven't missed any information)
>> Let's wait for Lorenzo's confirmation.
> :) thanks.
>
> See below but TL;DR I convinced myself that actually, I agree with David...
>
> I hadn't really examined the madvise() <-> madvise_collapse() logic closely
> enough but yeah. Return 0 for both cases.
>
>> I think the important part is that we cannot have a situation where start < end
>> (given that madvise() consumes a length). Because, there we really should have
>> returned -EINVAL.
>>
>> For start <= end, if there is nothing suitable to collapse, I'd say we'd just
>> consistently return 0.
> Right so madvise_vma_behavior() should be called with range->[start, end] tied
> to the VMA (under VMA lock we assert this also).
>
> So what we're really talking about is hstart, hend.
>
> Really we should NEVER have aligned the addresses for the user, that was the
> real mistake here. But that ship has sailed...
>
> Since we do:
>
> hstart = ALIGN(start, HPAGE_PMD_SIZE);
> hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
>
> That means e.g.
>
> start = <some PMD aligned addr> + 1
> end = start + <not enough to get it to the next hpage>
>
> Results in hstart > hend, so the user must have given incorrect input.
>
> hstart == hend would be e.g.:
>
> start = <some PMD aligned addr> + 1
> end = start + HPAGE_PMD_SIZE
>
> Which is still an invalid input. I honestly wish we just required that the user
> provided PMD aligned ranges and we didn't align for them, it's stupid that we
> do.
>
> So the real question is, what constitutes an actual invalid input here? We've
> made a mess and now we have to decide how we interpret it... :)
>
> I still feel that hstart > hend is an error. Since we are aligning things the
> stupid way we do, we are treating start, end as _bounds_. So we are saying 'turn
> everything in the bounded range [start, end) into huge pages'.
>
> So we use ALIGN() on start so nothing BEFORE start gets converted. And we use
> ALIGN_DOWN() on end so nothing AFTER end gets converted.
>
> But if you do:
>
> (first case above)
>
> PMD aligned                  PMD aligned
>      |  <----------------->      |
>
> You're kinda doing something stupid obviously, because that range cannot span
> any huge pages, you don't even cross a boundary, and importantly - your range
> _isn't even large enough to include a single page_.
>
> With:
>
> PMD aligned                  PMD aligned
>      |  <------------------------|->
>
> You are crossing a boundary but not enough to get a page. But you might well
> have a large enough range to span a single page...
>
> But OTOH...
>
> PMD aligned                  PMD aligned
>      |                       <---|->
>
> Would get you the same as is equally silly.
>
> Yeah ok this is a long way round of coming to the same conclusion as David,
> godamnit, and I so wanted to disagree here :P
>
> Since both get you nothing, and the input was valid _to madvise()_ let's just
> return 0 for both cases.
Thanks for taking the time to walk through this, Lorenzo and David.

Now we've agreed both cases should consistently return 0, I'll send
a v3 that simply bails out with 0 when hstart >= hend.

Best regards,
Wandun
>
>> --
>> Cheers,
>>
>> David
> Cheers, Lorenzo


