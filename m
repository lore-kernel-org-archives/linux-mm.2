Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEB9BFD8FC3
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 393A16B00C4; Thu, 26 Feb 2026 10:21:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316476B00C5; Thu, 26 Feb 2026 10:21:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F8316B00C6; Thu, 26 Feb 2026 10:21:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6DF6B00C4
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:21:00 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AFBB01B6E52
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:20:59 +0000 (UTC)
X-FDA: 84486970638.28.6445065
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf03.hostedemail.com (Postfix) with ESMTP id C39DA2000C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:20:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=mIZhFrh0;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf03.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772119258; a=rsa-sha256;
	cv=none;
	b=AWmWoECeVOjeJcr0IxwLvPprOvIzH8aLzOlMKNXQS6gD1HgTWEH/rx6fsDSFED+mGY7k7u
	dc1oa0vCN69PWcAalOZGnXYZMXbNqvADmqmM4fKCwFLs75aD0hPv/7RBDy1Hc1/N4F3ZJy
	u/ihTNifIfl3jV8Rj66cEcqxk7ODDng=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=mIZhFrh0;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf03.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772119258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96bMLt1vc+CQTxpugO4N1U1WWnL6JTb1Hqk9UYVV66k=;
	b=PChD0Dzwm2vDdPRjnbYb6pD5Uu6+8utyU/Ic+Sx4io2vvdlc7O1bz+wYPjjLTyKsl4ePKD
	cFbvQ3CiwtqoMyzpzeGSjMUYJggneJd57tNsxfUWzrGn6R+Iwmv17WCS3j051giuY28m36
	7guXFcsogn6InEfcyJqlBDVCBDJuqq8=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 81AF4B2CAA;
	Thu, 26 Feb 2026 15:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772119255;
	bh=96bMLt1vc+CQTxpugO4N1U1WWnL6JTb1Hqk9UYVV66k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mIZhFrh05aUyF/HK0rWw/gi4f2rji4Hsjriiuv1EXhc0M6f6cwDcwZkyagYwoJA7h
	 iPb5AKgAqqNAEgHesIpSbxIxeGq5L5jsLf0mZWLkfgIUbHqSn/qgQ5kD93RR+/K/N/
	 xJdcq6T/DKzG9QNzrXIshckbpzNDGVCgi+Hw4G1Y=
Date: Thu, 26 Feb 2026 15:20:54 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
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
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	kernel-team@meta.com, Benjamin Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v2 1/4] mm: introduce zone lock wrappers
Message-ID: <aaBk1sVcy87EPQ2D@shell.ilvokhin.com>
References: <cover.1772030186.git.d@ilvokhin.com>
 <5bcc39cd3a227944d0fbe75ff86cdac92b38d4ca.1772030186.git.d@ilvokhin.com>
 <20260225121421.2eb75a94578af35780978851@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225121421.2eb75a94578af35780978851@linux-foundation.org>
X-Stat-Signature: pczmx88ad59fiu4xu473jxjuwm4r6e34
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C39DA2000C
X-HE-Tag: 1772119257-691516
X-HE-Meta: U2FsdGVkX1+fA2OhF4AMtfPg+vO4BCGyXnwu2gyajHlPQTvvFI8z9oiNCYixprt4OiHQ1g4h3glK+2StvH1KZhfctVToBdmnPFZtZnE1fHLNVGrGTa4M47CtpHgHTD48Z+bP06jFncPQ6horLrOUFSMFKUCsrCTVU2/oliZVUHyfGfddqwEBB/nlFwxN4CIIaepYJygaQFReweYAcYr2b7EW5XNIGRqvqrEwy240Yh+J2OIH97vqAjvECef/JhwGHmdowO1ix9luG7CzmC9cgNXzHxwb9/PYSd1r4PSSfNAEZYnK65ItT8W5ZaSU6TAXM4W4p/++HgJDyfmD4PwX3b4YzWTi73yb4vcQbnXMxZPk2CJfwxON2tmMwdC3Rf5Htx+l0IVMTub9IZMDlmXp/lI65v4xZOIzOM6d7EWY+Il3qeJ6YKXOJ8sAp/2NuZf9Cn2D4EO5zJ7onwQKVpVD0wJvWeNsSF6xERRoZ2bfgkUthiOCQZjOibdV2eKtIJLxf/qYxdNrY+uwOA1yy12W1IfJIiLucoxZ8XV5HNle4e8sA/Q6/K6CmVFb1SCTvyRZL7OBpB+Y56YZp+sz6v7vucE26Q90BumCx3AArli+UtphEbS8v6yxNCkaV5aP42AN5xxcIl9vZ/EH3kugfX8LEhxa9pWxY+vYlqtlfS5WZJDlEFjV/H2+d0HqWJJ6gf/d+yVVtlV9fpryIOzxBqBnBalXS6jbmFOxx9aCx/7ECxILMJIAy1oNH6ITySJxN1VLC7gHaA0k4e+uelZiHPVGsP2quzz3f/+H0/wGVuCq21SSWzcJPVmb1D38RNHo8rPvtSBc3+CUWSLMamxzACWAYpULBTXcyWbVeXJmnyo9WA+ECWV6IuOUewsCD6D9JKvDpk6Kw7A2eej3AWJEhWP0Kh5rIYETNgAd+0155Mx2xfkCA/9/nC8Un1VLyHaC4kkgiXHxTe+lUkU3D3KQ4DY
 kRB0v+Dv
 ZqIY4w1yHgfK8w5Z+w1rsSlVwL4bxbgBuV6AxeIbLZ3YPT6xmQPCHCt3U0qaefKnR+GRlQ4vxyOp9NtKoPD8/esITetjubVgUCwdmzalxWIY5mfgatHZm++OnvV1T2hYd6vUs1heVqQ6Bhm+XcSibphraLq7RAa1RZfrXvN6m3v6Qi4BIbEZpYC1EiFXXez/VeI8l8VZ+io1q0qjcLhStP/I06HRn4OSdKpWPcX8XBkva2zTXm5jcD118twQapFlpUO2gBSXhf6CrltxmM/rM7xktBGPGipQ/bcMd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 12:14:21PM -0800, Andrew Morton wrote:
> On Wed, 25 Feb 2026 14:43:03 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
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
> > ...
> >
> > +static inline void zone_lock_init(struct zone *zone)
> > +{
> > +	spin_lock_init(&zone->lock);
> > +}
> 
> Please consider renaming zone.lock to something else (_lock would be
> conventional) so that any present and future and out-of-tree
> unconverted code won't compile.
>

Thanks for suggestion, Andrew! Makes total sense to me, I'll rename lock
to _lock in v3.

