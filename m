Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C41BC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 07:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CBA26B0088; Fri,  8 Aug 2025 03:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A35C6B0089; Fri,  8 Aug 2025 03:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DFB46B0093; Fri,  8 Aug 2025 03:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7EEC06B0088
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:57:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34F9D1DEE5D
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:57:03 +0000 (UTC)
X-FDA: 83752834326.26.6896CBB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 69BD140008
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:57:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754639821; a=rsa-sha256;
	cv=none;
	b=mHsElM0lH4iSQLQi1uEd9f8s0VDU01Vr/vX5rdM+VMUcZFbs/LE6RZLsa8hdlekZan4wdp
	Lychx6DuCA14RN5lAh/qh8u5O0mMQPULLvZHphqCj3TPW16xGpkOUC2KwSRtEXxceDp8Rf
	TvP04t2bbCnRdB0+Qfusp+c6ovKPY+E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754639821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h2hWN46nCgI1fh+v1S+lgdTjz+PlfGcgFVExXXoasGo=;
	b=P+RoqliSLqBPd1Cm2333FivCimr3SDXISgVZd3vcKTXCkOF1SSQ4ZrW+8uTyLQ969fkJJC
	I5PYqSZjSG6SAiiX6fo5nXUeSphs80fdK19ewykalXnPUfOgTRHkGmhZhyFbQSyX11OA9k
	nrZoZ3alcYUGTQH4XSTc7rvMdbVoN28=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F3F016F8;
	Fri,  8 Aug 2025 00:56:52 -0700 (PDT)
Received: from [10.57.88.69] (unknown [10.57.88.69])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F18B3F738;
	Fri,  8 Aug 2025 00:56:58 -0700 (PDT)
Message-ID: <8391c672-1123-4499-8d28-a731f2d88a9e@arm.com>
Date: Fri, 8 Aug 2025 08:56:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
Content-Language: en-GB
To: David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
 <158e6422-fc82-4d6c-a442-2ebe956a66da@redhat.com>
 <3fc75720-8da7-4f6c-bdce-1e1280b8e28f@lucifer.local>
 <6870e24f-dda6-421c-8df8-58294927b62d@arm.com>
 <ae01c6bc-019a-4263-8083-8ab073e72729@lucifer.local>
 <303b1764-6471-421f-b4c3-6a2585cee2ae@arm.com>
 <b0d257a4-a37d-41da-92f9-4d1c0a11c30c@redhat.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <b0d257a4-a37d-41da-92f9-4d1c0a11c30c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 69BD140008
X-Stat-Signature: p8jkiuh18pbnowmu88ra5oj1o7gpg6p6
X-HE-Tag: 1754639821-73284
X-HE-Meta: U2FsdGVkX1/nfjJuLAseKeIH/QiazcPSoTe6hN0QPEPM6r1O2ljzIX24hyhbft1ihkqIGiJ9rOZeEOfJHBb1VIvf6sr/08mX1terssgakBnDsLF4UFGgfZczsyOJiQVvSX/lMNK7CGm2bJTOnS2d0xs2wlhqFAkq3LL+1gm5VbC6DbQEIzKcAR+v6sa2tjQJnzdbMyjXByrPhytZF7xz0VKzQMhKGfVnVlq/obqop+58nMrs1aSnFsmgpWHM02lfHfpafKa8/rhvD950ME20DJX+VG2V58ODXNScUFC+kpyVpsXfoBpX6DuP1LsUfbZlIQRw3eNT57pCzoyjZuVTwn9fSOP+twOtkp2LoZLAjqLrOXY+1wMWtXFmXmmlwMorc6jiHtQZQBb8oT40nUDnGSPeS6ghbbd2HVjikGAp2C/p1LoEQ311GbZQwliWGNPdjcBPh7h6BUx7Jdh5wlYsafPFuSu5nAdAW/jWFLUaIGFv6IWrbRBK5ZbZSnZOqxHARWQGql+F/pHhNFTRMFK57zvJW78lJASeTKM3k/Ly4SmBYP9t1m1FVrOJ5YxB7AVqQ2Q4lz/OHucgrmreGkTET7ewQHqPWqiLOB2Pr82sJIcoz4ql5Gb7PXTguXfPn4siIEe7T8j/4HQD91DsmTigvyrAwlpilBn/cs7xAvkbx1W+DenjNKjNCssW+z5hS6bWDbxwJCCYqOd/1Tjl8nmkzVwr660P/WwG382vgt5doMUcdS5pdZ8UEodsV9lfP/jKXeSkX7VBgpJawOr6vzgGh1heocYnahqh3BSljQMoIsDOYe4P0DsuibpVWputwb0QMDx1E/naF2jXDnKNqRMFec/SrrQET0XZIYrOS7E4fNKAajfREgWRVyeLfpi7APIvilEtOpsPdiUx5CZccGlp9qAOja4+ObRE+Tr0/3FhXnKEKmdYuQeWXQzfbtxClAfByRYQWVihcJWFNls+jAe
 V1ahEwRs
 JGvfeP28R6YWGl3qaARvVCQ3kHgUv3S8Mtocz10Tsy47fJqGY35dUWyVZU4ZHYYQzHuVLs8jKavLwTtmLl131EU1/Fc2ZuIukxyUy5Zd8HlIrCoOpk29zKmqjptGPEzccj2S4vjJFzZSqcnl6ZpCTvTs3hoxRBIuxRe1QO4XBakFQjjI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/08/2025 08:45, David Hildenbrand wrote:
>>
>> Not sure if some sleep has changed your mind on what "hint" means? I'm pretty
>> sure David named this function, but for me the name makes sense. The arch is
>> saying "I know that the pte batch is at least N ptes. It's up to you if you use
>> that information. I'll still work correctly if you ignore it".
> 
> The last one is the important bit I think.
> 
>>
>> For me, your interpretation of 'the most number of PTEs that _might_ coalesce'
>> would be a guess, not a hint.
> 
> I'm not a native speaker, so I'll let both of you figure that out. To me it
> makes sense as well ... but well, I was involved when creating that function. :)
> 
>>
>>>
>>> I understand the con PTE bit is a 'hint' but as I recall you saying at
>>> LSF/MM 'modern CPUs take the hint'. Which presumably is where this comes
>>> from, but that's kinda deceptive.
>>>
>>> Anyway the reason I was emphatic here is on the basis that I believe I had
>>> this explained to met his way, which obviously I or whoever it was (don't
>>> recall) must have misunderstood. Or perhaps I hallucinated it... :)
>>
>> FWIW, this is the documentation for the function:
>>
>> /**
>>   * pte_batch_hint - Number of pages that can be added to batch without scanning.
>>   * @ptep: Page table pointer for the entry.
>>   * @pte: Page table entry.
>>   *
>>   * Some architectures know that a set of contiguous ptes all map the same
>>   * contiguous memory with the same permissions. In this case, it can provide a
>>   * hint to aid pte batching without the core code needing to scan every pte.
>>   *
>>   * An architecture implementation may ignore the PTE accessed state. Further,
>>   * the dirty state must apply atomically to all the PTEs described by the hint.
>>   *
>>   * May be overridden by the architecture, else pte_batch_hint is always 1.
>>   */
> 
> It's actually ... surprisingly good after reading it again after at least a year.
> 
>>
>>>
>>> I see that folio_pte_batch() can get _more_, is this on the basis of there
>>> being adjacent, physically contiguous contPTE entries that can also be
>>> batched up?
> 
> [...]
> 
>>>>>
>>>>>>
>>>>>>
>>>>>> Not sure if that was discussed at some point before we went into the
>>>>>> direction of using folios. But there really doesn't seem to be anything
>>>>>> gained for other architectures here (as raised by Jann).
>>>>>
>>>>> Yup... I wonder about the other instances of this... ruh roh.
>>>>
>>>> IIRC prior to Dev's mprotect and mremap optimizations, I believe all sites
>>>> already needed the folio. I haven't actually looked at how mprotect ended up,
>>>> but maybe worth checking to see if it should protect with pte_batch_hint() too.
>>>
>>> mprotect didn't? I mean let's check.
>>
>> I think for mprotect, the folio was only previously needed for the numa case. I
>> have a vague memory that either Dev of I proposed wrapping folio_pte_batch() to
>> only get the folio and call it if the next PTE had an adjacent PFN (or something
>> like that). But it was deemed to complex. I might be misremembering... could
>> have been an internal conversation. I'll chat with Dev about it and revisit.
>>
> 
> I am probably to blame here, because I think I rejected early to have arm64-only
> optimization, assuming other arch could benefit here as well with batching. But
> as it seems, batching in mremap() code really only serves the cont-pte managing
> code, and the folio_pte_batch() is really entirely unnecessary.
> 
> In case of mprotect(), I think really only (a) NUMA and (b) anon-folio write-
> upgrade required the folio. So it's a bit more tricky than mremap() here
> where ... the folio is entirely irrelevant.
> 
> One could detect the "anon write-upgrade possible" case early as well, and only
> lookup the folio in that case, otherwise use the straight pte hint.
> 
> So I think there is some room for further improvement.

ACK; Dev, perhaps you can take another look at this and work up a patch to more
agressively avoid vm_normal_folio() for mprotect?

Thanks,
Ryan


