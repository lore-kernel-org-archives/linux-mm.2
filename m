Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77C68C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 02:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5669A6B00A2; Mon, 29 Jun 2026 22:15:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53DC46B00BC; Mon, 29 Jun 2026 22:15:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47BD16B00BF; Mon, 29 Jun 2026 22:15:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 123176B00A2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 22:15:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BED208D205
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:15:47 +0000 (UTC)
X-FDA: 84934963134.07.BCC6767
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id 33B501C0002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:15:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QgBi+XLY;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782785746;
	b=bk9R73+fcrLzkneZatX1qiCDyrix/HLu1Uf5J8WOkv3YsA7VgGpLXkWkDOxitxG44aNaM3
	oh+7v0QjyOkl+fahJ5ivZ98xKsmpO9hpUTYxs00RxfdZcKdvt+TR7Fam1xgAiyHcYhZZg+
	qXE48a2pWMVFDoTzg3YjvQ5BkX0uSOA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782785746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=TmwOM3kLmga60eTP4uif8DGldwNWcAncsPcoMOlri90=;
	b=FfrUmaRkJXJkphm3sjH9ZBCnzgW23K09iy9YwAzgGsrtUL2hZBEUuJqpxSiiXxfwJT8szZ
	fu3C0FFr68MwQqmvTpNeaSy4wNgnQ03cyjdUCxWX943nDwUS0MnpySPdx326GXALrPvfZk
	mohF6mXHuAbFTFfY/yJVJ+0K67QwknE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QgBi+XLY;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c1269e4721aso223469566b.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782785745; x=1783390545; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TmwOM3kLmga60eTP4uif8DGldwNWcAncsPcoMOlri90=;
        b=QgBi+XLYDXcz/tyqvDEWac7rxBuDwtK1pqbplCbjiU3vK3pm9Uwcm1mnXzIzv/15hl
         bdE3VBw3qSZGWihPNkD+iMTlLw9HCK0FqMbroSqDLQ0uEA/XQhEmE49g7585ajuopgWK
         sRoi2BZSNB0fTanK/wfT6ivU2k+J2lTPI9z96UvR4+cBfa4Rfwlsf7VXKqZXNxqWOXUd
         wUHJ96twahKu9TSjKPMZm0FwA+jG5XeY635Jp0pHdXTC7TSZ2Wu6aQcS9WEYxIiAUzGJ
         AhfghQdQGnb0r7aDSio3xAoM9G0xR5y28mC1yWwyzwwfRmpEKV29D41rH0qt0nrM9QwJ
         V3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782785745; x=1783390545;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TmwOM3kLmga60eTP4uif8DGldwNWcAncsPcoMOlri90=;
        b=jj46v4G2Y5dqj8eVZIDOHfa/VbVNcS4oYkOQcOzItD2rjMjeH1IQfN5iHTiciKSwFK
         laQxDo22rkfV+fkt48zyx1PaJ8PMVHFWbiLOSe68s7WqVP8B0VYhijFzrnYlO17AwaOx
         2hEQPDOG1JisjjBn3uqlgDucA2SD6nr2Jw0M2okyppAJh4NvxAmVzEmZGxc4eESTH+nT
         3dBi8jTOCvD3ACagUrvQiwbjUWcRvin1BdW5awd0qYxI8rMc6DyuDv5i9AMPQ7soitKj
         B0iDkaYGoU6e/tnA2rOit/xzVUxX8Tbf8QnN6QNm8jNaHYVOAMW4CI13CsyZTP8yXjZu
         WVQw==
X-Forwarded-Encrypted: i=1; AHgh+RpajuD0LVCVijZKOlkDaPWKinwt6nVKnJz9cMjXHYRbNEKx0vpVTkYoxDh3arX5cXvDtFA5StXAVA==@kvack.org
X-Gm-Message-State: AOJu0YwE5kWYgv+Q+JAE9+2tNv2xzdmS9YyXqpTEylBBkNzH0WbmJBGf
	Vm9R0KFzhY7HiB47+t3xLJCV0S+0Quf6cdR2cnw69Oym3rB0nRTybinx
X-Gm-Gg: AfdE7cn9vJ28RNSU+z9wQxuFs7WvPFvcxmjaWxAFzABymrQaQJjOrVLL+klOS4Eahud
	riSVaRnEntJsvweUgRZ6ckVX8yi/1FX5RbiNmnD43qMRg742rQ+Chjh1+nDMKFQ+jg3KPOv9sA1
	1kWQZvTqhDoELUCN0Uz/FcvIfxdB+wV+ieDCor/O07ijAjdqfKm6LHTKPWXpndiqpz1MItk1xcE
	1/xb3TTt2yXh8pO+okBE/3tirahze7V2lD58/Dsr4jEdiWq5iprBRLHMPbFTwXXT7JleaPhMEHu
	zMDze0F1Jl4Ju1OeT09KlkaidxQ4hHpdDhRjqOXlUZvnjejbRL69ckUI4LHKXFoHtQ6tCAIwT+E
	rPh/Rm8XYoQR6l5AzwQMuZD7y73k5sCm6LO1ZQARUWYJo34J5mxKNLAlOK/lZh7QUaZL21BimJ6
	IKp0r1rju8qFA=
X-Received: by 2002:a17:906:f598:b0:c12:34ed:e100 with SMTP id a640c23a62f3a-c12873e7ce6mr70015966b.62.1782785744410;
        Mon, 29 Jun 2026 19:15:44 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6987c3b7335sm323776a12.11.2026.06.29.19.15.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Jun 2026 19:15:43 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	balbirs@nvidia.com,
	sj@kernel.org,
	ziy@nvidia.com
Cc: lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>,
	stable@vger.kernel.org
Subject: [Patch mm-hotfixes v5] mm/page_vma_mapped: fix device-private PMD handling
Date: Tue, 30 Jun 2026 02:15:40 +0000
Message-Id: <20260630021540.17297-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 33B501C0002
X-Rspam-User: 
X-Stat-Signature: 5gdzdiumfgdq66331yabkre5sdhyqnzc
X-HE-Tag: 1782785746-740923
X-HE-Meta: U2FsdGVkX1+jtGA6GmBysKAGWxDej16jMYPMX043Njy6zf3L4Beqh8NkR+QV9T+j12m+7ZpWPZMj05qggP5oaufPeQ4yb/mQ1B2LT8eQj9h+Rt62dDLDnYXwGjmUnTzVwoDrJgLcbqY4qFKmmkH4b/ECEckLyD1sj9dfaCWhRdVnSJuZQLUV88m9Px0GBmrXnS3chVW9lJ5oB2BRu0316EBGbWdtslrQxwmHkZD8KcOrgcSJSC88IimitmYPUyrsItMXWMEFelKC4PrqVtiyOKzBJ7Y14/it0Ip66MCVSfNWt4Yb2Cx5ZW41k9LW6OpTSiEd+3/FQ3ahwMFy+JcHLOiHt3C9e/jkM5YEoyYsRUeJD1mzCotEqj3FW8RMZI6M+niG/E10RoO9+/umseM30xw6nrC7i++IGOxYLH3usBegFtO+QD7KNnFSbAvYKjlUHjH51Uy51UR9D54dd7WOhshMC/3a31/s4tCTsDjMCa9fI2Z8ljCUm++hbXYYJI0kxB19VzBg8GPsauYfZf9TyR0qtenFbDgrKEnzWw1zth9u2osM+CYA2T6sgDU0HjcGwq2eZL1rn9gADRMfX7eeDKr3Rf/xFYMWpeAnLbjpzuZO4aYm6Mv7qgeyqVggwPSex8oPhr59hxE2kOeMHhVJVHxeJ8ppXRlNp9vmyVydCzT8PoIxRvRC8DsHMg8N7pKdPoURMrMpnis6Dwr9wHd2MUJEBxiPgajw2arY1M1r1gyd1Xji6Kb4CpNNbvMh+GqLrmUl4Iqe/qKOSy+AV7LLN+pUokbYKH0MNiPx29T1DRQp2BWk7sae8bLHQdMsZnhbd4UDqLO8t3CEpgE0iCpGeDFQkHE1r8xG3aqAYG4dPxf5uUFP7RqU0/7qhsp6iEU2ljGRWuasrY0HQKcuYNTePNsS3SX5IvJcJUJ/H9O/0IuVNYtoqsRQUAG+hFXCfW8KRhh2/RYvRRVaKyQdxUx
 6GXzMUiz
 j8t8uHJZnEC/3afDiLPOrkTEnhhZm7srHe7a5+SMpy1aH2I73F559Mg3njiVl+fjrZQwtYZ5/hiunlgMT0ffItYFhPRy6/Kvu98R5eiTsapfasrERXoF0ieCswq2TihCzq91Rd4ThQllRa6Mq1WbqKAjGgdtOd0lIui1Lvm/WgcwZVY7WiBxeoY3Udv9sv9uXOw73Y9TR+q4HKE+y3i9V/po7tgXgG3F8IGDjY7ODunx4IN6xTE+C6+TjVbsJ841cL0tDFv9BRYO0NvEmWqFcdDp6FMHgMjT/BNx06Bl2ZTtY14TS+JPOtjq3W1kBTSD7JU72kfOOffaNjvNjmXn4kGuC2ctjE4GUJVwsdZ0ntqaZQ+Nf4iPVZ180M4Igieb/omiTUOc5Egh7JNpcBouu/cBGWj9n3aSxpUK8qTzOPYT4pHyusyrnOY0JZ110uIEFhKEWzCyrzusxpByiXys/I97gy3u5yJPmVoBjMC4SUwHgdKrXc+2iUsQe/OrFiEAL3bhszmdIhcR5yP2nf7T2wYp7+nJ+THRBmTuPomFizK/1tljz7gmqluGVYHajhAsfmSNM+naueqEtMimNDB9dX6s5F4vCC6pR3Bht7m5y1Tsvd/uTY/QT88OOCGx30+FoZnMV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
device-private entries") introduced the concept of device-private
PMD entries, but did not correctly update the rmap walk code to
account for them.

As a result, when page_vma_mapped_walk() encounters device-private
PMD entries, it takes no action other than to acquire the PMD lock
and exit.

However this is highly problematic for two reasons - firstly,
device private entries possess a PFN so check_pmd() needs to be
called to ensure an overlapping PFN range.

Secondly, and more importantly, if PVMW_MIGRATION is set the
caller assumes the returned entry is a migration entry, resulting
in memory corruption when the caller tries to interpret the device
private entry as such.

In addition, commit 146287290023 ("mm/huge_memory: implement
device-private THP splitting") allowed device private PMDs to be
split like THP mappings, but again did not update this code path.

As a result, we might race a PMD split prior to acquiring the PMD
lock.

This patch addresses all of these issues by invoking check_pmd(),
ensuring PMVW_MIGRATION is not set and checks whether a split raced
us we do for PMD THP and migration entries.

Instead of checking for a subset of the cases after taking the
pmd_lock(), put device-private along with pmd_trans_huge() and
pmd_is_migration_entry(). Also remove thp_migration_supported() as
it is already guarded by pmd_is_migration_entry().

Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
Cc: <stable@vger.kernel.org>
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: David Hildenbrand <david@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>

---
v5:
  * put device-private pmd handling along with the other two cases
  * remove thp_migration_supported()
v4: https://lore.kernel.org/all/20260624065353.1622-1-richard.weiyang@gmail.com/T/#u
  * refine subject and commit log based on Lorenzo's suggestion
  * put pmd device-private entry handling in its own if branch,
    suggested by Lorenzo

v3:
  * remove cleanup part, only fix the issue for device-private entry
  * refine user effect description based on Lorenzo's suggestion

v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiyang@gmail.com/T/#u
  * specify the possible error case of current code and user visible effect
  * besides fix, cleanup the pmd entry handling based on David's suggestion

v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
---
 mm/page_vma_mapped.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 2ccbabfb2cc1..2d6c58488e3a 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -243,21 +243,30 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 		 */
 		pmde = pmdp_get_lockless(pvmw->pmd);
 
-		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
+		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
+		    pmd_is_device_private_entry(pmde)) {
 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
 			pmde = *pvmw->pmd;
-			if (!pmd_present(pmde)) {
+			if (pmd_is_migration_entry(pmde)) {
 				softleaf_t entry;
 
-				if (!thp_migration_supported() ||
-				    !(pvmw->flags & PVMW_MIGRATION))
+				if (!(pvmw->flags & PVMW_MIGRATION))
 					return not_found(pvmw);
 				entry = softleaf_from_pmd(pmde);
+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
+					return not_found(pvmw);
+				return true;
+			} else if (pmd_is_device_private_entry(pmde)) {
+				softleaf_t entry;
 
-				if (!softleaf_is_migration(entry) ||
-				    !check_pmd(softleaf_to_pfn(entry), pvmw))
+				if (pvmw->flags & PVMW_MIGRATION)
+					return not_found(pvmw);
+				entry = softleaf_from_pmd(pmde);
+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
 					return not_found(pvmw);
 				return true;
+			} else if (!pmd_present(pmde)) {
+				return not_found(pvmw);
 			}
 			if (likely(pmd_trans_huge(pmde))) {
 				if (pvmw->flags & PVMW_MIGRATION)
@@ -266,17 +275,10 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 					return not_found(pvmw);
 				return true;
 			}
-			/* THP pmd was split under us: handle on pte level */
+			/* THP/device-private pmd was split under us: handle on pte level */
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
 		} else if (!pmd_present(pmde)) {
-			const softleaf_t entry = softleaf_from_pmd(pmde);
-
-			if (softleaf_is_device_private(entry)) {
-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
-				return true;
-			}
-
 			if ((pvmw->flags & PVMW_SYNC) &&
 			    thp_vma_suitable_order(vma, pvmw->address,
 						   PMD_ORDER) &&
-- 
2.34.1


