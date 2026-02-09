Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1099DE7E0B9
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 09:55:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75E0A6B0005; Mon,  9 Feb 2026 04:55:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 735C36B0088; Mon,  9 Feb 2026 04:55:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635076B0089; Mon,  9 Feb 2026 04:55:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 539166B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 04:55:44 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 030DED620E
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:55:43 +0000 (UTC)
X-FDA: 84424461408.06.C8B32F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 57A5BC0010
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:55:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hp5YLrKC;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770630942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pWdUhgxDzRV7HRH4oVMdvkDRh1YzEzz4iZb5STB4kZI=;
	b=RHR36lLRFSUUANfhQYehp62sG437iEhUpm+WsicqimNOJwrd8cjT5cEN7Xj5/BglMISozX
	wwMEvnSgTP3Vy86MYEk8gYmKShu9Ip/qTsmd3Eukxq3Fz3hU9j0J6aTkmMrgTGdZ8Vt427
	PR8+k/mdG5aQhV4LBeMWSS9xeUlnIoQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hp5YLrKC;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770630942; a=rsa-sha256;
	cv=none;
	b=hPz3iicz3ewanjuLW/Rr0W3p3lmbxKCiTM1jh9W+Ao7hnhRqzPQHyNcQH3DJTMm4k+dugt
	UKgJ8yAJ3DAFcT6Hd7aLq0xXWTdgEB31dTUOsKRdtWkWeCiGji3mg6w4JXifTQV9nLcbBb
	qb0kIrxaMrGidBJMiUYBZPzgR/5dnAQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BF16260008;
	Mon,  9 Feb 2026 09:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CBCC116C6;
	Mon,  9 Feb 2026 09:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770630941;
	bh=/zeD3Z28iae7zRiVNaHCzegaAUapv7q/BPbPb39QLDM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Hp5YLrKCuRwe3favx/ifQ0p0b6aYrjP4n19amuwxse5OmQguLmG0YyNj3EnDwckEH
	 9gSsvHLNMTyKsKOLr6E5wN0uXlhlukk7/c7an/eOOp5NWFdPwxmLSbUvY0uKBYXBTZ
	 H72u0JBu6aQyLFRN7l5Ep3mhYeZVVKHcKFpMJJh3q4qEU2c4IdRSe22N5szVcld7Vx
	 OTIoSM/6N4MRj2VSA/+zk74U8Vj3sjb6L/+7zb7Gi09a7wChNKpBHLKTdQyMEOassi
	 QjMMp48JEp1KzyUZFDv5/0duWDZGMtj+N8vNh2sNh+HKUvR+TXZWP4YVmpz0v/C26w
	 Re0sRKfsAFAsQ==
Message-ID: <16fb7985-ec0f-4b56-91e7-404c5114f899@kernel.org>
Date: Mon, 9 Feb 2026 10:55:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] arm64: mm: implement the architecture-specific
 clear_flush_young_ptes()
To: Baolin Wang <baolin.wang@linux.alibaba.com>, Chris Mason <clm@meta.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, will@kernel.org,
 lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <9d866a2644051e13a41ef4d6ca3909c6e1f9e229.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260128114936.72280-1-clm@meta.com>
 <de141225-a0c1-41fd-b3e1-bcab09827ddd@linux.alibaba.com>
 <07d55759-a50a-457a-badd-85697174116f@kernel.org>
 <280ae63e-d66e-438f-8045-6c870420fe76@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <280ae63e-d66e-438f-8045-6c870420fe76@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: xw61ysxgmsbjim4fo1ewuio69d1rursr
X-Rspamd-Queue-Id: 57A5BC0010
X-Rspam-User: 
X-HE-Tag: 1770630942-296504
X-HE-Meta: U2FsdGVkX1/gwOCMpqSV4t+ac1udccsaelO7ZjKV4VwFJZ7pxGwxrZtWKot6gg1ugTxopINxPi46WeXTB+xemK61UoRIrsWEUUm19stqh/K4A+MO18p1bwQ5wjo/OD98DSuOJoX/KaO9sroOxVG4Jchar8VL5X1u+AospLHk13gZIXH/SldxZWlcPQ60ri6p+tlECrEFPUHtR6nGtpashTUROFFp6M+RLSdC1lLH9fhtn7SX9yHUippodk7BDJxEIIhQMxxZyANJUdnQD2E5OeH4mr9o1KuQcIS6nZqjY6kG/LOVY51Gj66Qb/EQyFDpgC+lHe0bpww4+d7jAjisRlG6FWS+ut8wZcrGmCXX4HaMKY9kci8cxwDzJX8HHy7Eez0EI4g8/0lYTMyi3brPu4hG7BXAc4ypC7CwFD9Xs9t903bZRD987ZheIRtNY5iM3PfoOfDt9X7wH0M5jbo1VS7qNbTc3mNA1lJ4XSRLr5Sy+ZlMO8HJ2ueVZP+E/U8D7+R6U+xroO5KMSunkasxkp9uPDb3D5nHE+A7DIFdmL8WdM/xljKWX7pQaOjeXrGrFOJVUpei7N8cdsSXl1mJ/chigpZ/ZtNH0YmCizN107N19PAerwjGN9SEFDkvWhK+0O8RZ6C13Yx3MznOUMPJVbIwAfn40bmwORl3TeypQ/fujAps0Q+55j/LtojTCj4+xl5gOUdOJHHFEVOc8MbOUWTKiCcWUwR5m5qUNuMrDTqMzeyfPHkBsEIYSwFbam1DvR2S4IymLUJlH6dgB/Ho8XCicHoTzsDMwJUl+tGitKZTHEMtvoN04CKqrr9fRhi0Mn0G7VAKUeiv6P515xhvMHD9yT84RhbZeqSzPhoh4dtF7BmVbyItyL/q1aZSuqeWAXPAl5mX3a7Djly51Qttd/ewfWWp601l1IlnriaavCGgHmeb0Ye9rTzhHY+6LLoqJynZQy4mEfuiv1jEkZe
 pLKPBMSo
 44FDzX+Lo4keQ3X0hfNixXhl77vkge4rBoxzOiUsK17q+fMGEGW3NvHmpINQmGwdpq7AC30ugFTe/JHNTwHB1Kkqac+cEzZvu6Ygau4TToD2vQlURuSMEr8umRQ8dfQoAS5Bzdnui2wMTpd5Z3VC2zcMPWFMlXqcYSVwySJyjJEoxqvRbAJWaGZdtFuQwCan5cjE2+UKcs6QXRbCX5AzoBx6Apk0JoL9qsp0HvpZIYNMNqaSupovxgxoGFKTCPx+y4ORXLON7dfXgBMvmCr888b27vdtdiY6hDuoWhmbeRCWc/eiapVgjXgGqc5N74E+wv/uh7AwgLu0NxW8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 10:36, Baolin Wang wrote:
> 
> 
> On 2/9/26 5:09 PM, David Hildenbrand (Arm) wrote:
>> On 1/29/26 02:42, Baolin Wang wrote:
>>>
>>>
>>>
>>> Indeed. I previously discussed with Ryan whether using pte_cont() was 
>>> enough, and we believed that invalid PTEs wouldn’t have the PTE_CONT 
>>> bit set. But we clearly missed the device-folio cases. Thanks for 
>>> reporting.
>>>
>>> Andrew, could you please squash the following fix into this patch? If 
>>> you prefer a new version, please let me know. Thanks.
>>
>> Isn't the real problem that we should never ever ever ever, try 
>> clearing the young bit on a non-present pte?
>>
>> See damon_ptep_mkold() how that is handled with the flushing/notify.
>>
>> There needs to be a pte_present() check in the caller.
> 
> The handling of ZONE_DEVICE memory in check_pte() makes me me doubt my 
> earlier understanding. And I think you are right.
> 
>      } else if (pte_present(ptent)) {
>          pfn = pte_pfn(ptent);
>      } else {
>          const softleaf_t entry = softleaf_from_pte(ptent);
> 
>          /* Handle un-addressable ZONE_DEVICE memory */
>          if (!softleaf_is_device_private(entry) &&
>              !softleaf_is_device_exclusive(entry))
>              return false;
> 
>          pfn = softleaf_to_pfn(entry);
>      }
> 
> 
>> BUT
>>
>> I recall that folio_referenced() should never apply to ZONE_DEVICE 
>> folios. folio_referenced() is only called from memory reclaim code, 
>> and ZONE_DEVICE pages never get reclaimed through vmscan.c
> 
> Thanks for clarifying. So I can drop the pte valid check.

We should probably add a safety check in folio_referenced(), warning
if we would ever get a ZONE_DEVICE folio passed.

Can someone look into that ? :)

-- 
Cheers,

David

