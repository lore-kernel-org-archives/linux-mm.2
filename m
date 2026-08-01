Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3A55C54FCD
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 09:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9BEF6B0088; Sat,  1 Aug 2026 05:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4C816B008A; Sat,  1 Aug 2026 05:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62366B0092; Sat,  1 Aug 2026 05:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 942CC6B0088
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 05:39:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26D62A0294
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 09:39:04 +0000 (UTC)
X-FDA: 85052201808.13.D5797D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9DDB4120002
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 09:39:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DY4rkb5d;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785577142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NxA8VWrunDgS1luoqRhJB3bAyaoBECbm4t0+Dmg1kEE=;
	b=QLt3Vbd0b5vLIoRJ03XDova9iOpOGvR33nWwxkefGXIeCahcTXPDn8gGOoIqEg8+ZnfF+W
	0yLnzFO0Y0ZUklQuVzN2kQkXaYVb3tSlkXdlI+orl0ehD8Rmky0sJet+R5vTyrPew+5QSW
	+81yTwR1uDe450txVHRDElvDJZUw7T4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785577142;
	b=5TuIedLIQkhf0xPVrfWZ7Xm1a6I0l40wqb5Z3719QWbNf8k/zyeDnuIQWLdGE5lN1LIqg8
	Kw2hkdL9csBswOmfWFwtMaplUZ0BzAKle5A/lnanzJxv/FiS9GJlWd264/UgZErbktYy3M
	lu/NahvJwBFBy1Sb6rErs+ed3Ok62is=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DY4rkb5d;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DFE8600D8;
	Sat,  1 Aug 2026 09:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3737D1F00AC4;
	Sat,  1 Aug 2026 09:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785577140;
	bh=NxA8VWrunDgS1luoqRhJB3bAyaoBECbm4t0+Dmg1kEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DY4rkb5d8EEpTxyH4OY81TtCvtKiSxqCnP8vJQM+E9mOCrfgxUEGj0pIoJ2rd+8xl
	 FGpETVcJE26MQ3qzJX98cGzMsxfSBBy82qIAjvd34hZeuUuf2DyCODN1bDWi1VkxsQ
	 FiUWBZwdFGI7Tp44jAPLUu/O3tRPDNHnHjKMs8nyAq6YKwY7sXy1goZ2ppHkz5spZd
	 BpvOOtuFX9yJ+wCmadUBzu0vqkRqT9jTI9roOs1bCWIpAyoLYn+w/zvYKwNBXrKEdr
	 qbPyMy8VNC/VFgM+ixhVelOxvZ4ggZVIddLCZQSTcV24F7PjyQ6mn5nREkuhFwGDsI
	 IjV3QWiaDba3Q==
Date: Sat, 1 Aug 2026 10:38:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	William Kucharski <william.kucharski@oracle.com>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v2 2/2] xarray: honor XA_FLAGS_ACCOUNT in
 xas_split_alloc()
Message-ID: <am2-HmShC6VXP_-G@lucifer>
References: <20260730-add-gfp_account-to-xas_split_alloc-v2-0-5a56c2361d85@nvidia.com>
 <20260730-add-gfp_account-to-xas_split_alloc-v2-2-5a56c2361d85@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-add-gfp_account-to-xas_split_alloc-v2-2-5a56c2361d85@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9DDB4120002
X-Stat-Signature: jytnhc65ussxhgstcdm5gasx7nnb5uat
X-HE-Tag: 1785577142-95649
X-HE-Meta: U2FsdGVkX19KGiTyuHW+nPVF3GNUt6tXIJca+Ouwo9XA4rBVtf8Hj8yhGHTpzeitXX+6dFN6h0BvS5sLJULdbVRkzNL6FUdwO0nN/VoDaCE1Hw7yikzjHi0EOTPRrBhxmVCQ+gt4seMqZsjZO6f0ahEWsjm9TrsNLUvVHrEsOXNOQt2WHlJJ7JDN5wJNxR8dr5KfDiOow7x3AM68i+quZ78hw0jUAfRs7aD9pAQ1HmWGeFyyYQjcW+UNAJfgyuz8sG0XV0p1dXyWWAy3KON2CgkxE9RWm8ueqV2lWC7fLy56D9nCwHJN9+g2fYfZIONdB9xjpJQcgB+TmjvtaNmPAo7WnJ6zv9w2RTlaIdjwlRmyJJ/1RZJiZwWIoghtpuU467kG+W5gtoOeStqEXbg/tlc/jIv2qfq81wBbszuGvjPxAd+cyO5AvPg0/uflAkjL0XNZQSKquhXvdyAQPgSEH6o5njMj5hpyLhu5q6H/Z4IXUWy/YoCco04k7Sq734SUNgF3BGmaFCKDd2LfM9wr+g5jk/sav93Gdg5zlDmSon1QFMT8jkaH9Nl5oC/9hcnAywk0oqR2uUaDK3AdWdiy6qY985apTe0KCvuBvZBmgKUZA8GiQ8TsmWdjiwcLSGLsGljn3OOx9ULcej/aGQl/4kZzbnQ4SEo6mekz5HRCzMMNie90aWtTJrAlNdx5mzI7/6dt9NFQWcUu8R/uN1KnyibL/2fdZQ1KNDymFYi7Bc9cdLsRtrzsXbVYQPglzvuhPcbtHx1EE939ajsRmyyt/9O4suqVW1gXfv2zGrF6GkcCvbC2b8XOLCyrw6WxUj3UX6FiJCdScaZJInxaDb6lHgAl9QfJJjc6FY7Hs/LxOzSQoedQ+Y2VbcQPxm1c1O2ZKon6UCXFfzrU1HY5iq9I7LJb44BIXbT0bcKDGO4kRo4vije5eNY6Opt1BdIPHW5jRHtmlydg6qE66A5FyEb
 OWQ7gkeh
 OUojYMAsAuP8KlYrlOrwo9IqSX2w0RQ80otBE7/GmZdCmsWu2KeIHfBKEzYr5JvtbmWI7f4cxzmFCfmCVVk2835/zZ/db1Iag0xjQq6fjNIwRcdkPj5wJyuktqwqtx1WjvbWqhXUhwUQo5cXT/kljI6+TA8JaqKt3cJBsqJSCzI3cZusLFpndg9Ow5bxSVWHK+XxdjWwmBq4dGKtFLTefxJQ2MhjofhXgZA/tgbqvvW1bqu7MR3qJvwTzTJa39W+xpuXZSMAU1n1Mkp+8IuI/NkuVA8skyS/BtSqSHZsV4agYkXvW4M8Up7oS0+BGYBhFBsNSUuSE6tvdllWYRkHvM7Rf6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 10:18:01PM -0400, Zi Yan wrote:
> XArray operations that allocate xa_nodes, such as xas_nomem() and
> xas_alloc(), add __GFP_ACCOUNT when the array has XA_FLAGS_ACCOUNT set.
> This charges the allocated memory and avoids the workingset convergence
> issue described by commit 7b785645e8f13 ("mm: fix page cache convergence
> regression").
>
> xas_split_alloc() does not have that flag. Add it when necessary.

Nit but maybe 'split' rather than 'have'?

>
> Fixes: 6b24ca4a1a8d4 ("mm: Use multi-index entries in the page cache")

Cc: stable?

> Signed-off-by: Zi Yan <ziy@nvidia.com>

Makes sense to me so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  lib/xarray.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/lib/xarray.c b/lib/xarray.c
> index 9a8b4916540cf..bfe7bef80f34e 100644
> --- a/lib/xarray.c
> +++ b/lib/xarray.c
> @@ -1053,6 +1053,9 @@ void xas_split_alloc(struct xa_state *xas, void *entry, unsigned int order,
>  	if (xas->xa_shift + XA_CHUNK_SHIFT > order)
>  		return;
>
> +	if (xas->xa->xa_flags & XA_FLAGS_ACCOUNT)
> +		gfp |= __GFP_ACCOUNT;
> +

This is some confluence of flags :) I wonder if there are other places we've
missed setting this for?

>  	do {
>  		struct xa_node *node;
>
>
> --
> 2.53.0
>

--
Cheers, Lorenzo

