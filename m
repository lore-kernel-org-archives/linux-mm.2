Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56FC0C61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 00:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EFB76B0092; Thu, 27 Aug 2026 20:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C6F56B0095; Thu, 27 Aug 2026 20:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DBED6B0098; Thu, 27 Aug 2026 20:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 099716B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:50:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85A8EA2E78
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:50:12 +0000 (UTC)
X-FDA: 85148846664.07.F1BA6F8
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf30.hostedemail.com (Postfix) with ESMTP id E983C8000C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:50:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fcXHy+eC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3QNuQagoKCJU8I6DJ56IDC5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jthoughton.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3QNuQagoKCJU8I6DJ56IDC5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787878211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=M+L/jEThU+UMCGGhHnA2GUCWkP7cgtpwQVPowQ/g9e4=;
	b=Bc226IDZJ80o3CFSAg2bMwTYKw1oT7vKVfaLDlvoXISLp5E30JTtNl5LG3pYwKDS7owJEk
	IDbN4WoxtqbtNQKWN3+6ya1tNwVlLH/gMHYGOECMDhLKR/DkYnT7v+knHUdEWGATbju1cP
	0llPeIXZLWkyFn62CSxQspQPPkJxlf0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fcXHy+eC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3QNuQagoKCJU8I6DJ56IDC5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jthoughton.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3QNuQagoKCJU8I6DJ56IDC5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787878211;
	b=nxGVcbH4xIpIP/J5cMY4Aumh3Ap342p1bdu2euu0pOMJV/Knjf2e1yL2XvmgMCLiAhTEtx
	Rl+248DcfwTEvFXZq9QRL9dNG5sSGq9veNgYc6SGqNKrZTLRsPDy9CO+e8B9UjEqq6Brpv
	BWqUhm4JEVlF1sjBMw/0FkziBBmxiQ0=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc1b6f65dacso361551a12.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787878209; x=1788483009; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M+L/jEThU+UMCGGhHnA2GUCWkP7cgtpwQVPowQ/g9e4=;
        b=fcXHy+eCf5sgHYPztjJGjGNrwav1LbRakAbVuLI2IxIzTMedfrJC39G4JcQK2ZOvmH
         YJWqdxjnixbU8GlRoHUs4uLLis/WN/qwgZCkAmSAgO9YK9r2F9nCSUTsY55QWQAhX9Vf
         8TSt/4Eau8GP8tSguv/1ugAZjHSaqFRb9R/b2zZ4lMlg79q2Ff5if9PC9zt0sYsrbbUA
         6sbn1GYPbfeYHne7ndynbVEWHt84+CqNDgHF93pTrWfc0o2rhufYIxuCMaZzK1gdPjm2
         YKorC8ygbwsGCR2BQQe5HhQI/xaRvWLh4o/u1N8xB7Kn5366+OqrsmhQYWyNHMplrmBS
         D+Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787878209; x=1788483009;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M+L/jEThU+UMCGGhHnA2GUCWkP7cgtpwQVPowQ/g9e4=;
        b=DDCwt4AkN1rmn2VtyT4vrCuVJTTtn5eXP/GuRqnxVIUEcmbcAaCMCswFWsEq2m62yk
         b4eAUxpTFUHPaBvI+zxk3o6ivHrhptR6+LoOowwiHnPYnWSIjWQ3z+4yw+pAbgcAEmAs
         H6BSpxivrvsRvFnJ5AQpSGVX2jvlYag6EIk3469H5LMJzBAC8eAgeeHIdmSSVkgMTKa/
         8BWqtWQbYw4qi1odrHW5YqLS6lUyISPXIJa+oBon1cwQLzPKg9ahTk4ZUPUOVOQBiuyt
         uLnmDaWtRU++RJV0MxpYDOC0i+NKFE27aqqPDVNNazkKSfk+3bjg8Jk4RWvsXJqCGkVf
         vzpg==
X-Forwarded-Encrypted: i=1; AHgh+RoVEogFWTpX97+MBAnjNVR/fykMSYXNm4RnB6VLF7LJR1vTfO7QpGdLKNBAiNQ1VdvaUvMyCu83wg==@kvack.org
X-Gm-Message-State: AFuF++nsv5Bcg59CfZNokmX3k4EWX6247tTTo2j6W9cn5RUwb7bI1sma
	MoC2yk/1PVHS2qJMTAICmEUySCLIakb+yBqGskFGSGrQsN2M/amwvgULse2L1Xrb+7+bDuFdJht
	Cym5Xe2zYl5QuFe4OEjmDYQ==
X-Received: from pfaz21.prod.google.com ([2002:aa7:91d5:0:b0:848:7fd6:7dec])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:13a2:b0:82f:2b0:2809 with SMTP id d2e1a72fcca58-8562953e9d8mr4642983b3a.1.1787878208961;
 Thu, 27 Aug 2026 17:50:08 -0700 (PDT)
Date: Fri, 28 Aug 2026 00:50:04 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260828005004.2870750-1-jthoughton@google.com>
Subject: [PATCH] mm/khugepaged: Don't collapse uffd-minor-registered VMAs
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, liam@infradead.org, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Yang Shi <shy828301@gmail.com>, zokeefe@google.com, 
	hughd@google.com, Kiryl Shutsemau <kas@kernel.org>, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8m8ai1nrmdjeib8x3i7ow1pr8yttt95j
X-Rspamd-Queue-Id: E983C8000C
X-HE-Tag: 1787878210-955491
X-HE-Meta: U2FsdGVkX1/W3aR/W8RCVrZKd1ad1V0FYMKoDgiq53T2XzrvYhj4rfcUNeDghmoM1SSvfvnejiscroNRx8+O74nE0n8aMXxADNpRGbrYWJLQrIu9L2hJUba1w7wScWl+vehptc/nQu4/BVHNE0JiWdyGhpSLB6f0Dg+eMxwtRdncOLfeMeiEm8Ai4uTFpTyCa9xaeI2Je37B0Sj+Itcs+QBXAUJgUiVRYC/pa6OTpIXz+mQsR6cdEQINoDLqB2FKL0BpJCF/XvAl62FznP5UGsqEZ0kjYe1NHi6Et4IN0p1A6sfc3CTNW32mnGU1NknoRRSN8mu8FirUUOcsPLJ3HxfT+xQ0/AiS44uCFuORdRlcVrHwHOd/ELOGv11uBLdLhkQc+Dcbysix6K8Fkw5NSqzqkFKfBtFqncZNObN0ak+w5my/sKSrTXJU0m1yivJI/4TmnUhTEkAIM6MbR5pCIFlLlg/JLDksCGDsguOSFjtTHTihyrFAaBxHvHKtuKmIQsqJVIfdb5ubDQ4K5TqZ7W1eao6FCJCQKmEff2t3UccVjUGlfUwKAJ21oWdyZhDKjviwOCUGFKB/PLxiLi4Z1uJnOOanXrMwETtZUyq4R3kP4d4PtJFssWgVASswTuI5CAMkV+1sd76ZvhpHBZc7T8sM2Bk7bdFSIS3QXOmquPREiN0R72nE+IXcL1ck0t3tXbNNh7y53A3EPrhzpDTZqcVpJMmQA5tehDhD/RhR23CZh4SBd2iF/IWvVBXIsLZBMx+pG0/Mr8jDw2cJwjxzofCWUGCMkq6x0lg4Qy6HVFnHHqhMNmFWFPxwUvBg7EkBy9F//osx5xJvanhiqVzgmarKLChehpE0brxqLtsSo7PAFo48cS35rYfG6ruORIBoGKBHnerSFycjAjY+Op/3Xgo4NfAmvmlVxJAOELpQIhK9qK0z9AU5HpbDte6EEA+dOzM4H3qH1c4eRun09Qw
 iC83FWeN
 GhN28RMY6un3+V97nenFEY8DwXQDQPG00WWjviKogKbehpUIm1UFA459I2g8PK3j8U4KjftiiEnk1A6S2JfMlXKsI4ISKSeyXmf9Lgk8dmoKsuHZUkK0ZBdvtlDJQx/dsaDz7Q+hrqsOIh+4fl5Qpg+rusZo0HpEYRWcKVLcMv4RM1iXyoFu9z9vksi/J1if34va+uvXh2SYhaGEbGdvZhMi6FEGJAYrrDNVH1ZO6ClACC4NYZDyWkPgbiLiG8MY0yZp/oNkxbXNSLAppRhsBIsxBJB0IZJPQ48Rw/qnQQvkAcMVUuao7ua6t+H/d5ZNODp5br0hhJa6BgZOY6V8s3ZYv3tTlZkTxHo9kOmnsDObNSdmvUOPm5n+euIVgplR1YwOsXS6gP9zaPH+WnckqNTwZNFF+svi69oiiCn9uxVrAqrOPxK7zAE/MdlEM59n/wdW/RnWLq1xoZ+RQlcOBJlLwytETLv/k4wiuMgnMva65jA8GMUJz78akyKaCw4unmTR8ZDMD9V/NVVVnuIClZTMq2Td7B1aSLIw2ohESOwIdTVPRP92l39GztpL6Vnfden62XGzVpiQJb5iAXbPZGBA2hfDAV2oLa2xbh7jfIctFiIWlEuBk/1HrEe0OjXW/Y3gWX601Z4+guXObDeIXkA18uQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Userfaultfd minor faults provides userspace with the ability to manually
install PTEs with UFFDIO_CONTINUE. Right now, khugepaged collapse can
map holes in the VMA when a naturally-aligned THP is present without
explicit action from userspace.

This is a problem, as it bypasses userfaultfd minor faults that
userspace is expecting to handle.

If userspace implements post-copy live migration using userfaultfd minor
faults, this situation is currently possible:
1. The VMA for guest memory is userfaultfd-minor-registered and nothing
   is mapped in the page tables.
2. A stale copy of a page is present in a naturally-aligned THP (from
   pre-copy live migration).
3. khugepaged collapses the mapping of the THP, installs a PMD.
4. The VM now has access to the stale contents => VM is broken.
5. After installing the correct contents, userspace attempts to map the
   page with UFFDIO_CONTINUE; it gets EEXIST, indicating that something
   unexpectedly mapped the page.

The naturally-aligned THP case is the only case where this is a problem.
khugepaged otherwise requires all PTEs to be present for
userfaultfd-registered VMAs (i.e., max none PTEs is 0), which is
correct. This check is essentially bypassed for naturally-aligned THPs.

To deal with this issue, completely disallow collapsing in
userfaultfd-minor-registered VMAs. This is slightly pessimistic; it
would be nice to allow MADV_COLLAPSE to work if all PTEs are in fact
present, but that seems more complex than it is worth.

Fixes: 58ac9a8993a1 ("mm/khugepaged: attempt to map file/shmem-backed pte-mapped THPs by pmds")
Cc: <stable@vger.kernel.org> # 6.1
Signed-off-by: James Houghton <jthoughton@google.com>
---
This was caught with manual review while diagnosing a related issue
that came up with in Google's live migration testing.

I've uploaded a mostly-AI-generated reproducer here[1]. As long as
/sys/kernel/mm/transparent_hugepage/shmem_enabled is not set to 'deny',
the repro should work.

[1] https://gist.github.com/48ca/d399bf534158e80241fb4937ef1ff664
---
 mm/khugepaged.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b237f6e7662a..66f956d3dd67 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2804,6 +2804,15 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 		goto end;
 	}
 
+	/*
+	 * Userfaultfd-minor-registered VMAs should not be collapsed, as
+	 * userspace is expecting to explicitly install PTEs.
+	 */
+	if (userfaultfd_minor(vma)) {
+		result = SCAN_PTE_UFFD;
+		goto end;
+	}
+
 	file = get_file(vma->vm_file);
 	pgoff = linear_page_index(vma, addr);
 

base-commit: 26260251022fbc2f248a3d747a9b2b961b18d2d8
-- 
2.55.0.897.gb25b4bd76c-goog


