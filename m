Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6761606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wax8ZcaD
Received: by kanga.kvack.org (Postfix)
	id A86286B0650; Tue, 27 Oct 2026 05:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5EF56B0651; Tue, 27 Oct 2026 05:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974646B0652; Tue, 27 Oct 2026 05:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EE346B0650
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:14:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2F10140692
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:14:48 +0000 (UTC)
X-FDA: 85367846256.20.BEF1ABA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5DB8B100008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:14:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wax8ZcaD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793092487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3C9BaH0xhn5HBqYI2J//q0I0p6+i5eg81V2wjnKirFM=;
	b=RKmG1vJg8j5d8t/tJa0S2WxdhyQqFs7dxE7HfBy/8BBW3UY6rk9KtikRbKA+3QsyPwzQOc
	SDdlabb9HKWCRJaW7yfC5Cu87gvm6jo5rG74B5YGMgxdh7xoJx6Au68Vk9WpTrwLhjJ9L1
	vwT0TOudibNNDZp/TNLt3jNPqnORe9c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wax8ZcaD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793092487;
	b=HCOFbYnkIFW/YgqcvVpM5zWTtvzbGhchpttMmmtDz0ywMOLDOCxOWH/K/B2K4xrn+vPZ/4
	VNGNqcq9cacDJBOuvX3dWNWoMgaG+p6m8RAgdkQLFY+KvbkNfpY9wFtHkLHG/3qrlhrxMN
	T84URYTyznfzxDc7l3Yw8Lc/6Ezgo+8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D662360052;
	Tue, 27 Oct 2026 09:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD0D1F01828;
	Tue, 27 Oct 2026 09:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793092486;
	bh=3C9BaH0xhn5HBqYI2J//q0I0p6+i5eg81V2wjnKirFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wax8ZcaD/71DiecJRehBjH5zvLNetiaOZxFQpb1WrNjXeS7UbTJCfdPzju8GkpkR5
	 dhrLX3VqNdfyJG8THsKAy7Zg1MlSK48H8IzHPn4+WXagMvTMTf23VfaYwqjmMxWF4J
	 ++aVQRfE/N3qmeQ4mWlhTnPnTLk6holKtH9fysbFY3Sq0B3fzgYVi6P9bv72BUL8as
	 jPTVF6ybNZ9tbOBT4WgNmDcRrIiEEvZtlJjuia2pyRtxp1x+2LMPFWrT8PiiQnoU70
	 T6x25iwZeTJPgQeNnZDH/2onGJTGqPiDGfF68A322uNHd7QLFq01c+VVuq5nXdSavM
	 /61haflQ2EIiA==
Date: Tue, 27 Oct 2026 09:14:30 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 38/46] mm/ksm: reset the unstable trees of all nodes
Message-ID: <auBrQQ9Lu_261z2e@gremlin>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-38-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-38-6f74bec9a5bb@kernel.org>
X-Rspamd-Queue-Id: 5DB8B100008
X-Stat-Signature: xobw6ymrhupe7wmaujh5ocmc47yohwr7
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793092487-19818
X-HE-Meta: U2FsdGVkX1+NQCnDUjwrFLPzPadlvkJT9b+fjvleEEfVM3n7Hb2P3PyDng57Bam2tQaQYFiD/jQTPg07YAvvaz2s6V9N2ZGOCg6FdV3Yo3hfyNkMHVJMCISX+Zawjawtl26inwz9Lk8hKdjLfhSZoLZ7KcRfCzzkkgFGeCKOQbrjjYnJa8ybaQEZDFDE2QHyTi1NacTD9rFFaLdFHAcoqfs9+KarAWfL6HP3lu68xBV5NT4q3tBVfG52lRkcts833vvlVApFZGi/dclD5GGXNvjmqRf3jZ69DZxT9WMUJIr5paPrZbxI4non/jTRMklIQpuU/LUtkFfpzR+8pVuS2o7abcVfRqwzie8IR3bD42dnjaE384fmS0YRKI/Gw8nTYxlGopGT9y7fXMZQN2wAIVWAPLoP1/ppWv+FhIp44WSmUgeJD+cBNAD1M/XRW8XYO7uzLA0wts4bPGbBWwMKOZp7Mz19smllAbu9PfWIlI7Me17V9wlncBNG8FOT3D1F+lDotk65uV0ihW84hGtCgb1ZeLzm3PgqYWa+SH+ncBoYuq8WZb7e5/xR+IW1wBaRVCBTKesEK7UHMftwsDjOmN8crgf4u1tPpAz7Vaj90Spl5AeWWp3lrUUd2WG+IteNkkKcJyhaoQtCIHpCZ/EVxH1xsoaxYHwvcz4ThGnzw1MzQnN9UdwqKc4aY6TDiKbtS0A3IE9A0N27mTT6q+GLIOe7m+cf2ZkvDRzODs7DPTfSDCDlGQgRPNwMCJaw1VPoTMt0xGJKcXsyAHiOQWnXgt/WjnT1JEV1yiWz0At49653frFrIg4G/tpIBIStfiZCT1klAlZZ6V4cZKCwu0j4+wxkO6pYPMt3duaUUwEXAXsm27hpKI1yAZrNkTmUsIi2lVtzUTYqYvRAl55W2spBoBhDIGEj6VfPm1k9NJFh8BIX5HH9vi1RTA7DUNTFz+uFwWvp/D7GZOMXpfCu3MU
 kF0UmUJr
 SaEdZffoOgYTtUHgBA66PMZnoRaiwOgK5+VtM9SOVq1BNRfbIzeL2orf1IJUHG1M7xgz5f7Ed6wIqiqjAva+7A0rUaSvD8eEI3G/7VehquZOCiudvht4t9ChLiBIBzKss8z8pNeibiI2H80dyaMNnF0sNFmLXP/RkjglYEDQg6DkDyFKKpcKIbgOIZ55VKY769fW5A6Jt9JaLSyvA1ysJtpxUIB5Es9s0WAfPPhRbJaYKHgRDB+KWUJJNSYHJgwixK/6LJWLkRohbFT84OEvU4U+bdUiMxzIixGFH9kThuH/K6F6R0mwMun9HJtSezA5b7tbzZHCi88boqicC6aKNX1ASF1YYexNePVT3drqD0WsidC7VyOI970+Ol1ngN9jbJU7cimDcnjf3TgVLbUMC93CbeCqkYawtMAP4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:58AM +0100, David Hildenbrand (Arm) wrote:
> Each full scan resets ksm_nr_node_ids unstable tree roots. Enabling
> merge_across_nodes resets this count to 1, even if per-node roots were
> previously allocated.
>
> So when toggling "merge_across_nodes" 0 -> 1 -> 0, a scan that starts
> while the setting is 1 and continues after switching back to 0 can
> encounter stale unstable tree roots, resulting in UAF.
>
> Only root is allowed to change "merge_across_nodes", and the documented
> sequence is: "merge_across_nodes setting can be changed only when there
> are no ksm shared pages in the system: set run 2 to unmerge pages first,
> then to 1 after changing merge_across_nodes, to remerge according to the
> new setting."
>
> Let's fix it by tracking in ksm_nr_node_ids the actual number of
> allocated tree roots.
>
> remove_all_stable_nodes() and ksm_check_stable_tree() will now scan
> more tree roots (skipping the empty ones), which is harmless.
>
> Fixes: ef53d16cded7 ("ksm: allocate roots when needed")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/ksm.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/mm/ksm.c b/mm/ksm.c
> index dbfb8f98b1892..9c51925825cbf 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -475,6 +475,7 @@ static void advisor_stop_scan(void)
>  #ifdef CONFIG_NUMA
>  /* Zeroed when merging across nodes is not allowed */
>  static unsigned int ksm_merge_across_nodes = 1;
> +/* Number of allocated stable and unstable tree roots. */
>  static int ksm_nr_node_ids = 1;
>  #else
>  #define ksm_merge_across_nodes	1U
> @@ -3636,14 +3637,13 @@ static ssize_t merge_across_nodes_store(struct kobject *kobj,
>  			else {
>  				root_stable_tree = buf;
>  				root_unstable_tree = buf + nr_node_ids;
> +				ksm_nr_node_ids = nr_node_ids;
>  				/* Stable tree is empty but not the unstable */
>  				root_unstable_tree[0] = one_unstable_tree[0];
>  			}
>  		}
> -		if (!err) {
> +		if (!err)
>  			ksm_merge_across_nodes = knob;
> -			ksm_nr_node_ids = knob ? 1 : nr_node_ids;
> -		}
>  	}
>  	mutex_unlock(&ksm_thread_mutex);
>
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

