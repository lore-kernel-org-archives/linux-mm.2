Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CF36FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 00:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23A5F6B0088; Wed, 29 Apr 2026 20:45:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EB456B008A; Wed, 29 Apr 2026 20:45:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D9896B008C; Wed, 29 Apr 2026 20:45:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBE186B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 20:45:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9AFDD1B6D9A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:45:15 +0000 (UTC)
X-FDA: 84713378190.27.5588213
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id DD58518000F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:45:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HFwGVGJf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777509914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pCTUpF0cpVJg2K7qPD+X5hb6jaLiczXXVr+fZfjKK84=;
	b=gsUirVREGKrbUR6QMP/Ni7hOplpPA6bNSm+bSTnGbKjwhZf+5mm1rMSyA9jwxPdPVk2ZmG
	IKbHw9WXcUE5KKvQjulpN6JBEmEKGvAKCCbLZ95z/XDojayk2SE6uIrnL7iKVqa28by1iP
	DKlHOKzsdvAL6bmumZDtwpNPRpI8I9M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777509914; a=rsa-sha256;
	cv=none;
	b=KJ9xz3N0PPTu9R4qPeyGbpa17HzkwvxAwVc7Yh6XRyzowJiTYx+i9wPTJuIMAzLA14Qwmn
	A/jU16tQ4OjkvGuLFl2fgD8yQt3pOlOKRlcJfkL+FCv1QMlDkDlH0za2mkPv7QsePp0gmQ
	ogoSkvJSfR7SxJLqnHpBlV/eh0MF8bQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HFwGVGJf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B994C434D5;
	Thu, 30 Apr 2026 00:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AFCC19425;
	Thu, 30 Apr 2026 00:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777509912;
	bh=1NgfA3n3epDy0q1UITsRHjNEHHtTt81kvm0NYuIzMtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HFwGVGJfkaIy5KBpg96SC/rKobcnOYBnzagj5OPEvKfrKBihzUHUnX6IZ/CEQnC8A
	 GisE6n6TM1ZbJzxzrC+jDcAgerA1xpww1xwWxrFgMbGNquTa0zc5JpP0gvF7fJx3em
	 EeDTV/+QKI4nwYVaU7ZybGyhUKxS9xBc0aCjcYEgSzKjqeg+8u1+/RlYErk2q8Yfgd
	 iSJ+fz15N+R3dhUGHIt9GfU1PABW+e49jYJM3F0lrFS0ePeRSuXgN5aOPUd5SOxOkF
	 fMwm+rH0HnOvRvvZ/CTd/2xbNNd4EX1Pdlu6jDt1Ph7Ms8n79wXywt/BNfYIIbD2m5
	 ozp8+0YxligEg==
From: SeongJae Park <sj@kernel.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH] mm/memcontrol: hoist pstatc_pcpu assignment out of CPU loop
Date: Wed, 29 Apr 2026 17:45:04 -0700
Message-ID: <20260430004504.113550-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429084216.186238-1-hui.zhu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DD58518000F
X-Stat-Signature: f4naz94uui5fbf9uihmubqgexni5gdr4
X-Rspam-User: 
X-HE-Tag: 1777509913-846567
X-HE-Meta: U2FsdGVkX184atU0OQ817nnW7VpBXM8JPAxnVlz3e3opB1ioIT+yqSOwq+D/BgpbQ05paLHu8TebCMQcgvNDwLfBpvAFLut8heiuHRJzssKjZbiKpgWGIQccX5ZZSZM1a+V8iwbu5kLajYE04A7FjcUknuUZOBQhs6eDmL5KXgNDxKcQVk7sv5fQ8/gBkuUm2DR1wUEV0qW8iwA1XR9LtreBgqjkSIiJ/tsBPZjAxiWcbjAccU8oDHYUoGZFv1F0aT4i6NysjaaDI05aTV5lXKeeKjVxDmtA04xNkhH0D8JTdboZfkPoktrlAKHIj6CmT/4tD3p/yxu1LwQlEQxPVBVO5lbbJv6kb9FcLAm34Y4lzk8w2SPuUcpBg+s6/P2VewDCtd/StAkPNQRPg/cYOHha5i5rDWZfpmL9K2mbMr28+MH0A6WPXDCjLdakTSqyevJSmxIp5fW2T4DekAMyRjbT4wuq+Lu6zM+r2ug5OAM7PaHrnIbUgi1fKG/ZTFLLrQqfLe8LCbyF5Ystvau54PhOqxOsTDwWQPx5akn2AwOOwq72DAQmad7qgIs2pJzhbCPkY0wzXslZBi68DdJeAHdbN5Qcu2iw624OlFEJemxw06/v3u88M72MxYMKgMO15EdNYR+qe/wp9/SJOVXCskJJx2mt/EfkV2x9PDIQY6uI/+G20TwMBHR7RrAnlj4AWxkDAeMavO/Ja8WMsEIZfCHEUj5s1mWn9lUMM8PgJH5eIJnbubegzhbMOuwhjql7vtyEv/YbaTAkZfaiLSsXQZwKMsEXEA05SIcrKD6shjE4im+LP9vdsHSTA+Zw3koeF9s7WR3/xbTOtngMIPA9404K6f58pMcASSBwzk4AbIGKDtuaPAQTqVhnnAOLqwR4a1/6HHS8Eh9V1QhS8QhtjJ8+5K2acvyKmI4V0nhSAHf9Vzl0HVWHC5Zt2Ab5fi5tMTBbUe3OYuUmDGCR4N5
 Hlf2IA+6
 Yg5VZ+2ws4/5CWwhg7rjk3VkklY3nJAYXkRPSY+sIP9v+4lTbdLNemPqrhyVo41mTi/8A3rat6g2q4YQDeNbsXrkWVMRLdOl1XkGgJF1a73fHbhvtqbNmeo6pF8ZTYVIzeSMES/RRxXfvhAfAkcZfy/pp6X+cS57Uyaq8vUx1puOTsxfPOqvHXopgemLBW4RGZ61VkHtABVxnRFgh5yX+NjuuxP24bX51WrtaOMckhWCu0TqlxBch8XntxpOxIRkBXOyMd0AMOQim7U+eO7eL1AYdDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Apr 2026 16:42:16 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> In mem_cgroup_alloc(), the assignment of pstatc_pcpu is invariant
> with respect to the for_each_possible_cpu() loop: both the 'parent'
> pointer and 'parent->vmstats_percpu' remain constant throughout all
> iterations.
> 
> The original code redundantly re-evaluated the 'if (parent)'
> condition and reassigned pstatc_pcpu on every CPU iteration, then
> repeated the same ternary check 'parent ? pstatc_pcpu : NULL' when
> storing into statc->parent_pcpu.
> 
> Move the single conditional assignment of pstatc_pcpu to before the
> loop, resolving both the loop-invariant placement issue and the
> duplicated null check. On systems with a large number of possible
> CPUs, this eliminates repeated branch evaluation with no functional
> change.
> 
> No functional change intended.

Makes sense and looks good to me.

> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

