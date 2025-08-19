Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0366CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 14:59:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83D848E0039; Tue, 19 Aug 2025 10:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C72A8E0007; Tue, 19 Aug 2025 10:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68EE38E0039; Tue, 19 Aug 2025 10:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 532518E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:59:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02C381A073D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:59:10 +0000 (UTC)
X-FDA: 83793814902.02.E9BAB5A
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf30.hostedemail.com (Postfix) with ESMTP id 05B7180011
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:59:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755615549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wf7a7DJgirtMHJJHt17nLHZba6IiyVWZtSHPFJcwStY=;
	b=GEL6wcbn7OWGmqzj4xJY18BnxaqO8VOlZp1KP5393dynUj9+JC8BzOYYd1LOFeFi1FOac+
	stnPvUDqV/kVpOo8Ud6cEgNnx+8sJzplgsOnMbUnoG9jMruqxYdG/e13uFF/LkaSWEBcib
	Sq1WPuITilzPaXL9Q7eqW3z4IRuo5BE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755615549; a=rsa-sha256;
	cv=none;
	b=S9EizzRyzBtjE4hoXo1ChOD89xywqu7pdw6glwDRvIo36lwZVrKYk9Uy5av2oua5/Gs1yC
	aGXsSDi9uXOZouAnfVxtPzAzb0KIiu8l0tfAOKtylza+CqXHUqizFsX/lyzA9wtSqfbB4n
	YtkMwnRHacphqoT3KiJje4SiHt0n2FI=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c5t1F5lW5z13NB8;
	Tue, 19 Aug 2025 22:55:29 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 158C61402E9;
	Tue, 19 Aug 2025 22:59:02 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 19 Aug 2025 22:59:01 +0800
Message-ID: <f609350c-2cfe-4cbe-98ad-a154a858fe4d@huawei.com>
Date: Tue, 19 Aug 2025 22:59:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH -next 11/16] mm/damon: add addr_unit for DAMON_RECLAIM
 and LRU_SORT
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
References: <20250814161125.67602-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250814161125.67602-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 05B7180011
X-Stat-Signature: gc6ctkj1fg3dwmn5cfb61dzzbk4jd7of
X-Rspam-User: 
X-HE-Tag: 1755615545-426395
X-HE-Meta: U2FsdGVkX19SBZC1rljcp+I6V2P/OIp9vPkIozq2fDyHEN8qDpkwpCIr78g/T4YLn0VFvVYysfVOUC+FETBt2riMe0uTmLulkdwQur7YhtoKmnQ/Ee9TdQt1QKBR1g5wYRbART2zQV5kLBreoJrQF7oabEyCgBF7UHdjBrpdnsVsKNvsU2+57icvmCcx4lHFmNU0l2vpoAXnSWhyagbnTxZw0uamqnaYsL1YLZgXBADY9Nw9eFIHmXpg6aik7kZ+n7+JtpHVQHQ6+myXIzPvlL7NSakdU1539hNOxu5zahFV+7NmnITFmwzDvvaMCNOPKxureJgnKMD8x+JUPLEmND1CujaYAVOZXWllts4NcRTFnMFa4yOAmxNAO5aYJ8B7YstfahOwYpY0ooHwKGnUNIvy184HBwh44yd7wg9KwxpRs9PUfKLot90y8UyFc7o4OuTOZ1FKWjwFlLhTo1DxTIDAWHkR/5dfU6sXB+dDr0vGlyGKT7WCe3w5WhpbBPawZQoeo05TbVMv/GxJGKrGmixsrHFjLmrhMiqdUOUcs4ThcDe05RpwrcmeKkiQrqG1fembl4XruATNxes5k7/SdiJeOuv2Z3pjh9zlldb4r7Xp+mCbpDV+Z4y0aowoQAgS+QXfW2OWBOIPt+jeicKqGKPBUbhZxYWIDdNwT888A+TZxtKGmZsGgpnvMDQt3XSPFsBKGnSSbAxfO/sO5SoO6fhbbBSrayZuKqsLlmd37VdADFf284wdsxMxIy42MPqpIKINKXGJcizJnLDx47ucezmfmJ2c5vnbfNaP6qaxDDIOWHHqnKoGPxI2CooAhOU9TjBmaK4jYV9+GQseJXHJ8gc3YAwkc+IJMmx8GV4uVPSARxeoJ5hRcqm4H5gOwhPHoWDOkGsSlv33y6aJP/Apyxt7+SC2jEaJ2dlL8Cm2Jj8mSl+UytxePQrYhgGq7t0vhtwRER55ZkCEWrTFDcy
 8RtPJb+w
 fOeW3Fe+d38dgqOGKQvuGW0Ux97jKqzqT5YPHlBnal7qyIR5HLW1aGenbJHfwUXLbYLrlJ9QRNnWz1+1J16Sy9BV2dr6erQpDPribhZ/oZYE24zHE1MwS2VFXj0Rw92HTrhXY5OWEPjlO6vz1baMRiv9rUD3/cE6D4uaL8CBxGnKvLBUy0QPObNqps6X8a/LGds1mu1KklxF1/l1CTqJEHlX09LcDr+K34ciWAhzpEWL8MLT/bOwuoaRzGP+0WYks28/EVrjPx9uu4/tlJXDzTHpWNaNMDORdlbr8tpOTrgq6LCFkkDFytkht8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

在 2025/8/15 0:11, SeongJae Park 写道:
> On Thu, 14 Aug 2025 20:59:04 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>
>> 在 2025/8/14 0:36, SeongJae Park 写道:
>>> On Wed, 13 Aug 2025 13:07:01 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>>>
>>>> In module DAMON_RECLAIM and DAMON_LRU_SORT, the damon_ctx is
>>>> independent of the core, necessitating dedicated addr_unit
>>>> integration for these features.
>>>> Additionally, if the input monitor_region_start and monitor_region_end
>>>> are both 0 while addr_unit is set to a non-zero valuethe default
>>>> system RAM range should be divided by addr_unit.
>>> Do you plan to, and need to use DAMON_RECLAIM and DAMON_LRU_SORT on LPAE-ARM32
>>> environments?  Can't you use DAMON sysfs interface instead?  If need to use the
>>> modules, this change looks good to me in high level.  But if not, I'd like to
>>> skip this change, and wait until someone requests it.
>>>
>>> I'll review the code change in depth after the above question is answered.
>>>
>> Hi SJ,
>>
>> Yes, we need to use these modules in an LPAE-ARM32 environment. The modular
>> approach often provides more flexibility in our workflow, so we would greatly
>> appreciate it if you could take some time to review the code!🙂
> Thank you for clarifying.  Ok, I understand this change is really required.
>
> However, I think reviewing and revising this part may take time.  Meanwhile,
> seems this part is not an essential one of this patch series, and has no
> problem at be separated and merged after the essential parts.
>
> So, could we separate this part from this patch series?  That is, let's work on
> the essential part first.  After the work on the essential part is done, you
> could post this part as another patch series, and then we can work together
> again on it.

You are right, let's focus on the essential part first.

Thanks,
Quanmin Yan

>
> Thanks,
> SJ
>
> [...]

