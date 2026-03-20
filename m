Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E22201093170
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59C506B041F; Thu, 19 Mar 2026 22:37:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D346B0421; Thu, 19 Mar 2026 22:37:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 462F66B0425; Thu, 19 Mar 2026 22:37:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 374806B041F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:37:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F1E221407D0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:37:50 +0000 (UTC)
X-FDA: 84564881100.04.2234DFE
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf15.hostedemail.com (Postfix) with ESMTP id 83F88A0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:37:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=6HaNDa7R;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773974269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tLcE4PEVNw3coDhaVjd8MvjBLXVdiuTUjCI49uSmTVs=;
	b=ZoWOjVV68xlxSCT7ykHBbxc3pWukwIY9XLE5eprG2YDeVyHYL/K1UKM7RbuVmJkYqjHKkN
	xiXr9Uisb1QO/2Y+PJaj8CLAoXC99mnrODzlT83NGzsyKrm8omLmApHr9+OzrccN5OVz2N
	G4lp4jq4RFeY+WZVVQphCed7vCNIb5E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=6HaNDa7R;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773974269; a=rsa-sha256;
	cv=none;
	b=WXmj4+7st8dBCBSCyN65cBzJsdbjpfUm5qZAg9xqCLO2PWsf2cv/tphcM0za5gerJjZHKv
	ZjPkaEDQK7YeF72ZZEnyJ/fNftyo7BkALJGSTiZfWcztiCKHldhCMAR7AVGz7nAVdGvAKu
	NcRDKYR7ei5fNT19IaY1ZB5ENNYB+/s=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=tLcE4PEVNw3coDhaVjd8MvjBLXVdiuTUjCI49uSmTVs=;
	b=6HaNDa7RtROPSfMEwZ/FWcwrc83A1T1E/3ECqVWJ2DsWfaenW2UJ+KvIiJ+ng5IDrac9bv5WI
	4Nem6HWFl7a8x6eDvhv2geX0e2mG6NkTTrTOx7y48nJedEstjJZEvAz6jkayVSOrqT0hZXnaruD
	bHPxkS7zfstJRWCXdi6AH0E=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4fcRRL0HhHz12LDC;
	Fri, 20 Mar 2026 10:32:14 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 6F61740567;
	Fri, 20 Mar 2026 10:37:44 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 20 Mar 2026 10:37:44 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 20 Mar 2026 10:37:43 +0800
Subject: Re: [PATCH] mm/hugetlb: fix memory offline failure due to hwpoisoned
 file hugetlb
From: Miaohe Lin <linmiaohe@huawei.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<akpm@linux-foundation.org>, <muchun.song@linux.dev>, <osalvador@suse.de>,
	<david@kernel.org>, <nao.horiguchi@gmail.com>, <linux-mm@kvack.org>
References: <20260318020711.3596947-1-tujinjiang@huawei.com>
 <0374ef8e-0da1-ad3c-c669-4946f5268881@huawei.com>
Message-ID: <b8bc5933-74d7-6b40-f58c-99ace8e10103@huawei.com>
Date: Fri, 20 Mar 2026 10:37:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <0374ef8e-0da1-ad3c-c669-4946f5268881@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 83F88A0005
X-Stat-Signature: djjjyctxa5jki5ie48zsmjdzts3wrtz6
X-Rspam-User: 
X-HE-Tag: 1773974268-88322
X-HE-Meta: U2FsdGVkX18HI+0eNVxhWspeba8ftWqpqLegV+iNFAQTuRzaE4jxUd8EhBu0x7RTHDWmsPcmTGSS7z1xBKU6rVYLo9Xg8VBrR80hmk2bIKEXLV6CyxD5FpYq0Sbw1Oi4GwvMS11gNW57pAaKJwUtDQDIb/NPctzD+4TBNp5/lce+ub4KaZmtHJVaZqOypEjrph1u9MUxURXwepe8Wg2pSJ0Scs9vNZ4W/PKdzIxEaszSE/i1OoRBbl1GMCM45BeOc2/E17Y6vQxSG1Np5sWsWGcA4EIVacWsb9fsa9tg/Nd1RmvFKwtYZWVYGlRc3exmAL3xubVn9jQ6y3Acmjfym+iCM6DwWH/iEZJKQewghriSO2Q41Z0rhG31WIFMxd8K14JhBosW3e1Zf9pJn4rDpUGw8xVQyc6Btm2wuBINsRL29Hh/AYYNGdWL22SDVfGzpmePPFQZvnnw4Gd+TGaBYD+w/RamDQD6TUfs7zXjj/P8HLMRsDaqHNUnAB3bmf53NvY3gIsoQE8pS3FfoDsS2xen0kKes8s/b7/HeZUZvcsZtakzCOVwTqDlP7LnZI1L1e2iTMCJWL+8saxVlJMECBcxtrINOKXII9XKVY+fKsTVjmgfjy7AAFxeIJRWw48j2ypxt6Z+3tA13TtBiiaK8c2qE93xw2RbXRQBUMEoZ8KQh+fTYJBYhzAiopL6TfoKyPjHZ/O7lxkHQdzwKLK2wV/oG/+MEH/jZRVzomzLUyjp9oLRsgwd7Z+BBPW1ubpukieK36jhdxWgvblGJjNNwq8FzOWWM2mNSYhtCUo8Zf/4lQ2Z0KZQNbcgEP915QFFcfYMsa2Vi3wA6bVGYT/JcA4NJQBweaoHn3fMOcYpY9mS/5h1WG5GHfueYFdmSITZUrzJ/5q6PZwlV4Xo2FQrfT1sks1L6sScztKmpeDc+WOPj0WCVSGqrK6wkIwRJRNgX3hLb6bsMrav1nzYaqS
 ALYghbsh
 E+eZ6XgwIbUC00AmCCjB3FLG1tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/3/20 10:34, Miaohe Lin wrote:
> On 2026/3/18 10:07, Jinjiang Tu wrote:
>> When a file hugetlb folio triggers UCE, me_huge_page() will keep the
>> hugetlb folio in pagcahe with refcount increased and PG_hwpoison set. Even
>> after the hugetlb file is deleted, the hugetlb folio is still leaked.
>>
>> If we want to offline the memory block that the hwpoisoned hugetlb folio
>> belongs to, it fails in dissolve_free_hugetlb_folios() due to the
>> hwpoisoned hugetlb folio isn't free.
>>
>> I can reproduce this issue with the following steps in qemu:
>>  1) echo offline >/sys/devices/system/memory/auto_online_blocks
>>  2) in qemu monitor:
>>        object_add memory-backend-ram,id=mem10,size=1G
>>        device_add pc-dimm,id=dimm1,memdev=mem10,node=2
>>  3) echo online_movable > /sys/devices/system/node/node2/memory136/state
>>  4) echo 5 > /sys/devices/system/node/node2/hugepages/hugepages-2048kB/nr_hugepages
>>  5) run ./hugetlb_file. This process will receive SIGBUS.
>>  6) remove the hugetlbfs file.
>>  7) echo offline > /sys/devices/system/node/node2/memory136/state
>>
>> hugetlb_file.c:
>>   fd = open("/dev/hugepages/my_hugepage_file", O_CREAT | O_RDWR, 0755);
>>   fallocate(fd, 0, 0, HUGEPAGE_SIZE * 2);
>>   addr = mmap(NULL, HUGEPAGE_SIZE * 2, PROT_READ | PROT_WRITE,
>> 		MAP_SHARED | MAP_HUGETLB, fd, 0);
>>   memset(addr, 0xaa, HUGEPAGE_SIZE * 2);
>>   madvise(addr, HUGEPAGE_SIZE, MADV_HWPOISON);
>>
>> To fix it, when deleting hugetlb folio from pagecache, mark the hugetlb
>> folio temporary, and put the refcount increased by memory-failure. After
>> the hugetlb folio is deleted from pagecache, the refcount is decreased to
>> zero and the hugetlb folio is dissolved.
> 
> Thanks for your patch.
> 
>>
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> ---
>>  fs/hugetlbfs/inode.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
>> index 3f70c47981de..6bebe2e67f3e 100644
>> --- a/fs/hugetlbfs/inode.c
>> +++ b/fs/hugetlbfs/inode.c
>> @@ -603,6 +603,11 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
>>  							index, truncate_op))
>>  				freed++;
>>  
>> +			if (unlikely(folio_test_hwpoison(folio))) {
>> +				folio_set_hugetlb_temporary(folio);
> 
> I think it is not needed to mark the hugetlb folio as temporary because
> offline_pages() will call dissolve_free_hugetlb_folios().
> 
>> +				folio_put(folio);
> 
> __get_huge_page_for_hwpoison() will always set hwpoison for hugetlb folio
> even without page refcnt increased. So this folio_put() might be unexpected.
> Please see [1] for detail.

Sorry, I forgot to put the link.

[1] https://lore.kernel.org/all/a3ff8c7b-69c1-fecc-3564-ecaa3e8a7e67@huawei.com/

> 
> Thanks.
> .
> 


