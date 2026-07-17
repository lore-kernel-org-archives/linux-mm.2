Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30028C4450F
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 03:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58E16B00A2; Thu, 16 Jul 2026 23:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30B26B00A3; Thu, 16 Jul 2026 23:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4A876B00A4; Thu, 16 Jul 2026 23:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86A526B00A2
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 23:46:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F3D5D1403E7
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 03:46:56 +0000 (UTC)
X-FDA: 84996882432.20.0A0E060
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1FCCC120005
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 03:46:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aFLuoHCu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of devnexen@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784260015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+qfsfSM7+v1WClc9BxhjMt2YlMxMtKRK2E8WppuykZI=;
	b=4EamYrBWY2f8Ua01HYorzR5WA3wTDWuniNkfVeBHN3VUmQfvKtlkScQaDv6Me1MsOE39J4
	xSwGfzhDjjAsviJFaMG/KF+FQmvovLkzxGm4/Sf81toNerKaQclf4VZSIo+ZBVF62yIsml
	D8rfKE+3HMq2eXnd3aF0Zh3zZp4T55g=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aFLuoHCu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of devnexen@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784260015;
	b=BJx7V9kOkkqKlJS7RHlX5tdzZJ8ANuJvkbHXsnE9xAmA9DtqPG7tBKyyIZqWoCE8XdIBsk
	C4+JhSvEwvZuyYI67aXPz6oem9CXpS05KSHJKWmH1xWKbuDNvWA4e/XdrPXWO3O52bynVK
	M0T1aANLbzdLZy1wfLap+kBWyEQrZx8=
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7eb42a2f5feso2945864a34.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:46:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784260014; cv=none;
        d=google.com; s=arc-20260327;
        b=jv3UrZQDvlLc+WX+Da6kC5FpUALaQ6Rt9my7bg8P8R/XAnrpEWTud7T7yLNiuFv4wv
         7EFfAMxyxLUFg5YTIryHwMexhPf6z1DY9WSXHUa5Sky3b5H2ZQKtloj2pqU5q4wYYjCf
         GYckEsj8qYhW+aUBnutpP4M5/MIAt46oDtIeS5CsQ7iy91gydCjrw9o6LB5ccIiRQlPW
         yAHG+/ILIZEGZKSkwSZXln1L4V8WPnWbNgA+bBK4v0smQSR22sUL3/u8tiNcebVT7cWl
         qCrBonk3EFFWFajBbgbpjiax3BzVrB5GBL+W1Gss0g1ynQZNQTXGxRlNR4Ujw9LwM9lE
         U2QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+qfsfSM7+v1WClc9BxhjMt2YlMxMtKRK2E8WppuykZI=;
        fh=NmEIUg9RuCDg2JHf6GDbv/tDtnqNpnylxGIjaUtFEPk=;
        b=hVJeZmrNOCJGauy3Jk1SX0RMATmdU+Jx58L9gOrRkjiAb+CBz+D6dwU6UXIahEOPao
         OdkrCE08shidTOB+ama9Jp4E5zh3//frD1d0V4zdztLijCrVH3twXGF9QEkXdgtUOOgI
         RgN074oXlcYQ2LuOGwkCX1xVw+/lLQjvfSoqKoBveUnL73k2tVUXpKsmY/3fxlN34p2B
         bd8aFqsglxOTuHEByXlmHCoO+JS+akkfumyaYhWRkh5ghItrU4MTbj7o6I4pO/voD4xs
         p+gMROoq70YeaKfl/B3iLxSoShwKKj2T/va5gxtrFTnCWS8BKm8nQ1jwTyVbW1iuRBpa
         ++7g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784260014; x=1784864814; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+qfsfSM7+v1WClc9BxhjMt2YlMxMtKRK2E8WppuykZI=;
        b=aFLuoHCuKFILL/3t3ntWVgROTYj9YfWCio+rafBb+NmYs1uATDBvAYGPrORI4AfUEU
         hsbtEsnd4m/oVDJYtdHfvG1vfYFv0J/3Eo8ua6nS+fjrIuqYSExzjwi23tx6hQEMvoBa
         fMLSIaYX8w9Z4x4TO2JNAcwlc+poav6FPAz4G754r6YRuHkg9H/qNlPPvw7qazyv42p8
         veUjSKtA6reT/7xJRfTbVc6EZxiVxmg86yI5rawFyWQi41sEhmcnNASSSMDWzInjca5D
         dXu3cac9hf+Hby1cV9x/GPB6G4PzkbnjRPJQTgOP+yMzOkM1+HMZT7QzkAPkAON+ZNeB
         2wzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784260014; x=1784864814;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+qfsfSM7+v1WClc9BxhjMt2YlMxMtKRK2E8WppuykZI=;
        b=iUfKEZbKX62KOvwiD35MZDMP6Gh66RjvRtcSr1NrXjJ5bbjX5Kmn7q6+pbDweO83yP
         ZcbxhqB1a3SYq0dep6BLdkPhrmbjuTtookgHIYIihhuxtm6asscRf3We942vBGYj9Qgs
         gZ5UXTauj4po9mgalfMIJVt2uz869reV8zXFtI/5KQZ0nLql8GVVA84ApBx8JuixlidK
         JtYQztSurVXSzdIm6+Iyv0VMLOPZluRtTt89Dk0/Ac0IrrtUiPVwwUR9QdDKQYsDM3F1
         b717qJf1PpTv578E7n7seQwFvpniB3mChuPLtJKXKZwLR95xubepyrbjaet0QySfgMkl
         R1lQ==
X-Forwarded-Encrypted: i=1; AHgh+RqH1Lim8iPXNbvBFS/8c78HQC7hL8vjP8oCQk7EidfPwSibF5YkkMyVlzP7kuCBayQ7Ua9lnruI1w==@kvack.org
X-Gm-Message-State: AOJu0YyPlgMg4F7mEc1ypXsOwLiMWG+ROZ8C5IGjXButaOxUbzzYPtEj
	S7v+5A7Is5W1MJ/7oGRc2gTJ4roZRSE8rtPwtA0AP5VqhZi+QxwxkIpJcpytxhS9hToIARk9Ii8
	VUKTEqd36hoVq9P9K0/rcwKQXRJt/VLM=
X-Gm-Gg: AfdE7ckBPJnVfqj1m9xBFdZX/l1nsCjdVbd2AQ4WjSYCICzRL+jN25WgDwlFuuL7RIc
	th3fkK4GYhT5LlT5TRiFl+osODGHfaXW/FIUFVjiCe4oayCi2UdvR9y1ITvgr6FKMDh2CIb5yjd
	gLs4Bidh9LLe43l3pm34iuokk/a6l8oZvqfgtUigyj4cKvAcZfxXmtiuTDZq8O9jBnuXB/3i9J/
	n35XLEpUOvRzUQa+zqcH8jLAmNU1Wi/DQl/HU30Z/1T9ZW7QfVYbADHhtucVfUYPQgQZjKrRhvO
	h9Odud+O1eShXt71
X-Received: by 2002:a05:6808:14c6:b0:4a4:a693:9d8f with SMTP id
 5614622812f47-4a4d03063fdmr419990b6e.6.1784260013937; Thu, 16 Jul 2026
 20:46:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260716-series-vmap-race-fix-v4-0-8c108c4317df@kernel.org> <20260716-series-vmap-race-fix-v4-2-8c108c4317df@kernel.org>
In-Reply-To: <20260716-series-vmap-race-fix-v4-2-8c108c4317df@kernel.org>
From: David CARLIER <devnexen@gmail.com>
Date: Fri, 17 Jul 2026 04:46:42 +0100
X-Gm-Features: AUfX_mxBLT37KrDyrNbP0EYWC50r_QKOrJ4iSaMj1OT4QL3-liPKJMNfSVRy2ow
Message-ID: <CA+XhMqzUO49FiC-Oa6VYUt7Wm9RZLH30DhUH2kVn_PBodyZ6dg@mail.gmail.com>
Subject: Re: [PATCH mm-hotfixes v4 2/4] x86/mm/pat: acquire init_mm write lock
 to avoid UAF
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Toshi Kani <toshi.kani@hpe.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	"Denis V. Lunev" <den@virtuozzo.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ohfxyw1ozmyi4rmjpo65be3ri6etm1ce
X-Rspamd-Queue-Id: 1FCCC120005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784260014-851450
X-HE-Meta: U2FsdGVkX1/j50QRFuuQCFEXqV997bAQXNrzhgQL6pdl3T2x8r2G458qk2XAa7x9SpiNzfsa+seWHHh75T7MuFRvMWhZPdC5jCnyc5bcVX0Xa5+RD3XjX7Z0nf28Ql1/kY9F7srloKcnsrY5r/4INdMcVrCbOLGfEMe9cncudXESfRV0AxyenoAP8saEdb/QYMJUIbhf7+t17DAkPB2MvAQFjzpH8SOi3ZAxN42EpSiivH8J6/wENlBG2qd1eLBOnaA6u0uMnzReGalOat1Fyl+lGAlIAPwkgwYPQQxuIWHmWStEKYIULT9xqSK0g17deN9Br/3NzH19t2iS5APYzA6nUfG6hZrIGmEidqMWKUGPJrT24wR3M3+SXaTC5vm/8Kh9X1rggsdff6rgBN9ymLfZLNhcs/EcyA7HlbTB9k+XlErMB+MoZ5WNQUWvOYve+hd3gAEd1eJlLMnk6WrTdK+5+3Abw/6GTm3H1r2x9xiWlvYSxe2SMqjClu8Dq8mJQQx/1BAjAoAq6fLJQCpmHBGi2lzPjoHVOS4ztmsCmBKQmHhSbX22v2i04t082Ksyw6b87AGzhCQahlHxRtS4/oGZ3did9XoDdxNCGu6lc8mssDcdKoKXiaBs1mWe8eQtFYiXB6i1Mqhr63BES8+vDVypUteiEo3ZSksEpjYuvhdSDbAYQktbE8gfSOSjSl4D4OH0ynYV7JDkCAxxFl5XWavOxUMSCjbCA4zvpSNG5U7P5z+nD4s43fqPeCWQmRVT6ZpBF8sdCjlVS5yPPCwemXO6md/R2wSeg0SaJD6JKm2gCiQBmn+wKWuPEqAWrwPrwr2kFfeW1e0Vj5eHaOxzIVpBsJ8yWyHPd+VPiB/3fkE5t8kTtcEPaO2yurRNJtTgyJHQRG2dWMgnzcNIwjy3gQ4J1aylqi4mWuGtIlZuV4PGOTUhaR7jfw5fuxuwUOfekYSh9jMhb2jQOxN5ZtE
 oWldIKxr
 LIOGZ4acK3aL+TRieyF5EWMdG4nmxm6pove/BXpVFQdDhECXWvIMiImDtd2aVfBeSK1CnT9Ju7/f5KTg47G6bMIBnflAlf+KhqS5m/lkvN7SM9R/Vhag3UDJL/pKUmJIDVb7NCT1wXNYuV9ds86ky6D9iXFbmt1sAYNKr3j/2BqeFASSeIIRF5wbqfSIuG/R1sOD3sEpB1BEYtS8QcwSYeOb67AKb9J21A9bhHala8m0Jxx93X/ufq33KATrBWeXS3692jdSFLuR6QXYxNuNe/EjOQg6rxUrWs5IJGvUdED1th+8qUnIw3Ifmb4YHjFLjp9a+DAROM/ieAWet84vm8FTZmva1IItnToJ77FSJsdXvgYjgsSUUqFyjMc/mU/t2sYPcro6McKmg5GaJPJPv9Y+bV+nKcDqhjBtaqwxqF/N/Tzt8HeqKJrdpNrQ1wzkdxdn1ImRuOpd10MFXKS1uYVZGbyvnamK66m1kaN4k/dFaeGsp+tTy7mOSjI5TcrbGiRGdZMPj2MebFYg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Jul 2026 at 22:31, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
> x86 implements page attribute modification using its Change Page
> Attributes (CPA) mechanism.
>
> This tracks properties of ranges such as cache mode through x86 page
> attributes, and as part of that logic manipulates kernel page tables.
>
> Since commit 41d88484c71c ("x86/mm/pat: restore large ROX pages after
> fragmentation") ranges of kernel page table entries can be collapsed into
> huge page table entries as part of this logic.
>
> As part of this collapse, it frees the page tables which the collapsed
> entries previously pointed to, and it does so without any relevant locks
> being held to preclude concurrent kernel page table walkers.
>
> The only way this code can be reached is if CPA_COLLAPSE is specified, and
> this is only set in set_memory_rox() via:
>
> set_memory_rox()
> -> change_page_attr_set_clr()
> -> cpa_flush()
> -> cpa_collapse_large_pages()
>
> Notable users of this are execmem and bpf when manipulating executable
> mappings.
>
> However, this is problematic for ptdump as it walks ranges it does not own
> and thus runs the risk of a use-after-free on page tables freed underneath
> it.
>
> In addition, concurrent CPA collapse operations are possible which can also
> cause races.
>
> Resolve the issue by acquiring the mmap write lock on init_mm across the
> whole operation.
>
> It is safe to acquire a sleeping lock as all the callers invoke
> set_memory_rox() from process context and in any case,
> change_page_attr_set_clr() calls vm_unmap_alias() which ultimately takes a
> mutex, disallowing atomic context here.
>
> Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
> Cc: stable@vger.kernel.org
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  arch/x86/mm/pat/set_memory.c | 15 ++++++++++++++-
>  include/linux/mmap_lock.h    |  2 ++
>  2 files changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index d023a40a1e03..d1e63f7d267f 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -22,6 +22,7 @@
>  #include <linux/cc_platform.h>
>  #include <linux/set_memory.h>
>  #include <linux/memregion.h>
> +#include <linux/cleanup.h>
>
>  #include <asm/e820/api.h>
>  #include <asm/processor.h>
> @@ -410,7 +411,7 @@ static void __cpa_flush_tlb(void *data)
>
>  static int collapse_large_pages(unsigned long addr, struct list_head *pgtables);
>
> -static void cpa_collapse_large_pages(struct cpa_data *cpa)
> +static void __cpa_collapse_large_pages(struct cpa_data *cpa)
>  {
>         unsigned long start, addr, end;
>         struct ptdesc *ptdesc, *tmp;
> @@ -442,6 +443,18 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
>         }
>  }
>
> +static void cpa_collapse_large_pages(struct cpa_data *cpa)
> +{
> +       /*
> +        * Take the mmap write lock on init_mm to:
> +        * - Avoid a use-after-free if raced by ptdump (which takes its own
> +        *   write lock on init_mm).
> +        * - Serialise concurrent CPA walkers.
> +        */
> +       scoped_guard(mmap_write_lock, &init_mm)
> +               __cpa_collapse_large_pages(cpa);
> +}
> +
>  static void cpa_flush(struct cpa_data *cpa, int cache)
>  {
>         unsigned int i;
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 6b5c2390cc30..047f5f5e2c34 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -621,6 +621,8 @@ static inline void mmap_read_unlock(struct mm_struct *mm)
>
>  DEFINE_GUARD(mmap_read_lock, struct mm_struct *,
>              mmap_read_lock(_T), mmap_read_unlock(_T))
> +DEFINE_GUARD(mmap_write_lock, struct mm_struct *,
> +            mmap_write_lock(_T), mmap_write_unlock(_T))
>  DEFINE_GUARD_COND(mmap_read_lock, _try, mmap_read_trylock(_T))
>
>  static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
>
> --
> 2.55.0
>

Hi,

This bullet confuses me. __change_page_attr() and friends are serialised by
cpa_lock/pgd_lock and never take init_mm's mmap lock, so this doesn't
exclude them.

Collapse vs collapse looks covered already: collapse_large_pages() holds
pgd_lock across the walk and both collapse_pmd_page()/collapse_pud_page()
calls, and the pmd_leaf()/pud_leaf() early-outs stop a second CPU
re-queueing a collapsed table. I couldn't build the interleaving behind the
cover letter's "could result in memory corruption". Can you spell it out?

If the reason is really Will's v3 point - collapse rounds up to PMD/PUD and
frees tables outside its caller's range, so it has to exclude
walk_kernel_page_table_range() walkers holding the read lock - then say
that. It's a UAF independent of ptdump, and it's why v3's read lock wasn't
enough.

Also: patch 1 justifies the trylock fallback on ptdump being rare, but this
takes the write lock on every set_memory_rox() (BPF JIT, module load,
execmem), even when nothing collapsed. vmap_try_huge_*() then loses the
trylock and quietly falls back to PTEs on every BPF load. No counter, no
trace. Not a blocker and I've no better idea, but fa93b45fd397 was about
getting vmalloc-huge on by default, so it's worth calling out.

Rest looks right. 4/4 restores pud_free_pmd_page() exactly as it was before
fa93b45fd397, and 3/4 builds the same walk init_mm got via
walk_kernel_page_table_range_lockless().

Reviewed-by: David Carlier <devnexen@gmail.com>

Cheers !

