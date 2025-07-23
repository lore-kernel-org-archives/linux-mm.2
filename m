Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67559C83F25
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 03:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD6C88E0003; Tue, 22 Jul 2025 23:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAE8E8E0001; Tue, 22 Jul 2025 23:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEB718E0003; Tue, 22 Jul 2025 23:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDAE68E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 23:47:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 73FFA1DA9BB
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:40 +0000 (UTC)
X-FDA: 83694145080.08.CD211F3
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id A2F8540007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="uPQqcGe/";
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753242458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N/DvoaUV4XUMGi7Qal/jmR/yKHgA90VGC0dhsQsvKMk=;
	b=2oQY2qgqNs79TQXrNjs1AWm3IZeSr5nEczgUhW139Os8dqYm417McG6BvbZMzRQE457TkN
	UpL+/Q+wOjDaEbL7/FCx/sH2sRQ64tIO1u4swlVNgiPqy/CppoqyXG5BnhwBiPYu1KKen9
	NnMaF2OgDm5AptmtiFMY7I879nizqWw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753242458; a=rsa-sha256;
	cv=none;
	b=DUWYubJAkkgorIFkX7LTJ5M/7QLj4d9jwdb/09/yKrZ4wA0i52QFfX60rk316tlO/gvsKc
	A8PTbXpMs4TyaZX5IpOh61B1ZkNlwSAYC3tgE7cUeKRLgQHS+SZUFp8jVOTfpnEXrvdJvg
	QNqdUWp+DpL3l44utsy6I9HaT5Zzc3o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="uPQqcGe/";
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753242454; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=N/DvoaUV4XUMGi7Qal/jmR/yKHgA90VGC0dhsQsvKMk=;
	b=uPQqcGe/EGy5lWnJqkZWi9fwwkiM+npLlNc5o6t9JHt8I7qt32P7g3SrzVJGz5g7fhoF/h3jrKLy3BuJ5M21EKslv82p4Q75H0ACLRJGw4AHJnn9iX54x0siaaQ0Z3KDfW1XM2C1v0MP4gFiJPF0R9ilg+HFFZG2QUaWWkw2cH0=
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WjZl5p9_1753242451 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Jul 2025 11:47:32 +0800
Message-ID: <65476b79-e493-4f09-ab6b-3748ab679429@linux.alibaba.com>
Date: Wed, 23 Jul 2025 11:47:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] khugepaged: Optimize collapse_pte_mapped_thp() by
 PTE batching
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, david@redhat.com
Cc: ziy@nvidia.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250722150559.96465-1-dev.jain@arm.com>
 <20250722150559.96465-4-dev.jain@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250722150559.96465-4-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A2F8540007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: bsrc8gso1nk13mptu77trfbxnok953id
X-HE-Tag: 1753242457-578707
X-HE-Meta: U2FsdGVkX18BomhLQ5sUGm4lTFd/ilVeIr9lJtUPnkVKMM5N+qKNcTdNnD7Gz44xNxws/1T9uHwd0udIFIB3xV6vIQb2cBnAVgixruIGgBrhxFtOLV4IEyx+tbDyW/NfmgPTiSZdJV1HYO37edmqe6saFtlm3+chmOdKu/BEHExAqxzht5maBvIV0Ntzt4DdMOmsc0MOXGfBhv+nKU3gCdnnRNYPDhdUyCkjJnkFn2w0OZhiAVJ+6oBrNWxQ7ViHx5joadSLyAeZcu+SUsLN5rtTpjpdpkg5bmyTvwmwubnY2OuPsUGgN7l5+otIslJbXa9V007tal9d9RcnocQSpe29/LL6796PS3YllUjdSsVn8Gnom3vhD9BDrUIKQYgl8nFnglfi1UHvhpBTTBDy9tlhdjUBDaqne7clWIUMC37sm6RLqj88MKw59xrD4lhqynpxIl/tKSSt2142fNFT2xCmcGQ1NeKSOpJccI5sWn4fsjT55t2/YdQJYTVT6QWHlchvFYjivi4xB2bEqvuQqV8PGmCtNLBCUz7WcTaFGBsI7eRY65ihlspNBld+IDOVAVOCXzKWwxdNhIslJuwad+9TYDm8KS3IZj0YvdRpN19WE4DnQfwFhLdOqCZm+/Kn5QFR2It2k6l6dAIKNRhjseydVl+6r2hNdjCBzhDR8ckDa8aX6h7bSJ8TJafBayt88qYZazvzCE1tMoWGZs2Qc9yVLpB4f5Za13VlO2ih5ZtW/sWN1fe3ocAXteqqosKMgZnuFSEm0lbdzeMDgfohb1tf5nxT1O4Tps2JKnvNjK4aPi5PTQepmvbDEwZ+Z4WoRRvtKP8JgTcinjjbs7NQGWBC3s/+1WZaVdRiWX5PB4iF+18lyVbrRIWaU0AewBgJINIvzlPy+Qn/CIu4ObgK9qigZ5dgaOWyTaPJx1dIssKJUw832zjqXhOoGEfzKudcVk6x5+0SZUCOogeCrnE
 GRAs32sP
 n6DbqeNppZ9/EtTMm/Dv1SWacR7rRogItIZwD94zsL4tvfFqp7SgGUWAdRjmTyEXgFc0YPmrZbv5ZzdMaS1y5Vjmhf68vBNpfvMcVRzfZH2tlYq/Dtai3pLt4mU+ooHqa8ozc756QcQd3B6KHNRdYKTR/xurmj6vQFnfJl11//E4TLxDlxFGvmpWAZKYs1VLP06OtcTtKYW07WUbabTkU4y13QZmRa+mecK3nSh1Aph007qTGFiNtHIECrZL7mmFIqumhB7Lxttd/etE1HMITL/xk8LlW7V92FNeEXGIgXdgSGvxeXWPy+XF3NQrvRuD1ebGZ60l8yUgXGlS6PYx+konGvmoQ1N+E6aHZb0txzU8CzvV2aYrOjzke1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/7/22 23:05, Dev Jain wrote:
> Use PTE batching to optimize collapse_pte_mapped_thp().
> 
> On arm64, suppose khugepaged is scanning a pte-mapped 2MB THP for collapse.
> Then, calling ptep_clear() for every pte will cause a TLB flush for every
> contpte block. Instead, clear_ptes() does a contpte_try_unfold_partial()
> which will flush the TLB only for the (if any) starting and ending contpte
> block, if they partially overlap with the range khugepaged is looking at.
> 
> For all arches, there should be a benefit due to batching atomic operations
> on mapcounts due to folio_remove_rmap_ptes() and saving some calls.
> 
> Note that we do not need to make a change to the check
> "if (folio_page(folio, i) != page)"; if i'th page of the folio is equal
> to the first page of our batch, then i + 1, .... i + nr_batch_ptes - 1
> pages of the folio will be equal to the corresponding pages of our
> batch mapping consecutive pages.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>

With David's comments addressed, LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

