Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8C35FF886F
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 01:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFA6E6B0093; Thu, 30 Apr 2026 21:37:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAAFA6B0092; Thu, 30 Apr 2026 21:37:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973336B0093; Thu, 30 Apr 2026 21:37:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 833A36B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:37:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 320741202A0
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:37:46 +0000 (UTC)
X-FDA: 84717139332.10.3DFD650
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5780AA000A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:37:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bCUD+SqU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777599464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tXkZizzlIjDaETBBA0ZOQ5z2LGXYcLfPd8nsRMFv+WU=;
	b=I9qWohWoVo01G8D87V+agN9Hxwh+VxeirkXan3OQ0QSVUQv1b7M+RtFvXSsPB+jxGdb34Q
	flPLGcmrbUvhQFer3nxEr5rnxa3AXghKgEO+GFrW8gutul6+27tFtmLJwBTC9ESYBHaup1
	nDFFZT26sjH5RWEabUfntOB4RUnwP0I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777599464; a=rsa-sha256;
	cv=none;
	b=QR/l9I+267QkiPoatEC5XYgaMIWN3/i/u641s0hXDAoU5LV/ITa8MneOU0EHH23IroiUL6
	hYRdDc6sit1ZbaaQriCzsrk8Yokr4k8vU9YMa8lqizqowh0HURxwHLTUoQwYRN4Uf5bDH5
	RmIhuoCBQxVXH264vNV9gJ3dVaoEN+s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bCUD+SqU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c70e27e2b74so587762a12.0
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777599463; x=1778204263; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tXkZizzlIjDaETBBA0ZOQ5z2LGXYcLfPd8nsRMFv+WU=;
        b=bCUD+SqUODp63YsWKqvE9SAXlS2izwLIdtkWy/w2awvtbsrO3EmlhaDVfxVPssfzgp
         JecgNDuqa+USM3MQPfHNIlJPye9eRuh3HJfa/SLhJvXalmZf6DRQJeLqMmQavemWEs+0
         btJkRxiJ+MEtShCb3jA3YBbbo8/CByk3/RKSAwjVbDCvvrlDM6Bt8FCXp9VO8yEXipbc
         edp0YrDqM0pHdnGgzyYMRZjVI9ZYsfucC4tXfujwYRNqwoYIBl+1iv0zo9dmfUxiylAn
         2bntcRmK6uar5IP2Eh/yEoS8c2+aM4tmgpYqq1rLE8JK1TAk6VhmPJ9gDSQ+lE11m1oY
         s4Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777599463; x=1778204263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tXkZizzlIjDaETBBA0ZOQ5z2LGXYcLfPd8nsRMFv+WU=;
        b=Fl19jNQAynhnBZHEBSANam9LeZGJBqqS16QGjMd9ggSLX7XaqUu5is27b/92+2JYPY
         +QAvjaRIkLczU+f/2B1v9cvUuUp9ma/H73aMlZ6CAOdv77h/uLuazo/MKpjbVqyPBs/1
         RXFGanwIl6lnZBDKlm0Jvl7qIg8qk8OsTxbAB4OhpWbktwofQzz4Nzo5grkSzib4llNe
         QYdERlvrzkrMBbIeKCK/+0hVLRfAdgDnog5ncQvapUbLBcJ7h0EKBGvdehrz+LtyKXTX
         GgMFZEqqAxgXmnmtCwFzX+k2/O1HZpjH4Q0CvM46oL5HUeIszuX4zUNiu0d5jJ5/DOR2
         9c3g==
X-Forwarded-Encrypted: i=1; AFNElJ+Pdpov0pNDLNzk6uYaQe7TCyf+fDYqcbs/CdZnT/z4RO+m9dT094yxRp/QQV7hi90h7lRh6IrTIg==@kvack.org
X-Gm-Message-State: AOJu0Yx6iJsIpDTCgvAGIke1c2ocFTRjdM4I0BHEwGY2DYwtzyGA3yJF
	lgbXauFKjLbWXKk753gsWKp6oNXBDtLggHcb6ltS9iP3Cq+EQZgPCfp7
X-Gm-Gg: AeBDietzBwFyJCxx4eQLWhHilwKX5ctymI6asq8DlirFFVQjkWNfKjZ2tiConHJ2U+l
	Fi6hYe84TfBrWyWU6uSNoPgxANztDldRktd0HjVZwyAhhzhTfbiICigsRmYDdlQGo9OCjbsprrG
	ArAUWdy7ukZri0ZC6yDwRr33cKSEQiCnkHGkAxZrFkcv7+sCsLtOrhZZuEbTrY6/rBzp2/K8Sqf
	hQtM6gAGtdy7xUH8a07ytC0bzi7WQDggvShzZwf8xhUVrXco+w+dbZZdKS8/sS5CS0Rlx5V5Sbx
	Ylq5Ga0jbYmFpnso6/l7wIMtStq4jXRtKlJph7qeSVwsMtvI0PwDWb0QlsHnPopm1a3w00v0Z59
	/Nqy8IRYbnHzt0PwMiVk0araacq77EaIAseAQk/0RPWXhWDCPYjdvNZLtGTb+UQegtPhobeBnnZ
	on22g8rfoaWpveD5pb/4sToIu7Hi5IViNLCNNWXhx5YaS6zghPVaEGguEhsR21
X-Received: by 2002:a05:6a00:330b:b0:82f:6a64:deac with SMTP id d2e1a72fcca58-834fe1bf650mr6747969b3a.28.1777599463184;
        Thu, 30 Apr 2026 18:37:43 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:8f3:e8d0:1478:fdf:dfb3:daec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83515b02935sm956318b3a.41.2026.04.30.18.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 18:37:42 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH v5 2/2] mm/damon/reclaim: validate min_region_size to be power of 2
Date: Fri,  1 May 2026 09:37:50 +0800
Message-ID: <20260501013750.71704-3-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260501013750.71704-1-aethernet65535@gmail.com>
References: <20260501013750.71704-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5780AA000A
X-Stat-Signature: 8j84ohxoftkk4w1kkudqz4d46ocxqp3e
X-Rspam-User: 
X-HE-Tag: 1777599464-366471
X-HE-Meta: U2FsdGVkX19tgSVcSaHPp/cvyAvewBLWokpEHjyxOZgVGnq501B2WBLriPWmbqFJyWBDz0gShMFtipnqsdNf6lVNN1x368kAeHKl/L332egVgUG57ziRGb9h7racSXGpn8kCnOMu8rJkyqjKP3j0iqRovjwKThmyhuZcC40ZYEjhrFE02XbKyV0WwnZ7bF0UrXUK5GWnD0ESo1covNXm7vpIndgpSzT1JPZ48yyUxYkjo+wvCg9ceKV4txp0ngIzrzUWz5T2zIy9IX5AXIlJWOnR64Y88HWX5ra+V/QlG27Hj266s7iElPtH/TmjtATh6ttRYoi63dTKgfEhFDhAbk/pXYBkVH53Qm9Hnwv2W+hczyeYUA8EOBpT21cfahKjKL3xbTtSEPW3wJZ4XbwIOTex3PzscxXtT5U6sGEWHXN2mz4TXwPXWCujGDaLz/YYtixF5wq0/j2zBsEhZEaofBSL0nWbYJVbSKvO3CIAWhh15rhkeaKjQy3cyiD09FaGtyYU/cBYHB6mXM4bKmrKckG91sw+RNRQYtyFjgpScev5800pxZpl34/6d7IfMXwQSLXoZVMzvdq5ph1FKm2Aq3HYy3fm3o2I/s3c01aHU8Y4KDrU0TxVdGgI6EBbHkORWRMVC0I8fVGGcXYkfmEdGZ3el4LLC7G7fm1RO7rKRykLUj0e9mhpZkDaFY4MNNpiqirUH6mN6QJmKlnAdbOxySaCwt4hBx9noSlPBmnBxSDJOv024wswpImCObLWGPWLMWWh8MP/N/YHr3CXYtKqoOKdp4dyIaf7Yj+qWTUDAAzgD0Er0Efisq6XqqMQi4MvSI6RljCLNu7g69JZ9WWjf4mOE2hZ6ZlM+hxSULQlYkglLed+qzqKrYi13pF+ucJOxbrIJxlr79Liiazyuxsrwj6bV5JvjwAyycs6LXMeCW3Tv79da8o8VoT7Pm/IY7FmhWfH3wM02Rge8nvVu9x
 8AZe9WFy
 +eyQYxE892g9zRi38UVgl4VB7A98Sc20/9Z42IhuOEw9LHWVjeYtA2GdvZMLRxE3xYMAIYPB42OaSskhc3XXChjbZg+V6QceAaARBEVsJvSdmzAnkdTYj9H1f5aEzfkO6thJ5TP8NuvFrt/UDg7CmttwHtfiObpjlRRmmn/Dmk7CFA3Js+P5d4C6/slyQ+HTwLHBrNy8Ex4/3ZgkiEl3d5srAxyLDV95AOnwnT0KRETAFQicsIcr+lwt9f202Ioa9RiyY80xBztzGhYYmXq448P9iWYObgF+9TS4bkT4ubaFkILx8ZbMkmfx8ufA6VO1UOm1ONdY0E7rLDPruMmRyvy7z2TZH5vM9LY3CSyN7gVhSighWiQswrE2lFs8d8VZ8HuqAw8rp174/pZ8jEAXhpxwtpGt9ZLR7flCOVZpFp9mUJA8pGpm2tQS2QhhzQ6YEO9cFj/hzsItp0QWmk79rudNptQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
=======
When a user sets an invalid 'addr_unit' (e.g., 3) via DAMON_RECLAIM,
'min_region_sz' becomes a non-power-of-2 value. While damon_commit_ctx()
correctly detects this and returns -EINVAL, it sets the
'maybe_corrupted' flag during this process.

This flag causes the running kdamond to terminate. While the termination
is a safety measure, it is suboptimal in this case because the error is
just a simple invalid input from the user, which shouldn't neccessitate
stopping the kdamond.

Reproduction
============
1. Enable DAMON_RECLAIM
2. Set addr_unit=3
3. Commit inputs via 'commit_inputs'
4. Observe kdamond termination

Solution
========
Add an early validation in damon_reclaim_apply_parameters() to check
'min_region_sz' before any state change occurs. If it is non-power-of-2,
return -EINVAL immediately, preventing 'maybe_corrupted' from being set.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 mm/damon/reclaim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 86da14778658..2747eef5919d 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -204,6 +204,11 @@ static int damon_reclaim_apply_parameters(void)
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
+	if (!is_power_of_2(param_ctx->min_region_sz)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (!damon_reclaim_mon_attrs.aggr_interval) {
 		err = -EINVAL;
 		goto out;
-- 
2.53.0


