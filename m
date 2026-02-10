Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DC14E94626
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 01:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7DE26B0005; Mon,  9 Feb 2026 20:34:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B010C6B0088; Mon,  9 Feb 2026 20:34:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0D456B0089; Mon,  9 Feb 2026 20:34:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EA0D6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 20:34:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C64813A9E2
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 01:34:50 +0000 (UTC)
X-FDA: 84426827940.24.578E2DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6DD68180009
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 01:34:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2n4Qvnv3;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770687288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ibsmmNgtHVgGF5VxdsiZ9xT0EmCVs8D2/ureK6LnfEY=;
	b=kowiU53Ss7eK/MsyacT+p+G5+1QT1QWYpPlsMLtAMLcAtI2J1m1AzN7o+3sXbMR3SmZDVY
	b9rZiK3eKBrK0uMbsXB+QQn+N4q9IXzBM1A6SkSUhkgf+8vHAcmdP7Y2rspGVeRnOEXmkD
	a+5wakUNvhZhAtgvtN2Bzv71qtzhoks=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2n4Qvnv3;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770687288; a=rsa-sha256;
	cv=none;
	b=a+0fGtEfgFGDAE7IW5GqpT+CUXWRGB2gYHP4j5/r+c1/gh/IaonIDsD4Q7242QZap0M4wN
	59Ig2t7UDlYkrPzAxM+KjL+3xkfFa6DzgJVUUTptLopYGdzvHNWlD5W9WxPHXGH5Kjbyim
	/MLqy8JBsp4YBdiGhPJ8wAdMRF8fP0s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F2CE60008;
	Tue, 10 Feb 2026 01:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F5BC116C6;
	Tue, 10 Feb 2026 01:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770687287;
	bh=T/HCmpcNqFcFD7xZ86y+ZqO8jXnLnbpyYwBENPJl2eI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2n4Qvnv3dtojiMggwW254KgxnSn9CjO1dUWy3GOSer8V7sbAUuJUTPUZ4qine7txY
	 V0v6T4Ggpk2LSpnLqB0OWN7YCvMGMU4/BzUzjxpvxFWoZLP+xlzPqjvxQstWW9Gw/O
	 Yq/kTGRQ24+XqR4ouSD4ZmCR29P6yO2J3fgcgqNA=
Date: Mon, 9 Feb 2026 17:34:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
Cc: intel-xe@lists.freedesktop.org, Alistair Popple <apopple@nvidia.com>,
 Ralph Campbell <rcampbell@nvidia.com>, Christoph Hellwig <hch@lst.de>,
 Jason Gunthorpe <jgg@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon
 Romanovsky <leon@kernel.org>, Matthew Brost <matthew.brost@intel.com>, John
 Hubbard <jhubbard@nvidia.com>, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] mm: Fix a hmm_range_fault() livelock / starvation
 problem
Message-Id: <20260209173446.b76547c4028132f71de1b8eb@linux-foundation.org>
In-Reply-To: <89cb1d4744789702cd80dba8eb40dd50bf053b4e.camel@linux.intel.com>
References: <20260205111028.200506-1-thomas.hellstrom@linux.intel.com>
	<89cb1d4744789702cd80dba8eb40dd50bf053b4e.camel@linux.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6DD68180009
X-Stat-Signature: gciaojeuipeqczg3wzcqyf6773jrw43r
X-Rspam-User: 
X-HE-Tag: 1770687288-770973
X-HE-Meta: U2FsdGVkX18eCkjxBDlnjG6SpjNQBUC50kLaCa3KSrIonwnLgnQDjAAmDFzmvyT6kBkmPjrMkZmKrY63SDzNQ0SAu1IFQlaeYSXAHLkZ1T3gclGr+FDUk+YD2SnqlweJ8kMB/paGNAZlwkpiRF29tIFv4q2izXqY95E0zHpXaWvkkmsTMCnIiSW7XXnzeut3K2cLSuS7WyBCvvyXNY2A4Tn3h6JaIvcMDF9Td17VkVu8N0xVZdRnJ0kr3i4lL7JvrgVgKwY/SXBElEulXMOoshN1Jk/Jyb98hc88ZX+j4eGuq+Tv3c5+zkDkxnqC2R+HjFcPHQQyIirZ3Edv2Odbb9oIfftQZXC1vx+Bbisr4hMKnPz2zJj4ujq2/IErufXJWyyU31Rcy308+oRbFh4mvBv3uOq4wvQquBWNQU5u0XbhkQlWxOM5JQv2RmZDDFy3UyKex2HIAvmGfywvj+5UYTKCpX/LgJJCD8wmF5jhUDBKegdLxI3JCmPZbq6yNPgTcbIDhSCf9oIwbKgI8fxvFv+JKFjij1pWZFnxkDE0RpMoZHABcuAAzYJ377/badspM4vF/9UNRC22md/+lSIE35fuJw/xXIE4g7lC0QkUmHOZxqKWGQrDKD+44Y3GZ2hsK1ltD3QrY4gQFL2uM0eHmcXmHwXunMQEc+3TW/g3OjBVj1OWpmjDKhmVByKE6wtqHD5UEqoSp+S5LEXSRK3F+nG/ZwiOE86UBQ1nTiCBUGOu8WOP8rR1YZmPV8WFL8DyCWb8jwSL0fhkjLM549gU3mZTCfBj8u954i2Hfcy5SN2D4Ck7Sz2n1Hu0rpMdJ+WJwuVwbO+hHfS1YtRgTOgQcyImOwcrVRc2CibOATkgY18Zirt/DFh54/lUsJI3v55gNlJouNWLMuD8WlL2EtWQig+LR/tOxUmRuBl0mhBeb6/i8wd1AhyicWV2LWsqMaP3cgsqaNVGr/TyLx7NxEF
 n0LYT1Li
 82byQAOeK+FXab1OrnQdfmx18WT+fiEcM+c9eTnOVLpu233O3C3c/6uSIYWK/aj2zaiMged2Y09dyk+5paPTpQA2lP42SiVXg89JiNW/DKgFP+q9qZ7fVbzfMVW/NZVbLduoH1Lv5rn+0xi79lLEKdDWS5JZSoUApOsiS3q780WbOBjinKZZcCtzBferg2swyelkh7yFTd/ZmE2eWVNSm6n+Yj7uPo/QaepPbq5lvy3a3rPdQDRzhh+vbGYCa4I+1vFcV1tc0GzQaSxNYoqxJ8GSIQ6STnCTprKmQZnOWOyLC7ixpqweZgjmSATRJKIuXHFyLwfKncPFMiN/DAE/U+5LUiH8HwVwNjqRZlSEKGoj4IAXksHPEKyb2V2GkxNfwDxWo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 09 Feb 2026 15:47:38 +0100 Thomas Hellstr=F6m <thomas.hellstrom@lin=
ux.intel.com> wrote:

> @Alistair, any chance of an R-B for the below version?

Yes please.

> @Andrew, will this go through the -mm tree or alternaltively an ack for
> merging through drm-xe-fixes?

Either works.  I'll grab a copy.  It you want to take this via drm then
I'll drop the mm.git copy once the drm tree's version appears in linux-next.

Acked-by: Andrew Morton <akpm@linux-foundation.org>

> > The lru_add_drain_all() function requires a short work-item

Pet peeve: s/the foo() function/foo()/g.  It's just as good!

> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4684,7 +4684,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> > =A0				unlock_page(vmf->page);
> > =A0				put_page(vmf->page);
> > =A0			} else {
> > -				pte_unmap_unlock(vmf->pte, vmf->ptl);
> > +				pte_unmap(vmf->pte);
> > +				softleaf_entry_wait_on_locked(entry, vmf->ptl);
> > =A0			}
> > =A0		} else if (softleaf_is_hwpoison(entry)) {
> > =A0			ret =3D VM_FAULT_HWPOISON;

So apart from the rename, this is the whole patch.  This got nicer!

