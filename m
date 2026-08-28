Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40ADFC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A6D56B00A1; Fri, 28 Aug 2026 14:37:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F456B00A2; Fri, 28 Aug 2026 14:37:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246186B00A3; Fri, 28 Aug 2026 14:37:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F15056B00A1
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:37:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7689E16052C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:15 +0000 (UTC)
X-FDA: 85151535630.03.DEDD6E6
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id A826312000B
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U8H2Mgiv;
	spf=pass (imf29.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787942233;
	b=ixIjEDDK4lmN/cFUA4Ek0FKbXOefNtOC96c5TBp64PqSPZIhrVcBaTGZooftXXnHtxwliP
	dtghzxWHzlgJieilQvPStwSjAwpHGOh6H+eKsAyI/Tg3lim6SgS7M5Wdfzx1SDdmhmJyF6
	O2/S5qVmbEAVRjW92D9nNC/3IajYOgc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U8H2Mgiv;
	spf=pass (imf29.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787942233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Jcn7GGjqrVUI/71BI99aJS+k5gR0ZeEnxqhpDzyiDE=;
	b=k6XEbqBqL9C0SrNotCKt7yN+Ags66/3WHv62QdebQVwYmEYBuCSfvGCZjAHg9AlBP1nG1H
	0e6iY+Rikzi1YQy+v4vCcsWJR1BtZKg6VrqqzVoFeIyZK5j76ybm8YROBS0kFaZ0biMXRn
	3Hqk6ovF7QbuqOeknz+/M+1w+vK/U8s=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-848643382fcso1516803b3a.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787942232; x=1788547032; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1Jcn7GGjqrVUI/71BI99aJS+k5gR0ZeEnxqhpDzyiDE=;
        b=U8H2MgivPCWKZO9wiQWrfJLEqzjjXksj27t/nI/cYW7b3ZnLHi68upRvZVOUJCcOGy
         OeXn/nLk8aM6L7oUoQipSD9+ma1f95jRa99LvoOpgv7DUsTTvHVhBbPDvFrh5YIIJDUn
         bHpnAmqWMYQ+rWLQIl7QVftuwCVxU9g2fWyYEX5kU6jkR1CRcqA2oOSHaxNdSrYk16lb
         wdCh1mzGg4H0wAaET13qeSN2djVVapEGo/H+BuFA3sWx+mWneuACGDVjqTZnWDfmskT9
         6RQOREdC3AkRsaheNCGAXLrBNbbhzf5ea/oABDjjxGY+FBWWzlhWVC3nnVFFtMb5FWpt
         WMIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787942232; x=1788547032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1Jcn7GGjqrVUI/71BI99aJS+k5gR0ZeEnxqhpDzyiDE=;
        b=J6EpgBAakieWnhYXDDGy4Q+gOwmrdZ3LFN2QJyFrijTITwTkB61Ou6SzSvW+QfVNuR
         dRJ8Pe2qdhpn5hHD9MsZKQNToCo6contUJTWAgCN9bIeYdmS32dFfuwtJOJa4dHGp360
         2ZnJFlnLh1dU8VOILiYGtmOWKZfcBXlgEFhQVxQ+NC93YcU9mww21VdnwwAbYAoMgYyb
         ta0tuGKmy4ExroKPk0eMrET2iqLD453YF7jE2zlGMJlvr8NUiFsUW5jrwDuOjYUDpSzj
         FG5PtBhuu3ispUUj83WKIwJKPtKIwLiTi0V5XQrWkpChRFvnZ88LBseQrKnR9j1N49iv
         n+Lg==
X-Forwarded-Encrypted: i=1; AHgh+RpH19CiatiHdF3tf1SKCfVw6U2FrPxIerggg6Edm4q5DAHqGZousf/dbcx4BLUKsegxD60YN8gNFA==@kvack.org
X-Gm-Message-State: AFuF++mLz/cSownEEJo/4/BWFYCc/kCA8vSNnQ/NTrRyI/Lz/qxnxVz0
	E3SCbDgblGYwAKUzUNuMke+uivEOSNVmOu91QLxKx3uNWgoa+CSLwspj
X-Gm-Gg: AR+sD10ya36A4Ie9toSU9puV7vU1BfJ/CpZcJmBJTMeCRXpGmQM2xIO/DVjfcgsQCAE
	xBdbY+GCNKUwUb9pIyaR7+gtYG0wiqckGisGqjyaDx6CauKrGD0TDiZeLlhfwvxSRC1zPewf4do
	EQGmueUXTjAS29PgKzoE83X621nEgBvfYDEwVHcx/eTv+JapfdDyzNVNdcBW5tg1r0vrr/gKMCA
	t8DtVAK3FGMEM4Z1TVq2GISnaqSZlcgPY66K+5tUAXx5PSC6mgq0wEtsEd4FiPMeKYu5sk7gYOU
	vNOIHzjJLqoh0WRDBldvdVtgl2dRoms8SOR0+7ECl0EweJ7M6YJZdh8HeqsNJyNVjPz3bRub3HR
	BK8G1dwjNOxMbOB0974UzJlqBQf2KMbJiObgZU0d/xGIN7DT8jSktESRnJlOhaTCFB32Woi2C7V
	QfpdqTYG1+RQ+vXyLdVLGS9iA976nraz2/npC0T8Ch7la6VJHSu1aDwKqNG9XPCcMZlqpuAWqRQ
	rL6iOyRopAsPRT1tQ==
X-Received: by 2002:a05:6a00:3311:b0:857:72ba:ff0f with SMTP id d2e1a72fcca58-85772bafff7mr2808955b3a.23.1787942232370;
        Fri, 28 Aug 2026 11:37:12 -0700 (PDT)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-856a2ea6fa3sm844230b3a.37.2026.08.28.11.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 11:37:11 -0700 (PDT)
From: Yin Tirui <yintirui@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	wangkefeng.wang@huawei.com,
	chenjun102@huawei.com,
	linux-kernel@vger.kernel.org,
	Yin Tirui <yintirui@gmail.com>
Subject: [PATCH RFC 2/9] mm/huge_memory: add and use huge_zero_pmd_can_split()
Date: Sat, 29 Aug 2026 02:33:12 +0800
Message-Id: <5e7add9f8103d3ebcc6edec70a8449e5336cb18b.1787941780.git.yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1787941780.git.yintirui@gmail.com>
References: <cover.1787941780.git.yintirui@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A826312000B
X-Stat-Signature: 87319fkbz8yfasjqqgatztzaff9o1zcy
X-Rspam-User: 
X-HE-Tag: 1787942233-868567
X-HE-Meta: U2FsdGVkX18OqUVV0B2B0gF3rmxNRVvzs7fGnSM2tKtzOCu68NzNpwkCBFllaQggMX6HpuicLdRzadawOkfThVkd/ZB4qXq3ZC5xW46iVtt+WxHr4Y9B6uad/Q8fXVhdp5KwutjNt8lEQ9OjRvn7f5GIOiX6u9D/bKpoVCcJm5GmKuLSI4SH8RKvLIocxRWOAcZgYWyOiSwtgGnVzBdQapYMJoLSBujArkS6eE0vzJUREM70UenwJf+97ukgRNysb61t7+VD41BBc2EtEnGXxt7vQu7qnwy/iHNS83fVR+wO5B1KrQHm5+vZCNu2GRGiIXicDH9rKBVBUfpcXaRykFYS+xgcLlyyFBbkzNuJrToeqj3WP4YOeDk/PEEgqRPbmO+1/+D9M/UF1na4UmL5rE07iQfIl0bcdMN+KHM58n2IKwglJjd9EC+8KDYKzPuSg3VbQ89pVWhLAHBTGVKRAYJOh471CrfvjVwdnwrHKc+J7eJfAF/egqtJNyx2i7+a1nC+kil+Lsb/oJnIzVOQOJj169e0XLAEkMJz9AputT75fIkQGYc0UE5UD73y/SH8/DRCquF7dmmDxmdCK6hMKhAaglNvvZ5uV8YmSMJH9h4ThsVV+ifjAEgfY01eI3P/7HxSC/9nNRKiZNomO13kcZuvhJgS/x5dLZnwjYOxyiVRrvBogZmhFQhdEZopUquMK/7FTimi/rc0ZUeOzjt9an6LNjejgPYhFuAdKMnJhGq6/+VHUk7qIMN/pzGKp3eamIICHQU7gTt6lZg40e6FdEASbEEa7bFZ8SqUE8oT/O1CBjmJZkM5Nv8QN7Q6WdbjEMTyD57pOgV0zR6ef3IAa4v7be1JiIGIWOc6gvDquHRev7jNCcY0nr8dvsBaR7bck67GdRLro8rtf80DH87krJPngD9jqivSKZNTXsXe30txBaNMt5xmkVlTmZdQ+EulsoQ/Ruxda81c0V9CknO
 wSC1zSmL
 ifIqkmkh0o/xFTHeF9J3HUYWIWJ4N4pSgS1SHbtBiZlBowjud/hyZz4J8ig+4sL8xDVfPhVjqCbLNyB+wcIp1tCV+0KMBWPK5PzVlt3pGRmkgtPsGbp2e5uAL9XW0bkTV6+Tx4xVw43g7iiOP7X70Dl59vth+ph5eust6JIlUQ8QUKdeDmu3k2Rqf+2JRdU0qme4SlsWRTuWKxPK6YE6TaSjzU7VYsIhVD+U0Qr6XblrOt+wUylPPGEbnQV0Mx5D8Sbb2qoW0Zm4b6Vbk6hGF/DiLi9S79KKca4y93dSEIfGG8Bto6hEkBWhOKMStqoFX8hwFxQo4gRv8iu/uhkKNjXDWfqFCJU7e3oLQxPKy1wmhMmX3VQHPN71vXKfnQBlZZqiIbv5zf9iJ0ZRoLwfD/x5BhRC7SBbBGSLUqsWqo73W894I6PfJI47jrbNiWV5eHjClYvlGpQOUi+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 8feabdcf6307..90d84f761619 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3139,6 +3139,15 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
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
@@ -3163,6 +3172,20 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
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
@@ -3195,19 +3218,6 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
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


