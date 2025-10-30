Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D15C0CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 12:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16B7A8E01C1; Thu, 30 Oct 2025 08:02:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11C6C8E007D; Thu, 30 Oct 2025 08:02:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F26CB8E01C1; Thu, 30 Oct 2025 08:02:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DEA7C8E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:02:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 942935C4E2
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:02:48 +0000 (UTC)
X-FDA: 84054644016.30.D9D576D
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf14.hostedemail.com (Postfix) with ESMTP id E081410001B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:02:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=AhlBi3vu;
	spf=pass (imf14.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761825766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1F4bKlogCSdJhbXuKbxSuX7GvQDCu2l6WO7cEZ+I/rI=;
	b=rb03mCdADGL/4v2zvi/kV6QjIIx/Jo74gdfffvtVeDBvr3oBE+/o2Lqp19AoMx5ypfk6bW
	4UULPIvczrUsSMRaW21m8dMkdd5j0vQQHFv7ufsiExYFHpLvkvvYe1BXDVTkD4GVWGXaVr
	YbaM/bw2E0gBwmXluFxGsKvD9sa5qnY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=AhlBi3vu;
	spf=pass (imf14.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761825766; a=rsa-sha256;
	cv=none;
	b=M85MJVM5Erqodt1JslSvsbib3My/XXlSFopgwZ9Rorp2f1TspQBLahC4atJy7pSckjgMAE
	lVE4jlpK+P1W/n52k3Ejc+3Hk413KIVxnfsWTfc4dIP/iN8hfA4/WhfI5EJJW94ZZJZcWS
	vd5l00yf5mNfR4vszOb4i0RjpuUrZno=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1F4bKlogCSdJhbXuKbxSuX7GvQDCu2l6WO7cEZ+I/rI=;
	b=AhlBi3vuwTuvlHKVsPyoRDWnzjbzXi7d9/ewCnESowJHxtRvlj/DDl6wY7MXLFXRcoA7PzqNf
	4d0NR8obvadoHPq1vEbHRxrA4mzVMaL0s+5x+TQmen0eNam9hmksKvYlIwh5dUPrNk4GL55Np+i
	KO+6HO75rVJl2G0KMINtofg=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4cy2m21JqxzRhRF;
	Thu, 30 Oct 2025 20:02:10 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 06B0C1401F2;
	Thu, 30 Oct 2025 20:02:40 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Oct 2025 20:02:39 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Oct 2025 20:02:38 +0800
Subject: Re: [PATCH v4 1/3] mm/huge_memory: add split_huge_page_to_order()
To: Zi Yan <ziy@nvidia.com>
CC: <kernel@pankajraghav.com>, <akpm@linux-foundation.org>,
	<mcgrof@kernel.org>, <nao.horiguchi@gmail.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, "Matthew Wilcox
 (Oracle)" <willy@infradead.org>, Wei Yang <richard.weiyang@gmail.com>, "Yang
 Shi" <shy828301@gmail.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <david@redhat.com>,
	<jane.chu@oracle.com>
References: <20251030014020.475659-1-ziy@nvidia.com>
 <20251030014020.475659-2-ziy@nvidia.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <dcd66748-4449-22ec-70ca-1b14b0582437@huawei.com>
Date: Thu, 30 Oct 2025 20:02:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20251030014020.475659-2-ziy@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E081410001B
X-Stat-Signature: rpupagp97xng5iwdxrkyh1coxeyj7zbz
X-Rspam-User: 
X-HE-Tag: 1761825764-151223
X-HE-Meta: U2FsdGVkX1+FN54YrfYJt1YO9GGm2hDkOW4EXeAPJfgyPsdxQxJYVLXk6aecdn2+gagEoOaEP/XOnf3V1+3ot1pGLH/V6xJwhRx6d05kFUOWIJvDwGkLH/4wcCPe5eiDgLnUBN/heznQJBmKcXjDmBJOgBl1AdJcd4k7b0lG2ieuK/VUqX4+lt9D/cL5ZpbPThY0Wi3u/u+ygJ3bi2USrEPxRpfcbdRpdGzLhDN3zOvx3OXfEbXor4gCXkkn3NoAjvheciEJrmw4RMTtNClK7xyK45YkRytndOXRs7+YFlPRDB2uZFWxyuV70qgPLFqWsdlUYAj2YTAL1kvGjYLsmvAyKBDi9czPB/Ag+ls+hcZIvBJCBHMedQ8aw6bbJgU6MFdKUFeXeoJKltqlgTUNjdmyw8aLWv5S7KAVYdE+FF3hsiK4pkCfZAJyKuIHDY1atoIyMB58LjuBrQvqLuNXy/Xxyv8dfgTZ1HSdro1dzIoKWLm+8Y5lwwDVaBHpVOhYrHtVz+vP4VUXXX/ytNe+MHH/TRnvzwC3DRCD35ph+InxpVOxkJLq2bZ0Dy9QWPAUKF4t78uioEb6iyJ1MCfJJSwwAiZ0LajEM0Cj6c2bTpkKURIt9Tpy7wuLeyeRlMbhho+fzEhCc6xtK9ZFd0vwefRfn1+DOndTgMMoi89ELs6NL4wsOqVsloxLSA4AZpeMz1gxlzyOlXA0XB5lexHa4UHE1svP5fCHOcFD7hMyHyjh1zAPKjkorDz/LD9gT5k+9xciRn5x5QaVfTLYrSv/hS6H26ugAGVZFKO7zru2abxLx6KV1TEk9LUxOn5UWCF+edJP4dKXKxFX/oV+7QgaYVS1GCDES8uh/2d/gin2Sp/14SteVuMYxO24cGquC0STSVzWkK8HtHziXEIeG8Yy2IJTx5+TnNV4NZpyYd24etTObM+XbDPmIvIxCFxqtjJPQ/ADYmiPq4Xmale/rBc
 dUccoWLg
 VM+6RV39B2xeO3In3NPg187gQgcuLFW1xwslgYQz6Mjpw440UEzDUM8GAY4BG04MNjC1c+X/EAIkHMazh2AlomZ1JHAVEQerFWVVwDGy/+Krk+49iBaS/m+MQGYa1IJ3Fseg7LCXg7R0dbDoMd2/NsFe7WI8jGx7L3fOH7lS4S8bsK6MVAgywOgdQ3VbufRKp/LUXizEmWluIVqZkqArP7I/lT4TyTbIpJ976YcIu4bsOyoBAdXfnDOj8eRn3iqlAR9r5hYDYtPd33+/a/2++T+DPFtSFeCD2+k9WnmneN3sUv/lCUn4u6ietM9qL3kWF7YYPRvyf2Zy+EKddwaMfCifK0IR5oN/tTZqXWKqv72ZfGkgGoHR3MyK3ULKn7ykmSxSDq7sIYnS257dun04yyc/w2gApBWN2MiBjrlPwV3FHtdOBjGsWAUtI1Inws3gb39NZgj9BQVXgdeYsbvxWf7BRfQByNEncgaTBpZ+DkUg/01I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/30 9:40, Zi Yan wrote:
> When caller does not supply a list to split_huge_page_to_list_to_order(),
> use split_huge_page_to_order() instead.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

