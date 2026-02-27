Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1322FFEFB4B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 13:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF4E96B0005; Fri, 27 Feb 2026 08:06:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA28D6B0088; Fri, 27 Feb 2026 08:06:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B845F6B0089; Fri, 27 Feb 2026 08:06:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A281A6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:06:05 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4235959A60
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:06:05 +0000 (UTC)
X-FDA: 84490259490.04.2609ADD
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8E9261C000A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:06:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=fabxRk5j;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772197563; a=rsa-sha256;
	cv=none;
	b=kUhiYQwd8aW1C5aCiOZNARhh/yNeuE8Al1JyObK3J4osFw5V4EwiRMZQ3Smw4TLz3rYXPY
	R1bp3xd1ktSpFYUEBH/mYeqJTF2oZRC5uDTmP3wIAl/3aw5Mm2Q8YxRQi1OQrkIR8b0eYj
	+8NRGL8CB8Soargq87eEpc211BxyRzk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=fabxRk5j;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772197563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFPcmXa3TYJ9a+ZatJmYfl714K9Z9gwrrVFBHqhQv2c=;
	b=DvA3pv1VyeznAPxiaatYCU4X2sp4PuXd+mrvw10KYap6QKjkDThSSVXhJqtQDSTWqm/KVn
	Ap5bTFVuQeCLOtEmDXqI/SrggrEj5mwdk16DAjN23dQHdMwWLo2H+vFF7RII7QpuXX0lsL
	IpQsrqjfrN7eykabBlFamQpI3lXPrWc=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id AF3A4B2DEB;
	Fri, 27 Feb 2026 13:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772197562;
	bh=kFPcmXa3TYJ9a+ZatJmYfl714K9Z9gwrrVFBHqhQv2c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fabxRk5jF/Q/JG1+ocNkMgBf91sfzczJhGM3o0kjghaJ1n/QylUZQMESyBBa0UvFD
	 g7EsxF3jkoSo0lnu/3ngvWkFv+dYHw50xqtbS/XcePqmmJLLUcAsZKnsFYZoQCHVPX
	 nJkRoSKIPktk0xJIO84YpLx3wMaDeMt9gO6+W6SY=
Date: Fri, 27 Feb 2026 13:06:00 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, kernel-team@meta.com,
	Benjamin Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v3 1/5] mm: introduce zone lock wrappers
Message-ID: <aaGWuPxfAMeHSKL1@shell.ilvokhin.com>
References: <5bcc39cd3a227944d0fbe75ff86cdac92b38d4ca.1772129168.git.d@ilvokhin.com>
 <20260227003140.82789-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227003140.82789-1-sj@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8E9261C000A
X-Stat-Signature: 7dkd35fg5dt8f5h3rkzaoh913qjxboyw
X-Rspam-User: 
X-HE-Tag: 1772197563-993131
X-HE-Meta: U2FsdGVkX1/Pa5hbRSpINa6VhPsRXN3H7jKTp/gsiQGF/8JuM8cZkRsZkPpDH0jy7tCcbWTbbyrOmEJZDU9uWsb2SM/UslAh2iOU/OiSYEGu7szWYPJfTG1lOeWJL3wdwMbmR32HTwWRlUYdXrhvB8YWniofunOEEEt4k8nkacKE6VyDVDghGBPeTvClwM2oj5+oVk25W4MU/iCBukKMopWD8vTRWxFPHNH+/ax0mG/rU6rNK0Obob+9Sitv3WhFLpbzLzWMy5uMQ4iJ6ldVx+PNygtSH2kR7gW/MO3Vz70KQFPoIpgh3tPqvkV92f+kodRzHRJxrj4dt0bh7p1rfx1ywF1ZAvhJCFFS5TnNgIqGbJKevNpI15zl8xvcJyr9SXztKd+C+QhvJANdJ74eEu/LJRt2Mi23AoQ4ERWs9UkThG83JFs02zE6Og9meZe41NNSOefZbMExjJmT9hoL4eAWLOgNXih4ah/lBtpMyrdZY1c8EvFO+RvoHwmYrkA18HhUN7vgV2oQPypnGVHPwDoYH5PFpDl+izZlAtrGq8lGqZr9PTxHgVt5y0qzxS117+OkeQzSKu27aTxjC28fUY414B6WC8FQmfbseK/IZSlAEVDEYfQ2tZFD3JcXWgFuW32xlNTEUnGNb9fCqlEiGC0yz5Hcjwm+X3hI0XNQF9K4wOHpD1jC0sHc6t6fxNEFMHHaenH2rzT6s1qq+97zPsdXchE+PdILkqr4144FkGx45LddiwiNtFiqiA/DL1Ige5Qw7QNPnWiufKdDqOWMMkltplN3IYS5GmhkySeL4IcwtYxb3Ga7KkcqhtFX8amc+Yo9MFHRROE/bMeuJyuspR7NqIYXUY7pQE2SmxLfs81fHalg7Wff7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 04:31:39PM -0800, SeongJae Park wrote:
> On Thu, 26 Feb 2026 18:26:18 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
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
> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > ---
> >  MAINTAINERS               |  1 +
> >  include/linux/zone_lock.h | 38 ++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 39 insertions(+)
> >  create mode 100644 include/linux/zone_lock.h
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 55af015174a5..61e3d1f5bf43 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16680,6 +16680,7 @@ F:	include/linux/pgtable.h
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
> 
> I'm bit worried if I will think this as a file for another general locking, not
> the mm specific one.  I hence think renaming it to more clearly saying the
> fact, say, mmzone_lock.h, might be less confusing.  Or, putting things in
> mmzone.h might also be an option?  What do you think?

Thanks for the feedback, SJ.

Good point. I agree the current name looks too generic. Putting it into
mmzone.h would further overload that header, so renaming zone_lock.h to
mmzone_lock.h seems like the clearest option.

I'll make that change in v4.

> 
> 
> Thanks,
> SJ
> 
> [...]

