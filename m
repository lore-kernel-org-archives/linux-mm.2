Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B2ECF5140A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 06:44:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29E366B008A; Fri,  6 Mar 2026 01:44:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 246716B008C; Fri,  6 Mar 2026 01:44:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 000C06B0092; Fri,  6 Mar 2026 01:44:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2FF86B008A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:44:10 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F6761A040B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:44:10 +0000 (UTC)
X-FDA: 84514698660.05.B5A5970
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6EA69100003
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:44:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GTUlB8W6;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772779448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HTT2hSwhIX0sy9uprNVi4qKHugU4cvVQ3G9ad8x784g=;
	b=bevLdaqCKNVdVCXKmecgAkqAz/zijkQ5m0XkBSlDdx0rlWiZwDh7KqXv+B4ynFaz0JUc8Q
	JVdrU17+LPJTN0n/rfWIa3PgEkbwOVlvThnc+J93k/YYjAU5+ncNe5yJ3U5lakjic5FS/H
	p5W2NaBchWEVcSnab/wHwisWOIzKgqs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GTUlB8W6;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772779448; a=rsa-sha256;
	cv=none;
	b=D+Dwpk0bWdTpBd/rkbHlVdU62Ytpv5LBIhoO1A0mByu3z7JILlVkpYvQy/BnLOk/YxPpLM
	T3bkDr7U6EycIPyYEP+rrJwiL2P9GqGJEK5tRnyRNBiII2JWuBl78IALfCo7YY7BxOF16u
	xj+u/qXZBw/yzOPEAYCwlKr/blPlgfs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772779443; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=HTT2hSwhIX0sy9uprNVi4qKHugU4cvVQ3G9ad8x784g=;
	b=GTUlB8W6bk13UIAcDxDAzvS9lFeJx1tKxY3DQ4Q+UtgNwmFuvygpYDIDIyKrZEaEWoFEfywA3V63EbLy4qEPetDAN0KX1zYMasrkCM/qmyRNqEvlbAtwy7dyHeS/dA1vXH+uDwhfaU/RUpRlxbCuvYxwhZES7MoyqpiZpQbTr1A=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-MKhEA_1772779441 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Mar 2026 14:44:02 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/6] mm: rmap: add a ZONE_DEVICE folio warning in folio_referenced()
Date: Fri,  6 Mar 2026 14:43:39 +0800
Message-ID: <64d6fb2a33f7101e1d4aca2c9052e0758b76d492.1772778858.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
References: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6EA69100003
X-Rspamd-Server: rspam08
X-Stat-Signature: c5d8qno9t15gizeqsndsanuknm1yb8hr
X-HE-Tag: 1772779447-94255
X-HE-Meta: U2FsdGVkX19V8bFhjtc2AJqiV97iOUgJRkQLP5suzD9OV3MJTgOOgiR+U7Yukk9PuBTlspYc/+L3jnwQ9FgW5V1CikxRlawj2s4rZzrFw7MO8QB3qan+Myi7raQ/8juTYPA9mjpYSM3QCqhYRXuynNTxx0xIdL9IM3zOhVUyPDesKJQdun2t2zi5lkw2twRWWjbn2+Sr8yHLSEc/qYgLD01rB5wswOWWhAKiM2vVJ0RjgF+BJFmJwqxqCOhklN7IVB5bek0wt0wYIBpOftmnj+xqBn9Wzy62V8W0pwKmQ6F9HAVFeZeJEy8zAhy+jr8gdrmZRz4kdecuqvG08kPpaMKSZz+Air+B+llx64x204HS7pDLRS8XpnepE91X4Ih/bvK3Lt49xqtNSBtX1mmMjLB1nUX6dla+oSJguaBlPZ+NbfklFGwgZ0+MRV8HFP6ck47DmO3+DVg3EZir5v/ow7ncENSdMjCg9QYcwlXGUKm3Wdl3mHg/Y95P/zlAnfCXiXpHrLMy2C9Vxo76eKCF4toJjoC+7Pcn+GblAlrwyO1fz+AHdT4MPishBWi14KlxM2RXVnVUpCk4e/9y6KU3YPC3Orn6nmqHdAIyOmQqz+UU/+f8knD7fGcT68Oda2s+qWLUV0hNsAzCz+T6BGoM9BnlpPMzEPOMzNb8FhQ16nNkhlE2heg8vIr3Z/GZe9j2t6PFdP/9flDOyVQDFq1Gxjc/UWrRn1Nvhl/NzrGthjBn7t7FJ2I0sSVOoXnPKzYSwmlwM+vAqN6I4SexwhQC8W5i3FO5X9wpOv6cjnv2p8EsUn6yE++A7E2TK17W9BfowsA4fjyVgf/A2oDzm+tslFQ6w+zG7dPFxthsaj+FR+rk4pSnge+6A89fFhbBrtkvwOQhnmos2WjjBOTxpRrAuk6CoTs0v1OEiMkzAo529Lxa4yPTPHPTnxFriupdqLGu1EwcTRiY/1KZIyYHnjz
 O3ZrDFCF
 zV5Ys+xWHeB1x1HDaggrTP72JT+lyTaCn8fJeovDfDlNnizQffz+jc+QRbHOiTf1ajZ9wL2o3HiwxiMQtugfTtnbO+ZHksybVxYXj9X6NT3SzqdvuKb74AXWFhR1bA6Kl2fhCp9xCU22hEo+YegDkMCYRx2UkGbfej8Q7/nLbAtVpqE4P1HMV6MKuRcmcs5mDZny7wkBRIBMZTVjwlTTxfT9hSnvrkZqflvNL5Rbl+UHl4ooijhmKF0G252J8s8ga5I7M6UGu6V+unX896LVrAgO1dBI5+nj3dHbdfSJC4ERGPxbXKubxgcB3kH1BBYTFLHQfoe2/fAMcVU6qdgF6wUhMpMdhIOZSF0U9l7/25CjDDmbctrbZXHp7Dvh+9vTZVHrpIqDPJuBx3yGnS4oTLOajfz8I9vWOM8p8/AQJCax632I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The folio_referenced() is used to test whether a folio was referenced during
reclaim. Moreover, ZONE_DEVICE folios are controlled by their device driver,
have a lifetime tied to that driver, and are never placed on the LRU list.
That means we should never try to reclaim ZONE_DEVICE folios, so add a warning
to catch this unexpected behavior in folio_referenced() to avoid confusion,
as discussed in the previous thread[1].

[1] https://lore.kernel.org/all/16fb7985-ec0f-4b56-91e7-404c5114f899@kernel.org/
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/rmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/rmap.c b/mm/rmap.c
index 603186ff4ba5..2d94b3ba52da 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1065,6 +1065,7 @@ int folio_referenced(struct folio *folio, int is_locked,
 		.invalid_vma = invalid_folio_referenced_vma,
 	};
 
+	VM_WARN_ON_ONCE_FOLIO(folio_is_zone_device(folio), folio);
 	*vm_flags = 0;
 	if (!pra.mapcount)
 		return 0;
-- 
2.47.3


