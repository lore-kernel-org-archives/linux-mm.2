Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5157DC531F8
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 17:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49C6F6B007B; Thu, 23 Jul 2026 13:16:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 477F16B008A; Thu, 23 Jul 2026 13:16:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363036B0099; Thu, 23 Jul 2026 13:16:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD646B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:16:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69AB6C05C1
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:16:06 +0000 (UTC)
X-FDA: 85020694332.17.74E4456
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6E4CF20007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:16:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FKEU1Heh;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784826963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7A7ilrML8UYNqjUJnB8K3U9b9b1vXX4T1cwsKKRMFw=;
	b=aU/hmZk2YOPCL2L4YoP4Wba2VBFFVZeBm+V8shKSxftKqb0vPj00frVLBlkdRWeaoPGtFi
	D/DGkKU8Fj4t9mKuO6QCw8M5skecFyAz+KaCuXDNfbZBIcYyQR4yhFOHyEOvDHAZ8cZQ1e
	LcIaevMQtmZRliDGlhWqHWu5uDq6SxY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784826963;
	b=cjo2XRkGmmtegWh0Sh3CFsi/1hx7sri/uHJcUqM/91DXodjUP4JzTfAQsAg/1pVrGpFFhS
	Kh0Vb5rdtPY8EeNhVq92+lwBsjSBdSHk3WeN81P46xZZVEuHnRhEa2c/DLJK18N+aWmYCE
	z04ZyOSY0twdlv+6ZyoZwHQaClrsVak=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FKEU1Heh;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47f904e80eeso819124f8f.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:16:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784826962; cv=none;
        d=google.com; s=arc-20260327;
        b=F9qfvAjRx2hgAnKnV1uN3yoGaq02g5b4cSRHSBboelzbQZ1MdydL0hdDUieVRJC5X+
         fep8pag1UHmtiVkcxV8CkJMyfZ1xd8scvKY9TqVzqFSFi/2L82U9Oxm1x/nTKzDMgr/U
         7/pdHWI6otXZsYCS1Tbb0Kcp94MNrL8Oecdq+QbjqTMQ78AZi0dXNC7JY4kvGVfSdOQx
         6qnrVM+c9zUkmXaMbBQHTw3Lhaovy7/5HH4VxzeYkCx6cb2LcVace90UA87rwbhPvgpx
         UCa7zusp2OK1Eq2eWsBW5T4fnG+MG7V0ufKtXgjQuDxZUxCVaOTj1MjU8iiZTwV87Wcq
         8pdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h7A7ilrML8UYNqjUJnB8K3U9b9b1vXX4T1cwsKKRMFw=;
        fh=FDv8zOJliymHpuStw0/zNz1w1rHdjte56Dv6gy3n4jY=;
        b=ISj/KwDBRlc/5Ss7tci5dBIUb2m5bSxVZMtnmo+XRtV59nhlF0KOQOSfWwjDhNhA+c
         0yi68NVxom6/F059WldSDYXL78zG4ZnrfBUoVtQ8AP/YXfMjlfdT+hfydeHe55W9nE1F
         DCIKD5i1x8o4EGz0gtlPHAuAwfaVd4R8gof5rfqlP9RJv8ULNTyHWuqmascnyT/wO5n9
         bafZ2Q3zLsPNGPx1IgZ+0gwWFcqy9xX2/TYZwXV/KYUwRuTfG4sV0QJs6yjNEh54u2yX
         5V/BbWBfTfcUNnzf/gE5uVkJEmacxbHCO3vtiYFxoYYhKrnnW0QSyN+G4+yIXyKh5UhM
         yeBA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784826962; x=1785431762; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h7A7ilrML8UYNqjUJnB8K3U9b9b1vXX4T1cwsKKRMFw=;
        b=FKEU1Heh8u9YFhCwsNOCpp0I36v3OwFUf7m6neNBbYRtW/byZJOco5xT2Hx+nraaIW
         /9qNoVICUeUBNwiZ3lqpL1JaFEVHs/7rNYOvels5Pq72nlhV8efWdhdYqf970VpwVfj2
         Jy4GHn+Po9JyJq52rfchTlhNEbC+zFk4peyRHA/4IAYrHGW/RhST74WnpJ7vMS24sqGb
         pucs6a2CyrKQSbZ9gr3U9KybBrf8RUyWngWU4zz3I2W9rgy+X9sU7xrD/OWSRvi+wDRo
         z3eG4j9pqAYKcx6S3Vm7VnS6aq0ZlFGZtKpPWTLuLW0J4vaW5BBqxuJCGAguPeBvJAdZ
         Y/dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784826962; x=1785431762;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h7A7ilrML8UYNqjUJnB8K3U9b9b1vXX4T1cwsKKRMFw=;
        b=rmkqZVTSg6SmVK7dU9n5q6pGBijI+mhaKL5FgyZtA1chQnHI27fv58GIknF9be7Nzj
         1tvaWSCoua1hpvxCnmJnz/XkQoHDUJCLlSCSc5Y8rhSKZJRvFT6uKt04v3y2ljGfVZur
         aQlGGx0YfaSyaQRMCum4YdoExZOsyPYercvoQPYeH49qIx0i3W45aRN4txam8Xvv6+CU
         yyTUabeIzQP9u0hYAWIcNRLBs4WsIM7f1qJtZx5P0jylwl3ST5GWghhYI9CuWz5MXVLI
         rNxAxNZPc+1wVmicnI/NAOpmQ2ZDTg9vCbHsk238xSYpRBVdF7yDsPyfIdDxVtw14obl
         G7bQ==
X-Forwarded-Encrypted: i=1; AHgh+RqRF0/wRYj6yxEhXqfutlUtfYFBLG9VOe+h9FJxnQDie+7lYcCILzb5zTyAuqfmWNl/A1Tu4luFCA==@kvack.org
X-Gm-Message-State: AOJu0Yx9t93Cl5US8J3fMFQAY9ei/ui3aazbyd/6XwYS6GMEQs81UBEk
	VJzUXr5g01e+mafHWTVxuUhxSzWDqGofqQSSs13ktRnlfAkCknTgf9wPMMXWTNVTzFfbuwIh7EU
	XMfh0ZIDn4C7DxeeExZS1m000Vd7NgTA=
X-Gm-Gg: AR+sD10Xd2kBmjov+EiTMcyiz+wTvfctR+gO9q+oWtEpl4ocO4rN8bJrTkRIBNnus4a
	YV628G/pq/xHxyRNAalgb3j4rfp07TDixAXIBOAk0mUmz9hLnXltu4y8xVYpQOQImBVNvceDnAy
	61vvVzAY70C5XyQsur6CrP6jnWxd62IKoT7AZuVFkHz+4QJcORiUQCeVTglqWtNODPondjiQTqH
	n3PbhCpsrsnKYbSwgIjmnw8WHYoBxn5pNHABUUQFEyi4yaa1CZCIUCwhmEYS/8XRsGKFUENMTyl
	L8rHY8qMuoHTmQiL9g==
X-Received: by 2002:a05:6000:98b:b0:475:f0d1:eb63 with SMTP id
 ffacd0b85a97d-47f8d76dc78mr5103717f8f.48.1784826961662; Thu, 23 Jul 2026
 10:16:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260722152043.2273289-1-usama.arif@linux.dev>
 <20260722152043.2273289-5-usama.arif@linux.dev> <amFZmtGHEZjXEw5R@google.com>
 <ee172b01-54c3-47ef-9040-1342a1566796@linux.dev> <CAO9r8zMzjCf620EHwzfosngc94fu=vAb=ukrtOi9Qf3rA3vv7w@mail.gmail.com>
In-Reply-To: <CAO9r8zMzjCf620EHwzfosngc94fu=vAb=ukrtOi9Qf3rA3vv7w@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 23 Jul 2026 10:15:49 -0700
X-Gm-Features: AUfX_mxzwM11na30T79ezLPWZb6gzVDd-rpSy4Dm9dX8njnD3RnNPEEPzA9TQPU
Message-ID: <CAKEwX=OCdMoGh2bQJNORJ42w6wTMrXyzXNUZcfgJMehfQrKanw@mail.gmail.com>
Subject: Re: [PATCH v5 04/11] mm: zswap: add range lookup for large-folio swapin
To: Yosry Ahmed <yosry@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, chrisl@kernel.org, 
	kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org, 
	ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, 
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	shikemeng@huaweicloud.com, kernel-team@meta.com, 
	Alexandre Ghiti <alexghiti@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6E4CF20007
X-Stat-Signature: xpn9jakndkrcryejt7esty7ugexjrxdt
X-HE-Tag: 1784826963-35576
X-HE-Meta: U2FsdGVkX1+6deeIq6ODIXw1Oq1h52tWWAV22L/FlrPvtykFHSGz38lW561mTh157FUqTp7rUHJk/kMKtxZYFNvGf/gSewmsPJLF4WhVEEm5B1OBpkG4/fL+lAYpelQ5nqD9v6yNdw0kY3TuH/9t4Z+UNhAOwcS4Dze6m+wtL7za3gFbnxLamShXohR6iJSSUzz2QBTmeew0LdptOYO5j/l8boy3DpAzLogFJNDSRACgZQsKXEMa4pdtUds1Csafs7LKSNun7+yhaJrB8cZ+Ab39sWS+5A6+tJtWYr9gC5MetLP1PQpP4FOk9ty+E5rF4wmh8htOsxz94eG3JydMyaXbI3eUXhYCXWD2Ap2Uy50GOuhgan0F3Dtyf4pBO1/LNq8R3UhbTc/NRJo984saN941ci0F0INGRrrtUUwBi1QWZx7qOfEm/EdoeoTrMQA0ZgUxR1EFseAL+Xs5TNws5aQ2pwQ+Fp1zAYU4dc8loJxdeCqFX/0E2eCgNyDTeHskHiSAGIykKBEWKSIr8xTABMI9RudPVWDVVShgu6Im9ieXd6Ev4z5EhDwrxNtXJrVwfrZ8z8DpI9y2bgbO5dzPS1ii94eZ3G7zdZw70rROWdBSBtyk3GyxgJZetrY3An2/K+KY4KIcROkgu04DF6y8Dz/R1y3jhPGJcq2wKy5nDopr90GW5P6ncwV3tfuRUJNRHGz2JYGQmIGbqDTWW0SrIhOL8yEHudEQHBZU7tywaY4yvnWEpFgNV5zr7PejISIZ935wxTPDL1FH2I4HNPQtrw9/fQzXftJWv2kN0/Tvk1Zh9wJROCWfkVsICaT/mFYpZAucoBXEWhpXMY+kBb27xbSEXjEg/J4/F0KkzybP2knbAjYxYeKA6XIwVKlpU509UdNioo4cwQnv5vbPkTtuexi6iXLKhW2FznLsiINNH/Z5BaI8C5bPO1d/ATjOCpF8V2cRPiedfoiEIHFmTaE
 VoYRPAjM
 JzDcdgqJDna0iao+Vg+JKQSOyWomWN/9GrbZLU5fh08pM+7c7wxOFQkq9DWihwkpqOLXWw1M02OiRyl0DORjrclAKIcFtyCFWs6JYm0E7CAdKHUvMGkdhVeyn8lIYctJ1yhUPOc9reojc8/DuPhIh1/fUgbEbRWpHstss2HTwMoA4yPBzkL/MiCLv70yleSfAyRRHdAoqi0Z8aSFZXugIQ1c68MkZSVvMn+Bok6uYEGXaoqS5w3jtMyNyffYNEa/YOfDXUr9eiskcCdKDiyu4lb1F63N0i2fWx1k6fLQV8YxaqoycvCgHmdItwQlQvDuM9HCHWvz8h55WDOU7QdHv2/8rmBL23k81Z+1dsrkit8zv5P+Pzqrwb7qCQU2T6tGm46AbsHLA9hfCkpjVmgaWAUomZbvVbsR1uZC4q97q9uKXW/w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 9:43=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > >> @@ -1595,13 +1611,19 @@ int zswap_load(struct folio *folio)
> > >>              return -ENOENT;
> > >>
> > >>      /*
> > >> -     * Large folios should not be swapped in while zswap is being u=
sed, as
> > >> -     * they are not properly handled. Zswap does not properly load =
large
> > >> -     * folios, and a large folio may only be partially in zswap.
> > >> +     * A large folio reaches zswap_load() only when its whole range=
 is
> > >> +     * expected to be on disk: PMD swap-entry consumers split befor=
e
> > >> +     * calling into PMD-order swapin whenever any slot is still in =
zswap.
> > >> +     * Confirm the range is entirely absent from zswap and return -=
ENOENT
> > >> +     * so the caller reads it from disk; if a slot is unexpectedly =
still in
> > >> +     * zswap, fail the read rather than return partially-initialize=
d data.
> > >>       */
> > >> -    if (WARN_ON_ONCE(folio_test_large(folio))) {
> > >> -            folio_unlock(folio);
> > >> -            return -EINVAL;
> > >> +    if (folio_test_large(folio)) {
> > >> +            if (zswap_is_present(swp, folio_nr_pages(folio))) {
> > >
> > > Is dropping the warning here intentional (for the folio_test_large() =
&&
> > > zswap_is_present() case)?
> > >
> >
> >
> > Yes, so we can end up in a race, which should be handled gracefully.
> >
> > For example, lets say we have zswap writeback enabled, which means we
> > can end up in a state where we have a PMD swap entry and 511 of the 512
> > slots have been written to disk, but 1 slot (slot X) is still in zswap.
> >
> > We can then have the following race:
> >
> >
> >   CPU A: PMD swap-in                  CPU B: split-PTE swap-in
> >   ------------------                 ------------------------
> >
> >   Checks swap cache: empty
> >
> >                                        Faults slot X
> >                                        Adds order-0 folio F
> >                                        zswap_load(F):
> >                                          removes X from zswap
> >                                          marks F dirty
> >
> >   Checks zswap range: empty
> >   A is preempted
> >
> >                                        Unmaps/reclaims F
> >                                        zswap_store(F):
> >                                          puts X back in zswap
> >                                        Removes F from swap cache
> >
> >   A resumes
> >   Allocates large swap-cache folio G
> >   zswap_load(G) finds X in zswap
>
> Why don't we check the zswap range after allocating a folio in the
> swap cache? I am assuming at this point we have the folio locked and
> the result should be stable?
>

+1. Is it possible to perform the check in __swap_cache_add_check?

That's what I did for vswap, per Kairui's suggestions. The cluster
lock is held from that point all the way to after the folio is
locked-and-loaded into swap cache, at which point no one can change
the backend under you.

