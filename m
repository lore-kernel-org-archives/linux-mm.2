Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE095CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 13:47:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BDD16B008C; Fri,  5 Jun 2026 09:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196026B0093; Fri,  5 Jun 2026 09:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D3026B0095; Fri,  5 Jun 2026 09:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F11D36B008C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:47:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9956B12012A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:47:56 +0000 (UTC)
X-FDA: 84845987352.10.32A2F9F
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 939AA4000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:47:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780667274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0VFERzCHnfVYWMS98UIV3KziVe6adFtZyXoIgvla8kw=;
	b=pNMPmm1aAA7dwXhrI/KJSlM1/lSqXQcN0JxcpGLn5wC5a/ASSlkeB9OCM+4wh/I70vJamQ
	DrPTd67VVv6Ire9ZL9KAx1K0sfm42INQ5BaidvA8tCrpSdRQ+2ua4GTS5YbFNixsTejA14
	YsGggZa35v1IbjakIB/078UzUg0d9CM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780667274;
	b=HnopdacHPZ5jRM8Hqn1xTDqNO/d7hWCXn/PO2MZ4Fy+6FAcJt96RzQ68m1euVzhRyFqMuo
	VbBs+s7mVCaOUa/wIvZWZ2sDDpvPGf1HvNvFarEIvx2Rd7HNA+Y2BHTotsgcbN2l6f08ZN
	pcDd1JQnYxwX3L69emNpNfLI4aWP1YQ=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gX2mF2YyTzHnGk9;
	Fri,  5 Jun 2026 21:46:53 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id E8EC040571;
	Fri,  5 Jun 2026 21:47:48 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 5 Jun 2026 16:47:48 +0300
Message-ID: <71dd8dd8-f30f-436d-93d9-fb812ed7a2eb@huawei-partners.com>
Date: Fri, 5 Jun 2026 16:47:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 3/4] mm/damon: introduce DAMON_HUGEPAGE for hot
 region hugepage collapsing
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260605010620.83004-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260605010620.83004-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 939AA4000A
X-Stat-Signature: cjqswq7q9odcbiz8m6a55m9jqo6g65jt
X-Rspam-User: 
X-HE-Tag: 1780667273-913740
X-HE-Meta: U2FsdGVkX1/1Y6kYgPaeL5Y2HrlfjvQJcFP6w88r+WXJoj0z3/cmVgFarcFznfmLULb+I0UqngkoP0+VY8oM2oQiP9M9+preDPM/6g+jHRXfSwZlJim9KI1JMt4ewcBprnJJz4QfJcal4OrnGeo6BFf2DBZpA0Ckv4jPQIbHdoxVPV0MdlIRDmvl4FpY8hzvAJqOcC0DQEL5tupWvpkfMo8DPe6cp/qNqiJqhWk8zUC/ifhDjPjRsTi8wineQe6vWDB7WDvCdoby8DvyLkO31gV9SxwTnw3KwVXDMojJomFqnBiMHN2P1hCIl1xoYnKePDWNmLk8MZOm5y/EU5+brEZCcDt5T9CMrcX7d08mZ/qhze/y5Nu2vXjcYi+qSJONtlbPR/nSD0WuO0QGo36wWT2iJmA5mBX/eKOW/cGvJCJwYW0Lq9DRs42w47B5qBh2IxPsF7TsN8bBG50nK7GJUHVk7HemCtqurZWU0i0pw+4LTgL9xpoDYmnM7UiKGTVRqcW/I8mx+q5+0p6Zp2IwE8mO/iQeXBIIVbsRQSEgHXmg40IXbOCEHrJuMhGE+UYWe2s/hu2CMDA+4xu9GTb/TqhUNJjfr21RKwV064NNQqVjvefCrIZhcIxEUn2WmeU2OZ2LtZkCJ8Ufww5qPS4IEo8l4isKYIpEJ6lrDov7VUawOOcGUpnPE6O31GOMwRF1fBrJirylStKVBJJKz4h8gNXCpbjMbai291xvOBDzh75W1HH0MXoTs3+Mi5OiM1LMK3RT7eOBm6qB/1pqikYF9kAGCQEkwwx1bquCyZ1TB4SyHHcBfPPXiG1V08CL7doI/niJUuh2X7gRydM/Hd77+NxDHQtIA+097EsOMkoP+5IflA2KjsN6K3xQ98W8tvqVOsvAdGfVTYezbeGPgtOP1lUTJbokVLGnB6aEB+w/5R5iUgyH3yv+hRpif8RrOQMCpfJ9/sSRyecn59q4u/2
 ZO0LOaZx
 QgZ2xR9PkdORRKjfEmkGNzikG3r+PC1fqwzIBCPxbh1C1QCd4+i5UADysba/ANoC2+qAQqt80dnrz+C/RNULx/QhLTyhKmqPhS3RVDMBnVufaBTBDBEmzXMGDh0f/zq3Z9Zp6WZpABpKa0FVduoyUBsLoIzouJtgqil8DtrSTLZSoXfV3/qlOYb2gTQ7+N6uJqlxSF5ZoSVt8PdomlocmVt5E8DSWsIu8r27e4sDvDt3Pc6TkvbmnepTRj5CzzS1TrdZ8avVsvE608epCBfG/59ZNtinkEeRbbdARg7qjYJZ4Z/RzzlVf4b4E7mblmznJMamaSEcwJLnhpRfOyZ3ZuUTgaRoioTRyZYGK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/5/2026 4:06 AM, SeongJae Park wrote:
> On Thu, 4 Jun 2026 15:03:36 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> This patch introduces a new DAMON module (SAMPLE_DAMON_HUGEPAGE)
> 
> Could we make the name shorter, to look more consistent with other sample
> modules?  E.g., SAMPLE_DAMON_HPAGE?
> 
OK, I will change the name.
>> which collapses hot regions into huge pages.
>>
>> SAMPLE_DAMON_HUGEPAGE operates in the virtual memory space, for a
>> specific task. The user is expected to supply the PID of the task
>> that is going to be monitored through the monitored_pid module
>> variable.
>>
>> SAMPLE_DAMON_HUGEPAGE uses the hugepage auto-tune mechanism to
>> increase or decrease the aggressiveness of page collapsing. User
>> autotuning is also available for additional tuning aggressiveness
>> control.
>>
>> The module also includes changes to the DAMON compilation, so that
>> the module can be enabled or disabled.
>>
>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> ---
>>  mm/damon/Makefile              |   8 +-
>>  samples/damon/Kconfig          |  12 ++
>>  samples/damon/Makefile         |   2 +
>>  samples/damon/hugepage.c (new) | 350 +++++++++++++++++++++++++++++++++
>>  4 files changed, 368 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/damon/Makefile b/mm/damon/Makefile
>> index d8d6bf5f8bff..16459ce40304 100644
>> --- a/mm/damon/Makefile
>> +++ b/mm/damon/Makefile
>> @@ -1,9 +1,9 @@
>>  # SPDX-License-Identifier: GPL-2.0
>>  
>> -obj-y				:= core.o
>> +obj-y				:= core.o modules-common.o
>>  obj-$(CONFIG_DAMON_VADDR)	+= ops-common.o vaddr.o
>>  obj-$(CONFIG_DAMON_PADDR)	+= ops-common.o paddr.o
>>  obj-$(CONFIG_DAMON_SYSFS)	+= sysfs-common.o sysfs-schemes.o sysfs.o
>> -obj-$(CONFIG_DAMON_RECLAIM)	+= modules-common.o reclaim.o
>> -obj-$(CONFIG_DAMON_LRU_SORT)	+= modules-common.o lru_sort.o
>> -obj-$(CONFIG_DAMON_STAT)	+= modules-common.o stat.o
>> +obj-$(CONFIG_DAMON_RECLAIM)	+= reclaim.o
>> +obj-$(CONFIG_DAMON_LRU_SORT)	+= lru_sort.o
>> +obj-$(CONFIG_DAMON_STAT)	+= stat.o
> 
> This is for letting the new sample module use the code in ops-common.o, right?
> I'd like to keep sample modules simple and isolated under samples/ directory.
> Could you please make the sample module simpler and remove the above change?
> 
Correct. To be honest, I didn't know it this was the correct way to do it.
Thanks for the feedback, I will just create the context manually in the
module.
>> diff --git a/samples/damon/Kconfig b/samples/damon/Kconfig
>> index cbf96fd8a8bf..512f150aaabb 100644
>> --- a/samples/damon/Kconfig
>> +++ b/samples/damon/Kconfig
>> @@ -40,4 +40,16 @@ config SAMPLE_DAMON_MTIER
>>  
>>  	  If unsure, say N.
>>  
>> +config SAMPLE_DAMON_HUGEPAGE
>> +	bool "Build DAMON-based collapse of hot regions (SAMPLE_DAMON_HUGEPAGE)"
> 
> Can this be more consistent with other sample modules?  E.g.,
> 
> DAMON sample module for auto-tuned THP collapsing ?
As mentioned before, I will change the name.
> 
>> +	depends on DAMON && DAMON_VADDR
>> +	help
>> +	  This module monitors a certain PID provided by the user through
>> +	  monitored_pid attribute. Hot regions are determined by DAMON-based
>> +	  sampling. Collapsing occurs according to the quota goal using total
>> +	  memory usage to huge page usage ratio. The ratio is set by the user
>> +	  through a module attribute.
>> +
>> +	  If unsure, say N.
>> +
>>  endmenu
>> diff --git a/samples/damon/Makefile b/samples/damon/Makefile
>> index 72f68cbf422a..f90845faec85 100644
>> --- a/samples/damon/Makefile
>> +++ b/samples/damon/Makefile
>> @@ -3,3 +3,5 @@
>>  obj-$(CONFIG_SAMPLE_DAMON_WSSE) += wsse.o
>>  obj-$(CONFIG_SAMPLE_DAMON_PRCL) += prcl.o
>>  obj-$(CONFIG_SAMPLE_DAMON_MTIER) += mtier.o
>> +obj-$(CONFIG_SAMPLE_DAMON_HUGEPAGE)	+= hugepage.o
>> +ccflags-$(CONFIG_SAMPLE_DAMON_HUGEPAGE)	+= -I$(srctree)/mm/damon
> 
> As I mentioned above, let's not mix samples/ with mm/damon/
OK.
>> diff --git a/samples/damon/hugepage.c b/samples/damon/hugepage.c
>> new file mode 100644
>> index 000000000000..e24562c92348
>> --- /dev/null
>> +++ b/samples/damon/hugepage.c
>> @@ -0,0 +1,350 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2026 HUAWEI, Inc.
>> + *             https://www.huawei.com
>> + *
>> + * Author: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> + */
>> +
>> +#define pr_fmt(fmt) "damon-hugepage: " fmt
> 
> Apparently this module's source code is following patterns of reclaim.c and
> lru_sort.c.  That's for non-sample modules.  Could you please rewrite this
> sample module following patterns in sample modules, like that for wsse.c or
> prcl.c ?
> 
Ok, I will do it.
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei


