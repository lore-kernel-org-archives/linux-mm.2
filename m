Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE36C606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 06:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=RQYtgorD
Received: by kanga.kvack.org (Postfix)
	id CCD176B0AF0; Fri, 23 Oct 2026 02:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA50A6B0AF2; Fri, 23 Oct 2026 02:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBABA6B0AF3; Fri, 23 Oct 2026 02:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AB336B0AF0
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:34:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE3CCA7B02
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:34:52 +0000 (UTC)
X-FDA: 85352928024.15.006FBCB
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 024DB40005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:34:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RQYtgorD;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792737291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=db1iEGMFzAz69F0Qd2NIWb14nn5dPV9u5Dz96tL5APM=;
	b=HwPjdlrmvm5vCPYr0arC7Xhmt93hK1ZCY4lfZfa+o2xfxIUplaldYVtDNe5O+8AU8NVlCr
	BfHeRhAsDGEOD4JFAmq7N5OLDOlu6f8CjUfB22TCMEMNOzYw4LoMUM4Np7aWblwoY7UzYa
	hshmvIjwHog3mec3VDTEHMbYJa+uQPQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792737291;
	b=KwuyWGBnxd3iZWGvn3o2S1GGAw3WDrLoT1ynw5yHpHOusYazcKgCx4e7HBwzQNM0zlg+Ti
	5ec2m7LvzByi5pn7OVPSvwvJ5wMHnUVlNhxFtW81lDlCU654NfvvAYGDfrPi1dK20phVNf
	C0IxQzp/soRpZFcop6o6MKQLOQlFTBo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RQYtgorD;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so326717a91.2
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792737290; x=1793342090; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=db1iEGMFzAz69F0Qd2NIWb14nn5dPV9u5Dz96tL5APM=;
        b=RQYtgorDqz36UpRe076uV2Qq6bQ8WyHIv4p4en25tiX3u/yZmqBYUYvZNZK3ElLTeJ
         boyIcvMweu1e1qadUP49CHFh7LBhIOhx6lqEmD/0ttFN2Yp45HTgaq/nKh/L/syyhkBp
         JuYTfePC64w3Qs3Iiwj34bUyGo11HkFcUZ3Vwcwkd2xIZjENDAl2dojiTE/MmLS0lNSP
         50yB0Oj3CfQZCTTFuPO7K2UcoIJZ2bSBujjXtQpG6PcFiHNvf3FSoJaO5XffSWEaAYuP
         fzq8Esumc4MV8r6LLjEwRLHvBv5OIqH3Ezh0m7pcoH2xOyjtcU2rHivHMTTlWkc8zDJH
         mgKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792737290; x=1793342090;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=db1iEGMFzAz69F0Qd2NIWb14nn5dPV9u5Dz96tL5APM=;
        b=oJEjtx+/0mB2coE9DjOuKAXlw4pochOfzIErMlEPBdfs+PGSmjgSLRnbVuZKQdo5KM
         B4AL7OqGpjPZ0hdYenY86DoCH9pYTKaBLUOyIyYnJCUSaot1oKQKq7zQnyZ4uRRpg0Sv
         1X3Of50W517u08kxprxA+I0pBbbfWPXwj1/o6tGKvjjXc5wnSxfou3vyOu167QkNdgUX
         ge+Z3SmHJp71EsrLExqXhWBKs0sNYahsD4K03Mn7XdhWId/5c2z9qJMz54fcxjGUY/yU
         moScGB60rBwUGItgWNqBPiFvgmh6g2BN3RArnJMBHgTkh6emDX0eIc+3K3iyvfOGAce8
         Wtlg==
X-Forwarded-Encrypted: i=1; AKwUvBy36qgyC2dqaGtx06zbgaoue03UgVuZ2JDyQfohcjlncaM0ccZlbhYepg9aoL39E7OC+2nm0/m5TQ==@kvack.org
X-Gm-Message-State: AFq9FYJ0ygMp53HwBKcs+nDQzBsqQ/Q0MqX9f58pD68vHZdbTRC8lgBM
	phRt0Zvlk8zZJIpo8RxdDa7XPJlBSBRsosh5mYpLYOLrcyrGCWS2zmhg9Q+UcEFPUGY=
X-Gm-Gg: AYBFou1F7PPsJg+PpXMaSHWH4TyqxtoBv4BWRQn8FUZKQWeiumBNDQOB/++VyYFKibm
	g0WAnl6nHRNaTDUaJg0NuMdFTcE18koveBEOHU96k1S+6+ViGpieEprfaGTso3NJaOrcPA9VDCA
	Ewq+ZhKXkqi3JLNXwNYYZ185PTEACwc2sH57DeMojxtu9SlHO0gWdmTNCpJ9FvOa34K28bSDGj1
	Mf09R6SCbTtRS9dt8VgXyXXDekeu9ADn2gXkLZXagejXDNvsJ0TCBX4qs4/i+gu+dDVbH6vatwz
	2L54VWamrD86QHml6mHdktjvQdS9bKwsNY74Fm/GMb5H0WCJT6Gtl7IdFDPFwjDzKW4NM+Pmj/y
	Bfe/PtmnFPO443mD4JhfK2Dj5s2Nbpx/S06igCW/GkOeccSRn+02FAlKrV9jm1B7Nuuiv0sSQho
	qkX8fRdXfkVf67OEQf3Q3r6z+CIuMHbKtNZ9gO49c493YHYr9XPrk1MHwHwGybaQXOvDTFRHpX8
	ZW//pSM5PQoV0GRjVoEenIzg60BmXmWlhal06geN3gX93PwC9VV1Cs67UE96Vr8cTYZhFEutRYi
	gw==
X-Received: by 2002:a17:90b:3b44:b0:3ac:c005:cf07 with SMTP id 98e67ed59e1d1-3adce08329dmr1117038a91.42.1792737289490;
        Thu, 22 Oct 2026 23:34:49 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3add246f308sm575202a91.0.2026.10.22.23.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 23:34:48 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 2/4] riscv/mm: fix hotplug page-table destructor handling
Date: Fri, 23 Oct 2026 14:34:26 +0800
Message-ID: <20261023063428.3658761-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261023063428.3658761-1-songmuchun@bytedance.com>
References: <20261023063428.3658761-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 024DB40005
X-Stat-Signature: 4pngyuanwpyrzmzpu9xbmrjoih9fxtns
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792737290-552535
X-HE-Meta: U2FsdGVkX19YNdiQNLQSEZZcBDg/u69EeHXOhMtvh48sZU2LZuQ4DhTlp7e47YDnweSo1ZXLe15yfQMubLYsx4mxY7MkBUKu0IRytYEMSsVuq8KsjYxiOb9sp26pnJNRYrpm6dapR9Q8TJS8iUc1lCBq0ZD6mQokDuqkzJwcbHVRaDFqcxNP2cMB/4e0I9sBrChj4i0jdE7MBSM4LqQKFiwUDkVAHILn72TYuuI4OIkDSHvVcdbx25tgklcIkx3D//C+NbDsFVsbcJkkAwpvsOU6s1Y7LVTQtpzsjIJkh4kbaTx+9N06yAMk4o6DdSeEdLeAJLmwscY98W6Kk5l7yndw1imvJTjlG3OyNevIPXHV6UIjE1Y0YWGH3kou3YPKMSnxkD4OKLvQAgdGL+v1PHu1iwOhL7IIMIhsHIgXWVRfNuTFiaB+hVRvIrQxrutrVK/7c7V50E3k6MRbGpiP8xUg7GeXaSsk5fvfLtOaviMo2z1OgQdhXIWdi878hOtBuB8DF0kCxKZvm2sJwpG/GeNjNTNXFxJczXytkwHuCUjCFEBIZTC6gonMqHFo7XORQPYCv3zbaIW7rBpvsDO3HUyuG7n09aucTgT2ILZhVLQdJv0vrYSxqScqg+yaXGtrc/SE1WfaBNxkcJd6qn+ivmQD5PsEWVjBYbHhzI6LHiZR4KKc0lhege4cA0ojRYjj1pz6CihsoLFuW/KUM0OuU5grY2iNEz8upgOu/WoK8YO0YfFJz9NdOgY2+DCTumfZrNMtL2Goz8hWaeOiqeSDMtyiQ9ZbKM/kXgspPo8JRM8RgCN9G9rZyLJYZB7eXz2NqPEQBBDLuGf9i3rBg0uH6nEy8Gtmigo32lBvHbi4pKawmbU9rEahSg8r8ZRehDeYew4nwU/9mgUt06Rh1EkG/LBkJQy3whDZFOCQ3gjLQbfqaCLMhy2TTZvy8unYCLRR47U5ILXty5RRNYmbQYm
 RJTIScje
 hlL1MU1EWWsxS75/ZrTriyE2AcXCpxsumw1JT8qCKeKqf8f9/xQUGqxd6DfWjjZZfER6pDxIxJbA4u/VAfoc9mKTyzInnTmROLYjSzjRTkj1dU+OJWrZaslzhz5tU3secd16ODzIDw3Vwjc2GuRDaQAPJM32H1LDuFk2nU2CSj1OT/XdpdR4Q/iz4PApLNw7+ZufXgFTZX90EuPgRVUx3AfOK2reS8kexd0q21PI+TxvZaMLhB64TaOBf9BS3Aeb3BlYJzOpn5o/ugZqbUKPVdU+Pjf19I99uSF7IuTyZjV8WEWF36pkubP0OinIBzngBuAv6dDS7kn8qbv9wrXD2i4tdetYjioVshsoZB6o2/tsygeaaHLrzmIK4hPH7rpWwMRBn+ijNQOtqYd1RkVUzBnVEy6c72HV+EaE51M8NmJXIldw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

RISC-V uses the same memory-hotplug teardown code for linear-map and
vmemmap page tables. Late linear-map allocations run page-table
constructors, while vmemmap and early allocations may not.

free_pte_table() unconditionally calls pagetable_dtor(), corrupting
NR_PAGETABLE accounting for constructor-free tables. free_pmd_table()
avoids that for vmemmap using is_vmemmap, but mapping type is not a
reliable proxy for constructor state. In particular, it becomes invalid
once runtime vmemmap tables use the normal pgalloc helpers.

Introduce free_pgtable_page() to select free_reserved_page() for reserved
pages and pagetable_free() otherwise. The latter runs the destructor only
when PageTable() is set, handling both constructor-backed and
constructor-free tables.

Fixes: c75a74f4ba19 ("riscv: mm: Add memory hotplugging support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v3:
- Collect Acked-by from David Hildenbrand
- Collect Reviewed-by from Björn Töpel and Kevin Brodsky

v2:
- Use pagetable_free() for non-reserved tables (suggested by David
  Hildenbrand)
- Simplify reserved-page handling
---
 arch/riscv/mm/init.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index fb37b0b67efe..e111d25e18e1 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1485,10 +1485,17 @@ struct execmem_info __init *execmem_arch_setup(void)
 #endif /* CONFIG_EXECMEM */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
+static void __meminit free_pgtable_page(struct page *page)
+{
+	if (PageReserved(page))
+		free_reserved_page(page);
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
 
@@ -1498,18 +1505,13 @@ static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
 			return;
 	}
 
-	pagetable_dtor(ptdesc);
-	if (PageReserved(page))
-		free_reserved_page(page);
-	else
-		pagetable_free(ptdesc);
+	free_pgtable_page(page);
 	pmd_clear(pmd);
 }
 
-static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud, bool is_vmemmap)
+static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud)
 {
 	struct page *page = pud_page(*pud);
-	struct ptdesc *ptdesc = page_ptdesc(page);
 	pmd_t *pmd;
 	int i;
 
@@ -1519,12 +1521,7 @@ static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud, bool is_vmemm
 			return;
 	}
 
-	if (!is_vmemmap)
-		pagetable_dtor(ptdesc);
-	if (PageReserved(page))
-		free_reserved_page(page);
-	else
-		pagetable_free(ptdesc);
+	free_pgtable_page(page);
 	pud_clear(pud);
 }
 
@@ -1644,7 +1641,7 @@ static void __meminit remove_pud_mapping(pud_t *pud_base, unsigned long addr, un
 		remove_pmd_mapping(pmd_base, addr, next, is_vmemmap, altmap);
 
 		if (pgtable_l4_enabled)
-			free_pmd_table(pmd_base, pudp, is_vmemmap);
+			free_pmd_table(pmd_base, pudp);
 	}
 }
 
-- 
2.54.0


