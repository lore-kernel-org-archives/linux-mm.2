Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 093CE109316E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43C8E6B0429; Thu, 19 Mar 2026 23:03:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EDDD6B042D; Thu, 19 Mar 2026 23:03:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32A716B042E; Thu, 19 Mar 2026 23:03:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21E016B0429
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:03:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC203140823
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:03:30 +0000 (UTC)
X-FDA: 84564945780.25.5599AB9
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf01.hostedemail.com (Postfix) with ESMTP id 17EB640005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:03:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BRd9A7fj;
	spf=pass (imf01.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773975808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EObcbvrVo41/3tmJNsRZYj7EDtAcf9QhF9iFM53hREo=;
	b=UsM4zeOP4Bp+5L1YKM4gTW8rVTb9Op2+2od3SY23cOjM60tjuzkB78fQJjpbeI1PAlV6Wc
	pqsVCVXlX6otHH+K1HrEiQgyHMxZe8P1vE2V6wE+eG3bVJ9IcMFiUNABlR1lrxj0T5A8T5
	2Y1uTeCTxq0co22ZTY7x00075+f4vfQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773975808; a=rsa-sha256;
	cv=none;
	b=Ulrd87iB52CKr6sMPvLc6Yqdze5gkUFvQgsAjM11KpxBhIdmhY21LcfhkLjQmG+Abwv45M
	kyeg86bLm+jI95EtyGdmxrJu6JYONVkuRPLsN9OZaCebqAg19h3L1Sjcy20BOkFpUVlwBs
	KjTsnUeoAK4hoHeT3msjcppMSaGawlU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BRd9A7fj;
	spf=pass (imf01.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=EObcbvrVo41/3tmJNsRZYj7EDtAcf9QhF9iFM53hREo=;
	b=BRd9A7fjmerLz1nXPfyPhSLZmL12DVBDcLzbyF0AvaKuz639kXcbhX99vzA5zYCgcioh2kLEy
	c58DWJLD3HupNKDPgE1WCazmaIckJhnAIEUdUemycGBZUUujw1PQIwEQVd8H0NEzhYSkag5BCgG
	VWKJKVYi3kbxLyrQFYrtKa8=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fcS1R5X9vz1prL9;
	Fri, 20 Mar 2026 10:58:19 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 9F05A4056C;
	Fri, 20 Mar 2026 11:03:22 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 20 Mar 2026 11:03:20 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 20 Mar 2026 11:03:19 +0800
Subject: Re: [PATCH] mm/hugetlb: fix memory offline failure due to hwpoisoned
 file hugetlb
To: Jinjiang Tu <tujinjiang@huawei.com>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<akpm@linux-foundation.org>, <muchun.song@linux.dev>, <osalvador@suse.de>,
	<david@kernel.org>, <nao.horiguchi@gmail.com>, <linux-mm@kvack.org>
References: <20260318020711.3596947-1-tujinjiang@huawei.com>
 <0374ef8e-0da1-ad3c-c669-4946f5268881@huawei.com>
 <693316db-3279-48c4-ad33-b02f95a4ba9e@huawei.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <209474bd-b6de-ffc2-bb48-f1e4ce000c6f@huawei.com>
Date: Fri, 20 Mar 2026 11:03:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <693316db-3279-48c4-ad33-b02f95a4ba9e@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Stat-Signature: 5z5rsf1d37ry41e1s6n5o6o8e8hwnwid
X-Rspamd-Queue-Id: 17EB640005
X-Rspamd-Server: rspam03
X-HE-Tag: 1773975806-49458
X-HE-Meta: U2FsdGVkX1+7GQExngKKcl4qTO/APrJf9d8yY5Yea8vz/EsmB1qFT3autwWAxxBICusJFtHVzkfwJvu5moy4kJvQSNdZ9TZb5ZAtv+uTbY7YtORyzaEMziQAlgvwplISRroZcdc6PLmRub/6fSQMRTZpGbxYc15Qvd/VnbnRoPbgws+Pwjf1f1nWEjXhnh2fP8n+xF+TqddGz2RsFXqV6ksjiBS8R/Omm9j81s1scPEEl/yLhI7X+f/rQHOM+Qxue8VLQ+WlmYpE55kLrxUvf3R9j/d4YTfPuMlFA6JfJjdZGRyNUWhGN07d4xomE2Q/SfZGomEWpU6Do8PH1Rr/CWowJqY1DQv5hF3cQPZQYBL6D8KPqIVlglatJXewJVn1N9hwlC+HvnRwraR81e77A6Nk1f82fRpVfJMtvFt6AQB2TU4RlG1X+kK0kkoUcyoDpUPYV+YkAiCfKCH2vZ9KQtBgQ1IGog7bK4+k5Kcc/TTZCwtq40kSjd6PlCzS3dTAX6m53E0ZLMTm/ilpqr0zIZ2o9A1F7f1CR2jLjAvKZSBbTPeynjaIdGfwubDurOkQEmDQT5gaDYgurNkvTuroMhuEeH60dLjhZRvSbYpibac1B55VyFwTSqQQY0UF0quo9pF4bBECkWMrRwOCk88HZkTC7ab+5AzBBlNC6OHHaVNX8ZjAe3keSlcOjnuk4CCJ4gVCd9QptQNnQ6kP6aDhETlcE16blKVqQN2dH6m6lFOVSvhhvCInwdFamVGWpngK6ZlTu2EENUI4Vgs33WgZhHTl/jIFZ7KBoky/fzZDDT7oenQ5h1mlSu0mbiWNviSJOMrTz38cSsCO6xcD1zPoTlqukn9/TdddkPwbq7Tidq25B3J9/r8SK4IUOczMCVukqnlbAC/lE5VP5P5hiR9Nv1DVHUyuOlu8J9x4LjFwu9geh8fWV2KQViKsvgRZRZMQLB++obOuMw1aSnN5kHD
 LUCdRqTj
 UIv4+CC7ctk+07l9+FcHXQry2IBuby1bdriDKq7i0Zj62WB8Qlij3DoOAgBjPTrmVJl9lV7ZkPQfmJDAjY2ieW4v7+BIDIIwhYgjYeNduI7924PjXMjofLiKMS1tDawJT5OH1GkWLWC5iPSEwl2HbnyWiipsf9ykWg/ocKSd7yjfxw9zwv8I00vU50RJ7bSMaQXR1adMWUXvM77FrNyR6Oj0NB2vToedNlesZQQLlSONwJbBIv3mNyyuX8qtdbx+OnXO+xjPUEuCr0yjRJmGhKfmXY36H5GywhMry0OaCLWhXfX6Yd2D1PJoDsdgUHDAlXdojb2aHlXJ+4oPhzzwu3Mew+ibP9OPv8H2golXbTCFDL6PbdSh1cIFrFwD2o3xSLm7NFe34MQpIU6iQIGGueyseHr1wlkh1+WFBSLCV5+htu38Z7zY5CvL/Gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/3/20 10:43, Jinjiang Tu wrote:
> 
> 在 2026/3/20 10:34, Miaohe Lin 写道:
>> On 2026/3/18 10:07, Jinjiang Tu wrote:
>>> When a file hugetlb folio triggers UCE, me_huge_page() will keep the
>>> hugetlb folio in pagcahe with refcount increased and PG_hwpoison set. Even
>>> after the hugetlb file is deleted, the hugetlb folio is still leaked.
>>>
>>> If we want to offline the memory block that the hwpoisoned hugetlb folio
>>> belongs to, it fails in dissolve_free_hugetlb_folios() due to the
>>> hwpoisoned hugetlb folio isn't free.
>>>
>>> I can reproduce this issue with the following steps in qemu:
>>>   1) echo offline >/sys/devices/system/memory/auto_online_blocks
>>>   2) in qemu monitor:
>>>         object_add memory-backend-ram,id=mem10,size=1G
>>>         device_add pc-dimm,id=dimm1,memdev=mem10,node=2
>>>   3) echo online_movable > /sys/devices/system/node/node2/memory136/state
>>>   4) echo 5 > /sys/devices/system/node/node2/hugepages/hugepages-2048kB/nr_hugepages
>>>   5) run ./hugetlb_file. This process will receive SIGBUS.
>>>   6) remove the hugetlbfs file.
>>>   7) echo offline > /sys/devices/system/node/node2/memory136/state
>>>
>>> hugetlb_file.c:
>>>    fd = open("/dev/hugepages/my_hugepage_file", O_CREAT | O_RDWR, 0755);
>>>    fallocate(fd, 0, 0, HUGEPAGE_SIZE * 2);
>>>    addr = mmap(NULL, HUGEPAGE_SIZE * 2, PROT_READ | PROT_WRITE,
>>>         MAP_SHARED | MAP_HUGETLB, fd, 0);
>>>    memset(addr, 0xaa, HUGEPAGE_SIZE * 2);
>>>    madvise(addr, HUGEPAGE_SIZE, MADV_HWPOISON);
>>>
>>> To fix it, when deleting hugetlb folio from pagecache, mark the hugetlb
>>> folio temporary, and put the refcount increased by memory-failure. After
>>> the hugetlb folio is deleted from pagecache, the refcount is decreased to
>>> zero and the hugetlb folio is dissolved.
>> Thanks for your patch.
>>
>>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>>> ---
>>>   fs/hugetlbfs/inode.c | 5 +++++
>>>   1 file changed, 5 insertions(+)
>>>
>>> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
>>> index 3f70c47981de..6bebe2e67f3e 100644
>>> --- a/fs/hugetlbfs/inode.c
>>> +++ b/fs/hugetlbfs/inode.c
>>> @@ -603,6 +603,11 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
>>>                               index, truncate_op))
>>>                   freed++;
>>>   +            if (unlikely(folio_test_hwpoison(folio))) {
>>> +                folio_set_hugetlb_temporary(folio);
>> I think it is not needed to mark the hugetlb folio as temporary because
>> offline_pages() will call dissolve_free_hugetlb_folios().
> 
> Indeed. I was intended to avoid this hugetlb allocated again, but
> dequeue_hugetlb_folio_node_exact() will check PG_hwpoison.
> 
>>
>>> +                folio_put(folio);
>> __get_huge_page_for_hwpoison() will always set hwpoison for hugetlb folio
>> even without page refcnt increased. So this folio_put() might be unexpected.
>> Please see [1] for detail.
> 
> When memory-failure races with migration, __get_huge_page_for_hwpoison()
> will set hwpoison without page refcnt increased. In common case, ref is
> increased before setting hwpoison.

Right. And in those rare cases, VM_BUG_ON_PAGE(page_ref_count(page) == 0, page) will be triggered
in folio_put().

Thanks.
.

