Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 088D0CF8859
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 13:39:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 503776B008A; Thu, 20 Nov 2025 08:39:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C356B008C; Thu, 20 Nov 2025 08:39:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 353CF6B0092; Thu, 20 Nov 2025 08:39:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 210BB6B008A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:39:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 748B012A95C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:39:27 +0000 (UTC)
X-FDA: 84131092374.25.EF7B4FE
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8666B180008
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:39:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A4d9y4YW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763645965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4VBW5d85HPNjGo5XvcopxN5QwpZOcDhSseUA2IDtV6A=;
	b=Cp6Fp5Usc2SH5h6ZPpppZ7nxHXyfidw0VCvbN9SbkyeK1LV84Ib/oJBUQmkSwUnoemGVaC
	hzpCZYUNOxFKMAcsslGDmmgDbOo8lvSzDCOYfrLLbdDcQSz+aZe75MdKtHal7TB+gJgdyk
	Wa8bDYdaK+w0/GSgWK4/K/YYOlfGtq4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763645965; a=rsa-sha256;
	cv=none;
	b=31oFDTdXxwgxiq8NqteccSZI/pNLYZYTQ7ReLitQnU0O0raByOwa0oxEkc1U4K6H+Wg2YE
	Bl1LYaHhZQ3/cYTmaz3Lz/KAZTw9E3Q8Zg+XUYZIXhfzrVpccc/b03YwtYhr/FhFshzoCC
	M0ZhbiO+6h5cXUjG4BcTDciFn9cuOxk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A4d9y4YW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <82a16330-f801-46f9-bc4d-b10ae9e1472a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763645963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4VBW5d85HPNjGo5XvcopxN5QwpZOcDhSseUA2IDtV6A=;
	b=A4d9y4YWBMIDtkYVklUQaOQptNvSdxm1jgBqV92EzXwKqRp6kfKDevWnXtE/QsdXN65gi5
	n9IUhTH1NvnYDMs2/WbW/QyCefvwAe0xMwYh2pih3XH9sj9UJqFaEJEbaNa6MWWuRZsXvl
	azBSwSk/aVFUYrpaIUusu5PJC937F6A=
Date: Thu, 20 Nov 2025 21:39:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 13/26] mm: mglru: prevent memory cgroup release in
 mglru
To: Harry Yoo <harry.yoo@oracle.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <da4182d4f912a00e0cbe377f424f1e94afd3e5c3.1761658310.git.zhengqi.arch@bytedance.com>
 <aR2YSDDbhHfk4aNs@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aR2YSDDbhHfk4aNs@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: nueu1nqgcyxuczwugpauz9wiy3y5bp15
X-Rspam-User: 
X-Rspamd-Queue-Id: 8666B180008
X-Rspamd-Server: rspam10
X-HE-Tag: 1763645965-893205
X-HE-Meta: U2FsdGVkX18mzTjCqU3mtkhu1ptaErDvrq5uOz2FUc0qkKJvmEnR+oX/bj5F02kAnPCswq+YGzcNa3mg2Z0PLMvTffnnBi44kP/H7BI3H0Ahi4daK4GH9HGRBqrmvrvryuZZRLnt2NODAC+jKufJdLoouowybp6XzX2PoOACHgOxMZI1KIKAYb/WQ7GX9zfTcSKGZDIE366MLKl35B+JRFSTNIOTo2qtnsDq8mNEiz4iNwaYvcQ2g/BqYPAVUYEz2yNAbdoXH2hg7qyMO853DMvGFwJDn+AcRrXkJ45NtyZe8qZYs5TPqVcMKMBmZMdTEjQyIY+V8nEHpt8w5YRDC/GqSw4UPnaCi+CSAZqyd6qwuVjCmg7Ze+ldYMj+bbW5x3RilfxnvIfp7NGQMNw6JzZ0kazkucRFF/9j8ZcG+3lut7BnKiBV1iDXHs14BQxYs20axzPCEbufMjNwgbsf7uELDX6IPu3xauC8BM4CtouA/47pAKE3dPUC/cFLATtLaQusTLknz2SCHmP8/0CMuujygs/VaagS1HI5EkdbSt6+hRGeTrhbyzSEkbiE3DkGYPW8+ymTCkQ8962RUz5zmPzcSoExumbt6YHP70EuQ8XtgiMoMrXfKsOPsHoljmKOOSChmqa/gNoze4T0UYwuKOEnC4zkqmdCrBE32YOnP02yRoE67RkzQiji971ru6DrGbcElqBhjwAuaCt5xqlF0q3pxX81PMSdnd9FIc4trgL1AN2igf+UnWSDCp7XCwGSDMHhNUaXJgQXkDDATMJx6pxblUqDiimP1BGTEK8hgV83FsLjEG2MDTpZtIJBIiis93fy0W09R6MqAD2eTup8wMVDVEaYlz5zqNMVQ4MFxNlT9BpBOCf3zeXKf1InQqMREUd2JbZ/6w3jbFLhaVojqoFV66Pc0n+iDu033GhzmCjVBPiofB6G2ZC0324U7Ig3LroDWyAU00JDPAhuSIR
 83Ssn4mu
 PBcEUNNFrJqSfbVW7NCgTswX6AY06r5gjbxqiAXQfKL6iWwIOMwyhnghSEv6t/k/l36sdYRgcn6CM8TftbeWXGPl79+vaMutDVnIvq/sYvHgyOpv1QI3jFIGjtW8Dj9nm1zEBXy9ug3mL//P8Ex6JN6yo+bojeqffr7yTojYe8AdviwQHS4E3hk5zJqSc50HxQTRIkWbm+mQP3saTfmCtzhZOU7Xnc15hIuEFW9Lnb+oCL78DTAdRgs+OU73y94968lnEatDLdJjSAeo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/19/25 6:13 PM, Harry Yoo wrote:
> On Tue, Oct 28, 2025 at 09:58:26PM +0800, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> In the near future, a folio will no longer pin its corresponding
>> memory cgroup. To ensure safety, it will only be appropriate to
>> hold the rcu read lock or acquire a reference to the memory cgroup
>> returned by folio_memcg(), thereby preventing it from being released.
>>
>> In the current patch, the rcu read lock is employed to safeguard
>> against the release of the memory cgroup in mglru.
>>
>> This serves as a preparatory measure for the reparenting of the
>> LRU pages.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   mm/vmscan.c | 23 +++++++++++++++++------
>>   1 file changed, 17 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 660cd40cfddd4..676e6270e5b45 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -4279,6 +4288,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
>>   
>>   	arch_leave_lazy_mmu_mode();
>>   
>> +	rcu_read_unlock();
>> +
>>   	/* feedback from rmap walkers to page table walkers */
>>   	if (mm_state && suitable_to_scan(i, young))
>>   		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
> 
> mm_state has the same life cycle as mem_cgroup. So it should be
> protected by rcu read lock?

You are right. The mm_state is defined as follows:

struct lruvec {
         struct lru_gen_mm_state		mm_state;
};

will fix it in the next version.

Thanks,
Qi

> 


