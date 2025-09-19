Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C56ECAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 03:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C362F8E00C3; Thu, 18 Sep 2025 23:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E6F8E0008; Thu, 18 Sep 2025 23:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B24488E00C3; Thu, 18 Sep 2025 23:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A16248E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 23:14:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 408C8869D8
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:14:45 +0000 (UTC)
X-FDA: 83904532530.14.613A721
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5D17B20005
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:14:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZZApztux;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758251683; a=rsa-sha256;
	cv=none;
	b=d90K22U8NLUN948qPB7XAULpZRmm0w6RsVHa1qE3j6xgMvw3duebBZiG6edTqGG4dFq9ZZ
	c7TOOtiXSDV9P/drd0BYS3OA1B/iJ0B9aUCVfrCS72kBzjL3PCWXxXCIw3okP9OmMGDA+u
	EaBOn5XmhXONxbIq5Fckecyn9Yl2KY0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZZApztux;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758251683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VNF2HnpXEMFwsdgXnhG3INUAuZBTmmdmXHxWPTY6uCI=;
	b=ADF9HPdn/ixsNmGcVOyhxfz7GhrPUwv98u3CxB/+NplDC80deP/DXYuqGZTUm/jJCxqL93
	I/Tgib9bc/73LARHoqa4HfIcA9iFnD+gy5JD8aaT+0JwvmfSl+wNPRvZebvZCjm7oqIxpV
	Cef/cjM3Un+ruRGISOCUdhcU/QhTI+8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758251679; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VNF2HnpXEMFwsdgXnhG3INUAuZBTmmdmXHxWPTY6uCI=;
	b=ZZApztuxTeFQk1UrIBOHPlP2aK5pHy42KO21WV2iKmPomBmws/PVPrKJ2RkllBICraaro7575iQPhOW2OCXhh35BMhvOKMn49eUJa2tdxe2VByBZg0CAOmKNnZleJ3s48yJZ9z6YbuifcdC9Q//jeNAekWj5x/9U6OG2ejT4JFs=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WoIItER_1758251677 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Sep 2025 11:14:38 +0800
Message-ID: <4cfefb25-567f-4137-9fba-fb3db041016c@linux.alibaba.com>
Date: Fri, 19 Sep 2025 11:14:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] mm/khugepaged: Do not fail collapse_pte_mapped_thp() on
 SCAN_PMD_NULL
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <v5ivpub6z2n2uyemlnxgbilzs52ep4lrary7lm7o6axxoneb75@yfacfl5rkzeh>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <v5ivpub6z2n2uyemlnxgbilzs52ep4lrary7lm7o6axxoneb75@yfacfl5rkzeh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D17B20005
X-Stat-Signature: ueo3x9mrkjacfici4ach44889gtkditf
X-Rspam-User: 
X-HE-Tag: 1758251681-880998
X-HE-Meta: U2FsdGVkX18kIr74NBMgsET2yvdQ8+JFZPUFwx3aGa0h6Y89D0G5OIAu9X5zHxCOTcHOnDoSiJZNUZqnkP4dq05AWde2pWb8027Ay2SGvLhy0JeFGHJFS9kBbc/jIfQrzeyHsFuRl2+/YzvfO0PRjQ8f3WpXCAiDeHx9FrTWhu8qLGxTjQfW5OdEzxbAU/XcHJ2rVa0FfqnFfp6g2HJydI262Em5GatiVuZOTDhG+c6Lf40mGPzWZ83ulygiqE+PDkyL/+Hfk2bUw3prLMt06ySvCKOpt5eKCETLQMBTu6lFApCLTIh3Toz737sh7Qz5QaoTl9CkLv4NtXaLdZZrDBd289T9RlnYT5DdZ5VRE78QbDUMnwYs0mCSg0efT8yIuxAr9SBlKUhVo409n7FT2b6iR7hVDK2OnOfye+B0Ge34DOfKauxN7E534kgrnFMZWoSBEzzTc6A3jOEXhFc3qauTX6027EzZojmnOiF50Snonpd/ECRNzjyLQUAxIdSRn7UiwLaI5EtZqvDPhm2UAgAh1RVImfGUmO9oMKs1JfCdcG/E91IQMPlXiZUalj1i5tjWvRLw3Nc/ZFK+XQKv1zdb01MHW5szSQDPmySj0/Pi1NsmJZrpL0jGLYdcSSKlmLPJ1F2cKO3HTBKs9NoBhbyeSoBdrjsMg1gYnGKv1/5J4c8CNYnpmD/zZiKSCUCPdktlcB9RKVzmW0c2DuMduDRLHrAS8ELsDDyyrDXqPibzvXpb7/J3ubLs5JBrah7evFQ00T06Crc2uYWD/YfkT49Kn6cEUhpoZmnZWBQPvAQAfSDMvWin4wre0tecO5Zz9USaGY6vI8k0bS6xfATZsbrEAPiRc8EFBeDFx09qAKBIlIn8WitDImxXkmP1lCVj9gUfr4dSmN1LLPQou7SVbBo+NuwN+mLwSLH1IjusSlht0XC12KrU2xMLWbvTyTcVeruAFQCU6cV8I/nQiUg
 5VwOWfjA
 9TGL/BBdF86QEapbXoRdFFcMmuyorRgnF3igZbPKu+dBjtwFq1tYgTsIbgaZQRqLEwY+MzjZBnsSWRFv5dwj98kQk2sza0/6fhci/nc2cNZzZIlfvMNjoyGwHCJrIaaln3i7ipkraHRSxWfBAyfz3q0Oqb9TF247NiSxeW9v9CcjwlcG/dnjPDWUc+T9vRoxr4kiaWsRQT4vQxp0mQm93vuMpmNNxsJi/ShBmvziHARYdUCejXGA6aGO5utdxG3pM6RwQaX2uzCiiKmphZAIjKpcxjEf1HJT5R3L5UUJMkNqb0B/t/U4yTgCX5QLoAnlLt09BpEIXB/ep2El4bS3xeE8nCEys7lqPWnQlbM0jskXgOtt0XGdWoq1jJ1pRg0tERmYFQnTaqs6Wa+HrZVoARmbh/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/15 21:52, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> MADV_COLLAPSE on a file mapping behaves inconsistently depending on if
> PMD page table is installed or not.
> 
> Consider following example:
> 
> 	p = mmap(NULL, 2UL << 20, PROT_READ | PROT_WRITE,
> 		 MAP_SHARED, fd, 0);
> 	err = madvise(p, 2UL << 20, MADV_COLLAPSE);
> 
> fd is a populated tmpfs file.
> 
> The result depends on the address that the kernel returns on mmap().
> If it is located in an existing PMD table, the madvise() will succeed.
> However, if the table does not exist, it will fail with -EINVAL.
> 
> This occurs because find_pmd_or_thp_or_none() returns SCAN_PMD_NULL when
> a page table is missing, which causes collapse_pte_mapped_thp() to fail.
> 
> SCAN_PMD_NULL and SCAN_PMD_NONE should be treated the same in
> collapse_pte_mapped_thp(): install the PMD leaf entry and allocate page
> tables as needed.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

