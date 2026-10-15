Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF940CC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 08:20:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E37E26B008C; Thu, 15 Oct 2026 04:20:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F6C6B0092; Thu, 15 Oct 2026 04:20:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4CCB6B0095; Thu, 15 Oct 2026 04:20:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB2036B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:20:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 301761A0981
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:20:57 +0000 (UTC)
X-FDA: 85324164954.27.29AC761
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 34E85C0002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:20:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PfmiqPqt;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792052455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=74dmfERX3NwtAgK/bnYeEncu1DFsTgxUC4MCbXJ1IRg=;
	b=YlmqnQdXm7mwlWYFuf3PJYAAWXoTbiTxu7FG+Ur72X+91dUw+4Yoi63uWKQyDy7Q71E2Pf
	vcagVJHtAc/amJ48dYyWrAaPovsOPYcIkDdH3M0h2vhJ4iXVRQpQuyS70j5PObVjuXoils
	eQL72mDxgrWJQ1zK7EL9LBwKtIO6I8s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PfmiqPqt;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792052455;
	b=LbDcwzVJeTiPP4OlsbO9s7bSk4BwLih4rzDdZ9p+ZOAiCkGmWkuIIdhB3T9binP/+gvc2/
	vUzXRrZTXuZxcv6vcRCZ458VyM68VRKduZdaF2uMosRKVeSuGo0bPQpoR9q9F2/+iK2rsX
	PzoH/MGgvx+nBMjhfktxY3YWPj/1GkI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC0782F;
	Thu, 15 Oct 2026 01:20:50 -0700 (PDT)
Received: from [10.164.19.62] (unknown [10.164.19.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C0883F871;
	Thu, 15 Oct 2026 01:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792052454; bh=F5wGTE/FgF7+DxZwQR6hrwUobidum0QUlEo4Hxn7PgY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PfmiqPqtNGQ2dfYvOxXeKNFpBumxHwD1dnsfs6AQ3si8OoeyswdyPCoLhpbWLXBZB
	 sn3dTCfmjgXTHQN9NCjTotyUhehm0Hyq39Yd/3y4Ew5HkmxlfSbcTNN0vepn7KKauj
	 zSfZsJOHcWrwtnsnxm/y3Cu6cc6e6RTEVvd/wrLE=
Message-ID: <087678bc-41f8-4250-bde9-e9fe9399e67b@arm.com>
Date: Thu, 15 Oct 2026 13:50:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/5] mm/page_alloc: convert any movable pageblock on a
 non-movable allocation
To: Rik van Riel <riel@surriel.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org
References: <20261007021250.1665929-1-riel@surriel.com>
 <20261007021250.1665929-4-riel@surriel.com>
 <20261014204836.GI371161@cmpxchg.org>
 <5234543d2c1b44706501d2e079b41e95a6a1d200.camel@surriel.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <5234543d2c1b44706501d2e079b41e95a6a1d200.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 34E85C0002
X-Stat-Signature: cwg4ssz3obmc7g48s16da7oestgegsgu
X-HE-Tag: 1792052455-321995
X-HE-Meta: U2FsdGVkX1+qwF/7pj3cWZlZGobG/AyZ0BeSRgzBLNGSAJ98siqFtb4aZsRKFfOUGZkCOdoFjsjoLyqPag6cpcm/8S/rJLbE0L3+8ZYWggvbJ+rC+wI2uVMorwHfQx3NtmFCy3Mn6xdOB5Q8WRLDNd6hPgRaw8QW5keDRFrg8iBF24n0gizr+cw6tcoBVfS7HWas1fhqyiLotOysfTBwJahBO5Pv2OloxQeBYfDNnycrEAwk6mHGIshjBfSIiui1jjQyDOpPH5OWSzD2EhueoteXWWBSC+gNv+flWTZf0TyOOFzXKiywSjWCj7anVBxQXV+lhKSYfXvdQx8CbOS0IsMzm2EQJOd1SqhBVyzlzDqpmF4TJdyU1Mr0S1Rz+xGYXYgKHrEkMoPAHDdcUMxz+yE68L8Y4BvllyvH3wVmihec7DhlUlc77/EkUWaY3cxxvOWiZ8GvKPHOjljdWWQdauEt08JEK9Dp1XceZs4yL9ALZTrjiXnpeq4G5tFuHIriCNiONW8erPln1TvqTY3Di2bhp1wiEUx1RG7kpZmgBH7ZOgtVErFTAcp6FnwMTdH9O5qKs0X8Bt7e3UEKx7rm6C44rnb6Lgcg8y6VGGM87EbSgeOGQe9CDYIoODRn7oC0W7L9iRL4DceSahXVHQqSO5Xta7Jg/I1DXU6R/y9tpH91g1KfdjpDjpRq9czMVa2xG4RHBEF13NuggZHHaAMc3u6lDGh8BbGHosk1jPhPRsPunDY/lqSe5Y26BRqQEuce2SsKxEWf3Zrg0Zli/kWJpCXyIylubbVHMQg91/XJV/oxIYbKOnlNYd/KVQ0dnx9WL8Lge+K7yIJIbHJDBMKjXXsxrGXOd6TRCeS/qZYJAyqdicTn1XgJukkqkt/S3O/wCRPcTiqVD+TCpMgY5zxRFU5Bjr90rezUUVdVKzQExyslBom/B/BTn1WohRy6FxwdaMDodqC1ZfOjaHlsDP+
 25c49CEe
 c/lg9iZb6W1CDRo4IwOBHTKYWJ4imESvNg/cXM4pzTwKMBOvttL5mPVz29BhXGQaKXBasqmNey7Hkp+dWU7ux+vA057B7ejDm+/pQEijpII487bKN4XHhl7PAOejiQzMM3hGyZSkcuYIzPDmituKnSrGC/2yXJzy6uJK55sDX9UjsQD98vTwmVMFqIE6R35B0r/zkJeQ/jKVc+LdwCG493Bcfm2hmUFnLgT39qURptAA1TQU+c85pibxXaCIFKdHbDKTx9yxFZOL1xno662P3MQl86wejbzJ3gefzu+LsgtcYov2ydcpvmILKgSoPeg1Lf+vGaeug67FO16E8ztGcwOuXjspQ2sjFfPSSa3pABXaCHAHTZZUP3JbIVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/10/26 2:23 am, Rik van Riel wrote:
> On Wed, 2026-10-14 at 22:48 +0200, Johannes Weiner wrote:
>> On Tue, Oct 06, 2026 at 10:12:48PM -0400, Rik van Riel wrote:
>>> try_to_claim_block() converts a movable pageblock for a non-movable
>>> allocation only when half its pages are free or compatible.
>>> Otherwise the steal path takes pages without converting, and
>>> non-movable content sits in a block still typed movable.
>>>
>>> Convert a movable block on any non-movable claim, however few of
>>> its pages are free, so the block's type matches the allocation it
>>> serves.
>>>
>>> When other pages in the block are freed later, they end up on the
>>> non-movable free lists, directing more non-movable allocations to
>>> the already non-movable page blocks.
>>>
>>> Converting a non-movable pageblock to movable is made stricter:
>>> a movable claim takes a non-movable block only when every page
>>> is free or movable.
>>>
>>> Blocks straddling a zone edge are never claimed;
>>> zone_spans_pageblock() tests for a block wholly inside its zone.
>>>
>>> Assisted-by: LLM
>>> Signed-off-by: Rik van Riel <riel@surriel.com>
>>
>> I like this in theory, but wonder how this behaves in practice.
>>
>> The block is claimed, but the movable constituents aren't proactively
>> kicked out.
> 
> I have code for that, too, but it seems like
> it's a lot easier to get things reviewed in
> small portions.
> 
> If you want I can resend this as a larger
> series, with:
> 1) the pageblock claiming
> 2) per migrate type free lists
> 3) evacuation of movable pages from unmovable 
>    pageblocks, when the kernel free lists fall 
>    below a watermark
> 
> That would be the full extent of the 2MB granularity
> fragmentation avoidance stuff I have here.

I think your patch series applied as-is would regress stuff:
we may have lots of UNMOVABLE pageblocks with lots of
movable allocations, unable to be rescued, hurting mTHP
allocations.

> 
> Just let me know your preference.
> 


