Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C592CCCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 05:38:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE55C6B012B; Mon, 19 Oct 2026 01:38:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8E786B012C; Mon, 19 Oct 2026 01:38:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7CCF6B012D; Mon, 19 Oct 2026 01:38:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8230B6B012B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:38:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F216C05F8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:38:26 +0000 (UTC)
X-FDA: 85338270612.23.90DA276
Received: from mta1.migadu.com (out-60.mta1.migadu.com [95.215.58.60])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0ACCEC0002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:38:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o0+2Mzj6;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.60 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792388304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fj1QnA8Wbfs9pmSonhebSKG5k1h01DAB044UZgasZmM=;
	b=VhdWnfJ72fxRpGjIlkB9pn+GAMexl6K+qxZc4AktR2tkY9HzRkovAV7bdDOLM8z2tBb7jt
	zwcRX4rCitRR2QRZwFiJISlESici1pL0bQ/A5t6WiFOI+Ucw9go383tE/NishX4BM5MEmo
	HLh1cAcfGb95eDyFxeYd3EWWVhefnao=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792388304;
	b=fdC92kKurUxgG9vGXlGlm+3KEHtZIkvtiRnOxHBExMeF6r8O9+YB7ht9AloMSdwrl8RJEi
	k18WwnBhOni1eEP99toESQvZMWtNraB9xOlP05GOdAnzVIXEadXsveN4yvX8zFX9kCx35O
	AWMnUS6Us3YszwU6jxiCEvt/FUYiHW4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o0+2Mzj6;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.60 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5E31hXFLn3ZF06DDXoSyDVQz+JRrW2LFsdTv2H+nT0Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792388302; v=1; x=1792993102;
 b=o0+2Mzj6jR0sh8s3vW7/WMOS+4ddEI1CG0esQegFfd+dTIU9fhM3WSi7/9cmzQVXxfTfcmKl
 7K7iK3fwddNVUUr0q+3wWfH22v2i1e2dXjZdHKqfqKRC2dO1N4/MY/lyXCIxQSTM3LyQO6zSqeP
 UQaJWfiLfOZ6Jb4E0dLGY8C4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a20ba9f3511e7662;
	Mon, 19 Oct 2026 05:38:22 +0000
X-Mizu-Trace-ID: a20ba9f3511e7662
X-Migadu-Flow: FLOW_OUT
Message-ID: <19d5b7cc-782f-44b1-8ec9-a1764484f10f@linux.dev>
Date: Mon, 19 Oct 2026 13:38:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: unqueue deferred split folios outside the lruvec
 lock
Content-Language: en-US
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20261017004555.2890038-1-joannelkoong@gmail.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20261017004555.2890038-1-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0ACCEC0002
X-Rspamd-Server: rspam08
X-Stat-Signature: nwz6esoee57utz7hhh4mh7mtpge6rtzm
X-HE-Tag: 1792388303-19428
X-HE-Meta: U2FsdGVkX19XhkoRVGlEz4HaX/hONg9NFTScdmsvvYXA6oSVsaRV499LIcT4hcbZ4ljkeTPUXQykZ+ndExBFra1rSY+goSF1VD/aTnJPq4f10J38fvX0nlTiQ4JzV7JQ5U/Xpkdyuifp94uvF5xTKC1DA18eoSEoREYpAPi9LKIqLMaraWo/UBQvzCLg/xtbrB6Lqr0hyytTv+9trpCYfMhqPLKwEb74+WAwmOpJFZIZfOzSXoQyXyyrgbO57jfjwv8wpmPvWOxFGlMmvSXv9h1Y5f/LZPMc3cRq4Jj1kSvGG+EYJOeqoM95DydCXjMTMFmB2nPSkHxBsvJCYIJbPmvkyUNApb9H6NG1E4l3ZdFltOtgjz9HsISA1D4lxl3DvBrBVpPsi966byMlxzr5JAfKvzw0enoOZD/M40cCLv4pWB9PjO6lK7TJJ1VH0FaLfPvcSwUc7s9/JvwOsMVnlbzGyo1t5O2XC+7/aBKiv7qlpHX7qukl9RKRFRHSLs5nvF/ncjciHIHuqlz/lC6eWKUIblyR/ySJ0uTqmqaBTlQ7KLdw8fhCc7pwmrFRxmQbVnsEI8+p29x0PIjLDfnANRjrMJ7DmOJHTthJQ70o8IeHHq+KU3afgQaLhzDLz2D32Zg2XR1xRO/8+Xv2fuYCiFNFIoXjAZo6J73piA+/l135FXshyxusPZOLovn7gT6a/PK3zCTmA0Bgftfz7IZkzNhPuP+Y5VCza63k+g/jkYq3Zw4RwnJCOg6n3YcbMQ/vQk2OlmJNr9Qo0dEomYJLgFR1ufcSKc4GXcMkGSrhStInoPy4BKy+xFgHxyJpLqg/1pRs/UeX4l8RF+QjVkeOIv69ZGvmfO12kE8rGTwWlreTnBpU+WmDiI6UW+Bvzxl1lKB71Kvu3LnM6rKO/X8fjnkNzK5sWiVvBN1fuP0EBKAOTt5KM2goU13ZF4uvExuS+STa51WafqdWKfZfGiv
 M3UYaYAJ
 FE1WC4KDr39gA+ZR8v9SK4cuuS9I11cbyN2rHfvQc3YXs6RWvl2Q68QQwE377vHZ/NUotnTQ2iqU39WXWDp9tsiZCYH5ZrzGLUzBGnmlGw7deKd171w7ZweZpJfQuQADycgTubcnZQZijWeDJaxnDx1Wr6ZhT6H3yHLeybI5t8dpu4kZg7MuzbPjlE9pNiL1hcZQ+aHqsD7fEvTu6K0Pkh8he+yWqDkeupHhszABXvtE5nQT/cCTk4Hwy+F/xH/QNhgA1KhceVZeTW537M2EV/oDjXc57pQcD8uUHu82/V2p4Aw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/17 08:45, Joanne Koong wrote:
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
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
> This patch came out of a discussion about splitting underused mTHP folios [1],
> where queueing small mTHP folios on the deferred split list was found to
> regress Barry's fault microbenchmark. The cost turned out to be the unqueue
> running under the lruvec lock rather than contention on the deferred split
> queue itself. Testing this patch on top of the series in [1] with the same
> microbenchmark, queueing every 16k folio went from a 15% runtime cost to
> noise, with lruvec lock wait dropping from 491 seconds to 38 seconds (most of
> that contention then moves to the deferred split list_lru lock, but runtime
> still drops back to the unqueued baseline).

Looks great :) Could you also keep the benchmark results above the '---'?
They'd be useful to have in the changelog, along with the test setup.

With that, LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

