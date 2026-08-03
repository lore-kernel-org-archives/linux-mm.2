Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 763DEC55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 22:06:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6B896B007B; Mon,  3 Aug 2026 18:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D43506B0088; Mon,  3 Aug 2026 18:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7FF96B008A; Mon,  3 Aug 2026 18:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BDBB6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:06:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1AAC58082E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:06:50 +0000 (UTC)
X-FDA: 85061343780.16.ED8FD5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5281140007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:06:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MQd1VvHk;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785794808;
	b=4T5tooAAUeGh+7lvE8zoabMVRRgPjIXDZpXlPzsYQgynWGG8aVVzGqGss7d1SThWtt8kkP
	WRBB0FD40SAR3OljhaENvkm0q8h2bBPSwnzlfDg9JrtWyBvF2KaQrqgIxLtoHcp9nI6eDO
	DpyZ+bP3PSgTjNUJ8HCUjVrsJFtSveA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MQd1VvHk;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785794808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRJdUMyhX0PzJBnxRWEvMZdbGSumUGTes3rU+AOWdN4=;
	b=xMhBqr9gWF/grNadi8XkyWcrYJRXrXvBqWxBO9sI1dGbWU0z4FygwR780WYxzyc6RL71XS
	4c5y2JJnnLanfGKnfsqDKNcbvn7Gz8/oqvMuNU8OtU9sScFQABWMH7O+O84mDzVIzcy7JI
	+ThpZWwkrqH+2LDMxmE0p2Wr1t3DqqA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C7B14145E;
	Mon,  3 Aug 2026 22:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0113C1F000E9;
	Mon,  3 Aug 2026 22:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785794807;
	bh=uRJdUMyhX0PzJBnxRWEvMZdbGSumUGTes3rU+AOWdN4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MQd1VvHko4+awaL0IxEWMNfsFnlHJayCptEKysDdY9mkMl6SKPPuxgXIlT7CYqtHb
	 Q0VNqwwbA/rL/I1Wec8S3NhZ1IDLIaeNallTWV5vsVVsbIRaLyDRtvVnY9FI2JNkpA
	 MXNDjhDj7k8qZFO/7jzLd29stMJtz039PWzPUB1w=
Date: Mon, 3 Aug 2026 15:06:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dayou5941@163.com
Cc: linmiaohe@huawei.com, nao.horiguchi@gmail.com, linux-mm@kvack.org,
 liyouhong <liyouhong@kylinos.cn>
Subject: Re: [PATCH] mm/memory-failure: fix refcount leak on soft-offline
 LBS folio
Message-Id: <20260803150646.6af05f00288dfec3b9c4b8bf@linux-foundation.org>
In-Reply-To: <20260803060001.800638-1-dayou5941@163.com>
References: <20260803060001.800638-1-dayou5941@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5281140007
X-Stat-Signature: taf9tgc6qfut3m46rqqkiwsc6ypx3zfo
X-Rspam-User: 
X-HE-Tag: 1785794808-543185
X-HE-Meta: U2FsdGVkX1993A16RmC3nmlaFf8BDslaJotm6afb8zuJG5DQNT3Ve5J95B3ub+8Y873Lc8Hh9zSeIzfRFf2DIzzN5lvnau7Kt1BsTzBUp1S+5qTiJZSBQ8BFLr7sBx/EZNy127/3LVnPZ1ZWxXUQiSzWZsT6lIQkxeJKoZsSWN1FpoMbfywbUakdg4GYqlbEJwsV9P34z3x50oKG1q6+eVQp9rmrdLfBKFSNz3nvig5nTLzXHBmU9e5+lRqHk+CRPtzzHptVWYdo97x/qb8JekknyN94nDsiZPpGtLhNrS/uLqGqlvCW1WuzjO+b+JaGcRZlgH3loHiZ3ZIP0cwDhGxvXddMiYy8MqtK4v/NIjmNrn2AJjri6eU1GQfFBvBqmrUgLAWGuyw49m8rrlLyoQU/4IYIPST7/E+ccy3nNfUDpeVKKeRW5P9ymbFHMPffBegEZMLQdIgPtzYmtWnkWIyWiaXe9Ulj+8KHIU6NnJYDhoei16cF1L+sWo4zRT8pgxWMhKz5kLv7tIrt0nMChVGl4n78qyykLYHklVkcdtTTSXyzfC/C/LsHM3TobV1FzUtvnmFrTx3mLnBI1fWf/jGS0n+w91s/SKbfk/q8M7QZfYpAUmNxXXhtlzN1Qsfri4uf0QcW7lXopFrSSMOSS3g+mNGsAGmUxOhzKwOekDorth45EMM+9TbXRoRjH0grSKgTy/OMF9D+59UIp/us+w90NPfRPLBAt8dsk3Zp5op92WLE45BiwZaa9ockGfzGfCii4jzQSrNhGqylslOzeGwsxhVSH0On7jPdpWnb6FQpjJIefFKLPn15x6eKmxvcLV3/HSszX0EXJR69Rtxwub0qatDo0wRq91Kd82XtEYAjWvCmYrbwe/W6BMtmNx50fq0+/Ixtn94jbLrIDfLvdQHiESIYMEciHat7Xz76EQ+Kf60Hd18+Z1bWBs2uahcEnkq1mOX75qIabx2b+WL
 9hJYSTYg
 KjwZie6vp3BARDioumWwBTHCCLLbqIuua8bmYimFM09GlQncab9i/aKOIVz4goCNhD+vqgjl3VaUcqk43zDMPfkVcKIJqo4VYvIlgb9HImD1BHwSbBXAjIrXqIDDvNkM4VTUvzvEPanceuHKgIVPozZB6Tt9AkCk4EmPlYwpKumG45X0Q4IyTNKWhBUSNfcruGrHShCqEGaACcXjwNUjcIAYVKYxf0fQZQfH0GRzPXM7Y8OZOSikKEgIDPnb64LLs+0UhstN2BUGIacZCK+WN0YnpgJwsYopgMZgmrHhweI1LaVTD19F5NFDkqRLD6hrhZfpeCmA02MWDrFNmFvkN0nQ/21NnFgjYeABxzNUKX9ZXesuXpeh4LssqSh38It1HvNN5dFBJIzIutcTk3rpfSiRqww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  3 Aug 2026 14:00:01 +0800 dayou5941@163.com wrote:

> From: liyouhong <liyouhong@kylinos.cn>
> 
> soft_offline_in_use_page() runs with a folio reference taken by
> get_hwpoison_page() (or by the caller when MF_COUNT_INCREASED is set,
> e.g. madvise(MADV_SOFT_OFFLINE)).
> 
> made soft-offline skip splitting when min_order_for_split()

Something went wrong with this paragraph?

> is non-zero, so large-block-size folios stay intact.  That early
> return -EBUSY path never drops the reference.

So the effect is to leak a folio ref if min_order_for_split() returns
0.  Has this been known to happen in the real world?

It would be good to update soft_offline_in_use_page()'s introductory
comment to describe its folio refcount handling.

> The other failure path is fine: try_to_split_thp_page(..., release=true)
> puts the page when the split itself fails.  memory_failure() also puts
> explicitly on its analogous unsplit path.
> 
> Split the new_order != 0 case out and folio_put() before returning.
> 
> ...
>
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2801,9 +2801,19 @@ static int soft_offline_in_use_page(struct page *page)
>  		 * NOTE: if minimizing the number of soft offline pages is
>  		 * preferred, split it to non-zero new_order like it is done in
>  		 * memory_failure().
> +		 *
> +		 * Drop the ref from get_hwpoison_page()/MF_COUNT_INCREASED;
> +		 * try_to_split_thp_page(..., release=true) does that itself
> +		 * when the split fails.
>  		 */
> -		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
> -						       /* release= */ true)) {
> +		if (new_order) {
> +			pr_info("%#lx: order-%d folio cannot soft offline\n",
> +				pfn, new_order);
> +			folio_put(folio);
> +			return -EBUSY;
> +		}
> +		if (try_to_split_thp_page(page, /* new_order= */ 0,
> +					 /* release= */ true)) {
>  			pr_info("%#lx: thp split failed\n", pfn);
>  			return -EBUSY;
>  		}

Thanks, lgtm.

AI review might have found a couple of pre-existing issues in the
surrounding code.  From a quick read, it doesn't seem appropriate to
address either within the context of this change.

	https://sashiko.dev/#/patchset/20260803060001.800638-1-dayou5941@163.com



