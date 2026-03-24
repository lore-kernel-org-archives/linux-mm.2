Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA15AF532E9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 08:00:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EA536B008A; Tue, 24 Mar 2026 04:00:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19A9A6B008C; Tue, 24 Mar 2026 04:00:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 089926B0092; Tue, 24 Mar 2026 04:00:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDAA76B008A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:00:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B799B1B9E00
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:00:54 +0000 (UTC)
X-FDA: 84580210428.24.D580370
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0E23120003
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:00:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YeF8J2EQ;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774339253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7u7VEluoINkD4QGxG9Hk8O3AYgwybG6LXtubb4PKQE=;
	b=HoRckUXihrCj6Cpqh34/U231i82dEXR6CspmoGqshOJGmtBLo6OAoEU+tdaVKcRVHLAwl+
	moCzrZobLOF5GGeRYtkm9a30WKCF09vgyo4qmYQbGbUx32gwnkYcvxd4mygY+Btc+M5qxq
	F6bHiAprtVtaiGTuhC8AoplbbQ8V0dM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YeF8J2EQ;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774339253; a=rsa-sha256;
	cv=none;
	b=xphYNyCoTDnDKimrd+ecFIw4Gd5ZJJWQLkZoUPnI1RwGOKEz1nF5vDI66Ws+yK2PIa06NV
	vF0FkXG0obSKDRvxUHhdmCzELJasfFRNmfi0wE8pzDsY1TDSRp6mQBwHukRF2Xuyn5iDfa
	7MInRBWTsEHN3mjpKP6OvQ/nd4i5qj0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 75FDD600C4;
	Tue, 24 Mar 2026 08:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE7FC2BC9E;
	Tue, 24 Mar 2026 08:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774339252;
	bh=gOnmFERNl1uVy17PSWyYQftP1AmbMAEBNmSuZwWOhnk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YeF8J2EQbBA8VCE4I7rnrj9qaEjcE96iWqZtyyUI5/NFwC9sUKUP7QdT7cBbihBiG
	 7DhMYHK4aZOjn/mSEdcsPvJ6b/23qkBemic5sCNPZk7m4ktZAFGWDJJA0rbRKyRogD
	 jPuIu1m1Cq94DBM/eB1wy5mgx/yk7glqcTeD2vYWsMVPWp29WaNxu/ATDyo4L2Tpeb
	 c+x9dUzGEdRfHdRCV92Hwb8bKzBlaA4Dk7QJ6ebaz9ifbh6X0hflivMZNAoXNsgF7H
	 a1qyyfXfIs4pMw+IX2oHsp2CgXA8w4aAzd45KbGBC94zJEAzBuXqDl2wSdeH+1g3z3
	 LsxpFxfgdndfg==
Message-ID: <49e588c7-a8f4-4671-84ed-4cff896a05b5@kernel.org>
Date: Tue, 24 Mar 2026 09:00:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/hugetlb: fix memory offline failure due to
 hwpoisoned file hugetlb
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 muchun.song@linux.dev, osalvador@suse.de, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260321021031.2240780-1-tujinjiang@huawei.com>
 <8b4092d7-bd99-4715-9a5b-471096ba29a1@kernel.org>
 <dd3c23ae-44cb-4194-a862-bb0b6e7f01a4@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <dd3c23ae-44cb-4194-a862-bb0b6e7f01a4@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0E23120003
X-Stat-Signature: en6ndcjequw15pimcz7cdscbcygy6ppc
X-Rspam-User: 
X-HE-Tag: 1774339252-719837
X-HE-Meta: U2FsdGVkX19+0QSSDXX4PJrKLVkMnGm69S6c7J1W1dNAy0RthM9sjpHDogdzinxBpJkJQ3ktKsYgJoVjg7CKxirn4t3GV8YJJiPtnqUSgKtZrauP1pF6PQhnA2PLg7eD0/bCkTvPvm5TmzIX86nWHzpOaY3ElQT6MQCPCfegyPP2PBNmWTSYuLRyFUf0EYdp7OaYesQXbX2xoUkU5MjS1RlqLc3gSRSri1VxismKyZs3HMN41UgsIg9kz8x38/YBIuIktblqkduBaZbr7KpZL3TfbLnaM8hwkhXbuDgTB14jVmfvf44t978IpUGGYU2xwgVyUw/O61aU3Y9ydm4DF0TluHmzwC684Oy4g+r5T4HFlykJRzEkbaAn/nG6hkmVJ+TK6Te9bGwLZHPnXAbyO5QiJjLibgC+1+IrexV6dcxqm+sOktTGRStRSiHqf8ZK2MHkh23yTG5rmUr4DPw422NDq5s7f0keUswvnDBHJuDaEkVKdJbVu0h+rOqKQKtEX/wTERftS+h+mVb07sVwMDtBq+ARFeU+wXZZdKtFu6qHoLTly2G8TlW1rrhBk6/uEyjwLxFVCFr3rYl7TSE1hDAcxRZssbIuWYWUkXDRXHEYrjhisCYAYTqD6qynsSUXD6bTHueclwRAL24yC4/I4DYFwJ0ojM2jtAKBOU5ZTE6rHxpWFrA0uC7gvs04pRAI6FaOx1OZMp4kXEVaf66SvJrw0an6tTpbDHtErZFQ022b3T4BrQXF21sHOULdvAMubItYxVLsUj/eAv2go58MOgrOkc2qWM5AiQJ3l178pyZXbIuX5ceUuwLnmJ61qztaNJFGrs1AMvfEl+BvoSxIuY8VEEDDJdJjHW8Zn5SSD0zEEY9q9NMAOOeII9rvy9XKYuUCrZFc5VV6ydcmW2PRHGWCC2g50CQLi3c9V6n55y09ToUNo/EgjZ+kivGKUig8rUqNBiQX1gSe6/Vy2vw
 2SxEA0R4
 5RShfp9CjhZ2kHWB7dtIRPIIcTJlHra1o6AdDDj4SHcOI4rLQLDntyPT+KIsug3mVYr6lMaHLCaIb/WswxtMlxZB/HWljrghapVEhC0ki3w2vId7wW/4bj2+nXMKIARflmKi7XIAiN8QYjMqyWZkjfjbuYGVdU0uSjwQY99Oq/OPtqIIEDxGJuTN2/EbqJkBeRYScsHH5NyCRXTc+L6NVNEYgFyt73iW38IucmmZZZT53GtUWuSi9xQhZXtHqtD+ZkOu7QgHtMr58fqyiTrA6QcUgAj2UB3K8l77mFVlx0K7oPDXRd5v5ZxdNqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/24/26 07:41, Jinjiang Tu wrote:
> 
> 在 2026/3/23 20:14, David Hildenbrand (Arm) 写道:
>> On 3/21/26 03:10, Jinjiang Tu wrote:
>>> When a file hugetlb folio triggers UCE, me_huge_page() will keep the
>>> hugetlb folio in pagcahe with refcount increased and PG_hwpoison set.
>>> Even
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
>>>   3) echo online_movable > /sys/devices/system/node/node2/memory136/
>>> state
>>>   4) echo 5 > /sys/devices/system/node/node2/hugepages/
>>> hugepages-2048kB/nr_hugepages
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
>>> To fix it, force to put ref of hwpoisoned hugetlb in memory offline, the
>>> hwpoisoned hugetlb will be freed and succeeds to be dissolved. We
>>> couldn't
>>> avoid races here, just like commit b023f46813cd ("memory-hotplug: skip
>>> HWPoisoned page when offlining pages"), which force to skip hwpoisoned
>>> page regardless of refcount.
>> I always considered that handling quite dubious. Just because a page has
>> hwpoisoned set doesn't mean that we can just offline it.
>>
>> I think that mus be cleaned up at some point.
>>
>> But not sure how to do this cleanly.
>>
>> Why do we even care about offlining memory with hwpoisoned pages? What
>> is the use case for your change?
> 
> Considering CXL memory device and we hotplug the memory as NUMA. If the
> device is disconnected, accessing the CXL memory will trigger memory-
> failure.
> 
> We still want to offline the memory, so that we can reonline and use the
> memory again when CXL memory device is reconnected.

Disconnecting a CXL device while the memory is still exposed to Linux,
and using memory-faults for protecting from that?

Oh my, that is horrible!

That's not what memory-failure handling is supposed to be used for. It's
supposed to be used for, you know "memory failure", not disconnected
devices :)

-- 
Cheers,

David

