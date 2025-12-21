Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28E52E67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 23:29:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00D166B0093; Sun, 21 Dec 2025 18:29:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4256B008C; Sun, 21 Dec 2025 18:29:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C366B0093; Sun, 21 Dec 2025 18:29:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C34596B008C
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 18:29:48 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 463418B9C6
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:29:48 +0000 (UTC)
X-FDA: 84245072856.29.0A017DC
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf16.hostedemail.com (Postfix) with ESMTP id B1472180004
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:29:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=YNn1W6LL;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766359786; a=rsa-sha256;
	cv=none;
	b=Nu7pF6moztVRTQ+2KJFynJRaAZeBDBvMK4CGuFZgA6ic72ZCQgfZ/fc7ZGcqlo66eL8IGz
	UxxvB0pOJu7n5HGwhQnSD4q2a/pewkD+fyQni9qpz/Sk+KGQ2AvfdW7YDFFeCwTaKs5m1+
	Oot6oxGRvOuEVOzYCK6LJ7Ptg8soL7g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=YNn1W6LL;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766359786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mq4W7sDg/Agh00nn/sSC9HgKzw4XSoLV+yJE0vShXuM=;
	b=EURJD6vssYCtT5j7p/7msvIa3TqEhyBOoF3is5goiKtp+FpTEi0LGx339X8V6V8NNTSmhd
	gaubUVzzPo8RMNnIIArQahq0asDLCma3lHigjLhBGPv25Jb9VuKGCh1XfOgriuTFewLX1e
	v7QrbPQb4nNsKCrodzyWG23r3F+JrvI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766359786;
	bh=Mq4W7sDg/Agh00nn/sSC9HgKzw4XSoLV+yJE0vShXuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNn1W6LLVQr7r81fgVrE3iNKt1NbFU1kaCmp41f1sr3h67Na+MJcI6xiUNS/yf9zp
	 VkeHEXt1ZmtVZVS2CEuqTCeQH48lrGG8jrtI8lnMVc20Co8UZho3SC4D373TD/SJrX
	 A/fasWo/5zs6dywhjCNWiinaPJKgo59T75k91mbbLOfwb/xcnDeF3R0G+AtwX8c9qY
	 02HNkcn5w0M++hHJLUyABFY0rNbaqp+c0jXbKUANKkMPg+58+jQwIG7kAy603gQg8Z
	 CdRlGvUD2nW9jaO4APDzwk68vlYWVextGyqAZD/yG8PR5lRk8Bz5eB6n8hDE8tHr1n
	 4sgCmvYJbvonA==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:6450:b8a1:16cf:5ecf])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dZHYQ0bfbzd8N;
	Sun, 21 Dec 2025 18:29:46 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mark Brown <broonie@kernel.org>,
	linux-mm@kvack.org,
	Thomas Gleixner <tglx@linutronix.de>,
	stable@vger.kernel.org
Subject: [PATCH v1 1/5] mm: Add missing static initializer for init_mm::mm_cid.lock
Date: Sun, 21 Dec 2025 18:29:22 -0500
Message-Id: <20251221232926.450602-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251221232926.450602-1-mathieu.desnoyers@efficios.com>
References: <20251221232926.450602-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B1472180004
X-Rspamd-Server: rspam03
X-Stat-Signature: syfk9e9otr6yrprz9x38zazjuka9qapx
X-Rspam-User: 
X-HE-Tag: 1766359786-11864
X-HE-Meta: U2FsdGVkX1+3GFrH5wAljsEpeszOx2jSNToAUyb1FAAEYsf37VUtYpN8s122G75fYATuwrHkbLPU08Jmvdl6SnaHuAEsfpIwwrny/+91qjGcJ1jPRwygsuv9IlO4EiBq5c3iiXZl78hp8yU8Z4zSIkEK6G8guw5SG9IPVNOZESsSt9XHX5jTQjz1e/DqRoyyI/Pxs52+dO+iexT5+PMaQ8DHrHgQcQns9JQ/p66pUnfQfmLJqadGwKA6HkFdfecFpf+8Nlntrt+FxX++gb0auMbtQInaBffFfW2YYzJG+b87DxOjL7LX9z5DbjwSkvCIAFQSFxO6hXWhsrOwcYxSjj4WI8L+x0Ekwy5ykybpzHbTT//5CINnCltI3SJePDzI8JwEBMqunUsZ885kxWlY0Nm4OhvwZRej3QLLzTBa11V5xPQzgGolpA2Q5zCVhY3FNynN7qs8Koi7slhrI9t9F/OuhzIk5smDz8L7iWqOwmWZz6hAKSJkXXBOZOyKJeNsT5IseqO8wrd6gAo95YV8Wae/egGGM4qZe04ROGnmimlsUCOZwUUFHPCOngU90L+Jt9Hq09cgNNrFvKCZ4IjFOYbmlX0gw7Bi7OJ1klxYsbeKiAZ1LzWOEGKkO6pK6rqXaBNwXD/dqdMxVBJ0v3Y4/FBriiUA0+VPq5f9J7/2tYoxW8zREb2oIubaNK8aZ0rR9hAY4x6VtRdActDlL4d5DR6tLxW8586Z7L5XWCmnOlkEVD9FYzJZsLHEFznW728eAgYNsEtUNNZbTq5R4ft1BQqQ5bTuxw13fzbs7/vcddPhFtpYg8klwk+rgS2kVT0HWNZugkDVAtnbu/869NWETr0GcHTlJD/mXw/RcDmHWImcp3OWEM3J5/JbGyaLLgbrpgj4AhIjPrRkCOgn+u4292wBdc4u+XYLQyG945yrotou00I7R5WOqs8sJVoN2qJgv0kGY0MyNcfIjtO4WMh
 HsVQBMjl
 HNViEFBuf5P/9zFDd9cT4TehtSLlFZ6Xs5NDIZrgDeKNPv9Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Initialize the mm_cid.lock struct member of init_mm.

Fixes: 8cea569ca785 ("sched/mmcid: Use proper data structures")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Cc: linux-mm@kvack.org
---
 mm/init-mm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/init-mm.c b/mm/init-mm.c
index 4600e7605cab..a514f8ce47e3 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -44,6 +44,9 @@ struct mm_struct init_mm = {
 	.mm_lock_seq	= SEQCNT_ZERO(init_mm.mm_lock_seq),
 #endif
 	.user_ns	= &init_user_ns,
+#ifdef CONFIG_SCHED_MM_CID
+	.mm_cid.lock = __RAW_SPIN_LOCK_UNLOCKED(init_mm.mm_cid.lock),
+#endif
 	.cpu_bitmap	= CPU_BITS_NONE,
 	INIT_MM_CONTEXT(init_mm)
 };
-- 
2.39.5


