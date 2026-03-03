Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A786EC145B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 14:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 660F76B0095; Tue,  3 Mar 2026 09:26:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 638546B00A4; Tue,  3 Mar 2026 09:26:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B0B6B00F7; Tue,  3 Mar 2026 09:26:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 461E26B0095
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:26:04 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D567457767
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:26:03 +0000 (UTC)
X-FDA: 84504976206.29.DE03904
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf03.hostedemail.com (Postfix) with ESMTP id 08D6A20006
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:26:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=cR1o2MTN;
	spf=pass (imf03.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772547962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNVFddGP/SQV1eCKP4+0NtVgj/0UkiifX6TCYuJFdss=;
	b=ARcOu8rRtdZhEQY7Fb3B3TqMsOklFMsKxbvpHO8xWHkryqyLPX+JTg1En8Z/qW4PIDZCPY
	IYgSa5AZooLlV4E/vEu9anZ4jJnqR66PuUKM5mO/JbuZoO9wHvZxyyaMuog1zcbJHYZMnq
	GtU5Y+cTscchMlshy4HarZWU9eVYlwU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=cR1o2MTN;
	spf=pass (imf03.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772547962; a=rsa-sha256;
	cv=none;
	b=z9z9RrbSFUMmnN3arWn+NBSEZbwoCn70soj9/VH7Zwqn5Z0PpWGEKay7OCNoWlYOY4yAzI
	EK+cElaEbspYu4leNr0y+msZjWWqmWLspFfMGTCidL55jSZ+YOAUiOU2W/N/WywguZzuCp
	BTmfPhI1CnZQ6QIN5VoOpIfWfuPIZtg=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id DDD3FB3100;
	Tue, 03 Mar 2026 14:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772547960;
	bh=LNVFddGP/SQV1eCKP4+0NtVgj/0UkiifX6TCYuJFdss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cR1o2MTNmIgJM6CSLHyWv2tw4JfyPhDpRjgo6tiqz7f4s2IZ5YCSw5z6tNQXgor7/
	 fhP27pb7RcpWqjF+WmGNTd/A4By/OK271NUgciUW8p2iipyod2Rkd4JS3l1K9JMASN
	 /hTSH+NuohXjtj/oRcJWrcMcZsLRnqGsDfXUKBlg=
Date: Tue, 3 Mar 2026 14:25:55 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
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
	linux-pm@vger.kernel.org, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v4 4/5] mm: rename zone->lock to zone->_lock
Message-ID: <aabvc4Xhc9qBfaG7@shell.ilvokhin.com>
References: <cover.1772206930.git.d@ilvokhin.com>
 <d61500c5784c64e971f4d328c57639303c475f81.1772206930.git.d@ilvokhin.com>
 <0f340324-502b-4719-b3e7-c7ccd4378385@kernel.org>
 <20260302143743.220eed4feb36d7572fe726cc@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302143743.220eed4feb36d7572fe726cc@linux-foundation.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 08D6A20006
X-Stat-Signature: 1n64nxcsjyj5u5o4797oshdj7zjpj878
X-Rspam-User: 
X-HE-Tag: 1772547961-876470
X-HE-Meta: U2FsdGVkX1+lhDK5RKhklmu8pNsgOf6hWNqF5kc+v3IAj2WVdJHojAh7JPpXi9PcuOV/l2Mj9XpVQ9SVQBZno3WAmGcaVTEhY2pDWHjkRR35UROSP/ute39Pnj6x4c1XsE7g5ic4z47qQQH9sptKUv0PADn2BlRtnaHDtsZcoMTAs5RaiIysohreja7xUS+D7hcunhDVC6XeWHqZ/jh+2curgaDiPJnbXjdSu9mo40jLcKN3tJql2VRfmrBk242hMcwNj5PsgcoVYdBUtZhMrXlVkxBdFDEAOHgsoRlVtnOxlE6UVm0B1QNE1KbGKZ+uekc8CLYjXLnaC0yPfLN/LQoP00Dz1Bq4avRon2aB4XzIchpfF303vvyazOk72TMcsmq6YX8NgeqcD/YshVtgfrWJD4h0gE79jcLhdPS1tojWq0WZ80wx00d83yt8kduRZMHwKdVnRMp8J272v7nDYRUeMKY+rV0rFq0pEYSmSeiEwTvu2hhdlyXr/hCEGL7JZJUZXFqyWP5Iorvcajotcx9ptDs7b4JCxdWQgu/KtDCLYFK1qnYGcO5YaUp6yXo19tKuFP6s+iRM3N5rDwfcRH+4SNKvl+MaBk/835x0nt5IkBjXoD/bP8me4s+t8soqMB/2sPVQku15G4EfqY559UGPVVMZZroRueZQLjooT8PZAO9g/2RVwtUnnSk4hsFFSPgvEEZVLo7U2J47o/JHk6MIh7lBXo5oHucvgUGnEpORMfq/SA/ugwcKCOicphuR0meQu3BczX0d5YIECVqDxvxRUH5V30d/NxukV0fQoUcnsiD2cHncT1uIjwNbW4dV8B+XWGR6wJawubJFVyGRyI8oug+erTJWGMVPr5C45Uud8I/lsa5juQXzSQyUgOVRjbl4B56E/WtPR0Om/QJDpLhwTr0Foa+GsS+6LqNFlKBXrWQI0dCMy2ai82GaRy1V+5/6PqnuoHphScyCh+j
 E2PwfZY0
 sh+DW6EWAKu+JM3byrIRHOPsPXgZaCHTIIUD2u1eYiCrKo/I8Sdk2atqPufW2IHx9/93wQnp6G5077INhkVT3Wsq5IZA9F9CyA8b1Q4S/+FYFrEkr5mourJ6ofZAvEReU3NVXY5fsazRcpvMTferlLL/yocPaervucA/LWjZ0nwN8BbTGKonXiv5eud2Fp5WP/4ugC6uNj9YjKP7ZzcsC5x65w2ZxVt72ixnR7RGQQ8QTvZyXWKn9TkBvNbJ/Pf7qzKfOW279kRsiA4KkiDOyFhWzEufykSSMaOwCpu5g0PdB+DsHpEZUkDkIOqLoaJNBZs5JIHDfZeTGWHTvRpktZsICyeOBgS6noKVms6/GAtW5Xh2VcdcnHaEqzNXYDHflatQ06My3r8UnCxzCvIvnLHCE1JfJzfBVANT8pQFBiJUAnZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 02:37:43PM -0800, Andrew Morton wrote:
> On Mon, 2 Mar 2026 15:10:03 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> 
> > On 2/27/26 17:00, Dmitry Ilvokhin wrote:
> > > This intentionally breaks direct users of zone->lock at compile time so
> > > all call sites are converted to the zone lock wrappers. Without the
> > > rename, present and future out-of-tree code could continue using
> > > spin_lock(&zone->lock) and bypass the wrappers and tracing
> > > infrastructure.
> > > 
> > > No functional change intended.
> > > 
> > > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > Acked-by: SeongJae Park <sj@kernel.org>
> > 
> > I see some more instances of 'zone->lock' in comments in
> > include/linux/mmzone.h and under Documentation/ but otherwise LGTM.
> > 
> 
> I fixed (most of) that in the previous version but my fix was lost.

Thanks for the fixups, Andrew.

I still see a few 'zone->lock' references in Documentation remain on
mm-new. This patch cleans them up, as noted by Vlastimil.

I'm happy to adjust this patch if anything else needs attention.

From 9142d5a8b60038fa424a6033253960682e5a51f4 Mon Sep 17 00:00:00 2001
From: Dmitry Ilvokhin <d@ilvokhin.com>
Date: Tue, 3 Mar 2026 06:13:13 -0800
Subject: [PATCH] mm: fix remaining zone->lock references

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 Documentation/mm/physical_memory.rst | 4 ++--
 Documentation/trace/events-kmem.rst  | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index b76183545e5b..e344f93515b6 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -500,11 +500,11 @@ General
 ``nr_isolate_pageblock``
   Number of isolated pageblocks. It is used to solve incorrect freepage counting
   problem due to racy retrieving migratetype of pageblock. Protected by
-  ``zone->lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
+  ``zone_lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
 
 ``span_seqlock``
   The seqlock to protect ``zone_start_pfn`` and ``spanned_pages``. It is a
-  seqlock because it has to be read outside of ``zone->lock``, and it is done in
+  seqlock because it has to be read outside of ``zone_lock``, and it is done in
   the main allocator path. However, the seqlock is written quite infrequently.
   Defined only when ``CONFIG_MEMORY_HOTPLUG`` is enabled.
 
diff --git a/Documentation/trace/events-kmem.rst b/Documentation/trace/events-kmem.rst
index 68fa75247488..3c20a972de27 100644
--- a/Documentation/trace/events-kmem.rst
+++ b/Documentation/trace/events-kmem.rst
@@ -57,7 +57,7 @@ the per-CPU allocator (high performance) or the buddy allocator.
 
 If pages are allocated directly from the buddy allocator, the
 mm_page_alloc_zone_locked event is triggered. This event is important as high
-amounts of activity imply high activity on the zone->lock. Taking this lock
+amounts of activity imply high activity on the zone_lock. Taking this lock
 impairs performance by disabling interrupts, dirtying cache lines between
 CPUs and serialising many CPUs.
 
@@ -79,11 +79,11 @@ contention on the lruvec->lru_lock.
   mm_page_pcpu_drain		page=%p pfn=%lu order=%d cpu=%d migratetype=%d
 
 In front of the page allocator is a per-cpu page allocator. It exists only
-for order-0 pages, reduces contention on the zone->lock and reduces the
+for order-0 pages, reduces contention on the zone_lock and reduces the
 amount of writing on struct page.
 
 When a per-CPU list is empty or pages of the wrong type are allocated,
-the zone->lock will be taken once and the per-CPU list refilled. The event
+the zone_lock will be taken once and the per-CPU list refilled. The event
 triggered is mm_page_alloc_zone_locked for each page allocated with the
 event indicating whether it is for a percpu_refill or not.
 
@@ -92,7 +92,7 @@ which triggers a mm_page_pcpu_drain event.
 
 The individual nature of the events is so that pages can be tracked
 between allocation and freeing. A number of drain or refill pages that occur
-consecutively imply the zone->lock being taken once. Large amounts of per-CPU
+consecutively imply the zone_lock being taken once. Large amounts of per-CPU
 refills and drains could imply an imbalance between CPUs where too much work
 is being concentrated in one place. It could also indicate that the per-CPU
 lists should be a larger size. Finally, large amounts of refills on one CPU
-- 
2.47.3


