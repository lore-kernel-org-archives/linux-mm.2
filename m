Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80DBED73E86
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 03:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A642C6B0005; Thu, 29 Jan 2026 22:07:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A10E86B0089; Thu, 29 Jan 2026 22:07:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9473E6B008A; Thu, 29 Jan 2026 22:07:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 84A1F6B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:07:17 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 342EF13AFDC
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:07:17 +0000 (UTC)
X-FDA: 84387144114.29.5E9BDB7
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf03.hostedemail.com (Postfix) with ESMTP id 450772000F
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:07:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=OSReZxRq;
	spf=pass (imf03.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769742435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=doBblbOwHdShc4Ks1wKLoAH6Jx+hawhblsEzVk31/Ac=;
	b=Jp6XIh6BxH0wVJnPC3MGXyHr+/xwA83xsmqKllSrlcT+zdj1zpUNfzCJLC31f02sbRGLu0
	ERHC+B/hbwMzjAoIWOENoQgK8xS2pPa/Wghr4+HiPCE+q6RIddcUvSz38nwwwtZGNzO4TJ
	nYXMUnuUG114KaIeQHlMYcerdBwTjCc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=OSReZxRq;
	spf=pass (imf03.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769742435; a=rsa-sha256;
	cv=none;
	b=jCKiuDVJcjY6I4w8KYFIIUq3m0cTFi7tHmTlrlbGgr2nId/YErJWCm7ZWj90uvmOMTOwi2
	ujFoMl80uP4N2q4ChROnS09Z5WYZrN3OVnAy9S1TpBdskotWWHs4v1FVXiniaRaCqaOG9h
	QR0TzUs/KEejrFY27vRQ4P2ZcTpmnAc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=doBblbOwHdShc4Ks1wKLoAH6Jx+hawhblsEzVk31/Ac=;
	b=OSReZxRqks6Mn+4xZc/BGDtgA59KlnSpys1LAlyeyCDRs0CZLytsQPzK2cJ+3MZyX175minF6
	3gCTz2appOma9TEGWjcaEExiVmR3CWOpjrAY0n3tfxvzIe3lLibNn0031sRfHSRz6h0SyL/dYKs
	qhyg/ULFl3IFSFttv8/qlws=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f2LRm4ZnxznTVF;
	Fri, 30 Jan 2026 11:03:16 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 8A6C64048B;
	Fri, 30 Jan 2026 11:07:09 +0800 (CST)
Received: from [10.174.177.149] (10.174.177.149) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 30 Jan 2026 11:07:08 +0800
Message-ID: <71e02d8a-94b7-4b9c-877e-5efd4f7aba44@huawei.com>
Date: Fri, 30 Jan 2026 11:07:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon: unify address range representation with
 damon_addr_range
From: Quanmin Yan <yanquanmin1@huawei.com>
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-mm@kvack.org>, <enze.li@gmx.com>, <sunnanyong@huawei.com>, Enze Li
	<lienze@kylinos.cn>, =?UTF-8?B?5Lil5p2D5rCR?= <yanquanmin1@huawei.com>
References: <20260129161029.48991-1-sj@kernel.org>
 <d6f2b111-bb42-4437-9711-bf06cf9afefa@huawei.com>
In-Reply-To: <d6f2b111-bb42-4437-9711-bf06cf9afefa@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.149]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam12
X-Stat-Signature: 8h8h33jt1grjgz95xnnno3dq91wpoemz
X-Rspamd-Queue-Id: 450772000F
X-Rspam-User: 
X-HE-Tag: 1769742433-601347
X-HE-Meta: U2FsdGVkX19qKebXX1XJ7Ur5CDo0HIu0qBYDumNbvkSgutQOJhFUGSO9RmC5yyszMq49UBtJGMSzI50SzU/7GOD76ZnyFir7eugaruPs5QgkAOsVYIn/L5eWxfopTz5MAjqCnyeNG0uWu0ZOmoC+h1XWt2Gnn8BLHKSxXOGQfb59hTKRSotUltlxbllzip3YfC5wdz3FP4rcN7bUcgjExqxnvHQQCAzpLrfizqUIsZ8i6M62lHka8kEUXA6DGEyTAknEN6oLPb24bgIbdxLot0qS8EFSYbGmz8BY9IzGORu3NJkOuj2oNbHrYf9qO7b2OFw03kOFPYXiVfd4ixlLL4elyrwZrAG3a9m7DZ1hwVAJjrCyK5sWFnXZj0igCpF0ce7W9pFhYxux8CcNNIa0K4ti04489FvhrMmxLgM9IaMCnukkezJcfPXklCNbKthobDLtrOM9+SycLiK3jjCFAUTmovFfnqJd3cDod/24yMwn/IOTGGMuitNnajHDG/we1P8tn2pwzWUUa269FkOeCJ4vCiFiP+BJotkQEpxv6SHxXfOhz8Exj5+dQrmNEJ+KLYohgPRE4TThK1XyX6RU3VSvANi32+CvN1XQRm+6ymw5smD0c8CviZ/sAusmi01chlgpvpYB9XMddqbKt2FA35B5zqjzl9MCQF74/FpHEWSjLiI/TkrlbyMsOjBzrDYMXgw0j/BirM2pd+cqNbl/szweQWRdZLM89IcohSx2MAXcPmpvk/qsh8BM0SkOYDtErznC/CmWxSY2q5VHPIyqETARkrmgxWAoTWS2yVXbBoRqJkzwh851S4Q3DisT4jZA4w1GGxx4sfBJGJ50Ok26zd+z1A71SOW/3T+YUkTQoiOtOtNZLwNYLkAveerJ9OBRfiFpAD9tMeoGvCjPyTSwd4aeTWPPzWeSDCdD/nf7RPqPDKbI7d40aY7Y4TcMJJAgTQZxdsN+XxqtOjy929u
 wZmRovCG
 FLu42PSjq3jW/notJHQ2lHqYJQw4C0tfKqPldxqQlK+56eiCpWGE1asGoHhkSVctbLIXWt98HXuMcBaHjt19+0aWzNJa7NHEVSeZSWo/YmHI5x/p6lc7wtwRYVzv4seTbRfowqG6R91RKJUHqOZtRozT+CzEt5NqRTFYgH4IzljoWpq5oAiCACo5Aet2UCj6Kj0WauPdLLkdRteE9PsA1HV6E0EWg6MoEJ1gGl5yYSI76fbA9bFPQkxeJn9oejMU6EGzOJugl/6Ti7gWmpq5XxtogRGQAW7he3N97msmqj0UbsBGQLB1uZW18t9MwYq/iCsni9elFBV2aU+K8pfLKOFzyHGpYn70NNIdh8dkC36VbKdQ4I6H3d6d9h9RN+aLsOcEe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/1/30 10:26, Quanmin Yan 写道:
> Hi SJ,
>
> [...]
>
>> Actually, there is another bug that need to be fixed.  Nonetheless, 
>> that's
>> orthogonal to this patch, so it is not a blocker of this patch in my 
>> opinion.
>
> Are you referring to the scenario where, on a 32-bit system with LPAE 
> support, the biggest System RAM address found exceeds the range of 
> unsigned long? Actually, DAMON only actively searches for the biggest 
> System RAM address when the user does not set a monitoring region. In 
> this case, we always reset addr_unit to 1, which essentially restricts 
> DAMON’s monitorable address range to 0–UL. Therefore, the described 
> situation does not occur. For details, please refer to commit [1]. 
> However, we could perhaps further optimize this by finding any biggest 
> System RAM address, setting damon_addr_range, and dynamically 
> adjusting addr_unit. However, there are currently no specific 
> requirements for this, so this work has been temporarily put on hold. 
> [1] commit dfc02531f413 ("mm/damon/reclaim: use min_sz_region for core 
> address alignment when setting regions") Thanks, Quanmin Yan
>
> [...] 

(Sorry there was an issue with my email client. I am resending now.)

Are you referring to the scenario where, on a 32-bit system with LPAE
support, the biggest System RAM address found exceeds the range of
unsigned long?

Actually, DAMON only actively searches for the biggest System RAM
address when the user does not set a monitoring region. In this case,
we always reset addr_unit to 1, which essentially restricts DAMON’s
monitorable address range to 0–UL. Therefore, the described situation
does not occur. For details, please refer to commit [1].

However, we could perhaps further optimize this by finding any biggest
System RAM address, setting damon_addr_range, and dynamically adjusting
addr_unit. However, there are currently no specific requirements for
this, so this work has been temporarily put on hold.

[1] commit dfc02531f413 ("mm/damon/reclaim: use min_sz_region for core
address alignment when setting regions")

Thanks,
Quanmin Yan


