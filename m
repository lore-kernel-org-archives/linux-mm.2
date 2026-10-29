Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FE78606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h6M7nzpp
Received: by kanga.kvack.org (Postfix)
	id B870E6B05B6; Thu, 29 Oct 2026 06:43:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5EB46B05B7; Thu, 29 Oct 2026 06:43:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74AF6B05B8; Thu, 29 Oct 2026 06:43:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 800326B05B6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:43:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E81F680342
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:43:49 +0000 (UTC)
X-FDA: 85375328178.24.89CC3A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 38F241A000D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:43:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h6M7nzpp;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270628;
	b=b6lesMUuu2AK8O9PkP3t5TLqlkUWuCIhWe5sEk8/ZDWSgAe4/2y2IkcTEpTnQHwaCRY+LL
	NnAfxrd7AWUjF1yMy14Cu5Tz1WeGsMIqzpqZRXOi5KTVbhlSnuZcIeEGr0ejmsN+yROIaG
	0lTsZAiBBGt5mEd1HsUy8l639aC7hp4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h6M7nzpp;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=v7bl5mathvEsQc0NewEfiW9buRzfycGDuVIoRi3XbeE=;
	b=FhFRdfCOd+J8MADMpD9AjPDwODEIrEMQuycFcHlWES5tDtege4xQBX1YerEksI+Hk+t058
	fhkG08M0guaK0vyM/S4F5rnUaDo7oWXDFpirnoFKhTvpNcppxs5GfMpf+6gybQ9wZhbVGg
	pua0LZkAivLt9b+6swDP2W5ByDPiw/I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CCB7600D1;
	Thu, 29 Oct 2026 10:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFD41F01825;
	Thu, 29 Oct 2026 10:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270627;
	bh=v7bl5mathvEsQc0NewEfiW9buRzfycGDuVIoRi3XbeE=;
	h=From:Subject:Date:To:Cc;
	b=h6M7nzppxu1MNzAHPW3TFoBhyXbSLLzhmYpxIyCkGQKBFJp/jQiCQVj6ypCqs2jUf
	 do9Uqc9YlgVQ6ZinxNyg+cRiQAk/D/tbkyY1hYWnQkutwOIaM2Ox6terGh28H0/lbT
	 h8cqIeuqP5iCMfPYOD+q6wMzbo4FEGewrVGHsEZNoGl4SYrTmOIFvQeKhczP2vaaJ4
	 DUevwX44epbNvvIl9Pc9YFfHaHzrj2MJWgfPQcW15LGQlyx/Ubsi9scnM5oMfKe4RR
	 JhPc9ioRgpvSa2YVBOQoQgWeM5PsBmwqL5jjyCaZgxjZGLY+8CUs7MyrnY4jacM2Ik
	 r3qFz5ix7MkyQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH v4 00/15] mm/shmem: various (urgent?) fixes
Date: Thu, 29 Oct 2026 11:43:21 +0100
Message-Id: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEoj42oC/2XNTQ6CMBAF4KuQrq2ZTvl15T2MMW0ZoCpgWiUaw
 90tGBOIy5d535s38+QsebaL3szRYL3tuxDiTcRMo7qauC1DZgiYCsCEV/ZJ/uSbllqOWY6ZKLS
 QQCyIm6P5HMDh+M3+oc9k7tPE1Gisv/fuNb8bxNT7Laer5UFw4BlIhLRMKgVmfyHX0XXbu5pN0
 wMucbbGGHCeKoAiQWV08YflEudrLAOODUmtKix1rFd4HMcPnTe3mDMBAAA=
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
 Balbir Singh <balbirs@nvidia.com>, Josef Bacik <josef@toxicpanda.com>, 
 "Pratyush Yadav (Google)" <pratyush@kernel.org>, 
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3095; i=david@kernel.org;
 h=from:subject:message-id; bh=GpKtRlaQ06LBkExuSjLz4XHKAw3/ZQRf15rGlWX8NMs=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeK/uv2d2YXLnL7kzy5YiS1ytZdVzuujJ0zZe5Xxib5
 2cgeVOso5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIm0bWZk6PDafmXB4leuGoeW
 xm4QbkmL151XfTx0so7M1qoZaauDnjP8z5kx5avo28t29nG7uFK219W7KSS+n9V/3+FmW8Vk629
 SHAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 38F241A000D
X-Stat-Signature: khjy8nox97169stb73iddagkqzc8nc49
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793270628-744006
X-HE-Meta: U2FsdGVkX1+AOu2ahqo7ah74ZLjqcRzlsWDcBNorcF2LUb/XWBEX091uXlSMnR5ghbBqf9f5RMngO6SUXUQK23mCp8MXtA6EV7/7agHgX8bLbi7MYeKauY37cN3rLi0aFl+RvIDEor7mq8dqtoBa9R/u74nEbiTTg+ykyKBnUQHMXPR465A8fIbbOeb1n0p+WpoQwpaqs3dHqwlCcmLn1ax5MbXHm7hzs/f+kiZt9NGY1EODwwG5uW89hnP1A47TKKxVQodcvhfBWOlPmHGqNFNQWH/w5/fIcaJxP5pS6RKJZ5Ui8RHzuV/anrsxU6m4HSeAnGTOvnCFTcYRRlw9CBaUIHtwFVvz3YJDEBy0CUIK6zpbI+VYDwHvgOsKxWUPyS+wreoNMTb/KJB5EmK8dJPw7lOWMuwAsLYlOQYQ/frsNxA9U/CocGHItk1CfUeQvl8SY75UZnteqjGhwlJMPWxa47mvq+KNwK/QX5hZ9Ffk9YVMMZENIv04cApysmIUUOfbjgHk8UCllIg+becj764fJ65FEDTF0b3unwmWo0UK2w6LCdqeDgcU3DiQiiH2J78uhR+iQc8TLbvY+OALRWXnOLtkwAkGQIayxfEeoF2SrGF7MWBEOV3CfxFQobvtyRbPlgSO/Ij9P9NhT63ma6kPgHDwJ1kJXdZA0rZczFIR7KcIcZXR7L0vNO+CmafYvP6CRrZAGpOXTmEK8k21K0FYMIjUH3rwHg+eHD3C2wVJg4A55wl8zBMmbsTEGVavTUItVtndAvp+wLtT+MRfyuax3dM+0W4xHDqEk4uoQwwjm9/Q3lQblHvJWFh7RQhhl/SEFHPelPQgOZkoewuzLzW4ZDbzQ7xobntErwf4xM1dbsYgVIHe52LJ36AC+wxXEJsZTboulsOtyhlPEIfCVXhSip+/E2IBr+aVHaXjOEzIj/B6htiY0gsLdJU94p9eLK27PbSdyJX0AJc/Isv
 4ThZnklZ
 4Hqoe0c2qe5xyWCTEaaLJz9JGuk8xavtNgA9MiLB95ah37wxPcp3tgyTwOtzS5RPaMFMlsAGISkDsg/0YKvRKGMWIULCcV2LZp8xkdC8Judu5YJi2LEtflP64apJtQKPHqG0LzMWdkrrKcgXyQzvDZ772VhSJYO/j8FVrKr/bNfy7SvfBURi5ffgxuygOCAtT77VgK05Rq2daigvVFaSvmNJOMU9boKBiJfki6+WnNUkShQJI47dsa2YM3nxvknBgxYSzDVbj7Pc65I/yxUyL3OoHpP68bpfqKW7B1+I6121npzjq4dubjj0nRwRpOW4ZbeCon/ni4amlE8IMu5VxTOKNXapMJ/7DrwvJS9usv9kglY33wIppCxtL9lG+PIGJBlnoglRn4vIT4GhfJVtBEqvs+M1p6ozWHK7OjcWs3kArJPL4RLuJZoLD1qtTNHHfVPbq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Thanks everyone for the fast review and tests!

I'm planning on picking these myself and routing them through mm-core.

This is a handful of fixes for shmem/tmpfs. I sneaked in a related
hugetlb fix that stalled upstream.

Some of the stuff is more urgent (patch #1, F_SEAL_EXEC, truncation
hangs), others are less urgent but still rather unpleasant.

The majority are fixes from Anthropic that I cleaned up or reworked.
While doing that, I found a bunch of other issues and tried to fix them
somewhat cleanly.

Mote details, including other issues not fixed by this series can be
found in the cover letter of v1.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Changes in v4:
- "mm/shmem: honour F_SEAL_EXEC when an ACL is set"
 - #define shmem_set_acl simple_set_acl
- Document remaining race in "mm/shmem: hold off eviction in shmem_writeout()"
- Link to v3: https://patch.msgid.link/20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org

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


