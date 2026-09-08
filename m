Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 048B2C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5EE56B00AE; Tue,  8 Sep 2026 05:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E36466B00AF; Tue,  8 Sep 2026 05:25:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4BE56B00B0; Tue,  8 Sep 2026 05:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5CDA6B00AE
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:25:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 248A8120493
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:25:17 +0000 (UTC)
X-FDA: 85190061474.15.348A47B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 86E671C0006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:25:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788859515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xSUgEO40+LVys6KHVmHOISeD86KTk3zQOu9LwBA3BY8=;
	b=AGDGWYMAjylgMWWMvwDrA4Vl44A03vArCTv11ZeQz3nMue3lrzyZIcte5CVwjVqUBTME6/
	GLqhgS+u/mdFFguL5SH4QxlO0jb12p/5YAgu0QWsTuJSZ/Gj7CY7SJS4RmYAaYjg78lnOM
	Gk/m7M0YFOMkY1Vpmd3ww92rHkjwYRQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788859515;
	b=BheFZgnKFYnA3XgbFa6kYf4FnqOJhXnIe9LdwuSqFEzr/5ynwvA16Tw6qmUVKN/oE79uaG
	VuKTd5OaPtXD8RcV9j+U9LUVy1HZ+743rLk/jBslSJgHfYiHiMBej+aan8Pr78DQ/3T4DE
	4r+VZReLl4ivfZTeT/HsWamxfq/OE/4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1874E60A97;
	Tue,  8 Sep 2026 09:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5F51F00A3F;
	Tue,  8 Sep 2026 09:25:10 +0000 (UTC)
Date: Tue, 8 Sep 2026 10:25:07 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	hannes@cmpxchg.org, usama.arif@linux.dev, lance.yang@linux.dev, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, kasong@tencent.com, hughd@google.com, 
	balbirs@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH] mm/huge_memory: add folio_reset_partially_mapped()
Message-ID: <ap_Tjt5vxal-B8DP@gremlin>
References: <20260907183340.1446132-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907183340.1446132-1-kirill@shutemov.name>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 86E671C0006
X-Stat-Signature: c9a3d6y3s6r4fd4zu6ujc9r4ta9una9q
X-Rspam-User: 
X-HE-Tag: 1788859515-824705
X-HE-Meta: U2FsdGVkX1/gkcojOR1jjtaDL0CE31ZNFUxdYd8a4Rb7Cp5HRDhYERdCzky+BEe6VgCN3LyrGxhY8hfve7mSOYS6DB4d6F7edwCGLbL0QTTqRLWlj3S6B7xNZ5+l73QUGB812A1JmSuc5EQ4GqchoC9VTtp9rrHliU+zDxwS9khZIqPKTckE65JWEGbNsaQIMRhTmnhdAUd+BncHwqDcXymEVKlwx8oUeN5Jp9bguj8PToPhyGY+s8nOqai/KVz3pdFLA1hR7nsBtvytDo9SjTvAQjmUiMr+CE4+WhoY04vbEEi50lDQXeGXpSuVBJaJhzRm7PnAJ5sz3McFxEWuxHqYEywk3RKvAXY5BH6QX3sN+TtksLRpjrZBTVT6I0bLKq1l1kTb27lGI/UrZ6z/Wd0RvEweontT0sCmFKnxiBwF7RX/4itETtBz1qgX28ksXgSt5xS4QFlmEKDsctN2d9NF9vH3lrlAJXr9OwVWSvACDrIhiepKMz/tqemZQXhc6z12FMnCL71OLbLuRNPSfGBwynMNjrszWhqUwW7nVQgNDJ842W7dMc/dOtlcCvTq7myR+xGTKplq74Sa7876fNGG7drHUd1QhL/N9sXXh/ipvn9FSkwH7zgIKyRQi3+GrQjwk710LWExCAiBkI7ds5eGYGLqmtHnce05cIAdLL7ByB6+6BBO0nQqkNGC+aSoQX+g4yZ/2BoAX8OnJ2CDYKtLGPGJO6ophl9gj+gUrsv731W70gldGtN5goTQ4l6y2ZB7d93vX4wHvclmd5+qT+12egJMSuN5OObygE28IUTwEutn5zB+YL4TWmhGfyQqoM1e3Z5xotENlLIZ5IGfbFPKqNAYFZa4SBmUDFFc9U73nyhr8n/lcLTBdtduVY5gab8MKydaxcxzc+2qRz8q9+u5hfEQL7H7QCFSaruZ/By4g22Mg5HMJey79TnqD5sPghAa8CsEwihWASe0+LQ
 yLSo0Agd
 IUG7rsxuTotk5O+P2tTYXJ3CMG+pUngNfZi7cjWnHnqCjJ2waHEY2UkjeDAzVL2NLqL2XvTJqAJ0ORBLrnNJg0S7I3iHKPvcRycy0t73aXbZC8wKfcdEHzez/xlrH3MU6Xusp2ZdK2mTDIrt2DE6LGbRyxiY3GQm3Cbtj4K8PLydO8sUzbhWGMfZqyFrbbwimPv6ag29jarfzb5mQANq8mQfR5FS74h9qcfms9HiLasMLztOzKnR0JGULsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 07:33:40PM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> __folio_unqueue_deferred_split() and __folio_freeze_and_split_unmapped()
> both clear PG_partially_mapped and take the folio out of
> MTHP_STAT_NR_ANON_PARTIALLY_MAPPED with the same five lines.
>
> Move the block into folio_reset_partially_mapped() and call it from both
> places.
>
> The helper asserts what both callers rely on: the folio is frozen, so
> deferred_split_folio() cannot set the flag again under it, and the folio
> is already off the deferred split queue. The list check sits behind the
> flag test because order-1 folios have no _deferred_list.
>
> folio_order() is safe to use at this point in the split process: it
> still shows the pre-split order.
>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Assisted-by: Claude-Code:claude-fable-5-1

Note that policy has changed on Assisted-by tags so this should be:

Assisted-by: LLM

https://docs.kernel.org/process/coding-assistants.html

> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

One nit above and below, with those addressed LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/huge_memory.c | 31 ++++++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 11 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index dd66c6ad5af1..23ef22c2b5db 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3972,6 +3972,24 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
>  	return folio_nr_pages(folio);
>  }
>
> +static void folio_reset_partially_mapped(struct folio *folio)
> +{
> +	VM_WARN_ON_FOLIO(folio_ref_count(folio), folio);

NIT: I wonder if we could have a folio_is_frozen() that'd make this
self-documenting? As trivial as it'd be :)

If not, then a comment like:

	/* Folio must be frozen. */

Would be helpful.

> +
> +	if (!folio_test_partially_mapped(folio))
> +		return;
> +
> +	/*
> +	 * Order-1 folios have no _deferred_list. The flag is only ever set
> +	 * on folios that do, so the list can be checked after the flag.
> +	 */
> +	VM_WARN_ON_FOLIO(!list_empty(&folio->_deferred_list), folio);
> +
> +	folio_clear_partially_mapped(folio);
> +	mod_mthp_stat(folio_order(folio),
> +		      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> +}
> +
>  static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
>  					     struct page *split_at, struct xa_state *xas,
>  					     struct address_space *mapping, bool do_lru,
> @@ -3980,7 +3998,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  {
>  	struct folio *end_folio = folio_next(folio);
>  	struct folio *new_folio, *next;
> -	int old_order = folio_order(folio);
>  	int ret = 0;
>
>  	VM_WARN_ON_ONCE(!mapping && end);
> @@ -3998,11 +4015,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  		 * leaves PG_partially_mapped set.
>  		 * Clear it here: the flag does not survive the split.
>  		 */
> -		if (folio_test_partially_mapped(folio)) {
> -			folio_clear_partially_mapped(folio);
> -			mod_mthp_stat(old_order,
> -				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> -		}
> +		folio_reset_partially_mapped(folio);
>
>  		if (mapping) {
>  			int nr = folio_nr_pages(folio);
> @@ -4516,11 +4529,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
>  	memcg = folio_memcg(folio);
>  	lru = list_lru_lock_irqsave(&deferred_split_lru, nid, &memcg, &flags);
>  	if (__list_lru_del(&deferred_split_lru, lru, &folio->_deferred_list, nid)) {
> -		if (folio_test_partially_mapped(folio)) {
> -			folio_clear_partially_mapped(folio);
> -			mod_mthp_stat(folio_order(folio),
> -				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> -		}
> +		folio_reset_partially_mapped(folio);

Nice bit of red :)

>  		unqueued = true;
>  	}
>  	list_lru_unlock_irqrestore(lru, &flags);
>
> base-commit: e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4
> --
> 2.54.0
>

--
Cheers, Lorenzo

