Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8BD3C9833F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 20:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7807E6B0088; Sun, 27 Sep 2026 16:54:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709236B008A; Sun, 27 Sep 2026 16:54:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F8466B008C; Sun, 27 Sep 2026 16:54:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32A6A6B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 16:54:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1922C40A86
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 20:54:43 +0000 (UTC)
X-FDA: 85260746046.07.3D7A770
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7238E180005
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 20:54:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=i6dKcdAM;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790542481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wezweqQqot1s/EhJa+Q8aOJlMWPiVKjcS+oT7p1UAYs=;
	b=N3IpD8mjwUF0CBdErOTB/hOSTGtdwNEJ5eTrenI8havB1RzJhV2Nfuib8Pq7W7E8AQAcmS
	bkncSjux58i+GuhIo1Y09lqgz5/zU2OOV4/RtAtSLWi6asoLVM2ukXgsTdvVL8/SDZNIfZ
	GgWGRvyQjJHO/ipQADq3CahkgcBDFMI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790542481;
	b=2dRbCc5V/FVobTnfR01Rha3MuEZm2Fb7vN+hf2ZneZEfTrq1PK5udvly8dqQABUO0RJLtJ
	Pmoy2xlw8XyMccxqVWZobtgZyVHLpGmiBGoJDiMr5oo7jGcPTQLcDsZXW8aCizOLtDf/fH
	J67w0xpYQoMJ8HmmxTq8sqDyG9sdVjU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=i6dKcdAM;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D7B51600E2;
	Sun, 27 Sep 2026 20:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112A81F000FF;
	Sun, 27 Sep 2026 20:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790542480;
	bh=wezweqQqot1s/EhJa+Q8aOJlMWPiVKjcS+oT7p1UAYs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=i6dKcdAMiqAgmpOl0EbfWmlKPvQQ/8TRbP8UEKnJN4TGjxlCgajWk7053GgOcx/Fu
	 IMdCKOG7soO6PIDFHc79lxiu0GVPJ8hlOBUzRUtQ8ArJu4Js62nF6CY+lxUQXQPGbs
	 fbbAW0/NLNvVPW5GDG5BEkcqH+Djx8Ji/1m+Wwng=
Date: Sun, 27 Sep 2026 13:54:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: rppt@kernel.org, peterx@redhat.com, surenb@google.com,
 aarcange@redhat.com, david@kernel.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, mhocko@suse.com, shuah@kernel.org, kirill@shutemov.name,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] userfaultfd: clear the inherited uffd bit in
 move_swap_pte()
Message-Id: <20260927135439.094d75bc42414879a6e21c79@linux-foundation.org>
In-Reply-To: <20260926124145.2878520-2-donggeunyoo.kernel@gmail.com>
References: <20260926124145.2878520-1-donggeunyoo.kernel@gmail.com>
	<20260926124145.2878520-2-donggeunyoo.kernel@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 63f5k6bhexc9ofukzroww1wicypeiqeh
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7238E180005
X-HE-Tag: 1790542481-810680
X-HE-Meta: U2FsdGVkX19bC2zzyFrseO7W4DgWDmE9eX0A08PJeMvjqenpPLGTricqSUULH0iX/Qua4IxdvHYOv+TQUi8tOfV7XSWuamGSRoDqg6e6w/oIpviJXxRmst15cJ1EKCqg6Q/2H2Th2l74yJIwXOSQQ6ZWpGEXJFTOSf+aFv0Mv4eUaNvMfUwdk2US+4My2LtoO7rT4KSo0b/uXhsq7+lWW3xP3CRP7/Gt6/U/TbMYyJbQbdwjsvL2vG86Elnq/CJTSyovyDNqT/4uHADw2gNO7h1hip6Z9jPT3lXKkSoqcWKyB822dHBjNskMHj1kyropT1np5m3xWMnUF+EW+PaWcLt9QE8395het4U3hQGvHHVGORhA8Zi2QObF9FZ3Qh8iyDXOHzkcvrjYAkoMcHhdZzeK7KjrIsdYeNgNQlRd/QWg+FIS6rG2Rqteed9qClh5VEjaqVbDp7qB9ZvoWKK7aYvPmH7VCTyXbHVFTjaNmVLi+b7KON+w3Y+69xAY53u1uJBiGUFW80eMRCzJZoaPap0+c5lLJAKc9nmYD43WUfCUvHgdCLJelrcl4cqoKiHhcAVzIg6blH3ZjzuDeqKxj162xv3lHdAyPKD0htvRjTjtbwhfq5bjXpdRB2iU/44pYNGmPC0uDGI1C9w4OMogPjRCxoLYVEJ5yLoVnD8QhpWKX+cI7Q1lEBrAnJEEE/mKnAnfxrATaSnBP05/gqb2bQi6pVhW9BZgy8eejeGcCAFa19AtTXCC8yzZlJ2KYJuuQLfmqyivl+boIj9yEAyrZMzKliHrQxzovLxWTI5gCHeVF7uBa/6nMgJoLcjTtl0Uy3tL+gjmM0VkIlYQQmmwiE+Y4AZ2G+wa7sndMJjARiXZ0B69QGvJBkkHx29ecqeZFEltrcLpylEzpAA7W+WkEOa4PM3G7yO7sTNF8uc19/2SjcKiyK/S1mSV7GB+yKhOa6OYT7Pf909jvXRDkju
 DTyJLPwM
 pHHZu7wmDztBmgdLyjlqZ4sY4b+Zj1pLarHjOE6pjBi6HC58lEX6lhbxzjxQ3BAZCZWCq0gIXX7FYZhHLbydW+6eaPKYhilqsb85HLmXXcCEgu+FLzVPWIYqHI/Lt1iqsA6+tz21v6wyj2FifFRSvrwWtRNHxuUskB01m9C3t+VhYDeAbCk7DeU9MMRcnInAEc0r9JgRtxDwU2yHKdgh4uy1VzcU1kG7WY5Z0A9WLkXOZNsjUWLbszMoaUaDvEy0Q2Ph4gM6LKvzmQbQvykEoZAjIPimZov151QFyDXHMcp4FNG7I5lzvV9pBXzv4msFDtHKvoCKHZm7N47xeo35DqUU8I7743JpwJqzwvdG7e1SO4aT2mkS0IABPp8+q7NWLoyZum5eVZIZC2ABkCWdNSszvtoZtXWucIcOT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 26 Sep 2026 21:41:44 +0900 Donggeun Yoo <donggeunyoo.kernel@gmail.com> wrote:

> UFFDIO_MOVE on a swapped-out page installs the source PTE at the
> destination unchanged, so a uffd bit set on a write-protected or
> RWP-protected source lands in a destination VMA that was never
> registered for either.  Nothing clears it there, and userspace sees:
> 
>  - /proc/<pid>/pagemap reports the page as uffd-tracked (bit 57), both
>    while it is swapped out and after it is faulted back in.
>  - MADV_COLLAPSE fails with EINVAL on a range containing it, because the
>    collapse scan bails on a swap entry with the uffd bit set.
>  - With CONFIG_PAGE_TABLE_CHECK, faulting the page in warns.
>    do_swap_page() carries the bit into the present PTE and, since the
>    destination isn't WP-registered, also makes it writable:
> 
>    WARNING: mm/page_table_check.c:202 at __page_table_check_ptes_set+0x185/0x1e0
>    Call Trace:
>     set_ptes+0x67/0xc0
>     do_swap_page+0x990/0xfe0
>     __handle_mm_fault+0x7d0/0xeb0
>     handle_mm_fault+0x9c/0x250
>     do_user_addr_fault+0x207/0x650
>     exc_page_fault+0x65/0x150
>     asm_exc_page_fault+0x26/0x30
> 
> Reaching it takes UFFDIO_MOVE out of a WP- or RWP-protected area into
> one that isn't, on a page that is swapped out at the time.  It hasn't
> been seen in practice.
> 
> A resident page doesn't carry the bit, because move_present_ptes() builds
> the destination PTE from dst_vma->vm_page_prot.  Clear it on the moved
> swap entry as well, then re-arm it if the destination is RWP-registered.
> 
> The WP case has been there since v6.8, where UFFDIO_MOVE was added.

Thanks.  This is triggerable by unprivileged userspace, so can
reviewers please prioritize.

> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Cc: <stable@vger.kernel.org>

This should be whizzed into 7.3-rcX pretty promptly.

It's not really appropriate to give the selftest such treatment - I'm
never really sure how to handle that.  I guess I'll keep things as you
presented them - both for current -rc, [1/2] gets backported, [2/2]
does not.

> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1449,6 +1449,7 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
>  	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
>  	if (pgtable_supports_soft_dirty())
>  		orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
> +	orig_src_pte = pte_swp_clear_uffd(orig_src_pte);
>  	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
>  	if (userfaultfd_rwp(dst_vma))
>  		orig_src_pte = pte_swp_mkuffd(orig_src_pte);
> -- 
> 2.53.0

