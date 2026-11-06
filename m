Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735C7606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZUo9TfL0
Received: by kanga.kvack.org (Postfix)
	id 72EB76B05B9; Fri,  6 Nov 2026 02:07:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B86F6B05BA; Fri,  6 Nov 2026 02:07:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55A676B05BB; Fri,  6 Nov 2026 02:07:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2708F6B05B9
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:07:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 606B11A0190
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:07:40 +0000 (UTC)
X-FDA: 85403813880.28.04EB68A
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6D5412000B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:07:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZUo9TfL0;
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793948858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SyAT3kgnB5A36GtJplToXCiU6rWfBoePnhWMVO882hw=;
	b=mkCBUfs9gC+iYBZKFbZ4pNouK1mHKxlGC5uH0KVSHvVWJmkHLCf69LC6mLTClfQ8tWmV+r
	r+kgaWFTme4d0vxcCKzq5DibAK/+rKug4sKviagDGGc8XmzV9383VMecSzVgxbBykfEsdY
	7UdPf17siYf26d5FA9ehl1FSKj20Tw0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793948858;
	b=cmiJrx8RGmBNU03vwmr61I7UOmopPWW4eXEhNArwwuxx1uI0xuvKZAnYqZ4vq699PlurYS
	gd1NWON5TsdjL0gNWz4zSX/kSNYg2/3nnXFF4o3GyOhpTjuHfYe9dgAqS7r0jrQJe+x0qy
	H459Ifni6uIztOb2jVbgUoHSrQ1sOus=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZUo9TfL0;
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b1dae0febeso368061a12.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 23:07:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793948852; cv=none;
        d=google.com; s=arc-20260327;
        b=bSg5rup4ybWEQbt3vZFYKnaHm3QzOONNMwrZY6O31HOkilBBj/fV0hu8K53MoabL7q
         wWE4ylT5rhDNRodSKdbqFcRMCbnRMb9asBnJkqTfKWKxWmpYVz+lz/BWjblL7lpcgfL0
         huZqmBZ+WTId5xUbBarx2GVAw0lJ0kZJ0qM+zG3GMlHHxXLcCEJjt+PddJi76hxoBuLm
         69+wg34ek0Qd2WL0ECmRxDg8neinwa6F+WHbiAy2C5peHQwE0mUqPzvcz+AvQLD3cc3P
         BornJFbUacB8lvi9vXQXqQiLOsBpYFdEaOCCtz/qLuV4yeKUNNbE9a99BSZDTxFo3LRJ
         pKnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SyAT3kgnB5A36GtJplToXCiU6rWfBoePnhWMVO882hw=;
        fh=CMo4IE9dTwVRR8TugaU8yNp2kXiVb/UbL8HIRiIzJUo=;
        b=ZCAFXwo7R1hHyBxht8aocBX9bFfepFr5SaYyVNOMiGWypghcOzyMpyIYe7ySwMJ5ko
         Te6c4VdPzdJueMPR5mOJPnuaHggv4nqdc7VAVH5osJsj1DaeQd5xMDDISKiriqofhqGY
         J50gP4RIisckuevwd9tCzMJ49sDJ8YqqpELkQOUdGGPcXahCDftxYTu9NyrTfymamF8n
         PhqTxj0QUu6G54eTSwL66thABOeJ8RYthdTY3BoAnTIeiCgKfoerbLSnO/Rnl2KoXjv+
         qkxNLyddrCLUwBNwGZjOeteErqYHT2i7H159Hawu0kSyZTq4OUzJQ9F/2iK4iEoQ6Reu
         rZAQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793948852; x=1794553652; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SyAT3kgnB5A36GtJplToXCiU6rWfBoePnhWMVO882hw=;
        b=ZUo9TfL012WVMItVWzDjvUiPtstXuFD29mw1fjFYi4ocE8q0rDxRdJRAuH16miLvss
         HGNIuTI7nQHFZwQSmLCyn2+EJO4H0wRvfvcFZbJmwlpdpONCeYpcsWZsAfgCWxZOGFMM
         LxSnvMvlzQut6SrAaod3uhw+J/KJOXnBG0RcI434jsjdl8ZYK1q96kcPOPUQ5NetYUHe
         24oDPrtAxRqJj6IZzM6HwVP3BFzADiDUzQ2vTPFzfw3sUfnOHoVPhgtkGq7LmqLIzB83
         dlmeF5NT3rkBjlM3hQWySVCwTlYMg53wcCrSwWtp6bl33pRFuizdqCA2fKgsDv3EnEzW
         80xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793948852; x=1794553652;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SyAT3kgnB5A36GtJplToXCiU6rWfBoePnhWMVO882hw=;
        b=WX1urebLFRRJb8Sdtu0MA0sor3uZinQ186v//lsHOzPsVAOb8Pm7V1DLhv/6sYcSJt
         rsn4JRxsn5IjRAuLBHfRd1DkXenG5WlnxAu/WeWKupnSLkUcm0h0H+jL/BYUdrbDi9Lz
         BGsH5ltRM9x9Y+LNcyVWD+fgfQJnCohGqgl3dfCQYJD28fpLBw/AIcyIspBX9mg+2T7P
         dO175TwB6IEopoz+jtN/KCLsH9BVQ9lw/lf+QNjickaansZObpk8BlfgGAd2cFWyXrh0
         apW5MexdUEqhSGX9Q/I5dSBQsIVQQu5Kgy6g3mM/I9sqq8+LfF5I0q+owHovRnG8eODu
         eTbA==
X-Forwarded-Encrypted: i=1; AKwUvByjBb0X/EPxh3MnMiA+9uX7JJbi7M0NUc/uWU46z8gvFlWJNPOt91aZhFd3IeFN19h/mxIxgQ+duw==@kvack.org
X-Gm-Message-State: APuU4Z8ZtyLIY5d+ua20JuBhDBB4bxf+RLPcYFEc3c5Cooh2KZU5piDu
	ijELDvCdSkqFS/4BHLwTS7j6QcdVBwyq2iV0NgQdjFvu1IWZuDLAj+hNmOiyieYh4viVVst4t4w
	/MJw8VqjPf69x2YPyiDMyAHEqhmhpJDI=
X-Gm-Gg: AYBFou0flJ5I461GXzhcSwmlRbRht1zl8v7HxEbQoCtJLZ7N4/1EBP06gSQ3ieVCZlV
	WKGOE8eEpNPBP3sJ/IM4b3t8hUOHf73pyTNbxzPWuePPpiSbPVoyWYQFDEe/uins/2zL++mC59m
	PdeQrQzq8xLLXgsOBFZ5uUe7p3UFUNFDqKX8E+Y+pCPU2PJ7XCplci6+mB7FTEDgNDxscl/8hnO
	D2IQ4bAzriKcnG5vq3qSuBRkq1PXlflJXzQVzgaPCc+WWLRCiSZgE8RQXTaw9oFERX5AGUN8Fwn
	ExDpFyaXgcQe3szzPf/pGbVaIiaJBg342SGBHrZu9zmJeaFehxIHcNw+A6puh1w601EuwHx4XJM
	efWzOHm5ekFKy4fvdBNgn4YynOG2WvlvQrF4Swsx+S7TpPsBhWhY0ubB2XFo0rQlIckjUZbJCpp
	rKCyWA4r7YjNCLNg==
X-Received: by 2002:a17:906:c150:b0:c46:9ca9:f524 with SMTP id
 a640c23a62f3a-c4d354b9d04mr130447766b.32.1793948851462; Thu, 05 Nov 2026
 23:07:31 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105-swapin-large-unmapped-v3-1-d5906e4cf18d@columbia.edu>
In-Reply-To: <20261105-swapin-large-unmapped-v3-1-d5906e4cf18d@columbia.edu>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 6 Nov 2026 15:06:54 +0800
X-Gm-Features: AclHuK_6llSzkyRcVYdlNTM5aGEuCM6qDLFo0-sBLaWSUDxDfNf218-kWrSN0Bs
Message-ID: <CAMgjq7AMjQpW+yTKKwuttNvVGeHfc1Nc=QDP836q+arsB13Lag@mail.gmail.com>
Subject: Re: [PATCH v3] mm/swapfile: drop a large unmapped swap-in folio in unuse_pte()
To: mt4022@columbia.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: r95dxk5rcrsp47nzf1ab7wnbqe4ytz5s
X-Rspamd-Queue-Id: 6D5412000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793948858-626002
X-HE-Meta: U2FsdGVkX1/OwNaW7pzmaLF1w7sqv4CpsNvNh+ffWJpmU623FEj9CJY+NmA0hcbDIkNvKv1inXVdgGHr3DlpIJj/lKC0yFMoEw0tpoLnsfFGVjEbBoQ0PX4M59oAMWJM5vjEU1iQmnomJ/pregbxhuGBPcqljTmDODO1utKeynX07MsLJAy/BMWnbsvvy6FTYllvePcWeiuzbRnio9c2KvMh0w2sRZ5fwwhDaJ278sXLAtkplYcIayNWndoBfkaxp3/24pB2kGzOlSttC5fLwTVA4zgKY9O95YswmPlIG2YdFujuBzs+pTURcI6jn47fpBbeN88FZ6SolNmlYLiPSLCy920m3TWdD+WznyE2tjDQv3J1/3slDUiCaAGCMZR8GNTrzK2nhC7jNr7anxZ/CCrqa2YDuGuT6wF1yHbr1Vvyq0jzGVvFtIrO6RbS+gHuAbDGqEjJeUKY3dn0WIVfdZQlZJEBWnkvHSbNOaB1RHNkzW45RB/cYO0LS7YgozC+YgKYFATg7Q8LLP+mWh74zu7YXnBdvtZb0O25jeKO8E929CFZHAZ9EQz6XHxNoMGwXGdZ7SimLT/1PFzgXcPNZzfMx6jbgYyuxqjzHtb63RjATKQCxLDYT1LMBhqXGLUcGEsmXFQn05WwdbgKMjrzuelKj/PRY+mpqrP5Vgv1bNVTB8a+FbiabX3EXE+QLWb7HqoYD+76dvIyS3ey1qu59xUsRFiXGddHLbwh7/ImBYAq0ic5S8On4SqPVYPec0c7onqhqSp7xGKEqVGRTvzK44C9sXt7Hil61KFixFB7UMPoazK1dZ70Fky6rx9Rbpw5BZhAjTtROn5FmbtMHizZNRJfwB0RPOsxrrHjhffhWsN4hV9coUYQ9MFtKO2yxt6WINMktUtJpUxmB9ExGFxiR55AhLEZOhuKc9uyFkgOqqFzzNY8ADuFv3uCUiOQTkxBIAwhFZTpMCAZuawgi5g
 NqRONuQF
 hyC3o/yPfC2LuDMc3wO7FGMoHGNLr1l+BiYl1nQVXk4/XIFSdnhHI3/YIxXqCp8QU87YLGcAEkgdNYujSwPA/GHY/XL7kF9KFYm7Ntr5BCrbMkwFLaFXlVB475pnAzr/7IhTch84XdvmlFfTCR3fTnl3gCUfJ+uZrEx/TLQba7hjWYepi22pDn3cPSS/FQmxq5FqxsbakojvzW0yElGkmd4lAK/zoHGuFwd4J4p/lcPJIy+O6X6u/QY6ySoSnfuLW7Iv83LYxF8+gQqPBuUGUJXJoqkCbTJkZmrju3tRxpyTrTpAyVVy9XLlJsTsCE9f0Km57irfuDNdpHNzbIppxjlXBD6QNedAzhOcQ9oT4dC8LL+ADeHeHB59ajOf6hd/ukXpxF4A3DirWdZ8qPxlFEKTP+x/j63DGLk4tXjTrvYKqmDbqgOmU+FF3Gg8u7Vvhhq4ILB+KqMDQ8KyEBih1oTfoUy6sp8DO7gBAUJvfVgod45cimPniZcP8aXL98P3lhJ2qZy8//BajgHd58o1KvQorX2iL5YioHHHUZBRyEm0oXyP9vsgE7vos+akIOMq0tZUL1gskfYYiLc3TQ0RCDbv6MYrdNGr0vBo171MGDZ/EUBk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 1:28=E2=80=AFAM Mani Tofigh via B4 Relay
<devnull+mt4022.columbia.edu@kernel.org> wrote:
>
> From: Mani Tofigh <mt4022@columbia.edu>
>
> Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even
> for SWP_SYNCHRONOUS_IO"), a fault can read a swapped-out mTHP range into
> one large folio in the swap cache.  The folio only becomes anon once
> do_swap_page() maps all of it, so if the faulting PTE changes in the
> meantime the folio stays in the swap cache while not being mapped or
> anon:
>
>   Task A (fault)                       Task B
>   do_swap_page()
>     /* swaps in large folio F */
>                                        madvise(MADV_DONTNEED)
>                                          /* zaps the faulting PTE */
>     /* PTE changed (F not mapped) */
>
> swapoff then maps it, which marks all of its pages as mapped and
> exclusive, and the next fault on one of the other PTEs crashes in
> do_swap_page():
>
>   [    6.424485] kernel BUG at mm/memory.c:5195!
>   [    6.424503] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>   [    6.427654] CPU: 0 UID: 0 PID: 67 Comm: swapmthp Tainted: G        W=
            7.3.0-17087-gd865f2677c44 #1 PREEMPT
>   [    6.432665] RIP: 0010:do_swap_page+0x24eb/0x2fa0
>   [    6.451035] Call Trace:
>   [    6.451567]  <TASK>
>   [    6.453841]  __handle_mm_fault+0x13b5/0x3b40
>   [    6.458525]  handle_mm_fault+0x16f/0x480
>   [    6.461143]  do_user_addr_fault+0x312/0xa30
>   [    6.462044]  exc_page_fault+0x66/0xc0
>   [    6.462846]  asm_exc_page_fault+0x26/0x30
>   [    6.476708]  </TASK>
>
> do_swap_page() already drops such a folio from the swap cache when it
> can't map all of it.  We move that check into a helper and use it in
> unuse_pte() too, so swapoff drops the folio and swaps the entries in
> again as small folios.  With the fix, the next fault doesn't crash
> anymore.
>
> This bug was identified and confirmed with the help of a deterministic
> hypervisor currently under development.  The C reproducer below however
> hits it within about 1s.
>
> Fixes: f1879e8a0c60 ("mm, swap: never bypass the swap cache even for SWP_=
SYNCHRONOUS_IO")
> Cc: stable@vger.kernel.org
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
> ---
> Changes in v3:
> - Don't handle a dirty folio, the helper already warns on debug kernels
>   (David)
> - Keep the comment above the check in do_swap_page() and say "some folio
>   pages" instead of "sub pages" (David)
> - Drop the note that the check goes away once folio allocation is unified
>   in the swap cache layer, mention it here instead (David)
> - Add Nhat's Reviewed-by
> - Link to v2: https://lore.kernel.org/all/20261103-swapin-large-unmapped-=
v2-1-87c70e597250@columbia.edu/
>
> Changes in v2:
> - Move the check in do_swap_page() into a helper and use it in
>   unuse_pte() too (David)
> - Use VM_WARN_ON_ONCE() for a dirty folio (David, Kairui)
> - Keep a dirty folio and return -EBUSY from unuse_pte() instead of
>   dropping it, since dropping it would lose data (Kairui)
> - Rebase on mm/core.git for-next-fixes
> - Link to v1: https://lore.kernel.org/r/20261030-swapin-large-unmapped-v1=
-1-41e4ae378e6c@columbia.edu
>
> This is based on mm/core.git for-next-fixes, on top of David's 7f2c000ffb=
10
> ("mm/ksm: check large swap-cache folios before mapping them").  On mm-new
> it only differs in context and applies with a 3-way merge.
>
> The check can go away once folio allocation is unified in the swap cache
> layer, where allocating a folio stabilizes the swap entries.
>
> Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/sw=
apmthp.c
> ---
>  mm/memory.c   | 13 ++++---------
>  mm/swap.h     | 10 ++++++++++
>  mm/swapfile.c |  9 +++++++++
>  3 files changed, 23 insertions(+), 9 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 91836d217d25..10016f7984fd 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5170,18 +5170,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>          * If a large folio already belongs to anon mapping, then we
>          * can just go on and map it partially.
>          * If not, with the large swapin check above failing, the page ta=
ble
> -        * have changed, so sub pages might got charged to the wrong cgro=
up,
> -        * or even should be shmem. So we have to free it and fallback.
> +        * have changed, so some folio pages might be charged to the wron=
g
> +        * cgroup, or even should be shmem. So we have to free it and fal=
lback.
>          * Nothing should have touched it, both anon and shmem checks if =
a
>          * large folio is fully applicable before use.
> -        *
> -        * This will be removed once we unify folio allocation in the swa=
p cache
> -        * layer, where allocation of a folio stabilizes the swap entries=
.
>          */
> -       if (!folio_test_anon(folio) && folio_test_large(folio) &&
> -           nr_pages !=3D folio_nr_pages(folio)) {
> -               if (!WARN_ON_ONCE(folio_test_dirty(folio)))
> -                       swap_cache_del_folio(folio);
> +       if (!swap_cache_folio_mappable(folio, nr_pages)) {
> +               swap_cache_del_folio(folio);
>                 goto out_nomap;
>         }
>
> diff --git a/mm/swap.h b/mm/swap.h
> index d5bf21f517dc..7779ccff5a0d 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -464,6 +464,16 @@ static inline void __swap_cache_replace_folio(struct=
 swap_cluster_info *ci,
>  }
>  #endif /* CONFIG_SWAP */
>
> +static inline bool swap_cache_folio_mappable(struct folio *folio,
> +               unsigned int nr_pages)
> +{
> +       if (folio_test_anon(folio) || !folio_test_large(folio) ||
> +           nr_pages =3D=3D folio_nr_pages(folio))
> +               return true;
> +       VM_WARN_ON_ONCE_FOLIO(folio_test_dirty(folio), folio);
> +       return false;
> +}
> +
>  extern const struct swap_ops swap_bdev_ops;
>
>  int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 71ef9e2efb3a..5d915951639e 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2513,6 +2513,15 @@ static int unuse_pte(struct vm_area_struct *vma, p=
md_t *pmd,
>         if (!folio_matches_swap_entry(folio, entry))
>                 return 0;
>
> +       /*
> +        * A large folio that a fault didn't map can't be mapped one PTE =
at a
> +        * time here, so drop it and swap in small folios instead.
> +        */
> +       if (unlikely(!swap_cache_folio_mappable(folio, 1))) {
> +               swap_cache_del_folio(folio);
> +               return 0;
> +       }
> +
>         swapcache =3D folio;
>         folio =3D ksm_might_need_to_copy(folio,
>                                        folio_file_page(folio, swp_offset(=
entry)), vma, addr);
>
> ---

Thanks for the fix!

Acked-by: Kairui Song <kasong@tencent.com>

