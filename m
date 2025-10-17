Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C25E4CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 03:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28A958E0033; Thu, 16 Oct 2025 23:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262448E0002; Thu, 16 Oct 2025 23:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F708E0033; Thu, 16 Oct 2025 23:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0885F8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 23:12:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7DB34119D62
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 03:12:10 +0000 (UTC)
X-FDA: 84006132420.01.906D1B4
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0129620008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 03:12:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=gMJT8zxU;
	spf=pass (imf03.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760670728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcvrMD3sQma3OYREUgSzhCQmw7Fa8hfqaZyefSFbX3o=;
	b=8kW40Gqy2SpAxN+3z3iuTieyOyn89bOKOEiVMFO/6xFJaw09I+2VuTKKTxMC9EF5f2JZwe
	5ilw1j/s71pOq8buf0XqAs8st64uFFod743QOKAreZhtdJwjI6cB5h41hzXqOpcJpE9ASP
	OZ9Abn9AS4HP0b3ZnbwHMN5gaCLA+a4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=gMJT8zxU;
	spf=pass (imf03.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760670728; a=rsa-sha256;
	cv=none;
	b=HifwlBsPaU/6TkQXDPoyVQVa6aNlmNcz5Y/0zo2vptm5dxsmMgFyh6BhIFeANwXpXrJeIp
	iavy2vZDTUN/wGgnPZg16CiJcf/52XyVrkmSGZ5AihKdeCxUJKzy/dgemrgYZ9s7DBs/WM
	K43AlOhuvIV0MCOMaU4ZSHk5UZku4g8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=dcvrMD3sQma3OYREUgSzhCQmw7Fa8hfqaZyefSFbX3o=;
	b=gMJT8zxUzHGc/AelXSc6QEx7C+SjQ4cXio4lyn84xfFtq0ygyFg6Vm25uv25TuTNI8JNi67O1
	G6SZ70HTCQGbA5j/tybwGp1RgWoUiw348EQUaNdU0/ZNAQHVBYXXY6DXINVYbN1XNdxXslHzn8J
	wl/G7VC4fmIpKFA7FGV2WWE=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4cnqbw6LWqz1cyVm;
	Fri, 17 Oct 2025 11:11:40 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 3A9C7140294;
	Fri, 17 Oct 2025 11:12:02 +0800 (CST)
Received: from [10.174.177.149] (10.174.177.149) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 17 Oct 2025 11:12:01 +0800
Message-ID: <4c2e5879-e554-49c0-8f05-094031cbb64a@huawei.com>
Date: Fri, 17 Oct 2025 11:12:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon: add a min_sz_region parameter to
 damon_set_region_biggest_system_ram_default()
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
References: <20251016194851.65981-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20251016194851.65981-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.149]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: 0129620008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: xqd9xwt59e16k4n9bkom8p4rjimaus4t
X-HE-Tag: 1760670726-474096
X-HE-Meta: U2FsdGVkX18IeCjK62ZWv/AXL4NWpk+xF/PROfHJfWYlCPFOnvhUXouyLNvsaKxZ73qPINS3j1vovmieedkavMTUuGIglnrFigDBfUhRqm1rTYNUaSrCoyEPpVhFnPkDcjvNCMq1Mg9NBBK9EH3ZPzQ9ipnq0mFPxQB8HOcUrRTuW4Iiu3bcu9YOxNKLGAgn2/EBtgBw5r1x8WhJBChIYys+ynpk7PbgdMza0nTJBDhEH+b3q6umFASy9Uhxi3z/DFHZnwuoFN74mts3TFQUSS5xZ5wrlt7231prHics2aES3xmF/hlnxdsmp68gKTJTY/G1V+poJAQ52Qqww1pGy3SlYSgmO2nZgx62OOX6kj3ptfWQDHm6DZ+JBvwvXexjPCFfYgl2in/h4h24AzaO82Zoyiv5krmPcVnmbw1PtasnxQXwHglXLOUYy2UDKr7Pa6D1ByuLoIIGGqT/dWzEEEZZt0lH4da/lrKO7XBFV2+h4K/vdiqDUtSKiWwMhPDNshvfAsYutNfIXl1jMZzNUpgd7pqZ2CLrgpFW3br164QCoxRXfN6ncTyxBeRP/DQtQqqpKZMZiaAyXG+cUTHyxYi2uPXJPw6kcjfT4Xywvy6gDph/ip1EjHgMYzkTUOSEBj+OsdZUj31Xfc+qVMltKcmujDoUJWr51uaMg5sSqyEl+nioARV8LaXU+cpN8cSO7jkD2zDxfjz58hGbLt0em4CODurStsDNch0tigZNzwfm7mmtyTCHmzofBCAi6uRqK3XjWQutt2st9PrAu7sUZKZYlVc76lGHQyysPns2vVY02KyZVh78bvdPzUEDJXI5HBdCs6kuxfUwuRrRi8BnwpG6GWIOQv8yBawXbsYvj0pBy510bZprdCLxHL1+dl+cirScRJ9eh5AzxCq/wKGci118vVgcmS21fD60qaymwa2ESk4EKZ1kDCcYPIdDQxt1lugjkXHgPBfb3we3B8J
 Uwbns2XZ
 V5z5b3FNRcdP+HilX2D4obYcYJuV+5D6sIgTfIENSXppz1eJJUkWl04D8xtlMUwr2BPfHcCh/wD/pk6JGqXQW85Xw5gqqHqS5vJ3c1HgOKrPdEn0aiVtPffcgykxJEhC0BIHwgyXV3vTcBUCPBeADreFyvxfbWrqdm7kmTUP1Mr6+Z23Wqfsxr5HxmJR75XApb/OXAAszdab62cPq4FlaFUknQ34KsarhhNHTObDHZxm3WOZppRpuHW1LA7WJUowq5fCWoC+1u+Gp03iqY9uWUcPcrkSqAYaIPYZgboqhZ07Zl9jRLl8qqUp9TEUyNHD34M7FttSL9ZY0/z0aqNhm862e+BAU/v/uSG/CJzcUjGRQ4hWF/qIilG23z0Lh0c6rQ9QQSV6E4iPd9Ht/JQGptaZyXtMRkQkUxOts
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

在 2025/10/17 3:48, SeongJae Park 写道:
> On Thu, 16 Oct 2025 18:47:17 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>
>> After adding addr_unit support for DAMON_LRU_SORT and DAMON_RECLAIM,
>> the related region setup now requires alignment based on min_sz_region.
>>
>> Add min_sz_region to damon_set_region_biggest_system_ram_default()
>> and use it when calling damon_set_regions(), replacing the previously
>> hardcoded DAMON_MIN_REGION.
> Can we add more detailed description of the end user issue on the commit
> message?  My understanding of the issue is that the monitoring target address
> ranges for DAMON_LRU_SORT and DAMON_RECLAIM would be aligned on
> DAMON_MIN_REGION * addr_unit.
>
> For example, if user sets the monitoring target address range as [4, 8) and
> addr_unit as 1024, the aimed monitoring target address range is [4 KiB, 8 KiB).
> But damon_set_regions() will apply DAMON_MIN_REGION as the core address
> alignment.  Assuming DAMON_MIN_REGION is 4096, so resulting target address
> range will be [0, 4096) in the DAMON core layer address system, and [0, 4 MiB)
> in the physical address space.
>
> So the end user effect is that DAMON_LRU_SORT and DAMON_RECLAIM could work for
> unexpectedly large physical address ranges, when they 1) set addr_unit to a
> value larger than 1, and 2) set the monitoring target address range as not
> aligned in 4096*addr_unit.
>
> Let me know if I'm misunderstanding something.
>
> Also, if you encountered the issue in a real or a realistic use case, adding
> that on the commit message together would be very helpful.

Thank you for the additional explanation! Your understanding and description of
the issue are entirely correct.

Our ultimate goal is to have the monitoring target address range aligned to
DAMON_MIN_REGION. In the original logic, however, damon_set_regions() did not
take the newly introduced addr_unit into account, and directly performed core
address alignment based only on DAMON_MIN_REGION. As a result, the monitoring
target address range was aligned to DAMON_MIN_REGION * addr_unit, causing
DAMON_LRU_SORT and DAMON_RECLAIM to potentially operate on incorrect physical
address ranges. Therefore, we need to use min_sz_region instead of
DAMON_MIN_REGION in damon_set_regions().

I will add the detailed commit description in the v2 patch.

>> Fixes: 2e0fe9245d6b ("mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT")
>> Fixes: 7db551fcfb2a ("mm/damon/reclaim: support addr_unit for DAMON_RECLAIM")
> Let's break this patch into two patches, so that we have one fix per broken
> commit.

Yes, I actually considered splitting it up before submitting this patch, but found that
doing so might make the patches look odd. Since we're modifying the input parameters
of damon_set_region_biggest_system_ram_default(), all the call sites of this function
need to be updated accordingly. It seems we might need to split this into three patches:
1. Preparation patch: Add the min_sz_region parameter to
    damon_set_region_biggest_system_ram_default(), passing ctx->min_sz_region in stat.c,
    and passing DAMON_MIN_REGION when calling this function in reclaim.c/lru_sort.c?
2. Fixes patch 1: Modify lru_sort.c to pass param_ctx->min_sz_region.
3. Fixes patch 2: Modify reclaim.c to pass param_ctx->min_sz_region.

I'm not entirely comfortable with this approach. Would it be acceptable to submit this
as a single patch?


Thanks,
Quanmin Yan

>> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
>> ---
>>   include/linux/damon.h | 3 ++-
>>   mm/damon/core.c       | 6 ++++--
>>   mm/damon/lru_sort.c   | 3 ++-
>>   mm/damon/reclaim.c    | 3 ++-
>>   mm/damon/stat.c       | 3 ++-
>>   5 files changed, 12 insertions(+), 6 deletions(-)
> The code change looks good to me.
>
>
> Thanks,
> SJ

