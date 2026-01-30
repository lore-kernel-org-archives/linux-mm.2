Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE8D0D73EB2
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 02:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81DF6B0005; Thu, 29 Jan 2026 21:27:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2FDF6B0089; Thu, 29 Jan 2026 21:27:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911496B008A; Thu, 29 Jan 2026 21:27:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 801726B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:27:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CACE6140312
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 02:27:02 +0000 (UTC)
X-FDA: 84387042684.29.52498EB
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf21.hostedemail.com (Postfix) with ESMTP id AFA771C0004
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 02:26:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ut3ycEYo;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769740021; a=rsa-sha256;
	cv=none;
	b=JnZRnw7kplur2/Z+LEDl6IYDj22kZqo6MBAzAzJqpSzukBwOzFAFOo9knAbK67OxniMj0Y
	KaE7m5GIHSl4GBcmpgcwv2lmHdyfag6KbwI5anP/gN1zByoLnnUeXxOGO3VEcF2X0ZfIHy
	CrNEy4zRcK5LqniZGf4RAkTSoThhcpM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ut3ycEYo;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769740021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oX5hyRJHR6Lithb+eoy4CxIJ3KMmionEVlpg+rommN4=;
	b=uqaYRzzcAOZqGIVeICpl8mWAKLoxbB3eQ3RJvi2Y7dw5cgB/zgTmy4A/RB7rEpEUK5uBYT
	6bKcYIy/FKCVVY10ChKYLTHT2PhO0nv5smrhDQIdPmOloa8Ddbkvas4U7vQ/vtFoMcjLHY
	H8JAJUM2T8PKXrxTNRJlCkjykTw9weM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=oX5hyRJHR6Lithb+eoy4CxIJ3KMmionEVlpg+rommN4=;
	b=ut3ycEYoJmVAo6Qx+NQKqYKGkKnkLAnn9jaG7L45bmFmL0lQtBsrZa3YmfldSSmg4SVIAvFG+
	Ej3b6AcXRgYa7/wIRM8KMGksV6LGfVK+znI8jMo6cOqVRiPqegvS5lx2x3vsE1R0fED10ck9hBO
	isssANONAnZ15xqnvweTygo=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4f2KYp5BKSzLlXs;
	Fri, 30 Jan 2026 10:23:26 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 1D2DC4048B;
	Fri, 30 Jan 2026 10:26:55 +0800 (CST)
Received: from [10.174.177.149] (10.174.177.149) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 30 Jan 2026 10:26:54 +0800
Message-ID: <d6f2b111-bb42-4437-9711-bf06cf9afefa@huawei.com>
Date: Fri, 30 Jan 2026 10:26:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon: unify address range representation with
 damon_addr_range
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-mm@kvack.org>, <enze.li@gmx.com>, <sunnanyong@huawei.com>, Enze Li
	<lienze@kylinos.cn>
References: <20260129161029.48991-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20260129161029.48991-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.149]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AFA771C0004
X-Stat-Signature: yp7qt66rknd894pw3m8h6484rz7so97h
X-HE-Tag: 1769740019-206495
X-HE-Meta: U2FsdGVkX19q5vkahng//us8twh220wzSOFwe94tC3GjdXOTzTQnnVWbvu5Q71SUdy8nyGaqUZvtToH5t8taK/OnWZNgiCIkDnjqAkRMEJkDSx/ukKbpFHf0gC37TVt0uizURpDoMLE8naAAdI8TEyvt+ZJumtZqbQGLMLskU9DXn/P9smgzK7qJLPEaUGruDUo/2vI7MZHKDO2NT4oacoKkTbb5lDKoJDzrwkuwdnjZw+USdL3iMYvRDPmc9+MYJ3AiWag1z3CsjoArgtYjAyqLIwcYq5JTrkBYwyhYUrpgvrYFWRcpZJtk3SPt4f3tKQBnomAGsU1Cy623ZOdgOswthPmWnS0uN4J3UmWlCbT0aCj2BWvQ2GFCciFawOMM1cNTpGuW3KMW6KD4+DP5syLbI0oi+W6kD3cT4HG9e5BcJLmEFnRf3v59jWkT7BP3sn4+AhcEOej+DryYsxxTzkF85sqe/j2gKHe+rGbw9mcCVdpzG5ULERQH/Iud415yaXwYgQyV8Xoxxv2APVBfJdFYOWyCgTLFyoh6UohjkhvMVHFIzWrVL9JliUmI7xTW/m1VDKLr6bTuj9ZESmf23kvAk4ygSOPi5zzTj0ckXFqtxS7YWsve/evVcXawq2JxRYggN7wB35fOy8iqV4ExzfJOCHZzkPjcpVIF8Dp101BN92DkjXRtORCZT7hDIK9al3DCF2k6WyeGB5+xe36LGdl2CAZrWs9oz00YeMdNX90ZQFmFlxzwm5ZHyQeKCObs9+ni6t0k+n53vy4Xg++S81Cu1426Cr48GLnVQ/2RHXomNG8QZXRhHdu2D7rraplPJwdzP1Yz5r6BCUEIZF2adsEamkNFe8ebv4d8AMqpVU/CDxFSlBn60mQsvHOgQ2U87L8sN7k0c2Cp2qOrDZZYx/h8pNdHrrrbIE2PygB9/XWCbBract/NkEWcY1SvkTrILpPXw2bxu3v47lxuv1g
 WSrp4BNP
 J3spoxGKRxcdcvWN+G7kVep2/lmLVMkyfCIrrRs+qTUs9kSnV/LN4+cUhoe9fvXGSq64Kqi/K2A3BaD/lnzbcGs8bB5dH7zgArk3Si80USft6QKINp3lHkty9ZRxj9qY+GL/m7ZGl7X069usxY+pVOlH1NNtziThJIQ29S7PeVpyQ108Bsx+BIwWadcXmAsgb8I8ZS4VEFEBhb8JNcpKnsyQAevcyrFPBl69LhTaKWv01M1NGDrOOJEdDtOSTv2U9Jlb9D1YxczZqGvNBXO1CqJ9rG8m5+F94Oh5hzdIGcycnTlIKzoc8IEs/+Y4b/sF2a7EqdUB2Ccy5T5Bhwm1ZDUp5KP4xo/2OIQ9CTqY7BbZk3rh9r3KIr7z6xIxX1p8WTO4C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

[...]

> Actually, there is another bug that need to be fixed.  Nonetheless, that's
> orthogonal to this patch, so it is not a blocker of this patch in my opinion.

Are you referring to the scenario where, on a 32-bit system with LPAE 
support, the biggest System RAM address found exceeds the range of 
unsigned long? Actually, DAMON only actively searches for the biggest 
System RAM address when the user does not set a monitoring region. In 
this case, we always reset addr_unit to 1, which essentially restricts 
DAMON’s monitorable address range to 0–UL. Therefore, the described 
situation does not occur. For details, please refer to commit [1]. 
However, we could perhaps further optimize this by finding any biggest 
System RAM address, setting damon_addr_range, and dynamically adjusting 
addr_unit. However, there are currently no specific requirements for 
this, so this work has been temporarily put on hold. [1] commit 
dfc02531f413 ("mm/damon/reclaim: use min_sz_region for core address 
alignment when setting regions") Thanks, Quanmin Yan

[...]


