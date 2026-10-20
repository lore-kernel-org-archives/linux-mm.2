Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6357606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 07:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V1CouIPD
Received: by kanga.kvack.org (Postfix)
	id 15E9E6B012C; Tue, 20 Oct 2026 03:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1091C6B041C; Tue, 20 Oct 2026 03:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F306B041E; Tue, 20 Oct 2026 03:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D3C576B012C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:21:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6346CA0933
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:21:26 +0000 (UTC)
X-FDA: 85342158972.26.64C4B05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B153F1A0007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:21:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V1CouIPD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792480884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78ho8sxyOUaxztm7HsYhydMdI29Az8Akld6js9MO2yc=;
	b=vVPEEJKgQoVWDUgqAxuz9E5B5OroFMK0WkcKCpz/kSxITbJteMK7mEnA2LMPW+zQC8Egub
	4GKHRvVh8e2u50IjcA6OAteJUN1zjzXg6TDOzUhe2Y//pU4SP50BUw8wXHR0fjgtSMaW1r
	vwO18+js4y4A+FKH+Zt1T23LIZby5Ho=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V1CouIPD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792480884;
	b=HiFs4gSuKrFIgTn+nfF8+pCTV0wOwn2rDmjjDCBg78zExKbAgeCDJMRyjdumtfsPj4cd0R
	Wq57GK6CvEc+iKHiuGAfDZeYtyc4VDHItClOwXAVuWs1gelofCYAWxLxo0rq+0Jqn/ALZW
	R8o5jtXovHm+R9wjv//1enmG8ayr1Lw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A93660DCA;
	Tue, 20 Oct 2026 07:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3996F1F000C5;
	Tue, 20 Oct 2026 07:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792480883;
	bh=78ho8sxyOUaxztm7HsYhydMdI29Az8Akld6js9MO2yc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V1CouIPD1awmOYL+8dafrrc0ZGcALseByYGhEf8nTxVKjeFNTjjxeCp7KKlzjFjEk
	 ir9GSrQVjfc0F+MLVK4jjOnjjiS/AFmJz3fw9v6XS/yuamlG//eJ2kynfrqw16aa0M
	 pbTLmzObydHP2DyvMAXa+5WyUnOPzomurWi06ilBoCvn6mcyn7tBaIWjUZrVHKVMU4
	 ChZOzYrplYc5L9pqwHt0DF+QLcRomY8++DxqGozZdd0CcU19/1qAdCAYYoon/9iTH2
	 5Zjvd05mTDJFuoAJBYnh9mwVyO+fXamJ4kPTzh3MI2DGbxSslZoxzk0JX1uYl6aCPh
	 ywnV3+02y6w/g==
Message-ID: <18392c52-a635-4d7e-856d-6203c4967483@kernel.org>
Date: Tue, 20 Oct 2026 09:21:19 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: let the highest memory node recover from
 hopeless state
Content-Language: en-US
To: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com,
 flyinrm@gmail.com, stable@vger.kernel.org
References: <20261019184850.3427905-1-gourry@gourry.net>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261019184850.3427905-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B153F1A0007
X-Stat-Signature: yy3zcw63ykyroctn9sewqp955fhb3oky
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792480884-480317
X-HE-Meta: U2FsdGVkX1+YVwrGqm8Xedm96+HSnegZkg/Nh6/7JeZb9L2AxQdDkrd8uWOg5OF6VyS7m4Ph6EPsiqHN7wP7OAdXQ2OUhO/Jf9yKujUH7eZqVGmxmJFfdg1GqcFTJrNK42gsvjjzDCRMJgjsVvQ7NKIF9BcLpPvb16cFT9M1fYG67uPZMgQkWblWRfSLyeGbX4h36tJZpmHH0WX3sS9qTwLitIw4YWxRXs1bP1jVlabCGYId2rBsnNNdnFcvoqbwnU2PjPBSinhDpT89C/o+UgmEn5PQnfK/Og2nruAOdooZIdAJbdh7msbXLyUmyAHl/Hp4FpnE57xX/A+FKPEeC0yv90i7TliGqMRqMljbl8/o79N3C/kIvY3n5qAza5G4Fp4d1RjD0etlC/GKGNqxYpGawpeeCNHyIC5ILGv6MsvAvtyMiSR/+SH240b3V/rXbcOTt/hKt8yWRoA/L3w2qUjXrt1pZwGkNqekRGKVYWUx6ijsAhR/Jrl+mCUR56WkDXBacrbe3oCfFfobbsVAfaezsDxPZgQ4jd5PQ7bLAbtmhKGmmYKBSyj0ACZHefmSJBH45iA7OBP2juWn1zYMlCZQsAHCq3Mde50Chjnyw9TnWnCGQPg2DMkbU+qTxbRGWQ1jA55o8GweZm2lWWAHO28UOy34l4QxmMagfbL5gP9JAVY/MTyuokbE7SPZMuj1jkN85656GJ1IYGgCxXwdD9ZZdvMNNzTdS69pXR6XC8n2VcEA6ue+wQbh1pyhfPb3oHAekHdIjDXQtUuuqle1pUIV6bYddz89ha23cN2gXL8RzBGk2lREIuHS3cKdFJNhilHCNHDM4kTPruIXiIvm1SXy1qQSWkZRUaUdM5Nwus8P58TiebqVXiwt+8KJ9ajIywCWbjHu3UP/Rh+ORwUMn106x08774HV0TOypyEGOWGlM3ZNTl7iNA+dVSsp2N8UG7LAQRJ45rDxQfhn4Y2
 3zJ0W75r
 4EOkeoNYf5PJ+w0NuBS80w93p7SLbvISOU6HvxiaNE7zMLKinu8UvMrh9FS/SbyKgdfHicCSZ7AvOlVAajNJxcPlb2tM48aJpfMjmlHiHgMH4s96T+QmNJiMNkkHHTwf2VzYZ1cQe24LQVt0FdHHS0yNCiwPA7sB8zuvnJ+JAyY6DcYiPYCQgi0JmKpSj1XTsat8yGkQ60ssWqkgndu5RNBEEsVRoEcuSPw2Pqf6wWmILKsd3WCf+j3NXvDSglXW+Uox+qh6pqUGpk7J7ZqeXPh/rFr3pGS3/VNxw1+/gOl600BNdAN1HRLLHox0Db49gipu+5NMBe9plwaqfT1Cfa9OiGw8K/ifBZa1ohAATQsorapP2PyjattjW35+tb/Nf42N7dkFNbo2085w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/19/26 20:48, Gregory Price (Meta) wrote:
> free_frozen_page_commit() clears a hopeless node's kswapd failures once
> its zone recovers above the high watermark, but only if another memory
> node exists for allocations to fall back to.
> 
> The test `next_memory_node(nid) < MAX_NUMNODES` finds only memory nodes
> with a higher id. The highest-numbered memory node therefore never
> recovers on this path, and its kswapd stays disabled until reclaim on
> that node makes progress and balances it, or demotion is re-enabled.
> 
> In many cases, direct reclaim many never fully run against a lower
> node (CXL/kmem), and that means its kswapd can end up full disabled
> in rare situations.
> 
> To reproduce, fill the highest memory node with bound, non-THP anonymous
> memory and no swap until kswapd gives up, then free it: /proc/zoneinfo
> keeps showing node_unreclaimable 1 for that node. A lower node recovers.
> 
> Count the memory nodes instead. Adding first_memory_node != nid to the
> existing test would also work, but a count says directly what the check
> means: some other memory node exists.
> 
> Fixes: e7a5f249e6db ("mm: re-enable kswapd when memory pressure subsides or demotion is toggled")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

LGTM enough for a stable hotfix
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 417c427b196d9..6d4f03faf96ee 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2929,7 +2929,7 @@ static bool free_frozen_page_commit(struct zone *zone,
>  		 * kswapd work again by resetting kswapd_failures.
>  		 */
>  		if (kswapd_test_hopeless(pgdat) &&
> -		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
> +		    num_node_state(N_MEMORY) > 1)
>  			kswapd_clear_hopeless(pgdat, KSWAPD_CLEAR_HOPELESS_PCP);
>  	}
>  	return ret;


