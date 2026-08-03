Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CF5DC55175
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 07:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C51236B00A4; Mon,  3 Aug 2026 03:16:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C01F76B00A5; Mon,  3 Aug 2026 03:16:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3EBB6B00A6; Mon,  3 Aug 2026 03:16:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 965846B00A4
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:16:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20C1F120462
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:16:15 +0000 (UTC)
X-FDA: 85059099510.18.841C09B
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8B81E4000E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:16:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pk3T118R;
	spf=pass (imf17.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785741373;
	b=eBfGs0hvmtnTAZaer4V9eioVHdu5ML0bJoSSM9vRVFFzKMuCJWnmj5myy9t0gsM25tDrIU
	CxosQgzgiWaTx7SMFlA79jk5eVvel4GL5DvGwVTENShI/bMfTu+Zzm4wN4KsDjfVYFUm3p
	+WtBYnJ122AotiotELZFJ96vTH/yrP0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pk3T118R;
	spf=pass (imf17.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785741373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dnw6NXnk8kwvNdo93WmVYhkyxHlgOe+nTgmTwSoBbA0=;
	b=xIcEkKruSdI99rWs2wpVb+8ttA3CTJ+S4hFkZu46UEeqbOuJxyrGovWVcnDhyYEOoG6DBV
	3O9aGKQBTTVHOvKd42jJdr6SqVkpMQpdVfgYnP0EUExh94tM8AH+ejRMypSNR7MRFwRdTr
	XVwrc6Oo4ju3uKo60DEW7ft+RJw5gDA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Dnw6NXnk8kwvNdo93WmVYhkyxHlgOe+nTgmTwSoBbA0=;
	b=pk3T118R/N20RkVgzptuQsU4dRxKrumW4ZfmyC+goiTs1lYHKS6TxU524NPqGLdT2dvfZce2Q
	2B7Bk6kr16aPvTvIgWJ6mPvT9ujUaMKg1IFCgniKP9oVjKqIXoeJgDtkdxG78G4NLEdIIvLKdKu
	E89KFLrJXoW3DEMYgfKSc6E=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hD7526HkGzLlX5;
	Mon,  3 Aug 2026 15:06:30 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id E350A4055B;
	Mon,  3 Aug 2026 15:16:00 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 3 Aug
 2026 15:15:59 +0800
Message-ID: <fe724e58-f525-4eee-9471-d1765f6bdb0e@huawei.com>
Date: Mon, 3 Aug 2026 15:15:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] docs: ksm: fix typos in sysfs knob names
To: "David Hildenbrand (Arm)" <david@kernel.org>, <akpm@linux-foundation.org>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <ljs@kernel.org>,
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <shr@devkernel.io>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260731083526.3953421-1-tujinjiang@huawei.com>
 <20260731083526.3953421-2-tujinjiang@huawei.com>
 <d9236dc0-3332-4fab-aa26-e74d10ad0cda@kernel.org>
 <f1f5c486-f14c-44ad-8285-a9df437f7974@huawei.com>
 <3066dc07-31b5-48ca-b14e-51b284bbb9e1@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <3066dc07-31b5-48ca-b14e-51b284bbb9e1@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8B81E4000E
X-Stat-Signature: y5b8b19tduyy8h15uwn5hregaqx37mbk
X-Rspam-User: 
X-HE-Tag: 1785741370-568096
X-HE-Meta: U2FsdGVkX1+ENUdufvebrbOJ8yisw5UVDMjgr884edImCh4ieNgDesNfb5UUoLRoCpDkCP+QniZn3h6Cyq1QXuwNdU1LqOBJvmfZuPCkkaAGx+9QFcbh4bneCiymmRI1ZS0QjJXHHcZxjkpSMzew7KG/YvJsOM5CIfyagvx9RnCypuO/9u9+9RfkwBFWD2SVTKRuQsUeMAYgnb5maD8UJrxk3JDKnukaU4CkLNIcqhZSJnD4mpVTIM4d+yO88HxEHWtjeDdQ1wdfMnADGXt4Ux06qPi3dcoUUxXiyiQfCykOj52FoK/A9NzamUYfVO3yWP6dSU0xfIWq/5odGrK9k6JeR0V2fj2XwPLQDaJxcQ4gIuYWqdJUNQ2xHTnOQ7MmQ0V42jRriVRztEOUizuPXwtNuaUz8x7yj2fKnoJ5X3LuRrPv/qwnmnS8gt28L9GI+5gML2P7j43rI6a3s4YSWj0m3A5JbUnDhvAgnIOEHrEP2EX+w0qkOsCSpXEafErIHU+lQpLd62gUNgnT3TOYnAZ6es94XSnQ38JedisfmOVsiM8nafRkBxE1ljRxf5qp2qkKmG08RQLEYJEcIKurPG+Tc02d9t3kDmyStNXjf9aOn3ApNP5OBrawhuRsUY1HL3bw4B37B+pehPTISLi543+k59MfWX4rbGCIT0YiSVTESK7vmTzHZOJvvhZU6p1rTAhEMRm9tOgzpIJYc/7KVBzx7Y0rM1WUB6vZTCdLvQDRWxF3adfy6x/gWIBK01eDQKuVCTBeYQ7oszktWdkCs2JRS20UhMFum41u3cttTvu2BEd/bqqcC7U3Z40yJAMzxBsQAUJcWy55bq7QlFbcHStcver3sBTvroFvUwoNgx3qUSveO7QDh9MnbNGE7NhXnW71/gFGVO1OeKnY+egzQb0WEh5R979mdznnSNY+AfOjrp01Z2zz70YgBwWn9BcbFb8dzpAT7o3niYW9DXz
 8bCGlBfl
 b7Wm6GcFbDb3A+sd/SY4mBsPEBveY0UjdXwLRypmc9nIp3NP0yRj4E+cV6QVCuGRYTxOQbPb2U+0ds1weYvF36oDMdLa+2l94FbqpvdXSZXFvB/umUcEx5NoP0Zz4H+bZ7jsFPtcpKEQImlkUoSNeUl0JRhJvXPDBjMUZjVtmI7TwEzth1zGz+hhbpSuR5Y7u3oYcQDpgKFxmeLO5T38m80I+DJVqIZyzvmsVcEIfUYZbMMlYW5LguPoXKLFCv6CkYSdfn5HAgwVRaUPUTQFiPoQpRZQXtSk+UdQ0b3tY0aHXMiZSaQjINWdnKNQCXCeXnbTYpvzNHXTbX+wr98IgUsJsUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/7/31 17:25, David Hildenbrand (Arm) 写道:
> On 7/31/26 11:22, Jinjiang Tu wrote:
>> 在 2026/7/31 17:11, David Hildenbrand (Arm) 写道:
>>> On 7/31/26 10:35, Jinjiang Tu wrote:
>>>> The sysfs knob names in mm/ksm.c are "advisor_max_cpu" and
>>>> "advisor_max_pages_to_scan", but the ksm.rst documentation spelled
>>>> both as "adivsor_*", fix the two typos.
>>>>
>>>> Fixes: 0710f38ad26a ("mm/ksm: document ksm advisor and its sysfs knobs")
>>> I'm not sure on fixes tags for documentation stuff.
>> git log --grep "Fixes" Documentation/
>>
>> Many commits in Documentation have fix tag.
>> I think both are ok, since documentation changes are needed to backport.
> What? When? How? Where?
>
> :)

These commits only modify Documentation/ files and contains fix tags.

0c13ed77dd2b Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race
0beba407d458 Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
d7f00084f686 Docs/admin-guide/mm/damn/lru_sort: fix intervals autotune parameter name
652e1a51465f mm: fix docs for the kernel parameter ``thp_anon=``
14e70e4660d6 Docs/admin-guide/mm/damon/usage: fix wrong schemes effective quota update command
da2a06188888 Docs/admin-guide/mm/damon/usage: fix wrong example of DAMOS filter matching sysfs file
1beb8ae302a0 Docs/admin-guide/mm/zswap: remove zsmalloc's lack of writeback warning
0ff11f103f5d Docs/admin-guide/mm/damon: rename the title of the document
465d0eb0dc31 Docs/admin-guide/mm/damon/usage: fix the example code snip
205498012513 Docs/admin-guide/damon/reclaim: remove a paragraph that been obsolete due to online tuning support
dd21bfa425c0 proc: fix documentation and description of pagemap
a8db400f997c memory-hotplug.rst: fix wrong /sys/module/memory_hotplug/parameters/ path
d83fe3c99d27 memory-hotplug.rst: fix two instances of "movablecore" that should be "movable_node"
72a3e3e25a51 docs: hugetlbpage.rst: fix some warnings
8867f6109b84 docs: fix numaperf.rst and add it to the doc tree


But there are also commits don't contain fix tags. Such as:

abdca14655fe Docs/admin-guide/mm/damon: fix 'parametrs' typo
78a00cac1e96 docs: fix 're-use' -> 'reuse' in documentation
eb14b12c8c22 Docs/admin-guide/mm/damon/usage: fix and add missing DAMOS filter sysfs files on files hierarchy
472098f23323 docs: mm: fix the incorrect 'FileHugeMapped' field

>

