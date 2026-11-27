Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E87606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 19:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vThAfQev
Received: by kanga.kvack.org (Postfix)
	id B94F46B05B0; Fri, 27 Nov 2026 14:34:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B45BD6B05B1; Fri, 27 Nov 2026 14:34:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0D396B05B2; Fri, 27 Nov 2026 14:34:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5466B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 14:34:47 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E60AEA04D8
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:34:46 +0000 (UTC)
X-FDA: 85481901372.06.DD069B5
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 252FA20007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:34:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vThAfQev;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795808085;
	b=U924DBAxbY3nvSLLdFjx7E+zkZJDSc6t4Eib+M1cIlRm9wnfCrgEnxfXeTtDsAGYhMfsUV
	49TLPgdQCCTjw7TaBQ8v+lX4rC5pG3rFMVoC4hPl/NLxYorlIQ9OQeFkDqCpaDq+GOPEEs
	QFlF/E6NbaDz2G4V/tLrwI6yXdngBqU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795808085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QVv0m7m4v5k5Mg+768HgZvDp6CR+HNVrKeGRSBttXo4=;
	b=ViCmDwP5bKMBNE/j1KfrYv4/XVZI6XvG53+vZiKpIehAmVFJppXfFJfVFfccOphkBYtQzr
	+3nUtE4yD3guNnbpSa1guLnrqIhAzK2l61B7tjrvAlJMa59htzT4woRD4eF5hx39e7ocOG
	DZQFvDK1KBLK0/LFXL25DlQpve13Z+c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vThAfQev;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8a052aff9e9so6034761b3a.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 11:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795808084; x=1796412884; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QVv0m7m4v5k5Mg+768HgZvDp6CR+HNVrKeGRSBttXo4=;
        b=vThAfQevhPcLlQYI1anfIjhf2eKDbiZhrtUa0rt/8kDLAESgDtv1nb13+BbaBzBI/G
         SWgVdi7RhBadVRS2ZQObqA/dbEpI3qZbmhH4z6zb1rVggWtyH7Ie63NS1y1TdMxW+5cv
         mtGMz2V7PodW68bYi3Qt2AXuZnF1WwWZgJJMbe6k471Q293gyTvwo5G8dpF+HaQNhAPI
         oC2EKNeJ7ja/TXUNIPui0JhBP88kFGjmVARpSzw+v0kpOrZkc9gCRC6wm1n9KhmhBhId
         Fl7U4659PvtTiNJiGJVStfC4WCJ5f91hox3no/Ii5ikNBcJs8H/fcRt5PX3uXvAf/C7u
         XF7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795808084; x=1796412884;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QVv0m7m4v5k5Mg+768HgZvDp6CR+HNVrKeGRSBttXo4=;
        b=rl5GapShn2z4mDg+1UnY7Q52AjwgCC4RGmh59BWs09BN3aEAnmw6FKwVP00BXoia4x
         LI8znKBmfbuP3yN9E0VK8XIFbDZZMJz7ouJmDrR0sSiKqZ8kVEN0eh1+9gfPgIRwOZvB
         Rq3lWg2yK9c/4h+lLeINc3PGH5rwl7E9BF4+GBm7ZEq3/3Ivi9LIsd9Kf1mURvpIjTIy
         iLZtLGWYGr1e6uZ09DIZp3G3lM5knx6Kg3/kchT2TV9PrMsM2v68pyv7M0cirex1ujKN
         /j+1Kdky2wV8lu7pT7vIGD3ped6prOasgM0To2tZjtN0sMEhlIvSM2Q+321aClWLkT3u
         VmBg==
X-Forwarded-Encrypted: i=1; AL+hErEndfoILdhdqRt2U4LO9In8hH0z3JmdhszIZXIG2mBtvDn+kqZWc5tt4k52747JOo7qDvv5hunnHg==@kvack.org
X-Gm-Message-State: APuU4Z+FssypquV7/85FL0INDjaMe4UUD23b7Cwa+i/sxdQ+1Ut5+W1Z
	7tEJ5/+WrHGhJW3tN4emNZ4zT/hHybl9vPkCAPAg9j1UWTREoU6In9wG
X-Gm-Gg: AZFdTZfTis72Tw0J0ARLfl4OLTWN9zIAof1JONKgdfNY/+mi6jz7DB2JlqFBX/x1qVi
	l1pFbx1OJF0cxhPDTlWn+uneBWzS87XCM5B0MUm2J7cjD6n79M6vZU+ga6A8TLru8UAqdjGbqj7
	NvyOAthwIOIgyPMGZV/T0xGWdMwlrNiznBA3U2RiMJMGQbH0O81Q2jRZ9jj83OD7HFftgJ19jDd
	VG7l70nKAWOMiqosZJlLBs3s1qiGbPHYW12L3WOj0U56No6nj7pF1javlQBtriISsKU5ZVcHQM6
	fU62ZaosPGUD9xbsdF4hfrHyYpK8mG4JhTj0D5N8qb/l+Yhi+WNCUgShn57K0GgUTHCg9yR94e0
	VkKqleG16KlxGlhjaNbmDWgfehKEQhp86Hg0nA3xtyo5hTCs8ac6OWiXEuughiQ4sfTpofDYKVa
	6V67zG85A6jH9iRn7yTF/+NJlZmRVBzMADn/iW4a7j2U3AQp1mdjnbTmpIJ5wiiCESpxfF8GrW8
	xaPbEEi1ESQvF3jtKiTgNWi6wS1NGbJLHOWctH9qDoe/Pu9IzFBPDrctrASBpkfnHFPTYK5oaHU
	77LC1pVtYBbgTmKuCUEZC+tei3n35PI2p2zKMrKezIL9TvV40d6PtbKhOF9A03Vnz/I+sUA=
X-Received: by 2002:a05:6a00:298a:b0:886:31d3:51a2 with SMTP id d2e1a72fcca58-8c87ce31d2dmr23631786b3a.39.1795808083757;
        Fri, 27 Nov 2026 11:34:43 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87353b889sm13232842b3a.42.2026.11.27.11.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 11:34:43 -0800 (PST)
Date: Sat, 28 Nov 2026 03:34:35 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Barry Song <baohua@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	"open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [RFC PATCH 0/2] mm/mglru: shorten the lru_lock hold time in
 scan_folios()
Message-ID: <awnYv_mxag0b6Dny@KASONG-MC4>
References: <20261127060315.1119672-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261127060315.1119672-1-ridong.chen@linux.dev>
X-Stat-Signature: sr7sejgmd55yuop9e5n4pk8krk6m7qqw
X-Rspamd-Queue-Id: 252FA20007
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795808084-51222
X-HE-Meta: U2FsdGVkX1/aS3B2+71iF5ktFwREYrZUxHonEN3PJVskUo+sCNmwWlr11VAiWsGG4ejQbHI9pjpp0IM3c+wO3s6XmzHPg1o/sKyfdjKCQ8dcxvpm3sGlv6qCpQ1fIv25apzOsB6odcT0O7wq4RLCZhvLczoTUcBjdx2TGWjTRZFSo/hsJZCBtuIEAUwLtdzjxoSPElSisZk4GxW5u+LUtYWU7Uzf55UDhwpwepa1G7ASTXbzhApXf1ElpqDTNITD/HBNlO6c7GZjwWQnpjELHcATLKa1pCQSkK8lfaC98PGF74xNU46ahKWCnLqwgHJdB/wk2iZVXtwOIma5V0FINk0GRWKkZjv3fFAUdEcI3X6pJhvAlAZO2C70R5vUQuoSdf9vURVopQkXCluEED1Rx4PSLQhsWqahS5Q81JeFo0C6PocIbA5wYTsSfNv+M7/XMo9Z7Q53Id5XVhkz3s8pPXcX6oB7otIip/kSxB0VV2AWJth2maXaZ2nX5pR8sSz89q9p+fqR9oEie5HdoRNzbdPaY/TM9VXc7/fkWDvwDHB3V7Synu6T9OoFeJRrzN2eeDzqF0GutJHWrJxOPhdw8IJRrTI/J6JE/u5SvtUXqJi8pRKt5cNAt5Ih0U9/QKEwOXMQ9DDdrLBGITYU87mkk2JlJlF/ulG+D1AqCFNSKhr4YURDB7sI0n1gd3NmN1Jnb5JJK6XxzRvrwNCZpda75082mr3dhZQIe3ZAOdKz/5Y4p32Pn1pmjwUigKJ1RbX2FmblN7R34wv8WsTLHaQSWkSkXh1vKhMVaUfwlc+rKU/KOsY4kQ9lEdaU8NdcCezj2cdkXFe07aHkFjItQp2OZd3WmaXotacMQ1nKLg4zIyTKiaI75RrMhee/lV59hTHdrT45yMyLLLNM2j3B7lvTbCNL839RBEgAz4ktgj0x/CTvNNDWSTWN2Xj03bDMQXQpUn5huzdK0BvNTqlkSqy
 E5KXKB39
 TQnsYrc6I/ezZXX2HV4dWbaPnqMUUlNIuFFRQIL2Zd6+OqvsVRcBJZc9lPUw1qqgAr017ya0YKpgzIGMOP/D7tstaNAH/bQukH2NaKH4FMoCFcVwjQeB7HKIPU1IMJ9fiEnRzeR1tVAINLpW4BVpPA8Y4bEgnwm0K5fYt+NaQVnTlqVHC3WMoXEFQ2NYFar0p2q+oai0F3W5dD7kyzgQfdkXi+fr9A9hc227qLbaJHK0SJZXlh/5+SoiHgGbcLzrBgYx6IsgnLJyxxp2m0wRT1buIHTz22mJRqSF5+pThP5VXFYuXhNpsg6XTWgORfs5LuQtQ3Q11M6IXRtcbbzWEBN40830POAk7ix7wxUVip8gkl4C+7Ewb+zemzlmj0zYG+5zD/kA7GAU2zmtAKuXm/Qistjxw3BTR6bRsEpcd2vyl/Q3XgEFC6+c3U0ZbZvCDCwkWYc0voMUVkYk74qwan2fru/BfYxGrfFyrMsVBddR7Mgk036Gq1itx7tmpR04i0491DTFdMX2/5/no58ivmjpp/Xr4+AoNqDunVxCTLucBWF2P5KWQZUwlpfx8eOryerkeA3NKRlRS4sn9pTwD5dFRcoXYjNT2dgKVB85uSxcWCKfoB5YNZD5LQdcQh5pc6yflde26lJHXf2gJbu4NcpCK27jkZXAopYNSkYBErFSDounyYRFCiIKPqGnP+Wj2qUFQepureGaZ2brlIWI/WdADST93tA2TS4rSlBcQ2PtBLqjH3cQkNTToNDl1tV4mEGj75aXVwABGb9teLMMwlmmNZIRKjUtQyHj5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 27, 2026 at 02:03:13PM +0800, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> When many CPUs reclaim from the same lruvec, they spend most of their
> time spinning on lru_lock, and the time scan_folios() holds the lock
> limits reclaim throughput. With 24 threads refaulting file pages in one
> memcg, about 40% of all cycles went to waiting for lru_lock here.
> 
> This series takes per-folio work out of that critical section, along
> the lines of what isolate_lru_folios() already does for the classical
> LRU:
> 
> 1. Update the node, memcg and zone LRU sizes once per zone instead of
>    once per isolated folio.
> 
> 2. Prefetch the previous folio, so the cache miss on its flags and list
>    pointers is not taken while holding the lock.
> 
> Tested on an i7-13700HX (8P+8E, 24 threads), turbo off and the
> performance governor. 24 files of 128MiB on ext4 on brd, all threads
> in one memcg with memory.max=1G, random 4K pread(), so nearly every
> read refaults and every thread ends up in direct reclaim. Reads per
> second per CPU, mean of 2 runs, with and without each patch in one
> kernel and the runs interleaved:
> 
>   CPUs      base    patch 1   patch 2   both
>      1    426681     -0.4%     -0.2%    +0.3%
>      2    387442     +0.7%     +1.2%    +1.4%
>      4    360312     +1.0%     +1.5%    +2.1%
>      8    314549     +2.5%     +2.5%    +3.3%
>     12    235058     +3.2%     +4.3%    +5.6%
>     16    184086     +9.4%     +9.2%   +11.2%
>     24    124478    +15.5%    +16.5%   +21.6%
> 
> The gain grows with the number of CPUs reclaiming from one lruvec;
> with a few CPUs there is little contention and no measurable change.
> 
> Ridong Chen (2):
>   mm/mglru: update LRU sizes once per zone when isolating folios
>   mm/mglru: prefetch the previous folio in scan_folios()
> 
>  include/linux/mm_inline.h | 26 ++++++++++++++++++++++++--
>  mm/vmscan.c               | 18 +++++++++++++++---
>  2 files changed, 39 insertions(+), 5 deletions(-)

Hi Ridong

I have a different approach proposed about two years ago:

https://lore.kernel.org/all/20240123184552.59758-1-ryncsn@gmail.com/

I hesitated to push that as the end to end gain was not
that large (5-10%) fio and it makes the code too complex.
But I think that one may work very well for microbench.

I tried to resurrect that 2 weeks ago, but realized it's not
the best time at the moment, there are too many things in flight
for MGLRU:

https://github.com/ryncsn/linux/commits/b4/mglru-isolation/

Perhaps we can discuss and see if using a "batch struct" could
fit better later? It should also unify the aging batch too.

