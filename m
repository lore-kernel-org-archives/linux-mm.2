Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52EEECA600A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 07:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7548E6B0093; Thu,  8 Oct 2026 03:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 725996B0095; Thu,  8 Oct 2026 03:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EDA66B0096; Thu,  8 Oct 2026 03:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE036B0093
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:30:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD657A04A4
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:30:50 +0000 (UTC)
X-FDA: 85298637060.16.CEA7782
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id BDAE5180006
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:30:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OdaKZexO;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791444649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7XwukL8/yd82nFdVG9qm4VBZNIyM/fBMMvZK+hA2jjo=;
	b=By77l/1QEEYQrB270WWjf/jIGTruJqFQvQoGjP5V2aUzuvLpmbbGY8XlV50REBNASj4XhB
	CXtl1AZ6Kg99OdGJ6/wOMDM3cI25oM1/+pXL79mFyqbUtIZIuFiayaCVzptENxkVUrqc1h
	G/Kgx6QdtnBRGFdU0GfRxUh8ZTm8xQc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OdaKZexO;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791444649;
	b=i/sMEj7J5vfEZGkl6meD5er0dNH/y0qzMDzbTZunW4lYEcQaMcWu8SE3A9yS+ULX3c6H27
	CpjditQxSA0MFdBjeFG64mklaJxcnztSddi8QpcnJ0+0KmjUqjxNYgRg9Mre2kabNovoJh
	wIPwBnnFvWTxwtRk5x4d3TUad/2ZeOc=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc4c02ddd62so2061381a12.0
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 00:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791444647; x=1792049447; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7XwukL8/yd82nFdVG9qm4VBZNIyM/fBMMvZK+hA2jjo=;
        b=OdaKZexO7keSis/of8Rvj1YpB4p1CW2Hn6XsXiU72y/UHzc/sJRxrZanOP/2hRnFPW
         jMJd0STQYpfXbm9EXRHrllYjX8Vsxk/T7+6R1a/CrOMyidigQO6zJwvwHb7CUUNEJVBu
         ny4YToDT3GE8kT2DSkQf/3iw1nK8Te1T3y4hg6QSq9/L+dCNe7i7R0O5SS5nsXIafnyj
         49QH+H5z8QDNTn2NNNcZ6siE/IkHGCAyvHbZafYhVvhQHpEUI7oVZyhhd5LnhSFyFdyM
         76c0CSFDB6dr/bhsP8mi3/poNsv/s4KNI8haKHVgBQ40VtBLnH34b5JuGsnGkfkxuh3V
         eeEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791444647; x=1792049447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7XwukL8/yd82nFdVG9qm4VBZNIyM/fBMMvZK+hA2jjo=;
        b=eRBy+0rlNtZNtQXomFAX6fsEWdE1N4Tw9nKiPhqTiR2tYRbV2aeWCVVA4JHaTYYfPO
         frDdYlbYMHSn1Mq1DoVUmcWDG7KO7Gz4FDAggAZy36GtFAlSdnRQvowHxAEcBFAS4EJW
         q3LAWEbGL2Yj3Zs5eK+x0zzonw9jpJBY7gDk4tKiczev41sVsxUdNGAeUeuA0wXl2+ff
         i20C0QSltZaaENMAKdhJ8wDu18Fnaj+GIQ8AlcggLgYb4DB72gyecmIBKpwmQJZzw7JY
         VLL21Am4catFGVd2R8EUnjRDYGVUKztyGz2vvnHs+8qlbZUuItfjWbxYU9utnKrWXlpu
         8KKQ==
X-Gm-Message-State: AFq9FYKuVvERQuz3N0skATpe2kdvF9MZFi4lk1wJZyQQlexFtzBZvvWv
	sv6ms4bnO81sfPVYTYseDeS4b+z/KsgRNV3uJ7Tj9zZda18trUWHKsMqj7dXEZSdk4Y=
X-Gm-Gg: AYBFou1np/YivwFQaauzoI/+QXAJDrj60zaZZACqMiQOxjoFyfEYs6lgOAT2OFDe3KU
	ekALUGMhbLT7qz2WjeclDGv67P7XGhE3XVeWqj4TakBraCgyigPbik0W1ELJPYHEirUzp5QRWHa
	uW0t+KmOvtKg57rw0fumDoX8IaFPDlb9yA8NkxjAm+Fitcl2G4t4Rq7ePdq66J5nliJP92z8KiG
	kYNkVUJ8pYLiI9uWk9xl2ym86NrZypyKG8BUlZ6J7H4HuwRptzXxR/ri3Odf2MJ8snK3QkdH8Oy
	/aQRpr4/uyY2jAu5nsFKOuJ9OlnuETrnUgzERC+drtd6Ch4dKRK/RpOZJ9Iep6s0LplBN2Pg5FK
	9hoj5E0Af5i8JjywTDqJ/5qiQ4ECzuYpBTxhBraPbMFeVPAuXZor+2Ym5tXtzKLMKz/c8M7Q86b
	bT5z0Lwk3zucuc5D1zwcqVPyDEdTQGfuzgq0IUecn5CbzUc/vlvdFNbJqgMCj/h4lf0iG+hoUOw
	sxyfdUFLRIsdx6kpuE=
X-Received: by 2002:a17:90b:2652:b0:3a7:b260:9cc6 with SMTP id 98e67ed59e1d1-3a8a1b91be4mr3069089a91.42.1791444647313;
        Thu, 08 Oct 2026 00:30:47 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8a438f25dsm3114715a91.2.2026.10.08.00.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 00:30:46 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	stable@vger.kernel.org,
	david@kernel.org,
	osalvador@suse.de,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	linux-riscv@lists.infradead.org,
	agordeev@linux.ibm.com,
	kevin.brodsky@arm.com,
	bjorn@rivosinc.com,
	apopple@nvidia.com,
	linux-kernel@vger.kernel.org,
	muchun.song@linux.dev
Subject: [PATCH 2/4] riscv/mm: fix hotplug page-table destructor handling
Date: Thu,  8 Oct 2026 15:30:19 +0800
Message-ID: <20261008073021.2512665-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261008073021.2512665-1-songmuchun@bytedance.com>
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BDAE5180006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: pqxkw6jazhofz3auckskejd7jes3zah6
X-HE-Tag: 1791444648-784569
X-HE-Meta: U2FsdGVkX1++EuKw8OpUfvBo9C6ki2y40D+mV2euHWSvn+DLCRosRMuL07FvlgyhdP1p5XFmVvGkZknm7qrF7YzoZ9PRmXidKmxg4GLH75ImuS34EErqwl+eE4Vl9noE+bS+ze1a4PtGbv0A1Xgsz6brFo4dvOhcrDaKwj9EByEufV8clmQGBL+btUv6ND55oHwbBAsfoF0uMuYwqlgqeDLBuNVz1+atv5k9bUnj9xiC5Xi3TFzr60Dj1zy81hpLc3XtU4iR7i9Pu+Ujwo+E5m+f1SvD59YooE+4TwYt+bL9hxYQjuQRuhCBUsIy5rgPTDoA+/tqPPR4K9EvcjUZRGPnIKXAp6lnrKR8ycnetVLkFqv5IkEwLi7xzYTvzBIPLYm3djMI4UJkNURDnVkYj5vG4aIVqn2xob/XLPV271W7ktl3as34ekq5M35/lxLLMGckqoOn+ELgjmdYGtD69DoUV3bATJoOMFqixq/vnNtubagj3UNSJZvpGqiiKN/bXz1lTW9O+EMTEgrZZS6/hGfacFgHnY1UA6CRQLK6Qgadsc0kYLFNXt7WR/alpqAvcH8R/GwQmgdwWvsFsK78PYLIVbfIA2m/V1hb8U8qrt5CbM2949TSvC9E8sebD+Zsq4BfClw3Mb6kJj2WBpn4jjBKiolYYOd1OmdVpKubu49u5TX5sUJphWOwTOLe1fB0+DGQrjb3F12igGCT4PIAr6zfhBe2QWBMGnNNtLk5W+tO56ORqsIk4pbuqbiaQHzoSPABbaA2khOOfZLL1jotRNRoOLwv1Omw5dNIQD1dU0FUpQs94bXT7nqwsN//7CevARzj+KbsTl8hcXoE7CCG4RsHwkIn+xCGm4moIV6bv2/ajXjbM5o8tMZvZ+a/jrdbop07fpfSy0G/7XwhTbgnIwckUdijJNKuqFyQVSkNPzPEFvrSG4F9kB/RYECfkLTpCRKGt6gebuExdfUQgEa
 TAXUPZW3
 L0SSxm5M5rsFITAFPc+MCrV0k0Hlvh8+m3sro3pku/MzMvlV+/W1aDG4USAo9lRweko+BK+3Tk6xnWgW8cw4osGgwuE4E1zk1O+aaxRpwJ8Cd7raYMRrHIkq38kNJ68+7PdTr+IQT5QWSYTuj/HKUz1zY2kLqtFFDiUBGhJwxh8e5QOsdd/wlCw8p0JBPDHYozqiu4UQzQq1Oxg7/DWPeoaMQ/R2pn7SbVsQnTMDRw4Feg1Y+urpyq05ly0mPsAz/kLJ5ldI8gd7VRtQQDBri69cNvYsGObm82/o+nfYGDqITyY576tfJo6exoapIxN7X0RHaf97fm5xMpIYYTwhgIBPnPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RISC-V uses the same memory-hotplug teardown code for the linear map and
vmemmap, although their page-table pages are not always allocated in the
same way. Late linear-map allocations run page-table constructors, while
vmemmap and early allocations may provide constructor-free pages.

The PTE path unconditionally runs the destructor, which is wrong for
constructor-free vmemmap tables. The PMD path avoids that problem by
using is_vmemmap as a proxy for constructor state, but that assumption
will no longer hold once runtime vmemmap allocations use the normal
pgalloc helpers.

Page-table constructors record their state in PG_table. Centralize
page-table freeing and use PageTable() to decide whether the destructor
is required. Keep reserved and constructor-free pages on their existing
freeing paths.

Fixes: c75a74f4ba19 ("riscv: mm: Add memory hotplugging support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/riscv/mm/init.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 857f9a55039c..429a0b015ec1 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1486,10 +1486,19 @@ struct execmem_info __init *execmem_arch_setup(void)
 #endif /* CONFIG_EXECMEM */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
+static void __meminit free_pagetable(struct page *page)
+{
+	if (PageReserved(page))
+		free_reserved_page(page);
+	else if (PageTable(page))
+		pagetable_dtor_free(page_ptdesc(page));
+	else
+		pagetable_free(page_ptdesc(page));
+}
+
 static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
 {
 	struct page *page = pmd_page(*pmd);
-	struct ptdesc *ptdesc = page_ptdesc(page);
 	pte_t *pte;
 	int i;
 
@@ -1499,18 +1508,13 @@ static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
 			return;
 	}
 
-	pagetable_dtor(ptdesc);
-	if (PageReserved(page))
-		free_reserved_page(page);
-	else
-		pagetable_free(ptdesc);
+	free_pagetable(page);
 	pmd_clear(pmd);
 }
 
-static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud, bool is_vmemmap)
+static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud)
 {
 	struct page *page = pud_page(*pud);
-	struct ptdesc *ptdesc = page_ptdesc(page);
 	pmd_t *pmd;
 	int i;
 
@@ -1520,12 +1524,7 @@ static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud, bool is_vmemm
 			return;
 	}
 
-	if (!is_vmemmap)
-		pagetable_dtor(ptdesc);
-	if (PageReserved(page))
-		free_reserved_page(page);
-	else
-		pagetable_free(ptdesc);
+	free_pagetable(page);
 	pud_clear(pud);
 }
 
@@ -1645,7 +1644,7 @@ static void __meminit remove_pud_mapping(pud_t *pud_base, unsigned long addr, un
 		remove_pmd_mapping(pmd_base, addr, next, is_vmemmap, altmap);
 
 		if (pgtable_l4_enabled)
-			free_pmd_table(pmd_base, pudp, is_vmemmap);
+			free_pmd_table(pmd_base, pudp);
 	}
 }
 
-- 
2.54.0


