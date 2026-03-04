Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 987D0EF8FEE
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC3476B0092; Wed,  4 Mar 2026 10:17:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C842C6B0093; Wed,  4 Mar 2026 10:17:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDBB06B0095; Wed,  4 Mar 2026 10:17:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADE736B0092
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:17:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7CE0D16064F
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:17:58 +0000 (UTC)
X-FDA: 84508735836.28.F44A83E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id CC748A0015
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:17:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lSvA+2M7;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772637476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gORGfo/eZSWsCbmV3QLCxXLN1L/w9q3NtduvMIsLB5U=;
	b=WK5H68DgajKhSCdoe3BsZnwBDbAqWUvOsLkyVXyX6zULskaN4kYhW7zHB1Qeq+QGeTmNq6
	7wgbw3VWkkq6swKtI8khkyyNw21Co+xwR7yJ50WdrGxiKP3gw/YtrTRFUKKbPb5AsCwmTF
	gIQ0BBC8sEL8WFteCKzCYVzEegFsaiM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772637476; a=rsa-sha256;
	cv=none;
	b=BeNOSKchDbIR716+po8Qo16/Vp6drq01BJM+ATjjiQxyUhnQZ84HaN65hiuLPfSbmG/lij
	rwnvoWe/2A0WpxJcvH2cYIBrZOlG84bRO9iASyghD7vxD5cxtpq00sTosbXR0JRyqsOD53
	1u4ynoFfwO7OThQK/yRx854lyO8WEOQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lSvA+2M7;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 22D9660097;
	Wed,  4 Mar 2026 15:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53805C4CEF7;
	Wed,  4 Mar 2026 15:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772637475;
	bh=57ImQNx7V4C6fEwHSIwRuOuyP5pxZ9XC+64vaT7Z0fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSvA+2M7lNneZJtS9EGoh6arq6gkKMsjh8L1g9NeTPJUw6aLeazosXn2Yr481RbLC
	 8CgsomHKptHsJMI0NQlhWQ0lvwTUsaF1AHrB7r/4ds+y9Y4mljkvugHvk3awgfu0ge
	 Z3XjZDeT2GSxIWMOj7/aunr2TxAhmq6d4oKxq7qnApk+uW7l9zdS4CoaBulAwg9dY8
	 LrKKqMzFdQ09K2IJVi/Ebqq4u+pi4iPbtIi3OBbt+fy5iXvIb4hdwFuqXGMMcbau/D
	 3v1Adi2arxboGcAoVQIvnmkPL8z9b324zPTHBBaYTjG9jujKTNSqy+1Yt1x2e3T7kA
	 rn4ftOD6VwIlw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>,
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
Date: Wed,  4 Mar 2026 07:17:46 -0800
Message-ID: <20260304151747.172713-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304151335.172572-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CC748A0015
X-Stat-Signature: 78w1ikfqg6rmk96mg1ean1preqskbpac
X-HE-Tag: 1772637476-714698
X-HE-Meta: U2FsdGVkX19AhyimvSV5CWdfm0hLGaz1KnHDTMIrhd4yErhB2ZhJEgXZcMkdR9M93G9I86v5GKjsT7pAWPH5CgN9qPaNlCx5kVhI07wewRQhv7SJxxZw7Ct6zUAFmLnf4OS6iRgnFr5dw9IOcFOU5v7Jh/FvaKqvZ8VsFKYFXjfleBhE9KmkqZFJhBD/5sQkBFsitOMv/igVGUQpaYaRSPWqZiJzbjDtCH3xcwoY+4zPXtVxWFoMDOgzf+EX8pUi2XPlz0ahM0oQlfyvdkmwN21BBgFM7gKccbGwqEpj0C/yrlYtECL8P2kenzA9dqOA0RBx+LRqzO5lH9veUyttpPiZ0Gl2sw7Ayjb577gIhiJeZc9NFRMsdvLDQZFqPL1mgGm5B7V0Bew4JFjquC+uM9U3PF55VHKGw1iNnMq3fMst0VmBwNO7qzZL0V/4/VUe7qX5gbMBfW1u/aHiw6wSWqDDt1kxGhg6Fd7KrVB0S1DTIRBH80ZvtGPwDXNToWt6FSrZM9iM/r8i60VIFqYZg7pZ/rJi/NrTIPBQ7nxaSaFDK4cjhnLqqrWGHjVeACOPi78K1gibOp8XSAla4gwWeqCzpAuVlLiywQVqItRXnNIPK+TDk6ZxUVnySDreZ4H64GxCFqkRgxYKcQEFIr/bbin4+YsXASk9doRjq4WX8/42U5ZfX9DPgV8+StJjg6hawG239nwWY1686AMVn3UkuHPkd5+Dqv6xD6BYu45SltsnNrnI0KurWS3AfyqeAM3uix2XAMYPi+KsQIh71WiUjaZCjt7F+fvGlKW1W3qTLOzx/dlBbVw/P7dGLWoKdjhl5yPnQdr1POr5miVMbh2prnREP3VHcWBW//sHGacd5XaQ49PH67s/UM/F/4CzZeQKVF15l1vE/3IN1UNrY0d2ZsGwDLXn7lb76AiEORknmKZTfx/SW3clMauz9aTRSRY9kHJLs2dPw6h7HzcTbI7
 100n1p8Q
 u1TL/oSaKDS3oqr+ievjpRcAbwePui+9rtvYiycaG7k4juVRKIDZBd/npBSQZhX0h1RrEQwHWr/jUoB6c1VCQhepcsRH2zyMBpFz8vm0bY2fnR75GZlMt3JGJKz5C+Vl0/gw/mmMf6YgGFHGCg+40JPDPFRjV8nT927aFs61trsnse4GC2X0LMTUJJit4ZR7+JSGEFODuMrzNtbxjFDTuBNKQK4oJ3ME5F62WUxzpjoCWjEpKDy5rCTx+1JnsHhss9Unq9jUZBhUt0GqknhpWV4KSDQQBjDUl92pdBX1a2/5e+hImgtw4GjSFLOonXwNL4aby0HI9zc94lUqBgFQPLRGDqD6QgwIb18r50/0C83SZdJ8CTsrC/YolcnsZOL/grlk7w4zsQty6hNE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  4 Mar 2026 07:13:34 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Wed, 4 Mar 2026 13:01:45 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > On Tue, Mar 03, 2026 at 05:50:34PM -0800, SeongJae Park wrote:
> > > On Tue, 3 Mar 2026 14:25:55 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> > > 
> > > > On Mon, Mar 02, 2026 at 02:37:43PM -0800, Andrew Morton wrote:
> > > > > On Mon, 2 Mar 2026 15:10:03 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> > > > > 
> > > > > > On 2/27/26 17:00, Dmitry Ilvokhin wrote:
> > > > > > > This intentionally breaks direct users of zone->lock at compile time so
> > > > > > > all call sites are converted to the zone lock wrappers. Without the
> > > > > > > rename, present and future out-of-tree code could continue using
> > > > > > > spin_lock(&zone->lock) and bypass the wrappers and tracing
> > > > > > > infrastructure.
> > > > > > > 
> > > > > > > No functional change intended.
> > > > > > > 
> > > > > > > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > > > > > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > > > > > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > > > > > Acked-by: SeongJae Park <sj@kernel.org>
> > > > > > 
> > > > > > I see some more instances of 'zone->lock' in comments in
> > > > > > include/linux/mmzone.h and under Documentation/ but otherwise LGTM.
> > > > > > 
> > > > > 
> > > > > I fixed (most of) that in the previous version but my fix was lost.
> > > > 
> > > > Thanks for the fixups, Andrew.
> > > > 
> > > > I still see a few 'zone->lock' references in Documentation remain on
> > > > mm-new. This patch cleans them up, as noted by Vlastimil.
> > > > 
> > > > I'm happy to adjust this patch if anything else needs attention.
> > > > 
> > > > From 9142d5a8b60038fa424a6033253960682e5a51f4 Mon Sep 17 00:00:00 2001
> > > > From: Dmitry Ilvokhin <d@ilvokhin.com>
> > > > Date: Tue, 3 Mar 2026 06:13:13 -0800
> > > > Subject: [PATCH] mm: fix remaining zone->lock references
> > > > 
> > > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > > > ---
> > > >  Documentation/mm/physical_memory.rst | 4 ++--
> > > >  Documentation/trace/events-kmem.rst  | 8 ++++----
> > > >  2 files changed, 6 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
> > > > index b76183545e5b..e344f93515b6 100644
> > > > --- a/Documentation/mm/physical_memory.rst
> > > > +++ b/Documentation/mm/physical_memory.rst
> > > > @@ -500,11 +500,11 @@ General
> > > >  ``nr_isolate_pageblock``
> > > >    Number of isolated pageblocks. It is used to solve incorrect freepage counting
> > > >    problem due to racy retrieving migratetype of pageblock. Protected by
> > > > -  ``zone->lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
> > > > +  ``zone_lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
> > > 
> > > Dmitry's original patch [1] was doing 's/zone->lock/zone->_lock/', which aligns
> > > to my expectation.  But this patch is doing 's/zone->lock/zone_lock/'.  Same
> > > for the rest of this patch.
> > > 
> > > I was initially thinking this is just a mistake, but I also found Andrew is
> > > doing same change [2], so I'm bit confused.  Is this an intentional change?
> > > 
> > > [1] https://lore.kernel.org/d61500c5784c64e971f4d328c57639303c475f81.1772206930.git.d@ilvokhin.com
> > > [2] https://lore.kernel.org/20260302143743.220eed4feb36d7572fe726cc@linux-foundation.org
> > > 
> > 
> > Good catch, thanks for pointing this out, SJ.
> > 
> > Originally the mechanical rename was indeed zone->lock -> zone->_lock.
> > However, in Documentation I intentionally switched references to
> > zone_lock instead of zone->_lock. The reasoning is that _lock is now an
> > internal implementation detail, and direct access is discouraged. The
> > intended interface is via the zone_lock_*() / zone_unlock_*() wrappers,
> > so referencing zone_lock in documentation felt more appropriate than
> > mentioning the private struct field (zone->_lock).
> 
> Thank you for this nice and kind clarification, Dmitry!  I agree mentioning
> zone_[un]lock_*() helpers instead of the hidden member (zone->_lock) can be
> better.
> 
> But, I'm concerned if people like me might not aware the intention under
> 'zone_lock'.  If there is a well-known convention that allows people to know it
> is for 'zone_[un]lock_*()' helpers, making it more clear would be nice, in my
> humble opinion.  If there is such a convention but I'm just missing it, please
> ignore.  If I'm not, for eaxmaple,
> 
> "protected by ``zone->lock``" could be re-wrote to
> "protected by ``zone_[un]lock_*()`` locking helpers" or,
> "protected by zone lock helper functions (``zone_[un]lock_*()``)" ?

Maybe too verbose and people who not used to regex might be confused.
Mentioning mmzone_lock.h might be better?  E.g.,

    protected by functions in mmzone_lock.h

> 
> > 
> > That said, I agree this creates inconsistency with the mechanical
> > rename, and I'm happy to adjust either way: either consistently refer
> > to the wrapper API, or keep documentation aligned with zone->_lock.
> > 
> > I slightly prefer referring to the wrapper API, but don't have a strong
> > preference as long as we're consistent.
> 
> I also think both approaches are good.  But for the wrapper approach, I think
> giving more contexts rather than just ``zone_lock`` to readers would be nice.


Thanks,
SJ

[...]

