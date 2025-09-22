Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3615CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 11:36:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4F58E0005; Mon, 22 Sep 2025 07:36:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BD388E0001; Mon, 22 Sep 2025 07:36:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3BC48E0005; Mon, 22 Sep 2025 07:36:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2AC18E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 07:36:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A336C05DF
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 11:36:22 +0000 (UTC)
X-FDA: 83916683004.27.BBC0177
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf23.hostedemail.com (Postfix) with ESMTP id E48F814000D
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 11:36:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HBDVlNuH;
	spf=pass (imf23.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758540980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0u+YpSV/wxdA6FA5LVbjzCi32nJBgZrsJFyY0iW11c=;
	b=wzI+lxH25u9PynBw9ytaQI4eVtQ7rOV699cIzX+3C+fwCPDGmvj3WnYwkM8FRDOlL+y83P
	hoY0D/dBtftjgiRlWtPn7PW22W/M7cHHQ/UoVQtw1MkR++V434XU8hlq5QwLSFFGgfCSHc
	uuZeYDNgU6AD6lhGUfKF9EmWzVldHQY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758540980; a=rsa-sha256;
	cv=none;
	b=xg2lmDwec9orNUN/s+rrzzsUwILYBPr1uyU/DLusRMmbFDpJr9NQ5GiEHfpRV+HSL0vR1+
	fhRa9JDtuDlFZdEA8u/Yb7v0wpk6UH4Smo74Crzg4h3BlL+Qce9fdIedDiZGhz0KMnYFXM
	RdRnZlAAXwLYLwk6MZ0ZmEIW5OZs3og=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HBDVlNuH;
	spf=pass (imf23.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3327f8ed081so715458a91.1
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 04:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758540978; x=1759145778; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X0u+YpSV/wxdA6FA5LVbjzCi32nJBgZrsJFyY0iW11c=;
        b=HBDVlNuHn8gxIDSfBC/Oa6RTUdvI5eDbuCO35my+waALAjf9TEx+f8bzJDcwzKKbEq
         HZ/nVHZuMElBI/q/5RNST11Z1JJ/mVhdOpKS8HEFCfgDgc1R7AznEIvp//wNfYN6hQrp
         e4HzC6NWvr2YIHwOjIBqAL32ZSkru+ZzYHUTFkNZc1n8udmuoPNPsfhVpjdmcqgVC0RA
         8Jg7H9M23bH3MapsBW7u1InA5/ZoCihzCjO9SsCJlKxXnbQwzgJdpBVymH+D/DZz0PbH
         GGy8CFBdE5sbfToqgn9YL5WDR25i+wOKkS5NjJ8xc7M7UZmYSbbOUymY/iSsnUrCXkLf
         0Cww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758540978; x=1759145778;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=X0u+YpSV/wxdA6FA5LVbjzCi32nJBgZrsJFyY0iW11c=;
        b=AK5G1RRPi2SRpZe+vtIe13lpESCSqPvHg4D1/MymT7HKg4hmmAk0eZv4lHMuXWzaLL
         Wg39/UipXGj6x2w511H+CvgIgbZrmvnoyy61iYYcNeBwRhxp8s0NUS9SRy7xvdhOWaG1
         vzYgonxMt2CCISOvDdaynAZmTIdYicic5h8H/4iSCOEIugrJBOwp08gUVQoMqjxbUcyz
         3D5SgkMJhkOmPVJeAO7vfvxnkguHexrQ+3Zsz6bJzwy3HvdDIIrgff10fJhrDgano3Fq
         vfLlvN9Ue11jUWpOQwtyG0BUP+WfxyO7GRheRL5kqSOtB7UeeKPLNL6iSa9P7eDP5qKP
         UWYA==
X-Gm-Message-State: AOJu0YzB2AmCUdLj9Oofvgsi70d/n/JgPQtGjiPRFS6yxJEMoWP/TVTl
	CX9T3gnPIHfCqybBRprCvyw2FABSpCIxNX+GhF5kQiYfzQOsjWey6JcOMJV1OP3sxoo=
X-Gm-Gg: ASbGncuryuwUnG/cMaHoDKSUS/HX1QOiDwnsVQaH4bYv1a8aQPDr1gJo3B3UnwGKSxM
	kmAGOrnO6x7Hr+2YO/uOLVN52bAexdkj6vIC3dBf/nYWdpBT/TyLxTwWkE79Z/6BHZyliHcONMO
	zPTSFqWcHuARUCUARivFiKl3sxGcEchRi0xAou+9rpaFxtsqb+DoKBSWQP/aLomOuEOGOqd5Y+d
	FUtkQM+aDAb84OHOe3/9SF3Rwtr0IlIutKqSxjJuAOcBZSHl+GJkws5TLFXdTyhhsjLfmlU6QAc
	+qdQkX3KM+TcRsZ8y8a892MIDa3WRkvhfqzw5mH6yqgbJx1sr66vrUfl8xvlS+6Ed+EAME2XtpY
	DMr1y9PN/neK+uy7lgpRvmdrAkhJX5nZZJ7n7+Q68WzT07pfrVETgIe82d1YPcg==
X-Google-Smtp-Source: AGHT+IFu8eiVI48iUvVgVKbcFTq4WvOFa2+0AYyjYOZYbm0gMsPD46CwjI8fpjFeWEGqYdUgtuMPzA==
X-Received: by 2002:a17:90b:2788:b0:32b:94a2:b0d5 with SMTP id 98e67ed59e1d1-3309838dff7mr15360958a91.37.1758540978490;
        Mon, 22 Sep 2025 04:36:18 -0700 (PDT)
Received: from [100.82.90.25] ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ea0852a82sm10802765a91.0.2025.09.22.04.36.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 04:36:17 -0700 (PDT)
Message-ID: <65b6c32a-7eb4-4023-94c0-968735b784f6@bytedance.com>
Date: Mon, 22 Sep 2025 19:36:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: thp: use folio_batch to handle THP splitting in
 deferred_split_scan()
To: David Hildenbrand <david@redhat.com>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
References: <cover.1758253018.git.zhengqi.arch@bytedance.com>
 <3db5da29d767162a006a562963eb52df9ce45a51.1758253018.git.zhengqi.arch@bytedance.com>
 <40772b34-30c8-4f16-833c-34fdd7c69176@redhat.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <40772b34-30c8-4f16-833c-34fdd7c69176@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E48F814000D
X-Stat-Signature: gngbknhjuaojs7s6zcmegogasofjobjp
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758540979-671258
X-HE-Meta: U2FsdGVkX19QnxLS3Osko8Bp3SeMCM1mXF+NVGMC9ixkjH1fukwflmXqNsqK8d9xlzAIdMkOkbrVYMsH8rIfa7ECtrmSgZn/uFPi7s3NKIEapjfK50LwBwU/URZuuzgBP9/sU1/4j3CxlZ+NhCHfy+W76cFCifuALmBAuVr0dw4WEFBk5XafY8A1ktzRVUPDZBQqq+BtIDjWsx5wDcFcElzWUhO6/ahtjGNtG3a1ON/Kz6gPNVf8ktR2W9GQX4xdLcrTuclBl/uL2JFtzSIwpMaJdp58Yl4RY+6/m90z1Tz7m9sHfOb4xk+acLSwvHlEX27iY8USnYCb/5zhe59lvm+jT6/VVXa8B3GoEPq4dfEFtfmxH5X86AZnuLAZaV3JaSsNRPyrVzAdcNPJjNRuK34mDumSRykrBfJWWgeqdCTySi6udNfRFj5eeXwerOFIAprPz/gcJhVcbRqmXt1r3c7vt5A8sppiVjktVgi5DMsqZ9j+98f3x5uH3zju7lcjCDgbayE38d/4uY0tOf05v/GnhhQPnoP32y6vozPJcnmiZrpbQjTDNW/Pazgd5FeIYTJMjII00Iza26z4f6w7+nqkcZ6gfqcUsk35PxNw/Z0PRRDfuQQOaVroP/2R/BSlhQji8hbcmHS6pFcVbMXCQqx3VjKvbJgEm2rAuxkRe2o8bR3VrVzDTwnkt/vdDcBDUVcWuZm3CeJh/pNyNUwllHSYtqNFxcy7/N0vyxfPYUBF0W9pVL2R+SbZXxaPJZfgepOCSQbQJYUZEJ3WpPC/dluPjUxrnWyCwXOucEI97jRrYDbJGVfmi2Dj9PS5r2NzonLX2N0aQbc1G4KX7NcURC8AmyQPxgwQsiKwWZUbrC/RTsrWFaTHtfC2xb9SvIK5NbH6uOf04vrpBlqwMym3Nyi5pe4fu4sLAhlH4X4l3gOB/73VM4LudnKUDAib7gStsNqzNU/esekpHKBWbL4
 vOSjrl+y
 +TT00AailXWV6zye9IKl/Lz0eFD+EF0e7AM9KCyjx3Zyr8HjEJIgFhVKP5YLH0UH9rqvfhWwdwyEsF36H0e0O6je/88BJ7+l7ndiaW3EwYhxsxNEdvu/3oy0lDhCJT8ALk/bESI//aUCKlh64vxasKAvXXj1RVIi/gROvIyT5+65Izn6CXjMIgycru9OLxAlXFixZ5JCx/9RuV+lxMIgOjCRkg2h1CnUnYK4QNw3KDgZaLOLqqS8PT8YPVvWAHPUzv3nH+E3oCJYaMW3U8IK3votL4vWSOdVFTQihtmWUhf633bXrSzz1UiR85Gs9i/xIX7rgRAo0GUbhRJXOoYmJ0CPY9uSYr1il2LjWEN9lpFG9lt7scweB4xW1cHYMx16BP1nxEKErJ/pcu51m8XtfKEQ2QAgEuvHJlgkJx5DzaeEGktA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On 9/22/25 4:43 PM, David Hildenbrand wrote:
> On 19.09.25 05:46, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> The maintenance of the folio->_deferred_list is intricate because it's
>> reused in a local list.
>>
>> Here are some peculiarities:
>>
>>     1) When a folio is removed from its split queue and added to a local
>>        on-stack list in deferred_split_scan(), the ->split_queue_len 
>> isn't
>>        updated, leading to an inconsistency between it and the actual
>>        number of folios in the split queue.
> 
> deferred_split_count() will now return "0" even though there might be 
> concurrent scanning going on. I assume that's okay because we are not 
> returning SHRINK_EMPTY (which is a difference).
> 
>>
>>     2) When the folio is split via split_folio() later, it's removed from
>>        the local list while holding the split queue lock. At this time,
>>        this lock protects the local list, not the split queue.
>>
>>     3) To handle the race condition with a third-party freeing or 
>> migrating
>>        the preceding folio, we must ensure there's always one safe (with
>>        raised refcount) folio before by delaying its folio_put(). More
>>        details can be found in commit e66f3185fa04 ("mm/thp: fix deferred
>>        split queue not partially_mapped"). It's rather tricky.
>>
>> We can use the folio_batch infrastructure to handle this clearly. In this
>> case, ->split_queue_len will be consistent with the real number of folios
>> in the split queue. If list_empty(&folio->_deferred_list) returns false,
>> it's clear the folio must be in its split queue (not in a local list
>> anymore).
>>
>> In the future, we will reparent LRU folios during memcg offline to
>> eliminate dying memory cgroups, which requires reparenting the split 
>> queue
>> to its parent first. So this patch prepares for using
>> folio_split_queue_lock_irqsave() as the memcg may change then.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   mm/huge_memory.c | 88 +++++++++++++++++++++++-------------------------
>>   1 file changed, 42 insertions(+), 46 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index d34516a22f5bb..ab16da21c94e0 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3760,21 +3760,22 @@ static int __folio_split(struct folio *folio, 
>> unsigned int new_order,
>>           struct lruvec *lruvec;
>>           int expected_refs;
>> -        if (folio_order(folio) > 1 &&
>> -            !list_empty(&folio->_deferred_list)) {
>> -            ds_queue->split_queue_len--;
>> +        if (folio_order(folio) > 1) {
>> +            if (!list_empty(&folio->_deferred_list)) {
>> +                ds_queue->split_queue_len--;
>> +                /*
>> +                 * Reinitialize page_deferred_list after removing the
>> +                 * page from the split_queue, otherwise a subsequent
>> +                 * split will see list corruption when checking the
>> +                 * page_deferred_list.
>> +                 */
>> +                list_del_init(&folio->_deferred_list);
>> +            }
>>               if (folio_test_partially_mapped(folio)) {
>>                   folio_clear_partially_mapped(folio);
>>                   mod_mthp_stat(folio_order(folio),
>>                             MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>>               }
>> -            /*
>> -             * Reinitialize page_deferred_list after removing the
>> -             * page from the split_queue, otherwise a subsequent
>> -             * split will see list corruption when checking the
>> -             * page_deferred_list.
>> -             */
>> -            list_del_init(&folio->_deferred_list);
>>           }
> 
> BTW I am not sure about holding the split_queue_lock before freezing the 
> refcount (comment above the freeze):
> 
> freezing should properly sync against the folio_try_get(): one of them 
> would fail.
> 
> So not sure if that is still required. But I recall something nasty 
> regarding that :)

I'm not sure either, need some investigation.

> 
> 
>>           split_queue_unlock(ds_queue);
>>           if (mapping) {
>> @@ -4173,40 +4174,48 @@ static unsigned long 
>> deferred_split_scan(struct shrinker *shrink,
>>       struct pglist_data *pgdata = NODE_DATA(sc->nid);
>>       struct deferred_split *ds_queue = &pgdata->deferred_split_queue;
>>       unsigned long flags;
>> -    LIST_HEAD(list);
>> -    struct folio *folio, *next, *prev = NULL;
>> -    int split = 0, removed = 0;
>> +    struct folio *folio, *next;
>> +    int split = 0, i;
>> +    struct folio_batch fbatch;
>> +    bool done;
> 
> Is "done" really required? Can't we just use sc->nr_to_scan tos ee if 
> there is work remaining to be done so we retry?

I think you are right, will do in the next version.

> 
>>   #ifdef CONFIG_MEMCG
>>       if (sc->memcg)
>>           ds_queue = &sc->memcg->deferred_split_queue;
>>   #endif
>> +    folio_batch_init(&fbatch);
>> +retry:
>> +    done = true;
>>       spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
>>       /* Take pin on all head pages to avoid freeing them under us */
>>       list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
>>                               _deferred_list) {
>>           if (folio_try_get(folio)) {
>> -            list_move(&folio->_deferred_list, &list);
>> -        } else {
>> +            folio_batch_add(&fbatch, folio);
>> +        } else if (folio_test_partially_mapped(folio)) {
>>               /* We lost race with folio_put() */
>> -            if (folio_test_partially_mapped(folio)) {
>> -                folio_clear_partially_mapped(folio);
>> -                mod_mthp_stat(folio_order(folio),
>> -                          MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>> -            }
>> -            list_del_init(&folio->_deferred_list);
>> -            ds_queue->split_queue_len--;
>> +            folio_clear_partially_mapped(folio);
>> +            mod_mthp_stat(folio_order(folio),
>> +                      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>>           }
>> +        list_del_init(&folio->_deferred_list);
>> +        ds_queue->split_queue_len--;
>>           if (!--sc->nr_to_scan)
>>               break;
>> +        if (folio_batch_space(&fbatch) == 0) {
> 
> Nit: if (!folio_batch_space(&fbatch)) {

OK, will do.

Thanks,
Qi

> 
> 


