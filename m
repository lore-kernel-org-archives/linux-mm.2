Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 361CF606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cdv1ywDf
Received: by kanga.kvack.org (Postfix)
	id 2A1216B06ED; Tue, 27 Oct 2026 09:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252906B0737; Tue, 27 Oct 2026 09:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 169A06B0739; Tue, 27 Oct 2026 09:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEE226B06ED
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:09:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 69FEB1C40C6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:09:05 +0000 (UTC)
X-FDA: 85368436650.12.713A1CD
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf15.hostedemail.com (Postfix) with ESMTP id B67F0A0007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:09:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cdv1ywDf;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wTlsyB1dR81kewBt8dbwH4wNLuKoV9knz79QDG5bxdk=;
	b=7fxxmNwCy4KKgDwk+hH691m9dKXKySuab0t1kzTdPPxZTHEEHGhKLVOm27MPuFOdKjWouo
	D0Njnyr9qbz3C94QGZDFzZClVa8LiVHM3FvV43zM9aKGHD7uC2M0wAMSlR/VbQwT++oKQp
	07SwUUkmbxKvRs6yCCN1YGEs6iy7DcM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cdv1ywDf;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106543;
	b=AJ0Up3Z1fqxla53EQ2RybXYOSHsm0T+uO6UnmflX1DVUMJVNnrsaaWi0GZeemCfw/neLSt
	HjvUDiPrCpXrm+HgXLsqwmgsa3UtGK+EWQhsB3xxBd6U7n/H3MMaQonSEBazu0g7jl1+vI
	0HzBHthc/hqGtKHmNNtFfGEn5lKb/7I=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793106538; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wTlsyB1dR81kewBt8dbwH4wNLuKoV9knz79QDG5bxdk=;
	b=cdv1ywDfKFnQDsZIcF8WzewM2FSEGk66VlZ+P8DC7uU/zs/OXV+pNDQulGm/bJxzu+TGXz+WMayLfaCbFAgW+Oa3hS0YbiLP++2hE+eO080t1O4AHYt/8EpVjbmpYR4QgzQeoaPji1hNjzaZeB7sKHR9aUSMIBQW/PiqVTSt1TI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0XDdouO6_1793106535;
Received: from 30.74.144.191(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDdouO6_1793106535 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 21:08:56 +0800
Message-ID: <9c562402-6023-428f-b8c9-036fb66d5ea4@linux.alibaba.com>
Date: Tue, 27 Oct 2026 21:08:55 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/16] mm/shmem: various (urgent?) fixes
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Gregory Price
 <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>,
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <a8f01101-7d7d-4982-9cf8-04b754ba132a@linux.alibaba.com>
 <1398e842-db91-4482-949a-e21197a48b9c@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <1398e842-db91-4482-949a-e21197a48b9c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B67F0A0007
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: gpccd1osjhye91spodicf9o99uj8ttqr
X-HE-Tag: 1793106542-728133
X-HE-Meta: U2FsdGVkX1+ggD9cqokTGmTehN4f0BNoQcKyyaZg+rAPeZRuzPdJOOv2bwtnzmbsVkLdsDiwWBiqI/ENry5Y5A/VbpUvNlCEQ9BOUzg7vNbD+6cHrrrgfL5jArBlSy9sMuwpufjo80mhze2AUp077L1D1X9o+Ywog03l2VdOYfMJsMutG+h9ACv8gH0PRleugYKVmL9dSyOZoLINwXrMkqE3+MLvrAZE0fAUK/C0MRb8K2LN2TMbuRfiALuRCueKU/MKyy699Ku0GxwAopetb/QZnVSu2XoikH8w4mmx3lXXIdt6hGc4QqnX36c1qsGjM9da8yNlu3qilA5aFBv0sx3WMmu/XzaNgXbbykL+PA74Ky7SuAZdCXdqwmCxcgRqMRTTRpINinjbJ7bBHts1z8kkSUDn8MiZj4m4ZrTicqo2QAjCyimVDT1zL6VU3oZ3YOwiHdvXJVHBnktbpPmn0kVrIQnR8p5/CBanpcz321OyXU3bI2NG5z593gBAQQs0EP8aVglf8X8+z1fo6BPlmd/vv1ClwjRBzOlLaiAF8XQ99W3EtF5VNWWZQSbWgAqKU1K3xONIvIYSzSfnt3cMzVFq0hLoJ5UdkYgiQu4+Inz/1tIZtRAOXdQNpANLfT856T1T5qzPk9nI6I3IbM9fSpcA0GAavbSYmtevqMXtPA87lfU7Dgw9aS5hx7rM+rm50u4UmmqmrvkMuS/hvagX21EK08YTzkKz9Lry9cwNqtblCUpYwBadUP00fNMrqKDYQQ35PLDvcbDUQgmpC4UQnZvBcB/ue5zGYCChyToJXUjTncqm2bTicXUVFlQmiydeuZa8H50WyW4MRGRTpcShBwQdIr4FWuNAXOqhgnLoFqIhDVOzqGUN9Z6L8CJJ53p+B/Cnb7wg7uKoyiUytjdQR07atiiaEAFZGDCNRBg0BucXJa7PL0Nz3YnHFyItRALVww7xYQzReTPgpAUJ6hV
 QxudkMUa
 bHHHJ005yLbPSmksTjUdfb6J+z+8OZKC4UdHUQohGP2issKOvQhVmyl8ORA5Wxvq8lEI5IUg6Kb9zHw5Yha/IgGc9UMNdPlwMOgj6TxVpct+liH0hnkkOVfUhasu6QsKrOoyprtcWT6a+YNQ8npp5JH3CJ0zA3nCFVNrLTTUmkHPgFCaedSkmN14lmS/D5mGghSHXgKP3PgDVdZ9H4pYgHu3Eq3AXcvp9uiedzJzIwe399yGJpOIvjTquNX9esorEGxaxRKkMZafa9vZ60pk3jN1ToFuKiK7zVhqpzN7I7AiHNkzq4Pw/r9ExcJPbKyC0Vt6emfFLfGrSz0uy79JUsXaVNSxa2JcpqPSPOSlV09SPOay9SUalq+5mVaixePrU8GHACfbaY92ym4IcDhsSpCh8N6JQEK9Vh/0NZu7zT2YllBvSXxWLlDapyPbT5Xqjy/1jVXBCKGvErpI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/26/26 8:12 PM, David Hildenbrand (Arm) wrote:
> On 10/26/26 12:11, Baolin Wang wrote:
>>
>>
>> On 10/26/26 5:40 PM, David Hildenbrand (Arm) wrote:
>>> Hi,
>>>
>>> the fixing fun continues.
>>>
>>> This is a handful of fixes for shmem/tmpfs. I sneaked in a related
>>> hugetlb fix that stalled upstream.
>>
>> Wow, thanks David!
>>
>>> Some of the stuff is more urgent (patch #1, F_SEAL_EXEC, truncation
>>> hangs), others are less urgent but still rather unpleasant.
>>>
>>> The majority are fixes from Anthropic that I cleaned up or reworked.
>>> While doing that, I found a bunch of other issues and tried to fix them
>>> somewhat cleanly.
>>>
>>> In general, shmem + swap handling is a nightmare. shmem_undo_range() is
>>> such utter garbage it makes me want to cry. I mean, really, WTF did we
>>> end up creating there. Does any expert here have time to clean that up and
>>> make it *actually* maintainable.
>>
>> Agree. :) I'll re-read shmem_undo_range() and take a close look at the issues
>> you raised, and see if I can make shmem_undo_range() more readable.
>>
>>> The following things are still broken in shmem_undo_range():
>>>
>>> (1) Truncate/punch of a single page of a large swap-error marker
>>>
>>> We don't split. Consequently, read access afterwards will still fail
>>> instead of returning 0s.
>>>
>>> I have a fix to try to split (which can fail), but I don't consider it
>>> that urgent, really. So I'm not including it. Might send it later
>>> separately.
>>>
>>> Truncate/punch of a partial page can obviously never do the right thing,
>>> as we cannot poison parts of pages ...
>>>
>>> (2) Truncate/punch whole pages within part of a large swap entry
>>>
>>> We try to read the entry, but if we are out of memory that might fail.
>>> Consequently, we will not free up swap space and a re-read will not give
>>> us 0s but the previous content.
>>>
>>> AI proposed a nasty NOFAIL patch which has too many nasty side effects
>>> IMHO (allowing users to force-read pages and retain them afterwards even
>>> though memory.max would disallow it). This needs a proper thought. Likely,
>>> support for splitting large swap entries (and large folios in the
>>> swapcache, which I recall is under development  by Kairui). But splitting
>>> can fail ...
>>>
>>> (3) Truncate/punch of a part of a base-page swap entry
>>>
>>> We obviously have to read the page in, in order to 0-out the parts to
>>> discard. That might obviously fail.
>>>
>>> Maybe we should install swapin-error markers if swapping during
>>> truncate/punchhole fails, to at least tell user space on later access
>>> that something went wrong? We might affect unrelated data, outside the
>>> requested range, though. Anyhow, these are long standing issues and
>>> I don't consider them urgent.
>>>
>>> They need a proper solution.
>>>
>>> I did my best trying to test these fixes. I was able to reproduce some
>>> of the things (including unkillable truncation hangs), and the fixes seemed
>>> to help.
>>>
>>> But again, shmem_undo_range() is just an absolute mess.
>>>
>>> Please prioritize review of these fixes, I want to get fixes for the
>>> issues in a timely manner upstream.
>>
>> OK. Will review and test this serires this week.
> 
> Thanks!
> 
> If there are better simple fixes, please do suggest them. Any bigger cleanups
> ideally come on top.

Most fixes look good to me. I'll verify the remaining 3 fixes tomorrow.

> BTW, the next time I get a flood of these patches, would you be willing to do
> the early screening+revise? But be careful, some of them are pretty, pretty awful :)

Sure. I'm happy to review and maintain the shmem related patches.

