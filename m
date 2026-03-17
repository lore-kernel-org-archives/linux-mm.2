Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED7BAF33804
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 06:45:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284976B0089; Tue, 17 Mar 2026 02:45:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25ADC6B008A; Tue, 17 Mar 2026 02:45:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1985E6B008C; Tue, 17 Mar 2026 02:45:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05ADD6B0089
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:45:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9656A1A0524
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:45:18 +0000 (UTC)
X-FDA: 84554618316.30.86E7122
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7D0538000B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:45:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NodgPK+6;
	spf=pass (imf30.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773729916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d9m8AenGNBSpK6f9o8GrCon857vC2vFuEB2dcmCEqmU=;
	b=vVwJbfxpnKAT3i0roIDR8z5uUll+8nXU9Sg+cf+Ffni1nfDkIMJSc+eNX5OfiKZacSQaZt
	582AChQdVW5WlyP2PI6Qc1MegTC9at4LlAUleMu6C+s6m0Fl6uou+sk7Y2Xmu2e2XljNqY
	COe9LVDAjOdmzJmoZtSKUxLqtKDuegA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NodgPK+6;
	spf=pass (imf30.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773729916; a=rsa-sha256;
	cv=none;
	b=56gyQu7dHKMum7h48ZvLDgKz7Ym+nUdjUM9H5GwZO1tkZZMhh6A31Z2Nshih/C36y52wH2
	vqf7k7wHcMijpUKBya068w+DRqwgOM5BEPIPxmOrT+J6IgIaoou4Dp21CyPqInZPkFBqfC
	8uSl5t/VzYh2j+XbSXAr+WoZ/ieoiXk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773729909; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=d9m8AenGNBSpK6f9o8GrCon857vC2vFuEB2dcmCEqmU=;
	b=NodgPK+6dMbsoNxKCOUFABB5sTnX/b91O4OB0qArN11uTlAl/bU7IXw2m2OH0Cz1YYXvuSwT0Q36PXu4OKZ2WJ1n004RV+/mGSlDRbS6XW2W3Zzd+C0j12V0f5nOGpF/VzpzExUl003vx4UMQQyd8ktXORCLXZO1mihya3Hrydw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0X.9ya0W_1773729894;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X.9ya0W_1773729894 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Mar 2026 14:45:07 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,  linux-mm@kvack.org,
  akpm@linux-foundation.org,  mhocko@suse.com,  apopple@nvidia.com,
  axelrasmussen@google.com,  byungchul@sk.com,  cgroups@vger.kernel.org,
  david@kernel.org,  eperezma@redhat.com,  gourry@gourry.net,
  jasowang@redhat.com,  hannes@cmpxchg.org,  joshua.hahnjy@gmail.com,
  Liam.Howlett@oracle.com,  linux-kernel@vger.kernel.org,
  lorenzo.stoakes@oracle.com,  matthew.brost@intel.com,  mst@redhat.com,
  rppt@kernel.org,  muchun.song@linux.dev,  zhengqi.arch@bytedance.com,
  rakie.kim@sk.com,  roman.gushchin@linux.dev,  shakeel.butt@linux.dev,
  surenb@google.com,  virtualization@lists.linux.dev,  weixugc@google.com,
  xuanzhuo@linux.alibaba.com,  yuanchu@google.com,  ziy@nvidia.com,
  kernel-team@meta.com
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
In-Reply-To: <0d66401f-9874-4047-971b-632723b0b7ee@linux.dev> (JP Kobryn's
	message of "Mon, 16 Mar 2026 21:37:01 -0700")
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
	<3a42463b-9ddd-4d64-b64c-6c2e6e4fc75d@kernel.org>
	<343bbd5b-67a0-46c4-8ec4-69158bf26b3f@linux.dev>
	<874imkpba1.fsf@DESKTOP-5N7EMDA>
	<cd3d7e2c-79fa-4c00-89ad-83beddf98bae@linux.dev>
	<60f71f4c-71d9-4751-8c6b-10179b98bef0@kernel.org>
	<c4e5cc3c-5daa-404e-8c55-cface8aa969d@linux.dev>
	<87sea0o55p.fsf@DESKTOP-5N7EMDA>
	<0d66401f-9874-4047-971b-632723b0b7ee@linux.dev>
Date: Tue, 17 Mar 2026 14:44:59 +0800
Message-ID: <87a4w7x8d0.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Queue-Id: 7D0538000B
X-Rspamd-Server: rspam07
X-Stat-Signature: 9ayu3rt5z4w7icfzfde63m41kciy7qxp
X-Rspam-User: 
X-HE-Tag: 1773729915-916235
X-HE-Meta: U2FsdGVkX1+qn14746q7Pl+jz+2D2S6Bp+1AMGbA7rgj2/q5jnklq54ZmM9BP19JQAT7HJgJFv/KKkPQ19jc5xFo2HnqI98UzX7dmVdnPs/1UdiJzAWSJ/GpPvR839MgDxXUN8/xUR7skO9x/ePZGXEOivfI1oRdhv73I9xzBksbmhKOLJIk1BISoeU2iqCKCcyNf3zs1vPlJ30llwbk0qZbbP/e8ZdkNJAuU525jFOE42N0VnO/k/u7pBLa7/TNlLsBCPl7fbmjEoO8xUwwJSOWDs+g4/9kQMgh63IyMVyWZyJgli/C0swIJxYzHEwMsAKk7T1hpV/wUCObCKuZ8LNbV4KcmdY7MK3WkmOzqJMPxJwKTfUOiWGNuLIr4PtRvnCvrG+keiULIG0bFsoNMSzeu5OCy6HAFKwtLV/x/Ljw6zZjmYPlEPqlnBBllXEm94WAIA4MUmuebhAn0lC2Qer4/lfEL1nXBRw7WOVO0y7ueAcYi3SmAU+zfrDaGUs+5ivSYmBPxfIIz4QE5tCOukjQZu/JcFNpoQnB99+b0eB0PapOLh5sk/Ns0AyQH0pZA28geHAP7g4SyoRuHDVtR7beN9anssxYU5Hu0VTNf/dBBpvFEgXJ/5JgRr765712UJEEsZjIOfzzdxoQ6wPGVh3iHX0yN+SML8t1d8hUDWMX1sN3XroVhvYvgzgzFJGHS8Em71ocZTnbVLmyq2JYNMLYx4oEKTFQfOvsurprlAnXpxC+5sO2EPE6atu9mExFdyI/46C2IAKzS4NdC+PKVRehCKmwPfskxWXaEbubqx8jFaxUY9BFPpe2ij6QWAn6jacVcI2fNL0rSHv3q3/uA1w1cvS86ajgNY4PAqEgmVTpeyeLGrjY8Wlzcm45m2BGkBM9rBfvZ+o8FyB9GA1+1uBQatJLBI52EbuWFHASpBuk/8jE1DZQU//HiIz5ZwGFNCNEQiUQAlRAvJx+zgb
 mxVauWHz
 Ok3byyfDS/Zovnev0QiMv/8TVru5q953pog1LJV4qotRR7jqwMC9lYC0SvRq5bI92Z4OzryB91JvWopo5I+hOwUPPsATqM2HNLqeeJ51yMi1AxgCmBK9DAyI33jFxT5UuRY6AO8+AZcocS4pcA9i/7b0aMQF5nzlrYKYWKKMAaWjQV4aCZ6L+jua/XmaFC10F8NLM4vQ25o7RYNoAfWUf4G60YDv9yc7H5s6Xj/jcQI0wCqgO3MzKz61ZMRIvK7YxwnUU/7owMgTFgdVIHmGmqdPfgIqlltUG2wInS0fHz9fwAy/nEBzI1d6vwe8Ponz6Ep5lTCp9c1MURxX4/DWDbARqhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:

> On 3/15/26 7:54 PM, Huang, Ying wrote:
>> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
>> 
>>> On 3/13/26 12:34 AM, Vlastimil Babka (SUSE) wrote:
>>>> On 3/13/26 07:14, JP Kobryn (Meta) wrote:
>>>>> On 3/12/26 10:07 PM, Huang, Ying wrote:
>>>>>> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
>>>>>>
>>>>>>> On 3/12/26 6:40 AM, Vlastimil Babka (SUSE) wrote:
>>>>>>>
>>>>>>> How about I change from per-policy hit/miss/foreign triplets to a single
>>>>>>> aggregated policy triplet (i.e. just 3 new counters which account for
>>>>>>> all policies)? They would follow the same hit/miss/foreign semantics
>>>>>>> already proposed (visible in quoted text above). This would still
>>>>>>> provide the otherwise missing signal of whether policy-driven
>>>>>>> allocations to a node are intentional or fallback.
>>>>>>>
>>>>>>> Note that I am also planning on moving the stats off of the memcg so the
>>>>>>> 3 new counters will be global per-node in response to similar feedback.
>>>>>>
>>>>>> Emm, what's the difference between these newly added counters and the
>>>>>> existing numa_hit/miss/foreign counters?
>>>>>
>>>>> The existing counters don't account for node masks in the policies that
>>>>> make use of them. An allocation can land on a node in the mask and still
>>>>> be considered a miss because it wasn't the preferred node.
>>>> That sounds like we could just a new counter e.g. numa_hit_preferred
>>>> and
>>>> adjust definitions accordingly? Or some other variant that fills the gap?
>>>
>>> It's an interesting thought. Looking into these existing counters more,
>>> the in-kernel direct node allocations, which don't fall under any
>>> mempolicy, are also included in these stats. One good example might be
>>> include/linux/skbuff.h, where __dev_alloc_pages() calls
>>> alloc_pages_node_noprof(NUMA_NO_NODE, ...) which eventually reaches
>>> zone_statistics() and increments the stats.
>> IIUC, the default memory policy is used here, that is, MPOL_LOCAL.
>
> I'm not seeing that. zone_statistics() is eventually reached.
> alloc_pages_mpol() is not.

Yes.  The page isn't allocated through alloc_pages_mpol().  For example,
if we want to allocate pages for the kernel instead of user space
applications.  However, IMHO, the equivalent memory policy is
MPOL_LOCAL, that is, allocate from local node firstly, then fallback to
other nodes.  I don't think that alloc_pages_mpol() is so special.

---
Best Regards,
Huang, Ying

