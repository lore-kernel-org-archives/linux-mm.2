Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 146CDCDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 08:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9A256B0088; Mon, 22 Jun 2026 04:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72AB6B008A; Mon, 22 Jun 2026 04:55:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89856B008C; Mon, 22 Jun 2026 04:55:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 92EF86B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:55:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12954C2857
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:55:42 +0000 (UTC)
X-FDA: 84906940524.24.C88D277
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5A2BE16000B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:55:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=voOQsZgR;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of guohanjun@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=guohanjun@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782118540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/k27yuvvAcrSuI7nc2KFV7Xg5goqifRJQoC4fuhhzo=;
	b=wjyN7rSwXW5yNjpZhkDwq2VugiKYIcZJHnMSJ6N+1iQXMOvyD/M8ua1te5mr24oF1qzGKN
	2XW+GIhVSU9mIlfK+AN+utCn4SWkNf5IWQBh4UfVwnWAhghW2oavZoi947lZsDlDrOLIPE
	UB/G1YA6JD5MBdhiK5A/jfq4Klfq/Lo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=voOQsZgR;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of guohanjun@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=guohanjun@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782118540;
	b=6lBTKQd0I3IA4Ruw5Qs+tJma3gH+uXqVztRRhi9VYWXonn8AKQJsGSTVk4oS7ToyLKU7cf
	ujvwV4oDnIGZqqXFlByVAQpxMejD2PozaT50vOxLtxntFow4biZq/cMsWkMANN/v/lwwCK
	FEb3wii9JZSRnvjh2kdlmJhe5jW8Gyk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2/k27yuvvAcrSuI7nc2KFV7Xg5goqifRJQoC4fuhhzo=;
	b=voOQsZgRzlKYfqyFauHA+3HtskSas5ruL50C+YKIm2HyfbZEt9c0235+CQwD+tly1r9dN5DOB
	az64d8RQg5S21lQjYO9MI1N5n7V5JVw4JsJdq1eZg90rgxjElk2jBu9/OZQEP8ttXF2JuxkyfA0
	jtxqNrTBWJYk320CaJA63sQ=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gkMJ63pQ8znTVR;
	Mon, 22 Jun 2026 16:46:46 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 9591240562;
	Mon, 22 Jun 2026 16:55:31 +0800 (CST)
Received: from [10.174.179.24] (10.174.179.24) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Jun 2026 16:55:30 +0800
Subject: Re: [RFC] arm64: early_ioremap fails to map ACPI MADT on 64K pages
To: Will Deacon <will@kernel.org>, Yu Peng <pengyu@kylinos.cn>
CC: Catalin Marinas <catalin.marinas@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, "Rafael J. Wysocki"
	<rafael@kernel.org>, Len Brown <lenb@kernel.org>,
	<linux-acpi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<lpieralisi@kernel.org>, <sudeep.holla@kernel.org>
References: <20260617060110.2846851-1-pengyu@kylinos.cn>
 <ajVVfnGIq_6zt2jC@willie-the-truck>
From: Hanjun Guo <guohanjun@huawei.com>
Message-ID: <3cceb66d-4496-1a46-60ab-f43b0669fb71@huawei.com>
Date: Mon, 22 Jun 2026 16:55:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <ajVVfnGIq_6zt2jC@willie-the-truck>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.24]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500002.china.huawei.com (7.185.36.57)
X-Rspamd-Queue-Id: 5A2BE16000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: f8k6rb6bfbwaocqt8ut7id1nr9amo4pg
X-HE-Tag: 1782118538-937803
X-HE-Meta: U2FsdGVkX1/PboGmaGxJ43L/10wX2y3IF3wLAjT4qQ44iq+FitseHd6LugbBrcVmFFGaKcG2vetG+C4XOppbMohv/tauEYxun+e30qPBv6oP3gfe+dOTo+6EM+tWMp/PGbgTZa3eiWHwI/xF623wotDutEwit27JnjhX9NB9yFFjugVHxnyTbhsEr/GXsH7MiXv6BDPkVTF86tQxA1vyHgTVSoMyjOn/HaMAOrEPfese3sDYVnhqwAQyaDrwvalCjdt1iWdT9Haxy8Kll9TFJwi3JhPB/mZuT8V9nGkhCxV/etpuC5X7ntdkKXGNQdzkhmylb7xX3BnKUje5aOVPflDx+xC0e7e/wy/PlgblJ2JGnmOmfE61PyfJK6/sHv1q6L/IaGQyZS5ZZSI1ptwwlkd2lnoPQPJCYA0mMFn2qqNfqe6DNGe2oZYpO8TxxKtdRFp5OlrHZowcEco7ZjWWvQqXtbYSobL2VnwX7v4ugXqoQsk6Zhkky73TbPG4QO8MWAApu8CG3XNiTEEmFBM1zllUpHFkbDeuRD7ic+Xefiob8V/CRq+OPGjv5IkvjMmQLDXyjMDMjW0I4iSeswICImdLooO7rbODaVe02U+yhqwuvNBkr8+MyzTDnb/fC6L0J8vhEVeMcn2wScc03+PqBGiw5IIMX8jViRabRdIGOg7L/ZB/lS5GUkUecZS+rLcVkDeVG7xe6g+ObI/1GjRUl+0JNUkr42YNd7HTGjee5l6hhT3VeNhFZPaIR2fuj0WmuUe7H6rNS4z7EV/FW19NVkXxvEa94Sm7hV+jnUCUjRPWc3isVxeMTFbOlwFidXmcGy+miDl4PlAP5hZHd0EpYYZ1ujWUwi5XG9MOJSQkRJ+fGC9YvYmdH/kTB3sDOULkAlzUJWryAimP4MWma6vQmCpgXQYuT4dh4b7YBiSqrAIakjf0hinJsupvqJjypElX4guktDE41wc0s+QKERV
 kjGQf5/w
 E4jT+gTCN42WmfuQQ+NM2nQDBATCuAPVxhOG4q3EAhnTM1nP3djEmt31FI/8WtuoyEnT9kOdgmY1QjDRmHq3TuQhN6ZQY+JsnW78JK3SwSZ0LwLYnthjWNdhbX9CYwIGC+0A4xRDKR3GEtWMfjfTIRm034L74DZN78sCjzcD7jqbPF+8E0Z1gU9WlU4APwXiG6ZIAafskMuujqfz4uxV9uUoIUCbsylXXL3xZMseMdnumVyGfVpmxH2aGvkB0kuwYBKZXdgaCYnc2tEIc0kHgqV3WXszGDep+wCGSP70P8gZHUHmrV5BXrCSi2cvu2jbRqMe/7CfaM/9PAjI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/19 22:43, Will Deacon wrote:
> +arm64 ACPI maintainers
> 
> On Wed, Jun 17, 2026 at 02:01:10PM +0800, Yu Peng wrote:
>> I hit an early boot failure on an arm64 system built with 64K pages while
>> parsing the ACPI MADT.
>>
>> The failing system reports:
>>
>>    PAGE_SIZE: 64K
>>    MADT physical address: 0x5a7ae018
>>    MADT length: 0x32094
> 
> The MADT isn't even 4k aligned, so why does the page size matter in this
> case?
> 
>> The failure happens when acpi_table_parse_madt() calls into early_memremap()
>> via __acpi_map_table(). The MADT itself is smaller than 256K, but its
>> placement causes the early mapping to require 5 64K pages:
>>
>>    offset within 64K page = 0x5a7ae018 & 0xffff = 0xe018
>>    mapped range           = PAGE_ALIGN(0xe018 + 0x32094)
>>                           = PAGE_ALIGN(0x400ac)
>>                           = 0x50000
>>    nrpages                = 0x50000 / 0x10000 = 5
>>
>> On arm64, NR_FIX_BTMAPS is currently derived from a 256K per-slot budget:
>>
>>    #define NR_FIX_BTMAPS        (SZ_256K / PAGE_SIZE)
>>
>> So for 64K pages, NR_FIX_BTMAPS is 4. The mapping therefore fails the
>> early_ioremap() check:
>>
>>    if (WARN_ON(nrpages > NR_FIX_BTMAPS))
>>            return NULL;
>>
>> After that, MADT parsing fails and the boot continues with symptoms such as:
>>
>>    ACPI: APIC not present
>>    missing boot CPU MPIDR, not enabling secondaries
>>    Kernel panic - not syncing: No interrupt controller found.
>>
>> A firmware change can avoid this by placing MADT so that:
>>
>>    (madt_phys & 0xffff) + madt_length <= SZ_256K
>>
>> However, I do not think ACPI requires such placement, so this looks like a
>> kernel-side robustness issue as well, especially on large arm64 systems where
>> MADT can grow with CPU topology.
>>
>> One possible kernel-side change is to increase the boot-time mapping budget for
>> CONFIG_ARM64_64K_PAGES, for example using a 512K per-slot budget only in that
>> configuration. I do not think this should be applied unconditionally to all
>> page sizes, since the arm64 early fixmap code expects the boot-ioremap range
>> to stay within one PMD.
>>
>> Has anyone seen similar failures on arm64 64K systems?
>>
>> Would maintainers prefer treating this as a firmware layout issue, or would
>> increasing the early_ioremap budget for 64K pages be acceptable?
> 
> It think it boils down to what ACPI says about the alignment of the MADT.

I checked the ACPI spec and it didn't require the alignment for ACPI
tables, but in UEFI spec, it says (for aarch64):

ACPI Tables loaded at boot time can be contained in memory of type
EfiACPIReclaimMemory (recommended) or EfiACPIMemoryNVS.

EFI memory descriptors of type EfiACPIReclaimMemory and EfiACPIMemoryNVS
must be aligned on a 4 KiB boundary and must be a multiple of 4 KiB in
size.

It only requires EfiACPIReclaimMemory type to be 4K aligned, not
for each ACPI table, because ACPI tables can be packed into the
allocated EfiACPIReclaimMemory type, correct me if I'm wrong!

Thanks
Hanjun

