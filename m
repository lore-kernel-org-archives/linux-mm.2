Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2548BCCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 11:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39ABC6B01A8; Mon, 19 Oct 2026 07:31:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324306B01AA; Mon, 19 Oct 2026 07:31:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23A286B01AB; Mon, 19 Oct 2026 07:31:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE46A6B01A8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:31:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 782281A06E9
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:31:42 +0000 (UTC)
X-FDA: 85339160844.09.7C637CE
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7CC91C000D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:31:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ZAH2WzTV;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792409499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zNdUrREfRi6A2agO64v8XOxx7iV4RKo6fmZLB1LQoIc=;
	b=fFFyWw4kBaYbf69ae4rcGNtqist+VZl4CbRsno3otpyTg+VxioIWun6N2kJ25AD7aEhoXN
	VkcLrdPn7/Thf9wufSgY5zc98TxK5gfwQ7b57c6UMJMiYO/VhPYjU+ITMycdMAwWOOk9N5
	LAdl/wwxpXwcmhSyvtO1/JOsm6oCb5A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792409499;
	b=18UKlTWTgx3Jzez8MRcBEECqc3uCcAKec5DbZ1rh8WZgys0XU+XV2F0E/Te6k6wuuZ+GGY
	+1+/AdwUCwhrubfWfYplv/0tk9jaoR6PTKtHvFyYJhqvmn2jCl1+Dyq9t3UgFby9EcgQTI
	uFAyphe9NUDkGj8tQPZM9ZZeHnAQVZM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ZAH2WzTV;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792409494; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=zNdUrREfRi6A2agO64v8XOxx7iV4RKo6fmZLB1LQoIc=;
 b=ZAH2WzTV4UssXPn14XA4UoWaN86Xw6Arj3z5b8l++x2nw85hDatT+OY29rpJhCfbqf4cTs
 YMxprNX9E1tbc9MzTkLUoitjeq3EySUqB3VTbYDaiuu/HSnbhtNfMxUOgeG7AoZZLguPAO
 bS6hyNdEl1x444/55dLPyosRd497buv6iHteZyo3kUlKrYnftKywtyFtmTlSPG81DosL5b
 67rZsnnzRtZpx2crmFaLLqEz16LrsbChq7RcLvsB747tHLPL5juYDnZjcqdvHg8pXVuBPn
 NH2ka5BtrkscWylgSfktyjwIwFYiBnuVAkBwbn5K05cJikSUo4Phh88M275itg==
References: <20261019113034.97690-1-lizhe.67@bytedance.com>
Subject: [PATCH V2 2/3] mm/hugetlb: disable PMD sharing for UFFD missing mode
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <20261019113034.97690-1-lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20261019113034.97690-3-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26ad5ff95+abd689+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <rppt@kernel.org>, <peterx@redhat.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Date: Mon, 19 Oct 2026 19:30:33 +0800
X-Stat-Signature: otaomo5j9qx5jpwad4yhzzgb1ujtzanp
X-Rspam-User: 
X-Rspamd-Queue-Id: 7CC91C000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1792409499-216925
X-HE-Meta: U2FsdGVkX19oDMz3z0pgrrexBoz2n7p91gdIZWs5xtbOcoTw5Crsp3DhYflPqVXTwv2RW8GsN9QPzkWOMnGQm5o4tXWQs5pAh7gzOha5dfGqfgptDSLFA0LnXIzbIw4Wf1NNTI5n8FGAR1pNtK4gFrZOu9Y6h10MpAbdD5hSDU/Hyk3r1wK0m8dyzOtgtj5bZIxVsvEYa0q7HxgX0WISl7EohIp0WdZJVhSu0XBM81lrTBbBgTCRQqKP1GZuHclu3s20hEybgSvrFwaBz9+c7OxJmWtRhFmNqYMSxeZwmNFGpQfZ/ZeEzGDZiiRTUJB6izX+Opih8o5qYVsxpjLIE+WA0eJlTZ3vh3+rPaNTTEZg/TUZok8In4u6DhuibEe1bJ5DF9WGdbslaqrszaThzc3z2h84Ae3u2n/sqyrXFfg7OKJhPgdKIm9b/uJJZZcOxanVUm2uc6YWKG/jrnFooBXnxbC1Y8hvLYneM92Wzky7YbIi5YVLXdTZQr7ziKJVpcLB/ko2VTt/NlSmFtK3TL5a/ewbdkfp4TNKg6Ijzp+MyHXpWXqBbVHZwDdn+DPwWEw/SfpG90QHIBok8D2qYRKuagNoE+kxLZC4d6EF+ZCBKpyaARwSgY08q9KzPpxSFMqb1ZHk2TeQFnQ0KuWhOyeFqfSo4jlPzNeP0Ne1vb4uNbSmQXTScP6Vty6FFRpNUIxkufjhVcpJVZZJdBcpAoOj91+M0i8T/dKCB5TBWzMfh4AZqficDiJORUwFFewOt/BHdrnY/jC+JoGutj/pGUNt309vFLBd2nsQkEzHHWWrpSyaj34R2p2iGG2W/Wq1rhyQpgplkP8rz69EVsstWFC26ySRUiCY6OJBaFW0eNV6oYdtdRDj/yB9f+/H1Tjsx/iaUdMf9SVMza8kyhH/kznsxsu6IjsJQkeNiXWYiUDRdb4fbZV2CPpaBBrAYTApabQ2Gc8+AgSzfZn8Dor
 0omc2zWb
 4/FeSkr19GEQYgjXYICnICDh5zg2JIoWJshYWSNy9pqfbzeEUDKUrz2RN4W5eh2GXKbA0ygPV7M+ppWktQ2NkeuSzbrn7MjYFGDIJH0Ph4WM/2Fq72YP/AGI6pVubThAWuYwyL+yix/BxAXS0bJIR/ji2x6XZo/UnPttWFnxKvOb9HhXrV+bp5vTKdGVbg/IRgLywn9hV+IbC3kGYbybRVr8viKmWFBzRHyJ+K4TOjz+gLmzcxEimyIFENQKMkxgRdQFclaoJjla3kDgocGNBnA0wIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

For UFFDIO_POISON to install a poison marker in a hugetlb mapping, it is
sufficient to have the VMA registered for missing mode.

However, UFFD missing mode does currently not block PMD table sharing, so
installing the marker will be visible to everyone using the shared PMD
table, which is wrong as UFFDIO_POISON must stay local to the process.

To fix it, include VM_UFFD_MISSING in uffd_disable_huge_pmd_share(). Add
a debug check on the marker installation path.

The existing registration path will then unshare PMD tables, and
subsequent faults will not share them while the mapping remains
registered.

The alternative would be to unshare PMD tables selectively when
installing poison markers, which results in way more complexity. Or
alternatively, simply failing the marker installation, which might break
some use cases.

This effectively disables PMD sharing for missing-mode registrations
that never use UFFDIO_POISON.

Suggested-by: Li Zhe <lizhe.67@bytedance.com>
Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 include/linux/userfaultfd_k.h | 13 +++++++++----
 mm/hugetlb.c                  |  1 +
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index a4351cffc60c..fe78ba14dc68 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -169,7 +169,10 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
 }
 
 /*
- * Never enable huge pmd sharing on some uffd registered vmas:
+ * Never enable huge pmd sharing on the following VMAs:
+ *
+ * - VM_UFFD_MISSING VMAs, because UFFDIO_POISON may install markers and we
+ *   want PMD tables to be unshared when installing these markers already.
  *
  * - VM_UFFD_WP and VM_UFFD_RWP VMAs, because the write protect / access
  *   tracking information is per pgtable entry.
@@ -182,9 +185,11 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
  */
 static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
 {
-	return vma_test_any_mask(vma,
-		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
-					VMA_UFFD_MINOR));
+	const vma_flags_t uffd_flags =
+		mk_vma_flags_from_masks(VMA_UFFD_MISSING, VMA_UFFD_WP,
+					VMA_UFFD_RWP, VMA_UFFD_MINOR);
+
+	return vma_test_any_mask(vma, uffd_flags);
 }
 
 /*
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2c64ca985dfa..fdd65e019a55 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6304,6 +6304,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			return -EEXIST;
 		}
 
+		VM_WARN_ON_ONCE(size == PMD_SIZE && hugetlb_pmd_shared(dst_pte));
 		_dst_pte = make_pte_marker(PTE_MARKER_POISONED);
 		set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte, size);
 
-- 
2.20.1

