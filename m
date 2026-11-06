Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 835CE606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 17:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZonrmaN+
Received: by kanga.kvack.org (Postfix)
	id 9744C6B05B2; Fri,  6 Nov 2026 12:50:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925016B05B5; Fri,  6 Nov 2026 12:50:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8396C6B05B7; Fri,  6 Nov 2026 12:50:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 592EB6B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:50:18 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB34080108
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:50:17 +0000 (UTC)
X-FDA: 85405433274.30.9079824
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 37AC9100005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:50:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZonrmaN+;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793987416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BnnkrLBDIOF3ryis613NWNf1pYsRv2SOtis6XbCWIQU=;
	b=iRVawKj5yk7TG6XW9Ck6EsFYip9P2fwu/Gm4AlHGosAf/G+dv90RtpU7k8fD+Vpw/AlXYL
	qQrT3qehLHSwEp3fkwnm5InX+f4VZi4NV2NlvpsulLHAk277ZQ/0LLTiwd1kCSsxM18FMZ
	ETaF84bXeMosVm03FIZXpqfDvz2Qy1o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793987416;
	b=QIVhs8ZV0SSJZ6dx2fRMjajbAG2UVsrI6Xwru9nYibfgjO41R89PUGXROxfS6miEvFtIdZ
	eXqj0ypAMzCU7eQeI9RrLqzZL261N5S42BWkWlAyOCaERohdiBrzHp3W9jeh7YfnU265Qr
	k5MSwva5USJJrc5yjOUTt+m8duA+A1g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZonrmaN+;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6273D406C8;
	Fri,  6 Nov 2026 17:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C971F008A7;
	Fri,  6 Nov 2026 17:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793987415;
	bh=BnnkrLBDIOF3ryis613NWNf1pYsRv2SOtis6XbCWIQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZonrmaN+/FMDB1mJ0VM9VxShp8vWLeWgjOb8D1wbDx7UsgsxSm8LPV3VFU35EkNGm
	 a0rFU1BCza+W6Kbu86HFV3DXQ2tekxZc5tjAJRMud2L9DLKciKjmi2ClSXHXbLNoH3
	 HJEARahBmj5UIi7Kx9w0etD5p1u2BCi5nzH/pmkQQBrOgf7hH7ZxxjZBbjcMb55ua8
	 F2AxgAWWwYPouLSVW89+eKFT4Y7+otdcEEmOuIZYv5WtYpwxROVK+6s1l7rSVL2tFf
	 /pQwN2c3JNNCCAeN3gXsGLk4ggkpJfmKKPssx7GWWhZ63ntUx5eX2xVzLiWgPcAOqp
	 Djoq5jQn/e3lw==
Date: Fri, 6 Nov 2026 17:50:07 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Gregory Price <gourry@gourry.net>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH 2/2] mm/page_alloc: only skip kswapd nodes below their
 kswapd watermark
Message-ID: <au4SKZKfJoE0ZgAw@gremlin>
References: <20261106172620.318113-1-joshua.hahnjy@gmail.com>
 <20261106172620.318113-2-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106172620.318113-2-joshua.hahnjy@gmail.com>
X-Stat-Signature: 8rzjhb4cp8c8m1nnteztqrdqha97tmig
X-Rspamd-Queue-Id: 37AC9100005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793987416-329125
X-HE-Meta: U2FsdGVkX1/wKNZAackDIr8SRniOkZ6NJT6H2RGPK02vSJbG4wa8/nX7MFMWlFfgFcbr86jR3tOl8fhezi6ssy6hSy3zxzeUauuF0iXoadNZJAp2YK+gqfwiVaAtrWmM0fLUscmo/nuZhbK9hmRagxR69nXOoTTTpTpYlCQrQvieYCEAaF25urQkVRBdwYMM9EoF86eddBBSWTztoNJLi2RBLfORzd22PL0wonwNfoNaVc+emerD2ltEMakwJMvgLLF4P4VtA3AHR2QQmhR/xLP4Y8DaDalUw0cGqecsgOiiZbB1F+3vHw+koFztH1xzhclFLkefkzF5CHbydDUqb2eG0IXCDy57pdB5CRZIFpV85eAhdJcmhDXCy3Oo+IaazLxyOyByXUK/bW6z2kF7b/nyvz7JfS65k+UCHzVqqQ7PMCMaPk7nq2BSGJ96OYfgbre/VQhT+f+FaIaB+PqHZ7clql21VJktj+4jN83nnxAdBweMUvBm+nA2fg/k3Gl3cs6eVI91MQdQ6UcX5AY10xNqBscb76etzpA66kP4byy06hZdc8f3zTtODF7P7DeBZcKOUHEBPSmgOmVxJ5KVK3yBbgDsrf5ldM4gtN3q5GzXPkdllXBmSPlDNV4yfDmC+tDFhbIcSNkKo62TbviPl2VgVUUwAkw4YxsRwMUh/rNQ3l4Qq51Cq47muht/e4HlXYzRawCafB8UatP/mVKp/E1BRfsqayTK43pArNkATyrjvOWJ7CoTlh3i8XIdH6w9b1uX9/kVHl3cBewySNWXdYWc+99wtRwv1q0QThD0R3YGpn75ieFN8DIflAJgI02HrsxaH4mj7L+zCfvq/VHLRHERQNOfBmnyI4E0Is2uXij4npngEYlGOYQhmem4PyX1Sgk58XybgxBlC4hIrLpJueBj/wDl20ma6haW7UI+pSDX4sQqitEkQIV7d7hCSNAtI1a0IDP0xzw3ThXj0Nu
 hEdsYWMg
 XpEQYhspXoeKSkB8cyyll0dv3CCuSIHEUtamJpqi04tBqXapEr8FsGm/xBbDqJahtXb7HY8nrQIfcQBcOKEPjI2Cc3KgYV9mA89ESMIAX5PyI1J+ad1F2gHUuQo7pUTN06MoshHz9fw++2CGqKOAsu782XXvQVcjAyT3egzNfsBCENxPTfS07f0hD5Yx1ZYNawJdNgNIP/kyEv6jrBDuNgI05tJmHMtuWwp7xzU/86YuCG9tu9Z1IZa3r9y9aa/9YByYQUnYPVVfo2BQ75k4kLz6AufWw9CUOE099BjsRBJr+FQqwebyThRNoHVD4efxap7+tKVVUFxg7Hi6oJ6DGHnTNc/6n9ryd7HdKnmi7WnVcrobEP4vh5YGCCvsMqGl0BB27EM7kv8of4U33oKJzXod4Mh9smtUMjrZZKxwMYoZL3OSvmoTa18V2JigJyf6y63kIAfPMSwm+XQk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 09:26:19AM -0800, Joshua Hahn wrote:
> Commit 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to
> NUMA restrictions") makes get_page_from_freelist() skip any node whose
> kswapd is active to avoid piling on an already-pressured node that is
> constantly churning to make free space that is immediately consumed.
>
> But kswapd can also be woken up for order 9 requests with THP defrag
> set to defer. This means that a fragmented node with plenty of free
> memory will have a kswapd thread continuously spinning and preventing
> order 0 pages from allocating on the node. This causes the opposite
> problem of piling on pressure on all other nodes.
>
> This behavior was observed on some Meta production workloads running on
> 2-NUMA systems, where processes with a preference for node0 allocations
> continuously allocated order 0 pages on node1, despite node0 having
> hundreds of GB of free memory.
>
> To prevent piling pressure on any one node, only skip a node during
> page allocation if the zone also fails the watermark kswapd is
> reclaiming it up to. This is the high watermark, or the promo watermark
> if NUMA balancing memory tiering is enabled. Make sure to mask the
> reserve flags so that __GFP_HIGH / atomic requests in the slowpath
> do not get a relaxed version of the check.
>
> This preserves the existing fix to prevent piling memory on the local
> node, while also preventing memory pileups on non-local nodes when
> the local node has memory.
>
> On a 2-NUMA VM with a 60G node0 and a 20G node1, with THP enabled=always
> and defrag=defer, I ran a process that prefers allocating on node0.
> With a fragmented node0:
> - Before the patch, 66% of faults were served from node0
> - After the patch, 100% of faults were served from node0
>
> Suggested-by: Daniel Hodges <hodgesd@meta.com>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/page_alloc.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5423ff4805f84..8e8a2c8d6e6a4 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3882,14 +3882,18 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  		}
>
>  		/*
> -		 * If kswapd is already active on a node, keep looking
> -		 * for other nodes that might be idle. This can happen
> -		 * if another process has NUMA bindings and is causing
> -		 * kswapd wakeups on only some nodes. Avoid accidental
> -		 * "node_reclaim_mode"-like behavior in this case.
> +		 * If kswapd is already active on a node and the zone is below
> +		 * its kswapd watermark for this request, keep looking for other
> +		 * nodes that might be idle. This can happen if another process
> +		 * has NUMA bindings and is causing kswapd wakeups on only some
> +		 * nodes. Avoid accidental "node_reclaim_mode" behavior.
>  		 */
>  		if (skip_kswapd_nodes &&
> -		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
> +		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait) &&
> +		    !zone_watermark_fast(zone, order, kswapd_wmark_pages(zone),
> +					 ac->highest_zoneidx,
> +					 alloc_flags & ~ALLOC_RESERVES,
> +					 gfp_mask)) {

I know this code is hardly the cleanest, but you're now adding a 3rd condition
to a branch that was already complicated enough to have a massive comment and
duplicating a block of code that already dupliclated twice here.

You're also then going against the convention of

	mark = ...
	if (... !zone_watermark_fast(zone, order, mark,
					 ac->highest_zoneidx, alloc_flags,
					 gfp_mask)) {

(Obviously yours varies on alloc_flags too)

And also inlining the mark value.

Could you clean this up a little given this isn't a fix?

In general extending functionality should pay down some technical debt if
possible, it's ok to add a preceding patch in the series to do something like
that.

>  			skipped_kswapd_nodes = true;
>  			continue;
>  		}
> --
> 2.53.0-Meta
>

--
Cheers, Lorenzo

