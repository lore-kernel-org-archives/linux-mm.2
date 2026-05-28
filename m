Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8E26CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 14:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002A86B008A; Thu, 28 May 2026 10:42:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF5456B0093; Thu, 28 May 2026 10:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE3BE6B0096; Thu, 28 May 2026 10:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8A2F6B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:42:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 733C014084C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:42:04 +0000 (UTC)
X-FDA: 84817093368.07.57C0A01
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id CE43516000F
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:42:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kZT86gGL;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779979322; a=rsa-sha256;
	cv=none;
	b=XJjNULTkJ/awq0cXByiV8cgSwsjJZDPuQhKC/Ubzp6EyNbePYauoayfgyh2hjt9mmkl57m
	27WwKqX9SvI+qr5eKvtVMpglCyJTOV46Zoxn+0WwXRROE1SJPKcVSypYBx6XhksU0zkvsx
	qxlcGv6a41CiJnpllxz3zlAoSN1CAwQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kZT86gGL;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779979322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NidMkUmESVDNlcSyssCD7iZp1v/eAgCquicEmOON/mM=;
	b=3Ob2BZbdT0fSpVRA1BwWJMxR8p+3qHTIfhtIMzCWDnutu1aUvhvn8zo8/amum0357xY7PG
	r67Zg1L5d0AAlct08xzRWnl/iPV4qfBck8o77Esl34/J13z0T3xhuoVnEv8u9HLEycnVzl
	tth4lOKo5wlWS37rBPPDB8tnMixjZm0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 401536020A;
	Thu, 28 May 2026 14:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6B61F000E9;
	Thu, 28 May 2026 14:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779979322;
	bh=NidMkUmESVDNlcSyssCD7iZp1v/eAgCquicEmOON/mM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kZT86gGLszALBo+IVJWP75sjtXaeROUt9a9FO4bIW3ZUmT751p4s78vUy72+nH3uY
	 as5+HZZnfsBTp4+kpTUaPyuQwKLXPM09JM57thOilmhX6A8dq0DZFD/f5HS6FZ+7nu
	 gh/2f8SB2LA0OrM4BUL9kulFb/zsPPVIs7VsF4BOa/P9qgvIXGVYlj5xlKUi+KMzaP
	 6rilsaQQ4gBp9OcchqbJ3nRmDYJ2Ppd34GoC1E8DSxiMQvGi41Od6STQb05NiXtzhS
	 mPx4e0zZQsl/cRscgGJYrAd8V4HEZi8KRbWx/9RmYFfAa5kmcE5zLheCWTc+KQufs5
	 +/R87HLTa+KUA==
Date: Thu, 28 May 2026 17:41:55 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Carlier <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Heechan Kang <gganji11@naver.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] userfaultfd: verify VMA state across UFFDIO_COPY
 retry
Message-ID: <ahhUM0A8-q0UqFv1@kernel.org>
References: <20260527184751.4147364-1-rppt@kernel.org>
 <20260527184751.4147364-2-rppt@kernel.org>
 <ahhAHNSZOeW49ms2@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahhAHNSZOeW49ms2@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CE43516000F
X-Stat-Signature: 96qzm1mo18b7b86ysdxm5ssgcrux3jmb
X-HE-Tag: 1779979322-675737
X-HE-Meta: U2FsdGVkX18xwomvEIroo3uGQ2635mcduxH8xUBjlMi1GnW3/QixIWKui+3kU9wH2w0iCO9T7ViqVelBZQYXaVOC+V14gcHcP/RKyXEpzXrMuelbZN4xJy2r9M+X5KTpM59EDST16qebp1EyIU/xLidkHmcO9dyu7fxaF2eygqx1VgUS/2iyeGiU/ryq/6SzTiQD0cCwo1ihGh0yi+AqIf3niTwzzSLf2LidQ4rcKUM9BHXhkgkB8GSX0PR0x0pF7eTbSAoCsTcogp+0Zenr+YGEYRK0a/N3ECPVSzQqH7evaPXOW+9VP/5AXxcRA18qXo5eT8G/48oCNAV3YOwKh6bV5UMNQWzLdJcoWFaonWwb4rurKocjLBpLk2rrw98o4GOUWNvDTd8f55Ve81PSz2AQc+zebCH1KDqYEyQ3x7gmyfr3umKHHUe6MTiEMKrIxTNypwfk4JJUYdw5bx2kgYI4+dbVhdWX+S1wkeyLtuLcjPX4x1ffe5DUDo0UYAd2lu9MEnqbZjq7ljvRDGVy8dqc17Lu3IruB41LM7GKqaHlnC9vCjKE8SCaYvtfniLDIPNyrszpIJ5dOchdGPZxEAMW6Mfz5XJpbhGWwNlEV0eBD8LWFZuIwnxzNWaI41DMjkRaUmTr5MufpVo/yWmUkOvNyFpM2b/EZh0FGeJm40CBGt0nj6XaizV5tU8j9qJXt2MXS+xQEsj1GaE5qkbo0B0EMrt0AWbELJ3C659f0ab66PQLdZd226Afnhwi70AOk7/jHEUq6kQIfHK1K3qBOgQUHavUrGiduOMuMl1D/RmCuOtQyfm5Oi8g3E5KOvCaWMRJfOmXFpn6pXybz4U+9FOEFqXpWYbYhPVSyJK7df8mwXlLhWpgBHnAvUtt9mr8mHh4MC7KXiq8D6RLygvAwfqWCfC7huNftj1kVI/ap8ZI7shyx8s3fX5GRMnSDr6qlGx17alHeEHvpN5p8/x
 En0Ir+dF
 qwMtLJ7l8LcSzR12H0StHTBU/C253CARtMLRl3fHmWSEn96Ogu8U3tez8utOtaBqrJOPSDJs69sdQ2IKCfqDA5CpaKNqcIJP3kOEHw+Rrn1QJC3GWj2VLcXLu5u3ueq7EwF3M5OG8J4BLUYsRcZFKZaLRAExEcYRRo8G64LpbJ/v1oqTww1Y5mdMeM3nfjCpPsnqOI44alWnJp3UOiF3Vu+hN+wmvo6BnQVr+g7khkRpbXMwej7Y00sE6e0JTOdi+SUWEBeBcRmL6dv1KY428GBNneNDY3EI8Oja1/dDodqgcKF8LWAAHrIgUDwJ7338UaFocJPElFGofa6lCs/DIC9D+pZ6hCOCPwguRgO41usH/kfd3wVLsGtRyTUBB8fLEctlAuUP0axacFIpeMziqj03jQK1QUEGoRA0oZ/Zb1AmAB/v/cDSmTl0TLHuKcZL4sogz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 02:31:00PM +0100, Lorenzo Stoakes wrote:
> On Wed, May 27, 2026 at 09:47:49PM +0300, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > mfill_copy_folio_retry() drops the VMA lock for copy_from_user() and
> > reacquires it afterwards. The destination VMA can be replaced during that
> > window.
> >
> > The existing check compares vma_uffd_ops() before and after the retry, but
> > if a shmem VMA with MAP_SHARED is replaced with a shmem VMA with
> > MAP_PRIVATE (or vice versa) the replacement goes undetected.
> >
> > The change from MAP_PRIVATE to MAP_SHARED will treat the folio allocated
> > with shmem_alloc_folio() as anonymous and this will cause BUG() when
> > mfill_atomic_install_pte() will try to folio_add_new_anon_rmap().
> >
> > The change from MAP_SHARED to MAP_PRIVATE allows injection of folios into
> > the page cache of the original VMA.
> >
> > There is no need to change for hugetlb because it never uses
> > mfill_copy_folio_retry().
> >
> > Introduce helpers for more comprehensive comparison of VMA state:
> > - mfill_retry_state_save() to save the relevant VMA state into a struct
> >   mfill_retry_state (original uffd_ops, relevant VMA flags, vm_file and
> >   pgoff) before dropping the lock
> > - mfill_retry_state_changed() to compare the saved state with the state
> >   of the VMA acquired after retaking the locks
> > - mfill_retry_state_put() to release vm_file pinning.
> >
> > Use DEFINE_FREE() cleanup to wrap mfill_retry_state_put() to avoid
> > complicating error handling paths in mfill_copy_folio_retry().
> >
> > Fixes: 292411fda25b ("mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()")
> > Fixes: 6ab703034f14 ("userfaultfd: mfill_atomic(): remove retry logic")
> 
> Did we want a Cc: Stable?

Andrew adds it when applying.
 
> > Suggested-by: Peter Xu <peterx@redhat.com>
> > Co-developed-by: David Carlier <devnexen@gmail.com>
> > Signed-off-by: David Carlier <devnexen@gmail.com>
> > Co-developed-by: Michael Bommarito <michael.bommarito@gmail.com>
> > Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> OK the logic here looks good, thanks for the changes. I have one comment below
> re: a redundant check, with that addressed feel free to add:
> 
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> 
> > ---
> >  mm/userfaultfd.c | 85 +++++++++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 73 insertions(+), 12 deletions(-)
>
> > +static bool mfill_retry_state_changed(struct mfill_retry_state *state,
> > +				      struct vm_area_struct *vma)
> > +{
> > +	vma_flags_t flags = vma_flags_and_mask(&vma->flags,
> > +					       MFILL_RETRY_STATE_VMA_FLAGS);
> > +
> > +	/* Have any UFFD flags (missing, WP, minor) changed? */
> > +	if (!vma_flags_same_pair(&state->flags, &flags))
> > +		return true;
> > +
> > +	/* VMA type or effective uffd_ops changed while the lock was dropped */
> > +	if (state->ops != vma_uffd_ops(vma))
> > +		return true;
> > +
> > +	/* VMA was anonymous before; changed only if it no longer is */
> > +	if (!state->file)
> > +		return !vma_is_anonymous(vma);
> > +
> > +	/* VMA was file backed, but file, inode or offset has changed */
> > +	if (!vma->vm_file || vma->vm_file->f_inode != state->file->f_inode ||
> > +	    state->file != vma->vm_file || vma->vm_pgoff != state->pgoff)
> > +		return true;
> 
> Doesn't state->file != vma->vm_file render the inode check redundant?

Nope, struct file is TYPESAFE_BY_RCU, it can be recycled with the same
file * pointing to different objects.

-- 
Sincerely yours,
Mike.

