Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDE63EEC285
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 21:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D81D6B0089; Mon, 23 Feb 2026 16:37:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87ACB6B0092; Mon, 23 Feb 2026 16:37:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72EEF6B008C; Mon, 23 Feb 2026 16:37:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5DB336B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:37:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 178C51B5C28
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:37:50 +0000 (UTC)
X-FDA: 84477033900.20.8435549
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2D9EAA000B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:37:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=oXibkeaw;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net;
	spf=pass (imf25.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771882668; a=rsa-sha256;
	cv=none;
	b=3F6bMpA9qZAwt+IsROpZbIwyDEZD7YybD3qd8+Z8PlKbc/NF3rLUHd2GF0B2bzfW233o1u
	5D1rygqjatkVioUs5YSCKuITYmyJtVxtIws3Z03wiuadg6B/VoBjF54m62ZEFPqHDbfYTS
	MPKSp6foLAACHkcEcFsMWTGOpzE2gzQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=oXibkeaw;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net;
	spf=pass (imf25.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771882668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ga3gT5t1zT7cApDJCtbfMkDZL1jlzDzDdU28dSqvl28=;
	b=hAUJsgEs8goSqAXpL3FStV7H7NIKXxLpBJRPbPBtNvmneteQPa0c8ASgJWIXUzYIjmNzod
	+G2dpv2jvL1t9f/kyaDM01uj7QMC8Fbo76750Cghn2MQntLUpbO0kVBFm1ylNJn4vXAT4x
	DNP/DU/+Wo1yT998rVBiPkp3sKL2AmY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1771882665;
	bh=jCJGZ6yUGTwLfNQ0j3wLPG2oxfk3xdLAhlgEKrJztzo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=oXibkeawTtBhdCgkokKZVvCDClIoBZw74G+NRsqO3JeF2CvkX7TfLu/XPPikJkq5U
	 O7BGyjFjyYlamI+I9UAT10MxcWExb2o40skLZ0D7OlSKLtyB/MqVmPM2zpae9yCUVh
	 M7KB9Wz2+JVb5JDJjaua8Z3Nk6Bj5fyOiqqMfdV8=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Mon, 23 Feb 2026 22:37:44 +0100
Subject: [PATCH 2/2] mm/slab: constify sysfs attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260223-sysfs-const-slub-v1-2-ff86ffc26fff@weissschuh.net>
References: <20260223-sysfs-const-slub-v1-0-ff86ffc26fff@weissschuh.net>
In-Reply-To: <20260223-sysfs-const-slub-v1-0-ff86ffc26fff@weissschuh.net>
To: Vlastimil Babka <vbabka@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771882664; l=2029;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=jCJGZ6yUGTwLfNQ0j3wLPG2oxfk3xdLAhlgEKrJztzo=;
 b=u66knv3q+Wk6YoFvrfVTHgsEMtuKPgGFNrimyxL8rKC6zLqhYkhgiqCP5J7DFYujF86ynB+sN
 ez+/dKQObdECJ94JBYGfrubVSOrUWYXy1NBZccpdpsCCo5daeFAhHDB
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Stat-Signature: i65bfmt7d9sb4br4agc3jyxs8wjyd755
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2D9EAA000B
X-HE-Tag: 1771882667-824098
X-HE-Meta: U2FsdGVkX18QuXfmjVyBixcfhuZfchPMp9BBt0RD0EyxHR2tU34YKiSejS7bfcEwHoY3PtyDI7SDGmOKLc28dv0M8rYMRbOoNUQJWcyr36gnnPV3P6Sil4EPgBjmyO7k8VfEyGEnZgfNpRPkxIIpZT2MLJ+EaL6eNnQLCIvsXzjLOm7t7Ah8RdsmvMw89APBCHYOFBmdl39pFK/xqXh51hiXBuI2xyUD7Sm72DNzAaqesGoKwunzivp780ueP9kgRZDPufeYTpGSNP52O47vTptKgRD0yW2/xGv/BVWVLo63tYSdE6z9bdRG+4CMgnDNjj6j6AmCgBUf0/BweeLsFoMbgRUCqucrSgPfNkk7OVKags5DwzSCJX6OflhtBT3wT7eVeeVed3mUu15tYXtd74p1Bhmveb1pSRoZVTLDzgwQS1a1wn1ltBZl9cdaw9qY/wKXV61wWjLYDDt2HwiUZMYRKKHPDQkuLnPSwfUVvX70QbVP9vkTln5GsJE84NbYBSbdCWehozh4LMu4dJ/fvlQkY3J2P3mRwODJ24rV2m8YLPNv5TkjiOH8hLKeyr6HiXG1fUECV4rpJLB/gGeMaphuXdmKz0RNYDgCFpP4TlhtHikr+ZVnaZQNLuK3WVMiULECAQT+llRG5j5Pzy7fx0Vx4dV8QiE29ZCeMEafOmiCrW0f9ucl8Y0dDix40uO59MvAloeloBDzD/dPbhzH6DoKwyFDMl98aQzS04ONWFHSTM6y7yOT3d0Q9686yNS3qTJ96Lrh1b4VzqwfPLR5oxZGdIS9CYDk1vuq0Lkenyua36K1J+/sfsElcWg6hdSZfdz+L0XQLbuiRXKSGCRNOQxoqFN9jM6uotn/Y/lUlvfT3jXWzVlnPWpGVVkDgWrOFTn6f151OnTxfyiovqKyW6/1oAnydUIH72dgHJxCkN8jrA/GAf7hXcHOTb4fufssfbetk8lvOujIAkqJbcM
 UAJ9SaTG
 i8XagWN/x0SKjiErgNG9nezy+MjRZSkdgc4ojZ48718aKES8y0ElUMT9wDKDA++wR+xQCiEf/r5ULsqrD8evi8LvIzYCkplpc6bW0m33M1X0yZ6tGF3xisccpJvduQPgDvAc2VEBMBlpJroLZ4u2M1BliFbVOu+s3QKhKoIqXz7kGWtx8u4iRFYDKxpDaToJbbmWqZma8Vme2E/o0HjkzwHhHsF0BeLElbiODyD10MwMOIWBSpFsjwhnxHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These attributes are never modified, make them read-only.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 mm/slub.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a48ea23b1728..73051cf77353 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8833,7 +8833,7 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 	return len;
 }
 
-#define to_slab_attr(n) container_of(n, struct slab_attribute, attr)
+#define to_slab_attr(n) container_of_const(n, struct slab_attribute, attr)
 #define to_slab(n) container_of(n, struct kmem_cache, kobj)
 
 struct slab_attribute {
@@ -8843,10 +8843,10 @@ struct slab_attribute {
 };
 
 #define SLAB_ATTR_RO(_name) \
-	static struct slab_attribute _name##_attr = __ATTR_RO_MODE(_name, 0400)
+	static const struct slab_attribute _name##_attr = __ATTR_RO_MODE(_name, 0400)
 
 #define SLAB_ATTR(_name) \
-	static struct slab_attribute _name##_attr = __ATTR_RW_MODE(_name, 0600)
+	static const struct slab_attribute _name##_attr = __ATTR_RW_MODE(_name, 0600)
 
 static ssize_t slab_size_show(struct kmem_cache *s, char *buf)
 {
@@ -9240,7 +9240,7 @@ static ssize_t skip_kfence_store(struct kmem_cache *s,
 SLAB_ATTR(skip_kfence);
 #endif
 
-static struct attribute *slab_attrs[] = {
+static const struct attribute *const slab_attrs[] = {
 	&slab_size_attr.attr,
 	&object_size_attr.attr,
 	&objs_per_slab_attr.attr,
@@ -9323,7 +9323,7 @@ static ssize_t slab_attr_show(struct kobject *kobj,
 				struct attribute *attr,
 				char *buf)
 {
-	struct slab_attribute *attribute;
+	const struct slab_attribute *attribute;
 	struct kmem_cache *s;
 
 	attribute = to_slab_attr(attr);
@@ -9339,7 +9339,7 @@ static ssize_t slab_attr_store(struct kobject *kobj,
 				struct attribute *attr,
 				const char *buf, size_t len)
 {
-	struct slab_attribute *attribute;
+	const struct slab_attribute *attribute;
 	struct kmem_cache *s;
 
 	attribute = to_slab_attr(attr);

-- 
2.53.0


