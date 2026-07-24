Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37AACC531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 14:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3AA36B007B; Fri, 24 Jul 2026 10:39:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11EB6B0088; Fri, 24 Jul 2026 10:39:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03E96B008A; Fri, 24 Jul 2026 10:39:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EBB76B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:39:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 24DA4403C8
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:39:27 +0000 (UTC)
X-FDA: 85023928374.21.E017465
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6F6FE14000E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:39:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kwAol3re;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784903965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yPJB9R+BtGXKtqq0HHHEWwuGdoJGjUsGQ6ieAQzTjYY=;
	b=1Cp6RJzkX+R34+MmYOgAN5+wNFUbXa9/TdPjE5c8BTg10lYS8iv/dJCLbtD/npX7/wilsV
	jtYK8xA8SdFLQnsRP1a31BKxjxyD/67pmZorq9B/u0qSNfPQegFS8WXNJ4gni69eM6Ozch
	PQkpS7AjGqNoEcfF+Ou/Rfoz6aqohyc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784903965;
	b=CB9N2yh2E1UFCMR3+Kncg88uSr7hYu+DfkO3dtlFCTud6xW4vEqf3QTr37+VAaFyKUjTjm
	KHMwbHAqXMdZjvOnWhpiM1Gi6HLH5Nes4BIlH2cWNLJBzGJ+/lJVJPTqlQNBtgsOpJDTuw
	mAKwQMWbbxTmcON9yplXZ5BDOWaKQ8A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kwAol3re;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E01540B11;
	Fri, 24 Jul 2026 14:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6171F000E9;
	Fri, 24 Jul 2026 14:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784903964;
	bh=yPJB9R+BtGXKtqq0HHHEWwuGdoJGjUsGQ6ieAQzTjYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kwAol3refeVf20YGm/UOA+ujIPTna1HVD3qxYvbowWy8qLj5ubn0oNRILAXeVwy3b
	 YiJGx3XS3W3b2u3vVNyokpkGpFWufMqFfzfLwqkbDUsTLNi1n+u1hqlnKKFpWGhYzi
	 H5Wc0axNZdJTilq9FXVq6rcFdsfnQ4BsoyYZ/t/WvhJd2ZxXURxVUx8u0N6/+m3DUS
	 fiD3zgmldjgLxUBNCHHEqO8iWyJGG+ZAolYgSbP8RTs7MOG5fyGx7NrJZnNPRB3YSp
	 OyTkEd6BqKk2w6IbEWEql4Vb/zO/gIE3a3oES5R+Nk09Xh1Nph1Ur8vFKW0IGCEmSM
	 RwuFA9beoHYCg==
From: SJ Park <sj@kernel.org>
To: dayou5941@163.com
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	liyouhong <liyouhong@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/damon/ops-common: factor out damon_putback_folio_list()
Date: Fri, 24 Jul 2026 07:39:16 -0700
Message-ID: <20260724143917.94375-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724060135.3014676-2-dayou5941@163.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6F6FE14000E
X-Stat-Signature: i5ubtea9dhgxa47r6q8woe8bzzfqbzoe
X-HE-Tag: 1784903965-129889
X-HE-Meta: U2FsdGVkX18hXxVzEsmzju4ZeFOAg2qmU75p+77el47DF7uUxx76Vlh0cP6Q+Uliiuuht2oCKr2s+NnYebDbThDaUlMswB4HS/AN6Z77Jw6+9ezx67T+tKD7vrGMWMt2pweGWEHi9SDCc8nxpm9XRNefJOWUkGptBP1934rhmkiRsqVz+IzIqHAk7XXLqqcIZGuWy9thcgORpNI0GC1MlvWkIbwxkMGVOvoNWXj6LTcq7C4GBr4T8GtupC1l8ZliGIXm+q0gOGNPBf2hoUHNQGDsXc7aDwSMzquMeyPeS8hA+ZniAHhDfI+U4gMGdClUsR4rPQyEGUG3SXsIa/kTkeb58MswAXCeUQHTnQ5lqN7lygJSNpYwZWGE2XXtA9tKjhY45NEJzvzJgt+1g1mj+E9e/fTDnvt0CJy9QuKnU3VbsB/cLDUPLdMy0xcL9r89iPvw5exajoUaQkZ7SFxasLp/4yCq3FUECPeGMU2BxLUy/2Kf1xN30vm7WfAuYhk8ALaasTkoqA4CGwFxzgjtAfX7Z+w0fZKyfzO5Ftl65hpXYD/OBnK/c96GonspKCImARuKNPxeT/qNB/XC/565XwuHmkJUI+35MKi/BWa4tAN+c/+c8MFDAwN/KQuS/vY18SjKxeV9nPOGyHpVT15DApqXHPGE7c9AEcbpuXPOilde2kXa8LI0G0f6pKqPs2xCdx4ZzAdFbOcx+jFPHchOO/tUO9kom8IMyzfEJ8HF5hfp3H9/+Vhv2DXPBB1OqeDbbkkLsYKma5NIVzIcV09XOva3nZx4/UfMWQ+Plko44s3p+zV5Fff6vb7oNxkfdAXkto9cOJ8bwL+N02DcT4ArFw9ksVNA+w0jSEXvc9AiGdhuh9WvWaUTDVetd4pOwkfp6PlD0bqRJQJ+0BxTuYgcklxit8s75fv7AWHjG6FfyLyMKjERNjOcf/8Gt/OODsm3NvcCUivRtvKreYj3yPz
 rjOo6Dzk
 0udMf+wSb7iwSvITxAEWs8QZAgDsi4vsuWo9tsAGXzuU/qtna4UvuoI5VW3Dfpt7q8jc1Em5KyBmLmKqrqBU5nojAHZSo2i+dUY/h4eL/R7xUMx4YC1hS4Pz8gUGapuU0nhESWaUiNKovZ+OmpnX9x8Jh196eQZIoItp4gFs0kxrDivkVvxlz5+vF68tZV57JuASAUGmF5T01TVDZjgi5zLRAR2wwpZc+JIVLweDNURdtBBdJKtKIc09a35WMMKBU9BTwfhdFtHEOp0St90c3Zmgp5JN68L+teLvjDh9/UcjxK5HxxS093pvI9D60Tp3SbI9uIH4cpSvSTpe3d8APnbcesGiJPM1Sn0VbtdPwOMTOHRo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'get_maintainer.pl --nogit --nogit-fallback' suggests adding below recipients.
I added them.  Please consier using get_maintainer.pl from the next time.

- linux-mm@kvack.org
- linux-kernel@vger.kernel.org

On Fri, 24 Jul 2026 14:01:35 +0800 dayou5941@163.com wrote:

> From: liyouhong <liyouhong@kylinos.cn>
> 
> The putback loop is duplicated in damon_migrate_folio_list() and on the
> invalid-nid path of damon_migrate_pages().  Factor it into a small helper
> for readability.  No functional change.

This is not a hotfix.  I'd suggest sending this separately, not together with
the first patch of this series.  Sending hotfix together with non-hotfix when
they don't really need to be applied together only makes it complicated.

> 
> Signed-off-by: liyouhong <liyouhong@kylinos.cn>
> ---
>  mm/damon/ops-common.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index f5ded45fabd1..9a1e8aec5444 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -331,12 +331,22 @@ static unsigned int __damon_migrate_folio_list(
>  	return nr_succeeded;
>  }
>  
> +static void damon_putback_folio_list(struct list_head *folio_list)
> +{
> +	struct folio *folio;
> +
> +	while (!list_empty(folio_list)) {
> +		folio = lru_to_folio(folio_list);
> +		list_del(&folio->lru);
> +		folio_putback_lru(folio);
> +	}
> +}
> +
>  static unsigned int damon_migrate_folio_list(struct list_head *folio_list,
>  						struct pglist_data *pgdat,
>  						int target_nid)
>  {
>  	unsigned int nr_migrated = 0;
> -	struct folio *folio;
>  	LIST_HEAD(ret_folios);
>  	LIST_HEAD(migrate_folios);
>  
> @@ -374,11 +384,7 @@ static unsigned int damon_migrate_folio_list(struct list_head *folio_list,
>  
>  	list_splice(&ret_folios, folio_list);
>  
> -	while (!list_empty(folio_list)) {
> -		folio = lru_to_folio(folio_list);
> -		list_del(&folio->lru);
> -		folio_putback_lru(folio);
> -	}
> +	damon_putback_folio_list(folio_list);
>  
>  	return nr_migrated;
>  }
> @@ -395,12 +401,7 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
>  
>  	if (target_nid < 0 || target_nid >= MAX_NUMNODES ||
>  			!node_state(target_nid, N_MEMORY)) {
> -		while (!list_empty(folio_list)) {
> -			struct folio *folio = lru_to_folio(folio_list);
> -
> -			list_del(&folio->lru);
> -			folio_putback_lru(folio);
> -		}
> +		damon_putback_folio_list(folio_list);
>  		return nr_migrated;
>  	}

Looks better.  But, how about further simplifying it by moving the folios
putback from damon_migrate_pages(), and doing that from damon_migrate_pages()?
damon_migrate_pages() would do the putback always before returning, and the
taregt_nid path will 'goto' the path.  E.g.,

--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -391,15 +391,8 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
                return nr_migrated;

        if (target_nid < 0 || target_nid >= MAX_NUMNODES ||
-                       !node_state(target_nid, N_MEMORY)) {
-               while (!list_empty(folio_list)) {
-                       struct folio *folio = lru_to_folio(folio_list);
-
-                       list_del(&folio->lru);
-                       folio_putback_lru(folio);
-               }
-               return nr_migrated;
-       }
+                       !node_state(target_nid, N_MEMORY))
+               goto out;

        noreclaim_flag = memalloc_noreclaim_save();

@@ -424,6 +417,14 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)

        memalloc_noreclaim_restore(noreclaim_flag);

+out:
+
+       while (!list_empty(folio_list)) {
+               struct folio *folio = lru_to_folio(folio_list);
+
+               list_del(&folio->lru);
+               folio_putback_lru(folio);
+       }
        return nr_migrated;
 }

This could be applied to the first patch.  And this patch can simply remove the
redundanty putback.

>  
> -- 
> 2.25.1

[1] https://lore.kernel.org/20260724060707.CE1F81F000E9@smtp.kernel.org


Thanks,
SJ

