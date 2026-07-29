Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CD23C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 711A86B0088; Tue, 28 Jul 2026 23:37:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0B66B008A; Tue, 28 Jul 2026 23:37:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9A66B008C; Tue, 28 Jul 2026 23:37:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3366B6B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:37:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB2FC1A05E1
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:37:54 +0000 (UTC)
X-FDA: 85040405268.20.7FF0E3A
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf11.hostedemail.com (Postfix) with ESMTP id AC7474000E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:37:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cdQJD1tx;
	spf=pass (imf11.hostedemail.com: domain of yujiacheng3@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=yujiacheng3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785296273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j6sG71vk0UOw32qt1L40plvuAIirX2vWQN+w9Z12geA=;
	b=ky/D7A5A26v5fhfXC4aqevLH3h2YVJQk5a48MAmlNiL4scrtBFJ/4uiWHqq9JQjmmLRoPR
	WYkz9nquBa8qILmfplt98zIb3000G4DkLoyyAFzZFAIS8ml7IXxUsoX7XObMXavaGYu8uK
	0ecsY7GgnsYpuT43dP2cSQY58jEdjXc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cdQJD1tx;
	spf=pass (imf11.hostedemail.com: domain of yujiacheng3@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=yujiacheng3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785296273;
	b=WwjGbPHJzCCGJK4+XobDr/Aj+oU7P9ZKD3LVttre12+gjoePPbRxTAMYBv18AvfyIbOy2Q
	TelWosJf4ve28JHAAGNnEzn1BhFeTv8bUxsAOuGZM9VH5BjDrbneJulWg1ZaIa8tAkxkSN
	OWnTmulAF9yF+C4DHdD8RvPNOOepqEc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=j6sG71vk0UOw32qt1L40plvuAIirX2vWQN+w9Z12geA=;
	b=cdQJD1txNNKR2aB8cEiLs7bXbkbf49HyUoAL3sF8g8gCBlFDatAjuu2IR3JFkVam7BCVAfkM4
	Tv/nnrmui2w9xctmaSWW9CwyPTbABmTwWBWYwJHQM8r61yG0yZalNQ3W68kyGGJ7DHAF+IlrxF/
	ARvEAEyXObf1rDiV8etl7OA=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4h8yTG5sxGzcb0T;
	Wed, 29 Jul 2026 11:28:02 +0800 (CST)
Received: from whupemo500009.china.huawei.com (unknown [7.152.184.116])
	by mail.maildlp.com (Postfix) with ESMTPS id ECA1F40538;
	Wed, 29 Jul 2026 11:37:43 +0800 (CST)
Received: from [100.103.109.247] (100.103.109.247) by
 whupemo500009.china.huawei.com (7.152.184.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 29 Jul 2026 11:37:42 +0800
Message-ID: <b144c707-7d74-42b7-9d88-47283f487678@huawei.com>
Date: Wed, 29 Jul 2026 11:37:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: downgrade final i_blocks check in
 shmem_evict_inode() to pr_warn()
To: Baolin Wang <baolin.wang@linux.alibaba.com>, <hughd@google.com>
CC: <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <liuyongqiang13@huawei.com>
References: <20260728091014.3876715-1-yujiacheng3@huawei.com>
 <fecfc5b3-86af-4c3d-af0a-d1084fb3650d@linux.alibaba.com>
Content-Language: en-GB
From: Jiacheng Yu <yujiacheng3@huawei.com>
In-Reply-To: <fecfc5b3-86af-4c3d-af0a-d1084fb3650d@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.103.109.247]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemo500009.china.huawei.com (7.152.184.116)
X-Rspam-User: 
X-Rspamd-Queue-Id: AC7474000E
X-Rspamd-Server: rspam01
X-Stat-Signature: khu1ndxoge9ticweatos5s8f86xswjt6
X-HE-Tag: 1785296270-929867
X-HE-Meta: U2FsdGVkX1+rKADo9ZmcS8N+Nm77y3se5vfJGjRoO/goI1kZkDeHplZv91KwWYjIFix8fy1fPbgPXmNoWfjoQ8D0tvBss9bmkzDaNLASqY9mchvoIl1TOHE2ATTbRPcbdDAzAD5EwXcZoSZBLM1vZtBFASsZ/kdp2IPvZn+xMeSA8emcGe9Ol3M7/tH9Rl/0rhqk9fircURKbXFjBE62ZxO3xp1TKkoBrjv8Z/UZ5Ysu3sWmw2S17+Z4psC7bFTumiBUPqqqKJDBNUwMd67E98ALuOoM0akLFbqNGQu3LBes0oTQf9rM/ikaIfs7z5dYRd5p4Z7ZOYK5Mke+3Sabd1K0V1MRvmPljcJf/g9TtzQIku3fMRCiYoOy3C93EQilgG5Q5z7Iztu64VS48ZxkWGfrTvztwZWcYZUv+0RBUK412ocWAzkYhdHOXPl3vmUKfGGtyICAJRI1+AqMMAauo2jN1fMX5uknikmIAWfGSvuKkmRGQzZGGOE5AZTPW96vNeVOvcItzwngLqXTULzbn1mP9YaaPNVEDRf4waoETmBzroltaSZV3c13HOZG8udaTUH/+HHnwxtHqnXGy1Cdh4vkwkgvsYM/IIPxpou4NFg9BmuvXX+HGemtDYMWofjkfqwFVBdOOvga5jeOEZseQjmIwNaVXsnyfZJKnTMGcN4ExtMxoEcQksmxOZa8HwqYUBHiQSaZkr0hjmGdHMaBqPcXXHqqR3ALTSYtnQXfCClEa/Alq0AUHGaadN+1ERojON/BG5v+JH3VIMN87r0b8jcvo43lQYTCnczVNE8Cj+6Bc68uFS8UGV1hPP+l66R5McwU6m+KGWn28cnJss4ck38swjyY7nomBNEqjVXDtayNQZ41xSJmR2GC+SeSRfQU5Bwpew2Qyf2rVNlAIdv0pFBuLhp9/7nsBYz9YdDyeYw/s/Zgnx8Q7u3mqBStf49uKvN22Y12cChHMtCZPSN
 OBylCk3E
 D998hif0oVhUFZHu51HZa/nZZxOm9VFKx8C0H0HmXNFC27KQ5yvx8207skEZN8CeGFZzVQyXGxvrP/aCkXao1S2ftGgdnvULhb1Xco50J+wLgJVWlm7pwZZJyfEfbHw9bF6yowR5Odt70ux02Ufg9PtBryftpq0zIUAVoZDR2xB000Phg9DiVjcj9LEpokMrCbuCkSnRijwHevkxGRDyEk2wxVwh/h62pwvLXY0V5zfvdGyK0kbCIeq6K4TUaQ3FrTWB7vxjFmncc2bW4IZaVKyrZpfeqOPhzvd+tTxVNW/tZ2LobJYhQ6BQKC7MyqNzbPFuHhhfkJ8ixqn5WD+KyDIcayWkJ+4Sz81mHdSAIHSbn18rAvqKYHxHD31sNG4yRCuLxtLZ2ipNG1uSAxpfRnOSo4958COsYQ1km
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/07/2026 11:14, Baolin Wang wrote:
> 
> 
> On 7/28/26 5:10 PM, Jiacheng Yu wrote:
>> shmem_evict_inode() ends with WARN_ON(inode->i_blocks) as a final
>> consistency check of shmem's block accounting.  When it fires, the
>> inode-local counters die with the inode; what may linger is a small
>> residue in accounting kept outside the inode, such as per-mount or
>> per-user charges.  No data is lost, and no corruption follows.
>>
>> On kernels running with panic_on_warn=1, this accounting inconsistency
>> escalates to a full machine panic, which is disproportionate to the impact.
>>
>> Downgrade the WARN_ON() to a pr_warn() that reports the inode together
>> with its accounting counters (i_blocks, alloced, swapped, nrpages),
>> keeping the inconsistency visible in the logs.
>>
>> The accounting bugs this check has caught over the years -- the
>> swapout race described in commit 0f3c42f522dc ("tmpfs: change
>> final i_blocks BUG to WARNING") and the error recovery race fixed
>> in commit 267a4c76bbdb ("tmpfs: fix shmem_evict_inode() warnings
>> on i_blocks") -- are real and should still be fixed; this change
>> only removes the disproportionate escalation.
>>
>> Fixes: 0f3c42f522dc ("tmpfs: change final i_blocks BUG to WARNING")
>> Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>
>> ---
>> One way to hit this race: soft_offline_in_use_page()'s fast path drops
>> a clean, unmapped shmem folio via mapping_evict_folio(), where the
>> xas_store() and the nrpages decrement are not atomic against a
>> concurrent shmem_evict_inode(); the final shmem_recalc_inode() can
>> then read the pre-decrement nrpages, compute freed = 0, and leave one
>> page charged.  Same class as the races in 0f3c42f522dc and
>> 267a4c76bbdb, this time in the under-count direction; reproduced on
>> 7.2-rc4 with madvise(MADV_SOFT_OFFLINE) racing MAP_FIXED replacement
>> of a shared-anonymous VMA.
> 
> Shouldn't we fix the race first instead of adding more warning information?

Yes, the race should be fixed, ant that needs more time and discussion.
Back in 0f3c42f522dc Hugh already outlined the two candidate          
directions -- coherent locking between nrpages and the shmem counters,
or eliminating shmem_recalc_inode() altogether.

I plan to follow up with a fix attempt along those directions;

> 
>>   mm/shmem.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index b51f83c970bb..223484cdc8f2 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1428,7 +1428,11 @@ static void shmem_evict_inode(struct inode *inode)
>>       simple_xattrs_free(&sbinfo->xa_cache, &info->xattrs, sbinfo->max_inodes ? &freed : NULL);
>>         shmem_free_inode(inode->i_sb, freed);
>> -    WARN_ON(inode->i_blocks);
>> +    if (inode->i_blocks)
>> +        pr_warn("%s: ino=%llu i_blocks=%llu alloced=%lu swapped=%lu nrpages=%lu\n",
>> +            __func__, (unsigned long long)inode->i_ino,
>> +            (unsigned long long)inode->i_blocks,
>> +            info->alloced, info->swapped, inode->i_mapping->nrpages);
>>       clear_inode(inode);
>>   #ifdef CONFIG_TMPFS_QUOTA
>>       dquot_free_inode(inode);
> 


