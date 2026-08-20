Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C745AC5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 07:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF0206B0098; Thu, 20 Aug 2026 03:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA0D46B009B; Thu, 20 Aug 2026 03:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DDA96B009D; Thu, 20 Aug 2026 03:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DCCE6B0098
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:59:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 00562A2E83
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:51:40 +0000 (UTC)
X-FDA: 85120878360.01.90C8398
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4142040003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:51:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EiktMHoK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787212299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYWGm3JCncYh75joMZsEV9hCVt+QeCSIIV62iiS77nk=;
	b=mUxyXM8dfv1EPMaasGUQzHyqcTX8UH5MSPpMQtnGaMZNl/rj0PnEZd8gJfU9w0mA6fyb9J
	Di1FUDhm987D9f+Qcur59cBff/sN3ybizAyRNxX0Au0HYzhVLsrAyD7lhsyCqwVROGxBAN
	IKY17O8YH68JofxGV0bWBJFldvYplsw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EiktMHoK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787212299;
	b=vaKGYqW/aU38C0oJ4AMKr26VuFA2D3GXQSlVHd65bLkzXFbMyJahp/wFdUtMGL4AwDUbrQ
	R/ytf6PFU98B/51IUBFUiWelYVHZAWVJGYnnzVSOwvNJA3q5FJPdSvwv3OnSWcSUtYFGZT
	3XynYWs5Idh1KRo0VJlU+p0ZBJwAzo0=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ce7d2adef4so24872175ad.3
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787212297; x=1787817097; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BYWGm3JCncYh75joMZsEV9hCVt+QeCSIIV62iiS77nk=;
        b=EiktMHoKkL+qBRlyG9x1N3TMW7Z3ZQsajnKoOcXkWteNg3qYZVMnPoRGuRNyVmBVZ2
         eIHNwhzGBwBLStmYKeSvxDWy9xYBr7YnmM4SZM/Bqb9ZiColXg6uW7kz4F+6Sfe9wb5Z
         5rNna79xv5+Y3uUwd6WeBfIu2TXe6fKD258kuDex3JrZ117JkppUGbiL3mec74SQNInp
         GwVmJa0ei7SQidf/gRiQd+YcioNUBLnbT2kkGx8SGipAzqoxJZBSSh0nWY+6VMemkH6p
         Q1B/B6PPRD1FkvhcVqU4zZaoDKAzPIjv4wmMrefBtcBhpII8tUF5F6E/2nfYNjT3G3Er
         OT7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787212297; x=1787817097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BYWGm3JCncYh75joMZsEV9hCVt+QeCSIIV62iiS77nk=;
        b=KvOXqSd3ebNKMJUZDSRo4BM+GV663MFyfcUdgF5UBSI1e5qfLjlA7u84zjG0sFHajL
         Lc1f6EF7eQlySQqZwKtQ0fZzsekzO5ynRbKXEUtZby5aEXrK7mBgPHHQIHEhZldbUuOe
         FdZN8GqExw3UyN5shEuENDcusCsxdAsidzKtIyiqf9pxbyEQLWyGVmy2VOpt2dpouVf9
         wjsjXv20U3ablsNbyvA3hFZR5rbeb3NtF61DLHK7UW7RwReNLfu8I6iBTla+SJvzYBAF
         adHP3NmtUaUwcPRR/T2PxoCcOYlrRq4Qi0T51ay43zpfg5oyk3J2AMR/62YlCdK0VMtD
         29EQ==
X-Gm-Message-State: AFuF++m/EEl9hoRmVuUF0LSwa9nqm+S0UBkqpLXT6tinXNDsZsgHWPSY
	sTrJFCyu3O7tQsptwQc5fflM4Tl257mBP4khg27UWc36JfKtV27pOie5
X-Gm-Gg: AR+sD12L5QXO68keVD/yLH+Z+/UFd+3Fcjf7rAun0qMPqHTXwsUGEe6/9T73yjZ/S+C
	R+gBnx4a3vrQRdAv0+Vfu3eVtNLQ9+m34Yspl4oPl+RTl6nPy/Eo0x6UPtppoRWCt7nmAa1Yphe
	kHIfMzspHoGLYkyaiHPUXTu04Y6hqqTUzVIgmLRKj6GM3TVzgmSxg1vAcRsc6ujdBTV9o9xxJVT
	jT7vm8lwBkVyhggTsCPJAk2MqaLK08gx9HomXGSMj2laYiQybuAn3L3pB1WA6PadZKmGXVwNPSv
	MkEdPGFnW7c2g2JMbxK+cNRG2mGBmI1NiTFLY/9ead3QjictkHehkIHB5k97V0GqQkimU3qY/+m
	6Ff6yJ0lrS84J+o6XGgoRFlKTiqTtzCBHpqHkT/TyZLhfLIEWR87TvlTPXpU3sT4GqcNPmt4NpV
	LrQzTgYqvWW3muQyeoRn2jzlMfoWh/1vZ4vEuyEwgDoHVO+pJUeGLTKaPc0msZ2eYu6A288RRpt
	HdiyPUFFQwL5FoRGvVNoAySUOvBmQ==
X-Received: by 2002:a17:90b:2810:b0:381:e74f:8a6a with SMTP id 98e67ed59e1d1-395810a1049mr21829261a91.16.1787212297013;
        Thu, 20 Aug 2026 00:51:37 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395ada67783sm455429a91.3.2026.08.20.00.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 00:51:36 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wandun Chen <chenwandun@lixiang.com>,
	Meijing Zhao <zhaomeijing@lixiang.com>
Subject: [PATCH v2 2/3] mm: memblock: show all region flags in debugfs
Date: Thu, 20 Aug 2026 15:51:21 +0800
Message-Id: <20260820075122.3294367-3-zhaomeijing100@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260820075122.3294367-1-zhaomeijing100@gmail.com>
References: <20260820075122.3294367-1-zhaomeijing100@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4142040003
X-Rspamd-Server: rspam07
X-Stat-Signature: w3j7qgehwn1kwu7e6hnrienj8kkwdbcq
X-HE-Tag: 1787212299-767878
X-HE-Meta: U2FsdGVkX1/Je613mXnmMVaB0Kwf+KXVlz/iqiwjuKYKPiFNr/H2z8tFRywhDbttNHmJE633Y6TCa886CZGzDaHSJz55TKZyjmm4wTJagAUjhs9BQW9u6/Ypz2WmZgsai56E99biqsO2h0+n2DxIRU9FdUAzbxT2JFIaOOSLQH/ioZcEZOlU+0syrhpK2Jp5NN8flfVgvsmtd/gBuZJOe06luLsdwzJB40F6DlinWnczrZzR2mEoz+n22Z22Xj0/g7MmG9cSqkusbBPlQq+KXoKhhvDQxSmoTn+P6G/dMj+LhH1crlAnIzIJGynLsqut1JThvgAx+/LEZ4d04QobBb1b5g9u3t0VKy+WD2ZaqK6NLfn+E9jLAqVYQhq0t3Ac6Ayv1w4C81SmQ2QLLMBYSbHATyGguIDpLFbT8a9MHEGFcxCwAcaA1VoF8Lb714y5gHIJHeDUNk7eoyJKmcDyOK8Nh4cmswiIjcSjQFNvIo24vkiVLtn25uSsamV3oSierosG6Ji/Nlw0Y367wwPMBIWXlBDObaaSc50TmZFtbI/7EPaptJASOL9DzNw0AfcDwI73bB/nT/RQAOiTSeQnX4LBbMeLPCj7Zq7gWKDvmbfuCvmHxizT1rcYiu32PsqLb4kutpfF7ZQnpXCssKBoEF4/68DuU/j/0x/NauuHEKt8cvPu+BFdR/1Uqynstibrevo9MVq1b5qSBM+ltyjrU8bFLiDuaIa0XvnKEUx7i5NaxGIzxQ0BZM7KgfNY7TJQxH3Aj4ntndCEESzqS3DQ2W8U148gIuWxP29+h7MJVkzRbSknP/qWflBHcNy0Glgm4NoTrG6WPKGMzQBAW8/gCKElNnn1g+SDveNcxqzmFTLLnr6Sh6M9QJTzZc8JxHZrpo23Ab4OdshFImM7iJVoQ25uPOC/3NSjQ5D4+vDVIBYHw8VhmERjBHkAvpKa1kx894OsJ0nwtDrJKpyMdlj
 5wTAbA36
 4ASftnpxCbUNsUwMx+Qplh1XmKkRqWbn7pEDKoTfz03oBEV0tYoyyQehmFr3a4/bimiwcezT94ARh4spOKQWFSofH7YtZHFgW8dMmQDucXhOc2a8C3+a6oVHW6Xezt4HeJ/gR9jh9YECnt+LP99YQ6wm3kS7PK91U+6wrtRTTTwKZQ3nbPU27xJl7uCVXQacHoisjuLo2WhTxAxagHZWZeSL/ifDyxWoygDOI9TwsZP8zh81Um8S9e06EiUYwMQj52GQg+mGgcKSlHBuYBEdwTYl+HGuwtsGNSUbxaE7wmK9KmkyKaqOevSXDaY6WXRkEy+AaZJ8yZOpzo2jPGZ88Ry1ZYLEGFgx1iSeXDmBFDlRVWwcm42pvlIxXx5iLxY6G9/jGH70LRVLX7lqxALa0tFMElIhUcxdJAvd4ATDLYcDLKQWt3iJPtKP9G/oDG9MVlvMDExUPI1dQsHbHBiaSqshttA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

Commit 493f349e38d0 ("memblock: Add flags and nid info in memblock
debugfs") made memblock_debug_show() stop after finding the first set
flag. A memblock region can carry multiple flags, so debugfs hides all
but the lowest set bit.

In particular, memory allocated for HugeTLB pages is reserved with both
MEMBLOCK_RSRV_KERN and MEMBLOCK_RSRV_HUGETLB, but debugfs only reports
RSV_KERN.

Walk all bits in the region flags and print every set flag separated by
"|". Keep walking beyond flagname[] so that a set flag without a known
name is reported as UNKNOWN rather than silently ignored.

A HugeTLB reservation is now shown as:

  RSV_KERN|RSV_HUGETLB

instead of:

  RSV_KERN

Fixes: 493f349e38d0 ("memblock: Add flags and nid info in memblock debugfs")
Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 mm/memblock.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 99f8e1bc60a8..7eddcc412618 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2912,7 +2912,9 @@ static int memblock_debug_show(struct seq_file *m, void *private)
 	struct memblock_region *reg;
 	int i, j, nid;
 	unsigned int count = ARRAY_SIZE(flagname);
+	unsigned int flags;
 	phys_addr_t end;
+	bool first;
 
 	for (i = 0; i < type->cnt; i++) {
 		reg = &type->regions[i];
@@ -2926,16 +2928,20 @@ static int memblock_debug_show(struct seq_file *m, void *private)
 		else
 			seq_printf(m, "%4c ", 'x');
 		if (reg->flags) {
-			for (j = 0; j < count; j++) {
-				if (reg->flags & (1U << j)) {
-					seq_printf(m, "%s\n", flagname[j]);
-					break;
-				}
+			flags = reg->flags;
+			first = true;
+			for (j = 0; flags; j++, flags >>= 1) {
+				if (!(flags & 1))
+					continue;
+				if (!first)
+					seq_putc(m, '|');
+				seq_puts(m, j < count && flagname[j] ?
+					 flagname[j] : "UNKNOWN");
+				first = false;
 			}
-			if (j == count)
-				seq_printf(m, "%s\n", "UNKNOWN");
+			seq_putc(m, '\n');
 		} else {
-			seq_printf(m, "%s\n", "NONE");
+			seq_puts(m, "NONE\n");
 		}
 	}
 	return 0;
-- 
2.25.1

