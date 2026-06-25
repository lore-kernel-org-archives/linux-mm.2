Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9322DCDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FA786B00E3; Thu, 25 Jun 2026 03:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2536B00E5; Thu, 25 Jun 2026 03:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710436B00E6; Thu, 25 Jun 2026 03:38:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4338D6B00E3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:38:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B95DD8FAB9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:38:12 +0000 (UTC)
X-FDA: 84917631624.07.656B7EC
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id E4DA5140002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:38:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kcpOVqU9;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782373091;
	b=N53vyOfItvzEhYEw4Mu6dj7VFXo5tl+QU1Icn3Gqk970GrqawkwoaRPEjiOUNa0/c7e8SE
	OBCZayNxKJH1tG7OM+fpAqckGSnDe+Rya5zbEIcSlk68zhxs6lSL9U5Je0IrK02cMW3dni
	EeMDTS/jmlOOJqPzotnEIxmGeaVeNq4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782373091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBpSi383BAOXXIGxhMDUQBIu/MQh2aj4tFTkWUIvvbw=;
	b=ssWaRkbb+sF/KF+I7ifUl51BnxwyPT0Bz+e+SMo2rrgjLov/cPf6QDj4mVScDrywJWlytD
	qS/PXSotOBKNmUY7HUtQp2jBEknxQ6JjW6kH0NjnCkXnRnb0AXyGlJQaHKAjg5g61+jf2D
	v5wGHUyzZ+FOqk+E5iC6tYM4oVQm2ls=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kcpOVqU9;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <1db11ccc-ae05-4b26-b360-c34ac9f97299@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782373088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OBpSi383BAOXXIGxhMDUQBIu/MQh2aj4tFTkWUIvvbw=;
	b=kcpOVqU9mWWYm6usOJNPTC5aT+1FVjw/uAvOceZSTPi3dapZRgCeL1+kbRPd8Ho1pgG97i
	fLpsGnw4FllP3+86/E8tjuxFBLJLiV8OWRSA+zEpyofpHVkwrZQoJEH92sj0PAJckHrU8u
	8vAFzzxSMM3QmMC3jeSJNoFAdUjtNjk=
Date: Thu, 25 Jun 2026 15:37:43 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Harry Yoo <harry@kernel.org>, akpm@linux-foundation.org,
 david@kernel.org, kasong@tencent.com, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, muchun.song@linux.dev,
 peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <20260623024237.45990-1-qi.zheng@linux.dev>
 <e74b0808-3bcc-414d-a037-41e479210cc0@kernel.org>
 <d97128c0-7d89-4b5c-b891-84f9af702fee@linux.dev>
 <8a76aefd-629c-41f3-b365-aefd4cc1411e@kernel.org>
 <7946da94-dc1d-4cf2-986e-466c378665b6@linux.dev>
 <dfe5d773-2992-448b-a6cb-ef633714a08f@kernel.org>
 <1d638906-6d64-4e57-a181-4b77683652b5@linux.dev>
 <b5c85cea-5daa-4690-ac41-a6f5aebd1555@kernel.org>
 <f18bf1b1-ccf7-4d77-9389-07311d2d1613@linux.dev>
 <1d78e1c1-0cdb-435e-b278-670bce9148b3@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <1d78e1c1-0cdb-435e-b278-670bce9148b3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E4DA5140002
X-Stat-Signature: yt7ch6kijo6er1n4ggijzgw7izzess6h
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782373090-731875
X-HE-Meta: U2FsdGVkX1/XVnUYel2IFv/YJRF5XasI0q6GdoMeXfDLdQAl+thRpg4mhpPLwvJlBhhJty+4ISAFgKq7cGyhlDJooqKipVPl6slvJCveHpAqNVjqvsMer6BwMP5J+1Rx2SmhPO4FRZenf8RmfIwwC+/Hd+87mOr3S381EhSa5eqjw72aGPYqjL1rD4LN4fn5DIZgWBab9Zl7SJ9uE6EdfPkhurD6X2DcgkQByBxor6Zu1KEPenm02H78tVljQOLG41NzaZZ4JdD9xSawAnIcirkAujPWrlZ53c69l65OwB1X7XpNlKQ5muvAv5tGNcz5SJ2siY9rpwoeEXSQm+qvsDWa2Drp5srtnBvk4zL5F+A4KOG8fEEdMi819IxF8DkTQI1oOyIJ5ungO1vRWnMUzEZqNV4kZO+o8P8cSmlkv9kk076Jvh7VXrOqNjJGOMPs8xZF+570jy2JZdpX1a6gw6S4ePiCuZczCwxuCbNLevwBSk/L7F0LelbBZeS4IRGpew4kXUyKVALnYNk9+RWWEtZWBeZIXhNo2kvqzr0MMbBCc1texl8M5pj8Hx92wsMDpv1RdO7ggUy1mBXX3+d6GXHkILe1Pg/ABAMggFDn4vJn/URPz2j/+7i0qjWphh9r6yQ5xqeHXzhxlwNY4ThTV9Nc/Atv8ZgMTl4ISRfBrA65Rb3yYIAp5niKfFRBzY3pkj+lmmJvO/B1AR9S9Qt0idSXCSuOj/OZdDztbCztSIGBBfy3TFYpZCEhJt5moWyqFoUmsspiZ5GHfSZt8uOjlt+9fM3tiez6mJqUfWLlU+RyRx7LWOAYk2ogITFqqFEYK6ZhFRJVmMGGT4wkaNAilrAgclZOWJu9pFsPav9n47XXW+22cz1kkP5n1nasyFDWskFWPrPyEOcLoQVysn/dmYOBtVswTfLvXGsdJ/UjuUENkXj3XO+5pNLRTGVMf0MFpdrjhCC5+iWKemPHemy
 6JP6DdIi
 wzVvFAlHviptFqyqmIJj0pYsW5GCfiKjUPvbyZhKBuwhZt6SoWV1gltMJIeLT2PqtgAr0r+3uPZG3dfDiA64hniuNhAvDL9gcVtjm0ELVyeppVssrchBxLpahPcr6Agvlapgv6K7pn5OC7AbwcdOCwg3iSUeV7Tm6EFe2qtRrV7/l3kmwG+rJqsS9InGb/p7gvM83KukjwoI2C4HDVUbmh7+I8r3xW6+hU2AsSwz9RVtBZks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/25/26 2:32 PM, Harry Yoo wrote:
> 
> 
> On 6/25/26 3:11 PM, Qi Zheng wrote:
>> On 6/25/26 12:16 PM, Harry Yoo wrote:
>>>
>> [...]
>>
>>>
>>>> So lock_batch_lruvec() can be implemented like this:
>>>>
>>>> #ifdef CONFIG_MEMCG
>>>> static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
>>>> {
>>>>       struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>>>       struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>>>
>>>>       rcu_read_lock();
>>>>
>>>>       /*
>>>>        * The memcg can be NULL when the memory controller is disabled.
>>>>        * Otherwise, the caller keeps the memcg owning @lruvec alive.
>>>>        */
>>>>       if (!memcg || !css_is_dying(&memcg->css))
>>>>           goto lock;
>>>>
>>>>       do {
>>>>           memcg = parent_mem_cgroup(memcg);
>>>>       } while (memcg && css_is_dying(&memcg->css));
>>>>       lruvec = mem_cgroup_lruvec(memcg, pgdat);
>>>>
>>>> lock:
>>>>       spin_lock_irq(&lruvec->lru_lock);
>>>>
>>>>       return lruvec;
>>>> }
>>>> #else
>>>> static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
>>>> {
>>>>       lruvec_lock_irq(lruvec);
>>>>
>>>>       return lruvec;
>>>> }
>>>> #endif
>>>>
>>>> Does this make sense?
>>>
>>> Yes, looks good to me!
>>
>> OK, this sync method makes more sense as it doesn't require adding a
>> new lrugen->reparente. I'll go with this method and update v3.
> 
> Thanks!
> 
> Just one thing to clarify...
> 
> So, when we check something that's updated _before_ grace period
> (CSS_DYING), RCU is sufficient.
> 
> But in folio_lruvec_lock*(), that is not the case because reparenting
> is performed in the RCU work, under the lruvec lock. So the check needs
> to be done under RCU and the lruvec lock.
> 
> This is quite subtle :D

Indeed.

And in theory, the l->nr_items check in lock_list_lru_of_memcg() could
also be replaced by the CSS_DYING check.

> 
>> Hi Barry and Baolin, what do you think? Since the sync method has been
>> changed, I will temporarily drop your previous Reviewed-by tags in v3. ;)
> 
> And hopefully Peiyang would kindly double check v3 still not reproduced
> on the machine :)

Yeah!

> 


