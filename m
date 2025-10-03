Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05D0FCCA470
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 07:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60F4F8E000A; Fri,  3 Oct 2025 03:55:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7A28E0001; Fri,  3 Oct 2025 03:55:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5240B8E000A; Fri,  3 Oct 2025 03:55:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E4D88E0001
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 03:55:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D851714076E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 07:55:10 +0000 (UTC)
X-FDA: 83956042380.13.4424436
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id D0FB81C0009
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 07:55:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759478109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZUqhVd7vcsVc1CWlD0NUVC7kP7EMWB7/YDrJRnN/yu4=;
	b=HwXIhqPBqtZvpmIgp4AvThyEuucYCuhkjrl4DpySK/bSiwnIlr80YRnLcMrblRSXDgVaXq
	XM3BAo7V+2uO7zEpodJfqy4eFqFS45T/h8/LDHax4hqCoCbEHMyhpdKvSHHMizPnGVSMpk
	5kvIcABzWHZZEX2S9Hz12dvDYaUlq58=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759478109; a=rsa-sha256;
	cv=none;
	b=LuXvgn9XFDECcfUG4u+r4GsSBnFaeggLXsLUEOBPVHFSVL4tIuDfZjyOpcLclkxl4Ruv+M
	wZgfd6SGc5PpF7A9kOFPMQReB8Xq+/mqu2YhrEuuBjmBHQUGdx/Jb8uh80tN7sEI2/21ox
	9e9JNpq6/LBALG70C43lmweuMC339UM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9CD081655;
	Fri,  3 Oct 2025 00:54:59 -0700 (PDT)
Received: from [10.163.66.2] (unknown [10.163.66.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 226B33F5A1;
	Fri,  3 Oct 2025 00:55:01 -0700 (PDT)
Message-ID: <36c12f7e-b55c-4f8c-998f-ba7a99a050aa@arm.com>
Date: Fri, 3 Oct 2025 13:24:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 wangkefeng.wang@huawei.com
Cc: linux-mm@kvack.org, stable@vger.kernel.org
References: <20251002013825.20448-1-richard.weiyang@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251002013825.20448-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: famigfz1rdonmecxznpt1sgpnkiuma5q
X-Rspamd-Queue-Id: D0FB81C0009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759478108-61634
X-HE-Meta: U2FsdGVkX1/gBen/YhcV1M7yLQzxMcQ6Xwk06VE2Ny7sA3oNgbRW8gsvnDdMhsqFwn2Mo8CUxzVJGQpI7Hd5Gn16rd0pop1iBAP/jVSfxfAJiLPdqZmV41GnKDxN8Wf2k4SpWp8dzZUI4X96D2dUIQaMXfRVeEIImqWEm6DNxEYjXzFNXv1WXDD82FWJydVsF/R66slA7dZx81Q5jjM7QUOysr3BbZ4nxeG6nRS8PIXHaK3ce5v6m8BEa7rZAojy8BEQXA8ZPYRu9yCCJnlY/0JVzSf8piX6v+uo5GKoLE3d101bE2Ugds4ya1PRXQRHomBpmyyZ+pOdOcDogv0J6l85x21Es9OIPlxaiyj0d+vI553rCAbEc56ewSG7JrUDTKIDNuipungsu//gjWyF7PxwBpWKJG7RfweXE6doPqubl1L3joS2eqXDUh0v4RQ/emcQwAFaPS5GzGzarVa6+CvHLCGp5YaZMYy16DADaeCHwzD/eJrmku/uNcE5jl8ibQwTWBr9C3PCwgmckbnRP0LyUmGTmdb/U0Jy9o/nJqfbZIxqCNhlAz+tH16g8ui6nqULBUNkmtxkAgEwaQQxZO8FEVRZIrr1itZXXh4tMJa9oSrXoiRwqBcpffhfVx6aXFKFQH1mSo2LoU1tiXE3LtzIZB+MjqvgPdJOUrF0O5PZIWIds4/sCuLXU8R19YTZjkrFhBCMNUaTf/ttGEphlRuvjBHoYQ2Nuz2RaXBDAxDldRCxnE/im6a5EnTrFHNZRDOb6EpLBr7lzEu846kg5a74ijSPW9sbjle2kqzs4GiE+VzX7X1hgk6UvE7j7tjw+PuZ/uEXgr8ddxbgmyzG1Z/Ql0hbAempz9GZl4S+2XYpbFn+ll+09Tur6dVk6IGW13EVGDJ3z6b7bT/aSV347jCGViyhs4VNyn9NPdZGpUGqTlUi+WqQMZHymJwh7gRA1vupX7+fqILp/t8St6K
 Mfnmq172
 vtYAvLcXAj1vBYdqI/MTdkQmemPxtfB5Swy81ANhwXawam/nyQJo9rqE1VgV9+RdddA9y21lXHd3bcjfa448ZQD5eC1ozdKN3U3w08aTzn25pqtuXDU/35upYyec6MRzJ00o6X54KKqh4FTm7sVUcFL1u9ROhwYsmBKft/8h/DJYuLlqQwrwB+qvAmnThNdk2GlsvW9oEgNMQX3OfU+eZYiWttQO+SEsRYdJZltIiHR2Xndr2Q5SjS4cUYgEMpZyrVTykOg/Kh5azyXqW2v2UjzIasr512Gg7/Q4V4phhxgF/ono/XEsMV7dQrMJ2LV7qDP6jTSelxHIeiJxSjS7g6T2Dj3rNY8aumOscGoItAinf/ZaXRoIaeKEkTWkdS9Y6fUbPUPKsggSotyw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 02/10/25 7:08 am, Wei Yang wrote:
> We add pmd folio into ds_queue on the first page fault in
> __do_huge_pmd_anonymous_page(), so that we can split it in case of
> memory pressure. This should be the same for a pmd folio during wp
> page fault.
>
> Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") miss
> to add it to ds_queue, which means system may not reclaim enough memory
> in case of memory pressure even the pmd folio is under used.
>
> Move deferred_split_folio() into map_anon_folio_pmd() to make the pmd
> folio installation consistent.
>
> Fixes: 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: <stable@vger.kernel.org>
>
> ---

Thanks!

Reviewed-by: Dev Jain <dev.jain@arm.com>


