Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81D88C5AC80
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 09:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E56456B0095; Fri,  7 Aug 2026 05:35:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2D966B0098; Fri,  7 Aug 2026 05:35:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D466B009D; Fri,  7 Aug 2026 05:35:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0DF26B0095
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:35:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 042F6160258
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:35:42 +0000 (UTC)
X-FDA: 85073966166.22.A1305FA
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3C0C6C0007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:35:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R2Km9XkQ;
	spf=pass (imf22.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786095341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wpE9LlR4n7E+nsWeZA4Ufk20Oj2MKir8BCmBsXj1cZ0=;
	b=hoD69HWZIj6XNs6/RKrn/C9xCUIUUHMmQTYd/VcQtRLt5WkkXMMupHm7+itT6nWYf7OANs
	XVvkjnjAPxkXT/BuSxPaagGXsuuYzQUl0wX1OZHUuxjysdbi84b2u3B9qq8MsxQxnRWVwr
	kWdcZDDYuawQMPHAxIVYJnQQz88CjiI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786095341;
	b=UxH/XlQDdhR+BAJNl737Ou/jpeJ4SQQmcxIJVgDFetS62kB26FPxfnUnMILHeg+w6v8mO0
	Haa19weArY09FdCCe1TIpf8y/beiUGPm0qlUcZek8hTxg78g6D2TG4NRGbGB+fWIpj5+KJ
	bY/IPXadNMp1bsnrPm7tYhpTiRmFTzE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R2Km9XkQ;
	spf=pass (imf22.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38e07ebd263so2151976a91.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 02:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786095340; x=1786700140; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wpE9LlR4n7E+nsWeZA4Ufk20Oj2MKir8BCmBsXj1cZ0=;
        b=R2Km9XkQtcj90qGksN3vD5znPRb+6U8lUqHMYZSfwGB6aCgmCRdRJ2WxHOZiH6VrZA
         yH2+aLueOf4pw/30qUhZCqBhF62KH2cmdNwDOgHkcmMnk3gxVkpyRTdkkrEX3Noq+dyj
         FmI94QFfBTeMIsw7yB5QChs5PowJ5skX1lB+gVSebKTct3FBocrmMSisp6Ug2SVAUCCI
         VlbV54YvdWs6qhCRP+HCKVSWNXicjpbHrsGh8wlQHpRbwvQI4HjMwLOFfIY2hpolo08Z
         kMZjqxeIgPQVZ4uA7HrfCtDH2BNV5XyWK7voDG+2Nku/Cp8qRlH20NP5GUS5DWth2jcn
         nd4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786095340; x=1786700140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wpE9LlR4n7E+nsWeZA4Ufk20Oj2MKir8BCmBsXj1cZ0=;
        b=WYY9WENm0wWTWlRQYegux3tpmq91z4ome891y+O3OoqrtFuHE3jIY7JQhR9LO+6SQE
         j/3ePcvz0i9PstsOiFV9HswHKbsg37+SZ/Ez9YIoSF9eFe4kk+IrjP7AZXQwR5Blrn0i
         Ghi9XY20GQ1D3m257k/xL2wBhK/uAcsHdZFP21AToNotF7v5nIFk4JWERK4lFKsgZiVy
         l0Dd/z+vmoupIBEWDTXjFtpCzJ+NA9fwfLE/TzXRhnWVOE4qCweHhdPm+TxAAoiJAroK
         4mTGqadv1lifBHag/zALuc80L0vCb+KJXdBMhfw7UwwT4h37I2lVoqNGzYRiWwMZ8IvE
         1y9w==
X-Forwarded-Encrypted: i=1; AHgh+RqMG5cRdXkIclWzYfK7AGbsU49yTvWa3A8PoOugxJ3Ker1iRnVl/S5DgWJwObtFDEu1tsq4zhH6bQ==@kvack.org
X-Gm-Message-State: AOJu0YzL75vUxaCTK98hbIzgjETTsBFFrkhLSkRgwBkCNBBio1Jpn7Bv
	HoJKVP1ZpbXNTpTf6HNrDHGUYUY+wi5xJOJPcN1mPaAVXgkuQT+enb9c
X-Gm-Gg: AR+sD12QP3jHAG41KrvC0csKYm1jgCd8tTTHPdmQ8Yd+J35fM3j3TAR0Kjq/0k+FE6W
	iQWFjmQaV1qGL37o+kKgHe9efeGiwLdF4M2WPrF8Wm1NuwC9Rg6B4+NIwYy8mrvShLifg8UKDYT
	1dYzRhlXWO6KscEtKZnMOA/agb/Wm6fYknds9l2J73wB2NvXUUprEJMYLQYOmyPlkVDfWsPKuHY
	Ec5XGZTS0MbJV0HYUxgofY4cnMx4FK7XeB2v2M0UMYjUcSvTkXIvbVBt8yxNvwHgmYK5hODMQd5
	8bd08eSepZrlFrj5xdJOFEtwBJxSqS71XBohWURiVrJlPp7tPHRxEMYgTuC9n3XFTS8IlOxYCUp
	+WIiQ7eomC4ezp9zedO5jSACm5lyPS3VdEjyTJGipz1L8he7rwxutdAU9YFEb7CCIkZnHLI5dLV
	Ly5qW5HzijXS0i6dBo0na56tkXBnreS8qetIC7x5gAYbBzVTwS2fUrcAAH4IFbvicDBaaVintgF
	H4=
X-Received: by 2002:a17:90b:4c50:b0:381:5a08:6291 with SMTP id 98e67ed59e1d1-3909d917dddmr6862093a91.20.1786095340044;
        Fri, 07 Aug 2026 02:35:40 -0700 (PDT)
Received: from celestia ([2402:1980:935:f4a7:6f5c:e816:9aba:2090])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3926254ee45sm1604269a91.2.2026.08.07.02.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 02:35:39 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH 2/2] mm/damon: skip deactivated schemes in watermark checks and add fallback sleep
Date: Fri,  7 Aug 2026 17:35:26 +0800
Message-ID: <20260807093526.183009-3-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807093526.183009-1-aethernet65535@gmail.com>
References: <20260807093526.183009-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3C0C6C0007
X-Stat-Signature: crsj6z4y94cgezrk9ywajyu8hyitqpyw
X-Rspam-User: 
X-HE-Tag: 1786095341-101090
X-HE-Meta: U2FsdGVkX1+Xo1w+Cg10SY/7AkHw/8s+y7GuAMFBa2UWNFlIkDTj5ubiOYJd8qBcfuCN3+fgtssk8beP73eY9ffHpbrpwaK+a6JdLgXMzRwoY++6K/gl4XnH5sJFaJpyOiMjvB+vFAVD+A8ZGCOeU3LzWslo30vubmJL8muDKo0m6ApjS87IKUPjz+9MUoCPvhemqJzKgXHwfZIDHXjmjjzn5qQcfnlR6hTTWzDfHYN22mLBdEnXIc2+ZzVr+I1/ew8ql2pjIYTgslCivyQQtrYCGciAATDiAWDpHoEA4WBhlnFFknxejEkn6PJQlWTJbce9qGAr22rx/EdJUrtcXzShu3i9TAlvaLPJhNxEGS8xZrOKlfT+4eK2jX7oJftp7fzAZ0ID69d/xCwbhYHu4dfslD5C2WveJSdXA4rXG2VRu9bduZmNaczA/S+KXR/68P4FKJ2WIjRpowq2eKPBESgHNHR52M3bmeOS4vlMDdbkQsDPYj0w1SM++vwAJ2K/wt4pW3LPJZgx40oX+UGtKcNNpQBvPx206o5gTpLiIaGOK/IBHHCkWuUjrzfhzW0QICLUenQI++KG1VR/1Pcu6ooWlOORS+pYpJS/YJzL4okCyXZIchdLHWo/abWSKf7881MBl80anFy07jTKOX8Rjqj+pdFkNozjTCXHUFK3UFfxED2WmoPTM1ytxlUrmhCpkpQQ2wB5u6EQtsdf8wBvmFQGdlO3I7V+Qm3PoaGDvV5drDjsypGbv1E6zB7QKUJv6+JO0ue4fo8n+0F30AqvFHn+FuzSMOV8c4WmKTk/zDJHtLWbaOue1xfBBkqb5oGCcrFjLzu7kiQN25oJ07xz77QobI2Kr0rQgEihmh2zCliIUT/EeQ7rIB7L2+kILHNx36issxyAOZR/LtzDcVvWfyni81Lp1fyo+0qFnKxqyvyLCdj17L30qUQkqFm2knlqXaCRvv6/8KyTOTbxjEm
 uwPJ/mAY
 Fc4tdJi1vVnxRvNBOpcx59k9rNbhc3Z1+wUzD1mgof7Zwy/pL92BeQ98PkXra2oNsj/RjOd4+uhKW+gxEY28Aqjwgty5Vv6sc2Lm1MPa0a/BBKXtb0e+HtWUwZkDTHIrn8/LeCE4BJzjKcYHATHZMwR5ezQ4NLpCYmXGfIzoZrJUfaMQbzzflQt91Px1uMBlzVD8ni+Ttk1oBOuResGW+IcH8sGwi3dCUrFkCV4UR40kTqPbyxvaAXoe3t+UX5l0ifaIx/253Zkd2He3WqIIHRY2J/Zz1S9B/VTUlN707VkVnNDEaZVgsuCfKNdjJDRT2GxpAjvDOZwbeKfFzSl92Lim6oh2DO9CAHlVv/58Mx0nN7xwbgorGTu8ff77Dz/gkWNIH1eJ0JQCXgGsHDRxsw+by7ALjTMJ3BQjM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

According to DAMOS design documentation, a scheme is deactivated when
nr_snapshots reaches max_nr_snapshots. However, the previous
kdamond_wait_activation() still checked the schemes which nr_snapshots
reached max_nr_snapshots.

This caused an issue - when all schemes were deactivated due to
max_nr_snapshots, but their watermarks were still satisfied,
damos_wmark_wait_us() would return 0, causing kdamond_wait_activation()
to return 0 (activated). The main loop would then continue without
sleeping, leading to unnecessary overhead since all schemes would be
skipped in damon_do_apply_schemes().

To fix this:
- Add a damos_is_deactivated() helper that checks both wmarks.activated
  and max_nr_snapshots conditions.
- Replace the wmarks.activated-only checks with damos_is_deactivated()
  in both damon_do_apply_schemes() and kdamond_apply_schemes().
- In kdamond_wait_activation(), skip deactivated schemes when calculating
  the minimum wait time.
- When no active schemes remain, sleep for sample_interval as a fallback
  (consistent with pause behavior) instead of returning 0.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 mm/damon/core.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7230483e771f..57d1a21a8a0a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2633,6 +2633,17 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 	damos_update_stat(s, sz, sz_applied, sz_ops_filter_passed);
 }
 
+static bool damos_is_deactivated(struct damos *s)
+{
+	if (!s->wmarks.activated)
+		return true;
+	if (s->max_nr_snapshots &&
+			s->max_nr_snapshots <= s->stat.nr_snapshots)
+		return true;
+
+	return false;
+}
+
 static void damon_do_apply_schemes(struct damon_ctx *c,
 				   struct damon_target *t,
 				   struct damon_region *r)
@@ -2645,7 +2656,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 
-		if (!s->wmarks.activated)
+		if (damos_is_deactivated(s))
 			continue;
 
 		/* Check the quota */
@@ -2655,10 +2666,6 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
 			continue;
 
-		if (s->max_nr_snapshots &&
-				s->max_nr_snapshots <= s->stat.nr_snapshots)
-			continue;
-
 		if (damos_valid_target(c, r, s))
 			damos_apply_scheme(c, t, r, s);
 
@@ -3220,7 +3227,7 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 
-		if (!s->wmarks.activated)
+		if (damos_is_deactivated(s))
 			continue;
 
 		has_schemes_to_apply = true;
@@ -3704,16 +3711,23 @@ static int kdamond_wait_activation(struct damon_ctx *ctx)
 
 	while (!kdamond_need_stop(ctx)) {
 		damon_for_each_scheme(s, ctx) {
+			if (s->max_nr_snapshots &&
+				s->max_nr_snapshots <= s->stat.nr_snapshots)
+				continue;
+
 			wait_time = damos_wmark_wait_us(s);
 			if (!init_wait_time || wait_time < min_wait_time) {
 				init_wait_time = true;
 				min_wait_time = wait_time;
 			}
 		}
-		if (!min_wait_time)
+		if (!min_wait_time && init_wait_time)
 			return 0;
 
-		kdamond_usleep(min_wait_time);
+		if (min_wait_time)
+			kdamond_usleep(min_wait_time);
+		else
+			kdamond_usleep(ctx->attrs.sample_interval);
 
 		kdamond_call(ctx, false);
 		if (ctx->maybe_corrupted)
-- 
2.55.0


