Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1849DEEC2A7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 22:36:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ACCC6B0088; Mon, 23 Feb 2026 17:36:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385566B0089; Mon, 23 Feb 2026 17:36:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B17F6B008A; Mon, 23 Feb 2026 17:36:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 142E76B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:36:15 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C4D889601
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:36:14 +0000 (UTC)
X-FDA: 84477181068.24.CADAF7C
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7CE8A1C0012
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:36:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="w7O1/gGx";
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771886172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDZJJyZ7IybQJkD08lIeKoohpnEfHBOokZpr1hipx2Q=;
	b=xaqj5tnGJfs0jPufEddUoaqE5lqsXMrWhZYduKZfb4eNtjCh64db23bG/4IOhwosDWJXj8
	vNPxGMvAPUaQR043j0j/eKPjxY/29wLn8aX9vOrSLyRhJKD1ak4/CCOz3lwGhZlZgxLJt6
	PUZhXiik+id/bd0X2BJ1uXeSl3svMkE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="w7O1/gGx";
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771886172; a=rsa-sha256;
	cv=none;
	b=LfkN7RZ9QtRWtcgn47kkYxHnJlbm8NVfru8D+we1DV2E9grOf2tjZuIL6Zmwh6MM1Qj33B
	dhDrKrpPdzMpMv4wUiXObRDvuAi23Xr9EjRXe0HlP2KaRzQxanvWsBjWq+gkivWAcee3zg
	+/Z0QD1R8N751f6DZWurq6aLx81f5vQ=
Date: Mon, 23 Feb 2026 14:36:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771886170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zDZJJyZ7IybQJkD08lIeKoohpnEfHBOokZpr1hipx2Q=;
	b=w7O1/gGxpf9KkaRXmd2zY7VV0wWYJo83dYPGj/+G+/IdNRODXsASEMfSMzbf6UqJzTJtXb
	uKsU3rGDFmM3JSX/ore6gYZl5pl71WTCFXVlR1ykXPUVrp2YAv27KiAG1cKfMRCgwlqUn8
	iltCqg+uxvPUp31GSbs0/+GFH+eO7js=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-cxl@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/4] mm: introduce zone lock wrappers
Message-ID: <aZzWNM06gNYKDoQW@linux.dev>
References: <cover.1770821420.git.d@ilvokhin.com>
 <3826dd6dc55a9c5721ec3de85f019764a6cf3222.1770821420.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3826dd6dc55a9c5721ec3de85f019764a6cf3222.1770821420.git.d@ilvokhin.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 7CE8A1C0012
X-Stat-Signature: 5xxnqkz365hkegrttjhixr958btrhozq
X-HE-Tag: 1771886172-732530
X-HE-Meta: U2FsdGVkX1/KxKeOaAVg01k26xTq8SzRD+6/0P0szq2WvoQ67UKFMzVcQVdrgmtBu6jcZpRqZJZjrfNHt8Zxa+t2PtEMS4drO8SYhHtMGntKTlqE4Kveq4DFy+Gq6vIrVNWvAWtRTnUHu2jwdpREDw9gYnHuQG+TpTm3kcx9F/ZieplXGtgUT0ref2Sd+QfbOiSHMj0f3ddlJ8KTVJ/yzJDpQGESzuO10PjxU23K1xaOrWoLyuarepVXVT+p/ou1dTA1FM0bmj6CGQ85saMFMLD/9M5EkEgzvm/mQHlT0mWFXGS+nOJcIDfphuFjgqCGadwBrlnHorNWFrw4mL38dyHi8iBrrxzGGsIU/UfIUAjZ5sX9I4OWcCBrokLjXPb24nMq5STL2o4H37Juw2uHhG3WNaVutJpOXwSgOFtz4expbrGMauYGLrOwtjnQ5mpdUWSbirXuffnBCHPZ9dBGAm28w/We6uVb/aFswIUt8EkibmajgWTDTA8ocfaG2jbafVE0AqXK42ijaqwKnlygIxR0SJTphpPvlKCZ4HyYffYZ5C9aKsaoHEY0BjgaeYO3qrzo2pYCxc2UkUOwVANFxHLO5IkmuzxQRbg1/sV+FOhPeUXQQERqN931sg9cafRt5PSqiZhAuMafw5Qvkbd+frjcY36xuO0BsgNRBBQqGmkEUOe4vUiRH5BiFbIfkPxRvAQGDIJHD9V2GOTx/cnbo32G9nO7GDrjCEvhbBdqkeADGHG9LuNWfHNk/mITUxgCttPGdrqcd/qL8XNYSlhoVU8eeqUqwjf6HCw0BQlwoaIVdq3kyMogdJ2lsbCR4ZXf6JKISO1Dxpekwp2Tn/rzgFRko/56vICaouRew9cRaNR8JYI0dTHmG/IPyy3EPhU95CthB6jxEnVDruzc6YetH1fFeZSUaRvYfumPDJ9XyZGjTOUIzMO5eq+QSPDM229vYyq1uj5PHXtvaIKY0rY
 fpopfC0t
 VmUoZ/9KZ7mPLb/m5ZH6GTOcEcUjO7uswBp1oPoRog7dSLvkpUduSvo9WYpp3yGzlCUis7efL063QBA97eyxXaVrljrjvr4CsrhIgudrfCWneOQ3K18/6fWVDTo4lyej5d9G+prVHZbjZTIVuvP7z7miNYMIgFD6524k+6PAXDjP2/bgCJEvLs6lMz0TdQKjMeJccW4Hq3L9ffV3xc+ZFTAxk8OVNHC4GMCVa0t73OiTwQYIOhxQVYNAoFY4EdzEhwWRxVwAA8fGv8cXOVjUCoqLzIYgHTYb3uGJkr1PmMIURQVa/X05EXUqLXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 03:22:13PM +0000, Dmitry Ilvokhin wrote:
> Add thin wrappers around zone lock acquire/release operations. This
> prepares the code for future tracepoint instrumentation without
> modifying individual call sites.
> 
> Centralizing zone lock operations behind wrappers allows future
> instrumentation or debugging hooks to be added without touching
> all users.
> 
> No functional change intended. The wrappers are introduced in
> preparation for subsequent patches and are not yet used.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> ---
>  MAINTAINERS               |  1 +
>  include/linux/zone_lock.h | 38 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+)
>  create mode 100644 include/linux/zone_lock.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b4088f7290be..680c9ae02d7e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16498,6 +16498,7 @@ F:	include/linux/pgtable.h
>  F:	include/linux/ptdump.h
>  F:	include/linux/vmpressure.h
>  F:	include/linux/vmstat.h
> +F:	include/linux/zone_lock.h
>  F:	kernel/fork.c
>  F:	mm/Kconfig
>  F:	mm/debug.c
> diff --git a/include/linux/zone_lock.h b/include/linux/zone_lock.h
> new file mode 100644
> index 000000000000..c531e26280e6
> --- /dev/null
> +++ b/include/linux/zone_lock.h
> @@ -0,0 +1,38 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_ZONE_LOCK_H
> +#define _LINUX_ZONE_LOCK_H
> +
> +#include <linux/mmzone.h>
> +#include <linux/spinlock.h>
> +
> +static inline void zone_lock_init(struct zone *zone)
> +{
> +	spin_lock_init(&zone->lock);
> +}
> +
> +#define zone_lock_irqsave(zone, flags)				\
> +do {								\
> +	spin_lock_irqsave(&(zone)->lock, flags);		\
> +} while (0)
> +
> +#define zone_trylock_irqsave(zone, flags)			\
> +({								\
> +	spin_trylock_irqsave(&(zone)->lock, flags);		\
> +})

Any reason you used macros for above two and inlined functions for remaining?

> +
> +static inline void zone_unlock_irqrestore(struct zone *zone, unsigned long flags)
> +{
> +	spin_unlock_irqrestore(&zone->lock, flags);
> +}
> +
> +static inline void zone_lock_irq(struct zone *zone)
> +{
> +	spin_lock_irq(&zone->lock);
> +}
> +
> +static inline void zone_unlock_irq(struct zone *zone)
> +{
> +	spin_unlock_irq(&zone->lock);
> +}
> +
> +#endif /* _LINUX_ZONE_LOCK_H */
> -- 
> 2.47.3
> 

