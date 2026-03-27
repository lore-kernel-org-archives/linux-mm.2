Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B924710BA43D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F1516B0096; Fri, 27 Mar 2026 05:16:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C8C56B009D; Fri, 27 Mar 2026 05:16:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DED36B00A1; Fri, 27 Mar 2026 05:16:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DC7D6B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:16:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B561E1A0CF3
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:16:34 +0000 (UTC)
X-FDA: 84591287508.28.84F4AD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1FDC8180008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:16:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mIFg8aVL;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774602993; a=rsa-sha256;
	cv=none;
	b=aCzV/BLHG0ALv+IebHxss37QdyMh6QVidQg5S2Hcw8N9TKplPWoZju7WN/CTvQuCQAca3J
	bLxCt3AXAQ0aUrAe9/jOXV3BRyhN9qEoLfnqqj1o4haLNoiAkQd2dI3aYCKE0OG9qD78KB
	qM8sPSjMg4b2s18pWC/UCcAhemJ2ucE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774602993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMTWVW2EqGPH+vi9SfjdA8Jq2f6OCPgRmxHKl5ZyMTM=;
	b=SJCzcF7X4qf0sjshVzTYnk6mZAgx1GDBxK/Z+pK5d2P6ZBU9vqsBAL2G+NG/vyH7IEm3i3
	yr2YnYIFXpLXkUvp7XSptFFL/lyya5eSv8HyqQsskhJtzz4AtqB3WvUmY4eEYdQS2QSxor
	Fj1SdjDGoQU+9rqiB1cEGx1m8PIs+Ug=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mIFg8aVL;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DABA6132B;
	Fri, 27 Mar 2026 09:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F41C19423;
	Fri, 27 Mar 2026 09:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774602992;
	bh=RA2+mnm1jePLgWpzmoLJsGPZhaLbocUvEdhhnN00Uh0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mIFg8aVLPSTmq8Rv94QjNKfuvs8E1kB7ttXFs491G7/ggD+gM+wusHpPgCNiJIahM
	 xJtTi1gznRljpi/mnJJ6n5hyRoH6w0EsjrupxoUo8voigCx7cp0n4siS6m9Aw+wMOA
	 AT1Izmy7aSZyyuTZ+Jss89NN6CZIa/otnc/0gCjN2RTOFzUtEa9MsX+27LXoq4X4GP
	 emIfV+rr5K+88nw3G3XiNjKNiPDoZQ+k6EMqH6Ym6o5H4QY3m/BLUv5w5TZHlmi4Un
	 ZcPSaeWsfXRwc2IYDlGza1rnmmyHVIcyNXpNKpQZQrSetsJphRda1U1mSZZgPDKZig
	 dH6sCAPBXCUVg==
Date: Fri, 27 Mar 2026 09:16:29 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Jeff Xu <jeffxu@chromium.org>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, antonius <bluedragonsec2023@gmail.com>
Subject: Re: [PATCH mm-hotfixes] mm/mseal: update VMA end correctly on merge
Message-ID: <c48daa0d-8c1f-4064-9400-0849ff9484f0@lucifer.local>
References: <20260327090640.146308-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327090640.146308-1-ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1FDC8180008
X-Stat-Signature: gx8tdzhcx74neh3efubjjfnsqj3qx4zy
X-HE-Tag: 1774602992-178549
X-HE-Meta: U2FsdGVkX1+xeRs0i3xm0SEB9T3zizjhPpuuwBBFfojr5dU/GcmY8e0Z+5gFgPwOrTywztR1c1RaJn7b9H9kDT7qxoS4c5vkFFHzT+J43AyI+Os9q1IZKukSOgG9k/evezAFRsYAT9AtYbxasocYGHcKyPC02+cl9RPCr+dYC9QSHMZ9+5u5z9WgXZA8NMIe4YeVeju8sDRBVlKBFdbGXKdMQbiH33EcHcSX+YMA3HC344+/+fV/ERPrmyGOpHJHVDp0MFNHNPuK6TKJBY2XgFLyA8s2E+y6sc0olaE1TgrnDbKlnaiT2kbKTeEU20LIXNV55icjr6jFB694fnihIC9EYFbLjdA+8b5ZmwgB7ejBtAOSZgjOK40gagHTHaLjU5QiWGyvA/6TkHByR3nE4oKEN+pvkk+dM+48eKvfOpxbuaZ0dhgsivEwsoum3GpKfzi7MfQ0KecsTkeK0cKSjlfVcTBAufu3atQNFj6l5GU6TBpUIFrRMMKKFQBji2Jb+O0/qnXvJOvV2HlhuvboClVLYHCvNhWl7J1gnaWPCw+EqWCONjxNUQiP1nHgIPu0x2wHLRKqShpOKOJI5kc5ZAlZWIbqeHhO4eYmAvp+14hz6xyxq5Ff1vnz3lt1ZGcmacte+ZA02cZEhqoMexe1Vss+jCOcd14aCr59ha/ftG2nhZJSGgYdAY0FKfTNsAMma7/ykzp4ly0yplz4N6PWCbcTqQk9vd5p6d09HLkpl2qIJ/+0PhMOxE6hnXdhLn2J2QFxX1FVHgwl6x7Z31hNq2+rrI6f2u3GvCxurGj8z0gEll1lI2ncoNsyRNwSVv9mbmzBc3L4TnISEPlPzGj6PGCoOJECwYhCFbMypFG6Cjb81SYN6NnSvyn94BEZfJ6gRDDfcImstgcs6QZtkcivaJGVNEuOXhHiODtPzyEw6gBHvNiQnkhpuPDxlB6lvptHPDLHI8L9yVbUR7JcTnp
 HvipEazS
 mlgfORvOEwpuz2T6RU25KDIXO5pd/w8HlL3cyBHPHJmyVFaaCAWC0nRcXLLl5UXO4N3PFOqWUXt1M2oLaKFZT140ukyhXqvX8Da9fNeZiH8aqqKdhvTHhyEUZynGF08JTPzdXtij1KIC1TcX/qIldnkCJx/OyaqD/qd2rRnZy0dPqf+MbMPn74+We+rmR88eGoP3v/+NQl6NVJ5Ci98FasyLwbQN7LY7ACa0B/z4zQi0iYHzCiSDPPctsQ0FagsQja0Lf+JSL7vVilTt5aLeHEszRbdkQ7qQLlMBxIhaIMJhJouFIUsBMPAnsliVJszlHo8ar
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 09:06:40AM +0000, Lorenzo Stoakes (Oracle) wrote:
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
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Fixes: 6c2da14ae1e0 ("mm/mseal: rework mseal apply logic")
> Cc: <stable@vger.kernel.org>
> Reported-by: Antonius <antonius@bluedragonsec.com>
> Closes: https://lore.kernel.org/linux-mm/CAK8a0jyHXqBpt8Xe8v9SNDbnRiwz7OthA8SKY=NLRY7smPEP3Q@mail.gmail.com/

Oops, Closes should be:

https://lore.kernel.org/linux-mm/CAK8a0jwWGj9-SgFk0yKFh7i8jMkwKm5b0ao9=kmXWjO54veX2g@mail.gmail.com/

Cheers, Lorenzo

> ---
>  mm/mseal.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/mseal.c b/mm/mseal.c
> index 316b5e1dec78..2d72a15d8ea1 100644
> --- a/mm/mseal.c
> +++ b/mm/mseal.c
> @@ -66,7 +66,7 @@ static int mseal_apply(struct mm_struct *mm,
>  		prev = vma;
>
>  	for_each_vma_range(vmi, vma, end) {
> -		const unsigned long curr_end = MIN(vma->vm_end, end);
> +		unsigned long curr_end = MIN(vma->vm_end, end);
>
>  		if (!(vma->vm_flags & VM_SEALED)) {
>  			vm_flags_t vm_flags = vma->vm_flags | VM_SEALED;
> @@ -76,6 +76,7 @@ static int mseal_apply(struct mm_struct *mm,
>  			if (IS_ERR(vma))
>  				return PTR_ERR(vma);
>  			vm_flags_set(vma, VM_SEALED);
> +			curr_end = vma->vm_end; /* Merge may have updated. */
>  		}
>
>  		prev = vma;
> --
> 2.53.0

