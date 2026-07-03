Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A53A1C44500
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 11:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758BA6B00B8; Fri,  3 Jul 2026 07:42:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 732546B00B9; Fri,  3 Jul 2026 07:42:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9D66B00BA; Fri,  3 Jul 2026 07:42:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3791E6B00B8
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:42:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B82901A0501
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:42:56 +0000 (UTC)
X-FDA: 84947278752.17.96A4C53
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0291740006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:42:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=k2n+xkzc;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783078975;
	b=EOlRrSWZGLA+vfwpnPmQZaL2JT6DjbLaoaCBn2JPKdLTi9tS3OsF8oeb7NqZKBQlgvtQgP
	Xu3tzGLBfg9tTZBxHp+WPo9eD9A7yX+WQ7Elke9xDZ4ogGmsBlj2lJE7GEzdcOG9Fm+jb7
	aD5M092WkUMfIu1V8VZkvWZMXfW94l4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783078975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SWBD+9qQtzjkzS2vxK4tZ/6Te1U+xHeFS85kjLJ6Phk=;
	b=OHxUO1B+TCCJeSvsqQI48xnJai8g99OLKeeVlwOtVVpqVXzl740I2uyanUqjQWWyghKzYV
	UahL+ldG5hb7jQ5mMJRsv/yE0BehYmKeuQ/75CEcoxZTv1jXP8wL8U0WDwY+jCn4JHOgKp
	rek+q18bNperwTnJCUU+sfZf5E4Ttl4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=k2n+xkzc;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B647C361C;
	Fri,  3 Jul 2026 04:42:49 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 934E83FAA1;
	Fri,  3 Jul 2026 04:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783078974; bh=h1IY5vXGtS5qm0GLFc9NhQBQjfsdy191rN1Uth+Oiss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k2n+xkzcwCyd3J/xSa4zKVaUpOHOy35BxeWEYAFbGOCKUM0tXaNOstPt5Q76BSk3n
	 yjtzVV2etNN40/5idIaXRjsy/phcdoOXCHriXGcjm3ZFmeV1EARux/ZHb42t7GgVAC
	 OzlyxC0kw2XvxGBk6gm4fmcJpkt6Hip6x3aoeeAQ=
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
	apopple@nvidia.com,
	rcampbell@nvidia.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	ak@linux.intel.com,
	nao.horiguchi@gmail.com,
	mel@csn.ul.ie,
	j-nomura@ce.jp.nec.com,
	pfalcato@suse.de,
	tglx@kernel.org,
	dave.hansen@intel.com,
	jpoimboe@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v3 3/6] mm/rmap: use huge_ptep_get() in try_to_migrate_one()
Date: Fri,  3 Jul 2026 11:41:56 +0000
Message-ID: <20260703114202.365553-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260703114202.365553-1-dev.jain@arm.com>
References: <20260703114202.365553-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0291740006
X-Stat-Signature: uppahmkkkxsm3ai8sd3y9erhcj67emuk
X-Rspam-User: 
X-HE-Tag: 1783078974-860880
X-HE-Meta: U2FsdGVkX1/EhnpUOBN2//oxlRTiysfiVRpGMKYRu+P5qy6Vm9sRdTdu5DasXARwvxlbTSqEHeevC6CitnWkAH/TBeov1gG9itjuvBURZ3OqEjjBeqHjvHbJj2C2PVI3R8IFC1iKdBR9aFZEsp2zG4uR13Xmg94+ljZ/B6T5dzGk+M4p2p5pyB84jVcSt55un3J49X4g3Z/c4vRBq/+UoYymMJ7WvFl0NtEArnLk+OuubCdoENjeq8ahvCm6XyxK2Fjy4j1SJ1ZZFvDGXNnqWZ4qPI7xeKqVPxhqEgO6aQ0JoYjt5H77hfmg1bCmCtbbD0Wvf4pS5nkjiJNnymT6ijFSUf1pxslXGCQsvvU5mkR0gfFXOAXzRtpjB68VyBRGTAXSdkh7kN69GvA5HdDBhbzpgUyo/ITHLUxL0QfV2DzhXHWlll2TwxXKr/ax/DtHy4xmhE4BjWuJqMd7Goz3HzWUqmZj+xv0FZYButOQ5Rif2EGxhTdTxVzD0T6yB1a3aMnWoQhazzN7GxpMCnTTwR2ySYd5lgkMugmXoae+NJToZteYQzNPLRoGvp78ULsYouliAjaln87/hrKXzOqhrmj2Y7Zv9pMwvVPsW8hkcUkc5uYnDM03lxp/lComTQbnsIPRLAumMk2lkG7ARMMwzd5H2DHD3a9aVC8khbL8bKaUMH92DiW2Q4TwFwphgDH4YzBWpXXlM4XTmhYcnwbtyOSwt/at9TGW6sp8KuiISPS34AC+arDVpYSZyXibiC9VlNen3S8qlfvgfyvVCfqO7EUhbJ8qRQ7iKTxsc0lCV7PelvnezCMqoRNPn6r0SFqOwiwu5a1njhjiRU6yR/k3h9SejiV3Ik3HYMW/cKjx7Uf0FaoO1jSjg5G/l9hF6RQDe/sQBn/T1MihvQ+xmlhzDBlOtl495vB+WVBwSyJy5TB9mfj2kQNjJKQfYplKbd/wXOk7RX6Mzg2bq0GYXIE
 hnUxFHnJ
 FieljATGEHfrcNWA8pL0ft5JRcuVF1AnbejOZrGDRg45wTpVyjCt00OzxdLVzJNi8MHRII+R0VastF89hOvOEP2X2PjInY5xST0En1i1RrqnO7k2msNT968+mB2n0Xp/mUfL/xp9J+hB1dOFTLvpuB9n1wNvTxNFXgmFtBT4ByDA2iITdoKSdSy23E8BojaR61ycmEOkdkM7g+s/9qhdVF89gemrFi3qDs4oLkCC0lSxBl54c4tf0+D7GdeQ5VFw9NplpAYl1TCqi2xDUsONUOBV7+4nn61aljsovGiau7F1TXvJ3arwOSs4huOLJ68D0r1ELIojzKes94W2CoRviynBtjC5DGXaHTXkUwoj+aUvDmd6y3Wpbh9zZyb4l4L7jwwpz8eg0xiSvSLI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

try_to_migrate_one() is used by folio migration to replace a present
mapping with a migration entry. For hugetlb folios, page_vma_mapped_walk()
returns the pte pointer to the hugetlb folio in pvmw.pte, but the code
reads the huge pte entry with ptep_get().

On arches which provide their own huge_ptep_get() to dereference a huge
pte pointer, accessing via ptep_get() would cause pte_pfn(), pte_present()
etc to misbehave.

It is not clear whether this has a trivially visible effect to userspace.

Use huge_ptep_get() to dereference a huge pte pointer.

Commit a98a2f0c8ce1 copied the bug from try_to_unmap_one into
try_to_migrate_one.

Fixes: a98a2f0c8ce1 ("mm/rmap: split migration into its own function")
Cc: stable@vger.kernel.org
Acked-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 03737daa348c0..ea4ad5e662f7d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2505,14 +2505,19 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 		/* Unexpected PMD-mapped THP? */
 		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
 
-		/*
-		 * Handle PFN swap PTEs, such as device-exclusive ones, that
-		 * actually map pages.
-		 */
-		pteval = ptep_get(pvmw.pte);
+		address = pvmw.address;
+		if (folio_test_hugetlb(folio)) {
+			pteval = huge_ptep_get(mm, address, pvmw.pte);
+		} else {
+			pteval = ptep_get(pvmw.pte);
+		}
 		if (likely(pte_present(pteval))) {
 			pfn = pte_pfn(pteval);
 		} else {
+			/*
+			 * Handle PFN swap PTEs, such as device-exclusive ones,
+			 * that actually map pages.
+			 */
 			const softleaf_t entry = softleaf_from_pte(pteval);
 
 			pfn = softleaf_to_pfn(entry);
@@ -2520,7 +2525,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
-		address = pvmw.address;
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);
 
-- 
2.43.0


