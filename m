Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E8441093168
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97FC96B0421; Thu, 19 Mar 2026 23:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 930936B042E; Thu, 19 Mar 2026 23:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86D7B6B0431; Thu, 19 Mar 2026 23:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 757686B0421
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:16:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29BD1C2537
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:16:02 +0000 (UTC)
X-FDA: 84564977364.13.C8A8980
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf16.hostedemail.com (Postfix) with ESMTP id DB5CA180002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:15:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=M+EY0cAh;
	spf=pass (imf16.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773976560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aw3Oy+lUPVYS4KAsAgAJdm+jNj5FDDasXgSzHivwBIA=;
	b=tdC7AnygHRLbNr71SDyE6ODO/S92rFIjm6sVKXS+9I/8th77+KGH1f8emjuQgWSO6/cedL
	KH0pkv34hSaNIP3y1XkKvUuBdTrNCOOv4jsj8HFDPMPYpAfyNBwIPBk4a5mGNv/r94ODR3
	z1cuA5rCBv3YMCfdtUbpFciOhH8tv4U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=M+EY0cAh;
	spf=pass (imf16.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773976560; a=rsa-sha256;
	cv=none;
	b=KF8dxmABba0mFVWlH3Ei8TmpGnw+O0pw4I4gjRtCwPs5nbAGOHll8pUFDo/bno2T0t2moB
	uBJgg3WY7RCnouNuxLRvaYHtAlLMaw/9LOK9hxHdcaHRXH6IfQcXdts/aK4Cmej2dAeMoL
	kpUML/hvPhrAb+XHYj7myVClbf84P1Y=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aw3Oy+lUPVYS4KAsAgAJdm+jNj5FDDasXgSzHivwBIA=;
	b=M+EY0cAhJ3MfdR7dCZuRBP96DM3abS1AWLKngCXxybUuBiOB+X1+MZupePqTnIz9oXQm5HBt/
	velh8jTC4fkvayffVudKkn3ES/DY/P89GBBf/DgTJDyUwNNP4DG3luS5QVee752b73Nwhrxbzbh
	LuoHqJYY3fl+c0LjxXKEhAI=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4fcSGm4QnLzLlSy;
	Fri, 20 Mar 2026 11:09:52 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 31C2740565;
	Fri, 20 Mar 2026 11:15:54 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 20 Mar
 2026 11:15:53 +0800
Message-ID: <5baf7fb3-5605-42ba-9360-9815c321ab59@huawei.com>
Date: Fri, 20 Mar 2026 11:15:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: fix memory offline failure due to hwpoisoned
 file hugetlb
To: Miaohe Lin <linmiaohe@huawei.com>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<akpm@linux-foundation.org>, <muchun.song@linux.dev>, <osalvador@suse.de>,
	<david@kernel.org>, <nao.horiguchi@gmail.com>, <linux-mm@kvack.org>
References: <20260318020711.3596947-1-tujinjiang@huawei.com>
 <0374ef8e-0da1-ad3c-c669-4946f5268881@huawei.com>
 <693316db-3279-48c4-ad33-b02f95a4ba9e@huawei.com>
 <209474bd-b6de-ffc2-bb48-f1e4ce000c6f@huawei.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <209474bd-b6de-ffc2-bb48-f1e4ce000c6f@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: DB5CA180002
X-Rspamd-Server: rspam07
X-Stat-Signature: 5mxthp6x6mj8x7jhne97c6zg95yaarg4
X-Rspam-User: 
X-HE-Tag: 1773976558-805840
X-HE-Meta: U2FsdGVkX19x/PFTww9NwYvHWp8/22UwDhSscnfIrlH12+gQM8qe5DtDXmQ1fk0kW0f+N9S5KE9kDCJWpUYi2AIzl+zLya0+vDYDL7rX/ZqRzSMqo1DGDJp7bBMzalhgdZtHy3A7CUpS87502oeZ/16cYyl28/JyaPcPwNqLY2VwXTVlXreUGcR7ju60T0vtHD0AL4be2KX7yTG9HxU40g/DVKN7632OySfEA5IJLAnAFDpfcW4VChzeI9s1RJkic0Ok4QF4g+cET+aBlFsJnzTSEPnsF+5Y8jIhhQub/6JNTDYVVZLrUE17t9yypYnv+ETRKdQzdSxWIHPqA5RsjPVJ5zUQ/0siigUri9igDS5rI8t4oXsWcbJRckdmVZeAep4Q+C7OT88slRh7/EZzPMi9aX+FoSrMPbKAtx0XvoTLlLCov12zGEfDCWi0vBUeN1JJrJ9vakgR6J8CBjnqoy10uAV5T5nSyOWpfoHTCfk/0uz/bGrsa8oh61iT3e1Fv2ZOYGDIeeEpB4/MUeV62IHXcVAOs2NS7xa6gxUfv5eUSibXccFMncfGmx/1OmdvIMIqbwVBvnVrv70mOqdxw9JQCGEbbpnZOCG+OM9ygUAnkq29Fg6YlAqZl6/mykAcCo4FFi6io8hcXSt8lE9fJZujgKEWswWqBNucdaDZkPmqz+9+sPv9KfFCskoqoazN91aYLVPcTIYovdTaBX29GpM7t8UYLYSpqLM7sXmN8yugRZ/qF2rwZQmReEVkhjMZu7iDHkSOdyIE0su7gSnBNU1qkvm+qF7dFuCyLvTNNfyGufM35MLeJfF4IuvQrVDShaaATrQ9teuUbBvP+l4C9MHZErU5ZoRpbJDzxIko+t7Ed7SMfBcihB7c/jHV5TQjrKRpb6c9LZp/DJvrmaJX/dmEBmOauLX9fReg1ShmdQL+6t+dVoSTndpUg4T02T3dk4qQvcrbM3D0dvWc21J
 p9irn1i3
 h0zDqxAhpbeOAnerna+aOiDIyHZdaJT07vqKJZ7jdnb0SBwWFikQk3OyjZiM6nhChtK8RxoG/HqfZu6+uEUfZXXYVBAllZEYZiWg1zc5eitpj6DNPeETxEv7IGOuZec+5tskOJObMEyWOYD9o9gQfSRMtd3I2IyHZCS4ZDprIOZrt+rbMnMCT2Op0CboRBWH0OQubdv21Ht1ks8/Q+w+E1SCd2H/YCcg6Q0u9M/TAsxgk1SeWBvpOTheb9WURuHBgOV8yZ/HL1taUak4N2yHwQfBH+YH16ojoGAa477QwtmPns+/nxJUqd7nHuH/ztH8MDv0/q7VpgBC0/YdCVZA7lQbD/a2fryiSCwx0yYk2VyAKv1HAuT83c5MoeR0Xo0qNDlyoybJTEQVPi9LMjNxelMBwbuksIAkreFYlGacEKd0R/rhHRD0oDYlDqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/3/20 11:03, Miaohe Lin 写道:
> On 2026/3/20 10:43, Jinjiang Tu wrote:
>> 在 2026/3/20 10:34, Miaohe Lin 写道:
>>> On 2026/3/18 10:07, Jinjiang Tu wrote:
>>>> When a file hugetlb folio triggers UCE, me_huge_page() will keep the
>>>> hugetlb folio in pagcahe with refcount increased and PG_hwpoison set. Even
>>>> after the hugetlb file is deleted, the hugetlb folio is still leaked.
>>>>
>>>> If we want to offline the memory block that the hwpoisoned hugetlb folio
>>>> belongs to, it fails in dissolve_free_hugetlb_folios() due to the
>>>> hwpoisoned hugetlb folio isn't free.
>>>>
>>>> I can reproduce this issue with the following steps in qemu:
>>>>    1) echo offline >/sys/devices/system/memory/auto_online_blocks
>>>>    2) in qemu monitor:
>>>>          object_add memory-backend-ram,id=mem10,size=1G
>>>>          device_add pc-dimm,id=dimm1,memdev=mem10,node=2
>>>>    3) echo online_movable > /sys/devices/system/node/node2/memory136/state
>>>>    4) echo 5 > /sys/devices/system/node/node2/hugepages/hugepages-2048kB/nr_hugepages
>>>>    5) run ./hugetlb_file. This process will receive SIGBUS.
>>>>    6) remove the hugetlbfs file.
>>>>    7) echo offline > /sys/devices/system/node/node2/memory136/state
>>>>
>>>> hugetlb_file.c:
>>>>     fd = open("/dev/hugepages/my_hugepage_file", O_CREAT | O_RDWR, 0755);
>>>>     fallocate(fd, 0, 0, HUGEPAGE_SIZE * 2);
>>>>     addr = mmap(NULL, HUGEPAGE_SIZE * 2, PROT_READ | PROT_WRITE,
>>>>          MAP_SHARED | MAP_HUGETLB, fd, 0);
>>>>     memset(addr, 0xaa, HUGEPAGE_SIZE * 2);
>>>>     madvise(addr, HUGEPAGE_SIZE, MADV_HWPOISON);
>>>>
>>>> To fix it, when deleting hugetlb folio from pagecache, mark the hugetlb
>>>> folio temporary, and put the refcount increased by memory-failure. After
>>>> the hugetlb folio is deleted from pagecache, the refcount is decreased to
>>>> zero and the hugetlb folio is dissolved.
>>> Thanks for your patch.
>>>
>>>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>>>> ---
>>>>    fs/hugetlbfs/inode.c | 5 +++++
>>>>    1 file changed, 5 insertions(+)
>>>>
>>>> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
>>>> index 3f70c47981de..6bebe2e67f3e 100644
>>>> --- a/fs/hugetlbfs/inode.c
>>>> +++ b/fs/hugetlbfs/inode.c
>>>> @@ -603,6 +603,11 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
>>>>                                index, truncate_op))
>>>>                    freed++;
>>>>    +            if (unlikely(folio_test_hwpoison(folio))) {
>>>> +                folio_set_hugetlb_temporary(folio);
>>> I think it is not needed to mark the hugetlb folio as temporary because
>>> offline_pages() will call dissolve_free_hugetlb_folios().
>> Indeed. I was intended to avoid this hugetlb allocated again, but
>> dequeue_hugetlb_folio_node_exact() will check PG_hwpoison.
>>
>>>> +                folio_put(folio);
>>> __get_huge_page_for_hwpoison() will always set hwpoison for hugetlb folio
>>> even without page refcnt increased. So this folio_put() might be unexpected.
>>> Please see [1] for detail.
>> When memory-failure races with migration, __get_huge_page_for_hwpoison()
>> will set hwpoison without page refcnt increased. In common case, ref is
>> increased before setting hwpoison.
> Right. And in those rare cases, VM_BUG_ON_PAGE(page_ref_count(page) == 0, page) will be triggered
> in folio_put().
>
> Thanks.

hwpoisoned base page is forced to offline. test_pages_isolated() and __offline_isolated_pages() just
skip the hwpoisoned pfn regardless of it's refcount.

I originally tried to force offline hwpoisoned hugetlb too, but it leads to wrong counts (i.e., HugePages_Total).

> .

