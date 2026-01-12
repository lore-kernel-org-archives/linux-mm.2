Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10366D2502E
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 03:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 324166B0088; Sun, 11 Jan 2026 22:29:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7766B0089; Sun, 11 Jan 2026 22:29:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A6856B008A; Sun, 11 Jan 2026 22:29:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 04B046B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 22:29:16 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AA56D5FB81
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 03:29:15 +0000 (UTC)
X-FDA: 84321881070.19.498651C
Received: from out28-73.mail.aliyun.com (out28-73.mail.aliyun.com [115.124.28.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 77A94A0007
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 03:29:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=antgroup.com header.s=default header.b=pg2SLIqr;
	spf=pass (imf15.hostedemail.com: domain of houwenlong.hwl@antgroup.com designates 115.124.28.73 as permitted sender) smtp.mailfrom=houwenlong.hwl@antgroup.com;
	dmarc=pass (policy=quarantine) header.from=antgroup.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768188554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qSGPjdxhk3/aWqe+xkuM6uIoGLfzd0PvSndY5oHIw6M=;
	b=pRTMRVKkkDbKUriqnG4m2YGA7+wKCY1lT0X89HoH4cb6ugcmDaymrs/+wRszyiRBFf7G1W
	9tt1np6kl18poQ3lOZjy544EDStAgZmxQKhelZJp3PlteWOBiz5VAXIMgs1XKpPcAnFB2Y
	nEuOgDlKbwKzRebiXzx8TEw3ccKbdI8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768188554; a=rsa-sha256;
	cv=none;
	b=ElsxMd1WkB1b7ybcVGrmotxTjxsN5HyEgZ01X2r7vsvON1ovb9nwZbsp+DeJ9YigM6roOu
	YTWkDoyRbwshi1H94DxdJ7vkwCi2Ussp/sseZz0PYGzWdALGDUB15PPUyMqDkCTrrLBg+g
	p0cdmlHygXReU39ZqxhGIPBqpjJdmyk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=antgroup.com header.s=default header.b=pg2SLIqr;
	spf=pass (imf15.hostedemail.com: domain of houwenlong.hwl@antgroup.com designates 115.124.28.73 as permitted sender) smtp.mailfrom=houwenlong.hwl@antgroup.com;
	dmarc=pass (policy=quarantine) header.from=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1768188549; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=qSGPjdxhk3/aWqe+xkuM6uIoGLfzd0PvSndY5oHIw6M=;
	b=pg2SLIqrwGKiSGHSWq6wIfzXuVnf69rqWZg/ASLozrMIE58S8BMVCK9zuT1D+GgUsc6cmmvMCwsaEdSoqjWPXU74u/7UTb4ShnOuvNaRpXf3q/5HtNyAF4iHtk7FqZtpaCz/+nTRZWc8NnOmyloIrt9O1VKUvcBYbp8o11TtMoA=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.g44jfNX_1768188547 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 12 Jan 2026 11:29:07 +0800
Date: Mon, 12 Jan 2026 11:29:07 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/early_ioremap: Print the starting physical address in
 __early_ioremap()
Message-ID: <20260112032907.GA60059@k08j02272.eu95sqa>
References: <aa2d44c34f44c31b50285b7592ed4fd78d6f59ba.1767965415.git.houwenlong.hwl@antgroup.com>
 <20260110155721.84af2e403badeeb29c7734e3@linux-foundation.org>
 <aWNqQd3CVx8Z_KFB@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWNqQd3CVx8Z_KFB@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 77A94A0007
X-Rspam-User: 
X-Stat-Signature: fqcbxfn9neh7pxe5hofoi1b1basbr7jx
X-HE-Tag: 1768188552-120766
X-HE-Meta: U2FsdGVkX1/r2KVDjICbqR/QZj6PJhp8wyjFv0k1RGFB0Bz8qZ9iwlg6Gsm+vjwP0pMEpS7BVYWab9sfhpIUxT4Gs0Pa29hoM0C8UTA6e9ZYh2I6cZnyGvguaqF88GHrt//YkGJRITyJlK+9cgGOLd+Qj3sslqAkvhSS8SJf5Wr1u747fBAEpRsi2rqXarvSPNMjPQCrF1DV3vRUbs77Lj8WBBKQESHIkp1VHbqb+/VbyrBNlJLRHFnEdoaH3Y57/Z6G7V2PxzjRGLOuVDny5pb2el5IkPxNopNPSU9pvt6WUAIeE4A/x+h4iVFZEqapBkt6j5uXlFh2HYzF21xIl1o8KoFHhF1adBq10Z3cKQjt55XXan+WgI4+qxr5IqwxUEEvvTJ96GHMVbAqov2KofPNWENa6PKcqdXHgr0vPYmNbMe7ZbrLUlZc7c2gxxojqycEyl1XXuG+1xxa/pHX90/t05eoHMYuRV/jIjGMlv32WEPm9ie21Z9GdJddsGzazzKwHHQ+ut7JdjCobgc6sEITdxM/Is304+NGezWYj7OdmDLrFfx5uZL0dcjdr8+T0agfYwOY614eB5MXk90DdvjaFMtHbcun6/KGQBeaaf0qv/wph5s+aALj7GRQAReBuOkFLwNLtx/OmOjGopjwRVPSb+1Sl6+q80sPC5Rr4B7GpW2lPUcC0PXSIlV5fllo+cjRrmC+VDB5aDkWuDcn0huA2OG9nmLSn5nJpwr5d2WgbZDVW9IrhCggrmsKGxA4NRytl2IGCUMANOcuWPYIK8xoIS6QvjdG7lpszt359EBsILbQo1E3uyBGzPpq27tnFC08awYpi8qo/6dhhTlvHVOIKRdorgy/cbZ+9p//PjehZfbNuFg5Z+ltqbnxL3/xangg96NXvOlWQPQo2vuQEt+yUwAnahloFCbPOSO3wx18tPJW96Rm154lLyci28Sj5Ut8YFYsq/fzcZvRguL
 GmSebCM0
 UQTVtf1clZg/wiVWw3n9AO1h4hm0wiX9ERR1V3KkiCYjWsWQ8qMKeDfbxl6YzDGxB/Xw77Y1JrwKgL3qd+pp51RvAOudPAqGwVAClJdCo0ZP4JF2Y1lBj5A2/Dbzm31gJLV8v8STqQYnmfjoeCd7jG2QgvKj65n90rGoDck7CpoPcNV/Xw5pgxWChA7CWrF/hpzFp95AGmC9Dgcf/RCWxqaXXgJ6QL/OUpf3c9fmg4ZtZf/IwVmub88561hwOCM6mYS3XBBx/pIou0znAv9OzBvab61+ZhKOfmXIiZnB/fpgavnl+CSMTuqrmK3DCCE5rAY7ONTzVP5+J6JZnDfTAgngM1QXsRLAsDNrgIyT6+DLwOpzUsPXUtmtCzKjefe0uAFjA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 11, 2026 at 11:15:45AM +0200, Mike Rapoport wrote:
> On Sat, Jan 10, 2026 at 03:57:21PM -0800, Andrew Morton wrote:
> > On Fri,  9 Jan 2026 21:31:51 +0800 Hou Wenlong <houwenlong.hwl@antgroup.com> wrote:
> > 
> > > The debug WARN() printing occurs after the while loop, so the
> > > 'phys_addr' reflects the last physical address rather than the actual
> > > starting physical address, which is not useful for debugging. To
> > > simplify, the WARN() statement could be moved up before the loop instead
> > > of introducing a new variable to record the original 'phys_addr' value.
> > > Additionally, swap the print order of 'slot_virt[slot]' and 'offset', as
> > > this will enhance output readability.
> > > 
> > 
> > yep, thanks.
> > 
> > > --- a/mm/early_ioremap.c
> > > +++ b/mm/early_ioremap.c
> > > @@ -139,6 +139,9 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
> > >  	if (WARN_ON(nrpages > NR_FIX_BTMAPS))
> > >  		return NULL;
> > >  
> > > +	WARN(early_ioremap_debug, "%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
> > > +	     __func__, &phys_addr, size, slot, slot_virt[slot], offset);
> > > +
> > >  	/*
> > >  	 * Ok, go for it..
> > >  	 */
> > > @@ -152,8 +155,6 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
> > >  		--idx;
> > >  		--nrpages;
> > >  	}
> > > -	WARN(early_ioremap_debug, "%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
> > > -	     __func__, &phys_addr, size, slot, offset, slot_virt[slot]);
> > 
> > It's strange that this code uses WARN when nothing is wrong.  The rest
> > of the function uses WARN appropriately.  But that's off-topic!
> 
> It seems an historic thing. A nice cleanup would be to replace
> WARN(early_ioremap_debug) with pr_warn() + dump_stack().
>
Yes, I see that the initial code uses WARN(), so I didn't change it, as
cleanup is a separate concern and may not be well-received. However, I
can make the change as you suggested.

Thanks!

> > Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> > 
> 
> -- 
> Sincerely yours,
> Mike.

