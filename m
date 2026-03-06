Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 114C9F0183A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 14:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 372446B0005; Fri,  6 Mar 2026 09:12:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F6286B008C; Fri,  6 Mar 2026 09:12:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F80C6B0092; Fri,  6 Mar 2026 09:12:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FC506B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 09:12:47 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 871428BFA4
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:12:46 +0000 (UTC)
X-FDA: 84515829132.03.42F85E5
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id B258B40003
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:12:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rqoyaOT5;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772806365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MAP4Rjii6xkTggMoAmMDYz72FvziKWhbp6xINy4uGD8=;
	b=8c57CdYP2xfLc/zmLC1zVjCzxjvXUleRlIyhygkCDuG2nhhWpsHsoojPcsM8+nYtS6t6ot
	m296FQkaotJJUwzV9MvTshbMzXEkRjFV8asYgZWqeiJK4GHdAJi32A/+2K75w76bzkBRlP
	LleETNUtXV61eYMCzL5xKlTnl1TST9E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772806365; a=rsa-sha256;
	cv=none;
	b=NLdrNNv6jYxlxhthVWEzrH3WX78qlx/LzoU0RX5dvX3NSzuILUZhixL/KFUyD06ohfwFWu
	BFFDE/FBWe4R3+Pok2dIOYL/Dsdk50UFgi5BXlpf2aczgvLAJqS3pfhS2MSraMoY4aScu+
	IKl50aua9UophKegiqe8kNGGYr+V3Wo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rqoyaOT5;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <64051a59-680f-40ae-b291-b884aeb7c77b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772806362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MAP4Rjii6xkTggMoAmMDYz72FvziKWhbp6xINy4uGD8=;
	b=rqoyaOT5KbnqR2SnrcRvZAOSoLhGhaPKpaJ1Ui7JbYfNxtQIM3ismlBjssvTQVI1RQuCrN
	c0baD+bcREKWiBdE5V7ZeWpLATpSAEBkpBVH+eY2Gdhq+xpVZ9vtOgdItWaSy6io+hiw/a
	7q0MXI/cUS9F91jrNug7DOPDOXJTNMU=
Date: Fri, 6 Mar 2026 17:12:38 +0300
MIME-Version: 1.0
Subject: Re: [PATCH] mm: migrate: requeue destination folio on deferred split
 queue
Content-Language: en-GB
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 ziy@nvidia.com, linux-mm@kvack.org
Cc: matthew.brost@intel.com, joshua.hahnjy@gmail.com, hannes@cmpxchg.org,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260306133556.2051251-1-usama.arif@linux.dev>
 <ab22e50d-3af0-4acd-9d7a-a0e86d0c4fbe@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <ab22e50d-3af0-4acd-9d7a-a0e86d0c4fbe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B258B40003
X-Stat-Signature: 8psspqdj5hqfidz88oyu8rd55yati5ci
X-Rspam-User: 
X-HE-Tag: 1772806364-681112
X-HE-Meta: U2FsdGVkX1/bj7mWUTGa/6ujuiO5VDKOk1aDfZ1O3Bsp+7rdzEnPfyx/2gqDG3MFKmTm3iSFZRyLKWve7Knh84Hjs+RSnG3KdC4kWrT6cdjGKLxKsoeHmpQ5JKryBW4q48nKZJgXQjk979vrnpYjG9TOtEzJj16KWwoRiYsNKelvbpdqL61BjHiq82DNk6a07o6fxL8wmCVU+KSn4HovyEUQvJEAX/LCtVFNRDfcZUe1KZY/0d8l9fikNgDCWckO8P5vugShkCGQDVNJb05jouSrQFRn7ksGNqkWP/mxypziSwo3G04C3YoxY3KkZ6A+nZnylcA55TPlsdWWVZJ/LqdL/hx/CKOA6R0NKSrgAJHKGiGvV+RlOccznLwhr6FQL9iEpm1KVwZf+ddMf0F5n+ZXLGcD7x3yOaoTAbu/50aySeECCN6oZwX0NNWNQA3DOXH9me4SsePAgawZ9tNbVD8EI0QcgniLB60H7rrCK+RqdUq/PLJyyQ7k2eqBE1roxHVgSnC2E+4tDM3gbE3D1l9ryo6ndxza6zuVCbfiBEMokEL2teLQGd5ep3YbTKDrYK3MYvHLNshfjkWMLBlsh1OkvIZatBpXorZ+7n8Oij3aszZA+D3o5QYRVWgxadjeixdWgoWtlqHcO9nQPDY409D4p3V4SQaMIN+h9nM4rHtpsBP1Nmv4b8AYFvA59H828VLcVZJjG5z6ejaoNzt/5Psg+ADCjc0IFvDRQTEfGqFZ8lr/4QoTNRnote15J5VSVe65xhvqDVU8FWbPx9uL2k8mnkHIESOr52HdOMjzmPQ9PDBH7VNJf9F1YrBfphKouy9sn7EnUGvAVwbYvcHB4q8Byd+BTToFFXi4D0RYK2GYC+qUaOTq2m8zYMOXWnd83bjrKpVJhEtXrt64fQ+gjzwMOisdoIDl8WIYROcnpuH2uwbNTOXHO2CnzHQgWzmh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/03/2026 13:49, David Hildenbrand (Arm) wrote:
> On 3/6/26 14:35, Usama Arif wrote:
>> During folio migration, __folio_migrate_mapping() removes the source
>> folio from the deferred split queue, but the destination folio is never
>> re-queued.  This causes underutilized THPs to escape the shrinker after
>> NUMA migration, since they silently drop off the deferred split list.
>>
>> Fix this by calling deferred_split_folio() on the destination folio
>> after a successful migration, for large rmappable folios.
>>
>> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  mm/migrate.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index ece77ccb2ec0..98d0a594f7b7 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -1393,6 +1393,17 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>>  	if (old_page_state & PAGE_WAS_MAPPED)
>>  		remove_migration_ptes(src, dst, 0);
>>  
>> +	/*
>> +	 * Requeue the destination folio on the deferred split queue if
>> +	 * the source was a large folio that was on the queue. Without
>> +	 * this, NUMA migration causes underutilized THPs to escape
>> +	 * the shrinker since the source is unqueued in
>> +	 * __folio_migrate_mapping() and the destination is never
>> +	 * re-queued.
>> +	 */
>> +	if (folio_test_large(dst) && folio_test_large_rmappable(dst))
>> +		deferred_split_folio(dst, false);
> 
> Doesn't that mean that you will readd any large folios, even if already
> previously taken off the list after scanning?
> 
> So I am not sure if your "if the source was a large folio that was on
> the queue." comment is accurate?
> 

Yes you are right. How about something like below? We also won't need to check
for anon and non-device folios with this as we only set the the flag if it was
already on deferred_split list.


diff --git a/mm/migrate.c b/mm/migrate.c
index ece77ccb2ec0..9e0780d380e4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1137,7 +1137,9 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 enum {
        PAGE_WAS_MAPPED = BIT(0),
        PAGE_WAS_MLOCKED = BIT(1),
-       PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED,
+       PAGE_WAS_ON_DEFERRED_SPLIT = BIT(2),
+       PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED |
+                         PAGE_WAS_ON_DEFERRED_SPLIT,
 };
 
 static void __migrate_folio_record(struct folio *dst,
@@ -1373,6 +1375,15 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
                goto out_unlock_both;
        }
 
+       /*
+        * Record whether the source folio is on the deferred split queue
+        * before move_to_new_folio(), which unqueues it via
+        * __folio_migrate_mapping().
+        */
+       if (folio_test_large(src) && folio_test_large_rmappable(src) &&
+           !data_race(list_empty(&src->_deferred_list)))
+               old_page_state |= PAGE_WAS_ON_DEFERRED_SPLIT;
+
        rc = move_to_new_folio(dst, src, mode);
        if (rc)
                goto out;
@@ -1393,6 +1404,15 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
        if (old_page_state & PAGE_WAS_MAPPED)
                remove_migration_ptes(src, dst, 0);
 
+       /*
+        * Requeue the destination folio on the deferred split queue if
+        * the source was on the queue.  The source is unqueued in
+        * __folio_migrate_mapping(), so we record and check the state
+        * from before move_to_new_folio().
+        */
+       if (old_page_state & PAGE_WAS_ON_DEFERRED_SPLIT)
+               deferred_split_folio(dst, false);
+
 out_unlock_both:
        folio_unlock(dst);
        folio_set_owner_migrate_reason(dst, reason);

