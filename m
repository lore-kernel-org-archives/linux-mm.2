Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 442DC606A335
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SNX3cDEN
Received: by kanga.kvack.org (Postfix)
	id 65C706B0609; Thu, 26 Nov 2026 06:21:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633386B060A; Thu, 26 Nov 2026 06:21:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521FF6B060B; Thu, 26 Nov 2026 06:21:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E94F6B0609
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:21:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B433D1A0DBA
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:21:35 +0000 (UTC)
X-FDA: 85477029750.29.178EFC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1BB51A000C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:21:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNX3cDEN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692094;
	b=BSekzp9lmRkRme7np4JVhkK6qdPKHd5kS02Z1xhbjlHGNpSYhvSNoabxpoTLQlD0nYWvfD
	kavUMghfBh1WC+Dnhng/xNjIPH+pX2SEEbp6BcS3kFSb/L6TjUPPrsHdzgc6jZyOaxMaYn
	mZ1I39/x4Q85ElFXsLZimNSxLklh+rg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vigwkAWRONvzPByx/zhPfJ9SVHH2ehEcBxoq+qTMC8E=;
	b=BvFo0gMVewLvkcWzXBEIfOZNmOeDvn3i+aUIWYv4DTCJw6FxJ2xTRuAG5nlsG6Y3UhiBCJ
	eE6qP7klNWSd7682YaaanZnE8m9uHPskR3au8m3DWgnrqTys9pDK0aPY2XaVq1Q7U7yFGm
	Gk84BF4W/p5rm9un/lNw63sMClBQoKc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNX3cDEN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A569C6338F;
	Thu, 26 Nov 2026 11:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734441F00AD4;
	Thu, 26 Nov 2026 11:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692092;
	bh=vigwkAWRONvzPByx/zhPfJ9SVHH2ehEcBxoq+qTMC8E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SNX3cDENiO5DzlG2beALu6yElwtfAJXpHrvTqpxO60LzbbVU27yDaIgMMSFUrC3qK
	 +gif9ob2GHrwxtQZ2uGiKiYmg7Dy16SvDHGHzdFUsr1dSx+qMH8iVYn8rJD5ozxCDu
	 ZLenCOZbN2Wt7s8cZ1jwGUELsfeht4miRfQl7N/J1msWxoJt4085AIm4mT+Ff3Hjww
	 0rvY138mhTHgAPV+UhUHEzrCijrGWuVoJt3D8ag2qDG35f5eTy1vTkHDWY+1GMsIhv
	 Z/IC6JEKsjS2y2gDXBkm1BfHhyIJPZCVGsNCbFMHzeqMQhFUU9ScTYCUcWKZiWuLGQ
	 jEz1spOt2dAIA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:57 +0200
Subject: [PATCH RFC v2 44/54] mm/pageattr: derive direct map counter
 updates from the level sizes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-44-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1BB51A000C
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: dp6jqh376sh5kru6g865pwyjyb766byc
X-HE-Tag: 1795692093-224779
X-HE-Meta: U2FsdGVkX1+qZ+rsiqMrrQqCvbpHkfxL5EoYMvWd8ArN7fJxMA7/oyNBxNktnjgBb+/AdoeJq5bAvku+ZnZVen6ABm9TZpgEXkYOBn48iLYTuNIoi5y0kzTQ7kN7CCpoEhcpRJ//AeXZY03I8EvnaDmNae32MBpauTJrBVrVUy+/SEJtvH3ZUZMzlsMu0rpQHJ0Q+W2agqCLUurPJacj8NPwSc9E5N3aZApwNHgkzulZRuNW9lF5rUdXdkJTPtDdtfwx/sEAkf8NpoIT83T0T+W66BXt8INNH3EeQKpOKtKrznIQkblIDJ2yYwxhYsxAZkdyfhvfyrKU04Lp9FIOzLib9L4SciKGHAVd7bJAXiRFv4cYDvxt2+yiibCxM1nCtBz5LdoymHfhRseO442I1It7IVFc+2Qnc9bhc3BQHyoADMoB7TcZD5GerBES71wneG91FlfUvupehX/Ct/hfgQrFQTW5IPTnT0EYphXkTOxwSVj2cgqwI3tj8Jt1I6eODCk+j9dS+LvxDYSJT7MqgbXX+uK6dbwmEzl6NPck3ZsNRp3N22bIXjQExFCy2dy8S265nGNIIYPPO/dQ+nehBdtpi/jAWevZSCuUKqJZT2xZB5qlgIQZr3YhF7yc8/9dGHQVIxFVlz7mzZPqDHJ6Kibzpnqe95+9ak/xe2BSCDuy52DjR5I+MecCcLBji/mJ0ITiwwQcPHFP4maAQZavpkjs1CgaFUWyuruvoVJ7tftObM86CTFMya165gnQ6L7nLZwSYKFIhTmtW09HjSPjdedIrjKMDRpAkFasgLhUNawcpb0EGDDXuXZZl8keHlreFNrhB4pixSRF1eLkQ/yrEVotL5xlmZ06Prq8MumboDuXF9MpYsorINxh5pQ2W61wkH8mi9bdtwouLhK3O0ZlpdXs6nUUXwe8tI1RaSE0P+nOz2gyrSbT6rcIgfi9RKB/jBvGdwV9i/0eKcE3Jlq
 fTNQEhiC
 Lfw/O0SFFCCLyI/gRnnEvOTVMed+8ZlsNDw5b7YIxomPtOkyL5PNoU0GZtrEl7bTKQatTTYzs6LaWRH5IV8Udmt1G9X/jTyiw2cXyTzogHYcjeqA4yBPH3vIvqTIlF1DnwffQAoro7CrmJCas+lwxZ31wN0laDBy/7CpRzFUkqIbhqTJSYQYdW4U4eKF1cR+ukxqy9VY92hNs67SUmmHhosfbm+ey89IlZhnvZBgt/3gkhYyk63S0Oob2kpZhcXTMlqS+mhD1vM3TREh6sIJ7EXGIJUMXU85axBzIL18Kz+W9klq0OnzOE36c7oYPfxLRFeJyj2i8GVske/qhOBAEY7TRQEnGsyuc+j4Wq4qlKHILDpwchhT+/19l4df65GDCFl9hqXFZX/t6TCIDMsozKufVYd/qkfShIGalLFqi7YvRgV2LBVIG8/uV9xddQu5lD3+riKeNHvBCcnw3tfUQbdgX35SI+msu3vG1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The direct map counters add PTRS_PER_PTE entries at the next level for
every split.

That is right on x86, riscv and arm64, where all levels have the same
number of entries and PTRS_PER_PTE is the same as PTRS_PER_PMD.

This is not the case on s390.

An s390 segment table has 2048 entries and a page table has 256, i.e.
PTRS_PER_PMD is 2048 and PTRS_PER_PTE is 256.

A split of a PUD mapping on s390 would add 2048 entries to the PMD
counters.

Replace the hard-coded PTRS_PER_PTE in the counter update with a helper
that derives the number of entries from the sizes of the two levels.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/pageattr.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/pageattr.c b/mm/pageattr.c
index e05281a2b169..555e55e7ecea 100644
--- a/mm/pageattr.c
+++ b/mm/pageattr.c
@@ -48,6 +48,11 @@ void direct_map_count_update(enum pgtable_level level, long pages)
 	atomic_long_add(pages, &cpa_direct_map_pages[level]);
 }
 
+static long nr_entries(enum pgtable_level level)
+{
+	return pgtable_level_size(level) / pgtable_level_size(level - 1);
+}
+
 void direct_map_count_split(enum pgtable_level level)
 {
 	if (atomic_long_dec_if_positive(&cpa_direct_map_pages[level]) < 0)
@@ -59,7 +64,7 @@ void direct_map_count_split(enum pgtable_level level)
 		else if (level == PGTABLE_LEVEL_PUD)
 			count_vm_event(DIRECT_MAP_LEVEL3_SPLIT);
 	}
-	atomic_long_add(PTRS_PER_PTE, &cpa_direct_map_pages[level - 1]);
+	atomic_long_add(nr_entries(level), &cpa_direct_map_pages[level - 1]);
 }
 
 void direct_map_count_collapse(enum pgtable_level level)
@@ -71,7 +76,7 @@ void direct_map_count_collapse(enum pgtable_level level)
 		else if (level == PGTABLE_LEVEL_PUD)
 			count_vm_event(DIRECT_MAP_LEVEL3_COLLAPSE);
 	}
-	atomic_long_sub(PTRS_PER_PTE, &cpa_direct_map_pages[level - 1]);
+	atomic_long_sub(nr_entries(level), &cpa_direct_map_pages[level - 1]);
 }
 
 void cpa_report_meminfo(struct seq_file *m, unsigned long levels)

-- 
2.53.0


