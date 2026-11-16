Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55CDD606A322
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ohNH5Gne
Received: by kanga.kvack.org (Postfix)
	id 3F6A46B05B2; Mon, 16 Nov 2026 13:29:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6D26B05B4; Mon, 16 Nov 2026 13:29:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BCAD6B05B5; Mon, 16 Nov 2026 13:29:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 01EAF6B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:29:44 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E4CA1C29F6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:29:44 +0000 (UTC)
X-FDA: 85441820688.20.952D78F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C022AC0008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:29:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ohNH5Gne;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794853782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4Dt8UvYqN45Q1jq3hRtmbwqb95X+fOufXdlZIkND6MQ=;
	b=Niq1DbG4gdhAou+ta7ikzd7AkfY7IZ2ncvqW1IRw5AUHhG+Bik2Rr91xjaOWcDLNcl0JxC
	yFI62/aU7+6GYBEdlOxVODm77rGvP8esBdUcQW2L/aEcdpxXJ2iHtuAkoeu/9+8YBPkdlA
	AIon807Yxv4IdPHNyKTmRywwJba/gCQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ohNH5Gne;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794853782;
	b=TuGwt1Cdlw2nnHpZwtQylvfsaF/XjixtZH95d+0iebfV2qoBtOIxyc4EYZLfkmyey3Usof
	0xqkLBi/OqBKmst0vMSNnzWAk1whPD5oohL6RPl8QPe5ai2auHFcLXvecO77oh7LNMjLEz
	mCqZP9zU99Uz+uuoXIQmjd+gAnN1qjk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 50A4461EE2;
	Mon, 16 Nov 2026 18:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F361F000C4;
	Mon, 16 Nov 2026 18:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794853781;
	bh=4Dt8UvYqN45Q1jq3hRtmbwqb95X+fOufXdlZIkND6MQ=;
	h=From:Subject:Date:To:Cc;
	b=ohNH5GneK3A7EOdyU+Jd+fzHkBpcFAjOiqXLLG40Bqz4EMUQxQHbMaxWLGrAUgpr1
	 D8dmX/P08z4tLfV/byuKIwTnl+WtT/bv39FXW6XhyzaGg3f1EYfOC9ccyoM//9l1v3
	 xWaHHTfTDCJUUEn0ImVtvQ//nKjUAAHnsXH8iyEMOXKx+017NpL431mj4IILZYGc/1
	 i2RsoQ+vgBOunWpt9AceF9lFiqemwF3WE61glPMXrmU0r3Ub2cTHHjVD+tjqYJYNMy
	 u26wa2YrhEf6WzmUX9fxU5bFFW2lk5eEDazTgk0t2C+q4lSWxfylvjoypdv5AI+JxX
	 LFFqt1acbeNFw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH v2 00/15] mm/hugetlb: various fixes
Date: Mon, 16 Nov 2026 19:29:21 +0100
Message-Id: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/13NQQqDMBCF4auEWZsyiWIlq96jSNE4iWlFSxJDi
 3j3Eks3XT74+N8GgbyjAIpt4Cm54JYZFJMFAz12syXuBlAMJMpaoDxz414UbuNqKU49l7oyKI2
 pS6ygYPD0dABQ7Np+d1j7O+mYI1mMLsTFv4/DJLL7tZu/dhIceYcdluXQiwbN5UF+pum0eAvtv
 u8f2dLrs70AAAA=
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
 stable@kernel.org, Ackerley Tng <ackerleytng@google.com>, 
 "Gregory Price (Meta)" <gourry@gourry.net>, Chris Mason <mason@kernel.org>, 
 Daehyeon Ko <4ncienth@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2982; i=david@kernel.org;
 h=from:subject:message-id; bh=9K2LhqofrRy5sX+UjJYGABWwyD7YIUGt24m0J81fj3w=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+e7d9aJdxWxh97VTWrwZeX82i0FNMrP9nBH5xPaxW+
 iXj9Vb9jlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACbi853hn85kBYbLPz6UHLG3
 yK7csK217OalmjNn4jnXB6Ry7XvyvInhv6OPWYy8xy4Fu/vTnTibDt3Yl/yU87Z1x8952o3a19v
 F+QE=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C022AC0008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qbi5nmbabg3w4pq14jiqhwbdtbztbeoi
X-Rspam-User: 
X-HE-Tag: 1794853782-828526
X-HE-Meta: U2FsdGVkX18RGDhzzrdOO1JLKVohAZIP0m1tF+VvDqWmR8nXOfa8XgjzDD8uN6U1kIu/GlQ8SHtn/K+AUW3lxh+u6e7ivG629QRIpiIOwSf35lZk3iUWswl6Pl07at2Hj5P88p1L1lu9O7ZyRGHoeyZgrOhIjGQPJ35xSO/RM1s17XBn6rUKYnn0TQezDxAkBFSA+02pI/AszFNBTeIR5F/OL9VSUsAsCzwzYqC0WpZ4h6wiHddAkDe88H73Pxdj9+uvTG/3fJpOPex4Sub9SPznlj107JfRr3Nm7Uekn1rldGI7ApjbaKNv3sV8MNsFzdW2MW7UqpYSP8cPn8iYfkBG9F7I2uskog1gQZ3CLcZNO4lxlZEVWhvaeN722tFisngWqZCRfgrFBPmZDfQJ/S4BVHMhs9cpj86T3onCyjxmaiQVvjg7bkE937Mr6+mH7olik68OWCAa0N/1yUZYjWt53UesoT8YaMRhO2LQeUsznk0YSU+VecJUF6Q5cHUaOcDpaIALcP1K3XVRhjXiMuy3TWjTiIuu3VJ0gPjywlr8gAk7Nw/QCt3O8kuhqkziZ7gxf/EX1Yr+AvRo/1cvbYwrdemSoYuHs3miqgl+H6CGUzQQg3FqreJn8gjUfZUV4F1ma0NvQLVmmi57AYJ3FkcZoOJmDi9ZMupe5oe0cpkTaRe/Q2l9/6FNBF4oIHVjCyiIjez2cztYtMEdbISwAeVdBZcJbx1Y9YBrFMKo2O3k6hX7nd8KUycL1y1tLrLFewUZnxw9Q3FJuStSCG/3Jp862qzzE9pyUK+L5MxWB8XgL7FSmrjiSQ4XVUkZwbL1ijycwGRWkHLBcU9wrMHNbzfPKL5Ti9W4YaiKDNkC/jAvJjbrLre0/anFTfjwyc8MbJz5bGtPYCZO23BkkLm7KlHUb44h/FhQMQcVceMvHIv2GyEVY6mLbdTrxyBJVobwWCCSEhritNPUoOmTqOo
 /qgez5aF
 vuarN2DqrjihuXC+Wf2VKaIyhRkaG5i8RIjotwM6QATCQEjvsaQI8Xl2BgwuIt/epZDx8FPyzy/gaYj0bBqNeBLtGiIzCaHXyhx06HzMg1eH39jqiMwLlqbDTDiQqCtbm7SkcwJCCGXKIyrHi9fjwedyz/Dz7ylrBGNeUxNerLNNy9ccuutVxOQfGw92d2LMSPaGWyTfSYA62tYzTVkkORmGqWGTAyxjo6ZUXFJZ5urU+z88mJwfRRM32vepEfQYZCIZokoqLHJceIKtI7wTk3Z65inWll62inSaA/9rg4CrY6B9Qxwuij/YTpA1IvCCFQyXT/iEF1xbTsWJfHJyrmb98y1cgJDQRThT6+DPINts6IYXm/QVXaHtRmofcdabW7rZ8pw1y7/ofSUJmgpwE5/traw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

v2 of the hugetlb fixes. There will be more at some point ... let's
drag these over the finishing line.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Changes in v2:
- Rebased on top of akpm/mm-stable
- Applied tags
- "mm/hugetlb: compare against persistent count when freeing lowmem folios"
  and "mm/hugetlb: account temporary folios separately"
 - Use const struct hstate pointers
- "mm/hugetlb: fix reservation leak on min_size= mounts"
 - Clarify that this is only an accounting error in the description
- "mm/hugetlb: account restored reservations before freeing folios"
 - Drop RFC
 - Don't allocate surplus pages for restored reservations
 - Free unused surplus pages directly instead of via free_huge_folio()
 - Document available_huge_pages() and assert that hugetlb_lock is held
- "mm/hugetlb: delay anon folio rmap removal until after the TLB flush"
 - Drop RFC
 - Flush delayed rmaps in hugetlb_unmap_range() (due to rebasing)
 - Move hugetlb_folio_restore_rsv_on_unmap() declaration to mm/internal.h
- Link to v1: https://patch.msgid.link/20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org

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
      mm/hugetlb: account restored reservations before freeing folios
      mm/hugetlb: delay anon folio rmap removal until after the TLB flush

Josef Bacik (2):
      mm/hugetlb: keep surplus folios when the pool shrinks
      hugetlbfs: fix unmapping folios from private VMAs

 Documentation/mm/hugetlbfs_reserv.rst |  30 +--
 arch/s390/include/asm/tlb.h           |   5 +-
 fs/hugetlbfs/inode.c                  |  36 ++-
 include/asm-generic/tlb.h             |   5 +-
 include/linux/hugetlb.h               |  17 ++
 mm/hugetlb.c                          | 424 ++++++++++++++++++++++------------
 mm/hugetlb_internal.h                 |  24 ++
 mm/hugetlb_sysfs.c                    |   2 +-
 mm/internal.h                         |   9 +
 mm/memfd.c                            |  17 ++
 mm/mmu_gather.c                       |  16 +-
 11 files changed, 404 insertions(+), 181 deletions(-)
---
base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd
change-id: 20261027-fixes_hugetlb-2c4f02ff6304

Best regards,
--  
David Hildenbrand (Arm) <david@kernel.org>


