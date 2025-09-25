Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C2EECAC5AE
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 01:38:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50CB08E0008; Wed, 24 Sep 2025 21:38:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BD4B8E0001; Wed, 24 Sep 2025 21:38:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2DB8E0008; Wed, 24 Sep 2025 21:38:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C77F8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:38:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D11DA1A025B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:38:25 +0000 (UTC)
X-FDA: 83926062570.08.F338DE3
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf02.hostedemail.com (Postfix) with ESMTP id 833E58000A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:38:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758764303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ryp1xLncQtEPwbkCyGjrMyDXNXZyAGz3HKpMUS7r6F8=;
	b=rUMwhFwlsBozF5XJhtGbtISXeB6WVd8Y4BoMwSp6VqWgPyl2UnqsedjdeZjKLViOB6RLxI
	qZKpH5zGTpd73p78RDKtK/NF4kGzQw0s87WDRfc3eMHJdozQIf3V2c9/qf3g1SfibHN6WP
	M2go2J0RI4pq8mNcEwCISYp3Z+VR/lo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758764303; a=rsa-sha256;
	cv=none;
	b=DhmRCOGHNgjTfRI1EhHvf1t0pXghKuXQmflLmbYMaXq6SgNnMqCXAIXLWjIanYauXWp1BH
	dnVMJ4jhrt/ttNRtKg4vpBiJ+vdgGsG547N3k1HpH/aBl8uoLuBmYqM0rYVN41xOOAcCV1
	t3ABXi3LZMuDmdaLRpeM1hU04WUEzTk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cXGVj07Q5z1R97M;
	Thu, 25 Sep 2025 09:35:09 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 36E321A016C;
	Thu, 25 Sep 2025 09:38:18 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 25 Sep 2025 09:38:18 +0800
Received: from [10.173.125.236] (10.173.125.236) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 25 Sep 2025 09:38:17 +0800
Subject: Re: [PATCH] mm/memory-failure: not select MEMORY_ISOLATION
To: Xie Yuanbin <xieyuanbin1@huawei.com>
CC: <will@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<nao.horiguchi@gmail.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>
References: <20250922143618.48640-1-xieyuanbin1@huawei.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <76680374-de67-0227-c553-7ef57178c165@huawei.com>
Date: Thu, 25 Sep 2025 09:38:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20250922143618.48640-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.236]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: 4rubb5sgn7qsj6ht8qqjowk1yncs6jpm
X-Rspam-User: 
X-Rspamd-Queue-Id: 833E58000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1758764302-286622
X-HE-Meta: U2FsdGVkX1/bvgCGuvUVe3eB7AuqDsgy9ou+wQknxSsix6Ky7zNsEGk/B02P312gFvVBG/+DyPm9fTnR7gTA5gUrWM2dLxbhEu61Dz1u1qSXc47oEzdivSzkXtHIsRbXE0hm3SRAR/tF7Z72JWFgA7/Pdpmv9tYRHvflW28Z46s3mTjMjAvLirkIgdgtafQHym+7CYP9iwl4+72IqCc7ZgUn3mdAf7CacoF/71HF6OlmFbd6dpNWKJsjyD0DTKm2l6Taur0G+36A/VSZOr5jpihOSX1V2QaYU3lU2hWrm8glhPSjsEgEjT3FQr62023FHbjxPZ5GIslQtZCsEPSKzLtSgXKA2sDRGnaZGghWlV+eKeaUHj+MwAWgnCMQpFjx4JBbwJ7JM5HEF7oInWYCDCY1/qxVHicuFyNLIt8jY20PVs7hId290rNieol+TbQmYGeRYwIyMK2azSihWESMHt64/5PKx9jj2Me4FxhbFt/HDs1hojGGpt5fp+4ZB6lGfUKZ5Ya4aIRRPCFP+BU6m8CpFVT8I/m9f7vyPQhOmOAySXctlOprk32AMOnUH4tig7FiZlDAD5CqvW76CZ2xl689dw/v2fho2tBBu3ueuvgI/qW7tel38LKzfUP/p3ZRBnuZnrJhcWjX/gpsp3IvIVl+TYdnir+nol2QtxNAuj1fJN8uJctbVoWbkNzntw8vU2knaRcw7aW4WP+LGc2APw6y+8WBHgH4vBFWM88sL05kPmP+PXozL7dBWtAMkkMWqOzir0sxjHhYX6A5Hjal9F02R0S6tsWK7XqVDU37gk5dKhI+3Zsm+Gw0jGJK+n0QdQTghmwPzuwafhiNcZG8cVXXhJvkX06EtOqUUfn5AME1XlBG6roQzQQ3slsXM2g1ijARvRhIxVnpH75rg1sZr9yfeE2yCHl2suCmO0AmUBUbo9snWqrGoG7egGgqUTwsgP10VBe7RWD9RNDZtd7
 v4ShPH9J
 Tx9av43xioaO1b9z+Y+f+losemBHjkFuYoi7fSPrRKc2b8dh99mYma8ZTssYEmyVVzeXouGZeYX9+4+Cnljn3K8TCnbRVc3o9ZKJSHkZLyfrGs9BuHd7carxe9hIXNyKvin3kyEAztSJCG8KgUuEhLI6axJ5nzqysZeB8BTcOi1/OCU/PJYM9KLvYoiEyhDmGzmKSLC14XG5UvkjrPpy4kpnRYlwu0V+jOi1LhZjgrH3i0LcROOkmPZugNmNTOO9cwvdwY4+8NOS5pt2GM+nN2TXSga+WKPBnfuN0J1Sj7KiSyQGdgmwHFZf8hqnsONhN4claC5Y5xtk7IYhrMBy8A9g5Ag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/9/22 22:36, Xie Yuanbin wrote:
> We added that "select MEMORY_ISOLATION" in commit ee6f509c3274 ("mm:
> factor out memory isolate functions").
> However, in commit add05cecef80 ("mm: soft-offline: don't free target
> page in successful page migration") we remove the need for it,
> where we removed the calls to set_migratetype_isolate() etc.
> 
> What CONFIG_MEMORY_FAILURE soft-offline support wants is migrate_pages()
> support. But that comes with CONFIG_MIGRATION.
> And isolate_folio_to_list() has nothing to do with CONFIG_MEMORY_ISOLATION.
> 
> Therefore, we can remove "select MEMORY_ISOLATION" of MEMORY_FAILURE.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

