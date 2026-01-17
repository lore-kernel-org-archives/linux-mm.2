Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11E27C9832F
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 17:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70FBA6B008C; Sat, 17 Jan 2026 12:53:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EE936B0095; Sat, 17 Jan 2026 12:53:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3506A6B0093; Sat, 17 Jan 2026 12:53:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 19B3A6B0092
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 12:53:08 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC0545830E
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:53:07 +0000 (UTC)
X-FDA: 84342202014.17.A958AA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0B887A0003
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:53:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uRo/RGFb";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768672386; a=rsa-sha256;
	cv=none;
	b=tr7WbHRBIrLyAKOz1vFBAYAfsKxbDI4hk8i2RJa0yD1Ph2u6/5kUI6HPx433X0vdxqgnOS
	+pxXZyoyV5pe3ZZRNwDw+1jQdC6pjbMH3dPgGaU+W6Q4FEXC0nfkt2UYb9X97DAJLvmTnb
	cyxq5y9nPLdySITxLHLfd9pqrM3N93M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uRo/RGFb";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768672386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9SXSsHjarq+WnTYSKtroO2XyXlApy82NV06r9E+Nzk=;
	b=TW3RN3ek3jM9z1R4wudlGPYUdOcJbuKqrolGKu9C+NsoLWLYzKtc6/yzuorrLBqylmG3j5
	QgiyM8xlkLNpKeZJKpJSfG1hK4NWb17vmiZNgRrwK7NAavXYp+RAQCQsqCsmRVnsQOeRaW
	fFuzq7jNOD7cTnWHGmsAik8fol9JDDw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EBDE740392;
	Sat, 17 Jan 2026 17:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3594C19424;
	Sat, 17 Jan 2026 17:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768672384;
	bh=AH/DZBwYEbnLl/A558vtilxxCPLZZlZguhHUqR5KoKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRo/RGFb2F1Gvvj5IoUxCZoRDJzJrhCdh704F49bhGjp7psN3RSMgSFfPTx5V5gxX
	 O8huFE/LLrRSypF/OgWTE4yjXVLTV6Sa4MQ+ylPhEPONuEpHmZEMqm7j2g0B6HKAlf
	 diUk1K/CyqRrUiJA7e5RM2L9/nnMN1M/GcGi7+PThcGvG/8yNEJbniYaYg6sw0Yg3b
	 MylR0Xq7YxkgxsHm06EYJ7Cx8kI/sjKrlJhfy2Lo6kycV6JkenhPbFQvy27aoDBf2/
	 ypSdQJ2r+AGAjcP817uLI0hkpjCeABas7o6uHL7wdA4fqjk9yUl5PJP8nn3AslCz7V
	 5s8mqpq/NrGRA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/8] mm/damon: remove damon_operations->cleanup()
Date: Sat, 17 Jan 2026 09:52:48 -0800
Message-ID: <20260117175256.82826-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260117175256.82826-1-sj@kernel.org>
References: <20260117175256.82826-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qfzzs9fhqiok44grkj7m65s8hxy9bbzs
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0B887A0003
X-Rspam-User: 
X-HE-Tag: 1768672385-868983
X-HE-Meta: U2FsdGVkX1/i/2yabfoss9cOy6Qfw7mmXxVarXvFB4YZ4m5gMI2FFezmZVYt0Lek+Vrl/7JP8By2bEZgljjGIJ66pS23ql0c0QOZfIATIxv9cYG5yRyqsMEdy+4FvOX3a3r7J5g0X3c+XTIu6xJdxVW54bDAKX/WaxJ6yR6f0Wgt7IgKe4jMuqv7GEsrBP/sxy9QRewHz8iajfmnu4U75NbeA2o0LDaSXGrukAA9Q3en5GYYXaMEvkhGxy6TCVgKJ31fYaDHKZJQr6EtTu28rK5rMM1pU3N2m3sX+hzDSMd0fgpGXNQ1txE5RstWHG4NKgzo4hUMiqQhr60yFuX8862qHpI8hF1UtuvWQ9H1+TLfSU4bgbJcPiYc/5opAsK0yfVl+vYl67DCnF3+XZ5/MRVqIfpVBdN4Dk0pUoKPMO48SJZ62/ayKOwzuTx5KQuJ0+kH7KQ/0c9d34c6M4t+0Kh/eFSKwOFJLrI3pxwfdALSaMoXAr/JNnYAyxXb0zoGx+OzMCS9iw4B7jGbSZ3y4PaBTY/3LTnPzidoaD146dlRmZXpin+y4v6GVWnW5CMaozgMax8oUN02eHD2bkjfegYO1DAZ7qazqMcjRW2xDrKwr0Ijrd62wdqqrey/VIwB6PVSARHVdsQ9qHqjs/tYE4aGD/62tkzvgyziMSYtUfQBPmCE6M38wrQv73LxHBcu2fRNLjEIOtjDXe6jTjsMTvVgil2bLorJ29yRp6lDVExZteE1T5xRFQth4DAkdJ/ruvd2v/+vS6rIuf/iAqHqkt8GURflbE+7CO55ZPMRWX9vkiMm+lMG84U9/bAACLXn4EI1RjfaWrb4osBO0vDyTffs3pBjHZRfW+45NYzsU27k3stX1J0lYPLdkDj+93nD1vRJ5AJbuRKvnOo7zkG7F3ab3ky/ESm4V8ZOqyNjwSp3UrS3QGIKmbQw5zwfLC+SO8XQ0Jnmelgh+OjWUOi
 gwFgZASr
 pNSz2HfY/AFwuznFu0T66N5JGEb9ueuFoODQf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_operations->cleanup() was added for a case that an operation set
implementation requires additional cleanups.  But no such implementation
exists at the moment.  Remove it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 3 ---
 mm/damon/core.c       | 2 --
 mm/damon/paddr.c      | 1 -
 mm/damon/vaddr.c      | 1 -
 4 files changed, 7 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index e6930d8574d3..bd4c76b126bd 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -607,7 +607,6 @@ enum damon_ops_id {
  * @apply_scheme:		Apply a DAMON-based operation scheme.
  * @target_valid:		Determine if the target is valid.
  * @cleanup_target:		Clean up each target before deallocation.
- * @cleanup:			Clean up the context.
  *
  * DAMON can be extended for various address spaces and usages.  For this,
  * users should register the low level operations for their target address
@@ -640,7 +639,6 @@ enum damon_ops_id {
  * @target_valid should check whether the target is still valid for the
  * monitoring.
  * @cleanup_target is called before the target will be deallocated.
- * @cleanup is called from @kdamond just before its termination.
  */
 struct damon_operations {
 	enum damon_ops_id id;
@@ -656,7 +654,6 @@ struct damon_operations {
 			struct damos *scheme, unsigned long *sz_filter_passed);
 	bool (*target_valid)(struct damon_target *t);
 	void (*cleanup_target)(struct damon_target *t);
-	void (*cleanup)(struct damon_ctx *context);
 };
 
 /*
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 81b998d32074..53514cb712cf 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2859,8 +2859,6 @@ static int kdamond_fn(void *data)
 			damon_destroy_region(r, t);
 	}
 
-	if (ctx->ops.cleanup)
-		ctx->ops.cleanup(ctx);
 	kfree(ctx->regions_score_histogram);
 	kdamond_call(ctx, true);
 
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 4c2c935d82d6..9bfe48826840 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -373,7 +373,6 @@ static int __init damon_pa_initcall(void)
 		.prepare_access_checks = damon_pa_prepare_access_checks,
 		.check_accesses = damon_pa_check_accesses,
 		.target_valid = NULL,
-		.cleanup = NULL,
 		.apply_scheme = damon_pa_apply_scheme,
 		.get_scheme_score = damon_pa_scheme_score,
 	};
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 23ed738a0bd6..40c73adf1946 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -1014,7 +1014,6 @@ static int __init damon_va_initcall(void)
 		.check_accesses = damon_va_check_accesses,
 		.target_valid = damon_va_target_valid,
 		.cleanup_target = damon_va_cleanup_target,
-		.cleanup = NULL,
 		.apply_scheme = damon_va_apply_scheme,
 		.get_scheme_score = damon_va_scheme_score,
 	};
-- 
2.47.3

