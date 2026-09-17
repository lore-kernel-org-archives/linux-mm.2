Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0233FC982D8
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906FE6B0093; Thu, 17 Sep 2026 10:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BE0A6B0096; Thu, 17 Sep 2026 10:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F7B6B0096; Thu, 17 Sep 2026 10:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BCF86B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:22:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 72F9040395
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:21 +0000 (UTC)
X-FDA: 85223469282.15.7485F0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D7A4416000F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ybj0/BVy";
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789654939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7NGmBAgLNyxB6QRiSTsc0KXNRJO/iSY1w2o1E3csW0=;
	b=yrRjbj80KAZLFA8RChwTs1Ucs8TgZAzEc8HYZ6/s17O/64wZ0i8si6DyxPPQB1ji2jv25r
	Jpyn1xdRyYjHqXp1lYUosPAhwa4Fqq1ZMhJGh9v6DolOGvRdanah5ipjLW2FsxaVzvBfu8
	c/nI596v87TcDn+PCgDxnIgGgTG/jKM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ybj0/BVy";
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789654939;
	b=ZmVsRuJBVaJ3iraIo4xelZJqKx9r12p56ooQqxM4crAeCN6qlbd4aoMGV7RX6pIAoIuzJt
	YkgPIRIXJQq3B9u3TtLvePiVQNexkKLQJeiN6U3xqvOFBJxsb+DS+06qtXegENVznfdaWg
	qrFOgvmjFpUbKhvhXeHjMY85QuSzDFU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F04943C3D;
	Thu, 17 Sep 2026 14:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39F31F00898;
	Thu, 17 Sep 2026 14:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789654939;
	bh=T7NGmBAgLNyxB6QRiSTsc0KXNRJO/iSY1w2o1E3csW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ybj0/BVybpVYjI52lmYjn6CSqa7w0qBacucLk7YHbAiTAl7Q94Kyqhxgfd3mwuOSb
	 Y+b9VurEDucUbgBMrq8NEzYM5HqPVxdg8LEUkeFI00h/MqIJfrSnkrSDVb2cVrrqlB
	 Rae2oLyzMmfBor6ViRSYc/GpIAdKnM8Vbfe8USRFmk9dcTd7uwi6fPMmTUB5BY9XwD
	 QyNEhN7x6lAh/w1Ug+rYSeyWDp8DpcKbJjNy21Xc12juc7h4VJCfP4WnLQxQSi/Nj1
	 /xcOfbSZOAnwv8QANoux2AAuA5iFgaYv9pPwHCfbmNrrTQImUmP9XXiPYDQHaYUFPQ
	 fqhAfvPZj18bA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/10] mm/damon/api: remove NR_DAMOS_FILTER_TYPES
Date: Thu, 17 Sep 2026 07:21:59 -0700
Message-ID: <20260917142210.90829-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917142210.90829-1-sj@kernel.org>
References: <20260917142210.90829-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D7A4416000F
X-Stat-Signature: 9wo4ok43ptef377e9py1ze3hts3et9te
X-Rspam-User: 
X-HE-Tag: 1789654939-515729
X-HE-Meta: U2FsdGVkX1/CKwXPvVt4aySo7EtHifdN0/gIScx33MlPkYAA/w41epQRWW9UEUX6HZN0F8SAyE7D3bs4jRqDHSEPQ953XGHMChNQ7r7WXPXiUkmSx4xVl/8EA7XnhVMwelgy6OcKTNBDUe15vC4FYrDrB7Sv1kwmZPFL6c/gGc4Jt6tFbUuP6GZBED6pksxs7ZTWixDPKWxpGvOi6Yla6J08hmY+FlAMxKqMpYBays8Nwp3FmqtW//RA23hTzH6WzMRg3uWYm4nR7032mAff5E+v8PqnkqLIHCidg1NqTJuvAC8ErUvocIJo9s20JVG4OQfNE+LTR8Jr/DPErasmryTFPJm+wCqBy5X4KJ1ycED/JHvOak3L6vKOFDknyJ316Tp7I8wUuJxNWNRvSDxfxpXWpWEY5MgjmOgelWEpaU6Phx5dLm+Y3YBi0Yauhk8GF8R7BCL6+Ino6umQPtqZ1rqthEKNsIMVd1jasEUoV0bhdVElmsaBHn2z3gFWEOAvhjR20NEdW1M0ry5/VlCEUlp4GaqA8bfQawNjUvlM2TkeMd/QacrsMSHbH6IFzovNOcDldr9NYDVLhwN49A98oRo5y1wNEY+wegd9GqinET15Zx1AKX6OkSdFlD3Ruz5W45AHZOW+1r9Ak7S1a/CUJCjaJ+qfJ76A8WNFFIx1NOWMPYg3jsM+wjydtuV9f2tgim6j/lmljDSClF/vxjkG+MEGmGM3ar0fF4dzIX7m+Vi9OmabjI7C3fNFEXgW+nawtDjglrXhzOmWi9xmyNxKwewHH0O5fXaJ6+b1XqHvFcs/GnmmwimTNaf3if/chhNoN8kJq3da9EaqMmjhYi9alroLkWx2sLvdvaHFGtpy7Id/eH2AWXD35QRl4C5lK6nVrtYdbQ96XghwMmDnM0zjqWFJW00jytkESenSJpUxtqASp+8cGYfeL8XwgBmyqv5/BB1YA/Zer1PIJFE5IEL
 Vex2lvmd
 Bort3DkECGozN4LAVRjb9F786SxsbG0rnJsu7YS8Qfsxr8Nu8BlAAGiau8COtbMTZbr8m0lqIxG+MCU8jr4kkZR6oK4cyGemcezoyJwmsAOFZVGtiTVgoEdae1r/pQMaErAbn7996QoKIsYWQ0GEBH5I+6YUmxMlS+9pi7/mQ+nbzg1AH6w/3FZi1+U6IM3vOd2nLlqkim+YRV8Xeapql/9y3rysqH5mVRDUXZTYoroocKD2duThLeV8bJf6tEIisat76aMJPpPPCHIIZ74i/0lCyt8w790RXzlpEREfZPnP18Nk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nobody uses NR_DAMOS_FILTER_TYPES.  Remove it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index bbb190b474015..836353c4ab9aa 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -400,7 +400,6 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
  * @DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:	probe_hits weighted sum range.
- * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
  *
  * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET and
  * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM are handled by the underlying &struct
@@ -422,7 +421,6 @@ enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ADDR,
 	DAMOS_FILTER_TYPE_TARGET,
 	DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
-	NR_DAMOS_FILTER_TYPES,
 };
 
 /**
-- 
2.47.3

