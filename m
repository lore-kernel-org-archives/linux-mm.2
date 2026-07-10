Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 777D3C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 07:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4ED6B0088; Fri, 10 Jul 2026 03:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455D26B008A; Fri, 10 Jul 2026 03:41:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E346B008C; Fri, 10 Jul 2026 03:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12B3A6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:41:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96C8C8D824
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:41:12 +0000 (UTC)
X-FDA: 84972071184.23.A5BA52E
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf31.hostedemail.com (Postfix) with ESMTP id 59EE920003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:41:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="IN5u/QlO";
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783669271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K4f52g3k8n6R01YhWkm7BaroZo2smbRn1rvCWyLLPxs=;
	b=YKSS7arGqeYprOVcv7zBfEhF0nXZuZlGnk3bJPwJm7nkiWVD/hozHpi2bNnsKODKupdmaC
	0kDiuVBVnh4oNxt8PzKo5CAPit7ap5Hcy55f3a/r4Q6WYEDsyxC2cAggcF37TxvICSiMlu
	nz+rxwRSN+WJHdO+vGPNAUaqDfxhfuY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="IN5u/QlO";
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783669271;
	b=VnexRgW9anYb5/13FzpDYxfCaqh4YCdHXBB1m2lYfv/Ku9w7gzAYxKHE7BVNE1YdLzhs3Y
	uQXXf7jU+sEe6yuIAkVkQq0w1tc2Mcrhb9U55B+hHaHJ7lPrzZ24IQmg9OgLQTVY8iELfP
	cIStARX2O7kwmNnqiYujHS1tiKTh5LI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783669265; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=K4f52g3k8n6R01YhWkm7BaroZo2smbRn1rvCWyLLPxs=;
	b=IN5u/QlOcoit2ggnJzSvotR3uZcIJ1AuVzKUTQsm4qNa7hIPskBtAdm/8Rtc6xEGSLY63VMl9dJkSek9tiYPyAscf3oTzpK+QwG2KZl89LiKQLsFjfiuuViusjcz+G2x9qyvsmJ1UqwmvisUbVFvr2FEaBq1eaSFJVmLVcd1ziI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X6n07c2_1783669262;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6n07c2_1783669262 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Jul 2026 15:41:03 +0800
Message-ID: <62b2bd29-28d2-4440-a970-526dd5d5bbe0@linux.alibaba.com>
Date: Fri, 10 Jul 2026 15:41:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] mm/khugepaged: extract young page check into
 collapse_is_young() helper
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260706154500.39178-1-npache@redhat.com>
 <20260706154500.39178-3-npache@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260706154500.39178-3-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 59EE920003
X-Stat-Signature: tghd3o3cs187wct3b49nmbfwgddrt96q
X-HE-Tag: 1783669267-341244
X-HE-Meta: U2FsdGVkX18FMiSVoeafiSxhpTPFp537nbizzKufZEdpY3bnzXcjwUHQtwpOq+zeyRkWzU0odiEYvVovPSkoFVoTTLwZU7RTu8hFjMFMMqb8W8LVyoUpWq7A/8BF1Wto4jnRHwQmUSZiBFNAoPudHJxNjMPVZI11Weyqh+DUAYljAJPWDnmC/msIsXKndRyWMF4P/LhiswzXkO/vtZbKo11+iI9GApl1yQUaZ+Y013Z9Yldu/zfJpgwWpAb2uA0U6yITM+412D+pUzyerb7N0oG+NWip1Uqu99slX6NyMz/jgBQbW6/pQ6p7NdRMvDeWo0VQvs4ct8fpjWNa3zm3jDaSF/Sgqt+zMnPs+A8Ci75MClByXidFUxEbf5kHXrvi0HuKBGzPORjg0PW65UBg5kejw43HYUQlKsPMM+UrEGu1fJQdy02IkLmLtjxPL5ExEO8EyUcVOgk5Oha6VrcQhMs360jeefxMYf71aH+Y/a+UFTuhVtbO12AI//sQrVYtd2PBFsaX+ZrF4oD5yzoVY0PxrL9NoojFJ7l3y4nkmqQfHkL+hbhEgU0YTegyeXV7SoF9Vlwk5vLOTyWJSosb22/U2fPjT+P1Fvt3/mif5amwA0YTtjQaoyPGFGuY7dybtu/J60mOGQhzjNE9dtX9y5qCVWDm2Dv+ofL86sJm79G+TOX19jx0agWBp61to/YRVCwyO38+eZbTHMyGD48V/mCpj/h5r3AN99dyzCWj0EWOr37dB6LQKHgX+DMfsAHZolZXtZiDyMKw4haT3LPzhxQug4Gqx3PPJMFRvWJwLIDmoc25N8xySwpVqPtFMkTsr9YaU3KzF7J98dYmuVtRThlsyFc8g9OJSlLJyBEcygTkxs0OmS5g0gBI4JgA4p+x8a054kJ+QPcXOBeA7EKcIwB+GoCmY0zZot3hwgvh6orehcpWOY6Ym30tS5E0zFbFB7jkfWkt3b3Rsx2DKLc
 ndQ86Gk2
 JtRJAsMmaT56lEl/jTEopxaTW1cRCmvrj1FzISfGoUDI89/CQ4Wl3BzRtTKg+y6/gqykYj9v1YY5bvnrEzqK46muv9474liSx93K0dYWaDcnDHsoTnrXd2ZxHzf3ErJHgcGziioylWxAKcGNOf/srS91O4PkAGlimZRSKa/NAvww7nAsoRmK5PqIVaB8PUIWZmZWEki6OdigQZg9r9EiD8V+vr5dnUin0+4o6/7+reZS6oWQOK3Y2kHyUzq88Y1kmEBCcF++y16PevpEQQCpDxb9o26u/n9ONZWvlF+s4F0ZBIugvMsDRyjYNMBvIOd2vMUs3iFgS43eVgJFtGNZB+LXv9EqITdSxtwWRCsRKXGQgeLpnRYZtB8/cTXxh5AEXtswv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/6/26 11:44 PM, Nico Pache wrote:
> The change deduplicates the "is this PTE young enough to count as
> referenced" condition that was repeated in both
> __collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
> a single inline helper function.
> 
> Also move the comment and use it as the function header. While we are at
> it, updated the comment to clarify that a young pte is a recently accessed
> one.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>   mm/khugepaged.c | 35 +++++++++++++++++++----------------
>   1 file changed, 19 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b3985b854e77..48b008a3c891 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -675,6 +675,23 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>   	}
>   }
>   
> +/*
> + * collapse_is_young() - Check for enough young pte to justify collapsing
> + *
> + * If collapse was initiated by khugepaged, check that the page has been
> + * recently accessed (young pte) to justify collapsing the page.
> + *
> + * Return: true if the page has been recently accessed (young pte).
> + */
> +static inline bool collapse_is_young(struct collapse_control *cc, pte_t pteval,
> +	struct folio *folio, struct vm_area_struct *vma, unsigned long addr)
> +{
> +	return cc->is_khugepaged &&
> +	       (pte_young(pteval) || folio_test_young(folio) ||
> +		folio_test_referenced(folio) ||
> +		mmu_notifier_test_young(vma->vm_mm, addr));
> +}

collapse_is_young() is somewhat confusing to me. Would using 
'referenced' be a more appropriate name? collapse_folio_is_referenced()?

Also, it feels odd to put 'cc->is_khugepaged' in a helper whose purpose 
is to check whether a folio has been accessed. I think this helper 
should be more self-contained and focused solely on checking whether the 
folio was accessed.

Just my 2 cents.

