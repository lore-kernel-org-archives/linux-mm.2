Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 719D4FD8FE4
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 17:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF0666B0151; Thu, 26 Feb 2026 12:55:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBB4F6B0152; Thu, 26 Feb 2026 12:55:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE7BD6B0153; Thu, 26 Feb 2026 12:55:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A805C6B0151
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:55:16 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EECF958525
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:55:15 +0000 (UTC)
X-FDA: 84487359390.10.B19A38E
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1910A140011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:55:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=2RHNxVtv;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772128514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n26Wbnp3l3vR8dz90LZIold6P91TJCToqADcCftfVoY=;
	b=bhRLFSl/dUIJcKPJietH2Y6eGCCtTCf3d1LsZy7RYR2sMzv36tSWKP88YY0ghZBGr6iVi0
	Mb9Do5DP2TCGVtPIC1csH9N4ULZM7L+QBUrT9bPzZp6fFPKC7UOhgsbJtPyPbSINzg0kbp
	nARbTwGgC+rWmSpMJC7+jh2dksX7KTE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772128514; a=rsa-sha256;
	cv=none;
	b=ODL1gVmgVmqYX2rcS24FeiI5ybqjLOlLpT+rSOSiYPuu9AA8S1V6OUIVszeoacVmAziN3K
	jQ4mvcHO67/OIhwKV/45674WsmG605D4itDsqzcIv9AFgls+1yZBwfZqftrOEWidvrd3mX
	OaKvq2ttIMglKC4Dl8wmabyzVUG1/mY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=2RHNxVtv;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 7CE69B2CB9;
	Thu, 26 Feb 2026 17:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772128512;
	bh=n26Wbnp3l3vR8dz90LZIold6P91TJCToqADcCftfVoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=2RHNxVtva8HwJ7FaIWnZp6Yt1NGrDNHqnBR2rEXpPGHZoiZxHqeEXt4ZiiBE9um38
	 jZDDgBcsH0TK5JJY+MFhm54eAyQlY/ZNIR3lfuGaOX8fmuwGlXQZ/ok3VZQ7yqwFDi
	 3DqfRtRcGwfHjCw0V7gvMRm8Hl0iXme8KVRXyF4Y=
Date: Thu, 26 Feb 2026 17:55:11 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 1/4] mm: introduce zone lock wrappers
Message-ID: <aaCI_-bNm-YGGXI1@shell.ilvokhin.com>
References: <cover.1770821420.git.d@ilvokhin.com>
 <3826dd6dc55a9c5721ec3de85f019764a6cf3222.1770821420.git.d@ilvokhin.com>
 <20260225175105.7777c514@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225175105.7777c514@fedora>
X-Stat-Signature: z37gtukq8axph1aqf5xbtb3efzebqh9k
X-Rspamd-Queue-Id: 1910A140011
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1772128513-979651
X-HE-Meta: U2FsdGVkX1+xVj4WeG4nXIBoxTXBWAZgQ5ATLgDV/yuCFGtIxBRT9bNNb+vGUf4QSTxeCocsTW2ziAbNvXYs4y1kaxxac0YMWUx5NOi0tgZqfl6TexbNQOBEAx0ehxl/CJ/66YCnHffyvL+7kGqgnMQV0lrHlX58QmjH5vgyWz/9BRQs3TiNKBGf5MlUGAaLWWsYTWV0wYEl0apuOjhjIDwzXRuQr/heJyOe7L/1AG8OoXBoK81sYS9rjUncR3+wz8UcmKw44lXpz8lH1afPwHOggr/ZnQWQhaTLJFn52P5B8Gg+VMWkh+juLyBENyz1hdAD4S53NcWlVwcJ8XD/w2UneQe0RUiUmpAtfgoAJfd/D6EKOqZxFxqqDLIpX/91TSQUiMfZ0IOWdxxNO40FkwVIBX6G7v+ZNeDp+BGy3CZgOdZK8q2d+Hl7O06tR+W+gPFtAjnVNkTJAqzq6WY2MkXUiFqkL6v7WpNTlfiAXxMSRYcZzn7wJSJbxHpAf1wt8ah/HG32Tzc4boNko1rOATiteWVkztt5dwszgPIo8hq18BeRKzbcaTpSBkKXcxfYDHDHw8Gf317iFEFdndDzKrZ3AYvdn7d3tcmEd475EL67dl0ONDoURXe5JjLKQSvw5+WDAjbS4pBuiQ+b8qHo6+c5fNSDA9cZ4KfM7lTfEGcJAv8s3JMcRZgSYZ/klnMktzT9nC84m3sLovdiXdrYlu6dXVijJclGDGp96oWZoazJazu2XI+d9NwIlkHlh3sPN/Puy1C7G30v4vASiM5nyeUekyMzMd0BgXh/RTf+mpSC5ykan0MEHDrAdSPHg62rulnwki91jO0uxG4qJQsETkY7lOD0llBi2mKcIBplmrCpRMPQ6Ls8pLxP1ocbBR/5Gt1aiWb4l76OKhsHRoNqJVv9ya5vNn9CUWS9TxVHio3ifcIfUgixabF5sr7d5hvI9O6VzTIzDw4jThUW/yB
 5oAx0/Fj
 e8ZCh1bfzgDg0cigK00LOS54kpcvS88PKy16ZlAlcCJX7Cxuupyl4olC2Tof6A8LhqnpSKf+9mwOx97/cZGXHsvCm4d+HjBPole7EAqYBezCPozjs5XYdDunRh3Hunem8EzI6lRCQUX2DIDZ2RLfk2JV4soMufjSaS4VNm7dHfQ1EJJj0RNETqKvFXMUHQxwSIYBz6Z0gv/A1GnyiC6ds7zVZIRFVqEzztK7som3tYuI7ww/H78exyslakNEY6N4mhOwXZ2Yrq4urTUmwqGYUu/65U57rnEEoOIK6dsbwEBJ2F5mUPYGaJ7uQlYvh8NU0Qrtr6U6Xgq4+f6s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 05:51:05PM -0500, Steven Rostedt wrote:
> On Wed, 11 Feb 2026 15:22:13 +0000
> Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> 
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
> 
> Have you thought about adding guards as well. It could make the code simpler:
> 
>   (Not tested)
> 
> #include <linux/cleanup.h>
> [..]
> 
> DEFINE_LOCK_GUARD_1(zonelock_irqsave, struct zone *,
> 		    zone_lock_irqsave(_T->lock, _T->flags),
> 		    zone_unlock_irqrestore(_T->lock, _T->flags),
> 		    unsigned long flags)
> DECLARE_LOCK_GUARD_1_ATTRS(zonelock_irqsave, __acquires(_T), __releases(*(struct zone ***)_T))
> #define class_zonelock_irqsave_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(zonelock_irqsave, _T)
> 
> DEFINE_LOCK_GUARD_1(zonelock_irq, struct zone *,
> 		    zone_lock_irq(_T->lock),
> 		    zone_unlock_irq(_T->lock))
> DECLARE_LOCK_GUARD_1_ATTRS(zonelock_irq, __acquires(_T), __releases(*(struct zone ***)_T))
> #define class_zonelock_irq_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(zonelock_irq, _T)
> 
> Then you could even remove the "flags" variables from the C code, and some goto unlocks.
> 

Thanks, Steve.

I like the idea: guards could indeed simplify parts of the
locking and reduce some of the explicit flags handling.

For this series, though, I'd prefer to keep the changes mostly
mechanical and focused on introducing the wrappers and tracepoints.
Converting to guards would make the transformation less mechanical
and potentially harder to review.

I'd be happy to follow up with a separate patch to explore adding
guards for zone locks and see whether we can simplify the existing
logic further.

> -- Steve

