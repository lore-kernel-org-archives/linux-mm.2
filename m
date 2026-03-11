Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 667491125852
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 16:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 981AF6B0005; Wed, 11 Mar 2026 12:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90BAF6B008A; Wed, 11 Mar 2026 12:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6726B008C; Wed, 11 Mar 2026 12:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5694F6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:20:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E7DB716027D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:20:06 +0000 (UTC)
X-FDA: 84534294012.18.80BA66F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D213C4000F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:20:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gRH9Q7aG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773246003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bR3vsQLWaXkLl0xaiA3nTiKdoROZ8vOGxjPBnQtBKzY=;
	b=AW8kxwMVg22pzeJlmCIIL/mbEvyvRWsIhwWV/LirmkA55mMzuPqFVtUzaHqsyR+sdmT/U6
	lKpc4yKFWYQQDpQAy9DGNOd30i7InHVnCV6N+sf2lmvWOLN6GrQXZxS6nyZhBFEsz4R0PD
	SPEIklYsSsuJaaeQ4S33uqW753z49IU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773246003; a=rsa-sha256;
	cv=none;
	b=jZ6EGEg4FAZtzJ9YZa6YYMCAPKiKFAaquANSeX3YcS2CnCRCPFU7kebp5HyinQQXCvsZtz
	0L0E0A21W5EPSWc3T7lNvL/gGWdCgiTT1UF1RuJyyMLSnSzfFno+Y4UhH+aED2v3xdDTS3
	RorL6rYCQa2anbP4eM3BI96NO/CAenk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gRH9Q7aG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 306B66057A;
	Wed, 11 Mar 2026 16:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0115C4CEF7;
	Wed, 11 Mar 2026 16:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773246002;
	bh=Q38flWxlKYCC3BnTX9DQqZ0jbBnyGWg0kcPHxlKCRCo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gRH9Q7aGzGCdD0Y8A5OV+7ZUpTJKajTLjkbk1qDdNLoc+ithzOd1IeHX4N+2G5Iq6
	 Lfo/iNfSi7kA01erVE9Go0d40XfVTVJYhIFwD6K/2tMyVTEt9wBE9vDx0l6opJGk3U
	 vjnL2Z6BfhfvzlCrfKIpa6Qp44O+cJlIFivipSUV2cWkSUJK/avzGEzN8N/8nm9Ro8
	 DzqHkp/RCsz8CIBDO0vi+zg1V8Sqb6vxOFrqjdBEbOOQKitZ7y4IwOumTeYZC7WBNk
	 bIsU/XdJ1ZhxffBWnnM9AlGmGXwndQAuXc/ji1kDXyHMpbGog0WZJEoa//OnvElesL
	 qDzttUUigftKQ==
Message-ID: <4370ca46-64ee-4357-ae6b-1405e65f3f47@kernel.org>
Date: Wed, 11 Mar 2026 17:19:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: "Li, Tianyou" <tianyou.li@intel.com>, Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
 Yuan Liu <yuan1.liu@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
 Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
 Pan Deng <pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 linux-kernel@vger.kernel.org
References: <20260130163756.2674225-1-tianyou.li@intel.com>
 <20260130163756.2674225-3-tianyou.li@intel.com>
 <3cb317fa-abe0-4946-9f00-da00bade2def@kernel.org>
 <aYjmcZ4hg9bNbmiY@kernel.org>
 <6ea2dbce-c919-49d6-b2cb-255a565a94e0@kernel.org>
 <2cb55d76-4da7-4ebe-b23b-0abbc4d963f3@kernel.org>
 <aYsaBkMecDG595Xg@kernel.org>
 <b3777d0e-0b25-45bc-b387-e67fe5a0d328@kernel.org>
 <de501b65-6d02-4eeb-b50e-bfe5ab9b8d00@intel.com>
 <24ef67e7-6f0f-4544-a50c-90c4de368c40@intel.com>
 <383e1567-0966-434e-a818-f70bff1d5220@kernel.org>
 <214b2cb0-e0d9-4482-956a-5bc599bae45e@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <214b2cb0-e0d9-4482-956a-5bc599bae45e@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D213C4000F
X-Stat-Signature: 968793a9q5ocfc5uipoh77u69mpmhanz
X-Rspam-User: 
X-HE-Tag: 1773246003-998646
X-HE-Meta: U2FsdGVkX18Xmi8/L/JXP3hUBH5SPpdkDJ5JxnPFkandNum7a9CdmxDoG019P83mcBw2o8Q7o4UEoF1cwpbA4tkAbKyLRC3me5KgCcIMuPjKccxMQ/GEUb2Nao7kdqiVIj1VmT/v6WvXGJLwsDH/hivIPT4OEnL27x/Hq1K4gyLJ1tCy5AS0DDr0y6a126bWptbu+TpGku2R5nPyKheS0q7WTh53o3/VD/HzWekPijEsok7j/iwBuK8gqpSe2yrj/oAdlt7Ac7xY1J31uYfCBNb+AH4ZCnJU+i7K5uVEVXXYuxC8CjT7tr8b8cMzIN7/KU1EG1vS4T9ARhOvKvOsY+QtaIJ796OMD73XnjNLKI3VVyUdsS3wcf1pH21DTHbNyDwkW77EdNA+LdxOFTswsfEYtukDeh9GaWnbl408ooVrbF/g4jEGztpk5U1kMA9V2ECiW8aB8VLOEmftiGAlexkh/N08VyqKe3N/NA4BRoO/T1dCmeltq8tVdskssUI5+xAtnGEhbewxWFUQ64MZD/7b5uhgRzHsfhHAffg4u8F72UCtU8gI3Q0F4+3ZFaKb6KSwLa6AuQSzRMljaMUMITLfae3wXq/zYh/u1s7y1eVuoqtF+jgI3+mGY3oVYkf+0B1AGEBjsNRZQP5WCkJNIwFcCtH73T5ToPMUmnl3lruBA0RWWIoTKYxvzggMwRowefkktboZR+cPztW9cYIGe7PmlC8Gpxro3p5vwy6USK+sGMtDKG4E2SrpA4nzfFL5Bob05MGNuiLS3fiYx+RaEixUEc2XmXj5mnzNOtLTLDsRKELJtuTGWSMY5VFk40zKuDq2evWbq11xjCHNLb41JBRM94PeeqKvGKkN9XSpjDUxD/g6Nglbu9rU3L8zv4vGsRGqtJsAkxRLDHSodn7ghvBUsbDWF4IEdtOreE5vLlqcTcqJQCFhINTGADEE3Hy2tHprao62ewIWxNQINEI
 6zxWD7ov
 juV9TmEWwC9uiiSROqtF1jBBLkRNvqajZi9eI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/11/26 16:02, Li, Tianyou wrote:
> 
> On 3/9/2026 10:26 PM, David Hildenbrand (Arm) wrote:
>> On 3/9/26 01:42, Li, Tianyou wrote:
>>> Hi David, Mike & Other maintainers,
>> Hi!
>>
>>> Just a quick update: Yuan and I created a new patch based on David and
>>> Mike's code, updated the documentation as well, performed the
>>> performance test, double check all the references etc. We observed a
>>> slightly performance regression, not sure it was caused by the
>>> environment configuration or we triggered some unexpected behavior. We
>>> might need a bit more time to investigate. Will send out the patch soon
>>> once we have confirmed data for the performance regression. Thanks.
>> A performance regression would be rather unexpected, unless we somehow
>> don't ever set zone->contiguous=true any more :)
>>
>> In which test / code path did you observe a regression?
> 
> 
> Sorry for the late response, I missed the email by accident. The test is
> simply hotplug and unplug the 256GB memory, the time became 3s instead
> of 2s for some reason compared to previous patch.

Weird, because we should be doing less work :)

> Interestingly, for
> 512GB memory hotplug/unplug, the time remains as 6s. What we planned to
> do are: 1. double/triple check with the same and other servers; 2.
> collect the perf profile to see what is the diff compared with previous
> patch, if the regression consistently persisted.

Sounds good.

> 
> I will work with Yuan on this and hopefully we can have more information
> to be shared here soon. Thanks.

Greta, thanks. Feel free to send out a new version in the meantime.

-- 
Cheers,

David

