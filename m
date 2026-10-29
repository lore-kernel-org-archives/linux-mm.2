Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB887606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 18:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f1Y6buIo
Received: by kanga.kvack.org (Postfix)
	id EED7B6B062C; Thu, 29 Oct 2026 14:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9EA16B062E; Thu, 29 Oct 2026 14:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8DCB6B062F; Thu, 29 Oct 2026 14:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC1A16B062C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:08:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38EB31604E3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:08:10 +0000 (UTC)
X-FDA: 85376447940.24.C97EECB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 711B940002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:08:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f1Y6buIo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793297288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dzqh+wdXVDD6rZ18+/BTNNGOJs3aTGYsg31/1TNDADw=;
	b=5v4VYYk+IX6cmdi2FCOBWh2ls3WBoOvGtERWf5Cw6ksHUwcG+D7veE9DKALlUbWM21Rsh7
	ECfR3AyiC29n9FfX2i8puEGGy5QEvbgw7o4Gc8b9bZJ8lnCnw6b/x9wSJuW00HFZnITHZh
	vMQ9HTWHNtkOrnBRUHqYRCfMrxnknmY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f1Y6buIo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793297288;
	b=iNbYkfDrV84E1Suj9FzYXmYNDd93UjI3WWu/UVKa7gtGK0DizfDrKY1XbBHuQoSpoRc/Kx
	EryceW69WAdqUx0clJr0ZiYzPpAL8NaJBJsyjQcVEQW4yVI/qikI3BDktrVdaHVR9EYKWO
	xtOO2/n6Pp036sDpqTijdig52VQuayA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B52E600E4;
	Thu, 29 Oct 2026 18:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EF91F01816;
	Thu, 29 Oct 2026 18:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793297287;
	bh=Dzqh+wdXVDD6rZ18+/BTNNGOJs3aTGYsg31/1TNDADw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=f1Y6buIomjd8NiYiwC6+L/N/2gFzxBK/PTis/OryQtGQXon5fydlVHG395evTsZmx
	 N4jboM2OkA3ya5OrYrllwnpe+kG+jOmUDYRXK+DGcBEX2/nOkOV31x/bMvQpJnopvG
	 7Z2lG945Ov3nX576VROmqMDKZlqUQsOyo/B/ZYq9LrxDRAW/aKhZxuW9lFRx9c45px
	 Jwf5vHxk0COCrcMoKMqnZT6qZ/tzhUODUrW0/2m7r3BcT5voMK8LY5N4HrDYwvdg71
	 kjfdi6qj4h8ApblSoT1kLHdK8Ti//IC5Ulk/kEtn5KhYMcS0OaoA3PtDBj0a38iVEH
	 buw6b2not2y5Q==
Message-ID: <fe658b1b-4011-4197-b228-fd4bb6c412bc@kernel.org>
Date: Thu, 29 Oct 2026 19:08:01 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/8] mm/hugetlb: retry the pool walk when the zonelist
 is rebuilt
Content-Language: en-US
To: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 akpm@linux-foundation.org, ziy@nvidia.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, ljs@kernel.org,
 liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, mgorman@techsingularity.net,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20261028211930.3504634-1-gourry@gourry.net>
 <20261028211930.3504634-7-gourry@gourry.net>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261028211930.3504634-7-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 711B940002
X-Rspam-User: 
X-Stat-Signature: eksqazombtg6wd5o94xu879ysxf4j56a
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793297288-589451
X-HE-Meta: U2FsdGVkX19DVsPYQ3Iy+vVIslf34p0wKqM2QPcEHFxFkG9DbJOV/xezaH3FcJpB4n8qevkhSJVoTuc5RWXAxc+TP9cq+Ez+hkpMFXHZT7RJR2nkc/dR6VhA4L8rMr182xOswF2zfPVCleRXtoF/Lhr+FjcX9FJxZVkXn7Pt83D/HtbTw1pNZ+dvTFuY5i9dICXJTgEkX4iHtxws/IKwvLalw7nFwjuRqLta3DZ6qn6LyF54qD7dYh7CeLaR553SK4X72KCtxH5sEXPbWv9Ze9bfrBcqntAlSOpm/sXqw7bKb8a35EzqmCr2pXveE6yoMk4gRMXZwaOumWMv3e29T/Ud/rIx+Z6ymlZ+c+IpYBFmhixzZw2VCBNE5YMPeHsBjdDUFR9IJzcyGDD31YF+FqwQ+XI8wLhp4qQJ20HCmsT/aU/F9nNJSONYIohob9wXu2VstcBllZESyU1tfMUysnyFZXPC6t9dYZn401DuIcPPVodoapAk9tPgw/DjcKGtrGDH499h70SocqjxbWx+OnSHYCWNp2PmV+GvBOy7oM1kLjCoXB3H8xAvXzMk9wbqKeS91mlKLcSxT0D0FNIwd545voOFjlTj7bmsNZkvozlhJvdrlslUz/5mqSPldftbxVlbfkvaRQ5CVIoT0Tf3FnVmUaTolxzVRnDAT+9iG/Qe7UBRyHFMFLWBUtWAh6LMbkrY9HIZ6Br0g1CNzYMw/nCNn9BE7SS2x+tIr4OtU0jjLxN61mKSdnKuEpdaxkavp8G0d7UTchirNaRfJju9f4V6tfm8GJCIf3+FWxx1tfNZ1z6e1dG86BaFulm9+B7LV298vJDZsFxza0z+h2T48/zkA0B2/dL1YCUjBLUzW7KrUplK88M/v5xwWND3pC4MxJeHcfMY+dH1khxx2RFj1yB9rn9bHmVIE/80X8V1zk72sZ2vao6PXDX9xd68UmAP+xBj+8U2Hx+YuSifUZF
 jHCgq70g
 39CGx9N0X8c7qKxTKegem7RVsrFRanNPJ6db1HyBmSLAViLuhau429jZhERc7d1uDcV8htr4jziJtiGCyQ88xOhxP7EfEM+rQKmKMr1sPD69bH4QQhWFZcryWfXQWw1M3v2PtpTgVLrn+cS/zRvqUfjernEcIFmFlD6FqOBUdX2yHrynYpK1eI4DXK4sZPvz0az8Y8jaYU1sQhEnrPE6W52JxSp5Bn2GH0gPUqVbGkvzu8kJhzTeoRB0Z/JKSbH5fljZwhV+0G4365rXxzbvrzXH08AjxZ/Vg+LS1vr/UnjoSsprtyN9I2UQ2xM+Bw17YmBF+mDzmRXOdCXXAsKjDSd5tnlAEjzZIA+nCQn4WkK/seIgPqJ+imHAIFyDiZq361uf0fFCaGVF+QCXn/xlKvXStGU/b6mPnzJ27
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 22:19, Gregory Price (Meta) wrote:
> Onlining the first block of a zone rebuilds every zonelist in place,
> shifting the slots after the new zone.  dequeue_hugetlb_folio_nodemask()
> approves a slot by its node, then loads the zone from it, so a hugetlb
> fault bound to one node can take a pool page from another:
> 
>   CPU 0                             CPU 1
>   dequeue_hugetlb_folio_nodemask(nodemask {2})
>     slot 3 (NORMAL2) approved
>                                     online_pages()
>                                       build_all_zonelists()
>                                         [.., NORMAL1, NORMAL2]
>                                         -> [.., MOVABLE1, NORMAL1, ...]
>     zone = zonelist_zone(slot 3)    /* NORMAL1 */
>     dequeue_hugetlb_folio_node_exact(h, 1)
> 
> Check zonelist_update_seq before using each zone, and on the way out
> with nothing found, and restart the walk if it changed.  Checking before
> the dequeue leaves nothing to put back.  Reset the last-tried node on
> restart, so it is not skipped.
> 
> With kprobes holding the walk across the online, a fault bound to node 2
> took a node 1 page in 3 of 3 runs, and a node 2 page in 3 of 3 with this
> change.
> 
> Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

LGTM, but...

> ---
>  mm/hugetlb.c    | 13 ++++++++++---
>  mm/page_alloc.c |  4 ++--
>  mm/page_alloc.h |  3 +++
>  3 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index b37d7d0db7fc..8edf323baf0f 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1293,11 +1293,11 @@ static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
>  static struct folio *dequeue_hugetlb_folio_nodemask(struct hstate *h, gfp_t gfp_mask,
>  							int nid, nodemask_t *nmask)
>  {
> -	unsigned int cpuset_mems_cookie;
> +	unsigned int cpuset_mems_cookie, zonelist_cookie;
>  	struct zonelist *zonelist;
>  	struct zone *zone;
>  	struct zoneref *z;
> -	int node = NUMA_NO_NODE;
> +	int node;
>  
>  	/* 'nid' should not be NUMA_NO_NODE. Try to catch any misuse of it and rectifiy. */
>  	if (nid == NUMA_NO_NODE)
> @@ -1306,10 +1306,16 @@ static struct folio *dequeue_hugetlb_folio_nodemask(struct hstate *h, gfp_t gfp_
>  	zonelist = node_zonelist(nid, gfp_mask);
>  
>  retry_cpuset:
> +	node = NUMA_NO_NODE;
>  	cpuset_mems_cookie = read_mems_allowed_begin();
> +	zonelist_cookie = zonelist_iter_begin();
>  	for_each_zone_zonelist_nodemask(zone, z, zonelist, gfp_zone(gfp_mask), nmask) {
>  		struct folio *folio;
>  
> +		/* A rebuild may have shifted a node outside @nmask into this slot. */
> +		if (unlikely(check_retry_zonelist(zonelist_cookie)))
> +			goto retry_cpuset;
> +
>  		if (!cpuset_zone_allowed(zone, gfp_mask))
>  			continue;
>  		/*
> @@ -1324,7 +1330,8 @@ static struct folio *dequeue_hugetlb_folio_nodemask(struct hstate *h, gfp_t gfp_
>  		if (folio)
>  			return folio;
>  	}
> -	if (unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
> +	if (unlikely(read_mems_allowed_retry(cpuset_mems_cookie) ||
> +		     check_retry_zonelist(zonelist_cookie)))
>  		goto retry_cpuset;
>  
>  	return NULL;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 33aab9deaaa1..70830689048a 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4411,7 +4411,7 @@ EXPORT_SYMBOL_GPL(fs_reclaim_release);
>   */
>  static DEFINE_SEQLOCK(zonelist_update_seq);
>  
> -static unsigned int zonelist_iter_begin(void)
> +unsigned int zonelist_iter_begin(void)
>  {
>  	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
>  		return read_seqbegin(&zonelist_update_seq);
> @@ -4432,7 +4432,7 @@ static unsigned int zonelist_iter_sample(void)
>  	return 0;
>  }
>  
> -static unsigned int check_retry_zonelist(unsigned int seq)
> +unsigned int check_retry_zonelist(unsigned int seq)
>  {
>  	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
>  		return read_seqretry(&zonelist_update_seq, seq);
> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index 2b1017a91928..53df6b8a0c00 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -265,6 +265,9 @@ extern void zone_pcp_disable(struct zone *zone);
>  extern void zone_pcp_enable(struct zone *zone);
>  extern void zone_pcp_init(struct zone *zone);
>  
> +unsigned int zonelist_iter_begin(void);
> +unsigned int check_retry_zonelist(unsigned int seq);

... is it possible to inline these here instead?

> +
>  enum fallback_result {
>  	/* Found suitable migratetype, *mt_out is valid. */
>  	FALLBACK_FOUND,


