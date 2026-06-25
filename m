Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 171D2CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CCB36B0106; Thu, 25 Jun 2026 07:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A4646B0108; Thu, 25 Jun 2026 07:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFCF76B0109; Thu, 25 Jun 2026 07:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAFA66B0106
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:30:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F3F31A0660
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:30:41 +0000 (UTC)
X-FDA: 84918217482.26.3B51995
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9FF6D8000D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:30:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HRZxSSoC;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782387039;
	b=c5efXHGVniVID5fxs80Na2kPXGmYZaIUe7qGJGjkXnUiLyZnc5tzDBrXbBkVWloQc437jK
	BNgInrRLFxrU10ygamtZDxPGLpp8uAwMbN8KopREByqEVwQJRBqY4J+QS8pzxM3/WSD6G3
	xcdtRPAfD9X6ba9viFCoF/LuTb9JHSE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782387039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJAkM7J6odxLVUNMRb88bVGPgUIhyfXf46ygYs2AIjE=;
	b=k5wC1Zs9dQfcWvyircPA5U8ZhNMOF8VUUjIbrOhmQr9bRy84aWQ9Rl/xtHvQTIfF6qPMTK
	NEdSPSXqsvSpjpatyqIOQfylZcxnVyg1Skl5QFTg2d8maoc7hm3OzW9SHcl9liRUzAf/sI
	j6yCLi/9m9149eukxlj7h5Jtsr6y/4M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HRZxSSoC;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4547232AD;
	Thu, 25 Jun 2026 04:30:34 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E0F3A3F62B;
	Thu, 25 Jun 2026 04:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782387038; bh=JOkyYoKGZVws+y2+vmN9YpBtKEwEn/j5yavI9jEFAmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRZxSSoCdsFKyHQSKFqPXzo5e1bfb1d0NEPHf3RMNJajp0QYStiKg/Vgbi2YEH6yW
	 ZlKHPkn3b0tpmJUQ2jnPfVaAexLjTsDpyaSxTnzsHtlNzCSyzg7/zrcXoAXYy+aJy0
	 IYrPDR1Ax3981AssSUlNsanBGRqoHg66FQ/kJPuI=
From: Dev Jain <dev.jain@arm.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	david@kernel.org,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcampbell@nvidia.com,
	apopple@nvidia.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	mel@csn.ul.ie,
	nao.horiguchi@gmail.com,
	ak@linux.intel.com,
	j-nomura@ce.jp.nec.com,
	pfalcato@suse.de,
	dave.hansen@intel.com,
	tglx@kernel.org,
	jpoimboe@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH 3/5] mm/migrate: use huge_ptep_get() in remove_migration_pte()
Date: Thu, 25 Jun 2026 11:29:52 +0000
Message-ID: <20260625112955.3254283-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112955.3254283-1-dev.jain@arm.com>
References: <20260625112955.3254283-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9z1kwkiuz7o4jps3pw33g8zamhz93os4
X-Rspamd-Queue-Id: 9FF6D8000D
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782387039-813029
X-HE-Meta: U2FsdGVkX1/JbDNFSlXUne1xTedQV7lgVI43T7OkmgybbYRdDhFLhgGOaqBWfHw5Ghp5NbVIMBamlJuAhZmMX+SP0tB9N+JA89IjY5ja5Nzjg33rEoCFQJu5Uv5BuA4AoCMjlEC1nmqVWPzEk3D+RzCz8V5nyumAt4waVzlce6UNeQRGUgsqtLDkJXsBeZipeQSi189v6wVrONSbWGe9f5DhwXxCKmt7nzHBoZFvocGfZ7t+UTGHmRtrCmTgGPfWnt+WKaUtXW8mZ+wRDqczk84d7Kbuwegnk8COHKlmexhBbCWZDzDVKeRXI1Enj1XMLvqKsfOu2HI6d63I1qoLTh9nxWDhnCHEH9goOlu26xDKZ4l1H3kIlKw1mDNzmPaQOjL/r1zef6UQbWRjvNFk49QmUJFA9yN/xffmu8eNXL14eS9Mi48d6IY3H3VVm9Rbw/mCa1Wp9K6WtBgBT+Us9Ji1egexnqDftua5tTx+HwIyqgmTxOlLNIHWMjDLSMrIrWlpvEHCbHqGHyVKvdlKk8z4G8dcpdMWAPIU2g1F20wmfhPG0w8h8zo7en6239iaRno45DAjqcmV82u/oSNXVzcYX5ujjVZ1lTro9ZMDScxZ9jQYwWmmBL7A1Ry3mWIkeZyEuM+yVI1VpDUEDCnm2p5qQpqi5rTNHMj+jF7AQzmNpy6vJrEBc+/1ToAnANxiP2Sr4HK51LNgHWPaSLWs2H3FyTSIjJCNXCz9AMpImHCROHxDFSjzNjv9govvKTKdJEyTyDGUw4FslZLPbwt015VdmRohj+LgbtqcwkBOvXZu8LTiOgdwmrdiz6IrZUoHvy1Qh68HrTdvYTSOLwNtMZyIFFdXYKhb2vxJavgfMhrPRYind/nXQIS5oGZpzFno0vr7kdK+4tB+OXwMN9jTEZGuEkjSVG/V4ebJSOoBoN/g96Pi0JGiZwIczjlJIhcOOtK/WhbOdWqEMQ+sUvp
 nHJvyvFB
 nLO6UrSePBKHOm9irhK3Emi3WjKJHIE1oU5ZeqRygVGHIPsRSRtEIDff+s8CstZf4o5NaXT894FaIS0E9zHkpHpxhMXpgphAE7EEWJkQy7addK/t5QUy/wtG6q0fQOUA873ANMvFsk/D29ydFeGBVsjmZXq1Ov1U2xQfqC/pHGCyks4NgeJ5y0cJlzY/95pJxHoQ37Afs7L0BHtBg1TIDyHJ/zV1IqZi0eCBL81nCDuHjMaUonf61W53XpGKTjOzuOUs2j6PTZUAKgGZpcGjBiGZV0zzrG5SlhtPqYGCMYcQ8Jiz+jehlv+kaUnkl4NyTWm712PmDRBXTKL9pkukOaCO4IKniV6KdruAAplNep3yyj/m9ui0+Ce0FOrGklzqqke25moFmHI7bSaU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

remove_migration_pte() converts migration entries back to present PTEs
after folio migration completes. For hugetlb folios,
page_vma_mapped_walk() returns the pte pointer to the hugetlb folio in
pvmw.pte, but the code reads it with ptep_get().

On arches which provide their own huge_ptep_get() to dereference a huge
pte pointer, accessing via ptep_get() would cause pte_pfn(),
pte_present() etc to misbehave.

It is not clear whether this has a trivially visible effect to userspace.

Use huge_ptep_get() to dereference a huge pte pointer.

Fixes: 290408d4a250 ("hugetlb: hugepage migration core")
Cc: stable@vger.kernel.org
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/migrate.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index d9b23909d716c..c65f0f43df7eb 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -371,7 +371,11 @@ static bool remove_migration_pte(struct folio *folio,
 			continue;
 		}
 #endif
-		old_pte = ptep_get(pvmw.pte);
+		if (folio_test_hugetlb(folio))
+			old_pte = huge_ptep_get(vma->vm_mm, pvmw.address,
+						pvmw.pte);
+		else
+			old_pte = ptep_get(pvmw.pte);
 		if (rmap_walk_arg->map_unused_to_zeropage &&
 		    try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
 			continue;
-- 
2.43.0


