Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77FE8CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A36C6B0005; Thu, 28 May 2026 03:16:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5540D6B008A; Thu, 28 May 2026 03:16:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48FE66B008C; Thu, 28 May 2026 03:16:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3968F6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:16:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C08DD1C1F70
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:16:41 +0000 (UTC)
X-FDA: 84815971002.03.2A6316C
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf16.hostedemail.com (Postfix) with ESMTP id 01652180007
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:16:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779952600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1itDI4n1n0mH1UBtuFOYwvdaKOCLmOzQbFutCY8dx4k=;
	b=KkeRNrMAE68MYGKokuqppRTfiEfGk0rr71JCxW3Oo2U3N/POPHMIXtDVh/HWTgZ02nDt8y
	3Dcoqx6SaQJem1EJF5vdwPYE7P+Nk6ODa2V+e+b14r0rjokK7ecKB+G4J4qWiPKCcYAL68
	Pk36Sfu1AkN9fF/6z2YtEBb6bzF9dsE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779952600; a=rsa-sha256;
	cv=none;
	b=fvEWaEzyiuuwllCELLFRaC+1n0Tk2Pj9UDzaD7bESltlNNo23Rc0712T7OAcIfFXV6osyK
	HjEaK7ayismOxnR3FH+SImvbUafHwdKNlHvoaPWCQ3R7quovoXPDjUhFca4wGH8B7d/7RR
	V97KqzlwyzS3Axew/aFwWDDLh1HJZh0=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5567568B05; Thu, 28 May 2026 09:16:35 +0200 (CEST)
Date: Thu, 28 May 2026 09:16:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, baoquan.he@linux.dev,
	akpm@linux-foundation.org, usama.arif@linux.dev, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: Re: RFC: better block swap batching and a different take on
 swap_ops
Message-ID: <20260528071634.GA1184@lst.de>
References: <20260515120019.4015143-1-hch@lst.de> <CACePvbVvhJ7Kz2wtUUu+PoNweOsq5XABSMqKrabX6FTdK2fpuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbVvhJ7Kz2wtUUu+PoNweOsq5XABSMqKrabX6FTdK2fpuA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam12
X-Stat-Signature: dbgthu66fda5ya1py3jyfwxjxpor4q73
X-Rspam-User: 
X-Rspamd-Queue-Id: 01652180007
X-HE-Tag: 1779952599-77062
X-HE-Meta: U2FsdGVkX18KWx0qTKoA/PLmUblxlsecYRj+ytrjYvYJ8Duvba4PkCt10R62wdcLpJnduNLuaZxyqcRoixCEWARWXaF+QeW1k+GhCMxvulk4B6/0y0HSJ8W8GSCv+fYZWvR2RTiyKMC3+aM3PNLUGbqkM+6OzfFgAxBkweGVdUrW4KEbtVJbo9FEmoBXH5888Qzq/Q0Zawt4Mt7GrTNWx7kqsrFjWToX4hIW0WPuXSqRLaki8CTLWgAK46mY/b/3HvwLHmg4YQnYGR932c7U7hXan6LlXYG+ZJ76yz4GRjuy8Q5SlY1jKhSwYVp5KEhXvSiDYVIBUMU/VLogjSgMv9HcKGprCwrf6tIfiNi6/r3x8WX3sPACg7xvMfUXb30XPJ+ocSMJfLGtcpamQ97bHNwFxQUgmQ3yaJplhYgpYVqNFKR4Ee9uYakYIsa/JaDzbIByz0TobHUkYmcAZSBxSitzcz1xYJYrYhzQZ6m+2CpwVbrSjmaFJxyEAOKk3DkxWrmjt4truQQEaIe7njAySXNGwKniT3YBuXFD++dhhU4Zl4d5RAPlFSqCZf5rHeqRtEd9Sf5peujZ1JOrH6QhyxsKl1LcxOrCRiT2eeYkatRuSPXtdU1OfKYnqoQ56R4UG+XSCYnz/4FkbwiCyJ7bhSQvLxJE3hEKEGdvfwuvaoIRSzuZxG/eElRy9gGoSB2MNTOAaINc0cREySHyt8AMtyV2hlvzu8UbaUrArHNCwYHZZAmVWFxihzZ8oD9Nl0MU4srvglTAYI7bN3OL8cIvuIRlM1zVcOhFOX7QTd0hjOxVv5GQyg6XrBqC5DpqP+tgWPVWhgTu/2L40FCUcIwEF6SZ+byYpSmJU3IEH0VG3wgHSJPtwX0/8C1Zq98Rp9kG5HxfB9SPMDa7k0IuPgo+YKkELMeGfELc/r681ujJSKbBMdzZ7Fx0x2itL8hAVkzkGScrIjYCBO7xAEszzBN
 QuDbd2tW
 D721wDYAvjcYp1GIuDyRoLIwwsKFwfhUhykQwT+WvD0WKcMKX57kBy8OyPJDwmiTF0BqWx2dHVMLr2Wi+MI5wSkY4ds5F0Dn6RoopaT8TKiTp+vUB16MvYG5TApfLbBShKlYz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 12:10:48AM -0700, Chris Li wrote:
> I like the direction of this patch series. I suggest you send it out
> as formal patches without the RFC.

I've been planning to do that for two days, but I'm still waiting
for the buildbot result as the buildbot seems to have some delays.

> One observation is that, this patch series aims at situations where
> block io merging would be beneficial. This makes sense for the
> physical block device. However for the memory compression based swap
> interface, block IO merging might not offer additional benefits. What
> do you think about a combination approach that allows the swap back
> end to select whether to use bio merging for swap or not? The end
> result is that file system swap will use your swap_ops flavor. The
> zram and other memory-based swap backends use an API that behaves more
> like Baoquan's original swap_ops series.

There are two approaches how we could do that:  make the can_merge
callback more high-level to avoid merging, or offer additional hooks.

> We can merge your bio merging swap_ops series first and then design
> how to allow swap backends to optionally bypass the bio merging as a
> follow up step.

Yes, I'd rather do that when we have a consumer.  My impression so far
was that the main support way to do compression was zswap which sits
above this, and we would not optimize for low-level compression.  If
we have to do that for some reason we can do reasonable optimizations
for it.


