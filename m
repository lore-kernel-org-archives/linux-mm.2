Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2063CE668AA
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 00:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F5786B0088; Fri, 19 Dec 2025 19:38:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A37D6B0089; Fri, 19 Dec 2025 19:38:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684E56B008A; Fri, 19 Dec 2025 19:38:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54EAA6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:38:56 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8AAE88883
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:38:55 +0000 (UTC)
X-FDA: 84237989430.26.EBA0A02
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id DDB4740004
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:38:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cdZ8ode0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766191134; a=rsa-sha256;
	cv=none;
	b=t6aYxBABdOBEVJnIATthONaxWAhWM9OxuN7pDKLva+GxaLjnAiqWWIt0OFDqg+xuTD/xfl
	JWFZOXoK0FUu7fD6WXdqIECZGItGhw0PCfkxBMJA/RumVPRVToVBL8Sq/p/VdHQ4P84nkT
	Yi+pm4ClL7fGwLEUqV8rKGfYPtseuR8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cdZ8ode0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766191134;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Y3Y0Yx+NCyZ6/DOSVsayIB2ojE39RciO6fXS+6DEgk=;
	b=CbLgztmrpuO3nEzHU2CRaquUc6RojXPDUaC5Huni4H9VzXR14MVe62wlT1jQ8bxKjVe/Gl
	aFeui/XwcsKmj/wwFK1F9yjTus0IZVTLJ2PIR3hkUTG2Cijdy6K9Fh85TdPnOOFT1YkOCn
	riIy4cXyUDKBeTYrkiJlVqODAu6ewgg=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so526150666b.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766191132; x=1766795932; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Y3Y0Yx+NCyZ6/DOSVsayIB2ojE39RciO6fXS+6DEgk=;
        b=cdZ8ode0mGdMc+X/eEylIolQNur2MtsMxDWS8fZgbsBI7orsCJkARpjdLUg86xf/6w
         z+FBDqXtwwx4nxlN2hU8242RRMFuMcgRozWCp2pIappcjpiXyoq+MEy5qQhmDobGoia4
         TzsYQ+U2+1IQuVCiS37vl63tr3SDsq4axEH3I3YQnVPKzA7dDloAtL8RTohhRaI4Z8S0
         kztMjYRhuX2LmLd1UiryWBOdQezlP7gA+sZhXJuCLUp3UwN3niXrAgTD199Ff55PYHAp
         HyezeCYboLrun0Poej+9PxhmFpDNSXW//S92KacGAwM/+MpZoqwOtbafgRsJqSdXEXls
         qCtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766191132; x=1766795932;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Y3Y0Yx+NCyZ6/DOSVsayIB2ojE39RciO6fXS+6DEgk=;
        b=r0PlBTNfJcIU8/o8+EhymUG5ex32Pj8ZSkyENPmmDR72kGvKoo3oOBMAN61nqqWuNv
         OJjUNIEBfI+ErKZcbrRgznj66qUv8V8a/QzWhUc8ywH7hGSJOWRjR2TteqFPmhOVE4tz
         sj9jA31Mro+xK350KAfsVL3nxr8FDy1d9xXFVX3np3ZH3AZcgtvWJtHiXKKEL4sXnr/R
         ZTOBRrfj68tt3xFhHGuZugXxId2/bZHmgnFgOwRHFHXwGVOnwhEYPqT+xkzVXPLfrWwH
         eX6tU4MhmuSm5GGITQ4wBcQiow7Ba0r7vYm1Hd1imWA+g0Oh/ELkdpZEAdKmCDfOL5JP
         2IjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxNdCT28OXBnukssOb3uR9YVDH4E+8tf4jWFgdpkxkQZU1jsRdeWo1FdwWy3Gj3g6ZFyQHMFW4sA==@kvack.org
X-Gm-Message-State: AOJu0YxgbPJV8bDp1JwhD40Z+2d+RXvnM+3ywipJhz0AIZdEOAv8Nnse
	z908JyhfsEbCMF5vPDBcMGIEAhSOD/aDZkVDOF2ElcaUaFkOIzzq3iTw
X-Gm-Gg: AY/fxX7EaZ+A/hUQmjzAJ7E66LWrT+B46v1zOdEJ2NxTpStbuSHqlWr+LPr5xHAHbmN
	YgdIkrBe8Pss0WeePbSttobIVFAZJef9HYUsbTpukAw3sQrJFK8gzIUMBimzkhYvnAWiYQwAQV/
	E3t/L4qn+JCawfnjQICtOqssMnASJ5gvCNOwLGn6qaGkTisfsWVFy1dj8HnNqftq9xab1Oky8fM
	i5rYGFYJRO0MO3pS7ZXQJD8VJ9UHD8wHfi/57ztap4GOtlM5KE/T3ZnSv2LSTHvHgEJEtBeD5O8
	94a1Fk4YzwjYYO21sa80P6jkS4hqrXVqvvIe7WIV0p07HbYd/1qE2e8qcHtVOu8TYyGLSDX9HVI
	fl3cxfa2uj1MTTKLYlR5jZV4aT1YZPWeDOym/Whxhw64IZpvQ2815sfSqlXVEYsal4y0CU60mnJ
	NJ0/pLQ+95kg==
X-Google-Smtp-Source: AGHT+IGMkT3dRU7E8CU6/p5XRm3FX+P7Y1WZkYUD/SbScH7FS0t89FNoNETeJQo4FkXBW5inymANjQ==
X-Received: by 2002:a17:907:8e95:b0:b76:7e0e:4246 with SMTP id a640c23a62f3a-b8036ecbbb2mr420395466b.12.1766191131803;
        Fri, 19 Dec 2025 16:38:51 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037de11dasm349498466b.35.2025.12.19.16.38.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Dec 2025 16:38:51 -0800 (PST)
Date: Sat, 20 Dec 2025 00:38:51 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/khugepaged: remove unnecessary goto 'skip' label
Message-ID: <20251220003851.dzsafcxtlbgzwsm6@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251216111139.95438-2-shivankg@amd.com>
 <20251216111139.95438-4-shivankg@amd.com>
 <20251217024818.ngoime34bxeatqij@master>
 <c7c1d62c-7d27-4b73-8173-0493adc66cfc@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7c1d62c-7d27-4b73-8173-0493adc66cfc@amd.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DDB4740004
X-Stat-Signature: fs6pozwduzb7wnudgtzjomrqme61gbbk
X-Rspam-User: 
X-HE-Tag: 1766191133-751867
X-HE-Meta: U2FsdGVkX1+rj/V66dMBqUkGF670Agz0MHfvwyCNb1GhbgMTRI8UkINH6CD4Nleoe2R7RKK8j8rU5F19CgQiLjArax+JQcKe+QEaA29vZHL9G0C78DFegTpdI7pxgRvIl1BMQ4W8926mKtSqWtvyjxgw5Fnw2HcqJfmRGnq/ZRqMuxwxYTxaIB0r1e4EgTbqikkZJ659Jx/ltbPFDHdZhLpnL1k8hqa62iyiJss0oeUEvqleBEGXsMzpnlpA800+WzpLx2Zmfl3m6oLrBv970S/GXUk4kT0agUD48l8dCGJAQUjajYS+KxLN6HEtrHt/gXaIphRRjNI5gwPqJbMGHbHcKcH0StMvlteHgzHPfIJxSJWmRmfDDyTxbi0iil3268oXHNS3xnG8PpCrt9hy1jFIB2ohOKvjTz58PCBQh5AMqU1gYuBGYi4l3GdhmsaNIImeEPNp7Q3wrjxJKMXnC8c644mwtoC6YEVGZjeODHK+/kHWvXlVihUiNKKCHetf1I16vMhVZlSpleCAINGC2G0w99xtFC4vEOoPLDTgistJL9PwAWGL8TWPjaqXYIFNm1SRPLAoS3fmUKV/vNlKvR/r9MjzUsReOJwCCzK68KceJiZKRjXTsH63ObyFbr52Mqsz7/SzzLGboHP+e97Pzd3/a2ywHB+ZHcqwXF4ZvgbNlaJ+yS7+yOAmoBDOqxuzZ3KR5NLv8yhKvurdc4Fi7BOAg9VC1imndKvotOGVRwwGqpYyr4OYRvhfR7sacmD7OEb/BgtInMxzL6Nso0s5YLmvhS6bKwk60dlQ+ko98LoqyGMOIpIib6btJK6sr+wP0YBIJ23SlzZWAbQustEFcLzX3L+O9Y0yL7pYUbDWPV6f1l+E/+dC1ItZdPs+/QCTI/qwGAP5zQQ0WBD+MB/hwHZnOBucW/iImCf/v7AYN37Yv2ovr2xIQxuAGgps+oYUHuUE52fOV3I9q4TuJsV
 Fa7ebz9c
 aIzJANZO4QNXEZGn07GL8CTre4zWpuGloPZ3tMSzqBCbZLTRUd8bCpdocUBN3M1F83pg8naOU36XPe8XZpC61LF67wDv5qsWBmNKMSFvaPdRnzQ5kn9TFZcrj1Pc8jdk4DaN0GLHsLYl44kIblQUDtj0c/UQNkH3nHcAiKAgSB8Ps8AcuyXJLUPCxP7sCg+6X980sb6e0OoLGIbfMWazVnMpGmZGCShhsbcJGIhK/ZDs3Ue2Tray8jEZlaTpLxptd6io1Sgm6gLAn9LuIGwVxwyIQ/BrYYD50wwr5HYpF7rJErfbhCd43CmgIf5jD6m9S/pHFoXOZMUAhH4G8XhUFas9gXJeJkl/R9RXoHkdg36Kw21PGGKnyV1yOnn5HS5lvQRizD3wDD+PRAF6Ck8dFjzXF0XJ5CwsvkVdCPL7qnE2WQ/E8BlFNQ3An3VN5T3q5n39bQagBisiIuziT4VUh/iUoFPyaQ+DY+Z/ZIBOmVqVO+sQ7Lp8UVYwqlU9P4t1N1HwIxZC8o+OJp6+OlxdPkYXstLYXJZMz8hWmPcOAuSuyYHllcAN8RVrVna0d/D0XEUlR8j+e8AoVXsiL/z0noJJaGD22gfkmSTbe2y+5nG0o3Ydz/urq0K6uKBDEjMRZSJ51uQL1LkIHUJNh1nq5hIsNBGykYQfuuH69wYgYWberlf4f38FLb7nx7nYav/SfSBwCK0Hex4hPmP8OYZwn7pDI/tffqds62l/I77IMUmfCX8k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 02:54:40PM +0530, Garg, Shivank wrote:
>
>
>On 12/17/2025 8:18 AM, Wei Yang wrote:
>> On Tue, Dec 16, 2025 at 11:11:38AM +0000, Shivank Garg wrote:
>>> Replace 'goto skip' with actual logic for better code readability.
>>>
>>> No functional change.
>>>
>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>> ---
>>> mm/khugepaged.c | 7 ++++---
>>> 1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 6c8c35d3e0c9..107146f012b1 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -2442,14 +2442,15 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>> 			break;
>>> 		}
>>> 		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
>>> -skip:
>>> 			progress++;
>>> 			continue;
>>> 		}
>>> 		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
>>> 		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
>>> -		if (khugepaged_scan.address > hend)
>>> -			goto skip;
>>> +		if (khugepaged_scan.address > hend) {
>>> +			progress++;
>>> +			continue;
>>> +		}
>> 
>> Hi, Shivank
>> 
>> The change here looks good, while I come up with an question.
>> 
>> The @progress here seems record two things:
>> 
>>   * number of pages scaned
>>   * number of vma skipped
>> 
>Three things: number of mm. It's incremented 1 for whole khugepaged_scan_mm_slot().
>

Agree.

>
>> While in very rare case, we may miss to count the second case.
>> 
>> For example, we have following vmas in a process:
>> 
>>      vma1             vma2
>>     +----------------+------------+
>>     |2M              |1M          |
>>     +----------------+------------+
>> 
>> Let's assume vma1 is exactly HPAGE_PMD_SIZE and also HPAGE_PMD_SIZE aligned.
>> But vma2 is only half of HPAGE_PMD_SIZE.
>> 
>> When scan finish vma1 and start on vma2, we would have hstart = hend =
>> address. So we continue here but would not do real scan, since address == hend.
>> 
>> I am thinking whether this could handle it:
>> 
>> 		if (khugepaged_scan.address > hend || hend <= hstart) {
>> 			progress++;
>> 			continue;
>> 		}
>> 
>> Do you thinks I am correct on this?
>
>I think you're correct.
>IIUC, @progress acts as rate limiter here.
>
>It is increasing +1 for whole, and then increases by +1 per VMA (if skipped),
>or by +HPAGE_PMD_NR (if actually scanned).
>
>So, progress ensuring the hugepaged_do_scan run only until (progress >= pages)
>at which point it yields and sleeps (wait_event_freezable).
>
>Without your suggested fix, if a process contains a large number of small VMAs (where
>round_up hstart >= round_down(hend), it will unfairly consume more CPU cycles before
>yielding compared to a process with fewer or aligned VMAs.

You are right. While I am not sure it exists in reality, but in theory it
could be.

>
>I think your suggestion is ensuring fairness by charging 'progress' count correctly.
>

Thanks for your confirmation. Would you mind add a cleanup in next version, or
you prefer me to send it :-)

>Thanks,
>Shivank

-- 
Wei Yang
Help you, Help me

