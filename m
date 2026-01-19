Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4104D4A5EB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 03:44:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 246146B00FB; Sun, 18 Jan 2026 22:44:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F3766B00FD; Sun, 18 Jan 2026 22:44:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 120B26B00FE; Sun, 18 Jan 2026 22:44:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F177B6B00FB
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 22:44:22 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B0FB813B619
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:44:22 +0000 (UTC)
X-FDA: 84347320764.03.6443332
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id 07E8720004
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:44:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bPRAAvqx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768794261; a=rsa-sha256;
	cv=none;
	b=RbfGgSRPrj11e/niBAyKQ5dJrkTne0vhv8lAzJT9bS69KAJo/YWNGK4W1+DqUfs7Tyc5Ai
	rhZNvGWbx/TTfKMT75N+kBp3sWmwMK6jn5TXfvOdYEuBar29/yjoZaIkZt40JDPNyyd+iU
	pzZBmjuGiuG1bdh1waivTfnOz5K4RdY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bPRAAvqx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768794261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qtD5snQPe94FOhhDUrGLnGyiUlaHl47qH8GQDuJHsl8=;
	b=2M79/hb7K//ZVQMLPBd8s1OnrcvEwk5n6Clmwk7Jm6ewKSfxWB9sDCFnb9DVHHraFFveL4
	g4LRhSLNXTecIIcGhYITpqKaclKBpEG+M579pqciXu0dIpD7j9TgqOys2E3k03pKYmCDL7
	njfbb2gInSZWHi6TSWZBiIYmB5jplRw=
Message-ID: <dd288f1a-e7b0-48ae-9b11-d882f42bab36@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768794258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qtD5snQPe94FOhhDUrGLnGyiUlaHl47qH8GQDuJHsl8=;
	b=bPRAAvqxtDPjzYKbswHc3HmHGQ9wVvkHc9z+Xmo2VCUXmapU3nrDOgxJFPzlAg7PDRtIcF
	zOP5PEP0dszlYOCUXzIXdRN2r5bnRILRWnJd6Tm7FjHYoAvti5eXRNMcf08nCHqwaP1jHH
	p+XMtJcBfwZz/Qjl6AeDMpqbzGVi8Zk=
Date: Mon, 19 Jan 2026 11:44:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 24/30] mm: memcontrol: prepare for reparenting LRU
 pages for lruvec lock
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <0252f9acc29d4b1e9b8252dc003aff065c8ac1f6.1768389889.git.zhengqi.arch@bytedance.com>
 <4a1b69d2-df29-4204-91fd-bb00b52350db@linux.dev>
 <e7aa1221-040e-4806-a259-56718844897f@linux.dev>
 <ncg4ibcrecdutsizzwdu4buw2fvqc57yji4rx3hsdwv4mgobkz@krdjtokzz4xg>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <ncg4ibcrecdutsizzwdu4buw2fvqc57yji4rx3hsdwv4mgobkz@krdjtokzz4xg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: fa3499tcfza1d4q8r45t415mturpzi69
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 07E8720004
X-HE-Tag: 1768794260-305795
X-HE-Meta: U2FsdGVkX19v9Zu9z4aNGtHe9PR6Q/ERmTa+xjbzKXUXBMs7eSqqXH68UL9TYuVNunx6f8oV5gIl7OwwtHIBZxbEnn3tR2Flaqoc1jKLrNC9ZAS02smHpO9bneZ6mn5ezuDW9O1zGhpxySYERsOmxXb/7VMzr1wEW82BOGq8Trecmvf9SB1J8hQgqB6qTaLo9EpXIn5J6T58iETBDFZag6QxASPgVJJbYz2r4xVPpMr5FHfAFsCPmsYIkIqhnq/xNQtiGh72+IV21SF7PZc4b76Nna2IWZ5zsuII8OxgOUY+fMVZDmoVuK8wMxA4zQz5nm1+Yn6mMR8Gh5uQFqITncGRC/v7shLxDedJUuNeoq1Yv32x4fd4Hr3bcpqunrqQFyremJjIXgjnFHfW8P5qI9TNFs5V4OZrSm2F5ta7b/JpT5Gt/JVKPCJWhdV/8kZcsKpnfR4HrevTXSaE4xSou0K990oKIi/qs1czGUP9SAsfO65PnIQ/dSV3Iw63E+C9E/GVNwr7qjcu1a9PEyzILJe8G0irYDxfuCfXe/dZPB7GBWdLR7Lh9XDyOGFP6/hN5nHuOPg2r2bMvoKu3eX7mDiGEVi1e2xbmVrAUzTdY5dV3uFPnVirGk76k+Xkv2TMBGUeAzi0yNUZTOd/h1h24mVOcuCpyYZ4U00vM9EBEjP2/q9Udl9+VaJsUjqnGBxIRM0Lba4T5f/slyK6HwINuD7vlvbTHxVxzLic0wAZtVS9OYGYAdOI1sxG8aVM4Q8JL8uAGP3I62Z0UiSEBOjz2fanzfwW0k8ZKeNdIc/Wp0xCZqgQRcNE2Pe2GoEbGythhTefz+GIscebtG7Wyze4E/QpONzZMFaXAnYFVX9UCaMw7rsgvo2J6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/18/26 8:44 AM, Shakeel Butt wrote:
> On Fri, Jan 16, 2026 at 05:50:22PM +0800, Qi Zheng wrote:
>>
>>
>> On 1/16/26 5:43 PM, Muchun Song wrote:
>>>
>>>
>>> On 2026/1/14 19:32, Qi Zheng wrote:
>>>> From: Muchun Song <songmuchun@bytedance.com>
>>>>

[...]

>>>
>>> It seems that functions marked as `inline` cannot be decorated with
>>> `__acquires`? We’ve had to move these little helpers into `memcontrol.c`
>>> and declare them as extern, but they’re so short that it hardly feels
>>
>> Right, I received a compilation error reported LKP:
>>
>> All errors (new ones prefixed by >>):
>>
>>     In file included from crypto/ahash.c:26:
>>     In file included from include/net/netlink.h:6:
>>     In file included from include/linux/netlink.h:9:
>>     In file included from include/net/scm.h:9:
>>     In file included from include/linux/security.h:35:
>>     In file included from include/linux/bpf.h:32:
>>>> include/linux/memcontrol.h:772:14: error: use of undeclared identifier
>> 'lruvec'
>>       772 |         __acquires(&lruvec->lru_lock)
>>           |                     ^~~~~~
>>     include/linux/memcontrol.h:773:13: error: use of undeclared identifier
>> 'rcu'
>>       773 |         __acquires(rcu)
>>           |                    ^~~
>>     include/linux/memcontrol.h:775:14: error: use of undeclared identifier
>> 'lruvec'
>>       775 |         __acquires(&lruvec->lru_lock)
>>           |                     ^~~~~~
>>     include/linux/memcontrol.h:776:13: error: use of undeclared identifier
>> 'rcu'
>>       776 |         __acquires(rcu)
>>           |                    ^~~
>>     include/linux/memcontrol.h:779:14: error: use of undeclared identifier
>> 'lruvec'
>>       779 |         __acquires(&lruvec->lru_lock)
>>           |                     ^~~~~~
>>     include/linux/memcontrol.h:780:13: error: use of undeclared identifier
>> 'rcu'
>>       780 |         __acquires(rcu)
>>           |                    ^~~
>>     include/linux/memcontrol.h:1507:13: error: use of undeclared identifier
>> 'rcu'
>>      1507 |         __acquires(rcu)
>>           |                    ^~~
>>     include/linux/memcontrol.h:1515:13: error: use of undeclared identifier
>> 'rcu'
>>      1515 |         __releases(rcu)
>>           |                    ^~~
>>     include/linux/memcontrol.h:1523:13: error: use of undeclared identifier
>> 'rcu'
>>      1523 |         __releases(rcu)
>>           |                    ^~~
>>     include/linux/memcontrol.h:1532:13: error: use of undeclared identifier
>> 'rcu'
>>      1532 |         __releases(rcu)
>>
>> And I reproduced this error with the following configuration:
>>
>> 1. enable CONFIG_WARN_CONTEXT_ANALYSIS_ALL
>> 2. make CC=clang bzImage (clang version >= 22)
>>
>>> worth the trouble. My own inclination is to drop the `__acquires`
>>> annotations—mainly for performance reasons.
>>
>> If no one else objects, I will drop __acquires/__releases in the next
>> version.
>>
> 
> If you drop these annotations from header file and keep in the C file,
> do you still get the compilation error?

I did test it this way, and it does fix the compilation error, but
Muchun thinks these functions are very simple and there's no need to put
them in a C file.

> 


