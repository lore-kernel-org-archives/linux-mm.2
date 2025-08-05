Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2581C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 16:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 479B08E0005; Tue,  5 Aug 2025 12:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403918E0001; Tue,  5 Aug 2025 12:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CA758E0005; Tue,  5 Aug 2025 12:20:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 16A068E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:20:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C10D8140156
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:20:54 +0000 (UTC)
X-FDA: 83743217628.06.50EF76E
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id DD68A1A0006
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:20:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JTeDu3iu;
	spf=pass (imf19.hostedemail.com: domain of bijan311@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754410852; a=rsa-sha256;
	cv=none;
	b=U0buxQytQoF0/MEQ4gzAIfZrujiEhacSd030SQysxGY9P1IZYbGHG1yD/yq2N7RSejR33h
	3WQ8EKlmWHkO22RKwSky92LL/fHYbwJbWljr3DeAbf5FIgVkwinIn4gMKmGYdikc/LGp+m
	U9y/8M1F4YjnmYeFnkq8Zsmy0oxlxrY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JTeDu3iu;
	spf=pass (imf19.hostedemail.com: domain of bijan311@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754410852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pDs8MlFPdGXXGi6TlMzCzWKbAeHvaPRj6HPGrEA8aHE=;
	b=FYe5OLDEKowys2/Sw2xyfql8CV4VBdkZBvN+TfMa5Hw35heU92oSKDme7Qoa9WlcjIzVvi
	sPUpYNgvCKa+9BR6JbKMMczb6777WOTyB3+2MlSRF8xvznDEYG/JtEhqeQO4ZcNusLlXtk
	m+A/aNw+aYxOl9zvYU5jbZgUBQ4Rc1Q=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-719f5a141a3so290687b3.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 09:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754410852; x=1755015652; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pDs8MlFPdGXXGi6TlMzCzWKbAeHvaPRj6HPGrEA8aHE=;
        b=JTeDu3iuErma/+mGPJey7xt2G7rmA8WyfSSy+twSDoRfaET0USD4fnPkNxmWQHmfa2
         VA5ovFjoryvgHmq/wFxWiMaXm1U4y9FWsxhYO4YYnOWx9U6v9JsdqbkLb5tAOAOjWdwc
         9BSPksLYg4Yz/MgsircJbqGhbjHbyuM/KsBCZBzI0pZZbgzVqzxVWbkoeEtkGk0F+xTD
         hJCpnwakVUFAfGn176GxGdtplZI56JeW4Bf3N7I+GYsGLzIUvFKTqy2EhvN2iW86+Qwp
         Gy9O0xRjdUnO/DFWduD1QgiE8DHXGVeWmxShzV3HL9DTUgNj5W5p6NNcS6RqInuDKYst
         4abw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754410852; x=1755015652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pDs8MlFPdGXXGi6TlMzCzWKbAeHvaPRj6HPGrEA8aHE=;
        b=TVnRp+IZVv6eXNZ7cHVPxN8CGrZvXLafoAXBJxRy0rUIOdPSyTBWP+ReccklYEBrTs
         I8vHyrcAIn4ByyyK1thvO777fTrfb7HhykakARHsKB5gtY5/vXeM0dZ42pQHpAM6JTJA
         Dq2GfZFtLsOEoRaM7nuOSqY23Rg4Vcsz+HwskxnydaWmlZqfRbWLlfJbnFddDbetGizY
         Rn7XkPHsQdgGzm8lRLpN6pnps6qcdSLEhe6IAtg3Umh29LbJEm0L586lg7eakNsWUzM3
         zuCUAI+Tlf1cemGuy6jE7u8CD9lZrojLGkUXNnmpBarEEg7zN0BWADYuA7I8/QDTv//Z
         dssg==
X-Forwarded-Encrypted: i=1; AJvYcCXEZAqyLPLRhZorGYuITGk/xCHYFUav506Yo4WWttRhfVAbBz0Xp4+bdWkdQx4uNHtBdfR+yCNQWA==@kvack.org
X-Gm-Message-State: AOJu0Yyj+7XzTlVpU31JGfJnMq+iEley159xwXFk2RVTZocaVl2Pdq5d
	2InknmuWNS8uxQrOzFHIZ5/lej8dh0mFsOdc2kFEiytkyk++85vK6v0zArARgQ==
X-Gm-Gg: ASbGncvDqaoClQZLDjwAzQuDw3EpHeJQ6WpcCdh5N+8I1kC5oWLmgRTTUAmmI9yIfkh
	cCwmkw/ZgluSgkEViIpTPKB1hJG5lOC1fcI8wiRMyHhxSaC/Xl0nf03gGwDeQlBYJd0wtNojtvM
	8ShxeIZpE9Ck3z02RdUjQXakrrGFGvF/QV6J/yMFgn7xxp7z+Q5otvxvsEsl8Tk5y0+26PjA/C9
	q0aSmlhb/KI0R6Q/SakEMYsWJLWZ/SjF3+PNDy2qVYnAoZcGB2kWbZS3uLWRYcUhC/9GU6leWc8
	4459ZmtMM7JbVNdigcmwKM5ohXnTPpzHm95iRN7yIhs1cPaiYURKI3pcwzZobFH5aIcbpoBJ+ti
	aDzQwh9eeYpBwFNmwm4Reaj1v5CfYowjdAp0zOSuEc6/gXTEL/VyFug==
X-Google-Smtp-Source: AGHT+IFnyMpRgYiV7oRfT3D4U/J6G+wtU+eDsuK0pB5vtb532dpTisNQyFGaJtTj/nzk7d4QMO8Fuw==
X-Received: by 2002:a05:690c:6f04:b0:70c:ceba:16 with SMTP id 00721157ae682-71bc7edb174mr5896047b3.17.1754410851928;
        Tue, 05 Aug 2025 09:20:51 -0700 (PDT)
Received: from bijan-laptop.attlocal.net ([2600:1700:680e:c000:2c65:e45a:e7d5:5f0e])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a5cdfc5sm33098757b3.77.2025.08.05.09.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 09:20:51 -0700 (PDT)
From: Bijan Tabatabai <bijan311@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: sj@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	corbet@lwn.net,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: [PATCH 1/5] mm/damon/core: Add damos_destroy_dests()
Date: Tue,  5 Aug 2025 11:20:18 -0500
Message-ID: <20250805162022.4920-2-bijan311@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250805162022.4920-1-bijan311@gmail.com>
References: <20250805162022.4920-1-bijan311@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DD68A1A0006
X-Stat-Signature: 14w5f7oc99gwezwsafz4jt6juaowephq
X-HE-Tag: 1754410852-52443
X-HE-Meta: U2FsdGVkX1/t6vjBPrNboVmZh8aI19bwLYCHkna8qDOl232cAizEqmUSX/RilRtn7iyfpJ9N/w/DrnGv46JXvfLxzbBSevybPJnT+LvdBLvYIQzWVqTomVebMRuvfaVIJYu388FcJB8WW5a7DEHckq255lS/CCB+zlq3wgLWrrKpuz/vnLKVjWoTwvbI3kAJzBgHSjTEqT1J2QUdx9qj8cFHrZjXEFUltaiieGfNgi6V+4PHPdRrMsLSC41a6Z2tTSv+h8cNba8lyu7+/PyaoqqoqrldYNY2TSIfRLW1oLOO7mHHHYdoH02ZxEOg8Vs3gGV2AvHjgt3U7Mbxzix92/mqwfa5n/NP3BreLDNUMUhvaA7FllheHeCoACia/HfQR+OCVKbSzwfN39bdpXSosB0KNkgUk+Ptulj+kpuWBkuRa6ud77zsmtKqDDh8BFQSq5rDDWftYI39dFvi5MREBLBt4dKkGE1kKjQhUxFdcF1Kyt2FVv5lV0qtxVmE4VPDLMCf7Mgx/5SmEK++mOMvvmex/SRbo6lXLMrrk9BZr2f1kQYxRyGOfhyQudOYejyP5JFO5OzKf+rGpnvr0XUn6+iEwUDVtKvfPQmpAN/RDCfUYoVjdS8JEzzL20QHJe7OXNlOYN9mUmqyw/4RzbwY2bqC23o+MWijt+59Ml1rVYEppXD8rcTzX34S+aU/Ei+mg7zFR7yORG0BTNzGI78EP1lmKuug78w4cXWDrFn9SQ/42Y4Ob0qCn9r4+UhQ+hoBWGQJgJ9p8V/sEfPP5eU2Y2NknEcf1uoJ1FV1kHWf4Pk+S/xoYfYwTs6a3HKyc5zL85vUSxro98LeOYWivRSTm9NNeQmuXWioTBPVlVAK1PC39PHJpdwqyiVewjq3h4UApsOx1vwfE/AXnTb/1dovTjGmq+fzWXF8l2INLHVorcgQwm9pSv6OneZkTG4+U4tsmMOXMF8iDx/qcp6+vCW
 FsZToWgl
 wDPT++cPHURyytxB6X0vIzYdXEnEox/KyJn6qS+GZwUHWfgZC5BZpcwM48KBxR1W60coB4/iw6tmwIA1/XC4IxMVD5CPrAJZR9u2v/+VPJdnOokRwDwea7r1XhvpHG1BWi0SLSv8c8txFPSGLJbZimkbsS53tac9HcQxevX0Z10r1+ImOYZVIP4KTxnZsRVcfPJj8hVYRa4WgLIiR3ndZuV0H+V9EExjEAD6zyag4N4GGh4rpQdH1LEabxVP9UzMclP0HM/TIp2u0D1qm8U/ph0fuAZ7oQNkSFW8COJNrGHrrcjkSk0CjASr4CdeHaX4bkWsqnRv9DwlV2FS0umbGX9QohJfjW4po7NseTqsOjvbKehr1Ss9BoXk1FPay8e3is2YcDau2AYEfaZq3VIwIB6qO50VWOR6rzFq3LdJVW7xVF35tqihN0wE/l23wYKBDDn/F7oJfUbSajdJVO2WgiV6IOm6MpvmFPac6NCefw++7Dg7R/0iU/v4E18wUm5H2bgh5D5TPGjzordmcaQT+pwUax1XKUXIhWQjWRDtUkDGpgZx4LSDp4Cyug0q2FCxsySD/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bijan Tabatabai <bijantabatab@micron.com>

This patch adds damos_destroy_dests(), which is used to free a struct
damos_migrate_dests. Currently, the contents of a struct
damos_migrate_dests in freed inline in damon_destroy_scheme(). Moving
the code to a separate function is useful for when damos_migrate_dest
structs need to also be freed elsewhere.

Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
---
 include/linux/damon.h | 2 ++
 mm/damon/core.c       | 9 +++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6b797120d2f2..a851c8bc2e52 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -914,6 +914,8 @@ struct damos_quota_goal *damos_new_quota_goal(
 void damos_add_quota_goal(struct damos_quota *q, struct damos_quota_goal *g);
 void damos_destroy_quota_goal(struct damos_quota_goal *goal);
 
+void damos_destroy_dests(struct damos_migrate_dests *dests);
+
 struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 			enum damos_action action,
 			unsigned long apply_interval_us,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6a2fe1f2c952..07b4fc5a9790 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -359,6 +359,12 @@ void damos_destroy_quota_goal(struct damos_quota_goal *g)
 	damos_free_quota_goal(g);
 }
 
+void damos_destroy_dests(struct damos_migrate_dests *dests)
+{
+	kfree(dests->node_id_arr);
+	kfree(dests->weight_arr);
+}
+
 /* initialize fields of @quota that normally API users wouldn't set */
 static struct damos_quota *damos_quota_init(struct damos_quota *quota)
 {
@@ -451,8 +457,7 @@ void damon_destroy_scheme(struct damos *s)
 	damos_for_each_filter_safe(f, next, s)
 		damos_destroy_filter(f);
 
-	kfree(s->migrate_dests.node_id_arr);
-	kfree(s->migrate_dests.weight_arr);
+	damos_destroy_dests(&s->migrate_dests);
 	damon_del_scheme(s);
 	damon_free_scheme(s);
 }
-- 
2.43.5


