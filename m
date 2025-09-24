Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ECD0CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 05:51:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09118E0005; Wed, 24 Sep 2025 01:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0D18E0001; Wed, 24 Sep 2025 01:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1DCC8E0005; Wed, 24 Sep 2025 01:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C24458E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 01:51:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F63A8786D
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:51:33 +0000 (UTC)
X-FDA: 83923071666.16.F57F585
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id AD75920010
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:51:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758693091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9V/zklm5pjGq+V3PZ8nHe30I+uskYxeOkBeKxTBhA70=;
	b=QlYYMX29JfD3QbtTvClrJodfql0asLMsr6HkizMLqjolYLPLB1y2lIycn1M3CXaFnhL5gD
	ToRS5KRWtku2lzcHZH596gZ9RGAVV9IjNzq9rNAZ75cfRl0oyfvxMRE9H4dGKIqIEpJmUd
	fNOnh4VDcMfCtGSMz7E3pLoXLTuV0LE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758693091; a=rsa-sha256;
	cv=none;
	b=PQxra/6+wp4DYKWDSuehyuuLK+jClZggJzjqpNVastf83KiF3rD+Kb1Nzmfzqh9J63oFjc
	2nzKOmaFkarCYIMF5JoZ81Rqwev7b/fwufquLYos9OuWGgLwp2dU175dm1Xq2xBqmbwPOR
	WDLY9JukUG6jOstUpvSiSbsUOI8NGdE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2528106F;
	Tue, 23 Sep 2025 22:51:22 -0700 (PDT)
Received: from [10.164.18.52] (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD0733F66E;
	Tue, 23 Sep 2025 22:51:26 -0700 (PDT)
Message-ID: <3db68662-7082-44c8-b410-00322c759d08@arm.com>
Date: Wed, 24 Sep 2025 11:21:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 2/2] mm/khugepaged: remove definition of struct
 khugepaged_mm_slot
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev
Cc: linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>,
 SeongJae Park <sj@kernel.org>
References: <20250924004854.29889-1-richard.weiyang@gmail.com>
 <20250924004854.29889-3-richard.weiyang@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250924004854.29889-3-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AD75920010
X-Stat-Signature: sda5kkethbyswfptpoyf4nswzi5shers
X-Rspam-User: 
X-HE-Tag: 1758693091-318948
X-HE-Meta: U2FsdGVkX18yFNTwPfxKN7N7ZY0YqEFOeUJhAt9MtrXlH4kwpvwtv3NbDn0ni48MXClDr3jlOI61iqm083DkA9hjCft7qQJuh7ghlCfe8A4rmUqEIj5ruqGFuC9hRuCi2XNDpIbRpjjRZUmZCvOwToiGmJryVsfwWikHXI0MMMSf9pRbgB/Bg0lSLGVyss2/tj50I39TYyALVZoezPFSB2piZhYM8f67vNkfC8/wKi9yna3P1XV+i38thw88WvTnuqtfu0zkgZho6dFI+v5pizYWjga2j2hmQLjETVu99GwZSa4JCTn4dQLx5lP7j1VEXRv5wGJLhd0Cl4iGXX5vm2W8JBFfCv9RUPFZvY3Y9LeUQEZqkzk2yydvvZAfjW97ZAExrejJUVWAmsSaHZ+dyhEZLLsvp6BlY4/JfEdpdT4BdM0sknV9PTTAIi9FhRIa5/BqK3wkfAvAozQ430jo8oZi5jc9iBhlBX4lCjiep5R5r6pFkq5lc4BBs7FqpR+WNCv67RwqeYCanfsdjL+JbGMuLDCbWuoDJAp+zdL+efEAqTST2Gej+uODkpy2Zkf2SaD8QVgdoNmT9oPBfqARrqQ+B85fw+U5iBHYNe5UOdPimYJeYURm5TtAa7HOXEi7UeR3rD1Df7GIbBM9tGRd/TKtn0n6q6dEjUnt2A00Iy81bzlxMR1znZZwrPbGKnW8f+KzSONKdEx4HxHq+3+FF/vqCpNZtrYFK9hsSYYM9YFlIWXb6WMwkiiUGGYQBqRo0Zcx+SzHt3iW7aWzH3lgd+EOR3PTlGfiXVIpX4REGI52LpABndrbU/RipwoLrxTTscRAygz/9aQHjafhoEWbkeGS6dTRR5cmfNmTuubovgxnVt/sQ2O74eTipXGZ8VsA/1nyLiPJw38+8IaU+n60kAGAUp4cBjH9QonkLA1Bpk6iQew+3GgL+i5I5vjnKZeyibN2bQQ7m1CdRkrFhQ7
 mVwUim5m
 WV4OaAzRsQ66OktgTbK3TSrlB5lfaX19QWJmK5FwwiabUA096DeHyu2O25aSaOTPQhmQ8AvHXAAQiYPE7JgFyBhN/f3KfWtA9P9kGOYOKP5fMLE9yFS66hr3ZfKTXkF9X5Br77g+dSZFM+ljZszzhUKhJIeqhn89w1MPOuXC79lQQtvxiZwXgRxOAmWs9SOLpCaSc/LK68p0deIK5a7EXiqwN1qcblngSJ7g1GJzGXaoYenNcLhRZwwxnQqELCbUQDfYuUz18KAphnn1AtdkaoFEnLIg0j5Qa2fBGreI6lU9V9oZ2OQcHIo9jox8KDQKBrnzyOOB1V4+Ua75h1e5ufLh6qEOmXUwEw2aem1GKJZX+eb12UidG8u1Kb8iI5p6/CsxAF0hs4/ukh8jlyeNnBmka//sOmQTpJ2VsAV79Xzg0wuAT7wtSdDIMmWqlAfSU0X+zmzP9aW73s+ThNosMkT5i1udwYH/2LJ8A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 24/09/25 6:18 am, Wei Yang wrote:
> Current code is not correct to get struct khugepaged_mm_slot by
> mm_slot_entry() without checking mm_slot is !NULL.  There is no problem
> reported since slot is the first element of struct khugepaged_mm_slot.
>
> While struct khugepaged_mm_slot is just a wrapper of struct mm_slot, there
> is no need to define it.
>
> Remove the definition of struct khugepaged_mm_slot, so there is not chance
> to miss use mm_slot_entry().
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Kiryl Shutsemau <kirill@shutemov.name>
> Cc: xu xin <xu.xin16@zte.com.cn>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Nico Pache <npache@redhat.com>
>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


