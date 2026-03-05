Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E265F47CB6
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 18:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C87E76B0089; Thu,  5 Mar 2026 13:59:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C49336B008A; Thu,  5 Mar 2026 13:59:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F026B008C; Thu,  5 Mar 2026 13:59:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A3AD46B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:59:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 403E114025F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 18:59:48 +0000 (UTC)
X-FDA: 84512923656.18.6097DA2
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf21.hostedemail.com (Postfix) with ESMTP id 379671C0010
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 18:59:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Yu9Wl8qU;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772737186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xIAr9uTlkQoiGY2a6nmMxMk0lhXg3OGIQh+EEVGCqF4=;
	b=doyIrw70HrwG186c796PG9ZM9LFJDbsbmFje81u1xnKKAZZ/RkO0Ec/XmcAjaZ/mbQGUET
	rBKen+sjPjkilUywOJXWh0fomeoSGX4RNgCVgOFjEz7RplJR4Capv4HfaafIGCqrRVSbQA
	gIe829QtIMVxCVmLZGwJlxIZHLWIINM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772737186; a=rsa-sha256;
	cv=none;
	b=oExEzOkNcmalybRXSc3phV2B+FBknXr5CzDo4YRorghaKlqt3XvWGqiO5NIOmKwXRU8R4X
	Y0uWex+92qPAzDgcT2yVC9Uyq/dVPlrnf0YpUpoV/+2JRwpqFOYaYoOod/fRns3aSoCZTx
	CZcMsKspEe9L+8DH++CXGqtIsun3Zis=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Yu9Wl8qU;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 64393B3385;
	Thu, 05 Mar 2026 18:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772737184;
	bh=xIAr9uTlkQoiGY2a6nmMxMk0lhXg3OGIQh+EEVGCqF4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Yu9Wl8qUgY0NYNYCLaNF90IA2VZUwszxKLY9WUGmYRyRQhTHIHYTlLLlG0+XVxrWL
	 rSmpq7m2UiDoXwbdQXlWk5RjV+G3XTm/FdOMIhrogkHuuxyBmsm/lAnM9lv15/pCXV
	 4qf8YBlQ5sdheR8gzAfvo9MzQ9ZSxydSweDd/HoU=
Date: Thu, 5 Mar 2026 18:59:43 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v4 4/5] mm: rename zone->lock to zone->_lock
Message-ID: <aanSnywUXTVPaYUj@shell.ilvokhin.com>
References: <20260304151335.172572-1-sj@kernel.org>
 <ebd994ca-eb04-4dff-a0a8-47aef0934c2c@kernel.org>
 <aanIdk2i-Eo9M967@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aanIdk2i-Eo9M967@shell.ilvokhin.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 379671C0010
X-Stat-Signature: woskasp9bbe1eiyn315euydtxqboqjz5
X-Rspam-User: 
X-HE-Tag: 1772737185-862504
X-HE-Meta: U2FsdGVkX1/VPDnv92TDQf3NfhItQHvFv2yNVKgEHKEKq0SYfHEyCBtuUYddFJx/itWt0QRW2+zN0X48YMEpeScUl4Yt3tTcQw0hq8DEyDVHUUwUIwCTHVXld8LedCR+w9nZJVvIBymc+5YA6vIL7AVkHgIw0kCgRRLl6M5QGxK154/YYOGnOYxQbFN/fkbp7xLUFMfGNXUa0sEs/1BDsshezj4qfAJMD6exA+a0krRtaK2o/a4QWOu36Lmumx7pi6fwy5zS2O4s2V7M30qPW3zt4yuOxLe5gSzaPTJwQhVaMFCtsmzJHiWZ7hm0cjoy0IWsNbhc9hMmatKb8n/H5uYG0YroOmJbmxAw9nXGTvrhBd44a0XWWAllI/NirV+o8PKuRcU1itrL3+brPRv56aNqhqxTkxhqcq4GdBnWhFaXBdofk2TbzZqSk/HOo8KsICm95vC2jMQIinoybB5GmjLDCOzIdBDQ+5ls8L+WjKxR8zmnpC4OgfQxgvaRqxBJytp6uW3zkUjzKmYYpHzvtve+eResUjAYZLR5y6E+zvdAD70MiUwJ9L18DRBbr7UVHgdguVIiHY8yhT8O08XM8GL9yrDHfftuBcdGx81BwwVRulMyXids2/0ysoJ13rg++sPji69BxwzerH2Y6hhVLDSVmAtMuWNpaH3tCf6+iWDqppJ1PuVIbxrTAXPT7RCkxpJq5tQHoAbSzvM67c6hDsV6JyHgS+FPFexqsNPCFdlN3/mu0BPHMKdmzQ+LAa1kVhGQcEFlDdntBpbRPYarU3umNlF3ihCoFtZLzbu8nSrf3wryjDpqci9xP7HsiwSeDRoO0il6CU4h7Ikxf2J066P8dB9O6AXFfKoVzOjgwK8Z0XGAiN8trnuzy9H1QI0seJSbEp2X5gbSZk+CW+1A91Rhtj8f/tglrN48s8x6iZJ4CMtwCK05QTTUzaaSrpLvhLg95N2aMsMVwIQ5aQU
 2RUz6bAr
 A3Iq36OIjiD2Fdw/sEEFN1ycEsfALy9+F3eSoWK8YFKqqwQOE5bJ8LmmpBgAuYOe6L0azIg8ek5e7GmTGVk9B6nfP3oCP07pqi9q5JsHjkIaVUuYUAGtr8CXbuT9/X5Xh8jm/9VdW6npTBCM4BGdt7OBTay3G/4XSvFLOALpnWKAyzK37p0s4PEIpnNqm/tezXFN2YpHBbZt8c0goSDEQuNNsLmi1BkyxyIbOwXkTB8XwiYe503Vh30dXv34u3nkrtUBMny7zgyGcVq8AFlmNyUnp+6UX4V4AV2GlbzmeK+miyP9OKka9O8R2abXK0J3QK5TVbclw3UbtzgfCWFn+4TQHL2cR/w8qeOVW4ctrDc3rWav5X5rTLerhbEb6weCczZBR1/7zfWL4CNfMQaCDEKjABvI6bhRX5uiRzYHcehJkCyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 06:16:26PM +0000, Dmitry Ilvokhin wrote:
> On Thu, Mar 05, 2026 at 10:27:07AM +0100, Vlastimil Babka (SUSE) wrote:
> > On 3/4/26 16:13, SeongJae Park wrote:
> > > On Wed, 4 Mar 2026 13:01:45 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> > > 
> > >> On Tue, Mar 03, 2026 at 05:50:34PM -0800, SeongJae Park wrote:
> > >> > On Tue, 3 Mar 2026 14:25:55 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> > >> > 
> > >> > > On Mon, Mar 02, 2026 at 02:37:43PM -0800, Andrew Morton wrote:
> > >> > > > On Mon, 2 Mar 2026 15:10:03 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> > >> > > > 
> > >> > > > > On 2/27/26 17:00, Dmitry Ilvokhin wrote:
> > >> > > > > > This intentionally breaks direct users of zone->lock at compile time so
> > >> > > > > > all call sites are converted to the zone lock wrappers. Without the
> > >> > > > > > rename, present and future out-of-tree code could continue using
> > >> > > > > > spin_lock(&zone->lock) and bypass the wrappers and tracing
> > >> > > > > > infrastructure.
> > >> > > > > > 
> > >> > > > > > No functional change intended.
> > >> > > > > > 
> > >> > > > > > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > >> > > > > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > >> > > > > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > >> > > > > > Acked-by: SeongJae Park <sj@kernel.org>
> > >> > > > > 
> > >> > > > > I see some more instances of 'zone->lock' in comments in
> > >> > > > > include/linux/mmzone.h and under Documentation/ but otherwise LGTM.
> > >> > > > > 
> > >> > > > 
> > >> > > > I fixed (most of) that in the previous version but my fix was lost.
> > >> > > 
> > >> > > Thanks for the fixups, Andrew.
> > >> > > 
> > >> > > I still see a few 'zone->lock' references in Documentation remain on
> > >> > > mm-new. This patch cleans them up, as noted by Vlastimil.
> > >> > > 
> > >> > > I'm happy to adjust this patch if anything else needs attention.
> > >> > > 
> > >> > > From 9142d5a8b60038fa424a6033253960682e5a51f4 Mon Sep 17 00:00:00 2001
> > >> > > From: Dmitry Ilvokhin <d@ilvokhin.com>
> > >> > > Date: Tue, 3 Mar 2026 06:13:13 -0800
> > >> > > Subject: [PATCH] mm: fix remaining zone->lock references
> > >> > > 
> > >> > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > >> > > ---
> > >> > >  Documentation/mm/physical_memory.rst | 4 ++--
> > >> > >  Documentation/trace/events-kmem.rst  | 8 ++++----
> > >> > >  2 files changed, 6 insertions(+), 6 deletions(-)
> > >> > > 
> > >> > > diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
> > >> > > index b76183545e5b..e344f93515b6 100644
> > >> > > --- a/Documentation/mm/physical_memory.rst
> > >> > > +++ b/Documentation/mm/physical_memory.rst
> > >> > > @@ -500,11 +500,11 @@ General
> > >> > >  ``nr_isolate_pageblock``
> > >> > >    Number of isolated pageblocks. It is used to solve incorrect freepage counting
> > >> > >    problem due to racy retrieving migratetype of pageblock. Protected by
> > >> > > -  ``zone->lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
> > >> > > +  ``zone_lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
> > >> > 
> > >> > Dmitry's original patch [1] was doing 's/zone->lock/zone->_lock/', which aligns
> > >> > to my expectation.  But this patch is doing 's/zone->lock/zone_lock/'.  Same
> > >> > for the rest of this patch.
> > >> > 
> > >> > I was initially thinking this is just a mistake, but I also found Andrew is
> > >> > doing same change [2], so I'm bit confused.  Is this an intentional change?
> > >> > 
> > >> > [1] https://lore.kernel.org/d61500c5784c64e971f4d328c57639303c475f81.1772206930.git.d@ilvokhin.com
> > >> > [2] https://lore.kernel.org/20260302143743.220eed4feb36d7572fe726cc@linux-foundation.org
> > >> > 
> > >> 
> > >> Good catch, thanks for pointing this out, SJ.
> > >> 
> > >> Originally the mechanical rename was indeed zone->lock -> zone->_lock.
> > >> However, in Documentation I intentionally switched references to
> > >> zone_lock instead of zone->_lock. The reasoning is that _lock is now an
> > >> internal implementation detail, and direct access is discouraged. The
> > >> intended interface is via the zone_lock_*() / zone_unlock_*() wrappers,
> > >> so referencing zone_lock in documentation felt more appropriate than
> > >> mentioning the private struct field (zone->_lock).
> > > 
> > > Thank you for this nice and kind clarification, Dmitry!  I agree mentioning
> > > zone_[un]lock_*() helpers instead of the hidden member (zone->_lock) can be
> > > better.
> > > 
> > > But, I'm concerned if people like me might not aware the intention under
> > > 'zone_lock'.  If there is a well-known convention that allows people to know it
> > > is for 'zone_[un]lock_*()' helpers, making it more clear would be nice, in my
> > > humble opinion.  If there is such a convention but I'm just missing it, please
> > > ignore.  If I'm not, for eaxmaple,
> > > 
> > > "protected by ``zone->lock``" could be re-wrote to
> > > "protected by ``zone_[un]lock_*()`` locking helpers" or,
> > > "protected by zone lock helper functions (``zone_[un]lock_*()``)" ?
> > > 
> > >> 
> > >> That said, I agree this creates inconsistency with the mechanical
> > >> rename, and I'm happy to adjust either way: either consistently refer
> > >> to the wrapper API, or keep documentation aligned with zone->_lock.
> > >> 
> > >> I slightly prefer referring to the wrapper API, but don't have a strong
> > >> preference as long as we're consistent.
> > > 
> > > I also think both approaches are good.  But for the wrapper approach, I think
> > > giving more contexts rather than just ``zone_lock`` to readers would be nice.
> > 
> > Grep tells me that we also have comments mentioning simply "zone lock", btw.
> > And it's also a term used often in informal conversations. Maybe we could
> > just standardize on that in comments/documentations as it's easier to read.
> > Discovering that the field is called _lock and that wrappers should be used,
> > is hopefully not that difficult.
> 
> Thanks for the suggestion, Vlastimil. That sounds reasonable to me as
> well. I'll update the comments and documentation to consistently use
> "zone lock".

Following the suggestion from SJ and Vlastimil, I prepared fixup to
standardize documentation and comments on the term "zone lock".

The patch is based on top of the current mm-new.

Andrew, please let me know if you would prefer a respin of the series
instead.

From 267cda3e0e160f97b346009bc48819bfeed92e52 Mon Sep 17 00:00:00 2001
From: Dmitry Ilvokhin <d@ilvokhin.com>
Date: Thu, 5 Mar 2026 10:36:17 -0800
Subject: [PATCH] mm: documentation: standardize on "zone lock" terminology

During review of the zone lock tracing series it was suggested to
standardize documentation and comments on the term "zone lock"
instead of using zone_lock or referring to the internal field
zone->_lock.

Update references accordingly.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 Documentation/mm/physical_memory.rst |  4 ++--
 Documentation/trace/events-kmem.rst  |  8 ++++----
 mm/compaction.c                      |  2 +-
 mm/internal.h                        |  2 +-
 mm/page_alloc.c                      | 12 ++++++------
 mm/page_isolation.c                  |  4 ++--
 mm/page_owner.c                      |  2 +-
 7 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index e344f93515b6..2398d87ac156 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -500,11 +500,11 @@ General
 ``nr_isolate_pageblock``
   Number of isolated pageblocks. It is used to solve incorrect freepage counting
   problem due to racy retrieving migratetype of pageblock. Protected by
-  ``zone_lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
+  zone lock. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
 
 ``span_seqlock``
   The seqlock to protect ``zone_start_pfn`` and ``spanned_pages``. It is a
-  seqlock because it has to be read outside of ``zone_lock``, and it is done in
+  seqlock because it has to be read outside of zone lock, and it is done in
   the main allocator path. However, the seqlock is written quite infrequently.
   Defined only when ``CONFIG_MEMORY_HOTPLUG`` is enabled.
 
diff --git a/Documentation/trace/events-kmem.rst b/Documentation/trace/events-kmem.rst
index 3c20a972de27..42f08f3b136c 100644
--- a/Documentation/trace/events-kmem.rst
+++ b/Documentation/trace/events-kmem.rst
@@ -57,7 +57,7 @@ the per-CPU allocator (high performance) or the buddy allocator.
 
 If pages are allocated directly from the buddy allocator, the
 mm_page_alloc_zone_locked event is triggered. This event is important as high
-amounts of activity imply high activity on the zone_lock. Taking this lock
+amounts of activity imply high activity on the zone lock. Taking this lock
 impairs performance by disabling interrupts, dirtying cache lines between
 CPUs and serialising many CPUs.
 
@@ -79,11 +79,11 @@ contention on the lruvec->lru_lock.
   mm_page_pcpu_drain		page=%p pfn=%lu order=%d cpu=%d migratetype=%d
 
 In front of the page allocator is a per-cpu page allocator. It exists only
-for order-0 pages, reduces contention on the zone_lock and reduces the
+for order-0 pages, reduces contention on the zone lock and reduces the
 amount of writing on struct page.
 
 When a per-CPU list is empty or pages of the wrong type are allocated,
-the zone_lock will be taken once and the per-CPU list refilled. The event
+the zone lock will be taken once and the per-CPU list refilled. The event
 triggered is mm_page_alloc_zone_locked for each page allocated with the
 event indicating whether it is for a percpu_refill or not.
 
@@ -92,7 +92,7 @@ which triggers a mm_page_pcpu_drain event.
 
 The individual nature of the events is so that pages can be tracked
 between allocation and freeing. A number of drain or refill pages that occur
-consecutively imply the zone_lock being taken once. Large amounts of per-CPU
+consecutively imply the zone lock being taken once. Large amounts of per-CPU
 refills and drains could imply an imbalance between CPUs where too much work
 is being concentrated in one place. It could also indicate that the per-CPU
 lists should be a larger size. Finally, large amounts of refills on one CPU
diff --git a/mm/compaction.c b/mm/compaction.c
index 143ead2cb10a..32623894a632 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1419,7 +1419,7 @@ static bool suitable_migration_target(struct compact_control *cc,
 		int order = cc->order > 0 ? cc->order : pageblock_order;
 
 		/*
-		 * We are checking page_order without zone->_lock taken. But
+		 * We are checking page_order without zone lock taken. But
 		 * the only small danger is that we skip a potentially suitable
 		 * pageblock, so it's not worth to check order for valid range.
 		 */
diff --git a/mm/internal.h b/mm/internal.h
index f634ac469c87..95b583e7e4f7 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -727,7 +727,7 @@ static inline unsigned int buddy_order(struct page *page)
  * (d) a page and its buddy are in the same zone.
  *
  * For recording whether a page is in the buddy system, we set PageBuddy.
- * Setting, clearing, and testing PageBuddy is serialized by zone->_lock.
+ * Setting, clearing, and testing PageBuddy is serialized by zone lock.
  *
  * For recording page's order, we use page_private(page).
  */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4c95364b7063..75ee81445640 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2440,7 +2440,7 @@ enum rmqueue_mode {
 
 /*
  * Do the hard work of removing an element from the buddy allocator.
- * Call me with the zone->_lock already held.
+ * Call me with the zone lock already held.
  */
 static __always_inline struct page *
 __rmqueue(struct zone *zone, unsigned int order, int migratetype,
@@ -2468,7 +2468,7 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 	 * fallbacks modes with increasing levels of fragmentation risk.
 	 *
 	 * The fallback logic is expensive and rmqueue_bulk() calls in
-	 * a loop with the zone->_lock held, meaning the freelists are
+	 * a loop with the zone lock held, meaning the freelists are
 	 * not subject to any outside changes. Remember in *mode where
 	 * we found pay dirt, to save us the search on the next call.
 	 */
@@ -7046,7 +7046,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	 * pages.  Because of this, we reserve the bigger range and
 	 * once this is done free the pages we are not interested in.
 	 *
-	 * We don't have to hold zone->_lock here because the pages are
+	 * We don't have to hold zone lock here because the pages are
 	 * isolated thus they won't get removed from buddy.
 	 */
 	outer_start = find_large_buddy(start);
@@ -7615,7 +7615,7 @@ void accept_page(struct page *page)
 		return;
 	}
 
-	/* Unlocks zone->_lock */
+	/* Unlocks zone lock */
 	__accept_page(zone, &flags, page);
 }
 
@@ -7632,7 +7632,7 @@ static bool try_to_accept_memory_one(struct zone *zone)
 		return false;
 	}
 
-	/* Unlocks zone->_lock */
+	/* Unlocks zone lock */
 	__accept_page(zone, &flags, page);
 
 	return true;
@@ -7773,7 +7773,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 
 	/*
 	 * Best effort allocation from percpu free list.
-	 * If it's empty attempt to spin_trylock zone->_lock.
+	 * If it's empty attempt to spin_trylock zone lock.
 	 */
 	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
 
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index cf731370e7a7..e8414e9a718a 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -212,7 +212,7 @@ static int set_migratetype_isolate(struct page *page, enum pb_isolate_mode mode,
 	zone_unlock_irqrestore(zone, flags);
 	if (mode == PB_ISOLATE_MODE_MEM_OFFLINE) {
 		/*
-		 * printk() with zone->_lock held will likely trigger a
+		 * printk() with zone lock held will likely trigger a
 		 * lockdep splat, so defer it here.
 		 */
 		dump_page(unmovable, "unmovable page");
@@ -553,7 +553,7 @@ void undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn)
 /*
  * Test all pages in the range is free(means isolated) or not.
  * all pages in [start_pfn...end_pfn) must be in the same zone.
- * zone->_lock must be held before call this.
+ * zone lock must be held before call this.
  *
  * Returns the last tested pfn.
  */
diff --git a/mm/page_owner.c b/mm/page_owner.c
index 54a4ba63b14f..109f2f28f5b1 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -799,7 +799,7 @@ static void init_pages_in_zone(struct zone *zone)
 				continue;
 
 			/*
-			 * To avoid having to grab zone->_lock, be a little
+			 * To avoid having to grab zone lock, be a little
 			 * careful when reading buddy page order. The only
 			 * danger is that we skip too much and potentially miss
 			 * some early allocated pages, which is better than
-- 
2.47.3


