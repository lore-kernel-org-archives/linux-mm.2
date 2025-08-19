Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25584CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 14:46:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2F86B00A5; Tue, 19 Aug 2025 10:46:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B536B6B00A6; Tue, 19 Aug 2025 10:46:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69076B00A7; Tue, 19 Aug 2025 10:46:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95B836B00A5
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:46:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 88E0783ECD
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:46:11 +0000 (UTC)
X-FDA: 83793782142.30.88BB9ED
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf11.hostedemail.com (Postfix) with ESMTP id 69C5640010
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:46:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755614769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4cNaQ0fBoqXOclbVMfjs7KIIF3KZCWAaPaFJoz0S3LQ=;
	b=m5J8RTjEj8zGZGjfBKK4OMJMlqr1Lc+/DdnF1F5v+4/47Vc8V3rTPKjmWFa9XV156cg2VR
	YvHk4A8SzfCzv36cAfR6vsCOxCB8KeUHhH8aM5lAG5TE84nbnnnAE7AYP/1azFc9JH+AaP
	8yzOjvaGUuRNX/1jnI8TAD64QT3WHyw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755614769; a=rsa-sha256;
	cv=none;
	b=ZIQwymgXECL/9ZXZS6KjGuslGEVc/1I+bV4QZg5o71/qmdKzeKk3qU7S3CuaEotx4nFnJL
	Z74Dm6YBbwLW2ghqIa4Ya0PqiTW+XEZJqtNVkp0WYvhXPzk/gSXEEnSE7TkI7bjRlf6JRm
	+1ZTQvz8kqA+sWYefms5ymYsc4yGcOc=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c5sjF42PpzdcS1;
	Tue, 19 Aug 2025 22:41:37 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 396D218007F;
	Tue, 19 Aug 2025 22:46:00 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 19 Aug 2025 22:45:59 +0800
Message-ID: <c3050ee1-a3f6-4f3f-8cd3-a5d67dcdcacc@huawei.com>
Date: Tue, 19 Aug 2025 22:45:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH -next 07/16] mm/damon/sysfs: implement addr_unit file
 under context dir
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
References: <20250819062452.39889-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250819062452.39889-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 69C5640010
X-Stat-Signature: s6che1549dko4kd8ey4xiexm114dhm7r
X-Rspam-User: 
X-HE-Tag: 1755614768-591784
X-HE-Meta: U2FsdGVkX1/2TdJQZOMbLy1VarKKIKhjyZb0vKpULyw46joxfg76DkwRyIJDQFP50pXIHJfKVqKdrDDo7beOhC3d1ea95709WnLPEA4VS2uPRGqi5WCHyn8u797PBNC0sKbkBrAMz+8lBKCgOXe+cFIfUVloEghjzbuAlbj/yqll4d6YwOURjOqG57UlUbKg2Tk4muo6FJZdpPSYxiz8pzBygb5CYdGaRyWrAtd1zcpZ2hXqG2Q3veTdJAeLsR2qMzKgzNzC/2pgz6U39FW/sDW+82CRYvG7YWaCFvOqTZAKC3o6GeA1XATS3Oh5T53Li2PkY5zEY/KGQNE5dfyHk8An80t63aGpmvFnn7qOlXKRD0Xd5I+E2iioZa0/BcJAUx44QfUZ/gO02JMo9p8r5Mzp26EzS3rP0ziSB2Y/lq8ff7b1Gb9NUcm0+B2RYhmcwmmBpWX+Ni5UaAsSOD2YvhPDH/nXAlTpXkw6FV+Wj2BsyHDGHN+cxWexZSZS+Ari/NOVq/tQoC55BzyUxaAICPrrl1zK06FLwDFH5M09QQbTYIag5mB8J5s9xeaMjs5SocNdZiHGU8Ngx56XFN7oLEDFN5ifHGSYHj0dG+SGnk7UqPmQft+l0yKmDuFx48ZKnqnPwPvHw3TtmVrdhoPx+GQZRy0c3oSMs6dLXdzeMaIS2nybBaoZQae314OcZv3tM50M+XnUHXkvTXwblN7swjZzTBBHf5AsSoWDkpeB4t3O5pm3+iBV1OCp6y7cxiwH4AzY76qFIe+zYr62cLXkYC/2dJGZ81Tc1cr5jroIHykhkdK/vF8lzuh7+BCLFvfppbVBLFRU0oxZOb7Br7x1Kd39psgeI1RK3XL7U9OaUGhE9wQMvvzEP+Xf3qIMLsFHQqms4xt6VxPOzoSxwSB+7uszg2w6TGH+J7OisErg3g0J2RAAo7pIf6eDu3ww4LqCf5GRPU2weFeZSf7h8UR
 OFcq6Kts
 kDxsgY13HU6HDzMuAXQF+6ZVyEI+LalZwFWMORvc8kKAdvrxu3LDT/uQB2RohC5/UMx00K5i4QhU0lfmRM1usiJzyNzjEGRuFM8PCjf5l/+q+4BykTimW9x73ZITggDU1a9dQQU9Y28ENt47uc8Y7kpPPsp73BK4YCKXeO1LbBrs01miXmF7IhH7nFpgKcLp8q/wUXuRU7urYDs5lRVDgXuXoV/8hu77vHE05XbJBR4cwxp9f/sv73Wpq9/Mr9TwRZfDgn0lnMCv77hPOqSBlzV8Hdy6n5mX3Jy4mRgoKHaFn1aGyxIy1qpceJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

在 2025/8/19 14:24, SeongJae Park 写道:
> Hi Quanmin,
>
> As I suggested on another reply[1], please squash attaching patch to this one
> when you post next version of this series.
>
> [1] https://lore.kernel.org/20250813170224.6128-1-sj@kernel.org
>
> [...]
>
>
> Thanks,
> SJ
>
> ==== Attachment 0 (0001-mm-damon-sysfs-return-EINVAL-for-zero-addr_unit.patch) ====
>  From e0a5aa5e571ecd0f58b0914f8fc8562a60014ae8 Mon Sep 17 00:00:00 2001
> From: SeongJae Park <sj@kernel.org>
> Date: Wed, 13 Aug 2025 21:17:03 -0700
> Subject: [PATCH] mm/damon/sysfs: return -EINVAL for zero addr_unit
>
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>   mm/damon/sysfs.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index bea782b0a711..eb4269383bae 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -1422,6 +1422,8 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
>   	err = damon_select_ops(ctx, sys_ctx->ops_id);
>   	if (err)
>   		return err;
> +	if (!sys_ctx->addr_unit)
> +		return -EINVAL;
>   	ctx->addr_unit = sys_ctx->addr_unit;
>   	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
>   	if (err)

Aha, returning -EINVAL when sys_ctx->addr_unit is 0 makes sense, but I wonder if it
might be better to prevent users from inputting 0 at the source instead? I've attempted
to modify patch 7 by adding a check in addr_unit_store. I'll send out the v2 version
of patch 7 later (PS: I am performing a comprehensive validation of the v2 patch series),
and we can discuss it then.

Thanks,
Quanmin Yan


