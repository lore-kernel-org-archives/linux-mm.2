Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B491D39422
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 13:32:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE34C6B008A; Thu,  2 Apr 2026 09:32:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B944B6B008C; Thu,  2 Apr 2026 09:32:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82FC6B0092; Thu,  2 Apr 2026 09:32:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9664F6B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:32:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D2CA16065C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:32:50 +0000 (UTC)
X-FDA: 84613706100.28.48C9994
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2595240014
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:32:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=e+oVS+QZ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of sumit.semwal@linaro.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=sumit.semwal@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775136768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nsx2hYjw+sV8/0qohJ1DlKPwBoo2zkp1J5PdzUN8MV4=;
	b=OS9GnTokvckXxOnhT92maT6g7ywH8OpIpW+F7QGPYuY+buwTNFGo5gKiYRdhI2dTZTOWG7
	D/HwHwzM5uo6xPulCWQGjaXr2Ovc/yhlSnnDE/BFJKpbK7ZNByslBWiMBPT8RGGhkHzL1Q
	rdAoV1JtUxta1bbFS+XsRap+FXDc/Tw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775136768; a=rsa-sha256;
	cv=pass;
	b=1X9+mVhMaXjLQzTi2a1YDD/evAh0YuWhU3ANK5MPxf2AdhOKPGfF0kpXLD5xF+R6bfNy81
	Zf7emNxasSx34GmL246drHgl0zHLCvrw0ZwdyEg8RUsrQrT4PZNiqnUSFoJgg4UQMbYLlo
	xb6/+WEWIMhiDKvCWZ4b+U1/PwSw4C0=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=e+oVS+QZ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of sumit.semwal@linaro.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=sumit.semwal@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b9358dd7f79so168686266b.1
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 06:32:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775136766; cv=none;
        d=google.com; s=arc-20240605;
        b=EArxWWBPX1puFQ8cnTeZ5GnuxwHnTYk2ez/cVsncJgbPMTtmAqbtV6Cob1SuPpH6yh
         VN0G92bqncv9i9NzfPc3E3RP7HP5wMnlG64tfNNv3eK56YVPUvlwMeBcsdrkpVGvdYRG
         fYRSsWc1Aqw+MypUpy0SaVxmf57U0YVSLCl4nv+XnocWOAGVRMI5QYbeUAbv0HSmWJbV
         BAHXksQ5rDsl/O3TNr2HeDtLBlM08sboyV4U2ftu/0zSoUv2E+Vu6zC8AgFYlY7OWy2p
         0xYKKBmLHg1hOmnRP4ZKWL2cci/TQltkkXzUW+QIwyj5p9pWZMh2zP3+7GHG+dcgeux7
         O+bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=nsx2hYjw+sV8/0qohJ1DlKPwBoo2zkp1J5PdzUN8MV4=;
        fh=as/MkIjXAqTBak9ydfmlQumAPpesLAVhEH5jqSf0kb0=;
        b=EHSDgZwsP/jTOUMVXMPhvoVSZYuaI0hfI4KiBrcKea1Li892QQJVJqOTSRuEYvG3hS
         8Sqz+4TQnDmzm7uP21X4WKiir0A2t7LMhT8gtfwOqUk0gQ8p9Z+phIafJA4X/L8MZnCK
         y+R5Sj/zvDCKbfNnwiNOkAQkhOWyr+EF2DnGgEEdr/zNzPjZnzp6RkZn1rd2d0XUlpB2
         zL5DzHZ65vjHC1u35CZfe53BejqhL5FktF5Jdm/xzjSU3WiFWv72Wxbrs3fqzzrAwffw
         x7ZXvUoCGDTRL3LyUF6EYxQJaG36iYhiUlEldA9zXpWPMA29sF/MTzt2FweSAlwt0hZe
         LC4w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1775136766; x=1775741566; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nsx2hYjw+sV8/0qohJ1DlKPwBoo2zkp1J5PdzUN8MV4=;
        b=e+oVS+QZbW4SznNMJFAZ/6Lp5Y78PXJj0dEkahCKJ49OTwWcW5TdwwCgpO8i0RPdvl
         DHeD7Al+DIB1MbqyIb9rTBlor9tNcJ9Rv5npvbvnZTW9X8/6GMWyypyez4oAA6wTNvTU
         ftWuSgvwDvzCYM232KbPZtXjCWvZftdI4gAVTldcrFSOu5fRD75N1DHZC7vqt8thD5pd
         yYMBJ+v5D0Bjt9E0UvCPqkgAt46U8QPckfSW+kdTsdt+E0ylrZcPYIHK0ZRPKtsuXj7Z
         AeQXHZOWrH/8EEYBRhQOXVoacGfK+AnlPUZjJLpZWA/LrVsOGwpyJdeHdvfnGm4R/ZM6
         w7OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775136766; x=1775741566;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nsx2hYjw+sV8/0qohJ1DlKPwBoo2zkp1J5PdzUN8MV4=;
        b=TL2tBvxBwVA2kKQ/ZbnWe0zjDlqtKlz8nPi7WLHzqY/NBPytecCLVMOPVrmnPbaYob
         l3OJFVulPFe5An6xp9HTRyBApw83FQQcyvGD49ryFlk+vTgwmsw+WRe5OJnjBkareZkd
         iBFWC/DXd0QPV+UlljBniun90hSg/jQFoTaHSs1ppmvOIU7rveYBzdl8oOEq7gaNvkob
         y1r2fCQN+1lUZziKCK5oPhiomWpvrHvGLVgA3rHejR0c8a1I3qmO4lN+yhrD0rH0kvbr
         jYY7my4zsH0x9SipMw8Orcmwf/i1742WjEfPVRcmKPVaPPd1b/aQCDzVzfTm75v6oc25
         Du+g==
X-Forwarded-Encrypted: i=1; AJvYcCWNYj/ScEu2j5/pgFSjFtE8PWbNeR7ZYFAsINz3uM2MezZq7V+8loiOh+iKDnPT58dqivc8dLCvig==@kvack.org
X-Gm-Message-State: AOJu0YxfIUACAEDCVl+f4W/IrViQZMZYY6sXEA90rWwZi1mKgsFFJKuC
	tyT2b6EMNMPMCWuPjYlZ/fY22p5LkVfNSyIJ7TK15R0gtFpcnZFZaW5ZldguTt3IGvVngeBXbt7
	6hJXubIwlHfsR7LeJC2t8+JjgIiIn/vjhnOKN3kIkMQ==
X-Gm-Gg: ATEYQzxQ/bfJCHSkSnPDnf7hChKww2tBHMPwHHPmiPQ7DbC4FAvI7c9vtRCQZnuiXgM
	KJbW+GLA/cy9sXHUXvovb+A7e/V1PZc61e8H0CWnMjHgL1TZ9iHEJmWqak1Wj9Egni1z/kYfmEC
	esTF6oRlLaqN5ejbjjQdhDP71dv6YI+Rr3UY13e7bP/N6oht8ZDtmgzpmMWUZ5XyutxXcG9FE6b
	NdnpqWoaqIXi62D0P37FeYTuBoWDrAtZEFqkXDni2LtErwdUdsWe0Z6pEQZZPp6bx0zGORJiQAn
	7KkzwLY=
X-Received: by 2002:a17:906:4912:b0:b98:695:ec53 with SMTP id
 a640c23a62f3a-b9c138c110amr392586266b.18.1775136766273; Thu, 02 Apr 2026
 06:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20260331100026eucas1p19bdc2aaca4c9a48c6f6ac8fec71478d8@eucas1p1.samsung.com>
 <20260331-dma-buf-heaps-as-modules-v4-0-e18fda504419@kernel.org>
 <46397de2-eedf-4e09-a83a-3b683d154fe7@samsung.com> <CAO_48GEFQE_FJjuq1UqP=DC6LJE8jjE3C+4FdAyB4uEZDsnFJw@mail.gmail.com>
 <20260402-burrowing-fine-bloodhound-afcebc@houat>
In-Reply-To: <20260402-burrowing-fine-bloodhound-afcebc@houat>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 2 Apr 2026 19:02:34 +0530
X-Gm-Features: AQROBzBU7_o7IRQH6mzOKTP-KDFv7IkPoqq1yaLRTD3AfvGaKguQAkczWk5rypY
Message-ID: <CAO_48GHzMpKHQxmS9ADd_Z9G56uWOPfJ-qhNek7ubgkk_yjGDg@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] dma-buf: heaps: Turn heaps into modules
To: Maxime Ripard <mripard@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Albert Esteve <aesteve@redhat.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2595240014
X-Stat-Signature: mjayiar6tubkcak787nn67gmoq5195ay
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775136767-319398
X-HE-Meta: U2FsdGVkX1/loyZmAl5V83sJTw/rHhPu8zYDkxWwMuGnXpgwInf3lzCHFP3tbs0rcB+B8pQaGcm6vYcv73Y9zxOsVkwf0Y9aT/cSF3HC7nlPPbH+RykK3fDFj3F17T4Rzao4IAAeVIdmkvg65iQlN4ynBEWMVxcI2qqD0/XH9WY9jOEOtppwsfB6MOypKSskS+PzQhNBAxcHbkWYoWYHkaHOo9lemT0gPv+Xaf13/8NzfWIluu1nmFxFE/nLbWGC+LDOfeDgtwngivMRCsCSdet4MR2eZ9CE3yhYsyx7DjQyODussp/JgueNx/saHtVOTujNQCGtmAx0g7DccrVn0SCPU1ENG8PT6+QGAAt5AHoJ7gTo6HvBcxkfWIZYbVvym6zMTxG3qkXOpQlQ5toivPC3g2X7w8kNUL6Uc2u85jnVSvuHgHx+XJA25M37oYuDyW8jwvyyLUhsmzIH9rIO9H7vhMdCFBcocmddKfxKlOTlYkwGk8NDHqYhI0/9IoFig0/oTSro/wWHhYFtG8ZkXqND4jx8vBk+aY7pJBqM8q4cAFPlPTeVk4dqz4DR7toXk0cUZ4kkdr4FVxcAEfGr6rw0xBBs092DtEq5a7Tw9/uzzqhRCEj6wKQeb5v2jNV2s+1gwdVLowjq4H4f/AzTNua2KZRydEP2AiHUvkdZ+7uASttwkT93a5FrGRm87S9ugqiS9IpWIvhhVDUWWq/Owbk/ILTHVAlAR0pz3hXvxOiOkK9rM0fbyFzsEfCAlvk3loF2X75JJc4aHISUPUvWDASMZLtiSlT+pRMHGvmeSkSlY2/DyjyZj3PfRkjN7wAQPaL8Xrs+YaeXh4TLkg5JuIx1RLGgSbgMK0Ao65Jgae+f5Y4XDgCP6LY6bOMY1sd+Sgftg0HYIYffhaq6FixAWMHhNC5jSwI13OyWEPPf9FD13hwPGxAzCax8S4M/nwCBuszedGRMcw++Ix9IZ5D
 Hp1Wz/nt
 0Un7Pkaq6uW3tOwrHpKRcXtbtJ+TIHJdU/rqgOUainBPfagvU791/vRHNManePwTOGLM3W/ebVt5S26bQ6SzCuqy8Haoi/ZMGp3FwQn416r4v++BS9vs3Jo80CXmNmVXg55heNyGVhtAyOAUApwdYpNPeETb4NkB54p3YulYIuu8iJqAuIIgmW4Tdbkn1FO3bd9zNQ+0XTjnoum9Zmk7epDPhVnz5vY6pto6jndaX4gT40nbP0ogZbxJfjONatyjOlwCGZ9NYFpWbDiKQzjM3Zz5uHLojEPY0X3jELIGufimMfvb268dOC6djUyR5RAcgD+bl1Gv6jIrFYu0l1xCb12HBOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Maxime,

On Thu, 2 Apr 2026 at 18:42, Maxime Ripard <mripard@kernel.org> wrote:
>
> On Thu, Apr 02, 2026 at 10:36:48AM +0530, Sumit Semwal wrote:
> > Hello Maxime,
> >
> > On Tue, 31 Mar 2026 at 18:24, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> > >
> > > On 31.03.2026 12:00, Maxime Ripard wrote:
> > > > The recent introduction of heaps in the optee driver [1] made possible
> > > > the creation of heaps as modules.
> > > >
> > > > It's generally a good idea if possible, including for the already
> > > > existing system and CMA heaps.
> > > >
> > > > The system one is pretty trivial, the CMA one is a bit more involved,
> > > > especially since we have a call from kernel/dma/contiguous.c to the CMA
> > > > heap code. This was solved by turning the logic around and making the
> > > > CMA heap call into the contiguous DMA code.
> > > >
> > > > Let me know what you think,
> > > > Maxime
> > > >
> > > > 1: https://lore.kernel.org/dri-devel/20250911135007.1275833-4-jens.wiklander@linaro.org/
> > > >
> > > > Signed-off-by: Maxime Ripard <mripard@kernel.org>
> >
> > Thank you for this patch series; now that it is needed by more folks,
> > I think we can merge this.
> >
> > Marek, I'll coordinate with you on this - thank you!
>
> If Marek plans on sending it during the next merge window, maybe the
> best thing to do for us is just to wait for -rc1 and apply the rest of
> the patches. Otherwise, we can merge the branch in drm-misc.

We could do that. Are we ok to wait till -rc1?
>
> Maxime

Best,
Sumit

