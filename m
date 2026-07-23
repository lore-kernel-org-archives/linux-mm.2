Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47E44C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5AFF6B00AD; Thu, 23 Jul 2026 03:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33AB6B00AE; Thu, 23 Jul 2026 03:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B70216B00AF; Thu, 23 Jul 2026 03:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90F9E6B00AD
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:09:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27A09803E3
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:09:59 +0000 (UTC)
X-FDA: 85019166918.27.E61EDFF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6984714000C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:09:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IEQzhbRr;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784790597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=udoFQkxO2oOWVLlP0eCTJHSO6amN4Qsw1FnuJwXSFeo=;
	b=JliiN9Hyl+512o+Qtf4nTcY2nhVrv7U/mYxGjokhr0REIIYB37J3XDAHeHTsc236p8UYnh
	541lgibct5yI29PH0IuuWV/D9IMCMa95pPLdtJUrCJXkU8HZB6pG4tC3jtALGDc56azir1
	mWAh47CDDqHkHT/f1xKIsHycw3pT+4w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784790597;
	b=Zm6zODp/fcLtn7JlqOBEvD5ncbBicI6BPFC7clcR5okp8vzGZfJ/7WFJvgejB9O1cxH3EO
	MCO0IPH7IO9yJs3JhzUSMVpqP2AR+jXGRButjuV2pbHhnLWY3xhlGu1ktvXDMmP34wBAuo
	clRO4JA86jLcnCbWCUCIQgsrII5af2Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IEQzhbRr;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8174D176A;
	Thu, 23 Jul 2026 00:09:52 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C92EB3F66F;
	Thu, 23 Jul 2026 00:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784790596; bh=yBeFG6ZrZTecABCeoXEb9SJ6EL++3Ahm1QCSPbW+WP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IEQzhbRr4BfxqMjqiFb2W7EeZ3ul3RzHqDjJWUZ+BBOBoJB38lL5h/lHv1lT0CiQ0
	 V5Di1hM1Pv/Pskgb9mgj6Cb9QLAOsoEOcn49UkQ+yczy4jfIMtevNRvJLFpOXmbibp
	 BBgx3V9bbhmWjY0O+ZTB10LAP0phn8zAHm2jYAyk=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH 5/8] mm/internal: add set_softleaf_ptes
Date: Thu, 23 Jul 2026 07:09:01 +0000
Message-ID: <20260723070905.3422276-6-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260723070905.3422276-1-dev.jain@arm.com>
References: <20260723070905.3422276-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6cw1ih61jkesr8fcsf8wg9ssoqw4g5ef
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6984714000C
X-HE-Tag: 1784790597-789872
X-HE-Meta: U2FsdGVkX1+GseH+jepLQgkSxzqijHJN8jvGmlgOCVoQTWDVc5hYVUkGlEkOlpv0UOJighgCOfql0LHvmi/h2R0iq+BQnSFsL+F3MYh7VZLoJF4NGiQvuA1zYPpLyIw5TjrNEoOgZlYPvI7hzwdJyP1sYa63pd43pJagWWCtDBJld9TL3kf2ycyOjGYi37/9Jt4188bbV1prpw1jl6ohBsFTm8UdM6MwX+ff5Qj0UpXsxVMdwzNOPvJJBfT616ysLB2df6XXAIOuHFTtgavMpoi+seKaAISV2jHkyL2qtTFILWCN4uSTkrmLZ2PevcvlP86DN0yl371kccB1I7o4Im30cvibb69jBwG69gnsC6JxxtvOj8lT2W/RUCw6sLrSrWpdm4TwObArDmOAR0365akFS41L4AI7gKv8TYOU37wNliNY7gWYqS94D2eWMKfCTfOCb2lZKQe8Lv/jVycQlcaO8xi9I7+FJJHXTrzI/JZ9UF1/oX1zlwST7UzQevs71tPNRbp5zfC6KVBVK6E/A9eaDHovimjyxR6Xta5LXZAMFrQrFyZqefjxVP9oUcRzJSaalMMEuvctrnIcR/w2MiaCKp7oGPS6xrmz/BejX/1J8uax/AONGiwjA9C6mO5rJ7VPj8k+7WQHP2HoDYIqICG8dmS9yiygomAWTIFtgfqN1JnnEpIRvT4kpVxxAO2j45Blg0DFFgOmhPWkwsx0VzXc7ESY53W/yaO6DXLNHXbSK5Y/vlPdMz41kmkvZugjZPvqGvaKaYWA1vvg8fvE0bNoTLuwck5Mnck3hObZQXiELDm4ioKUiTqrt/BhLJO7oIyhNlc4UnVzm6NCECvl+YXO7b8oEO2mlMuyUVNhLy7QO3IjBSFYQ2Ol8q3TA8jimw9H9roCrnZ/spyPtYkm3ihXN3pouRYnGXGKrMPzFLSorw1/ktTKkk61oataLXnKnHxPkfirFS6HrtGQu2p
 uaqJq303
 B+bSsOD9UFf4QdLr2B58qEtNEpMtQ30vkWVDPmkDfWSw5DoNqT2HuCy0NfzJGL67Uomj7AyXYYb7xEW6/F4jbEpMw27nQjGTxy7vzPirNA2T/gR9yfguimT32LZpVa8xgPREXlKCbWgOgfm0ilgOdQl3cmV11hbG21FNngJR6A/W61Vra9OGVCbvZyrbjpShmV35ezj8QtmFJheFxAN28PMcpxF2PQa2ahTZMjG+rdhebzmkeu5LR4OWHFKPvX4Psywsm83kV/eTxyqgS5iqdlWi6/eeBCvJZADuU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently we have a helper called set_ptes() which is used to set
consecutive present ptes in the pgtables. To do the same operation but
to set "consecutive" nonpresent (softleaf) ptes, add set_softleaf_ptes().

The softleaves which have a notion of consecutivity is swap softleaf,
and those grouped by softeaf_has_pfn(). The latter is trivial; future
code can convert present ptes pointing to the same large folio to
swap softleaves with consecutive offsets using this helper.

The other case is softleaf markers. They do not have a notion of a swap
offset or PFN, so future code can use set_softleaf_ptes() to store
multiple (same) markers on the ptes.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/internal.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index ce52188a8a65d..3fc1c1c776ca3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -514,6 +514,39 @@ static inline pte_t pte_next_softleaf_offset(pte_t pte)
 	return pte_move_softleaf_offset(pte, 1);
 }
 
+/**
+ * set_softleaf_ptes - Set consecutive softleaf PTEs.
+ * @mm: Address space the PTEs belong to.
+ * @addr: Address of the first PTE.
+ * @ptep: Page table pointer for the first PTE.
+ * @pte: PTE to set for the first entry.
+ * @nr: Number of PTEs to set.
+ *
+ * Install @nr softleaf PTEs, advancing @pte when its softleaf entry
+ * represents consecutive offsets. Swap entries advance through swap offsets,
+ * PFN softleaf entries advance through PFNs (encoded by swap offset), and
+ * marker entries are repeated unchanged.
+ */
+static inline void set_softleaf_ptes(struct mm_struct *mm, unsigned long addr,
+		pte_t *ptep, pte_t pte, unsigned long nr)
+{
+	softleaf_t entry;
+	bool advance;
+
+	entry = softleaf_from_pte(pte);
+	advance = softleaf_is_swap(entry) || softleaf_has_pfn(entry);
+
+	for (;;) {
+		set_pte_at(mm, addr, ptep, pte);
+		if (--nr == 0)
+			break;
+		if (advance)
+			pte = pte_next_softleaf_offset(pte);
+		ptep++;
+		addr += PAGE_SIZE;
+	}
+}
+
 /**
  * swap_pte_batch - detect a PTE batch for a set of contiguous swap entries
  * @start_ptep: Page table pointer for the first entry.
-- 
2.43.0


