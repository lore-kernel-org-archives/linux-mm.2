Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78A94FD45F1
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 22:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D66AB6B0089; Wed, 25 Feb 2026 17:51:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D134A6B008A; Wed, 25 Feb 2026 17:51:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29D36B008C; Wed, 25 Feb 2026 17:51:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF7A56B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:51:16 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 61D731B7441
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:51:16 +0000 (UTC)
X-FDA: 84484476552.13.4311E5E
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf28.hostedemail.com (Postfix) with ESMTP id A1187C0002
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:51:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772059874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wVXAFAgcy2s5ZideHEYBkFHH6cRRiDyS2dawlDyeGYM=;
	b=s3zLlYr0d2DeY3kIF5eHKeX2pZYcLVrCvT40k+YLjqoeqyLA6MeUYkTQqj1PHMNfS/z4mx
	OgPmeksCuyyaYvfL2jhDY6JQGTxmCOYaHtNlLYmq7BLryHZtRpOC5HaZkaxFD5y/A2/eJf
	IwgpE6Q4Pfee9K+3ED/Liaar3dlsN48=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772059874; a=rsa-sha256;
	cv=none;
	b=eKfRiMfTqWC5VkAwa45XR+TYNCVOX9kstz0JJ+Xekxhxn4apci8FN9OnHDCcI5LsZz1iqa
	xPXrZkwJm2UcVDVvoVP+kdWItmyf6+Pu+k3wy1CTOh+ATRSUlJDY8q2c02T5MmLVd1fr6/
	DLI7dGgWHBzaqhfzZwElZtDmQFuvoO8=
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F7A91C74B;
	Wed, 25 Feb 2026 22:51:12 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf17.hostedemail.com (Postfix) with ESMTPA id 2D6B819;
	Wed, 25 Feb 2026 22:51:07 +0000 (UTC)
Date: Wed, 25 Feb 2026 17:51:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>, Qi Zheng
 <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH 1/4] mm: introduce zone lock wrappers
Message-ID: <20260225175105.7777c514@fedora>
In-Reply-To: <3826dd6dc55a9c5721ec3de85f019764a6cf3222.1770821420.git.d@ilvokhin.com>
References: <cover.1770821420.git.d@ilvokhin.com>
	<3826dd6dc55a9c5721ec3de85f019764a6cf3222.1770821420.git.d@ilvokhin.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19bcS51kdQMJLg4y+CWNN6mKgepRI8oF40=
X-HE-Meta: U2FsdGVkX1/tj9mqP/zexxSNbzfzJyNDn3Ikcoz9DM7IrcRLT4iJW9kifyj/zq12MlJmNIjaxAlYOyS3OVEskQGvSr6j2wOSQr4HauKmUod9p5RnvvAxrahOxlqk+oH4Ol5w6uws6FKwFTPR68+qweqED6rOryjCvuMJO2ZTATs92nH8W4R/Pp2qLAK2T2gz7rU1DQuMj9KTkr5PEKIAE3Dg4TqYHi5RHkwdlmYRJYSL6C+FSbZdN2YxvnZ+XXzK3T6KoJOVX0Se6kXSSy2fSWGEvLebKL+M3f1uz3BFWqVnjdOvNhVnNOm1AZfDO5LDRN1jNrbXoMR6wjybtI29GKMzZUrJXXUk3P3X6XVS5YFSysdNbNP41hAv7wez19mJ
X-Stat-Signature: 8gfyis76sfgdc1u14u6tppapitasde71
X-Rspam-User: 
X-Rspamd-Queue-Id: A1187C0002
X-HE-Tag-Orig: 1772059867-798157
X-Rspamd-Server: rspam01
X-HE-Tag: 1772059874-276636
X-HE-Meta: U2FsdGVkX1+CCNss2Kvr0C/LkxMicaEnyb96E5Qd1vN2vTEYK12L0Dnn8IiZqCFzOlXIahBcRPALnCTk0F/mf1/NEWW+BYNG5IgM056YNp2a+OUra0uy8C4YopXR89CCS+w1glOaKmqlyCJVjen8wB8u09mUNHXws178qxp4NwQeNDYTD3Puh/TTDRA/vu1gWbWio5Bh1hJAWcvna4oI9PHYYEvhoAVur/Iac5gl4Y84vDJMUcMQ5eYurQXElelM+CQhbm/0iA29CTURfLjmoGugO9XsL1hON/Oj9cIrRLsot5OBr3t+8CZKO1/NJTmRF2xwIs/mYo/P3al8zI7REmSJmF/WPvYzo4eKSEmZ+FB0NoyZ0umKPjFmfmM4PTaMVYAviA6RaTjfRKBgRTp+q22EXynUZ+YX5QdpthCt5GjEbcAnvqccUDZ3uRGX9NJ9mcZyOToZ+gFSV3U0ES9llFVJnKwGvI7ZmXilz6g5zkt/8PIe8WZOm7buaHSCs3y3Zhcfk35ofvwNzG0iGv5vG6XpvjAReSoP5XnSenrzKVZSeBMMMnG088janZUsHHjsU52FvmUg4XdpVA0OjccWgizBl3mHyx7TIvEp6WpkK6PjAtRvqgNgkt3ghDWLaXwYo3qgZGsSnR5jPLF3AkWjBHoY1ZSvAg4peQlN3kwAK1Ag1lL9/Xj+sD2cU6PTj4KEhxhmEXK7ph064+UaAB6Q9xc1Fh/2ec+rlE1/RSm5CzXPVGb6VpsCUxuCHtF4Yen91Nku8BUoeci86gwJ8U6Mn3aXs/bf+8t0Iiq+++9+/+Gm5BbexBXOZ+ZMjo+x7m+tP9WdZYEfxFn/gqkWJMEfriI+Vjfb2plJUmNw0c8POZvebygq9DrunKargM1L/3XXXykwPaDFHDFhWVKudiKVh1m6PC9h1ADtC/kY2JwM3rbyS3xweVrc7+UQlGxXaduEWInhYqqYk0qizxnswBQ
 xPKKQ6BI
 CO1Xwzf+/WS4/pBHVXMuvOBQcNDut1N1KVDFE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Feb 2026 15:22:13 +0000
Dmitry Ilvokhin <d@ilvokhin.com> wrote:


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

Have you thought about adding guards as well. It could make the code simpler:

  (Not tested)

#include <linux/cleanup.h>
[..]

DEFINE_LOCK_GUARD_1(zonelock_irqsave, struct zone *,
		    zone_lock_irqsave(_T->lock, _T->flags),
		    zone_unlock_irqrestore(_T->lock, _T->flags),
		    unsigned long flags)
DECLARE_LOCK_GUARD_1_ATTRS(zonelock_irqsave, __acquires(_T), __releases(*(struct zone ***)_T))
#define class_zonelock_irqsave_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(zonelock_irqsave, _T)

DEFINE_LOCK_GUARD_1(zonelock_irq, struct zone *,
		    zone_lock_irq(_T->lock),
		    zone_unlock_irq(_T->lock))
DECLARE_LOCK_GUARD_1_ATTRS(zonelock_irq, __acquires(_T), __releases(*(struct zone ***)_T))
#define class_zonelock_irq_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(zonelock_irq, _T)

Then you could even remove the "flags" variables from the C code, and some goto unlocks.

-- Steve

