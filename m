Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9058CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 12:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21BC38E0011; Wed, 17 Sep 2025 08:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CC928E0001; Wed, 17 Sep 2025 08:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E2358E0011; Wed, 17 Sep 2025 08:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF2CC8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:21:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A884C16051F
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:21:42 +0000 (UTC)
X-FDA: 83898653244.14.E048852
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id C578740006
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:21:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VOBQCHTU;
	spf=pass (imf12.hostedemail.com: domain of chengming.zhou@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758111701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rTrn1iL20oKG8cn8ZNNfsgW6d/NuD2OtCZO3XSRwbVI=;
	b=t70USLVJQlVRxfK1Lcnr8unZhUDH/+98J70eURW6nQZlx0ryQstnUxzE6DlNj2ukUDF21i
	pnqjLsi9e1iaFfVL4SUJDJxs6VRMD39Mic2gznuEPnuOF+6pOWJCeP8840iwU1lX511l4+
	LH9ymrBcqxph9NgubrgISCvnoiIpQ94=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VOBQCHTU;
	spf=pass (imf12.hostedemail.com: domain of chengming.zhou@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758111701; a=rsa-sha256;
	cv=none;
	b=o3SLyDOhfa29+ltqm/aHPZvacRLqffyYCZzppN53jaK4cMB/4cw64Nmc6gRJVqEXhMstP/
	U/lMenzKsQow2WLOu5L5YWREqZTdvZShB4sDLCaG8k+oo19f6DGhekoGkoFt/kM2Pyy3Qf
	5vg+ts/RhBF4S+dExiqKJS8rhphwhX4=
Message-ID: <3ee62dcf-c016-4da1-b93e-ca173654a7af@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758111698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rTrn1iL20oKG8cn8ZNNfsgW6d/NuD2OtCZO3XSRwbVI=;
	b=VOBQCHTUXuPBeS5z9yVNOlGH8Rrxhzvu662V0VhV9k69ucXL/Ur1IhvSZzkKNXhH4OH5la
	zW53X5Rav8OK8R0vj9MUxsDuYCzqTKn9M/qOIbpcJbgBJ1m3rYmK3cCBDE2OE7SO5K5orD
	IFG4Q8rt795RBfU+yLhwAr5kCYbWzuQ=
Date: Wed, 17 Sep 2025 20:21:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] ksm: Use a folio inside cmp_and_merge_page()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 akpm@linux-foundation.org, david@redhat.com, xu.xin16@zte.com.cn,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Longlong Xia <xialonglong@kylinos.cn>
References: <20250916080533.2385624-1-xialonglong@kylinos.cn>
 <20250916181219.2400258-1-willy@infradead.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Chengming Zhou <chengming.zhou@linux.dev>
In-Reply-To: <20250916181219.2400258-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C578740006
X-Stat-Signature: wffx98xh7mqkja3wgprb3tyxeop4tdxc
X-HE-Tag: 1758111700-185347
X-HE-Meta: U2FsdGVkX18MBHVWKhRlJW8BZIt50vNKu9IxDs8+7RrZNQ2RbS8+thvNOf4XZ98r4MWQ0U4UIsBl1v5GKT1/OjDYmruv9vVFE/sxkjrzTbOuBJT7nQS297m5HY3e+OK90K1vuKMoFON2r6w6M83rCd+qMLVWh3Ai01D7aF4UjpX/8MqTqYRbfLXUmYUoFaF5a9xU3bEJioaDOTGDEGVB9AqgXti5K63+OYO47dS2Wqzl952A3XdJ67WuleQ3w6cbygjt8WbuK5JLmDr9yRrxGcvPl7L74aRqm1zKCAQqLLQrvnLjj21F7MDTUw1ik0SNwWBAXw6FFImCFRLqw+ACJqoZLTb51MAOhuJRU7z+/vLNQC6myVtZ4cnWKdx2NSxrrYxNpXon1TWDxvDNGcq/vCf8UlDNCX5FJou9OOm57cetrqjPGaq+RU+88GWOKGi4QojXkBTJVLYzX7ins2aFf3Wu1nEkW67lOyrwafWHCs6Kx6tCaHaBDzNxv7oBCeY1HkGwweRz8boSf4IqzzRu2hg1CRWExsb9TlKaIJgH0OGU4ybskabeJSpJE9Q0N3quzb13/jVYx1zDsi1hL492W0FhaYXq1dSnJwsb3ISEZXZoxg/ftteYN9gTFUvDBzjFBgUHP6zOJTUht9ZLmohofNhMLe4PKsWkk+3OyAG/Os4/Xqn+4KzxSDcqHpEGk4vlavqEQ29jzHAR0cBTuWAtatctqlS2znWilSfSXfIpbC2YywdkWN3caa3WqZdF74BsZlwuJ2+tJu36Ij9ZFNGheBTFIVFWlNxmwO3lpVOJjvVqbawrczgETtCBwTc44VAdFz/PTv3ysSa1yt7Vm3TJ+iXpka9KFGJGk/XmpIQnSi6r8qbfUgbZH7+Yp0Nm9EjzUu6svRWcFtdziL8IEetMxcp9mBsBcHDjVz7G0sss8sJgrbP6M5Qm1Jxpiz+xwPODr/urQjhVRKcGrA4RDnX
 sl+XF6Ji
 cWHF0nfd5fw7Kr2dmgFrjsnYjXb9cG/OpcWG1TxovGUz0D40txZLoNMkslIRXQu32YMR/qaz6TxM1Jkc8D3M3yKs/Lj6ExNvpNWMZ5geW2rYF1sRI82YG0dnC03fV7H1GauQ/Baet1t7TQmscC5REk/2NPH38Ih4duTkFhUP8yleVrrnvnlwsQ9xWfU/djaVn2M0cvZ+/oYZGfISoa9CoEHz3hweu8X4zke0xScslvyopzNzIH919qFxNMdCVkjl9e70bFxt5e3CyOdvzAinD/nOCyo97Hq6MGkBHAF7s4/ZGDvz/OBjXmYqa5dAwPKR6HA8fO40rJ+vx5kFVzC3G6ht6Ljajb7QHnm5A/OJ6+2RvYTOF9+IxfnN/wtVAgJvBgrsE9d8qhXXlAgw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/9/17 02:11, Matthew Wilcox (Oracle) wrote:
> This removes the last call to page_stable_node(), so delete the
> wrapper.  It also removes a call to trylock_page() and saves a call to
> compound_head(), as well as removing a reference to folio->page.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>

Thanks.

> ---
>   mm/ksm.c | 15 ++++++---------
>   1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 8583fb91ef13..47655ca8f9a5 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -1057,11 +1057,6 @@ struct ksm_stable_node *folio_stable_node(const struct folio *folio)
>   	return folio_test_ksm(folio) ? folio_raw_mapping(folio) : NULL;
>   }
>   
> -static inline struct ksm_stable_node *page_stable_node(struct page *page)
> -{
> -	return folio_stable_node(page_folio(page));
> -}
> -
>   static inline void folio_set_stable_node(struct folio *folio,
>   					 struct ksm_stable_node *stable_node)
>   {
> @@ -2221,6 +2216,7 @@ static void stable_tree_append(struct ksm_rmap_item *rmap_item,
>    */
>   static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_item)
>   {
> +	struct folio *folio = page_folio(page);
>   	struct ksm_rmap_item *tree_rmap_item;
>   	struct page *tree_page = NULL;
>   	struct ksm_stable_node *stable_node;
> @@ -2229,7 +2225,7 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
>   	int err;
>   	bool max_page_sharing_bypass = false;
>   
> -	stable_node = page_stable_node(page);
> +	stable_node = folio_stable_node(folio);
>   	if (stable_node) {
>   		if (stable_node->head != &migrate_nodes &&
>   		    get_kpfn_nid(READ_ONCE(stable_node->kpfn)) !=
> @@ -2268,7 +2264,7 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
>   
>   	/* Start by searching for the folio in the stable tree */
>   	kfolio = stable_tree_search(page);
> -	if (&kfolio->page == page && rmap_item->head == stable_node) {
> +	if (kfolio == folio && rmap_item->head == stable_node) {
>   		folio_put(kfolio);
>   		return;
>   	}
> @@ -2349,10 +2345,11 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
>   			 * the page is locked, it is better to skip it and
>   			 * perhaps try again later.
>   			 */
> -			if (!trylock_page(page))
> +			if (!folio_trylock(folio))
>   				return;
>   			split_huge_page(page);
> -			unlock_page(page);
> +			folio = page_folio(page);
> +			folio_unlock(folio);
>   		}
>   	}
>   }

