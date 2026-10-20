Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C35B606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 13:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=bwugqmLO
Received: by kanga.kvack.org (Postfix)
	id 0EF316B04BD; Tue, 20 Oct 2026 09:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7616B04BF; Tue, 20 Oct 2026 09:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 003EF6B04C0; Tue, 20 Oct 2026 09:01:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0EDA6B04BD
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:01:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F81FA2D9E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:01:39 +0000 (UTC)
X-FDA: 85343016318.22.C23101A
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf02.hostedemail.com (Postfix) with ESMTP id BBCE98000A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:01:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=bwugqmLO;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792501297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YWKyDgPAMwPA3qrc0lPHDPftrnHIF8SWtFJgxMOACtU=;
	b=uXvFJxn6Q91BKSpM6k2w/yZuLtaGky8WLi34egYWXRSeOsqj8vk/V9ngRu4JL2PnVIrGXG
	RwE6Ht5B4Hcl2MwzXMSgUwOTzU/nuGvh9OmOkRZ/gqk/Hdw2RQNHXPhk71ZvNPZ0lSeFj/
	V1Z0QraoAM7/l3NsATrsR/94dmPu25g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=bwugqmLO;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792501297;
	b=16ZckY6TWfAwKoSeUso02dXkFmPXUyn5r4/G/hHn4dgW7GiRFWbZck75ZukC51lWPNCEfG
	DBHi6TZK1POaQY52kwrXHO62mubDd76S82JKbh4tvXBdE5gezgW8fUVKn8RmXXiqfmlw+8
	0MTB4OQFsBCpeUfUXRHpkfJRid7dITU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792501290; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=YWKyDgPAMwPA3qrc0lPHDPftrnHIF8SWtFJgxMOACtU=;
 b=bwugqmLOLdiFHmYmSEl6RQMWsQ4Mr9t+ZBHggzzq4k9/88vKu9+6LX3K7gsS6KLSnJ4ZBl
 pv3m/P3pjdhySwAbenbLDzpgGw6tbp5VAIlL0YQGYuWsVpzkm/es4MExa08lhDlnUFUSZ7
 TnEKNU9UVPt2nB3zM8nHvVk2EuiQz2gyPGNeWXgmUdXFkmpurAyKkzlIQTMPucvmgErpww
 OHLNfP7JyhZHGzDu6qzOUUNtXWHTdO/DbvBb4MSM6ouE8Egh7xcpneypxWNsjGNiFztVvi
 avxVbeN7qsjXeew3+hlYAHUSuBrJ8ib3RLHS1C5Qwy1GalLfhyryjJNbbo9nMw==
Message-Id: <30457046-a662-4ff7-a6a8-100398d7a806@bytedance.com>
In-Reply-To: <atY-LD2AzCYATRii@gourry-fedora-PF4VCD3F>
X-Lms-Return-Path: <lba+26ad76628+5dadd7+kvack.org+lizhe.67@bytedance.com>
Subject: Re: [RFC 0/2] mm: add source selectors to memory.reclaim
Date: Tue, 20 Oct 2026 21:01:03 +0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ziy@nvidia.com>, 
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, 
	<ying.huang@linux.alibaba.com>, <ljs@kernel.org>, <mhocko@suse.com>, 
	<muchun.song@linux.dev>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <weixugc@google.com>, 
	<cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
To: "Gregory Price" <gourry@gourry.net>
References: <20261019141401.11927-1-lizhe.67@bytedance.com> <atY-LD2AzCYATRii@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: BBCE98000A
X-Stat-Signature: kxdg3z4nzq3fxaqgfbbyjrpue5i4iyro
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792501295-789245
X-HE-Meta: U2FsdGVkX1+ITI+H1I7VZuWadoy8VBYEK8+y+Gy0hZpeqwbgqx55f2uI2tDNEWGjEQeJbpExlZcBTy6jhw0eWDjBNC5LWAlygxbL3Rr/gNZ59+BkHddizPYf5hQCd39PULw2hUUEJiiayEZMqwNLwICHgL+LurY5EvUh0qLH81UYb4sfyHEgt6Xq3kqObZCWR+/QxN7d+u5OOV7mnkuFyhWxhNb/PsY8xVub05U7CmL2x8IN7YfsOHsl20Hoo8ym3M/KY8Rift1IKmkvAhVaRdjzLzDfhUxNUl7t8Z4qmEPS36zaNngwFFIbLz1cda9HAy0ipy0KjuL1oQoIjSKIfa7itYgFijevNW+rVFiSbXbVzqcJk1Fqv90/E0eUWqg6pHauhd2JBvTZw3IJX+xETfxOYig65YTazs+5WcwdXTL5HK5HUbVG4hc3YFLyxblHqCcrwZTdLNMu5jjcNGwhTye/3gUEv9lcejI2pAw4EUq2ZH2HhegyFieDZd48sT5+dl0q/AHAthblhb78hMvu+4BVJMnaaMdUXivE7RAp5nRJ6uahF0jbeSNt4ZyB/+Dd+s83TP4MPR5c274uT3uIXAksZv7G+Tl6B3JxLyngggGNgiG2RBhXsbRTeZF1BH4z8zX7N5+No37v+VjhZeHiXO8K7dlCQOgUF/c2GOpEA7eEH9tEVSScZRVdQpNcfDKMG/z7pPT7zY1ccz8qut5093wqHgHSOqnOx8Jx/DLkopSW3FvR1DtULH5tJWXh0qd2OVhFDuQYWcIbGXb2G15B4GTgnr8yYFueKLkoZvcE4xuZVyf4ISAOWTuv+s2GJGPsGW6Cd78lT8whKcxIqY20amxdy4oSZ3EKWDXrQtY9JLc/GaLmHMMwrRFUX/upAx0LpYz6R/wUCOYkUzLNv8Jzog24+r30DV5UKydITNu5TZFh1vEds8HfUn3G5zwX33hFIUi4mc4wO3nPxcNbDCI
 Md3jVOFm
 1f0sJkbeOZWfHyQzGySQFCCdP6yMoygQfWusJLQKLLBXkbyvINvrMivyrokjZx1Lu8K2TRhLr8ESQUC27voFD+pWT6bhJaUZeqfInxcJd2O8Skxf8E+7KgeFnJmGK7+CKq5i1w9Y7dp52Yzfw26BIc684TVC3XCYcHCF/l7oOOzZ+EbZdYb3oVOrNhK49FbsU+Ksv8kc0mFXxSUiCtGYGNw3zYhQelcUIJbIu0ReG8XgdjsiebV4JYNynOsJs0V8G3LfUZR3Imrb8TNGueq3AgaQpfmEBNwONayRmWfMIv/bKOgIFRZb3cmFwQJdPbMGsZkhbWbYsDgvoHhcGTjxcWQyhq7ocKQqwG8NY9JTDYE4vGK3l+mwz9YMiF6RDAEYklNnSS4wR09ZD0NFWcz6VlTQHa/Egk8xMFg+l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/20/26 12:10 AM, Gregory Price wrote:
> On Mon, Oct 19, 2026 at 10:13:59PM +0800, Li Zhe wrote:
>> memory.reclaim is a useful proactive reclaim interface for memcgs, but
>> tiered memory makes "reclaim N bytes from this memcg" underspecified for
>> userspace controllers that manage memory placement across tiers. The
>> kernel's reclaim policy is aging-based, and on tiered systems aging may
>> demote folios before they are eventually evicted. Without a way to
>> declare where reclaim pressure should start, userspace can only reclaim
>> from the memcg as a whole and observe one aggregate progress value.
> This is not a good argument for pushing the complexity of managing tiers
> into userspace - it is an argument for fixing the reclaim interface to
> handle demotion and eviction sanely - which presently we do not do.
>
> My best examples:
>    1) the watermarks don't make sense for lower tiers that need to absorb
>       large amounts of demotions from upper tiers.  It's likely lower
>       tiers need larger WMARK_PROMO to let low-tier kswapd run longer.
>
>    2) proactive and async reclaim current reclaim top-down, which results
>       in swapping directly from top-tiers because lower tiers don't have
>       space to absorb demotions.  We should experiment with async /
>       proactive reclaim applying bottom-up (lowest tier first) so aging
>       the top-tiers demotes into lower tiers more successfully.
>
>       direct reclaim should stay top-down because we want the best page
>       with the least work to minimize stalls.
>
> I have a strong suspicion if we made these change, then memcg.reclaim
> would work more or less the way you'd want - and anything else can be
> managed more directly with madvise/process_madvise.
>
> I also have concerns with extending memory.reclaim this way permanently
> locking in reclaim implementation details that prevent us from making
> changes like this in the future.
>
> ~Gregory


Thanks for the feedback.

I agree that the kernel reclaim and demotion behavior still has room for
improvement, and the watermark changes and the bottom-up proactive/async
reclaim idea you mentioned may be useful to explore for some tiering
scenarios. But I think there is also an unavoidable userspace policy
component here. The kernel can improve whole-cgroup reclaim, but it
cannot know every controller's placement goal.

For example, one controller may want to keep a specific per-tier
resident ratio for a cgroup. Another use case, as Joshua pointed out in
another reply, is reclaiming from a lower tier first so that later
top-tier reclaim has room for demotion. A single default memory.reclaim
algorithm cannot express these per-cgroup policy choices.

I am not sure whether changing the default whole-cgroup reclaim behavior
in this direction could affect existing userspace dependencies. In the
old nodes= discussion, Mina mentioned that Meta's reclaim stack relied on
memory.reclaim triggering demotion [1].

I also do not intend source= to lock in current reclaim implementation
details. It should stay consistent with the current design: source= only
selects the resident source to which reclaim pressure is applied, while
the kernel remains free to change the reclaim policy.

The typed source= form also leaves room for future source selectors
without changing the meaning of source=nodes.

madvise and process_madvise are useful when userspace knows the target
virtual ranges or processes, but they are not a memcg-level interface
for applying reclaim pressure to a selected resident source.

So I tend to prefer the more conservative opt-in approach in this
patchset.

[1] https://lkml.org/lkml/2022/12/13/79

Thanks,
Zhe

