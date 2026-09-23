Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50450C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:55:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF456B0095; Wed, 23 Sep 2026 02:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0856B0096; Wed, 23 Sep 2026 02:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A3386B0098; Wed, 23 Sep 2026 02:55:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E87F46B0095
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:55:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DE771C33CD
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:55:49 +0000 (UTC)
X-FDA: 85244116818.05.A2C4B4F
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3717B4000A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:55:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Xb6HfC2S;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790146546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MSHfleQDJgNVV/fzOPiv6iN0a6sYi73P6TvrUGvr60g=;
	b=nvT+HaYUgcW+4Ive78p6aav7rU7hL8OMVvvWiy2Q93mF1hIdPgAG/C5I2kolNBwNJqw4HA
	zFiOES/gomMrapNEthwimHTIkEoA5gjdvgZi8n+0FMGTdiDnSI4hiebZAa7yErZ1DyYDB4
	AtNYRImAieZ5hfbe4kB/v+JStfRnU3w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790146546;
	b=YqY/kM0I0j8JqQKPCgeZreUzuYfWa3Z1JFlpOSgg2Ub5kJkalMLIB/3Nh0YKcd6CwbyJYK
	NDyfBjUaDmkwm5oeeY413QB9iAzKPeAWqeDPZQnzRcUyKkDWKiCfIP5PZeVxc6tz68I40B
	wUNBxVjsvfRaDuWsyn3HuQ9DVNV/yik=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Xb6HfC2S;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790146541; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=MSHfleQDJgNVV/fzOPiv6iN0a6sYi73P6TvrUGvr60g=;
	b=Xb6HfC2S0vQIPGUSR0vVrA1rsszu9tYXxDvLfsxZ8leb+2Fy2xG8nsQwNot0mknCSIrzm7Fn2aH5Tcw5/2JZ2Ui+JTRpnrgOZsN0YpDFsSvJm+F+Ez1m4GmXWtu6FnZun60AnYUdhiXkwQFg9iXfZ03PvT2o3d8m3cu8YDwpP9E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XBWAyqu_1790146539;
Received: from 30.74.144.107(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBWAyqu_1790146539 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Sep 2026 14:55:40 +0800
Message-ID: <ea81ccb2-d316-47fe-93ae-ef32af2a7330@linux.alibaba.com>
Date: Wed, 23 Sep 2026 14:55:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/19] selftests/mm: parameterize the mixed-source
 collapse case by source order
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
 <20260919002451.496763-13-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260919002451.496763-13-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3717B4000A
X-Stat-Signature: knrrf6seai3ibg7oo8jjht5nq98edik8
X-HE-Tag: 1790146544-606951
X-HE-Meta: U2FsdGVkX19KtE8yksXLWfn1PMgES5e4MwTeQK93r0gzULQ2qAUUnPLJICnVOZfue8En2NPZ1QvN7pseXMJsR8t33/DdY8ai6/tcb1vNaKAoDuI4mkLzLr7PNBslkvEd7fDiBEuGMvqoxpdP55pPJwgdfejTfTHLwn5S/Z1p86uaA7G6WkilJwMLx4sy1QL+s+fDWpF22y3uR1R0tSoNrGOlh1uSxMvHeknKH05y9RVSv4lC+ijdLCulUB4AGdQ8OXXXpoNxZhZH6Q1cBtIIUNhEJWYpTw40uA25+EyhNAos3ommWq4O6N552Sncp7TJx+xY2yKFP2wz7d1iM1+cDXSgq0SVOdYomQQ9MTc14IZUxAbJXF7+I63OHr5x5utLxEqD6XBVo2uu9n+54wKoSYt/6teY+C5YJ6K9YZf1qoozc+38XH/F2c+nKGWlhng/8YV7Au3EsS94SdtHhwebktQzbqCisMr67NpbmsEn+tRdb385y8IRJUOQCF0dogQarbrcQpTLhqm+l1p4uliYpaKiPWSD/0Qb0vXIbdkEbYvd549ZoiB3E/cYmqEuqD4bBa1FSeIjLFd7E4QhCgxudVlMtid57nWnrDPm/eRoe/ysDmWJl2rpIifuxZnG3clqg/DJ6Q1WUjel7Jp0sNikxbFNlxR3kFscez8fnODu8AvXk/uM790NJgWMIkSEcy25LzNKCOL2Wo7j0AgcEZ4rdS4frR6Db4KSH9Q2BThuLdadqd5t8ykCtcPsVVpuzH5BwleLGy1f/2NM2tvAZrQFI632Xi7bFdt8eIT1USB8J/VxxN1jT+y8LBNyC0FeMalCZFC3NBF/emmZhi0yYdoxeZ6Jn65QCfj5mjdSNePOEde7X3azgpBvjfhS1In9VchGnb/pRH6bQV9I6Mq5d2ciqsdbDHXgHopDeXd0USTdPlqCM+B8U4chuxoqdl0drKpi1UOdPWtU9jleQV/uV46
 Kn35Rbwz
 vIDOmaM2LMmmjUWc95hZ+94XDwb8lHUHs0wYeM5Y8LrerNmf0blrVQT1eX+0E+0UzIsKhHq0D25kabAVjD/84JSh++Icc7Igtpal+mMqFoiaMADi8lHf64lWK3QtTft98Lwh9sj8cb2yZoi7bbp9So33f16i4mdNK50j+WVJS+7RoeEH+V0v0in8dnG21qTMs4Vp2hmPsfRiFc9YOw1ATwEUlowaRsd9Z86E+3xornRttIvWOsZ2xMZBK0ZlSlBVGcnCkQ0INiVvsuKE6xZtpHscZelpfqTn4hQyNVjmSH0RtEsrAOQql6xWKPNiMUU5ZX+7LemKm3gFpSlQTttSe3n96HY3fWMTSPpFJb1WYpKc9tuD/E3ljGYMbkq6OQ9aSp3a3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/19/26 8:24 AM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> collapse_order_mixed_sources() faults its region as order-2 folios and
> collapses them to the -c target.  Order 2 is below the contpte size on
> every arm64 page size, so nothing in this suite collapses a contpte-mapped
> source on purpose.
> 
> Let -s name the source order alongside -c.  The case then faults at that
> order, keeping order 2 when -s is absent, and the source order has to be a
> supported mTHP order below the target.  The other mTHP cases are
> unaffected: mthp_push_target_order() enables only the target order.
> 
> A -c at or below -s is refused before any case runs: the sources would
> already be the size being asked for.  Without the check the generic cases
> fail on that one by one instead of saying why.
> 
> "-s 5 -c 7" on arm64/64K then collapses contpte-mapped sources into a
> larger mTHP.
> 
> Assisted-by: LLM
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

