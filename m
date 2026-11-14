Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1A18606A89B
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 16:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=Ib3WR+2g
Received: by kanga.kvack.org (Postfix)
	id 421996B05B1; Sat, 14 Nov 2026 11:47:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D2596B05B2; Sat, 14 Nov 2026 11:47:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 310066B05B3; Sat, 14 Nov 2026 11:47:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAAAF6B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:47:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7BC38140413
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:47:11 +0000 (UTC)
X-FDA: 85434304662.22.1587995
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7B7461C0007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:47:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=Ib3WR+2g;
	spf=pass (imf20.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794674829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3LuBfwrsNMEmaxatdcww0jyj29nzn1W/PMAS+hcYzQQ=;
	b=Ti4mu3Wx/8FUkhib0K9p0yixroGiOd2sRXRNTH6QO9xYaZT8SJRUjRz1kh3tv7OQAwsZQw
	as7xh72vfivMiWXG4oAiPgsfLV4YNjOMi98J5T9bNyJ1h/84VWqvFfdm6lxIo8Y5wpEzAV
	aq+1oY3ksXMqlHCkstjqitvB0tfche4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794674829;
	b=YmwLLzx0xx6grEOmhs4wK2yMQnf08cmtrZ0JWKEav+qpP3OPEOONlz+ELnRYC36klgTwiT
	vXm0pRMwXNvnZXMwbg5c3JX+7pz6yn+lnk0exJtPgiGpA6ak5/bClSIJfFwwbj7ypry2hy
	HDu9Ot0qVT1Xix0+US1nV75rj0wOgHE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=Ib3WR+2g;
	spf=pass (imf20.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jRg5M70DSz8XrrJ;
	Sun, 15 Nov 2026 00:47:03 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1794674824;
	bh=V7A2yyFE7wnSjeZEJxHslp4jPPbaHPv0vPxXAMZMgLs=;
	h=Date:From:To:Cc:Subject;
	b=Ib3WR+2gr/7rSbP9L7eduEl1nvz2FLrNgu5CqNXBEQRords0YIIRQAZAd8t1c6pgl
	 L14voEHkFAvIkctcG+5Ai/+txc8ZyxViXYFuZaJUa5OgXT8yK0mfKLGMkcZoRD3fe7
	 ui/ftW7BJDvvksVW+8LUJkm1qqVu1M6D1Rz22siVQNvYFZZWN11oPe3p7kluBFxOrh
	 /bJBnqjO6PYgj8L5QBs2sVH5Mp3OXeaXN7Kffq61nr9FUxyP1Z8vsYE41IVVyBni2l
	 OWHwwf7r4AjzyqqG8yq4hkPa2L4WDBH2uw8Vmp/vnzbRb9Q5lTiK6A5ZF7kyfaUJIQ
	 NMXPDpzccWfNw==
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 6AEGkr7a089513;
	Sun, 15 Nov 2026 00:46:53 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 15 Nov 2026 00:46:55 +0800 (CST)
X-Zmail-TransId: 2afc6af8907f77b-3074b
X-Mailer: Zmail v1.0
Message-ID: <20261115004655564ix3vefI54RZ3HhYOmxuKX@zte.com.cn>
Date: Sun, 15 Nov 2026 00:46:55 +0800 (CST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <akpm@linux-foundation.org>, <liam@infradead.org>, <ljs@kernel.org>
Cc: <linux-mm@kvack.org>, <vbabka@kernel.org>, <jannh@google.com>,
        <pfalcato@suse.de>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBtbS92bWE6IHJlc3RvcmUgVk1BIGl0ZXJhdG9yIG9uIGZ1bGwtcmFuZ2UgbWVyZ2UgZmFpbHVyZQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6AEGkr7a089513
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sun, 15 Nov 2026 00:47:04 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF89087.000/4jRg5M70DSz8XrrJ
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7B7461C0007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: ajak37hweb5k6u6rou9ty7oi8ssmi1s5
X-Rspam-User: 
X-HE-Tag: 1794674828-615107
X-HE-Meta: U2FsdGVkX1/r2dDezrCtjrgn+7kUhl84k8x+nenchN03+5e0XeWO9X/pSPJySEcRBBVfDYWL9BH7vzQSpgnw0TwRyEXFAZ5bThlIulB/MMrEKkwrgr6o34Y0WJG9Uy02Q8Ya9hlK+alSHmDKHYOC/TLI0xo1PtPGdd1kwNt6SQnM2kmmKEkFYdlrLocfWajW62HiIZaDE75xrFDTGZ4dhaaEaD9MvfFmiB1ViqDM5ZJpNnTpp2Py41X+YjUN+Q367nEiZ9kUaNiuXs/rjfSdEkCkkIUo4U0sU3GbFO7R/nbsvZk3P65zHtypMc/ohoX3hwjr3CWmRpDF4xsOi/gk5giWxz2Qfx84WnaCvFVGRqNgSfRR7wrr7W14LGt+8Aooo5k0szH7JRlgGgssLDRQ6G/0snj1ojCIxsvwcUVy9rQwhyj9xhhSRctQn8XwqTeW1KzYNiUrQo+AwNPxEKj5PhieGOcwFVH5ZJIlKcLI+g/0SCIBLcg1P4ZNAY5MpVdYFp/YkfnJYSsLP8U6dtDToj0shBh/2k/8pIspGLVmopHs0K2P1plOmA9d0KWAaDHO42h4yN4V2V7hQPchqzH67tVg5cC0+lbJwJcVUXS+Re06hlMNdLkUOmeEqFclgamCZfvz4ZuKOc+Yq+NB89MCdo6DB8O4aN4FYA2ZLbt+f4KIG+yH7zi3xmpDMRoUxRFaU1Q4rQf+6Ua33oyrVkX24W/hSxvyRllsPBIqzMhnEmC5M9IZ4hSePs/0nHwQJ1IkBz8lykwpWozHq9Cn8NTveHUtAQBrJuAySiJaZLWDidhFDxcOqr+qA00R1zSZ0B3QB9JQAKzB/Cieus28AqgnxlPEZKA9lCDofZK2UUuujmnk7kNvOITgRa4jVZ5sszGwTIM2/+JpM1WXNk8Rg0kxWvcogfSo59y/hImFbF8KR2OpOGWPd9AxSHfdbgLv3wQB7XstXys3Osr7oS9oPqm
 VhpdVDRl
 vFz9RZhbcURq8dfKdpDiJ4767x0uLjgQu/nWsBHZUmpjOu+eatSRD683a7PoVCoE0paEoaj37Ubs3qJzzmY1HJ/JGslMJK/jtuaCzqgKVeLwXTlFS/L9s7es4yVMl7yRH5ITOVFiDkVasnKu9s9nSTdZ5j23eHM5Ax9NLf3MHHymRxF0qfaBaNkfekXSuBjMZfgABVlA1/T6ITDnx2hSGm4lohe1DPVBvyxKj9jG15f6gNdcUW9Crg/aW36tt1IJjzTIit8RUsitvZBT5U9giZHu8kYeDE2vngUEKevVI9Y06ygXyU4MauZEZUui6wD2xfeQr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Shao Mingyin <shao.mingyin@zte.com.cn>

mm/vma: restore VMA iterator on full-range merge failure

vma_merge_existing_range() moves the iterator to the previous VMA when
merging to the left. If the range spans the whole middle VMA and a
vm_ops->close() hook prevents removing it, the function returns without
restoring the iterator.

An mprotect() walk can then visit the middle VMA again. Restore the
iterator to the range start, as the abort path already does. Extend the
existing close-hook merge test to check the iterator after this failure.
No crash or data corruption has been observed in this case.

Fixes: 01c373e9a5ce2 ("mm: rework vm_ops->close() handling on VMA merge")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
Tested with tools/testing/vma using its default ASan/UBSan options.
The added iterator assertion fails before the fix; all 29 tests pass
with the fix. Also build-tested mm/vma.o with W=1 on x86_64.
This verifies iterator position, not a crash or a production workload.


 mm/vma.c                        | 5 ++++-
 tools/testing/vma/tests/merge.c | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/vma.c b/mm/vma.c
index c82e9306b11ac14f684f44b8d71a0026b7fc145c..c87b29f1beec4ceb02c23f6b37af0e5dff272436 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -983,8 +983,11 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	 * If we need to remove middle in its entirety but are unable to do so,
 	 * we have no sensible recourse but to abort the merge.
 	 */
-	if (vmg->__remove_middle && !can_merge_remove_vma(middle))
+	if (vmg->__remove_middle && !can_merge_remove_vma(middle)) {
+		vma_iter_set(vmg->vmi, start);
+		vma_iter_load(vmg->vmi);
 		return NULL;
+	}
 
 	/* If middle isn't removed then it's resized, i.e. splits. */
 	if (!vmg->__remove_middle && check_split(middle, left_side ? end : start))
diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index b26f1a66a17074775d751a907eb627445cc1dda3..91accb5dc9944724cd11d1bfa47484a3cf9df54c 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -680,6 +680,7 @@ static bool test_vma_merge_with_close(void)
 	 */
 	ASSERT_EQ(merge_existing(&vmg), NULL);
 	ASSERT_EQ(vmg.state, VMA_MERGE_NOMERGE);
+	ASSERT_EQ(vma_iter_addr(&vmi), 0x3000);
 
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 2);
 

base-commit: 84abb955b1015477aa11a96e2f3ac1b938b77f48
-- 
2.43.0

