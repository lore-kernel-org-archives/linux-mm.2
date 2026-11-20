Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C92CB606A330
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ne3oG4JV
Received: by kanga.kvack.org (Postfix)
	id C60476B00EF; Fri, 20 Nov 2026 04:47:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10B96B05B0; Fri, 20 Nov 2026 04:47:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFEAE6B05B1; Fri, 20 Nov 2026 04:47:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 731A36B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:47:20 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 09A23A8C59
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:47:20 +0000 (UTC)
X-FDA: 85455019440.26.EF9165C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 37EB3100003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:47:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ne3oG4JV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795168038;
	b=3Vg9/B5JWCbI33ba5+f5yUuNDcNG5bCYcYoOPZH3D4UwX/lTzRIPXOHdmHYEYgX7b80BAF
	OT45B6qInWdF2rlf3VMl7P9tg5+ym1Siz9pMiuy2TelZiEQ41YCMbtSZgg5KJh69NCEhUy
	YdlJzsnUkdoT0rDeU+FJaHuKFIKyGhw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795168038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9TK8Y60rG8NiKouFkfePiFMpKuLWEFIntD2PEI7ua3I=;
	b=O+NLPfdEfhwuVu5hRt9N5shSbyBPxrlHnO2Zu5IsmFi97EVGtqPVQBf+ZJx5Hv/HgnXkTm
	+3VDBRUyfAvLl1TrALC7f4G4rDISQwagwfcJwSxHc2ha5IkYi04G+2x5YU3HnzkYJxHJEj
	YPcWZ0lFk2CJdssHsuDKmw18286dsL8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ne3oG4JV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6733946389;
	Fri, 20 Nov 2026 09:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095541F000CA;
	Fri, 20 Nov 2026 09:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795168037;
	bh=9TK8Y60rG8NiKouFkfePiFMpKuLWEFIntD2PEI7ua3I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ne3oG4JVdPmgZgBSBUAKVcKzck0RKZwwGx1CgeztImWh8/N678rI4M0NcrTIpNV6o
	 944+Pkkq4H6UHhDVeZr77IYLqWP6xQZhRga2edYuWmlonTU0mzGsmtf29GtydGCs4y
	 VR0ibtZUjU227lmj9HELs0tDPCAeqC3veD4gBssY2SkRPOvKZBN9t5sM0eraTMdr73
	 aBxr/RSdBVRCKv9QmWl+Bd0Gg2bt9Wb8rSp5+s03Yg8O+bCO8GcA+QRPcwdK+QTiHI
	 45e6JAlDHwVlIaWRdEB5lmugYhKreo6eAhy+QNwR5MI4k+LHMisYaq9KlTvLQ3n/xl
	 FQ0KCjAjlurIg==
Message-ID: <73c18685-8115-4ee5-876d-a276902488aa@kernel.org>
Date: Fri, 20 Nov 2026 10:47:11 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] rust: alloc: reject offline NUMA nodes in allocator
Content-Language: en-US
To: Franklin-Qi <yusq77@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, linux-mm@kvack.org,
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>,
 Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot
 <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Uladzislau Rezki <urezki@gmail.com>, Harry Yoo <harry@kernel.org>,
 Georgios Androutsopoulos <georgeandrout13@gmail.com>,
 Vitaly Wool <vitaly.wool@konsulko.se>, stable@vger.kernel.org
References: <20261120021633.12274-1-yusq77@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261120021633.12274-1-yusq77@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 37EB3100003
X-Stat-Signature: cf14su18fr6czh6r1fc9tc5us5im5qo5
X-Rspam-User:
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795168038-991031
X-HE-Meta: U2FsdGVkX1+YI0W8v7SRCWXeqfAkD8da/+vpBgrjuowQQahCUUjqx9TYkLhgCPFr9RG1V+2XDpNzY0A5IsyWIjjqCB5/vi3fbiJnci720x2C+jksHhSclblXpe73NztIHf9uN0pS/Ip8301IKn2+X/GEJ2UEZtZfUAohNvTCOrDvKrCJoGscJIM1M/FT6xQCCNmH8r/17I6NpBZsEX0HrZLecI9fJUQmkjCE9e4Bt3EVsxFNobl/DkEkGut/RVeJKGY1rq/Ar/2FoxBxZYR2cEGEJINIMx78r/gZEJ9fGz1hhC41/nzCbQLb58YATh+g+PCvTWtqPoam4fZAI0oSJ0kcK8Fnn9Jfa+oXSVJLaK+8ZyFm8eACLxIvhAX1IaQiW+aROCuyrX2aSLpn2uQHaLIv2ZVTCvq+XlO45DfmtuIIJqrJn039T+XylJ+HqEZFhY0YWvdPmgrawzrYeLf4cJN1Qn+S/+ATuyPKfX2tVb5qDsmypr0aRQH6Awh/hkj0BXShiOV9zG7v3dAvxFgXPWLjSX0PFn63kAFJcqJrqARiMKsKE6whxuASOZr1OyL8JSmTq7VEOyJP8ulDBs8qVgYRKhNOoipUvQ6dtOgPYi3XEhGf5GqZHNMu76h5+RAv68n6eD6bM61zyfOX1LnKHoA7iJjPtF+kKIkfZRiDSP0wZJm8ZHGghsZUxm81pF3OncQ/Z6P40qadrVqVsnF3qRCwRUqCh7SSPFvt3bvPpI3wmVd3kSWR0qO9zOggiInC927pVGA2SUUtSmAB323hllYVprHZaD4JEC1NICJAPLOc/1DgGQGET+wc4hcPPratn6atDSQ5/IZRMPyFvgYalEd0CaCPN62tQFhqbPa7Ftd/lgALmWBOdAMO2LFGFoO706N6Vd8DNSnJHLKUbMli7EGwL19ABIW2f2sAgNTTDgNuQiTu4izED/X/BRi6+fBiIj6OpQxGHgvbOEKy+QL
 y/KkV/p4
 CrxxEZ3Qp/jsSDv4i7ncnCcL/f6JMDhbWLBqvph1uK9fA672ADSCgxxiKW4ddV8nT8sUqGDsl4/stENqZmMZq97udK4hja9kIrPV8a+qJq3sxyFZSvh28pemWG2yp36ePA2s4B3r8ZEMmrhRRPDdaxMTQgpwuohf+XFOzF7prWYVbgndY0/htI04qtabOfmjau/M/d+SjAYB7NBr/st2UEN+8EZPSzJnls4pqR7/wGhj5IV2yHauicuSQhlrWNiPoCXZOkvBI+K2ySXrKzALT0Y8Ax6R+xhTbf/lpnTdh42tQbycoojzToKsh4WBm3MsQbzAvJJf+ulio02XMHsLNgeVAhv0CMaScMyVElOO2M+4VoneHYG8VflbpVHKjGeae0EWbhQ2VONINzhJsIrsHOjMqgXvNDfeDtY/kaK0YuCBhq6kJ8rwLBU2aV/bS1FC3SMN1/ZxD+LbfAltSBsihPn5MucRk4hmGcNFVxGoxGPKdCJDy5Aqidpl4qB8AIFJ8bBWcs42i3wyJVxBZSzhaJvq8oyjGWo+52G5fk6EfcI9GSL4sYSAiGo2TKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 03:16, Franklin-Qi wrote:
> NumaNode::new() only checks that the id is in [0, MAX_NUMNODES). Safe
> Allocator APIs can still forward an offline node into
> k[v]realloc_node_align(), which may dereference NODE_DATA(nid) == NULL
> and panic (GPF).
> 
> Reject offline nodes at the shared ReallocFunc boundary for nonzero
> allocations. Leave NUMA_NO_NODE and zero-sized free/realloc paths
> unchanged. A residual hotplug TOCTOU remains if a node goes offline
> after the check; this matches practical C usage for rejecting
> statically missing nodes from safe Rust.

IIRC we however don't remove node data on offline, so the NULL dereference
won't happen?

> Fixes: 7760b6421b6c ("rust: add support for NUMA ids in allocations")
> Cc: stable@vger.kernel.org
> Reported-by: Georgios Androutsopoulos <georgeandrout13@gmail.com>
> Closes: https://github.com/Rust-for-Linux/linux/issues/1263
> 
> Signed-off-by: Franklin-Qi <yusq77@gmail.com>
> ---
>  rust/helpers/mm.c              |  6 ++++++
>  rust/kernel/alloc/allocator.rs | 18 ++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/rust/helpers/mm.c b/rust/helpers/mm.c
> index b5540997b..b61e54e16 100644
> --- a/rust/helpers/mm.c
> +++ b/rust/helpers/mm.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  
>  #include <linux/mm.h>
> +#include <linux/nodemask.h>
>  #include <linux/sched/mm.h>
>  
>  __rust_helper void rust_helper_mmgrab(struct mm_struct *mm)
> @@ -38,6 +39,11 @@ __rust_helper void rust_helper_mmap_read_unlock(struct mm_struct *mm)
>  	mmap_read_unlock(mm);
>  }
>  
> +__rust_helper bool rust_helper_node_online(int nid)
> +{
> +	return node_online(nid);
> +}
> +
>  __rust_helper struct vm_area_struct *
>  rust_helper_vma_lookup(struct mm_struct *mm, unsigned long addr)
>  {
> diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
> index cd4203f27..15e17f598 100644
> --- a/rust/kernel/alloc/allocator.rs
> +++ b/rust/kernel/alloc/allocator.rs
> @@ -101,6 +101,23 @@ unsafe fn call(
>          nid: NumaNode,
>      ) -> Result<NonNull<[u8]>, AllocError> {
>          let size = layout.size();
> +
> +        // `NumaNode::new` validates the ID range, not whether the node is online.
> +        // The C allocation paths require an online node for nonzero allocations.
> +        // Keep `NUMA_NO_NODE` and zero-sized deallocations unchanged.
> +        //
> +        // Residual TOCTOU remains if a node goes offline after this check and
> +        // before the allocator runs; that matches practical C usage for rejecting
> +        // statically missing/offline nodes from safe Rust.
> +        if size != 0 && nid != NumaNode::NO_NODE {
> +            // SAFETY: The helper only reads the kernel's online-node mask. `nid`
> +            // is either `NUMA_NO_NODE` (excluded above) or a value in
> +            // `[0, MAX_NUMNODES)` from `NumaNode::new`.
> +            if !unsafe { bindings::node_online(nid.0) } {
> +                return Err(AllocError);
> +            }
> +        }
> +
>          let ptr = match ptr {
>              Some(ptr) => {
>                  if old_layout.size() == 0 {
> @@ -116,6 +133,7 @@ unsafe fn call(
>          // - `self.0` is one of `krealloc`, `vrealloc`, `kvrealloc` and thus only requires that
>          //   `ptr` is NULL or valid.
>          // - `ptr` is either NULL or valid by the safety requirements of this function.
> +        // - For nonzero allocations with a specific node, `nid` was checked online above.
>          //
>          // GUARANTEE:
>          // - `self.0` is one of `krealloc`, `vrealloc`, `kvrealloc`.


