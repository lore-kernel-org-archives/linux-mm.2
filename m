Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58C1ECCD185
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 01:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09348E009A; Wed, 15 Oct 2025 21:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9BA8E0008; Wed, 15 Oct 2025 21:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8398E009A; Wed, 15 Oct 2025 21:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84B888E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:21:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 215AF82A8E
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:21:05 +0000 (UTC)
X-FDA: 84002223690.08.B9A2733
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf27.hostedemail.com (Postfix) with ESMTP id DE5DB4000B
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:21:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=X9ypUvtZ;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760577663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDyeLaeN1YOib58odHslZ97kcj1JXP+1Zl/NMoXkpdY=;
	b=Xqx+NnPvZ98MOGnKevMgoyyxbwUyrJv3VIbROl6jZGFJxSCtC+H3M1USjF8DiYCGi5jdqe
	FqdG0KTxoU7QFHpOePBIpZ+Wn1zMtmy3HFgrZc86lARwSq5jTICLh3Dq3NLyPaf/t9pXIE
	rrJx+K9mC3CMXp5sK+YR2uRWbHksjRo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760577663; a=rsa-sha256;
	cv=none;
	b=sGV0VB7HlYhMSAuc3jUXfWsM2o2mHM9+Mui0KxDmYW/r39XLcNCjpAMTXA8AaG6FV7CYdI
	tCSSv63skUBKd53QhLYFj2bGQTsbDGODCasNgDkDX9DkrkyW/hTGmRjAawn04abvg895vo
	zZmQhwdn4rh30PybY8q2IWhd99g2RlE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=X9ypUvtZ;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=iDyeLaeN1YOib58odHslZ97kcj1JXP+1Zl/NMoXkpdY=;
	b=X9ypUvtZg7r+fJjlxX2ctM00ggyiSlkri/nftsetPwBaF2nczxRaoYtYP4+w96sZcU7tydQxJ
	kzC639C/j4BFRUGzMT4xGiCYOJpYOHKVY1dh6XouwsyPWYxsJ5fDhipJlgHHfs+6edJ7FIi8F9d
	pUp5tFcOR/FZqz9xfuLabwE=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cn9BC4RtrzKm6d;
	Thu, 16 Oct 2025 09:20:35 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 39C44140294;
	Thu, 16 Oct 2025 09:20:56 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 16 Oct 2025 09:20:55 +0800
Message-ID: <c4cf63e4-92ca-4332-8638-af26acbde3bb@huawei.com>
Date: Thu, 16 Oct 2025 09:20:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] mm: hugetlb: allocate frozen gigantic folio
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>
References: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: DE5DB4000B
X-Rspamd-Server: rspam02
X-Stat-Signature: uo9ph6gwbfxdtjowfu67zuhxjt1hyiwc
X-HE-Tag: 1760577661-914776
X-HE-Meta: U2FsdGVkX1+oQpNBP5mOZY09U2tcEggGlLHUdChkTSVO+mK79DIn2OG7v+qyiqQehqp0dk4YzT1NkAhaabZJo8ywOL7MNJ5841IWFsnokTX7NtnGgrg9E5JojIvolkWTQ905cdTqEEhgh9CEzY15ZcrBArKd2bY4y/TG/cyrzZmtyQgfnYpDu8dwoa3aT6pzvqeTE/xwoqifiTFz83x2b/Ib7KTtIOM6eo6ber/szccuzqpyDJ6RIVC5qInPUWUq74hvJ0ocUHuv9ynM6RzRceM0YYrW0g0Z39gDiNdrRN5YtU2qe+09I4a+IFAw6lkHPDg+u8WkFK52NQ6onBJLQ7XZXGFKuC+ClddZPeJ8XPqFF543evpTeVOWPD2rweJ3zJBweCnsoP9aHrPlqYw6z6B2Isl6vv8iOeNMzhR44nnDaoSXbI5Cb3nD3RnReLKI1EoSkkeV8Hlz6zdDnnQABTb96Hpw5kTZQBtQHV4V6YyZJIYSGGV3c2ddfJzKyV5ea/vEAvkARyjbOhJUddDf055ab6WqALn9pPe2GPk1qgIxWfogEE3KOo3zGqE7rvSoWFYGUUektcMZ2H4+EotLFyt8wB3jMUqKMxjDqO2fil5yFYE6Cos/Ips28tl32P0T5KSd9uws2LlcmLszqLybsqYVKwh4BwpkFRtQlEqep7x0TqNepwjbyltihCxOacLnHr7oYl3CLz5ktlVwPweoVwF1AmvromzC+oXNRh8dAMhYmRgKLS2v+761BUpH5tnlCsX3zsS4KjdMn3gXDiqYhhuUqORuPAFq6L9EHgB0RG0JlhO9lrNxfZpMqCV86wyCSRANraNYAriySa9o2fR8Ds2hvWXSN3d6ERfyIpK0BxInRD0qIsQ8XV8FeH+iNFvWczeCgWm2rPz8C7tDC3Ip4fsoy7G7fzTF07mg+gD/cXoNKA5gGjhhzqmKwL4miDrlS6txZYz3/HpK7TIazpo
 X4f6//L4
 ZAuyVt9OFJ3z08c+mPRzd1ixVqb13Kf8Aeq8a4K6GguWuzHC6hhuXCmtx36D+LunkTDHbGNgFqY0ZWbcOjA+apZCoznOb/tT5MiiUK3uGNJT39u6zYJx2AA1oSswCspGaTgkTtosLvMxDQ3sjxebODCnC4hkgBoXQe6OfNczD70Y3+kLp4VfzHP466TUgIxMz+NjBl1D8t241CTMyzA+/Q32goFY5xQPT3KfcWdHaDKtpN6cVXCMobqEqUzfjdF2xeKdGYRJ7EnQ/sk24Xout1fywb+GlR5BUPw+IdOG1lrz2NeZ2zBFJ3B3l4G7JZhoK+xEU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On 2025/10/13 21:38, Kefeng Wang wrote:
> Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound()
> which avoid atomic operation about page refcount, and then convert to
> allocate frozen gigantic folio by the new helpers in hugetlb to cleanup
> the alloc_gigantic_folio().
> 
> v3:
> - Fix built warn/err, found by lkp test
> - Address some David's comments,
>    - Force on frozen part and drop the optimization part
>    - Rename split_non_compound_pages() to __split_pages()
>    - Adding back debug print/WARN_ON if no cma range found or the
>      pfn range of page is not full match the cma range.
> 
> v2:
> - Optimize gigantic folio allocation speed
> - Using HPAGE_PUD_ORDER in debug_vm_pgtable
> - Address some David's comments,
>    - kill folio_alloc_gigantic()
>    - add generic cma_alloc_frozen{_compound}() instead of
>      cma_{alloc,free}_folio
> 
> Kefeng Wang (6):
>    mm: debug_vm_pgtable: add debug_vm_pgtable_free_huge_page()
>    mm: page_alloc: add __split_page()
>    mm: page_alloc: add alloc_contig_{range_frozen,frozen_pages}()
>    mm: cma: add __cma_release()
>    mm: cma: add cma_alloc_frozen{_compound}()
>    mm: hugetlb: allocate frozen pages in alloc_gigantic_folio()


Any comments about patch3/5/6, I will update a new version in this week.

Thanks for all the comments.

> 
>   include/linux/cma.h   |  26 ++----
>   include/linux/gfp.h   |  52 +++++------
>   mm/cma.c              | 109 +++++++++++-----------
>   mm/debug_vm_pgtable.c |  38 ++++----
>   mm/hugetlb.c          |  58 +++---------
>   mm/hugetlb_cma.c      |  27 +++---
>   mm/hugetlb_cma.h      |  10 +--
>   mm/internal.h         |   6 ++
>   mm/page_alloc.c       | 204 ++++++++++++++++++++++++++++--------------
>   9 files changed, 271 insertions(+), 259 deletions(-)
> 


