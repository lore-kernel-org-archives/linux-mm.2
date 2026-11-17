Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20AEC606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 15:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aiNgqNJC
Received: by kanga.kvack.org (Postfix)
	id B18E16B05B6; Tue, 17 Nov 2026 10:58:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC94C6B05B7; Tue, 17 Nov 2026 10:58:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 991426B05B8; Tue, 17 Nov 2026 10:58:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FE2D6B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:58:54 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3466C04CF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:58:53 +0000 (UTC)
X-FDA: 85445069346.01.A7AE881
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 14FA72000B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:58:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aiNgqNJC;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794931132;
	b=sUfcWSPlCDjtfGHrMwPD45JabLFE6tF9yydXZ17g2d6X7ZVAkGGau2Js9AIdzd+vsLyDjr
	DBJta7xs4ur1UetPYjCrdnKfV6+PXGzSvUlcaYBn8NVKFsCxvOs0mdzJbHlSR/+KPJ+edy
	VhSeCiHCln5zJEzk6tn1SVzPbNxHad8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aiNgqNJC;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794931132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SH3B96UoxOckJWmgiMFdQXZ6He/d2a60d40nEzWGR/Y=;
	b=tNRAge0TejnLJIg3nQugn2AOcbqNfCCfh0Mg3RFfLdnJg/jQK3W7IHsCSx5sO7C0DPhYiM
	9MysOADzsY9r/Q2QHUrmdP3XCuR6rNi693q9iUmPVjK+PSCwO+QjasNmnXNabitLZRQ1S6
	aE7qUuXy0FxvuHaBlWk1gn4QAZuyWR4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A795460F97;
	Tue, 17 Nov 2026 15:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91E21F000C8;
	Tue, 17 Nov 2026 15:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794931131;
	bh=SH3B96UoxOckJWmgiMFdQXZ6He/d2a60d40nEzWGR/Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aiNgqNJCBDq75GpvSOEPsFj3zOzPEJ3ehg7/ZUjkX5SOrdNtkq1McDKKzKFSV8aAo
	 WRtOVxAyES7+rdGx3KU0uqhEP2sz14f8ArxZjkHc5ESuPKR+ydPlRhhwnuCQew7tzB
	 L8ll6paqcwd3yyCmEupFz1TFeQp9Jng+5VadnP5xKjCCvvsxpy/uqo0OBJZHdce+Os
	 jfOdqz+rZfJBCmNfxfJdUseOQzECZpfrChosWk/L0DL7bF7Ig8aOBIZ0qQ1XPMrGdt
	 YbvdpQz5OulOc/7+sbj0UHxhTExEHBmGYFNza4SLbyyiwk2imMiUJ8VgZmSaKAL9Iy
	 C5sw+ZRl5fPsA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 17:58:34 +0200
Subject: [PATCH 3/3] mm/memory: don't upgrade non-present PTEs in
 insert_page_into_pte_locked()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-uffd-dax-async-wp-fix-v1-3-c9a30f27f452@kernel.org>
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
In-Reply-To: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jingyi Sun <1045704958@qq.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, nvdimm@lists.linux.dev
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 14FA72000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: rwqij7gwbsbj4uugnu9ker6ybp5ur6k7
X-Rspam-User: 
X-HE-Tag: 1794931131-195707
X-HE-Meta: U2FsdGVkX1+Nt5iXy4+xjSIB5X8HGB46bcUayf6UQfS9xd+dBIrzNtd0jbiXB9izqifc/R02H7OqrWm/K5pVZLgU7touGVOEAx3wEEw+3yMYQehKrMZQqmPmUzdasYfoIlR55Tgw7Hh6fpe0rjdhzD56rKK5yVZArtkgbiorXYfhKJEL2Ci63idxA5fvKKu14tKklkHSsVRdzbYZe2G975ixA5NoSRjekfIJKP7oU8xgpVGbjDgLDFqeNNtTEQPP3qd9yIsbqDJ6x+X0BDS5mZ/DbSLxaK8PCOzV0weLAavtx56RwABwIHBCsmt3mH5Xf9sPcR6QypnvOay8lptXEHDXk8aDnXGGtZMql86KhfKDxt3U7NK136q6Qm4RCa5e91dLN+yXOzI+Ml1mTZWUSmTuMEn6k6NPpP5lpfdD8Bl44HDek8/Wv7YLYdM7oSlRTIuc/+j58LzVloyEiXfSs/wGH8SAjhO3K+A2VSm1n2eGHwyf48eSWql74kk8E6B02MM8rk+z5hqAYKaTDUaB/lvQCPPO8RU8XKFrbvB2pG0STvyuGdeV5FtP7eX0CBcm+8Cp8a7UUcL0Hqk1F52Z/dSYwdK+335exKRsytX94vXsMw25C0+TaRdAV/qaOdDB/kznW9DiJ6voeOfcXyQTtoIsw3gM6nAZrgSUn8VhnSpCPqZ8YJybmAzKVfintxaXu7osTnMyBNFKtrqoi/jFTY9/KbhfvKwLEMliSaRZap+I2+ELJeqYzEjICwJZ30p6wT01NHTDxaVmXkBptkDC6IF19bRttyIxUA0IIx5V7sVRJp6pc1ZqA1O7P9WtFkfcDe8Pgywj0WGVj/QGWoXcSBFZQV3mFt5AQtCA4BrE9JvYMTanqcVIK2AmtPG8lZgpBJhw2Whec3EcLDVrPzUriJGi75lxv2Dlr/awPTA9SW2U7r0moI6yZoj7XLLwQlDiUfC+LccX7Ul7+AAUT+U
 56bITikv
 JP58qZhUVvqLxI1Knmwl1aw8s646Mg35w8mD7BvmkTkBZsSgVBzrtTc6adgks5SlUrljcI2YYX4zYv1DUQN4SY2tqcwuRXJj/kGJZWAW9Oer4FBMcUaWPUJP2yIqk9Pw31Y7m8buAUUZwTU8j36g3DSkajdMQzv3QLOyeiB7mNTCVrG943Ymtt6zDckMJgaKk9MFL5V1ZgjJxUV4foF91yGN8sUXsMnhm2PmOmZRaBGwh96pIIEWbiyNkFfoHMBKacgcnZ2vSshtVxyP2YlV+PZ0mbj9vuV/Bmny0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On a write fault insert_page_into_pte_locked() assumes that a non-empty PTE
maps a page, compares its PFN with the page being inserted and upgrades
the PTE to writable.

Since guard regions are allowed in file-backed mappings,
MADV_GUARD_INSTALL can put a guard marker into a PTE of a DAX mapping
after the DAX fault handler found that PTE empty and before it inserts
the page.

vmf_insert_page_mkwrite() then extracts a PFN from the marker, hits the
WARN_ON_ONCE() and fails the fault with SIGBUS instead of the SIGSEGV
expected on access to a guard region:

  WARNING: mm/memory.c:2489 at insert_page_into_pte_locked+0x47e/0x490, CPU#3: guard-race/157
  RIP: 0010:insert_page_into_pte_locked+0x47e/0x490
  Call Trace:
   <TASK>
   insert_page+0x6f/0xc0
   vmf_insert_page_mkwrite+0x31/0x60
   dax_fault_iter+0x3be/0x5f0
   dax_iomap_pte_fault+0x1b8/0x390
   ext4_dax_huge_fault+0x1a4/0x2f0
   __do_fault+0x34/0xc0
   do_fault+0x179/0x610
   __handle_mm_fault+0x8ca/0x1250
   handle_mm_fault+0xb4/0x290
   do_user_addr_fault+0x15f/0x730
   exc_page_fault+0x83/0x190
   asm_exc_page_fault+0x26/0x30

Return -EBUSY for non-present PTEs on write faults like it's done for read
faults, so that the fault is retried and handle_pte_marker() deals with
the marker.

Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 66ad58429967..a80925c61706 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2474,7 +2474,7 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
 		return 0;
 	}
 
-	if (!mkwrite)
+	if (!mkwrite || !pte_present(pteval))
 		return -EBUSY;
 
 	/*

-- 
2.53.0


