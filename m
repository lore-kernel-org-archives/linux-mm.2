Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B015A10F2849
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 15:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E7706B008C; Fri, 27 Mar 2026 11:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BFB36B0095; Fri, 27 Mar 2026 11:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FBD46B0096; Fri, 27 Mar 2026 11:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 13FCA6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:52:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC45213C604
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:52:10 +0000 (UTC)
X-FDA: 84592284420.05.07BEE14
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8E077180017
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:52:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eGvhQaJ8;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774626728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Q5ksaGR7gwOSVEkETuLC+0wScT8pAv66Ky5oYJjKzM=;
	b=m4jgAPSqm75Ts2RImLC9UEinJ/jEo1SdbDI1ew+G1s18s9otggysGhdCC3PkOR15T/KUYf
	q+BlzmUHYU/TWzvrvYQhrvMCpa01jfK4vECI0oSLdmtJ3PS9x+DtQY5rXGhvzYf9dePXif
	r4mFfLfKB4FiNf6X2OXYEFTWhKOAyEY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eGvhQaJ8;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774626728; a=rsa-sha256;
	cv=none;
	b=lUB2tgNMvCmIl4/Fwn1xgCd5Dq+hFVtP0tHxYR1op8MyrK0OA96RBQH/C6M0YWzvTIdwR9
	ixw8fzqAQW2+0nHf62txbqygsOrbUvRun1GA9XUuUG1BefMB58eAYVySj02+gdzU58NwtD
	9OzkcJb8HdkEXaLrNhWmb3dhed2yEC4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 945B660054;
	Fri, 27 Mar 2026 15:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D55C19423;
	Fri, 27 Mar 2026 15:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774626727;
	bh=S+rziZVihSoBfUqA+7DJs6Ny3tSZzxWwBJfTNWgblG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eGvhQaJ8/qCwDTAZFS6JoiEX9NgaeeQxj/xwvS9eDsDKmDsZUjzfyUY+ueo/fvxOQ
	 /coqGswZ85HEy6I+z9oQYOaBCi/jZrOYk98oOLxYvGPSKKHp0eq9vIeuxB5ovEqU2c
	 PPurJ9RDrbtwzr0tl1T1NV2BQejLjZXMzjV+dV6VlijzgtUnGcrmJBe4r1xUd/hqK+
	 y+EmeHV4JXbyhUxUqCMEJ/CwaTOGUBF57z6KMagkWgnavsjYsh9Syq7LPRhx6Jyr4Y
	 BYMi75XFawwFTENKpXCiSFPN93tU8+GTULmU7lYXsE8gwIVdOzbChF3SuAccmTt4AY
	 h4VB4Do3UG53A==
Date: Fri, 27 Mar 2026 15:52:02 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Jeff Xu <jeffxu@chromium.org>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, antonius <bluedragonsec2023@gmail.com>
Subject: Re: [PATCH mm-hotfixes] mm/mseal: update VMA end correctly on merge
Message-ID: <d6348e8e-b9ba-4404-848e-8db941ffdfbe@lucifer.local>
References: <20260327090640.146308-1-ljs@kernel.org>
 <20260327082446.4e7fd5398043d56cebb35a54@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327082446.4e7fd5398043d56cebb35a54@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: mbadeidqjt6787ngk3bcuhf8b5s59xwu
X-Rspamd-Queue-Id: 8E077180017
X-Rspamd-Server: rspam09
X-HE-Tag: 1774626728-740543
X-HE-Meta: U2FsdGVkX19u0ILVRPpV/jm+dVQTiLsZLLj2Mbv6dB8yl+gZkkBt/EJHLKwZGFdV5lIQYhelAVHrzYPkQ9J8twP1i4WzzpWlLj384CIHYkbqRaijBD+J0Tw3jAU9wjeoYkJHYYzmQ7fOxglhK83W3g+pkyrpp0GFsS8FRP1VUHKowIJaNM8dwApFi5fj0wk2PbV8nD4088wAHF1sBm74bQhA1Tckrtbhl2mbx0LSTzChWqw6VrleNazgSp+pva4ZuR+1cVC3zCGt1I2SKxAB2OUke4D2dLzWj2YRAWMLvIt9+UWJ0xlBXnny5+JW+etO8miYD7DJ4qrvLx2+kGSUoys8F7xvUJ5U7okHoIYpaOng04otbpYza89AdEQa9nW+5VKKMtfRC0RCIUDEC32PwG+WrzkxBfAp/5y/z2YSyUeQiDn9DIBJjsqrXhbJ+fXSokeliJ9htpsh6Rmj5JgKAXpHQgBuG8qnxNeDE2SwttrBAt7S4h6a4TE9AQiG+bUrVg36MgAXZaIgEdXdOt6iO8H/wtbEMO1u5hXpIQITr2yu+95OkJB86dbYNjzwCM/5CxhU+1vwN77Fr4WJIBNmQMZTnXWwVPzS5bxhGvjnrTAaxXLDtvsn0fFaD1C+hplPqdZV5cVNHURugsJ9T3xb3L8s1QdD3Gmy00y2AuWKjTPu1kucI/GfxaI4lMyC6Gen1wIbf30yJJ4VDlQj0AYGz/3ohjlLp/Fos7mz4CtNlmQOLtjr9DVelubNr0bTmjwWvy8Ga/hhyewbR5rPDmhZkElpqKL3V8Eo5XeuZYk6pDaweF9nZ/hSU42qU9qtNuQ+xCX9iU0q66kul42Kwp/qljgOqyA8w0PULbIwcBiMvHGibmstDoY33i62aH2vke7Sb5ewr6G2uHEnaWVO7NrTYSa37guB/DTFJigGe5EFrqM7Sbluw6xnyS0wnf4TVnCwdo8nX57wgYltvSG0chA
 r+P7W+gw
 nAiTIMd5IeNSZBcgA9dz/FkJ5Tub1FD92UNKpqFT6NuEJ2XgAvoyKE/5nfWbDk0ggseIyUOZtQ8n3SJIHigQcpNoGkGRM2969KnNIUxrMGxAZVzLTDXTZujJC9esaj4q4ajrFwj7/vV6JlAIRV/GizUOChB40IkNAnHXcaDZ90xmzwUcXPtgf/cKevhLBk2la1XFzyJ2uqdLnAajoemUDIXFw8WIji/nXon7VMr8o7/K3B5E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 08:24:46AM -0700, Andrew Morton wrote:
> On Fri, 27 Mar 2026 09:06:40 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > --- a/mm/mseal.c
> > +++ b/mm/mseal.c
> > @@ -66,7 +66,7 @@ static int mseal_apply(struct mm_struct *mm,
> >  		prev = vma;
> >
> >  	for_each_vma_range(vmi, vma, end) {
> > -		const unsigned long curr_end = MIN(vma->vm_end, end);
> > +		unsigned long curr_end = MIN(vma->vm_end, end);
> >
> >  		if (!(vma->vm_flags & VM_SEALED)) {
> >  			vm_flags_t vm_flags = vma->vm_flags | VM_SEALED;
> > @@ -76,6 +76,7 @@ static int mseal_apply(struct mm_struct *mm,
> >  			if (IS_ERR(vma))
> >  				return PTR_ERR(vma);
> >  			vm_flags_set(vma, VM_SEALED);
> > +			curr_end = vma->vm_end; /* Merge may have updated. */
> >  		}
> >
> >  		prev = vma;
>
> This led to some rework in your "mm/vma: convert
> vma_modify_flags[_uffd]() to use vma_flags_t".  Please check my
> handiwork.
>
> reject:
>
> --- mm/mseal.c~mm-vma-convert-vma_modify_flags-to-use-vma_flags_t
> +++ mm/mseal.c
> @@ -68,14 +68,17 @@ static int mseal_apply(struct mm_struct
>  	for_each_vma_range(vmi, vma, end) {
>  		const unsigned long curr_end = MIN(vma->vm_end, end);
>
> -		if (!(vma->vm_flags & VM_SEALED)) {
> -			vm_flags_t vm_flags = vma->vm_flags | VM_SEALED;
> +		if (!vma_test(vma, VMA_SEALED_BIT)) {
> +			vma_flags_t vma_flags = vma->flags;
> +
> +			vma_flags_set(&vma_flags, VMA_SEALED_BIT);
>
>  			vma = vma_modify_flags(&vmi, prev, vma, curr_start,
> -					       curr_end, &vm_flags);
> +					       curr_end, &vma_flags);
>  			if (IS_ERR(vma))
>  				return PTR_ERR(vma);
> -			vm_flags_set(vma, VM_SEALED);
> +			vma_start_write(vma);
> +			vma_set_flags(vma, VMA_SEALED_BIT);
>  		}
>
>  		prev = vma;
>
> resolution:
>
> static int mseal_apply(struct mm_struct *mm,
> 		unsigned long start, unsigned long end)
> {
> 	struct vm_area_struct *vma, *prev;
> 	unsigned long curr_start = start;
> 	VMA_ITERATOR(vmi, mm, start);
>
> 	/* We know there are no gaps so this will be non-NULL. */
> 	vma = vma_iter_load(&vmi);
> 	prev = vma_prev(&vmi);
> 	if (start > vma->vm_start)
> 		prev = vma;
>
> 	for_each_vma_range(vmi, vma, end) {
> 		unsigned long curr_end = MIN(vma->vm_end, end);
>
> 		if (!vma_test(vma, VMA_SEALED_BIT)) {
> 			vma_flags_t vma_flags = vma->flags;
>
> 			vma_flags_set(&vma_flags, VMA_SEALED_BIT);
>
> 			vma = vma_modify_flags(&vmi, prev, vma, curr_start,
> 					       curr_end, &vma_flags);
> 			if (IS_ERR(vma))
> 				return PTR_ERR(vma);
> 			vma_start_write(vma);
> 			vma_set_flags(vma, VMA_SEALED_BIT);
> 			curr_end = vma->vm_end; /* Merge may have updated. */
> 		}
>
> 		prev = vma;
> 		curr_start = curr_end;
> 	}
>
> 	return 0;
> }
>

Thanks that looks correct!

Cheers, Lorenzo

