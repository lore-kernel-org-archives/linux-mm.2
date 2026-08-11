Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 965FFC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 09:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C19E96B0095; Tue, 11 Aug 2026 05:23:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1296B0096; Tue, 11 Aug 2026 05:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E896B0098; Tue, 11 Aug 2026 05:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93ABF6B0095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:23:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B9B51C06B6
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:23:43 +0000 (UTC)
X-FDA: 85088451126.29.0A2159F
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id 95F1514000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:23:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ABIUFPga;
	spf=pass (imf09.hostedemail.com: domain of liuqiangneo@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=liuqiangneo@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786440221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=w3MYd2TVYjVgXHcht1S6pZlncyHsIQAl89MBKPGG9XA=;
	b=CkCXZGO5pNIB7dP2pqZWGsq++mu7zSVpgNQrFXYd7MQI0673FNBsiqmIeG9a5ulxN04++u
	pmWp8i0r3yBZeh/bQdeolvWQvPFiyB7Q5NvPZntGaIbNttAPHqY3In0Skp3u6g/r0/bPxd
	0S2dxLiz+d4e6smzeHiJv/wXs4yzmpk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ABIUFPga;
	spf=pass (imf09.hostedemail.com: domain of liuqiangneo@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=liuqiangneo@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786440221;
	b=aRuEMPxVBbWQV8h91qsle91puSfaRytSe+426dBFiJ8sDh87hcdM1bCPDi86ypwaCI3pSI
	7G3HJczWmZjHsU4PzwYSlqaxu0I302Y6bIjttCOljKluRWOqbtk7pRNNwje58yzZqLXmJG
	MEIZ3SwVA2aS70WsDrin+vr6ZIUgRXw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=w3
	MYd2TVYjVgXHcht1S6pZlncyHsIQAl89MBKPGG9XA=; b=ABIUFPgalmmet5BOg0
	6WOMthh2aBOugVzhYoQjk6qbo88Y3Y8ADSuNCeXIBVplqg8kb9O3TLQtDoCRG/jj
	J0vJsgJdmzbi5yp3No9foL+JqGepmPLZL3v/iXS8OOXdc1AcUb5gTSbW+r8K6l29
	6cMgVxky4c1089BYrUyHxRy6k=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAXVi4O6npqFnMiBA--.20913S2;
	Tue, 11 Aug 2026 17:23:26 +0800 (CST)
From: liuqiangneo@163.com
To: jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qiang Liu <liuqiang@kylinos.cn>
Subject: [PATCH] lib/test_hmm: fix NULL deref and wrong direction in devmem fault debug message
Date: Tue, 11 Aug 2026 17:22:55 +0800
Message-ID: <20260811092256.102101-1-liuqiangneo@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXVi4O6npqFnMiBA--.20913S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr47GF47Xr43XF48Kw1DAwb_yoWDtFc_GF
	409Fn5Wa4jyFyrurs3CwnrtrWFy3y7uayxuw1xJrZxuryYq39Iq34vqrsIqas8WrWqvFy3
	Cr1DZry3Cw18tjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8db1UUUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbC3w-2WGp66g9FZwAA3p
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 95F1514000F
X-Stat-Signature: kiu7jphjz37kkp5rnuz9q7gxfek4pk4u
X-HE-Tag: 1786440220-421453
X-HE-Meta: U2FsdGVkX18Lx8pp55rMSaku+CaU0TrljISTFY7WaWj9WguCZVAtNrfWZMyMf/5HvHu2tV+6gcz5RzDii/C7Xh6t4+tinY7hGajo0+P9oOOR7lQga7sy/bLsCSSUrZFLKfCCrdgBPI17b42LsEjvptN7iSt+UdZdIbpR0jECOCtbVNHgtEPJExp+sq11zvKTxuc1LpulcqOXa38hMQMbVlNRdMkcxIunqUWzY1/jWdna+iXmgBAE2hk6UGT/XeFn78BjYO4XmtXVO6GPkIa/ItASHkHIyA+2p4jWqgNdAT+Ag7MhX/JhuRMVeaKjGUZSEmuqp0JjPW5lJvtsSzAkn3wgFbHsI6FSSQkaVf0CTtry89uyuI2zxPU5hv2WBJL7O3xaWuyiJBzr22X9Vn1ayOuBUeSz82g/cnVJq9FcRh9Or7wCM7GSWQ0mVxBMNFCJ4SwjjUdWr40H6sILJ7hbmc6OlvATQBEc1mtD6KOrVIWjDTcCFpeWyLLQuwo5JSyKtD6/oZKuwti/H/SQhsIdO61x1yl+ut5rQEMURAyrRbRxgEGiRp7NsDyPsG6VXgm32Ez28DwzF996m4NuYRmf+X8q35yE0eNFjZIuIsqqGbMLs9ZKY6cpJnF7ew/Hsem7YrlBlacZJRNMVJDf1QrDrSAfhqhn0xYJzfuVPV44wDcpf+1J1t1ocV88RTLW1YrgwYHKZvEWVzgaH/jdaFC+cgi2OeemBY3Rf/bBdNkh8HRkOCXAzAYSQcxLeoFgyqVq0BwBbkaICgWYbQ4Tz1gyd6jeIkAnxm2O9Zb/7dSvRD+dvNVj+5+8QQFD3MLprh7YUqWqXnmP9FhXIPRvkOL8q2btOyepyigtrW4l3c+nyFdiLULVT9VgMTNLF7EIm9wmt7wdKS3MvUjA3/THIFBJcIcC5/EOoOMHD+S1a211IzLD6cidPJF4TpD3zh+xd1E721yGrVEp26I3+pTV0GL
 pEVNqlbX
 qOfdypgFpFkzg+DuQds0aifm4Sxs+YLycfAGhMG1CjVlHjUaXctpX3mtPLH2pk9PcfO7JuyuMjNIPo0Wo1s9BcjaqskKNx8aHWQ32f7wIv+pTjJbnNAUUfbjUT3YWfoRb4HsEURTSAwnWobz651l9C6k0bO8xCfSJ8W6fIzi5PN27NMiwdpnVTKvJvVW0qVi7YXdN5/zwue5p7tBnoNkG0MkSjB0208mGdIf/+qn/hy/4ul9MWd+wyZdl/ipqeN2AT6Tm/2ad7o7bpxBgR72jUuMBWuLYNegds6I9RvL46O/qVh0ZJ+o/lcOTS3tFwHpXheCrIJLaPW4aw/mWEUob4rZ4EPs7aGJ1IxJJlCXeqZZd2qFTZng23u7SuM7qDN9KERih
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qiang Liu <liuqiang@kylinos.cn>

Move pr_debug() inside the `if (dpage)` block to avoid a NULL deref,
and fix the direction label from "sys to dev" to "dev to sys" to match
the device-to-system copy.

Assisted-by: Qoder:Qwen-3.8-MAX-Preview
Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
---
 lib/test_hmm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 6e72a0d8a53d..1dae93ab1e93 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1151,10 +1151,9 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
 		if (!dpage && !order)
 			return VM_FAULT_OOM;
 
-		pr_debug("migrating from sys to dev pfn src: 0x%lx pfn dst: 0x%lx\n",
-				page_to_pfn(spage), page_to_pfn(dpage));
-
 		if (dpage) {
+			pr_debug("migrating from dev to sys pfn src: 0x%lx pfn dst: 0x%lx\n",
+				 page_to_pfn(spage), page_to_pfn(dpage));
 			lock_page(dpage);
 			*dst |= migrate_pfn(page_to_pfn(dpage));
 		}
-- 
2.43.0


No virus found
		Checked by Hillstone Network AntiVirus


