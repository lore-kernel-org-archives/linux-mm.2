Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BEBA606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kdh2USKD
Received: by kanga.kvack.org (Postfix)
	id 79DC36B05B6; Wed, 28 Oct 2026 16:14:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74DFD6B05B7; Wed, 28 Oct 2026 16:14:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6157C6B05B8; Wed, 28 Oct 2026 16:14:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3FC1C6B05B6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:14:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1B8AA024E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:14:06 +0000 (UTC)
X-FDA: 85373136492.04.535C167
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 03A871C000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:14:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kdh2USKD;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kpnp0nKo1RLJPeIcxnHpYwtTOco9Mw53rg5cDi3/lLs=;
	b=XZt+BMUiJSBDO/HhqW/L+fNp8iO3kF1+LJoAiaCVdW0FLGi9POaZUVATOwk12za9EBZtQa
	YidoFdz1uI3L/gfp1Pt+mkziJpnVcxOtoR1rjHc/2yvEmtkdgNiS4kawZ0VmZAMF/kfSC3
	z0D/vvGztkrxhiHR1GKPLwR+9w8OJ2M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793218445;
	b=p9Q5Ot/f2gL7ezsLR09X642k9lf2iA210Mztu5rU2r9UP4gl8qkT3gmYPsYh79TfIxwMxY
	nd0Yg0XlLAFYNch6S9KH17ojjrsfb7rOfYC2WJt9PTivUtYFJBnZCdNmXFJ0TEMNBDxIP5
	Ses6qBtXWLq1JnE2iiYZwsgBA+8OXyU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kdh2USKD;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FBCF600DA;
	Wed, 28 Oct 2026 20:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECCE1F01829;
	Wed, 28 Oct 2026 20:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218444;
	bh=kpnp0nKo1RLJPeIcxnHpYwtTOco9Mw53rg5cDi3/lLs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Kdh2USKDJZ0FkYnWxpwRhfUMZvge6+fv52eBOYXQE4K9FiM0K4U+BHJFNVSPa8SaR
	 qz0fJopgw/70FToz7iDOKngca29X//VXT5/e8eP6xGe5f7GFhffQH6zeC2GOp/hleH
	 n9o4bqtE3izozibZx0/EGpV6yc5ooao2ZOamV04m7ODd/0AjL324MpPNritM1bvgPV
	 i4WVSj11U1NP3zYtWbfrCuQSbjPM+7EWyuQ7RkG3U4c8cWx2ojiZ48TgZhVuUFx9jj
	 PTNmpfwlk+bKAkCQlPvJwDrVqWXVgoBNuxz+ZTVLJ/GThvLKqVUtebOP+aR2t9RJfI
	 QneBInCwD8IQw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 21:13:29 +0100
Subject: [PATCH 01/15] hugetlbfs: fix integer overflow in fallocate()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_hugetlb-v1-1-a0a033db180f@kernel.org>
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
 luojiajun <luojiajun3@huawei.com>, Josef Bacik <josef@toxicpanda.com>, 
 stable@kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2170; i=david@kernel.org;
 h=from:subject:message-id; bh=I1sQzSgEyvJMIZxcUjk6PSvZ4Sdw/GRLUPVEqCN7UCk=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIehZcebvr66cjyjsA4Z8MHays+f2Jax1wSNyGwXXO75
 bTlOWxcHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExk8xaG/zEmOY2li54ueRq3
 v7n3zJSkguNagnz6Ep+ZLr7Oe6t++x3DP/VXvov+1dmK3lywRTvn29Xfb744bo47787m7frugMi
 alUwA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 03A871C000D
X-Stat-Signature: t5d787j1cpq87hnzh1ed141u9dsy5jrs
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793218444-760677
X-HE-Meta: U2FsdGVkX1+iTaMYhkLyudOM5iPZA/e4gHFl+xMNjcacXHps9jwFmy7kN0c2Gvr0DUpMaQylEhU18KgrUaenCBsjXYfJmeFNWT8N0NPr+UEkzIxJ8qh+0ZrheCEBEgV5EequVLfD7nt2+1dHnWOA1LIho3kv8SyWntkYjGI+doScbedrX3KUefoJGqjKgBXblVvKtWqS1fNFOt2CMFh64VHELEUlow74HJX94v+HGsoaaiVkbUgpDWmdE6bbxLMaws73CJ5KsWuFXIJn6FfZAq5bLmCDEgSGNhCkQMtQPIZ8j/dNrKP4ijdHWu1oeC+a3lbxGYobDCJpaY+HTXLMgaZWJTbRHVSkkSgi7ZqU7VD2N2nCqryN1npUzKFwicHvq05VkYjuCD86C0RsVxFbyLCs6WOJ9l1HkncFUBsRhgEEN4KejSz2dRVDi/CLOsMBffobHryMA9lAxKrKr9HimYSVMoa5XvzXcilszmTygxVlVrgpBbr1n8DZlre+/EAyA+L4HIelhoqWVK0EAPyZgYbEnzZg/txyaHrMM1OXaLK2iPsABVDne3jz7FzLC2I3FqJ3Ozpxik3o2pQ3tF01k60P6ZWSzXbv7NpHkF3aQDU94u6f1twA8HVh9aQk9NZRdSEtovkySISeDrc2sOfUwpWE2sIYh9I+Jdk3lJDUTmX6oI0GCutjLsE5LsVaW982aRIeXiXdpP1vS57yrxAT5ayhw0KV0ZzLINB7+8w67CAVzpuorZUJlO6LUSVguDe2qnzt2GTiOYG9f+lBZWOV9HCVbyTYLN/K5zeBtjPm3Ibs2JuUudZ0xDbEKKh2tfeWEtCTfiRhBL4fKYteyx+s80GwjytDJ2rvfynN1GFa3/lAwxZcrAg/8LaVmhMeDdSpS/Rl2Vzp6HaoQlU6chmpCubygko4Jy5MZQE6nxA5MJUDLuuURijECDhlCyiSbnG+Q1I/LYFV6MOzVVnVFlQ
 YJ5WbLb0
 uFjIsagXhCJsOfkrK6cCXaB/Z0XQKKnJfJ+RRVe69RLZ/lHv3DDRAJWO228j9HE+UbrUROwrd6ZIk6aVqc+OYBtpKIDTh1+TOEynqeSaZ1YuRRDFhN2Y7fxUAS0dYQAVbk6wBWF6woKYFerxjkJdqKh/C+5MISchO5nsWmDrD3tRTEWZA+g1/8tMB2zX7Y4EHmH1kp+WVGFLGVq/twK/v37aZHJeXyj1N2wCrg7m9VdIEQoo6in2lTEQ6+fFVzJyCKtAwwg6jEOtnRM0tLhtm4yYgFerPvwS+FIubiLa4gdrY+I635mOkXf/Qs49uTycjONWBL+grkE3mecEB3UlIsxL4gSYkj1rrubuo6kWwdtOTE27CbnLkC5ObMGJHTlzRjyM1eh8CrvP1LvtkS+V8/NbcfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hugetlbfs_fallocate() rounds the range end up by adding hpage_size - 1
to offset + len. vfs_fallocate()'s existing overflow check only makes
sure that offset + len does not overflow.

Once we overflow for valid endpoints near LLONG_MAX, we can get a
negative temporary result that is then converted to a very large
huge page index.

A one-byte allocation ending at LLONG_MAX can therefore consume all
available huge pages. Pages added beyond LLONG_MAX are skipped during
inode eviction, leaking them and triggering the BUG_ON() in clear_inode().

To fix it, calculate the end index in a simpler way that cannot
overflow. This also fixes the signed overflow reported by luojiajun in
2019.

Backporting notes: without commit a08c7193e4f18 ("mm/filemap: remove
hugetlb special casing in filemap.c"), remove_inode_hugepages() must
include the final huge page during truncate and eviction.

Reported-by: luojiajun <luojiajun3@huawei.com>
Closes: https://lore.kernel.org/all/1554775226-67213-1-git-send-email-luojiajun3@huawei.com/
Reported-by: Josef Bacik <josef@toxicpanda.com>
Fixes: 70c3547e36f5 ("hugetlbfs: add hugetlbfs_fallocate()")
Cc: stable@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/hugetlbfs/inode.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 01c4d6f44ebe..5592cfc6cc8b 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -721,11 +721,13 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 
 	/*
 	 * Default preallocate case.
-	 * For this range, start is rounded down and end is rounded up
-	 * as well as being converted to page offsets.
+	 * vfs_fallocate() guarantees that offset + len is positive and does
+	 * not overflow. Avoid overflows when calculating the end huge page
+	 * index: set it to one past the index of the huge page containing the
+	 * last byte.
 	 */
 	start = offset >> hpage_shift;
-	end = (offset + len + hpage_size - 1) >> hpage_shift;
+	end = ((offset + len - 1) >> hpage_shift) + 1;
 
 	inode_lock(inode);
 

-- 
2.43.0


