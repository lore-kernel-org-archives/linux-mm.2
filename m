Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45C07E81BA4
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 12:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70E556B0005; Mon,  9 Feb 2026 07:01:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8026B0088; Mon,  9 Feb 2026 07:01:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9D86B0089; Mon,  9 Feb 2026 07:01:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF456B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 07:01:46 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 160541B34B6
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 12:01:46 +0000 (UTC)
X-FDA: 84424779012.24.51699B5
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9EE79100005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 12:01:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="HgvFsm/O";
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770638504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aVJWYN5hT//tauzZC63sk90Og7RFtOObfGnbaqSG+J8=;
	b=I7s1IrQU5xTMcSfdhh+C1wNXkctcD8YyqMJmGBQxO8MHfgFGjkgVA5x9peaV45DJm4mb/k
	FG5zoOhwzAVTtJDiSj/qfl8qEusLSmjXMT+bTOQwTCzJDguxGi0RyHJUYqQ0dkX2ZAd8pw
	ldJen5k0UU2Okll/7/3uRHfbwo0f8LU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="HgvFsm/O";
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770638504; a=rsa-sha256;
	cv=none;
	b=CJwrUeJc06Nl6NqS8F9Tg8zHIM9qTUgDIIZLbIcjhxyY02EodOEEVXhaEOSgDgbSoCbGsF
	0/4uZ6Asct0jsJs8GChXhStPgkbUDznScXn/lGSDfkSRMkBJGZoIDF5oPr8UQ9xE9ClO6p
	wBooYmNF0HRA/7MRses9l4oxHSHInZE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aVJWYN5hT//tauzZC63sk90Og7RFtOObfGnbaqSG+J8=;
	b=HgvFsm/O5g3Y9YB2RfP6Mz2JabvrM3IzLzLrLnyrTV56cNRQv176lP0NpjI/mcxJlpGKlcLfK
	vcCyPP/bWOp+HrFwDDgLpyVBRya0CEHBsBSxo43LQh5aIcvEcDlVWWDFTIVvp02VSWzT4KTZSqc
	2XO8ugKS2BfADEs4da/8lfY=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4f8jq35wJvz1K97n;
	Mon,  9 Feb 2026 19:57:03 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id AD60240563;
	Mon,  9 Feb 2026 20:01:38 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 9 Feb 2026 20:01:38 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 9 Feb 2026 20:01:37 +0800
Subject: Re: [PATCH v3 2/3] selftests/mm: test userspace MFR for HugeTLB
 hugepage
To: Jiaqi Yan <jiaqiyan@google.com>
CC: <nao.horiguchi@gmail.com>, <tony.luck@intel.com>,
	<wangkefeng.wang@huawei.com>, <willy@infradead.org>,
	<akpm@linux-foundation.org>, <osalvador@suse.de>, <rientjes@google.com>,
	<duenwen@google.com>, <jthoughton@google.com>, <jgg@nvidia.com>,
	<ankita@nvidia.com>, <peterx@redhat.com>, <sidhartha.kumar@oracle.com>,
	<ziy@nvidia.com>, <david@redhat.com>, <dave.hansen@linux.intel.com>,
	<muchun.song@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<william.roche@oracle.com>, <harry.yoo@oracle.com>, <jane.chu@oracle.com>
References: <20260203192352.2674184-1-jiaqiyan@google.com>
 <20260203192352.2674184-3-jiaqiyan@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <26a7803a-bf20-c60b-459d-2c8f82f2f4f6@huawei.com>
Date: Mon, 9 Feb 2026 20:01:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260203192352.2674184-3-jiaqiyan@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EE79100005
X-Rspamd-Server: rspam07
X-Stat-Signature: 9bquq9fsbwnonhkkf3prudnshurhxk45
X-HE-Tag: 1770638503-239212
X-HE-Meta: U2FsdGVkX18hjjH/0RQcedcpK1cvnRvhm8zFxTVUxmfIwSNQXaNpQDo6U82ObSt5R5r5hhMaC5TNpGvqDvZ8494tZjJ70xGMCQBx2KWOEbF20FvElyHeTsxKa6Cwo0+g43PcuO0OoOgLOt9RXIzwad7EauChCJ8I7V2djB9h9XxC7f2/Zu3zhiuLRc0yopDj4Imcf1Gx8WDdThvudNoFVYobB1KgB3gB/7ML0e4K5GZsmmGjAiOn2XVn3lgVneiOqKuz1zLv6/3UDobvKy31PA8wWuVkl4UWNvIHQdZKwZ/KO7a8c4AfHNyZOA/xlXsGzME8OFUhQH9f++n8d5hGXwZ0MijwNqspZfMiLFhryuuUg2F+qvI1a51X/i1UypZmwIXJaT84Qqd3LXR5OrBlf2tSJasRJ45/yXsm2T1WsHiO3G8NToUA7cpMHFmm156LcHRM/jmRLFSWkOHk1cV9lOMNJAc7EcdpmXMWomj9R05MahhNwhfb3vGkAGOkp8XSXJ/EMBsOOxXCcl9BdqNTvS1kKnMvkzVoCFWB95B1DicAaqMY+mJhcPKOJSobOj5XPoSxKp6HALLpBr88FevBu1nCogr9y65ObBH26Vobw+PnTbrdmkfVteZLZ5UVRDKoIZgREbmy8O4Sa1AxQg7ROzktTCoiurK7t8kpGmkIk2/OevXKdRDUA00iTumLrsqaL+CsP19ce2kLeTMgCHlU03Jij7fKA+sj0BGKf2FgX4xjJIcUWJ2/sl/bY+OIjRV6RheO0lYo6dO1xYxl1o/4AgM7f8ut98oxazjXC598RPQRGgw9IFVAOS8wWynGTAEM2iyWZ4W8bthjLLM9nKOuFkyx9S2F5bN03L9MDSWYpk/jW4cL9E/4lqysr+ugOP91gRnzBbX+sxYbAit98LlGR2nij3xYI/bCb4FCnHzZbHzRuBtGHXFZrDtKD6ENK7qoh6KR2uhfx5WIa4s4BII
 aiLIPHPy
 S4dlMPc2Nz2whcbT9uNSpQ87Ed4TdIld46irHUb93o0MD6NVHfkIg2F6T1M5Wemy3WnepnAuXjN4//U8R9MN4jSEvXXxwQ8xIUdq2F2ivQSx+1XZ1SqRoIhuxeL4Tnmj10qVgc4MokiLFiXDfWOiPEX7+CLKZz2yzTDYROZFVEnQ5qvp2/u400VqzYkkVzXGSKgid2QU/H8S55+3mZQrTZnN9aiH1lUAuHQ1+Yld8vjQqqCywU0Dllo+G8Qkr6BEJG6OW/h+j5/CPMlZE+4Ae1eRu6SXyTCthpDTg2ImJKksrM7zzj9Z7X+RD6CW2lfqFKuc1XWQAa+D9g04LqDll2yUJZD5mQNutv/YlYRaw7Z0BDyz1gV5LCOafZHd+e+U+P5LhYMf6NRFXAh0rc4yC1oIDvp9oIgXFzBno9nrludrKXFk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/2/4 3:23, Jiaqi Yan wrote:
> Test the userspace memory failure recovery (MFR) policy for HugeTLB:
> 
> 1. Create a memfd backed by HugeTLB and had MFD_MF_KEEP_UE_MAPPED set.
> 
> 2. Allocate and map 4 hugepages to the process.
> 
> 3. Create sub-threads to MADV_HWPOISON inner addresses of the 1st hugepage.
> 
> 4. Check if the process gets correct SIGBUS for each poisoned raw page.
> 
> 5. Check if all memory are still accessible and content valid.
> 
> 6. Check if the poisoned hugepage is dealt with after memfd released.
> 
> Two configurables in the test:
> 
> - hugepage_size: size of the hugepage, 1G or 2M.
> 
> - nr_hwp_pages: number of pages within the 1st hugepage to MADV_HWPOISON.
> 
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>

It's not required but could this testcase be written into the tools/testing/selftests/mm/memory-failure.c [1]?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-unstable&id=cf2929c618fec0a22702b3abd0778bbdde6e458e

Thanks.
.

