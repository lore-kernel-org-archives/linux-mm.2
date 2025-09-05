Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57DAFCA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 21:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA558E0010; Fri,  5 Sep 2025 17:33:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9AFC8E0001; Fri,  5 Sep 2025 17:33:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7578E0010; Fri,  5 Sep 2025 17:33:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 89F408E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:33:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B211C028D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:33:28 +0000 (UTC)
X-FDA: 83856498096.07.32072D8
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 63184C0008
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:33:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h3ahOOnk;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757108006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QwCCUd0KTHgYFr0j+O9LFcsWubnSBozHvxaBHLHATR4=;
	b=yoXmQIQNritRI8cmmOt6K08XnDnfKjhPk3hlvhah9+N8cjBOH+X752s2sQ7pNqh0oGVHO6
	2jB2iVeYdIDoqeFUbxNs4h/opzeDI9c9xM8UqeF6uWiYFDte06oF2Wcn+xjO2pbnsiUBX1
	QAh3MvfimkrBuEEunF9wp91yQsp/NaA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h3ahOOnk;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757108006; a=rsa-sha256;
	cv=none;
	b=6MSl/xVlwTXLwFNaJn7q+B7yvlvS31HLiWZwKSQfPWvwciYo02AI8jlztIFft9tcUi0xc4
	2ij9qUMRNFoHtCRrqj+dQddg+DOF7eJjKNp64xSg7H0ARrnxl/81Gjipsgo/0PiLhzUmcS
	Q8z9A5I4ZbQq0cltcpYGbyQJUG0cLJA=
Date: Fri, 5 Sep 2025 14:33:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757108002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QwCCUd0KTHgYFr0j+O9LFcsWubnSBozHvxaBHLHATR4=;
	b=h3ahOOnk/F0MmUrnwBj0pv+WS92VUhpUcjg9AF/33EvQBSOR10RVaCo6g6sKvHPZ7RxQiR
	ossZ/zceuY6LBcRxgB1y3V/V+5V4ZIXr9lLQmuk9MmkA2Gmipmt8kzFJybjnnxAq+gq4kj
	1PBirCUf/vYTfpvlbNyxekDm4CIgA8c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Peilin Ye <yepeilin@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
Message-ID: <ukh4fh3xsahsff62siwgsa3o5k7mjv3xs6j3u2ymdkvgpzagqf@jfrd7uwbacld>
References: <20250905201606.66198-1-shakeel.butt@linux.dev>
 <aLtMrlSDP7M5GZ27@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLtMrlSDP7M5GZ27@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 63184C0008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: eqg15txp4zdao961pky8aownsp5yh5ji
X-HE-Tag: 1757108006-526876
X-HE-Meta: U2FsdGVkX1+t5/t7qcutErjDXonT2xOS7KL664Fzcj13LFFQ+IN6Y/vhlyJKXEMWmxVD4uauFbBrjWPYz+RZna/kvLughB1gLpjt15iUJYtP5qDqy8wwRCBn1YebiG0hSUa/WcrO5C82nFncTYJsFP+QTV4ic/2cCkv87EiffEZ4fUbxl6GD6Cr0EO51pIDzAEeBdGVEeevbV345BFCBxfLpM8aNbfTNkMI1xH5c1tbIDTLo8Q2w8I0I+FP5LO/2r6R3pIG+CW1V/yWVlx6u2hWO4skUuiq6YJHaLqpAlzrMxSUDKTCfe41eoDQFEsQ8VxvCgE9HAWZ+9BM0VYRIUGT+Z2b/bU7WfVS0WrVJkHLsVSbHpttT6uZFMlFuT6xHKYA+nuqPAECxYPcHlqLY5MCFoWyUTBOgtQA8VtqZA2ApMgfG/ITSh7e4wbn/RDNdhU89pdVdwSWdOETUw4h7pXD+oKp/0mPoTSULjpld6diiD+V7ySwvKOwBraoChKMNQEK2cz9CZ4JjBRQqftrFXoz89eSJhgSYMNrPSc+Ye9qFtOeG2BiNAlBCf1JMCTXzwzU7jxFiTQY9REJNOJxVmewLQq/jJpsLC4cyuZkZ2gMLqs55qTdQz4OFrZGgaQx6/JYiAZFp4Rkrp9Lxc434OQHsKahbWNbGGHKNdae40iuxEHytJiteq4/9FyYRdFXcJcGhHVsES250PYinoiy1mo8AN765FiP1BJ7uXZR0+aJGkpM8TzdktUNcGXu9iZyDEz4XxVF2GT/8wh3fErx41TIK4MOe1MVmeAxqsfItuR80iFZatsphN/bt+hQ7eBS9Ds3EU09q3J7WUDm7MN3+VT+zAB3SmyoTU4w6lv9fX0atr9iOLuTPpEAudeUw2f55vpvlS7HnKMBEvlcn7JkT6JlAtt7+AtRmYsJw9oyLUAXbLJB/76/zvzbrm8sSUiZlfCKNFQqF89eNzFx8LLY
 ciC4sRZ3
 nqFtRCSW2PueainG6GhYBxtlChabXldv70d6sVJkS8wB3lMGLPwAhh8RFR5HFHgVhs5sbcpPoGTY+wMx8EUuxwfDkfu3DoSbRAIzygrCXZR3vwmVTsx+R0gmHVxlZQAfYYwJ8tBz9plr4bmMGnTBIpcFhUtQigcdBZaWcQSd5TSiOHi1NFs6M4qX3hIrRcAdqac4n3q+QL4GO7vSySyBDzMzmjMv88J/+Lvih5y0vESYJ+Iqr3l3vkTPW5ArZ+LJtl9CDO1Xk0A7b2hw+iJrqRSiBtEzyoktaWDDS1kvci19sqdc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 08:48:46PM +0000, Peilin Ye wrote:
> On Fri, Sep 05, 2025 at 01:16:06PM -0700, Shakeel Butt wrote:
> > Generally memcg charging is allowed from all the contexts including NMI
> > where even spinning on spinlock can cause locking issues. However one
> > call chain was missed during the addition of memcg charging from any
> > context support. That is try_charge_memcg() -> memcg_memory_event() ->
> > cgroup_file_notify().
> > 
> > The possible function call tree under cgroup_file_notify() can acquire
> > many different spin locks in spinning mode. Some of them are
> > cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
> > just skip cgroup_file_notify() from memcg charging if the context does
> > not allow spinning.
> > 
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Tested-by: Peilin Ye <yepeilin@google.com>

Thanks Peilin. When you post the official patch for __GFP_HIGH in
__bpf_async_init(), please add a comment on why __GFP_HIGH is used
instead of GFP_ATOMIC.

> 
> The repro described in [1] no longer triggers locking issues after
> applying this patch and making __bpf_async_init() use __GFP_HIGH
> instead of GFP_ATOMIC:
> 
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -1275,7 +1275,7 @@ static int __bpf_async_init(struct bpf_async_kern *async, struct bpf_map *map, u
>         }
> 
>         /* allocate hrtimer via map_kmalloc to use memcg accounting */
> -       cb = bpf_map_kmalloc_node(map, size, GFP_ATOMIC, map->numa_node);
> +       cb = bpf_map_kmalloc_node(map, size, __GFP_HIGH, map->numa_node);
>         if (!cb) {
>                 ret = -ENOMEM;
>                 goto out;
> 
> [1] https://lore.kernel.org/bpf/20250905061919.439648-1-yepeilin@google.com/#t
> 
> Thanks,
> Peilin Ye
> 

