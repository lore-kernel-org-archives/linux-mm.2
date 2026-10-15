Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 309D9CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 09:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D03C96B0088; Thu, 15 Oct 2026 05:05:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB58B6B008A; Thu, 15 Oct 2026 05:05:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB7B6B008C; Thu, 15 Oct 2026 05:05:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 964AB6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:05:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 053BD4090E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:05:34 +0000 (UTC)
X-FDA: 85324277388.21.B1FF6FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5A63E1C0009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:05:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BjxGIpPy;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792055132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3Iy2xLXR2x993pIXgHnMySyaQglTta+do5lmMI7ybk=;
	b=OHJ6bAjgTjhS/6ZBDZqQePogk0EaEg5a9uMz4th4MVfHclJSidsOtznIYnxkT2pwcn08Ka
	7p9YfR83tCV3WCZzB7evRaqjEGjjVp/6S6j2d9shkUxUD0XXnqh64LTAkjizDvWs/M9CUa
	pKKeQulCa33ODIme8amMnKs8dH0emYA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792055132;
	b=yqWarc+vu49k8IOCAZjIcIJM+Gv3kq8hPMQDNsNsvBhS1SEJ/YuTx7SH/8bZXJDpehuE+F
	ozigV+0m8X49dKQ9cGqNVb1D3HIR2kHbs6LYaV8ofxYSroJhWBR9V6HvQVQWNgghpRZ8mh
	UMN34rcm9Wo91JWP5k6qByeDaQg1Fd0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BjxGIpPy;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D5E043E30;
	Thu, 15 Oct 2026 09:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99B41F000C5;
	Thu, 15 Oct 2026 09:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792055131;
	bh=i3Iy2xLXR2x993pIXgHnMySyaQglTta+do5lmMI7ybk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BjxGIpPytUDCjf3oHieq1z2xj+WqtcBnVttFrOgOeGtnR4dXibxnqiymN9qUS4FVQ
	 UZcwaO9d5rTLZcjDX8/WxaJ0OPnfXjEwQbP4YTJaQISyEupwW2HCHUydxT2PUolM3T
	 E91G+9KoXO+i+UtEff3VNmqcGtiqf5oiA59PYznQqEJGTo45KIvOBSUpd59/jgc60N
	 cpudvdzDyKTz3G0wt6wK2dboL19osEtYvZbZMPQ2aLGuRfeyxxOft7bF+wspbZO6Zl
	 BasBxay/SBgmeCqOzjjzapcDi7ghmQlto+QvjvuIEvoKzBxtuCCsxhZZJjeG+SKwJT
	 8D2smjU76jMdQ==
Date: Thu, 15 Oct 2026 10:05:24 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Lokesh Gidra <lokeshgidra@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Kyle Zeng <kylebot@openai.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: only allocate anon_vma in CoW mappings
Message-ID: <atCUhtQ2v1WtNKwf@gremlin>
References: <20261014-copy_hugetlb_page_range-v1-1-5b68e03fe7fe@kernel.org>
 <as99gyi-NUprRK6e@gremlin>
 <a5c6edb4-9e8d-47f1-a316-6627e518fa7a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5c6edb4-9e8d-47f1-a316-6627e518fa7a@kernel.org>
X-Rspamd-Queue-Id: 5A63E1C0009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: na7pgjw3iekaczojddra66nmqn67zowx
X-HE-Tag: 1792055132-933483
X-HE-Meta: U2FsdGVkX1/IGvcRwroMD63Jq/d6ds2a1q4K3LcVi5PpVpBD196hnNx3HMtSiH51cHnDJG1HdEwCvhqxaCImgKiXpgUnplSU8RlCv7zxQ0DYY5Au7W2AIyBE619XViwOtCdLi3AoYRzutdaCpRtVG44cGQ7NmMPT3rzMt79jOR2maxm5vxnU6APluNsahd7V+xfiSVyjUbO5yMUWJxVxBW0Cr4mWzKfXTbFgvdBRPqSMWupydzk6P15dYqoze9+VSixGnm1JC4eMp5sFdeW5pR0TzzPQCd5N1l4BhJfUR6saxzG3w+M9vGcpdA9FgaLy/We1ObgWKQWlk11VL5GV+XkTjIZ7zOt4LKRk2B2yskNXlCUcYM8fjVTMxpPYgqK4MBxwAc+VOls7t90lkUoo29ayxBox5CHUBCgRa0sAq7Us7BGJNESefI5bE901Cai6/n7BMf4xfYAiJRUMTKXvaWU/BBfq7SFWvwiUCM5BbMnptv9pWjp0ScSe7ENm9cV2IFQYU+gor+HLBsw8I7uuHqF7XYATLvUz80OfYpV3Sq122HJZrFV4br/sskcIbN2UnZkVWLtgVItjqpe+/mP4nVyGe9YUfR76TUbgeptl74czSmYrJpuYlnzVKM9Jodc1fzmGtxEwaKE6GVXeZ0JsFXglnGYp+ou6qAya51TPqnFvuonp4qA0ZO52nCeAfVMHHx8PJqMlMbk9e+d09MOe5aaI7yFQzakKpTBOKcXojfKXbaOrXAWL8IaczgrvA4moH9N2aWRDUzJzh/Lypp0DAn5g3rWdvzWmJC6tKhYfC+zwqdMcyb5Q6NhxND19UjnQ5IjSyGY7IsVM5TPDTvOhmC6YXRvACqBX/Le8ekfOfMUUDjhbBfpMhc6bIGM0qrI0bMrzOnFLC+Wa+b35+YvlNCdi0hkX5DHYlMSTy/kW9jSZbpIlvYN9XKjzfZpq/OtdwRBpy7ARjsbbPsrdOlB
 nd/rQ4t1
 kCDP9kdiTp3i0o6WSJjVSqJxR+0ANXb7Jsf1m7DkD21BWoHMMjdoP79lU9Gqb3idL6CA4EXYR9p02xbfHin1LkkPC7hs0s6OzdRADxFu3zjihZgq42bV8DevCsheMRl0reNBqjspcS5Z5YnQBszFVSMv3LRBW1k6P/IlBf0pdt9JS/tLvWor+m+VRMmeKsUQ0uYU3xnvvJli4Lkz2xPC7ZNE7cCVrbDi9ZwIYUOYXxps31UNPCiFO+pSxZ1K+yFZ/0/mgXg/cD1Y9kghEDGYbl8I0RKhISv5KLfPGLAvDgtxJakA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 08:29:35PM +0200, David Hildenbrand (Arm) wrote:
> > Hmm really? Is it possible to do that without the hugetlb lock?
>
> Yes, we don't have to sync against PMD sharing if PMD sharing is impossible.

Ahhh I see.

> Will send that out for the next cycle.

Looks sane!

>
> > It'd be good in general if we could get rid of that lock as a whole :) but maybe
> > dreaming.
>
> Yeah :)

I will probably have to go and look at that more deeply for
mmap_prepare/scalable CoW reasons. I will wear goggles... :)

--
Cheers, Lorenzo

