Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C8E710F2861
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 17:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 769E66B0096; Fri, 27 Mar 2026 13:39:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7409B6B0098; Fri, 27 Mar 2026 13:39:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67D316B0099; Fri, 27 Mar 2026 13:39:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 547916B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:39:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F32061B98E5
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:39:12 +0000 (UTC)
X-FDA: 84592554144.28.9B6CF4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 52EF8A000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:39:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f4UTltk5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774633151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GyrqVamBG3j4otOmqJuCFce9BhzZSQDfhcypvVGMDSA=;
	b=42rKXShF31L56P8ZWjXEBhIfUASQEcTWRof6l1WsH3f3hqYoTDOnBTCF3ekUCLKcMtyoTA
	NZzWzB3sDtKat5I8fOWP0fUSyWz8TEDuVT+ZN7ju4y/J2T5TPD+cbOQGhwP4rTVdgs7/Fe
	my21UDD97rY+SZIJV798jNqfOqNlbKs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774633151; a=rsa-sha256;
	cv=none;
	b=0kfu57T3ExA1E0PRKXszsXxrJI8Qx00Jw8qwsqtfwvUp8m65ibWUwin+hhD3F8pWCsHbVy
	asF2oHPgPQk1RBlj65qRW4pYUyNrwDZHHvHHjJR6qxbK1DYdDJrTtqdCL+NzJdu7tzCBTP
	JgZU36P6BBFijGrSOIq1NcBR/z4rAj8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f4UTltk5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AB1C760054;
	Fri, 27 Mar 2026 17:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8670C19423;
	Fri, 27 Mar 2026 17:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774633150;
	bh=XvRZpEO5qXbmnDOaGraCF9wlJYPl5uIhO+RgIna/R3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f4UTltk5F2B0knlAlLfHgqtM7+h9X1XYrGDiSo/Timu/CZjBmQYzSOnrHya4pm01D
	 6t0FxKH7BtbNprB4YP5hoZUZkm2rQKm86vDphdnrUXTJ8TNvsKkRPSmu5fSUmMdPMy
	 q/cXVpSvooqHKR0qpx96DHQgUZascinHQzKhIU/IfdJezvxsfKmbfSmwdil95/C6fG
	 gQHXpwcZwB1qv36puLX8dnXm/jsU0pyJXg6VxFV83IxLwrtdEjmYf73D3zSYZJSDsE
	 YLq4SFbYCGgsyRFt6A0QfiGEsvO3k9kfrNRESo4+kHlxREZdtZsqCXgO/14WwaTReQ
	 vFqn0Y/xCYIfg==
Date: Fri, 27 Mar 2026 17:39:07 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Jeff Xu <jeffxu@chromium.org>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, antonius <bluedragonsec2023@gmail.com>
Subject: Re: [PATCH v2] mm/mseal: update VMA end correctly on merge
Message-ID: <f0173a2e-8035-4f32-9fde-9dec0d1e5f58@lucifer.local>
References: <20260327173104.322405-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327173104.322405-1-ljs@kernel.org>
X-Rspamd-Queue-Id: 52EF8A000E
X-Stat-Signature: z84bzzzxxi94e16bb97831y343wazim5
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774633151-949878
X-HE-Meta: U2FsdGVkX18A31/sh1oWIfjCZ9K3Qjp2VGMt6z1KhHZMVLPdJ+X0OfEBOSdDCrMBfr09Far4YX3cGVUeS3XzMoN3zA2TTlAYB/YsglgL++t57QiMLmARVpjdlD8EwFszVelSughUBi7fqxPwmTH3/77fpmckRs7ZC97eUvDHfJZPCFnkaIrPL8NQEDyFEuBx6g7cGJn6Aihlsn/Cwl9H1vvEubR8n9r4xqvhB/ys7evkAhe97AA0Lq6QzMqkNDGy7SZj1Ram5LrHKDD2CAkvXETEv9IKk5dd6La53zYJKJY2Rt+eF6Of6aQzGQfB5b92ZAfl+x84Bmf1qBltK5sYjCyxYqLvQEtpc22KMT09Ux/ru1wlfTNACCMnryei03g/id0SeTIlngG5PsvD8aVyrZkvD3kVgDCo2TZA1KIayN2jZoBFb2dAGK+Y+ZV0WJEjIBHbQ2E1A1SwWIRsUql7WGFQhIsxcO+uyD17CI7VC+3mCn+WSvHZrPGNqrwAzJD6uexANu+446OVoO5xPjFYLe80iVOFeUWjkuyn06Kt3MlcM91MluOg4ooiYm3oYtJw+310upFf31Sx/x+Ov0+twNflVdSu968JV1RwhMwNHbxtQ/kXQ4xjZQ4et2SRuLaf9vWISWXQLN01gbRrHAnwJgkm0Xg0aP7uJtHiLLvx/yv8AE900Ekd6YClP/0u9IH3tGKeSwUL0u0EereNfVoNGH12NCSJm5ug/AttiQSmeU2VE6GQnG/uEbl8q14x/uHp+Wcw1v51kKUekiZSKXJTPpVg9JWclqowJoY87WkhEDaZcOFQE8JdUBtDa0VTiCjb5fuFXJFyvRg3+HwKnkDvlDO4ULZUPjCzdmzHxjKDJ6i9Ncc+I9lWqTtg44CEij99tkLFzXmn/7Lvdqdru67vNXnUXpzW8YKyBhsFz/IiKfTj0t1cdkctYVxyGyfnYZG9qO/Va1BUUZ1TzBp9Pat
 VdB7nF8K
 jKGSrQvP2v9YavL96DmGmirLpsOn6eAfNuAKVMDHEEcFosB357EykfPoV1PvcZwGCLZhbHERhobSLxp/MLtizE5I4P77O06Bk/ld5FsgXGwT7aRECDVD35y/oX5KJjrAXxJ3i3GE2nLoCGX+GtbWkWY0pOHn4l8R+Dn3kxp+oEvOLX+XPfCZ5Sp2n15aS/vCJftjcLfItX4UV/5/LfQKHX4fSB8bhBHsaX2DWmnXlF5UFX/RogmnMYUZ1HiohawUyO5tdaFjGXY+aVlUBOeZAfInNgfC9GA+WUmpmdmjaKIxOQJuU/ltuS05OQhZdUdq06buG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Note - I tested this locally against the repro and confirmed it resolved it
correctly, and I also ran it through AI review as a double-check.

(Secondary, less important note - I plan to refactor all of these loops as
they're all quite bug prone :)

Cheers, Lorenzo

On Fri, Mar 27, 2026 at 05:31:04PM +0000, Lorenzo Stoakes (Oracle) wrote:
> Previously we stored the end of the current VMA in curr_end, and then upon
> iterating to the next VMA updated curr_start to curr_end to advance to the
> next VMA.
>
> However, this doesn't take into account the fact that a VMA might be
> updated due to a merge by vma_modify_flags(), which can result in curr_end
> being stale and thus, upon setting curr_start to curr_end, ending up with
> an incorrect curr_start on the next iteration.
>
> Resolve the issue by setting curr_end to vma->vm_end unconditionally to
> ensure this value remains updated should this occur.
>
> While we're here, eliminate this entire class of bug by simply setting
> const curr_[start/end] to be clamped to the input range and VMAs, which
> also happens to simplify the logic.
>
> Reported-by: Antonius <antonius@bluedragonsec.com>
> Closes: https://lore.kernel.org/linux-mm/CAK8a0jwWGj9-SgFk0yKFh7i8jMkwKm5b0ao9=kmXWjO54veX2g@mail.gmail.com/
> Suggested-by: David Hildenbrand (ARM) <david@kernel.org>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Fixes: 6c2da14ae1e0 ("mm/mseal: rework mseal apply logic")
> Cc: <stable@vger.kernel.org>
> ---
> v2:
> * Correct Closes: tag
> * Use David's excellent idea to improve the patch
>
> v1:
> https://lore.kernel.org/all/20260327090640.146308-1-ljs@kernel.org/
>
>  mm/mseal.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/mm/mseal.c b/mm/mseal.c
> index 316b5e1dec78..ac58643181f7 100644
> --- a/mm/mseal.c
> +++ b/mm/mseal.c
> @@ -56,7 +56,6 @@ static int mseal_apply(struct mm_struct *mm,
>  		unsigned long start, unsigned long end)
>  {
>  	struct vm_area_struct *vma, *prev;
> -	unsigned long curr_start = start;
>  	VMA_ITERATOR(vmi, mm, start);
>
>  	/* We know there are no gaps so this will be non-NULL. */
> @@ -66,6 +65,7 @@ static int mseal_apply(struct mm_struct *mm,
>  		prev = vma;
>
>  	for_each_vma_range(vmi, vma, end) {
> +		const unsigned long curr_start = MAX(vma->vm_start, start);
>  		const unsigned long curr_end = MIN(vma->vm_end, end);
>
>  		if (!(vma->vm_flags & VM_SEALED)) {
> @@ -79,7 +79,6 @@ static int mseal_apply(struct mm_struct *mm,
>  		}
>
>  		prev = vma;
> -		curr_start = curr_end;
>  	}
>
>  	return 0;
> --
> 2.53.0

