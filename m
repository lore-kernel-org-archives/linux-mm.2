Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B152606A31B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 02:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2F66B05B0; Sat, 24 Oct 2026 22:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 183E36B05B1; Sat, 24 Oct 2026 22:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 073476B05B2; Sat, 24 Oct 2026 22:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2BD46B05B0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:17:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F8F1160545
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:17:05 +0000 (UTC)
X-FDA: 85359536010.09.623474A
Received: from mail-m2481.xmail.ntesmail.com (mail-m2481.xmail.ntesmail.com [45.195.24.81])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3DB7E180002
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:17:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf06.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.81 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792894623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FnEFDsNw6/OpFTmHzBgKlLwdZuANPYxCz09uyvQgX8A=;
	b=EQipwNCCAx9GB5LN0dDnLxakFp7td/UubxhtHxaA/0P6wwqkFlVYfpKideCoAJQh+ZOP03
	d7jGZDmQpuskWBhKSiU4e2PpPZNc/cl8H4Du7kGLj3odH3Bgzoh7JE1oIrdvLRpDSstiVg
	HUscJFUZdBAC5OSUpfd9wJ0kQwd1SuI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf06.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.81 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792894623;
	b=hmkEA3RDoR80VBbo/yk61NLD3NHHMk5VWMdU3uzcX1o9YT7Qs1bkE3LjXYTLkqzJCZANO9
	nJZobf0LweXUUulnS8D9/HpGBITKbEUpWb6CMMzfouc559jTenCjV2TCkwS76VNdy7ss7j
	Qiy8DGztJ3WlJSrNz0qXLdC3eAAXBBY=
Received: from [IPV6:2409:8a20:e23:2ae4:8810:8f74:8c26:2] (unknown [IPV6:2409:8a20:e23:2ae4:8810:8f74:8c26:2])
	by smtp.qiye.163.com (Hmail) with ESMTP id 206d49bda;
	Sun, 25 Oct 2026 10:16:54 +0800 (GMT+08:00)
Message-ID: <7f9a9da5-1250-4be3-bfa2-70e4b6051197@easystack.cn>
Date: Sun, 25 Oct 2026 10:16:54 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] mm/page_owner: add bpf_iter and kfuncs
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, daniel@iogearbox.net,
 andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
 martin.lau@linux.dev, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
 ziy@nvidia.com, shuah@kernel.org
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261021112437.1799213-1-zhen.ni@easystack.cn>
 <DMAURQCKK6CG.10CZ7MFXGJO3V@gmail.com>
 <d39db4fb-e511-440e-9065-72c34a1a295a@easystack.cn>
 <DMCCBEPCIWH0.2JEDKE64WPJRQ@gmail.com>
 <06925440-8df8-4f2e-aea0-ede1a98435fa@easystack.cn>
 <DMDAZW82I9LT.3FNX2WI80GNE2@gmail.com>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <DMDAZW82I9LT.3FNX2WI80GNE2@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa170d8bcd60229kunm6cc80f93366ac1
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaGE0fVkNMQh0aGRlCTUgaHlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMaSUtBHklIQUkaHk9BQ0NKS0FDHUxPQUMYSU
	1BSVlXWRYaDxIVHRRZQVlPS0hVSktJT09PSFVKS0tVSkJLS1kG
X-Rspamd-Queue-Id: 3DB7E180002
X-Stat-Signature: 1utngoq97hui7e4xzrsdaxzddgmpmzks
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792894621-380312
X-HE-Meta: U2FsdGVkX18SxVRD9VFYr7pby3487diYRNq1fhJAZwHk6ac4Utq0r37c9NMTBBsZPMwIVPoSqPh5m92f00bQ0GM+MScUwtwRxqiPFmLUrB6ER55vR5yy26/m1razF3BGYqtcIf51G3jDTy3F+jZFi/HyT0JsnD6dak8jOgfpmyMrr6x9RHeNIz9dzVUIp+w+IVouf6LKY2lEYXIzpR+TOVtRHpUTFp1T4D558vquznLmNoMaheDz6xazPwNcdrXnUPh5/URdsYfmdshRwQ+8ZlMfWnIAWX8u8jdrVY+kHVtl8Xp/uqr2vPYKi6uPfM5ff+17WhOzwp7I75NmqkHJtqpVvnt7qUCTq4hZoTnkpHpTPHa3dE83NO/GC+iUAyf9yZM6u8isLu6mjXzZGrNHhJgGvwWWRs9EEfwxb39qGauVvdBHUjsinEBJ0Xq5yLRtl9ZQKq3EZpizQfaaMSIr3He1pwjslF6lNuSa20mIbSKBr/mKzTvmDVg/xHtt6muluojaUJYdsl4ByIw7QBMPJIa7TK7C4yrnuCfIhtRwhoofq1C9ymfkaJmytAbrh37p7ft98a+sVSa3ujeuWIJhuc57YwWWcH4DNEW0VE46MlhyKOmdt6oNe/M9zhXWCMZ6HZCasLQh6Pm9PtPessXbyLMuDQxy0eKW7NuJ/Fewm12lVTj3FEBKrxIksA2XlN/fGJ+iwSBC904lzXnV8Tbq62Ko/mnl9kzwiE7GuDiNfXz/dXc/zhbDdu0KigsSGKi6soZHGiyaILJxtyZWnap3MCsADqHIHiLKffmfdoCaeggqS2sNT1c7pf3F+TIK0ximwpo7VUn2/VTRbmDj8Ep7g0yedkx36SoVjUf0yRzT2PgwJzgH85hrp+YpY/ZXXzlPXKiLUvurX5kATmlT0ePeDV30GenuskdoEhyDawn0DLJUj/LWbZg9eXhGQq8wMomOjCKSPPuF1JEhGE3SMfs
 9J1X+RBq
 H5WbUJSJfQIjfxLtP4GFB4r3jtdoyqX2wCwhzQ0ptmttB24bzELMkVSEFm01pTwfBeGSkGoLrodAvHVcl6rcCMqeB/+jvetusmpZJ0HNNwnRiHZ36vY1g1VlOOF5MBB+91htn1a1xKDej0J5ftIh1KbRFtsqkC9Av7R9S2MOAxFiWPN8ru1xD3z8ve6ZtQIMmulqcoFT0HVziFZWAePPG60A/wFKWJijFbyPt1+QNjcC2FRqE6LZCloMW7oteEd7cdd4wnbmv2mnYzkjE8vGvx/KH3Gy34zCjb3Ioso8OMLnwQnfivDKxBHmZ5kUM3vKng5Fo2jEPwP4baThwnGPBCwhDdb/PwhMujM9QSkKqT2N7EUPnx9rDIvdWwJT3utWNnZMCJb3GN0jZQWkuxWLS5UAO1DVuUgQ7vvvB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/10/25 03:08, Alexei Starovoitov 写道:
> On Sat, Oct 24, 2026 at 10:19 AM zhen.ni <zhen.ni@easystack.cn> wrote:
>> For this one node alone, about 97% of spanned is holes. With
>> bpf_for(pfn, start, end) plus a bpf_page_owner_read() per iteration,
>> that is at least 16,712,944 kfunc calls, and bpf_for has no scheduling
>> point inside, and all of them are wasted work. The gap grows with memory
> 
> Right. spanned includes the holes. So don't pass them.
> /sys/devices/system/memory/ has memoryN only for present blocks.
> /sys/devices/system/node/nodeN/ links to the blocks of that node.
> /proc/iomem has "System RAM" ranges.

Thanks for taking the time to review this.

 From /sys/devices/system/memory/ you get a discrete list of memory
blocks. The prog (or userspace) still has to walk those blocks, handle
boundaries, and track progress. That is traversal logic that an iterator
already absorbs into a single next() call. Pushing it out just moves the
complexity; it doesn't eliminate it.

Therefore, this only demonstrates feasibility, not superiority.

> 523024 pages in a 32G node looks like 64K pages.
> Then the whole 256G box is 4M pfns.
> When a hole is passed anyway the call ends at !online_section() in
> pfn_to_online_page(). /proc/kpageflags does that plus put_user()
> for every pfn, holes included.

True, the kernel safely returns an error for offline PFNs. But paying a
kfunc call just to learn that a PFN is ineligible is exactly the waste
the iterator eliminates — the kernel-side cursor skips holes and
ineligible pages before the prog ever sees them.

> Syscall progs run under migrate_disable() only.

Agreed, migrate_disable() pins the task to one CPU without disabling
preemption on PREEMPT_RT. But being preemptible doesn't mean the loop is
free — an 8M-iteration tight loop still consumes CPU, delays RCU grace
periods, and piles up softirq work. Skipping ineligible pages up front
reduces that pressure.

> 
>> front. The spanned of this node is already 17.23M, so a single bpf_for
>> cannot cover it; you have to split it into N chunks and poll, with the
>> chunking state kept in a prog map, i.e. a loop nested in a loop.
> 
> The loop over chunks is in user space. One bpf_prog_test_run_opts()
> per range with start and nr in ctx_in. No map, no nested loop.
> 

The outer loop being in userspace doesn't remove the chunking burden —
it just relocates it. Userspace still has to parse sysfs, construct
ranges, issue one syscall per chunk, read the map, accumulate results
into a global aggregate, clear the map, and handle partial failures. And
in the snippet, i is an offset within the chunk while start and pfn are
64-bit — the chunking arithmetic itself is non-trivial. An iterator
absorbs all of this into next().

>> for 52-bit PA. A 32-bit PFN range will overflow here.
> 
> The snippet was:
>    bpf_for(i, 0, ctx->nr) {
>            pfn = ctx->start + i;
> i is an offset within the chunk. start and pfn are 64-bit.
> 
>> Solving all of this requires yet another, more complex kfunc—and it
>> looks increasingly like bpf iter. So why not just use the iter?
> 
> Nothing of the above needs kernel code.

Feasibility isn't in question. The question is whether we want every
prog writer to reinvent this traversal plumbing, or let the kernel do
what iterators are designed for.

> v3 is +474 -83 lines on the kernel side. The diff I sent is +55 -1
> and it doesn't touch the debugfs path.
> 

That diff includes my improvements to the page_owner infrastructure, so
the line count doesn't really establish that bpf_for is better than
iter. The iter approach only adds an exit on the debugfs path — thin
shells over the single page_owner_next_eligible() extracted from
read_page_owner(). It changes no logic on the debugfs path (aside from
the mem-hotplug locking fix, which addresses a pre-existing bug in the
debugfs interface).

And the fact that the bpf_for approach doesn't touch the debugfs path
is, if anything, a disadvantage: it means two sets of eligibility rules
would have to be maintained going forward.

With the iter approach, any future change only needs to be made in
page_owner_next_eligible().



Thanks,
Zhen


