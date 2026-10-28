Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AECB1606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MDryEfII
Received: by kanga.kvack.org (Postfix)
	id AD5286B05C7; Wed, 28 Oct 2026 16:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A86256B05C8; Wed, 28 Oct 2026 16:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973916B05C9; Wed, 28 Oct 2026 16:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB5B6B05C7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:15:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5608C01CC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:15:44 +0000 (UTC)
X-FDA: 85373140608.12.E7FA2F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 23971C0008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:15:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MDryEfII;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dhlOcylSqv6vV3g9yAiSRK5LeWK6PvVVUjVeVgzCiQQ=;
	b=uTo0gI85TqOti9gmklrR/c1kl6fQeghX1V/9/bvHxGem2cESg0aRrP+CfiQcK/GdrKFfMq
	QOCIKgTPrjKMVPHD3dXA4OoSYTynHZ5y+6zakBZ7fYWofU7NVSJjdDXxpbqHY3VSvXFfE8
	f19B/Vs3NbsZdgAeRL2FHBpQGUYMdH8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MDryEfII;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793218543;
	b=px5RyyMKU6f4955mm/NMrkFHBZmobwf6PO/gvEKV4dKayAcNrYcTcoXC1M85SdqLjeGGfK
	pWbSrpakxeGEdwRmDN5t6Nl+brLwZ2scXW8XFXHNu4UJXWSLnbFwWiTJ02OTmw+tVofckY
	dfTXyYl2vyj0Ia1wQmZlZLmBbGfjT8g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B03656021E;
	Wed, 28 Oct 2026 20:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5134A1F01828;
	Wed, 28 Oct 2026 20:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218542;
	bh=dhlOcylSqv6vV3g9yAiSRK5LeWK6PvVVUjVeVgzCiQQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MDryEfIIbBaBrNLjVh8hACudAmXfL/S1kjrTLh5SZ08bjgHV6iWXaXp31ewgzfKe+
	 zWNEbZUYhL/laZa4wmO5uWL429aLw9BrkwUNg9TYVRY5iPDgN5wldEw1bIoxGd9Toq
	 PQh1eb5oeGrVkia/U2LFeH3hWctk396bHN/cwEVZW1towoLPmbhcF0C5pzLxc9fE9x
	 6yZmXjQs8uIOijZ0DoGLNB78fF56/72A3d+tDxUxf6iGgw2KYtvPos5F1X+diqmqMt
	 c4S8d2I/GmOne7rKz5V+Z0nCjCzEAmelHZpDitJZ2FTrtPqI24uifZXvNp1VdlE5I5
	 GxDSJ1FqFqmYQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 21:13:39 +0100
Subject: [PATCH 11/15] hugetlbfs: do not grow a sealed file in mmap()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_hugetlb-v1-11-a0a033db180f@kernel.org>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
In-Reply-To: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1642; i=david@kernel.org;
 h=from:subject:message-id; bh=jfkxciSMrikjpjxL1MRSlSwGiIzaViEI3tCQWSWiOnE=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIehZfd+Xd4tvvyz5xvlh03sXngfnuSyoGrLxMOfbHTm
 3vghl/O2o5SFgYxDgZZMUWWoOD7Bi9frqutduNjhpnDygQyhIGLUwAmoqzM8M8qr+y2cslv7tel
 Yjo7GTnfTlNcYyIkuzDX4J/kGgX2Qm1GhvU6GhpWRcdurZr0NYObk8Vxq9uH12bhR/KXcU2N2hW
 gzAoA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 23971C0008
X-Stat-Signature: yipgmqx384k8fe7ya8azybfxdjo75j9p
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793218542-286743
X-HE-Meta: U2FsdGVkX194KAt0jYC8vxIOBho7yCKsBxe6vqo0HAVdi0Ece+S9q8o0LQxJ0kgzr39OWatDivGwbYoYmzY6GAc6ySSlE/QvU1Y4fUjgi8Gzm26X/57n0pv6TNp30zLuzyzlQAALbX3SAP+FFkkprh7hCCFM824cbFMbzFei4lpSxbk7VVemtXjVk3/YXEciHgRYGrdwKZ0aG7rvsjlMdUYvVmxaZVE2qDpe1U/aNvXLaKfZ496meoIZG+3FEaQtPKLLhIuTvWR4gxS5DQQEsLT+SLAiWn9P7yxr7ODZy7X8f/dmmmhkZTuldPGVJATXaUl354Z1Spp+d8M1Qyp/g2L1bkq3l7sxjOzaskZrWBZc4ZYsvYl3StQ4Gqq99EjpwVMMjcmgyD6Re4iT9jbCfHzlqaILQMT84GdlUj+Y/Q5K6acyHJ4aKr/tXyjVlDX6YrPlhPzOpNp06K95X30Zw83ZdG5sHkcncwhhsk6J5hkpZtiXBoN4t94IEZdI8Ow7nQgXA0iWOTjajG9TkdbQPCbCgdzsOe82wrMudbJQU9Sn74nrqEbt/CXADKIvSPwa42cpP2QPw9z5xEzgkTZD8M/AgggOFtJhs+pqavlBzXvjy+ShaAlALgU8m52WsvFrEkyA9O4kcDBRuAVMjDUlDCufZMFVbVqhgHCqCGG5EihzwYX/m9Zr26UfNNo/TrZndgqDTQrvQYFAoZs1oo4nUamI/AY5OMHo/QB5HdrcBASAELiW5+2pkBLUbquBmXpfWS0sqbLbmSrxbMGqbQF3dT8MUWLUiZHEt+viBnURLYfD3dd/euDKbpkvZOhgBfYFNGmwk5Vg+xLs+yRaZnSaT3dvdoknKskOxVnvT5C4hElkk7ELjkSa7XF2vGG/GDNfAsDrlNG+kqXYxEpnqhK3vPa3ymjjVOE3Oi5O2AuH1heiwjBsM9OiZR94mFcq8Fj9bAicIo9C8WYaA56LUCi
 /1AMJ7wx
 x+vkq61pDQ6T8W3axqLPX96ruJHDr68wpxVvrxBMlfTSMckanS1oorNltLsxxaA9Nq0CydcNsrlhCnVZlej5GGjQdrHlclxj8Gy1VR9qiwRdNmgLujJ45oxdB1IaEnF5ky087Ls0Bh/z4oNo0zg4ItrSojtQ7OipiwPghwQT8yEMqr+IJJS46vpive8FrwZvZibRVQlRlKWYKsBSbgzFHXIapTqmYGMr0LkOtOs0QpLjj1yUp97Q6R5m51z6IbV4TVTJLAk1biL+ZtOgPp5k3Thb0HqhARmm4HYkplrvJn5LDsHclck6bxnsdcsBycFbwFBXj+h9PzGrR76dsL63UB7smd++uyOXvCzL2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

hugetlbfs_file_mmap() grows a file when a writable mapping extends beyond
EOF. We are missing seal checks similar to hugetlbfs_setattr() and
hugetlbfs_fallocate(), allowing a user to grow a file that has F_SEAL_GROW
set.

To fix it, skip the resize when F_SEAL_GROW is set; mmap() still succeeds
without growing the file.

We currently also allow CoW mappings to grow a file. Disallowing this,
maybe even only for read-only file descriptors, could break existing
userspace, so we have to be more careful. QEMU's file backend is an
example user that might rely on such things, and would suddenly start
getting SIGBUS when faulting in memory outside EOF.

So be careful and focus on F_SEAL_GROW for now.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: ff62a3421044 ("hugetlb: implement memfd sealing")
Cc: stable@kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: drop comment; simplify+extend description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/hugetlbfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 174455e10d0f..47da18bb3490 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -156,7 +156,8 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 		goto out;
 
 	ret = 0;
-	if (vma_test(vma, VMA_WRITE_BIT) && inode->i_size < len)
+	if (vma_test(vma, VMA_WRITE_BIT) && inode->i_size < len &&
+	    !(HUGETLBFS_I(inode)->seals & F_SEAL_GROW))
 		i_size_write(inode, len);
 out:
 	inode_unlock(inode);

-- 
2.43.0


