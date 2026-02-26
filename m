Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C9C3FD8FE7
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 17:45:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2076B0195; Thu, 26 Feb 2026 12:45:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09A556B0196; Thu, 26 Feb 2026 12:45:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F08FA6B0197; Thu, 26 Feb 2026 12:45:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC1A16B0195
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:45:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FD8D13A7D1
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:45:23 +0000 (UTC)
X-FDA: 84487334526.04.A0DEAB0
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf19.hostedemail.com (Postfix) with ESMTP id AB2761A000C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:45:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=XykilkVd;
	spf=pass (imf19.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772127921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7itAp3Hnu5FQvNWR3bqYNG7oBmnjq8V66kLCXadRGQQ=;
	b=JGYVbSMtGqsZ6zzwDPxH+LdFEy6thCga1Geiu10b291U+RQZ0RtOqX0Cd2aH/nW7R914ZG
	IV9JR8CdHMR9JqVRamPBbqM9DwKFskxToEQfG5hT62zXzbpMnkEi7vPiNH8fFfPXUivfnr
	gVDwwOjBP5v6wtbJ5Eu1LMIJylF/XUs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=XykilkVd;
	spf=pass (imf19.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772127921; a=rsa-sha256;
	cv=none;
	b=w5t4AygqqRZ1b+F+pP4Dm0m2GHw0KbGsdDL29gC3e2TL1sYn8HbLCbzZq5KnDL09ZF1mH5
	4WkhoF7aFNhnEt7razDo1Bdp/wLJtdk2ilfCAmf3DJobwIMfs3TcBOj/cxSg7OXzDRceou
	RidimZN/4AJrYRbTfzfUDx3FmDyUlHI=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id AFFD7B2CB4;
	Thu, 26 Feb 2026 17:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772127919;
	bh=7itAp3Hnu5FQvNWR3bqYNG7oBmnjq8V66kLCXadRGQQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XykilkVdm3dqUbRzNdGsTWGQJOPcDREWG1rINi0v4L67XgdIVYMR6fvXN9aBxFzCE
	 SSr/CZRSiny0EqWgtjql7ZYVsC1D/OQmJPOxW+xXNQiknqoceSR+sLFcR7lzlDZEgR
	 49w05mVSKhnWffrr01pxuNy3mfbayzuczT636xHM=
Date: Thu, 26 Feb 2026 17:45:18 +0000
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
Subject: Re: [PATCH v2 3/4] mm: convert compaction to zone lock wrappers
Message-ID: <aaCGrl96pD-0_ts4@shell.ilvokhin.com>
References: <cover.1772030186.git.d@ilvokhin.com>
 <9710c3448c6c984164c93d7c6c0283e06ff987bf.1772030186.git.d@ilvokhin.com>
 <20260225121252.7c6519a857c1a8c56ba5206f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225121252.7c6519a857c1a8c56ba5206f@linux-foundation.org>
X-Rspamd-Queue-Id: AB2761A000C
X-Stat-Signature: dm7hc35p7343brpjs1pyqgtdcyi1w3h8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1772127921-536409
X-HE-Meta: U2FsdGVkX19SuH4vom9qVT5F/vXE4lAUzGE/JFdau/MWpv+j+cn5tSoQOd3IYGr3Jnw/rX59YGduz2JuihgUnDduVKRAL8M95IdE2T5Qgksi5d9V8hCw8zfMFoYUg3GTIPSXesVVu8yJFbVkPPtHlzM8YJ00TkkV8tWniNypP5V0as2sSONquQQlrtA6bzo2bdJxWAdp23IyXkMO9WW/RtptYW0DgNxA7wC85LFJkKUsf/xk7Imrs1HjfgqqCZajreehfgOuI3UsNO6QxaD+UxjiWJCPjcx28LvQFZju97MUXZZDceAT6dPMeT6hGUW7PD4cLF1ZfP5mG+5tQdAI181OAdAnV1C943V9F8XvLsWeuijkY1U4Cp1OER3pA+IHT2bKhzpFFXVX+pdHtf4YxSsyEscNfjF17BvwYFT888IzPDX22QnAU9kjt5uWgOBZdXWjxLb2DE2iWyM8xcgMucTxWeWhg7tBPBx6IEbrTtfKaja5d/G90m4mPjBV5cZ6dFwWYl0XsbAMpARD0GmbeOT8vQMFXU8mp+TlGa2E79jcnTXqXJS8XBVtgr5wmcN5k10GERT3qqiNjWKnMOS8Zkkh8vU+0HgeeL7Nnd1ai+xqsoh1RRBKQFIl32eija2CDHTaozYr/3sPuVQpq1dE5oheWyrK3azXTr8ILDWNPdHKfQhe+zJ9UMxhMdGi6qg7edocvNrIE2iJADRaONn9zFu1LfwuSDHrpEJ054XstYfXfBu4gLnW1udVILOiEamxD5noeUd7yjO0ikpnPhjX7wZWd/Ge2xSFtptTrP1111qWCyQSgv+r0KM1TPUkJSPqFASQLjOmJ6Era4P2P2B+bCNDOn4YLbmC+azUPzkPs9sZSekKqIVlTu3qo+jXA+/v3QS2vN7HJTeDnwRpcMOSizCoUEt3BvBv/gAUWoEUpsgJvraOSOsCCOrje+HYnFQ74gHk00ieOBv2VRV/TUC
 HIhfwtgF
 nwa0lzRPrI790v9ceJdDdtpdOXqLYcDGwTG7Pslg+tXDEiQJYP/sAV9vKiQMXybL3UYLilbLjA4P2spKJs1xz+gdDJMpr/UxfDpWJ5FoZxRRFaK6yE0VYmqYzMW9QqWyHzkW/34G07YtCO6ie+N1O0iP91qJn7ir/zZyxooO6Ce9IYtpOlVxwl9V4aGryWfD2Oluh3ft4ljYugh+NLSR7QskTjgw7Sw6GsHaVDeMLAjmRO39vynsBjDiGcdqt/IacxyChxxGaCxDpVwM6WgQu2o2Tz34ezAyLMUaX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 12:12:52PM -0800, Andrew Morton wrote:
> On Wed, 25 Feb 2026 14:43:05 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > Compaction uses compact_lock_irqsave(), which currently operates
> > on a raw spinlock_t pointer so that it can be used for both
> > zone->lock and lru_lock. Since zone lock operations are now wrapped,
> > compact_lock_irqsave() can no longer operate directly on a spinlock_t
> > when the lock belongs to a zone.
> > 
> > Introduce struct compact_lock to abstract the underlying lock type. The
> > structure carries a lock type enum and a union holding either a zone
> > pointer or a raw spinlock_t pointer, and dispatches to the appropriate
> > lock/unlock helper.
> 
> It's regrettable that adds overhead - increased .text, increased
> instructions.
> 
> Thing is, compact_lock_irqsave() has only two callsites.  One knows
> that it's dealing with the zone lock, the other knows that it's dealing
> with the lruvec lock.
> 
> Would it not be simpler and more efficient to copy/paste/edit two
> versions of compact_lock_irqsave()?  A compact_zone_lock_irqsave() and a
> compact_lruvec_lock_irqsave()?
>

Thanks for the feedback, Andrew.

My initial goal was to reduce code duplication by keeping the logic
centralized, but your rationale makes sense. Given that there are only
two call sites and both statically know the lock type, splitting the
helper avoids unnecessary abstraction.

I'll introduce compact_zone_lock_irqsave() and
compact_lruvec_lock_irqsave() in v3.

