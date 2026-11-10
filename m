Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69B4606A327
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ch5owv7W
Received: by kanga.kvack.org (Postfix)
	id D9A626B05BC; Tue, 10 Nov 2026 13:00:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1CFD6B05BD; Tue, 10 Nov 2026 13:00:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0C056B05BE; Tue, 10 Nov 2026 13:00:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0BD26B05BC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:00:15 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2D084140A30
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:00:15 +0000 (UTC)
X-FDA: 85419973590.17.E4D215A
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 464A0C0019
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:00:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ch5owv7W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=yintirui@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2zYAQk7dfh7Cuvi7cfy4zLs0bcYM3xIu51I8ewPRuE=;
	b=Dsqf5o2S6xKpyeklGlwiLf+NM8uSxoQqJuD4i61jB6gXo532B6ebPCvr3A49yUt+bp/mav
	trPUtDi4VaiF3MEWtstJlBu3mF0nCXvjMjeKrZIRDZsb1PVbzpzOcsCx48hZAo6Lr0G2LN
	QuL1lvtZq0PAik6wCi3Dns2U7+CQBys=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794333612;
	b=CrzxMiJUZvhckMdUxkqoLvIGdFWGpNEH7N88pZd/zlnRCMMnCy7W1XVtgZIAaHu4kXTSSz
	nJCY1Oq4JsdLC4kDK6RtgbOBwovEhSypYjj2rz+hhZnLUmu+DN3j5w9A6WKDjfXLl55yf8
	+y7IBrnFn74XPel30pm65GhXQCyZJSw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ch5owv7W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=yintirui@gmail.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1b3ada81853so2021977c88.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794333611; x=1794938411; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P2zYAQk7dfh7Cuvi7cfy4zLs0bcYM3xIu51I8ewPRuE=;
        b=ch5owv7Wv6ttLLTlKCla8UJqkxzreN7KSDDUZlCD4TfYIXbIC/pD1ZjTVShloq7bkP
         65ZipaGR5//NrB4x08+4TgF5S0/YyTCdnIN44w4TkIldetu48G6XSrRptprC8OY5kvl3
         RAHKhK0Hv1UqHELJ8pM3jXRtMcufBzmAjgSGifu49Cz7eqc1h+cYdqFiDhA9wuZZ4uYX
         LU6RVsT+/R7DeuJ9beT5jJl/W5eHkQqMHTy5fHss7G9zrDhc/kxg2Qr2CxjiImK/Je+f
         KHcJ1Uv3XawNJYk7LPIDgu1DubAhd9j84obuPZ7LIb3ZmE1AJda09mOjc0574bi8XlXW
         +r8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794333611; x=1794938411;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P2zYAQk7dfh7Cuvi7cfy4zLs0bcYM3xIu51I8ewPRuE=;
        b=l+eUKaR8XNwjPpqkmosRG5DJieQ+jx10yPSgaqC5fK/ln4YvOArqyg3CocVEwTu71/
         kagfEhwGH0VdbgEJ8VQOfDyoekgRz2JUByQ6qziVCv0snzUTwk5gvu1/mR7GKpuzebZ0
         HAn/BeLqWx8kmssX7WDzG+d/qM8Zv3fU5TrcI5j5hRNnjtQ/CVGRjLn5jze0oyG9zDwk
         tN8sBfxAGxCJW384Hndqtu20tDAGx5iw2C0nGe2wDhV/qbRD7HsWPSNioq0Aqh69TAEg
         qjet2A/AylH++tLk06T+1GCQf38Ys8yS5JO0aztbmyCIFH5ai3ADZ5mjQCTKzf9GKhFq
         qArw==
X-Forwarded-Encrypted: i=1; AL+hErHK7LX4InTFMUcGqwOfViqJWor4UZDwhTWt+DS6okAEcrdvi+vZi/H1Mcg/KqhalcKZOLBj5l8r3g==@kvack.org
X-Gm-Message-State: APuU4Z/iOV+CBk9mq7peB4njiVgcfiNr/91IoMlgz02aGCQNBSzVCLez
	ponRzw9JrmQNn5HVmUbrWj9gUZC1/SZPxtZE4y57rL3DLRupnRyINgX7
X-Gm-Gg: AYBFou3tOXVg3NjNZ3FrQzstsG+G+wTTUhO0VI5uVDIbOxK1blT2zZ1JoBgdhulDkOg
	qYlUNJvSKGp9C9FHqybfFJjhsV4L3Q+wKM1o0c6YimgZdhYgbKdkPqCM2EJHFPyJ9dUdl80Tl40
	w7LMqssqNaYJNVVRrk5Hlu38xSPphttsDUMqvopzrl/hytHKGI2GnUQ8b7Yw7A0iS+UpGHgLGQy
	LxmpnjqJsFZqWcuPF+c+aTtjJESlwu9luKPOaXYUB5GlV+qsdSd8ewpfuyM7NuFBwn0qwXKs5ky
	p+G9WW0ZTydwK/jBu2eLUcrn9t9itd374Fbqivh8DNgyYlL5HAXjJxO1IW1613EsI9XS/JVMd/N
	W5NYCy45Cksw/TWpMH3pNRxymaFQxCQIWu5G5HrANBu6QnCtAKG4QjnFua80vRCAd1xr6vecDCG
	hNu+SFi3fVjArVrqL+vfzHO3Ckz2oYCFuVs5pXZxJIWop0A2ScN/DmsLWiyXqgANhuFv9g9R5xa
	6ERe3qjPCfykNDgTwT/93f/vQeZVkSo0yxfAfoifNV8B5sP9lQ0mq8b5mHGqMvxujQ+ebHWFjiQ
	dVcEzhIC+W2WsKtpFPiaCEHUX35CnloQ0gSi06PmJEVmL7A0rYQIl/1P87E=
X-Received: by 2002:a05:7022:f519:b0:1b3:ac23:611f with SMTP id a92af1059eb24-1b3b6017fa0mr3776188c88.28.1794333610087;
        Tue, 10 Nov 2026 10:00:10 -0800 (PST)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b4b90csm7624260c88.14.2026.11.10.09.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:00:09 -0800 (PST)
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
Subject: [PATCH RFC v2 2/9] mm/huge_memory: add and use huge_zero_pmd_can_split()
Date: Wed, 11 Nov 2026 01:59:17 +0800
Message-Id: <20261110175924.2945538-3-yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261110175924.2945538-1-yintirui@gmail.com>
References: <20261110175924.2945538-1-yintirui@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6fernt3jcuhanycrajpc54usgy5fz336
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 464A0C0019
X-HE-Tag: 1794333612-534487
X-HE-Meta: U2FsdGVkX1+QnMbdP3LH7TjDw8eQsswkqqdy7ulSkm8O79znmrNfbjqmFnHEzwaPpesh0TyMtDY+bfPViTHp0NYnzBsbCpDh2wNapkAaaIUQoCAxBBNKCVQdTthNckGznEw04MoZ369HHK8POSDrIw3bJ4EzXT0Eny6BbQJtFk5QPWvACnR15Lb4fgXH4lNl+sQqXdy+xumZD8u5BbzFhHfLAd5Pl6vPnkEyKcTg7QB4zATst0gozW37qpGgO4qiPK48mc+WH3pWkOuFoGE37fKDsyc6G5LPlbrErMi+MbR+H0pTzL9T8zOd4NDsrwU5ttNB7KFr1dpVe9ZK/VPgFHdbjD+tYSxvrm/cG6OlavVQSjktYjW87flc09UY2yXgwZTnCeVC4aDR7n976DJYc2FZRmtBtHXjTWr+7T4m5lyyP35hFtfs8p353fso3xlIMn6X7GqRHCVqcbZuTJJ/SViDmcqBjIRt4Sj0YWe+zCBdKMvN2+67XsAk98a8eyb7+Fto1+gc8BjJxdrEcuXXTOQry6Z1VcW4+qDzcg5ZF8CK7hGtZXjhKl9E0EMcOPC7ocj18dKr92p2v1X5qLN1kq4v6zfxRihN6pXcF+FnvIrArDbjTKA+4tTOnCLAs5aHcmtwHjoEBuBIPN1/b2T8noXyDGGYYYo67VabSTpnoeaRFWDtwMO+chQeQ8pq1ei5/WmUjJfgH5h3/4ekZLkuh7MRN/gfbEKDVBzDXQBXj55b3kMlM4caJbzy7B1YWXo2yykRBC4EBcs4ckG14ORv6kxI0ys/MNGp7AW0VuruLgduqOMraqARhm72rI9fANeDHfRUWuC2uXI50uThWiqqM8eHYsYSnt/M5Mf5QktapO4MVwwVWr+QeD/iVWAM08qibuCg93J7ZME7OdTCzSPVRTjKJvsH8cGCX1FKJC9qI+RPEqdHtkJEyxomA5RPb60Sw89CgA6dxUKntONTX37
 3cGhtOcf
 x+wFH6Mhp/zq2Xc71JTK8R8ON+Yl3SAWfc35vTVrfQpq3zygv7rUZKFxRStKakppghZHuuEID/W5Awunb9lSXAviWPwW2wFDoVFmsSZqRhyLfvqiSf7LKexz/QXud77D+O/eG3HiljaL6NUkjwz3+f9ki7qbstW8ui/nouK7BB4U/PW98fG9Wjnjc5EnM3FoLFncJAncd+RbCWbPR6JnJEc2bPq5KjwhqPO8xwPovCdEGCSpQBR6zqehNJaqnAu/bozKrvHbP+kYKyLNgqxkd7L8dzR/VPkw8WRkgP32c94ZeENRxNHZpP11pSBnUiGB0LG5jeOWZ0fZybF9oAX5xd2qV1zGss6cLNgyBRXfxkGm6Q1d9lWKqwnvmOPTX9WbM6sUs43d/iaZpfPwleKxeiloOGiaIBHgtY3tmdpziWLxskfXi//xIYMDNE4Ir1lrNQXECN9RpbgpxO7w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Only a huge zero PMD in an anonymous VMA is split, into a page table of
shared zero page mappings. Any other huge zero PMD is simply unmapped.

vm_normal_folio_pmd() returns NULL for a huge zero PMD, and the split path
unmaps any entry which has no folio. So make the decision before the folio
is looked up, in huge_zero_pmd_can_split().

No functional change intended.

Signed-off-by: Yin Tirui <yintirui@gmail.com>
---
 mm/huge_memory.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b643e264ca23..dbcacc7b1374 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3184,6 +3184,15 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 	pmd_populate(mm, pmd, pgtable);
 }
 
+/*
+ * Only a huge zero PMD in an anonymous VMA is split, into a page table of
+ * shared zero page mappings. Any other huge zero PMD is simply unmapped.
+ */
+static bool huge_zero_pmd_can_split(struct vm_area_struct *vma, pmd_t pmdval)
+{
+	return is_huge_zero_pmd(pmdval) && vma_is_anonymous(vma);
+}
+
 static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long haddr, bool freeze)
 {
@@ -3208,6 +3217,20 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
 	count_vm_event(THP_SPLIT_PMD);
 
+	/*
+	 * FIXME: Do we want to invalidate secondary mmu by calling
+	 * mmu_notifier_arch_invalidate_secondary_tlbs() see comments below
+	 * inside __split_huge_pmd() ?
+	 *
+	 * We are going from a zero huge page write protected to zero small
+	 * page also write protected so it does not seems useful to invalidate
+	 * secondary mmu at this time.
+	 */
+	if (huge_zero_pmd_can_split(vma, old_pmd)) {
+		__split_huge_zero_page_pmd(vma, haddr, pmd);
+		return;
+	}
+
 	if (!vma_is_anonymous(vma)) {
 		old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
 		/*
@@ -3240,19 +3263,6 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		return;
 	}
 
-	if (is_huge_zero_pmd(old_pmd)) {
-		/*
-		 * FIXME: Do we want to invalidate secondary mmu by calling
-		 * mmu_notifier_arch_invalidate_secondary_tlbs() see comments below
-		 * inside __split_huge_pmd() ?
-		 *
-		 * We are going from a zero huge page write protected to zero
-		 * small page also write protected so it does not seems useful
-		 * to invalidate secondary mmu at this time.
-		 */
-		return __split_huge_zero_page_pmd(vma, haddr, pmd);
-	}
-
 	if (pmd_is_migration_entry(old_pmd)) {
 		softleaf_t entry;
 
-- 
2.34.1


