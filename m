Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F90CC9832F
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 17:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F4736B0093; Sat, 17 Jan 2026 12:53:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48FAD6B008C; Sat, 17 Jan 2026 12:53:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29D2C6B0095; Sat, 17 Jan 2026 12:53:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 160696B008C
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 12:53:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BC02C1A02FF
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:53:07 +0000 (UTC)
X-FDA: 84342202014.12.481FDCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 183E11C0004
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:53:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mJTU5Bsm;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768672386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KkREkgbaZdi6dH8X6KjYuNUssFMGO9jdYf+WGLfyQ9k=;
	b=FGK+60xlR2xPV+NPYaPbVtaYzeTbVmAzEofw2+dJ5gM6HdG2/cRXXpFUrXS4wj97f/KlFj
	YLFzsXAehOTfbJooX9/C5UTmZKXKwNpnYxdf2G8OyLSeGLszSjpIfASeoaMrU64QUkeD9m
	3Y6LioxOxJoPf5PIQQzFVBd1oWA5Rys=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mJTU5Bsm;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768672386; a=rsa-sha256;
	cv=none;
	b=LbsTmzsBjANX4XSbt8D2kJmchSFQqHmonxjRzdtRjZ3YZIHsgzHZdic/uSkXdb6jQYpTSE
	tPZfJA9ya+YoYexnnnFeMN1OHXXOOwsVKwPiDS8YRhZdHw2zhUNTIpRf23VBnq8XHuFWDh
	J3b8s5DDMKOv37Xg+YNJb+mRXUsJGcY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3097744469;
	Sat, 17 Jan 2026 17:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFEBC2BC86;
	Sat, 17 Jan 2026 17:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768672385;
	bh=KFdeOU1Cqynn16FGkaHhjOKt5M+h0bd+XluHiDK/WQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJTU5BsmjgSpWiQ4aBcyH4NoTiDDamTXPlbz+OYyNaiO4LtArWbnSEFsp9LSoj9t2
	 BFhSaVj/s2oJEvv8OPmFUxC+wN2SnMf55tmnkKQg+NxGOKLdWqXr2Lh88pYSqWF6k9
	 MiryKagHnXH6+9+K+F+TQDJdgV2D0HI3SAjXJvdCEYAbjNys02TkwQN6U7ss4osRbF
	 xdFzz3AHs4KVIIbeEbXgUaEauGh/KAUhlWUVwOew5jn6H/ULP+KltyueEh62pkxjZX
	 cv/iQGwQn3Fax2eoIVtcafhXSdeU2edAkWbOtuu/PDuBF5p4dvpoTuTb7cQ5sRXrKl
	 qzMeg+eode2jA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/8] mm/damon/core: cleanup targets and regions at once on kdamond termination
Date: Sat, 17 Jan 2026 09:52:49 -0800
Message-ID: <20260117175256.82826-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260117175256.82826-1-sj@kernel.org>
References: <20260117175256.82826-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jmat883iqb9rogqjc54f4j7j7g8bxd19
X-Rspam-User: 
X-Rspamd-Queue-Id: 183E11C0004
X-Rspamd-Server: rspam08
X-HE-Tag: 1768672385-685503
X-HE-Meta: U2FsdGVkX1+aPReXjThgM02HXYhEqy6UTuKYzK29K/pFHjtuAYXDFn516HwECR2QKFVBGOdu/qkk8/yel7TgdwrpQaHodGCh1rn4bsKpIFIWYp9NaHCjtSfyp8KFPiKz1B6Nm1At5939TRY1+a92szrShv/uhV16OZ/Ctq7kcJO4tmBpBL8QKdUIUwdL1l4IjiD28xlKVhsL1QJXY96R0EbFy2GFmNGOHyKgda4uronFuLTjMA+D5NuufKz/HW0ekTRNQfmwMLbOLm+TbCmmdLNEL30PK47S/9KXtGI4otU9wIQzjD68mTj4hnjSYBLL5mEobEJ33PsOn5pCoZ4MuaMsHmBqKg3TiYnCRx3YjiGhmlTcZ8Z5PE/o1gutalHDdMJXwGb56D6nl/XAfXDoLQjHSIpQT3Qt8BzToPIgmVEiyh/KjLlaBl/lIkUcKzQndfVl3U9UboQT/nht2EZtjtIlDaN5THWMyPxOylOrQezyHA0iz2XL5C+nIRjHMJ9GhpVRljTIIZZ/AO5AAyGzMmGkU7EoPzJIjZQjIiJNSUsno8PSg8X40YaqQj9GC7AqjuvRZO0t0mNv7+WBVDIvivt8LgnsuSrNmQhpovhic2go2bYjozzJREPkahvswby4bY/4Ll13FcaHozm45wQEUkKwcVP60xRyf6SJcQWQbHhXjAVsjW+fU+pYrq6WINuZ+LNN1Kgv8FUce8jxwj3gX8ErAKPtmfE+Z200m0CC05KdFRW7n2I87KSDLqpArvpnB1FfdSKfs15jJsg50GVkyLEuKoJx/gA7CsQArCz8sm0cjzCuMdqTFheXPGxE4FpAy/9/CuAq+4qkIQBUVT1xBhc+gAYzkl8bKlWGG8o0gmlC1hpDugARdWdwVpgij/geVrEuwfMxm2IEPmJfqlbEk3d1qjFd6HUgLWFR2k6GXkQnFo6n2IhE/vuUtQsMG4GfrEuaypkuWxZRM1bc/3X
 HBVu8s0a
 AxgjJHYN4QASgWyU4PZv1ugT05BbbxZC4BHf9H9ERLzgFpJfTr+F8fNsH8Gcs2zHIunMKOh6nnjP+iPsZRJGpZFUD6WJfALxGgIWBqz/k0/uTcP7gD2GlhysOKuwLo1rXu2+yFnKA/7UGcwoC87zOMyHmLv+G+o9am4EpWj9DRh6jRKOtrVZ7ECrxfydVhFs+3iwj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kdamond terminates, it destroys the regions of the context first,
and the targets of the context just before the kdamond main function
returns.  Because regions are linked inside targets, doing them
separately is only inefficient and looks weird.  A more serious problem
is that the cleanup of the targets is done after damon_ctx->kdamond
reset, which is the event that lets DAMON API callers know the kdamond
is no longer actively running.  That is, some DAMON targets could still
exist while kdamond is not running.  There are no real problems from
this, but this implicit fact could cause subtle racy issues in future.
Destroy targets and regions at one.

Adding contexts on how the code has evolved in the way.  Doing only
regions destruction was because putting pids of the targets were done on
DAMON API callers.  Commit 7114bc5e01cf ("mm/damon/core: add
cleanup_target() ops callback") moved the role to be done via operations
set on each target destruction.  Hence it removed the reason to do only
regions cleanup.  Commit 3a69f1635769 ("mm/damon/core: destroy targets
when kdamond_fn() finish") therefore further destructed targets on
kdamond termination time.  It was still separated from regions
destruction because damon_operations->cleanup() may do additional
targets cleanup.  Placing the targets destruction after
damon_ctx->kdamond reset was just an unnecessary decision of the commit.
The previous commit removed damon_operations->cleanup(), so there is no
more reason to do destructions of regions and targets separately.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 53514cb712cf..0c8ac11a49f9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2748,8 +2748,6 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 static int kdamond_fn(void *data)
 {
 	struct damon_ctx *ctx = data;
-	struct damon_target *t;
-	struct damon_region *r, *next;
 	unsigned int max_nr_accesses = 0;
 	unsigned long sz_limit = 0;
 
@@ -2854,10 +2852,7 @@ static int kdamond_fn(void *data)
 		}
 	}
 done:
-	damon_for_each_target(t, ctx) {
-		damon_for_each_region_safe(r, next, t)
-			damon_destroy_region(r, t);
-	}
+	damon_destroy_targets(ctx);
 
 	kfree(ctx->regions_score_histogram);
 	kdamond_call(ctx, true);
@@ -2875,7 +2870,6 @@ static int kdamond_fn(void *data)
 		running_exclusive_ctxs = false;
 	mutex_unlock(&damon_lock);
 
-	damon_destroy_targets(ctx);
 	return 0;
 }
 
-- 
2.47.3

