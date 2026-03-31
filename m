Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B416110F92E0
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 16:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 285D76B0096; Tue, 31 Mar 2026 12:41:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25D246B0098; Tue, 31 Mar 2026 12:41:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19B976B0099; Tue, 31 Mar 2026 12:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 06FFC6B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:41:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80D07138F59
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:41:41 +0000 (UTC)
X-FDA: 84606924402.03.D89E998
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8F60510000C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:41:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IpoZhlqW;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774975299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYp5jtYV8e9c0GHDX6iE3m6Qn+B664htEYIIRvJGk9Y=;
	b=kzd0jmvjZPVmT6nO8bJCAMYUCl9vCYTAeWbuBxxpRGYKRB7NC5Tt4aUuPKKWx/wqwpXNZm
	8v7/bjD5ZME01NeSshcYrd+i86CBjCFRYP129Zjuvn2CH9wTiaBYFwu36GWiwOgFQ8hglg
	xlNfykfISDGnQJPc0dEupSm6VcPKfGs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IpoZhlqW;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774975299; a=rsa-sha256;
	cv=none;
	b=j/8wTYUfmmHnU8Dz9z81NGJZOyGM3sUuekCf1FnoP8s9TDQnT1q8+6LaIIPcrt0rPb1Dz3
	B4Sn0ABu1sPjkfDlja1rN6s2LxCquO2M2rKEa1ZHTqoGYKbV7g/5HVRIPct5d7CNQeOOMD
	rTG+jhzfJ/Em8ABX7PmZG+C0Fc7qSjY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 92A4B43C07;
	Tue, 31 Mar 2026 16:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33591C2BCB1;
	Tue, 31 Mar 2026 16:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774975298;
	bh=ywVHlTRf5Tl9PysYqy8ehrxhpxHsZDl2JA5xh4pA8mc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IpoZhlqW77ifhqsrVptmAFxDbIwtx3rAPM8fBui7v2JQSwdJHRZorsMPaAaUAtkCX
	 HiyVJxZZldfllhLGXBRgY6g0GGsiIviwg2ZVaIjg+jWqDqC8jSDT8szOFkU0JjzQTY
	 rQMGkJjSfj0liCM8zOCIlkKnxDeFb9P9mFA7rtn7//srCjmnJ0jBqR3QHh3vF7NxcT
	 /rZaOvvGEVJCnB2UwAPA9GOjDD5a0zsg5OIfFrdjFaTURtr98LVei7vhu+k+RAiFHH
	 RuBV+gR9z+VSlG3pRQrlxoDIVYiEJgX69ObHWc+MSXnlUCRGnnhbdNwwsLRaTzQwiY
	 6wUuw/CT6KfQA==
Date: Wed, 1 Apr 2026 01:41:36 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Hui Zhu <hui.zhu@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Hui Zhu <zhuhui@kylinos.cn>, Vlastimil Babka <vbabka@kernel.org>,
	Hao Li <hao.li@linux.dev>
Subject: Re: [PATCH mm-stable v3] mm/memcontrol: batch memcg charging in
 __memcg_slab_post_alloc_hook
Message-ID: <acv5QCe0qMUUW2xP@hyeyoo>
References: <20260331091707.226786-1-hui.zhu@linux.dev>
 <acvnjCr26zpQUW0h@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acvnjCr26zpQUW0h@linux.dev>
X-Rspamd-Queue-Id: 8F60510000C
X-Stat-Signature: yuwsc36z9xpupindmn9m7fg3uq97fcnc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774975299-131362
X-HE-Meta: U2FsdGVkX19iYdASSW3pvWJfWRYlEsPa1v7dCp/UYqKnr4k+bGJC6TTId4quLm3vueeanvCw4A2uzFgnjyI/RZ3FTA93IMJsW3ZqMisr+eC14NpyQylhT9V0/j2VuH+dLW2GPOWXbwVjv3Ugd8zKP6EfyyRzGnE71D/7k/cNbBksXX+biWKyv1F1gGMb4u7EUyIIsRo/XSbxvkVkKpgUvaI4w+smbKnSxWaGyIOVAF728CezExmS+yUGMGcSCdDsrUEA/VV7Cmv+lXQklgtlggdGCk4cYtEAR1iWAadhYgQQBVOyLCZkaDYpMZ0gMdRmNh+i/ObVm7j009ZsKVPfNCbyQpRPn34T9HP/EkjILld0X6qhanpx6fkni+ZFgIQ11aif77qjpobIXs4jRhTl6krhs39puKju4443N0FL99QgUgLZwVdf5KfJHLgH8WIKcY8IV5VBXpsCU+YFMEAxyLuOhbn9uAgapd6nwnKX+ughsBISsBTDjNnqvtpZBUP/teZt4JAun7kChqNnRZFIzNY6XQ1duCJeMDGHm7vB86QfDtbRaYpAWSoq/bOgIRDscLSV3bYX5WQ8+AvSeCUKhFMxZlH6/OWtsg/UTt0UZSOkfc+VKp4lYFxSbOL+1i7BZ5UtdMlMiKCvCfQ57VQP5qweuxW/iVXQQRA15YqgC7gNe5qP/wZGcVTM7w8fM5KQG1HUEAQDg1lg1lCfOKv6SQayjz6uTa0ZCKSLHupjKEiewAi6NT1EA6xMo3O1pOkUTRueO9a+EXAhFz98KJNyGFB6dZ4uVCHRM27zKqNaGtWv3HFpuBLPWDH0QcBtetOCp1/jWB20UHVLzReXsPkZdaM6CdW6p4i6p+omYW2kkkwXIjHl/yHGf4RU/eNFFpXASQyk7hfRjAQpw6CDjjYtcgUXrftH+MU28b3l4991dclRpQdmekRaMeJOR1ieG/1PHejY+8OzeRDHBHeEbZN
 hjb6KYbp
 EEr1fznhyg/s0L9XGXGotXRUyeXxWZQpmEqdaQN0gxHjPVuMYBUsGBhqy97nzQe5HgwZZ2SQCp7SP9Z+//3LhX/DdHX/YkxebfFjkIV8Rh1c+hwaVb6gPWrosoK+9yKOqfj4CBdUJl54xg0V2Rdo0zjv7UxMueLN0KKLMnJWOj4KoADTYQibYmOk5Op74NkqAkZ172u3VRO0H/NpvfF9Zt3hYEw4Cha3FmH/UZqlT+gw2UjLoS6efFwRzG4+yUc6nqB2LgYCSkLn+w3OA5GAnsH1zE6BUV6O+2E+bhGLtRrlZjRs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 08:32:30AM -0700, Shakeel Butt wrote:
> On Tue, Mar 31, 2026 at 05:17:07PM +0800, Hui Zhu wrote:
> > From: Hui Zhu <zhuhui@kylinos.cn>
> > 
> > When kmem_cache_alloc_bulk() allocates multiple objects, the post-alloc
> > hook __memcg_slab_post_alloc_hook() previously charged memcg one object
> > at a time, even though consecutive objects may reside on slabs backed by
> > the same pgdat node.
> > 
> > Batch the memcg charging by scanning ahead from the current position to
> > find a contiguous run of objects whose slabs share the same pgdat, then
> > issue a single __obj_cgroup_charge() / __consume_obj_stock() call for
> > the entire run. The per-object obj_ext assignment loop is preserved as-is
> > since it cannot be further collapsed.
> > 
> > This implements the TODO comment left in commit bc730030f956 ("memcg:
> > combine slab obj stock charging and accounting").
> > 
> > The existing error-recovery contract is unchanged: if size == 1 then
> > memcg_alloc_abort_single() will free the sole object, and for larger
> > bulk allocations kmem_cache_free_bulk() will uncharge any objects that
> > were already charged before the failure.
> > 
> > Benchmark using kmem_cache_alloc_bulk() with SLAB_ACCOUNT
> > (iters=100000):
> > 
> >   bulk=32  before: 215 ns/object   after: 174 ns/object  (-19%)
> >   bulk=1   before: 344 ns/object   after: 335 ns/object  (  ~)
> > 
> > No measurable regression for bulk=1, as expected.
> > 
> > Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> 
> Do we have an actual user of kmem_cache_alloc_bulk(GFP_ACCOUNT) in kernel?

Apparently we have a SLAB_ACCOUNT user in io_uring.c.
(perhaps it's the only user?)

> If yes, can you please benchmark that usage? Otherwise can we please wait for
> an actual user before adding more complexity? Or you can look for opportunities
> for kmem_cache_alloc_bulk(GFP_ACCOUNT) users and add the optimization along with
> the user.

Good point. I was also wondering what are use cases benefiting
from this beyond the microbenchmark.

> Have you looked at the bulk free side? I think we already have rcu freeing in
> bulk as a user. Did you find any opportunities in optimizing the
> __memcg_slab_free_hook() from bulk free?

Probably a bit out of scope but one thing to note on slab side:
kfree_bulk() (called by kfree_rcu batching) doesn't specify slab cache,
and it builds a detached freelist which contains objects from the same slab.

On the other hand kmem_cache_free_bulk() with non-NULL slab cache
simply calls free_to_pcs_bulk() and it passes objects one by one to
__memcg_slab_free_hook() since objects may not come from the same slab.

Now that we have sheaves enabled for (almost) all slab caches, it might
be worth revisiting - e.g. sort objects by slab cache and
pass them to free_to_pcs_bulk() instead of building a detached freelist.

And let __memcg_slab_free_hook() handle objects from the same cache but
from different slabs.

-- 
Cheers,
Harry / Hyeonggon

