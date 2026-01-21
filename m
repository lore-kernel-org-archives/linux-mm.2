Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 875D8CA5FBA
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 03:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008346B0005; Tue, 20 Jan 2026 22:41:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF86A6B0088; Tue, 20 Jan 2026 22:41:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF76B6B0089; Tue, 20 Jan 2026 22:41:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D19C86B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 22:41:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F1C21A07B1
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:41:48 +0000 (UTC)
X-FDA: 84354571896.09.D48859D
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 88BB8C0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:41:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=MLXyUFtd;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768966906; a=rsa-sha256;
	cv=none;
	b=BZKhLcT9V+OqJol7ik2rIuHF00riHR4TwZup2UAMRe28eomiGpvXBIJ2TotNbwBZ7iCrCV
	mk09kUzH/dZKb6kmfS3oKowSrW+YkBIIyC3KZw4HDNj+bk+g+MF8GLjbaIWvrZsd2y6u59
	+OQWIXa76AEmppEUlnjouBOB2Sj2NpI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=MLXyUFtd;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768966906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nIV3xvOe2RyeHCdqN7cWwo25EnzOGG/6eEyKfi9EgWc=;
	b=Gj49uclPNZVYyFqq7klfj0u/17xmiCw34vajkh7/ozAWRbO+oMJ8iuYStLW9mzo529fPMr
	jWBwfmIKz91f11GYVXfHHN8v3SDI6ExoeIuOBmwFb6aqr6+4S1C8X96lq4ZPu9GOxHFcxS
	aLtg4TlrcJCiq7d8uJDI6p3NZPOAum0=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7b22ffa2a88so2662544b3a.1
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 19:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768966905; x=1769571705; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nIV3xvOe2RyeHCdqN7cWwo25EnzOGG/6eEyKfi9EgWc=;
        b=MLXyUFtdxbPewk6X8Ofu3U+Omlw6EYKFpAyZlfIBdpyftXK0EMjah9do97tIKG3SuX
         9f4TpROYkBS73bfnxPKpi+FVah0EaxMRmxyrldYpeB6Ji0HcSdBF7W5uL9FmWYNU/drT
         nGggq3+52A2axkZW6BvrtFFSg7LTi/w3ST4Pk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768966905; x=1769571705;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nIV3xvOe2RyeHCdqN7cWwo25EnzOGG/6eEyKfi9EgWc=;
        b=Hz4wXqUS9WquJrcifXRul8fWXMwKp7HRrtFMZACExYLXgcc52gy3PZRtZnLqtngBCQ
         EVxBRZITXYRSk1izwnwj6ADp626YLggxeSQKeYpvgSnEA3R/LvlRffL2wmQIRoy4AimV
         H3cgeI8iPj+gp3tXLXiZySRDTlLWsynPu1jTOOdYh3bakwDa4QSHaU/ezxeTscFbQ4jG
         NJvE7hku2CAzBgfxxJU+Sl5ZSo9HyYH+zs7vuP8nI7xKaKUq3m+kCxAQzWPp6XEecg9E
         uav/XvaRGSiL019CINhgWOhplt8QL11URpMo1sRTA70JwuxCqkx1OgEvL3ywGfNV8eu0
         K5lQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCiLTtdIk9e8H5P5A/PEsd84EyIqlVH5sa78hCbE2+RG28n/iletii76Ao+5wR1+jDyc3ARIpGBQ==@kvack.org
X-Gm-Message-State: AOJu0YzDs+xDoPiZ1Y9PHjB0joj2KWXVExDN7Xpf6dnKCPQ7v3BBx8+E
	DEqaYwGTHjvQ1GFrjgwc2J58e1nfW7xOQyrfU57Qg9uDjeSZxzmVQP3RoHtqAPBAFg==
X-Gm-Gg: AZuq6aI/fB/XO8q2XnJW/Sb/8o+lpbwk3kcCdZwk5DpbmDnaUtGem6tVcz/yjqiLQQx
	4T7C+687JI+KxxrED4SiI71bHog44hltPc2/lEs7iT8YzNYU2wQ37+6BDOaKcpEnya/19D+SSM/
	iN4HnSYJEq9LJg3ETU1yRGYZ07nCJE7rmb52g3p2W0ssfN2HZq9TKUm8qapLGJAJJe7d2PHob0R
	VSF4hf8jvot/C6/+xQhHpCyjWafUhm5ew7MhqN4fxVc3PmTl6DdrcFxPhZu/kOwIBCoKZEa7aSu
	CjY76rBf5u3wEYinCzaOLShPzGNVpJ4KfwbG/aZ14VJwfTW9lQdVLi4X7ywD5QkibxmYUHsqIzt
	rhd0bGJ9rtdYn6haBQRMIvJpvg7GZ32MWVAPMFMOn0P385/vJ2b5cOWN0c8qAAlM8oGoX6FmJnQ
	j8S33hoAEWhkbHSA28wc0hAa9NEOzpCRIev1JUnsgN1EDvsH7uXQ==
X-Received: by 2002:aa7:88d6:0:b0:7e8:4471:ae6d with SMTP id d2e1a72fcca58-81fa1862fd1mr13008426b3a.57.1768966905317;
        Tue, 20 Jan 2026 19:41:45 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:a85f:a6d:c028:515a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa1278061sm13468456b3a.44.2026.01.20.19.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 19:41:44 -0800 (PST)
Date: Wed, 21 Jan 2026 12:41:39 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH] zsmalloc: make common caches global
Message-ID: <kmku2oyevj5vbt6na73iyksyod4sjcvik5zx43h4mw55m744oo@ddiynkvadmni>
References: <20260116044841.334821-1-senozhatsky@chromium.org>
 <zfmvd2oogwtx6mbavyjgwxralsvrd576ye6jnscfwvqy4u4ayp@q7qpxnyaxb6f>
 <CAKEwX=OJBc38i6ZhObNsvsNGJ16ZuNXkV18f-j=JRd-2xecJQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=OJBc38i6ZhObNsvsNGJ16ZuNXkV18f-j=JRd-2xecJQg@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: u5cw3zqf1od4h5azr97ncifsdtzgbyob
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 88BB8C0005
X-HE-Tag: 1768966906-520839
X-HE-Meta: U2FsdGVkX1+nXLd71HLAGwDJW/wBs24VMdy8AGB8NCrNVE6zQo3DHaYCfIRr8krSR4mRJwTDYGXLg5WhwYKIhgIbKB7MvvCWNcvvseUAbtobOnnkhL4ZmvGKD9tF3t+Fqnjx5bohIQOVfNPyNp+XbP1aCRGaWqEUIzNK8ZeP22sdNSZeDfqUqbfO6bTQVeIQ9xrTjBaThA3en/69DmqjvcnROIHKcFk7U9+YN31WBSg9A9DgIuviC054Hp+E6eNlJ4bQmW4xNkQoKG+i0RQyTTvIYZ5B8wI5k+rirpSTDJvoTMt9pSMSQ1BeofA48bU8TRO1EfV9FgcwfCzHIy09n944m36qSKtJ3Ew1oVXuTvfBhTs7Gx0MLK2XpM1ptlhqOap9E3HhfC3425hL1Aa1wUBAZGZ1nZrX/3AWB+KSX0Dh/0wiHxD+MJLpfjHW2MQ/PrDjWF6kG2c3YOVLFPv1K1jdsSeblRfu2wAVj7wOk9jHEauDJM789hj/q9Rf7U4oq846JE23yzGGAVbSeTLSQ6bnDqTNwok2Ee0Hdl/sAGvfb133vifCc7zvfsKO8MbpVc7jUyP92aQthcgwRWsTSJuX0Go3Cvcrl2UhAcqeas5zYcwAsQD6Nj1EUz6vlstU2wNkBYKBtL80S5ge/vEJ3b18LfqB4lPWic6TMNpp8QJHCDe3vFnMjHXVTw+P/x3V7rPW+eXrBBaT9veOe1USNxbiDQ1vLt9v+xjBGjx6g5p3RXQGep6Z5vK2YmidWHyx0+/YDOp2TzztoGWopBA6QOvLnEc30W2AGgHVRhb9Xv6rtyMFIsB1TZnUX5UTsodN4sovRb6z53uf2kq9KX4stvofYVa3MvZ95gKQKz8pVLoXZ/3frfuFQ6g7oR38TkF7GyDlKlTGmHEhNYLagQyXqHaWoDXw+ky8RLfldDMk5vrp5ZkmOMuhrNnLE4rOLlPmic9foR9UrqD7Hy4czZD
 gXZXmMA2
 feEkt/9m0IduQDEOk2K654uAVWsNGh3rCxsYjjRUCuVsb6+tuavDCdyft/GOI1/EeRS6vb/Hc1zlU2oSBjq3tpEHv75Us0mdnEBdmFT37BOi2sfXmWe8RECPYG/N0tkUfVMam6dng8SEjLT2PNMMbc8ZiEvGC8ySoMwyEuNio1jfKwOMrzRtikHAIBlUUiw6XJjlHNoQ1FCaCCuIK8mGcDryX+Sf40h1TEdgWNRCAH5wc6yRZLDGH/pyuSGWgH7jE5tLPJx2caPUw3ZEQyC2UaYiROw7l6uDncxRhOzmXgXf1rCtoI+FZ6v/YI09fOMw1RxCG33apabL+Dd4bRJhn5ntk3+v7DDsILP6SfeBscbJIQBb9KZWOBlvrPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/19 13:44), Nhat Pham wrote:
> On Thu, Jan 15, 2026 at 9:53 PM Sergey Senozhatsky
> <senozhatsky@chromium.org> wrote:
> >
> > On (26/01/16 13:48), Sergey Senozhatsky wrote:
> > > Currently, zsmalloc creates kmem_cache of handles and zspages
> > > for each pool, which may be suboptimal from the memory usage
> > > point of view (extra internal fragmentation per pool).  Systems
> > > that create multiple zsmalloc pools may benefit from shared
> > > common zsmalloc caches.
> >
> > This is step 1.
> >
> > Step 2 is to look into possibility of sharing zsmalloc pools.
> > E.g. if there are N zram devices in the system, do we really need
> > N zsmalloc pools?  Can we just share a single pool between them?
> 
> Ditto for zswap (although here, we almost always only have a single zswap pool).

COMPLETELY UNTESTED (current linux-next doesn't boot for me, hitting
an "Oops: stack guard page: 0000" early during boot).

So I'm thinking of something like below.  Basically have a Kconfig
option to turn zsmalloc into a singleton pool mode, transparently
for zsmalloc users.

---
 mm/Kconfig    | 11 ++++++++
 mm/zsmalloc.c | 73 ++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 72 insertions(+), 12 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 4fc1a171dffa..ff6855e74c3d 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -132,6 +132,17 @@ menu "Zsmalloc allocator options"
 
 comment "Zsmalloc is a common backend allocator for zswap & zram"
 
+config ZSMALLOC_SINGLETON_POOL
+	bool "Use a singleton zsmalloc pool"
+	default n
+	help
+	  This option enables the use of a single global zsmalloc pool
+	  instance for all users of zsmalloc (e.g., zswap, zram). This
+	  reduces memory overhead and fragmentation by sharing size class
+	  configurations and memory between different users.
+
+	  If unsure, say N.
+
 config ZSMALLOC_STAT
 	bool "Export zsmalloc statistics"
 	select DEBUG_FS
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 8df45aa1b5c8..acd14b001342 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -224,6 +224,10 @@ struct zs_pool {
 	atomic_t compaction_in_progress;
 };
 
+#ifdef CONFIG_ZSMALLOC_SINGLETON_POOL
+static struct zs_pool *zs_singleton_pool;
+#endif
+
 static inline void zpdesc_set_first(struct zpdesc *zpdesc)
 {
 	SetPagePrivate(zpdesc_page(zpdesc));
@@ -2051,17 +2055,7 @@ static int calculate_zspage_chain_size(int class_size)
 	return chain_size;
 }
 
-/**
- * zs_create_pool - Creates an allocation pool to work from.
- * @name: pool name to be created
- *
- * This function must be called before anything when using
- * the zsmalloc allocator.
- *
- * On success, a pointer to the newly created pool is returned,
- * otherwise NULL.
- */
-struct zs_pool *zs_create_pool(const char *name)
+static struct zs_pool *__zs_create_pool(const char *name)
 {
 	int i;
 	struct zs_pool *pool;
@@ -2170,9 +2164,29 @@ struct zs_pool *zs_create_pool(const char *name)
 	zs_destroy_pool(pool);
 	return NULL;
 }
+
+/**
+ * zs_create_pool - Creates an allocation pool to work from.
+ * @name: pool name to be created
+ *
+ * This function must be called before anything when using
+ * the zsmalloc allocator.
+ *
+ * On success, a pointer to the newly created pool is returned,
+ * otherwise NULL.
+ */
+struct zs_pool *zs_create_pool(const char *name)
+{
+#ifdef CONFIG_ZSMALLOC_SINGLETON_POOL
+	return zs_singleton_pool;
+#else
+	return __zs_create_pool(name);
+#endif
+
+}
 EXPORT_SYMBOL_GPL(zs_create_pool);
 
-void zs_destroy_pool(struct zs_pool *pool)
+static void __zs_destroy_pool(struct zs_pool *pool)
 {
 	int i;
 
@@ -2203,8 +2217,35 @@ void zs_destroy_pool(struct zs_pool *pool)
 	kfree(pool->name);
 	kfree(pool);
 }
+
+void zs_destroy_pool(struct zs_pool *pool __maybe_unused)
+{
+#ifndef CONFIG_ZSMALLOC_SINGLETON_POOL
+	__zs_destroy_pool(pool);
+#endif
+}
 EXPORT_SYMBOL_GPL(zs_destroy_pool);
 
+static void zs_destroy_singleton_pool(void)
+{
+#ifdef CONFIG_ZSMALLOC_SINGLETON_POOL
+	if (zs_singleton_pool) {
+		__zs_destroy_pool(zs_singleton_pool);
+		zs_singleton_pool = NULL;
+	}
+#endif
+}
+
+static int zs_create_singleton_pool(void)
+{
+#ifdef CONFIG_ZSMALLOC_SINGLETON_POOL
+	zs_singleton_pool = __zs_create_pool("zsmalloc");
+	if (!zs_singleton_pool)
+		return -ENOMEM;
+#endif
+	return 0;
+}
+
 static void zs_destroy_caches(void)
 {
 	kmem_cache_destroy(handle_cachep);
@@ -2235,9 +2276,16 @@ static int __init zs_init(void)
 	if (rc)
 		return rc;
 
+	rc = zs_create_singleton_pool();
+	if (rc) {
+		zs_destroy_caches();
+		return rc;
+	}
+
 #ifdef CONFIG_COMPACTION
 	rc = set_movable_ops(&zsmalloc_mops, PGTY_zsmalloc);
 	if (rc) {
+		zs_destroy_singleton_pool();
 		zs_destroy_caches();
 		return rc;
 	}
@@ -2252,6 +2300,7 @@ static void __exit zs_exit(void)
 	set_movable_ops(NULL, PGTY_zsmalloc);
 #endif
 	zs_stat_exit();
+	zs_destroy_singleton_pool();
 	zs_destroy_caches();
 }
 
-- 
2.52.0.457.g6b5491de43-goog


