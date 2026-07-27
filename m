Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDAA2C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5286B00B5; Mon, 27 Jul 2026 10:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8AD66B00B6; Mon, 27 Jul 2026 10:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DC366B00B7; Mon, 27 Jul 2026 10:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63E076B00B5
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6BB5A0792
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:36 +0000 (UTC)
X-FDA: 85034812632.23.70024F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6635F10000D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PXeqXkkT;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdtqE3eR/Bua/rulOOI8NT/gdSWbQwN4dD7fIeQTAXA=;
	b=c+3H4Qk6Sop+YNtIfAbWA8IPPfTrQooqP6ppOHLcK/xe+EGwqbmZvE6l9NkfvqfrAY0UZA
	om6YXt4Pyu0ZL7yggmWRwOibxghzxWAVEKiYnOD7KFOjg4uy6Tkmml6CUyuRiWMYPH4P1c
	zd9at12xsW5NNqJhFEThoZpVTY+lbXo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163115;
	b=UF+KOhrus458Nlib4Hx9Ix8UAWi0m4gFRd9W1cHE0XJ461S0zXwCrrD91WlLdSQMtbyvHN
	0jvXiT6GUK5W1dfRbDYqx9NiqZwovqnJdB66D2J96BOB2iVzp2YRoBWotgTBsnZOGN38Kh
	Y+rRfxb5NuCaernRX5FGvWnIm9YZQnY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PXeqXkkT;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0AF5560A68;
	Mon, 27 Jul 2026 14:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9050C1F00A3D;
	Mon, 27 Jul 2026 14:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785163114;
	bh=SdtqE3eR/Bua/rulOOI8NT/gdSWbQwN4dD7fIeQTAXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PXeqXkkThnDbMubQzL2QbuRli5gndk1PPtauBRBlBwa4NEBLeRA/hD23pXTiIu4xy
	 4P22t+uiOpUKYOLsY9b9hSnxJ3chgwAnpcoZKQG+1XVB+wmbXOiVPTgmsBtd5YLFst
	 XMdlizTzpV461DxxQk5ChkHB51lJBac1KFX/nepVeUnT3wWTYB+52pKKOoyGmFwXAN
	 R5LSXWxH1skTgsHUV2GCPjXkwgb1WkgRf8546lL9y+RMhQ3WLGgd2B8te90sPZUO5F
	 pN41zTfsCWF/tl6dGEnZQa8y1McpBGMWrz6E3OcnbwVq45AOkhLQTFMAqDazLVPkKn
	 +yiVcE3Cmo1/A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 06/17] mm/damon/core: commit preps
Date: Mon, 27 Jul 2026 07:38:15 -0700
Message-ID: <20260727143829.86236-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143829.86236-1-sj@kernel.org>
References: <20260727143829.86236-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6635F10000D
X-Stat-Signature: joyxjsqsyu7chennbtj8j65ooaxey9ir
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785163115-242299
X-HE-Meta: U2FsdGVkX1/En9EVUijeaMfQDHpz/4wecdz8J9Kihnyw4oS9RvzVeszP2RixXR42tXAIsD2YNO21vPn8XZV3Rm4E4LwaGq/snnNr2vJEI+n0rMiNZh6SAfi3rIttK8m6uPl2a9cAsCxU8bSvS3sHbSFv3/hovXqsGVXTbwpN6+mVao13iVzPHTHzlfL295u0kk/heoNKbz9fco1OuZuDtg1Jlf5qQFbWg4EkN3/7AiPVRzLaViRflzuytkGEBgYVJ4Vq24tKHrjiKnFjm7oOTPDdy8xGxe4SX7EMJHKwr4yb8cw+TJw9UVErMqGtnkomAtfAxkHxdCslVCOjeEb76bDGrdbw84ZRE9XxF1TUXoiul1EP38l8vE9zBcv52eBK11bztcarR16Hw/tlFHuQ+uGJMPzYB6T/jzo/9HnTf/ypKJS6GhA23uLKhtaqJE6CrT3kOztXCZmW5oaFwv4q/rztA+Cxxyk12GXYr9QXYow69SEsczAiKTotdEY/iHLK96pdZr8IHFjY97zBYMAYpXxKVM7DWZ8YEKfdcwnmSsjxQ5vOslLBUZQYE/9nQOmlISOc3k2xAQ8Xe6OMzUiFy8w+3FCefeVRUnr30Wj20QSgVmOAATd+F9JEI3tJeJpRiEzCm0LNDlPZ1U0rq8PUuHZbJ9CS+4CmuBtqoq31fiPUtrRaetyZTEplTCwSYzNwgGb+gTBbnriaeKM89eMu9gylkZWTfDlVK4dGAvRTVD5Sxb/MFQ7P22ypJ68jnc3CWZXxoFKJMuNl4eJWxj8QN6aGbI+gwQw2rtosq4XTBf2pM8l4PftVYD6I/s9L/1Zd+49pMZxNr9O4ppXAuJwVCG7RpK9Icm3ofa5keGkRiu+Z8/8u6HDVYd39pjHYxI6EAwwzeNCNI9i2/rZrPoSQmN4IOoEktDhkmzRZUH299xCkC+vqYOlEYO9yTs56PIqIk+1x//B7hjFzz+0DEfZ
 GUScqT1N
 U6rIitR3S7aTodXSfb2m6599YcDUidV+ThMjsjRsjmNoG8wZEvAugEUo9b1XHIYjmPgA+6LpSBGvuOoUI8yHMw7tXhkPA5ihiMw0UEC1EeZPlACsgLW7QDJ/WqdqHwh8sN7Mu8U3Li8+dgz8TWndDBPt4PvkNwdUPHtj8LCzjLhyje1BZltC/yYBrKqLfFngPEmW20sI+BEuZSROXKsSR1OOlDkVfPsaIJ05H4+UN5niGIsw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_commit_probes() is ignoring damon_prep.  Commit the prep actions,
too.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index bda61f9ec0266..c74dee56efee8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -128,11 +128,34 @@ void damon_add_prep(struct damon_probe *p, struct damon_prep *prep)
 	list_add_tail(&prep->list, &p->preps);
 }
 
+static void damon_del_prep(struct damon_prep *p)
+{
+	list_del(&p->list);
+}
+
 static void damon_free_prep(struct damon_prep *p)
 {
 	kfree(p);
 }
 
+static void damon_destroy_prep(struct damon_prep *p)
+{
+	damon_del_prep(p);
+	damon_free_prep(p);
+}
+
+static struct damon_prep *damon_nth_prep(int n, struct damon_probe *p)
+{
+	struct damon_prep *prep;
+	int i = 0;
+
+	damon_for_each_prep(prep, p) {
+		if (i++ == n)
+			return prep;
+	}
+	return NULL;
+}
+
 struct damon_filter *damon_new_filter(enum damon_filter_type type,
 		bool matching, bool allow)
 {
@@ -1694,6 +1717,36 @@ static int damon_commit_targets(
 	return err;
 }
 
+static void damon_commit_prep(struct damon_prep *dst, struct damon_prep *src)
+{
+	dst->action = src->action;
+}
+
+static int damon_commit_preps(struct damon_probe *dst, struct damon_probe *src)
+{
+	struct damon_prep *dst_prep, *next, *src_prep, *new_prep;
+	int i = 0, j = 0;
+
+	damon_for_each_prep_safe(dst_prep, next, dst) {
+		src_prep = damon_nth_prep(i++, src);
+		if (src_prep)
+			damon_commit_prep(dst_prep, src_prep);
+		else
+			damon_destroy_prep(dst_prep);
+	}
+
+	damon_for_each_prep_safe(src_prep, next, src) {
+		if (j++ < i)
+			continue;
+
+		new_prep = damon_new_prep(src_prep->action);
+		if (!new_prep)
+			return -ENOMEM;
+		damon_add_prep(dst, new_prep);
+	}
+	return 0;
+}
+
 static void damon_commit_filter(struct damon_filter *dst,
 		struct damon_filter *src)
 {
@@ -1752,6 +1805,9 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 		src_probe = damon_nth_probe(i++, src);
 		if (src_probe) {
 			dst_probe->weight = src_probe->weight;
+			err = damon_commit_preps(dst_probe, src_probe);
+			if (err)
+				return err;
 			err = damon_commit_filters(dst_probe, src_probe);
 			if (err)
 				return err;
@@ -1769,6 +1825,9 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 			return -ENOMEM;
 		damon_add_probe(dst, new_probe);
 		new_probe->weight = src_probe->weight;
+		err = damon_commit_preps(new_probe, src_probe);
+		if (err)
+			return err;
 		err = damon_commit_filters(new_probe, src_probe);
 		if (err)
 			return err;
-- 
2.47.3

