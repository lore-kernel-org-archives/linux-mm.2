Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD3F7CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 09:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB296B0005; Wed, 17 Jun 2026 05:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 792AE6B0088; Wed, 17 Jun 2026 05:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681D06B008A; Wed, 17 Jun 2026 05:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4571B6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:55:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8EABA0373
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:55:29 +0000 (UTC)
X-FDA: 84888947178.17.5229DAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id F35B62000B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:55:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rqk3daBB;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781690128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m9Lgp78HT7pVAXZur8onseb66Nd18UDwgALM4MZsuNg=;
	b=GwD4hB7N7YSqZG6SFgEd8qE3U5GiqfPVUZy0Wbzlz4aYyeoLXQZe0SPMO74e8aaN6fVNv9
	cpyNzP3mHlFsRXHGWEfJ1nIDIoklS22G0NnQldXI6Eoqezo5E6pQYRMc7l0xe53JJ7Q0KW
	IIUHbMiys+8qsDFhRUMcTS5xWe1r8Kc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781690128;
	b=UID8n3D4NF50ImLkIqLMflkmYhCzv+JFTntAZGtUCycZjRWetbZExWboUt3JYMybSCE8O1
	qvbl6xM6CRaEbU74juPldXQUX8MoAEMWpyjiqO8w+iLgMa8m1QTxzCDpnKE8EdJD1m5IG7
	0ruNdUQSU4PVucWt3XLUjqJDRTy1z7o=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rqk3daBB;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6ED0C60121
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280121F00A3E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781690127;
	bh=m9Lgp78HT7pVAXZur8onseb66Nd18UDwgALM4MZsuNg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Rqk3daBBBfPc7/dDjixxxRax51Dv3j+3VVLIcdaAO7oW6BBfYlSKtVcnlQEDBNXbG
	 35boQ765+nAsWAiQwkTlJvBi5S1vftfyATSP/3fDaZpM4W/T32Q8VCrHPhHsYC/LiB
	 780kTvO3NTN1Fks6Emike/JmOBzF4J9K4V9cLsjPyUvk4Kz1R4pugegvAeje/aQr4i
	 kCII1hL7kzcg/2ZPfnLb00DWqqVB2+Co78ZK7DVJf4neGFJIl4vC56m9J1f5yziT9J
	 F2KHlAVlluhnYfyclfE0+TJm82nCXz0+I+BllLdByA5Ax8wZr2a48TXwEHXj6M3OyY
	 aV2GWQehuDdOw==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-915aa0a9293so81134285a.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:55:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+vTvFMlI21no637tb+nQcoGkoHDs/3A0i058teIrRfUH+ucsFILq1vxwUg9A+AlXVak33bZ17ukQ==@kvack.org
X-Gm-Message-State: AOJu0YyFGvzFv1xzhOklbmS7I1E9BPwfXChO51D9Dknyhesa6bSGjEqK
	DDFd8+W0RlRBG6N+LntwjL+FVRMkGjUjhYPUeMKY6knwXzDcPiANCxLGj9NJjVZZMyfYHNnrQAC
	znG5sQofpMQnkeO3HBXxCKUhJQ2N38xc=
X-Received: by 2002:a05:620a:319f:b0:912:671b:d0b1 with SMTP id
 af79cd13be357-91dca2b4c9fmr282521585a.2.1781690126578; Wed, 17 Jun 2026
 02:55:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260611105124.98668-1-baohua@kernel.org> <20260611105124.98668-4-baohua@kernel.org>
 <CAMgjq7D0roMW108dP60PaCTnYfSDCA7GyGDATn-nLD8kiNViuQ@mail.gmail.com>
In-Reply-To: <CAMgjq7D0roMW108dP60PaCTnYfSDCA7GyGDATn-nLD8kiNViuQ@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 17 Jun 2026 17:55:15 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yZVGcpKzvRE+tvdqLrP-rQP9c7iHrGLCttyUkSQAndPA@mail.gmail.com>
X-Gm-Features: AVVi8Ce9fpjj358omqtBflORrPPCZbIf6R1G7Ohjnj0oDUixmwDFHUmG4aszuHI
Message-ID: <CAGsJ_4yZVGcpKzvRE+tvdqLrP-rQP9c7iHrGLCttyUkSQAndPA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] mm: entirely remove lru_add_drain in do_swap_page
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, 
	jp.kobryn@linux.dev, usama.arif@linux.dev, shakeel.butt@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: F35B62000B
X-Rspam-User: 
X-Stat-Signature: 9k7den9s3ddujjrxoc8irsbkbmjmswhm
X-Rspamd-Server: rspam08
X-HE-Tag: 1781690127-36090
X-HE-Meta: U2FsdGVkX1+aoR4il9SxOsLgRVz7MpS8PkdCpjf9L2UEXn5mZCrskuK1jVQSGyqiJcjB1iQYMeP/oC/LaLFyrA/fMFq4GOJMuyU5/blv7j+01iwOzWCWQ8YPc880Ckrq/oC1sKeIsTkdyvjmUA9d4UdXbmMq3+OkP+s6vkmMoaHPozeiXbhy2wGCW1KcbXBZhwOowmOk1rZVnU3xN3aEAAcis/2O0xmv7yrmeUIrcgcv4brv74OPhRK3SM2rfD56RR57HXTWA0FEPEVeAx+/reqmd/yrK7kFWZm6EI4NyXo+gtLBXQai+d8gHPS5CbC8jaQgbSfWRo9viUEnbNMwYYHiVy8PkTwCv0uwM64WlzQ3TuYAy7FI9wl5D+FD8N45esJc9egioLcaS5ZS0hpUzjEj8HxBCfj/rzTViv4lKTtXMb7qeAS+dQmFxdnFQ/qgAnY2Tt9zlVqQDeT/vWkYvOAr77twbkibbby3p5HvqS5yqGjS4Fz/U2TRlCeA5zhMFDwULKjiLq6GiLFB1dLm9S0RDr0hNPb3w051yfFhYNh4WnT5VBxxIpta8/1XSxjKaNqqrrKgxkQv7BkoFQ4Y2+oH7RjFTs9b++aNExaN4sqhpaCqSPouQ/ZEsNRa21JO0OuFFF4bktUXc+w9DZwTSHwnpxmkr3SpDsUVGNFQM0PDSv2+wjwiHS7IB7eCjCt35lyImSegoh24FIPAjLSWoa23nOZcfuOwJI05iZpdshZcpK+xaHSs1GK26Ipy/kkbrncHBSmgtOhS3vnJ2wS0Bej3dJ3NkcoX9Kt+Q2o2WgQMGSIKWKDXGyskO095bc6sUelf0KDYhJkvnQIppPVZFPgrGdX/NejwbRN6VKYiCPw31s2LMlRVgIE9lixZd3bYPKyQnBmGhPVVuSEUWCTZ8HiZBf8SgjGzyRoC1Oey6Czo1ixKSJ3+uPmP8z/pfhlHCd3XUPWKTiFU5R7rXFg
 3edhqEvN
 1iz3R/tMdenJhQrFwEOFUz5kFzbTvvzrdmoYr9COYKkgiA1eu3cPxfAyUq/g853EkGsYXFntZAJ6QitpZqFYMZiy9eDxGlW8AF8FaSjpP8ZKiize17n1nF0erS2XtJaQvc/EyLZi6XOqNC96BYrl39oeuzJfsuGNb/y5+nNaR3PlzETMqlObQY8vrtOustDmAz7TrV9UhLxGRIGXKKdqb1oW1eqhCil+g5ZhHSfZCphD2GuInoEiW9KGICPs+c/rQoq7La6t2Y+9ySnaJiDGtXKEGnXK4GuYg813Wit0Hqu7/4hBH/Zr5iYhPCvzmg1O3hQgw4YLorQbHGNqjlPBFo3+4fis/IUw1DgkLElqIKYzC54rhR7TSpheWYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 1:38=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Thu, Jun 11, 2026 at 6:52=E2=80=AFPM Barry Song (Xiaomi) <baohua@kerne=
l.org> wrote:
> >
> > We are doing a lot of redundant lru_add_drain() calls in
> > do_swap_page(), especially for synchronous I/O devices. For
> > example, the test program below currently ends up draining
> > lru_cache 100% of the time:
> >
> > int main(int argc, char *argv[])
> > {
> >         int i;
> >  #define SIZE 100*1024*1024
> >         while(1) {
> >                 volatile int *p =3D mmap(0, SIZE, PROT_READ | PROT_WRIT=
E,
> >                         MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> >
> >                 for (int i =3D 0; i < SIZE/sizeof(int); i++)
> >                         p[i] =3D  i%64;
> >                 madvise((void *)p, SIZE, MADV_PAGEOUT);
> >                 for (int i =3D 0; i < SIZE/sizeof(int); i++)
> >                         p[i] =3D  i%64;
> >                 munmap(p, SIZE);
> >         }
> >         return 0;
> > }
> >
> > Folio reuse now relies primarily on the exclusive hint, making
> > lru_cache draining to drop the refcount in lru_cache largely
> > irrelevant.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  mm/memory.c | 10 ----------
> >  1 file changed, 10 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index ce8ef27e7a54..b5a78670bcc8 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4903,16 +4903,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >         } else if (folio !=3D swapcache)
> >                 page =3D folio_page(folio, 0);
> >
> > -       /*
> > -        * If we want to map a page that's in the swapcache writable, w=
e
> > -        * have to detect via the refcount if we're really the exclusiv=
e
> > -        * owner. Try removing the extra reference from the local LRU
> > -        * caches if required.
> > -        */
> > -       if ((vmf->flags & FAULT_FLAG_WRITE) &&
> > -           !folio_test_ksm(folio) && !folio_test_lru(folio))
> > -               lru_add_drain();
> > -
> >         folio_throttle_swaprate(folio, GFP_KERNEL);
> >
> >         /*
> > --
> > 2.39.3 (Apple Git-146)
> >
> >
>
> There is a ref check in should_try_to_free_swap though, perhaps we
> should also improve that part too or we may have more more folios
> stuck in swap cache after this change?

Good catch. We could assume that a !LRU folio has an extra reference held
by lru_cache. Does the below make sense to you?

diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..237220ae1572 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5094,8 +5094,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
         * Remove the swap entry and conditionally try to free up the swapc=
ache.
         * Do it after mapping, so raced page faults will likely see the fo=
lio
         * in swap cache and wait on the folio lock.
+        * Assume that lru_cache contributes an extra reference for non-LRU
+        * folios.
         */
-       if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags))
+       if (should_try_to_free_swap(si, folio, vma, nr_pages +
+           !folio_test_lru(folio), vmf->flags))
                folio_free_swap(folio);

        folio_unlock(folio);

