Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E165C606A321
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 14:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BB9E6B0B86; Fri, 23 Oct 2026 10:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06C866B0B88; Fri, 23 Oct 2026 10:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4516B0B89; Fri, 23 Oct 2026 10:52:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD3426B0B86
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:52:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A68158011B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:52:11 +0000 (UTC)
X-FDA: 85354181262.28.2E19FAC
Received: from mail-m1602365213.xmail.ntesmail.com (mail-m1602365213.xmail.ntesmail.com [160.236.52.13])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8230D1C0006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:52:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf18.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.52.13 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792767129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XSYsF9HWbYppz9Cbcbdfh68sAbHvBzwUOKcY1+7QiNw=;
	b=rs6fLLy+QShiei7uLSR/ya64+KazsUY7F1fINC7QXrhYKXZZIwTRPYEM/xknVVcUpCjiNP
	5w0iRT71WG1fWFVkpALyYmX7rTtwnwm7PHqOOpES91o1roiQ7O8xDv/RPCzaoGoZ7n2aN2
	WaHZMAfCWMLs+MK5tk+wh90ZdRwMeFs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf18.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.52.13 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792767129;
	b=gUcBT20OG7+MCF+zeS6oQQvopL0gYRWCD2z/HoSaFPwal6xL0sdA70tpcuvYXU2OfwA5Hu
	zOlJuVBsRtsp67flUyOV/0bzBPQ1gUMjvwhy7vFV6uE2j/mjlRUa+dWzWU9K1fykuqYF4j
	BkgnxAqPUqodzmLyZNyUmphKaRm2byY=
Received: from [IPV6:2409:8a20:e23:2ae4:8810:8f74:8c26:2] (unknown [IPV6:2409:8a20:e23:2ae4:8810:8f74:8c26:2])
	by smtp.qiye.163.com (Hmail) with ESMTP id 206722931;
	Fri, 23 Oct 2026 22:51:56 +0800 (GMT+08:00)
Message-ID: <d39db4fb-e511-440e-9065-72c34a1a295a@easystack.cn>
Date: Fri, 23 Oct 2026 22:51:56 +0800
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
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <DMAURQCKK6CG.10CZ7MFXGJO3V@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1693f463b0229kunmd586c24b3116c6
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTx8fVh0ZS0gYGB8dSUgeHlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMaSUtBHklIQUkaHk9BQ0NKS0FDHUxPQUMYSU
	1BSVlXWRYaDxIVHRRZQVlPS0hVSktJT09PSFVKS0tVSkJLS1kG
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8230D1C0006
X-Stat-Signature: 9ewo7weykdtti91yzeuf37hckg731dia
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792767127-284555
X-HE-Meta: U2FsdGVkX1+Pel1ai0RFntsIuumyH3IaIDN/l69paA3L9Upm9Ftsdqm0S+hp+OvoTG75oRxgeBBOEqHeuG2M2QOptHZ+v4NoHBbVSep2we0M5cJ8zk83x9VZFXq491XVk9Wa+q9vS48/Q4oRoMSi7e3Eia34F3GQW7lIjhRb+4zt+q2MKOglvlrXEw0yCidDorPS6yF5/ZIvAVDmpAWo+9EgqKrqLD920VjeoScx7F7EHe3uqFEjWtqI4XHdluGm6g9sXI4tgTg/SQk4lHNadyMZSPEfZ648ttP0/EfNLKjNB/9EopxL3Ms+lCuCwOAU0bhWmEslo5th5kO0zlbBhKWih9Ywe0vGWaW3lQFC6gr0Y78BIviZ3dv6kqk58WWoRZpAU2xmnRZ7sKsNPV964NMMWakFadwbO5NZPKG2TBfabLsVL8D+k26S7m9y3wm4Lk42sYkvXF9GT6BUm/O4WenXOnz+JmzGPHYd5zNYem2qRK5l84bK0k0NWbdBudfUHa7NJ0gOsBW5UX0qcatlTipE4SmCtOkE8k6M/Tcd9XFWTdqaI2Yu90GLrQ0iq9X9qk/J9IU1RhQMaPJVYUXpl2ECRYOCeJ8ua6F6zhfM5G4JxFQoZN9Npv91aFnNcsk3CkjOoEZeVF+b6ZQ4c5RmV62uPDw04ckCuHxOyoR4ZUV4M7yoVz+oe4gIAhjlfM4c/NsXEXn8Mg4IYaYcc+rNSNPh8TaPMTBr/iKk1Ij9ZAOWLsObO7tEZnFNIGOBueME+7M8uru368lMVuxUxmF4VF2N8oUN6UyrgpqeNjSIIqtiku0SlivJL+fa4YAsrvn9gqST3o7YX3A/2cQv+7TlxwdoIR5zFFzvo6xAsMUGKPatUPG46mg2y160uR9P6EhChl2xz+lEc0ZVD6DhA9hQ7VE3M3SPNFE7ePzg1P1HutUnr8nEN6ePQt+lpfB+Kiwe1U7C8wP6CD+LefXOOD1
 1Xh8gxAd
 YVx8wTV8D4cBCalHYoC6+I14YwfaPcBEkGGOvmCZEn9tz64vhdJoG3CIi1H6jpWbKg5ztBHBd/xkj4Lf1tcq9LccYy+AKlu4m19qkukLQ/OqTY0y0QSh/uww5jtJY45olzrd+eH4wtDRv/Zt508TkagbpZVfYdJBFG44sRrcFNLQ4N8o+XnFt8oMF/MazI72RcnUzFeECQkB/NPAqzKe206c+lDE9I4Z0w++/dnFaHrJpdkcldBjh7U6XVRazWJDPDzf92qRFSa8iZSWfU42fdRZXnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 2026/10/22 06:00, Alexei Starovoitov 写道:
> On Wed, Oct 21, 2026 at 04:24 AM Zhen Ni <zhen.ni@easystack.cn> wrote:
>> Exposing the same walk to eBPF lets a program filter and aggregate in
>> the kernel and surface only the records it cares about. This series
>> adds that access as a seq_file bpf_iter target and an open-coded
>> iterator.
> 
> This is overkill. Two iterators, two kfuncs that print strings,
> a rewrite of read_page_owner(), a new file and a new header.
> 

Thanks for the detailed review and the sketch. I agree with the
principle that a thin data kfunc would be ideal if it were sufficient,
but I’d like to explain why the current design ended up this way.

On the two iterator surfaces:
They aren’t duplicate implementations. Both are thin shells over the
single page_owner_next_eligible() extracted from read_page_owner(), so
the eligibility rules exist exactly once. There’s no code redundancy;
the two iters only differ in access patterns while sharing the same
underlying iteration logic. This shape is also what Documentation/bpf/
bpf_iterators.rst prescribes:

When adding a new BPF iterator program, it is expected that similar
functionality will be added as open-coded iterator for maximum
flexibility.
It's also expected that iteration logic and code will be maximally 
shared and reused between two iterator API surfaces.

On the two “print strings” kfuncs:
These are things a prog genuinely cannot do on its own. The record only
carries an opaque stack-depot handle, and resolving it is not reachable
from BPF. Likewise, the cgroup path is built by cgroup_path() walking
the kernfs parent chain — a prog has no way to format it. Given the 512-
byte BPF stack limit, the caller-provides-buffer pattern (as in
bpf_d_path() and bpf_snprintf_btf()) is the standard shape for this kind
of kfunc. I agree they could have been mentioned earlier rather than
left to the diff.

On “a rewrite of read_page_owner()”:
This is really an extraction of common functions, not a rewrite. Aside
from the fix for mem-hotplug locking (which addresses a pre-existing bug
in the debugfs interface), there are no substantial logic changes. It’s
not a large-scale refactoring.

On the new file and header:
This is for code clarity — to distinguish the traditional interface from
the BPF interface and make maintenance easier.

> All that the prog needs from the kernel is the page_owner record
> of a pfn. That's one kfunc. The walk, the eligibility rules and
> the filters belong in the bpf prog:
> 
>    bpf_for(i, 0, ctx->nr) {
>            pfn = ctx->start + i;
>            if (bpf_page_owner_read(pfn, &po) ||
>                pfn & ((1ul << po.order) - 1))
>                    continue;
>            if (po.pid != pid || bpf_page_cgroup_ino(pfn) != cgrp)
>                    continue;
>            /* add 1 << po.order to a hash map keyed by po.handle */
>    }
> 

On why the prog can't actually execute it:

1. What range to scan. Where do ctx->start and ctx->nr come from? No
in-tree iterator context provides them, and a prog cannot derive them:
min_low_pfn..max_pfn, memblock holes, and offline sections are all
kernel state. The loop bounds alone require either another kfunc or a
kernel-side walk — which is exactly what the iter target already is.

2. What makes a page eligible. The alignment test in the sketch is the
only part the kernel agrees is expressible in a prog. Everything before
it reads state a prog doesn’t have a handle to: pfn_valid() over
MAX_ORDER_NR_PAGES areas, pfn_to_online_page() under get_online_mems(),
skip_buddy_pages(), the PAGE_EXT_OWNER / PAGE_EXT_OWNER_ALLOCATED flags
in page_ext, and taking the record snapshot inside the RCU window so the
checked value and the reported value are the same copy.

3. The walk is deliberately lockless, so exposing struct page to the
prog is not safe. The pfn validity check and the page_ext dereference
must happen under the same kernel-controlled RCU window. Otherwise the
prog could observe offlined pages or stale page_ext data, breaking
consistency between the check and the snapshot. Keeping the walk in the
kernel guarantees that the page_owner record is read atomically with
respect to mem-hotplug and RCU protection.

4. One record doesn’t give the prog the useful data. The record holds
only opaque handle/free_handle tokens; stack-depot resolution exists
solely in the kernel. The memcg is neither in the record nor trivially
reachable — the path is built by cgroup_path() walking the kernfs parent
chain. The NUMA node comes from page_owner_get_nid(), which bypasses
page_to_nid()’s poison check. And so on.


Thanks again for pushing on this. I’m still concerned that the sketch
may not be workable in practice, and that it would also lose some useful
capabilities. I hope the above clarifies the reasoning. Happy to discuss
further.



Thanks,
Zhen


