Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77778C624CF
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:24:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 723726B0151; Tue,  1 Sep 2026 07:24:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FB546B0152; Tue,  1 Sep 2026 07:24:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610866B0153; Tue,  1 Sep 2026 07:24:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CAC16B0151
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:24:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4381A3DC3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:24:35 +0000 (UTC)
X-FDA: 85164960510.18.2CC2ED5
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0358D40003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:24:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DOahXZMJ;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788261874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E3VURlQpvCj0IFlfDMpwATe4ShsH6UZzlqTrim1jfqQ=;
	b=XrXbqpDsTNj+sMkrbMY4+hHI2qHOTLBCm/ZSyeSvbBvrymGo435+n8kt02Ar4Hl/uua4N3
	iMLZVQRFLX7NCZHb0P0rdyy+HdUfA0ZoYQFv2m32yxnZ6GT5wZg0rhx1WaubI9PB0uTJ/2
	NP37RnvxoNdTletx6r9XUVk29wv79QU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788261874;
	b=0LmlbXdpC5HDplNBXvvJ4mPI2Fap+CDCN+io8drs3MOgXdYB+Ih8jQMio9chXhDxsgYwMM
	c2l2nxSqWT2UVyV5QDqQF3VHpEoUfKAJE2tq9RZoF48f0VulFG6QDOoc6wm7V3czImDv1h
	IVIdRbKxF+1NdYq8FLAYa1eVvBRdCrQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DOahXZMJ;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788261869; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=E3VURlQpvCj0IFlfDMpwATe4ShsH6UZzlqTrim1jfqQ=;
	b=DOahXZMJ3RhwsA9PjEzn12EvmXslanQu5oHxd6UonvI3B1O1/1ub0co60zBFHfd5UOeSHgm9dAdOFVcl8lnfGF6y8b5Biu+o6RSOT03FDfCncnO1cNuzqu6Cpsi9blgnltqeez/uJ1rb6lE4AREIQVczUxtnRwbfXu+xMfqfNJc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XA7CcCs_1788261862;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0XA7CcCs_1788261862 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 19:24:28 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  kernel-team@meta.com,  akpm@linux-foundation.org,  david@kernel.org,
  ziy@nvidia.com,  matthew.brost@intel.com,  joshua.hahnjy@gmail.com,
  rakie.kim@sk.com,  byungchul@sk.com,  apopple@nvidia.com,
  urezki@gmail.com,  chenwandun@huawei.com,  Chelsy Ratnawat
 <chelsyratnawat2001@gmail.com>,  stable@vger.kernel.org
Subject: Re: [PATCH] mm/mempolicy: take a cpuset cookie for the interleave
 node count
In-Reply-To: <20260828193111.1023497-1-gourry@gourry.net> (Gregory Price's
	message of "Fri, 28 Aug 2026 15:31:11 -0400")
References: <20260828193111.1023497-1-gourry@gourry.net>
Date: Tue, 01 Sep 2026 19:24:21 +0800
Message-ID: <877bl5qknu.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0358D40003
X-Stat-Signature: fd5n6jbz1wyjd4uu75fkmusb4oqbskea
X-HE-Tag: 1788261872-112771
X-HE-Meta: U2FsdGVkX1/KRTVIDQgmHbmGI8RP51WN2aNzR+dDhrsnF9ZswGNdDlmOjbFHd9F5qVlVtT79FIGS0hng1NvTq4wRPiTlNvgavPi/VluxNU6Uf/fr35CeNDWtoXXPEdzav7NFJylB321WxcosooobRbjtPWeGd6ocsjeHSahXvl5vJNZWM7fdzk0BKI6iWxdsERYYy6klmYwTHe/zO6j0ft+SL84AMD2ErTU5EhjmO4Qx6gT5qNmKA+EHB6oLahJIL0Cx62P2gjD4Bd1PAL+OReFIBszAv9Zr0QFlYtg1XD3dL8k074SdlB0Pw0JTuYI4VTfXyUmxq+B9s6gA7o7nKJi5P7DfIbumMCF9WYcoGTlxB7sNywtnKfjSH3USdx6lZRnlIfIqpxY8BxacyrUTcv6XM9b5AfKPOlBeP96lQXgiZcwDP8AXjyDFuYOgWT7SxCQBz/GueYdG1lLkiGtHSpvQbpJkI89SLof3368MDFPWHMGNzrthutqRHcUqRLzGFbTi8XK+80z0rJ6L2nKtU5E9oItlitj81mmLcGzmZHhw6g72dys3S0tFMuWFGobRUyVp9GkfYBc8cVUAPdyL+U4myT8NAf/ydgSmk/IWjoF1X/ddXy3faS742HNz2li92YETUh9jcYOegYPp1nwHsFLcsqWzQNMRcl/UERhuV2Onm7H82sw1reY43F8p+3iqujaAAEWY2tV7OdXBGegZESvnVWAdGl1HaodC0oXJ7PuOQEtKts3cg2QOVoOQvrrPsO+Gwvi4VlxMgv/dbhiKwrV45WURfE/gA6vbPAZbHZ7JeG55cMhGk3VNa3F1nhmFmJiAGomOVxTn8wh03tx/nEeEo7k2eeK+VTTfEdt/gJppv416QdZNVb+4/6R05nwoF2hjlP6sxGt7KdRUZ5TehNEQ6JyZlnG9GAqyA4T/NRmheouhFKoY4bE95e5U/72tsC/RQjbVhwtQ8adxRf7
 CDpZwnal
 YsUwx0D7hFXr9GJTXgl3VrV5peyhqhYjPSuUMYTV0dnIz1NmbXuSfwZG5aY2a3QogDUgsdHG8sAjQ1esVo3HHmLTg2deJE1F3LxdlN+FPR4G4gZkk2tOjBH/5j26NqhwvdL3FhWV9CfKklIrjkHnynTxnPfmi2eGnnlZ4FFAIe/qMZx5kMY0GnzL6TbB0xvo/ksIRZ1C2g9qTfna0l2BGw1HcCLjpwdqIdE9ZACMtLRMQ0SRf8/XVlUab6FtS0KZH8gmr0FrzKUdQJqyM3gTeMVgMJWk6Xf8yndzSz32QaqFQbcB8ZMT1Z3IX6W335xo9TC8+GHXMefM80MDkVaf9VxczOQ48KW/37iRTYgfG3i65abhZ1u+D8z+CPM0ke+4HDOidRo2nLnYN9hUuKDD8l1pdjCSBk8hpT0lb9pqtuBGyjTyTbSg+1qwPGxQtsZHQ2W1r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gregory Price <gourry@gourry.net> writes:

> alloc_pages_bulk_interleave() counts pol->nodes without a cpuset cookie:
>
> 	nodes = nodes_weight(pol->nodes);
> 	nr_pages_per_node = nr_pages / nodes;
>
> nodemask_t spans several words once MAX_NUMNODES exceeds BITS_PER_LONG, so
> a concurrent cpuset rebind can tear that read and yield an empty mask even
> though neither version of it was empty.  The call then allocates nothing
> and returns 0.
>
> Some compilers will hoist the loop entry test above the division,
> because nr_pages_per_node is dead when the loop does not run.
>
> 	682e:	call	...		<- nodes_weight()
> 	6838:	test	%eax,%eax
> 	683a:	jle	692d		<- nodes <= 0 skips the loop
> 	684a:	div	%rcx
>
> So in most deployments, this div/0 is unreachable - but nothing in the
> source guarantees that, it's just not easily exercised.
>
> Take the cookie around the count and bail if the mask really is empty.
> Only the count needs it, interleave_nodes() takes the cookie itself so
> so a torn read there is already retried.
>
> A rebind landing mid-loop can still leave the count disagreeing with the
> mask, so the loop may revisit a node or skip one - but a rebind where
> nodes change causes migration, so a handful of misplaced pages isn't
> catastrophic in any sense.
>
> Measured on a 72 node VM (NODES_SHIFT=10) with a cgroup v2 cpuset flipping
> cpuset.mems between a word 0 and a word 1 node set, and the two word read
> artificially widened: 330 zero counts in 130414 calls without the cookie,
> and 401 retries with it.
>
> Reported-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
> Link: https://lore.kernel.org/all/20250907160829.91628-1-chelsyratnawat2001@gmail.com/
> Fixes: c00b6b961099 ("mm/vmalloc: introduce alloc_pages_bulk_array_mempolicy to accelerate memory allocation")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/mempolicy.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 79053ece02cd..060a0eb26917 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2592,6 +2592,7 @@ static unsigned long alloc_pages_bulk_interleave(gfp_t gfp,
>  		struct mempolicy *pol, unsigned long nr_pages,
>  		struct page **page_array)
>  {
> +	unsigned int cpuset_mems_cookie;
>  	int nodes;
>  	unsigned long nr_pages_per_node;
>  	int delta;
> @@ -2599,7 +2600,16 @@ static unsigned long alloc_pages_bulk_interleave(gfp_t gfp,
>  	unsigned long nr_allocated;
>  	unsigned long total_allocated = 0;
>  
> -	nodes = nodes_weight(pol->nodes);
> +	/* count the nodes, retry if a rebind happened during the read */
> +	do {
> +		cpuset_mems_cookie = read_mems_allowed_begin();
> +		nodes = nodes_weight(pol->nodes);
> +	} while (read_mems_allowed_retry(cpuset_mems_cookie));
> +
> +	/* if the nodemask has become invalid, we cannot do anything */
> +	if (!nodes)
> +		return 0;
> +
>  	nr_pages_per_node = nr_pages / nodes;
>  	delta = nr_pages - nodes * nr_pages_per_node;

LGTM, feel free to add my

Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>

in the future version.

---
Best Regards,
Huang, Ying

