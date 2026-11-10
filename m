Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5CE4606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gudwJJIp
Received: by kanga.kvack.org (Postfix)
	id BE7F16B05C1; Tue, 10 Nov 2026 13:00:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B49846B05C2; Tue, 10 Nov 2026 13:00:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A13736B05C3; Tue, 10 Nov 2026 13:00:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BE646B05C1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:00:50 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC8CF80A4E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:00:49 +0000 (UTC)
X-FDA: 85419975018.03.3DA9817
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id C9BE54001C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:00:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gudwJJIp;
	spf=pass (imf01.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794333647;
	b=aa0Y0xVJsDI3UVfMKAicDr6lEQO4SR0dVfQ0z3L5FPvVKPWyfL6GG7sYqBTeAqXmjMeoHt
	uEbrizo0itP9aqmioTyrJbyHxiztlseoBSKfw+Mt5lGkXEU7aytj1EqdykWMdqWO9j7KAM
	1C7lpymtMDscfMqYB0h0ZpG+yhx8Usc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gudwJJIp;
	spf=pass (imf01.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+9N5Sc1Y8ONMq1nw5Y8gb9n5wSCLwY8oTDzk3ovJiVU=;
	b=IR4chM65H3x4kt2Go/U3R3C7wVoZAuSLvWKOlAGTSa7HIpQnmHMdVGnAefoZrwAjtb3pJd
	7U3tpBuDt+QJIX2MdYCH59pxFe1s4mXmxXEKHklykdrdz6IMk9zo+GEFjcYiSB3m4Ur6Ua
	VfMXnF1DvVk2q0XQKh6h23/tI0GmXTM=
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1931ff67a29so2634574c88.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794333647; x=1794938447; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+9N5Sc1Y8ONMq1nw5Y8gb9n5wSCLwY8oTDzk3ovJiVU=;
        b=gudwJJIp7yFgzCs0r0LDna7Y7pI3DGI4VOjN7IIoKaRmMfVOlRTN6ckoD4rBlHsGSO
         LOxBJmsE7mpBu3HX6zxIBXQa/NkYgIQTw1/Jo6DDDyFyMMiPKqfwauD7ghYm6ccwNT9w
         zY+Oa5Yet0YTJuNbUmY1F4N8VQr8WtCD/YfZha7LQPrn5J6+nkY9zYSn+I3J8j3AeWe2
         Vnx7plmsz0gENEB02ujDb6aBkN5LoAv4NWQInokoPQSEpvjRsnGKsroxDW/HwoRyWB60
         mxufcCTxn+jWMI8hA7G/uXXCnT8+JRGs9TtYynVlnqQ6y1QeQb1fv7X2boRdZdqeO8NV
         p4jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794333647; x=1794938447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+9N5Sc1Y8ONMq1nw5Y8gb9n5wSCLwY8oTDzk3ovJiVU=;
        b=DuH/Imu2ikX24gstOZzPOVuVuAl/3EpW30dt37tXVOrv48ER+CuluXrZSrTJCFmpbq
         OQ9Gh7G4SrsTE0JpJfc7riVH+91r+QWNcfElAFQmkFazyFgPIVREUaal19LrL9zTQHrP
         JLwSZZYvCTbXWghSFIgN4lN8Du+N92VNvpsaVkp1cih3gSlbmbqDgEv3MUNmqLTiTv4i
         1f3AZ6HRTfNlru0yA7uHcVw6VzQA8zI7J0x64rWP1RjvaLIM1l6g5ED31JqaVf84PmHY
         5Jt8cjTEDG0vswwYeD9+rd/hKagMRLuKRLFh5e4Lzxrvq86q4IXNTyERxIbLBsA7mjXW
         zHMA==
X-Forwarded-Encrypted: i=1; AL+hErGR4DKdKGFb5bbvwT3H0HQnkZU2NLXk2qxEL1Cc+ZnhwgBzDyNK6OP0PvNjjdDbFMriZyFV+hn9Mw==@kvack.org
X-Gm-Message-State: APuU4Z9MhNzjD5tOtfWn9TwRczDdSNHr7MaxVQuemXYDe7CTn3ePHl7a
	FuALHnMrHBn2v8nk94B19YzgC95hcxp0xOffu1XgTaK+ZI91fywg2bp6
X-Gm-Gg: AYBFou2CJROubWU9B0+flhqL8VNLgJIxZDRe5nru0k0pBe7c7W4MJprTaz0LTOIi1Nx
	ZENtlS8F/gd8J425WFdP5BMT/N81ah4FK2ZAdbr5TVY0K4HiVx/DBDXhoCghplEyw/y8Kpu7Y+k
	1GS/0yZCLyDjBAFwyi1DWSIPEdVi5eN6/BQGprmMn/7CB4jffJzQoJWnG5wtRmdbIk/UW6Srpu6
	LtoCKbgjyE41Kd6OhSirf7oWlAVszW6TJAW8iugHdTfuiI3wG/lXzM1BXdlXNNk/Kz2JgDpmF1I
	vFkOh124jaJFVJeM6MQdxVS5N7htRYmPrE4VeZsjEb2HZ4KgBpiqutksndpjDQKhqfyOKEhlyxD
	N9MrQkSillNFkwLZmcZIikwSQT4F0gCk/pLsl46a+A78VEZ6RVm8+m7KFrnLEHNqvhTY5W4HUuN
	dQZ8UO4S7H5wWj7I4N1OaA+Z/V2AlcMz5YdM8u8GCtLY9CgWNS9khSaxKV5b9r9Ji/X144QaeQb
	NIB4uiyBwn86EJmERi6z3oPQaemahMfkobAJKD+OL/umOq/1EYGvYzlf7VLf3MAJwx+1xTZeBI3
	+nT335wXxidPjhjbIYI04Q4Y1dPSn1E5Hr25TP+Ec2Udl4cEFKESswRW5ZQ=
X-Received: by 2002:a05:7022:b052:20b0:1ab:fe29:5081 with SMTP id a92af1059eb24-1b3b6073e47mr5274788c88.20.1794333646393;
        Tue, 10 Nov 2026 10:00:46 -0800 (PST)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b4b90csm7624260c88.14.2026.11.10.10.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:00:45 -0800 (PST)
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
Subject: [PATCH RFC v2 5/9] mm/huge_memory: dispatch on the folio when splitting a huge PMD
Date: Wed, 11 Nov 2026 01:59:20 +0800
Message-Id: <20261110175924.2945538-6-yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261110175924.2945538-1-yintirui@gmail.com>
References: <20261110175924.2945538-1-yintirui@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C9BE54001C
X-Stat-Signature: 5zdgqt9b8g4in87o6txf3spka7517783
X-Rspam-User: 
X-HE-Tag: 1794333647-94189
X-HE-Meta: U2FsdGVkX1/+DbLB3waACPvH6mS9WzQhmMCV3TNSe44uO3mPKUNjz62jmm5rKPERyPQrcAGxPANMJOVvC09q6mQBjHmr13g81qZMEWGO7SWHepVj82+0OYvZMiwwh+opm4OOcz4WodJ9JBFpuh5N6gTh2msYd3B4+BXZ7IxLdbUXoITjL7mJuMnHWY71XcSpnB2hWf2SYRFn1zoeZWH8FuRiXR8cg9WqxYDfGqPR5EY/6rSYgADlhFBe2f3Z9SPyWX9rcd2D14KVBSyy3zv/Pf8tpbwY3WenMEsqmAnVQyWUnlWS8iCAhUhsMVYxpHH1n8iLzvariL+B8cRAA041JfE8wgSjJyLEpBTm0OvRn+Pq8jmgbEZy69Kb3OA42Ad/x/c7AmeK8ZgMj46wSTVWozSyNLMswjZTiC5V5PsYqIQctfpltdoKh4L2P77CmehCLO7rUq8d+wrSwbT6AeeP+KCuAeJ13e6/SocHPWLCcr5T2JaGXQQ98PTwAhTfCAr3uBIM8+1B/y04frTODXMJDG0Mwwu0+gihL548vKcjCBFcs+ggJyepOz/lqhBcrMyg4xcZLPosGcrfKORDcr3+AvK94vG4UoZVej8d1ks/9lyTZCVNUlqqOrNDfOIXWaWW9IHT1BMH7Au3h5wk9D8FhVxqNJhlBOzCN2QqwEqT6FFStNvsh4OU0/3ckdtOGE4DBCeSYkn5g5zhNy/nBLnbUIJjz54CxHGaoa9d1tgFvaCzjnIgXm8yu+TkzbAweAElUb1KPqy1nCNMMgUgQtWSKCmWfLqI1j3PMUJ1lacd0RYk+qR5TTp864pSa0MEW4tOjxu+uj/PAEldQzPn4gQAafI/WHpoVOX1MtORFLviUdCexwx0vCy7lph2wnlIAfNJ1wqIBh1BZdsurx6KdFhcncHLtqSUMR0ITOGT5P6csVUiow+mSXjJ61fDujEvWR8qI4LgsxDK0cunVUoDNn5
 Bh0eiUxq
 FwpheX70IEdxVZCpBGyee40bPufGmjMFut6sngwYxFfN/t8NhVPe4bLNjQeZbyiFGd1ZDkUo75zJjmDF+zd9gjOJxoxgLCXIbZBtc3nUZjRHxJwuOHaDdmORgauMEWlnQhwAxBIMtUJI4wxnl4vLOSZe/ZCGuZCoJzabx5t6Wc6XTOLstukaVhNDnTa6DYd4pq89akKVN3eNWfUtgKOfnDty/FRBdCHDuKOSc7odGKgiuPG05/l394hn35qoPEe3dgkSlgooDf2iTd5zDA+jfHj061fgNbdbyE04E/p7973iuwMB3Gz1xd4XiLYiVN+mc9jQIDVzrENpkQvtcGGdObpyA6mbIJAGbq5LezV5jNhimm/J2cDZfdPZ43Iiy4KBgZotqIiWK+mlwOqGmwh+jVnX+s+vitZq7asJB4yHVa7MZ4cGxoEO/E/+rKcTKGv+fXOPKK17EOZMthvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Only anonymous folios carry the anon rmap and PageAnonExclusive() state
needed when rebuilding PTEs, so decide the split path from
folio_test_anon() rather than vma_is_anonymous(). Treat a NULL folio as
nothing to rebuild.

This only changes behavior for folio/VMA mismatches, which are not produced
by any in-tree path.

Signed-off-by: Yin Tirui <yintirui@gmail.com>
---
 mm/huge_memory.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d0ff2957e47f..dcc8cd380da2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3289,7 +3289,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	if (unlikely(!is_present && !folio))
 		return;
 
-	if (!vma_is_anonymous(vma)) {
+	if (!folio || !folio_test_anon(folio)) {
 		unmap_huge_pmd_entry(vma, haddr, pmd, folio, is_present);
 		return;
 	}
@@ -3299,14 +3299,12 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
 		entry = softleaf_from_pmd(old_pmd);
 		page = softleaf_to_page(entry);
-		folio = page_folio(page);
 
 		soft_dirty = pmd_swp_soft_dirty(old_pmd);
 		uffd_wp = pmd_swp_uffd(old_pmd);
 
 		write = softleaf_is_migration_write(entry);
-		if (PageAnon(page))
-			anon_exclusive = softleaf_is_migration_read_exclusive(entry);
+		anon_exclusive = softleaf_is_migration_read_exclusive(entry);
 		young = softleaf_is_migration_young(entry);
 		dirty = softleaf_is_migration_dirty(entry);
 	} else if (pmd_is_device_private_entry(old_pmd)) {
@@ -3314,7 +3312,6 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
 		entry = softleaf_from_pmd(old_pmd);
 		page = softleaf_to_page(entry);
-		folio = page_folio(page);
 
 		soft_dirty = pmd_swp_soft_dirty(old_pmd);
 		uffd_wp = pmd_swp_uffd(old_pmd);
@@ -3366,7 +3363,6 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 */
 		old_pmd = pmdp_invalidate(vma, haddr, pmd);
 		page = pmd_page(old_pmd);
-		folio = page_folio(page);
 		if (pmd_dirty(old_pmd)) {
 			dirty = true;
 			folio_set_dirty(folio);
@@ -3377,7 +3373,6 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		uffd_wp = pmd_uffd(old_pmd);
 
 		VM_WARN_ON_FOLIO(!folio_ref_count(folio), folio);
-		VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 
 		/*
 		 * Without "freeze", we'll simply split the PMD, propagating the
-- 
2.34.1


