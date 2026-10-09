Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66D08CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 19:39:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D69E96B0088; Fri,  9 Oct 2026 15:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1A176B008A; Fri,  9 Oct 2026 15:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31B46B008C; Fri,  9 Oct 2026 15:39:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E5016B0088
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 15:39:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 140BE80500
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 19:39:55 +0000 (UTC)
X-FDA: 85304103150.15.45DE038
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 66A811A0002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 19:39:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z8e8DRo/";
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791574793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i1X2Q68ZmYsPWobrAu7yZxvAEcunRnI0QLmJSHkQTsw=;
	b=SVVUJKz6FO6gCAL3Yg8agtnY80yG2cMK26H3JTTXF3i0M5SS9aZPy/Gx1DAD3xnqGpEhMX
	zGlHxbwS4iGzjVdAC5hSmtvv8FkoQXwOlCdgV46V+hn3xOazH5eUtmvhyU0jc065/LSgsR
	5VQh0Dl8DlehQRS8G2nwQzlyneGwvxM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791574793;
	b=4fJk3n218suxXEo79VgXkwtnFxbFCz+lwB62SOPwPp8clWjTA9axBqTyfitulDQnYfDuJH
	IzHMqdajpU3gLV01TpL/6SlS+v6T70cp3F6RvPfdQovhSMfdCSllqxNXczB6QbqH1TsRpr
	EXZsrzH7dxj6EiP3IvsXwiNiiRuu/7g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z8e8DRo/";
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A910D44788;
	Fri,  9 Oct 2026 19:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026761F000FF;
	Fri,  9 Oct 2026 19:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791574791;
	bh=i1X2Q68ZmYsPWobrAu7yZxvAEcunRnI0QLmJSHkQTsw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z8e8DRo/AVA9dOkXV7/WAaZmDrCtuRLJu70W9RqRnnftfwEJwAggklQbJlzDjomCd
	 NcHAvYULKuYrlqcHTP/2dAMwl0XqXyUaa6ZerBn90d3OY9P2HOV1Dns7S9gUcKPRWt
	 HqeiVb4t7i6RFj+5LKvCj+utjJrsZxcthA5QPKEEFd7/adEixO8ONBnyFVZg/8/vTe
	 UNyW1qR75zam1ahjU+AIr1Xk7PGei6iSHn46USHvDHsroYic5ZgokBtFw2lRdfp/dv
	 4DMyQDex+LEiF+I6GU5CFrF/C1yL2LUmemOIqlM4IQ1FSL0EAhAWt3u/zds14kWPay
	 uSYH8xBv2i/HA==
Date: Fri, 9 Oct 2026 21:39:48 +0200
From: Harry Yoo <harry@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, Pedro Falcato <pfalcato@suse.de>, 
	Kuniyuki Iwashima <kuniyu@google.com>, linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations
 with GFP_KERNEL_ACCOUNT again
Message-ID: <ask5kpMS4mpI8Api@thinkpad>
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org>
 <asjhg2e4-WSeKuXd@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asjhg2e4-WSeKuXd@thinkpad>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 66A811A0002
X-Rspam-User: 
X-Stat-Signature: scrq4ae6j563fnd5p4x1cjk9eqgeg356
X-HE-Tag: 1791574793-781370
X-HE-Meta: U2FsdGVkX18da1vCpj6nfYZFy1yuRXGSkMawmWk2e8LG+jbMiD/hzEoyTp2omY7bbeMszgU4136MEJdbjW3XZ0P9RpTuN/bsTeKKE4sKCRhmpFE2hPVEOxk+mBC9GTrvuHaQpR1XEkyOrtMnTC1rGa8dR+IG8Ab42NDgRgVmEO1jjSfRW0l5PM2HReGQyYogNrjmHKS+1G5iVDH4LHkuzC3QcQW5P866jOmUS1tda3lGwoN1toZ3Ez3UArsnKMPwaG1fns9HipXbWA/aBfYy5AazXjORtboIyMlqZFBYuHhgXzPFihsFKrRBQf8YJZs+s1GjdqXtKZl1llYnIaCctqgNHay2ynYZbXOk7MVdh/IZbaSwGhkj5mrqZIU1W/Wi7c2b1aY+RVMJLtyNMCC/dX6sIFpucJbV2ESCBueb2GbGUpc2nf6uBaBHhS+VIBlUuBHVYG7joKZhgTBGwX/d9hnVzafqAUDXtQpI+xIis12g+IP7KFFTL0jWg3vOl0gs2RiFz6hbQNxZ18gh/miJc3Sm5og8vSVFxazDqZu2ArfmWVHC2ZDrlfzzMJXVkN/RRRLUO9KZ8jsFs9k5wZ8Z2BadCWwrHezU5pVDb8Bss0QNOQosWrHtYFjfCVg1SxdxjazzS1yZAeg6pfvj6neFy2NdVLGaWIJ3Fk/BqwRPivOcPprhHu65VzFaQGDpJ/jxmN489w02dJ98niuq1QliaMfiim/hFenxl7CRF0Zlnzd2zMCCv/bKxnrTkLCZGIFoUaTQeo9t+oxBWKWL3PEGsHVqjKdn2HEjTPI47d5wMUM+Jq5awkxDoxPLl+H1LCxP6XUnq9Pd/hYMzOM9jMLkz4dmrXRdFd08dKYObVyLrL3oyG8nJtYbTVpOauAG943Un5Qs5qlLhI8sK/cqHZaDNTKd7uW+kb4bDzolodZMih5geUQvgC4EtTEQM86HLVZW24KJPsQOr1FPsqj4mId
 N3DTpkqw
 oUNfM9yVxsXTnf0hNw94J+L/8nDkfuEN8OegD6hV4KjDgPXgXlg0nQKrPCChZFlf2N2xGA+0A1wgc9jr85RBdMVbLugolG8Yvbrw1vItWUNG1+O9hO0k5gp0rGzshXrK153oR9anSt45k2XrOOhA9F7+YPCq8myJWnv8P2x1aQA38u8YvY4uNm3wmNoHOJw12e3NlCtD9/C/50kTnDtpuhK8KgmXVTuoUw7JbIIr3Q4YIGbZTzasaLIaCCsAUJGeVR4HhpjHJeNovSNtSwwRqbTh3uu65svRnFcvffGW32BLQcgc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 04:22:03PM +0200, Harry Yoo wrote:
> And now I see the initial kmem_buckets design did not sufficiently
> tackle the question "How this should work when kmem_buckets falls back
> to kmalloc?"
> 
> I suppose the kmem_buckets' abstraction should not be too tightly
> coupled with kmalloc caches. Creating a kmem_buckets should be
> conceptually equivalent to creating a set of caches with speicifc
> slab flags, size, align, useroffset/size. (for variable size allocation).

Just to clarify... I have a few concerns on this area.

1. Complexity.

It's very counter-intuitive to understand how it works when
SLAB_BUCKETS is not compiled. My brain cannot easily process two
different implementations w/ and w/o SLAB_BUCKETS.

A "compatibility layer" allows us to assume certain expectations
and ignore all implementation details when SLAB_BUCKETS is not compiled.

2. Making kmem_buckets tightly coupled with kmalloc's implementation
   details is not reasonable.

Let's say, at some point we make SLAB_BUCKETS always enabled and drop
the config option. Then all kmem_buckets users will now have certain
assumptions inherted from kmalloc (e.g. alignment), which is not
reasonable.

3. __GFP_ACCOUNT and __GFP_DMA should be applied to all allocations
in the slab cache. For kmalloc, these flags are only used to select
the kmalloc cache (which has equivalent SLAB_* flags for __GFP_ACCOUNT
or __GFP_DMA) to serve the allocation.

Specifying it on individual allocations (rather than as SLAB_ flags)
makes it easy to break the assumption.

> When it falls back to kmalloc, kmem_buckets itself should provide a
> compatibility layer when falling back to kmalloc.

For example, calculate_sizes() converts certain SLAB_* flags into
GFP flags (s->allocflags) for allocation. We can have a similar
logic when falling back to kmalloc.

Though current implementation does not allow this and requires
some rework.

-- 
Cheers,
Harry / Hyeonggon

