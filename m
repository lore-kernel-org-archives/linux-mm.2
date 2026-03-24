Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B66D6E9A76B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 044876B008A; Tue, 24 Mar 2026 07:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F379E6B0095; Tue, 24 Mar 2026 07:36:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D146B00A2; Tue, 24 Mar 2026 07:36:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D319F6B008A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:36:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B7E8BAEDF
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:36:59 +0000 (UTC)
X-FDA: 84580754958.12.D315A11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id C9F8712000D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:36:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MtaRfCQ3;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774352217; a=rsa-sha256;
	cv=none;
	b=hQUMWxwRxWzqbVhJQhKsvjSf1weWmCbAfgBrhkUhFpdJCF7au6kXHAwCAhBvEIavMYMjPz
	kbXOUFL4Ydu8nkTS0YqzyssGpaP0sU/Wf/WUHd0ksbOc2JSI9pSDdAtfEGw+JIGltx/xYU
	Z3OWJgoKhDi7RXGvmQ32M2t1t3Sf8eg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774352217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=haK3Z3wGwKvhpFv/J8BrfE/Z2IlmXnBqH9V7IZg9j4Q=;
	b=jYyqm+UnWKhipIlUPuiB8N04KyqAfpPi/P2X8uDvffhLMdReUDa9ZyoRNrqwxUlZfERFBX
	01FePDs3dzH4iFEmKRxwtKBpZo9wYFZ/QQIx4cPzsu+FbmQh0jZ8WmQzxPX7r79wmeGKRp
	Uh0PSxO/9QSRxQE1D4eFV/0Oor8+o9c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MtaRfCQ3;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E642943428;
	Tue, 24 Mar 2026 11:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBDFC2BCB1;
	Tue, 24 Mar 2026 11:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774352216;
	bh=tQSs2dFj+n0DSQeut8yGh2rxuLxtozxe3F5h1kJgfvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MtaRfCQ3ZhLZQfIdmx3CXjhspsFtT1KkpoqNxB+3xRp8wEzWFbYb8f1EzJSEuEUIA
	 DSKxggnRw+0t5IUUZfSlc73fLUjz8fXwmbpQ5hf1Vo5NE0dn7Roq0beFTQpJbD5jPE
	 L4dp5uG2/m1G7vBbJaL3IzY5+EOgc/eWjrdA/KdmmLYazxliW0CdIarikJ39sOka2U
	 nDZ7tBq/8slZ7D2PO+pktaIrbePjvbp831kg/LUSOmacyPfjgEcliRYlfkPQIQ06wE
	 Md7XD7K1i60zeqrShWzuHGFn2AGRxM4cUsjlzI4NHpTdlVpt9I24KD0VYGjV/YX5l7
	 0gMS/pPpz7HtA==
Date: Tue, 24 Mar 2026 11:36:54 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/7] mm: list_lru: deduplicate lock_list_lru()
Message-ID: <666b8dab-a58e-4cc0-aafd-57fd59477068@lucifer.local>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-5-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318200352.1039011-5-hannes@cmpxchg.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C9F8712000D
X-Stat-Signature: xgrdfgw1uefqrszyinzqez7f4prm1ore
X-HE-Tag: 1774352217-861164
X-HE-Meta: U2FsdGVkX1/yrrJ1J4Q6DVKuQV9al2O8tio0KdTbUo9EaP/3hmzwQS5gUqR93ExCLHITKGRUEwjMDgI/Rqf7pKZMv0XjFpYxMyPZ+fpiREpJuVSxCNbXDVz3rXjuL8gccWygeXgR9hovK9dT37Ow/FdGBfEtrNk1OFreoOvJb8ekFJYVxDNJN7WWDMCc3iI3IGJH1QcuJqgdvzG0gI+TgHvboEHb1+qulgs26tqwq97U9c5tIRbvd2toPwYvi7Z2DL9ndHOFw/7qdequJ/N4+g4vAm2Dv4UCJJBjiOSD+NFvWMJrfdsiJh9Dh+5YodZX6b7B3jIqrqoe0oSC96l78kODiiL702PErWNnkmsAcRmycKrRAEhg0WftcGH9RgwT/dTv9prKNfDGP1QSxTeGJy2gtUs9+UKbByCRGSZWIUdXWSmdVVts3QguBClXH5clInsY/gba/njhWo7fLTO1W/2oITuIbuZFVJrpKNh5Ous9tNMsfOXjtFuie/xvRaydVF7si/jBBgq/xOCkxUx1XI36vhBWyFaIV5OKlI/IchgeWGjx51CFb21AnWfetOtsTfb6Vr5FhrBda6A+JRrY9GuwS2KfujzHW5Cmpf6CbChdlHzDJ57e8WqZy9Duuy1PPzzaySvqBp6gl+7183SXUEUmD7oAhjTDHtOaNi1K0YZQ9FCr1Y1/gsozfxEjESPeZLktuPbH+slAX0rwpwFez7r6Q7Az1Mu7cUFcg5Y02hzAvJ4m4YboRL++dk350c2ZpFF9TDAbTol2kKZ2qtrQhqoQ+xiW/xcoC9KC1AYpTaYU1UOqLrHPRWEJc3sKFlLtaWwSn6q1fmji+JO8VuPtNygr6ecWCUWnAKeFOy28ENccz6ANPjHslF4IJVp5n2/xTSRl/k433jphLpVgKPFkUqO9sS+89XDv1JkD24b+3uE0j58wZIFNl6wzwah58pL7ghmz6ZEuiS2utiD2o4/
 zlFvO428
 gP35XaneRekZjjSkktZtx7iEb6vqjVWoXBZw6i5KtC92A/CMnPHvy3MN88qEdGLBvFOphBXmgdUiVYGwJIGP3VX2+n8UfbX7Oe8gHXjRpbBmPPz+NvJlw0PLD2y8IHpJC+tLFa7wliQHuIv0SmArdZGXhb4wSFgFMeRSpoCzp4fY+lgk2HooUmqLgxeT1ZhDsyUvovSgGBACJHCSFXC7ye3XHMzqzc8pXCY5KQp+Qy2gswi/QEEQCheCcc/kp+H9MlSGBbxKDy1Az5aBKf+F6oxsOzZEBrKdq0i7pXbq9E8WXmB3P9kZZKAdVJnpf+L03KmPN2CKKuhxNhAlXBefNn28B7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:53:22PM -0400, Johannes Weiner wrote:
> The MEMCG and !MEMCG paths have the same pattern. Share the code.
>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

I like the symmetry also here :) LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/list_lru.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
>
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index 1a39ff490643..4d74c2e9c2a5 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -15,6 +15,14 @@
>  #include "slab.h"
>  #include "internal.h"
>
> +static inline void lock_list_lru(struct list_lru_one *l, bool irq)
> +{
> +	if (irq)
> +		spin_lock_irq(&l->lock);
> +	else
> +		spin_lock(&l->lock);
> +}
> +
>  static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
>  {
>  	if (irq_off)
> @@ -68,14 +76,6 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
>  	return &lru->node[nid].lru;
>  }
>
> -static inline void lock_list_lru(struct list_lru_one *l, bool irq)
> -{
> -	if (irq)
> -		spin_lock_irq(&l->lock);
> -	else
> -		spin_lock(&l->lock);
> -}
> -
>  static inline struct list_lru_one *
>  lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
>  		       bool irq, bool skip_empty)
> @@ -136,10 +136,7 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
>  {
>  	struct list_lru_one *l = &lru->node[nid].lru;
>
> -	if (irq)
> -		spin_lock_irq(&l->lock);
> -	else
> -		spin_lock(&l->lock);
> +	lock_list_lru(l, irq);
>
>  	return l;
>  }
> --
> 2.53.0
>

