Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6E7FC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 11:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7C86B00B0; Mon, 20 Jul 2026 07:05:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A89406B00B1; Mon, 20 Jul 2026 07:05:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99E666B00B3; Mon, 20 Jul 2026 07:05:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71B1E6B00B0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:05:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF5C1120120
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:05:18 +0000 (UTC)
X-FDA: 85008873516.24.08CF1C4
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1C269140007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:05:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RK0CYnUC;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784545517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LE7lXg74pYORpbuFx4QOJ0MptzoQRSngymT9gqZ/79o=;
	b=nbUcGEB1jZH7dcYhaqZPerhY6PLuhHSZj9ZYwUF0p/wGNsVQ38LHHiLIoac6H2ArK3w5GB
	6aBoSRqZtmlL+Wgun180N30QebJlIyy8huVWIq+MNbdZYbm2NVuy4asVWczt6S2zxHvOTM
	d0uihksA+87d5pDx2hhBsgqu/J/rD1M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784545517;
	b=MmLDFjIz8XwPi9uOwPJp+VXwhqGi+D+Awjdg9AGXqKrJNuLQW4KZWloxGEmlxlRBdmXK9I
	7i3tBHsplIp5GirLMBP5q/bh3GZlyh9IyRH1aEzY1DGLMQ/mFWsVzTGOIZMK3Oq6cwbv+t
	oAfLHXRseVF/c2MtxEnfvXZsCp9lMEE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RK0CYnUC;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784545515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LE7lXg74pYORpbuFx4QOJ0MptzoQRSngymT9gqZ/79o=;
	b=RK0CYnUCMrkf7s5idwexHk4YSU/n6GI0NkkE16RN6kbocii8IM+z4dsvTuE517nvs1+97m
	qNv/bV5xJHM1Kp6qtLRJu1xVmamUvZpcfZJnI3VPkbP51b00WscxYogMSymtIZHVyB9vX5
	IJQy6tUT2NwLd6nk7RQiKzCssUU2dNY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 06/17] mm/mm_init: factor out pfn_to_zone()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260720093127.540540-7-songmuchun@bytedance.com>
Date: Mon, 20 Jul 2026 19:04:35 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3E402DBA-58EC-4FA9-B1D6-33DC7185AE19@linux.dev>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
 <20260720093127.540540-7-songmuchun@bytedance.com>
To: Muchun Song <songmuchun@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1rtuab1o6r75dwapkscpqdbo3bp4b7g5
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1C269140007
X-HE-Tag: 1784545516-641924
X-HE-Meta: U2FsdGVkX1+jYzSEXgaPLzkE6ZVaXEU8Z79M92s9H3xzQQsA2ZFK3k+Ov+MByI08Tyx12OM61jMKZh/nzYQnBzxJjAynsi/lwua0LhkNThldZRwUchgst3qFASdq+Wtegq4jw2IGoQ3rUSH0HUrBebfDPU+d2BH6mQRCVlId1ZQWpAPBgU8lE3mV8aI1Pq0LVgIWy/zesZEFOsCt6h5IItzZ1MdAYbNXpQ5QCyjvi75jzL+69LQi91vIjuSRo+gfM/z/s+zYd8tId/EMd25zkvr7rqqQs5kTUPQnjF9RJa01wYCL5nwSJsTMAtPvYcuRzeo+qTOcxwjyaYnt69uRE1/4JkFl/xH2Rc+i23xhwytyNUeGU41NxTyU/dh85V1wJjpxcgBLlZSfMNKYqnQIjE7AqXSePYSk4B53bzO3drK242RhMEACmT3hOfCD5Q513e02JANuVf7+LnfLCLJsJtR9v21wUmvN3YX50Ip6gV3K6Mre27NqRcbTv8mhj/rkhBd7kEgZDdWe2VV00D+ysHZUiTSm5Song45YT3t0YXjoBb659aChu2rSMeNNrL0DBr3jhD5rPz4ZlfGtPxB4ugN+i0+KzbqtKpMik4CI9Y13rE+RjOHporOzmFObtI1XWUUhBV6yt/oj/+UtgdZz++mzZdu5YKBCpc7SU6ABNbzAEowf1JuwnNAvRdN+QEE7og+KO8PJ5T1iiIWHKg+JQPQ7l3eWJyaY//rlvE7HsWrdoXgRo/Z7p57al1Bi13Ij8nseeRO7VFf0EkyTUkZFichUHhaYtaKxM0o1AwyK6DTDkRQF7KErkXJvcundJQ0yv9Psug05mts4olGWTUEU1rINu4p2aJ005j+0se7JcaxB+tww0uJup9q1SKZZXbGB2NUn62BaHNOafwizWdKOkYU6YBqJNtbbqq5g7A8n7Tq3apiJk/p6Dfnhu3PjhckPW4GwfR1u+98yDJoSFbM
 Krw4Q70w
 ws8BhEOqGEzQ3ttD7Hw79o/UKmjse/q6yUcA9vDpfW2vxuqGUGmzQ1gCzBhgCkU+WhWkp0zC5wOzc2RRikXvxNslCh8q3ezbZd5P9eSLhFV/b3dn9PwuJCDDNOX6xjGgfN9VKxwHLLzEbun3WKEkuNPhJIK4T8OLwU2g4wET5vWmcLBeei8l78J2vaK2Ixvvxe4tJ3E/+oqsjOupi023A5xJssgS2SCoERRTEQxxYnbx9L4WcLFYDPN6IsrWy5HH7HiBZdEypd1t9/KlxqvyJ6cj5kS3/6gN020OVTKz3qrz5gaHcsF5eLMdzYxXUygD6P5nInh4VLu0FOGBvPibfqoGFJpFcZqZcpR9WDN1y6ztcZjsxkgmQuBsct872MH7one/R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 20, 2026, at 17:31, Muchun Song <songmuchun@bytedance.com> wrote:
> 
> pfn_to_zone() in hugetlb_vmemmap.c duplicates the zone lookup logic in
> __init_deferred_page().
> 
> Move it to mm_init.c, declare it in mm/internal.h, and reuse it from
> __init_deferred_page() and HugeTLB early vmemmap initialization instead
> of open-coding the zone walk there.

Sashiko said "the declaration is actually in mm/mm_init.h". That is indeed
an issue. When I was handling the rebase, I forgot to update the commit
message here due to code conflicts. I will fix this in the next version.

Thanks.

