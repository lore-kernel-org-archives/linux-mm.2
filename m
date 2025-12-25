Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07388E784BC
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 02:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E979F6B008A; Wed, 24 Dec 2025 21:30:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E65B36B0092; Wed, 24 Dec 2025 21:30:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952456B0098; Wed, 24 Dec 2025 21:30:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 72A7B6B0095
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 21:30:52 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36DE1B9B17
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 02:30:52 +0000 (UTC)
X-FDA: 84256415544.19.745B438
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7549380008
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 02:30:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uEWInZVt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766629850; a=rsa-sha256;
	cv=none;
	b=8PWGDi3mv7UL8ZbAqFhl6NQZSywLFQQF119OQOuosYHsnA/P8Y8upZ2yPszyZszDe2H4vp
	xSNgTleBI0LZ6Ix/LlCiSK4Ij7znzkbry96L4BaZ65RCS5+T/QFAGY4naJoAn3wJavrw2G
	kFkRmk547Uqlz9KcBa3BkR/Dbb2eLR4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uEWInZVt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766629850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=St8sB6Z40i3IsUrD3DQc1hO2Xmc++xMKpRA7OQH0Mr4=;
	b=ePii4KkaK2YypPK09oKRUdTwT5PXbpKcXuvhlaRa53su/1x4eyT2z3MghT8bQbrji+Iu+o
	p1rmxcSZW5B0O32q2mfLjsiJVoW4bcxk3Zstsq+6qkz7We5NBIZmD9kKmsrZu9WTEVh8K9
	V6l6UOKwkndqDfBG6zeCaEgeFRysjzc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4846442A87;
	Thu, 25 Dec 2025 02:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3C5C19421;
	Thu, 25 Dec 2025 02:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766629849;
	bh=uCpoE/Jqb55vNr00kSEg/jQImas43u/CkKNXRFT/dX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uEWInZVtCJTE18Lw5f2GG6oaCBPdA36k9wlDxYkCYl6oTZ1U7jl40RyUuuDDyqxq+
	 1DdTcRYUgw7Z4IadWoaPWX1Y08pe/S3fqM5sSMtrDPANa16QFdQi99SnWXe1LDlsHt
	 g/Pi1B2px2xVjlI4z3nVxXzdsZrdIcxYqXTlnXtgQAx77BiYjjs9eRUDQerBpLo/M9
	 6NpCeIHIMlDPp4fv0iOapXuESM7xzNCVuXGaCORZ5+aR1PPGQWFqEh85iJNd+1ZLtp
	 S1kpDAlx1GCQRSgntDCTz0Uh5VDZeEInV2cWvB1v19Htu5x2FRz1ScmubbkqE8s3UP
	 hS9ARSMsVnfmQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/4] mm/damon/sysfs: cleanup attrs subdirs on context dir setup failure
Date: Wed, 24 Dec 2025 18:30:35 -0800
Message-ID: <20251225023043.18579-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251225023043.18579-1-sj@kernel.org>
References: <20251225023043.18579-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7549380008
X-Rspamd-Server: rspam10
X-Stat-Signature: u97bpekpakjqc5n1mnwzfd9twgcthzst
X-HE-Tag: 1766629850-37346
X-HE-Meta: U2FsdGVkX1+WZqb/rB1isttsvCXU2de0AXz6i9rQpxKKPp+jicFSyzyjBqhhy2qL0hZbLtZruU6hRjMvoMixLOatS9f3/k144S6o/JgnFe+i7be2fv2gffYYyyY2DMH5si2C37MRFj0J/IbUEylRd/A2kUrfJxXx/paJRPxYe0Guv5+CcfJ8HQf/HF3pq9ralva9WoQCB6rSb8+pS2fFXHGKlXFirYMlA7o7rXpOMqZgLNlC+mDUoKymPD6SSeQjjTzncBQ9abpRd7WeoC4lXbsvYgBmwCH97jh0SKoNtwBGL9Ec2YHDbn8vCDIyBXqQmHsUCr7H7LDCi4/2FiePQXzVVZF6aJ+/w25E+DX3CVISXUizQmgD+v/NlHOOVWgB7OdOJ9IKBNvEb5JqFqKyTiygh3QPguJJUpzuweBZcy/Y/Z0vWVQWCOo1ohrD8x0bhIqAKB2oMDbsna3Nr+95fRoXrxjcSHxWlE+hBZBzOhsy/tLLB1dC4Ajgr2AM8cyXDiec+r86/PKGrqfzLR17FG4YYFaLDnVQXiMjDaUbhX5aDbw4GZCP7N5iNsK2MKthjm/t8tqLZ+EpeIo4hVAvkIvilvqSXrvYffC0QQwy2fYP/nxZzw2CNYcKZ2amlIzyPAeoViDCJeJUHw0dAp/Fet8w3GI3zCkz46NxZXi78WtFlaWzRcbjlkC2rAShYVxN2NOFWQ0D+5dQncrRbNdOLl4+mTUzlDEPFOaXh3ZPrX4EAvd+JopJ5lwal1VIciL1S/lCvy0FhW7UIY2MnSmQMqXJZ1bD/qXfv8ifdbV9/8sfWAjvHdfGUnunslD5QNi+/c/7YA19kZKw54NE3q8V2A8nwU6AQVewiNfbT7yfD7mObGiUSaBX/UzOKBXBGOer0MNC5cd/yxI8vHr6vdA9V/bx7vBuYUG6PczrKKkPyPa4OpBEdjIJzxCVw+MdhsamUFw7ISU8f+k74L/P5Mf
 WkOGttNC
 w9qdxnNGFecHNh/8C6PlUKUlQMMGu1VnHiwWZmi53+WFbhbhCHjw8H+7Yzsz6Wq8gr8UKlqnemumALqXY46nIeDwbOkbWe2f4y2vh6Fzq0mxa+4ADgTr5NaapeIBb7WcegczDZnUkcyVOO0Ez0waFJz3pa7pYL+GOL2S9GKHzLzjM1fzzuerRBaCs1VpFeNHen/lPPxRj08hksTZ7qkgXiUoEf4G3h3x5i68ASHROOUxovxs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a context DAMON sysfs directory setup is failed after setup of
attrs/ directory, subdirectories of attrs/ directory are not cleaned up.
As a result, DAMON sysfs interface is nearly broken until the system
reboots, and the memory for the unremoved directory is leaked.

Cleanup the directories under such failures.

Fixes: c951cd3b8901 ("mm/damon: implement a minimal stub for sysfs-based DAMON interface")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index a669de068770..95fd9375a7d8 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -950,7 +950,7 @@ static int damon_sysfs_context_add_dirs(struct damon_sysfs_context *context)
 
 	err = damon_sysfs_context_set_targets(context);
 	if (err)
-		goto put_attrs_out;
+		goto rmdir_put_attrs_out;
 
 	err = damon_sysfs_context_set_schemes(context);
 	if (err)
@@ -960,7 +960,8 @@ static int damon_sysfs_context_add_dirs(struct damon_sysfs_context *context)
 put_targets_attrs_out:
 	kobject_put(&context->targets->kobj);
 	context->targets = NULL;
-put_attrs_out:
+rmdir_put_attrs_out:
+	damon_sysfs_attrs_rm_dirs(context->attrs);
 	kobject_put(&context->attrs->kobj);
 	context->attrs = NULL;
 	return err;
-- 
2.47.3

