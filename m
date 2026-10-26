Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65630606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DAN+Pfx0
Received: by kanga.kvack.org (Postfix)
	id 5DC0D6B05CA; Mon, 26 Oct 2026 05:41:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2E46B05CB; Mon, 26 Oct 2026 05:41:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2B66B05CC; Mon, 26 Oct 2026 05:41:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28EDE6B05CA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:41:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 962C91A06BC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:56 +0000 (UTC)
X-FDA: 85364285832.17.DAFA97B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id D3D6818000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DAN+Pfx0;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007714;
	b=ODmgayDA9SAjUljjWak23O8H/37xAvz/nxCxm8RWGdKZpGSlyVTgJee9k0ZWwxzMWQrw3Z
	VAFcUOB5BNjX7iPjpNbGnJSFmeYxK0cLaPI5Dj876K86w7G+863eULesA147bEz9ldbGwP
	gpTGc/rE0EA67avvmBsYCwMqCq+USOo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DAN+Pfx0;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aGpDUDlUvxDHEJHBZRQ3tgIXl+rm1QtshrWtObqHbjk=;
	b=YlP/SWBiUNSNrrn4iZnsb0d7u2G7X/EZgAmCxKWP6xAhtJjt32oM9cjXrvpTilwJHqGxUb
	qKtttmDkRU0D2UQLpq53uLnOTqwQYtdqLpkIQh84EO4mGMjJ5AFOiKxGGnHT1/Yg7BNumG
	qh4ojgVBSOHkGoqGMZfxBUg+Q1gD8vU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8002E60A54;
	Mon, 26 Oct 2026 09:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5D11F01486;
	Mon, 26 Oct 2026 09:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007714;
	bh=aGpDUDlUvxDHEJHBZRQ3tgIXl+rm1QtshrWtObqHbjk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DAN+Pfx0l97EzGHUgR6+hY9dfBsCc7pWR3sIjaIjOTVvtghshSAsBv9hcX8q1HblE
	 3fh3YMs2Pph2GGcogjwJ7O/+IFfzC8GiE1XF8qy2ngbTSy/NwQTFeraQC1YL7WnIhR
	 fEpDr0APRvlivHSVrantysmOjNXgBtBvV/CKNNK12qtJlXERRFWMy5isq0eIUMqnmS
	 rYDGIfBDRaLMCTI7XyJEGDJuQrcpwD71Uy9NLKbHvj5kW5lbQPe03L1d9xDXZksHPC
	 2VnEHdJ7SfA1A8J50R3+GwfY965aSFELcnjaYb896n9s+vnY1dvW6FiW0n1+8z44kG
	 q6yPyiaO6r1+w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 26 Oct 2026 10:40:42 +0100
Subject: [PATCH 09/16] mm/shmem: preserve data in clean folios when
 splitting fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-fixes_shmem-v1-9-703206d5fa0c@kernel.org>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
In-Reply-To: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2232; i=david@kernel.org;
 h=from:subject:message-id; bh=EQ/dFnzmWeu2+S+buSrLImOQdEESG0dp5Zm7vqfc91c=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLuK4iz6U/dXKOosypTqWf9+Vm5HJN9NsysXzVP9vv9T
 jZ3FynxjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACayfhojw5efjec4Ig/7HL7+
 Iuz/MqX1Agu+PP3+ZrvGhO4JFjOf1N9l+KeUWjDj2rs7xn/LMr5zd96Icpyl+Td334clTYK2Jdu
 PfeEDAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: b47neftrwuos93g6jsqfeij58yhayek6
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D3D6818000A
X-Rspam-User: 
X-HE-Tag: 1793007714-363672
X-HE-Meta: U2FsdGVkX1/ucmVwLXZ5k0boef7rqUcV8ZM0dxgY4QlOE3KpN/ouZQnretDoAzTKh1CC/gXgL4dj2J2p8IqKgQgqOBVeOWf7YQQI+EGHzo7v08yiwomoXewpyLd6Ae2cdxXrf/F6LTyI76fN3jT+sDefSepp/4o0y9UTZLhg/Uxp4ZdKKh5vW0wZIA52hKj+KxdNmEZ7sFQ7JjvPDOUXZsjznP7trYWhFm6EoHr51BR9oON3PBg/NZ1obRvADtiax47kPFld74OjdK6Zcj+usgzXJT8h2oIuYskxdL14gNmLaV5DBW155WwRRasFxEhtZTm9GrqBLGoqryi8Krfpo3/2J8CPM+Ol3l6Pe8Flr3hxzNde6RFeFnlY8ln4tOkSe+hUEmfShZZ4MEMQjVqGFYINZTC3okspx5P1BBv+Y+b9YeHfQMuUSIVJRreQTWxqrf2UohPhNxhNQv5daoexhQ2H72C1w1W4UqpcOUWmz5jFOgYKUggZVTSMLG1DuHIIihgitWVZk1M6njPeaH5qXr/ZStiTaBufJyJZwSD/c8ung7QLF9NJtIETvKjC/buZR5rTCe9aYvaUWS6xUBEbt0qWye+KZk64E53YPjGxzKG0awW+oQ6dJDMIpbv12xkj7rS1ohedKfZMK8QsX+2BebsYlvXLEobkPhWeqrQR8XeiTyHms1aigLuijN21d8EyRWpygfVKqrPRL67NxOiTGTj14bmxr/LABxHxZvERmjBuwqUBplE80zRw44d1Cblo515q46eyiZaTHya3JB48N/Hkev50dVizGIINf9WUwRC59NFut953OaRqfQggoMd46mTrWCEcOe0Phh0/9WA+UqAIrv/X+GBZDjr9E0sRBxEE8MPPxmYJ2Tmg4yKg/I3T3J0uLEZaNbM802f7jo1SvcJ4vS9icP9NZw8j5DxqFsdQ3XMejHzFsMo9KPyF5VWog7WRWuQtd8QekC8T06A
 eQ1eEwzu
 0vvPBLojke2k+56n3M2rirA84AlLlArQYT8ZeqPZLhLZlya8B5gZlD0d1G8aD19wMEBD2CJE9ysxAqt5G194ZXHtgkXzGIfFd6jn4fsw7waxB5M3u5mJwqL08LXDQHjn1gBLuT+nYVDdr2gsryTl4Ytx5P3aVb9jAGdRYu2xKRITo666yisJ0a2T9B3LiZp+gaRlb9rsn6Zx5V91yFRrtXdKvAwLiI5ykQ+4s7EktPmpfNZaokcWnH66wSoV/gz1oA9ktTvObtHWInmTGaZtqe+UQ3ZFQJmxHYVga2QwFHE/QlvB1b6Dzd6YUOxVI+k2/rEKX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

A shared writable mapping can have dirty PTEs while its shmem folio is
still clean. A read fault can install a writable PTE, and a later store
sets the PTE's dirty bit without marking the folio dirty.

After shmem_undo_range() has handled the boundary folios, a concurrent
read fault into a hole below the new EOF can allocate a large folio.
For example, on a tmpfs mount with huge=always, the fault's offset must
be within the file, but the allocated folio can extend beyond i_size.
The final scan then finds this folio and calls
truncate_inode_partial_folio() without marking it dirty.

Splitting normally collects the PTE dirty bits when unmapping the
folio. An extra reference, for example from vmsplice(), can make it
fail before that step. The fallback unmapping on split failure excludes
shmem, so the helper still sees a clean folio and drops it, losing data
outside the range.

Mark large folios dirty before partial truncation in the final scan,
as the boundary handling already does. Exclude failed-fallocate
rollback, which must discard the folios it added.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: b9a8a4195c7d ("truncate,shmem: Handle truncates that split large folios")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: simplify descriptions, adjust comments ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index e2c3b04051833..938221c473f3f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1474,6 +1474,15 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 				VM_BUG_ON_FOLIO(folio_test_writeback(folio),
 						folio);
 
+				/*
+				 * A shared mapping can have dirty PTEs while
+				 * the folio is still clean. Mark the folio
+				 * dirty so a failed split cannot discard data
+				 * outside the range.
+				 */
+				if (!unfalloc && folio_test_large(folio))
+					folio_mark_dirty(folio);
+
 				if (!folio_test_large(folio)) {
 					truncate_inode_folio(mapping, folio);
 				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {

-- 
2.43.0


