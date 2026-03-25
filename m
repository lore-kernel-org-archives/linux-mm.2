Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 035BBF54AD6
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 00:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69A006B0088; Tue, 24 Mar 2026 20:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64B596B0089; Tue, 24 Mar 2026 20:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561996B008A; Tue, 24 Mar 2026 20:28:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42FBB6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 20:28:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB54959445
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 00:28:10 +0000 (UTC)
X-FDA: 84582698340.12.5396F07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2C4B44000E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 00:28:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DPyAlTqO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774398489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/DvjoNiDZ2v2YNUYyE/Za3qyXk0Tj9YBpP75eUZvygE=;
	b=DVrlOM9bR+btCvsx7hke63tqMJZ6Jtmv26Q5RXysBJSK+lby390HEpOMp+ixuIMtKFqqYH
	Qw6dB+aBYQEBg4bzUs1e5jHOGwuvzlHlwK7M0pX2annct8W/eibPUETrrUnan2ST+R/RRp
	4ceo6x9rT3YUl4HPSwosGe4mCQice+E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774398489; a=rsa-sha256;
	cv=none;
	b=OTuzeqsLkNi8idTy+Otgj8YVYZIISFOSUjPzO6G0T/4349teTVb9VnSwcksPIfN28VJmoR
	Mu5a1juJRJTCfcW86LRoezcpv9WlfcVMcNkibcxkRmiY7S/k6JaYJGV7a03fMkye4Iq1NV
	5Nyo8wodo9TQYtdfWmc0MyvVLpX5wio=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DPyAlTqO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 22CAB418D7;
	Wed, 25 Mar 2026 00:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97420C19424;
	Wed, 25 Mar 2026 00:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774398488;
	bh=TvloSL61KzQ9iU/afN4Rt1hOopTR6E2Gjkg+FYAiOb0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DPyAlTqOL2tV9cr4DTV8nrok9SlazMYfMm8u08LNqfQlvOy7s7zL23wyecMM1705Q
	 MvKcQvzz+8+Yo78A5Kok4/jcxgHsuhXjL0z2vCNMV99AVX3NlnEyPL8/jmVM0nF+th
	 3tiQdovxIuOwKm817E9S1AgrL/Q1F6RaaBQHn45DUV8tlmqWpSIjXsDFgt/BfFGfqz
	 2iiFOTPDMM4X53D0axXL4siHU3bfa00uoRkSIVTUkGv/cEpPPvLIMYrE9HaRmE71Lp
	 qLqf0aRTO9BgDUfjGVBeFqSHZUhFaknTWuvLifb+FFTvarbI+TyRg7CqU36qxPJX8n
	 14afEiXtUezTw==
Date: Wed, 25 Mar 2026 09:28:06 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
	usamaarif642@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH] fix: mm: vmscan: prepare for reparenting MGLRU folios
Message-ID: <acMsFsQOAIK-455b@hyeyoo>
References: <e75050354cdbc42221a04f7cf133292b61105548.1772711148.git.zhengqi.arch@bytedance.com>
 <20260324114937.28569-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324114937.28569-1-qi.zheng@linux.dev>
X-Rspamd-Queue-Id: 2C4B44000E
X-Stat-Signature: sitqkotfaxm1ax6ctahmz533mdx4987k
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774398488-710510
X-HE-Meta: U2FsdGVkX1+12RSqPlj2lIQdslYVnR2MGMgm1VlsoGksoB719qia1lQjMa/226GU+kqSg8SVvt716rSBiTnXswabXh1dPM9X/kzNMFaBsPhTOwwMliKCji95io8FY5lOOeNaMFUHnCUeEiiWX+aOM8ZOWq9lVQzqXj1WBfVEW1GiVw1shiJnOQEf130iixrtQWHtEjyj1JGNn6DJZXSJJoDW+11GZuwYiAxPiTu0qiCfTr3+WQmU/BD+L83Tn0fS252shqeeaUwgWLfknE9Tgmclk2irIQHw3h51JUL/dE7lQzgrlmTPDTNLBLygCIUjJfgNW4YuLGNGk9zgrchYJQ2dBXoWy1qX5DcwWDehp9pWrGAtISQk2GkqdAthIF4lh4Q98LXqVAIgf+h8vRW4hVjdN4qR0HFO7ue6nbphHAIuUY72HPCefXwTuEKzfXXa1TocAD0cuYEcv+pKxZfdfETJwhNK/jIC2NusCGWn4em4R3ZQCIuso5kPeGM89yGKlwB/SrYo0xU5D4M9cPWXVdwmYSen+VH/gp9hUTyPo1MIJDQ0sgtTU+eZOB1pk51/u2PnL+rjVFuXYgqgu88XfE2dGt/0g4Ma+Xg80EOFHwSuf6OJn1XdLKvqnp4Ss/iz4kqrehXq0SQ5d+zodaHubhC5NyUctxxZQ1rHeJhPhG4vDmL5XlF2/GU0I7Eabtr6N7SSReucFkTJ7xusg5STG4xyhI3zMKvOxC4DfQa7LjC44bD3t9w94dV6Fj3x/YnIuXyD8QtpIZt1/336Wm6JsefrA40qExWw+a/OYdhFktqclH7dYQ8F0FIhzhF4ycrfv6nAaklkj5hTnS7S/i/kvEXYBCSUn0NPJsf13NG2+xiG/bv5Y99yw8iH2DVlpApVpvqLHFzjwAL679TE+zMViMgO1biPDMcf1E1wJQdKzIdoMUjYSk5HRaaqW3XgkTwebyvkvSIkMGRvPVOpSyD
 BYdROIYE
 PNeQBw4IUuE5YZ7oLZOTTy+cU4o7g1MSkoij6+gp0h+3Hl+EAvXUS4i/Zhe7E2A+8UcJK5tO2HBk0SjnRVVHO0xFCW1PdaDTbiIwMisLm+cyCcp/JvELs4aBP1kMXKfsmfdCSUcuWuznmnBqWVHuAH64Awbh3jXjMAutt3oMw9Kzpl84NOGbH3vf6NbqKNgazl/7elta8bsKgvaVS7EadGCywtrxFsMB2q437/egGlmkT92w7wREcXipYr7P7v7+X5l0eNGpRA5Cu3zVDHfZP29ZNS8Ur8HV8zNQStL8bhO4GOQ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 07:49:37PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The lru_to_folio() returns the tail folio, and the lruvec_add_folio() adds
> folio to the head, so the tail page is colder. Since we always assume that
> the folios in child memcg (about to go offline) are always colder, we
> should use list_splice_tail_init() to reparent the child folios to the
> tail of the lru list of parent memcg.
> 
> Reported-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

