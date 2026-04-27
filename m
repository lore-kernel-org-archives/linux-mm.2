Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98936FF8864
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 22:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 969EB6B0088; Mon, 27 Apr 2026 18:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91A356B008A; Mon, 27 Apr 2026 18:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 809646B008C; Mon, 27 Apr 2026 18:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C1AF6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:28:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AAB3A8B674
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 22:28:12 +0000 (UTC)
X-FDA: 84705775224.21.D4BE592
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id B5819180002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 22:28:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DHs4z9+a;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.53 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777328890; a=rsa-sha256;
	cv=none;
	b=sniv4yQSYoeivwbWomggSWdzimvMGq2PTsM1HLixFcA5K9740CbdUlo6y6CpW5Wyhxb268
	4n6scUk+3bw4o8dIjdkfogyjdyeHpQz0M3v36xUkneUhYoqgzJc5wD32/GHnaoFBGMKd4F
	O8sgueuF4f93XqH4ReK1n3NycjvlGjA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DHs4z9+a;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.53 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777328890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P9hfpEncvlzWZw9qEgc5pnCnun8WUnWYl5bmHD7iYIU=;
	b=eQ5SJV3uITiadZA8oJr9D5iuj9ScHGfF0aUuf8FZ1BX7ApWq+/gaCY4uXfIYz/yAWUQL+S
	SSHcPQ86R0W0t6aG3C7pzsenaHrJ4XMnCOWe12+PH1lN4mx/LnRbnulIeLgWzrfqf7JYlE
	/PJdbMUwLts8wNZufx8GFqc4bgWcxrg=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488ad135063so97870495e9.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1777328889; x=1777933689; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P9hfpEncvlzWZw9qEgc5pnCnun8WUnWYl5bmHD7iYIU=;
        b=DHs4z9+amAWRZBW+Nr5vhnxvwK562mobZX1hgPMe9zh52ObOrzVSuQcCWOHh2XLPw7
         OcmyMmhnRjBGgY/0tQN3XR0TWMj61BraJZ1TVLIDktXGKF9HoOdjPR1kMIcv55256iPC
         Y/Rl50dMp6t4MexRLieMS5ekgVi5OS4fjXkT2htqTf9hMHDmUgJVsIvJ3p4mcih4MZXu
         zEprmVwkwYi7Sm6CC4auzTV0P60YPy63cwtGGcvXRaC7GXVgYWKVmkXQpbKDeD3CByWz
         n4B1iRwNsjZy7xbtsrbEPPsDHT8b5l2GyvERn5GPkYUR6q6KaKjE7WrHVGGEm1qK6tM7
         p2aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777328889; x=1777933689;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P9hfpEncvlzWZw9qEgc5pnCnun8WUnWYl5bmHD7iYIU=;
        b=pDF3xtKT+FMYt7Mv67+KVHu4RZRuNjaWUI+ZLV6fwzoAT64c241pFHeVOHUHbS/KlY
         HGn2sRENKhJQnL7o9RSTdcmJdVkiXlheHViCnI+QpDLA3i5sDqiTAj1P7xTyDjXzkNc5
         /J0E69p4ixa433WXEc/A8SDazMUIYtoWRpo410u/UQdmBIJgQ3XAfP/OIcjoqb8/FnQB
         8KjhXQqN8mVXphFRvSLfsGxd7HrJXl0Xu9Zxq+X0QOLDRLFJALMAtp7Ty3eqgLdMWYAo
         3BshVN90PVN1a4re5ebX7p2D9lEOPf3ZMCKkkb7WGD1eY++UMldQ71mpzQcxGG7SHvmz
         +lZA==
X-Forwarded-Encrypted: i=1; AFNElJ/jrZkqJ2onj2R9qO39n1jbYYGYT0VliAhY163RVKLOlUzRT+mgfLZRh4e2S3FQisn+MIPXbq0kMw==@kvack.org
X-Gm-Message-State: AOJu0YwFkxmGipsE9Pt3aw3FyEK8nQJws7UXTctVAq8RGLjRCEJr0Gcm
	swd7wttp1F+iXVO1idYpEbE+VMJjdVI/GlzA3HfznuustEM+aXpKbR7RDbHPxcsrmfc=
X-Gm-Gg: AeBDievaO8n+u8ZM9GppuDIBXZ+m9pwQuZGdmtKR/tcxGAwXC5seNDdpVRAHuYIZZJ+
	hRvJYqHbBLKC92cMMExza8YbZCgESe/up6CU5z7D3jxycpOVQQra9XPuZf9gzJIT4Y4ECfNTAEI
	iBEo/JlySJHuXVyO7KWtPUnCBAmIausGTqemkkIWqpFTbkIGx1wlj4odBwaKxhgJ9w1gL9vFLdf
	uk5JVumEATxaXyzrvFwOHOxRsaN3G0wM49wpqahb71evfiFng+C5ZEnWTICnFM5ENkOpS6dG1DU
	PV28eeWqdeAuT3IpH1ps0juRtJ8Xy9LmCSQwWwJVQwp5rBuBmUK8jVuzvtReIpHcB8QR1jDKz4l
	OgCNDZSAp1zgOHVHiqhJP6MZK6eXK/+L3B9ZPHlBBNFnpEBHhkMYLKWxnujULE/bk3dbU85Yi+S
	Kv/5ISkS5vnPekusR7jMTN+Mp5l4YYYwqqzVhO9js=
X-Received: by 2002:a05:600c:46c5:b0:483:64b4:79da with SMTP id 5b1f17b1804b1-48a77b22e28mr7190105e9.26.1777328888562;
        Mon, 27 Apr 2026 15:28:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2a00:23c8:67a7:3101::e3b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a77afabcdsm15735785e9.8.2026.04.27.15.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 15:28:07 -0700 (PDT)
Date: Mon, 27 Apr 2026 23:28:04 +0100
From: Gregory Price <gourry@gourry.net>
To: Arun George <arun.george@samsung.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	yury.norov@gmail.com, linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com,
	gost.dev@samsung.com, arungeorge05@gmail.com, cpgs@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <ae_i9IlIndumJWN3@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <CGME20260427123800epcas5p1e1a2fed257091b31e2e6c3a7d1b0c2b0@epcas5p1.samsung.com>
 <1983025922.01777297382206.JavaMail.epsvc@epcpadp2new>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1983025922.01777297382206.JavaMail.epsvc@epcpadp2new>
X-Stat-Signature: 6y59zpagc3ho4k5zfx4k5bo89j9d7yuf
X-Rspam-User: 
X-Rspamd-Queue-Id: B5819180002
X-Rspamd-Server: rspam07
X-HE-Tag: 1777328890-39870
X-HE-Meta: U2FsdGVkX1+RwzAT9FFejDqK4coGwcLbHWThGnmLohbjzx1O8V7nD/U2faGoto1VzT8awgoJlx3Ua0NphMAM+xKyLjRkZ2dDnRlksEVvTO46TJ0KYUEXzIra57Q/wLLb1IPdioi6nGubm995YLsGuKHQhFNUssrBUHCcbWiMkBwI0TgQIdkL7MAmclAnu4Kv4FNRCx1hbMPv+oZmFDPptEGzXhA6+IvIJzD3JfHYH2Kb3KY+2xN2J1jURCWBy3LnIiAtdli7wh5tuEcOyI4byCCl1SXdTGwvSke752t7buTUGNsBwOtAiX+6Lt+NClCfxB8lzW4Q6ugvmWKp8vrp2h2U1Jjn4BH0y+KoZlbpVYmNmop4Vo3ePBznoS9tXcHWbfSzNs8YTNG1TaiqwMIeWoRTSe7+7m+Zm2JkYVnRX+AzT3l/O27Y8Fji1et2AjFenCMlvjZ5CL93rvp1G40VR17u70pHhNX1PQSxml099eL0zbMXHU/7IQQcgSO1zZhaods+VhtSMGwvSzEq/Ky99G6rnKu668AdB/sAuuIVsXxIyjQKvAiF2DlUmRUmm0K9wBpl7ahoTjOBEBDaNRj2Nr6us6fi1abZr3XVaekiQUuQGWYAiA+yoMx5i4SUe0dhQuE1LRgbf/DvL9j5XN6pPYkQdtn9umesoX3s+Z8hBcDpg++l72Xy/8UDq7Air5HxXfPvZktrBBbQChSHSNj5DFqHuKSB3lbhIMuLiu5TRvifQtNNoiWDlsOmvO0P+TnV3IXayT7DBBsVb22OZQegR+Ief1udrZ1aJiMzy/xDAzuG9eWCSAX6DnSUJ9tPAEZOSZnHD2weES1LfNB1tK9C9ZenAzV0uQDdZZJtnymir7K5HVaX3jrtumbXN1SH7WxbJqLdxpsz3+7qob4TMw24duhyeUBR8FjCaFp0hIIw8wmdND+gAWhVCG3muCtsj49s0Fcid7r8vtmxLKV9Rx4
 MOH/7zNK
 CN0Yt5jkiXIKMg0yIKznffBOAjI0+iaBSRRMRwtiZVcxim8a0kcpci+Ew2BcK9WX2yec8gVTlcpszuXA+fCeCGEIasXJYMSZ3YRSVsS0LYgisCPGWVDtJoDMxjjwMauK43bbb7zzJjIeIJjghxA9+8hNYhJciBye1uJcnXXBNU4d22IWb61iISdsZw2emg/lDpIFDy4/yBsJDDg30abtXwhuD0Y+CW6EI/jlIyMkMCZIpP39on5VhqsMJ05h17Z7mmFfA1STP51LwdqDrgB6dKuVim4GC8a4R/0oEjSz9Oo3j4nBNP1V/KSUAJ3C4yTO/SodHAN3aFrsZYbZL5EUHoOscAAXzNpta0dj240w5dYkXYM2Kbr6CDg6jPCPVNW45LOEmrKrLRmj+ylQ8OhxHXngaM4OHcOHquQdGl9p+xjf7qYXT4Y5wFP/DDLJGVdUFgrftijpeDIAy5bkN1ZA19Q87ffMYcBEiHiETSNqt/792ERo1sghvIQFEh6HeO5r+1HD/Lt99RF6wS08mBG5or9860w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 06:02:57PM +0530, Arun George wrote:
> 
> Appreciate the work as we also chase the same problem statement.
> A few queries please.
> 
> I see the current support relies on read-only mappings which might
> limit the performance. Any particular workload you are targeting with
> this (which can tolerate this latency)?
>
> Any deployments you think of where the goal is a capacity expansion
> with a compromise in performance?
>

Primary use cases for us are any workload that benefits from zswap -
which is many, many (many, many [many, many]) workloads.

That said, performance is quite irrelevant if you cannot guarantee
correctness.

In a scenario where a multi-threaded CPU can write many many GB/s to
a compressed device - I can't see a scenario where completely
uncontended writes to such a device can provide reliability.

I suppose you could increase the latency of a writable cacheline from
Xns to NXns - but you've only slowed the bear down.  Meanwhile, running
away from said bear includes trying to migrate stuff off the device...
presumably to swap - so your migration process has to have higher
throughput than whatever writes are coming in from the CPU.

Meanwhile - the system is clearly already pressured, and is likely to
continue demoting new data to the compressed tier.

So you end up, at best, in a footrace hoping the bear loses interest,
or at worst in a fight hoping to dodge its claws (generating poison on
some write that fails).

> On the device side, are you targeting beyond compressed RAM like
> devices such as memory with NAND etc.?
> 

For private nodes - I have been collecting use cases, but I haven't seen
a NAND proposal.  Unless someone is willing to demonstrate such a device
actually working without causing bus-lockup issues, most believe the
error-recovery overhead for NAND is too expensive to service cacheline
fetches.

> The TL;DR talked about mmap/mbind way of user space allocation from
> the private node. But the allocation is controlled by GFP flag
> N_MEMORY_PRIVATE. Does the user space path of allocation set this
> flag along the way?
> 

No.  Userspace does mbind() and it works - if the device's driver (or
service) has opted that node into allowing mempolicy syscalls.

The kernel injects the __GFP_PRIVATE for the relevant VMA in the vma
fault path if that VMA has a nodemask with a valid private node.

> And I believe the bear-proof cage might work in the normal scenarios,
> but may not work for all.

If it can't work for all workloads, then it's likely not general purpose
enough to find core kernel support and should seek to use the existing
interfaces (DAX and friends).

> We might not be able to rely on the control
> path (backpressure) fully. The control path could go slow, slower and
> even die as well. Should the device respond with something like
> 'bus error' if the host tries to write when it is not capable of
> taking any more writes?
> 

You need two controls over compressed RAM for it to be reliable:

  - Allocation control (acquiring new struct page to write to)
  - Write-control (preventing new writes to compressed pages)

Private nodes provide the allocation control.

A read-only mapping, and guarantee that only memory that can reach
the device is userland memory - is the only way to control the cpu
writes from the OS perspective.

(Bonus: page cache can't live here, because buffered I/O bypasses
 this by using direct writes from the kernel).

Slowing the bus down just puts you in competition with swap, and bus
error is basically equivalent to poison being reported at write time.

That's basically the whole story.

Loosening the write-protection can be seen as trading optimization
for risk - where the risk is hitting poison in userland-only memory.

In the next version of the RFC i'll demonstrate cram.c as a new swap
backend that allows for read-only mappings to be soft-faulted in,
migration on write, isolation to ANON memory, and some optional 
settings that allow a device or administrator a "writable budget" 
which allows some number of pages to be made writable without migration.

~Gregory

