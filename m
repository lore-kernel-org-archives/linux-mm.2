Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBC81F532E6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 06:41:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1CC76B00C2; Tue, 24 Mar 2026 02:41:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE876B00C3; Tue, 24 Mar 2026 02:41:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4086B00C4; Tue, 24 Mar 2026 02:41:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDBF36B00C2
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 02:41:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31BB5BEFF3
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:41:38 +0000 (UTC)
X-FDA: 84580010676.23.AD10E6F
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf27.hostedemail.com (Postfix) with ESMTP id E33754000E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:41:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="KvG10/A7";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774334496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eVHjW36RkcRE7Sq4GvAUwpA4tNCHY6Tlpq7co/9PTeE=;
	b=hIGbrwhmjkGOeq26Lemyesr9AGLcAS70ojLf0hrEsnYXJknvYW2PwwaFxBXHnTU21y+YFx
	fehTD5kTIqxobuwcLRdPldwJmG66hq+3X8PnqSDhDU8bQ3y//e1Z4ywvHPztABbnC7Tpfd
	eFgGVpEW+SMP3wdHeQ41fMHz788hdR0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774334496; a=rsa-sha256;
	cv=none;
	b=xWbSDuZErsMnF0zL+WF5cYJ+0bRIKxorRJiBb4m28YaBf+5diY9fopcIJy2f8RMcadpfPq
	uAzvahXeCa6zJlwAEp6WHGIbAUjHWOZG//w6UEpi3A0Z5oJ7UvrTTC0yRZUe+po5cKLDvx
	K64y1xo+p12ZuiPhtcdoCxGKSkP7JHQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="KvG10/A7";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=eVHjW36RkcRE7Sq4GvAUwpA4tNCHY6Tlpq7co/9PTeE=;
	b=KvG10/A7W8KsgVIpNhjawOnqUvDEbL2H7Lwr0/RbeHxcrq7NKI56xdG/eRnTdj1nyIl/2fTpv
	8KjSZ3S/nnMpSrgfPk80lyYqhFFtWBQKRrYA+gEbqIGjThmis2HcBMdqjDVIGiCXMnXXhmhcmjZ
	DVyG3AgML4hexS7YDTm4NpA=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4fg0fh0B6Tz1T4Hs;
	Tue, 24 Mar 2026 14:35:56 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 81D5F2012A;
	Tue, 24 Mar 2026 14:41:25 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 24 Mar
 2026 14:41:24 +0800
Message-ID: <dd3c23ae-44cb-4194-a862-bb0b6e7f01a4@huawei.com>
Date: Tue, 24 Mar 2026 14:41:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/hugetlb: fix memory offline failure due to
 hwpoisoned file hugetlb
To: "David Hildenbrand (Arm)" <david@kernel.org>, <akpm@linux-foundation.org>,
	<muchun.song@linux.dev>, <osalvador@suse.de>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260321021031.2240780-1-tujinjiang@huawei.com>
 <8b4092d7-bd99-4715-9a5b-471096ba29a1@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <8b4092d7-bd99-4715-9a5b-471096ba29a1@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: E33754000E
X-Stat-Signature: 4md1wr8wc1867ta3czwcangudotwaznk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774334494-890597
X-HE-Meta: U2FsdGVkX1+SvZUmjjVo9CN46KahC9CkXhMrsyothR3m4THtiddJhdwNXHVUG2sE4k1dAkvpskE8yhGZWBKhrCNqs6TgkTVGuMrqMIxl0tpaEgbb+FqydUTlntuYBV+JtK+aZ9Ix23MLvYZ51hrZkTKMUEHmYp7mkbMMfgbnKDkC5WqT8kTMZbzY4ThPMaEdttQqf05DpOhGTR+R9DWwkqcpHS0FntprCtGfsSVml8I0JG3bKF4PeEWHOD626JFMWHlG4+yeWs2X7nAZNgMWgRYg7VqnglxNu4gNFnaQyS0Jc9aeTy0Q1nWnyo/eTtMPzlcZblj6KYu9C9KxLqFr39JldCvPP7+V7VbbL/PoGlkQ0mdpVXZpULGSPbLnX43XCBCQd8KsNb3otGNVS/skI+QqyJVoHjM41a7wlLGaszLGLRuc2/0xSipjVAQ+QIdTNcMzEkHjuDInDhjicV+1giaUCSyb1slscmuRNk9QnZre5vUjNPZ1CK0fUGu4wwoUF8NPo09TVrFpP09BWg6PPizMIMUHYDH4FLFMhqgoGe8TVuQvlj1IGsxj3oImffiXVUCD9Z9JXSsA92cPiAx1DZH2yxqTMRorsOuWLNFYhc5SvxejH19TTNFJOa7PfJI/ayQmOuqhSfTg4gNV294PJzN/7VoFgLxx/AvI+EL5GbXJJ1Thvq+rQmRULbhq32nCnAvZrdxl3Dbjl2toHzF+OQmP55n/rRDHXugz4bsGM8r/AX4y18GHJeh1MsIowRZotz7QM5ykhAwsJ6PaE5NBER9GmQeNjTy/m9HW9buDGPYd8Dt+uqzgc6RfQZzI9Bko/bN6yPPId37piIxPt0MdIlKHN5+0F5cGZgTozMjWEdYdrHiKQTO+9NvQ0YPcUbHgjeq/qxpGnpXUpC7BtJwy1Vf6ROfxBL8kRcvHf4ZPz8WzXsg6UBP27S04JTHZKqTqXph1V9o7/pTQOm6hPk3
 xzb2zdO6
 TCWXI9qtFjS7yBzIe4RcETBX3TQNG/W0uZ4yykm1aOVAFl5dDMeoCAlDx0vHqmBOhRhWUHu9IrOiqSaGPPCTtqym6DWFjwcTjTCBpPFeaL6Np9iD4I6mAixyYvqpC4tqGj1NARDpi9OqFQYdldhWX/AbkR7gtcGfGO+DHF5HeNXlPM3PnuadMpcyIkCxVFVX8ljUa/NmHZZVkPOehiu4d7NKe1cHAasx5MrgmoW+HMr2mxb4r/IgnJDSgzJP2G7sk7hDKqWoN/dIfpXp/Qes9ggeWz7lqTL1tptTFRzjqi/oPRwmDL5mK3LqfEYdPEZK91U60NBzDewSxsDMq3pXR8VyYPfYHaTrIAU0Vwp5QmvwRxOh1+PfvNy5txOnKfIp0G0u0S5ZlY4JGE8robjJRbAk2ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/3/23 20:14, David Hildenbrand (Arm) 写道:
> On 3/21/26 03:10, Jinjiang Tu wrote:
>> When a file hugetlb folio triggers UCE, me_huge_page() will keep the
>> hugetlb folio in pagcahe with refcount increased and PG_hwpoison set. Even
>> after the hugetlb file is deleted, the hugetlb folio is still leaked.
>>
>> If we want to offline the memory block that the hwpoisoned hugetlb folio
>> belongs to, it fails in dissolve_free_hugetlb_folios() due to the
>> hwpoisoned hugetlb folio isn't free.
>>
>> I can reproduce this issue with the following steps in qemu:
>>   1) echo offline >/sys/devices/system/memory/auto_online_blocks
>>   2) in qemu monitor:
>>         object_add memory-backend-ram,id=mem10,size=1G
>>         device_add pc-dimm,id=dimm1,memdev=mem10,node=2
>>   3) echo online_movable > /sys/devices/system/node/node2/memory136/state
>>   4) echo 5 > /sys/devices/system/node/node2/hugepages/hugepages-2048kB/nr_hugepages
>>   5) run ./hugetlb_file. This process will receive SIGBUS.
>>   6) remove the hugetlbfs file.
>>   7) echo offline > /sys/devices/system/node/node2/memory136/state
>>
>> hugetlb_file.c:
>>    fd = open("/dev/hugepages/my_hugepage_file", O_CREAT | O_RDWR, 0755);
>>    fallocate(fd, 0, 0, HUGEPAGE_SIZE * 2);
>>    addr = mmap(NULL, HUGEPAGE_SIZE * 2, PROT_READ | PROT_WRITE,
>> 		MAP_SHARED | MAP_HUGETLB, fd, 0);
>>    memset(addr, 0xaa, HUGEPAGE_SIZE * 2);
>>    madvise(addr, HUGEPAGE_SIZE, MADV_HWPOISON);
>>
>> To fix it, force to put ref of hwpoisoned hugetlb in memory offline, the
>> hwpoisoned hugetlb will be freed and succeeds to be dissolved. We couldn't
>> avoid races here, just like commit b023f46813cd ("memory-hotplug: skip
>> HWPoisoned page when offlining pages"), which force to skip hwpoisoned
>> page regardless of refcount.
> I always considered that handling quite dubious. Just because a page has
> hwpoisoned set doesn't mean that we can just offline it.
>
> I think that mus be cleaned up at some point.
>
> But not sure how to do this cleanly.
>
> Why do we even care about offlining memory with hwpoisoned pages? What
> is the use case for your change?

Considering CXL memory device and we hotplug the memory as NUMA. If the
device is disconnected, accessing the CXL memory will trigger memory-failure.

We still want to offline the memory, so that we can reonline and use the
memory again when CXL memory device is reconnected.

> I know, it's very desirable to do it, but I much rather have it not
> working then having something that is likely mostly broken and actually
> might cause harm.
>

