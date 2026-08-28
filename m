Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51E61C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 861D96B00A3; Fri, 28 Aug 2026 14:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EAD36B00A4; Fri, 28 Aug 2026 14:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68C986B00A5; Fri, 28 Aug 2026 14:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE226B00A3
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:37:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB164A0547
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:24 +0000 (UTC)
X-FDA: 85151536008.22.40AD561
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id E4D64A0008
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k3tHWy02;
	spf=pass (imf25.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787942242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zfcyzCAqaQXbJL0WVp7G3Q9umeDsMlNHg+F0EE9N96I=;
	b=c8eI79p3Nk1/L8QDNvT1NxhcREKauR4i+FMjry9fRkjOo11kuXp3a/KAM7qs4bEHnfbOH5
	+uP5lGkfGFEGDi/AHdyHQ4IJU2c5uILhkEc6cHczAf1O58w4o8pL3preQ6S1JoxebxH1/T
	K2v75vkKN6v7ceJMKZbuv4I/c8S5cLM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787942242;
	b=SLQVKhCQkDtz9vFjrhlnsUrvQnpewc/fydPxL41qkAuLxX5YtC1Rzr8HW93fWh4R4zZKkO
	5Rq3FnQBuShjz0CCrz8lrJmjzdFArT75U4LU64xZiwmkheAjqlB6bF70zm9IIKsXbXCZlK
	ncSoixry4csx8wceUp5yqs+7qQ6jqqc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k3tHWy02;
	spf=pass (imf25.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84830c774a0so1640091b3a.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787942242; x=1788547042; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zfcyzCAqaQXbJL0WVp7G3Q9umeDsMlNHg+F0EE9N96I=;
        b=k3tHWy02FrC33gihpL0rMzaYKv8GUeb0ZiNi4idfBHuokQkhdxHRANqzlZzXLD8v2Q
         hVQiw8sRiuX6aMQwtNSlfpu3pWjDQhHhbrhjdqXkbrSS2OQIMzEZIk/V+LqYqow1LWLO
         PLJJSuxqA5gXzODrjyLQMx7/lQvNi6JZ3ZI6lMy3oLbFz4NzADkm9If8C2zIrDvY5yl9
         8E8iAInOs2tvgOc7pITR0StSeQnqW1B7/h2fZnoagE8uHsFHXb4/4jZA+KBiACYlLbUm
         zl9fo27DzoUYvAtG8EXkls8BVF/MM5/DgIm2ocKDw/vasFX59QQcD/L77z4YAdnfO7gN
         h33Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787942242; x=1788547042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zfcyzCAqaQXbJL0WVp7G3Q9umeDsMlNHg+F0EE9N96I=;
        b=rPEd7TlA3G/M4UbgCm0pekIthCMM6FIbLj7CApgn5WMfdwpNwJCJ2NBzxh2yQgWJjo
         3+Gk4vkRs4sbR1kKE7rwhJJiNIwOcg/jYOWugtl9q581iWJ4OHNg1ACDmcxeCJCuk2L+
         lXvQuov2ABrk07gUXhwIZjcLCZDBJx0haUIfMoH6rH/0hv74P6VMXmVIBdhDnF4k/dHb
         Me+IfdVFg3lKNJhHV008D8gOBLAKZJyqLsIy4Ndo+mrfeweWc9lOFC+OwTfJZXRSD2H3
         FFg87uZku0UyI0KbqtpjmiusxPv34C0hiJM1wijZ/R4qYlxSaiXKN2wXykasLCR4Pp6G
         uoCQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq/OE7rDxUhWCRdjJcRIpfShT5ZzZMXamSoN67XkMsF7U0aIa1dze0FKlO5PZjBWicegMOAxsBsBw==@kvack.org
X-Gm-Message-State: AFuF++lfiXKaVNWdLmmHypRGdSPu6swv4MKNafu8FA/oIDR/srJ1Ogim
	TED/RGglUQKvERqsroaa3uPqGbxoJFDvb24/C8aUkURXUBCaZk0qvpI9
X-Gm-Gg: AR+sD130jOh2IbBZVG7UwDawonu7PVkohmGbhU7qUs+rodNZFOixEEOEEg16Zrb8qgx
	Uk+SLuyi4xbeF1Dmn000DAEfRH18ugyCwpjQ2hxADeNC4uEDzRC3jLOge+OMB928V4kfmDzBcMe
	it6I/6m/qi5aUCTc0gPj9O1fHdwbNoqOJLN9PtygRbCziB+JQsDRWgw6ljf+HmJhscx2sK9ig2N
	agf+GdQg2oprRKvtEsAHRjFt8nqlpLjtf3Q97/rdbwj/Vuig4ozZ1f/Jb4FVUkCI5F72vaPXgRp
	CAmzWbbHTPRAoHn0F+fz4Rzvzrcajawmq73W8DfRCi2JVxOom4b85w+KG7oGdoHJh9IHFuBoJQ7
	VqdSocg/Vy2pHwIMrxen3EpgXn6AiST4UrYDx6qq11kLOXzBeid6dqJQ6wTWWDwdJrIemzQvPHg
	hMVdnxHSNfpI6CudLB0ZwweljqNx1CQMcTfAMe5QXN9XqjWeG6bm/4tNg1cX+FBUiq2wkojVHIC
	HJcGUDPyz/s6gbPuu8=
X-Received: by 2002:a05:6a00:9459:b0:857:727c:a1f8 with SMTP id d2e1a72fcca58-857727ca426mr2412271b3a.26.1787942241652;
        Fri, 28 Aug 2026 11:37:21 -0700 (PDT)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-856a2ea6fa3sm844230b3a.37.2026.08.28.11.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 11:37:21 -0700 (PDT)
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
Subject: [PATCH RFC 3/9] mm/huge_memory: add and use unmap_huge_pmd_entry()
Date: Sat, 29 Aug 2026 02:33:13 +0800
Message-Id: <c64ff489b0c59086fcafbe74614d47df66010ca4.1787941780.git.yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1787941780.git.yintirui@gmail.com>
References: <cover.1787941780.git.yintirui@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E4D64A0008
X-Stat-Signature: 3engpixbh99fj95mqmyyq7fi4k3zjdic
X-HE-Tag: 1787942242-788177
X-HE-Meta: U2FsdGVkX190MLPPYu8IL9b+pHMQzQ846ZZtsxRtbQu6BXznKuG5jCFWxdTS1Vqs8BdNh+YIt6VIMNlrPiQt5qPzsl0ZEsW1+HwLiMvGSSW6q/PpcB5gFQGrYDblgHd9n+MKETFMHxSk8yhP9FgdCWKjegtxyXdOrimRORebC0SDJcmRuirl10amyLY7Wtdr2rW/MsprxJsWTMTBavVFueaSp4b31Ilq+SiC/2OgVSfUWbvSgxSBajw19Xo/Ak0tci/k0N+r3KZxu8jAR6Nf9j/Uc+an+E3QQDLXHNQynXT+nWR09ZWg2mR1qJ4lW944qxL65M3Z4Isb01Ce0Gqjwo8QKTAf3z2nwOYufywnEZAxmIQQVPre4yKHl4UqByqwsuqkJid08AzGzzWpeSuy4qtL1yVhz5mfGpAfctO2pPrVacjXeie029J1Swm/Pa8bkxF/Q0XuwoZKKgpSMq6TaacYiwjLZzKlD7p4bgIERQNybxxFy4ewpaC6WgED/KJ9/Q6KN3hD5b+8BcL71xpcxCnEvUHMhN438lqX+M38edWoCEHnhaYy+y/ZaW781Dp/wDPXJNQMnRv2mEW0C1n+AnKRsiR8cB8P1gDWxxZ553IgTMDnot53d4owW2BWXpbb5JoCdSBxRKuDjVQeDahSUq7+x2UlHWhwQgm5NnfC+VZ7n9+CyM5cgGXQX62ZqKoFAJZX4uDeZKJIxXIWp9UqQq2wop+0S9LCInOwnVj9oaXBMLB5EGh0XYjvT/5ibBKF98NaY0H33RnKwaPzi0sv7sE+LjY+4R3aWZFz5LoKzj/3LXUs9Ykms5B5Df2r2GWklQsLH8CaZK7SUnfrQxog7YWk5QtG9WDXk9F08yPXfJpt1XWH3iX8V0jU5QvJZUczS8cpE+bT5/P6G3MwRHaENBPCfH7UwDszwzyOIK4ufBd9bikxheWSXFRj1qspM5exs14KFaoZQWSMgl4/HCV
 tUCbYgM6
 0C9kFQfh7wHjTFe3K4UsJSZ6s6wo0Wzygyshw/9UDQkPT8iVQJySDxFNtTi2Vr6/JDZznicR7H/H4G5m4Mf3zHOeP6QZOauKQudu4LxzEMCMrgK/yUttoLwxPd05c3OBdqAzuZtksIPE934sukuWztAX7IkKuw4PnBCcJI0M1jCplBP2VFPg1HgYZpc9zrIGo9lN3CC8Gw9CvG0uAFhV2COgQeIrdlDu/D2LjT1u83QZZFYJ7Uw3yGWPVKgGAhJ8AGYU+NsYvD9UtJs2I1gqTYGu8yyzs3iBUcFzKtFLyhKCxI+BZRnOqXFRuAci4DFMljBRJ5sRB+G2+m7LTeQJ5o7Jq/JJ2jqz6nazbZojDQWunYWi1bS5vdVrbkHOMGxgaeRm7oq986S2QVAPg7i+8ojJmCTi8GXIrF1H9Z/OmldFApvuUvzUr+dDNvE1BdAilLnhKT4kZVwo4gaw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Only a huge PMD entry mapping an anonymous folio is split. Everything else
is unmapped and comes back on the next fault. Put that in
unmap_huge_pmd_entry().

Old and new differ only for a device private entry in a non-anonymous VMA,
which nothing in the tree can produce.

Signed-off-by: Yin Tirui <yintirui@gmail.com>
---
 mm/huge_memory.c | 84 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 56 insertions(+), 28 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 90d84f761619..aefd62827139 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3148,6 +3148,52 @@ static bool huge_zero_pmd_can_split(struct vm_area_struct *vma, pmd_t pmdval)
 	return is_huge_zero_pmd(pmdval) && vma_is_anonymous(vma);
 }
 
+/**
+ * unmap_huge_pmd_entry() - Unmap a huge PMD entry rather than splitting it.
+ * @vma: The VMA @pmd belongs to.
+ * @haddr: The PMD-aligned address @pmd maps.
+ * @pmd: Pointer to the huge PMD entry.
+ * @folio: The folio @pmd describes, or NULL if it describes none.
+ * @is_present: Is @pmd a present entry rather than a softleaf entry?
+ *
+ * Only anonymous folios are rebuilt at PTE level when a huge PMD entry is
+ * split. Everything else is unmapped here and faulted back in on the next
+ * access.
+ */
+static void unmap_huge_pmd_entry(struct vm_area_struct *vma,
+		unsigned long haddr, pmd_t *pmd, struct folio *folio,
+		bool is_present)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	pmd_t old_pmd;
+
+	old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
+	/*
+	 * We are going to unmap this huge page. So
+	 * just go ahead and zap it
+	 */
+	if (arch_needs_pgtable_deposit())
+		zap_deposited_table(mm, pmd);
+
+	if (!folio)
+		return;
+
+	if (is_present) {
+		struct page *page = pmd_page(old_pmd);
+
+		if (!folio_test_dirty(folio) && pmd_dirty(old_pmd))
+			folio_mark_dirty(folio);
+		if (!folio_test_referenced(folio) && pmd_young(old_pmd))
+			folio_set_referenced(folio);
+		folio_remove_rmap_pmd(folio, page, vma);
+	}
+
+	add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
+
+	if (is_present)
+		folio_put(folio);
+}
+
 static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long haddr, bool freeze)
 {
@@ -3187,34 +3233,16 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	}
 
 	if (!vma_is_anonymous(vma)) {
-		old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
-		/*
-		 * We are going to unmap this huge page. So
-		 * just go ahead and zap it
-		 */
-		if (arch_needs_pgtable_deposit())
-			zap_deposited_table(mm, pmd);
-		if (vma_is_special_huge(vma))
-			return;
-		if (unlikely(pmd_is_migration_entry(old_pmd))) {
-			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
-
-			folio = softleaf_to_folio(old_entry);
-		} else if (is_huge_zero_pmd(old_pmd)) {
-			return;
-		} else {
-			page = pmd_page(old_pmd);
-			folio = page_folio(page);
-			if (!folio_test_dirty(folio) && pmd_dirty(old_pmd))
-				folio_mark_dirty(folio);
-			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
-				folio_set_referenced(folio);
-			folio_remove_rmap_pmd(folio, page, vma);
-			add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
-			folio_put(folio);
-			return;
-		}
-		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
+		const bool is_present = pmd_present(old_pmd);
+
+		if (vma_is_special_huge(vma) || is_huge_zero_pmd(old_pmd))
+			folio = NULL;
+		else if (is_present)
+			folio = page_folio(pmd_page(old_pmd));
+		else
+			folio = softleaf_to_folio(softleaf_from_pmd(old_pmd));
+
+		unmap_huge_pmd_entry(vma, haddr, pmd, folio, is_present);
 		return;
 	}
 
-- 
2.34.1


