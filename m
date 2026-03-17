Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C371FEDA0A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 609EE6B0099; Tue, 17 Mar 2026 15:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BADC6B009B; Tue, 17 Mar 2026 15:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A95D6B009D; Tue, 17 Mar 2026 15:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36E826B0099
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:01:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D2F5F5611B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:01:55 +0000 (UTC)
X-FDA: 84556474590.16.3715CF1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1523D4001A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:01:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcEFPDX7;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773774114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G6DnMrpwy81R+1cg28Zzd0r8ovxNQwv+LEtPGLckKTg=;
	b=bhkCTmKO9zs1IQe+GYXCvxyV162a7sMi3Hz/ROVy4r82BPVXW51Rh+USgDvL9q0QeSLRRK
	r89quVjwn5IIHEsywZPjL0TWJwpqMK4o6dpLFaatlRuSkWhLbWXJml13sCXOpCs7OWZlFu
	lWsp6OV0Rnh5SMyR7OvhSKE3WccZ890=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcEFPDX7;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773774114; a=rsa-sha256;
	cv=none;
	b=DftPwEqTxtQBsDj9gGJ/zvHiqHr9tjxXinTCMR74uDarJCwlHm5jinPN/rx2J02ZhiTFIX
	D3swkrRfFgNkmuAloaZKK+6rE7uvDbLCRS/BF9fPbaMWa/ISXdorzqzrAEiByrEI3Ap3cN
	WNyLJ8nOQvHVlrzsevoE+TfX1uGiLFs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6898D60103
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1740FC2BC86
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773774113;
	bh=X7+GZqk8XCTD7ztLtdVckDBkeqEbcXbOGabMkquTHY4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dcEFPDX7cHxHSgGJsjPkKNXCtgDq8YWDFkFT1/9yyZl2SjWq8qDHBmWIMS5spzVRa
	 LvStT4CyFvqRsZTa/j6aq6hMZx+thQP8HAbE4cJb36zHptDxmaPnfxHWHz4cLWJRmR
	 5FNH8Fe+EOshQQqha+V3mAHGCoDLhFsHFa7NDkfqwmH1QRGP9QQgJ0Cx8jSnJqkYfZ
	 MHZbMY2FqK0ThjMUEvMWkBdR8Pd9EOHsgrzhr9jYWofI4DX2QyJ6QK9iG6kC94pEsU
	 BtSveGdtFawavfkfHdpIUxMRxJH9ubeO0BRT9n5TzGJLXMfIQNc5225a7xzyx0f9bb
	 i+aPN9Nyn010w==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-661d20c9787so8803786a12.0
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:01:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXIpDS9ln9j0m6LJOlOTha3qDp3nl5jd4GjXke94rt2ssa6nJ6slAOKU/3+9XDcBr31debK9iCDXg==@kvack.org
X-Gm-Message-State: AOJu0Yww9+jkKJxrSRBF9lF8QcMpJKm07y+0rMCiUaHEw69OJ6ErD7FP
	OYB/zoG3cgbXH9kypieTW2zqofg3iODNzbikzg+YXRrQ2MdP9Jejw7JEsiqlpzMzdaiFJixZi0H
	GbkGFC1mTSJwuK9JkiJ6lQD9HHVSy4R8=
X-Received: by 2002:a17:907:e10d:b0:b96:f0a0:c7be with SMTP id
 a640c23a62f3a-b97f4827ae3mr18589266b.24.1773774111734; Tue, 17 Mar 2026
 12:01:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260316140122.339697-1-ljs@kernel.org> <13e09a99-181f-45ac-a18d-057faf94bccb@lucifer.local>
In-Reply-To: <13e09a99-181f-45ac-a18d-057faf94bccb@lucifer.local>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 17 Mar 2026 12:01:40 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMnDBNcssqG2zQgS85tzPLgZ+Xt436jdwdcqGi1d-=BxA@mail.gmail.com>
X-Gm-Features: AaiRm50rOuxq5oD3gn_aXSroXWD1S0LheU_1ipU_wik855j6J7PadPbdyuVIPsY
Message-ID: <CAO9r8zMnDBNcssqG2zQgS85tzPLgZ+Xt436jdwdcqGi1d-=BxA@mail.gmail.com>
Subject: Re: [PATCH mm-hotfixes] mm/zswap: add missing kunmap_local()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1523D4001A
X-Stat-Signature: e6qu3ws1dwpuexm1ko8d6sr8thpbyugy
X-Rspam-User: 
X-HE-Tag: 1773774113-276826
X-HE-Meta: U2FsdGVkX1937nxwmIw8/W1maLLzjc9EhRbM9ixNGOVUdWGOEeNc60ja/t/17IKeL1d+pCS3exii7fLo875ucgSz57XKSKFjbaYPpQwJjNZQrdnTagSRuFAC6vCQAonKMEqlFGM/1p/DvUpx5LW4O9hzqJq5huzc91ynq2BmWOyy5s6ny6sxtrWTvSuiMQ11bjKwgvj7FkYK4r6deM/zXLiBC5aJhR1gPmhFQ03v/wN06xbEOUVnGym1MJkUTNSb9JAf9YmxUTV3DvYRb0rmHtbK7QxaYVYs2DzNuXLtITKePpruAgmP6N5owI3iU1aFWsRSrQ478owTyQvNkSc+X3Ghs4OwhiqZ4axHAPU5xc6+02JUugh3GXdWOg8wv6xFyq4HjvudEH/uDZOL+4fEJFJ+/h9X+gx8Bkcjh191n8anG8AQrxqIrI3v4rrfzKFylSLg44DrG/d1WOwmjLvda8nedygGoy4upyUL/Pum1snliDRC8CrUsuAqjoJD+aJ9ywzaI4/QrXaJ0sexLyP/6XIHMCVimKsMy0ZO0r0vmluptfNkbM6PaPPbmgyovS/JayRHvu9Ee/6EIjZjgSsWXs6wNhx5y1EnTxtUFxX1Rlm/RnTaW0cBTaX6jlO73VQL9mG1cXk71MNlm6tYxr7P99w3JQfhxVdNN2/7Ml4BeJR4+rm6Y/FlONUmirhgfp3yFsO5eh+b7VajOB9ixdGg4NKPR1c9oZsdKAn2gOEm1ps++MkR/i4cPQ7VpVz4DqwEmQAJ7at/VD4Mb6RgQX6QToPHVVKgRoqJvOsZqTQuwOm9CRJ8clfDTkRUexetQ6f/RmEBp7WojF27s2TbwLdkScHeTL1cZutTlyp8jH97PGwrUyIB2VtS3vHKXfMddPxWZY4+FEnHeVzp5RzXrT3HOZbDhFK+tP4wsNFnLnJEdhk4upaCsND9YQZ5ooxTQ3Nhq+F1IAsB84JcJHIfIPD
 q5rprjW4
 CP8SX2vbD04TqZFVtbT5vqFjAeQsBkY2vGzwx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 5:59=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> Hi Andrew,
>
> Please apply the fix-patch enclosed to add a dcache flush which was also
> missing here.
>
> I had assumed that a new folio here combined with the flush that is done =
at
> the point of setting the PTE would suffice, but it doesn't seem that's
> actually the case, as update_mmu_cache() will in many archtectures only
> actually flush entries where a dcache flush was done on a range previousl=
y.
>
> I had also wondered whether kunmap_local() might suffice, but it doesn't
> seem to be the case.
>
> Some arches do seem to actually dcache flush on unmap, parisc does it if
> CONFIG_HIGHMEM is not set by setting ARCH_HAS_FLUSH_ON_KUNMAP and calling
> kunmap_flush_on_unmap() from __kunmap_local(), otherwise non-CONFIG_HIGHM=
EM
> callers do nothing here.
>
> Otherwise arch_kmap_local_pre_unmap() is called which does:
>
> * sparc - flush_cache_all()
> * arm - if VIVT, __cpuc_flush_dcache_area()
> * otherwise - nothing
>
> Also arch_kmap_local_post_unmap() is called which does:
>
> * arm - local_flush_tlb_kernel_page()
> * csky - kmap_flush_tlb()
> * microblaze, ppc - local_flush_tlb_page()
> * mips - local_flush_tlb_one()
> * sparc - flush_tlb_all() (again)
> * x86 - arch_flush_lazy_mmu_mode()
> * otherwise - nothing
>
> But this is only if it's high memory, and doesn't cover all architectures=
,
> so is presumably intended to handle other cache consistency concerns.
>
> In any case, VIPT is problematic here whether low or high memory (in spit=
e
> of what the documentation claims, see [0] - 'the kernel did write to a pa=
ge
> that is in the page cache page and / or in high memory'), because dirty
> cache lines may exist at the set indexed by the kernel direct mapping,
> which won't exist in the set indexed by any subsequent userland mapping,
> meaning userland might read stale data from L2 cache.
>
> Even if the documentation is correct and low memory is fine not to be
> flushed here, we can't be sure as to whether the memory is low or high
> (kmap_local_folio() will be a no-op if low), and this call should be
> harmless if it is low.
>
> VIVT would require more work if the memory were shared and already mapped=
,
> but this isn't the case here, and would anyway be handled by the dcache
> flush call.
>
> In any case, we definitely need this flush as far as I can tell.
>
> And we should probably consider updating the documentation unless it turn=
s
> out there's somehow dcache synchronisation that happens for low
> memory/64-bit kernels elsewhere?

Yeah the documentation is unclear to me too. Given that the flush
existed before, I agree that we should re-add it here even if it's
just cautionary tbh. This feels like something that should be handled
by the kmap API or memcpy_from_sglist() though, sounds like it's easy
to get it wrong.

>
> Thanks, Lorenzo
>
> [0]:https://docs.kernel.org/core-api/cachetlb.html
>
> ----8<----
> From 94989ab3d97f0cde0dcf59eba6466fee932ec4ba Mon Sep 17 00:00:00 2001
> From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> Date: Tue, 17 Mar 2026 12:29:55 +0000
> Subject: [PATCH] fix
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  mm/zswap.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 499520f65ff0..16b2ef7223e1 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -950,6 +950,7 @@ static bool zswap_decompress(struct zswap_entry *entr=
y, struct folio *folio)
>                 memcpy_from_sglist(dst, input, 0, PAGE_SIZE);
>                 dlen =3D PAGE_SIZE;
>                 kunmap_local(dst);
> +               flush_dcache_folio(folio);
>         } else {
>                 sg_init_table(&output, 1);
>                 sg_set_folio(&output, folio, PAGE_SIZE, 0);
> --
> 2.53.0

Acked-by: Yosry Ahmed <yosry@kernel.org>

Do you mind sending Andrew an updated changelog capturing the
reasoning here, I'd hate for that to be lost. Or maybe a v2 including
the full patch and updated changelog. Up to you/Andrew.

Thank you!

