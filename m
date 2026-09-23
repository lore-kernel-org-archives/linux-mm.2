Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72B4BC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6988C6B0088; Wed, 23 Sep 2026 02:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6708E6B008A; Wed, 23 Sep 2026 02:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 586386B008C; Wed, 23 Sep 2026 02:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D99E6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:25:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4680C0544
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:25:33 +0000 (UTC)
X-FDA: 85244040546.02.020E771
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf08.hostedemail.com (Postfix) with ESMTP id 12AEF160007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:25:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ADpetL1X;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790144731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D9NFy7AB+YED6sFXcPgfcOz13XtdS9fxqd/Xeu4Y7fo=;
	b=lRj13rxtTcDUQ69zyd9pchoUtGtVbNrSASlBG9f9mPz/TDEGBVJdLqlpdUYvczZ/BuueN2
	sojcS8OdiFSdYja2UHtXje7s2AsxCvVuSq8J8NCH7x0QS40PZTKTjtnfUVfHcGvJc2LdiR
	y58w4+4/w5cdxxw/K3a+H17qp7xEf4k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790144731;
	b=Ztl36PETqLNHkPwy2EZCyLeXwpLhWolRU1P4lX7U9sO4RbEILzR0gJPSiS/HWyOCkA3AEy
	39lN/OZBEZ+sLLCPWsiNPmbEibLkVsFk7LSQjL8CHz2Tt34l3vyMQ0wGZXG/TcfPHhtc3z
	5CMr4YbwRkWa9oINMM5aKCXav0X7hG0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ADpetL1X;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790144726; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=D9NFy7AB+YED6sFXcPgfcOz13XtdS9fxqd/Xeu4Y7fo=;
	b=ADpetL1XUTnREhm9acS8i1HwvFXdh8OM0fxNq7194C3cPNr5R7MBVHW9WRqIHpBAFE1//0Y6GC1MkGD1d0MZxohbenTDXFBRJsZ3zvWJwR3U/5mJZAaOpEWbhoJMfb4IgK1dwszKJFNiK8X9xLfxZn6Ypiwzcd7kURw0TkoLqas=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XBW5CM0_1790144724;
Received: from 30.74.144.107(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBW5CM0_1790144724 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Sep 2026 14:25:25 +0800
Message-ID: <c551f404-f3db-442d-b101-f21c78c502bc@linux.alibaba.com>
Date: Wed, 23 Sep 2026 14:25:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/19] selftests/mm: stop khugepaged during the
 MADV_COLLAPSE cases
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Muhammad Usama Anjum <usama.anjum@arm.com>, Usama Arif
 <usama.arif@linux.dev>, "Nico Pache (Red Hat)" <nico.pache@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>,
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Michal Hocko <mhocko@suse.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, kernel-team@meta.com
References: <20260919002451.496763-1-kirill@shutemov.name>
 <20260919002451.496763-7-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260919002451.496763-7-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 12AEF160007
X-Stat-Signature: e3y6pogbptchayjw5d9iw9ssbn7p8yxm
X-Rspam-User: 
X-HE-Tag: 1790144729-437385
X-HE-Meta: U2FsdGVkX1+J8DD6UFqHJH4APrLkPaM82XQicRKztq7r/9PZjEquTCJ3+nKYIbx4LWiS2GnJEp+18FxhowV4G9Bq0idFKntsC0m45eJ/tVQcL1MTSxZRudhh/ACL6oYZpo08qMIUQ8XaEE6hlUBWy8sNP+bccKHakg1oKvuaEiCVvLEmERWZsIVXjvcq21ADFnrQ5UKEmOe2RgoK11vU6ghIuuO3PPZv7yM1vdZFQgEA5xSNAxDqccwrgKWkC/yuLQnj1ilELDpwdcVQxDobvPWNPpElc93datTXYGa3uYi6JTjBj8g6CoWoJIRrQXQNw//Md2SNRCj5xCHM1d8rHIi2H1mEsylVi/r/KAzIsESCFlOHy/fFQOf8HgylJJMwkX0xayemSkwkL/DzY8qmjDYHfTxKVWwDB8TTarlqCO1ni+XxCAMhEAsGb0sHNMCerRzq+9Q9QdSvAAsPTY1GBf61aexXzCX77KNpBJt+eucJ8Zf/JBs9ev7zpKs5sF0GPj0C2OvCwfF/MvC8e8W1GuNeui75fTFngckCIstkFPY20SrJJzRTxoMsng2Kvye29QMykdPt4tJBkxm5rAwVadbuRkjj6D6kpDtrLn/BlcMEe1OwjEGI8WkFsq3/JtzUawsWtDewUJQwrDbaxrG46ycRzrgH13d/67MCpVy1IqzVec1IsJYahLNlwP4Jn/XFCtEKOCAv5j3Bdd5voCzPh5im8LmAw+h6G+5ACJ19bSIhfG1vmX7LG8lBdEpnHt1nvHvRGUrJyDcobSlg0NOqZIE2eAEeStEM20FYeKzRHxbidq1kt+DlWdnpjQsgU1RQHDSfDS6dAI8D+3p5982vH16GObmFGVBR+7YvRyeQAjtQ/GQEDWBqFhKZz7S7WP/Bo6qhZZW7jJ2mtR4JTgQevUvN/KnBgEXrIzmKRYguayoL02QE6EOJQx3lPakvU0d0MBkjjvvzSOWXEmcCmLH
 GRLpGAis
 U/aiLdoCkZqUOINmIaWr40dXcKZafxcMCErkJKskvHIqjP300r6Jjz1FDPYOnor/QifeuQ4PgqYez6uRwF1bN/B77GDzer89uYThH/CefH3opU9JlLsHyrfbFdLPr4Rr9ybbIT/+OVOTv30S/7SUBFm5LkMr/yBYxgu9FFcCz0xZ2lZ+t54EC9BZ20q6q4afqnTlm3pgQ7HoITbfJJ+Ubvt1SI1hNrdf1ePlzkDm/sLxSodpaMkxzeOrCLCecj5uI+hvjPmnwcniv3P89XoUWIVS5JJ6Iuaca1DBb7ZODVPtILsaG7YV51TtvA2sXR4psUxyWFt4Bq+sA8A3hPolPJG5anyMAunUahXT5kNMNn2CmQfPJQt7Fvkfz5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/19/26 8:24 AM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> __madvise_collapse() turns THP off before each MADV_COLLAPSE, both to keep
> khugepaged out of the range and to prove MADV_COLLAPSE ignores the setting.
> It clears the global controls only, which is no longer enough.  A per-order
> control overrides them, and -s, which makes the cases fault in folios of
> one order, leaves that order's control at "always".  khugepaged then
> collapses the very range the case is working on, and the case fails on a
> collapse that was interfered with rather than refused.
> 
> Clear the per-order controls too.  MADV_COLLAPSE does not consult them:
> anon never did, and shmem stopped with "mm: shmem: ignore sysfs configs
> for shmem forced collapse".
> 
> Fixes: b7f16963efe7 ("mm/khugepaged: run khugepaged for all orders")
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

