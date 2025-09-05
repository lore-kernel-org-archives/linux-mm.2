Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 152D3CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 10:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ABCA8E000A; Fri,  5 Sep 2025 06:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 583858E0006; Fri,  5 Sep 2025 06:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 499A58E000A; Fri,  5 Sep 2025 06:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 359E48E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:10:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D873E14065B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:10:51 +0000 (UTC)
X-FDA: 83854777902.29.8E95A43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id F2300100005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:10:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=aisle.com header.s=google header.b=oF5BRqA6;
	spf=pass (imf05.hostedemail.com: domain of stanislav.fort@aisle.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=stanislav.fort@aisle.com;
	dmarc=pass (policy=quarantine) header.from=aisle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757067050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DAnIhBQbDm9gjZjqjenS6A8LuOGC08UU7yZ4phQFyfQ=;
	b=KarL3QJfXwE0L0pdgpGgbTSiVhnFgiLBLZQS47sFju6zVjJbNjyE3eYh8m86rRGeUbWlE1
	hHeUB6tZgHvRkhTw4YgZMSLEwi0dd2rmudK8AFA24N7v7uRhgqxZu65PBKIpHhnmV31BAV
	Kswer9i0UQy+1Alb42HlOW9F/MqLUvY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=aisle.com header.s=google header.b=oF5BRqA6;
	spf=pass (imf05.hostedemail.com: domain of stanislav.fort@aisle.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=stanislav.fort@aisle.com;
	dmarc=pass (policy=quarantine) header.from=aisle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757067050; a=rsa-sha256;
	cv=none;
	b=6mEB7QQBYXqb3sYd1k9+YYDm8cwnyfc4YRP08bpuqKCPPPqNSp+AsvpkC2H2YrfKcqchc+
	9IO3jOu6PciJ2/P0vttSPT37OyReRZXc3T0CdkWPlt+/WTL0yAv4hakXMcmNtLsA7rwEkF
	1PGAhGXVgna6TiL96JGUKOeuDy7vSb8=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b049bd81ce5so86068966b.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 03:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aisle.com; s=google; t=1757067048; x=1757671848; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DAnIhBQbDm9gjZjqjenS6A8LuOGC08UU7yZ4phQFyfQ=;
        b=oF5BRqA6aqrZUO4rco06KGNZ44DJcPnMIVVhYA/eW4fZ5DcPjN3ZgoR0Ha3sf3c4C9
         aD+0vh4tGWjMJH867Cdkj56tjiVACLDaxv2CyiXcnhVlzrXlGSowVg1TEeo2HNAjFGV9
         vTVLY8v/OkNDx/FPNokjUyTDggF4nV68d7sT2IOIlG3hHk4+30D4rYmqQm3wAwv2NJcd
         soOl17WjRJF/AJTzxd+6t1A8tVnJUiQ2Db8L/+wYke18cGzpU20uGAhIbig4QcOuce5m
         o9A9k//NzrFxzdvTgK6d2DYqy6gZx7Gh3Vsqmx7GTcvCPcUUjEn00yYzXaS1Gkpcjdm4
         QDzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757067048; x=1757671848;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DAnIhBQbDm9gjZjqjenS6A8LuOGC08UU7yZ4phQFyfQ=;
        b=aM40ufMGE2oovd6IJYVcv0PkLR6RVYs1f57Y2ywH/wqrymy6fy1QqxH2wU8UpfMkeR
         x34WVtO9fDIaHc4XrEsh+xJYihMWCXH3VsH+ExxzLV30UZ+Phz95BOXx8oBf/kRJLnIO
         9w7xvqJy9x7Gc2wEo9uo6PNLza0iYf7x+dVlWvGu28DyWPC3xOI1q3mihxdOR6ahXr0A
         4HqTTebyhb/KTwT4t6wwQ/zam9yPgnl4eLi4Dn8+uQm+/jL3hQpKF67qzroDm8fNqj//
         +g7DomQkDGKFXuIkUGLhQiC+M5mF2oiBcLFH5MWYqPJq4sD+E25YCz8s72eByJxbjXN3
         sBCw==
X-Gm-Message-State: AOJu0YzM91rQ1XPEKVIqWxo8pqeiWPKqFSPhmjun0OHfAcMoETEZrC3T
	HP/HVBC6aGQ2j0VZjeHd3kQjsXvVNf8E9h5nRKRSMdgfjP5sBJrdhFxtmdxn2fRV00o=
X-Gm-Gg: ASbGnct/oqQD3BhudfshXAoL9VSps3PIekcYaeTd5R/DT7eJhp8AW+UNAr8d/npWYZL
	FsDYon368v8coVvpbibMMNX+ZIVIzqcBQb6f+hfNPbab8iKq24C3DyPHxuuxgSyESUCFtRvqymG
	hNTnrrjelbfdWdxZ3zMXRFzpL7Ea19oWDiXNsi0JFmCiMwzdDbdA0kfWWpRc7j2HmxcrcsGFg2f
	rXFcNx08IFSlS8VMcd8BXGkIWMN45caHlDIvcAXuPSWjo8IC9jWgXHyvm/0fl+hRT+uvasQj5T0
	RNBovzjJwZTdG7wJa8BsMarOnLhbwk0VmpxvLGoN+/uXn+lhVp9yu5oAPsNPVxYvhbFR36lJ2ts
	A/HW3+at60dN6QS9W/G8vkJ/V3otWrYYDv2i6BlWu65QIKCIO5nN1KKS1WQ==
X-Google-Smtp-Source: AGHT+IGp1pr9JZHYShV64sfeXi9j9BsKxp4VYxKhIH6aW6aeCKq4sV+NmvY4luz6jw3F75rB7Ogdww==
X-Received: by 2002:a17:906:e57:b0:aff:1586:14c2 with SMTP id a640c23a62f3a-b0493086abbmr283824166b.4.1757067048302;
        Fri, 05 Sep 2025 03:10:48 -0700 (PDT)
Received: from localhost ([149.102.246.23])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b02152cc1b8sm1530574566b.36.2025.09.05.03.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 03:10:48 -0700 (PDT)
From: Stanislav Fort <stanislav.fort@aisle.com>
X-Google-Original-From: Stanislav Fort <disclosure@aisle.com>
To: sj@kernel.org,
	damon@lists.linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Stanislav Fort <disclosure@aisle.com>
Subject: [PATCH v2] mm/damon/sysfs: fix use-after-free in state_show()
Date: Fri,  5 Sep 2025 13:10:46 +0300
Message-Id: <20250905101046.2288-1-disclosure@aisle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: brshwptjsg9z6q8a5cx37ukq1xemsarh
X-Rspam-User: 
X-Rspamd-Queue-Id: F2300100005
X-Rspamd-Server: rspam05
X-HE-Tag: 1757067049-217266
X-HE-Meta: U2FsdGVkX1/1p+wKG3CHWgQDyhwSSQpmnqNcpkP7XMCwfL5D7HiTRFnQzQ1S9NAru5OVbmK/ii1vAyLKSk7w3RZ3YVPUdo5dW8rqbuIl4HkXUETWX9+ec6jeaX5xk0lXyimNeQinmiVX1t9IB8MVbMb4iXrn6+1tHxa8GbWeihcO7NoyR8yq6ArC9hZfpwb6SBKmIU9Dwndtf2fPqeBZDr1Jtcg/9grP4wtRgtWnbWBoXufWl8md+yp7RwiEO+6sxI1ICCLiRj8QivjoHLYrOjR9sExnDlFwwLOjDX2/kZXbmdYNgjwfsVduM9ZUuqFUr31gH0Huh0BYdc48irWArO4PlzjU6L3oqKSV7SpVVvrfvjo8ZLuWUAdC/3MWfEyvrvBgkNyj2W02oLrf9spo7p/ONkiqo6LrCJ/yAyPA8GRvpDITO2sJV+mzMLrGetmtEj20br0l9lwic/tTQwkhGwoja6j63PJXJk2/6C6U217CVUFHD+oDIg9bQWfVoaPOR4F82GxUm6mil/ibg2dE+q/2Jb3Rn8G7rl/QPR/8xYttXz5FOtyA/rW2OrCosYs8zxWbofWNEUx7rPc150cAEfzngH+UL9NevNi3k7blQ8dYgcjBFz/ixLXnaD6ga+BiZ2JxpkvRCSwCtOXXeNqYBzoSjxc7ugSAz1vukZN7ndfn6r8Xd7Kc2COqMckceY6tFW9Esczifq+nDkTCWh0F1M6oJIL8deinDxuu9uK40yCFWPz8DWzarV8H84eqRS/P4SZ+vlhWQ68LDMvKmS6gBXA4BDcbaoSSfRsTskd9Wn8yrVqYFueFzHuAywU37U5jD3Pq1Sr0wt5GscEeSYhsoNwFDYTN04oWawJqr2fmoPA8BNWmtdZezzNR6/DlPFnV4Luv8YVViRhsNRVW3B+IWzVIFrUPCm/8ZduyFdeQLq16UwND77jWepjekOu2BykoCMoDdcb916B2eru/rBl
 YC5I9qdX
 rl7alUdc98/gMkMZCb6a/FirZs7fhyj6ud4MMHtlCXHej7GibXyOA9OyWff7qAeM5i+Nm/oegQEX6jn4YclI9g2Gi/IVdE1g/4iZCpWQmbspwLBhi7UZDk/TwxNquCaqZFhPg0DcnhfAdgC3v2bzl7JYoC002PeQnxB5xvGP+UmZWvxpULJRIKcOYOOkQCPsd4wCyANmmKba5SC+BKulI231eh2ua7anhPZVW34v7mfmwkjAl31D2RhFZtowl20tLwO90iVsqTmH9IkaiMOFJLIf3s3lu1/1sNKNQQd+vpuI4k/IYbS8SDvysN7l+ySXVf9MVCkPWYkQ1VZL9oo3dkv0dyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

state_show() reads kdamond->damon_ctx without holding damon_sysfs_lock.
This allows a use-after-free race:

CPU 0                         CPU 1
-----                         -----
state_show()                  damon_sysfs_turn_damon_on()
ctx = kdamond->damon_ctx;     mutex_lock(&damon_sysfs_lock);
                              damon_destroy_ctx(kdamond->damon_ctx);
                              kdamond->damon_ctx = NULL;
                              mutex_unlock(&damon_sysfs_lock);
damon_is_running(ctx);        /* ctx is freed */
mutex_lock(&ctx->kdamond_lock); /* UAF */

(The race can also occur with damon_sysfs_kdamonds_rm_dirs() and
damon_sysfs_kdamond_release(), which free or replace the context under
damon_sysfs_lock.)

Fix by taking damon_sysfs_lock before dereferencing the context,
mirroring the locking used in pid_show().

The bug has existed since state_show() first accessed kdamond->damon_ctx.

Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
Reported-by: Stanislav Fort <disclosure@aisle.com>
Closes: N/A # non-publicly reported
Signed-off-by: Stanislav Fort <disclosure@aisle.com>
---
 mm/damon/sysfs.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6d2b0dab50cb..7b9254cadd5f 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1260,14 +1260,18 @@ static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 {
 	struct damon_sysfs_kdamond *kdamond = container_of(kobj,
 			struct damon_sysfs_kdamond, kobj);
-	struct damon_ctx *ctx = kdamond->damon_ctx;
-	bool running;
+	struct damon_ctx *ctx;
+	bool running = false;
 
-	if (!ctx)
-		running = false;
-	else
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+
+	ctx = kdamond->damon_ctx;
+	if (ctx)
 		running = damon_is_running(ctx);
 
+	mutex_unlock(&damon_sysfs_lock);
+
 	return sysfs_emit(buf, "%s\n", running ?
 			damon_sysfs_cmd_strs[DAMON_SYSFS_CMD_ON] :
 			damon_sysfs_cmd_strs[DAMON_SYSFS_CMD_OFF]);
-- 
2.39.3 (Apple Git-146)


