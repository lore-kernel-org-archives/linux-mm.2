Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F2BACD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 21:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB37A6B02A0; Fri,  8 May 2026 17:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64946B02A1; Fri,  8 May 2026 17:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B52916B02A2; Fri,  8 May 2026 17:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A26816B02A0
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:41:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 340461A0330
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:41:45 +0000 (UTC)
X-FDA: 84745574970.23.A16C793
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7A32680007
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:41:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kK4GS7G8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778276503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gUkRvIbkVy/C+AetQ9f5r6TPejl5dRJ8sc6LS3VjlsQ=;
	b=iu4LktWWMVGeZ8TlOXbspWWwWQtUrq4za5SUjJFZTOHGMjnTxczb26cegpJKvUgQ+6rJtO
	h/RpDfwUUeRIADB6U3FEL0EASU7CWWgPmfH+BoURlwA2TC8QqhduiLWO/906fwFFikAFcg
	ytnHONpgwfXTPx313/6o1NhUJ4hN4sQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778276503; a=rsa-sha256;
	cv=none;
	b=He0lU1I7nQMuniZmlNhOCwpAOvJbI79KqOjf8Wn+YdXlAx+Y3R13nLKUemvPWnm285YVpJ
	nCsfbhCmnC4jo7tkuIsDyl/utlZ6E0asDryPtdT+a6eCzrE7Ap3yuDSC/qSwZsTZq9gK/O
	sUPQcbbA8AixWYtUx2DBTeD6pqLG5FM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kK4GS7G8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B319460181;
	Fri,  8 May 2026 21:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55FAC2BCB0;
	Fri,  8 May 2026 21:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778276502;
	bh=C5uNZOk0+Ox0K/5DzoimGv/kGBAg9O/PngG4bk1Ydx0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kK4GS7G8sLO37sfOkMRYMw9J2p2H3Czzi2BISfaOLZ4VFFZDHMuElpHz3CxwcWLXQ
	 Iah53dkaEN9B1KoE0fVMfqb5/yU2366ZV1mh5Js2AG9ZViZP+P3tByC84K4wOFg5V6
	 2Pf4lNLdRUap9BqfHcF+d3Kwp/eFx1rrp6fk33mDeTus0s9CUlGhShqMObskb6Ob4a
	 Qwlgdw7nnUwX3YWdhkB5Y3BTUvXjHb871K4vGoQwCBGU2wwCxMMPYxneoiodT6Ksd8
	 7LRrsQLtUMeL8zzl0C00Axql7TIRHl8UYtauBGHhIwqs/5MX6wh1XOoscD/Pb8Aenp
	 7haqKSYSYjQ1A==
Message-ID: <6b6b094b-8dcb-423b-bb86-ef1439887eed@kernel.org>
Date: Fri, 8 May 2026 23:41:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/khugepaged: clear MMF_VM_HUGEPAGE on
 mm_slot_alloc() failure
To: Lance Yang <lance.yang@linux.dev>, dev.jain@arm.com
Cc: ye.liu@linux.dev, akpm@linux-foundation.org, ljs@kernel.org,
 xhao@linux.alibaba.com, liuye@kylinos.cn, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, akpm@linux-foudation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <3fb8c00d-d60d-4fec-81b1-e7633384a52d@arm.com>
 <20260506105150.21504-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260506105150.21504-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7A32680007
X-Stat-Signature: fut51iagdgpswf4itz9jug5n4g15srb5
X-Rspam-User: 
X-HE-Tag: 1778276503-769923
X-HE-Meta: U2FsdGVkX18UIhJmFPeQyh7VNLf+mjdYX1AHTQiakbV6Xec0OgH3rF3LAxr0fj5f175SaBbP/OOTJXGndzM54mygvlK/mM8d2qWG6TERYLv5UC3xgwBHwbqnxpM4CGfk5S7Vgzbo1KJYwsrKBl00Q4/3minbSIJo+Y+jZXvzr7NZzi66HmEikTO75aGh36WBoNWoJHc23uhvais7k409jpg6FBPV9rCMGaBl50J7ZBif/DuUqGTa9xlTZy2G/5dn41iP5W1SjXGbY+uq80YrTfB72Tk3B6R+Io4fXAq2dcvJbk3BKrA3DW9bQgb0rDEKhrjhxuk42Ker3srza3pI91aJhW4jQT5tj6D3/q6SFVwTWaAjswV+7lgoO2/5Q3OlEtBGdrIRNLz3t6Db/fItH0psQ9BRENHdcHg1xXUwMjgbF28la/zCAz1jn47FPaPKLx5gBeFKxuDmqfTVsy7WmxOOpqrgdbYaFUG5uU/uyA1+2GH4pBpCZd7Meroa3j7Rg0/SdE6rt+eJ/jhMgjG9fv9O++oL8MWk8oQm3ixRqiUZiZo0+9ajKXGZElqM9ZWZMkz8xFaRjaKIuJ0jmDQsE4kauf8Uo1UCrQWtMvPMILZSoho/mIRrN7G4bJ8o3BEoA1dv1pCvq2Osf0sEt5Wwxx7BUNbUpm9HUrKQH5/rJlLCFr3uehMj6Umi4wwwgasi6639t0mh3sUjxzY/7hfEmxZ+LpTLNa9B8aoxXK1LoB7RoPS6if+DUkUQVPSW8Nli8MBRqgKX/3FM3n/rU5xduSaKlFLO96IIpUDGHTJGRAcOub9SO0QVZON3OUJ8PUwgiXlpA3HoEufTC1qg107841rScDAw3JNnj1rXD/IEoacoaSpALsFLqylzNRXZwe0y8DNtCXd7x85olndfIJuBx/9sJC6f09egq6KCVFOCA9A3BolOSxSiAabrT3wrE8Exhi2Yep1udDvY388lH5m
 abOVmohs
 Y6UbqeZHWjkixeAIGufdZSth0pxoRgkOP/wD8SByNJ9iapG9kCoKx4yDL8xTlyRIlL4eypQrtNEIsZ87Wu/5ocTwrgBOXSzz6yyFrd7/144Nq5KAtn4ldPKSb3fIT29kQWjdaWHbdTr5x6omknKiVcYb2V65Vu+JYVkMCQGSzTzFhAYbvv7A7z+fKqmsfL3NoDN0W8QfSiy49oA06ZBdBVv1Pt6QoHGp2z8xTP3zehwEpO65QkoYWvAxoOIWOktD8W/eXj3IKmN2v3p8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/6/26 12:51, Lance Yang wrote:
> 
> On Wed, May 06, 2026 at 12:16:35PM +0530, Dev Jain wrote:
>>
>>
>> On 06/05/26 6:51 am, Ye Liu wrote:
>>> From: Ye Liu <liuye@kylinos.cn>
>>>
>>> __khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
>>> corresponding mm_slot.  If mm_slot_alloc() fails, the function
>>> returns with the flag set but without inserting the mm into the
>>> khugepaged tracking structures.
>>>
>>> This leaves the mm in an inconsistent state: it is marked as
>>> registered (MMF_VM_HUGEPAGE set), but will never be scanned by
>>> khugepaged.  Future attempts to register the mm are skipped since
>>> khugepaged_enter_vma() checks the flag and returns early.
>>>
>>> Fix this by clearing MMF_VM_HUGEPAGE when mm_slot_alloc() fails,
>>> restoring the ability to retry registration later.
>>>
>>> Fixes: 16618670276a ("mm: khugepaged: avoid pointless allocation for struct mm_slot")
>>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>>> ---
>>> Changes since v1:
>>> - Add Fixes tag as suggested by Dev Jain and Lance Yang
>>>
>>>  mm/khugepaged.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 7d48d4fbd5f3..60ab7c1b61dd 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -559,8 +559,10 @@ void __khugepaged_enter(struct mm_struct *mm)
>>>  		return;
>>>  
>>>  	slot = mm_slot_alloc(mm_slot_cache);
>>> -	if (!slot)
>>> +	if (!slot) {
>>> +		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
>>>  		return;
>>> +	}
>>
>> Note that, a racing khugepaged_enter_vma() may back off
>> when it sees that MMF_VM_HUGEPAGE is set, but then the above
>> clears the flag after slot alloc failure. So we end up not
>> registering the mm with khugepaged. But I am sure no one
>> cares, we are in much big trouble if slot alloc is failing.
> 
> Right. A racing khugepaged_enter_vma() can see MMF_VM_HUGEPAGE is set
> and return, then !slot clears it again. If there is no later
> khugepaged_enter_vma(), the mm still wouldn't get registered :)

So why not

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5f4e009593e0..78735f34250a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -437,13 +437,16 @@ void __khugepaged_enter(struct mm_struct *mm)

        /* __khugepaged_exit() must not run from under us */
        VM_BUG_ON_MM(collapse_test_exit(mm), mm);
-       if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
-               return;

        slot = mm_slot_alloc(mm_slot_cache);
        if (!slot)
                return;

+       if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm))) {
+               mm_slot_free(mm_slot_cache, slot);
+               return;
+       }
+
        spin_lock(&khugepaged_mm_lock);
        mm_slot_insert(mm_slots_hash, mm, slot);
        /*


Arguably, on the race described above, likely the thread seeing the
MMF_VM_HUGEPAGE would likely similarly have failed the allocation.

I'm fine with either, just wanted to raise the (cleaner looking?) alternative
where we just properly back off?

-- 
Cheers,

David

