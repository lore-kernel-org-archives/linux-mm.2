Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 591DF606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 07:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=h9RW0skV
Received: by kanga.kvack.org (Postfix)
	id 66A316B05B1; Mon, 23 Nov 2026 02:27:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6194E6B05B2; Mon, 23 Nov 2026 02:27:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5095C6B05B3; Mon, 23 Nov 2026 02:27:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE9B6B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:27:05 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8320DC080F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:27:04 +0000 (UTC)
X-FDA: 85465552368.19.A3EB4F7
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf09.hostedemail.com (Postfix) with ESMTP id 97FE0140009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:27:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=h9RW0skV;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795418822;
	b=Et2c+MKl4WWCHtyH+HzUFEFadIzgjmXhq5xOSTFotfbhJ1y22aFNqS52Caot0eI3X+cnu7
	G5atGMzqzljtIwMMcjxf1zfLWIj1Wp1MZ07gulUr7rIG5dEPpncF0HKPr7y+RaE+K4/LWR
	odEQ3cA552uto1/gqgybblCQFy6fu9c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795418822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbxLi+ngc7yBEF+RDuHT9s0ss4BFD5uPZn79I/AO1Vk=;
	b=XvXxl5opy6WSTK7k8f78ZyauWLWmU7GAdY5Z6J5Gpsp3mrZOUstoEwL4sWnQQos5YXUlLy
	Plg1kNyZTmln0P2vvr+z9vyyfW3ygB7dnw4vuGZqpDVFi9+bIvJ12iLdNlTcznHzFO/w5X
	Kt9/E7XG/oOFUZrRckEH9UG9jCUsSRE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=h9RW0skV;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lbxLi+ngc7yBEF+RDuHT9s0ss4BFD5uPZn79I/AO1Vk=;
	b=h9RW0skVRwIOIUqLb1y40msOVJQqQ0XsLLplin4RvEHiKv6tUNFr4jlzLSJ/vr17B1ln30g6E
	AOqSUcrDMGNmLVazGVjZeA4506jiAp+nbcAUb13T/zL54B48ePFSNIDuyr3eWlhjCKI9WGTJ6WE
	ekes2N6kQGfhNwY9wpkiGR4=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4jXyDb5gjYz1K9Vq;
	Mon, 23 Nov 2026 15:26:39 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 7653040580;
	Mon, 23 Nov 2026 15:26:56 +0800 (CST)
Received: from [10.173.98.163] (10.173.98.163) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 23 Nov 2026 15:26:54 +0800
Subject: Re: [PATCH v3] mm/memory-failure: set PG_hwpoison of a non-hugetlb
 page under hugetlb_lock
To: Mani Tofigh <mt4022@columbia.edu>
CC: David Hildenbrand <david@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Mike Kravetz <mike.kravetz@oracle.com>, Matthew Wilcox
	<willy@infradead.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<tz2294@columbia.edu>, <stable@vger.kernel.org>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>
References: <20261106-hwpoison-hugetlb-ro-v3-1-c11186963647@columbia.edu>
 <42a60f57-5323-f981-8ef3-2e5d67623902@huawei.com>
 <a87cbd92-0e07-4f84-9a6f-8db0b1778fcf@columbia.edu>
 <b0f30561-aabf-2bf5-2204-20907c40ef43@huawei.com>
 <08b18b88-3ab4-4681-bec8-f4564fe9f1dc@columbia.edu>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <77680005-7178-cb1d-6e20-e23519839222@huawei.com>
Date: Mon, 23 Nov 2026 15:26:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <08b18b88-3ab4-4681-bec8-f4564fe9f1dc@columbia.edu>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 97FE0140009
X-Stat-Signature: e4intby9795b54w1pz3ikdytjdsyk4ws
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795418820-170276
X-HE-Meta: U2FsdGVkX1/4zb1ST9+Wl2wrDufB2VWVhVI8/I8Rgk+TJRXvLsPyAnpYF/q//6LFHJ8eSTXwAXfYhpaASdxoPTdd9IyY4bXlZpJJlJIVd+Ybixo5Oq31BUVjRCra7YNej8yrweKiQL0ECFF/BxUPx5Em/JqIp1lWH3euFcjRHlLZJ0b8z+vx9ohUF4ta9Kvf53tREULTYumiFcFlJmYeCURpgid9pvzUj9ACNE9X/uuNawKqmHRyhgVsOywyx4GZy+IZKrYn+smZuuePSttLR3yMTP1Og4C3fWohpj81Fn04Njt+NepZkfVUtXdsD6O8hmFvHVwjPSsd6i29imNSn7SONNlBZsRXNcztcjprPShBnh9enL3Vq8GdfaVG2nQY0V49kZdk72jNGJwyxeMZrWOM1xTZvteTMMY77YeVgitHWxp0VeCssOnGG42bB+iovfHssio0yIl+PEGSsLiu7sC7fXMIC4lSzH8I8vjvCv66DoJhpwSHjr9V8G3gD+iuj27na7BXY92x/EACgv2gNOLpFxKBFz01/BX8pIz8oJGe6fUjLx7KTaoxpCESX2unCeDR9slpaGDdZaGp2wruLeJxejcSUk5al+TZcY4ma5CLYMxlpztbZub7f/sPzx2f8Hw6m0rrf4CQ1FPVrCg5rl/9NWWJjLiYqkF88um/Pfa1vVM8Mlr2md+nr+auQ/ahTTCyRNQwDNFmDjnjq9+aqZn6P2pOPDySm+Abvl0gpOckyNWGdTEBBzb59o7dM2RfWZEWOVzY+5N3UJq9Iiz45d/D+UAH9Rt62Oqcu7VQbfm10GXH3TjpTwXtrJRdRui3H4MAu9vAINWwIam39zYw8l9gFxsVKS++3RywMok6nbKRGIYzxGzI7q+XIO2/qM3VnlgSAiWLzRdM9Jq5YsWyrmhcympRp864zD66tkH8iitdpefhSQqxFJ5GULCkwkMo0wmXjB6hb6ow08vBx60
 MHh2CCDA
 i1PZtrZg7m65Np/o/IScqGEdIn8Dajay6u68jx9wTbptqURbJKTXLtKr0xpeAxTUe4437fwazSG0psRocEZP/ERNYiRz22ARWH0I8HtBiQEDRBR5y80gR+wTWjRPKxy7txshAuDlXwfY7lQVRj3O9tsM/rIB/biugz3R0SgkoCpa31qvv665dqB4N9ngD3mWuwH4jEKu4tam/uNIFFPAM9jatSlSJF2NRP50TikaE42ckfCWUMwPhxmBs3jt2coD678vN64SYWpfqht/PPJ64pIzbJjPfongB72L2pEcMBvkN+7lLd8B9Z9ijk5dvY71+4WVsr388PWcLrbwGx5knKTOxr2dvP5RgDC2aGEt8JvhwVz+ycE1Y2GpGq8DGbg8UroL398DQ1sQlPXXhwOvx8vtfs4Fq6AVsCn2+4y9RaeC3IeVcvNANKh47CO7h82Bxm35cET09kYn1tFkUlt+mcn/ap70A8038932LyMekq1zAqT95arVWDGO6bCu76Z3/jAN3haWcQRLvlPrjbgNhSkElWMHe92rmcX+2vqce+uQJK0M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/23 14:19, Mani Tofigh wrote:
> 
> 
> On 11/17/26 2:01 AM, Miaohe Lin wrote:
>> In both cases, will the hwpoison flag be lost? If so, would TestClearPageHWPoison work?
> 
> Only if P's struct page is past the first vmemmap page, since HVO frees

If P's struct page is past the first vmemmap page, the hwpoison flag is lost. In this case,
do we need to do something? Now that hwpoison flag is already lost, I don't think so. And
TestClearPageHWPoison won't do anything in this case. Or do you mean TestClearPageHWPoison
will always write even if hwpoison flag is not set? If so, can test + clear do the work?

> that one. In the first page it's copied, so the flag stays. And

In the first page, the hwpoison flag stays. So TestClearPageHWPoison can do the right thing here?

> TestClearPageHWPoison() is still an atomic write, so it'd fault on the> read-only tail (e.g., 6.6) the same way.
> 
> 
>> If the page becomes hugetlb, should we skip the retry path? try_memory_failure_hugetlb
>> can't handle this case?
>>
> 
> 
> It can, the only problem is the stale flag from the first round. With it, hugetlb_update_hwpoison() thinks the folio is already poisoned if
> P is the head, and unpoison_memory() drops the folio ref twice if
> P is a tail.

I think we can correctly clear the stale flag from the first round.

Am I miss something?
Thanks.
.

