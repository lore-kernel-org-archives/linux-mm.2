Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64496606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 15:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KNa1MpD3
Received: by kanga.kvack.org (Postfix)
	id 740C96B05B9; Thu, 12 Nov 2026 10:01:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CAC26B05BA; Thu, 12 Nov 2026 10:01:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9AE6B05BB; Thu, 12 Nov 2026 10:01:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 255026B05B9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:01:08 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3D0BA022A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:01:05 +0000 (UTC)
X-FDA: 85426779690.26.1458A5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 06F6914000E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:01:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KNa1MpD3;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794495664;
	b=l36LEC+OuXHGPlXPjRbr6/C3vbi89XBJj5tha9dPPgA9zcURD+5KW93MBsu0RJp5bmUTQq
	6ooDl5Wc+vYn22kCQZftnbSRshrHDiVHYCXBu3RGSHLkcHFPv1HeHbDkvfVeAC1NNiSAGo
	Fb9gfefG9rzTb5CyqafrqqRguXWqzyM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KNa1MpD3;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794495664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XWzzX2bCOjZE8Fke1tFaOhIuXhTbcbQFXwLZVTqEnEI=;
	b=0L3/IbFNu6Y9x8/GyewmTcvUTIahVOzMBDlAGPVkxYL3QGlM0Btasky60B5kz6bihZ0hoZ
	zD6ZNBztK5jjbISbP4kaYAzq8jjYlT/s9eg1USFu92ZgGagsbO/VC3kuA1cozv/C66dqgj
	R+wfJE5JWNuvDDqJA9a8nhLu5BQuYek=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3472441992;
	Thu, 12 Nov 2026 15:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360271F00A05;
	Thu, 12 Nov 2026 15:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794495663;
	bh=XWzzX2bCOjZE8Fke1tFaOhIuXhTbcbQFXwLZVTqEnEI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KNa1MpD330l3EWuySCHcUKGnIZC0ND/ubfob28E/jJ0ZXddKGwz7qZFjYFVe22jUO
	 fr1EGuZJOR11VLiJeZCKyr/jgX1FLWAmaxqHVwdYDJUQFAawUKkmpcc7we+wk1viR0
	 2L5yLmYZ0oPbeMCOeutt7KS+GBToJ8lh7VmWi0m/nSh37iimn818iZn5MRFjTrV7/W
	 JBlv43bsdj08e2nohFZMOaGYvY3MD101tc0A4LRMEM6dsvEaDmSsu4CRQgPG87CFyi
	 Bo1eFHvgTGblFg/uCDkdRlIF+G3280cgX6v+zdTQPXov6TGxxq9LNAF9cQd0PYd5gJ
	 o7Hw/ecXuTd2g==
Message-ID: <76157846-e30e-46b0-b767-0902e3f8c82a@kernel.org>
Date: Thu, 12 Nov 2026 16:00:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slab: remove outdated comment in
 create_kmalloc_caches()
Content-Language: en-US
To: Sang-Heon Jeon <ekffu200098@gmail.com>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Hao Li <hao.li@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Roman Gushchin <roman.gushchin@linux.dev>
References: <20261112144653.840367-1-ekffu200098@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261112144653.840367-1-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 06F6914000E
X-Stat-Signature: ex39dyho6xb7gfrwjyhgmpp7x7ywgzfc
X-Rspam-User: 
X-HE-Tag: 1794495663-929457
X-HE-Meta: U2FsdGVkX1+rnTrKrfZCbnK/CUgvweO9gPzreqKinxnMrDL6/iJ4l4Td+KHaKlwQi5RELdOBT3PO1oBNuEyDggYHEX9eP+8ceLWIzZEH58lw7heFjEqqUZ7ey0YHrbzqEH7PO4f1foR6VVKy+7zwQED70V9kjnRFx/1RpNo3efE3bHaL9nwGZlIR3Wjalclh4sLCvIKtr1k48KwlTczzEB8JbTmdE8IcjTW+rPA7CdOREjxeMMj022IZcmvoxvQCpdxbLPpJS5nP2RsCr55d5uIYjg9kYhJDKkhtN2lvTNbFgI5eu/QIRwa0NoA7SsQfawKBI6zhjkmcJf5d1PT6bBQec5swabzxRqrr7ZVC22CSA1HTPGng4XwuHZfl1k6tTjUfsQFPhoSANC1pCtdL756lELZ6GTJVz/iAqp1L1k71MjLbRmepPrKsG+d2EYODEYJKkHgyWv9adyLhKqdB+ApFELwqGQ97hdiE40QXrjTnDdFvddCNumstsEFVanJ37+JAj8f4pVYVSjO5O4rbPgODAbw/Z9V3R3QcPWi3De0eJzVzkce/VP+X07LzbiKcc7ZPuGUK+VpDGZ7rZqJai0baatvNjZjULdx/cZQdQgFQIayY/Ozjz1qMDrLoxvhYnFRGN+YCkdYD2coxsdYBua09zBRxzyxjufOEb6dj6+AbsIXS/H2eGDB6WRUBtEkQFPf0jC+c2ZvCifDoJYpBIisLINLq1YtamCdeRgZ1kJFIaYUqUknBGklQiZzWOV6oIA4XYpaO/+DKXbaqVfKyusBZtp3W8V4Sb9Mk8vhspvcs1di9gITa92T/LNwxd0HYdDV8AYqMWAubixow3Ee0XRmGOG6X/xoKZemYcnWhD1EgZ4l2pDojlBkJFhyU2TPOuwx/dCzD+ukqpoaUWDJnmMNrvJmyQocQuqg5JystJrMLap37sKcBEMwRRb+u09QriglyXZR6W4peQMuuF8B
 lrua+Sgd
 xVq4GWcoKa4DDZBznVmh4hfVlWBjHTAmEpKLy2WW5umNjm5cF0GekU+FrrFs3CEDlbb3X0k90UhybUcSfDI8X8YVxiYq+7XrU1LojTz1NY3EMT1WgkItUi7ZpTwPj7DttRtF+tfod0DZDEn+2aAcKgxhRALV6Xl5O3r04G/xxxOJoHAJaDOnluARKiyI0nSr012Suq2EEy9BY4ej9cWj+uh8xpWBjZBC310T1hO1C/MHAszxLfBNDwUH/zLu1Y77/+p4sEVf2lqx+HwL18VuXxl2w3lGCTrIw7KDdAQsCMgZzTi+4yOjigfq8YVgtHxl3JWbzzXdZ8tVF9RN9mFpQom1kYV5yu2lcNUa1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 15:46, Sang-Heon Jeon wrote:
> Since commit 16a1d968358a ("mm/slab: remove mm/slab.c and slab_def.h")
> removed SLAB, no kmalloc cache is created before create_kmalloc_caches().
> 
> So remove the outdated and redundant comment.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
> Changes from v1 [1]
> - Remove the whole useless comment
> 
> [1] https://lore.kernel.org/all/20261104144753.2266231-1-ekffu200098@gmail.com/
> 
> ---
>  mm/slab_common.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 01c64ef661e7..10603b9cbb53 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1028,11 +1028,6 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
>  		kmalloc_caches[type][idx] = kmalloc_caches[type][aligned_idx];
>  }
>  
> -/*
> - * Create the kmalloc array. Some of the regular kmalloc arrays
> - * may already have been created because they were needed to
> - * enable allocations for slab creation.
> - */
>  void __init create_kmalloc_caches(void)
>  {
>  	int i;
> 
> base-commit: ce6518e61e3b4bf4f97f7ac6204049b9eba7eb75


