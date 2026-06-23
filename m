Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0F61CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 14:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A31E16B0099; Tue, 23 Jun 2026 10:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A09716B009B; Tue, 23 Jun 2026 10:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91FC06B009D; Tue, 23 Jun 2026 10:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 697116B0099
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:08:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD996404C6
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:08:20 +0000 (UTC)
X-FDA: 84911357160.13.B3EFBE1
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf15.hostedemail.com (Postfix) with ESMTP id A17CAA0016
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:08:10 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782223692;
	b=uaaE1IozUNp2B692q0RK/OVbclw+kPo3wlRujmwcfVu4L3U+x3csHT6M48SDmEK+ype/kB
	YmfM5qyUeFRCVERyMvA/OF7//XY/kMtllKCWncxOY/n0EfpDWjJ31neZxSS0ntaVjvnNzK
	+xbYy/amh96n1D5wrJhywg5VdmLCZK4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782223692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Kjc0ILl0J/jDwE6Rp8VeaX8HsM6FVKzVv2KZZcpLvE=;
	b=qtJhmFsSTVMNDUd/Jcj1D0frpF/5gSxbClZlMOihMP9N0wuGOcCBazonAe50HQdVNBubL8
	z+HgZvazCvai8JdDG6RRHFmymXUCGRi+dAn6YSJceYbpfwgbMvPjZpTMwTmqY43BIVdipp
	4GXy/k4YggJhyIDX3C7rFW4yQczr2Y8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=h-partners.com header.s=dkim header.b=f2mWTIgR;
	dkim=pass header.d=h-partners.com header.s=dkim header.b=f2mWTIgR;
	spf=pass (imf15.hostedemail.com: domain of zengheng4@h-partners.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=zengheng4@h-partners.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=huawei.com (policy=quarantine)
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4Kjc0ILl0J/jDwE6Rp8VeaX8HsM6FVKzVv2KZZcpLvE=;
	b=f2mWTIgRI0OMt+a5DXk7llvGYG+YSSaNqEUOMlOA2s03QZHIYyfSkzRV1Z6b4x+STugLrsIPq
	3m6oP+Rzqb0N2IaFfkxaKjYTPJucaumO6NrvPZ1nl2cSchKOLvsCKiwkRUAFEbcYKgg7VAPrMAf
	PHbGQXpQFpA89e2wK8OSTX0=
Received: from canpmsgout01.his.huawei.com (unknown [172.19.92.178])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gl6BT3pzczcb3n;
	Tue, 23 Jun 2026 21:59:29 +0800 (CST)
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4Kjc0ILl0J/jDwE6Rp8VeaX8HsM6FVKzVv2KZZcpLvE=;
	b=f2mWTIgRI0OMt+a5DXk7llvGYG+YSSaNqEUOMlOA2s03QZHIYyfSkzRV1Z6b4x+STugLrsIPq
	3m6oP+Rzqb0N2IaFfkxaKjYTPJucaumO6NrvPZ1nl2cSchKOLvsCKiwkRUAFEbcYKgg7VAPrMAf
	PHbGQXpQFpA89e2wK8OSTX0=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4gl6BP4B7gz1T4GM;
	Tue, 23 Jun 2026 21:59:25 +0800 (CST)
Received: from kwepemf100008.china.huawei.com (unknown [7.202.181.222])
	by mail.maildlp.com (Postfix) with ESMTPS id 460EE40363;
	Tue, 23 Jun 2026 22:08:05 +0800 (CST)
Received: from [10.174.179.37] (10.174.179.37) by
 kwepemf100008.china.huawei.com (7.202.181.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 23 Jun 2026 22:08:04 +0800
Message-ID: <7d46a48c-8805-09e1-4818-807953898fb4@huawei.com>
Date: Tue, 23 Jun 2026 22:08:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC PATCH 0/6] mm/damon: hardware-sampled access reports
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>, <sj@kernel.org>,
	<akinobu.mita@gmail.com>, <damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
CC: <akpm@linux-foundation.org>, <corbet@lwn.net>, <bijan311@gmail.com>,
	<ajayjoshi@micron.com>, <honggyu.kim@sk.com>, <yunjeong.mun@sk.com>
References: <20260529165640.820-1-ravis.opensrc@gmail.com>
Content-Language: en-US
From: Zeng Heng <zengheng4@huawei.com>
In-Reply-To: <20260529165640.820-1-ravis.opensrc@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.37]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf100008.china.huawei.com (7.202.181.222)
X-Rspam: Yes
X-HE-Tag: 1782223690-374397
X-HE-Meta: U2FsdGVkX1/7sMyDnb3l48ZGlwn1UW4d7uWkrYBy8mKH3tMX9cw528cfzhqDiO83Y0QOZ++0Ajice0iCHSG3DblVZmpFMS/OKyafCeLLP6j864uu5P8Se9f9l8EDejFO9uZFkDnFSbtwExOaU9acoTjRXEjvTyZ7zIjOPObb3sJWXmw7Adwv2owb2850nt80UvLpPvZhIbLBrVLsJwpqLt0XqSk+JB4zRS72CAmL3l3ERemLDxkU8a58rK5KCU/zW0VUCj7VxuWAFJn6xd0FrWIr95SxsR16XGbgtkkoLDP6CH3ZqC+ae8fOI5DAiebRvwn88Wi4iO4ZawDHmlSrYAN0rm/xKw8rcLMQAj7tKcrSgWAiASsqJKORUIT8SryJ+VETFKipG+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ravi,

On 2026/5/30 0:56, Ravi Jonnalagadda wrote:
> This series introduces a vendor and PMU-agnostic substrate inside DAMON
> that consumes hardware-sampled access reports through the standard
> perf-event interface.  Userspace selects the PMU through sysfs (raw
> type/config knobs), driving either Intel PEBS L3-miss sampling or AMD
> IBS Op sampling.
> 

[...]

> 
> Ravi Jonnalagadda (6):
>    mm/damon: add struct damon_perf_event{,_attr} and per-ctx perf_events
>      list
>    mm/damon/sysfs-sample: expose perf_events configuration via sysfs
>    mm/damon/sysfs: install perf_events on apply
>    mm/damon/core: per-CPU SPSC ring drain and damon_perf_event lifecycle
>    mm/damon/vaddr: implement perf-event access check
>    mm/damon: add damos_node_eligible_mem_bp tracepoint
> 
>   include/linux/damon.h        |  80 +++++
>   include/trace/events/damon.h |  49 +++
>   mm/damon/core.c              | 403 ++++++++++++++++++++----
>   mm/damon/ops-common.h        |  39 +++
>   mm/damon/sysfs-common.h      |   6 +
>   mm/damon/sysfs-sample.c      | 579 +++++++++++++++++++++++++++++++++++
>   mm/damon/sysfs.c             |   3 +
>   mm/damon/vaddr.c             | 267 ++++++++++++++++
>   8 files changed, 1370 insertions(+), 56 deletions(-)
> 
> 
> base-commit: 4c8ad15abf15eb480d3ad85f902001e35465ef18

I wasn't able to apply this patch series to the linux (and linux-next)
mainline branch, and also had trouble identifying the source of the base
commit.

Would you mind sharing where this baseline is from?

Thanks in advance!


Best Regards,
Zeng Heng

