Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B874CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39CB6B0096; Wed, 17 Jun 2026 10:48:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC3236B0099; Wed, 17 Jun 2026 10:48:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB2196B009B; Wed, 17 Jun 2026 10:48:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7ECF56B0096
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:48:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0F33A043D
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:33 +0000 (UTC)
X-FDA: 84889685706.21.5376EBB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 22A90A0008
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CDB7fXxh;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6MPeEDmuSnl5VMNAu0xLTOn+1aNO6rM35POBLTCeUQ=;
	b=dFEOtPUBOT9YqPF/eIaG4r/7RtO7XRBkehG+1M3goCuBQcf+oHozcecHcaiJ0Z+xnzKZ5d
	AF8i0O5idGUnoJEyEKCDMtrFRcggaFF+n058pBmq7FQPAkTq+MLFLkpz2+lLTNJM5pZu3A
	NRsxzhmlJd9V5TuUAUMlYl9tePm5o9U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CDB7fXxh;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781707712;
	b=ecPIZCmMusVDgwDkkOKj4im5a7hevZU2YFDckUthePri+yZNBUiMxPR/UJQtOPZs7YGgny
	1ZdeN+xpF45MnvW0sbygr7oqhYwcyUGnmv9Gi0E0yJaT2l0H7OezFLPPOelHrKS/mYapJx
	QlydQ/2JXad1/qBaOIcycjBC97119r0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 464EF4012E;
	Wed, 17 Jun 2026 14:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7971F00A3F;
	Wed, 17 Jun 2026 14:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781707711;
	bh=L6MPeEDmuSnl5VMNAu0xLTOn+1aNO6rM35POBLTCeUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CDB7fXxhsPsBc6x2ZY3EvKqaB7hcb+fFR4C4FwWmmKS6s+Psk+6eZdopSyUqN0mfv
	 LfSxp9kMoGQDZv5MAauhg2oYEX64ASfCiJ4P1kM9DGP7dS35M1Eyeg/vyVNp4jcSoX
	 +2k684OkfKYEt3y0hnPP9lW3cSOjg0Fx4xqRWPwXAJtTu1ZnA4Z8+RoLRlWt7YRMlR
	 8DbtDejnCiQZpqlNzTv8K8X50X8FIrc5j5Y8maUZgrdWgjqbK0CbjDELLnQrNP1fjl
	 hl+WgC1bIlavfXd6vUQUvNaBl10q4H/Ki2kNKjTbkq0rP4vuOS2BBejPYhjfWqO1Rd
	 YTwTOjus8k3rg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 01/11] mm/damon/sysfs: kobject_del() target (normal), context and kdamond dirs
Date: Wed, 17 Jun 2026 07:47:55 -0700
Message-ID: <20260617144807.91441-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617144807.91441-1-sj@kernel.org>
References: <20260617144807.91441-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 22A90A0008
X-Stat-Signature: wkbtiwen6om5qg7in8mot88yxbqbzsjp
X-Rspam-User: 
X-HE-Tag: 1781707712-614641
X-HE-Meta: U2FsdGVkX18qQkSgj5TaVo94P5odnNpShzDGkjRXQfm0pMasYkp5z5eFeeO8HuEkLQgZkE6zTJEGgAQozDB1kZeFUyvU0vPDi2k0Whp2IDB2RjsrXXOgXOCasa7/OIrg0X9QptASGn/edEilwx0mU+6EdsjBhUATKd/+QfAqdVo3a+T+XYb1uGFK15IJzlnyRXvDeg2i+0t8aOli4u3P90KWOjzCOHApQzT9Ujep7vJtQ5QtOhTG2z8I8m86RPVJTpAytGQ2JOUznXbZZS/sgEoCed0yTx9AzMuHYPZkKTRVugs1m31ZYOcGkfbb5RCN6tjtqpa37RUZIx9+QVjeFObftEuI3U+he5r2rATYLBe0OrVEYQUvaeujGiFQMY1gmFVcUZfA2I8jsmI7iXm5+sdl70yEwsJQryX1DLaaU7OKlgTba07gaTHcdmlFuLRPukDfsMGpoVVS1/BFUM6wVujOBHm8WqqJNb6je19NlO22Jg4+6jzgpJHJ0NetdyJdl94XMBDvbf76m2JZMhM2FxJ8CkU37bKNRBjQ9HG4xMUqj6jHUQVWKD+xmdPxtXba32HKrHDF98Y9PSNTbcIhe7KxzdZ2sNnVkaFW4/xF3UhtbwhMjLaXtfa17GO+pvm2OV9U0EJIu9PbG4kMhGUbV7V3PTbf6K4SqK1Hv6UUuh+KNpfZGgZsLTBmEiMPdcBAT1BcPiMmshs2szd1HKu/J4G/bFN2oWKKE8+tNiTHGgG7wFZQmh4IwKMf555n3EcJQuunRQcW/bz24aNho7RNS+l9yi/gu0R7lAGqnq3l/rnBcjYHPS1eAs9k5lVvTqGLdrRf8LTBtvsMHsrff3ZTZ5sNNhxV1e3PiPECkt+TsqGcx8tbAbkBEERKGAsHkbKujScrZ7K5PH7xqUzwE7riLcjHF8zdiRzC8BZuXpKYLpxjWxu7XJeezV7TCdKtwY2X9iTczx0LPIK1IIpnaei
 Jt2Ug4VZ
 rv+rD6K3z4skPOAzXtnLoOsukjR7qJy2cu85yMprJl5wMEy8JkFVnlFg/GdQxRUqi9X8HQG/lODISeD46pEBMN+Xahpocq6KJf7XF6PrZiCbSIKnqFFb6xgmrp7G/PENGGk4klzyd34KJrJx1pELZFBZJAK1D/AQxAxeo9ZmEhKH3zm2u+ncoMPs20hoaM4N2iRF1Xpj5D6HNNAHOD2wmf4d2u6SnQPNMf8oEOi7MuRjT0abTaATXCQufpGUo1hOSBKujCU8zUgSwF7v2qSFRgoesKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for normal creation paths of target, context and kdamond
directories, and error paths of context and kdamond directories by
adding kobject_del() calls.

Note that this fix for target directories is not complete since it has a
similar issue in the damon_sysfs_targets_add_dirs() error path.  Because
the normal path issue and the error path issue are introduced by
different commits, this commit is fixing only the normal path issue.  A
commit for the error path will be added next.

Fixes: c951cd3b8901 ("mm/damon: implement a minimal stub for sysfs-based DAMON interface")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 2e95e3bac774d..dba1c67fc188f 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -333,6 +333,7 @@ static void damon_sysfs_targets_rm_dirs(struct damon_sysfs_targets *targets)
 
 	for (i = 0; i < targets->nr; i++) {
 		damon_sysfs_target_rm_dirs(targets_arr[i]);
+		kobject_del(&targets_arr[i]->kobj);
 		kobject_put(&targets_arr[i]->kobj);
 	}
 	targets->nr = 0;
@@ -1642,6 +1643,7 @@ static void damon_sysfs_contexts_rm_dirs(struct damon_sysfs_contexts *contexts)
 
 	for (i = 0; i < contexts->nr; i++) {
 		damon_sysfs_context_rm_dirs(contexts_arr[i]);
+		kobject_del(&contexts_arr[i]->kobj);
 		kobject_put(&contexts_arr[i]->kobj);
 	}
 	contexts->nr = 0;
@@ -1680,13 +1682,15 @@ static int damon_sysfs_contexts_add_dirs(struct damon_sysfs_contexts *contexts,
 
 		err = damon_sysfs_context_add_dirs(context);
 		if (err)
-			goto out;
+			goto del_out;
 
 		contexts_arr[i] = context;
 		contexts->nr++;
 	}
 	return 0;
 
+del_out:
+	kobject_del(&context->kobj);
 out:
 	damon_sysfs_contexts_rm_dirs(contexts);
 	kobject_put(&context->kobj);
@@ -2501,6 +2505,7 @@ static void damon_sysfs_kdamonds_rm_dirs(struct damon_sysfs_kdamonds *kdamonds)
 
 	for (i = 0; i < kdamonds->nr; i++) {
 		damon_sysfs_kdamond_rm_dirs(kdamonds_arr[i]);
+		kobject_del(&kdamonds_arr[i]->kobj);
 		kobject_put(&kdamonds_arr[i]->kobj);
 	}
 	kdamonds->nr = 0;
@@ -2555,13 +2560,15 @@ static int damon_sysfs_kdamonds_add_dirs(struct damon_sysfs_kdamonds *kdamonds,
 
 		err = damon_sysfs_kdamond_add_dirs(kdamond);
 		if (err)
-			goto out;
+			goto del_out;
 
 		kdamonds_arr[i] = kdamond;
 		kdamonds->nr++;
 	}
 	return 0;
 
+del_out:
+	kobject_del(&kdamond->kobj);
 out:
 	damon_sysfs_kdamonds_rm_dirs(kdamonds);
 	kobject_put(&kdamond->kobj);
-- 
2.47.3

