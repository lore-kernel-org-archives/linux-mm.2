Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90DD1606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f7Zzhskc
Received: by kanga.kvack.org (Postfix)
	id 9F1CF6B06FD; Tue, 27 Oct 2026 10:50:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2156B06FF; Tue, 27 Oct 2026 10:50:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 891B56B0702; Tue, 27 Oct 2026 10:50:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FE776B06FD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:50:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4739B409C1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:50:33 +0000 (UTC)
X-FDA: 85368692346.26.24AD7BA
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 765B6C0005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:50:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=f7Zzhskc;
	spf=pass (imf28.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793112631;
	b=TSFmIRy7eXh5YVcRI/Wregf2qKfCcLZS2P6xcOgsXeucKfQ9mbtDyPkaztg8SFjd4iTBz6
	48A6gr0PnUME4cDvM+IfeVY4P8mjvuhFxAVSFWFXqKq8HpgBwlDDAp8RmP9ZWlBRSEOqUp
	HPX0OSRjwZgJhAeb/AL3mpxJkOfiNTg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=f7Zzhskc;
	spf=pass (imf28.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793112631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GrQrPLClmrsE+He4Exu1Cy0LMOiiaKKo07ZDQ53Bndk=;
	b=DmoSlLh5b/+WKsH5htdzfLvsJTc/dG2ZIAFIx6jthrYPLXvsPupM6df5aqaDsq20/YaVvp
	xaj5Pp906QEyGi+0cgcRJMKBkIr1l7tYDp2+pf8Viy6Vw03HqNPpZ92D0xtejM2B+5AsZ+
	qCmPkRP6Y8CEKI4JsZVBuTlacKijCVo=
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5c9e7731b34so3040658e0c.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793112630; x=1793717430; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GrQrPLClmrsE+He4Exu1Cy0LMOiiaKKo07ZDQ53Bndk=;
        b=f7ZzhskcQ3RsprVjhvEfUhTJ1IZeddFrXhL2+WTbbw7oP3AY1dHvBVXLIoWbibBtG/
         dGtIyW7GQJTr6ZdkMOgjcQ3erGt1kb7qdZrlFO83Y3kfbI6jgnDePQ5D0yf5mlOqz4Kz
         PewfABSuMKnnQ5zfaNEP1ZSLXkSRAmiW8yzj+kAzrkyDH3wIsnybP4tzsEq+g/EGET8V
         kPt/G+7TfmxJXQBYhnt5gNSWjzHNXCzhIwyFmG1CdUFKnEg/l2QrEiOK4HQqRqC4pwPc
         eC5n2iYcV68q/KobbePK8rbnDoNVwHtccS7jC7iOyFh+tBdeyBdIpcivxGL3Lmj58SJx
         SmqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793112630; x=1793717430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GrQrPLClmrsE+He4Exu1Cy0LMOiiaKKo07ZDQ53Bndk=;
        b=NIC4/INRipRrG9iXzC+6mC6U0eb2MnjB3B7cEnNGfQXLRla5OA1ymFjDCDIrmNjJ14
         ajCjj8s6l4UN3Zdg60Qmdr2gtYtoszeA/SAVzcdw9EUL/4y3K50na3DDmCa0VNkwgafH
         0QkhVn3v9IYHTJRj7RPqvKDQphkmAu0WVnQ6Barf0sf5rVr0lOKsHfzvgEK9rt69XSOf
         crzuF1G5h3nKfUObdWagTysFIXgLWjtncqf/RdJL1w4TtdaDkopwS9r/4tsk/gUlDLM3
         povP0gL+sUJfDytE/ZSSv9+uUd5QYDXzd0Lgscfhc1qjpaXf+u779IJoKduN5ReBZ/Kd
         Kz2Q==
X-Forwarded-Encrypted: i=1; AKwUvBwFIwOKRL+FY9l2XCT+6YOnuUUIC4R+nNgtsn6t2MZhTmelriGh1OaZNwOyOadDCEHjR3U+0FKnJA==@kvack.org
X-Gm-Message-State: AFq9FYJVtYu/PcrLr6BBsB5q0ImxYmtA5x9W21pAXXeaqeAC4+4CA4Rd
	zWfBsDZqbHcu+UYXsF7eK8BtBFAIn5J+YfqKbxSlAxcgPAYJ+DYsRykH
X-Gm-Gg: AYBFou1sAcfOtbx9sAOoghs+KeSJFisXmk+kLwwZMHpHF/s4ilhBGjZxOh7ZiRfGvRU
	3N0CN4wR9VArSc3AH2tygTonyi4DxqU3dCiqRZmLyQSJDrh12IxCyADYSk3997/PVWUq7qBDDMj
	o2ZBn0Be+bSTFPjQGn1SyByE+0AL4R498HsLYPxOWq9EpaK03NgLFCwlwjwaSnnw1mW3wb4e9YQ
	29cGYbAR1k33/fcz4IlCLwDscxcb9An+Od7aH2alzxPNeRL9XM8eA2aLoOdap0hGs7ebzEi7Ay/
	Fr9+v79VdfV1wtL/ilbQGH25sQmv7HgwS1NhapSBPGRNgw7PKbHe/jJFLGbV79KaLffKg7/y1Zy
	mkWsqfOY12hBuc6QCjfkQW4lirfLM+bNliT+BGXSFLySprbrThcL40kbKGhmnNNQFKK839ELIgR
	jUiGjDT+YRY4jyKlhZiKouqdbgQJnZHMzKDVm4BuLdEup+tQ47iNE22FuJN0jMchkM/Y2c+LC7y
	M0DXjwcGVt04KKyr4g4/7DltNMl/YmalBVNsZhhVv2qf7wvJHpBkE+DEkU5HpbnUVPdy0CBujLh
	MJk8KLTC772p3LAF7lRgqZW4M5fcdcgpmg/NjdMSh4UiSYnQ1AB7j1mM
X-Received: by 2002:a05:6102:5809:b0:7c3:c0b9:8d50 with SMTP id ada2fe7eead31-7ce5cd9de6emr3685058137.21.1793112630369;
        Tue, 27 Oct 2026 07:50:30 -0700 (PDT)
Received: from fedora ([187.120.134.44])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec4a4b4b09sm110371e0c.3.2026.10.27.07.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 07:50:29 -0700 (PDT)
From: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
To: trintaeoitogc@gmail.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH] mm: clear pmd in pmdp_invalidate()
Date: Tue, 27 Oct 2026 11:50:15 -0300
Message-ID: <20261027145015.1338865-1-trintaeoitogc@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261027140950.1337359-1-trintaeoitogc@gmail.com>
References: <20261027140950.1337359-1-trintaeoitogc@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xzd8rbb41ft7a1z71rbf8ukhtgm17mnj
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 765B6C0005
X-Rspam-User: 
X-HE-Tag: 1793112631-306395
X-HE-Meta: U2FsdGVkX1+AwSnxru04DhKNb/H1BlFYfENjHnK9O926hW3Wo6qSl51M5BdPu8TSzkobLd1z5b4mBVtrjUuBumFJ6H8lJH0dpwuRIY0ntsYJbarTI9O6deDSAniaJf6JGUFWQ5dYWfR+DwIL+LEP2NOzd0yi78Rmz2NatyE60/Ch6FQp46Sbb9qEGMhHgVFUsBsRUVOuiU+M60eRHiXHt+iETZgt6XfPr3E5tIt/Qva1ezx/JZJoBJnuil80LlMwb7dfU/7etd8sl/WG3JDMEeKkLdZ9S4w6s5syn7M6HnWb6RqUeBo0s6xsTU6Mt4KoAWVkNowSyzWtGbAPDmUwuS4f1NC5PJ8ILE7zjjhOgJhMcBputvazywNxfO2WTsYHJugE3NWUNCPwThzxsUnD5EaNORJq2izpOry0Dw84F2SJrzGTfF0qLKkDfOCAMZsQvx3Vg8RnOuyPSAc3ss7K6tvZW1RGRQm9r71yKoDLmZhfBUU/N43WLCyueD/b++kHHSd3/S1F09Im+c69/N2yMxwh23uUuqQf/9NgytVRAagjW6GF/18T0gWpTEJToqJrnMf/Vkj3mYJG55hrdy/KXcgM3pl67x8rcma4FF6fpLNmvAYAQ2cAX9q7cQrjsfbK/MhKZkCBQsgqOpMLQG1OvXUl9ScZT7ZsnCBdLd0YfRufVZyvPtLC7iUgvt0y0U/vQkImGRy+dimV+XNKN0wF19zpVNKRA6AIJXY+DUk4kE0P+OKZoe0AWrIW/b+3edKB46tD00pqh6PPMJYH+MGb57UO9A+XLeOW9MLwY49iKqpRm3KmZCwEKGy7LhWUQb2GRwrKGqW4fzeHMeONwvGcyow0fE2dyMhUCmmqmP+X0jrrxqts3vKdUBHYE6SnBMs4VHoSB11279MZQ5HRBI21NNELLj5cLnmmUHYANUak+V8fJ+N+qbv8XMsQ47pYFiETGFmKKsa0hiN34vWF285
 2MD+RlmK
 S8CQZQJrOVtqEObvUOsKwuCic4lOx3FjpU37GRxvw0XtxuvRj7GrmFad2V5m9rpGhPrhan7lDSn4rxnmENEFxBv2E1thmB7EoPExwc71sXcrKYi4dJnyFnCcw1/6VC5tTfA0nhjI3OClYRYdHhOhk8Rvx3I0V3UFe7HzYWUBowYb3BrFLsEMvwdMEsGBRSE9iLQOZEicheq3E8MyevtWSpR9YfC0t1VbEZY6CiCRFIn5z0tgTtpzj6/3dhmI+ZuKg16Q2g7o+Y0Q6mEegEwPzQYLzwFOu1kqLHUexzg5jga1HMN42qa3u78LQnIk6BL5PA2WgeeTWxSs4XX+hQ7HQ+Rf4aKvk02Gxe/CLN4TpKDrGuaxfFhYEb7ZSMKyZ3RuDNaFvxi5XfKLRtfS8XZV9i5rrZVteVW8GTLwEkKiSHXukjJ12Nhvrq+vg9eWvPY1Q4f7SsZiqjUY09RWSt9Kf/5SVb/BwV39SouJt5254GD0KO25swlgXIX/UUgNwFz2pEXEpQ+VfoK4xCHwQbh1XLiDqd7Ky4MJjvmYdnlY/FWVw0HUBYLctGEkBTqx3PPa414FDQBGH6WZKiRqmIgvUcx9HbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Guilherme Giacomo Simoes <trintaeoitogc@gmail.com> wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> > > when attempt to do a madvise in a chunk of memory allocated by mmap, the
> > > folio_split is called to split a portion of memory, and despite the path
> > > leads to pmd_mkinvalid() they do not clear the pmd and clearer wording,
> > > leading to a BUG_ON inside page_table_check_set() because the map count
> > > is more than 1.
> > >
> > > Call the page_table_check_pmd_clear() inside pmdp_invalidate() generic
> > > function to ensure that the pmd will have they map count decrement.
> > >
> >
> > The subject + description is rather confusing: you are not "clearing the pmd",
> > you tell page-table-check that the PMD was cleared.
> >
> > This is all about apge-table-check.
> Yes, you are right, i'm not clearing the pmd, I will improve this.
> 
> >
> > Can you post the actual kernel splat you ran into? Or is this generated by an LLM?
> Of course, the stack trace of error is (already decoded):
> page_table_check_set (mm/page_table_check.c:118)
> __page_table_check_ptes_set (mm/page_table_check.c:223)
> remove_migration_pte (include/linux/page_table_check.h:83 arch/riscv/include/asm/pgtable.h:642 mm/migrate.c:448)
> rmap_walk_anon (mm/rmap.c:3053)
> rmap_walk_locked (mm/rmap.c:3169 mm/rmap.c:3164)
> remove_migration_ptes (mm/migrate.c:483)
> __folio_split (mm/huge_memory.c:3640 mm/huge_memory.c:4289)
> split_folio_to_list (mm/huge_memory.c:4435 include/linux/huge_mm.h:416 mm/huge_memory.c:4499)
> madvise_cold_or_pageout_pte_range (mm/madvise.c:420)
> walk_pgd_range (mm/pagewalk.c:147 mm/pagewalk.c:237 mm/pagewalk.c:278 mm/pagewalk.c:319)
> __walk_page_range (mm/pagewalk.c:427)
> walk_page_range_vma_unsafe (mm/pagewalk.c:737)
> walk_page_range_vma (mm/pagewalk.c:747)
> madvise_cold (mm/madvise.c:594 mm/madvise.c:614)
> madvise_vma_behavior (mm/madvise.c:1364)
> madvise_walk_vmas (mm/madvise.c:1721)
> madvise_do_behavior (mm/madvise.c:1916)
> do_madvise (mm/madvise.c:2014)
> __riscv_sys_madvise (mm/madvise.c:2023 mm/madvise.c:2021 mm/madvise.c:2021)
> syscall_handler (arch/riscv/include/asm/syscall.h:112)
> do_trap_ecall_u (arch/riscv/kernel/traps.c:341)
> handle_exception (arch/riscv/kernel/entry.S:237)
> 
> And the repro.c that I writed to reproduce bug:
> ```
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> #include <sys/mman.h>
> #include <sys/syscall.h>
> #include <errno.h>
> #include <linux/mman.h>
> 
> #ifndef MADV_COLD
> #define MADV_COLD 20
> #endif
> 
> #define HPAGE_PMD_SIZE (2 * 1024 * 1024)  // 2MB huge page on RISC-V
> 
> int main(void)
> {
>         char *addr;
>         size_t len = HPAGE_PMD_SIZE * 2;  // 4MB - two huge pages
>         int ret;
> 
>         printf("Testing page_table_check bug with madvise(MADV_COLD)...\n");
>         printf("Huge page size: %zu MB\n", HPAGE_PMD_SIZE / (1024*1024));
> 
>         // Fallback: try without MAP_HUGETLB (kernel will use THP)
>         printf("starting THP...\n");
>         addr = mmap(NULL, len, PROT_READ | PROT_WRITE,
>                     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>         if (addr == MAP_FAILED) {
>                 perror("mmap failed");
>                 return 1;
>         }
>         // Enable THP for this mapping
>         ret = madvise(addr, len, MADV_HUGEPAGE);
>         if (ret) {
>                 perror("madvise(MADV_HUGEPAGE) failed");
>                 return 1;
>         }
> 
>         printf("Allocated memory at %p\n", addr);
> 
>         // Write to the pages to ensure they're mapped
>         memset(addr, 'A', len);
>         memset(addr + HPAGE_PMD_SIZE, 'B', HPAGE_PMD_SIZE);
> 
>         // Touch pages to ensure huge page allocation
>         for (size_t i = 0; i < len; i += HPAGE_PMD_SIZE) {
>                 addr[i] = 'X';
>         }
> 
>         printf("Memory initialized, calling madvise(MADV_COLD) on partial range...\n");
> 
>         // Call madvise(MADV_COLD) on a partial range of the first huge page
>         // This should trigger the huge page split and the bug
>         ret = madvise(addr + 4096, HPAGE_PMD_SIZE - 8192, MADV_COLD);
>         if (ret) {
>                 perror("madvise(MADV_COLD) failed");
>                 // Don't return - the kernel might have crashed
>         }
> 
>         printf("madvise returned: %d (errno: %d)\n", ret, errno);
> 
>         // If we get here without kernel crash, the bug might be fixed
>         // or the conditions weren't met
>         printf("Test completed (if kernel didn't crash, bug may be fixed or not triggered)\n");
> 
>         munmap(addr, len);
>         return 0;
> }
> ```
> 
> I see this BUG here:
> https://lore.kernel.org/all/69851c62.a00a0220.37c87e.002e.GAE@google.com/T/
> 
> Yes, I'd should mencioned "Reported-by: syzbot+227179d5a8a87e9df90d@syzkaller.appspotmail.com", my bad

At first, I suspected of pmd_user_accessible_pages() and I started analyze this
function. In a brief search I found a CVE that fix similar bug:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=21e5eca0ac9046da9918a919bc92b7b5a78d27e7
They do this:
```
-	return pmd_leaf(pmd) && (pmd_user(pmd) || pmd_user_exec(pmd));
+	return pmd_leaf(pmd) && !pmd_present_invalid(pmd) && (pmd_user(pmd) || pmd_user_exec(pmd));
```

but, inside riscv-dependent code (where this fix happen), the pmd_user_accessible_page() is:
```
static inline bool pmd_user_accessible_page(struct mm_struct *mm, unsigned long addr, pmd_t pmd)
{
	return pmd_leaf(pmd) && pmd_user(pmd);
}
```

and the pmd_leaf() do:
```
	return pmd_present(pmd) && (pmd_val(pmd) & _PAGE_LEAF);
```

and pmd_present, do:
```
#ifdef CONFIG_TRANSPARENT_HUGEPAGE
	(pmd_val(pmd) & (_PAGE_PRESENT | _PAGE_PROT_NONE | _PAGE_LEAF))
#else
	(pmd_val(pmd) & (_PAGE_PRESENT | _PAGE_PROT_NONE));
```

So , the pmd_leaf() looks like good enough to check if the pmd is accessible to
page_table_check.

... Too , I suspected of PAGE_PROT_NONE, because the doc above they declaration say:
```
/*
 * _PAGE_PROT_NONE is set on not-present pages (and ignored by the hardware) to
 * distinguish them from swapped out pages
 */
```
And this lead me to think "if set a not-present pages, so maybe this not should
return true inside pmd_user_accessible_page".... 

So I check the `git log` to see when and why this is introduced. But how is
mentioned by git commit message:
```
commit e3613bb8afc2a9474c9214d65c8326c5ac02135e
Author: Stefan O'Rear <sorear2@gmail.com>
Date:   Sun Dec 16 13:03:36 2018 -0500

    riscv: Add pte bit to distinguish swap from invalid
    
    Previously, invalid PTEs and swap PTEs had the same binary
    representation, causing errors when attempting to unmap PROT_NONE
    mappings, including implicit unmap on exit.

    ...
```

So , they is introduced to distinguish between swap and invalid ptes.

So , I concluded that this is not the problem, but maybe the documentation is
not good enought about the PAGE_PROT_NONE flag.

And, after a lot of thoughts, I try to call page_table_check_pmd_clear() ,
inside pmdp_invalidate(). I attempt to do this because, I see any architecture
dependent pmdp_invalidate() calling this function and think that probably this
is the solution... 
I apply , test with my repro.c and , this WORK. 

I implement this inside generic pmdp_invalidate() because, in my mind this is a
generic problem and can happen in any architecture not inside riscv specific.


thanks,
guilherme

