Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D23D606A686
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=f6rS3qtW
Received: by kanga.kvack.org (Postfix)
	id 849446B05B0; Mon, 23 Nov 2026 03:15:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F8C46B05B1; Mon, 23 Nov 2026 03:15:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70EBE6B05B8; Mon, 23 Nov 2026 03:15:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4AE0E6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:15:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D91311C423E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:15:01 +0000 (UTC)
X-FDA: 85465673202.25.D2D4EF5
Received: from mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	by imf14.hostedemail.com (Postfix) with ESMTP id D5EF5100006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:14:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f6rS3qtW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795421700;
	b=vYRDCYpA8yfAE0LeoKpuii9Owkgy5/sZW+wDYzeUt4oX4XUG8UaVZMHPhKsRty97usLNlu
	COEaqAHGfI6x90Ncq7ITP1SPjI9u9uT5tsWhu2i/HSN9h/3T/zGyIwP5Dd2hbRLiyvfzBT
	8D8c4GnOsI7FQSK0PkFzQy28kQFWwmo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795421700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gaKscylzVA9L6Cd/lM7nAM+V8+V1ffHPVI55bUnkh2M=;
	b=5Eo1XNGLe+aTxC4m2zBKo5ngziixyrYpqkd6P+0tnUNcs24xiVVooEVIG6Kg55eKCnifCy
	IncOm8lv9IG4W2f54o6aKsq3g4uNZ+a7TtdurKXCwBLP81lRY7acp2ENhVYudr5BGJTiHg
	1EGEJzQ5sAxlq3X/GCeXcNTeARELDpc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f6rS3qtW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0his6L4KAv1ky0UJ0arlaVseKaKp+gf6jPobbtyi7KU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795421698; v=1; x=1796026498;
 b=f6rS3qtWqjwBOtLWmm8nE1rE++2Y0GSTfCCxuMVrMkr3vyVRt3kRH3OvuVrtug3cVKnPUTlf
 xQm1Xk+gTuTSUpXdL1MCiJOZCkJ/covQdEgUdlblHLBs0lgESrwIaJRCiHBA3LBFQt/7NbHiqx4
 2vq8aMYPTXqQ/enSjlFfq4kI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 87a4271b6fab09f6;
	Mon, 23 Nov 2026 08:14:58 +0000
X-Mizu-Trace-ID: 87a4271b6fab09f6
X-Migadu-Flow: FLOW_OUT
Message-ID: <5eea60a9-962f-4aa4-95b2-a242d847310c@linux.dev>
Date: Mon, 23 Nov 2026 16:14:48 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/11] mm/cma: centralize CMA pageblock initialization
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Muchun Song <muchun.song@linux.dev>, Li Zhe <lizhe.67@bytedance.com>,
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-10-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261120100856.16929-10-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D5EF5100006
X-Stat-Signature: kp39jamzxbxchjudio7wdt37htmz4s3i
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795421699-313526
X-HE-Meta: U2FsdGVkX19W8QtANZjD9yXyHBgd/5nNZbmioMQ39KmsVKbqdzv3huWSWDkfRppKS+tvU9hGI84wB5LbludhOLM/gPo30PhL1a7TVCEVolOIc1T8aa5ky9Hf7/GFqUvq3QrNmaKeXIiGLUB4MNwJAmJ83QGCwPI8ct7giT3BNihxKc4AwY/rKBlLrIc84P27hLEfMyM/JiMBz/kZOVNURSw3M2o/KzH4pCJ8GKDZXE62ZESTesMRB47RwAd1rltH8FBuY1b7MLNjdz2vmhCf+1EdEwNHg03CbRGMiA7/sYAbDxqPcOqJYroY9Edv6P36f6KE9G63veqPaFAd+8eHEZV4LChiMwngXDUDFgooRRGZmj9SE77vxw23fpta08Xi8J1zXziGvvGRgiug/0+PmxiSpHGMzwP07WZHYbcYEdEKQy468BVJv4Ykdyn+JRaX8qYtDtNFJ89y8qsJmdB4y8L7n1P24sVr6V1EZo9ABEyy02czNsurNEnAYlISX/OQk6sD493JgCvTXuLGMdl5aI4X12P6y2oSNPFEeKzPXWwWWBjNJ3Og3M0F7bgpffh5mlHNhAG60zcSasHlUWRyyS//MZHhC0kHpqgBQr6Qc3UqkPrf/6ixp1jQmhZtjKtHcgHLInS3bezzt1v9b3KVQjRG6/LEUT4IZ+IJsmUgBxvoUUxEmAMVqAyBmixCh7vX4+5KFAQQUlegZ4nm1HhA4fGKMvGZ5hPnFzNNmb1wila8rdanYCi2lm/rfsLgJXg2nL4qOzX+zzU6yL+GHcJjqR90Qj2L/hbQlMim9NLQrc0ElN59GzVgBhS9Ge1+/WOH8L5ke5pDqpXmTNeW5JLEHjtl7aSreS6KvG7lgG+d4gJJ5l0I9CZctpGJPAPrsVQmP+o9ungGOzPYV8vP8bg3rXTvV2Hm7NfRV/1Ev/uHiyCRpb3xrxtqKga6IeCeSaa/hLK+g1eJW2T6lffZfXP
 qH5uRf5D
 L0fsNM+DYo7afy18cFDl8pBO22mzYkWNlNhVVFz3xdNPpA4Yn846YMDrOvDKP+ilArXOcnGjohZm9yeR45d8gSRT+6M9k5e5asyGCma6570+h50KEj1pOLUeZLE5mJwfpNZAvc9aLRASnL0rG9wLZ4Y/RvA/9MnqzZmDUOGol4J4wWHumnFVbfb0AEGnpA0BdV3l2uVS4FcbD+8DcBpdD4F2ZC1fyOeCacoJzNdKL/6Va9WMVtfNtjrYprpwZVqczgPQHAEkgECJY4vXJwG5N5doZA2iSSjMxOmx0ooWSedJcNEn4Yubgjd5zIv4B+HYh/zYBPLFhhnWQRXPHhnDT96Mdgr4Hsji4z5P6GTDp+YFz1tOHoeNaaDEgtweUanig9eTqn86KLxL3fEXj819JI7I3pw8PTFuwOhFEgsbwqLaKA8tksfH0iDgLlsAm7bm9sNUaFhJrmFoQ+so+wkjeqUoylMwXQwoNpjGDZUivQlaCQVDuYt3gtObppvdbReThZ4Sm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/20/26 6:08 PM, Muchun Song wrote:
> Early CMA reservations currently require callers to maintain CMA state.
> This exposes internal bookkeeping requirements and splits responsibility
> for the same area between CMA and its users.
> 
> Make CMA fully responsible for the state of early reservations. Pages
> already handed to a caller remain owned by that caller if activation
> fails, so keep their managed-page accounting intact regardless of whether
> CMA retains the rest of the area.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v3:
> - Restore managed-page accounting for early-reserved pages regardless of
>    CMA_RESERVE_PAGES_ON_ERROR (reported by Sashiko)
> ---
>   mm/cma.c     | 30 ++++++++++++++++++------------
>   mm/hugetlb.c |  8 +++-----
>   2 files changed, 21 insertions(+), 17 deletions(-)
> 

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


