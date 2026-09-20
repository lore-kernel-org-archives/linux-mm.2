Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EAF1C982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 06:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 841846B0088; Sun, 20 Sep 2026 02:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8180B6B008A; Sun, 20 Sep 2026 02:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72E0F6B008C; Sun, 20 Sep 2026 02:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 41DF36B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:11:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 208F5C03D2
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 06:10:56 +0000 (UTC)
X-FDA: 85233117312.14.6740416
Received: from mta1.migadu.com (out-44.mta1.migadu.com [95.215.58.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1491F1C0002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 06:10:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="i/diRS5+";
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.44 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789884653;
	b=ctQqK9eLjZ0dokwfdY5xHJolGOUZXcJie2V8mdwrNXD2P0KCAoAx40XwLkwLxV4daSXhQh
	Qx2/eXx6ocN5gfKY4P4jLFuAjkIbB6FtTjIMSGPCqh3tFbhvKlP8UFdjrGRDqC9BY2EMEC
	vxdpgMz1DCD1zLlA6izS1AOxkBCVEUM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="i/diRS5+";
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.44 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789884653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=chYxN++RWJ6aMZGRW9WQ650UmAGoL9+mnv6L2RNYsUk=;
	b=61dNV6zWVBRxWfdwWe9qBPGlMvlWzWa6tKhBZTmOb7Y9yIGlVsm1/owI1FyCDrZgPlReSj
	QPINks3u0JMJF6PCTaMogtSVDzF0sb6sp2fwlxF5cFu6jLh+oOEBDOcoQrPwuLAPH635iT
	p/C1ta1GqilpNpXTVrtMPXrSTdibtQA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XBXICcDKSuY/lMhCIyKc8ruxZp1iN0ZmzDia5GycYgI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789884651; v=1; x=1790489451;
 b=i/diRS5+SpyBLvfAI2dGtvOfQwq7rIdgK3496V51UaoB9d5LCaVdQAMbDnWllAyaSDcldNoR
 1POvFB3sU2IW3rJ5GHqBkmvhf1zCpED78HZfRajI826yiAieXkl+rUNpNOrdqzhE+WNc0eBmgqP
 dpKegz0UzQrjg4lV14q8yHbk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0e8465e20e73e58e;
	Sun, 20 Sep 2026 06:10:51 +0000
X-Mizu-Trace-ID: 0e8465e20e73e58e
X-Migadu-Flow: FLOW_OUT
Message-ID: <00212347-d64f-48e8-bbda-a4613fe492ae@linux.dev>
Date: Sun, 20 Sep 2026 14:10:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new] mm: vmscan: put rotation-missed folios at the LRU
 tail
To: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260920043015.3126317-1-ridong.chen@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260920043015.3126317-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1491F1C0002
X-Rspam-User: 
X-Stat-Signature: yx6gs8p5cx9c3xemx6fzhfd11f7suq6j
X-HE-Tag: 1789884652-989814
X-HE-Meta: U2FsdGVkX1+Q1WL7DAICF1D/bsj53KaSZVOzcIk6xrtT5SoD97Q9dcXbHr6PrE+ggMIoIf/MH+C1EcvneLnp3r8/geoU+Qfnb+zj1TsKlGlJVLYk4KFx5iTBt8sVaiU5Ls8aP34GuIFjBxnFCY1TocGFtV3iZvWHTQ0E7ok1Q09yDLsx/HG6t8Y5k88sduAJLDP3WQXzDFDlKjVTRDtSI3bubDx6W0rAUxTrWDePfyrBezSHuAupbWxlbzWXaANOeMYV3uJ8fKkVIHEgEkk72ibqQ1+gVUNaHnnsidx7vAB9nEF2Bp3SGDjyFVFPJd+WB5/5G1DNFC+6btYmtP9k4lPuLn7JniMiei2GVpEZGqjxgzQSSP/0erjJijy7sfwQlVvUEME6lN4tmYbfrWs2b1SlRemIrfHBpRrXGtO1fdYDCGsQaN/vgv2eS8j0Hvy07PrYWVFpUhCjGfXk2uMOdPnLs+bK1HY89/1exRqATzJMwhm96PQnGAmumohuhnHs/9uK6qdClApWYTJuL81gXPkZi8wuo+hM2GuR4sxOWa2T1Xr9imNVJFzMCUisXm1kqW6JBGdEVfejTjjH3KZg9olNeuOUlZzB/SfnwqazRoGhf7pREf5YKiOlgVr/C1S2qjr3/xwO4zsNQ/W6vlyWw8GMHRzzovhMgIBosiq/as/JeU+U0YJrEX9s3dqWPv9UrRLWIXbN8qeJteJ7Rs5/DPaQmBIZcjbscyt8i2OlrN6RWAOw51GUfWKBNjcRITGUFxbjxDjKxFQF3ZQY9i5pLf85oxWmR68M+FBE4kOXhXNnfR+FBYtZ1/oPA7tii/zb5qzuGyr/EE/7CgO2ypooCxAjKOFSb6bzBoSJl9wvU6iiKJBjjEEpc3dxUt6F2AciHiF5zcPicNlrAoz/eLff3QHJ6/7Xz8OCxH8Da5ptEMKs5hjESmgo4PgVmEDIBpoyKNu7jMJObOemTVBUAiQ
 4ziovyt7
 aZLcvLNbEAPhgcSwC/l8ZVd6//TnGqpY24ImLKmi8MFlZyjE0twVjULWIr2YF135wFI9SU19oVqM9mPD1gnz7ycOw93Jbw2Osgd9JZLsMtJh4axjm38T28RLF0XwMSJPs4xm/1vjWvQ7oykr3KOw7IwgadJ9N13vRb0CQE4ovves/MRAK+zWUImCqosmINipDzbo/OXzy5lHfttpNUvYhn4OgRvl9svrH22i5dnwgCi2Etklr5I2tNk1PqAIe3ANGPgAeY1FGtnZmQfcxCnpUdEgBzCuQgOeCw3Vnzx+L7Igokm4Of2kn1RyqV6PazkR4rYtJdpbNSP998xAKxE1dMBokpWJVfQxeIHN3uNwR/Gijp7SJX6qaSCzklQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/20/2026 12:30 PM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The page reclaim isolates a batch of folios from the tail of an LRU list
> and works on them one by one.  For a suitable swap-backed folio on an
> async swap device, it queues the folio for writeback and, after finishing
> the batch, puts the folio back to the head of the original LRU list.
> 
> Meanwhile the page writeback flushes the queued folios in its own,
> independent batches.  For each folio it writes back it calls
> folio_rotate_reclaimable(), which tries to rotate the folio to the LRU
> tail.  But folio_rotate_reclaimable() only takes effect once the folio has
> been put back by reclaim.  If the async swap device is fast enough, the
> writeback can complete a folio while reclaim is still working on the rest
> of the batch that contains it.  In that case the folio stays near the head
> and reclaim will not revisit it before wrapping around, causing a cold/hot
> inversion: a clean, written-back folio that should be a prime reclaim
> candidate is kept ahead of hotter folios.
> 
> commit 359a5e1416ca ("mm: multi-gen LRU: retry folios written back while
> isolated") addressed this for MGLRU only.  The traditional active/inactive
> LRU has the same problem, reported at [1].  A reproducer is available at
> [2].
> 
> Rather than re-reclaiming those folios (which would drop the swap cache
> that may still be useful for a future hit [4]), restore the rotation that
> was missed: when move_folios_to_lru() puts a folio back, add it to the LRU
> tail if it looks like it missed folio_rotate_reclaimable() (inactive, not
> mapped, not dirty and not under writeback).  A new do_rotate parameter
> gates this so it only applies on the reclaim put-back path
> (shrink_inactive_list()), not on shrink_active_list() where the list order
> is already deliberate.  This approach was suggested by Barry Song [3].
> 

Add test result:

```
Without patch:
   cat memory.usage_in_bytes
   1073700864
   cat memory.memsw.usage_in_bytes
   1413124096

   free -h
                 total        used        free
   Mem:           1.6Gi       1.2Gi       299Mi
   Swap:          1.0Gi       678Mi       346Mi

With patch:
   cat memory.usage_in_bytes
   1071140864 bytes
   cat memory.memsw.usage_in_bytes
   1413423104 bytes

   free -h
                  total        used        free
   Mem:           1.6Gi       1.2Gi       322Mi
   Swap:          1.0Gi       328Mi       695Mi

```

After applying the patch, the difference between
memory.memsw.usage_in_bytes and memory.usage_in_bytes is close to the
swap "used" value reported by 'free -h;.

This yields the same result as the 'retry' approach in v9 [1].

[1] https://lore.kernel.org/lkml/20260916123846.1242548-1-ridong.chen@linux.dev/


> Only the traditional LRU is handled here.  MGLRU already retries such
> folios via its own clean-list retry pass in evict_folios(), so it is left
> unchanged.  The same do_rotate scheme could later replace that retry pass
> to unify both LRUs, which is left for a follow-up.
> 
> [1] https://lore.kernel.org/linux-kernel/20241010081802.290893-1-chenridong@huaweicloud.com/
> [2] https://lore.kernel.org/lkml/46037a37-4cf6-448e-a94b-30a4d16e8814@linux.dev/
> [3] https://lore.kernel.org/lkml/CAGsJ_4zwP3_+EYY5Ug9EJ+yD1UdxsBSGr25u8s1K3u_i7LH3Zg@mail.gmail.com/
> [4] https://lore.kernel.org/linux-mm/20260911121341.178028-1-alex@ghiti.fr/
> 
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>   mm/vmscan.c | 21 +++++++++++++++------
>   1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e200ce3eb056..026b844c681f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1971,7 +1971,7 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
>    *
>    * Note: The caller must not hold any lruvec lock.
>    */
> -static unsigned int move_folios_to_lru(struct list_head *list)
> +static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
>   {
>   	int nr_pages, nr_moved = 0;
>   	struct lruvec *lruvec = NULL;
> @@ -2018,7 +2018,16 @@ static unsigned int move_folios_to_lru(struct list_head *list)
>   			continue;
>   		}
>   
> -		lruvec_add_folio(lruvec, folio);
> +		/*
> +		 * Put folios that may have missed folio_rotate_reclaimable()
> +		 * at the tail to avoid cold/hot inversion.
> +		 */
> +		if (do_rotate && !folio_test_active(folio) && !folio_mapped(folio) &&
> +		    !folio_test_dirty(folio) && !folio_test_writeback(folio))
> +			lruvec_add_folio_tail(lruvec, folio);
> +		else
> +			lruvec_add_folio(lruvec, folio);
> +
>   		nr_pages = folio_nr_pages(folio);
>   		nr_moved += nr_pages;
>   		if (folio_test_active(folio))
> @@ -2135,7 +2144,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>   	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
>   					 lruvec_memcg(lruvec));
>   
> -	move_folios_to_lru(&folio_list);
> +	move_folios_to_lru(&folio_list, true);
>   
>   	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
>   					stat.nr_demoted);
> @@ -2246,8 +2255,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
>   	/*
>   	 * Move folios back to the lru list.
>   	 */
> -	nr_activate = move_folios_to_lru(&l_active);
> -	nr_deactivate = move_folios_to_lru(&l_inactive);
> +	nr_activate = move_folios_to_lru(&l_active, false);
> +	nr_deactivate = move_folios_to_lru(&l_inactive, false);
>   
>   	count_vm_events(PGDEACTIVATE, nr_deactivate);
>   	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
> @@ -5115,7 +5124,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   			folio_set_active(folio);
>   	}
>   
> -	move_folios_to_lru(&list);
> +	move_folios_to_lru(&list, false);
>   
>   	walk = current->reclaim_state->mm_walk;
>   	if (walk && walk->batched) {

-- 
Best regards
Ridong


