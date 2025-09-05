Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB8CECA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 21:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 421D86B0011; Fri,  5 Sep 2025 17:25:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F9306B0012; Fri,  5 Sep 2025 17:25:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336B36B0022; Fri,  5 Sep 2025 17:25:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 269936B0011
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:25:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BAE061DDD1B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:25:38 +0000 (UTC)
X-FDA: 83856478356.06.22563F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 160521C000D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:25:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ovDb1vEK;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757107537; a=rsa-sha256;
	cv=none;
	b=4X/7zfKIED3kzRjK4hIxFUgYXMeDPXSanAZHxx2U7g47gbwhHg9Md2nc+WQbbD1Qlkhd5O
	d/kKhKwcyuNCZWGK3vclKnPsd8G+87gCLAgPl6px/4ykhjiJGDWbywtKSC9YUCB+X2zGX6
	HSUe1KRHGwBvWLGHBTU2O4gYIpAI62g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ovDb1vEK;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757107537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQDaUlhfvpfNwIsx3BnmW5265mBNXrpyL5fIyRLxVJw=;
	b=vkwM6vfygQ6Ot9RG0isisiL2Pl+FffwqW+MErBYhjB0dlgUh/LYFxiiz3+2A2G1UG6XJOy
	L9SXRa3EqgIimpVharufzsfsTaQfu8gHNM+w69qVzSp1+KZQ9pbCdBTK31BywYZSiJYR5K
	mxSEPjr8izPmiJFCbi2Yjgnx6XD1Txs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B5BB4406F9;
	Fri,  5 Sep 2025 21:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDACC4CEF1;
	Fri,  5 Sep 2025 21:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757107535;
	bh=WPoJwaVQXGkbzP/Vb9wAK4RsibkCO5VPcszwcm2D9Bs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ovDb1vEKU6V+sG5Osq3FeR/x5JaHP5Z2nwXevsmXNAieLPlSNxerKnohvC9gMBTNO
	 z5c75iIrlm4TDIQ2TT4JI2BjOp31psrlEhVSKhaIYoUYqVEFX7283d17eygYFy015b
	 OCjKZu86gRL3/Rkpf2WrCSlvmkA23+xoVxKtiK8+d0gcreznM7veqM5/azH7D9VovY
	 prWeMNKZ4Ni7PsuEamTvcNq4zQ8aj0uAQifUUUj9em8M4YxcS6FrUZ1B4nPB1A7anF
	 V8EDj0TXZOSV+UmYT2ncSifCTM9PIf8yx96CQ/bOanGYwJ1S+ah93I1Prn1M20udjy
	 XbMJiYu+zQqug==
Date: Fri, 5 Sep 2025 11:25:34 -1000
From: Tejun Heo <tj@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Peilin Ye <yepeilin@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
Message-ID: <aLtVTo-Egnqdjxi2@slm.duckdns.org>
References: <20250905201606.66198-1-shakeel.butt@linux.dev>
 <87y0qsa95d.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y0qsa95d.fsf@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 160521C000D
X-Stat-Signature: je6uuwxfesu915csncieud3a5kyfoibw
X-Rspam-User: 
X-HE-Tag: 1757107536-76284
X-HE-Meta: U2FsdGVkX1+44WdRGwtZN+5Gp6fKb5R4IT4IJZdxO+RMi6sDKGe3tHpAOYMmfEFo0STKaweTWFHMezZivfgqv1LycvZpZUijiPJhgczta0brgtbHJFzDza8A58MG2527zdpE0bprD2xikL4t/vmB7mDRKr8nqgsCQwUjxTNOgUdK64J4yHXLxq6HLXpa1wrLQbRcjHh5gSPeoYH2KiLxT83LqujMD4mDJmRiWd/wwg6Bf2udAbXLQFKXB5iaqnTt71Ba4nPt2LiS0mKnEoCCDiriuvY3Cz28lddrmi+TcRsaAXRcGsZhe/K/Tntvm59bTVi3vQztTEJAv+j5RgUO6fUlUbTnC14VYFiUNpN3Fbc43H4T4/wGr3EqeG3sUwgy1UuH/UCqjylSR+lAigloc+Kk6rbbSLjURvlyYB9HoBI3hCajHw2gJM9BqMvBuQ3/gDk/ovCy8393AvD3uFsozDed09BccWrNMWJ98nmSKjZzjSJpVj17tgP1QOK4IfC445QwO3Ku8vi3AstxKl3rg7ZqSW12wbns1M5ZnJ/e7wL45w4CrQYZLAn01OaQp8Y1OyuxfGoGynwIFlReJD+TsQ8B1jy+ZHFJM0roEEx8HG5F1rFuc6WaCERL4utNfRZjM1UwX9htDpeysvGMtX3kQA2csLGDMZ21ug9SrcgHzy+uzwXDkVIQBkKkUqOKsp5TuHOAcglMXFkVlL/jS8uRzw7wx9AMNnfPB4dITHKCorkKvkEte9VcN+ll6fZq8Xr1aBcMQDqNzVoZs8x4vJ84AgRA1IT7MRULhIPKQMepkyqD19C7is10jAtYbV5eM2g4Pny54OGYo+OadGyh+6IIbZBO8Ic9vPRiMAYY7JeDTCbs9yhvzZzswDYOCoxpefrA2oIGLNosT5/gBjbittSbnzn2txbi9NlHr3ZbtSdoCNgiLfA+Zhdvu8GOmBJHr34tcBICY8Jcwz+cIlHH53e
 NRYDW0G7
 RM/njXLIdL5lZwDW+kJx7EpAF6eVAD3L50Rv2O87zqcBsc58isVOG8CMeyS+mbXLEzPAoAi2lWVfmZd5kX3pHuCse5FSv5K/YboaUG+ZTSDEQOEaWtVPL7fGskJ8dDlx8WPMawi8HDKKwvYHfl0kwpSVgfYEohbMrUrox6OGxqY9R3nBDqFvRMUCzIEo5xBk1outoqPTGKC0n2Ma/XDYaiVYCeQdKkryCMwM30M0/1FA9R/z6v35lshaCv2cCixR4m9ElxoksFGwMWLA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 02:20:46PM -0700, Roman Gushchin wrote:
> Shakeel Butt <shakeel.butt@linux.dev> writes:
> 
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
> 
> Hmm, what about OOM events? Losing something like MEMCG_LOW doesn't look
> like a bit deal, but OOM events can be way more important.
> 
> Should we instead preserve the event (e.g. as a pending_event_mask) and
> raise it on the next occasion / from a different context?

Maybe punt with an irq_work?

Thanks.

-- 
tejun

