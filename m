Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF4BF01804
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 08:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 961556B0095; Fri,  6 Mar 2026 03:06:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90EB26B0098; Fri,  6 Mar 2026 03:06:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83BE46B0099; Fri,  6 Mar 2026 03:06:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F4AD6B0095
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 03:06:05 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13A4A14043A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:06:05 +0000 (UTC)
X-FDA: 84514905090.09.09D87F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5D675A0013
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:06:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e7IawFCH;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772784363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wThyn0miyrDFY74RpLM8dbe63bKotUruuQw/jFVwkhs=;
	b=tKDWY0xwrFV5MlinEkfQaHYVmNP+o+Qx97BOu3UShSL6M57kSaS6kYjanLvzEpL/KDWu/W
	m1v+7oxRoKvn2LHLyS7Hw/wpmw+FShQrxkqrurPTNmmv8paQ+XGv+TyzwxhlHQwEZSA3/F
	vnXOkbowtV2TRGv0oecw8+nY2SI8p78=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e7IawFCH;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772784363; a=rsa-sha256;
	cv=none;
	b=Qd1mn/WnRT2NLVryvBLeOITqT8uIR9UiQ1yyU0RhaBqIGF+WzqSI0bJayJ87HAADKZoNcA
	abqg6Kyxa39vDaryEiljnKT/PNlUMhlMXJtACx/3sIhX0H5XeAbO1ru/MbsiBz0Scx1Qhm
	NeHHPF27lGXHIJbcgTl0vF3V82qJZHs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 94C8B60126;
	Fri,  6 Mar 2026 08:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07EEC4CEF7;
	Fri,  6 Mar 2026 08:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772784362;
	bh=LBnLAIcGHsesTcn5+nCMswocvTfZ7iqXSC/2rWKf6mo=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=e7IawFCHAhTtgO2GugIeECwEAMAUwS7CAhKdLOxCNwho2wzUPrFmxuX0/LHIKh4Kw
	 qraeumJ9ZyUL57jNsPz2RIDPJu/e0skvhJsg7SPOAgHZWcL4wA41gYL6zd+LS3tapH
	 b4Pd4tRflwrRsgHHdIQkUGAAYYcHq41rSp3OsLdy8ARqGbWLeGLMs999tv6BBhu+cy
	 10G0W/9KMXIiaWZrXgag1vJzwIY6HCA+8DjBbKyU5wuZhatlvNDmiV4zOTYa6PxYIJ
	 Ex+l2q4U7fRWA3kjpxzxDE2jrt1NzEyabYTyDqMGKONV5Peg3xCTHd/3B6baFYUWXF
	 W6t1hx5WKLGqQ==
Message-ID: <3b0b7f7f-c1b0-4f1c-bece-ce0cae130cb5@kernel.org>
Date: Fri, 6 Mar 2026 09:05:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH v4 4/5] mm: rename zone->lock to zone->_lock
Content-Language: en-US
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org
References: <20260304151335.172572-1-sj@kernel.org>
 <ebd994ca-eb04-4dff-a0a8-47aef0934c2c@kernel.org>
 <aanIdk2i-Eo9M967@shell.ilvokhin.com> <aanSnywUXTVPaYUj@shell.ilvokhin.com>
In-Reply-To: <aanSnywUXTVPaYUj@shell.ilvokhin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5D675A0013
X-Stat-Signature: 4damn69ed85u5btqrtc6pgi9yd59r1yk
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772784363-748796
X-HE-Meta: U2FsdGVkX18Ljph99c0j8geRSMbK8W+WY/jJTLHQeiwX/OjY3YvEwMrD2uobNFyB4kc5rM7umCiiiHiCVq/eNBBGHcz9Op/0Tx07D+Q+cTfNPtf/NRvr/QIbrYjSmolzoJvvEHTqzClr8WE/kYdEyeDWAwtaEj1KdgQeOBKffh0OkqwIYRj5aCG7GMzo8/3cY3qb/zbDTtqGstEt5LPE1ooKN38Bma6ptdqMiij/zzH170XRQIvnCDL+NwNOBiEQn/o2ieCSxRx4jmaXffoMPJpJ78IQ9Yt1oZSRvCbYLdexHnP82lMa82OGHFTFOrWk10X+jjmcaWjEyuO56h7oziqTnG4gG32RpPe4EkaHdoDZ02vvweXHruDZXnACB0yXzS6HRJ9gRda6n2DjsZcwnYmuXrgfTvhJFo0LU5RNPJDe70ZPWD2HtsAjDWpO6wLUe0ziexPTmovll5xuHzp5taPF+N9B6CBR1qSIfUAPk4S+PMM5f1Yxiu4gHaPElsESeqy4khevgz2L6fuEiW2Uma1mkABvNIToK+5DUHIYQHxwuNMjik6M/0iSMUaPd9Ou/ovOCqf9yfcZWFJg/NRpzuNn7gnhP0Jk1bXD2/iNPOooYkAdcATniZDNOlZTn/I+CWiI7Mczk29E9JmFtqwrK7tm5FBjnXfExgdIeTHglu7aW6NQjMwbofZV87lYZakdU22uNP4azc0GnEk13x9AihCAItJ2nFrbMudesubAvGHK81SUOZ6vXigBtdR7/Tdhd+MMY2JFr6fL2urGJ8VU1qH4fgdgPHh1fPaU8sdJqvCobBKFcZz9ai10kYyglxMR8i1cg5BiVoYflHpOJVkKhb7A2VUtn667kUM4nh28BoABfiJaR3vB8fGXBw6/uBGZc6wXYwt3g3VAGvCxZRmky0bIxiA7uGQcWNb0tyA/0kfPPDAdbCEhBM7KOKsHf0cp8EdHuicrIyiLtOpbxIc
 o715xwSn
 glw2Yo1+NR0EbIq/AecWoaDiY01M7g+PRWz3f/tQTnN0QMG6f+jgNJcUwVEdCIH2wKzQUjRn5DQu3s3WnyQgqJMLgCqbOFpOg5hL2AYMcbz0c7flA6FbevZYnhQBwo+BZWiSfHwMTx2QZvN5xDIbHtVpWcc0dxyV1IZjc62wAOsvR9IUdj6wvhfVs/HxPaol95vjyo5QS3bR6KfO/294LDP6xlKBOhXVbtMu49ExgkZJ6IuTxQMJpUdoqbWf+vCUArBCUnQIzJhDgpIKWEqIr7BsvSh9Zu09PuZ/G/0fpD5Ullsth/U4cY3tXPWKh5XAvDTSoB7uXwSby+2A4hb7yy7JFjzFBZZbMCdD8d/wXbu7UiQSXaSZPkkDl3OiUpbXcxazWaepoJXM0l06xsCsQWnYPwckOBqxYiovnoUkMeh+hMAwYXVCWzCiKFLgFBrfvJvXt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 19:59, Dmitry Ilvokhin wrote:
> On Thu, Mar 05, 2026 at 06:16:26PM +0000, Dmitry Ilvokhin wrote:
>> On Thu, Mar 05, 2026 at 10:27:07AM +0100, Vlastimil Babka (SUSE) wrote:
>> > On 3/4/26 16:13, SeongJae Park wrote:
>> > > On Wed, 4 Mar 2026 13:01:45 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
>> > > 
>> > >> On Tue, Mar 03, 2026 at 05:50:34PM -0800, SeongJae Park wrote:
>> > >> > On Tue, 3 Mar 2026 14:25:55 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
>> > >> > 
>> > >> > > On Mon, Mar 02, 2026 at 02:37:43PM -0800, Andrew Morton wrote:
>> > >> > > > On Mon, 2 Mar 2026 15:10:03 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
>> > >> > > > 
>> > >> > > > > On 2/27/26 17:00, Dmitry Ilvokhin wrote:
>> > >> > > > > > This intentionally breaks direct users of zone->lock at compile time so
>> > >> > > > > > all call sites are converted to the zone lock wrappers. Without the
>> > >> > > > > > rename, present and future out-of-tree code could continue using
>> > >> > > > > > spin_lock(&zone->lock) and bypass the wrappers and tracing
>> > >> > > > > > infrastructure.
>> > >> > > > > > 
>> > >> > > > > > No functional change intended.
>> > >> > > > > > 
>> > >> > > > > > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
>> > >> > > > > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
>> > >> > > > > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>> > >> > > > > > Acked-by: SeongJae Park <sj@kernel.org>
>> > >> > > > > 
>> > >> > > > > I see some more instances of 'zone->lock' in comments in
>> > >> > > > > include/linux/mmzone.h and under Documentation/ but otherwise LGTM.
>> > >> > > > > 
>> > >> > > > 
>> > >> > > > I fixed (most of) that in the previous version but my fix was lost.
>> > >> > > 
>> > >> > > Thanks for the fixups, Andrew.
>> > >> > > 
>> > >> > > I still see a few 'zone->lock' references in Documentation remain on
>> > >> > > mm-new. This patch cleans them up, as noted by Vlastimil.
>> > >> > > 
>> > >> > > I'm happy to adjust this patch if anything else needs attention.
>> > >> > > 
>> > >> > > From 9142d5a8b60038fa424a6033253960682e5a51f4 Mon Sep 17 00:00:00 2001
>> > >> > > From: Dmitry Ilvokhin <d@ilvokhin.com>
>> > >> > > Date: Tue, 3 Mar 2026 06:13:13 -0800
>> > >> > > Subject: [PATCH] mm: fix remaining zone->lock references
>> > >> > > 
>> > >> > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
>> > >> > > ---
>> > >> > >  Documentation/mm/physical_memory.rst | 4 ++--
>> > >> > >  Documentation/trace/events-kmem.rst  | 8 ++++----
>> > >> > >  2 files changed, 6 insertions(+), 6 deletions(-)
>> > >> > > 
>> > >> > > diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
>> > >> > > index b76183545e5b..e344f93515b6 100644
>> > >> > > --- a/Documentation/mm/physical_memory.rst
>> > >> > > +++ b/Documentation/mm/physical_memory.rst
>> > >> > > @@ -500,11 +500,11 @@ General
>> > >> > >  ``nr_isolate_pageblock``
>> > >> > >    Number of isolated pageblocks. It is used to solve incorrect freepage counting
>> > >> > >    problem due to racy retrieving migratetype of pageblock. Protected by
>> > >> > > -  ``zone->lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
>> > >> > > +  ``zone_lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
>> > >> > 
>> > >> > Dmitry's original patch [1] was doing 's/zone->lock/zone->_lock/', which aligns
>> > >> > to my expectation.  But this patch is doing 's/zone->lock/zone_lock/'.  Same
>> > >> > for the rest of this patch.
>> > >> > 
>> > >> > I was initially thinking this is just a mistake, but I also found Andrew is
>> > >> > doing same change [2], so I'm bit confused.  Is this an intentional change?
>> > >> > 
>> > >> > [1] https://lore.kernel.org/d61500c5784c64e971f4d328c57639303c475f81.1772206930.git.d@ilvokhin.com
>> > >> > [2] https://lore.kernel.org/20260302143743.220eed4feb36d7572fe726cc@linux-foundation.org
>> > >> > 
>> > >> 
>> > >> Good catch, thanks for pointing this out, SJ.
>> > >> 
>> > >> Originally the mechanical rename was indeed zone->lock -> zone->_lock.
>> > >> However, in Documentation I intentionally switched references to
>> > >> zone_lock instead of zone->_lock. The reasoning is that _lock is now an
>> > >> internal implementation detail, and direct access is discouraged. The
>> > >> intended interface is via the zone_lock_*() / zone_unlock_*() wrappers,
>> > >> so referencing zone_lock in documentation felt more appropriate than
>> > >> mentioning the private struct field (zone->_lock).
>> > > 
>> > > Thank you for this nice and kind clarification, Dmitry!  I agree mentioning
>> > > zone_[un]lock_*() helpers instead of the hidden member (zone->_lock) can be
>> > > better.
>> > > 
>> > > But, I'm concerned if people like me might not aware the intention under
>> > > 'zone_lock'.  If there is a well-known convention that allows people to know it
>> > > is for 'zone_[un]lock_*()' helpers, making it more clear would be nice, in my
>> > > humble opinion.  If there is such a convention but I'm just missing it, please
>> > > ignore.  If I'm not, for eaxmaple,
>> > > 
>> > > "protected by ``zone->lock``" could be re-wrote to
>> > > "protected by ``zone_[un]lock_*()`` locking helpers" or,
>> > > "protected by zone lock helper functions (``zone_[un]lock_*()``)" ?
>> > > 
>> > >> 
>> > >> That said, I agree this creates inconsistency with the mechanical
>> > >> rename, and I'm happy to adjust either way: either consistently refer
>> > >> to the wrapper API, or keep documentation aligned with zone->_lock.
>> > >> 
>> > >> I slightly prefer referring to the wrapper API, but don't have a strong
>> > >> preference as long as we're consistent.
>> > > 
>> > > I also think both approaches are good.  But for the wrapper approach, I think
>> > > giving more contexts rather than just ``zone_lock`` to readers would be nice.
>> > 
>> > Grep tells me that we also have comments mentioning simply "zone lock", btw.
>> > And it's also a term used often in informal conversations. Maybe we could
>> > just standardize on that in comments/documentations as it's easier to read.
>> > Discovering that the field is called _lock and that wrappers should be used,
>> > is hopefully not that difficult.
>> 
>> Thanks for the suggestion, Vlastimil. That sounds reasonable to me as
>> well. I'll update the comments and documentation to consistently use
>> "zone lock".
> 
> Following the suggestion from SJ and Vlastimil, I prepared fixup to
> standardize documentation and comments on the term "zone lock".
> 
> The patch is based on top of the current mm-new.
> 
> Andrew, please let me know if you would prefer a respin of the series
> instead.
> 
> From 267cda3e0e160f97b346009bc48819bfeed92e52 Mon Sep 17 00:00:00 2001
> From: Dmitry Ilvokhin <d@ilvokhin.com>
> Date: Thu, 5 Mar 2026 10:36:17 -0800
> Subject: [PATCH] mm: documentation: standardize on "zone lock" terminology
> 
> During review of the zone lock tracing series it was suggested to
> standardize documentation and comments on the term "zone lock"
> instead of using zone_lock or referring to the internal field
> zone->_lock.
> 
> Update references accordingly.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!


