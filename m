Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FB7BC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 22:19:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A41CB6B0089; Wed, 21 Jan 2026 17:19:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0F8A6B008C; Wed, 21 Jan 2026 17:19:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FB186B008A; Wed, 21 Jan 2026 17:19:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7FDF16B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:19:56 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F68EC5F8E
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 22:19:54 +0000 (UTC)
X-FDA: 84357389508.26.2265A45
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3D14C80007
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 22:19:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bRcPWOGZ;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769033992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HoQi6KkVwO2LhgzMpx+nRVqZde/RMh0LYhGYMNHF+wI=;
	b=mb+3C9byfd/X6xUjQajgeNKC+R50NuVqEdnJcAdc9ctlLYrtKHw8TSST3TO2VHmzOTqN6g
	gK0Cj6+Ra6dViEOevjZnNtc0NTogFC/DRTPGX4ceYhrEYXCbQdnuaP+SjLDVNTvTYRhIUW
	7TWC6gCGILC6PH45Tl3lHLF2jPkwrxc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bRcPWOGZ;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769033992; a=rsa-sha256;
	cv=none;
	b=Ug+9Cf6OM/L0E7y5tXw+GsgBsAtdZqfkGPSjwhy0lxlAwi+q0hd77DW/pzcdqnpXPvjH2z
	OW7K3efLrIfI18kE34NSACTVxTauXAUGSyAfRYn2gfw3HQEehLDAJbM85NUf/1ZDFVkOnZ
	S7pV3GusyKOABvuvSXalePzKaOyBESw=
Date: Wed, 21 Jan 2026 14:19:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769033989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HoQi6KkVwO2LhgzMpx+nRVqZde/RMh0LYhGYMNHF+wI=;
	b=bRcPWOGZvCAF46Vb6d+TQK7NJXXCA1nyBDuGiR30fw6T2n2RgwTpzNZsEoy7Sw8d7wFm6H
	dFr++EqcJGqK4eMkbiF/b08+spW4WaOIL49mAPk8Xb9i4ovQiwLgdCvZbi5lkyrSgh6UW+
	dV28mKXR+f8sdVTOAWqWhdjoPIBVXz8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] mm/lru_gen: add memory.lru_gen interface for
 cgroup v2
Message-ID: <aXFPhnOn4oGllq_Q@linux.dev>
References: <20260121123955.84806-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121123955.84806-1-jiayuan.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3D14C80007
X-Stat-Signature: fc8jdtgko6nni8baw6aaxa8cdg81iz6w
X-Rspam-User: 
X-HE-Tag: 1769033992-5050
X-HE-Meta: U2FsdGVkX1/yc8rxdNtBxCvgb8LFTLy4fG3DM3/ThAT9wxmfY0QCLWl09l6AOZkKn81Wi4oYZOOroA3cwMOmTnWGGGNR1hIuHBXxbg6yH2HhfsheQKjowhRguC0FVSTilo1fdlxNVzimhL1QUifVH1Ypc4ehyTIGYTVLzPqgZ3uEAjfbWKyJPYxx+qs3BACyq7Yh9rc1THnZrFZTY6TYIH+n428l23gFvn1T0P2u9ABDQ+y+hq7hP8WSWLact+VNdbRuGfX882kIKLlQSdFW+U5zV+/+0u4xD67fV++IeHLh856Zge+UFlAvdJxzlj0VownbO4Ce0q3vkhLysZacArOIc55SKHm8Z8D4hBu3l1gv+as441wmF7s/jG9VPzi45wRD4eI8VOgHiNktlAlC76KIdMM+PQoYcNE7LfNlmazd+Rs/fBW047sLGQbAgrZ8P2SQZGarQliEq9KGj6o9F4Lr94fVCSK1oh5LYL8yVHsiBkLx4qHcjq5xqQ0V+XyCR3l2MlNu7kHlVqJHJ3Io+i/YjaDgt6nLscxqsMfghP52ajqyoeRaL4UaOJjsMOCO/yrRHM/nSPnyYbdMwOh/CNfQ5LeAla9FwwxZ7LAkUTbI40qhdFkyGFYXdcGuBoJzBFx2GVOWwuqBEvK1t7yh0SipjyqsRrdwpbm8W4k+dypLgZDQ1DRwtNPCXmHeLqPkfC1AaYKdSlT9D7Y+YgnmweF3yfEELcMLKTBWJ5sBrE9I9HGwpRHxstjllQqMFYClhlvyF/GjloT164PODVdJUZKSpQIOLuK8lb1LxRfdacmP1tb9EDZ05ahHFw8OQubk21b+4SxwAIkwVe0PBi8xNmBxQN4PFSjOWkNecEqwkFht5NmEMx/6KRADHn2I8D8jVFY5pgHax8qnYDMumvf2Xp3h5U/B2OsEathq4P3aeBIJdOyYGSqIt8RzOXVM4k+Acgkco6wJ9WoD9sDi0H5
 n25stDi1
 0Q5jUgFhOtVxuAsL3Pf9eIJhgRg5n/giOG4GzkzoFYnRgERoQF8KrxhP69Y+BDzGr1jXB/hsRmoNxOw5D0qW9OT7LolBRHhIdLZazb6fygrQb+gHhYyVX+lKMl+iFyqKaX4DCjcFplWWAYV9aH9X1UJ5eXDK5+RDSJoQA7vN+XgNt5xJU3dlbAtYr1FyTBCbKIMM0zpFLdMrxrAfH4TEkLEoimp2+xLAM0t/WmUUvOI7xd6ErH/7rrtvXTRIEwksn69WTBr7gmC5XtcFleJT6YAR1dA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 08:39:46PM +0800, Jiayuan Chen wrote:
> This patchset adds a memory.lru_gen interface to cgroup v2, allowing users
> to interact with MGLRU directly on a specific cgroup without needing to
> know the internal memcg_id.

Unfortunetely we don't want to expose reclaim implementation specific
interface to a cgroup. 

> 
> Motivation
> ==========
> Currently, the only way to perform aging or eviction on a specific memcg
> is through the debugfs interface (/sys/kernel/debug/lru_gen), which
> requires the memcg_id. However, there's no straightforward way to get the
> memcg_id for a given cgroup path. This makes it difficult for users to
> leverage MGLRU's proactive reclaim capabilities on specific cgroups.

From the next kernel version, this memcg_id will be inode number of the
cgroup for this interface. So, a simple 'ls -id cgroup_path' would  be
sufficient for your use-case.

The relevant series [1] is in mm-tree at the moment and if you want, you
can backport it to your kernels.

[1] https://lkml.kernel.org/r/20251225232116.294540-1-shakeel.butt@linux.dev

