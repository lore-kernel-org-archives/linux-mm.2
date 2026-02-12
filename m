Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B21BBECD6FE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 01:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C690A6B0005; Wed, 11 Feb 2026 20:19:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16CA6B0089; Wed, 11 Feb 2026 20:19:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B22946B008A; Wed, 11 Feb 2026 20:19:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9FA9E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:19:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F42713B603
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:19:06 +0000 (UTC)
X-FDA: 84434045892.18.764AC85
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf16.hostedemail.com (Postfix) with ESMTP id 09EDD18000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:19:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="XXMDf+/y";
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770859144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IANkVLxJq7lH+TLeyGbC0FUJVX2z6v+14F3M3zDhSss=;
	b=NPl//8nE9VrAP6Dg8K+v285k00jp6PRn3OW58f3Rg34egWzuW+qlvmwfuJPcO/CSQq81yS
	AcGgZQQMcCstvp4AnJhMTshpY24dYz324/HGwOORQXaptCj71CeoVDtAKXLr55h9ywhhRo
	hYi/0P2xWcbKDxze2MFOyPg1zcjjqug=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="XXMDf+/y";
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770859144; a=rsa-sha256;
	cv=none;
	b=W9UGLPMqqGSRMJ7siNFeq8KM8DNE6m+OdYjL9ej2ETy2UU66hZ01IQHsyE4hwOcPCS6By9
	U+iH4KW8VTRyBLEFV3PVuVP/ZVruMNptQQtx5zJlDIzM4kwbSqvsxP1ocQL4KmkqfHzLFx
	kwv6tjmDw9lt0TTuDTx8Gxf/WqF/v/Q=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IANkVLxJq7lH+TLeyGbC0FUJVX2z6v+14F3M3zDhSss=;
	b=XXMDf+/yMPSuUxdF6WJwU7Wu9QyXLhi+wBsA9F4alN6EFM2zLPcKbkNl6bFrvyEC7FJ+fcOtu
	z23HX7Q53vOEbCiKybQ9//31FDh2fTYeU5XqNTmjhYxCB71V2d0MjNqDUGue41Xq16ToNPoCQko
	Ns9J67q/6cj0c3YUufv8Wsk=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4fBHQ53bp7zcb0H;
	Thu, 12 Feb 2026 09:14:21 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 0534D4056B;
	Thu, 12 Feb 2026 09:18:58 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 12 Feb 2026 09:18:57 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 12 Feb 2026 09:18:56 +0800
Subject: Re: [PATCH] selftests/mm: Remove duplicate include of unistd.h
To: Chen Ni <nichen@iscas.ac.cn>
CC: <nao.horiguchi@gmail.com>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
	<shuah@kernel.org>
References: <20260211064311.2981726-1-nichen@iscas.ac.cn>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <adba2471-81ff-6978-598a-a436c4af88da@huawei.com>
Date: Thu, 12 Feb 2026 09:18:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260211064311.2981726-1-nichen@iscas.ac.cn>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam11
X-Stat-Signature: 8uc915e8b3fi9f3pnuhii7bwupjf7fqf
X-Rspam-User: 
X-Rspamd-Queue-Id: 09EDD18000D
X-HE-Tag: 1770859142-795645
X-HE-Meta: U2FsdGVkX18NkYLk1cFXpTxGBYQlQmkR7wpxAYl2Q9hy5h2DQ5b6/lM4OI8kSuN9SdnCYcjr+d2L4sPQtXZ6FrIR9fm+xTWd+h2K704ezE5gr3nPsR2opNBKow6AAFk1jd3kZ4sJ+1UBwMQXY6i75XEyDCXwrwvlApC0sp+IYHmHK00YnJm1T3F6//pvV7SJFs7z+E+9RJXutVCSc5qXDvcoh0DrawYwicDDiJp7FAxF2JN9bS3SCpI3jEaSc/lt8WBDZ/8NofGkdUabqqWAGqgrPjTm+P44sBH0eifM//SRYm1u6hlLSJCk7nQ7YrQf7uhn5+YO+dd6MvCx3V+oZJWJXOJoPXfLO3JgrXMBAGiDYfZMEpquVVewHKslPO8WfV4BbhPWLwMkGQwnzwPMw6jGeCOQyn5Rnrr+Mz1u039fYAO4sUMSKNLAQi2AUZ4xelNJJgCZRrdmAhvzVefRurcbNGORfgeehtZ4CWEqL7a4XsgXLUVZVEakCYvRqL1CTA/hDmErXqCg/vRMiABDcxV2UjFbAMkRTwYEVEcKVspAups2T6qxtxOhz8NAECxHIfM1Sin9xQG3c0XCaS7OWG8A6Xhb8l0EfWa5OE/6J6zpPBMrNGuByk7CCJ9eK9OjBRTWFAlNd/CqaiJbcoXDIYnf0xfgNMFL/ffDNumEoSlP51BfmdMR/GTc+r2tlzeXxlIai+5sItAy0H5MD3He/kgMST9o1yuuXX2l0PP9M11UjGBTN2r0BNKEPtJfRF64EhZvvZoTmeXA9GgYt+9wj8MqWztnODxOWodG/o4dqLrSzFLi8ktlOP1K8aATmGX7nilY69VO6rGySd0LNF2bHK7yhuiliE4DSo4M6WGCFWzWU4ntx1sRXm+hAeY093UHqF4/sz1nMsAkuLpoHoB6TMizV+NhlkvxYqCFu+eMzpDF/VNza1uBNL6jYk5aNgaA86lElF43uzfkECY9iJh
 Cbe8deH8
 f/yi2b9qSU/8rpVKjKHvRP3fbA28BKTZTn/U8aVpD18+Zu19g3PdMGBiNbArE2iYL/RMeDD6wWKy6VsR/pkebt/aQJ+ZvnynCqHVESb963/8ye3IenVbmXV8z7NFeEVhpEKXP4LTUOO70OgFhm/lQ1JOBGD0dUiYPgJprmtoypAoP4ZNzBqFrEq3N7aLxXhzNJJwosiL+gZ9jHhqPONaE2KteyHarqKpqt1ylOdpBq3RnyNQWYRJ1tmE6XHKus//TiRnbdnvNep9NhlLcq5/LIOLVF+IyPpZ3TQ/HStjvr7dggY945JOXvLUkh3x+E101ZtU9CIM4cBGGy0VwOkoayULdatiI356pgrXpX5I5HVd1mQQPiIGnCn0F7bpswfJAWQULD8OZSSHlGU3gfT+9HgKIFdvVFn2iiI+b69Ne18SJiYKLvuh1sKTqmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/2/11 14:43, Chen Ni wrote:
> Remove duplicate inclusion of unistd.h in memory-failure.c to clean up
> redundant code.
> 
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>

Oh, I missed that. Thanks.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

