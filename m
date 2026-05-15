Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37092CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 07:03:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 680EA6B00B2; Fri, 15 May 2026 03:03:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6318E6B00B4; Fri, 15 May 2026 03:03:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56E736B00B5; Fri, 15 May 2026 03:03:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4861B6B00B2
	for <linux-mm@kvack.org>; Fri, 15 May 2026 03:03:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E383FA066E
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:03:42 +0000 (UTC)
X-FDA: 84768763884.29.AB4D9D2
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5D90BA000C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:03:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=bGRGnkZD;
	spf=pass (imf15.hostedemail.com: domain of liuqiangneo@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=liuqiangneo@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778828621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DP0uN85hN/P6bKF4QuAuHVFx5r5zGiybbDRcEIgSFik=;
	b=pQkibIjwuofCCYYl9fiwHzBHZMcFK27QpyLyllCSqGOoWnTRm+Q0VGsm7J1pER2w9EH3Bp
	XifMHpFKqtB8TZJ+HTinovy0nOa+rxQpLUbE8piNCLZO8b+UTuPv6nedgUY/kQj41I7jCs
	mkkgxOcNNzHn94YHN2/WjocQ2BeYjNQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=bGRGnkZD;
	spf=pass (imf15.hostedemail.com: domain of liuqiangneo@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=liuqiangneo@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778828621; a=rsa-sha256;
	cv=none;
	b=LBk5kLXOfyUl/gFAwrW9eefUDOMFzfUBdl4xm6LuwwXsD2517J8sguufX0T8YIWaPhJyKP
	E+OJqn+5ACRcMUXwgXkmAM/I6Acgloh1lpf7gZ0k1hyT8x9BSp6pIwSbWmuJDW8nymoPRS
	/rA8fAEy5/Ub6j40W8eW7MiJ2/31CQk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=DP
	0uN85hN/P6bKF4QuAuHVFx5r5zGiybbDRcEIgSFik=; b=bGRGnkZDyZTd3VL9qo
	lUQealMhw50wlFCXOGYzn+FbSOd0vYPCspuMpbfgavCHVQrruP4L/l4HW0tzwQoC
	sbqYQQlXZVdpUpfs8dmeljklQtfFssfIWryJ23ftJeS/xMH/YV5Ou3/nWN/XeHgA
	4Y9VXZ9vHNOh1ymcr7VkhZks4=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgDXnOEyxQZqinfCDg--.24181S2;
	Fri, 15 May 2026 15:03:17 +0800 (CST)
From: liuqiangneo@163.com
To: akpm@linux-foundation.org,
	apopple@nvidia.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qiang Liu <liuqiang@kylinos.cn>
Subject: [PATCH v2] lib/test_hmm: fix error path in dmirror_devmem_fault()
Date: Fri, 15 May 2026 15:03:11 +0800
Message-ID: <20260515070312.130435-1-liuqiangneo@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgDXnOEyxQZqinfCDg--.24181S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKw4xWw43Cry3Zr4UGrWxJFb_yoWkXFgE9r
	4rt3Z3uF45JFZ0gr4xArsayrZayFyqyayfu3Z2yrWfK34UXw1Yqwn7WrZxt3WUuF4jyFWa
	k3WDtrn3Ar1fCjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0U8nUUUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbC-Baa+2oGxTaqFgAA3o
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5D90BA000C
X-Stat-Signature: hpanp4badacfmfatmjd51u6mdyq8ewqt
X-HE-Tag: 1778828619-267521
X-HE-Meta: U2FsdGVkX1+FcweQ3w8OCbacDTlWF4NzUUyFgRVCi7VWZ7niqdVxy8Egda4C1xJ2r8zzuftsh7yAaU5/AXslZuqFJnzwFnU5j3tuJpJB50QqWfORAkTIxReZS2GzWPFpob3XLvQPb57iUDsWsuccrq1qZxaftGcGpEAhflkK73n6JM1xpsWAn0NFJmigq6rEXAvKUXAvg7PTZ72lVsxfla4Z933BnFQd4iDQh/OPdpcMr9uiqp7eNsV7I/rcwpwDrSNmJgkkiBg813dDDf9BRK6FgN6fxmXlYkyFiXUcwSUkpzypnZr3U3iaG/zYZ2QqBXcrDOE0Of3U6Gmjh95UKnR2tM273NAq/uLlTqn8wBxWodknQjjY339MCV9XKQloEjOdZUClfHbfFoQ3k2sv7mRzKCCl2UBe7eDygo5p0Pa8nW45PJI2E4PdrGBMlfskSRmwMvk6DLXPji+J4F9bSt+9LOwJyu/3q+BYZ6Iwav384vSopFqvRltFQbO21HCtNPc5gVu0eHnFpVl03LR4RcbYj7m+8EEBHdGNCuNWhkcwjdkjoNAkIl7c+tHJtWvv5qtpJj6QCGBCVZ/KS+TthJjSbLGdELK2++lkBOQf7Bbb9yCv60O1bOCS4+0sH/v7uriB2wayjMCAYKVn704J6dEcsbCIVVa0du0z2KBGwIWg1CFxgukqrUTX8+aLLEbJoQpTI0oS3SK4pF87RdeFF874gHXEeH7IagS5k8JcGcxcsz/UikCEMvwS7cH1h/d22vF12uHNLsrhhHD4x5jtd2I3vputGK/OIQDkH15YDnG9sBs+p062iczK3K/1AQijLadi863OzH3HGVQ3Q+LDlkesa+8iNt2BdEDicvKoYxkuZChOiVzg9vdt/gnmIpjSxfyKrdSqTy6jFPUkMrrbt0/GT9loBUzxYEPGDpIXPaGE3OKcTwLziGIlJuuqd4R3PRKStM/lHcwvBKHuCPG
 kzkFEcuF
 QtPEsVjpAXVkccMIkmbNOq9DLRKp4YmHu1JgErPiaMNSNoZUe1ixNu7JdBeiY4xxPUIqnyncttN9lg/nXMZRtGaxBPLK3/4NzKKm9GLhS3gdfcSou7kt2enlpxe/i8ZPLknVaRFFmTXEYSGqfXYG8nsPZAV82UFqB/Jq+7pXwXrAyCDletiBNisms77l3N+TPkk1OY9denMUysx/Luhx/7Np+RwY1f6tL5C0ZRnBFbel+xw2AESiMi2yLI7tvudbeaIedsRQzk2OxejTVz096qxoC68GXfS+JzpftVGy3nbAqx4ad++zjjexKauaGSOaok/q0py6No20hnM6SbqC3s+yvzmF+EMWv+eAxwYBJbm4ry6G2Ddfily3N9wOWCHlVyhyHp5pXdzjYL1YVjkrrBe/JAQjWgI3HVEnt5S1dd5EARtzTQaLaXZ+4qIikXi1U3jpE9urpz0UXzSg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qiang Liu <liuqiang@kylinos.cn>

Handle migrate_vma_setup() failure via goto err for unified cleanup.

Reviewed-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
---
v2:
- Add comment explaining migrate_vma_setup() won't fail in practice
- https://lore.kernel.org/all/20260514025328.21175-1-liuqiangneo@163.com/
---
 lib/test_hmm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 213504915737..a232b34f8d3b 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1679,8 +1679,14 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
 	if (order)
 		args.flags |= MIGRATE_VMA_SELECT_COMPOUND;
 
-	if (migrate_vma_setup(&args))
-		return VM_FAULT_SIGBUS;
+	/*
+	 * In practice migrate_vma_setup() should never fail unless the
+	 * test is wrong as it just tests some static VMA properties.
+	 */
+	if (migrate_vma_setup(&args)) {
+		ret = VM_FAULT_SIGBUS;
+		goto err;
+	}
 
 	ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
 	if (ret)
-- 
2.43.0


