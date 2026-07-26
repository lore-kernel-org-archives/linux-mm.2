Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D65FC531D0
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 01:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEAF56B0088; Sat, 25 Jul 2026 21:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9BB16B008C; Sat, 25 Jul 2026 21:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4316B0093; Sat, 25 Jul 2026 21:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 889266B0088
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:48:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDA91A1487
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 01:48:40 +0000 (UTC)
X-FDA: 85029243600.09.378DD10
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf05.hostedemail.com (Postfix) with ESMTP id BA6A110000A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 01:48:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=KXqdHSQH;
	spf=pass (imf05.hostedemail.com: domain of dayou5941@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=dayou5941@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785030519;
	b=BNTmjucfy4sEe3EVNZ5gkif1FHrjw/2hvrSPDX5ph2I4O3kWp03FPvA2i+MbT8TLGBM4wX
	gQSJRTUWefpzeqk8PKjLjcvr+8e+dVxhXIKQBHFacNk2xim0flm9RBiABJ4uQOUo+/VRCc
	4EPFVyZNBqnduASZPIHwXVM54NgxdJA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=KXqdHSQH;
	spf=pass (imf05.hostedemail.com: domain of dayou5941@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=dayou5941@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785030519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=adku3ZUyolT1/aAV+9p6y7s5z/CUYnjGXtUnLeZtGPk=;
	b=F6zi8LRX5dBnsvgH3S/FZm4q1K8jZYZ6oQG7/aJq+lJKrPeYBQX8xz3nAU3z5ujsiOdXqL
	XaF7rldVp+NiYCp/PbnYLQO5d+3nXAPdzPDzR4CCuamdUfZBDB3yNgRXZ57lGq/GKmBt//
	wkHWZQZ3kj54feMWFtXsIRt7m2mlr8Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ad
	ku3ZUyolT1/aAV+9p6y7s5z/CUYnjGXtUnLeZtGPk=; b=KXqdHSQH3dSnhciUEx
	O1Yo8IFYTnfrT3VJb5lvl/yioTCFqgrLGm1toOfLLOE8bu5Q5lnU0Atrcgn3xqCs
	kaLSn7c2BmTCOaFxWZPZp84iTNAxf+/6SpdXMrwv88HAsyA3+D7qyOV6Hbzkjl2P
	YCToDhIDdT1NWi+jPBPO/Su5g=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wAXbRJhZ2VqI91GKQ--.1854S2;
	Sun, 26 Jul 2026 09:48:18 +0800 (CST)
From: dayou5941@163.com
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	joshua.hahnjy@gmail.com,
	liyouhong <liyouhong@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v3] mm/damon/ops-common: putback folios on invalid migrate nid
Date: Sun, 26 Jul 2026 09:48:15 +0800
Message-Id: <20260726014815.1280757-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXbRJhZ2VqI91GKQ--.1854S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF4UGF4kZryfJry3KF48Zwb_yoW8ur43pr
	1rKa4rC39xtryI93WfXFZYvry0yrW3Jr15GF9xGFs7A3Z8X3409347t3ZF9ay5Jry5Kr4f
	Aa1qyas09F47JrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jwID7UUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC3QPllGplZ2PVYQAA3Q
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BA6A110000A
X-Stat-Signature: usgf47gnqmqzzb5p67o5odzztwz1ufz5
X-Rspam-User: 
X-HE-Tag: 1785030517-240585
X-HE-Meta: U2FsdGVkX1+qDy1DWlk/Jf7MZ4BTpwOXDXTjbknGXOVncR8prQnLcOKUrUFvnwzrukzqmfojRV1z+P7qwUqHMzsGdwCQN/fmRChk7eZt16TNf4VRnYsfvM7MOYtw5dk+CZBAFBBiJeZF8B4Zw+++fPzWGcx/EHD9AFm4LaGO20dZGEVSO/e3Ifa5/Y3YPyudfy1aYYcNtL7KGdWdLSg+7HL121shJ815cCb+rHl9nvvvMgW7TlynsAT1o1t81xef9P8bwriL0JiG6MuQb7SS7hKx5sW/oqkhDJ6pwreCYvGsFSqCIy3VKKs6a5Pd1Sk1PKKCYmeindo+edgQopxTMiBokch4dpV7ckZB5tb0mv4jHEM/b+1ae82DuVg0sq+ywojwx+i+UbI3SSc49rq3XrZ2ujQHrWvQ5SL0wA8AVRWsuKofQkQ1ViLTFKpPPQ2zQNiWnytu1Z8fns1JSHIHygF6Vrh/yNUcxNbj9ZidjLr7BEC+E4mkthiBs58APC8mfdOhQF8n+P2UZeYgRLD8/mzr7Y5IEKHQgf4JkVsnLnnNS9q43sU9C8L1fiz0bVC9hoqLeAGuHpM6mbaS0ny5wkpKD+P4pPUlUT3sad65pdLfif6Cncduqv46BCU/wjfvleuasUh1ai88hLOzjtgCrVG1x3Gh7cRbhutZRuCfP19c+w3AX4SktS4RSBwtXFabfJJNO7cA0/wCwHg/o9xTKnTmhbIzwpfja3Z8W0OLBjvEQi/Wuar93/ds5GKllpg4cyNel798ac2q1e7RPFGof9LmE1yRjDkbZ+kz61/I4qqD4SeQuSC5z0pvGfXL5e+KiLzePsRbHwiLzlSXRAUIaYoH13flPho/wEPcUT7gIVztuNtacS+mJd3f9iiuCt8GKXwaZAF6zaU513hkicCuDAl/K03XRV1fk1J5XFTMZ6TOl6tZEv+SSz0A4xHcBe1/ahrXg+GShYPQ+lqLN+h
 cYpfz+Sg
 /iMIzoowz9rGq0wTHRzOWsuJASBx1vufZWLpC/ZwSseE9PuBfs7LGCMr86JjnYDKXNGa3Nk6F6hmrSzlc+e8Th0AmVTxrVicp1BfvU8O3cwsjF01JQ2lnKtO0ylPoJLAtZ7+fIFEZ7mtp+NGmJ9tvhJ8ppwR3hXGiy7orQKXzDpd9U8Acx7T/vuKc22rVRwsvlfN/rnE13TdM6/cmxXt2pTjzS7TJ57y5PDIqez1t/vQrIRpp+ARheYUAFTKm+GYM3waTb2r5zGaL/NGPKQgDmU54bE2fCc/hdN/qHfrI6tfgtH1w6I2LFIi/bv4pK2jGGkg8lC8aaSBwQSp17x47jUww0u3N5umPPhsH176+BqA7gMNqOZHauC9cle2wis9NuJDP3cFI+m40uw+EIlIkk1mz9Lvbnti0Bul2cuq64r9+aWjSZTDKEc2arjDgofUWGYLyFZYQXg7WbLYHS85/7nrFlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: liyouhong <liyouhong@kylinos.cn>

damon_pa_migrate() and damos_va_migrate() isolate folios into a local list
and then call damon_migrate_pages().  When target_nid is invalid (including
the scheme default NUMA_NO_NODE / -1), damon_migrate_pages() returns early
without putting the folios back to the LRU.

Callers then discard the list head while those folios remain isolated with
an extra reference taken by folio_isolate_lru().  The pages stay off the
LRU for as long as the mapping exists (anon active+inactive counts drop
while RSS does not), and the leftover references can pin the pages after
the mapping is gone.

Put the folios back on the invalid-nid path so ignored migration requests
still return them to the LRU.

Fixes: 7e6c3130690a ("mm/damon/ops-common: ignore migration request to invalid nodes")
Cc: <stable@vger.kernel.org>
Assisted-by: Cursor:grok-4.5
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: liyouhong <liyouhong@kylinos.cn>

---
v3:
- Drop the 2/2 cleanup patch as suggested; keep open-coded putback only

v2:
- Drop the putback helper for easier stable backport
- Open-code putback only on the invalid-nid path
- Keep the original indentation and Cc stable@
- Add a separate cleanup as 2/2 (factor out damon_putback_folio_list)

---
 mm/damon/ops-common.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index d1842e2b00ef..f5ded45fabd1 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -394,8 +394,15 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
 		return nr_migrated;
 
 	if (target_nid < 0 || target_nid >= MAX_NUMNODES ||
-			!node_state(target_nid, N_MEMORY))
+			!node_state(target_nid, N_MEMORY)) {
+		while (!list_empty(folio_list)) {
+			struct folio *folio = lru_to_folio(folio_list);
+
+			list_del(&folio->lru);
+			folio_putback_lru(folio);
+		}
 		return nr_migrated;
+	}
 
 	noreclaim_flag = memalloc_noreclaim_save();
 
-- 
2.25.1


