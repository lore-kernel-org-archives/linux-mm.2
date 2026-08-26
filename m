Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C550C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 07:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DEBE6B008A; Wed, 26 Aug 2026 03:23:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08F3B6B008C; Wed, 26 Aug 2026 03:23:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEAC76B0092; Wed, 26 Aug 2026 03:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B43926B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 03:23:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90FE6A312F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:23:44 +0000 (UTC)
X-FDA: 85142580768.25.57592A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id BD5DA14000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:23:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bk9h0TQk;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787729022;
	b=oEY6Fuaplm1vjwf9G0ntyXCYC1u4dyxpbV6W7+RGChdB0qdCxDdpXbNp2oggmZVmuYGz4H
	TUq6tcMTFzEmx3lbV4xjwGPFUUxj8s95U8Y79QJu9bqFzpiIxCVl2L/k4Hd4UrzqCJRxZp
	9pddUfJrCiHMkob8bvSckuKRbK9/FFs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bk9h0TQk;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787729022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eDY+D7XL9VuOmqDyV1cbNPo/RBpqAzB2FjfOhAjGhW8=;
	b=Gfu2wH+8OgYRQfQZ+78iOs0INmUXpyBq/nQdg1FtsLLsicPuQ41U7aVPaH9WmHpCbsat7z
	L5ZlI8VRCfado7qZ4DW2rP0s0AeJMNib+lgrJmihy1uppfx7xVBe4BAoYj4qQ30j472z6K
	ingwv9jk2sy8QDryLIk9H9D3kRNiXjQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D4EAE43597;
	Wed, 26 Aug 2026 07:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F671F000E9;
	Wed, 26 Aug 2026 07:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787729021;
	bh=eDY+D7XL9VuOmqDyV1cbNPo/RBpqAzB2FjfOhAjGhW8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bk9h0TQkoAsdrTAfvO7bJZAqgBEtCuTbokVkteESGBqJymGQQiW+EDuaRW/do3qr9
	 K/bjqs93XO0Vt3LolPNeKkksBx21/D2yiDHbPORUOWE85JfnQYIzhSH1Rv7oaNRdqj
	 xFYfrNZzdEssI1zf34ftP8+LhtM7MDlFvUsO6NW7mSgM+fQSbZfvdM2HUM7DJAIpMM
	 N+hUg3SevjHZoIbLmNrvZukDUrKCQ+i8t8tkKb1vTGzJSX84HduHP3mzdapPFzTHmf
	 +iFP0L8XS2gMb4plOera5hojjcBidjkuKhKFnMZjZ9u/bW5CCCCxwZyyzaFKji4wdi
	 tQrDlCBYgNhvg==
Message-ID: <24f8108d-e7e7-47d6-8994-f50625daa4f0@kernel.org>
Date: Wed, 26 Aug 2026 09:23:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: fix missing migratable flag on same-node
 hugetlb migration
To: mawupeng <mawupeng1@huawei.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, baolin.wang@linux.alibaba.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260707110254.3147686-1-mawupeng1@huawei.com>
 <fa60a766-6cc2-4db6-a38c-9a8e33925eda@kernel.org>
 <ce6be959-58df-4138-bb35-01a1785a91d3@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ce6be959-58df-4138-bb35-01a1785a91d3@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BD5DA14000A
X-Stat-Signature: 6ewjcg3twfafbwxtj6m1ao1hrb5nxf3o
X-Rspam-User: 
X-HE-Tag: 1787729022-580897
X-HE-Meta: U2FsdGVkX1/8fAKjSzY4qOdZbCZv1L+GtsVKi3EBvDV2Gx9q265Nor2LTZg8Lq/gBzuXjNj5HXPq/iVBqePKzRnhVwPOez+pHjLX/UDlnMZD+xR4clYrz4IjHuahCYOJNISk7UOiWruS5vySIxM/M8Sn9pIh6gHWzMRIY1QIbjLrF8okTXeVzUJAjrui/lCEonuqVn1KcZWUUkUDeUPN0qGela81e3cGluDyL2UChM34NSGdTSyDZS4TbA46gUa1p1Da9eJ62yr9Rm4mhDPhv2xDrnYUKv0TDjNHLqnC0j9eBsZQsfL7KHVmncPznN1cVdwLPtACSEmWgTUj/q/DPtF1HwnUMNDRUjSZ/PeuZtfyjaFK2RPLh2R1HXbfdqCXZUpVBfSbphgVA9paTsYXb2Bb678ZOAwsUx0R0f9XEgCdzEtj7kvyPpU8udi0oGRrSjI8BnOgE7HmWCZFc0ug+SdPgjhQg9Jnox6S7h3/olYAiqhnEkLmVuaDJqv//1bnAfwT1NvvkxhvlTQbBtdndhv5JXPJmxezEy6xW/8vimTZxweIMIYgYt3D5e/CBlmFEplJzfH/1YqEWKI5Za1CxDPKJU7cMkfl5PUYhmAfY/UIJ4fQU5nF5i/UrpUNPDZGy4jDUGNM3CVMMMWITRXpVURjpiv1Tsne0TNTpqQCu3sWHeHjRxDB5eoOOXn2psEn5H8TJ/7Kg11oETTGvsD6whQVSTf0HqAS4embEeGo3du1Kvfv//Qo+9IncZJUfzLUNSAizzb86jpOInHQu/4ZL1Qo2HMMX15/nz7sDHtJy6j9AbZMUQyyfJC0C1VWnDNJcHUYPlioPT6BXpR1LSimez8YRwilU+iflBlTHHCvzTuR4X5XwoKs8h0fuByKbAZXE8Sfqvyn0mZ0w4pOWn45bBw4QTQ7bmJiDWqcIJqFo5lyfJqoly8WSrNbO/Rlj82NhUXtfx6zFpflKzuhpYg
 9x+6v9bd
 QaFE+7cb/ESZ4eGKj/fX/XQDchM/PslFUY9XqCHl0v+VKUcQKmn9gd1/zrOpENgmcxXo78YZg3eEm51FUNshyfjdZYu0P3QVeSRvrsGwAEZ0FpM8DaMjAWasc7bsAkRds/Knv1yKv1JW6qiT7zn350KH2h/o5D2s/PEVzNPpsp154fb6FD6d0Pkds4oeV9N3Q3qN3DYxuaBjCwsnlc7DcMfG/fhNxm/GtohoMCxlErCfYEHBziZ7fPpd08K8UPNFBXhX2K7oEhCX3C2nMTIE2Zv+qZKu/CnmGYoSUNAJqw0Ucz19v5wXdo1fFA/949gEiGktLXU0Ul/2pSzY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/26 03:46, mawupeng wrote:
> 
> 
> On 周二 2026-8-25 18:27, David Hildenbrand (Arm) wrote:
>> On 7/7/26 13:02, Wupeng Ma wrote:
>>> Commit ba23f58de896 ("mm/migrate: don't call
>>> folio_putback_active_hugetlb() on dst hugetlb folio") moved setting of
>>> the migratable flag and active-list placement from
>>> folio_putback_active_hugetlb(dst) into move_hugetlb_state(), so that
>>> the freshly allocated destination folio is handled where allocation is
>>> known to have succeeded.
>>>
>>> Unfortunately, the new code was appended after the existing
>>> temporary-folio block in move_hugetlb_state(), which contains an early
>>> return added earlier by commit 5af1ab1d24e08 ("mm/hugetlb: optimize
>>> the surplus state transfer code in move_hugetlb_state()"):
>>>
>>>   if (folio_test_hugetlb_temporary(new_folio)) {
>>>       ...
>>>       if (new_nid == old_nid)
>>>           return;                       <-- skips the new code
>>>       ...
>>>   }
>>>
>>>   /* added by ba23f58 */
>>>   folio_set_hugetlb_migratable(new_folio);
>>>   list_move_tail(&new_folio->lru, ...&h->hugepage_activelist);
>>>
>>> When the destination folio is temporary (i.e. the hugetlb pool was
>>> exhausted and the migration callback fell back to
>>> alloc_migrate_hugetlb_folio()) and the migration does not cross a
>>> node -- the common case, and always true on a single-NUMA system --
>>> move_hugetlb_state() returns before setting the migratable flag or
>>> adding the new folio to the active list. The destination folio is
>>> then installed in the page table but cannot be isolated afterwards,
>>> since folio_isolate_hugetlb() rejects folios without the migratable
>>> flag; a subsequent soft-offline, hard-offline or memory-hotplug
>>> offline of that folio fails with -EBUSY.
>>>
>>> This was reproduced on a single-NUMA arm64 VM: a second
>>> MADV_SOFT_OFFLINE on an already-migrated hugetlb page returned EBUSY
>>> and logged "hugepage isolation failed".
>>>
>>> Keep the surplus adjustment, which is the only part that depends on
>>> the node crossing, guarded by `if (new_nid != old_nid)', while making
>>> the migratable flag and active-list placement unconditional. This
>>> preserves the cleanup intent of ba23f58 and closes the early-return
>>> hole.
>>>
>>> Fixes: ba23f58de896 ("mm/migrate: don't call folio_putback_active_hugetlb() on dst hugetlb folio")
>>
>> Agreed, let's CC stable.
> 
> Thanks.
> 
>>
>>> Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
>>> ---
>>>  mm/hugetlb.c | 14 +++++++-------
>>>  1 file changed, 7 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index 571212b80835..cafadfdb63c0 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -7211,14 +7211,14 @@ void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int re
>>>  		 * There is no need to transfer the per-node surplus state
>>>  		 * when we do not cross the node.
>>>  		 */
>>> -		if (new_nid == old_nid)
>>> -			return;
>>> -		spin_lock_irq(&hugetlb_lock);
>>> -		if (h->surplus_huge_pages_node[old_nid]) {
>>> -			h->surplus_huge_pages_node[old_nid]--;
>>> -			h->surplus_huge_pages_node[new_nid]++;
>>> +		if (new_nid != old_nid) {
>>> +			spin_lock_irq(&hugetlb_lock);
>>> +			if (h->surplus_huge_pages_node[old_nid]) {
>>> +				h->surplus_huge_pages_node[old_nid]--;
>>> +				h->surplus_huge_pages_node[new_nid]++;
>>> +			}
>>> +			spin_unlock_irq(&hugetlb_lock);
>>>  		}
>>
>> The return was really rather hidden, thanks!
>>
>> Can't we instead just turn the "return;" into a "continue;" ?
> 
> There’s no loop in move_hugetlb_state(), so continue won’t work there. But I understand your intention. 

I am clearly in need of some vacation (next week!!! :) ).

> To be honest, I’m not fully satisfied with the nested if either, but I haven’t found a cleaner way.
> goto, or extracting the surplus move into a helper, feels like over-engineering.

Nah, let's keep it like it is, thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

