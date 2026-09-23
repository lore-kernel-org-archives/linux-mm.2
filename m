Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16463C9830E
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 14:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 110C56B009B; Wed, 23 Sep 2026 10:46:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8D86B009D; Wed, 23 Sep 2026 10:46:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 025086B009E; Wed, 23 Sep 2026 10:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D65EA6B009B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:46:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A1A6A086B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:46:29 +0000 (UTC)
X-FDA: 85245302898.18.FD5C659
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A5F32C0008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:46:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fzblyvSK;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790174787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ia/uJnJgEt3TppJ3oghshuBusp1+GVmLdKrLBHFvgNo=;
	b=biGhJbomB4g7NpQFbNeYmMLH/IjHX6RayBpabmd2RQG7NLjqq16agKBq0mjlwqbtbZsEyQ
	06Jty0jtFVZAnn4ph67Cud4Pd1zsuF7kBBJLE85TigE1fKmGhoH9yOA03f3/CMpxtkRcy3
	YIDZ0TPbBBWTIniwsMh2ZdzkfTL8nn8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790174787;
	b=zVGvgmX3acg2XBlnGO46vpI1RBr3zQz3VJPeErx7Dp2sXml4wU6Xp1KgNBf9pomnn1Xkfb
	PearnPctuo+dQpYMuQaT54UYEmaU+ByF8yCAVAkCTJ9+moYQSWVrWBjhwal/wqtsghadsl
	gWJ7NFE/5V/IamKhhCuiLXW2Apr55HQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fzblyvSK;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1130760210;
	Wed, 23 Sep 2026 14:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D231F00898;
	Wed, 23 Sep 2026 14:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790174786;
	bh=Ia/uJnJgEt3TppJ3oghshuBusp1+GVmLdKrLBHFvgNo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fzblyvSK+VcTOEf3Gl4rbuJnipZbM6qJdn0loZfx8fEC5s0jd5vSZ8LlQnGeHlfr4
	 Lh8zKFnLns+2fj993IPMrTD7J+71r4i4Gfb/7W3Ii2OMpAueu1cNzbmLmnCEhT11Ds
	 wN/NuviMrwTQ3Qe4GO5Tgn5o2S0V4g6XTfGh6hdUYmz8wFGikbrR7HgD/PY/BXH+CZ
	 UhPKnSLnW7XdBgQ8hqrDslLv8xkSmLDdvFMDFUSgyZij+r/4PVrZw/3sWdk77cjMy4
	 bCgkxl6s2587Nks4DKhk1MtVaEuWQuNkh9JzIuKgJ+h+u+86pyalz5CcT2n4VAZlEd
	 xwuuVv441rrtg==
Date: Wed, 23 Sep 2026 15:46:20 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, david@kernel.org, vbabka@kernel.org, jannh@google.com, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Subject: Re: [PATCH 01/10] selftests/mm: exercise MADV_COLD and MADV_PAGEOUT
Message-ID: <arPl6UhNDbwds4uR@gremlin>
References: <20260922235830.2350770-1-gourry@gourry.net>
 <20260922235830.2350770-2-gourry@gourry.net>
 <arPgwegm8XgbEUrO@gremlin>
 <arPjwPwVxdvdR5S0@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arPjwPwVxdvdR5S0@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A5F32C0008
X-Stat-Signature: n54h6fhq4tyg1q17r8sgiy3sjbuonfuy
X-HE-Tag: 1790174787-207437
X-HE-Meta: U2FsdGVkX19BkzAgD1rPD5BFvHJmKTn5X0aiG4i0OlTov+ERzpV6djH5t/OGBkGKiruRrVWrCCIwFJamylLOF3+hjwXL31HwADJA1sfCBFkzkfFuhj1dL3TpJ6CpkeZE3U2nmyXFH07UmCUjYUCpl6C9mh8wY/CwhbXGu+7K/n7N9sJYkmQNDIGpxZREeGtksg2VE/obt6PmUiPO6BRL4Oiur2oEAWWzg0MtOx81jBhHthblkuYCqABoVwEK6tRSt6NpwaCE9k/sAaeHx/d7g6GSCAz7p9psM95MX3mYZdfqiycZd38IPY134ZIHhlbM3l7d1ubQvlZmGpF/+AbRf0xVtROqh7CKVhsqQzASiLXpRlXtmuvJCzeZ/ihLi82gJZ1PdHyRnxNUKyVTbNBqUaYCBapWSqX3FWWi+0bjC8JX9XLIAee3dMKasps/Pw6Vcp5vlKfDcpPdf8OtBzh7eZtRamh/jkrolWpiTXvmDSKV0oNGfA/ztzQ9wxGSYeVcKP7IhwSQCUPC1psNWqSdpyxQ0WOmTWyAkYPsq/lCOH/ZwoKgDoIQ2ZhcrSZRBu5mCukrfQp4Q5VJCHQDLP3KokwejgdPkxX2JO1axLPfH/LDghKqfuAKkGBRsl8uJ+u1vZfdVbpF1QIC9HNZbmiIjQT4dRahBfgL7jXONy38zkvIrp1dsv3THzO3JSXg8kbdgqkiYdql7smmM2dpt/udn0qTByxGKRzGnIX+yqsdFKWrmtyzkcQuPo8hkSyNwZf/RdBGcFNV0Rk8dN455gB4FR0E+ODslBmuV/TxmVtMA5WsSnU5jaf4/oYnzWpfb2ezduESr+Ib86+YYqtFJvbA8OnEfuBrJMu60vdCGycW5sX1gs/+L/wxRB/sq7DuVMJR9QoU3IRDsBhRL8XnXf74rvfiNl9op/SIotECpnLW9dRYyjD1BKBTSS2ZfcoRv73LXyQm5wSCJPQbD3Tel/R
 dZZ8AoBp
 w9JUQU0+ApM7OyYkG4sHYvQCq6z3l2gacewh7/CuR1w6REToZ5NcLn0MUTEr926uwF8z3P7DZkvY3Yqm2gfiXpaWiPAbQcwLhGpjMOTrBy5K1/Z1XQA9wEiZHhfyPDTYJi/MGh3g4CBeccchdIt0tmIF4Cf1HVl6OMNx/8zJAy8FRICcCOuyNgZGEGV4+WSLtPNrdpZx0Wjg/YR0rHJara5a5EP/Vlw2qhpWDURbAw0fu2yidUVfbteaxAgo1rtAsEU3pTHpz6WIw+9kXn4yQR0S+x7OFnbgYcvpA6rFGC72l3ZcPqbNZqhyn00NHaekbimW8P+o0XKPtYRRlA6NgR1ICmqh40Gq6LDFEu8HmiZ0ieVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 10:44:17AM -0400, Gregory Price wrote:
> On Wed, Sep 23, 2026 at 03:26:05PM +0100, Lorenzo Stoakes (ARM) wrote:
> >
> > I think in general we want to avoid putting stress tests as part of the
> > selftests in general? Or at least if they might take a long time to run or
> > excessive memory usage, etc.
> >
> > Though that might be benchmarks, as we have the THP stress tests so maybe it's
> > OK?
> >
> > >
> > > Assisted-by: LLM
> > > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> >
> > In any case I really do think this should be split out into smaller parts, this
> > is a _gigantic_ change :)
> >
>
> Absolutely, but alas my poor email hosting throttles me if i send too
> many emails - and sending a 38-part series where the important part is
> the endpoint of the refactor moreso than the individual tests...
> instant 24-hour timeout.
>
> I'm working on a solution.  Need better hosting.

Thanks! But yeah damn indeed you do! :)

Though larger series can scare people off so maybe better to send the tests
separately?

>
> > Since you list a whole bunch of different test areas and you're exercising
> > different things you should be able to split this out logically across those I
> > think?
>
> As mentioned, this was originally ~28 patches split out, but i think
> ultimately only the contractual tests should be shipped.
>
> Maybe there's an argument for keeping some of the implementation
> details - they're fairly easy to find in the code below for individual
> inspection.
>
> Examples
>
> contractual: These tests won't change behavior based on implementation
>  - authorized file PAGEOUT evicts a clean file page;
>  - unauthorized shared-file PAGEOUT leaves the page resident; and
>  - private-file PAGEOUT reclaims a COW page but preserves a file page.
>
> implementation detail: behavior can change without breaking a contract
>  - full and partial MADV_COLD on a PTE-mapped THP

Yeah doesn't sound unreasonable.

>
> ~Gregory

--
Cheers, Lorenzo

