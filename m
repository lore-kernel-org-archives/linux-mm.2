Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D3E3606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 03:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DUEHaSsV
Received: by kanga.kvack.org (Postfix)
	id 186AA6B0701; Thu, 19 Nov 2026 22:30:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B876B0609; Thu, 19 Nov 2026 22:30:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04CE66B0609; Thu, 19 Nov 2026 22:30:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABEB26B0747
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:30:17 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 03FC91A0D26
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:30:16 +0000 (UTC)
X-FDA: 85454069274.19.A1F856F
Received: from mail-dy2-f9.google.com (mail-dy2-f9.google.com [74.125.229.9])
	by imf17.hostedemail.com (Postfix) with ESMTP id 279A640003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:30:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DUEHaSsV;
	spf=pass (imf17.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.229.9 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795145415;
	b=JBchcKjjP037q1872c5O/LN8Xtnfm5A/8wckEC11RiPnJkvQK/Ebeqw2d735KPt25V0d1n
	CycU3g8SX7aVolSpzSI2IXJdAUhbTuYxoHDyQ2ZceRdnmPMTkrvdd0isaw2XVLgeOhiyny
	kOW61xL+TWw+xhzGkdmO+IULIzwZCok=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795145415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5KQryppcZTCndUvPMmTnDA5Zo+dmCbnx/qPrbhLEgfM=;
	b=ao+quqwfVGP89TFDkWfTzKKWomcmyTWkxbQwmpVtR6XD4Cg02yDQuK7yHklGur0EF9zXWq
	67kQj7q1TbJROD1HWZ7YS63xkWQp7+hG7+Nm6uAtfzsd+Q7V8BNS4ItGenjnlkyczuV1WB
	o2xt+wNiKGbpM1xSevqqHi4Ers6Yxsk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DUEHaSsV;
	spf=pass (imf17.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.229.9 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy2-f9.google.com with SMTP id 5a478bee46e88-377157fde7bso114275eec.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795145414; x=1795750214; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5KQryppcZTCndUvPMmTnDA5Zo+dmCbnx/qPrbhLEgfM=;
        b=DUEHaSsVcgjcKrr/UQVQcpIUZg2qGQTR1emHm4nXviz21p7rcdJf1oNtbsArowe6NX
         eQBei1W09/V56W9fAbaJAsslP/KDhp55HLVe/j2GEUOrke00Xl333ZE/Vdtmh19T/6nt
         oheep30SmgjXpMJ/vrxgx+CBBQZz8Ve4hzFXcEynSrI9LFnAjhSsZdWKnn06bGBDHKvc
         NASRTwAcUIfeQsWfQ95x1HFtbPDayl5m28YWPOJfM3bH685LZ7JAqvDrtstV2NQLflrV
         sk+ZJzwMiDZLlHM/T/tkR7zp2zK1zL5miJ7itbqvZw9N3pKSr/rpRdOEqyEK3k43k0mT
         gZQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795145414; x=1795750214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5KQryppcZTCndUvPMmTnDA5Zo+dmCbnx/qPrbhLEgfM=;
        b=qSEiecu43W0Pf75OaKbtjiqKOMM9FlCQN2e17tC8Z5OVP2GAhjJ1Ici1iOGwDad2uW
         ZEqy8n3yxCLQlN30+WKG/lOkFbSxjQxNA3db0P8wWpSE9tBCtb/J6SWE0aMye0ZMjuE7
         GeZVPCxfk3VldHFSsk91fSf3Nv3LuhL3ia8K4YvbtSfod95KSQ1dN2MU/8PnNfuSy56z
         F5ikG8U2Te3lJho2qO4K6KkVdXYFsrmZBprItWJexRd7cemqHlEKgQqYFpriywHQU31i
         PGxOebX7VvBH9haE2K0c+Nelyp065Bb/hPKhqihrS78AkYNzeP5PmNyw0liDW0Dar12q
         gQEg==
X-Forwarded-Encrypted: i=1; AL+hErGGmgN0RmUkixL6lSKQCJSKYNzNKyTwA0sGkXd83wSIWxfVuveyt1U+8O98LZ1tUYctY2RDHWAofQ==@kvack.org
X-Gm-Message-State: APuU4Z/WnUL0+vi4B1wCgRGPDi5m9N1qu9qjGeT/0ua+Ep7ZzNDlaX1g
	Boltm9+TkWZO3PhwfixKVQtAVmpVsh2fzlrfRk+Ll5Y0nXVBd55fWUO8
X-Gm-Gg: AYBFou2XE+j7REE4gK2UCF3tfbc2QAJZT7fffG6YTdnV8lsS0HGrRUlstZO1+9nmQ9n
	VKZ7TL6VBAGXKyauvyzXlE36Y9+7CaDkWcXEgHcZB8D5CWXo56XWWnLxaddYB4wOMYg9xkC0Kcf
	rAX4kQm3+ETNqUX3VHO1LywZgxkFNPygXdzmeEiRyR+r0NlJNpnPm3pCr+JnQw76AB0n6orAad2
	o7kTvo0Ru8jE56cWMtRoxKVlvYDvpTvePMggIk1wnC08cgygGNu4z8GNlje0UVhQ25M9L9vhj4V
	QS0FJzjIODHeAQvRvNdJRxo/0tgugkKI1CPY/WrHNZJAgNHkEJbu7pJkCeY5ES8j71BPk65BD07
	HNm2udQxm7jBN+knGEAll4rqm3yxPF+v/Ce6yRRwNM/da1mSNfjsz/jwcZ9UcSDfUszoCHj5bUQ
	g7Uihz4P3FsOMcoJ5U8uRiTF7WD0LuYwvmlrEA3hfmpXWF05D22yuyXJnmMGhO/c8pcrRRMvPz2
	vohJDBdhWJhUwi5kJPstPcVnHVjVNld5j3QTs3cmkBHKmXE7E/r1QiC/93cP5ukbz5DhQrblaz4
	1aOBBanxRtcQ/KSKt0WBL3CW+o9dfWZ5fE/ggv0ltR9vKrTXfKvA8eFbDx528CY=
X-Received: by 2002:a05:7023:a5b:20b0:191:a5b2:ef4a with SMTP id a92af1059eb24-1b5568b9f5dmr1447318c88.28.1795145413793;
        Thu, 19 Nov 2026 19:30:13 -0800 (PST)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567e644dsm4362507c88.5.2026.11.19.19.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 19:30:13 -0800 (PST)
From: Wandun Chen <chenwandun1@gmail.com>
To: david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Subject: [PATCH 2/3] mm/migrate: batch PTE restoration in remove_migration_pte()
Date: Fri, 20 Nov 2026 11:29:48 +0800
Message-ID: <20261120032949.2036731-3-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261120032949.2036731-1-chenwandun1@gmail.com>
References: <20261120032949.2036731-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 279A640003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: mwsamtfr5e7g563oe6sjjyeji5sikwqn
X-HE-Tag: 1795145414-30239
X-HE-Meta: U2FsdGVkX19eYD7aAxMTWDaITQvB+W6SmU8Fg9Kt2rO8tlE+O11Lu0V3sg0FUXUq9DQcx++RhnTnRKgddDI9DNmAlutQEB3njIzAYTbEtARkcFKamdQo9i3PvBIuScQs+HB10GEe6IiWg4zEjfH9aN5lLR58xrwkbow8J6NTtPaPW0v8ftylqtAczwMrvaFBrSGh3eTFMqAWK8s0G0X5t7xzQ83Mhfqp1ZIyJxyEifD3Ii2ABOOZcqS8R6Mz5hprHTgIbaE8NnHbR8oNY+FkmUoVvpUEDcUbwWP2TNKCfDzzsoNJfcwJmfBpcEQv7y7DVasCbs5llMGVFudUaFyBoguMUHKea11YsqIxVr8lwL+q4Pp/5DlGiFy4lJ8bI2HrwicrmgoVE2WYVQRYaHqSOIEMYH9TrRAuyZ8JWqwa6wS2/yQSruqmIr32QL+idK90s//4y1iosymdZ+ThId9O1g7+nXWH0ZNxIx2BA9Du4Aaroo3cqVIex/Xr9mt/YoWAQ/lDWvwbTugYNZFX522zBljIbS0VSSUuQy6exjGonY7CTkjTPYa1w60QI+M/XYev9WrWakM2SUVUebe7ujcZdXKmfoR5X3Oocei+a/yS1NdEeYCjhNYtXFe32DOs3yWvHbrkEax8tJDHKC4cYNe5DEh2gpgzHflJJYbcRjhHamHBfqJdPYS9W8pvWbgvJIB2xjfvBNFcmw1NfPXzHpe3nsoLTd7q9x3AUjbwo21BLcc7torB892PfaafINvlpePWEQRV7vEBfW9e86sOxiX0eamrcujPGnqp/UVGC0KwyCI8Kel/ZikM/Xqm/d1C+OVQVrbOr+To89kbwCckt08b26qvTMJ340WwRWTy9nzkrKsJiAzTmtSGltpWApano/rL+RemH+E7rFrLu4etwXhQb3yP1XL0qI9yahPbWwWFk47Sg5AP3/QIKN9Jmz+I25j/g7Q+5tIEy3QhNZ4wU7R
 EEg5moyA
 GFq8eTL+O904jV76VmOyxOCFvlIIl4denUxr/JIcOSOPS8p+m0uYfzecXeJSDm568TvSVAwKjzxqXVNegikUq6T94n3ueyj1aVJbvBeJq4xOJnAiZjljh6ppSaCsLRD73fApdBqPnTFovd+kcrNdovjSAWBeLNxw1z5ISPqlmASSKZAD8AYweV1rM0yr2Jmo7dFECrsJzVS1DviT0WW8HAhDSbos4G/GjWMKzCLH2X7njLsGqy57ftKnlyd9LgbZcsfnfRKj7vgRg3YqyGAQIjSMD3o2Wh7b0Pz8IqftpSGeKsa7TcqAu5HLLVpwLlIMuMVU1Zhp6weSQxEfzU2aImDgNmhQAgfThx6efJSsxRjMfDMVjff1IZ1G+TUuGHhxCi1e+NcTSQD2oNomQNWaqiXJEmxJbHOoacAv9EoySZRc+lWS0XU9HE3MWsNombXxnvsg5dCwlYAazqpGP906AkLmaOop3qq4ctTwz94pdn/O6/xR55SvfVDxKxIXazUO58Y0Mu1MWMPKjktlZUNDo5UkmxSSFF1jgJevoB407EnxcqqX3Yvr4ah8StPbmk8V6VIb93z6ulhGl/ArPUILCyZckP9u/1zKmc6BbP69unahzRYaB32aR7ZV5ZwyQz8UIchzrjQUu17WC7dN8yaZako1KaMPCzuUN9UKvLLDUVGsJui3UcycD+7XAgpCo9wJJGcz0/CkloiC2xghoIjgQsPXIG6wenXfzFQn1f64Jf3fZU4US3f4qfQG6uHyXBm0UE5fupguCURm0fipKeFcntHK8VSQbTHpqwwUTQXBjmaSaqVreHUkW1z2VDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

remove_migration_pte() restores PTE-mapped large folios one PTE at a
time, constructing each new PTE and updating the folio references and
rmap separately.

Add migration_pte_batch() to find adjacent migration entries with
consecutive PFNs and matching type and flags.

When a batch covers the whole folio, the rmap helpers already call
mlock_vma_folio(). Skip the explicit call to avoid double mlock
accounting.

Device-private PTEs encode PFNs as swap offsets. set_ptes() does not
handle this encoding when constructing subsequent PTEs, such as on
arm64 with a 16KB page granule, leaving device-private destinations
unbatched. The next patch enables batching for these entries by
advancing their softleaf offsets.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Link: https://lore.kernel.org/lkml/5f9c449e-43b3-4732-9c14-8199418cace0@kernel.org/
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
---
 mm/internal.h |  6 ++++++
 mm/migrate.c  | 35 +++++++++++++++++++++++++++++------
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 9f78c12882cb..e6ecf307d532 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -552,6 +552,12 @@ static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 	return __softleaf_pte_batch(start_ptep, max_nr, pte);
 }
 
+static inline int migration_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
+{
+	VM_WARN_ON(!softleaf_is_migration(softleaf_from_pte(pte)));
+
+	return __softleaf_pte_batch(start_ptep, max_nr, pte);
+}
 #endif /* CONFIG_MMU */
 
 void __acct_reclaim_writeback(pg_data_t *pgdat, struct folio *folio,
diff --git a/mm/migrate.c b/mm/migrate.c
index 3c39d309e6bd..e000ef77ea87 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -358,6 +358,7 @@ static bool remove_migration_pte(struct folio *folio,
 	while (page_vma_mapped_walk(&pvmw)) {
 		rmap_t rmap_flags = RMAP_NONE;
 		unsigned long idx = 0;
+		int nr = 1;
 		softleaf_t entry;
 		struct page *new;
 		pte_t old_pte;
@@ -441,17 +442,34 @@ static bool remove_migration_pte(struct folio *folio,
 		} else
 #endif
 		{
+			if (folio_test_large(rmap_walk_arg->folio) &&
+			    !is_device_private_page(new)) {
+				unsigned long end_addr = pmd_addr_end(pvmw.address, vma->vm_end);
+				unsigned long max_nr = (end_addr - pvmw.address) >> PAGE_SHIFT;
+
+				max_nr = min_t(unsigned long, max_nr,
+					       PTRS_PER_PTE - pte_index(pvmw.address));
+
+				max_nr = min_t(unsigned long, max_nr,
+					       folio_nr_pages(rmap_walk_arg->folio) - idx);
+
+				nr = migration_pte_batch(pvmw.pte, max_nr, old_pte);
+			}
+			if (nr > 1)
+				folio_ref_add(folio, nr - 1);
+
 			if (folio_test_anon(folio))
-				folio_add_anon_rmap_pte(folio, new, vma,
-							pvmw.address, rmap_flags);
+				folio_add_anon_rmap_ptes(folio, new, nr, vma,
+							 pvmw.address, rmap_flags);
 			else
-				folio_add_file_rmap_pte(folio, new, vma);
-			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
+				folio_add_file_rmap_ptes(folio, new, nr, vma);
+			set_ptes(vma->vm_mm, pvmw.address, pvmw.pte, pte, nr);
 
-			ptes++;
+			ptes += nr;
 		}
 		if (READ_ONCE(vma->vm_flags) & VM_LOCKED) {
 			if (folio_test_large(folio) &&
+			    nr < folio_nr_pages(folio) &&
 			    ptes == folio_nr_pages(folio) &&
 			    !(pvmw.flags & PVMW_PGTABLE_CROSSED))
 				mlock_vma_folio(folio, vma);
@@ -462,7 +480,12 @@ static bool remove_migration_pte(struct folio *folio,
 					   compound_order(new));
 
 		/* No need to invalidate - it was non-present before */
-		update_mmu_cache(vma, pvmw.address, pvmw.pte);
+		update_mmu_cache_range(NULL, vma, pvmw.address, pvmw.pte, nr);
+
+		if (nr == folio_nr_pages(folio)) {
+			page_vma_mapped_walk_done(&pvmw);
+			break;
+		}
 	}
 
 	return true;
-- 
2.43.0


