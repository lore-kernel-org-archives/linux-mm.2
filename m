Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0156CD4F50
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 08:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 474D98E0003; Thu, 13 Nov 2025 03:40:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44B9B8E0011; Thu, 13 Nov 2025 03:40:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361148E0003; Thu, 13 Nov 2025 03:40:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 27A7D8E0011
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:40:38 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD1074D41D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:40:37 +0000 (UTC)
X-FDA: 84104937714.08.1B3581A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 396EB20005
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:40:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=3H2qB260;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf13.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763023236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oJ3MIZLrxHKL3HXjB9g5ZhKNNJWUlT+3FdxZLvo6TYU=;
	b=3yDt3kMtend0Xy9LdRJ7+qAF/O6Suzhs+5E7CbJiMd+NmVtNSmP+KVQmIURfjW2+YU2+Q4
	yJkRkuVV11JFU5hRf824RoEIO/t2MRVqQF9iVFSguEVJ8BGjdR9omIh2u12PNNR4kKmHS6
	Um72bA58DmCZ/FywaYoyrFfrojjxFPU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763023236; a=rsa-sha256;
	cv=none;
	b=Rw2afOZGgcK5zL+xzOfY350rWSamw8YGLxslnoNc6aVHZOQu+c5OmnQJBQJ8c9r8OFA2E3
	dOojfHahlgsdugcqwkI8YHcOe+vFreVmbs4bHyWftHKpHSbbphXgDv3koEHiBebop7Q+iB
	7NZu1kp0zbazHXYb85Hh2JxlVTnHf9M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=3H2qB260;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf13.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oJ3MIZLrxHKL3HXjB9g5ZhKNNJWUlT+3FdxZLvo6TYU=; b=3H2qB260bJGzdc+mmZgu7gbjP6
	1tD87ZP9O2SQYeVz0R5sOPzmZUiDzhxP5hMx4R7leLOcXctMCAKcG5vKLyy9X+ppA+1/z49+ZC2KO
	2KpYYgSaACQwf4BzVa7sPYVcLw9ABkTLAakb1cSccaVOrDJi6Kpf3gYH4WSokTCp3ib8fsjhaaTDC
	wAMU/QnGPc05g8wj/PrFiL203dpiEripAEpep5/4LLaxLnUq02mJcdQPKphySrabkUFuQ36qIVpkQ
	uoB7AeMpdvoml9M8Tp/iYlTBhsLy52Ipw5QoVCCT1q2StYTwG6fR6WbFgVrGOLdjF3q4Ufn5hZWAG
	OHBPvXbA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJSsa-0000000A7Nb-3vnA;
	Thu, 13 Nov 2025 08:40:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] fault-inject: make enum fault_flags available unconditionally
Date: Thu, 13 Nov 2025 09:39:42 +0100
Message-ID: <20251113084022.1255121-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113084022.1255121-1-hch@lst.de>
References: <20251113084022.1255121-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: cijb6nqg8u33gypeimbzsx55dbqcbbp3
X-Rspam-User: 
X-Rspamd-Queue-Id: 396EB20005
X-Rspamd-Server: rspam10
X-HE-Tag: 1763023236-896190
X-HE-Meta: U2FsdGVkX191BsKB08q4g8OdTyrwbpfO8labQ6qytLCJ6RlgRRiY9BGhQV3wKEo0UqTSasrOX/AwbjO7upzoPjmj2qXWoC0Tn0CMB71AYdSW7nUWspWLhUBFXNbVqw+Lu9cRMZSWuDOZlp3MpI6Jo13iyoj2qSKyNQB8GoWpgpt4JznmZ4V0lY9k22+rujZyMN/c06FXm2TJQQSiLHKpDUXzZL5+3Cig0YqX95A+1F6feBxNPjf6bAkaBYzdAr4CeeGATko52RhyOb2PLZgrQQlZreWa6wUt9xSQjtE72USBf3vogVAR6Bh7DZSnyHm+/TXIaCi1q/It4ieRzWYc89/A6kkB2jkQv5P+Niz0xZ5Oa19I/inm34K+9rhp5wTerVcTM2FM5j8ffiXXI9OwhgX4Z8SqoQrH6YHE6vUX0lACih8Wkb7KgF/Y1bz0GgjYpvopV6Od/872viUVXcuZoF1gZdzWmHFdEncaW6DnR83/K7wI6kC5SUJ4IhaQBgIVYkW9dKFPEs56uDQiqAm+rxzsDapTNhhKPmWzhnBOcGM4zQo1m9+1/KyeYogkvdNjzj7w8LVUgMsH+jIuvFoaZtnnDHw2invQJGRarX6Y/tSOxCYJwKQzELzjTauyDSQcCb9tCIUKExY09WTSGDLMpZeQnCbZlRpiNzoH/mcb5oTj7JirZvdlPXRwE/r4yEO/0Zz5RF1XVSP70LTF1Hq3yTQK8/HuvOMm7Ggq+lpwUUwUW0McaMmA+L3WQIBBlUnLgOQ+2GJqGh5bbhFqYHbGlvBs0KaywA8foGBlHCI060tUcmHnOqmOyntLh2b+t0ZtwiLX8kaWEZaxoR4g046gLGFKVjt4b+iJTNiWImU8sWCHIlB01tsQYZ9Jz9vs+q00EnLja4UcgH+q7lcL8UKMwN91oTJdhbrxqAT0FbbL0k3DOMhTXcdhOSVnFfF+VEzZtn9PhoFM8NVOae8Ud0r
 UChA6qd5
 Aog98rDBKxqx1/xfVEjyM5jsFn3r8djCLe/K1oWe/i3+9w5JsuDFtdOIPr8yhKF5IZB7njBVhf9cIv57VcH2kUsrsldfscq0qJ19Qp2U86uo1REDQKn8jGE+nJ4RRfBbtbY0uwHjQxEMl7Vii/tmKkOzpF3jHQkLg8/nVrIvweNdaLc1HeLuRuldX6jHqj+zKI0dcPw5GC7opuMXskC66traSP/r3h5aUts+6j3w83IJit27y0WApq+g2bMt/6Ozhav/6dWoI3GbMAQ7RylZC6Q66BORqJJ7yiffqbyWRnLraB6mJcLR/76LFCaxy5AhGaGRhPO6FSPgUcwH6dPdaKsP5761sFUnWi2ryZGQqJyB3kxHUPKt8vTv/yG/z/dBazslJMT+c5R9G8NDgdI2DeJ+JA6ayyapYkzBZsI0shcNdS3fodp/GoRaIU+ViRoDBGcqK7+paY8gvuxgJGVAdtePCk/t+edyd5liFrMz2/ag1MY2LY8O3E6LWMO0ajOZw3MLs8drx5lZt8x9wJO2eJYyN7/iwAhHALp4OewF647ebTvFema9DvQCOEq+ffl5KnM3VcsuGQH7WGXg2ZazmkIPsRowRRuOC5JfNiB1q+WAmzOWQmotPHb4gqAObirOufEhZAhvBnrXJMn4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This will allow using should_fail_ex from code without having to
make it conditional on CONFIG_FAULT_INJECTION.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/fault-inject.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
index 8c829d28dcf3..58fd14c82270 100644
--- a/include/linux/fault-inject.h
+++ b/include/linux/fault-inject.h
@@ -8,6 +8,10 @@
 struct dentry;
 struct kmem_cache;
 
+enum fault_flags {
+	FAULT_NOWARN =	1 << 0,
+};
+
 #ifdef CONFIG_FAULT_INJECTION
 
 #include <linux/atomic.h>
@@ -36,10 +40,6 @@ struct fault_attr {
 	struct dentry *dname;
 };
 
-enum fault_flags {
-	FAULT_NOWARN =	1 << 0,
-};
-
 #define FAULT_ATTR_INITIALIZER {					\
 		.interval = 1,						\
 		.times = ATOMIC_INIT(1),				\
-- 
2.47.3


