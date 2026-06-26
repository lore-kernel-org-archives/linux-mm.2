Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9C93C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 16:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87DD86B009E; Fri, 26 Jun 2026 12:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8560F6B00F5; Fri, 26 Jun 2026 12:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71F046B00F6; Fri, 26 Jun 2026 12:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39B7B6B009E
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:25:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AFF8F1A04FF
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:25:57 +0000 (UTC)
X-FDA: 84922590354.05.6ADC23C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id DA9108000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:25:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cvhC5AvK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782491156;
	b=Mtq475FEz3O74MFN6UfXcsNPspG3D81LtuJWg3k3BT0lAQzieOy7ZkJ3obN/iZkf7dBCDd
	Zy36mq/XhBAT8kERSgBFG852KYfTDCP98M4AUYTI2/U8rKgQXIpMet2FgCcNoSFkEPUN0t
	TPsPKm7pIb7b1DWsGt2Y5s/XhdE79Kw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782491156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mVZQGcD57fl9DeFxG1conkB5yGx+FgWXJ3xY0+4QH1g=;
	b=OwjAI8buANREgt1KI7GTAbmmbHF/Q+vtjRDOfqZQq1myQ6cqKD3N5fe6NgDDmlc6HmUXXH
	pNceXsjSproD5d2WAkNOGrlWQDv2J5RniLuDyp1tsEU0AvyIrwrLKO3Kf4KM+NJ2BTHBLh
	9EWgIn7Ne0OpCdxAc2cYOQZ9mDMgUcM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cvhC5AvK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13A784377A;
	Fri, 26 Jun 2026 16:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D091F000E9;
	Fri, 26 Jun 2026 16:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782491155;
	bh=mVZQGcD57fl9DeFxG1conkB5yGx+FgWXJ3xY0+4QH1g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cvhC5AvKs5YOK2xPFn3qFwnu5neSKjvB8xwF0vZIK81AXnH6oC/TFLnji2N1e/gsW
	 sX5fgw0bYSCwtQiE62KKDCZefdLnA7jfM3acnRf2/nAQElN3lLZh8ry7HgfE+JRqdl
	 plLhfPghcTwpxbjfaI6mTc1uDc9BmTOapgt3NVhNfYVKKbtzTACcte2NnCwpfYM/OA
	 T4NaoSaDf4qIhE5ZOcuK6WSdEIgMY5MwHGTKA0lkQBoh5ekBVXW5aQoSkfZB/Hdjnd
	 5oERSoCmsgQx4AETmxWiSKCtN0qighjsZXzZr757naF4Vg4FmucY6uwbkADyjR2QWD
	 P5iyZ/S4eKyug==
Message-ID: <c4718e32-2baa-4dee-873c-7ab99f21ca4e@kernel.org>
Date: Fri, 26 Jun 2026 18:25:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: avoid unnecessary lru drain for
 wp_can_reuse_anon_folio()
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, baoquan.he@linux.dev,
 chrisl@kernel.org, jp.kobryn@linux.dev, kasong@tencent.com,
 liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org,
 mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org, shakeel.butt@linux.dev,
 shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev,
 vbabka@kernel.org, youngjun.park@lge.com
References: <20260623231635.43086-1-baohua@kernel.org>
 <20260623231635.43086-2-baohua@kernel.org>
 <bf2bbffa-dc68-4a3e-a8e6-1ad57c10255b@kernel.org>
 <CAGsJ_4wJ-2JFY4+ADf-Bn2PrbpvOnWeVwZY3unKnB=TZ71-hzQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4wJ-2JFY4+ADf-Bn2PrbpvOnWeVwZY3unKnB=TZ71-hzQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DA9108000B
X-Rspam-User: 
X-Stat-Signature: k5yz5dn8yiysxknzu75dcibm6wee8jd9
X-HE-Tag: 1782491155-503908
X-HE-Meta: U2FsdGVkX1+xRWLbSqnvu4K1o+6SagEPda4hzQfKNKhY1mh5RBdk6W3Me27Xuoa4B/jtUN31exaXKWtYnM3dtP31qaiAtmfnbpQD4XrE9O/k6NJP8I1Oz+3t+8HK+upRT8LAcWPdN1CtMnTxwpk6+0B4/KfmCIXILUW7EJ1T7k/KHz+LnEsoTZYGA3UxCW/c6+FFNg9CX6g8SGUdtsC2k+MhNvWH3GoT4KrbXohANQE8EJxvEIkMw+jDnfiUG6gitaOUDWdhUSuLcYJixZEAXg8+BRzDbb83XbulHktSbCvQUI4dA19LBAc03Ol7pUpZrGqfP+hp+oFcXYQJPJl5QKuIt6Q/STf5WxQcXZMO2FDGI1DRTv3IyX+1m+x8hrA6i9u+4lA0b53jB/8hVp/M7kUpVzfNHDh6ithVljQGWEeyMcoc0Wm9LjNp69tUGK/OEqd3DY+mJP21665kFJzq1bWTveQD0QjwgLY0wV7nGBHl5RrRhzKK+Q0RxeJC+UD8QwJsAaBQQhWxaYrt4YMtCyNZwEPq6RWOFOD84JfIrS2ZcZAj0iyaUQqJ8YuznRXOBNmvQoOVRrXO79EitIcvV2HXvJ8Fskdrv/b+ANRf+qmoV33kSdgGx41wEf53B5/ZIqKs36DRdSVMnyyS+IbvvZ71OonkF0qbVGkS4I844kMheX24fjq9vmMORcanmWwdACTjg5owET3X14RwRTh4Q1KwSSu2xv/eZj009VX7+KUaNHRaUwNdvpmkeQ4+jJbPX9ChTVR4fNOAloIuQ2f9zTR8P37a4cZwtKsTGGEzCMRZ68lcxaF213M+4FnAZAR1kseHUEHCdZib+NdOuqppHBYTV6pSg4MjGQtjSlpY8ogeyqlh3itn3tLEVjvtp7H67uIHblEaIqDxjpOeh16q2Fn8TeK+d9Ta4E7XRQ3lM/NWlCWgfTEUYpNqYvuDRxHVYFtqlhLXIMxcwgw7U37
 JT/M46aS
 6VwpG2fp2afROMWEkt6c0XkJ60WR8hkBIy/X5IkOjIzRY6WQXTZ1PDoRkQhcX6q6NdTmBi/AItfoB+Oo54GhP+o4+2+RkmDftIyxoP7mHhfe1ONFzy0Cq6y35vRMcwtQtv0Gsg501ah+c7eVzrrBq4JaDyyi6kMuFawD28lW3HJlqvhnJLdKw4syuL6tT8o6XAhVPD4hRZII3JeReNane3BDEVDmbQvukDdV/T4cGIFWy/wwDsjnIT25ox2JbqyyJzwKInirJ67PtRw0o+cW9Pv0CxFvu85NzLP3/Z+ZSlS83d1gRhD0CDIFpmpgrxTy3BBb+D+zXJLfstqwEixWN8myHJrRu65hdED9/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 23:04, Barry Song wrote:
> On Wed, Jun 24, 2026 at 11:02 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 6/24/26 01:16, Barry Song (Xiaomi) wrote:
>>> We always unconditionally drain the LRU before retrying anon folio
>>> reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folios
>>> are in lru_cache, and use the refcount to avoid many unnecessary LRU
>>> drains.
>>>
>>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>>> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
>>> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
>>> ---
>>>  mm/memory.c | 8 +++++++-
>>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index ff338c2abe92..f6848f4234a6 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -4193,12 +4193,18 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
>>>        */
>>>       if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
>>>               return false;
>>> -     if (!folio_test_lru(folio))
>>> +     if (!folio_test_lru(folio)) {
>>> +             /*
>>> +              * Assume folio is on lru_cache and holds a cache reference.
>>> +              */
>>> +             if (folio_ref_count(folio) > 2 + folio_test_swapcache(folio))
>>> +                     return false;
>>
>> I'm not keen on making this function even uglier, so no, not like that.
>>
>> We have the earlier "folio_ref_count(folio) > 3" check.
>>
>> In which scenarios can you trigger this such that we would care?
>>
>> If the answer is "I don't know" there is no reason for a change.
> 
> As I replied to Shakeel in the v1 discussion [1], this can avoid a
> large number of drains, both during Ubuntu boot and under normal
> workloads:
> 
> "I booted the system into Ubuntu, and after

is this with this patch only?

> 
> boot completed I observed:
> 
> wp_reuse_skipped_drain: 5542
> do_swap_skipped_drain: 0
> 
> Then I built the kernel in a 1GB memcg using zRAM swap, and observed:
> 
> wp_reuse_skipped_drain: 25017
> do_swap_skipped_drain: 43595

This is all data that belongs into this patch description, not hidden
somewhere on the internet :)


And why do we care about local draining? This is not a drain-all.

Really, this patch needs more motivation clearly spelled out.

> 
> So in summary, even without swap-in we can save a significant number of
> drains in wp_can_reuse_anon_folio(). With heavy swap-in workloads, most
> of the savings come from avoiding drains in do_swap_page(), while we
> still see a substantial number of skipped drains in wp_can_reuse_anon_folio()."
> 
> This is exactly the case where folio_ref_count(folio) == 3 and
> !folio_test_swapcache(folio). That is why checking
> folio_ref_count(folio) > 3 does not help.

diff --git a/mm/memory.c b/mm/memory.c
index fec2e9f2858a6..153a6166beeb4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4181,6 +4181,9 @@ static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
 static bool wp_can_reuse_anon_folio(struct folio *folio,
                                    struct vm_area_struct *vma)
 {
+       const bool in_lru_cache = !folio_test_lru(folio);
+       const bool in_swapcache = folio_test_swapcache(folio);
+
        if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && folio_test_large(folio))
                return __wp_can_reuse_large_anon_folio(folio, vma);
 
@@ -4191,15 +4194,16 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
         *
         * KSM doesn't necessarily raise the folio refcount.
         */
-       if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
+       if (folio_test_ksm(folio) ||
+           folio_ref_count(folio) > 1 + in_lru_cache + in_swapcache)
                return false;
-       if (!folio_test_lru(folio))
+       if (in_lru_cache)
                /*
                 * We cannot easily detect+handle references from
                 * remote LRU caches or references to LRU folios.
                 */
                lru_add_drain();
-       if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
+       if (folio_ref_count(folio) > 1 + in_swapcache)
                return false;
        if (!folio_trylock(folio))
                return false;

?

But I also want to hear why we care about the local draining.

-- 
Cheers,

David

