Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4521A606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BqwI/Uvh
Received: by kanga.kvack.org (Postfix)
	id 680666B09D3; Wed, 25 Nov 2026 06:58:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659C26B09D5; Wed, 25 Nov 2026 06:58:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F236B09D6; Wed, 25 Nov 2026 06:58:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B6F06B09D3
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:58:47 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 994DE80E64
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:58:46 +0000 (UTC)
X-FDA: 85473494652.16.C1A3B2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D896DC0004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:58:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BqwI/Uvh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795607925;
	b=DZbG4b6BkW/yULKHICapeB3fkUbaxjJnHMwID44nU6UaoNBYQHEgusZbmZbOJqHSVlEDcN
	cFxURRGrhk220cJUGHrhh+rLW3jXz/lY3QdMxq+54g3ZvzBJZyn0Hp+DAxBrKRg2Se4Gg/
	JZ288JrDCOCPfR5enQd9EobiYqyuDgA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795607925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lNCRH7cZNuQ7wfq9CQGChM58dHTmDD/qVZ/gcuDQhzg=;
	b=izagBmjyxl4GbzzVgDF8eGM0Is4bNTnPc3zZLdnrlEzKAM31XfjNhCTCDUDkcCXsayqwVq
	xOhSSLM/QfTFdUd6pNXc5v6P8kei+5EC38SSwvz+FFEqcUSvtncw7IeVCvcixDgkhSsHu7
	MV7Yx6zMXdLbUwgksqsLhueqmfzfhx4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BqwI/Uvh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C760B436D3;
	Wed, 25 Nov 2026 11:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42B01F000C4;
	Wed, 25 Nov 2026 11:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795607923;
	bh=lNCRH7cZNuQ7wfq9CQGChM58dHTmDD/qVZ/gcuDQhzg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BqwI/Uvh1M7WGfv3uxJ5RiUJbBD+YJxiGEH51l57/J8cvR0nYFX9EuOxH01Db/gl3
	 azhDLeQNLq+gSCz9bBclgE/Stxwgc1OnGda8kGmqV5EMXVKkUmFfV2CvT+Rm62XK1D
	 XenG4wQO2RrCgW/wCbiDbBeO4Rc7Ip56EoT3c3O+llR7TUr6/zNgbWYvfeIzDxnx4p
	 +ubU4YtMsxmEZnWNmlaSQ/wG+hvcmY4BCfujSx+SR/f4sy4MzVXgjv7yDcjComKw4v
	 IQ/v+4QySHWIFRBr0ULn+3P4SkF0Kkj2loMeQgoVqubeybQ7GXz5stRzotyVe4uM66
	 RFWviZn0m/VFg==
Message-ID: <4ffa6613-119b-4eae-abbf-26134bd60177@kernel.org>
Date: Wed, 25 Nov 2026 12:58:38 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: stop hashing address_space pointers for fault
 mutexes
To: Zhengchuan Liang <zcliangcn@gmail.com>,
 Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Davidlohr Bueso
 <davidlohr@hp.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <9a97a64f7e7aabc668499c426a2417a77d13a2f4.1795587203.git.zcliangcn@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9a97a64f7e7aabc668499c426a2417a77d13a2f4.1795587203.git.zcliangcn@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D896DC0004
X-Stat-Signature: tdhjbrymg73hbco4r63wk6c6uxc5ra17
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795607924-692858
X-HE-Meta: U2FsdGVkX19dM0CqVumnZ5UZalaZk0lS9Cd4ZG3hpmO4fG9B/IdLLXYQAGXPkxGiXo6zEKS91UTPBOFsyw9EicHtJIlJIooBUg4htbaPluti+MvSit41g1M9qhaUtyAdiUvwnJ4JC7p9C/W0AaCpq+PFUMuU1ojJWtahWezVwlka8K1PQ/3LlSJAhE8bZfjsdxyex8GmRR0YVWo4I1MgUCsyoCv/h8BvMuJ3+AJwyXAPIWoidJWGfWJxOHItqmJrxxyGCbvR3LZ1CNtoGh1MV4rBdfOedicIqjhlvcNcnNJmjnQi60D2cP92rs0jRr12R0buP3Y3n97v+xjg/DlKluxSIUGsbiOqvQ5e9yhmcrlMwUEBjL17W3ifdvdv6fndV0jYKfoGXPjU1Wgm+ufplrQiQ7hIVAw+MkJEQG19CGn1940KHZP2Yy3D+uGzc3ErhtmEvzKdeRdiBKzEQA+5ekLrC4n+dMwmz/odmMx0hL0xVcfYMLEtvF+XaZBtxesMZptnD1D1XDqGowYAY+UMU+Bnp29vTab7lyXUBCkNnZtIO05Cxd4kMEBV1xEEv9NO9/Ld/T0pe2KDviuXOoRsQkQ4usmH8uc1TuoS59FffwwXb3E/rqoLol6K32CYMLR/0qHWwokhTUeFrot2G96WctUX00HfR6ab+bo/M0PqSretOqJGr638I1uFbljSQVzPOQ0E8HdnWKni3K/a8Kj8T+ogpuSN6QbIMhWPBIueizuhH5SFFyp8+p95jQzTPeQFziB7Y4T6+o3/vJvLOue5qvlX/rhz4NPBIfo2+bpt62KPTI068NREZuU9O3mNvlPQiqEdupuTFooYSam3A3UmzcY7Z0A/YRvCK+yn0k68K0dQZG2dP3Fp7mHZs0cf63wgEONVpN5iXdfHfWuVDGZixQPKLCDHbJCHVbXWMK2lOc9geWBbdQurlfOFuA2JcrTUNnJr4GkhxaBqMtsyl/C
 FlxmLn9D
 T8EYLCblBu3M8FiHqCK0pbUz4mhZERY5xVDdnsq4VVQwWorepOcF2b1vGcmYbILPJdedcb9B2FN6iGVs3gNYni+5UjGEFkwXdJRHaTkO3ZFaIChVWWy2eQGfPA8UsCFWuFzxjITRCYnCAO2l6OX1P8E8l7HS7UOv0IXmi6JBfAWEnU8gVVq4u0n1vfvxC628H0BWX6XgZkszSTJ44ktLCZOOffE7LN3YTQ10NgfSz9kNDtd9+EZGJQiETz89hAz79B2eiWFC9SLa5kgWT7EMpS0AOMWAQh9y0GmzpXMQACgRhdOr1OuWyFVNTfI/VLOqrFfoXLTw8bo58Mgbalq1WkUh7ql+O4mL19nEt4JmQQSuD6MRWuQeFi30xOYOFQIa5fecaqVumoVhc9w+g8mnT3oBzS39O2HIoO5c6KK68AfZv3Deb9MJcoBPjTkQQGym3a6jW68g1ccSDcEd8wB0s8Ufemv4fC2BBx3zDvA+ui1jvyt66ieyHINT3gQsoFjv/rd1mO3RH+sFuTIk0cvooj6hOjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 07:15, Zhengchuan Liang wrote:
> hugetlb_fault_mutex_hash() uses the address_space pointer and page index
> to select an entry in a global mutex table. An unprivileged user can
> create a no-reserve HugeTLB memfd with an empty huge page pool, build
> contention on one index, and time SIGBUS faults at chosen indices.
> Pointer-dependent mutex collisions expose equations that recover the
> exact address_space address.

I'm not sure we care about this problem. I'll let other speak up.

Attacking hugetlb users is stupid. This doesn't matter in practice.

[I had stupid AI fix that allocated fault mutexes for each inode that I
discarded immediately]

> 
> Give each hugetlbfs inode a dedicated random hash seed instead, and hash
> the page index with that value. Operations on the same mapping continue
> to select the same mutex, while separate mappings retain independent
> bucket distributions without encoding an address. The seed is not
> relied upon as a secret and is not reused by another hash table.

Can't we still end up with the same problem, just slightly different, afterwards?

-- 
Cheers,

David

