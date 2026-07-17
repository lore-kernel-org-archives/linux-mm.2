Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F681C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17E4D6B00B7; Fri, 17 Jul 2026 12:24:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156CF6B00B9; Fri, 17 Jul 2026 12:24:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0947A6B00BA; Fri, 17 Jul 2026 12:24:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C37B16B00B7
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:24:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18DE1C0187
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 15:07:09 +0000 (UTC)
X-FDA: 84998596578.08.F59BCFC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id CEB3140010
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 15:07:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HPDOJG6W;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784300827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J51Fw8rU8N3jKV4+nr08wo0Mj4JR8dhWVcD01BFVxwA=;
	b=AiKdhQOEH4BVFOsVT/sQWhe9U8EwqtAIaIbzQB1F8VN+Gt6IAMsZBEP9DUBjAo9QpXolyd
	5GWkRobBsW2Tzfw+bTh3epOy3GRXLGQ4Pn5fPYSX2/UUZlOZOY0qCtvbZcJvtT01wEAzvV
	xEdypWz3BC2oxunZ5fXju+EDXwWqvbc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HPDOJG6W;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784300827;
	b=waLjRkk3KTKF6/i3yP1pvl6u9UwPuwYlgQUdQ71F0zB3jVQ1vqQjW0RyH5oww9KMxmx3Z3
	grrBXh8cc9s/vw90hiPNhsOYskGRAQR2zI7qe76IksDPbRKfKmlHbpV8m3taGsPSw1BfQ2
	dP1N3i72AKB3bsqDRAP/Pu++ITzco8E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784300826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J51Fw8rU8N3jKV4+nr08wo0Mj4JR8dhWVcD01BFVxwA=;
	b=HPDOJG6WK4VFbu/rYmoip+KTxOnitiqPpWznUgSO+5a34tI6ef6wX1FFIOwkXMc3IQWVo9
	24FprqFlZ7aqZmVDNWlyCGCd39ahYzE2R66V80wGh4mLDDwm6LtATAavAK8nhB7erfv5qO
	Z0GHOKvIMg0pNpWjlpxDc+dandH3Wf0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-424-L9jxO2hANjmfYFmmOGOa8w-1; Fri,
 17 Jul 2026 11:07:00 -0400
X-MC-Unique: L9jxO2hANjmfYFmmOGOa8w-1
X-Mimecast-MFC-AGG-ID: L9jxO2hANjmfYFmmOGOa8w_1784300817
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCBC7180074B;
	Fri, 17 Jul 2026 15:06:56 +0000 (UTC)
Received: from [10.22.81.98] (unknown [10.22.81.98])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CF5911955D89;
	Fri, 17 Jul 2026 15:06:51 +0000 (UTC)
Message-ID: <d2bf022d-d30a-415e-8a96-4136258e347b@redhat.com>
Date: Fri, 17 Jul 2026 11:06:50 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] cgroup/cpuset: update some comments about the page
 allocator
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
 <20260715-spin-trylock-followup-v3-2-fc4d246f705d@google.com>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260715-spin-trylock-followup-v3-2-fc4d246f705d@google.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: sSS_hsOlWQXdK55tUkPLAzXoiJMmV6WCbAeipHVO4Fc_1784300817
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CEB3140010
X-Stat-Signature: pks7jarur3r9mmpyqjphohqyhuq4y5i8
X-HE-Tag: 1784300826-430986
X-HE-Meta: U2FsdGVkX18Ejjzur+ad6/pr6iWozxQE07jIMeFxaqW7dP85WvK1fRn67bncBGgXjP+j0v0kWZiahSjhWamHxoCimUHFe93Ymh06T1xRqeFZUXCJ5aPXm7R2OaJz99L9BgIwYoVRlCVxu3mQ7UIoQg20dVU5++6ArP9asKRehUMbY59jyX/BhkppvURYhrNwWn5kQyr7z4Pvl20PXqC2YhkerU5lw4NvPIWEf41FV8O9Snrj/2kCenWEmvaHi3Ir3ug3aCwtO1eHQ9Q9m4ppHEVkAZIUJToNcymhp2JkokWKzM6kcEbTAEKGADREHpU1IrpnytOcW46wmjgJgr4Na3rSPlVttyR5A7OPPbE20ZdXRDGoNKP1rxHYHv44tNubvv3wTGnwNsC2MJRuAnhHm3a/NdKYc0yx/yjuxvpRggX6J5mXZdO1RBL6OTgyUL/bY3AS/HQbR2WKCa3BNWIK/dx9BGFHpzf+Unhkk/VrJVN3/8iHEGU4s16GKNMyztD/e+zYVveJ8icptvVgR/t1qh3AnBX7em2mjCxpQxRA+YnxnXHPWuvkJddRRHO1ajHXe++SnStYg+klbEvof3rsNHIY28Px1OxcWusd5UUuogtmfspE4QpjO/YhiCZyZKor62RZRGedtN+89nIj6PWA7fIRS1MBp7MBcswvCYyXOQHIsfgoFmEzznInMM6IYo9Sy5wNIBeGhASmovX8l2Qu4uNbXM2DpoOG/GrkfNFuHgXs+vUCoeTIctX4mh8tnNAfmQITPe/losYDtNH0Yfd2c6gX0aNZnB05exftUG9rLLS/zcXRBfRO41LUMP5RNDzKgiySZkq5QsZuFH+TyLvR2H75O33QyXLUVFFXliHlXUrUiGOX54zSiOfobSDltbvyf4wgWSbCEsqYh61Fjlq5M3zVwD3UIp4vPzdrCwZfUKOzpAnLXaMzpAUeNWJAOs28gS0eFTnTCL2Fe0SwifO
 KpT9Ve8U
 oOxvygt1gUB9/1J2UnckpLGTi2CKeSAHffu3IMJHtr0ZAYdXeIg+lXFpbIwg+t45u+NAHNAPyNlwsT39NuGOf9oFeSUKlZGvk4XOtclqejjA8XGXZMRRg0Qh1mezB73aZ3t2BonsxT4Bcpxnl5dtzqxTefvXuQHC/hwZdqa0V6prONvvzLeJHW2sqQ3DpIyz7m4SUJi1N3c4JDC7pnLRGhc3IgbKpfTAIq7PLqUYMMSeTXWcirCRc7Spx9bz8pqEsGmTAg3V53/mjKLFn69YAYQ4uVLcJC8HRe3TushOMfX4BvYkckwoSDM8DEnht+NurVTqM9MyAf/woNuoyLRKTqI70kwfJCEURrwqq2KQG1ilEFKJfX2l+FhaVr4pJEa2hV0/4NFqHJRWvwSn24KLYy6+zrct/XK2Fm2A0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 7:03 AM, Brendan Jackman wrote:
> These comments describing the page allocator are out of date:
>
> - __alloc_pages() is no longer a public API and has no business being
>    described outside of mm/.
>
> - The `wait` variable is gone.
>
> It may be out of date for other reasons too but this patch is just
> fixing the issues that stood out.
>
> To fix it:
>
> - Instead of referring to a specific function, instead to "the page
>    allocator"
>
> - Completely drop out-of-date details of that function's internal
>    behaviour, since they were irrelevant anyway.
>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Link: https://lore.kernel.org/all/DJP11T5V7BDW.2FZZZ8R6LOY4I@nvidia.com/
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>   kernel/cgroup/cpuset.c | 13 +++++--------
>   1 file changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 24ea2d09cdbdb..dfd0f827e3b92 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -4193,7 +4193,7 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
>    * nearest enclosing hardwalled ancestor cpuset.
>    *
>    * Scanning up parent cpusets requires callback_lock.  The
> - * __alloc_pages() routine only calls here with __GFP_HARDWALL bit
> + * page allocator only calls here with __GFP_HARDWALL bit
>    * _not_ set if it's a GFP_KERNEL allocation, and all nodes in the
>    * current tasks mems_allowed came up empty on the first pass over
>    * the zonelist.  So only GFP_KERNEL allocations, if all nodes in the
> @@ -4206,11 +4206,8 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
>    * come before the __GFP_HARDWALL check, otherwise a dying task
>    * would be blocked on the fast path.
>    *
> - * The second pass through get_page_from_freelist() doesn't even call
> - * here for GFP_ATOMIC calls.  For those calls, the __alloc_pages()
> - * variable 'wait' is not set, and the bit ALLOC_CPUSET is not set
> - * in alloc_flags.  That logic and the checks below have the combined
> - * affect that:
> + * The second pass through get_page_from_freelist() doesn't even call here for
> + * GFP_ATOMIC calls.  That, and the checks below have the combined affect that:
>    *	in_interrupt - any node ok (current task context irrelevant)
>    *	GFP_ATOMIC   - any node ok
>    *	tsk_is_oom_victim   - any node ok
> @@ -4327,8 +4324,8 @@ void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
>    * should not be possible for the following code to return an
>    * offline node.  But if it did, that would be ok, as this routine
>    * is not returning the node where the allocation must be, only
> - * the node where the search should start.  The zonelist passed to
> - * __alloc_pages() will include all nodes.  If the slab allocator
> + * the node where the search should start.  The zonelist used by
> + * the allocator will include all nodes.  If the slab allocator
>    * is passed an offline node, it will fall back to the local node.
>    * See kmem_cache_alloc_node().
>    */
Acked-by: Waiman Long <longman@redhat.com>


