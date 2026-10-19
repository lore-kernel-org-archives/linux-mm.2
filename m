Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6099CCF2E3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 13:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09F1C6B0269; Mon, 19 Oct 2026 09:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076BA6B026A; Mon, 19 Oct 2026 09:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA8406B026B; Mon, 19 Oct 2026 09:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C37E26B0269
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:46:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 64599406DC
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:46:39 +0000 (UTC)
X-FDA: 85339500918.17.068D0B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A17D7100009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:46:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BqyE52BJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792417597;
	b=NK1tVAv247K5A2Gpxb55woyLZaPI/M4dT9Q4RiXalGYbyWx2wbDeoEq2drqWh5b4K4vs6M
	q1LibroZDVGmMwIFOI59Xy9fllqFidrkLxWu8kQ3pCH4IyiKU/G74mXHc1TPXikQC17xvl
	da77Kzjhevl0rwV5hsjT2ojtHlixxv4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BqyE52BJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792417597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GIOgXb/mnhZxFdGRsi0Jf0fYXTZWOZ0EseekTxOkjig=;
	b=M0JqRJHEYPWLiNgxN1g/xHF/MQYD9bFB51pM2ncGyGVzfi5U1xRl6X5t0BQxdubV5g27fg
	jy7hGLXg7EYkPGJ2EEsfSKzuHRUGjT6s4tq6uEE/Jif27zD/JLcEKyTcgOio5j/Dvq+OGq
	Dv6a1UqQkrj7ZQqkOSmoGdqRvlcOtKM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F288C60136;
	Mon, 19 Oct 2026 13:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BEE1F000C4;
	Mon, 19 Oct 2026 13:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792417596;
	bh=GIOgXb/mnhZxFdGRsi0Jf0fYXTZWOZ0EseekTxOkjig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BqyE52BJIudzcsDq5arU4VxZYP8jdANRgfaSAsySsr/SfWhoTbCY0S6zvW1kK3HPu
	 GdDoQFIsAyEtKwjLr56Fj0KpDOKI9rkD/SKwuzSNgU5Y5RbnbQoqiq/b1nV4kIt1/i
	 CoJECe7g8iRVAee7GK7AM/spZv5PaVNwfj6Tyib7OJf9/7/y1DiU25X7W/UNXEILvq
	 CvQZbD9MU8dYkV9Z6DTgQB7up5xZhD8iLmj/TnFJ0u8I1yEHyLMKGaUJfmj6/BY40e
	 gQ58Uq/U8gyY9kyUD0Je0VFboIlM8CtwDnxlyYvjtTuvpQsyp1WgQKqlx/LnYSTRsw
	 wmInQsE/GIaMg==
Date: Mon, 19 Oct 2026 14:46:34 +0100
From: Harry Yoo <harry@kernel.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
	SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v4 03/17] mm/memcg: add folio-based lruvec live helper
Message-ID: <atYdi3O77m6XzaKu@thinkstation>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com>
 <atEkfmRFgXJCbJuK@thinkstation>
 <CAMgjq7A6Yom=dHDMXk+mpYm3dotgOaVRjPHgUsOryjJ1VjPC6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7A6Yom=dHDMXk+mpYm3dotgOaVRjPHgUsOryjJ1VjPC6Q@mail.gmail.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: A17D7100009
X-Stat-Signature: h65m57ef9xauzyk39tnup1igri3cxize
X-HE-Tag: 1792417597-418439
X-HE-Meta: U2FsdGVkX1/FrRSe0ZFqw7cNT1HNJSNaRHWvgInqWsLEQA2N9f8r4wrUk97awj5JgX0ygaD7OhZib4+Jvkjb136Ow3fXp8YrnJs51YpdKpNQbUKS3MOZlJXyPfoRRyl/5Lh8jpMQ/Yr4Nh4ndBQI7PWrjAMPJPi41ntqB/XQmKFOFgGhsf/atsu5diw43xQDyi87a2UemUzXVHsBfr5guSGYAvy2ywH13qame9z3Xb3gsk7Ns9cg1sGNVOFCkzFscnWEsOvPRwyr3vm+bNVqLLk8xjCua31Zmpv2mAKLVS3PxYq6C7hjWuzv0fjwW+UhStypP1nAOu+4uhp5D2Fzp3hPtvIeHHdL5YNMpSORuZ3SSF2LZaKh2n+88bDiZim3iKfZs4eD9mQDbs0OH0/HExzzxoJpxYBqrwnXKS2+qY71FzGK9tgZpbGFNgd0bCcBgeTRZk0QemmUqTddR7UNLjp60R6OeCxxjP1CSv2f6TVR8N7iD5VEc7GLoUxhHkeoAt3Pp/9OIYiq4l0fdMI1AnjkZy9bx91zOsI4eOLwYLxnbI5DZK9ZQaj9pFojeLUYoO4XuzZJFjCMZRK3kRa/8CUlaXlYiSewFhFSByjFCNj8P5LGQ8QQ2G7pXGt/1VkBwwVZxv8i27vE1FimuVh6uh71836DtXzcDuAPE44DluOZyf1GHYnZ2mrlvaQNH9ex8fxyxtQnqmDoCtgd68K9G1DqGjODvFXPOzTd/o60/I3Nz8tM4Ti6Zr+DzEJpMkqc8tsAPQmqGcU4uJnMZfSgG/HXBtWdWOFCoCokJXT4Dpo1w0fj9iPhWvi2d1w2V+C3GBFTmQua7wr1QqunFKBDPtddJwd01uA+CruSjgYJJLaCHYZqoITHKQhVo/lmT4iuL+ldTTXjPMWZifE1+IXiLAReJoNRMPMsr3yIFpemOlwDUokArcdi3f2XL80Npt8XEriAwx1RjVfkAnuR8C8
 bYGWWoVm
 32CkcdxddER6isluujoZq6Y47+pCsFSTDl0V8f0V/xlAjZ9PCWwRGU0HBpVUWSD6lPp9BnE5V9s8YMcYy428EkR/VBIzZ/y0B08p3RVmzcPYKVlMhuRblw1fAs7mRBmKubLNVKKk37JxgprPdGKvQe9R2y6cyQqYYPkwgrzzK+eYbjJ0y3lZiFl6stQUZbo4iKfe17/8CkEzvFUMlS7J3u3qE0x5tGheCTHWO+2vCDqVfLJi4pV/F3U7SYSLIyhUC7KOifxBbiAuq+HLTjHATEzZvf292R4x9a2xHaRd3CfH6QxfjlGfOidJQ2jVycQl/3dVHcS7jSxQt9kzrKwfaj3FsIBlyUHnyHI2pcwaEOCWg5fgNe9ptG52RVJ+X2K4o8kIn2/CDqVv2PYBuT0o236uRaa+JBGLN4bd/bqfNF9rQOE8fVs4IcRNL3XNw2YUu+gDnYpOpQkO49fk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 02:15:59PM +0800, Kairui Song wrote:
> On Fri, Oct 16, 2026 at 3:11 AM Harry Yoo <harry@kernel.org> wrote:
> >
> > On Fri, Oct 16, 2026 at 02:15:52AM +0800, Kairui Song via B4 Relay wrote:
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Add a helper that resolves a stable lruvec for a folio under RCU
> > > without taking the lruvec lock.  It takes a folio directly so the
> > > lruvec lookup happens inside the RCU read-side critical section,
> > > which a lruvec-based interface cannot guarantee.
> > >
> > > No functional change.
> > >
> > > Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> >
> > This new helper is doing the the same thing as what
> > get_non_dying_memcg_start/end() do.
> >
> 
> Hi Harry, thanks for letting me know, I wasn't aware this helper
> exists, this series started before the re-planting work, so I missed
> it.

No worries!

> But it's a bit different though, get_non_dying_memcg_start assumes the
> caller holds a reference to memcg, while folio_lruvec_live_get only
> assumes the caller holds an reference to the folio.

Not sure I follow. I think get_non_dying_memcg_start() has the same
assumption (a reference to the folio). A folio no longer pins the memcg,
which was a key requirement for the reparenting work.

In the function, RCU is the only mechanism that prevents release of
the memcg and guarantees correct reparenting of local memcg stats
(state_local) as it's reparented in an RCU work.

> I'll check if I can deduplicate it though.

Thanks!

-- 
Cheers,
Harry / Hyeonggon

