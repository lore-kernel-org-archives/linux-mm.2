Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1BDAC55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 09:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8BB6B008C; Fri, 31 Jul 2026 05:41:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9C26B0092; Fri, 31 Jul 2026 05:41:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDB1A6B0093; Fri, 31 Jul 2026 05:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CADEE6B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 05:41:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E25A1603AA
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:41:45 +0000 (UTC)
X-FDA: 85048579770.22.BE3265C
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 39CC040005
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:41:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OxPWSkfs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785490903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jgxl9CIQj6KttRa1KpmqjLcUf7cr/iCoTYx4L9S8blw=;
	b=45LZyrvTySBcEvIauKORx08Pr2/itDPgXoB+K6s/JWOz8DG6RY1ZBz4ay7ZCV2z/AzAFWe
	OAJggZ8wpan7gYxPAkTuaDYA+0zvbeQmMb3zwkfbbAV6vbwsnBk0XW3ENtry9NiNhgRhZr
	TCp7gFN+UyFMc4RSwY9W0eAOluEtZqE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OxPWSkfs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785490903;
	b=elUv6LS5kLbfgMv9j+dFP9QL92MTpLX4qZlZ1YWuA9S2MZUITcUZbgJ23WPU8Z+5WZETIi
	UqeUhYhT8qHz1yLZqPfy1VcMtYDZ9DERJ3DACZXjx9tyE+ChjxIEwmHPqE5ZCwP0sRfbXJ
	pI0vuluPgBZ1rI6VO4Ivb4w/eIwjJ/E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785490900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jgxl9CIQj6KttRa1KpmqjLcUf7cr/iCoTYx4L9S8blw=;
	b=OxPWSkfspY3uM75dNzMXC6xjyjOI4Bs9bAbnQqGjK7gWWpIQC2JpWVvU/gw2bX1cjSzmjc
	gb6sYVIdfp4EeWcNS6P6Nc0xfsjxwAeRnEQcJeqxcbfhMft3GOALuVI3Yd1kE5DlChSYiM
	DgDAMlRTiyVsZDt5xxAmIFvyTBXgKug=
From: Hongfu Li <hongfu.li@linux.dev>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	hongfu.li@linux.dev,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH v2 1/2] mm: Use a folio in the softleaf_is_device_private path
Date: Fri, 31 Jul 2026 17:40:54 +0800
Message-ID: <20260731094054.90791-1-hongfu.li@linux.dev>
In-Reply-To: <amdkR-gX_ABcKyCQ@lucifer>
References: <amdkR-gX_ABcKyCQ@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 39CC040005
X-Rspam-User: 
X-Stat-Signature: ypu95zhsrze6393uodxx9xcpgmkcc6pw
X-HE-Tag: 1785490903-103194
X-HE-Meta: U2FsdGVkX1/NHyoIQkpZnjsJQH+bjCKLfTcBeNCji2jIF/d7Afi6OyBjD5xhMggOUmGDJvj0/Hvq0eE1jSGBF+uf4aJ6tgzRqSfzDsMrdFU5mnV0fBSRplxX5oQQe2gGYacFULI3P8H/lRd5N47zcIyglcr0ZHKtRyRIIYhZXQEeRDLs/BLn+HbbXUU/CidVbObCQti3wW6nMDv3EfmHvCAP/f2jQ5gvDGx71VAjNmbUOGmEVnwOCGnvIoSBzqkF29rsyhG/nrQS9yLMtssflYrMqnckNhIpkgFxuNeOCkOeMeCKi4t6BkEWGXmcTLAndt359T/RW89QfX6WIQN9ttHKQrkCZ08aFLIcF8KVwAarQtHR8dvNq7Q7WUXyxvWZ79J15fqyJ+56vQl8r663QkcegAm08Cy1DrexyrVlI1bRMiYySZNuOgR7b/iQd9KnRptUQC2fAfym+QKX0qlY6+VQ1thWxHpwKeTalKTlkHl4be+lR4eA3ibpIvCuJX6GOwwYjVJ19AtoL/DoDnVZjYKmyXYJT4N2BzVE0BhUoCydmUs5p6Qsvk2cYIIUnO47J3/sg3O5MTAJ2pEIkQaKRkZQFG+nel7Bp6EnQIVkLtn9w3JKw1Hf/GnWJBpBB01SRP8QEiTG2h/aRfax+PwstzlDMFRow46IKkEVdV12ex3p34ZI5geJkCzciPvSHb/EVpWmWb3QBpMfhqhHP2cl6/32zUwQ1SKMbJgzXM55GNdSKKVjCh4zYTHIiErDW01xJHdF+AKp0fjiH3lgr+5XD8xA50WvkTt7cZvEZIhXvNtRc2Dgw5fGhoYtr87q4oHOZNK05BS+LhLJCLCf+ONh9MC3+GF6QgRzrcfFJZYje85u5rJrE7fqeHt/nog35zLKNpYkOg1fBWoSF90tM4U2wC3WmzaubskvbNMwK4uQea4vsAUFbHTWOksR1scsKktMPL1cD+drKql5s7SyjjX
 cCiDcpbP
 EAQil89TH0qbj6foKqW8hoFyXsWGgP8S8VgPFhqxXoqK3Fe6OIjNjMDxsymj/fA8pEIBuMacEZFL69CMwiIK477MS1sAQY5B54z85Oo/t4M4u/5aVjeqM9/uWgqGwaXdxK1EpVPjGeW1H9FLMhwMgr+J4oLuTuwIP+S1ppHjp43LTGSGe6CzwVETx3IVNU8EXxXjCjgTpCYYLUmngWSbpJOl8wfH5vEVw6hj5uSVrxzULHH4jNetI1TxpWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >  mm/memory.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index d5e87624f692..ae521baa8c84 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4871,18 +4871,19 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >  				goto unlock;
> >
> 
> Up here we have:
> 
> 			vmf->page = softleaf_to_page(entry);
> 			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
> 					vmf->address, &vmf->ptl);
> 			if (unlikely(!vmf->pte ||
> 				     !pte_same(ptep_get(vmf->pte),
> 							vmf->orig_pte)))
> 
> Since we're canonicalising to folio why not actually set folio using
> softleaf_to_folio()?
> 
> So
> 
> +			folio = softleaf_to_folio(entry);
> -			vmf->page = softleaf_to_page(entry);
> +			vmf->page = &folio->page;
> 
> This would also make more sense in your 2/2. But more on that in a sec.

Thanks, I've thought through your suggestion carefully.

Could entry reference a tail page of a folio here? 
If so, softleaf_to_folio() retrieves the folio containing this page,
and vmf->page = &folio->page would point to the folio's head page,
which may not be correct.

Best regards,
Hongfu

