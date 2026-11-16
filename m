Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 336F3606A33B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gzU3ZvOP
Received: by kanga.kvack.org (Postfix)
	id 04FE96B05C6; Mon, 16 Nov 2026 13:31:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0013E6B05C7; Mon, 16 Nov 2026 13:31:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31DA6B05C8; Mon, 16 Nov 2026 13:31:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7F716B05C6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:31:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 435A880281
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:31:33 +0000 (UTC)
X-FDA: 85441825266.23.C2FFCB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6C8131C000E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:31:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gzU3ZvOP;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794853891;
	b=JuGg/hNS1oPW1/855G1DvXBJAe26YO/SOxnRxO/WaWw88qtGYIyJHvwSPI6bXg6G+Vamu4
	AdeW5UlZj4w0DBRC/Wx55QVg+iQubUeZ0ttNAfF+JOdKeyBbRR0G2V1PAS5Z5DHfhvUaeJ
	vPI2JqZmoYCOhgeghX2c8QCRA2J0840=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gzU3ZvOP;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794853891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0jJ9DG871OFSsJRPfDNFiA+MAmHAYLFk8xwl1caeO8=;
	b=R75TOeKKc9ygk/CyDaBxhPj0kkZXwPlkBMiKT92VA11ZvQdeQ8TQ/qXLKqYFSZ+AkAVLLN
	knqkyHHsmMi35n3e9nYthiHkGrX77ENNPWDjKfGkzb6N3UKelTM25VgUYRKb6gicgDNwua
	jxWONrYRHjal6ukHEzi3a/eOCxamQ90=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C6F96405D9;
	Mon, 16 Nov 2026 18:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C1B1F000D2;
	Mon, 16 Nov 2026 18:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794853890;
	bh=q0jJ9DG871OFSsJRPfDNFiA+MAmHAYLFk8xwl1caeO8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gzU3ZvOPOm6u99r1euC5lial6Qf/zt9Z2yF20f0NZfK0BVs2UBiLqG7yras464Rq5
	 U/O54qNu+c8Ffk4R8OioGkEV2DxIx6W2UBRXjc7RgtGhuRVZyZvGi380w6qagb+iaY
	 H9T6pnKcrcLEz29qrY3kpf1UsQ0fahsCc5+cUGi84dIoCI0gI4eUAJbcOn5HdCb2Ak
	 f0VFiHQBSxpfcvcYAk05ieFQaDQ5PTaN00cI3lUo5iaXRR71T0/LYj01OAOsb2YLhY
	 byGtidwywQpBEzyyOwWxmdTBT9Jga8CtTWC8ZMQ5QBajeLrCaOLvFZJCEuxlRc3C4P
	 ReSDG4BvlyAhQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 16 Nov 2026 19:29:32 +0100
Subject: [PATCH v2 11/15] hugetlbfs: do not grow a sealed file in mmap()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-fixes_hugetlb-v2-11-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
In-Reply-To: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@kernel.org, 
 "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1744; i=david@kernel.org;
 h=from:subject:message-id; bh=G/tuABhS2tS7ZSsk7F/KPnT0aGZ5wg9nvABDUFm2+8w=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+e3fGM9mYXipelJ7Ywvbq5fLfrpsUPx/6NO/X87g3o
 QFamoadHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExEX4jhf6Wtzm3ZywGvbzdN
 TE6efEZc8KnNtVUBczU1DvIp39V8/ICR4UPy4sf/53i6vRIoZznvk/3IQ8Bp2r9jsyb+KxX5E59
 QwQEA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C8131C000E
X-Stat-Signature: jed4eb9bc3rwwoz97hg6w65rz8gok4xp
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794853891-367978
X-HE-Meta: U2FsdGVkX18ghmqLgrdp+QjgVU6pIX0EZB1XHglDTilD+Z4KfTXGxiGWP5SN04P9B1qvJgzQhnLNga2Xm/Z7MaKSyZ6ZpgEse717geoo1mKq86OPcHVcdOABfC1gZhpqjbgUJX6iiMFtnX+id7ydXnDSnJrIC7sVEChHUf8B9sxnUc/hRjUBQ1PHqxxccXPQ6ddNmdnZLCl1hRL8IsUmb2IUNmf409LBxdjrE8etkcmk1a1oiqguCFkVTFmJYynJgIbpO+byo4D3xGKoS1msKbMKzIgksuD+/PPu7N8FpzLY2LX42XeAK+OJHaf4yfOSwSs8LyEx7oRKvLQ8cl7NF7uf6J7/BlsC5d7NouO0zkkKMsB2TUf6O4o9g0+N90TAbqBSLmvO36yZFFhYeu5YF1QyWNTnTxRVmGQIeGGq/LVT1iERAFLdeSG+K3i04AqzDQIBcnxTnBart77sOQwlGeEMp6PFjqvTe3/KAoFXGBQTC4JLENq1Zr9SZPYeupjAXROIu7ZkYV8S8V5xB5PniM8UYHdg65eSnjScAwkfnYl7MnVDk+b3BFSanR3q+LRAIiP0QkOqLOvthb+PCcw9dVT8/Vz+iP5CYKnOSR2hmlhc5TVTiCMlMIMUQd0U+8imjgMCrfV8N6khqrcyqVQMgq0iY+0S2IUv+jjKcYoAFGJYLAfkgY775EzlXAjCiOCswhXNYC/8bXpv1ikENnJvxO5+pa8rEDyYbS5m9+KEiNbIGbzOL3LhpmEmOMnBE6xxcCqX5sUN5HO+N0zrFDpINRb0upGQEYH91i7QG2aos5lkwl1KBe5VDVNjhLbWLRRTFe6O3qGnHHUqikR0TEyj8u8+J4nAhB4E010PWpG2BH3keicJO6f4J4pXNBvuK+Nk4HSReBqFzKtZIBPnhBpyU9k0T7MnCKKke9IiF8kmjHxf0D4LOXVjROoiiCxEwqeIvlkNqZOF1lmeMQ/KA5J
 u8MPpv4S
 cWc8Q8BARJW7KnPEzVzAZv/4rjcFqgsXuPXSR4U2je9ZdUZWQuw+ilrZfa9TiWMYZFomYV6pRGgSdRienFMA6RopwmghOKEFSxAq4O8efwcHf8W6C+bPsQV7FAAtlNrNgyrig0jDxy32YfQJRQbb54BACJMuOItlZPOxvgedDsxgqf+PheKaiWXC8Ee/Nv6i66UDnpr8WXIjwGFjZo0CZXbfpD8cTzuSKzjVl3UtLXdyLzCRzh2GqA+bkUGHib3n54TPjGAhGismAc+fAGK6nbv/+5w32W0WFmFMYsgf0QtaAHhHkNze1BZMaH6jPCWeZt++mf7n9s6ZdZoyaAurwRSxA2fGeQTvRoFHLQriShykb/BAdxvTAv4+ZLomVUlhLgKrN
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
Acked-by: Muchun Song <muchun.song@linux.dev>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/hugetlbfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7f64bdc07aa80..68761e1ed4d2e 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -157,7 +157,8 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 		goto out;
 
 	ret = 0;
-	if (vma_test(vma, VMA_WRITE_BIT) && inode->i_size < len)
+	if (vma_test(vma, VMA_WRITE_BIT) && inode->i_size < len &&
+	    !(HUGETLBFS_I(inode)->seals & F_SEAL_GROW))
 		i_size_write(inode, len);
 out:
 	inode_unlock(inode);

-- 
2.56.1


