Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31A24FCB61C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1C06B00A4; Fri,  6 Mar 2026 11:15:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9619D6B00B0; Fri,  6 Mar 2026 11:15:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89BC26B00B3; Fri,  6 Mar 2026 11:15:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79AFC6B00A4
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:15:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 326C91C8C6
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:15:16 +0000 (UTC)
X-FDA: 84516137832.07.7F01C4D
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf03.hostedemail.com (Postfix) with ESMTP id 434332001D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:15:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ilyx6wsK;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F46BSWUVzTSNMVtPbFqNmwug0wRx85MgEhXeZ2WefSg=;
	b=hUbyFFigxwzooCtWqdo0IgI3pu+00yBioCoQi0ZMCpmYNuIBtvjtwAnTYnUmwkZ3KO7iCZ
	K/e4Q+zdytqpBFEU7WjAlNtO9LdAPgJVW05toL1YIT3vgvYGHIcwuKynJ8SEA6Wg6HkX1z
	H4kocqs+9Su/tP0yhzImQ7WOU4gOW1s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ilyx6wsK;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813714; a=rsa-sha256;
	cv=none;
	b=azikJmSWSmueAKfCh+Nn0vPe1Nkmwpn+gH94CbpjduaNlEbi7QBj/tKzy3yp9kTtZ4GxSP
	HKT1z3suWr2BPyZDn/8Lo3GrXbC0/Ul8GldcJO636JqEDlUFOm6WDdbvgB4VbOz2OLe8vz
	IHWG1ynZNtOwtZdtgyHyQwExfZn2/i8=
Message-ID: <28e48b47-f215-4e4a-b55a-01dbf293ff35@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772813711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F46BSWUVzTSNMVtPbFqNmwug0wRx85MgEhXeZ2WefSg=;
	b=ilyx6wsK0ezghYuXNj+LGWBzh5gjqHMVDVuo4AxTgmeFbqG88SfGgWNXWl8GSj02nrFkHD
	/KanIQP0HSHOvrQZ6kfuzHwAXhRtPy7RUg/q+Z2U5jYPfaW2W0c1aCMX+3OU1I2k6eGseM
	TPmwPA6wGXmBBvt+RIi1t9yozapqjyU=
Date: Fri, 6 Mar 2026 19:15:07 +0300
MIME-Version: 1.0
Subject: Re: [PATCH] mm: migrate: requeue destination folio on deferred split
 queue
Content-Language: en-GB
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 linux-mm@kvack.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 hannes@cmpxchg.org, rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260306133556.2051251-1-usama.arif@linux.dev>
 <ab22e50d-3af0-4acd-9d7a-a0e86d0c4fbe@kernel.org>
 <64051a59-680f-40ae-b291-b884aeb7c77b@linux.dev>
 <993B37FF-29E1-41F5-A1E8-F38B9CD24478@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <993B37FF-29E1-41F5-A1E8-F38B9CD24478@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 34apcmfhd4tkp4qfazejtij59xikgfor
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 434332001D
X-HE-Tag: 1772813713-904482
X-HE-Meta: U2FsdGVkX1/RPqi2pyisdTibd+tRU6gujP2882qJAFmPtAGBi6tB3ay4bo9hu7bhY6gYwOYNExZ3MlwGKRrmp++VUmO0r8yhyZ5mg7oY0DvAj1T1bIL18I762wMiJZselUBj5g6x1ZmxLGX7PjFL4ytj8Qyn5lEAYF8LgWCmYVqrdy5AfvywRkVi2j4kBTc+1tpd7z8QDFa/pz1eijLJ0CL6CvclkSV2U8dohN0UWhBJH5Ll6OQv8qndactGC5Hpa3oB7jgEQb+x4Wr64TG/dcWY8Wc29f1JT5kik70Cfv5rOoCow1+0uTjOLvY2RIobKUc2tjbg7brQXgvClpDznxcivjmHO2IktB8o83yWhO803aTOvut7xs+2wdcgpIoig+hkCyBW6mUFlJX5vYeWmhxxEgSDbCc1+cdKPx+3DMEVagxGjzrMRr/df4ecjV+cmbB2CRm45/uTt2C/sad8BqRpGrnpMxPDpUP/v8jX3u1cNzXApS3N/okm2lIdnmT64goJC0H/zAT3dIRX2faY5luIf0Dwhu08q3sjQpr5E4HsWJ21Zdcsl5k0MY6D7fcn3q4rM37xe+EN/b98kMbh1oY08PXXZOCDTuh7oyjclm2p487623tgtEkTD+FmhlE1HeW1gi/HMVRKpARoeNAj8/bUCEdB6v+fhV1zfLm2z8l6WV9WXo5dD+2o+5nIpofzLWXHVIfO+gsNfNmhEk6vg90yBfqchbYDITsdAq89sbkSgXKvaNRZ9mEJe48f0BLwWK+3pdL8sAfzFTQEwrVFEObRHrPHJNXYsRB/GhG7Zy2KHVR5lUeX4uWMjfMQQXdd0/Y+za2uJDFYUDIx8jwsCs6WKDERVasW/dRq4aiwl6n7u50WKg0GnQWWRe20wBncj8CN7fhaYYHg/cjnxQnjwU/zeUXGK5YVDI6zJF+Ou9ClLGXIAnDwGUGtg5c3J1CP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/03/2026 14:46, Zi Yan wrote:
> On 6 Mar 2026, at 9:12, Usama Arif wrote:
> 
>> On 06/03/2026 13:49, David Hildenbrand (Arm) wrote:
>>> On 3/6/26 14:35, Usama Arif wrote:
>>>> During folio migration, __folio_migrate_mapping() removes the source
>>>> folio from the deferred split queue, but the destination folio is never
>>>> re-queued.  This causes underutilized THPs to escape the shrinker after
>>>> NUMA migration, since they silently drop off the deferred split list.
>>>>
>>>> Fix this by calling deferred_split_folio() on the destination folio
>>>> after a successful migration, for large rmappable folios.
>>>>
>>>> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
>>>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>> ---
>>>>  mm/migrate.c | 11 +++++++++++
>>>>  1 file changed, 11 insertions(+)
>>>>
>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>> index ece77ccb2ec0..98d0a594f7b7 100644
>>>> --- a/mm/migrate.c
>>>> +++ b/mm/migrate.c
>>>> @@ -1393,6 +1393,17 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>>>>  	if (old_page_state & PAGE_WAS_MAPPED)
>>>>  		remove_migration_ptes(src, dst, 0);
>>>>
>>>> +	/*
>>>> +	 * Requeue the destination folio on the deferred split queue if
>>>> +	 * the source was a large folio that was on the queue. Without
>>>> +	 * this, NUMA migration causes underutilized THPs to escape
>>>> +	 * the shrinker since the source is unqueued in
>>>> +	 * __folio_migrate_mapping() and the destination is never
>>>> +	 * re-queued.
>>>> +	 */
>>>> +	if (folio_test_large(dst) && folio_test_large_rmappable(dst))
>>>> +		deferred_split_folio(dst, false);
>>>
>>> Doesn't that mean that you will readd any large folios, even if already
>>> previously taken off the list after scanning?
>>>
>>> So I am not sure if your "if the source was a large folio that was on
>>> the queue." comment is accurate?
>>>
>>
>> Yes you are right. How about something like below? We also won't need to check
>> for anon and non-device folios with this as we only set the the flag if it was
>> already on deferred_split list.
> 
> BTW, migrate_pages() tries to split partially mapped folios before migration[1],
> so what remains in the deferred_list would be:
> 
> 1. partially mapped but with a pin,
> 2. fully mapped but potentially underused.
> 

Yes, thats right.

> I wonder if you want to do an underused scan before migration and try to split
> underused THPs.

hmm, I think we should keep THPs as is if there is no memory pressure (proactive
or otherwise). Scanning THPs for zeros has a cost and we would also lose the benefit
of THPs when we dont need memory.

> Or to avoid this additional scan, find a way of detecting
> zero pages at page copy time and split it after migration.
> 

Yeah but I think we lose the benefits of THPs after migration when we dont need
additional memory?

> Anyway, it seems that all large folios are in this deferred_list. Maybe, like
> David suggested in his LSFMM proposal, we should scan large folios on LRU lists
> at reclaim time instead, since there is not much difference between deferred_list
> and LRU lists right now.
> 

Yeah the THP shrinker is a very basic implementation and there are a lot of 

> 
> [1] https://elixir.bootlin.com/linux/v6.19.3/source/mm/migrate.c#L1840
> 

Also Johannes pointed out its not great storing this information in page flags,
we can just keep it as local variable. This is what the patch would look like:


diff --git a/mm/migrate.c b/mm/migrate.c
index ece77ccb2ec0..48a972f158ab 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1360,6 +1360,7 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
        int rc;
        int old_page_state = 0;
        struct anon_vma *anon_vma = NULL;
+       bool src_deferred_split = false;
        struct list_head *prev;
 
        __migrate_folio_extract(dst, &old_page_state, &anon_vma);
@@ -1373,6 +1374,10 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
                goto out_unlock_both;
        }
 
+       if (folio_test_large(src) && folio_test_large_rmappable(src) &&
+           !data_race(list_empty(&src->_deferred_list)))
+               src_deferred_split = true;
+
        rc = move_to_new_folio(dst, src, mode);
        if (rc)
                goto out;
@@ -1393,6 +1398,15 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
        if (old_page_state & PAGE_WAS_MAPPED)
                remove_migration_ptes(src, dst, 0);
 
+       /*
+        * Requeue the destination folio on the deferred split queue if
+        * the source was on the queue.  The source is unqueued in
+        * __folio_migrate_mapping(), so we recorded the state from
+        * before move_to_new_folio().
+        */
+       if (src_deferred_split)
+               deferred_split_folio(dst, false);
+
 out_unlock_both:
        folio_unlock(dst);
        folio_set_owner_migrate_reason(dst, reason);
 

