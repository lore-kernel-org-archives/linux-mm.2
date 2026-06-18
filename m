Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8065CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 07:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF796B008C; Thu, 18 Jun 2026 03:29:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7B76B0092; Thu, 18 Jun 2026 03:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CDD46B0093; Thu, 18 Jun 2026 03:29:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D74A6B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 03:29:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E19EE16676A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 07:29:26 +0000 (UTC)
X-FDA: 84892207932.13.17D9A6A
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id D7CAB120003
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 07:29:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Kj/MZwqg";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781767765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eBcpoqH3ULdZQTzYGOMF5BgZRJSQRfIxAKlVJjXtwSs=;
	b=JQIFMpFIVlP3qtpAsVazRI3nIPM5tDFhxZqAoZru8CjJL4qo6LcoaYQrUnd4xzbVTNbdB4
	SaiEgLxi+/mbN2YzhfcEXhvLfbSJ1sUGm0zFLrvFnoQcjJWUXpIJE9kinsRpqXPi9Rgxjd
	iHsztL9CZrlGVDH2VdoNUWdWtbOXmI8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Kj/MZwqg";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781767765;
	b=CnnYZLGGmyYlBhkOSlmd6HI1OjcItcR3POZaSVLrHlXmkSVVYk0EOjsYIajd56ZxZKtwQC
	pjLiOY7QQI6ITitYJMw4dOxF/s7GztR4zSBlpv/yLDOneigOXY8bPupBk4kLajEh2F06N9
	i9j5gmkrywAOMkPvqK9U9/V2pSw1kgU=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-695737cf38bso794716a12.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:29:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781767763; cv=none;
        d=google.com; s=arc-20240605;
        b=WvByHz8x5f71jMKXTi2kIrSMUj6wM+Z2ZzymCY6uvmmzh7R7/58DyC2Gt3wPA0LGG8
         /5Wo9RNARuZ79jXjRSyUDS/q0SdsR13A6+he8uXa6ptSTVp76CuZLYzV7c+EERkI1KNn
         GTIf1Q4I+f1LTx8vAMTm2voojGATpSaK9IYqKq4wPNn8NbYcKxpUI47Ud6KkjkE9y80a
         NQAdMIeqA9RnP46IlscP52Jco6NZuCil3PBUDHlxryg6lzPvRQS7OWwzw6gmHHicogDK
         wAE2cIcWrjbIvuZ+A05kGGj6bFptp+4zKkFijb4t97Tr0dFXa68VxQ8yYEyDCV6CcpdC
         yRHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eBcpoqH3ULdZQTzYGOMF5BgZRJSQRfIxAKlVJjXtwSs=;
        fh=tgGMRe9iqIeiVP+FgM9M3wMP7+d6+SmQ0Npd0LLX4bQ=;
        b=GtIG3ScXajrKMURGOvA5f/Z9UhswXFBiCG2wdID8yEATzMC3JKayy8KHEcARTBpy2w
         gLf1xE35BEcI98F4bhwYCAI9umyQAooE+PeBBJq/wqv7nI7MFXTdoYCSeYH8+LxJq60d
         kB2dodleXczt1qxnKnsQc63JCFkQjc5V3Mx0G/4IprzHSGIpmtJcvBlPCh3cUlNnAlKI
         2VyOThej+074EQ7fF/wOTem1n0covDRl05XAFad7x/18XeidyvTvOMZiZHzwEl/I5WgD
         +manBNU2Qx4LYuUmGhh6EFbpH/PfHrThMJYbfITjIgbiwqFhvqd77Ept94wVqAdDxxLz
         KExg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781767763; x=1782372563; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eBcpoqH3ULdZQTzYGOMF5BgZRJSQRfIxAKlVJjXtwSs=;
        b=Kj/MZwqguGKhYiP5w/8mWStYSi47ApvRH8aqrK/vb4nPB6+SDU8a39E6aLwyZZQq7z
         HJNw7DQ4cCODFAB+p6uNHI72G08J/VaoEWVpTtoHFB6T1wkZajbrYvmXySgN6iMFIPlM
         I/aXPuvZGTAwroYbyHL4tlhPRYBP2KlFVM4Uc+tspt0W1o4Hb6n3FRSn1JjBpVXDOh6u
         6aTlx0l6IN/ZI4As5Axh26j0mcvNImhZ9WQL6DE3y30Z49IYp1NtHdvz8Q+z2zRO5TLr
         Ybjl4xnDcHzwfEPuAhf4Hwmf7KvxDIhcVWUTGhf5ucorXCEhLqKDbyXc/2BJvMIjwrqU
         FdDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781767763; x=1782372563;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eBcpoqH3ULdZQTzYGOMF5BgZRJSQRfIxAKlVJjXtwSs=;
        b=sa/abQFlrx3z5EMH9eu7rSOjuAUX1hb2qzivQ+7R8Si003g6r6DqdaJd9VwK/TVxYg
         z5Nv9d7pwPO/SKykhfUykrLzyJ+Tvb/842QrIQ8gYFsuklLhUbwpOk5bY1+5GxfwzqXz
         YVod0n8/2VgZalYZrt+VyNaqBbrTXFquWNc9fa9hFDHFnqBC9D0f/IKF5RG62lrVXc8K
         iEowu+Bw6JhGnlQPlFERZJt6JCRfhJdjv37iP1ydEPAVwoI7i/F92YHK250x1+A/dLq7
         4QDLpdSl4JYpiGKtkkXRvm5E87XTgice8oI9PmWNV34RwlhrSGno8PYKlsExfn9uR/2X
         RI7w==
X-Forwarded-Encrypted: i=1; AFNElJ/cqgQ3ZSxbz/8XPJh6FDnRUXfwMO7nSpniFSmrqqR1mQ0mFYu6d3VfZqeo67c9wMMeVRH4xBIn6A==@kvack.org
X-Gm-Message-State: AOJu0Yy1bK02VZtBsOe0b++O56C8z+XGRCBp7dtOHtUkKAWAN/Q11pfL
	3fEVtJOOfAMyX9J7bp8WoNsVfOA8zUllDzEhxsYwGHkyRae/C+X6LoxUoD1H2WhYBzwbLlDhZZf
	uU6tB4ikg96QNRQO9ZFZI6fp0yQfPK4U=
X-Gm-Gg: AfdE7cnTLYlrv5Dsgm78wz8F6q1z+kFDpDBpvmbc3xxCE1lYrR3++5t4VDUDx+0u9VZ
	Uh2Uc+Udxw5Ac1j5LbtWjfB9naMiyAn+95KHDsyYJoM8iE176Mt02c3RYH5Kz4TWYO5bIvr6G2Y
	5+mxU3lwTD1zPXxdxLTd5VaFYb8xRV236yZ9evUaQrAl6KP0PbFx3zrkFEFh4DqSeWiKWKyoTbV
	Sw8Sl2/CYnfq5wHzG6uRQazxTxdREF2PJ1OvQzV1y+rKMX5ViA/ukXeRYSgPZD4xvAkHZdsfoPB
	yiSsesJV7k80IlUlCX/rNann4q2mWQ==
X-Received: by 2002:a17:907:26c8:b0:bec:f580:8ee3 with SMTP id
 a640c23a62f3a-c05a956fe5fmr501997966b.46.1781767762691; Thu, 18 Jun 2026
 00:29:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260611105124.98668-1-baohua@kernel.org> <20260611105124.98668-4-baohua@kernel.org>
 <CAMgjq7D0roMW108dP60PaCTnYfSDCA7GyGDATn-nLD8kiNViuQ@mail.gmail.com> <CAGsJ_4yZVGcpKzvRE+tvdqLrP-rQP9c7iHrGLCttyUkSQAndPA@mail.gmail.com>
In-Reply-To: <CAGsJ_4yZVGcpKzvRE+tvdqLrP-rQP9c7iHrGLCttyUkSQAndPA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 18 Jun 2026 15:28:45 +0800
X-Gm-Features: AVVi8CeyA236DEf8oaj4Gfs-xcZGw4fgB1YX65VM-FwaFSTsUQBeLhfsxu7lQjA
Message-ID: <CAMgjq7BDfvNXdWH0cqarsujjUn3i3tDDhDkmSg01TR4h-tDorQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] mm: entirely remove lru_add_drain in do_swap_page
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, 
	jp.kobryn@linux.dev, usama.arif@linux.dev, shakeel.butt@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D7CAB120003
X-Rspam-User: 
X-Stat-Signature: 8cnywbwco3xu73m4q4gx57cb99q8kgu5
X-Rspamd-Server: rspam09
X-HE-Tag: 1781767764-607815
X-HE-Meta: U2FsdGVkX1+tbu3kEME8Q7qcWl6VSA2yRkzk4P1GlTUyr3qqVK0GeWRxHIj5r2Vtu7ZT77MEeT9bJ2ribP2GfwcRBd3OYDGulEJGi6EQbPCPbqnjt3PqUbDbw7DGLSZ8Byh4hxmKBKs9txUhdjlMMIrmP5t2NW3VGTqIzK9r8U7zpAz+aZh7uch9c3hbZJ2UkGGPXEif419dWh0hYENo974t4wCKRbbwLOSPkvVTyhTMFvjbYAkaFZZdOAwQ7IVeSSLimhetDDZkMVTTQyux2NlI/Yus+aaW7h0xNzjKEt9/6hsPgeo2lEFHZ1rxxlKsxEm0vbSaxErlqA57GFgVZvf9abmpbH6pe+ipJT56QhME3545R8K1+Pa20DWilNaiB6fiFaA30rkJoHiK4pKEJ0O8oBLKBGnfk1NjLDpa5murLI3RYdfyy4e11ltJlnuRI/yDlvKt64UJ91g2Bvt0jBWWad/IIFfun+JWgHANwZuwgLQrgIj0YLNMNmjQvGbVSz99mUcL6jtcASTmMs17o28rGs6O0MVJrxAygDad15a/SAbcYBOR1/vOChcUjDN3tlo/zB4fSYyKLU3HhMqK6kD+GvVfx3+Hn/HNOiRArGb+l8G8vFgmoOQcsszIh9FIkg0ay4GIrNDXbKSNSAeDaRXALXDhE1w74I655Oukstc+tYVqjUtsgoTmNFXfArrjXqYRfMFuObTC+J63sb3sRZbnI3UmEasUHAKaCo0W/zfsPfmBqme+loBMSXHweBLhP5BiudGwx/3M0+1Uw5q+yrU5V5jiUiGZn3lseAMmmf8hECcug/2mqIwrsOhDVSdF1uC8it1iSf21z4gs3nvS/jXnpHbfcJZcIa3OwQrtUxO62n58awRyQfpbwvmSyldEMUF2lbmAqgcn90mzt7hXP4DGP8YRXqYXGlDGZY1SI1U7v9MIC5LX2/vZWu9ruSSLpCv8dE+dc55QH+SQJNN
 ec2nPMVq
 /g8KCEQKiz6SBe+Ftqm3waJgiZvV7HhLe7JXVkq7Xp6HGeZaB3qGOe1rvWDXneVdl0taXkXliRwWCMeSnIwB6TXAVDaz3NezPNqM0wqY283t5zHO+men+cuUXXq9FjWN7UoZWtolUBlEwyefgdQHQH+FUQc+A+QRouYSkUQK3BbxAfkEf9VRVPmFRjm9qm60ZzqKyCSi9CsuUlhXkvjykRmyrdHwCY856MBSUGxHhQ6zd8vPJ1GFvN0LAGcfLBDUqj+RrvtBJotOTo/Qy3+QWzPjbqmoyCIcNpyxUi/zbrPP9dgpf+BDK3Zaw5dl43KMdYkj8yI7/HZkO664N3qA2mL+y0YpI/W9u8hixRfqJ4m29/YkT5/GmAE/hShqXeMoVC3GhJnXS3IXUESRj2hfmLVfa03sHBZxEd+kpwXJA3SawqkAoUK8ylIKT56JWUuWEreOsvGb32df6mLz4wiGpheUCupYovuzyRLqwo62MoO8a+KIO3+tiq7O2tA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 5:55=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Wed, Jun 17, 2026 at 1:38=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > On Thu, Jun 11, 2026 at 6:52=E2=80=AFPM Barry Song (Xiaomi) <baohua@ker=
nel.org> wrote:
> > >
> > > We are doing a lot of redundant lru_add_drain() calls in
> > > do_swap_page(), especially for synchronous I/O devices. For
> > > example, the test program below currently ends up draining
> > > lru_cache 100% of the time:
> > >
> > > int main(int argc, char *argv[])
> > > {
> > >         int i;
> > >  #define SIZE 100*1024*1024
> > >         while(1) {
> > >                 volatile int *p =3D mmap(0, SIZE, PROT_READ | PROT_WR=
ITE,
> > >                         MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> > >
> > >                 for (int i =3D 0; i < SIZE/sizeof(int); i++)
> > >                         p[i] =3D  i%64;
> > >                 madvise((void *)p, SIZE, MADV_PAGEOUT);
> > >                 for (int i =3D 0; i < SIZE/sizeof(int); i++)
> > >                         p[i] =3D  i%64;
> > >                 munmap(p, SIZE);
> > >         }
> > >         return 0;
> > > }
> > >
> > > Folio reuse now relies primarily on the exclusive hint, making
> > > lru_cache draining to drop the refcount in lru_cache largely
> > > irrelevant.
> > >
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > ---
> > >  mm/memory.c | 10 ----------
> > >  1 file changed, 10 deletions(-)
> > >
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index ce8ef27e7a54..b5a78670bcc8 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -4903,16 +4903,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> > >         } else if (folio !=3D swapcache)
> > >                 page =3D folio_page(folio, 0);
> > >
> > > -       /*
> > > -        * If we want to map a page that's in the swapcache writable,=
 we
> > > -        * have to detect via the refcount if we're really the exclus=
ive
> > > -        * owner. Try removing the extra reference from the local LRU
> > > -        * caches if required.
> > > -        */
> > > -       if ((vmf->flags & FAULT_FLAG_WRITE) &&
> > > -           !folio_test_ksm(folio) && !folio_test_lru(folio))
> > > -               lru_add_drain();
> > > -
> > >         folio_throttle_swaprate(folio, GFP_KERNEL);
> > >
> > >         /*
> > > --
> > > 2.39.3 (Apple Git-146)
> > >
> > >
> >
> > There is a ref check in should_try_to_free_swap though, perhaps we
> > should also improve that part too or we may have more more folios
> > stuck in swap cache after this change?
>
> Good catch. We could assume that a !LRU folio has an extra reference held
> by lru_cache. Does the below make sense to you?
>
> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe92..237220ae1572 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5094,8 +5094,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>          * Remove the swap entry and conditionally try to free up the swa=
pcache.
>          * Do it after mapping, so raced page faults will likely see the =
folio
>          * in swap cache and wait on the folio lock.
> +        * Assume that lru_cache contributes an extra reference for non-L=
RU
> +        * folios.
>          */
> -       if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags)=
)
> +       if (should_try_to_free_swap(si, folio, vma, nr_pages +
> +           !folio_test_lru(folio), vmf->flags))
>                 folio_free_swap(folio);
>
>         folio_unlock(folio);

Right, this seems better. I've been thinking if we can just remove
that ref check in should_try_to_free_swap and always return true to
reclaim the cache for write faults. However, that seems like a bad
idea after all since shared clean swapin folios on non-sync devices
might benefit significantly from being cached, and such cases are
unlikely to be very rare.

Just one thing: I think maybe we can have a more common helper to be
shared by `wp_can_reuse_anon_folio` and `should_try_to_free_swap`.
Since the cache reclaim in `should_try_to_free_swap` is meant to help
`wp_can_reuse_anon_folio` (IIUC), keeping them more consistent seems
easier to maintain and understand. Trivial though.

It's fine this way too, it's technically correct and this is only a
heuristic check which doesn't effect correctness.

