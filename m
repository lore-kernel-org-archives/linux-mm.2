Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B81CCAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 12:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D9F8E0014; Mon, 29 Sep 2025 08:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7688E0002; Mon, 29 Sep 2025 08:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB6018E0014; Mon, 29 Sep 2025 08:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C09E68E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 08:30:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58D4A1401EF
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 12:30:02 +0000 (UTC)
X-FDA: 83942219844.15.078F9C2
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5560B1C0009
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 12:29:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ncYpLbcw;
	spf=pass (imf21.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759149000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xwPQpa8YyY/4fqmUTUsxZAf/0tS09vx9t0wYWRdNUL0=;
	b=vKKL/TXcnHnJ0zAGg5ymqkZnfjEstyX45AFYmc2/Of6zTN4huDY34N8UrHXva4JR97VRAn
	QJcbOL7LAl9QAWPe04w1JOy60I2N6uE7rJs+3Ik1sdQss6mob878PJvdiq8HuW7q+Kb2gv
	j11MaRlYkIgo3wSOIiMZGVMk9DSIEyE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759149000; a=rsa-sha256;
	cv=none;
	b=Uc4fAsa0mrDxsNpRWhcnhxMq+iUFHMHZ5PgSDlsDWLi4KEE2GVSiqTlSdtmaWHjLrAsWzR
	JJVxl69JO26CKF98mBEVHHYJ5eHbRHMqC+evmCX/T33qHPRYPYFmxLuX6NhQL32qbyhPdQ
	DbQvCrLsHSHooLKWFoe0u0Qs/YmBagI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ncYpLbcw;
	spf=pass (imf21.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xwPQpa8YyY/4fqmUTUsxZAf/0tS09vx9t0wYWRdNUL0=;
	b=ncYpLbcwbF08YgdPPX4CVpXE+aN+dyGed0mOtmm9Yb1io98SZhDIOS3IpWVB94YZGb8sS51cQ
	F3GvRpBPwfGQzVP//ABufVlXWHhm71r3cjEYoRcdYbwNE1HU4O3C8kaiRNavtGyF+enhqUDdoaZ
	0Vnl6G/LMcAhi6+Uqya9m98=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4cb0r712HNz1cySb;
	Mon, 29 Sep 2025 20:29:43 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id AD39C180042;
	Mon, 29 Sep 2025 20:29:53 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Sep 2025 20:29:53 +0800
Received: from [10.173.125.236] (10.173.125.236) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Sep 2025 20:29:52 +0800
Subject: Re: [PATCH 1/1] mm: prevent poison consumption when splitting THP
To: Jiaqi Yan <jiaqiyan@google.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>
CC: <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <tony.luck@intel.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<baohua@kernel.org>, <nao.horiguchi@gmail.com>, <farrah.chen@intel.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Andrew Zaborowski
	<andrew.zaborowski@intel.com>
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
 <CACw3F50ijQ20Vg8ycMROSCccf_XtjB_fFvLGxvQZ7eaNQoLwGQ@mail.gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <5f117b73-8d7b-b233-a0a8-2a29ea6312a8@huawei.com>
Date: Mon, 29 Sep 2025 20:29:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CACw3F50ijQ20Vg8ycMROSCccf_XtjB_fFvLGxvQZ7eaNQoLwGQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.236]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5560B1C0009
X-Stat-Signature: 9ubtdwoxky9g6ub9nf1wkdj5gapkn8bj
X-Rspam-User: 
X-HE-Tag: 1759148998-71239
X-HE-Meta: U2FsdGVkX1/0DH47BedOnB3Y29aAHiuax8638F+gLFplHFn05slMrFsmSAhIMWR9Mn41yAcniP4+DyGebCZfSa3pu+JQR2URqrbRcBc+LOVtaYapr2KTOnuXVjFyvcSM1w//K2ajcQNyHBnUvCJpvvct6yb9MjpmJvI31HoGATXj1MpLWQmym41R5O+/ois7KnWcRtIofCRyM5j3E+RvlPyXAsupsyEeU4E6Er7VaoxNLd8t19fCkATj7xx5sQULF1Zo50WHtNDRokYb1owDkbGhGRPoankZ+bG0KGz8ZHa4/cvnl8Gltzq848+x/Mqx7RydDn3ibaiFjHSpSvQJmJD0ULDTj3A9BlTB2WmyTDQwGhhI356IQMcxy93n4OoT32qUdlPz0g8vPWwQ0tWt+K7pzkYSUTCbTDW2PMorOQrb2DjRToGGta++XDDVB0wM8sfqOttxyEe1Av25e8nD3WPSk39mwp/7gvnaDHZS6QWo2bzAv879kSD6oWOk8VHFoDOnIkJGacOCrmk4Fkh3am2HMtqdElQV6wvUNau3JZ9mpuYrQbBTM6RLUdkRJkwGblTt/jjQ/PqpaF8wfY9yYlT8bpkGAoXiEIne4wOFd/naMKrVwtVuO7a8l6nbUnc8wFb4tHo9E2IavX/u9PZXWi4NxrgR+Xpae74j5R9vk3/Yy8pa0j6mKyN1AntPRFya/HXHDTtNm6G5/p5nRY88+qhdk9mUXy/p/Vk9HxIdzkIxuo2yWCrhCDh6T9wpyLoZptXSJaJEPJ67TyqgbuhQkI5MDVmq02AU/e14Z3b/ruFRBu4fVsp1kGDx1cSP/ih3Sc5tYYznS8eiRTdDqo6GCdVz8WEFQaYOQ0WFV3bFBZpxUKEc4U9ZQsuBSnOf1NOM/5Ch2vwgOz/7mEhqeRDOqjwlfZXX3jiZmJmdMlurKe2AC2KzZuM948iRvFO3Whs2EDIn9d6xp2usZt+gLBq
 Z67Fe6br
 wypHerHNeFiUXzeFZHdZxYqqNCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/9/29 5:55, Jiaqi Yan wrote:
> On Sat, Sep 27, 2025 at 8:30 PM Qiuxu Zhuo <qiuxu.zhuo@intel.com> wrote:
>>
>> From: Andrew Zaborowski <andrew.zaborowski@intel.com>
>>
>> When performing memory error injection on a THP (Transparent Huge Page)
>> mapped to userspace on an x86 server, the kernel panics with the following
>> trace. The expected behavior is to terminate the affected process instead
>> of panicking the kernel, as the x86 Machine Check code can recover from an
>> in-userspace #MC.
>>
>>   mce: [Hardware Error]: CPU 0: Machine Check Exception: f Bank 3: bd80000000070134
>>   mce: [Hardware Error]: RIP 10:<ffffffff8372f8bc> {memchr_inv+0x4c/0xf0}
>>   mce: [Hardware Error]: TSC afff7bbff88a ADDR 1d301b000 MISC 80 PPIN 1e741e77539027db
>>   mce: [Hardware Error]: PROCESSOR 0:d06d0 TIME 1758093249 SOCKET 0 APIC 0 microcode 80000320
>>   mce: [Hardware Error]: Run the above through 'mcelog --ascii'
>>   mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
>>   Kernel panic - not syncing: Fatal local machine check
>>
>> The root cause of this panic is that handling a memory failure triggered by
>> an in-userspace #MC necessitates splitting the THP. The splitting process
>> employs a mechanism, implemented in try_to_map_unused_to_zeropage(), which
>> reads the sub-pages of the THP to identify zero-filled pages. However,
>> reading the sub-pages results in a second in-kernel #MC, occurring before
>> the initial memory_failure() completes, ultimately leading to a kernel
>> panic. See the kernel panic call trace on the two #MCs.
>>
>>   First Machine Check occurs // [1]
>>     memory_failure()         // [2]
>>       try_to_split_thp_page()
>>         split_huge_page()
>>           split_huge_page_to_list_to_order()
>>             __folio_split()  // [3]
>>               remap_page()
>>                 remove_migration_ptes()
>>                   remove_migration_pte()
>>                     try_to_map_unused_to_zeropage()
> 
> Just an observation: Unfortunately THP only has PageHasHWPoisoned and
> don't know the exact HWPoisoned page. Otherwise, we may still use
> zeropage for these not HWPoisoned.

IIUC, the raw error page will have HWPoisoned flag set while the THP has
PageHasHWPoisoned set. So I think we could use zeropage for healthy sub-pages.

Thanks.
.

