Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70DBDF3C99B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 15:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D18F76B0089; Tue, 24 Feb 2026 10:31:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAFCC6B008A; Tue, 24 Feb 2026 10:31:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBF376B008C; Tue, 24 Feb 2026 10:31:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A851B6B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:31:12 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E8FE1B5D7B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:31:12 +0000 (UTC)
X-FDA: 84479738784.15.5DE2BCD
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6681840012
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:31:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vPSKdZY5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771947070; a=rsa-sha256;
	cv=none;
	b=Zrd20dX6uYP/MFs5wBlTEYKc93aFbCtals10frChaVYDF0RQr/AcO64QiQRR7+g7WfCFCy
	snLip13Q/pO+C34rRVSv5nozkH8qYnMMXMqpeSmVh6+lLEZV+90T7NIuBnp5fnKECqoH8m
	WC54bF9x7UPCZx+YlHR62xmrXYhs6Yc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vPSKdZY5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771947070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R+yfrV5RKBFEGAKtXVj/llMLh9I8k1XehmuxgjcMXfs=;
	b=68TsTBH92Mgvh+gSO+wiw1IHGqONFRxWJOAsHVX7NSJder9Cj++QLIqOEbICrz7fZ0nD9x
	2jdgFB5qgGlBplR0jL0/UZoX5LjvYI/3JLzLUCgIPp0DNABTfuIotZz7/+PLrPxUT9Iqrg
	ZokUjkrBUf5Q12rouzfBn4MU9QRbDEU=
Date: Tue, 24 Feb 2026 07:30:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771947067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R+yfrV5RKBFEGAKtXVj/llMLh9I8k1XehmuxgjcMXfs=;
	b=vPSKdZY52nwmTjOayDoBACsDYtj6IQTSESDQ7/IEDYJb+Gj9DMzrniJmfcGumIi8gLxOCc
	1rvH45wBIVsApNtqMUVjbxdXlEFwcdF1L1OQTL1xif5r9BZkAaHhh6zW3Reink/8O87eZ6
	IpTrziHmHin7T8RyfqQXruhmifbn9R8=
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
Message-ID: <aZ3EE4JVDghZSq59@linux.dev>
References: <cover.1770821420.git.d@ilvokhin.com>
 <3826dd6dc55a9c5721ec3de85f019764a6cf3222.1770821420.git.d@ilvokhin.com>
 <aZzWNM06gNYKDoQW@linux.dev>
 <aZ3BLKzhIIZvkbwL@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ3BLKzhIIZvkbwL@shell.ilvokhin.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6681840012
X-Stat-Signature: wwudfhbiuadz5ghu4tk96ef3t9ir5mz7
X-HE-Tag: 1771947069-327785
X-HE-Meta: U2FsdGVkX1/CBm7Q750gbNP8JElmxAo3EwbClwYCG9STS4BxfK8uOZANkWU28J6igRtPJimO1NtbnR6ijh6/a0Qnsk3t4I1REYu7Ds1WxtaGCD2CAiOZcVmqVvEyflyqwPHk52ji2p3p/p1eUxtSyl79MdcLWKORPkDHX5A9KOLRVA0NUWDpedoyMrNSX+1na9x68e3tfYBNk11WteoD2vo6/V0yTIYn/Soa0D+sbGP267Pyk7jqs9Tc5gpzQbjkrAV3IYo0yBSha3sOvRgFm+rBnMhW0wF/V03D1JPWUQepGXrfp8ePI8c/IcbWQr48SVrzZZX6HX4Z+/K08UEnj+1eUF7GFeSWuIXQ8V8hAJZv9t9D53BVMOzPkffHxLgwCgwTbdPj7Vy7Uaj00aL29PwoJLhz8paEoR0kM6mde7eleOpVhE7ilqyAReut4eS1Z2Wiy9n6M9PQ/M2NloNhUuXPay9xxQhl6FKhSZ3HrIzpzkbfnwDF5FvXlLF1h/J2JZm7XvreJ7grJV4imqCtvJSnLbpnQgLvFjW1AD3vEicP81tiLK+HZMwKuLsuwViQVqiRVzuxFsMm/JWvN1ZGDh2zNq4hdjtcwZRpOcAesk5KJ7FydN/skJBIMrQKEg3VfFgFprIs9A5ud5G7nbQID6TPuMBFK9e3vknxOalzhexLDBeQdD/BuO1jiQKqzj+zUTFTMXI31isNiqQfuVMSTEVg1FVrtBgvKDtLyK1lLQA2iMpUx1+UXOWYyRaG8lq4xUJS63uT57osLl/gksz1gc3CnzhNpUuyTbMBSVWEkDIT34R65gO5DtgahxhsyC0ysErtGT3pFtZAgKsKMURC/DwOfvXNNq0Uj3sLkOR1UBwufXn7wX37WWCou8Wx2qfYw+KpG34FtpsfrADmxBXOQfILrd9RWti7GJ+TjXrJW1Y4LbWoJN/A9E7QUdl9kSATRR5ej0ErIT0k9+aMpaX
 wJP2q9Zv
 nTBpUA+Y6sMZdZeTfKArXSwUbNU/enPIRXLN9hrxwhg1/zdDlK4y43LetenBDJ/iiWH/3bYhGQ8Qli7foq9H88JKrIEiSowIPr3dBvGH6QHb1Xfz+FkqrVJJRxiWZpsGjM8HkGAFoAb3JCBOeog/IyuS9Ejvy1LWvQLP+9skTIJun1o5PKJSguO4HvFeGKh60zGLaRWwk/JfBS53CjDDTF4L3258rWGuZ/qght3bR1joLQ2C6pvNhqJuxzZsMHfkTzRL8OKJmkdYuBq0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 03:18:04PM +0000, Dmitry Ilvokhin wrote:
> On Mon, Feb 23, 2026 at 02:36:01PM -0800, Shakeel Butt wrote:
> > On Wed, Feb 11, 2026 at 03:22:13PM +0000, Dmitry Ilvokhin wrote:
> > > Add thin wrappers around zone lock acquire/release operations. This
> > > prepares the code for future tracepoint instrumentation without
> > > modifying individual call sites.
> > > 
> > > Centralizing zone lock operations behind wrappers allows future
> > > instrumentation or debugging hooks to be added without touching
> > > all users.
> > > 
> > > No functional change intended. The wrappers are introduced in
> > > preparation for subsequent patches and are not yet used.
> > > 
> > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > > ---
> > >  MAINTAINERS               |  1 +
> > >  include/linux/zone_lock.h | 38 ++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 39 insertions(+)
> > >  create mode 100644 include/linux/zone_lock.h
> > > 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index b4088f7290be..680c9ae02d7e 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -16498,6 +16498,7 @@ F:	include/linux/pgtable.h
> > >  F:	include/linux/ptdump.h
> > >  F:	include/linux/vmpressure.h
> > >  F:	include/linux/vmstat.h
> > > +F:	include/linux/zone_lock.h
> > >  F:	kernel/fork.c
> > >  F:	mm/Kconfig
> > >  F:	mm/debug.c
> > > diff --git a/include/linux/zone_lock.h b/include/linux/zone_lock.h
> > > new file mode 100644
> > > index 000000000000..c531e26280e6
> > > --- /dev/null
> > > +++ b/include/linux/zone_lock.h
> > > @@ -0,0 +1,38 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +#ifndef _LINUX_ZONE_LOCK_H
> > > +#define _LINUX_ZONE_LOCK_H
> > > +
> > > +#include <linux/mmzone.h>
> > > +#include <linux/spinlock.h>
> > > +
> > > +static inline void zone_lock_init(struct zone *zone)
> > > +{
> > > +	spin_lock_init(&zone->lock);
> > > +}
> > > +
> > > +#define zone_lock_irqsave(zone, flags)				\
> > > +do {								\
> > > +	spin_lock_irqsave(&(zone)->lock, flags);		\
> > > +} while (0)
> > > +
> > > +#define zone_trylock_irqsave(zone, flags)			\
> > > +({								\
> > > +	spin_trylock_irqsave(&(zone)->lock, flags);		\
> > > +})
> > 
> > Any reason you used macros for above two and inlined functions for remaining?
> >
> 
> The reason for using macros in those two cases is that they need to
> modify the flags variable passed by the caller, just like
> spin_lock_irqsave() and spin_trylock_irqsave() do. I followed the same
> convention here.
> 
> If we used normal inline functions instead, we would need to pass a
> pointer to flags, which would change the call sites and diverge from the
> existing *_irqsave() locking pattern.
> 
> There is also a difference between zone_lock_irqsave() and
> zone_trylock_irqsave() implementations: the former is implemented as a
> do { } while (0) macro since it does not return a value, while the
> latter uses a GCC extension in order to return the trylock result. This
> matches spin_lock_* convention as well.
> 

Cool, thanks for the explanation.

