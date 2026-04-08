Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56996105D9AD
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 09:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82D6E6B0098; Wed,  8 Apr 2026 05:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8051C6B0099; Wed,  8 Apr 2026 05:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742426B009E; Wed,  8 Apr 2026 05:35:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 64C5A6B0098
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 05:35:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04337140A71
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:35:54 +0000 (UTC)
X-FDA: 84634881870.14.234B7E1
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf13.hostedemail.com (Postfix) with ESMTP id 49DF12000E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:35:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="VJyeBeG/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775640953; a=rsa-sha256;
	cv=none;
	b=W4O+uLyMBKDWgzAsfdrF4ROeT0JNxX+j+3NObyUaRaTd1O9SVRl8Uem1dExTxg+ee2LeGI
	+gpy2boFdcoej65Uz4ynabEFD+FoXg+ZxR2mvplqel3RZyEyJEtU579HrTPyXEMJcZ1VI1
	JrJ015CNBdTB8e1UftNkVauqotRNXUw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="VJyeBeG/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775640953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KF+ygKPysPZEijop9aZpkM2S8G/o+N1c3ydLA/xl4hU=;
	b=tX6ebWREbgdpzHmFEZBX5ME7TTd5NbDWVqpFQ0FI5iQYholvI/wFGowOdtotmyfvPC28F2
	x4Ottz2ZHzPARIlFNAd/N7oJui0IxpmXzJy1mu4WemtHCgo+WkeoD4MavJ35EvT7MB6BBx
	9Qh4csOydfjrcNaMzzN19QpyskEB+BM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775640951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KF+ygKPysPZEijop9aZpkM2S8G/o+N1c3ydLA/xl4hU=;
	b=VJyeBeG/o3ABOAAOFKj2J05D8RehmzpjrGtOy6/U0W9jkcNrLPOk8vgGXR2EsxoCsDjDGm
	OOilFkbYXvSsAn/BMUnOXXKwbL2yTN2L6zJyuAl51/nVYTeOxjcELa2OBOZt8h0sDbpBoA
	g6bpg8/5t6ZLsy2MuLAYOQD700jChjU=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/khugepaged: use round_{up,down}() for PMD alignment in madvise_collapse()
Date: Wed,  8 Apr 2026 17:35:33 +0800
Message-ID: <20260408093534.2373007-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 99y5st576z9gn5rjpbwq7iupbqk8fog6
X-Rspamd-Queue-Id: 49DF12000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775640953-593064
X-HE-Meta: U2FsdGVkX1+F5LqoM6Q9SbFcwY5uKgixdysOIqFVdQePXq2aloS/HAEfnvDrCLQCof11kWXg40MSsWA78nFcv3Qvh/ORZQ1DgEKBev6uGJ2CFc3vaUPqEKKk7fTihJ6ikwDJXsGMLvnIFXQLEji8Wevc6wkW68I8B/NrusN0gr5RU3LutLks+uhucwNuEQQCUrSNwwsuuiIhqN9zQPyJFWEk+jz9sMpXakfn6Hkm5RH+XQlratFOxvR273I8RYfKsnZFVOgnBvvlIeBfCa5JEFNH80foheSi3299/fjtiKJwoHB3+6AYd/wax4lt/5lXTRa4RqK3z4ykJwz4Ou0Vo71aP00dL2tsKJ+NPp5sfcdmymw9zwoTOlW2TTYgDAZCnHt9nO77lr1NgMGmmzxjQfIgM7/zxMXx+H/gBJvE2A39tPPcbsHzYvcYky/u6IKQghzpyKcCN1ZGypXqAean+yNJRK8gzlwWMAUj4RoW1SidOQSovoV91jFvbIi0ei/1AboDxikxodejqkfwsggtRcK4c7JC0H9GHj+J+HPN1hpj4pLpTIcoLyiofkegWNkbaUGpnsHL6ElNsO75HzMdElEmt2GgO8NbLqh3A1Oyz24KQzJnQOfpfB423ZdeSRNwZ/CRK2inp4ddg/ORwolHzYz0II65cGBogo1Xr4G7zeEBaNT9+rzxp+CQRQjUckFe4Y66uHAAVi2BPou4KyrmWT2EmSVWc6W442IrmWzsZvPKTCgtkEwXUnXXSZKvbU1cF0q7J12XwnXgk6fUu9Uwl/5oESNiSKgOZB0T9LRSwg3ISVdiONyvkVXmPshxlGwZfsOWd6+xvbyoqmNZOGWqDm4fJl9E+PlfzXUsrDs/MKgIn1HBr3Kw/nMnUuXMQSD252ZzSprqChf8kj8DB5hF2yZvkfcS4XzYjSNgGUC7rVsQQWXlt04f1hNdvVO+csOH+OADYeXFBCXBpAGhFnb
 eHAL2TbQ
 6FXyX/62N0dADMjZeeUMZ3BnlF5nNy+GV+34P7J5r3aTFBH2mqkYZGy3NZ88GcLOsyXZF50uVd7RNz+X9bir5U6B6BNGffSoPP6TqoqRkHy+Dyz3y1cl1DiRU7X+tdlm7eB9FdPWytPrZLKgNWVWXh2owrFe9dJaUl+LG4dxV3Ssj6Cd3aa1jCE3e98qeDhsfzu3W9X1Hv1vLAGslU0f7f+5g1g99zrXqUJ6bTo+BDLkwcNFA4JKGTkPhRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

The PMD alignment in madvise_collapse() is currently implemented
using open-coded bitmask operations:

    (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK
    end & HPAGE_PMD_MASK

Replace them with round_up() and round_down(), which express the
same alignment semantics more directly and match other PMD-alignment
code paths in khugepaged.

No functional change intended.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/khugepaged.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1e2bff40d014..80d0b7136b58 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2835,8 +2835,8 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	mmgrab(mm);
 	lru_add_drain_all();
 
-	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
-	hend = end & HPAGE_PMD_MASK;
+	hstart = round_up(start, HPAGE_PMD_SIZE);
+	hend = round_down(end, HPAGE_PMD_SIZE);
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
-- 
2.43.0


