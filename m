Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AFABCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 21:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 529998E0006; Fri,  5 Sep 2025 17:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 500F98E0001; Fri,  5 Sep 2025 17:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43DE98E0006; Fri,  5 Sep 2025 17:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 355C08E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:21:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1FB5C0342
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:21:04 +0000 (UTC)
X-FDA: 83856466848.13.189A952
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0E55914000D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:21:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T92UJ6nl;
	spf=pass (imf23.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757107263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=osQ9Lif183itocSuB65QNUmR7DDdBX3nJ25Dd19v7/A=;
	b=RDGLzdYj9jdxSHWi61YufRvI4A+GGi6a0Hkml4ZNBfci4X1RVIvOzJwby9uUtTXmLGWkcD
	aS/Yho0psAKnF5D16YekyNzm3gqX8f5cKd3aWn6ktX/4xswEWclMzFvVHJmFFiS2DHAfjV
	mkZSp7WqP70xGJZB1JRlaZ04NomJk40=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T92UJ6nl;
	spf=pass (imf23.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757107263; a=rsa-sha256;
	cv=none;
	b=iKz/TXSya7i+Bww3V9HLmXZ6sNn9dXwZMZtDEoOteCbgO53NKWJiQwfmAutT0uJPPHBQZe
	PElNkuUWjKm6akFM6+kGLS7S8ZBYrCyAoeLvXGZOCpmoc6TYQL6D0JhBDWjt+eXqe0nmMV
	mN4GKiOUgNmC/yu2JSMimZxPRtb3U+c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757107260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=osQ9Lif183itocSuB65QNUmR7DDdBX3nJ25Dd19v7/A=;
	b=T92UJ6nlCLVsFWAjC543fR6YxZ7eSKX4N/EozztC9mQXQQZDNQpa1JqppUr7HfB/1DqVC1
	eMMGdMAl5kM/wbqM9bnCE4A7yj8zaOMAzfc1girqTcnRs2VN1F4AGpd0+z+Rm87itDCCbG
	IVdmYsC+5yZnrIvGVfOGBtML1s5j1Pg=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Tejun Heo <tj@kernel.org>,
  Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,
  Muchun Song <muchun.song@linux.dev>,  Alexei Starovoitov
 <ast@kernel.org>,  Peilin Ye <yepeilin@google.com>,  Kumar Kartikeya
 Dwivedi <memxor@gmail.com>,  bpf@vger.kernel.org,  linux-mm@kvack.org,
  cgroups@vger.kernel.org,  linux-kernel@vger.kernel.org,  Meta kernel team
 <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
In-Reply-To: <20250905201606.66198-1-shakeel.butt@linux.dev> (Shakeel Butt's
	message of "Fri, 5 Sep 2025 13:16:06 -0700")
References: <20250905201606.66198-1-shakeel.butt@linux.dev>
Date: Fri, 05 Sep 2025 14:20:46 -0700
Message-ID: <87y0qsa95d.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0E55914000D
X-Stat-Signature: esa86rra83zxxkk4pkehrobu7nfwhngo
X-Rspam-User: 
X-HE-Tag: 1757107262-765122
X-HE-Meta: U2FsdGVkX187OUIeVKk9TqY7XuzBahQ7pSrLOIaXY9AxSexPwI1+7WJrPG84NalTlDRGY/YiR1383Qf/ST9LFSPs2nGWEJdjNfm5N5xcFg7Bhlca4bdeuBj5gZAgkcvsRwDFjwhNs7SznTGKiYdoy3jpOPz2PlcahOdiojKYFYOoMSxU6i3FJzyQ4YR+MWAV9auPq95Mo49OUzXMqBfMBqIXoMdK7bL84lzqgBx37oSDanOt4DPHPhvjDvwz8ABIL7n1TWyvAlu9WoYjF7JQ9Qc48MvdBmhpTa4Y48DWot3WJIv3H7qCJjjcnE8ug3TdCCzbVvwLLtxz5eY02uJiw8rYmTyjpVHFcmCKbgkJMe88znHRzozEN3+Mzr9f1bY0iIo9VPmn1Md7Blw0VG9+qF8NKwmZ+ZY5pJOQvgro8J1NUCAYT0qyWaAxBVMuKqPZynU15MQvPkANKvAwT5Zlo5u6AZOLP+nyuldLdThtlI3bBorLeHX24dLzvmUUFta7mKYNabFSGPmASNiui5H5sm2pdcX2a9gCfE4fJHU8YGVnfzwGqqAwtSUHlHI2BypHwRSivJU5p2DNN7H+I/r3Gm+6/xLINiiAI48Jah+Los7r5yNFctuGRBb76ME/RLx6G7RS1/BxmppeIsYT+mXPDIa84gyP4zx5l9ktgbSo0Bc9Mo9RJn8waHICLnKhv8uZKiwUW3o/hHO9OCkXVVePpyfFA7qgmBzZgzKkAZfcyqFu+O85OqnC6Ro9Uji3t1U/HH5PNP4qNhKqdxY7EOwMfe4jkdhLi0YG4mxNjYL4D0oAi4+hxnyTJtWC43YKpyW55lpVM+/UMOWruKqErRr0yiCp8zRvHSrRL2jlBBw6u5MLd25X+1jjzd90ggmZjFr4HKRmlYBWw7neubIbHFK0cElIYsFL3j5V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> Generally memcg charging is allowed from all the contexts including NMI
> where even spinning on spinlock can cause locking issues. However one
> call chain was missed during the addition of memcg charging from any
> context support. That is try_charge_memcg() -> memcg_memory_event() ->
> cgroup_file_notify().
>
> The possible function call tree under cgroup_file_notify() can acquire
> many different spin locks in spinning mode. Some of them are
> cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
> just skip cgroup_file_notify() from memcg charging if the context does
> not allow spinning.

Hmm, what about OOM events? Losing something like MEMCG_LOW doesn't look
like a bit deal, but OOM events can be way more important.

Should we instead preserve the event (e.g. as a pending_event_mask) and
raise it on the next occasion / from a different context?

Thanks

