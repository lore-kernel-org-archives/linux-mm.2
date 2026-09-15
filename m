Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF15EC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 07:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150D36B008C; Tue, 15 Sep 2026 03:13:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103276B0092; Tue, 15 Sep 2026 03:13:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E969E6B009B; Tue, 15 Sep 2026 03:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0F476B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:13:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D9CF71C1F60
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:13:36 +0000 (UTC)
X-FDA: 85215131232.25.D7084DF
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf31.hostedemail.com (Postfix) with ESMTP id 14A1F20007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:13:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EHQ9HP4h;
	spf=pass (imf31.hostedemail.com: domain of orgads@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=orgads@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789456415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=velMxIt+642lquxYVKbrnSVvPRt1SpQzIuYolRQYJw0=;
	b=yn9Y+WnMWn0LtIPBDgLB7sNdYibWAUbEqlcre8qLtw9z3z2KiylVVxmRRazwRuTWNZjAGH
	9dGjgSzVzb47CvdzzsO9wF7wbda58rGKoSYf7JKLYToDn6cv660iJMvx+9ROWIGfkC3IoP
	JbBVwsvTWw5IkM06oE8uWIL6zxL8sik=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789456415;
	b=CQJoChE7aGlHX4jzqsN7jOXZffGXtFpWTz+rPpmWxDW28i/FUo5XLVIdcWdk6wsAtqQc43
	tJR6m2GThzpOvwKNpsx6jgNR8wo+BRAkPY46MfdBsL5Aj5xbglS3KlZHpiQ5G9zRo5AVKu
	1Xc4TdAnR1RSyA1sE3rT9Nd3GWbIfhk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EHQ9HP4h;
	spf=pass (imf31.hostedemail.com: domain of orgads@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=orgads@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49e6bad7b79so26302425e9.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789456414; x=1790061214; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=velMxIt+642lquxYVKbrnSVvPRt1SpQzIuYolRQYJw0=;
        b=EHQ9HP4hNFOd7ga7Xw3YdDxiHMXsPVxrhdg+pUTc6aM9Jixdfrrd/ee/NQxOjV3keU
         bB5lW6h49hPdrqY8jK3Bzp8XzGzfvgWACR2OVF6ubYBrndWsIrSHBkP4S+GrjIjEMKRY
         oaT5cReXt8TwFewWCuWKdgkDkyyBhW4pnWuu+Crk4PzHHZ5vQtL/jjrgGlNGLfywCXP1
         D6GoP/LJQwKwiPvY0y2Sik8KYvcXFvkWYXJBvcUEAtmcpMH5Cp/U8vrSBYLBXZFNk8PJ
         Z/S2lWFAlsX7m2XftJpHver+O/lAbUEMUp3tJ6Xuo9u3eCLa58GbMfQ3y2DRPqGRplTQ
         HNBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789456414; x=1790061214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=velMxIt+642lquxYVKbrnSVvPRt1SpQzIuYolRQYJw0=;
        b=w54bG9IJVbA4xupNgO/JgUhuCKMqNRu6OJnHanTQguyoTeNhj6zwG5VI91nD+cQm8i
         IehTY5ulIU77pjAiz5ramad0JVtOUCA++AiCssv4g4Z67yOsDq343YyCgbrz/qVqD8pU
         PrdAe+CEP1U3NKJv7DsR+7TOw2ujI0jJwzr1Wjd7nxSjMR4UhsOv/IJ00NjlhLNI4iq3
         W+XzZ6srhMjuOOZGRWO++sGBZFN5q545nICH8TqvMw7z84rq0sNRqHv2puSQM62PJ/z1
         TwsLtQGh/xqSJ1GWUEpLgD1ow4LOLayQwTXGn1HhKqJeyn4AiILvuDK+pN5qsEShC3TU
         czXg==
X-Forwarded-Encrypted: i=1; AKwUvBxsB2T/05ryF81fZG+T/7/mioSlE4bZXdkuxkeqDbnZE+hJAkAAFEN6yeLkwIxyRyUqs90KMV1wuQ==@kvack.org
X-Gm-Message-State: AFuF++lYizRW/nPkAUdkn+NL4OU3NLyygNq2HnfwUnJsUF54MHqMeDyX
	BidkzmisTKDK4L114Ij+VKGmpzrtu6Ga3A3ttEIogsZk7r1Wf7M8Sy4w
X-Gm-Gg: AYBFou0lr5vtre7aH+Z/Dwxhbim5ODbkmcWwy4qqP1K5LDNQowhF/Xv21c9sAyZabgb
	4ILO13jmhBaZL95zMgukRXhx+vfmPUhqNu25C4B83wOeKEX8XP1aLHDKT8kPC7RBWHuDyc1bujW
	3OgwR+Od5KXztm9hmthH0Ud1kDxMNYapYJ3Znqg4flMDjLbtPTMIzEptw/TA6tyRRl2XPQo7VXm
	Q+Uf+t269IrXQZsbmwt1PjlxkqqyuACNTGLQpBmRC17dyB4bT2Md74lu+kRSC8cOgRBYiDyPNwT
	d1BhuDmmaKRAydcCLvhvJ11l4z6xQWP97X1Z2poyeEcH8V9OJaUshakb+ClKL87q6GTOrUX0EXL
	3NyQvc3nFiR92A5+la41wXaz/n18/TBIzohE2+LvGZQrXRbrs3RY8Zybm3o6Xpyhrz3/hPQsZoN
	OCbd69pV/zBY09nUOPaxRtjQiG8vDiNXsdtQVr72sqm4gpE577dNXzK88wrHr/Z7S74oNLRiARu
	DJhFB3V4NvdySeTfH7LaJUT0hq8upEHqTxpWXHmDzeONILGdFzWNUr8CtzNwQ/pndGgdmXQkHJ9
	7heIeftlAaa9I9i+
X-Received: by 2002:a05:600c:4e4a:b0:49c:dc14:d681 with SMTP id 5b1f17b1804b1-49e7a63a784mr80413585e9.3.1789456412284;
        Tue, 15 Sep 2026 00:13:32 -0700 (PDT)
Received: from center.jhjvjihww5qejoy14qwv1cc4td.frax.internal.cloudapp.net ([131.189.143.225])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e7ef735cesm42941345e9.6.2026.09.15.00.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 00:13:31 -0700 (PDT)
From: Orgad Shaneh <orgads@gmail.com>
To: tsbogend@alpha.franken.de
Cc: linux-mips@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	osalvador@suse.de,
	stable@vger.kernel.org
Subject: [PATCH 2/2] MIPS: mm: do not write a huge TLB entry when the probe misses
Date: Tue, 15 Sep 2026 07:13:25 +0000
Message-ID: <20260915071329.15125-2-orgads@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915071329.15125-1-orgads@gmail.com>
References: <20260915071329.15125-1-orgads@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tz9q6u9aswwb6w4tfo13wztnxasdwm1p
X-Rspam-User: 
X-Rspamd-Queue-Id: 14A1F20007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789456414-9109
X-HE-Meta: U2FsdGVkX1/5p3qyT1Ugo1rbmsZmf4j/EJ0MWKsjf9pTtQ2jUHtwT1NUUYNhzbFitgNyv89SZL6CgkBPh6eALJg6gcdRe8ejA2iWyRlsqUadeD6Ok1NDMpIft4BUYrFKqY2sNM0NyPfytUywSH3wdMhkf7fJyRGXA3yrgy7QwUPaX2edND+NaXMdrsAU0gedQxsXIrryIg2Zy+DPSobtXXZKsCBuJ5Kow779FEqj4Q2bPoI8CgHqaeXCMMvA50N5gg7n/E2LuM5a8h1HGjnT7w2d74dXFqkYS9/TyZQ7RhWKuh0/y2eIYHZXDDKYzvglNUDALSPzSLYU6Z/HMNsUGVpsvJ3St6N/12ffyJIhM9UqNc5FcA+icv+kuQaJcvkv/Snd54r+a/NU57XoEJ8HLYRB98V0wYz7Hnxydq2H/1aLL0xpbDFos5iMNAeB7NqgeJrSCEM81eC17sywPiqrhnBG/j74kGuzQdG/RyeBz9mdUWJvfq7UmbczoWr1dEF8+/1n75xUuc3h+hOFFbE4x2Q3ea2o4PYnj5Ju8zVaSI4Ijw2nJR59UJkzDtnXgywLMx3ZmB14q2ODCTfsVkYwL8ueZ6e/ilGi6/f2cackOV/SpjtBN9Tn8JtQy+wu7sEBaMtcspcxUAYTkwBYCgtMGSoHVsI1bEH0+ngk0V3nf3abRBNXwl52QziQw3SEE8N7l2y+J4xKkwiTimIIEBP8yVIUjOWluN6h2coGi68yB80mV3uHytfwXevL7lFAVJQsbdojZRs9Xl44WRvbwOzvHhGhV2G3p7vQfRbOtLaYNntdO3sGkOHk4VB9/ZTarLSn3Biputt2AUe0Bh/aZ399cPpNZQQIFVDf1qDjZUl7Pp6k6TK2dkTJDukVjuFtfvZ61zlH5KjoAVjDiTW3fMNeYRoKB3eZkTIhtxl75vlgkmGUyZAzaWejz1XnUiO+9hsaX+6hrtqsOvazUgJ4bBZ
 6XdQ+w4d
 VznV+1Maim8H0HPMeuuc07x2SeXMq8fptb++t88B43Dn2fYF9dl3QYPxvnKCsKY9k2Biwno/LA+7/NplWsJBxj0nXtOez3DNezh+6F7QE7QM5XJTf+Ghs4rzzezDC8fs849XrlCaphaoZ+v8OZapF7PPpp2LeAjJB5Hb0Ux9eByxdCAYcTZO6MhhLKKnPcl3pZWT8dUczYVnyNC8x62c8QtiNkFK/QYxGkUw682HM/dk4vfQbIgdjUx6ZcVs9q0KpxvHLnWc+jKg/T2u6gW6TG2dZtH+Dj4tWSWSRed7x6FxtKnJWpjMYEfVxwERWRwEsz66cgLWdhi1ineGSeODfSSLDBMSpV0aloYgFrRHSbptqkW99+LFkKipkU5cUc8HxMMJO5282CqKtjvwFRYa1iVfoBhEdu5w6AuphnU3apPL5TvkIH99r3ZXGozWkmruOGmstCzS4t3Bo7fDTn73mRfPwxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__update_tlb() probes for the 8K pair at the address it is given and,
for a huge pmd, writes the huge entry with tlbwi at the probed index or
with tlbwr when the probe misses. That works only if the caller passes
the faulting address, so that the probe finds the 4K entry the refill
handler loaded for the faulting page and the huge entry replaces it.

update_mmu_cache_pmd() is not called that way. do_set_pmd() has always
passed the huge-aligned address, and since commit ebcfc63d6bca ("mm:
abstract THP allocation") the anonymous THP fault path does too
(map_anon_folio_pmd()). The probe then misses the stale 4K entry, which
sits at the faulting page somewhere else in the 2 MB range, tlbwr adds
a huge entry next to it, and the TLB holds two entries matching the
faulting address. Octeon raises "Machine Check exception - caused by
multiple matching entries in the TLB" on the next refill of that page;
a process on a CN63XX board died this way within a second of start, on
the first anonymous THP of its bss.

Skip the write when the probe misses. The refill and TLBL/TLBS handlers
probe the faulting address themselves and rewrite the stale entry with
the huge one (they also set the software young bit), so the entry is
installed on the next access at the cost of one exception.

Fixes: fd062c847a8c ("MIPS: TLB support for hugetlbfs.")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Orgad Shaneh <orgads@gmail.com>
---
diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -332,6 +332,19 @@ void __update_tlb(struct vm_area_struct * vma, unsigned long address, pte_t pte)
 	/* this could be a huge page  */
 	if (pmd_leaf(*pmdp)) {
 		unsigned long lo;
+
+		/*
+		 * The probe above only covers the 8K pair at @address, and
+		 * a huge mapping is installed with the huge-aligned address
+		 * while the refill that started the fault left a 4K entry
+		 * for the faulting page elsewhere in the range. Writing the
+		 * huge entry to a random index would leave two entries
+		 * matching the faulting address; leave it to the refill and
+		 * TLBL/TLBS handlers, which probe the faulting address.
+		 */
+		if (idx < 0)
+			goto out;
+
 		write_c0_pagemask(PM_HUGE_MASK);
 		ptep = (pte_t *)pmdp;
 		lo = pte_to_entrylo(pte_val(*ptep));
@@ -339,10 +352,7 @@ void __update_tlb(struct vm_area_struct * vma, unsigned long address, pte_t pte)
 		write_c0_entrylo1(lo + (HPAGE_SIZE >> 7));
 
 		mtc0_tlbw_hazard();
-		if (idx < 0)
-			tlb_write_random();
-		else
-			tlb_write_indexed();
+		tlb_write_indexed();
 		tlbw_use_hazard();
 		write_c0_pagemask(PM_DEFAULT_MASK);
 	} else
@@ -380,6 +390,7 @@ void __update_tlb(struct vm_area_struct * vma, unsigned long address, pte_t pte)
 			tlb_write_indexed();
 	}
 	tlbw_use_hazard();
+out:
 	htw_start();
 	flush_micro_tlb_vm(vma);
 
-- 
2.47.0

