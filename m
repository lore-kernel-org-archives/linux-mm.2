Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE847CCD1A5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 00:51:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368538E0007; Tue, 21 Oct 2025 20:51:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318BA8E0002; Tue, 21 Oct 2025 20:51:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2069C8E0007; Tue, 21 Oct 2025 20:51:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BC318E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:51:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AAEA5C06DF
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:51:51 +0000 (UTC)
X-FDA: 84023922822.04.A499498
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7CAD5C0005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:51:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=g9FX1901;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761094310; a=rsa-sha256;
	cv=none;
	b=tG8YlSBEBBhJXtIFQscnp/mIwn91gq+yOCynMX0lZuTIrX2Eu4f6w1At0ZtdF0zDwzLbD/
	QfEoZXDpeHGnOF8m2Cnkxt+nol6geBJ8JLXnoFM8VsN9vATCIMkrKOyU8nPZB+hNFs2QXp
	b+lqqtGZOCdana+CgEYeHpb+GHrMEjk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=g9FX1901;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761094310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NhNODGEGAf1PMqtVEQW9+WwQAwcAtyxiYl+I3YMmWwU=;
	b=j9vn+yCr1A1tSC9YGEet+jxoVX6M30FN2odDTm7gCp3F9VilRJdwGQGZRnTJc/5BsiZDSu
	+6btwuIHCtw30QkA3Vzr64zzHLjliKR9ErBa/4Qk2ErAdDkbGMebb/ojAUUuJmDoMpRdam
	DJZOyEmLMt5Kt9QJbMEHdpNJLGwwGBA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NhNODGEGAf1PMqtVEQW9+WwQAwcAtyxiYl+I3YMmWwU=;
	b=g9FX1901rtMnwqzXkvwB30GdrOlb4EnNVKWQYb+lUSv1B52ipXGKILnzjIoZLauuqIb+5O15E
	BYNtWQYEWPAKwbpBn/M/bElA4e3EqamFQl65RP70NYo3cfpWKiH1Gu8UriIxDSkP8ynRGiAZvnI
	reH0E/gYofaANOfwCupYllc=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4crrFH5S4MznTW3;
	Wed, 22 Oct 2025 08:50:59 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 22C851A0188;
	Wed, 22 Oct 2025 08:51:41 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 08:51:40 +0800
Message-ID: <f9f19e32-f14b-4835-b804-6e8a60927d04@huawei.com>
Date: Wed, 22 Oct 2025 08:51:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] mm: mprotect: convert to folio_needs_prot_numa()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Hildenbrand
	<david@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>, Zi Yan
	<ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>
References: <f1d3d11b-6ac8-4747-b2e7-952d4fc3e09b@lucifer.local>
 <719c8df8-b4c9-4a6a-bedf-d62becdb09d2@redhat.com>
 <759578b3-d582-48cc-90af-491210ecd90f@lucifer.local>
 <3ee89484-9cdf-4c50-a5db-79b9f2ca6886@huawei.com>
 <967f61db-0ee3-4257-a44e-69ef15ced012@redhat.com>
 <944fe458-6391-4cb9-8719-dbaf69f3958d@lucifer.local>
 <72e2f6b9-d241-43aa-9a3b-2f13c763bef8@lucifer.local>
 <3554c866-5087-4beb-8d63-6a3cea02d431@huawei.com>
 <16ca4c3d-7c18-4cb9-bc04-d2eccb5d9b67@lucifer.local>
 <5703e7e6-f037-4b4d-be74-8c256e7a3e10@redhat.com>
 <36e1f03d-1acf-4a2f-aa29-0bc0c14ee1fd@lucifer.local>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <36e1f03d-1acf-4a2f-aa29-0bc0c14ee1fd@lucifer.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: 9uiwh43yr6i7hoq186hyh8cdmr8x5xdz
X-Rspamd-Queue-Id: 7CAD5C0005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761094307-819915
X-HE-Meta: U2FsdGVkX1/Q2kpjadrw4V+qTWb0hgCW/IDT6Q6q3tegt1qne3NtWBv5RBo0+ZFaEwawX1Yz9MRQnPziDNwPUZKXiEbKIOPbLzeEWaQ02EY83UfxakCn4VgZKFGmloIjAfMqqq6eTH7HF6kMbJkjTIL5X14UM3BOL+TKvWWAYpmtAJlzdaYa3hiHkTWZZfuOlF2cJol19Dy8oqE7mW9X5uzP1Ul1dJAAYmq9Vx8uNEMHTIjGjVyxd20NbM4jCKCbNgFnshBa8o6yUSgoWGiWaJdrJ6k8S47k6Co0seLPqtWdMv8aVuSy8xrm/I4ACbH74kKBtOcKCWgWbV2fasnTQWhjKzy4YQQZJYQgkyCjGHKrlqVpXz+UkOtfsmNMqoCUNceFfnrbY0KJWmoL1y27P1dKGZDXpVysiNew1MntttUZ0S5FSXxQUpNq5F6AZN2UVoHlUNgoz+9FMEfB0aO1PGHUwU86axw8Lgsme/NUfDFlZ3CILguJUTtMTFbaf6sjWYrIZYmW/MGfiMWk0zmZWexTmCwroVvkCJVrIGD5Ru3eM9v+Jd6+72zSo8j/MyfA99zpchIGytrKaBy+AYaVNDm8ODzg1RRlE1SuGu0QytOllW+wPgBCPa+NgE8jBFZZudhLLQrbnNxcdJRG0Yspenv7utF9zwfzMF4c06RQVCUczeGn5FRPP3pD/NEINqZAhcuiLWanzngMXJHkiS+11S9go5WY8I2BLCz4gDw7ozWciOGuXJvkuHycDlfXw3G1EQta/1H4yoOO8BUxn9Ul9T54rUw5cKUQS4/ypsDgt2f2Ghym77CRw4BPBEcWrCqaGNoxoBgraMQRVTF9MwgIM/SaoF2NuO2NI9J4+lF/09ofhUsWWS8p4kwHABR3OXAXRC7uIjzZB/DlNbYiMRjCh4OoF+l5iXjTqqfl4LFz6LUQQtroXmd0XeenQpLJRU62pyiavKw4/BJxKIvIrjB
 1q5Q8xAR
 qfDGzLvDszIl7S1+ODgXnQ2E6wuvkjTzkZk8xhycz5sJz1eCHbdSvrAvaqVkG/ugzEtXA/sYr3CKEnJh7vbxRy8hWE/CJd4/Ur/vB0xpMQNoxBIeOP6NwImGeK4hdUr6sdG+XI0R61hO4+kaf6kuz1WzK5BR2zI44S5EOFJtYtAnexc7odNfxPBAOJjSWhKi7n1z3yBKRxPw9wdLoadhID4NpgajOa8dr+Mx/IDGF2W7hLZ8+hXCmPU0OfnbBEv+FXsNrUc3qEyiPIQavBN6/RDc1Is7MH2QAa3Ftf4sH1Jj2PFjREl2qwDYXClAVFJ8B7jn8QQJkwV60j5NXxam/+u9tae5XFguCtbfogRZSjKCLXRQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/22 0:36, Lorenzo Stoakes wrote:
> On Tue, Oct 21, 2025 at 05:01:30PM +0200, David Hildenbrand wrote:
>> On 21.10.25 16:56, Lorenzo Stoakes wrote:
>>> On Tue, Oct 21, 2025 at 08:54:08PM +0800, Kefeng Wang wrote:
>>>>
>>>>
>>>> On 2025/10/21 17:45, Lorenzo Stoakes wrote:
>>>>> On Tue, Oct 21, 2025 at 10:25:08AM +0100, Lorenzo Stoakes wrote:
>>>>>> On Tue, Oct 21, 2025 at 11:13:32AM +0200, David Hildenbrand wrote:
>>>>>>> On 21.10.25 10:41, Kefeng Wang wrote:
>>>>>>>> Maybe folio_needs_protnone_mapping()?
>>>>>>>
>>>>>>> I think prot_numa should be in the name one way or the other, because we
>>>>>>> also have ordinary PROT_NONE unrealted to NUMA faults.
>>>>>>
>>>>>> folio_can_map_prot_numa() semes to me to be the best choice.
>>>>>>
>>>>>
>>>>> I don't want to hold up the series so if you guys feel strongly, leave it
>>>>> as-is. But this reads better to me.
>>>>
>>>> Let's keep things as-is for now.
>>>
>>> It'd be nice to have an argument as to why (I did say if you guys had
>>> strong opinions...), but never mind.
>>>
>>
>> folio_can_map_prot_numa() works for me, so we can just use that and call it
>> a day :)
> 
> Thanks!
> 
> Kefeng - Since we need a respin anyway, and if you don't have any specific,
> strong, objection to this, can we just change the function name to this please?
> 

Sure, will adjust the naming.

Thanks

> Cheers, Lorenzo
> 


