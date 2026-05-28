Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50201CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 13:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694C06B0093; Thu, 28 May 2026 09:25:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 645026B0096; Thu, 28 May 2026 09:25:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55A546B0098; Thu, 28 May 2026 09:25:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 457DC6B0093
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:25:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D53F01207CF
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:25:23 +0000 (UTC)
X-FDA: 84816900126.17.BEBFF31
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6D44E18000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:25:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YEvhW7kY;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779974722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxcsNZRecDEaQahSiT11cWudtxXnG0dORG1khJbfvIw=;
	b=Ud0ZzZATz4Fc+U2/ESbvqKlZhIeHy2g0u5wSjyzl3+ZvuBYm4FvMvbFyP+BldZ92zdH2cu
	tL0y1yJRHJio0fzeQov6yqtdyY8os5ABKQlhg/QCeTl5Cj9EoN9oB3zguuFUa/pdiajDxn
	y5HAPR3A6xgVxd7k9Dqt1Q4s1RpyL2g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YEvhW7kY;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779974722; a=rsa-sha256;
	cv=none;
	b=TqQYcUBgVf1xqIx+MU8N6b07eZa91RfhXRgL/SNT6+kXZIjhh2MPpV7nxn3O5a5yBtjJ/v
	bSd+sGZn8eRqq7EnhO0omhculP4Nr4vCP9BuRD8m9IiR7AXPj/2OMsoVzPYixS7itQoBni
	RdYUX6SvgMzbKvHGNsseXmU4kiwPc6E=
Message-ID: <1eb96ce9-6959-403a-980c-c3bbd5843bbf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779974716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YxcsNZRecDEaQahSiT11cWudtxXnG0dORG1khJbfvIw=;
	b=YEvhW7kYNXlm9pb0Nco0953goxoB6e2HwGldUUyQg0h4AiIlLCtrtHHxY4j3AVrbcVvkJd
	7SFNPBQ4KBvQR080l/wF3xGV3MqI6+ouBvUM6L7PsZminoYSLEtGXCdRL7erGMsSznoYqi
	3kgIoNNi/FUaCW8CRstXYBtAhtdDVc8=
Date: Thu, 28 May 2026 14:25:10 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v5 1/9] mm: list_lru: fix set_shrinker_bit() call during
 race with cgroup deletion
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <liam@infradead.org>,
 Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Kairui Song <ryncsn@gmail.com>, Mikhail Zaslonko <zaslonko@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
 <20260527204757.2544958-2-hannes@cmpxchg.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260527204757.2544958-2-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ytmpupewom3uemecynrot6apczxikkz8
X-Rspamd-Queue-Id: 6D44E18000A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779974720-210126
X-HE-Meta: U2FsdGVkX19XwtWHOoaXJrfGPJIBln5Qb/iIYKC9EjkMBk7sVPYKnQIRoeqQksXLUxnS0+jNOJU1CRDTTy1Mrp9mPyv7lnWyDO3mUUlQH9v0REu2lp4s1Edqcnz/m2pUOuDphigPmLlR1y12NaXqQFdgki1cq6l8VPicGp+n0sRLjNhhzhVMhbNWRDsRb5+ZrludH5BjT3MPD4QfoCB7DVqvQ4iLpOwMEyj9W0HJ+k6yy7qG90y/f9T99cxygHnWSFQuszcheUMbbd1wq7KkuT/c4/ElZutHiR60GbWgH+NIhBcyiG9xrMpmjmren8XgxW4mXGaGOn9MHW2xtfE3Igi/q8dU/UlJrgiWOoGc4seu9cmMYYPLB+ZihxHkGBgJPa3i18NnMYUvsVkdoJngUWYA/5oBCI5W8nwhGUwvFWyU1xrDOJpnzAl9hPYB1fKbf6PR4RV2vcP0xpUfikNUQHd/ErDDUxHneS+BuK9WxhBiVFcRL4QVPfz4MQSRLGC59haus6R6U8THOXb2IJJKgflRRHdodpWuFzQVSaQukIuI070Z7VqItm58aubnyT24YADQ+yF6V5JAOaFaTdlgHxynNF8KwT2TKR45EAmDL4JwLQgCxmYq9chZ2w0zCfMzFjpNFhiNqKqv44Cp3eY71PDJGFWc+Ao7CjR2v2t0ErWuntvahVdBs4vWS+C+Pn3a02L2yHyz8k5jISlunWc0/02owZW+BkoBZq38DGcIrGswiVgWDTmuvl0HoKUA1SlBC52n/oRTZrW/zsL7+DHbsSzkYc89dRIACa45NnDIn7JHGz+gvFlMFCsnIX2cGW5TPganhjmWNx2ZZLI9/x/owwWDgwUO8EGddR7crq0ljzPE7kHf7g0wNnC4QHppAx8AOPHHRPAF6ds5FygSbD198QTPQT+IPOK2C9ZkZb0NbZuHS5q+eXMOSJvdfBC0gFjV7cUq+rrnmyLysQJ4kHl
 SxZWugzQ
 C7ZPpdo3uIYW3NI2eurbUidLQVdRTt1AQzjV/7g7RjyykpbqTZ9DkW0yDNvXskt35sVB/OyChaPBjgF0hhR10oruet2Ml6FfvyqsSWwqQGNPurw1LHajW1yJGKVMFfKOyWQ+uNk4Lo4z7FUvxXpkzdAGU7OOYvyIDZN1nz3mJ5DP2T08ZO2XjgXXtgcc4I3pph1ncUOjdGsS1vpwW4NJMagCeaxa3LYJrx4FJvkh0lzAD2FlsuyICeVKeO10t2MQ0fh0lJ3B+YVPOyxFLAdEOMGtKnnhDOOFsmJDz0jxE/fnk1IBCKd7Pr8q92Bln3dCrgUsW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/05/2026 21:45, Johannes Weiner wrote:
> When list_lru_add() races with cgroup deletion, the shrinker bit is set
> on the wrong group and lost. This can cause a shrinker run to miss the
> cgroup that actually has the object.
> 
> When the passed in memcg is dead, the function finds the first non-dead
> parent from the passed in memcg and adds the object there; but the
> shrinker bit is set on the memcg that was passed in.
> 
> This bug is as old as the shrinker bitmap itself.
> 
> Fix it by returning the "effective" memcg from the locking function, and
> have the caller use that.
> 
> Fixes: fae91d6d8be5 ("mm/list_lru.c: set bit in memcg shrinker bitmap on first list_lru item appearance")
> Reported-by: Usama Arif <usama.arif@linux.dev>
> Reported-by: Sashiko
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/list_lru.c | 26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
> 

Acked-by: Usama Arif <usama.arif@linux.dev>


