Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF371606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 17:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3CD36B05B0; Sat, 24 Oct 2026 13:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEE1C6B05B1; Sat, 24 Oct 2026 13:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D035C6B05B2; Sat, 24 Oct 2026 13:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E95E6B05B0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 13:19:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E280803DC
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 17:19:58 +0000 (UTC)
X-FDA: 85358182476.29.9A93430
Received: from mail-m2484.xmail.ntesmail.com (mail-m2484.xmail.ntesmail.com [45.195.24.84])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5CBCD40009
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 17:19:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf04.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.84 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792862396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sd+yctJGX58GYgR2VMHbAaQET091sbKp1a2O1nu6sRY=;
	b=DJe9saU2tt9Ky1vJsxZR5wheXf3/fcf/s94DMmrwPTXzxIC1Wai4jfrRNnCbLpadjRs3TL
	ZwfiAbs1no06GIeJ1+Ohq0c2q7iL+epFfIRuYvEl7W3aGfVvmAAMHRx5pjBVF3nTpNFzJO
	H+KPzASn/To1JH/LrIkIgVcKWqhvRus=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf04.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.84 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792862396;
	b=PVDHD+svnz7uWXdB7AD3UboXcrsbviH1ZhOBckdpWpTRu9jbvHX+UbiuFGl4Fp4D1RJLv/
	xA3rG5Nzzbid7OiE1s6lepNToxVoVNHtVIT8bFGqGQafBjfkG0KWBNfohAjLc4KMPe0NdK
	HXoM9bx/REjYQ9fbfPgX6LavWyD0j7U=
Received: from [IPV6:2409:8a20:e23:2ae4:8810:8f74:8c26:2] (unknown [IPV6:2409:8a20:e23:2ae4:8810:8f74:8c26:2])
	by smtp.qiye.163.com (Hmail) with ESMTP id 206c2f1c2;
	Sun, 25 Oct 2026 01:19:47 +0800 (GMT+08:00)
Message-ID: <06925440-8df8-4f2e-aea0-ede1a98435fa@easystack.cn>
Date: Sun, 25 Oct 2026 01:19:47 +0800
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
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <DMCCBEPCIWH0.2JEDKE64WPJRQ@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa16eecfd8c0229kunm0bf4aa98351e65
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCHUlLVk8fH0IaGkodGEpMHVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMaSUtBHklIQUkaHk9BQ0NKS0FDHUxPQUMYSU
	1BSVlXWRYaDxIVHRRZQVlPS0hVSktJT09PSFVKS0tVSkJLS1kG
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5CBCD40009
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: 4cp4xtq9a61339prfq3i6bw4nq7s7sjd
X-HE-Tag: 1792862393-899420
X-HE-Meta: U2FsdGVkX1+AKU+a1Gct9s7TDC0BNtSAGQ9q07yEq9DRNfSOThiMJKlRYUSEmedyFm8+TH9e1zqk76XI4aOqG8Z5LsrLHs4TvW6qTJx8TPejm5VoJJg1bLNS7cFW4JhJ0196m8v+bqZcc7XAEwL3qXP4+7VIZUkl6JxThKQBwVre2ExBKdzKImzYTBi6ImZ6jg4CwCW3nDlJdt8x6QqsYOdNtm2wNHGhyGwavL8TFgjhGdpnUKT1DG7WmP75buKivI18OBeIvl4C79TLSDtB2qZhHJlGeOM7OcGUdEbE6Q8UIpmDE/7o/hA783HxzbQ5W5vdbVKucYOEd+m+CPpIrdzIg1F2XQ7bG7uDSS/xXMrhBJM48O562G5yscATHoBK8H+3MirkYC+GEcr9rnCvAGBBI2x54zauV1TnoPqXUoe2z1dnX/CjNSiJVO9iGoWgO7K5mX4uxkDomxkYGTsmyBz/vTTwioi3nWzih1btYiz0Q38QPKfMKXJKEUc6YfbeBG16FhfnJ+MOwphUQi3lQv2amVOSXn5Qnhup4Fedz4+zmEdwAloEvjUrDBtSuiY1EF5Ggc0CtfF3WSokMGH6fDHxSuhnbVjFQYxO9ljJNENi157Wp+vGS2fIjVer27hecNw03++V8xHtr5sr38O6K6ihCsROMpE0wH+QBUk+PJi+vIloFqUcMyBjHGNvYe/GV2Kzy9K4lN36fqVOFUWPaT7HQ/KIEuB4AWtI2xRuMebj06N9hifPZV/J+o/i5AZZhobsQB55AsYIW7VOPmo0lyPEPHbjZAovZxMQ2Hq8bwSWLiSYZyu3PKRjoyl2kUcnNZk4oBY8BxazHz2cBR1km4rz8/DWs6ivK7qGntykxZbfi80OYLN4MO1KF5/mJfsvX1vgVtUgLXkWp5fD1nIgF1u2vFGksQlV8+9Etis1FQ3tNm0Ee8vKvjZLL/jrd+gzU1IDIzdS0Wz5eFjxiV7
 0SBRABkk
 pjJ9DioZvkpH+jYsxbgUjhzA1Abr+Rhqk71hUGPETOJ6UskrXUaNQ2CQC20qCWWbaDAPqhMtuXjUHY1VdDuQAAzp1PdEUf9T0rOVgxHPOA5aRkLrBXYB8BSc2fcOiHl23OF8/aIxBOry/97bC64B2tD4g7z9uTRcH70Z0QgagtDsO8JVGGH3XfdFqItBNlrgj6CZtqdTK2FoLRTzxiLIyHU4mwjA2jpHv/17KDFggz72xmZYkmqpkuLummRdnj0sm0hSrvteTxWD9hGEMQAsJ6GgVfqHjpEnYhCbPj0oPfQTT7w33UKcuBf4S6ACkx6CS0a5EXnjL08REmhA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/10/23 23:58, Alexei Starovoitov 写道:
> On Fri, Oct 23, 2026 at 07:51 AM zhen.ni <zhen.ni@easystack.cn> wrote:
> 
> tldr: it's still nack
> 
>> underlying iteration logic. This shape is also what Documentation/bpf/
>> bpf_iterators.rst prescribes:
>>
>> When adding a new BPF iterator program, it is expected that similar
>> functionality will be added as open-coded iterator for maximum
>> flexibility.
> 
> It says what to do when an iterator is added. It doesn't say that
> one is needed.
> Iterators are for kernel data structures that a prog cannot walk
> on its own: tasks, cgroups, kmem_caches.
> pfn is a number. bpf_for() is the iterator.

I agree the doc is prescribing what to do when an iterator is added, not
that every case must have one. But my point is that having both
iterators coexist is the convention, not overkill.

Page owner traversal looks like iterating over PFNs, but PFN is just a
number; what is actually being traversed is page_owner records, buddy
blocks, online/ offline sections, memblock holes—kernel state that a
prog cannot see on its own. So it is not a pure numeric-range walk.

> 
>> 1. What range to scan. Where do ctx->start and ctx->nr come from? No
>> in-tree iterator context provides them, and a prog cannot derive them:
>> min_low_pfn..max_pfn, memblock holes, and offline sections are all
>> kernel state. The loop bounds alone require either another kfunc or a
>> kernel-side walk — which is exactly what the iter target already is.
> 
>  From user space. It's a syscall prog, like scan_open_coded() in your
> patch 7. Its ctx is what user space passes in ctx_in.
> /proc/zoneinfo has start_pfn and spanned for every zone.
> In holes and offline sections pfn_to_online_page() returns NULL
> and bpf_page_owner_read() returns -ENOENT.
> 

I agree the range can be obtained. But being able to obtain a range is
not the same as that range being meaningful to the user. Page owner
users typically care about a process, a cgroup's leaks, or the global
distribution; PFN is just a physical address index, and users almost
never know in advance which zone or which PFN range to scan. Letting the
prog specify a PFN range raises the bar for writing it while the
practical use cases remain limited. This is not a feasibility issue—it
is a question of abstraction level.

>> 2. What makes a page eligible. The alignment test in the sketch is the
>> only part the kernel agrees is expressible in a prog. Everything before
>> it reads state a prog doesn’t have a handle to: pfn_valid() over
>> MAX_ORDER_NR_PAGES areas, pfn_to_online_page() under get_online_mems(),
>> skip_buddy_pages(), the PAGE_EXT_OWNER / PAGE_EXT_OWNER_ALLOCATED flags
>> in page_ext, and taking the record snapshot inside the RCU window so the
>> checked value and the reported value are the same copy.
> 
> bpf_page_owner_read() in the diff does all of that:
> pfn_to_online_page(), page_ext_get(), PAGE_EXT_OWNER_ALLOCATED check
> and the copy of the record before page_ext_put().
> PAGE_EXT_OWNER is set together with PAGE_EXT_OWNER_ALLOCATED and it's
> never cleared. No need to check both.
> __reset_page_owner() clears PAGE_EXT_OWNER_ALLOCATED, so
> skip_buddy_pages() and MAX_ORDER_NR_PAGES steps only make the walk
> faster. They don't change what is eligible.

I agree on eligibility. But I'd like to expand on "only faster": what
those steps change is the scale of the walk, and under SPARSEMEM that
scale is structural, not a constant factor. On a 256G, 8-NUMA machine I
have, node0 is:

crash> struct pglist_data ffff0106ffffe580 | grep node_spanned_pages
   node_spanned_pages = 17235968,
crash> struct pglist_data ffff0106ffffe580 | grep node_present_pages
   node_present_pages = 523024,

For this one node alone, about 97% of spanned is holes. With
bpf_for(pfn, start, end) plus a bpf_page_owner_read() per iteration,
that is at least 16,712,944 kfunc calls, and bpf_for has no scheduling
point inside, and all of them are wasted work. The gap grows with memory
size, and I'm concerned "only faster" understates the runtime cost on
real machines.

One more structural issue: bpf_for is capped at BPF_MAX_LOOPS = 8 * 1024
* 1024, and this is a runtime check—the verifier will not reject it up
front. The spanned of this node is already 17.23M, so a single bpf_for
cannot cover it; you have to split it into N chunks and poll, with the
chunking state kept in a prog map, i.e. a loop nested in a loop.

And cur/end are stored as BPF_W (32-bit), while the PFN upper bound
tracks the physical address width: on x86-64 with 46-bit PA, max_pfn can
reach 2^34, and 2^40 with LA57; on arm64, 2^36 for 48-bit PA and 2^40
for 52-bit PA. A 32-bit PFN range will overflow here.

Solving all of this requires yet another, more complex kfunc—and it
looks increasingly like bpf iter. So why not just use the iter?

> 
>> 3. The walk is deliberately lockless, so exposing struct page to the
>> prog is not safe. The pfn validity check and the page_ext dereference
>> must happen under the same kernel-controlled RCU window. Otherwise the
> 
> The prog doesn't see struct page or page_ext. It passes a pfn and gets
> a copy of the record. The lookup, the check and the copy are in one RCU
> section inside the kfunc. offline_page_ext() does synchronize_rcu()
> before freeing page_ext.
> page_ext_from_phys() does the same lookup from any context.

I have no doubt about feasibility.

> 
>> 4. One record doesn’t give the prog the useful data. The record holds
>> only opaque handle/free_handle tokens; stack-depot resolution exists
>> solely in the kernel. The memcg is neither in the record nor trivially
>> reachable — the path is built by cgroup_path() walking the kernfs parent
>> chain. The NUMA node comes from page_owner_get_nid(), which bypasses
>> page_to_nid()’s poison check. And so on.
> 
> The handle is the key to filter and aggregate by.
> page_owner_stacks/show_stacks_handles maps handles to stacks.
> Same for memcg. bpf_page_cgroup_ino() in the diff returns the id.
> st_ino of the cgroup directory is that id.
> 
> 

Similarly, I have no doubt about feasibility. I do have some concerns
about data consistency and performance. It also increases prog
complexity.

In summary, while I don't dispute the feasibility of the bpf_for +
bpf_page_owner_read approach and fully agree that kernel-side simplicity
is paramount, I wonder if we should also weigh the complexity on the
program side. If using this kfunc imposes a steep learning curve, I'm
concerned it might limit adoption. If a feature lacks practical utility,
it becomes difficult to justify the effort.

Thanks for the detailed explanations and for walking me through
these points.



Thanks,
Zhen

