Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C814DCAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 08:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FFCA8E0011; Mon, 15 Sep 2025 04:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0876A8E0001; Mon, 15 Sep 2025 04:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB7C48E0011; Mon, 15 Sep 2025 04:08:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2EE68E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:08:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 69DA61A04BB
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:08:39 +0000 (UTC)
X-FDA: 83890757958.18.F577E19
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6D39D2000B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:08:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e8RlS6Ig;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757923717; a=rsa-sha256;
	cv=none;
	b=cz/TGt8ZJyb2x7ihnHVFTEoEGA6nTqm6JkhWWKq/2FwA+stLtUWJnf6JkcYw0w5/rfGuZt
	xaE03aK2HZHrqhyWyPDBsWY1pBMNJYgsBKDC1betUnzRrQp1KsZgyKEyP9IS8mLK2YBrnz
	03dRVQYUqdMmWZMqtx5y25SFkaVfiew=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e8RlS6Ig;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757923717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EtEmkQtLFBHG9GoKlpgRUasNpA5G9sH4hEUSIhS5NPk=;
	b=g6wJuNaxfExb9TGhZgpAYnF5tV+4p4PKo0f1EZn6laNO0V75VhArUsgp42oilVFb4cqzcS
	HI0WSm/itaYBYtYEioKyqUDknsJDVXuec8Sd+kNyJ5T/ritzO3L+U061RRU7YrURci/PwU
	NhzgqYSPGO2436z4+KxlCeU71MxDDT8=
Message-ID: <e40f3eaa-7c94-49ab-bc39-e0e3ed56e163@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757923714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EtEmkQtLFBHG9GoKlpgRUasNpA5G9sH4hEUSIhS5NPk=;
	b=e8RlS6IgcqpS/92ZZRptrbVQobbrMy/IwIBgqKB1dBDUmg4eIRfucud057R50cFeyffbTn
	U0GMl0jL1WWjcj17qi3iXnnrhGEJndYfr1F1W4sZ18xar+lkFJPf6tYnilda9LxzIOVl/g
	iR3HlcVA1+OfXZG7c3IryA4vn5TzAks=
Date: Mon, 15 Sep 2025 16:08:24 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>, Dev Jain <dev.jain@arm.com>,
 Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, lorenzo.stoakes@oracle.com,
 akpm@linux-foundation.org, chengming.zhou@linux.dev, npache@redhat.com,
 ryan.roberts@arm.com, xu.xin16@zte.com.cn, baohua@kernel.org,
 Liam.Howlett@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <ae30fc02-c573-46bc-a5f6-935f256149e2@arm.com>
 <cf5d6ff7-faa4-469e-9e32-b90c75b8194f@linux.dev>
 <463716f5-be12-4d78-9432-779e3f11460c@arm.com>
 <62680957-e9aa-40ad-893d-885bd01e1117@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <62680957-e9aa-40ad-893d-885bd01e1117@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6D39D2000B
X-Stat-Signature: cm6xn7scgnjk7yt9jogk6t53wst7brbd
X-Rspam-User: 
X-HE-Tag: 1757923717-802957
X-HE-Meta: U2FsdGVkX18K1Qw7YmK0c0gYmEu/TuO2nhbMhVxQXK0nNhbcXm6gdSSA9MCw/ofC11AeG4dqgBd1PS4fe9QfI8RZ5eif6DFQXVU8Zff4afQcGHqQ6cOYSbsyQ0/jnOdox0TYZe55xHn9y4xkODxCfjvTLxronbz/SXmMgoAOq/RbANopI7SzAzRbzuLI/8MJf3OzzOesGazg7ktt7ojMdg3X0zutHAGt02NyTZzbFXGuAG8HBXd7637baMyoWlcpOiuZXHQbxwIj+KZLhs8hr69Ys+C5fyDF4W+O0him8XIsnckY38FSMPxR3Sb6vcvhdcie1Ab2yRbBDt2vBeUKlhKjdIq+THbSWJWWImp0r3XoJsMkF1GsWsyYLz/UDcmvC2NgIbzTJEIJIyEpWO7S1DSpHlesk2F/lPohrhk9IzySdUxjlx9bA2IUasv2/VjDwu7c0leeYIdjpCaMLOC4WlFMf3lVF3pJkmpUNV1sjZOPnyDf33+y1GenPbBU441SVRASij7NAEzOxArH2GURx01ilUVmuY4CGy3OfZvaj1mQO0uf/C4PAmz9ds/KGO9mQjrTV+xnY5skdbKT1F1Pdgb2wnKM+P9o1x36wcauKSQkTZieXtKonbr41IlYRcMeKoVqFCdImTlxaSMF124r1snxm9Wr6A4hHXuZaRaBnTMsupg5RqqQXUKy+RnrYw7ESYDXmMyvc9km0TH8g46NRnGrUn/lbARIi3yVXgTBj+Z641jxzrLjTVK31wHCjyhIUTDw3Y6idhLMXR2DJSG/cxP2DHUDaGvVZq/4kuUXAy90ea73c7yf5UybN18/crxvV5jGUoq15Es88cFQY2yEnpr+lPVWUpnCwBVShf/lAotM+i2T05OLcsL7DHEpuAPY1yyxU4lNNUUAynOpS/+ftWsL5vLOCbmE0Qn5dt9T+MCcvnTXAgyI4R56UAm55smnOqdNUoYGUDnG4xC7o33
 r+sNpPnY
 l8OSBtZuYoaf38agKWRMIJ2XQSp1E+IAPRlx1Te7STKKLWdJq7BA56joYFC0DXBmlDh0zBtUoumkFBCHyTyG7tbQ8si8Yzb28VX0l/fXCR4WT+yg4lJgvEsDxjKKvuuCi/pEQ1uxLRn7QsV7gewj6Q8Sw4prljLs8oGKCxmE7J1oyB3yFPomXeCX+3TsmN3/+LhcyKfVcxE3QzCQGT8iG4P17DbH5UH878tk9MrWW1UGsgffpj6B+va+L6OcNFmNLW+b9PR++vcd1pFvtvH8+IRjVSKc3ZoVnP+TtcsP1D7Ff+hJznSKEkz4xDrcRswuUD8Jjao3+0lwnNNljfmtMSOc6o3JyCwgoekzRiFIrBVkUGFE+WZFNRzXSIBoZEEZvGtwA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/15 15:56, David Hildenbrand wrote:
> On 14.09.25 09:29, Dev Jain wrote:
>>
>> On 14/09/25 12:33 pm, Lance Yang wrote:
>>>
>>>
>>> On 2025/9/14 14:21, Dev Jain wrote:
>>>>
>>>> On 14/09/25 5:30 am, Wei Yang wrote:
>>>>> When using mm_slot in ksm/khugepaged, there is code snip like:
>>>>>
>>>>>        slot = mm_slot_lookup(mm_slots_hash, mm);
>>>>>        mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>>>>>        if (mm_slot && ..) {
>>>>>        }
>>>>>
>>>>> This is only valid when mm_slot is the first element of its wrapper
>>>>> structure, otherwise a NULL slot would converted to a mm_slot with
>>>>> negative value. And current code thinks it is valid and continue.
>>>>
>>>> Shouldn't you fix the code for the case when you can't find the slot
>>>> in the hashtable, i.e slot == NULL? Like, if (!slot) return.
>>>
>>> Right. For khugepaged specifically, the slot == NULL case in
>>> __khugepaged_exit() (only user of mm_slot_lookup) should probably
>>> be treated as a kernel BUG for new.
>>>
>>> But I'm not sure if the same logic applies to KSM ;)
>>
>> I haven't seen the KSM analogue, but restricting the position of an 
>> element
>>
>> in a struct to make the code work should imply that the code is wrong in
>>
>> the first place :)
> 
> I agree. If mm_slot_lookup() returns NULL we just just handle that 
> cleanly like
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 6b40bdfd224c3..70a32d59d7d2f 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -488,11 +488,13 @@ void __khugepaged_exit(struct mm_struct *mm)
> 
>          spin_lock(&khugepaged_mm_lock);
>          slot = mm_slot_lookup(mm_slots_hash, mm);
> -       mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
> -       if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
> -               hash_del(&slot->hash);
> -               list_del(&slot->mm_node);
> -               free = 1;
> +       if (slot) {
> +               mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, 
> slot);
> +               if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
> +                       hash_del(&slot->hash);
> +                       list_del(&slot->mm_node);
> +                       free = 1;
> +               }
>          }
>          spin_unlock(&khugepaged_mm_lock);
> 
> 
> If mm_slot_lookup() is not expected to ever return NULL, then a 
> VM_WARN_ON_ONCE
> might be sufficient to document that this is guaranteed.
> 
> IIUC, MMF_VM_HUGEPAGE might be set in __khugepaged_enter() in case
> 
> (a) test_and_set_bit() succeeds
> 
> but
> 
> (b) mm_slot_alloc() fails
> 
> In that case we could get NULL.

Ah, good catch! We could indeed get NULL in that case ;)

> 
> 
> It is rather weird to leave the flag set in case mm_slot_alloc() failed ...

Perhaps the MMF_VM_HUGEPAGE flag should be cleared if mm_slot_alloc() fails?

Cheers,
Lance


