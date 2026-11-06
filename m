Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95EF5606D838
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=xIU7lhrU
Received: by kanga.kvack.org (Postfix)
	id B47386B05B9; Fri,  6 Nov 2026 08:56:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF8136B05BA; Fri,  6 Nov 2026 08:56:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10306B05BB; Fri,  6 Nov 2026 08:56:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 779776B05B9
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:56:44 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 900B680D61
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:56:43 +0000 (UTC)
X-FDA: 85404844686.22.86C54A5
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2191C140005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:56:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xIU7lhrU;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793973402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UkYVC6JgbebV6njVGe6gs4FA7AO+9hyOeWdBXzF6uKs=;
	b=KZ0xFmEb6fSDVXWJutnDbuyYx1sM4AMSBL+G4uE3qzRkR+6Q2eKDeRqpfs9rsSpZW7NeN9
	KV8O/hrPjgQYk3ZBXQt3EXzkkZSKqC2VwwWNf14xoY/ajknq9eQHH3GDQxFsgxaC5RTZ6P
	G81r4gS1wL6Lg4+S9kmaW6ReD/BX/xw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793973402;
	b=zSFuCCSRPqb0hd29mf/GLxaJbiwCjYTczmKXU+jg1HWcGy6gzZIpkIil7Ai37E7DLRLFr7
	/j2Bc2FbIV5AEBMBp1aby86NrEzDrlgMVAtfrReRBtgP+n0jCFRGpzvCiS1IzBCcYH5LCh
	QlS964ngAs66nhyO7rOXBtBmia3oMI0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xIU7lhrU;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793973390; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UkYVC6JgbebV6njVGe6gs4FA7AO+9hyOeWdBXzF6uKs=;
	b=xIU7lhrUf4n/Ovllgowwe0ipKu+7m90Zmj/rkmNVjs1TZBG2oG7Kr4rK2lbSo+5T09DntMGy8BJAV2lVa0eY3k76hk1IOI/HteumkaUAUCBYXRxCJfipAb1hZApyaIYUhSP3zy89ez2vi5y7rrV2vVESVBkH7lHZELl9pTOyZ/4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XEBpgb8_1793973386;
Received: from 30.251.68.229(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEBpgb8_1793973386 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 21:56:27 +0800
Message-ID: <3c0185d0-ed2c-458e-bbcc-cd35070ec743@linux.alibaba.com>
Date: Fri, 6 Nov 2026 21:56:26 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
To: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, qi.zheng@linux.dev,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
 <20261105045406.39871-1-lance.yang@linux.dev>
 <0ddaf336-7cb7-4e83-af2c-f60d23f7aafd@linux.dev>
 <f7bd740e-1328-473e-96f5-89658a08d514@linux.alibaba.com>
 <CAGsJ_4zHtv7hBCaW=wdfiM7yA4OJS7pcFomSo22bEzWHizYAXQ@mail.gmail.com>
 <453e2c18-4e79-4db2-b565-1af881925f08@linux.alibaba.com>
 <CAGsJ_4zLiwYf6LM_BWoZyiYWxvW2H_siZ0QC7FmEHazF_fLa6g@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4zLiwYf6LM_BWoZyiYWxvW2H_siZ0QC7FmEHazF_fLa6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qojdu9dy6xmgrgi4nqunjihnpdap5pr9
X-Rspam-User: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2191C140005
X-HE-Tag: 1793973397-285722
X-HE-Meta: U2FsdGVkX18XhQ8tJXDWuzurAXu59dlcwcJ6TpZMwFINixczOFLmG75pwN30auFNjHMqznnu68kWy7a4MXMW4qXmbmuZQaTw/aoa0SEx8JGh5HUyDtTi+9aVNcHsZW/CncwM5X7uGJMYGXrqMqWd/IwQ88lWoF8paxMdgOdGSoNSLVdaeDJD4H7HnCS/v0QkasoLiWR3hpLp+llskY4MWDw1LtNK+s13gZR/ivjuEUKnQDFInKfYBO4SkQNF3WoFCYOaBYl8o7LzA03vosok3hzGxHrJZMhlWHUgvNrv3bk7moazC7Ft56nvrk5hWBrio2GTn4NIqYg9Ttpz/GLj2bKpDzopzcK3ls79PS/C2EpLNNPBMOv/kDqJZwRZj06ymQHqeshCFRO6/mV2t5CVh8pxhP1UrqkVdabCBbwOhIMWhqBV0gVJmChboMZjSJDkPHg3IhfZOeuvM2x8fGhNJxz5zXcjYlrzWw7UKaYhsKI0ih6/bUwY5n5tuFOoWAgOuUyxj0DBPpAGKOKenhMYEwSKShsmOCfpGORt08QgGOB/fHj5xGdYLO57nDKjXKzs0F9RmPLGmOG67YJDz7Ln9behAwa2LOYjvDVAmEARBtjHRYP3MXHkUQjUlfoF3B/8SoTYK8mlEu6p2eqTt2BeGbkYkCBMLeTIjN2u/HgQnCkRjHFvLTLaRtMjEcHhrOTF9bjsXnFZPMyatk8MWTCbeZj5yJdiqlb0+wxq+bYIRk48N5Zzgq5qFopku2ozjHigRuO4tflXPgxgUj7ahtpj8vPLO9740ZmvdWLhvznsRDZbHwZKZI9+OCs3/ht5Qa7Bv8hEANdfYzGiGr1c1ICd6BaYjOurMp3qEGbhd2WprdsjAmgkKpU6wAwEGsB13IxMAMKwblrBOU0nMG+hCInftQu5CDEFt2cDZNO2ghJQ4MEFDqyt4IN2/oviwnRFTz/f5UBzmn0Y2hfTgENiete
 /LUD6avN
 KvpoNx/6l4tp1tUdV+gwvwUwaes71oLZGgrM6kYUF5iZej1p3IxOJ2SvsypyrKdmDmZvbthO8FUmWI21hImpJd72KqxqUIHScr+5HFgowOuhyYUsUVwt1Y6vD9I3zVBNzUpaluOkuZUsmc10VlqgXlXHXaXVGfFoOhtMA5OdP0wbwtBKZ1FOLwPJnm2LVV7UIPpvCRAqbHKv58ueyh8Sc2k/KSyeMby4bMWWGpIczMfFWgL38I0UAyPKgOw7hUsFn0CW/b2pvRykBcna21v7m4qAkNFVylR9qhtB58RDCLwdmLURSUxvR3FJ5MXwJl32+g7SHMqaGRqddTFI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/6/26 5:56 PM, Barry Song wrote:
> On Fri, Nov 6, 2026 at 4:55 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
> [...]
>>>>> Ouch ... one thing I missed ... what about order-0 reclaim?
>>>>>
>>>>> shrink_folio_list() only sets TTU_SYNC for large folio, so can't we still
>>>>> hit the same race there?
>>>>
>>>> Thanks Lance. But this matches the purpose of the TTU_SYNC flag, which
>>>> is used to avoid racy checks with PVMW_SYNC. If no TTU_SYNC flag is set,
>>>> it means the caller can tolerate some racy checks.
>>>>
>>>> For this case, I think we should set TTU_SYNC unconditionally in
>>>> shrink_folio_list(). Barry, what do you think?
>>>
>>> Baolin, thanks for reaching out to me. I added that flag
>>> mainly for large folios.
>>>
>>> I observed cases where PTEs for large folios are partially
>>> cleared during certain transition states, for example, when
>>> PTEs are cleared before being modified:
>>>
>>> pte = ptep_get_and_clear();
>>> pte modification;
>>> set_pte_at();
>>>
>>> In such cases, page_vma_mapped_walk() skips the empty
>>> entries and starts from the next valid one.
>>>
>>> This may result in partially unmapping PTEs for large folios
>>> and trigger unexpected folio splits. At the time, I was
>>> particularly concerned about unnecessary folio splitting,
>>> so my focus was mainly on large folios.
>>
>> Thanks for the information.
>>
>>> However, I also noticed that a similar race can occur with
>>> small folios. In that case, the folio may simply remain
>>> unreclaimed by the reclamation path.
>>>
>>> However, my main concern at the time was avoiding
>>> unnecessary folio splits.
>>>
>>> Your new race also seems to amplify the same situation.
>>> However, I don't think this problem necessarily depends on
>>> the commit you mentioned. It has been around for a long time.
>>
>> Agree.
>>
>>> If the concern is reclaim failure, I agree that there is no
>>> fundamental difference between large folios and small folios.
>>
>> OK. And I did a quick measurement to reclaim anon and file folios via
>> the memory.reclaim interface.
>>
>>   From test results, reclaiming 1G small anonymous folios (using zram as
>> swap) shows no significant performance change. However, reclaiming 1G
>> mapped clean small file folios does show an observable regression if the
>> TTU_SYNC flag is set.
>>
>> Without TTU_SYNC for small folios:
>> time echo 1G > /sys/fs/cgroup/test/memory.reclaim
>> real    0m0.178s
>> user    0m0.000s
>> sys     0m0.178s
>>
>> With TTU_SYNC for small folios:
>> real    0m0.315s
>> user    0m0.000s
>> sys     0m0.314s
>>
>> So for the current patch, I'd prefer to keep things as is: only sync
>> when TTU_SYNC is set. Without setting the TTU_SYNC flag, keep the
>> original logic, meaning the caller can tolerate some racy checks.
>>
>> Any other thoughts?
> 
> I'm still struggling to understand where the regression comes
> from. You're doing echo 1G > /sys/fs/cgroup/test/memory.reclaim
> without the concurrent CPU 1 (MADV_DONTNEED) operation that
> causes the race.
> 
> so the regression actually comes from other places, maybe here?

Yes, I think so. But I haven't had time to dig into how this affects my 
tests yet. I'll dig into this later.

