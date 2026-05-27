Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 061B9CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 00:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CC4E6B0005; Tue, 26 May 2026 20:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07D186B008A; Tue, 26 May 2026 20:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED4B96B008C; Tue, 26 May 2026 20:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DBEF66B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 20:35:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4287EA04D5
	for <linux-mm@kvack.org>; Wed, 27 May 2026 00:35:54 +0000 (UTC)
X-FDA: 84811332228.29.1245AF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7369E40008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 00:35:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0riesBSZ;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779842152; a=rsa-sha256;
	cv=none;
	b=FQggGlOB3AkbyzPfLTYFBy4JPmTJiQ9WrTmwpbKWz9mDEJk+AmlIBkh994AS9xLtcmUU4y
	uo+KUaARNThnhpIJKHVYZvTunf7vtA3av6/eavzVXCjimofXM0WrnXM5lQrErTG0NVZi8V
	uTM2VzDVjYYv7hPINgKL+Rgs7bJH6zI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0riesBSZ;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779842152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8nAnhYe6Vb6K8/CHU1r82EaNMMrJl0J5U04ISDPErfE=;
	b=penaqG9a7sXIxQOYLiYB+/M4fC67/yly/s99oRjkNvTkwceNg27d4pZ+BD18CbzNf2LYsW
	vHRpxBHJzhi01VNojFjs2IpiHF1lrNNxKqfmcOtsE5jspP+VnvxlwyB1+RFFff/PJB69yd
	lV05Xa/CmoNPLsAvH7cVPrGAgtaXkRY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CADE3600AB;
	Wed, 27 May 2026 00:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9451F000E9;
	Wed, 27 May 2026 00:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779842151;
	bh=8nAnhYe6Vb6K8/CHU1r82EaNMMrJl0J5U04ISDPErfE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0riesBSZ8Ui/QdZ3f0Wb2q7DQUO6MHITwZGxhJfUor7uQaCIv2XUhy/+H81xxQ+VM
	 JXFWYM0fhOI+PU4v/qpBQkdkvPt8Ki4AacYwo1+cagyq94hYDCFzZNSJNs71JF7zv8
	 abZoUNFHEX6RAP9Qr00CNYj3/4+P7isfVN1IRgnI=
Date: Tue, 26 May 2026 17:35:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard
 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
Message-Id: <20260526173550.927ba4ba517e9af5a6d2c6bf@linux-foundation.org>
In-Reply-To: <d17188e3-a710-44a5-984e-689a127d4c1d@kernel.org>
References: <2026042303-vendor-outright-b9d2@gregkh>
	<20260424063817.552a894d4b5bfa4de40792fa@linux-foundation.org>
	<d17188e3-a710-44a5-984e-689a127d4c1d@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7369E40008
X-Stat-Signature: e97fxj5qs3g5x43cgbd3ehii6q9nryyi
X-HE-Tag: 1779842152-335761
X-HE-Meta: U2FsdGVkX1/ZcUj2H+Da35srjNYCOBuBQNpke37fhyE57ZSBF0rjPEIcABMSi/5TKlrbRXBDH6cH8LFkljjRVwPZKn20nEGosuMTd75zYCQUL5EdoEID/OJ0Cb4A5FiS7jYbO8ZVKZ089FAp/+mzLnkjyLTbZOKRzr5EVccwSju9BWJhN5RwFEFwACqGg02nQK5Y+yQfqEfapEvjB6hcr6J1WDa2P8B6ehWIWbNquCxR5wEZwKuq7XJia0aQlcRWdB6Kx5GRscR1x6++RfaHFye8NjxY+CSfgdReHFjDkuzid6ktnXL9Eact/LwUVL1AdErzVOTwucemO9Xrl9mm8cCzzeqOVNCHwPww+1MO5NtIxzHltq8YX7jC21mqyGi4OjVDf8USX+/J03PxI1yK3EXhQjlVBhiGr2EeR4JBUNPfNIUxVD76ogNtQ5qrf9up8A2uZ/wg6wK7zO9z+YIrvyUFgyPUIuhezTO9XddFrit07Schevf5D1+gtXlTFXK+qsk23AL3dMa8KyufOztHvAZBxx3H5CTZsKRP3n4XcI51czzMVxzaOXJk2BZ4pmdF/416ru35lqKJ3OW6hyZarqvCd7axa79rJRg39BonUlbZkM42Gxon38L+sWlVdNcpGA6uOKich0Ex6WefGYbKTXUPaDxYNKnTfpDp3+8PP+yDBoiMxBiMBeR6EnPR/hjIXjR/vRdNmnfvG9jW6EP2V4rR3PWSEoBZ5r4hbkfde3DwHAGGwo156vtNRwsxwVcNs/hbKXQlB6+p6rgxonop8QyikCW0A1OUc1y1C88behTOwHoQxAzQQ2C3B7oXlXpzXg5zYOACcqNziDOcEHbntoJGpxKdF9FRr9woY6RzCfYqXGbMKcS6VkW3SMieKDucdjZwsQ1zxWXJxdRq6vKOKDiOdVh57mg/nczIpRb+KJe4kMYhi3fbcwqj9DXxST1u8GagV4CAAQ2qUEjDw5a
 mSio8sGj
 HCxazaShmZuM9fL5ckDFTdtfK0d8GV0MwsAFcJDjVCKv+a0edtH2dyBLSyBL+AFNMdnWHIui7kqZKjCIqX4cttbpiBQJ0jVCoH9rePU2G3aKLdUNa5a2Q+aoJYVPqcJ5sP+9jNpdZyoogCqKN3qiOFGt2frWTmKSWtJIB4myNlLkbIbwWcihZIeOg1n0BnRrvyxwxDct3STfRaJ0ctxWvIpTHH0kGC9jeMCd0FnEh1qozXktr+/1ZkhG9CWmkkS2SbU69+g/Ju3Bkjn4Dgum7Z6ivVSDL4tG3dC52QdhKXD4VYdb8hZkTnk/wn8onZf/IiF/efPI/5wH+BrSpSCUOxiB3EZujuxFGmUQWGL1Gk2OuedfMhZqzNVDSx7nHydDVVqTnmCVNFMNAZ+kqsZ163nk9gKTQDT8l9xCwrHBibZ1LFuRAsPiaOFOynOFtQ6wJXUzQ55Gx8i+a3BMjnhO/WWRs912OzhkTWWn2x5QAsdnEDd86TT74o9sKDkYBVx/0ERENk4dp2OjX5Mccyv34Oei9peZO5jbF84nEBuHzm1WI49vkvHtIHVElCPkrVmHQ03hsOM5Q30PbhcUgfmQ2K1W20wD5hTUqG1m3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 16:19:32 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 4/24/26 15:38, Andrew Morton wrote:
> > On Thu, 23 Apr 2026 16:28:04 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> >> The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
> >> get_page() reference for each page regardless of foll_flags:
> >> 	if (pages[i])
> >> 		get_page(pages[i]);
> >>
> >> This is reached from pin_user_pages*() with FOLL_PIN set.
> >> unpin_user_page() is shared between MMU and NOMMU configurations and
> >> unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
> >> GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.
> >>
> >> This means that pin adds 1, and then unpin will subtract 1024.
> >>
> >> If a user maps a page (refcount 1), registers it 1023 times as an
> >> io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
> >> unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
> >> the page is freed and returned to the buddy allocator.  The remaining
> >> 1022 unpins write into whatever was reallocated, and the user's VMA
> >> still maps the freed page (NOMMU has no MMU to invalidate it).
> >> Reallocating the page for an io_uring pbuf_ring then lets userspace
> >> corrupt the new owner's data through the stale mapping.
> >>
> >> Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
> >> for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
> >> symmetric.
> > 
> > Battle of the bots?
> > 	https://sashiko.dev/#/patchset/2026042303-vendor-outright-b9d2@gregkh
> 
> It references the
> 
> 	if (pages && !(flags & FOLL_PIN))
> 		flags |= FOLL_GET;
> 
> I'm not sure if there is actual NOMMU code that triggers it. For example,
> uprobes uses that pattern, but I suspect that that's not a thing on NOMMU.
> 
> 
> Probably best to just squash:
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index ad9ded39609c..44bd28cf6e00 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1988,6 +1988,9 @@ static long __get_user_pages_locked(struct mm_struct *mm,
> unsigned long start,
>         if (!nr_pages)
>                 return 0;
> 
> +       if (pages && !(foll_flags & FOLL_PIN))
> +               foll_flags |= FOLL_GET;
> +
>         /*
>          * The internal caller expects GUP to manage the lock internally and the
>          * lock must be released when this returns.

Nothing happened.

Should we proceed with this as-is?

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: mm/gup: honour FOLL_PIN in NOMMU __get_user_pages_locked()
Date: Thu, 23 Apr 2026 16:28:04 +0200

The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
get_page() reference for each page regardless of foll_flags:

	if (pages[i])
		get_page(pages[i]);

This is reached from pin_user_pages*() with FOLL_PIN set. 
unpin_user_page() is shared between MMU and NOMMU configurations and
unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.

This means that pin adds 1, and then unpin will subtract 1024.

If a user maps a page (refcount 1), registers it 1023 times as an io_uring
fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
the page is freed and returned to the buddy allocator.  The remaining 1022
unpins write into whatever was reallocated, and the user's VMA still maps
the freed page (NOMMU has no MMU to invalidate it).  Reallocating the page
for an io_uring pbuf_ring then lets userspace corrupt the new owner's data
through the stale mapping.

Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
symmetric.

While at it, don't return NULL pointers in the page array, as this is
really not expected for GUP users; instead, just fail and return
-EFAULT.

[david@kernel.org: changelog update]
  https://lore.kernel.org/e9c5cf89-fa4c-4b83-ae70-9d3c72542ee9@kernel.org
Link: https://lore.kernel.org/2026042303-vendor-outright-b9d2@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Reported-by: Anthropic
Assisted-by: gkh_clanker_t1000
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-gup-honour-foll_pin-in-nommu-__get_user_pages_locked
+++ a/mm/gup.c
@@ -1983,6 +1983,7 @@ static long __get_user_pages_locked(stru
 	struct vm_area_struct *vma;
 	bool must_unlock = false;
 	vm_flags_t vm_flags;
+	int ret, err = -EFAULT;
 	long i;
 
 	if (!nr_pages)
@@ -2019,8 +2020,14 @@ static long __get_user_pages_locked(stru
 
 		if (pages) {
 			pages[i] = virt_to_page((void *)start);
-			if (pages[i])
-				get_page(pages[i]);
+			if (!pages[i])
+				break;
+			ret = try_grab_folio(page_folio(pages[i]), 1, foll_flags);
+			if (unlikely(ret)) {
+				pages[i] = NULL;
+				err = ret;
+				break;
+			}
 		}
 
 		start = (start + PAGE_SIZE) & PAGE_MASK;
@@ -2031,7 +2038,7 @@ static long __get_user_pages_locked(stru
 		*locked = 0;
 	}
 
-	return i ? : -EFAULT;
+	return i ? : err;
 }
 #endif /* !CONFIG_MMU */
 
_


