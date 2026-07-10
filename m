Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5C72C44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 07:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C68E26B008C; Fri, 10 Jul 2026 03:21:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3FF76B0092; Fri, 10 Jul 2026 03:21:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7E4F6B0093; Fri, 10 Jul 2026 03:21:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93E616B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:21:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B2B7140239
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:21:58 +0000 (UTC)
X-FDA: 84972022716.03.E3D51B6
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id 039D0140006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:21:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cLgn5iTT;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783668116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0jsS6CvIf8h9YNVfslpOzzkSogUyLYNAlZCZLFhTUw=;
	b=CmXprd+BeeHKR+hzQtO3G5mqDUkMwkKDvekpDMoBFvEYCUYatWnaiHFwe12wQ1C1pPj0oV
	aWpsi2PaVLBePzkrjGJpHFoBirkdT7HWIa57kaPyLNg151evljuSJqvR4rncs58kk0ipMY
	zEAQZWZoBlQ1nPydLKWSWzrNLNRg1tE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cLgn5iTT;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783668116;
	b=BOa39LRFM604LDxYbRqyJ6uXND39iefu+ZQ+IF4sKEjeIh7kfx5Je64+IFz1BLzKxKABQX
	VvaAp53FV1j/U64/jDvtL6ieo6EFi5Q9+NrLn+m+oYZTFyFEPLDlFyIfDeAiAN6LrY5ELN
	FlYUEFyxAu9tKxtm3+2OTrC7sJgtNzA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783668110; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=s0jsS6CvIf8h9YNVfslpOzzkSogUyLYNAlZCZLFhTUw=;
	b=cLgn5iTTD2YuDE+iAY4y0mVwudQ91u31OpebstYpQO0k4h335S8feSo69gnBLMQHbEvFqvtDqghYM9Mtfen4sY/wtlC7XX62QI+mYSDrnazYB2BZ9+P3JCE/uW6hnstUk4YUFN2o7SChgxwWt3dhwT+2OxjeKBsKGGZQSljjkFk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0X6n.faJ_1783668105;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6n.faJ_1783668105 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Jul 2026 15:21:47 +0800
Message-ID: <7ec7533f-e1dc-4236-99cc-6848d651976e@linux.alibaba.com>
Date: Fri, 10 Jul 2026 15:21:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 3/3] mm/vmscan: avoid pointless large folio splits
 without swap
To: Xueyuan Chen <xueyuan.chen21@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Barry Song <baohua@kernel.org>, Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>
References: <20260709145124.764807-1-xueyuan.chen21@gmail.com>
 <20260709145124.764807-4-xueyuan.chen21@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260709145124.764807-4-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pmd4p9qdd3867jm5yha6y9ya9u5xz73t
X-Rspamd-Queue-Id: 039D0140006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783668112-332640
X-HE-Meta: U2FsdGVkX1/X8KjU6MEGpJVi9QeThBfDpxruwyv+6ngKA3El5PTK4Wk7+FtGMk32i44kiY5natoCJoOcmbtY7sCJI8hCUfqjNtEHLZyPd0J2VPM9RKcP0wheFOlPMHq/JxUXHiTQxkJcupBk6e69o2GqN9+IBD7b9dQsRV0Q0F0vB39x0SfDLp0QOcZMRKfQ1eXuUDfi0yvXBhu8EEbJFZL//gtbHzTWFguGnYOWTSpeJ+K8HaNcMfSTk3PDvGyk+WFLqLG+wQKsyo+ZO2rSktGLEjn5EX7H0BQY6cUr66Hq+/5nXOJUr3RzTYYVpXEJEw9wCA8aodckUSYMaeZS7ngnZBesImXyPknHepK1Yo6hTuJK8AqywtN86Dd4YWkUP7DuJvgZuRVZ8+CUrXgpXYgwwTASJEHvW0QchE/EivrSoUrWqkUhOe2OoFl9R3RlMStF1n1gWfTyFViU61Zsr2sfBPCwTDYvJ3OZW2yRvVT5YJ/lLPSgrZNYQuT36dfnJT2zCJjmSBxsQcV/m58sw24Su7f9wXrJdnANJSLJ1aNlKLnol/ho4DB4U7oJc6SutNwRXDzDnbWYoTzYfCkUYIrrSzTDhtB9jUugwgI5jwv95EfjgluO1hCjXZxPuwaHyZNCr5aMEeP9b/JLpN6Q9lyl7DMgzYqz6AxCpjG3HbMiVYcXP0fp61w3oK67lSvnbrAUE5ocdScWRrWc21F/qx8WIk1bV9yr2wu/x9LWel7ObVdS2IQfBPq2NP43qFk2wI1jbtfrH2H0tBM/aSTYjMs/SSWmwzCbaQHAToB8LEAOHdS4us/FrFcuYz23ucFSZUxWuAEiYP7IabCyAjZf7MJwZHSnqYfpAv6Y/GAEAxTf8Q2rOR9HwlLAmyK9Z+6Drz/g8+0ZeIqsrrnVed3gSHVl7oVJnPk+a6f9qJOoA+u2brQWmxQMwCqHEiWokglh6jCbSGZBaT3dbv1OqTz
 dJuzDcQv
 Mp5xD/tjlSWhiDbS3KGCOn3ZqnduQdIh2l5BHMwxPudxxRFxYiPcJUOfp0xOlp2KdLvUjWtU+qUOUBkuRQ7mlq2MOBTw2mLYG/52l6qHa7V5crwIdk9cGYe6yF+R40bQ7zJq0XDI5aVUlRyqAjbHRSJb0PXWPtphRW6oaYBdH1OD+sLxqGGAVhDOnJeiMFZC+Rns5P02OVeTz+UE7kjBoJQvNj5KS1KDF5HLxNkMr1H7bu49IU/qsX69GAnnNPLGfe0dZ6JTD3OKM6JsGfddOqisdhqY/ij8u/XJSPTNmiT3By+V4jJYKqifCuevi5Wd9f0W9tf2bMa8AWLIltUaxvghF4cXARX6T2g/ep+sJmAw0AEWs8k9DtRnixbl4yz53vkAr2n0kIiPa+2tFI0SOLmUxJ6LXURK/W2sJPejuszH7Wwc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/9/26 10:51 PM, Xueyuan Chen wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> When swap is disabled, exhausted, or unavailable due to memcg swap
> limits, splitting a large anonymous folio cannot make swapout progress.
> The fallback only destroys the large folio and inflates split statistics.
> 
> Use -E2BIG from folio_alloc_swap() as the explicit signal that splitting
> the folio might allow swapout of smaller pieces. For other allocation
> failures, keep the existing activation path and avoid the split.
> 
> This preserves the split fallback for fragmented or partially available
> swap, while avoiding it when there is no backing space for any part of the
> folio.
> 
> Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>   mm/vmscan.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bd1b1aa12581..40340a88f78e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1260,6 +1260,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>   		 */
>   		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
>   				!folio_test_swapcache(folio)) {
> +			int ret;
> +
>   			if (!(sc->gfp_mask & __GFP_IO))
>   				goto keep_locked;
>   			if (folio_maybe_dma_pinned(folio))
> @@ -1278,10 +1280,11 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>   				    split_folio_to_list(folio, folio_list))
>   					goto activate_locked;
>   			}
> -			if (folio_alloc_swap(folio)) {
> +			ret = folio_alloc_swap(folio);
> +			if (ret) {
>   				int __maybe_unused order = folio_order(folio);
>   
> -				if (!folio_test_large(folio))
> +				if (!folio_test_large(folio) || ret != -E2BIG)
>   					goto activate_locked_split;

Like I said in v1 [1], please apply the same change to shmem swap as well.

[1] 
https://lore.kernel.org/all/6e89f868-ca7a-484f-aeea-5d8d029714f2@linux.alibaba.com/

