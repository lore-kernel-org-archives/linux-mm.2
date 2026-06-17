Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F4EECD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 07:33:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E771D6B0005; Wed, 17 Jun 2026 03:33:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E20EE6B0088; Wed, 17 Jun 2026 03:33:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38476B008A; Wed, 17 Jun 2026 03:33:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A898E6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:33:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30C3E403A2
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:33:09 +0000 (UTC)
X-FDA: 84888588498.26.5619226
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf25.hostedemail.com (Postfix) with ESMTP id 524DDA0006
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:33:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4PvViPGF;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781681587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MU8cLNW4cs3+j2eOxJiKF6ANHGeeIXo1iPWKsVafUj0=;
	b=U/5jy+0AeO8X7oZ7Lf1buVNl6KHIGrLHWXBov/9Hp/oUPVmV6mVKVnCNcl8bA73d8PVB27
	r49zcu004SjZeSDlVW38kYQfnuDtI/IU30hCk9eftFQ2XrEkHRDdS94EDJ5qpzMgUprnIv
	kh64hJMTMxb4jxSBgdrYzTHoQ2nGo9g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4PvViPGF;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781681587;
	b=rVefjWVtsLplU9YW2/At5Gr7o1Wngvb7ftrfZyupE4bQa2uYcChvhO8TfxQAhGk1aHDTsP
	ldfDcR6/+bV6PL1DT5CHKDvPiWGCjfdnK5J6Q8vpRUwLypX3BfNbC8fjH9W7KxajxFSuqP
	w+5ya01l0iJeB5dbPDJzIQ7tsimW8xE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=MU8cLNW4cs3+j2eOxJiKF6ANHGeeIXo1iPWKsVafUj0=;
	b=4PvViPGFBMXqKLhx5j6wvRohmp2ncVACO9EumK5IolLjCPHRUP8h3CVM4jdHfmb9IOLx0s+CH
	GHhiwVvqqtqbl9MfC1PYW3n9gK0letrx3B8YENNVd16HAnKmuxZ1sCd/oO9d5zCWAapstD6CqDh
	uA6c4ztoPwHWpzRLwl7Geig=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4ggFk924s3z1cypL;
	Wed, 17 Jun 2026 15:25:05 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 89B11405D1;
	Wed, 17 Jun 2026 15:33:02 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 17 Jun
 2026 15:33:01 +0800
Message-ID: <7fa4b268-5c5b-4a69-ba47-40246ff933e0@huawei.com>
Date: Wed, 17 Jun 2026 15:33:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: khugepaged: free xarray nodes left behind by failed
 collapse_file()
To: Matthew Wilcox <willy@infradead.org>
CC: Rik van Riel <riel@surriel.com>, <ziy@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <kernel-team@meta.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Hugh Dickins <hughd@kernel.org>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, Nico
 Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
	<dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, <linux-mm@kvack.org>
References: <20260616145413.1491961-1-riel@surriel.com>
 <ajFrxhGf7loEHUeX@casper.infradead.org>
 <8a4caadc-f414-4874-97d4-2fbaebe2af39@huawei.com>
 <ajID7ZpnBYOucAVz@casper.infradead.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <ajID7ZpnBYOucAVz@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: 524DDA0006
X-Rspam-User: 
X-Stat-Signature: aeauk1qrwnf6fkp5qpydbbfcwm8htk4h
X-Rspamd-Server: rspam09
X-HE-Tag: 1781681586-950399
X-HE-Meta: U2FsdGVkX19AAPmy0/jwAQBNkL0E0DwJLnk2Npd+gadMsyqHRlqC4cBW2hSYP7fj6hvgva1mAiiBoDJ9P803VsfULfdeyAVS87BG1FtwgG/p3sDoFESDHoAWXbbfFWRJCFtnnvFzeF3ZTfEh/qoo3fFxKhG00y4ay1NTvy+EWi9PfVyYNWmg54IxJFmvMiNAJQtokZ/MDixpY+Zf8fcbNzm1yZK21Yi83yY0IJioze8RRTOTXMsD3n5R2f7QbosBq1nyQgcOrjLDXwiHM4fjx8NoyfZkPyoRNDbe9TQNZwk2nAuaZsc+wlW4UiVG0KxvRB9nGhFRqi0WvxjMHq6KTy7OKfi+SrVJ6+QQ0AVt2A0p7Tfs45hH4QXDf4RlqMINOE6D7oqfmaqL5O0EcxlI1wEcsgWRMp558My6+rbG1hMgW95wkEfmP0XMd0/96ijTovrcZ0QJ9ZVyMH0A3A6wreQ9/OFsLTstsg5MXRwQLQ1MlEwXF7RgUp9dyE711yHuFrK70jtlpLvCfpIUwhW998e3/sv2KRtclFj2t8kR1Nm1qVo/6f32aZ6dAhwT7GT1IWWBuNZuLGmbs+Ds6G9hKxJp7ai5VhEIxWFKwwkCE2K4QDyrAV61lKY0u7/+ZbJu2KCkQmthdQoA76+pCGCIUbMg+K8CvHHW5GSzeyPCGxMOqYAZOjfFERWnP+QIvT3WDQbJe3/Ou6oOjfWPTftflZzXVpVlqu9mF23U3aSfg2ooFyqLPtoVkTO2fjcQzvTVNhGOguQNdxeMYGDn+yBhI+nwxwkaZon6tWZwT3S5md3RUkUCZgetVZzVM+Cua+vGhpIiVnxUrtN2thVCbVNMbByKAYLnpniqh6C964s4MNErIv6mS8Df1mg49Qqx8Op9nGqaof/YVblfyrQeV5T3abqMFS9PLMTU8sQNOQcqfCqfF0pDN27Ad4k+ok2er3rfPxJhpzyYcl/fQDLvZh7
 rKNgAlek
 i0o1sKs6aEFqyI4jn1nCF3MMGC9d+TpaBPJNremaqbrfXyOoRcdS1E7rRSAEw7kcbsDCst2TCiAGyCwJtiq4YkyouZMaq4KpoaHNt0x3F72/1DKvpGYbMNoh19CgWNrHudviIOmUyDFLorU2NnakSKJ4OmQpv6aLtI+9/gChNhMElEfUtglMDF++uQwf6ATF4kH1lmWVaQpYX9vC8npRd4BNq46BNhPdUsaoZ8KsrcpEkUWFxLBTeSQE93J61uJf3qkKNLjdwGsQDbJXQXv0hg7z5TUVrbLJXF6h5eOJiwzxu8jwVAJ4NsMwbh7SCYjPVySeA9G4OKjzzRg1jwzuCUj/Gvl46KY+cJWSnZ9buXrQSsIiQo7aWLYsn/7KvjCP/sWYa6ATBOAQ8fyM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/6/17 10:18, Matthew Wilcox 写道:
> On Wed, Jun 17, 2026 at 10:00:59AM +0800, Jinjiang Tu wrote:
>> 在 2026/6/16 23:29, Matthew Wilcox 写道:
>>> On Tue, Jun 16, 2026 at 10:54:13AM -0400, Rik van Riel wrote:
>>>> syzkaller reproduces it trivially with MADV_COLLAPSE on a sparse shmem
>>>> mapping (collapse aborts with SCAN_TRUNCATED because the range is empty),
>>>> and also via slab fault injection, which forces xas_create_range() down
>>>> the xas_nomem() path before the same abort.  kmemleak then reports the
>>>> 576-byte struct xa_node objects allocated in xas_alloc()/xas_nomem().
>>> I think the ways to produce this problem are sufficiently rare/unlikely
>> I can reproduce it easily with following steps. [1]
>> 1) create file /tmp/test_madvise_collapse and ftruncate to 4MB size, and
>> then mmap the file
>> 2) memset for the first 2MB
>> 3) madvise(MADV_COLLAPSE) for the second 2MB
>> 4) unlink the file
> Yes, but is there a problem?  That is, do we need to clear this up
> before we get to clear_inode()?

A user cannot exhaust memory by continuously creating xa_node structures. So
it is enough to free empty  xa_nodes in clear_inode().

We shouldn't free empty xa_nodes in collapse_file() rollback path, because we
couldn't avoid a concurrent call of collapse_file(), which creates xa_nodes
for the same region and may use these nodes.


