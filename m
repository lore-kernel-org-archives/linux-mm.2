Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16B2BD148B5
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 07:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3256B0093; Thu,  8 Jan 2026 02:10:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 756466B0095; Thu,  8 Jan 2026 02:10:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663596B0096; Thu,  8 Jan 2026 02:10:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5673C6B0093
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:10:26 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F9B98C03C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 07:10:25 +0000 (UTC)
X-FDA: 84307923210.28.76F8F71
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7464C4000A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 07:10:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oVtY8tjj;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767856222; a=rsa-sha256;
	cv=none;
	b=x+VDPjbp/t6zYesx4Os3mSSkNZDmAHWw4UkzHFaTZcHzE2FfO6eDUlefhEqBexkY8AeSas
	Mwz2ykE+7k0pOzl1cF96jK8T9rNvE2hzBgoiKlJVgPESNa7bd7KfnDcNjuf5G2ycSMmSBi
	iyQRkklfPVg/tCwQkPiBRD2aTl/z9lA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oVtY8tjj;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767856222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ORbNOMOE6nQYdN919c1TOiay1P8kR+yOhZXjS8Hf7n4=;
	b=a09W2soFLniPXQSPyV7M82FNkaXpmq94vRcVsCWCzrB7vwNuxZ/2XPKiViqwhvoLNCLmL1
	3Uy7c7TpJ33zwscXDi+bK5AIpkksYVhEfQ+7ufeGDa/HTtWqfDAqb9JVqhlz0HM55U4MYZ
	vaZd9wjuBrwZ71c3SLeeGdljDlttx5o=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ORbNOMOE6nQYdN919c1TOiay1P8kR+yOhZXjS8Hf7n4=;
	b=oVtY8tjjMLSntvPEKlcJ2qq8ve8Q6TUMSzgHbyZKuk3BtzsP7QEE0+ETLA7BvVrCuxjY9J018
	WOmTS1eNRIsOzxxaAyw66ffX19xbEhGaHsxPkN0z9DdZjyxAKTu8zu3rikjinswZ0Nw8FfovNDT
	n14bbQaNETFfUreen0NJH2c=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dmwv927pBz1K9CR;
	Thu,  8 Jan 2026 15:07:01 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 33AC240563;
	Thu,  8 Jan 2026 15:10:15 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 8 Jan 2026 15:10:13 +0800
Message-ID: <9726d769-5803-4309-aa7c-20cd0cf93553@huawei.com>
Date: Thu, 8 Jan 2026 15:10:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 mm-new 0/6] mm: hugetlb: allocate frozen gigantic folio
To: Zi Yan <ziy@nvidia.com>
CC: Mark Brown <broonie@kernel.org>, Claudiu Beznea
	<claudiu.beznea@tuxon.dev>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun
 Song <muchun.song@linux.dev>, <linux-mm@kvack.org>,
	<sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
 <4211be25-3fc0-4395-9b24-a5ff0b3caa34@tuxon.dev>
 <13ad5888-2d53-40c8-9269-22bc6001754a@sirena.org.uk>
 <7253A444-97D1-4256-9AD9-BCFF66437510@nvidia.com>
 <eba617a5-6d8e-4998-bd6d-e25330657380@huawei.com>
 <7b0330e8-e42d-4aa8-91ab-1098a9f89c7e@huawei.com>
 <F951C85D-87F2-4155-B592-DA3D53145957@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <F951C85D-87F2-4155-B592-DA3D53145957@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7464C4000A
X-Stat-Signature: otjas1i8h54rx4mtc59bm1oxycub9be3
X-Rspam-User: 
X-HE-Tag: 1767856221-840863
X-HE-Meta: U2FsdGVkX1+PQwsWccbPViWnIlGgO9bWMxRJoJ4iBGD17wTgCXJQ2r5zFeXTGsnPIFAv9ufY46CIJf8MSz41NjvJlq3O2uirgj322qnMib4nwohA1ozTEw8fJGKjek/297TrKldzYVI96G2Z1uJN1yGlNgt0i5KzErarRkowo7+Hmi8lkM1q3DRDa93K03FMOn7JbJQkMjAhg/YMQIrgXqvg06oPk8RGbDh1RtvI4FKKoUEZVJUrdknflQVNhkO5ZCEQg5j3LeDuFFd2cmTRYghZ0bYmKY+jTh22Chgc5EHhHsfurY4JprJON+GVtziVYyo375VwXp72xn38Va2hg+C+HCVb8g5emZaB+x48VzuGSPLU0SmGraDNo0hF9OC7jE6XQDamjwEYmQ3M1mFABToDzX7VP4NAdoXmvVkFVYaueseqCip+uLv2oy4V6ShdkJPEqGTgZIvor67OtMx15W8QbO+CJ3rxLuvSTN0I+2MghoEkrNMFHW5QTzDx0TfW48SJPNuNjNkBKIZlznGvWrx06adxSQsxjrxIk+/KLo61TgGdWTDfH3ZBrnX7BL1180PPQhhJ0fiSUVOGes/XIr3ijYj4pXfm8HUasYGDgb9JEdGyjKZ7dn/lW2bXHwRuEH8ihTqUqJVRQa5F00uA2ajFU292TUGJFF5eK+W+1yAaQKihYpdm2aCiLSlENoq5//d8GWxcgOX27NhI0JaKDGhBrFd33D5Y8LvIoxldBVkcPQDvJG8+z4S2sMWQuiO3JA4QhBrRv1gB3c++OZhjLaMVjPDe19QLUChsiT2HmtN1Ga2VBoZ57SMk2oM3XC6WdX+XiS+fQoCu8SfVJy5o1rNRZ145rk9Yk7MiKpvOouKV2C1/93g3DTP3oVAdCatOJPwewiz1acnKoq+pHIemaOwSUO9IaY5AeviEGwwqao4BpEfYGv/pL7j3ZxF8ROnwklHTURYkXNjsCy47fRp
 c1z0X/sR
 KKbQ9UXaa37+qHJkJxbV9zuw955yMk5xYGh1GZQGDg29uXmPRO0A2Q7efrpljsf14lX9Qd2eIqVLGSXbLJ3UIkrdmmQplv819VO8mpKgHKPDnykrUrc6ZBytoCsQ6hjR1G0WzSGG3W2rFdm6CYtC5Q4zPIG+WZwLHP4KGoHFyqy9vTbwRxMwxdEQLEtM3JvnwcxABsnSMg6IuCsrPMb9Kx6XTAccxzgGmxNWboWhwb1V3MVpVf33GBDU7Pt1LIzU3w/DTAf+2xKQDGYwHrAUMTp1WBySNXG59gXPIGii+KEu2q6uvkmjcCA8YQxkZpywBEIc3zSvhMCdeU0/U2lOlp+BQ1K2NGAsq8MB1Ii5cgCeDGRGCP1nZwmaw5NH22O3Y979n779Ei7n5SV3s2MkvQhJjXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/8 11:25, Zi Yan wrote:
> On 7 Jan 2026, at 20:53, Kefeng Wang wrote:
> 
>> On 2026/1/8 9:05, Kefeng Wang wrote:
>>>
>>>
>>> On 2026/1/8 3:38, Zi Yan wrote:
>>>> On 7 Jan 2026, at 13:39, Mark Brown wrote:
>>>>
>>>>> On Wed, Jan 07, 2026 at 07:31:30PM +0200, Claudiu Beznea wrote:
>>>>>> On 12/30/25 09:24, Kefeng Wang wrote:
>>>>>
>>>>>>> Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound()
>>>>>>> which avoid atomic operation about page refcount, and then convert to
>>>>>>> allocate frozen gigantic folio by the new helpers in hugetlb to cleanup
>>>>>>> the alloc_gigantic_folio().
>>>>>>
>>>>>> I'm seeing the following issues on the Renesas RZ/G3S SoC when doing suspend
>>>>>> to idle:
>>>>>>
>>>>>> [  129.636729] Unable to handle kernel paging request at virtual address
>>>>>> dead000000000108
>>>>>> [  129.644674] Mem abort info:
>>>>>> [  129.647456]   ESR = 0x0000000096000044
>>>>>
>>>>> This is also introducing OOMs when doing at least audio tests (I don't
>>>>> think these are super relevant) on Raspberry Pi 3B+ running NFS root
>>>>> (probably more relevant):
>>>>>
>>>>> [   64.064256] Unable to handle kernel paging request at virtual address fffffdffc1000000
>>>>>
>>>>> ...
>>>>>
>>>>> [   64.087583] Call trace:
>>>>> [   64.087586]  kmem_cache_free+0x88/0x434 (P)
>>>>> [   64.087598]  skb_free_head+0x9c/0xb8
>>>>> [   64.087608]  skb_release_data+0x120/0x174
>>>>> [   64.087615]  __kfree_skb+0x2c/0x44
>>>>> [   64.087622]  tcp_data_queue+0x948/0xe50
>>>>>
>>>>> Full log:
>>>>>
>>>>>     https://lava.sirena.org.uk/scheduler/job/2341856#L1721
>>>>>
>>>>> Bisection identifies:
>>>>>
>>>>> [fb9a328d30400dbc8b2ea5a57daeb28bedac398b] mm: cma: add cma_alloc_frozen{_compound}()
>>>>>
>>>>> as being the comit that introduces the issue.  Bisect log with links to
>>>>> further test runs:
>>>>
>>>> Hi Mark and Claudiu,
>>>
>>> Thanks for the reports.
>>>
>>>>
>>>> Can you try the patch below to see if it fixes the issue? Basically,
>>>> in cma_release(), count was used to drop page ref and decreased to 0,
>>>> but after the loop, count becomes -1 and __cma_release_frozen()
>>>> is releasing unnecessary pages.
>>>
>>> Oh，sorry for introducing the regression, my previous self-tests were
>>> more focused on the hugetlb part, I should be more careful about this,
>>> and thanks Zi Yan for the quick fix, I will do more check and test for
>>> the non-hugetlb part.
>>>
>>>
>>
>> Based on the cma_debug interface, I performed quick tests to reproduce
>> the issue before Zi's fix. With the fix applied, the crash was resolved,
>> and no other issues were observed during testing.
> 
> It seems that the series is dropped from Andrew’s tree. You probably want
> to send a new version with the fix folded.
> 

OK, thanks for the remind, will do.

> Best Regards,
> Yan, Zi
> 


