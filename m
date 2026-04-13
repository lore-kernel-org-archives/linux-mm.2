Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D1E0F34C56
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 14:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C28526B0089; Mon, 13 Apr 2026 10:13:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C00086B008A; Mon, 13 Apr 2026 10:13:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3CDD6B0092; Mon, 13 Apr 2026 10:13:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A60276B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:13:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 58B321A01D6
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:13:40 +0000 (UTC)
X-FDA: 84653725800.02.5CDE54E
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6FD9C4001A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:13:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="U2qrO4/B";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776089618; a=rsa-sha256;
	cv=none;
	b=ISmsYJOBp6ZXcx+RoQ6pfGFzDTu6bw33nRQZr3nz6fW061tUr7GcthM11Gr4qgm3+goPmY
	ER5RXdbnL6sGicU3YJ7J3T5xkemtd5uBdVV2N0I59sAnFEWZth5Kv5RwgLsimFaJtDyQdY
	flWDayS4dj6DhPFxb2DYnMjo2Zj181Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="U2qrO4/B";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776089618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7M+7T8ZcuIplDzLqOqdGKThmKW/nekPSMPdpLelpxjM=;
	b=cU9USdbrkRQWXPN7NYLFDtS37e2xl1xdb3GpAwSJF0vZRY6uNNwLUVLg5DRHPp5T40sVcY
	P1DUk9lpNcQNLt8ndzEthyn0wEvW/nnUF4+BBG1Y49KuM7PJ0hRmid4bVBfHBerpvsd0li
	/SFP74rsYI5lB874HIleIYq2fFPEk9k=
Message-ID: <8747df25-721f-4813-b81d-8c7275a2f33b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776089616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7M+7T8ZcuIplDzLqOqdGKThmKW/nekPSMPdpLelpxjM=;
	b=U2qrO4/BLedHXxuPkTjgI2NHer3fd2VJbGz/lKOBJ4HPiD6R9Uzd86XNZ+k/r78JkhmcJn
	oO50JyjP5yRF18Ia6feGFHQ/voxt99Jfj38P9q17VC/t6iWQPNoFNUlS2GJeaRducNnsGY
	MOODgu6Prd7Fy5mRp7RJ7n0kpAssa+8=
Date: Mon, 13 Apr 2026 22:13:23 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm: thp: Fix refcount leak in thpsize_create() error
 path
Content-Language: en-US
To: Guangshuo Li <lgs201920130244@gmail.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: stable@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Barry Song <baohua@kernel.org>, Nico Pache <npache@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>
References: <20260412175428.2613383-1-lgs201920130244@gmail.com>
 <8eda3f8b-b811-4303-aefb-4b23aeeff16c@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <8eda3f8b-b811-4303-aefb-4b23aeeff16c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6FD9C4001A
X-Stat-Signature: cjwoirrk17sfqxg3p691i9t3imggedyr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776089618-10000
X-HE-Meta: U2FsdGVkX18hScisQBrgQPwjIoWMhC4xQXL04jlvqJjjivyDsoomgtFM3IkfeWa2CkEQ0JXd1YHEfNihb2kZJfhgXdIHnBnERdvrusRit4WlhlWiIBQsv46Flio06hXk0bPUAwrGeVm60K3S4ksv/Oh8GpvkpdTKp2ItOKB+ROxjx+9aWxF/Zd+I3OLKvsg6jsALYmRnf0bsGSilDWQXH2Wb7KaIT9sa/hcPFISCXvM4j7eob7ocsGtv8o8MsqvY9tqX5TSkjLucGNtKEG8XhgF8KXODqtV6URBDBk1RKUcwrg0QidHvw3xx6ETrebOX1UVPg8Vir2ageRz5ehMl9fAxjmbq5nCtN6qHe8HOTBtoOYFkjmjaNJkFFCMPf2Dgr78d8So2z5x2fo0FlJC+c62+Li6zAxzdiXPW2icwHV5H063d+p3pHweuVxMSvp0tBnrqFKlddx1xNxvJce+wgiHPnegpoNJ3IRdLOoA4SycC6AImA0kzcaiMH48wcvqMtvCbRHagVwDBhppbCPOKgx+NocWcp+QA3mjHpqwy8EvviqibJFKmBn/lBfy7t30hLzbLOgFJWLpdnzJa/WEnbxWD9R9I11v8xlf2BWGmFHM+ci7g0xFjEbhnuffUrTeHv5OjnEFoqQ5kjApDZE6vQYfkbJXhTwW6BE9J4sjT0VNIdRaJ1DTCxq8kN2gttMLyCPMESG6A30mMQI0huvBVwRpgqhgY37FoJnX0oBqMU9U4CRhCmOxyEm68V4PcjA8vPedF/nEYY9ZAOXZtAdXBZ8CJ7Da+gBg65Yu/vVeuW4SIybui9IARE/ouF198NM4Y2kCvKmxnlrQ0OJEAOdra6eHVQoMWr/3Y/uz7OzGOqNzjVrUzy773ih2mcdosKmNQJJv2MtWtBotkRx6wx2oyUQzdmAxb3TOrSd4AqmN9XZvms6kibev/zTRwouptAuw006kQhyEzNcFtxqFCtk0
 Akg1zzUf
 zhf4V2JfK78+Z0YQTzsJhLKxbuW8XmJUuuSEWZgl1uJBCy4MJT6PG91pVPytyuApXy1I0oStW0+w6ilEZtvRNxYQeVA2gzzDE9G6Qg/oY+2ejsTjKyTJM/K359T/0LIUmSpnXiGg3E7ymc8dIvbRGm/hkroUFQK+RdnepfMSGB/e09U5pQI7tZ5ee8lSTrT4SNWTMrt0YnC+fYlP2dDOtPpCrfT9NRt5L/kcyaHrhegEoVh98SWZ8JS3b0JDc3rtCiymxrlT+bqsJQpFD+Fro6xJPJRyw5VUZKcs43xSimuvvARN7hFiKA7KATFmCLR5xD3DXBsolXtVoVCuqsAi1g2/5nQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/13 19:39, David Hildenbrand (Arm) wrote:
[...]
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 40cf59301c21..c8ffa188a198 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -726,10 +726,8 @@ static struct thpsize *thpsize_create(int order, struct kobject *parent)
>>   
>>   	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
>>   				   "hugepages-%lukB", size);
>> -	if (ret) {
>> -		kfree(thpsize);
>> +	if (ret)
>>   		goto err;
>> -	}
> 
> kobject_init_and_add() indeed documents "If this function returns an
> error, kobject_put() must be called".
> 
> As Andrew says, that's not what the "goto err" does.

Right. v1[1] should do the trick: just jump to err_put

-	if (ret) {
-		kfree(thpsize);
-		goto err;
-	}
-
+	if (ret)
+		goto err_put;

Hmm... not sure why this changed to "goto err"

[1] 
https://lore.kernel.org/linux-mm/20260411062152.2092967-1-lgs201920130244@gmail.com/#t

