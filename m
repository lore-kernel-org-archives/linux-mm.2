Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EE9ACEE35E
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 02:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 719A76B0098; Tue, 18 Nov 2025 21:46:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EFFD6B0099; Tue, 18 Nov 2025 21:46:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62CD06B009D; Tue, 18 Nov 2025 21:46:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5290C6B0098
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 21:46:01 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E74F7B7E4D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:45:58 +0000 (UTC)
X-FDA: 84125816796.06.E0F6AEC
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf17.hostedemail.com (Postfix) with ESMTP id 559174000E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:45:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763520357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xtPWvbA0ZlT1rkW+dX/KfOjgKFItCRBsi/VasSJDrHE=;
	b=JkhXWQeq0BrAlPu8gP7u1f+SStaOYfztbfebr0edXEap8v/p0xCRp/Zp0tCAzSxucFnjC/
	zcvjUj+4wE5f0B3WG57EthXwkpDNurlo1MoR33V4vQXNjLK2E+xg+EssuTQ2XGyTrQL/mm
	jlDaB7jnnNIkAiy4SAPRS5qMCstipsM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763520357; a=rsa-sha256;
	cv=none;
	b=z9lnxfLdIafMNXEiFCli+1yJmo3AhXAolHAdyYe4P/jJE/MaPyKKqoiPw3zxzeL1Uf3w7g
	Pg4DUyKxTkLSNY1P8/ACeE1035rrVhI26gJeBcewDIDwuK5dyW4CdOnWDNVFL67mdcSZGb
	fRbE/0sIkBROLAlvr8mb9wJhwJsMp7A=
X-AuditID: a67dfc5b-c45ff70000001609-07-691d2f5fe744
Date: Wed, 19 Nov 2025 11:45:46 +0900
From: Byungchul Park <byungchul@sk.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kernel_team@skhynix.com, harry.yoo@oracle.com,
	hawk@kernel.org, andrew+netdev@lunn.ch, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	ziy@nvidia.com, willy@infradead.org, toke@redhat.com,
	asml.silence@gmail.com, alexanderduyck@fb.com, kernel-team@meta.com,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	mohsin.bashr@gmail.com, almasrymina@google.com, jdamato@fastly.com
Subject: Re: [RFC net-next] eth: fbnic: use ring->page_pool instead of
 page->pp in fbnic_clean_twq1()
Message-ID: <20251119024546.GA18344@system.software.com>
References: <20251119011146.27493-1-byungchul@sk.com>
 <20251118173216.6b584dcb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118173216.6b584dcb@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsXC9ZZnoW68vmymwZX9ahb7mpYxW6z+UWGx
	/MEOVos5q7YxWsw538Ji8XX9L2aLp8cesVvcX/aMxWJP+3ZmixWT/rJb7Lu4hs3iwrY+Vovt
	DQ/YLS7vmsNmcW/Nf1aLk7NWslh8PHGC0eLYAjGLb6ffMFpcOvyIxWJ2Yx+jxe8fQGWzj95j
	dxD32LLyJpPH5Vt72DwmNr9j99g56y67x4JNpR6bV2h5bFrVyeax6dMkoPCOz0we5y5WePQ2
	v2Pz+Pj0FovH+31X2TzOLDjC7vF5k1wAfxSXTUpqTmZZapG+XQJXRtPJbraCw0IVvX/aWRsY
	X/F1MXJySAiYSDzsuc0KY2+5e5QZxGYRUJVYsnsRI4jNJqAucePGT7C4iICKRMvmmSxdjFwc
	zAItLBL/D80AKxIWSJdom9UEVsQrYCEx9fl/dhBbSCBGoqnnGiNEXFDi5MwnLCA2s4CWxI1/
	L5m6GDmAbGmJ5f84QMKcAoYSJ+6+YgKxRQWUJQ5sO84EcdsjdomNK7UgbEmJgytusExgFJiF
	ZOosJFNnIUxdwMi8ilEoM68sNzEzx0QvozIvs0IvOT93EyMwqpfV/onewfjpQvAhRgEORiUe
	3g5+2Uwh1sSy4srcQ4wSHMxKIryqjjKZQrwpiZVVqUX58UWlOanFhxilOViUxHmNvpWnCAmk
	J5akZqemFqQWwWSZODilGhgz9W2PTDLjfmE9T/KmX4ec/dtXFuV6nH4PDriJzrlj+jHj9uO8
	C6dX9wcY2z/5Zdv6efF5sU7xOUIOXEWpH+adTTpx5vCSG68XzW6cKX/r8r5fn8KZHp2wC3my
	0sRFwyLWdMf9QDOOha2cl4wXTH7ckZz33frBvpzgsvaPYbO+3jA7/Ueok/+0EktxRqKhFnNR
	cSIAAgFzG+YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsXC5WfdrBuvL5tp8LtJzGJf0zJmi9U/KiyW
	P9jBajFn1TZGiznnW1gsvq7/xWzx9Ngjdov7y56xWOxp385ssWLSX3aLfRfXsFkcnnuS1eLC
	tj5Wi+0ND9gtLu+aw2Zxb81/VouTs1ayWHw8cYLR4tgCMYtvp98wWlw6/IjFYnZjH6PF7x9A
	ZbOP3mN3kPDYsvImk8flW3vYPCY2v2P32DnrLrvHgk2lHptXaHlsWtXJ5rHp0ySg8I7PTB7n
	LlZ49Da/Y/P4+PQWi8f7fVfZPBa/+MDkcWbBEXaPz5vkAgSiuGxSUnMyy1KL9O0SuDKaTnaz
	FRwWquj9087awPiKr4uRk0NCwERiy92jzCA2i4CqxJLdixhBbDYBdYkbN36CxUUEVCRaNs9k
	6WLk4mAWaGGR+H9oBliRsEC6RNusJrAiXgELianP/7OD2EICMRJNPdcYIeKCEidnPmEBsZkF
	tCRu/HvJ1MXIAWRLSyz/xwES5hQwlDhx9xUTiC0qoCxxYNtxpgmMvLOQdM9C0j0LoXsBI/Mq
	RpHMvLLcxMwcU73i7IzKvMwKveT83E2MwChdVvtn4g7GL5fdDzEKcDAq8fD+mCCTKcSaWFZc
	mXuIUYKDWUmEV9URKMSbklhZlVqUH19UmpNafIhRmoNFSZzXKzw1QUggPbEkNTs1tSC1CCbL
	xMEp1cAYmSP1va+JU8cscMvH+aes4+Kvx/5gWG+tfdRXa+aPT7rbJfQb7lf/Tfhu53PBYsXe
	nOnqm/NTLm1cwRNl3f+vM6N25qVZhdMe3H6y9M2ZPxPKjG52tXq+OxM/dzrThZWm63etfds9
	Q5+RgzXKOX3K/vK09tq7ivNfftF0TGC0vqKXY5pZJflBiaU4I9FQi7moOBEAgoPsPM4CAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 559174000E
X-Stat-Signature: esu8oaxpi1c6ysuuf8tbwsnhecx41yfz
X-Rspam-User: 
X-HE-Tag: 1763520355-952336
X-HE-Meta: U2FsdGVkX193MD1cxPtWRLzcJ0/5tR8J+xsGDjZY4Ry44g/SCNoZp2XwOv/T4tSgtBJwpea8SUxtjDAaBBwZOwChfd1EAXf1tWjIxGqGkMDm91krIlxp6eszAJk2nhMgTOV5zHzHXIJtndSqaho+ffmASCLdBt6TU/FuspIjAA5zDtJ/Y+tKctaHjR9J/h7ZNIaZLcE2jOPM9x/1SPW7PAUsBUSx28jJCjCQfLW/VElr6+mKTySdgFB0Bvcgy7IZSFy2MXvnd9mQX7i+IrQQeJUQ5JzYRb2kyy7Lwl0dANX5/gRFXqPHELGyPEcjKb/Wun17SEqHwthFd/zuV0gwNQDBOKvJhLsYNNgrXpOwcJg+fnPh/ZTcKxLFbBeY2UcqaH15sKINHRw40+iRWAtIQPXY0iMaTYzstwiVfgArRHbjk24aWvX04uiuzOy9xvKBS6TIcxD5IF3sdjWKGhDqtOP5V5A5fvcrScM6CfiFuIFO8BW/D2kgbU6YTWaLsR92qH7ZnDKtc4b7pfVnT1+Xekb3zBEG16XAe33xe/slGSbdY21sk7jFJqN6L72Es3q8uNfly7/R7GRR6M+pU2DnGaCC8g0TTYt9zi0l5fiy7rNsVSrRox2jVl70T1ID47+u3SzrwW8QO9AJz7YzYwJMcoV9ltkurydWRiBvzE01RWU4qcu80fX/bCkJZlxZ0oCR88kbVRtziKoU8VYhTLfMjkCcCa0Tdz0LtdL5bESrsg0dV085vp4jDLWy/UR9asvDbsXwZkMMzKc2QrPaSTY0M1rHCU4xe0ERjyex/eK5Zw0+LMfgqOqIDMpJHWVGR8OthfnS4tPehpWMZt/xXFcSggYvJiMpPqTxBsZAx49/1KPUjvWp0B+j6NYjNmW4qEQSR2EmAgf6+znCxojo1zMnExyd/NhBjU4dE04hyFNj83T/NUzFsWii5M09A8Ucy0mbVfEpQL+uL0Yc/PgWLS7
 mH6ogMGU
 EpFHFTg9hC2Cx74hVVRZy4kraW/8WUnxB+R04u26ziY1xyvyawi31A3+4LlbWCZd8o1soS3U/j3tbOU0HtfPjDPn05jEOo0RjQMZp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 05:32:16PM -0800, Jakub Kicinski wrote:
> On Wed, 19 Nov 2025 10:11:46 +0900 Byungchul Park wrote:
> > With the planned removal of @pp from struct page, we should access the
> > page pool pointer through other means.  Use @page_pool in struct
> > fbnic_ring instead.
> >
> > Signed-off-by: Byungchul Park <byungchul@sk.com>
> > ---
> > I should admit I'm not used to the following code.  So I'd like to ask
> > how to alter page->pp to avoid accessing @pp through struct page
> > directly.  Does the following change work?  Or can you suggest other
> > ways to achieve it?
> 
> @ring in this context is the Tx ring, but it's the Rx ring that has the
> page_pool pointer. Each Rx+Tx queue pair has 6 rings in total. You need
> the sub0/sub1 ring of the Rx queue from which the page came here.

Thank you for the explanation.  I'd better make it in the following way
rather than modifying the unfamiliar code.  Looks fine?

	Byungchul
---
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index c2d7b67fec28..382573f35408 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -653,7 +653,7 @@ static void fbnic_clean_twq1(struct fbnic_napi_vector *nv, bool pp_allow_direct,
 				 FBNIC_TWD_TYPE_AL;
 		total_bytes += FIELD_GET(FBNIC_TWD_LEN_MASK, twd);
 
-		page_pool_put_page(page->pp, page, -1, pp_allow_direct);
+		page_pool_put_page(pp_page_to_nmdesc(page)->pp, page, -1, pp_allow_direct);
 next_desc:
 		head++;
 		head &= ring->size_mask;

> > diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
> > index b1e8ce89870f..95f158ba6fa2 100644
> > --- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
> > +++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
> > @@ -653,7 +653,7 @@ static void fbnic_clean_twq1(struct fbnic_napi_vector *nv, bool pp_allow_direct,
> >                                FBNIC_TWD_TYPE_AL;
> >               total_bytes += FIELD_GET(FBNIC_TWD_LEN_MASK, twd);
> >
> > -             page_pool_put_page(page->pp, page, -1, pp_allow_direct);
> > +             page_pool_put_page(ring->page_pool, page, -1, pp_allow_direct);
> >  next_desc:
> >               head++;
> >               head &= ring->size_mask;
> 

