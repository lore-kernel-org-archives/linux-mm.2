Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75679C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 16:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE5DC6B00B6; Sun,  5 Jul 2026 12:01:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A97AC6B00B7; Sun,  5 Jul 2026 12:01:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ABC56B00B8; Sun,  5 Jul 2026 12:01:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69EBD6B00B6
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 12:01:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AEC8514012C
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:56 +0000 (UTC)
X-FDA: 84955189032.12.D2FEC76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1A8EE20008
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eSIXgO6Y;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783267315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h+1wlgb4/vhq8hic6IHVay1RAoaGPrWWDyvHtZVfeMM=;
	b=W6pZVeNhXZ2B+9hCgj0hGPPtWwmVX7I/PB7RjCKK6brCb8fzKTd2WRNDCcCC3FuSodSV1W
	K+CwrajCKvdvXDKR9Cc2Wjyh2YqsL1Lia/OMCuNmL6RzEmJR/3Ubq7HLgt0Zsgtuncpj+K
	TFnLhVy53CmE9smpDurRROZIi2LfAbU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eSIXgO6Y;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783267315;
	b=gcacwSID1B0IsiDkm8n5MdHPEXFFNBorlsf/T2bmXL0twyJqdvx1sY6NeHz61L6iMCFnCh
	qII9eH6jO7FG3abrlig44iAwTF9At/kbxOU4KL1RRS/WS2R6IDJjLb0qK/mJVNjrHeF6dF
	9EAUGMqeq0jHTy7LaEyg5BQXKJ+btrA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B79643AF3;
	Sun,  5 Jul 2026 16:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4131F00ACA;
	Sun,  5 Jul 2026 16:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783267314;
	bh=h+1wlgb4/vhq8hic6IHVay1RAoaGPrWWDyvHtZVfeMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eSIXgO6Y39Jn3yR6Y83ITTi34aztQHPintIirt4pPS/K8UusGSbAGwLRqq2nXXiZv
	 KNToG+R5NR2v4tu+Hk2nDZF4kcL+MiopcqTNx9d1JxORowFWmPFO/tAZGvk0k52lP6
	 C0rTf4Sf9jN1RwfUaCxBnFu3Uoeq/DZwaK5kgMvDTs8oq9Gjg+LU23WrtuXhHn6Rzl
	 rgk3Mjrpp/Y7jgTI8V52UzyzoaLtaVZe86VEhQV8/+CYNHGp1QvYs6jxosj3zxtaHo
	 Hz8GyXpoDet0mPXcIMaYvqtuNDNMl4ruAbSpDkwk3sjopnz0B5jAidTGvJeMndamGe
	 f1tOVzfCIyBXQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 07/11] mm/damon/core: change damon_stop() return type to void
Date: Sun,  5 Jul 2026 09:01:34 -0700
Message-ID: <20260705160142.97308-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705160142.97308-1-sj@kernel.org>
References: <20260705160142.97308-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iwngwjgy5jytesxb859hmtdaz5sajrwh
X-Rspamd-Queue-Id: 1A8EE20008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783267314-243077
X-HE-Meta: U2FsdGVkX19lRyiQtSZlkgu/+fb9ET3+eqmBCu2RUgQHn1/OZO0312n+3/RoGX9ntlFcXJvWblP1cjyIklH1sZs7fGMDX6tJ38ctABP+KhLBkNsY/zK+GJxoarQBG9q+vHs5R7vegJLVp9lfCSbuKq8wmKPboQR2d2997ytbWmeuEwWg+zAkfnEpGD4sZZNlMTbNWAcZm+GCkTbPwdVHUp6mqmas7UV3vjeUdDtUjPWEP+z+Bq/gvuEN2kgenWqlKNlGtC204u9Dd2JZM8Dq41kaMHT6pf+yOUWjHGSzjmU3J13hXsM+IeQaWmaiYeOalKnr3jgzhwpuyhn3qUS7jY5wVeORMJDz82e8uyGfd/t9NSd0TxVHM2ug+ODZMN+i0LX2QNHJv1q7Msu7fQ3USy0rVtfyJ9RDjzISmLdn9lKl9QAeaY8fJnRysYkDxs++IhQ8DZGFdv0s+ABuTbAtm4MAtuX5evaatAd91p2S4sQ5coDNTmITF1YUDRpjXPP2pwIlgkuZA03xoQeJ1XWThURxYLptmu7SJKQj2hYNjsZ3pUxlXROmLkcsVL0K6I2l18O3dh+/8urnJ6G8f1ptnDlX1IC8eYIInyn7Z1q08dH6q1bAWqjfqnZoULurAPbBXsI7kEJbdkYtTTBxTbuS6kVmB7H3fVCZjzinRV22rEOAezaQQxm2sjPKtVRpRbPQ+3HcELX1KPOT+dUwzZy18nXfqqfmaaS+MctSQaENzWhEnD/cfvPM8mexR3eJqGGua28CORAkRQ0rXMhK7IFMigSHImOMBFs3YdpvCWiGP2D/se3Pz/L6oIbzvUAIi5/KlonLCnSt7p6o8WZoXmKyWiBA2cD0M1pH+yoXf3eF5WOt7tQhxj29yYBMrosKlbwIm6kduFjshmTdmzga7A7xJdFsfOFhoKJ+Gid2ibBPlnY09OixXVT2a59vSY6EMnE+HmHMijJ4SHkYLZUOT8K
 /Ph0iCcZ
 QgPpM3wPLtJmztQ4famoYC3BoIyTVJggHhPgAYx4Ph2Rn12qC7CbqfMuErvJ+12uHKJ+7AM74+ipET+TTd1j6pKuiNxDcPteuvnPkx70TwSVwZ0tVejX5iz8Ox+mlRGKUDBeYAJntz9mtslG3qmYSouqB2xKTNccnIO+/u7FgPS2LomCaa7CV3wfIrUChWY97p/VkowmCPzvmAcSs7RAmYegq7sMQ21YFeOOPVDCjhCOvd8Xxi5wLDZ6IDZDZxACNJDg6MatFsGJdkblED7eN0oitgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stop() always returns 0, and nobody cares.  Change the return type
to void.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 +-
 mm/damon/core.c       | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 2661231c0ae82..19b7e839bde0b 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1070,7 +1070,7 @@ static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs
 
 bool damon_initialized(void);
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
-int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
+void damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
 bool damon_is_running(struct damon_ctx *ctx);
 int damon_kdamond_pid(struct damon_ctx *ctx);
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 84e400aa4e823..08510bf9b38da 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1947,14 +1947,13 @@ static void __damon_stop(struct damon_ctx *ctx)
  * @ctxs:	an array of the pointers for contexts to stop monitoring
  * @nr_ctxs:	size of @ctxs
  */
-int damon_stop(struct damon_ctx **ctxs, int nr_ctxs)
+void damon_stop(struct damon_ctx **ctxs, int nr_ctxs)
 {
 	int i;
 
 	for (i = 0; i < nr_ctxs; i++)
 		/* nr_running_ctxs is decremented in kdamond_fn */
 		__damon_stop(ctxs[i]);
-	return 0;
 }
 
 /**
-- 
2.47.3

