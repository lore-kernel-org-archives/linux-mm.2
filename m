Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0703CD98E1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 05:38:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A16326B008C; Wed, 17 Jun 2026 01:38:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A63E6B0092; Wed, 17 Jun 2026 01:38:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 867A36B0099; Wed, 17 Jun 2026 01:38:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 401AC6B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:38:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B80AE8D109
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:38:16 +0000 (UTC)
X-FDA: 84888298992.01.1FE65EC
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id A786AC0004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:38:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nCtMfSet;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781674694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PdQW7mnIcxU0xqvK/Mu+/9ECddk8GsYVD9sGy9QjVDU=;
	b=qY3mDWr1l8Ifk8E207HKVvEoyaE8hkbG1AlQftVS9Lc1ht3cGDqmLDv3RS5z4U2V1B2ZSB
	4GM2p5StXO0dSHHD/ATiL+spvLdDtBahRJS2LiIYBOsWnUxr6mrppRp5+81TSlmonUZRKY
	P5XMMSNCAehUONOZPjwtyyY21a0LF9s=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nCtMfSet;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781674694;
	b=vDQ9TovqfRLkAFLnFWy6SWWIzsafA6fUnl6j1O6rjig0moVaUEtdxNfnXQ4KA5f4OleXBU
	aSuBEZFCzbnzvWItd5ks/wwhYg7c2Qkh+yyyaFaWEheJvtzfMLcax/nVC96LvSpzYaviVs
	f1iu03H3JrLjSWlHYoosEh1yuOPL6Sw=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-bec4639953dso913548466b.1
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 22:38:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781674693; cv=none;
        d=google.com; s=arc-20240605;
        b=HD62DEOEnhxnBlE/04LJXVmAirytfFl1AWntZ/73I42Liid++Yhz0IUO9xANTJGyb/
         2FfgV6vVB5fgcEr/cE0vim7hS0iY1wNiA0wcrmKZWSK10ywPU/+1rvVaD198EbKWAq2V
         58usijJOafMCZ5U8KYJ3BoxgRSznktsxTJvwNuYxXu7imKo5M/+NUU5GuurvoNLpkrYN
         b4dEhdsp8u3VT/W0yeFQeJ+CDN3TqLxBDsyyx+dKKKvsGNilWbETloa7EIv2j+3cTQgu
         b9V2SefHCHzFvGFepOrUy/i8959ItxEPHdp2mPMoqCunBbyv3cFHHNBEq58P6npjrnJe
         +hCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PdQW7mnIcxU0xqvK/Mu+/9ECddk8GsYVD9sGy9QjVDU=;
        fh=K4WgOPzKekD4aiunQrky8FkEah6sfEQdewYrjLS9UZI=;
        b=lPs8UOVNhReUTTg73W69hxPTEqidoQe05zgqbjMPsRlfFMUX/aoROzlfs7nLBLRNbA
         vveH6lXTUgURNh3O/+Rej+j5I3/d5P8Teqdu12LBD3yx+aoBO0SG7OwJRiYLEtXEHHgQ
         BdJGive+mhkg3ukByTkxlttN7eKjh7rI3L55PuxT101vDgiTpR8mPXiOzT+KqXb2trck
         wprAMDAli0jji3oUz1D+w9TTYLQzRUnO64NunEXvoitiaI0yS/BP3YwZxEWu+M/ZJ3lx
         PeqXAUcUb4kKljZgRmI295A9BNqJyRqyo4afUIQfUGUCvmT7Vo8dFquSbi25tUFgDR4j
         oopA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781674693; x=1782279493; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PdQW7mnIcxU0xqvK/Mu+/9ECddk8GsYVD9sGy9QjVDU=;
        b=nCtMfSetIvqZqrgqx/KhMSQd57nwD+o1xTv8AvALkvsjkjlXAS8UEjUQSadqMCnU5H
         L/Wl3b/v+3KsAKSWyr4v0iWf6Y4xdcPQkQsQE/57vVWELu6XosCvnD/wilReE4yFztqq
         uNwMPPyuNXRa7J32L9r1aju2kF1MZBgBMq8k97Oc0HpJCIkaKbcpZE8C/XNA/KAk27gb
         9b9oZ5gcXCl0s6ogZSHcny3Fq53iRJJSmqQ4v/Czhm3MO92bhI8h0UwkoDEIdtdZWeUm
         ZRArkTt9iQEuj3Dz/cYgvNnl8S1dZpnhEW/rnNv1yn4hPLmiud7PwcnYqJDjQ378eDbo
         g8kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781674693; x=1782279493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PdQW7mnIcxU0xqvK/Mu+/9ECddk8GsYVD9sGy9QjVDU=;
        b=nDgGUhRBoQYWoOqU3H5PliJS7JrwCv8qz4xoSFFXJhGqZuqguhcvg5QqlqZbXAMgqU
         tma/WBqDKeVVKnvBTF78v8/A6DNIWrFY5oy53oe5GTyWaz4IbE8zSt88mJd5WpWVa3UY
         O5JsHdwWHOTstq0iG8HzWqzH4xCXw6ShLxPTHxfGnYKsEAVS4bCxMBhF2SQ7pOn8+o9k
         nnKR+stO9YP9aQHM7u6V7jHPCAFtD88N9XQ7x23q/z89fSgSuzR0S64T74JYxd6KlvsU
         swlLKDahM9xy0bGbukTYNYDScT3DlDU5ib+ZwrhXhz37QcV22WhopGtwJSh/eisovLDZ
         fpPw==
X-Forwarded-Encrypted: i=1; AFNElJ+EF1sKs8pAll9fZgbfPL5nZlC+JFKkuTVfXmQmSwVfBCuKItVArFgUdJoTi6O3JOjMCQITbq4wwg==@kvack.org
X-Gm-Message-State: AOJu0Yxp9MHmqI8qk3dBUuHkN3zUcwIsXCMdFjdCJ3zjUSUhsJ6yMR64
	0iILDy6dd0EbgwGzMThB1K46DRLTNsrOeIxw8iBnAvCz3Bb1djGLCwFZAoy2dZB/w+XpW843gIN
	UPCle5Vm9YA7+lUSoQ8WIpO1ZvmC7DAY=
X-Gm-Gg: AfdE7ckH7r8y9CTIZZGLBxx8r7DILUo8NWMcuudBpVU4MiNWHb5h9kiYmoh39ZfhMoU
	SP8betgZnsyiDALlL7f6DGEqd1uSFjSeVP7H7bXg5o5n27zyW1iUVIkCICFxNFKmLxYmFIEqRB1
	cPIhYtKKHgNXjeGf9sfnhPu6P4EAJzrHxbcpbjOXtkRTh/6aseOZNEhOyb5Q7L9yrnMua2QwWs9
	Y7XfZEaFjzpdjDOeG4ND9cIwLUiW8xO+8CG03VJibvPCj6AbEKS5Eb2lSvxb4eixXGB+CkMTar8
	7l3Us3r5p/MeI/cc9xiLyDJAX43lYg==
X-Received: by 2002:a17:907:9701:b0:bfa:e08e:3f1f with SMTP id
 a640c23a62f3a-c05a75aad0cmr150086066b.24.1781674692659; Tue, 16 Jun 2026
 22:38:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260611105124.98668-1-baohua@kernel.org> <20260611105124.98668-4-baohua@kernel.org>
In-Reply-To: <20260611105124.98668-4-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 17 Jun 2026 13:37:36 +0800
X-Gm-Features: AVVi8CdLTOuFJ-mkBK6j-dUcHm2a6jWsu2wtl6C_XwVm55bph36ixS-HJBe3umE
Message-ID: <CAMgjq7D0roMW108dP60PaCTnYfSDCA7GyGDATn-nLD8kiNViuQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] mm: entirely remove lru_add_drain in do_swap_page
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, 
	jp.kobryn@linux.dev, usama.arif@linux.dev, shakeel.butt@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A786AC0004
X-Stat-Signature: ykzmpfsjcrgbp8h5jz47jamnwdykc4ep
X-Rspam-User: 
X-HE-Tag: 1781674694-446540
X-HE-Meta: U2FsdGVkX18UuzPUJcfdi3O0rSBIc+l73jKu3z1qWSdIfVnH4ijtoqGFnVpkeJexhSdVpxi90UUTnRUdHDr3s2XOsgaV0OVjD5FvLzxLHzqNhM9xjYAACgZUr/UcKSHSVMFJX+kUmv7QdE/Papqi011x1MSIIfQ0YnfCGOORbZbr0VtKhA5tz/lebXudsEVLDcg90v4H6co0yXcrWsH2Cr+uxpOfi34bj/1XxQaEmg3+W5hl+pXsg36lzwYa38vffMZwvSURNSPUe27GrLu7f4gw/sPJ5Y060uKHOsdYj8tkZfBIwm0E2MuEQOLq4XaaYxFP3lrP11dYcmuCYFkas43bC20G+JSEEHEJVVgPpHZz69eHWddEpfqisO+j7sWdkzkalGeZNfcn6wtCmU6K4PmAOC+bXg6Z0z08ttJHyRdQ34Y2D+hN6R+kZtl5KB27+sTSoF4+TLQtZHmPQaBKl7osDE97uWeN/w8idi953NvX5Z2E3fACO0jypqkWnrMi/8ffE8486z7S76bheAfiBN/6gHlFm4LydfAu02YwsE7Q1Hy10wiSR8cKKlaFg342D6g5QeU8BdQk8zJVw/k/mOffw87RNA7H2B0JP84QDjS9MYJDFhKKZF65HlnDRYi6JcWMgPzZAmQz2Jxww9AqGyfQ+Y1lyZmI8D7k1lm1csF8m9xZl+oxV6v4WJXc8PbrmcdX/QldQyRi/SAcHMDcMhAdy08eQEHXqKYgBUz5dy9jI8weTf9FTCUVeQYphkHkd8PKN62NezL8n1vIyi9ul9k2VGm+qE/UgzgzZlGq54t6tx7nWRNkitk9N40KJLPnZoRYPGj6PKc4z4uri26BQeYcjj5oU99BHZoTV5ouqVqjhhRkAUNdUmpxcQgiMlCrGjVESxXYeP4hUJxa3eHClld3ZECwYwI0fx2RcTOE68CB51xhMR0VMfoDGXeCrKqwEoC4jtxN7NXZsGvatW5
 DWyD1hBb
 fylMPjp1d9FZZCvJb932ZzZe9AMeBaktK9ixmSDshB8fZ3izn0hfkeaO0FWV4mRKur3qaqr6xWyQ68cBVKWAC5kpx0xiBQGJG9ziDqmegnaQEaImJJZCBqUXWlsnppDCf2osRThPjUsqP5e8GdhmXWn3lanVnlQpRYz8e8ZJi4wQ5gH02F5gQ4XzPjRvb9OMBOGuRplysJs3yps/2HWH26dan+sWVuninkKcfrNhwJzykM9KvwQUL5or4GMrCn9VHscgJG/vkg+FBar3ZUCLqlAtHZQmtjuhweZnLh+mKppnov9ccUHoJlnClvfDjfIVsOa/CvSvksT3UnFh8EmOVLhFo/d4Z8/pejyElDKkrio6GWnGbgg7xQuUGu3UCDbCeJuWwRFw9O6kJZCFu8lWIXx5SxwMBZoeAwByN66pDeTu+vT8Fl5r+quJisFbEzTPhPrcaz0PG3oA5fheqQJkzyoeHsx3hAcL+J/r180oPX4Z7cTtduqf5XsDFHzOWPdumXDKp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 6:52=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel.=
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
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/memory.c | 10 ----------
>  1 file changed, 10 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index ce8ef27e7a54..b5a78670bcc8 100644
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
>

There is a ref check in should_try_to_free_swap though, perhaps we
should also improve that part too or we may have more more folios
stuck in swap cache after this change?

