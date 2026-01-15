Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57C8AD3CC92
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 00:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A539D6B0005; Wed, 14 Jan 2026 19:53:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6816B0089; Wed, 14 Jan 2026 19:53:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E2FB6B008A; Wed, 14 Jan 2026 19:53:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9AF6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:53:05 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19A1AB6514
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 00:53:05 +0000 (UTC)
X-FDA: 84332373930.14.9A2F2FD
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 944F2100009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 00:52:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768438383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Z9TTCdEGcAz3/MMv5gcSG5giGOZ78QNNfGsG4RLadc=;
	b=TAa1vhMynNRB10fc5UNgguKDVgpR01AmjrpJ1TVQe1H2ikxzKvXZkCaZ+Z9V+lZXnMamk6
	EthEo2TBuK1ZpKMuWWirggEwZ5g6s/03RDa0Q8E71Dlw0DcSB1Z7UcKpjK0n0jRVZwaDvG
	cROxAQ/MU2hNYvqLco3e/LCaVjgXr/0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768438383; a=rsa-sha256;
	cv=none;
	b=TaGSF9a1QJqvsa1OLd3yZ0FlAUojSsZoalOx/Udg6RpAwjj24bAfSI94qx6DW8bdeb9xBP
	IdWepKTT83H1S9U+kAcvAkMvDhUDF9g1tk4zP5POkptTSxgbktW3+vt9FJeIAOmPDmWb54
	9rxEvlT6Vg0FJ6D8+XSmUjtc/nxBh3w=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ds4FC6jxRzKHMdL
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 08:51:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BCA634056E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 08:52:52 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgBH9vZjOmhpd_JZDw--.10605S2;
	Thu, 15 Jan 2026 08:52:52 +0800 (CST)
Message-ID: <2e8bf48a-b819-40b9-bb9b-f6ac6672059a@huaweicloud.com>
Date: Thu, 15 Jan 2026 08:52:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] cgroup: use nodes_and() output where appropriate
To: Waiman Long <llong@redhat.com>, Yury Norov <ynorov@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>, Byungchul Park <byungchul@sk.com>,
 David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>,
 Johannes Weiner <hannes@cmpxchg.org>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Brost <matthew.brost@intel.com>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Rakie Kim <rakie.kim@sk.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, Ying Huang <ying.huang@linux.alibaba.com>,
 Zi Yan <ziy@nvidia.com>, cgroups@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260114172217.861204-1-ynorov@nvidia.com>
 <20260114172217.861204-4-ynorov@nvidia.com>
 <51675d7c-5c9d-4596-8e5c-692c90b79e06@redhat.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <51675d7c-5c9d-4596-8e5c-692c90b79e06@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBH9vZjOmhpd_JZDw--.10605S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF45KFyxArWkKFykGw4xCrg_yoW8tFy8pF
	1kCry7Gay5AF1xGrWxXFyDW3s5Ja18Ja1UJr1UAF93JFnrJr10vF1UX34YgrWDCrW8Gr15
	Jrn0vw1IvFy3Jr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 944F2100009
X-Stat-Signature: ir8p6kb5udiywnhnhxj9oh7m8psk87uz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768438379-368820
X-HE-Meta: U2FsdGVkX1+YoIRylinkyw4XUCTX4D47UtgwJy0Ik2lJEmjnEnYICI+LO2MdfbBPfwpTe5BDqEKcZJnijCp0PKHHouzkiS/lwFGJvmS1+qP+5SucFOTOrVJHWNDYJsLqCHvpcoeQuYEg2uxs5uurqrRu5BKfRs4XjdsUfxCI4wTDkaKiW5baD1uJ4bJ/hVuFld1Y3C6/IAiZZxCQ7J3WtZtmJv+I079ygQOOH5Y8GPoiG2NQ9I0uid+NgXB6cyRey3mfbWrRL6kwnpR0gU4IECBEJTSTWmLx3qetD0VY1pxOZiD1j0I2P7xKsu7Z9gfsob0EKFgK0aB9WyRgeXygFZ6KJcz/LAA2xuksQVsNGK81GZ6Tr8ZRpGRbSyimsL+d4BAbLWe73rP9YjL5pz8wTXySxjy2rMcBwQezL7EY9z1l0jUUkxH5cWbQxE6ToC7FFbFM55kUEb717i+EnYrc6OL1yG3x3bpWmk0ZOchEappdKxwBOLcP8Uv2sqCAAI5AXtdib5EIjMN/Mb+cuKWxec0nTrSab531+oL42KwuVDMWsg41HdaCwDXw0JdLfnqnj42yrMW7BAjyknUDf7EjOSw6ZPpbYxox+Rp0etx8oKDdH+j946PmNUZCi8OZ0j/eZGZ5SiEceK22aQ/2s3U3crYUhTn+GaG0pxc1Dj+vimiJe8ScvtOMuBQXjkKXjFFEV7RZ7ewcuWfXgTNXFZ4faR9R1ixHPFw8go3l6LfNB5paxXrU/62/VFY9nhn2BGkA2DnaibRQkPAiSLeHuQVkgb9kv2GnIFj/Dc+Yah82GR0jjTCx/tZ306RBc/aTrs7XFK0zMEaOq7p8yEz1ysWADeTTX7X4nJxViqTCMGGi+aJFmu3TzfmXRs4ze26S660BJ2jkn6mktptxIUyeWxSt0ggUc6jYi2/qutYIGdgZ0QUvswxlTbtBoKr//hE90q3f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/15 6:33, Waiman Long wrote:
> On 1/14/26 12:22 PM, Yury Norov wrote:
>> Now that nodes_and() returns true if the result nodemask is not empty,
>> drop useless nodes_intersects() in guarantee_online_mems() and
>> nodes_empty() in update_nodemasks_hier(), which both are O(N).
>>
>> Signed-off-by: Yury Norov <ynorov@nvidia.com>
>> ---
>>   kernel/cgroup/cpuset.c | 7 +++----
>>   1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 3e8cc34d8d50..e962efbb300d 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -456,9 +456,8 @@ static void guarantee_active_cpus(struct task_struct *tsk,
>>    */
>>   static void guarantee_online_mems(struct cpuset *cs, nodemask_t *pmask)
>>   {
>> -    while (!nodes_intersects(cs->effective_mems, node_states[N_MEMORY]))
>> +    while (!nodes_and(*pmask, cs->effective_mems, node_states[N_MEMORY]))
>>           cs = parent_cs(cs);
>> -    nodes_and(*pmask, cs->effective_mems, node_states[N_MEMORY]);
>>   }
>>     /**
>> @@ -2862,13 +2861,13 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
>>       cpuset_for_each_descendant_pre(cp, pos_css, cs) {
>>           struct cpuset *parent = parent_cs(cp);
>>   -        nodes_and(*new_mems, cp->mems_allowed, parent->effective_mems);
>> +        bool has_mems = nodes_and(*new_mems, cp->mems_allowed, parent->effective_mems);
>>             /*
>>            * If it becomes empty, inherit the effective mask of the
>>            * parent, which is guaranteed to have some MEMs.
>>            */
>> -        if (is_in_v2_mode() && nodes_empty(*new_mems))
>> +        if (is_in_v2_mode() && !has_mems)
>>               *new_mems = parent->effective_mems;
>>             /* Skip the whole subtree if the nodemask remains the same. */
> Reviewed-by: Waiman Long <longman@redhat.com>
> 

Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>

-- 
Best regards,
Ridong


