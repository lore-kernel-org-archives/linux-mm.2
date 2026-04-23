Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D640F589CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 13:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C30F6B0005; Thu, 23 Apr 2026 09:00:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59A5C6B008C; Thu, 23 Apr 2026 09:00:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7436B0092; Thu, 23 Apr 2026 09:00:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3BECF6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:00:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D741612016A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:00:03 +0000 (UTC)
X-FDA: 84689828286.07.D35ACE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 03A0B80002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:00:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=wjsCD++q;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776949202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=agOwW0PTa7h95/wGdLXX8a5q/5FYuc653sa/RsWuQtw=;
	b=vIayWJIvQPDxqGSNhcJ7YarMohYmh4QZi9IuqSHuGU+f8W0hKJO9pl8rZEjTvr5V7vYJBN
	+qgfd2r1TpUPzB1RXoCNfAxnbLfZRE0Dg9/roPxVRdqLAUxXkdswQdBqjkqiqB+IpF3VZ1
	Q1j5QHRacsIharMNvJJ7881wlcMpoek=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=wjsCD++q;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776949202; a=rsa-sha256;
	cv=none;
	b=Wk621VucVFkeprSmuJJNDx/6arDKUADO0jZOji7x16yiEN2UBWjCbcsBj8rmFU3aKpz/0O
	CnO51oIjbqQzvDvAvXJQpkW4SFjvr/rPDqyjeqUfOia8KkBlzKTBf/1LSv4AMCuEiv86vY
	4rBkMJFLBJRbMNoMSw6nUagbeKiGFK8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E8E0E40494;
	Thu, 23 Apr 2026 13:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9F4C2BCAF;
	Thu, 23 Apr 2026 13:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776949200;
	bh=6GbEckYSnZZ1ear2oExA9pFYBwoNnXW6rLGISNYHF1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wjsCD++qo04kgcNKA2OC1fTlPBtZbLJZClDxjzBZpRovMVUInvv8FDzM+BR2oN3MB
	 DR1F4Ncc9iQ59SOJBjnLlKVibewh1UAoqlJdk3phiDRbyNogph0Z7xMAJb1RSNoUlv
	 jdH97HKSvf8dopBVzQkwoNbZMacB3y0K/JcrN8N0=
Date: Thu, 23 Apr 2026 14:59:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
Message-ID: <2026042314-traffic-riverbank-d9a1@gregkh>
References: <2026042334-acutely-unadorned-e05c@gregkh>
 <dee5b7e8-864d-48b5-99cf-282eedaba927@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dee5b7e8-864d-48b5-99cf-282eedaba927@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 03A0B80002
X-Stat-Signature: y7wuds3apwtffpf7uts7aayj9t7hfn6t
X-Rspam-User: 
X-HE-Tag: 1776949201-63309
X-HE-Meta: U2FsdGVkX1920is1Rk62xZifhv3idj68rQsruB5aQJSe8OOqa3jOcyGA8jjpGsvBcorI+smol2wNy5aSbka+g4+BGAU/sgIB7Z9eqoYTZpKGgmuNyVQUrhTS72AXZduIoRrrHGZgufro6ramsJE8Yoe+kbk6ZY8tZDAlZn4VoarecXlsK4ztj+Gb374GhXHwRRWsq5fakCOc/w+jO3fvGILDPSyrC3SdKapOYd8bDOU0Mb656T9V6vC4Bypc+bVPczrpoKMDsP+++WW65n3yWBk2VbxDr5NGvUgawe1X1dF34bC7tZVHFasZ9ly5oSd4E9t0uAQQfnSxOrizWI9P3ECKL9lPjIcL679nmBWlkYe0S1+Mb5qoowxBryFC7mM/sIQJ+9Gn2ejDHR6b1ior8MNbtGCfmMkYiRcb2UHe2Tc7joSbRyKvJmkKPcJ6rv9n5BF/z1hs8YWgeqXgK4wSv2W77wFbeDIFqZbu9m3eCXS7y/JrDeqWT1bRpvVheTtqRnERSgnlmaYRsUoeOnB3RR8z+WyNtDLMxOXOsj5hTQtaarfnurqVbFhyy4CIubMYcIi6eTI41Ujnyidag6rJqzeSBaKrscnyE7rhst47gwRtyLxpfn2G5RoeVadP+XIR0fNlpoH+1MuGi224r0i576+F/wP+WlGA6yEyqilT1PLrNGcFZ0WFMtMpNaoZnZEUdmEDXzVtlINReeq+DCluGZ5MKSjx/GRcq4Rrmra5UXngVTJURKikb/E65q62ebkT8yJxG84M3V3dp3UUfoJUljGBCOlJsW2ymeRJmGnDqxxOG5v5C2GJu0nQdGHtFuybgMfpOlleSCBVy5HTSIwotODiWs+V152rA9eHoJSQGtuVG2Iu3zhFL3wCT+UmQC87pMOp+IZ0geOLQYdQfqinbmkE2/k8+cUykwI/pugB3UrdgTFoiF0F5R1mcPv33v22vjKVnw8Vbdqi8nZoqMf
 N1PLReOC
 011O6Aeym9+kMMIw9d5V5Y4Vc0RGRTL7m/0qXeEtX+z34euGAczR25iZy0mCKrnf6e5W/11kP9oYC5Ip3CqAXClPMOTsVuWim9Edh6WRg9yDxHgO5uIQTZu+rTRdAs7YtEu2oHwMadluFcGN70ihyX0WnQ/ccYeIiQnVv35AFp78IpQFCFpqEPk2Z3HNxetBjCaayb7mcp4DSINHN3XweQLLsXweCdLgetVzN3top3ABBGxaBS6CA2NU4e6U5vcwdBOUfThmAx+PDJPIKFE6LfeImgZRoyQnkgCEDJTl0x6kZ91dNJBfCs3UKd4oYDNYXHs/FGhYrSX2XSuL7WQqRRCVEV68egkqW9PfWQFIIJCWhpecVLwcMehQiKI/bygead7V3A6MZSeHvV3+lB8o72L18q4IoGY54psm43+rURWcYPJrbxwX/CNX6g9lz2hyQs0YoBGAEvmUZcEWtEDp3ozLpQ+L4bxuGzdMZ8id/mMbCIHV0sm+4NXV+fNgDeEil41VJlyfRaJF0C2/ML8U3ustP6V28MFQFC75KZ/d6efuPFlwA0WuilF4FkW44EAgn0iIjl/ytJGLfFaJPwcYtBnl2EPZwp5LDCCZ5FkjLQZupFno=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 02:47:23PM +0200, David Hildenbrand (Arm) wrote:
> On 4/23/26 14:31, Greg Kroah-Hartman wrote:
> > The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
> > get_page() reference for each page regardless of foll_flags:
> > 	if (pages[i])
> > 		get_page(pages[i]);
> > 
> > This is reached from pin_user_pages*() with FOLL_PIN set.
> > unpin_user_page() is shared between MMU and NOMMU configurations and
> > unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
> > GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.
> > 
> > This means that pin adds 1, and then unpin will subtract 1024.
> > 
> > If a user maps a page (refcount 1), registers it 1023 times as an
> > io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
> > unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
> > the page is freed and returned to the buddy allocator.  The remaining
> > 1022 unpins write into whatever was reallocated, and the user's VMA
> > still maps the freed page (NOMMU has no MMU to invalidate it).
> > Reallocating the page for an io_uring pbuf_ring then lets userspace
> > corrupt the new owner's data through the stale mapping.
> > 
> > Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
> > for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
> > symmetric.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Reported-by: Anthropic
> > Assisted-by: gkh_clanker_t1000
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> > My first foray into -mm, eeek!
> 
> Oh, nommu ... what a great use of our time.

Yeah, tell me about it.  I have been cursing a specific company's name a
lot these past days...

> I was briefly wondering if we want to add a Fixes: ... but then, this was likely
> broken for years and nobody cared so far in practice.

Agreed.

> > 
> > Anyway, this was a crazy report sent to me, and I knocked up this
> > change, and I have a reproducer if people need/want to see that as well
> > (it's for nommu systems, so be wary of it.)
> 
> [...]
> 
> > -				get_page(pages[i]);
> > +			if (pages[i]) {
> > +				/*
> > +				 * pin_user_pages*() arrives here with FOLL_PIN
> > +				 * set; unpin_user_page() (which is not
> > +				 * !CONFIG_MMU-specific) calls
> > +				 * gup_put_folio(..., FOLL_PIN) which subtracts
> > +				 * GUP_PIN_COUNTING_BIAS (1024).  A bare
> > +				 * get_page() here adds only 1, so 1023 pins on
> > +				 * a fresh page bring refcount to 1024 and a
> > +				 * single unpin then frees it out from under the
> > +				 * remaining 1022 pins and any live VMA
> > +				 * mappings. Use the same grab path as the MMU
> > +				 * implementation so pin and unpin are
> > +				 * symmetric.
> > +				 */
> 
> Yeah, drop all that. Especially the hardcoded 1024/1022 is just screaming for
> trouble longterm.

Ok, will drop!

> It just follows what we do everywhere else (e.g., follow_page_pte()).
> 
> 
> > +				if (try_grab_folio(page_folio(pages[i]), 1,
> > +						   foll_flags)) {
> > +					pages[i] = NULL;
> > +					break;
> > +				}
> > +			}
> 
> If it fails on the first iteration, we return -EFAULT instead of -ENOMEM.
> 
> I know, I know, nobody cares. But if we touch it, we might just want to return
> the error we get from try_grab_folio().

So just abort here and return it?  No, that will not work, there's a
lock we would jump around.  How about something like this horrid thing,
adding back in the relevant unlikely() to match the other calls like
this:


diff --git a/mm/gup.c b/mm/gup.c
index ad9ded39609c..8fa5b37be8b7 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1983,6 +1983,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 	struct vm_area_struct *vma;
 	bool must_unlock = false;
 	vm_flags_t vm_flags;
+	int ret;
 	long i;
 
 	if (!nr_pages)
@@ -2019,8 +2020,15 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 
 		if (pages) {
 			pages[i] = virt_to_page((void *)start);
-			if (pages[i])
-				get_page(pages[i]);
+			if (pages[i]) {
+				ret = try_grab_folio(page_folio(pages[i]), 1,
+						     foll_flags);
+				if (unlikely(ret)) {
+					pages[i] = NULL;
+					i = ret;
+					break;
+				}
+			}
 		}
 
 		start = (start + PAGE_SIZE) & PAGE_MASK;


