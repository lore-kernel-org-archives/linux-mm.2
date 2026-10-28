Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDCF0606A321
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OC0jqLoF
Received: by kanga.kvack.org (Postfix)
	id DDE376B05B5; Wed, 28 Oct 2026 16:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68126B05B6; Wed, 28 Oct 2026 16:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2FB06B05B7; Wed, 28 Oct 2026 16:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC246B05B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:13:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35951A01B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:13:57 +0000 (UTC)
X-FDA: 85373136114.11.3A629A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7D64514000C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:13:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OC0jqLoF;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zblGlkWs1OXZ9bHPBTP+AfF1wpBrK3sa+fiGbxI6Tmk=;
	b=Es7F0HgKvH6palnnXrUUVhuv4CofnBr+3Q/vPL5J6bCKxSQZ/hYa4zuZoHad+KCR12UJkX
	mG+adkqcrBEXWNoB4r6zaRRfuA/HoUdk0PJLT4NiB+KPiisXyzJnhv/Oph2GUne29Bt/pq
	kutcM56wBdo6KjxRFi4ScEiCcozKdaI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793218435;
	b=LjDJoAS7RNLFc7rHVpLjL6s/MDNs0Spb04pa7xjMP8ZZoGe7rb8PTreRVTJoSSGPup0rm2
	HAqV3/eBCE6amFNAevK0kTM+5QZZYYd2mAdjLwmQS9Ym7W6w0uNezSGufPXZNKFomT3SYL
	Pyxyg7/05HSIvmsRdWC+93TRhWsc7FU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OC0jqLoF;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 13DEA60202;
	Wed, 28 Oct 2026 20:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7580C1F01825;
	Wed, 28 Oct 2026 20:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218433;
	bh=zblGlkWs1OXZ9bHPBTP+AfF1wpBrK3sa+fiGbxI6Tmk=;
	h=From:Subject:Date:To:Cc;
	b=OC0jqLoFLAK/f7Y/IM8DLSn3wtoD+SuKLrY4GE7olSLvMuY17nKMUBtWNwwAWrUuW
	 68eQ1fXTtwD1Mkz56lvNrm8yBb2YjWoFKe5MBwR/5ZdqiSNyl09FfN8The3pXc5f1O
	 UnrwFdXA1g119nmQF6pwyJ/F0h/GnkfkMfLILeXOmj8YK63F4vv5+FWd6IXdkwhwbx
	 mGKfWkYriQmacjifaD6SgllEGlNIvY/rte/RQ7KdgkTHDZ4grM7xPNOaUOQIzL1590
	 mvFx6xd7CIyySiul2eebB73/k3iGQeWUHzP+MdDPt1R/pi4YlYfaquMD+Xp63xCRt6
	 cVyzcMIDORuKw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 00/15] mm/hugetlb: various fixes
Date: Wed, 28 Oct 2026 21:13:28 +0100
Message-Id: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGhX4moC/yXM0QpAQBCF4VfRXNtaQ5RXkcSaZSS0Y6Xk3S0uv
 zr/uUDIMQmU0QWODhZel4AkjsCM7TKQ4j4YUGOeaCyU5ZOkGf1A+9wpNJnVaG2e6gxCszn6BiG
 p6t/iu4nM/p7AfT82vNYJcQAAAA==
X-Change-ID: 20261027-fixes_hugetlb-2c4f02ff6304
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 luojiajun <luojiajun3@huawei.com>, Josef Bacik <josef@toxicpanda.com>, 
 stable@kernel.org, Chris Mason <mason@kernel.org>, 
 Daehyeon Ko <4ncienth@gmail.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3500; i=david@kernel.org;
 h=from:subject:message-id; bh=bNNIIjvmXZOTaOJfPgSy5HmuhJm0C5N8Ej36sP+bpik=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIehRelXeaZ1r1L/+uWb21rYmaZznX7zvzWpDXjLjtL4
 9XHN47d6yhlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAiRtMZGc6cuvFGgkFTpbsr
 2Szz7PXbmyN4WmwFa7g3nPvV1HUzVYyRYa6t9K2elrqoaPbnQkd4l0qxFx099ebfg5s7f3hlz9G
 O5AAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7D64514000C
X-Stat-Signature: sziwbrdyjdpkj18g817tfuggh3bgqdu6
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793218435-357125
X-HE-Meta: U2FsdGVkX18niRQNRM6938Z/NJtubhNPoHDVQwEzKMdQIIOtZM5AnRByXPkWmc/XnDQg8U6EptFfceHdmv5XuKyNQ7Zu92hQ1If7bzEl4BN2vOuStbQ12JisJJz/X0ToLntn/aABQx4rVdBShpLwNV1douwORV5MTx9th3KXxu2UXE6d1ntbL1F83KRWp14x75XAT69l6+qm8JSu84NaAZt6ZOOi3/vb558k9F/gRa1tYi6juBJl8czCSHvFbdM60lle7IP8yizVWvjzqPSWX2pqFHRZJMeMxNVdl14iKVjNR7amhCHYoYwbbEb9qFn0UDfVlFf7kzJ/SzbUeo62V4u/L14eQFt0VpmrT1XRjK/5i3KJYodOOtSYPSqNWNFO12n8jBQSRngm5lso0G6rVZY/Lx9eva8yTiwiB/dPCk9aZ5cUbm4Z24wBgEaXb/X8lKLCKKkg/Q/0XQQu0KcdXjQ0Wbd4w9ohDC+XNhJMugyEMP+f0O+1nWqS3lEjWMY1n/dCOEuec3zEnvxuFnYmsV9XBbq6mRE/w9LOv7ZKkbqSD7xQSVd31FTisqfDBZ3zCJcvT20n6aHo8nqdhb+vKMHEQbhAJ4RP6r9SWXCy/6pejg7q+zm5b3I2Uzg8fbKfGlCSKhlfuYJSUYFqRWcZJEEgf4CfFPthMTzte1HEs8ZFqU73Cz6QLKRT7NeKnPvCDaPL+j3bL86gzMaF3JiDSsLknUcG74utXc0rSvIIt/tbcaX33wvPmf+NZGkgpzFOW1FWSC9mWDZbgCuyvmyNDnBdws2MpCR+hhC9ZUrB/cjBosgGv9RCJJPZt1J+t+tWxAIu7yG1x6RFTyB2qL35DzcLTl3ZZ+FgzfBLFuxbVUV74fwirS9ADU7mQIzks1927IxNri1yKYuwiJfkI9j72Pvl/PIlsfHJDrgW6YG72sMWEaph+CKbAPkI7CVmOmlZkZgAsa5oNzLyVTNDzOR
 SfhVxC8Z
 QaKvdhTTSLyC1VjkF9X1M0eZG7vjyxuRYajO7Ecv+qKUR1jMLXuDkUiOY3wHjiy036V5hxj7b/jJOGXWDKV7s2ktS6qZ65fNj5/oATBUfI3govyxhjxIhESKZUH9kPgvHzHspTo+wZvUhPvQPVMczUj4DC50RAqzXb964Dbvdcj5fZEeVulgGeM3/rgtiG/XMEeLPdG9jcZEQpLCc6BAOvFV4UYrxJi4kMptje7CXWklFNVlZP7891ISqprOxAx2IwYO0mfJR9N7J/e0LWMum//K2QXZ9dWPIgoLZA1a6NDtTq3eZct2QgLyBr09Ie2LoBvG+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

These fixes almost finished me.

Oh. My. God, hugetlb, what have you become.

And I am not talking about good old hugetlb. I am talking about all of the
things we slapped on top of it over the years, including MAP_PRIVATE,
reservation, UFFD, accounting and much more. I mean, I kept complaining
about all that in the past, but I just had an 2 day-long reminder from
hell.

And don't get me started on some of the proposed AI fixes. Dear lord.
There is a reason why I am the author on most of these fixes. And I
try to not swear on the mailing list.

Hey, at least huge PMD sharing was not involved this time, great
success!

Anyhow, nothing here is super urgent IMHO. Just a lot of unpleasant
things and corner cases. Most of the issues reported by Anthropic, some
found by me while poking at things.

Two bigger changes as RFC. One of them documents some remaining
problems, one of both being a hard nut to crack.

I have some more complicated lower priority, hard to solve things
leftover on the hugetlb front (besides some fixes that are already on the
list), maybe I'll report them to hugetlb maintainers to share some of
the "fun". ;)

I threw some tests at it, but there are just too many combinations and
corner cases.

Next, likely we want a kernel config to disable MAP_PRIVATE and start
deprecating it. It's simply unbearable.

I won't pretend that I understood all the details of reservation and
accounting, even rewriting some of the comments took me ages. If any
fixes here go into the wrong direction, I'm happy if someone wants to
take over this series, I tried to get the heavy lifting done.

I guess, have fun reviewing? :)

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Chris Mason (3):
      hugetlbfs: do not grow a sealed file in mmap()
      mm/hugetlb: keep surplus folios that are reserved
      mm/hugetlb: fix reservation leak on min_size= mounts

David Hildenbrand (Arm) (10):
      hugetlbfs: fix integer overflow in fallocate()
      mm/hugetlb: compare against persistent count when freeing lowmem folios
      mm/hugetlb: preserve reservations when shrinking on HIGHMEM
      mm/hugetlb: account temporary folios separately
      mm/hugetlb: fix mremap() racing with page migration
      mm/hugetlb: serialize page-cache allocations with truncation
      mm/memfd: recheck the page cache before allocating a hugetlb folio
      mm/hugetlb: count again if the reserve map shrank
      RFC: mm/hugetlb: account restored reservations before freeing folios
      RFC: mm/hugetlb: delay anon folio rmap removal until after the TLB flush

Josef Bacik (2):
      mm/hugetlb: keep surplus folios when the pool shrinks
      hugetlbfs: fix unmapping folios from private VMAs

 Documentation/mm/hugetlbfs_reserv.rst |  30 +--
 arch/s390/include/asm/tlb.h           |   5 +-
 fs/hugetlbfs/inode.c                  |  36 +++-
 include/asm-generic/tlb.h             |   5 +-
 include/linux/hugetlb.h               |  24 +++
 mm/hugetlb.c                          | 388 ++++++++++++++++++++++------------
 mm/hugetlb_internal.h                 |  11 +
 mm/hugetlb_sysfs.c                    |   2 +-
 mm/memfd.c                            |  17 ++
 mm/mmu_gather.c                       |  14 +-
 10 files changed, 361 insertions(+), 171 deletions(-)

---

base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d

change-id: 20261027-fixes_hugetlb-2c4f02ff6304

--

Cheers,

David


