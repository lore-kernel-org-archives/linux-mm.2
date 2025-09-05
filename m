Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EE30CA1016
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A9B78E000C; Fri,  5 Sep 2025 05:03:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22CE98E0001; Fri,  5 Sep 2025 05:03:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07FD58E000C; Fri,  5 Sep 2025 05:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E10278E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:03:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 79DB5160604
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:03:37 +0000 (UTC)
X-FDA: 83854608474.28.29BBBD7
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8D8761C000B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:03:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Uo0UkaJt;
	spf=pass (imf18.hostedemail.com: domain of marco.crivellari@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=marco.crivellari@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757063015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k9Rqa4pGBGQ+nqaKUkB0WbuJqc5AZJEg5FxwGqJqHQw=;
	b=rRfsewb5r6wPLWYV5W3MhdzBI5xdOZP/ChUgxntb5PbmTEs1otKpJQ00XiWxlFw+pNM3PJ
	es5RmkXTW7eW2W69n/d4VWiv14WkIMQlZXA7CANXdQx8gaTzNbHjnR1jQ6GwymkHAWDa5j
	wqSV0dA5HCwMD6P/HM4nLoI2sCId2bI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Uo0UkaJt;
	spf=pass (imf18.hostedemail.com: domain of marco.crivellari@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=marco.crivellari@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757063015; a=rsa-sha256;
	cv=none;
	b=UygZVLUn0pcETH+BLosqZnk+XgDOUH+SCa63M3vv/w6X6CvDFcCajqYib7jI44Vv0PDsxG
	/yO5lAJ0dL5gwwvP3lzm7GuX8eyDp6GgxcXWWRKzDqkBwuHys+njCds3e4x96itdmlpjrR
	mx/sttaiEbT2/Qzjr98teDDtYyRhQl0=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45b7722ea37so9931265e9.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 02:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757063014; x=1757667814; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9Rqa4pGBGQ+nqaKUkB0WbuJqc5AZJEg5FxwGqJqHQw=;
        b=Uo0UkaJt5Fd3l8P+JOAKHvz7R8r4fLtEr5V4K5UwwxnF4l+OjgpkmQV9bFiiXWLjN6
         oH1zB6rsbRih7adA6IldOotIzTe0Wvsj2Fbo0B77Nd2YnNO8AImsI+0juhPOFl3Z8ozN
         MW6uaXocM9u6XS1gGixqUhXlCHXUdFMnT1PWPSUfI1ahUTlZg2zazXDU5wiaiVEdqMtC
         C3fQcW0BUZR7ZTUPLpb2U1BjufBOtYuU3UG45puEemh99+3o+EGgAkcCOwr1UEwtgua6
         bxluQOFqzR2j3+ale+aRRukLw/7yCyePYXn+72CnBRTYcoFJcK1X8ztIGWG3BZtYEseY
         KFrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757063014; x=1757667814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k9Rqa4pGBGQ+nqaKUkB0WbuJqc5AZJEg5FxwGqJqHQw=;
        b=KHSQJ97SYtvrIvSVcLOPnoCzgEqFqhnqekP9vvhWHWsHFa38kg+9kHD4M/KPMi6nMa
         40un5EXWl6uR3dcpy8vYp4mz43HFsRFqT+R1jlOVIiSUSqVvIlIXE2srXDT+8TjYANvg
         5KLeJWtJVvzVOrAcN0m6nGDAKuUATPSEJuRL/oCwqbfgeYWBNQL5JXKOeTs5Yk06TfAl
         aVsL97u/5KRr1PuuK5wmGp9Ps+l1HI2UzRKiEK9TvGKwqgAm+J/BCJTVjLnYbIlMmBHW
         8Glu00UDm9jUIDaMK6VP9uzBXP4rJhjlegBvBKSI+kj9ZvILnkB60R8gsebgUEtJ+C5U
         8WDw==
X-Forwarded-Encrypted: i=1; AJvYcCVERiNHH27OPGh4iubtTeskVexMAYliBMaEsQwyfiY33nQd8STm/xEO5Xdie0eMROfw+fyILig/zg==@kvack.org
X-Gm-Message-State: AOJu0YyP4l2stt7miJ6tPwbShbjtU/uUvXeNHsM4BBzAoN3aO4sOsXth
	dQvIi3Px75iC/QFw22VlCIQ/O9587cz9BKDbQqwlrjO6jy4E4hElGLYJrgsgl6VfogI=
X-Gm-Gg: ASbGncsayQsDesz3MmKBfrKf4t2x+uvvAXz+8X0bNTZtLFBoTqH3mbLmqOX8t9JocAj
	1JppVEbvxqi5SUpIorXc7HUuwJpGoImHObcxlWnnLhsffKKzJA3y70RIywIKshMmzPXFo3dt9rF
	jnDYfLKY26IXm9AmO791fQ6uIAGtJI4u8E+2g40E9fiLff3ToKjH9Q/3iho7Y7akMqjbx2XM5w/
	S+FQLJkBHF5oVy3aa18vWQ4xdfXaY0tgAr9Ya8d/i3oLJZrCKqZfd93Oy2cm5/5bYg/kZKHkane
	bfTR1322YIP1sY8fbgKC6xgHsfANfEmR1OZGZeqbS5s63YvPih+7+z8WnC7HovOmE6xzvppWHjv
	zR5XkLj87KVPd5M5yrosS4Z+XyvoP3T4QamA1Zmb41m6FODI=
X-Google-Smtp-Source: AGHT+IF5IWr97S5oTh0sTJHYmRd+RWZpF54xEoPhZVRBSB+xqmyXwnaCsRNO69Q1AcCVvKZ1nQuUdg==
X-Received: by 2002:a7b:cb41:0:b0:45d:d295:fddc with SMTP id 5b1f17b1804b1-45dd5b2282amr15894545e9.4.1757063014017;
        Fri, 05 Sep 2025 02:03:34 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf3458a67fsm3614543f8f.62.2025.09.05.02.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 02:03:33 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] mm: replace use of system_wq with system_percpu_wq
Date: Fri,  5 Sep 2025 11:03:22 +0200
Message-ID: <20250905090323.103401-3-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905090323.103401-1-marco.crivellari@suse.com>
References: <20250905090323.103401-1-marco.crivellari@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8D8761C000B
X-Rspam-User: 
X-Stat-Signature: of56f3mrr9hmqy5wjrbfd6o8ntsoyrjk
X-Rspamd-Server: rspam09
X-HE-Tag: 1757063015-229715
X-HE-Meta: U2FsdGVkX187u4hdCupT3piM0ZVEUMhoI6IPJwFphvQ/3jcLdy6eJoiK1HuVhM1kdMGsQSuMiOz7QkOrRZqjI7emvq89AaqR7ukIiu9wb/0kyD4lBkwa5/tMblj0gLtFtk1yVymKqfOqaShVh8X1uyfqUx3+lkH1K8sSq2zHgiWai9lx1NWwXVoNWIEkROOgZTXYd6nP2my8QIvfKZaFWTtS5vgLKZHSnA7V7BLXio6RwTrCaDmyoAEl/kDK9UnrgqyVfsH5+UbI0slNQJtGO45JBoDctcDb0RlDI6r9aPl6xWnqcmOa4P4PTfGMZrlXyF/j5VhyhZhZKlvZgcawHJjBYVHrGXIDQrpT8M1iOUjxz9bvyxANvDGt317tQhiTv5FwjHMUsTTb0n76z31jlSgd/kj4a8ULDqF01znyUyq8xgTBqomxoen1/DCU0UKYmuXEf11VTiIF69DHIQQgS92oV9ZhkuQeTkmsUIwuEKiU1PJ6mM6cPTxgqXxr6I9leMYgqlh2WvUXB4+WFCvnMJgdHeb+5VG9kJkVSKoA0UkXpxV+HuA7bR+7spVuNOuborE4Dx58PFEfy59whsv/H14D+0TNstwkxdKosimnLZQCAQBmMbrqqERcQ5wV6ATMuaObpD+RO1yuF3Q4eWXCBBrlXI8Ma7FHqAVHzYCs3RmEcN3cIP2Ns58OU+T0gzJuWalX7QBAmpFqajEQae+4blrGSW2Ml6BYsKFJJaEuv3RVw2M1+9YNhmnFm3AYl3RFBMTRZnon/fQjerbR1ORk6liHaWMoPodX9K45rfSuALWyf9DF3UqVR3pR3Gw+SHFpEAyPkya3ksqnng5YZruiO6ZszYzI+mOntzT3B5hE3mbpIbKVAd2Lv+CQuJoth212292a2pZcWyr7+spyXf4YsXj7hy/zjZVXXj4lUolUXeUalEuBcTNLIwA5OaSNjOBkTsjwXof+My7AyRQXUCv
 xDErdlrv
 ixME43O0UuxH2JwdSU+ljdFaT3mhHVzsBRmZduQJnR+7OcdtWoJNj4bhvQNvjumL4Y3YJQaGAhGIyGqeiu0dXvwdvqsuWkLvFk5zbBuS7/sKV3dg9mB7AIc1vFNVjdZQcUzLws/y9LzBt/QtHnVQWiC7Ih+zz3Bxh4pFw8dGgJUnC97cIFKUsM+fwuOmHm1Q6iIv7TIdMBZLmMRfB5zfA3jJKrtHDMzrLMcZzklMr9jRF9Ew82cG6gg5sWklFQVilKRCuP+RmxTy/OJmlG177e6q1tvPoB4oS4NzFsGJb16Bf35//0p1qgWkzL2vEc3vOGi8ILbVysFZ6tzX7FzLoG8stSxzpJ1YPIcoDtgpmE4pfXzHRPvoCjrsdMhlEbZHycEUGfxRfgzJWSXhtZq/RGPG9Jg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistentcy cannot be addressed without refactoring the API.

system_wq is a per-CPU worqueue, yet nothing in its name tells about that
CPU affinity constraint, which is very often not required by users.
Make it clear by adding a system_percpu_wq to all the mm subsystem.

The old wq will be kept for a few release cylces.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 mm/backing-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index e9f9fdcfe052..7e672424f928 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -966,7 +966,7 @@ static int __init cgwb_init(void)
 {
 	/*
 	 * There can be many concurrent release work items overwhelming
-	 * system_wq.  Put them in a separate wq and limit concurrency.
+	 * system_percpu_wq.  Put them in a separate wq and limit concurrency.
 	 * There's no point in executing many of these in parallel.
 	 */
 	cgwb_release_wq = alloc_workqueue("cgwb_release", 0, 1);
-- 
2.51.0


