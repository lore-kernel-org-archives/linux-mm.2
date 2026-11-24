Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2B2C606A335
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 03:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=DB52Qu5D
Received: by kanga.kvack.org (Postfix)
	id B46906B05E0; Mon, 23 Nov 2026 22:58:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1CC76B05E1; Mon, 23 Nov 2026 22:58:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0C106B05E2; Mon, 23 Nov 2026 22:58:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BA1B6B05E0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 22:58:26 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D327E8072D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:58:24 +0000 (UTC)
X-FDA: 85468655328.26.A3E85D6
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 30778180003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:58:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DB52Qu5D;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795492703;
	b=6BI/0MXGrbCyk3G5ngbmFuY3gNadAaSX9Ta+jMye5SBOJn9WN+ig36knapJ3UHQy+UhHyH
	+9XlG9Tv+MkF2ilMAOyDswOtjTAl+NU4aD4vDWfDrCbjXCwJZ0I7G4LbNrqCF3SmltpFuE
	TBF6kh1Fvc3veX3hmgQKOS0gqyJ+zoo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795492703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gv4uJJGyzmSUG7P381t7O1IG6z0LrgKIDZorRLIr+gM=;
	b=NN/8sVtJhowrDlmMJdpJY2o9nwGpgnx0CO+30+lQdCrOy14fCcr/mqsmsc9l+55CVboWRK
	QNr8Fm5YhCfQy8yKFuW/s/msDbQbaFNcY/Y9nxf95nYHc3ttR/oKcsFySh5FE6ikgeqHuP
	P8evE4tzzEDYtfQKY1X+CQ3MJMn5IGc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DB52Qu5D;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-67c0ffaae1dso4204766d50.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:58:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795492700; cv=none;
        d=google.com; s=arc-20260327;
        b=RNCzmYXK5BACwZMI1sSAISjZCp8Nmdr85bGGF/euiKsd80YIcomtaCLO4x7XqrfoWi
         5Anr3Qp3HV8wo3vp7xyzgFAraFChDB7wCVj0Cea+qHRapIf4khaS5CgG+u2pxKMAoTAm
         2EYyujtze0SvrQonYpxZwISX92vjBSb7bMQTLsUgEyMOG6xgMJNcOfglgKCqrgZGCThW
         KNXh14o+59UAUrfNYBnm4vEFDsGnJGGDK9F31wBGhel3j5F1UbFnnzGF/OQQ/0b34lPv
         dAAtRyga/0KGqbitjKVtvZck6PIsV7MPy5/x2JZl772Jm2nFlBUY31Gg3TH9VU7ooll3
         JYZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Gv4uJJGyzmSUG7P381t7O1IG6z0LrgKIDZorRLIr+gM=;
        fh=2JIuCu6ZB72FmcqsvzcSf22QdclULhVt2mV0g99Q7N8=;
        b=AK4KzRGhUS7F1XvdKu9Gc7IJjq4M+cy1kE/AgxaYhnzEcjji4wtSvYuLjcz0b69pFR
         MJkn3gQTfid/JnfGPMTIBBwoKEkk2R08cCT+A8wd8NR+Vr65XXn7ZsS5lQNeWP+cHHVn
         Ns5O/Rzvj7H6r0cLVETNqP97WVDIqqnUZ+SXy2nrfWfyk1y+9XzhauWjxhAKrEg51Qth
         OVBHLzx4Lmw/BW17juP4Qnror/L9jykP1l9AcjAnhJod0aizK9wFEbGtHJNXOah+PhGv
         DsPqyHGJ1xoM3W8VGZpxhM3wBPNMl4NBZ8JkveyuXs4+AuH59Q8QmQFUYo4s8kVsw6K0
         zinQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795492700; x=1796097500; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gv4uJJGyzmSUG7P381t7O1IG6z0LrgKIDZorRLIr+gM=;
        b=DB52Qu5Dd4eGCRDIebXqN1ZgDXabtDydc9MT+nqhfeoPDkCaStvHULv3B+tQnCjtsl
         9Y/sNM5HlZkffbb8LCopZDV9kSzd6j0uPEP3jT8n8os930x03eIBTjCcl7xDkk7+UayS
         vgokJtkx5fj7Hf8ZNmgFpvLlEPsxbBh9KKbTs4/qT9iRpmNF+KqMcyx6A2OazdCyUVGM
         J0kwk0Dbp9/SPxGxEhjhQhChua0e4ugZ54RK9XtDHwJLUzUkbWCQqMo14EDfNTomJfkO
         G7nGIy05CM3W9tfdOcfGQ6KCZdAiKEgUSBu2UAAuWOvbtcYk8EuLiwrzIz/UiwoV4swX
         64Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795492700; x=1796097500;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gv4uJJGyzmSUG7P381t7O1IG6z0LrgKIDZorRLIr+gM=;
        b=IYanPUNcOFTA7VM1VbwDP17DUDhfAapptsO/9UNNuEYOxLxr2mqE+d4DY/stcoDxXn
         TWvSc1anQ6hy+TGenG54TFDMtFY8AgReEqwOKig7Y/swQAipOkX8l3S0HpY612RHp+LJ
         0TVW4bs3/wanmo/xUfXYUZpXl2JGb8v+p7SnlGS5EYcQfh4qxIplqvKnnpEXZfLhgv9T
         He5+vWan9MPD95avxix5Y48g717FL3rrLvBG/pN+s3DgwR1JoeVlyBGi6kuHkkYVem9+
         IX0OUtDk8yXuVEmu92e8f1niPOqUDkOu/xjEvperi1+bUBn1haGpldaGrYQQFK9NqEVo
         3IoQ==
X-Forwarded-Encrypted: i=1; AL+hErHWqRvIVmTBd3GUM2EDJHfDP+/A97Ju9Va6NxG0lDoD+tdOq1lbCW3ZUD9sHgVRPbayMYopDqQR/w==@kvack.org
X-Gm-Message-State: APuU4Z8sMMJGY/mMVSwS4pIzDkthRTaxaNeVjZONpvBwcwFUHkqyODWL
	rVO+JIL5hOCZFmPON49I2DMsOuI6LZFRwIs407grqOrI6M/MOWLwiTqVIFJmzz3P6s2q2cF0rTW
	4ddCfSSRLrnLUmKg6v6ftlzRGVuQqTWEaG5jui5s5DQ==
X-Gm-Gg: AZFdTZfjI1KoMSBqNrIpHLrqa7QM81QlM3+aOg+uNYqKPrClZ/9cHM/CcLhMAVrRbkx
	7i7ckxXfJynmGxaO9JajmszuXjzWJ/whAT2faDgig/V7QjBO1QuKOFGjT4NSHRdPGUrWD3dRCF7
	Hz6pslt+IiRfnCWWcguUGUHiXGquPuTaay/eM572X9vII8HhGlr9Bs8wXYjHEqtbxiskG7wGeZH
	1HYEUYv92Xhp+zSvT44N1nDc3vW0oFkmlii90gPJ4rHqhQZef+BRIxLwhYuExdinFB+Ar2ACI15
	WezKjmSGM6rHcGAcLGGOHdZfLiZxLP4noHM9TbJJ7ow6KU1G9nHEBisjFsC/7AMylPMSG81KMCI
	5FibO8G61hrp0WBlnakpdxGMRzin3rP3qx7NX
X-Received: by 2002:a05:690e:440d:b0:67c:1c81:fe59 with SMTP id
 956f58d0204a3-67df44077c4mr3119996d50.12.1795492699638; Mon, 23 Nov 2026
 19:58:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <202611230851.6AN8pFDD065900@mse-fl1.zte.com.cn>
In-Reply-To: <202611230851.6AN8pFDD065900@mse-fl1.zte.com.cn>
From: Muchun Song <songmuchun@bytedance.com>
Date: Tue, 24 Nov 2026 11:57:43 +0800
X-Gm-Features: Aa3M54osbbQsBQ30OQPILu59VKnjdwijA1lNndox2VeAUO0QbDMk_0iqr7KJXdU
Message-ID: <CAMZfGtWxmbASYdVBVhLFRDmQGqCunuUS+OqxPVzQpCT9n8pqYQ@mail.gmail.com>
Subject: Re: [PATCH v2] riscv: mm: allocate split linear mapping page tables
 via the standard page table allocation APIs
To: li.hanting@zte.com.cn
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, linux-riscv@lists.infradead.org, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 30778180003
X-Stat-Signature: r3eby15ynjsn7j4unqhybzxqa1kbr7gi
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795492701-567305
X-HE-Meta: U2FsdGVkX1+fpbzi6IQytT+lBnQZK6YkTYRLi3gaSoeyRUeNyvn1SPlGkDVY/z6zorrXbUFzNkyvJLIrDpp/kTXkfiU0m0xtY5dmzvXkHBrllf03SM+Nrn87NsDc9jecbD8N5n3c38DqjMSfdfisxeo7SgXEQG0DwZTRFu4Ve8ouM+ZNT9nKp23AoxudS7blkNQOnnA5jqSWLs+NqUJA5WsZeKXgvLTQmIWVUnWvOQZJu8YQQWGuG4LEnt+Lw91pCdH8NtH52o97reRVimpcMuAduhZNmiY93Mzex25Zt6j1RbgC922Sn95EUJ8dCYYygkdTYUEosRA3Bv1TMPrebZWj9NKNykXWdGzA4Qte0q7yU7R1J3cZ/fAuJVIC0jkkF/gHMT+GW1GIStXDwX5im8mlR4drvnX6AAUVSCl41g52zlhBASIgozyP7+haSABHtodaPViqfi1oEsG0wkdBpxPD5mpA5dlDp3uceNCnKb1DzWA36FH7n20IlihxzCkXaNC39FxrrmlbFW4tHy98LpKXzNnjvnMrob/kz2ncYdL+ZJh86jgaj7yjDtDOGXkHN4rDGNPMvWzXcfZrCWdX4I9X5aFNyeaOl1t2FUIE8RmRF+3jGxhQCThNNIEZ1v7FuPlZVhJOjFn0QlPJLhkXLOthrOxwrT/MFrQc4PYFMKbcVQc50N11JJihQZw9Z6G6nLD9HG6mlUywfLolbJ1lalYSqsui0rcN4tnSzy8FtO3fzMEzVxH8lE4zYd9lCsWhW9MgZUQsfmQ+40EZnaZE20W6q90RIp9ITPmQJ8aJzolX6nKvcEaA6gsjGzNsrbBrb3aEa3XQpqga5aPDJu3+JNuQbBQ9hdqvgrzNQRB6/+sK1PscY9mwkYV4VCjR9jKbLlFbWvHqvg82bfu695V0LkOZ2ywbNVEOjXhVZY7LunsdIPY0zfyLSdUYYvddM0XDkmNsP7zJ++iUiBqkyHa
 oc6g0T88
 Y7rK3cxU73DR/Oqb5gBy+yYJn0Updz3bxVjV8MKfkKnzKy61AtkFGBYWYcqMlUqnQUj+zrOTLKva/15rWDQshH/zgxqT+I3vU72m1OHHzcAhVFn8Tq1sq1CEHScZVUxM0n7LeueWKngyBVXgzP9JqXNQrfSNX6yDwlxMji57RpeUDg2jRpapbDV8su7160p48Ame2oIY0WvC4n/evnDUsndfrek+SX8WEI5N8hpqX9QNEMwUMk+zfKf0uisxpAbRa7fJHp5hd5LoV0lbNsDUS+pLP47O5u6d4nRNT2+WSU7R5cqryLOsflVSldNja/MXgCCQKArlkW1rdcKFcLG53M8lx2mXVQMpd9/q7R7gH5CBR6PBpuNBbbGyzHDN8G9e7HLXPnM+KshYgZ4XlyZGzTTn22leUHNCPW4ays7lcqPruloLMf7QHX9knuzeMHTOBMO1FU4Xe+KKS78gQPlYYVrvss34vLdq/p0Uyn0r1s1H6+yavtVKs6Vdg0RglSp6BnGc8eud+KV+/qbrO5/pNy1/l+UrI5N6vHUY80t6bZBsC9RBfAQjfUTHFnx+emKPBoOalMMHrDk9zmBQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 4:51=E2=80=AFPM <li.hanting@zte.com.cn> wrote:
>
> Hi,

This is the commit message body, which should be a bit more formal.
You can place expressions like these after the three underscores.

The subject is rather long.  How about:

riscv: mm: Fix split linear map page table allocation

>
> Commit 9e4a3ec3411b ("x86/mm/pat: Allocate split page tables as kernel
> page tables") recently fixed a latent inconsistency in the x86 CPA code
> (assigned CVE-2026-97525): __split_large_page() allocated the new PTE
> page with a bare pagetable_alloc(), bypassing pte_alloc_one_kernel(), so
> the page table constructor never ran and the resulting page was neither
> flagged PG_table, nor accounted in NR_PAGETABLE, nor marked as a kernel
> page table.
>
> RISC-V open-codes the same pattern when splitting the linear mapping on
> behalf of set_memory_*(): __split_linear_mapping_{pmd,pud,p4d}()
> allocate the new page table pages with bare alloc_page(GFP_KERNEL) -
> three call sites in arch/riscv/mm/pageattr.c, introduced by
> commit 311cd2f6e253 ("riscv: Fix set_memory_XX() and set_direct_map_XX()
> by splitting huge linear mappings").
>
> As on pre-fix x86, the resulting pages live in init_mm without the
> PG_table flag, without NR_PAGETABLE accounting and without the kernel
> ptdesc marking. Under CONFIG_MEMORY_HOTPLUG, hot-removing memory tears
> down the linear mapping of the removed range via arch_remove_memory()
> -> remove_linear_mapping() -> free_p*d_table(), which releases these
> page tables through pagetable_dtor() even though the constructor never
> ran, underflowing NR_PAGETABLE on current mainline. Muchun Song's
> series "mm: Fix page-table teardown during memory hot-remove" [2]
> fixes the freeing side by skipping the destructor for pages without
> the PG_table flag, but the root cause remains: the allocation side
> still bypasses the page-table constructors, so these tables are
> unflagged and unaccounted for their entire lifetime.
>
> Align the three sites with the standard allocation paths:
>
>  - the PTE level switches to pte_alloc_one_kernel(&init_mm), exactly
>    like the x86 fix;
>
>  - the PMD and PUD levels switch to the generic pmd_alloc_one() and
>    pud_alloc_one(), which already handle the init_mm case by selecting
>    GFP_PGTABLE_KERNEL, running the level constructors and marking the
>    ptdesc as a kernel page table.
>
> No functional change is intended; the observable difference is that
> split linear mapping page tables are now properly flagged and

This is slightly misleading because the accounting, PG_table state and
hot-remove destructor behavior are intentional functional changes.  I
think it would be more precise to say that no change to the resulting
linear mappings is intended.

> accounted, so /proc/vmstat:nr_page_table_pages no longer under-counts.
>
> Fixes: 311cd2f6e253 ("riscv: Fix set_memory_XX() and set_direct_map_XX() =
by splitting huge linear mappings")
> Signed-off-by: Hanting Li <li.hanting@zte.com.cn>
>
> ---
> Changes since v1 [1]:
>
> - Switch the PMD and PUD levels to the generic pmd_alloc_one() /
>   pud_alloc_one() instead of a local helper, as suggested by the
>   Sashiko automated review. The generic versions already handle
>   init_mm correctly, which also resolves the first open question of
>   v1.
>
> - Correct the severity discussion. v1 claimed these page tables are
>   never freed; that is wrong under CONFIG_MEMORY_HOTPLUG, where memory
>   hot-removal frees them through remove_linear_mapping() ->
>   free_p*d_table() -> pagetable_dtor(), so the ctor/dtor mismatch can
>   actually underflow NR_PAGETABLE. Also pointed out by the automated
>   review.
>
> - Add the Fixes: tag and move the discussion notes below the tear
>   line.
>
> [1] https://lore.kernel.org/r/202611091101.6A9B1Nf3015337@mse-db.zte.com.=
cn
> [2] https://lore.kernel.org/r/20261008073021.2512665-3-songmuchun@bytedan=
ce.com
>
> Hello,
>
> One discussion point from v1 remains open:
>
> Since RISC-V never collapses the split linear mapping back, one could
> argue for deferring this change until free-path work actually lands.
> My preference is to take it now: with CONFIG_MEMORY_HOTPLUG the free
> path already exists today, and taking this now removes a trap for any
> future work on the linear mapping.
>
> (Note: the generic CPA rework series "[PATCH RFC 00/18] arch, mm:
> create a generic set_memory/change_page_attr core" would eventually
> replace this code entirely; this patch is intended as a small fix in
> the meantime. The series author has said he is waiting for such fixes
> to settle before posting a non-RFC version.)
>
> Comments welcome.
>
>  arch/riscv/mm/pageattr.c | 41 +++++++++++++++++------------------
>  1 file changed, 20 insertions(+), 21 deletions(-)
>
> diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
> --- a/arch/riscv/mm/pageattr.c
> +++ b/arch/riscv/mm/pageattr.c
> @@ -3,9 +3,11 @@
>   * Copyright (C) 2019 SiFive
>   */
>
> +#include <linux/mm.h>
>  #include <linux/pagewalk.h>
>  #include <linux/pgtable.h>
>  #include <linux/vmalloc.h>
> +#include <asm/pgalloc.h>
>  #include <asm/tlbflush.h>
>  #include <asm/bitops.h>
>  #include <asm/set_memory.h>
> @@ -109,23 +111,22 @@ static int __split_linear_mapping_pmd(pud_t *pudp,
>                         continue;
>
>                 if (pmd_leaf(pmdp_get(pmdp))) {
> -                       struct page *pte_page;
>                         unsigned long pfn =3D _pmd_pfn(pmdp_get(pmdp));
>                         pgprot_t prot =3D __pgprot(pmd_val(pmdp_get(pmdp)=
) & ~_PAGE_PFN_MASK);
>                         pte_t *ptep_new;
>                         int i;
>
> -                       pte_page =3D alloc_page(GFP_KERNEL);
> -                       if (!pte_page)
> +                       ptep_new =3D pte_alloc_one_kernel(&init_mm);
> +                       if (!ptep_new)
>                                 return -ENOMEM;
>
> -                       ptep_new =3D (pte_t *)page_address(pte_page);
> -                       for (i =3D 0; i < PTRS_PER_PTE; ++i, ++ptep_new)
> -                               set_pte(ptep_new, pfn_pte(pfn + i, prot))=
;
> +                       for (i =3D 0; i < PTRS_PER_PTE; ++i)
> +                               set_pte(ptep_new + i, pfn_pte(pfn + i, pr=
ot));
>
>                         smp_wmb();
>
> -                       set_pmd(pmdp, pfn_pmd(page_to_pfn(pte_page), PAGE=
_TABLE));
> +                       set_pmd(pmdp, pfn_pmd(page_to_pfn(virt_to_page(pt=
ep_new)),
> +                                             PAGE_TABLE));

Now that the page-table pages are allocated through the standard
pgtable APIs, could the parent entries also be installed through the
corresponding populate helpers?  For example:

        pmd_populate_kernel(&init_mm, pmdp, ptep_new);

and similarly pud_populate() and p4d_populate() for the upper levels.
That would avoid open-coding the virtual-address-to-PFN conversion and
make it explicit that these are non-leaf entries pointing to lower-level
page tables.

Thanks,
Muchun

>                 }
>         } while (pmdp++, vaddr =3D next, vaddr !=3D end);
>
> @@ -149,24 +150,23 @@ static int __split_linear_mapping_pud(p4d_t *p4dp,
>                         continue;
>
>                 if (pud_leaf(pudp_get(pudp))) {
> -                       struct page *pmd_page;
>                         unsigned long pfn =3D _pud_pfn(pudp_get(pudp));
>                         pgprot_t prot =3D __pgprot(pud_val(pudp_get(pudp)=
) & ~_PAGE_PFN_MASK);
>                         pmd_t *pmdp_new;
>                         int i;
>
> -                       pmd_page =3D alloc_page(GFP_KERNEL);
> -                       if (!pmd_page)
> +                       pmdp_new =3D pmd_alloc_one(&init_mm, vaddr);
> +                       if (!pmdp_new)
>                                 return -ENOMEM;
>
> -                       pmdp_new =3D (pmd_t *)page_address(pmd_page);
> -                       for (i =3D 0; i < PTRS_PER_PMD; ++i, ++pmdp_new)
> -                               set_pmd(pmdp_new,
> +                       for (i =3D 0; i < PTRS_PER_PMD; ++i)
> +                               set_pmd(pmdp_new + i,
>                                         pfn_pmd(pfn + ((i * PMD_SIZE) >> =
PAGE_SHIFT), prot));
>
>                         smp_wmb();
>
> -                       set_pud(pudp, pfn_pud(page_to_pfn(pmd_page), PAGE=
_TABLE));
> +                       set_pud(pudp, pfn_pud(page_to_pfn(virt_to_page(pm=
dp_new)),
> +                                             PAGE_TABLE));
>                 }
>
>                 ret =3D __split_linear_mapping_pmd(pudp, vaddr, next);
> @@ -198,23 +198,21 @@ static int __split_linear_mapping_p4d(pgd_t *pgdp,
>                         continue;
>
>                 if (p4d_leaf(p4dp_get(p4dp))) {
> -                       struct page *pud_page;
>                         unsigned long pfn =3D _p4d_pfn(p4dp_get(p4dp));
>                         pgprot_t prot =3D __pgprot(p4d_val(p4dp_get(p4dp)=
) & ~_PAGE_PFN_MASK);
>                         pud_t *pudp_new;
>                         int i;
>
> -                       pud_page =3D alloc_page(GFP_KERNEL);
> -                       if (!pud_page)
> +                       pudp_new =3D pud_alloc_one(&init_mm, vaddr);
> +                       if (!pudp_new)
>                                 return -ENOMEM;
>
>                         /*
>                          * Fill the pud level with leaf puds that have th=
e same
>                          * protections as the leaf p4d.
>                          */
> -                       pudp_new =3D (pud_t *)page_address(pud_page);
> -                       for (i =3D 0; i < PTRS_PER_PUD; ++i, ++pudp_new)
> -                               set_pud(pudp_new,
> +                       for (i =3D 0; i < PTRS_PER_PUD; ++i)
> +                               set_pud(pudp_new + i,
>                                         pfn_pud(pfn + ((i * PUD_SIZE) >> =
PAGE_SHIFT), prot));
>
>                         /*
> @@ -224,7 +222,8 @@ static int __split_linear_mapping_p4d(pgd_t *pgdp,
>                          */
>                         smp_wmb();
>
> -                       set_p4d(p4dp, pfn_p4d(page_to_pfn(pud_page), PAGE=
_TABLE));
> +                       set_p4d(p4dp, pfn_p4d(page_to_pfn(virt_to_page(pu=
dp_new)),
> +                                             PAGE_TABLE));
>                 }
>
>                 ret =3D __split_linear_mapping_pud(p4dp, vaddr, next);

