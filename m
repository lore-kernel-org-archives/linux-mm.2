Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DCD0606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RoKXrxRL
Received: by kanga.kvack.org (Postfix)
	id AEF3E6B05B6; Wed, 28 Oct 2026 04:41:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7966B05B7; Wed, 28 Oct 2026 04:41:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DD6F6B05B8; Wed, 28 Oct 2026 04:41:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76CDB6B05B6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:41:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03A8EA0C57
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:40:59 +0000 (UTC)
X-FDA: 85371389880.22.FC39914
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 428341C0007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:40:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RoKXrxRL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793176858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NScCcV9wFc6Sd1YtAGPOEgK4jDQ30KRAuuBIko3e0tY=;
	b=ObKafwliCy5JW+hmNOXTL+VwvCKv5Nbs+JSWBnwhPEG/tQ9EHwB5FnV2nKKlf/woBZCwJM
	ehcrD+Qq0KV/htYKxOUD60sVeR2oAj0EIj0vLH243ENbZkSIOkn+ca5eUhSI9F97ZxzHSC
	2I/PUJ/3W6FCXwpntSTHQNm9v25J3C0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RoKXrxRL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793176858;
	b=320HhFBu6k8okcB/gZLp8XIghSDXWW8ywpTzMVqtRHKOrTrxBAd30HxWKa783OsAQKOVgK
	cgsyKflxgziFoSIsrt+FPB8mHl3q5w/1Sja2okFvtvEjVZdfbNdJQbGl3yGfeSF2Qq2iK2
	B/ZTelBeNLm+8RYYYu8wpsb0dMXKtfQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 91D1D60136;
	Wed, 28 Oct 2026 08:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0EF1F031E2;
	Wed, 28 Oct 2026 08:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793176857;
	bh=NScCcV9wFc6Sd1YtAGPOEgK4jDQ30KRAuuBIko3e0tY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RoKXrxRLPSgf26a6jGNaysWfRNoZuVhq6LhyElLzyxCGgnlYSmwc6jQjMIvjn2CfW
	 grOFoNwwPNL1zB0oH2t4PElnk9fwgVTYa4/Tp1721aiXkzkSSCUsUvngV+bfzy+vnn
	 ybZnFU4aTm/JO6kcIP9tS7sVgF/4asdtiIbTdGtMnf3E+Umijm95tGIBqnQGC0xq3E
	 z0xio0fi+QIsk94xhcj0Cu0q+D7cur4M0vlceYqW337VsgA5A/W6acgwGAN8Fzjyjo
	 958jVF4UeDgw0Q1j5ps31XySmZ3JYWG3bW+6BgG6k9GWU5Lx+BmRfn7NCaELLadrF3
	 eB84dhGt+8GHQ==
Message-ID: <a212c5c7-04a8-452f-ad2e-68d61d281e83@kernel.org>
Date: Wed, 28 Oct 2026 09:40:52 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate: snapshot the source nid before the
 misplaced migration
To: Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com
Cc: linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>
References: <20261027021721.95781-1-laoar.shao@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261027021721.95781-1-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 428341C0007
X-Stat-Signature: cno8co4umcfa8uozpe9xrxbsot4x3ac7
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793176858-984341
X-HE-Meta: U2FsdGVkX1+6Gw0wH/3y0tKHe1XCnjkJkXXJZM5PSnG3ET6rjU0U8+XDTS6BlCrijI63IHc7AZ7TM1XF/KVgbee7k6Zg/y0xHsqumKPj9Yj/PV0fKZ3tzWp31kZEBfEsoBT6Bl9CWp3ek6EUw+dc0y7iJ2qGVh5ibjABTWLsZQy7w67lOC/DyLAiJE0asxkDEjxV29HGawK2jYIOW6EhERN735ZCerdC2MJybY2nhNoX46e3p6aMo2Zcr82oWUVfHja9XjK/21lsCNQ6NyhHKU60Zt05St7Yu1rs4aoLgoQhOMZH7rnNxVD8JAVqQHC4Jmz2RefQDFKo0BZ81r6eVGBmPBBfFB9Nr2EXn7OWq2703du2yLNdxXQyHHw+kLKh8oyRFUD8zVVtM9JDokdQ9tJan2qcSWZVt82amCCSGM18Z8xSmoPkSBEFDq3wlYgDb96UFjs6HPxjXD5xBrvG+wd4mJpnmpmX5M/rqcRyM8P38N/taGsRJ0/QXe40wGQuQZCjRIlsGtVUbcfc69uWS1nRloGmEP4E5i4XqBxYYp1qswB+2ZIZ9uau/Z235c2lvKoXsXYpWM94l2LiO1AvlHBn0VN9+DC+TNE70b3V1zBGVQYDtnTxjerZFgh7SN27HjfQc41oRbMIzAP+ocwPbZymRVla0DGZL02f6VWfBN19U9ii4ZGqVeJyCp1JErl9U58DjA4qqBiXPlAa5w14jrdFfFYOO+LZnQXCkTjhFw+Gf1xpR9UNeR3z5TJCjdF2TevoGi29m5WSuQ2Fb+aIKpiTQac6ORqjJfL+ijVZhhPcRZMs56ls7cGPIP8TW8YIlkQ/8a1LOp7DRvRbqQ7R43LUQUSKmGahUvhXSABq2H0dEayQdcv2OEig76b2cP8UsHsjieQdstqVnh8J62foj913yh7QeYkS0kwvzZNPXCNSIdcTV+Y2d5+oXDp7B1nWoJzgMzliXEvnfIt/fkq
 K6akMnHc
 WgM6Z90sOpHRPa6VbTIJhUq46LXbsAaxxOq9HeBhjx2taPwDvqKSTJxaxinzTz70pA8p+pLkxfGc7B+rCqQqYYeCN8lWhfn0gUy40Z8BWCGnZqg6XD1092VFbUbdN1DDQw6Duy1fZtUz8HwzQbxH/OWC8VWSbALL3/lFOYc3YLVGbxpHo8U5ta2xQxiWa5YUk49DzxMNn4QTlvLR6xkibJkBwb7+vNb6DbPNXz1DKxkOPpeGFB+cCJYJ1ERYgdsTfqpTwd56xs3HMIMuJL5/lupnPZYO/LHKr0p3htX8srA0vcTcKtL/1iW4VWrO/fpOqOKZubsZaIxoRiyRgwLnSeb+NB1/ENeHsU/wMv+ww7ixDULyCsp+OVh90xQT4/CRF4xjFWxY43RNHcLLJGzg3s9FtLhAoRZQNPtAitzf+SLryTzhEMJA6/t5VErqFdRd/HiSOIgrf4ChyRUgQ8VrHtm+owoJV5vhGK9N0ATkkl2sQjYJcBhRxIpAXm2n4U+NpUa1h5jp8ErpVvrWpE4F5FCnv8coVxMTuqSIKg/YFfTAxGWZTNQcffsSrdRiHho1SUzHD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 03:17, Yafang Shao wrote:
> A successful migration frees the source folio before the promotion
> counter update, so the folio_nid() read there operates on a freed
> folio — which may already have been reallocated. It happens to work
> today, as Zi explained:
> 
>   : Strictly speaking, it can be seen as a benign UAF. It works, because
>   : 1. folio->flags happens to be the same as page->flags,
>   : 2. folio/page nid is stored in the ->flags and never changed.
>   :
>   : In memdesc world, after a folio is freed, I assume folio->flags would be
>   : zeroed since struct folio is freed and calling folio_nid() on a freed
>   : folio would give a bogus result (yeah, it can be mitigated by not
>   : zeroing node field and each node has its own struct folio pool, but that
>   : makes folio_nid() implementation dependent).
> 
> and Matthew explained further:
> 
>   : once struct folio is separately allocated, it's a UAF.  It could be
>   : recycled to a different NID or maybe the slab containing the folio could
>   : be freed (assuming we're not holding the RCU read lock at this point in
>   : migration, and I don't see why we would be).
> 
> A separate concern is memory hot-removal.  With memory-tiering mode
> enabled, successful migration can release the source before the
> promotion-accounting folio_nid() read.  If the task is preempted there,
> an otherwise-free source block can be offlined and removed first.  On
> the x86 path, removal can unmap the source's vmemmap, so the later read
> can fault.  The snapshot avoids that read.
> 
> Fixes: e39bb6be9f2b ("NUMA Balancing: add page promotion counter")
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> ---
>  mm/migrate.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> ---
> 
> v1->v2: improve the commit log, thanks to Zi, Matthew and Andrew.
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 15b45832bcfa..91ba064e1bf4 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2757,6 +2757,7 @@ int migrate_misplaced_folio(struct folio *folio, int node)
>  	pg_data_t *pgdat = NODE_DATA(node);
>  	int nr_remaining;
>  	unsigned int nr_succeeded;
> +	int src_node = folio_nid(folio);

can be const.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

