Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD49DCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 12:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 510B890015C; Thu, 14 Aug 2025 08:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E90A900023; Thu, 14 Aug 2025 08:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B15690015C; Thu, 14 Aug 2025 08:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21193900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:59:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C2F2E117C3E
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:59:14 +0000 (UTC)
X-FDA: 83775368628.28.83773A5
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf28.hostedemail.com (Postfix) with ESMTP id 86355C000B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:59:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755176353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xpTLa/7NeSqJzzUAwh4Vb1zZiHgd5xmYgd5uo2/vhsk=;
	b=crJSphRqEjx4DP2a60pyqS5M75MkEmahQhrQ646tqxqjGdjbEwoI5B0NlcWs1SrEkGpkPr
	JjJwrMCl+amPptU9nQmKDwVny1+aygIUfFajv6gAj6/ZXf5IbhCGLKWlryYdASSbaeoaFG
	pqvL3YphFNPq0GSRM6Nv33rm4RJqytw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755176353; a=rsa-sha256;
	cv=none;
	b=2WlMXN4zf3elBv+KgJLk5mP3RNhbTy1WBH/r0s6OOJSA7PSeramR2TZn7qI4VikYsAwgG8
	WrUnqzKtMm0vin+U9d2BuzxBBwCF7SwZWJd5R+bwyZeSV3DIaxvvfX7V8BfI/bZml8Nn5x
	DwEr8vWvgnFQ6owtGUy1uQ1gh9sIvL8=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c2lZF5kdDzdcLx;
	Thu, 14 Aug 2025 20:54:45 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 2E7B0180B62;
	Thu, 14 Aug 2025 20:59:06 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 14 Aug 2025 20:59:05 +0800
Message-ID: <39e07350-2510-49fe-ae4a-e5d10b69291c@huawei.com>
Date: Thu, 14 Aug 2025 20:59:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH -next 11/16] mm/damon: add addr_unit for DAMON_RECLAIM
 and LRU_SORT
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
References: <20250813163656.5611-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250813163656.5611-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: khjwx3wztjnko7fsmk9krnfa3mk6t7rx
X-Rspam-User: 
X-Rspamd-Queue-Id: 86355C000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1755176352-363267
X-HE-Meta: U2FsdGVkX1/jJYzQL/vI37zwVS1sNFvvPneFQU+Aia8vykwfYHE1MaGfCd1RkBWaxY+ZnvFkmwJGbflXMjDu4QxjTrNrvJImDwzIn5e5/vkOh78xMJsLP7V1BWHuCUAj80tsK4OkB9p5qMEDrPf+DGL8ky8yEWWzsuAZ1ld+VvqzURxGaX1UhUSzTglMWVnGbolHnfSZvXuRs3czJ5hDp7+5bpgSvYRIvFj0O5OwsS9GY1smRG2vRT+IcKafO/qPRGWzseiEFMlmzFikqOmU54XCQl4/HFHqb+qWEAZGcejZFoqQZkLtpXx6wv3Mpz44drmaaYUDwtJ1J13XXqhF08cJPknmDsvHemJhcGedi2CImf+lN+817Z0r3WZk6uK9lcMfsVcDwKx9DeAxXr5pE285U+zE3TWV8UZ13+ynU7/fP3gj8AHLF/uNuhKaVMdCld1pJLDUcIGUt0EgtiYy1GjVix5uvor/205JGbf3V26PKhk8BqwjPeF5X7/P1mI87jwN3/Ax/9+OF3htnMAG7AuoBPmF7jo/Zyv/c7yyS1ezy6BUclQ6yG20eEPziYTnICIls+lRJdavx4EyXuAsXYB8+GE+0Z3T+bOL8zPF4KNiqoBnRA1AyuQVRuVeDyB8ZOKtSkj9FJ3cwHl1mvHpMyHxHMA/xZEGjb8G1FZ98cHYdIv1PYLSiTQzVPWdOxGPTr9oKwWH6Sum5zFvuTTw1Sd7aU6sBm/35TF4fcHZZBixQ1i0iRpPtssaR7ycpX5HaLj8sS/jcwyYsPHDrhZ2rB4GLo4Vzyf9gbvvhS4jKtewQL3mN5RpVY2o9YJVDrdy0GuNoxyQ8GLyXZGSkaGYg4UpxFNXyM8p6NnZBTU3d0iTi1gchrMExjTfbtOF/ynbDOPPutAEpK2CIGuxUMgm52u6ueqYbcquLzQAN2LMo8Il0HD663tSK4DSZ3UQBXWMIXnkEB+/tGQEiI93504
 DD9h6e9B
 HTs3VdO85Ow5rnOT7WfPqD7kczjKITGYa1xUtq3loVvnZv6F3EFICg5YefBPUYfm2shFJ4Fjj6C94raDw4ih8cXEn8FufZvRVupZpSHkhXxEI7SONQNIJQNbGt8rVAlN7JEs6dKndg0nEceESQ+yDpfu9eodWwxDFL+Z9Yy93YtvPvhmtO5R7JTcbN0xQDQCEl2nSadAlELvyZa2C76rVbWqLJ0PxrNMtuup0cIA61yzGM+UQzY6usquEs5YhJWXFWmNqvE5hpSTWP6oUgiDpHXzjPm1U42o3jCagc14krYRrgbIUjhZ14jMVrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/8/14 0:36, SeongJae Park 写道:
> On Wed, 13 Aug 2025 13:07:01 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>
>> In module DAMON_RECLAIM and DAMON_LRU_SORT, the damon_ctx is
>> independent of the core, necessitating dedicated addr_unit
>> integration for these features.
>> Additionally, if the input monitor_region_start and monitor_region_end
>> are both 0 while addr_unit is set to a non-zero valuethe default
>> system RAM range should be divided by addr_unit.
> Do you plan to, and need to use DAMON_RECLAIM and DAMON_LRU_SORT on LPAE-ARM32
> environments?  Can't you use DAMON sysfs interface instead?  If need to use the
> modules, this change looks good to me in high level.  But if not, I'd like to
> skip this change, and wait until someone requests it.
>
> I'll review the code change in depth after the above question is answered.
>
Hi SJ,

Yes, we need to use these modules in an LPAE-ARM32 environment. The modular
approach often provides more flexibility in our workflow, so we would greatly
appreciate it if you could take some time to review the code!🙂

Thanks,
Quanmin Yan

>
> Thanks,
> SJ
>
> [...]
>

