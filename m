Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82E35C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB696B0088; Tue, 22 Sep 2026 22:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46C4F6B008A; Tue, 22 Sep 2026 22:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35DD36B008C; Tue, 22 Sep 2026 22:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 066AA6B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:58:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED8224064E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:58:21 +0000 (UTC)
X-FDA: 85243518402.15.5301121
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf23.hostedemail.com (Postfix) with ESMTP id B4E0F140003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:58:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GC52+vuf;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790132298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MpMJiNla5q0wcx6Bz2QNntowy7sWY2tZqARzYeGdoq0=;
	b=rBEg7h1yLvcsXd4dAv8WHKecBJcGnJYa4Jw5m4HTKpiWtKlT8b/orluhI00HuI8E6d6m3v
	rMvs2on8YIOrYLyYcZgt0cpNpCzV28taNnpLDmb+f06Vqz51OGDQmokbBlyaGPCRCkZHym
	yvupwquml/f+CRN4JPj6wdRhAJ9xuLY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GC52+vuf;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790132298;
	b=5oIbP7TEHa1fynBfCGlRsKaEnhG99M7uFZU7OG+Xe7wKiksWtO/H0e6xkQMCBDuay1nub0
	1MeFCYc5iYfRHhS8VEAgRT7d858nDP99XpeTlzIKq424yOf6FQJb7wOqTdtzCnpKPdKoYv
	hopb+SER0wzStIK/rjpwGSR6+1m4xRs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790132292; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=MpMJiNla5q0wcx6Bz2QNntowy7sWY2tZqARzYeGdoq0=;
	b=GC52+vuf+oHB6bZ6d5QWnpsB6qstrragnzoV53qNEPHPKqd/ySMfWdLlInZJPpnQG7ESKqhirMqImuf+hNSzBars7TI4/Miu0C7G/uS/At9gHGss1muadquUCOy7RVDq8r20CxIvtqm00o5aB/J9YltVuGH32R1V8g+5cq1/M4k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XBVYz1B_1790132287;
Received: from 30.74.144.107(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBVYz1B_1790132287 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Sep 2026 10:58:08 +0800
Message-ID: <167f0a33-315a-4782-bbfa-edab3fa22ace@linux.alibaba.com>
Date: Wed, 23 Sep 2026 10:58:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2] mm: vmscan: put rotation-missed folios at the
 LRU tail
To: Ridong Chen <ridong.chen@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260920132519.3369946-1-ridong.chen@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260920132519.3369946-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1c5f86wo7q68kks3k969awybgu878rcg
X-Rspamd-Queue-Id: B4E0F140003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790132296-388773
X-HE-Meta: U2FsdGVkX1+ECRjNRSL13WuC73PhD/BT0RalnVnghzUGEohfUD5K61xkD/PvOZowLrfrq9VQc6D91xrVCWpiqHDVXj7iFhMrw/OPkjxe8JgER+QAOxuIPWg3S7qAEeB1JXyG9OaFVIzj4YXkr612KKx9N1bJDaXYF1N8d8adt8NyA6c2AN/BLdq7Ioxc0olgcDkNvjXcWWgQT1cvNj+2y2teJNUs2LcntbaTB/khW7kwEOmeksAiyywOzwhGZG3t5RfFO+C89eFqrLRCBzSZt1Rr53v5c2dJCfGqO5IO3bS6lS6kro8RQoLEYf2tM2WDR8nyr/Kg/ShIZOA/EYWYoJX2lug/FfdlgRUIM2D7OYbXTWAImldrUb4SzSC5oef/pYw6sG6w0HxOro9269gwVXyEH7BkKW6shDBp2tzr6E3BE7JUwIToLyeZC1e4aYH0e76wJAuJTM0O4E69xvfdIIKc4L0wRS5vRsMIRV5IQsC5+7NUJ0cx3eHSTJF9Q2wvf0V9xG8H2NHQZovqUplPkTv31w7yEOkBVGnjeYqTPTdjUBd8wjQz1hj4sJS8im2+RlN+nAJtevAJpUgA7F8gHwyyGDD+z7m2fGSZ207TNDC/NbewQHlQp4pFCcqlY2DwAPCNQUrFU0TU70xURBOBoIwtw97CxzTVlnLCBDHL6hFSuLMlanV2X6Ogi7OYMFtnD6ReB/Kx+r/y+kxsouWC5Mwc6veGLxMr8XbIjM3y2zt3m35Ri/2xDWQHq1Ezt6+Ab4g5a8aQ5jFOOqTqo3TZvnXI3LKIvNHOVyIpW6dmtlZurwfuqHgqDkKiS8c8FEQUtPJLzRyakOmN4SeoUDiRLDcwp9I2S3Q4cgFNIfumpmCEmii8U/lEgK58aGnf2JBiizJjWPQe0MDp4RBRoUILctLIh/XRHIg5YD2HgH5HlAEdQ2D77Zoig0NEstnv4DGmsvuAhmHZyyWFMNySfw0
 ZHQxaiHd
 ziTKD9iWsfjfRtiUqGQHHM8C2i/WfsdwizYim3Bf0tancMwp/TigJZhkeK7fOuCJjWLhoD2Y3uHyw3aIuSakG4w8v8Q44FzNg59qVpSwom8BRR+JqoDAOmlWmR+KLdE8G85r+Q19bdBolCG7+TF1efmszHFgswZdRjUcB1e9cNgAY6RPIMFAqdI4l4Q8nj7rjhyjcwjoWbcreKLt85EM47X84y4Ty9PNVFahJoswKt/zGkz8NY3WJTRqm7EUwPeEgj/1Au/0AunNk9aZTrwBm9vXnnj5wxgYSi/C2YKV8PTEyFvbJzsxJbZa0szkwxOcsW5aL8RlHTUlDR/4ohM50kVPBnEs6jnOKia1OYq9yrchUr3NTrep8tQLZaoj1Y2kUmPENwV5qnJaKMTo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/20/26 9:25 PM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The page reclaim isolates a batch of folios from the tail of an LRU list
> and works on them one by one.  For a suitable swap-backed folio on an
> async swap device, it queues the folio for writeback and, after finishing
> the batch, puts the folio back to the head of the original LRU list.
> 
> Meanwhile the page writeback flushes the queued folios in its own,
> independent batches.  For each folio it writes back it calls
> folio_rotate_reclaimable(), which tries to rotate the folio to the LRU
> tail.  But folio_rotate_reclaimable() only takes effect once the folio has
> been put back by reclaim.  If the async swap device is fast enough, the
> writeback can complete a folio while reclaim is still working on the rest
> of the batch that contains it.  In that case the folio stays near the head
> and reclaim will not revisit it before wrapping around, causing a cold/hot
> inversion: a clean, written-back folio that should be a prime reclaim
> candidate is kept ahead of hotter folios.
> 
> commit 359a5e1416ca ("mm: multi-gen LRU: retry folios written back while
> isolated") addressed this for MGLRU only.  The traditional active/inactive
> LRU has the same problem, reported at [1].  A reproducer is available at
> [2].
> 
> Rather than re-reclaiming those folios (which would drop the swap cache
> that may still be useful for a future hit [4]), restore the rotation that
> was missed: when move_folios_to_lru() puts a folio back, add it to the LRU
> tail if it looks like it missed folio_rotate_reclaimable() (inactive, not
> mapped, not dirty and not under writeback).  A referenced folio is left at
> the head so it still gets a second chance, and a folio with an unexpected
> reference (e.g. a GUP or speculative pin) is left at the head because it
> cannot be reclaimed yet anyway.  A new do_rotate parameter gates this so
> it only applies on the reclaim put-back path (shrink_inactive_list()), not
> on shrink_active_list() where the list order is already deliberate.  This
> approach was suggested by Barry Song [3].
> 
> Only the traditional LRU is handled here.  MGLRU already retries such
> folios via its own clean-list retry pass in evict_folios(), so it is left
> unchanged.  The same do_rotate scheme could later replace that retry pass
> to unify both LRUs, which is left for a follow-up.
> 
> Test result with [2]:
> 
>    Without patch:
>      cat memory.usage_in_bytes
>      1073700864
>      cat memory.memsw.usage_in_bytes
>      1413124096
> 
>      free -h
>                    total        used        free
>      Mem:           1.6Gi       1.2Gi       299Mi
>      Swap:          1.0Gi       678Mi       346Mi
> 
>    With patch:
>      cat memory.usage_in_bytes
>      1071140864
>      cat memory.memsw.usage_in_bytes
>      1413423104
> 
>      free -h
>                    total        used        free
>      Mem:           1.6Gi       1.2Gi       322Mi
>      Swap:          1.0Gi       328Mi       695Mi
> 
> After applying the patch, the difference between
> memory.memsw.usage_in_bytes and memory.usage_in_bytes is close to the swap
> "used" value reported by 'free -h'.
> 
> [1] https://lore.kernel.org/linux-kernel/20241010081802.290893-1-chenridong@huaweicloud.com/
> [2] https://lore.kernel.org/lkml/46037a37-4cf6-448e-a94b-30a4d16e8814@linux.dev/
> [3] https://lore.kernel.org/lkml/CAGsJ_4zwP3_+EYY5Ug9EJ+yD1UdxsBSGr25u8s1K3u_i7LH3Zg@mail.gmail.com/
> [4] https://lore.kernel.org/linux-mm/20260911121341.178028-1-alex@ghiti.fr/
> 
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

