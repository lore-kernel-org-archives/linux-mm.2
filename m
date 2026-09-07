Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5071CC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:12:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E89266B0099; Mon,  7 Sep 2026 14:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE95F6B009D; Mon,  7 Sep 2026 14:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BED6F6B00A0; Mon,  7 Sep 2026 14:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 81E9F6B0099
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:12:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19839A0284
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:21 +0000 (UTC)
X-FDA: 85187760882.03.F3EDFB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 26A19C0007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IvVcwGnK;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788804739;
	b=J7AUwYYIGJ4gKr4FTDjZo1NhgYkNIFekpG8b4atYsuwtllkvXtjA7ZQANOdOYIQgB+jObb
	lW9v8E55/MKGOsvT6shwbrBi7l0JG7wBIFJJdbHicMdY2g0CsrsP0+npracODwNFVwjt4J
	ivb+ZAlSreNkdnSETOcb04VP0+P/8VY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788804739;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EXTW1ujwOLxh0XGtE6+guyzUycv4nUfSYyijfyYfTtA=;
	b=C5qFu0fKeenHK8813chPw74+ngDKj2GYrG7ZZ9o64viu2dwWGitBHsp5zvbyMCz0EsLD1c
	69li0lahfFOcX3LK91SXJXk84Qdrj7wigXN18m45kFT0xvQ9+BVyt000+Sr+E60OK4qD5i
	pAeZR8s7GYEohfnAa80DE4CX15Sb9jM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IvVcwGnK;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 77D0E4451F;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59D2CC2BCC7;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788804736;
	bh=gfvvUIk/at6UwTcWzvjabNbGGeRmaBR57SeASlJRRMg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IvVcwGnKAwohWi8jVjvQefQ+/Q6stoBvaLk4rXyFAb9hU6QoxU7FI/5+IWDJtIe48
	 2QjaPMOEZt5FbOJ0E6GVI5vB+Xay3X0okJuEcg0mBvOgCxNmMrdjVgofIaAZawJmob
	 P8gUaJwUIITBFeiUJH/UNDx/3Lp40hO+hRLwjV7fR+J2trRTUyOPWF05p1C/KJJCcg
	 j7u3W0s2SCBD5HoHx0QcbXtNMMm3DCQavULni9S2VPTAWwdQneBqZ/gaW/IXHjcBDT
	 XHjn90qqarJDzH73FPzPWluIyn3BtAYNwUEbNMN48oA0ZDRz7BeGlpaZmbH2tSqzQW
	 dcPw8XqnqhXsA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 437C6C79F99;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 08 Sep 2026 02:12:12 +0800
Subject: [PATCH v4 08/17] mm/huge_memory: move unmap and remap into the
 split helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-swap-thp-cleanup-v4-8-b532a3f20e71@tencent.com>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
In-Reply-To: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788804732; l=3718;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=8rla4SJJrgTvzsnT4YVMcceDfbNPfTApzzjzHoKnAbE=;
 b=Z+m1XqtvYJ1c2EZdBoxY+IfPRPPJ6im1EtJt+NZENHRGR/MgPaiFx2721x3Qd59KKT4y/T4TP
 pODORevDxB8BeXsMdRBlxQxNitPBxqEtgb7p/VQel8vOSRKaTA2sS9D
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 26A19C0007
X-Stat-Signature: e7pabuy513o98xjeq4o91c7tjh91r6q6
X-HE-Tag: 1788804739-388060
X-HE-Meta: U2FsdGVkX193OlEmsMPbMTAizTTojce/IY/iNA+MU63W09D7qrS3cXSGB+9jcpG2Tagh6ELb9b9sz3PD3KEOpSehkp3goiarfXTABx16riev3z3TKk5FjMXAbUeFDg9JrK7nh+mCqH8KNm9qhZkTHT9hRwb77r54N0jhrEIzeVf5VVa+ACjg9vPPKAsaJ1sOZSnTOnUHJnFjztGMNJvZB5OjiGx7QHs05gfrBUNnF3K+IOTTB96AE7GkxbMkep2jYsiZO8R7BVXPwGHhV1gNvMH1cnA5OU/qFij5TZmFfI6AEEfBKV+I6oC+hr5ie9iHeHPw0naXAzWaLkU05/pBpptNmr9BPSt31NKfu8ihEhKaZLyNatyWaphcYklEW4ph1AawitquSCtgSWzUbbzk7KOVSeNDC7ImVwwzARK03T8UAHne5mAf/uaQ7mJRlVo/k1Rq4ul9y0tlcLlDmlnHPnkTUdpbZq5W3YYsghfV6WZ+AeUbZX6K2nMJQ4B7mYnOe8G5Hm9bFdEBz4xdzCW3KgpmHiTgNbL8mC8A4eKcVKdy52m4I8CAqGeipNRa1qny2/3+c5hpW0gdjiOzP4H7G4yPwedRwiH+wsNfekQYonQO3k2cA0GZjW2uDzortZisOks7V3rEzzFw4oTLphC5yxYonbOZALhIacanvXLMsrFCWhSHRCdaBgSKm3F+sLSsqFvFzSPHjhdNw9MXJ7kejIHDJRf4TAcgrxCtGKX+SdJXYORCwzn02KxnhDrwC+MRIomZwhricPRji6ktlktQzGVWLggSQt4Qa4czglb8QbsDCNX9Si3JKj8HfNgQ6UBtybnus0hpqf2wI5ZtuBezdiF40mhqk2E9SxWZgJ9jMsQ3j72P4z/dA5RBYDuGW/8h4hOfrrm+xAnWkcgkuelEViwjEDLmoRktPPN5y9NosFzh0ZLibteyFM/qTyYd4zUOwWERO3Dl6OPSNAJkSHo
 m68PcTWb
 GRxKUYvs88svk2XlEqG7NC/+C7HP7jVkygUFVt7GzC+mDxckUtY5k0QtbBdYS+kakcngaLKaHRUqI4XcCplcFHp23Ov3fbEfGOoJ3EScKNbIhnjQPldrbqmtDzSX8BaPjx3rGfo+78MVzkzchbhj9iSyQcgHAbAB5gnfzQI9gFBsOgfJMsTeN5tDTg7PH8BPV9iFiqibW0fysxOzHX6HsYAcoXwhpm0Wtggiblhc41T6yylV1UyWQfoR8ajxoQSBh4N6L29Hs9uCb+4jUjmFCctlCX3yc3C/GOHI8LZzdKYxNqweArYPJMeuRFSXDeC/E17pgf8dZZn+TmORfSsZgDXCuLLvOevaYa+kWPBZ6efIjgcqSI5GFa5ef6yTvU1wuGDIj1J8gbxSD30fIbJUtm1LAnHPhUQiq90/qLlmmfP3WOiZ4aHZX5TQ7BCDnzUJU8SDb0zVtzLH2BLEljffw9lcu4SZSnFsBFzLhKXDVNRmKxwZOc3irC1CPTLwFvlG7htyC4Fxg8ohDKrZWIJ6FCk4V+y9ycxAToTgf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To prepare for further cleanup, move the unmap/remap handling from
__folio_split() into the split helpers.  Only anon folios need to
be remapped, so remap_page() is now only called for anon splits and
the anon check in remap_page() is redundant and can be removed.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 47ccf2326cfe..7d7ce0726c19 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3640,9 +3640,6 @@ static void remap_page(struct folio *folio, unsigned long nr, int flags)
 {
 	int i = 0;
 
-	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
-	if (!folio_test_anon(folio))
-		return;
 	for (;;) {
 		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
 		i += folio_nr_pages(folio);
@@ -3995,14 +3992,21 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	struct swap_cluster_info *ci = NULL;
 	struct folio *new_folio, *next;
 	int old_order = folio_order(folio);
+	enum ttu_flags ttu_flags = 0;
 	struct lruvec *lruvec;
+	bool need_remap = false;
 	int ret = 0;
 
+	if (folio_mapped(folio)) {
+		need_remap = true;
+		unmap_folio(folio);
+	}
+
 	local_irq_disable();
 
 	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
-		local_irq_enable();
-		return -EAGAIN;
+		ret = -EAGAIN;
+		goto out_no_split;
 	}
 
 	/* Take off the deferred split queue while frozen and memcg set */
@@ -4055,7 +4059,13 @@ static int __folio_freeze_split_anon(struct folio *folio,
 		lruvec_unlock(lruvec);
 	if (ci)
 		swap_cluster_unlock(ci);
+out_no_split:
 	local_irq_enable();
+	if (need_remap) {
+		if (!ret && !folio_is_device_private(folio))
+			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
+		remap_page(folio, 1 << old_order, ttu_flags);
+	}
 
 	return ret;
 }
@@ -4087,6 +4097,8 @@ static int __folio_freeze_split_file(struct folio *folio,
 	if (shmem_mapping(mapping))
 		end = shmem_fallocend(mapping->host, end);
 
+	unmap_folio(folio);
+
 	xas_lock_irq(xas);
 
 	/*
@@ -4171,8 +4183,11 @@ static int __folio_freeze_split_file(struct folio *folio,
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
-
 fail:
+	/*
+	 * If we want to use try_to_migrate() on file in unmap_folio,
+	 * remember to add remap_page() and adapt it.
+	 */
 	xas_unlock_irq(xas);
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
@@ -4212,7 +4227,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
-	enum ttu_flags ttu_flags = 0;
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4300,8 +4314,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		goto out_unlock;
 	}
 
-	unmap_folio(folio);
-
 	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
@@ -4309,11 +4321,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
 						true, list, split_type);
 
-	if (!ret && is_anon && !folio_is_device_private(folio))
-		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
-
-	remap_page(folio, 1 << old_order, ttu_flags);
-
 	/*
 	 * Drop the mapping while the inode is still pinned. @folio stays
 	 * locked and present in the page cache until the loop below, so

-- 
2.55.0



