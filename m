Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5863BC5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 01:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062B66B0093; Mon, 10 Aug 2026 21:48:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 013CC6B0095; Mon, 10 Aug 2026 21:48:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6F626B0096; Mon, 10 Aug 2026 21:48:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BEA796B0093
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 21:48:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 509531402EE
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 01:48:50 +0000 (UTC)
X-FDA: 85087304820.09.D93644F
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1DE6120003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 01:48:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dICgdgX8;
	spf=pass (imf03.hostedemail.com: domain of guopeng.zhang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786412928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZkR9Jrw3xAmJagDyGOXNwoyN0RpcRJIgBllJw9AEJU4=;
	b=OFv5DPq4fSp5A+QS3sASW64H+8fGaIBHvAGmWDzv91y/AaXhjHumF9I5zjmsN4ATOVvaYK
	3pYWCnIpjlhjKU1wS9JwAGUqBSv/EBzlIiwG350RWo5GcqHIt92Z+aRakBgoUh25pentW1
	MbJKB+B382qw1u6smgV67jYvjbXIjo0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786412928;
	b=ZAND2P71HacjL7y4MXUoaQUFOd1QaxMOlug/9P08Q6fjTDSqRW0fnhDRZxmmDN2iE8ohNQ
	suu7zDEJJQ0PyQ2QYJHabw3KUDJQxk6Hy8NujKA/1vtqaUoxWs1gsIVKY9AOiOQaE8c9kp
	5Ep974IsTGGFOEMQ9QCzU3e6mqMWqTE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dICgdgX8;
	spf=pass (imf03.hostedemail.com: domain of guopeng.zhang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <fbffc1dd-a606-4307-aad1-2172e010de88@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786412923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZkR9Jrw3xAmJagDyGOXNwoyN0RpcRJIgBllJw9AEJU4=;
	b=dICgdgX8gaKSk4Qf7qPJHjC3t91MFlzNSnOpWSNHNtWABVNfQ/J1xiBig+1w7K8I5jfg9C
	CQZsDqtAymdDCAcdB4/TW/DT6lnyiSF6Otg1y8PRQK4TKmNJHSgUufoh0+QOLoRLyI0oi0
	axGFMuu3l9UfhnlCk1Pog9Vy0dgXx7A=
Date: Tue, 11 Aug 2026 09:48:38 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: memcg-v1: fix memory.memsw.failcnt accounting
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: shakeel.butt@linux.dev, akpm@linux-foundation.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260810074247.52747-1-guopeng.zhang@linux.dev>
 <anoh5K01Qcn2t1Xh@cmpxchg.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <anoh5K01Qcn2t1Xh@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1DE6120003
X-Stat-Signature: 6t4zg3bby6bwq579cbm4oqtzxkxg4irj
X-HE-Tag: 1786412927-817073
X-HE-Meta: U2FsdGVkX19ENBBx8ezOmHECQkfiya+wVtH3px8KDEOQb2OlrbFkawDSJDYi6y/9cOeBBHY9g0x5nHl4Ri9RnvMMVrDJFSIN/+tdinMk6EKii8iZdQv32LdIFXvPPMQJHJ9ptOTnv163wlaAnPxtR9wsPGFUEmQacuGasmbcWIn5rOlQl6GfnahaHepZhk9orX18g6/rx+OqpRmFYmADiSYl4AXzNxf2eFdy78hZuMWwuxA2643+Z9XzbDq/cFj+hUy/umEtk87ISbVu7L/0CCZpfhH0khdmzlOHhW8G3WiH8BOlLeaWybRkdUAL/C6wVa5gZ6yB317Hj6nq7XrvDqe/aojGiiBovFUBQEMDptaTtEpU6wpAY3aQn7BvTsVz32XYHczRcqnQ7Kz3aNOAQOi/yyFiLewUldxvY1aWtLoaP4ySYif/yJR5kT0bnm4vK9WEjkOVFJzQZ4KPfT2TOcy+cXxMAuDsJVD35td5sZjmiY31RYbWpQLUuXFM5ttk1nV1nc65GJyIgeiXf7Tz99gNDn6uKJN44+souFcd4DMq+UNsylskHoJSii3SZNv5rI5j9xplHcaBKvQIY9a8SqzvVKnPZFAyFu7IUL4cZqck4ENmGiDpRiJK/bUeqwCrq4zxpLj2GaTVQCNWXmk4VBsBkw9Faxb4LpjvF4UjYnlMJBeeMUVB2c+uKzyW98gINueSkDn6H7uE1jwPwfUMdsPERy3BPzNrT6yDoenKxEaLRLgZwduTUyhpVz8+K5BJFePqquOFxoevZa2zDPFypl6Y+KuSVzYiHf/rmDw5/BWMC4C1XK7AbVH73ysz2Ov7jEA77zON2LyzTx/lpb66YuKANUwmKivXkCYPt1nR7+IGj/MvFLQBb6OXNTSEZdDLBh11pYnFgtx5g4L0iy6cMRl9Laz8+Pycgo2WUdQr1mwBc2W4Ze3KOQH6+sEKtkX8ZWmhwWZyGtC8mU/6MOB
 fcA6OhJP
 tDvMq/slt2g08P4J5z7AI3TTnQO118qT/pvh7BSmDK8YxDzQnURy6Wsc5tE+PpwmYJxpU8/eXZPmqSi6gc0W/C9j6dZG0PIq0xND/hIHjkjZO39A5l/TH6+z4pdUFK0ARo3kwcbA+77puP1A9x7vkZowZ+cfFZj0y2k47s0oFO7+Dd2qxkhaXmyntfNzUhT4PUPZlAKW5TdE1j922mDQQ/bOPMdgt0na2CCfAzT2FkjRT3lQhL/9u4khjYm4ze3VcloEvem/2ShNDf1rjPkhB806HkBSO7HBkyfZ6ubu+xnmxPac=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/11 03:09, Johannes Weiner 写道:
> On Mon, Aug 10, 2026 at 03:42:47PM +0800, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> Commit 0e2759afcaf9 ("page_counter: track failcnt only for legacy
>> cgroups") made failcnt accounting conditional on track_failcnt. It
>> enabled the flag for memcg->memory, but not for memcg->memsw.
>>
>> Consequently, memory.memsw.failcnt remains zero when the memory+swap
>> limit is hit. Enable failcnt accounting for the v1 memsw counter.
>>
>> Reproducer:
>>
>>     CG=/sys/fs/cgroup/memory/memsw-test
>>     LIMIT=33554432
>>     mkdir "$CG"
>>     echo "$LIMIT" > "$CG/memory.limit_in_bytes"
>>     echo "$LIMIT" > "$CG/memory.memsw.limit_in_bytes"
>>
>> Start a child process in the cgroup and make it allocate and touch 96 MiB
>> of memory, causing a memcg OOM.
>>
>>     cat "$CG/memory.memsw.failcnt"
>>
>> Without the patch, memory.memsw.failcnt is 0. With the patch,
>> memory.memsw.failcnt is greater than 0.
>>
>> Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Sashiko raises a valid point. kmem.tcp.limit_in_bytes is deprecated
> and will warn if set, but the functionality is still there for the
> time being. No need to leave it broken until it's removed.
> 
> Could you add
> 
> 		memcg->tcpmem.track_failcnt = !memcg_on_dfl;
> 
> as well?

Thanks for the review and Ack.

Agreed. I'll add

    memcg->tcpmem.track_failcnt = !memcg_on_dfl;

and update the changelog accordingly in v2.

Thanks,
Guopeng

> 
>> ---
>>  mm/memcontrol.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 6939a4fbb991..4ffe5b3733d9 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4235,6 +4235,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>>  #ifdef CONFIG_MEMCG_V1
>>  		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
>>  		memcg->memory.track_failcnt = !memcg_on_dfl;
>> +		memcg->memsw.track_failcnt = !memcg_on_dfl;
>>  		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
>>  		page_counter_init(&memcg->kmem, &parent->kmem, false);
>>  		page_counter_init(&memcg->tcpmem, &parent->tcpmem, false);


