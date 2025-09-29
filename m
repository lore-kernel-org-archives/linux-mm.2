Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DF0ACAC5B9
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 16:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8748E001D; Mon, 29 Sep 2025 12:15:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D90518E0002; Mon, 29 Sep 2025 12:15:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCD5A8E001D; Mon, 29 Sep 2025 12:15:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC1358E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 12:15:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C418C0440
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:15:55 +0000 (UTC)
X-FDA: 83942789070.08.01D3EBF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id A69CD18000A
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:15:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759162553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8W/3jEx60cREUdUJ9tpjW6dbXpH5skoo+oNFVdQbJIM=;
	b=4/o6lkHwEqTkxClezvwkOJ1hvchtAfKQ4rQk77Uag5LfBtcxWBuRflExHa2uQ5PnY7zpv9
	2EfSNyS+KkE/4gPgHpL9MnIuzFlaZWltLjQtT/d1Ynnl17FCqyCi8URM0C8tjzBAwtMjQi
	KGantXjTLUMcBDlTjjDQij2lf/O2ndU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759162553; a=rsa-sha256;
	cv=none;
	b=evl09FpcyiTeK2jFeYZx1X+Fa7806vEUIDkHiyo4wv08GFqGD76hg8ANSdiKI3CTTlNsyp
	xLTXdb3gKHdfYhp+0IHd5Tbvz+wzuvo1BFRe6gW3hrQPDWtqjpC7hAZ9e/gZq4UdPYYhFY
	pWBjIJTrujmJNd8wbzibtkD4h7Yb5uc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3019150C;
	Mon, 29 Sep 2025 09:15:44 -0700 (PDT)
Received: from [10.163.64.106] (unknown [10.163.64.106])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C69F3F66E;
	Mon, 29 Sep 2025 09:15:49 -0700 (PDT)
Message-ID: <51812c42-39bc-42f9-8597-277afe690924@arm.com>
Date: Mon, 29 Sep 2025 21:45:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation/mm: Drop pxx_mkdevmap() descriptions from
 page table helpers
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Alistair Popple <apopple@nvidia.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250929120045.1109707-1-anshuman.khandual@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250929120045.1109707-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A69CD18000A
X-Stat-Signature: g6817rpdzjyn97paky9647ozr5f74po9
X-HE-Tag: 1759162553-359176
X-HE-Meta: U2FsdGVkX18URUH1EX6KggCnPouGKNXeKYC5ioNkiau+c1P0VP3VPZJwhpCwWyZsiR+iN/iLhO8818D8Wkk72iDOXsM2J3w+3CSpQahlk9/TiRXjOVNUTba4ASw3sUhyer02trVlFu/Hvaa+10bYCTtcwZrtfnMWikzuXN6iNoflFRObJuuAWxs7JoXRzey+th7nC0UC43LNscwHrGcjQsju0zVaP7vRTSrcjZpKQBrBJX3Z+Z+8l3hlVOmHexSvlbClOPnYQH6ruUfOQU3GGAt1/SVK7w6SAKiCkT1pqcWaJ6/wQfN/VAMuRtjsK++Y/ZO5G0BLAQMvn3HJ+AszKnMdhA8oz0IGNbbCV37SS0NB8geDHD9ViqknhcSfzWdZ58HLPpJ70HFfQnedQfNMJ1ggVW56zx819QoFe+ChzYC0vnF2j1hrOPYfXGyysI/Ev4afrbLhEz6g2sqilpvbCtST+RtPJWKCM/PluQV+BhXZFZSmHPvq221KFDwBJPi/rGx+B97IoxvkPxNUnyAsS1D7N20DdgTFmG2ej5FriW5sKGuM3ONs/nHNN8VhMGSyRrPEoup7JDS3TrdjoGqow35A/do6UipFvKctOM/Zf/NrWNgJKZ3dguFO6JBM8m795EXxWqfQ48JY5MWuClEQGmcH9NA+t2dH/BbvvCQNA0BAGsGEw5yLp5UNGGfbBT5e2KHeNJ6zusYjabgykLTD8HzBdujK+lnVANcABr3rEUlwPT9xfvva8bQPqsHS3t/uGRsNtCqAQQhr5QNzbeGtxhM2SXgLJHUVU2nhaYEE5RDKpKi79sELm7J1pkkmRj+KzG/nqvCJsH9k3CBbyHWWC1wZuYMuOvOgCXSoRGPt2/tWk9SF8J+gBBo3TBvwZzZOq3wMrttuyTzSdNJ5w6H+uipwsoNZ9wEO5EC6AW21UYxlM7XUC5rUHbN6JPUgNXyG6Z6X3giktQoJDpR/kXg
 xXa2DeQ4
 feng8Pl4XTN5eVKhofJNOCYCBEuhykHdIremZLVsxvCicpqUWe5milOJRfd8DwY3OWCwbMmXLu5T2lv8fWEdS5Vdon8gyX/VBGT0XgM5qPAH/H0zeyAqwjugknnCN3yU2IZRmu9mbzjU+fOY32+68yO5dxhhele5daHDvYWZK3sBrXWQ6EO3xG9JStBaqna5HTcbaO3jaEfgzhpKS+Zhqr1NYcU4D37QlymeIKhLTy9ImOY2eGY4VmUyjT666UrB5/hRU1oQyffibbF6F6NBIRxcMi268VTm9YzQn1PaF/QqGsrxrXdI2wy3aGr6mPNHxLPiFzzA7BL0C68A+N5U1IINmYkgImqeSsdXjxqIM6qbnagAL8nLd9jGQp9dlEH5N5HuvsFBPq/zW9XRIC8ISNzg+qL5s4M5GyLG3yVqVqcGUHSJvUQkVItipUyUIumhNVtEDA3HGdsde+Eo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 29/09/25 5:30 pm, Anshuman Khandual wrote:
> Remove pxx_mkdevmap() descriptions, as these helper functions have already
> been dropped (including DEBUG_VM_PGTABLE test) via the commit d438d2734170
> ("mm: remove devmap related functions and page table bits").
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: linux-mm@kvack.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>   

Reviewed-by: Dev Jain <dev.jain@arm.com>


