Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 750E6D72343
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 07:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B416C6B0428; Fri, 23 Jan 2026 02:48:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B02476B0429; Fri, 23 Jan 2026 02:48:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2B466B042B; Fri, 23 Jan 2026 02:48:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92F8F6B0428
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 02:48:55 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A7E31403EB
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:48:55 +0000 (UTC)
X-FDA: 84362452230.22.EC63906
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 372531C0002
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:48:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769154533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MYvPwHhfsPm7uPEEPYL527U+7+4R1Shy/cyNbqif0AU=;
	b=2PS5hc4tQ51Z1HuQo5nTE7PaqEnvIwA6lyT8tBrN62BLdtNn3iThvQmcwnx63Ju6bb7hk3
	BTI3V9BiG9uaQQlzM5RbeUH7H4pY2e+0wHQ65w/Ff5uC057RNmrR0+gU0I33oB7MdZryZk
	kr420lAtA65BlBG5qHz2XKTjNOTgUfw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769154533; a=rsa-sha256;
	cv=none;
	b=AJqdhlSRt+kTA4o5YiyVSRIWhQP39Yq6APMBM7DVPfGX+oL6xOUuhWRQs1aKI1RzAU8flb
	5fVM8j9SmdtkFAnpPJQ2nZtKnsveGx8ats0152rBuahaP57kGtUdNHww0ZNru9j3vaGcFz
	siqbpS/6gMBvEBKtbWElwiHOryXc69U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FB5E1476;
	Thu, 22 Jan 2026 23:48:45 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 234223F632;
	Thu, 22 Jan 2026 23:48:47 -0800 (PST)
Message-ID: <afc56f8f-0c22-4bac-a99b-b46df346334d@arm.com>
Date: Fri, 23 Jan 2026 13:18:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 5/5] mm/khugepaged: make khugepaged_collapse_control
 static
From: Dev Jain <dev.jain@arm.com>
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Wei Yang <richard.weiyang@gmail.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>
References: <20260118192253.9263-4-shivankg@amd.com>
 <20260118192253.9263-14-shivankg@amd.com>
 <6486c6dd-2702-4a4d-9662-09639532ce6f@arm.com>
Content-Language: en-US
In-Reply-To: <6486c6dd-2702-4a4d-9662-09639532ce6f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xr5wz8i9puf7r73nr77jd68eet8sb1kg
X-Rspamd-Queue-Id: 372531C0002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769154532-272055
X-HE-Meta: U2FsdGVkX1/YNoekEf4kCNzfMGMN+sks/TUkZdB9KdN02QbkRhYh6o5AXbwOeobkIw5iU7kTZVD2SiOYUMue5aM9OwQgzFsUpktSTXMejDHvEYHh8wZ1F67cWp/Ko8eCUXur2MJY/ERlduRWJXIC4DPMzJOMr/cmPVErAjNKnvNlJwEm84rq7pOHPVnCyjHbdqQicEVUigzGp/2VB5jAyBzrpvgz7C6nqDNLny7tvAgijTIrAZbNvwqaNEJVQkAHIvyDPrRn/uDd2oE/k2l2H5Tl7spXf+YnDfKX+/ARHphOsCDtoQAbMOR2xEGpzz3u5TnaXYLxkt7CmJ0gnBX6thWEL3pyIxvMx3Hz4tOTWIKm0f4r/NTbpaiDiMuG40Hg3vqIWk94UFNK9AjECEkFeodmLUupvfCaCKyj6vEUpVASuhXUkUkQ9eXvZkIr/aBFmfh9WzlJfGmhWmpBLtedPWsCad/DYxZ5npuClppmuyUjNUmTJCnKgvFSZ+ipI1xLdbR5mUMs4IIVWPvf8guxMv8/SyAnh+klRCjHoo2NTPvbSBYvaSwcmwNGGwaz1AimCfTANtHgAB3E8MnKCtsV+oyaYM0CZiJrsG8mnElsFE0a2UkbZ0eylp1r1g38/y5RAVc92V+ijbuIx8RaRWcnu4bjigeVOEg68Atz6ar58Sy0tpL60zw5LOViUjjJDraiVIuVY47WWQqwJY+6HIAQVYDLSrYDgOceVMdit1N6+4n1X5YuxYSJaRqzkSnioEAbFL11dCzOa+FeUL3YR255Hc9W8qdD+dpwoRfu5OPae6lxs+rq+h3C1U724Zaa2qV6vnjqTV13Q3grQpT7dx2ZQkH4Jxg0LZaWD/L+zuxPzcMXWh1EXrRPFr10tUCzmjoRWDC0+fxoy1pmDZevryS3sIzS4sKEH3LNi94AvdaYavs/FojXSa0rTkE0cKjT9/HHFksIulekMMWi56OguUh
 RGmsUJaI
 puuWVm2ti5YQL5TVzKOg4TRUsGk0ZLhN3pRKaqUQzfzUmL6L7qKIaqOSGHtZnBa3q72JWhK0E3QppnD8uEIBr025WLGCIBegTeYo7IPpJSHvsT/vA//2hbhe9n3fbcAf4cLIS3wbK9kuKZjt/9t3NVkok1i0TnGPeQYUORgb6BooVyrWw2CQxPMMxkmxMi9MhoGnx1lHed2/ZOZ1CsrBam3gvVPLPUz7nFrpp3wPbVP3S2cT5Wvcvcwj+xPDAipC1rvQbr2A4c2P1PWgupak+DNwgUtXBMysA5he8FRlbBs7xfkx+VJq2hS1oiu3B+TBu2LTblf9rlXusd6axFmz6NDw3IgXwXhBt0MGw8w9gq9ggjyuVvXEHD267cGG+tzi9bGGWDH/JRi2APp7smHGQGfO8e96jRQNUvNw/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 22/01/26 2:58 pm, Dev Jain wrote:
> On 19/01/26 12:53 am, Shivank Garg wrote:
>> The global variable 'khugepaged_collapse_control' is not used outside of
>> mm/khugepaged.c. Make it static to limit its scope.
>>
>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>>  mm/khugepaged.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 1667abae6d8d..fba6aea5bea6 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -827,7 +827,7 @@ static void khugepaged_alloc_sleep(void)
>>  	remove_wait_queue(&khugepaged_wait, &wait);
>>  }
>>  
>> -struct collapse_control khugepaged_collapse_control = {
>> +static struct collapse_control khugepaged_collapse_control = {
>>  	.is_khugepaged = true,
>>  };
>>  
> Will it not be better to just remove this variable? In madvise_collapse,
> we defined cc as a local variable and set .is_khugepaged = false. The
> same can be done in int khugepaged() - define a local variable and set
> .is_khugepaged = true.

Since this patch has been stabilized already by 4 R-bs, it may be a headache
to now remove this, we can do my suggestion later.

Reviewed-by: Dev Jain <dev.jain@arm.com>

>
>

