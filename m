Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89D07606A836
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Uu/tERdF
Received: by kanga.kvack.org (Postfix)
	id 952FF6B05BA; Tue,  3 Nov 2026 05:17:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92AC66B05BB; Tue,  3 Nov 2026 05:17:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840A06B05BC; Tue,  3 Nov 2026 05:17:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58A876B05BA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:17:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5414801EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:17:28 +0000 (UTC)
X-FDA: 85393405776.30.2006140
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id E7A4BA0003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:17:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Uu/tERdF";
	spf=pass (imf25.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793701046;
	b=y5qrfDqloqRjXDSthNXNx1oNfnO9U/ZY/DKwAgLf31vM1h1WkCwAL83Vsct+cWTJhnDFej
	W5yV990KxCnfv9MAUxeM2SCxap5QfcSiODz1PbFvuwdvIKHMxugOs2ImugtgaVqRpOLMXH
	K74EKZflsQfNlu2zC/KNPWmGjH9wbQE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793701046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+SJoEqsvZ+TRv506SN0uWYqGOCHbvZTF1hg+QTdNQpA=;
	b=vnjRl0Y0W/pmnbqDETuUXWusACi1aIOcElW90EAmDsqGbaIYqIkkiKFE/KrgWEnv9VuanH
	iLKrBrnOKImMACeM+34K4LVh2iA8hnGYYo2p0nKsalghPvlGTlzGBbKtCjoT0u1Vthlhil
	0cGGaeif4DHrZyPW9WMFG5UHtt1fceE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Uu/tERdF";
	spf=pass (imf25.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-35c76e9614aso5490807eec.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793701046; x=1794305846; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+SJoEqsvZ+TRv506SN0uWYqGOCHbvZTF1hg+QTdNQpA=;
        b=Uu/tERdF1VF2MlXO0QJL16mhzMXjYVqNzXeSvDG/SFd9KcjYcwIi5ZmpNuZ95CKyXd
         J1TK9WTYxa9xmNzNH9OHetFsHcBynhZTdXluRBDVc78iuurIh/wPnTRw2k7ffjzR/xfp
         HHciJuHBv13vtrE78O21Ma/0gfBQNxg1mVlsdVc5z4x+LUOrksEuguUTVZTRFGN4+htz
         0tG7snvfEoHECj/iyCxW9cnh2YEuIFdYTd8czHz5BEYmUd6uiOb6kAXGj+MjJYr/EPNN
         sax8HZfQEK/XHIcMTIYKp2LgezLPZciwYnlfsyofO21IkOOLbMj1Tb+QdUVm/WSYecjt
         V4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793701046; x=1794305846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+SJoEqsvZ+TRv506SN0uWYqGOCHbvZTF1hg+QTdNQpA=;
        b=e3E4w9NjKaJ0x2Jbo3f+nRTvKG/VUE1B9HxrninJdfVfl5ZtqE79sw0A129W/TPF4W
         xWs0SxT/t3XkGpVXSgG5rMNIoCHcCvQggNocsPaXBdDDFbxDp1xAa1oiFJkm9uo8CGRS
         +R9HvcF4LVz8kHLjp0sMMe8YspeWXbKvqBmRMn0oOIM6YOK5FkSTVArO0G93JYQfYVfs
         LJRPTVekd6Za1HXOw3NyxnVbe2WU9ASagaESOPTgli0hJU81KIaWSI9A1bA5LOBTlCcL
         v459Bqle+DMjQIEflcsPme1gkLat2lg00meqwOvDYIghRMPksN9Z+AHHB8STnDq1i1YU
         DV2A==
X-Forwarded-Encrypted: i=1; AKwUvBzwmi16U2DBuTW/N1wk2CnF4/hsOndcWN7coNPepPFommF2+feEwxccjFPhwbZDZGtsXRAOOi8bKQ==@kvack.org
X-Gm-Message-State: APuU4Z8gJ12fUtRJZnxcXMUNS5VpJJE6u8NxTOe8IzR9aizO5sBVwdvX
	467/buZJj8wWNAN67FHxKbGAsD4TB0Ajxj6vHZwvYrwTVpHy/kWplPrT
X-Gm-Gg: AYBFou1Fwr5aeEubTB7MCt900dbYfdEHRpDwzFqkjOkpwzXleMeDMVo2NIcmklaHw1+
	579jyT0WI0N4n0uExoA05ZtLLdpl+jl99CpUCiqhfnRMzAPun0S51Uy9vXwGCzX2QUBQPJEBwxF
	NEvxnhsMvyMa0V1uCC1xnVQfVHvZTFpkaUXEMhbKwdmRxEEUT3CDhD4nbnSClDEaRDpXHEzbBY4
	6/swZg8e88ltcPLkBepQZV+vdwVcs5ivXaSUGvHylC88voZmx0F+xDGnzRwvXYSh1nsPxopx1ZE
	e9Bv/Ik79dofquCS7kwabBNjOW61kknK+K4SLtsGXPKnqKQYlq7QW2eWecpmZ9NoWoBj773fRi0
	wRxaTukF7c/uEUj8LENCJXe3YesBrnpVUrEkFwEVF0e+WXeODxtqjzCeyL7SUDETRzSsmW30bFv
	JOJg2DLdAgLsUwkVEXd5vQmaZRvWPBZm7gQNRtuha6G+Qm0wPBHeAJEDWkiZM4HeyI5oma0AbNk
	QESiWCjEo+/VgLKFS+17ExFQkI5VfAO9OdkRRCcm5sxw6NLx/QrssLQ6WgsIV5Guw4PcVHNTg5m
	1ehKOWMEzTWfYc19fkvz291Q1QxQQg==
X-Received: by 2002:a05:693c:894e:20b0:368:7c9d:1577 with SMTP id 5a478bee46e88-36a4238420dmr18800136eec.20.1793701045554;
        Tue, 03 Nov 2026 02:17:25 -0800 (PST)
Received: from 027.. ([2409:8a20:4a5:7150:84fc:ce3c:7b09:dbca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a4291e38fsm53145387eec.15.2026.11.03.02.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 02:17:25 -0800 (PST)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v11 02/10] powerpc/8xx: add vmap_pte_set_huge()
Date: Tue,  3 Nov 2026 18:16:50 +0800
Message-Id: <20261103101658.766905-3-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
References: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: sx6r8fz1jsgt1jyjykwr11idwigs3tad
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E7A4BA0003
X-HE-Tag: 1793701046-512830
X-HE-Meta: U2FsdGVkX19KkFU6JR0pF3KmtXIuTOHzq0GCBAntqHTZybCxR08BI1gHgZ/R1sERVr2l22C1TvRJO/KQzTWiGtBXLZ/pXRvgLgJ5T1iH4v1O+gOwjZYfiSfcsWuugeJamrOhLIviLfDZS+voHGEnRhocAxoHxmaeSY5UiL8lAySfVF/6tjrOAGjgiGQwjJJIThrQrAO3QT0+MKBCMPgAKz+SOBufWLcY0IoUgcy9pRr23tWLjXtxuoHaRvcxCnjn8Jmh6G7wE0LZ5XfBHbGufVCl+GA6IC3ilth60ZeSUOaHLajGO/cdIgH72YkqqOtvFLKOzAdyWfMVQb2dO9R10bEr0fcKcguR6DZVvsPDxstn3dGXwEjMjcG/Z7c/2mB2K3WqM2jKLRyhivihqPOeuSOxVRZ6MlqIHo5PWh50bvQ6U5yzKUj8nDfRbZzzc5Rr5WBELUSAc4Cxkrxr7fcE0eb1tTZcHRKj+z5kjWNsWozSs5KgMNnxBO2e3ZsxDDxVdbT6COfIxX3/KGc0Zzp7T4CXnwGqssV1kBtDIa1624iFEGXZ7uOuJO6uE9JuIiBj21ZrX63L3SIh5DXvvo+xfjk1NvwzUwEg3o02H0ol7AQ5nZOfGD0nRWA0qF+k0fIwb4Ue+TOcxrGKr2Nm9JB28lxFy1P02XtLNIY9XmQT5pezEenwDAJTWkdZKQ49XGk/mSDKDxZZGNEFneV+oyDN9T9LGtAOpr+4Q4anKFNCfC+anKTU6bsSKI3BqsH4WwPbNyYfs+LXKDeS8Zu+eBbjpsJGlKy3LeAHsv89Iroox8bEUsyIFuYNVpy8ZTryfXzgKzJ+d0PAkG0KbNoXdjmM1zD5c53k5Qmf4t85068mdr3YLEkcOys/l2fbZ8fM1XKuZxFXWqaE6GsjVaYbTAYEnRE1u9qEg0+jvgzWaJuPJ7l1P04gX2rJWc9YrlHiNPnMzRVZT/e915SEv7PlZJh
 K4oyLPlN
 kbAJZBq5zzloK9WSwVbzl6EZttC2Kk1xQoMEsqs80kgtXQMmjk319gYnaksw8IEWknXA9/MjHFFNQb79TY3iNhyAeZcut+bvDelAU4AtPQThYrWcK1bQ6Z41RgD24JjuhO77TteLJ1K4O522wVCjl4ydxPdWBMiGlVGDnVaz0TrgkCtfab7C8yLbQMRssMXgBbO9OfKAijsW+MJcP4+RHCBbvXbpM1t3RWCMr5Ap9DK/5uUIPJv8b4xeYqt2HkYmZRDbyOeAqL9Ir8JfTJnjy+gB9lO0avGQbxFEZgTizYDrnhsii0xQcvWfQ3qC/VixMu404O7wtZz3uV8aPxpSvtvCUTf1cXvpTEONJzy1owXOCwW52OEezN1/F6as5SHhIddg3XJbIjcAJGMXLezd2ouC5PjaJOXbZlnTN7WEpJs8hx6Rdssd8EO/ItjT1WuR/nP0h1NjxqDjvakj3rBdI5b9SM1gypqpmbAOTE+RTVePhVSVMxQ+wleI1ZQNa33FF5J2s02+yzaNxBnlBXiFjCyX9dTVQjQqwrS+kYHE8kVU1RjdfLdjpGS00sQpXyEhLjV1MUzUkVuJr1SIfwvRJ8dk3UOd/tTxSezEu5of9dpLtmbwIaHSNpGLSEwH7cbfGWzObCt6kLfMsuGc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wen Jiang <jiangwen6@xiaomi.com>

vmap installs PTE-level block mappings (SZ_16K/SZ_512K on powerpc/8xx)
by reusing set_huge_pte_at(), a HugeTLB helper gated by
CONFIG_HUGETLB_PAGE. This makes the feature silently unavailable on
CONFIG_HUGETLB_PAGE=n kernels and couples mm/vmalloc.c to HugeTLB
internals it does not otherwise need.

Add vmap_pte_set_huge() to powerpc/8xx, next to the existing
pmd_clear_huge()/pud_clear_huge() in mm/nohash/8xx.c. It builds the huge
PTE and writes it into the backing cells directly, without going through
set_huge_pte_at(), so it does not depend on CONFIG_HUGETLB_PAGE.

No vmap_pte_clear_huge() is needed: 8xx does not implement
arch_vmap_pte_range_unmap_size(), so the vmap unmap path never takes the
PTE-clearing branch.

In practice PPC_8xx selects HUGETLBFS unconditionally, so
CONFIG_HUGETLB_PAGE=n does not occur there today; this is a decoupling
cleanup rather than a new configuration.

There is no caller yet: mm/vmalloc.c is converted later in this series,
once the generic fallbacks are in place.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
---
 arch/powerpc/include/asm/nohash/32/pte-8xx.h |  4 +++
 arch/powerpc/mm/nohash/8xx.c                 | 29 ++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/powerpc/include/asm/nohash/32/pte-8xx.h b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
index e2ea8ba9f8ca..6ea854d67a2e 100644
--- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
+++ b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
@@ -235,6 +235,10 @@ static inline pte_t ptep_get(pte_t *ptep)
 }
 #endif /* CONFIG_PPC_16K_PAGES */
 
+#define __HAVE_ARCH_VMAP_PTE_SET_HUGE
+void vmap_pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		  pgprot_t prot, unsigned long size);
+
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/arch/powerpc/mm/nohash/8xx.c b/arch/powerpc/mm/nohash/8xx.c
index a9d3f4729ead..54254182700c 100644
--- a/arch/powerpc/mm/nohash/8xx.c
+++ b/arch/powerpc/mm/nohash/8xx.c
@@ -220,3 +220,32 @@ int pmd_clear_huge(pmd_t *pmd)
 {
 	 return 0;
 }
+
+/*
+ * vmap PTE-level block mapping. Sets a present kernel mapping directly,
+ * so unlike set_huge_pte_at() it needs neither CONFIG_HUGETLB_PAGE nor
+ * set_pte_filter() (a no-op for non-exec kernel mappings).
+ */
+void vmap_pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		  pgprot_t prot, unsigned long size)
+{
+	pmd_t *pmdp = pmd_off(&init_mm, addr);
+	pte_t pte = pfn_pte(PHYS_PFN(phys), prot);
+	pte_basic_t val;
+	pte_basic_t *entry = (pte_basic_t *)ptep;
+	int num, i;
+
+	pte = arch_make_huge_pte(pte, ilog2(size), 0);
+	val = pte_val(pte);
+
+	/*
+	 * Make sure hardware valid bit is not set. We don't do
+	 * tlb flush for this update.
+	 */
+	VM_WARN_ON(pte_hw_valid(*ptep) && !pte_protnone(*ptep));
+
+	num = number_of_cells_per_pte(pmdp, val, 1);
+
+	for (i = 0; i < num; i++, entry++, val += SZ_4K)
+		*entry = val;
+}
-- 
2.34.1


