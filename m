Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FBA6606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YI6M5SvQ
Received: by kanga.kvack.org (Postfix)
	id 89EDF6B0600; Thu, 12 Nov 2026 17:15:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872CA6B0601; Thu, 12 Nov 2026 17:15:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770786B0602; Thu, 12 Nov 2026 17:15:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 469E76B0600
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:15:27 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 47C0081D16
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:15:26 +0000 (UTC)
X-FDA: 85427874252.17.888DE37
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4BA58100003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:15:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=YI6M5SvQ;
	spf=pass (imf05.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794521724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x4QNJEvzAlMIXBGcKmxpv9rSZn0KBUFpxlms+bXqEbk=;
	b=kNA+WSw9ryrRCetT4a/1+odnCW8I5lnc6qfOdcuBWm0CWov/QBbwgH7VvKx261acjIpXEC
	2AfcxKIhUHhbr157V7EqtxYtl77eS77s7TxHaBEHk8mJDHwHQuvTp3g3K7ZpCXIaoaPrAg
	NWVBj6MsbSaLn7kbk71jlwuec9a9nDc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794521724;
	b=GwfM4er2masXVYeN7LE5fA/wun54SugG1WhE/eY7MWaYsUZ24PpLnBxElhQPavnFPbBpz1
	vbYyO7jOqzmA9FfVwf9Zut7IjrmavVulBdKfMvpucbtRBhUb/ksanyZ5mBKJtfjqbFMPMV
	+7IHUe0UGAGjfk8wCRN+y9nFgDmXY7w=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=YI6M5SvQ;
	spf=pass (imf05.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b791a4b732so1596a12.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:15:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794521723; cv=none;
        d=google.com; s=arc-20260327;
        b=jn5z8UbVbaITCa0CZ9lksk899h6BeQwnywZX1cnURaNWnzPzC80gxKb0BhrEfMe6HW
         /u9ttgHlOyeM38VjL9MgajHtYHm5PMWnA2DjmBlA7bsgLEkrh7PpIXk4zmSTzHkiozVl
         DP/xQqHsdvGy2Jl0Rm5GMGckrTzEDPXFemih6LuDOs4DmGGOvbFkpPvieus9zGkXQN1/
         bqMvWUkzcps61Rcax/R7h3+qlpEacv/8XSv0WZOAQwXugG067jkkfvTMrl18AI6UM/f4
         2kPZ5ld/ReCti6QEB6RdWSeYyWZOFJpfaen7HK3/LxGkUf/pt96IJb+Yrps2F0hZR5SJ
         MkLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x4QNJEvzAlMIXBGcKmxpv9rSZn0KBUFpxlms+bXqEbk=;
        fh=+Fo/6s2SShDsG9zAQ/JewX0hSeoixmMYrO2T/rJo2Lo=;
        b=RUHzzQFTEbVdRbn752vSVVBrKzMO95W9s7ZHcqVcex1evwSA2Yh0WtXHrE2fs9gqUr
         oFVN1JKCVsifUAbQ3be1vo5tVY90XDkKTQuwpKGdKkI+DjAHg4ou7DQBpq2ZDUqw5TZh
         e2S3bVz+2QMi4sM3gtspj/6GcNphilSLNH630twb7s1uR5JL19VDwh9bGzfxlOtUFPox
         +wUjxI15t/zqoGCXGgSUjv7uAtvQgfSybm2YKZog8uUvReAeH2D+S8Lza9ajhki0Le1J
         JC04vqCi+5uZaztc+yiMJwrSHQtb/hPA2DRtLZiPJXWADaQ0Pael/qvdrut0ak1v/ER0
         1XdQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794521723; x=1795126523; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x4QNJEvzAlMIXBGcKmxpv9rSZn0KBUFpxlms+bXqEbk=;
        b=YI6M5SvQKP0NbOiof2poe12e0Kie4AFLdJdFGat2AFaHQ4vhVtDD2srWGcHqJJQGQe
         5XicVljlPPE1IjL38RV8c72ibD/Yc5xO116TTi1fx4x5ueT4LEipw6r8/SNhSfidKu11
         BY3ccbqIVMuh8aOAqF7JtxKpn7AaA3rXkh1+zHQAnecJa3Fg7pxpkSn0gg7oUPl4x2Mc
         tJP47ZcjYK+pr1LhPV1nahJgNLLFl0YVhm8EcwasJXv8Bmy5mgFwiaS5eLSBQjgVR0dJ
         cPsgRqX5oUWu3NetCGALh1DWNNbc0L5u7dZ4TH2y4NbN/wLAsPm9KjOnccpRkNrysKuN
         sytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794521723; x=1795126523;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x4QNJEvzAlMIXBGcKmxpv9rSZn0KBUFpxlms+bXqEbk=;
        b=Wf93P05ElateKdn4WT35N8Afxh27ZWTjEOVbtnJn2+vXi72Wcvbt+lmUFn+ewlUZNL
         I7RiJ0rpLOBpYzxpte9yetfNmWirAFxYFoi3QaA2u/AcKSLsjRZ4GCuL+769vVvPbNIt
         HbNMdioMUR+Plf3+VCj50nu5rroqfzwSYMd5nxcDc2t4bsvKxSwQ3nv09Pb5rXX6X1/8
         qdkctA5z95RQ3pymbpHVks3gri6AKwCq1+IGjNMCwuxguJhUk7y5CVO07YeP4ZcAE/aj
         2zoSC9FG83wEi0tLuC8JAZ5gOFv9eDZ+H29qrEtpKMnIYrR2vySJs5MK6+7O4zXzRWn6
         UWEg==
X-Forwarded-Encrypted: i=1; AL+hErGLB92fhGGKveQ4nM4l07VvZf9QmxXdHpMvqyIcNHT6ZfntZ4/aj5k1akKW99kITpBBkJUaVjhvNg==@kvack.org
X-Gm-Message-State: APuU4Z9PkRkGjphnCkp9uPnnYCfk7chEin9bTPXTJ6aJXwswTPAFhbJd
	EdtS8Kzu18kwnb8gOlOUOsdUmAItjeFia3t1k6U5e2p84vRPjDD1AA5axnFWPCcJoJihug2uHAG
	DAvVhXO5P5cVIK+2sw6Xl8hriamvn5ZylwH1yECH6
X-Gm-Gg: AYBFou2zD1Sso8RQe7zFd6Bgqh7IHGn5AEUFSTbXxwiO4nUdZrnjt1zsDYq8NpZ9Wu9
	c/mNguJkrjsUF+m/xfoQfqmWaK9qqY0WpgTvKF1IdmFWkmnqixjvxHydI0DVVwEVc3JMKWAAsDn
	JlUWFjhD3qNtjrmAsFh+lrr/XDK2Ddn/27pu0hGyWwLw/l9Tn4PccvoZGKT3xg62o2EqH/IPtvL
	d5C5wixrnsGJWZ4xMMDyvmNg7R1MpCqBjsmJ+bIvr9ipCdBEAzNbty1TbldX6YNUCFa3pIP60sP
	RkHhfegww3edVuQTK2zKg+zJiFs8hMR8P5oBeaTCjKaDxeMtAFPLucbZY93IqFs3tYEQS/y9M4J
	NYglDZDf2RvjKBezVwZjjRzD5ZKDsS3X+xh9B7liiHfU5eeuYLH1Xqxv7qgTO+BkfS3Q=
X-Received: by 2002:a05:6402:c886:20b0:6b5:70a4:c77c with SMTP id
 4fb4d7f45d1cf-6b7c82e0d9amr8478a12.11.1794521722130; Thu, 12 Nov 2026
 14:15:22 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261111-pte_table_clamped_end-v1-0-2dbe339c487a@kernel.org> <20261111-pte_table_clamped_end-v1-1-2dbe339c487a@kernel.org>
In-Reply-To: <20261111-pte_table_clamped_end-v1-1-2dbe339c487a@kernel.org>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Thu, 12 Nov 2026 14:15:10 -0800
X-Gm-Features: AclHuK9pHXXgukY8FhNBnEmP3YKYpuBgy2MxKk9i4nfs4cjz8eUM4vjeaML0zRk
Message-ID: <CA+EESO5O7BjFx_bmsogzWBZ0gsDD17na-cGjtc8stwATaHpXeA@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm/userfaultfd: fix PTE table overruns in UFFDIO_MOVE
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
	Barry Song <baohua@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Chris Mason <mason@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jks8en5enhf7sc9fcswxnem1kby8yfiz
X-Rspamd-Queue-Id: 4BA58100003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794521724-607923
X-HE-Meta: U2FsdGVkX18ezbk3jt2KyV+ZmgBfFCmDX8cXpzWrm3wBIzGRPf4Ys36KC85alVY2sLJAovwuL8ece9hMafUfnXFejIiF1omKQOr33SbCRoxnxFVhpy6+zLJ0lo3uQRvVwE9mBgZ9qNA3d4NctMp+1g8OdCezZvg4pxQsspdllnFP4kZQaL8DMEx2H6pcWBrN3bdVLa9J+EwkP5DW//qx85OPjvIDbhSUQrbhorWHp+4nyicC2crWI2/gw873hnrEAtC/s/W9ZhtL74Jc0nvXwkWcmxFvoemkCzYKRSwhG8ryAo26TbWgYiEyEK0+36oNx31aLt6LHBXuKCiYRDXLb5xRPAsOkxZWPpZxxmebvOBBxefcd1P7TrEuBxJBYT25NfVAd2CqiSEuBSxKXes7ogW9gteRlFgqiIxFXSqY55qXhtZQem8KqXVqQYjQjUQgwTfgs7s4VGnflbCp3Few/bo2HDr9iPMkqB3NeSloC/uJTYpbpeck2D9V06G0Bub8chYACJsHaNr/c7nAkbAmhImTKtQ7CE4KKgpxtLppD6YolkulvVBVDzygdbsJtcxsJIWsLmfXuD6CzAeTTcbe7stM3BoT8PZGwSt18J0dHIW7BOepasE0sWUjdG3Q/AYa7yW7z7Cz1awMmNXlKvvuYU6RsIp4An6LHIwsy4/YRnLniNXcwTP8g7twxAba+AL+kVDPKvaWpOp7P2cqwhBuokD0pdBZ50A7YSz3sSzDyghVomg7FD9rxCzXlfwG58zw94eAauQzAtQf4UUDI9p1j3KC4ZX5fFfYNYhmj2WDQvgFbFa1YpigS6N6gPpl02H2OzGlMN3qxuvcVib1Dtn+j8ahxe4Kj1IIa8sh+G18NW82dDdCFm7MgywtzFypy1RDLEl4Y2z7pphc51c/bimA9Rll1VNfhFUvw9i+tG9Iks8+1dT8f1ox3UOf/shzGMj/i/Gmfbhf13CM4gtou5X
 faiG82TU
 xxbpy4qrGb0xoIyFbmNLqnkbg4CvWDA2XlAqkS4qbMtuNFTB8JIpLStaY+qyMhzJISEQI+C4aWXFeFh7YjQbo5P/Z+7uQHyTovrcV4eR2BZhGQ4gdykiC6Nh9XW9qI6Ew392Hyq0WkWNZZFadnWo/UBagPhGaiJoK5egRlFhcQ3ec9gciU2iOE7xtGaUTWdntI6ddXz31Fvvc07Jdko9GzkIsiuWXM9G85k1gIAfu946IEP0t6glg9PpE/TCpI9KO9ufEqNGjYMnt1bzQ4HGr3z9pwJbVhuppQimlhF9FUjEq3Yb14Nhs1VuEHB7vWRSNluSnMMXX4f3OySc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 2:00=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> With a folded PMD, pmd_addr_end() simply returns the supplied end.
> move_present_ptes() can therefore walk past the source or destination
> PTE table during UFFDIO_MOVE.
>
> pmd_addr_end() is only intended for page table traversal, in patterns
> like "next =3D pmd_addr_end(addr, end);". With folded PMDs, a higher leve=
l
> has already clamped the range to the PTE table.
>
> Folded PMDs are uncommon, but can occur even on arm64, for example
> with 64K pages and a 42-bit virtual address space.
>
> Extract the calculation from folio_pte_range() into
> pte_table_clamped_end() and use it to clamp both ranges. This preserves
> the wraparound handling from commit f681d4580d5c ("mm: fix address
> wraparound when scanning large folio PTEs").
>
> Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for p=
resent pages in MOVE")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/pgtable.h | 24 ++++++++++++++++++++++++
>  mm/memory.c             |  7 +------
>  mm/userfaultfd.c        |  4 ++--
>  3 files changed, 27 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 780fe849ff8b7..66d369870a740 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -12,6 +12,7 @@
>  #ifdef CONFIG_MMU
>
>  #include <linux/mm_types.h>
> +#include <linux/minmax.h>
>  #include <linux/bug.h>
>  #include <linux/errno.h>
>  #include <asm-generic/pgtable_uffd.h>
> @@ -1518,6 +1519,29 @@ static inline void arch_swap_restore(swp_entry_t e=
ntry, struct folio *folio)
>  })
>  #endif
>
> +/**
> + * pte_table_clamped_end() - Limit a range to a single PTE table.
> + * @addr: Start address.
> + * @end: Exclusive end address.
> + *
> + * Only use pmd_addr_end() when traversing page tables, in a pattern lik=
e::
> + *
> + *     next =3D pmd_addr_end(addr, end);
> + *
> + * Higher levels already bound the range when PMDs are folded. Use this
> + * helper elsewhere to clamp the range regardless of PMD folding.
> + *
> + * Return: The exclusive end of the PTE table containing @addr, capped a=
t @end.
> + */
> +static inline unsigned long pte_table_clamped_end(unsigned long addr,
> +               unsigned long end)
> +{
> +       const unsigned long pmd_end =3D (addr & PMD_MASK) + PMD_SIZE;
> +
> +       /* Compare inclusive ends to avoid wraparounds. */
> +       return min(pmd_end - 1, end - 1) + 1;
> +}
> +
>  /*
>   * When walking page tables, we usually want to skip any p?d_none entrie=
s;
>   * and any p?d_bad entries - reporting the error before resetting to non=
e.
> diff --git a/mm/memory.c b/mm/memory.c
> index ec3d9d99ccee2..ee792a2c0ccea 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4959,13 +4959,8 @@ static void folio_pte_range(const struct folio *fo=
lio,
>  {
>         /* Stay within the page table and VMA boundaries. */
>         const unsigned long pmd_start =3D addr & PMD_MASK;
> -       const unsigned long pmd_end =3D pmd_start + PMD_SIZE;
>         const unsigned long lower =3D max(pmd_start, vma->vm_start);
> -       /*
> -        * We cannot use pmd_addr_end(), as it does not clamp reliably. T=
o
> -        * avoid wraparounds, compute using the inclusive end.
> -        */
> -       const unsigned long upper =3D min(pmd_end - 1, vma->vm_end - 1) +=
 1;
> +       const unsigned long upper =3D pte_table_clamped_end(addr, vma->vm=
_end);
>         const unsigned long offset =3D idx << PAGE_SHIFT;
>
>         /*
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 169f681f9849b..57650e6f040d1 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1266,8 +1266,8 @@ static long move_present_ptes(struct mm_struct *mm,
>         unsigned long src_start =3D src_addr;
>         unsigned long src_end;
>
> -       len =3D pmd_addr_end(dst_addr, dst_addr + len) - dst_addr;
> -       src_end =3D pmd_addr_end(src_addr, src_addr + len);
> +       len =3D pte_table_clamped_end(dst_addr, dst_addr + len) - dst_add=
r;
> +       src_end =3D pte_table_clamped_end(src_addr, src_addr + len);
>         flush_cache_range(src_vma, src_addr, src_end);
>         double_pt_lock(dst_ptl, src_ptl);
>
Thanks David!
Reviewed-by: Lokesh Gidra <lokeshgidra@google.com>
>
> --
> 2.43.0
>

