Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDF67606D815
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=glbhRE9M
Received: by kanga.kvack.org (Postfix)
	id 003BE6B05B6; Thu,  5 Nov 2026 07:00:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1DBF6B05BA; Thu,  5 Nov 2026 07:00:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0CD86B05BB; Thu,  5 Nov 2026 07:00:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C271B6B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:00:53 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63E9EA0A03
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:00:53 +0000 (UTC)
X-FDA: 85400923986.07.39FC165
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 852082000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:00:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=glbhRE9M;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793880051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iHtHHKkWSJPfQWrFBs5xTFx96nXTptk6pC2f5beHRKY=;
	b=c4ycJVGxfG4GIbi4BYGfbyHYvc1JsE03Pg2CkKPVJIXptEwzdFgA6+vnzoSVbgPW7L9pPZ
	M2HU1dhPWaq3YgL3XGYQ7rZBNnLeQTqJgERvBtQhSdGI+9sl1jE6gON5G5989AzUFVf7OI
	igek5uYpFgnB+A4Rcj6wnA/4XJlHP2c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=glbhRE9M;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793880051;
	b=TZnF1QwqzMhlo8Kw9UfZoZ87+v7Bo59MI8pAvNrGCTtrjKcN3YpY0t+bfWcdYFkxXVJDzH
	n9l40omBIt57+/Th7Tiln1reQwgDVU+HCodjTci4lEvaHy6vUUS/GQd/xRSx8tHHY071Ny
	ThOlX2k4FvaRLghSEbTfS7jUvqVdYh4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7B804142E;
	Thu,  5 Nov 2026 12:00:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6389A1F000C1;
	Thu,  5 Nov 2026 12:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793880050;
	bh=iHtHHKkWSJPfQWrFBs5xTFx96nXTptk6pC2f5beHRKY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=glbhRE9MUrcqClo0tmsn+pGHwQQ5bP2TNIV4adb2xDr4eGky/Bh5xBQie+A4zmBm5
	 qbFxwCLizZ51ZiVgQImrqt3z/7lk9DwPr+P7ZPylQ7iGGuiQwMdv6sYESrghii7ppv
	 sOw9CjZ6hfOONHZqYR+ZiEvuUc1PkjOdutrZQS9BaxvIqyBxAq9J8WcsxEaJY7AduN
	 N8IGRdnHU6dJa7CTh8PeqDA1qEsKdPINGL0Brv+XJVqFBrVzUsHxqZlTcjp0IZVseF
	 bCljvtWq1uh8Lm+fRvcaSJcFeaJXdTl4Cnc1IiarrO/PGaFzzWq9e4PvTdI2YNDZCM
	 pBQxcZ3SeT6Pw==
Message-ID: <dec26f4a-138a-4cd7-b000-4bda7c61af82@kernel.org>
Date: Thu, 5 Nov 2026 13:00:44 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/memory: use pmdp_get_lockless() for the pmd read in
 do_fault_around()
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Geert Uytterhoeven <geert@linux-m68k.org>, Sam Creasey <sammy@sammy.net>
Cc: Hui Zhu <zhuhui@kylinos.cn>, stable+noautosel@kernel.org,
 linux-m68k@lists.linux-m68k.org
References: <20261104091050.117076-1-hui.zhu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261104091050.117076-1-hui.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tjgekyc8764f89nikch849d5z9kf35k1
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 852082000C
X-HE-Tag: 1793880051-77598
X-HE-Meta: U2FsdGVkX1/Bdg7/xpoqbn7Lj4tqj5ww/C3jPXsJcKR0yRF54Byylv0R+SqOtZ5njPgHAPYAwTzNLA3UkQm8akFgYDYMZGShQyJqXDkYDkqHxRET/3BT0q2eIA9idwkVQVjCe1FT1i8okiYnk+iRN0kyRGedtFIxooGaAgQitIanc+uewMtvpcht5wBbNognfM49wz+RuMPpkybGMNX9wPkdHFUHqrCAOaqnh58fKts0JcdpQeRrDfKJhi5dp0xKm1wRseSyLpv97yxOpKD1ZBfNNkz4p6xJSkDOoF/xBu3qH0wyw6RIoCbZ7Y3VsSWzaOif1udMAOjsZSs7t5jDJIvTCWN6nnmMxA0ZkYyvcklsG4gWU5aHIAYX6f8vhG7FlOnABzNBdI7M790NrDYbO9RwwvfLbZXPiJDLAwN+g3tmlQRvUAI046vixxFi1VpZyJpZ4WZeBzj+5Hx9KyI0f+nzHgAoT8+w8EhXYAAC/LC7HsclitnrDKeqVI5L6Ax3tLSn9UojXay9ZNQD69KilJzUOsb05LorXTIZP9hPQdCiw65uMDCbgdUrbapGJKfs4TBdI4Fqj5quCwmUwYH6BYrQ2nUtcl7B/F82W/WQaZhx55j+de+NHvqGoB6vmycWHD4cQj9JaMsx8TEwobvcFwatLPyXT/wNqiyhNKgK4jtvx4tVgWH11CK97BuU4VfXhftrQsziLwnMcIJES/i/toLU5JQk8YpAKgTKpibVVDx24Hv+difWsb6gbWI/HzUBSeAKWEP5fYrdvhGKUNCm0/Mf1z699QVpPvIHSPNwgR+P370/tsJIY4IU3FoIhsjzeMyDxS+C8BcxaVcsvCM7IsC/mYlMo/Z3mLbF4KdNYI/yPLwJLgthb12qZRNtD8ErqtbMcosCZRjAW5xIRDFanp/N3zaf1CPQwCSWombHO0u8j9wulpPlB/hIPU1HPQKJEiGQT8qkskQ1VKbumzF
 ka0nTW+g
 rauWPHfJ4ES0tTt4UzvZC4DbsPRWKu6avR0RewxkxpwV+iFOXUNdvOS69K65aCl2y6Rf4ZswwpAPQ+6/ihIlumJ1euls5TSYyu+Mwr8m88Yd3g1TaTg786nPhpCRABBrvcYRcTFXp3Ls3uoPDOyy9RKG/lpWbvSoNFjwCtOxj95XOo7qrN/urJzF1bKoZcAg6Np9Mz/6fA8Rf7EHQjd3EZ7JcsgZv2mj2gDck0Ye7xL/4AQCvQ7bCAgNYFlEmUAtzPchoNpvh7FDDTvZpgOWKgJQwT6ijg0maBApXTmvZUZ4UYGrbChY5hh/k8+A14bpM1ve9CpSwG9N4MSOgDVaAhSFbvUlgXdV/f8eCZw4tsx3eg7Ldqmp14EvxhuR+TOYTAyBqVqQlNqJm54yqdKcqpRHdj1kyZ7Y356TyYXMxa/XEze8kdTwmtbOB+rJ+nn+Xb+JZ5+EPgXufbPNP4hY0L4YZpFgU791Fby+slvQpI9MXuH8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 10:10, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> KCSAN reports a data-race in do_read_fault / pmd_install; the same code
> is in mainline:
> 
>   write (marked) to 0xffff8d52a75fb810 of 8 bytes by task 27487 on cpu 5:
>    native_set_pmd arch/x86/include/asm/pgtable_64.h:83 [inline]
>    pmd_populate arch/x86/include/asm/pgalloc.h:84 [inline]
>    pmd_install+0xe0/0x120 mm/memory.c:444
>    finish_fault+0x5bc/0xb00 mm/memory.c:5204
>    do_cow_fault mm/memory.c:5432 [inline]
>    do_fault+0x5d0/0x6e0 mm/memory.c:5526
>    handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
>    __mm_populate+0x144/0x270 mm/gup.c:2207
>    __do_sys_mlockall+0x2cd/0x380 mm/mlock.c:764
> 
>   read to 0xffff8d52a75fb810 of 8 bytes by task 27527 on cpu 9:
>    do_fault_around mm/memory.c:5341 [inline]
>    do_read_fault+0x162/0x670 mm/memory.c:5381
>    do_fault+0x31a/0x6e0 mm/memory.c:5524
>    handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
>    faultin_page_range+0x227/0x530 mm/gup.c:2156
>    __x64_sys_madvise+0x67/0x80 mm/madvise.c:1479
> 
>   value changed: 0x0000000000000000 -> 0x000000001386c067
> 
> Both paths only hold mmap_lock for read, so do_fault_around() tests
> vmf->pmd while pmd_install() populates it under the pmd lock.  The race is
> benign: a stale pmd_none() only wastes the prealloc_pte, which do_fault()
> frees again, and a pmd seen as populated only makes ->map_pages() find no
> PTE and do_read_fault() fall back to __do_fault().
> 
> The load still has to be lockless-safe.  The store side already is: on
> i386-PAE, pmd_install() publishes both halves of the pmd with a single
> cmpxchg8b.  The load side is not.  pmdp_get() is a plain READ_ONCE() over
> a pmd_t that is wider than a word there, so it becomes two 32-bit loads
> and can return the low half of one pmd together with the high half of
> another.  Use pmdp_get_lockless(), the accessor for pmd reads that do not
> hold the pmd lock: it re-reads until both halves come from the same pmd.
> It is also what __pte_offset_map() already uses on this very pmd a few
> instructions later.
> 
> Only X86_32+X86_PAE and SH+X2TLB compile the retry loop, these being the
> GUP_GET_PXX_LOW_HIGH selectors that have more than two page table levels.
> mips32 with 64-bit physical addresses selects GUP_GET_PXX_LOW_HIGH too,
> but is 2-level and so falls back to pmdp_get().  On every other
> configuration, x86-64 included, pmdp_get_lockless() is pmdp_get(): the
> pmd is loaded in one go, the READ_ONCE() silences the report the same
> way, and there is no functional change.
> 
> Fixes: 7267ec008b5c ("mm: postpone page table allocation until we have page to map")
> Cc: stable+noautosel@kernel.org # KCSAN annotation only, no functional change
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> Acked-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
> Changelog:
> v4:
> Commit message only, the diff is identical to v3.  Spell out the affected
> arches and add the lore links for v1-v3 (Lorenzo Stoakes).  Reword the
> cmpxchg8b sentence: the store is already atomic, it is the load that tears.
> Add the Fixes: tag (David Hildenbrand).
> v3:
> https://lore.kernel.org/all/20261103014749.96764-1-hui.zhu@linux.dev/
> Shorten the comment to one line (David Hildenbrand).
> v2:
> https://lore.kernel.org/all/20261102093120.92654-1-hui.zhu@linux.dev/
> Use pmdp_get_lockless() instead of pmdp_get() (David Hildenbrand).
> v1:
> https://lore.kernel.org/all/20261102031308.66177-1-hui.zhu@linux.dev/
> 
>  mm/memory.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 0fb676dd2bd63..f25c2ce0ef153 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6017,7 +6017,8 @@ static vm_fault_t do_fault_around(struct vm_fault *vmf)
>  	to_pte = min3(from_pte + nr_pages, (pgoff_t)PTRS_PER_PTE,
>  		      pte_off + vma_pages(vmf->vma) - vma_off) - 1;
>  
> -	if (pmd_none(*vmf->pmd)) {
> +	/* pmd_install() rechecks pmd_none() under the pmd lock. */
> +	if (pmd_none(pmdp_get_lockless(vmf->pmd))) {
>  		vmf->prealloc_pte = pte_alloc_one(vmf->vma->vm_mm);
>  		if (!vmf->prealloc_pte)
>  			return VM_FAULT_OOM;

Fun, this breaks some odd m68k configs because they do some legacy weird stuff with pmd_none().

I'll throw in the following cleanup. CCing m68k maintainers: I would drag
this along with this fix here unless you disagree.

From e3c739933a04743e3923f6f39a603e93f2700304 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 5 Nov 2026 12:49:38 +0100
Subject: [PATCH] m68k/mm: simplify
 pmd_none()/pmd_val()/pmd_present()/pmd_bad()

pmd_t on m68k used to contain 16 words. Commit ef22d8abd876 ("m68k:
mm: Restructure Motorola MMU page-table layout") reduced Motorola PMDs
to one word; Sun3 and ColdFire use word-sized folded PMDs.

Use direct member access in pmd_val() and replace the Sun3 and ColdFire
pointer-taking predicate wrappers with inline functions taking values.

This allows us to write something like:

  if (pmd_none(pmdp_get(pmdp)))

While at it remove unused pmd_present2() and commented-out pmd_bad()
on sun3.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/m68k/include/asm/mcf_pgtable.h  | 20 +++++++++++++++-----
 arch/m68k/include/asm/page.h         |  2 +-
 arch/m68k/include/asm/sun3_pgtable.h | 23 +++++++++++++++--------
 3 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/arch/m68k/include/asm/mcf_pgtable.h b/arch/m68k/include/asm/mcf_pgtable.h
index f45a882238dbb..4efa8e3e1e98a 100644
--- a/arch/m68k/include/asm/mcf_pgtable.h
+++ b/arch/m68k/include/asm/mcf_pgtable.h
@@ -130,11 +130,21 @@ static inline void pte_clear(struct mm_struct *mm, unsigned long addr,
 
 #define pte_page(pte)	virt_to_page(__pte_page(pte))
 
-static inline int pmd_none2(pmd_t *pmd) { return !pmd_val(*pmd); }
-#define pmd_none(pmd) pmd_none2(&(pmd))
-static inline int pmd_bad2(pmd_t *pmd) { return 0; }
-#define pmd_bad(pmd) pmd_bad2(&(pmd))
-#define pmd_present(pmd) (!pmd_none2(&(pmd)))
+static inline int pmd_none(pmd_t pmd)
+{
+	return !pmd_val(pmd);
+}
+
+static inline int pmd_bad(pmd_t pmd)
+{
+	return 0;
+}
+
+static inline int pmd_present(pmd_t pmd)
+{
+	return !pmd_none(pmd);
+}
+
 static inline void pmd_clear(pmd_t *pmdp) { pmd_val(*pmdp) = 0; }
 
 
diff --git a/arch/m68k/include/asm/page.h b/arch/m68k/include/asm/page.h
index d30f8b2f15927..09a2c020ec992 100644
--- a/arch/m68k/include/asm/page.h
+++ b/arch/m68k/include/asm/page.h
@@ -17,7 +17,7 @@
  */
 #if !defined(CONFIG_MMU) || CONFIG_PGTABLE_LEVELS == 3
 typedef struct { unsigned long pmd; } pmd_t;
-#define pmd_val(x)	((&x)->pmd)
+#define pmd_val(x)	((x).pmd)
 #define __pmd(x)	((pmd_t) { (x) } )
 #endif
 
diff --git a/arch/m68k/include/asm/sun3_pgtable.h b/arch/m68k/include/asm/sun3_pgtable.h
index 704442a391fd7..5867d24032655 100644
--- a/arch/m68k/include/asm/sun3_pgtable.h
+++ b/arch/m68k/include/asm/sun3_pgtable.h
@@ -109,14 +109,21 @@ static inline void pte_clear (struct mm_struct *mm, unsigned long addr, pte_t *p
 #define pmd_page(pmd)		virt_to_page((void *)pmd_page_vaddr(pmd))
 
 
-static inline int pmd_none2 (pmd_t *pmd) { return !pmd_val (*pmd); }
-#define pmd_none(pmd) pmd_none2(&(pmd))
-//static inline int pmd_bad (pmd_t pmd) { return (pmd_val (pmd) & SUN3_PMD_MASK) != SUN3_PMD_MAGIC; }
-static inline int pmd_bad2 (pmd_t *pmd) { return 0; }
-#define pmd_bad(pmd) pmd_bad2(&(pmd))
-static inline int pmd_present2 (pmd_t *pmd) { return pmd_val (*pmd) & SUN3_PMD_VALID; }
-/* #define pmd_present(pmd) pmd_present2(&(pmd)) */
-#define pmd_present(pmd) (!pmd_none2(&(pmd)))
+static inline int pmd_none(pmd_t pmd)
+{
+	return !pmd_val(pmd);
+}
+
+static inline int pmd_bad(pmd_t pmd)
+{
+	return 0;
+}
+
+static inline int pmd_present(pmd_t pmd)
+{
+	return !pmd_none(pmd);
+}
+
 static inline void pmd_clear (pmd_t *pmdp) { pmd_val (*pmdp) = 0; }
 
 /*
-- 
2.43.0


-- 
Cheers,

David

