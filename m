Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28593D7308A
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 04:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E9BF6B0005; Fri,  3 Apr 2026 00:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29A946B0089; Fri,  3 Apr 2026 00:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B0336B008A; Fri,  3 Apr 2026 00:24:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07FDE6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 00:24:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B68A58B5C
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 04:24:26 +0000 (UTC)
X-FDA: 84615952932.15.F49056E
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8C51F180005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 04:24:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NHnh5hQY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775190264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cErbKdi32QMH2dzlzoL5zUK31mzqGlUsJK8tpfLDBsY=;
	b=C/CxKJ3Yxl1B1VsZpy+xNTPTNGqH+K6k6JAlxjzlEFHrxgA2krZIXl5hgi/46qwNoUAjI4
	WbgvQUU+8OeXo5q7WXYjUACRVRyKSFB4DOt/17KZfEk0C1+p4aQxlekqilOOt+JKqf5i4c
	AkA3hGs6uR1gvtE8SP/v9SF+2zZJdQ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775190264; a=rsa-sha256;
	cv=none;
	b=xJ9FbWxvsORrEBlj8pbEFnFrQRukcucbZz1cOdEb7qjmTuoyycYt3Dj1mQgzfMv4bzcBoc
	BHivRO1SbJcMoHL+rp3CiZiZwIefeKpROngJErouFcIyK+yzli6dU4C5bOBr/vE+TBibIs
	9hudWGDyC6A8mkR4cL+4elAMI2pCYlU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NHnh5hQY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <4bb6d46b-afc8-4d35-952e-8301df5026ee@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775190258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cErbKdi32QMH2dzlzoL5zUK31mzqGlUsJK8tpfLDBsY=;
	b=NHnh5hQYagWyfnu4knCBFIoHSA96++GT6HlgM1Q+86YOBBRPB6jqSGhB95MtgzUu+S5E57
	HJW4NldnRpgAWyHkf16HAfxbMYbu3uSBws19t8jIhLOP4Bwy0NUIPUB2PMl9SYeFYL4dgz
	PrlXplwDn3JxTrfML6rm4xQxqk6T1GY=
Date: Fri, 3 Apr 2026 12:24:04 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable 1/1] mm: fix deferred split queue races during
 migration
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 david@kernel.org
Cc: ljs@kernel.org, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, richard.weiyang@gmail.com,
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kartikey406@gmail.com,
 syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20260401131032.13011-1-lance.yang@linux.dev>
 <C4A8301D-C76B-430B-A6A6-8B642B80FE2E@nvidia.com>
 <FB71A764-0F10-4E5A-B4A0-BA4C7F138408@nvidia.com>
 <20260401161958.38ab50f44e7629e6475d3eca@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260401161958.38ab50f44e7629e6475d3eca@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8C51F180005
X-Stat-Signature: ywmic8m3f14gou8ij5fh887rh68j111w
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775190262-955857
X-HE-Meta: U2FsdGVkX18z9JEGo5/lOdtH6aAFtJ83YE+VurOXa84Lzo1NkNv0ukIpX1MLQoTgANwG2+zq/02vBppcKUfJim3kJ/MLKvmgceyYMuOqJ127MjV+o0+o77mrtOpXl/oXm49j9eIwTybVU0g3wihiOaxFXLXvZfTszzyOkSAPaK1mpD/gkjaNbVCvy3y36DTTx2k6iQs5hZYtd4eHrGiLxhYbH8LN/uczobUfZTPbLhtNVHRD9cZaNBT12D7u8FWTI/un8gC/+eEVZ7z/oocjpFBRlTIf9uq9TyG9P+82WquI34b/WpLoAI38sGkUVIXNrme4XAoG9xFjUeXjeWpmy0tR81rddjT+uXpsbW6IJg/gggR/iNAs12vDCA7XDTX79f1oI3KoEXqJadGWS1LZfxEAY+uLcl5lfh3ibwO6ZG2tjubwx7+tAmu6tV3fceT4QYcC1c+kTOIws5sckQSUI980W2/knzZDPaQ5jO6aJV4+OyJyB2jn56s0VTP/4j2oYtCDgGz6s5tcI+B1YdLpygLg1Z72BGT4sFe2OuQZuDhhTUvcMGuGqnAkz4t67RYnek2AsKuqHfGnZy28Dc21RPzRl0TMf72rnDj82vKUv4OcnlxJxDV3TyK4nP0VmJF2qecHixJQxFWS8GKUI426FUCxQS1pzDZLlT9r+9ryi1QXQPE5zkoA0bseZwfVnd8UPbnKFhgIUuZsGN4kHbv9PONjCr7dcPeZgaxRnrgxQBxMgUsL+Dl2xED7bbtQdob1E9rn8pri9rb3alj4nTr0l1h5e54xVheX4sFG8gULczkJadaimM05VFbtKWz767+rkm4As4Ake6cS4uVf2rhrrlKvxh8L56UWfWunKX/ON+4FakzNnA+ZpZSwMLGpwIXVI5jaHf+TQdfRPvHOJWZ4lqiT1n0jwhEJPafvk7KO1cZtCqxftWThIa7/o8pL1R/ZrPA0tJPw7hASaQG/KjW
 RVX2e76X
 S4Ga/Q0zt3Tq+U8ll4QlzXNph5v7Gs1sKMHpoh3ZZLgUACmokL2mjbEwZ4CB5YeX1SHRjUty7kAgowbmv+RdOrCIaiX8J18SiWhWVUMlkoe89j6CiIva1YGSCyYi7uMq7KVEXQasM5Yks9+z8uWJf3OgUIyaiIVYOl+V1I8dCAapPP4N0uALDccj2FPAH2QpZfXaDsus8TdfhnajfF9Lt5V3Cg6hIOGm7+XrynqNPMMEYMj8Hs8vL1dnlyBAAuvk6sha/VbX/mOwP6OJAnjgpNipDqYwlar8izzoaTULOQIo2gCjG060Js/XdHZcxNsYiY9jfl5XUZ/5qiQu0BdBRrDHkl44IcM0T3fIUIH+uJqhDGU9hLQopFYtOZ3QLiJYfVdDYby9+fi+cKFSaK/MgkeXe5gokgF4Gg+UDKskpJJ7TtSCkgqnKVbJeBJdlDdNCp7+ZafAHRQgU7DoW6VerrBl9AE/+ZJu6oMFXsQy50gAawV/ka7IGn79awxUpnJz6mFewkct6+UDS/FzINWd0UCU8kFkNBHwvKz6TFNO/FHrKAdNQxgtwwfNWSJhffalpj0dAXrrd9Hd4wgTCjdod+ujZ+p8Y1SOLCUh5/EGwPu+g82HGNzfVCBfzB6nj+WKXVzjsyPWHkOSf4D8Jy/BwU3TrGHsRKyjWqJrfhXLOdVrOJNwb0CKzK0F8jyULtZajMQySMRSaFajKPx+RHX9w902Z1OymMwGZHM1LL1WJblnK5wL0Pf+t8NPrXLAEo+TulKlxkCI36pLb3OEtPHtGsJ1oK+14sEh2zmylEs3+c9LCrjnxlDlpnrrDjhKgfbJXDVp3iSEBDvnYAWycvmDQ8DBssA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/2 07:19, Andrew Morton wrote:
> On Wed, 01 Apr 2026 18:55:48 -0400 Zi Yan <ziy@nvidia.com> wrote:
> 
>> Can you apply the fixup below to move the comment? Lance told me he
>> would be away for a while, so he could not send a fixup to move
>> the comment.
> 
> Thanks.  I folded that into Lance's base patch so here's the whole
> thing:
> 

Thank you all!
Lance

> 
> From: Lance Yang <lance.yang@linux.dev>
> Subject: mm: fix deferred split queue races during migration
> Date: Wed, 1 Apr 2026 21:10:32 +0800
> 
> migrate_folio_move() records the deferred split queue state from src and
> replays it on dst.  Replaying it after remove_migration_ptes(src, dst, 0)
> makes dst visible before it is requeued, so a concurrent rmap-removal path
> can mark dst partially mapped and trip the WARN in deferred_split_folio().
> 
> Move the requeue before remove_migration_ptes() so dst is back on the
> deferred split queue before it becomes visible again.
> 
> Because migration still holds dst locked at that point, teach
> deferred_split_scan() to requeue a folio when folio_trylock() fails.
> Otherwise a fully mapped underused folio can be dequeued by the shrinker
> and silently lost from split_queue.
> 
> [ziy@nvidia.com: move the comment]
>    Link: https://lkml.kernel.org/r/FB71A764-0F10-4E5A-B4A0-BA4C7F138408@nvidia.com
> Link: https://syzkaller.appspot.com/bug?extid=a7067a757858ac8eb085
> Link: https://lkml.kernel.org/r/20260401131032.13011-1-lance.yang@linux.dev
> Fixes: 8a8ca142a488 ("mm: migrate: requeue destination folio on deferred split queue")
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/linux-mm/69ccb65b.050a0220.183828.003a.GAE@google.com/
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Deepanshu Kartikey <kartikey406@gmail.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Liam Howlett <liam.howlett@oracle.com>
> Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Usama Arif <usama.arif@linux.dev>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   mm/huge_memory.c |   15 ++++++++++-----
>   mm/migrate.c     |   18 +++++++++---------
>   2 files changed, 19 insertions(+), 14 deletions(-)
> 
> --- a/mm/huge_memory.c~mm-fix-deferred-split-queue-races-during-migration
> +++ a/mm/huge_memory.c
> @@ -4542,7 +4542,7 @@ retry:
>   				goto next;
>   		}
>   		if (!folio_trylock(folio))
> -			goto next;
> +			goto requeue;
>   		if (!split_folio(folio)) {
>   			did_split = true;
>   			if (underused)
> @@ -4551,13 +4551,18 @@ retry:
>   		}
>   		folio_unlock(folio);
>   next:
> +		/*
> +		 * If thp_underused() returns false, or if split_folio()
> +		 * succeeds, or if split_folio() fails in the case it was
> +		 * underused, then consider it used and don't add it back to
> +		 * split_queue.
> +		 */
>   		if (did_split || !folio_test_partially_mapped(folio))
>   			continue;
> +requeue:
>   		/*
> -		 * Only add back to the queue if folio is partially mapped.
> -		 * If thp_underused returns false, or if split_folio fails
> -		 * in the case it was underused, then consider it used and
> -		 * don't add it back to split_queue.
> +		 * Add back partially mapped folios, or underused folios that
> +		 * we could not lock this round.
>   		 */
>   		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
>   		if (list_empty(&folio->_deferred_list)) {
> --- a/mm/migrate.c~mm-fix-deferred-split-queue-races-during-migration
> +++ a/mm/migrate.c
> @@ -1384,6 +1384,15 @@ static int migrate_folio_move(free_folio
>   		goto out;
>   
>   	/*
> +	 * Requeue the destination folio on the deferred split queue if
> +	 * the source was on the queue.  The source is unqueued in
> +	 * __folio_migrate_mapping(), so we recorded the state from
> +	 * before move_to_new_folio().
> +	 */
> +	if (src_deferred_split)
> +		deferred_split_folio(dst, src_partially_mapped);
> +
> +	/*
>   	 * When successful, push dst to LRU immediately: so that if it
>   	 * turns out to be an mlocked page, remove_migration_ptes() will
>   	 * automatically build up the correct dst->mlock_count for it.
> @@ -1399,15 +1408,6 @@ static int migrate_folio_move(free_folio
>   	if (old_page_state & PAGE_WAS_MAPPED)
>   		remove_migration_ptes(src, dst, 0);
>   
> -	/*
> -	 * Requeue the destination folio on the deferred split queue if
> -	 * the source was on the queue.  The source is unqueued in
> -	 * __folio_migrate_mapping(), so we recorded the state from
> -	 * before move_to_new_folio().
> -	 */
> -	if (src_deferred_split)
> -		deferred_split_folio(dst, src_partially_mapped);
> -
>   out_unlock_both:
>   	folio_unlock(dst);
>   	folio_set_owner_migrate_reason(dst, reason);
> _
> 


