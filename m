Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 884C4E8B383
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 02:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B26FB6B0005; Tue,  3 Feb 2026 21:04:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD64A6B0088; Tue,  3 Feb 2026 21:04:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E07A6B0089; Tue,  3 Feb 2026 21:04:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8BEA26B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 21:04:09 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 33CFE8C20E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 02:04:09 +0000 (UTC)
X-FDA: 84405129018.21.88A58F2
Received: from out199-18.us.a.mail.aliyun.com (out199-18.us.a.mail.aliyun.com [47.90.199.18])
	by imf24.hostedemail.com (Postfix) with ESMTP id C602818000E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 02:04:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HwBj3f7s;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 47.90.199.18 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770170646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBt7Z/V5pgKMFlIjdcHweNeN5RveOulAhKPeOcD39KA=;
	b=xKuGzlR4DAs9zBZ6StQy1eDaHRKVylvK3qeeCxUb5Z/bQfWhGra9E4rg5auTjh9TU66gur
	9wNDqMzpAKSrRuA3zU9CvBrwQL3tH0wA6IVWfyxyOtrAb9xoqZcdMZlmzC4OzIpPcH/yOK
	Z96jJo0MbuRv7RnALhV+qmcrhNa3A2w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HwBj3f7s;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 47.90.199.18 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770170646; a=rsa-sha256;
	cv=none;
	b=J9Vu9sXmLjRato5rGo0zIZD69sNnD05z4RQ7QG5+O5/kC5SQKRWSJaKatUthwFWnn0b9Lo
	luuFdFpMwba1YZzmsBeEA+NPGp8KJJ2eKV7SyjSuYNhVZtZAnvKRxo0KpWwqFCMjJRCg9V
	gXOg3LWgmpUlPikNW10Lf4aQ4rDtYDA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770170630; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jBt7Z/V5pgKMFlIjdcHweNeN5RveOulAhKPeOcD39KA=;
	b=HwBj3f7slVzWgweYiynPnrpx83X5/T1CWN3bqGvkCdNILR1vvcGOHgOtUs4qAZAKCPd2tBN54E7k/BtuTLKJrEYKjGrdyTm6LPCvd0OrP9hxPWHAjkUSHm8DRbJu6sT0hL7jrw+demfYagCNbza4hxLYaj73M3NpedI/ryZjjMY=
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WyUk0nd_1770170629 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Feb 2026 10:03:49 +0800
Message-ID: <ad71b58d-cdb9-4a88-9a80-d0c4339e54f1@linux.alibaba.com>
Date: Wed, 4 Feb 2026 10:03:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/huge_memory: fix early failure try_to_migrate()
 when split huge pmd for shared thp
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
 jannh@google.com, ziy@nvidia.com, gavinguo@igalia.com
Cc: linux-mm@kvack.org, Lance Yang <lance.yang@linux.dev>,
 stable@vger.kernel.org
References: <20260204004219.6524-1-richard.weiyang@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260204004219.6524-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sukobtsghb4b6mscsonicf8pdxkcfd4e
X-Rspamd-Queue-Id: C602818000E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770170644-53073
X-HE-Meta: U2FsdGVkX1/94gxBBm3OnCken00orMk/e1qXJkOrWLUmxuPA+9XrlxFOcUKzRhHVEzVCSh6cx8fB6z0IuJKYyHu/Vi4hQ0tXQM4rHu09be9jaHCds7yE+LVU9bFadIZGWoqAL8nkNf+zt/ekSXz7iUHx+m2Gq3TJdotdFmAGtNMx9E++AMW5v/nPXDjreh3ZdAo+w/oXSn/Nk2BW0I71SwFmpCjk578ksO4Dz+eQ/BjnfOCTbxKjxAGUlUU5F5Xj8MkVhoyhqrfMjDTsjiNQOBFmZuM13n+92BMXxzrOsqg9nxOE5I0BLSmI2Yjxhdhx6O8t7N6arrDQRqD+X+KsgK8YpbMKJ9tzP782FSW4GoiFjfoy7ov5w0rO88Jz2qql/08SygYltdndgEt7C326zS7Ho2j+HpbCJ+rxlEP7gfXfOW43FpfDeXLtJlrDWP2wJX/6h+X12xNA10/TWBD03aRfIfUjdQhvLMLNJykQS6ulNM+FHjaASkGkBqYmHQxLrGlVJwGq3xzZkWMvByknhmDJAS++oWAXz/8GSNN7WZ4znd1fYOo/wypBxUgwrExeMFJsiFa/rWzx34wN5WNk76mpfdEJfBy2MMYYwjXRyYGEf0em+X/w/IL0D6vTNCr8pOTPgzV1KKhl9QxPPvDbNZwa3DR8ulng81MsdxjRiGtEDtp1DUvEg1Pxk7PdZxUeC7pXpiie0AYu2i4OasviOk6ZjTX+P5BAGNYZO6NZNxty69JSl8s6IPLLRj86uqydA/+XrHdSIbDTjSL3ShvCmbcQZ6MobVh/wDEinSCPJ/p1iouwLIeNIxT4JSrW/Gwe/2bHe7H3fNVSVwfMSwthriIFsiSL4bEjqAAEfo7H9lN1+6pcT3fZCdgDU1BwfqGlob2BQBxL4It1KZDs1e+1bnjLn430aGYBxCgztJOOuoetJrIoBSkTecRatdMYPw1OqpeWmMkBgFzb2872X3B
 QBylgddW
 fDWIBOKMhrB5C7E4SPoim00cGmbYcS5MGsS2/lBCzXVnnhBOWQJPcGsZg6f7WzIvzwpoBheAq2SisYy63IamgBMYuLVGsyooJGO7HUaLlyGEr/DEt3NgvYvFRNdLSCKlmY/vNfSo/b76PC8GgZ6RiA69ZW2iptGtna8sVfWL+6XUSsSkcXgn3NCyp9V+OLE3Npw1+tLtkpwnqF+IiWlmCGs5sEl1c2NPsqYcOD7zE4qB3zxpVT5WVnzIWSqdU/Hth45F6FrHFLpG0IXYH8AoNriLpL87sM9Zde+ZCluPFF55iHqZWNFBH9QEQMOfbHVWmxbYMLJjATdObUhuXDuPe1ZxAmULvrV/Q/WPGExybLhsk9HNBZ2RMAG41VB5jXlJC7+7Yp04+vK1mUt96iKRzZr2C7nPTyfLBzpa5juyVeNjlwRSLULwwWcUo3jekBOkuSTD9iQAK7T4Ic8QTMm1Ry/62C0MEFtu2KJR6L54z6HkiXr4VtVTdSOxnC0aACYxJqQGC3VzZOTZqiGEcXKAiWHGzHu+i7M9DQm5sncz+hqDSK98=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/4/26 8:42 AM, Wei Yang wrote:
> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
> split_huge_pmd_locked()") return false unconditionally after
> split_huge_pmd_locked() which may fail early during try_to_migrate() for
> shared thp. This will lead to unexpected folio split failure.
> 
> One way to reproduce:
> 
>      Create an anonymous thp range and fork 512 children, so we have a
>      thp shared mapped in 513 processes. Then trigger folio split with
>      /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
>      order 0.
> 
> Without the above commit, we can successfully split to order 0.
> With the above commit, the folio is still a large folio.
> 
> The reason is the above commit return false after split pmd
> unconditionally in the first process and break try_to_migrate().
> 
> The tricky thing in above reproduce method is current debugfs interface
> leverage function split_huge_pages_pid(), which will iterate the whole
> pmd range and do folio split on each base page address. This means it
> will try 512 times, and each time split one pmd from pmd mapped to pte
> mapped thp. If there are less than 512 shared mapped process,
> the folio is still split successfully at last. But in real world, we
> usually try it for once.
> 
> This patch fixes this by restart page_vma_mapped_walk() after
> split_huge_pmd_locked(). Because split_huge_pmd_locked() may fall back to
> (freeze = false) if folio_try_share_anon_rmap_pmd() fails and the PMD is
> just split instead of split to migration entry. Restart
> page_vma_mapped_walk() and let try_to_migrate_one() try on each PTE
> again and fail try_to_migrate() early if it fails.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
> Cc: Gavin Guo <gavinguo@igalia.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: <stable@vger.kernel.org>
> 
> ---
> v2:
>    * restart page_vma_mapped_walk() after split_huge_pmd_locked()
> ---

The fix looks reasonable to me. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/rmap.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 618df3385c8b..5b853ec8901d 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2446,11 +2446,16 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>   			__maybe_unused pmd_t pmdval;
>   
>   			if (flags & TTU_SPLIT_HUGE_PMD) {
> +				/*
> +				 * After split_huge_pmd_locked(), restart the
> +				 * walk to detect PageAnonExclusive handling
> +				 * failure in __split_huge_pmd_locked().
> +				 */
>   				split_huge_pmd_locked(vma, pvmw.address,
>   						      pvmw.pmd, true);
> -				ret = false;
> -				page_vma_mapped_walk_done(&pvmw);
> -				break;
> +				flags &= ~TTU_SPLIT_HUGE_PMD;
> +				page_vma_mapped_walk_restart(&pvmw);
> +				continue;
>   			}
>   #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>   			pmdval = pmdp_get(pvmw.pmd);


