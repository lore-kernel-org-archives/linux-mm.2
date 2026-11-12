Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1082D606A33E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 02:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=i/H2hxN1
Received: by kanga.kvack.org (Postfix)
	id 2EED46B00EF; Wed, 11 Nov 2026 21:27:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29FFF6B05B0; Wed, 11 Nov 2026 21:27:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B8236B05B1; Wed, 11 Nov 2026 21:27:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC7626B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:27:16 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EBD83120497
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:27:15 +0000 (UTC)
X-FDA: 85424880030.27.632FD13
Received: from mta0.migadu.com (out-140.mta0.migadu.com [91.218.175.140])
	by imf28.hostedemail.com (Postfix) with ESMTP id EC9A8C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:27:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="i/H2hxN1";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.140 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794450434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2kXQUvq0pMfnz4HzoTzQFMbsuHXEC2i6vljk1NL33ts=;
	b=OUMueqfHipaKj13iLHeL8TYW3WP/IFHWgWARSDJ5/GWenGeHG0/rQEMGzpAjtarKZGVvdv
	v7IW3Ua2KLQgLTfkSPOeo/PLcvAPWmjs81S7+WaH4pxWCZ11+KOhnQlpiutTr44SKCWtI9
	SuKv6HN7anNUf4l124EcqJP17unGKK4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="i/H2hxN1";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.140 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794450434;
	b=rfM15jCMyYHtnpG+OruaqJLcW2d3YpTlKzKDbnYnr/rDi4X95+JnqDzlwrvyw/BdKj9sgu
	MAG/xi3nfJZbFGMOAwLn5F9Lc/7lQR1xCBaOXC5cvthtPPqTDIZJ/F9ImbSpOMwMo3aJcw
	cG1lgfKAbdyHPmftWbxwDsdGE93+i7o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lsq8XQTPFu5wkpyrYlGgMAgRBeoL0TX9wwuTx30+lDo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794450432; v=1; x=1795055232;
 b=i/H2hxN1wgzBhaueWtScsLuQzMUD+RLCn6qIqP9BunWdm36qayynlHwqyVDYy8yZvY7w0f/c
 +bWmVJ7Dernv/v9KUsPDxMlTBmRvTpyjDfZrCaH+VanmPJxO1LUoOsNUnAUwq+Gh9Z665nDkmWk
 5wCk7Qkst9lPERceSJBfZZkM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 6e62475f303e8754;
	Thu, 12 Nov 2026 02:27:11 +0000
X-Mizu-Trace-ID: 6e62475f303e8754
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] memcg: flush nr_charged_bytes when the obj stock trylock
 fails
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261112013220.4064478-1-shakeel.butt@linux.dev>
Date: Thu, 12 Nov 2026 10:26:56 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>,
 Meta kernel team <kernel-team@meta.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <16F05AF0-BF45-4206-8B42-0D2AD6CA2B20@linux.dev>
References: <20261112013220.4064478-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EC9A8C0004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: g1ns53q4qz1c8yq8ffpqu73x8aof4g8p
X-HE-Tag: 1794450433-353579
X-HE-Meta: U2FsdGVkX18wUW0Lh6VR7gayqKp4cff5dXKKiV702AympL4hcvoGJo+Nnmn5w077QlpMzR4seeqzcIxmXtmCce3ZeXCYthBYB3afDREgviKydR5XFfEmgTy+tm8HTbroAl8l5BPMKRVHq1y7XPqHWaJoHVRxOcvxhsN2d/v0QGJ3MKNE+iBvG/evNlKO0HyvqXVmj7jCJ4+Z5zHJ3H8n1AgaKZkw2orGK0NzL5SaSMGZPKiO8F3a6j4d1+VeSCDcIFQ7RWojRIqnt1T4FJ5mgdMjc2WcVNCxZkgBNULZ3Um4F3OW9sjZj3LSVzMJa3P+ERdNZsp8XiBw/+UfgrmnPWvPruQBQkJYWg/r+iByctCiC93pOZnaoyOXGV/tmExacvnPoR5PxGXrdE1bIamJGrS0Dhmcb375VMnIlE10Uv7r+1TRT/0L6nQPH1AMuq9HsX/4udIp+NuK3UDKxwHixUz1whtIdhGZyAo7eFbUYB4qSzy+9FnOK03jR1sThYTfy5/ktAWqGCBsknKJjwPAw1zEIw9DnA2whxBcQa5EbJnIVfV9sOjxtk6kFRAB3Xo7pCUyTY2965t6cHOwM8svCQTC8E6Zq+x99/g9an/uZEUGmT8+2PBU1SQwrp8EMBNGfUJkwzCgtco4EID8RffaDM999hAC6L3wiFiyxZxLlBZazO2YI1BOZLuhRGpUJRvP53pNFnwkoqNZEXWL1MxBa6mGXXo9NYvHFt6EheyDjcswEN9ToL4kUaPtKgZeNRnxWePcw3GxBX72met01Tx15JiOYcldg3VbNFaKKeK/ADUhmZ6uy9TIE0JfXdsLBVyG57SG2YNz656/ymqSgwwSjtF2Kg46psTldRLkaRnIZIpaVB7y/QcZ98vhSP4NCYAxet7gHj5aO4M5i/OODbXpxPTIJ7GfHTiAv6GTW93KTXrbzydjrdW9rhZCf20oSkTqJZa/hteLS78r34S2jMC
 D1sVLOOC
 GUF+WqBoNt3HewDgDtMNiQRUpxL1RjrOpMeMIrRT35aPLtUESjYJTDldBjKaG88lhKcLZX6uovWLqHXeCc4wT+dpCuQLJO2ZoWMiUMoMFRqppvQ9I4Ye2J7KvSjiM7F9HCWoFn2WROrVKmp+RaCyAdpqZs71fHF17JRmZjB7cQn6v7Gopkoc5IQGogZanFfi/4AWwx/+XiTvMYkNP8URTQdg82NwYJNUVp5pXVmB+ogr/yp+4HzL+59xODGsS6KLWFFOirhjsP3mBNMnM3kzF/35yGO6S00TUPrbwLYoYc5IoIIW9/C6wUIiDUM69zCsIPc4vdiE9AUlnwX8NLH3M3U+XmxoewkH/YsyEYAqlNFc03+VuJCKriJ64Cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 12, 2026, at 09:32, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> When interrupt code, such as an RCU callback in softirq, runs on top of
> a task that holds the obj stock lock, its trylock fails and the bytes go
> to objcg->nr_charged_bytes. Nothing empties that counter while every CPU
> using the objcg keeps it in its stock, so it can grow without limit.
> 
> Users see memory.current and the "kernel" field of memory.stat keep
> growing while the cgroup's real usage does not. With memory.high or
> memory.max set, the cgroup is reclaimed, throttled or even OOM-killed
> for memory it does not use. The counter is 32-bit, so after 4 GiB it
> wraps, and those 4 GiB stay charged to the cgroup and its ancestors
> until reboot, even after the cgroup is removed.
> 
> Fix it by uncharging the whole pages in nr_charged_bytes whenever the
> trylock fails.
> 
> Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: stable@vger.kernel.org

Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

Thanks.


