Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E041FC61DC4
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1E5C6B0095; Wed, 26 Aug 2026 04:23:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCEBF6B0096; Wed, 26 Aug 2026 04:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE59D6B0098; Wed, 26 Aug 2026 04:23:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4E636B0095
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:23:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3CFBA3683
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:23:49 +0000 (UTC)
X-FDA: 85142732178.15.BF0AEB7
Received: from mta1.migadu.com (out-82.mta1.migadu.com [95.215.58.82])
	by imf13.hostedemail.com (Postfix) with ESMTP id BC9DA20009
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:23:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pGVrpfAx;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.82 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787732628;
	b=H4vM+eaZ7a4cPMCoR375eAaavYy5/zU9FWbQAznh4QQlt205ixaVOuDOpkkZNBSbkeYavR
	3FV3iCYX0/AGlJgl1Dcic4s135YIJjKbfYNphzEBsbH3ZI8CKLZE0JjRoaLGd64jcjv1UU
	itATGCgEPkBC3PTqcGE2juP/wwe1l4c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787732628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywhUz20q9xlD0TuiB3WNfI7Jw22OgANqaMrYQa0ggkI=;
	b=W1Xr45Izkg0NE0AKF3RwX55Dtx7ktnmTG0STAluzyymty2XDdpxKo3+WA0yxUbvKa/QoR/
	ghLCV4lyHYXCOFaoX7KJxovHXHbFXIJZXZUlp0XKO4+ARIqOKc9k11zE7uppr6P1jnwBTn
	pYdsUlo9FRH7vzqIlz0bLIX/nB1KE98=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pGVrpfAx;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.82 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=phYg0IFEYWVrpDdbQ98Z9cebBiSYeTfZKyJMdv6V2gs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787732626; v=1; x=1788337426;
 b=pGVrpfAxNuTaD/Om83RMN3gQMIzXMtUE5r0zLTCW12HTM26NYyzdoR8r7Dd8R8nCDtw6Dffn
 1fFHUkNOnLzVEHN5r7ryDVxw+rhznt+umM2eb1kYy61q1jJ2h30sXo7VofPS9PzV/LzqHqbJUFj
 Koj8tOVF++TuNRdQg0siWUGc=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (223.70.159.239)
	by mta12.migadu.com with ESMTPS id c55063d47d246f4e;
	Wed, 26 Aug 2026 08:23:46 +0000
X-Mizu-Trace-ID: c55063d47d246f4e
X-Migadu-Flow: FLOW_OUT
Date: Wed, 26 Aug 2026 16:23:34 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com,
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
	lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, stevensd@chromium.org,
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com,
	zhangbo56@xiaomi.com
Subject: Re: [PATCH 1/6] mm/mglru: batch update lrugen->nr_pages in
 inc_min_seq()
Message-ID: <ao6ihnPCO5zDCT-D@fedora>
References: <20260821102538.22642-1-baohua@kernel.org>
 <20260821102538.22642-2-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821102538.22642-2-baohua@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BC9DA20009
X-Stat-Signature: kb6dcnt4iq3ur16tc6cq8nrab18ipfkp
X-HE-Tag: 1787732627-17772
X-HE-Meta: U2FsdGVkX19WqlpnacrqB57sq4oR0CWwv3GAxIUmv/DOlnS6YJ5XE+HxyhCmIN8QfLIA1LKe+YyM0ClAGa0RN+RsvWHQeIGihdWRBaQcacdSX+lHXlrDoLMotIwtSCYroAbU1jpzdgUVLqtFnsjRd3hPaGu3/RieQKr7USavi0sqKwFQSXw79I3PwzRcnmVapKog+VazVdc1d7AvsNtM+09m2+ZBx/LsJn2yk+y43j451krGNhp02eORoxKW+yrWxYOwQnpIJRp2Uv7xBZtThOKPaefXUTs20p0RNKJ++0ydDdUwtnnQn82RH8st7KiccJB3Cxrr/IdKwZkp0cHwR8+Rl81Mjp0KcIXD6RNrS+zZjNb7ZoLF+SQjwIm+zM2YvlxtaDKlr0w921yF3zQkrdoV5/Lk8BQiRICM6pDOgzP3mJnXNG8g7kzYsxxba2YpvoWmxBxv5aZX4TBtdonmHb+H7Gi3oKUT3vD7aZlaUroJx/eAfA0x2PNWsFFCoHL/2HD8Mfxvt2gGjOOdoBLhfZoZoJ+H3EhIzVZlor5KuX8SihO4I2ri+2syHCUnBkVeaYt6IL+e9wjrd/L8yAat6cP0afpYOjCPv1zaVHQgzeLU92XOJrkV/EQEFVwLmSfW2rLW5a45R7tNum6ozYzU+9xXoq7/HaEFAfctKveTiL73JfEGNrGvnCluLrkzOqCXJQveE/wSA6mLFthGPCP5sRJe2RBUEcQLup4tAzv/dtlA9vzmjvwu47G/RMxqBUNDPnrve7W7cdzXdKUhfiT9An1mxV7qExZIzGFofRWG5tStF2XwZP7qT2PGuy0VQLdAkk0us6UhM0RgEVMOKSvPRUmPWnmcjuhTPIQyrBNPvBp4hy6kq2WGRgbdFdOrnSkpbN8sedDMcyaOVoTJQMaIn+SXegLC489fcfQk/mka6zv7obWyuHmZpHbhEWCq3/huh2IzTNtQEBHAgJ/nGAo
 HiPQLxwz
 wKcA/pDbpxmJh+X04zTUZ/kxpqRS6eaYztomgepiqKynO+rvwYLo91hmsJ0xnFBaygIpJlB5ATWqWvrM8qIRMbGvzYUFVgHPzW0d1YrZo4RysvJuC/eKwR9qZoAwWTCu1ZyShoDw8CawirpdAMvVQC4h3lE86h0VjvJhktj22ZibHV2Q9P9/XnrUzfiM4UUmnlHFGSlw3ypoId5it1MCE7OUf9AqYeHbhGiToc/84Vce6sggdfN/T9I9ZbsxWa08FcaAcBNV9R/6juhvOjKTxil8adgTdwU6FRCS1TZQBvOREJU+lJPdkyzHLG+dVIk0BX2zOhDblDfSI5JLe3OU4RdA9Z0LckmRvV8ibkihczu6VX8VXn37Jd6YeubD1wRe2JhOIz8eBzAXUJBDOIs8czAXbYphd5eH8hUG87qIEGT+8q+5LvE0/1aJUusreeEpUuxf2JrT6FrwI1tJXRgHfBKKcJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

On 08/21/26 at 06:25pm, Barry Song (Xiaomi) wrote:
> Currently, folio_inc_gen() updates lrugen->nr_pages for every folio
> as it advances generations. Instead, accumulate the size changes
> and update lrugen->nr_pages in a batch after scanning the entire
> oldest generation, or when the scan stops because remaining reaches
> zero.

This patch refactor code to split out __folio_inc_gen() and introduce 
gen_increased, this is the base of later patches. You seem to only
mention the minor optimization of lrugen->nr_pages. IMHO, this
refactoring can be split out to an independent patch. The lrugen->nr_pages
can be integrated with other patch, e.g patch 2 or patch 6.

> 
> Since we only move folios from the oldest generation to the second
> oldest generation, the active/inactive state cannot change. We can
> therefore skip __lru_update_size().

For the justification of skipping __lru_update_size(), there's a
precondition: get_nr_gens(lruvec, type) == MAX_NR_GENS; With this, the
oldest gen and 2nd oldest gen are both inactive. Calling
__lru_update_size() may waste tiny cpu, while skipping it may cause
issue in future if the precondition is changed. Do you think adding
a VM_WARN_ON_ONCE is necessary?

VM_WARN_ON_ONCE(lru_gen_is_active(lruvec, old_gen) ||
		lru_gen_is_active(lruvec, target_gen));


Thanks
Baoquan
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 46 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 35 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c1404a59523d..0d74fc00abd3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3296,20 +3296,21 @@ static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma
>  }
>  
>  /* protect pages accessed multiple times through file descriptors */
> -static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
> +static int __folio_inc_gen(struct folio *folio, int old_gen, bool *increased)
>  {
> -	int type = folio_is_file_lru(folio);
> -	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> -	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
>  	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
> +	int new_gen;
>  
>  	VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
>  
>  	do {
>  		new_gen = ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
>  		/* folio_update_gen() has promoted this page? */
> -		if (new_gen >= 0 && new_gen != old_gen)
> +		if (new_gen >= 0 && new_gen != old_gen) {
> +			if (increased)
> +				*increased = false;
>  			return new_gen;
> +		}
>  
>  		new_gen = (old_gen + 1) % MAX_NR_GENS;
>  
> @@ -3317,8 +3318,21 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
>  		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
>  	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
>  
> -	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
> +	if (increased)
> +		*increased = true;
> +	return new_gen;
> +}
>  
> +static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
> +{
> +	int type = folio_is_file_lru(folio);
> +	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> +	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
> +	bool gen_increased;
> +
> +	new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
> +	if (gen_increased)
> +		lru_gen_update_size(lruvec, folio, old_gen, new_gen);
>  	return new_gen;
>  }
>  
> @@ -3904,6 +3918,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>  	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
>  	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
> +	int target_gen = (old_gen + 1) % MAX_NR_GENS;
>  
>  	/* For file type, skip the check if swappiness is anon only */
>  	if (type && (swappiness == SWAPPINESS_ANON_ONLY))
> @@ -3916,32 +3931,41 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  	/* prevent cold/hot inversion if the type is evictable */
>  	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
>  		struct list_head *head = &lrugen->folios[old_gen][type][zone];
> +		unsigned long delta = 0;
>  
>  		while (!list_empty(head)) {
>  			struct folio *folio = lru_to_folio(head);
> +			long nr_pages = folio_nr_pages(folio);
>  			int refs = folio_lru_refs(folio);
>  			bool workingset = folio_test_workingset(folio);
> +			bool gen_increased;
>  
>  			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
>  			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
>  			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
>  			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
>  
> -			new_gen = folio_inc_gen(lruvec, folio);
> +			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
>  			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
> -
> +			if (gen_increased)
> +				delta += nr_pages;
>  			/* don't count the workingset being lazily promoted */
>  			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
>  				int tier = lru_tier_from_refs(refs, workingset);
> -				int delta = folio_nr_pages(folio);
>  
>  				WRITE_ONCE(lrugen->protected[hist][type][tier],
> -					   lrugen->protected[hist][type][tier] + delta);
> +					   lrugen->protected[hist][type][tier] + nr_pages);
>  			}
>  
>  			if (!--remaining)
> -				return false;
> +				break;
>  		}
> +		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
> +			   lrugen->nr_pages[old_gen][type][zone] - delta);
> +		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
> +			   lrugen->nr_pages[target_gen][type][zone] + delta);
> +		if (!remaining)
> +			return false;
>  	}
>  done:
>  	reset_ctrl_pos(lruvec, type, true);
> -- 
> 2.34.1
> 

