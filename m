Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0757C53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 17:31:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEF696B0095; Mon, 27 Jul 2026 13:31:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC7706B0098; Mon, 27 Jul 2026 13:31:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADF866B0099; Mon, 27 Jul 2026 13:31:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7157E6B0095
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:31:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05E02C0139
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:31:11 +0000 (UTC)
X-FDA: 85035247542.07.0977363
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 31E0DC000D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:31:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Tgcp/6d+";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785173469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FeuJKdYUaVLKNBfWUd4HTmd0q5nfx0zD3ldduTDAYyw=;
	b=JRCsogVWzjtGLq4jSSYhQi0t8YtRg3dVf+pt3kWlmAvnUHO4XgKJ6dBKqeVOjJ5kZaB0vS
	+8ld9QE3MLbHDc0OwlWfd/xAv3tTBjPwTWWyfiXiyTc50L/ryMBEjF9GQzQ5OC9NuocE3t
	oa2r4x7U4m+mfNIKXzI0rq3PMBVTYJE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Tgcp/6d+";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785173469;
	b=rtzoENFELaSTwwxD90nDSgfFXPgL1yCRyXG5p8CopwqGXm8sOJaL8QoPt4drZkhfrTtbVk
	znjOrCsLbdgtqYmhuXH9K6hfIB2OdThcYudJrH4Cl0mi8PowkZv9fidOoiuzlaWLo41WUv
	1o12V/Dq3jgCxMV6pIBb00CR8Rk7W6c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14EEF41B4E;
	Mon, 27 Jul 2026 17:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827011F00A3A;
	Mon, 27 Jul 2026 17:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785173468;
	bh=FeuJKdYUaVLKNBfWUd4HTmd0q5nfx0zD3ldduTDAYyw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Tgcp/6d+oehw4jDZPMJxHA7W9qn4aC2gFYD7gy9EXODmJCAyFVQTa1rPfhqeWoew5
	 Y8D3kgRBHTLk8wRpNYx/lh/CJbi9sGnokVUwUQcjUwKia/o3MlNovgq0U9Sh5CJHdI
	 S8vOrgAm+++TF5TjAp5Hylm17hxvbJBCRIWLYu2WlswQBrM/V2YCFIV9w1shQ1cyNm
	 i6Egn5y0+toxfqtOSQmy64WdvsRNkBL/4490Kow5eZLM+InHbK5a4m/fSsLu49so0U
	 kg402vDz5qjt3yEK3UvSg4nWOo8QBL4Srr1UqNxjCR6cOBIbNGWTvr53xdyCSRuMKZ
	 QztiFaMubtRnQ==
Message-ID: <312caaf8-1661-4437-aaac-a93bf701ccf9@kernel.org>
Date: Mon, 27 Jul 2026 19:30:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/huge_memory: Initialise workingset state before
 folio split
To: Matt Fleming <matt@readmodwrite.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Kairui Song <ryncsn@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com,
 stable@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@cloudflare.com, Matt Fleming <mfleming@cloudflare.com>
References: <20260725101419.3938406-1-matt@readmodwrite.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260725101419.3938406-1-matt@readmodwrite.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 31E0DC000D
X-Stat-Signature: skt11rea37ndsfbgib6g63dbcrf7tigo
X-HE-Tag: 1785173469-110668
X-HE-Meta: U2FsdGVkX19qQzg1G9hbWuZRgwIOVfWFCuuSZ2s+qP7R7iKN0x7bLWrrkZk+IH/zh+NpZkyAhnX04g1Zloau25cEEAXzSmyN84Lu6GgFysqlNNiiJpCXgQdsJ3yZYtUmmOCx4KUunmKzbSchG9xJZtU1wm7cGAScfJKGVZPYveM4wD2syJg2jyLZ8BGZu7DhT4cikHK+VZTf4Vx724u4KqNFrRbUDJoE+BvU334rb9HP3jhEIzx2LHZiA1P8SF9Vq+3xqPllxtLoxc+0gG8WGsixUyqG4LvGi6avvoj1Y1lGpU7lTd7CJojoqjL20E+TqDwuS/kdEgr+hZYft7tylofPAUgULV21U7awKQGUwP1GyWmQdNCRLw/DjqbPeanhFsOWbrihUf+vtZiBcItoRUI91kPs1eJV1a2kVmTGAIiFgYcigAKHhfJH3WSW2X0MebTBgV1mGEyq3YYdKGW5w7x0OVQgHet5wQiYoO9mDekfzTHynPJHfpCYvGo2MQVKgIEO/nFcl9hi56EvBTQ/uSNzunKbcB3odpHRzDF7SIs/12aaLqFpKO47Jq42YHakLpMTLBT98Itk2q/GGOgbOWJubec7W2wS9aqSY5LqAooh4sctVzk7fT9YiKEZxxJuUiNAjJR9l0H/YTceOOiJqKgtstG80+ZrXCl0Fwmhqp3vp0PO4d/NpOprp6U2w0xCHsd06xuVKKizuHbVgiQmQ6+y3RevcujRb2n1qz2RKO7ajZB9SRdhO24wanX5A15nmvDM+ZqUwf8LjUxBYtXQJs0RHH8S1AuFTwmkLieIPutge5X8Ni/GL62+CSageiPFO9HNyqbx5v+ySpNkkfABpLqin5p/efy2DJSIkOkvvOoXNE3/Ou4vDi4PsxlPifmli35GCnmUoIBYktRm/qM/4dNu0dAdyRewW22cvlyythZNpG3Bw5lUWKxpl7WiJha9K4iq4f4bm1gt0RUFr7g
 hd5lp1VH
 sgIhmmA3t/xkzkx9H1/QirENnuAKu5q7rZc1CXQqhZAEvdOTLVw7wg4OkzdYX88Ml+XxUPSjeobrq/eVklquHY7Pkp0jEXbg6TtEwEdOu1LjBkoy+mrmHN3N/9ZC1PnnDH1YKX/xHtdmQsKltAmcHXhkQuMYX8yQep7s/Wrbuu9JjAu441t8YdFBIisGFa4fBXJr+JTVKoZUveiDYGhGi5F2TxE6Nuz55TCBj5gS3BNluaQZaOgjTKQK/XWkZAt+Fk4gubu5RX84M0r0v+umBeoNU+MCIoJHXxBvWNZiC8MEJS1H/M55oqVb75AzA2k9VXhs51ZGd3Ytwy7MsIs1xaxlgtbBBK5xZDEZ+lt+itc1DJZxRPabSESXkST+o0r+8AobUNTpQ0XiQvJHphLiyU3/orDBAjGEmKyAhUBikg9TZWmfVkC/lNGFhEgSNM5Wg0LEcFHTjaGvtYLj8yfqdp1Eztq6vG6QuPe3yTq7iXbd4J7brT368s8mLZxb91+R4AZxj867Rno1DKDj0T29aIcynivy3IPFmvyqiFdX316SAAeZzDT1ZUmvxvJNDTkZTcdfpF+W+McI0QGKO/OyjtoWvxEuQ6VDuNy7mfIddM9wvg17Iy9Kbgk9znClpx0pXmtDSf4A49k+VN8rc8jWvYSA+IXXbnKivOatB7LLhmbnkuwP/nHV0H6rxIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/25/26 12:14, Matt Fleming wrote:
> From: Matt Fleming <mfleming@cloudflare.com>
> 
> xas_try_split() adds __GFP_ACCOUNT for page-cache xa_nodes, but
> __folio_split() leaves the xa_state's xa_lru unset. That lets a live,
> memcg-charged xa_node exist without being linked into the mapping's
> shadow_nodes list_lru; when reclaim later walks the list_lru it trips
> VM_WARN_ON(!css_is_dying()).
> 
> Use mapping_set_update() to install both the workingset update callback
> and the shadow_nodes list_lru on the xa_state.
> 
> Reported-by: syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c5b060ce82921a2fd500
> Fixes: 58729c04cf10 ("mm/huge_memory: add buddy allocator like (non-uniform) folio_split()")
> Cc: stable@vger.kernel.org
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
> ---
> Changes in v2:
> - Move mapping_set_update() after filemap_release_folio() succeeds.
> - Add Zi Yan's Reviewed-by.
> 
> Link: https://lore.kernel.org/linux-mm/20260724195244.3715130-1-matt@readmodwrite.com/
> ---
>  mm/huge_memory.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index b5d1e9d4463d..4ddbc72e92fd 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4033,7 +4033,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  		gfp_t gfp;
>  
>  		mapping = folio->mapping;
> -		min_order = mapping_min_folio_order(folio->mapping);
> +		min_order = mapping_min_folio_order(mapping);
>  		if (new_order < min_order) {
>  			ret = -EINVAL;
>  			goto out;
> @@ -4047,6 +4047,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  			goto out;
>  		}
>  
> +		mapping_set_update(&xas, mapping);
> +

It's entirely unclear when mapping_set_update() should/must be called. ... or
even what it does.

Why is it called "mapping_set_*" when, in fact, we modify the xas?

The more I look at it, the more angry it makes me :)

Can someone please try finding a better way to handle this?

E.g., can we somehow remember in the xarray that we have !dax_mapping(mapping)
&& !shmem_mapping(mapping) early, and just do the right thing from xas code? Or
is there some way we could have a mixture in the same xarray?


Anyhow, for this patch here, I guess it's fine. I am convinced nobody can say
that with confidence. Black magic.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

