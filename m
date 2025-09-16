Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 893EFCAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 14:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B72B58E000A; Tue, 16 Sep 2025 10:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B49C38E0002; Tue, 16 Sep 2025 10:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86A28E000A; Tue, 16 Sep 2025 10:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9191B8E0002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:37:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A89214019B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:37:30 +0000 (UTC)
X-FDA: 83895366660.02.5497260
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 857FE4000F
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:37:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZN1ct+08;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758033448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zm/y1D7s43WyhF0XeZWL5HSiuUb+YLhCe29XHDsKitM=;
	b=KKIG77zkMQtvf7u80fWx5ExHv4J4UNEJg9PGG9uPn8OkhOJ//cG8SHnb6p0lZJoeIqrg+d
	loPPhjGFPLJEeN1nxO/2fGPPpvvPhMIhh2j9KhOIpIaBfWhu2ILs21rku10r1ckJ/kUZFK
	zda8Lv3NxihE/vMk+yx3ksuALr2xt4U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZN1ct+08;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758033448; a=rsa-sha256;
	cv=none;
	b=yyVxMnBxe12SNVsVB3KW7L1+RUQ0Bt8z8Cak6MSg6hSSvnSY2xVodcj1geCJ2jsDO85RJe
	Q5LQMX379oRj8b3DnTmpuLYTG+P78hM1nCNtbTaK7VxjstnXB/tznTS66YRtH+b5BOIP3J
	dfNVjQtQ/5qGg2pcuPPJMGUbCttvMtA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E2061601DF;
	Tue, 16 Sep 2025 14:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74623C4CEEB;
	Tue, 16 Sep 2025 14:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758033447;
	bh=LgO5/yIM681jTrDMpq8xGFhrw1pnS2TvOssqGdcDUCI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZN1ct+08J2HGLhNlNLuFWoe5C1alwpgQhtMeSmLSwH9dlwRSe6s3/oXgwOLOzbBlQ
	 PXzXEd86PJ9ccKF0e8Qpla8hYUK4grbeGFjGSOb9K8AXPMkJLiDDIvnraAWyyYlZaA
	 3yMAqc6xK3vhvitPcAQ247EwtzG/RPw8JG3N7cbBJm57zZ3CBZ9lOulbeA1Px/h2s+
	 RXuYmEWymSRiUoLadgIGLtH40Jj6EH/zUUkJIw1tqvgnPAghpo+5BW2ZySzqHEAKRL
	 B+bEFypAX1aQFvcNUbgVJC88obupLOi9uZCERwx4xTeog6t+8o7/+21q5bc5zMdfTK
	 LwJLKBnL+qljg==
Date: Tue, 16 Sep 2025 17:37:19 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Chris Li <chrisl@kernel.org>,
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH] kho: make sure folio being restored is actually from KHO
Message-ID: <aMl2H3BLpH3xFCOw@kernel.org>
References: <20250910153443.95049-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910153443.95049-1-pratyush@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 857FE4000F
X-Stat-Signature: kuwecs89knu7qry1z5sj3g3awpuicfgs
X-HE-Tag: 1758033448-529257
X-HE-Meta: U2FsdGVkX18aDsh0SiOta7pi3SJ3EU0jM5U/spZIfxDmfrLFM16xmI+AQhdt/1QM+ORqCeweGg1vqKoMPKla/SAfFa30du6ADdHRsLqyr1nQV1TNcZdRAnizt2lSEamLZo1PpdrZXL9eJOvxPXWAG6SnIk2ry84GRN2uUO+4RsO0A2FSLvh52HYlM4D8+MkMAZg7H6wIbudSkxdEmjpJ+AuI/YGgENN71Cp6FgrjdxL+IyC8ppP3sR9dBQ1g8zPQgu4ohnxNFQ5K9rUvLKoOZN1w/cUKKXMZnOcijp+CeMvKTUnhETLWYJIo7oGAwih7mwvVI+C48rKr9WCBuT9aCVEyw9KIta+PCHlThMXeVyQMrqaV8kJrC9AYEMXWslOsGZDY2gr+WEfFgn0LS5NB9o2pRzNNO4G4th5g0CWHH/ijRiQRV4iJNbGsgC2+FPnXhga/3SLXo+fo+sSjBz0PCarIxSaezeLIqCV99+UEPpc6doMeMm1Asg6z0Lccc24n5bAKGYOpTMO+FRC9Zd7ut3OorvD3PdQXSf86ocmFtGWIrloMzm6bDGl1HFplQbx3vaybpYQC22hKrvfK94ypjUjqik5gi0zWLTZn8AB+VnAJxlzV9SPzfRXtxrDOVQp5VlrLp+F4qrhPHZZ4y2iJxYH2wNHUSnvz/oOlLrqJpPfBE5voNRrikKAYOfwWP5ht5mFKhMaBfAsFVbaW0Ro1BeHVjNv58gdeBJl3vh72hInE+57vTzVE4HXuhgm5NYeScxrdtMyNrT8NoCmatsLsRtzGq+XYWJbYKRZieoszX5b87fGTLxLJ1FCjqB42NZnJUDXmtXFKAdShB/333+Jq4rrKZXY8keEsdloi2xscK/HW4+6HDg2i1DPZivt+u0jmZHcl/88RDTn91qPuSiS4yRGW8O/bqj5lpf/LpKy8yVsJ4IkEt3+Dmdeh+Vio/VyJIMD+bryau2KneGz7b6u
 skz6g6Wf
 WRcQWRGosGplUX25Sev8tY6aPumZF0m6h1wCGLVbOcV9Hc0iMYgdWvvKpPTK1z3Z3U1B64un+ClnkRxlmffVyypsn5KHByv6tAJ8b43E9v+LZT8EL/p8EMV096K8ImlXx/cWKAL5r91RffqnBbJdwqn9IexpF7cruKyVmls+rUoMIOFeMbti7LQjfgIS6oi35Dv2jBKIZ2etgLwPTFzR8kz5IFnQuzBKt8uVuDHsCujVaP0Y2CGlmJ5d5UI/uEo/HU4QWC2Fk2JvkUAZtRWQt2gZdng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 05:34:40PM +0200, Pratyush Yadav wrote:
> When restoring a folio using kho_restore_folio(), no sanity checks are
> done to make sure the folio actually came from a kexec handover. The
> caller is trusted to pass in the right address. If the caller has a bug
> and passes in a wrong address, an in-use folio might be "restored" and
> returned, causing all sorts of memory corruption.
> 
> Harden the folio restore logic by stashing in a magic number in
> page->private along with the folio order. If the magic number does not
> match, the folio won't be touched. page->private is an unsigned long.
> The union kho_page_info splits it into two parts, with one holding the
> order and the other holding the magic number.

I think the sanity checks belongs to the core kho_restore_page() function
and kho_restore_folio() should be a thin wrapper for that, at least until
we'd need to allocate struct folio there.
 
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
> ---
>  kernel/kexec_handover.c | 29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)

-- 
Sincerely yours,
Mike.

