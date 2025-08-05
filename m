Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0512C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 16:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 711C08E0007; Tue,  5 Aug 2025 12:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1DD8E0001; Tue,  5 Aug 2025 12:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B0C28E0007; Tue,  5 Aug 2025 12:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4889D8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:20:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0CC61D98CB
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:20:58 +0000 (UTC)
X-FDA: 83743217796.16.413D96D
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 17F12A000B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:20:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z+B28lPD;
	spf=pass (imf15.hostedemail.com: domain of bijan311@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754410857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bx5UQH2AP53zKZgFMv/Gb2uS3eFAcrg1hCo7F6RktNc=;
	b=WlokU89N4tcLUqvUKTuVNRUuXFHysjH4SDTZvUzWMTZQzkZgVPW+tge0ZnpMqdGjMXW1vI
	mhyB9EZ68yKXgrnDyWcysnBh7KKyCekRbNHlv0ihFmT+qP2+B6ti709FoMbp5NKa0jIEzo
	hM/QFidE76PximQBCq3JeFdgJRu3TKY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754410857; a=rsa-sha256;
	cv=none;
	b=YYaSeADo2Gp9oNO6oYBiYrzgYYXFeuS2u34srkz42IoEzA3rv/rMJwNoQjyRRsObPj6MWf
	U4okUpNCRMo6EcD9ERYDaH9JKxmHPsJW5GbPL1IvFHG6S0V9hqWhWtStYWcB9aFoKpL9r5
	XKl8/L9B1wNHYQVOfT/F15hm+LVrtIc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z+B28lPD;
	spf=pass (imf15.hostedemail.com: domain of bijan311@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-70a57a8ffc3so56153697b3.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 09:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754410856; x=1755015656; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bx5UQH2AP53zKZgFMv/Gb2uS3eFAcrg1hCo7F6RktNc=;
        b=Z+B28lPDWQqZaDab8jU8DbKWjiblSbVkHDDKg/lD3qWzl0koG2syAzpTw3OPReJMPv
         PqTytnHnxLOiUHIKKryvBNmX88FxouJ+TulzjWA7EF0m3vImwlFObohEFXZSx42dJ7g7
         OaG1U2xGjIY7ItBQ1PhgAO8J5YdJNGx4cJHAgB+9DsMzmMixgQmbZ5JntjxPfNKDsngU
         WRuJgiWHlDaxLXEOKVLa1Z36+WKVC+FvA7BbodX34awnfB5hX/0y5UV/Cd2CLQkIjkgz
         hATRj1KN+VHqWVsRl7P4LSdOgBB/518YDCu1rldcGylcIgtoW84h2NgVW8s1LCaIIqI7
         c0hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754410856; x=1755015656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bx5UQH2AP53zKZgFMv/Gb2uS3eFAcrg1hCo7F6RktNc=;
        b=pV8lf1joT0Q0vqk/qqJ7inj2AOf8rjCyjN34iYW9BxneMZMSLipF7AzPaBGu7jWz9C
         UuKYm49UArNWpb7B0Kv+4SiI1xC9fqbcHUYchTRhJcZQluv7vH6LiA58JqbINpyvZhHD
         fvgDN0j/V/1WTzZlC6CnhYF09LNBNAoN8zh2Rrimg0RXcfO6UJd0TT9V3mLBp59HO/C4
         DaHUK0aG/xxbuSuy+dDA0fbiYWok711ge3ISRaRM7EGktwsPrHuHc4yKgGGG0kTnie/C
         W+I09bFtOIs2NDLw+zOVuDX/Q7+2q2PK+denb3zLlJi3vex/E0A79GoLn4h/4hcFpNZC
         ar0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWpjNdAA01r11F3YnNl2QWq3Bp8Y/DR8hFzpFloBbqhbZpUC9nRBO9yG8ajMaSt9VS/iJkWDhQV/A==@kvack.org
X-Gm-Message-State: AOJu0YxhW/HscRIhunKXYckDN7jzMxDnZhnRNBrmiptMhmD+Lhow4SQd
	ZIphVPZWLdxQNgcS0/ChalGfHRM5AgKXMyw4i69G+01/wtR0O+Z3YN4v
X-Gm-Gg: ASbGnctw0Q5J0VFFBuz0xJ+XLhGBpdARKRZRSkynO6yyPxBA9FXPIsTwuQ5FUmHYpps
	ii5SfSM3BYcr8GpgCQOsQvkt/qokQCC0YavEa9SDb7szggv9aml0ZaueiqRPCwyeLFLkwwUBhAW
	jpkszM4W848Zv/FoPee9rI/v5h95yxEYX+7NfVRtumOAARHT7nQ67iYgVeHBW8QSiulXTTjmayV
	7X3HtLFPA8GsECyQcUrUjY9fEnkrCXnji2sDqZCRXXgbTXaIbpSz9ofpM6eM1mljmBR9Hc+zSff
	y89bAip1vbIVerBU39v1nWVuxXkD6twH5S20K/5UxEKkgcjGZdMVMUANLVEIeKBXTbkItrRhqw8
	zzM4JSms3IfUnq9h8CbFR0m9VbnvYHlrhywQxmalYljw=
X-Google-Smtp-Source: AGHT+IFlo58+shaatwrcSK3z92CxM5zcfRVC7mFQfOpwfhIPPC64bmge/xE/VJyP1a2lBc5ROadoGg==
X-Received: by 2002:a05:690c:102:b0:719:4c68:a70f with SMTP id 00721157ae682-71b7f7f5e71mr172583967b3.20.1754410855971;
        Tue, 05 Aug 2025 09:20:55 -0700 (PDT)
Received: from bijan-laptop.attlocal.net ([2600:1700:680e:c000:2c65:e45a:e7d5:5f0e])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a5cdfc5sm33098757b3.77.2025.08.05.09.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 09:20:55 -0700 (PDT)
From: Bijan Tabatabai <bijan311@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: sj@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	corbet@lwn.net,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: [PATCH 2/5] mm/damon/sysfs: Implement a command to only commit scheme dests
Date: Tue,  5 Aug 2025 11:20:19 -0500
Message-ID: <20250805162022.4920-3-bijan311@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250805162022.4920-1-bijan311@gmail.com>
References: <20250805162022.4920-1-bijan311@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 17F12A000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: x8iwgbwaow36nx9ortimi5eewrnnhci3
X-HE-Tag: 1754410856-210115
X-HE-Meta: U2FsdGVkX1+BeqyYEAF2r23dcCu/U8uJNofHU3LOmewAM7KYHbgV5G1DPD0SqY1/9SlFHlaD96wJej2Wxuq+0ix+Aprq16RSXW2AENNE/fHqpa/lo/85UT2S00WYv0KosEj3UW0dqcUz78Wx5VMnvp4tspKukse07MZP57JIPg5O5O5qbFjKIkWr7D4dGLN7XhkJaEiEvpliVOMSNsFsGQY/yzfndFmLaBCD009/FQfhYEh9J8vURPGlpFIbUkvhyWZmwmYdMgpb9t5C3pVQn7T6WJnD6C2PyYqV9CMfNAIFpfmWwGcbWKRsi2PkCfPHipMmnoCedhc8ixYqrtuwHeaC5fHgS/jjt+56zDGYsLa/Up3MhlmmuyMQWi/PZpgjcLR5OPSBKh6nviyryMHc9TqZAYq6CnO0VW+eXUnUq6HD3NxmzAhPaV79dqEpvEaBqyg8Uzpy8dScVYFZSjSXdejn10HbzVspxckSL5IJ4vNksDTGVzlrNUHtDrEQmWEJxWnLvY51xBP3nLBgzhSQPXORmruVfBaXTkBsTfanStw2qGCpoZM98HdtCQBFnMNqZ7bKLrdbn3q6ipzt2TE8QbZUb8nwV4BNDCqt6CV0iQQjaB3GNJbKN8A8TIKUROe7DfQ24J63rcfZKYUHVzHbtGXPZUUr1zM2UzAQ9yTo1VUDjgn8dSM6goGjKeh5UvUSlJlKu4GCZDGKYzR0PZjCK1XekaHgm9sGkw7ecIiNfUs28wd6cg3v23deSx2aYtv9I0YP8EarFxe6g+bO9XaQjve2pyeXPfcZ2Cxsvcwv1XxxJLPNuUAkNGU8m82oSaofdlzbN3rObTity4trqeX8VqQG1RLw3T9OqQja9Qq4U9gVnbpNHBhWAmw96p11DPZZoofhKz36zeXOD6rIi3YseyY9KF/z6LqcjtkRG+eXsXvmx5ZMyydQdqnG03kTmbbNkWbdlLf/WKWFSL82q2w
 XIm9qDGC
 kcxvyqW/O14H1dUlEJcxBPcyW1u2C/NDQcdf1uDapjV8gR/1qpcfCLs/jdFxXUxP4XoMJJngeS3x01PQ67DuqWS4k0qthGWChQlRT12hDU5SGLofWyfCvFA8B9AFSdZruQ6+llp0x0SGo57slt5tzMltZ740DJeIBTiEaDrpNue+epL9eIyAtb0fSRiwGjJ5PiBORQCVBPLFkvEbpH3dpNQUYZVXlrx0knEAvMgBfNBIhTOfKGmiVsh3KFiIBLZs0KwuBycNsfQ1+m4Gjr1z1KPlY1j8Zh7He/DzZRU0+SCEqx22sL31qbh7AcxaDbCdgeCpBWiE+LckicMfUkXzSANUL/O/OPG7Dn+XabOcZgKnfdrnZJE+PmuAYefWjJncE1XnMqQbH4xr9VZBVIuTYUjYp6eOhno2IGqZyFBWUV+d5s+UUeuW9OeyF1Dqo5FcFdxB2Sfre14x+Sbg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bijan Tabatabai <bijantabatab@micron.com>

To update DAMOS migration dests, users need to write "commit" to the
"state" file of kdamond, which will recommit all of the damon parameters.
This patch implements another state file input command,
"commit_scheme_dests," that only commits the DAMOS migration dests.

This provides two benefits:
1) It is slightly more efficient
2) When the "commit" command is sent to the state file,
   ctx->next_{aggregation/ops_update}_sis are reset. If a user sends the
   "commit" command frequently (relative to the aggregation and
   ops_update periods) to update the migration dests, the aggregation and
   ops_update events will be prevented from triggering. Having a
   separate command side steps this problem.

Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
---
 mm/damon/sysfs-common.h  |  3 +++
 mm/damon/sysfs-schemes.c | 35 ++++++++++++++++++++++++++++++++---
 mm/damon/sysfs.c         | 27 +++++++++++++++++++++++++++
 3 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs-common.h b/mm/damon/sysfs-common.h
index 2099adee11d0..3189b2bda079 100644
--- a/mm/damon/sysfs-common.h
+++ b/mm/damon/sysfs-common.h
@@ -59,3 +59,6 @@ int damos_sysfs_set_quota_scores(struct damon_sysfs_schemes *sysfs_schemes,
 void damos_sysfs_update_effective_quotas(
 		struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx);
+
+int damos_sysfs_set_schemes_dests(struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx);
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index d355f6c42a98..d30c8b6575c2 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2445,10 +2445,9 @@ void damos_sysfs_update_effective_quotas(
 	}
 }
 
-static int damos_sysfs_add_migrate_dest(struct damos *scheme,
+static int damos_sysfs_add_migrate_dest(struct damos_migrate_dests *dests,
 		struct damos_sysfs_dests *sysfs_dests)
 {
-	struct damos_migrate_dests *dests = &scheme->migrate_dests;
 	int i;
 
 	dests->node_id_arr = kmalloc_array(sysfs_dests->nr,
@@ -2468,6 +2467,35 @@ static int damos_sysfs_add_migrate_dest(struct damos *scheme,
 	return 0;
 }
 
+int damos_sysfs_set_schemes_dests(struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx)
+{
+	struct damos *scheme;
+	int i = 0;
+
+	damon_for_each_scheme(scheme, ctx) {
+		struct damos_sysfs_dests *sysfs_dests;
+		struct damos_migrate_dests dests = {};
+		int err;
+
+		/* user could have removed the scheme sysfs dir */
+		if (i >= sysfs_schemes->nr)
+			break;
+
+		sysfs_dests = sysfs_schemes->schemes_arr[i]->dests;
+		err = damos_sysfs_add_migrate_dest(&dests, sysfs_dests);
+		if (err) {
+			damos_destroy_dests(&dests);
+			return err;
+		}
+
+		damos_destroy_dests(&scheme->migrate_dests);
+		scheme->migrate_dests = dests;
+	}
+
+	return 0;
+}
+
 static struct damos *damon_sysfs_mk_scheme(
 		struct damon_sysfs_scheme *sysfs_scheme)
 {
@@ -2530,7 +2558,8 @@ static struct damos *damon_sysfs_mk_scheme(
 		damon_destroy_scheme(scheme);
 		return NULL;
 	}
-	err = damos_sysfs_add_migrate_dest(scheme, sysfs_scheme->dests);
+	err = damos_sysfs_add_migrate_dest(&scheme->migrate_dests,
+		sysfs_scheme->dests);
 	if (err) {
 		damon_destroy_scheme(scheme);
 		return NULL;
diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 1af6aff35d84..c2b036abb25b 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1188,6 +1188,11 @@ enum damon_sysfs_cmd {
 	 * to DAMON.
 	 */
 	DAMON_SYSFS_CMD_COMMIT_SCHEMES_QUOTA_GOALS,
+	/*
+	 * @DAMON_SYSFS_CMD_COMMIT_SCHEMES_DESTS: Commit the scheme dests to
+	 * DAMON.
+	 */
+	DAMON_SYSFS_CMD_COMMIT_SCHEMES_DESTS,
 	/*
 	 * @DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS: Update scheme stats sysfs
 	 * files.
@@ -1230,6 +1235,7 @@ static const char * const damon_sysfs_cmd_strs[] = {
 	"off",
 	"commit",
 	"commit_schemes_quota_goals",
+	"commit_schemes_dests",
 	"update_schemes_stats",
 	"update_schemes_tried_bytes",
 	"update_schemes_tried_regions",
@@ -1478,6 +1484,23 @@ static int damon_sysfs_commit_schemes_quota_goals(void *data)
 	return damos_sysfs_set_quota_scores(sysfs_ctx->schemes, ctx);
 }
 
+static int damon_sysfs_commit_schemes_dests(void *data)
+{
+	struct damon_sysfs_kdamond *sysfs_kdamond = data;
+	struct damon_ctx *ctx;
+	struct damon_sysfs_context *sysfs_ctx;
+
+	if (!damon_sysfs_kdamond_running(sysfs_kdamond))
+		return -EINVAL;
+	/* TODO: Support multiple contexts per kdamond */
+	if (sysfs_kdamond->contexts->nr != 1)
+		return -EINVAL;
+
+	ctx = sysfs_kdamond->damon_ctx;
+	sysfs_ctx = sysfs_kdamond->contexts->contexts_arr[0];
+	return damos_sysfs_set_schemes_dests(sysfs_ctx->schemes, ctx);
+}
+
 /*
  * damon_sysfs_upd_schemes_effective_quotas() - Update schemes effective quotas
  * sysfs files.
@@ -1644,6 +1667,10 @@ static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
 		return damon_sysfs_damon_call(
 				damon_sysfs_commit_schemes_quota_goals,
 				kdamond);
+	case DAMON_SYSFS_CMD_COMMIT_SCHEMES_DESTS:
+		return damon_sysfs_damon_call(
+				damon_sysfs_commit_schemes_dests,
+				kdamond);
 	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS:
 		return damon_sysfs_damon_call(
 				damon_sysfs_upd_schemes_stats, kdamond);
-- 
2.43.5


