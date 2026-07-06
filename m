Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55A5EC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B5F06B00C0; Mon,  6 Jul 2026 09:39:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03FDC6B00C5; Mon,  6 Jul 2026 09:39:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E49446B00C6; Mon,  6 Jul 2026 09:39:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B44BC6B00C0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:39:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1896A12041E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:39:19 +0000 (UTC)
X-FDA: 84958458438.29.7FC089C
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8EB8812000B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:39:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf29.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783345157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=OvV5ow51uPJ6r2q/FROYBbfOzEtS6k78XKyueIsIoh8=;
	b=VfFZHk3hFOmMit3VoIYRMI8p5USgBYPBFoONTK4NkFedq7wsdwxou4Gm6TMfSANGh2eUzK
	a+BkhEv9dODwS6BKfbsKtZkKX1O9Yatgotmdjo2n0PJzeyz3b2qS9j37u/nZ++okUrDP54
	qoZXt4EduYeTwEW0W1CNaYDHiDuTcaE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf29.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783345157;
	b=DEmkCjsb1Bhz8NoJpOiisnrYBWEPj5wziMLbe0b/UoSfv9zh1yuxCLnyX5rcV1VTz4WnkG
	C4MTq6M3+0JSIGJfWMvK5TiyEtGkuFgt30n+R1rU2ja8A8VG33dK0GTHXqwqahPcUzOuVr
	gaVOmJUbrMNHYniaEDY6u3gjMnJC1jA=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gv575104nz8Xrrf;
	Mon, 06 Jul 2026 21:39:13 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 666Dd6NH053071;
	Mon, 6 Jul 2026 21:39:06 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 6 Jul 2026 21:39:09 +0800 (CST)
X-Zmail-TransId: 2afa6a4baffdae5-7d49b
X-Mailer: Zmail v1.0
Message-ID: <202607062139095043SOsLi6TIf403tcjPf8fm@zte.com.cn>
Date: Mon, 6 Jul 2026 21:39:09 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>
Cc: <hao.li@linux.dev>, <cl@gentwo.org>, <rientjes@google.com>,
        <roman.gushchin@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhang.run@zte.com.cn>,
        <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYyXSBtbS9zbHViOiBmaXggbG9zdCBsb2NhbCBvYmplY3RzIHdoZW4gYnVsayByZW1vdGUgZnJlZSBiYXRjaCBmaWxscw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 666Dd6NH053071
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 06 Jul 2026 21:39:13 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4BB001.000/4gv575104nz8Xrrf
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8EB8812000B
X-Stat-Signature: zxfpp7srw1p5ocxrb5m9zzr7mz58cgiu
X-Rspam-User: 
X-HE-Tag: 1783345156-913236
X-HE-Meta: U2FsdGVkX1/o+QOk+d3PZXDeoijiq/Ja6VuJr+7pQo409IxuUAFxFsQfg0bepP1OSwJKLGLIMBywFDl6QG/qjCXUlj5h6a+X1IUQfJ0s8X22GQxiiZuH+/ayrl7yAhf3d/ZWGZcyfNjWLPaqP7D3IWEi0sWTC+QyHKgWOsdo5xyh1w5YMynBqmsadFRzpyy86TLaCYk/+0epulMITI8sXHh3mR/q4BKTMbiWKqEo6E6QzpXRrHD30M+VHUwH7aEJ6y5itISnCIGlVRtHGnEvMWprmxr3FVd50nEwVgd62xUUxfbA/0dTvRQACGbv1hjWxG4oLx20o/8gvkdJkXk4o37I/inUPIcx4DFnzUSpYs6nhGPRuQ1jwuyYnpbo2/PNs4Ptp/Pd3soJQxnbIIr0j2Eknjm3hOF565gBhXni/al3+WGIFsE8NmYMKi+TZcrKqYICKPIkm95O1Xj9G+HLGcdqLUOH7G/v7yblYvdgQL9jdzugOt4YLQJ9VYPkbXqT4tP3GX/Y/V3V9lWXza09pbRd/sk/cDdS4ezRguzWu5SdC6S2JG8EyuXWxLd2ckVH3mdsIEndFdD0CDBLFFV0zKKT3WC8H6hKUlOHI5HK8ooOdPwCvD9rqVs4jjGR9Wv/NjmqAW8YlPta2WPcvMvok3rBe2N9JhUKr0v4DWzsUip/kY2kR/Zj5uLaoYG+8efRUpk5W9aR0y2zqW52V5LxEur6xKsqt+Axc3g4sL8BrvrTegPfmMFS6Uq/Bf3rU9rjCLJz7EsuXgdiqWlXEJgrr/1S39ZYV2N9g5B2qJoQRgXOOVkE+AdyPEf03HMTUrM8ARdAISJGO0U/vRAIP5u7ffYpysAp42HRLbUs72QG2rLNFjrdG93srz1yJTVYNKIVEGOX/Xe4cb/N/+MKUg8Og+Ejr/qlNCfU82Eu1DjaXGdTgiA1UNhVIJuf0sJjnPwcNBsKAsGkKd7Azg36JPn
 21kqgZfW
 QLJh0vuv11/HVDMKIayrdvPrj7+YSeX68duxK1VKgdIO5TTJcYPamK3fl4Y8cjnpwuo8G/sUNZw8np1er0L3hcXvTAivvPDLrhn28t/56XKBa7WDgZ32rFOKdADr78Vv84WY1x9kzGSMNrQnilnO8sQlx3D+9cphqxK28ImREkkvG14L1D4FS3mEd6gJQmFH+1P/SkkczfbOjvuVQq8Mmj+8kHQn3E0VK4QTwQkXGbswBZ0kjLpojMVplaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shengming Hu <hu.shengming@zte.com.cn>

In free_to_pcs_bulk(), when remote_objects[] fills to PCS_BATCH_MAX,
the code jumps to flush_remote to free the batch. If all remote entries
have already been compacted out of p[] via tail swaps while local objects
remain, the flush_remote path returns early since `i < size` no longer
holds. The leftover local objects are then neither cached in the sheaf 
nor returned to the slab freelist, causing a memory leak.

For illustration:
 size = 64, local objects at p[0..31], remote objects at p[32..63]
 After scanning all remotes: i = 32, size = 32
 p[0..31] local objects are dropped.

Harry pointed out that, although the logic contains a real leak, it does
not appear to be triggerable with the current in-tree users. To hit this
path, at least PCS_BATCH_MAX objects, currently hardcoded to 32, need to
be collected in remote_objects[]. Looking at current kmem_cache_free_bulk()
users:

* maple_node has sheaf_capacity = 32
* skbuff_head_cache has sheaf_capacity = 28
* panthor and msm drivers have sheaf_capacity = 4

The sheaf capacity is, at least for now, derived purely from the object
size, with the user-requested capacity used as a minimum. Therefore, among
the current users, only maple_node has a sheaf_capacity large enough to
reach PCS_BATCH_MAX.

However, for the bug to trigger in maple_node, all objects in the sheaf
would have to be from remote nodes. In that case, there would be no local
objects left to leak. So this issue was found by code review rather than
from a runtime report, and it does not seem to be triggerable by current
users.

Still, the bug could become reachable with future users, a different sheaf
capacity, or a change to PCS_BATCH_MAX. Fix the logic by freeing a full
remote batch in place during the scan and then continuing to process the
compacted array. This keeps all local objects on the normal fast path,
while the tail path only handles any leftover partial remote batch. The
redundant next_remote_batch jump label is removed as well.

Fixes: <989b09b73978>("slab: skip percpu sheaves for remote object freeing")
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
---
Changes in v2:
- Incorporate Harry's detailed trigger condition analysis (thanks Harry)
- Link to v1: https://lore.kernel.org/linux-mm/20260704160450302fnznThT3hBeBiwlhE-oGv@zte.com.cn/

---
 mm/slub.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 9f754cf1c187..4d7e3067a5d6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6193,7 +6193,6 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 	void *remote_objects[PCS_BATCH_MAX];
 	unsigned int remote_nr = 0;

-next_remote_batch:
 	while (i < size) {
 		struct slab *slab = virt_to_slab(p[i]);

@@ -6208,8 +6207,11 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		if (unlikely(!can_free_to_pcs(slab))) {
 			remote_objects[remote_nr] = p[i];
 			p[i] = p[--size];
-			if (++remote_nr >= PCS_BATCH_MAX)
-				goto flush_remote;
+			if (++remote_nr >= PCS_BATCH_MAX) {
+				__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
+				stat_add(s, FREE_SLOWPATH, remote_nr);
+				remote_nr = 0;
+			}
 			continue;
 		}

@@ -6293,10 +6295,6 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 	if (remote_nr) {
 		__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
 		stat_add(s, FREE_SLOWPATH, remote_nr);
-		if (i < size) {
-			remote_nr = 0;
-			goto next_remote_batch;
-		}
 	}
 }

-- 
2.25.1

