Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77FF4C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 08:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591206B0005; Sun, 12 Jul 2026 04:54:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51BAA6B0088; Sun, 12 Jul 2026 04:54:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4FA6B008A; Sun, 12 Jul 2026 04:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 180986B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 04:54:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 95CCA4085C
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:54:05 +0000 (UTC)
X-FDA: 84979512450.21.7DCE6AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0A6701A0003
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:54:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=epPcl9sY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783846444;
	b=npGT23vVbkvht98m2MQOoKBPmlxIHnS0Q24XtNsyrOM+rO8QfzUuetcTUYi/uC35AeE+Rj
	j9Rfg+veSH8EhrFzNxP5mpFFcJL96YdAfAKxChbJQh9rA5vM96fCJFdvEQ8P4qryzFPISi
	cxX+ckdddNBaEJRqB/v2s+6XU6ZHhnk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=epPcl9sY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783846444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GnL9C72NCuP+8WoVaUMRNhlRZdNBSwfW36nJtkAt9LI=;
	b=cst5MrhDYp1EELP4ufERbEvq53sKFbzf6CHzw3Zt2DQM00BMBmJxbiHo9FoIsGx91cMMJb
	B9ETWj7fTFBXf4ahSJMAx/rfDcjKC7MtQ+hj+qVHgF5AZjQ+sg/ZGKXX1EyoOVIJG1moC+
	ppwWs02nzpdBAq88zE3hoLDhhCey9cg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A8CB600AA;
	Sun, 12 Jul 2026 08:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1958B1F000E9;
	Sun, 12 Jul 2026 08:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783846443;
	bh=GnL9C72NCuP+8WoVaUMRNhlRZdNBSwfW36nJtkAt9LI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=epPcl9sY5qVsxQZgyUPrZsLn7kXboM/IbScY0npRmn9P+uRRsG+P7J04YR+iaTObs
	 1Px8rtHkErijBwOPBiUblVWwHivtzui7iKOQzLnQCbfVUWTosHxOMF+GGFijea9wlK
	 zbz39L341j03oPz2WAoRaPtTJh2riBYK1+pzbZ//v7p4o3QWUPlAcJ0yDZ/ZtLH2I3
	 oCr2y9pF59kfYfOJFdkWO49UwMw4GcYox72kxTR4mDa4FbEoXG2CkFx8yZYdAjkTL3
	 E6oDW4BUgoGmtZEjVpvqLSM6YwBYEbG5gElIdhTpYK4nxTZEhlk/ORnJAQa2ENgvoc
	 w58yTf35cMoSg==
Date: Sun, 12 Jul 2026 09:53:48 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Toshi Kani <toshi.kani@hpe.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Carlier <devnexen@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Will Deacon <will@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/ptdump: always stabilise against page table freeing
 using init_mm
Message-ID: <alNWAE1818jgGTqW@lucifer>
References: <20260710-b4-fix-non-init_mm-ptdump-v1-1-2d40982c98ec@kernel.org>
 <alIWLiLObQuZTGQZ@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alIWLiLObQuZTGQZ@kernel.org>
X-Rspamd-Queue-Id: 0A6701A0003
X-Rspam-User: 
X-Stat-Signature: waza8cbjf7n8o7efb1x89khsfgxam8fd
X-Rspamd-Server: rspam03
X-HE-Tag: 1783846443-703683
X-HE-Meta: U2FsdGVkX19wxYmQvx5uP4u+wUE/gFda9pVEZY79haJ+bkkv3yLnIfTOdz07ZdcRg2Yo7It7wNEfRs8jcuBxF7JWJZKblePCxn524ylA5QKJAmUxM/bN4LMLv4fIXmfJlSJvc6LIsWyxCv+DwRvYYBDsPp5gZostQ12BXn4foS7AWsGGc7GPlLtCb7YZ9+yQ7IphAxZb2q/AJpsOPSFVSUPIXvrhpIaEQaPvXdRB05atbvqQmb1DXFN4Z3iJyOPzE5uV4VhQJ3RujxuBRX4WRH8FwXWGO5olTjtGm89OauIEx6FwALchw4svtV3T/I9SXKgN37yBzikOn3E73l6feEBJ1TKqZHTcFuH+0TkWDUNlH/Ouns+3OYveqIKaWaM+7keltdJRTsER3EYT5du4VBr59gYoxArZ6j06UKOoQKifg82+ihdZZxZJ3HDHLo4NbB70LSh6No6NosWubkrqPlB1ErREI+fJBJzbeBueS8lcMt9gzCsopa/59nsDu7SzAuSAbRwrqUbyEoVMiP8HlJ2Mg8JHfLjIuhjlyIHRPf2Uiz8EQYrDyTpnyK1XrF6Kh3WcKpLq4Aag8RrSPAWCf7efiBfnGb8UQLSyHcj0FP4aWC8dg81CvYZZKKs5r0k28u5oiFngS/8mS0aTfGk5Xv7tv/5xCwiSWdmUxvaLonUlKPnE0JnN/xMD/Sn8/D0icitpmvnanbI6QY0qsV7E5RgznxiNUCOp2JW+G90GqJ9zm3dFqtQNBkWgQ9ORrD2SRuoFYnhCj5dgaiwJOYO0GAgoyKLaFjLFhIMziPE2OYto2ON3I1MAOdH/L1hBYl4O9YrBZHziF8B0G1yqYSWzX+SEmd9sFSefrRXuVdNccMtvzW/W7mNIkqYyD69Brm/u2Yi29a3QhOxgv2RUfUxqMFSVnZoOazM1b2zWFgo/bu/dsZKEg+kLbxOpbAEeQpUgHHx2Zwrcm9hHzLmWQtR
 aG4bxUnV
 dSSjvN7kyp8nx+ycq62wbYwtmqkhPE4k1be1eT4Q8Yv9C3U118U6lko0PlT3Zd1WritNU8bs+EkXLhS0xuFdoDfzPYVrASCV3ZDjB/f5+BmdPRkOsY+8Af8v7ioJu244nKtdujRXxVgKXrOHMTbmlJRB/r5Akta7wtgpVuKlc9HPjyjFXxcwJ2pt4YGd3JpAWPbNXyk2w1Fu4aqDqNQItcPdHdsQRainoI3FFHBhLJVz6Dw26xftIV50gtg9tV+JZfBB8lhD/q+K6Z0V4NkL8EKSwLBDf9SSnOhDemVL3koNr1O/Aqf2g9o2zsVPBXoq+ONha
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 11, 2026 at 01:08:46PM +0300, Mike Rapoport wrote:
> On Fri, Jul 10, 2026 at 02:29:21PM +0100, Lorenzo Stoakes wrote:
> > x86 and arm64 invokes ptdump_walk_pgd() with non-init_mm mm whilst still
>
> Nit:            ^ invoke
>
> > walking kernel page table ranges.
> >
> > For x86 this is done in ptdump_curknl_show() and ptdump_efi_show(), the
> > first passing current->mm, and the second passing efi_mm (we reach kernel
> > mappings that init_mm protects for current->mm due to x86 cloning shared
> > kernel page tables for arbitrary mm's).
> >
> > arm64 does so via ptdump_debugfs_register(), configured by efi_ptdump_info
> > for efi ranges against efi_mm.
> >
> > The init_mm mmap lock is used to stabilise page table freeing against
> > ptdump, so take a nested lock on init_mm to ensure that we are correctly
> > stabilised.
> >
> > We take this after mmap write locking the non-init_mm mm. Nothing acquires
> > the init_mm lock first before locking an arbitrary mm, so no deadlock is
> > possible.
> >
> > Other fixes have been sent which update the two cases which can cause races
> > with ptdump in init_mm ranges to acquire the init_mm mmap write lock - vmap
> > and x86 CPA huge page promotion.
> >
> > For arm64, commit fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump")
> > already provides exclusion against init_mm for the vmap case, which this
> > patch also pairs with.
> >
> > The first point at which ptdump can race kernel page table freeing is
> > commit b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page
> > table"), so we target this in the Fixes tag.
> >
> > Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> >
> > ---
> >  mm/ptdump.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/mm/ptdump.c b/mm/ptdump.c
> > index 973020000096..6bef47b1a073 100644
> > --- a/mm/ptdump.c
> > +++ b/mm/ptdump.c
> > @@ -178,11 +178,18 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
> >
> >  	get_online_mems();
> >  	mmap_write_lock(mm);
> > +	/* To stabilise page tables we must hold the init_mm lock too. */
>
> Maybe
>
> 	/* To stabilise kernel page tables we must hold the init_mm lock too. */
>
> Other than these nits

Ack on nits will fixup on respin.

>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks!

>
> --
> Sincerely yours,
> Mike.

Cheers, Lorenzo

