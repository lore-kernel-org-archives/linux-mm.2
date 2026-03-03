Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 766BCEC0462
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 958F76B00B1; Tue,  3 Mar 2026 04:10:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 906736B00B2; Tue,  3 Mar 2026 04:10:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 808816B00B3; Tue,  3 Mar 2026 04:10:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C9F96B00B1
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:10:55 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9BD3F1603C9
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:10:54 +0000 (UTC)
X-FDA: 84504182028.06.FD28AEB
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id A282D160004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:10:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=L65MIYlY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of aliceryhl@google.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772529052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ogaYtNkDCDfQgVAlj1DqpuMuiJSw75SXwPAGSQIf6q8=;
	b=Raq+I5xw0qI9LZOcbZ8cujYJj2awWXvlLOAZmE6dlFeoOqyFcIOcdyuk2ffhLNDXpXFvFQ
	7n3U70Qw6P0uUFjoN/U/AMX6vIEzd5SDK9DAgdfLQ2ESXY78BhtOu0Z9z0SdewLAfdEff0
	lV1/7VYRd9jfHUbXBAwcW7LHiGCQm1g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772529052; a=rsa-sha256;
	cv=pass;
	b=SLUKmilKQWNn8DDkRZBsNhcSYUmYzzqWetatv3fqS7/g5I48LwM192r2Bzx1HRW9TR4DvN
	+Mdywf2koYd8J+SNyZdfnct+5/g23MgOtmVTWekQ50zTRSY36mBPBEvhioo6ZV2DzBlvrS
	JUQ4L0fzMC5XX3R+bZrFcPArym0otkQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=L65MIYlY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of aliceryhl@google.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2bd9a485bd6so801637eec.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 01:10:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772529051; cv=none;
        d=google.com; s=arc-20240605;
        b=eRPuG137o94jQouRI+mMn8rDJQGLOMJjKlnaV7GHbgqGNZM9jSSndAPNslK9/7b4Xy
         JaWVkZRuwQdqusj43lsPvpUih9FYBNMP4lY5DKeH5C4kCHUZjrZ2Rl8cMT3VI3fW5qdY
         VcwO5PUCBgtuZGumruygVSxeeI+PsUl6r8klc2A4/yXeesKC9bcDRxqsdalmim/3jyVN
         MY6dYGOd27BijUCsbEhP47JDV52vRCSH3rT2iCtv44YEoNhvaIaXCZH4iZtYZu/1+tqh
         Q6OxOLwbZ4ohtlMXrAvZk4nLSms9ES3BtYxGUWk83i0JYlHyK5GWXBmJMpmkAX1/fN9Z
         Rjcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ogaYtNkDCDfQgVAlj1DqpuMuiJSw75SXwPAGSQIf6q8=;
        fh=kf6eST06QRmZK0RLYnXSh3+pELMgssyQ43P7lC5YYnk=;
        b=Zg5Nrp0lBM5XEqmncAFCLtDaJ0YFQIhLvKzTK0ShuWY3hThXnm+FwLjdBKQcdKE9Lq
         +XdyIHnqBvNpxnu+oEkaH9diVMU1boR0FlwzoRCOwb56cU1I7yZPKNzXSnb9PBTMcGMg
         3yd+dFHft53vEQyobyz/9jqcoLDuK+mUMLmjHxnQd9lNMoPZZoLwjqEUXYYqVMm5PAIQ
         W4QnsxUI3Qi4r8Cy4g8oYIkHy0nr1CYcYFcQUy7DksK1D/ByFhFgaCOgHmrPUpvnLH4i
         PrpZHhnoz9+JJjUlDdbgK+1kU4psHLy9On/6tLEIKfzwfogKpaiTYUYoFiXOLq7N+W3G
         IZ7A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772529051; x=1773133851; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ogaYtNkDCDfQgVAlj1DqpuMuiJSw75SXwPAGSQIf6q8=;
        b=L65MIYlYDOL2PPhWLM61DZPsm73sLmMCGhcRky4rDlDvANYaMhELR2ATSdG0NtyGVC
         c4/9Ow8M8HacnUKNaEZFn+2tcxSr9k+eGC+2f0Lz+j/IloMxmXhWBHF4u4hi3xahrpOI
         3QUr1tifcSsON4xJvhs1KyyyYpvb0zyZEK1gbtFShnZ60ReWh5+C199T+T9W+VqSOI4B
         wfFJUcedB8dP5PUw4STNL8grjdRG153mgcKBgAO/q6NLsuY3ybMUh5Io+70Y9FIkqRmQ
         yDf5XivSFuT/7Xa4D1Jxqbv/1etQsjNBv134PqqIRntNd4ocp7GF/QFHLbQyZlxeQY9Q
         sAOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772529051; x=1773133851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ogaYtNkDCDfQgVAlj1DqpuMuiJSw75SXwPAGSQIf6q8=;
        b=WXNaxJCB8xScVPl8RZEpBfUJWFZ0qtdpQ3Ko+6Ox1boPFGwjufq/VG7q+HxWK2nlqM
         eCPc49CNJJT7yFjFYzA2ftvM6qOhjx53Z7pNPmWL7lbfVaRsRhPL2Zvq+hdb9mnTWnDh
         /xDbWevyB7dMDL1itQHYfvvqVtj+gDYzeS1l7i7F3ww9wWM7wpfUfcPFJUavJzecrEew
         8RbOfcwVFgeOWrJBxmzNLYvQHhwNspPnFvIyNY/813V4diIGvmjBQFlvqNDxyqgo1WU6
         DBk6z/TrsS8KsvTeq3MMXnGiKOq59qX/m40FwtJVlt00QA97Se38KXVqTsRajY9vOTPH
         p8bQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5IQ0K2Xu5m7/mzv86ahjy3FHv1rf1gOHVH8PhUlxTo1/LHSiRHQylmhr/sWgU4zJG5Kfjb4yqEg==@kvack.org
X-Gm-Message-State: AOJu0YxvH7innYpIIf7TQ+Tb5R7NaTYAklXQ5cbEwsjYRJPFajtHnhi8
	huQf0Ot7OsXWmJmIETj+KpFvbsbuYVXMiBQP4toA9P0K2Pz0FnciBO1xoGH0tNbpb4snPcWbQp1
	YD0Jj7L8dn9WuqqMsa2cN0khbBZEsJ9KxEqS7ERcn62SRD03r/1SdRsCa
X-Gm-Gg: ATEYQzw+ND+G2NdYp74GA8TcHGfcnBSZoYqCZHWHZXRIimUhyQEpb8dQV6cSUUWkvQI
	aX1hL6KdA3pWY526LomN7qsO6ujoKdJ+xz4e4Vjswb5GTqxS5oikXNYaDiTj5JJ1DJAUyjmZEx8
	4f6Xo4RFduqRs1lNH1iWzZEBNv4AJ4/twY90ceQplYS7dWDlFQnYIxwuEzXKipM9ebrbf8SYZBK
	cx5YixWA7VoDKqI/Ad12nnK/KiQCLZZdSsxIPDIgDwawzdXW3bvd3ev4/whYW5iqrJI1iatvR9l
	4UXb7YzNergRV6Ko2tH5hmTTBWJaU1PMlBiftxc6DaJdP+Ub/pQANNrusOdCj97sSGKxAnDv
X-Received: by 2002:a05:7301:4187:b0:2be:2345:bec9 with SMTP id
 5a478bee46e88-2be2345c34cmr747934eec.31.1772529050571; Tue, 03 Mar 2026
 01:10:50 -0800 (PST)
MIME-Version: 1.0
References: <20260302-vmalloc-shrink-v1-0-46deff465b7e@zohomail.in> <20260302-vmalloc-shrink-v1-2-46deff465b7e@zohomail.in>
In-Reply-To: <20260302-vmalloc-shrink-v1-2-46deff465b7e@zohomail.in>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 3 Mar 2026 10:10:32 +0100
X-Gm-Features: AaiRm52rAnHdLqvMM7EXBEc2P87ECUtZgvBdg1tUvuRwL_rErY4LvI_runlcjC8
Message-ID: <CAH5fLggLgRJL_5a2Ky-Ag7E6iRdY1wAVA=yx4wtz16-q+CMAGg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/vmalloc: free unused pages on vrealloc() shrink
To: shivamkalra98@zohomail.in
Cc: Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A282D160004
X-Stat-Signature: 3tcrsryuuh1nzor3x1tgu6dktmkkz73i
X-Rspam-User: 
X-HE-Tag: 1772529052-950050
X-HE-Meta: U2FsdGVkX18ZM1cXb5y8gahRXYLW394B51Y6f+vukGf77sMkRKrAtx50qBUNw3uApEFpp65DPZhwtn1F8/fW22SsK2zfjHhA1qJRFocsmZm6U6ZvtxDy4uESZu4zjIRzFZuFfo9/sJFzDEyHgiCoTgIZY6ChKxbbWiWdmT7T/aeh/n5lDHz2+POW6zsUPSY6ROYd3K52h7Gc8WIOFhLt64fB4Cloe+rICSvPBRSGy/zijOTX2ePSm0ZWtpETKy1MKy7m71KjTDkj4/jvRCEapAh1UCDfgWPJokzBLrfw8sATbxCeiLv1o9QmVRuha88nRPqy6S6xi3Y70FtJ7VkrVpGBfopwKRa/LmLaS73jnqqHLHiJmWQrw45EJBMfi4qgmyByoUTcOZyCxH7a6zUFpWBDdAWg8X3DGnUgRcWhJNY2A3SMRAbZS2GJUmnNnHTFK1om8mrPfzIIEHqziF1q9ayHd6us6KuY2ex+Mf8/XE6PU/IKsROkuMn6eMFNMMUXTTlgorEA2qCV9wbUtSltD7Kqrj6zwIqRxL4+uzVA+SLB7Xx8cxwnKGGsISNk6toWuOCXzFJdQceVHS/YJjMOkOsHuJVcrJ6yfqXaq9YPxURH2UMMrbdgWPwRGP4VCpWPHBl/LjN5bttfEXyS0EbfnnUUhp6ahKlBmqX76WCYMkoEfu66xXezQO2Ye2xFHNQFF27temkLWULD5kIAfLd19j3pfe17xdvIbFpzZni8nE0bf4+02cja30ON7kR5pIzf43Kxv29SbRJZMW/cMev3RTqrpdaUhP+W4eiMQBDXV/S7aM9bxpPO7F3OzblXdN453QDAD75Wu6uRh073bWuom6mMxAscgThZ9huTTAUE2xTC/VfHjOaNn1O7V4mMeWPr1y9Gv096AOpi1Mn9pykFV42oLhHPbQMCSFVnb4JJU7Li21WHR+MMBse2+B33UklXlvZ8XmZ6UNU/0jy3kNa
 R+TX9uEH
 r+MsEdZ6MmtjEsgjWc8ca8nckeq5RJE3iGJ3TYWD4waShH2yWIoGpOfuEXMDUIA8zaZ+nFeGa7KSPOC9ujZSuavEHus50EPux8log0ZGgnW3mfcmmg97fG1VTWwCzau1pJ8aOxNs7IAMQTAc/m8cL1H8J5TJp1uqwIuxuj5z+Y993r4/xkuU3SN8aiE1YYJfFSJYjy7lZ6uvb7Ugvi4TsMo7dW9XfUQxSN5nzmtYQDZ90XTw58jHd1gvtuviS6kg77zHS2aie1Nacrpg6tRQaOxi1VqfOYMbOThn8Eb+CayE75tn9boFF5/LzUFC2QoL65gjcdOCjueZ3aheJ7vqqxgYXFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 3:03=E2=80=AFPM Shivam Kalra via B4 Relay
<devnull+shivamkalra98.zohomail.in@kernel.org> wrote:
>
> From: Shivam Kalra <shivamkalra98@zohomail.in>
>
> When vrealloc() shrinks an allocation and the new size crosses a page
> boundary, unmap and free the tail pages that are no longer needed. This
> reclaims physical memory that was previously wasted for the lifetime
> of the allocation.
>
> The heuristic is simple: always free when at least one full page becomes
> unused. Huge page allocations (page_order > 0) are skipped, as partial
> freeing would require splitting.
>
> The virtual address reservation (vm->size / vmap_area) is intentionally
> kept unchanged, preserving the address for potential future grow-in-place
> support.
>
> Fix the grow-in-place check to compare against vm->nr_pages rather than
> get_vm_area_size(), since the latter reflects the virtual reservation
> which does not shrink. Without this fix, a grow after shrink would
> access freed pages.
>
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
>  mm/vmalloc.c | 25 ++++++++++++++++++++-----
>  1 file changed, 20 insertions(+), 5 deletions(-)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 54e76a47e995..7a4c59422638 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4327,14 +4327,29 @@ void *vrealloc_node_align_noprof(const void *p, s=
ize_t size, unsigned long align
>                         goto need_realloc;
>         }
>
> -       /*
> -        * TODO: Shrink the vm_area, i.e. unmap and free unused pages. Wh=
at
> -        * would be a good heuristic for when to shrink the vm_area?
> -        */
>         if (size <=3D old_size) {
> +               unsigned int new_nr_pages =3D PAGE_ALIGN(size) >> PAGE_SH=
IFT;
> +
>                 /* Zero out "freed" memory, potentially for future reallo=
c. */
>                 if (want_init_on_free() || want_init_on_alloc(flags))
>                         memset((void *)p + size, 0, old_size - size);
> +
> +               /* Free tail pages when shrink crosses a page boundary. *=
/
> +               if (new_nr_pages < vm->nr_pages &&
> +                   !vm_area_page_order(vm)) {
> +                       unsigned long addr =3D (unsigned long)p;
> +
> +                       vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
> +                                    addr + (vm->nr_pages << PAGE_SHIFT))=
;
> +
> +                       kasan_poison_vmalloc(
> +                               (void *)(addr + (new_nr_pages << PAGE_SHI=
FT)),
> +                               (vm->nr_pages - new_nr_pages) << PAGE_SHI=
FT);

There is a kasan_poison_vmalloc() call here.

> +                       vmalloc_free_pages(vm, new_nr_pages, vm->nr_pages=
);
> +                       vm->nr_pages =3D new_nr_pages;
> +               }
> +
>                 vm->requested_size =3D size;
>                 kasan_poison_vmalloc(p + size, old_size - size);

And there is a kasan_poison_vmalloc() call here.

Furthermore, they seem to touch overlapping ranges. Perhaps the first
call can be dropped?

Alice

