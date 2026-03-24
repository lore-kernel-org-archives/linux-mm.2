Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A711FF532C0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 01:28:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E1F36B0092; Mon, 23 Mar 2026 21:28:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B91D6B0093; Mon, 23 Mar 2026 21:28:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F6186B0095; Mon, 23 Mar 2026 21:28:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01FC36B0092
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:28:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7EDB1F61C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:28:56 +0000 (UTC)
X-FDA: 84579222672.04.B7F2237
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id D783814000E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:28:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=YnWJ9ElD;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf23.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774315735; a=rsa-sha256;
	cv=none;
	b=YD6Cub6er2R0GSmah7CibfegF8EnP0HQoE4nLk/tDddKB2CdBZgmhuBgBJJOUOvDRIrfXp
	KwuLha6x6r7kU4r8CxzdfvnnjPhPNV9KUAlwB64Ok7IHwvBDo9jb6jdipikH7/9BIrm6qf
	1FBPIQw6azdy3AGdofqfYybWZsuVO2E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=YnWJ9ElD;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf23.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774315735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W6JRFOUadqjciaiNHE1QDofRIxwv1kmNDZZ2Wj8Ios4=;
	b=umx3l9DRVnL/91dHqCvzlWvQqaW3UbRVHfPp4/1SoLfkQUg6YWT+gxq3a+k0050MRQk2OL
	v8vQh8SsH4eMSmyjoEwqs1DGY/J5lNyWfVWVHJpqyfBLRqBtIO3zoIjfm7pZZD9SxyzcRe
	vI/zg6hjpTOyil52T3I53Cn6LAEZCT0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=W6JRFOUadqjciaiNHE1QDofRIxwv1kmNDZZ2Wj8Ios4=; b=YnWJ9ElDJrJ3NE6m8liGiTosd8
	ybIFtdCxq4+uGxr0YUoML5Ie4NFc3ZRtUgXVtjfyMvDgiQ1HEimnkEtYs/fEMjzzVDl7dBm6fGdnh
	U/AkPcYscEjH4ztWCgUuD6DIwGjquju7iyDuC0y8fzslplZdJnAgz8Fgf5JPldCzjD+/tpOin4wDq
	G4sXk3gFYN0vpgWv8mHtxKGDWba9xJQ9n/y0PZDpCOP4dvaKu3tKsKjhRB09mXmobwkoX+H0Ti3zN
	y2UHdHmrSGtbZ4G59/TatYnuWdSenszH3SSKQFnfUqRqXGj4Qp356UKE0F6DKPjFIDhxRwruuCFJp
	eb6buPJQ==;
Received: from [179.93.15.111] (helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1w4qZc-0058EB-PU; Tue, 24 Mar 2026 02:28:49 +0100
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	kernel@gpiccoli.net,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v4 1/2] mm/memblock: Print out errors on reserve_mem parser
Date: Mon, 23 Mar 2026 22:22:17 -0300
Message-ID: <20260324012839.1991765-1-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260318190816.1811325-1-gpiccoli@igalia.com>
References: <20260318190816.1811325-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D783814000E
X-Stat-Signature: sbb1a4zbm8hhmk7ytbpa777jon7rymq3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774315734-861705
X-HE-Meta: U2FsdGVkX1/YfxzCNgENtcm8comnhljJgwtCfYMSP8LH3oI5DLIGK5MozSPE1ZtRFkgFq1lZfHdi803r5M8xtCbNdEV/0bK2uFzWLVDS+fZ2tFV/iKDeQN/ZIf9h+SKMMRfnI1N+3i5S0IFLb2IKrPD1wJ7ECjVnw0CxuP+6uwYtp8PwGj+hLQrWdyMGpGJP+NO26dLHdIWhl3+W6Wubu14KUi41Kx85xFZ4Nmw/s2U04C357bY7Th3TO3gAm1ZnzWNPAL4I1YSyjilDCmeQe5JpUWvQleFddMm0qbNkOI9HmxmOJ7pcHv8pEz0vnED8rhCHxzqEQnif4boGgxLe/8Mj39tiNNdjqU7G9n9zeoVMGBpMMDOntCWsoPh/7WnKIFAUDY08KUfPzBgS3kxhdXhsXB06CRyGThz01KGHgomsY/tfSy0fCFdwJ0YxmJYcmOSvny3FXlKKboNUTXldVWFMmCczORO+tVkx6EN5LqNTLj/O6RWP4LvtgXAA9cUewbinMEWauiXOoxYZa3lMMtGkQw/JmRK63qMTqM+BCFlCKoeaeee2KUFelHBwq4njGz7rWiImZe44xGE6kuyAADdeY0DOSx1oXk8+mL0+C3nr3NYdQZe5vVvp4hk+YusvyULbtW2+Y1kbze0mg9MZCBHXV9cI9ImquI6eaQQFgaB6FF6ZRVA7+72MqVg2B6DXFtpa958VZJjLEzRlvGW6zKvfWFklrQhQOvMlgFVj/u0ycpXbtmD6Qt/56j3pXE71hISzweLbgbJauLx9zbyzUvnCumZNF9rmNCPXb+dYv/paXLok5PEQlRiCzIPjo8CJYmYbjVxQGn4IKFRLY6ctifYh7ZOuKGjZe2V1MdQ86q4HANz2Nm0aryrVVDTVCjLYW6Oo3X0DLJAOtbA3DyVoS2YCcgHRCIcMAheUTB5zsySuIStgBdinv6Afe1zs+jYGnR5EimYVneCWeUivh68
 ax4h1owD
 Lc+ELYW9DykRKcPsL741SL/nL5Seyb+TAklfN2OMOtIgOrdSNpHRJ0jB+9G2Smodnp3bJk5ho4j1mUdHA3A9qNmmP1NrICvCm+mOdb1y0EiAKiOZh7a9iLb6dMc7gl3beMTDYUVb84Q1RY82qxKUKR8x1je/GDnyDF7ezypx19Wv+Bq4efYFEsU4Pm7MnnUrQZT2jx1bolQCKCnxyrosHBvCMgyQN28LJN+hFkNnRfe0vQmE//9LwmyUporwPaAj/onk0sqo/DEKsuH5f3l5jEm4j3649o/kt6+itnYsf1Ur/ZNkzb9c5K/rslu6gHyBXmrv0hKNJikLTftKtltVwvuWhp6uFFUZZV5Bx82FC4n1KQCZQyKKTf9UqgPt5Blykju6VQgOb3+lqo4fzVS+L6a1SKK0+lYcAPMkVKLmxjY5/T5aNwxjZK3iCxBW6v33yF34Ik4LF5rDoBlU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The parsing of kernel parameter "reserve_mem=" is subject to
multiple failures, like duplicate naming, malformed expression
or even lack of available memory. Right now, all of these fail
silently. Let's add some messages so the kernel log can provide
useful information in case of failures.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---

V4: no changes.

V3 thread: https://lore.kernel.org/r/20260318190816.1811325-1-gpiccoli@igalia.com/


 mm/memblock.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a80..ac08d7f8c15e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2642,23 +2642,25 @@ static int __init reserve_mem(char *p)
 	int len;
 
 	if (!p)
-		return -EINVAL;
+		goto err_param;
 
 	/* Check if there's room for more reserved memory */
-	if (reserved_mem_count >= RESERVE_MEM_MAX_ENTRIES)
+	if (reserved_mem_count >= RESERVE_MEM_MAX_ENTRIES) {
+		pr_err("reserve_mem: no more room for reserved memory\n");
 		return -EBUSY;
+	}
 
 	oldp = p;
 	size = memparse(p, &p);
 	if (!size || p == oldp)
-		return -EINVAL;
+		goto err_param;
 
 	if (*p != ':')
-		return -EINVAL;
+		goto err_param;
 
 	align = memparse(p+1, &p);
 	if (*p != ':')
-		return -EINVAL;
+		goto err_param;
 
 	/*
 	 * memblock_phys_alloc() doesn't like a zero size align,
@@ -2672,7 +2674,7 @@ static int __init reserve_mem(char *p)
 
 	/* name needs to have length but not too big */
 	if (!len || len >= RESERVE_MEM_NAME_SIZE)
-		return -EINVAL;
+		goto err_param;
 
 	/* Make sure that name has text */
 	for (p = name; *p; p++) {
@@ -2680,11 +2682,13 @@ static int __init reserve_mem(char *p)
 			break;
 	}
 	if (!*p)
-		return -EINVAL;
+		goto err_param;
 
 	/* Make sure the name is not already used */
-	if (reserve_mem_find_by_name(name, &start, &tmp))
+	if (reserve_mem_find_by_name(name, &start, &tmp)) {
+		pr_err("reserve_mem: name \"%s\" was already used\n", name);
 		return -EBUSY;
+	}
 
 	/* Pick previous allocations up from KHO if available */
 	if (reserve_mem_kho_revive(name, size, align))
@@ -2692,12 +2696,17 @@ static int __init reserve_mem(char *p)
 
 	/* TODO: Allocation must be outside of scratch region */
 	start = memblock_phys_alloc(size, align);
-	if (!start)
+	if (!start) {
+		pr_err("reserve_mem: memblock allocation failed\n");
 		return -ENOMEM;
+	}
 
 	reserved_mem_add(start, size, name);
 
 	return 1;
+err_param:
+	pr_err("reserve_mem: empty or malformed parameter\n");
+	return -EINVAL;
 }
 __setup("reserve_mem=", reserve_mem);
 
-- 
2.50.1


