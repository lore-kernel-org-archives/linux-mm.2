Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 998AE1125806
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 13:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2C5D6B0092; Wed, 11 Mar 2026 09:26:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9ED6B0093; Wed, 11 Mar 2026 09:26:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DC606B0095; Wed, 11 Mar 2026 09:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 79BAF6B0092
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:26:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 258FC5668F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:26:03 +0000 (UTC)
X-FDA: 84533855406.30.2F28585
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3215A40007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:26:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DKWFD9TA;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773235561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zIOqQQg32OlTrnoQWipcCb+EJ6IeLqAL0TLWqd691x8=;
	b=ANBb4o0eiKbcA07NLplxrG7OJsCcVj1zgdS7LE2ssPdj8Mta1t0k5wZ/ZcfLkJL0WNxOsa
	OOsW6Qnrmey2ACbH7tfvpugDMuDv/UVej870Ng2+UAGDF3V60Y56jrvqCLJvWOwNLTTuBs
	lKxQjiYNAiEERxZfDezOWfFxiBleTAE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DKWFD9TA;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773235561; a=rsa-sha256;
	cv=none;
	b=OAHAvUx6g+3iaw6y2jqY/JNoyifapVg0JjuhiioCvddOr7bCXQrZ/r7Oy8e4/AXjSr2cD+
	jG8gnK579Asd9X/jNye4y6tiJzYxJF82DkQYxK9cHm9ev0JAWAzAEZ5M/9BzJWlVCATQ/s
	PFsePbIG2rhE8vr4iouaBD7J/SyhNa8=
Message-ID: <f5014cca-9aaa-4bbd-baed-55fa992ef930@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773235558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zIOqQQg32OlTrnoQWipcCb+EJ6IeLqAL0TLWqd691x8=;
	b=DKWFD9TACw0weVBVbNnU0DetKwcOm8iEzA/nO7oGCujBR5njNmkxy83HnRfYNMP8pD0Kp/
	lq4y9WnFV4xKBa0YO8mLbMZSVU/uzjpv7JnXjo6DEpfKoL2hc7SN/nGA0mQhWN+3zgwAz/
	f4nkho1dR6f9IGveQfGoWJs1AF58auE=
Date: Wed, 11 Mar 2026 16:25:49 +0300
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm: migrate: requeue destination folio on deferred
 split queue
Content-Language: en-GB
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 ziy@nvidia.com, willy@infradead.org, linux-mm@kvack.org
Cc: matthew.brost@intel.com, joshua.hahnjy@gmail.com, hannes@cmpxchg.org,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260310105419.3256755-1-usama.arif@linux.dev>
 <946b13be-55a4-4d3e-a931-0793bf22e28f@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <946b13be-55a4-4d3e-a931-0793bf22e28f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3215A40007
X-Stat-Signature: 8mnrszewir6noxf5qa3jn8hq761bz6zb
X-Rspam-User: 
X-HE-Tag: 1773235560-835760
X-HE-Meta: U2FsdGVkX1+Vb32tlTygSCh1aA/IlUuiZXiUWl1f1wRFd02YsFjwxuLhOn+qwVII3M70X6KjeA7O/AKdMxJ0jwC10SMeCfuslilV7JaBBPk2fXbTHj/+TZmF0TL01WQiLPMncDCh20UrUd+GYlUag4qL509bGkev/kUdxV/zwzFdwBIw4F5aigVw4EZX8lD/xq+0bDihc/EzRVCVlWrOiqC6mW3/f51dJIpLZee8nMm4kbh9NYZx3p0GmUL1h5JLPf54Ma1+/xHku5wD/DiI34WkQ49vqIPp6d98lPxseedaWA9NWE6SzD5GyjStXs/drBiyFtp4LmdA4YQgue+YUHBiznYEZpmqaMdctIjMQTIzMyOA14M6mkZZt+q+PtHHZsBLAbBNZ56NU4m0TJJgUX5T9QtPicjBMAPwVK3wXLtOEHx8nNHHnJsKijLu79kx4XDTa+uGwQGRwC7hZLnhdFh1EOEVshZ8ASt85yydghOZJ3eHjsJ2v/kYUkwwE5wpKCuvqW2igoXH8XgEKFrFjkSdqN0Oq/k4D78paP3cIAatu74PmK33RLKEbKQnx4XP3rJXk9AKB+rjvlzxi4e6Vq+dPC9aRg/y0KJrAUFe8RfyryMEaoqpQVeOXzCgQiRmFLs9fk5uYKKHTmR2GWKzy2bHqizS0vNU5l+XF93PAcqhboMEdRjgFp2w63X38LlCcRtyf26yvUMucOGVEvL1Xubhy2oz+BdXXlb4yXW+bM/XXSGJPWz90rzUp+paaNPrJEVZWMNELHdsxMCeeHBnxcJhlNXOZJARIRYnihL/lXB1wYb91qimQDyCXshVlWi7ryfykl+OpkF2PxcrZ5q1mJv7FyqHOrxgcJlFzRgY8Mfvp5c/Lcpf0RIkwJy9+5G7hS4ZQ/G+WTUPoXmpF+66r6/qFz3H+//wv43quQzpfHKPzdHS952j8FFLH+3Vh1MZNXbG7qfduSC3f7mQcbf
 crJtVGNf
 Takp8HkZw05TXjiHX8AU7TCZugHVsoR6I2/Ym12L9R/SA2Pzz31SXxwdTxddmE8iY/ysDc27aIahemtvgyQoEKMitf2zT1jIHYnK/lgWxNCTxh1gT//WOsAOEMIvxyU4wNL1jatcSjxJ0pO7UZU2P6woskBfSFiUnwatxZQz1ACOsaOrelTe2/92/1HHDE+U4yyR0118025aOBgt7IxNl1uZuUVzobgtqaWnL8wEISexeKgph8f4fE8XYuv8WkBPRJVArOuTlZMinxlQN7Xkw+8QN3jEHDf5hZH/vo3U7Isf7kf7nw2TGwlGP6x1UAarbbiwjxnh/55KskZBblOeInKQrcFD1HHcnQrsa/h/WdC0Z4nU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/03/2026 12:23, David Hildenbrand (Arm) wrote:
> On 3/10/26 11:54, Usama Arif wrote:
>> During folio migration, __folio_migrate_mapping() removes the source
>> folio from the deferred split queue, but the destination folio is never
>> re-queued.  This causes underutilized THPs to escape the shrinker after
>> NUMA migration, since they silently drop off the deferred split list.
>>
>> Fix this by recording whether the source folio was on the deferred split
>> queue and its partially mapped state before move_to_new_folio() unqueues
>> it, and re-queuing the destination folio after a successful migration if
>> it was.
>>
>> By the time migrate_folio_move() runs, partially mapped folios without a
>> pin have already been split by migrate_pages_batch().  So only two cases
>> remain on the deferred list at this point:
>>   1. Partially mapped folios with a pin (split failed).
>>   2. Fully mapped but potentially underused folios.
>> The recorded partially_mapped state is forwarded to deferred_split_folio()
>> so that the destination folio is correctly re-queued in both cases.
>>
>> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>> v1 -> v2:
>> - record whether source folio was on the deferred split queue before
>>   move_to_folio() (David)
>> - record partially mapped state and update commit message (Zi)
>> ---
>>  mm/migrate.c | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index ece77ccb2ec0..61013d258eb4 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -1360,6 +1360,8 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>>  	int rc;
>>  	int old_page_state = 0;
>>  	struct anon_vma *anon_vma = NULL;
>> +	bool src_deferred_split = false;
>> +	bool src_partially_mapped = false;
>>  	struct list_head *prev;
>>  
>>  	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
>> @@ -1373,6 +1375,12 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>>  		goto out_unlock_both;
>>  	}
>>  
>> +	if (folio_test_large(src) && folio_test_large_rmappable(src) &&
> 
> I don't think the folio_test_large_rmappable() check is required. Other
> folios we migrate here would always have _deferred_list initialized but
> unused.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 


I have been auditing the THP shrinker code when it comes to NUMA migration and I think we need
another fix for this. I have sent it here https://lore.kernel.org/all/20260311132342.3193160-1-usama.arif@linux.dev/

