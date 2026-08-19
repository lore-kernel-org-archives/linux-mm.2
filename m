Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81D5BC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8706E6B00A3; Wed, 19 Aug 2026 03:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 848A56B00A5; Wed, 19 Aug 2026 03:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7364D6B00A6; Wed, 19 Aug 2026 03:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 37A7E6B00A3
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:54:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B282AC04AB
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:54:38 +0000 (UTC)
X-FDA: 85117257036.10.168DB63
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id F328A8000C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:54:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PyGO8RCw;
	spf=pass (imf30.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787126077;
	b=lv0/O2+qKBCzgACWAtgLTC5VB1yv+8bacV3Wd9wttk+NksfwS8uKm21AjkeyAyj5QbqB5p
	ihhvMeEd1kUCYazalP5IyyDpttquwzlMKlYbkeo+Nam8REuNrCl87putFJzj34D9J92OpJ
	8KnJ8LrpdDHv9m1cHNLn1BbEF1F6sYY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PyGO8RCw;
	spf=pass (imf30.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787126077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1St7cJMFBwCWDrIWciZLSeyUk7ee+DohomwT0PVBa0c=;
	b=NEdyEJPsepeYEDWlz6mnL68HN7VFdlt1s7jyEwTKYrrXWUphnESZPR4LxZgvw74yEbs07M
	4nLs0ROejlmC0hXtT5JHHKnqDFnevAzY1r0dGjG/ffyMMfAJrtcMlhKjHmOMRVNIgBHTwC
	d13qy6lucflA1v08+1NWE0wd9KqGctI=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2d5335cf904so5818135ad.2
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 00:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787126076; x=1787730876; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1St7cJMFBwCWDrIWciZLSeyUk7ee+DohomwT0PVBa0c=;
        b=PyGO8RCwi9Yw9Tl/Mi2tpN0zALwELWDKS6JNO1Hl46AXJ9mv8s+3fGN4VLeo256sD0
         DsE/7aeNV/kbHZaGDk0hwxUaZy7tMYwHu3whWhM+Altf0OZWNCC8n0ttG1ZanZEI5RK1
         Ye68b7a50PMHDsut7hJWZDNmsMdiWMZvE0kugv+k4e36xq6OUW6vbFy5gM5w0smL51UN
         wQvmCJ0jVv6JYty8cQxno7SsNtakGWllbU4UTJ7rBfn4qN9TsTlXxMBJBgF6gkDbtx+C
         N7Y+MZPbmHX9nSFqaYhO4XXWlPg/X1Px4pOsjWFhVR8g2iRUi6BJ9hL6JDDyf/ZBkqSI
         LG7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787126076; x=1787730876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1St7cJMFBwCWDrIWciZLSeyUk7ee+DohomwT0PVBa0c=;
        b=F+/3ybAWLvL51x4/jUEbPF6B3KaWyNYAy6phzNHTytR2f/Giqu0APePX2Y6NfQRAAp
         0L7I95wmsI9ZiBW8k9Dx99nwj8T89+I3gI4nZB1O+jYBWVnZ5ltEOUnMUpNUMOL7r8oK
         QE2+bph8P2v1YG6GVrPlLBfv8VN9cmiOTVb2yirCnV0/p2hgkyhRR36qLVjFX418iDkL
         QXAblbN8+SQWwoDEtY/6sH1z2XfJcC9GGu+UZK4b58O9RUVLWUbTmVInQaIa/R6fa/PP
         ms8hbTPp6C8p1K9gSTZ7D3GvWfbhy/CMsEQGzpx10TFZi3rr53QoYXnC2G2TrA3KFaEF
         IXNQ==
X-Gm-Message-State: AOJu0YzRwPW+lKE51Uz0ELrx+4cgT2aFCC3yMqadnypl4Z3+rhBKs9Sh
	9vrua88cr6pTgLCwqDU7j5uaaslK/XIXKAOQAfJF1BdvLHfsBydcgzFY
X-Gm-Gg: AR+sD115uLxub/krHMa5YDpaxRtHJnvBu/bjAkgOzhwHi12y1oBD3cyEfc041MVg8oQ
	8a10ViV6k66e2M1F7I5NQ0hGXzAzoPKE4FTi+/bMiVG1HhsbVI8L2Sja+fg0CyYaUsgIAw3VLB2
	e8hxjo9mvsFCoYHVABAJwRKImbCFg6FAht8MyVO7TXiHpMPa9Itlb+zAiPVZ3YE1RPYhNs0TiKg
	SWtLad9RvVi2BwNSyyz6BtSVggVXQKrwbHOLj0CAym/vHfUWF2/PMAN2s87m4c7vlwo0/bmbsMr
	jClucE7/PPZE2vwgE0lJYPY3VHyI/6RJFa4TouHRUoG6E0hkLzz7eKJYOWAYfDxxdGa+8dIFvC+
	6hLBY0GzwAIzgEB0cjDuf0RNup9MzDKYIE1SgajUW95U8Mc9WC5nrjLGcFvdk3AtCuQa3NdeEUp
	5kaYdZJYHg39j3/dCGST+1xSPdXpfVf/s9XoRwDWR1YHh91DLN7od7e6XddjH7HKK4RGlcuRDzU
	K7es8LGTb18OerP7vVRWbtNguUH
X-Received: by 2002:a17:90b:3910:b0:38e:4cb:51f with SMTP id 98e67ed59e1d1-39581088755mr5432845a91.11.1787126075786;
        Wed, 19 Aug 2026 00:54:35 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957faf596fsm1668929a91.11.2026.08.19.00.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 00:54:35 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wandun Chen <chenwandun@lixiang.com>,
	Meijing Zhao <zhaomeijing@lixiang.com>
Subject: [PATCH 2/2] mm: memblock: show all region flags in debugfs
Date: Wed, 19 Aug 2026 15:54:22 +0800
Message-Id: <20260819075422.2387980-3-zhaomeijing100@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260819075422.2387980-1-zhaomeijing100@gmail.com>
References: <20260819075422.2387980-1-zhaomeijing100@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F328A8000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 6ggakhx7f4g8goktk5ffz4ky1kj177o1
X-HE-Tag: 1787126076-930889
X-HE-Meta: U2FsdGVkX18tiHU1WnfaBpJ/pNiL8m2tE3FHpAxS13FlyJgQkpYDogzCnVY1uVRKRo4K63hkLtNMmLFaFNQrJ8RV4/nl49vkW43oJw/SQqXmws46tZplq3CDFMnwMusTaBG9LW+OZb5ScAzZmGbqfW9jadqgpDJGBLIxDal/sGF18mfFbZU94d6j3Q6/jDCg56ZfwQqrVFcYiyYzDEUDc4+kSd1EnBcRNkMqsFjlCHymutZM3yJ3E02VIsfKXQvbP/SczLfpHf3mMbTq9cbVaJja6KOmf/ZQFlZBV0etqs6PUOiklQiAy4Ma1BH8Sxwe8Ff0IgLWIhNpqDm0Lc38GjY6a3gVTZaVNKEPKzUcnI6DyonFB4yD7RPj5xS+BjB1CXlOOqNqvWfqGL3P5awwUKVMcSHF4qgPuiM5cEE/RWSsEDk3B01TFQZafCk6ybwMPkJh3ucZ8/Rka7PiibtFGEnxzigG8IJgDMVlngG2OQA/gB/gTZAt1l2aqEuuvFiCzPKOfyirGnSuB8tUyb0byzAhESL/WUKSBTcNonIW/010aVs/ujOAJ3RQmKC2EBKI4SFFOHv/+lZNtdIhJDgG8e/yOgLFDLbAG85BILz22GEr3IhY0fnDl9gHJZStpgnXYNpfyFYZit5+Bb7Cdg4gICq9ugFuhyoc5Tn19zVkQ+1trAcDiNcyBaJH2LelVozU1iMA7yiF4HCKOb4rbUFyGaVvZgiH+4x/yTbEXvNX/1WsTnKYkns3w02H3IhQUBSpp/Tnxm6xVo2AgNNfGbcdP14OURTxO+EPCMGSKlFSV3FkYVHuPw5seEH7csJZ9T4ONV4blzZoVHGsHql+LzYbG+FuJQqWthiYBi3QGTcyKVjn1nZ9b3awK+NSI8tKDG2wkrfLZvtYYOcvrjl0tn+0RV2a+cYPsX7z+k/kiVzUQukKUkf187cYWmCi31pi/biqhstBDKWURpK37taoZlq
 /eqNmdn9
 UpJLZvqcgDvqyLWZ6aOOsXLmi49aaxJc8c6XqHLXx7tI7OHtjXA6tQsmMVYvLa9USeJyxF8Cx07YGHjO55PLJ8riZnLW8KMVOaw1qoT5IPHTSfxJ36IjgPb7iDodtPrBikhEC1gu+nFK3o65+lbUb/xoeeGKEv1LoQ+TKpqLguGT+iYjG20a+asdN1BKJyW1XgIHEIOk0yUqiLP7k3K83r9WYdKS54aT2ZuLMnk+UO6K8wV0DLvxYmeiHwrOvKvEYENtAf43LLoNCkJimfBKVhtqAlF7JvoG1t18lifpojvpMIFqsysdWHK6hzs3H1l+50m3Fzu0z9veazQWkyrD8XBWBI7rzcAstLeDXIRPS7ShwyFhfIZiiWJmVdADA9AxXvY/ep6ymdFPZelRmkaUVZ/jA4DZvo2p+4Z3C0RGhEkB6lgfUoYxG1Eorsj1F6dOqHsTdV0ofqiY9dOFGO23dLlhQPw==
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

Print every set flag separated by '|'. A HugeTLB reservation is now
shown as:

  RSV_KERN|RSV_HUGETLB

instead of:

  RSV_KERN

Fixes: 493f349e38d0 ("memblock: Add flags and nid info in memblock debugfs")
Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 mm/memblock.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index f2952d725c10..5d806fe92cd7 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2896,6 +2896,7 @@ static int memblock_debug_show(struct seq_file *m, void *private)
 	int i, j, nid;
 	unsigned int count = ARRAY_SIZE(flagname);
 	phys_addr_t end;
+	bool first;
 
 	for (i = 0; i < type->cnt; i++) {
 		reg = &type->regions[i];
@@ -2909,14 +2910,18 @@ static int memblock_debug_show(struct seq_file *m, void *private)
 		else
 			seq_printf(m, "%4c ", 'x');
 		if (reg->flags) {
+			first = true;
 			for (j = 0; j < count; j++) {
-				if (reg->flags & (1U << j)) {
-					seq_printf(m, "%s\n", flagname[j]);
-					break;
-				}
+				if (!(reg->flags & (1U << j)))
+					continue;
+				if (!first)
+					seq_putc(m, '|');
+				seq_puts(m, flagname[j] ?: "UNKNOWN");
+				first = false;
 			}
-			if (j == count)
-				seq_printf(m, "%s\n", "UNKNOWN");
+			if (first)
+				seq_puts(m, "UNKNOWN");
+			seq_putc(m, '\n');
 		} else {
 			seq_printf(m, "%s\n", "NONE");
 		}
-- 
2.25.1


