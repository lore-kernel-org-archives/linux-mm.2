Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACAE7C982F1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CB336B010C; Mon, 21 Sep 2026 07:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507636B010D; Mon, 21 Sep 2026 07:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C796B010E; Mon, 21 Sep 2026 07:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19B2C6B010C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:01:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE3C2C0140
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:01:06 +0000 (UTC)
X-FDA: 85237477332.11.D64BCB8
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	by imf01.hostedemail.com (Postfix) with ESMTP id 04E6C40004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:01:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TDo+pTbb;
	spf=pass (imf01.hostedemail.com: domain of 3bw6xagoKCKwhPaZZQRadfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--vdonnefort.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=3bw6xagoKCKwhPaZZQRadfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cvjbTKhoGU/dDzLNariOWDtPZWx05brpq3W1pqMLn2I=;
	b=1OSlKjH+w2ya0zJTK21hHAAhoTtDanBmOFLqBPX1s09Ft9PWaddBBSjyvdf6A+feBTn8aW
	eYzCfKF+53x4IyIi3dl/MXM6czEQ4PI/Fohm+FWTgRPOHngk4ptQZ4JfeUAQ8/kP/v1zCB
	oxxTRNGlXU2xmKvmpLGr8JcEL2GG1oo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TDo+pTbb;
	spf=pass (imf01.hostedemail.com: domain of 3bw6xagoKCKwhPaZZQRadfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--vdonnefort.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=3bw6xagoKCKwhPaZZQRadfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988465;
	b=cxcBICIS36z/My53vKA3to5EAlJZWUD6kCOfJ1RortahU58EJFQvHcTOLsPQt0IHxQ5nVh
	3F58pJUIs4EnHLLVlEbpFm4GR0QamRXy2qpjqLIjTKawZey05KdRrMs8wXO/fH9hELx9kF
	7IBDBaNJf5+N7IVXu5HAiYx/CTSCZ1Q=
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49e65f2f1baso34023205e9.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789988464; x=1790593264; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cvjbTKhoGU/dDzLNariOWDtPZWx05brpq3W1pqMLn2I=;
        b=TDo+pTbb8XMJakXICuQof6gNxWAnFH0PZZNpAbZuJSgg4uT27P8NfgRc65pkak9buu
         W81iBPk5IUalclifw2BWV6D7nRcfEd0KlD27O2r02TM4v7zm9ERmJuVE2zt+JC5k7EfN
         cC8OB4JoKBTlejFzx4q4sx4R66ioekAjkiJS7pzWihm/nPZbSyZ4sN4KK5PcB3GE2Rj4
         ee1xPcILSLzs87Q2iAirWi1uI8GyLUC8iW15v8dTzgLZkS3bj0TVbtxciL7QXoYm9npm
         ayxQzYv/6Yo+Z1LybzdKyeaE2rPqK8LiiJ6Uwo2JR2HZvaPss1BV/KN+kHnpRwzG9Gqa
         AuIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789988464; x=1790593264;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cvjbTKhoGU/dDzLNariOWDtPZWx05brpq3W1pqMLn2I=;
        b=kWXBWJ5VVsZ41AVu7OuCLXHONtRNVcXKR0Wykjc3GyXrJYAII7CunHSgRCqWNW2/4G
         hVXQETbC3NCo0IMN6/Iubaib1TKEauO0m49EsZ1ubXvxwXfYqJ7vA9hXbbQ4N6FeR8KO
         QzwpypL5uWjK1S8U4BbV5AgkCV4hZ4+6trwNldwNEkacXnIGDTQWhUYtpLmZFdof9A9s
         GkfAFoMige6rRnyo/KgvDUS7CMf4bIMbIcSgIcMWv7N5gRL7fdl+jtoee46PP1u5y0zN
         5WrwxIV578zLynKQegM8potvz9pbtCkW+qAVlrarhax4slWTxiEl/zp/zM56n2OYmL6a
         m4yA==
X-Forwarded-Encrypted: i=1; AKwUvBzoOiMZZkl8Wy9C3hbNeV4Tuf/FouoMeQeqYxJthgx+w2RBPxCztyXB8pXre9viz5HkmVOC1KakWw==@kvack.org
X-Gm-Message-State: AFuF++mNUfFuXFYz++gwtUoch5qMn03UYeneCZNsSr5fWeP06FPwmSrI
	1T3k9aDqWUptZBxCyZoKT/MYIA22sVZjQqA/I3BkzCnNUb+6skbgU2alu4SJgnDwWxOkKRxBFHh
	p/KdHQezn0tVBH6UYVrnkpQ==
X-Received: from wmix8-n2.prod.google.com ([2002:a05:600c:e548:20b0:49d:2730:73de])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d25:b0:49f:d753:3de9 with SMTP id 5b1f17b1804b1-49fd7533df5mr5289235e9.33.1789988463507;
 Mon, 21 Sep 2026 04:01:03 -0700 (PDT)
Date: Mon, 21 Sep 2026 12:00:48 +0100
In-Reply-To: <20260921110050.3977591-1-vdonnefort@google.com>
Mime-Version: 1.0
References: <20260921110050.3977591-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260921110050.3977591-7-vdonnefort@google.com>
Subject: [PATCH v2 6/8] optee: Add support for arm,ffa-lend-pool
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, sudeep.holla@kernel.org, jenswi@kernel.org, 
	robh@kernel.org
Cc: mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org, 
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 04E6C40004
X-Stat-Signature: r15axgfnxixxu4qn7tjc8i8yfw8n5aoz
X-Rspam-User: 
X-HE-Tag: 1789988464-798383
X-HE-Meta: U2FsdGVkX19TizM8gQzhA4vcQQpvaL9tRAnOr425yW8JEnyVqzrSui+Def0d2DOKA5CCT3KSyCtal2mRhTnekAYM8xXAtUVeok8yhU1gB9DfSib4KX+FZQwiUdCqzqhmgHg4cijemNdYnMCiabu6f9jw93oIrTkne1JBqjfKev3nJYBe/bvKn8ie9XjbtWm1/lJKNoth14kVDK8D067jH4KTimsIRiqWh0Jkl/zIfEeDlZG0M7Wp5JdD7HEwoNdeWehcwkeYtcCAXIAGEO1HN9V01TEKM6/0ZANu8uAWQBqVJHyUfq30v+TmCoVytg1rf1N6eb1Ff2M6xafUvQAJQWov2P+gbKpgbyBACX9287LYTVpbKu6K7R+ZAt2CqXEt/3Vct24KYnpQALtpbPeV2YPqsS8okis46unq1nweY5n3uGWpFVQ54WtYvOERz+NvX4PpCLMZU9FxZHwPdqEhrE0usUPogecuNWA4ifSFybHAy/I86EXTu4yG+Cux767oeUoFFTvk599IsHwoO4fNO6FbfUIc063PGRZzsQzMmBVseZQTvJB7C5nI9IRwY2kb8qrh/T+nN4l/J/LLNaaEmVv2Sondntm5jCQELAHqmeoDOZdJg5TADx6+onJRuTTaAPsZuZMKVu8C6qowAJvlM5b96zRUmkzPw5OfowSicGFkIFt6gFFV4yAS4C8htdgWS8nsQP3uynZbT7wJ392j7cxUx81b+VnODo7E8OmiLT9ofbeNBb2LCh1xH2yobpyvSc+20Z6lTe/gRkHkwUPLjX6sLnH1/yB2lpInM/8p4qX92zYSGneWw8v63nPXvZSuEoMLa2GkM435WphdsORaUowbYhYUyig2b3KL2joGH+lbZLySD5fMghAnjr9PK6mtSkIoRCkV8Xu7wIhtfShoZkFPbBtTaG0R6vNTrOkpGtO+qq0zv/V3482stHX8RN1F4nhBB5S3uxvvDElV5Oh
 4UmXtllG
 n+BmH0mzhZdMIHf7Gh/svq2E+FLTSaLhXzfoKD1rWOjxSMKrbFYXkmCSFJJs+EER5RQgPMJb4mPiyWehk+OE+1SJkGMIBJ1m/kpheXVGX4dS8XLgGuOWxAV28C+kJElIwl2SGWGGW+m9Ghpo4BJOCrwfGF3h22br7EL3CDSQGQTaAaXV7LHJCxm+TSUw5RzPopnhCj/LIjSZOpCAF6p899Efh9lPCnJBMWAOQOp9GIJn+d0U6o/xesHQOQD0UvY7n0ooCCbjdCvZMhQZ43s2e1vrOcuPsyR36HXDhaFtTxdPdGiL1/vKEMa5gDxqQNZXLGIC2s6U7dkmD1UvbxSNRRbHeE6KTZW5hv0GlgCTu2LgEaeyfVjqafQKIyAvFB26hdv+VMQ9Pio2abD1DQrNtRZnEWTKVg6XewBBq06eGNxyAhNBPjnr5P0dDh3nQzk9jKsY/R4I5RPNsx92AV4+nlABa9nRhSNDbW0zQlKGIUUKImBGCx59zCNYKmXJ8ZiJSpfs2gU/LPMQmTpERWw8RlitDQd/pIf+3b7rStkocM1ytICZq1rqr3RkQmEQfjKX9LrSIDVIdj3oUoYtCcpscK6p2lPKOlR+GbXPKiDMZhwL1a1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hook OP-TEE dynamically allocated protected memory pools to the
"arm,ffa-lend-pool" driver. While the SMC transport platform device
resolves the pool through its DT "memory-region" property, the FF-A
transport lacks a device tree node and binds via ffa_lend_pool_attach().

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 drivers/tee/optee/Makefile        |  1 +
 drivers/tee/optee/core.c          |  6 +++
 drivers/tee/optee/ffa_abi.c       | 13 +++++-
 drivers/tee/optee/ffa_lend_pool.c | 72 +++++++++++++++++++++++++++++++
 drivers/tee/optee/optee_private.h |  4 ++
 drivers/tee/optee/protmem.c       | 20 +++++----
 drivers/tee/optee/smc_abi.c       | 21 ++++++---
 7 files changed, 121 insertions(+), 16 deletions(-)
 create mode 100644 drivers/tee/optee/ffa_lend_pool.c

diff --git a/drivers/tee/optee/Makefile b/drivers/tee/optee/Makefile
index ad7049c1c107..4986d863b9f7 100644
--- a/drivers/tee/optee/Makefile
+++ b/drivers/tee/optee/Makefile
@@ -9,6 +9,7 @@ optee-objs += supp.o
 optee-objs += device.o
 optee-objs += smc_abi.o
 optee-objs += ffa_abi.o
+optee-objs += ffa_lend_pool.o
 
 # for tracing framework to find optee_trace.h
 CFLAGS_smc_abi.o := -I$(src)
diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index a52c1f498b99..39f315cea830 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -201,6 +201,12 @@ void optee_remove_common(struct optee *optee)
 	/* Unregister OP-TEE specific client devices on TEE bus */
 	optee_unregister_devices();
 
+	/*
+	 * Must follow optee_unregister_devices(). Clients require the lend pool
+	 * linkage to successfully free their memory.
+	 */
+	optee_lend_pool_unregister(optee);
+
 	optee_notif_uninit(optee);
 	optee_shm_arg_cache_uninit(optee);
 	teedev_close_context(optee->ctx);
diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
index 633715b98625..e979dbc9a547 100644
--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -1042,13 +1042,21 @@ static int optee_ffa_protmem_pool_init(struct optee *optee, u32 sec_caps)
 	int rc = 0;
 
 	if (sec_caps & OPTEE_FFA_SEC_CAP_PROTMEM) {
+		rc = optee_lend_pool_register(optee);
+		if (rc)
+			return rc;
+
 		pool = optee_protmem_alloc_dyn_pool(optee, id);
-		if (IS_ERR(pool))
+		if (IS_ERR(pool)) {
+			optee_lend_pool_unregister(optee);
 			return PTR_ERR(pool);
+		}
 
 		rc = tee_device_register_dma_heap(optee->teedev, id, pool);
-		if (rc)
+		if (rc) {
+			optee_lend_pool_unregister(optee);
 			pool->ops->destroy_pool(pool);
+		}
 	}
 
 	return rc;
@@ -1172,6 +1180,7 @@ static int optee_ffa_probe(struct ffa_device *ffa_dev)
 
 err_unregister_devices:
 	optee_unregister_devices();
+	optee_lend_pool_unregister(optee);
 	if (optee->ffa.bottom_half_value != U32_MAX)
 		notif_ops->notify_relinquish(ffa_dev,
 					     optee->ffa.bottom_half_value);
diff --git a/drivers/tee/optee/ffa_lend_pool.c b/drivers/tee/optee/ffa_lend_pool.c
new file mode 100644
index 000000000000..b865c37efd5a
--- /dev/null
+++ b/drivers/tee/optee/ffa_lend_pool.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Support for the arm,ffa-lend-pool, unmaps lent memory from the host stage-1
+ * to mitigate for CPU speculative read of Secure memory
+ *
+ * Copyright (C) 2026 Google LLC.
+ * Author: Vincent Donnefort <vdonnefort@google.com>
+ */
+
+#include <linux/arm_ffa.h>
+#include <linux/errno.h>
+#include <linux/of_reserved_mem.h>
+
+#include "optee_private.h"
+
+static struct device_node *optee_dev_node(struct optee *optee)
+{
+	return dev_of_node(optee->teedev->dev.parent);
+}
+
+static struct device *optee_device(struct optee *optee)
+{
+	return &optee->teedev->dev;
+}
+
+static int optee_lend_pool_err(int err)
+{
+	/*
+	 * Registration of the arm,ffa-lend-pool reserved-memory is optional as
+	 * another (although less performant) stage-2 mitigation might be in
+	 * place.
+	 */
+	if (err == -ENODEV)
+		return 0;
+
+	return err;
+}
+
+int optee_lend_pool_register(struct optee *optee)
+{
+	struct device_node *np = optee_dev_node(optee);
+	struct device *dev = optee_device(optee);
+	int ret;
+
+	if (np)
+		ret = of_reserved_mem_device_init_by_idx(dev, np, 0);
+	else
+		ret = ffa_lend_pool_attach(dev);
+
+	return optee_lend_pool_err(ret);
+}
+
+void optee_lend_pool_unregister(struct optee *optee)
+{
+	struct device_node *np = optee_dev_node(optee);
+	struct device *dev = optee_device(optee);
+
+	if (np)
+		of_reserved_mem_device_release(dev);
+	else
+		ffa_lend_pool_detach(dev);
+}
+
+int optee_lend_pool_prepare(struct optee *optee, struct page *page, u64 nr_pages)
+{
+	return optee_lend_pool_err(ffa_prepare_lend(optee_device(optee), page, nr_pages));
+}
+
+void optee_lend_pool_reclaimed(struct optee *optee, struct page *page, u64 nr_pages)
+{
+	ffa_lend_reclaimed(optee_device(optee), page, nr_pages);
+}
diff --git a/drivers/tee/optee/optee_private.h b/drivers/tee/optee/optee_private.h
index aefe1e6f5689..f26723e81573 100644
--- a/drivers/tee/optee/optee_private.h
+++ b/drivers/tee/optee/optee_private.h
@@ -325,6 +325,10 @@ void optee_supp_uninit(struct optee_supp *supp);
 void optee_supp_release(struct optee_supp *supp);
 struct tee_protmem_pool *optee_protmem_alloc_dyn_pool(struct optee *optee,
 						      enum tee_dma_heap_id id);
+int optee_lend_pool_register(struct optee *optee);
+void optee_lend_pool_unregister(struct optee *optee);
+int optee_lend_pool_prepare(struct optee *optee, struct page *page, u64 nr_pages);
+void optee_lend_pool_reclaimed(struct optee *optee, struct page *page, u64 nr_pages);
 
 int optee_supp_recv(struct tee_context *ctx, u32 *func, u32 *num_params,
 		    struct tee_param *param);
diff --git a/drivers/tee/optee/protmem.c b/drivers/tee/optee/protmem.c
index be3abf6e8aa6..b8ee372d20c0 100644
--- a/drivers/tee/optee/protmem.c
+++ b/drivers/tee/optee/protmem.c
@@ -42,19 +42,16 @@ static int init_dyn_protmem(struct optee_protmem_dyn_pool *rp)
 		goto err_null_protmem;
 	}
 
-	/*
-	 * TODO unmap the memory range since the physical memory will
-	 * become inaccesible after the lend_protmem() call.
-	 *
-	 * If the platform supports a hypervisor at EL2, it will unmap the
-	 * intermediate physical memory for us and stop cache pre-fetch of
-	 * the memory.
-	 */
+	rc = optee_lend_pool_prepare(rp->optee, phys_to_page(rp->protmem->paddr),
+				     rp->page_count);
+	if (rc)
+		goto err_put_shm;
+
 	rc = rp->optee->ops->lend_protmem(rp->optee, rp->protmem,
 					  rp->mem_attrs,
 					  rp->mem_attr_count, rp->use_case);
 	if (rc)
-		goto err_put_shm;
+		goto err_lend_pool_reclaimed;
 	rp->protmem->flags |= TEE_SHM_DYNAMIC;
 
 	rp->gen_pool = gen_pool_create(PAGE_SHIFT, -1);
@@ -76,6 +73,9 @@ static int init_dyn_protmem(struct optee_protmem_dyn_pool *rp)
 	rp->gen_pool = NULL;
 err_reclaim:
 	rp->optee->ops->reclaim_protmem(rp->optee, rp->protmem);
+err_lend_pool_reclaimed:
+	optee_lend_pool_reclaimed(rp->optee, phys_to_page(rp->protmem->paddr),
+				  rp->page_count);
 err_put_shm:
 	tee_shm_put(rp->protmem);
 err_null_protmem:
@@ -112,6 +112,8 @@ static void release_dyn_protmem(struct optee_protmem_dyn_pool *rp)
 	rp->gen_pool = NULL;
 
 	rp->optee->ops->reclaim_protmem(rp->optee, rp->protmem);
+	optee_lend_pool_reclaimed(rp->optee, phys_to_page(rp->protmem->paddr),
+				  rp->page_count);
 	rp->protmem->flags &= ~TEE_SHM_DYNAMIC;
 
 	WARN(refcount_read(&rp->protmem->refcount) != 1, "Unexpected refcount");
diff --git a/drivers/tee/optee/smc_abi.c b/drivers/tee/optee/smc_abi.c
index b8a2bdac3208..e46eb881cf90 100644
--- a/drivers/tee/optee/smc_abi.c
+++ b/drivers/tee/optee/smc_abi.c
@@ -1522,7 +1522,6 @@ static void optee_smc_remove(struct platform_device *pdev)
 		optee_disable_shm_cache(optee);
 
 	optee_smc_notif_uninit_irq(optee);
-
 	optee_remove_common(optee);
 
 	if (optee->smc.memremaped_shm)
@@ -1714,14 +1713,25 @@ static int optee_protmem_pool_init(struct optee *optee)
 
 	if (protm)
 		pool = static_protmem_pool_init(optee);
-	if (dyn_protm && IS_ERR(pool))
+	if (dyn_protm && IS_ERR(pool)) {
+		rc = optee_lend_pool_register(optee);
+		if (rc)
+			return rc;
+
 		pool = optee_protmem_alloc_dyn_pool(optee, heap_id);
+		if (IS_ERR(pool)) {
+			optee_lend_pool_unregister(optee);
+			return PTR_ERR(pool);
+		}
+	}
 	if (IS_ERR(pool))
 		return PTR_ERR(pool);
 
 	rc = tee_device_register_dma_heap(optee->teedev, heap_id, pool);
-	if (rc)
+	if (rc) {
+		optee_lend_pool_unregister(optee);
 		pool->ops->destroy_pool(pool);
+	}
 
 	return rc;
 }
@@ -1833,14 +1843,14 @@ static int optee_probe(struct platform_device *pdev)
 	    (sec_caps & OPTEE_SMC_SEC_CAP_RPMB_PROBE))
 		optee->in_kernel_rpmb_routing = true;
 
-	teedev = tee_device_alloc(&optee_clnt_desc, NULL, pool, optee);
+	teedev = tee_device_alloc(&optee_clnt_desc, &pdev->dev, pool, optee);
 	if (IS_ERR(teedev)) {
 		rc = PTR_ERR(teedev);
 		goto err_free_optee;
 	}
 	optee->teedev = teedev;
 
-	teedev = tee_device_alloc(&optee_supp_desc, NULL, pool, optee);
+	teedev = tee_device_alloc(&optee_supp_desc, &pdev->dev, pool, optee);
 	if (IS_ERR(teedev)) {
 		rc = PTR_ERR(teedev);
 		goto err_unreg_teedev;
@@ -1932,6 +1942,7 @@ static int optee_probe(struct platform_device *pdev)
 		optee_disable_shm_cache(optee);
 	optee_smc_notif_uninit_irq(optee);
 	optee_unregister_devices();
+	optee_lend_pool_unregister(optee);
 err_notif_uninit:
 	optee_notif_uninit(optee);
 err_close_ctx:
-- 
2.55.0.1082.g2b9226bbc0-goog


