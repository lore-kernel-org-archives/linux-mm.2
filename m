Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AB2EF5A8AA
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 18:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C1E66B0088; Mon, 20 Apr 2026 14:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672B06B0089; Mon, 20 Apr 2026 14:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561A36B008A; Mon, 20 Apr 2026 14:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4406B6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:21:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D74B9160B44
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 18:21:05 +0000 (UTC)
X-FDA: 84679750890.16.6E6DF76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id CF50040008
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 18:21:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZJvn7T1M;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776709264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdGs29E0iCEMibZ36Q0lkT8grGNzh+9GN8Yb1MpfN5g=;
	b=BkfPHuVt2ObivWBBUFO7snsaHKXjh5/pC3hwJCnFRwBKwOuFLWvg9W6Vahvg4ueVpBOp3s
	F8hI6imt1hXaCZbvf3aSnnaAR7XI0Jwtpl2M4EOE12m3u6JN0auPK/8smY6DXmdbEtN+UR
	n4Rop2hccIgds2lE8kPumPb1Z2AoLI0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZJvn7T1M;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776709264; a=rsa-sha256;
	cv=none;
	b=d/eWUICxq2cHDJwsZYcUVAjDP7j1Jyni52k0ycA92d9p51end3k3892pkak+MYVFJTPJQO
	TfzThNgWDV8O3irYUg2ExAIRx3qM5b0APMUThtIlcYcxCvZpCtl+L8kXQhJUr81dH3sPbX
	5aZodRKAIPrjjqteQGcGflqJTA4FLsQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D7E343506;
	Mon, 20 Apr 2026 18:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71268C19425;
	Mon, 20 Apr 2026 18:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776709262;
	bh=FOAaojl3scYAMf1O14+NiH/97wNiKCNp6Z7bcubMnWI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZJvn7T1Mehfwd58iUr4z6KPmYtrflju6rxnK52vFeCgzwVW7gp5jR12PvRswJf7gG
	 Ljg0m8Kavna3IcqwA9wmu4GnfXtFuO2az2yNglp1WRKI/5zcz22mwWbJPFX/GudUyV
	 OUBF5t2BZaTQKLRrdl+8RE6UepWh8pnjsWjHHXWf5XNicGTmFaCsWEBblajths32kb
	 VHVAHqPSOR05EeNtoaRtf55Fo7tZLoSZx6VzPmVqjCFLJHccAcPT9vD6FxX8hZIxwI
	 itqcqmieANkMfg2qmbuoznd5f8HTH9isfGD1m4zC79dI5QgNI/aDhXt3umVvGuFdmH
	 7dv8nMw/AtYrA==
Message-ID: <c199e47d-b2fd-42f3-9e50-c47c848dc72f@kernel.org>
Date: Mon, 20 Apr 2026 20:20:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/18] mm/virtio: skip redundant zeroing of
 host-zeroed reported pages
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev
References: <cover.1776689093.git.mst@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j3z8sd7gcn8w31xowwc1ze6txx4977f5
X-Rspamd-Queue-Id: CF50040008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776709263-582743
X-HE-Meta: U2FsdGVkX198mcyJcmKrCrnw1Y7piF/GzaWuf8l9L4tVkqQJHjAWaUjipBraMS13hzpmXL/p0j1LjKE46jFEYOS/h9NASrVHllsiwzJVhmJj77yvKVdbPxOIu9nna2cyeRnI4FgfwYDYVcSXdpseps55GqfJ0Gjn/93ekmYQp+BXdIw5Y1cQFGA9hj/xnvQkr1jnwCAybmt/rOfE1Ze6LHdZwR5E9WrTDClA7214v//l43hxGIb/wG8x9rciIQUzF3eGLCfe/+RHLygy2mARfujf606Alqlw/Ls9B6AaVxunrdif5QVMIvQaeeH0OGlgYp5yM5qaGyPKvoE7dCn9lQVELpKxDnC+N5R5WXRn+nhbe4iXuQxpbVKktj38+rdFZ5DPOtB3hOVwSDF3Iz3//IS0Sf8OFop1CVRiX562/Cn6OIYlk4Usp323eiB7x2oGtVAE5B4gzm3/ZiYc+UvKC3Ne3UJ/QWTZMXKfjZnDp/FpCvUAA4B7c/mrxi2Dzd8zfgJ7GdT/mTH2Ivandqz5C6M5VQG4a9lfORgq/eLxbFO3UB263uGsTgOZKoRh7gB5TZxl6YnEDnbgQJ+1FSoiWm+dYgUHiyx66QUBjiK2xag/DKhhLWoATOSkNLdrHNjaBGLv1wnG/o1xdDc6HVMDjust3J7I6WTvczKN6QXb6UOo+CSs1KeGNgp9tWVkm8LaWL6PBKRd/UDFcK+xusfwzlMC6w3xl6rmR5XYxkp6+xgMYCL4kqIzn2VJ9roOyzElBeWxjT2XuPlBAgdn1uu3JRIwi6/BmzjLQoAWjCxXasm5gr8n7YRmolhcjsHBywUQNP9uZQFPDAsRhXwLR/gtpS31FZrnSuaD041Z1PwqlORdunqd+jeX3+BgVkME0ki0XXn6IZ1eF3kFastgF5LdR/NC9HnvhSIHOgeEOHPPlIIAYWPNTfwrWzMFl91owQOIkPoAD44mj1h32O4kJsx
 P3Knl9O2
 5Xmooqzren3eE+aaCe0nDdBSLzfTsKcf5xbuJuAcpcUd+EtJPkmVwBEC2cPQQJiKbtOMVtSh4+j+oTbcdrCrjzEHqY9QoeUA2C1osAjlHrmpMFMY1pGd9n2f6exmxFgPSR6srDN35/I5WY2WqK0YWiwFl1pCQ0lmc3dXClvpOc3PA82dRRdbdlhagznEKOS5KEc6XQWKnFOuKL3cP1M3wMBFp815APnjSTOYfkNCHQ9ZNaVkfMfn/ptbdHKCRoaV6vN7WuuEYy/2fwenoH/ql1/xAPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/20/26 14:51, Michael S. Tsirkin wrote:
> 

Hi!

> 
> v2 - this is an attempt to address David Hildenbrand's comments:
> overloading GFP and using page->private, support for
> balloon deflate.
> 
> I hope this one is acceptable, API wise.
> 
> I also went ahead and implemented an alternative approach
> that David suggested:
> using GFP_ZERO to zero userspace pages.
> The issue is simple: on some architectures, one has to know the
> userspace fault address in order to flush the cache.
> 
> So, I had to propagate the fault address everywhere.

As I said, that might not be necessary. vma_alloc_folio() is the
interface we mostly care about in that regard.

> A lot of churn, and my concern is, if we miss even one
> place, silent, subtle data corruption will result and only
> on some arches (x86 will be fine).

Which would *already* be the case of you use folio_alloc(GFP_ZERO)
instead of magical vma_alloc_folio() + folio_zero_user().

I don't really see how vma_alloc_folio_hints() -- that also consumes the
address -- is any better in that regard?

When we just do the right thing with vma_alloc_folio(GFP_ZERO), at least
vma_alloc_folio() users will not accidentally do the wrong thing by
forgetting to use folio_zero_user().

> 
> Still, you can view that approach here:
> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git gfp_zero
> 
> David, if you still feel I should switch to that approach,
> let me know. Personally, I'd rather keep that as a separate
> project from this optimization.
I'd prefer if we extend vma_alloc_folio() to just handle GFP_ZERO for us.

But let's hear other opinions first.

-- 
Cheers,

David

