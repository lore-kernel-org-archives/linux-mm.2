Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8586C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 14:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACA8F6B009B; Sun, 20 Sep 2026 10:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7AE86B009D; Sun, 20 Sep 2026 10:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 991D46B009E; Sun, 20 Sep 2026 10:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CED26B009B
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:25:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4393580440
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:25:55 +0000 (UTC)
X-FDA: 85234364670.04.BD016CD
Received: from outbound.st.icloud.com (st-2005k-snip4-11.eps.apple.com [57.103.79.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3D5C8A0007
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:25:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=0DjttDuk;
	spf=pass (imf15.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.73 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789914353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+4LxcE0ZNzlIfE6jsP/r+Z9z994JbQce9sXcvnyNA8=;
	b=UGY6luR630mcoauOoKHY9oHsW9wPHmnaNJhV+Lvs3gmDsEk8k7HyQdjV5faQQToIUd3doh
	xvpGkXG3sPlsfjdjvTILhkjDICooSRh5veJ9s6K+t4l2ag6c77YxDQ4gxz700UWCdvx8pn
	wjACMMAtfSgO1rP6XvV9weNh7Ec677E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789914353;
	b=Sk9fMzlQ88f/H3dOctCgZXTwbN331MkCormA0TYjp8nMkT6oHvrF5FyaWyTud9tqWiciMj
	1xzWnNKjFYXwM98qZ5sWFy1ElXteMeyhPnXmZBTMTmPt1DE+Y4gBzFChTslBkDPDss8zdV
	HVeyP+kDcrGKWA+UXHLvUcYOKy3vqyQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=0DjttDuk;
	spf=pass (imf15.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.73 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPS id DAFC81800298;
	Sun, 20 Sep 2026 14:25:51 +0000 (UTC)
X-ICL-RepId: 01a0bf35-88f9-7723-a13b-ddac2a20e3f7
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhKB0MGWQReCEsEQwFbEhVdRUkERxtXAlQXXQZSEnIZWhRcGFNFUR9UWFUJCgJRHFYNV0NUBF9QSxsOXABLWhVVFw4CQh9QH0wWV0NEHxwZWhRcGFNFUR9UWEMZRVZpQQtPHV0ZWxxCZFhXCQoCURxWDVdDVARfUFQRV1ALWQJCD0gKXwdGRB1KG1IDGhlXFlgbRwJFRkRBFEweCFRbBhQOSVAPAF0DME0dXQ5SBUZeWhdeUxcfSwBcRVoOWwRHFA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1789914352; x=1792506352; bh=y+4LxcE0ZNzlIfE6jsP/r+Z9z994JbQce9sXcvnyNA8=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=0DjttDukd+i3mo1A1I2YF7SyteZe/7bum5j+GBddC5P0ROkasuWaAkywRCpHku72oPNSZz2SGxUjajVIRh7JommRICypJYrbZNZG3lfJOGAm9fUQOLwfUv5LaWMD31LtCShooxE0IuBz7ckhptCUtDuH7wCV/fMflXMKwWwN1zLbXTR6wDnVtYgvsLzKaon53p5qhDBy0tJYFvhmydaSPJ9I2CuaP6snHI4NwiXOMe7Ao0m0PMLSs6/Q58OVs8Zwmy7LRHlJN+1z+WcZyERmm9OmloBj59F4LQI+gA+zCCcwUqhtWlNONp0gIDxZTvp9NBiLOwdKyBcnWJRk8t+IlA==
Received: from [127.0.0.1] (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPSA id AE6C618002AE;
	Sun, 20 Sep 2026 14:25:41 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Sun, 20 Sep 2026 22:24:17 +0800
Subject: [PATCH 4/4] mm/vmscan: extract folio unmap logic into
 folio_try_unmap()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-vmscan-refactor-v1-4-ec04d71cb761@tencent.com>
References: <20260920-vmscan-refactor-v1-0-ec04d71cb761@tencent.com>
In-Reply-To: <20260920-vmscan-refactor-v1-0-ec04d71cb761@tencent.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.16.0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIwMDIxMCBTYWx0ZWRfX7qNKLx881oKO
 Bp+LChKGf2VW5KvHE+LIrzqNhgkEFk+8+IT8an4O1FJ7uX+mrx7XS3BSa9pvZZrRFo0ujF3KTr7
 PfYqGylSL61VuAq1uHGnPvG8GJVhl9cTlTs3h1rNsx3KDgyXy9eAQ8g5Y8IQhH1DXKZhWGgRfkh
 wnqHg1ZriRyjUdeHm/1FtRTUHY6jfPg1d6PFEdpCxFkIEfnPZ6ME+r1boiadHkzu6yVr7F8DAx2
 7yePeiwa+eH5ONJJRiVMrpblmeQKWgtVeWcJADZbQDqDOg8dsRQydpYTYyp46SOg5bTMTkzE/dz
 LD1EjemTVVxJkwLMAgI4un8rxYU/d/N2WNQ7wssnZrkpHx6ZpN3X/mK0g8XBNk=
X-Proofpoint-GUID: hsmcGXTx_XoKWvLdLUk8nhQZ7yr68fs8
X-Proofpoint-ORIG-GUID: hsmcGXTx_XoKWvLdLUk8nhQZ7yr68fs8
X-Authority-Info-Out: v=2.4 cv=aOr9aL9m c=1 sm=1 tr=0 ts=6aafecf0
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=VwQbUJbxAAAA:8 a=Oe3AU6d8b7fpH-gKf6sA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=J6hPbylVjWXjVQVODqME:22
X-JNJ: AAAAAAABexOQ5G1UmVTm5NChbqSVvjY4dKgF+1/+LdvMSuutUNKOVn8DqWDfmzPGkYwCgcYUrOXT1Zy/EUORdYYUYEV1GN5Rhh/0Sh02N+/PV12GIHCgjZcr4DQx8cUi32GomQIUICU6YR2OVOy7coC8/rEX3AmQS3WV62G+EGBQjP1lY3rO/solOdeBJyyPZBBBSktw7jjhGkSJpXm5G1Cogosjl3kDnbRRYMUeVXtJvVIkhO6P12Onk76bZD0LK04/9Atv2qGO1hbAnTJmGr+iQqPDLOTTmUfxX+4qsMGPHFLaSIlylxdYTQ/9fuKmnvVVdhddWZMx8ZR5PRH1RQE4crSD7oa81BgtUolF0pLrnMJ1KaYo6gwr4zj0ChxqQFyvskztMJ+BOmRXdHp6J2YYuQ/e9quypXxktlpwLghBzV8z3cvXwBwhWdC6i08ixkMB5ciyFILygON0h7NWockcRamEEiDBw+UZKQdVloz5+jBfBM0xb1BgAfXPWjCa6cSy+dcnCiL+CXtoxrM5ggNQG34oOsEcuA5kz80kGcpnf0Ynj0/mq+QQTkPeHem4xQiQ/JBffPCXW5q0UA6GnMOvfpS2qNxMx8+qN8dSJ8n0FPkqQX0yVrjSRQjvk9USiSzUqswCSKJDxvSqUwAmQZCiYioAwaYbGo6N4aAhhe+RmBPDldebg6O2nuzyM9kzr6HhaJWBC8LJpRw7MnXsPlrZrZw2rHgqzmdu7E+E6uHd/Mi+HXyNOloE8cKthcuI12xpTu8vvbKrRuNHyMbUcybvC/LSdBmdS7Ons+Auduerqu7BQxUeeNYNMIHprLp7BV1AYALfnQNfp1K831zocdUElwxySKmJvm1+pmUqQKfONVJX6gf0g0NUJDwH8zJlszWn/wYb3L5kNbVgP9EViUve1L3ZpEs=
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: b9e9bw94mim5d4fn6kkeumfby3dgu3sy
X-Rspamd-Queue-Id: 3D5C8A0007
X-HE-Tag: 1789914353-981524
X-HE-Meta: U2FsdGVkX1+wbq6GK5KtNWfPapzeMVFxVONevbMHsSH//lOuON9GjbL1h/1OBR5/OxUt+mGyYoSmwIIQESuk3gUgrR88DqbR2faNFELFhbIz+Yn0AkMn+f1iZxihIvws65nSitDkdqIN15foNQs80EXf/rPiyQClLAgmaoXAKV19G0qSECuC5tJf9LlGPX392k+tVOy2wWvR19cZ2d14wbh5JWS2q4XkfmgUu2c9hO9YCcgNnYRLiXG8PPJKKF6cTMfdPjWYl8VT8QAuk+2fDkDV/+4ixVe6eCQm63JMllFbq/ICI/Q0NPeUW2Lb5bTeV7LKv2VMecy/JF8T2+Cfg85yncCh26bXlWYbijWnanPT0OFPyrxHaakr/8fkFLG+AeMfE2JY5S0FGi0VOpGVthSydelZ3JPIEdpQQy+tK+yi4HJ983mYfagQauqNKMqq6OtH2pOFgBPH4QHSujgQFr4xe9jcPBIE+tG2QlMD2hDUrDwPsfvJF8zBqkLVkKes02Sn/sVVIEA1g/CYW+BUcd0fgxgg1YpaVkDaj1yOlQjGqCm2p+MNCg62da76sgrdjdPONNMYmDHRqf2jfTb/u+UyDZeluQ1z4MuyDPq6a7pzGtW9icWQ1fVTOEiGnK2Zw1sHA2UryamZMltLTT5utD8M37gbEg8ZIedeysrLBpQGXvKy54IlcZdb5wDOuKdRZhjj/cW8lMaOZncno/aiLTolPQi6ryVugWG3o2sO0qN0AYwf536gfxX7FVw43+hKLOuQMb8HH3xTkWh9cmpnb2C721dfsH+Mper9gAVGyz5RTwCHtttTyMSyZ9aKVGxl3upmlp718LeC+tD4l9rRSiy3Sd3zG1TlDtTXq513kJY98WreuHBYq5UigdZG3XIeHjKHi5J29IoUdmXBIy/GKGNbf143fwIdYqO9VoDfVfYaX31r38Gg/2qUtBlc0H1HPnn7zhl1Y41xQ/tr3RD
 TOAGQB7X
 nKgoXtrCwZD+PAD215Kno5EeLotnBmfJzcFOpafi0TVMapFSEeY9ELhyMdSxbAi16pIYqqRbKPV3NAi5oBSpBu5tp39MK6wEqw1LI1Ey1amR/9w0DUDRj3mD0eM+lGRTnwVKUYfGPIjF5FLZNeYEATXazbIXT2i9ybpWfH7442gyvfpPAwFssl+gXriKinaGLA+VXn9D8j0XI2z3eXw7X69vyzSjW5zSRwaddtJtECygRnb3PTlr95WjyeHEsCOjWNff0LvDfSC/K+8S/OB7jmbbHP8texo3rc/UpXgdoY3m01yZH8HO8k5KLESngsQpiMUHAi6TiLXb7H0f2Jn69WmeS8l3jJXKoT9kPrH8jHnuMabvhEHfpfvWzzhUhTgBsDX0sx705P+wfNXQaDc9X766ed57zvkt41C8b/Pc9vl0EFd5iG/TA35h97Qzlpr7227uzIiaHpG7NrcqjXkp0q5fkMCuVkhZsRrAFAStGYMAA4Y2JTDUJfLN43lZSbM7A0ty+aarRq5Ps/cBONSC7IAZ94yIcBfYbJwY60aUbOVYISNE+pzJmzCIsiF7EUkLDfIzi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Peng <bruzzhang@tencent.com>

shrink_folio_list() contains a self-contained block that sets up
TTU flags and calls try_to_unmap(), accounting for failures via
reclaim_stat. Extract it into folio_try_unmap() to reduce the size
of shrink_folio_list() and make the unmap step independently readable.

folio_try_unmap() is only called when the folio is actually mapped;
the !folio_mapped() check stays in the caller, keeping the function's
semantics clear: it tries to unmap a mapped folio and returns whether
the unmap succeeded.

No functional change.

Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 65 +++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3bce7ff89293..71b507011603 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1318,6 +1318,38 @@ static enum folio_pageout_result folio_try_pageout(struct folio *folio,
 	unreachable();
 }
 
+static bool folio_try_unmap(struct folio *folio, struct reclaim_stat *stat,
+		unsigned int nr_pages)
+{
+	enum ttu_flags flags = TTU_BATCH_FLUSH;
+	const bool was_swapbacked = folio_test_swapbacked(folio);
+
+	if (folio_test_pmd_mappable(folio))
+		flags |= TTU_SPLIT_HUGE_PMD;
+	/*
+	 * Without TTU_SYNC, try_to_unmap will only begin to hold PTL
+	 * from the first present PTE within a large folio. Some
+	 * initial PTEs might be skipped due to races with parallel
+	 * PTE writes in which PTEs can be cleared temporarily before
+	 * being written new present values. This will lead to a large
+	 * folio is still mapped while some subpages have been
+	 * partially unmapped after try_to_unmap; TTU_SYNC helps
+	 * try_to_unmap acquire PTL from the first PTE, eliminating the
+	 * influence of temporary PTE values.
+	 */
+	if (folio_test_large(folio))
+		flags |= TTU_SYNC;
+
+	try_to_unmap(folio, flags);
+	if (folio_mapped(folio)) {
+		stat->nr_unmap_fail += nr_pages;
+		if (!was_swapbacked && folio_test_swapbacked(folio))
+			stat->nr_lazyfree_fail += nr_pages;
+		return false;
+	}
+	return true;
+}
+
 /*
  * Reclaimed folios are counted in the return value.
  */
@@ -1596,36 +1628,9 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 * The folio is mapped into the page tables of one or more
 		 * processes. Try to unmap it here.
 		 */
-		if (folio_mapped(folio)) {
-			enum ttu_flags flags = TTU_BATCH_FLUSH;
-			bool was_swapbacked = folio_test_swapbacked(folio);
-
-			if (folio_test_pmd_mappable(folio))
-				flags |= TTU_SPLIT_HUGE_PMD;
-			/*
-			 * Without TTU_SYNC, try_to_unmap will only begin to
-			 * hold PTL from the first present PTE within a large
-			 * folio. Some initial PTEs might be skipped due to
-			 * races with parallel PTE writes in which PTEs can be
-			 * cleared temporarily before being written new present
-			 * values. This will lead to a large folio is still
-			 * mapped while some subpages have been partially
-			 * unmapped after try_to_unmap; TTU_SYNC helps
-			 * try_to_unmap acquire PTL from the first PTE,
-			 * eliminating the influence of temporary PTE values.
-			 */
-			if (folio_test_large(folio))
-				flags |= TTU_SYNC;
-
-			try_to_unmap(folio, flags);
-			if (folio_mapped(folio)) {
-				stat->nr_unmap_fail += nr_pages;
-				if (!was_swapbacked &&
-				    folio_test_swapbacked(folio))
-					stat->nr_lazyfree_fail += nr_pages;
-				goto activate_locked;
-			}
-		}
+		if (folio_mapped(folio) &&
+		    !folio_try_unmap(folio, stat, nr_pages))
+			goto activate_locked;
 
 		/*
 		 * Folio is unmapped now so it cannot be newly pinned anymore.

-- 
2.55.0


