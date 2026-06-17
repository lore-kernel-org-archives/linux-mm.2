Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ECB7CD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 17:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8CDF6B009F; Wed, 17 Jun 2026 13:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3E5E6B00A0; Wed, 17 Jun 2026 13:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54066B00A1; Wed, 17 Jun 2026 13:36:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 889676B009F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:36:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4BAF01C4831
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:36:05 +0000 (UTC)
X-FDA: 84890107890.12.FBE46B4
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 47902A0003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:36:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cLmyeicQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781717763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T5V4tVp6yKnTKF6RniMiSm/7lWhPKZviX4QeBCL6yRU=;
	b=Ihc3KNDuyKvsn+xRNUKyuZzFZlHS8vNwckW2JJZExSQC5rIVVlW6hVcvcqoRv5gmIHemgr
	7o3JoJ+hHmq2NJX2DNez/GE3qnbQj9BgG3JKJ3K2x3DETUtlzC1n115eqSF2lQnjVhMn11
	AS/Ty1zwLdED4kxIhC884rxCr2oxcU4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cLmyeicQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781717763;
	b=VpjWMGJcfJvWGlaIXDippfhzfzgGqzDtCpBttuGQIHOf1l+0iIFA4L6cu12b/i8Vyq44cq
	X/XK+X6ZWACjZQETg+y5V78DoEM2aWISq/jyWFqW3YfKivc2nN6k6J/Gd/g9eveaU3wX6D
	eZrHp5GDWYBi9WZlpklfFCesSaDc0Lw=
Message-ID: <9370ec06-417c-46e1-8874-2613cdd6372b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781717761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T5V4tVp6yKnTKF6RniMiSm/7lWhPKZviX4QeBCL6yRU=;
	b=cLmyeicQb1OOCtrCPxsmlxji/GtE3X2lza/AN5O0w0VmbN+LeKTzSfzormpVJKwWIVhbQ1
	sXjl7sqg5xTfjMp3mEa//bgFiluJtHsbg5c5PCEdP0g7OjWOB0G/c+7y6eYXhvyeh17Ntv
	9qrkJe/DJzq6+6UaJE4D5gFDmqKvBv0=
Date: Wed, 17 Jun 2026 10:35:43 -0700
MIME-Version: 1.0
Subject: Re: [PATCH] mm/page_alloc: use existing highatomic reserves on the
 buddy fastpath
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, fvdl@google.com, linux-mm@kvack.org
Cc: shakeel.butt@linux.dev, usama.arif@linux.dev, linux-kernel@vger.kernel.org
References: <20260616191420.52556-1-jp.kobryn@linux.dev>
 <fa69e7f3-45da-4722-b47f-e6fcd38717c7@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <fa69e7f3-45da-4722-b47f-e6fcd38717c7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 47902A0003
X-Stat-Signature: 431rbptynwm5mnkbonqtoymuqxcpuomj
X-HE-Tag: 1781717763-645614
X-HE-Meta: U2FsdGVkX18vIHTLamZbOfCYOdQUK+HDP9PazdW/t8hz2n3rvHG4OKadS8e5bgIbVYvdlx16b8EJonzl+jlTrbi4dPTbugKGWx9syvecapWLWjH9q3mHWo3kTnJPqSzC+ywqXsTLS6Hg/1lqwRC81HP9J4chRBKDhtaz58+zZWHFU0amZA0YE6BVPR6lfFixZNZYRcLAiv/tugiL7vjMzCLKgvdY1umedm4DncTPW7ugFdOmbpzmJI+1fxPjGO9owHnDQkNBQ8uzKVO3vgYwHNpZmrr5tOI9x6dfZ/AxMNjFB99VOsEuvFFtzSsCfdQfYTNqIONQTNAoMIbx5xVK33OraFH0eJZpO/HeOZ7+LseZmWxIM4ak7FZwyW+pvqbzaH+9CKv9UIntOZiW5eptYIXN/dRaf3rA7K0NvZ/0wZ8FYAw17IgKF0bWNRkrO6Mfj7EWaP9fbUgTCa9JHgFJS9dwr7CCtBrv15QCijwIQCqTVHYFdXm6nQiAQcmoPpEGu7z13pEFG+4qGAYtz/hqni6w+odYDRUu30RlGjaaYHzNxEEmmI5oLuWAJZOW/t9dzwIpb1S/enAdPT2OquqsmhF6i3+iaWixDtM+v/5L0ph+Sw3GJ6GcbdSHZF7nofk7zJmFdUwzrCwwSANDTpFINoGdIYPnPCZ5a/PP4GzUdInfCNuZZd/tLf6YrMljOnU9epkVe75by941RYq1Qu/f/C/N8VqJRniCewZzi1cz/XIQaXk5XgAZM/20b2lpZ6azzfsOqsk6ijQJdLbmaD6j7YWcC97s2oHKs+GcJ+7OfZV6ei0KYJ4J60L9pbXFs7LstXEEcE3OKm9Q6NF0xfdM1zCKgftapmiZZq1zlwG/SfMRPIcrWwuq9DUssWZ/HhszsKzOJOSA7KDA3S+V6aZU7tE1TEDlTnceFBZXdvrPp04K9sa/EaQvBXSRIklm2Lg8AW95xbMqGX8Qa52JOeq
 gl3sKsYm
 Ea3kWec0z5fCP7EpNKxIogoXx5KqWhh3Oigo29I7+baqVsGXHPxR16Si1pbEisJHPEhaoBbKs3DlHE/DTGsRikZsVaxnkWdFrfh9b74kvPB5slyFcYxBdH1FpRF9DsBMRBKsjQLogoVMwB6J24RmHn1/xqEmJkvgdyC1T2EmAQPSmLSf1bNVHWQdNp+enyhLKGdp9P/QU9TYmeIF0SHrElbumJEsUlOvbtETnkx8fkob3uK3dew6Y2nt/Y+O9izB9jz3n1/S+GblHk2QLFqoQ9Swj/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 6:02 AM, Vlastimil Babka (SUSE) wrote:
> On 6/16/26 21:14, JP Kobryn wrote:
>> ALLOC_HIGHATOMIC currently provides both access to MIGRATE_HIGHATOMIC free
>> pages and permission to create new highatomic pageblock reserves. This
>> makes it unsuitable for the fastpath.
>>
>> However, the fastpath can reach rmqueue_buddy() while MIGRATE_HIGHATOMIC
>> reserves have free pages available. In this situation, the allocation can
>> fall back to other migratetypes without trying those reserves first.
>>
>> Allow high-priority non-blocking allocations above order-0 and up to the
>> costly order to use existing MIGRATE_HIGHATOMIC reserves on the buddy
>> fastpath without granting permission to grow these reserves. Add
>> ALLOC_HIGHATOMIC_RESERVE for allocations that may both access
>> MIGRATE_HIGHATOMIC and grow the reserves. Change the semantics of
>> ALLOC_HIGHATOMIC so that it may only access the reserves.
>>
>> A UDP receive workload was run with free MIGRATE_HIGHATOMIC pageblocks
>> available in the target zone. Before this patch, the workload did not
>> consume these blocks. With this patch, comparable runs consumed available
>> blocks for 96-100% of eligible order-1 atomic allocations reaching the
>> buddy path, with no highatomic misses observed. The workload did not grow
>> highatomic reserves and NAPI page-frag allocations remained healthy with no
>> failures or order-0 fallbacks.
> 
> Great.
> 
>> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
> 
> LGTM, I have just one style suggestion. If you agree and apply it, feel free
> to add:
> 
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks for the quick review.

> 
> ... and (unless other reviews raise something) send v2 rebased to 7.2-rc1
> once it's released. Thanks!
> 
>> ---
>>  mm/internal.h   |  4 +++-
>>  mm/page_alloc.c | 34 +++++++++++++++++++++++++++-------
>>  2 files changed, 30 insertions(+), 8 deletions(-)
>>
[...]
> 
> And only here add both ALLOC_HIGHATOMIC and ALLOC_HIGHATOMIC_RESERVE.
> I.e. ALLOC_HIGHATOMIC_RESERVE would not be a superset of ALLOC_HIGHATOMIC,
> but access to reserves and ability to grow them would be decoupled. The
> comments on the flags actually suggest that's the case.

I like this idea and will decouple in v2.

