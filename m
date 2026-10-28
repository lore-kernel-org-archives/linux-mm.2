Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C53A606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ELizeEpW
Received: by kanga.kvack.org (Postfix)
	id 2EEDB6B05BC; Wed, 28 Oct 2026 05:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6306B05BD; Wed, 28 Oct 2026 05:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 203EC6B05BE; Wed, 28 Oct 2026 05:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA9676B05BC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:55:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DEA421C462E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:55:26 +0000 (UTC)
X-FDA: 85371577452.16.8B3BA15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1E3761C0007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:55:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ELizeEpW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pqX9rfgmqaJsxylyr7PekQEwW67TR8Idof8IkM9MJmE=;
	b=YWRRJ25PLrPZUA21C0lccnsCB2u8l93xFxPHAoECS7FCuIlRv6NQX+XHwuf2Of2wE55JTx
	dqmDcSv/b8GhwaMWviTJtnyaYPJvESlgIV8Mi33iTI6B3tRAwFSporGwdhEPSKsy+aYSzD
	euN7Y2T7kYajQBVttFyydTUq+F/ZxaA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ELizeEpW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181325;
	b=onkUn7BJykZWs3kD2638EKYdZX2IeP/72N4rqrvtTdzUe3CdHcE6hDb1aiOMXg9vmfKZSK
	H7fyFQ54Y8bIK4P3YPs3fvq9WEuSACvqW2DY6D+MKDO93FN5tw3hc2HhvQbZECb+9Kq5rZ
	fLD+yPwMt58XYRM1S8R9v0imsndCBfI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CCAE43954;
	Wed, 28 Oct 2026 09:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3161F01825;
	Wed, 28 Oct 2026 09:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793181324;
	bh=pqX9rfgmqaJsxylyr7PekQEwW67TR8Idof8IkM9MJmE=;
	h=From:Subject:Date:To:Cc;
	b=ELizeEpW0IWW9ALHMAwUdjXES+qCVnseTomqDmrxUdJsA2qI1fN9VpHRkPMHHB/z1
	 e98N/XcweBbYdDxieObG0MX16FEbZspUHisMJzORsFG2RKQx8fFFQkPbYAFWDzM2ri
	 5EU7adjS3axw5M15cusfxHELyH9A9jDW3BFaWZZf0Cvzc9OtiEgSXpBwT6DKoZwOMK
	 YDcs/ClOj2ocpKlASP4GDCXMcRwgGFy8qvPcLXO05pWqmHr72dzqMzxog5X5ziXbmN
	 fXncLL7O89PPHuccmSvDF6IutEG1BMlNtzJv5mzszHS/JLBJtjeodcuI20GPcZ7Nzx
	 Xmo41NQzcaIpw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH v3 00/15] mm/shmem: various (urgent?) fixes
Date: Wed, 28 Oct 2026 10:54:58 +0100
Message-Id: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHPG4WoC/1WNQQ6CMBBFr0K6tmY6hBZceQ9jTCkDVAVMi0RDu
 LstxkSWL/Pfm5l5cpY8OyQzczRZb4c+QLpLmGl13xC3VWCGgFIAZry2L/IX33bUcVQ5KlGUIgV
 iwXg4Ws9BOJ2/7J/llcwYE3HRWj8O7r2+m0Tc/cpyU54EB64gRZBVVmswxxu5nu77wTUspif8l
 9VWxiDnUgMUGWpTFht5WZYPf46i+fYAAAA=
X-Change-ID: 20261025-fixes_shmem-2782719b130e
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 Pedro Falcato <pfalcato@suse.de>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, 
 "Pratyush Yadav (Google)" <pratyush@kernel.org>, 
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2356; i=david@kernel.org;
 h=from:subject:message-id; bh=QKWfbKNTmEUQgDJxMmiHWqIlTxwF0L7tqAj1iugtr3c=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeHitX5vxxjbn98MT4SZ/U/rgYd3Umz5A7kLnmyso17
 xgWrteb31HKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBE/JUZ/qnMkuP4+etE9Zmk
 7pnM3M3aZ5e8l9T+s+TKId42p+g9tU8ZGbYo8d9KvOM4j5O3YcHWxX9//o+6L1PxQ1DSxOHSPR4
 BWz4A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1E3761C0007
X-Stat-Signature: wdrybdzkbxc1zfcq7b6b9ydbmoqmh3xq
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793181324-686696
X-HE-Meta: U2FsdGVkX190TpsUspOcXR/q/TBeVIHxinfBkPr6uZ6DT4IzmF3U3ULnqP5t5GTnsqjYoaSZfgDKPjXFa8Tmr8ScQATZw1LhDD9AHYQBwdW9zVd9PX/E8CTPPPR3clAyOAxtI8owJRoTCaU8ieX7vKK5jU3Wm+wzk8hDDbnWz1SRHsy53Pe/IIq1bb/f87QKbpApgRaYBnzcbkIftw09PKe2YkSvAF272D76BvbjUdRuTsakVT61d/ehDwFDCy/IMernCMnyKz1oh5vt21falaquzdIQx2ldntUAl5U8i6RgfMF0KNpSztuVne2urJlYOjsnMWKSCl2JkWRQg/iYj9/yFcZDNHsVI0vqh2KPwpGVOOK4BuDR5dsSiBpwUBRFgg9OweJUp0BgQHHehoGX7GQL60v16Ju4y5N6oD3KRuAcDCvlMDH5sknsda/acQNUeNFl5nmagbn3GOYF7b0YJI05/tvaa7QeDPa+MG6xNjQmS1lzY1Hc/KF5KYkRm/yvsVPiPlRV+HB1XmlZcoB3UM5mtRGjCIfjvxmVv08G6wMXXD90XaXytB7N63mEuUKDf5JLSf60456o3COnn1ZSlRx9U8uCxlI80V/HYmBQ8IGLpSq4Tr5pZILMMv2o3c2zkJ1ux28PqqiNos5BUa36zbUE+sMmadj3I0Ep5q+gceKDbG8x/dMhkAXz8mfWwrToTBi69BlQKbU6Wvk5Eg791lFX7y7/Q0nEjRwzX851AlvWsZeTS+CjYvSO9f+IPdZ0byVlcJFYZq3W1cbmnqotHiz/51t0CyD01hO9fu3bSiofr02rddBpPfC+Cn5RhnXmu/j2fimUxmjuKQkYE0l3csslFo+OFGz2tu+O7JFM25eMa3xQLTIMP3YL6ITSB9Z9r+0aLv+qQL6LeWnuLt1Z95zVbh5X7sQ7aVQFibH/4RZ3xhSFkwjWUIPUAre4docpSiOUfV6O9rrJcUhdSVb
 MMJMsqHh
 uGli6CqiNcm2JBlmIx1EmbdliD+9xIYWZVevIJFFxBOIMS8AHG89ZQwflI58aVIwPXToNtQMGeHNAHGx1pdskVQitoa8low45zv2uvnkiF4PxV32aRdphSqlmmtgt12jnPIBoc25n6KCWMvvqvS/vumwnEvLlcwOsrDmJ3GRye7Lkd05QluBEr4ea6hsAm1eq3vlTx3j4XZiu00/sx0CHH06SR3xh8g+uqCaWFQH5tlFXprIAPPajIBcAgiAROkT37fD4Vy+/Uxwr7YBR0YI7E7qZr7GJTFItJA8NRKSGQ4MmG4ZZ/GTT5v/WJO7spzeUYGBZ4Jb/BebroNvHqhKT0Boe8edtd1yIxtBMVibhWWrd8tA601obrdq03gLcjYwtfR/q5XYUMiHK8MKGylctx7NyV5aeE63hLyBrZL902C9z0pfwb8QYOSqz9GrXeI1vRGLz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

see v1 for details. TL;DR various fixes.

Rebased on top of latest mm-stable. The dropped fix is now included
again :)

Thanks everyone for the fast review and tests!

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Changes in v3:
- Rebased on mm-stable
 - Fixup for shmem_set_acl() no longer required
- Re-include the commit I dropped by accident
- Apply tags
- Link to v2: https://patch.msgid.link/20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org

Changes in v2:
- Rebased on mm-stable
 - Fixup shmem_set_acl() compilation issue after rebase
 - Dropped: "mm/shmem: avoid moving the truncation start backwards"
 - Fixed up: "mm/shmem: stop retrying folios that cannot be split"
- In "hugetlbfs: enforce F_SEAL_EXEC in setattr", check for S_ISREG
- Smaller patch description fixups
- Picked up tags
- Link to v1: https://patch.msgid.link/20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org

---

Chris Mason (4):
      mm/mempolicy: charge shared policy nodes
      mm/shmem: honour F_SEAL_EXEC when an ACL is set
      mm/shmem: stop retrying folios that cannot be split
      mm/shmem: preserve data in clean folios when splitting fails

David Hildenbrand (Arm) (7):
      mm/shmem: discard whole new large folios on fallocate rollback
      mm/shmem: rescan after nonuniform folio splitting
      mm/shmem: fix truncate hang in large swap entry
      mm/shmem: preserve allocation errors when swapping in large entries
      mm/shmem: fix truncate loop after boundary swapin failure
      mm/shmem: fix accounting of swapin-error markers
      mm/shmem: fix truncation of files containing only swapin-error markers

Eva Kurchatova (1):
      hugetlbfs: enforce F_SEAL_EXEC in setattr

Josef Bacik (3):
      tmpfs: keep the quota soft limits of an unused id
      tmpfs: preserve explicitly disabled quota limits
      mm/shmem: hold off eviction in shmem_writeout()

 fs/hugetlbfs/inode.c  |   8 +++
 include/linux/memfd.h |   9 +++
 mm/mempolicy.c        |   4 +-
 mm/shmem.c            | 168 ++++++++++++++++++++++++++++++++++----------------
 mm/shmem_quota.c      |  28 +++++----
 5 files changed, 149 insertions(+), 68 deletions(-)

---

base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d

change-id: 20261025-fixes_shmem-2782719b130e

--

Cheers,

David


