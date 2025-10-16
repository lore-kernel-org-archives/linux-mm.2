Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 059B0CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 06:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0819C8E0008; Thu, 16 Oct 2025 02:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 058CD8E0002; Thu, 16 Oct 2025 02:15:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7DC8E0008; Thu, 16 Oct 2025 02:15:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D849C8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 02:15:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71A91C0200
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:15:11 +0000 (UTC)
X-FDA: 84002964822.22.18F5ED7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id B0BCE4000B
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:15:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760595309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ajEhGlo0LJCYEq+n3GOEYfI0lN1GDBwwoZA6Ee8JhME=;
	b=MWMDEk8OMK9WUgDcdXZhrBcntZd3LLD562F6I8ZvSZAar0kN/foKltOO+/3RC/G72PjZqj
	sJ6XY4ZCUGnPC9HdHLXQ1Se+0kXe29L8NdwjQV96F+Z90EoJTFICxoHj14KE6PdI3irQkF
	4vujOyDuE3jM4UrAFdba/ekGzQw1U9U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760595309; a=rsa-sha256;
	cv=none;
	b=0L74E0EhmBoTw6ZsxDxmBh8CMhC7UrMH/YQTGnYZXOeRKO4AMp+vofzpttnn90cWL2k4qf
	nlAlGFIl0VdjAlRbdi5GLAm3KpANmbL9DlurGf3BxfqimIhtXeLWJJXMvRhKDBFXBkaHOH
	imSCiTKKV0y4b/sUiKrcWhosQnJtCrY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B764A1688;
	Wed, 15 Oct 2025 23:15:00 -0700 (PDT)
Received: from [10.163.68.150] (unknown [10.163.68.150])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD8CB3F738;
	Wed, 15 Oct 2025 23:15:03 -0700 (PDT)
Message-ID: <debdccdd-1a4a-4039-bdc3-64b68525d03c@arm.com>
Date: Thu, 16 Oct 2025 11:45:00 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: guard is_zero_pfn() calls with
 pte_present()
To: Lance Yang <lance.yang@linux.dev>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, akpm@linux-foundation.org, david@redhat.com
References: <20251016033643.10848-1-lance.yang@linux.dev>
 <ab4e7044-c285-426e-bf9c-fa06a0f47ae9@arm.com>
 <d5d2fe20-9d63-4304-8b36-9708309791ea@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <d5d2fe20-9d63-4304-8b36-9708309791ea@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B0BCE4000B
X-Rspamd-Server: rspam03
X-Stat-Signature: jft7bz4m5k9ua1uhq7qr4ew7uburhqhh
X-HE-Tag: 1760595309-492124
X-HE-Meta: U2FsdGVkX1+pEg8Ruf7c2MWJ3LsLCELvEo28Xa5o8CvY2bOw3pGj8Ar39bZ5r+Lu29Kujbgllw17ku+jl0KRYmjz14p7QGUl5fLi9ZzeiLsLn0TbaHE/Hxsn/VIl6TgcwbgSU+cPjzBqcc29I/gb0Tp1gdloVXIVY0jvsqo3BopT5kikXdSrFaqf6j7lqA0S+jyb93lJ5WKXxyx8HTE+c6F7tBXVJOvALGnXcXUkEHNVDgWONSjW05qv5+4wjfpVOBfHRVfBR07MkW6A4txg8aSIpjsfFPeB5TWr8LyjLhR0koJRJRK2YeIbVB/xUF35vYuceQGgMUhOgyw31hUZ3QqjnWf/4mdFF2mx8qL2iZiRHGIqAAD10a6vqk+wqxadApL/wQbbkPbVXpcXw7/lgeUrJy+I6haJmXFcsQT9CBgsqNgT5xzdjYc/mYGA0eCSrH1FLDDoklDSeQp38EydjM20vsPL8nil4hLbQSSbvW5gbJEamHFn5ihcZ1fhN/DTFsVN4Oy/j+5hPOm88Vxcdl1Q2TgA/35gr/X7x+taXVSJURIrq0U+Hj4uu8l6CCg30mrKI9l5BXazQdrWgOogQFmeecI/E5W3x4H0vH+GDD0/tS+8HaiU/qabB7YAN8Sy3cOwBQ6O32NxONLcNoP6tVTGQL5sVOAXBCNhH3F8EIbwiBN9dpmOE8E/bZyWkMuWjXHbaULuaaCn4k82EhIwY7HqPJvAbCY0aNaZd47aTCrUmJNzyvIy2q4a/dQ8sF5BPozkgGYu7CGnQAGhzgTykjTldxwd/X+nJLeXL4/tbfcPDiP1Q39mbUqUZGapsdKXFIO0vOBwC8bWIIFZ3zDlyMs6jAJa/6Pnvf49VnUz9oQ46hA13paqbfhXCEws/12uQoIwJUDlnfXPhMmBRt2GjvqT1Fx3O8WYq7ua09DqbiUb8kwZT30zsxET0asyUM9dC/Y8rEMOcnHNlB56L+a
 NHKtUR4f
 LPsGoORFjXjQzB13Z4yq74hIpIVHQ6kgq/mMNl/nNGTLULDtjPjeKbfsjiiUN/NLKNowH9QlF4oJj3fi8HqGDdUW7TGmOkHOt6mobpPd6sFfX1+ukcIHzBxASERTSh8g4xRF6snTdf+2EPjGaYJtah/+YGRxJqz5HV29NC0k2jdx+7ixkgJ8lbBuAoPMQWrCbh7uMqCBvZNAmoZY/2Xn3cuRDVRoQ4CrUfulWkGxIgecdskk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 16/10/25 11:29 am, Lance Yang wrote:
>
>
> On 2025/10/16 13:34, Dev Jain wrote:
>>
>> On 16/10/25 9:06 am, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> A non-present entry, like a swap PTE, contains completely different 
>>> data
>>> (swap type and offset). pte_pfn() doesn't know this, so if we feed it a
>>> non-present entry, it will spit out a junk PFN.
>>>
>>> What if that junk PFN happens to match the zeropage's PFN by sheer
>>> chance? While really unlikely, this would be really bad if it did.
>>>
>>> So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
>>> in khugepaged.c are properly guarded by a pte_present() check.
>>>
>>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>
>> Thanks, I missed this.
>
> Me too ...
>
>>
>>>   mm/khugepaged.c | 13 ++++++++-----
>>>   1 file changed, 8 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index d635d821f611..0341c3d13e9e 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -516,7 +516,7 @@ static void release_pte_pages(pte_t *pte, pte_t 
>>> *_pte,
>>>           pte_t pteval = ptep_get(_pte);
>>>           unsigned long pfn;
>>> -        if (pte_none(pteval))
>>> +        if (!pte_present(pteval))
>>
>> There should be no chance that we end up with a pteval which is not 
>> none *and*
>> not present, if you look at the callers of release_pte_pages. So 
>> perhaps we
>> should keep this either the same, or, after "if(pte_none(pteval))", do a
>> WARN_ON_ONCE(!pte_present(pteval))?
>
> Good catch! Yeah, but I'd rather not rely on the callers ...
>
> Wouldn't it just be simpler and safer to always have is_zero_pfn() 
> guarded
> by pte_present()?
>
> I don't have a strong opinon here, though ;p

Yeah same, I think we can leave it to what you have done.


>
> Dev, Thanks!
>

