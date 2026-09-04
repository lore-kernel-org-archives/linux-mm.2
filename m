Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8FD3C79F81
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 02:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A97F66B0095; Thu,  3 Sep 2026 22:10:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A21C86B0096; Thu,  3 Sep 2026 22:10:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 910296B0098; Thu,  3 Sep 2026 22:10:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E8696B0095
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 22:10:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C6AF81406CD
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:10:31 +0000 (UTC)
X-FDA: 85174450662.30.040BC95
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 417D840002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:10:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gJfvaJT3;
	spf=pass (imf27.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788487829;
	b=jw5Pmu4rlPprAzBLFm6AnnjP3p7NR9ulDbIirIpBvsippe857e0Txo4udYL4NJBC4/kFw7
	u3NgrNJT/RlhN1CulU9kuUH/gR/JAGZctqXhB5LOEnHPjz0dJvNtsc9nA4KUej/Z+0HDVU
	YgKv3Gg1I+KTSDj3V7OpF8QxHytBmuE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788487829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+SHGWUY7CbETPDlAl8WdiZ5m/7wagn5ECpymwWOZn0=;
	b=A8LvUrcHQ0XZP6isBZN8eW7ATErizgwWFdlNiel+Upspk2m5aUYEmeGqLGg45nWCwIAqMh
	NNovzcJ6AnwZWwgy3aRuJYLETREWjhPZKiTsyM5cm9iKxGw6VFtVaZxlZc8qNq3qrkcjSA
	Km2NyIrp/6sUXyXzZTUtyk90uFLjq8I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gJfvaJT3;
	spf=pass (imf27.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788487825; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=J+SHGWUY7CbETPDlAl8WdiZ5m/7wagn5ECpymwWOZn0=;
	b=gJfvaJT3Z+sg4w+QrBCDwxyaXNLLZeE3NaNV2yhyqE59IEhmIUiuxqXtbgoCITwX7XVWJLb+oexa+iHIjrO36bq+uDYWZFsfxDMEWLyMgGXTRmRXuBe3zNbxr/u3H7QEiZbdiUJeo1EtBjTHFUXBUU+GeI+UG77IgLqDPvcdbms=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0XAHIyJ-_1788487822;
Received: from 30.178.82.219(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAHIyJ-_1788487822 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 10:10:23 +0800
Message-ID: <697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com>
Date: Fri, 4 Sep 2026 10:10:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/list_lru: don't copy stale shrinker id from
 non-memcg-aware shrinkers
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lance Yang
 <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Xunlei Pang
 <xlpang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260901115104.2944996-1-qinyuntan@linux.alibaba.com>
 <aphXPCn8isUVV87k@localhost.localdomain>
 <0c5aba0f-137a-4aaf-bddc-060118322602@linux.alibaba.com>
 <apktMn_hwvZwsRUG@localhost.localdomain>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <apktMn_hwvZwsRUG@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 417D840002
X-Stat-Signature: 7am7e4du7h35wakfkte36utd6pa15ixs
X-HE-Tag: 1788487827-89670
X-HE-Meta: U2FsdGVkX186g4NJuXG/vFl3ziMHOGf8BYYnuZhWaeVTN/2IkH86L/iH2vYB6YDv3+8X6QTm7wyTUtwT6LwOyotJEnMVNPs3J2E1GMTf8klqZpaAg1/hqXyUCeUlDKTFSM7tZtp+QNDamxSTZ0JCc9+W6U8ZWa56Q3NfGaEJcdetJZw9e9DvIwUN7PrzazugJsw5U9qVIMecUOcoJQ7FFD9LGhAaIkI7mxIa/qyEwkG5BjwjN9RVRkaQTwlThaxna+/InLkOKZV0nrU+0+cE0P6Y+0AJ68qGxbO95uTiIpkd2OKa9AnPSuhTGlGWCOE55zb2hA3yG4qEeKAzAjfNmO5dX6LVvRTa+Eba3hLeDavvY8B3834OiczQorqyXqPJtiV1QT31egIBxqpdyhC3aA/yDGDBPwkjQ8pHF/+VbGxnAk2+PyELxTZPUFEFeWtUssDMCLwYD2w1RbwUxO2buFqu9lQzNydnWo39nNERxdI7it26gxHUR1WyD8CgKMFp10RrkuarUthWmExitmBR8qB0CV0sGtsedRVoA7vwg1P/26BCpCjUme8SotEPhllI4lqcohfXi+G8sCn3/539PY6i8NBzxVY0VNApI2SvyXfyfEtvvhyEc1IOOUblwR77kLb2LNCEq+EqkZtS0QmWC75Q6Xw748zGzpPPZiMKUnlU52lhdr+96DAmmyuSh4xmzynwCc2Hc2I1ppHk1DN5gvbm7naCnxw9X2T0sBcJfMd1q1yP/dqSy+kZ4OfLcaMqI/9a3jhC133QUFcYdpTPV4bG7go4Dmm/3DOR5lhqbZ47xccc0iuDlJYTS/cgY1EzlTzUBiXl0Vv+4Ez+rXWB2Tcs9k+/M+WrvVfnlfuZPKDfdv/cXN47+TR0TQYo+ZRrhD3JStCtp91liWbwMogWJACqCqo/e/DWQ4KYsVE4DTc+CzV40FJNnaXksZuDLJ9PG+IbBdh8fl2UwNBDrVc
 3QFPDFfG
 7OUz890dqX/RQ9SsAY2oeFoiIi9U3Dn395vhjxU1Kb30YYkpf970/cIjzUdbUsnxbOsSEbs3eS2XQCK5T3L/ha3D8YNv2vW6wrwPQd2b6OHNE/OCefe/NzRl/Pd+0yG/g3mG9Ke2hiHnr9TdGLoplnsk4OIlCkMvhHrDO+Miv9Z0fAkWElm1ZV8DKYH6ieG+jyZQHtJTU9iotUyRqFDQdZgvPqFN+AWkZYgW7QxZQ69LDeiG4bx7hlOJJhXWEsjV34E9kn5vUkapt5lieEM9Q3hovT3bqYcZEXabRHXGXphY1MSFHbC+oGtLoJffuaJSrUBaVL7esEFh/lh0OdCLt4OTh8oKvujvrBVSPoOTG6iLROY+EJnezfHJBag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Michal

On 9/3/26 5:20 PM, Michal Koutný wrote:
> On Thu, Sep 03, 2026 at 12:06:53PM +0800, Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:
>> You're right, that sentence is imprecise - SHRINKER_NONSLAB shrinkers
>> do register per-memcg under nokmem.  What I meant is that on a system
>> where no NONSLAB shrinker happens to register, shrinker_nr_max stays 0.
> 
> And ideally, with cgroup.memory=nokmem no slab-based code should call
> set_shrinker_bit() with whatever shrinker_id.
> 

Agreed, and with this patch that holds: slab-based lrus fall back to
shrinker_id == -1 and set_shrinker_bit() is never reached.

>> That said, I see the flag restoration and this patch as complementary
>> rather than either-or: 
> 
> Yes, it fixes your immediate issue and it is a prudent approach in
> list_lru_init(). OTOH, with this fixup, we won't be able to learn about
> shrinkers that are missing SHRINKER_NONSLAB.
>

True. Though the old behavior wasn't a reliable canary either: the
warning only fired while shrinker_nr_max was still 0. Once any
SHRINKER_NONSLAB shrinker had expanded the maps, a missing flag showed
up as a silently mis-set bit 0 rather than a warning. With your audit
below covering the current tree, I think losing that accidental signal
is an acceptable trade-off.
 
> 
>> other MEMCG_AWARE-but-not-NONSLAB shrinkers
>> (superblock, workingset shadow nodes) still take the fallback path
>> under nokmem by design, and __list_lru_init() copying an unassigned
>> id there is a landmine independent of the deferred split case.  So I
>> think this patch is still wanted as the generic fix, with the flag
>> restoration on top for THP.
>>
>> (zswap might deserve the same NONSLAB treatment as THP, btw - its
>> entries resolve the memcg from the folio's objcg, which is available
>> regardless of nokmem.)
> 
> _That_ is an important point.
> So that would need a fix too, and likely Fixes: b5ba474f3f518 ("zswap:
> shrink zswap pool based on memory pressure").
> 

Will do.

> (I'd have preferred if there weren't Fixes: 03375203e1da8 which honors
> the SHRINKER_NONSLAB semantics and it only uncovered pre-existing
> missing flags. Or keep that Fixes: but explain the relation to the other
> commits. (To make it clear to backporters.))
> 

Fair point.  I'd propose retargeting the tag to

  Fixes: fafaeceb89a5e ("mm: switch deferred split shrinker to list_lru")

as that is the commit that made the problem user-visible: it put a
list_lru holding charged user folios behind a fallback shrinker, and
the boot-time warning is reproducible from v7.2 on.  Does that work
for you?

Andrew, thanks for the sentence fixup yesterday.  If Michal agrees,
could you please also retarget the Fixes: tag:

  -Fixes: 03375203e1da8 ("mm: do not allocate shrinker info with cgroup.memory=nokmem")
  +Fixes: fafaeceb89a5e ("mm: switch deferred split shrinker to list_lru")

>> Would you like me to send a separate patch restoring SHRINKER_NONSLAB
>> in thp_shrinker_init() (Fixes: fafaeceb89a5e)?  Happy to do so if
>> that works for you.
> 
> SHRINKER_MEMCG_AWARE are due to be checked for correct marking with
> SHRINKER_NONSLAB. I can see that it is missing in: thp-deferred_split,
> zswap-shrinker in the v7.3-rc1. (The shrinkers in nfs42xattr.c seem to
> be slab-based so they're correct.)
> 

Thanks for auditing the whole tree.  I'll send a two-patch series
restoring/adding SHRINKER_NONSLAB for thp-deferred_split
(Fixes: fafaeceb89a5e) and zswap-shrinker (Fixes: b5ba474f3f518).

> The shrinkers mentioned in your original commit message:  workingset
> shadow nodes, superblock lrus are both slab-based, so systemd with only
> those shouldn't be affected by this bug.
> 

Right - they were listed only as lrus that end up carrying the bogus
id 0, not as triggers; as the changelog notes, their objects resolve
to a NULL memcg under nokmem so set_shrinker_bit() is never called for
them.  The only actual trigger is thp-deferred_split.

> Thanks,
> Michal


Thanks,

Qinyun Tan

