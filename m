Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94452CD4F38
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 038858E0026; Wed, 12 Nov 2025 20:47:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05178E0014; Wed, 12 Nov 2025 20:47:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6ED38E0026; Wed, 12 Nov 2025 20:47:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A95AF8E0014
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:14 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7CDF01A0730
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:14 +0000 (UTC)
X-FDA: 84103895988.20.069A70C
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8E04BA000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=m30R5Vne;
	spf=pass (imf25.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpe1iExYP0zyH90A/cjYKaPPTKIVrHTbjuAaN9Ted2E=;
	b=Gq8tcRAbC9tWmA7Qwytq0xEJvoc/pFdCZkfNhsFkf53hXBaAJGZaM1OR3PuEiLd11+FLy3
	8HBwtmr5zNECLaWArGk8DrhT9ui2z6O+zDNGimZ5Duf5zPIJv3onC4HQ7T+06Vq9HStdyP
	vpaY6jvSTpX9HpERMHw6axccc7coYz0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998432; a=rsa-sha256;
	cv=none;
	b=5ZoE2CANcNO1joZyBV0WQeMQb2HkGdvl7faD/mv4Of9qBjMnYfjskjxTsESWLNbfPgESjM
	aW+tbn6CR36HK/dO2prweUcW4XVcIMTsA1pNDQh2nNZI8yicX6N0bT0t7zjwRtQf61PO9Y
	ds48PJ5nyrIVYBNbbRusi/9To1NrFRY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=m30R5Vne;
	spf=pass (imf25.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-bc17d39ccd2so161748a12.3
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998431; x=1763603231; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fpe1iExYP0zyH90A/cjYKaPPTKIVrHTbjuAaN9Ted2E=;
        b=m30R5VnemHPRn6EuRrjpoUO6zjs42c36ms1MDBLHFLJ0oWHlRnWWZZhQ8WnVZc262i
         P5RtUoM24klHp0AT6HPA2TK8UGr83XjD1jbi7Qh/FtrurkZ7mwdfztj0zaQjXuB1Kpl/
         +9S+IpKW99lEn94WMfflIIhXnWYfVS4POkk7RdAPpyuumxiH3pDHAa2yERZTZx54AwEV
         cpaklDjKq53WTjbUILFyaBWzDAw7rilzOUFP5lZsCOEHGufzhPmy5BdPttZn5srKRrUu
         IOyakbERynMZei7oyDJO2W9JRcjMTmEEAiVIA32FzdtJbB5VF91vGTjCpc73jyTyJ6HU
         TTDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998431; x=1763603231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fpe1iExYP0zyH90A/cjYKaPPTKIVrHTbjuAaN9Ted2E=;
        b=fmZNDdfezmEg9zuT6v3G9LEh4l/GFf6U4B5Ru2qqYzGlKSVetgvYOD7S8aod//M4Lq
         8D2tZRdox/8c3TxXUBCp+NJ5kRQDxl2XmNTxoSsyzwrUpQPHzqb2fWJpFSqz72WwtcyV
         zA5jrWl5TXp1yswnUW/AMzv6AgkSTnE29NTspmhujhIHEQmbit/Ofw1srXwqnQScyCUk
         KPGyn2+HyiaNFUUBpuUSPEuNVrpIc74bE5GA3ostdEWwWmFRZTRbGUeaECr0Pjbn+WGr
         dg6wiEIWIChrdKXj/JiXjW5Iqy8wn4pf9iFLDj3d0vvr2LY7vYlGPnsxvYdQJSNJ6BSj
         QOYg==
X-Forwarded-Encrypted: i=1; AJvYcCVPwZHDM0ZIEEu5CIlbzZmCj7G+rJs9NwErUqJJns2jF2Jd7Es/U/9dwz/RhVzWhEVwCVzXars2XQ==@kvack.org
X-Gm-Message-State: AOJu0YwJkdBuOQ3Kv6ZknrzwVskKR8dSFl65nSBqiKCN1Q6LqoVztGd+
	jvSqoWSIyzh3S88nh5NTSxls0cb3d23370dpEuK9dZe3XJx+j3ZZkluHuCzjRoYI+68=
X-Gm-Gg: ASbGnctS+0J97EXGwJtF2z/UVC4WRx0KM20lSpz4g3labx/uJPAPnqtbHMH3n460iGf
	h6REaGknt0Pd5IIcdsfxTe18WhazEBLG1bIGbyy9oBWSbrJK7BiZNNyuX8qGuqc3E4d5x36WcJi
	vAtpAr74W+acf07d/NCCRmgbX+zy2T91GFnK2MdEbku+OvJgvBpyMbaukwSpMxY7SvipAC9Qav5
	AeRSlea9Vffy4g29qFtRy2s2skdkBD2ND219o579BEpodRzT0/6WqjG319vxEnnQsPIZoa3mjc8
	qkY09y4xAoJG0t9bziDzn8MR98uS5WxXBt86BrK25SMpuxANrNDwllOsAVx/LB5+c05XMONWZvx
	8ad2+/0SbXpFqza1tqi0uUvFZm/ioquCnFZfyiV7GmWIrs2dhv31daT2PlNQj4VysIUol3MbQIn
	DP9qRG63+9r4zlAbiv/aEa3A==
X-Google-Smtp-Source: AGHT+IHfQlkxOaBsnfDtOhaN9Eg9wG5LhwHH/6CgE2hK5xO5V/1h7VmoyWUWgcNESoHw3XrIzaUDgw==
X-Received: by 2002:a17:902:ebc7:b0:298:481c:cbd4 with SMTP id d9443c01a7336-2984eda4101mr66654135ad.26.1762998431452;
        Wed, 12 Nov 2025 17:47:11 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:11 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: devicetree@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 08/22] mm: Allow page table accessors to be non-idempotent
Date: Wed, 12 Nov 2025 17:45:21 -0800
Message-ID: <20251113014656.2605447-9-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E04BA000B
X-Stat-Signature: jycfp4qkne65cwsojpthh3nho6goe5nf
X-HE-Tag: 1762998432-821975
X-HE-Meta: U2FsdGVkX18OeyzkDN4/1tKQIit1DojiWa52y1u62x+MO+iMscsYvQK9HdzXmTQ0c/Ct4icLs/fkKGq7/Tg29vAZvGGfcLwAd6G1YZBeA1V0c9ZV0TaVLi2nMfSIcSaRx8x7dXh0PraitoympGm8qBD1TTdjgI6A3wM/WAc8e0s4cQBl+DUWMRYyd7om7sttX9ok1+mpNOYwsccBRX8kG+bIDoweVtQmaS8A/G3e1eQ56OyHi97j9FNLk5Wc1rP+qO3QH55N/YefPa5YYrpF7y/1uljidOdKgBr/ou4G4MDwU7GuWklAFdpbWcUogY/sESt+i5uz9GjklnLNvNIWhmVO3WmG4vBPyQY88zlEj7z0V1Jp3yV6uwPikPur6k4EQlHjylJ3v8f0afAcLPdimOKgYvI1WIqX/vmJhr6Vbg/I4sDtKDpF7GEi3PpiGyVXmnnGiVzH1B7QIbujsevvO1nsf6slvmN1LQXqdws6sjGTEChev6LBQ74u4BriaqG3RbAKumEdLUG4BEWTlWg9ZzQtef77MVzWXcqk5hoMnfsjxOznbQHVEQ2qJjpCVbDNOQSDv8GKeNuQO19iXwya10iOVhisP6fBrWGqZdoBGoiqgnnDyZiv0M4lcJlMPK3lJRbhVcd5bDQOw0dlXNnAfbTxYtI02Lp4xHAg2GmC5gQKoetIJ027WK8eSo3pKz6YDZ1K5bucybUnwXLb/nJOwEu639v2uEYzWd5iWdruj2dEGwW4/Mw9dnOsCkqOFlqrUiN9UqHTPP4Xs58iDOdc5+NdUFYuBhTAGTN7b/f1S0AuNaDaybTzGsTwg+eXSigf5GVMwf3A6buQdyqqTa0RTkiHZylQcTtp6QC9tgzR79E+xrt3A6Ta+MC+rmFeg5oY1xw10QSmmB+A/B/tfqSdN2gDV0HJHQJ0a6QWlNy5bf3fiJxZWd0dJsgwdVSJ/lUlCWG8bXVaVOnFBPC4JZb
 rFmCWCuk
 eDWEWmlGg72XEAwyPUUekQ/rhbi7RrjJSBDLM738iDN9rVOme/CS34I0K3u/0EAD4jBBbbKsbu80Xz+X1SFUC7auMPExkNejGbVoANzWjGGx+v3qhrfXBMOI8LxiCLGDHQrSqGDrHiTFLgGnTsN+aUj8ogSbi9tOWf/cyaTCsgcjwshtclxSPECXuWF4I+CS08+KTRH4QgtGp2zIDKic5wMPC5EUfoj/FpKTJdpYac1jsEmPpnm+WFs59L0IRjc4k3mzikG+kTddUH/uYtWiK0zPX38a1vvxoUfo9/rSVfMZ97SU0aSSb8jqAKM+sYvL8wg1Z+1QbqB0hTQrKq8vhjBHU2Y6qijTHS1ptrMRZlZSrGuxp7TDLUbsrtmM/DsqVhRcBtF6diy3+Yt+GmESTsKkrayK7itXKPARZV+izs2E/T6NcSVWcXuBVJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, some functions such as pte_offset_map() are passed both
pointers to hardware page tables, and pointers to previously-read PMD
entries on the stack. To ensure correctness in the first case, these
functions must use the page table accessor function (pmdp_get()) to
dereference the supplied pointer. However, this means pmdp_get() is
called twice in the second case. This double call must be avoided if
pmdp_get() applies some non-idempotent transformation to the value.

Avoid the double transformation by calling set_pmd() on the stack
variables where necessary to keep set_pmd()/pmdp_get() calls balanced.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

(no changes since v2)

Changes in v2:
 - New patch for v2

 kernel/events/core.c  | 2 ++
 mm/gup.c              | 3 +++
 mm/khugepaged.c       | 6 ++++--
 mm/page_table_check.c | 3 +++
 mm/pgtable-generic.c  | 2 ++
 5 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index fa4f9165bd94..7969b060bf2d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8154,6 +8154,8 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
 	if (pmd_leaf(pmd))
 		return pmd_leaf_size(pmd);
 
+	/* transform pmd as if &pmd pointed to a hardware page table */
+	set_pmd(&pmd, pmd);
 	ptep = pte_offset_map(&pmd, addr);
 	if (!ptep)
 		goto again;
diff --git a/mm/gup.c b/mm/gup.c
index 549f9e868311..aba61704049e 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2844,7 +2844,10 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
 	int ret = 0;
 	pte_t *ptep, *ptem;
 
+	/* transform pmd as if &pmd pointed to a hardware page table */
+	set_pmd(&pmd, pmd);
 	ptem = ptep = pte_offset_map(&pmd, addr);
+	pmd = pmdp_get(&pmd);
 	if (!ptep)
 		return 0;
 	do {
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1bff8ade751a..ab1f68a7bc83 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1724,7 +1724,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		struct mmu_notifier_range range;
 		struct mm_struct *mm;
 		unsigned long addr;
-		pmd_t *pmd, pgt_pmd;
+		pmd_t *pmd, pgt_pmd, pmdval;
 		spinlock_t *pml;
 		spinlock_t *ptl;
 		bool success = false;
@@ -1777,7 +1777,9 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 */
 		if (check_pmd_state(pmd) != SCAN_SUCCEED)
 			goto drop_pml;
-		ptl = pte_lockptr(mm, pmd);
+		/* pte_lockptr() needs a value, not a pointer to a page table */
+		pmdval = pmdp_get(pmd);
+		ptl = pte_lockptr(mm, &pmdval);
 		if (ptl != pml)
 			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
 
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 31f4c39d20ef..77d6688db0de 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -260,7 +260,10 @@ void __page_table_check_pte_clear_range(struct mm_struct *mm,
 		return;
 
 	if (!pmd_bad(pmd) && !pmd_leaf(pmd)) {
+		/* transform pmd as if &pmd pointed to a hardware page table */
+		set_pmd(&pmd, pmd);
 		pte_t *ptep = pte_offset_map(&pmd, addr);
+		pmd = pmdp_get(&pmd);
 		unsigned long i;
 
 		if (WARN_ON(!ptep))
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 63a573306bfa..6602deb002f1 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -299,6 +299,8 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
 		pmd_clear_bad(pmd);
 		goto nomap;
 	}
+	/* transform pmdval as if &pmdval pointed to a hardware page table */
+	set_pmd(&pmdval, pmdval);
 	return __pte_map(&pmdval, addr);
 nomap:
 	rcu_read_unlock();
-- 
2.47.2


