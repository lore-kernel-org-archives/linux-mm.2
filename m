Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B5E0606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fwPm5lg4
Received: by kanga.kvack.org (Postfix)
	id 7F79A6B077D; Tue, 27 Oct 2026 10:10:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A84C6B077F; Tue, 27 Oct 2026 10:10:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BF336B0780; Tue, 27 Oct 2026 10:10:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 44C076B077D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:10:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36F15A0A7A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:10:08 +0000 (UTC)
X-FDA: 85368590496.05.BE68C1A
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6901D1A0009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:10:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fwPm5lg4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793110206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tOHCbTTh38wgZqUQAraRD2c7zMfmVdF5wzMAOJI6e4A=;
	b=0vjNLka7hlldLAgz3jh/LF4ze2QicHTrIwqyKLTXCLwkSqi2g3B/x3DPGCpodHU4nrVhrA
	QpT/kLHiIIj6XZpaGkb6sJWWa3AsyyJ4sramH+vhuyD2X385hecYtVDiDDv0f5o8uGHW0T
	cz1QgH/EssbNIDuJbnvBxjmTRuk+mrs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fwPm5lg4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793110206;
	b=z0sUlfgFy0M3hzmykceIEpK+5GhRGNtCHqKfJxpRU7jhL94IFFjzm9fmlmiBHZ65VsZsd3
	F2uRDWnzyI3iJMZipfYixRNubMMVTNBKmuEyn0vZRlEV8azuvITa+Xrsg3aJT9ei80rz2y
	FkweDOKkEGCBkpJOwZ63TIC7r9kXg94=
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5eae12762c9so1874620e0c.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793110205; x=1793715005; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tOHCbTTh38wgZqUQAraRD2c7zMfmVdF5wzMAOJI6e4A=;
        b=fwPm5lg4uzZjYBRRmcNib6LrdW9hcr2spdLtTARGT0g62dZKJ+SQEQEhRuCpS5icLo
         SxRv1jFRzKQdBf/lA9bLk5W/avx5WlB/W6cykqI2DSNh+bkMz4Ao2viJBjnm7R9FUG6f
         cf6JjKidbNps7QJbN33LJ6435uArA8h3QEEN16eDAW2/WkAU0AjCjr4ReSdZQyKk5dy8
         GVKYUiJHkypcNHVo/FDEIQd/bbGfcMYQ/0r2JCKmpOqT7AkRetlFXfGchBiCO9Qd4rBA
         KgTBAu8PIxAqR/WI5lix34p9mSNse4lzPtorpmbQEvuYQf+GzrSjzVQ4cC4b/5XpfNW+
         qkFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793110205; x=1793715005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tOHCbTTh38wgZqUQAraRD2c7zMfmVdF5wzMAOJI6e4A=;
        b=ks95+87hVMcdTRdH8hvIfD8g01IUKhu40DLELxexKUyIjjygYMNSQA+P0DKCuTfByI
         1KEkKXTV4RmocUJMlqQGWHANjelcYo+mueN8Zith6o34I4CmYQKbAeGv9Hlyp9MUlmxx
         l91E5xC7vGZ6hHD4rxfwh7r26UcMPwIqoLxwkXzvOllscP7xpibufHe2GDstdUTnNMQv
         RYuu2BwDYOArXGRTicChE6KoFTz9FmDi8/0rnKxpoWeHJuAtp2DUBTYXhJX1LHzSzmt3
         SmMDS/qCaggvEk2VwufMhzcUmj/VQXnyVyAT6Up89VKEvhn0y/1YL56oy0LfnRUWhHEQ
         UY7Q==
X-Forwarded-Encrypted: i=1; AKwUvBwUruB9DgLR4395FEkL0A2AbOYp9F0S5yMJGRZEKCMw7TzXcSNjWZgFgB1XSQeu55e6WWNU/aNO8Q==@kvack.org
X-Gm-Message-State: AFq9FYKU0I1EZYzUg9xYxfUKOeSVhzG489Xf9Mv+TbYON7sMc6CF+BtB
	NYKcid9xM0fRclTOinG4iUxHu4NC6gBCVt6WYD0Z3pXtAKaSztAj+CfU
X-Gm-Gg: AYBFou27x8TsgPihOZzlDvTipOhe/nPizKOFniHo2KtDEiFeFHst8I7czN/yKw9kF9+
	oujVD8iesHFf42G4ciyykQcBmmENDMKRQDUYNgAeEAwn22RVn4PzsTcQAbsVSHsID2an1pBUQCo
	GBTwOi4BHuZ/n3S+6CUf37puwbgAafbj6rKJJEfYcmcWEEPdDKXfkou5fexuLbmFaQ/G81OtA8s
	IeRyefrc5d1Cd5pqRuS1wPuFLkUgjXyWRr7gkUKMjKmxeoQ3EIIR4IF0kejL7R7ymzr14GwnC0z
	I2RvyI09aN3PJ8UrO0wXS8jUtxWNznPSvZ9M2Yy104MflEmGN5s/sHVEMuS/hA1jC5e2QTq8SeI
	mafq78GKuZGxnKM07KDFvCYN9fmkKiUaY4fpuHiI6Zsnf11l6u5QWrY/spJzbnuW7kLB4tGyMh9
	FlMQA0wEB3Om8050jY7YMIlQTflCM/FwESronfYv16uqjY59reRBeaDWQstMPKSN5MnN4b4WIVU
	g0/Z0JlBYyFu31zSim+g0M171x0r1nXuBhj/2W5xoqoWMbMm1Irt4uwrAnXSbaas3vX5N0vgOSd
	iDJUrf/4XrazA5M6nI8NAQXhogtpB/QWpKwR9XJMToASi1yEzdsGok0h7OIAAbcjj3Ljw/1Dxt5
	9SjRWy9w=
X-Received: by 2002:a05:6122:ec5:b0:5c0:fb8d:9993 with SMTP id 71dfb90a1353d-5ec22ecfe84mr3781126e0c.0.1793110205099;
        Tue, 27 Oct 2026 07:10:05 -0700 (PDT)
Received: from fedora ([187.120.134.44])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec233f4d28sm11903907e0c.3.2026.10.27.07.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 07:10:04 -0700 (PDT)
From: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	trintaeoitogc@gmail.com,
	vbabka@kernel.org
Subject: Re: [PATCH] mm: clear pmd in pmdp_invalidate()
Date: Tue, 27 Oct 2026 11:09:50 -0300
Message-ID: <20261027140950.1337359-1-trintaeoitogc@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <f1b2ec5a-f7a7-442c-97fd-f67fe6ecb197@kernel.org>
References: <f1b2ec5a-f7a7-442c-97fd-f67fe6ecb197@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6901D1A0009
X-Rspam-User: 
X-Stat-Signature: ieqy9q3xgb48f6ndk6ywjjrshfjss6aw
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793110206-822202
X-HE-Meta: U2FsdGVkX18kqKaMrF3eMTfHWbS4a5FURaN0GMctE0sDQpyYb0ftyXKf0I6On+b8bHVJ+e/Wrjf/IUVNJJJl999nbOebqaZ9lGFPT2WKnp2riTK2Vqb9PfDqrJPFcc0XSCV1kv8DVTn8SBUys+jvMArNwEFbbl+O61a0zQ2xd1xkH2nPcdk8tqaZE1WNkDDFG6ygpfenb9e9hNu9E/drLhdWwqNPJc3tacqAk7dZn1HOcjCyNa+aJ5kvInHhn31z2BXtnZYVtfuystd8HpCyULUQqEiF0VKD+ci/t0u3O2LNAMIKNm6wXuRK7HGcuEYeHzNspW1HOmdchM8CQC4lkA78KOw0rmCWyOlIJpMvIKDCuXUkJI5DIh6W1OaYpBWx2NRi7rdc/N7dYD1fadiYikTZl5Mqksu+kwMHSsL65vCEKlhMy8f8AsIZXkPDvqkou/KHWFnl/pZdOAHglgLY+u48p1CsgY5tUPlEFis/O7lmUYRn0nSptjyjjE7nNOTJtTgYvDRCS0waux7+xFQERJOnRpRz/pTzuZb/bhDviEjzDC488kx4H3bjibahSdNjJyZc4BNFG4DcroCfFNxm9q4FYmOmqU+ExZmwk0pD9qrC3f6/cbAdGdWrhgU+EeWR3zgzdZNrCNw8RNwW9uqRTAsjxQN3yEjIkvgrQ3SPzH4+sy3U9Rg+uFGQkTEG/UO31cOOAuUIX2UN3R0e50oYLzBQzyBzKYBFENUxJHpQifc1bHNX9bUU4kfwdCb/vJ9mADPmzdk7JnebIVnAiUk6bq/aVEHi5ADC9SFrL9SVwnv6eAL9WxQe8BC4NkDnoiv725761a/1ymBJdIUOp1imGxHuzxvyG42KnEPgvzhkiQ1T8J+7Gp3LlCbB12kPV5Tu2CeRWOONaUfjrtoj+Djq7y0dYKNLvQW/2Is8NsHHJQGASkChSeQ78t365/inxJaUE3zg3evBqYrrYRTHIgT
 wfXMUXkX
 ppcRVnKDpDhMAjTCY8aKYeAq52IoAeHg5DHLeTumyVnm9PEZFlhh8PxoeiAZb9FoufKzTIxsw7cSFWtPyYP8/yae+OJIqchdZ4oRjOzV+nH3q3f9BGPkGMlF41bGBfiX+LUTsAq9EbiL6cqNRg0ITa+w6uEQgXo8iUl+9LcBIP8+tCHgYz0w73aGHglWGHie9kIKsihvs1EvzTCAzYYpchrp5YUmRQBdlbX7hinmxBBNORpeDeLdr9o9TbyOwH/KTQm5w5WV/4L4aoX7j26Uwho3G2o5KsvVX60QaSD//YrEhPU3voY5iuTjsij9+9mdhVMsJFqzMgv3XBWJsF03MCvqDf7QCJU8VAFwgX2t4aoB6pHrX/6BZmmLEIs2uU8rbsgxISFh2KPyvI7hp+nBHlKuSJPWXhXyRRQdpaZWEnRPS1p+zzd03zLmxTAg8veqG1S3AEerkW6so8dPU1JBwwfEsSsA19mmiLAVJbQEKSogautRTv2Sui/nJM+GIXtJy5S/7oPx6MtikzeBR07F+X+jfonCp4uH8lQoF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"David Hildenbrand (Arm)" <david@kernel.org> wrote:
> > when attempt to do a madvise in a chunk of memory allocated by mmap, the
> > folio_split is called to split a portion of memory, and despite the path
> > leads to pmd_mkinvalid() they do not clear the pmd and clearer wording,
> > leading to a BUG_ON inside page_table_check_set() because the map count
> > is more than 1.
> > 
> > Call the page_table_check_pmd_clear() inside pmdp_invalidate() generic
> > function to ensure that the pmd will have they map count decrement.
> > 
> 
> The subject + description is rather confusing: you are not "clearing the pmd",
> you tell page-table-check that the PMD was cleared.
> 
> This is all about apge-table-check.
Yes, you are right, i'm not clearing the pmd, I will improve this.

> 
> Can you post the actual kernel splat you ran into? Or is this generated by an LLM?
Of course, the stack trace of error is (already decoded):
page_table_check_set (mm/page_table_check.c:118)
__page_table_check_ptes_set (mm/page_table_check.c:223)
remove_migration_pte (include/linux/page_table_check.h:83 arch/riscv/include/asm/pgtable.h:642 mm/migrate.c:448)
rmap_walk_anon (mm/rmap.c:3053)
rmap_walk_locked (mm/rmap.c:3169 mm/rmap.c:3164)
remove_migration_ptes (mm/migrate.c:483)
__folio_split (mm/huge_memory.c:3640 mm/huge_memory.c:4289)
split_folio_to_list (mm/huge_memory.c:4435 include/linux/huge_mm.h:416 mm/huge_memory.c:4499)
madvise_cold_or_pageout_pte_range (mm/madvise.c:420)
walk_pgd_range (mm/pagewalk.c:147 mm/pagewalk.c:237 mm/pagewalk.c:278 mm/pagewalk.c:319)
__walk_page_range (mm/pagewalk.c:427)
walk_page_range_vma_unsafe (mm/pagewalk.c:737)
walk_page_range_vma (mm/pagewalk.c:747)
madvise_cold (mm/madvise.c:594 mm/madvise.c:614)
madvise_vma_behavior (mm/madvise.c:1364)
madvise_walk_vmas (mm/madvise.c:1721)
madvise_do_behavior (mm/madvise.c:1916)
do_madvise (mm/madvise.c:2014)
__riscv_sys_madvise (mm/madvise.c:2023 mm/madvise.c:2021 mm/madvise.c:2021)
syscall_handler (arch/riscv/include/asm/syscall.h:112)
do_trap_ecall_u (arch/riscv/kernel/traps.c:341)
handle_exception (arch/riscv/kernel/entry.S:237)

And the repro.c that I writed to reproduce bug:
```
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <errno.h>
#include <linux/mman.h>

#ifndef MADV_COLD
#define MADV_COLD 20
#endif

#define HPAGE_PMD_SIZE (2 * 1024 * 1024)  // 2MB huge page on RISC-V

int main(void)
{
	char *addr;
	size_t len = HPAGE_PMD_SIZE * 2;  // 4MB - two huge pages
	int ret;

	printf("Testing page_table_check bug with madvise(MADV_COLD)...\n");
	printf("Huge page size: %zu MB\n", HPAGE_PMD_SIZE / (1024*1024));

	// Fallback: try without MAP_HUGETLB (kernel will use THP)
	printf("starting THP...\n");
	addr = mmap(NULL, len, PROT_READ | PROT_WRITE,
		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (addr == MAP_FAILED) {
		perror("mmap failed");
		return 1;
	}
	// Enable THP for this mapping
	ret = madvise(addr, len, MADV_HUGEPAGE);
	if (ret) {
		perror("madvise(MADV_HUGEPAGE) failed");
		return 1;
	}

	printf("Allocated memory at %p\n", addr);

	// Write to the pages to ensure they're mapped
	memset(addr, 'A', len);
	memset(addr + HPAGE_PMD_SIZE, 'B', HPAGE_PMD_SIZE);

	// Touch pages to ensure huge page allocation
	for (size_t i = 0; i < len; i += HPAGE_PMD_SIZE) {
		addr[i] = 'X';
	}

	printf("Memory initialized, calling madvise(MADV_COLD) on partial range...\n");

	// Call madvise(MADV_COLD) on a partial range of the first huge page
	// This should trigger the huge page split and the bug
	ret = madvise(addr + 4096, HPAGE_PMD_SIZE - 8192, MADV_COLD);
	if (ret) {
		perror("madvise(MADV_COLD) failed");
		// Don't return - the kernel might have crashed
	}

	printf("madvise returned: %d (errno: %d)\n", ret, errno);

	// If we get here without kernel crash, the bug might be fixed
	// or the conditions weren't met
	printf("Test completed (if kernel didn't crash, bug may be fixed or not triggered)\n");

	munmap(addr, len);
	return 0;
}
```

I see this BUG here:
https://lore.kernel.org/all/69851c62.a00a0220.37c87e.002e.GAE@google.com/T/

Yes, I'd should mencioned "Reported-by: syzbot+227179d5a8a87e9df90d@syzkaller.appspotmail.com", my bad

