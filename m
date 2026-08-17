Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF755C5DF7D
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 22:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4DF16B0114; Mon, 17 Aug 2026 18:26:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1136B011A; Mon, 17 Aug 2026 18:26:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7B3A6B011C; Mon, 17 Aug 2026 18:26:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8278B6B0114
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:26:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 072D5140971
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:26:09 +0000 (UTC)
X-FDA: 85112195658.10.6BC9F66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4FA51140005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:26:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=h7gneX+8;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787005567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1b7jKWdEZGMoFyuy609fAfk/mYE8kL7oO5E00u5yre8=;
	b=edGlmkk6QsLOpjISEk7vDku0EKFtWQ5mu5GvauwGsiqX0AThzmmuPwK0XRYpVuVfpxoZRf
	JGkQR7R7WO0cT3WRaf7Hzj/a+IxnpS1Vm2rQjqVGEjfCKRwd5BG0VSxacmgTKIricGil4n
	fw3UExRnhIo2oT5C1x0lZtg60y37E7Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787005567;
	b=6rIg7EscP/CNZSlKoI/wPRpQsYdJT7oGKroUGMiyZgBMQfz/fXO9BkJw/Cp8me1pqxdJeS
	VvJn8u9hs3Cyi0KjBLJGAbjhq31/rKK5GcpuSmMcNhKPFeZB8b65b1a3dI4L3fTyIntt2T
	+QCl5lVwW+kb+kjrUCznR2r96zoLiO8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=h7gneX+8;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C8BF42A2C;
	Mon, 17 Aug 2026 22:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDE61F0156A;
	Mon, 17 Aug 2026 22:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787005566;
	bh=1b7jKWdEZGMoFyuy609fAfk/mYE8kL7oO5E00u5yre8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=h7gneX+844xS7D9EO+tsMQ7wp6/YghmaCMnHl894psOygzK3Mj/axlnr34fk66c0+
	 5tZ6gmDpB+oO20VFntrD0gNXzjrn9GF3bx+oLVctjc3kS2xjTLlROXE0k/Dzjr060E
	 22xjgVprrQhGA7WygH4Cp5plfcOcb0oPP0mLVaeM=
Date: Mon, 17 Aug 2026 15:26:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Foxie Flakey <foxieflakey@gmail.com>
Cc: rppt@kernel.org, peterx@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
Message-Id: <20260817152605.5d2bee3fbf1a2bace4c0eff1@linux-foundation.org>
In-Reply-To: <9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com>
References: <9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: df445t55pg8u7wbj8ek5wy781er35b8b
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4FA51140005
X-HE-Tag: 1787005567-782199
X-HE-Meta: U2FsdGVkX1+mZ1+mVqIET0BMuIDsumWELlU3eWIxgoTQQPtDrBaTpS1T5ahoSSkkLnxSenBN9w8inR0eTv8NJjrTdoc/w45WEJ3yB/TwH2QFz8Hj2TcbAO3pF/+qqvZIVtFGw/9IIfd+0kMJNc/Ei0BD2DkrQ5EfkLA2jgETQqWv62ZVQ490KN8OWFHZ0Kw+F7XBoYpUdeTXn+7Quwf4NGywhS6v415EwIdoVaB8j8yK19hhxuAllvHXgRKaLH2xiUxE7mSTSuHXTWijUe5h4JTLUjk/qvI669+LrUEE3OzMOZaNWjAhqtgUQWdc/hy5QOZZYqAdll3HyUseDVwzsJqqMZ+xBlzILgwxdSz5SfKA3NItS07sDEq+VNFs5ugruyAXRgblr+vRrk36qHu1c2wj4aGfWwjPCBTqKWuoPeTul0B5JWHqppMhxGGdfhL3L025A+K5xoG6owhPS1tPPkufn9DZfVeGD1960i1r7mHYxwmfUnGT8T/25z4oefbo9vHePvH63BAvy3EI+ox/EDmWP86/LbDGI6bRtrVLAbpCGGrdH/SfBA41lZeXgoPuFhBMgC0pojCojJIrgUxCFZqz5iAcyyXOcpdQcWobc1AGy71TSVqd7D78pIhpZwo32D3ZurhFqfGdQqWwiAHT0Ymq1Edry2vIR+ULJ40C5eanyLr1vGO3udEcBx9XrNcgU48+1yo54szHLpyBmhb+osmswTDBMsjv8i8+01JQHyr0IGPMlR9/eP1iszrboW/qXxUboTKQ3qtkFAUdxV03txuYSzD97vOyDD/+Mx+0ZSJIWvgShpA3mEHBTC4km96rvq1eho/I1cnvd2DOtvfFsttyliuVRnBz1mRY2DoYwcpgOLFyD0mhuqUm6jPlBj1jHzVWdaqYr0OkmqRzS1i1phlwe894EZDpe4tZbHxAqZOBAgKZZQ1nJB+Vofbp0R2TCU9vc7H+MpocwQTC5cZ
 W0dsnaNG
 6bs2h+xkMLjK/rZImd2eLU3XI7Ju9778X1d87vZl//Iu7scUGPY5a7+Nef6uwZR8cj+PCB+XiSYLyxXuL5Pptn2iyPOyl1j84PqwW0aoCzNO4GG5RrseCUvvnwBWqS7RULFOeYFcZCg6Rtpgjf1v9fzQ8U3dvhQ39oDD390VrL41YVGOr7KIxobxZpOArIlORd9bQnt+qHqYVTKHPjBZLp/lvo7jgn04WyXuj8ttF6G/VbDXcgIsiWymZ0rZRqZdwrEkCbdVkO0jsCrvWiMODLMTrzoiWhrdUfuPTE8eBr4zWi+AT41h4ebX2LNsxQVE90z3pOpHx3FXFodU4iJLNTw9Jx0yr20utVMh0zJ0VZKt6XL0TJ0vvhj7Cu2kYX6dQNt9W0QjoL5EXTePCtgVmcMqdxJvKY20TkYh8xcTWSri16UXtJExaU6KnDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 15 Aug 2026 17:42:12 +0700 (WIB) Foxie Flakey <foxieflakey@gmail.com> wrote:

> 
> An fix for edge case can occur if move_pages_ptes return -EAGAIN, later
> when checked and it is EAGAIN, outer loop would retry again on same page
> and succeeded but the err isn't reset so the outer loop would think need
> to retry again so it goes back again and move pages again. On third attempt
> move_pages_ptes will fail because it already moved and returns an error
> that is not EAGAIN when outer loop checks again it sees non EAGAIN so it
> dont retry and break out of loop. When loop is terminated it did not update
> the "moved" variable from successful 2nd iteration.
> 
> That behaviour manifested into this at userspace
> 
> Source:      [ .. unmapped  .. ][ .. mapped    ..]
> Destination: [ .. mapped    .. ][ .. unmapped  ..]
>                           ^     ^
>                           \     Kernel moved this far in actuality
>                            What is reported to userspace on struct
>                            uffdio_move's move field
> 
> When the previous behaviour is
> Source:      [ .. unmapped  .. ][ .. mapped    ..]
> Destination: [ .. mapped    .. ][ .. unmapped  ..]
>                                 ^
>                                 Reported to user space via uffdio_move's
>                                 move field

Thanks.

The text is a bit hard to follow.  I asked Gemini to redo it and
perhaps you prefer that?  https://share.gemini.google/cOWn3pQadvVw

> Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
> Signed-off-by: Foxie Flakey <foxieflakey@gmail.com>

Yes, the pseudonym is problematic - it is contrary to our written
rules.  But I'm a sucker for fixes, sigh.  Perhaps if someone else were
to send me your patch with their signoff also, the rules would be less
offended.

> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2069,10 +2069,12 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  			ret = move_pages_ptes(mm, dst_pmd, src_pmd,
>  					      dst_vma, src_vma, dst_addr,
>  					      src_addr, src_end - src_addr, mode);
> -			if (ret < 0)
> +			if (ret < 0) {
>  				err = ret;
> -			else
> +			} else {
> +				err = 0;
>  				step_size = ret;
> +			}
>  		}
> 
>  		cond_resched();

Maintainers, when reviewing this please let me know whether you think
it should be backported.

Sashiko did what it usually does when we make it look at uffd:
	https://sashiko.dev/#/patchset/9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com

