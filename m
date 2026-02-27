Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 952BBFD9E26
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 00:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBBB36B015E; Thu, 26 Feb 2026 19:45:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8FC56B0260; Thu, 26 Feb 2026 19:45:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D85086B0276; Thu, 26 Feb 2026 19:45:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C39686B015E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:45:59 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8DA01140253
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:45:59 +0000 (UTC)
X-FDA: 84488394438.02.F54AB20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D7376A000C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:45:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N5/u1IOs";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772153157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=86UkKb1KgMuBrh7/WgoHjehPXv4MORsHae533XC9OJs=;
	b=Y0lKbuCfaqMLaAZwERV7gytfdI14NcdZ6eN/QQ7UYvpnVKu+UMzItHvjiPnvZ5OXgSX1Dr
	hI5CWJGyKXFOELr+JDKdQCYnUH5bUjo9WO0pkvZoFPBm4iTxTASyMFy2B/MQFMpMi/wrNL
	7XSd978aeZ+51BD5VgPO5uSHe9zXoBI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N5/u1IOs";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772153157; a=rsa-sha256;
	cv=none;
	b=dFvtai2r5bus0C+2g+F3URoGRj0CiuCKoPnWkfTXNIw5pcM+rI2e3DFGSN2TczqQYnmLEW
	eYCtbFeM/EOo86zBUgroIddTNE9HON4EqceSBBR1vzcY2CJWCcLn6IxXF5qP564PJs2i37
	4jKzax0C5FbFFBxj7EVAVFUo7D9tQNc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 202AF600AD;
	Fri, 27 Feb 2026 00:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE24EC116C6;
	Fri, 27 Feb 2026 00:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772153156;
	bh=7stlFYCl1LQeMv3JNhnoSvzt9QhLvt8aUlCsIpsOmHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5/u1IOs51h8aCGcDabK8JxMaRFCCz3yl/81Kyfp2I9SmL8WNud2TGw1i6xPTNx2+
	 YkBlcdmAlq03sHWV9EXKAPQF1dpu9RdaR/SmBF18k1H5a78VPeTzgZMyQr1463r7tt
	 U8FPbQENYrGx1CPlO+DNYhbWgqVlCA8C186mEv6qpHCuntkOSqmQ/2LJJySaJ9STRB
	 ipFC3tGfwLOEvSxvB/Xhgv0M7v0BhgXnlLVOKYZQjI30fOPWH5/HZt0+9InTZFnXJL
	 1tDMAQMyXo0idZuX80df97Secsv4Lpq45x7LyGctpT7z9CBeMovuOgDwhIU4D1NJIt
	 634MDT7vDZDUQ==
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
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	Benjamin Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v3 3/5] mm: convert compaction to zone lock wrappers
Date: Thu, 26 Feb 2026 16:45:54 -0800
Message-ID: <20260227004554.83555-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <01729baf359e4c6612aead53f1fcb644f782d1de.1772129168.git.d@ilvokhin.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D7376A000C
X-Stat-Signature: c71zxjisy4czntbwizbxatynpcqrtn54
X-HE-Tag: 1772153157-335329
X-HE-Meta: U2FsdGVkX18zP81Ae3kVEpIzLZoNuYoLInos2Kb+/2Mh48jkcA0NiVqW7fy+xwHGf6y9E1mU7r+CJygS8xYfLL65yqDZhNf+KyGifXMqgIH+V3WQh/ZCrkQaw4d8tj3oBZfHam5g9Tdwu0OPA5yUen5ZKeqwgDIEZnbbf0rJb1FJc7WDY8qcFK28XsLOO9JFIc2skY8KLF600tLUrNZfFseB4Dwzg0dZ1yuk1utWFmx3OO9yeRnwC1MxV8Vq10sWAyq3SmdtM4O5eBwl8NMKp8qqgDAxC+vKmpzie4bzd8/KH7ooWMb7I0XG8nSbZ+G5ZzRfB4Nm9lFXv3/gjZMaEBvnYOGAU1FVJcW4dayUsTQPCax8xX7pfMGZF4BzaY4xVxlsFiyBseykXft/SCvg2nZ2XhagA86iLYQn3gc2M1GKdGPD0a/Xv5BLId1fosWJcOfB/VtpGzX042cVDWSbRsBuIncn2ASP7Y0mO9OSHcFIqm3zzBWVAuQjUASyh+zkSCwQqNir3+uLxrqv36JFRGB3IX2BwXpHFj7ggZC7En/IeWYbVc87Ihcw/F+sE8Jjj8kaz4h2u/cXPxjUYm7AapHuNmUUE+5BZFj/tMw0Zp/LCUnOIYNTfA8dT4M1V77d/PqIHEg1qVfBApj9MjRu0EdE5K9K2JM0nPvjW31rWygVng/76RgCdNYLdMk3cajh7pz37X7wIpPKYDc8uM7M1Q81Ov2ZxDYOJrn4s2yoXCgEbgwpdvi8KuSgqXYgIdxVU6cvj2xmFmDnZzGuoemrpKZMZqQ8qGtc0IkDcRci60U7Y6WWvT7AKbZE5vvRNvYaLEpvh2bIClyw6KGOo8ziiMqdncdtKL00bXc02Bb9Rz56HY3xuObx2pqdvkM5gAVJCfysPPQhLDNsMGy8YRo8QeRU7rL7rO4SPL9orsO9si531LnFLblpS++sIBbGArmFYiLAtZgMGdDjTAd73xL
 +LoD9MmX
 V/XkfqDU0YvDoIgUnRenQH4qzER3x1XbBeOWhjd/j7qYbrVe8WUX86S1snzYwu3hXX+d8KnvvE681JjYxMBXnk6Y1qj7d1LPwWu9s5hvrcoiAhoB3vLPrsUUUfu0ugCMfVyD/fjNUR+cCufhA+wMxCl8NG+qmK0Ewd7Xa1BR4CEvZFHqyNY5ow/AngqSIZMWvh02td3QC47CMvP04tn8qhnbNlJeiXKoQ2pgJSD6QMnONcnPFdH5YHqu3+KJpsl481xjTpIOTurJLZ3k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 18:26:20 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> Compaction uses compact_lock_irqsave(), which currently operates
> on a raw spinlock_t pointer so it can be used for both zone->lock
> and lruvec->lru_lock. Since zone lock operations are now wrapped,
> compact_lock_irqsave() can no longer directly operate on a
> spinlock_t when the lock belongs to a zone.
> 
> Split the helper into compact_zone_lock_irqsave() and
> compact_lruvec_lock_irqsave(), duplicating the small amount of
> shared logic. As there are only two call sites and both statically
> know the lock type, this avoids introducing additional abstraction
> or runtime dispatch in the compaction path.
> 
> No functional change intended.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> ---
>  mm/compaction.c | 33 ++++++++++++++++++++++++---------
>  1 file changed, 24 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 47b26187a5df..9f7997e827bd 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -503,19 +503,36 @@ static bool test_and_set_skip(struct compact_control *cc, struct page *page)
>   *
>   * Always returns true which makes it easier to track lock state in callers.
>   */
> -static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
> -						struct compact_control *cc)
> -	__acquires(lock)
> +static bool compact_zone_lock_irqsave(struct zone *zone,
> +				      unsigned long *flags,
> +				      struct compact_control *cc)
> +__acquires(&zone->lock)

Nit.  Why don't you keep the indentation?

My impression based on below output is that mm code prefer indenting
__acquires().

    $ git grep __acquires mm
    mm/compaction.c:__acquires(&zone->_lock)
    mm/compaction.c:__acquires(&lruvec->lru_lock)
    mm/khugepaged.c:        __acquires(&khugepaged_mm_lock)
    mm/userfaultfd.c:       __acquires(ptl1)
    mm/userfaultfd.c:       __acquires(ptl2)


Thanks,
SJ

[...]

