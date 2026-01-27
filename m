Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C370DD2F005
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 12:16:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A7C6B0089; Tue, 27 Jan 2026 07:16:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 204AF6B008A; Tue, 27 Jan 2026 07:16:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E536B008C; Tue, 27 Jan 2026 07:16:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 032A66B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:16:19 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88076C37B1
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:16:18 +0000 (UTC)
X-FDA: 84377641236.26.80A0E15
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id CE31E1C000C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:16:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hUKjvELb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769516177; a=rsa-sha256;
	cv=none;
	b=b9bBq4qsUT3I9AXovGRxOxxwgb/Ly/ez+jKTWwgrW7CQOohXdEmATwTZBXexPHWCXRIHjd
	38RORORajmFZhCmf67rAA4mzeXSjEkXAe+RB3jdrV99kj/8EJV420DUOFzgxcj8CoWbFLD
	6CQFN7qVq+pgu/XoN1ZS8CrNKBgWIc4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hUKjvELb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769516177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bw+1Lau4jkXgNGH1w/oSy1pnIcM7wv7myPLVDHR+sFs=;
	b=yILNEYyly+epxqne/1sY3l8mwyxdjWp9Je5qZCl268wRywBJCJA2hJVWIpDsp8o9pBJwo1
	pQACqz4i2/q26SJ2tBrphPl5gQkyNI9BNYO4xjbNasq01aKygSt7V+5/2ZBgZAJGUAdApD
	d6SZHfTg96+XNFWHFZsNz6w/MEIX5mQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769516175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bw+1Lau4jkXgNGH1w/oSy1pnIcM7wv7myPLVDHR+sFs=;
	b=hUKjvELbABSmnUqrI5qPQ9bSnsP89+zBRGMs7qv4H7R27UKdLDXzwCU/gg9o3BfqeT7gST
	gcwTCrZEx5j4Uez+P67ltUVh1b+5YlRCzUPEJQdC9fITO2OWcyB+9wYkoAHOxFLz1rkNYN
	VeJ1wvGnl78/SABD8IsL0/mjfl6wMPk=
From: Qi Zheng <qi.zheng@linux.dev>
To: david@kernel.org,
	andreas@gaisler.com,
	richard.weiyang@gmail.com,
	will@kernel.org,
	peterz@infradead.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	dev.jain@arm.com,
	ioworker0@gmail.com,
	linmag7@gmail.com,
	akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	sparclinux@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 1/8] mm: change mm/pt_reclaim.c to use asm/tlb.h instead of asm-generic/tlb.h
Date: Tue, 27 Jan 2026 20:12:54 +0800
Message-ID: <befca537d10c6bf8d531b1ee0a8af1e3b31352b0.1769515122.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1769515122.git.zhengqi.arch@bytedance.com>
References: <cover.1769515122.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CE31E1C000C
X-Stat-Signature: 3ipmaey69o3ed6gbhj41g3mepk9j5mk3
X-HE-Tag: 1769516176-499181
X-HE-Meta: U2FsdGVkX1/1d3ro5rHtRe6mzijBoqkVbhoan+BUnCs7unJGOBOVEGYuIVutw1DwiTJ+XRoRTEULmtdDJuDmDrLMNbL7ufwzRm+rJCOFwwply3Z3XKFXTKS5ZDp3Colyd/NqdS1jenEQ9XLB9IiNrSw7rgBYbBpY9iu5VhSyypJE7O7kZvCgqhO4aIcO/xI4qiNj0RVLOHfpkf0AcoOTHUbz59GHm5+opRhpestLFWB8B9VYi/ejw/7F67UaUkJbpMdAiaw3tHNotIqvmwCqRPv/i/s0bhHzkcVe/KrmwMoqg4r3OTp4UXBXU9Cx0AJ1O1qqgRg9hfoB1iegboRyXHhizn6Y2LZZBZVbEh9v/3kNaK1ffTUcwj6RZY0zJ4QhCFN9faUxVO2l1bto6HN8eEJS2h5kT7QuKxS+8WVGTtuF2iz3o8WSyhZPB5XpYD/cd81OfiaaM06t4S8k/fhrpBJtaP+98sMLNdAhXpaMafyvte3yuHx/miWqn4LeqYrtppUwbfNeZbKIRO8nAqIz28ZJ0yTTNiGyMPHbj9b3wyFJNhM8hV8T+QcW56wVS6t6o3O3tbE+Ph3iE6XMW/++WduveNYLkBNr/7M4mlZszSqFk7nEKMRDhx6k/c+6TeO0Gi5luimcItTfYkkB7Jm3J6Dpk84kau+j7Pkgk0RULr0fG/xMBAisHsHq2TcRe1iSLtuF4q5aGcn/GCUIU4BNnCXGPGZ6i3q1yxqH5xIrF+GI/UEpE8Snc+OakDY4Tql9r2G9Uzjqhia0MFxYq5/i+ok+K6HjTrduax6Y4H+HKOPqwywIUxMnY+MWndSp7hAnrFNKBD9zHG28UJkTXaP04HRgZf0GQfia3Vx6GIg7/0iDPR+HuRgcmaMKsOL3ymxmynnXtIZjfIpFfhT/OLimNr7da08pOEJ79zLQL3aLC1nolC2JNmZcFdzcMsO0jV5Y6OLvy/rDpaqvx+rJ6cq
 56RUUot5
 QUHwViUgbo+gyDwLvw8FEZtmkYi6STwU/fRNJVzwisQYdpU81do6sjeduAx38FLmSpQUspDFx0al4V3CnF2tZPuDGyXatx7vmACWg8QlrhiD3mTcwg6KGXD+sRko65QmG/pomLQSrZkDcaUgQWeru0BZE8OnIhoXRrPhPnTveIwTSFPluAJdAbLXw1UskO9yvUpegtN3+3RiKjoP/NAojUIFpfhao/eTMaXxQtgZK7B/F0alYVANcOJ990U9H9O4VEWHDbX9AZyEsu2EjJnklm9lra5Vqdw1l3/drL4hiS3Iq1RmoxfozFy47+LSWEouczrVnJp9NyJJcq1f6mVMa+itdu+Mzvc/aSSlmLXLd2osU1ck=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Generally, the asm/tlb.h will include asm-generic/tlb.h, so change
mm/pt_reclaim.c to use asm/tlb.h instead of asm-generic/tlb.h. This is a
preparation for enabling CONFIG_PT_RECLAIM on other architectures, such as
alpha.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/pt_reclaim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
index 0d9cfbf4fe5d8..46771cfff8239 100644
--- a/mm/pt_reclaim.c
+++ b/mm/pt_reclaim.c
@@ -2,7 +2,7 @@
 #include <linux/hugetlb.h>
 #include <linux/pgalloc.h>
 
-#include <asm-generic/tlb.h>
+#include <asm/tlb.h>
 
 #include "internal.h"
 
-- 
2.20.1


