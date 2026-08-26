Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 376CDC61DB9
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 01:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11FA66B0088; Tue, 25 Aug 2026 21:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1346B008A; Tue, 25 Aug 2026 21:46:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A536B008C; Tue, 25 Aug 2026 21:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2B3E6B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:46:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 065138011E
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:46:21 +0000 (UTC)
X-FDA: 85141730562.17.2746C91
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf26.hostedemail.com (Postfix) with ESMTP id 291D1140004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:46:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2kDdgKCD;
	spf=pass (imf26.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787708779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFA8gg4dXqO5eQ3Z8uhoSt39gt9y9DRKmtEs9LVCGbE=;
	b=LzIHiE45yVXL1szEPlKK8PWIsZKrW7szeyCLn/zoi1bW+HYdIOC9Nx6KqfVtg74FgnS/Jx
	yH+SSjVx4SohraB7kr8NyYWhluOIUUgguPNnEIhzNIncx9UHXarZN6cQrGArlgCPCQMUbJ
	QmBAqOSOwNYfMNbMM0thN+ebtBSxZss=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787708779;
	b=yW1gNvQoi0AuW9epeuT0iIYU24aupl9+CnBJOlR8BIrOKYjs6V54H+Ea+Fo5MhQ5puPpYn
	9by8dRLY1OCH9oJp79sDzyM1azHqSydXRhZEUr4cltxhkrGph/q3SF0Ut9/GHgRLL9NTKE
	jNy6fjm/I4hxivH/eXUvLaysuEr5dDc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2kDdgKCD;
	spf=pass (imf26.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=TFA8gg4dXqO5eQ3Z8uhoSt39gt9y9DRKmtEs9LVCGbE=;
	b=2kDdgKCDMdGoIbhTaF3zE1+No3dQ1vaJ/+5famVqMY51YU9VWaYD/+nBgazTKGSTDsT+980PG
	eTlc5iw7TG79G7i4+olp6ThK21Husf+OfbBlXMHCo0HT/O5HUG1B7CHqv5COzxDFQJ4vRHXvgWJ
	/PZqVYjNGG3lBxpHPtpYFeA=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hV6fy5P50znTtT;
	Wed, 26 Aug 2026 09:35:54 +0800 (CST)
Received: from whupemk200018.china.huawei.com (unknown [7.152.184.119])
	by mail.maildlp.com (Postfix) with ESMTPS id 5FFFB40578;
	Wed, 26 Aug 2026 09:46:09 +0800 (CST)
Received: from [10.174.177.15] (10.174.177.15) by
 whupemk200018.china.huawei.com (7.152.184.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 26 Aug 2026 09:46:08 +0800
Message-ID: <ce6be959-58df-4138-bb35-01a1785a91d3@huawei.com>
Date: Wed, 26 Aug 2026 09:46:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: mawupeng <mawupeng1@huawei.com>
Subject: Re: [PATCH] mm/hugetlb: fix missing migratable flag on same-node
 hugetlb migration
To: <david@kernel.org>, <muchun.song@linux.dev>, <osalvador@suse.de>,
	<akpm@linux-foundation.org>, <baolin.wang@linux.alibaba.com>
CC: <mawupeng1@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260707110254.3147686-1-mawupeng1@huawei.com>
 <fa60a766-6cc2-4db6-a38c-9a8e33925eda@kernel.org>
In-Reply-To: <fa60a766-6cc2-4db6-a38c-9a8e33925eda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.15]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 whupemk200018.china.huawei.com (7.152.184.119)
X-Stat-Signature: ids354r7qsjnw1yt4nhdmk8w95jh6jcy
X-Rspamd-Queue-Id: 291D1140004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787708776-213937
X-HE-Meta: U2FsdGVkX18rj2bmsDJeJvWSgviiwF3d9720cgG/mB7aVMO1E1GdmzQBQmvWvNtXU9aFl1gDHMIBpp7GyhRwDnckwbx0lpXi3JQxSl8Br5mdtV8a2nlKOnmPPrkSSQ0cZSpO50b3iqKB4ozm9R4Jx79cMkTGDMf1v6diqoCWtK7T0xU05UnfoCFY0UPKECULKKUCP61ZkVGkLIgW6SEuP701v9zKLlbSTsMbqTDi8/daJ4fQ+mdappA9ofsfY3Aof39ln3ThWgNzoSLU+djXIwU34nbFEwLUlaJD3QpTfb/lXtuLUJa9J3z8nLOVlzEgz3orYiylNntkdps9Oits21jCaOTIy9e6WGjyZDLu51ycKuVgxKIjyctX+nArYN2WkYEPhbCLiIxBKVazKDIJ0YirXBCMd9laauBD8iTTJ8+AkmKH3T+vQ5wsW4SW2ofuQXg5cfWsr/SXMCAf4Wn/9V2FSFw0MfBOmOOtfgG0cqL/vX2PPG73rh/ghE072YRXvIQO7GVCa5jnZP7qibYbMm8+MMYeGHwscGdGYVKXwwLlbFthXPgFfiEcigHMkDN2w1d+OHT4X+G4ciP9lsHfgUH8zTFW91imkf2MKXBlBZSfo0usTKJK3w7EKTgVlghEw5up7X1j9nchH8mcQZTbRps9iNN7MNvkxXjLv8ZogkHYUOpMBrucc42TqbaKbN32tYR19LY80hzp0NYFUTL7+0eEPei/TV8DGzTzkYheW/PokN9VpVX29is9/MaFX/6UZLU0QTRJrsY948u4NF0UQmlLs4PUSyS2+TBlMcIMliXuj0TT9kBoXglnjOr5WRloP5eE7O7ObVAOvpSlqTqzoMkUcpAPkhHRWMTmu5ze8aX92yxuBdfCaEFA7TsPbDQ9WPt5FKo/THqQ3IplctjM0lAJOPkEfF3P/R8s6u8sFq7iJGoJ17W89voUoqK32WH94pxHkD46Uvn2dzXcKLd
 Y9ncHml8
 hH1RcC4/SPuXdeglp5TbaJmdtxq69d6PuVje0CTnlDvEvmXMgBE/WXAhyHnNC3Gp9MvhwCiyhrbnDZdpNf25qtsQaGm0kpri4WJyjpn7wABkwod1qrFVqtdHpHPHJzTsS7vjoTxXjj36eYHyMF5RbkGKDOHaUM8QBwF3KBEtT5/eh5k6uXfcdliluvDwr+lYPX9OuT2K9OTJUtXKP0eJmBT1oGsS6/26weUsnYQq/zSOgFFjqaxvSAsRgzXmFGX/BbqhprTic1CTVA4QvRWN+Y+I7A7o4fRGCEqqLp2SfoKRwpULUyjabUb/UstToJcj9a2WRhdpcjFeNDCngxh9JZDHiheOekEY8ogn/9CY3/fGYxso=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 周二 2026-8-25 18:27, David Hildenbrand (Arm) wrote:
> On 7/7/26 13:02, Wupeng Ma wrote:
>> Commit ba23f58de896 ("mm/migrate: don't call
>> folio_putback_active_hugetlb() on dst hugetlb folio") moved setting of
>> the migratable flag and active-list placement from
>> folio_putback_active_hugetlb(dst) into move_hugetlb_state(), so that
>> the freshly allocated destination folio is handled where allocation is
>> known to have succeeded.
>>
>> Unfortunately, the new code was appended after the existing
>> temporary-folio block in move_hugetlb_state(), which contains an early
>> return added earlier by commit 5af1ab1d24e08 ("mm/hugetlb: optimize
>> the surplus state transfer code in move_hugetlb_state()"):
>>
>>   if (folio_test_hugetlb_temporary(new_folio)) {
>>       ...
>>       if (new_nid == old_nid)
>>           return;                       <-- skips the new code
>>       ...
>>   }
>>
>>   /* added by ba23f58 */
>>   folio_set_hugetlb_migratable(new_folio);
>>   list_move_tail(&new_folio->lru, ...&h->hugepage_activelist);
>>
>> When the destination folio is temporary (i.e. the hugetlb pool was
>> exhausted and the migration callback fell back to
>> alloc_migrate_hugetlb_folio()) and the migration does not cross a
>> node -- the common case, and always true on a single-NUMA system --
>> move_hugetlb_state() returns before setting the migratable flag or
>> adding the new folio to the active list. The destination folio is
>> then installed in the page table but cannot be isolated afterwards,
>> since folio_isolate_hugetlb() rejects folios without the migratable
>> flag; a subsequent soft-offline, hard-offline or memory-hotplug
>> offline of that folio fails with -EBUSY.
>>
>> This was reproduced on a single-NUMA arm64 VM: a second
>> MADV_SOFT_OFFLINE on an already-migrated hugetlb page returned EBUSY
>> and logged "hugepage isolation failed".
>>
>> Keep the surplus adjustment, which is the only part that depends on
>> the node crossing, guarded by `if (new_nid != old_nid)', while making
>> the migratable flag and active-list placement unconditional. This
>> preserves the cleanup intent of ba23f58 and closes the early-return
>> hole.
>>
>> Fixes: ba23f58de896 ("mm/migrate: don't call folio_putback_active_hugetlb() on dst hugetlb folio")
> 
> Agreed, let's CC stable.

Thanks.

> 
>> Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
>> ---
>>  mm/hugetlb.c | 14 +++++++-------
>>  1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 571212b80835..cafadfdb63c0 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -7211,14 +7211,14 @@ void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int re
>>  		 * There is no need to transfer the per-node surplus state
>>  		 * when we do not cross the node.
>>  		 */
>> -		if (new_nid == old_nid)
>> -			return;
>> -		spin_lock_irq(&hugetlb_lock);
>> -		if (h->surplus_huge_pages_node[old_nid]) {
>> -			h->surplus_huge_pages_node[old_nid]--;
>> -			h->surplus_huge_pages_node[new_nid]++;
>> +		if (new_nid != old_nid) {
>> +			spin_lock_irq(&hugetlb_lock);
>> +			if (h->surplus_huge_pages_node[old_nid]) {
>> +				h->surplus_huge_pages_node[old_nid]--;
>> +				h->surplus_huge_pages_node[new_nid]++;
>> +			}
>> +			spin_unlock_irq(&hugetlb_lock);
>>  		}
> 
> The return was really rather hidden, thanks!
> 
> Can't we instead just turn the "return;" into a "continue;" ?

There’s no loop in move_hugetlb_state(), so continue won’t work there. But I understand your intention. 

To be honest, I’m not fully satisfied with the nested if either, but I haven’t found a cleaner way.
goto, or extracting the surplus move into a helper, feels like over-engineering.

> 


