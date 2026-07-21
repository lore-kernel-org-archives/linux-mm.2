Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1EE9C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 10:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBA166B009F; Tue, 21 Jul 2026 06:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6AF26B00A0; Tue, 21 Jul 2026 06:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83246B00A1; Tue, 21 Jul 2026 06:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DA3E6B009F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:17:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16045C0406
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:17:04 +0000 (UTC)
X-FDA: 85012380768.09.D911DFE
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7A0B61C0005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:17:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sNBjPHD8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784629022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rbbOM9+ieScbci4D2m19EpRMBOk1+xoDTzRYZ8IQLl8=;
	b=qIxtQ2GS4M7hP8Eove9vRNmXZmgocAli/7nM7RTs396eqet6CUUacyxd8dfhVEKDe2URcG
	HqN5MeqPh7Phvg5ER0TT5R2uaNIlsdlB1RltW9027jqruYPXt136z37VxNplO1lNeP1b1B
	xCh9u/nMn9RjTzhKBBrCJLHEjwaOt7k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sNBjPHD8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784629022;
	b=Vg9mVGvUxqDwOjxbhR+vqKSiIF1C932zdX6lNDuE3CKJVw+qGLt/ycejO6wE9H0W1T3Ahi
	Hs5AbWAHL3g92RgeQrESvpVMSMvRQLhNd+/TwazYUPvdWO270E6a7vPjw9/QVX5ABgm8QK
	KPjSuXvpKXDRH0g5FNO/TbSUh+qwLQw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784629017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rbbOM9+ieScbci4D2m19EpRMBOk1+xoDTzRYZ8IQLl8=;
	b=sNBjPHD81MV2lL6lnnTFq6SIlC+16xpHB+3aUraUvsPbqtBjXsXj/xQwF+g7nepuD4/+tb
	2j/ufMa6u3AgVNYGwejuNOVOaz08sgvWR3fVjHDGI4f1K/lDE/ICfzkDilpXBOAbhsZ3Xk
	7Wb3ZITWYWaTHyP4OakcJGeUAaIudO4=
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Cc: npache@redhat.com,
	david@kernel.org,
	"Nico Pache (Red Hat)" <nico.pache@linux.dev>
Subject: [PATCH] MAINTAINERS: update Nico Pache's email address
Date: Tue, 21 Jul 2026 04:18:11 -0600
Message-ID: <20260721101811.115954-1-nico.pache@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7A0B61C0005
X-Rspam-User: 
X-Stat-Signature: tennmypb4jnptxxntgcad8cpazec48hw
X-HE-Tag: 1784629022-209550
X-HE-Meta: U2FsdGVkX1/nZMMTGT1ja369hh0lBsaMZjr3jPJ8C/sQE8wEaHClo/3kUBcLGt1iN0+e4qt4qqXxU1k8awOfy2lDjsuGlZ/F7ZTVLh+HMTn2PsflHhuf2QfJRVvM4FsvfjSQYGwEzxnThYmboGDJdFG6d/rDVnBnpwttTiEE8QF4HEtgMEM0qVh/fXcjQvsGH6cZz2yWFWGPd39WEnMAKqf67paRrlhqBxBIJBxVL94DF8zWUxB1FZCVTG/+XGmhyQwMrvRBo9KcGCVcgb/kfqZCjy0hK0JU2InItt065DgBViWv+O9Op5m5QAPXpjGemB99rqknzD8sIQhyRNCfmEyrRNxYIYC7CFZRAAgf1g6ooZ2DMA2RLeyJdvB5MeuJSb3z5T/zGPHt+G/wuhemITtv8BpxHp3CFIMo01PZlKQSiV+7N8DWENH2ud4LlpGgns+3UUlz8EgZkVZTHwX0sy7t6BMEJ8t63rkRmYM6OjnEEpqQ2QKFb6DSp0AZfIbYH8tFrxKwmpDC92/q5yM2rR9yGgwpE7Q/2RsiJbWkpmcb0eGvgfYop5J9CwCKtfN7/gRntEqX2nXNFapyZFhz284ECFuL5NqiVvg41tSMDYBcczS0x42mc7Q7U8hz5BAnPs09LcjbTsfKqw+AroFdViwdNTPzsCmd3ZpuH1B4l0ZCpiMgYIpxc2Z36q4AdFkWklQkmm/BxzfkNZhBRSO8Qyl93cMRRGqNyJpN9xGEe561WRzKDEm0vVZcobYqh8lGgRyoGmZnA+p9+H2jdn0PJRr4UyYPiWVRefiBiZBJFAw4/pNRqDjkNGMvS9i1l/n4OEVqFz5z2c8FBgFgDD/qd8mhyUDF0t1s/PW2J3NQur0O9yZ5ll7hXyi2OTMsvPuZQEjH+1uT1FNe4oRMF2xgv2mXEhxpIxti5X4lalwGD70bid23gGHa6wuZ+i1nvl1ytYQIPGO3JXyxCkrU+nX
 AgcQ9XCD
 a/vE+jFIlhr28h0wRjEsQ9C9bqFt9YY6BeDBAhaKEniAuU9A5FNA3h7amlR0BrbJiABVcs+b/tqXay203DMxNzOntmQokPfWckEOOzRsIZ3oV6EzgXpnnUUDCsIEXzkciBgUBOu+aLe4dXKP54yZluAS9nl8nLM+8CWnfVJA/th+wipmP5E/9OEEVa9OYNkNezGirA7JuLLiHINYOPVCoHEF32Mg4Xxx4H1qHPHLBFPm5YqFwHxdI/u2dcI6XcwjDiKI7LiBo2YuOHMDgtKcYJHGjAx3lqz3DMQEeyU1Sp93Je4oPPIwBj5CxWtYcRQEq8irK3oRHvisVEtUl1uRs7zRtm5S0yjRs/FMZtc5M0Qx8ONyhLdVeamfMXJl9RoNPWzSU2agGzp6YKVkM/5wFj+qzorVK9TUoq4civzl+uvtuU70SAcgczM9Fm9rde78X4rc96vckf25cjbJJyY8eU/9tw5k3PwB4fQWivF3aeyzlWDdR97oGnJgEeeE/BY18LTl/XpcmqPgsPMvAtplBUn6j0o5YTAWNwFNIOPTzUJr/8V1soSUmg7u1inXqGNrAL/tp8TqN9obOhTPDFrOVs2yPo6IFHeL/MLdtydsviaGgAknQf5iFBO5gOEuUS0pXtpnV83E+vKUAP33IJf9E44hKo/FecHpcIVS4x2pDJ+MNtqeRWPc+emv5EcgzyXNpqtt/UBKfjKWJ4bfbG33Uob5t5B2ON9P74IbQWBJizjTidhjSj/Y9ZBI+iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Switch my entry in MAINTAINERS and .mailmap to my @linux.dev email address

Signed-off-by: Nico Pache <npache@redhat.com>
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
 .mailmap    | 1 +
 MAINTAINERS | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/.mailmap b/.mailmap
index 501d858cb432..e36a76e2800a 100644
--- a/.mailmap
+++ b/.mailmap
@@ -644,6 +644,7 @@ Nicholas Piggin <npiggin@gmail.com> <npiggin@suse.de>
 Nicholas Piggin <npiggin@gmail.com> <nickpiggin@yahoo.com.au>
 Nicholas Piggin <npiggin@gmail.com> <piggin@cyberone.com.au>
 Nicolas Ferre <nicolas.ferre@microchip.com> <nicolas.ferre@atmel.com>
+Nico Pache <nico.pache@linux.dev> <npache@redhat.com>
 Nicolas Pitre <nico@fluxnic.net> <nicolas.pitre@linaro.org>
 Nicolas Pitre <nico@fluxnic.net> <nico@linaro.org>
 Nicolas Saenz Julienne <nsaenz@kernel.org> <nsaenzjulienne@suse.de>
diff --git a/MAINTAINERS b/MAINTAINERS
index 1ab8736850ea..22d38e288227 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17252,7 +17252,7 @@ M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 R:	Liam R. Howlett <liam@infradead.org>
-R:	Nico Pache <npache@redhat.com>
+R:	Nico Pache <nico.pache@linux.dev>
 R:	Ryan Roberts <ryan.roberts@arm.com>
 R:	Dev Jain <dev.jain@arm.com>
 R:	Barry Song <baohua@kernel.org>
-- 
2.55.0


