Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F11BEDEBE7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 01:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CABD6B0088; Tue,  3 Mar 2026 20:50:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978556B0089; Tue,  3 Mar 2026 20:50:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87AA26B008A; Tue,  3 Mar 2026 20:50:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 794CD6B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:50:43 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2CDDDB8920
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:50:43 +0000 (UTC)
X-FDA: 84506701566.14.DEF6ABA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 72EC2180006
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:50:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NMf6wHgU;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772589041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhZHsPPRl/Z+5UeOuM4lCJAFg/64NDuszGAU1B/T9fs=;
	b=51Aj/gPy+X0Uatw9M/UOihuT4P3pLqAej3/PoUlg0P0a6Hf1UEo0WZizGXAR8yStoV2eZh
	GnJH8+aqhjCHlSdlM47koHjwNOrXopmsxPKGig9QiIlIerO/u4SjFbmSBS0R2sDdgydbLN
	vSGZ42PtI6QzLIpFHay9nW2qPSCIo4w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NMf6wHgU;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772589041; a=rsa-sha256;
	cv=none;
	b=DIzXyMAd0rfYk7vXSaj6uoPluDrHEKSp/YeGXQguMae4PmHgyMYa3yx3spv9bzZNI8EU6r
	V7GPOa7bM4vqi6vKvSOBH03/0fEEXrWV8AYzJCWg3CKVtH2QrKBG1xCYJK7TYm6CeBR3Wn
	QHQ8exqXsuADVt8mL9qDu6wabopACz8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A55F43C31;
	Wed,  4 Mar 2026 01:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0B3C116C6;
	Wed,  4 Mar 2026 01:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772589040;
	bh=O1q5xmxh+8ddRQkx9dw/RmwoUPF0G+lCo8Vxz/LWoc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMf6wHgUjBtsficAhTrZpbDymeP1qrJm9gVBDymeA284t3/4xD/IUN4lsK8wjWy+0
	 bt6Y0geh7b6+ibfslggbZaS+3PjKY4n9O7gpimLq9/ZpKkd7YK3id1SyXOZg5ouJUt
	 uCo3eHNYq8lUU8smojeLkxDQFMVVIdERceZ9EsdlPydbI7Q2l/lMKn1kZcAQzyoIqC
	 8kACgcsK3/8fyojRSMUBnfjlAfY7nOBxBH6s2TEmHbq7UnjMV4sa0IGNnhhOzVEle5
	 lbqA+w5yQeiS1As+ECWzKZrk9mNG9pC+HMt4/sVmhuZobunJ7mNsMpM5MZ/oCu3HN9
	 3+17MGIcWJ4hA==
From: SeongJae Park <sj@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v4 4/5] mm: rename zone->lock to zone->_lock
Date: Tue,  3 Mar 2026 17:50:34 -0800
Message-ID: <20260304015035.84839-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aabvc4Xhc9qBfaG7@shell.ilvokhin.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 72EC2180006
X-Stat-Signature: 3z3eaagmkqshwi96rhcpcjbhy1pb3dfi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772589041-313082
X-HE-Meta: U2FsdGVkX18XqLXPdU9IkhR8VLbcMYIx9HcWEiReVd08+BIaQ7HzIi0aMesxYhYjaXl1uSfQhKNhpmixhBuFuisi3Mh7jEY8oNeG9bg8oZh/IxdKpBKGnDiLT0PBb8cqAA7jYETyZ4cP6sHzX1slU0I9HPugTWDV1vuTaggMQzw5TP59mjT2MkcztI9KTuJ7lXLvZTI3k7lI2qEXcCOuuzt2++ZdBM1qMfNPYv7YJQUjV8UHE/aHjRi7NFr6vL9WHY7XDPxti4l+J4wHcgZlreeq/bXTLeZvqE/PB+iWB0ydorp17h2hws5eeO0crf+ezAoNYHtzjv4DHHRY8X3wxySR7n0oO0NjBgZ3ykAC2Ch2PA+YvB3lfAgrzoLMwixRXD7ROz7lj9/qHzn8RkJS52q72qoCG+lss2KMSh0sz7C/Ff6th1LXBj/0f7pmtsiVkfQ9TPK6M3NAWMfElJTKSgwYB2BS0E0jWunA9bJwREQTDls2P94kZ1udgDQkG9Kj147E2uEMP9k9JWu4LxolTt4Cv05ApK/z0oWR/rcKKwQE/Dm0/Kpn/Ev1rKq49lb9zNCr1TurSkvqQ+2eTKBhyZWauR3nAXPc7+aLZQm3PYCAypzBOWkJVwqJOS2kyiSaRc0QUhFT/++Xe7kYFyn1gvUs7DhuD0srGu+F3J3xbNs0yV+1rzg06PrJyBrLNMT+KxqnLM+gM3vKwc+Og9cNBO5vQjwWk5w8GWqRvNyDiK3OnTdfzyOAfbCDf2/DMfHiqgRUemINwWEoPotHpsMOisQUyaUhqnYS0U91RUzXGfGhZ7CJBkNAHjcc07bISCDYcD0bu7IyOgct5x17IOgoFmrhPYL4x6GvhZtv+VPLqcubInKI2xJ27OZ0SbDnt6viXgLi5ZAZhuAOkdITxtM5w/RYVDSQObwQxyA6ZBhrSoF7yry4Cpr3YH4hrj2Q/V37gPxsMgXbUIG2KBEx2nu
 B+hcQa4C
 zxljYMRa/IFoixsgkDhgadfR11pwpeIOTQc+EextSA/6Glv/ldk0TD9xO52JVCGdpv9KZmVAQ1AvMExVvBYhP9G6tKz+9mNCPjB+MRq0JRgVyYPnsCs0P+43E8iQjv3FmZYvXC2VK4AsuRJFoCQ4WmSxTWwwvuW3Mzcn9tjs60eRYUwo++8xKLotNeRAUEGNNBlE8alb+K/7AMQZuLjzYc5QkG6x5fIyr+nLXSZHAnrulPKFT29nNxWoz95hTsaRS9Vo/B0Wy26tSmwg3mQOeiDP16FXhk4c3u2AAOZGOK+8vEQGwJcq5SfN4TI03e7cNWBbDZ36v1t9jA9u99PE3JD679wrqRVOzzcuI9MuU2LbVkXMP/+i55S05OxuwWCdDmugQz3DPo+W0ZVy+vDceIowjeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 3 Mar 2026 14:25:55 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> On Mon, Mar 02, 2026 at 02:37:43PM -0800, Andrew Morton wrote:
> > On Mon, 2 Mar 2026 15:10:03 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> > 
> > > On 2/27/26 17:00, Dmitry Ilvokhin wrote:
> > > > This intentionally breaks direct users of zone->lock at compile time so
> > > > all call sites are converted to the zone lock wrappers. Without the
> > > > rename, present and future out-of-tree code could continue using
> > > > spin_lock(&zone->lock) and bypass the wrappers and tracing
> > > > infrastructure.
> > > > 
> > > > No functional change intended.
> > > > 
> > > > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > > Acked-by: SeongJae Park <sj@kernel.org>
> > > 
> > > I see some more instances of 'zone->lock' in comments in
> > > include/linux/mmzone.h and under Documentation/ but otherwise LGTM.
> > > 
> > 
> > I fixed (most of) that in the previous version but my fix was lost.
> 
> Thanks for the fixups, Andrew.
> 
> I still see a few 'zone->lock' references in Documentation remain on
> mm-new. This patch cleans them up, as noted by Vlastimil.
> 
> I'm happy to adjust this patch if anything else needs attention.
> 
> From 9142d5a8b60038fa424a6033253960682e5a51f4 Mon Sep 17 00:00:00 2001
> From: Dmitry Ilvokhin <d@ilvokhin.com>
> Date: Tue, 3 Mar 2026 06:13:13 -0800
> Subject: [PATCH] mm: fix remaining zone->lock references
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> ---
>  Documentation/mm/physical_memory.rst | 4 ++--
>  Documentation/trace/events-kmem.rst  | 8 ++++----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
> index b76183545e5b..e344f93515b6 100644
> --- a/Documentation/mm/physical_memory.rst
> +++ b/Documentation/mm/physical_memory.rst
> @@ -500,11 +500,11 @@ General
>  ``nr_isolate_pageblock``
>    Number of isolated pageblocks. It is used to solve incorrect freepage counting
>    problem due to racy retrieving migratetype of pageblock. Protected by
> -  ``zone->lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
> +  ``zone_lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.

Dmitry's original patch [1] was doing 's/zone->lock/zone->_lock/', which aligns
to my expectation.  But this patch is doing 's/zone->lock/zone_lock/'.  Same
for the rest of this patch.

I was initially thinking this is just a mistake, but I also found Andrew is
doing same change [2], so I'm bit confused.  Is this an intentional change?

[1] https://lore.kernel.org/d61500c5784c64e971f4d328c57639303c475f81.1772206930.git.d@ilvokhin.com
[2] https://lore.kernel.org/20260302143743.220eed4feb36d7572fe726cc@linux-foundation.org


Thanks,
SJ

[...]

