Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62EEECAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 09:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C180D8E000B; Wed, 24 Sep 2025 05:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA1928E0001; Wed, 24 Sep 2025 05:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90AF8E000B; Wed, 24 Sep 2025 05:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90A7A8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:57:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3916CC04D3
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:57:40 +0000 (UTC)
X-FDA: 83923691880.17.22A4092
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7B72A180008
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:57:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MIl8KZK6;
	spf=pass (imf06.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758707858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=feWoks1URwNxECdx0kBnKSduIOhZ1zoC6naom/ljIvQ=;
	b=MPve8HfkVg0yY7uvYhZPLeEwYBiU1kKSof+ka5Bshk7T4ZuxWYIxWFD3GU01im+hFEBe4X
	6JoyNZRJj9i18oB0cvRST6bF9LbdpqybRaznSLTNGHvcDngN6kj9JQQ0cUV1XF66fA77TE
	zO1qVNL87NnLkCPbJozUcnC0B4misvo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758707858; a=rsa-sha256;
	cv=none;
	b=R3llvdeSmDbXHF6e5N4OJI6On/v4GvE8zCa/XT/M/LnSIbxoytfQ+NOANUGhGEnKPOHyaG
	gJvifrxSTKSQCkO6Bsb9TH1QRUTIdm7oICuSLQda4Wg5b7+XPYBuRkdDbQeUvFNgnaULEb
	ncInUWrnVhPB/b92BfyNZIq4//BIHQQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MIl8KZK6;
	spf=pass (imf06.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-77f68fae1a8so838819b3a.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758707855; x=1759312655; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=feWoks1URwNxECdx0kBnKSduIOhZ1zoC6naom/ljIvQ=;
        b=MIl8KZK6CvfRfs9Ppp/NRy295QXfG8tYBsSKsineZgkbUXZwM5b6+6mYy0W/p6jdlE
         /CVqZyJ/3gKZFAbZAU4edB8zTEamMXTSyWlpfSUBfzZN/IHIKzkWSOHhnga159MS5lmt
         2zrgwV0WQ8BArvxXuWDp5VpnaZA8e2239Lh/xIPofvIkYg57qTbJ+8ptaTy719Tw9Ekc
         p574AFTbCeozy5WEgOT0JBSXD7YgaKGhTHHyTgjuqQ81pbW8eUvE1QkK/BPNwaOAfGLO
         ijNo90s79s3tFM0qVyUz8lDOMeL8aqhM5T8eaAS9xJQ0sf96am2WCzyBfs4LKGTtiK5B
         A1TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758707855; x=1759312655;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=feWoks1URwNxECdx0kBnKSduIOhZ1zoC6naom/ljIvQ=;
        b=cHcdtn/MS0FqLHn1uEe5wk2NgviORt8tN0bTskK6N2A8+0SIj7RapZWhFW7S1AOuDh
         fiNOtAA58dY3ErrqZr8eOsSuHloT51Jd/FGPOn8KBEoRpLip8fbV6N45lsTuXU1+PBZa
         nVZ9I4Rx8X0kQ+vsrMx46ZZml2icqzBJ09Ys3h79mWiSSP4fKB/NASaqIRWD0Bea6M3r
         2YTpV04mXdEfwW6AfcN+qpM3xSIXzIqigdI2IAy+EAXkHRXLzeU47aLkqdchx/jRAHQg
         l5tu0pu6VJJSI0ejnbGuk7dxDoeoHoKwvUSxF5vXuCnicyIYGWj0dCR0Erzf/Ic+kwQ2
         Weaw==
X-Forwarded-Encrypted: i=1; AJvYcCVTOzdXmmqmEwDobUqpbiIx9G7FUle7OCrE05a/nLoLo7QyaCLyRJz6GH0XOlrBK5zc2ehgLZI30g==@kvack.org
X-Gm-Message-State: AOJu0Yxel9miL75mMq0ZlGdcrUejKiGcOn+PNELrFbYaTKG0zM0E1GmS
	C63Q2uY9t/QBZ1YR5zamzgZuawope4sHkp00JSjb/SeKcjJCcuUSY2/J/tPQ/eipCfU=
X-Gm-Gg: ASbGncuQzZroUxmKcAPY0K19/XK1pfV6jK5NPnCo+Gkr3QDl7PYjdFsytfiswjok+KP
	FLtcCNVVtXq3I9ApiytQJWFZeNrZEH5Qi/w0hdSV1Un+L5MNfcsUyS7WxhVwT6B6OnvdMsvqrMS
	vkphj/luI7BkPHjCO2N+1GTfjBBMI/K5teae3Efvrp7JGS845YbNtKLj9vtwKpfIjeChi6/BC4X
	anKfnpSeZk69WyItl3klBaBME2Gd/bxAiGah3ut08S8E0OhcKRobfEUuOxmU2OBeS5VrjtWgBI+
	kL49GC9FIr9652ePaS0Pycnv8yWwd6VzkxN4wS0TykChMJupjwbyr6nb02Kj4aHv1jciJyiu2D6
	6pb8ajpSvm7Exs/XmLTar0KK1AEFgAzk0A2oA0lCfOC5YN3HNkGz0wMnrBw==
X-Google-Smtp-Source: AGHT+IHcogPZLoIfoB/HwHpwoOkYoaHEaLHCbtFP1GStNJWfELLsdO2LyRM5voSYtico8yl3cdiwAw==
X-Received: by 2002:a05:6a20:e293:b0:2c1:b47d:bcc9 with SMTP id adf61e73a8af0-2cff49b176emr7797143637.48.1758707854901;
        Wed, 24 Sep 2025 02:57:34 -0700 (PDT)
Received: from [100.82.90.25] ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b55352ae6d2sm11066918a12.37.2025.09.24.02.57.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 02:57:34 -0700 (PDT)
Message-ID: <7d0bf9a8-7890-4002-9e02-5f7884ab0bca@bytedance.com>
Date: Wed, 24 Sep 2025 17:57:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm: thp: use folio_batch to handle THP splitting
 in deferred_split_scan()
To: Zi Yan <ziy@nvidia.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, harry.yoo@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>
References: <cover.1758618527.git.zhengqi.arch@bytedance.com>
 <782da2d3eca63d9bf152c58c6733c4e16b06b740.1758618527.git.zhengqi.arch@bytedance.com>
 <A64EA303-74CD-4CF9-B892-C0FF9699F3FF@nvidia.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <A64EA303-74CD-4CF9-B892-C0FF9699F3FF@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1nr47wzof4mtz78uueqhq9oyb7346eax
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B72A180008
X-Rspamd-Server: rspam10
X-HE-Tag: 1758707856-697484
X-HE-Meta: U2FsdGVkX1+BBAD6imcHvdxGl6iKZpeFdMW9rCaxGGvrfq/F2Mk7LoW2cq+aJgClyvjW3vc1EwKCE9kgLAoecTq+o52+CrNPiELynNDeHg+9waBxapLpo27pO5NsR2FkZLZJhD0/1cnobxkc8DbVecJ/j7dktg45FxiGdoI/o/nrV2WF5cjECiFt6/yzR2UmbJmFHoHlpULg76ueUzY+qB8A+pkBHNWCHan+j2NFCv7DRlBpJzRc9h/Tm8fhPtDnZWCSb3CTubma6NWGq4uohpfldCmLlUgts5k85qiIkfK8HswgaNQU4/op1SZlc/HpbwpyKLOsr/lgR9T6rQNvD4cMgfB+clJf+uoU/FAFRjA6m7u6dYxGOd2hK7YOwNl/Qvtzdfw+C5kj7hrsMVdBGtwR0fZAG4a262kaW2jQNbroeRUagy3ULm/u/GgwhYyeK2zNm5CabwltK5qxA6ywp9Yg/j9prVY13CFLehBKFpw45EippoIAh1AUNEivUIkY6hvRF3xcphLl5iGE4GDlULz74gJ6OiBV23Lp74Evk6zCFuKCzi30By2YgpW3B/noQRJkLw+Q3wqBR7Hhr582ziz4kmMIxb2gYF4YpUbKlny4c0jp9lLhD7YNa7i7wR+ywozSVbwt3v/W86U0nfly8I0A+ccEZ0CNUq1dX9BdYvuSXuYPi9SVQUF+fK/tQ4vX/FX2j/nFrl1cHaVEqeVmnJwkxDP7Yk0mR41EGUEnZqt+VKK1hv5JDLDnuxij/n6ORGTG2jaoiBhcY0t3AJLFP7s8ENcV6hkNQWbvheBqjo/R6cJXMR189vepY/WuGziQHu/t9x1LZv1dg6LhcASDnXCoev93CqsAweCv9sfGCN6EyjtqAx2iVgA1jVcyIdcCJpNkc5bUh0MwMFqqenmWHJoipRhCegIb2ffzRASjLL3X3ARZMj4KDX/IZ9JE4zIzxU33AkhJmZsX/ICVMLY
 Upg9hzYy
 MpvqZQFk0l2Oen9qBV5GXI9/i/SgCeIeANQQJa09F4h69MyjUbGFYGeymfRYeuoHM6udzgra7T2b+5jWJ6dXxsG4VCp68IuN5Lxg1qxIyMcXJq6VodzzEXVhxUv/xCZI3OIXDHDEuI7C9rKAcPoUNF0QWAJp0SrpTQa3erDnoT1d9w/CKbTljp4Z+68fgl+Ew5uhWtP21kPe2RV2QqourY8YlUrD0UFuREM8Vb9y5EM217MG+2IUWEqMGdq9iOc5MaCSNNjD5IDsll2Mcu+OLKD0wjLjIkvogbGz5A2D1rJSnvjFfK3OJ4VWtjBjr/LcNU/LNExOFRI//hCFzhE8sqEDlnkrEPQaX906qVmJyM5WWp0JL/m32YqxVrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zi,

On 9/23/25 11:31 PM, Zi Yan wrote:
> On 23 Sep 2025, at 5:16, Qi Zheng wrote:
> 
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> The maintenance of the folio->_deferred_list is intricate because it's
>> reused in a local list.
>>
>> Here are some peculiarities:
>>
>>     1) When a folio is removed from its split queue and added to a local
>>        on-stack list in deferred_split_scan(), the ->split_queue_len isn't
>>        updated, leading to an inconsistency between it and the actual
>>        number of folios in the split queue.
>>
>>     2) When the folio is split via split_folio() later, it's removed from
>>        the local list while holding the split queue lock. At this time,
>>        this lock protects the local list, not the split queue.
>>
>>     3) To handle the race condition with a third-party freeing or migrating
>>        the preceding folio, we must ensure there's always one safe (with
>>        raised refcount) folio before by delaying its folio_put(). More
>>        details can be found in commit e66f3185fa04 ("mm/thp: fix deferred
>>        split queue not partially_mapped"). It's rather tricky.
>>
>> We can use the folio_batch infrastructure to handle this clearly. In this
> 
> Can you add more details on how folio_batch handles the above three concerns
> in the original code? That would guide me what to look for during code review.

Sure.

For 1), after adding folio to folio_batch, we immediatelly decrement the
ds_queue->split_queue_len, so there are no more inconsistencies.

For 2), after adding folio to folio_batch, we will see list_empty() in
__folio_split(), so there is no longer a situation where
split_queue_lock protects the local list.

For 3), after adding folio to folio_batch, we call folios_put() at the
end to decrement the refcount of folios, which looks more natural.

> 
>> case, ->split_queue_len will be consistent with the real number of folios
>> in the split queue. If list_empty(&folio->_deferred_list) returns false,
>> it's clear the folio must be in its split queue (not in a local list
>> anymore).
>>
>> In the future, we will reparent LRU folios during memcg offline to
>> eliminate dying memory cgroups, which requires reparenting the split queue
>> to its parent first. So this patch prepares for using
>> folio_split_queue_lock_irqsave() as the memcg may change then.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   mm/huge_memory.c | 84 ++++++++++++++++++++++--------------------------
>>   1 file changed, 38 insertions(+), 46 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 2f41b8f0d4871..48b51e6230a67 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3781,21 +3781,22 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>   		struct lruvec *lruvec;
>>   		int expected_refs;
>>
>> -		if (folio_order(folio) > 1 &&
>> -		    !list_empty(&folio->_deferred_list)) {
>> -			ds_queue->split_queue_len--;
>> +		if (folio_order(folio) > 1) {
>> +			if (!list_empty(&folio->_deferred_list)) {
>> +				ds_queue->split_queue_len--;
>> +				/*
>> +				 * Reinitialize page_deferred_list after removing the
>> +				 * page from the split_queue, otherwise a subsequent
>> +				 * split will see list corruption when checking the
>> +				 * page_deferred_list.
>> +				 */
>> +				list_del_init(&folio->_deferred_list);
>> +			}
>>   			if (folio_test_partially_mapped(folio)) {
>>   				folio_clear_partially_mapped(folio);
>>   				mod_mthp_stat(folio_order(folio),
>>   					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>>   			}
> 
> folio_test_partially_mapped() is done regardless the folio is on _deferred_list
> or not, is it because the folio can be on a folio batch and its _deferred_list
> is empty?

Yes.

> 
>> -			/*
>> -			 * Reinitialize page_deferred_list after removing the
>> -			 * page from the split_queue, otherwise a subsequent
>> -			 * split will see list corruption when checking the
>> -			 * page_deferred_list.
>> -			 */
>> -			list_del_init(&folio->_deferred_list);
>>   		}
>>   		split_queue_unlock(ds_queue);
>>   		if (mapping) {
>> @@ -4194,40 +4195,44 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>   	struct pglist_data *pgdata = NODE_DATA(sc->nid);
>>   	struct deferred_split *ds_queue = &pgdata->deferred_split_queue;
>>   	unsigned long flags;
>> -	LIST_HEAD(list);
>> -	struct folio *folio, *next, *prev = NULL;
>> -	int split = 0, removed = 0;
>> +	struct folio *folio, *next;
>> +	int split = 0, i;
>> +	struct folio_batch fbatch;
>>
>>   #ifdef CONFIG_MEMCG
>>   	if (sc->memcg)
>>   		ds_queue = &sc->memcg->deferred_split_queue;
>>   #endif
>>
>> +	folio_batch_init(&fbatch);
>> +retry:
>>   	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
>>   	/* Take pin on all head pages to avoid freeing them under us */
>>   	list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
>>   							_deferred_list) {
>>   		if (folio_try_get(folio)) {
>> -			list_move(&folio->_deferred_list, &list);
>> -		} else {
>> +			folio_batch_add(&fbatch, folio);
>> +		} else if (folio_test_partially_mapped(folio)) {
>>   			/* We lost race with folio_put() */
>> -			if (folio_test_partially_mapped(folio)) {
>> -				folio_clear_partially_mapped(folio);
>> -				mod_mthp_stat(folio_order(folio),
>> -					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>> -			}
>> -			list_del_init(&folio->_deferred_list);
>> -			ds_queue->split_queue_len--;
>> +			folio_clear_partially_mapped(folio);
>> +			mod_mthp_stat(folio_order(folio),
>> +				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>>   		}
>> +		list_del_init(&folio->_deferred_list);
>> +		ds_queue->split_queue_len--;
> 
> At this point, the folio can be following conditions:
> 1. deferred_split_scan() gets it,
> 2. it is freed by folio_put().
> 
> In both cases, it is removed from deferred_split_queue, right?

Right. For the case 1), we may add folio back to deferred_split_queue.

> 
>>   		if (!--sc->nr_to_scan)
>>   			break;
>> +		if (!folio_batch_space(&fbatch))
>> +			break;
>>   	}
>>   	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
>>
>> -	list_for_each_entry_safe(folio, next, &list, _deferred_list) {
>> +	for (i = 0; i < folio_batch_count(&fbatch); i++) {
>>   		bool did_split = false;
>>   		bool underused = false;
>> +		struct deferred_split *fqueue;
>>
>> +		folio = fbatch.folios[i];
>>   		if (!folio_test_partially_mapped(folio)) {
>>   			/*
>>   			 * See try_to_map_unused_to_zeropage(): we cannot
>> @@ -4250,38 +4255,25 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>   		}
>>   		folio_unlock(folio);
>>   next:
>> +		if (did_split || !folio_test_partially_mapped(folio))
>> +			continue;
>>   		/*
>> -		 * split_folio() removes folio from list on success.
>>   		 * Only add back to the queue if folio is partially mapped.
>>   		 * If thp_underused returns false, or if split_folio fails
>>   		 * in the case it was underused, then consider it used and
>>   		 * don't add it back to split_queue.
>>   		 */
>> -		if (did_split) {
>> -			; /* folio already removed from list */
>> -		} else if (!folio_test_partially_mapped(folio)) {
>> -			list_del_init(&folio->_deferred_list);
>> -			removed++;
>> -		} else {
>> -			/*
>> -			 * That unlocked list_del_init() above would be unsafe,
>> -			 * unless its folio is separated from any earlier folios
>> -			 * left on the list (which may be concurrently unqueued)
>> -			 * by one safe folio with refcount still raised.
>> -			 */
>> -			swap(folio, prev);
>> +		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
>> +		if (list_empty(&folio->_deferred_list)) {
>> +			list_add_tail(&folio->_deferred_list, &fqueue->split_queue);
>> +			fqueue->split_queue_len++;
> 
> fqueue should be the same as ds_queue, right? Just want to make sure
> I understand the code.

After patch #4, fqueue may be the deferred_split of parent memcg.

Thanks,
Qi

> 
>>   		}
>> -		if (folio)
>> -			folio_put(folio);
>> +		split_queue_unlock_irqrestore(fqueue, flags);
>>   	}
>> +	folios_put(&fbatch);
>>
>> -	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
>> -	list_splice_tail(&list, &ds_queue->split_queue);
>> -	ds_queue->split_queue_len -= removed;
>> -	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
>> -
>> -	if (prev)
>> -		folio_put(prev);
>> +	if (sc->nr_to_scan)
>> +		goto retry;
>>
>>   	/*
>>   	 * Stop shrinker if we didn't split any page, but the queue is empty.
>> -- 
>> 2.20.1
> 
> 
> Best Regards,
> Yan, Zi


