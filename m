Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD0E9CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 12:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 880AC6B0005; Wed, 17 Jun 2026 08:19:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 832906B0088; Wed, 17 Jun 2026 08:19:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FACB6B008C; Wed, 17 Jun 2026 08:19:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A61B6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:19:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A614E1203B5
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:19:46 +0000 (UTC)
X-FDA: 84889310772.13.48B1A62
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C2AF710000C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:19:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jB1V4jU1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781698784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36dwFZxBM2Mvs9Ysq17fBYZA5ElHiSQOeMD61I0SgP8=;
	b=PNaH4xqBrQvNf76fXsW8KvCX3RfodZ4615NQW9PzpV03HBfTp5FlkCWJk/eV6tOWFcZ650
	ohDYnRwiPh+Hm5DtaRyDWi3cAHP1ZkXI+LvzK49ojMJKumBhJxPqHnk1US/KGSwK4V/PSS
	m9F5YUoD/Aason7nOMsLQ22gyAOSSKc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jB1V4jU1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781698784;
	b=UfGmKZm7LYwEnNEI6DhfjIHvYtiJwkfFGvWoRM30FCEsGgveDjBXMxlQkN+od2tJ8KyK5K
	xEiOye1TQxYIMijhnsHJ298NRuhyIiByOoVNS/hSsWDEB4lbO7Y9ObPRPBH5fhANVPwTVg
	I/pWe0g93jk/0M4IMzaYbWtLAEnLiTQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D0666001D;
	Wed, 17 Jun 2026 12:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441C81F000E9;
	Wed, 17 Jun 2026 12:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781698784;
	bh=36dwFZxBM2Mvs9Ysq17fBYZA5ElHiSQOeMD61I0SgP8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jB1V4jU1lUYP3KvbH/Mzbj6NniqX2MC9cIu2RXWR28+Yj2yGrrfQntXLFmrsDodba
	 jHC/koUFMYVj1aQMOouElyHbMSUxDdm06SKVQbReL9o1Jxk5PDzA9whZhZA8XBH+Eu
	 5IDT8fEgNKSRq6jpjJrQOXzXL9Qu9ndMdArLmXoAWHtT4jEXCE/N8D9dQ9wmSyKfdp
	 xU4WEzsNMepapnsgUNzkn5TfAuA+QwDev93oFOkBXBCUGSdp+bBhVWDQA/WtdL/jvI
	 Gbq4NymcjjbDz0IfKDSCdjr7gbw7wWCo3xq+q5rIXMJqe3DsGILnTwKgImjWRVijad
	 FUZZenIcKFlbg==
Message-ID: <5c665b98-088a-401f-aab8-7c9c4d4f484d@kernel.org>
Date: Wed, 17 Jun 2026 14:19:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/5] mm/vmscan: extract pageout_one() from
 shrink_folio_list()
To: Zhang Peng <zippermonkey@icloud.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>,
 Zhang Peng <bruzzhang@tencent.com>
References: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
 <20260525-batch-tlb-flush-v4-3-83789d6abc00@icloud.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260525-batch-tlb-flush-v4-3-83789d6abc00@icloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C2AF710000C
X-Stat-Signature: 6t9ufqzs4prbrckeud7kqz9spnq3f4ty
X-Rspam-User: 
X-HE-Tag: 1781698784-471247
X-HE-Meta: U2FsdGVkX19mxk9sq37mxgwjJtZCtVEaCOU30LQTAOs5VEThfoiFiX0wOBBRVT98Ic1njJddcaI64KQqhHzPjJll78y8nr6tR9oJGyu6gfNJYdRX/yVWnruTSqTB8xlc0t+GEuRhZSTcyUEMYwH8P8KuxpIRhwIsd4/W9vmus/PJcUpi6I44dcVaAjjT0wty+6XJj6hIwb1r33aXMqgCdjgBwtFBN+91IGsARANbGWU7RnfJ6yqE90B55i5Imgcb/xCcsw8kfcqWZhPxyhVPLjq6Ultfc/7Y9p1p2zkn8GnENuCXLIeZZVGglyHksbOVzfwTjHSqB81YBelgreuxRa+OICJN440mcRwLYSY/jOi9Pu5J/s3i7sCEIOfFIwoSDYyuQZx6eLePNcNEoNyFZR4fJ0Mq0qijwPflPlOYfBJH46+UJHS8gOOj6HB9vZnm1PSW9fRGsN6xQDUi56AQaVvktbY8kjsC8pDlV7Aly8kX16yqf+btkTJ6wvTnwazjHOcM/Ojn9OB17VhpWucTp9xDBrC/jOIkHVCvSiXS9/eNeJbciUXT5C1LNPCh90eKjiQS7tv5wu5MdlYvNuWs2jdXh9Ji8JCLzXFImLw52+JHPT7d89b54A/VaCNlFOzF+JqzyY7C5zQSZhEH3kxuNJcCU90y7G9YnfLzRiEUMnuiIqTxhjl7YneaVPGvqwN4S6xgbNGdpPIZwYIkIM51IYDw4dO8mMchTmH7JSGvt4MEz2Andc6V5ELy0P4+jDGtz+XzVe65kZcIN9ORu6iDmBd97FufO+e8ZXKY08iAsFmKE3/1Mg5aZtmyIxs312b4dC7Fy72Y2nU+EUv4VlZJMJiuhPZRR1sEZuLDy+hbJtC2fd8IUnoJytQaZA8ZlWi/FtNVoDVa64G7iPhD/mHWgF84T48tutiRZE6OYODDyTCffexvUVzK6kQRefDdJqlqvPEvm5ZuBWN174xeUyE
 Vmo6klk4
 vFt3ZJFRV6rjSLLQSgOKxwOpjDO2pa9okM561u6m8vO+kB2KC0CeXuS9FBXa2vHNfstYXXbbWgvnAUDh9MIR+DKn/qh208SSBQX1QHS2NMIuOR8IPoGvueOndGTq7Z8MY0sUD4LpS2atsK+bKsdUHGM+ZQuU2XE/lj7qIQxnQlfvAu3qDAICn1YiIP9vDptuzNKCbnfV0Z5jYtvSLTJDlRU4tCVGjRsxfbaBfJs2JptNHmjISi2b7C+LWat1O0uQEWNdKRKI7wriWYtVCNsiVFuYUzXCeX3zXfJcV2gWS0M84YLV+4SckETZbPPu2gQZE8go0vCwMEatfhAE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/25/26 16:57, Zhang Peng wrote:
> shrink_folio_list() contains a self-contained pageout() dispatch state
> machine. Extract it into pageout_one() to reduce the size of
> shrink_folio_list() and make the pageout step independently readable.
> 
> No functional change.
> 
> Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
> ---
>  mm/vmscan.c | 107 ++++++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 65 insertions(+), 42 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b31f67801836..456d38eb172c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1161,8 +1161,68 @@ static bool folio_free(struct folio *folio, struct folio_batch *free_folios,
>  	return true;
>  }
>  
> +static bool pageout_one(struct folio *folio,
> +			struct folio_batch *free_folios,
> +			struct scan_control *sc, struct reclaim_stat *stat,
> +			struct swap_iocb **plug, struct list_head *folio_list,
> +			unsigned int *nr_reclaimed)

Two tabs please.

Same comment regarding returning a bool.

> +{
> +	struct address_space *mapping = folio_mapping(folio);
> +	unsigned int nr_pages = folio_nr_pages(folio);

Can both be const I assume.

> +
> +	switch (pageout(folio, mapping, plug, folio_list)) {
> +	case PAGE_ACTIVATE:
> +		/*
> +		 * If shmem folio is split when writeback to swap,
> +		 * the tail pages will make their own pass through
> +		 * this function and be accounted then.
> +		 */

Same comment regarding making these comments use less LOC.


In general, LGTM.


-- 
Cheers,

David

