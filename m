Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74E09C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 04:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3138C6B00A4; Thu,  3 Sep 2026 00:07:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4A16B00A5; Thu,  3 Sep 2026 00:07:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3E56B00A6; Thu,  3 Sep 2026 00:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E26676B00A4
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:07:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6BC3B1A0410
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:07:05 +0000 (UTC)
X-FDA: 85171115610.20.019A77A
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 326681C0006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:07:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZtwljQv+;
	spf=pass (imf21.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788408423;
	b=4zX5ncDTRvsh3RJDeYvkwRLHS0Dyim5qWW2Zc1Nweusbv7BBS3Wo/SWbBJ3b8melcCNUog
	ufaqCfF//SQF5K7KfyoqnBkU73Uoszb6xgvJWoX5GxcBuaYMleZEWetuZdM994cOj0VBn8
	k1G8neyfqIaWoRkNBRLoI0rqU/hWofo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788408423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EFwlSXqfNEKM0ur5X+fXDaf9C70UjzJTOT5AZjis8cs=;
	b=IT7KwywOvL09cjYP/HvGd48T/7+5XuBYgsYyCYeuL4HuA25fKSWdljPnjabxGHkNSLQFy0
	u6f2QaeAGexRbFENvqY+OpNtEYunTGIXyEWNuLtz5WY0aSXBQfJywNKxzvZWUXgl4EaD8p
	jO0WsXCaCwqcQIJF8dtXbTHLOuUYViA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZtwljQv+;
	spf=pass (imf21.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788408419; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=EFwlSXqfNEKM0ur5X+fXDaf9C70UjzJTOT5AZjis8cs=;
	b=ZtwljQv+5sMDovzHR8a+QfaF7M08zoSx+QfWh1H2EPGvaRj4O3g3ltU4PvJHkeiyiw0K1xUBM2zCBfKEevBtKOVjSh2Drkqzz4cb3XwZSvPn+WhcK3OF84eR9WLaPVPMLk0ortS0h2TYF/Hz4il1UK24gUfnNaNEcCrtJTQZCWM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0XAEokn0_1788408416;
Received: from 30.178.83.4(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAEokn0_1788408416 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 03 Sep 2026 12:06:57 +0800
Message-ID: <0c5aba0f-137a-4aaf-bddc-060118322602@linux.alibaba.com>
Date: Thu, 3 Sep 2026 12:06:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/list_lru: don't copy stale shrinker id from
 non-memcg-aware shrinkers
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Xunlei Pang
 <xlpang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260901115104.2944996-1-qinyuntan@linux.alibaba.com>
 <aphXPCn8isUVV87k@localhost.localdomain>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <aphXPCn8isUVV87k@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 326681C0006
X-Stat-Signature: mm1d5qbk3nc3a5gfz6nxcte4za6z49qi
X-HE-Tag: 1788408421-864802
X-HE-Meta: U2FsdGVkX1/2iVmjGum0fgxtOTGclD0j7CEG46Qn59lZonnXzNODxH0aYcLUFw8shlC/gF4hawfs54DnjfhztC4AmJtub3GOPyrPxUD45z1H4UYSoeIv346iRw7vOtI8bO8rUA+q6BzPi9A6I+4Zz9CQ2Xs4PUG1fVKSm6N/9B2SSYdModTIGFuNxtck7lhIW7r80kHllEbvjpLwi/tmW+Jzt5OflPgj4QfB83ijz9Zst9M13ZygnZNVJdAYJqo1zO0Yj9PM7MjglyjnpGKMJxz6l52JM9drIPtd4nM4YCxlS+1310iVNVcFRCmm5I4cSjJj4Ev93pRvL50ypdG81Hf+kMO5AOs8npFQHW+kW74Gt8TPxdR1RbK43QPdEwOgpnbaYpSrVshzqzmr2VEINMJG3SSDAoE5eHyiGY+Mhl0vPAaHRXTdJ+Umfc899/FB4E/P0PDl3Y/n0mJ5IFfuagS/9rjtjArcBnvXM9BqDuM5cP7+lAXicSgqEmQx7c3M07pqiaF5Pjj4sg5Pf+S9BAHh/MoqlnM70k2JqMQOpj2jo3YdUNsGaLA+a5I3wf46dPg39ghSb+xa0tmDGjHOXXPI42XTKyEZt1qlknWjAP1NtlcmJJepQ4JH7kPJpd45UL8voO1Ap3cmx2DICjgat/p6QMIbXctRZfvN15EJ+biSnAVW9Uk0IgKIZ+/jcO8q5F03hxVS+SuBrfWFHwhvEWlEPo2Hrx9HCOGNVw2maZcNgw+INa1p/zIHdJrIiJbezqSGsUz+wAy18cu0Bci43gOM0xiBLeJSaXysPDIQSqQwBjApZ4D839BKaRW8yUtCM52pBhnI+DS/aq9OYfQZIJLMXKCsPggyN3OsoaM+DxrX1s2tW/WV4z7Ofn9Dvi/Zcn25Zua3MHkBFQfvwCW47tqRGd4zZMaR3NXJjiC2HalugI7M9mgZSVq4L+D9lIriayb9BcBZGjrcst0MDdf
 ayaL4MDn
 lFTmwXke19Nta1a0VBwJ06A8gYaxy3dQDPTgziR9V1xBldGiahjSxzivnPHU79zHOyK5aVAqIPCnl33lVYdfxwHg17+nd+2r45zzWxjdDuVASreO0uFU89BzEp0IyiYN9Dj3PhSEXuwDJSauV80OXnEb6hvs2dB9MoHrrJdv9KwnIAvvUk6WMJt+jStpV5+A+ndrz68f6HUfwPtMGWv+A2ZoljMOxzML8J07dPhjzxB81atGrUXPV2pfbscx2SJlvM75aTWmWYVdS1ukUJ13KyQVNhqtRX+hilMR8mF+UwVyLpOSGZMYWUMmcnEDkCFZcgSPq9dTk9WdTRPPDAbhDQnl6JpzXTt7VXSpHzFTj1MOP8AgDtsLYRk2iXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

On 9/3/26 1:17 AM, Michal Koutný wrote:
> Hello Qinyun.
> 
> On Tue, Sep 01, 2026 at 07:51:04PM +0800, Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:
>> With cgroup.memory=nokmem, shrinker_memcg_alloc() fails with -ENOSYS
>> for shrinkers without SHRINKER_NONSLAB, and shrinker_alloc() falls
>> back to a non-memcg-aware shrinker.  On this fallback path,
>> shrinker->id is never assigned and keeps 0 from kzalloc(), which is a
>> valid id belonging to whichever memcg-aware shrinker registers first.
>>
>> __list_lru_init() copies shrinker->id unconditionally, so every
>> list_lru backed by such a fallback shrinker (thp-deferred_split,
>> zswap-shrinker, workingset shadow nodes, superblock lrus, ...) ends
>> up with lru->shrinker_id == 0 instead of -1.
> 
> <del>thp-deferred_split shrinek has SHRINKER_NONSLAB so, the id should be
> assigned (at least I see it in thp_shrinker_init()).</del> I was looking
> at 6.12 kernel.
> 
>> Under nokmem the list_lru collapses to the shared per-node lists, but
>> __list_lru_add() still calls set_shrinker_bit() against the memcg of
>> the added object.  Most list_lru users are unaffected because their
>> objects resolve to a NULL memcg without kmem accounting, but the THP
>> deferred split queue holds user folios, which are charged regardless
>> of nokmem.  Since no memcg-aware shrinker can register under nokmem,
> 
> Not sure I understand here, the SHRINKER_NONSLAB are excluded and should
> still register for per-memcg info.
>
You're right, that sentence is imprecise - SHRINKER_NONSLAB shrinkers
do register per-memcg under nokmem.  What I meant is that on a system
where no NONSLAB shrinker happens to register, shrinker_nr_max stays 0.

>> shrinker_nr_max stays 0 and every memcg's shrinker_info has
>> map_nr_max == 0, so the first folio added by khugepaged triggers on
>> every boot:
>>
>>   WARNING: mm/shrinker.c:212 at set_shrinker_bit+0x99/0xa0
>>
>> On systems where a SHRINKER_NONSLAB shrinker (btrfs, xfs) did register
>> and expand the maps, there is no warning; instead bit 0 is set
>> spuriously for an unrelated shrinker.
> 
> Could it be that you see this issue because of a shrinker which isn't
> marked as SHRINKER_NONSLAB?
> 
> I'd even go as far as pointing at
> fafaeceb89a5e ("mm: switch deferred split shrinker to list_lru")
> which removed the flag from the the thp-deferred_split shrinker.
> 
> IOW, the proper fix should be addition of SHRINKER_NONSLAB so that
> per-memcg maps are properly allocated.
> 
> Thanks,
> Michal

Yes, good catch.  The flag was originally introduced for this very
shrinker by 0a432dcbeb32 ("mm: shrinker: make shrinker not depend on
memcg kmem"), and your 03375203e1da8 changelog even cites
deferred_split_shrinker as the NONSLAB example that still needs
per-memcg data.  fafaeceb89a5e dropped the flag without mentioning it
in the changelog, so this looks like an unintended loss.

That said, I see the flag restoration and this patch as complementary
rather than either-or: other MEMCG_AWARE-but-not-NONSLAB shrinkers
(superblock, workingset shadow nodes) still take the fallback path
under nokmem by design, and __list_lru_init() copying an unassigned
id there is a landmine independent of the deferred split case.  So I
think this patch is still wanted as the generic fix, with the flag
restoration on top for THP.

(zswap might deserve the same NONSLAB treatment as THP, btw - its
entries resolve the memcg from the folio's objcg, which is available
regardless of nokmem.)

Would you like me to send a separate patch restoring SHRINKER_NONSLAB
in thp_shrinker_init() (Fixes: fafaeceb89a5e)?  Happy to do so if
that works for you.

Andrew, since the patch is already in mm-new, could you please update
this changelog sentence

	"Since no memcg-aware shrinker can register under nokmem,"
to
	"On a system where no SHRINKER_NONSLAB shrinker registers,"

per Michal's comment above?  Or I can send a v2 if you prefer.

Thanks,
Qinyun Tan

