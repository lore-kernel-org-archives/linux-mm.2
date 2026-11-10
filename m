Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 477F7606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 06:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=XmQ5gUTA
Received: by kanga.kvack.org (Postfix)
	id 3772F6B00EF; Tue, 10 Nov 2026 01:23:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3013A6B05B0; Tue, 10 Nov 2026 01:23:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D09E6B05B1; Tue, 10 Nov 2026 01:23:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E58466B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:23:57 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7BA7FA05F3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:23:57 +0000 (UTC)
X-FDA: 85418218914.11.FC8848A
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf21.hostedemail.com (Postfix) with ESMTP id AD9971C0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:23:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XmQ5gUTA;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794291836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nKkhdqVD8ZDaQWaWgeabMl+KwyqTWSczMhRw1w7SJCA=;
	b=zmBzkkyOEzX1ZhGSp8P+gxr2H4fV3sOZKc8SBjKlOJixZbfms/cjIz93OdIz8EzcbeCVB4
	3qCJVsaP5h34UAT+/P1nV72wBaMM0c6wzUSt8zydUDrzt+XaVkaccGSmT0Mh5VCtclGW7s
	5FQtdf7bN6c0xIIovAWdqwGSjovTbqc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794291836;
	b=2rE9tFLXVemTkFKbZ5U6zLpyg2+0RwzC9dTyxvkGjHk+qqrc+hqoMuqr7xFUEZvZrmK26t
	2t/7N8t62n6vKgX6W5f/UWVko0zpwSxThITWw2hUcAUOm6uwxUxZd3Xo0hlONuMPFOL7dg
	Ls6Efx7IixsDUyODH3od8ok6G6ySYl4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XmQ5gUTA;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794291829; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=nKkhdqVD8ZDaQWaWgeabMl+KwyqTWSczMhRw1w7SJCA=;
	b=XmQ5gUTAcawS8eOOxFMh2grF5l+4oZCXDueJwy3oadClQTJ0QTICG/N+JaZLdH4RF+5j5nvqyl/F38jyLnPjztL6Hbo02n/TEklI3UQuOMjCUjq6KDP3NCbluONtBCLwVbjcIPNfzZIRg0T3gSzLYiZxwfGrHnH9i4gS/XZWytk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XEUDJQw_1794291827;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEUDJQw_1794291827 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 14:23:48 +0800
Message-ID: <86856d64-593e-4d10-ad40-c0c4f056332f@linux.alibaba.com>
Date: Tue, 10 Nov 2026 14:23:46 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
From: Baolin Wang <baolin.wang@linux.alibaba.com>
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
 <3c0185d0-ed2c-458e-bbcc-cd35070ec743@linux.alibaba.com>
In-Reply-To: <3c0185d0-ed2c-458e-bbcc-cd35070ec743@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: jgqogfehj8j65drqbeckgbd8qj55ejjq
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: AD9971C0005
X-Rspam-User: 
X-HE-Tag: 1794291834-816868
X-HE-Meta: U2FsdGVkX19W0emFRUCPC4ZY352Qei7sFswgATfLqkc3gTtngy2qu7rejHGheHxvIV2qRED8c2IsOdRoz4DJ2BVKdiPG543jKHlz2/PuIyeGhPJzFJTNj0uoTS8JvB/E3aGKmcQyfkCB4fJCJSPuMZ0u646FGp6KDOkF/WQv+v1BwzWtmi8JfAhBJxOHEc6WAaB8ssZ69vVQKAZYjIrrlUAQiymUm4gF4a4NPP9UcA+87/kzPTtop4ooiacJr+CMO/7aENpi9RhM3D3H94qx3quCduW5ratR8/p6J/3I7rkQOy+q5qcHwMXuRQnVKc7A3G1dnuLmjdF8DCNEOdUFKjuwHXIYTO+64uKnGpcxPurC/zW83mMS/REkcAgI5Oa8eJHr789GjLKGsWNJ2+RM79nzfgM3wV2RQ87LkoNTYmqfV6FStg6DRqtOcValJhcx8Zpq26BAQpmaKTzNBVGtyNc6YfSFi7MeHnsV09Oxfw1QY3YrwcTE2l6mjNwrxQoJTagog3Nimu22jfYDkOKvp3yiqDDtqGKs2Y31cHjifQNljr0Fo6lR2XcbiOp5/zbah+wk6hBCA/5Z1YJcP3mJmURdnTpvYxslYcl7xNVhkQlvgcn6DPK/lhtQQGMUcn0A8/hLTfVopXJHUP66Ow2eU8xK2fMhTkkbFySlIBzksL3xX8x/V9scg06N3xLfzl79nFie7eT7HUcOuyButBiKdJExdtsjbgnRjKVqP3WDgA6EUuXOavX7+rN5bduQS7Iwg0V+uvUHcqPpHKFp/Pa2MfwNomiML2YWuzA9iXLJyG+mVdkUEuJMRGVNydzKwofdmMeQRBLLjaoByFswXVbRSMcrB1yOdqXpLsjt+uvonDRhIM9MygqJLPuoP1DQOEy/YjmiQcg8vHg/0ctxcziOE+YGcVTIytHcLtDLrTq6p4n9s9YuGs9glicZZ/g9oDN17k3U+HfHumYFwZW5Mno
 VU3cJDvK
 nhaXABi/4nWkp7P8znlWjfBUOYnT0K1gJM5SfmfVkMZI7f3fJ3l/Zwf8m05sGgmDY3ByrzBHOolQiBCoZhF+tNZd3CrP8gdH1+DpB6uAyk5wiYcmMz+6KpDpRQlbKTz26eyRzwI7Alo4BtPLK6d474wxsHdJZruAzVE2eImHJLscV9CGeKFEvJWTAibNuA9CkC4/q0bBPNBYGml/O9US5gVcIRFkz8VGZ1pDrP+RyrQ/aqYd0uMRokywqSGRrqsi6BvUb8d6c+uFCgbGOBQcMkO+yog1zvClCraDXUBvpfsU3fR+fVd5rNPMEorSyloMrK6bfL4AkW3vsJ6g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Barry,

On 11/6/26 9:56 PM, Baolin Wang wrote:
> 
> 
> On 11/6/26 5:56 PM, Barry Song wrote:
>> On Fri, Nov 6, 2026 at 4:55 PM Baolin Wang
>> <baolin.wang@linux.alibaba.com> wrote:
>> [...]
>>>>>> Ouch ... one thing I missed ... what about order-0 reclaim?
>>>>>>
>>>>>> shrink_folio_list() only sets TTU_SYNC for large folio, so can't 
>>>>>> we still
>>>>>> hit the same race there?
>>>>>
>>>>> Thanks Lance. But this matches the purpose of the TTU_SYNC flag, which
>>>>> is used to avoid racy checks with PVMW_SYNC. If no TTU_SYNC flag is 
>>>>> set,
>>>>> it means the caller can tolerate some racy checks.
>>>>>
>>>>> For this case, I think we should set TTU_SYNC unconditionally in
>>>>> shrink_folio_list(). Barry, what do you think?
>>>>
>>>> Baolin, thanks for reaching out to me. I added that flag
>>>> mainly for large folios.
>>>>
>>>> I observed cases where PTEs for large folios are partially
>>>> cleared during certain transition states, for example, when
>>>> PTEs are cleared before being modified:
>>>>
>>>> pte = ptep_get_and_clear();
>>>> pte modification;
>>>> set_pte_at();
>>>>
>>>> In such cases, page_vma_mapped_walk() skips the empty
>>>> entries and starts from the next valid one.
>>>>
>>>> This may result in partially unmapping PTEs for large folios
>>>> and trigger unexpected folio splits. At the time, I was
>>>> particularly concerned about unnecessary folio splitting,
>>>> so my focus was mainly on large folios.
>>>
>>> Thanks for the information.
>>>
>>>> However, I also noticed that a similar race can occur with
>>>> small folios. In that case, the folio may simply remain
>>>> unreclaimed by the reclamation path.
>>>>
>>>> However, my main concern at the time was avoiding
>>>> unnecessary folio splits.
>>>>
>>>> Your new race also seems to amplify the same situation.
>>>> However, I don't think this problem necessarily depends on
>>>> the commit you mentioned. It has been around for a long time.
>>>
>>> Agree.
>>>
>>>> If the concern is reclaim failure, I agree that there is no
>>>> fundamental difference between large folios and small folios.
>>>
>>> OK. And I did a quick measurement to reclaim anon and file folios via
>>> the memory.reclaim interface.
>>>
>>>   From test results, reclaiming 1G small anonymous folios (using zram as
>>> swap) shows no significant performance change. However, reclaiming 1G
>>> mapped clean small file folios does show an observable regression if the
>>> TTU_SYNC flag is set.
>>>
>>> Without TTU_SYNC for small folios:
>>> time echo 1G > /sys/fs/cgroup/test/memory.reclaim
>>> real    0m0.178s
>>> user    0m0.000s
>>> sys     0m0.178s
>>>
>>> With TTU_SYNC for small folios:
>>> real    0m0.315s
>>> user    0m0.000s
>>> sys     0m0.314s
>>>
>>> So for the current patch, I'd prefer to keep things as is: only sync
>>> when TTU_SYNC is set. Without setting the TTU_SYNC flag, keep the
>>> original logic, meaning the caller can tolerate some racy checks.
>>>
>>> Any other thoughts?
>>
>> I'm still struggling to understand where the regression comes
>> from. You're doing echo 1G > /sys/fs/cgroup/test/memory.reclaim
>> without the concurrent CPU 1 (MADV_DONTNEED) operation that
>> causes the race.
>>
>> so the regression actually comes from other places, maybe here?
> 
> Yes, I think so. But I haven't had time to dig into how this affects my 
> tests yet. I'll dig into this later.

Sorry for the rough quick measurement last Friday :(.

I found the first memory.reclaim() trigger has high variance because 
folio_check_references() activates folios. After the folios' reference 
flag are consumed, memory.reclaim() shows no regression with or without 
the TTU_SYNC flag, and the data is relatively stable.

However, my testing is simple and doesn't cover concurrent stress 
scenarios. Whether to set the TTU_SYNC flag for small folios can be 
discussed in a separate patch, along with how to evaluate the impact.

