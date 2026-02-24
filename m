Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D42A4E9B262
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 12:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42C996B0088; Tue, 24 Feb 2026 07:58:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403F96B0089; Tue, 24 Feb 2026 07:58:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 330FB6B008A; Tue, 24 Feb 2026 07:58:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 223E36B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:58:42 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8ECAF137A61
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:58:41 +0000 (UTC)
X-FDA: 84479354442.09.D1CF414
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5D4A040013
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:58:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=0Dri22NS;
	spf=pass (imf17.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771937919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fue2tVU858LZ38elo14sVk6gqI1+tCuiftRGjcHag5M=;
	b=Cc9lvCrE29vRwDaf0nkBqUd2CIg6+RSXEUAVWhFa/MB14h/212pp+5lVx3ic0/XTsHpiMT
	XWgYkD5HxvaowMnIc74pibjqHrFqlAkSFMA+V7i770sPy7XLQBrQk1+5UtiDtl0aJXaPZo
	cO/+IYVxy84WFqNwBhykDoqwh5ZMiWM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=0Dri22NS;
	spf=pass (imf17.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771937919; a=rsa-sha256;
	cv=none;
	b=25e9T5rPEdNj5oeHYVYlibCf/a+3gHWKSJ8U3mkPiBuiZrZVdZnHA6mOyHtmYyNzH+rA35
	cu69Xw7S7K2a6lxxG0CGTT4j+QNc5OzPwici7J4iJr57JkLsiJp8EfKa6QQoXQ8BK7bIZz
	WAjnO6BUqSjHBzyFEZ6wo8FlE65D4+g=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Fue2tVU858LZ38elo14sVk6gqI1+tCuiftRGjcHag5M=;
	b=0Dri22NSRpnz5eN6q+1zdlhweMT9s4WRiPZ+j7U3LnNHQbyH8uZMWvPcuFL8IJQPUtAn1joPc
	Abh8ITRNQNBs+9wdYrIk/vvx94LLo7DY90heyih62XOOVHGvJ1+CrETObVn50aAnXaKFuiGNYbB
	Kvp8fs8gXTVCEl2lU+Fross=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fKyMh4WzfznTWL;
	Tue, 24 Feb 2026 20:53:52 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id D068140565;
	Tue, 24 Feb 2026 20:58:33 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 24 Feb 2026 20:58:32 +0800
Message-ID: <64357180-b91a-4319-bd0f-5f09e38cebdb@huawei.com>
Date: Tue, 24 Feb 2026 20:58:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm: Regression with v7.0-rc1 on RISC-V
To: Ron Economos <re@w6rz.net>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>
CC: <ziy@nvidia.com>, <jackmanb@google.com>, <david@redhat.com>,
	<jane.chu@oracle.com>, <hannes@cmpxchg.org>, <willy@infradead.org>,
	<muchun.song@linux.dev>, <osalvador@suse.de>, <sidhartha.kumar@oracle.com>,
	<vbabka@suse.cz>, <claudiu.beznea.uj@bp.renesas.com>, Mark Brown
	<broonie@kernel.org>, <akpm@linux-foundation.org>, <pjw@kernel.org>
References: <1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: z3d5jbhx5seia4bwjumw93pf7cfccqkb
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D4A040013
X-Rspamd-Server: rspam01
X-HE-Tag: 1771937917-280667
X-HE-Meta: U2FsdGVkX1+BsQXqGzaGNZPpZsrZcKYizscc8BhfYFKmctnp3viTz01uhPpckKr9bt4ERu9Bs8FFCr8NSILEHLhHuGmAzd1NgY5ZyMS/fwCaL2m0HXx6RF1EA6yIe+nSJ4BJowXPQ4439dBfLLAyxVh8l4neNrZ9sHLpPzbSnPcdetnc9lgXPGhVOAGkpgqJ9UtZ/LLOEZpfwKmoDkaec6WdJMx0H/qSWtGWaNo3njEyxCJtHLF2zRNDumkywhHk6ffzn1os/mJ2eDr9IBeExjD0VCOQyPbl8RgTVh/N+MvB3fnaiqEiGfGNKL1tvJUEb0cI7EF/b4p/ZTSCmwJSUUmv1OzvMb7tAmxHj/QapQEek7u57AO9EELXBe8FwVXzpEAC/VpUa5vuwxwrkW5O53IG+BwcprN7NYM0sTAq+iw0NxUKl99/siDFBXGdQJgHZmKeimg0909i50BJB52arcukJ5VLVMQdhrvnvg/yQLYM3pweTMra8qSJ3AEQVtN02FuwsOcUK801FNEQfPeYegEKJiVnmQmPbmY4WqQyrf0YckYO0Sc46YHbO02Jk5cFboYdoJTUMmah0QuxBcbD1+DXYV3uDSE5ugjkQdowVUNOTSkYWOQAAsrKQSneMxMycshihlv5rCXZlA5IPxW4hnJcL+CZ4ebPS4wrnujkey4rhyP7UaGpjiCCU1VW57UEeK33Bgq3hBJZkIf8cDgjm+MLx+vXHtFQUyqypajln7FDZtJMoeCpfxAuYyN8LvfQwALkjMFpJtR6L9dQXd0hMtWzvPrtBCfw9BsKW7lSSUzaAnxuGhOm9Xam2+vZL2O0nNgysga3ZlbKooV54rjScTF00EZ1ZpMkeRRMOxZSFsJJZA3RMFD5VejhPEsRgOc1B730s+JnLUPBGMq+7jHG2J6hSQ3Kv6l1iiNKEQYHBP0gLmDGsPm00OWYwJst3PfZ6IQYdwKLw61OjIs+Sbr
 ZyFSxNCc
 FICcFZawl12PLAqQQNewUu6GL22d+3V5qefpYAMZKm1QMteIOX1g9uxNeGB8OeNqeEuLDOkPYi7l3mXX2n9wY7wOOyCU/S/lDSlVI1QbnXRg0mfR83GilNFwesLva3oxc7QLYAbrD8SBzU+wh05ofUloghARAj9gidogA+gFYlQzGdR9dQWEJa9yl94p0I5kn1F5+IQOmkQVUdpiEEujb2nqX/3/Ql0JcV/UKapBsDedzNMpt5dieXoyDxGfPkikuiu9wdI+Ai9GGKZ0F7OAT3yzDKdu0/WkEaTcy3A9BJd9/qTnAYn3MMzTMi6h1B7SyovHU1R1Ljq+MJcfxcB88H6UK7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/24 16:37, Ron Economos wrote:
> I'm getting a BUG dump during shutdown with Linux v7.0-rc1 on RISC-V.
> 
> [  OK  ] Reached target shutdown.target - System Shutdown.
> [  OK  ] Reached target final.target - Late Shutdown Services.
> [  OK  ] Finished systemd-reboot.service - System Reboot.
> [  OK  ] Reached target reboot.target - System Reboot.
> [  173.985249] BUG: Bad page state in process shutdown  pfn:f8850
> [  173.985311] page: refcount:1 mapcount:0 mapping:0000000000000000 
> index:0x0 pfn:0xf8850
> [  173.985336] flags: 0xffff80000000000(node=0|zone=0| 
> lastcpupid=0x1ffff) CMA
> [  173.985365] raw: 0ffff80000000000 ffffffc501e21448 ffffffc600f2ae88 
> 0000000000000000
> [  173.985386] raw: 0000000000000000 0000000000000000 00000001ffffffff 
> 0000000000000000
> [  173.985403] page dumped because: nonzero _refcount


The refcount set to 1 when cma_alloc() by set_page_refcounted(), and it
will be dec to 0 in cma_release() by put_page_testzero(), there may be a 
problem somewhere else?

Could you enable CONFIG_DEBUG_VM and CONFIG_DEBUG_PAGE_REF, and try to 
track down page reference manipulation by tracepoint? or for CMA-related
pages, introduce explicit printk both increments and decrements of the 
page reference count to identify the root cause of the issue.



