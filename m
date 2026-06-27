Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E272C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 02:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2682B6B0088; Fri, 26 Jun 2026 22:02:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1CD6B008A; Fri, 26 Jun 2026 22:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 093436B0092; Fri, 26 Jun 2026 22:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA4946B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 22:02:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 349881A0634
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 02:02:49 +0000 (UTC)
X-FDA: 84924044058.25.C133ED2
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf20.hostedemail.com (Postfix) with ESMTP id B57AE1C0002
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 02:02:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=gjMnZimu;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782525767;
	b=G7P17W6ub4QWMglpWp8NeTc8H4ZKTClt5BbgoTaVK+85ZKYdggvt55sQTLvbx+x6O+C9Zz
	91I7yWXzeISwG8F/PUXlQpUPAGsmecOZHF6ow/QRPvfRUKWHrdMTepY90asAF9rIZmT33s
	01T0KaSw93Ujb9kX5DNVTrqBegXUyQA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782525767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wSo8Q+yLQGdZX1UOIghquAO1yLazKdYABRmFO2rMjFc=;
	b=OeooKVpRx4UmtjvhWRQsSh2WQC6iJJcU1zcWYiCigWSIFIiDKeMJuXrmuvIek5OY7yLZna
	ThORWbaRdtX6uFXVA5dNPJxbe4DiJbbGZ936RAPPPxeajlM6agQJiQv5embFU9vTAHL/Hg
	JCN/DCEgNLXd44cbAtgnWyVaURnFIm8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=gjMnZimu;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=wSo8Q+yLQGdZX1UOIghquAO1yLazKdYABRmFO2rMjFc=;
	b=gjMnZimu8islHmhOjSiPKaopV4mPDV5GIVFK9eHpwb8tSQCsQYzwGkCmDZgOFzk0ZMd4jit9i
	mcOIiLobn3eMFhWyIE6AKjr7/pZEwZzVstj0U+o1ILi9XN76ciTATwOAycElahJMKwR0dwP0lR3
	VKTI7nzJ4WIf19ahhPIVYjc=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gnFv15vQrzLlT9;
	Sat, 27 Jun 2026 09:53:33 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id D12A840572;
	Sat, 27 Jun 2026 10:02:40 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 27 Jun 2026 10:02:39 +0800
Message-ID: <13baa0b0-4b4f-49b2-a7d8-2a0eea63689a@huawei.com>
Date: Sat, 27 Jun 2026 10:02:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: mincore: use walk_page_range_vma() in
 do_mincore()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>, Gregory
 Price <gourry@gourry.net>
CC: Pedro Falcato <pfalcato@suse.de>, Zi Yan <ziy@nvidia.com>, "Liam R.
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	<linux-mm@kvack.org>
References: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
 <20260618092845.3905740-2-wangkefeng.wang@huawei.com>
 <ajPZlxq5z1hyo1kE@pedro-suse>
 <42e167b2-5676-45fd-8f3a-738d2f4f6623@huawei.com>
 <ajP9bQhmvR9OX0VE@pedro-suse>
 <e7244b54-d794-4e46-88e7-69204da2b60d@huawei.com>
 <20260624193852.2a1ac8a187978e4baa75f47e@linux-foundation.org>
 <1b34ac03-edf7-4219-a334-1e7b7292129b@huawei.com>
 <e759c145-f55a-4b23-8aa7-ae0342a7cebb@kernel.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <e759c145-f55a-4b23-8aa7-ae0342a7cebb@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: B57AE1C0002
X-Stat-Signature: 7bihm4bbptb6qucbaju3jfhkpefboira
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782525765-937932
X-HE-Meta: U2FsdGVkX1+7vl7QHKv+s5TQklElc2nXJteDeOFC//3f5TorcRwU0OTAOb9UZ2E9mgIYGiiU0DCGIrVuwdgt54FoPWA+bAVRwCghJ6ef9Nvt9w9pWBop+h5Pzr3m2Sf5QmPJaRZlq0cdptTs7bgoKlPKN8yqL6LhO1+/QVxVJZHAhbmgMyIxpWwaV1OQYRxDj8dQYK44++1PaKw9X6tamIalSnRqQiT+6LQaWelwxBGiH8QlGT99XN2/cF6/sfBvQzWwp6+07AWf9iBm9b2PTSv1E9uZX3BYYPoWABv4YhQpdC0KyOu6J45OnK77V69piRcOqHBcJ7DVX7WXWlxUZJDWd/p30jaGu0B8nU5QRX4cpcdcI4BXq5s6apC+Wgmr9+PGxwwnuLzXrMaqUakWOginLusdCOp5DR1ooREiYE8HHVWfJSW/TFIa+jqpg23ildHenrm6fTDHDlyjziee01EBgRPLtvvVRthK9zzq8xxSohpF/cXoLMdbJNl9Jb90oSn6O3UMLOIqc/JRj1j6ZnaP/MFXU2Nflfw59Td8sHfbKMRMILDR3xJC0wetaxMmJWpsWC3jQ3vgNh1vavo/yJiAsWylSWvphDGk8Y8kMdYt8bexqdXUCQIRhkPxETwlShB/TIoHDp2d37oRzxC81S/X/ozSAakpdGA4gwK0cSu/0mtELIL2U9Q5EmYrbCuzXxMOVllyoYajP0UUTU+28wk9vzNbwODvoJXZj723wk2h66IToxjEVrQgXO8uCJ4Ohob7f2sulIyT/mawh+Z+O+wI4a2lI1Q0zFRf30woDOVkIeeFH2YkfpkAvhQo97hUa5Ng+7ZPt/uRlvt4y85jpwVqbaIJkWiH+YgUIscShZU85K0zmrlHs2+FfngfZeTF2f1eAAsIF/Bq9OX/7at/5effo4FV2jTusszAPuufxp7/5GrUqRGPh3nnIz4zovvm6P55ityusY//fbehvNS
 b23RCTi+
 Qnp9gmOBHcuO2h9qJDetlfzuRlIQT/lir8g5jekOdk2cSsjsoNDPvjtYQdYKlE+PgnF7WDSSnsvmwyQI/39JSmBByT4ppA/M+n6GsrnF2JG2xevVAWKWiUiZ+nB8GCyhKlRU2Z+bKj3n4Qrw+g9bcwoEgYFs1Y80KSJoCDmEeSp6aphjHupPnIV/3UBGFKz3IQrm6BkKCNVn+YfwJkS00WHpnTYPWVUeva6pJYD5kRRcS2hNVh3xRM02YrlcAEPzRA66A59+0yvsqTSjhxnjLrMKdAtnGwlBC6v/5HwNaXI0p9WkFaCOtr/ASahXJX8+5aQBsmddGX4Y6ThZf1d0DYaG1rgHtOruIIypW3msNz7KO7WV/ZbSarTSgLC6ZR4SZMUUttu4ItGJv+PGWzj7xDpNqEn3pj7FkMDgQUNARv7spl10UVtTpNViPgapTwiFRSpGfdDqnhzjDdSoI7Kx47sZcXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/26/2026 11:58 PM, David Hildenbrand (Arm) wrote:
> On 6/26/26 17:21, Kefeng Wang wrote:
>>
>>
>> On 6/25/2026 10:38 AM, Andrew Morton wrote:
>>> On Mon, 22 Jun 2026 11:23:11 +0800 Kefeng Wang <wangkefeng.wang@huawei.com>
>>> wrote:
>>>
>>>>
>>>> Hope Andrew can fix the comments when pickup patches.
>>>
>>> I added this:
>>>
>>> --- a/mm/mincore.c~mm-mincore-use-walk_page_range_vma-in-do_mincore-fix
>>> +++ a/mm/mincore.c
>>> @@ -261,12 +261,7 @@ static long do_mincore(unsigned long add
>>>        }
>>>          /*
>>> -     * walk_page_range_vma() does not call walk_page_test(), which
>>> -     * handles VM_PFNMAP VMA by invoking ->pte_hole() to skip the
>>> -     * page table walk. Without this check, PFNMAP PTEs would be
>>> -     * treated as present by mincore_pte_range(), changing the returned
>>> -     * residency status from the historical "not resident" to "resident".
>>> -     * Handle VM_PFNMAP explicitly to preserve the original behavior.
>>> +     * mincore historically reports PFNMAP mappings as non-resident.
>>>         */
>>>        if (vma->vm_flags & VM_PFNMAP) {
>>>            __mincore_unmapped_range(addr, end, vma, vec);
>>> _
>>>
>>
>> Thanks.
>>
>>>
>>> Sashiko is OK with your patchset, but it might have found four(!)
>>> pre-existing issues:
>>>
>>>      https://sashiko.dev/#/patchset/20260618092845.3905740-1-
>>> wangkefeng.wang@huawei.com
>>>
>>
>> Sorry for the late, this is pre-existing issue, I am not familiar with
>> zone devices, so just focus on my changes and the subsequent
>> changes related to mincore.. After a quick review, most of them are not
>> issues based on my understanding.
>>
>> + CC Alistair and Gregroy for migrate_device.c, also Zi could you help
>> to check it?
>>
>> 1. mlock.c, ACTION_AGAIN
>> 2. migrate_device.c, goto again array overrun / double counting
>> 3. migrate_device.c, softleaf_to_folio VM_WARN
>> 4. migrate_device.c, pte_pfn / pte_dirty on non-present PTE
>>
>> I think issue 4 is real issue, a quick fix is
>>
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 554754eb26ff..3ccc4fc1015c 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -401,7 +401,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>                          bool anon_exclusive;
>>                          pte_t swp_pte;
>>
>> -                       flush_cache_page(vma, addr, pte_pfn(pte));
>> +                       if (pte_present(pte))
>> +                               flush_cache_page(vma, addr, pte_pfn(pte));
>>                          anon_exclusive = folio_test_anon(folio) &&
>>                                            PageAnonExclusive(page);
> 
> That looks reasonable.
> 
>>                          if (anon_exclusive) {
>> @@ -422,8 +423,12 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>                          migrate->cpages++;
>>
>>                          /* Set the dirty flag on the folio now the pte is gone. */
>> -                       if (pte_dirty(pte))
>> +                       if (pte_present(pte)) {
>> +                               if (pte_dirty(pte))
>> +                                       folio_mark_dirty(folio);
>> +                       } else if (softleaf_is_device_private_write(entry)) {
>>                                  folio_mark_dirty(folio);
>> +                       }
> 
> The pte_presnt() check looks reasonable. But dirty handling is really
> responsibility of the device side user.
> 
> So likely just
> 
> if (pte_present(pte) && pte_dirty(pte))
> 	folio_mark_dirty(folio);
> 

Got it， I will send a separate fix if no more comments, thanks.


