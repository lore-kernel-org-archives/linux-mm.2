Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83DE9C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286456B00CA; Tue, 14 Jul 2026 10:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25D376B00CF; Tue, 14 Jul 2026 10:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173736B00D0; Tue, 14 Jul 2026 10:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCA8B6B00CA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:35:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 513218030F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:58 +0000 (UTC)
X-FDA: 84987631596.24.A13E0D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B2906180002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l5Rf4pxg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784039756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wUP+A3V/Raa3GTzyt1oBi5Pi6+PUzbHoN/8enGeFJg=;
	b=b7ZvpYs8gDMHH/FDH0EDRajo+BWgeQzJtDMiaRhkUC8hmf3+rrkoFXtf54vZ3vGppECea4
	PD6yb5B9DOLJMNGEcK/SWJHvOV+PseG1zE7bfRQgx0xMq/hzP2TX9uMmcLYbw4AveaTXAA
	SUEp21N8VCGc7CwK8gV3tgjD80C0bfc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l5Rf4pxg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784039756;
	b=IdoCCN//d3dEP2278RJ+h9po1iZCelHUqC4F79kQgbI8Br7U+Qc+1RSi2I4kDS28L3gBbM
	pMxxlTwEAjsqiHIOtQtQBlj6SMK6suvvxJABsWoe4LHWI9rmlNV0xOjssHoZvCQkF4GDBy
	3g7/E7YRCpFiSTlB+eidRVICp9138qE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E2B574372E;
	Tue, 14 Jul 2026 14:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE371F00A3A;
	Tue, 14 Jul 2026 14:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784039755;
	bh=3wUP+A3V/Raa3GTzyt1oBi5Pi6+PUzbHoN/8enGeFJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5Rf4pxgD2IqkG6wezOZ27v3qi0J9YlVZMPXvUIKQStRrG5i7Ol79FfGQs0PXllkX
	 /U99kUO56V7z4iF+6RPR2hIpPnyweTw83kEMrmiSLpt7sB5S+eqdP2nd+304yU0q+o
	 OitdBloS4IHWRFIADoI5NOjjy7Pw673U6KdrrBEdw57NbyU/aUxpGCIUuid9A0qQcL
	 kjlUbWkJMLuS1Nfp+t5gl4JWk7ii301Bq7ALbhPhKiA8aFswJC59sodNe1q4ocBXym
	 G++xPcuYIA/7bm4aAe17CIv9tofBE0RqnzPu7hzss9VKis0N36mM99aM7pfTVwmHMR
	 Zk3Hfz1nz2bkA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/10] mm/damon/core: hide private damon_target fields
Date: Tue, 14 Jul 2026 07:35:35 -0700
Message-ID: <20260714143544.101305-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714143544.101305-1-sj@kernel.org>
References: <20260714143544.101305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B2906180002
X-Stat-Signature: uwqqwozhynynbzem4zpsbj1x9db9hkry
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784039756-888705
X-HE-Meta: U2FsdGVkX1/NrNmY0Th3DdoVoh62QaLEqRxG8BchDdr8ZVsjkEQ13rSY2MS2fikko1X3p9xHnllyeTJkaPXeNOcE2emg4VqHPDKcsGnjLYui+968OQgYi7w49I5mH35jvXTh8GNeiE34G3qXF+dXfecEW5IZdrz00TgrH+kyAfeo8BzqQZJSa37Ay5zCgooMsGUqCSqieMGcj9Jn220bmOuq1dyq5RPL1lDH+GbIXr7rrvAmTtlhjM+PMBKRbVpjZKI0uUDcExDv0MJOPS8n7oxmSrbzc4t7unWt5q71adPyPmrmQKmbzJ8HAnd/m7qAOAV4EEW/E/2Dm+f6yiX6he5OnZZKpPsfdLyHkMb/Y8HlO34SbQrxFjTpruwXGiGxWWUVUFkSNPsjWF6w5LGpBtRSeuSkPe4ukOybHGD4XvgjUc5yRPBJpTSjzQe3TWYKt6ixpK9a2mI9M7U5KskSZDevmBNuejCPUwoQuR9zHkQ4nLFNMuL3/3K0Nv+WhyQYHUKNcAncWvtdodokkQUaQBUzKQA95PbRnb/ly0AVSnd07ZMDkBiwCIPMbSMG7cmX0x/mku4c/r7rpk1qesFm8SZAJWf/AcNsFLwbCpQoD7zhas9az4Ss6UdBKhx6I2Bddes+hoL+Nw+X7LItMygB5q/cbzmoGg6mYw5gTcBcCbZIiy5sd6ooMlz72BkO9AGSSOsW7zPQyTCHZdHe6GyaS67JkMmbRNPDP3tNHpbw+5D7PMSA7spXP9l5lmaLnWxgTCX7sViiM1AXi8Sji7WWMqx4u/GlQ5UgKZ386VfPLfHhIqdW4FZ64lawO1sjYWFQEIxgmxqP3TqGkSCkxMoimLB/lbWbn5IXtWwyO0kZAxTXlzSUyz4RBRk5/UuX0kkb8FoqBsmYASu0LRm8lnzdA6ZdN9/1DPEEXmgrZATCc/wmYMoj2PaEOezpsGkFg24L/7h5P4ENOQxnFnOlt82
 HzBwZisl
 sefdqj5uhtGaJBvnHs0psIge3JQvXt/TNeyjUqAEBQRlyH3ZZcJS8t88cpLPXFQS+08ZDFa9ODh+NUXi6FlYKmOaQkutVDJdJRDtFBQZ4ZRaFPi1nR2/PgjfILtl5wfkElyFuTAFA7MJcdzwBKrcOp1Oq92ioOpnoG1Q7Btd/jYkOVl7X/tLSUYQc0fhWhCorv0iFwconWNljRkGtB6ywHS7kviAbRWFFOhVYovtBe63pwkPW4mshWGE4LiiOdOosxfOanCkDFqb432KAWz58b2E8EA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'nr_regions', 'regions_list' and 'list' fields of damon_target are
intended to be used by only the DAMON core layer.  Those are mistakenly
not marked as private.  Mark as private.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d32377e7e535e..6e160557a0014 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -79,9 +79,6 @@ struct damon_region {
 /**
  * struct damon_target - Represents a monitoring target.
  * @pid:		The PID of the virtual address space to monitor.
- * @nr_regions:		Number of monitoring target regions of this target.
- * @regions_list:	Head of the monitoring target regions of this target.
- * @list:		List head for siblings.
  * @obsolete:		Whether the commit destination target is obsolete.
  *
  * Each monitoring context could have multiple targets.  For example, a context
@@ -95,10 +92,14 @@ struct damon_region {
  */
 struct damon_target {
 	struct pid *pid;
+	bool obsolete;
+/* private: */
+	/* Number of monitoring target regions of this target. */
 	unsigned int nr_regions;
+	/* Head of the monitoring target regions of this target. */
 	struct list_head regions_list;
+	/* List head for siblings. */
 	struct list_head list;
-	bool obsolete;
 };
 
 /**
-- 
2.47.3

