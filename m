Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 041A7606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 07:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=d4aFD2UJ
Received: by kanga.kvack.org (Postfix)
	id 0C63B6B05BD; Fri, 20 Nov 2026 02:04:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 077996B05BE; Fri, 20 Nov 2026 02:04:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED00F6B05BF; Fri, 20 Nov 2026 02:04:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD8436B05BD
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:04:51 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23825C0D26
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:04:49 +0000 (UTC)
X-FDA: 85454609898.29.4048EA0
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 72128A0003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:04:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=d4aFD2UJ;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795158286;
	b=hlVxy71NoFBaOAC0u/oxMXnfeYSx6npBK2ANGmbghWg/ihmT5nBX+cDsSWBjmJ7+QroVHG
	eqzhTP/gGuTPMLqGEQFLfb7wrp8b9OdxAEab5vxbmjksRgc8hoq4C5CYwxu150Ms8h6yfu
	tt7kAl8xki+Erit0agVyySrVGUN63aQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795158286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3OAgcRg9EnbY/PPSzXn+hugpxwFSYehyNculrW0hUPM=;
	b=vdc4CZqiPAW/EYSAeDNuC8WPdTD5nZvbsFzGU71xBi3qDCTODHUivs6i2ZVuk1eezilD7Y
	e0HRorhdpLoESn8le1cnU9MmypJv2haJ6EivJjFtOXKIvfxv4VMynjD+Q9d5DxBTcvftbs
	Oys9rmVSe/0WsKieE0kC6pgE5X8gNHs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=d4aFD2UJ;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795158282; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3OAgcRg9EnbY/PPSzXn+hugpxwFSYehyNculrW0hUPM=;
	b=d4aFD2UJIIb4eH1FRHl/28m2Ij9G+lXS//SYj4IpcacVMUunlALlrcH8OOh4RDlrJ41p0LIw+q3Pow3sRpOd9LxavhWLzBGqsd00DqjcUGzIyaQcZugmP6cUmqtP1H3igi1L29bBaaFnm2wVRJ5sKbERfZZvp5ZoKurmiKHYxY4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XF5YGBo_1795158278;
Received: from 30.178.66.186(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XF5YGBo_1795158278 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Nov 2026 15:04:40 +0800
Message-ID: <565e4075-2788-4310-8309-7739b9ee94ed@linux.alibaba.com>
Date: Fri, 20 Nov 2026 15:04:37 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 RESEND 0/5] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
 david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev, david@fromorbit.com, qi.zheng@linux.dev,
 yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com, ryncsn@gmail.com, gourry@gourry.net,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
 <20261109215053.85df5685da951ab47ef858f1@linux-foundation.org>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <20261109215053.85df5685da951ab47ef858f1@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: kujg8bnf8djosg91rzfuqjbeustxdp1w
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 72128A0003
X-HE-Tag: 1795158285-996268
X-HE-Meta: U2FsdGVkX18sJpJ49G3stB17EZta1iNij8/7ypKvMZHkhpR4ZCRilondqRBdQlWbjeSor70AbGY15h/+XeHNFP8eFvDb8c1ddkxedzbU6MOalDLSzZfJgBoeajLFoJtNSQ0Au5+QAD/mR4Vedjz8bCSW9kGKWP/dhESb4uQviwdEftaxRoZ6ZVd01pxjvJVDiBtBHj7LsHeuzD7iqCh7AeMH7Ymj8FYUqKkfqDjW9h0aTlrLtoisxf8aOMIt1mCSjM0WlNYRTwQIvM871qjv9OyGqhfsLWCdxLZhsiBeNLWljZAr9i9TJ3e9Uy/vQPWXeMflrcAB1TjCMWFGB7UhRzR1UJng5LSkNX+iN8aJnx1jQhp+Xd4vHt6H31Rsw5wibqhNqQBVUSK2IU3UWLtCoKM8pVkr8w2WwQXLE60o0znz15Cn/BfLsPk5Q3rEtFLCFFB7VwoHGq5B6ABdjm9w2dFuY0IG4Rt7erk0hpUWLf0xgZ7rcgTWigNn3UEMgazun4NI1m93z7omIGhxq5Agj4zy2wCLfLcYjicjPxPT7TVJMOydIvGWbQw0K8SpoeYJKDUeAiu1JrW7BPmTc1pvvw45zPhDzMTTriGYXFfF2dN62ehWP6xT0BqT8WjI4Cj4MT4lCpKjk9Xo9bs4/3aFAbAFnhJVQKwbbRh632luVwE0sPlR9Zv9BC4y/U75nNOF6/+kMnOCwR970DkKOKGZ/JErY+CxJ5KMLZLsE41hju680Ipugsja+naSt3HSxAODuso5vjvAEFy7xzSTTF+OuvT6egFUCjUqFSSJUd6fgH7dCXN9F69E3mmo2nE21Wq7lwwlwqu28zDZE8rtFuffzlWDF46XAKor/zzdlwJDTVxODKaFbxYr3Sl/CHHVu6IT/XCN/iw3HhpDlpOEwY9bbE85HAw32UF8ot0XFWWDxLamFLWaTy30ZGzwJcQlONIbm7Lgsk0vdHQ0PhEJsiU
 d/McXV/x
 Pt6hih9KbAYk1QwcwWrjiPIbQcG0DNY7iX11txJQIKKn7kfQS7Rb3g8xu2u/bUkhhtZ8TO7DfzTjTtSjyxKRhjwx1mOn/R6730RrXqRCM3RoJ3mw/pEqzBA5s/GH9hQIEVJdghufz4ykVgHQUR9DxakYZcBZONhuEEQsI2J8/N4nhKXBzf3cZzcD+ySfuvPAV41U9wK626c0buWadSk4dOevc3COlJSowe+iUuhJaJzDXTRH0u7WJNph2/h7FV87hhy4sAltT4FkIKUC3f/d3N3K3OHnpf0TGlzsjE4YA/s5VONTUvpltdopcHqDVpm4ZsVp955aEsVgkgUfBKpkZVXxsi7LJbxQrSRR/xwUPRThk8fgvq88YGLuAm3yAfSFfZu68npc7u5xTD1Z2F83FA4dvqoDAW9wNx7zbBqN5V6aSJTot4d6cJ2LPR0bVORDWMs/noZ7TcsJqOZbZAh8HMpx4/T/Barnv2GDaBDWQoh5pLW91VMPgiDgymHtT/HD+IzXVxAStL4iHzKLbRkb4UHCJJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 11/10/26 1:50 PM, Andrew Morton wrote:
> On Thu,  5 Nov 2026 17:22:28 +0800 Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:
> 
>> With cgroup.memory=nokmem, the THP deferred split shrinker and the
>> zswap shrinker are degraded in two ways.
>>
>> First, both shrinkers are missing the SHRINKER_NONSLAB flag, so
>> shrinker_memcg_alloc() demotes them to non-memcg-aware shrinkers:
>> limit-induced reclaim of a cgroup neither splits its partially
>> unmapped THPs nor writes back its zswapped pages.  v1 of this series
>> [1] restored the flag to fix that.
>>
>> However, as Sashiko's review of v1 pointed out [2], the flag alone
>> is not enough.  __list_lru_init() also collapses every list_lru into
>> per-node lists under nokmem, so even with the flag restored, the
>> objects of all cgroups share one list per node: the per-memcg
>> shrinker bit is only set for whichever memcg happens to repopulate
>> the empty list, so pressure in other cgroups may not even trigger
>> the scan, and when it does, the scan walks everyone's objects.
> 
> Thanks.  Sashiko still has significant-sounding things to say:
> 
> 	https://sashiko.dev/#/patchset/20261105092233.3558950-1-qinyuntan@linux.alibaba.com
> 
> It also says "failed" for reasons I don't understand and it doesn't
> seem to have emailed anyone.  Please check it out?


Hi Andrew,

Sorry it's taken me this long to get back to you. I've had a very busy
couple of weeks.

Thanks for pointing me to the report. I looked into the two issues
Sashiko flagged in patch 2/5.

Sashiko pointed out that mem_cgroup_id() identifies the cgroup
directory. We reproduced the ID collision on v4: after disabling and
re-enabling the memory controller on the same cgroup, the old and new
memcgs had the same mem_cgroup_id(). Once the new memcg has its own
LRU list, a lookup for the old memcg can therefore find the new list.

I think memcg->css.id would be a better fit for the list_lru index.
Each per-memcg list belongs to a particular memory CSS, and its ID can
only be reused after the last reference to that CSS is dropped and an
RCU grace period has elapsed. That keeps the indices distinct for as
long as the old CSS can still be accessed.

The second finding is the same race that Shakeel's patch [1] addresses.
It predates this series: a folio can move to the root memcg between
the two lookups in folio_memcg_list_lru_alloc(). Shakeel's patch
rechecks whether allocation is needed after taking the memcg reference.
That also prevents the unnecessary allocation at index 0 that Sashiko
flagged in v4.

Does using the CSS ID for the list_lru index sound reasonable? I'd be
happy to incorporate any suggestions and send a v5.

Best regards,
Qinyun Tan

[1] https://lore.kernel.org/linux-mm/20261112061231.2469026-1-shakeel.butt@linux.dev/

