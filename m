Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 274ABCD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 17:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B08D6B00A2; Thu, 21 May 2026 13:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8894D6B00A5; Thu, 21 May 2026 13:18:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C5F86B00A6; Thu, 21 May 2026 13:18:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69D756B00A2
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:18:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A7D1C2457
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:18:45 +0000 (UTC)
X-FDA: 84792086610.28.5BE79E6
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6C6A514000A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:18:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cgpeDyzT;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf26.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779383923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6uBaRWeboZvmpTwEOOUnQd/wpJgce6tSxtmt3LHmSMg=;
	b=bEaBq4RhJQETvA6i00NazAChHDPSjerUpnITT7IVu1ffgYrE7Yc8oYkYcUwMcm4QaX+dft
	q0jPGDWr6InokMgBO1b/MWlG5zad5/CNtN/u0+VjK8555E2BDmRK8IMgc/S4DR6UUCc1Dx
	b4EOttFS80AL91jsWCKXxcWngUSS3Tc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cgpeDyzT;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf26.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779383923; a=rsa-sha256;
	cv=none;
	b=V6V4Lu8RvpzLewIwIIW5yalj5jShLtfOYTcbi+qHrca/57iL8MuzWrrb3RrGB5ou8N+Xv1
	TpQJuPjmL+IxBGIEkQVKzwPldEFL7F2Fk2jdnZFXqlfqcIt65Q3UXxTqfSMqzdsqG2yQ2A
	yQgx8J64ooeA4rvH5bEPCcL0oKUs7S0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6uBaRWeboZvmpTwEOOUnQd/wpJgce6tSxtmt3LHmSMg=; b=cgpeDyzTxHXrutNT1OLjKEANXa
	tuJ7EygeSCCWRY73ILnRFUSrT+YePgAcqmWO3wOt8RvMftzp8NynHhxYocjZsnj+Oej48ITkVACTT
	t4o+Flsnxt3f5XX6z/+xps53VX2o5DK1+hXKuvGPOPuj02QgJgpVuQmJugoaPUHaSfUBGH19ilAq+
	Z92P5OvmpPEXYHxovxwCTouRStYdGazxe/2Bu1TE4sn13Gw5rQmup/4zL7oDACwPmsLZJfziQlMHD
	GD7SvlrWR5/Yn3iikw00Nd9A7zuNOFHTczZFpovLWP/pLy+JEfJBKP/wrUYrMNE3KJIH/eVv1S9xV
	3odIx6wA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQ72b-00000008c2v-3otI;
	Thu, 21 May 2026 17:18:38 +0000
Date: Thu, 21 May 2026 13:18:35 -0400
From: "Liam R . Howlett" <liam@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Dave Chinner <david@fromorbit.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Kairui Song <ryncsn@gmail.com>, Mikhail Zaslonko <zaslonko@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/8] mm: list_lru: deduplicate lock_list_lru()
Message-ID: <jzpcbo7vheq2soyyayxv5kmsgachg7f7whlzvjh5wxd7ptceby@vegyxf7ejrv4>
References: <20260521150330.1955924-1-hannes@cmpxchg.org>
 <20260521150330.1955924-5-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521150330.1955924-5-hannes@cmpxchg.org>
X-Stat-Signature: c9re9ot95y3aepasnx7gsdpmkbw6s96i
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6C6A514000A
X-Rspam-User: 
X-HE-Tag: 1779383923-968841
X-HE-Meta: U2FsdGVkX1+abcdjnig9PiLE8ZZTisrCNN8yheg2P/SilfZhdWozKJyHpZQB8ereDObXB4AH9MJL1K7k6vUorzAegATe0cH8Oh/gsP4/gSfwHXoZz9eedykg9bq874ZRlnBDjQ5dYB7Ze4ixr2YQAOWzMdsmhylLMZG7Br+QBu7zyh8aVSLG0rRTeN5shqOrk4hwc1M4rJixblvUC1IVb3cbUMviW/Mlj4FmOoLvSARw35AwMP8Ov287wOK78pXBRkk/FWJu6ySHPdsxGe3s1onMQ+jYpasuZESANHXcRZlqqRDbq5P/6nH1jl+yLa4/auizAVXGfqmPohPWx23LOIlrwJrgh+lRhKm4n9ZDV3FurnpeSSTwgyLqGXkP0a40119AK5pgnI621z5KIAnFsqQBhgiY0TazA0QAsQUNhQ6IQh0buhpspVttWj0YiUTiL95RsYQtFUgRETUwA1hylUl/cuHZeYbr4asDSJ1KzJz0iCJPDzYX9njY7xXvs1Ve1FcB8h525H0pdGMplI84DuzZCIdIEIwwiE3Vtxxy4U3TG2Oko0FYykow1hyFVnDSHx2P5pJWzZ7/lwPtoHWFADNCmpLxS6hG9dwYIAFBOsSLwucd3lKks7XUuEkggmML2AHEM3p8aXHgCcOxsr3+YERioixl1livaHDBartzQn9Yn3BHR88WbmImPhdH4MtrHDgEU2VZQyMeaVYns4anmLfPIIYayKj8jmxWDHDTSzDeiPJMk9k97qnT5KTMngGHSY+8W9AfKil0TWkVUHuE7lfrpColrktmW5NtP6gbOqoG1uWlcnN53rF10qUkx9Eif5o22pF72cCWjNIfi/jU53ysGUq1R/ShdtRAv89ee0foZMP6ahIM0NfwPDW+EmQR/CX1tmHnzKSbf3j+irgRPXFEU6iofoAO4A7tYud3sA2QbZCGD6pufOKElOPlBF+1qXDBe0Ku0lZjSNGE05D
 cI1B6xrB
 3Vzyam4NMWepdUJ4f96i26GYvOUuw/nlCly4AhFgbnb8snlx5My6NWKset+hY058Bl21fZlcVPjk/pKzmK4A4vgwoHSfcp9vQLvYJCkpfRUzFMeWRuf+wF6CuBz0CYW4vSdS754mQN8VNCivyjnByDDOHHQiinsO4RWPeIv9j/8s4fQNweMrmGkxLXwMbeSltpkP8X8dxzjC5AByShCS6HtfG456FFp0sd4T4PvzANPALn95Ubz60najalQYvKDOAdQX8djf39Agf5biMgUqxi/HiJvpHaizkqeI9XFGtTyl7Mma3OehJCPoecrvqWY5yoLlW7VCCv8GtmUevX0+LqQykiuo/+GAhMURA9Uu4lKYbjmWkGFKVLXLJWgSrqA/dBoBvLdIUIZLNYm9thCqcZ0m83UoApUYn8dggdK98qWD6EwHMDHdVSIeMRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/21 11:02AM, Johannes Weiner wrote:
> The MEMCG and !MEMCG paths have the same pattern. Share the code.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  mm/list_lru.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index 9da6fce19832..65962dbf6dda 100644
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
> 2.54.0
> 

