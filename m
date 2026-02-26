Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09EDAFC5913
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 08:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30F6E6B0088; Thu, 26 Feb 2026 03:55:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD376B0089; Thu, 26 Feb 2026 03:55:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9046B008A; Thu, 26 Feb 2026 03:55:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 05AD76B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:55:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F1921B7993
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:55:30 +0000 (UTC)
X-FDA: 84485999220.05.220FCAC
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0319214000E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:55:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XaPtPOeu;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772096129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+s8ajlX2QcTdOYbVJGf1Ky4Pkxf5RlbUW07y7TzjKU=;
	b=yL1MHNHF/UMc5AoUBx8Yd2Pjw9z7TYmuDrJu2MCAgbQ7tTmpi/QUa7qn5RCganMmtNMbrY
	fpqINRL1GAVEDUFjPLzfCfuF6Rcd/ENRf7Z46svEk4FckhiUwSXrSC9OmKxl/8jTx9ImAt
	oFDoWZXvSBcZJ1g7hUYrcn0w5Dn0qa0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772096129; a=rsa-sha256;
	cv=none;
	b=mYTjE6ML1M638VfjqpbjGIPrCWAg+inqroUyz6+jaFxUp1WOsA45zTGC4J5ZT4eWyXCzWf
	QCPcMbvGnmiwKtnFllu6qt3VT3eXURwvmGrCIs7Yw5AiFUcm5VY3jyqkx/YrRP2u1trb2T
	3/vgmQReCht8l/CJj7AKfZAToqkG03g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XaPtPOeu;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772096121; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=W+s8ajlX2QcTdOYbVJGf1Ky4Pkxf5RlbUW07y7TzjKU=;
	b=XaPtPOeuJb7STliqL9GjFZB8eC6/ENUWp7cQmOWQ1XHVuMCObGE+yAM6kGU0O7Fq3Zyq9ggDMDqeIyK2Tv5fdLblYkdjS3MDxCPbofUcLIkeRZvH3ZHewGR3WS1TDcO+xMTUhhxumt5d4rL4cFSLBbU+r4WgviRqCF/5lBAt170=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wzqh9SS_1772096118 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Feb 2026 16:55:19 +0800
Message-ID: <c9c250de-742b-4615-88b8-95ea7e6dbba8@linux.alibaba.com>
Date: Thu, 26 Feb 2026 16:55:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v2 2/5] mm: introduce is_pmd_order helper
To: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226012929.169479-1-npache@redhat.com>
 <20260226012929.169479-3-npache@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260226012929.169479-3-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 9ri11p9x1gsg6kwhg7xw6guq7oqf1anr
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0319214000E
X-HE-Tag: 1772096125-823962
X-HE-Meta: U2FsdGVkX1/4+sxBFXxXYT7GFNzMOvPvezoQt2ljGxFfa5d+MFqNxHod3kv5D3KCPV7bCeNJVgLKgAWLM9XdvGCfQd4z+eXoG+i7hQFlQwqr8YIWRXwmgtmtnd5QF1Na8nvoiW5evIv7vjjGyKwwyFx5b83yjc7LCrMohGJZhq5VPjw5OV/pS2AJLVOCPpeFyAIlQittZFEJvXoiqS/xPnXLNOUYFDft8VzbzkXdI4pGkSKEBncsVzkrSUj5lyhijIuC03OfhSDRt6CeE9lJWf7MtgmeRzC4RguB50cDRuTd7CSzxMKQbT4TKbPUVZTQbonQMnb51J3vlNnvA3WZ8uS1OYsys9n0R4CK3z5JR4c+jy1C/FzLf9eAwavLvvmKcUMn7HH/99+AHe1jmjjpeOCftO/UqPbyHJmbmgYMcCt/dlMgJyi50OYo9UT5pXivl5TlwLvHtola75NZk3obxO5rbnYz622wuCXQZhYJ66/5RlLIIdC+7qfwDrCTPGn9g7/3IIl+vwTPRT8IXBG8mczmCbHhhaI3qTsIbvEgOBbjQutuLBcMkvWhl+gZZXaH5F4h1ZVA3xcC+3E5fQ3PNKQcHo+EiIbTUnAsulCGk/N3dJ0bBkqHuhDKKu2SF/7IcedilnLcGfyQOSIvf+zNRQOC7a7zwpniGiZD/nBrR3xs4tWIVQ+DyIjGEPaH2BLYjMWu0rwe+bmG0ZZxejewzxkTIK0CHeynAqwMk0Ts6+tVVcCB1LWTl6TJT6fYVrgYh2770bc4Ume9B1HurxIuUt0Cug76DOCXgoaTYu3j/0djioB5darObjAauMJuTe7rp9vNKSb2+RT1xIjTnty8VaW76HkKFkNZhB86vY/bmEEbb7tJAGfAeYAijMhzrdPP2nw/Z1bCgodKAy7r5Q89Vw184M4hEf3LqAYzL5NB3SbhVhB8/a7IIhXileVePr4rAFlIVupwo064Byvou4R
 V0sw/OoO
 RC5LiPNrTokhqy8ihEB3aseYvUmanVtboRPd33uJneTD49lyfrtSgxMcOtGZGBkrprj+jSd1YZj1ZdORnQi/f7qgePUS/JMLWU3qZJn27kiNOo6LqQDqsPKeJy01M4uwsGbJBlFW307is0ijQ+ooitst69cND33X8qtaeCwpH2kEOuM80il6f0UNQfMP3lQBK1MvJyf+CkR1uyDZJxiiVASV45FssyYXW9TxYQbiYMPAksyBwMGI4to6bqR6iLzd0K9u8pOQsfU2UjCGiY70Lmgzz10Y/3GM5pJsv6xivwKrdLibL0JwzrOQVvzxTYwfGCmXPhDHwCQq4yDQeBh/PX+OvmRCnV9B5rD3znFgbwhUVMa78nUjos0izq+DRF530RDWz88EqtjdR0nEMEV6DH21LlzVgK0BxDqr2WjonQE/r9fqIip0J+em0IvCks2bWaIX1ZCPkBOSH6L/TWGGs+35qOw1d1exov3ajcGMFa+Mms0V6FuZPT41f3/bmslp3aLiNMmd/CFL2Cz1P4smEtXAbKXHIrusl74t6x8J3QoHZvCRH00hIM5Z/1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/26/26 9:29 AM, Nico Pache wrote:
> In order to add mTHP support to khugepaged, we will often be checking if a
> given order is (or is not) a PMD order. Some places in the kernel already
> use this check, so lets create a simple helper function to keep the code
> clean and readable.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

