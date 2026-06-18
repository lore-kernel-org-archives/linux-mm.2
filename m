Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F342CD98F0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:23:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 452DA6B00A5; Thu, 18 Jun 2026 04:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DC716B00A6; Thu, 18 Jun 2026 04:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CC2B6B00A8; Thu, 18 Jun 2026 04:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0458C6B00A5
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:23:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0BA4F120683
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:14:42 +0000 (UTC)
X-FDA: 84892322004.23.D763107
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2570D10000A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:14:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ezu8amWw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781770480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=djl1UEFmEC9ml3q9D+FtrJf3HHVAsDL/Pz8kB14AFRQ=;
	b=aWm65nKNKA6yrfAH68hNa2Msq5nhul78qtaw/2opW0qOIRzFVvFXU/nVWTT3nmD0hhEQQO
	43hRJit1pul+6w0ABqbc5dFrhr3rwa2X53d8/964yxqYVrTalkkrUbZFOdw849Q4nyonhu
	Jn6jvhNbAXYTwl3RxkUX5rJFUJKLuuE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ezu8amWw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781770480;
	b=xSCjqiJSyl9O5n+LQp7zoHvyxZybtfO57j/rNTl5392ycwt/lVNKaT9JwLJcjQvvALlwp2
	wmAVMjT5YsPEIT0eUNyKH781HOKjH1YDoPQb9XUYZoIbNpw4a6p2QNJPLk70J+3+m6U+pL
	6FAdJ3AMZe/Frmrwj5ms+xDSQVpeXiQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48978401DB;
	Thu, 18 Jun 2026 08:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25121F000E9;
	Thu, 18 Jun 2026 08:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781770479;
	bh=djl1UEFmEC9ml3q9D+FtrJf3HHVAsDL/Pz8kB14AFRQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ezu8amWweTpC/6Onms7/VBRTF+2CcbczR8U9E+BlszlyXabITstcyDz3238kT1e4v
	 z7j3ovocssBr9Q/wQQoXzcTPU9tU35Wk5hVgOEPSBdKtOWK2fnaXO9tAjc5V2tnASS
	 eOMZBelEhLad3+Tu6HvhT9F7jwrkK6O++vTpAo0MRs0rNaW/cRauLjVgSjM4VYOD4R
	 ko0I2zLFLwMW2R3dtENX2oAyz0ASCUP6w5l9F0tTiodLCQdmnCy6g+GbPQ0dzBez5s
	 3BibL4TCT09tRUSUD/nn6x+e0DttePEV6TFc4rMR4LfIKduwWkayBNzw63nHO8Xfr0
	 iQarPWHdh8cJg==
Message-ID: <a777b4ad-157b-464b-8cdf-feee9a6a03a1@kernel.org>
Date: Thu, 18 Jun 2026 10:14:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: remove PageTransCompound()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>
References: <20260618080411.3902214-1-wangkefeng.wang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260618080411.3902214-1-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: zgf58ifi6xx6xg7iftr7p1rez3qoocnn
X-Rspamd-Queue-Id: 2570D10000A
X-HE-Tag: 1781770479-987793
X-HE-Meta: U2FsdGVkX1/6Yyj30+j6rBWYYnaooztdU7LPqz/lon5KticOTSnJEWLkjYzDKko8dEcVwGFHY22SKxxog/godaEkpoPekWInZK4w6ll92V/urEfGRdw0o58ykGS5ai3p5ix/xnWdS+JGRZN4nt1QB7l+TeANL62qXcwAMdJClMfn90lKsNQWzgIOPh9xwoQw7J41KClRMi30IZYF+OoslwiutchzGcEPeGB85eVNL7wxB3wfRJKaZ97z8ZeTzNuIyXDoy5lot8ZbDwo+2khXZ1LqVwOsYmc8fM7hiSjFCLX5cPfXacyqSQaDUu/aFHvVFPLRF3XCrxqH958XNengTljcpwmlVUmpBordoAxQE4UUoPWNFokbqsaZy318wTY/XMrA0j1SGacN+Py+hgmi/SYAF5ExUiemEn0B+2ZBXENQHGHF67T3VsaApohFlnXHdkA2CikONB5ia8dUnK1b76lnHQoRGzt+MVjZ3dPGHwB1597t+iSWh/Y4LmnjlYMMK4l48ZQiZqjx4ZNBkzmGSKfZBoGESGAhDYts1d3rSP72EAKrpOPirp0CWBuhMTH5wHYBOlVOYLfSUljPvDcgVvokG5qEl8vfdvI5ENlRPHHGwK9Hrz3l3tESJ/U25AKC7HYnFuHbLiWuByzXp5PJi+FGo4zlfHbiPSglr67mNSFyXOC/5CNMZykCpbOm51JSXBnmIxxwMW1CIO8cvihNshwWWruURZmGCqBZgXse4WLipvFBcCM4jxfdAKs4ONTNJKqquq+1g1Oz72gh2swYHEIMfXGUKvk+5INUlFwHOe7AOKYbvxqP5pVImMfGCmwudfUvCNgU/JfXAbEM3YAkednonYDUY8ixASmyRuBMJMAmsy9pVQwX/wSVcuXuEgzfHAZEE9bFWSHWSYoGTpde5F7sO9Bw8t01qEZsQJ6gVMUfguY1huIXbqcsc0oBVD7A+4IBgNlief6f6q+WBbN
 yBZlbETp
 Vh1CF9itXFFyJyR8REddLlq6QWaqvPvRhnUJV7XT83Buzos+BJyZi3ZbcWyqLPIlPhRyZiikfz6EmCfI+wLK5X9hEX5ukWLEqc0rQm71iIn3NYCoMAFhCDF7H3OLhSUjkMUrLR8lrLiwud8TwR8Aksx90eZIEUVFAM5C2XleUsLvpMTnAfDiBKAkb6QcuKxqWYcJ/8zX1sVe7altF3gLraI73N5QYkpXWKdyt/hsMaViCF3irySO6IhPDT/97wJd14wqTLQnn2qCPMyDFgFIdLvfHaY4iD2qt46m9rXiym1E/33T8Nvtqf8bJg6hhsrT6Iv/Q7PUrqsVnhfA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 10:04, Kefeng Wang wrote:
> Replace the last user of PageTransCompound() by PageCompound in ksm,
> and get rid of PageTransCompound().
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  include/linux/page-flags.h | 14 --------------
>  mm/ksm.c                   |  2 +-
>  2 files changed, 1 insertion(+), 15 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 7223f6f4e2b4..7a863572adce 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -879,20 +879,6 @@ FOLIO_FLAG_FALSE(partially_mapped)
>  
>  #define PG_head_mask ((1UL << PG_head))
>  
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -/*
> - * PageTransCompound returns true for both transparent huge pages
> - * and hugetlbfs pages, so it should only be called when it's known
> - * that hugetlbfs pages aren't involved.
> - */
> -static inline int PageTransCompound(const struct page *page)
> -{
> -	return PageCompound(page);
> -}
> -#else
> -TESTPAGEFLAG_FALSE(TransCompound, transcompound)
> -#endif
> -
>  #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
>  /*
>   * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 7d5b76478f0b..75db9ecebdc9 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2341,7 +2341,7 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
>  		 * afterwards, the reference count will be correct and
>  		 * split_huge_page should succeed.
>  		 */
> -		split = PageTransCompound(page)
> +		split = PageCompound(page)
>  			&& compound_head(page) == compound_head(tree_page);
>  		put_page(tree_page);
>  		if (kfolio) {

Nice, but ...

we already have

	struct folio *folio = page_folio(page);

And we know that we work on folios.

So can't we just work on folios?
diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..41ab25aa2a82 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2327,23 +2327,24 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
        tree_rmap_item =
                unstable_tree_search_insert(rmap_item, page, &tree_page);
        if (tree_rmap_item) {
+               struct folio *tree_folio;
                bool split;
 
                kfolio = try_to_merge_two_pages(rmap_item, page,
                                                tree_rmap_item, tree_page);
+               tree_folio = page_folio(tree_page);
                /*
-                * If both pages we tried to merge belong to the same compound
-                * page, then we actually ended up increasing the reference
-                * count of the same compound page twice, and split_huge_page
-                * failed.
+                * If both pages we tried to merge belong to the same (large)
+                * folio, then we actually ended up increasing the reference
+                * count of the same folio twice, and split_huge_page failed.
+                *
                 * Here we set a flag if that happened, and we use it later to
-                * try split_huge_page again. Since we call put_page right
+                * try split_huge_page again. Since we call folio_put() right
                 * afterwards, the reference count will be correct and
                 * split_huge_page should succeed.
                 */
-               split = PageTransCompound(page)
-                       && compound_head(page) == compound_head(tree_page);
-               put_page(tree_page);
+               split = folio == tree_folio;
+               folio_put(tree_folio);
                if (kfolio) {
                        /*
                         * The pages were successfully merged: insert new



I'd assume we don't need a check for folio_test_large(). We'd have to double check whether
folio is still valid after try_to_merge_two_pages() succeeded, or whether we have to re-fetch it.

-- 
Cheers,

David

