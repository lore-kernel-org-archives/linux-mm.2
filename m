Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B00CAE6748D
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 01:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 864976B0005; Sat, 20 Dec 2025 20:16:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8110A6B0089; Sat, 20 Dec 2025 20:16:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713F26B008A; Sat, 20 Dec 2025 20:16:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BDA46B0005
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 20:16:39 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EDDF6607AF
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 01:16:38 +0000 (UTC)
X-FDA: 84241713276.22.810A505
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id EE0371C000A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 01:16:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lD1gafCX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766279797; a=rsa-sha256;
	cv=none;
	b=lq6Nt93dM9/uhLgtjTi5h0BGddGBog0HYtSdPXFVXcT0MqIaC9vVbg/6ZCOCnpj73d/8VP
	JYfdC4zxvXaQ8vfp2d0DCE3Kj90gwxSvZpOZZqowp5WbXEAp21v3ROfsXZyor4lgsfDVrA
	7H6foFBfD+rrzo0WQPvwSJwQsHNaBtI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lD1gafCX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766279797;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+2sMUT8kDC1Ir29lVu8GWpeD0f+cthDMl3JzZStKAs=;
	b=MYFKvqY+j38sm3U6x0/n8rDjBfFFlRI9phgyKwMayPTCWjmRabXPuvW+xgtzN7p3UsFEoS
	QrnAyKZMdBkVOR4d42MYg/iX78sLc1nB6czd+fZQ78cMVpoKbONDleRLBcT6nVVEdt+/GV
	1mrG6AZffvlDUVmU63klvVt0TvDpLrY=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b735e278fa1so515245466b.0
        for <linux-mm@kvack.org>; Sat, 20 Dec 2025 17:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766279795; x=1766884595; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8+2sMUT8kDC1Ir29lVu8GWpeD0f+cthDMl3JzZStKAs=;
        b=lD1gafCXi4FdUqLvq/YpqlSRdynsnrgfkne/cjolDo72O9Uqn2oemHjTS1Pz4Kr4oe
         hC7/uKV1z9zXUlCX3TJVq9r7LBAzQ3V19fj9b+LPnUE+te1w17P8PLwi/i+KmH2Ja9/x
         tjJA4MWArIr4XAKgd/7mbmm0y+aa/5fbcWbijCri35e74eUPZcaZLUBlvoIITd1CL0vj
         GNBcxsW7WE0uTr5+Y0HN6icWojZ6v3gDY7XeORF3knfTd2zDMrycNkJlUF3jgBK23IaB
         Avua60yfEYf8/x6O5q9hQALayrvsN8V8BABdv4SVSnoVLTMK8V2wWO0/J8a4njRBImXH
         cyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766279795; x=1766884595;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8+2sMUT8kDC1Ir29lVu8GWpeD0f+cthDMl3JzZStKAs=;
        b=udaaLy9S/pjSP4yFJB84y2QvwDegPB6P9k7eSaRaC1HZSgXxwliH+kyaDfa+2BH619
         /xUExj9hxb2L8UbSuFmi/5NZtWArNxYqjHiYXEpTDswcQgmM1thn6yBxs+uC+IYJbyjo
         GC6Ovo+xsC/s7xVCCjX0AlWA0UyIPBbQb7KJyw0CiXnV3F08FYDOPCc5D6lOsqt6Nz+5
         TcpoW0mKiyq9JvzJbqm24m5yOVc/mtnqRE55KDbR8X3EZLXf1N6e0E1RYDArJ3bs5yJh
         NWYVOLkJVuP924WsIfnMPpwF01gC+raVajwIFg6+DvFwpDydWpPOjo6S20xOqGceE9dc
         EZGA==
X-Forwarded-Encrypted: i=1; AJvYcCXHsiG+JQNujDQXSazEPn8HJSgw7nlgAKxzkixyeNUgrdyJnn46SZWglrhw6j2KvYd03j4PM52vGg==@kvack.org
X-Gm-Message-State: AOJu0YxXUB85QHbhFXPpwjExzhktB/FqQoaxR0XruUuMaa7mLRIHXZm7
	AseFiroBZRFwohequq0YrUjVUTqHqdGD507k18xCEzw/wUs6F4yITW9v
X-Gm-Gg: AY/fxX4/AX1I6piiFh/fkBWONCGg7vsI3TmmjwRiZHAUx/8NdLMS8t3ZDGCLHCr6WoU
	qPRQ5XGFB5Eg3dB/qr3gREF3meyTNtCm4NaOzbfuBOgiVrVnQZKBFG+Dl4Ty5dq6kyqsKM5vdZH
	rcfD6OoTxwUQqk08zXKmiPuecGMN6ac1E0+0INk+WLJDcxQpdaugLuEoEHTHRV0ShQjVxdKKUM/
	Eix/E9mKRm0t1G5sT1Skj5rYLElByCqQmyP6ZG+fEs9YNBSPaO12Mc6nodM6nlPXE4Uswb8iWes
	IbCweo3ZJky3BeyibF97GaQZjfCgcD3+b3a5HljWD1tYth1vHDs+9RE8YIe2eT3IheSw5Q2YVIe
	zEW+caxQkW06peEm8ECrZ8tCwgjeaQkPB4qAIwqgsHdujYegNMk3suaM49ZJ4io7Pvo+SrAQI/6
	TAZh6PiIXNdpcgTXBui5nK
X-Google-Smtp-Source: AGHT+IFD2cY/Wxoo2IxpcvIXcNiq4H/08jKq0RxJx57XdtKMD/Rf+oialktXa+Hm/L916QKJkZCtbQ==
X-Received: by 2002:a17:907:e109:b0:b80:4030:1eca with SMTP id a640c23a62f3a-b804030298fmr439312266b.2.1766279794994;
        Sat, 20 Dec 2025 17:16:34 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037de11e5sm627341866b.39.2025.12.20.17.16.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 20 Dec 2025 17:16:34 -0800 (PST)
Date: Sun, 21 Dec 2025 01:16:34 +0000
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
Message-ID: <20251221011634.uolx6ajnnpaevnvb@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251216111139.95438-2-shivankg@amd.com>
 <20251216111139.95438-4-shivankg@amd.com>
 <20251217024818.ngoime34bxeatqij@master>
 <c7c1d62c-7d27-4b73-8173-0493adc66cfc@amd.com>
 <20251220003851.dzsafcxtlbgzwsm6@master>
 <63453d94-6410-43fd-8676-dbb04e423b10@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63453d94-6410-43fd-8676-dbb04e423b10@amd.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: EE0371C000A
X-Rspamd-Server: rspam03
X-Stat-Signature: u3i9dtqzgpkghm8h98hj8nahud4icgjy
X-Rspam-User: 
X-HE-Tag: 1766279796-335465
X-HE-Meta: U2FsdGVkX1/s6sz6HsPGN3WCWIldlfg626ba0Wh8Nb0D4oe3El0Qv6oCBl1KgaJ1LhKXeZ/Sczwf90SuimOHLDefxKYnE0Avi8h0y83sCiLJox170FfQZAgjjkZaOmvK2KCidh82IhuGQyGim4hzfEj8OIOMXw1+AiVeczawkDDlBQA7ovKj9dd+mqb2n0INI5GGllQFZ+BcvG43AUImT/z+C+ydhdLAXMy09gg6HefpMLfUUYhqb3f1P+5Xwr5glaapgbw/YSiqnOzYsTx2awBfyuGiC237bRna5JPMD9NQEPikOsHlUosyMWRFE59hKnFlWGp36nDat5Sl76I0wkvTNJw2W4VdBOIloY0UXHEQFro9Q6S3ueBeWBTL+1SX0l+G+999+muGedcO2Pin5vBDXYk3k0lZFv27O+9S0469Eys4/gyDLKQFHWMnQCTj7yw15yVqdLZ96toIoub8vat/cYSswlHAqyQdXXWpZWtQy4y33APof8g91TtW81aK/PwtxtZZFTmUWd2Aufn5yBl0gawy/9Z6gLaJDfvuDF8CGIRRPQWkq9QJ2jJDTAVfo+iuQSVTlPizuOBDpI0uy213WaelrEkn0/69XbqCgN4oGGDoAUGKEi7pA8KPYx26q/RF/c9R0Wr0RxoKIY9S+EskUn0++MdAb1b6wonhGjs5s92SxEbxegnAuTbzw1CVkma8L5ZP+eEdDytIfMsASqdDHiZI6rDdQ7abNX8e09DjrjMfZlMBZjjzOw40ToObreKSCvNS6BEs0ROygnV2jXMb4kzCJtToGWupH/5q9YhXbNabvijkfBTJ0WFWo6cGhcyu9agB/+cBvoFT+SXR7Oo8tkDDZpVHImTR17y1C9rnV68bnBSoZpJX+5FitBHN6Nsjg9H2UkON5luFCJ6hDW3LZYaRmAsgREAB7BETUj4V4jxdssB2/Zd6VwADqhicYOyigRUB6RQ4RSpgH+d
 HreUIMKq
 YOx4pg5I8R23+l8M+xXWzB8Aty7KbI2nI3yB7U59KibGzAYBjIBERDR03ZYk531RUDmX40lBsrjv68sZ8od4eww5aw3FPsOtDkKY9LQEG9xRDD5MmeBSd6BpXVzj+wzedsX9kgsaZN3AMwVn6iM90qA7bY8dVIF6hoL2m95uR2bvTyU3pj+tFYve7gbpEIsAAnox3vaNeB5AHlgkEJtUdfpWG1EITOtTMckNlrwHwfn4CUXgCO64oQU2HDXajhzKNPsca/StbZP4sb4N4V8RkGdGWAlX+3aBzlQcl9wSPOZJhTCLOheoBS6TUTw7IhQliHZ+q4HmpbfsXlXNrhJoanFMqpbSwOSKlDvwFzRjJjTVRDBPGPk0IX5fSkor6/4ajyV1FGhXHrvRg/BACwzxYK3rfHbcAVbRM82oLuo2BSgTBv8Q8tc3LLuQOp49YrKULBmHSNQC3MFuy881fTtCpu4Lw8jGsAqXe0+s68XJZdSrkjMs3l2x9kvDMKOwklSGbkzMIhAbHxwe1Q9HdGkbk3s2hcgl+qTzC67IPzRh52mB2hqLnksze9BsfvyuYdxvxtkc5A72HMtrpZio79uHBsv3VX35qOnq0CFXKZq7Azw0ORJbMw7aKtdMn8CaIaI0HcUN72AwfvAMyBMetoBbHBIgJATTKUrK+OtuCqheIwGmJTv7MHCUNjCwnfwiTHgxrBy4D1E1INORgd3V8k8bQ5rrPf5w4Hc8UcmLMEeOIyufyMtc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 21, 2025 at 12:02:11AM +0530, Garg, Shivank wrote:
>
>
>On 12/20/2025 6:08 AM, Wei Yang wrote:
>> On Fri, Dec 19, 2025 at 02:54:40PM +0530, Garg, Shivank wrote:
>>>
>>>
>>> On 12/17/2025 8:18 AM, Wei Yang wrote:
>>>> On Tue, Dec 16, 2025 at 11:11:38AM +0000, Shivank Garg wrote:
>>>>> Replace 'goto skip' with actual logic for better code readability.
>>>>>
>>>>> No functional change.
>>>>>
>>>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>>>> ---
>>>>> mm/khugepaged.c | 7 ++++---
>>>>> 1 file changed, 4 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>> index 6c8c35d3e0c9..107146f012b1 100644
>>>>> --- a/mm/khugepaged.c
>>>>> +++ b/mm/khugepaged.c
>>>>> @@ -2442,14 +2442,15 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>>>> 			break;
>>>>> 		}
>>>>> 		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
>>>>> -skip:
>>>>> 			progress++;
>>>>> 			continue;
>>>>> 		}
>>>>> 		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
>>>>> 		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
>>>>> -		if (khugepaged_scan.address > hend)
>>>>> -			goto skip;
>>>>> +		if (khugepaged_scan.address > hend) {
>>>>> +			progress++;
>>>>> +			continue;
>>>>> +		}
>>>>
>>>> Hi, Shivank
>>>>
>>>> The change here looks good, while I come up with an question.
>>>>
>>>> The @progress here seems record two things:
>>>>
>>>>   * number of pages scaned
>>>>   * number of vma skipped
>>>>
>>> Three things: number of mm. It's incremented 1 for whole khugepaged_scan_mm_slot().
>>>
>> 
>> Agree.
>> 
>>>
>>>> While in very rare case, we may miss to count the second case.
>>>>
>>>> For example, we have following vmas in a process:
>>>>
>>>>      vma1             vma2
>>>>     +----------------+------------+
>>>>     |2M              |1M          |
>>>>     +----------------+------------+
>>>>
>>>> Let's assume vma1 is exactly HPAGE_PMD_SIZE and also HPAGE_PMD_SIZE aligned.
>>>> But vma2 is only half of HPAGE_PMD_SIZE.
>>>>
>>>> When scan finish vma1 and start on vma2, we would have hstart = hend =
>>>> address. So we continue here but would not do real scan, since address == hend.
>>>>
>>>> I am thinking whether this could handle it:
>>>>
>>>> 		if (khugepaged_scan.address > hend || hend <= hstart) {
>>>> 			progress++;
>>>> 			continue;
>>>> 		}
>>>>
>>>> Do you thinks I am correct on this?
>>>
>>> I think you're correct.
>>> IIUC, @progress acts as rate limiter here.
>>>
>>> It is increasing +1 for whole, and then increases by +1 per VMA (if skipped),
>>> or by +HPAGE_PMD_NR (if actually scanned).
>>>
>>> So, progress ensuring the hugepaged_do_scan run only until (progress >= pages)
>>> at which point it yields and sleeps (wait_event_freezable).
>>>
>>> Without your suggested fix, if a process contains a large number of small VMAs (where
>>> round_up hstart >= round_down(hend), it will unfairly consume more CPU cycles before
>>> yielding compared to a process with fewer or aligned VMAs.
>> 
>> You are right. While I am not sure it exists in reality, but in theory it
>> could be.
>> 
>>>
>>> I think your suggestion is ensuring fairness by charging 'progress' count correctly.
>>>
>> 
>> Thanks for your confirmation. Would you mind add a cleanup in next version, or
>> you prefer me to send it :-)
>
>Sure, I'll add this fix patch in the next version.
>

Thanks

>Thanks,
>Shivank

-- 
Wei Yang
Help you, Help me

