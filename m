Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B257EC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 02:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A15BE6B0093; Mon,  3 Aug 2026 22:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99E886B0095; Mon,  3 Aug 2026 22:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866C06B0096; Mon,  3 Aug 2026 22:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3E96B0093
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:15:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFD731A08A9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 02:15:44 +0000 (UTC)
X-FDA: 85061971008.15.5BEAF5D
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf21.hostedemail.com (Postfix) with ESMTP id 817241C0007
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 02:15:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SLJlQCJN;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785809743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gh8Fd4rP94suOy7JCk3n/TSIF7NrslTncc4aDwf2pwE=;
	b=bYri7x7jtsIsweXdO2pyeOHLNf2rP9pob3x31rCbiSQWvOncHSyw1d9djWT4UrX1ZI5byN
	muRvbJhvc5hOWxbSNCojgJfSc6x9r30YiebTZEk+1kxnOAiiL2A05lDyQ62024UQ8nHnuC
	y0lkSkh95kGHd9el08kjpalrwOe0Yfo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785809743;
	b=wMRQ6lO+i3Jw1atd9/y/rkiCXlJfxdbkEleKyZIvhcudCd+LUut6k4RKkpSCtSABZvlpdL
	RtoUpqg2/Tj8avd4QE8GesXQLoh2n3FhPl3V4Fnwx6DC0LkTvsZ+sTN6YEYIeouhleVQwM
	sf3X6k32MKyIIOBmrsQcZv5LxaZPU5I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SLJlQCJN;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Gh8Fd4rP94suOy7JCk3n/TSIF7NrslTncc4aDwf2pwE=;
	b=SLJlQCJNlHSpohuZTPY2E+kIwSLZltoJd4ITQeHkQPJypG1mxt9MrUYrwhIdebzDPLQOh/quX
	Ouxsi6vaW71EP9g1xNC+D6myqw5Qol4V70XY9k8vVNBQ92LVezSo2W5z7AkPcRCCFot+/8qnRxM
	OSWBPT68cY3sQs5g6CJHgQg=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hDcMx73QbzLlVT;
	Tue,  4 Aug 2026 10:06:05 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 84433402AB;
	Tue,  4 Aug 2026 10:15:36 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 4 Aug
 2026 10:15:35 +0800
Message-ID: <32d2d3e5-2cbf-4c95-97b9-5d618dc58378@huawei.com>
Date: Tue, 4 Aug 2026 10:15:34 +0800
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
 <fe724e58-f525-4eee-9471-d1765f6bdb0e@huawei.com>
 <c075be8b-4213-4ba4-8e95-6377986d7c8c@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <c075be8b-4213-4ba4-8e95-6377986d7c8c@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-Stat-Signature: mzwygec4ozndhkirj7o35d4s35xmaj88
X-Rspamd-Queue-Id: 817241C0007
X-HE-Tag: 1785809741-955020
X-HE-Meta: U2FsdGVkX1/o9LYxRQNBaOOwHj14yLw2PR5AhAr92LvQVGeO6g+o2vAqbEOCK1VQ3N1uIrSkCmKPioR9LDnmX09bMxP72thRp5+oCUr6ekLhryLSJOyBhV6zYKHa29eSOqM5bSKp/vq1MYrxcCWX+LKmkNyp4kxdw/u3n1U2PMx1z/FJ6mfUWf2tDEdS341zdXSCfKd2JvKMUC+QbQHI2EWxqGHl2cvRmcaDPyi2KSsSZJnV7ptqDuS6g77wNmJKIQikVFmG2FS8CzJTW6T056/JmyilCddA36dAseLy6FPjbYt/QOV4y06TAr7n2v7yGfGHy3C2lwkVbLJ4UUXMvhPmRduByJvoVhw7jJAXmn6MpQ345NBnf/pXMO7L/VmNiqPUgULOq2MeRvS3hF1YPCjlqS3FN9BDq5JgmSAbMVv+NexuAwitnjgz76a1iKMG1RAl3By35kSW6Gt07u3GMIA9YpxxPJH2FLBazXJwL1aoG1DGkFEDwkUOPrr5u/ndMHXdibySzRk46VyyghkQiTEMOQl70Wn/M3mSpdGJxrfgU0Sq7Y1hUS1u6hFDEOIP39+hLmPfzMU2UB++LivsOjvK1askirarzLbuvaPBIHO+CpayDA/QVkpITNW2arMC35gmSo5pzSY2USds0fM0R6lKoQoxMwU6YenqKgiXwyQM77DdQz9Dikwty10zujAuvJXLDwBIwteVon8GLAZTY6jeeFagiZUBjqHekG/WWcknVvuLBKT0Ki4DpJdN5U/XZbgMke3Ts3BFoNSAoxdZVac2XPoYPzbei3uR2vik+LwtmFgm9S3dg5BCZSdNifhquDOi7cVQrnt62BencNq49pdpgGLItjdwo97A8Ey2je47h/K54sq8EpG0ZsZNn+b4GlaWWq1/2sF5EB0Yos3RIHAYqkpk+8MEa0LN5S5vxLZHGEHhMoPBBFj09Af635/usgMrjQVMd6TD5krWx5v
 G/xmgSdM
 PJ6IzjLAeLsdSrjbsoSPdKwqaEfRBPqWGhI+qOOIe3W2Q7U137BqfVlDRpe4MW0N1278zJMJhtyhvPh25pJH4lWEc11a5Ox0pTIEmuHhzo7tP2Vwb50sqwh6PLvZZ2HjTIfUKIErrc4U7E24nFuxYsG9mDedCyXJtSf2BPNOVLts3WfIIDXjf58xoTB4erK0MN32Kz12JYrrsGiTtdBfiai6IfkWXQADXqTAYSl3l3qrMK/P2jKqx0T24zRe9xIpInUwHlIifuktwqdKtxb9C4L9WDxJ8vCHEKepcLfi/81xm2tI5SMsytgDeSG2WPebjDu0xOuh0gLrJxrBTRd+nn1+v1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/8/3 15:54, David Hildenbrand (Arm) 写道:
> On 8/3/26 09:15, Jinjiang Tu wrote:
>> 在 2026/7/31 17:25, David Hildenbrand (Arm) 写道:
>>> On 7/31/26 11:22, Jinjiang Tu wrote:
>>>> 在 2026/7/31 17:11, David Hildenbrand (Arm) 写道:
>>>> git log --grep "Fixes" Documentation/
>>>>
>>>> Many commits in Documentation have fix tag.
>>>> I think both are ok, since documentation changes are needed to backport.
>>> What? When? How? Where?
>>>
>>> :)
>> These commits only modify Documentation/ files and contains fix tags.
>>
>> 0c13ed77dd2b Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race
>> 0beba407d458 Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
>> d7f00084f686 Docs/admin-guide/mm/damn/lru_sort: fix intervals autotune parameter name
>> 652e1a51465f mm: fix docs for the kernel parameter ``thp_anon=``
>> 14e70e4660d6 Docs/admin-guide/mm/damon/usage: fix wrong schemes effective quota update command
>> da2a06188888 Docs/admin-guide/mm/damon/usage: fix wrong example of DAMOS filter matching sysfs file
>> 1beb8ae302a0 Docs/admin-guide/mm/zswap: remove zsmalloc's lack of writeback warning
>> 0ff11f103f5d Docs/admin-guide/mm/damon: rename the title of the document
>> 465d0eb0dc31 Docs/admin-guide/mm/damon/usage: fix the example code snip
>> 205498012513 Docs/admin-guide/damon/reclaim: remove a paragraph that been obsolete due to online tuning support
>> dd21bfa425c0 proc: fix documentation and description of pagemap
>> a8db400f997c memory-hotplug.rst: fix wrong /sys/module/memory_hotplug/parameters/ path
>> d83fe3c99d27 memory-hotplug.rst: fix two instances of "movablecore" that should be "movable_node"
>> 72a3e3e25a51 docs: hugetlbpage.rst: fix some warnings
>> 8867f6109b84 docs: fix numaperf.rst and add it to the doc tree
>>
>>
>> But there are also commits don't contain fix tags. Such as:
>>
>> abdca14655fe Docs/admin-guide/mm/damon: fix 'parametrs' typo
>> 78a00cac1e96 docs: fix 're-use' -> 'reuse' in documentation
>> eb14b12c8c22 Docs/admin-guide/mm/damon/usage: fix and add missing DAMOS filter sysfs files on files hierarchy
>> 472098f23323 docs: mm: fix the incorrect 'FileHugeMapped' field
> That is not what I asked. You said "since documentation changes are needed to backport".
>
> Who backports documentation fixes and to which tree?

Sorry, I misspelled the word, what I originally meant was"since documentation changes don't need to be backported".

>
> We usually don't backport anything unless we Cc: stable. And distros don't generally
> care that much about documentation backports either.
>

