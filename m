Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C8FEC98328
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 18:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D4986B0088; Fri, 25 Sep 2026 14:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 185F06B008A; Fri, 25 Sep 2026 14:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C106B008C; Fri, 25 Sep 2026 14:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD8376B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:53:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 557AC14075F
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:53:39 +0000 (UTC)
X-FDA: 85253183358.02.20B12A1
Received: from mta1.migadu.com (out-160.mta1.migadu.com [95.215.58.160])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1161940011
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:53:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fVr/NGic";
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.160 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790362417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0E07eiXm8JpEoSoxhqWV54UT0f4Kt2drf7Od63Kqw78=;
	b=KvCvNL6rYwT7tNuI1uytG0dL3kRudCUIdSyIwJ0zMtvvMDoMOj2Erbl3P3Y/xIO+kaHpA/
	pSwXgm30tFYw43ZJFmuyevolGRxERaRsEdgyuGgsuc+V/1yqlEz4SEtrFhlO4SUe911dDm
	R+LQG9wQTo2lgfo3Jb42PcrL31bezmI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fVr/NGic";
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.160 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790362417;
	b=q1pXaFfHM02rSOjp54w+LrJ+hIJSMW071JFet7taG2MN4eJ0Ofbv+F0IrrB8OMsVnRH9w0
	0Ohg24BOe0qSjnBHH7fwpV2sswrBElbax6mv8mJHa6KFXmp5UTmtJj/2AG3p4fo8gn92tl
	AoDcfY71RmffsfIbmP43VbHNgUvCaSg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MYAsyhMrxVLSyyzXXZiuzFZn94HW4dHyFnyA6oBCThw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790362415; v=1; x=1790967215;
 b=fVr/NGicRJLAIMRpq0b3GzU4YTqMs/8d0kXNcq0OUHzFl4q8ZDkoWEtoG6wunxXJTy9ER4kK
 JtPylE8AqV36/bgqnFsIGAHylwepFgInzxQtK+pMiUqMNuXlLIMP7o7xVTJsPMhh6jp1jEx2k6g
 WNpPtrxdUeHuEGrmNkZlyb9c=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 07de4f991be2ed7f;
	Fri, 25 Sep 2026 18:53:35 +0000
X-Mizu-Trace-ID: 07de4f991be2ed7f
X-Migadu-Flow: FLOW_OUT
Message-ID: <99740342-e0e0-4ce0-ad4f-563d9c46a7a2@linux.dev>
Date: Fri, 25 Sep 2026 19:53:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: remove the unused zone->unaccepted_cleanup
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, axelrasmussen@google.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev,
 david@kernel.org, kasong@tencent.com, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 mhocko@suse.com, qi.zheng@linux.dev, rppt@kernel.org,
 shakeel.butt@linux.dev, surenb@google.com, vbabka@kernel.org,
 weixugc@google.com, yuanchu@google.com, hannes@cmpxchg.org,
 kernel-team@meta.com
References: <20260924191103.3475117-1-usama.arif@linux.dev>
 <arZlCx9oAWXr71Y3@thinkstation>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <arZlCx9oAWXr71Y3@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z43xy7nncxpqtn9zogeogqj4xc9jx5xh
X-Rspamd-Queue-Id: 1161940011
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790362416-43314
X-HE-Meta: U2FsdGVkX18mAGIWVmZdhK/iH/6jiabHlV2lKQQYClH1k1Zda1jeT8Lv+vMXkSbC6JsYcLY0j8/ZPRG+AyElJgyAP/zj3K5vfuEw9eru0Y/AD7i2iODQp2MhHKIfoiRUJAwS4oB6eSzJxDjEGX8BSWP/WNt8u+nIHIVve9mwFwAs7POtf/D4ne4KelVnfU2XTlKexw1xedPFzbLELykls0D9ngFg58I78QsAjqWVajMWGG5OKOZDoaXQ5vFPry1bsp/ZhIbhBNtb05l2GYJymzcYS4EUpobtzUZhSfLq+r4kOzYB0rzDy7ki3ZR53fWkaxLGbKzfuNX1+wV8bRg4c9vP6K/a0lM/nGMaE5FbRKvSqHx0k3Rn4cMMgvgWPmbNKNvE61iEn0XYlnQGZQCnKCB6+g3z7lLFBdVfq1cPAUTlzCrbLPDE44fECBuTntDueHRAdl5UxBXjHeCE9Yyxt9d2fm2lh0/vbHfRXnvGFTKWVDW3xp3FcNNIJru3j2zZzQhhHdqvaY/QLi0k/TtHtzxbRh0oaowmcwdBRfk01XCR+IAGDUSTgOFBm3cbNP7A5Xc32e6noUm6GuGV1yMFuUYesWNsJOarO/pMntEoaRuAVDlh3G9QCDAlLfeHsQ0X30seqJLBpcS/0lCpH8C9KBSZfU+3M8687X9atM7xwUM6x+tqDWmIV+y/EYXQZVIa/K9A43s3R9CZjqMRYgK/jBDdxn2gPhHu8MZLcGlpxL4EJCIrEwYvL6xSzUAkpM+0koyvztBZThldLQu5LiyXZIYWPQ1biO7Ri3L0ssuZHp2rsQkxdmLeK7S119muP8+c3OIvgk+jrcu1vOhMaJK978u4s1+Bs1ZqUsLkKACk7bZx4CoAbDoTRAOF6rEoE+aw+upriyhD1GgTniQqshTIBMRa/0DipT06JqVN+3HbhRwdxn2hyK0aZnQ4nqyynvoKU2mcJfmwCP9dIF3adHz
 YhH9Lywl
 JBVbMySG970JFhouN4fqjvLiJ1eBuqJUgzsn4rlndwtTpb6ftWibsaZpq1xrDM8Uoc/K44ju7fvoKQPfZjeXYockIxTLjoZ8PGYFkRwjlfANjsPYjYwlnAYgBLY4FUYY/+mFNKRfVtmabzZuq2UMLdP1jFkeTv0FYrlCvGJ7xnK2qTWfXclSKLI/R3s94YzzvjlocfuehgZabLtsNyUl7FWPPYkVUDoGewIuZlS6NqFLG8tktPz+cd6dx4qGUKjWPyoL35Mo2qKAJhT2X7fYfG7Lh6HTmwBjaG9YLCOpR7oztnMd7QkQiBFWopERUEAbmAX7KRSEYrk96QWxhZdMUfF0AFLEoxtYirlW6JApEiSKRMfARnserWg1iYet7Ucf/iqLG+VLmcPrrH1z22m2JnqxoqK2oz2cTcd3k3q7suLq3fGtFjhViZEYtl47P7iKZ3iOYo343EIiuwKBzPoDm2PJTySkiJVKsfHytL5GUlTbTGnmJ70YgURc+PsymbHhFQE8RGBvC1950xznMPK8qOeU3P7d27vlopVVrHGEr885l/0TNouXa9mxoGE34fINB01L/YHleC/ffnJ1RMnTbttkwU1GjY9+20vIXB6Cy67LII5dXoOO/Hn22SwKlmYdmDTWWSdytes8wOMS2GRXvoQ8k8iBXOOSTlLFpepfqcMSdBcFSlSMaLZwD0dNKhJaeiA14UchvnS8WogOvlxPjGrJlJLJ0LW6PZWvnsO+Cj1dtWhEcrinLFcHKpaIoGslJqHdFAw42GvWWJ5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/09/2026 13:16, Kiryl Shutsemau wrote:
> On Thu, Sep 24, 2026 at 12:11:03PM -0700, Usama Arif wrote:
>> Commit fefc07518227 ("mm/page_alloc: fix race condition in unaccepted
>> memory handling") removed the zones_with_unaccepted_pages static key and
>> the work that decremented it, but left the work_struct behind in struct
>> zone. Nothing uses it anymore, so let's remove it.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> You missed me on the CC list :(

I would never do such a thing. perl scripts on the other hand...


git show | ./scripts/get_maintainer.pl
Andrew Morton <akpm@linux-foundation.org> (maintainer:MEMORY MANAGEMENT - MISC)
David Hildenbrand <david@kernel.org> (maintainer:MEMORY MANAGEMENT - MISC)
Lorenzo Stoakes <ljs@kernel.org> (reviewer:MEMORY MANAGEMENT - MISC)
"Liam R. Howlett" <liam@infradead.org> (reviewer:MEMORY MANAGEMENT - MISC)
Vlastimil Babka <vbabka@kernel.org> (reviewer:MEMORY MANAGEMENT - MISC)
Mike Rapoport <rppt@kernel.org> (reviewer:MEMORY MANAGEMENT - MISC)
Suren Baghdasaryan <surenb@google.com> (reviewer:MEMORY MANAGEMENT - MISC)
Michal Hocko <mhocko@suse.com> (reviewer:MEMORY MANAGEMENT - MISC)
Jonathan Corbet <corbet@lwn.net> (maintainer:DOCUMENTATION)
Shuah Khan <skhan@linuxfoundation.org> (reviewer:DOCUMENTATION)
Randy Dunlap <rdunlap@infradead.org> (reviewer:DOCUMENTATION)
Kairui Song <kasong@tencent.com> (reviewer:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU))
Qi Zheng <qi.zheng@linux.dev> (reviewer:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU))
Shakeel Butt <shakeel.butt@linux.dev> (reviewer:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU))
Barry Song <baohua@kernel.org> (reviewer:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU))
Axel Rasmussen <axelrasmussen@google.com> (reviewer:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU))
Yuanchu Xie <yuanchu@google.com> (reviewer:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU))
Wei Xu <weixugc@google.com> (reviewer:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU))
Baoquan He <baoquan.he@linux.dev> (reviewer:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU))
Baolin Wang <baolin.wang@linux.alibaba.com> (reviewer:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU))
linux-mm@kvack.org (open list:MEMORY MANAGEMENT - MISC)
linux-doc@vger.kernel.org (open list:DOCUMENTATION)
linux-kernel@vger.kernel.org (open list)

I have a script that just takes the last N patches and converts it
into a list from get_maintainer.pl. For trivial patches, I dont think
much about its output and just use it without thinking.

> 
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> 


