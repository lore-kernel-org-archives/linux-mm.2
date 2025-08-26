Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36F7DCA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 09:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59E5C6B0190; Tue, 26 Aug 2025 05:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54F6A6B0191; Tue, 26 Aug 2025 05:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48CF96B0192; Tue, 26 Aug 2025 05:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 362A26B0190
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:36:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E9C261606D0
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:36:46 +0000 (UTC)
X-FDA: 83818404012.16.31B59B3
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3ABB1120010
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:36:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=llTPnz2r;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756201004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DC7TigxQIJI88XZibBjtJx3Fwr28TQ6z5OzWaFAMjtk=;
	b=YQ4XcunpgD/UzCZbGgsD0DdL95kB0L4aTwCT1tebcXCdK94cVNXOErSVOjikz8wHrMdIhp
	NO5kWwErQuT2l0RmFnvzyh9NXkKaPOjkZcNYiytBayHCswdPGlQ9OE3erkHjVEZ0C6rTSM
	oL5SzaShwHiRsfq/oHOxywRSWyciUZ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756201004; a=rsa-sha256;
	cv=none;
	b=zXJlE1sejcu7y2XRkSrI7pIufWDK3mXP47j1xAeOJa6U40MwZFZ3E0JYXCp7lD3YaFUdAc
	CZLNU5Fn/zh9TTOiznxE9IiB+okYeNYvIKb+NBYcSq8mcBLJu4waR1zS9HlzUo/pXNMu1u
	xgy6nUF4umUyVdhZcWS1F/TtfEO+lx4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=llTPnz2r;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756200999; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=DC7TigxQIJI88XZibBjtJx3Fwr28TQ6z5OzWaFAMjtk=;
	b=llTPnz2rSfZqhlOEEsA+a3nvccIg75W1KnScdIRWlGqbz4iPinpuSZ74Cv7uoN9/50BWrRd9KEuDf6UInExxU+Jk02AvopjNZ0Z4HPTeFxSS7k8oNdN5QJvNzob8PjUZZRuchVWaI4cFj5a8hdO1VS9LRvHMUR5cHR+z3xv6y+I=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmeLDsQ_1756200997 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 26 Aug 2025 17:36:38 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com
Cc: baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm: shmem: use 'folio' for shmem_partial_swap_usage()
Date: Tue, 26 Aug 2025 17:35:54 +0800
Message-ID: <a2d39608d99cba1130cacd9cffbafc6949193c08.1756200587.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3ABB1120010
X-Stat-Signature: 5m6timfddcs5wu9ykhrpu37443okmryr
X-Rspam-User: 
X-HE-Tag: 1756201002-555689
X-HE-Meta: U2FsdGVkX1+1p0NQAUBMjPA5pObH6ixwejedEGlaltafl5pHIpRp0r8vBSivFSMvVx1Dy5OjT2PWn8yPa8kbIaS2+i9bEIHYlz3bvz7C+MHJElkOGPiJQlMiVdYldNCmpVmb5fsiDK21tbtNUl8gKyfDOGPcDY40q20UhRk4MruakG4RIr3O2uJIoW1zwn8G/rbLMmG3Ct8RjpUp+x+crZFcarjdTlbAqr+6ZHUe03zdDJsgixpKnyR4NkTBbYUP4gXncL7HRgRgFSvcb09K6oiZ+3e/lnztFLPx14/4JltJATh1krNeHd2FEEHuy6/LBYrOl5eI2pPIAMaPKKqL8uLm+h2AmM4vhZRmWunhsOqVayOBQs+lAsHP/wWKPLTbwADYYXwnz7430D/Nc85NjiFdyBwxqO3i2XouLRr/+P4ZDb0eIlhRB7aAvxb/BDBQk8B4nMIbup77N9Ng6P0Pj0W0kveKKJpxCuXnIzbgdw5vllXu2SMsGhLJw5c1ZyL0g8z+q0p8LMgRth5Sdb+fNtrmTJa98IWr4U+MDR/5FBuo+hlvBr0KXp/FVkzKsVvN9TJhhidCTOCJTy2uyG4dtYzSESR03EtRE8YUwd+gLvlCAQP02oYCAwq0qMoSVf/UWS79F8WkCvKbiAMOLpmdPaItBM7JOZBW+bGBWxzqXpeaFlSb7qRp/N5/e0vPf3xyg34E3x5XzDzVbcWrcgMGdBds7hCfuCGEREL9/M9FtKHvvNnclfp3df0XLFbRAlGW9lbu1jS6tpFR/Me53LwgPJv1OwIvoggmh5ZotD2MiaEzGIWpdNkYnLA7pAtLunuv2hpdr6Iv47mg0bre8ZJy0vzi8KMpZ+szTglQcx2+q+vvEnCByUqrtIseBAnSppANCnkOWo6srZ4w6p1nWLCGk1KEn4RFQRCN+HzIEVUbZYQo7r2uqO5yaIz+hbWNQDvwSijReevruIa1Vc9liY0
 7Q6PMoh6
 D8BEY4Be/vQ+Ea7M8YYvRGoShR1JO83gpy871QGFntahv8tJOMEz3ydLoSgT3IszMizZh6jHQXjF5vdt8If67hl/TGXhybihctMkPVQSBoEwy/5Xf0yRv2pkhqpqlkgOYNVYrhj5n/9GEF3nmxrWKWWdv9e9DuJzjW0khfYrChnglc8KSj8aqlLnU7m4kdlYcMhTuKO/vJ5jqPg+wJglYxYLlConSyj+TFZRqLPBvlV51CthTrREMhkkbAJjsmZBDuE1Lh7t5HbOF3fvyNzq/A8DWD6qPnnPgY+yBmJFPcSR4FPXh0Ubw6VmEL2OuPBUXzVUa+TZef55xHoA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is more straightforward to use the term ‘folio’. No functional changes.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/shmem.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index a360738ab732..b3c6de84dd27 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1006,15 +1006,15 @@ unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 						pgoff_t start, pgoff_t end)
 {
 	XA_STATE(xas, &mapping->i_pages, start);
-	struct page *page;
+	struct folio *folio;
 	unsigned long swapped = 0;
 	unsigned long max = end - 1;
 
 	rcu_read_lock();
-	xas_for_each(&xas, page, max) {
-		if (xas_retry(&xas, page))
+	xas_for_each(&xas, folio, max) {
+		if (xas_retry(&xas, folio))
 			continue;
-		if (xa_is_value(page))
+		if (xa_is_value(folio))
 			swapped += 1 << xas_get_order(&xas);
 		if (xas.xa_index == max)
 			break;
-- 
2.43.5


