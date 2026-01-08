Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 835F9D1D47D
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 16:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DFC26B0088; Thu,  8 Jan 2026 11:19:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6891C6B0089; Thu,  8 Jan 2026 11:19:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9C56B0092; Thu,  8 Jan 2026 11:19:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4C75B6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:19:52 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE6EF1AC32
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:19:51 +0000 (UTC)
X-FDA: 84309307782.25.6D735CA
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id DF902120010
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:19:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767889189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kIMvYTe41yGVEESOn1cMNdpMDw3Wgu/8iU/J+XaGs1s=;
	b=q/wwgsK5dczJmICKaodGzZJTGA+F1t2LlRR1AZ6KxdFMmA2RxaM8g6PuQEd+x1sqqK6Cnf
	ld8OeRMRnDsJvmHcQe7Q7p9OZgbzMk/nYXFsfec8Z4Moiwsz4+y/cBwVw7BNuljLlzEzo3
	HtBpdfMJ0ckl2c0WpED9f4mUDUArj1Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767889189; a=rsa-sha256;
	cv=none;
	b=BS4F7g4YpX3XvgmHf3wNf4xgTsHcXiVzRFbZl99Y7HmlGJOPZN30a/9RIZoyUk/OcxfFIb
	jbBYXo97smamSjhfR3WehCYByQakoZk8jcTSKrBWePmWFLvUafOQ+7KqSL7YH32BvDd8ZS
	DhyH07FE7o+UNiiSLZQZHDHz9Zm6RgY=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dn98m6RNlzJ46CS;
	Fri,  9 Jan 2026 00:19:36 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id F3E9540584;
	Fri,  9 Jan 2026 00:19:41 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 8 Jan
 2026 16:19:41 +0000
Date: Thu, 8 Jan 2026 16:19:39 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Cui Chao <cuichao1753@phytium.com.cn>
CC: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport
	<rppt@kernel.org>, Wang Yinfeng <wangyinfeng@phytium.com.cn>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID
 of CFMW
Message-ID: <20260108161939.000026ec@huawei.com>
In-Reply-To: <20260106031042.1606729-2-cuichao1753@phytium.com.cn>
References: <20260106031042.1606729-1-cuichao1753@phytium.com.cn>
	<20260106031042.1606729-2-cuichao1753@phytium.com.cn>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Queue-Id: DF902120010
X-Stat-Signature: kkmrax7tscfxkqppxk7697y9p1k4gc3m
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1767889188-923607
X-HE-Meta: U2FsdGVkX1/yJ/oRwT/QaaQ9krfF72u2Ql2XH7A0hj4VK4qZo/1z6h6vc1niMzJyBS9c7FyU2/Fs6gTQkXCfS4KUOFGbomerkaY6n/qhVJTrp9rZVZQzasks5D+Go3PvdDAqPQFPIsjkTcPya5yR1s3s1kTgjaZ6cRu5iR6350aQNwjEXDcD633fzIJBvX3uOf4ubBpJp3q8nFWWib2BV5gKzc1Ef2Z+fHE9U8Kx8WmhEfdYEKuzcMvkHEkhsg2Gaorto73LlsC18yt9fzuG1sGCMsVsPIXkoSzBMuOVopq7gZn/7dAFx22t/k8eaNyo9yeo6HXEhw8qDypVDYXKtEGaax1mwZ/IAui/PUCcNc2ucbfnDVD/Sx5rVO27/Hxl5ubHj1jkiOuTZpKFr1SToft/XJ624YNXciwDqdExO5r6AtFdlDo2B8Y8u9YVNHYYtxPmJh3je+e+MOsruClsU+DTzdEETi5T+d2dz6OzznYZMbGCr6d4/HLuGwM/t1nwX3cPRj9oVZubjDBpkmkM05/hmXCB00/c5LxZgaMLBBP16vGwxaMxX44V0VqveIihOYde+qi+1+hTwvqLkQqKziWWBxFs3NyW462PfrsRk9XY5/mFfRolNj4s21mWjj1WL5ebEawrygCevftB4fOgYYgQoEoivkLlbIlnmO4uWpaC62DPIxIijNimLZr6tN0KLO8LM6OBTrnFVbXPIMS642y1DE2+XL/t41inHYmr0QZ5/ETpEPfoHT2JF98c2RnI2wKnthrs9B0cDixa8rn1ezmEavNiTa0yNjvc1T2GGSomrlg0/8n27nBfi7I0+IefTLCbj3mAyW+j8amctU+zJ4fHLr0WF5Q3Rx6Fwsol2CC84QZulaWBGq+eUa2BCeThvq2frgnH5XJOlyeAoZJ16kT5OItBlS9tXl0GT/MawHPu45JM0hPwbahblpEr1o9e6jojkEmxQYKV+Ixh/c0
 P1xirNlo
 hYF/ei+/tFKErZM4jG+25NIBh4qA+lX5zRo0GduGGG1rhl/k3K47M9etLohH99BcKeyF7ZMTiUoxvguqNVY27MipAsXeUmMFzR7WvXWIBQhyMfMwrWc2BxcTcAocoZT068NCWNVuB7Gv//h3aQEM4YMLyr1F4McOwk9XOJ/PQcpfP/GIpf2YAWrhrpZ8J+7U/eOnTSq3T6MkG6WOom8oBukrYHh8qxUGCq2WgxJTaYL57tHPF0Ot2PfHPYorqgWLmbxWJmx1+sXj9a+/M1NAGd4zsYbGjvI0Eh6NnT46Qo4u+QRwcUkV17W9HqB9GRqI/0LorGQd+jEHXjzL79CZfEFdv49vDavjmCCTF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 6 Jan 2026 11:10:42 +0800
Cui Chao <cuichao1753@phytium.com.cn> wrote:

> In some physical memory layout designs, the address space of CFMW
> resides between multiple segments of system memory belonging to
> the same NUMA node. In numa_cleanup_meminfo, these multiple segments
> of system memory are merged into a larger numa_memblk. When
> identifying which NUMA node the CFMW belongs to, it may be incorrectly
> assigned to the NUMA node of the merged system memory.
> 
> Example memory layout:
> 
> Physical address space:
>     0x00000000 - 0x1FFFFFFF  System RAM (node0)
>     0x20000000 - 0x2FFFFFFF  CXL CFMW (node2)
>     0x40000000 - 0x5FFFFFFF  System RAM (node0)
>     0x60000000 - 0x7FFFFFFF  System RAM (node1)
> 
> After numa_cleanup_meminfo, the two node0 segments are merged into one:
>     0x00000000 - 0x5FFFFFFF  System RAM (node0) // CFMW is inside the range
>     0x60000000 - 0x7FFFFFFF  System RAM (node1)
> 
> So the CFMW (0x20000000-0x2FFFFFFF) will be incorrectly assigned to node0.
> 
> To address this scenario, accurately identifying the correct NUMA node
> can be achieved by checking whether the region belongs to both
> numa_meminfo and numa_reserved_meminfo.
> 
> Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  mm/numa_memblks.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> index 5b009a9cd8b4..e91908ed8661 100644
> --- a/mm/numa_memblks.c
> +++ b/mm/numa_memblks.c
> @@ -568,15 +568,16 @@ static int meminfo_to_nid(struct numa_meminfo *mi, u64 start)
>  int phys_to_target_node(u64 start)
>  {
>  	int nid = meminfo_to_nid(&numa_meminfo, start);
> +	int reserved_nid = meminfo_to_nid(&numa_reserved_meminfo, start);
>  
>  	/*
>  	 * Prefer online nodes, but if reserved memory might be
>  	 * hot-added continue the search with reserved ranges.
>  	 */
> -	if (nid != NUMA_NO_NODE)
> +	if (nid != NUMA_NO_NODE && reserved_nid == NUMA_NO_NODE)
>  		return nid;
>  
> -	return meminfo_to_nid(&numa_reserved_meminfo, start);
> +	return reserved_nid;
>  }
>  EXPORT_SYMBOL_GPL(phys_to_target_node);
>  


