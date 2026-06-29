Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 989B1C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 02:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1246B0005; Sun, 28 Jun 2026 22:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861D66B0088; Sun, 28 Jun 2026 22:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7501C6B008A; Sun, 28 Jun 2026 22:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 475806B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:12:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE6801C645B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:12:02 +0000 (UTC)
X-FDA: 84931324884.03.69E8158
Received: from one.firstfloor.org (one.firstfloor.org [65.21.254.221])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1AC5BC0003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:12:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=firstfloor.org header.s=mail header.b=dJjN3COW;
	spf=pass (imf22.hostedemail.com: domain of andi@firstfloor.org designates 65.21.254.221 as permitted sender) smtp.mailfrom=andi@firstfloor.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782699121;
	b=142DFB5Vz3fqMoNMSi/R7fhbZyKrOs7/lSjBNZ9EF9MZdD9JprWGGZL6e8NJlrazpHAJDY
	vW8W3RzkmcgkiEPWhzi8LEEpLBrwaoK0P84/CN0osvoiSDj5GUAs4T1PxeDq8LdfQQERYi
	h9QzQ4xfGK8xZJh00RLHL/yNwQ5PXtM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782699121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ju+l1c1eu6zVsUY2O28hQpAXOGeb8J/0ohMkOsErdu8=;
	b=Guh1udFETsCJzoUJx2pazcd6pI1NuU0J7pXhXSIFDtAnshmeqon+Isnu8TWZF313zrgcAm
	uWoNaCgOWgFpafQdBHoDjFlMh2YmH3FSYZMqA1Q/KgkuZV6v1KCGYgd4x3uNtdEn34zhT/
	EnB05RNC8cs5Z/pOJcEKU+Jkw+u4iFY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=firstfloor.org header.s=mail header.b=dJjN3COW;
	spf=pass (imf22.hostedemail.com: domain of andi@firstfloor.org designates 65.21.254.221 as permitted sender) smtp.mailfrom=andi@firstfloor.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
	s=mail; t=1782699118;
	bh=RFG3rzu5a6Ap7m/l0KIWt23agkjRtO1qq92PQWzi49w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dJjN3COWIwqRMqxwVgtQuQdggZDssaR78n9SWsZ7HMfD4HwLIMI0jbAltBaMq55sA
	 j0R3zPaOyQSOczagvtS+qsgwqDIuziba9Ons2RHL1M5XFhmzqWN8A/HZF6C/BrLncX
	 q6QXw5w2oCh7Wv9PvURMJr1nELOmwNuWVx5vE0mo=
Received: by one.firstfloor.org (Postfix, from userid 503)
	id 70B0C5EAB0; Mon, 29 Jun 2026 04:11:58 +0200 (CEST)
Date: Sun, 28 Jun 2026 19:11:58 -0700
From: Andi Kleen <andi@firstfloor.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Byungchul Park <byungchul@sk.com>,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
Message-ID: <akHUboUaYi-OJHFu@firstfloor.org>
References: <cover.1782676497.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1782676497.git.mst@redhat.com>
X-Rspam-User: 
X-Stat-Signature: 5wza8mbte7gtx37d5gtihcywuofbhxsa
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1AC5BC0003
X-HE-Tag: 1782699120-72163
X-HE-Meta: U2FsdGVkX1+c/8q2rvxIlqjkTPiVsFPyQ/QPcjO7WCIdt6jQlRQAfmZk6SK8B7eGzNboeghjMXCdkEVmbvU35K1jgfUBQLuwjlZAmGRcqQGFjUrterSm6YUfGvFBV3zVjHyq5qT3c3TmqIBwBEGV4ltZBTrSpYdanA3m7200JQYbOPqdyy8mmlPa94o8rSpb0WX61GraibKi8TJPo7ZRFOgGL7GQRgA2yRRtsMl69WDtBNPmBBfDfRXLQrGhDxbazrESU6PBHXP4vS+pPpHVK6EDCuSTa5kzt2ZpDb6U4bRachMGrN1B2UdzmcKSflkqBIVja8okR5tUIVFYJnwXGtxfVasnfcm3RpdmDBKzCP/0qxU/D7Bu/YlvhUQLXoifXQazIjua3u68JVOSAJaYo6tBinMx8r7NtTVas0ffZ7vBZcBkSxkwUmjFpjpmrzUZNxLDyectiORLwLr/QaYYROY92qsg7DxpwnXhFycuqDBOLg3+wyAVF0HkdhzT5eM16TsKjAqC+dNkIPPvzQ1E2iIK46r8dsM2XC6Kld+N7PC0BGDh18rxlq94ZcS2xMyZXODCsgRYz8Lc05437irEJVLATjS2NgHuvW9+cJ4GhZicotrb/KqyTq01kEsMohlcY/7YAkp2cspY5Pzvr12UaWN523TPPpVXYeA1gdXH/Q+8QcpYo2MTpxNiCbt+xxbWHaKOX4W+wkAY4KUk1K3FvZMb4BModHs42vQnb/dfuumkarsBl52PAg6d1xTnWDj6oni+X0u45pMMCdpzCiqXt8oNosJWFvt5Tlr7FsIQZO/IfVtW53bt/b+4J8UrbOvaW9z75ouMGy4yYK1UUciT0DftiAvKpFTFePJKP7fUtrtJ/X7Jn8iZwCtPg0DYy0RLcL1rmCcqIpdxk/HKyp4gNKDtVPgWHfAX4b46Wuy9IjjUxZ4fgnO8L5HYSM65i9SSQb6bPtVrYbgcc9MzjVN
 VdSPPC66
 jnnW3WqvTcDYxp3cJBiycl7Bp8nns72sVUwsMIxKhkZNeR0iUB2780ASUUY0BRsebwY2CbugT2GADhzhfhwlEma097mwb5JWpxWaF4PtOgs/RxGwfMBIlJhaLXwMtktLT86/Mpk2imGNJAVXStuMO/l3D5qnyXapw9A4nCmPB4AciWRnZK9/aDG3vkNHmiBABqDJz6l9Jmarw5Wsp7cSlKDd5j1iGOmd2tbvF9877ffZAiOmc4q9ZHhI2nQk7X19j5yVX9lOVM3AjHCdm5v6QMkKeS9A44JXrVRZbz78LVFGKDtJSYpbvhP6xDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 28, 2026 at 05:45:22PM -0400, Michael S. Tsirkin wrote:
> This series fixes the race by:
> 
> 1. Having memory_failure() call synchronize_rcu() + retry after
>    setting HWPoison, so that any in-flight non-atomic RMW that
>    read the old flags value completes before we proceed.
>
> 2. Wrapping all non-atomic page flag operations in
>    rcu_read_lock/rcu_read_unlock (CONFIG_MEMORY_FAILURE only),
>    so that synchronize_rcu() actually drains them.

It wouldn't surprise me if your underlying performance assumptions 
-- an non contended atomic is cheaper than a rcu_read_lock/unlock --
are not true in various CPU/kernel configuration combinations.

Modern CPUs have fast atomics when uncontended in normal circumstances.

But it probably doesn't matter much either way because the difference
shouldn't be very much.  It seems very complicated for something that
could be much simpler.

But I guess it's fine.

-Andi

> 
> Performance impact (page alloc+free microbenchmark, 200K iterations,
> 20 runs, KVM guest, error bars are 3-sigma):
> 
>   !PREEMPT_RCU (x86):
>                          insns/iter      cycles/iter
>     base:                12237 +/- 1     17954 +/- 136
>     patched:             +22 +/- 1       -124 +/- 122
>                          (+0.18%)        (within noise)
> 
>   PREEMPT_RCU:
>                          insns/iter      cycles/iter
>     base:                12512 +/- 3     18541 +/- 214
>     patched:             +95 +/- 3       -12 +/- 161
>                          (+0.76%)        (within noise)
> 
> When !CONFIG_MEMORY_FAILURE, all wrappers compile away completely.

