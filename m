Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2F42C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 02:55:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81496B0092; Tue, 18 Aug 2026 22:55:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0AD86B0093; Tue, 18 Aug 2026 22:55:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D27C6B0095; Tue, 18 Aug 2026 22:55:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61BA46B0092
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:55:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E7762803E3
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:55:37 +0000 (UTC)
X-FDA: 85116503514.10.AE926D4
Received: from mta1.migadu.com (out-37.mta1.migadu.com [95.215.58.37])
	by imf14.hostedemail.com (Postfix) with ESMTP id DBDA6100007
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:55:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sWzsNKUY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.37 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787108136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vQmUlerGIfmDflb91fg4O+jH4m7vxFQJPaUYGL93Kk0=;
	b=T/GstHK+VExnprgaYtg8gbDYKyLiYPqRvmTUnQ7ATpbqRpBHRLowOx1VeJefvu5ZBQmYwz
	duGlmRL3YokauCEOgL1hcK9lHLrAUOlDczTzk3Di/T/w/mL0w0TLEw/aNApKg4tPo4BeJX
	HvoD//Tfb/z+mhz0/JU1j6+4L38LHnU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sWzsNKUY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.37 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787108136;
	b=XF84FuCH8AEPI2KUh84kHTpzpJfYt56j7ix6HpgZ5WARQFEiMUHxa4PbxMhxucXECnMYXM
	3DBEIyNkcN690D1t/TcrzM4lpnvGWxVWdAtbOtisM9Svra0cegvraOQSwKv5/CbbEHmwbi
	ZttO+lem/24Q9Xj4mul2FB0ja4pXkJA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3S5O+WmFCYTlfNAAGG8hR3gIY7XgRoq+MHcx43aEOyU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787108134; v=1; x=1787712934;
 b=sWzsNKUYwhwa2tA4WrFgkElEP4ujCKXDuzDgc1GltC7mQYovHgzLz2bkceKAJzisJRLwGdTK
 8wcZvn0dxi2NXWkKw+dTxr+5Z6Ch2KeQmqZ0EoZCQNqGEsEaCBPMZWy9yU+VZxkBfl25YOYz1+Q
 sThh9w+IToPJBpApEU1LGv+Y=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (223.70.159.239)
	by smtp.migadu.com with ESMTPS id ab08ddb189ee31a0;
	Wed, 19 Aug 2026 02:55:24 +0000
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: Ye Liu <liuye@kylinos.cn>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: [RESEND PATCH] mm/page_table_check: add explicit pmd_none check in pte_clear_range
Date: Wed, 19 Aug 2026 10:55:15 +0800
Message-Id: <20260819025516.2967199-1-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DBDA6100007
X-Stat-Signature: aoz63j98jywj1eq3u51gfotbxch17awf
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787108135-109337
X-HE-Meta: U2FsdGVkX18ZuF8wFXrNBbtxldlxVOcoKdxDqVnC/YWL8q6gYpG46IP6UI62jwW8ZrzLURHaOBP6dygpsX9jByrI6+1Fau6949ZG4aEh9p8Ggp0fbX8+YlHo0wrE06zmpxMHSpSPiMK7Z7078NH/8GACtTbNvSMuSKlS/6VNqEQ/TfbGM7y6gZiBlNXFU3ysYwYxb4/zOgdZkQKI9CPaKshlUPPjhiriwCZ4luRqSyHhiUqltOlSD1OGj4AukUCcv5jYFktpNW8KT+wvuZShR1vgLynJOFc4t1Ckz5nBMWyTEGltr0qfqKHnx2wfiXw1lspNeePZgbkgIwsNNtp2uOkEn8rEYSqVSye5KGL79u+XLdMq5BKuupCo3YGHSU4lcAUfko/5ZnTHFilHqb2BS/praANkZz4P+hV+c7rD9lLFh+l/MGsG5vRbXv+Pw9csD9pK/s0Ri70GpR5gcWKokbWzV9CR2vjejvlEAUcDlYLXJAxnU5HEHxA/0TtNoDpg132MqqA93sF4Yri1uCQ6yeVaOYxHQMoxiAeH+8uj5irKWeNIm0YqNmWlPMtQ/Y4Yjt5J8fGvxghKJMy9bVE6mOUzbRxnOcUorEQa4WFGP6zeiurE4uThK05ef+1BH9vxQHOY6/6Fygy6mE3QIZZoR//2JsoFJfLUQyVdON6ZEgWjBYTzEc3iagmjaO5JCNKRsUbE0tu8McB2wP4jlt6sRooPpYQRgPNIwjuRstnFPjH9XE8d1zEANGz7W2YuhIz+iIXsN+7H6exrZaXQ6GhV3Bjz5zOeJxgSc1QI53feAAZwcFHJHlDx0ofEjRDqjIxettetsFkuj0zZT/YKqE4la1cIg5MjJCDUrTIc2UHAykFxpmBwr12ssNsp5e7CFIbNv/XfODiXLR54dqknParJroWWXaJvH/KChIv1zY25qzqaRhujV/IHPFVyjTrO4FIp4HdidJ2w9GT5JxMBFHt
 fqzZDF3M
 pKEXh+4m2H2AEU0sSFeNy2KErCE+eA7PuyfVSQnZiEcpW9V/7/VCuiNjrpDiKrz/F5TNKb+bwDApYW7kAwiJLTdPeNupZnBJ2mg+fhjh2A/XnV4tEvbFfmE33aIU9KzXNknCD71Q9sL70NBhk3PWBYfmOaSePEB8zzVwxCF2Q/XEykSb1h+KMdv/icoZbC9QLtP+mCyw4AyL2LKgswQc8MXgOIeuVN318V3pp8sCVZiR3soMI4XNVpgBo/OySH1gadcRD5JK/NGXOEL+x6AXXIOdsqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

In __page_table_check_pte_clear_range(), the condition to determine
whether to iterate over PTEs only checked pmd_bad() and pmd_leaf().
This relies on the implicit assumption that pmd_none() is always a
subset of pmd_bad() on all architectures supporting PAGE_TABLE_CHECK.

While this assumption currently holds for x86_64, arm64, s390, riscv,
and powerpc, it is an architecture-dependent behavior that may not
hold for future architectures. Add an explicit pmd_none() check to
make the intent clear and avoid calling pte_offset_map() on an empty
PMD, which could lead to undefined behavior.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/page_table_check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 6ffc536359cd..ed3e1a76f266 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -278,7 +278,7 @@ void __page_table_check_pte_clear_range(struct mm_struct *mm,
 	if (&init_mm == mm)
 		return;
 
-	if (!pmd_bad(pmd) && !pmd_leaf(pmd)) {
+	if (!pmd_none(pmd) && !pmd_bad(pmd) && !pmd_leaf(pmd)) {
 		pte_t *ptep = pte_offset_map(&pmd, addr);
 		unsigned long i;
 
-- 
2.25.1


