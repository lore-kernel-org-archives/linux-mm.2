Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B55911093170
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C0466B042B; Thu, 19 Mar 2026 22:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 297FB6B042E; Thu, 19 Mar 2026 22:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D4C96B042F; Thu, 19 Mar 2026 22:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0ECD96B042B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:44:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E8631A07DA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:44:00 +0000 (UTC)
X-FDA: 84564896640.05.83751B2
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf20.hostedemail.com (Postfix) with ESMTP id C550E1C000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:43:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cAFxq934;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773974638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JsV++KViT/ePmKSbrCn+1c1HJcTHxEEO2+CwW3XExvk=;
	b=Crf2OILDSL++dVHn98ZNlaGOB4gIKm6lnz1zAiHHWbg39NcVMmWeznVLzZdkq00F/dFmlr
	9IFmm3q17T8dyddq7gB2Alis0mL2wzQunoAxiQloEye1C3GLNNYziRz+2wV8br+1hYADaj
	EHBAaGx6qShKtBx0eZ3iCsDi12270lY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773974638; a=rsa-sha256;
	cv=none;
	b=fCina5JfdQ0WTJoPe/hrTF1HuSb1obUTxci58Fv1FZL49trREZb4B0RFFD2FSyUblCrto4
	4usNWkkAezOtbsr24O2g23S5R5fewEr7miy+jwoVSJKSVI7HzN4VMbcQQ/K2UlGpSY459d
	uSZZGYMKcuSFhuBZD/GZwtj7oWQXhFE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cAFxq934;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=JsV++KViT/ePmKSbrCn+1c1HJcTHxEEO2+CwW3XExvk=;
	b=cAFxq934RE994OL3OA9doyKFy3wSmSFGLcFMdj5NuhNY3xudHO3tnON//fiZ1cPZpsctiK2sh
	yxy37ZcONF1X8fNRoXVu1dXhtlRuOz/GHQYCHZcn2OUOpP3d3wjQw2z06u7P6knAUkrZsR/her1
	2CtkyXooEs7nbPsvGQjhGgo=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4fcRZZ1Ypsz1T4gw;
	Fri, 20 Mar 2026 10:38:30 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id DA4C02012A;
	Fri, 20 Mar 2026 10:43:53 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 20 Mar
 2026 10:43:53 +0800
Message-ID: <693316db-3279-48c4-ad33-b02f95a4ba9e@huawei.com>
Date: Fri, 20 Mar 2026 10:43:52 +0800
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
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <0374ef8e-0da1-ad3c-c669-4946f5268881@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C550E1C000B
X-Stat-Signature: jutnfieffjexeps8ng6hwjx8dmkrnupy
X-Rspam-User: 
X-HE-Tag: 1773974637-520158
X-HE-Meta: U2FsdGVkX1/OwyFPq80tGfpvQhVA0HA9xbdbRCbOJtRxvHCDxNtNPdQA8y5QSLFsHoXBO5LSvPYDnLrvOjigITJ1cGSgXJ9sL9ixy+4PlfMUe91Nx2HuqFeP6k/a/4WJqP6YHF2r3svTZHouMR700qQ3oG/mIyhRUOHtvJ58W/+QFzg6t2HlZPQ2Mg5F1XaH96QxnB0joQ4F20DaMkrxRHfaH+Vxuv8VJ7r3dWZQd8IPiG/a5enyGLwnX+faYGdBeR+B5G+ILL5WN/5JUXbiOU89M59Uxpf58OMiRxfnfHvK3SQt71bo8OwJuahyAAWOhVbtneSWXLUI+wTlnP2oLuqcAmzgZje6xBWide/TN/fgFFjR3oQHzD0/CyfCcBjIOV5YgNw/sRJ+D/5zG7NC3YgAMjv6NU9PTUR4dNQAzPH+dXVfSPam+9lgLvt+BhV1Nwy4DfzAtW2bAqELk0Ogmqr9Cv0NJDDuqm7dYy7GmR/65EDD5X5TUck5ZrWEavSL5IZBOHKNhwxiw2ZkgpnytKdA60fAej+yo9c2gYQWXvz7jdcwdtC8W1pX88zteUlNC84TEqXQis60eQuaIQCknPzSpVdxSqZsFMJcSvs1ZsvtS2Ta6fLd81muh2nM9fwjB9AfZeaL0XSXNoVVUVmS5B92OB03FQB+8eU+TGg3DAnYAVzdUH6XiqgRlHl/Jmv+MkaaiwweSNKrG3jVvxvHwbjrQpINOKn7iUVs0Y9qw9D7xS2KxuXxsNp8VxBYKl5uTRYUT3qeBiG2KSauCl9JMawjZqQqo3/1z1Dt679vp7T0VePOEUuqmtsAlaAO44+nWJhG2S8lGr9UfXF481WVt36SmtLJaqnx/vOlMPjcfGgR3YnyNATTdfiYGwJuQ0df1afegOvPXL+BONHL/a225m0QmKs91lLntY2H1Rf3ZMcz5nWdcrQLpS2SRlvRjGyAqd2hSN6gc4xzSJVfNLP
 m6DCIAOK
 JM6Z3h2BheRpuDPlZIcTHPRUtn3MhSa9FuqiXfEU5t8ibhaw7PX0Blk0J6xOHCeKM3Vm1+D+/b0Bia4yKrjg0p2nzTzZMBBLKWqMjiclqH7TZw4B21emauMUhGIYs4NBhrf+e1g7Kb48P+r88olztZLB24Mw+Fj6Y31cryj4Up9sY9G8KRHSceUtMZNT6iDFq1A3h4vBqspk5LPN3l/SwVqALuVNvhhf6RRvW/ZorlSl1KNrRoduxqepMpsnfkmlvKEMPvTvzjVIyaUMr6BJCI4nwTQYgi/J6yJL+P+K3W34lBlq1eRSvlxBLYsFkR+bfxulQRcKlqf2oS2drUoCtU7k11loNmb3C+AzwwW4rt736RCc7eOFpkSDfQCvHwbha/j36gD+oEc0o7dp8kvrSSGvBuSd7MZTncO0CunyaW0LQo4jb3i9wjKaFlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/3/20 10:34, Miaohe Lin 写道:
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
>> To fix it, when deleting hugetlb folio from pagecache, mark the hugetlb
>> folio temporary, and put the refcount increased by memory-failure. After
>> the hugetlb folio is deleted from pagecache, the refcount is decreased to
>> zero and the hugetlb folio is dissolved.
> Thanks for your patch.
>
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> ---
>>   fs/hugetlbfs/inode.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
>> index 3f70c47981de..6bebe2e67f3e 100644
>> --- a/fs/hugetlbfs/inode.c
>> +++ b/fs/hugetlbfs/inode.c
>> @@ -603,6 +603,11 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
>>   							index, truncate_op))
>>   				freed++;
>>   
>> +			if (unlikely(folio_test_hwpoison(folio))) {
>> +				folio_set_hugetlb_temporary(folio);
> I think it is not needed to mark the hugetlb folio as temporary because
> offline_pages() will call dissolve_free_hugetlb_folios().

Indeed. I was intended to avoid this hugetlb allocated again, but
dequeue_hugetlb_folio_node_exact() will check PG_hwpoison.

>
>> +				folio_put(folio);
> __get_huge_page_for_hwpoison() will always set hwpoison for hugetlb folio
> even without page refcnt increased. So this folio_put() might be unexpected.
> Please see [1] for detail.

When memory-failure races with migration, __get_huge_page_for_hwpoison()
will set hwpoison without page refcnt increased. In common case, ref is
increased before setting hwpoison.

> Thanks.
> .

