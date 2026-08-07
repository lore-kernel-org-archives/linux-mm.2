Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3042C5ACD1
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A45106B00A3; Fri,  7 Aug 2026 17:17:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19016B00A1; Fri,  7 Aug 2026 17:17:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81E016B00A1; Fri,  7 Aug 2026 17:17:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E89B6B00A1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:17:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D676012019A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:53 +0000 (UTC)
X-FDA: 85075735626.30.F38E404
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id CE7D6180003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ub/1Y7Op";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786137471;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yf2eH17J2JnoPPFllkQ72e3hChKeUw7HB9uAf+4lcvk=;
	b=JoP8Mnn0JRILzUExJvFgtE+jk6CHDoVobagNb4IVt+uWVEkw930+TZcWiA7IH8ZVfL4SVR
	ZUJ9Qlt3a7DU0Oqe1CIcDA39cNdh10m7P7L/wCDXzfRDSeFNVXFOSpSnAEXDpf/LDAVyxd
	VoD4hv+1kn7+DAPaPiXFt9GTunkxyzE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ub/1Y7Op";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786137471;
	b=BNQ1SUYsQ0FfXbrGhyf3ekBAfXIbrXsKVEmbazhYUKMNpsKIeTGlkZxJ3vbBjVQWeE5JEt
	G/z1Ydx6iZrozTNmlWKzbm4ztDlpogFwG3QY+OvlqfT+bRo8b6ZlQIe20YQJuuZ1qXj1mv
	0mu/kQpq6kW5+wLSRQNkLa5fAcx6FJs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 28BB444043;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 082BCC2BD05;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786137470;
	bh=RMQj/ADtXLid5GNTm45wXQFW8eJpGFU1MLjh5peezVc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ub/1Y7Opi+xUA26V40Lass7adw6P90cGHSNhWBp0a+//G/CG9rgSnv9Zx7UFRB1go
	 FEl03QH69nKJqB3RwVw7bE8OawVEwegfOZoVteR5xqZFm6Z+VW0K16izqWA9dVVn/J
	 aWquVbYdgm3DAUQU/zj8dHn9e6aXKdByw3bputSzv0VxZG07A7boJcqsAJvBiIDyeU
	 mHBmKbPWg0eUFsy4JqCaSwU3qAqJGl2eDqTgFNAx7kkcNVl2oGSg6VyLLC23zzx9A6
	 W9LGQpQcOr0MqtACrVMcCis8wWuKKUqbjz7w0nbQmbCek971WQ0YrhNzyCiGDfo+Mx
	 ctj6PQ4jmN+hQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8325C5AC9F;
	Fri,  7 Aug 2026 21:17:49 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 08 Aug 2026 05:17:07 +0800
Subject: [PATCH RFC 06/13] mm/huge_memory: move EOF trimming into the file
 split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260808-swap-thp-cleanup-v1-6-689939a7ccc3@tencent.com>
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
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
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786137467; l=4129;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ZL+oPmr0JHpxplESJ7EerMTHHdu34aMC9es8n1iXisQ=;
 b=TUuL3slW4TdvxV30rEc7OV1KPB5pDFSkgui5vPimNk4tOvZccc4VWNgqV0EZxXrHdc9bAkfeW
 7m5+33bUPJyDUPCcJYrU+saVmc62A+8kjy3ie6RTbvOMfdDqPsmOo1l
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: qaxb4w9eapfkqaewxyfshtjn3x4nefpb
X-Rspamd-Queue-Id: CE7D6180003
X-HE-Tag: 1786137471-97738
X-HE-Meta: U2FsdGVkX19DcXnB4qjQ46Gf4P48JuA9WZ52kpd2nTFQNym9kGTomB4LraJKSzUaxE7eDc5bk8yxTCZTs+/fN1YJ02l017w2nUrVMb3lYo60r314PDrVYctP/S+X0wMy0G8Tv0O5a0fp97lUJD//1/59v2jnPot+e5wkJjJ5hHmE/5REC/GvdF26kuwg/kfR4jvEcWB4fG0UXlDenX8uBHiHgPEXSIzCQ+RoV9qITmVWnsD2YB6xMSb4nK2BsUi38hDXqZuarYdbYU1Ys8ymbnJgTJzZeblq6r97/TV0q4s7pQCronk3EqnaM07qDcS8/Iq7McpKrWe3/0NC14xNlfDNUJdlLRMFd8j1jEUX6CBoc61TzmSF1eLQvv6SBRuGz1U/5SxkHXBicm0hdKs53oU2h+LC12DqyGJt4dNh+cvjK76w+HeDDWyg2zwVpe+XWhkI/Q5ehyX/ahoAYcN/6e4bzcXoarMWvieB58HlQJARJ/qFzF22r2FWUtNUOVB7SyTwIeK3TUJSo3hrUMp81X93h0+wT+/ueVONpzEn69VjEPq8lz0DGqXNdL5KXbU8tYSR9/9QqPVxldTXMYhEbzxBHUzg6IZspv0rFX3iiBhdZpplgtlYZvNJdD6sLJxAW3rcrvQCLywiX2PhyfmE4MKj4VvYZXMqLtonSOnP+UvYVmSc24dJ9cLH5GRNp/cB6/JJZ+WT+cakoYX+C/I3YVQEDNSA1E4/l5oBWeOlmonnVxIkn+6C2VMW4YE3u8SI0I05xtpRFm7oDmGnPvfLtjQgd30oq6IkCsOXBpAzYac2JIY68A0dw2/OX1JG9euG3jE1uKhVn7x+uClTgkDsl8K1c8Ghi6BjXZ0BR81WqOZd5L2p7zubb0AZJ+7GAnnRIW60lE9c2JuBtyC1XmC2s80WBRaYxlaGv0bUUZmfZmS4795Jo1v5ERDK+cPclAGIjNqUMwtCD2Zif6/iQXr
 DBPRWkPj
 AvEiID+ACoLZ5C+3lsy/XgnWBYaiY6C29TF81pNrx3mlZMYH2HMM58wxYQR2OkJ74jG/KvcrUagj7kHsovC60kdIN10DQaWVkFYe5IeyeOXXjMmj9jjPMbOdo2EiHkY5PDJyWGsijzchmdfW77QSom3OPWRMltaGBLUNwkKRsOsh4HTD4SPBvEfD4/El7597USGYgFoyXoLi+k0R7dwLqOJ5s8Ngeq56G6BgWAjIzRTpKpMF8fyCvlUcvPcL0CPuyFgjTFoYmNLaxN7fZZTBbCQoufAiDwKNs2YVSll3/xl8Yhfd24dwOQMsuiJeEN0kGLPyT7c4Lp2aLqramoj+PQWIjwE/sIrl0z4lwTfr6FunF7tJdqv6nr23KV/z2UqabEtqtmTDa/pHLbllQGxBez3UyPGk04UMNU+743gftlCmJfhMDtLwI+br+VZ84zulzhfL5ru1S44Ogra0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of receiving @end and @nr_shmem_dropped from the caller, the
file split helper now computes the EOF boundary and trims pages beyond
it itself, as this is only needed for file split.  This drops the
redundant parameter passing and sanity check.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ca9430a6f8d1..72f5d0d24127 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4031,14 +4031,26 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int new_order,
 					      struct page *split_at, struct xa_state *xas,
 					      struct address_space *mapping, bool do_lru,
-					      struct list_head *list, enum split_type split_type,
-					      pgoff_t end, int *nr_shmem_dropped)
+					      struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
+	int nr_shmem_dropped = 0;
 	struct lruvec *lruvec;
+	pgoff_t end = 0;
 	int ret;
 
+	/*
+	 *__split_unmapped_folio() may need to trim off pages beyond
+	 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
+	 * seqlock, which cannot be nested inside the page tree lock.
+	 * So note end now: i_size itself may be changed at any moment,
+	 * but folio lock is good enough to serialize the trimming.
+	 */
+	end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
+	if (shmem_mapping(mapping))
+		end = shmem_fallocend(mapping->host, end);
+
 	xas_lock_irq(xas);
 
 	/*
@@ -4102,10 +4114,9 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
 			continue;
 		}
 
-		VM_WARN_ON_ONCE(!nr_shmem_dropped);
 		/* Drop folio beyond EOF: ->index >= end */
-		if (shmem_mapping(mapping) && nr_shmem_dropped)
-			*nr_shmem_dropped += nr_pages;
+		if (shmem_mapping(mapping))
+			nr_shmem_dropped += nr_pages;
 		else if (folio_test_clear_dirty(new_folio))
 			folio_account_cleaned(new_folio,
 					      inode_to_wb(mapping->host));
@@ -4126,6 +4137,8 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
 
 fail:
 	xas_unlock_irq(xas);
+	if (nr_shmem_dropped)
+		shmem_uncharge(mapping->host, nr_shmem_dropped);
 	return ret;
 }
 
@@ -4162,9 +4175,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
-	int nr_shmem_dropped = 0;
 	enum ttu_flags ttu_flags = 0;
-	pgoff_t end = 0;
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4241,17 +4252,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 		anon_vma = NULL;
 		i_mmap_lock_read(mapping);
-
-		/*
-		 *__split_unmapped_folio() may need to trim off pages beyond
-		 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
-		 * seqlock, which cannot be nested inside the page tree lock.
-		 * So note end now: i_size itself may be changed at any moment,
-		 * but folio lock is good enough to serialize the trimming.
-		 */
-		end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
-		if (shmem_mapping(mapping))
-			end = shmem_fallocend(mapping->host, end);
 	}
 
 	/*
@@ -4267,16 +4267,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	if (!is_anon) {
 		ret = __folio_freeze_split_unmapped_file(folio, new_order, split_at, &xas, mapping,
-							 true, list, split_type, end,
-							 &nr_shmem_dropped);
+							 true, list, split_type);
 	} else {
 		ret = __folio_freeze_split_unmapped_anon(folio, new_order, split_at, true,
 							 list, split_type);
 	}
 
-	if (nr_shmem_dropped)
-		shmem_uncharge(mapping->host, nr_shmem_dropped);
-
 	if (!ret && is_anon && !folio_is_device_private(folio))
 		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
 

-- 
2.55.0



