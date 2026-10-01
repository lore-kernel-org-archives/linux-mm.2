Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19DF4CA5FC4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 01:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ECF16B009F; Wed, 30 Sep 2026 21:00:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29EB56B00A0; Wed, 30 Sep 2026 21:00:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B38A6B00A1; Wed, 30 Sep 2026 21:00:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC6096B009F
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 21:00:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A2D71A0275
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 01:00:52 +0000 (UTC)
X-FDA: 85272252744.02.FB378B7
Received: from mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1B4B3140007
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 01:00:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xShgBlgK;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790816450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E9cu6gaPd6B1QEw8XTg0R4sQ58YLLIvtvCs4yMKNz34=;
	b=OqSRcAia/3DsUaPaZVIDqr7F1y/PFn27Zv3FsWMIZ8XQ6MTN4CCBSuINzB3Nk+wKpeF6bd
	i56KvVCvJpBUggAKmj1w/DhbGmwhmMm51HQm2pdinR1g1sBk3odVWyY9YYSsJbHzqx1K1G
	xiWlMRl54hagyYyrGdJ6fpeAB9e4f5M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xShgBlgK;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790816450;
	b=ATxehMOJl+Kd1Sd+Z5hSNBI0ani74de+7PUDgVk8rr2p+WmQh9yuWZf0I9P7A21osM6RoW
	raLIb/zeGXwtzP29UEQrplZeWRSKj4b3fOw7pZZAlCC8d+BCLa5mtV49rwYQYj/PGouOi+
	EillA5ijZWFnKrj9PS8TeNriZSY2qb0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HaQPNgehEuldW2UhCdxSN+8tT39bgGHcvLRMMFKomVs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790816448; v=1; x=1791421248;
 b=xShgBlgKu6+XLjyZu3n6X1OOEztZFWuRNKQvyZnrkQrQuVf523VESG6Y0ZmhL7b+U/UHGC09
 /vkcndQ/mWan2KqAGYQepSqZF9slE0h9A7W/y3XoFfdT7mNPbRZrKiu9SDvtEviqZJhibdHCnlp
 Rn6DPhQrny1gA/ouQF0fbcO0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9f96ffee7864c01d;
	Thu, 01 Oct 2026 01:00:47 +0000
X-Mizu-Trace-ID: 9f96ffee7864c01d
X-Migadu-Flow: FLOW_OUT
Date: Wed, 30 Sep 2026 18:00:41 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alexei Starovoitov <ast@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	JP Kobryn <jp.kobryn@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	John Fastabend <john.fastabend@gmail.com>, Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev, 
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached
 struct_ops
Message-ID: <ar2kvmCPR9q31V8M@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <bda525506b3fb3e61da28a112f28abba@kernel.org>
 <arw4rjVkm2ob9ioL@linux.dev>
 <bc6815954b8d08e75deadd43e1a2192c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc6815954b8d08e75deadd43e1a2192c@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1B4B3140007
X-Rspam-User: 
X-Stat-Signature: w7mnha7cqybz4j4xs6hwenz3bsxdco97
X-HE-Tag: 1790816449-373395
X-HE-Meta: U2FsdGVkX18e74ZWkW1QSDPYNcGNwtFabwOX8yO2hGj9P9ThB3dSm+d8RwvgxS737MQTtVrjbwTgh8BcdzVGnbu+KVGHWfyhpFu7OxQFft+IWTN8N/iay9VEI9INgFBjwmZv+A16Qheo5Q/BCV1dN23jzVVxcVaJ2iSJozadI8E4rAnTj4VB6FOWT8oVnRLPxCBRBflVquv7pHCoRxOacau5zHYK0br6tpvTG/tcx5C56I7KgmUQlIn8VOxqjJv2h/z5YJtc1tAqG0V9qCwsjMO0XbZlOSyFcfktRNRofq9YSN7AuYhviPjugbYsZu6wpygHo0RnPOz8Z7xp8uFB5VYeAMjjUsOS0r8AJoonaO5n2PwWh2DyuRUrOGv6mBH68pmT+0srWH+eW8KlHYLgotSaZpD0Z6XoFFzngzrr85RYmKMYIbDa6YRyhvZFWTC7dgyLMYIwIcNzoTvs3GG+FaYFxq8Zg2YJGOXw/N3pPkO+LNtkxsXvdJLaukrLvv9Fnv4dpQAh1QGG4CiarFFMaxcnfwPjO9s2FLeYfHpEvSZVSQ3sRii1B3O9keDeGdqb9MzH6baj1h+uw2KmbCJ6qa4BwfDTmOpimYsp6Y0XZSWRcUwNCzYyyX/49O2InTFUq/aj4VnHh3AID83h1m7v/96ADtQwPbx0v3Smll9wz5uo6kYnrVu74+ZxQnqW/+8gK1VDK/zvaTYffjKo2w6PfXBHcecJhXa9SxLhW/2NiAjchksHp7BNaU+ND/CaviGeOQLxXo3kny8H49nMVE+aMTK3CMHVBm0lIbys3ralsJd6H0ksjXGNca2x+jy38xvlZG7Ymqn9SJZ2D4NPsmxlNaNx7Go7CSwlqNRR1qyKtjmrnqXNU3TVcIAJwrB6qmmbxXQy0xTaO/pMI12RjP317aGVaOQD5mK/SafYXyYo1iB2kyOwBTq8dAJ3mLLti69ZF0gqAeeqx/H1RDyvx74
 I7aW3XXd
 4sSbzswaYRsRso/tJ6dlNsIkxPGfIGDBk0AL2ooud5c1MdeGxuCCH0KfuJk70iuTw5IAUx1mMnP6gpQlquYc+WBGcZLTSX0XLXgNh26TqELQTt/IhcmZe/7Hfs2BTGmcOx5MOfitcSvJvJecMJcqRdJIol3AtsJky2tUIq8rljVGAmVJYIs7yWwZ4JiXXkUQozxygwN7G8nVyrGZQPwaHbsEigt/Jc1B6gupD5chPB1+qyeNm7A6G0ltzAW15CVFIuO7RjIusAZnHDge+kCcsFth9krGbSrGTplwdcxfSWBTV97cHaHlYJuDKKtPB2Do9ULjs4ShF/Ylw8Kwya4wyvr4p4KxV/b8+c293M6WLjxBgwBP8v3Ud9nejECYOzwQ0XIqkjNe1k+Sv/Q8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 01:35:33PM -1000, Tejun Heo wrote:
> Hello, Shakeel.
> 
> On Wed, Sep 30, 2026 at 06:28:21AM -0700, Shakeel Butt wrote:
> > I am fine with changing the default behavior. Actually, I have been
> > contemplating whether I should propose a revert of commit c9afe31ec443e
> > ("memcg: synchronously enforce memory.high for large overcharges") because
> > it has introduced more problems than it has solved, but that is a separate
> > topic. The initial commit already mentioned that MEMCG_CHARGE_BATCH was used
> > arbitrarily, so replacing it with something big might be acceptable. I want
> > to keep that decision separate.
> 
> Which kernel paths allocate enough for this to matter? Can you give specific
> examples where the in-kernel synchronous enforcement helps?

mlock(), madvise(POPULATE), fadvise(WILLNEED) are the obvious ones where large
amount of memory can be allocated before returning to userspace. Now regarding
the in-kernel sync high enforcement for these cases helps or not, I think it
depends on what the user is trying to achieve with memory.high. One scenario I
can think of is an overcommitted system where admin dynamically adjusts
memory.high limits of colocated workloads based on their working set size. The
memory spikes will be smoothen by memory.high otherwise colocated workload can
be negatively impact. In this example, ineffective memory.high will not be able
to avoid global pressure which can impact colocated workloads.

BTW the above scenario is just an example and not something I am proposing.
Actually I think memory overcommit in the presense sync throttling can
potentially cause more isolation issues.

> 
> > Returning to the actual proposal, my plan was to start small with a narrow,
> > specific use case. However, my long-term plan is to provide a mechanism to
> > change the default behavior for custom use cases. For example, for
> > memory.high, I will provide a way for users to specify what behavior they
> > want, i.e., whether or not they want more synchronous throttling.
> 
> This doesn't seem like a policy problem.

What is "This" in the above statement?

> It feels like a problem that should
> be and can reasonably be solved for everybody, so I'm not sure whether BPF is
> the right call for this specific purpose.

Here if you meant that default behavior of memory.high should work for most (if
not all) users then we are on same page. If some user want memory.high reclaim
to happen in a separate thread instead of return-to-userspace or synchronously,
this proposal provides mechanism through BPF to such users to achieve their
goals.


