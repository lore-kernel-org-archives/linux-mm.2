Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E057CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 10:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CB1C6B0093; Wed, 24 Jun 2026 06:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2E26B0095; Wed, 24 Jun 2026 06:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B7CB6B0096; Wed, 24 Jun 2026 06:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE586B0093
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:16:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9E4841202EA
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:16:52 +0000 (UTC)
X-FDA: 84914402664.05.27C3952
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7734714000F
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:16:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=detNAHgl;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782296210;
	b=aBBEGdS7PdpKorVoCGrID5ZIZsuVW8BZ/DvBK3JmecmHVC0fI9phHb1vBKFX/3q0xYInYC
	Hes6JA6Yk9TYxFKA8DoAaROuKiu0b6tESZoX53kU5SNKh9VcuYY+/ENbnAnSO5w2szvxAI
	3GsFjSiFC6RuWD3f+hIaEq7verh5N28=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782296210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQK2pBj8BQNKbfOl1F2j9HUPCiXxm1EiTKjrYcnAK4U=;
	b=QEMjbhUIJSAFzbuG6jLtuoxrbsrJ+NIgeYclQ9nBhTk4OkLFMwQAjMbHetGnb5jrlPUQYA
	hE23IMUTSD4m4xaDjJHdPlpnQLFqAnm4IPfQJQQAKTItxSqlGNQrAaniBlJJbOhllXI6Fw
	YqqRlO4dmYKEm7B9POwzRmjMHON8F6w=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=detNAHgl;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-697b8540279so1363402a12.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 03:16:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782296209; cv=none;
        d=google.com; s=arc-20240605;
        b=ZAghWvs9mAK8H//LP4X878d5BmCYunIK8phkluDfVaZ10ZmYVuEQLITv4aFRtvvpsf
         nsFHNACbd7ot0yrFv1+v+4azt7WOmBIDK0qlsUocPrUES8ySvH1nIpbJf9c+vK8vJwob
         9+UZDK3jUmbyVHtInJ9zA6nRD8Ug6SXNW89LqStdP3Tk9U6tbErRKrtQwRyZxROFcMWE
         FrvQ0F/KhGpD8CBns/lnzBfmWFJ82gilCG6fv95w205RBslKgS8CwD2zTu+SFdB/GEMZ
         yY/baNm5YEmbOk9ExzDylOI68fycPLS+8m+fEmqBJoiNkAVrm4XXbBisX5Mgm1XuFyn9
         vymQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UQK2pBj8BQNKbfOl1F2j9HUPCiXxm1EiTKjrYcnAK4U=;
        fh=jzPJ7i2WSDYmXM7kCesROrJz3dCs/Bnh8UWTGLK4isI=;
        b=AB94PxMHknDfK3ZEgAmmJzyMWC3njXQ763/06pHumdDeCBS7X5mFNs1GbuFoej6HF/
         XQwWwOF1d+4XFzMmduXMWxWZHcat3sJRHR7npasIiR1TNV5wEX59A+bd9FgN0xh4iZAr
         ax8YxfiyKvczNfYRGPury6J/93rQ9shi1HAgF0Ec1WXJq7vRi4pz75pp0fS4rLijK3dC
         bKv7RSVYI1LvgZk6/dpaSP22Q2WAfVzpruI8EY9R51tKrRUqdW5H65zaHS4Cmi8FnfkL
         nniwy/eSiki+Sxc8oOlkLRe8m0GePZwwW8AxipQtV0zo2zdm5xwhA/t3PPuQVxg77zbm
         /QnA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782296209; x=1782901009; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UQK2pBj8BQNKbfOl1F2j9HUPCiXxm1EiTKjrYcnAK4U=;
        b=detNAHgloOuC3uThThDOIW2eI9bBHakkqfHLX2ZmArXyo3uzkRbfIdz2/SxvGllyFj
         as5awEkZJ/9lg9eDcxldtBHJJxiL5uD2CyVwuV+3BkQSZ/yPaWchybMlnaCXUZw6t1eb
         Kr/1MXhD4pxF5a6t0ytCCMceHmZtTiVAZiQSo2HJnvT+t96pa/YxZKO+sVhaAy/EvTpc
         +xRr3XCiSeGEQlw9cQp2O4dJzxXXQMMKEcOcI+NjmwkTn5eRlJfx3j2LH7HRTwayvcIa
         xvaDVV8Gs1Z1iHhIId7C3OzhnPrGd587cDkTOBMvUi1Ev34lYzAML607up366ulO7kx9
         lu1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782296209; x=1782901009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UQK2pBj8BQNKbfOl1F2j9HUPCiXxm1EiTKjrYcnAK4U=;
        b=QjRrGVYQhtByHLD805i6NQf/klwV5kJStaBzd2wPQTc7n/23LdFeOV10ITbxai2QxL
         T/UCdJRSW2e4fTNmYTYb56bVC9xM7UfSGKAkna1pwGOD4vqt8wARhwM6znaVwwh7HrOs
         DyxTnkJQSFYjuaT9qOfBVJYioH25w0cWg0aFQKa5a5bliYBKDYKqUMsmdmVMmG6C2L5c
         3S45mnDYlwDX7zIJCUqaUExLNjT4uf/uL1mNV9iy/UURjqU66RNZdVQwMiu+eTU36UT0
         VJcVU6jAfxtAEoBOlNTs7VQ6i2G1QKgk7SZwW6B5EEPLl3dobXKxMm3ut3r9DwaVDMV3
         qLaQ==
X-Forwarded-Encrypted: i=1; AFNElJ8mVIWALWDjKjVANJ4AR1CcKGhmdpxPLmA8EF6EbT7cLgrWypzvZdw3DXsLpEF7TTkR62Z6YmCZ+w==@kvack.org
X-Gm-Message-State: AOJu0YwqqyxVGhsJ5EhV6NqgioXQDbx2A+4PiFBsZmHMDyZW12inHwSF
	gClWR6QPM4spTorD8FcXpxcw3nNMpqNRrCStq6yMaJWaUc6x64K85zY48Nw1dX2fKyqLOE8JBzo
	waq8lyznYj+2mmFkoGxXpT9hKUKTFdb0=
X-Gm-Gg: AfdE7cnKoNS/hJp77iMfWBZPZXnst+rRYF4M4Zv5iGwqQ2Ffpl1Y59zrJsW4KEMUMfh
	O0mK3dWr1SqC9n5PY2zuLH/qcBhDYpKQWy14/XT9IpulCG6h8vR/bN8lh3JrgHYapKSLcyeyFzD
	TdiQyFelzhelrAXmXcYmYdHUDMO40eHHt+X4ADBISeUly2VPiMyL6PBCgPYW9VkRe3zUlIwAgF7
	nKX6o/YgRE1j5dQMIlGkpI11w91xgkLdow6hDO+l/in8eSxWGpM6qXZSrRXRVcTkdyb0UDziLwp
	rW4Cihwrg0wXhsXDK9BCY2O8nIRG1w==
X-Received: by 2002:a17:907:c448:b0:bee:19d0:db92 with SMTP id
 a640c23a62f3a-c10803b52e5mr366822866b.49.1782296208510; Wed, 24 Jun 2026
 03:16:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260623231635.43086-1-baohua@kernel.org> <20260623231635.43086-4-baohua@kernel.org>
In-Reply-To: <20260623231635.43086-4-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 24 Jun 2026 18:16:11 +0800
X-Gm-Features: AVVi8CcGjG7rTM6Nobr68lWdfX8Fp_VEvlB1uBNZ_hzUUIkKMFN6zCaJgc31nkU
Message-ID: <CAMgjq7C7xOvwQHOm519CVh58CEt1hm9O1=AsduMPb5op_b3J8Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] mm: entirely remove lru_add_drain in do_swap_page
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, baoquan.he@linux.dev, 
	chrisl@kernel.org, david@kernel.org, jp.kobryn@linux.dev, liam@infradead.org, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com, 
	nphamcs@gmail.com, rppt@kernel.org, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7734714000F
X-Rspam-User: 
X-Stat-Signature: j4gxgotu3ct3eb57f3mr8gogojukbw6n
X-HE-Tag: 1782296210-93618
X-HE-Meta: U2FsdGVkX1/DmdCVsJBsu+JbZ0qNicHahCpe/uQfOedik4l2L9OarLUxnsjs1YCr8r8MpAkIsFqXvszxtFEy4EDLa6hWOb7P+qIE3+s4wfDDuT3fFnjonJTQobbN5J55nywvuICekL0b6tBzN7q/8/blkTJu8HragHHZYQiXarwQ3uh1GOV3hs0zrVIeVhSe2YUsivDa2uD/19R1ggKV0L+rGvtHOxzoUq7LrrPYfxWwTM5r89637HkidE/YtrZtKH/LPeUkuhB0I9aZBYFVXXhLzKdLAKXRmD9koMISWZFEZwIaf1jA9N5BR93uW4N48mp3amU1sHV/WQ6Qe4qrPJQNgcdvfsu4IYKiZw5NOQd+hZNP1bj0oG6xnRMkJ5JanZ/li0DyOQAWgwQ5Ek7i2LrHA5e3l49ZDYwMbomrDcFRBXG0iO1KmkWTXDMdolzzAF7dX3IcIiYQdWMJdSGOPrehEywlziu+odfrvsgr38jU73kFxvIbvq3qA97pid6BqGE2ce3iw7af5bQGu6p7E4HWznIHEMxY1uNRaMGIoWoT8B8qotZ2mywL0g1/HUNORskmTYq6c7ZZbQRfzmfmjLIjWq5ohJZt72NugsZDN/s7gVRjAn74CS1oqt7kPxllxy8FoUNIaIGke8DzCyJVlIPMh2mGM3banaqrCFkxnbBBgQ2RmeKUeHJJ6PKXA8PvYfm9E0po2Niyxkf1BlfFplvoRG68edUpbeTR6GJBCMlhVue3nDhjFhk8pj/Gy1eF8Gz6csLzezgaNxh6OE9GJ26GpTXuBIFJtbTpbaKE8tbhzdScBrIcCqf37yiDktFHwadnTbJ2EAgXtHt08FaX1sl9cGkelZzBYOeAoUYHMZu6nnApRtDDvEtlx6KAfG/2HyNOVcTgXOmpVRjB5PECvDxHfDngwVexpnSzz3W3X7je2blAv7PIaTtlYyDb8otbf47ib2TWBc/uYNgmByM
 ERFMzHwR
 vq8h91vxTfG7lfmBeIpXDp8IW+vz4cO7oLHB9Q+0MH5SrbHb5LHK999efrnu50DpaYySBNH7Xurqhk4AlhNDqlkVaWlZXbEoQ8MQ2l2jU6JmEFLDjCNlWMYF/28nZZDX4cJEjK8hk7lf2jUVy9t+cX+/p+U4/asDvzhSoIImaR27rfQuK7TMEu2bVzi8S246ua6kNh09BwZoFxmO3FmP6XRzsl+BKCobjbhUX+ChlJtlBkYKEnZyHS01+mtMGiZQo6Qduyb7URvNlPePLOv/bVuMeHygshsJy5Es9raQnA64URGJ1DP21/3l80oXUGQf9/T+Hn9FCCt1ebLePOpeFAhKa7oxv9oE/s99vr6t75O89dEhJWQJnGD+sRdmJCDDZK3V3Wcm/YqAviENGj4O9DEapeOhrKBQtQStdV4gQG8GX6s7hjvScqfyzfZW7Manj0QbVTd7CxEKjBWBxHgH2JE7PtslVkF8bYKol5R1tWgzOQkuIixPrWZz0pA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 7:18=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> We are doing a lot of redundant lru_add_drain() calls in
> do_swap_page(), especially for synchronous I/O devices. For
> example, the test program below currently ends up draining
> lru_cache 100% of the time:
>
> int main(int argc, char *argv[])
> {
>         int i;
>  #define SIZE 100*1024*1024
>         while(1) {
>                 volatile int *p =3D mmap(0, SIZE, PROT_READ | PROT_WRITE,
>                         MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>
>                 for (int i =3D 0; i < SIZE/sizeof(int); i++)
>                         p[i] =3D  i%64;
>                 madvise((void *)p, SIZE, MADV_PAGEOUT);
>                 for (int i =3D 0; i < SIZE/sizeof(int); i++)
>                         p[i] =3D  i%64;
>                 munmap(p, SIZE);
>         }
>         return 0;
> }
>
> Folio reuse now relies primarily on the exclusive hint, making
> lru_cache draining to drop the refcount in lru_cache largely
> irrelevant.
>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/memory.c | 10 ----------
>  1 file changed, 10 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index abd0adcf65f0..2983a6baf474 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4903,16 +4903,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         } else if (folio !=3D swapcache)
>                 page =3D folio_page(folio, 0);
>
> -       /*
> -        * If we want to map a page that's in the swapcache writable, we
> -        * have to detect via the refcount if we're really the exclusive
> -        * owner. Try removing the extra reference from the local LRU
> -        * caches if required.
> -        */
> -       if ((vmf->flags & FAULT_FLAG_WRITE) &&
> -           !folio_test_ksm(folio) && !folio_test_lru(folio))
> -               lru_add_drain();
> -
>         folio_throttle_swaprate(folio, GFP_KERNEL);
>
>         /*
> --
> 2.39.3 (Apple Git-146)
>

Thanks, I saw the previous discussed problem is address in the next
patch, it's totally fine so:

Reviewed-by: Kairui Song <kasong@tencent.com>

