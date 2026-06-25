Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B51CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:25:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F18286B00A0; Thu, 25 Jun 2026 10:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF01F6B00A1; Thu, 25 Jun 2026 10:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8B46B00A2; Thu, 25 Jun 2026 10:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA79A6B00A0
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:24:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2783514013C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:58 +0000 (UTC)
X-FDA: 84918656676.16.BE22DC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6B04040002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e7ootxeA;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782397496;
	b=orqzMBA6Q8wDg+2uV3gFKX+T3CXDiFS5+oJqpYwfXozhU7VWFUoEHlNAdQTXQA6m97qrut
	c3s4h1N25NCYN7GzikJE5iI14bjRLbID8ulXBNNEtopNKH9KUPsMizEqz0Wx9yqE8xFVbs
	UAfuvsk012Duxjrpkpn625/sj12I/Ug=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782397496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QU3Mdz0QWuS68FFe2kfHvyIPhX+22pphhD8CNUTJFTE=;
	b=ys8yZGp4A9p5hQ5Mxt6eXBbnCgnXIaQBwBfPPSNUN6Cx4iqtx6Tyz4/Wqi5odEkC4km/9M
	g64PHuA26whL5rjeae5nqdUP2PbbxblguPmZbVuSlv25AVGftL87uycnw8YnmTBl2MLgRh
	FBWJ2fyCnka+KST4p9ouRcSABsaBdMU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e7ootxeA;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D862B6021C;
	Thu, 25 Jun 2026 14:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64CF1F00A3D;
	Thu, 25 Jun 2026 14:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782397495;
	bh=QU3Mdz0QWuS68FFe2kfHvyIPhX+22pphhD8CNUTJFTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7ootxeAFvxb1hfB81Mthn2cZCaLFZAowIOZ9rKmqjaSAM8KO62ef8i4HhnevDN3X
	 mxGcab7l17Hgm2Erlzv7YA/udIle5opylGgzMrN7qXMWKzc8vJ/yzFwYZsdlEXSrC0
	 zZc141hQocD7AVvrMGy95WE1hzaUTJnvB7XqW5Mm1sJyBUwk0G5DPk8dlHE77AbdyN
	 tPNecPjY0WNYEfzC+c/HXQJcnvcv1QtyC75evsvT1V1kZ3i8iQmWH/fVs1kfUWu4ZX
	 RldtfzEvv2BI5xvE45J721RrC1Egdd9R4V6sSabskJyqULoSxia2ufU+v1DOX4IeAU
	 TcW4aG1srvdfA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 10/11] mm/damon/sysfs: split out filters setup function
Date: Thu, 25 Jun 2026 07:23:55 -0700
Message-ID: <20260625142357.103500-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625142357.103500-1-sj@kernel.org>
References: <20260625142357.103500-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kbygup4wc91b94qsqaa8wjfiajs8hi5b
X-Rspamd-Queue-Id: 6B04040002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782397496-981268
X-HE-Meta: U2FsdGVkX18zfTL7jqJXcSGUz283jNtsdxR1NS7/b5Ryn6GdPYwsf+iEJpsR6cBEP7j5h7NylO8MEasViB8SB6WQPhGGlfShnb5NSWRexL+/H3n6dDjjOOKMYQ9x6j6Lf/fl01WTQDPq7DFC+DoBeUEZlr9hIrv4yzz2jppLFo71Ucl9WY/mlSkJCqllyVPJYbp4RhGTLBai6j7OHAG7ZeFOtXGAviDP7ZUrZ8UIsJI0E6gNAeG4Z5qdJ+fURKcOmSkHfyauFWqmIlfYbHKBXHw5LVcggNjY8I9yNPqUbe31+6+vq0omi86evDDVor1lzQYZ63qRQDDuXEC0ZyDQ1Gmrze7e4ZGEuF/fGPZ4WDJEozguuiBAbRPpuLJAfKmn0QXoNVf1faayTPjgt0L20iYQI/xKs7keFufICAJhsb1Ga6h4+PeFbk49dq3aWKpszSIXjlnLxn38VSGhtKLeCqu3wOQHNpeV95J8qE39jOH4PeaWZ6CO9zGJ8sSkDdau6bcXsvyGwS0XctDT0PT8Vk/os/xwjsXiblALpVRQz2Iu80kKiwXg9XRhUab7iZo+S54+DEYqSIOHGh/TYA4oWNDI5SJzkBVan1fY/klaepRSiIufaji0FUNY9/fP+v2ueoZPNDOcqatra5Ad0YvvfAf5qzw560eCaPvqO6R0+uHBKbRfoFBUTgBYucEKe4n8C6gcKmVKIYfahsQO3efepKZaGC6kK+dKPenY6M4WPvuR+hkaEYBzBPJ0CHHDucQLxKjXNw0r2H0+1g1ftG8M6OZqmI1kFA7Ox32oV/Ai1+J+9EnuYhyFb02Zgjg3cSfJKlvLpJuSeXyFeDutvLXknqW4EUv7wsLpqmhn6gzmMRq9MO4TlvPClI8C/BLHVv6YHv4lBNQzlhdUsw9tAuz0O2nf2sX+eL6O6w7zlTIaGYv73AF2a/jW7OMsaH7QWlcv31rG50CXS1a3qeOa/X/
 Kfumnbtz
 DDm965riQ6txjB4i8P6ti6zI/H8vg52CCbf/hKIJD19Bnk8xGLyW4Izz5+2Mh0WInkgutkOfvExIK6NYZY9dfZBHMJNn7m9G8EWg//7gyijeTY0zv6SJviLezZHlUgKh9B3xJ0hyE8fxn75funIZ5WsLTmb5a2VGrlbCDdXMe/rMrIU3Lrvt17SUpGwhw/n9bbxLrfMKdIK+ER4qoIg/vdilE0/Vn2SUY77/WjNJWqvkGF+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_set_probe() is doing not only probe setup but also filters
setup.  Split out filters setup for readability.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 982d824f63c21..f3bb146b204df 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1899,16 +1899,11 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
 	return damon_set_attrs(ctx, &attrs);
 }
 
-static int damon_sysfs_set_probe(struct damon_probe *probe,
-		struct damon_sysfs_probe *sys_probe)
+static int damon_sysfs_set_filters(struct damon_probe *probe,
+		struct damon_sysfs_filters *sys_filters)
 {
-	struct damon_sysfs_filters *sys_filters;
 	int i;
 
-	sys_filters = sys_probe->filters;
-	if (!sys_filters)
-		return 0;
-
 	for (i = 0; i < sys_filters->nr; i++) {
 		struct damon_sysfs_filter *sys_filter =
 			sys_filters->filters_arr[i];
@@ -1935,6 +1930,17 @@ static int damon_sysfs_set_probe(struct damon_probe *probe,
 	return 0;
 }
 
+static int damon_sysfs_set_probe(struct damon_probe *probe,
+		struct damon_sysfs_probe *sys_probe)
+{
+	struct damon_sysfs_filters *sys_filters;
+
+	sys_filters = sys_probe->filters;
+	if (!sys_filters)
+		return 0;
+	return damon_sysfs_set_filters(probe, sys_filters);
+}
+
 static int damon_sysfs_set_probes(struct damon_ctx *ctx,
 		struct damon_sysfs_probes *sys_probes)
 {
-- 
2.47.3

