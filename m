Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7291DC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 738056B00AA; Mon, 20 Jul 2026 10:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70F4F6B00AB; Mon, 20 Jul 2026 10:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6251F6B00AC; Mon, 20 Jul 2026 10:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2538A6B00AA
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:39:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C6691601E0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:39:00 +0000 (UTC)
X-FDA: 85009412040.29.C5A6036
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C3F351C000A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:38:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ay+iy/wP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784558338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5EtQKsaIFF4zrg7SxJ6yEzRaKzfboagi3OY19494b3M=;
	b=aHXY0SZ3IXkpZUlHCqJ6zFic/IloafAWTBbFrVOuJKggNWwa5Jf3FJx6+9PCYlEVC44F3z
	tOES36tGIfBCEMTintAi2zXMaBtZzRlY0LZU2zSUV0g8yinkFFH8LrBw7gMEFDq7uS+cGa
	6O1QTHIOPSmF6nCnRNzAXJe38QM0Rlk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ay+iy/wP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784558338;
	b=0cAdXMbpOWyzx/XN/5CwPMb07Lmf4xcH7ShI/HuZAGOvs7b7rWaVvxB/RKpS03YXYR0UCh
	0J/20+e1wd3FRNEZNNZpg2XxJmbao+d793/qZhsr2rXmCjjGgUsCVNltn6hWdmHliEA3y+
	hkxeXsawSU9sW1pqg8W9iU+bTK4mBj0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 019384114D;
	Mon, 20 Jul 2026 14:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF61B1F00A3D;
	Mon, 20 Jul 2026 14:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784558337;
	bh=5EtQKsaIFF4zrg7SxJ6yEzRaKzfboagi3OY19494b3M=;
	h=From:Subject:Date:To:Cc;
	b=ay+iy/wPWIXP2MHJiPUUdz+Q6EqIbI/faogVz0rqA/aYuUxw3l6P0E54iGo7inABK
	 KJdJLpYWaK7SVULgJSTlIbWVqUAXB8+zgabr5SjKJKT6vQiWyf2Gur6QaTUXay2xlG
	 nfcwI9sGc44p70CIpst+4HRx7JWD30QoljtEFz8AsaG4tEEnwxiYfszOHj68Nkd+fU
	 zMBH8PscxiFIw9JGDV90FX17RRW4SKyruUP1pGQk+NXKFq3hBa8j383ZKmSWWUvXLB
	 3tAu/of/mV4iIu1iQU+ST7UPGnsthosHQ1KSjtcqldZghtZztNQ296obNN5f8NoR7A
	 cgcb/yuTLDh3Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v2 00/15] mm/rmap: index MAP_PRIVATE file-backed folios by
 virt pgoff
Date: Mon, 20 Jul 2026 15:38:26 +0100
Message-Id: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOMyXmoC/32OQQ6CMBREr0K69pO2FlBX3sOwoN9fKBJKWqwaw
 t0FdOHK5Utm3szEAnlLgZ2SiXmKNljXLyB3CcOm6msCe12YSS5zXggBWkHAqqt0R4DuAdH6EYb
 aGQMVR+SkhdKYs0UweDL2uckv5YfDXbeE42pcE40No/OvbT2KNcfQRfKpKA6yUJnI9mltx7Rrw
 /lGvqcudb5em98/xb8/UQAHNFIdBSfDj+rXUc7z/AbvlBHc/gAAAA==
X-Change-ID: 20260711-b4-scalable-cow-virt-pgoff-a0cc0eb14bc6
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=10834; i=ljs@kernel.org;
 h=from:subject:message-id; bh=onSNPyAB7DTgM/GC/XlfM5KdJUT5zoq4XsSv0WjT0yc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLijF589wqd8oXhxJMN2XXzGV8mXzUzXbH0bpX06hv8q
 WpPXkuZdJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiG/cx/C+yvMR0WZcpfPmd
 Z6cYD61SXSaaG/eRya6E28CRc03KmscM//S7jXJjalO28P7j4Q/Lubl7gXBRkfUS7WgZl4Tgu31
 3eAE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C3F351C000A
X-Rspam-User: 
X-Stat-Signature: mtiss7xq56u99quzpuwhiab5dj6cqdfj
X-HE-Tag: 1784558338-410369
X-HE-Meta: U2FsdGVkX18pxFQBFGxfGKr5elJhqGhc/6nUZW9U3RQaB6S3ftpCSWbiB2kAh6kfdbHCcG+3hQo3ZswZLAffRoSoZT+tsIWxl1EmwTZexSMzc5TfmWedyC4wLeUh1PcjkQ8CzLOU9SMmwVh5apEQEYrD+LFOI5Dm4bMQyoFoYBMM6DfRpKnGfTn5cV6f3wMlSlV8JHuTJL3rY00f8bJj/Ocaeo8c711r8Xu0xZidtyOBgKAyW4C/eAFpXnLHoD/QgM7mOuHIYBFgjP9OxL+mn0CHoZiSqHE7xqDZA3LGshQS4Gq8S1ECn2GZ9hAeGIRU/OLagf6M1YhMjUMIByDgfitcRqcNPd7WY6NnuLjDDS+Q7P2VuwzoGmP9R6x9JIF0Zm4P3RfZmYV6PpmQvUgXn8d/QBnSIewCkso9RmP8A8hxJ01axAu1NuAF/l964IekEtNpJV0JLCOsRGrz8CYn+SaspBevGInRTQfesN+zKFyqr8DNY/b5U0GhPaQSx7DQf8Yj4UHhj3JnAg/HZ1K+SicjZsleDRhqZCDaX9Pso5L3qT5NCqeqe/VKHr7OtNH8pAnNzOvzzcj1U39Ez9DWnUlTaZNG34+VxzwJ05FiLPUGFwSJ5bmKvmXlxQUDyzDChB/CcMy5g77+APa+HEZj3rIrIEcPknLJxazy4JtHIQRYY+nwl3SyGaOuA79qdUIp1G/JTMKQ8g+dGqyyh5fG3K1kWFAvpxuUbygzLFV4BmbIQoWX+KV/sRuAZRNqYAqQAtA/ZgGadju3nQOvglicJYpFG+iDo8WxixUjFCZG+nXmG0cvoyoMLGHa6NPO3eaK4/pYB20CfxKYDqvnMHvBwB5fAlRpk3or34UsI6F3q5GN+F/lpOlQaRz9HKIbfEnC+7BDq770D1L3x+RNf25VdOr5a6FaWfwQReNcZkIQKmTLCLKaxfQh7D6UlAy8ECwbpi7IfBS4GJ2BXIUPfnp
 jk1wMQaH
 JizeNxzeBUP8ZvhP83P92K+q2TG3BWSRIbekgg3TDa+LHYJJ7kvrW9eXfN0MB45Nj7MnUJnuTRBa6UPjr7ZB7dT4zhdCWZyZTQdo+wE18KZ+ZkIkdMZV7zwkLvBmg08wlKt8wOCasRH6ZHGY0VAzJFy7V4XKMhYbEusmnkMc2rDCVLE/ftctpoS/qQSbKEA7NaCj1ENc1Fv4VkKwq9ePOJ/Ht8iff06+sC7lXeq8Uih2VQhY1lt5tErUfxlsLFsL9u6ActVV99zG4LthnmhTs0cX6Pkr2lrtHsBzyGq4KHVTu1UMgWvLiDk3sAjrSFSBoNWZA1Qs4hgm1uzcqbKtH/3umc/Gbk1dWhsPbLF08QBqkBF72B5rBRFrgNZC2h3gkQJYGrj3yO4P9ysRMRsMRG0stAoHNwMaSwg6yorcaorT7ff9p6WgEWl4C8GOQluDI2RJhD2PezDFQXmrOIh3AAiw3bHOCJ4hgHKY7Rl5K0HouKv3D6iFuoyZ98rZHqClgkvEDWgftHxIDyFZmgzQobbcbwSeR6EzBUi1Qe1ZE9eUhdg8rVBxaeWuJHNPinl+KSqH1O96He9hgXNglqizuRl1Q8BJJTCa3ZhD+LrmA3Wkr2WLF/4pmangXEr2mvVqI2qA3u9ajxcM+mxss+RucAJI+QWPlSLvkiBPjcDBrMQN/tF8w1REvtd5EYS7Ot8Y0kn6LdYRivScoWsY6D5QzM9RMWK6FmcSnoFxb9CAgCdpLYjLKO5/gdup6wg29w/soRvb6s90YFl6/MT+cUxHkOBRSQ/SnfkoTieoNpLcGoczGfAOa5J9qSSLhSMO6fh0Mf7Elop9uMiorCQKuiLi4vjdYPD0tiL9Yh2jwlVwAg9OkTJEuS2AEdNgKChte2RxMSMO85DBhQSUOk0mshxAN7JMZlbGpR8e5xtkzlp9DI2EqTXuL13djs933rR29oY+d3lDcwlTthtKH0eMG8GeQSFOfDE1N
 S84RRGF7
 kNItfv6uwBTUs+++2wjSRRVkdXxKTzoKX0G+te84ltnNVowPqn150eHQ6Bv0WHuym2yXA/kumbVsaC1mQpHKgT/9uDEdmNt9vFFAvcgvegE9ITt/IhWzfrTg4cvYvlA2Ecp5nGHplma3iOsjGB0xVwnVpFbR8RGpj2R3j5eP4S6jbMinUssGGm2KfgDWHKN2YnCadZ0il1n5TBO9CggmWxHp2uINi7WGfNe3zMNly4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In memory management we've managed to manufacture a great deal of confusion
around the concept of anonymous memory. We have:

1. 'Pure anon' memory - anonymous VMAs whose folios are anonymous and
   swap-backed (thus for reclaim purposes, treated as anonymous). These are
   simple enough.

2. shmem - file-backed VMAs, file-backed folios (from rmap perspective) so
   present in the page cache and mapped by an address_space object, but
   whose folios are also swap-backed (thus treated as anonymous for reclaim
   purposes).

3. MAP_PRIVATE-mapped /dev/zero - a strange beast whose VMAs have
   vma->vm_file set, but whose mmap_prepare callback clears vma->vm_ops to
   satisfy vma_is_anonymous(), which results in VMAs that were mmap()'d
   referencing a file, but are in every other sense anonymous, including the
   folios.

4. Other MAP_PRIVATE-file backed mappings - These possess file-backed VMAs
   and have file-backed folios until CoW'd, at which point those CoW'd
   folios are anonymous.

This series fixes issues 3 and 4.

In order for us to traverse VMAs using the reverse mapping, we require two
fields - folio->mapping and folio->index. The first tells the rmap code
where to look for VMAs, and the second tells it at which offset the folio
starts within the referenced object.

For anonymous folios, folio->mapping points at an anon_vma object. For
file-backed folios, it points at an address_space. And:

* For file-backed folios folio->index is simply the page offset of the start
  of the folio within the file.

* For anonymous folios belonging to pure anon mappings, folio->index is
  equal to the virtual page offset of the folio.

* For anonymous folios belonging to file-backed mappings (i.e. CoW'd folios
  of a MAP_PRIVATE file-backed mapping), folio->index is equal to the file
  page offset.

This series establishes a new virtual page offset property of VMAs to
allow us to map anonymous folios at their virtual page offset, consistent
with pure anon.

The purpose of doing so is to lay the foundations for the scalable CoW
work. This is necessary because scalable CoW looks in the maple tree for
the VMA located at folio->index << PAGE_SHIFT, before falling back to
looking up tracked remaps if necessary.

The MAP_PRIVATE file-backed case means that folio indices will very often
conflict with one another and this remap tracking becomes substantially
more contended, and of course the fast path can never be used.

This also makes it possible, in future, to unshare anonymously mapped
folios with deep fork hierarchies on remap, eliminating the need for remap
tracking in the vast majority of cases.

Similar to page offset of pure anonymous VMAs, we update the virtual page
offset of unfaulted file-backed VMAs on remap, but do not once
CoW'd (i.e. vma->anon_vma is non-NULL).

Overall, there is little impact on mergeability - for shared file-backed
mappings, we treat the anonymous page offset as equal to the file-backed
one (via vma_start_anon_pgoff()), so merge behaviour remains the same
there.

The only impact is on MAP_PRIVATE-mapped file-backed mappings, which must
now match on virtual page offset as well as file page offset to be merged.

To fail to merge like this would require CoW'ing the mapping, then finding
another VMA with identical file and compatible page offset to remap next
to. This is therefore very much an edge case that should have very little
impact (and which scalable CoW may very well address in any case).

We also address the outlier case of MAP_PRIVATE-/dev/zero mappings which
have file page offset but satisfy vma_is_anonymous() by making them truly
anonymous.

This is low-risk as for anything meaningful these mappings behave
anonymously, but it is very beneficial to do so as we eliminate an odd
corner case, and those are notorious for attracting subtle bugs.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v2:
- Removed incorrect assert on always-NULL folio from 7/15, as per syzbot.
- Updated 2/15 so linear_virt_page_index() checks for vma_is_anonymous() as
  well to be cautious about 'special' (VDSO, VVAR, etc.) VMAs accidentally
  being asserted when CONFIG_DEBUG_VM is set, as per Sashiko.
- Updated commit message of 9/15 to mention the subtle change in NUMA
  interleaving behaviour, as per Sashiko.
- Updated 10/15 to assert virtual page offset for adjacent VMAs for various
  VMA userland tests, as per Sashiko.
- Updated 13/15 to remove the !vma->vm_file check altogether after
  MAP_PRIVATE-/dev/zero is made pure anon in vma_start_virt_pgoff().
- Updated 12/15 to check that the /dev/zero device is a character device
  since it turns out that block and character devices have their own
  separate major/minor device number namespaces... :) as per Sashiko.
- Updated 12/15 to fix a bisection hazard where vma->vm_ops would be
  overwritten by vma_dummy_vm_ops for MAP_PRIVATE-/dev/zero, as per
  Sashiko.
- Updated 12/15 to fix another bisection hazard (...!) due to
  ordering of vma_set_anonymous(). Removed in 13/15.
- Added comments to __vm_virt_pgoff[lo, hi] fields referencing
  vma_start_virt_pgoff()'s comment to be clearer what these are as per
  Xu Xin in 1/15.
- Various typo fixes + cleanups in prose.
- Updated the cover letter to point out that the MAP_PRIVATE-/dev/zero
  issue is addressed in this series too.

v1:
- Rebased onto mm-new.
- Dependent series heavily reviewed and looks highly likely to land, so
  un-RFC.
- Added explicit check for /dev/zero and removed ability for arbitrary
  mmap/mmap_prepare hooks to make themselves anonymous.
- Made MAP_PRIVATE-/dev/zero mappings truly anonymous.
- Added MAP_PRIVATE file-backed mapping merge test to selftests.
- Added a MAP_PRIVATE-/dev/zero VMA userland test to assert that the VMA
  really is made anonymous.
- Added MAP_PRIVATE-/dev/zero merge tests to selftests.
- Fixed missed virtual page index site in try_to_merge_with_ksm_page().
- Updated folio_within_range() to use virtual page offset for anon
  folio. This had no impact as it is only called for large folios at the
  moment (and MAP_PRIVATE-file backed mappings can't currently be backed by
  a large folio) but making the change now protects us for the future.
- Fixed typos etc.
https://patch.msgid.link/20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org

RFC:
https://patch.msgid.link/cover.1782745153.git.ljs@kernel.org

To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Jann Horn <jannh@google.com>
To: Pedro Falcato <pfalcato@suse.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
To: Miaohe Lin <linmiaohe@huawei.com>
To: Naoya Horiguchi <nao.horiguchi@gmail.com>
To: Rik van Riel <riel@surriel.com>
To: Harry Yoo <harry@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
To: Kees Cook <kees@kernel.org>
To: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
To: Nico Pache <npache@redhat.com>
To: Ryan Roberts <ryan.roberts@arm.com>
To: Dev Jain <dev.jain@arm.com>
To: Barry Song <baohua@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
To: Matthew Brost <matthew.brost@intel.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Rakie Kim <rakie.kim@sk.com>
To: Byungchul Park <byungchul@sk.com>
To: Gregory Price <gourry@gourry.net>
To: Ying Huang <ying.huang@linux.alibaba.com>
To: Alistair Popple <apopple@nvidia.com>
To: Peter Xu <peterx@redhat.com>
To: Xu Xin <xu.xin16@zte.com.cn>
To: Chengming Zhou <chengming.zhou@linux.dev>
To: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ljs@kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org

---
Lorenzo Stoakes (ARM) (15):
      mm/vma: introduce VMA virtual page offset field and add helpers
      mm: introduce linear_virt_page_index()
      mm: abstract vma_address() and introduce vma_anon_address()
      mm: update print_bad_page_map() to show virtual page index
      mm: introduce and use vma_filebacked_address()
      mm: propagate VMA virtual page offset on map, remap, split + merge
      mm/rmap: track whether the page VMA mapped walk is anonymous
      mm: introduce and use linear_folio_page_index()
      mm/rmap: use virt pgoff for MAP_PRIVATE file-backed anon folios
      tools/testing/vma: expand VMA merge tests to assert virt pgoff
      tools/testing/selftests/mm: test virtual page offset merge behaviour
      mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
      mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous
      tools/testing/vma: add test to assert MAP_PRIVATE-/dev/zero is anon
      tools/testing/selftests/mm: add MAP_PRIVATE-/dev/zero merge tests

 drivers/char/mem.c                 |   8 +-
 include/linux/mm.h                 |  74 ++++++++++++++---
 include/linux/mm_types.h           |  12 +++
 include/linux/pagemap.h            |  66 +++++++++++++++
 include/linux/rmap.h               |   2 +
 mm/huge_memory.c                   |   3 +-
 mm/internal.h                      |  76 ++++++++++++-----
 mm/interval_tree.c                 |   4 +-
 mm/ksm.c                           |   7 +-
 mm/memory-failure.c                |   4 +-
 mm/memory.c                        |   8 +-
 mm/migrate.c                       |   6 +-
 mm/mremap.c                        |   6 +-
 mm/page_vma_mapped.c               |   6 +-
 mm/rmap.c                          |  22 ++---
 mm/userfaultfd.c                   |   6 +-
 mm/vma.c                           | 119 +++++++++++++++++++++------
 mm/vma.h                           | 144 +++++++++++++++++++++++++--------
 mm/vma_exec.c                      |   2 +-
 mm/vma_init.c                      |   1 +
 mm/vma_internal.h                  |   1 +
 tools/testing/selftests/mm/merge.c | 161 +++++++++++++++++++++++++++++++++++++
 tools/testing/vma/include/dup.h    |  87 +++++++++++++++++++-
 tools/testing/vma/shared.c         |   3 +-
 tools/testing/vma/tests/merge.c    |  34 ++++++--
 tools/testing/vma/tests/mmap.c     |  50 ++++++++++++
 tools/testing/vma/tests/vma.c      |   4 +-
 tools/testing/vma/vma_internal.h   |   1 +
 28 files changed, 791 insertions(+), 126 deletions(-)
---
base-commit: 5093dba1014c1d7f7e247fd118f0fa8f22136046
change-id: 20260711-b4-scalable-cow-virt-pgoff-a0cc0eb14bc6

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


