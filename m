Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B189C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 19:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3F8E6B0092; Thu, 17 Sep 2026 15:48:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17366B0093; Thu, 17 Sep 2026 15:48:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2DD06B0095; Thu, 17 Sep 2026 15:48:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9ADE06B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:48:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2856D1C26CC
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:48:07 +0000 (UTC)
X-FDA: 85224290214.02.7D9A2F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 69618A000A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:48:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nzZ94X10;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789674485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SKCZtymFejY399Tv50swKvjYDiRpa1vybAFKL886URM=;
	b=Bm36Z2sB1fElnQ1zGCY6WurLObAN2w2yHbAYs1zYSLro6aMF9B9BjOyqhMREObKxkRzJ2/
	M473KwwtQO/+Oc8VEOZdcxP6imXEwyyHixaXtpHmOWjSbDS4IJvEPphG2+lzNKcTfaX72S
	Z7fLJkfMU6jpn4NomSHDMNEV0t14hzE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789674485;
	b=TrHlX7FMgQYbw0A1mQ/SKX49POXEuSqn9QuHCBWzU4ry9SJJUWsgVO9lzW2WxwxryzCNqg
	uvS9hMZUGHQK2MWTSnePIBo+zzsbkNKgOEt86UbsBJeE9uA8Zp5gbzLeP2iMr6DZQF555j
	I769qyv1QzzDNjC79rtxbbDNUQ9YvgI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nzZ94X10;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 06F94601EF;
	Thu, 17 Sep 2026 19:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0FB1F000FF;
	Thu, 17 Sep 2026 19:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789674484;
	bh=SKCZtymFejY399Tv50swKvjYDiRpa1vybAFKL886URM=;
	h=From:Subject:Date:To:Cc;
	b=nzZ94X10WN1rmG1Ujm9ASeObZPM1xl2YtZNwu4dtqxYpjEyV1huRr4rAzA3gdDaUQ
	 cTYUQMFCnKCL62poZqeTo3t5fQLOhl/ROHFE15LyMwsdMk8uzkgR6SFQz4CJNiVyXV
	 SMm9DOQxCzo0MOpvkR9rYCKDdlSuzQ/V1tjS0kytUmUmiNTVGhAS7Ruy7lb9Ism3VU
	 2YpX4iwlYAvx9761wKq7oFiItuIo/c55SpXjiJV8QzjdCgu5z/5mN+3woIvh2Pmnqn
	 ZTWHyDQe5DSb3gxNPK60vl0VJpAdz/6v6cC6CS5rd5yPZ7nMkwv8LFbqJrQyupz3lD
	 piIM6f6Q8FR1A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v3 0/3] mm: implement and use vma_has_anon_rmap(), silence
 KCSAN
Date: Thu, 17 Sep 2026 20:47:40 +0100
Message-Id: <20260917-vma-is-faulted-v3-0-5c22314a72e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3XMSw6CMBSF4a2Qjq25ffCoI/dhHBR6gRsVTIuNh
 rB3CyONcXhO8v0zC+gJAztkM/MYKdA4pKF2GWt6O3TIyaXNJMgCDBgeb5ZT4K19XCd0XKED0Ln
 KTQksobvHlp5b8HROu6cwjf619aNY37+pKLjgypYgWl2ZStvjBf2A1/3oO7a2ovzwAn68TB4rg
 XVTOqGL+ssvy/IGiNh6Ee0AAAA=
X-Change-ID: 20260909-vma-is-faulted-3ed004535970
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2919; i=ljs@kernel.org;
 h=from:subject:message-id; bh=rE+GgG5lo7kLvRik8sUqKlJkAvF+DMB1bmJcti/7mbM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWOL+UybscKnJzyYpEK6bdF7pSdSr3NgvM+b01aduhj
 daLdtkEdZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAifvMZGTo3rndbt2lu3xGV
 f7OEHoizi15a4pny3ZNZQ/B7Sn3tvL8M/wzkkyUmGIVHzzc/eHxGj7iBi12NwUx7tnSB6Af3Z85
 MZgYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 4ujgqujobfqizmm8hambkgfb5p8usggq
X-Rspamd-Queue-Id: 69618A000A
X-HE-Tag: 1789674485-888677
X-HE-Meta: U2FsdGVkX1+7JWdD89KAXKGRvuiFH4soq/ZxTucF+Yp9kwoOTVzfXcRXInVNZ0E4ieNEDSvoYXu0SgoFjY/I3armYtv2P8wM27Fbl31v02VbnkTbdolw6hMJUu3PVtrQItUwq4+2CEp/ub9fN+2FP6vgMasFe2vi40t6ghYmau0qB2YpTuKsScMDyjI+avB5Q6aT24VZEsfwkHE4RasjFlWKbjFUYR3ZF9XfLFu/MNlL7/pHrLyeQZwocKMtjoZBEE8uG790/wCY0+4u5e+iMIfglwd2cUzoorcMAudGevkW2E9kVQRlmBOB0/VL+mowvsdRF1v5eD8zB3JkpKBoECAkMwVA8FXycqLP8xSbnLv4VQo1QZlJuz9mAgiPg5brmJvKD9CFIxpKRLIIv2aJtWUwxEkszkONy8RRVJhHvClKKRRYGhxCBulV+9AoScQkx6umc1/f9nQtAwjUE27hSlj/zTuo4StmBzPis2YFWAoccuB9OHRQIYBplCASO9Xs6LueF7Ij5rkxfLYTIICKBqTrBPHpAPT1nQXoJLbNWJJBm/RC/ZK9jRWfca4Kn4L1SZMSzJ7V6g5Wjw1yvvywz5gXW2tvorumc4MEMi3fE0mR/gGMwWH6sTt6xmQh7CZK+Fs6UMWt9LHwPe21dAjiSg9N2gU8TY/6SM5oYTVwSklmgrTynadIdjvUYYJsihmcDLFHzEWoszjt6N5JojU/oSVxtLMT7NzIlTPZE24NSU456E1OwToKjETX9Y+83Q1Z79DAT+SzrMfTQklUupuUDGRKmzNf+i35REWJ4E/BPr094b3njQZlVhrasDJwwSO7iwfngBB7a0Vq0JFttWu1sUmLCVLYEKuZ4VKkNKmgv2Xv84kVDEWfFlNY5chh0LiuzfP/oJROqKtKYpHGTWT+W2t2k+/XwLUgh+c7dBICjXQnJPVVNASvblJtg846xNqeI2+jtixx6XzEeV+KChZ
 WEEXCEvB
 yT6HyKvI8i2y44gUzv7Calq1gq1drTh6TK/8xrKOAjPVEUGaGA+KOfIBr+XXtnlwYCF2Lv53Jz40VBw/3H/j5Krvkavp51qsTVh8rtSBZMSkSfeY4vPVRzEOPhX92U32NX6xCONx8eG6VBqAtdKbozpZAx6CKSQBWYmSvt2QLtqHRLhaZqgdvcU3AwL6ZOFqxA7szqQ0/DZUfU0CkbWM4nsEU0/98RhzRQlT7f68RQZTMtghLSObcYcBbre/GPVnWRwTSTVyVxPzuAu30uqlJcopmlHjrzVFh6e0/tusFnA5S4NoahwSzaOKDpXE7u17MckR+cSZ1lbWY0obgIAPdbotVEyl5SQeZUnNOc5oBjEkFljA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide a function to abstract the common task of checking whether
a VMA has an anonymous reverse mapping associated with it.

In the first patch, const-ify vma_assert_stabilised() and related
functions so that vma_has_anon_rmap() can reference a const vma pointer.

In the second patch, introduce vma_has_anon_rmap().

Finally in the third patch, update comments referencing anon_vma to instead
reference the anon rmap to abstract this conceptually to avoid confusion.

There are still other functions which reference anon_vma directly, those
can be addressed in a follow up.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v3:
- Updated tags (thanks everybody!)
- Separated out const-ification changes as per Kiryl and Pedro.
- Renamed vma_anon_tracked() to vma_has_anon_rmap() as per Kiryl and Pedro.
- Converted the missed hugepage_vma_revalidate() and vma_needs_copy() callers
  as per Kiryl.
- Update the kdoc comment for vma_has_anon_rmap() to highlight that it implies
  anon folios may be associated with the VMA, as per David.
- Updated anon_vma comments as per David.
- Updated the vma_has_anon_rmap() patch commit message to avoid saying
fault as per David.
- Various prose improvements.

v2:
- Renamed vma_is_faulted() to vma_anon_tracked() as per David.
https://lore.kernel.org/r/20260910-vma-is-faulted-v2-1-e81ebc7d146b@kernel.org

v1:
https://lore.kernel.org/r/20260909-vma-is-faulted-v1-1-3a701f48984a@kernel.org

---
Lorenzo Stoakes (ARM) (3):
      mm/vma: const-ify vma_assert_stabilised() and associated functions
      mm: implement and use vma_has_anon_rmap(), silence KCSAN
      mm: update comments to refer to anon rmap rather than anon_vma

 include/linux/mmap_lock.h         |  12 ++--
 mm/huge_memory.c                  |  21 +++----
 mm/hugetlb.c                      |   2 +-
 mm/internal.h                     |   2 +-
 mm/khugepaged.c                   |  17 ++---
 mm/ksm.c                          |  16 ++---
 mm/madvise.c                      |  10 +--
 mm/memory.c                       |  16 ++---
 mm/migrate.c                      |  12 ++--
 mm/mmap.c                         |   6 +-
 mm/mprotect.c                     |   6 +-
 mm/mremap.c                       |  10 +--
 mm/pgtable-generic.c              |   2 +-
 mm/rmap.c                         |  22 +++----
 mm/swapfile.c                     |   2 +-
 mm/userfaultfd.c                  |  12 ++--
 mm/vma.c                          | 127 +++++++++++++++++++-------------------
 mm/vma.h                          |  29 ++++++++-
 tools/testing/vma/include/dup.h   |   2 +-
 tools/testing/vma/include/stubs.h |   4 ++
 20 files changed, 182 insertions(+), 148 deletions(-)
---
base-commit: b02c77c78ff74d3d88ea614335ae833e01ed5d30
change-id: 20260909-vma-is-faulted-3ed004535970

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


