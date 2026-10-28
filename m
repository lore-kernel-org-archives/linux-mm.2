Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0C91606A326
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rq9Ru2l4
Received: by kanga.kvack.org (Postfix)
	id DB8F06B05C1; Wed, 28 Oct 2026 16:15:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6A676B05C2; Wed, 28 Oct 2026 16:15:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C325A6B05C3; Wed, 28 Oct 2026 16:15:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B0776B05C1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:15:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF2938011D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:15:05 +0000 (UTC)
X-FDA: 85373138970.20.C12F0D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0943614000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:15:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rq9Ru2l4;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/U9n2F5dQOQHSwb1MXCfMAe5RfJMUNrLjUXev2VqdHo=;
	b=tbkR3PToylFAhxZtdDp9kEuie97gXOV/BVy8iWGvLRXKM2P9KRN1eSR2PtlkrbpLfluBwr
	mkhIlX1GsQUA+PZ5xBvn8Mq227hPkBUV81ASAj7Uxvwpc50LEqnRWN0kjg3mq1JJ1aF+uU
	TKSdHqd5i9Mgw2koiNfa4czerMuVCaA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rq9Ru2l4;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793218504;
	b=EzGdHHCSlT9cH1HBY48AxdoEZcYvtxB9BmR7lpdw5UbBP/qtPljeMr93h24PMsK6ERMBK4
	A4hw4yQzmprDc8rdh6xekAJHYss7ZY8Ku06h8I3U9xL1+yhBqCEpuBUxRiG/luwqDaqnkr
	7/cEnv6vG50C0MJW1OPy0XT6Ij683aM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F0E560219;
	Wed, 28 Oct 2026 20:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B921F01825;
	Wed, 28 Oct 2026 20:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218503;
	bh=/U9n2F5dQOQHSwb1MXCfMAe5RfJMUNrLjUXev2VqdHo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Rq9Ru2l4yMkJyr/jNoKFGTmkAlXE2FDGSgQxEQAku+lQY8AFnqQIyt1jzMmONwh4q
	 kDTLUzME3AvbI5d7QDNllciJdAzfa+61Fh44eWWBAmr6qPK4xxkv+6x300WqZp2BfR
	 zX/T0YJcIGStcwr5GdE4B3ZSqs6wXKJyp2c9IgJFjQaGqhKDykfe8bPb4hjmAf2Xwu
	 lJarCETJWX6/U/PqBmmlR5EQyyXPyjiut575L2P+6OYLtAbh99qxojHguMjAcS4Bss
	 q4OFyM9/FSL5Iuy4AHNYlsunTo/BqU25zXOGquu4qbgNHa4C0R8Lq17sPHtO2vN0Gy
	 5ZpB7NHG9uFbA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 21:13:35 +0100
Subject: [PATCH 07/15] hugetlbfs: fix unmapping folios from private VMAs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_hugetlb-v1-7-a0a033db180f@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>, stable@kernel.org, 
 Daehyeon Ko <4ncienth@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1684; i=david@kernel.org;
 h=from:subject:message-id; bh=rVtz7fX7kcHzCCezweHAtetVEk43H7wa5E9No4kWJ70=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIehZfO5dZ6YFXlkbImz3NXXN2kF52vd6eYsGuKWIred
 ZgaGODaUcrCIMbBICumyBIUfN/g5ct1tdVufMwwc1iZQIYwcHEKwETOeTL8lQnbm73rQsEJnaZ0
 GyvLGfOb98tuNGOecLv3lOw074RdGxj+BygIq7pWz2K5O8u51Wqri0FSzNOQp08sTi57zbrxyKI
 3TAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0943614000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: t13zt3q1i73wp8td3mprpst4uko7umby
X-HE-Tag: 1793218503-90464
X-HE-Meta: U2FsdGVkX1/AQhzLJGbq00DD+a1b+Ektd3dc+8o0zgKcUAw1EuxyR0llBYo5bP6bV2EboXhzfht0j2hS/71IAvnP6ig/JVp1YOUKqKMm4VwJ8cjvYx4TYSo5ffr3s3qXl4e6fEwwZL5MctjSMDrHYtatKUrb+4LFQW3KjOjqbMnHdmRngQyGJP3qVbsNnTlhmaAEfPLv1A/YquFIAvR1PsorDNSE8KH/rgKwvywSP8+p/bXCzaX/CI86l4KQ6iYDbp5isQuEYhIXsVgpOKTmrY6ocK+LWhLu0i1n4HBRlJa5+QNMcFQD7gZsfpKELMBMYY79kUy4+Sarbz8+XBEYQR5NQLgjeWM2Tzy+yaqa3Hj837yxNFkBrZ8KLjS6mqXYX/PKpmqI3xqkNBWHSjsGRK0v7Z2KLjgKpo84+CERP1IiFpn764SYD6Ydd1NBpyb3wWXq2O9oRIztzlAlwXeXL2UJB1sIBMIPs5PeeN+6YdBlLAH8unxIuh3L6bfqxNWdt5s54WnCH0BK2za23c/dbuptLWTWt3Xec7dHmZlioU7iGJcft72cUjsUQ9TQVpUzocOq4CtxzVwNWSgWwzsbUI/8mcXe2QQrjV3VWxlSpknolL/5IrbIZb8EYBgeX9/8XDvPqu3ht78mlCixVQMx+izuFdU2xckpQbjxycJK1JpHII4O15QqF+DTed3AfaYbmceexOLL71jHwQ+djDYpisgVfv7CQ23uGKxv+Dc7Xv2LSqidmLP/dcyTyXyXUljaGo+nyWO13lWpD4VSuTI94TXWXGgQSSVFC+xamSy/xGKJYdwPhLyMT6giegWdzfAtezcF7GxcaofT3O3UZnhX4NxRqHWjooBp7Mg9aadZE0wLEANoXwTv/qk5HYaHHlP0BhdTgpginY8/FHd4vmbYs8w2feempasWupYQxIwB0GsrQB/jOl3p4COIC3xpk2E8ZS+d8x6DUkuFRqxrXLp
 cDkGa0XN
 z3/+M4nGXGEtOdjqkqOpK8t6lqqRDIw3u2wXciahSiY+t16WHRB3avzhluo8zuyczFqGIWHvHSRnYYaUZyHtjMw71twlbc9QFmwvcCbSCOK+DZt2IhkARN+Ra+SAUuKikKGxVzaHmPRoyVMgxHwfxh+93Y+xK1c62lKAKYBLjXQKG9tNKNy2JmeMe3mshMxs+DNMJKnZqXtDvvnmW39ZX9u3091V86GfL/80pW1DXHMY4gOrZJZT3BRCpzeVgqxKjRNc5Ta9od2eyB5w5itiKM2NOArYFheFQeBRhSSlIquJZMvSRnU8CNXqcTSGLoFWCd1q9G2QK2iuMcWehxY5S0fpp3j8tXxVoA0VKMmKFZNL7oepLp0Gm8rVXhz4Go785cfXvYBqVYASEzTnEBKMYzlWqmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

hugetlb_unmap_file_folio() assumes vm_private_data points to a struct
hugetlb_vma_lock when hugetlb_vma_trylock_write() fails. Since hugetlb VMA
locking was extended to private VMAs, this can also happen when
vm_private_data contains a resv_map pointer; treating it as a
hugetlb_vma_lock corrupts memory and can cause crashes or hangs.

Only take the VMA lock when a shareable lock exists, as additional locking
is only needed for PMD table sharing. The fault mutex and i_mmap_rwsem
already provide the required protection for private VMAs.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs")
Cc: stable@kernel.org
Tested-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: simplify description and comment ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/hugetlbfs/inode.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 5592cfc6cc8b..fa367fc9e019 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -400,6 +400,16 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
 		if (!hugetlb_vma_maps_pfn(vma, v_start, pfn))
 			continue;
 
+		/*
+		 * We only need additional VMA locking here for PMD table
+		 * sharing, which synchronizes on the shareable lock.
+		 */
+		if (!__vma_shareable_lock(vma)) {
+			unmap_hugepage_range(vma, v_start, v_end, NULL,
+					     ZAP_FLAG_DROP_MARKER);
+			continue;
+		}
+
 		if (!hugetlb_vma_trylock_write(vma)) {
 			vma_lock = vma->vm_private_data;
 			/*

-- 
2.43.0


