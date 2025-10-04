Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76724CAC5B0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 04:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACA648E0009; Sat,  4 Oct 2025 00:42:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA1EA8E0002; Sat,  4 Oct 2025 00:42:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DE798E0009; Sat,  4 Oct 2025 00:42:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8DEC88E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 00:42:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1ADBA454E4
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 04:42:21 +0000 (UTC)
X-FDA: 83959185282.15.D2CE5EE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0242818000A
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 04:42:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759552939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u6cEzEFEeK6KqaaJaixEXCWPVceD8QLTDoIGcEvWJCM=;
	b=2yhMqa25C2hS66bZkNR8VsksLrbuQn6xVEpTeNB9qfruLrqkJcaOGD+2Q6PhfR7KntdZ4D
	zbowAYTtdTkfQWRY42qAMLHysSsXwgsRhe/dJoHh1DMoo9U0JOKipDNfmjx3GeEckcfVMK
	RMZe0/d/Xh0QOdeogkQ1nA8pXd9aF+k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759552939; a=rsa-sha256;
	cv=none;
	b=gYJ97dGwgs7W39i/yR1SJ5bkuchnqOv1FpaBmBju4EbfNZvd76ky6NFJSyXf0v6a5g+ISf
	nS8A/nl+aigYszgKEseYEWyMrV6se6mu3IOeauX6tt+kF4mLmPg9olog8sPMcI/kGYIzrm
	9A3T4MoCU2uZ/0Dd1yazqOt/YF9mQ34=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D68021515;
	Fri,  3 Oct 2025 21:42:09 -0700 (PDT)
Received: from [10.163.65.95] (unknown [10.163.65.95])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 113283F5A1;
	Fri,  3 Oct 2025 21:42:12 -0700 (PDT)
Message-ID: <f9f62e40-92a6-4ee8-aba0-6bb9b2929f41@arm.com>
Date: Sat, 4 Oct 2025 10:12:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new 2/2] mm/khugepaged: merge PTE scanning logic into a
 new helper
To: Lance Yang <lance.yang@linux.dev>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, david@redhat.com, richard.weiyang@gmail.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 linux-mm@kvack.org, akpm@linux-foundation.org
References: <20251002073255.14867-1-lance.yang@linux.dev>
 <20251002073255.14867-3-lance.yang@linux.dev>
 <0d55d763-81ff-4b99-bb13-3dbb9af53cdc@arm.com>
 <a36c9776-d158-4add-86d0-c41a09e4a255@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <a36c9776-d158-4add-86d0-c41a09e4a255@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0242818000A
X-Stat-Signature: hbg7dmqzynjwknht43q9p4d8o5p9jkww
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759552938-714049
X-HE-Meta: U2FsdGVkX1+ZBYQQMm/T6dffImCPykjaeH6mNa3cRfTZKD955HTOMpixOiH+2Y4ZFYuklw5s08pu3mieknhOEXjQJ3Gz8vBolVd4DFQ83dana3WwXSA/Hm+49ttNZoUzLEVmVLEuV/xNsnZIMt5W2AH7XeecUeEMuvLbrBXZ+JfG7fhN6NBz9QiCF82TmgpE8NRIZiEaBkbMZ/D0XcTESwBs0KrVq9UIHPfhZlV2xXQgpJqIdq7ydE+0DKa/RqSBDkYCxTpl9DHlt5smNkHsBOsAKvS7MCjoWF3zqFuMUzGHp8llKfmRjAzrYUqZXGucEvP4qqoE+Bnj7y3+j2V8qUWTI0UyuPQDaBSg12Oz+/oIkz/OQd4ffsNxQO4GXy5z8OyJ5XH5/5E0Bb7SH2KQW8wnBwJGrji23e/FFbISDJl8Cc4tweuxPe639wmzpjqw9KSpmHxLJ2HzCqkaBB2UhpAoBqenAn0g+DvJWryj+QKlKCcS5JYQNx2qQmDGUlQwH/0hr6oinkIqyuSlJHl4NrTaJSDjnL+sws8kfUAkRwKCj2BXFpmqVMtMchweIODC9yUvLULs7ybG5QcZeooND4WpV+e4gc+At890H0oPSaj+hbQPBeQvZXswtvxGwDHuzExIv0zZFF5aB8QjVaDBWO7kgNHAuL8zB5F/LyoOEEOS4UP23rA/1iQ/16HHf8AGeMZl2KXwve0ygZ0BY21ARDcKnVEPqzByscIoOUhMDY+6gEIcs/2apVmJMxhLm98PK7Y6atLjy7/QRoB8cS97Xwk29eZczmVUKMdptxqoR1RpEC0jXhRTq2icYI391GKG6jBk92AtinYETTcEgUeWC1ztZgRvR7ZGSktQcQnWlIiHgvH0V46X0VkMMkvb/uAldP6bWOKRgwGZbmwxPz2OtI6MoZvLIcudzaJNtV4tZ/6HAIrZAJjLEWJYboBR+vKvdTUcSqsYpUbaoSDINYi
 VNbjPWDg
 su/W9oZsnhracLEmwqltQm6MMXq3DqAMsgnJNcI91tr1k9NwGhAbNfH14lY24mcosaN2juXD/4069sOg4BS06vuRTWHQvQpv5ssAKeUD6P9Wa9zlCjn6PZGIqi12mk55Dwts9dfHYWLH1MSGkbcJQr65lZkjm5Ng2B3QtblFAnmHt1wIB7+e2l63Hsy1Hxsk6SqWvKDDFi/rw7wyxhvjcO+7Tgolvvomg3BDGNo44wX6tvraMksk52p2j5Y/4kTq6DTKFemOp7aor7dg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 04/10/25 8:33 am, Lance Yang wrote:
>
>
> On 2025/10/4 01:05, Dev Jain wrote:
>>
>> On 02/10/25 1:02 pm, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
>>> and __collapse_huge_page_isolate() was almost duplicated.
>>>
>>> This patch cleans things up by moving all the common PTE checking logic
>>> into a new shared helper, thp_collapse_check_pte().
>>>
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>
>> In hpage_collapse_scan_pmd(), we enter with mmap lock held, so for
>> an anonymous vma, is it even possible to hit if 
>> (!folio_test_anon(folio))?
>
> Ah, indeed :)
>
>> In which case we can replace this with VM_BUG_ON_FOLIO and abstract away
>> till the folio_maybe_mapped_shared() block?
>
> So you meant something like this:
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 2a897cfb1d03..ef87d7fe3d50 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1374,11 +1374,7 @@ static int hpage_collapse_scan_pmd(struct 
> mm_struct *mm,
>                         goto out_unmap;
>                 }
>                 folio = page_folio(page);
> -
> -               if (!folio_test_anon(folio)) {
> -                       result = SCAN_PAGE_ANON;
> -                       goto out_unmap;
> -               }
> +               VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);

Yes, I would suggest a different patch making this change, then in the

last patch you can abstract away till the shared statistics line since that

much code will become common between scan_pmd and _isolate.


>
>                 /*
>                  * We treat a single page as shared if any part of the 
> THP
>
>

