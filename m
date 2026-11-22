Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEE87606A331
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ui1TIecL
Received: by kanga.kvack.org (Postfix)
	id B7AFF6B05BE; Sun, 22 Nov 2026 07:42:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B03DB6B05BF; Sun, 22 Nov 2026 07:42:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CC196B05C0; Sun, 22 Nov 2026 07:42:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 742C86B05BE
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:42:42 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3226406C0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:42:41 +0000 (UTC)
X-FDA: 85462718922.05.1D113B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1477040002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:42:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ui1TIecL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351360;
	b=N5yMFtwszuZQhzivmUpvB3lopLhAHdStNBqVqpUzOQBxRK1I+DpShYCVJUaWYPANMhmRsL
	ggxcxh9oqj5ZeDjkw8jM2scRe0VZda448qXgoz1JJPWSi3mUTxpUdilYgjYRjEx5o29t/7
	NII7iAil2UPPXr48YOge5BY92+2ZbD0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VocNkS/2cBGTqC/iQ+yEVdcXEbMXCrY7zeEC95RbIoU=;
	b=wZMMqSuBI5BSFrAmGUZvrP8dbH50N1yd38XbDCx8aU+pSQ+tJ+K8/t4o/FlhPIEPGxamXr
	570CqNBMXSTj6/hvTBcEXjuUi/2TjnPfHrX0TGv+oY5CK08JtTmqnqPvgzSZoMgJhdUnJs
	KclXa4lXOy1BsRY9hs4tIxSyJUN9Mpc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ui1TIecL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 142D943AE2;
	Sun, 22 Nov 2026 12:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61DB1F000D4;
	Sun, 22 Nov 2026 12:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795351359;
	bh=VocNkS/2cBGTqC/iQ+yEVdcXEbMXCrY7zeEC95RbIoU=;
	h=From:Subject:Date:To:Cc;
	b=Ui1TIecLzRfZvfuZEq3oVQVO168omOXqtg/+Obb8kscYYVhga71dOJoyd3yF5d8tD
	 VIhPRl9yFR2eNKo+S2XB0VQ3BBm9aLMfZPW2oMutfD8gBOPs+ghhND5zvUFO/BAAxZ
	 p+tkDyFjnj6eEyiTQY+bqTvBgcFpDqakl3Q5nr9PkZOrYZSQ9zSPLEl2XwA9r9/JG7
	 W/7uLVrdAWW6Kvn//5faO9dCi1pB6qYvqTP1KShYslpZr09ApQEZ1GOYcjqePDcKwD
	 RxivDXDqZCANZXw/JrGYZjxmapcGYZepAw3e4sV9L83JbcoTnQ3LqbdJWL8G6yG8XR
	 XWaDBLuuN+tZQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 0/2] mm: fix deadlock on the folio lock due to inode
 eviction
Date: Sun, 22 Nov 2026 13:42:16 +0100
Message-Id: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/yXMTQrCMBAG0KsMs27ADKVoriJS0uSzjvZHJq0Ip
 XcXdfk2b+MCUxQOtLHhpUXniQP5ijjd4tTDaeZALAdpvBfvRu0tLmgNaYg6thkxD3N6uLqGHCH
 SdKfMFfHTcNX3rz5f/i5rd0davh/v+weun7c5fAAAAA==
X-Change-ID: 20261121-migrate_reclaim_deadlock-44e28e226b9d
To: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Heiko Carstens <hca@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2395; i=david@kernel.org;
 h=from:subject:message-id; bh=EVf3IUvbYA/h7bHadHrnyZL6o9BArIID6FP5pA54HGY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKZHuu89Sg1TAtgl6hLsJKeGJF87WPwHr493CfKH8bti
 dmyIdGso5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIkcyGBkuJryZkPgurlvTi44
 3K1j35XTk3fuc+BFNv6gE4p6lTK/NzMy3Dlz2TvkyJPPE78FT5XMl6vkkzdTPnbbwbM45u267G8
 HmAE=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1477040002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ayru1eg5is64rp3nta3cuc1r3ygmfbwz
X-HE-Tag: 1795351359-604578
X-HE-Meta: U2FsdGVkX1+XdjGkNzF1rPsBfjuakM5hZHEu0b1Vyt7nXoSA4yM5qjtLm9hOkmHF1iQB8k5cTUmzjLVTZqpPNYq0/9q+6qNxBVsyprtHTxLImjAg2d9GTmdDte18nm+SuNEFXIzrxrWMT5gow9bHNhOE1tdySDjdea+w0O+IZmS2MM0r/Vq1zC8hSvzP0hIfKA4IJCloM2ydb0kuuFiNGwsfjFFHVGxnNvUYW+38yFlLctbe9i87rL1vCVrxByJFcwuFgZRjSAczXSEh0PAFTCDZof03XfCFg2W27mJeu+z9R392bu1crlID3zYJjy23UYJSBLLGOc4vnHjgSiNEiZfp7YAKasB1zJIgDYJh+00V/JAuy8Xnicr0ldAW7YRELNI0d5wfkYDIw4TSjKjH6cI8uW5WVh/gd1GtMNJ8oq51NvSB9uaTbmeTagF42q9efTWBbI3ucrXZMdSQVuc8Fm06I37Mf49I4dngaSExNy3cvErcm8ZRE2qaqJz3hJW/yGXQ5r80p80T6hAPOPcZIAtj9CadgHWu6Td4wFvy8piDzzofTMlg3owUfE+tIMuDpaBwhgA3SNhfNOsUuoblMVU5jy7TioOPtRaV5byRbSO6Sa7jaVJ1igy8TXwHcOwEV27gHbDz3+bU/tbKEYjmDKw0qXfVzsJC30iq0MlDJrtDQys7duhCW0jV0rTNzsk7Hn3zKltXCbIefQkghmKCxdOFfpZ+aa9BBAz+dpUgF4iJuGxisTo01vpg3nu35tHxRmQL+CpmneSOY+fLqWvbQn7m1i3sI4At+bZD3LLVD4zRKoI5VbUEjtf943MX8HljvH6r/sbwncegyFZI/BAhML/8uuGYnwFw53kXa/EbemwfP6y9T4IktvbniD6HPXcu2vbhrZbUsRLdSjc6bYa8cuN3UohiBnL/W5bidEejNHkdNNnD4/Uf5jGQll6q6/5lyRgQcxqZjYzcDZKr8xi
 HtSMHScL
 EGM7p3JEbedmLssBXm/aE323/zzGNVOZkOs0E5+mpcLN3JlHJ9qjcdZsDrwwjxq7S77Flgbv0UNEuns+ahaOwBLbn6fCYdm6fpJy4ll7t571bsyEA6zBK/I7wJfVUZ8qBKpbUYeOcCkD2rFOisZlJ2nKYQTc80MsEQJXo8a9N/ncc3FauJaqgox5GBVmZ9H26pT8D/MrIjmb24Do8d73kWwYWvCVVObQK3XZPS1WSOaqHkTNF+D417E98TA3dip6JWMNv+Z5hXKTS1ePknzmy/OdpUE3s0qWICjXvdO/3HEcc8G6J3F/fRgvu6pYMNGrpJfYjZWRaz8ie368roBUNMkSw1IXwdt14JhDACkj3TSSzO/JWKzMEs8GTO7od+xrwk5AC+1XuuA++YzTK8LzKwzFyCxnh4V+UEu1ciC5E6ShMrMM4vXOqyKDxxMKQTKWDWP9z2LiI+sqrWh5oiUjoWOBV34PCNtl29oRvYdQZ89yRXOGahp9lyr6Lb5TQYJNH4KO2yiDF0PjYsEWH/+lom6EkWC/ssFUksdSbsdGxIVlrTZJUaSudF6gdgsSD9xQT7aBf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Whenever we allocate memory with folio locks held and trigger direct
reclaim, we might end up trying to evict an unused inode. Evicting
inodes with a populated page cache takes folio locks, and if we happen
to need one of the folio locks we already hold, we'll deadlock.

This can, in general, not happen if we also pin the folio's inode: for
example, through a VMA that cannot go away concurrently. However, we
have some scenarios where we hold folio locks without pinning inodes.
Examples include page migration and some folio split users.

FUSE makes this easier to trigger, because it evicts inodes on the last
reference. A similar deadlock with FUSE was recently fixed in FUSE [1].

Let's handle folio splitting by simply running in NOFS context. We only
perform small allocations, so it doesn't really make a difference.
Interestingly, this also fixes one of a handful of possible memcg v1
deadlocks.

For page migration, change the code to allocate destination folios
without holding folio locks, which is in any case the right thing to do
to reduce folio lock holding times.

Some of this might also be fixable using Jan's work on deferred inode
reclaim [2]. However, that is not stable material, and not allocating
folios while holding other folio locks is an improvement on its own.

Unprivileged users can trigger this deadlock with FUSE and
mbind()/migrate_pages(), however, it requires multiple NUMA nodes and
quite some luck.

I reproduced the original deadlocks with FUSE and made sure they can no
longer be triggered with these fixes. Further, I ran the usual migration
and folio splitting selftests.

[1] https://lore.kernel.org/all/20250925224404.2058035-1-joannelkoong@gmail.com/
[2] https://lore.kernel.org/all/20261009133253.20102-1-jack@suse.cz/

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
David Hildenbrand (Arm) (2):
      mm/huge_memory: use NOFS when allocating while splitting folios
      mm/migrate: allocate destination folios before locking a batch

 mm/huge_memory.c |  10 +++++
 mm/migrate.c     | 134 ++++++++++++++++++++++++++++++++++++++++---------------
 2 files changed, 107 insertions(+), 37 deletions(-)
---
base-commit: eb01811cc3713af1f78dfe18fa89c5270ebfc767
change-id: 20261121-migrate_reclaim_deadlock-44e28e226b9d

Best regards,
--  
David Hildenbrand (Arm) <david@kernel.org>


