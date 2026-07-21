Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1B8CC44520
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 00:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89D4A6B007B; Mon, 20 Jul 2026 20:45:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84E896B008A; Mon, 20 Jul 2026 20:45:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73F3B6B008C; Mon, 20 Jul 2026 20:45:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43C916B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:45:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A13D840326
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:45:32 +0000 (UTC)
X-FDA: 85010940504.22.5A61151
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf30.hostedemail.com (Postfix) with ESMTP id 16A2B80004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:45:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784594730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=PeLnXTEuH3XSt9W3LvBQqjGopcyWFN1yhaf5Phqf00c=;
	b=EHrQ5lYXBErWahdt1VqAkoJJA0TPi8l2x59gYXJZrUMcS+Upup8XgzKYGGG48zpcvn2E9Y
	9LPz+g8fnyyUGhZzhi/FoCDRf0LyyFYVav/i0O4HaPJ9A7+q2qBCRMxhCSNKQhxXQuMSFR
	Y43VkW8SkprWDy6DRuZoyAWXmEnRFbQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784594730;
	b=tpCLKEVjwixPTgKrCe2bpXDnUyV5eoDngvIVbYfuPjMqhCasRL+lc/nIjZKK+61LCE9Hfc
	jEKOV46pkQhkZpISW9j20iSh7KIHGv3RPnTXHXBT/dr1ddUKcRMSQTXTvdTCARS4JD+YgK
	lXZ0f+JwSp1CYVLp+YH14lS7G+ck9BQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4h3zFM0Pngz8XrrZ;
	Tue, 21 Jul 2026 08:45:27 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 66L0jL4S040046;
	Tue, 21 Jul 2026 08:45:21 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 21 Jul 2026 08:45:22 +0800 (CST)
X-Zmail-TransId: 2afb6a5ec12210e-88f0e
X-Mailer: Zmail v1.0
Message-ID: <20260721084522552ZPa16p1SRj3PYat3sqxuN@zte.com.cn>
Date: Tue, 21 Jul 2026 08:45:22 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>
Cc: <hao.li@linux.dev>, <cl@gentwo.org>, <rientjes@google.com>,
        <roman.gushchin@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhang.run@zte.com.cn>,
        <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYzXSBtbS9zbHViOiBwcmV2ZW50IHBmbWVtYWxsb2Mgb2JqZWN0cyBmcm9tIGVudGVyaW5nIHRoZSBiYXJu?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66L0jL4S040046
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 21 Jul 2026 08:45:27 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A5EC127.000/4h3zFM0Pngz8XrrZ
X-Rspamd-Queue-Id: 16A2B80004
X-Stat-Signature: 6k3b4sggqf5z19xf3s759adfwk9bhj4x
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784594729-992828
X-HE-Meta: U2FsdGVkX18Qyv7QB4cA35sJStMRx3cHkRdDqQ77PLGD/Lr2Ivv3iAgywvRWXXXud9L84r8HYi6b/loFdL5uKHam4pV2MRI1UhK2rJ9esiH1wH+faCXob+ZXrfdADYEKtyGkAwo1LUpdJSV2XjQpuyzd+XjzrIrDBljB9yKJL8eSE16MfmuT17ruvnc4WnzGGMIzp6OYzmfljTbnxD2tF/6OEaT7xFsGeaD3pkVP8lAob1vX+KnxvZMfVrhW2EHECfB/92isFComjHn0AO3DqoMhDd1Cvl8ZqAsffwinFyZH1y94N2XaZnG8O0zHe7EivyXqdr8E2JjugUPUhCnOpZGtZkREcYKUiiufKywJotw8G6OlXtS1FXFsEdiCD+UcqfCAtJq+P5ryN9SQtW3B/mAxUmanJjXcyY8XH1X93euapxQ6tzSPARdvK+NgYZ7SwHtcF4EaR9WqiDniGMu1KWYHzNPf7bBWivIYxpgjVVLKmU2iTyGEMDgxPG9/xhE/WEpY/wbSVCpjUGgCKrromvLBOQjUxMVIREvIlAzcsGR3Jh20FD3IM9ZyQQW1QgdbiiZS9MXdn4hnDjADj6918IPbjjqcVy5X5GPHPy1rJrMV1cM3IHOSuFuyRAkxeI+zitWLRJLxGyiVTOE1JCgnwGFZZdTcImQC9ngxheP/luu4H6uRRlrfcUTaAhhmjNMWlSquScfII0S/+ivA3KpYnZ6GbKV+eyvApbpTLSvzolJ8YCHCb3BPHPPgdfLdcl51ktKMYr3bejKlE0O7lKWfgvdA8uEKjU6PU4RbdE8+fa9PIbGt0pwkg+kd7TNr3MtqvI/kdrLwnb4c5sIxM68HkSc88GUgsHD+eFMxeqhv/KugpIjpVN39DMKc9yHpqqyC2vSdVANpuNplYZGocnSJNqnJvpOCoRyFhfLbL5YO4mF6f/GunocESYFoRVrqzGC++RuMLgLXSKScbuGmT7v
 buAVOu00
 Tbp1RNKbPMs2kO82bT0yCEjrGJo58n+SWaOavyArY2j5Ycl8QkBQ7DrVoLH36dxn2mWIR++fG+GhYhQ3zf311uC/xdb5Ux8u6uVDPso72piUFqffVoyx847I/s1Mbvj4ubFJI4jvickbAGQdAq9cpn12pxPrBv5GTCaKMZIoDJQj+O4Mgf8rT/YtDN1Vli4EvEhWJ+JzSb3r6HfLlaHW7P+SX/yaY4roLujj5Nxqq3Yu6f1YzECT2003ZuSwr6mSxVFyUT24719OXy8WnlQJmSlJJvAyK7orMv00BGEgF36Qt4i8ZSbH/yddyPmxbpfoS0zsA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shengming Hu <hu.shengming@zte.com.cn>

kmem_cache_return_sheaf() may refill a partially consumed sheaf before
placing it in the barn. Without an explicit restriction, this refill may
draw objects from pfmemalloc slabs and consume emergency reserves.

Add __GFP_NOMEMALLOC so that returned sheaves are refilled only from
non-pfmemalloc slabs. Also add __GFP_NOWARN, as suggested by Hao Li,
because this refill is a best-effort attempt and failure is acceptable.
If the refill fails, flush and free the sheaf instead.

Fixes: 3c1ea5c5019f ("slab: sheaf prefilling for guaranteed allocations")
Cc: stable@vger.kernel.org
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
---
Changes in v3:
- Replace “normal memory” with the more precise “non-pfmemalloc slabs”,
  and add Fixes: and Cc: stable@vger.kernel.org, as suggested by Harry.
- Link to v2: https://lore.kernel.org/all/20260720211127124sYtTNbvsxCXN9_pDh-pwt@zte.com.cn/

Changes in v2:
- Add __GFP_NOWARN as suggested by Hao.
- Link to v1: https://lore.kernel.org/all/20260719113701797vZ3R8NxiqYt8dEfeUxtON@zte.com.cn/

---
 mm/slub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 53b4976d3831..357b7522c817 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5123,7 +5123,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 	 * simply flush and free it.
 	 */
 	if (!barn || data_race(barn->nr_full) >= MAX_FULL_SHEAVES ||
-	    refill_sheaf(s, sheaf, gfp)) {
+	    refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
 		sheaf_flush_unused(s, sheaf);
 		free_empty_sheaf(s, sheaf);
 		return;
-- 
2.25.1

