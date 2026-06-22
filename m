Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07FD1CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9F176B009E; Mon, 22 Jun 2026 06:20:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4F5B6B00A2; Mon, 22 Jun 2026 06:20:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98CCF6B00A3; Mon, 22 Jun 2026 06:20:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6100C6B009E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:20:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7BF4166C56
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:20:26 +0000 (UTC)
X-FDA: 84907154052.19.36975AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 15441120002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:20:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=m3dNwSEd;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782123625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Av5Cay2iQgE4dmKixANA1y2OxA30B1PEKQsa9QOD1Vk=;
	b=flArPOCruJPXNffKy0j8tSCmMN82PZoD2kUe8JPkggykO8D1ToBZYfr4AMpyLeK5FbX2Og
	h96mC5mTjT1aXOmta59pH2muxm0UxjxMNo2XC2q6xh1IYJEiSJZxfDdZlMpOym5V0nTZbm
	Nczd9pgUp42ya/H7nnXXiEakEGiEu7g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782123625;
	b=rZQqbBh8O+d1lUrvzJWgyd6n6ha6Wq4mFtceWVkR1hbw7Hu7C3DZRPXLrP8COmS3QVtvJN
	vnStbK2BsmrweQtHkMWGM5kSNvGOyJqn4riik9Nw1pciJfWo9amQex8NamOj2LKGJ74B7H
	xm04vfXLYPOqZdieUdGKTJlzpVc5rZw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=m3dNwSEd;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A9BB403B8;
	Mon, 22 Jun 2026 10:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AC21F000E9;
	Mon, 22 Jun 2026 10:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782123624;
	bh=Av5Cay2iQgE4dmKixANA1y2OxA30B1PEKQsa9QOD1Vk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m3dNwSEdQK97otKyW4aA+SnAcax0LXFVdX64+OZjOO0Yq/NxEgpmFc+PVwtEkPciV
	 QQueXKNfzqnoitADM34KU9cMQrKUiA+WB5ez0XvobjUs5biRvhuvuLKAQJ0kAFD71K
	 spFd56Fk/w4Va/+NdkMYcD/JhXmr0IoR5GnqKN64=
Date: Mon, 22 Jun 2026 12:20:38 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	Robin Holt <robinmholt@gmail.com>, Steve Wahl <steve.wahl@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 08/13] sgi-xp: Use higher-level allocator
Message-ID: <2026062229-lumping-latitude-b091@gregkh>
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
 <20260622-alloc-trylock-v2-8-31f31367d420@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622-alloc-trylock-v2-8-31f31367d420@google.com>
X-Stat-Signature: 6zbh4xn6pb9jxuihjxzzdbpxkycmrkbr
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 15441120002
X-HE-Tag: 1782123624-998418
X-HE-Meta: U2FsdGVkX1+hIRi/WUEleDXKlAZiI7E8oO0Ejbp7EXYpe6PyukmD0XIbeQ+WBP8k3Wgtp40MBoL8Ip/rbplnXFzVgRm62MUt2xnfoF+6/9nERfHCvaI1a+pMSseyu3rXYthpsSg/Oac50e7zfREyWf8nTKKuU52BkfRKgey8fyKZ7cnFIi1GuqMgyc2xgxiZnkseyZmOGf7I/0l1DHcUK0X9sbu6uu8cfIIa9wEKp0sSc1CA1RtbIQvaJPjQ9HR4m3+V3T/aLHTXvzIhNyGv7Ee5H57cR1A9qZKQJfmwuwifh96AtGd9Wp8O3wey6GvMuTGw83VLrc5Q2Tn7yfw/laKe6/fLwl7qLxQcnCLsVgOzUZzXKOf+BbbsFp84ZtGCIZe/PiwvAjBCjfRwhiXJqEE8AsbJqPnjxP4yyE9CIxtGb5ja5aR3Eo60UFglkZrDs4N2XXkC0Q6xHGquq79lUWOzWsb+epw/YrtVB3wy5sFJV4Q2oXSwXE+X897KfFL4OgD4Db9KdZK4+Wn+0GPuDIJbQfn1BmZdy3oHNAkq8mqAmZ/Cb5sUpFlFRu7De0eJZecadurn07nBn0YtDFz8Ivfry66lvx8d8phPdZNcaDNLISuRzSzONCSC5NkTCDawqE6EYK0S22owgk25a7kQqLCt96lD1/TDjgNF2+dJZPv5rR6kJgEdYNVombhYLJVX1DF94gkppluNSoqknjqYWuasebzvfxAbOOJ5btku7Q4HSYDNPGvIFqcQv/9VLEZByC+ov4PpHuV7CTKPkku3nhgngxv42iZYg5gbXm1/AoGEzZtqKycU/vmlXQSJX1ElcJJG8QKuJ4aXqbCmarvfE32XigbVHIiL56XgZZAfT0GRqZiQ8ideWIBdmRkYobAR+cY7E0RE1fY2yxpZAJ6UQw9lpHYhIErC0O9Sj+JBJofB/Re/Zi+uyHXqHCWwDQUAwjxi3IOUi5DEcKKFZOS
 Rc2ZPZjm
 iXYxFUiDbDaXSPUR3OVlsVB0HVJZmCNyMb6eXqIRsKX0UCm3yCt4Nz3pCyhCHWf5tPEWICAXRY81qPjYVft7vP5gTN1u7/3un9ERdPHbwJNu89Kp6AIAqfRKjyEe8AYEFPlh9bgAuzDSGmTvKre7MstN0EvtXRmaqnl8rgv1S7lxkElvUjzD2tKzhy+bi3qq9ms66jFqkoDk2m4uAdTgh8f8idnx2OtyBUSZ9c5YtpFSX6HPhgHtBuHMVbwhV837xy45Pua1ETK8tpedyivHpAEBICG3yHyLuRLJrFtydSuSpcbSKbdpkXVGYWMgXlmiXPeWFqcVIUPesr/BaLPOwFcvCEyUdQbzUvLwulctklq+dZY1ksbx70siAInPaV2LC3ZVrt11/Vkd7tXYI5pZnF4XygC/71fBpskno59NoYVPhCpClM7fJuIeziJ5TPKXWcPKhHobqINHuSwzDnutj5MZVKduWkhTFl6FmrPJaFjf2ULiRnOP7hBxcVVkj1VTgGk5bYveCJy4VN4LFWUICCJ5wZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 10:01:35AM +0000, Brendan Jackman wrote:
> The difference between __alloc_pages_node() and alloc_pages_node() is
> that the former allows you to pass NUMA_NO_NODE.
> 
> The former is going away and the latter works fine here so switch over.
> 
> Cc: Robin Holt <robinmholt@gmail.com>
> Cc: Steve Wahl <steve.wahl@hpe.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Assisted-by: Gemini:unknown-model
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  drivers/misc/sgi-xp/xpc_uv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
> index 772c787268932..aacff70204241 100644
> --- a/drivers/misc/sgi-xp/xpc_uv.c
> +++ b/drivers/misc/sgi-xp/xpc_uv.c
> @@ -170,7 +170,7 @@ xpc_create_gru_mq_uv(unsigned int mq_size, int cpu, char *irq_name,
>  	mq->mmr_blade = uv_cpu_to_blade_id(cpu);
>  
>  	nid = cpu_to_node(cpu);
> -	page = __alloc_pages_node(nid,
> +	page = alloc_pages_node(nid,
>  				      GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
>  				      pg_order);
>  	if (page == NULL) {
> 
> -- 
> 2.54.0
> 

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

