Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E34AAEA3C5E
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 13:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326D86B0005; Thu,  9 Apr 2026 09:00:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FEB86B0088; Thu,  9 Apr 2026 09:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23C086B008A; Thu,  9 Apr 2026 09:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11BCB6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:00:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9BD05E2EE0
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:00:43 +0000 (UTC)
X-FDA: 84639026766.25.086E5DE
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf05.hostedemail.com (Postfix) with ESMTP id BDD3710000D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:00:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=byvCiLOR;
	spf=pass (imf05.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=byvCiLOR;
	spf=pass (imf05.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775739641; a=rsa-sha256;
	cv=none;
	b=xVrhyftfnEtR9QpOmAoBZ2OuJXm7tS/MUQid4QxJ6fu6d+leR0GLa5kXV4cXsrgDO4gtyK
	OeX7C69K4BWCWB3TLepy12GH7n6FACO1GO6TbwpPu13AhU3Tlq2Tclx+c7jyySbBrTlXbW
	iz/9bPMbOhyPhOWgaZYIuapobLF5+r0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775739641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8K8dTYIfBr95gka4SMFnnmH0LLrhv1YdGgZUi+F6W98=;
	b=a161SQtW8+gJMhA9x52dwPZvfuY0Lrkk8YUxsmmLvGyPUgkEaRfPr2MlgC0V7AbMdKxP0h
	/TSQQk6ttZ7gMXKdId9C2f4ntcRc6jMtOopdtxlZYYiRuUTSyAaFDriHbwz5djn70PCxOz
	90cRGYizrC7BpctJUudnfHss5pP62bE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8K8dTYIfBr95gka4SMFnnmH0LLrhv1YdGgZUi+F6W98=;
	b=byvCiLORt6Rcx6RN+BTI3johy8ZtXi9h5eFA88EulocIa2qHGeV98yUyIcLfEY0H0akJyseF3
	syp95/e3v8DF6r25GGTFVBSRNq4Cx//hCVrZmGFClDZXvwb1R8ew38qT0iLLnMDO7rd2p/LqgSt
	seYoSeUZq9Os/DhKcIBbIlQ=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4fs0Hw0yzjzRhTw;
	Thu,  9 Apr 2026 20:54:20 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id DFA1440538;
	Thu,  9 Apr 2026 21:00:34 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Apr 2026 21:00:33 +0800
Message-ID: <0cc07f96-641a-43e1-b90d-641962d9459d@huawei.com>
Date: Thu, 9 Apr 2026 21:00:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] fs: drop_caches: introduce per-node drop_caches
 interface
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Michal Hocko <mhocko@suse.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Christian Brauner <brauner@kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo
 Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260409063503.3475420-1-wangkefeng.wang@huawei.com>
 <addP4MKmA8zfSN1o@tiehlicka>
 <dbb92553-58ba-42e1-b7df-b8450bd69d33@huawei.com>
 <addhuRqrB-u7oDp8@tiehlicka>
 <bdd49511-9b84-42cc-a286-9fdf2ef531a7@huawei.com>
 <adeFBKzNq9rNzbHk@tiehlicka>
 <95bc0034-a72b-449c-9be4-b691fd03dc1e@huawei.com>
Content-Language: en-US
In-Reply-To: <95bc0034-a72b-449c-9be4-b691fd03dc1e@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BDD3710000D
X-Stat-Signature: wu1g9wzouzjnu8gm9xusnsd8itfw4pe3
X-Rspam-User: 
X-HE-Tag: 1775739640-45076
X-HE-Meta: U2FsdGVkX18rWqeCi5Qwa92gbDKALtZ8VulqgnPXyFhRVRLsDSnxpf8kxwwZrngWZAK92X1ra4iCUMbx7sfYVnVLFa+Z3nTedGOm4V/hxTuXcu87gBzQBPBvX7BsgOwpijbe6c3CIRQX/RM139FAnSIQjX95a36L4qiTrRJYGsKuqvDpdnxC3wmiMv1vsaS2f2ZSCMaZB9DucU18DM1fw/N4xOFjwm0VgNPTba6z2SMioG9fBe3dOzOnC4prPzIlAVGGPoGQtZhSVnA3zDFXj+Jq+eFsHcmMzahZ/r9giciqlNL7IV+loiknXJ80pVFOhFpTBlV1rM63btHWBwqshXAgibb1jbPvw5VSkb/qRZde6ljPAVTh47q5c7SCsNcM7aisA0Dt8eNh6AuClNhcCjJtKOg3pt7j1VI286f1XioCp0kVsDEuua2QfMj5482SzJheJOrM+G8fF+hd0BYDNB0EqLlt5OZzFSDt4TXlOJFlI39mgfHTqpc1XG5dzxAl32VXl58LbqJELevXakpZOSLh+batEtSA9/EzKE8xhY5Gw4Q5PD3RcT0nPv6Mjvh3IwG6xySDNKKhhUS8GDySU9cbIUmuBE/SF35iDyUdCVzXOEpjpSSCJS7TjBvQ++a0ZydQyGwcX8bVWJ17KQKntFEN4qvGmKYiuDdrDP0DLGijteobbMjfimxXQPaSKBAwKAkp2dqi7CnvLMh2lhg7oL3dGMlKo5zd13H0Zmh6H2MYJR1uLjqGv+uS1tEIRfq65KobOfH1k24jPDfnLD9Xzk5s0nwGw2J7DTtwSEzYV6ufvEzliGekpJzjYnfZA+jPGBMP2mwgx3e45saCnZbp3Ew+7HrQRpK4DYScC3zQBXXI/shr523ItPBu7twmgvlV9q/IeJmusEP1wPJUlfRVCw1BY+jBYGnEDwT8tZ9ZH40+ocWSbK8sSjuDqwdsMlWZTfvcQjipGrud7Z5B8U6
 ZCjK3/7O
 1K9dVvyn6yfM47cBN5ABExq4qKT9QqkKveYGTIF4blhc7V8tpeggerCk/2P0XKYYkXs2D8C4XulRlm5s5F2SICH+M+u1jx3lx+RWiocucHnOMdi6z0OvmysvFAw+d0tKOlOOIAeMCswMjMw14RzicIy10EFbYME+cuSO6+w5gas2f5IMoOClk4pO+u1N+sMof9j/o1wwFfmXtC8Qaa8APu8n0gJr5KS4yWw/QqH69mF+/XMPHOcPCHFBx+f6BWFiGVwT67Vui1vFdzNxZmBJRZdu7UZPnTPc3qTO6Ecof6MnwJfVsIcj8RJ0ytW+WuDxIM/rvLpbTuWdUOBn5g+J7yTqu26rDSWpfCJKnUhbyfK99UjNFvu6Mze7M3KDsDPI1NnNMgQ0BGvcEPIY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/9/2026 8:50 PM, Kefeng Wang wrote:
> 
> 
> On 4/9/2026 6:52 PM, Michal Hocko wrote:
>> On Thu 09-04-26 16:54:48, Kefeng Wang wrote:
>>>
>>>
>>> On 4/9/2026 4:22 PM, Michal Hocko wrote:
>>>> On Thu 09-04-26 16:08:37, Kefeng Wang wrote:
>>>> [...]
>>>>> To use the reclaim interface, there are two differences,
>>>>>
>>>>> 1) we need to input the reclaim numbers and swappiness, this is not 
>>>>> a big
>>>>> problem
>>>>> 2) for reclaim, it supports swappiness=max to only reclaim 
>>>>> anonymous pages,
>>>>> but cannot only reclaim file pages,
>>>>
>>>> Why is 2) a real constrain?
>>>
>>> This should not be a restriction, but a strategy. Our product wants to
>>> migrate anonymous pages to the local instead of swapping them out. 
>>> However,
>>> the current per-node-reclaim interface does not support reclaiming 
>>> only file
>>> pages.
>>
>> Yes, I do understand that you want to keep your hot anonymous pages
>> resident on some node. Those shouldn't be reclaimed by the user space
>> triggered reclaim anyway, right? Migration will then happen during the
>> memory offlining.
> 
> Yes, that we need.
>>
>> This will certainly require some fine tuning but I do not see any reason
>> this should be completely impossible. Certainly a more robust way (from
>> API POV) than the suggested drop_caches. I am also not convinced we need
>> page-cache-only reclaim for the existing reclaim interface. I believe it
>> makes more sense to look at the reclaim from hotness POV rather than
>> anon vs. file.
> 
> It is already support only reclaim file pages when swappiness = 0 for
> memcg.reclaim, but not for per-node-reclaim, so we can just make a few
> small changes to enable it(no tested)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 84eba9ab5d25..46254ae9b8df 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2515,7 +2515,7 @@ static void get_scan_count(struct lruvec *lruvec, 
> struct scan_control *sc,
>           * using the memory controller's swap limit feature would be
>           * too expensive.
>           */
> -       if (cgroup_reclaim(sc) && !swappiness) {
> +       if ((cgroup_reclaim(sc) || sc->proactive) && !swappiness) {
>                  scan_balance = SCAN_FILE;
>                  goto out;
>          }
> 

Sorry, the changes below are incorrect，please ignore.

> or
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 84eba9ab5d25..e2998b61f78b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2515,7 +2515,7 @@ static void get_scan_count(struct lruvec *lruvec, 
> struct scan_control *sc,
>           * using the memory controller's swap limit feature would be
>           * too expensive.
>           */
> -       if (cgroup_reclaim(sc) && !swappiness) {
> +       if (sc->proactive && !swappiness) {
>                  scan_balance = SCAN_FILE;
>                  goto out;
>          }
> 
> 
> 
> 


