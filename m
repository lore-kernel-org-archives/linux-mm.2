Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2D8AD35171
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 11:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEE0E6B0005; Wed,  1 Apr 2026 07:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5B46B0088; Wed,  1 Apr 2026 07:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDBBD6B0089; Wed,  1 Apr 2026 07:00:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B10BA6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:00:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 58799E1214
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:00:23 +0000 (UTC)
X-FDA: 84609693126.24.C326D8F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 43361100012
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:00:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Lq/TXV9t";
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775041221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NgQlvT7HXim2f+4oQJCFZZ6ALZtvPfeqfyykoKM5poQ=;
	b=iRwuTTObZnwub8NPGofRxcI9nd400a/xjQwgn8wykZMmE34yeN/g1Wmb23IK9YdUBvxYwt
	Ybk2WK7MhA+aOZTYYHQuBsiUTHi6mOCnFl/ydXOWUCKMPEEz+vOvRQJXZHR0wGjp/CRNME
	lWqjvETW3itOueNoRE+zHnDJ0Lcsu9w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Lq/TXV9t";
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775041221; a=rsa-sha256;
	cv=none;
	b=ucBvpdqMRmNmJfzU0Ees+q+GDH3aHpuFchPb0sp9iDZnm4OtRdhej8c36o7qSfpQjT9Ffa
	G5ogQQuhGQv3oER0YEVHL3plSeflnQe/ezY3IMwInLroakJxLuyR4hCdqH/Z9xLjVpC5G5
	tliYEdrilGECqjcfr/Ppghggrx7CJC8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 137C540875;
	Wed,  1 Apr 2026 11:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB629C4CEF7;
	Wed,  1 Apr 2026 11:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775041219;
	bh=Sn0m1q1+j6lDe7jogLiwV6iavRQIFV9BO8Doky+kRR0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Lq/TXV9t+5cmUeGofFuxuXFePuYCo9Pd4hVefeEaXq/h4nd0BIR9v4eRmMhWWtbae
	 XVj2Rclj7WYyU8XDc+dVatQH48JTG+7Nz9VJdAi5W99kditCPzafa2fbpZ4TwwzpsR
	 Ic6JZMa14nT8TaKAHpVZgIkYAIi58Eje9Oh7Ff3oTCo6W+9LGr8Ip7xi23hIPsfw/m
	 T0Uqma/A2vgvD0cLtZs3unjPZHbE87WFfkmZxNB+Y0/SGt3M8XRFIj+ST7vewisAvF
	 mMMZEF1NaeJJ1oOuCld7OhBQUUzU0GEgWpHyTGeZQyx0MiN+ek2qQG6ppcvDWPaaMl
	 HleGU5pyi/Q0A==
Message-ID: <f28d968b-1d09-4db9-9f4b-55205f43c951@kernel.org>
Date: Wed, 1 Apr 2026 13:00:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in deferred_split_folio
To: Lance Yang <lance.yang@linux.dev>, kartikey406@gmail.com
Cc: usama.arif@linux.dev, Liam.Howlett@oracle.com, ziy@nvidia.com,
 syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
 akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, npache@redhat.com, ryan.roberts@arm.com,
 syzkaller-bugs@googlegroups.com
References: <27d742c6-631a-4878-9c44-bf49bcce9510@kernel.org>
 <20260401105305.94886-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260401105305.94886-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 43361100012
X-Stat-Signature: mka95r3awmwjhoebnmkjowpbo7kxfxnc
X-Rspam-User: 
X-HE-Tag: 1775041221-37779
X-HE-Meta: U2FsdGVkX18xfVZ3eH1x44I27UCeKp7blzS4FqgmpQbLcc7B8FRsk+93rbTxwh3gDW7YjokXcaxiieo2CSUBk6X7USbaTGcB/cLRn6R0FeMp2MSC+gUvBd9P4QH43bK2i4NwD0XIY1AnZC0CsGEpBu1z+PBjHH3HfiF7Ic4W9K0L99/SW71jaXCWIOGCfXgqdh4owTs2ZdPLZyEcABgWQjoIC182H/y7rsPf9vSLFZRJQ+YfdXBCQzMmkCdaPuknN9zvkY59sWwT6pOVtG3cmZvBgdKoPE/Iff/zUlMgNkXmX+9aBAUUqoYF3ezvGDBQR3Pjq79q0w4/phsGzeYwzgC0F2kdWqC4+YGBWfYihl1RwNeCNDU2Z7UxN7gS5Zx8mbPB1YNfi7OaX3Z06xT8P5Cx74i3b5gbk/IaEToOOABzuLpq9/cz7oNB6wj98gOuwf0X+VMJX5yDYEwtMBj4bBO3D4zsbWvsfP9q8Y/poc/ACfKzW4dpP5fwU4TQq+If98XSXla2OYHmE0LfG+YrzJJLqy15IpmJCaxAGHscJWM0eNxZNCOFfCbVEtM73I9m99LBxF8KZcFkIlz9hg13nfcrLkVV5uJlfZ+0p9/5MJupmuwaqjDMnoLm5J2Cb4QJCYnXs3vJ4pKI10rBsCq117LzHzXXolRf6okDqhwyXdSOfOe10K8AVJImqriGrdAlFpiDaDjmfZbKNyrPNcn0B6PVR5S+te0dxiuH+pOg3By50s2w51cTdmKDsY1OJIF0ABbqbs8VnyTuRAk4UN4r+xCKGNlrlZp0fJ8h6MKGSeNINqqYge8NnjlGkGlTAQanw283OFbcgUTZ3MYu2xwDGw6o5nYqkx3J16nDQr8NltQUI9d6RcaJF64nu9JF8xEGJCYtVlTOOzJCzEevAbOIhEuHvw4Iknx4zQLrf7ZsUBFyl7JGh7xlTUiKBjYxV6BlMOsWEseH11prGjLKb8n
 Q/XC/Qay
 Dy3XmqbKSs3GcvWM6LoD9naGxp4J7piGyiaSLXuBFCMkiIzLvbAYW0JWjgUuXE7PU4mDZsp7dEh4JY5O72n9bil+lhAU8WStDRdUbw1MUcAirWkKjQbpJXGdEPMVm6ICg+eMgqN1bRyh+ywlHXLAwjIawdCFxQP7uRiuZ4BnYV54CVbkmsOC3ow6iToM1nTlqGwmV2XCwylxKPJzqL/PvxRzJGoKPspNyaOqt3D2aUvdHaAvDRbr+tMsbF0n5CB2MPIYDD5ucGif3U7V0CZ3iChlH2uNktQVMQria7GcoLbegpp+ZukWwGmjkktVM0sPv7wMKFGWtsbnWN17rK6xiKI8tcUzZ76cvBCTRCpc9CJ6tFkKVu70k6t+W6+s6Lbf7BmP9gsbpfSPnTiRhaqogLowpub00ovtZcwVzXdE86QP4p5LX7b2I6aUDOXMBmVetnY9E9PDPP49vGdwa5JjFxtoheWRz+UG6wnBfHqaVpdjxpRzIseir021L0pFXaMtF/n3AnFrqUhgbX+ZHSpckKyYZVG32P0zWmrEIqh/vZu3kPTI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 12:53, Lance Yang wrote:
> 
> +Cc Deepanshu
> 
> On Wed, Apr 01, 2026 at 12:16:43PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/1/26 10:59, Lance Yang wrote:
>>>
>>> >from another sharer can then remove some of those mappings and reach
>>>
>>> Perhaps the WARN is simply too strict there :)
>>>
>>> Migration already holds the folio lock on dst, while the competing
>>> rmap-removal path runs under the page-table lock. So once
>>> remove_migration_ptes(src, dst, 0) makes dst visible again, this race
>>> looks hard to avoid.
>>>
>>> So maybe the simplest fix is just to drop the WARN in the
>>> !partially_mapped path:
>>>
>>> ---8<---
>>> Subject: [PATCH 1/1] mm/thp: avoid false warning in deferred_split_folio()
>>>
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> migrate_folio_move() snapshots src_partially_mapped from src before
>>> migration and later requeues dst after remove_migration_ptes(src, dst, 0).
>>>
>>> Once dst is visible again, a competing rmap-removal path can legally set
>>> PG_partially_mapped before the migration path reaches
>>> deferred_split_folio(dst, src_partially_mapped).
>>>
>>> Migration already holds the folio lock on dst, while the competing
>>> rmap-removal path runs under the page-table lock. So once
>>> remove_migration_ptes(src, dst, 0) makes dst visible again, this race
>>> looks hard to avoid.
>>>
>>> So just drop the WARN in the !partially_mapped path and preserve an
>>> already-set PG_partially_mapped bit.
>>>
>>> Link: https://lore.kernel.org/linux-mm/69ccb65b.050a0220.183828.003a.GAE@google.com/
>>> Fixes: 8a8ca142a488 ("mm: migrate: requeue destination folio on deferred split queue")
>>> Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>>  mm/huge_memory.c | 3 ---
>>>  1 file changed, 3 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 745eb3d0d4a7..8ea8e293dc7c 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -4433,9 +4433,6 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>>>  			mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, 1);
>>>
>>>  		}
>>> -	} else {
>>> -		/* partially mapped folios cannot become non-partially mapped */
>>> -		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
>>>  	}
>>
>> Can't we simply move the setting before restoring migration ptes?
> 
> Afraid not, it closes the remove_migration_ptes() ->
> deferred_split_folio() race, but opens a new one with the shrinker, IIUC
> 
> Once dst is on the deferred split queue, deferred_split_scan() can
> pick it up immediately. The shrinker unconditionally dequeues every
> folio it visits:
> 
> 	list_del_init(&folio->_deferred_list);   /* always */
> 
> Then for a non-partially-mapped folio, if folio_trylock() fails
> (dst is still locked by migration), it falls through to:
> 
> next:
> 		if (did_split || !folio_test_partially_mapped(folio))
> 			continue;  /* not requeued, dst silently lost */
> 
> so it is *not* requeued.

How is that different to the shrinker just trying to lock the folio before we
unlock it and failing? The race already exists?

To sort out that race a trylock must not result in the folio getting
discarded.

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ff9a42abd1b6..521989517cd1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4558,7 +4558,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
                                goto next;
                }
                if (!folio_trylock(folio))
-                       goto next;
+                       goto requeue:
                if (!split_folio(folio)) {
                        did_split = true;
                        if (underused)
@@ -4569,6 +4569,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 next:
                if (did_split || !folio_test_partially_mapped(folio))
                        continue;
+requeue:
                /*
                 * Only add back to the queue if folio is partially mapped.
                 * If thp_underused returns false, or if split_folio fails


-- 
Cheers,

David

