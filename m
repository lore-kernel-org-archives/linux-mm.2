Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68947CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6B96B00AB; Fri, 12 Jun 2026 00:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7EA86B00AD; Fri, 12 Jun 2026 00:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6CEB6B00AE; Fri, 12 Jun 2026 00:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A4FE86B00AB
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:00:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C4BDA03B7
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:17 +0000 (UTC)
X-FDA: 84869908074.05.E0AF9AB
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id D62791C0011
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bDPU9rkY;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mz1pkfZLBXPZiMkWew4YPl94Bxp7XZrjgH0nwtCkmEk=;
	b=Lq6ghnOZNosSsfKaS0/cJQq73ijxpws4kzF3ciIBB+qcN7y2iH5gdkamyXHua+OPqirOBS
	ZVDZAlnNsZN4uhp9jPHqN/NLo4SIcTPfcK0ptoPNI8+4kIBBXnMzEUKO+5na86kHYpXzg7
	kX84806MX0z7Sn9++4RXnMFjmq4tuao=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bDPU9rkY;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236815;
	b=IQNu+zV6P8IHdVLx/abEolakv7aakstSDLkMhpSN/ogXN8MuEir99eSYxKrADW8LACgw8l
	mpUW90DKXortUpUN6eUtwXsTc6ZD/2FVCCXobRP6nNK8aNRYKQQtR5CL+tQjFlXypK8zp9
	EJXOkC4AHLGFG1l9ZHbWq5aUUzDfABo=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-84231305a80so359522b3a.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236813; x=1781841613; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mz1pkfZLBXPZiMkWew4YPl94Bxp7XZrjgH0nwtCkmEk=;
        b=bDPU9rkY2O6Z1ci6jsWrBru5IBGrd0bWCEpxV+6dJ62Uet8L+Y8avBZaUXyl8qE2js
         JgJOGPH86rYdpreKFHwdTTvisHblbc+rGhLrln3i9dWhiKWPzhyMZ6SE6ihOmBxhsSSC
         +D7vpU/iKMiAeKmz5yuA8851+I+MC8/rLvPzlS9fyVYK/7pA5RxiYibLVjE20V3uSyEC
         lXXwa8jHwUt6WbpvqUYFO7hfVkLCqbwgibHatn1xPUs0xsz2fBxItmjbczHRfuqInIjU
         Ro5Cg8ezMiwekfY0qAMGKcbgzTeaOf9VJ/pvrxYJoGw0sU4w7NG9v/888XJZc23f1mvq
         ONaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236813; x=1781841613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mz1pkfZLBXPZiMkWew4YPl94Bxp7XZrjgH0nwtCkmEk=;
        b=QaVo0xpn2Uqwkh7E0oM7St7mvVEmkNksDVAb5FzZrqQDkDT1W1xT7KSKvBkpKemhVO
         g4LWGuUJXqvHfov2GrcSTvQImxEwjc4Oa+3baQfhHIx2m8cxBi4QfiAZz9JaDW9mYwHm
         mN1cQCaDmMjuGkDP5PsbDahXDcu6DRFAuiNZ7p9XzhSqR+VkhYzn0ELmSC2urZqKU1aI
         tDhQn6VFM5j3islTJDqPL/ymqSo6jRS1FDXNcPKSpKPu4B8xVF9XQxCxN/WtEZ/VFr5l
         XS73pQuliKYnEJ+sTYfW5peNRaQRoZOWVqc0lLYBLVvPvmbHBLiEoSBXZrO+KJU4JA8D
         tA7A==
X-Forwarded-Encrypted: i=1; AFNElJ/0X1s14mPE4ZJ3RWyUYg/IDAAEX4t3jpiQFBD9/eYRGchlF/cBK46iGwsj/4Q3jAVQ8IU0vaXZhQ==@kvack.org
X-Gm-Message-State: AOJu0YyA6Jx+CQRhPV/w76EsOQR4yt27KcculXwsqlYm5aUjZNxW9d1A
	AhyYcL/+uMdFZ6dYLMw1MvQ5JOzONtevCrXqGeBVing4ZFbQ8QcnmdeIFqhMfNajq3A=
X-Gm-Gg: Acq92OHTeslF9IIVD0eXxexDv2DURDfPtW8v5rEu/+kX6QBoy4J9avltB//e10Vsdba
	ZiFQdqFf10WJnCh8S7Fe/o0lJ/Ui5esC2TjWzxQBg+NOwkW8SZ2zhu9NLIyG/6vuBdC6qJ0TTGC
	4zhtTY0TrCluGwNB/ylt7QwXg+UkOYgvG+MG+bbyEviorovuhVv3yyatClMDkyWQ7iK1iug8HJu
	ktBHPvVambk5G7k6A9DY/shJHx5y1NTovPGvwB9HXdsBWmIiNXBEuG4JGRgZGrgpSzlBDaBflCJ
	WkJs5yPkgsQIIq1ie+cq0wA1y3BhlWjV33GUwkQf+kcYkibiDUKd6tvWWcqQRYHaUTMfbFzlYLJ
	fu0FOHU3r11T8VnhuYYJHBkEa1q98zb4x54hErA0gYB0dQ/vHNLSjMUjELUj/P5w2vxZuefJerS
	gV/8Nhh/BU9O+dgD2MvNNwMs3HYaqjFB7pnwNxa66/+qA=
X-Received: by 2002:a05:6a00:228f:b0:842:46a6:e2db with SMTP id d2e1a72fcca58-8434cd377f0mr1142768b3a.19.1781236811996;
        Thu, 11 Jun 2026 21:00:11 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.21.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 21:00:11 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 12/19] mm/hugetlb_cma: Validate hugetlb CMA range by zone at reserve time
Date: Fri, 12 Jun 2026 11:58:56 +0800
Message-ID: <20260612035903.2468601-13-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D62791C0011
X-Stat-Signature: bi1pstfuoh7gg3zojgy1yrmaeezy8rxj
X-Rspam-User: 
X-HE-Tag: 1781236813-554798
X-HE-Meta: U2FsdGVkX19knVFK9BoFnh4zbPNbzQJKhMiRXQ7Hr08zT8DNQiAo/ItoYUHz6M0StoEoDkSTGZd1BK+i0jkWwjj/7sWc5RIf2sQWtmot7eOpDqvccnKQIIZyh77fQHaEN58pqhb3rIQYI7yiL9ipzEJmrXTIjEtouN6xRuLD1GIEjNQ9B360mkbsE4ZIQmWoThLRX+xrE5N35Eb7ZZvTXbPaabAhBFL9iUDUhl3Hoefrlcb2jmjjKTtuhWs0f8AYsowk2CYu6NrfcvjUCa0wJC5aqYIxmzJoxwT0+ePM889XlNCl5MSdhoLAnJjLHbxpnZF6SCRxw7cc3axiCpRrMPJa02PduSK1I2bs5Zfj5CRyRZD201YMPWxpmO570XXHPZPEh/HzqEzYa2wokQN8u5gdRGQ1yuCKRdWE9Iz6/pqGyq6q0ToPXRj9ZFydu2hoBCzIa9UNvjGulOVpgqtn2zRdUepelMhHIRtrNDD3UsDKTQyDt3ibwJVfrWGlz+BCl+JSLCr3iwO8w2TSfkT1VLbm7YXLAPBMmJrE0zP1aIH8bxAqrkPB0r0xIaiC0r0VFG9lajQm6A1vXUKHiCSAL8yJ4tQTCXGT0NV666kH1pdKErOehSO5EWxOqzABoAiueFO8+9QrQkfyDEdtDEPltCGNYM7QlZ4QZb0Qw4E5Rf/4kcqQqPvrmSzh8n0d1E9pafpuXma+lX6b6dqy7qe8k8UMqJ/gbLJZTei1GqPOt4mio26CwLFClhODvz9BdNjaTSjULhSqhW0HoAIsmxxXE5hFmYu8USbTYv/TYDT+V38+qImBpYFyj2K0KAkuCU8ktIAi3moX3bvyi4ktpfP6jNkORgtyyGYFscZsDgviKWi6AJdcXG1dSkL6HVFwOeQnym49VkB8VJLgJe55tpoGGvG12MphkwpFxK6vDpcwfmq1KBjo1Jjc47MgPC6E6mVyttd9z8S1J7WIn4JJFSU
 5QqO0Hma
 sWJkADrUYtKdLM3o1UYOHi9x1pjjaG/n2xfIbeDawvB7/riyQV1SqBHqWQKKptPZJAmbPO7jHuCMmooF2hphHAFlww84RpeQGuTzYnWCYhuJS00+UW8r7hr7nXsNOafJ1PWTg6fiPWhXDZlY/kM5cPpwLFvRF0o+TnpBLryupIqHA23NbYmftxfcEKeOoC5EBG2D1mkguFgodrGBCY40eHgRQda/frbItuoFeT5sZVxb5rrAbUIzCKToEd93TeSAaYhh9zvKLbfvifdxuKeSYMjYk491eZjKUVz0wyI2jUu2ZoQUASAq87z2voPnHEu1kKzKhXuwiPHaXS/GO/q8Ln+a313fCOthwMzYeL9ImyyFQtvg+Ip8hiqkfNaAIlbWt6XYpN1bI1N9uWMs/JIba3IcR03D9p5KPwygmGGru+kvl7zSOUbrfKUc6qstRb3NMw9WCOlvP6gjWeE1qEWFt2jql5bxuvemG+gIwN38TL0Q02WzPT5taUm82gpYn2C7P3XX2G2H0a01BK5P21iT/FBTi47w6s5PnuhCu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hugetlb CMA allocation currently has to cope with CMA areas that span
multiple zones.

Validate the reserved CMA range up front in hugetlb_cma_reserve() so
later hugetlb CMA allocations can assume a zone-consistent area.

Also drop the pfn_valid() check from cma_validate_zones(). mem_section
is not fully initialized at this point, so the check can trigger false
warnings. Keep the sanity check in cma_activate_area() instead.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@suse.de>
---
 mm/cma.c         | 3 ++-
 mm/hugetlb_cma.c | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index a13ce4999b39..31073738f2ac 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -126,7 +126,6 @@ bool cma_validate_zones(struct cma *cma)
 		 * to be in the same zone. Simplify by forcing the entire
 		 * CMA resv range to be in the same zone.
 		 */
-		WARN_ON_ONCE(!pfn_valid(base_pfn));
 		if (pfn_range_intersects_zones(cma->nid, base_pfn, cmr->count)) {
 			set_bit(CMA_ZONES_INVALID, &cma->flags);
 			return false;
@@ -165,6 +164,8 @@ static void __init cma_activate_area(struct cma *cma)
 			bitmap_set(cmr->bitmap, 0, bitmap_count);
 		}
 
+		WARN_ON_ONCE(!pfn_valid(cmr->base_pfn));
+
 		for (pfn = early_pfn[r]; pfn < cmr->base_pfn + cmr->count;
 		     pfn += pageblock_nr_pages)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 39344d6c78d8..ce999391cc14 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -231,9 +231,11 @@ void __init hugetlb_cma_reserve(void)
 		res = cma_declare_contiguous_multi(size, gigantic_page_size,
 					HUGETLB_PAGE_ORDER, name,
 					&hugetlb_cma[nid], nid);
-		if (res) {
-			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
+		if (res || !cma_validate_zones(hugetlb_cma[nid])) {
+			pr_warn("hugetlb_cma: %s: err %d, node %d\n",
+				res ? "reservation failed" : "reserved area spans zones",
 				res, nid);
+			hugetlb_cma[nid] = NULL;
 			continue;
 		}
 
-- 
2.54.0


