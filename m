Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E9D8606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OzH8AW7I
Received: by kanga.kvack.org (Postfix)
	id 90FED6B05D5; Mon, 26 Oct 2026 19:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7516B05D6; Mon, 26 Oct 2026 19:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FDAB6B05D7; Mon, 26 Oct 2026 19:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9296B05D5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:24:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE619C08A5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:24:32 +0000 (UTC)
X-FDA: 85366358784.30.8B1B711
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 12D672000B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:24:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OzH8AW7I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MUiVnQIcW4HK+Vvqa5OhN89hQ5i9YryKSTF3EOLnRhs=;
	b=SPKN+BFHgGptBALhQyU4FGyR6egKdt1u+nVdVxIbASHtUX7ZF+FzKa2quHuSvijGcCclhY
	z+Ykv3alNhNG/rNNfzjV1PIPgqk4PjwJxKnuU/7653UwzW7tsbMQUcoULHArQcQzzQnhKe
	QaG4voXqkBIvIFz64bmEhwWx37vd/ZE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OzH8AW7I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057071;
	b=cUAnHPwHvP1laQ4Ey3pyeIPZvlpYfD1xvE0lZkoChrNDVftagILXN+2RED7g5eaz7Ux06h
	KosU/trdTuyNr3Pjgj8xPydve+oQMVNzFFulDp4xc1eK5DOOwuhV4mbu6sV7cRVoW1+GbO
	4IJXolpqIRTuK/xRtgUJ9hWaPW4hlUE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A341C601F9;
	Mon, 26 Oct 2026 23:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DC01F01825;
	Mon, 26 Oct 2026 23:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057070;
	bh=MUiVnQIcW4HK+Vvqa5OhN89hQ5i9YryKSTF3EOLnRhs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OzH8AW7IZVGSLh2s2JrXn3LgfDvl1ZX4yFb3GlfsKgz8zoruMSoZEux9/uq7Tk7sm
	 cs4Oevuzm9hv19FFmzb4oVFDDyN8hTsXOa6ga9Wfsm5s0IDEHvgPHKHT1iRlEt6Wlx
	 jX+TKAvX+UWsfR/O6g1EGXksf6/NAU5KAIgRyfAIxs3u0nD6husexzjL6i0H+JmNDj
	 QvoT1xFpiuuavcAk/OvUsImVM/yKW2pqjZDDZvkv/sFj6K5bneJ1bUwoy5GawuHUzZ
	 931Cja01VhM36lJwgGvGp6aGe8/8ws02QJV+KXzzxA8UueMTlx/UmBS8gk/lw+F0G7
	 w2duGXjGqq0LQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:41 +0100
Subject: [PATCH 21/46] mm/gup: fix out-of-bounds write for nr_pages == 0 in
 GUP-fast
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-21-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1165; i=david@kernel.org;
 h=from:subject:message-id; bh=+4EllZ1FmTDP2PkVD3jcp4reP8xmeyVcibo3mkhoq5k=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu358669na3pAFl6/pLlittcCkyfDvlTqOwCWbPfX87
 u3WdpqU2VHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEohMZGW49v/1k3cwERfmt
 n7+fPaFx4sZu2c8NIUqvN6qeE//yxBuoYsd97QN6BzL9n+U45fx9aXrcwfOcrdWLPY5TbjzqWTN
 3FwcA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 12D672000B
X-Rspam-User: 
X-Stat-Signature: a8n7sa85p4ggmmn4dcqramj1bc5mehij
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793057070-887222
X-HE-Meta: U2FsdGVkX1/5nF2Vd3mQiYCnvTsFC66poi+8GCvTvEa1hVumk6/1Q4pyHbdog14Iota51Zt/RAv2xedGIinBvipWScTgM7bIoGQNQE//0L2E7AlHBCC/7l01C5hD+K+Fur2tBCFThB7jM6nm+6GBPLhh1aDYo4sdMfFGeyFzx7r8vW58uYV7vk0RDeM52qPhEcJO7gjFvJt6rmKWGYcwRcFr2CYkkxFy1DFPqM2/smmAcVKCMUWgwEOPi7B+xtI4QdjW4oKhdOnbz4zNx5tQtzeQDtn1tpLNJ9/LSVvxcLR0Jt7t1P0pp7QjeuwEpDCQMbsmBz3/qQoSnwcwrMk28s9ZHPTm76ob9E7ggbfac2BC+qiiJ/KgZh8407/EeDOqrMbv1QcNRH+KdvyKzaBHmy8VTlQ9kQD2qR7wButb3pOfGmjPy/R0aqt8sUNwk3hbwUZszElgMIPbJHi+XTFkpKkdVDWbbFMOaglXQdGV7GqkscvZ6iSqrOziEVHnnEV7T2vExcphn0K4GzKmqSj/ADU0XQsWHtp8Du49RnzJIWqusTTYcX7AG5nmDm39NIl3hC4B3FnFu4zdUDDru6TAb1p4sJAHk+LK9OVhE9Vg48dSCHsTgp/WPrRjks4tQFoJrpYXGLKwb7/WBJW63qbLYpGs1BY3+LsOvlsRmytrEykAMZTOILpAj4PvvI11HrWvGS+G3HdxF519TYQkp2c2tsInF2r6q2tAxxqsjBXdyxAXBTv6/T44OIYKLfaGC/wHMpdBV7CUCpmn1CkztCTAMjjTcJS7CUjmEzvN1eqXVhdiTgFIU7XAYtVnA37ynp0oJtwtXDpLV2ul+FfhN5uyrqJGDnKz2NfyaK2yzj/L4sKM6KIhUFuByn+I7vBZtmXV/gXmI9y1Bt3rfSXBLY0Gcdv9hZZZQH8LEGAiQYL5quaWQl9F9QCQ1m78QcYVwkDITswL1ebXYlutp1Bixdu
 uETrxlc/
 zlj6RJzJtZNH9f3/idRhhrRD0znUYRWii70+5F6reKdp79OPtiI3dXuE+9F4CdytsAdgXfzcmQ6nOLLYEi8HadgcI13axZNdqPOhBUB/NdogkDff8m8eFfuFBZjCY0PtuPvDV3oSEy/dG7/gHBuF8ZRp29DRX47K7fab5/8eSY/xHuC91km6zvjKDUFcofgn3RmofBlmU5zmzLLxkMmgZOMdluHRpDNAetVPM72NLCv11iD6O+/E0wNGDNLzIUHliqSr45eux1rzHdEpo2Hi+LZC81v+xQ86TGkxpUUElIeeuxnC3mQ7dUNqE8+9IgWOcha9X1CczxqJN2w/+ifPkClYBxVjPsTG5xLkGviQmgEU5yNY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

With nr_pages == 0, GUP-fast still enters its page table walk and can
write past the caller's page array. The old end <= start check caught
empty ranges, but was replaced with an overflow check.

Users such as OrangeFS can pass a zero page count derived from a
userspace-supplied length. So let's return zero for nr_pages == 0 before
starting the walk, just like GUP-slow.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: c28b1fc70390 ("mm/gup: reorganize internal_get_user_pages_fast()")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: simplify description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/gup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index 47e7ae152cdf1..9906965893431 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3204,6 +3204,9 @@ static int gup_fast_fallback(unsigned long start, unsigned long nr_pages,
 				       FOLL_PCI_P2PDMA | FOLL_HONOR_NUMA_FAULT)))
 		return -EINVAL;
 
+	if (unlikely(!nr_pages))
+		return 0;
+
 	if (gup_flags & FOLL_PIN)
 		mm_set_has_pinned_flag(current->mm);
 

-- 
2.43.0


