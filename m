Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEC66606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=frTMT/BB
Received: by kanga.kvack.org (Postfix)
	id E2F9F6B05B5; Mon, 16 Nov 2026 13:29:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0006B05B6; Mon, 16 Nov 2026 13:29:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1CF66B05B9; Mon, 16 Nov 2026 13:29:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE2236B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:29:54 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 183C1C024E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:29:54 +0000 (UTC)
X-FDA: 85441821108.11.0FBE194
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 40BD740007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:29:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="frTMT/BB";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794853792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BDKwBnssy4agIUeqV3XD2T4cqqodSZ5/K7uKqzvbVTo=;
	b=YAvA9xrGqTOw/mIRbrMv5jUTwW+oXlqYhkIaDsyAV+JYxvIp8UamnOPhH0pNmQWQxS7Hu7
	Ua7SITzBwt9MF9ZRAt1pIu28N2agsMD+LhvqOHMM1ugpM0N6/Zdg44flmodfmf8ExvMdEl
	hrnNaciHJZdqc5CEe5EqALFUMBScP0M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="frTMT/BB";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794853792;
	b=tXZ/omtpHFAVLyehb/g3hqZRw5QZK+DJnlzc3mIEf37JXQQgZ3Kc/8oiSpNeIY4VnIaj8I
	x4c6xLTdpFY9rME6Zj3/95NSIT8H/nlnXsy91mnavgms641xkwZf04o4z/cH2Stx41jX+U
	NrWVZ3C6+aZQvNiCiHQR5pDCwkgXYuE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75D4543E53;
	Mon, 16 Nov 2026 18:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D3C1F000C4;
	Mon, 16 Nov 2026 18:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794853791;
	bh=BDKwBnssy4agIUeqV3XD2T4cqqodSZ5/K7uKqzvbVTo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=frTMT/BBjQfNrhm+isVpW1M1JadVDrkuyoM+l1Kt9CYcRUMtdljdPkd+1eUSDEOKp
	 lcgVPz6EopuvnX7rrxMXk9dg+FhH1yeux1/LyyDXJE805w+n/6YYfd4eCq5r85XKNI
	 lYTBp+RPKMr9sCzgzOjdp1sBIRWq6xT4mgA3+qR+fbaUKb1bS2jtbdoM30nYdICi27
	 x/111AzBvAmJnUoXkIBnOOA5DWQWGbBK5uecgSsex7PC/9sf0Fy1b5ueL1r0MTZ8rj
	 xjYHhyGpzg9mySTJtumtF+u+KcoU03ar1bN+mF8xkluXjeKobf09Wq4N13sT8LklYY
	 dfdi+qg2Yjz1Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 16 Nov 2026 19:29:22 +0100
Subject: [PATCH v2 01/15] hugetlbfs: fix integer overflow in fallocate()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-fixes_hugetlb-v2-1-4dd9e94ea9ac@kernel.org>
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
 luojiajun <luojiajun3@huawei.com>, Josef Bacik <josef@toxicpanda.com>, 
 stable@kernel.org, Ackerley Tng <ackerleytng@google.com>, 
 "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2425; i=david@kernel.org;
 h=from:subject:message-id; bh=s4vY02Z66QhN2vzSqhVJnXZ9yDCfCoi6K0jWeQw2axw=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+e7dvD7GoClikdnle1fqn3m+j+EtNZ/mXSS4pWsrDy
 zytNf9uRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABMJaWJkOGBc4swuFVgum6EU
 y39pfXxn8MvXSplKfaJn/inWtczbwcjwM5Clvp37xJXf3xQajy2LDe8X1/E64WLxxDDt2m0P/ip
 eAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 40BD740007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kkhzn54d9r57ebpqs9jtq1ofdwpdjmd5
X-Rspam-User: 
X-HE-Tag: 1794853792-526180
X-HE-Meta: U2FsdGVkX19a+oGu6FfaBxkHSOosBqepFzoNZ97r8PAv/FnPpu66KY/dj6EhuYmrDoQ4cmfBYeYsUV+MoYKK2mBXY1KsTe7K2Yw62w5GKn7JGdvjHgMt5yrbrDsIP3fEJmzqOEbBnGivKZu7tCiY4NJxiLrJOyybDMLp6kdwqI1vBDuipcTjyFnMYioc5Faw11YzsD76qC2WuXbDoK6bCI0jUaL8JDP4hfaxBsrHBwogELu/kEE0KEsTg+6XFQwfz5Hw9u+d1+JsyUiss/BoYm/+RytVkewuDU4YQ+syzOxqQ8w5N74XVrUH90cSaMvzyiEmC5SbJ/0nFdpw9/aDWXsygVZgh3rmohzOha8DtM6pWy6bbvjnWqOKwPaPu/h768lC8tCAD3KneWhmKHTeIKkrfpWsV2bjqO87EGawhl+F0hSUh8EfSMCQafTZsyRhbQqbAZ2L7RyfkEP3WySkJjml9eCu4WQNapW74m7H6zYGv2Ke6SEK8fsGGMXKecCLzM0+2NvEuoERR4m/2lvIEcnmjAO+pHBTnYk/xSe8CwoKUvYJ4dSKZsc4Z0qsvGh4o/0+g85EF5eJwiAE/kHXnhUUZ5Mc5xbBc7RaqhDKSI0OdEuZgF+bxLAx8/VwmFLsP0EObTDvvzLP4tM67L25KPMyDf6KZ9LzAc+DXNEMNaM2qnOuNE0yztWfDgIPQctOhhdkLzBRniPoxa+ygWoycJBFgkHvRlyrGWijl0SyOV3Fa0s+ny0q2Tb3eWuzLCA+9op4In/jKA/rQZlWXnczSYpF69XjJhgK2WqaK33qV0KC6cE+Md7IrEi5ega6Mrwt9XeOcFNyjPIQ8wjpupqOReY5KT2RdrJoMNhrMPIwYf7xjPnazNMP+UMS+Og9r6OXotAQZ0dQWym2DcylPg6N8HvsYhUS1HD3hs8UVhNSvJgY1V2lYggm8BUSzCr0P252ACoVCwCz2HL0lszFb7J
 c3szJtmu
 lghfazFojFgonymCSUEm0CJak97P/nmV5zq21HChKWvuK/yMrzJNMXN9w+V6F1QMSN1vbvauTz5QkW2XjdX462jRzaQZMNAbpKvMswVKWjoG9zqqVAXVsue32oaC8Jqt7+dcRiWqP+8mmtHZPultYBYHOWtPjkwu35wcuNcMQyjx0DNwC1QFhFknyuMZ/LBwgw4QDYU1x+pDVCmbRtrsjRJbNAIDEb7ZT+vDN7TE6ekKJnaDBNpWxH8UKSw9B1qrwdTX5k8+vQGv9zmhmqxfJbTlhaszZQxaGyFVjzsXomaXsK4BU3FFp2TfrhG4H77MQYg7ggSvrXu0M/4vq86pIIenuJxYMFvBZf8yAxCpJYpG3WyIgBdO7fsYLIeiOA7Oc+94fDWaD8FOJz6pkZGyGmD3wJWBeofe67BjxVP0IIWbrmAQfmT3oHYlzXcF74PyJS0gzqCiNyYsdDp7cmAeT+xgrhNY8mSrVXtVSLUQpmkyKxvc=
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
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/hugetlbfs/inode.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 02e0a65d596d8..9f502a456cdb0 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -722,11 +722,13 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 
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
2.56.1


