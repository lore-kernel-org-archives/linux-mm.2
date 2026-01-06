Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06EDDCE9D5A
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BEED6B009E; Tue,  6 Jan 2026 10:25:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651E26B009F; Tue,  6 Jan 2026 10:25:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 588AF6B00A0; Tue,  6 Jan 2026 10:25:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 478226B009E
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:25:46 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CDC4A58336
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:25:45 +0000 (UTC)
X-FDA: 84301913850.15.5FB5CB1
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf20.hostedemail.com (Postfix) with ESMTP id 708C41C0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:25:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=QEdpsuNl;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767713144; a=rsa-sha256;
	cv=none;
	b=NUsVAmMEtjchd+kOMQYB2Px3YTpzxHiRGweJwgcxV/oiEFzUw6PDTXiW8f7LEvqU2SY4Kz
	cvV8G+G2hRk0YolQ3rXcbh89jQ4MTYwx4S03W0Vgv325QgbDsGx/FELIfuEDSrOFtmWsbC
	ABU8lg2qR6XBCHjoquKYnPS2YJiJO6M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=QEdpsuNl;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767713144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WfYfd1PzaMaipLKoSbmZze99juo76um6Ea96kj/deqg=;
	b=f59Q1xO+dpYM2Ec9gsy97lxcTVPk84GZ9qSRPVcRLe2inXN5IhI8Spm8gCt41WYFv0aG36
	OF9oG9keSmhmI3KOxKrNi1d3QYbwInqVsFVoLdQjESgHN1nW3iy+wJPrlpsbpQyetUm81V
	pe0G175P1w7FKlcTboLT+PgGIf48gZ0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WfYfd1PzaMaipLKoSbmZze99juo76um6Ea96kj/deqg=; b=QEdpsuNl7ia0un9wF36SttoObu
	nxQEI5WIklTjmDfhrXDmpkPWlxy8UkL6Iqr3LpMakwafmglnFlnXsR5VXVC58V/ZHYkv6AMaKolqx
	/cVr5UJwW1UKZEMlstf6VqpxSWes3tMyHVBIc7W0cJpBdY7idKsO/hNVuRMW8C2V6W76GEHI2hfis
	9LOA40VS74ERDGDEfcydRZnoxE/Xdw8aWQhtCvTN5o2OjkX/+pXncxFEUdmVzLQxJFtvjWUBMr1AT
	do7k2fi00jp3bllKENz1pIemqqzAvW+cZB4IfzbmjRFj6rGMZHixTPqAj4H63R0U2vBEtx8//4DEg
	K94AiDUw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vd8wE-00000009xZY-3ZDj;
	Tue, 06 Jan 2026 15:25:39 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 5D63E30056B; Tue, 06 Jan 2026 16:25:38 +0100 (CET)
Date: Tue, 6 Jan 2026 16:25:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Keke Ming <ming.jvle@gmail.com>, mhiramat@kernel.org,
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org,
	tsbogend@alpha.franken.de, pjw@kernel.org, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH 0/5] uprobes: transition from kmap_atomic to
 kmap_local_page
Message-ID: <20260106152538.GA3707891@noisy.programming.kicks-ass.net>
References: <20260103084243.195125-1-ming.jvle@gmail.com>
 <aVj146EunyaOQzxO@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVj146EunyaOQzxO@redhat.com>
X-Rspamd-Queue-Id: 708C41C0005
X-Stat-Signature: 37arz8ubq1kbmcjdeyqqn4twhuhzeatb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767713143-942030
X-HE-Meta: U2FsdGVkX19PJtRW/GLKw+6pqKC4D4jWOMMPDcF/93GPCzKU1fN1p++dDJEKDlBIN9x9i+5DFJ+7OArQ8pKSk+zPtsekZsSooQYL0hd2/rrgx8+99FV/rzrIIXwEt3j/I906iJRj5ngZnqv5whOFD6yEHqoq3BZFlN9TtDUq0KF62eRa0QhiAnUc35nmisii1wHZxlGuoy3CAOMaTuQ2xXYBePjx552929lvw0U4YihmOeUyHkiG0/OzL/izk9CZWX1dSA7lNQy/75FnyhEEwH+QrP12eXnjHnTb7fiKuta6INBvg2YxEdVHvY40hVveUeVFjoM9JM3MMKgpXKYjKHj060FpseI2YQ/WseOO5zO8DXK52xAS8X6JNQqXpaQMVBAmqSa9H5Z1jLZfLrwJk7Li4ZCyvOpCFR4wXR/L9DDj77GbvP8p79qYYbcHTqrJ5hc1WY7sJQJZp6h8/JsMbyZOQ/Feq4WziICo8zxAwbuzjzP1Jof6ZLka+qgvGfEicj7micvtz72skZNRzLrW8FrwxPfmE5VyQY4/tKy4paYhbx4sWJNTnVZIKP2kjgW1i2bKHzjSAWX0wvdSC6GlF4yfvf1O49fzU79kk0MeUHzAo/z7G/te4iQel5JVgS+A+/EbwL1NWLeq3cER0NzgqQMw77HVzzYVHm0dUgY82NvrC1UN6gD7AdV9ZXW6pNjR8HhEBndUDRMlFsewG52PHtsN9hOP0zYZa2CY8J/kOi7Q4Vp4VDkqwxt67vy5VmM1hkflOc2oIFyHZjh3/5tqahUe4Gdxh2eXfX1JXg/zrWHGG8pZgfOv3sWkCn+GnX9JNEdnHWDucOTiDQg+BPW9Hhco1PWHnV0Nr8Gdci1LwMFw1grRGNVye9SX0QyVNC6OmGe+rFhRYgKUKEWUqWTunhWIgmY1MD8RKAFV+GBpDG/e5RSMmUYM1NYySBsG7yfBADoTywKbcprOhFi8jgo
 iADJXxkf
 4ZcLyetz3Fo/648VYfOSVCbYITPL6gK25dSVRSdBX3afNn5QbtuEqMWWfRcJoMRNV1ebDA0ivFeceiV74YSnZ6eeHrh+NIliQ06L1oR0BBWIsLtvtUtCQTYPhuF31mF2xwtVbjpYYYTiXFLCGmC5GZvglDxVvJCeU40tCRKEvkqjQbj6dDCmDe40iFujeybmph4Pt9jgRgmGvXzqQUqC4u9ofEWsFbtLOBZTpYAu+/uM44TooqLSKv2WqxKS3G7DFf5HWCKeIu5+pSVc1r71kqBorWrZxn2OihUg6lULyASdY4bQp9AGgtbAb0IYEw8ZDT6Be
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 03, 2026 at 11:56:35AM +0100, Oleg Nesterov wrote:
> On 01/03, Keke Ming wrote:
> >
> > Keke Ming (5):
> >   riscv/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
> >   arm64/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
> >   mips/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
> >   arm/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
> >   uprobes: use kmap_local_page() for temporary page mappings
> >
> >  arch/arm/probes/uprobes/core.c     |  4 ++--
> >  arch/arm64/kernel/probes/uprobes.c |  4 ++--
> >  arch/mips/kernel/uprobes.c         |  4 ++--
> >  arch/riscv/kernel/probes/uprobes.c |  4 ++--
> >  kernel/events/uprobes.c            | 12 ++++++------
> >  5 files changed, 14 insertions(+), 14 deletions(-)
> 
> Thanks,
> 
> Acked-by: Oleg Nesterov <oleg@redhat.com>

Let me go stick them in tip/perf/core

