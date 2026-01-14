Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B90ACD29FF1
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F67A6B00B5; Wed, 14 Jan 2026 06:35:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29B0C6B00B7; Wed, 14 Jan 2026 06:35:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A39E6B00B8; Wed, 14 Jan 2026 06:35:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F36F56B00B5
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:35:15 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B7EB21A0442
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:35:15 +0000 (UTC)
X-FDA: 84330363390.23.58EAC1D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 637B0180008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:35:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=joISx2o1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IiVeDDKD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q5zHwuGF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hwRkntOo;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390513; a=rsa-sha256;
	cv=none;
	b=781Id7jGbWaEXEsIuX+YqjzKmwG2P4aJL8MYJgpttaanmNE6YvV8jGHQwMwd7THb1poF8n
	888y7HFkW04XO5k7ldlc6K9S81+k73va9LtG4DIEWYmOQ2zeVYNcjFwSDGu/Xd/3u00SLm
	pDAXhIc1c1TilgbdBXhn4zz/N4cdIFA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=joISx2o1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IiVeDDKD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q5zHwuGF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hwRkntOo;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+vtFGwlvwFcJdd9kx3i/3SK8Y/po3O5eHXGJwIGw57s=;
	b=x2gV0fmdfmpYzgYpLPrCeC31BwoAiLnlOl8ovSff3aKUuCS76jfebk54IOLfxxYPAdHmWR
	9gR9m6xU7XrSUOGZc82CAJ4UvWWhCkvGoGRVFENg35iE7+3IEDZcn5ZB7GFfaMFE4XSpdz
	cNRvJNcy2vsaRYcWOaD3sxnv3x2uJFY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 750B05C368;
	Wed, 14 Jan 2026 11:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768390511; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+vtFGwlvwFcJdd9kx3i/3SK8Y/po3O5eHXGJwIGw57s=;
	b=joISx2o1xY5F99LNjDVaBD1OAyHB2fl1BryxzdduPV2Qdi6MHuns9QbvbVo+resqvWKTlB
	tmzvLyNQB8Vv5mWOqRvGBy7oogxbaTtrRLiR/cV/CeLog6esiF783tmc79bp/iqrpetR6A
	KHIax2Cn2wmukFbTHW7S7wg0E9AFqOs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768390511;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+vtFGwlvwFcJdd9kx3i/3SK8Y/po3O5eHXGJwIGw57s=;
	b=IiVeDDKDKF3/HkFiRuB56yUietAwRRi5ZzzRAL7J6bXWRTHljoXex6K34Vx488yLxDxqZT
	2tGKjKgi0dJfJIBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768390510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+vtFGwlvwFcJdd9kx3i/3SK8Y/po3O5eHXGJwIGw57s=;
	b=q5zHwuGF0z8dzEcpcJH3ZIQfs74QuN8CHlN9igKJGhmq69zgr+RWCnUAFAktaC/DlCJ7Rq
	ST66wmCmxdgVtk7tuA9xsADYHtpmatwEITZDE5Qf3bDT5cg/ctkFGZQ7wq0N2U3T0JCp+L
	PSpC0zC0RdlRfV+LBboAvTnzXgP4FQY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768390510;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+vtFGwlvwFcJdd9kx3i/3SK8Y/po3O5eHXGJwIGw57s=;
	b=hwRkntOo9d3hqSW5VzjYd7RfzsGToj93szPIjWOLrXFdzhMImhpU0FCfROmLSTaMNvDcfz
	rIAsSMc/bAVSuaDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B700A3EA63;
	Wed, 14 Jan 2026 11:35:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id y4F1KW1/Z2n7EwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 14 Jan 2026 11:35:09 +0000
Date: Wed, 14 Jan 2026 11:35:08 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Mason <clm@meta.com>
Subject: Re: [PATCH mm-hotfixes] mm: do not copy page tables unnecessarily
 for VM_UFFD_WP
Message-ID: <2cfknurph2lkbfht6nqajt74fujwompjgmkhr3muiiv3snylhr@ufijpjud2rac>
References: <20260114110006.1047071-1-lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114110006.1047071-1-lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 637B0180008
X-Stat-Signature: hq4f9bqeujyhhrh5r13fzx34wcycrzw6
X-Rspam-User: 
X-HE-Tag: 1768390513-600719
X-HE-Meta: U2FsdGVkX1+/dzzATeKJPkAYlIihsm9a5Fmw3OyVp71x+UgGjDNlWUBptr7yOpwyT0tl0Foqi61WDAtJDr8YtWL3yiwynGuPyxwJMagl6yUPmEpt41HGJD5Sw0k8jWuXuSD7AGY8dlMot14/NOt0caHYKcjurcqRnhxp/XXEr5WTRulNt21ty1Keu+J6CDMtKaLKeQZneHmOsQBe7z8R+PbJG0zdPrTLtCyrtAqUq5WaDJMX0e4kwPkB9qGO84EFbnnq2nmF1kfOHOQjP9bCUQ1OILmIwbGWAzVLfkdWE0RU8/UhlWd0shQcJbrRQuq5d/sAymt5MBYTZnKpJPc7FRWI/mSCn50Dqrhfre+vG2n06lqmJaD1EJye//FODx1VCI0O3MOyRNkHp07ZXxBPLP/2tX7sIdrIWFB5UivBDGZ3XfXJT+M958prA0WSaAwLAzzZ6tPH56Pprf4Tzl6tpFvccLTxtCoEpkHhmP75QSMswBjV8DuC9duYnH81ouVHfauIMOFhhe+ImHf5du5Sbvr3OiSNy5D1zJyHktU35SbF2XKXgMR1DiAR0/N9WToHfFNCWHUbjRM+bCWER59DLi+mX3e15uC3riY7w6s4YaqAHieOpzdcOzaddQ//BAvWDD7BhObU+Ivr6Mv2om48fCqbdgTlC31QfUXYf4RmSoViuNPq8mgnUq9GXx6KhKkpBdNRgZ1OowaE/3dPW9XA4io/TALEu5hJGljH7b052BGUNxYIvCsCuJa9D4wYXZtnwISwTG365ZqWBEts7SPm4BZapErDUceelZg6v1tmiDJXvSG5q2jTDv7FpaIKa3nWC5y49sf7bhTZpJ4k8f+cqAgQdl5Op0sONpc/U9oa6aO4YbZdy7FhqC7Nty3mtZ77PI0z2Ne7ZlxKaXMngqWjaFWXJBUXEdOh+DspO81OWlQqyySu3RMJtzwGaP9g3hSYT8CbWZyNRs5d2hRw+t/
 h91rCQ0C
 IMXgRcxeN0/WAPz9E0tEhlPw6aGRHw6rdMkbSvb78w6yZYNq1Kyxo2ktOxqAO5Uo76ed9iQSmTbMEBpNygC3IE8Mrjt/sdCoM3CXHiIibw3EY7whBEECx8EdTu6FIqvrI+xA0GjTynljgTBsb9oWWrYfjkoNuarjPoFX2kqGcxn8Up7/Cp+l9L8x7lqVfjf7YfOEkXAd4N0ale/uQgcKR7N7SQxqK56x8eZijVanwr25OGM6UXctpsw+WxZUh7XY2of+OUuFCOII55SpI8fjT4L+QqIrxiHit6Bar02EkQ5Er6pfbDi0QNehFTg0aNO1IOR5XT6UHkaqgX+53iYz9K18xjLd5Uc9GPlyJSggLI0vfNji/1wS8ij0K+5HChnZ77zx3+NroG50rgcAmywsFUAtp+hqPMvTHAApcd1pfVjmk9oCjqLwwyYm3mo6oVZv6Jq3wsPl6eXwmtDE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 11:00:06AM +0000, Lorenzo Stoakes wrote:
> Commit ab04b530e7e8 ("mm: introduce copy-on-fork VMAs and make
> VM_MAYBE_GUARD one") aggregates flags checks in vma_needs_copy(), including
> VM_UFFD_WP.
> 
> However in doing so, it incorrectly performed this check against
> src_vma. This check was done on the assumption that all relevant flags are
> copied upon fork.
> 
> However the userfaultfd logic is very innovative in that it implements
> custom logic on fork in dup_userfaultfd(), including a rather well hidden
> case where lacking UFFD_FEATURE_EVENT_FORK causes VM_UFFD_WP to not be
> propagated to the destination VMA.
> 
> And indeed, vma_needs_copy(), prior to this patch, did check this property
> on dst_vma, not src_vma.
> 
> Since all the other relevant flags are copied on fork, we can simply fix
> this by checking against dst_vma.
> 
> While we're here, we fix a comment against VM_COPY_ON_FORK (noting that it
> did indeed already reference dst_vma) to make it abundantly clear that we
> must check against the destination VMA.
> 
> Reported-by: Chris Mason <clm@meta.com>
> Closes: https://lore.kernel.org/all/20260113231257.3002271-1-clm@meta.com/
> Fixes: ab04b530e7e8 ("mm: introduce copy-on-fork VMAs and make VM_MAYBE_GUARD one")
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Acked-by: Pedro Falcato <pfalcato@suse.de>

> ---
>  include/linux/mm.h | 6 +++++-
>  mm/memory.c        | 6 +++++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index cb3de0c73d03..44a2a9c0a92f 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -609,7 +609,11 @@ enum {
>  /*
>   * Flags which should result in page tables being copied on fork. These are
>   * flags which indicate that the VMA maps page tables which cannot be
> - * reconsistuted upon page fault, so necessitate page table copying upon
> + * reconsistuted upon page fault, so necessitate page table copying upon fork.
> + *
> + * Note that these flags should be compared with the DESTINATION VMA not the
> + * source, as VM_UFFD_WP may not be propagated to destination, while all other
> + * flags will be.
>   *
>   * VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
>   *                           reasonably reconstructed on page fault.
> diff --git a/mm/memory.c b/mm/memory.c
> index 4b0790c8fa48..2839000cd26f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1465,7 +1465,11 @@ copy_p4d_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
>  static bool
>  vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
>  {
> -	if (src_vma->vm_flags & VM_COPY_ON_FORK)
> +	/*
> +	 * We check against dst_vma as while sane VMA flags will have been

s/sane/most/?
I understand you're annoyed but perhaps we should leave this out of the code
comments themselves :)

> +	 * copied, VM_UFFD_WP may be set only on dst_vma.
> +	 */
> +	if (dst_vma->vm_flags & VM_COPY_ON_FORK)
>  		return true;
>  	/*
>  	 * The presence of an anon_vma indicates an anonymous VMA has page
> --
> 2.52.0

-- 
Pedro

