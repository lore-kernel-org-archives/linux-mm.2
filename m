Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A56FCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 12:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2298E0069; Wed, 29 Oct 2025 08:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33B798E0045; Wed, 29 Oct 2025 08:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2037E8E0069; Wed, 29 Oct 2025 08:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 08BBC8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:32:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF2CA5A20D
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:32:12 +0000 (UTC)
X-FDA: 84051089304.02.35DF802
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D7E32C000E
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:32:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FJgv2viE;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761741131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=63Hr9geJeZINSi0+iZx5lG4HnJMwESbGP4GJKJg5SkA=;
	b=GSsmZrzIVWib6v2Gow9I6ssCdOmivgYDu6yLhHhrUq/ejOshwh96THBxQkKQBAYIlIgrN2
	tZrxbYleMEDi5jdDC99rwIdafrG/MQO7y8wjud8phy27Jaua6csiIeUF3nW2auIgahvK08
	+VnYdXPeCf3WMOVaoJRiglATa0yChM0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FJgv2viE;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761741131; a=rsa-sha256;
	cv=none;
	b=rknXOIv1OPXn2vmAo+RhC6VlAOGFdX0ntEM8OBQK81IgStgPAEhlWv+XbUgn6g/xYH7W9X
	3htfU6CDlUI/A8Gqe/Q8/eSKW2lf4Ndwk0T/8nCjP8eOvGxvy1n6RTBy81r3M+XPrw5Unq
	3cMM8+j6QupkM/1abSnRf86W6k68t+Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9448142B62;
	Wed, 29 Oct 2025 12:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C35C4CEF7;
	Wed, 29 Oct 2025 12:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761741129;
	bh=bwJ2LDA4HRhC+HobQk4QKdidu746ps7rOg5uVjEgqro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FJgv2viE4T0S7HMJU6Yh7xCC80x72PQjEKuQzhXPuI+TXewfU5c5NVc/W52pu7PQ7
	 e5k/ft0v6KR0Wb16oe7Q37oPx+ZQEeGi6s/xnccQrVaKwi91vkHYJXFRUReY/IZ3nc
	 4T97Tr1tWM9CQOEhIqJfxhtbk/zLt8h/HLZx2l64WfT7BRo8ZITf3nhN7slWoTc8dt
	 oNjOLZpMChg/E6wI6M2RLrWSalIRfMVI6zvruFfFi5MDVHjLMgws2oM92LLZVguItY
	 uScNW57JyDgVNiPgPx/zywwoqvGhxQ/EvK2QveGnFjEJ4jUyqupUot16mS9/hUiRZe
	 sv6QR5mXH2ACw==
Date: Wed, 29 Oct 2025 13:32:04 +0100
From: Christian Brauner <brauner@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, 
	linux-xfs@vger.kernel.org, linux-mm@kvack.org, hch@infradead.org, djwong@kernel.org, 
	willy@infradead.org
Subject: Re: [PATCH v5 0/7] iomap: zero range folio batch support
Message-ID: <20251029-entrichten-anrollen-b9eb57a2914f@brauner>
References: <20251003134642.604736-1-bfoster@redhat.com>
 <20251007-kittel-tiefbau-c3cc06b09439@brauner>
 <CAJnrk1Yp-z8U7WjH81Eh3wrvuc5erZ2fUjZZa2urb-OhAe_nig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1Yp-z8U7WjH81Eh3wrvuc5erZ2fUjZZa2urb-OhAe_nig@mail.gmail.com>
X-Rspamd-Queue-Id: D7E32C000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1xzbts8optb4ojesat593tmmy43uwm9e
X-HE-Tag: 1761741130-170245
X-HE-Meta: U2FsdGVkX19uevPjy+aXiH/V89iO5MbscqIM8CnLuXdZRRH37AT4CO9g8Yzbas/Lz7VkISS0msHIQVNsn7stDWLQnNh5vQ2bWFURoZlexUIMCQvASEtd6NNbYcjPDKNt9bHp0SahsjKg8U8JAXbFS/lqzYjWYYLd7OdcgUArAWdUzz7JiNe2whD9WHCCXb69kr6xXKpMHophaKkYDhEcDOj37LEfltaIqlz9T0gjnmezqwHm1YcW7dOsgCY4iZphxfsjLacZms5M37aPP0SO8dN8kmSTJaFKi49qVm55MBUeR2DEyVjkAlAtHE7c2L7CgcrGh0CC1zquzt+iL3CRrk4PUsKnwXPMg3/sLNrgqyxK3DIFxBdNFUAgN+51UWQySXJxMtXZFhCKMO0MMHwibO48Jb1qq6DLa+uG5idq/whH33ny0uolVNJc3Qt8cg2nUe1Aawzy/0+fQ4PAPbL5s5Bd1/he0G0Hfz0+y5uFj6rjbF2UnOlVEperMZZwej4g5dIWXn6R/uZGaWxxPg1+MDODfc6B+lkXHkN04iS7L6dno8mTDwGJD2sdt//7VpByiCoLrAF5DenfY8ZJmBP2+PFozovKwmMThChks3Kg1TfD+9ulmc3eHaRTd3DYljnn8V96xzPuEqd0RiFz1nz1fD1zvT+0NvP/YD+IfU/ssO06E09wAEDK377XB4qE6sHicoJJ+F7W3PihtlL3I0O50S/8MpF7U/XWQe7dYDg++qfAyC5kuuF+OUO+GAddrkya9/s/E2CXKU3F4U/mDwbGpHubTND9V/Sj3yNuZMCSsfzCwWzu/dRI6i3LPCPzaA8L897agGJdFl47PSdxcNfbqrnkiPbZ4WCAefqmS5j1Mh2DUiOjlYVyvnxoE6/+yFVqkfRdUl0cm3Qfula6WrO7qtbYUsXit2rQx79ZNVU92uTDSIy5wzOTZPNgsC65lNaPhc12ocHp18TteetuK14
 gSWPyI1Z
 BNZEr4rA7tMgMNlyNFPsZsTjhn4yXTCYTRsBBnotm50ice3cJbFmx5/Vp8HbvbEflChm7PI/msiY3JD+yEw1cXx/pbV/UnDwNNBgXyfmkZIPId8Pj3g05kebdvlrak6Ua0beiV0Ltn5KtbI0IxVkbBeZTYYPbx7Yah3dTGV0qwcqOczlgJQMN2DCifCPmQkHmbPv3TBuhAygEYjQ0J4KHKgNdH4JnFiMfUwz3AA2zAzvQCkMW27nRXppSvgfOkVNCBAawa2JmfpqhcxpWUaHxoM77VyBRWPchq6QcERGZmHy/SHXTdH0aVRsq9AV6McllZZBOGi1F1Ea5rC55p+qlcMHO7HgKsKUOlk+o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 05:14:07PM -0700, Joanne Koong wrote:
> On Tue, Oct 7, 2025 at 4:12 AM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Fri, 03 Oct 2025 09:46:34 -0400, Brian Foster wrote:
> > > Only minor changes in v5 to the XFS errortag patch. I've kept the R-b
> > > tags because the fundamental logic is the same, but the errortag
> > > mechanism has been reworked and so that one needed a rebase (which turns
> > > out much simpler). A second look certainly couldn't hurt, but otherwise
> > > the associated fstest still works as expected.
> > >
> > > Note that the force zeroing fstests test has since been merged as
> > > xfs/131. Otherwise I still have some followup patches to this work re:
> > > the ext4 on iomap work, but it would be nice to move this along before
> > > getting too far ahead with that.
> > >
> > > [...]
> >
> > Applied to the vfs-6.19.iomap branch of the vfs/vfs.git tree.
> > Patches in the vfs-6.19.iomap branch should appear in linux-next soon.
> >
> > Please report any outstanding bugs that were missed during review in a
> > new review to the original patch series allowing us to drop it.
> >
> > It's encouraged to provide Acked-bys and Reviewed-bys even though the
> > patch has now been applied. If possible patch trailers will be updated.
> >
> > Note that commit hashes shown below are subject to change due to rebase,
> > trailer updates or similar. If in doubt, please check the listed branch.
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> > branch: vfs-6.19.iomap
> >
> > [1/7] filemap: add helper to look up dirty folios in a range
> >       https://git.kernel.org/vfs/vfs/c/757f5ca76903
> > [2/7] iomap: remove pos+len BUG_ON() to after folio lookup
> >       https://git.kernel.org/vfs/vfs/c/e027b6ecb710
> > [3/7] iomap: optional zero range dirty folio processing
> >       https://git.kernel.org/vfs/vfs/c/5a9a21cb7706
> 
> Hi Christian,
> 
> Thanks for all your work with managing the vfs iomap branch. I noticed
> for vfs-6.19.iomap, this series was merged after a prior patch in the
> branch that had changed the iomap_iter_advance() interface [1]. As
> such for the merging ordering, I think this 3rd patch needs this minor
> patch-up to be compatible with the change made in [1], if you're able
> to fold this in:
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 72196e5021b1..36ee3290669a 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -867,7 +867,8 @@ static int iomap_write_begin(struct iomap_iter *iter,
>         if (folio_pos(folio) > iter->pos) {
>                 len = min_t(u64, folio_pos(folio) - iter->pos,
>                                  iomap_length(iter));
> -               status = iomap_iter_advance(iter, &len);
> +               status = iomap_iter_advance(iter, len);
> +               len = iomap_length(iter);
>                 if (status || !len)
>                         goto out_unlock;

Thank you! Folded as requested!

