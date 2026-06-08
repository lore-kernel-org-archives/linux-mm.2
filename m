Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2004CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 13:03:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF7466B0005; Mon,  8 Jun 2026 09:03:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCED36B0088; Mon,  8 Jun 2026 09:03:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0B966B008A; Mon,  8 Jun 2026 09:03:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD7886B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:03:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 753D61A0AB6
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:03:19 +0000 (UTC)
X-FDA: 84856761318.24.88BCA9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B5A0D14000F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:03:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WnCrlLI4;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780923797;
	b=K1HTjW1uNw/sGcJREsi6IRajQdlCMEorg5rIpKWKJdGSpos1lQlgIMTI+0ev7mN7Aa2z+r
	4mfpKV1cxKGzhr49ZZtGYF4txPSR3fGu2bgPss2tDTL9qNu2hVz4fEDjN0TCNey8T+5sRG
	hpq5ut+t2wnXa4S/WXw3+1bDIkIZtlI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WnCrlLI4;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780923797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u8t0JmXdFbFbeA5ltIt8qNK+2eno+amYqyTTozeq0js=;
	b=TF0KIb7G5LbCp9WZxRg1ZYs1Jdh1WxV+/ELqr5M2+H6nwqZ5s1EokoBTO+nukTQsj2IhdE
	x2aqEDKlCrhXZseiKC4S7Vyzpq4jDPx+GuFrVmd+kgjPm7RstU3d3TWS2b0pDSKO/FdCG3
	XA9Uw3bBitcsFvUPDVwVrUlVMIiIJ6M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF73A437E8;
	Mon,  8 Jun 2026 13:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543481F00893;
	Mon,  8 Jun 2026 13:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780923796;
	bh=u8t0JmXdFbFbeA5ltIt8qNK+2eno+amYqyTTozeq0js=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WnCrlLI4cEoMqxpHS7crTMZ3G8aXdSp+Y2MrhSAn29GjoXlwtyB1iVzwJBlcShKgQ
	 pS+Y/y7PAA5vbOAIYl/Ohabzt6Jd8sPvo92QX+E4ZZNL0NqwSw/EsU4co8tpclya3d
	 XDHgb3y5I0lROYr5Rl4fSbLacF4QPl9IXOxMMegPyxwXYQ6X+d/actDFi6mMVbUJJo
	 nLgGoxZRjfRD0UKJYiiIu6BbPMg0ubpsUO5e3nusonpfgll/NaNxrd8t7xOWgtj0Y0
	 X+xKatEulWW/roSNbMe7xFy9ukkH6ve242zAXed11Qud7X4d1KT63aruFmsVYKgkER
	 ukQnsV6eKeW/w==
Date: Mon, 8 Jun 2026 14:03:11 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Carlier <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Heechan Kang <gganji11@naver.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Michael Bommarito <michael.bommarito@gmail.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] userfaultfd: verify VMA state across UFFDIO_COPY
 retry
Message-ID: <aia8nKXtShnhQpVY@lucifer>
References: <20260527184751.4147364-1-rppt@kernel.org>
 <20260527184751.4147364-2-rppt@kernel.org>
 <ahhAHNSZOeW49ms2@lucifer>
 <ahhUM0A8-q0UqFv1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahhUM0A8-q0UqFv1@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B5A0D14000F
X-Rspam-User: 
X-Stat-Signature: jkyrayns3noez6jn3wec7suuucpcb59c
X-HE-Tag: 1780923797-982308
X-HE-Meta: U2FsdGVkX1+8h0wuuW5LcQVXBbEMGLYb1usnaNj/oYIBU+ELkWgcbXJ7vBrRchplKqFYLj9WchS39QttdFY0l5ur14lF0ceWCu73dHH6Rp9gbRL2oxrnPoFzqqOoxwSxS4M26QjM9MsC+HW9JoitXVOhvucn2nWZcO6akeTgyiy+P4+ObnA57oTwLRK5PcuBDHSPOaPlfOJaVCweyPP3qKlIhSB9T6x2lWta31jtgbfEt5A4dHAM17xzZLOcQTB+LAIteNH43Ubo01556ox8hmLKrnEC97laG5CMFx05d0R5+2bKPSlBaBBBL+ggUQdPK1p/iGFm2sGS/tZr13Fh5AfEhJTr9W+wbQ95f5wnd5Mg2VeUqS+w1srP0OgXZ65PuMHL+7b8nxeuNAMkK2gPvPp9Lh1vr21/2gYWQa6fHW7q+1R6zXstU6Dy9g2p/KT2VLGrti2D2BogtZL8FKdgDiZ+ZjOD0beUfojPivcLlQUMfmEn3aB4wcBzoOqSJS95hc8uP1A5Lz279rj+/VQ6Gpo2L3+RfLV34Er/7eS/l6R9h7b4haxlYjtmmNFF5fp7HvSx1tAkkghf+G/6hbmxjmJsdLSXfi8yyjSwSC/oBhvY1zX/D8o6a0QN+1hbvOZZ6JQTieptOlJPEZFzyXIeP9EPQBcVdzPXEPLIUvN0oe9FLT278pU5Zv8H4UNDbTD2uxVRJ3XHV2kl5j1dZmFoy+/qZZ3R8xmj8+MjplwG0NBhaNyHrg0hzLNdRC271xIhB98CC3i/zINMdHwCqLY4CRIWrAJuDQ4OYYoKt0dZn+tmSb+jVW3M9/9MMlv3QuoyUN9R0TMTjgDF94FQjtekN015B0AKMKAH+/Iq4/hS8PKMRIqGj8t54NZsBVzNsdALHnAZjkiqV0FvR0/tWOCIU3kT/baOZ6AfYz+AUMa0/D3vQwXhiAcXLYxwujDlu7btfBJuTZFlyWU/sBSuuK9
 CoorUD7Y
 gA1STRptuBrw/nL8WlT8rm6KaRdtbrCASG18AcQHLeUuyy1xPofqkAxAyuWOmSfy3sZmJ1DjSed+3uugA5xWR9b0C11thEDIWhj2WTfCpuHMUvCFrexdiboPUGi6pniv+uBoTTbBWz184tylTeaoRt7ABoFf7QTZ+QKjAESw76Ol7kEYK/u/w/jzAQ1Yioxv0zVCZ9CYMK95vsmaqUv1jhcbKbXBKM2SFwKLv+py0AeKWpQ+dsMKNyd5XMCzy/wCUtG0p6dSAuJMYUvBso2CYhcdOVK+/zpaR9LzG4FjSTGM6zO0QixRk1Hz7XG2T0oSAQyB19WHck4dxTyJd4aIU0HyzTDjcuNRmGM1MmbVMKO4u9d76uh4nZuASeVeNdxMAdKAzXkEYBfPP33gR4naesEEFHR5i/1WLqmMDPTK5KDB4pWr7UjTXx2S/iEhX7cqICSbV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 05:41:55PM +0300, Mike Rapoport wrote:
> On Thu, May 28, 2026 at 02:31:00PM +0100, Lorenzo Stoakes wrote:
> > On Wed, May 27, 2026 at 09:47:49PM +0300, Mike Rapoport wrote:
> > > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > >
> > > mfill_copy_folio_retry() drops the VMA lock for copy_from_user() and
> > > reacquires it afterwards. The destination VMA can be replaced during that
> > > window.
> > >
> > > The existing check compares vma_uffd_ops() before and after the retry, but
> > > if a shmem VMA with MAP_SHARED is replaced with a shmem VMA with
> > > MAP_PRIVATE (or vice versa) the replacement goes undetected.
> > >
> > > The change from MAP_PRIVATE to MAP_SHARED will treat the folio allocated
> > > with shmem_alloc_folio() as anonymous and this will cause BUG() when
> > > mfill_atomic_install_pte() will try to folio_add_new_anon_rmap().
> > >
> > > The change from MAP_SHARED to MAP_PRIVATE allows injection of folios into
> > > the page cache of the original VMA.
> > >
> > > There is no need to change for hugetlb because it never uses
> > > mfill_copy_folio_retry().
> > >
> > > Introduce helpers for more comprehensive comparison of VMA state:
> > > - mfill_retry_state_save() to save the relevant VMA state into a struct
> > >   mfill_retry_state (original uffd_ops, relevant VMA flags, vm_file and
> > >   pgoff) before dropping the lock
> > > - mfill_retry_state_changed() to compare the saved state with the state
> > >   of the VMA acquired after retaking the locks
> > > - mfill_retry_state_put() to release vm_file pinning.
> > >
> > > Use DEFINE_FREE() cleanup to wrap mfill_retry_state_put() to avoid
> > > complicating error handling paths in mfill_copy_folio_retry().
> > >
> > > Fixes: 292411fda25b ("mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()")
> > > Fixes: 6ab703034f14 ("userfaultfd: mfill_atomic(): remove retry logic")
> >
> > Did we want a Cc: Stable?
>
> Andrew adds it when applying.

Hmm, I didn't think this always happened by default? :)

>
> > > Suggested-by: Peter Xu <peterx@redhat.com>
> > > Co-developed-by: David Carlier <devnexen@gmail.com>
> > > Signed-off-by: David Carlier <devnexen@gmail.com>
> > > Co-developed-by: Michael Bommarito <michael.bommarito@gmail.com>
> > > Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> > > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> >
> > OK the logic here looks good, thanks for the changes. I have one comment below
> > re: a redundant check, with that addressed feel free to add:
> >
> > Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> >
> > > ---
> > >  mm/userfaultfd.c | 85 +++++++++++++++++++++++++++++++++++++++++-------
> > >  1 file changed, 73 insertions(+), 12 deletions(-)
> >
> > > +static bool mfill_retry_state_changed(struct mfill_retry_state *state,
> > > +				      struct vm_area_struct *vma)
> > > +{
> > > +	vma_flags_t flags = vma_flags_and_mask(&vma->flags,
> > > +					       MFILL_RETRY_STATE_VMA_FLAGS);
> > > +
> > > +	/* Have any UFFD flags (missing, WP, minor) changed? */
> > > +	if (!vma_flags_same_pair(&state->flags, &flags))
> > > +		return true;
> > > +
> > > +	/* VMA type or effective uffd_ops changed while the lock was dropped */
> > > +	if (state->ops != vma_uffd_ops(vma))
> > > +		return true;
> > > +
> > > +	/* VMA was anonymous before; changed only if it no longer is */
> > > +	if (!state->file)
> > > +		return !vma_is_anonymous(vma);
> > > +
> > > +	/* VMA was file backed, but file, inode or offset has changed */
> > > +	if (!vma->vm_file || vma->vm_file->f_inode != state->file->f_inode ||
> > > +	    state->file != vma->vm_file || vma->vm_pgoff != state->pgoff)
> > > +		return true;
> >
> > Doesn't state->file != vma->vm_file render the inode check redundant?
>
> Nope, struct file is TYPESAFE_BY_RCU, it can be recycled with the same
> file * pointing to different objects.

Oh lord :)

OK ack on that then!

>
> --
> Sincerely yours,
> Mike.

Cheers, Lorenzo

