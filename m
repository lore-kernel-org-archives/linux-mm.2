Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D6DBCA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 14:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A03BA6B0096; Tue, 19 Aug 2025 10:52:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B4A46B009B; Tue, 19 Aug 2025 10:52:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2036B0098; Tue, 19 Aug 2025 10:52:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8169D6B0115
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:52:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E377138152
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:52:50 +0000 (UTC)
X-FDA: 83793798900.11.95F1C93
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2AE17C0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:52:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755615168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k65romq/+NMxbn3YAJT6YNQIcJzTkfkbePZg8yS9jS8=;
	b=6k91EtPgbroZTH5a2FktydCLZGdZWyeA/5r/lbKM2+r6AV2104Tr9RF5ojipAYR4AsBYB2
	mF2qC/M1UbqAiC1SfMiZszm9hnC89S3Zks1K2DBtH+pUHs8LWtm//1W5GK+qKCOeszRMla
	aMy7wS/CilSyxoSKZYihzL4sCJK7MT0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755615168; a=rsa-sha256;
	cv=none;
	b=qLiDTnWwmzc29/4Wcxfev3CrxVvKYYrNt6F4j4WungDMjPHqNH9zHlAF6Hhy7PCvquWJBX
	8eO0ZI23N5egV/ngs1hVgxqJNK7iruK+ZKQaPunpuDBGmqrdub6QRwABCQx1NG89COvDGR
	W4mJGZ2VEWIFLz2nsz1R+IytylnO16g=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c5srz5CmDz2CgFZ;
	Tue, 19 Aug 2025 22:48:19 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 2914E140149;
	Tue, 19 Aug 2025 22:52:42 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 19 Aug 2025 22:52:41 +0800
Message-ID: <48fd269c-a61d-4459-ab86-8235adecaf93@huawei.com>
Date: Tue, 19 Aug 2025 22:52:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH -next 12/16] mm/damon: add damon_ctx->min_region and
 damon_target->min_region
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
References: <20250813164907.5885-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250813164907.5885-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2AE17C0005
X-Stat-Signature: jn9cf69fbzxgzy9iqda141f4ehqxa9pn
X-Rspam-User: 
X-HE-Tag: 1755615166-302619
X-HE-Meta: U2FsdGVkX18OZ/luM//fZpaMxkGC0Wq8eAku8jLABoys1VtIzWCgy+MXCq3NujD5EH+an4wqkAZOr0cSQLLd8lJCFyAiJh7LB96XlaBT647QjUVhmzZo9w+KrAHh1WBnlwa3TgSFYL/ToWRFdUjrmQmTYYKrd1yaGyWn0ISDgNvjJzAmlYLZSVfeVrugKU7S2zhTCEEVLZTwPGjEYAyPX5ZwgoMUWttdyxrKwrT6LpvfoMGqUjhtJQ6hctJ1S5OnrmqZgc58WV8JrdBSd1yjYz/qCjdFO+rlCXqWdpKgPV8mfaHKoWq+EC2CT0hHMezAeUPOps38hhjJpMWObWRPFQXr2chq5ZFE4inqoe4d0Ol8G9J9sljQFvE5Pg+Om7D9PWbOa/2XFbQpnjs+pFscWoZZ/SLy5BT8t4fgHsJSUe+GhZ9pB8l0EUgZxcLNY5zeJrxGBA83TM09sY5UPNFfB2NR2VLNSYW2bCSs8uM6V6Ko3x5nAkXHXg3fCPe4E3zweH7gYgtCsWYDF+HK+DFgsyP56WOkEVckIryugALXohZy1BSmqkSaLVBRCECnZZtIOR8diF6VGqZM13lsXr+GzJW6ioL8Hq/vc9WNrsi9KV2f79YNjUhzKvBIR8eMQa6QEzLCd1PMVbd2FqeEuE6lJYQEH+jqUf5N792OLNDG6bZpZCmfJjI5Dwnjm3CdjYBT3afhIlkjO4wmVXDE9WKQH5xGx77cm0ftG0zsaTFiZaFP5fsEzngLECuuMLvYRjI/0Ie9zkaJkvnYQl7V+o60xekuKulUIXIYtLJSDVzf6eNl58Zq4kM96l2S7dLX1hqsRuMf+APWCSd5RRhkBU3lEiIcKn/9nV4r27ReQmWu4rg/2cpE7YtZ04zacFgt9LYTCfXhlhgmimi18pxNI5q3y9fmOYq9c+i1M/mrVK0cW4mBqMZbBiQ9lvXJq2oTjxKG3CAJi0csRqopuu+9J0e
 NDw8AEGV
 T6Y3Ni2voIykotBT8CySNbhFgW7bNL2O1BdIpS9F5+4m3XSZ6JG18uyA5Q01TPrHPuP/m8bztgaEMqJ+7BnOYj6HkLMu53IFsKxk+XiF7bEv2M3oMQtGEa43Y74DgOPyDY5uQZTc9c6obLpsjjKkMTslEDcAKa/QCa4Rix9mdvsV0fcVoEtHEKafwk0xLxsSFtOkrLxwZSb1McWQy71hkLk7lRvwDqhwlwS4yGoIOb+yPYHgwIYL+f25sm57wyn9P8WRNUZrAZhEiHNt+WohkEbURPWGCRHmtAZL5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, SJ

在 2025/8/14 0:49, SeongJae Park 写道:
>> To me, keeping the synchronization seems more complicated than just passing the
>> addr_unit value to relevant functions.  I'd prefer passing the addr_unit to
>> relevant functions.  It could require more changes and might make code uglier,
>> but I think that's easier to maintain, and we can cleanup/refactor the code
>> later.
>>
>> Could you please do so in the next version?

Yes, I've revised patch 12 based on your suggestions and will send out the v2 version shortly.

Thanks,
Quanmin Yan


