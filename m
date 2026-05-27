Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E22CCD5BD2
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 03:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6B916B008C; Tue, 26 May 2026 23:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1C276B0092; Tue, 26 May 2026 23:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31FC6B0093; Tue, 26 May 2026 23:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92DF86B008C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:28:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 224BF120394
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:28:25 +0000 (UTC)
X-FDA: 84811766970.07.FD222A3
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf09.hostedemail.com (Postfix) with ESMTP id C3BF7140005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:28:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vxS6Gf+C;
	spf=pass (imf09.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779852503; a=rsa-sha256;
	cv=none;
	b=z/RhMl1e67oeSR5+OBfzAoaf8dWbuMqXAQY/yjuz7nmF3aHnOFWgmlqzuUQby3CfJCYQBZ
	YLpf7ShfFHcfZk9f6Lmv72iLHNa1Nzyt0Hf1Lrh3NTqBvFwqx+03Q8gCeyeNk9nGtvDedT
	0tXObsp9EyYU6+rnsQraYlYL9EhVXf0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vxS6Gf+C;
	spf=pass (imf09.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779852503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xm27aHRyRrQdqIYE1aIWgOYbESWRNrtkj5Qor33G2U=;
	b=3vDVcqpcbcTsC2EUM11DfaX7OJchAshvj68Q+RQyRO9tuaqAUn/UzIngvGNM25ljlKluLo
	6PK/qKFgA671hy0+ZQTe4zrMKnz4gg73mVlE9THB4NNE3lrEoEcdwu2cTTXUT171HRLw1a
	TfLAmkVuZ+S97hfANC/hrUXkrOVKi04=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8xm27aHRyRrQdqIYE1aIWgOYbESWRNrtkj5Qor33G2U=;
	b=vxS6Gf+Cc901CR4CW+oPMFdkTvgem+UrfX5puCn/KLmIQ4iJQkw7n6w6kp6j8VZYbILqtZQOz
	0F+NME38TwHIHvifM7JKN5ojJqbJW+FP1DZ3oZYmTlslN9aR3oiEivW/WYKhuxRnFcOWSxtgtag
	qA9tI0nLrYmfnMOtW1WlDOU=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gQFHg4HXPzmV64;
	Wed, 27 May 2026 11:20:31 +0800 (CST)
Received: from kwepemj100016.china.huawei.com (unknown [7.202.194.10])
	by mail.maildlp.com (Postfix) with ESMTPS id 51B924055B;
	Wed, 27 May 2026 11:28:18 +0800 (CST)
Received: from [10.174.177.15] (10.174.177.15) by
 kwepemj100016.china.huawei.com (7.202.194.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 27 May 2026 11:28:17 +0800
Message-ID: <ebe77f40-aeb2-451c-8e30-f6be4b1bcbf3@huawei.com>
Date: Wed, 27 May 2026 11:28:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
CC: <mawupeng1@huawei.com>, <muchun.song@linux.dev>, <osalvador@suse.de>,
	<david@kernel.org>, <ljs@kernel.org>, <Liam.Howlett@oracle.com>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] mm/memory-failure: fix hugetlb_lock AA deadlock in
 get_huge_page_for_hwpoison
To: <akpm@linux-foundation.org>
References: <20260522010305.4099834-1-mawupeng1@huawei.com>
 <20260522205041.a85237b104d74533c13745e4@linux-foundation.org>
From: mawupeng <mawupeng1@huawei.com>
In-Reply-To: <20260522205041.a85237b104d74533c13745e4@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.15]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100016.china.huawei.com (7.202.194.10)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C3BF7140005
X-Stat-Signature: dhy4jjehr4dgns4h8s3i8hd3o9ix1guf
X-HE-Tag: 1779852502-57589
X-HE-Meta: U2FsdGVkX18sJL+o4ZUbyfIHJycvAsvWEp0vaNaDYgOmFlrxzBc2ZWHzW2r2bLulFjV4zhW7M6EttSoYEeaf0BXtZE9gpjXNWgmRmHWflOTjDeKZj5sWXf/JE8iRWYzdnUsbYDR4BKI0RoK/caCx9Gj9rQg3UEmwsQn88dudmuFLmhqMs9B6FZ/lD1gdRV7uTr3Z+j3AuR0EBBRfZRLu/M8NPsM8H8uTF4WCi+mkXvd0yDm1WOl6FighXf/YxhU1f+PQgnXNSWgudF1HQyvWubQ23m7BdowWE3YKZhvKR1Jv3K9ZmV54cdxj49o9MARYPORlAb6FRxlmzK4psLnUr67Yu7z9wXPkQRsEaOY0XDDVJvDP2k9zajSOCWUURqfgGKOdvxLBjNzEzPHtY4q4G042xtTBeOCjBhdEtgyvDEOrsASsq463wK3zqQ3wnIUYgKGlq812lF16MHtGKIPxLLPIJhopGIW5y7hQpHCm2miKNFbbA57HOW9PRp4E9xsxV/pLDmMyjVO+h9AOiu/fxmxTd4ar+vmfG5gJMPvkpD10UpmrMrayFkx9woZ50VouctbQOu8+mJZ4uH+2MwwQ1p0sPufFciBSwYN+DmPZ7HlXai9WpqqcUxalgK611MmrTR1ZOjQCSbDjeaBztNnqwwbXE0dXfvJ0geI/kc6w65sABjVab+xI79+VrxmarRifsqMLEt6SYIbCw/uGT+fyEgoeuh0IcbULukfCRUVnz0qwJbybhit9wBw/vBQaXmk3zb7DCXCicBCGk5mmJrzTeVx1TMEcT1yvp5W3MoMyaIVrSv23YPnLKT8S2RzarXO6Ny1rCrBbSkKu6ISzWShXOBJsQi/VzhbdDxOGd53C4mBzSyNSQaN//o81zRj1FsvWFPQ/s5rtyws0vbVLrxUpsj+4kIt/E+N+vx5UHHtWQfoEEpglFuxvSoxAfNmAJRyxeU/SEW0mdAXSzPEvIXK
 bZkBnpZW
 BMmdzAUJUrECrm8iaeihWRqf7Uohitxsq+YpMt3R7xnbpSjoBvNbe309fuZLlYdGNhdi2K1gZ4bjlBoCQ4h5AoOTYjsLsh8R3QCHkYbs0K5tgnCjH817IFQdPhptp2fJq6XCkFSa7uvG05AE30QS1UYuHwHiQILhgokSlUoDUbWSJQuBQKAIoNclKs+LJuqARxaxp0SKcQYuoRjNmkipc8tYG7iPWHvi7ar12QL7sQ1fLvxKAtm3EUO9oHTjyEmx+z2lOeJjeQcNYg1//8Gnqj44dYf2YAEfMHvc9qrWqkuyyJUzN4ksw+Hqx5qZt7bJ6q1RW7SZJZoMnEjsEw7DUW+XTbn5/L9ygTFdWcvPQzAuBKOTRH3aUCJwV5YbqbZTUK/QKj+cg12WNBhAS7nG04ACbL3OFWOXFaCUCP+Rk9r4qFPpeBRkV9w8VU+4HvchEziqSic1tphTzU+gakbKw5mq5jUwnNIO1hDYCMB4E9p5gRtr70wk6zHlTF/WP+WwoE/sUeB85ctJOqhvYIEh02SfhaJApccafsWf+kBtmbVey/fZRUr5GtSqMKQdGdO1jppKrXS7478g4CyfoHOi6fQAD4jPrn3puX2D30MAoMyYRp4/DN4rhrDOTxLmKQTuTFAp0KEX8zdeX1eHj+iy2WWTJXYnNH7JzH7MhIzj5/aRN8rQVrre7wp+XRZNRpVVPMWX4wCYuZyrob9wyIIk0oI8iAvb6xkKyiApdfJ+PVawk3Su4sVoqS3w7jy3ASZX23jeb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 周六 2026-5-23 11:50, Andrew Morton wrote:
> On Fri, 22 May 2026 09:03:05 +0800 Wupeng Ma <mawupeng1@huawei.com> wrote:
> 
>> Two concurrent madvise(MADV_HWPOISON) calls on the same hugetlb page
>> can trigger a recursive spinlock self-deadlock (AA deadlock) on
>> hugetlb_lock when racing with a concurrent unmap:
> 
> Well we don't want that.
> 
>> Fixes: 405ce051236c ("mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()")
> 
> So I'll add cc:stable here.
> 
> AI review didn't like the unlocked page_folio():
> 
> 	https://sashiko.dev/#/patchset/20260522010305.4099834-1-mawupeng1@huawei.com
> 
> So I'll add a followup patch which addresses that (and which addresses
> Miaohe's naming nit).
> 
> Please let's check this - perhaps the locking alteration isn't needed.

Thanks for your modifcation, this looks reasonable to me.

> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix
> Date: Fri May 22 08:44:25 PM PDT 2026
> 
> - address possible race identified by Sashiko
> 
> - s/out/out_unlock/, per Miaohe
> 
> Link: https://sashiko.dev/#/patchset/20260522010305.4099834-1-mawupeng1@huawei.com
> Link: https://lore.kernel.org/f39f405e-4b4b-8f79-70fe-a2b5b62114eb@huawei.com
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Liam Howlett <liam.howlett@oracle.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
> Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Wupeng Ma <mawupeng1@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/memory-failure.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> --- a/mm/memory-failure.c~mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix
> +++ a/mm/memory-failure.c
> @@ -1970,14 +1970,15 @@ static int get_huge_page_for_hwpoison(un
>  				 bool *migratable_cleared)
>  {
>  	struct page *page = pfn_to_page(pfn);
> -	struct folio *folio = page_folio(page);
> +	struct folio *folio;
>  	bool count_increased = false;
>  	int ret, rc;
>  
>  	spin_lock_irq(&hugetlb_lock);
> +	folio = page_folio(page);
>  	if (!folio_test_hugetlb(folio)) {
>  		ret = MF_HUGETLB_NON_HUGEPAGE;
> -		goto out;
> +		goto out_unlock;
>  	} else if (flags & MF_COUNT_INCREASED) {
>  		ret = MF_HUGETLB_IN_USED;
>  		count_increased = true;
> @@ -1993,13 +1994,13 @@ static int get_huge_page_for_hwpoison(un
>  	} else {
>  		ret = MF_HUGETLB_RETRY;
>  		if (!(flags & MF_NO_RETRY))
> -			goto out;
> +			goto out_unlock;
>  	}
>  
>  	rc = hugetlb_update_hwpoison(folio, page);
>  	if (rc >= MF_HUGETLB_FOLIO_PRE_POISONED) {
>  		ret = rc;
> -		goto out;
> +		goto out_unlock;
>  	}
>  
>  	/*
> @@ -2013,7 +2014,7 @@ static int get_huge_page_for_hwpoison(un
>  
>  	spin_unlock_irq(&hugetlb_lock);
>  	return ret;
> -out:
> +out_unlock:
>  	spin_unlock_irq(&hugetlb_lock);
>  	if (count_increased)
>  		folio_put(folio);
> _
> 
> 


