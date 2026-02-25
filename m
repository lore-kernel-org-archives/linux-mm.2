Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7077EFB7F0
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 06:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BBA76B0005; Wed, 25 Feb 2026 01:28:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969A56B0088; Wed, 25 Feb 2026 01:28:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84B506B008A; Wed, 25 Feb 2026 01:28:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 716F46B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 01:28:02 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDF6B5908A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:28:01 +0000 (UTC)
X-FDA: 84481998762.15.E2C85C6
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1292340011
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:27:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QynxAqD2;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772000879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fzmvl+WxG3Jff7cSYYgfD5qWpcTKs1nAA3CGqddqF1w=;
	b=U9LuyJlPTp+C0yWbt6xIBD4RtZzbVTyhf/EAFuAhw6ax1lJF1Q/i2uhptc+GjL0q2L3ApU
	ccD+iaWTVXPeM+NZpFT6xvNrEyKODmbEQIcP8cWKw40pv1wc4eHzArCfrXcjLq54t3loh7
	iirfJjkHYQ+R6v0CeWqZ5IyB3r0QJ8A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QynxAqD2;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772000879; a=rsa-sha256;
	cv=none;
	b=1+6aQOgbVKGFpwOFavRNgrFSXk4mpeixQGMfXhR1LpNvGfqH5W+fURATweeWGtKW+BLyJY
	VDhIXDmnWtCncGUVugyQNKuMfMrniTSetaBmP84rgi9HKVfhryAETNzqZfYDGS86goe6eB
	PkoulqKDodfSlQ24ZCghU/EE4GkEXrw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fzmvl+WxG3Jff7cSYYgfD5qWpcTKs1nAA3CGqddqF1w=;
	b=QynxAqD2R4KnUQEf/Wp7qbiYSFhUH3njKbhuDePMT5qW/ksJVyoJ6uiSFegqmbyUWKl4gQ1hR
	9n09eVvvmcO7g7MmfxwB46mv5HMgtMRkwaGzctBP0PYAy+MYjGGwbu5uA0tNBCdvyjGO4KaFdKT
	KrcCZTnea8deA2A4rJAM7I8=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4fLPfK1zKTzLlTD;
	Wed, 25 Feb 2026 14:23:05 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id E41EB402AB;
	Wed, 25 Feb 2026 14:27:51 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 25 Feb 2026 14:27:50 +0800
Message-ID: <9bc0d4e9-71ae-48e7-83cc-d42166d3eaee@huawei.com>
Date: Wed, 25 Feb 2026 14:27:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/cma: move put_page_testzero() out of VM_WARN_ON in
 cma_release()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, SeongJae Park
	<sj@kernel.org>, Ron Economos <re@w6rz.net>
References: <20260225031231.2352011-1-ziy@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20260225031231.2352011-1-ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1292340011
X-Stat-Signature: cku6kuasrfayydmpwue5j7gkgtur8nbe
X-Rspam-User: 
X-HE-Tag: 1772000877-598010
X-HE-Meta: U2FsdGVkX1+cYBV2ToS11rfyOuYfgPp9BYQ+f1OWWCgn0uFTjSlvba+o637M7aoNrIOBxwfaUHn4csyPvMtDm50ajUg43HM7IRy33LH4x9EMJ6VHRqLXtKYrgpv2MZXnv326CjD6/Ip/7a6uL0JLiDRhX/gPyZhcJSXlaHWbJy8VQ/WIHQxn6S4APRF2El4z3A9iRZpmq8uy+aOBSoN1dFgR+B/znN6SywbU/e705vLIc5Dp2P1cIJFtcr/nRzftuvioDmfmEJEz/PJG4QA8Laqt6+v7pbw7A5bUWEq+Rv6z4Ame4Y9+eUJbn+b85mXxwK1YxIyVB4SSm3mzUEGVlNstV8YaO4sAjVvQ1JIq0T0pgl1Pr0goumX4TM5AnoMwIrVuxNzPgY1yPTfgWT85PxXZTE63Q1/7cqAbZS4ygalIvK9nu/Chbe3XTFwiDmsvHJcfIcfDWlq2N4p0riYnTB3drTm1bvemTBOXCdDsNRDh9Evm1WUz2mAcDGUR/vJZZhckn277JfQdBf1NwpjjH4nIkkBKlfXrILGQgRf5KXqnH1B3WEHK0k6hyi0Wgvr8fLpPn54udHsTlNM7Kc/J6d3z1KPLSXyM9E1OyEXGqc4oGyPO2SLoILHxGWkpSmjyhgPoMeqSJy2N+H/3wDIu9lsgoqVdNZmvlR6NofywPiThOz+D9sN/rwS7qz0g2Unw+OmVRVD7QMrCxe1mcxhdF4LXMgc8YpikMWOLiMWeFVavwB7RXf3bz0P37hzLCFSZxtMUaGG0xFN7/xXtSxYgZk1+2ACU83pTvPe2MokmYj1kNtH4Q1GtAC5wnxhX0KruKUND6dfD6F2Jac28OUWT8ieEopzWpP3tUerzjVf+PrWhpYUp5C2gjK+0+Ge8boc+RDv3dl9RmMHnqviyKx4rHD7AfSOb5zQ626iYV5aG8WEZOIR5KuXCF+tZHpmDMNT6VoDUK7RNTkfnmaO7euV
 oblSi6eT
 znLzB36RHRIrcA2XmLG1A6LkjLN9C4kf1JCBSDIN2ti1J5/ZFchRi9aCJJwLM6Mrnt5J0/MSGN1KLcD/AAqb3kwrOtMVg+r2rKhvegEsk0vuk9gMWLqIlwPP8OflOB4LGfPY0tEr/tx1shsYayLPIGb8c2xG2zlAQHkGKJvHDzcrKd4yRFitKqpNj7tJgqFBgxfuB3Rgez9VcEd+mTvyDOx1ltVkR1a2PDc3br92NMy8WU1dIXEGAKyABFVG+bpSj7+Nj3zfE6K3KmNuyXI140gIYApDP8qXdK+rNTPyD+zXWnSOj4shxYRJNdXNnfrEC4dXarabp6VZ1md/8LbOU6QwE/LnNjv0zfBbrwNaPB+ck+EhEgGylXowGI5y0gzXX27NnC9sK/HUkr6Yit40uyjhVwd80clWqtfVgrzjQxV9oP8rUZp7dvUCsoCm9p3dNySFPNDKArD6BnoLSUrL8ipGImiayvvWcTPQAxr99mRSgWx8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/25 11:12, Zi Yan wrote:
> When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any statement
> with side effect inside it is incorrect. Collect all !put_page_testzero()
> results and check the sum using WARN instead after the loop. It restores
> the same check in free_contig_range() before commit
> e0c1326779cc ("mm: page_alloc: add alloc_contig_frozen_{range,pages}()"),
> the commit prior to the Fixes one.
> 
> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> Reported-by: Ron Economos <re@w6rz.net>
> Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net/
> Suggested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  From V2:
> - Collect !put_page_testzero() to get the right result.
> 
>  From V1:
> - Collect all put_page_testzero() results and do a single WARN after the
>    loop.
> 


Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>

>   mm/cma.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 94b5da468a7d..15cc0ae76c8e 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -1013,6 +1013,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
>   		 unsigned long count)
>   {
>   	struct cma_memrange *cmr;
> +	unsigned long ret = 0;
>   	unsigned long i, pfn;
>   
>   	cmr = find_cma_memrange(cma, pages, count);
> @@ -1021,7 +1022,9 @@ bool cma_release(struct cma *cma, const struct page *pages,
>   
>   	pfn = page_to_pfn(pages);
>   	for (i = 0; i < count; i++, pfn++)
> -		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
> +		ret += !put_page_testzero(pfn_to_page(pfn));
> +
> +	WARN(ret, "%lu pages are still in use!\n", ret);
>   
>   	__cma_release_frozen(cma, cmr, pages, count);
>   


