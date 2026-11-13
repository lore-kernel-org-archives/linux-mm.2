Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30970606B1CA
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Iolwc92g
Received: by kanga.kvack.org (Postfix)
	id 4F63A6B060C; Fri, 13 Nov 2026 03:39:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CEDB6B060D; Fri, 13 Nov 2026 03:39:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3B96B060E; Fri, 13 Nov 2026 03:39:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 12B046B060C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:39:46 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD3B11C091F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:39:44 +0000 (UTC)
X-FDA: 85429447488.15.91DC0B3
Received: from mail-pj2-f0.google.com (mail-pj2-f0.google.com [74.125.227.128])
	by imf20.hostedemail.com (Postfix) with ESMTP id 092421C0005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:39:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Iolwc92g;
	spf=pass (imf20.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559183;
	b=lu2zqJnpvfg9tqWbgvuMRsEiwJJFwrshwODWlK0k9F7fJSFjShoTqRTJwbTUQvBnhbW/to
	OePfpMwmfTGX4J6NoeUkSaSeVn+hmwUSRETOfRHAvsfZvhP8mUsxV9QfidMm0tIC86HpCO
	xFr+0vruZzQbp0Zifx2gRC6ccdtjgYI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Iolwc92g;
	spf=pass (imf20.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ekfFZRepZnQ1N1ZhqbxE6PlLs8pwZY5pduEDrnrEgbc=;
	b=bxPNd7iuVy6rk3jpB/06Tx0Em1ggy3AgjMcb7JMgOt9fsEHiZirDdJrJ49T6RtgdMRWiRz
	WqUtKaIeBXiSCWpZoyZaAh1qhzCg4E4aama8VDu0Ek4hthHdJGAKUkECPewhfl5dOfZind
	ww3Q04teJ7HX992oMQneXsonIa/fC8E=
Received: by mail-pj2-f0.google.com with SMTP id d9443c01a7336-2ed324aeaa0so1579235ad.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794559182; x=1795163982; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ekfFZRepZnQ1N1ZhqbxE6PlLs8pwZY5pduEDrnrEgbc=;
        b=Iolwc92g8O9YYzucZPxICvB4zquQZvKHXgkE8/z4mr4VrG4Ksqo1rkx722I6c4vIZb
         SqZ6QDSbD6e5Sb0LsvZWQoPZDjiFSkS4y5Sth8yLSn51bGf8whWsJStUZwMtZ8BUiXaK
         WlNC12QivGnU4uiJ0PWXxkxRaDPgDPzDmDHPtKUiEvc1hbBvGzKlH2hdEg4ioHpDf0eZ
         /biYEMZCkBvUQj5W3vvBxrVNyMaboweryfnDRrG2+3Ca6LuTcdj4ak/6pht6FfhRqEAk
         NRYHwyDE129zrkpHmb7WAhqD2VLqAYJ7q5j5YwKArn+/Dch6wn5chYiqHwtuq6ebGv54
         LFiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559182; x=1795163982;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ekfFZRepZnQ1N1ZhqbxE6PlLs8pwZY5pduEDrnrEgbc=;
        b=dML1FM4UKRgK32fsW7k5YEuC/cwqSROOR73HmoVtyQDio9pCWjq+xLNsiUezvfEQP/
         u9vO04m9hmCyKuTzqixvU0hRYrzROcFQNFTNobN3DMt3qLhGJtyh6QjyJtt259Bb4dZV
         yGLNcd51nSbbi5NCkE2PPfJqa5V//pdg/UVtOZiEvjlIR6JCMRu09wBpVQfmLGZIeUVd
         l5WJyfpq0EiTbJdV0MBYoI1IQkOLwt8lSnaA3hUXd/tWHr+d1IMmgUFHm91azdMCl5qc
         iNb1T1kXH5ZUGFxF7dYnwnLQphHc6WFMmqB7h4q/D2r4ZFLuIi6PRszEYPUdDKk4/sNA
         nY+Q==
X-Forwarded-Encrypted: i=1; AL+hErFdcR2ltPzGyuhwPv77kRGoXdxYlCLK5sikaykj2aXmfTHW3YXpkHKK+ZOwXaMeM04onO4Gra+Pqw==@kvack.org
X-Gm-Message-State: APuU4Z/zh87wIAyXoe7gk7bH2TUHj0t1vbLV4r4bpzQuTYODMoITviip
	4ZNRq9GZXnchW/XAOoNOpqRdH34P+MjiSXcUUnU9KoPUKLhbcfYtFWtV
X-Gm-Gg: AYBFou03W2ko+v24yQ4+dd4TogsfjC7jWJ5etfyTUZfDplq7zrDMFTBu8YQDiARVSDq
	UCQjCRUtYqTkP9hSWezCEvATtSFhP34Ur9KkV7zG8sFKSE7NCYu5WUJdrXjPcQeznH5NPl6PUQ4
	l+2TBdCRc9vgnnRRzXslmTVNfEEPZxt8tjMeGCBGn8o0+2yKvxEiUHHkc+XCeyLgASRxdhjDAMg
	ckWC3IYYUJtv1iI0AapoCQB9LpSjHleEhxlmutvv3gZphg9aZXVpENgGD7uzypac4OtEc7ZvdgK
	AgudM68tgMdxkiI3LtIDagrj87yngY98rePY+GgTY/YwapqOl8eYK3uP4B3A7nN7C3NzSAavaZu
	ZvuFSFhP/7GouH2gVtdNxAlFQ2ZEQUNTqewq2+8nAZj1Qye87qEDEnMMoZT0V7sKcqBE8Z4G9s9
	ZhJyBiFjSIakUIGrcTnolwDBbkCCXlKCoiyaaiw1+wUq32PazMz1qIUctpSx+w7qCaoKQ3VMWvA
	0Z8rSXp3MEPdkgbTP6n5cTEhwkX0hesuiGqL/A/qQrIjwTX9soan2L2hurT2jacYjdLq1euIFXP
	V/j4RvcxZxZxTYXUlQfVoFdwEGEpBawcIfsThVWRpg==
X-Received: by 2002:a17:903:3c28:b0:2ed:18cc:d3a4 with SMTP id d9443c01a7336-2ee0dc38effmr16914615ad.46.1794559181651;
        Fri, 13 Nov 2026 00:39:41 -0800 (PST)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f75dde9sm6809525ad.22.2026.11.13.00.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:39:37 -0800 (PST)
From: Wandun Chen <chenwandun1@gmail.com>
To: david@kernel.org,
	kas@kernel.org,
	hughd@google.com,
	akpm@linux-foundation.org
Cc: ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm/migrate: improve mlock tracking for PTE-mapped large folios
Date: Fri, 13 Nov 2026 16:39:27 +0800
Message-ID: <20261113083927.2727599-1-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: byg5xsb15hexymt6fyssn1capgzc7397
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 092421C0005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794559182-655866
X-HE-Meta: U2FsdGVkX1/vdLWjkhKANtshrHbpr7Efucb1xoqsMKnfd7f6GBaT9riFOuY1tvnhiiYc4HUJJlre//w4Rprq6WA2/VX3QJpVIUXktFaf8sSxmTep7IBJjcWWBvujJmFoJsygS+T/rvXpSYQhaTrdABVrg1mD/QM8fX8nBeTGokjEaSJS5D4DDYZ4Vzf4t4o/3xRKrWtl+kvXbOefhDGHfkGnieghQJYKJxt8HXO1KB4OiDNThfNCq2EOGW5saj8U6VdMK6ZcZj5r/I9gTK+mdLMpB5I6EMvCeEEaO/qid63Jus8kTutjb4vJWrMG3bGemDxn/1qLeEXnEOxSi4S8NGqinl7xiHomb5A1JXYEQZHJ5guNk9D37HPq4JBL5Ot3J4q7eYjyyY2Sa7/PBwCCY2A5KXScdWsxSTst3KVH89DsSFm2q6L51nwMwqg5QHTTVQsvGDf15bwU6Ci7CjziWTnCCJHt0WOwizCSq3q/WUjUP21tr1WdFLT7tc3gyT3PpU+QOe/NqKg8k312woQ22X6FN+bOgHq5mVJuppHd8NIVXQhoMChkKK4BcZm7jK/WYZ+CME37bno7E51gpjRRikGgPXoz/hTAO/eprFh/BPUNIxpgSaCO1C/i/QYg2NEjCimtoW5tSw42pDtFQI+q3BOarcNfBDAQ4VIVDblp+ucTLIEbWuWRZr/ZZeo2aUo91htKphtCfhjzr63dulgMYV3ryHZIUuJGTdbPGSHjEOMdgg7neXfumHMUwpZMU0+vB52VEbIML5bS7bPXAcSUgQo1zUi+yRW/f7l0M8h0hPwkrPJyoIX7GTYsRacsvo9gJmbvJQQ7hNc8JE60AJ0XJKdlDUDLREdBf9ZMhu9bWMA+NXJvALyv4sHivU1fE99lovN6cBy/FtKKm5aZJc+THB+immJusgvndK/aV0VKt4oEtFC/K5IxHxUCr6NZHo1v5Mh83AcfkFgMN0cfz3r
 TUF6VnBs
 swKF3I0jGqGUQ+aayPdAkf2jybGDP7VJHp0wUiI5yh2HyJo9WmxGERZQzG0ojrtm+KUuv4BA9F73I9tqivEVatJaUGpj1pQxoCym562SA4OxR0DtVsp/4wBQGB0p3Czf2q6zM9i0u/R0esN5ZH8umpbv5kwt748txeDIKjo++vpeF3J8moBxwnQ1EZhqaItf4uLy8p5kh9RIkJQKy6MRStAjVimTCWe+iKRRJk+2c6s6P4W+JuRekTBGQWdV5hxy2h3XFL4pxMMR0ncH0cXR//ZtiMLePFRtbhGHk5XtCJFh7rJZZYj+51G+NhcWg8QJTJ0s2wkIgVwQgI6EmR4AXJlU0SBEqWfJTZNa9eUitc4+BRFvCu4sw9qPNkK5ZA7rpohDjq58UNfKxCycW86yRE5C85r7+AReL8cDji+PTCxqhvWNV1JAue79V4QvfBTjG2+HgflVDyzG72wyRWpR7HD7HGgUVl7JlrhhJWAiWXwiawwcIAIvpQf8ezIXFpcHasviVD0ZYkuJ6STDc7MoMcoHw2IB3kfCx9+Wx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

Commit ab521b4142aa ("mm/rmap: improve mlock tracking for large folios")
mlocks a large folio when all its pages are added in one rmap operation.
However, when a PTE-mapped large folio is migrated, remove_migration_pte()
restores PTEs individually, passing nr_pages = 1 to the rmap helpers. As a
result, PG_mlocked is not set on the destination folio.

Reclaim can restore mlock in try_to_unmap(), but Mlocked in /proc/meminfo
remains undercounted until that scan occurs.

Restore mlock once the full mapping has been restored in a locked VMA
under one page table lock, rather than waiting for try_to_unmap() to
restore the mlock state.

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>

---
v2 -> v3:
1. Rename nr_ptes to ptes.
2. Collect Reviewed-by tag.
---
 mm/migrate.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 94033c222e04..3c39d309e6bd 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -353,6 +353,7 @@ static bool remove_migration_pte(struct folio *folio,
 {
 	struct rmap_walk_arg *rmap_walk_arg = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
+	unsigned long ptes = 0;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		rmap_t rmap_flags = RMAP_NONE;
@@ -446,9 +447,16 @@ static bool remove_migration_pte(struct folio *folio,
 			else
 				folio_add_file_rmap_pte(folio, new, vma);
 			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
+
+			ptes++;
 		}
-		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
+		if (READ_ONCE(vma->vm_flags) & VM_LOCKED) {
+			if (folio_test_large(folio) &&
+			    ptes == folio_nr_pages(folio) &&
+			    !(pvmw.flags & PVMW_PGTABLE_CROSSED))
+				mlock_vma_folio(folio, vma);
 			mlock_drain_local();
+		}
 
 		trace_remove_migration_pte(pvmw.address, pte_val(pte),
 					   compound_order(new));
-- 
2.43.0


