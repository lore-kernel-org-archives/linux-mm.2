Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ABD7D3B7E1
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 22:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06E166B0005; Sat,  6 Dec 2025 17:47:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F2B6B0006; Sat,  6 Dec 2025 17:47:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4F256B0008; Sat,  6 Dec 2025 17:47:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D2F596B0005
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 17:47:52 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8064D8AB80
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 22:47:52 +0000 (UTC)
X-FDA: 84190535184.26.45FF9DE
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id A57874000A
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 22:47:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kwXgO4II;
	spf=pass (imf12.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765061270; a=rsa-sha256;
	cv=none;
	b=x2RXIPm50ankraUc+nw8Tm5g5qQT1GbL/3I7pK90e3D4raexrv1Cb2toXhfedi/nP/HTMV
	kIzFA6rOWmHydr+Ez3FmZQASJMmZvRBNDd1OaLyMTXciR1JhK6orMSOFdY+msLgXWdi03Q
	uZPZ+oSwWlNz6iLdREXp9cHd8pHZeVA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765061270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=p8HyIOypJQi8MinjibtE2pByaiOBmlIGh+lllMAA2tY=;
	b=fLXyzfPEqezuOpAcsYkjQ5EVYqglb7hw6bP8vvHqz6OJI3fnduKx/k+FDYCCRMmeI9DFeq
	QWrRMw/YiBUWnhe/r+6N2pM7KpeC04W5B7aRL7FgGqbySBLbHjmxPBiG9knGgFePe11AVN
	dMDt51JM3smMGI+xYb+k781Etufg3bw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kwXgO4II;
	spf=pass (imf12.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7ba49f92362so1871291b3a.1
        for <linux-mm@kvack.org>; Sat, 06 Dec 2025 14:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765061269; x=1765666069; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p8HyIOypJQi8MinjibtE2pByaiOBmlIGh+lllMAA2tY=;
        b=kwXgO4II9VBATVBHZCz69lPTwPxcrcXy747Rlzg1T3Q/An4NXeQeSe7cZKAUanRSBm
         f122uQiOjYLfPh0guqhGRXEzoC9FqxVenQzGjPShpLGTYAIEZ+6KC8vuPK1nK1Whd+BO
         iuWMFz0UfnCu/VH/FntIBZ3yB2V0X6rcr+lEZU3MqTih0JdNcyHUzbCzuqT8+tFYWYHv
         oCyXBnT8ekE97cg7MTAvm7f8YJzlMnxghYU7ujM2BRBIY6ScBIRNnVAvHNmx+Rd+1Er6
         XOCD8+jA7BaAWUidHYdJblBxMKlkXmgF34dGoL2UvwTqXbCxjX76tmKcYMQsXGarCLtp
         3hfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765061269; x=1765666069;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p8HyIOypJQi8MinjibtE2pByaiOBmlIGh+lllMAA2tY=;
        b=nP10jkEqNiVEvLMbQi29PH5zLNG2NZZym0pBAtcx3CSJPhXOaNjPj1VMy35brBBsb3
         SipAJlbkoiHnuBytl+UudunegjPXU4NSejnyFSNOeNXAj1CNzl37WUks8H96KXrjgsos
         EC8F+udqHB0Wb4BlfM/ZTZtm0gtJyjTrueSspkOGJ2sgCW30ImXdojkeWPnSLTOc718h
         S85QcqEPQnNJfOkbf1Y7WtIA/9CzVTzbFoqEuOHO5c3tkvegD39YPna9b3buhVs43aaW
         GGJMlavlCtGpeua0OZYVy/3bqegzhvBmeEpz7Gy4o4/yP9rK80mBCfCxZrk36usbaECc
         HGRw==
X-Forwarded-Encrypted: i=1; AJvYcCVAcAjZp+pxsMMXaUdfPLQVQSreVmPYAy1h4BuPK9lijT0dKz3dXEE9lI14bOGPt4BKaA5iXLJ7pw==@kvack.org
X-Gm-Message-State: AOJu0Yw1XrO0kvpZI9x5QaBAAF83utAaBls7I+vX6oZbnqxqtaJTdOGi
	fc9JUoHMD60hILZ/s+L8w8dozMT5NwZgpcH8FdE+T4uQg/ISZ/3GhQP3
X-Gm-Gg: ASbGnctROm+hFzV5tjm4MUgBfHDR3bYfJJVFeoOkqnUX4aWhNvcyphEuChOUaddSz49
	VxlDEOL97BvYFPaJCoISw9L6h6teJj2ZkdVr3F6Xstb8SEQVdfqWcsD469UIJcQyUlCYDmA7leH
	9mOw16fF9Zm0hLbaL51fU77gamddvhMSHd/2RAx0tI6bvUjtzxqOdo2961+bzET0jcI6cOGgnof
	ifWaVnuSbhtYH2gtK9AD0cB2TPplR6nEHe3gJI1hrFgASw4AYSm8i6WPK3Pj5VtzZ1uzkvkvS7z
	nUEymRsuMkqPLGarfT4wPTS8VgHvzHFwfloG6+4C/6Ybe2kBIPL2R42ioBQ+cCGClKG9l07X6EW
	hRjaVZYQ0z9IgrhiP32KZ715ZqcHW/3eQc6Jr6O5D5Y38EvfvknCd5KTK5VmfFiGvZ7NGPyHjeS
	AQArJrvtTQROKU
X-Google-Smtp-Source: AGHT+IG5H8nxjn7G4JCl9iN3Z23UEpNSUowdVhWCNwSa30pQ3LuY45xdznOSufJ/9sRdo9pF+fHD3g==
X-Received: by 2002:a05:6a00:94c7:b0:77e:d2f7:f307 with SMTP id d2e1a72fcca58-7e8b7578ad6mr3537901b3a.9.1765061269365;
        Sat, 06 Dec 2025 14:47:49 -0800 (PST)
Received: from HP-Note-Host.. ([222.234.91.137])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7e2aead366fsm8796486b3a.51.2025.12.06.14.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Dec 2025 14:47:48 -0800 (PST)
From: JaeJoon Jung <rgbi3307@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: JaeJoon Jung <rgbi3307@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon: modified damon_call_control from static to kmalloc
Date: Sun,  7 Dec 2025 07:47:23 +0900
Message-ID: <20251206224724.13832-1-rgbi3307@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A57874000A
X-Stat-Signature: imypgrs159oimrekorogheepjqodutga
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765061270-808375
X-HE-Meta: U2FsdGVkX182zLvOumHlDpDvvioFcKncFdlYr8wwCQfq1DYDdY9nUsbHZYaD4anmCfdL/QwtIQxAzRDl0J4IRxEdCSSzqDuZXN679D5jlxxGR0DagXe0GXeK4jdVe4ZO0Q/oYeHztnoMy4OlXFfIZMDUvitCTYAI8tuapi3jErZX7ddNIrtSZIeA7bShYgzWfdQ7d8MjUukfnHcA2UgGuTDUd/0vV0n/LLl/bnKXZvakQIcqSoxFpG3Esm4X8agh7Pc0bqzzhz6cW0uxy5/XYByiqI0N598nj6spHh9Vfb4OuqWaF5WG0PsW0plqr/F3sN5cwvfQlpQRX0mWKIu3DfT+uEgzdrg0qBdAwhnIZJcUPiZIhDBQhyI7bNbtVzwz5aZKm1GS8sP8x/34ZrXHU4/PV/rM22cvdPFXRvFB3MIE9XObdqETybxWUeUvWy0w1sTH45c4Zgppnt5Yr2u0Ei0RP/CkITsjw3FMCECRqFqL6HcFNwLj1VSuJo5M8v+y8IeDG2sY+U8VW9WaD3QZU3idLZP6w8Zwq3nkcWclV0Hm51tlOYEBm8OWHwZ+vWG2v17A72PhYf1smXtmbyHLZvY7+ca1Gc/xKiULUpXZtbnaya9LpAFw5Irn/pr09/jZTl7zbvTFOQRejgP+FjV6bNomh6ab9q+FqmjXqmE43vb8FHK0p7pE38AqMR6FR/pMROPRcDguEPxDzRqaqjtPb9QJnE10Hv+QZktwSen7kQXKqXFd0OQXusS8d+S5GWzMrprou2nFURnK+zVotBHHshG5wYvH5OVEy2x8Xh6+5W1MEtgMeiTlZs3Rg6GrX5dbWMpgwVty6VoqX+QBtJyCV3FSmYKryckCALZimCJ8BCN6p3wunPL+/wq4sBbY+MSgVZiLZHXOASpg+6Qj0wb65y7htLjaW/PgiZNfiO/D9/EyWepN9mAdQYjJ0ejapBDzzOyJqtOToptTM7GG9Xu
 Spu+iNF8
 GxhheKUDHqGvYW0BSDc+91bkIsyl30qjnGkdx8gGQnShCREBBDEY9g7R3efkTRBAUJ/nrbqdrGwbKJHov0E87F6c4lTmAR6euATh5K/4EInU3ApcWzxrtwFRfpcKft4D3lxOwLQBMuw45zXP4ub4DpEJxNLkpy/9DqwvxVZi5gjqbTzvt8IbU8ppmTv8CsbBp1tUpz3zMqnU/EoRJyawwrNejb9HSngbNUgs4YmqEQxOPVf8KteSLzwRyCKXLeiX+I7Weqh4mcnd4qnbd6sQHSp7HuRSgITRdrh6wEHwb2Nb18IfQaswwf5mukgrTgX3XlSoauIlG/b0Z9iX70/qAawZgDH5AP+VD1ZDJkgoFnRvknToNFvkCMKeovIk/IPvqNFTWdeDZuAANKgdaYj0phbK1FOBCvxKDowaeSYxj9Yx0JBAhvWiSi10UCK3cQ2OAJ4e9xXRvnmeqi6jw1D3tpl5JEcP46iJLLJg2cuBhzQZD6R0fJo4jjhFtAK9c6OOfpwveslFYqer7NHllypV5X52e5JbNDFZ7VKKrkbBPtGxdbatHB0jnONRMogMo7KyjE0k4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The damon_call_control structure is used by all damon modules.
In mm/damon/sysfs.c, it is dynamically allocated with kmalloc(), and in
the remaining modules, it is statically coded.  There are many daemon
modules and they are designed to be used only when needed.  It is more
efficient to use kmalloc dynamically whenever needed as in damon/sysfs.c.
Using damon_call_control dynamically and consistently has the advantage of
eliminating the dealloc_on_cancel member variable condition and reducing
code size.

Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
---
 include/linux/damon.h |  2 --
 mm/damon/core.c       |  2 +-
 mm/damon/lru_sort.c   | 20 ++++++++++++--------
 mm/damon/reclaim.c    | 20 ++++++++++++--------
 mm/damon/stat.c       | 18 +++++++++++-------
 mm/damon/sysfs.c      |  1 -
 samples/damon/prcl.c  | 17 ++++++++++-------
 samples/damon/wsse.c  | 18 +++++++++++-------
 8 files changed, 57 insertions(+), 41 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index cae8c613c5fc..7a4d7196cc75 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -636,7 +636,6 @@ struct damon_operations {
  * @data:		Data that will be passed to @fn.
  * @repeat:		Repeat invocations.
  * @return_code:	Return code from @fn invocation.
- * @dealloc_on_cancel:	De-allocate when canceled.
  *
  * Control damon_call(), which requests specific kdamond to invoke a given
  * function.  Refer to damon_call() for more details.
@@ -646,7 +645,6 @@ struct damon_call_control {
 	void *data;
 	bool repeat;
 	int return_code;
-	bool dealloc_on_cancel;
 /* private: internal use only */
 	/* informs if the kdamond finished handling of the request */
 	struct completion completion;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 109b050c795a..fb3f844d5da5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2519,7 +2519,7 @@ static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 		mutex_unlock(&ctx->call_controls_lock);
 		if (!control->repeat) {
 			complete(&control->completion);
-		} else if (control->canceled && control->dealloc_on_cancel) {
+		} else if (control->canceled) {
 			kfree(control);
 			continue;
 		} else {
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 42b9a656f9de..e3d6a46fa2fb 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -279,14 +279,10 @@ static int damon_lru_sort_damon_call_fn(void *arg)
 	return damon_lru_sort_handle_commit_inputs();
 }

-static struct damon_call_control call_control = {
-	.fn = damon_lru_sort_damon_call_fn,
-	.repeat = true,
-};
-
 static int damon_lru_sort_turn(bool on)
 {
 	int err;
+	struct damon_call_control *call_control;

 	if (!on) {
 		err = damon_stop(&ctx, 1);
@@ -302,8 +298,18 @@ static int damon_lru_sort_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
+
 	kdamond_pid = ctx->kdamond->pid;
-	return damon_call(ctx, &call_control);
+
+	call_control = kmalloc(sizeof(*call_control), GFP_KERNEL);
+	if (!call_control)
+		return -ENOMEM;
+
+	call_control->fn = damon_lru_sort_damon_call_fn;
+	call_control->repeat = true;
+	call_control->data = ctx;
+
+	return damon_call(ctx, call_control);
 }

 static int damon_lru_sort_addr_unit_store(const char *val,
@@ -378,8 +384,6 @@ static int __init damon_lru_sort_init(void)
 	if (err)
 		goto out;

-	call_control.data = ctx;
-
 	/* 'enabled' has set before this function, probably via command line */
 	if (enabled)
 		err = damon_lru_sort_turn(true);
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 7ba3d0f9a19a..967d06d938d6 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -283,14 +283,10 @@ static int damon_reclaim_damon_call_fn(void *arg)
 	return damon_reclaim_handle_commit_inputs();
 }

-static struct damon_call_control call_control = {
-	.fn = damon_reclaim_damon_call_fn,
-	.repeat = true,
-};
-
 static int damon_reclaim_turn(bool on)
 {
 	int err;
+	struct damon_call_control *call_control;

 	if (!on) {
 		err = damon_stop(&ctx, 1);
@@ -306,8 +302,18 @@ static int damon_reclaim_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
+
 	kdamond_pid = ctx->kdamond->pid;
-	return damon_call(ctx, &call_control);
+
+	call_control = kmalloc(sizeof(*call_control), GFP_KERNEL);
+	if (!call_control)
+		return -ENOMEM;
+
+	call_control->fn = damon_reclaim_damon_call_fn;
+	call_control->repeat = true;
+	call_control->data = ctx;
+
+	return damon_call(ctx, call_control);
 }

 static int damon_reclaim_addr_unit_store(const char *val,
@@ -382,8 +388,6 @@ static int __init damon_reclaim_init(void)
 	if (err)
 		goto out;

-	call_control.data = ctx;
-
 	/* 'enabled' has set before this function, probably via command line */
 	if (enabled)
 		err = damon_reclaim_turn(true);
diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index bf8626859902..6a21de62c3f4 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -196,14 +196,10 @@ static struct damon_ctx *damon_stat_build_ctx(void)
 	return NULL;
 }

-static struct damon_call_control call_control = {
-	.fn = damon_stat_damon_call_fn,
-	.repeat = true,
-};
-
 static int damon_stat_start(void)
 {
 	int err;
+	struct damon_call_control *call_control;

 	damon_stat_context = damon_stat_build_ctx();
 	if (!damon_stat_context)
@@ -213,8 +209,16 @@ static int damon_stat_start(void)
 		return err;

 	damon_stat_last_refresh_jiffies = jiffies;
-	call_control.data = damon_stat_context;
-	return damon_call(damon_stat_context, &call_control);
+
+	call_control = kmalloc(sizeof(*call_control), GFP_KERNEL);
+	if (!call_control)
+		return -ENOMEM;
+
+	call_control->fn = damon_stat_damon_call_fn;
+	call_control->repeat = true;
+	call_control->data = damon_stat_context;
+
+	return damon_call(damon_stat_context, call_control);
 }

 static void damon_stat_stop(void)
diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 3c0d727788c8..3cd0af16a92f 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1614,7 +1614,6 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 	repeat_call_control->fn = damon_sysfs_repeat_call_fn;
 	repeat_call_control->data = kdamond;
 	repeat_call_control->repeat = true;
-	repeat_call_control->dealloc_on_cancel = true;
 	damon_call(ctx, repeat_call_control);
 	return err;
 }
diff --git a/samples/damon/prcl.c b/samples/damon/prcl.c
index b7c50f2656ce..b71914549725 100644
--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -52,15 +52,11 @@ static int damon_sample_prcl_repeat_call_fn(void *data)
 	return 0;
 }

-static struct damon_call_control repeat_call_control = {
-	.fn = damon_sample_prcl_repeat_call_fn,
-	.repeat = true,
-};
-
 static int damon_sample_prcl_start(void)
 {
 	struct damon_target *target;
 	struct damos *scheme;
+	struct damon_call_control *call_control;
 	int err;

 	pr_info("start\n");
@@ -109,8 +105,15 @@ static int damon_sample_prcl_start(void)
 	if (err)
 		return err;

-	repeat_call_control.data = ctx;
-	return damon_call(ctx, &repeat_call_control);
+	call_control = kmalloc(sizeof(*call_control), GFP_KERNEL);
+	if (!call_control)
+		return -ENOMEM;
+
+	call_control->fn = damon_sample_prcl_repeat_call_fn;
+	call_control->repeat = true;
+	call_control->data = ctx;
+
+	return damon_call(ctx, call_control);
 }

 static void damon_sample_prcl_stop(void)
diff --git a/samples/damon/wsse.c b/samples/damon/wsse.c
index 799ad4443943..e9cbc4be3706 100644
--- a/samples/damon/wsse.c
+++ b/samples/damon/wsse.c
@@ -53,14 +53,10 @@ static int damon_sample_wsse_repeat_call_fn(void *data)
 	return 0;
 }

-static struct damon_call_control repeat_call_control = {
-	.fn = damon_sample_wsse_repeat_call_fn,
-	.repeat = true,
-};
-
 static int damon_sample_wsse_start(void)
 {
 	struct damon_target *target;
+	struct damon_call_control *call_control;
 	int err;

 	pr_info("start\n");
@@ -89,8 +85,16 @@ static int damon_sample_wsse_start(void)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
-	repeat_call_control.data = ctx;
-	return damon_call(ctx, &repeat_call_control);
+
+	call_control = kmalloc(sizeof(*call_control), GFP_KERNEL);
+	if (!call_control)
+		return -ENOMEM;
+
+	call_control->fn = damon_sample_wsse_repeat_call_fn;
+	call_control->repeat = true;
+	call_control->data = ctx;
+
+	return damon_call(ctx, call_control);
 }

 static void damon_sample_wsse_stop(void)
--
2.43.0


