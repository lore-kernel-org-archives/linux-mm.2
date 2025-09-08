Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52C44CA101F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 02:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39BD76B0007; Sun,  7 Sep 2025 22:16:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34CD36B0008; Sun,  7 Sep 2025 22:16:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262336B000C; Sun,  7 Sep 2025 22:16:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 146FA6B0007
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 22:16:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE39716090C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 02:16:34 +0000 (UTC)
X-FDA: 83864469108.08.BF352FB
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf08.hostedemail.com (Postfix) with ESMTP id A0BEF160002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 02:16:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wUvIXf5n;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757297792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSRS+R1XjsTFSUxoGD2Q9a4ybrs4HDjecpHqO6RVh1k=;
	b=6ygh25lkhR/iGmdUGFiSRTvlNptEN35s1uZoBj4hkmtT6U43iBWVsq9b++7oy5OcsZJxVp
	VK+mUlp/gf/eGZxMsoNqC1KJyFn4+6zdBCeMLrGfLnIlXqvJZ0HzfBOibL4PBW90yCg4rQ
	/RXvE7cT9Fy7AjLQF34c/gH7TWiSB+A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wUvIXf5n;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757297792; a=rsa-sha256;
	cv=none;
	b=TQlXrtVvKxBSuvi5DW7/HXEtq/cWdBquLvivM3uacs6Fd5xtk04NTIqC3gIoFcn740X8kM
	nv16UkvklL1j9gXVfUrpJFRGkQOrV87SN9/Ip9wT/yuFka948lZ/IdyQ5S/qbBPZ+LYUOT
	rJyRyfLdJjPVEVdrKMxSyjHzhSOJLjo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757297788; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fSRS+R1XjsTFSUxoGD2Q9a4ybrs4HDjecpHqO6RVh1k=;
	b=wUvIXf5nuETDaTveafAgCXqmQuumqXnvGyeV4zUaBg8Ext0T38qi9I47ppJbWWUqikaJmec0UfwPvwoND9JOa7WkwJpkd6f8T9BujnZbjuxYvYufv3Sji85VUlx3oGu3dZGBW4TvMdZ2Stf5PeLzrUtZfk5ghbPZNsc/z7dpt6k=
Received: from 30.74.144.132(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnQBVtb_1757297786 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Sep 2025 10:16:27 +0800
Message-ID: <d86ea841-b18e-4f6f-902e-0763492f5aeb@linux.alibaba.com>
Date: Mon, 8 Sep 2025 10:16:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usamaarif642@gmail.com>
References: <20250905141137.3529867-1-david@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250905141137.3529867-1-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pc6um7ggpfn5gkj53ubnoxo1aergf7o6
X-Rspam-User: 
X-Rspamd-Queue-Id: A0BEF160002
X-Rspamd-Server: rspam05
X-HE-Tag: 1757297791-176131
X-HE-Meta: U2FsdGVkX18fLJEPXwweJjj2xD3Ij9E503+8J90YgOzg9vAgfE901+qzN8pmLnOO8Pzvc0y9FYgHegxaItTT6m2uKH5AAFghDlFf2YugXQBtHIg1dxpOHi0yeY4/13zTSd5IqQGoNou35i27S9r0OQlahcANasqgc0lpnkQBEVvjdLOBiBrqxD0kDBQf4SaERJJeM8aDFr7mI0oEvdSB0VOAePRWhS1MZfkRW9DFDCU9U2GCIQzJRynC2NiNKaFq9tzGJsRtvZ77QRc2/ZHhMBKy161A9o/PVAcy9NOdssbsZSgqnlyI2x9rPIL7Urrw32ZHS3qN7ZTcoxcXZMQ2BhHRcAgDew9bw32Q7VqljZQZoxL+ILGDK3wP/axElxkvuT4TbSXf46Nn7Jb08IzFpzJPm+suWy09fwXDYxUrUF68wvONmL/LmL/KvRb9rFgIT2jeQIoaO/60BdBOx4cpPSaHIcZRDyK3Pfhcz+998WcSJ8mYRr7g382ZoZbb/Grsc/ASJ2WBpfeEyLGP/kk5uoMtLzHGHp/WnjK+3xQN41/zjnLn32EJNTm8HzbhvEcQrWphi7rbQW9Z183CqQ3/o5QoiabB0UgMRuH4/ztr2gz0ZhOUxXY+iKfV4ru/d9Nmf0jgiG1ofNLUgq8U4qo7WqdZ9KcFhyVTeL7HXS2CFMIUap4eV55dM6bJRbBTe7bv/TJUs8aYpkPHptvIOAtgEmdW80683wdQL7fcXey0NHRjDhbtXFiLJZ3HQ2h0LTHWu2fjRMfhMpC1kDcwuDh5ptclcuN5neeSjE4ZrEidXKegu8dxA1XMO8b0Ck0DlH6cdotMKQOO0j9F0z/X3ktdFa7RGzDa8q4ZYyE2+c0U6whltLyrS7y5o2PKCkjV7CTq7vAFJ2F/LVoNZw1AE38te6RJdX5HMMq79eCCZ8FpKmKZtA5dNuhkoVyHPfWxBDsPPbKSIc8TSnevMy6GwEQ
 fXk0tXy1
 DFDpZzOg6Ab/RwH+sFxx3T+GlpDqgeU/KEOLYIT4o63lNt6H8sdAtDvLDeRx9Y7JsLXfB79v+INL4X7/ckb9E0J5WDT834s0q/WH2/HqVUFoxfmfbR8M2+sqjiqd44MJs/PK3k7PoWFeI0k05Tn2XzVADAW7xzK6Qdi0NYPVCelyZexXNuCbrypp+bUoUqETKHVNBEfzzLVqkxEGZdirYMeCVcugfAjLrrfDntf86IPeDBhWlQtDp/TCmRETc0EXpE+lETyy0ZTt2Q6hGAcHibT6sxbgXpVwd1uUFIzJFS/mtjQrMoM+pAc+ASgJ+HrKZ1lBC1Rqt+8MaGlOsTL7lz5zT5E9i7NIhMOiIgM1X/HxulHmvTJvgdAc008o7J1WY1ThXnHJQuKZ5bJ969AmlivQeL9Y6vE0A5/AUtsL9nPkteSMrmjabW5EbSXPEs1a6lq1mCjXWvX6SL8ofANlhqBIwcRWB+jtBBYUCey8Xkvz+75njymtFx5nk4hG4SjEN3KWc3+EKXMHjsK86MZSt6dB76NlPj7shpmK3tqyzsX77JNemy71jS4NDoYWiFm6Lb5NaU9aM1Bl6QWU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/5 22:11, David Hildenbrand wrote:
> We added an early exit in thp_underused(), probably to avoid scanning
> pages when there is no chance for success.
> 
> However, assume we have max_ptes_none = 511 (default).
> 
> Nothing should stop us from freeing all pages part of a THP that
> is completely zero (512) and khugepaged will for sure not try to
> instantiate a THP in that case (512 shared zeropages).
> 
> This can just trivially happen if someone writes a single 0 byte into a
> PMD area, or of course, when data ends up being zero later.
> 
> So let's remove that early exit.
> 
> Do we want to CC stable? Hm, not sure. Probably not urgent.
> 
> Note that, as default, the THP shrinker is active
> (/sys/kernel/mm/transparent_hugepage/shrink_underused = 1), and all
> THPs are added to the deferred split lists. However, with the
> max_ptes_none default we would never scan them. We would not do that. If
> that's not desirable, we should just disable the shrinker as default,
> also not adding all THPs to the deferred split lists.
> 
> Easy to reproduce:
> 
> 1) Allocate some THPs filled with 0s
> 
> <prog.c>
>   #include <string.h>
>   #include <stdio.h>
>   #include <stdlib.h>
>   #include <unistd.h>
>   #include <sys/mman.h>
> 
>   const size_t size = 1024*1024*1024;
> 
>   int main(void)
>   {
>           size_t offs;
>           char *area;
> 
>           area = mmap(0, size, PROT_READ | PROT_WRITE,
>                       MAP_ANON | MAP_PRIVATE, -1, 0);
>           if (area == MAP_FAILED) {
>                   printf("mmap failed\n");
>                   exit(-1);
>           }
>           madvise(area, size, MADV_HUGEPAGE);
> 
>           for (offs = 0; offs < size; offs += getpagesize())
>                   area[offs] = 0;
>           pause();
>   }
> <\prog.c>
> 
> 2) Trigger the shrinker
> 
> E.g., memory pressure through memhog
> 
> 3) Observe that THPs are not getting reclaimed
> 
> $ cat /proc/`pgrep prog`/smaps_rollup
> 
> Would list ~1GiB of AnonHugePages. With this fix, they would get
> reclaimed as expected.
> 
> Fixes: dafff3f4c850 ("mm: split underused THPs")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---

Thanks for sorting this out. Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/huge_memory.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 26cedfcd74189..aa3ed7a86435b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4110,9 +4110,6 @@ static bool thp_underused(struct folio *folio)
>   	void *kaddr;
>   	int i;
>   
> -	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
> -		return false;
> -
>   	for (i = 0; i < folio_nr_pages(folio); i++) {
>   		kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
>   		if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {


