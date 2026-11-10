Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531AE606A327
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=N2U+81ex
Received: by kanga.kvack.org (Postfix)
	id 72CBD6B05C3; Tue, 10 Nov 2026 13:01:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DD2A6B05C4; Tue, 10 Nov 2026 13:01:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A5CD6B05C5; Tue, 10 Nov 2026 13:01:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 348B86B05C3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:01:05 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 296A6C0994
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:01:04 +0000 (UTC)
X-FDA: 85419975648.07.4F37B91
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 49C6040003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:01:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=N2U+81ex;
	spf=pass (imf07.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794333662;
	b=SqTA+ghAgv+ouFW0mKniodlTqmfYNAFznoGAYYr56Zo+XA0/mwuuOwxpE/8Z/DL2NMTfQN
	uRS7zUrIq35WguuuUtt0cyDABtSFwoJxdTKwRcPE6U+cLV5qh8WMMBRLyzkQ5eYvjYoh2Q
	aMlWUh/5ymx9vZ9MUu/Zx2lAJ7Xd6MU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=N2U+81ex;
	spf=pass (imf07.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANhVEI2FjVEETl30wKF8XXVG78pCH1hEhuZdh7nY6Zs=;
	b=UI7FgTtcfGVIDaCyrIrJ2vQRU8RJF4+BALyVHoCD/Ua37SRMurUHCNnXja5vXzutQ+HSuJ
	UGAsn27V2eLCNRj9qi2v/U/x3qdvh9atUMj1qhKvwBRrZwOAxkaeyDFKL/hLkn5B7mCsw8
	HEenj5fADsldAHy8hYwTswHCUtecHEc=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1b3a05f8b5bso3477203c88.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794333661; x=1794938461; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ANhVEI2FjVEETl30wKF8XXVG78pCH1hEhuZdh7nY6Zs=;
        b=N2U+81exkumzrvBZt0d1x7PK2ELxqOboePS3HzfzQpanSxbih24w3C6kbRJk+MzXcB
         xo2P8keFLRgIW+wkIGzkC6tNXgIaDcI/VAGKiXw+JVn7Rf2/E5uQZw3XLLfZMrLEEYUG
         c0T1a1P1Wd3nFyl5AZhPubsJ/h+5dmGAG0ERLoIwBQDv3Rr5no6KP0WwLG5i32pafy7D
         7z2ZPWkZhmAp1oYnmwUKQtfXfdmJfSlOuLgiGQglgF/dcZFS7qZMWLkBPVX/TfTZSY7Q
         Y6gN6wMLKFqt6qJE9+rzP7r8JfaW/+XJS3n9TEQzHXd0fEe2BcT2kl5O3O1pubAnyJMe
         +ixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794333661; x=1794938461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ANhVEI2FjVEETl30wKF8XXVG78pCH1hEhuZdh7nY6Zs=;
        b=jfQ99iZUkKUSi3DzN2i6PXvzF1ylxk/TSED4qUpoEhfrk43KVAE2Sy3KCyt9P5r6jN
         Xtz2emArjiiDyILcukM7Z3aIz5nBlEQRHIjFw9re16mnGJT3nJ3x4yeY5v8GH0pK5Jo7
         sjmqaQzl8xUho8MeMuFo9VBTpRddqf9dqb3rPkCrfmZ+/tmGKuPbjfW87q0UYN9Ibd9W
         99f1YesoR+KGWqu4TpcpdhqnRhObdFud9aJ0WdXnyyMPCstIl5mcimG+ooR/kDoGpk0o
         6h3GoauHrO8+8YLb9A9scz6pv3AqL4+VsLdMjmhSp7whvs1M6YmYMHritfWBIYPqRPn9
         SELA==
X-Forwarded-Encrypted: i=1; AL+hErG7aHZ82kg6yDbNL9w/U0oOSx2FFCuA1XC5hIiKiJOUXaunmUB4D2l8BUDxaLiDBNmGuSfNHSwmTA==@kvack.org
X-Gm-Message-State: APuU4Z/ed21Cx8h0YXMOds9X6nA76U9kwISpWFG/BomVCovGyobInvWk
	BqO8RMcDOj2kQK7s4SSbwIeva5F2URlIb8toaCSh/3XW3maTfiKMqlCL
X-Gm-Gg: AYBFou3dnVLGVew1NdZDul+6cp1HwB382tpibaqhSsuxYcgaJ7CZ7fnNv4n+cWoMUcP
	Eylf0zCD0rwBDNo1itYNhS8FswAhlgi8ozCm5Os2XEdmIp+5QafMWXvcI8+r8Rgn84yosiNbzOB
	cAOK4JqtTXafap7xjMCYX4ajeBZ5GeHApDLzIS3xtne2uvM/5Pw4SjlP27e0bOR0GIBIJHgOYoY
	sGExeAXK3p8PYw5pLDt++K1/1s+7suvseiFyT2UJsn1QyG+6t50TIf4SxN2AfxPd1l8NNzkJJHY
	NxhNL/TAfX580JYEDEkF0fPU9shw3hat40JHqkPBfRBNGHxbWQSGOHJzE25bBxxf0uFm9CmQV1I
	T4t+duv+CA429tjTorSQTM4t3ANQQErLPf9BeAmPMaFLWLfOdwJJpXNfHw3pdJLMcqJUxK0lh2Z
	uJhoIhPPUUc3zdPJLJNQgdpxT85l2XaeGxpFdfk5SW4BBmC+887wo/sudKlow4n4mS+qIhNvNgR
	qWqDo44joOFwn6WwEHSz2GUAd9OIam00JDGNMYMse8VnJU6yM0b0oWs/vsukJo7sf8q7GKhANOR
	2vN0+KMyFiBVd79oKIOe95s3fFJ4LRH8SWHgPyqjDQeBsNCNLSfyxc54UWk=
X-Received: by 2002:a05:7022:28a:b0:1a3:87c8:7efc with SMTP id a92af1059eb24-1b3b605185emr4269128c88.39.1794333660619;
        Tue, 10 Nov 2026 10:01:00 -0800 (PST)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b4b90csm7624260c88.14.2026.11.10.10.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:00:59 -0800 (PST)
From: Yin Tirui <yintirui@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com
Cc: ljs@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	ryan.roberts@arm.com,
	nico.pache@linux.dev,
	usama.arif@linux.dev,
	liam@infradead.org,
	kas@kernel.org,
	wangkefeng.wang@huawei.com,
	chenjun102@huawei.com,
	yintirui@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH RFC v2 6/9] mm/huge_memory: add and use split_huge_pmd_anon_rmap()
Date: Wed, 11 Nov 2026 01:59:21 +0800
Message-Id: <20261110175924.2945538-7-yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261110175924.2945538-1-yintirui@gmail.com>
References: <20261110175924.2945538-1-yintirui@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kirfgejympdt9hwcgqdpc8j7bw1fe441
X-Rspamd-Queue-Id: 49C6040003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794333662-339280
X-HE-Meta: U2FsdGVkX18t5T/9XvIaOODbndiuR5HHJKEGh9z/2bdjDjESoTl97ezBWSvSM9IzEkOczF8efTqE45K4ZrHfmiUmvbA0oJqbt8x8qumrVmGWEapH7zDZ1srGkpHIX33DE2s0DelOVmE2AOKMMO0ypLUYX6x7z/E9S4hjGQB0a/87WDh25McVknhaRe5hpD1DhUHgBAJNaOrLdojZlqCHzQpVainUj5pYF0xZJPzukpotRzgzWFBrZgedMUz5rv4cOfBm5ygA0sXaP7pTNMsFem7kxzflAVn6aew7tbmSWtHJV5RLu0K39VQ+5J+Q6xY3Nf6cuaLpVpC1kIppqfJvzk+DiOl2+xgK13JzSvvE3asusR2A7sby4s2RNUuuxlFoT/a5btWb/E3p+RAE68uOfRqxmkvyBtEZsQx3cTcKocJgAGa4VIo+ozr4jzhl+04i7cBIspB+brkF/Din739u9/s2ZayP+luE3g3qRmW8JJCzoskgsoFNNJANNJpnib6LJW5Tq4gpQWOs2qORs66ovv8oA79Uffr3ahVJuAvDjwpYkavOFBgVnN9n9nzBZ5sRyNlMJ3qkwYHRVbJje97stz+gZB63zvZkUZNf1H+v/5Elnc/fYerWuloI6+olW8pc2PjijWaJ1YPtxFRvpExq/ApseuZq99u8tNjLlgqHv4sGjqVDLEcbtDe63sKUjdjwOq/4mdLROLlbrmUZSBMXxFKV0CBGnwclz8CFUEmPEDDp+voC4lDAmQy3mzQA7e9+ml+cT613uGzrG87csW24ZpJxaSk++zeWNRiLKF0fznAzCTr/zwj0DR3v+A+APLQP8L7Z38iFgycytthccfljJClJ1zkkbq0TsXZ0YBdPEgozVbXcR0vwy+rT/oioGOmJAddvpNpSfdS9YzXV2w00a4T0y7e7Rv89tqChhx9rTZhkqrfrgoypMyDU+TWwx/UCwulUmUw26n0gjOxC3Zp
 9eDutwWQ
 48KelfPY9cnZUe568TZ4ymFEQMOkVjI/Lwz3VJrjtlZthCmucIGnEVBKaBhG+eMhXA04jZhDhKvibPhdY77nIM1+x5LMEaukBYyFpL5F2e1eVeWDG+5ixqur6ID6WwSyXO3yRZ2rfgCEk5Jzz3SopV3abbHTQrbHt6SZf5eaA8WtbqMW38SMpu2evjvA+F6CNTHnc0LfSwdRgn4hmTW/VYILD/7FaxDGo+tWGbV+KL/9Qu15PzG9c2xQ8gIcbh5cN+PZqFmy/0rkyDkd/kTTVpfWBJqD4hMeVtsvIaGzBxH61BYFZA09suQAQYyslTrAK4N0ZolrlNuQxv3JvGEe682OImIVFvehO1dLw7PNz2MpYx3NB5/ew27pW1/nvRTZENWv6fgbyG/Jw+WuEAkEXUcyVDm75cL4HGt0qGhQssdjHNiplXFf5ZGlU1XPHH+2zFXBmC+llnBGQH80=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The anon-exclusive handling and the PTE-level rmap conversion are written
twice, once for present entries and once for device private ones. Factor
them into one helper.

It returns whether the mapping may still be frozen instead of writing the
caller's freeze back.

No functional change intended.

Signed-off-by: Yin Tirui <yintirui@gmail.com>
---
 mm/huge_memory.c | 90 +++++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 43 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index dcc8cd380da2..5abcd194bd4d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3239,6 +3239,43 @@ static void unmap_huge_pmd_entry(struct vm_area_struct *vma,
 		folio_put(folio);
 }
 
+/*
+ * Convert the folio's PMD-level anonymous rmap into PTE-level ones.
+ *
+ * Without "freeze", we'll simply split the PMD, propagating the
+ * PageAnonExclusive() flag for each PTE by setting it for
+ * each subpage -- no need to (temporarily) clear.
+ *
+ * With "freeze" we want to replace mapped pages by
+ * migration entries right away. This is only possible if we
+ * managed to clear PageAnonExclusive() -- see
+ * set_pmd_migration_entry().
+ *
+ * In case we cannot clear PageAnonExclusive(), split the PMD
+ * only and let try_to_migrate_one() fail later.
+ *
+ * See folio_try_share_anon_rmap_pmd(): invalidate PMD first.
+ *
+ * Returns: whether the mapping may still be frozen.
+ */
+static bool split_huge_pmd_anon_rmap(struct folio *folio, struct page *page,
+		struct vm_area_struct *vma, unsigned long haddr, bool freeze,
+		bool anon_exclusive)
+{
+	rmap_t rmap_flags = RMAP_NONE;
+
+	if (freeze &&
+	    (!anon_exclusive || !folio_try_share_anon_rmap_pmd(folio, page)))
+		return true;
+
+	folio_ref_add(folio, HPAGE_PMD_NR - 1);
+	if (anon_exclusive)
+		rmap_flags |= RMAP_EXCLUSIVE;
+	folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR, vma, haddr,
+				 rmap_flags);
+	return false;
+}
+
 static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long haddr, bool freeze)
 {
@@ -3320,23 +3357,12 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		anon_exclusive = PageAnonExclusive(page);
 
 		/*
-		 * Device private THP should be treated the same as regular
-		 * folios w.r.t anon exclusive handling. See the comments for
-		 * folio handling and anon_exclusive below.
+		 * Device private folios are treated the same as regular folios
+		 * w.r.t. anon exclusive handling, see
+		 * split_huge_pmd_anon_rmap().
 		 */
-		if (freeze && anon_exclusive &&
-		    folio_try_share_anon_rmap_pmd(folio, page))
-			freeze = false;
-		if (!freeze) {
-			rmap_t rmap_flags = RMAP_NONE;
-
-			folio_ref_add(folio, HPAGE_PMD_NR - 1);
-			if (anon_exclusive)
-				rmap_flags |= RMAP_EXCLUSIVE;
-
-			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
-						 vma, haddr, rmap_flags);
-		}
+		freeze = split_huge_pmd_anon_rmap(folio, page, vma, haddr,
+						  freeze, anon_exclusive);
 	} else {
 		/*
 		 * Up to this point the pmd is present and huge and userland has
@@ -3360,6 +3386,9 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 * complete for this pmd), then we flush the SMP TLB and finally
 		 * we write the non-huge version of the pmd entry with
 		 * pmd_populate.
+		 *
+		 * This must also happen before PageAnonExclusive() is read
+		 * below, see folio_try_share_anon_rmap_pmd().
 		 */
 		old_pmd = pmdp_invalidate(vma, haddr, pmd);
 		page = pmd_page(old_pmd);
@@ -3374,34 +3403,9 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
 		VM_WARN_ON_FOLIO(!folio_ref_count(folio), folio);
 
-		/*
-		 * Without "freeze", we'll simply split the PMD, propagating the
-		 * PageAnonExclusive() flag for each PTE by setting it for
-		 * each subpage -- no need to (temporarily) clear.
-		 *
-		 * With "freeze" we want to replace mapped pages by
-		 * migration entries right away. This is only possible if we
-		 * managed to clear PageAnonExclusive() -- see
-		 * set_pmd_migration_entry().
-		 *
-		 * In case we cannot clear PageAnonExclusive(), split the PMD
-		 * only and let try_to_migrate_one() fail later.
-		 *
-		 * See folio_try_share_anon_rmap_pmd(): invalidate PMD first.
-		 */
 		anon_exclusive = PageAnonExclusive(page);
-		if (freeze && anon_exclusive &&
-		    folio_try_share_anon_rmap_pmd(folio, page))
-			freeze = false;
-		if (!freeze) {
-			rmap_t rmap_flags = RMAP_NONE;
-
-			folio_ref_add(folio, HPAGE_PMD_NR - 1);
-			if (anon_exclusive)
-				rmap_flags |= RMAP_EXCLUSIVE;
-			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
-						 vma, haddr, rmap_flags);
-		}
+		freeze = split_huge_pmd_anon_rmap(folio, page, vma, haddr,
+						  freeze, anon_exclusive);
 	}
 
 	/*
-- 
2.34.1


