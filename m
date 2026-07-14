Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F6B9C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 05:06:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D996B009B; Tue, 14 Jul 2026 01:06:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91EB46B009F; Tue, 14 Jul 2026 01:06:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 833F66B00A2; Tue, 14 Jul 2026 01:06:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56F226B009B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:06:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9BDE4160268
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:06:56 +0000 (UTC)
X-FDA: 84986197632.24.9F85613
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf26.hostedemail.com (Postfix) with ESMTP id C588A14000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:06:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf26.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784005615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cil6ibnzSChTysBJVExVRrdSVE+bXTPf+rUGgc9AyrA=;
	b=6qqkdcMp2vg1m/NG5dpU1ZXkBq+RDBq0orOe7Y+lXs16D0Rebucbc+CXX2lFxSkBckUoAn
	CTa/px5dIVRU8s7mLce72cE39wzdJ8GaI3eWK4BeI8DnqIjaCqyfRuQLmoywRupOm7YRim
	blpyat4nrLJ+y7MjaKYIYYy77DD4SE4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf26.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784005615;
	b=3SdJr2mXGPxIM21plapLfo6/egA2yKfI4kkjv/DG32wvN/NbkSrtttlIa+rHyc1uSRmbyt
	R1GapimgmqtqORc/MARW16hcgViK/bdAhZZdjJuVfTK8USBwv2urA1Dkz7f5roytuTfI0E
	Wzc2adIerumWvHMWlrWq/H/RXoqYQYU=
Received: by verein.lst.de (Postfix, from userid 2407)
	id DDFCE68BFE; Tue, 14 Jul 2026 07:06:49 +0200 (CEST)
Date: Tue, 14 Jul 2026 07:06:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
	chrisl@kernel.org, usama.arif@linux.dev, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/7] mm/swap: introduce struct swap_io_ctx
Message-ID: <20260714050649.GA31523@lst.de>
References: <20260713093350.2154226-1-hch@lst.de> <20260713093350.2154226-3-hch@lst.de> <alWQMssVSvO8Zp1U@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alWQMssVSvO8Zp1U@MiWiFi-R3L-srv>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: wer9836s94zu4e67b3a7n7rzrrx1kdp8
X-Rspamd-Queue-Id: C588A14000B
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784005614-981964
X-HE-Meta: U2FsdGVkX1+8eCDROqMXDoTdnxQA5/L4cg8cuKReWUw72obuaOBwOfz2Ry5cNSHsdjiE6KGRcFn6T4jPTJ11048BmDI3kYS7to6C9YE/CbeKepA+agtIl3I/iwo1hRFNb4iY+8ixdMQeYDHFD+uCRc/gVOLzUBvGrELjeh4pshbXg+Mlu9BWMTwnkSIA2noWWX2zfhDq55KOo1fzl5XSufPzEbPR2I/Ol8bV4PJ/B/9Qg2xP9N7pKY88ZCphTQNf31YXUOFCB4WeZKZN3udqrhboY6ZNnDnUSnq6El2Hzi8oBUKvWT6yuLS0Xvx9T5Mp2xrNH678nqMDtDxwbO53NkIKEFw/BoYz8MUPzmr30+p9boGjJH42R1ro/zecdBkEHeoGO6e0iBrvatq4lIaxNCVldGCW/siZyU/XoScgSPMOPAoSlbD22RVIkuIsD641CgWVw3v5cneRy3zwBfjCW56KQYn9Zl1obICMtnSRKUUJ/YJsFCNpkTsj/oWUt3MzaMCg+0KgrUv6HwVieoVKtb8dkxC4SRokspnHv223oxhQHXmsH676pfjA1jBBStVfknUPSbdH/1XKi7lVMnu+iMufgmdawErHaGNQ6RBq8VFGS0AihW4aC35vKKM7Gy6oyJbQ7I5+u2s6+3ccKs6QVZDs4k3uJEdz09q94sglWyineu8dhdMS34HugW2cT7oTMj/1u3bwC6kpJTcE0uYoYnDQMEVH1eFtmADMU1l2188RhBbRlyF0ldwd6BwbHCLcFF7RQZH43v7wbgeL6YPh3c73pFXa7z6XcWYGtQDe1q/glKlT/eY5VN14WrNAgRGJMfUqtxe5r24VM25/hKIvOltbQZd9OUSU/NMCLGUV7toNTN6H8XyzrXDDyR5xPx1fGvEoEcaDWHZnDz0no4BXEZOIaBdkE2cofQM5fNeAEiOIhHBvHhEbDstn/HSVBZEzmL/bB3h3uWy4nTNjPi9
 blNAqmel
 1Scp0gjdFg7//N/3j/LGySBZ+7sICL9LCIBrMVBU5oLP+vNCZu/E9OoxgEXZP4uVt7ppf2gEPrXeyIOokwhYuTYLotkMWfwpfoRfZeubKVgu0ChzvJdAgEiaAPzvGn5EUX8tZcVMCjvPHnfDzngEnWqSx0qiZsms5rSI/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 09:26:10AM +0800, Baoquan He wrote:
> Hi Chrisoph,
> 
> On 07/13/26 at 11:33am, Christoph Hellwig wrote:
> ......snip...
> > @@ -212,15 +212,15 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
> >  		pte_unmap_unlock(ptep, ptl);
> >  		ptep = NULL;
> >  
> > -		folio = read_swap_cache_async(entry, GFP_HIGHUSER_MOVABLE,
> > -					     vma, addr, &splug);
> > +		folio = read_swap_cache_async(&ctx, entry, GFP_HIGHUSER_MOVABLE,
> > +					vma, addr);
> 
> Could you please help answer the question in v2?
> https://lore.kernel.org/all/aiFaWmCWgEWAFj4W@MiWiFi-R3L-srv/T/#u
> 
> It's not clear to me why ctx need be put at the 1st parameter. And if
> only replace &splug with &ctx, there will be one less line of code
> change, and this applies to other places of change.

It is not needed, but passing a context as the first argument is a common
and good convention.


