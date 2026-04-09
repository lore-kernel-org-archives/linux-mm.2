Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED4FCE9DE6C
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 08:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4791F6B0005; Thu,  9 Apr 2026 04:55:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 451616B0088; Thu,  9 Apr 2026 04:55:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38DD46B008A; Thu,  9 Apr 2026 04:55:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2888A6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:55:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB4C2E2C4B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:55:18 +0000 (UTC)
X-FDA: 84638408316.11.774EDA8
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf01.hostedemail.com (Postfix) with ESMTP id C836240009
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:55:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ylb3kxaT;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775724917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sdrsHSwCRgZ6uS9xoPl86hpy3G8uYrU07GQUvhHy4KY=;
	b=C+9YbfyKfhDUK0PKd7diijOGt3cwyf4BuT+BlyMUpyHmhRHIAlfRzVzrnF8G9azTHuGvzf
	TR2AGDrqdf237hE1kr7v5zqfyNeaNmrSBn+JoCluQUxYd/Ew/+Xlar1FePtx2PxqSoBZG2
	PoPnp2LRB1MSdb92fgojw+Cfm4lU0Ks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775724917; a=rsa-sha256;
	cv=none;
	b=7Lihm0E2NBFhm/56oi3XINYDgQDgR9/x3FhaF8l6goeSoMGWQXd6grXrfNvrsE3vZb8hju
	7Ks+cY6nAXRSWloZIRNhThz2YIPnSTjJZs2gQHq7zNXnglfaHLxouYCto5+PgX+zInIoKd
	qx1ZUb6MYcm8z4o75HKCZOVEDg42F+k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ylb3kxaT;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=sdrsHSwCRgZ6uS9xoPl86hpy3G8uYrU07GQUvhHy4KY=;
	b=ylb3kxaTKjTEwhB2+nK78hg3owDGCr5AAKr964qMrhpr3j3fRZ4FgDYp/gvOMkCs2cFU/zJFd
	fpkpYgJaYUkLqU23EB1JNQq9V/jkH2xEfz8BzuQ/jxl7j9X8/c/rC8O3ug9NxVcSNTI2KP4B0bQ
	863Z36N9tL+/AhR5MMHe/a8=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4frtrM5hhgzcbNR;
	Thu,  9 Apr 2026 16:48:35 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id E2A8E40538;
	Thu,  9 Apr 2026 16:54:54 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Apr 2026 16:54:53 +0800
Message-ID: <bdd49511-9b84-42cc-a286-9fdf2ef531a7@huawei.com>
Date: Thu, 9 Apr 2026 16:54:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] fs: drop_caches: introduce per-node drop_caches
 interface
To: Michal Hocko <mhocko@suse.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Christian Brauner <brauner@kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo
 Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260409063503.3475420-1-wangkefeng.wang@huawei.com>
 <addP4MKmA8zfSN1o@tiehlicka>
 <dbb92553-58ba-42e1-b7df-b8450bd69d33@huawei.com>
 <addhuRqrB-u7oDp8@tiehlicka>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <addhuRqrB-u7oDp8@tiehlicka>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: C836240009
X-Stat-Signature: x7bqm35r347g1esmddnzci171azxfrxu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775724912-317890
X-HE-Meta: U2FsdGVkX1/faJdCfIYzgzkq/LUYUgHcVP0LSYSaeZ81x7h3lShBEdwgZtNaple7AK/dycS60N1K9+uEvjrg/K98Vr+kikg/LvNcwQFdFVPM+RrK4rzgZx7rrrxfrxbxUC/LiJBjix+rUKFDX/1eBnROCLS1dHtiTuABWVFH6v5W0kDesbYZj7QBy0zM3nsMQuEDKFgYwyubPlO9Hk5h7ERkGwHY4SiOsvyc6ZIKLpsJJsUzOBSt3rKdmNwCj+JQTGTodPXzr8tBPgc7R1bC7IEB1vr4qWiLJtTTB0a0k++i2Y0M9m7l5/Rb/rK0PYzwt3bFdAzZ/TxW4Bza0NhTa5SXs4WBmZ6kPr/AdJOroBZyZlFgoM7Yw5QzpTpt7RQVXSAdRceWMDwQr8jBPkpkETOjo4FbsKH9SLU8kq/wtvKvM2FtmgUs8VYxMxPrPq0q+N4qqLXsc1mt8F4zTBWcZgUTUywsX+HR9LpxXeAS+KqVjWpwLvM3vpmkVN3jlOxJT9WSGQqJgy8YCfGdlx0XbG1WoOBIaAbt37DHCYmTgGhEywXAHBZ1yta8vT9FDQjckxP6lai/EIXqMM2X9XW+cZsrf6iN0Njsn/3uUiWYsjbHIX43SPhKnR0kfaibu+hSB6XwYd1If3ayI2dF7m+ADIrBOizXnHFG5BYIfkPyhonBwWy6ZX/Xo4OmCdA1v7qEyD8rJ4vfruXCrfv0ojh0hkjm8l4WmJaeEO9iNWa1VNq93/PhnWEB60zbmEQ4XeqONnreS3c+Os6ddHlv/jHBaeovqImG9XvxhRwAiTyPYkougjogscqx5ucUqVCI9xcnNLNrqYaMq2FaKXQxlvef1+hPGpylUTT8JIya+Yos2e291AV5OkJZZhuEHnKAEqWbCh56UIwEolNGy+IZ8y2oCLIlXzORGdcwR8hjVBse5rZiRHxEPgOVKj7t0pLRrc2tuV6G1xrooXSJZx3G6P3
 RUov9EIV
 4PjIdD5mQqdqzSNdwCOOFI1BSPk7/zbExMH6UrcRwjApYsUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/9/2026 4:22 PM, Michal Hocko wrote:
> On Thu 09-04-26 16:08:37, Kefeng Wang wrote:
> [...]
>> To use the reclaim interface, there are two differences,
>>
>> 1) we need to input the reclaim numbers and swappiness, this is not a big
>> problem
>> 2) for reclaim, it supports swappiness=max to only reclaim anonymous pages,
>> but cannot only reclaim file pages,
> 
> Why is 2) a real constrain?

This should not be a restriction, but a strategy. Our product wants to
migrate anonymous pages to the local instead of swapping them out. 
However, the current per-node-reclaim interface does not support 
reclaiming only file pages.


