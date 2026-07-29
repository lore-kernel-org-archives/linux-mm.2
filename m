Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF80DC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF6BD6B0092; Wed, 29 Jul 2026 09:52:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80416B0093; Wed, 29 Jul 2026 09:52:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6EF06B0095; Wed, 29 Jul 2026 09:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 905166B0092
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:52:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23B201404B3
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 13:52:53 +0000 (UTC)
X-FDA: 85041955026.22.4BEEB65
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3FD2EC000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 13:52:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VXmy9sA0;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785333171;
	b=q+JPt90LLKE/rnrHZrov84KPn5C9mU28vJabzpZFTPWx4pFXYZD8pRFZqbNbSDU8PiukPY
	3oEv2oVIYWVUJ3WjhmPVruVzCqMTa3oDvjgGTCc/T+mYBzBzMI0+d4loZbSkCuOgF6bIV8
	xxK35hzHX1So0LoIf87tQ9nK+wt98JQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VXmy9sA0;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785333171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysgBHq5s5Hm/YI8tEORg2R1/XNH+Q68qloOBkdqdGRk=;
	b=EULGd5kBtDv/8YQ32xzT3uuMBkAOnIqxP3S7NCtuLUZqWSrwHBrHHLaxtUqloh1aGuE4nM
	eL2lVhbdE3tb96sXXSgphhIcxeTIVQNUJYWzSarATQ6hdGyncl1Kki4702QLJ1QBolkBUM
	39Rsfix1U1GTGNK7vN61Fc1rTKS8v+Y=
Message-ID: <b226ad94-1464-4c42-a080-686533ccfbcf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785333167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ysgBHq5s5Hm/YI8tEORg2R1/XNH+Q68qloOBkdqdGRk=;
	b=VXmy9sA0jy4gxbhbmal08rZHjBw98uF//VsEcCLNmFVasgABbKxuixXLaWtCFY/fcYZ7y5
	168iF14uvrsvzSj69TSV1qpCrIxYB9Qu9z5O2HADLheq9E1uKifq5w5lDUShq9BYsevfq1
	iC3vJk4Qd3S4bB6gkI4sGMP7XQBHcks=
Date: Wed, 29 Jul 2026 14:52:34 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v5 04/11] mm: zswap: add range lookup for large-folio
 swapin
To: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org, ying.huang@linux.alibaba.com,
 Baoquan He <baoquan.he@linux.dev>, willy@infradead.org,
 youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
 Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, shikemeng@huaweicloud.com,
 kernel-team@meta.com, Alexandre Ghiti <alexghiti@fb.com>
References: <20260722152043.2273289-1-usama.arif@linux.dev>
 <20260722152043.2273289-5-usama.arif@linux.dev> <amFZmtGHEZjXEw5R@google.com>
 <ee172b01-54c3-47ef-9040-1342a1566796@linux.dev>
 <CAO9r8zMzjCf620EHwzfosngc94fu=vAb=ukrtOi9Qf3rA3vv7w@mail.gmail.com>
 <c40f4a8b-1f60-45ea-962d-0597c413ec3d@linux.dev>
 <CAKEwX=P=cFqojHPCp1oGqZCOVVGi9pyrgLtaSH3qrEwVppmxdQ@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAKEwX=P=cFqojHPCp1oGqZCOVVGi9pyrgLtaSH3qrEwVppmxdQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3FD2EC000B
X-Stat-Signature: gw6fax4bu7ow6ewxomuft7jybygapn19
X-Rspam-User: 
X-HE-Tag: 1785333171-414376
X-HE-Meta: U2FsdGVkX18ckARtMKUnWkbLeBrJvzSM2xFOLHbBk27XCANWPfBoYh2yoBjOIt/H2wzO5mfFgRh2HBo+Z5J5mvdZlfj71zijW0YbX8EIkO27HCq9s5RmSsjRepboUtYoydOL2eQzm8qUzoWUehEYPjQ9cFg3xCO3ieVovFVWUCaxzCbiuSdLTZjKNWmv5peJ7aWznUEyW9akraoVfCXU9DUzskgGKQoD+5pAqaDGRfDKWq4EUzACkoZ+nlcMOWm08HMIyqLZBbXhSlVPTJ+MktIm+uM0l9rxuiHSoVJ8rNvI9jiaeTT8lpj5BrsNzU5w/qWmC1wakdSY8hkdLS0nZNErG2B9wT9f8/54KiKzuHeNCfNpopxGRANJr0SIiv6KNvKVHaO1MZF7HUPktowH0Tp23YhxZZJXFSEqhfvdkSoXpjdsxXvxES5K6xpnG5gqndzhC20yQgDZvGKP1e9tmaHfsQU5wYM0yx5bXuxNMd6bDkN0DLrQrRPVxc02Ca6Y4HMYDjPL560FvAHRidT7KKHY639K31FjRjhB52Ps7mdhThM6DVOwHL+3yhZhHUXUYcv0H0iFaAdWYGOphmpHiVgfDhgwn97j+2yk1uMyqGfAGGgYa4hyWzGla9BSsmGClhmnOT8tq9PD50iALVRPYX2z7TsbSjktqVyYfaJThu+cWZHLNEmxRne3yM//SED49LZVERE5eGHZ60/ZbxFEE5o4Xb4bjowp1qYNDXbr+XhBfe1TQ3MmFBgrovwah8upN1rXt8T/P7H7CJej6oVpS0gz52qgGdfWp26GuwRNUd0+G/uOa6LUke685uGn74WR3BLDjnw2vzwrQAvVj6lXzsTQDbhBQKieFpGyRfMWZDGgZHMoDU+RsbBNAp2NzlU0JX7Vjh/HY9R9LlgI18MV739y8EeHMOfadQB28TBZRb2fWoXl5gVRm7fBErEXA/Z9oCG3y0JBN7TCVlEuOjv
 phaAbxcx
 VHawYmDzBX9sV8O5ydPCW4b1ID/vJkiPG2jF7vEvAWdQ7ddrKnELVBVMP41GdxccIrFKdFbo2RYpILhKUhXuefdcxiC+lmI3LmtnYIwdAp0DSsniiJ1vjTyR+hm18ZUgj/kTlkpft9Ji6EOXzUdoZ3HkmV7wkFylh1aZcTraKH+2Bw0tx/mkL61CxfpsHpdutO92aOh1R8Frnt08tNdYzuZ24RvJtbzuWAdmDaWj+GzdKgSE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/07/2026 17:24, Nhat Pham wrote:
> On Fri, Jul 24, 2026 at 2:59 AM Usama Arif <usama.arif@linux.dev> wrote:
>>
>>
>>
>> On 23/07/2026 17:42, Yosry Ahmed wrote:
>>>>>> @@ -1595,13 +1611,19 @@ int zswap_load(struct folio *folio)
>>>>>>              return -ENOENT;
>>>>>>
>>>>>>      /*
>>>>>> -     * Large folios should not be swapped in while zswap is being used, as
>>>>>> -     * they are not properly handled. Zswap does not properly load large
>>>>>> -     * folios, and a large folio may only be partially in zswap.
>>>>>> +     * A large folio reaches zswap_load() only when its whole range is
>>>>>> +     * expected to be on disk: PMD swap-entry consumers split before
>>>>>> +     * calling into PMD-order swapin whenever any slot is still in zswap.
>>>>>> +     * Confirm the range is entirely absent from zswap and return -ENOENT
>>>>>> +     * so the caller reads it from disk; if a slot is unexpectedly still in
>>>>>> +     * zswap, fail the read rather than return partially-initialized data.
>>>>>>       */
>>>>>> -    if (WARN_ON_ONCE(folio_test_large(folio))) {
>>>>>> -            folio_unlock(folio);
>>>>>> -            return -EINVAL;
>>>>>> +    if (folio_test_large(folio)) {
>>>>>> +            if (zswap_is_present(swp, folio_nr_pages(folio))) {
>>>>>
>>>>> Is dropping the warning here intentional (for the folio_test_large() &&
>>>>> zswap_is_present() case)?
>>>>>
>>>>
>>>>
>>>> Yes, so we can end up in a race, which should be handled gracefully.
>>>>
>>>> For example, lets say we have zswap writeback enabled, which means we
>>>> can end up in a state where we have a PMD swap entry and 511 of the 512
>>>> slots have been written to disk, but 1 slot (slot X) is still in zswap.
>>>>
>>>> We can then have the following race:
>>>>
>>>>
>>>>   CPU A: PMD swap-in                  CPU B: split-PTE swap-in
>>>>   ------------------                 ------------------------
>>>>
>>>>   Checks swap cache: empty
>>>>
>>>>                                        Faults slot X
>>>>                                        Adds order-0 folio F
>>>>                                        zswap_load(F):
>>>>                                          removes X from zswap
>>>>                                          marks F dirty
>>>>
>>>>   Checks zswap range: empty
>>>>   A is preempted
>>>>
>>>>                                        Unmaps/reclaims F
>>>>                                        zswap_store(F):
>>>>                                          puts X back in zswap
>>>>                                        Removes F from swap cache
>>>>
>>>>   A resumes
>>>>   Allocates large swap-cache folio G
>>>>   zswap_load(G) finds X in zswap
>>>
>>> Why don't we check the zswap range after allocating a folio in the
>>> swap cache? I am assuming at this point we have the folio locked and
>>> the result should be stable?
>>>
>>
>> Yes that makes sense. The folio is locked and the result will be stable.
>> How about something like below?
>>
>> diff --git a/mm/swap_state.c b/mm/swap_state.c
>> index 1f08fb522036..41f168377cb1 100644
>> --- a/mm/swap_state.c
>> +++ b/mm/swap_state.c
>> @@ -12,6 +12,7 @@
>>  #include <linux/kernel_stat.h>
>>  #include <linux/mempolicy.h>
>>  #include <linux/swap.h>
>> +#include <linux/zswap.h>
>>  #include <linux/leafops.h>
>>  #include <linux/init.h>
>>  #include <linux/pagemap.h>
>> @@ -500,6 +501,17 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>>         __folio_set_locked(folio);
>>         __folio_set_swapbacked(folio);
>>         __swap_cache_do_add_folio(ci, folio, entry);
>> +       /*
>> +        * Reject mixed zswap/disk backing before starting the read.
>> +        */
>> +       if (order && zswap_is_present(entry, nr_pages)) {
>> +               __swap_cache_do_del_folio(ci, folio, entry, shadow);
>> +               spin_unlock(&ci->lock);
>> +               folio_unlock(folio);
>> +               /* nr_pages refs from swap cache, 1 from allocation */
>> +               folio_put_refs(folio, nr_pages + 1);
>> +               return ERR_PTR(-EBUSY);
>> +       }
> 
> If you move it to __swap_cache_add_check(), you can potentially
> backoff even before the folio allocation? :)


Thanks Nhat! Yes, this looks much much better as well:

@@ -190,6 +191,15 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
        if (nr == 1)
                return 0;
 
+       /*
+        * The cluster lock serializes swap-cache insertion with zswap
+        * writeback. Reject mixed zswap/disk backing before allocating a
+        * large folio and recheck it before adding the folio to swap cache.
+        */
+       if (zswap_is_present(swp_entry(swp_type(targ_entry),
+                                      round_down(swp_offset(targ_entry), nr)), nr))
+               return -EBUSY;


