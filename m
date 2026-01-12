Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A3D2C9EC8D
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 14:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F07386B008A; Mon, 12 Jan 2026 09:32:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81276B008C; Mon, 12 Jan 2026 09:32:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96716B0092; Mon, 12 Jan 2026 09:32:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C55EE6B008A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:32:23 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7ED811A034E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:32:23 +0000 (UTC)
X-FDA: 84323552166.13.2C66403
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5B7674001C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:32:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768228340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Wlt3q+6BdH5/BP8+FY2EMxRhOM89wbQaqYnJwRyTq8=;
	b=7hc+X9w++bttmZhYbV1qfwhlMwLcb5zCcyinvj3F3q+put7hEMdMs9WbhSe/me29R9XyYD
	o15FGT+FsdjEx4CdKkdK5VjW3dOyunkCUkXoVkPOddNwc/CWxaRzLVgFYv5x4nP/PG9QCq
	m6hhC5EZkHpTNliBTd5YxF3PQ6BPIZU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768228340; a=rsa-sha256;
	cv=none;
	b=cEC/6GYYIRllUZsJJcghSkDBYnDXWxvGV30GHd7PN+Gy4xGM+W05ExdzSoZpMLoLnJyZ0A
	i/TST/KHLMpes4lo35ZyOi7Yh6ZhNlWsesOeieDeQ0nuzQEXF2hQoP3iQwIlywZkaGecME
	Dv8H5ydy9gzOI20o+Gy2kJUvwNnCTaw=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqZZm4ycNzHnGch;
	Mon, 12 Jan 2026 22:32:00 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id CB88A4056B;
	Mon, 12 Jan 2026 22:32:16 +0800 (CST)
Received: from [10.123.123.67] (10.123.123.67) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 12 Jan 2026 17:32:13 +0300
Message-ID: <d9fe0fb8-2c83-4eeb-8513-853522909253@h-partners.com>
Date: Mon, 12 Jan 2026 17:32:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] mm: improve folio refcount scalability
To: Kiryl Shutsemau <kirill@shutemov.name>
CC: <guohanjun@huawei.com>, <wangkefeng.wang@huawei.com>,
	<weiyongjun1@huawei.com>, <yusongping@huawei.com>, <leijitang@huawei.com>,
	<artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<alexander.grubnikov@huawei.com>, <gorbunov.ivan@h-partners.com>,
	<akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<harry.yoo@oracle.com>, <willy@infradead.org>, <yuzhao@google.com>,
	<baolin.wang@linux.alibaba.com>, <muchun.song@linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
 <ec023298-c26d-437b-a023-b49509f83c5a@h-partners.com>
 <aWTfduyPXjhymyzW@thinkstation>
Content-Language: en-US
From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
In-Reply-To: <aWTfduyPXjhymyzW@thinkstation>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.67]
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: j799f3mb1yf1rfw1kpo17j9owk4bqtcn
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B7674001C
X-Rspamd-Server: rspam08
X-HE-Tag: 1768228340-799990
X-HE-Meta: U2FsdGVkX1+qJczZow1S3y7WTdVuVoe82HYsMnItgSjbDqLeTtLIGSKwaLAa4xw1GC8rLo27/sFw+N9+jX/uvTva2mfaCKMAREU42H2Uf+YebQkJXQnJd4a72t3jj4W5qv4Kyu+DDZPD/W5qeorWnzMaJceZdzCUnTn1saXCQyH/VKgSg6HTvReOvDRIYd/sjS1P0570ilB3e5D8yGT/8z7eOj3xao7HHgkI2GyM7OcSqOVQS+4Zg2SJ/QlkuLnSHfMbZXjCDRYUUDSCfiLbBue7bJHwZofOHOwHDcRMT1UunxyywEjFaQD0yFGt6Nl6MXfFoCc+1ozsCCYVGlo7wD5MgFofNopb++gCYMBh5bMHoKsozcJ+DgROairmpKeiLOgfgDCPqnD8NRqoWv7RXW/OPg4q7n6M+AeoTa6QcpwZyq5FDselCIYzm20tN+mOgBKBGMbl0vEnRlYtlF9KTJXDUBkjSWBGZZ8H1BFRTEH6sDyTCVEz9kreCw/q9tFo4dVSuvnJwR8LtMrc/Bnip7aC0OfYOwhXTs9sw/6Kw5tFZ2yapUtWfJuFK4ZOemarNwAtzl2YXqixJGYEOzI4nHVBYStNdQt8lRvVVIeT6v5dYdqGvVfN6H2uroijxby5Z5vRkKUDcMgO6vgU05DW+abS/NoUPTcBLdjQ+aljRBnJY8sZkliUJ4CAHLxjSxXX2rT8pEvzRd8SgKb5W9rOoYx2965w8paK8sY4iJfItjIup+5cizdfE6bpqb0vuD4Ogg9JhgFWmL/Zw9HHbD17URkujPJlTYXm6OTrvLnP4yifc1KrBTLKA0KSG8VuSObOsIDiiJXa5FCrBaeaKhiZqolJUIsbs+augmPaUPcji4x9DHTuTcTljZMx8GmVpu1osFhWpypKlze1VDWn1UfIiOWBCMd0B03z9suRlJHHA66C7tnZ+0rVCNOgqp06WyMBbxyG2jXJtinDiY+xbH7
 x/oJIyM2
 36clWRGAR6vGfTHAn2urSp9JkN/TxyfhRc1TfdKLkgzYmzYu7KxOmv4j5cfAB+t2UQ5hPlh5OTVya8AsChUGeDZjrFkBfFyLR8DHbrms6ldRSosehu2GxMzAlYL268O6PTZ7bq9EhQbURN+BQluvLaO2qTldek13yVrbSOmc5LjVz21ji6vwmuG0awDelm2DG6bQnMHaQ196mR2sJ0pEdDwwPQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/12/2026 2:49 PM, Kiryl Shutsemau wrote:
> On Mon, Jan 12, 2026 at 11:30:38AM +0300, Gladyshev Ilya wrote:
>> Gentle ping on this proposal
> 
> I generally like the idea, but I would like to hear from folks who
> actually understand serialization.
> 
> Also, do you have number for "a full CAS loop when the counter is
> approaching overflow" thing?
> 
I am not sure that overflow is a real problem because you need a very 
specific race condition over a long time to achieve it... But as a 
safeguard, everything lower than 2^31 - #max concurrent accesses (~#num 
cpu) should work, so let's say 2^30

