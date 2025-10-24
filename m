Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC0D6CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF3FC8E009F; Fri, 24 Oct 2025 10:22:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7D658E0042; Fri, 24 Oct 2025 10:22:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45A48E009F; Fri, 24 Oct 2025 10:22:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BD12A8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:22:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66D185DAE0
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:22:03 +0000 (UTC)
X-FDA: 84033222126.11.341C7EE
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf30.hostedemail.com (Postfix) with ESMTP id 609EA80015
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:22:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=ezQP+7u3;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf30.hostedemail.com: domain of "prvs=63920b99c4=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=63920b99c4=clm@meta.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761315721; a=rsa-sha256;
	cv=none;
	b=eVeqjOG3DzP7wG4FHULwl8XsZgyxmpZKdBO+oOSuhHzIvtv5snfRPF0sb9/OnxLeYDQE2I
	XjxEpl2fPIhGEdHPBwi1cwmCvOnbS2lEUhH0V28GfoV6D2ZMYbOHFREeelpkAC+39uahWt
	lO8SWU8euxsym3K88gQ5vGSBq3Y7oVw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=ezQP+7u3;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf30.hostedemail.com: domain of "prvs=63920b99c4=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=63920b99c4=clm@meta.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761315721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b/ol2wZmOZszG9k8vxf893BYtcntNjtXKAqt3ZVyZ6M=;
	b=T5Ch/ra6IyiYp6DlnY0ZY2b1+mWeGjEJpaOLX6Nm9TYWhrF1VcZhhs4GsRFkWs6pm1245Y
	T7jDtjLOQI77jXqQ6I4e5SFKuQZWmr5nNh+CMSqoHw/vgBJqNIVrOA+qcvh2mGPAaeT3ci
	zx17TMtY7UTFlvkqk9lviRkj6K8hKyM=
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59OBwgYl419537;
	Fri, 24 Oct 2025 07:21:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=b/ol2wZmOZszG9k8vxf893BYtcntNjtXKAqt3ZVyZ6M=; b=ezQP+7u3tFEf
	zrYyaDhCkTMVQFov2O0qB6+PQ8nFCiz5xUxgfcMk2tR+A3R95RZzzaKIuV+0udnJ
	CETmgt5bY2oOqy9mzXp4dlGP2sajgZMdyujqwW9Jd3+LwfTJJnmgMKee2hmQcqYr
	WcE4brwFFiA3z7jYttDF5dcSZDq9hbl8VFDOJu5glQxQ96K+O8D1SKa4j6JalBSI
	O5tzYojsleliqP7yWdADgof1zsQg4uANQ8T4e/jCWi4UAfCyP24qMqFgbZnB9oHV
	Z2N/UdAhoSxb1Rht4AfWxZvy79778q+JYsFec/by5KkZgF6k0yclfpMdaDfD7DNN
	vDn6vxt7NQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a09288x7k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 24 Oct 2025 07:21:55 -0700 (PDT)
Received: from devbig091.ldc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Fri, 24 Oct 2025 14:21:52 +0000
From: Chris Mason <clm@meta.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett"
	<Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        "Sebastian
 Andrzej Siewior" <bigeasy@linutronix.de>,
        Alexei Starovoitov
	<ast@kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>,
        <bpf@vger.kernel.org>, <kasan-dev@googlegroups.com>
Subject: Re: [PATCH RFC 02/19] slab: handle pfmemalloc slabs properly with sheaves
Date: Fri, 24 Oct 2025 07:21:35 -0700
Message-ID: <20251024142137.739555-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251023-sheaves-for-all-v1-2-6ffa2c9941c0@suse.cz>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:108::4]
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI0MDEyOCBTYWx0ZWRfXwTD/VmjTrZA6
 JRMZKrwqksV2xp1yhJWxwn6gzdqQ6FLs2fQ0eb7xBONuzcwgzrrSURnRmWBCizGKI+13LbnEIl4
 ylNtvCoS+qc8ZaNrun/2WUn50FZBKyvgRCtxu011MC4I60o1A0gUQr7LQe1DnOC1f19Mw9W27VB
 MlWsAS28QxLMenEBX7/purq6SIW3f2Ls4I6uC6IrLhRbaN7uAosLW6+sFcqB5q5bySPDl5GzzE5
 R9gNXo0vhN4ZummzWu1+T3C/Fckz++HJCysc3xdveEplf4WxEoLA0JxvzvfFP6keHpZ+LjYmoHz
 lUK8NtClWc9hhIyXgA6umSdgtc7sWHlWqXnnspAxBWh4MhmjJc8arJC6lHS0Uji0i8FsmPJ+NE1
 uMZWCoJMv2b3asDyr7V0u3Kf1VWvBQ==
X-Proofpoint-GUID: 1v7_B19uZD_UKIAK3zHZIbCsxtzfqkFk
X-Authority-Analysis: v=2.4 cv=aK79aL9m c=1 sm=1 tr=0 ts=68fb8b83 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=PCJbmnWxFXnHO1kFQDsA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: 1v7_B19uZD_UKIAK3zHZIbCsxtzfqkFk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_02,2025-10-22_01,2025-03-28_01
X-Stat-Signature: qkxten4hhooo4oox8ae9cfqpse85muuz
X-Rspamd-Queue-Id: 609EA80015
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761315721-249881
X-HE-Meta: U2FsdGVkX18YRicynVJP/z0i5FRty/RPBM+mITVxyexrPP2QOUJWtePH/U3B70sNKWgZTrX15ZHmZrXmSe0VlBp/NbQjYHwjVk0o95Hy9/SI9ZLUlwKvyD+72CmSla76ukDUFvfShBLEx8xWzHsEA4kATbrZOCtFjcVxWgz0QZkkgqEbP0cAbseaDUnbjBt1aBwjgQtdjgZW6pgu8phuRrZtezr/VD112TlfH9I7LJ1tbhyg4SHSpYoLITcSlWntdunzSKL/LxQCl6y8bN/5dnkNZkaguabrwT5/IX5HuabLvKL3U+I4//4q8xo+kv1ERQBKHX5Rw34FQa1HtT3pEPteuSF19xmrVZxcJR+YQspvogiHhxNI5veYx9JQzEcsW/XUZDJFsDQ0qTSlhWqbN0EpcOhhc8zcPiDV36P4J+sn35e9IOfT/6Orz0+uGNfZjadF1+xtao5Ugj6YnzR+BKj5fJz/9MnXpWngPuJwbCRdzBWW5ZpOFfZmBC6w4wd7jJ8Q2yxVOfYHwWGjA2+UvOGVKy9LsKV/npabQQw1mS44SZi1qVwXsj0kpnVgQQtXcEQJizaji88IY7cvqiMXVn3VaXnH2QnJfiQjuh0TuTYCXJLMF0mrLI4TpF7EE7zhDIepicA398gNmnC8wt3l2DrMfIkxw5u4ksER3+r7lnDksRZPbwxprjsezEjhcZznGoxs2mPKEe0RR5LzNTYr66HsTgneDTtKJzRCP0w3VFydNFI2h3Xt18M+mke0QR1CFbN07KapdLZ9mL8JyU+1iIA8DChBS7nk/kBrPDzm/QANYdTiADf2CM4ReHZiZUGG/NcuQEtn1ExSMDnXmJB4kU8pBNh71p230bOElJJBX2k8KgnnYPhbgRlSjGYdYx7tXtiAQSTs6jWElHTUwyg6DKCP7UVXLWOVrP/+JiX+2NQaKQbuSprh9VPpmYH+UWQws42bQ5LmFpPbs5hkm3p
 er0gAN2X
 VD6iJgDSNt+WqV9rRTR0hUAX8OAQIjEPo2culMXtoIQXnVK8hhBr9DIbYYXH6gwwKSHgeXfPN8uOGYlMdzv+2zrKwpFHE/7MjODB30mHbTra0rZbqkZUyQiHZ/fjP06bZLVWIo1JO7zT0YOwjTZC+K2E34cyu3VYvx2cmy/qfmvWPvzRIJ3o5Gddq4EqA2cD4vv0QfIUMOFzaq0GKysf+Z9gVK1UVju+uByj39s6CWruIWEl1qRpdRwZlcWBwn3BsvR+kGrc5BOYvLyn2u6BEU6ds8tMt9CTVRu65qpKwcex3MQFu1V7wDtYRzgdTA5RbRxvj8mncgUih3ch+wqDi4uXSJz7so91+1SxYfp7OwhZ4KReca4yuRc1VpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Oct 2025 15:52:24 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> When a pfmemalloc allocation actually dips into reserves, the slab is
> marked accordingly and non-pfmemalloc allocations should not be allowed
> to allocate from it. The sheaves percpu caching currently doesn't follow
> this rule, so implement it before we expand sheaves usage to all caches.
> 
> Make sure objects from pfmemalloc slabs don't end up in percpu sheaves.
> When freeing, skip sheaves when freeing an object from pfmemalloc slab.
> When refilling sheaves, use __GFP_NOMEMALLOC to override any pfmemalloc
> context - the allocation will fallback to regular slab allocations when
> sheaves are depleted and can't be refilled because of the override.
> 
> For kfree_rcu(), detect pfmemalloc slabs after processing the rcu_sheaf
> after the grace period in __rcu_free_sheaf_prepare() and simply flush
> it if any object is from pfmemalloc slabs.
> 
> For prefilled sheaves, try to refill them first with __GFP_NOMEMALLOC
> and if it fails, retry without __GFP_NOMEMALLOC but then mark the sheaf
> pfmemalloc, which makes it flushed back to slabs when returned.
>

Hi Vlastimil,

We're trying out the AI patch review automation on the BPF commits and it had
some questions about a few of these.  Since the goal is to actually test the
automation, I'm putting them in unedited, but I did try and make sure they
were valid before sending.

For this one, I'm not sure if the behavior AI is flagging is intentional or
not, so it feels like a reasonable question to me at least:

> diff --git a/mm/slub.c b/mm/slub.c
> index 4731b9e461c2..ab03f29dc3bf 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c

[ ... ]

> @@ -5331,6 +5340,26 @@ void *kmem_cache_alloc_node_noprof(struct kmem_cache *s, gfp_t gfpflags, int nod
>  }
>  EXPORT_SYMBOL(kmem_cache_alloc_node_noprof);
>
> +static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
> +				      struct slab_sheaf *sheaf, gfp_t gfp)
> +{
> +	int ret = 0;
> +
> +	ret = refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC);
> +
> +	if (likely(!ret || !gfp_pfmemalloc_allowed(gfp)))
> +		return ret;
> +
> +	/*
> +	 * if we are allowed to, refill sheaf with pfmemalloc but then remember
> +	 * it for when it's returned
> +	 */
> +	ret = refill_sheaf(s, sheaf, gfp);
> +	sheaf->pfmemalloc = true;
> +
> +	return ret;
> +}

[ ... ]

> @@ -5497,7 +5528,7 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
>
>  	if (likely(sheaf->capacity >= size)) {
>  		if (likely(sheaf->capacity == s->sheaf_capacity))
> -			return refill_sheaf(s, sheaf, gfp);
> +			return __prefill_sheaf_pfmemalloc(s, sheaf, gfp);
>
>  		if (!__kmem_cache_alloc_bulk(s, gfp, sheaf->capacity - sheaf->size,
>  					     &sheaf->objects[sheaf->size])) {
                                             ^^^

In kmem_cache_refill_sheaf(), does the oversize sheaf path (when
sheaf->capacity != s->sheaf_capacity) need __GFP_NOMEMALLOC too?

The commit message says "When refilling sheaves, use __GFP_NOMEMALLOC
to override any pfmemalloc context", and the normal capacity path now
calls __prefill_sheaf_pfmemalloc() which adds __GFP_NOMEMALLOC.

But this oversize path still calls __kmem_cache_alloc_bulk() with the
raw gfp flags. If the calling context is pfmemalloc-enabled (e.g.,
during swap or network operations), could pfmemalloc objects be
allocated into the sheaf? Those objects would then be returned via
kmem_cache_alloc_from_sheaf() to potentially non-pfmemalloc callers.

Similar issue exists in kmem_cache_prefill_sheaf() for the oversize
path at the function's start, though that code wasn't modified by this
patch.

>  			return -ENOMEM;
>  		}
>  		sheaf->size = sheaf->capacity;

[ ... ]



