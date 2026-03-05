Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF2B5F47CA2
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 17:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8B96B0005; Thu,  5 Mar 2026 12:42:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6906B0088; Thu,  5 Mar 2026 12:42:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A8D36B0089; Thu,  5 Mar 2026 12:42:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB69D6B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:42:38 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8ACB4139A4F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 17:42:38 +0000 (UTC)
X-FDA: 84512729196.25.26444B5
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf17.hostedemail.com (Postfix) with ESMTP id 55B1A40013
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 17:42:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=BLKLlUS+;
	spf=none (imf17.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772732557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v62qxDPGMf43nSWUVOFWJmlONh5WT3QlqDMXHIbC27Q=;
	b=BEWsHlsii9zlSTc4QJv2a1poFyEJv0NnvZThawEL9KL+3PEQFvYiy6y0jzPmQY1zE6Ixka
	cwUPBjnCQ24Vb9gCr8wNfMgQ4W2Z1KfORIuw5Z9nf2mAfesDQDMt98odHi77y04giGf7sX
	HLSThgzcG4VCNBHafd9PpoGneTL7MZs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772732557; a=rsa-sha256;
	cv=none;
	b=vXhAHmOAFuA9v4KFdRi3qC9W9fhdLgVUu3d8nY3m/jmItK+jsevaBVwJhROcksE+VCV4GG
	Ymsgu6Lz8qfvZYqC5FupeY+2jKUDT2E5F6vdfVCRcdiszbYaImqJjErboFOw9sDrDyKENK
	q0JzZR6aMS99obCt0gq5GD6bje9r07A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=BLKLlUS+;
	spf=none (imf17.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=v62qxDPGMf43nSWUVOFWJmlONh5WT3QlqDMXHIbC27Q=; b=BLKLlUS+FX6VcTXIcA8Sewn2I5
	I6rmP+PRF0KJAe1hwJpoXo9F2rPDVKPI+B45TxuS3MdmPqiXge582xOQSbbqyGsBF3YHm/1Clsre4
	yM5Fj8GbXNWNjGB5+0FiHMQlxO+4F4C70JdmOapv/Ezi9zDexCZDtv4mDKROdkSJaYpCBdEvpSoX2
	fYnPMVw+nx8+7u/CVP+yBvcJy1Di0xChciiwZWgZ8kYIkjSwFQicJM7mzIg6BcFJfAXwRWHVIooqx
	yIvhNH4GR6vYuBFDSwAzc90xg9GmsFhCdcz9bDIkXA6go5kHnr2aYmlHmPsZocrOl4468hm40wUyD
	0Kkm+ZwA==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vyCiV-00000007Mnu-1Q8e;
	Thu, 05 Mar 2026 17:42:31 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 25732300182; Thu, 05 Mar 2026 18:42:24 +0100 (CET)
Date: Thu, 5 Mar 2026 18:42:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH RFC 3/3] locking: Wire up contended_release tracepoint
Message-ID: <20260305174223.GA1442992@noisy.programming.kicks-ass.net>
References: <cover.1772642407.git.d@ilvokhin.com>
 <8298e098d3418cb446ef396f119edac58a3414e9.1772642407.git.d@ilvokhin.com>
 <20260305105924.7069eb23@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305105924.7069eb23@gandalf.local.home>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 55B1A40013
X-Stat-Signature: jcwsofqz5pr3i99phbfntsd5so45n4cp
X-HE-Tag: 1772732556-622058
X-HE-Meta: U2FsdGVkX1/tXLJj2s029gx7QbxlAsAHHA7spMvu0/SyjCse14hUatac+6QUw2cYK8Co59x6cS47pOW5mw4LrM23RM/bSvnGMKckVXn8tWDoWERK8XMT9rTootK1uzhmrZa/nzWUOVm9yejHTH/rGun1lUQyQv0C4iJt2QQV5d3Tkc71aP8BZks6OcfiUgJ6uYyaN46yG27h2ckM292hYaF+vZ4MgvGqajy/3cJ0TMIjbj59hf3Wdf+zSTHnYxajP0b2b95BZfPFhWkTj9qzuILrRvr0ns8vQdVHl38yFwfGg33vCrqEzu8Zgnj20vOHnWW2JqqAomzjag5dOM4A8HvA0bYhFxk9EjjbMruxhLAC71OZeFPm/iGfUsYZIx5xpLQJJXZ5n+5HPitU4y9H7NVShrhFHxVJLaF97AUgcO6k/ru+KWEeD/Ax7Ujz34wTSXDgvcWLjlv7TKtwV/FauSUgQwlq/MwPI+jRxFf34Dr6h04uUHlMCjMk6C6mOPxmHGeN/sDVrxrnugibgr6HLuCv8ozngALvQ6m8BwpFw4DeUpBLO6m7hoIE1mZxgfZoilg3W6JlUM3BZgtS+rCDF+BWpXdBHCs4d/slCyAXewry4Qa+8ch1tOS7W/F4U9g5EwktnKesTCt2qDFemNKQcSnGE+rn1oB5VkVnlpfxfJ9KwLAEjPkKnevFJEJTe43RFMLfgvoS+B1/bU4pWwqIbGgNIpIIqZxW0X4nLga8FxLBsieByZGlfrjtwZJhSrBX22SCxXu2U+HHwXqwEBvMhW7lVSHOrYlXyMtbplOfX/0m3MLnd/4IR0Asg0cvbxv5BdPIL0ln/tkRHf4Vv6HwHZPCBmOZwjGNxMVEGxTnMyYHoS6xtE54kqzetLez/rXrbt2B/sXjs2xmEEzYNvgvfBZfivMWCnNvpJkG16UL7dqUe3HE5ZQIrSMt0ghMT/XAlR6YPEIgcMwUqQuhKfH
 cGAmuoDM
 HzxnFwLUJQWzKaQAaTVLzi8TGD5hZnTdZg+f8lCgrFk9zKiHjcztHGLeCPyICOA01YqasZ9yGF/VJRPevYMNGaUiUbrb67dlvO75pyZF1GfRMUaQ08MxVKlo9C4BVe68bfdt//9wgg32ZLC3RRP+48TcGsVJ/m+bLCFL+xALmOw0fRB5oa3mcAPWMveiG9QbquYixl/JRsEIVgc2bSMGQwhqy6UQUIbrg0nIG/Acj0IBgFFmgwd85Zp/gyyywkzLHEm3+secaoOsgQ8knEMBqYA5krxYvXRCX1nfXU6kfMjkX4vaJxqWnU61z33up83Adnc58omwWDifAetC/OsOrukvN5VN4098svMw4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 10:59:24AM -0500, Steven Rostedt wrote:
> On Wed,  4 Mar 2026 16:56:17 +0000
> Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > @@ -204,6 +206,8 @@ static inline void rwbase_write_unlock(struct rwbase_rt *rwb)
> >  	unsigned long flags;
> >  
> >  	raw_spin_lock_irqsave(&rtm->wait_lock, flags);
> > +	if (rt_mutex_has_waiters(rtm))
> > +		trace_contended_release(rwb);
> 
> Hmm, if statements should never be used just for tracepoints without a
> static branch. The above should be:
> 
> 	if (trace_contended_release_enabled() && rt_mutex_has_waiters(rtm))
> 		trace_contended_release(rwb);
> 

I still wish you would accept:

	if (trace_foo_enabled() && foo)
		__do_trace_foo();

The compilers can't optimize the static branches and thus you'll get it
twice for no reason.

I really wish they would just accept __pure, but alas.

