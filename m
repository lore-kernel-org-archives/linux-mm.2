Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96DB0106ACEC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:58:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3DF96B00BD; Thu, 12 Mar 2026 16:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F084D6B00BF; Thu, 12 Mar 2026 16:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52836B00C0; Thu, 12 Mar 2026 16:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D3E506B00BD
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:58:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B8171403E8
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:58:01 +0000 (UTC)
X-FDA: 84538623162.18.43971CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id F24574000B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:57:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FLiV1etm;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773349080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0OrgL1iQRwZHOzCyRQIk0lufG4h3ls5sHWCdkmfF4e8=;
	b=mEL/1KOd6m9S+z2fQBsnSDGysOzE6lYb2TN5DEe/aC1Ao8h3TnDku7G5Nv4dmJBsvxWeO9
	hB9d/nkzaLQiwCCwHkmreGfxLc4GEhrDX8E75+IlxJx8fhE2HU3Q8syKQeVzuP2pOHcL6m
	camyDUxMXtJXRyMpOnDyS9n8GenWQNc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FLiV1etm;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773349080; a=rsa-sha256;
	cv=none;
	b=lXFmT3K0mzglcqSMMgfOgSbfVW4hA+jprTX305dskQmbVHDNjxJOOfXwH06PHa1b5AXydv
	hsDyLu1NasWnLBli7yP3iAAvZKdw8aXYBtHdcpTK3pBOaPhIF8G9zq7BqCcg9zdOo2EsDX
	OZTy46IGOiq4fwHTyHQIoaBBqzn7GiQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6134260142;
	Thu, 12 Mar 2026 20:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D739C4CEF7;
	Thu, 12 Mar 2026 20:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773349079;
	bh=K9BkTSEP4DAO1oqXkTRgIUsMciXJXXN0g3ET3zAlngE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FLiV1etmYVcSGbbdm/XWzQaxQrtcu+DjcXjI6bdWYsu841NM3z6Xw64cXI54+iaIn
	 L2BrHY9lnVUqIJ6938urwDNEtRFz9ffekCMe3lr4UZIlR45/w5t14m5ix5+hCEMOxM
	 z/hIOPZIY6kgBHdLKvnC8iu8NrktiaWhHWtId3+Y=
Date: Thu, 12 Mar 2026 13:57:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasily Gorbik <gor@linux.ibm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Pasha
 Tatashin <pasha.tatashin@soleen.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 x86@kernel.org
Subject: Re: [PATCH v2 1/4] mm/page_table_check: Pass mm_struct to
 pxx_user_accessible_page()
Message-Id: <20260312135757.d65e8145d9d39e1ca5bc9666@linux-foundation.org>
In-Reply-To: <ttbskgg@ub.hpns>
References: <cover.1772812343.git.agordeev@linux.ibm.com>
	<ca77f3489453c2fe01b25e50e53b778929e0dfc5.1772812343.git.agordeev@linux.ibm.com>
	<ttbskgg@ub.hpns>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F24574000B
X-Stat-Signature: 94d8of5wmxycs3i8zih88gm4gnp3nyep
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773349079-329685
X-HE-Meta: U2FsdGVkX193TznZQxGAlomW1I5Z4+xIWI0gARMw+lNdPXfSLsIHjiwtlYgH5MaDqsj2GaJgSEAe/A0+2BvqFv5oPlqjFacLD+J4GcmaK9kNHWNlkDVXLb0QbD24PU9/LtadBibvdF7Zkt9t97+khT2ppoRXqbX76CpiL9DsmsBPUurR8PkyxoNEqwkOhZvX5dwOsI7I70HmNTxs1kPJAhkGQBvXcpLBm2oBqWjeyjXTaKJJxZij7jwEpGt08geKXDcf8mtBvE7bVRTSaoTf1EvG4GT0Qpmeun29/O/ocL1utD3xkEurlK1RdW+bohFzv6W4re8yK6oyPrcYtEFkO6JTyTL8sszLf6bZToKZ723SDJyde20TB8TA1oEamD9aLv2rLZX6Vst2lOR4fvKuTCWk52mrXT71nLg+J6ng70UFmRFgmDBE8L6iW/TtWkYnl+NN2vMngWa8IXYnWmiJRi8wS6/7rnlm2uKpg60LtG2Be/MGFlbxgznYF1V2J7chvn+JmS7mfg0b+w1BzVcQkYn3zrP6iNvsVBGFLRcvCT1EZCUbqOUg7VoevkDaOtzqh5ZIcO2oKQHCHdIRnYFrcWFop3Z9dqB50twV0BslvT1cSM4I8ogikp/Rn4fWfQRjo7JBpNllSBvfbDnhvW1NbwaalRazZ18ONV+b/IJyybjrkb2xXL3Ujg0YBR3jn5iwdYd/Qv/VR5yB37FNGQxgp+zcrTQkzN+EuAC/fRoIJayxvYHuomp/zKgGPyh19cHJsw0XC/99rARO0nPS3H2/iv7Z97ycNVuhX52JGLQdiaI0Rg8lHgfuxj52JkgD39nF6TdG9k2uUNmkthQqcPO9y//I7XQki7Mk4j+QSSCXC/hmSOq1sRlpzj2loUNyxYtQ+2nOZU5uHc+DzNW+LRiV/Ht9sLJSec0N9EV7ZQ2GE7XVFV+eaGGcgVXPqZH32sEH7gTNPh+zaprsHioL7XH
 jOGOcAi0
 aIQfy6cHNsTZ1s8EgP51GNioviTV0V+x+vD83GY4Mm1l1rhhHl9r1LMgtXMLaZQw7z12CuC3FX5sWPjk0bRPW+xJ8sOibOw2yQkiO3G+oqxas93OgML3+Pdrl75soAYlsJo6iU7PCAJ0XRMKbjrmjNp3flEdGP3rqXBB6pcvrqrzcSbf8EFog1UxWnToYRXyvGDer4154nOxYKCfztK/+Brog3IQcsMKLNN9eTtBTz6HFYjLvmU+mwG50CFYE89h5enyWE47D5GDEp2PIB5LMw2F3q8IoR9n0M/eZc7SfOQbnFSGS365lyl3M11v8Kb5IqFU5Ut5xGC7pkQmBHgJjDIEVuwoHy8xKrHFUDYWmzgKvlgWgCyWT00aLTGBZCLCBcLPh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 16:02:40 +0100 Vasily Gorbik <gor@linux.ibm.com> wrote:

> On Fri, Mar 06, 2026 at 05:16:30PM +0100, Alexander Gordeev wrote:
> > From: Tobias Huschle <huschle@linux.ibm.com>
> > 
> > Unlike other architectures, s390 does not have means to
> > distinguish kernel vs user page table entries - neither
> > an entry itself, nor the address could be used for that.
> > It is only the mm_struct that indicates whether an entry
> > in question is mapped to a user space. So pass mm_struct
> > to pxx_user_accessible_page() callbacks.
> > 
> > [agordeev@linux.ibm.com: rephrased commit message, removed braces]
> > 
> > Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> > Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Tobias Huschle <huschle@linux.ibm.com>
> > Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> > ---
> >  arch/arm64/include/asm/pgtable.h             |  6 +++---
> >  arch/powerpc/include/asm/book3s/32/pgtable.h |  2 +-
> >  arch/powerpc/include/asm/book3s/64/pgtable.h | 10 +++++-----
> >  arch/powerpc/include/asm/nohash/pgtable.h    |  2 +-
> >  arch/powerpc/include/asm/pgtable.h           |  4 ++--
> >  arch/riscv/include/asm/pgtable.h             |  6 +++---
> >  arch/x86/include/asm/pgtable.h               |  6 +++---
> >  mm/page_table_check.c                        | 15 ++++++---------
> >  8 files changed, 24 insertions(+), 27 deletions(-)
> 
> Andrew, may I get your Reviewed-by or Ack-by for v2 so I can take it
> via the s390 tree as well?

	Reviewed-by: Andrew Morton <akpm@linux-foundation.org>

It doesn't look like [1/4] changed significanty since v1?


