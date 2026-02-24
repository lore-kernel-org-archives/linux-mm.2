Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8363CF3C991
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 15:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BED156B0089; Tue, 24 Feb 2026 10:18:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6D6F6B008A; Tue, 24 Feb 2026 10:18:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6FF86B008C; Tue, 24 Feb 2026 10:18:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9652C6B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:18:10 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 32DBE1BFC1
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:18:10 +0000 (UTC)
X-FDA: 84479705940.25.88F2200
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2649E180011
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:18:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=TjYFzDnt;
	spf=pass (imf24.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771946288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vjbAdZH+HcILdXS95EbQM6Jm5jY1DudQ1+3DHISJ1DA=;
	b=b7WIk/YwX1o+e54PteM9omQG6brDuXZhzjAlRn3KMn1jCgnRal8urkjGLc0oILr/l43R12
	8XWlInp+umeVlns5F9o2SoqQR81yqdovxPyNidD2FzmKFDdFtBhaX+6OlUr69DCU18SPaF
	7n6Zfa9SELCg4zOQ6VJzGe+a1ilwfWo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771946288; a=rsa-sha256;
	cv=none;
	b=G6+DKMZf7WfsJ6IWckmYSTKl2GU1SNek+bshLEhIfyf0UrrKxA+fayJugDw3TIlt5kWgTk
	vH8j6JPt8mNTgEdr9EEdWugvSdwSAs1VYdGpSo6xl51eYIuSGLnIXGOAamwuXA6n2lcYIz
	CBucXotOBrddSCXptquN0mSEG83x2ts=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=TjYFzDnt;
	spf=pass (imf24.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 19550B2BA8;
	Tue, 24 Feb 2026 15:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1771946286;
	bh=vjbAdZH+HcILdXS95EbQM6Jm5jY1DudQ1+3DHISJ1DA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TjYFzDntZp50UvP3NtII4msWGYbwxHj/LdBYNJDkgknZzO2x7YgnkPEOJk0K2PNZD
	 NjeKtNqKpmkJN9o2WGX6gfta0wgyn1rfASSQWYb49P3Fzg7dfvrY9LhjwLKUxh451F
	 h4F06Z6WAEXz5H5HL+NvHHCjU1pdi/cbo+UsgbZw=
Date: Tue, 24 Feb 2026 15:18:04 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 1/4] mm: introduce zone lock wrappers
Message-ID: <aZ3BLKzhIIZvkbwL@shell.ilvokhin.com>
References: <cover.1770821420.git.d@ilvokhin.com>
 <3826dd6dc55a9c5721ec3de85f019764a6cf3222.1770821420.git.d@ilvokhin.com>
 <aZzWNM06gNYKDoQW@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZzWNM06gNYKDoQW@linux.dev>
X-Rspamd-Queue-Id: 2649E180011
X-Stat-Signature: 3abkgduwt5ojxgccwyrnuw6he7tts5ky
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771946287-227346
X-HE-Meta: U2FsdGVkX1/pIeyd/H1K16z0O4Ejp21/RE6pNn2KoH7UTQ/9Vd9ISwukIeBBbIZlxRzgJRlFw+DWE7o+VqiGSCCsjGmu3sVopX/D4PO9KQN+5rtDUSQDcXNru8ZJV/DJDc6BJ7ucJZczciHy0Im/6SR0+YlNGVH8vQurIu/TdwSlnWa8FgnEmHAg91Zec9HMEeW+84g4J59Om30TamuFbG/uRj0rgSRaJzAgIzWHTHWYVxHm0V0MVKiAhhLvZy/camlrQSJYwRwoOmAIN4xj35Gg+cetOXRmrAkeAqC5CiDEVhXOD9c81SpLMaf8Gf/rygONvDvLb6dJtHS4nYpsf1fWX9MDUaHVMUK/vuiJsT8pUupVClMvu2/AOzoS1VTDrM0FCJ16f9QTsgjdQEf3bmtdr2oScWflegRpw+T17+vJNeS1WqSXJJHpzL/mSUAYU1smUsBLHn7vX1xNjkjP3H65z8Wc/4M2toYtNX8K+yDE+WNS8jo6MEJ88Jf3CE2ho+72dkW5b84Kzi81oCW/l264PThAwQufhsl/u+VWo3Eo0YAaS6ClglLE5e0IQs2qyJI+USuPn/VSegu3Y9AHc0ZDaE4yYJRm9c0EFq2Ckper41JEVOPNxceYlZW1f27AQwFZDIes5k05TalsFj/zLDTDT35QtHiAfpVe/BRxlce+YGWpg9S08FS6Vk/lm8nL++Ha8829oOKPcF4swXym+avGy051K17GecKPr1J4WROGrSNpBClX3bb76w1SldYVVojGi4anfdKi+yB1YkC4lxzq2qsSBNMnUVYTg/IgOSHEH528YuKZCAOhYZmk/B0cV80vXPxC84pqp8xc6iwiNjeGx1Q0JM4JID7ZiRBXkwUzN3aDRbOYccTWJLUL2LOE/Y/dkXg6AB2lz/wV42OEtKaSUHmnQ/kCfw5DnUm5rwWmKYSvg3nQtS2XZKn4fQVwdgRg4RmRgZCc8t9Y3or
 /jrylk9P
 9X9X8GHbuJjUM0LZmdE/m6YaJP9KMMM5SJk6I89nOMwa3Luy20G45M09phh9Fqo2e14Gf5gC5ktYqNlLuXmGFmvDeS8Wdt/QRToeMV1yBOpTqdI3WvpLO/d9/cRvtf9jSQwkYohac63E61ySOwXkoVhtdVdzDuTgkpKXc75fukEm9SUfA7c8IFIJjknkCOQxtQSsfOZZU3arzDjdjVkXK7xUn7vYv0R40WpEFVTHrZb1yfFS/n76C+DM5ikhSChT8upbHLKtgT9XacAy8jtVxUgGoldiBLoSFHm05t+rNclBugS89FCoY+rArk4jqMluElEbxDJNxCPDkyfA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 02:36:01PM -0800, Shakeel Butt wrote:
> On Wed, Feb 11, 2026 at 03:22:13PM +0000, Dmitry Ilvokhin wrote:
> > Add thin wrappers around zone lock acquire/release operations. This
> > prepares the code for future tracepoint instrumentation without
> > modifying individual call sites.
> > 
> > Centralizing zone lock operations behind wrappers allows future
> > instrumentation or debugging hooks to be added without touching
> > all users.
> > 
> > No functional change intended. The wrappers are introduced in
> > preparation for subsequent patches and are not yet used.
> > 
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > ---
> >  MAINTAINERS               |  1 +
> >  include/linux/zone_lock.h | 38 ++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 39 insertions(+)
> >  create mode 100644 include/linux/zone_lock.h
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index b4088f7290be..680c9ae02d7e 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16498,6 +16498,7 @@ F:	include/linux/pgtable.h
> >  F:	include/linux/ptdump.h
> >  F:	include/linux/vmpressure.h
> >  F:	include/linux/vmstat.h
> > +F:	include/linux/zone_lock.h
> >  F:	kernel/fork.c
> >  F:	mm/Kconfig
> >  F:	mm/debug.c
> > diff --git a/include/linux/zone_lock.h b/include/linux/zone_lock.h
> > new file mode 100644
> > index 000000000000..c531e26280e6
> > --- /dev/null
> > +++ b/include/linux/zone_lock.h
> > @@ -0,0 +1,38 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _LINUX_ZONE_LOCK_H
> > +#define _LINUX_ZONE_LOCK_H
> > +
> > +#include <linux/mmzone.h>
> > +#include <linux/spinlock.h>
> > +
> > +static inline void zone_lock_init(struct zone *zone)
> > +{
> > +	spin_lock_init(&zone->lock);
> > +}
> > +
> > +#define zone_lock_irqsave(zone, flags)				\
> > +do {								\
> > +	spin_lock_irqsave(&(zone)->lock, flags);		\
> > +} while (0)
> > +
> > +#define zone_trylock_irqsave(zone, flags)			\
> > +({								\
> > +	spin_trylock_irqsave(&(zone)->lock, flags);		\
> > +})
> 
> Any reason you used macros for above two and inlined functions for remaining?
>

The reason for using macros in those two cases is that they need to
modify the flags variable passed by the caller, just like
spin_lock_irqsave() and spin_trylock_irqsave() do. I followed the same
convention here.

If we used normal inline functions instead, we would need to pass a
pointer to flags, which would change the call sites and diverge from the
existing *_irqsave() locking pattern.

There is also a difference between zone_lock_irqsave() and
zone_trylock_irqsave() implementations: the former is implemented as a
do { } while (0) macro since it does not return a value, while the
latter uses a GCC extension in order to return the trylock result. This
matches spin_lock_* convention as well.

> > +
> > +static inline void zone_unlock_irqrestore(struct zone *zone, unsigned long flags)
> > +{
> > +	spin_unlock_irqrestore(&zone->lock, flags);
> > +}
> > +
> > +static inline void zone_lock_irq(struct zone *zone)
> > +{
> > +	spin_lock_irq(&zone->lock);
> > +}
> > +
> > +static inline void zone_unlock_irq(struct zone *zone)
> > +{
> > +	spin_unlock_irq(&zone->lock);
> > +}
> > +
> > +#endif /* _LINUX_ZONE_LOCK_H */
> > -- 
> > 2.47.3
> > 

