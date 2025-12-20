Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07BDAE67481
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 20:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461AD6B0088; Sat, 20 Dec 2025 15:29:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40F366B0089; Sat, 20 Dec 2025 15:29:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1966B008A; Sat, 20 Dec 2025 15:29:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B5D16B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 15:29:33 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A8FC98B3E7
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 20:29:32 +0000 (UTC)
X-FDA: 84240989784.27.EB8DC15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3C7A81A000C
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 20:29:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KlzGev4g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766262571; a=rsa-sha256;
	cv=none;
	b=Qy8QzkDWlTEFgUyKmbhrU0ljUXw4d1c8U40flq/+9mrxx7zhxYFdVfsMeCvUbB4GWRA1ZJ
	yh8Zc7KQ0VmlYCWCWm2ZP60jqEXKzjXwtpMInA4m4tEUQhZyC1Ud8WeISQDjapoEN/ZCjD
	ZN6GT0ogpwLfdWMA3YXaeXvLNjdFEas=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KlzGev4g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766262571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TCQLw37PZ+cDl0MYK/GRAaX4EJ+/No2Dw+ZsxIWPNpw=;
	b=GVMW7BVkpUO4ZXJL1ewBXPq9f9NhwxEkztYxD1HFF/wuf+QzH7XmHPD0LCDr88eNbK+FYt
	GPjEQDEz4eQzf44pQD0yQNPg7d8Pb0gmUY+efiBByTsmGAGK/Q1XYx41S+2yfxSOVSiMkw
	gQ1kb+/pfIeaD47NDUK3Ux4GfOT1M6I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EDA060053;
	Sat, 20 Dec 2025 20:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CC6C4CEF5;
	Sat, 20 Dec 2025 20:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766262569;
	bh=3djAmIY/bVZRGmdUxEHr+Zlvw5SAngNGjsGgg06NI6I=;
	h=From:To:Cc:Subject:Date:From;
	b=KlzGev4gP45f+/xC+1UTrC3rgFPVQkqGxSimB3iSE6vnu8awn62WEKEfZtumSrnMJ
	 o/RitvRyR7pqNC8ZPX/VhqbpHv9CzTFypt+oOEwsYC+KeUo1wjt6T68RQBihAVL85k
	 9WNptPhsVsT+6tuBqfZbtpKIikPccd15iqUXcJFu2eRbtUUigMe4JOYlXGF/VUsIx6
	 cEyN4jNEzFPOy2F5CZi59YcVRR+bO8M+U4VX2shuigZ5IKOYkCmzyRmjf0IFLs5zB7
	 ldVlqVpm9cVfK/oamhWyOYHTiWfdby5wIujPQ1vSNCMzs5oyTUBU6HpyRzmtJF7g1X
	 4AdVlTj0+jF9w==
From: Sasha Levin <sashal@kernel.org>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	pedrodemargomes@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH] mm/ksm: fix pte_unmap_unlock of wrong address in break_ksm_pmd_entry
Date: Sat, 20 Dec 2025 15:29:26 -0500
Message-ID: <20251220202926.318366-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3C7A81A000C
X-Rspamd-Server: rspam03
X-Stat-Signature: ueqyku7phxjqb7iqtkoquxa8net8ub1h
X-Rspam-User: 
X-HE-Tag: 1766262571-486923
X-HE-Meta: U2FsdGVkX1+0PfPAk1GsMmX0fqFE//ZtkCYAIUxLud6IgBZdMT3mGK2uI4yH7AnN5b25oKqrkgA5Hwt29c747aU3xQ7w7HdawUTlhq3+Np43Sljk97GAhIciOgNS1EQgFiawpp9BZFCKMaka1ekk+sEnL5xHeNUFzpJdk1tBouRijGYb4g72aTLpd9BnxnKBsj0E6UXaLAaS+Dnn6x+YUVi0KCcz14XwsEphALhlO5H+2Fu/fggRF+NNagC6BnyRSoSg3UkRVfiiJRSyu4PtxU4zjRBMpiWmNY5e3YEPORpjbiBm3s61oyrccvqIj6m4v41L/RxvnQsowgsPo5AiiiBvjDhv9vrc5ujUkZh0+hfG+s94grKxH2V5D89Ts6FsT2P218lb/Oouis/GcDaLR5P6819cqgqq9lU1tO2PCHrBFz4V7DllAcIWYIpvq86iVVY/VOAZr46ZRQ8R/KOxCTWOzVf+1FYeYCChmHOEDQM8vuOthvPcP2PKHCAz/abG8zADjPGbGDlakBYU7jwx5UwwYc2dxmCf0fyGNRKIgXXjIR113jnlhdDVrDUjLxaymQv75P2TlaaQ7s3brX4/7msnfNee0K4WbIbU8r6B2q9CQ2ovTEV+UZbcai8x+Sq9ehR6dzqwxkcS4JytiJ7gi5wXLWMsQk2rj5WRWXuqiGxsw0yY4ECKCuaxPVCpv2qeucdp5IL5mhOo7yM6dCg4SH9f1MGyvnQTklBWZGowu3Xc71y79E91AWm7ashgvJoUICDPFVr5KYcc0C9G9qyqNRHrlYMrr/O7k5YbELSkMXdLmdcxoxZR7IHkgxdeUViwKFRZMvWhlqMGlCKtoIba16RvEfPQaE5GpSAOyHSpoNsueAHZc35GpbdZ4B8wTyk29MaLSDW+FbEFQQzgiGKulAuTxQ5V2qhxMFgskzAqC48u/cYYqZHZSBcLe4znedSYd9MWC9U47TJszL5+CN1
 c+iB3pQs
 F2vKkVILzqlM+p2G8aKaSfVo3t6YUSaoN8xdIODzaodr2ItQfNPZnXxj5iVbWkNHNocaz006lccdVSqVf8h+yVm2KOQWVU+7QsefzZt30HUQ3PbM01IE3js/UmvF3lZ5Ikghn+8fmjL0mtd2ad0s0efjLrreVOJ50y55qE81Fkd6gYmiwUuEikWLPYZ/0XcL4+aMAhSbJqG55/GbwdDQWvlucUR5Ab/rLHVPY3wQ5dCwuan5S9IvuwQ0UC1a6VZYr/PLYabKxxkfUo2Nae4Qss5VZqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On ARM32 with HIGHMEM/HIGHPTE, break_ksm_pmd_entry() triggers a BUG
during KSM unmerging because pte_unmap_unlock() is passed a pointer
that may be beyond the mapped PTE page.

The issue occurs when the PTE iteration loop completes without finding
a KSM page. After the loop, 'ptep' has been incremented past the last
PTE entry. On ARM32 LPAE with 512 PTEs per page (512 * 8 = 4096 bytes),
this means ptep points to the next page, outside the kmap'd region.

When pte_unmap_unlock(ptep, ptl) calls kunmap_local(ptep), it unmaps
the wrong page address, leaving the original kmap slot still mapped.
The next kmap_local then finds this slot unexpectedly occupied:

  WARNING: mm/highmem.c:622 kunmap_local_indexed  (address mismatch)
  kernel BUG at mm/highmem.c:564  __kmap_local_pfn_prot  (slot not empty)

Fix this by passing start_ptep to pte_unmap_unlock(), which always
points within the originally mapped PTE page.

Reproducer: Run LTP ksm03 test on ARM32 with HIGHMEM enabled. The test
triggers KSM merging followed by unmerging (writing 0 then 2 to
/sys/kernel/mm/ksm/run), which exercises break_ksm_pmd_entry().

Fixes: 5d4939fc2258 ("ksm: perform a range-walk in break_ksm")
Assisted-by: claude-opus-4-5-20251101
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/ksm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index cfc182255c7b..2d89a7c8b4eb 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -650,7 +650,7 @@ static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long en
 		}
 	}
 out_unlock:
-	pte_unmap_unlock(ptep, ptl);
+	pte_unmap_unlock(start_ptep, ptl);
 	return found;
 }
 
-- 
2.51.0


