Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6EB2CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 18:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B70C46B0250; Fri,  8 May 2026 14:07:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B21856B0251; Fri,  8 May 2026 14:07:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A37476B0252; Fri,  8 May 2026 14:07:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FAED6B0250
	for <linux-mm@kvack.org>; Fri,  8 May 2026 14:07:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C84A28B63F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 18:07:44 +0000 (UTC)
X-FDA: 84745035648.24.868CD4A
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf30.hostedemail.com (Postfix) with ESMTP id 17D9280008
	for <linux-mm@kvack.org>; Fri,  8 May 2026 18:07:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=VQuOdwNp;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf30.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778263663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U84xTPtSzHCYwlBfJ8QYFEF9cYH13YL55X92oolwzd0=;
	b=WmuIoyP5TiBuGizZwnr1plaE8FsnE8W2n4QW8XUvCxZtIYIcskkIWJXdjzUim8fTmiSHvz
	YEjJ807XAYKz2csDHZ0+ydYPGvYlmoT9qStFaqi4rNOYY4g/gCSm5OBsEfRg31yfMNyg07
	aD0PZ4qPTKrek19BRMQ3frYlsdcbAEY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778263663; a=rsa-sha256;
	cv=none;
	b=MpSxiv03PeGoPmSNqpmjFrkMtjUsUNjNw0QqgDWAjXyLQOS8Pc3m8Rc1NKUqeGTXk8VedI
	E7zOKgol1KynflECmvJ1HYFsJMCycfWjwAGTI3Ud511LlNrj+Xc1yV7R9fgR6COrDegNrC
	POZyqJaLQ8xhviJvvPCkhqlK+x5YtTk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=VQuOdwNp;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf30.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 361AFD019C;
	Fri, 08 May 2026 18:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1778263661;
	bh=U84xTPtSzHCYwlBfJ8QYFEF9cYH13YL55X92oolwzd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VQuOdwNpwD3wDXPZ50x0gvil9D7oQWIOkhUp+Dj0AEAOqKDxamokQgGBiTFsYPIG+
	 rzKKYCAZl/0yf5qyb96UUZtOWCM8Hnmsmm09tX1YRSzjKi9jQok2BrYaLyWZ279g/o
	 lHMGGVNXMSINmfC8NCrpkzmIis8akxSsC9KyMyDY=
Date: Fri, 8 May 2026 18:07:40 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, hawk@kernel.org,
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	kernel-team@cloudflare.com
Subject: Re: [PATCH 1/2] mm/page_alloc: add tracepoints for zone->lock
 acquisitions
Message-ID: <af4mbDB3-ohO5DCp@shell.ilvokhin.com>
References: <20260508162207.3315781-1-hawk@kernel.org>
 <20260508102948.b1c687e623fabec65580f258@linux-foundation.org>
 <832e4333-4079-4865-8ad8-3dd8868fb964@kernel.org>
 <4f61457e-deff-430f-8a1e-d3c33c925db3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f61457e-deff-430f-8a1e-d3c33c925db3@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 17D9280008
X-Rspamd-Server: rspam04
X-Stat-Signature: qatjrh7kp7ujjhpypujpa4mkqygybio8
X-HE-Tag: 1778263662-311614
X-HE-Meta: U2FsdGVkX19xaMlKFiA7slKtQ/fni5IWKX+/K7a6OrddE8L6lNWkygasHhzdxHTo6stpXkh0Lkq4ZtBTiHQcry8nJ+xeD06olbp3Y14zfh7iuVA0MIufvU4CQ24+WCfAOpjtzr0exHnZPT1+zL6IZGKNby3cAbLjavMEU/6Dw7puPbcBuIFoGSIbgKDvQf9T3N17PYh4kv+5AElgL2A+EQRkCTWON6iSm7Q7jODU+T1diMztcQlJzijjHC3/S3URSef1IF8Rdbowc4xm36yk/u3zsS2BZTIijQvJjQwtOYjfWOG4Qz83v3h2PP+xtz2Ha0b+rIss+NyWkqph6h/8tI2sUNpEj/XEgMTjmH65nc++r0Aq3iHAhChAQR2dfGfJj5LGbN81bTxIR/3b7F/vGBAhXsgI1Tr3ZQRLeJN9CQN9wkINbygEhGibTLoabio6h0u1BincMfEVd1ZXrj/DxIsDa8P7NeBokx3INuAxSi597YfPSYeG+0lx4yrvx5n+LE0bDvfWFPrj02mCGy3n1b85hRn2r/nLkDrF3d7V4718trwoT8lfMh9mS/+ocxhjZG12M5zVDf2r3PzSGESC/NE+j2mUsG2gb1DEDCKieyT8guiKQTUkPoqrJgKqFkTsDq7PTS8imV/qG/7bszYCXazDMqRSscZ8zEuhEngIwdqjhan29pyV+yJ7yRGOQ/1DwjWO/APtNK3XAj/1Hir64c88kcnjpIBEKPdaGfLu4QmZMIvpouA/Qss6Qq4RB8qY/2Lu5V4IEBenlGNh7uG0p71ct92cm6lHf0F9lw6dT4c8NSr2HLqrG3Xge55SPwcb2tdUEAOh/5s8HpR99640Wxum7X+xfhDIxMyqOjDcFbuSPcLkGIoBMjXOGEu1kY+BV9LxBDS4OxljBmTekK8V6PlW08z64/GSiKlr/C/e99q4s3TEi9W/H7h8hkmXMp5vuubZSWlrtzFH2iQmcXE
 r07FD+3n
 Do0voh4UJmiy1wVPCb66PcG/Ws+7tbLFgnK/2rH9y8CcCtRDdjt66PNqjeqVCvOu3BGkj0r9Jo59EsKsOHaSVNDUWfXM7B1I+I0NtEks8HGKQ6IinsL3c2WS8dfgW+ph2DvD9JxlyaJwoD42Gl0uSinfys6TMOKzA93pyvuBJxEZwbZHovh2X5PH+jxxppu4Q0VTeUKvxq1gkCr34o+iec/phHEwHDuUiYLVeVP8S5wPMRv/o0HSxDoAI3le/Jxgtbm1339i6dah5RXnCDxr9RDMItdvxqnnmBiFvy83ESwtpyeG6v5RrwhLb91mmFTZtheMZghkWacT+VtgmrV7fBwlpiXvJfh7X+fHvE42r8XpNRQZ4p1PCqZZ0sBaMgPV1/O8qSJbMKJ9eGVJ7o4zpYnI/tB3vD/V2ZRGW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 07:40:51PM +0200, Vlastimil Babka (SUSE) wrote:
> On 5/8/26 7:38 PM, Vlastimil Babka (SUSE) wrote:
> > On 5/8/26 7:29 PM, Andrew Morton wrote:
> >> e .configOn Fri,  8 May 2026 18:22:06 +0200 hawk@kernel.org wrote:
> >>
> >>> Add tracepoints to the page allocator fast paths that acquire
> >>> zone->lock, allowing diagnosis of lock contention in production.
> >>
> >> Thanks, I'm surprised we haven't done this yet.
> > 
> > There was a recent attempt [1]. Not being a generic solution wasn't welcome.
> > 
> > [1] https://lore.kernel.org/all/cover.1772206930.git.d@ilvokhin.com/
> 
> And this is the generic solution I think?
> 
> https://lore.kernel.org/all/cover.1777999826.git.d@ilvokhin.com/

Thanks for cc'ing me, Vlastimil.

Yes, this is an attempt at a generic solution for tracing contended
locks, including spinlocks, so it should also cover the use case
proposed in this patchset.

In fact, zone->lock contention was one of the primary motivations for
this work.

