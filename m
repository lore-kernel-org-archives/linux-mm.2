Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D99D0C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 10:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A85076B0099; Wed,  5 Aug 2026 06:25:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A36A66B009F; Wed,  5 Aug 2026 06:25:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925486B00A0; Wed,  5 Aug 2026 06:25:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 631E46B0099
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:25:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E787A803FB
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:25:31 +0000 (UTC)
X-FDA: 85066834062.25.152A6FF
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0AB3C140004
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:25:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=lKR+sDTn;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785925530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g9y18o+SeXXE89bm99BSkZE54Wz40yQEuA61nq1G8kI=;
	b=Bh5yr9Wm2hRPZ5JlLsRmR6aWfwMD7zLqM3DIokS+20IiB9Npr7VH6RPRUXhdUyV3xJ2ld/
	p24dwoGMiM+oRzcG8JmID52A3Ge7+phB0PM/P5OlULc+T1M8W4kSbcGjyC8+0b4qY2kdVn
	QJIVuT9F43/z14reLQ6Osa9b1DxN6Ts=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=lKR+sDTn;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785925530;
	b=mJL59kGEahbMrNW/OnOD823Jl9/ovpM9ekMKAvepf681oJqasGz9lloS1B9YADIuh4bFr3
	+ZALSOCVcb4V0njDMVo5RSRJ1a635V16X3nq5q4yzQmXr0Dc91kjFiBoUjtIYfqtHNsVaa
	pbYs29Sz+CB81STlNi2io6Up+2pxSKc=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c998fd549a8so606780a12.2
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 03:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785925529; x=1786530329; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g9y18o+SeXXE89bm99BSkZE54Wz40yQEuA61nq1G8kI=;
        b=lKR+sDTnRL/KgpddkUAASbIZxwf72Gkn7GViRVx94kTFac6T8CtKlyu5Of8/oiO9Ud
         B8YmgrQiSU6uYS4nn9zSqbPqOOsWsoo1LMG0BD+IbWqDJl701fJh9J1ndAPphVi/3/kO
         Y5hH6SwhbtFH45sX9D0hrKEez1Y4FpP+bX/yU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785925529; x=1786530329;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g9y18o+SeXXE89bm99BSkZE54Wz40yQEuA61nq1G8kI=;
        b=SOY/N6SIesjdZyEik8QFrNdBAZec0MHtn9zmxtsfb0QG14gUkNf3FYgtPcQO8qJIYU
         2o0zzK8iIo93Q3KtYs6O6j05Af0cUEs+94wkj4WNmKTxJswJjBgxg5AoxuPHLxBhn9WC
         GM63sDj8PhdXyq7yN3KpPijc/ir8+PtoYee9E+1lhHfJS55VZxjPbPplNKoWWZ0UyrGh
         HvVLVhFXyVrWjaAIH7Z2jyRTsaTOMfi7Jkm+780axW/2MFe+yXL1SecAt387mfZ2lj76
         KXJaQFQW+rn1JlbmR9ICrU5c5A1KL/7bJAmGb74IwcuFe35lHGgCqWVCWqBRxOTbjrIh
         03SQ==
X-Forwarded-Encrypted: i=1; AHgh+RrSxtE0GCXMgSUmXcJ23IfiJAqzN3TJYFB1rV4Uzp+SjhuCAmRceIKE8jzWN01mJXjTtwJeehFpHA==@kvack.org
X-Gm-Message-State: AOJu0Yxp/jOZMHKBDeRFDxk91gRhEjgSKuwufSGn5U7Gr1I0udNUJ6MP
	85KP/ileXzrExJSyBQAFPsxOwLvp/fz19Ecnv3rltzS32HFzILuyHxt/7pOt9TR2Ow==
X-Gm-Gg: AR+sD12tZeJiLZA1RWANlgo9XYqX7jzkXAEm5CX3PCA7c8O5owaw+bgGWS6XcUjqL9K
	g8WXFZgmVucwbdm2CIxZAivoz6/vJXV0E1QRj3Q8rsdObzA6hRj13crJYdfWwM1p5vcKleZ8SBA
	c6kvIFnfqvY/PZf6wJQifQU1fftU94cZdQdrb0fVpK5VJoI8aC+qz1PihCeXqDS0ebAnlbuRpfr
	bs9Ez1zNkl9RO6R70ZsV8rjdM2HxJ+crbhksdq4cYzryyUkHtce5cZYHBaUteNd2mx4MBKNGNWc
	gwsfhezLYstO+zdyWnG0xn4ql+lwTEcvvWwe0q2GnW381z/AR+UwzP5V3kwV77TuXlFjjn8AzgR
	HNvu+iRmgcavH5Tx3Ga2VANQc30Slm4I4o7lifONvhMPd2Rvxw54gpseNacEXOeAsBieYp8Z4gm
	LrAegoZLtFhbjsN3cwnLvOykMVuQedfnjtEmJYFbjSM9Pzwm/0E20ln+Fvg9piu6duJ5vUrKD/K
	E+60REVtoKJvnbZo6uVOGpXmtah
X-Received: by 2002:a05:6a21:2293:b0:3c3:994f:b4f5 with SMTP id adf61e73a8af0-3cb85eefa11mr7619522637.28.1785925528727;
        Wed, 05 Aug 2026 03:25:28 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:8002:2a47:a704:5a58])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe708041basm1245872a12.14.2026.08.05.03.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 03:25:27 -0700 (PDT)
Date: Wed, 5 Aug 2026 19:25:23 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Barry Song <baohua@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	akpm@linux-foundation.org, bigeasy@linutronix.de, hdanton@sina.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org, ryncsn@gmail.com, 
	yosry.ahmed@linux.dev, surenb@google.com, Dongdong Zhang <zhangdongdong5@xiaomi.com>, 
	Suleiman Souhlal <suleiman@google.com>
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression
 backends
Message-ID: <anMPLgbrf7XMC7Qw@google.com>
References: <20260805005545.66112-1-baohua@kernel.org>
 <anKQ_qZ1-Q6FchZ9@google.com>
 <CAGsJ_4wD+KNL0yMkuS4GijbHaiyPxgTmqKzkr0DErC0XH30w4A@mail.gmail.com>
 <anKaU6VStrW8zaQo@google.com>
 <CAGsJ_4wQ=mDXuxxTdAZkicN5pJK3SsNTOxHt5oNYrq7CgCVObw@mail.gmail.com>
 <anLGxk3iShEfCB30@google.com>
 <CAGsJ_4xU5VN3abCPzACZoS92MqaUrMHn9EQ1FCJD+wy=upbbMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4xU5VN3abCPzACZoS92MqaUrMHn9EQ1FCJD+wy=upbbMA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: tdhyrdozgukekhbz34egkia9rrmtt811
X-Rspamd-Queue-Id: 0AB3C140004
X-HE-Tag: 1785925529-804858
X-HE-Meta: U2FsdGVkX1+lj6PQbw8gmFYB6FPLgTrvyhLC6Uc4eGbVa5al8i0IP7afItAsOUOWg314AmSvCOXqQpvaty1eVyUT8mVFCzRLLl8WLs1A8LpLoMVTP5ISx1H0Xnicd51ku+dXqhxt2Tup5Eb7Cf1MnEnA4qYvR0clnXpUlv+IVrL9GWZpZ5vmawmM1IqTMxRDlFZFPNm8q81mx+HUZLaTHuq37X02hy80rlUFypemE/1P9bmco+/ncdErRXIaLQLOeTmCdS5zLaovssn0loG1V+4ssolrQXwSTpV3FCOBmqoCY5rIDqMIIQPsxiuD+Nu9Zo76OsU3bLGOCIZ0BoXNCfFW/pyfWfyUSLBU9vw+oD9MXpKa31nc1QaKjdEAWIbbebm0UmfJoRy2lksaMOMQHSlTtMjP3rQMOdN+MDpyJ4VtfK6m679wqDBQU1hAnvhyDXXsnbk5pTmXmVFSn5KAITVt9lqtyK/uRycqbrCKiV5sVrGQRhGGyIUqRksmwJoX5pH8xrL3sVmy7gAUF5sDnL0i6X7c+6E5wmwmSPLWaXjcnTPX0oFlV+zyMn/vm8p99bkYcWUd3RgykIi3R2Z84ybdepJXB12XfGWAL46POxXsvn25dohlXaDklkiJWG1ByLCM9cdyRHEjKqcMh0cAOlsMMVFdzfkcTo6abO68vrBMGQEyH/ikWqUf36bPMBbBNc2g9u5aYKd2ZCR9+AKaiIvs+rLrEZLAurltTqTXq4M7s4Kn02PUszVoB7Zf6CcHDrkr5XarzDfkjU00eZZrbXC8VA6/vUYxoLcs1s42nhgEniuBeCHGt9Sa8WqvOVNsW1y9LyqiyUICbv8jgrtBFPqNmNM01tkVzLnWttTCt4l4DN3BOfoabPbYod4UAq3o8hZqZ2+JnlZ7vzWkWrGbX6YMV25xNeWbysmCiPWUafMySbO8HycMUbfSaTll3Gp0uaBl5LUybLAmSYjDZWa
 tfJVp7rE
 Jc1aDgfeBryTQwWbc0C58Fe5creKYLonUSEAQDBlLpykK1GGI3tQU9fFgOu6vyojmlWzCX9OwH90icWmaofOWvP3qcLBInnD64zdFKL2/jEm9G0vsRvlubSjnQN+lK43q4oWzhd8lDsX4ngpdaJorKNrsEd6OD1nKyICEuzWZzjnnBfgSUWhL6KPIOzR19aQqYklKrk1r+3v9EoTEincFawR72PwchJYLNbPhX484Z6AU8dKY6ODfGn8S5FuoeDMFz+03uJXRcVYZ1p+I/8NW224WUnvHzfVJlNQE0z0vkSjLm327NP6ruG/58ln+KQdqVK8YgnY1/UyMfQTvKlG1G10g/K+JdpG8wySInknYgjvKAxy4TsPZkO3mog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

On (26/08/05 15:50), Barry Song wrote:
> BTW, I wonder if compression and decompression could use separate
> mutexes. That way, a sleepable zs_malloc() in the compression path
> would not block decompression, which is the more latency-sensitive
> operation.

quick and dirty patch.  Just curious if this improves anything on your
side.

We also maybe can have more that num_online_cpus() stream, if we
switch to idle streams list instead [1]

[1] https://lore.kernel.org/lkml/20250130111105.2861324-3-senozhatsky@chromium.org/

----

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 974c4691887e..3c523ea0dc27 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -112,21 +112,28 @@ ssize_t zcomp_available_show(const char *comp, char *buf, ssize_t at)
 	return at;
 }
 
-struct zcomp_strm *zcomp_stream_get(struct zcomp *comp)
+struct zcomp_strm *zcomp_stream_get_write(struct zcomp *comp)
 {
 	for (;;) {
-		struct zcomp_strm *zstrm = raw_cpu_ptr(comp->stream);
-
-		/*
-		 * Inspired by zswap
-		 *
-		 * stream is returned with ->mutex locked which prevents
-		 * cpu_dead() from releasing this stream under us, however
-		 * there is still a race window between raw_cpu_ptr() and
-		 * mutex_lock(), during which we could have been migrated
-		 * from a CPU that has already destroyed its stream.  If
-		 * so then unlock and re-try on the current CPU.
-		 */
+		struct zcomp_strm *zstrm = raw_cpu_ptr(comp->stream_write);
+
+		mutex_lock(&zstrm->lock);
+		if (likely(zstrm->buffer))
+			return zstrm;
+		mutex_unlock(&zstrm->lock);
+	}
+}
+
+void zcomp_stream_put_write(struct zcomp_strm *zstrm)
+{
+	mutex_unlock(&zstrm->lock);
+}
+
+struct zcomp_strm *zcomp_stream_get_read(struct zcomp *comp)
+{
+	for (;;) {
+		struct zcomp_strm *zstrm = raw_cpu_ptr(comp->stream_read);
+
 		mutex_lock(&zstrm->lock);
 		if (likely(zstrm->buffer))
 			return zstrm;
@@ -134,7 +141,7 @@ struct zcomp_strm *zcomp_stream_get(struct zcomp *comp)
 	}
 }
 
-void zcomp_stream_put(struct zcomp_strm *zstrm)
+void zcomp_stream_put_read(struct zcomp_strm *zstrm)
 {
 	mutex_unlock(&zstrm->lock);
 }
@@ -174,23 +181,39 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
 int zcomp_cpu_up_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zcomp *comp = hlist_entry(node, struct zcomp, node);
-	struct zcomp_strm *zstrm = per_cpu_ptr(comp->stream, cpu);
+	struct zcomp_strm *zstrm_w = per_cpu_ptr(comp->stream_write, cpu);
+	struct zcomp_strm *zstrm_r = per_cpu_ptr(comp->stream_read, cpu);
 	int ret;
 
-	ret = zcomp_strm_init(comp, zstrm);
-	if (ret)
-		pr_err("Can't allocate a compression stream\n");
-	return ret;
+	ret = zcomp_strm_init(comp, zstrm_w);
+	if (ret) {
+		pr_err("Can't allocate a compression write stream\n");
+		return ret;
+	}
+
+	ret = zcomp_strm_init(comp, zstrm_r);
+	if (ret) {
+		pr_err("Can't allocate a compression read stream\n");
+		zcomp_strm_free(comp, zstrm_w);
+		return ret;
+	}
+
+	return 0;
 }
 
 int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node)
 {
 	struct zcomp *comp = hlist_entry(node, struct zcomp, node);
-	struct zcomp_strm *zstrm = per_cpu_ptr(comp->stream, cpu);
+	struct zcomp_strm *zstrm_w = per_cpu_ptr(comp->stream_write, cpu);
+	struct zcomp_strm *zstrm_r = per_cpu_ptr(comp->stream_read, cpu);
 
-	mutex_lock(&zstrm->lock);
-	zcomp_strm_free(comp, zstrm);
-	mutex_unlock(&zstrm->lock);
+	mutex_lock(&zstrm_w->lock);
+	zcomp_strm_free(comp, zstrm_w);
+	mutex_unlock(&zstrm_w->lock);
+
+	mutex_lock(&zstrm_r->lock);
+	zcomp_strm_free(comp, zstrm_r);
+	mutex_unlock(&zstrm_r->lock);
 	return 0;
 }
 
@@ -198,17 +221,25 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 {
 	int ret, cpu;
 
-	comp->stream = alloc_percpu(struct zcomp_strm);
-	if (!comp->stream)
+	comp->stream_write = alloc_percpu(struct zcomp_strm);
+	if (!comp->stream_write)
 		return -ENOMEM;
 
+	comp->stream_read = alloc_percpu(struct zcomp_strm);
+	if (!comp->stream_read) {
+		free_percpu(comp->stream_write);
+		return -ENOMEM;
+	}
+
 	comp->params = params;
 	ret = comp->ops->setup_params(comp->params);
 	if (ret)
 		goto cleanup;
 
-	for_each_possible_cpu(cpu)
-		mutex_init(&per_cpu_ptr(comp->stream, cpu)->lock);
+	for_each_possible_cpu(cpu) {
+		mutex_init(&per_cpu_ptr(comp->stream_write, cpu)->lock);
+		mutex_init(&per_cpu_ptr(comp->stream_read, cpu)->lock);
+	}
 
 	ret = cpuhp_state_add_instance(CPUHP_ZCOMP_PREPARE, &comp->node);
 	if (ret < 0)
@@ -218,7 +249,8 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 
 cleanup:
 	comp->ops->release_params(comp->params);
-	free_percpu(comp->stream);
+	free_percpu(comp->stream_read);
+	free_percpu(comp->stream_write);
 	return ret;
 }
 
@@ -226,7 +258,8 @@ void zcomp_destroy(struct zcomp *comp)
 {
 	cpuhp_state_remove_instance(CPUHP_ZCOMP_PREPARE, &comp->node);
 	comp->ops->release_params(comp->params);
-	free_percpu(comp->stream);
+	free_percpu(comp->stream_read);
+	free_percpu(comp->stream_write);
 	kfree(comp);
 }
 
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 81a0f3f6ff48..fd919571d8b7 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -71,7 +71,8 @@ struct zcomp_ops {
 
 /* dynamic per-device compression frontend */
 struct zcomp {
-	struct zcomp_strm __percpu *stream;
+	struct zcomp_strm __percpu *stream_write;
+	struct zcomp_strm __percpu *stream_read;
 	const struct zcomp_ops *ops;
 	struct zcomp_params *params;
 	struct hlist_node node;
@@ -85,8 +86,11 @@ const char *zcomp_lookup_backend_name(const char *comp);
 struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params);
 void zcomp_destroy(struct zcomp *comp);
 
-struct zcomp_strm *zcomp_stream_get(struct zcomp *comp);
-void zcomp_stream_put(struct zcomp_strm *zstrm);
+struct zcomp_strm *zcomp_stream_get_write(struct zcomp *comp);
+void zcomp_stream_put_write(struct zcomp_strm *zstrm);
+
+struct zcomp_strm *zcomp_stream_get_read(struct zcomp *comp);
+void zcomp_stream_put_read(struct zcomp_strm *zstrm);
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 		   const void *src, unsigned int *dst_len);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 3b9dfcae9317..6a564a5e0041 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1358,14 +1358,14 @@ static int decompress_bdev_page(struct zram *zram, struct page *page, u32 index)
 	size = get_slot_size(zram, index);
 	prio = get_slot_comp_priority(zram, index);
 
-	zstrm = zcomp_stream_get(zram->comps[prio]);
+	zstrm = zcomp_stream_get_read(zram->comps[prio]);
 	src = kmap_local_page(page);
 	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size,
 			       zstrm->local_copy);
 	if (!ret)
 		copy_page(src, zstrm->local_copy);
 	kunmap_local(src);
-	zcomp_stream_put(zstrm);
+	zcomp_stream_put_read(zstrm);
 	slot_unlock(zram, index);
 
 	return ret;
@@ -2101,14 +2101,14 @@ static int read_compressed_page(struct zram *zram, struct page *page, u32 index)
 	size = get_slot_size(zram, index);
 	prio = get_slot_comp_priority(zram, index);
 
-	zstrm = zcomp_stream_get(zram->comps[prio]);
+	zstrm = zcomp_stream_get_read(zram->comps[prio]);
 	src = zs_obj_read_begin(zram->mem_pool, handle, size,
 				zstrm->local_copy);
 	dst = kmap_local_page(page);
 	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size, dst);
 	kunmap_local(dst);
 	zs_obj_read_end(zram->mem_pool, handle, size, src);
-	zcomp_stream_put(zstrm);
+	zcomp_stream_put_read(zstrm);
 
 	return ret;
 }
@@ -2129,12 +2129,12 @@ static int read_from_zspool_raw(struct zram *zram, struct page *page, u32 index)
 	 * case if object spans two physical pages. No decompression
 	 * takes place here, as we read raw compressed data.
 	 */
-	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
+	zstrm = zcomp_stream_get_read(zram->comps[ZRAM_PRIMARY_COMP]);
 	src = zs_obj_read_begin(zram->mem_pool, handle, size,
 				zstrm->local_copy);
 	memcpy_to_page(page, 0, src, size);
 	zs_obj_read_end(zram->mem_pool, handle, size, src);
-	zcomp_stream_put(zstrm);
+	zcomp_stream_put_read(zstrm);
 
 	memzero_page(page, size, PAGE_SIZE - size);
 
@@ -2285,20 +2285,20 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 	if (same_filled)
 		return write_same_filled_page(zram, element, index);
 
-	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
+	zstrm = zcomp_stream_get_write(zram->comps[ZRAM_PRIMARY_COMP]);
 	mem = kmap_local_page(page);
 	ret = zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
 			     mem, &comp_len);
 	kunmap_local(mem);
 
 	if (unlikely(ret)) {
-		zcomp_stream_put(zstrm);
+		zcomp_stream_put_write(zstrm);
 		pr_err("Compression failed! err=%d\n", ret);
 		return ret;
 	}
 
 	if (comp_len >= huge_class_size) {
-		zcomp_stream_put(zstrm);
+		zcomp_stream_put_write(zstrm);
 		return write_incompressible_page(zram, page, index);
 	}
 
@@ -2306,18 +2306,18 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 			   GFP_NOIO | __GFP_NOWARN |
 			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
 	if (IS_ERR_VALUE(handle)) {
-		zcomp_stream_put(zstrm);
+		zcomp_stream_put_write(zstrm);
 		return PTR_ERR((void *)handle);
 	}
 
 	if (!zram_can_store_page(zram)) {
-		zcomp_stream_put(zstrm);
+		zcomp_stream_put_write(zstrm);
 		zs_free(zram->mem_pool, handle);
 		return -ENOMEM;
 	}
 
 	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
-	zcomp_stream_put(zstrm);
+	zcomp_stream_put_write(zstrm);
 
 	slot_lock(zram, index);
 	slot_free(zram, index);
@@ -2457,7 +2457,7 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 	 */
 	clear_slot_flag(zram, index, ZRAM_IDLE);
 
-	zstrm = zcomp_stream_get(zram->comps[prio]);
+	zstrm = zcomp_stream_get_write(zram->comps[prio]);
 	src = kmap_local_page(page);
 	ret = zcomp_compress(zram->comps[prio], zstrm, src, &comp_len_new);
 	kunmap_local(src);
@@ -2472,7 +2472,7 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 		*num_recomp_pages -= 1;
 
 	if (ret) {
-		zcomp_stream_put(zstrm);
+		zcomp_stream_put_write(zstrm);
 		return ret;
 	}
 
@@ -2481,7 +2481,7 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 
 	if (class_index_new >= class_index_old ||
 	    (threshold && comp_len_new >= threshold)) {
-		zcomp_stream_put(zstrm);
+		zcomp_stream_put_write(zstrm);
 
 		/*
 		 * Secondary algorithms failed to re-compress the page
@@ -2510,12 +2510,12 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 			       __GFP_HIGHMEM | __GFP_MOVABLE,
 			       page_to_nid(page));
 	if (IS_ERR_VALUE(handle_new)) {
-		zcomp_stream_put(zstrm);
+		zcomp_stream_put_write(zstrm);
 		return PTR_ERR((void *)handle_new);
 	}
 
 	zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer, comp_len_new);
-	zcomp_stream_put(zstrm);
+	zcomp_stream_put_write(zstrm);
 
 	slot_free(zram, index);
 	set_slot_handle(zram, index, handle_new);

