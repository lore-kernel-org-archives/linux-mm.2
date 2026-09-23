Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E2B6C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 11:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D55E6B0092; Wed, 23 Sep 2026 07:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5966B0093; Wed, 23 Sep 2026 07:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC4D6B0095; Wed, 23 Sep 2026 07:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C64F6B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:20:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE5BE8077F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:20:58 +0000 (UTC)
X-FDA: 85244784996.14.41A2FC8
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0961E1C0003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:20:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="L 98RMmX";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=qU+wGpuY;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790162457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ktiZUKec4B6HZzJ+HNFJ4iYy4188Qhi+lPMjiYgieJ0=;
	b=jNqkLRepEpuVduwULgsZNTjqBrmKhMNchEFSKWGT2c3TsTpiwssAWHBA7E89dvRvbz13Uc
	e4CW1El0d6hM8hYq4s/gM54YH92k7/TmwgNpJtsOFu1zLJPJRO1z7dr/LLwUKn0PTyLwzJ
	gAQWVLUOq6yCcK/qjaIfWeKkJp+tae8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790162457;
	b=IDVsIZeAVhBx1aNwum3CCSiSNgZbBowYd4/jOkbK121bU+uaeqZ5YqTlphG3300/wW2SBX
	65mxWghEJN3mlmu2lRNKNq1v+1mjpYBmIEmdDs+0L7t/hgj43ZuMwfvSTGxX/6DjPFpgq9
	BeTfbdNX3xmXebasVagrrIvKA/ze5+s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="L 98RMmX";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=qU+wGpuY;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 8302E1300181;
	Wed, 23 Sep 2026 07:20:55 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 23 Sep 2026 07:20:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790162455; x=
	1790169655; bh=ktiZUKec4B6HZzJ+HNFJ4iYy4188Qhi+lPMjiYgieJ0=; b=L
	98RMmX2tvfQopY1x7eEjV9sTfX+l8j0VI1k01xg0D+Qmrf6ioEAr6nemXKJ4dxEF
	Oo0TffjnNinl/3GQd41+cnNNgtg4qBrj8TCx15p3Ms06jdCn2azCvucDkwtJ59wz
	D8pBs9Q/MR66hU8HkUbZ2JQn870SHFXEnOTEDPtZj1qWgX1+qXkPemxwRzE1le5L
	ah2OxvHYyfs9IcLHMn2UIOaig10RjgR+L7Rdtf2zsO+HdX/N877mLo9iuJNaKb3E
	hoDQTgzxAkx7T+74Cgk8VPWla70HDKmtNgZEcwpfUcjo053579zNK7GmFV1L1H2S
	RgmKwDx6qpP2AKh96RWhQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790162455; x=1790169655; bh=ktiZUKec4B6HZzJ+HNFJ4iYy4188Qhi+lPM
	jiYgieJ0=; b=qU+wGpuYPN3hKO+M+jMFavBC8IWCUdrgpnyeGM0ze++b3XJa6mF
	a3qcuTyl1sXjHvU/eQpeGl+3lyCo4USxjMw9vF1QOuc/kQatBAUK+OroKgEja0gD
	mjYsBl6z3PHOjM9SuWCITnRBzVDpDUfoJCMONZ/G2PS0lGzAfLJ3eGdrlGIPp5mr
	dc2a5UTOjGmzvrQE4owdPur1EqZ8Gl8nvo2N2gAAWD/F0FYTh3k73xjRxv63hYJ3
	5RZqDt3BuW7aNxcgk898YiHLq1w98JDIDrXq38aVvoEoRW1HLmwVZ+WXxJmtbv4H
	sWidPGjZU66tDqqUBzhZeOnlHtyL9E4Uhcg==
X-ME-Sender: <xms:F7azavxogpDrfF4DNFL1eKcZyaLyIifkD3nR1ZRYKCDBCzqdcNT2Gg>
    <xme:F7azapm_Ip8OGxjSen2YTfdBmEHNx2nSn0zexKKF-LjZciNHf-j0cjlG91DTqDxLk
    ul2OFHNIeEUU6UGQR48HqSLu0rzLpWwp9Iww_ke3fCOnTi-8yRcrBE>
X-ME-Received: <xmr:F7azaoBnzmW26a655BnpjHaY6rH0AzBSlqHQJW9OtSleJ8IE5F1hl45tHrc>
X-ME-Proxy-Cause: dmFkZTGYKaX4MJrWiZQMObUvdDS/QWbPENP4/QfruR5BVC0vDr3fwy8UqZaiMm19WVvCJj
    0rjC2wvVme8pZCZK4Hk73qsmr2qCNpQkL2lxolYz2oT+uCsVBU1r74piGSnXzeClBinZV7
    y3sxhX+8TAkchK3N+UMQqjVLMQq4uynP4uBOC2y0eE+zIaGoNSwYA6DO1H17PSNo7adr3v
    zojz82agX4yD8xYnPoAfAweqTZDQka1uyTOk1rUyA2wF2i+pTDCXEHTcXXCXckIiOGFMS9
    RF8C9KpMBE6BRRNKbAjci9rBuBiDk4EEvDDezb/DoxDzAECoRSW1iKrymdowfjbRej8fo2
    1fWqr2HTppvuYAkHu+XIoVQXJOiBnpn14qMCD7wVZMNdSs8WjzmZa0LCmexgVyTst7xXCV
    8vrC5ID1UpF84NYRlV5wWUzeAeZrT7F4j2e/cj7Zx7V53e201mLuDIv+/RuQ0mj/VgPgvy
    9sVH1R1Ngny8Rf4YlRIVLg9pOhHQTAipWD7r2nF0cQSF+vvqJhDIzyedY2MCw0+Tua+wuO
    Cyx1D0Y8G3TrhzF0t2c7Fbnnl0ebdqM3oNftdN4qhfBYE7OA1G6iijrPP18j85XPYmw4qi
    eevpq4izXY2aoM/WK135q5sIZ31zBMEPadTnZfXdg7nTknDl95Pg2+lUFqAw
X-ME-Proxy: <xmx:F7azamcnDK08mifL84qQeuza90uRKs54JJQcFkR6hr9HwM5sWERw9w>
    <xmx:F7azauptGNy_k84Tb9wPHFq9GIwU8W_MtL3tfwSMZP09VJaKfgKzGQ>
    <xmx:F7azaqK4rhh7EUVDwIAsIoH5zX030UctfN-PANF85p9THr4j5d3mlQ>
    <xmx:F7azavQ-EzhrMhKhAa63jnDmwRhHHHih65emu4DYNKz-CTtzoF5cqQ>
    <xmx:F7azajpKXdNZS_Ql3gtTIKKMJ-xv-1D89RkX7k717JM6Poi4E83vb7G7>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Sep 2026 07:20:54 -0400 (EDT)
Date: Wed, 23 Sep 2026 12:20:53 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Donggeun Yoo <donggeunyoo.kernel@gmail.com>, akpm@linux-foundation.org, 
	rppt@kernel.org, peterx@redhat.com, surenb@google.com, aarcange@redhat.com, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, mhocko@suse.com, 
	shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] userfaultfd: clear the inherited uffd bit in
 move_swap_pte()
Message-ID: <arO1r1NfMVLPwqtQ@thinkstation>
References: <20260919004630.1159895-1-donggeunyoo.kernel@gmail.com>
 <20260919004630.1159895-2-donggeunyoo.kernel@gmail.com>
 <49208ed6-6c20-49a9-9c0d-0e1cffe1898f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49208ed6-6c20-49a9-9c0d-0e1cffe1898f@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0961E1C0003
X-Stat-Signature: sozgt5s7t4op7fjz8p4ia1ye3n6a9hbw
X-HE-Tag: 1790162456-237321
X-HE-Meta: U2FsdGVkX18qn40U/tbgjGCDs/Lw8+FfhoHgAfaqw7vzU7zUOQh9NNFXRBBR1kYslo0vTGCq7vgTwPMj7ysan7iu1qGKx3M7mVvdgyZ7eOO3FjtcoANdaaYZPSWau4kDAJGwlfPUDqGbRefbJhHGLfaIalVb0jyt1/2b3S6A2H6zQQvRFQe+JGL5Ih5G7wOZugp18KbKvZ2jnOqZV42p2GJLI8C8xdHFwOt4wLPgn/buDs8pbNTwd4xKukK+FFp8gSyA9Md33UzMcwC8KlLcj66v9qcxtyVJxYBMKH5LCc1Rtv0D9uVKDnLfaLU9wD5r6krmtobB4d/xGGqJesYYgoL2Wku0/bhvqViOaJeV899gMNgv4Dfy1UmJXdakhxYmE33+BSuqyHkiQKNbPXVA2KKZPA8fpfsBt/24c2vpri4ZJgGUocaTcGWJinqgfmq6Ko+7PqptzoJ39h3mCr0fWeNDR6t6HwhlwJ8d/YwlTkYo7N+wJFpMEAC865kYSMyxCbNmIf2EtEEwPuWMfYezbo0c0fLR5HUTU9hD+czFR1MzxJFWrvvXipVbznep0gD6LFWtNxKEo1MFh+ZKg0tmSsqhCiI3NtuUbXGL9zes0gIzXfDJsxMdtKfS/fvXZkmzYwzVZ38o8G9J+PZK7FBdte1P85AiWjd9XjWeMt0UBkaDG7i4hhN2qEN27bYQqZjp2pJ5388YIM2wQ789PXHleROSQ3znoGMu8j6U4xH0v0h/uEGbAyqnjMDTF/pxvyRv3QHPKKWyiUnUcWooqhdf0ZPjXMLcJn/BmCgXMS21MA+EwAjhIlisxWnNAwWon0HLJrWbc1h0hh63L+vAV9F3oTlSOrL/ZveAcxJpCEAwXSj5H/6Mqhvnbtg9cVVl58jzoJsfwiM4QIKTGXzHUFrqGOTeOGi+fV1XihV/uB3BSYirlFnFlOMMK+gXoK3zftfLwwJ1Itu6EAwzZttcF/Z
 STcvPl+m
 Ocm+cM/Ji83hLZXf53Y8/gcGjIFEcIqV7gAwxXmC9xDHT0vDUVZP2VY60eW5gxUehGrh8lH5oXmGZRLshVPMvEEr61pEWfME6M593IbS6SYd2gcZFGSsVvA+JTHrRRNfOj0qXny1AIIUMHgOlY8T7alnm2cdISZZm+CXFgjrX+dg8FgshqvwjPxw0WhVHx8x8cAm32SIJ2xlTi07zEAmN0v8JyPVuaJJ9Ea3KYwX7hxqyM4TofR+ixRBeHdzdIJeVH5RGapc8JTpuX+5jrrgCOKREg/obClrRrTyB8CbgLrDz45dViBquLG115EaaNJ1du+XXJ34S4Ywsxe9COLfsHhQbzFFg8j5Fr487RkMhOdXHNnd4gePsGPpeoWUafpl+kd6UMMTJo5cs3qdUaw2q+zI5Z/71V63ECWNkDmGjBamdv022TpXJ/fR8s37neVndWGjK8EbTjFaQFzIs6WXCsiZEYhsitSXIuQTWpHs32pt6dtFgVWTLEAJZFzVdnpC8W+0ig8qNUfP3kNjxOFl0LE01TLxcCcfsd2VsSBo87kT6YA8laF8C9VEtTf6OID5hhLdUZ1LTckQOYDsmyPmo4SoFVspTvkLABYqzS0jQjVoInB0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 01:40:51PM +0200, David Hildenbrand (Arm) wrote:
> On 9/19/26 02:46, Donggeun Yoo wrote:
> > UFFDIO_MOVE on a swapped-out page installs the source PTE at the
> > destination unchanged, so a uffd bit set on the source lands in a
> > destination VMA that was never registered for write protection.  It is
> > then permanent: the bit is dropped only by change_protection() under
> > MM_CP_UFFD_{WP,RWP}_RESOLVE, which uffd_wp_range(), mrwprotect_range()
> > and userfaultfd_clear_vma() issue only for a VMA registered in that
> > mode.  pagemap reports the page as uffd-tracked, and MADV_COLLAPSE
> > refuses the range while the bit is set, because collapse_scan_pmd() is
> > strict about uffd on swap entries.
> > 
> > move_present_ptes() and move_zeropage_pte() build the destination PTE
> > from dst_vma->vm_page_prot and arm RWP only when dst_vma asks for it, so
> > the destination's own registration decides the result.  move_swap_pte()
> > copies the source PTE instead and only ever sets the bit, never clears
> > it, so one UFFDIO_MOVE behaves differently depending on whether the page
> > happened to be resident.
> > 
> > Clear the uffd bit on the moved swap entry unless the destination is
> > RWP-registered, as copy_nonpresent_pte() does where it installs a PTE
> > into a destination that may not be armed.  A WP-registered destination
> > stops inheriting the bit as well, which is already what it gets when the
> > moved page is resident.
> > 
> > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
> > ---
> >  mm/userfaultfd.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 74f04c323c50..6495666c596b 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -1452,6 +1452,8 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
> >  	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
> >  	if (userfaultfd_rwp(dst_vma))
> >  		orig_src_pte = pte_swp_mkuffd(orig_src_pte);
> > +	else
> > +		orig_src_pte = pte_swp_clear_uffd(orig_src_pte);
> >  	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
> >  	double_pt_unlock(dst_ptl, src_ptl);
> >  
> 
> In move_present_ptes() we don't run into that issue as we create a new PTE from
> scratch
> 
> 	orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
> 
> 
> Staring at the
> 
> 	if (userfaultfd_rwp(dst_vma))
> 
> I do wonder why we don't have to take similar care about wp ... I'm sure the is
> a good reason.

The RWP branch does not preserve anything from the source. It arms the
destination whether or not the source had the bit.

WP has nothing to arm. The bit is per-PTE state that userspace sets
explicitly with UFFDIO_WRITEPROTECT or UFFDIO_COPY_MODE_WP. Registration
alone protects nothing, and UFFDIO_MOVE has no MODE_WP flag, so a moved
page in a WP destination starts unprotected, same as a faulted or
copied one.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

