Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2007FC531FC
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 02:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6EDE6B008A; Fri, 24 Jul 2026 22:10:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1FB96B008C; Fri, 24 Jul 2026 22:10:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C105A6B0092; Fri, 24 Jul 2026 22:10:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 961496B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:10:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D9A2A0CD5
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 02:10:36 +0000 (UTC)
X-FDA: 85025670072.05.A15A4CB
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf30.hostedemail.com (Postfix) with ESMTP id B9CAD80003
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 02:10:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=mJysJzjV;
	spf=pass (imf30.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784945434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ng+ga4AhfBnASMyVoG+hjZ/tTmmyO7vuzpRNh1bTvL8=;
	b=XQ2eRlfbwxW9nQm8NQLlXUt0y+oa+x1goAoGJYgMSGWV26Q+9ATMQbj9VRIBNqpaMh93CB
	PWXkVObTkebJYJUJHzF3APjCPm7PKyLbTrayEkmRCZPLETjv1murvvZjJjTzNFBO88ZNK3
	7c/5ffa+JF1TSxTELY/u9nq9hBkeWFg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=mJysJzjV;
	spf=pass (imf30.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784945434;
	b=nsxuJ4dr2MqeJhs24u9YL591YcM/ymTfweGSVPprH8JMQTwKpH99y6GQMtMWDFYtDlkzFq
	+5WNVY7a3++7XbcORuR0ogfy1HLHoJJkbpe/U/3QiQsGuPJTg2DcPTbUoAcfZ+3D+gWOCZ
	OE0W3dIdTFK8be5yrvGwS698UHr0ttI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Ng+ga4AhfBnASMyVoG+hjZ/tTmmyO7vuzpRNh1bTvL8=;
	b=mJysJzjVOqICmd+b38gDsU25j3xRj3lblG6e8H3/tDf8WuocPTWmqVb65HMAyQv7xhT2J1qmB
	CGs5AfD90di/WpGfmy4rLD/ntvLUTiNXSYgJqDRnE7Sv6B+S7hY1USPdLWjYlZPSbRD0IWxA25D
	xL3rxeb/Uqsjy8xmNbLYyoo=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4h6Skn0mZ6zmVWf;
	Sat, 25 Jul 2026 10:01:05 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id A12B74057A;
	Sat, 25 Jul 2026 10:10:29 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Jul 2026 10:10:29 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Jul 2026 10:10:28 +0800
Subject: Re: [PATCH v2 4/5] selftests/mm: skip hard dirty page-cache test on
 NFS
To: Muhammad Usama Anjum <usama.anjum@arm.com>
References: <20260724102431.1199519-1-usama.anjum@arm.com>
 <20260724102431.1199519-5-usama.anjum@arm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
	<linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <sarthak.sharma@arm.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <57c6bec2-3135-35ab-46c7-b1ab041393c9@huawei.com>
Date: Sat, 25 Jul 2026 10:10:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260724102431.1199519-5-usama.anjum@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: B9CAD80003
X-Rspam-User: 
X-Stat-Signature: 9ttumk6n9oep1puiom6x3kr8yaxtc6dd
X-Rspamd-Server: rspam04
X-HE-Tag: 1784945432-631427
X-HE-Meta: U2FsdGVkX18apIQJJ8MVw2Qq2HM2sQ13PMMZRUGB14reWogEnxRoz0RehLA6r5urjPMn0GvRctjds2Gt/wlx2NhlkNmNFpSpastAZCoW3Pn6MCaPAsfMnIVwqf/mKAc1IWEW+k4gIozvhgPw/LKAPMyhqrs7S1QaWocUpl0BarIYHSVlOVcxQH7ZXJZx805qOTVZ5GEqXJctTMTxayYcCAgk8EzgdrDfkozVmY3ffwWwlnMy5mWkA8rBTpocXrV0z2kD8sG28ymiMr9A8xMSCvRQ0vgQjIDB/2ea3igvE2sQvwNkUK5mA7FbT9F9ERc7aftXxkeifHmEHBMZOczzUk+/zpImF3/Xx9E/lkgfZwqK9ab2qsyU0KbgaZFTHJfCUX1pEOCscEh9yODYaEX+jTwqts+t1jbLPlts/oe0APX/bMvu4knGI82g89PFJeHzy6e9yhoXhprSy4m6eAZNNmEss2yNgXA8uAHzb1up/xl7l6ZetoXK3/cqq6Er9zPfcCFgocjkyrXcKsXegG/xeHIVa28lmUgoqBbGENHtGMcnDFkrVo+iLCVjtbmJp6l2PcI5cAVsfDRKJ0Vy3GN1SfX99Tczumi9vKtwziCxT8UY45Fykh4eynN8pmR6u3GoosGuGEjz1kFA+4gC0TlbXTIqUgZgjLIYjfq2yeVZsUuvQYoofQRUGmDRypU1ouu/iIo+kM7j7eniOqB09YRtBgxsfQ8E7qsuVZRv3syeVh/aIaQeLZjF+2N3VVv8pYdyuuBToYEKhOxzJp/9bMSk5JZnHu1zKjtZ2qXZiEm1KQZTi4YApBKHjVwCdPgZKKn3nAaZ2eWx5QBWrPRj0OvvWoqoEZ2PngE4FtHYtZMaMVVEPIoA1GME8ig3IOLaoq/sg/G48+3BrgHO9/5cuoGWHoMZvK9Dj2ZV3TptbMOxLnx3Kh9tTaXdL1sdT8r/BUYHmqLoeQcHq9M89ihDzVO
 Pp13OgXV
 5YbZCVGEyBDI5IDqxAFKSsEhWTi9yDkW8YZOwz5L8e8Ag8T4aQAe9w04MNWXKmixbtZga6QESUZN4NYCjtlDLKlCgSVz73GSv+YTbAmX0D0Thr39Gil5ou1Qvk7i9VGHp6Lo1pPyAnsIwGnlTor86nRkJX7rrWLMBms2sQcj639DfGPSAgrGgF/cGroetvxt4yyu1sFTv9e9OOXtDQ+nxd0PdsaYDJHJFF/9GjY+f76o5FIeZVX4gu6CP4lMGXj70woK1Yo+6XNkasg8ICSQXUHFnastQoO8VMJHrumePdNIgjLWJzEq9v7T2sP970SWCdH8z7KQIPCCUWFUJ69Cor1rmnbXcJUozwFZMbc7MHZHetfA2S1mKwLF2nN7TZ+TUbkvTxwq537ZOu3KLiS1WoUSpMZ0gqk/N0Ovix+dGF4lSpUAtVw4PtUz1Gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/24 18:24, Muhammad Usama Anjum wrote:
> The hard dirty_pagecache variant uses MADV_HWPOISON to exercise recovery
> of a dirty file-backed page. The recovery path records -EIO in the
> address_space mapping, which NFS later reports when the test closes the
> file. This makes the test fail after the hwpoison checks have completed.
> 
> Skip this variant when the test file is on NFS. Keep the hard clean-page
> and both soft-offline variants enabled because they use folio removal,
> invalidation, or migration rather than recording a delayed writeback
> error.
> 
> The unsupported-filesystem path in clean_pagecache() also returns
> without closing the opened test file. Close the descriptor before
> skipping there and in dirty_pagecache().
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v1:
> - Limit the NFS skip to the hard dirty-page variant.
> ---
>  tools/testing/selftests/mm/memory-failure.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
> index 032ed952057c6..3c72084f57e8b 100644
> --- a/tools/testing/selftests/mm/memory-failure.c
> +++ b/tools/testing/selftests/mm/memory-failure.c
> @@ -283,8 +283,10 @@ TEST_F(memory_failure, clean_pagecache)
>  	if (fd < 0)
>  		SKIP(return, "failed to open test file.\n");
>  	fs_type = get_fs_type(fd);
> -	if (!fs_type || fs_type == TMPFS_MAGIC)
> +	if (!fs_type || fs_type == TMPFS_MAGIC) {
> +		close(fd);
>  		SKIP(return, "unsupported filesystem :%x\n", fs_type);
> +	}
>  
>  	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
>  		    MAP_SHARED, fd, 0);
> @@ -325,8 +327,11 @@ TEST_F(memory_failure, dirty_pagecache)
>  	if (fd < 0)
>  		SKIP(return, "failed to open test file.\n");
>  	fs_type = get_fs_type(fd);
> -	if (!fs_type || fs_type == TMPFS_MAGIC)
> +	if (!fs_type || fs_type == TMPFS_MAGIC ||
> +	    (fs_type == NFS_SUPER_MAGIC && variant->type == MADV_HARD)) {

It would be helpful if we add some comments here.

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

