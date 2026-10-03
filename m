Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB2FDCA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D56D06B008C; Sat,  3 Oct 2026 17:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2FB46B0092; Sat,  3 Oct 2026 17:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81866B0093; Sat,  3 Oct 2026 17:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DEFC6B008C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:08:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA79D1409EF
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:08:25 +0000 (UTC)
X-FDA: 85282553370.25.DA66CE2
Received: from mail-yx2-f1.google.com (mail-yx2-f1.google.com [74.125.224.129])
	by imf02.hostedemail.com (Postfix) with ESMTP id C4CFC80005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:08:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Byjn/0UO";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.129 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791061703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cTXzKyPAYLSKTuAayh1igoCj2XMMyLRIxo66Ogyyd0s=;
	b=zp3UWUZ2SYEXlcWL0ws2eCUH+sv3EofYAGKWYq+/sidUdfj8oP+PO9XHnIcfsVslJYoiXN
	CQs/WEtQfkO7Rz1xntZTkjGPzLqWYzh5n5RXaW7AlAnxShDz93rUg7gEcfP4A+6ZHXKd6w
	rfhpdBL9B35pNfsR98Lk8Zsl8R1ZOHY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Byjn/0UO";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.129 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791061703;
	b=Uu0Xhkvs/gaSuhU9anb4dLZ8YN0Zm9WuY+/RKcLAzVtTJ35bvGpH1kUK2Qvil0dYPNAcMH
	oK0jrcNrNUGkQGTots8gmsBxgmus3ebSVbnCYaUzx4uZhSBO5Jm8ZC7vWLqeUw8vWioNk2
	EQNIi39SdE5+SkQF1GG9ImzdKbt2X+Y=
Received: by mail-yx2-f1.google.com with SMTP id 00721157ae682-857cb570f53so632137b3.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791061703; x=1791666503; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cTXzKyPAYLSKTuAayh1igoCj2XMMyLRIxo66Ogyyd0s=;
        b=Byjn/0UOf/9OMEXl1ujCzOMnBFR2r4N2DAiXKe/ZRSi9KC3lPcdBUGoZMCCmPbDHqB
         sLNtaE7jLx//Q6jjG7pOf8Z3BIYTSQQQxKBVm9Hffx84tdis0hS+UxcyTxARU4LkP7Jr
         qZQ1hGPnMyXrLJqu5vokmHJGMFcYejffeccRhHWqcXWemngz0bs2IlU8/YDs7RdgaYVN
         AOgR84aB758t0F9i0EzsHxgZQlRmpmWMoY/Kg+07+3a1WUuA1182uut57iKOHFrtgS6N
         u0nB6EGbEfI1sqd5A7IA87/zU/1sqYqONDF9lllJfqpAwgT23A32PXq/UGWdM7cNkb6P
         4gCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791061703; x=1791666503;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cTXzKyPAYLSKTuAayh1igoCj2XMMyLRIxo66Ogyyd0s=;
        b=JgyZmal6ReG1ADhNKGsFm8ZhPEK1poue7jIvAeLjT/UqBPX/EjVrkuUdyObLk81JCo
         TWgXz/lJb4RpwLX+TQgLyQ2RcbiD5lhYzZIaQSUW2P8thx/HcYNVBe0yNx7fbmQl9xvs
         SI1oPkHBcR18IQ+wKPDDYyY9Ppg7FssaFUm8DNWLFeMzZ/fFcgf41rzdzyMG3WZhkAbR
         u3yl4YNo1u00Bg7r3QfsQQplhGAc/KXTD+wTwzpB1D3thpA5odb9rpIfkVvaLW6WVWm6
         KChXksq2FOpl6XV6n6V/1TWq4RsP5lfChGgRLyPkGclfrES/+tPEyLA8yWoDIbNPbA2l
         kWKg==
X-Forwarded-Encrypted: i=1; AKwUvByV800C0zrzlrL/NF2clwA1UtC3fMJGd4hiNZfFWXBf6otRF/kMo2XrKtZo9+aGtfKNL+Suysj56A==@kvack.org
X-Gm-Message-State: AFq9FYK/KiD6NSTvmxl4kwso26jONO5FLebEIRshZ1CnVYxXJcGyDWNP
	sm9BPuClK9ShhFIX4P9v1P+evw6jc6xarNeBC4mZzeSeXegWgbObvHL9YP0p3yw1GA==
X-Gm-Gg: AYBFou1W0lGG9dgwD5h71tjXRshxe1E6s7oA5AzZ4uWtOyv9RKm4nzrEUKfjz6/0COA
	id6CiA+cNmHyHzVCSa4Uwj8omPntnDTJ2+1ta5kmoikzCOi5cGsoR2ZBEp856sNUwvGCXeTAt7A
	B76Y+BSNm1ljWx+X+/u8qikGXX0EfJSxV+otwWxAIGbxTDtyehOcYqo0XA92a2aSyfnMOkfOhqu
	1LE+mVFgs3XlBGh8qM0ufd445+Ng5hId1221r5gmwzmEDN5r+VXdPdpjC0qc279HJkTEzICLxyj
	OIlTVefJ5NNi0qmxvPV81qQVxN08kdWrK9GANNCOZfEHR/KUb/nm3E1/PIKuJckZIvAnQ/clvgf
	4Pd7wa9SVuysbK8g0uzm8e3px/mJawoBg8o4DLg8C+5ZLDrO4MCRu9jvQPvZRZR+dFOImsaau3l
	6jiX8Q+xVdG1JvzMS1213RmhAB/9Nk+ye5qUZg1gQJclDgKcSU3qZeB7F4FAt6tqIa18e8A2s3W
	TFB6b5Itsw1OhJIJMkyKpPGpPoCsyQkmxMyunZbNz2CUUjMpH59SkWCKdThRcb8KOLoVVRDyRhn
	LKcNU7Q/9h6pF3M5amqiv6cSD1e7/X9oRA==
X-Received: by 2002:a05:690c:47c4:b0:884:c83d:d182 with SMTP id 00721157ae682-8ae33de4fbfmr27023737b3.0.1791061702821;
        Sat, 03 Oct 2026 14:08:22 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2600:1700:4577:1050:550f:9551:5468:60f1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8af0d179d3bsm743537b3.40.2026.10.03.14.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 14:08:21 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Sat, 03 Oct 2026 14:07:54 -0700
Subject: [RFC PATCH v3 1/9] mm/damon/paddr: remove page_fault access check
 primitive
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-1-0f00417b41bc@gmail.com>
References: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-0-0f00417b41bc@gmail.com>
In-Reply-To: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-0-0f00417b41bc@gmail.com>
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
X-Stat-Signature: 3h3ww7f5s9qw35sm5hu9z4bbekr5tntz
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C4CFC80005
X-HE-Tag: 1791061703-160602
X-HE-Meta: U2FsdGVkX1/ngx0dUfb/fztSekhVDaS7QWMLMrK120p/KU6tQwXuC5QwEryrPKsYyzhZULyqvOOLc7E/A//PBRHDVV0XqYASxiFBPNPGHr55W3VannUc/R1fOmWD+NZAEDspxKfviqW4RpGDN3kwpNmIZm1MWBIPATihOxtCnmvOtbVuMahmqPFrGDHp1DLgDMvCop797l0NaXVmZkQFQ3o31hibJBUenMPNjBBiocl23jMGBaIoOk2H8M049GtjA7LhXfOzUw8dRSTJ8mrSc44n0qA+MJJrrU/+Euk9eSTbaoW7eRsj63p6J2IV+dmN2XiN8aNSBW5F9HbDzmqHdoOU9Q5dGilNf4Es4mvv5olVwskWR34H5/P2c/bFjeoSkhW6APnatl+tVb3hfoHt4dHEUZh1Jzlpan5XIr8PgL0DQG2z92k7fva5hBFrxYX5MVC4f6oSoi9VflAi2Fl2OJ777YX/DBTxo2WUitwawPmi4txXUp25Z+0LqSCaWx7PPsxL+DQvWkx7SSy5surftY7A8RfcettfKacd/AQyumqlIceOu4s1Lk1LhsqLGlcMa1UiPhE0lCh+HN+Y6cxv51pCauLokkVUksYvkS3eLlfW09ljfPLWpJTJr+Ki5imve4Phcbnm9A5OTWX+lmuudzs0y0wXQSJZIimiPiDV94fsaqG/diTI4KwnsglnN3xNmvgZMkJzRw/aLShZQULW9XxroObjhJO1QUSqNZjZfY7+PefY/WlIpIYRqf1eXOCM6HsdvXp5qbp0InqiqhS50+5oq68VyiTO1uwKI2GP7mJF6ZATq/gXMC0oifkVXD/KrUqFgRKCWHdzZQfBG4gmszWhOsSqP52SE50AMwQyXuh30ZgizCIZCbODbGrn68vSC0spmRBnrgGpEiYE9HGmPpaQkaCBY+dVk+o5oCkfygzPDY9UaHChQtmryQrTx7f/J936PxTjWZq5wcsJ3F0
 JDH0mtj7
 5kt0ruLJnKEAG2zeKnE9McUMvxFP5Y12Am9W7u3YxggDnxzU9IJWn2euJHd0t16UOCxpbIODd4TnblQYb5VpFg96Ek2Dm/ggEUyRu7nuPzmcpxftUdhN/4Ae1J6I7ch61gay8j3eFtSmjU6Tth9Cz/awjAf76k8uYFSNARTMtP8z5Hu7/dJyE5ZrqViSRs1fzUMdI0hInSOSRzPtSUsABQQZudzfm9Ri8wy8EefvIXoL7tEiwwkQ0NcOeV7Qsx8F8r94GRpGmoc9oVKAWtVKfpVsIdX4maaV52xNX8XlXXwWB7HycVmQRNeYZsSXeWtpdvmY8RUnzzWoxucaMSNeIAB/hjklpH42UuopPhjmuuni83QrJrHWgU9Dv1uzUVgHInrUkdonNFE71H7Dty+I0haRM+RKR26LkBDYtr3fP+FgMpMB94YQtJQrBUbSbaQwyYS4kGOdoXOzzAURGxctRhStHIeyglVjYRHT6Sox4UanzNVzUKljMzhSf8+2NQdbMNpWVYtxqktr0mhY/e4n/0YzlrvFadHlEoLQqk62llWp4i/uIxrmkT16laZQP0EtEkbSPGlvCiIeQNVs=
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

Both removed pieces predate this series and are unrelated to the
perf-event probe infrastructure it adds.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h | 10 ---------
 mm/damon/core.c       | 20 ------------------
 mm/damon/paddr.c      | 57 ---------------------------------------------------
 mm/memory.c           | 53 -----------------------------------------------
 4 files changed, 140 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3d0c05df3258..10582f669673 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
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
index ddf9c08aa6c1..886e068e7844 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2544,26 +2544,6 @@ void damon_report_access(struct damon_access_report *report)
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


