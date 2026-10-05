Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62D4BCA5FFC
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 08:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D23336B008C; Mon,  5 Oct 2026 04:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA156B0095; Mon,  5 Oct 2026 04:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE9CA6B0096; Mon,  5 Oct 2026 04:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 959D86B008C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:46:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C9E112018A
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:46:55 +0000 (UTC)
X-FDA: 85287942390.08.8E202D4
Received: from mail-yx2-f2.google.com (mail-yx2-f2.google.com [74.125.224.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 367F640005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:46:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pqATxsfN;
	spf=pass (imf01.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.130 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791190013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iy7K2MY429karblm1RWZnJsHtbbKuquWPEKzVkmQqvM=;
	b=ViAL5Lshg8v1eIbs5XWZiLwcvEAptC5XvE2VmDfe54dGsZEiBx5V7VuSsGe32lB7PD8CkD
	iCLHLT6CpCRxSV+BARL+9wXPlmCF5qRCdC3QmI8/36ELwOI8Tdv4XZSN00HnekoJ63Tbnx
	My7QZSqwlYJM83TwRsK5+IbYekkrECc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pqATxsfN;
	spf=pass (imf01.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.130 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791190013;
	b=RW6Ra33UbWwHcZjLhT65EIwTHyxVCTQWcsbS+2ZmpeubDMa0XAD2OcyQGsZp8xp6mri83X
	AJazWky1amgpN5ArpMpT+Ivl2rG5ckupGQk+JnbGvGUrnTU4ghv3JqZ7g+36KbegtH3S6h
	Smj4l4/bq2LF2yoZCw3RLYl20kJn7B4=
Received: by mail-yx2-f2.google.com with SMTP id 956f58d0204a3-67569b8cbf8so297239d50.1
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 01:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791190012; x=1791794812; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Iy7K2MY429karblm1RWZnJsHtbbKuquWPEKzVkmQqvM=;
        b=pqATxsfNXzRr+4kl7XkoEs1o3Zz/W8jdnwnU4MrXERzrqejsg/r655NoIgZqQGbQo5
         fXYreRF2IruGBUiEtlBmzdxDSV5umykgRNDCzU1Uvp2eAGiV0nJRTpO0G1cQnqvzLVVP
         sGjtOd6vHmFoF9k2JrysPtyHLMYXtwlTqXSgFT8Zf4ydTBQkaVv36HNrDYHo9Q8bqSaH
         lAfTqF3FLwpPqVcSrcv0tkqny8iu+nM0P4uj1hb6jqeEtpSQYoC5gBShLLkWdoz6AHHp
         fI55XZaRJkRHVKDTfwTc3eiJL6a492/llsOwjseE79wE05YerKme3EwqnGWOF0eCMqHm
         S9wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791190012; x=1791794812;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Iy7K2MY429karblm1RWZnJsHtbbKuquWPEKzVkmQqvM=;
        b=S6w5EeCdwhDftiEE3nCHCzWN1YBsSB0CSTHbBczSpbxExhp1lRpD6NKOISCtRn79zm
         f28Sj4NDAnx5t2q6/bjILs8f4bQCqZQg1mZWyFL03JbYG5TYM0S5QzpWmYsuKvsPoSbz
         3ai6orG1YvJIPrYK7oYjm9ajCs7nRQ4PcXq70hHGgpa/8NMkgn6xX46KH6VKK8KEmVmM
         +ekacht4PkYZ7Og8OQ1zaHOVT2CngdV+YEk9SzKZsSUOYkP63WbMkIB0rSpoFSY3cn6M
         4mRAKF/en9+ZnlNTZp/XLd6FSEN9DFE6gIXK/XQDNL0PWzC1tsAtyjlhzJ+2SPfAKP/x
         nB+g==
X-Forwarded-Encrypted: i=1; AKwUvBwjmg4bWSJm027f80JlmoGRxr4KfRjFO5dHzArcDB32TPujo/yUzDZ6f5hHKO5dZ+8B4OfT9zl3CQ==@kvack.org
X-Gm-Message-State: AFq9FYKKeedeC7WzXiI4TXrRBDoNZZb51T4rmqFAiI/l9KYd2oSWiSIj
	KvaTmk4BWvb4BGH57ZJ5S4EgEmUcZo4Od/rLZ/nj3FCiQUARZb2DdBs=
X-Gm-Gg: AYBFou0BgiJnbPtY7HYlKxCQbEa8QqBBpi0xa9jaWy3XC78XEhPNbR3VJF/obM4Nv7i
	OxV8QYwU09jlfaBZyfGUQ4pUaoeZfrSi8vMbQ4bQ7gRL5rD5cUzpz66df3eX0Qj9XWetQ/R8ARV
	fNblMcH/p5E/CrhP07S/pZbY3rqrE6Ax8nUc37p5SLej4zFHfVYM5tuNUEwR3yEZPrnHgJyGYej
	kJiVwSyfx9UM4o8pVaAtsDQA7gyvUHmrMSj4MkeF45DUISGVifMm0m6ghF52SBKbUeIOkCg8mRV
	LK1Hc7ndwa1VSV0STF0JxuyvQfXkvY9r74GmGg7aaUeU/xKtnqxzUUIRQGUWIWMLG8FOIsNjzrS
	VruU3wVBgDGJRfdNXL0wxkYdhH4hBxaRxxNuYr/EDCOZAir/1ydHFbj+VgzNMgQGoVdgWFce0hi
	aml7CgJX08X2Wq+gTvrdMm94I8cIfFpoqWUtynkvt/7925SR2nRyyGiJtiiAg4/5nUO1z3cAHG2
	DDLg4DwQlXylp876X0WnORJ+Oo8r4H2MWI5I5xEzAg7D9OrxwgpFbh79/3rovAFmp77FeORLCk3
	EMcGBWojMq2odN7HJokdwl3bwnHL+xzmZw==
X-Received: by 2002:a05:690e:1309:b0:677:dae6:51b0 with SMTP id 956f58d0204a3-677dae663d0mr758067d50.18.1791190012138;
        Mon, 05 Oct 2026 01:46:52 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2600:1700:4577:1050:1149:2fcd:c86b:8747])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-677c1b9c895sm2346306d50.13.2026.10.05.01.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 01:46:51 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Mon, 05 Oct 2026 01:46:45 -0700
Subject: [RFC PATCH v4 1/9] mm/damon/paddr: remove page_fault access check
 primitive
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-1-b03452e137f3@gmail.com>
References: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com>
In-Reply-To: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gregory Price <gourry@gourry.net>, David Rientjes <rientjes@google.com>, 
 Wei Xu <weixugc@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Bijan Tabatabai <bijan311@gmail.com>, Ajay Joshi <ajayjoshi@micron.com>, 
 Honggyu Kim <honggyu.kim@sk.com>, Yunjeong Mun <yunjeong.mun@sk.com>, 
 Akinobu Mita <akinobu.mita@gmail.com>, Lian Wang <lianux.mm@gmail.com>, 
 Kunwu Chan <kunwu.chan@linux.dev>, 
 Ravi Jonnalagadda <ravis.opensrc@gmail.com>, 
 Jonathan Cameron <jic23@kernel.org>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 367F640005
X-Stat-Signature: i47wn4tsmqmpubztqp9t89umwxrh6sn3
X-HE-Tag: 1791190013-803867
X-HE-Meta: U2FsdGVkX1/kYRVNX3Boy6YlZ6K1ST0SUBhIBYmQINIgRf6oFCL8IriV0EwY6i2tAPNhhaCEci3O3XupWPB5S7+ma6yQeDrE7QS3s5q1gow5UMw/zQa6sVcOY1+8o6k5SXLtHo0CU799BNVtXAozDT4MUqSH2fPQ6H1yzthXQP7PWH79EvbuIezxd6ofXRoG/Qf5SusWIPqtR1knfJrWQmYxzwixN0UIZLT3wn01WqxW8jLKh8G427x2+s3M/A9byk3TOGKa9iwRUwFzSFAYsUbmAd2V78MUagOpMkBI1t8vlj0anHb7m6WANN0mNLTZ4EA+mC1lW3mnsDHvom68buUsV0hQKZ98o35jhemNMpr7Vua7aaUsQjt4Y3nWlwvCI1zhmnJo1uupUeOOLzsnKGJn8sUg4atkKHiUI3JF8wCN0jafvVym8barB4axznBW6/csc4O8xR5Yq4XuUrJXoWd6fWXdqlHyLu0TtIBKhacPcyphYn5U+k0xygD0R5CH8/ON+XAkP7I/XVXtqD6yzmqX6mCm3pHXKl23Gzt8GVlk2P80r4N1UbICOahIWjL+qcghj1fllYel4QJ9ak+JY1X1LCtaynOkm9izJWvzX8LUZkAVWfKLH8N00RPeNPEu3EAWEIb1nxaPa81ZOnBqOL56B+OeaMYR1LK5twyWaN8YxJYQyjyNtrjTVzrF0vbpGAApoDfS9hRvWfhrBLxkIu4vjQKNl1Dnq1A1SCJJ96YVgJQjmCRlbv3g2SGI7UtP8PRKh28AJPVsT9rfjomPyRMYKtPVWiAfbeFY7froL10bpfKBmntjFLXDSG2A3fXumGHE1iKSFscLcp85Eh+Rk2zOquFYx0wCLW3nW/agJOUL4+BwCZ7RB9Xsikbx8Of9dcVVryfSHWO93OhFuHqa7lLI3VExB4++1zg/J/Rg5txdoenGbbGJFemSiaVYnivKeBjC4SowtabSUJLIZMq
 fohnjEtH
 zGihCDEKW6zWmrUhzmfk/wpFf1WEchVOtJoIz9Sp0pAekWYDUhrCvcGd4HRWW697aVUHorJmd/PuvjFfSWwM1KiOm6d4456ilWE499BAMS4ZaagJe5FmybgGGZjMVmzkaPyXIHR+gym3UcgXAgX7Q9S1B8GydaG0SLFVnVK8hKVtLY5BoUvgPoR/Nxb+ff8LuPMZ81yan2NA7IUO+uMXiagNvpNKjYRvZxESb8wphkL0hoZDJuo2gHE1nw32ZSIbtdfMZENwc8/jc8F36T0bpYXFI2fKkukr/1XPjW0tdrgWWidhJqNDvEPnrXGJuzUdo29uZXSjetcIvFZuK7xwVxJuOyILJ59G+Euhf1Ks4ZNLslmuxVISOA8PwzqVGZ0fU5GLCyw6HBuDYQO4/JlFyiWRtSM8+eH9pnxKYPSGTaNVQEwqg4AWN2/LQpkJKSrXM63sGqJCvDqIT4j5mI/sqOc8M7VlSJQ4gpn7mhHeqzXLnVJHGVfWu89Waso2RJotNXD75B7eT5N997f7trcyNsZnlyp2ocG5wHaK1ZY1t5WFVealoM5/91sA0h1UdLWGJfws+eY2TrigEioA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page_fault access check primitive reports faults through
damon_report_page_fault() into the global, mutex-protected
damon_access_reports[] buffer.  A later patch in this series replaces that
buffer with per-context rings fed only by perf-event probes, which leaves
the page-fault producer with nowhere to report.  Remove the producer here
so no report is silently dropped.

Remove damon_pa_prepare_access_checks_faults() and its supporting
damon_pa_change_protection()/damon_pa_change_protection_one() helpers,
and the page_fault dispatch in damon_pa_prepare_access_checks().  Remove
damon_report_page_fault() and its sole caller, do_damon_page(), along
with the two page-fault-handler dispatch sites in mm/memory.c that
selected it over the ordinary NUMA-hinting fault path.

Writing Y to the sysfs page_fault file now returns -EOPNOTSUPP, and core
validation rejects a context with page_fault set, so a configuration
cannot select a primitive that no longer reports and have every region
read as cold.  With page_fault gone, page_table is the only access check
primitive left, so a context must enable it.  This leaves MM_CP_DAMON
with no user that sets it; its check in mm/mprotect.c is left for a
separate cleanup.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h   | 12 +----------
 mm/damon/core.c         | 24 +++------------------
 mm/damon/paddr.c        | 57 -------------------------------------------------
 mm/damon/sysfs-sample.c |  7 +++---
 mm/memory.c             | 53 ---------------------------------------------
 5 files changed, 8 insertions(+), 145 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3d0c05df3258..7940840b4da9 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -930,7 +930,7 @@ struct damon_attrs {
  * struct damon_primitives_enabled - Enablement of access sampling primitives.
  *
  * @page_table:	Page table Accessed bits scanning.
- * @page_fault:	Page faults monitoring.
+ * @page_fault:	Page faults monitoring.  Not supported; must be false.
  *
  * Read &struct damon_sample_control for more details.
  */
@@ -1299,13 +1299,6 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
 void damon_report_access(struct damon_access_report *report);
-#ifdef CONFIG_MMU
-void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd);
-#else
-static inline void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
-{
-}
-#endif
 
 int damon_set_region_system_rams_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
@@ -1323,9 +1316,6 @@ unsigned long damon_alloced_bytes(void);
 static inline void damon_report_access(struct damon_access_report *report)
 {
 }
-static inline void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
-{
-}
 
 #endif	/* CONFIG_DAMON */
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index ddf9c08aa6c1..3638e2054030 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2087,7 +2087,9 @@ static int damon_commit_sample_filters(struct damon_sample_control *dst,
 static bool damon_primitives_enabled_invalid(
 		struct damon_primitives_enabled *config)
 {
-	return config->page_table == config->page_fault;
+	if (config->page_fault)
+		return true;
+	return !config->page_table;
 }
 
 static int damon_commit_sample_control(
@@ -2544,26 +2546,6 @@ void damon_report_access(struct damon_access_report *report)
 	mutex_unlock(&damon_access_reports_lock);
 }
 
-#ifdef CONFIG_MMU
-void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
-{
-	struct damon_access_report access_report = {
-		.vaddr = vmf->address,
-		.size = 1,	/* todo: set appripriately */
-		.cpu = smp_processor_id(),
-		.tid = task_pid_vnr(current),
-		.is_write = vmf->flags & FAULT_FLAG_WRITE,
-	};
-
-	if (huge_pmd)
-		access_report.paddr = PFN_PHYS(pmd_pfn(vmf->orig_pmd));
-	else
-		access_report.paddr = PFN_PHYS(pte_pfn(vmf->orig_pte));
-
-	damon_report_access(&access_report);
-}
-#endif
-
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index f4fa7c231e55..65a5b3269d1d 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -67,67 +67,10 @@ static void damon_pa_prepare_access_checks_abit(struct damon_ctx *ctx)
 	}
 }
 
-static bool damon_pa_change_protection_one(struct folio *folio,
-		struct vm_area_struct *vma, unsigned long addr, void *arg)
-{
-	/* todo: batch or remove tlb flushing */
-	struct mmu_gather tlb;
-
-	if (!vma_is_accessible(vma))
-		return true;
-
-	tlb_gather_mmu(&tlb, vma->vm_mm);
-
-	change_protection(&tlb, vma, addr, addr + PAGE_SIZE, MM_CP_DAMON);
-
-	tlb_finish_mmu(&tlb);
-	return true;
-}
-
-static void damon_pa_change_protection(unsigned long paddr)
-{
-	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
-	struct rmap_walk_control rwc = {
-		.rmap_one = damon_pa_change_protection_one,
-		.anon_lock = folio_lock_anon_vma_read,
-	};
-	bool need_lock;
-
-	if (!folio)
-		return;
-	if (!folio_mapped(folio) || !folio_raw_mapping(folio))
-		return;
-
-	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
-	if (need_lock && !folio_trylock(folio))
-		return;
-
-	rmap_walk(folio, &rwc);
-
-	if (need_lock)
-		folio_unlock(folio);
-}
-
-static void damon_pa_prepare_access_checks_faults(struct damon_ctx *ctx)
-{
-	struct damon_target *t;
-	struct damon_region *r;
-
-	damon_for_each_target(t, ctx) {
-		damon_for_each_region(r, t) {
-			r->sampling_addr = damon_rand(ctx, r->ar.start,
-					r->ar.end);
-			damon_pa_change_protection(r->sampling_addr);
-		}
-	}
-}
-
 static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
 {
 	if (ctx->sample_control.primitives_enabled.page_table)
 		damon_pa_prepare_access_checks_abit(ctx);
-	if (ctx->sample_control.primitives_enabled.page_fault)
-		damon_pa_prepare_access_checks_faults(ctx);
 }
 
 static bool damon_pa_young(phys_addr_t paddr)
diff --git a/mm/damon/sysfs-sample.c b/mm/damon/sysfs-sample.c
index ffc9c8545547..27f35cbb509f 100644
--- a/mm/damon/sysfs-sample.c
+++ b/mm/damon/sysfs-sample.c
@@ -421,7 +421,9 @@ static ssize_t page_fault_store(struct kobject *kobj,
 
 	if (err)
 		return err;
-	primitives->page_fault = enable;
+	if (enable)
+		return -EOPNOTSUPP;
+	primitives->page_fault = false;
 	return count;
 }
 
@@ -590,8 +592,7 @@ int damon_sysfs_set_sample_control(
 {
 	control->primitives_enabled.page_table =
 		sysfs_sample->primitives->page_table;
-	control->primitives_enabled.page_fault =
-		sysfs_sample->primitives->page_fault;
+	control->primitives_enabled.page_fault = false;
 
 	return damon_sysfs_set_sample_filters(control,
 			sysfs_sample->filters);
diff --git a/mm/memory.c b/mm/memory.c
index 41278e32dde6..44034d5b32ab 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6565,54 +6565,6 @@ static void fix_spurious_fault(struct vm_fault *vmf,
 	}
 }
 
-/*
- * NOTE: This is only poc purpose "hack" that will not be upstreamed as is.
- * More discussions between all stakeholders including maintainers of MM core,
- * NUMA balancing, and DAMON should be made to make this upstreamable.
- * (https://lore.kernel.org/20251128193947.80866-1-sj@kernel.org)
- *
- * This function is called from page fault handler, for page faults on
- * P{TE,MD}-protected but vma-accessible pages.  DAMON is making the fake
- * protection for access sampling purpose.  This function simply clear the
- * protection and report this access to DAMON, by calling
- * damon_report_page_fault().
- *
- * The protection clear code is copied from NUMA fault handling code for PTE.
- * Again, this is only poc purpose "hack" to show what information DAMON want
- * from page fault events, rather than an upstream-aimed version.
- */
-static vm_fault_t do_damon_page(struct vm_fault *vmf, bool huge_pmd)
-{
-	struct vm_area_struct *vma = vmf->vma;
-	struct folio *folio;
-	pte_t pte, old_pte;
-	bool writable = false, ignore_writable = false;
-	bool pte_write_upgrade = vma_wants_manual_pte_write_upgrade(vma);
-
-	spin_lock(vmf->ptl);
-	old_pte = ptep_get(vmf->pte);
-	if (unlikely(!pte_same(old_pte, vmf->orig_pte))) {
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		return 0;
-	}
-	pte = pte_modify(old_pte, vma->vm_page_prot);
-	writable = pte_write(pte);
-	if (!writable && pte_write_upgrade &&
-			can_change_pte_writable(vma, vmf->address, pte))
-		writable = true;
-	folio = vm_normal_folio(vma, vmf->address, pte);
-	if (folio && folio_test_large(folio))
-		numa_rebuild_large_mapping(vmf, vma, folio, pte,
-				ignore_writable, pte_write_upgrade);
-	else
-		numa_rebuild_single_mapping(vmf, vma, vmf->address, vmf->pte,
-				writable);
-	pte_unmap_unlock(vmf->pte, vmf->ptl);
-
-	damon_report_page_fault(vmf, huge_pmd);
-	return 0;
-}
-
 /*
  * These routines also need to handle stuff like marking pages dirty
  * and/or accessed for architectures that don't do it in hardware (most
@@ -6686,8 +6638,6 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 		 */
 		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte))
 			return do_uffd_rwp(vmf);
-		if (sysctl_numa_balancing_mode == NUMA_BALANCING_DISABLED)
-			return do_damon_page(vmf, false);
 		return do_numa_page(vmf);
 	}
 
@@ -6806,9 +6756,6 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma)) {
 			if (userfaultfd_huge_pmd_rwp(vma, vmf.orig_pmd))
 				return do_huge_pmd_uffd_rwp(&vmf);
-			if (sysctl_numa_balancing_mode ==
-					NUMA_BALANCING_DISABLED)
-				return do_damon_page(&vmf, true);
 			return do_huge_pmd_numa_page(&vmf);
 		}
 

-- 
Git-157)


