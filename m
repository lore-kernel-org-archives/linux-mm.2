Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68AD0FF8850
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 06:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49BA76B0005; Mon, 27 Apr 2026 02:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425496B008A; Mon, 27 Apr 2026 02:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 319CB6B0005; Mon, 27 Apr 2026 02:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A84D6B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 02:37:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9AD364075F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:37:43 +0000 (UTC)
X-FDA: 84703380006.04.A7D0F06
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id D282B12000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:37:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ePiLT0wj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777271861; a=rsa-sha256;
	cv=none;
	b=FubYvzMzHHtL3Xl2Adrp15NmaPXJ+MKlsYb8uGHTnKONlwAPlOYvGarSvYiKhR6OSvUAJM
	lIFONNK877rJ0MXj6sTXEpSk17QMT52WYSHjRxZMZ05gU8mlLEyUErH2iRfZrmwfkHOTix
	RQp8MpT3aRvDV+Wf6UVBkjOi/F3g38M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ePiLT0wj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777271861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=571oaXZgb1cM9wv4JKckLJbRvYiZhpmMD/AGdOnoXi4=;
	b=VKoYIhmKZWjj8mocGaqfNGd6r0lE8aH7Bd5ck4N6FHPy2D/U6hqxdh2smtSChq9BSQXj9J
	7URpxxbBQHp26u7LDBgQfPXQkbozahLVsW2MpSMHjCW2IL5WFqfKmBE8hYt4xiuaXxZ2+Q
	udmjrC+8Fmj37AjEElSeWgfnNofVs2E=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b24fdac394so94591425ad.3
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777271861; x=1777876661; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=571oaXZgb1cM9wv4JKckLJbRvYiZhpmMD/AGdOnoXi4=;
        b=ePiLT0wjsVJtAoOuXQ2FHCfkFI/mXFAVSoGenHUXZA0IPGD/a8O6cba7FZwJVnMH3j
         +j3b+y+RCYFRIBttn+fUOFuFmA8NfaFPMjQLE4FhxvDn79MWHsePDc0tCufozpJ/VLKU
         NbbnqLt0v1BaQ2Piq4Wyzq1lPsAnjnozbKICy4Z2F+pJBW2nkoeaRWAneJCeQwxioLdG
         u++5cpwVn8Yur+tWReSXJQqyG/iMAH0jyew5br2wqEzHiQL+brI/hFn1GXQlEdXXhgGI
         dXuw/DtY6+UyVjoLI62n0f7UlbEQ0dQKsxKLvf6ops9DBimz54sYZWw4ce9LfT+d2y0A
         MHwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777271861; x=1777876661;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=571oaXZgb1cM9wv4JKckLJbRvYiZhpmMD/AGdOnoXi4=;
        b=DQMJiHCXeFbMFnfoUVkqK7LPyazns1YGw0Q8myuwlBhl9OTo6NweTXCVOW4wBr+Uzp
         SK4ms6wCYFrM57Gj6SISVFr9CfuHlMUSd9SkFUepZOMEbgaFCYXUX0PqMO9wCTozcxH8
         rYNeynwiTHUI4+cahUED8jUdy8SFi2ojI5we1Yzp4Z6oHXYmZdsCJ47lr/zu7n+Dsnqv
         WQ/sg30KlDc9SBY0b3G0Y7I2TL/5iwMfef3mmIYWUuo5WnuPwGMEowJPH41qcttgiRVk
         chcQSVj/mDKXQvfJOXj9h4fuqA4oXsghGm95v1dzchGNV4zyl17idgy/5BT0P/GP5Cy7
         jKeA==
X-Forwarded-Encrypted: i=1; AFNElJ9R+UT/JagxnRm1EnZGUIACB/DK42flhlQbrp7LclmC9svAWsq7cA6ba2tJhxwAGRrkmCgzsbE4IQ==@kvack.org
X-Gm-Message-State: AOJu0YxfcX2A1iqp+XXbZDlmijlM5bde40VohVQdVxTsMrJ04QSeTkv8
	SXM/HOyTvTpvxtubawOUG4Gd/JqLZ6VJLxiL7I/KAzFhNZWI7UvP56aa
X-Gm-Gg: AeBDievL9eRSF1yHDhs441U23jhJhMUCm/YkX6DpJ5HH+jjwDXXqymKfszaLiG4U5jx
	0hg3K5yh75/Ko+wFwwyW3/3PpTLgs9mzHNLx9f0VVVlkbLBntz8QGQv6Xsh0ofDPmh1rH1EDt/C
	FYpjMChv7c5Qc+lVaulxADi3Ymx1SIOXTQUp6/EJi2ktmz5ahJfa1qqfoiCLUbNLeYNUAmAQEIQ
	eS/+aJQfc3y4tGTNPHjPDsGH0RO65L3jxtEthwrQKh7xW67jyQT6Zw+SPuHTZjHTqPtQT+qX0ko
	mdBY+1F3wXj/vbWc9pqOQakcH2/xWBym7vZxTJSCfIcAPtcDLvE9eaNsNSTwtHqN9oTT29nT3hl
	/3osJ2ONXaCFZ5k7LnIRisY8nKd0+nGedVwELha7JVV0r93gfx3r2zxw8v7zN6C6PIUUVrR7c0m
	pYg17s1qO7F5hl102InhZpsZJ/a1b26FtTr2AVW/drGd4wHfvHCNZPFXrl
X-Received: by 2002:a17:902:ce0c:b0:2b0:51f6:d46e with SMTP id d9443c01a7336-2b5f9f009b2mr451730915ad.15.1777271860705;
        Sun, 26 Apr 2026 23:37:40 -0700 (PDT)
Received: from tech-Alienware-m15-R6.. ([122.171.21.105])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0db13sm315231825ad.53.2026.04.26.23.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 23:37:40 -0700 (PDT)
From: Sunny Patel <nueralspacetech@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sunny Patel <nueralspacetech@gmail.com>
Subject: [PATCH v2] mm/migrate_device: fix pgtable leak in migrate_vma_insert_huge_pmd_page
Date: Mon, 27 Apr 2026 12:07:22 +0530
Message-ID: <20260427063729.17294-1-nueralspacetech@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ysdc3e6i8kztxz1jxuqniqcsbwg3pi3s
X-Rspam-User: 
X-Rspamd-Queue-Id: D282B12000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1777271861-781937
X-HE-Meta: U2FsdGVkX1+MAx1P2S2VG+xXuTwbkC+lLwCdfH1lvR+ZVxDOndIIom2RK2xJRWrrc/INOLvX3cFTd9PEv/rgjkV7SH/ERcOODAzD0omsNIgC1ptBsNYeE8/0vsHBxNeHWjvG/FpqBo+et0nPS0rL0uGXX+GXsUGkgobzLz9b3spHfRzQXuUQSGfyggWBqhQ2EKGsLXULpU13JdUO0sXPH9kpbRYjXF6JJopx3lQGuuJj94DjEDN1c2edd04kwfSFOxfjzUniEE77W6ULw6i54NbJyczfjlGZusR4RoGJNjepSV6Hob7M0T6RLNm9NEyXHGlCoUPeBN3Oaq3P3/VyBTkwIqNLPHArmxvVhP1yAguDUkrnzztqGlXhD7fJEJe0RzPcZezq8kocL5kBXNxcmvDYXylElgoFShNC/s6a1MQXREoO3dd8+0MyB06SvP1zNqKzMJQUtnQfyeBpkiwoDbSj+PoYW/cCvZIXX5VdiMOFr32L9uh7d7N0erSdbUuzFy7Ay5QEjZHi+jJK/CePo2SMZxyEwVwcsLLi9THK4IlEMym+pZancKS+VNKDzZMlvrI4cdU6ZAr1kd3c+UlXxgJCYqeiCE8uhyUEwJV8nzUE6G2E0TzEwzyuaNP3u0yV3tZ1J3OrsljuX1OGkSSE75aXZj68A/+13Bz99zuyecmHPgGsGoZwq6N2RD/bJAWIEOursppdIFo8RMvmn5z4TLtLkNlu4V2NvVmqLzLfBR5GwHaauz75I5q51gC7wslwkNt7lkRcp3tX/L2BwUDpiLaNAeD68Eme8foaZfheQizfZPHUx+X3rLUyhlovGP1YCNLYm+vS9NDEzY2IGK2I3/aVelfOosB9ZZkb9Z98eLO2L4lueLAV594dIfEA4LN5U3UlJIp43i0Ku1JFRMAGLrKY9kPi4fSHUkLB4rXdjo2PisNEEY248HL9JEJz+/4sWHyCkH7pMgwVlcIXokh
 4FNxfQaA
 Gl76f83LbnfKUKw0CYHBjW6Mo7dmUQsghSbiiYIlyo44ZWwvqNWM3+lDE4mrp2zKf/rIFHWnOrfIqmDs9kFUpunLUZVrPLcWH7ZxM5HaMWE3dZKgMhIZCo3y/edACiDy06oQMHMv2zAoKnwCP9ZOY7mITYPVawgy3Pkpee7JQ7M8LAQYfWXlAYs81q1xP2mMYq/yI1oG/+vyEdDFc0qXRQauAcEZicK+/+Oso9NiCTYZVXFhFbF7n0os5jlCd9FTYjG9CKW6ihjviq2YzOTuXIXCS1L+3ROoFQQGI+fLwLiiAPSbKiKo+zvAV3ISx4v2BpJB17w1jVxbg2PLIWtfO6gH1egqB6yd81DA1vamTrqHzL6s/vqmdxFYtFc8Z5DRvGzT/3GAuzIVBfWCTORbaBc65hRh854LmeqHK5QFy6Epoojlm3JC6Yl7jO/8GPdwzwWsB3l69KYnOn2CkaLPJiUbUch+cJh5u4VCpnVfPX8Hl/W+OBbbzOKps+uJU2T5Nwtfokrdw6MwVZV9cA8nUD1NaVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When migrate_vma_insert_huge_pmd_page() jumps to unlock_abort due
to a PMD check failure, the pgtable allocated earlier via
pte_alloc_one() is never freed, causing a memory leak.

Add a pte_free() call in the unlock_abort error path to release
the pgtable before returning.Also included before goto abort in the
folio check path.

Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
---

Changes in v2:
  - Added pte_free() before goto abort in the folio_is_zone_device()
    check path. The lock is not taken at this point so goto unlock_abort would be incorrect here.
  - v1 only fixed the unlock_abort path, this version fixes both
    leak locations.

 mm/migrate_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index fbfe5715f635..7e132196856b 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -840,6 +840,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 	} else {
 		if (folio_is_zone_device(folio) &&
 		    !folio_is_device_coherent(folio)) {
+			pte_free(vma->vm_mm, pgtable);
 			goto abort;
 		}
 		entry = folio_mk_pmd(folio, vma->vm_page_prot);
@@ -893,6 +894,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 
 unlock_abort:
 	spin_unlock(ptl);
+	pte_free(vma->vm_mm, pgtable);
 abort:
 	for (i = 0; i < HPAGE_PMD_NR; i++)
 		src[i] &= ~MIGRATE_PFN_MIGRATE;
-- 
2.43.0


