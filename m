Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 412F0CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 13:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B8B46B0088; Mon, 12 Oct 2026 09:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369896B008A; Mon, 12 Oct 2026 09:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27FC86B008C; Mon, 12 Oct 2026 09:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E9C76B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:50:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 79935C0BD3
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:50:22 +0000 (UTC)
X-FDA: 85314108684.09.1596037
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id D3610C000A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:50:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lm+kKnUH;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791813020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iIF0cuBrvG7b5EsFRUsQtjqUL9CqJNgHm4Pujjq8N5c=;
	b=EhtH8nNZ0nKqaVx32oMvFFu1VLXzK7oEBuYWxVr7y1CpoIw+DKFw4jvATvYl6szNP6FcFl
	1PE+e5pSb4pWHBagcwgemAOPxA+GtFNPBMmWBmU3VoEe9PilVwoYLAstsbdNDoDw2JNk2S
	HPGYjYJfaU1nFUeGeFLVIvpkKewY4pg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lm+kKnUH;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791813020;
	b=HTx93ylM8JNldBlFncMC4/1MZ9EHnRRBlp2sXVkSLOrIBlq+G8+Yr/2KF6tjPnafUqPn80
	4eFt7tXStEFc2r757Qm1mSOtHjDrdzy5MA9Y+zkP1AmBRKWh++a3iWU4G+VlsrZ5BSnNMC
	nK7RLGc3VYfJnAdVU9voml38FI+Z4Fo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1596A411DB;
	Mon, 12 Oct 2026 13:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354411F0089B;
	Mon, 12 Oct 2026 13:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791813020;
	bh=iIF0cuBrvG7b5EsFRUsQtjqUL9CqJNgHm4Pujjq8N5c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lm+kKnUHfiLVmzLPRe4NR1YRlcaapiM8GWY8ZbTS5ukWb/CAm9lH/msxFephP9zZx
	 5pZhY5gLUXsJCyUSi5NDRxWpADvgWvPLBea4X60jo9qifaBAKPwq2HndWaxjT+4cFF
	 BJcxL5cKSeTnnjl9KeH2mjW3xT+9YdeVDngEujeiRE/kBUzBkKRCfg8LRNqQ+KAlBL
	 X8awSOOC2QVH4jHMjQ1AyvGgdWDWReZapWKnkV8n+YlbEMUOERC27oD3QA/GAvr79d
	 Y/CY03Z5C9NPPGZXUomO8MdSs/OkMhS4T6zyGIN84V1Vov9pk3SfSKpZnrJTiUcuPW
	 zGXbfcjvvx5lw==
Date: Mon, 12 Oct 2026 14:49:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: albin_yang@163.com, akpm@linux-foundation.org, liam@infradead.org, 
	david@kernel.org, vbabka@kernel.org, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, albinwyang@tencent.com
Subject: Re: [PATCH] mm/madvise: add cond_resched() in THP branch of
 madvise_cold_or_pageout_pte_range()
Message-ID: <aszlcdgUO8bUdNFs@lucifer>
References: <20261010024042.4070048-1-albin_yang@163.com>
 <aspKmWIrOzNjiP-t@gourry-fedora-PF4VCD3F>
 <aszZPq92qX3jpsNE@gremlin>
 <aszhNc-Lrw7BgCT0@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aszhNc-Lrw7BgCT0@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D3610C000A
X-Stat-Signature: gwi79496dz556jndticgsh7r1ytf6y86
X-HE-Tag: 1791813020-789963
X-HE-Meta: U2FsdGVkX1/X7UjTHx2/nFyAsRwUEG8IrnedYjfTEZlKWU48huE1sUNaek46eG8czQG5LGQIrOtPsO8BlLlswW2slDijH45DpfUwraMft9h3meJFSelRSbptV8v4M9aU40RSatYVt2XjMKGYGYTIj8FcwEHoZOZzsuCnVuPlS/tWYbBaHjTnCoyaK8OKxwT21pefU9gKulNLOTKME3dRJk+A/jLhUszCLWYFOp2jLaV4Ir9kIKopELsN4Pb85jVTFQMC3InO6tMUyDOscc3vaywbLNvTOCuOyxOI+DC8UhP8Z++fRp+Xz5QMojyMRg3PwPcNdBdEV3CLSk9+BHvqHAoxItx1cUdvExoBIWS7yIqEe005iliK8WidF/w0+ktNED/zxcVLqTR8DMAH1LbrdjvhooHxjTqMokhrHjlEel9f5e9ExS3kjiMsw4Do38jwqkWnA36cwzCMBcURKeW/UY0tJMRnd9ob8H0y6+ZyGduD9t4cEuSjW4dl42Z+Q7i0rhPvDesnrDYIC0KYupsmKm1BAzd37iyLSz3tHolH0JVg+dyrG7u48Cb8Yv2kdbHql61IdtiTd3r2C6OEcoJqrAtZ6u0SAmi6zkgmmZfdT90JMLGUHlcq20BK+Nypp+ADnEoScKLLXSYQUlWsrvqprebFX0miydw0PmWxVU/DkCjb4fdpFCBMBe2hRAdfsoZ14D0t71mwIOkuLEManYOcchX6cJaaxP4gCD8UkcIHizEEkmbC/w87fzSvINp0Q7w8BZdHyRdg3DklBCq2dVQMpBQgm8keyNNiL0oawaeYCy51Dv2Q9vfVwaj9LlHGUffOuWKgmY2hBMDhC9A3UnYkjCEqrvJSxp1vxJUzmFXXeI03RQjjGljagbTBkP7gpkoygCWb+w7Xo5rLsWeUc4DZW1fHkvMjZljhnUqdOySW3Dgtv4lYAYE3c3u6lWGCfWuZUePsCK94l/ZXk1gYRFY
 1SGScfVj
 qPaAjtws1qoISqWxt6x0mF0Np36w2JJ2SseSbclqC1p+Msva9e9y1BhKFotJKv5uNwAAXQNeroejGVVsIMbLOJKxVtmBYt1B0CekiXtTEwuu6OGUan0UyjUYh8oPJviTvy/M7r+Pd4Al/XeVtBAjpqvsNZalOs3iylJsmC7KHBhwLUvKPhe1pDsrgvxcrCgkULfv5Zl0k1CwDdAaUdTmziUhKznkYbit6enli8VR//hvXoNjEibpbUf3AU4W2gWSMBvxIyY+PBP81IA5wdopPW229lfzu50OBvTevEseAFPJy1VzeSV/Jyj0JzyIDOaf9zRRfdWxbFtEhF5XQQza5vD1lzmFpYfBs4MU/n75z7VWHVu8ToqVSaR+xynLuDGdj72MrDXoAzdrAYduBVs8EDpfiLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 09:32:14AM -0400, Gregory Price wrote:
> On Mon, Oct 12, 2026 at 01:58:18PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Sat, Oct 10, 2026 at 10:26:33AM -0400, Gregory Price wrote:
> > > On Sat, Oct 10, 2026 at 10:40:42AM +0800, albin_yang@163.com wrote:
> > >
> > > This same improvement came naturally from refactoring the entire
> > > function into a proper pagewalk structure:
> > >
> > > https://lore.kernel.org/linux-mm/20260922235830.2350770-10-gourry@gourry.net/
> > >
> > > this function is really nasty.
> >
> > Nice!
> >
> > And thank you for looking at this horror show of a function.
> >
> > But yeah as Andrew said, need something for the backport, then your work can
> > help eliminate the source of such things! :)
> >
>
> Oh yeah totally reasonable, just pointing out that two separate efforts
> came to the same conclusion.

Yeah, it's nice it fell out that way!

>
> ~Gregory

--
Cheers, Lorenzo

