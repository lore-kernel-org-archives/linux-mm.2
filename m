Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 749DAE91264
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 06:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4C396B0005; Thu,  5 Feb 2026 01:08:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F92F6B0089; Thu,  5 Feb 2026 01:08:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F79E6B009B; Thu,  5 Feb 2026 01:08:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 782056B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:08:15 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EC60B160419
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:08:14 +0000 (UTC)
X-FDA: 84409372908.13.CD92694
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 042E2100017
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:08:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RoZb9W1X;
	spf=pass (imf14.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770271693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4+SrgGx3YMSZaBmeav9ddo0K7dZ8z9qSkCK8ecextI=;
	b=1S0U66GH4zBly5JPWbNztjnTv0oCfsTFszNqe2A5g2U6GJ2tvlg85nfgkHAYdb+6dWxkV5
	+tbLbw4j0ge4GmtI/w/1F/ptC93cWmeF/gxJGiw3OBQIHMFZq2StDOT9eBrl3V8NdJAFWl
	/s5G2vTaCAle+iGF3EwRiNHhErEOU7s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RoZb9W1X;
	spf=pass (imf14.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770271693; a=rsa-sha256;
	cv=none;
	b=2vKIITSVkOCFiHDpnAi6VGJSixAmHjOwFBe7eCcwlM8hvP32HRgJvgToJWCExSCmebddbj
	l6KsSF4oQgG4swBeCgLWEffDaQlXlHk9OhX6OAWnPGXYPwxH7yAyRkXQ35oC0FGwJJxU4u
	KGxaP0z3rLYS0xdreC4Sm2QnC1lI4ug=
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2b785801c93so1410765eec.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 22:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770271692; x=1770876492; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z4+SrgGx3YMSZaBmeav9ddo0K7dZ8z9qSkCK8ecextI=;
        b=RoZb9W1Xu6BvgVXTycqmUbaWk8YsbiY55scsmPFuQAsOErAGpX8KaacNxuCsl8lQoO
         ktmSpFH4hWW6+dO10PAt32BAKBaqPPtolUTgn3Lt7Dhin/ixJaQ+2H5f1IitmmOpEayz
         rziVB30ANBPaw6Y9GII6Uk8r0perjfW3SBwCzdcIDIL0TZVy6+6LXD1YcCuyQtVU1YRE
         +M7XRr0A0g5q/oRSMZrL3uS266cA8LQQAqPZncdkCf9rCuQZ9ezM/Kb6UV/K2lRG/Vn0
         5LaYPEUkSCSdf9+k5A3w0jfU3yU2504M7sWzEjvQfcnvDrMS4w3NqosA6OmlEdQc82Y1
         spMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770271692; x=1770876492;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z4+SrgGx3YMSZaBmeav9ddo0K7dZ8z9qSkCK8ecextI=;
        b=mLZL6BFPvd60NOWxFyN0VtSBfTOZiNvBkzYe+HTPRLZh6ZfxZo+aRB2dOPM3+fUOXD
         t00B5SV8PmefwH1dPmJ7w2pTardP39hJdakmYY1qAGgogOrhr7kyDCzODO5sQa2iybym
         oA03TsE18Mk5CLEfmAHazaTWhj0xBc/mrbExjMg0ldPd4mPsDfjPg4QMuo45hRH4Xf5f
         LWhDhGKxCNDwM2c6fDECiGaClLYlLjhpV4DMavOPjuvSkfVJm+Ln26o1bEW2m09TKw8E
         tUh3tQyMQaEXoXTsqCte0YmlC5xApuCNC4Rq2GhMzLXsZ+cpPVWW7C9ZuHDuUnpxpr3G
         a4Uw==
X-Forwarded-Encrypted: i=1; AJvYcCUUg6eb9UTJdMmmpd8L7OzFmrHlJ8sNyaFjKeK/1zklVeYqAO8Wk6gRqyN8WYcOj0F/REAQqMMWEA==@kvack.org
X-Gm-Message-State: AOJu0YxaXrs8+S3W+a6KGik8RHShEgbu6aGYJvypHt8Z7Dg/Le3s3np7
	AoH2UDxXvTAKDQBJU5PHwphKWfmUEJmtAnfdqgkDyy9gO3MMzRklpTAk
X-Gm-Gg: AZuq6aLnJTDJWjPoKfMZCAtbxIA6POgo3U7F9i3ugMWzGJh9V3rXHms7EG2uinfWr3k
	vgA+laCkAtIpv9dhQaswuqryGyUt/Li1qPef7YYJ9uMNqls9rVnz71+V52pC5LOU3Dq1S1SPNYr
	5vjhMBWPBlJaPdVjTZAl8jkFGDs5dks6q3Oah/U+84SOlXqtHVEWmcTJU/za/0rvgNQxzkGMuoD
	6qP5zQVPLKyz3sCoS75YlQ9F4lZPOc+cn68cRpDlR0y095IlRVd/EO2DxrBDaAcwxH2fpCu/D1P
	wgo67YHxQCerBYTzrud/fyhl5R+F/QGdlpQOGWCAKWz28U+biqQa0GJ+9olZ5tf/M2b0TibwH7I
	WO77NmN+OZ/jWxMylQJI2Bc0IRcFYlMUIGy8Ui9FBJDidUbBLMOeAO4eZIZu1wRJGVydRKfEKsh
	plVldnThiiQqmCuwcsP9082/9hU+DP+MLF8A==
X-Received: by 2002:a05:7300:e803:b0:2b8:2a49:9566 with SMTP id 5a478bee46e88-2b8328bb6ccmr2467964eec.14.1770271691517;
        Wed, 04 Feb 2026 22:08:11 -0800 (PST)
Received: from [10.36.158.92] ([50.175.227.221])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b832e4d18fsm2680362eec.13.2026.02.04.22.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 22:08:10 -0800 (PST)
Message-ID: <075feda4-86ee-4521-8b92-914d24aee582@gmail.com>
Date: Wed, 4 Feb 2026 22:08:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
Content-Language: en-GB
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: ziy@nvidia.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <e65bc740-8e20-452c-b66f-0e13cd4e9c59@lucifer.local>
 <2efaa5ed-bd09-41f0-9c07-5cd6cccc4595@gmail.com>
 <b07a8d54-75f2-4d77-838a-7454ad559cd2@lucifer.local>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <b07a8d54-75f2-4d77-838a-7454ad559cd2@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 042E2100017
X-Stat-Signature: 7pfqyx8k8b3sw5etuwua3671xa7gcjb8
X-Rspam-User: 
X-HE-Tag: 1770271692-191559
X-HE-Meta: U2FsdGVkX1+enE9J64edqALxyGkFfTVjMFyh/FY40myorPeDOKcsuDOQEp1EW/pv0T/de/DK3ZtLZA2Wq9bfADcASNAYFlEavIWK9kLxRQwLynf6oKuPFy7JCShPZTVF6VoRc1hDbbvlxaMNJ2eTPcZ/ffjnwsvNH1NjTokApOyAR3isLQ/9zycnEe/KkPTm4Zvjd6Vk+50Qj8/1py/sfTfJM0UKCnOIAZsUjpBzar+wFk2N9egEXWjaE2Y4j/0Q3PIFl9z6HU51ANefuCBgr+oM8+5e5oNSsH/wrcZbiCabq/ChM7DXbnyOZsIrUQDrsFB6seqXBe+EANnHv9tFxdJvyhfJLDgJvh0Gq6uSkuxy1FEjplb7p+4VjH9wTjCyYOVK2OxTaNfTs4zh0HwsQmL3N/2iT9TPBv/QrP/iEWIA3zh7jVL/iuLHwwtJZlozX35+PZ0DFuLdETQmrwT1fV3N7p6x0PjOnNeDTEfABr8WRzfJvvdVVoGv1b4segg95X5B0I2MHnP7MLpb2aWHZU+iRL78YWNwLEohNxD5A6jWTYjicz7oWh9URlcjwaQl+xK5Z1zTvplJRclD8j+dM0HwiLcoBu0y0YPJcBkoOJq48AgodzerYP5t9tiqloj306mjtHKwGKkcV/n9NTYaAOVdvCm5/syrJgmCImUB/+fvfaU/F6xtg4GJJDRaOHHj1IxauLn6IJ93CMIXYtt6cFlnvkKMJGId+x2g+vrGN1j03YwoufvCgF4Ox1xdfo0nLhOLuQHRksFkFj4fD4KtvRvy97QqhkAyy/Id+Q8B8AZPRmf6HghU+MGdzt+AnqHYeZYvBRZp4Xx8WMv0y9hEbP2ZX2u1D2dJzFBMKouNVPZDIdu2LK97tlPr5FkBfsNJd/Syj4UBPFQyVcQ4BjCRMDiDf8jH03qevXNDbujUimvQAAf5jfhlO/GpYzaKXy0KY3v7LqOe6vfdQT+i9+n
 ng/AmOqB
 TRrLTJL+WvOg855MPdomSLWsX1oKKmLLTHI7khRblmSxH32VbhQr2ZHuby7nZFQ2cfdstBRnyZfbRHk2TpwUwWxlcDGZwOZZGz0XPX4peEKl31mYeux/oST4YKhcnBvaJyH32oXDYaq8WsSfRx5dgCK65WmaIoTpnrFuXOcoAKNA6XUtegb43UgZjygMH0g1+NTYaGs0DCsmczwZEwdglRqI4t0k+BUVIfpALoPWVZkMcntBq3Hux369eQfMzfsexXXHgcbQy7MtlZHQTh+kD8e2rwp1FMeFZOEL3TyqGVPXKsLv1SoOHGGWt4YSni18JgG3WennUfRo0tRbxufNmbdH48v82pIzmjQHPaV3cnRDVEgx1Ix3d6nxvR8gzgvjfrK0WT/xdKUIjrV/QgnumaaJmyEChswh7tMX1CQ+XWMz8c9f+UYNb14quI4ZXIzlwOendsBs+Z9oW3JCvH2TrMqtDlMHIqJZHW+JbE0ys/7ieNdBhCcy5U9fr4MbJt12EQoJOH3/yJ13Ixq2pKEiUWmPSn7duDG0jyrbZxSKtm69xcJk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 04/02/2026 03:08, Lorenzo Stoakes wrote:
> On Tue, Feb 03, 2026 at 05:00:10PM -0800, Usama Arif wrote:
>>
>>
>> On 02/02/2026 03:20, Lorenzo Stoakes wrote:
>>> OK so this is somewhat unexpected :)
>>>
>>> It would have been nice to discuss it in the THP cabal or at a conference
>>> etc. so we could discuss approaches ahead of time. Communication is important,
>>> especially with major changes like this.
>>
>> Makes sense!
>>
>>>
>>> And PUD THP is especially problematic in that it requires pages that the page
>>> allocator can't give us, presumably you're doing something with CMA and... it's
>>> a whole kettle of fish.
>>
>> So we dont need CMA. It helps ofcourse, but we don't *need* it.
>> Its summarized in the first reply I gave to Zi in [1]:
>>
>>>
>>> It's also complicated by the fact we _already_ support it in the DAX, VFIO cases
>>> but it's kinda a weird sorta special case that we need to keep supporting.
>>>
>>> There's questions about how this will interact with khugepaged, MADV_COLLAPSE,
>>> mTHP (and really I want to see Nico's series land before we really consider
>>> this).
>>
>>
>> So I have numbers and experiments for page faults which are in the cover letter,
>> but not for khugepaged. I would be very surprised (although pleasently :)) if
>> khugepaged by some magic finds 262144 pages that meets all the khugepaged requirements
>> to collapse the page. In the basic infrastructure support which this series is adding,
>> I want to keep khugepaged collapse disabled for 1G pages. This is also the initial
>> approach that was taken in other mTHP sizes. We should go slow with 1G THPs.
> 
> Yes we definitely want to limit to page faults for now.
> 
> But keep in mind for that to be viable you'd surely need to update who gets
> appropriate alignment in __get_unmapped_area()... not read through series far
> enough to see so not sure if you update that though!
> 
> I guess that'd be the sanest place to start, if an allocation _size_ is aligned
> 1 GB, then align the unmapped area _address_ to 1 GB for maximum chance of 1 GB
> fault-in.


Yeah this was definitely missing. I was manually aligning the fault address in selftest
and benchmarks with the trick used in other selftests
(((unsigned long)addr + PUD_SIZE - 1) & ~(PUD_SIZE - 1))

Thanks for pointing this out! This is basically what I wanted with the RFC, to find out
what I am missing and not testing. Will look into VFIO and DAX as you mentioned as well.

> 
> Oh by the way I made some rough THP notes at
> https://publish.obsidian.md/mm/Transparent+Huge+Pages+(THP) which are helpful
> for reminding me about what does what where, useful for a top-down view of how
> things are now.
> 

Thanks!

>>
>>>
>>> So overall, I want to be very cautious and SLOW here. So let's please not drop
>>> the RFC tag until David and I are ok with that?
>>>
>>> Also the THP code base is in _dire_ need of rework, and I don't really want to
>>> add major new features without us paying down some technical debt, to be honest.
>>>
>>> So let's proceed with caution, and treat this as a very early bit of
>>> experimental code.
>>>
>>> Thanks, Lorenzo
>>
>> Ack, yeah so this is mainly an RFC to discuss what the major design choices will be.
>> I got a kernel with selftests for allocation, memory integrity, fork, partial munmap,
>> mprotect, reclaim and migration passing and am running them with DEBUG_VM to make sure
>> we dont get the VM bugs/warnings and the numbers are good, so just wanted to share it
>> upstream and get your opinions! Basically try and trigger a discussion similar to what
>> Zi asked in [2]! And also if someone could point out if there is something fundamental
>> we are missing in this series.
> 
> Well that's fair enough :)
> 
> But do come to a THP cabal so we can chat, face-to-face (ok, digital face to
> digital face ;). It's usually a force-multiplier I find, esp. if multiple people
> have input which I think is the case here. We're friendly :)


Yes, Thanks for this! It would be really helpful to discuss in a call. I didn't
know there was a meeting but have requested details (date/time) in another thread.

> 
> In any case, conversations are already kicking off so that's definitely positive!
> 
> I think we will definitely get there with this at _some point_ but I would urge
> patience and also I really want to underline my desire for us in THP to start
> paying down some of this technical debt.
> 
> I know people are already making efforts (Vernon, Luiz), and sorry that I've not
> been great at review recently (should be gradually increasing over time), but I
> feel that for large features to be added like this now we really do require some
> refactoring work before we take it.
> 

Yes agreed! I will definitely need your and others guidance on what needs to be
properly refractored so that this fits well with the current code.

> We definitely need to rebase this once Nico's series lands (should do next
> cycle) and think about how it plays with this, I'm not sure if arm64 supports
> mTHP between PMD and PUD size (Dev? Do you know?) so maybe that one is moot, but
> in general want to make sure it plays nice.
> 

Will do!


>>
>> Thanks for the reviews! Really do apprecaite it!
> 
> No worries! :)
> 
>>
>> [1] https://lore.kernel.org/all/20f92576-e932-435f-bb7b-de49eb84b012@gmail.com/#t
>> [2] https://lore.kernel.org/all/3561FD10-664D-42AA-8351-DE7D8D49D42E@nvidia.com/
> 
> Cheers, Lorenzo


