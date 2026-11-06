Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B781606A33D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pJrwF2pq
Received: by kanga.kvack.org (Postfix)
	id AF65B6B05B6; Fri,  6 Nov 2026 05:06:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACE646B05B9; Fri,  6 Nov 2026 05:06:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A696B05BC; Fri,  6 Nov 2026 05:06:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 746426B05B6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:06:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50E1CC0CF8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:06:02 +0000 (UTC)
X-FDA: 85404263364.01.2B130D9
Received: from mta0.migadu.com (out-115.mta0.migadu.com [91.218.175.115])
	by imf28.hostedemail.com (Postfix) with ESMTP id 612E5C0003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:06:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pJrwF2pq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793959560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7FWvjRm5VHt/o3Fu51zLztgQLTfGfWw2bGFo45jXROo=;
	b=nLQSwI7u3iOJGElK2zfh1pU88mcgtCsukacw6WsGl/FmSDgtWwFKpGaj/L+fo271bpC8sp
	XbQJm8sQxnbSTAMguBb/ce954ePM2mjAgWcch36MXQgh+UTUrmTO0eXMp3yOk2UUgcXXFh
	R6++qfTLGtpxpOwt7sut5PcGjJDSxCE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pJrwF2pq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793959560;
	b=y0FnqpGMw/y9EwRPviAUvPffl3w4kAyacl93hj4fq74KhV+o17zQ40cHX1vphgzRkUGJqA
	8/iolM3iIxNXNxsHzTQXTI4+fDWKGumhryiuXOBuEC3DCYRspT83Jc6tH85cSgsJ2laly+
	Y11o9D4MsHNZqkESyMUmVkmAnMEYTP8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gmhp/zhGP3DAO+86b4RAlsAtIQ84L/beRI6uM3dmLu4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793959559; v=1; x=1794564359;
 b=pJrwF2pqbjdw01C/gZ2ueKzvCk+VjkI6WCrAjOe966atQmcFeQ5qTY83Ko/GNz69lvpZ1dZ9
 s/XbXa8Ooy0luIOXcSZ8j+KGPwSltxDFf0p++OS8HmXbnmmVmS7KC2PNmNKgvzxSiz7g2tkGP6t
 vuudGTR3+4arUemMHnTriZz8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a67021b1b9df2a3e;
	Fri, 06 Nov 2026 10:05:58 +0000
X-Mizu-Trace-ID: a67021b1b9df2a3e
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>,
	Zi Yan <ziy@nvidia.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Chris Down <chris@chrisdown.name>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v3 1/4] mm/hugetlb_cma: fix incorrect hugetlb_cma_size assignment on malformed input
Date: Fri,  6 Nov 2026 18:05:18 +0800
Message-ID: <20261106100521.30099-2-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261106100521.30099-1-kaitao.cheng@linux.dev>
References: <20261106100521.30099-1-kaitao.cheng@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 612E5C0003
X-Stat-Signature: x4s5cczb89p4ami8ssmkhr4eqzq8ujrs
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793959560-423527
X-HE-Meta: U2FsdGVkX1/Z2xmokf5I/WiX0NQQ9cjYWYkL+X4RdUAI16QFHVaDUBmLYZ9OVyK7P40TOaksEzQF0IfsNhgVJSNcbzHyoEXdaDwt0UHOWoAq5qNcPhH5eNHtTehPhSou2c+IEXxf5Su1pLLDaN+WyL6vUVouOGkQF6rD2HXnrVzTazSboUyRrNHRkr+tQTEMiQURUxUCN+oONvOXOECGKtZzJtFPQiXbsi6/rpzlzZDoRPrnRwoaDG2j+pzTtIb2Z72QvOjefNGrTpnTkN9nxHIhK/Q2unhIhn9TcjukurDK9VcLES57ypsJLOZmu0NjA0KONXvBN4nQtKjDAAHEEO/Os7nQoVV02ZkTTLen7FejilaeaVuWs5Gm1fSVdQLch4tRI//nBS3ewOEyphs71P9QfkX9qZaMyjIeboLrvNzmHPXvL4w4vzt4iPenrd8iRoqaZvlloe6sECyaJ+T4jgAZVOStlCtxu3D5xLbGslDV1lWJ60wwVE86QbUJqqaGnjLQtdL8Lg2Vk3nxRDKFm6QIpR8DaV0NAPswxkzgvMDZOXXZ9bQQX38u64i5VFrQOXC+X+TaKpF8gRQTKeQ59JJzUuLWK5/3C+nMMrkI4bcKcprQqPDviAAEtuoXHFYjUkXv2UCCsgzxvJOZ7YYUoIiFXgn/BHkNbNZe8ZmaL5jEwZ9P5QtiH1IoVSwdDS+G2nG1An/k5NU2v00WAJr/2cqDIWCEt4klxsDCccy3oQBKEqQEPdUf6SxiKeEXxFyrVCIroz5iK3EmRrXug+mZvS7eOiFBhWFandnFLL6dheAlqJ3aFeFt2ROLeidF2/yZTfb4bEaWkQB/wgQyV8ZOxTD+AtZ45ibZEd9MW/5BLA34z/Alx2UqAVelOuhHtMoWTxlgFC/aKeCiaRG8fFIJweP9JGBDjBb/DTV/ou4XFGNuJvigH1Ln8upNkN2K07gIXhPIpxojktkeSs9jKvQ
 TmQb7uWq
 rwjGPiXyfTnqS/rh0lw2aEr7Fy+hqLb82dEIJVzBV7vYBTKFZb7z8HbdswG0Pvma1kNV9Y9M7KO0mTCSd1Yo04bIqaLH9UDdCmPqyGZTAQ/hw8nil5NEl1CsFrqDB14li77H40/3Dv+0WUorA/rT3WiFut9QZk08l0x6lC7FwEn5vRTd/wLrHYN8ZyY3wA2gITtfn0Eb/hQptwjWsRxsRz/6+ePPrds6Mkml0LwhbQQrqB28qSmRQ2s8Vdo9rj+Z2MsuJD8bC/x6zSJJOlPCP0dKLN6bO2vULSUi3NgnGJJwjDOzbF4furxq1usLT2CUtCRAeX3zUh18i9MqGrTrVI59WLLxeRS6r1kFjVw8D9voT/+hN8npsQywvvolVg+Hcp3EKf03qNOEsrcTEQdPtzSuni26DsaB4RNyL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kaitao Cheng <chengkaitao@kylinos.cn>

When hugetlb_cma contains a global size after node-specific entries,
cmdline_parse_hugetlb_cma() enters the global branch and reparses the
original parameter string. For hugetlb_cma=1:2G,4G, this interprets the
initial node ID as a one-byte global size and clears the 2 GiB reservation
recorded for node 1.

Global and node-specific formats cannot be mixed. Return -EINVAL when a
global entry follows a node-specific entry, before updating any settings.
This preserves the valid prefix, so the example retains node 1's 2 GiB
reservation and reports the malformed option.

Fixes: 38e719ab2673 ("hugetlb: support node specified when using cma for gigantic hugepages")
Closes: https://sashiko.dev/#/bug/linux-10f40d3e-3feb-4622-9da8-1fedecb2d0e2
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/hugetlb_cma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 80b2407e9f07..cd6a64986278 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -165,6 +165,9 @@ static int __init cmdline_parse_hugetlb_cma(char *p)
 		} else {
 			char *next;
 
+			if (s != p)
+				return -EINVAL;
+
 			tmp = memparse(p, &next);
 			if (*next == '%') {
 				if (tmp > 100) {
-- 
2.53.0


