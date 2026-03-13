Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64334107BCD0
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 18:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FD606B0088; Fri, 13 Mar 2026 14:29:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AAB66B0089; Fri, 13 Mar 2026 14:29:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ACB46B008A; Fri, 13 Mar 2026 14:29:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7774E6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:29:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DDB51B738D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 18:29:15 +0000 (UTC)
X-FDA: 84541877070.06.FDA80F4
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9D109140009
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 18:29:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gOjsee/7";
	spf=pass (imf26.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773426553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pv/nqWXHkfj7NbNE0aFGYmPjuMP96PKFI4ITkk92xic=;
	b=q3s5hgUcKZgO9UHMYzlktPyCGLunCTctlIMkzRSqmpy11DNysl1tdrxnu4dU9Hr2IBbXUg
	/8387qWZje4o7Zxho8LQVJ9i6pfx7oLJJOCyMhKeWAwCC6GrvJvz9utHrYYi5HMSlNhhYd
	eWe/5plBfWEKJG3pr0AYT2prgj62wlI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773426553; a=rsa-sha256;
	cv=none;
	b=nV4a1aTJUWO/bsz+IxMw348aKc1mO0nLOs1LRGgzgDR33kvjySr3T5Gpk539WHCgbOmgTR
	VZIpndsbHoVccthyOzyFd/lYqeqpEKX51bLtChss0J6hr0fRvlr72MEmBFTDFcGRCrNbEm
	az2a2SFISKR3lCuXUlR9ErPhrOuOpsQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gOjsee/7";
	spf=pass (imf26.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <cdc56556-2f69-46b7-8a7c-0f144a36004c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773426547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pv/nqWXHkfj7NbNE0aFGYmPjuMP96PKFI4ITkk92xic=;
	b=gOjsee/7ePXLg2aXVQRCN98jWrWOJGc7S6Od5X5MCK2XmZiOGkbnjW7aiGdNYAKZEniFby
	yIlBZdhFvB+0R6tKrR+2QHRw41SgEFGPECC6cQR00lVPRhhcghOc3/uCGAMO4OCyycW0lq
	ZTmH8SsM0A6v+7eY3IHoq5fzhd3ix7E=
Date: Fri, 13 Mar 2026 11:28:52 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
To: "Huang, Ying" <ying.huang@linux.alibaba.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com,
 apopple@nvidia.com, axelrasmussen@google.com, byungchul@sk.com,
 cgroups@vger.kernel.org, david@kernel.org, eperezma@redhat.com,
 gourry@gourry.net, jasowang@redhat.com, hannes@cmpxchg.org,
 joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, mst@redhat.com, rppt@kernel.org,
 muchun.song@linux.dev, zhengqi.arch@bytedance.com, rakie.kim@sk.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
 virtualization@lists.linux.dev, weixugc@google.com,
 xuanzhuo@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
 <3a42463b-9ddd-4d64-b64c-6c2e6e4fc75d@kernel.org>
 <343bbd5b-67a0-46c4-8ec4-69158bf26b3f@linux.dev>
 <874imkpba1.fsf@DESKTOP-5N7EMDA>
 <cd3d7e2c-79fa-4c00-89ad-83beddf98bae@linux.dev>
 <60f71f4c-71d9-4751-8c6b-10179b98bef0@kernel.org>
 <87zf4cnkip.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <87zf4cnkip.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: m98bybypi9mxnxt1zfqsi9wm6d71r67q
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D109140009
X-Rspamd-Server: rspam12
X-HE-Tag: 1773426552-343710
X-HE-Meta: U2FsdGVkX18Sl6o+ZUfyifORkJm/gnmq248Kz+1IBBkulPNV1WszKcz7yEUAktVS2t+hFoZtsS9W/mKIO5liM64y0xHkQH/4Ynu4EXBFdgTtEhk8ZOZAUhSTQOF1CJq+ZE2rXuEpBUastTow84v9wMNvRMRcE18Ku64mdGRSQt3LYBPZjx83dOmM6WlYY9vASKyMaylGGgp6xY2Q7xexXpnawTkpYVfuuh6puQG7+LnYrdriBKyLyKNZNxhbjdFGUS/3P9amYxYIEwEezNNWg5U4h1tRkgyqGEMmOcH9BSpJcafQjP59bmN4hjUolvouSUYRf9hKhlsFx8VG2n77uusR0CedrF6xwXzc+YHOyIoHEnkme6KaId5Hj6OMuNohSCqbQxEbM5mtBaqCmstqCUvs6uFIzTOy82ejb/gWQrfx7ZFSOL3/sWpavR0VuZ2kl2Rt1EWNO8WPfDOOxX0VsjuaygIHdjPwnOmDt0C8LTliURdL4Nw/NQv0vHSPmlHDx3TSiXat0m5s5JEim/i+4b8oR2pmJuFtqfrdo3DB6kbFMQOsWiYlpvhrEbceKQuoxH+bKbEgBxSByl73uhDdTWiZ7WKfqqtwNcxeZt3D7+TY8uc8WgufQLQViry4xl9ZcL0e1tStN9BpLZeGM3jtiN72lVTXANC6d0oAZMR20sMhQZ1HN5J1Wun2Kdhb8x1AWqJe2ya4GEnC+CoVjdPJ3PgBL9rmvj2Ho2u5Y5KidOO8Xms7ygP9+IGZEZrHvfJShMXGA+i+s0e7AC75Z4fK1BJBuWDK34iyJokmH04GCGV3+xZTgh4XydObeb+/3Qxv42X4rzfYMmp63H1lpK/NRPSr4r4FCqajoiTiC35M7/UZi8t0tGh5ELq3a4YdCMjY2VHOcC2vhcYlcMH4aXFufYbBqh1dijerE8mAmzgWrxJmxf86KtoIkWdHhFrtCfrjV77YNan6/FzhxZaUKK6
 HiBQUylq
 VgJvhOuTIfKq9LMqrYjcyvpbJeroH8Xjpbbu0RGck7Eta+jP3CM+ZhogZzyrmvKOekxn5p5q/vh03i9ldZ3D37hnpcswnjOc6fBMLiPGZd/+SU/naCQtRymCnwnqnpGZHbIJsuHbYclgdw/dQXbdvN4rWmj58zltgOZQtx7iRBypxCscNU39tV4tKQPphYNuvqyB3I4p1ChedA1CzXcQvuunq1kSSmQipQSY5nowupB9akb0bFGUFTsOJLcDTYZYGoziZM9G+iJGcSGU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/13/26 2:31 AM, Huang, Ying wrote:
> "Vlastimil Babka (SUSE)" <vbabka@kernel.org> writes:
> 
>> On 3/13/26 07:14, JP Kobryn (Meta) wrote:
>>> On 3/12/26 10:07 PM, Huang, Ying wrote:
>>>> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
>>>>
>>>>> On 3/12/26 6:40 AM, Vlastimil Babka (SUSE) wrote:
>>>>>
>>>>> How about I change from per-policy hit/miss/foreign triplets to a single
>>>>> aggregated policy triplet (i.e. just 3 new counters which account for
>>>>> all policies)? They would follow the same hit/miss/foreign semantics
>>>>> already proposed (visible in quoted text above). This would still
>>>>> provide the otherwise missing signal of whether policy-driven
>>>>> allocations to a node are intentional or fallback.
>>>>>
>>>>> Note that I am also planning on moving the stats off of the memcg so the
>>>>> 3 new counters will be global per-node in response to similar feedback.
>>>>
>>>> Emm, what's the difference between these newly added counters and the
>>>> existing numa_hit/miss/foreign counters?
>>>
>>> The existing counters don't account for node masks in the policies that
>>> make use of them. An allocation can land on a node in the mask and still
>>> be considered a miss because it wasn't the preferred node.
>>
>> That sounds like we could just a new counter e.g. numa_hit_preferred and
>> adjust definitions accordingly? Or some other variant that fills the gap?
> 
> Or can we adjust the semantics of numa_hit/miss/foreign to consider the
> preferred nodemask instead of the preferred node?  Is there some
> programs to depends on the current behavior?

Good question. I think it comes down to whether the existing semantics
are correct with respect to policies that make use of node masks. I gave
some thoughts on this in the previous reply to Vlastimil. That
correctness may be outside of the scope of this patch, but I can give
that a try afterward. I'd like to send a revision that reduces the new
counters to just 3 and moves them off of the memcg (as previously
mentioned in thread).

I know numastat is one consumer of the existing stats. It seems up to
the user on the interpretation of the data. Not sure about others.

