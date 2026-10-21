Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22929606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 03:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KAqpMnqf
Received: by kanga.kvack.org (Postfix)
	id 3D8966B019A; Tue, 20 Oct 2026 23:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386A06B05E9; Tue, 20 Oct 2026 23:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2766D6B05EA; Tue, 20 Oct 2026 23:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 024776B019A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:37:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0345FA7F81
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 03:37:33 +0000 (UTC)
X-FDA: 85345223628.07.F5B8C8E
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf14.hostedemail.com (Postfix) with ESMTP id A63AF100003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 03:37:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KAqpMnqf;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792553851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JlRmug8M8jL+izLY5CnmCZpoNqlaHo91H3D4D0KORIQ=;
	b=KmZmRXd1E16rF70xbGyfxsamZD9U729VEyBv8PbpvVrsRxoffBSjqIZnuChs4fXB9HRGJb
	NfL55E4n6w9JYLZzN4WudSEwOlAiLhr+qwJJuCbz7VwCdmNuiQC0xgMuPRFiU7/rh3hW5n
	Fhn4priw35gmTfW5Z6UtqfBe/l11glA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KAqpMnqf;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792553851;
	b=MefgXCueG/cXTkxAZ7K7d+eT4ej/25Ax58KdPS0LAP7o8cR5bnBYGBML2ustg6+EvqpEKs
	tC98XheVSatIBI9k+hnaMaBltKbBdIKGj7IiGhho5FR/bXzxl41V4xT2agb3zXOHgjSz6L
	ddKh2qessRJ1uRkqlqaMt+zi0FvbC+s=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792553848; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=JlRmug8M8jL+izLY5CnmCZpoNqlaHo91H3D4D0KORIQ=;
	b=KAqpMnqftsq9Vh76BCQw5o/ftHsSv60bCJPdslWGu5RbzsaqKScMrnR2n8nft6vT2AHW2nwTLRUtlgcEc07XyQa18mWlUC2MFI08zk+h4kPpHbIhVo0ZsQBJAeWF3+mOseyBA0plsS3vTKcTwPtoTfrwaqHODfAfSN9Xc9l0qmQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XDFBTxn_1792553844;
Received: from 30.74.144.135(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDFBTxn_1792553844 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 21 Oct 2026 11:37:25 +0800
Message-ID: <0d0e6e7a-eb2f-4435-9be8-0c82d39b4cb1@linux.alibaba.com>
Date: Wed, 21 Oct 2026 11:37:24 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: unqueue deferred split folios outside the lruvec
 lock
To: Joanne Koong <joannelkoong@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>
References: <20261019230646.3510790-1-joannelkoong@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261019230646.3510790-1-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A63AF100003
X-Rspam-User: 
X-Stat-Signature: o7jsb41r7ihbhwp69berss84ectp3t4p
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792553850-673253
X-HE-Meta: U2FsdGVkX1/WTC5p90MYW6/NgJV3uGaREj8N0IKTto3ClbiKUEAfG0SGMsJyUprntzDxF2j0t9oFhrelyKEpZ9S91I/ncoZ2UswtfW6yX+omLuahcbWluBPWtHQmPvvKmRpdrN2+CAIp2T6mJczt/wxpyWsiafent1z1jkicSM5NOuhXCeSNS6aajeXyTZ9G0n0HkZ1QPQNXWq7UtBnMgtmrXLDYv33Gaq/vK3MgdSgtXcjQnNWzLQwVHgiyrNH83DcoXtcHy85VXRXu8n+vCMV/Yvnq6JeHHrQD63ktDiqDkgARBMi+GmbeL7cTsNBCyomzkbO5xNJkrVAu2ifaZjb7HnEhSYua0V778+OJbctdS+CLkzGW5XyPuWv+1c5F4l7/up9OiaIvduskn/hj9HHk349+YU3gQGukBLQtosNkEaoHizoZ7+14qlffEjh6acm524QEW7INa0zgib6f/oIW4HRjZptmKyii1XDelgoCZiPewM77STwOYaE/+OePwRyFxyrdoku6zppdzZCKSku9nqpHjEQu7LJQwXsQBEoHu/EPVqJxGY4T8h8XHc7hPrljzjWs75kzcKObfHOftHHzihxRc2vKUcMgSBPr8eY1yuSqs4KVUjsFkPQnmuqYcwW2kf5S1yG4MdA+4oddIrh6y0+bkmL32ccHT2Z346l85UWOgca6lL2hrv40er5P1rBqoONUMqgpxo9QenC5D+04F3WLlLf/RS9UxOU4BT8mGjYI/h8Ss0bpuCh9fXRHOajkLly8x6v/pMxj7BvcbqE42a4mlSBbQr7GPYgDYxWsR0eHwuqBPoWH3NlJXBjbReRE+BDbphU4JIr1aloBMxPOMK17yay9LbHnFGDWyZ69iLOQPs7cQRu8wzF92kyEY4uahcNTIhRy5rvmAtuEjobEgrpF7Qn05BahdhE2duuCcYV0C/oBk3p++oFlTY6gkEn3iCRMM9M/lL7D+T6
 USuYTSDr
 xVK07A8FzlZF2ZeaUdtRC2ldz1RnK/nSZ7sPG6hyjGaRlLVnNI3YTJmXC/bBzNm14ijd4hkBfdYOM5SzB74Fh+TNVLHE1+wWViYdefkEaU1AQjUXkovEUlMjL37deA4Any7eyzf3nCaG3epgoA7gGunUT8ypGuFj10sESryx+Hg2VIHgQUz6fpz5UVljZXJLg1TmFDL8vy7VxpH1srNvz/kzjfYEBcAlXrmbM50kR+d3QBjb2bR0Atzf2cMZLytl6SQwQrLOvY5+t6eQchn+2srUFZL28fo0qS2purt1wdwHFKuQrB1wI8x/PzEs0xe81b4cE+blFfSI7QHjjLwG6jJUFkWZiQDe8p1mP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/20/26 7:06 AM, Joanne Koong wrote:
> move_folios_to_lru(), folio_batch_move_lru() and folios_put_refs() call
> folio_unqueue_deferred_split() on folios where the refcount has dropped
> to zero. In these paths, folio_unqueue_deferred_split() is called with
> the lruvec lock often held (move_folios_to_lru() always holds it and
> folio_batch_move_lru()/folios_put_refs() usually hold it for every folio
> in the batch except the first). However, it's not needed to hold the
> lruvec lock.
> 
> The lruvec lock protects folio->lru and the reclaim LRU lists whereas
> the deferred split queue lives on folio->_deferred_list in
> deferred_split_lru. The deferred_split_lru is a list_lru with its own
> per-memcg per-node lock.
> 
> There are already other existing callers that call
> folio_unqueue_deferred_split() without holding the lruvec lock (eg
> __folio_put(), shrink_folio_list(), __folio_migrate_mapping(), ...).
> 
> Add folio_batch_unqueue_deferred_split() and use it in
> move_folios_to_lru(), folio_batch_move_lru(), and folios_put_refs() to
> unqueue each batch of zero-refcount folios from the deferred split list
> after the lruvec lock is released and before
> mem_cgroup_uncharge_folios(). This helps shorten the lruvec lock's
> critical sections, which run with IRQs disabled and are highly
> contended.
> 
> This came out of the discussion on v2 of the mTHP shrinker series [1],
> where queueing small mTHP folios on the deferred split queue was found
> to regress Barry's fault microbenchmark. With [1] applied and
> khugepaged/max_ptes_none=0 so that every folio is queued, perf lock
> contention showed that the extra cost came from waiting on the lruvec
> lock in the free path.
> 
> Test setup: 2-socket Intel Skylake, 40 cores / 80 threads, memory bound
> to node 0 so that all threads contend on one lruvec, with each of 80
> threads faulting in and unmapping 16 MB of anonymous memory 200 times.
> With only 16K mTHP enabled, this patch reduces the queueing cost from
> 15% runtime to noise, and lruvec lock wait time (summed across threads)
> drops from 491 seconds to 38 seconds. Most of the remaining contention
> moves to the deferred split list_lru lock, but runtime still drops back
> to the unqueued baseline. This test uses a worst-case configuration ([1]
> is expected to only queue folios of 2M and larger).
> 
> [1] https://lore.kernel.org/linux-mm/CAJnrk1a2PpUGTsCgS7jct2KET4K2zAL+_h+te8G1MaU9bXs99w@mail.gmail.com/
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

