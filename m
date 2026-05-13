Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2F9ACD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 367466B0095; Wed, 13 May 2026 05:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316746B0096; Wed, 13 May 2026 05:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22C5F6B0098; Wed, 13 May 2026 05:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1136E6B0095
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:45:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B14A11C066C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:45:50 +0000 (UTC)
X-FDA: 84761914860.21.BFCB43E
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf12.hostedemail.com (Postfix) with ESMTP id 13B6240002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:45:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=PNAu9Vy+;
	spf=pass (imf12.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778665548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8bvOMnKJfXNE5YsXe8vkEmmolNaOOCgms3KMkV0kHLM=;
	b=Vj9aMy/Z6AA6n/bmFNmjfJhU0DeBvA8fbfNUKHzwsXQhuqzN4SEQFS2qJgOp/U/dpDzZ6Z
	ousHSZeghe3aylNEO+sCvBIqos3oytSx1RQde8cTjdgE+sIs8zNE1B8bbV2JyWjeWkGxMW
	ADPgInW+WrQmZu441QzydP0YuwbIkiE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778665548; a=rsa-sha256;
	cv=none;
	b=qWUSsQcYmb9fIYM6IWaQaoMVx1Uxhy+UnUUSQZK/hBDQp9EpL6XA0COSSMCKyEh8kWrwnL
	8SgIFLt9Ve3utY+Ej/doubee7nf1+MH0CpZfZNg/E7rc52C4eiy1A/rzFpk0g3kKCmfZBF
	OyqrXpVhFZyb1bNlia2cL7a134KsiuA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=PNAu9Vy+;
	spf=pass (imf12.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=8b
	vOMnKJfXNE5YsXe8vkEmmolNaOOCgms3KMkV0kHLM=; b=PNAu9Vy+2P2ttq0AjQ
	f3XqpCAZ02qoluw6QAjTqhgvWXZL4yZBQrATb4ZqbkYv7NBprx2BFkbXFB5OUUOD
	RNNDwvmMPYWJWiw4JKoAIQ8LyX8Sq6kzweVZ5nznFv8tKEOp/JTp+sxhtL5YQvqz
	dfu9+POWf0kOyc6S6tuK57yIo=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgBXXvImSARqv3FNDg--.31S3;
	Wed, 13 May 2026 17:45:16 +0800 (CST)
From: ranxiaokai627@163.com
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
Cc: leitao@debian.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH v2 2/2] mm: huge_memory: refactor thpsize_shmem_enabled_show() with helper arrays
Date: Wed, 13 May 2026 09:45:08 +0000
Message-ID: <20260513094508.50888-2-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513094508.50888-1-ranxiaokai627@163.com>
References: <20260513094508.50888-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgBXXvImSARqv3FNDg--.31S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zw4UZryfZryfXFW5Xr4xJFb_yoW8uFyfpF
	Z3C3sayrW8JFykt3yxWF48tryYgr4fJw15trZrJaySvwn8Jr1qvF92k34rZa4UA3yfWw4S
	gry8WF9rGFWDtr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piqjg7UUUUU=
X-Originating-IP: [117.176.243.1]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7Qy4BWoESCy46wAA3F
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 13B6240002
X-Rspam-User: 
X-Stat-Signature: md3pf8d1xaay3com6qentg6skrate743
X-HE-Tag: 1778665547-628459
X-HE-Meta: U2FsdGVkX19emh0j8eVmnYngXuPsqr7OKISomootH1b3TiuYV8Oak5eC1bqxCB8EC5q3UJd6kA0vBMyA88KLtr0IHY/gaW1ITesGTr1LgNKV6H1CpivkP1ygt+xLS14YcB1MISZ71KpmUy+8Zb/KC3yvCZfaZszs83UVb++c5EYqfirIS4vlkYax+aJ5EYmSuaLB201liBjvuTH43xHLMEkiBrcjPlai5OMM3kEGzGxa26d8UCi8ApZlkRTRIkmH3QTZ/pxhONVsQW1IlpQRPT0sgcslesVMRplfeQjD/krfWpLreTJQmZHSTBgOFZOM1QyX/s46t8Y9p9P71UNk2158maP6dLYHbRGXjM8miIPYT1OPm0xKuU3D2NTFo/E6tW+v91TRJyNJKjqoqi++NSyY8uMxFYR+y4t9JUDXGYye9CiRClqvduRmNBVir8EesmuqcovpoqoHQPr4FhuNCPvoV/5OkuoV9ntsskgn4s2PJvLFNb6NtuIXSHHf5vSY6DkbnsHQXZvh1d65e2ClOieXbmxyiNU6T5HS+EMxqAalheLBzAz9jAltcDUrzRYns+l5Qbk4G1YQYmoT1/ZKf/5s914Br1ISa6ZXMV0ImAzTfUplEHrk9XMMXnyBSRUzTUnz4RDws9rwN2mxbrD1kyFiQfN9K80t2IEGoxYZ0Ywn4fdgdKblAizIz/xfCnWUqnnlhRR3Q709acfccCzqJV3nCnrrFTBSd4xcVRRljiSJ+yegxsGG+kWLUzS+sP6hrcmPbgm08MsG9rBJWBWCCkqPIMqLUSTU8JVbaPVbLscwSzV+11wPG7xTRNzOkBV1IjdknBBHVjDdQsc9eSBeJrCcRZE9qLjxhLrTy6/+k6gCY6/H1spx8PHYuO1Oq7OlmeBCB1eK4M8yYR0m9YiUPkDe+Bx9c9j+KG191K3GKeD5MHiL04WzDG06JuiXXg7HLHG3/fcHVnpNySzWxwB
 kQamZ8yY
 fT8P1Xv55iPRkx+k9nLLJCdqaJRx+BQNj0jIcPXewTQ58NHSFT00tKteQMcS6ZHG2ww8k8E2TYp11Vtvxtjc6xEXUXeqw+i2hI01yyGkBJ6k3j8kRfTFQw0lMiFVISH4jbIfcZe96lK4j1Q3RHbGr+KuZ446ppWT08OA3/PyjZ7CV0cqIdHNE4GEanWHIHJHgwzKZu6dJxlYk+H3XVjq8F1Ed8i6OS/Pd37v/BTrtazmuTFfh7TXNOYyZ55Hc0z9lWfaLgptzomb/1yk0sFXBa90ErMbZkd51QG9ZlfD2GfDEzBqqPwDDBKTnQh8i4J6vdAMvqn8zSPau10AhkuF7J08zbVBteNU6/+ui+sNDJtNafdw5y2cpqgXNWC495dzNbFKONG+kVbPkcml1dWQGbBnT2OWPvZbv89Efl1yLQP2xJKrMpFOiKBV0KBEsruubWerr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Replace the hardcoded if/else chain of test_bit() calls and string
literals in thpsize_shmem_enabled_show() with a loop over
huge_shmem_orders_by_mode[] and huge_shmem_enabled_mode_strings[] arrays.

This makes thpsize_shmem_enabled_show() consistent with
thpsize_shmem_enabled_store() and eliminates duplicated mode name strings.

Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 mm/shmem.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 60cb10854f11..086762e6de71 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5553,20 +5553,30 @@ static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
 					  struct kobj_attribute *attr, char *buf)
 {
 	int order = to_thpsize(kobj)->order;
-	const char *output;
-
-	if (test_bit(order, &huge_shmem_orders_always))
-		output = "[always] inherit within_size advise never";
-	else if (test_bit(order, &huge_shmem_orders_inherit))
-		output = "always [inherit] within_size advise never";
-	else if (test_bit(order, &huge_shmem_orders_within_size))
-		output = "always inherit [within_size] advise never";
-	else if (test_bit(order, &huge_shmem_orders_madvise))
-		output = "always inherit within_size [advise] never";
-	else
-		output = "always inherit within_size advise [never]";
+	int active = HUGE_SHMEM_ENABLED_NEVER;
+	int len = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(huge_shmem_orders_by_mode); i++) {
+		if (test_bit(order, huge_shmem_orders_by_mode[i])) {
+			active = i;
+			break;
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(huge_shmem_enabled_mode_strings); i++) {
+		if (i == active)
+			len += sysfs_emit_at(buf, len, "[%s] ",
+						huge_shmem_enabled_mode_strings[i]);
+		else
+			len += sysfs_emit_at(buf, len, "%s ",
+						huge_shmem_enabled_mode_strings[i]);
+	}
+
+	/* Replace trailing space with newline */
+	buf[len - 1] = '\n';
 
-	return sysfs_emit(buf, "%s\n", output);
+	return len;
 }
 
 static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
-- 
2.25.1



