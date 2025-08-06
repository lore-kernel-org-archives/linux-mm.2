Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7D6C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 03:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE26D6B00B0; Tue,  5 Aug 2025 23:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E93306B00B1; Tue,  5 Aug 2025 23:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D823E6B00B2; Tue,  5 Aug 2025 23:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C6D996B00B0
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:05:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B5461DB8D8
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 03:05:46 +0000 (UTC)
X-FDA: 83744842692.12.D938E95
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf24.hostedemail.com (Postfix) with ESMTP id 50A3B180009
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 03:05:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754449544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oPq367EsNv26yzKmsuK0ciIoqBobmIU7yREvY214uO4=;
	b=uqqGEm1ZWeF+ZNaOXogJCyziYMDH2+BwXzGUg5nakPsV7Q+xLPvkLJvY+qj0WOF6K7zZMM
	xAp3HeXqnU93KVelPhjEJnxu7slrerhMAKbwv8hrlRpL3MiT9b6CyCU54GnCLv/0cQFm4y
	XhTi0gNIZg97abqUEIckZYeNLAOMEk0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754449544; a=rsa-sha256;
	cv=none;
	b=4M1VubWzaeRRdvDODt9vM42emUFCaaaqLnaLDF1SOKDNhK32yWV5S6q54CZF4mDblkI6dG
	wKk9Ug19qIi/UaV4j881HP9wsOqkF7jYh8N4AlibFHIa2ZZlQ2qm5TXnu2D9EoaWjHGbJN
	4oPt9sN7kpEM6znZJYfwA+dilDfhle4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4bxZpz4md3z1R8pl;
	Wed,  6 Aug 2025 11:02:51 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 5B336140294;
	Wed,  6 Aug 2025 11:05:38 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 6 Aug 2025 11:05:38 +0800
Received: from [10.173.125.236] (10.173.125.236) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 6 Aug 2025 11:05:37 +0800
Subject: Re: [PATCH] mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn
To: Jinjiang Tu <tujinjiang@huawei.com>
CC: <wangkefeng.wang@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <xueshuai@linux.alibaba.com>,
	<david@redhat.com>, <ziy@nvidia.com>, <osalvador@suse.de>,
	<linux-mm@kvack.org>
References: <20250806020520.631203-1-tujinjiang@huawei.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <1e63c37f-8eb2-865d-d3f4-9ef928f1a959@huawei.com>
Date: Wed, 6 Aug 2025 11:05:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20250806020520.631203-1-tujinjiang@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.236]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 50A3B180009
X-Stat-Signature: w7nxw8zz4zy6xq8s9en3w3f54ydx45tp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754449542-953339
X-HE-Meta: U2FsdGVkX1+MUJsdnhek4BpGdT9JjBycLMTOjZ7mVKrnYeK9J4DFsio1neN1T6PfPCJqXNwMOj0SVPH0wkoeORf/3YMJjlna5f6pX97uWydU5jjdvPjPa3M6ZMn6tIK1RXjuJ9RudCQ6dPnHQT4hWiCinef7+mIkKBJb+jBZLsm/sF2jHA3N80TWdFluQ3Qq3d4q4ZmzMnGxGcQQWBbiy1hygbVz/Pf9Oa9tcfuQ0XQlceQ15HkBgevwP3rDdGwl3A6oqlBeNUcpP5iiyiQdYW+9kewoJVz/lXnwLT6imS4z/+PlCfaLZGlXEsJFmrGF5sfd7jOrBzqedAU5Xs5ay3aXf8BdjuB4l90waH85h76TzXSorHc2Ah6bgS0pTTFJ9WV3p6F+01AddkciyRn2QpolZ3qrUnwsr5Jky6PblmkIELO7M1UmT7g5vjzanKYKATXSmpkK8YRoK4SQYPwgeNyW1vHBD3NYbp80Iv18VBA4AF3qqWYnT4P4MOBNGzcuaTgWwyAqS3jR9Z/aupFtqGZwBxKQ7+y//cgVNVZcjp+5mWcezDeKXFph2DdtWa6WcRWJyoWLy5ggdVQYrrZLS+gqhGGTUWd0ZN/EY2pVzbOJK6hsKib3tjY5bExYxOgY3UmisblP/EZys7irMW2FoLjFwau9wBCqHqAx5wOjbV7W7M5eFCf0FlFQLMIfFBUZ2/Oyg1YVYirQoYjYyhSYyAYx8e2o6jnZ1ZQ+Z9znPSGIK3AelD8Anx5E/fxkucIXLFpVLFBdZftuPdwuh8e4JCuuJqwgElzXiE436BM83aSSvLqSTh+Wh7n0i4AzPpo3B5tEjaMiMhKxEK9ztMfPMn1Q5qTPiRCUWqAQDrvR45FdpXVgNQG8VhK+77yoqOl040WU95Y22haY0Le4zt/PPf3wkE5EGg/LmRNILVjs3qkaBgleiFV4Sixm3Tt1S1C7GXNQmEpjDgMOJKWtsoN
 rAjhHvrM
 38P66ve0p/rlUKAbfIlcYoEyNujfU10+cYdrLbcwm01ELpx4asnIKGolkVVjbtP622ykDtGPQX02XXq9Nmrn+DzngECyVagymDQ+uwed24gkLygXoG1zZIg28rwXOvsVPpoxFoN7aAh2S5X/eP2J9OFkxV8PrRBB2qjyOliVIjZVJMVutSShwpcF+D1O6ZYCDyoH+t82Ok7/t2qZju0Me5bkIfLW4wmLXIJurD8hOF2XKbXtFErt+lU30UsNK1tEGEbPTA2jTZs1gSx4lvn5sLK/ez43z7zW1QJYh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/8/6 10:05, Jinjiang Tu wrote:
> When memory_failure() is called for a already hwpoisoned pfn,
> kill_accessing_process() will be called to kill current task. However, if

Thanks for your patch.

> the vma of the accessing vaddr is VM_PFNMAP, walk_page_range() will skip
> the vma in walk_page_test() and return 0.
> 
> Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes
> with recovered clean pages"), kill_accessing_process() will return EFAULT.

I'm not sure but pfn_to_online_page should return NULL for VM_PFNMAP pages?
So memory_failure_dev_pagemap should handle these pages?

> For x86, the current task will be killed in kill_me_maybe().
> 
> However, after this commit, kill_accessing_process() simplies return 0,
> that means UCE is handled properly, but it doesn't actually. In such case,
> the user task will trigger UCE infinitely.

Did you ever trigger this loop?

Thanks.
.

