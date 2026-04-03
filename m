Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C86DE7E34C
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 08:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17A0C6B0005; Fri,  3 Apr 2026 04:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12C3E6B0089; Fri,  3 Apr 2026 04:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 041B16B008A; Fri,  3 Apr 2026 04:59:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E3AD26B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 04:59:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A9EF1403BF
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 08:59:47 +0000 (UTC)
X-FDA: 84616646814.16.D33E0B2
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf05.hostedemail.com (Postfix) with ESMTP id B80DB100009
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 08:59:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=gkoM6sjn;
	spf=pass (imf05.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=gkoM6sjn;
	spf=pass (imf05.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775206785; a=rsa-sha256;
	cv=none;
	b=dKjZhF+eAGFAfOqFu0kT8encqj7ek8eEfDeNSr6c1bcO4w76B1d++BmPCCdyVudcLDPJER
	CV4EpUdHTeWV0Ie79WpgUJimxfYLENnfBJHux+aFoe/4ia5ncuwajeB+XyeJmLs4qI2ufV
	xyxF0LmtxLogArIXeMNXTnb6eugZ2SE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775206785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NQfGHQLvAEoUXucN/ii2mm0KWEqbxxSVip1UKyTR+SI=;
	b=67TPyvqxw6kBRm9/7iGNB2zZLeWlcjk2yPo3QEQ+5dCtKKQcJcxGDiJGIRAz/6PJFEQoX1
	F+bfD4rAb6pddaHpoaSNoOhLdnxXQz4obiHhYxSav93muWq0gypRpCyuGInmBvuK9J4X6T
	DhkHSzZ2EDh4ON7m5JRxqHq0tySztLk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NQfGHQLvAEoUXucN/ii2mm0KWEqbxxSVip1UKyTR+SI=;
	b=gkoM6sjnROvHyr6iX+GmH1fTXFMqbyz6dLvNinKPz/WP0EPyGk7FUeo+MISSDGFVhwYJfQnoE
	OrrbuGAiDq3xxJLA2+c46KVXblBXJgIMiGECIMZVGEt708wE3jZtoizpieDOTy7aMuAcxfHXY92
	lGgFED+YO1oKTLqr9KBsBNo=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4fnCDq2DpDzcb0v;
	Fri,  3 Apr 2026 16:53:31 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 83F8740561;
	Fri,  3 Apr 2026 16:59:39 +0800 (CST)
Received: from [10.174.176.156] (10.174.176.156) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 3 Apr 2026 16:59:38 +0800
Message-ID: <8a902208-675d-4564-bb31-fdefcaebb752@huawei.com>
Date: Fri, 3 Apr 2026 16:59:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/damon/lru_sort: validate min_region_size to be
 power of 2
To: Liew Rui Yan <aethernet65535@gmail.com>
CC: <damon@lists.linux.dev>, <linux-mm@kvack.org>, <stable@vger.kernel.org>,
	<sj@kernel.org>
References: <20260403052837.58063-1-aethernet65535@gmail.com>
 <20260403052837.58063-2-aethernet65535@gmail.com>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20260403052837.58063-2-aethernet65535@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.156]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B80DB100009
X-Stat-Signature: 5i4f9fwj8uybitdhnyaamwh8mid5ar5b
X-Rspam-User: 
X-HE-Tag: 1775206784-211853
X-HE-Meta: U2FsdGVkX19fGHG9aoqOfK1grHoLV8WkuP+ZMdXqo5P5VJ5sAWAwHxhgY724gRsetQ+51LegdJLPGUvfo1dvSlLR5GeRHg+oyDcqw5hCk5/1SSHA/9gfsRwC/apYFDkczPpHl3dJrOSANBcVxVUINLVbW9oGq2QAscOsYflvI/AhdCqjEYyo9PMCkhCrmXyynJCrffQpYWjAHZYqBx1vjlKYnONFMjfb/Ogy1pOKSoc8CxRAv4XtSMh0bJkqnoz4Yo6NEBRiERzjHUPcxEJZtKKNvR1a6x17CCcxxRB3FNTq0SkPFMQ8f2bQkUyJEGMwLUqLztNtKVThhzsehjQWvWcJonSYz2oy74QnVsoyeAEn4vP4DTID60wWlKTKwHE5hw/6Qt81b3VTZm45SKC9jmDjw8TbWgI2cplIS+8+gI+IF25X3bDVkAqPXkJzQHOSAoBmgrEiW0HU4C0GEKEm66C1CPtcod7W0t2gzwTgQxL0Vk7n1bfG9Sz+aGW2VPhuEt78JTR4uyi3mle57w8WuIJCskNon5KwMWEdSFARIfOEqPLkUceA/r6vMpDS+rUSJRBPKDUQ2+/3eZ59bqUkwbxqqSgEqIEWE+kumzsnPm9jvZJnep/Gpx94TNEDA3vxwro53mkfkIJXA8cSXJ5QaRGEaX3GtFkNB5XzHOFTxQallfrgenHhcqJhF864rFmkLawH8WMOXw4MmrFL8TPjUJsh/i6W0gYS+qS6KcfrEaOcjQcVZl3MET67sSeGHb8xMk3MaN52GOuq51DwgUsZfd/PldX2h4BJRswgEsR8ue10DWesjM3iB2ZT3yd++RTfjHmhqq6gUZx3rK08GMxbPraIO3wc7wjPGqDNQe1XwPEDbFUGbVyCkv+HGjPWFjldpoaReYCT/eaCZ9uxz3rN2lmnEEaAr02v4+CLLxidvXPJ76Nu/4InzX4PQcnI+lnvcODNxLMgg0LDiva4IjG
 Ub2Be2uP
 KlixZ/rmkNhyOFfWQAZIcTB0lZ/54tJ2B8GxWdHx+ppkdrCj56u5yyjo9SOy5+rCN44unwzG17WJClzb7yzQW+RgJIlwEdfxbEwEddVBRv0oPeJyNI7o5yuyBDiC37LuxKwSFsTA9q4XQn6x+XDlzHn/Pl3zpJ+iQKSiNqCvvgujhVQI6kwRbuQ/Ue1AXurrbRKXEFtVeSh3ao/IdVwCnEGayw/T0UIb5Ccz6Rm1IW13tybLTSu4drHJTUWY5lFnJR2iU/yHfJJ68HogMbPVLxaBsb/2VPK1oWS58Px64+yhm6pi4qTZd8ya1YkH6QlBS/F4J9+ExcrGa+cD7hbpasEmGtx0KaSqEJ5xiziCmaV+oZBldQldc2PZQ7qgEVqg6gqCWpfQ3yPcB9jtGJdFC4gBx8OHpuVI21Ej/kyelOknHbFgHLX/hFACIDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liew,

在 2026/4/3 13:23, Liew Rui Yan 写道:
> The damon_commit_ctx() checks if 'min_region_sz' is a power-of-2.
> However, if an invalid input is provided via the DAMON_LRU_SORT
> interface, the validation failure occurs too late, causing kdamond to
> terminate unexpectedly.

I'm a little confused, what does "causing kdamond to terminate
unexpectedly" mean? The damon_lru_sort_apply_parameters function will
eventually call damon_commit_ctx, and the power-of-2 check is always
performed. Is the early check here to prevent some more broken case
or am I missing something?


Thanks,
Quanmin Yan

> To reproduce:
> 1. Enable DAMON_LRU_SORT.
> 2. Set an invalid 'addr_unit' (e.g., addr_unit=3) so that
>     'min_region_sz = DAMON_MIN_REGION_SZ / addr_unit' becomes
>     non-power-of-2.
> 3. Commit parameters, and observe kdamond termination.
>
> This patch adds an early check in damon_lru_sort_apply_parameters() to
> validate 'min_region_sz' and return -EINVAL immediately if it is not
> a power-of-2, preventing unexpected kdamond termination.
>
> Fixes: 2e0fe9245d6b ("mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT")
> Cc: <stable@vger.kernel.org> # 6.18.x
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> ---
>   mm/damon/lru_sort.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index 554559d72976..3fd176ef9d9c 100644
> --- a/mm/damon/lru_sort.c
> +++ b/mm/damon/lru_sort.c
> @@ -294,6 +294,11 @@ static int damon_lru_sort_apply_parameters(void)
>   	param_ctx->addr_unit = addr_unit;
>   	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
>   
> +	if (!is_power_of_2(param_ctx->min_region_sz)) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
>   	if (!damon_lru_sort_mon_attrs.sample_interval) {
>   		err = -EINVAL;
>   		goto out;

