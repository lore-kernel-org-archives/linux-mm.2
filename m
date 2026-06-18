Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 849C6CD98E2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605066B0088; Thu, 18 Jun 2026 04:43:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD0E6B008A; Thu, 18 Jun 2026 04:43:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5406B0096; Thu, 18 Jun 2026 04:43:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C44A6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:43:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C473C2C33
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:34:14 +0000 (UTC)
X-FDA: 84892371228.23.46E61CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id D47DE2000D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:34:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YM57K2za;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781771652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SB6+ZWqOYOVD8J6Bm8SL4mIshI5oOydkw8DYdXdWOWI=;
	b=MY58KL4pjRU4I5lRxYE6ggYSIFA7OwwI92zCPNlFgb7vjEMMIPjz84bCOt8X+9rgU54GHw
	WorxyGA29QUL55FEn+jqIq+gajUBFVM06hfRVOhWgu0J6r2T3iG1yUJd0INVAtw9iFz5ni
	SMghy06/+WyOmggYxHPbb+ssShjaYSk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YM57K2za;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781771652;
	b=5GG8BwXfHM0p0EDdCNbHYbrqHNJxRXE8U9fEWjHmHztb7ovGPXiRLqRlHTzYHnNKIpMRxK
	Q6JO2OSVslTOv5Du/SsfnkyOO0fUNCuqE1oryTvTUdw8tU9GDvnMcXQ8/ojl/uJcOWPUiw
	zkZw17kVA2JABm05DNybSVXGZf2Rlxc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 075CE4391A;
	Thu, 18 Jun 2026 08:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96471F000E9;
	Thu, 18 Jun 2026 08:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781771651;
	bh=SB6+ZWqOYOVD8J6Bm8SL4mIshI5oOydkw8DYdXdWOWI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YM57K2za+CC6RytagmjmCqXnGQc+SkdnKMBuOZwnO2NqsfRcfFEpbGzEn72iCkPg7
	 Adu28iwlNOIklDbu/PZI1NjZFE2MY/VVPalsuFkVouPiL9IY8E7E0rGoOGeHei/Rnp
	 YA0W3poKHIA6DCrOmWDA37W/6mQ6Di08BvfNXJuagpMB9PVY0I2cIR9kKo0trJy20Z
	 2eHZLmiFXByxMoz2YPVv4mXkjmjCA35cnnAvKV8gxesoW/n2n1njTLodZfUhP9hZ96
	 uFJm7n0ajHBoYrRdjyJ3qv/dH65lDSVgOM16OoKUwWqjw2BVqsN/vSjy1h8PEK4v0m
	 /I3p8zP71uT4g==
Date: Thu, 18 Jun 2026 11:34:05 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Oleg Nesterov <oleg@redhat.com>, Peter Xu <peterx@redhat.com>,
	vova tokarev <vladimirelitokarev@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: prevent registration of special VMAs
Message-ID: <ajOtfdGgFQYL-T6f@kernel.org>
References: <20260617194059.2529406-1-rppt@kernel.org>
 <5a993689-f730-406d-8515-8bb6025cc851@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a993689-f730-406d-8515-8bb6025cc851@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D47DE2000D
X-Stat-Signature: 1inbgk45xwizcgdyu6hxh68fsyfo5iog
X-HE-Tag: 1781771652-677320
X-HE-Meta: U2FsdGVkX1/KB9X+iUEid52ghFx5CVplpG4+CFDTWrmhQOMdSeOrg8ErL5ZOIuRrAKLDMNNZdsWhA6/tCWGGVkZpu+I2EtPDimXSTsg47yg851oR8cdcd8HhplqOv2i/bjtt1COLY7AlJ066IYGBPyBUOCD2QUysbZ0omizdiiP7pHWsQ3Cme6SWeMAqTaZnL8fYxZNIjpbsiWwP7QVj3dUlg3T1qQt0PNmapTdrt2f3tKOIvl3Rto4iUJhbMbvpnDjkNvNnlF6Pk1qHHK0yh6YwFQ4M3TB6CyVbo8lWf7y3/DsBdncuZnva6S9W4+Db0zW9YNn1m4m8WhGFh31vydyKJYmkl8vAEILG2fC2zaufT3RP29oTsz3cSyq34E0GGnGO2EZVUE0JqATH27esCSo+gAp7A6bKADlJBeZEGeruz3EpfaQdUTzJAhsdmsVCfNdUSP+2ImQRboEhHP90t4hEtpebOE3DQloP+8pDzMcTvTPxEoWIETfcX5wi8fvf8DvkOzPn15klZA9TZmlokhc07AqPqlc+gMZIC/q6f3Rr1bahm15v3nhydrASSmgOMNzKtip7yPWRk12xEapKIXXqOFXODH2ZBfkBrMg1AzniE+3iINLqOKpgnf5JW0zebswZYM75k/gszbq+9topdT7NFJGfk1/f+PMCyNpgr7W9VOUIbcmzSh9wBZcdmCusdyxSBQ81IIbD83ZQO23hYopvcKghPgJ+i50aoNDFf+ws+oo8V46IVxcSJZXqzHsJ18tzXqqB3cU3ZvkCto7Hl1djMINFYar/HF92X8CzUHopHx3lboFvy0v+MrF/3rHlgE6bWCsSoEYyHkxdGcMNxHFG8ivxohkuCP8MAUHxtnGR0csV/gKGsZz+fFxIUt/DofCM9+kR1JlfvyL7oX8A5enwpOthnZ2Cy2QdMtL2O4jEXCawDFn1Lp0uVftcWwRk/PA0slo/BNlFAoTLEtX
 54b1/kjm
 WLUUcfvOSwdWQJmIQtTIue600iiogr6UcNQ/VIdheLTlxTaTkBBq9d7/oitrB/fBFK6abxIBk46Hzz7RyRmYoBAwNEdac5fooBi31T+fwumeM+7qstRNTM0qeMAurmNr4b5SFF+/pzLxy+/+XWIADWslbYMs7tqx6C7sIR4TfZHNEQL0Uucc7m2/f8aiUmbQazPgotoIY1I2NcjPSffdPBh4NLUvnUSPL/G0Arp1jc3/BK9jS+v3V3tOS0gcBkx3QavLLIqoSOZiNHBbVHJ4/bpElWBj0eTUS4UEmrPZySeldkp4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 10:19:17AM +0200, David Hildenbrand (Arm) wrote:
> On 6/17/26 21:40, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Vova Tokarev says:
> > 
> >   userfaultfd allows registration on shadow stack VMAs.  With userfaultfd
> >   access, you can register on the shadow stack, discard a page ... and
> >   inject a page with chosen return addresses via UFFDIO_COPY.
> > 
> > Update vma_can_userfault() to reject VM_SHADOW_STACK.
> > 
> > While on it, also reject VM_IO, VM_MIXEDMAP and VM_PFNMAP so that if a
> > driver would implement vm_uffd_ops, it wouldn't be possible to register
> > special VMAs with userfaultfd.
> > 
> > Reported-by: vova tokarev <vladimirelitokarev@gmail.com>
> > Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  mm/userfaultfd.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 246af12bf801..b8d2d87ce8d7 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -2111,7 +2111,8 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
> >  {
> >  	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
> >  
> > -	if (vma->vm_flags & VM_DROPPABLE)
> > +	if (vma->vm_flags & (VM_DROPPABLE | VM_IO | VM_MIXEDMAP | VM_PFNMAP |
> > +			     VM_SHADOW_STACK))
> 
> I'm sure you considered VM_SPECIAL, which additionally includes VM_DONTEXPAND.
> 
> Would that be better, or what was the reason to allow VM_DONTEXPAND?

By itself VM_DONTEXPAND won't matter, as uffd can't resize a VMA.
But thinking more about it, it's better to make vma_can_userfault() more
restrictive and just use VM_SPECIAL.
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

