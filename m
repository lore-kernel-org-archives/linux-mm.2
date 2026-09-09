Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6517C79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082866B008A; Wed,  9 Sep 2026 13:09:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032896B008C; Wed,  9 Sep 2026 13:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB1D36B009D; Wed,  9 Sep 2026 13:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D38CC6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:09:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 02C311C1C7B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:09:30 +0000 (UTC)
X-FDA: 85194860142.04.83E9C29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 595CE1A0007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:09:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YNyzfKHe;
	spf=pass (imf19.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788973769;
	b=Gf9DiU3cMzemonzML8/ePpiAG7lGG6zEr0BYPNAVWtHnc7STlWds06EU8ZexRes4JlhK6y
	d4VzAQZ0QYsnATylrDOl6xu1by/mNi5sEr5RxYStcfRmxTG+eGmm0KJssdpH3ZDdeJSbWK
	iyjByqd5sfEpvhTYUjCKQYTO3pyHZ2Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YNyzfKHe;
	spf=pass (imf19.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788973769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aV+nOwJ5Gj3tu2lGPRWNLzdJqg3QTrStyGxv4qGWJgU=;
	b=y38zJsbolPAiw/IpJKFJaGbsG2kwGFHyuSy7YcdblwFO2KAvDSLiOC+m1p+2yhmq6fX3kL
	5Ca4dDKyUrXqGfQN/85GWcH7GleBRKPTX3E0FoeIYxmjGyoY9sRLWmxtgpUD3SiuAFwos2
	nJNiRbtFz3whJy8U7/TyvU6ATiOAq3Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 88D1B4180D;
	Wed,  9 Sep 2026 17:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662051F000FF;
	Wed,  9 Sep 2026 17:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788973768;
	bh=aV+nOwJ5Gj3tu2lGPRWNLzdJqg3QTrStyGxv4qGWJgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YNyzfKHeuXIUl+W/PcDxkZrDmdeG6hDakZVShiQRZ0O44JliSmf+yf1kfjBnQgVch
	 0tBQrA472BNig++FCUMuqjk1MRmRqMi+xYDALklMdKjCvpuviMyndXZO9d31bg1BGT
	 DEuPtbx0DZPB9A19Ix+oR8Q7NjsLYs2iSJfA49SpjWumUDl7sEL9Leth0Hs4KoEazj
	 J43gzrNFR5NUo3aPVBvgjZXdsoc1c9u/6ACOAogC1vkflSUwZgPM3XRaiDN4NGeBa/
	 OwDKgrxtyjjf026wXT8dlONCA7Bb9FWePmO1mOSpztlmT70NkdyBMl1y80u4Mj7Pvl
	 kyr9Qb39RBb1g==
Date: Wed, 9 Sep 2026 19:09:19 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/12] mm/sparse: refactor sparse_sections_init()
Message-ID: <aqGSv_VPT1IKGgIs@localhost.localdomain>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-2-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-2-008fc8d579fe@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 595CE1A0007
X-Stat-Signature: wjwx78usdt88tyuk8nc7xg5i1ppc78ex
X-Rspam-User: 
X-HE-Tag: 1788973769-135257
X-HE-Meta: U2FsdGVkX18c55YJYzsS2jDZrfuyNhRJP4rzy/0XNkO4lyhpLOJ4iddbwLXvEYbT+UaMbp/zaBrf/n1jexB8PeDFDGPTxA+Wt9/TiIUGbrRQfCgNAKK/L0FWva+VHpHiLM/B8G2f4dHiH0I/ZnHDSaUjyZRzslnKFBeS78Mh4aP+7TnFNgpqgOInMMFBWSJgyFHyaLJLEmhgLiyGiA6lHoccGNwujUe3k9SfKG9HRklUMWKui7L9nDj/LFyHwIw6HqVWIkaVcsmFCvVM3FuroiYaj4BHeLk+Iqh70TUh9zJZTqoeFIFzxVIiKhrYhGAGOH3INtjjx3uJfp08V+VwI/enGICcxTE0ijFUjK/pn2Qfq3U0IAZdIYwpPvht+EhNiCS4XWSHkhYxgKSqMt3RECdUx9vxfEJXYLqEEajdw8ocjvbMgd55FmC9TSJUeNpyeOJzWaQf1zU1gw5sP0y+6yX8rBHQLB3auN37SvuzdunPZdJmp7t4EKzd9hVwQ1X1NcjjXYIcDf8pEJCBpWw+IZs0IloUI7hEda1DwDWVIQf7kZkOIc3k4q4z8b6LOEaO4OSS3MRctdkskz1bm0Hi2nU2PPjDmBw4zgVM1YArXMIkad0RUImVNL0gTosTSk/yKllJm+X2rkdL5lHaDDgbIbxMBTuFTrl+DhQLK/9JgszSmMlPoDZCO96NUtx9+9t2eYTGYfvlY8aOwPjbNUJK84zVCe0x2/SKH8bUWX70cyjBzDinDqA6Hey2de50Pf9u1A89tfWelRb9ws/4Dq8l6/mmBXRpA34+X8hyfWV/Dj+fJsTO7ZrdBURmvc1nMAtwOPDr2DyMC1EmTKnDPA70FXQ5bOxgIPb4FerscWSPptw6VHpYdV/JQrQvRA7iZltfUUn1qOnBvAN350RUS+n9O5Rzo6z4aSvBn3/+TFxD1WGFMuWS1DN2+r13Dx+SDo2mzs/7Fm9LnDQt42u2yt7
 eL/LUZgW
 hFVNLIKjCpsU1U0yfVSV1IXQsDoI8mKBY/v726o/tRmMpxXATmlcYRc9lU9ZAzHigFjsF12YG8ZClc3a4ak+2ZF65yzcvg1J74dU8aZpKYMp1K9AfeijggC/mbSA70g0LjuTuX0xeDAeKTv/OqEsv7e65eDPJjPL/HgjH+vf+VwBA1YGVtuXqxrYBmpB0pko8Cd4G4X+9Xm2Ijw/egizXzdAyXDrLbFOL1FWlYDjn0AT2siplqDQVnHJApbNl1NWMAzY0laEfkZDemLCJip2OyKkaKFkDGttv6ozj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:32:55PM +0200, David Hildenbrand (Arm) wrote:
> memory_present() really identifies+prepares all early sections so the
> initialization in sparse_init() can properly iterating them to
> initialize metadata.
> 
> Let's just inline memory_present() into sparse_sections_init() and
> cleaning up the code a bit while at it: make it clear that we are operating
> on pfns.
> 
> Note that we call set_section_nid() now only if the section
> was not already created earlier. Now, there is no more inconsistency
> between what we (temporarily) store in ms->section_mem_map and what
> we store in our section->nid array.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>

Not sure if it was intentional, but it seems we lost the "Initialize memory section ..."
comment.
Do we want to put it back? Maybe for the folks that are not really
familiar with all the memory section's inner stuff?

Besides that, nice cleanup :-)

 

-- 
Oscar Salvador
SUSE Labs

