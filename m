Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9BE3C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28086B009D; Thu, 10 Sep 2026 03:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D00756B00A0; Thu, 10 Sep 2026 03:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF5E76B009D; Thu, 10 Sep 2026 03:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE846B009D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:41:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E56E80422
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:41:57 +0000 (UTC)
X-FDA: 85197058674.22.D7DB4AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id BA0E4140005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:41:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hum0N2mv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hum0N2mv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789026115;
	b=bewlHOYB0Py0TLTe/cLaMgbQ9qtDwNAhNygra0fSXof4z5WzbViKreX3Aa7+mCiJaOi0+4
	Ivpgjzpn0aL+acF2r6G6zJlW5B1xYMs21N7NIEK5wgCDqaNB6JQuJGnaO19ccaDAdYYFhL
	U+rPKiCdNBtApcCvSA7Qvti35nOLF5c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789026115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MQD6QrrlHO8ADNcKu+y9ND7s92JpqOTzGT8eHlZRW3c=;
	b=epwvV+WoyOzqaLk8Crr1vDHPXrVRt3HQCETPZT32DiUCTP4ZF3fujP+lFmjH0GII8Tt1dM
	YOCnhbcV4JX2P2sU9TnBr2XmBdNI5QQBjyS+qVhWjpJSmZT7iFcsu23gAQSA1VAVtWYnSN
	nfvJKUMCHSis1Qg9M1HKlsSIfe8+wm0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E78FC40F82;
	Thu, 10 Sep 2026 07:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC751F00893;
	Thu, 10 Sep 2026 07:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789026114;
	bh=MQD6QrrlHO8ADNcKu+y9ND7s92JpqOTzGT8eHlZRW3c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hum0N2mvW/CuBfRXSaUF604iUi2nR0bxw6UgLkHyRZDJuNLy1Ha9yCWp1/5OdGC0t
	 mHffGzrg+Jn8zhnmUzT8u1hPEPvI+GhxC/gW76xY6DMQN/2vp2JvZpFLP40DRKW9vN
	 o1uTlOXTl3NlV4t+K4WwIwp/rwA044erTzIMl5LdME8z41WwXqm3XyZF/HdX8KjFVl
	 8pPMSbrivX76vlMVZBnVs9Odk7O2B/rH+q1saii4dYE2iCECTnOH5sQOFTP/R+tfhM
	 PDggJLUBhRMQdtdq2kBlokqWj6Ooog/GtNWD0U81w6DYG0gy1yFXUCfOVWFzEkxup4
	 WsUe7aEXtvMpA==
Message-ID: <2336140f-c993-467a-b2eb-e99dc9427a59@kernel.org>
Date: Thu, 10 Sep 2026 09:41:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org,
 vbabka@kernel.org, willy@infradead.org, jannh@google.com,
 paulmck@kernel.org, pfalcato@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260907063918.3432401-1-surenb@google.com>
 <20260907063918.3432401-4-surenb@google.com>
 <4825a2fe-f064-45d7-a7c9-e98de7efe86c@kernel.org>
 <CAJuCfpFL_g7tELjT8p8ExM3tX_v2gNDM9rRKwwefPV_KW=fHfA@mail.gmail.com>
 <8e643f51-a47f-428e-9443-678326288fa6@kernel.org>
 <CAJuCfpEYdj=u0wczKRrsB8uDkbSzPy+hrsCo9TW9-3J3r3p0xQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpEYdj=u0wczKRrsB8uDkbSzPy+hrsCo9TW9-3J3r3p0xQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BA0E4140005
X-Stat-Signature: g7qpww3p5nf5coos43nnzpqswjnoxak8
X-Rspamd-Server: rspam01
X-HE-Tag: 1789026115-767866
X-HE-Meta: U2FsdGVkX1/w74pvoFhrdWqKZhO/sjTqXyw/efuMzK/WRxWs/YKzo8upwLYpCF+91TdKJM7hi52vT/o8DlFznRxE68fDALfutHKK9Ryqxc9Dw8IEE0xE7P3QDM1gRj5EEg6iPKfRRzMXQb3t9ACRmGVDhNCX+SAB9LP7FAQdW4oOlhK0/9mEHYw/r0IOQAZlwNlGNgR++msJXB7Cq5n7OS5Q75E/YOEI4CPmM5Q63v/twIVySDleDgSxLY+Oqla0/yhdexKlj35h/203PqKSz6RcForA+Iv9CYMDoITDJ0Ew5SU8ZUnN1NT9vNld46PzoiFpS6Ft/LIQMHfNzg1JWOWBL/Tpbhugaz1cJEBn/U/raCeszjYwGMLSocHxCK2UBlac5UP5LYjFZCiqoTCt+JmgjwS/7gmNgDYPCIkzk0Bz/fkiEq35McKZgfHpdP3TUuODUgy+dSA8Y0bnbLeTHEdtQroenayiYKsN6GE3aozk+T4AywV6GP+575vSIGlIRGbxaHNaWIMbImC0izp38Pv0QnbU6uV3z9PJeFMcJL0b4CcezwOTkX7ZaYzvx26SRWSDjODizBPOplHo+QAYLLzVmuBFBXtQau237IZ4ujO7oWorC2oJJYNU015WOOlcOhC5r5B7tBxTB3xkcuLXJSqfa5TByuerm8pr9zvFJrnjVumPQHaxuUVB7kMBUH9qt4FJPbWq0rSIScrv+b4Q5/ewHu3lCTgr6oEXWblJ8iSNzK37i+yDOTVux2bfMQXtcR/OU5+w5BMFvaVXj+1+Kc6scIydS6Srcmy+nNvdhzPXPRSYFar9PnBFBv21e04sA3V5tG/DhAHUiao2qFGKnneabq7+kekTafCSmrTkHe4v6s6ZkueCiiLxcVPuyz0jXcG2nzFLnxp+1Zu19+S+7ykP0EhlXjpk9lzZU1Aol5XjZGXCOCYs8vNlvFrS/qnVGZxIzJONkOXNa1mvsxQ
 5m+7j9cm
 Al31lsDWR0wptpxiSQd+BzNcspD56ucAcnyi8G1SZnMJ82k30Qd2jaFN/SgHzfIwm7wmJncq2b+2J1S9YipRrIoXNGj12yOidiQzqXCXVqsny/Gep86ZjHjZsxj84OE0UoUwCX1OqUskskTG0QX1QE+dJZGk5BBwHVbk2LfB1rYMSziLx4wSKMdV1IuSlLcVynlrbOifpwI59L36NRFUPnfJvtBcZl5rmIdfkhYsa7ZdhOQAK88QJytA+mIdPne31SGS5HOQ5vhtwSROX1xHFzTYw9BTJSYprr8uiRH/pv77pkWEfruHF52Izc5LuabPYK3WPCKPNJqkqLZAU9c6JRjGgnj9wPlZWTQQF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 23:51, Suren Baghdasaryan wrote:
> On Wed, Sep 9, 2026 at 12:16 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 9/9/26 20:28, Suren Baghdasaryan wrote:
>>> On Wed, Sep 9, 2026 at 10:16 AM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> Hmm. So, are you saying that !is_cow always implies shared_or_ro? Or
>>> maybe you are stating that vma_is_cow_mapping() was the actual intent
>>> here?
>>
>> So the comment says:
>>
>> "For private writable mappings, we might have COW pages that  .."
>>
>> Which translates to:
>>
>>         private writable == vma_is_cow_mapping()
> 
> Ok, just want to make sure I'm not missing something subtle.
> 
>>
>>>
>>> shared_or_ro = VMA_SHARED_BIT || !VMA_WRITE_BIT
>>>
>>> is_cow = !VMA_SHARED_BIT && VMA_MAYWRITE_BIT
>>> !is_cow = VMA_SHARED_BIT || !VMA_MAYWRITE_BIT
>>>
>>> so, !is_cow would impy shared_or_ro only if !VMA_MAYWRITE_BIT always
>>> implies !VMA_WRITE_BIT. But I think it's possible to have a VMA that
>>> has VMA_WRITE_BIT but not VMA_MAYWRITE_BIT, right?
>>
>> VMA_WRITE should imply VMA_MAYWRITE
> 
> Ah, good to know.
> 
>>
>> (in sanitize_fault_flags() we even disallow write faults entirely if VM_MAYWRITE
>> is missing)
> 
> I see.
> 
>>
>> For example, a
>>> driver can create such a VMA to allow writing to the VMA but to lock
>>> its content once mprotect(PROT_READ) gets called.
>>
>> I don't think that would be valid for a driver to do. But it wouldn't matter
>> here because
>>
>>         shmem_mapping(vma->vm_file->f_mapping)
> 
> I was obviously overthinking this :)
> 
>>
>>
>> I think we could simplify the comment as well to:
>>
>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>> index e671b4fd8dedd..4b7e7089cafa7 100644
>> --- a/fs/proc/task_mmu.c
>> +++ b/fs/proc/task_mmu.c
>> @@ -1303,12 +1303,10 @@ static void smap_gather_stats(struct proc_maps_private
>> *priv,if (is_partial || (shmem_swapped && is_cow))
>>
>>         if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
>>                 /*
>> -                * For shared or readonly shmem mappings we know that all
>> -                * swapped out pages belong to the shmem object, and we can
>> -                * obtain the swap value much more efficiently. For private
>> -                * writable mappings, we might have COW pages that are
>> -                * not affected by the parent swapped out pages of the shmem
>> -                * object, so we have to distinguish them during the page walk.
>> +                * In CoW mappings, we might have anon folios that are
>> +                * independent of the shmem object. So fallback to the less
>> +                * efficient mechanism in such mappings.
>> +                *
> 
> Sounds good. Will update.

Likely worth putting that into a prior cleanup patch, so there is less noise in
this patch.

-- 
Cheers,

David

